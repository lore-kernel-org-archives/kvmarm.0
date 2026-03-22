Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 229E252F8B
	for <kvmarm@lists.linux.dev>; Sun, 22 Mar 2026 15:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774194631; cv=pass; b=O4V8DQSso8rcJUS4w+tcAVo/DUtMEAjqLkjq+KTO7xNtK7JVgsQ7p1QPqcoLhnDqZZ3cIQAA17RFQeoN8vqX4PpGxG1ulGbiAqxxPa2X6k8eA+u4UDrdZYtTitm2K0Us4mEOtaBMAvadp9iYiVCUul1r5p32HKndinU++DJ1+os=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774194631; c=relaxed/simple;
	bh=BhBOLtHAp4YM9Z087VBxs34GLhAwhGBDe2xmAhBFqjE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Eb6nnC6SK6jzATFRRAn5d5qRYeimmhSMtLX0hC+Ocwnk+u3armq1dqcYz0pyWn0A545NA/O2V/KTCwDdzOKEv77hdI96tqAq2n1VQUKlyHYPW7MRILs/M5dzCOiB2cEG9FCX1NkkwSl59grPD9yOvZmrVAV71Sac6g3o24nf5wE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Jn+oRaJ9; arc=pass smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Jn+oRaJ9"
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-50b30d61be6so932481cf.0
        for <kvmarm@lists.linux.dev>; Sun, 22 Mar 2026 08:50:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774194628; cv=none;
        d=google.com; s=arc-20240605;
        b=K6udGpgXqwiNX4HBJ3EBVo0XDxvl2cmdCPVYly1fcsjWeO04DDIu8mWuDipyQykFII
         F5CjgnFQ0l6KwfRanTKPa7teIeYUvOQoeaDWQ7To0Tgi2eUdIRTqgmMeGN4nJufacrdL
         gJxkew0ph9Xj9hL3a7+FjpWBICO150WoWh9ImwpKdhT+rUmnb0nhPKS/eb1nF3LXiqV3
         4isZsKqOGXf582Ru3YxKwSjgEJ6t2tif9unp34Z8hOrVaVB91791Ii1ZbllyRyvhS/Qj
         9uStGC2CNrSAi1wO2i8MV3cSax7UtPOvzFMFSlQiMSGPXXWup2mSuCYET0kLMuod8Xzt
         YLNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=9TMp7zsq0XX2Ydy/N6WFEOqdEvOC8DyuCjYsPFMbMJY=;
        fh=br/O7ad/Dpl82iqHQ050DMUcdTbv2XuF8/c9+X0NSgk=;
        b=PKCiGP2ca5j/4dBPDXQKfq6xCEhDpIvPeeuDqCGhGYk04/oPVRJp9knaBQvAQO8prE
         Ph70RLtxIBaBhMtsSeAXwYcIgzPFAEfSYj9RdKWI+I5EVf3XXG3JD9dU7pX+U8yGn5uM
         wavAQ7iu0gRTZMoYypnS5uEOqHR+SWJL/A1U/Cwd/HF4rO+oK41Ovc+gvyGkRTULQ1c2
         2iE6aPHLOh0NZB9G6Skw0lOEW2Ep47tOt4pPAYcqagGHHzk4dbVnu0QfnWX0EmQ4VWOj
         QcjS40QQUOSDtqGZbsqoxVtFXIpSrhoCpofs9MITMNizyeW2kd+U7DJlXibQemmlFFsH
         BrUg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774194628; x=1774799428; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=9TMp7zsq0XX2Ydy/N6WFEOqdEvOC8DyuCjYsPFMbMJY=;
        b=Jn+oRaJ9scjFAN7IGScIFF4uw1fD8h+ly6vWJwAspknvV0h+h0M1DkYf9VGf75y+Na
         VAH13jepHIw8ykNfn42vxR58zC+59AJNzri1DDOKA6LEFNFu0l1fGHmKf8/hROWFcD4G
         6h2sM8Eu1XJ9qCPWUihp29Lv8HXQhiLryAxBiLz7Znf0N7/Ug7V5EybrcFh9UEHjDCrZ
         EGHxp+Xvc34Xmf/BuQyfwk2pao+KbX3K/u2R+7FJAuwS/01rc6pT02sbr/rcoYzUGsnl
         67CBMvxJp811NPWRlsVCOBQYDaqfbSR0axiFEN7LLjKoUDw/xxKEkGgH4uXoZVOl35zn
         pI5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774194628; x=1774799428;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9TMp7zsq0XX2Ydy/N6WFEOqdEvOC8DyuCjYsPFMbMJY=;
        b=dGzV8vRB15rIQ+Yi8Yyftu/vRWIjz6cU/FANKNCRDYiNdVzd40tZhQes2Tpv/5uB66
         WtjnhicqF/3VuZHrRP5qhB3qUazlXGiecMraTSocvWSqvm+qBQjmyJLWQD6QC26VYXRj
         DL8qoU/cj9BDJObyQg22IO2DWUvEjF53M3i+KE4c2QeqMRCcxNrpj84FhShMAhbG1AFV
         Wx+eQVweJQOSknqag7cH+Rw03IwXnArLd5HjZRsyHQJgc8/PzAqwtFioJWfS6T+DPR3k
         FAIje4XjKhHrUQTcwAyUUPkPSBe2Q0UQcJxRyfpknXWKJNXb/RKwMM+4xF8amvpsqJcS
         Zo6A==
