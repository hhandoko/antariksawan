package com.hhandoko.antariksawan.controllers;

import io.micronaut.http.HttpResponse;
import io.micronaut.http.annotation.Controller;
import io.micronaut.http.annotation.Get;
import io.micronaut.http.annotation.Produces;
import io.micronaut.views.View;

import static io.micronaut.core.util.CollectionUtils.mapOf;
import static io.micronaut.http.MediaType.TEXT_HTML;

@Controller("/")
public class HomeController {

    @Get("/")
    @Produces(TEXT_HTML)
    @View("index")
    public HttpResponse<?> index() {
        return HttpResponse.ok(mapOf("name", "You"));
    }
}
