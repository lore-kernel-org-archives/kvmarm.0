Return-Path: <SRS0=IpCr=AY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D81D1C433E2
	for <kvmarm@archiver.kernel.org>; Mon, 13 Jul 2020 20:42:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 53EAF2075B
	for <kvmarm@archiver.kernel.org>; Mon, 13 Jul 2020 20:42:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="f3NIzdi4"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 53EAF2075B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 812F64B1DC;
	Mon, 13 Jul 2020 16:42:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id FF26TJOhfwJM; Mon, 13 Jul 2020 16:42:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 240ED4B114;
	Mon, 13 Jul 2020 16:42:13 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 07BD44B1CF
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Jul 2020 16:42:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Tc7-Z3k0ba-j for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Jul 2020 16:42:10 -0400 (EDT)
Received: from mail-wr1-f66.google.com (mail-wr1-f66.google.com
 [209.85.221.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 73D354B1CB
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Jul 2020 16:42:10 -0400 (EDT)
Received: by mail-wr1-f66.google.com with SMTP id z2so18327829wrp.2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Jul 2020 13:42:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=XAR84aU6feAmQ9KLm4hA32ueUQwBE6FT/0JLii8cAm8=;
 b=f3NIzdi46R59d2mFJK34NeZCZ1CfUD7xLXKw6PMI3W/sngpHDmAY5MsFXyYMGT7yyJ
 2eEGqeEfxf4L4yEr8wVSS4e3BuQ7XhKqzb9Vkn0XLYlzIKVdHUG+04pbvPRZYIp9zJ+J
 /4th1epkTBiDunpWQKpDvJL2YnFDKdomZaNQhwcRDJM7Fjr6ORxlIdUtsNLYx8GNuakG
 cfwn3VnWRy38zDhHNskaTpSzUq6we6dbj4BrqeTSLrO7hg9kGmor8m61wiibu1q3HDdJ
 WuLVFfDNwxrhwYKmhm+oMOW9VS+MUnf7xZI3cDArGNpjD9yi2IWPYZtrm4zYJzUCKRT9
 qHvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=XAR84aU6feAmQ9KLm4hA32ueUQwBE6FT/0JLii8cAm8=;
 b=UG8KV+QurwVnPj1LqhUwaPS7bdbvilBnECcXoprREBsxRzSp+ccQZDnsahHoSA6wcA
 bLerJ74cey+xUlCnqEXcDq9MqlCnOBjqXf0bxOp075BVUTRsTKYg2PhpK9ih5yfm6v+C
 spJxEN9RGWBRP3EGBGGQZmISamIFeFKAN8BfsyNgr289vilWZOclwLnHr/q0aA9HILhf
 Jv7vcsUMG5KROYdgTngUXCbVrBuGL7+g+TX5HJTe5paIbxs8nwOJ17NmCCNP6ta3pzBU
 TOfhKRCzAXoQ4lM2/iRV/J+d7qQzxI97Oo4Sfn+QUlEdOlsxculiXUp15YM3hPgmLTjY
 9Iuw==
X-Gm-Message-State: AOAM5315lizxFBeY45P+TJJs8Yka0JZgPbdLAOQAwWXdBTw9ZNvbBhvI
 IvXxrMgb80dJV06xSDKSj9bkBg==
X-Google-Smtp-Source: ABdhPJx8LRozrNytEkKVhOj9r1/LLUBwqwGZpNPYHoo+ddhnk5Sx8PVJRWnpLd09XzK3Hi+MdSiqag==
X-Received: by 2002:adf:82f5:: with SMTP id 108mr1303877wrc.218.1594672929164; 
 Mon, 13 Jul 2020 13:42:09 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:109:4a0f:cfff:fe4a:6363])
 by smtp.gmail.com with ESMTPSA id f9sm25487709wru.47.2020.07.13.13.42.08
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 13 Jul 2020 13:42:08 -0700 (PDT)
Date: Mon, 13 Jul 2020 21:42:04 +0100
From: Andrew Scull <ascull@google.com>
To: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH 2/2] KVM: arm64: Leave vcpu FPSIMD synchronization in host
Message-ID: <20200713204204.GA2680114@google.com>
References: <20200710095754.3641976-1-ascull@google.com>
 <20200710095754.3641976-3-ascull@google.com>
 <20200713160421.GS10992@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200713160421.GS10992@arm.com>
Cc: maz@kernel.org, kernel-team@android.com, kvmarm@lists.cs.columbia.edu
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

On Mon, Jul 13, 2020 at 05:04:21PM +0100, Dave Martin wrote:
> On Fri, Jul 10, 2020 at 10:57:54AM +0100, Andrew Scull wrote:
> > The task state can be checked by the host and the vcpu flags updated
> > before calling into hyp. This more neatly separates the concerns and
> > removes the need to map the task flags to EL2.
> > 
> > Hyp acts on the state provided to it by the host and updates it when
> > switching to the vcpu state.
> 
> Can this patch be split up?  We have a few overlapping changes here.
> 
> i.e., renaming and refactoring of hooks; moving some code around; and a
> couple of other changes that are not directly related (noted below).

