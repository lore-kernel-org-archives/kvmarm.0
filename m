Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C74D4200127;
	Thu, 19 Jun 2025 08:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750323327; cv=none; b=gP5pnXvH0ZLEv8OIxXLEWsSjNP2L0vVN7sefBMOVEmqRyOikXNjQmb4UI0HXMmGO6jmdYAHm5AuyjFmmdLklbiVA9hUhB+1hwnBfz+aXP1AJKxl3p6Hrvu+IRQUVca9sbP6a77qXr3phfCCL1rOMUP2upjYSRO42tPjnmwFSKBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750323327; c=relaxed/simple;
	bh=eQADuGSiL41NAxGl9NK+UhkSlVn0yTQBhyaUTND5Uzc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Zq6G1+jc8pgyEB9l1MCaz4RAd5w7fvyriFCKaYiy21ctwmh1fsMm1GNfV1u2C7xC/AIEuTvH6spd2GPu54epAB2IDE8zWXLs5YTPTEFtGVY91Oh2aY782AS9Y5yjue0wmAa/3bAXMrVq9znIdqb3rKZtX971nGkl9znbfE66ykA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p2FgroRg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p2FgroRg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77A63C4CEF8;
	Thu, 19 Jun 2025 08:55:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750323327;
	bh=eQADuGSiL41NAxGl9NK+UhkSlVn0yTQBhyaUTND5Uzc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=p2FgroRg8XpbJ/VSjtfLXHjJJRjKYpLj2XcaUHKG2xLQ7wfM+Z5n3rCjl6c8Zto5M
	 RSqSwjDobL8Uw3UNbEgelKH8UpaKTaToYX2CC3EHc2vsE2pdmJDyKlBWw+TMDnneAR
	 zMJQDoEg8twbtA3I11UyCenEImVZ9sO7oElSKq/lIdyVHdbSV7Rl1uy4I9OtVCIJ1L
	 xY4b7NmVNhx3/G6psbDY7j5hAeSUhrVg2Gh8rwAs7zI7pjkVGSiXnOiYqIeGf09brb
	 UZTFESwD6c+51mkUr6sZ7eCO2jWacLftMDJ3IO+VCTUTYL9SrpXOCd2q9ivlu3Pq39
	 P3TSZ4nA1tZBA==
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-60789b450ceso962777a12.2;
        Thu, 19 Jun 2025 01:55:27 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVhFvOx+E3BuRaPH6H/JYggp1BQzjmPpAfxN8jzfQjQdml8pqjmM3ntebXjtvJO8RN/eJcSWQ==@lists.linux.dev, AJvYcCWPMpPz3PpMhy6aw4aGqJvowaIyFeqxXXbZRUewKK1CxhOpZJvIzhMkWIjuHEELHA00+Wv9ziM=@lists.linux.dev
X-Gm-Message-State: AOJu0YwmFh8LchMgYwwq4d2fgjpAmzudnwchTlpzM5pLgj2aRyHONqLL
	/jpBALxb3uq4dlWjuS2FxE2GrJrMqTYwi3vMQ784e6wU5c3i20f9QXP7Q6qlSQSVOlz5AeKcJrY
	H+DsL5E3VgT8AxqlsEhsjBVh8vs7oBdA=
X-Google-Smtp-Source: AGHT+IFe63NPmdC9P72cDlyX2WP9si/cWhn+2uqDCCs1dQMO/+ouBJs4HCM0Kl1RCgdHuztVjrD3QGSEtvvPoh/cEAU=
X-Received: by 2002:a05:6402:50d2:b0:607:6057:9006 with SMTP id
 4fb4d7f45d1cf-608d08f7a70mr18716524a12.8.1750323325929; Thu, 19 Jun 2025
 01:55:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250523043251.it.550-kees@kernel.org> <20250523043935.2009972-9-kees@kernel.org>
In-Reply-To: <20250523043935.2009972-9-kees@kernel.org>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Thu, 19 Jun 2025 16:55:15 +0800
X-Gmail-Original-Message-ID: <CAAhV-H4rFt3J6hD-eiNN5nihNR0cwMxPJQpq8LQWkx4km428og@mail.gmail.com>
X-Gm-Features: AX0GCFtBM3K8OeK1JL3sld-cpEWi3kLQAET9w-cyksCMv2tJ5SCZdduevj4T0cU
Message-ID: <CAAhV-H4rFt3J6hD-eiNN5nihNR0cwMxPJQpq8LQWkx4km428og@mail.gmail.com>
Subject: Re: [PATCH v2 09/14] mips: Handle KCOV __init vs inline mismatches
To: Kees Cook <kees@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Thomas Bogendoerfer <tsbogend@alpha.franken.de>, linux-mips@vger.kernel.org, 
	"Gustavo A. R. Silva" <gustavoars@kernel.org>, Christoph Hellwig <hch@lst.de>, Marco Elver <elver@google.com>, 
	Andrey Konovalov <andreyknvl@gmail.com>, Andrey Ryabinin <ryabinin.a.a@gmail.com>, 
	Ard Biesheuvel <ardb@kernel.org>, Masahiro Yamada <masahiroy@kernel.org>, 
	Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nicolas.schier@linux.dev>, 
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, Bill Wendling <morbo@google.com>, 
	Justin Stitt <justinstitt@google.com>, linux-kernel@vger.kernel.org, x86@kernel.org, 
	kasan-dev@googlegroups.com, linux-doc@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
	linux-efi@vger.kernel.org, linux-hardening@vger.kernel.org, 
	linux-kbuild@vger.kernel.org, linux-security-module@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, sparclinux@vger.kernel.org, 
	llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi, Kees,

On Fri, May 23, 2025 at 12:41=E2=80=AFPM Kees Cook <kees@kernel.org> wrote:
>
> When KCOV is enabled all functions get instrumented, unless
> the __no_sanitize_coverage attribute is used. To prepare for
> __no_sanitize_coverage being applied to __init functions, we have to
> handle differences in how GCC's inline optimizations get resolved. For
> mips this requires forcing a function to be inline with __always_inline.
>
> Signed-off-by: Kees Cook <kees@kernel.org>
> ---
> Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
> Cc: <linux-mips@vger.kernel.org>
> ---
>  arch/mips/include/asm/time.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/mips/include/asm/time.h b/arch/mips/include/asm/time.h
> index e855a3611d92..044cff0e0764 100644
> --- a/arch/mips/include/asm/time.h
> +++ b/arch/mips/include/asm/time.h
> @@ -55,7 +55,7 @@ static inline int mips_clockevent_init(void)
>   */
>  extern int init_r4k_clocksource(void);
>
> -static inline int init_mips_clocksource(void)
> +static __always_inline int init_mips_clocksource(void)
Similar to x86 and arm, I prefer to mark it as __init rather than
__always_inline.

Huacai

>  {
>  #ifdef CONFIG_CSRC_R4K
>         return init_r4k_clocksource();
> --
> 2.34.1
>
>
