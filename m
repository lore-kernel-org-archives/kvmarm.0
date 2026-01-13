Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80E31288522
	for <kvmarm@lists.linux.dev>; Tue, 13 Jan 2026 14:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.176
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768314611; cv=pass; b=ruGN48xIN90bI4PJrmeVYBa3fO+VdrH3IeW5rtN3XijCShzUdLtUEAlDHsYoNcP4wioVyREALT5YXpFZiJevAPSkw+a2wCUxCbKOkw2UNKKxX8CvjFcpAG0h30tPU5N0iD065v6VrxxPtewGLI8bP37JUbpba3DYYjUhqwZKO78=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768314611; c=relaxed/simple;
	bh=G5FodbqLvXK9tpyH66xlaj/l47vKj19iBm8mD+95DeI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Tbz66KWCsjwCKC9NS5ZrJ2/Nkc4smgyrHvg+bWRGst+Zt8EJaZ0wQPQAmejQDsQEn3tCsGBAeXPbcWbW3N22ROOnH8hyzMscDljFM/NXd3tta28r9FsyGqoABsknuXl632+Je7TTzlKJOuV97pQOLbCWwel3uYvM1PRhKTtD/IQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=u99lpXRV; arc=pass smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="u99lpXRV"
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-4ee243b98caso450501cf.1
        for <kvmarm@lists.linux.dev>; Tue, 13 Jan 2026 06:30:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768314607; cv=none;
        d=google.com; s=arc-20240605;
        b=eQ4uT+T/V3NYspa/JE9igflyl8BB8rLijQ/1zQygRA14DVubmVazYILydJdJ1rZNBq
         RIFYwsQLQwWwydbcNRca10d2BSK+jjkaWqCssPmu9g4PnVItcINBwpsKbqyVpI1BsZTp
         0THKjXK9sV55oIESxbeTtDDVGFVYQed81BTXOeoKGse9yy0rQcW/hYpkCZDTJE+mPuIM
         FbtMHi54LjWfEzjlR3h6TchINCo0YEhBLbL++gHvm/mvIRlKd3mlYiwxiBeyHLDug0a6
         eQS459NPRVpWJccPtGRQV+BAXkVuxMGJzn01P3svfOYqXS3OKa3JmRjKwmQ2n2s1+6K6
         kABg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=b091E81/2unB3PJIE3JLMImmryguifLfk5JsrT4l5/A=;
        fh=FDY9KpOBxIRlg9URhvVT6BYFPB3FaqvLOW6IrUsz++0=;
        b=jrs0jYpEcC7of+CaNqImBFCBZdllBVG/SuzzVNfd54C7fevLr8ra9AZIVotkTLpnw7
         el51yofTP0Vb6hZl8TLuIr5UpufLu9bCVpgkerMGNs6z1VAIhoJ6c46W1uNCK+dqwK9x
         VO75avPPtQhNXv2SNf2h8L2Zn5fS3ySQN98RxsQR9xxPmtJgWvfXVFFNPOuSfr/MUBGW
         wSo01xL0b4N1kuP00iA4vCVhAPz2PN7gWIzfE0f0nxN3iyeiCVj7yrEi4uan3tmkxlDi
         DCK/DaOv5I0JSkaRnpfgXqdccx5AWEd12koe/TGyXgmjxMZgKBA64Sggd8nj9rUm41TG
         6t5g==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768314607; x=1768919407; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=b091E81/2unB3PJIE3JLMImmryguifLfk5JsrT4l5/A=;
        b=u99lpXRVaBX6c9KzA1XjMECC1i5ktae4ZYfHjTufyyJo1BaUM1/v4uOp/xCe/rnqDM
         XQkV/b7q7IjruhoN/plxO6NRxaADQ4IfQ7SdsiZy8O2QnuMhroqDUNJWNYEK7peUK+P9
         oukJxOtDvOCMY8Qs0vmmOF84XV2nRULcMXKT5TzxwxQGyVQbq77zt3mgk0bTm1gS8w9o
         GQU+gLdlygXY+9iGUFK8NX5xGwi0ftbjkfyX3O7Q8D7DH2FI5PH/Tjhg4gt9fajgnb8r
         X/QDecfEWyiAdCIVCSl1Ep8QtCy7KH3Bqa6UpG1P0bLNvOJSacV0TpC2gCOJSUUc74G6
         ye5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768314607; x=1768919407;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b091E81/2unB3PJIE3JLMImmryguifLfk5JsrT4l5/A=;
        b=Xk8DZphPw05378CVtQK6VDZwYxfZLomfBjctyOgqfajfzo50OntJwh3gfga12NDvD2
         p5382R9GCPtvH8bEo+z1nkhO/rQdwgQsMhEJtKlUpb1ejb9Rv4taOIl/cSzwYWA/cxOM
         QIaX3isQw6ktlF9uEaeZ0ISvICMfZA7Hj/DUYrdy1vsehnkb+2eS8L9L1VN/wIZjjIUV
         bolMPXx6LYeFYH6GrPwtsp1ObP883aKtqRD9/W3WhDNnOVbkca5Cc0uCk4kPZuQKToQL
         qertErNowU+H8ee8PrCpoI14m/EOVgX9wN3e1nrwGInEHOF+TwFWIDhN4e1qj5HkIFjG
         9ZBg==
