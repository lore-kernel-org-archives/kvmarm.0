Return-Path: <SRS0=B0kT=CR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FSL_HELO_FAKE,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7203C433E2
	for <kvmarm@archiver.kernel.org>; Tue,  8 Sep 2020 10:29:49 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5D9ED208C7
	for <kvmarm@archiver.kernel.org>; Tue,  8 Sep 2020 10:29:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="X9Xv9wG3"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5D9ED208C7
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D028B4B5A3;
	Tue,  8 Sep 2020 06:29:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id u3oKDv+CMM5f; Tue,  8 Sep 2020 06:29:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6368A4B5A4;
	Tue,  8 Sep 2020 06:29:47 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 43F684B5A2
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Sep 2020 06:29:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VHvkJd6otofs for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Sep 2020 06:29:44 -0400 (EDT)
Received: from mail-wr1-f65.google.com (mail-wr1-f65.google.com
 [209.85.221.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A47FD4B452
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Sep 2020 06:29:44 -0400 (EDT)
Received: by mail-wr1-f65.google.com with SMTP id s12so141857wrw.11
 for <kvmarm@lists.cs.columbia.edu>; Tue, 08 Sep 2020 03:29:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=Ww+JbIoqw4LDpz+y1W2JhklH7t80cVduU4Qn0uN+fcw=;
 b=X9Xv9wG3CQ5N2AqrjiXbo04NtzyONrvuNC06GeaEDyfi/RsuZ171jG4IxmZ9VbMtzs
 yynMgAyUUx8oTxaOYCubrNloze56/stEdlNUhOZR/zDdxiE+M9JBHKa2OOvyfws08qe9
 VEwU9JZbtu+Gef4+DdHeGG2rdDuZQ5cCo8zDKk1PxrbVrDZM9BThJBu42h0hHm1BV4Nj
 SZNxN0Nfj9rNAWXOnQE3IG9GYQqDzEWFNrwyMRarxuk4mrunnQTb/nYgxTgFNF3VajBh
 8RuIcD0JEVgjlIo9tagMGxHaK9b6spIqogxOMVwDfvqpJtLzOE1fWZkpIy2RMU0BOL13
 Sc5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=Ww+JbIoqw4LDpz+y1W2JhklH7t80cVduU4Qn0uN+fcw=;
 b=odA5G+oVJeb5pcFlnle/Gv4/IU73bk58mAIKb1CbKKGrJ+bNe+fS5eaJc6LZNErYo1
 yOq1UEVwlP8i2NNwoo9K+OMnoVBKFCtbSuplHdPG/vMNldKwYpUmmqn1o1YqpLK25xvx
 S7qru0ar1Lxn2p71Gba2IUXcAgOouUFMMtmByPEGfvFffaJV+qDyxBC90h6Um/LJrByy
 zaYYwNDszwt1Q/xL1D2Dr9FVuk9v793ZGH7D281OJAoQjz7vXYYUwBB/PyeMlm32+rhI
 vWGtfyV+RdaihwsfevGdosO2GIYttOQYSGgdqzZ4A90Nmyl0RGDE8Eq4V2kTwlynqe22
 1uKQ==
X-Gm-Message-State: AOAM5338aV+adTqlEcNtqL2ClAazM8cbAu3P3cfpj6jC++0lCsZ6Avo6
 S1okH0Zx3+goKfFIu54gw8gHUA==
X-Google-Smtp-Source: ABdhPJxaXa0SlHdVHqC9Rs2niAP9SWM8QKBYvq87xpZo909CezL8n2SQB95CZZM0R+TvtvNtA4FthA==
X-Received: by 2002:a5d:4081:: with SMTP id o1mr9154576wrp.338.1599560983371; 
 Tue, 08 Sep 2020 03:29:43 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:109:4a0f:cfff:fe4a:6363])
 by smtp.gmail.com with ESMTPSA id z11sm33152904wru.88.2020.09.08.03.29.42
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 08 Sep 2020 03:29:42 -0700 (PDT)
Date: Tue, 8 Sep 2020 11:29:38 +0100
From: Andrew Scull <ascull@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v3 06/18] KVM: arm64: nVHE: Use separate vector for the
 host
