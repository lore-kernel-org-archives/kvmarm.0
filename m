Return-Path: <SRS0=3/RW=4B=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF368C352A3
	for <kvmarm@archiver.kernel.org>; Thu, 13 Feb 2020 21:37:04 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3D93D206B6
	for <kvmarm@archiver.kernel.org>; Thu, 13 Feb 2020 21:37:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="oRtZy/pf"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3D93D206B6
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D0D854A598;
	Thu, 13 Feb 2020 16:37:03 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ikWyJxEWbx14; Thu, 13 Feb 2020 16:37:01 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AB66A4A542;
	Thu, 13 Feb 2020 16:37:01 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A7EC64A4CD
 for <kvmarm@lists.cs.columbia.edu>; Thu, 13 Feb 2020 16:37:00 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7uTfEOZ9+O0B for <kvmarm@lists.cs.columbia.edu>;
 Thu, 13 Feb 2020 16:36:59 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 623B04A542
 for <kvmarm@lists.cs.columbia.edu>; Thu, 13 Feb 2020 16:36:59 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 1E1E3206B6;
 Thu, 13 Feb 2020 21:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1581629818;
 bh=x9nbXOfLxwm3MSFJz4Mp1Qf8injFxjoGpzXI1vGi1GQ=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=oRtZy/pf4khN4Vxvx2aijKcDfaumiwA1LktH2GBiQQUaX581XUmG6AfGGluhYSFoO
 vYEqTz1XtLqfRSXUSwskHcOPic5G3VN0Gmq0AUf1tnspnax9p7+3qWxZKc5DsONLFB
 fis/aB5ljjxzuQS5wk55GuhjY13AAr+V6ZP5Q6dQ=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1j2MAK-004ySa-AB; Thu, 13 Feb 2020 21:36:56 +0000
MIME-Version: 1.0
Date: Thu, 13 Feb 2020 21:36:56 +0000
From: Marc Zyngier <maz@kernel.org>
To: Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH] arm64: kvm: Annotate assembly using modern annoations
In-Reply-To: <20200213153820.32049-1-broonie@kernel.org>
References: <20200213153820.32049-1-broonie@kernel.org>
Message-ID: <b25323d02c76441ee12c206f07907383@kernel.org>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/1.3.10
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: broonie@kernel.org, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, catalin.marinas@arm.com,
 will@kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Mark,