X-Forwarded-Encrypted: i=1; AJvYcCXUlq6QobeSe01EYeQ8eCKQg8hoHGj3Yr56o9pbDog8fX099Xnn10GO5EVxLeX0kC4mBT+C0h4=@lists.linux.dev
X-Gm-Message-State: AOJu0YxXJXO3o0XJV5Smjvng7abdvdGeIRC59ezSlb7OzZpyDHY3q5Q3
	oZId1hWvnFYjQUQaoUBPDH6flcahm5+7TkpqJTJa6WieU7nCvFYisVuMhjtctemkInAvZO9Sjzy
	ZFR2+N0h9FPU71Y73WyLkW/MEwHY+4gApHys2B5jy
X-Gm-Gg: AY/fxX67xmMfdtRYwmG2ElROc3KMRQCXBu4xWOOoIn+9K3aB7bbeYs6qbejYqm5CWOs
	qVQQ7LICz0txPDr6MhbuOEyI51cqPoOP/JSj7VAlqJXfxxQkWPLF5l2ic7txT0otLl+7XbhEWoK
	/odecA2igEfIHwN8LBDWU9SCm4j3SY9ZEiHnTBadha2/RKwWzxYFOLNuef5BEwbWGMOYlPY9fIe
	oKmuzTbmTrCTdHxOqwBfP4+2W3enky4GzYzUfgAAjvfpQj6p4cWZrXao1A/hPt7fNnT1SMKVEqF
	U3MzGew02IAWw6ZvCwt0rvkOYQ==
X-Received: by 2002:ac8:5ad4:0:b0:4f1:83e4:73be with SMTP id
 d75a77b69052e-5013b23e77amr10218591cf.15.1768314606872; Tue, 13 Jan 2026
 06:30:06 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251223-kvm-arm64-sme-v9-0-8be3867cb883@kernel.org> <20251223-kvm-arm64-sme-v9-24-8be3867cb883@kernel.org>
In-Reply-To: <20251223-kvm-arm64-sme-v9-24-8be3867cb883@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 13 Jan 2026 14:29:30 +0000
X-Gm-Features: AZwV_Qi1BQ7vCKiwPSasBf7ZnHIRAUGyzNDOshXruUEpESYhIak7mxGtl8xsYqo
Message-ID: <CA+EHjTyL5gFQ8osKHaXQHa6327-HBJ4wvn6G2isDY3og4tCBKw@mail.gmail.com>
Subject: Re: [PATCH v9 24/30] KVM: arm64: Handle SME exceptions
To: Mark Brown <broonie@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <shuah@kernel.org>, Oliver Upton <oupton@kernel.org>, Dave Martin <Dave.Martin@arm.com>, 
	Mark Rutland <mark.rutland@arm.com>, Ben Horgan <ben.horgan@arm.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Peter Maydell <peter.maydell@linaro.org>, 
	Eric Auger <eric.auger@redhat.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, 23 Dec 2025 at 01:23, Mark Brown <broonie@kernel.org> wrote:
>
> The access control for SME follows the same structure as for the base FP
> and SVE extensions, with control being via CPACR_ELx.SMEN and CPTR_EL2.TSM
> mirroring the equivalent FPSIMD and SVE controls in those registers. Add
> handling for these controls and exceptions mirroring the existing handling
> for FPSIMD and SVE.
>
> Signed-off-by: Mark Brown <broonie@kernel.org>

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad



> ---
>  arch/arm64/kvm/handle_exit.c            | 14 ++++++++++++++
>  arch/arm64/kvm/hyp/include/hyp/switch.h | 11 ++++++-----
>  arch/arm64/kvm/hyp/nvhe/switch.c        |  4 +++-
>  arch/arm64/kvm/hyp/vhe/switch.c         | 17 ++++++++++++-----
>  4 files changed, 35 insertions(+), 11 deletions(-)
>
> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> index cc7d5d1709cb..1e54d5d722e4 100644
> --- a/arch/arm64/kvm/handle_exit.c
> +++ b/arch/arm64/kvm/handle_exit.c
> @@ -237,6 +237,19 @@ static int handle_sve(struct kvm_vcpu *vcpu)
>         return 1;
>  }
>
> +/*
> + * Guest access to SME registers should be routed to this handler only
> + * when the system doesn't support SME.
> + */
> +static int handle_sme(struct kvm_vcpu *vcpu)
> +{
> +       if (guest_hyp_sme_traps_enabled(vcpu))
> +               return kvm_inject_nested_sync(vcpu, kvm_vcpu_get_esr(vcpu));
> +
> +       kvm_inject_undefined(vcpu);
> +       return 1;
> +}
> +
>  /*
>   * Two possibilities to handle a trapping ptrauth instruction:
>   *
> @@ -390,6 +403,7 @@ static exit_handle_fn arm_exit_handlers[] = {
>         [ESR_ELx_EC_SVC64]      = handle_svc,
>         [ESR_ELx_EC_SYS64]      = kvm_handle_sys_reg,
>         [ESR_ELx_EC_SVE]        = handle_sve,
> +       [ESR_ELx_EC_SME]        = handle_sme,
>         [ESR_ELx_EC_ERET]       = kvm_handle_eret,
>         [ESR_ELx_EC_IABT_LOW]   = kvm_handle_guest_abort,
>         [ESR_ELx_EC_DABT_LOW]   = kvm_handle_guest_abort,
> diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
> index 5bcc72ae48ff..ad88cc7bd5d3 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> @@ -69,11 +69,8 @@ static inline void __activate_cptr_traps_nvhe(struct kvm_vcpu *vcpu)
>  {
>         u64 val = CPTR_NVHE_EL2_RES1 | CPTR_EL2_TAM | CPTR_EL2_TTA;
>
> -       /*
> -        * Always trap SME since it's not supported in KVM.
> -        * TSM is RES1 if SME isn't implemented.
> -        */
> -       val |= CPTR_EL2_TSM;
> +       if (!vcpu_has_sme(vcpu) || !guest_owns_fp_regs())
> +               val |= CPTR_EL2_TSM;
>
>         if (!vcpu_has_sve(vcpu) || !guest_owns_fp_regs())
>                 val |= CPTR_EL2_TZ;
> @@ -101,6 +98,8 @@ static inline void __activate_cptr_traps_vhe(struct kvm_vcpu *vcpu)
>                 val |= CPACR_EL1_FPEN;
>                 if (vcpu_has_sve(vcpu))
>                         val |= CPACR_EL1_ZEN;
> +               if (vcpu_has_sme(vcpu))
> +                       val |= CPACR_EL1_SMEN;
>         }
>
>         if (!vcpu_has_nv(vcpu))
> @@ -142,6 +141,8 @@ static inline void __activate_cptr_traps_vhe(struct kvm_vcpu *vcpu)
>                 val &= ~CPACR_EL1_FPEN;
>         if (!(SYS_FIELD_GET(CPACR_EL1, ZEN, cptr) & BIT(0)))
>                 val &= ~CPACR_EL1_ZEN;
> +       if (!(SYS_FIELD_GET(CPACR_EL1, SMEN, cptr) & BIT(0)))
> +               val &= ~CPACR_EL1_SMEN;
>
>         if (kvm_has_feat(vcpu->kvm, ID_AA64MMFR3_EL1, S2POE, IMP))
>                 val |= cptr & CPACR_EL1_E0POE;
> diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
> index d3b9ec8a7c28..b2cba7c92b0f 100644
> --- a/arch/arm64/kvm/hyp/nvhe/switch.c
> +++ b/arch/arm64/kvm/hyp/nvhe/switch.c
> @@ -181,6 +181,7 @@ static const exit_handler_fn hyp_exit_handlers[] = {
>         [ESR_ELx_EC_CP15_32]            = kvm_hyp_handle_cp15_32,
>         [ESR_ELx_EC_SYS64]              = kvm_hyp_handle_sysreg,
>         [ESR_ELx_EC_SVE]                = kvm_hyp_handle_fpsimd,
> +       [ESR_ELx_EC_SME]                = kvm_hyp_handle_fpsimd,
>         [ESR_ELx_EC_FP_ASIMD]           = kvm_hyp_handle_fpsimd,
>         [ESR_ELx_EC_IABT_LOW]           = kvm_hyp_handle_iabt_low,
>         [ESR_ELx_EC_DABT_LOW]           = kvm_hyp_handle_dabt_low,
> @@ -192,7 +193,8 @@ static const exit_handler_fn pvm_exit_handlers[] = {
>         [0 ... ESR_ELx_EC_MAX]          = NULL,
>         [ESR_ELx_EC_SYS64]              = kvm_handle_pvm_sys64,
>         [ESR_ELx_EC_SVE]                = kvm_handle_pvm_restricted,
> -       [ESR_ELx_EC_FP_ASIMD]           = kvm_hyp_handle_fpsimd,
> +       [ESR_ELx_EC_SME]                = kvm_handle_pvm_restricted,
> +       [ESR_ELx_EC_FP_ASIMD]           = kvm_handle_pvm_restricted,
>         [ESR_ELx_EC_IABT_LOW]           = kvm_hyp_handle_iabt_low,
>         [ESR_ELx_EC_DABT_LOW]           = kvm_hyp_handle_dabt_low,
>         [ESR_ELx_EC_WATCHPT_LOW]        = kvm_hyp_handle_watchpt_low,
> diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
> index 9984c492305a..8449004bc24e 100644
> --- a/arch/arm64/kvm/hyp/vhe/switch.c
> +++ b/arch/arm64/kvm/hyp/vhe/switch.c
> @@ -458,22 +458,28 @@ static bool kvm_hyp_handle_cpacr_el1(struct kvm_vcpu *vcpu, u64 *exit_code)
>         return true;
>  }
>
> -static bool kvm_hyp_handle_zcr_el2(struct kvm_vcpu *vcpu, u64 *exit_code)
> +static bool kvm_hyp_handle_vec_cr_el2(struct kvm_vcpu *vcpu, u64 *exit_code)
>  {
>         u32 sysreg = esr_sys64_to_sysreg(kvm_vcpu_get_esr(vcpu));
>
>         if (!vcpu_has_nv(vcpu))
>                 return false;
>
> -       if (sysreg != SYS_ZCR_EL2)
> +       switch (sysreg) {
> +       case SYS_ZCR_EL2:
> +       case SYS_SMCR_EL2:
> +               break;
> +       default:
>                 return false;
> +       }
>
>         if (guest_owns_fp_regs())
>                 return false;
>
>         /*
> -        * ZCR_EL2 traps are handled in the slow path, with the expectation
> -        * that the guest's FP context has already been loaded onto the CPU.
> +        * ZCR_EL2 and SMCR_EL2 traps are handled in the slow path,
> +        * with the expectation that the guest's FP context has
> +        * already been loaded onto the CPU.
>          *
>          * Load the guest's FP context and unconditionally forward to the
>          * slow path for handling (i.e. return false).
> @@ -493,7 +499,7 @@ static bool kvm_hyp_handle_sysreg_vhe(struct kvm_vcpu *vcpu, u64 *exit_code)
>         if (kvm_hyp_handle_cpacr_el1(vcpu, exit_code))
>                 return true;
>
> -       if (kvm_hyp_handle_zcr_el2(vcpu, exit_code))
> +       if (kvm_hyp_handle_vec_cr_el2(vcpu, exit_code))
>                 return true;
>
>         return kvm_hyp_handle_sysreg(vcpu, exit_code);
> @@ -522,6 +528,7 @@ static const exit_handler_fn hyp_exit_handlers[] = {
>         [0 ... ESR_ELx_EC_MAX]          = NULL,
>         [ESR_ELx_EC_CP15_32]            = kvm_hyp_handle_cp15_32,
>         [ESR_ELx_EC_SYS64]              = kvm_hyp_handle_sysreg_vhe,
> +       [ESR_ELx_EC_SME]                = kvm_hyp_handle_fpsimd,
>         [ESR_ELx_EC_SVE]                = kvm_hyp_handle_fpsimd,
>         [ESR_ELx_EC_FP_ASIMD]           = kvm_hyp_handle_fpsimd,
>         [ESR_ELx_EC_IABT_LOW]           = kvm_hyp_handle_iabt_low,
>
> --
> 2.47.3
>