Message-ID: <20200908102938.GB3268721@google.com>
References: <20200903135307.251331-1-ascull@google.com>
 <20200903135307.251331-7-ascull@google.com>
 <87y2lllsu1.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87y2lllsu1.wl-maz@kernel.org>
Cc: kernel-team@android.com, catalin.marinas@arm.com,
 linux-arm-kernel@lists.infradead.org, Sudeep Holla <sudeep.holla@arm.com>,
 will@kernel.org, kvmarm@lists.cs.columbia.edu
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

On Mon, Sep 07, 2020 at 12:38:46PM +0100, Marc Zyngier wrote:
> Hi Andrew,
> 
> On Thu, 03 Sep 2020 14:52:55 +0100,
> Andrew Scull <ascull@google.com> wrote:
> > 
> > The host is treated differently from the guests when an exception is
> > taken so introduce a separate vector that is specialized for the host.
> > This also allows the nVHE specific code to move out of hyp-entry.S and
> > into nvhe/host.S.
> > 
> > The host is only expected to make HVC calls and anything else is
> > considered invalid and results in a panic.
> > 
> > Hyp initialization is now passed the vector that is used for the host
> > and it is swapped for the guest vector during the context switch.
> > 
> > Signed-off-by: Andrew Scull <ascull@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_asm.h |   2 +
> >  arch/arm64/kernel/image-vars.h   |   1 +
> >  arch/arm64/kvm/arm.c             |  11 +++-
> >  arch/arm64/kvm/hyp/hyp-entry.S   |  66 --------------------
> >  arch/arm64/kvm/hyp/nvhe/Makefile |   2 +-
> >  arch/arm64/kvm/hyp/nvhe/host.S   | 104 +++++++++++++++++++++++++++++++
> >  arch/arm64/kvm/hyp/nvhe/switch.c |   3 +
> >  7 files changed, 121 insertions(+), 68 deletions(-)
> >  create mode 100644 arch/arm64/kvm/hyp/nvhe/host.S
> > 
> > diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
> > index 6f9c4162a764..34ec1b558219 100644
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
> > diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
> > index 8982b68289b7..54bb0eb34b0f 100644
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
> > index 77fc856ea513..b6442c6be5ad 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -1277,7 +1277,7 @@ static void cpu_init_hyp_mode(void)
> >  
> >  	pgd_ptr = kvm_mmu_get_httbr();
> >  	hyp_stack_ptr = __this_cpu_read(kvm_arm_hyp_stack_page) + PAGE_SIZE;
> > -	vector_ptr = __this_cpu_read(kvm_hyp_vector);
> > +	vector_ptr = (unsigned long)kern_hyp_va(kvm_ksym_ref(__kvm_hyp_host_vector));
> >  
> >  	/*
> >  	 * Call initialization code, and switch to the full blown HYP code.
> > @@ -1542,6 +1542,7 @@ static int init_hyp_mode(void)
> >  
> >  	for_each_possible_cpu(cpu) {
> >  		struct kvm_host_data *cpu_data;
> > +		unsigned long *vector;
> >  
> >  		cpu_data = per_cpu_ptr(&kvm_host_data, cpu);
> >  		err = create_hyp_mappings(cpu_data, cpu_data + 1, PAGE_HYP);
> > @@ -1550,6 +1551,14 @@ static int init_hyp_mode(void)
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
> > diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.S
> > index 9cb3fbca5d79..f92489250dfc 100644
> > --- a/arch/arm64/kvm/hyp/hyp-entry.S
> > +++ b/arch/arm64/kvm/hyp/hyp-entry.S
> > @@ -12,7 +12,6 @@
> >  #include <asm/cpufeature.h>
> >  #include <asm/kvm_arm.h>
> >  #include <asm/kvm_asm.h>
> > -#include <asm/kvm_mmu.h>
> >  #include <asm/mmu.h>
> >  
> >  .macro save_caller_saved_regs_vect
> > @@ -41,20 +40,6 @@
> >  
> >  	.text
> >  
> > -.macro do_el2_call
> > -	/*
> > -	 * Shuffle the parameters before calling the function
> > -	 * pointed to in x0. Assumes parameters in x[1,2,3].
> > -	 */
> > -	str	lr, [sp, #-16]!
> > -	mov	lr, x0
> > -	mov	x0, x1
> > -	mov	x1, x2
> > -	mov	x2, x3
> > -	blr	lr
> > -	ldr	lr, [sp], #16
> > -.endm
> > -
> >  el1_sync:				// Guest trapped into EL2
> >  
> >  	mrs	x0, esr_el2
> > @@ -63,44 +48,6 @@ el1_sync:				// Guest trapped into EL2
> >  	ccmp	x0, #ESR_ELx_EC_HVC32, #4, ne
> >  	b.ne	el1_trap
> >  
> > -#ifdef __KVM_NVHE_HYPERVISOR__
> > -	mrs	x1, vttbr_el2		// If vttbr is valid, the guest
> > -	cbnz	x1, el1_hvc_guest	// called HVC
> > -
> > -	/* Here, we're pretty sure the host called HVC. */
> > -	ldp	x0, x1, [sp], #16
> > -
> > -	/* Check for a stub HVC call */
> > -	cmp	x0, #HVC_STUB_HCALL_NR
> > -	b.hs	1f
> > -
> > -	/*
> > -	 * Compute the idmap address of __kvm_handle_stub_hvc and
> > -	 * jump there. Since we use kimage_voffset, do not use the
> > -	 * HYP VA for __kvm_handle_stub_hvc, but the kernel VA instead
> > -	 * (by loading it from the constant pool).
> > -	 *
> > -	 * Preserve x0-x4, which may contain stub parameters.
> > -	 */
> > -	ldr	x5, =__kvm_handle_stub_hvc
> > -	ldr_l	x6, kimage_voffset
> > -
> > -	/* x5 = __pa(x5) */
> > -	sub	x5, x5, x6
> > -	br	x5
> > -
> > -1:
> > -	/*
> > -	 * Perform the EL2 call
> > -	 */
> > -	kern_hyp_va	x0
> > -	do_el2_call
> > -
> > -	eret
> > -	sb
> > -#endif /* __KVM_NVHE_HYPERVISOR__ */
> > -
> > -el1_hvc_guest:
> >  	/*
> >  	 * Fastest possible path for ARM_SMCCC_ARCH_WORKAROUND_1.
> >  	 * The workaround has already been applied on the host,
> > @@ -198,18 +145,6 @@ el2_error:
> >  	eret
> >  	sb
> >  
> > -#ifdef __KVM_NVHE_HYPERVISOR__
> > -SYM_FUNC_START(__hyp_do_panic)
> > -	mov	lr, #(PSR_F_BIT | PSR_I_BIT | PSR_A_BIT | PSR_D_BIT |\
> > -		      PSR_MODE_EL1h)
> > -	msr	spsr_el2, lr
> > -	ldr	lr, =panic
> > -	msr	elr_el2, lr
> > -	eret
> > -	sb
> > -SYM_FUNC_END(__hyp_do_panic)
> > -#endif
> > -
> >  .macro invalid_vector	label, target = hyp_panic
> >  	.align	2
> >  SYM_CODE_START(\label)
> > @@ -222,7 +157,6 @@ SYM_CODE_END(\label)
> >  	invalid_vector	el2t_irq_invalid
> >  	invalid_vector	el2t_fiq_invalid
> >  	invalid_vector	el2t_error_invalid
> > -	invalid_vector	el2h_sync_invalid
> >  	invalid_vector	el2h_irq_invalid
> >  	invalid_vector	el2h_fiq_invalid
> >  	invalid_vector	el1_fiq_invalid
> > diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
> > index aef76487edc2..ddf98eb07b9d 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/Makefile
> > +++ b/arch/arm64/kvm/hyp/nvhe/Makefile
> > @@ -6,7 +6,7 @@
> >  asflags-y := -D__KVM_NVHE_HYPERVISOR__
> >  ccflags-y := -D__KVM_NVHE_HYPERVISOR__
> >  
> > -obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o hyp-init.o
> > +obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o hyp-init.o host.o
> >  obj-y += ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../entry.o \
> >  	 ../fpsimd.o ../hyp-entry.o
> >  
> > diff --git a/arch/arm64/kvm/hyp/nvhe/host.S b/arch/arm64/kvm/hyp/nvhe/host.S
> > new file mode 100644
> > index 000000000000..9c96b9a3b71d
> > --- /dev/null
> > +++ b/arch/arm64/kvm/hyp/nvhe/host.S
> > @@ -0,0 +1,104 @@
> > +/* SPDX-License-Identifier: GPL-2.0-only */
> > +/*
> > + * Copyright (C) 2020 - Google Inc
> > + * Author: Andrew Scull <ascull@google.com>
> > + */
> > +
> > +#include <linux/linkage.h>
> > +
> > +#include <asm/assembler.h>
> > +#include <asm/kvm_asm.h>
> > +#include <asm/kvm_mmu.h>
> > +
> > +	.text
> > +
> > +SYM_FUNC_START(__hyp_do_panic)
> > +	mov	lr, #(PSR_F_BIT | PSR_I_BIT | PSR_A_BIT | PSR_D_BIT |\
> > +		      PSR_MODE_EL1h)
> > +	msr	spsr_el2, lr
> > +	ldr	lr, =panic
> > +	msr	elr_el2, lr
> > +	eret
> > +	sb
> > +SYM_FUNC_END(__hyp_do_panic)
> > +
> > +.macro valid_host_el1_sync_vect
> 
> Do we actually need the "valid_" prefix? The invalid stuff is prefixed
> as invalid already. Something like el1_sync_host would be good enough
> IMHO.