On 2020-02-13 15:38, Mark Brown wrote:
> In an effort to clarify and simplify the annotation of assembly 
> functions
> in the kernel new macros have been introduced. These replace ENTRY and
> ENDPROC with separate annotations for standard C callable functions,
> data and code with different calling conventions.  Update the
> annotations in the kvm code to the new macros.
> 
> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---
>  arch/arm64/kvm/hyp-init.S      |  8 ++++----
>  arch/arm64/kvm/hyp.S           |  4 ++--
>  arch/arm64/kvm/hyp/fpsimd.S    |  8 ++++----
>  arch/arm64/kvm/hyp/hyp-entry.S | 27 ++++++++++++++++-----------
>  4 files changed, 26 insertions(+), 21 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp-init.S b/arch/arm64/kvm/hyp-init.S
> index 160be2b4696d..84f32cf5abc7 100644
> --- a/arch/arm64/kvm/hyp-init.S
> +++ b/arch/arm64/kvm/hyp-init.S
> @@ -18,7 +18,7 @@
> 
>  	.align	11
> 
> -ENTRY(__kvm_hyp_init)
> +SYM_CODE_START(__kvm_hyp_init)
>  	ventry	__invalid		// Synchronous EL2t
>  	ventry	__invalid		// IRQ EL2t
>  	ventry	__invalid		// FIQ EL2t
> @@ -117,9 +117,9 @@ CPU_BE(	orr	x4, x4, #SCTLR_ELx_EE)
> 
>  	/* Hello, World! */
>  	eret
> -ENDPROC(__kvm_hyp_init)
> +SYM_CODE_END(__kvm_hyp_init)
> 
> -ENTRY(__kvm_handle_stub_hvc)
> +SYM_CODE_START(__kvm_handle_stub_hvc)
>  	cmp	x0, #HVC_SOFT_RESTART
>  	b.ne	1f
> 
> @@ -158,7 +158,7 @@ reset:
>  	ldr	x0, =HVC_STUB_ERR
>  	eret
> 
> -ENDPROC(__kvm_handle_stub_hvc)
> +SYM_CODE_END(__kvm_handle_stub_hvc)
> 
>  	.ltorg
> 
> diff --git a/arch/arm64/kvm/hyp.S b/arch/arm64/kvm/hyp.S
> index c0094d520dff..3c79a1124af2 100644
> --- a/arch/arm64/kvm/hyp.S
> +++ b/arch/arm64/kvm/hyp.S
> @@ -28,7 +28,7 @@
>   * and is used to implement hyp stubs in the same way as in
>   * arch/arm64/kernel/hyp_stub.S.
>   */
> -ENTRY(__kvm_call_hyp)
> +SYM_FUNC_START(__kvm_call_hyp)

I'm not convinced by this particular change. _kvm_call_hyp is called 
directly from
C, and behaves almost like a normal function. What's the issue here?

>  	hvc	#0
>  	ret
> -ENDPROC(__kvm_call_hyp)
> +SYM_FUNC_END(__kvm_call_hyp)
> diff --git a/arch/arm64/kvm/hyp/fpsimd.S b/arch/arm64/kvm/hyp/fpsimd.S
> index 78ff53225691..5b8ff517ff10 100644
> --- a/arch/arm64/kvm/hyp/fpsimd.S
> +++ b/arch/arm64/kvm/hyp/fpsimd.S
> @@ -11,12 +11,12 @@
>  	.text
>  	.pushsection	.hyp.text, "ax"
> 
> -ENTRY(__fpsimd_save_state)
> +SYM_FUNC_START(__fpsimd_save_state)
>  	fpsimd_save	x0, 1
>  	ret
> -ENDPROC(__fpsimd_save_state)
> +SYM_FUNC_END(__fpsimd_save_state)
> 
> -ENTRY(__fpsimd_restore_state)
> +SYM_FUNC_START(__fpsimd_restore_state)
>  	fpsimd_restore	x0, 1
>  	ret
> -ENDPROC(__fpsimd_restore_state)
> +SYM_FUNC_END(__fpsimd_restore_state)

Same for these. The only reason they are not written inline assemply
in a normal C function is that we have these fpsimd_* macros.

> diff --git a/arch/arm64/kvm/hyp/hyp-entry.S 
> b/arch/arm64/kvm/hyp/hyp-entry.S
> index ffa68d5713f1..f7b0cb189b77 100644
> --- a/arch/arm64/kvm/hyp/hyp-entry.S
> +++ b/arch/arm64/kvm/hyp/hyp-entry.S
> @@ -180,7 +180,7 @@ el2_error:
>  	eret
>  	sb
> 
> -ENTRY(__hyp_do_panic)
> +SYM_FUNC_START(__hyp_do_panic)
>  	mov	lr, #(PSR_F_BIT | PSR_I_BIT | PSR_A_BIT | PSR_D_BIT |\
>  		      PSR_MODE_EL1h)
>  	msr	spsr_el2, lr
> @@ -188,18 +188,19 @@ ENTRY(__hyp_do_panic)
>  	msr	elr_el2, lr
>  	eret
>  	sb
> -ENDPROC(__hyp_do_panic)
> +SYM_FUNC_END(__hyp_do_panic)
> 
> -ENTRY(__hyp_panic)
> +SYM_CODE_START(__hyp_panic)
>  	get_host_ctxt x0, x1
>  	b	hyp_panic
> -ENDPROC(__hyp_panic)
> +SYM_CODE_END(__hyp_panic)
> 
>  .macro invalid_vector	label, target = __hyp_panic
>  	.align	2
> +SYM_CODE_START(\label)
>  \label:
>  	b \target
> -ENDPROC(\label)
> +SYM_CODE_END(\label)
>  .endm
> 
>  	/* None of these should ever happen */
> @@ -246,7 +247,7 @@ check_preamble_length 661b, 662b
>  check_preamble_length 661b, 662b
>  .endm
> 
> -ENTRY(__kvm_hyp_vector)
> +SYM_CODE_START(__kvm_hyp_vector)
>  	invalid_vect	el2t_sync_invalid	// Synchronous EL2t
>  	invalid_vect	el2t_irq_invalid	// IRQ EL2t
>  	invalid_vect	el2t_fiq_invalid	// FIQ EL2t
> @@ -266,7 +267,7 @@ ENTRY(__kvm_hyp_vector)
>  	valid_vect	el1_irq			// IRQ 32-bit EL1
>  	invalid_vect	el1_fiq_invalid		// FIQ 32-bit EL1
>  	valid_vect	el1_error		// Error 32-bit EL1
> -ENDPROC(__kvm_hyp_vector)
> +SYM_CODE_END(__kvm_hyp_vector)
> 
>  #ifdef CONFIG_KVM_INDIRECT_VECTORS
>  .macro hyp_ventry
> @@ -311,15 +312,18 @@ alternative_cb_end
>  .endm
> 
>  	.align	11
> -ENTRY(__bp_harden_hyp_vecs_start)
> +SYM_CODE_START_NOALIGN(__bp_harden_hyp_vecs)
> +SYM_INNER_LABEL(__bp_harden_hyp_vecs_start, SYM_L_GLOBAL)

Why isn't SYM_CODE_START_NOALIGN enough? And what is the rational for
the _NOALIGN, btw? I'd expect an alignment of 2kB to be more than 
enough.

>  	.rept BP_HARDEN_EL2_SLOTS
>  	generate_vectors
>  	.endr
> -ENTRY(__bp_harden_hyp_vecs_end)
> +SYM_INNER_LABEL(__bp_harden_hyp_vecs_end, SYM_L_GLOBAL)
> +SYM_CODE_END(__bp_harden_hyp_vecs)

Same here.

> 
>  	.popsection
> 
> -ENTRY(__smccc_workaround_1_smc_start)
> +SYM_CODE_START(__smccc_workaround_1_smc)
> +SYM_INNER_LABEL(__smccc_workaround_1_smc_start, SYM_L_GLOBAL)
>  	esb
>  	sub	sp, sp, #(8 * 4)
>  	stp	x2, x3, [sp, #(8 * 0)]
> @@ -329,5 +333,6 @@ ENTRY(__smccc_workaround_1_smc_start)
>  	ldp	x2, x3, [sp, #(8 * 0)]
>  	ldp	x0, x1, [sp, #(8 * 2)]
>  	add	sp, sp, #(8 * 4)
> -ENTRY(__smccc_workaround_1_smc_end)
> +SYM_INNER_LABEL(__smccc_workaround_1_smc_end, SYM_L_GLOBAL)
> +SYM_CODE_END(__smccc_workaround_1_smc)
>  #endif

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
