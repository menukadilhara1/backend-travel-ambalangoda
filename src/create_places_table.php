<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up()
    {
        Schema::create('places', function (Blueprint $table) {
            $table->id();
            $table->string('name');
            $table->string('cat');
            $table->string('dist');
            $table->string('emoji');
            $table->string('bg');
            $table->decimal('lat', 10, 7);
            $table->decimal('lng', 10, 7);
            $table->text('desc');
            $table->string('hours');
            $table->string('fee');
            $table->string('transport');
            $table->string('season');
            $table->timestamps();
        });
    }

    public function down()
    {
        Schema::dropIfExists('places');
    }
};
