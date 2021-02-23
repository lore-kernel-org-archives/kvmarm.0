Return-Path: <SRS0=rfx0=HZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42119C433DB
	for <kvmarm@archiver.kernel.org>; Tue, 23 Feb 2021 12:34:35 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AFD3664E5C
	for <kvmarm@archiver.kernel.org>; Tue, 23 Feb 2021 12:34:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AFD3664E5C
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2AC5D4B1EC;
	Tue, 23 Feb 2021 07:34:34 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id D3nadd8DynYg; Tue, 23 Feb 2021 07:34:32 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D567C4B1D5;
	Tue, 23 Feb 2021 07:34:32 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A815C4B1CA
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Feb 2021 07:34:31 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RcnQv2ZBYtXR for <kvmarm@lists.cs.columbia.edu>;
 Tue, 23 Feb 2021 07:34:29 -0500 (EST)
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com
 [209.85.221.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BE0374B190
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Feb 2021 07:34:29 -0500 (EST)
Received: by mail-wr1-f41.google.com with SMTP id r3so10771425wro.9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Feb 2021 04:34:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=WELRMbdAhRJq+PsrIuYo5xCle6Cc3La9mGY1/BLGqqQ=;
 b=aD7pIPSkogllSoJTWoJbPbAZMmkRLlZExE0O3UEuqZeQwXfI3Nt03bhB8cQs0H6qjA
 /ICEKKaP+gm/GDB1Y9fdaRFi4llDj/4BZCRgJWJ6BRYPRMCgTMVFQ0j7aFVrdL40ht68
 zSYHKVVZ9asIhggNf1XMJ+7HWnlASJO0EjQcJNGokvO/Yl32/fC8QnXiF4Gv0AR5HXaf
 5W5WXliasv6HNtoi9Nz4hn6xOW802XoUEFyY/GZMTgJmO6UPZHI4oNRDqeL9YR3IYifO
 6D9Xs5lgUc1m7IriJOuZ9LUPEB1efzHO7EiH9GpG6fXRtA36NBp5GQGcr62ZaTsHBMP0
 jniQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=WELRMbdAhRJq+PsrIuYo5xCle6Cc3La9mGY1/BLGqqQ=;
 b=XQIKIF94eKS/Pm2pOBtX1VlUutVRd0z3NW2pxxkd1lAKtUc3FTpJ2K7geMGsIJIk6W
 1/cQmQ1tRFMuJliRZ0XzqFdjeZoTUs+DSZiCvbBtRUt0MM1CQ6KyPL1W0fnUfrwlOLTA
 rx9UOvtNVL+raDarkmMFNwbFHWFs8cYJn4AY/nMiWbzoXATqJ1aQ7PD25rYMiopcTA/8
 /oT7obQgFy/0oQRNURZME0mQXNYcBCoXPzkOU9TBD3Ju08Q34z4aYdr8zRuUptQYoB4S
 lvTjNIu7qaXsFMSLgqMCO2sAqxtMMk8HedtlRsB8nOhTaQWQc7RQf2KC89cWG8odF8FK
 FiCg==
X-Gm-Message-State: AOAM531ehhBVLBaMI+HwE2XjaqYQncIL4HHiL6UrxwLvhp9tcz2+NYK0
 ni301CV/hc9I7j0tjuXTuOG6LA==
X-Google-Smtp-Source: ABdhPJycQkv0I8yNsfHtUTSlp+EivNAKcChqzWsGWPdDKVFlZKpKrHWzg0Sm3zxnmG6Ai0bgonqRNQ==
X-Received: by 2002:a5d:6585:: with SMTP id q5mr14267440wru.270.1614083668490; 
 Tue, 23 Feb 2021 04:34:28 -0800 (PST)
Received: from google.com (216.131.76.34.bc.googleusercontent.com.
 [34.76.131.216])
 by smtp.gmail.com with ESMTPSA id 4sm2981074wma.0.2021.02.23.04.34.27
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 23 Feb 2021 04:34:27 -0800 (PST)
Date: Tue, 23 Feb 2021 12:34:22 +0000
From: Andrew Scull <ascull@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 2/2] KVM: arm64: Log source when panicking from nVHE hyp
Message-ID: <YDT2TvFFxre5i3KN@google.com>
References: <20210223094927.766572-1-ascull@google.com>
 <20210223094927.766572-3-ascull@google.com>
 <87czwr10p9.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87czwr10p9.wl-maz@kernel.org>
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

