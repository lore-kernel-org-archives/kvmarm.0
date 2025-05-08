Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C36F0225760
	for <kvmarm@lists.linux.dev>; Thu,  8 May 2025 12:23:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746707008; cv=none; b=RM2LH2P0vs3SZXdH87VhB+J3rP07kVvkZgHISxWyWJLC1xCjmsoF9f4Yd8cn/f011MjanMfCSdPP/VYH93YJ09gEvxMiDFxla8WKA1Rq/ukjflEp89qxC2GKJJrrP7KK3gyizX8jqoj0f0Ifb/k1706CnOLtSt3/dMe+EGqZ9XA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746707008; c=relaxed/simple;
	bh=n1DaNBSAbwSjqMNiKl3ZhnzGUtTOnVJb3kD0pUQSCf4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fL29eBfTKp2a7BxaAwKMVsuYmeaShsXpraKoVf/IYsnYdYPMzP7Nl0aX6wa8Ihv8mG0mnBMzpIcRjbV29+xr/60vIC5/cD5BNWBCNT3Ix5qgu5ax3PLEmStrfmiarhdLwesIfYjH88VGPjQsgbNLLq7mF3OnwOfKLIVbHjVh8nk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0p5Dg6hu; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0p5Dg6hu"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-22e09f57ed4so21938985ad.0
        for <kvmarm@lists.linux.dev>; Thu, 08 May 2025 05:23:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746707004; x=1747311804; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=YHzGR2TH3f5PkiaDuIeNupqLtaLoSxh32TBcttsiE58=;
        b=0p5Dg6huF5N2a1dQpdqXUiJF5o8s9FiHWh1WYwyc4Wu//c4qiydZQ9wfK1Oz1kkAYS
         ASN6jaY8GVS8IH47Q6RDyXKq994g6Mp7OwgKcgQ7C9sYZo0tfs1p/cB61MSNm2n+z+kS
         uF2jOfRvKZp8C/fyJbyaYivIs6eWMxYkJoBm744b1PsJZRrue7oQodE+A6OQHNsRFvQr
         xjIUaSJ3BDsMSWWBKT4kqezsvd9+t1nmbl9en276s2lWbCKFcNRs+EkxuaQqEj8du7XR
         zT4H6Ws9QAuiBpapfOChC9sWjf96ZWvm1Ucu7xpxOHtTILMxLCVT4W796VmCFa6uUxvv
         lpbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746707004; x=1747311804;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YHzGR2TH3f5PkiaDuIeNupqLtaLoSxh32TBcttsiE58=;
        b=JO37Kvyac8xXzZgHgiEyIKNg+1uxZEot8cZrFIgt2TOq3VxAeI2t4X5g+C9HQZZcFc
         7nTNcGCaRP/lU9dzPwiJxjb22ZVLtFrN3b1GLN8LtBprKeZxiQuUMuK0W3dilkSOmXEK
         NqS3q4A7LGyekIoP/U2WcgP96Xj0HN6h5iCPNApTK4WYfIVqWqFqa1zPIxggJuoR/0Xa
         cbONQXR/hpOAlL3ZP8xs+QngIJsLbFY/gw9OW69XwxQjuCbEVqFv+zSLkv933mktGtmM
         DNRVh+VQCQwCYbwrRy5PHVLw+aAk53Sf4BcjTrwlx+iEu+mjNcgbb3miife4D6/4f1BV
         JTAg==
X-Forwarded-Encrypted: i=1; AJvYcCXDL56ZeHAJpP9aGYThjtgYrThltcx/wUso/IRLLNRgbEvWoJcbVGtUzOVEz37WlxYd0NAEmtg=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz47vHK5PyKEY445UUArj+hPM1L5OzDk6uCILyBAZZcliW/UPZC
	afTxxwMLtc3yCe4qs4cPYroarw/MS9PJzqwcQW0g+mA4AkKXw0wmuk54YNxwB1T+WbcPkcEMIZn
	LOXnfPhSrI62kSIv3OXWGsOvDIa0WTTxugh1J
X-Gm-Gg: ASbGncsuXquam2KnvcgsQQV8lIuczPJEPs3m+WpzAOP1r+piCggye5monlnTNDNmbZd
	Az0Of9h81XIITUSAj05xWVwCl8qv50PvAMeuRGy6RD5ZceYiNTDTNDsPApBObkpS3zokFbs8FNA
	G4nbbYOqu65ZiGrQsYOPW8Erw+T7cC8FLlwC/wIMV0xJRjoZXCOADDFyYuh4XeBoU=
X-Google-Smtp-Source: AGHT+IGuazhS9joimxHTMGiamVK9GxUm2CRwvQi3+Gq6fqxsbfAnr7up4McbBtUROkgn62zEFRcy/K/C2EzHqfHG+xw=
X-Received: by 2002:a17:90b:4b8c:b0:2fa:1d9f:c80 with SMTP id
 98e67ed59e1d1-30adbf6d05amr4939913a91.17.1746707003520; Thu, 08 May 2025
 05:23:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250507180852.work.231-kees@kernel.org> <20250507181615.1947159-2-kees@kernel.org>
