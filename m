Return-Path: <SRS0=B0kT=CR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FSL_HELO_FAKE,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11F6CC2BBD0
	for <kvmarm@archiver.kernel.org>; Tue,  8 Sep 2020 10:42:41 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7901E20759
	for <kvmarm@archiver.kernel.org>; Tue,  8 Sep 2020 10:42:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="DpYaNcpI"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7901E20759
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EE9EC4B555;
	Tue,  8 Sep 2020 06:42:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4gJelolZ-zi4; Tue,  8 Sep 2020 06:42:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9248E4B56B;
	Tue,  8 Sep 2020 06:42:38 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 765854B55D
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Sep 2020 06:42:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kup6dalWj2di for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Sep 2020 06:42:36 -0400 (EDT)
Received: from mail-wm1-f65.google.com (mail-wm1-f65.google.com
 [209.85.128.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1BDFD4B555
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Sep 2020 06:42:36 -0400 (EDT)
Received: by mail-wm1-f65.google.com with SMTP id b79so16648218wmb.4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 08 Sep 2020 03:42:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=265gUzEhVdkDTc1wUknbkcd39l2dKp2B/Hto2DQ7EdU=;
 b=DpYaNcpI9kOr+xzq4Vj7MtvOmHpmTrkGwdazXuTIF4qTDNHAyVRj19VeYgv1A6kOpz
 sIhihICaOC0vpgzpdWWMN1lVVOX//Zp2hpWEhkAADr7q9uVuaMeKdB9hZbHpr/gMQKc7
 9lraHWOpvPLFkyepIjwx79k64bemPeoKKPOoIMrlcjt9VCCp9aRdiwQ3mnoBgDNhNpzm
 ts90NV3wYG1m8ClMXnlfgv2vNznTLNaPyiItuvBNrCD3HWPGjc9YkjZ8yyCG0daZH6Pi
 V2KGdjekrZa0/mjEP8rCMIOW3dGHS2JiFnTHq5NobDBZv3AKUKTBIalui9SVG3tYtF1Z
 jLsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=265gUzEhVdkDTc1wUknbkcd39l2dKp2B/Hto2DQ7EdU=;
 b=pi8lIfF6ni19CQDhn4xGTgqeX8Z+p9oPPLkYAGU02/Kd1x+5WoXniCQLB6DMqqNKpH
 mYlpU56CuqRTpCUocEWgrmbG12Hx+IZ0O2VTQ5zJVYT4/5IZrV02lGD4jBMnW0nxWgYg
 Sp6Q/GxQanL9lzHPO15xHZcRapNYIZ1Joj5HFUWIJyo6flxJwoN/WxAq5fB6U+6MLwNU
 TQZUbUhdOi9C+blJq7YkBX3APFyBVkx6posX1YehR8Rxvu5zldgxn4Xc84G8e71vb4dk
 RG31eUsTVDG9hqmcXIfZvYfnDg+Zai4W8U7tgrlM+NAnK/CJ4i3cYir+NTgKZ6/ouxrW
 rqWA==
X-Gm-Message-State: AOAM532eHEIvXO+962TsnCn+m4cH+cdAGXgjRpAJY80arNoFtZTLHi+W
 EUkRKK0/FZtAGeeuEQUCQN9JEg==
X-Google-Smtp-Source: ABdhPJzhurQl1nAnYGpFe9g3ck1GQxtkn+etwuucQaxDjDANBwHc8CjVgIv7xjbKcndq00UIKGtZdQ==
X-Received: by 2002:a05:600c:414b:: with SMTP id
 h11mr3792718wmm.20.1599561754859; 
 Tue, 08 Sep 2020 03:42:34 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:109:4a0f:cfff:fe4a:6363])
 by smtp.gmail.com with ESMTPSA id t6sm8207191wre.30.2020.09.08.03.42.34
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 08 Sep 2020 03:42:34 -0700 (PDT)
Date: Tue, 8 Sep 2020 11:42:29 +0100
From: Andrew Scull <ascull@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v3 12/18] KVM: arm64: nVHE: Switch to hyp context for EL2
Message-ID: <20200908104229.GC3268721@google.com>
References: <20200903135307.251331-1-ascull@google.com>
 <20200903135307.251331-13-ascull@google.com>
 <87v9gploxt.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87v9gploxt.wl-maz@kernel.org>
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

