Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2C10200C82
	for <kvmarm@lists.linux.dev>; Tue, 12 Nov 2024 15:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731426108; cv=none; b=lYnFD9+jmwNXf3bsZXz1gc8CG18WK+px78uA6/tSeNyFEKf6HdB+cvLdPewzgAieTf370X81CnLCbHbxN34GJOyEHMic5yLKWrKafyYGPM1qjhbD0hgAW86zz8kKBL2QOy4S8hbDg3KOWRofCB/uejoKHQApDGGaYvztsU0Q+u4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731426108; c=relaxed/simple;
	bh=xgNKwdx8fbeGP/sL5jmeeV58ujRWHOcZVehMXSMJrkA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KExy1L6YjZfeXk6wXNmfb3DIkVUEYUOiY+j9E6RJgHn1pAsxqxv+sllkTRN2lDpB7KU6YWxEC0dCeAO9O9hhxrDr8StSme2SenwpEavnlltlHKiV7rxBNvC8smDevL9VfdopjBue5G8K0q66PW01te+gapbLfCQHcHW03SADAwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RKOY3zba; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RKOY3zba"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-5c947c00f26so13608a12.1
        for <kvmarm@lists.linux.dev>; Tue, 12 Nov 2024 07:41:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1731426105; x=1732030905; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=bkZf0dAyKpaV6oeL97qMQayHnuJCrWyOMGk6lUpa8dI=;
        b=RKOY3zbakRXF1AdgcdEhgxNWUD1mvciCvTTk4QM4HKdgHanhburQ8MqBKLxTQHZNne
         T+zispxPYvkTHvUWMBfjr32D5UwMDrnvIe0gVzJl0MRje2JQnXFsuBiiMnpDRw/w5Ze9
         gqkrHmVROiyP66pETgyZ9GoWy2I91a7Tg0w7lvhgmd1qYpXjSy2VsGGSw/iSLdUYtiQZ
         TGav/IUG7MMWWupiH1Y1psS+ZBd6uFlVNdg7mAI2p/nY0F0fcRkTQWIu9Xlhg+NAXMgi
         3zUjsNqtzaySz0ZcyaJVM7ocPj8x6dPGaEkCCKRHm1NxqbJxszcFAg40TY7RleYw9yTv
         G0YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731426105; x=1732030905;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bkZf0dAyKpaV6oeL97qMQayHnuJCrWyOMGk6lUpa8dI=;
        b=CgWGLKkGnTlWNBfS6M4nr7LXpVVvhs13ORVGinWupuCqBgueJNrtvlxkT2FhfQ6uJ6
         hmQCrRXzQ4+pEYRYhdpX+v8FOrGmRh6+qwWGDkgfnP4a6K2aReeTmTL64pcGk2arbi80
         3YTZAivdnpxafL/hl/fpUnONHBtw4fHs1fHHB8tUSo4zDIFw7C2htZWZoSx8/z9B+wvB
         1Vckzyykd+QRCwuDqBf8FGFSm2U9Vgn8XB+rdtqXKn1CzlN3tCqZxNoIgLtPTwgBmYYd
         QdGrsbtVdbnuYkf407XT7Zrsn48T6NbLN3LjKB92vIBSncofLdLsj21Pqe7qDg7BUQRA
         d2Yw==
X-Forwarded-Encrypted: i=1; AJvYcCWjBHOWZwiWvw7kBSJO5W4WsjvhlL6An4I+NW7KwCm0b0JOo5/8M8RtRE1a+YsTgxziYozLeZ4=@lists.linux.dev
X-Gm-Message-State: AOJu0YzYMMTfIuEgkopX1AX+3PF01LsKEhMdsmE3o376q0Z4ETB524dK
	agW6pJjRSY3rnWT/k2Jo3jqyeyI5KJUD4YGWjFL14dYDUnCjY6Y76bFYE9XSDNWbVS8rGZ3I/u9
	ehWES9c/wRcYvaEvkLVlP9qTyxMKe2A1W1sZK
X-Gm-Gg: ASbGncuvcCBF6Cki0ECS6rFh5mT9AW90gsNnCgQZc9Mb17JRVN3JaybokU2J4DMpxbu
	dxOGXwISxlb2Jd9nxPNLfOLFOnL7iSK5hdeSU3Qvm2cMpYErctrWtQgw6OFIe
X-Google-Smtp-Source: AGHT+IGKGj3m0K6cw27EtgaGcbRERBtnwAgADHveQ1xpIh6tli+bg/P/um8bA7UFcXQB7YKvR9KUq5R8xprHojQBtMg=
X-Received: by 2002:a05:6402:234b:b0:5cf:4994:501d with SMTP id
 4fb4d7f45d1cf-5cf5234185emr287895a12.3.1731426105003; Tue, 12 Nov 2024
 07:41:45 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241112105604.795809-1-james.clark@linaro.org>
In-Reply-To: <20241112105604.795809-1-james.clark@linaro.org>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 12 Nov 2024 15:41:08 +0000
Message-ID: <CA+EHjTyPc5o3T1jQY8VY+W5qtneiKw5wVMVhuSif2ZVs3S=ChA@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: Pass on SVE mapping failures
To: James Clark <james.clark@linaro.org>
Cc: maz@kernel.org, kvmarm@lists.linux.dev, oliver.upton@linux.dev, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, =?UTF-8?Q?Pierre=2DCl=C3=A9ment_Tosi?= <ptosi@google.com>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 12 Nov 2024 at 10:56, James Clark <james.clark@linaro.org> wrote:
>
> This function can fail but its return value isn't passed onto the
> caller. Presumably this could result in a broken state.
>
> Fixes: 66d5b53e20a6 ("KVM: arm64: Allocate memory mapped at hyp for host sve state in pKVM")
> Signed-off-by: James Clark <james.clark@linaro.org>
> ---
>  arch/arm64/kvm/hyp/nvhe/setup.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
> index 8fec099c2775..cbdd18cd3f98 100644
> --- a/arch/arm64/kvm/hyp/nvhe/setup.c
> +++ b/arch/arm64/kvm/hyp/nvhe/setup.c
> @@ -146,8 +146,7 @@ static int recreate_hyp_mappings(phys_addr_t phys, unsigned long size,
>                         return ret;
>         }
>
> -       pkvm_create_host_sve_mappings();
> -       return 0;
> +       return pkvm_create_host_sve_mappings();
>  }

Reviewed-by: Fuad Tabba <tabba@google.com>

Thanks,
/fuad

>
>  static void update_nvhe_init_params(void)
> --
> 2.34.1
>