In-Reply-To: <20250507181615.1947159-2-kees@kernel.org>
From: Marco Elver <elver@google.com>
Date: Thu, 8 May 2025 14:22:47 +0200
X-Gm-Features: ATxdqUHttH2gHvJKzLvMz7fkEuSC2xFFktBrniyRJYj71k93n_Rm8LTTobDJ7fU
Message-ID: <CANpmjNPcYPvnQzMT3p+Vc2=EiEbR1WnykUEjuYc0bH2HOFi6HQ@mail.gmail.com>
Subject: Re: [PATCH 2/8] init.h: Disable sanitizer coverage for __init and __head
To: Kees Cook <kees@kernel.org>, Dmitry Vyukov <dvyukov@google.com>, 
	Alexander Potapenko <glider@google.com>, Aleksandr Nogikh <nogikh@google.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Andrey Konovalov <andreyknvl@gmail.com>, 
	Andrey Ryabinin <ryabinin.a.a@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>, 
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Hou Wenlong <houwenlong.hwl@antgroup.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Masahiro Yamada <masahiroy@kernel.org>, 
	"Peter Zijlstra (Intel)" <peterz@infradead.org>, Luis Chamberlain <mcgrof@kernel.org>, 
	Sami Tolvanen <samitolvanen@google.com>, Christophe Leroy <christophe.leroy@csgroup.eu>, 
	kasan-dev@googlegroups.com, "Gustavo A. R. Silva" <gustavoars@kernel.org>, 
	Christoph Hellwig <hch@lst.de>, Nathan Chancellor <nathan@kernel.org>, 
	Nicolas Schier <nicolas.schier@linux.dev>, 
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, Bill Wendling <morbo@google.com>, 
	Justin Stitt <justinstitt@google.com>, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-riscv@lists.infradead.org, 
	linux-s390@vger.kernel.org, linux-efi@vger.kernel.org, 
	linux-hardening@vger.kernel.org, linux-kbuild@vger.kernel.org, 
	linux-security-module@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	sparclinux@vger.kernel.org, llvm@lists.linux.dev, 
	syzkaller <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"

+Cc KCOV maintainers

On Wed, 7 May 2025 at 20:16, Kees Cook <kees@kernel.org> wrote:
>
> While __noinstr already contained __no_sanitize_coverage, it needs to
> be added to __init and __head section markings to support the Clang
> implementation of CONFIG_STACKLEAK. This is to make sure the stack depth
> tracking callback is not executed in unsupported contexts.
>
> The other sanitizer coverage options (trace-pc and trace-cmp) aren't
> needed in __head nor __init either ("We are interested in code coverage
> as a function of a syscall inputs"[1]), so this appears safe to disable
> for them as well.

@ Dmitry, Aleksandr - Will this produce some unwanted side-effects for
syzbot? I also think it's safe, but just double checking.

> Link: https://web.git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/kernel/kcov.c?h=v6.14#n179 [1]
> Signed-off-by: Kees Cook <kees@kernel.org>

Acked-by: Marco Elver <elver@google.com>

> ---
> Cc: Marco Elver <elver@google.com>
> Cc: Andrey Konovalov <andreyknvl@gmail.com>
> Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: <x86@kernel.org>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Ard Biesheuvel <ardb@kernel.org>
> Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> Cc: Hou Wenlong <houwenlong.hwl@antgroup.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Masahiro Yamada <masahiroy@kernel.org>
> Cc: "Peter Zijlstra (Intel)" <peterz@infradead.org>
> Cc: Luis Chamberlain <mcgrof@kernel.org>
> Cc: Sami Tolvanen <samitolvanen@google.com>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
> Cc: <kasan-dev@googlegroups.com>
> ---
>  arch/x86/include/asm/init.h | 2 +-
>  include/linux/init.h        | 4 +++-
>  2 files changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/include/asm/init.h b/arch/x86/include/asm/init.h
> index 8b1b1abcef15..6bfdaeddbae8 100644
> --- a/arch/x86/include/asm/init.h
> +++ b/arch/x86/include/asm/init.h
> @@ -5,7 +5,7 @@
>  #if defined(CONFIG_CC_IS_CLANG) && CONFIG_CLANG_VERSION < 170000
>  #define __head __section(".head.text") __no_sanitize_undefined __no_stack_protector
>  #else
> -#define __head __section(".head.text") __no_sanitize_undefined
> +#define __head __section(".head.text") __no_sanitize_undefined __no_sanitize_coverage
>  #endif
>
>  struct x86_mapping_info {
> diff --git a/include/linux/init.h b/include/linux/init.h
> index ee1309473bc6..c65a050d52a7 100644
> --- a/include/linux/init.h
> +++ b/include/linux/init.h
> @@ -49,7 +49,9 @@
>
>  /* These are for everybody (although not all archs will actually
>     discard it in modules) */
> -#define __init         __section(".init.text") __cold  __latent_entropy __noinitretpoline
> +#define __init         __section(".init.text") __cold __latent_entropy \
> +                                               __noinitretpoline       \
> +                                               __no_sanitize_coverage
>  #define __initdata     __section(".init.data")
>  #define __initconst    __section(".init.rodata")
>  #define __exitdata     __section(".exit.data")
> --
> 2.34.1
>
