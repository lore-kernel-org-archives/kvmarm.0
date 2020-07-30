Return-Path: <SRS0=3/sM=BJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BBFBC433DF
	for <kvmarm@archiver.kernel.org>; Thu, 30 Jul 2020 16:03:06 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C6F0D206F5
	for <kvmarm@archiver.kernel.org>; Thu, 30 Jul 2020 16:03:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="mRDwmDBj"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C6F0D206F5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4CC4F4B484;
	Thu, 30 Jul 2020 12:03:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id s9ChYMH7i5vN; Thu, 30 Jul 2020 12:03:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8D31A4B46D;
	Thu, 30 Jul 2020 12:03:03 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3BDDD4B442
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jul 2020 12:03:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9RQtOWu6zdAl for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Jul 2020 12:03:00 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 97E044B439
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jul 2020 12:03:00 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 69F38206F5;
 Thu, 30 Jul 2020 16:02:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1596124979;
 bh=9dbJ8eQHQiRQ94uLst7uOQUTUZFEex2l56205Svc9n4=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=mRDwmDBjgEEaR9ayOvjRcpd7w4HjJaYef6cqe2HHf8mgt6Gh/qna/6Q0w7HYDAyRc
 fiHSllxTV1I52zc9NIz69Kmich9iI3BMJzoKypnefyFZC6V/4C5LT48tSbE9yJ478L
 iCr1ssKhiV0O3zkhFseZRCKCZCSZeriuymy7uIy0=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1k1B1F-00GIyO-BU; Thu, 30 Jul 2020 17:02:58 +0100
MIME-Version: 1.0
Date: Thu, 30 Jul 2020 17:02:57 +0100
From: Marc Zyngier <maz@kernel.org>
To: Andrew Scull <ascull@google.com>
Subject: Re: [PATCH 2/2] KVM: arm64: nVHE: Don't consume host SErrors with RAS
In-Reply-To: <20200730151823.1414808-2-ascull@google.com>
References: <20200730151823.1414808-1-ascull@google.com>
 <20200730151823.1414808-2-ascull@google.com>
User-Agent: Roundcube Webmail/1.4.5
Message-ID: <cf05e4e6c427b1c708dff54925ff8a9f@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: ascull@google.com, kvmarm@lists.cs.columbia.edu,
 james.morse@arm.com, suzuki.poulose@arm.com, julien.thierry.kdev@gmail.com,
 will@kernel.org, catalin.marinas@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, catalin.marinas@arm.com, will@kernel.org,
 kvmarm@lists.cs.columbia.edu
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

