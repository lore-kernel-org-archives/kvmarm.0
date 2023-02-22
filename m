Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BC371105
	for <kvmarm@lists.linux.dev>; Wed, 22 Feb 2023 04:30:17 +0000 (UTC)
Received: by mail-pj1-f50.google.com with SMTP id x34so4043704pjj.0
        for <kvmarm@lists.linux.dev>; Tue, 21 Feb 2023 20:30:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=5i4ldczDQYuSG/1FXAxAWO2RItdkLbuSLSCwjoOZQas=;
        b=RvCSgLpRV8MIeD43Y5Si07PAj+VVGYhM/xxdS6X6HjXuhB+esvrc4TqEBztu+psTWF
         3RAck/24/L5h6vJT0IjYp+nNYSC4Dvw49olE4ZX/xshlB5RAuUp+qRbzIbtVlsr3N/Rb
         UKG6XQj7Dlv6E3cR6+5xJhyJIV/7e5kbytMqU2dZtZ7BaEd+ue4xzLDirNDmeWVIFczd
         +WyF6C2s3XtYeKUUU4Ooc/Zc3ghwmUB37+h8N04QV4xzXM4CmhjozC1ziwQLmQ3aq1cm
         mlNqA56/Ky8CIYq/g7CSMNCMXFxhBc+X0EX8suFwkNAkvxe+KHphHUfnfumMyxJSEfGa
         8jnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5i4ldczDQYuSG/1FXAxAWO2RItdkLbuSLSCwjoOZQas=;
        b=7QuksuXifhHI2Z4ypY1IY796I1lv0foEk7wYgZ5zCCg6wNIMM2afdduv6fNsAGRek7
         M/waIhcrBFbcew9uWsilIta/X9OkRJExOIY6pWZRlAu6MTR07OLcxmnjrdg7z2Ml94/M
         Zfa7BEU/YmS3VPhUFEy0jPU7QjFPvytHQ3DPEDgIDSIDN1agAbT7Mi8WHVDk/ufpmWOo
         USZ1pWjV421PRj9hm6TemtdvuDK8BMBONg4skiMkEAR5FrkXyL4/EnJmyph8UoNVNzRO
         0gOK8e4wxT2FFImvvRPyv7t3AjDNCXL0U/NrndmNs+5FCuvQmU9C6gxbtrNHw8r1GRPc
         fWwA==
X-Gm-Message-State: AO0yUKXr8vi4Yyt1A2xhn4ldUVpRZvh65okHb5iLDd6x5u9z3R+Um2R1
	tJaqjec1vuhleBtA6aDGElAbQBYMtFIV3CyZDQkQCg==
X-Google-Smtp-Source: AK7set8IwOqtf9Iqg5nsqLtHapf2xboF7aeB2Qj338HK5zISpBAYiHRU84sE/TIOasEXXX/xOKht6UwgpXQxVMstVPQ=
X-Received: by 2002:a17:90b:3904:b0:231:f52:ddec with SMTP id
 ob4-20020a17090b390400b002310f52ddecmr2370549pjb.91.1677040217088; Tue, 21
 Feb 2023 20:30:17 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230216142123.2638675-1-maz@kernel.org> <20230216142123.2638675-3-maz@kernel.org>
In-Reply-To: <20230216142123.2638675-3-maz@kernel.org>
From: Reiji Watanabe <reijiw@google.com>
Date: Tue, 21 Feb 2023 20:30:00 -0800
Message-ID: <CAAeT=FwB+ym5D8xOBEJPAgxoBsD3v_s9J=oP7AXZy3=G78ajow@mail.gmail.com>
Subject: Re: [PATCH 02/16] arm64: Add HAS_ECV_CNTPOFF capability
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Zenghui Yu <yuzenghui@huawei.com>, Ricardo Koller <ricarkol@google.com>, 
	Simon Veith <sveith@amazon.de>, dwmw2@infradead.org
Content-Type: text/plain; charset="UTF-8"

Hi Marc,

On Thu, Feb 16, 2023 at 6:21 AM Marc Zyngier <maz@kernel.org> wrote:
>
> Add the probing code for the FEAT_ECV variant that implements CNTPOFF_EL2.
> Why is it optional is a mystery, but let's try and detect it.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kernel/cpufeature.c | 11 +++++++++++
>  arch/arm64/tools/cpucaps       |  1 +
>  2 files changed, 12 insertions(+)
>
> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index 23bd2a926b74..36852f96898d 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -2186,6 +2186,17 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
>                 .sign = FTR_UNSIGNED,
>                 .min_field_value = 1,
>         },
> +       {
> +               .desc = "Enhanced Counter Virtualization (CNTPOFF)",
> +               .capability = ARM64_HAS_ECV_CNTPOFF,
> +               .type = ARM64_CPUCAP_SYSTEM_FEATURE,
> +               .matches = has_cpuid_feature,
> +               .sys_reg = SYS_ID_AA64MMFR0_EL1,
> +               .field_pos = ID_AA64MMFR0_EL1_ECV_SHIFT,
> +               .field_width = 4,
> +               .sign = FTR_UNSIGNED,
> +               .min_field_value = 2,

Nit: You might want to use ID_AA64MMFR0_EL1_ECV_CNTPOFF (instead of 2) ?

Reviewed-by: Reiji Watanabe <reijiw@google.com>

Thank you,
Reiji

> +       },
>  #ifdef CONFIG_ARM64_PAN
>         {
>                 .desc = "Privileged Access Never",
> diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
> index 82c7e579a8ba..6a26a4678406 100644
> --- a/arch/arm64/tools/cpucaps
> +++ b/arch/arm64/tools/cpucaps
> @@ -23,6 +23,7 @@ HAS_DCPOP
>  HAS_DIT
>  HAS_E0PD
>  HAS_ECV
> +HAS_ECV_CNTPOFF
>  HAS_EPAN
>  HAS_GENERIC_AUTH
>  HAS_GENERIC_AUTH_ARCH_QARMA3
> --
> 2.34.1
>
>
