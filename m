Return-Path: <SRS0=coVF=A7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BCABC433DF
	for <kvmarm@archiver.kernel.org>; Mon, 20 Jul 2020 14:14:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D1E6520B1F
	for <kvmarm@archiver.kernel.org>; Mon, 20 Jul 2020 14:14:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="XB8J45D2"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D1E6520B1F
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0CAAC4B1C4;
	Mon, 20 Jul 2020 10:14:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id apZFtOlILQH8; Mon, 20 Jul 2020 10:13:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CF1604B1BA;
	Mon, 20 Jul 2020 10:13:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C321A4B1AD
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Jul 2020 10:13:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IEvtd6GqashL for <kvmarm@lists.cs.columbia.edu>;
 Mon, 20 Jul 2020 10:13:56 -0400 (EDT)
Received: from mail-wr1-f65.google.com (mail-wr1-f65.google.com
 [209.85.221.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7A8A64B1AB
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Jul 2020 10:13:56 -0400 (EDT)
Received: by mail-wr1-f65.google.com with SMTP id s10so17969205wrw.12
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Jul 2020 07:13:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=QyKpzZOepKKW48F/gIgT29VMJG4xl/KDrvrYO/Nr5PI=;
 b=XB8J45D21DMmwDapAVIfc1rKwW3tX5vgbkODHb5LBXaMftAAwpFp47KxszTicP+i4t
 my6VveJF3iGRYlUDL6RL6Dh7VLIgg2Fb0dywgAh97dF83wizCYwZwjEVaTPDv+iB+yJm
 oA3QVyEqLtFBQZVF2iWAoHh4eC+oZ+PHNqR4YDXGPYwoPPv3voKzjCT5veBiI9YUKXcx
 kPqaYNGt20QWJvrQUUDtPkwUl30MGojpZ+EroBYTA7UOyh2vO/q2RE0ex/IvfbVRWfP1
 dpFoIvGpGJT0huf9bCCI15hguwWw3i569MiCL2OzCJ4oRHelUlyeq+ZpYyTEhx9oPZby
 Df+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=QyKpzZOepKKW48F/gIgT29VMJG4xl/KDrvrYO/Nr5PI=;
 b=Zsc7j3DYaJN+Sf6Flj6WPs3EJdlGenkjix9/tp6/jAGKIXC+tQpQVfM01Qo/HZxSnl
 hnHpDMXEIsfkVUfFfI5FpMkhJNmtxtK2Fa6arJRkwjojxIvCpAnfOjTmufk3fzXpLTUY
 kVPN0ePRrr+7ZP8+Fnj/Ttny/xjdRrz0374WL0mxwTDytOZvMOj4BW4ereXVtbvAT+43
 hJruz7qym/Nnn8lYeExJdiTUL9BrhSvwTqM2b5gy5iAuymuojwwUduPeHjKlOFNYM506
 DEmZV1OB9D6IdA8CgNlm6KNKDHQqdmJVOHmHpba7PdRdP933giMKpxzzCiOyNfiY4zN+
 fnlA==
X-Gm-Message-State: AOAM532Lxo1/kDxu8fkl3FgPqFFdYAcoP/S8chpW/ojMAiHmzsgnoOFF
 dPsvdzgfx9wZl8Cmiw8rJ7sMKg==
X-Google-Smtp-Source: ABdhPJxn649Ie9siOEZeeNG4GiLMBTmQy9Z7eL0bjrjUnTjN+DEcssfpGzdrGzzD0yBDXmPQfJt6LQ==
X-Received: by 2002:a5d:4947:: with SMTP id r7mr9374499wrs.165.1595254435096; 
 Mon, 20 Jul 2020 07:13:55 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:109:4a0f:cfff:fe4a:6363])
 by smtp.gmail.com with ESMTPSA id 2sm31851560wmo.44.2020.07.20.07.13.54
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 20 Jul 2020 07:13:54 -0700 (PDT)
Date: Mon, 20 Jul 2020 15:13:49 +0100
From: Andrew Scull <ascull@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 07/37] KVM: arm64: Separate SError detection from VAXorcism
Message-ID: <20200720141349.GA2179496@google.com>
References: <20200715184438.1390996-1-ascull@google.com>
 <20200715184438.1390996-8-ascull@google.com>
 <87a6zxxknl.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87a6zxxknl.wl-maz@kernel.org>
Cc: kernel-team@android.com, kvmarm@lists.cs.columbia.edu
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

On Sat, Jul 18, 2020 at 10:00:30AM +0100, Marc Zyngier wrote:
> Hi Andrew,
> 
> On Wed, 15 Jul 2020 19:44:08 +0100,
> Andrew Scull <ascull@google.com> wrote:
> > 
> > When exiting a guest, just check whether there is an SError pending and
> > set the bit in the exit code. The fixup then initiates the ceremony
> > should it be required.
> > 
> > The separation allows for easier choices to be made as to whether the
> > demonic consultation should proceed.
> 
> Such as?

It's used in the next patch to keep host SErrors pending and left for
the host to handle when reentering the host vcpu. IIUC, this matches the
previous behaviour since hyp would mask SErrors.

We wanted to avoid the need to convert host SErrors into virtual ones
and I opted for this approach to keep as much of the logic/policy as
possible in C.

Let me know if you'd prefer a different split of the patches or there
should be different design goals.