Indeed it can, into at least 3.

> Overall this looks like a decent cleanup however.  It was always a bit
> nasty to have to map the thread flags into Hyp.

Glad to hear, I'll have to get it in a better shape.

> Side question: currently we do fpsimd_save_and_flush_cpu_state() in
> kvm_arch_vcpu_put_fp().  Can we remove the flush so that the vcpu state
> lingers in the CPU regs and can be reclaimed when switching back to the
> KVM thread?
> 
> This could remove some overhead when the KVM run loop is preempted by a
> kernel thread and subsequently resumed without passing through userspace.
> 
> We would need to flush this state when anything else tries to change the
> vcpu FP regs, which is one reason I skipped this previously: it would
> require a bit of refactoring of fpsimd_flush_task_state() so that a non-
> task context can also be flushed.
> 
> (This isn't directly related to this series.)

I don't plan to address this at the moment but I do believe there are
chances to reduce the need for saves and restores. If the flush is
removed a similar check to that done for tasks could also apply to vCPUs
i.e. if the last FPSIMD state this CPU had was the vCPU and the vCPU
last ran on this CPU then the vCPU's FPSIMD state is already loaded.

> Additional minor comments below.
> 
> > 
> > No functional change.
> > 
> > Signed-off-by: Andrew Scull <ascull@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_host.h       |  5 +--
> >  arch/arm64/kvm/arm.c                    |  4 +-
> >  arch/arm64/kvm/fpsimd.c                 | 57 ++++++++++++++++++-------
> >  arch/arm64/kvm/hyp/include/hyp/switch.h | 19 ---------
> >  arch/arm64/kvm/hyp/nvhe/switch.c        |  3 +-
> >  arch/arm64/kvm/hyp/vhe/switch.c         |  3 +-
> >  6 files changed, 48 insertions(+), 43 deletions(-)
> > 
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index b06f24b5f443..ca1621eeb9d9 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -24,7 +24,6 @@
> >  #include <asm/fpsimd.h>
> >  #include <asm/kvm.h>
> >  #include <asm/kvm_asm.h>
> > -#include <asm/thread_info.h>
> >  
> >  #define __KVM_HAVE_ARCH_INTC_INITIALIZED
> >  
> > @@ -320,7 +319,6 @@ struct kvm_vcpu_arch {
> >  	struct kvm_guest_debug_arch vcpu_debug_state;
> >  	struct kvm_guest_debug_arch external_debug_state;
> >  
> > -	struct thread_info *host_thread_info;	/* hyp VA */
> >  	struct user_fpsimd_state *host_fpsimd_state;	/* hyp VA */
> >  
> >  	struct {
> > @@ -616,7 +614,8 @@ int kvm_arm_vcpu_arch_has_attr(struct kvm_vcpu *vcpu,
> >  /* Guest/host FPSIMD coordination helpers */
> >  int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu);
> >  void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu);
> > -void kvm_arch_vcpu_ctxsync_fp(struct kvm_vcpu *vcpu);
> > +void kvm_arch_vcpu_enter_ctxsync_fp(struct kvm_vcpu *vcpu);
> > +void kvm_arch_vcpu_exit_ctxsync_fp(struct kvm_vcpu *vcpu);
> 
> I find these names a bit confusing.
> 
> Maybe
> 
> 	kvm_arch_vcpu_ctxsync_fp_before_guest_enter()
> 	kvm_arch_vcpu_ctxsync_fp_after_guest_exit()
> 
> (we could probably drop the "ctx" to make these slightly shorter).

Changed to kvm_arch_vcpu_sync_fp_{before,after}_run()

> >  void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu);
> >  
> >  static inline bool kvm_pmu_counter_deferred(struct perf_event_attr *attr)
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index 98f05bdac3c1..c7a711ca840e 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -682,6 +682,8 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
> >  
> >  		local_irq_disable();
> >  
> > +		kvm_arch_vcpu_enter_ctxsync_fp(vcpu);
> > +
> >  		kvm_vgic_flush_hwstate(vcpu);
> >  
> >  		/*
> > @@ -769,7 +771,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
> >  		if (static_branch_unlikely(&userspace_irqchip_in_use))
> >  			kvm_timer_sync_user(vcpu);
> >  
> > -		kvm_arch_vcpu_ctxsync_fp(vcpu);
> > +		kvm_arch_vcpu_exit_ctxsync_fp(vcpu);
> >  
> >  		/*
> >  		 * We may have taken a host interrupt in HYP mode (ie
> > diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
> > index 3e081d556e81..aec91f43df62 100644
> > --- a/arch/arm64/kvm/fpsimd.c
> > +++ b/arch/arm64/kvm/fpsimd.c
> > @@ -27,22 +27,13 @@ int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu)
> >  {
> >  	int ret;
> >  
> > -	struct thread_info *ti = &current->thread_info;
> >  	struct user_fpsimd_state *fpsimd = &current->thread.uw.fpsimd_state;
> >  
> > -	/*
> > -	 * Make sure the host task thread flags and fpsimd state are
> > -	 * visible to hyp:
> > -	 */
> > -	ret = create_hyp_mappings(ti, ti + 1, PAGE_HYP);
> > -	if (ret)
> > -		goto error;
> > -
> > +	/* Make sure the host task fpsimd state is visible to hyp: */
> >  	ret = create_hyp_mappings(fpsimd, fpsimd + 1, PAGE_HYP);
> >  	if (ret)
> >  		goto error;
> >  
> > -	vcpu->arch.host_thread_info = kern_hyp_va(ti);
> >  	vcpu->arch.host_fpsimd_state = kern_hyp_va(fpsimd);
> >  error:
> >  	return ret;
> > @@ -52,7 +43,7 @@ int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu)
> >   * Prepare vcpu for saving the host's FPSIMD state and loading the guest's.
> >   * The actual loading is done by the FPSIMD access trap taken to hyp.
> >   *
> > - * Here, we just set the correct metadata to indicate that the FPSIMD
> > + * Here, we just set the correct metadata to indicate whether the FPSIMD
> >   * state in the cpu regs (if any) belongs to current on the host.
> >   *
> >   * TIF_SVE is backed up here, since it may get clobbered with guest state.
> > @@ -63,15 +54,46 @@ void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu)
> >  	BUG_ON(!current->mm);
> >  
> >  	vcpu->arch.flags &= ~(KVM_ARM64_FP_ENABLED |
> > +			      KVM_ARM64_FP_HOST |
> >  			      KVM_ARM64_HOST_SVE_IN_USE |
> >  			      KVM_ARM64_HOST_SVE_ENABLED);
> > +
> > +	if (!system_supports_fpsimd())
> > +		return;
> > +
> > +	/*
> > +	 * Having just come from the user task, if any FP state is loaded it
> > +	 * will be that of the task. Make a note of this but, just before
> > +	 * entering the vcpu, it will be double checked that the loaded FP
> > +	 * state isn't transient because things could change between now and
> > +	 * then.
> > +	 */
> >  	vcpu->arch.flags |= KVM_ARM64_FP_HOST;
> >  
> > -	if (test_thread_flag(TIF_SVE))
> > -		vcpu->arch.flags |= KVM_ARM64_HOST_SVE_IN_USE;
> > +	if (system_supports_sve()) {
> 
> This is a change and should be noted.
 
Ack

> Looks reasonable, though.
> 
> To ensure that we aren't breaking assumptions here, double-check that we
> also have system_supports_sve() in the appropriate places in the Hyp
> code.   We almost certainly do, but it doesn't hurt to review it.

Yes, hyp gates the fp trap handling on system_supports_fpsimd() and
further gates SVE on system_supports_sve().

> > +		if (test_thread_flag(TIF_SVE))
> > +			vcpu->arch.flags |= KVM_ARM64_HOST_SVE_IN_USE;
> >  
> > -	if (read_sysreg(cpacr_el1) & CPACR_EL1_ZEN_EL0EN)
> > -		vcpu->arch.flags |= KVM_ARM64_HOST_SVE_ENABLED;
> > +		if (read_sysreg(cpacr_el1) & CPACR_EL1_ZEN_EL0EN)
> > +			vcpu->arch.flags |= KVM_ARM64_HOST_SVE_ENABLED;
> > +	}
> > +}
> > +
> > +void kvm_arch_vcpu_enter_ctxsync_fp(struct kvm_vcpu *vcpu)
> > +{
> > +	WARN_ON_ONCE(!irqs_disabled());
> > +
> > +	if (!system_supports_fpsimd())
> > +		return;
> > +
> > +	/*
> > +	 * If the CPU's FP state is transient, there is no need to save the
> > +	 * current state. Without further information, it must also be assumed
> > +	 * that the vcpu's state is not loaded.
> > +	 */
> > +	if (test_thread_flag(TIF_FOREIGN_FPSTATE))
> > +		vcpu->arch.flags &= ~(KVM_ARM64_FP_ENABLED |
> > +				      KVM_ARM64_FP_HOST);
> >  }
> >  
> >  /*
> > @@ -80,7 +102,7 @@ void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu)
> >   * so that they will be written back if the kernel clobbers them due to
> >   * kernel-mode NEON before re-entry into the guest.
> >   */
> > -void kvm_arch_vcpu_ctxsync_fp(struct kvm_vcpu *vcpu)
> > +void kvm_arch_vcpu_exit_ctxsync_fp(struct kvm_vcpu *vcpu)
> >  {
> >  	WARN_ON_ONCE(!irqs_disabled());
> >  
> > @@ -106,6 +128,9 @@ void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu)
> >  	bool host_has_sve = system_supports_sve();
> >  	bool guest_has_sve = vcpu_has_sve(vcpu);
> >  
> > +	if (!system_supports_fpsimd())
> > +		return;
> > +
> 
> Is this a bugfix, an optimisation, or what?

This was concern over the comment in the hyp switching code that said
something along the lines of some flags can't be truested if FPSIMD
isn't supported. However, I'm convinced that FP_ENABLED will not be set
if !system_supports_fpsimd() so you're right to question this.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
