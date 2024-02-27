package main

import (
	"fmt"
	"strings"

	"github.com/gofiber/fiber/v2"
)

type User struct {
	Name string `json:"name" validate:"required,min=5,max=20"` // Required field, min 5 char long max 20
	Age  int    `json:"age" validate:"required,teener"`        // Required field, and client needs to implement our 'teener' tag format which we'll see later
}

func Greet(c *fiber.Ctx) error {
	var body User
	if err := c.BodyParser(&body); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"status": fiber.StatusBadRequest, "message": "failed to parse the request body", "error": fmt.Sprint(err)})
	}

	if errs := myValidator.Validate(body); len(errs) > 0 && errs[0].Error {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"status": fiber.ErrBadRequest.Code, "message": "failed in validation", "error": errs})
	}

	return c.Status(fiber.StatusOK).JSON(fiber.Map{
		"status":  fiber.StatusOK,
		"message": "hey, greetings from the server to " + body.Name,
	})
}

func Validate(c *fiber.Ctx) error {
	user := &User{
		Name: c.Query("name"),
		Age:  c.QueryInt("age"),
	}

	// Validation
	if errs := myValidator.Validate(user); len(errs) > 0 && errs[0].Error {
		errMsgs := make([]string, 0)

		for _, err := range errs {
			errMsgs = append(errMsgs, fmt.Sprintf(
				"[%s]: '%v' | Needs to implement '%s'",
				err.FailedField,
				err.Value,
				err.Tag,
			))
		}

		return &fiber.Error{
			Code:    fiber.ErrBadRequest.Code,
			Message: strings.Join(errMsgs, " and "),
		}
	}

	// Logic, validated with success
	return c.SendString("Hello, World!")
}
