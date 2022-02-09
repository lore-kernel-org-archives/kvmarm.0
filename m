Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8F01C433EF
	for <kvmarm@archiver.kernel.org>; Wed,  9 Feb 2022 05:32:59 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2F0FD49F1F;
	Wed,  9 Feb 2022 00:32:59 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id d4F7ciZCx+m5; Wed,  9 Feb 2022 00:32:57 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 932F249F11;
	Wed,  9 Feb 2022 00:32:57 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3C61549EE4
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Feb 2022 00:32:56 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WCtFk4ddHd56 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Feb 2022 00:32:54 -0500 (EST)
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com
 [209.85.214.182])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E877A49F13
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Feb 2022 00:32:53 -0500 (EST)
Received: by mail-pl1-f182.google.com with SMTP id y17so1275517plg.7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 08 Feb 2022 21:32:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=D7+YcMiVd9Hc5kLj7x+yGkNfQLVgsxIrCv5I0j/D974=;
 b=T/1vFjr/klDZo5A5X5ggCsvek2MMTbk5/3/i0aHupQOIkDv86nwidKxw/tbeAw4R19
 Tf1mQM82xZ4gsc6MAxi7PJemsCUcAWjT5AaDo5pBTyXIcNIhFanNPRxndhMgx3/04N+D
 DDhg91V0jNUa5K0L4nbzVAGhBAS8G1c7dihUsmbTmbEqTLwf6vO7U7rI4Z5g9tJ1T9CI
 Dh+fL1WOHq8aiEjwqYDP16LGjrmstu+zW7Uaf1XykxhMXWKDLSbs8gCpQoI/UHtsJrgJ
 hASFrEqTdoNJBXQXGj0i+uxaW+qCqcT1+vm9ttrv/slQzgYTh0BXNwAVHh/tCk9f+lSc
 sU5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=D7+YcMiVd9Hc5kLj7x+yGkNfQLVgsxIrCv5I0j/D974=;
 b=oLyYFV8DFfyXK6xahciKojwMcBhHleLLwGaVP9TUjMTNUL/lI9L7MgF6hJEIAuAxob
 sAnGLzwQgguxycLFHFvc+gK78n2ghN+Jq+l6rSwTdtPkoFxWRN1UonGge2rjwZKiM9bg
 WQTEleveEqgWcwi/P9+JU7YFwXhHlYOaQWsO8wtD2fR7mkzIuV5ymb3WXZMT1SDdmgwr
 lFEMz/DxhiOt1ju0s0BVoRWcwcDHg479BUvIJv0yX9ZPNUlveyrwzU1nsFEuGWPrqFJz
 ym7wFwIGzjBaApo3dCDUQ1NAjpTvTjj2sYhAa64fgsmZfv3SK96rhuUD24ZML2+xYNwZ
 u5gA==
X-Gm-Message-State: AOAM533rJKJHzYTowURtFGP2LIx4TiqHU/JVkrhczcUhCEemnpCnfdAK
 pgqZLhK1mIk0VM3vLC0v5+bFUS9SHGBAxtCw5x7bUQ==
X-Google-Smtp-Source: ABdhPJznT0fnJAY2aJA3dYTn4irEUJ2fBda+hZqSpZYoIBeH+8guaG7eqjsRvBe9hvrs6mGMqzYzGv9YSYlFZfRrQ9s=
X-Received: by 2002:a17:902:bc83:: with SMTP id
 bb3mr573731plb.172.1644384772628; 
 Tue, 08 Feb 2022 21:32:52 -0800 (PST)
MIME-Version: 1.0
References: <20220118041923.3384602-1-reijiw@google.com>
 <87a6f15skj.wl-maz@kernel.org>
In-Reply-To: <87a6f15skj.wl-maz@kernel.org>
From: Reiji Watanabe <reijiw@google.com>
Date: Tue, 8 Feb 2022 21:32:36 -0800
Message-ID: <CAAeT=FwjcgTM0hKSERfVMYDvYWqdC+Deqd=x2xT=-Zymb6SLtA@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] KVM: arm64: mixed-width check should be skipped
 for uninitialized vCPUs
