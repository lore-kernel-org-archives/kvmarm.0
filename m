Return-Path: <SRS0=3/sM=BJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77464C433DF
	for <kvmarm@archiver.kernel.org>; Thu, 30 Jul 2020 16:25:17 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E63B82082E
	for <kvmarm@archiver.kernel.org>; Thu, 30 Jul 2020 16:25:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="kDjoo/W9"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E63B82082E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 46B6E4B439;
	Thu, 30 Jul 2020 12:25:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id kjSlqXdm8bQC; Thu, 30 Jul 2020 12:25:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D1EB94B4A5;
	Thu, 30 Jul 2020 12:25:14 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 11AF14B47B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jul 2020 12:25:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id df3oLLEi5Oj3 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Jul 2020 12:25:11 -0400 (EDT)
Received: from mail-wr1-f67.google.com (mail-wr1-f67.google.com
 [209.85.221.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 43E1C4B439
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jul 2020 12:25:11 -0400 (EDT)
Received: by mail-wr1-f67.google.com with SMTP id r2so20400176wrs.8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jul 2020 09:25:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=koNibirYQ1qcFn5x8kD6r8/i82c1OoiMC4YIct99C/A=;
 b=kDjoo/W96A6pTfTKWJ91hQkZ56WRwOU8RUsmcUfOnrYAQ6NpR68zzFHXJYrzM4DiDA
 4xUgKxrOrZIuZoJzmgkL5lQ4IEhIQkU9zgnFh6eTAFYW4urPjenmxKTjBnwPMOl7pen1
 K75+H5aJybgRf1QOr/WpmuRx1pbOV6laUYItPkYebADv/PLFXGS4YP8u5mEys5TOaKCR
 WvvKJlD7c0xxBbdFsZjM87tc0XV4sSbd20gZAUJTwudlq3+LW5tbyAyAEDJ01wX1Gk+B
 OE/o7FN519RXy0pSglcJckfurO9SIr+oAjpYpRoibShst1g5Cs9M4NqkyRHXpX+3go8h
 LUnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=koNibirYQ1qcFn5x8kD6r8/i82c1OoiMC4YIct99C/A=;
 b=EepGLJlYmcDCzr0H6G5Wx9pRCY5W1aeMDe8asEFxQO/CnhE2tivmtOf5W3w+7rufzX
 1o1sBDOUNNXmRjIL1vlNsASTN7k36yE+CGtDlH0BM2YnXITh/5wc8y9kRwAQl04wPD99
 fV+NXh17QC0e5OpJZKTefHWLoF9HeAInw2nNbpdBkJB9ulYa1Qgr07YYY+ED1cyyTjiK
 zmTBGN5jgb6UHbv8jBHDDc7RMA6gtmY/Jvix2G0+8Ayj/ZZXy7dIc+ehqYiI3z6/lDWi
 b0OdiH3ksd60R8wN2G5Rj5wUi4PEkvCtNw8gOLKVQMlB1RHIRmqkfBdWmu9cQ6PqmdTZ
 74qQ==
X-Gm-Message-State: AOAM532HpPb43Pgb/AJiJPgdSiAD8ZzW+IREy5c58wrB3uT7OJzk0J0E
 /B+FtoWTTFKRxdhXuLQyCe/t3w==
X-Google-Smtp-Source: ABdhPJwkLdOiJxa2doj2egCqeXh4iBKM5PN8fOmaGRVEF+h+FB2+wMQyGOJCZ5uh05MT5zkWsQCCKQ==
X-Received: by 2002:adf:df91:: with SMTP id z17mr3912342wrl.149.1596126309830; 
 Thu, 30 Jul 2020 09:25:09 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:109:4a0f:cfff:fe4a:6363])
 by smtp.gmail.com with ESMTPSA id 31sm10492076wrp.87.2020.07.30.09.25.09
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 30 Jul 2020 09:25:09 -0700 (PDT)
Date: Thu, 30 Jul 2020 17:25:04 +0100
From: Andrew Scull <ascull@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 2/2] KVM: arm64: nVHE: Don't consume host SErrors with RAS
Message-ID: <20200730162504.GA1476392@google.com>
References: <20200730151823.1414808-1-ascull@google.com>
 <20200730151823.1414808-2-ascull@google.com>
 <cf05e4e6c427b1c708dff54925ff8a9f@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <cf05e4e6c427b1c708dff54925ff8a9f@kernel.org>
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Thu, Jul 30, 2020 at 05:02:57PM +0100, Marc Zyngier wrote:
> On 2020-07-30 16:18, Andrew Scull wrote:
> > The ESB at the start of the vectors causes any SErrors to be consumed to
> > DISR_EL1. If the exception came from the host and the ESB caught an
> > SError, it would not be noticed until a guest exits and DISR_EL1 is
> > checked. Further, the SError would be attributed to the guest and not
> > the host.
> > 
> > To avoid these problems, use a different exception vector for the host
> > that does not use an ESB but instead leaves any host SError pending. A
> > guest will not be entered if an SError is pending so it will always be
> > the host that will receive and handle it.
> > 
> > Hyp initialization is now passed the vector that is used for the host
> > and the vector for guests is stored in a percpu variable as
> > kvm_get_hyp_vector() is not suitable for calling from nVHE hyp.
> > 
> > Fixes: 0e5b9c085dce ("KVM: arm64: Consume pending SError as early as
> > possible")
> > Cc: James Morse <james.morse@arm.com>
> > Signed-off-by: Andrew Scull <ascull@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_asm.h  |  2 ++
> >  arch/arm64/include/asm/kvm_host.h |  1 +
> >  arch/arm64/kernel/image-vars.h    |  1 +
> >  arch/arm64/kvm/arm.c              | 15 ++++++++++-
> >  arch/arm64/kvm/hyp/hyp-entry.S    | 42 +++++++++++++++++++++++++++++++
> >  arch/arm64/kvm/hyp/nvhe/switch.c  |  3 +++
> >  6 files changed, 63 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/arm64/include/asm/kvm_asm.h
> > b/arch/arm64/include/asm/kvm_asm.h
> > index 413911d6446a..81f29a2c361a 100644
> > --- a/arch/arm64/include/asm/kvm_asm.h
> > +++ b/arch/arm64/include/asm/kvm_asm.h
> > @@ -98,10 +98,12 @@ struct kvm_vcpu;
> >  struct kvm_s2_mmu;
> > 
> >  DECLARE_KVM_NVHE_SYM(__kvm_hyp_init);
> > +DECLARE_KVM_NVHE_SYM(__kvm_hyp_host_vector);
> >  DECLARE_KVM_HYP_SYM(__kvm_hyp_vector);
> > 
> >  #ifndef __KVM_NVHE_HYPERVISOR__
> >  #define __kvm_hyp_init		CHOOSE_NVHE_SYM(__kvm_hyp_init)
> > +#define __kvm_hyp_host_vector	CHOOSE_NVHE_SYM(__kvm_hyp_host_vector)
> >  #define __kvm_hyp_vector	CHOOSE_HYP_SYM(__kvm_hyp_vector)
> >  #endif
> > 
> > diff --git a/arch/arm64/include/asm/kvm_host.h
> > b/arch/arm64/include/asm/kvm_host.h
> > index e1a32c0707bb..6b21d1c71a83 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -575,6 +575,7 @@ void kvm_set_sei_esr(struct kvm_vcpu *vcpu, u64
> > syndrome);
> >  struct kvm_vcpu *kvm_mpidr_to_vcpu(struct kvm *kvm, unsigned long
> > mpidr);
> > 
> >  DECLARE_PER_CPU(kvm_host_data_t, kvm_host_data);
> > +DECLARE_PER_CPU(unsigned long, kvm_hyp_vector);
> > 
> >  static inline void kvm_init_host_cpu_context(struct kvm_cpu_context
> > *cpu_ctxt)
> >  {
> > diff --git a/arch/arm64/kernel/image-vars.h
> > b/arch/arm64/kernel/image-vars.h
> > index 9e897c500237..7e93b0c426d4 100644
> > --- a/arch/arm64/kernel/image-vars.h
> > +++ b/arch/arm64/kernel/image-vars.h
> > @@ -71,6 +71,7 @@ KVM_NVHE_ALIAS(kvm_update_va_mask);
> >  /* Global kernel state accessed by nVHE hyp code. */
> >  KVM_NVHE_ALIAS(arm64_ssbd_callback_required);
> >  KVM_NVHE_ALIAS(kvm_host_data);
> > +KVM_NVHE_ALIAS(kvm_hyp_vector);
> >  KVM_NVHE_ALIAS(kvm_vgic_global_state);
> > 
> >  /* Kernel constant needed to compute idmap addresses. */
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index 98f05bdac3c1..bb7c74b05fcd 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -47,6 +47,7 @@ __asm__(".arch_extension	virt");
> >  #endif
> > 
> >  DEFINE_PER_CPU(kvm_host_data_t, kvm_host_data);
> > +DEFINE_PER_CPU(unsigned long, kvm_hyp_vector);
> >  static DEFINE_PER_CPU(unsigned long, kvm_arm_hyp_stack_page);
> > 
> >  /* The VMID used in the VTTBR */
> > @@ -1274,7 +1275,10 @@ static void cpu_init_hyp_mode(void)
> > 
> >  	pgd_ptr = kvm_mmu_get_httbr();
> >  	hyp_stack_ptr = __this_cpu_read(kvm_arm_hyp_stack_page) + PAGE_SIZE;
> > -	vector_ptr = (unsigned long)kvm_get_hyp_vector();
> > +
> > +	/* Get the hyp address of the vectors used for the host and guests. */
> > +	vector_ptr = (unsigned
> > long)kern_hyp_va(kvm_ksym_ref(__kvm_hyp_host_vector));
> > +	__this_cpu_write(kvm_hyp_vector, (unsigned long)kvm_get_hyp_vector());
> > 
> >  	/*
> >  	 * Call initialization code, and switch to the full blown HYP code.
> > @@ -1537,6 +1541,7 @@ static int init_hyp_mode(void)
> > 
> >  	for_each_possible_cpu(cpu) {
> >  		kvm_host_data_t *cpu_data;
> > +		unsigned long *vector;
> > 
> >  		cpu_data = per_cpu_ptr(&kvm_host_data, cpu);
> >  		err = create_hyp_mappings(cpu_data, cpu_data + 1, PAGE_HYP);
> > @@ -1545,6 +1550,14 @@ static int init_hyp_mode(void)
> >  			kvm_err("Cannot map host CPU state: %d\n", err);
> >  			goto out_err;
> >  		}
> > +
> > +		vector = per_cpu_ptr(&kvm_hyp_vector, cpu);
> > +		err = create_hyp_mappings(vector, vector + 1, PAGE_HYP);
> > +
> > +		if (err) {
> > +			kvm_err("Cannot map hyp guest vector address\n");
> > +			goto out_err;
> > +		}
> >  	}
> > 
> >  	err = hyp_map_aux_data();
> > diff --git a/arch/arm64/kvm/hyp/hyp-entry.S
> > b/arch/arm64/kvm/hyp/hyp-entry.S
> > index 689fccbc9de7..2c5bec3ecb2a 100644
> > --- a/arch/arm64/kvm/hyp/hyp-entry.S
> > +++ b/arch/arm64/kvm/hyp/hyp-entry.S
> > @@ -213,7 +213,10 @@ SYM_CODE_END(\label)
> >  	invalid_vector	el2h_sync_invalid
> >  	invalid_vector	el2h_irq_invalid
> >  	invalid_vector	el2h_fiq_invalid
> > +	invalid_vector	el1_sync_invalid
> > +	invalid_vector	el1_irq_invalid
> >  	invalid_vector	el1_fiq_invalid
> > +	invalid_vector	el1_error_invalid
> > 
> >  	.ltorg
> > 
> > @@ -271,6 +274,45 @@ SYM_CODE_START(__kvm_hyp_vector)
> >  	valid_vect	el1_error		// Error 32-bit EL1
> >  SYM_CODE_END(__kvm_hyp_vector)
> > 
> > +#ifdef __KVM_NVHE_HYPERVISOR__
> > +.macro valid_host_vect target
> > +	.align 7
> > +	stp	x0, x1, [sp, #-16]!
> > +	b	\target
> > +.endm
> > +
> > +/*
> > + * The host vectors do not use an ESB instruction in order to avoid
> > consuming
> > + * SErrors that should only be comsumed by the host. The host is also
> > known to
> > + * be 64-bit so any 32-bit exceptions can be treated as invalid.
> > + *
> > + * Indirection is not applied to the host vectors because the host
> > already
> > + * knows the address of hyp by virtue of loading it there.
> > + */
> > +	.align 11
> > +SYM_CODE_START(__kvm_hyp_host_vector)
> > +	invalid_vect	el2t_sync_invalid	// Synchronous EL2t
> > +	invalid_vect	el2t_irq_invalid	// IRQ EL2t
> > +	invalid_vect	el2t_fiq_invalid	// FIQ EL2t
> > +	invalid_vect	el2t_error_invalid	// Error EL2t
> > +
> > +	valid_host_vect	el2_sync		// Synchronous EL2h
> > +	invalid_vect	el2h_irq_invalid	// IRQ EL2h
> > +	invalid_vect	el2h_fiq_invalid	// FIQ EL2h
> > +	valid_host_vect	el2_error		// Error EL2h
> > +
> > +	valid_host_vect	el1_sync		// Synchronous 64-bit EL1
> 
> I quite like the idea, but it feels like you have stopped short
> of doing interesting things here.
> 
> Since you have started pulling host and guest vectors apart,
> you should be able to do a much better job than what we have
> today when we try to identify the host by looking at vttbr_el2.
> 
> It also means that the macro that pushes things on the stack could
> be removed as we end-up having very different requirements.
> 
> What do you think?

You're right that I've chosen to stop after the fix and haven't gone on
to take some of the obvious refactors that this would allow. The main
reason for this being that the refactoring would, at times, be at odds
with the "host as a vcpu" series [1] that I am also working on.

In that series, the requirements change again so I was planning to look
at how to refactor the series based on this rather than refactor once
now and then again in the series. Let me know if this doesn't seem like
the right approach.

[1] -- https://lore.kernel.org/kvmarm/20200715184438.1390996-1-ascull@google.com/T/#t
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
