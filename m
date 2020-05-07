Return-Path: <SRS0=Tpw5=6V=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D1B3C38A2A
	for <kvmarm@archiver.kernel.org>; Thu,  7 May 2020 13:33:31 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DB6B62075E
	for <kvmarm@archiver.kernel.org>; Thu,  7 May 2020 13:33:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="q8ihiDFW"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DB6B62075E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 45DDB4B227;
	Thu,  7 May 2020 09:33:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Aqhynt7H1T91; Thu,  7 May 2020 09:33:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BF2A84B181;
	Thu,  7 May 2020 09:33:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4B40C4B181
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 May 2020 09:33:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EQeGXNJytJm8 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  7 May 2020 09:33:25 -0400 (EDT)
Received: from mail-wr1-f67.google.com (mail-wr1-f67.google.com
 [209.85.221.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C76F94B0AD
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 May 2020 09:33:25 -0400 (EDT)
Received: by mail-wr1-f67.google.com with SMTP id y4so6395650wrm.11
 for <kvmarm@lists.cs.columbia.edu>; Thu, 07 May 2020 06:33:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=lavJtxKaYcyNLFyKsKYMDkQAHQjwXkcemrxVw4KhSys=;
 b=q8ihiDFWmxPihIUKThUImZ9SqPSGicCB/LUIH7G13GZkNXJykWaCALUvcVkKcfb+OT
 ISMslonAmpBXwKqoCaUXy/3GAeLnAN+2rqT8xag1XdqPbGIC/XX2bVX+EpLC3xHfPwMq
 KgjlZFMT3IBwk6c2lkgefiShIR70gBlf8h9NAwp9ezfG0Y7090yvadbR7daceiHVTn+J
 bLkajrwF3S3sjXshSRI3ocfRGRVetfg+zTEhDD5lrongAN8L8NiUnCeLUxp/NmVDcRV0
 uKQirezMvpbWE1Y5O75qcGmYMuC1EGZt31E/QKZfCRDuKPvxZ5+3aG84W79Zrh/wDhMO
 WXOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=lavJtxKaYcyNLFyKsKYMDkQAHQjwXkcemrxVw4KhSys=;
 b=JaXCfvFrfsMMve0lBq08Z/R0poZNpUfMjgVpQUoZsIRyTXbaXLSVfFlp6M5SNF3ODV
 X9M12+sIeICmjd5M8KAj+MUca4REWPwTntfTw8gmk2aUN2CYaaUhzKEk0zOfDjhWR8GD
 s4NVng5e6rXOjlWk72iF3O7Y7o0A0SkgmelL19AsWB5uOxBrZYsz7ciNV3P76hSLWZJa
 B1P80LGyCQCBXULed+KFDFkEeGsIQuFIABwwdj2JlADlGdbSp/Ml/2+KKkm1VZU2y83R
 u9NpW1LsiNt79Vg1NLvvePVtKLgxOB6IX1C2ogk6JPlsq4jnz8h7/T/Xs4e2T80/qgXy
 j9RQ==
X-Gm-Message-State: AGi0PuYeJd4BvCTYe7j9rm9NuNBaUOoFh801eioLfZViwOPyWzPGFyzH
 a4Bg+j8n5zr7xao33jCnJOm5fg==
X-Google-Smtp-Source: APiQypK1mliJvEiy6KkK4NSYKEudXyeC7ljs0Mrh3EMKeWBt76IU1uAhJMUGJmPyzwky1z5OheEEAA==
X-Received: by 2002:adf:ec09:: with SMTP id x9mr15388355wrn.21.1588858404386; 
 Thu, 07 May 2020 06:33:24 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:110:d6cc:2030:37c1:9964])
 by smtp.gmail.com with ESMTPSA id n6sm8458850wrs.81.2020.05.07.06.33.23
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 07 May 2020 06:33:23 -0700 (PDT)
Date: Thu, 7 May 2020 14:33:20 +0100
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 02/15] arm64: kvm: Formalize host-hyp hypcall ABI
Message-ID: <20200507133320.GA16899@google.com>
References: <20200430144831.59194-1-dbrazdil@google.com>
 <20200430144831.59194-3-dbrazdil@google.com>
 <87d07fj3g9.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87d07fj3g9.wl-maz@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, Will Deacon <will@kernel.org>,
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