On Mon, Sep 07, 2020 at 02:02:54PM +0100, Marc Zyngier wrote:
> Hi Andrew,
> 
> On Thu, 03 Sep 2020 14:53:01 +0100,
> Andrew Scull <ascull@google.com> wrote:
> > 
> > Save and restore the host context when switching to and from hyp. This
> > gives hyp its own context that the host will not see as a step towards a
> > full trust boundary between the two.
> > 
> > SP_EL0 and pointer authentication keys are currently shared between the
> > host and hyp so don't need to be switched yet.
> > 
> > Signed-off-by: Andrew Scull <ascull@google.com>
> > ---
> >  arch/arm64/kvm/hyp/include/hyp/switch.h |  2 +
> >  arch/arm64/kvm/hyp/nvhe/Makefile        |  2 +-
> >  arch/arm64/kvm/hyp/nvhe/host.S          | 68 ++++++++++++++++++-------
> >  arch/arm64/kvm/hyp/nvhe/hyp-main.c      | 35 +++++++++++++
> >  4 files changed, 88 insertions(+), 19 deletions(-)
> >  create mode 100644 arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > 
> > diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
> > index 821721b78ad9..4536b50ddc06 100644
> > --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> > +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> > @@ -372,6 +372,8 @@ static inline bool esr_is_ptrauth_trap(u32 esr)
> >  	ctxt_sys_reg(ctxt, key ## KEYHI_EL1) = __val;                   \
> >  } while(0)
> >  
> > +DECLARE_PER_CPU(struct kvm_cpu_context, kvm_hyp_ctxt);
> > +
> >  static inline bool __hyp_handle_ptrauth(struct kvm_vcpu *vcpu)
> >  {
> >  	struct kvm_cpu_context *ctxt;
> > diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
> > index ddf98eb07b9d..46c89e8c30bc 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/Makefile
> > +++ b/arch/arm64/kvm/hyp/nvhe/Makefile
> > @@ -6,7 +6,7 @@
> >  asflags-y := -D__KVM_NVHE_HYPERVISOR__
> >  ccflags-y := -D__KVM_NVHE_HYPERVISOR__
> >  
> > -obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o hyp-init.o host.o
> > +obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o hyp-init.o host.o hyp-main.o
> >  obj-y += ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../entry.o \
> >  	 ../fpsimd.o ../hyp-entry.o
> >  
> > diff --git a/arch/arm64/kvm/hyp/nvhe/host.S b/arch/arm64/kvm/hyp/nvhe/host.S
> > index d4e8b8084020..1062547853db 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/host.S
> > +++ b/arch/arm64/kvm/hyp/nvhe/host.S
> > @@ -12,6 +12,55 @@
> >  
> >  	.text
> >  
> > +SYM_FUNC_START(__host_exit)
> > +	stp	x0, x1, [sp, #-16]!
> > +
> > +	get_host_ctxt	x0, x1
> > +
> > +	ALTERNATIVE(nop, SET_PSTATE_PAN(1), ARM64_HAS_PAN, CONFIG_ARM64_PAN)
> > +
> > +	/* Store the guest regs x2 and x3 */
> 
> These comments are massively confusing. Please stick with the
> conventional KVM terminology, where the host isn't a guest.

Done, this was a copy-paste failing rather than intentional.

> > +	stp	x2, x3,   [x0, #CPU_XREG_OFFSET(2)]
> > +
> > +	/* Retrieve the guest regs x0-x1 from the stack */
> > +	ldp	x2, x3, [sp], #16	// x0, x1
> > +
> > +	// Store the guest regs x0-x1 and x4-x17
> > +	stp	x2, x3,   [x0, #CPU_XREG_OFFSET(0)]
> > +	stp	x4, x5,   [x0, #CPU_XREG_OFFSET(4)]
> > +	stp	x6, x7,   [x0, #CPU_XREG_OFFSET(6)]
> > +	stp	x8, x9,   [x0, #CPU_XREG_OFFSET(8)]
> > +	stp	x10, x11, [x0, #CPU_XREG_OFFSET(10)]
> > +	stp	x12, x13, [x0, #CPU_XREG_OFFSET(12)]
> > +	stp	x14, x15, [x0, #CPU_XREG_OFFSET(14)]
> > +	stp	x16, x17, [x0, #CPU_XREG_OFFSET(16)]
> > +
> > +	/* Store the guest regs x18-x29, lr */
> > +	save_callee_saved_regs x0
> > +
> > +	/* Save the host context pointer in x29 across the function call */
> > +	mov	x29, x0
> > +	bl	handle_trap
> > +
> > +	/* Restore guest regs x0-x17 */
> > +	ldp	x0, x1,   [x29, #CPU_XREG_OFFSET(0)]
> > +	ldp	x2, x3,   [x29, #CPU_XREG_OFFSET(2)]
> > +	ldp	x4, x5,   [x29, #CPU_XREG_OFFSET(4)]
> > +	ldp	x6, x7,   [x29, #CPU_XREG_OFFSET(6)]
> > +	ldp	x8, x9,   [x29, #CPU_XREG_OFFSET(8)]
> > +	ldp	x10, x11, [x29, #CPU_XREG_OFFSET(10)]
> > +	ldp	x12, x13, [x29, #CPU_XREG_OFFSET(12)]
> > +	ldp	x14, x15, [x29, #CPU_XREG_OFFSET(14)]
> > +	ldp	x16, x17, [x29, #CPU_XREG_OFFSET(16)]
> > +
> > +	/* Restore guest regs x18-x29, lr */
> > +	restore_callee_saved_regs x29
> 
> This is a lot of save/restoring on each and every HVC. And I fear that
> at some stage, you will want to restore some EL2-specific registers
> too, adding even more to the overhead.
> 
> I'll have a go a measuring by how much we regress with this.

This is the main part of the series, to add a separate context for hyp
that needs switching. I was seeing about 5% from this change for the
HVC micro-benchmark but it would be good to have it measured on a range
of machines.

There may be some tricks that can be played such as not explicitly
saving callee saved registers, since they should be saved by the calling
convention. We did this in Hafnium but it meant there were times that it
was awkward to know where to find the true state.

Once we have a better idea of the overhead, we might have a better idea
of where to draw the line for tradeoffs between performance and
maintainance?

> > +
> > +	/* Do not touch any register after this! */
> > +	eret
> > +	sb
> > +SYM_FUNC_END(__host_exit)
> > +
> >  SYM_FUNC_START(__hyp_do_panic)
> >  	mov	lr, #(PSR_F_BIT | PSR_I_BIT | PSR_A_BIT | PSR_D_BIT |\
> >  		      PSR_MODE_EL1h)
> > @@ -35,7 +84,7 @@ SYM_FUNC_END(__hyp_do_panic)
> >  
> >  	/* Check for a stub HVC call */
> >  	cmp	x0, #HVC_STUB_HCALL_NR
> > -	b.hs	1f
> > +	b.hs	__host_exit
> >  
> >  	/*
> >  	 * Compute the idmap address of __kvm_handle_stub_hvc and
> > @@ -51,23 +100,6 @@ SYM_FUNC_END(__hyp_do_panic)
> >  	/* x5 = __pa(x5) */
> >  	sub	x5, x5, x6
> >  	br	x5
> > -
> > -1:
> > -	/*
> > -	 * Shuffle the parameters before calling the function
> > -	 * pointed to in x0. Assumes parameters in x[1,2,3].
> > -	 */
> > -	kern_hyp_va	x0
> > -	str	lr, [sp, #-16]!
> > -	mov	lr, x0
> > -	mov	x0, x1
> > -	mov	x1, x2
> > -	mov	x2, x3
> > -	blr	lr
> > -	ldr	lr, [sp], #16
> > -
> > -	eret
> > -	sb
> >  .endm
> >  
> >  .macro invalid_host_vect
> > diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > new file mode 100644
> > index 000000000000..c8938e09f585
> > --- /dev/null
> > +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > @@ -0,0 +1,35 @@
> > +// SPDX-License-Identifier: GPL-2.0-only
> > +/*
> > + * Copyright (C) 2020 - Google Inc
> > + * Author: Andrew Scull <ascull@google.com>
> > + */
> > +
> > +#include <hyp/switch.h>
> > +
> > +#include <asm/kvm_asm.h>
> > +#include <asm/kvm_emulate.h>
> > +#include <asm/kvm_host.h>
> > +#include <asm/kvm_hyp.h>
> > +#include <asm/kvm_mmu.h>
> > +
> > +typedef unsigned long (*hypcall_fn_t)
> > +	(unsigned long, unsigned long, unsigned long);
> > +
> > +void handle_trap(struct kvm_cpu_context *host_ctxt) {
> 
> Coding style.

Done.

> > +	u64 esr = read_sysreg_el2(SYS_ESR);
> > +	hypcall_fn_t func;
> > +	unsigned long ret;
> > +
> > +	if (ESR_ELx_EC(esr) != ESR_ELx_EC_HVC64)
> > +		hyp_panic();
> > +
> > +	/*
> > +	 * __kvm_call_hyp takes a pointer in the host address space and
> > +	 * up to three arguments.
> > +	 */
> > +	func = (hypcall_fn_t)kern_hyp_va(host_ctxt->regs.regs[0]);
> > +	ret = func(host_ctxt->regs.regs[1],
> > +		   host_ctxt->regs.regs[2],
> > +		   host_ctxt->regs.regs[3]);
> > +	host_ctxt->regs.regs[0] = ret;
> > +}
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
