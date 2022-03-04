Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9AAFC433F5
	for <kvmarm@archiver.kernel.org>; Fri,  4 Mar 2022 08:00:46 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3171149B07;
	Fri,  4 Mar 2022 03:00:46 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gq7tU6nsziCG; Fri,  4 Mar 2022 03:00:44 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 88FD549B0C;
	Fri,  4 Mar 2022 03:00:44 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9AD054965C
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Mar 2022 03:00:43 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gDnWaMAFfqu4 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  4 Mar 2022 03:00:41 -0500 (EST)
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com
 [209.85.216.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 22FB0408D5
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Mar 2022 03:00:41 -0500 (EST)
Received: by mail-pj1-f53.google.com with SMTP id
 ev16-20020a17090aead000b001bc3835fea8so7365394pjb.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 04 Mar 2022 00:00:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=message-id:date:mime-version:user-agent:from:subject:to:cc
 :references:content-language:in-reply-to:content-transfer-encoding;
 bh=8rnWolcf0zjKHO23OfWEsuXO3jDtd43VYm2lWQciK58=;
 b=MKPVrJgS1+7YtiU1xap4sN2rVZ4ZhdZdM6Ic3uerrU2wyKTrlZpdu2rbV8rZeQUe7r
 u+R+Hp7yr6H1zbOpD6ZEow9QLGJn4herHx2nBLFQB30YbkdlGQcnpgSqm+9jhRKojfgy
 alJcKOiXAEQ3xHoGgQsNcKotkaoG0UikgWLK8qa5cf1CkkLU+zd96bVLmm2/JXvEr0TI
 KbcXmOjGjCY3RJ9JiGXOBPIeaiuuwM2m7AATUCR6TQUv/bSAxMKKiDoadTjGKIn0UYDC
 yqSpRaOrnhT/b1sAvPlT8gqcYosyg8P0xNZ4HRFtMh3OIjJ93eidHEFsXvmL5qI6Czym
 w1yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:from
 :subject:to:cc:references:content-language:in-reply-to
 :content-transfer-encoding;
 bh=8rnWolcf0zjKHO23OfWEsuXO3jDtd43VYm2lWQciK58=;
 b=6Hz7KikgYUIn6euwTz5UzxUDygtshv5wg0/bcFAIaElwEu6Wvuof2KDPdbZVA8QGGr
 AJ8cwxCM8wZO6R/AVeHgZmIkk4krAvxpQwm565h7w+cIFXL9fBr1V7rblwniXIlmUZVN
 rsoNNemp8RVd4Tf8yH4/ubUsG05VDaKVDcdYrmtEqD+qwbdoPw8/0gK//+zqj/iMW2V0
 Lfj4AceYxMiXw9aHUYuBk2fgjinHc0YRR2Q17aQ3PlCpq6VeFQv/AF0h5EjNM21yg/p9
 AKt7yjP/WbUuAAF48UF93xUb7vTvEo9XxKNEiSgGsIGmOca+MayMvwYWajR4Pl8j4su4
 h4ag==
X-Gm-Message-State: AOAM530v1nzuXRwp+MVUOoOUJF/rRRZZ9I9HY/rdN8D/D6mZc0Mc1Ov0
 1Fz06DdDTw8fVw4Baf0senLCrQ==
X-Google-Smtp-Source: ABdhPJwsigedjfH91COnhkZNT5vzPDrcCaa9q4hKWNMidlqkmANMWP4ynlUcavqFxNZU9uZA/Tc4Vg==
X-Received: by 2002:a17:902:f70d:b0:14f:a1e1:b9b3 with SMTP id
 h13-20020a170902f70d00b0014fa1e1b9b3mr40064195plo.36.1646380835151; 
 Fri, 04 Mar 2022 00:00:35 -0800 (PST)
Received: from [192.168.86.237]
 (107-203-254-183.lightspeed.sntcca.sbcglobal.net. [107.203.254.183])
 by smtp.gmail.com with ESMTPSA id
 v21-20020a056a00149500b004e15a113300sm5168277pfu.198.2022.03.04.00.00.29
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 04 Mar 2022 00:00:34 -0800 (PST)
Message-ID: <75e90ab4-141f-21a8-1559-f792b84d60fa@google.com>
Date: Fri, 4 Mar 2022 00:00:20 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
From: Reiji Watanabe <reijiw@google.com>
Subject: Re: [PATCH v3 2/3] KVM: arm64: mixed-width check should be skipped
 for uninitialized vCPUs
To: Marc Zyngier <maz@kernel.org>
References: <20220303035408.3708241-1-reijiw@google.com>
 <20220303035408.3708241-2-reijiw@google.com> <87tucf10fg.wl-maz@kernel.org>
Content-Language: en-US
In-Reply-To: <87tucf10fg.wl-maz@kernel.org>
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Peter Shier <pshier@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 kvmarm@lists.cs.columbia.edu, Linux ARM <linux-arm-kernel@lists.infradead.org>
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

Hi Marc,

On Thu, Mar 3, 2022 at 8:11 AM Marc Zyngier <maz@kernel.org> wrote:
>
> Reiji,
>
> Please add a cover letter to your patches. It actually is important to
> track the changes as well as being an anchor in my email client.

Sure, I will add a cover letter for v4.


> On Thu, 03 Mar 2022 03:54:07 +0000,
> Reiji Watanabe <reijiw@google.com> wrote:
> >
> > KVM allows userspace to configure either all EL1 32bit or 64bit vCPUs
> > for a guest.  At vCPU reset, vcpu_allowed_register_width() checks
> > if the vcpu's register width is consistent with all other vCPUs'.
> > Since the checking is done even against vCPUs that are not initialized
> > (KVM_ARM_VCPU_INIT has not been done) yet, the uninitialized vCPUs
> > are erroneously treated as 64bit vCPU, which causes the function to
> > incorrectly detect a mixed-width VM.
> >
> > Introduce KVM_ARCH_FLAG_EL1_32BIT and KVM_ARCH_FLAG_REG_WIDTH_CONFIGURED
> > bits for kvm->arch.flags.  A value of the EL1_32BIT bit indicates that
> > the guest needs to be configured with all 32bit or 64bit vCPUs, and
> > a value of the REG_WIDTH_CONFIGURED bit indicates if a value of the
> > EL1_32BIT bit is valid (already set up). Values in those bits are set at
> > the first KVM_ARM_VCPU_INIT for the guest based on KVM_ARM_VCPU_EL1_32BIT
> > configuration for the vCPU.
> >
> > Check vcpu's register width against those new bits at the vcpu's
> > KVM_ARM_VCPU_INIT (instead of against other vCPUs' register width).
> >
> > Fixes: 66e94d5cafd4 ("KVM: arm64: Prevent mixed-width VM creation")
> > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_emulate.h | 25 +++++++++++------
> >  arch/arm64/include/asm/kvm_host.h    |  8 ++++++
> >  arch/arm64/kvm/arm.c                 | 41 ++++++++++++++++++++++++++++
> >  arch/arm64/kvm/reset.c               |  8 ------
> >  4 files changed, 65 insertions(+), 17 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> > index d62405ce3e6d..f4f960819888 100644
> > --- a/arch/arm64/include/asm/kvm_emulate.h
> > +++ b/arch/arm64/include/asm/kvm_emulate.h
> > @@ -20,6 +20,7 @@
> >  #include <asm/ptrace.h>
> >  #include <asm/cputype.h>
> >  #include <asm/virt.h>
> > +#include <asm/kvm_mmu.h>
>
> Huh... I wish we didn't drag that one here, it is eventually going to
> hurt...
>
> >
> >  #define CURRENT_EL_SP_EL0_VECTOR     0x0
> >  #define CURRENT_EL_SP_ELx_VECTOR     0x200
> > @@ -45,7 +46,14 @@ void kvm_vcpu_wfi(struct kvm_vcpu *vcpu);
> >
> >  static __always_inline bool vcpu_el1_is_32bit(struct kvm_vcpu *vcpu)
> >  {
> > -     return !(vcpu->arch.hcr_el2 & HCR_RW);
> > +     struct kvm *kvm;
> > +
> > +     kvm = is_kernel_in_hyp_mode() ? kern_hyp_va(vcpu->kvm) : vcpu->kvm;
>
> Errr... On first approximation, this is the wrong way around. A VHE
> kernel doesn't need any repainting of the address, while a nVHE kernel
> does. Even more, a bit of context:
>
> static inline bool is_kernel_in_hyp_mode(void)
> {
>         return read_sysreg(CurrentEL) == CurrentEL_EL2;
> }
>
> So not only the expression is the wrong way around, but it *cannot*
> distinguish VHE and nVHE when running at EL2. You're just lucky that
> the two bugs (on a single line) cancel each others.
>
> The only sane way to write this is to *not* look at the mode you're
> running in. kern_hyp_va() is designed to be nop'ed out on VHE.

Actually, I did it knowing kern_hyp_va() was nop on vhe and
kern_hyp_va() was needed for nvhe in hyp.  I wanted to make the
function work whether it is nvhe hyp or non-hyp, or vhe...


> > +
> > +     WARN_ON_ONCE(!test_bit(KVM_ARCH_FLAG_REG_WIDTH_CONFIGURED,
> > +                            &kvm->arch.flags));
> > +
> > +     return test_bit(KVM_ARCH_FLAG_EL1_32BIT, &kvm->arch.flags);
> >  }
>
> Given that this is used on the vcpu switch fast path at least twice
> per run, we need something better. You probably want to offer
> different primitives depending on the context:
>
> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> index d62405ce3e6d..daea0885c28d 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -43,10 +43,22 @@ void kvm_inject_pabt(struct kvm_vcpu *vcpu, unsigned long addr);
>
>  void kvm_vcpu_wfi(struct kvm_vcpu *vcpu);
>
> +#if defined (__KVM_VHE_HYPERVISOR__) || defined (__KVM_NVHE_HYPERVISOR__)
>  static __always_inline bool vcpu_el1_is_32bit(struct kvm_vcpu *vcpu)
>  {
>         return !(vcpu->arch.hcr_el2 & HCR_RW);
>  }
> +#else
> +static inline bool vcpu_el1_is_32bit(struct kvm_vcpu *vcpu)
> +{
> +       struct kvm *kvm = kern_hyp_va(vcpu->kvm);
> +
> +       WARN_ON_ONCE(!test_bit(KVM_ARCH_FLAG_REG_WIDTH_CONFIGURED,
> +                              &kvm->arch_flags));
> +
> +       return test_bit(KVM_ARCH_FLAG_EL1_32BIT, &kvm->arch.flags);
> +}
> +#endif
>
> as you are guaranteed to have configured the width of the vcpu by the
> time you hit start messing with it in the context of the hypervisor.

Thank you for the proposal!
I will fix that based on the proposal.


> >
> >  static inline void vcpu_reset_hcr(struct kvm_vcpu *vcpu)
> > @@ -72,15 +80,14 @@ static inline void vcpu_reset_hcr(struct kvm_vcpu *vcpu)
> >               vcpu->arch.hcr_el2 |= HCR_TVM;
> >       }
> >
> > -     if (test_bit(KVM_ARM_VCPU_EL1_32BIT, vcpu->arch.features))
> > +     if (vcpu_el1_is_32bit(vcpu))
> >               vcpu->arch.hcr_el2 &= ~HCR_RW;
> > -
> > -     /*
> > -      * TID3: trap feature register accesses that we virtualise.
> > -      * For now this is conditional, since no AArch32 feature regs
> > -      * are currently virtualised.
> > -      */
> > -     if (!vcpu_el1_is_32bit(vcpu))
> > +     else
> > +             /*
> > +              * TID3: trap feature register accesses that we virtualise.
> > +              * For now this is conditional, since no AArch32 feature regs
> > +              * are currently virtualised.
> > +              */
> >               vcpu->arch.hcr_el2 |= HCR_TID3;
> >
> >       if (cpus_have_const_cap(ARM64_MISMATCHED_CACHE_TYPE) ||
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index 11a7ae747ded..5cde7f7b5042 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -125,6 +125,14 @@ struct kvm_arch {
> >  #define KVM_ARCH_FLAG_RETURN_NISV_IO_ABORT_TO_USER   0
> >       /* Memory Tagging Extension enabled for the guest */
> >  #define KVM_ARCH_FLAG_MTE_ENABLED                    1
> > +     /*
> > +      * The guest's EL1 register width.  A value of KVM_ARCH_FLAG_EL1_32BIT
> > +      * bit is valid only when KVM_ARCH_FLAG_REG_WIDTH_CONFIGURED is set.
> > +      * Otherwise, the guest's EL1 register width has not yet been
> > +      * determined yet.
> > +      */
> > +#define KVM_ARCH_FLAG_REG_WIDTH_CONFIGURED           2
> > +#define KVM_ARCH_FLAG_EL1_32BIT                              3
> >       unsigned long flags;
> >
> >       /*
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index 9a2d240ef6a3..9ac75aa46e2f 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -1101,6 +1101,43 @@ int kvm_vm_ioctl_irq_line(struct kvm *kvm, struct kvm_irq_level *irq_level,
> >       return -EINVAL;
> >  }
> >
> > +/*
> > + * A guest can have either all EL1 32bit or 64bit vcpus only. It is
> > + * indicated by a value of KVM_ARCH_FLAG_EL1_32BIT bit in kvm->arch.flags,
> > + * which is valid only when KVM_ARCH_FLAG_REG_WIDTH_CONFIGURED in
> > + * kvm->arch.flags is set.
> > + * This function checks if the vCPU's register width configuration is
> > + * consistent with a value of the EL1_32BIT bit in kvm->arch.flags
> > + * when the REG_WIDTH_CONFIGURED bit is set.
> > + * Otherwise, the function sets a value of EL1_32BIT bit based on the vcpu's
> > + * KVM_ARM_VCPU_EL1_32BIT configuration (and sets the REG_WIDTH_CONFIGURED
> > + * bit of kvm->arch.flags).
> > + */
> > +static int kvm_register_width_check_or_init(struct kvm_vcpu *vcpu)
>
> The naming is positively Java-esque! How about kvm_set_vm_width()
> instead? Also, please document the error code.

Sure, I will fix the name, and document the error code.


>
> > +{
> > +     bool is32bit;
> > +     bool allowed = true;
> > +     struct kvm *kvm = vcpu->kvm;
> > +
> > +     is32bit = vcpu_has_feature(vcpu, KVM_ARM_VCPU_EL1_32BIT);
> > +
> > +     mutex_lock(&kvm->lock);
> > +
> > +     if (test_bit(KVM_ARCH_FLAG_REG_WIDTH_CONFIGURED, &kvm->arch.flags)) {
> > +             allowed = (is32bit ==
> > +                        test_bit(KVM_ARCH_FLAG_EL1_32BIT, &kvm->arch.flags));
> > +     } else {
> > +             if (is32bit)
> > +                     set_bit(KVM_ARCH_FLAG_EL1_32BIT, &kvm->arch.flags);
>
> nit: probably best written as:
>
>                 __assign_bit(KVM_ARCH_FLAG_EL1_32BIT, &kvm->arch.flags, is32bit);
>
> > +
> > +             set_bit(KVM_ARCH_FLAG_REG_WIDTH_CONFIGURED, &kvm->arch.flags);
>
> Since this is only ever set whilst holding the lock, you can user the
> __set_bit() version.

Thank you for the proposal. But since other CPUs could attempt
to set other bits without holding the lock, I don't think we
can use the non-atomic version here.

>
> > +     }
> > +
> > +     mutex_unlock(&kvm->lock);
> > +
> > +     return allowed ? 0 : -EINVAL;
> > +}
> > +
> >  static int kvm_vcpu_set_target(struct kvm_vcpu *vcpu,
> >                              const struct kvm_vcpu_init *init)
> >  {
> > @@ -1140,6 +1177,10 @@ static int kvm_vcpu_set_target(struct kvm_vcpu *vcpu,
> >
> >       /* Now we know what it is, we can reset it. */
> >       ret = kvm_reset_vcpu(vcpu);
> > +
> > +     if (!ret)
> > +             ret = kvm_register_width_check_or_init(vcpu);
>
> Why is that called *after* resetting the vcpu, which itself relies on
> KVM_ARM_VCPU_EL1_32BIT, which we agreed to get rid of as much as
> possible?

That's because I didn't want to set EL1_32BIT/REG_WIDTH_CONFIGURED
for the guest based on the vCPU for which KVM_ARM_VCPU_INIT would fail.
The flags can be set in the kvm_reset_vcpu() and cleared in
case of failure.  But then that temporary value could lead
KVM_ARM_VCPU_INIT for other vCPUs to fail, which I don't think
is nice to do.

Another option (almost the same though) I considered was as
follows, which just had kvm_reset_vcpu() use the new flag
when available (The following is the diff from the v3 patches).
KVM_ARM_VCPU_EL1_32BIT is used anyway by kvm_reset_vcpu()
and kvm_set_vm_width() though...

---
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 6c5f7677057d..3542eeb48e5d 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -181,11 +181,8 @@ static int kvm_vcpu_enable_ptrauth(struct kvm_vcpu *vcpu)
  	return 0;
  }
  
-static bool vcpu_allowed_register_width(struct kvm_vcpu *vcpu)
+static bool vcpu_allowed_register_width(struct kvm_vcpu *vcpu, bool is32bit)
  {
-	bool is32bit;
-
-	is32bit = vcpu_has_feature(vcpu, KVM_ARM_VCPU_EL1_32BIT);
  	if (!cpus_have_const_cap(ARM64_HAS_32BIT_EL1) && is32bit)
  		return false;
  
@@ -218,14 +215,27 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
  {
  	struct vcpu_reset_state reset_state;
  	int ret;
-	bool loaded;
+	bool loaded, is32bit;
+	bool allowed = true;
  	u32 pstate;
  
+	is32bit = vcpu_has_feature(vcpu, KVM_ARM_VCPU_EL1_32BIT);
+
  	mutex_lock(&vcpu->kvm->lock);
-	reset_state = vcpu->arch.reset_state;
-	WRITE_ONCE(vcpu->arch.reset_state.reset, false);
+	if (test_bit(KVM_ARCH_FLAG_REG_WIDTH_CONFIGURED, &vcpu->kvm->arch.flags))
+		allowed = (is32bit == vcpu_el1_is_32bit(vcpu));
+	else
+		allowed = vcpu_allowed_register_width(vcpu, is32bit);
+
+	if (allowed) {
+		reset_state = vcpu->arch.reset_state;
+		WRITE_ONCE(vcpu->arch.reset_state.reset, false);
+	}
  	mutex_unlock(&vcpu->kvm->lock);
  
+	if (!allowed)
+		return -EINVAL;
+
  	/* Reset PMU outside of the non-preemptible section */
  	kvm_pmu_vcpu_reset(vcpu);
  
@@ -252,14 +262,9 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
  		}
  	}
  
-	if (!vcpu_allowed_register_width(vcpu)) {
-		ret = -EINVAL;
-		goto out;
-	}
-
  	switch (vcpu->arch.target) {
  	default:
-		if (test_bit(KVM_ARM_VCPU_EL1_32BIT, vcpu->arch.features)) {
+		if (is32bit) {
  			pstate = VCPU_RESET_PSTATE_SVC;
  		} else {
  			pstate = VCPU_RESET_PSTATE_EL1;
--

Thanks,
Reiji
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