On Tue, Feb 23, 2021 at 11:29:54AM +0000, Marc Zyngier wrote:
> Hi Andrew,
> 
> On Tue, 23 Feb 2021 09:49:27 +0000,
> Andrew Scull <ascull@google.com> wrote:
> > 
> > To aid with debugging, add details of the source of a panic. This is
> > done by having nVHE hyp exit to nvhe_hyp_panic_handler() rather than
> > directly to panic(). The handler will then add the extra details for
> > debugging before panicking the kernel.
> > 
> > If the panic was due to a BUG(), look up the metadata to log the file
> > and line, if available, otherwise log the kimg address that can be
> > looked up in vmlinux.
> > 
> > Signed-off-by: Andrew Scull <ascull@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_mmu.h        |  2 ++
> >  arch/arm64/kernel/image-vars.h          |  3 +-
> >  arch/arm64/kvm/handle_exit.c            | 38 +++++++++++++++++++++++++
> >  arch/arm64/kvm/hyp/include/hyp/switch.h |  2 --
> >  arch/arm64/kvm/hyp/nvhe/host.S          | 18 ++++++------
> >  arch/arm64/kvm/hyp/nvhe/psci-relay.c    |  2 --
> >  6 files changed, 49 insertions(+), 16 deletions(-)
> > 
> > diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
> > index e52d82aeadca..f07c55f9dd1e 100644
> > --- a/arch/arm64/include/asm/kvm_mmu.h
> > +++ b/arch/arm64/include/asm/kvm_mmu.h
> > @@ -130,6 +130,8 @@ void kvm_update_va_mask(struct alt_instr *alt,
> >  			__le32 *origptr, __le32 *updptr, int nr_inst);
> >  void kvm_compute_layout(void);
> >  
> > +#define __hyp_pa(x) ((phys_addr_t)((x)) + hyp_physvirt_offset)
> > +
> >  static __always_inline unsigned long __kern_hyp_va(unsigned long v)
> >  {
> >  	asm volatile(ALTERNATIVE_CB("and %0, %0, #1\n"
> > diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
> > index f676243abac6..cf12b0d6441e 100644
> > --- a/arch/arm64/kernel/image-vars.h
> > +++ b/arch/arm64/kernel/image-vars.h
> > @@ -71,8 +71,7 @@ KVM_NVHE_ALIAS(kvm_get_kimage_voffset);
> >  KVM_NVHE_ALIAS(kvm_vgic_global_state);
> >  
> >  /* Kernel symbols used to call panic() from nVHE hyp code (via ERET). */
> > -KVM_NVHE_ALIAS(__hyp_panic_string);
> > -KVM_NVHE_ALIAS(panic);
> > +KVM_NVHE_ALIAS(nvhe_hyp_panic_handler);
> >  
> >  /* Vectors installed by hyp-init on reset HVC. */
> >  KVM_NVHE_ALIAS(__hyp_stub_vectors);
> > diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> > index cebe39f3b1b6..5e0d9a5152e5 100644
> > --- a/arch/arm64/kvm/handle_exit.c
> > +++ b/arch/arm64/kvm/handle_exit.c
> > @@ -291,3 +291,41 @@ void handle_exit_early(struct kvm_vcpu *vcpu, int exception_index)
> >  	if (exception_index == ARM_EXCEPTION_EL1_SERROR)
> >  		kvm_handle_guest_serror(vcpu, kvm_vcpu_get_esr(vcpu));
> >  }
> > +
> > +void __noreturn __cold nvhe_hyp_panic_handler(bool hyp, u64 spsr, u64 elr,
> > +					      u64 par, uintptr_t vcpu,
> > +					      u64 far, u64 hpfar, u64 esr) {
> > +	extern const char __hyp_panic_string[];
> 
> Is there any reason left to not to make this a symbol at all, but
> instead to feed the string to the panic() call below?

No, none. I guess it was only a symbol so nVHE hyp could point at it and
doesn't matter any more. There doesn't seem to be a good reason for VHE
and nVHE to have the same panic string.


> > +	u64 elr_in_kimg = __phys_to_kimg(__hyp_pa(elr));
> > +
> > +	if (!hyp) {
> > +		kvm_err("Invalid host exception to nVHE hyp!\n");
> 
> Do we need to have hyp as a parameter? Can't we work that out from the
> SPSR passed as a parameter?

You're right, that should have some useful information already. Didn't
occur to me before, I'll play with it.

> > +	} else if (ESR_ELx_EC(esr) == ESR_ELx_EC_BRK64 &&
> > +		   (esr & ESR_ELx_BRK64_ISS_COMMENT_MASK) == BUG_BRK_IMM) {
> > +		struct bug_entry *bug = find_bug(elr_in_kimg);
> > +		const char *file = NULL;
> > +		unsigned line = 0;
> > +
> > +		/* All hyp bugs, including warnings, are treated as fatal. */
> > +		if (bug) {
> > +#ifdef CONFIG_DEBUG_BUGVERBOSE
> > +#ifndef CONFIG_GENERIC_BUG_RELATIVE_POINTERS
> > +			file = bug->file;
> > +#else
> > +			file = (const char *)bug + bug->file_disp;
> > +#endif
> > +			line = bug->line;
> > +#endif
> 
> It looks like you have lifted this from lib/bugs.c. 

Bingo!

> Would it be worth
> making it a helper that lives there? Something like
> 
> struct bug_entry *bug_get_entry(unsigned long pc, char **file,
> 				unsigned int *line);
> 
> that hides the #ifdefery and the fund_bug() call away? The
> disable_trace_on_warning() call isn't a problem, as we're about to die
> anyway.

Yeah, that'd make a lot of sense. Please protect me from the wrath of
the community when I touch the common code..

> > +		}
> > +
> > +		if (file) {
> > +			kvm_err("nVHE hyp BUG at: %s:%u!\n", file, line);
> > +		} else {
> > +			kvm_err("nVHE hyp BUG at: %016llx!\n", elr_in_kimg);
> > +		}
> > +	} else {
> > +		kvm_err("nVHE hyp panic at: %016llx!\n", elr_in_kimg);
> > +	}
> > +
> > +	panic(__hyp_panic_string, spsr, elr, esr, far, hpfar, par, vcpu);
> > +}
> > diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
> > index 84473574c2e7..f9e8bb97d199 100644
> > --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> > +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> > @@ -30,8 +30,6 @@
> >  #include <asm/processor.h>
> >  #include <asm/thread_info.h>
> >  
> > -extern const char __hyp_panic_string[];
> > -
> >  extern struct exception_table_entry __start___kvm_ex_table;
> >  extern struct exception_table_entry __stop___kvm_ex_table;
> >  
> > diff --git a/arch/arm64/kvm/hyp/nvhe/host.S b/arch/arm64/kvm/hyp/nvhe/host.S
> > index 3dc5a9f3e575..d9a9dd66b1a2 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/host.S
> > +++ b/arch/arm64/kvm/hyp/nvhe/host.S
> > @@ -77,21 +77,19 @@ SYM_FUNC_END(__host_enter)
> >  SYM_FUNC_START(__hyp_do_panic)
> >  	mov	x29, x0
> >  
> > -	/* Load the format string into x0 and arguments into x1-7 */
> > -	ldr	x0, =__hyp_panic_string
> > -
> > -	mov	x6, x3
> > -	get_vcpu_ptr x7, x3
> > -
> > -	mrs	x3, esr_el2
> > -	mrs	x4, far_el2
> > -	mrs	x5, hpfar_el2
> > +	/* Load the panic arguments into x0-7 */
> > +	cmp	x0, xzr
> > +	cset	x0, ne
> > +	get_vcpu_ptr x4, x5
> > +	mrs	x5, far_el2
> > +	mrs	x6, hpfar_el2
> > +	mrs	x7, esr_el2
> >  
> >  	/* Prepare and exit to the host's panic funciton. */
> >  	mov	lr, #(PSR_F_BIT | PSR_I_BIT | PSR_A_BIT | PSR_D_BIT |\
> >  		      PSR_MODE_EL1h)
> >  	msr	spsr_el2, lr
> > -	ldr	lr, =panic
> > +	ldr	lr, =nvhe_hyp_panic_handler
> >  	msr	elr_el2, lr
> >  
> >  	/* Enter the host, restoring the host context if it was provided. */
> > diff --git a/arch/arm64/kvm/hyp/nvhe/psci-relay.c b/arch/arm64/kvm/hyp/nvhe/psci-relay.c
> > index 8e7128cb7667..54b70189229b 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/psci-relay.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/psci-relay.c
> > @@ -22,8 +22,6 @@ void __noreturn __host_enter(struct kvm_cpu_context *host_ctxt);
> >  struct kvm_host_psci_config __ro_after_init kvm_host_psci_config;
> >  s64 __ro_after_init hyp_physvirt_offset;
> >  
> > -#define __hyp_pa(x) ((phys_addr_t)((x)) + hyp_physvirt_offset)
> > -
> >  #define INVALID_CPU_ID	UINT_MAX
> >  
> >  struct psci_boot_args {
> > -- 
> > 2.30.0.617.g56c4b15f3c-goog
> > 
> > 
> 
> Otherwise, I like the idea!
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
