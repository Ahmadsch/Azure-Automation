package at.hcw.devopsdemoapp;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class DevOpsDemoAppApplication {

    public static void main(String[] args) {
        SpringApplication.run(DevOpsDemoAppApplication.class, args);
    }

    @GetMapping("/")
    public Map<String, String> root() {
        return Map.of("app", "spring-aca", "status", "ok");
    }

    @GetMapping("/health")
    public String health() {
        return "ok";
    }

}