Hey Marc,

On Thursday 07 May 2020 at 14:10:30 (+0100), Marc Zyngier wrote:
> Hi David, Quentin,
> 
> On Thu, 30 Apr 2020 15:48:18 +0100,
> David Brazdil <dbrazdil@google.com> wrote:
> > 
> > From: Quentin Perret <qperret@google.com>
> > 
> > In preparation for removing the hyp code from the TCB, convert the current
> 
> nit: Unless we have a different interpretation of the TCB acronym, I
> think you want to remove anything *but* the EL2 code from the TCB.

Argh! Right... This should have been 'removing the /host/ code' :-)

<snip>
> > diff --git a/arch/arm64/include/asm/kvm_host_hypercalls.h b/arch/arm64/include/asm/kvm_host_hypercalls.h
> > new file mode 100644
> > index 000000000000..af8ad505d816
> > --- /dev/null
> > +++ b/arch/arm64/include/asm/kvm_host_hypercalls.h
> > @@ -0,0 +1,62 @@
> > +/* SPDX-License-Identifier: GPL-2.0-only */
> > +/*
> > + * Copyright (C) 2020 Google, inc
> > + */
> > +
> > +#ifndef __KVM_HOST_HCALL
> > +#define __KVM_HOST_HCALL(x)
> > +#endif
> > +
> > +#define __KVM_HOST_HCALL_TABLE_IDX___kvm_enable_ssbs		0
> > +__KVM_HOST_HCALL(__kvm_enable_ssbs)
> > +
> > +#define __KVM_HOST_HCALL_TABLE_IDX___kvm_get_mdcr_el2		1
> > +__KVM_HOST_HCALL(__kvm_get_mdcr_el2)
> > +
> > +#define __KVM_HOST_HCALL_TABLE_IDX___kvm_timer_set_cntvoff	2
> > +__KVM_HOST_HCALL(__kvm_timer_set_cntvoff)
> > +
> > +#define __KVM_HOST_HCALL_TABLE_IDX___kvm_tlb_flush_local_vmid	3
> > +__KVM_HOST_HCALL(__kvm_tlb_flush_local_vmid)
> > +
> > +#define __KVM_HOST_HCALL_TABLE_IDX___kvm_flush_vm_context	4
> > +__KVM_HOST_HCALL(__kvm_flush_vm_context)
> > +
> > +#define __KVM_HOST_HCALL_TABLE_IDX___kvm_vcpu_run_nvhe		5
> > +__KVM_HOST_HCALL(__kvm_vcpu_run_nvhe)
> > +
> > +#define __KVM_HOST_HCALL_TABLE_IDX___kvm_tlb_flush_vmid		6
> > +__KVM_HOST_HCALL(__kvm_tlb_flush_vmid)
> > +
> > +#define __KVM_HOST_HCALL_TABLE_IDX___kvm_tlb_flush_vmid_ipa	7
> > +__KVM_HOST_HCALL(__kvm_tlb_flush_vmid_ipa)
> > +
> > +#define __KVM_HOST_HCALL_TABLE_IDX___vgic_v3_init_lrs		8
> > +__KVM_HOST_HCALL(__vgic_v3_init_lrs)
> > +
> > +#define __KVM_HOST_HCALL_TABLE_IDX___vgic_v3_get_ich_vtr_el2	9
> > +__KVM_HOST_HCALL(__vgic_v3_get_ich_vtr_el2)
> > +
> > +#define __KVM_HOST_HCALL_TABLE_IDX___vgic_v3_write_vmcr		10
> > +__KVM_HOST_HCALL(__vgic_v3_write_vmcr)
> > +
> > +#define __KVM_HOST_HCALL_TABLE_IDX___vgic_v3_restore_aprs	11
> > +__KVM_HOST_HCALL(__vgic_v3_restore_aprs)
> > +
> > +#define __KVM_HOST_HCALL_TABLE_IDX___vgic_v3_read_vmcr		12
> > +__KVM_HOST_HCALL(__vgic_v3_read_vmcr)
> > +
> > +#define __KVM_HOST_HCALL_TABLE_IDX___vgic_v3_save_aprs		13
> > +__KVM_HOST_HCALL(__vgic_v3_save_aprs)
> > +
> > +#define __KVM_HOST_HCALL_TABLE_IDX_SIZE				14
> 
> This whole thing screams "enum" into my ears. Having to maintain these
> as #defines feels like a pain, specially if the numbers are never used
> in assembly code. (and for that, we have asm-offset.h).

