Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA728A41
	for <kvmarm@lists.linux.dev>; Mon,  4 Dec 2023 03:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Ma291zuT"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-6ce32821a53so269126b3a.0
        for <kvmarm@lists.linux.dev>; Sun, 03 Dec 2023 19:01:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1701658912; x=1702263712; darn=lists.linux.dev;
        h=mime-version:message-id:date:in-reply-to:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date:message-id:reply-to;
        bh=CQYiiiRLontcDI44whmeD/LoEJVxuqfkBiryqv/zBTg=;
        b=Ma291zuT9Zhjq5f5nlMg2UIpKvkZ/+51ExY58xLrtul/qQ1zxB6pMVmLzmadFlgs2H
         R/DmlgiJ5Urc82X5tL/k+Runu6vUzAyv+AYtCrQAiejk+QpaE8mP4rWL8Kq3WuDA1oy1
         q3AK9ELV/QQGwYkpy9UiHECZPx0rBi1Y68d7MPouLj0jncrPi7rLIIPA/ulNO7+Eiiv4
         CWsxsw4UNepKjaO04zTVjgKht9hFx8s7SMiIv200mselBpotoAeZyuP+t/2g6nAfIe3J
         8H4kVueLvbiV7tTOTxdOxLWbSTgc3kQ+7ZIfLnlLWhZ5G02V4GUJNd8MmRRVXBAQ55wO
         vV4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701658912; x=1702263712;
        h=mime-version:message-id:date:in-reply-to:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CQYiiiRLontcDI44whmeD/LoEJVxuqfkBiryqv/zBTg=;
        b=fnAUUwSoDmBPGxZbrEXdGwFk12kGYgJyw3oahPrSn4r/Dr2KgXZ+/KtiZ7Cmn3wCaS
         w3MLK0186CjSv7m4OgcB8u10Ba1nuRUCBUb3gOSlz/Epj2Ko2z1lL/k7NAMjgkYF20Do
         4vIYrhRQRxpjyrCqhxJ35Lno9PATx6vk3eWiIoftQ7lCn0CqdkXqNRvo7aOhbgpWk+jv
         i6fc6AfYCxDCbDoZHj9tVd7i5ZfLpki6S3yg1Cqsvr9s08hQCX1ehzMFENEXTkC5QS0q
         v9qf7YBXQuKuylysrAAp0fV+HWX2ikEhfKivtFtCXI+V5Lmdt6Slnb7k4rb93EddGxWj
         TrIQ==
X-Gm-Message-State: AOJu0Yy86uGRPAWCz8n4oCMHim7LWTVTdQnuL/z/VOYx2s5j8hSJhCBF
	n13Mo305Trqn1OKpagu57WDDUw==
X-Google-Smtp-Source: AGHT+IHFLJUBmtnWAvysao8TWHQlyk2Cfpox9jD8bkyNgUP4wKyxIxGZHkfjhvm//XUEUavLfPd53A==
X-Received: by 2002:a05:6a20:748f:b0:18c:8fef:22cc with SMTP id p15-20020a056a20748f00b0018c8fef22ccmr1035248pzd.24.1701658911982;
        Sun, 03 Dec 2023 19:01:51 -0800 (PST)
Received: from localhost ([2804:14d:7e39:8470:979a:226c:de55:73de])
        by smtp.gmail.com with ESMTPSA id c24-20020aa78818000000b006cd88728572sm6562301pfo.211.2023.12.03.19.01.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Dec 2023 19:01:51 -0800 (PST)
References: <20231122-arm64-gcs-v7-0-201c483bd775@kernel.org>
 <20231122-arm64-gcs-v7-13-201c483bd775@kernel.org>
User-agent: mu4e 1.10.8; emacs 29.1
From: Thiago Jung Bauermann <thiago.bauermann@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon
 <will@kernel.org>, Jonathan Corbet <corbet@lwn.net>, Andrew Morton
 <akpm@linux-foundation.org>, Marc Zyngier <maz@kernel.org>, Oliver Upton
 <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, Suzuki K
 Poulose <suzuki.poulose@arm.com>, Arnd Bergmann <arnd@arndb.de>, Oleg
 Nesterov <oleg@redhat.com>, Eric Biederman <ebiederm@xmission.com>, Kees
 Cook <keescook@chromium.org>, Shuah Khan <shuah@kernel.org>, "Rick P.
 Edgecombe" <rick.p.edgecombe@intel.com>, Deepak Gupta
 <debug@rivosinc.com>, Ard Biesheuvel <ardb@kernel.org>, Szabolcs Nagy
 <Szabolcs.Nagy@arm.com>, "H.J. Lu" <hjl.tools@gmail.com>, Paul Walmsley
 <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou
 <aou@eecs.berkeley.edu>, Florian Weimer <fweimer@redhat.com>, Christian
 Brauner <brauner@kernel.org>, linux-arm-kernel@lists.infradead.org,
 linux-doc@vger.kernel.org, kvmarm@lists.linux.dev,
 linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org
Subject: Re: [PATCH v7 13/39] arm64/mm: Map pages for guarded control stack
In-reply-to: <20231122-arm64-gcs-v7-13-201c483bd775@kernel.org>
Date: Mon, 04 Dec 2023 00:01:49 -0300
Message-ID: <87a5qqisbm.fsf@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain


Hello,

Mark Brown <broonie@kernel.org> writes:

> diff --git a/arch/arm64/mm/mmap.c b/arch/arm64/mm/mmap.c
> index 645fe60d000f..605d4e6edc1d 100644
> --- a/arch/arm64/mm/mmap.c
> +++ b/arch/arm64/mm/mmap.c
> @@ -79,9 +79,20 @@ arch_initcall(adjust_protection_map);
>  
>  pgprot_t vm_get_page_prot(unsigned long vm_flags)
>  {
> -	pteval_t prot = pgprot_val(protection_map[vm_flags &
> +	pteval_t prot;
> +
> +	/* If this is a GCS then only interpret VM_WRITE. */
> +	if (system_supports_gcs() && (vm_flags & VM_SHADOW_STACK)) {
> +		if (vm_flags & VM_WRITE)
> +			prot = _PAGE_GCS;
> +		else
> +			prot = _PAGE_GCS_RO;
> +	} else {
> +		prot = pgprot_val(protection_map[vm_flags &
>  				   (VM_READ|VM_WRITE|VM_EXEC|VM_SHARED)]);
> +	}
>  
> +	/* VM_ARM64_BTI on a GCS is rejected in arch_valdiate_flags() */

s/valdiate/validate/

>  	if (vm_flags & VM_ARM64_BTI)
>  		prot |= PTE_GP;


-- 
Thiago
