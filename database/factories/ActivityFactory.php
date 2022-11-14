<?php

namespace Database\Factories;

use Illuminate\Database\Eloquent\Factories\Factory;
use Illuminate\Support\Str;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Activity>
 */
class ActivityFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition()
    {
        return [
            'user' => 1,
            'ipAddress' => fake()->ipv4(),
            'userAgent' => fake()->userAgent(),
            'action' => 'forgotten_password',
            'message' => 'Test Message',
        ];
    }
}