X-Gm-Message-State: AOJu0YyfW8TT/jMt+JJ+g4n/cLwcv31aAqZJaVDUcNPLqjRYLIErxJHf
	rG34KZoyvR4BvbNsIHbhI+M14+TaFC15NHF0pM2odO9B9eCv3cO4ChTCGWk0YiJm2j/Q4W3YkXO
	fZoDEiLpFiFHqGsns9mAL1NkSQrbDPpR6zn1CP2b8
X-Gm-Gg: ATEYQzz4AJMGvxJuYjKPaVcI16YQjMg1dyjww/hpbaJAO0WfJb2vRemTTHeQEO+P5u5
	zcBd+t1CstmpatXgoCVuSqFLLyQrR0KbiSGy6q17KA7rgEAK5V/JuUzbJ/nuoRtQ4Y+pbuxKiIG
	2AN2tPwPvIFSsv3eqUtqOUMZ3RqTiMLUOSmf9+PRPmAhfPWY6IW3PdZQdTmVC7aKcULdZjMewrd
	qMBuhd4C0jobibwtsY4XVZB6Key7qPmDUuVvYwa/EIgkSt0LKFn92ptWzBY/4+/qnkHQiCktaC2
	0o6DfDUm
X-Received: by 2002:ac8:5f8e:0:b0:4ff:bfd9:dd31 with SMTP id
 d75a77b69052e-50b48098112mr16468731cf.5.1774194627629; Sun, 22 Mar 2026
 08:50:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260321212419.2803972-1-maz@kernel.org> <20260321212419.2803972-5-maz@kernel.org>
In-Reply-To: <20260321212419.2803972-5-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Sun, 22 Mar 2026 15:49:50 +0000
X-Gm-Features: AQROBzDQA782Knk4hyvgu0Qa0fNpkNAT5ojfrw4qkd--fM3yU2R8wbZU-YGI_Xs
Message-ID: <CA+EHjTyeuE3aqqmx8Fe4REOM7WstEAp_A0tvMNygPJCLT7V7wQ@mail.gmail.com>
Subject: Re: [PATCH 4/5] KVM: arm64: pkvm: Use direct function pointers for cpu_{on,resume}
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>, 
	Mostafa Saleh <smostafa@google.com>, Quentin Perret <qperret@google.com>
Content-Type: text/plain; charset="UTF-8"

Hi Marc,