This is essentially inspired from the various 'unistd.h' files we have
in the kernel, e.g. include/uapi/asm-generic/unistd.h, which have
exactly this type of construct. So, this was really just for consistency,
but no strong opinion from me.

> 
> > +
> > +/* XXX - Arbitrary offset for KVM-related hypercalls */
> > +#define __KVM_HOST_HCALL_BASE_SHIFT 8
> > +#define __KVM_HOST_HCALL_BASE (1ULL << __KVM_HOST_HCALL_BASE_SHIFT)
> > +#define __KVM_HOST_HCALL_END (__KVM_HOST_HCALL_BASE + \
> > +			      __KVM_HOST_HCALL_TABLE_IDX_SIZE)
> 
> I don't really get what is this offset for. It is too small to be used
> to skip the stub hypercalls (you'd need to start at 0x1000).

Oh, OK. I assumed anything above HVC_STUB_HCALL_NR would be fine. But
yes, this offset is really arbitrary, so if 0x1000 is better then that
totally works. For my education, where is that 0x1000 coming from ?

> Given
> that you store the whole thing in an array, you're wasting some
> memory. I'm sure you have a good story for it though! ;-)

Note that the array's length is __KVM_HOST_HCALL_TABLE_IDX_SIZE, which
doesn't include the offset, so we shouldn't be wasting memory here.

> > +
> > +/* Hypercall number = kvm offset + table idx */
> > +#define KVM_HOST_HCALL_NR(name) (__KVM_HOST_HCALL_TABLE_IDX_##name + \
> > +				 __KVM_HOST_HCALL_BASE)
> > diff --git a/arch/arm64/kvm/hyp/Makefile b/arch/arm64/kvm/hyp/Makefile
> > index 8c9880783839..29e2b2cd2fbc 100644
> > --- a/arch/arm64/kvm/hyp/Makefile
> > +++ b/arch/arm64/kvm/hyp/Makefile
> > @@ -9,7 +9,7 @@ ccflags-y += -fno-stack-protector -DDISABLE_BRANCH_PROFILING \
> >  obj-$(CONFIG_KVM) += hyp.o
> >  
> >  hyp-y := vgic-v3-sr.o timer-sr.o aarch32.o vgic-v2-cpuif-proxy.o sysreg-sr.o \
> > -	 debug-sr.o entry.o switch.o fpsimd.o tlb.o hyp-entry.o
> > +	 debug-sr.o entry.o switch.o fpsimd.o tlb.o host_hypercall.o hyp-entry.o
> >  
> >  # KVM code is run at a different exception code with a different map, so
> >  # compiler instrumentation that inserts callbacks or checks into the code may
> > diff --git a/arch/arm64/kvm/hyp/host_hypercall.c b/arch/arm64/kvm/hyp/host_hypercall.c
> > new file mode 100644
> > index 000000000000..6b31310f36a8
> > --- /dev/null
> > +++ b/arch/arm64/kvm/hyp/host_hypercall.c
> > @@ -0,0 +1,22 @@
> > +// SPDX-License-Identifier: GPL-2.0-only
> > +/*
> > + * Copyright (C) 2020 Google, inc
> > + */
> > +
> > +#include <asm/kvm_hyp.h>
> > +
> > +typedef long (*kvm_hcall_fn_t)(void);
> > +
> > +static long __hyp_text kvm_hc_ni(void)
> > +{
> > +       return -ENOSYS;
> > +}
> > +
> > +#undef __KVM_HOST_HCALL
> > +#define __KVM_HOST_HCALL(name) \
> > +	[__KVM_HOST_HCALL_TABLE_IDX_##name] = (long (*)(void))name,
> > +
> > +const kvm_hcall_fn_t kvm_hcall_table[__KVM_HOST_HCALL_TABLE_IDX_SIZE] = {
> > +	[0 ... __KVM_HOST_HCALL_TABLE_IDX_SIZE-1] = kvm_hc_ni,
> > +#include <asm/kvm_host_hypercalls.h>
> > +};
> 
> Cunning. At the same time, if you can do this once, you can do it
> twice, and generating the __KVM_HOST_HCALL_TABLE_IDX_* as an enum
> should be pretty easy, and could live in its own include file.

Right, and that again is inspired from the arm64 syscall table (see
arch/arm64/kernel/sys.c). So the first intention was to keep things
consistent. But again, no strong opinion :)

> > diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.S
> > index c2a13ab3c471..1a51a0958504 100644
> > --- a/arch/arm64/kvm/hyp/hyp-entry.S
> > +++ b/arch/arm64/kvm/hyp/hyp-entry.S
> > @@ -13,6 +13,7 @@
> >  #include <asm/kvm_arm.h>
> >  #include <asm/kvm_asm.h>
> >  #include <asm/kvm_mmu.h>
> > +#include <asm/kvm_host_hypercalls.h>
> >  #include <asm/mmu.h>
> >  
> >  	.text
> > @@ -21,17 +22,26 @@
> >  .macro do_el2_call
> >  	/*
> >  	 * Shuffle the parameters before calling the function
> > -	 * pointed to in x0. Assumes parameters in x[1,2,3].
> > +	 * pointed to in x0. Assumes parameters in x[1,2,3,4,5,6].
> >  	 */
> >  	str	lr, [sp, #-16]!
> >  	mov	lr, x0
> >  	mov	x0, x1
> >  	mov	x1, x2
> >  	mov	x2, x3
> > +	mov	x3, x4
> > +	mov	x4, x5
> > +	mov	x5, x6
> 
> Has any function changed prototype as part of this patch that they'd
> require this change? It doesn't look like it. I guess this should be
> part of another patch.

Ack, this isn't needed just yet so we should split that out.

> 
> >  	blr	lr
> >  	ldr	lr, [sp], #16
> >  .endm
> >  
> > +/* kern_hyp_va(lm_alias(ksym)) */
> > +.macro ksym_hyp_va ksym, lm_offset
> > +	sub	\ksym, \ksym, \lm_offset
> > +	kern_hyp_va	\ksym
> > +.endm
> > +
> >  el1_sync:				// Guest trapped into EL2
> >  
> >  	mrs	x0, esr_el2
> > @@ -66,10 +76,32 @@ el1_sync:				// Guest trapped into EL2
> >  	br	x5
> >  
> >  1:
> > +	/* Check if the hcall number is valid */
> > +	cmp	x0, #__KVM_HOST_HCALL_BASE
> > +	b.lt	2f
> > +	cmp	x0, #__KVM_HOST_HCALL_END
> > +	b.lt	3f
> > +2:
> > +	mov	x0, -ENOSYS
> > +	eret
> > +
> > +3:
> > +	/* Compute lm_alias() offset in x9 */
> > +	ldr_l	x9, kimage_voffset
> > +	ldr_l	x10, physvirt_offset
> > +	add	x9, x9, x10
> > +
> > +	/* Find hcall function pointer in the table */
> > +	ldr	x10, =kvm_hcall_table
> > +	ksym_hyp_va	x10, x9
> 
> Can't kvm_hcall_table be referenced with adr or adr_l? It'd certainly
> be nice to avoid the extra load for something that is essentially a
> build-time constant.

In fact David already has a nice patch that transforms the whole thing
in a jump table, which is much nicer. I'll let him share the details :)

> Another thing that could be improved is to keep the lm_alias offset
> somewhere, saving one load per entry. Not a huge deal.

Ack.

> > +	sub	x0, x0, #__KVM_HOST_HCALL_BASE
> > +	add	x0, x10, x0, lsl 3
> 
> The usual convention for immediate is to prefix them with #.

Noted, thanks.

> > +	ldr	x0, [x0]
> > +	ksym_hyp_va	x0, x9
> > +
> >  	/*
> >  	 * Perform the EL2 call
> >  	 */
> > -	kern_hyp_va	x0
> >  	do_el2_call
> >  
> >  	eret
> > -- 
> > 2.26.1
> > 
> > 

Thanks for the review!
Quentin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
