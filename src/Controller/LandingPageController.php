<?php declare(strict_types=1);

namespace App\Controller;

use Symfony\Component\HttpFoundation\Response;
use Twig\Environment;

class LandingPageController
{
    /**
     * @var Environment
     */
    private $templating;

    public function __construct(Environment $templating)
    {
        $this->templating = $templating;
    }

    public function home(): Response
    {
        return new Response(
            $this->templating->render('landing-page/home.html.twig')
        );
    }
}