On Sat, 21 Mar 2026 at 21:24, Marc Zyngier <maz@kernel.org> wrote:
>
> Instead of using a boolean to decide whether a CPU is booting or
> resuming, just pass an actual function pointer around.
>
> This makes the code a bit more straightforward to understand.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_asm.h     |  3 ++-
>  arch/arm64/kvm/hyp/nvhe/hyp-init.S   |  9 +++----
>  arch/arm64/kvm/hyp/nvhe/psci-relay.c | 39 +++++++++++++++++-----------
>  3 files changed, 29 insertions(+), 22 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
> index a1ad12c72ebf1..f4c769857fdfc 100644
> --- a/arch/arm64/include/asm/kvm_asm.h
> +++ b/arch/arm64/include/asm/kvm_asm.h
> @@ -291,7 +291,8 @@ asmlinkage void __noreturn hyp_panic_bad_stack(void);
>  asmlinkage void kvm_unexpected_el2_exception(void);
>  struct kvm_cpu_context;
>  void handle_trap(struct kvm_cpu_context *host_ctxt);
> -asmlinkage void __noreturn __kvm_host_psci_cpu_entry(bool is_cpu_on);
> +asmlinkage void __noreturn __kvm_host_psci_cpu_on_entry(void);
> +asmlinkage void __noreturn __kvm_host_psci_cpu_resume_entry(void);
>  void __noreturn __pkvm_init_finalise(void);
>  void kvm_nvhe_prepare_backtrace(unsigned long fp, unsigned long pc);
>  void kvm_patch_vector_branch(struct alt_instr *alt,
> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-init.S b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
> index 2e80fcbff2dff..64296b31da73d 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-init.S
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
> @@ -173,7 +173,7 @@ SYM_CODE_END(___kvm_hyp_init)
>   * x0: struct kvm_nvhe_init_params PA
>   */
>  SYM_CODE_START(kvm_hyp_cpu_entry)
> -       mov     x1, #1                          // is_cpu_on = true
> +       ldr     x29, =__kvm_host_psci_cpu_on_entry
>         b       __kvm_hyp_init_cpu
>
>  /*
> @@ -182,11 +182,10 @@ SYM_CODE_START(kvm_hyp_cpu_entry)
>   * x0: struct kvm_nvhe_init_params PA
>   */
>  SYM_CODE_START(kvm_hyp_cpu_resume)
> -       mov     x1, #0                          // is_cpu_on = false
> +       ldr     x29, =__kvm_host_psci_cpu_resume_entry
>
>  SYM_INNER_LABEL(__kvm_hyp_init_cpu, SYM_L_LOCAL)
>         mov     x28, x0                         // Stash arguments
> -       mov     x29, x1
>
>         /* Check that the core was booted in EL2. */
>         mrs     x0, CurrentEL
> @@ -204,9 +203,7 @@ SYM_INNER_LABEL(__kvm_hyp_init_cpu, SYM_L_LOCAL)
>         bl      ___kvm_hyp_init                 // Clobbers x0..x2
>
>         /* Leave idmap -- using BLR is OK, LR is restored from host context */
> -       mov     x0, x29
> -       ldr     x1, =__kvm_host_psci_cpu_entry
> -       blr     x1
> +       blr     x29
>
>         // The core booted in EL1, or the C code unexpectedly returned.
>         // Either way, KVM cannot be initialized on it.
> diff --git a/arch/arm64/kvm/hyp/nvhe/psci-relay.c b/arch/arm64/kvm/hyp/nvhe/psci-relay.c
> index c3e196fb8b18f..cc698ceee9c8c 100644
> --- a/arch/arm64/kvm/hyp/nvhe/psci-relay.c
> +++ b/arch/arm64/kvm/hyp/nvhe/psci-relay.c
> @@ -200,23 +200,12 @@ static int psci_system_suspend(u64 func_id, struct kvm_cpu_context *host_ctxt)
>                          __hyp_pa(init_params), 0);
>  }
>
> -asmlinkage void __noreturn __kvm_host_psci_cpu_entry(bool is_cpu_on)
> +static void __noreturn __kvm_host_psci_cpu_entry(unsigned long pc, unsigned long r0)
>  {
> -       struct psci_boot_args *boot_args;
> -       struct kvm_cpu_context *host_ctxt;
> -
> -       host_ctxt = host_data_ptr(host_ctxt);
> -
> -       if (is_cpu_on)
> -               boot_args = this_cpu_ptr(&cpu_on_args);
> -       else
> -               boot_args = this_cpu_ptr(&suspend_args);
> -
> -       cpu_reg(host_ctxt, 0) = boot_args->r0;
> -       write_sysreg_el2(boot_args->pc, SYS_ELR);
> +       struct kvm_cpu_context *host_ctxt = host_data_ptr(host_ctxt);
>
> -       if (is_cpu_on)
> -               release_boot_args(boot_args);
> +       cpu_reg(host_ctxt, 0) = r0;
> +       write_sysreg_el2(pc, SYS_ELR);
>
>         write_sysreg_el1(INIT_SCTLR_EL1_MMU_OFF, SYS_SCTLR);
>         write_sysreg(INIT_PSTATE_EL1, SPSR_EL2);
> @@ -224,6 +213,26 @@ asmlinkage void __noreturn __kvm_host_psci_cpu_entry(bool is_cpu_on)
>         __host_enter(host_ctxt);
>  }
>
> +asmlinkage void __noreturn __kvm_host_psci_cpu_on_entry(void)
> +{
> +       struct psci_boot_args *boot_args = this_cpu_ptr(&cpu_on_args);
> +       unsigned long pc, r0;
> +
> +       pc = READ_ONCE(boot_args->pc);
> +       r0 = READ_ONCE(boot_args->r0);
> +
> +       release_boot_args(boot_args);
> +
> +       __kvm_host_psci_cpu_entry(pc, r0);
> +}
> +
> +asmlinkage void __noreturn __kvm_host_psci_cpu_resume_entry(void)
> +{
> +       struct psci_boot_args *boot_args = this_cpu_ptr(&cpu_on_args);

This should be suspend_args:
+     struct psci_boot_args *boot_args = this_cpu_ptr(&suspend_args);

With this fixed:

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad




> +
> +       __kvm_host_psci_cpu_entry(boot_args->pc, boot_args->r0);
> +}
> +
>  static unsigned long psci_0_1_handler(u64 func_id, struct kvm_cpu_context *host_ctxt)
>  {
>         if (is_psci_0_1(cpu_off, func_id) || is_psci_0_1(migrate, func_id))
> --
> 2.47.3
>