It's just a name; dropped the prefix.

> > +	.align 7
> > +	esb
> > +	stp	x0, x1, [sp, #-16]!
> > +
> > +	mrs	x0, esr_el2
> > +	lsr	x0, x0, #ESR_ELx_EC_SHIFT
> > +	cmp	x0, #ESR_ELx_EC_HVC64
> > +	b.ne	hyp_panic
> > +
> > +	ldp	x0, x1, [sp], #16
> 
> You probably want to restore x0/x1 before branching to hyp_panic. At
> least your stack pointer will be correct, and x0/x1 may contain
> interesting stuff (not that it matters much at the moment, but I'm
> hopeful that at some point we will have a better panic handling).

Right, I had that in a later patch but it belongs here. Moved the LDP
between the CMP and branch.

	.align 7
	esb
	stp	x0, x1, [sp, #-16]!
	mrs	x0, esr_el2
	lsr	x0, x0, #ESR_ELx_EC_SHIFT
	cmp	x0, #ESR_ELx_EC_HVC64
	ldp	x0, x1, [sp], #16
	b.ne	hyp_panic

> > +
> > +	/* Check for a stub HVC call */
> > +	cmp	x0, #HVC_STUB_HCALL_NR
> > +	b.hs	1f
> > +
> > +	/*
> > +	 * Compute the idmap address of __kvm_handle_stub_hvc and
> > +	 * jump there. Since we use kimage_voffset, do not use the
> > +	 * HYP VA for __kvm_handle_stub_hvc, but the kernel VA instead
> > +	 * (by loading it from the constant pool).
> > +	 *
> > +	 * Preserve x0-x4, which may contain stub parameters.
> > +	 */
> > +	ldr	x5, =__kvm_handle_stub_hvc
> > +	ldr_l	x6, kimage_voffset
> > +
> > +	/* x5 = __pa(x5) */
> > +	sub	x5, x5, x6
> > +	br	x5
> > +
> > +1:
> > +	/*
> > +	 * Shuffle the parameters before calling the function
> > +	 * pointed to in x0. Assumes parameters in x[1,2,3].
> > +	 */
> > +	kern_hyp_va	x0
> > +	str	lr, [sp, #-16]!
> > +	mov	lr, x0
> > +	mov	x0, x1
> > +	mov	x1, x2
> > +	mov	x2, x3
> > +	blr	lr
> > +	ldr	lr, [sp], #16
> > +
> > +	eret
> > +	sb
> 
> Please add some checks to ensure that this macro never grows past 128
> bytes, which is all you can fit in a single vector entry. Something
> like
> 
> 	.org valid_host_el1_sync_vect + 0x80
> 
> should do the trick (the assembler will shout at you if you move the
> pointer backward in the case the macro becomes too long).

Gave it an explicit measurement check.

+.macro host_el1_sync_vect
+	.align 7
+.L__vect_start\@:
+	esb
+	stp	x0, x1, [sp, #-16]!
     ...
+	eret
+	sb
+.L__vect_end\@:
+.if ((.L__vect_end\@ - .L__vect_start\@) > 0x80)
+	.error "host_el1_sync_vect larger than vector entry"
+.endif
+.endm

> > +.endm
> > +
> > +.macro invalid_host_vect
> > +	.align 7
> > +	b	hyp_panic
> > +.endm
> > +
> > +/*
> > + * CONFIG_KVM_INDIRECT_VECTORS is not applied to the host vector because the
> 
> nit: s/vector/vectors/

Done.

> > + * host already knows the address of hyp by virtue of loading it there.
> 
> I find this comment a bit confusing (and I'm easily confused). How
> about:
> 
> "... because the host knows about the EL2 vectors already, and there is
> no point in hiding them"?

Done.

> > + */
> > +	.align 11
> > +SYM_CODE_START(__kvm_hyp_host_vector)
> > +	invalid_host_vect			// Synchronous EL2t
> > +	invalid_host_vect			// IRQ EL2t
> > +	invalid_host_vect			// FIQ EL2t
> > +	invalid_host_vect			// Error EL2t
> > +
> > +	invalid_host_vect			// Synchronous EL2h
> > +	invalid_host_vect			// IRQ EL2h
> > +	invalid_host_vect			// FIQ EL2h
> > +	invalid_host_vect			// Error EL2h
> > +
> > +	valid_host_el1_sync_vect		// Synchronous 64-bit EL1
> > +	invalid_host_vect			// IRQ 64-bit EL1
> > +	invalid_host_vect			// FIQ 64-bit EL1
> > +	invalid_host_vect			// Error 64-bit EL1
> > +
> > +	invalid_host_vect			// Synchronous 32-bit EL1
> > +	invalid_host_vect			// IRQ 32-bit EL1
> > +	invalid_host_vect			// FIQ 32-bit EL1
> > +	invalid_host_vect			// Error 32-bit EL1
> > +SYM_CODE_END(__kvm_hyp_host_vector)
> > diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
> > index 1e8a31b7c94c..1ab773bb60ca 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/switch.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/switch.c
> > @@ -42,6 +42,7 @@ static void __activate_traps(struct kvm_vcpu *vcpu)
> >  	}
> >  
> >  	write_sysreg(val, cptr_el2);
> > +	write_sysreg(__hyp_this_cpu_read(kvm_hyp_vector), vbar_el2);
> 
> There is still the pending question of whether this requires extra
> synchronisation, but at least this becomes a problem common to both
> VHE and nVHE.

It does require an ISB to make the vectors change here and now or else,
up until the ERET, either vector could be active. I've tried to keep
this in mind so that both the host and guest vectors can handle this
transition period.

> >  
> >  	if (cpus_have_final_cap(ARM64_WORKAROUND_SPECULATIVE_AT)) {
> >  		struct kvm_cpu_context *ctxt = &vcpu->arch.ctxt;
> > @@ -60,6 +61,7 @@ static void __activate_traps(struct kvm_vcpu *vcpu)
> >  
> >  static void __deactivate_traps(struct kvm_vcpu *vcpu)
> >  {
> > +	extern char __kvm_hyp_host_vector[];
> >  	u64 mdcr_el2;
> >  
> >  	___deactivate_traps(vcpu);
> > @@ -91,6 +93,7 @@ static void __deactivate_traps(struct kvm_vcpu *vcpu)
> >  	write_sysreg(mdcr_el2, mdcr_el2);
> >  	write_sysreg(HCR_HOST_NVHE_FLAGS, hcr_el2);
> >  	write_sysreg(CPTR_EL2_DEFAULT, cptr_el2);
> > +	write_sysreg(__kvm_hyp_host_vector, vbar_el2);
> >  }
> >  
> >  static void __load_host_stage2(void)
> > -- 
> > 2.28.0.402.g5ffc5be6b7-goog
> > 
> > 
> 
> Thanks,
> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