> > 
> > Signed-off-by: Andrew Scull <ascull@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_hyp.h        |  2 ++
> >  arch/arm64/kvm/hyp/entry.S              | 27 +++++++++++++++++--------
> >  arch/arm64/kvm/hyp/hyp-entry.S          |  1 -
> >  arch/arm64/kvm/hyp/include/hyp/switch.h |  4 ++++
> >  4 files changed, 25 insertions(+), 9 deletions(-)
> > 
> > diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
> > index 07745d9c49fc..50a774812761 100644
> > --- a/arch/arm64/include/asm/kvm_hyp.h
> > +++ b/arch/arm64/include/asm/kvm_hyp.h
> > @@ -91,6 +91,8 @@ void deactivate_traps_vhe_put(void);
> >  
> >  u64 __guest_enter(struct kvm_vcpu *vcpu, struct kvm_cpu_context *host_ctxt);
> >  
> > +void __vaxorcize_serror(void);
> 
> I think a VAXorsist reference in the comments is plenty. The code can
> definitely stay architectural. Something like "__handle_SEI()" should
> be good. I'm not *that* fun.

Fine... ;)

> > +
> >  void __noreturn hyp_panic(struct kvm_cpu_context *host_ctxt);
> >  #ifdef __KVM_NVHE_HYPERVISOR__
> >  void __noreturn __hyp_do_panic(unsigned long, ...);
> > diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
> > index 6a641fcff4f7..dc4e3e7e7407 100644
> > --- a/arch/arm64/kvm/hyp/entry.S
> > +++ b/arch/arm64/kvm/hyp/entry.S
> > @@ -174,18 +174,31 @@ alternative_if ARM64_HAS_RAS_EXTN
> >  	mrs_s	x2, SYS_DISR_EL1
> >  	str	x2, [x1, #(VCPU_FAULT_DISR - VCPU_CONTEXT)]
> >  	cbz	x2, 1f
> > -	msr_s	SYS_DISR_EL1, xzr
> >  	orr	x0, x0, #(1<<ARM_EXIT_WITH_SERROR_BIT)
> > -1:	ret
> > +	nop
> > +1:
> >  alternative_else
> >  	dsb	sy		// Synchronize against in-flight ld/st
> >  	isb			// Prevent an early read of side-effect free ISR
> >  	mrs	x2, isr_el1
> > -	tbnz	x2, #8, 2f	// ISR_EL1.A
> > -	ret
> > -	nop
> > +	tbz	x2, #8, 2f	// ISR_EL1.A
> > +	orr	x0, x0, #(1<<ARM_EXIT_WITH_SERROR_BIT)
> >  2:
> >  alternative_endif
> > +
> > +	ret
> > +SYM_FUNC_END(__guest_enter)
> > +
> > +/*
> > + * void __vaxorcize_serror(void);
> > + */
> > +SYM_FUNC_START(__vaxorcize_serror)
> > +
> > +alternative_if ARM64_HAS_RAS_EXTN
> > +	msr_s	SYS_DISR_EL1, xzr
> > +	ret
> > +alternative_else_nop_endif
> > +
> >  	// We know we have a pending asynchronous abort, now is the
> >  	// time to flush it out. From your VAXorcist book, page 666:
> >  	// "Threaten me not, oh Evil one!  For I speak with
> > @@ -193,7 +206,6 @@ alternative_endif
> >  	mrs	x2, elr_el2
> >  	mrs	x3, esr_el2
> >  	mrs	x4, spsr_el2
> > -	mov	x5, x0
> >  
> >  	msr	daifclr, #4	// Unmask aborts
> >  
> > @@ -217,6 +229,5 @@ abort_guest_exit_end:
> >  	msr	elr_el2, x2
> >  	msr	esr_el2, x3
> >  	msr	spsr_el2, x4
> > -	orr	x0, x0, x5
> >  1:	ret
> > -SYM_FUNC_END(__guest_enter)
> > +SYM_FUNC_END(__vaxorcize_serror)
> > diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.S
> > index e727bee8e110..c441aabb8ab0 100644
> > --- a/arch/arm64/kvm/hyp/hyp-entry.S
> > +++ b/arch/arm64/kvm/hyp/hyp-entry.S
> > @@ -177,7 +177,6 @@ el2_error:
> >  	adr	x1, abort_guest_exit_end
> >  	ccmp	x0, x1, #4, ne
> >  	b.ne	__hyp_panic
> > -	mov	x0, #(1 << ARM_EXIT_WITH_SERROR_BIT)
> >  	eret
> >  	sb
> >  
> > diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
> > index 0511af14dc81..14a774d1a35a 100644
> > --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> > +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> > @@ -405,6 +405,10 @@ static inline bool __hyp_handle_ptrauth(struct kvm_vcpu *vcpu)
> >   */
> >  static inline bool fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
> >  {
> > +	/* Flush guest SErrors. */
> > +	if (ARM_SERROR_PENDING(*exit_code))
> > +		__vaxorcize_serror();
> > +
> >  	if (ARM_EXCEPTION_CODE(*exit_code) != ARM_EXCEPTION_IRQ)
> >  		vcpu->arch.fault.esr_el2 = read_sysreg_el2(SYS_ESR);
> >  
> > -- 
> > 2.27.0.389.gc38d7665816-goog
> > 
> > 
> 
> I'm not against this patch, but I wonder whether it actually helps
> with anything. It spreads the handling across multiple paths, making
> it harder to read. Could you explain the rational beyond "it's
> easier"?

The earlier reply should cover most of this. I claim it's easier to make
choices as the predicate isn't stuck in assembly. Maybe others feel
differently and I should use less provocative language.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