To: Marc Zyngier <maz@kernel.org>
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Marc,

On Tue, Feb 8, 2022 at 6:41 AM Marc Zyngier <maz@kernel.org> wrote:
>
> On Tue, 18 Jan 2022 04:19:22 +0000,
> Reiji Watanabe <reijiw@google.com> wrote:
> >
> > KVM allows userspace to configure either all 32bit or 64bit vCPUs
> > for a guest.  At vCPU reset, vcpu_allowed_register_width() checks
> > if the vcpu's register width is consistent with all other vCPUs'.
> > Since the checking is done even against vCPUs that are not initialized
> > (KVM_ARM_VCPU_INIT has not been done) yet, the uninitialized vCPUs
> > are erroneously treated as 64bit vCPU, which causes the function to
> > incorrectly detect a mixed-width VM.
> >
> > Introduce a new flag (el1_reg_width) in kvm_arch to indicates that
> > the guest needs to be configured with all 32bit or 64bit vCPUs,
> > and initialize it at the first KVM_ARM_VCPU_INIT for the guest.
> > Check vcpu's register width against the flag at the vcpu's
> > KVM_ARM_VCPU_INIT (instead of against other vCPUs' register width).
> >
> > Fixes: 66e94d5cafd4 ("KVM: arm64: Prevent mixed-width VM creation")
> > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_host.h | 13 +++++++++++++
> >  arch/arm64/kvm/arm.c              | 30 ++++++++++++++++++++++++++++++
> >  arch/arm64/kvm/reset.c            |  8 --------
> >  3 files changed, 43 insertions(+), 8 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index 2a5f7f38006f..c02b7caf2c82 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -102,6 +102,12 @@ struct kvm_s2_mmu {
> >  struct kvm_arch_memory_slot {
> >  };
> >
> > +enum kvm_el1_reg_width {
> > +     EL1_WIDTH_UNINITIALIZED = 0,
> > +     EL1_32BIT,
> > +     EL1_64BIT,
> > +};
> > +
> >  struct kvm_arch {
> >       struct kvm_s2_mmu mmu;
> >
> > @@ -137,6 +143,13 @@ struct kvm_arch {
> >
> >       /* Memory Tagging Extension enabled for the guest */
> >       bool mte_enabled;
> > +
> > +     /*
> > +      * EL1 register width for the guest.
> > +      * This is set at the first KVM_ARM_VCPU_INIT for the guest based
> > +      * on whether the vcpu has KVM_ARM_VCPU_EL1_32BIT or not.
> > +      */
> > +     enum kvm_el1_reg_width el1_reg_width;
>
> I really don't like that we need to keep track of yet another bit of
> state on top of the existing one. Duplicating state is a source of
> bugs, because you always end up checking the wrong one at the wrong
> time (and I have scars to prove it).
>
> >  };
> >
> >  struct kvm_vcpu_fault_info {
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index e4727dc771bf..54ae8bf9d187 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -1058,6 +1058,32 @@ int kvm_vm_ioctl_irq_line(struct kvm *kvm, struct kvm_irq_level *irq_level,
> >       return -EINVAL;
> >  }
> >
> > +/*
> > + * A guest can have either all 32bit or 64bit vcpus only.
>
> That's not strictly true. All we are enforcing is that EL1 is either
> 32 or 64bit.

I will fix the comment.


>
> > + * Either one the guest has is indicated in kvm->arch.el1_reg_width.
> > + * Check if the vcpu's register width is consistent with
> > + * kvm->arch.el1_reg_width.  If kvm->arch.el1_reg_width is not set yet,
> > + * set it based on the vcpu's KVM_ARM_VCPU_EL1_32BIT configuration.
> > + */
> > +static int kvm_register_width_check_or_init(struct kvm_vcpu *vcpu)
> > +{
> > +     bool is32bit;
> > +     bool allowed = true;
> > +     struct kvm *kvm = vcpu->kvm;
> > +
> > +     is32bit = vcpu_has_feature(vcpu, KVM_ARM_VCPU_EL1_32BIT);
> > +
> > +     mutex_lock(&kvm->lock);
> > +
> > +     if (kvm->arch.el1_reg_width == EL1_WIDTH_UNINITIALIZED)
> > +             kvm->arch.el1_reg_width = is32bit ? EL1_32BIT : EL1_64BIT;
> > +     else
> > +             allowed = (is32bit == (kvm->arch.el1_reg_width == EL1_32BIT));
> > +
> > +     mutex_unlock(&kvm->lock);
> > +     return allowed ? 0 : -EINVAL;
> > +}
> > +
> >  static int kvm_vcpu_set_target(struct kvm_vcpu *vcpu,
> >                              const struct kvm_vcpu_init *init)
> >  {
> > @@ -1097,6 +1123,10 @@ static int kvm_vcpu_set_target(struct kvm_vcpu *vcpu,
> >
> >       /* Now we know what it is, we can reset it. */
> >       ret = kvm_reset_vcpu(vcpu);
> > +
> > +     if (!ret)
> > +             ret = kvm_register_width_check_or_init(vcpu);
> > +
> >       if (ret) {
> >               vcpu->arch.target = -1;
> >               bitmap_zero(vcpu->arch.features, KVM_VCPU_MAX_FEATURES);
> > diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> > index 426bd7fbc3fd..dbf2939a6a96 100644
> > --- a/arch/arm64/kvm/reset.c
> > +++ b/arch/arm64/kvm/reset.c
> > @@ -168,9 +168,7 @@ static int kvm_vcpu_enable_ptrauth(struct kvm_vcpu *vcpu)
> >
> >  static bool vcpu_allowed_register_width(struct kvm_vcpu *vcpu)
> >  {
> > -     struct kvm_vcpu *tmp;
> >       bool is32bit;
> > -     int i;
> >
> >       is32bit = vcpu_has_feature(vcpu, KVM_ARM_VCPU_EL1_32BIT);
> >       if (!cpus_have_const_cap(ARM64_HAS_32BIT_EL1) && is32bit)
> > @@ -180,12 +178,6 @@ static bool vcpu_allowed_register_width(struct kvm_vcpu *vcpu)
> >       if (kvm_has_mte(vcpu->kvm) && is32bit)
> >               return false;
> >
> > -     /* Check that the vcpus are either all 32bit or all 64bit */
> > -     kvm_for_each_vcpu(i, tmp, vcpu->kvm) {
> > -             if (vcpu_has_feature(tmp, KVM_ARM_VCPU_EL1_32BIT) != is32bit)
> > -                     return false;
> > -     }
> > -
>
> In [1], I suggested another approach that didn't require extra state,
> and moved the existing checks under the kvm lock. What was wrong with
> that approach?

With that approach, even for a vcpu that has a broken set of features,
which leads kvm_reset_vcpu() to fail for the vcpu, the vcpu->arch.features
are checked by other vCPUs' vcpu_allowed_register_width() until the
vcpu->arch.target is set to -1.
Due to this, I would think some or possibly all vCPUs' kvm_reset_vcpu()
may or may not fail (e.g. if userspace tries to configure vCPU#0 with
32bit EL1, and vCPU#1 and #2 with 64 bit EL1, KVM_ARM_VCPU_INIT
for either vCPU#0, or both vCPU#1 and #2 should fail.  But, with that
approach, it doesn't always work that way.  Instead, KVM_ARM_VCPU_INIT
for all vCPUs could fail or KVM_ARM_VCPU_INIT for vCPU#0 and #1 could
fail while the one for CPU#2 works).
Also, even after the first KVM_RUN for vCPUs are already done,
(the first) KVM_ARM_VCPU_INIT for another vCPU could cause the
kvm_reset_vcpu() for those vCPUs to fail.

I would think those behaviors are odd, and I wanted to avoid them.

Thanks,
Reiji




>
> Thanks,
>
>         M.
>
> [1] https://lore.kernel.org/r/875yqqtn5q.wl-maz@kernel.org
>
> --
> Without deviation from the norm, progress is not possible.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