On 2020-07-30 16:18, Andrew Scull wrote:
> The ESB at the start of the vectors causes any SErrors to be consumed 
> to
> DISR_EL1. If the exception came from the host and the ESB caught an
> SError, it would not be noticed until a guest exits and DISR_EL1 is
> checked. Further, the SError would be attributed to the guest and not
> the host.
> 
> To avoid these problems, use a different exception vector for the host
> that does not use an ESB but instead leaves any host SError pending. A
> guest will not be entered if an SError is pending so it will always be
> the host that will receive and handle it.
> 
> Hyp initialization is now passed the vector that is used for the host
> and the vector for guests is stored in a percpu variable as
> kvm_get_hyp_vector() is not suitable for calling from nVHE hyp.
> 
> Fixes: 0e5b9c085dce ("KVM: arm64: Consume pending SError as early as 
> possible")
> Cc: James Morse <james.morse@arm.com>
> Signed-off-by: Andrew Scull <ascull@google.com>
> ---
>  arch/arm64/include/asm/kvm_asm.h  |  2 ++
>  arch/arm64/include/asm/kvm_host.h |  1 +
>  arch/arm64/kernel/image-vars.h    |  1 +
>  arch/arm64/kvm/arm.c              | 15 ++++++++++-
>  arch/arm64/kvm/hyp/hyp-entry.S    | 42 +++++++++++++++++++++++++++++++
>  arch/arm64/kvm/hyp/nvhe/switch.c  |  3 +++
>  6 files changed, 63 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_asm.h 
> b/arch/arm64/include/asm/kvm_asm.h
> index 413911d6446a..81f29a2c361a 100644
> --- a/arch/arm64/include/asm/kvm_asm.h
> +++ b/arch/arm64/include/asm/kvm_asm.h
> @@ -98,10 +98,12 @@ struct kvm_vcpu;
>  struct kvm_s2_mmu;
> 
>  DECLARE_KVM_NVHE_SYM(__kvm_hyp_init);
> +DECLARE_KVM_NVHE_SYM(__kvm_hyp_host_vector);
>  DECLARE_KVM_HYP_SYM(__kvm_hyp_vector);
> 
>  #ifndef __KVM_NVHE_HYPERVISOR__
>  #define __kvm_hyp_init		CHOOSE_NVHE_SYM(__kvm_hyp_init)
> +#define __kvm_hyp_host_vector	CHOOSE_NVHE_SYM(__kvm_hyp_host_vector)
>  #define __kvm_hyp_vector	CHOOSE_HYP_SYM(__kvm_hyp_vector)
>  #endif
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h
> b/arch/arm64/include/asm/kvm_host.h
> index e1a32c0707bb..6b21d1c71a83 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -575,6 +575,7 @@ void kvm_set_sei_esr(struct kvm_vcpu *vcpu, u64 
> syndrome);
>  struct kvm_vcpu *kvm_mpidr_to_vcpu(struct kvm *kvm, unsigned long 
> mpidr);
> 
>  DECLARE_PER_CPU(kvm_host_data_t, kvm_host_data);
> +DECLARE_PER_CPU(unsigned long, kvm_hyp_vector);
> 
>  static inline void kvm_init_host_cpu_context(struct kvm_cpu_context 
> *cpu_ctxt)
>  {
> diff --git a/arch/arm64/kernel/image-vars.h 
> b/arch/arm64/kernel/image-vars.h
> index 9e897c500237..7e93b0c426d4 100644
> --- a/arch/arm64/kernel/image-vars.h
> +++ b/arch/arm64/kernel/image-vars.h
> @@ -71,6 +71,7 @@ KVM_NVHE_ALIAS(kvm_update_va_mask);
>  /* Global kernel state accessed by nVHE hyp code. */
>  KVM_NVHE_ALIAS(arm64_ssbd_callback_required);
>  KVM_NVHE_ALIAS(kvm_host_data);
> +KVM_NVHE_ALIAS(kvm_hyp_vector);
>  KVM_NVHE_ALIAS(kvm_vgic_global_state);
> 
>  /* Kernel constant needed to compute idmap addresses. */
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 98f05bdac3c1..bb7c74b05fcd 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -47,6 +47,7 @@ __asm__(".arch_extension	virt");
>  #endif
> 
>  DEFINE_PER_CPU(kvm_host_data_t, kvm_host_data);
> +DEFINE_PER_CPU(unsigned long, kvm_hyp_vector);
>  static DEFINE_PER_CPU(unsigned long, kvm_arm_hyp_stack_page);
> 
>  /* The VMID used in the VTTBR */
> @@ -1274,7 +1275,10 @@ static void cpu_init_hyp_mode(void)
> 
>  	pgd_ptr = kvm_mmu_get_httbr();
>  	hyp_stack_ptr = __this_cpu_read(kvm_arm_hyp_stack_page) + PAGE_SIZE;
> -	vector_ptr = (unsigned long)kvm_get_hyp_vector();
> +
> +	/* Get the hyp address of the vectors used for the host and guests. 
> */
> +	vector_ptr = (unsigned 
> long)kern_hyp_va(kvm_ksym_ref(__kvm_hyp_host_vector));
> +	__this_cpu_write(kvm_hyp_vector, (unsigned 
> long)kvm_get_hyp_vector());
> 
>  	/*
>  	 * Call initialization code, and switch to the full blown HYP code.
> @@ -1537,6 +1541,7 @@ static int init_hyp_mode(void)
> 
>  	for_each_possible_cpu(cpu) {
>  		kvm_host_data_t *cpu_data;
> +		unsigned long *vector;
> 
>  		cpu_data = per_cpu_ptr(&kvm_host_data, cpu);
>  		err = create_hyp_mappings(cpu_data, cpu_data + 1, PAGE_HYP);
> @@ -1545,6 +1550,14 @@ static int init_hyp_mode(void)
>  			kvm_err("Cannot map host CPU state: %d\n", err);
>  			goto out_err;
>  		}
> +
> +		vector = per_cpu_ptr(&kvm_hyp_vector, cpu);
> +		err = create_hyp_mappings(vector, vector + 1, PAGE_HYP);
> +
> +		if (err) {
> +			kvm_err("Cannot map hyp guest vector address\n");
> +			goto out_err;
> +		}
>  	}
> 
>  	err = hyp_map_aux_data();
> diff --git a/arch/arm64/kvm/hyp/hyp-entry.S 
> b/arch/arm64/kvm/hyp/hyp-entry.S
> index 689fccbc9de7..2c5bec3ecb2a 100644
> --- a/arch/arm64/kvm/hyp/hyp-entry.S
> +++ b/arch/arm64/kvm/hyp/hyp-entry.S
> @@ -213,7 +213,10 @@ SYM_CODE_END(\label)
>  	invalid_vector	el2h_sync_invalid
>  	invalid_vector	el2h_irq_invalid
>  	invalid_vector	el2h_fiq_invalid
> +	invalid_vector	el1_sync_invalid
> +	invalid_vector	el1_irq_invalid
>  	invalid_vector	el1_fiq_invalid
> +	invalid_vector	el1_error_invalid
> 
>  	.ltorg
> 
> @@ -271,6 +274,45 @@ SYM_CODE_START(__kvm_hyp_vector)
>  	valid_vect	el1_error		// Error 32-bit EL1
>  SYM_CODE_END(__kvm_hyp_vector)
> 
> +#ifdef __KVM_NVHE_HYPERVISOR__
> +.macro valid_host_vect target
> +	.align 7
> +	stp	x0, x1, [sp, #-16]!
> +	b	\target
> +.endm
> +
> +/*
> + * The host vectors do not use an ESB instruction in order to avoid 
> consuming
> + * SErrors that should only be comsumed by the host. The host is also 
> known to
> + * be 64-bit so any 32-bit exceptions can be treated as invalid.
> + *
> + * Indirection is not applied to the host vectors because the host 
> already
> + * knows the address of hyp by virtue of loading it there.
> + */
> +	.align 11
> +SYM_CODE_START(__kvm_hyp_host_vector)
> +	invalid_vect	el2t_sync_invalid	// Synchronous EL2t
> +	invalid_vect	el2t_irq_invalid	// IRQ EL2t
> +	invalid_vect	el2t_fiq_invalid	// FIQ EL2t
> +	invalid_vect	el2t_error_invalid	// Error EL2t
> +
> +	valid_host_vect	el2_sync		// Synchronous EL2h
> +	invalid_vect	el2h_irq_invalid	// IRQ EL2h
> +	invalid_vect	el2h_fiq_invalid	// FIQ EL2h
> +	valid_host_vect	el2_error		// Error EL2h
> +
> +	valid_host_vect	el1_sync		// Synchronous 64-bit EL1

I quite like the idea, but it feels like you have stopped short
of doing interesting things here.

Since you have started pulling host and guest vectors apart,
you should be able to do a much better job than what we have
today when we try to identify the host by looking at vttbr_el2.

It also means that the macro that pushes things on the stack could
be removed as we end-up having very different requirements.

What do you think?

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
