Return-Path: <SRS0=McOM=P3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09C51C433F5
	for <kvmarm@archiver.kernel.org>; Mon,  8 Nov 2021 21:33:44 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8086A614C8
	for <kvmarm@archiver.kernel.org>; Mon,  8 Nov 2021 21:33:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 8086A614C8
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EB4DA4B1BC;
	Mon,  8 Nov 2021 16:33:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Lho6I1l6Aai7; Mon,  8 Nov 2021 16:33:41 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 295C84B1C0;
	Mon,  8 Nov 2021 16:33:41 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F29DE4B1BC
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Nov 2021 16:33:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6QGRg5CQdTYN for <kvmarm@lists.cs.columbia.edu>;
 Mon,  8 Nov 2021 16:33:38 -0500 (EST)
Received: from mail-il1-f177.google.com (mail-il1-f177.google.com
 [209.85.166.177])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0EC744B0E1
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Nov 2021 16:33:38 -0500 (EST)
Received: by mail-il1-f177.google.com with SMTP id s14so18475292ilv.10
 for <kvmarm@lists.cs.columbia.edu>; Mon, 08 Nov 2021 13:33:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=hFSV1mBws9eLeLO5kPMmlLtWrmSlD924TaH/pakFmoU=;
 b=O7/fYinykmp/KyEQVR3JRt816V+8zD9gdBIlkyp3lTFLY/wKMfxdp7IVHhrIv/GSz9
 bosru1a/4zIf0Dp3NEv9gwxuV1MP3HEVomdXK7nf0ciuQXqQSwaiMJ/fqzudASPJQRb0
 AuyZzjiupsk0i+PgdPFaz8nTBRKhGEoAp29RScs9pyG0d8RWLvWTSv8XkaVhjGgHeMAl
 hj0mPf/gARZOMHKMXPzGUtAiaX6nrQbeFliJbfaa0DFCx3/LKw2HBPWxgmB7VIPkpQ0g
 j80tXIUKKWHBKfTzcww2g+aGHCatQqgcDjjhcznu44WID6chwqvLvwCah5B4E4hj77iO
 2LQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=hFSV1mBws9eLeLO5kPMmlLtWrmSlD924TaH/pakFmoU=;
 b=IgnqnvvS/vwQXKmGeG2LFhurA2ys4QjuJoPsmqKcYdxlPMb19irHDJh8E5SraxHLAN
 Xeo2xpUzkMf67zEqMtVifkJ86NvTcjOe65AHnh/vJANquGCb39FGuGmei8L48JRgU06s
 nsTPuVdcYQet6wWL/+M94FAaITTnCz1+dX0UPlG7WS2JjjsjWXPYke+JIZzCo1GIeZJF
 TIMuyqrYJsxz2/LFTa1miSoKKgQw5vF/8lo8VvtLcoTEyZYmnFYzah/T4vhht8AoYgXr
 DEHFBer/MJaSKF2j1od7gFI+uhzYKL5WJfctlc7eithu+MDgWndqmtbBmjsfGKZfqoC2
 9/JA==
X-Gm-Message-State: AOAM530DVeHzHB8Eo2ZWkCT6Pw9GPrHsbQqR+Pf6gF75iQyxyVdVakhE
 q96OReGzKmY8WrnaPyP9jpb1eA==
X-Google-Smtp-Source: ABdhPJzjPhy8/nW/9RIzLXtQxLZfiK10pduutrQX2tnPGXqQ62lKvQDM2Oe1tiRS22zzVFnb21gvuw==
X-Received: by 2002:a05:6e02:2166:: with SMTP id
 s6mr1565008ilv.170.1636407217245; 
 Mon, 08 Nov 2021 13:33:37 -0800 (PST)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194])
 by smtp.gmail.com with ESMTPSA id x11sm945804iop.55.2021.11.08.13.33.36
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 08 Nov 2021 13:33:36 -0800 (PST)
Date: Mon, 8 Nov 2021 21:33:33 +0000
From: Oliver Upton <oupton@google.com>
To: Raghavendra Rao Ananta <rananta@google.com>
Subject: Re: [RFC PATCH 1/8] KVM: arm64: Factor out firmware register
 handling from psci.c
Message-ID: <YYmXrfCntqEgCeDX@google.com>
References: <20211102002203.1046069-1-rananta@google.com>
 <20211102002203.1046069-2-rananta@google.com>
 <YYMCgC6qMEEWhNrk@google.com>
 <CAJHc60wGi3wLNv97dFo1BoOjRUCpNSvw6u_nA+uunJX=k5+dEA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAJHc60wGi3wLNv97dFo1BoOjRUCpNSvw6u_nA+uunJX=k5+dEA@mail.gmail.com>
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
 linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On Thu, Nov 04, 2021 at 10:16:21AM -0700, Raghavendra Rao Ananta wrote:
> Hi Oliver,
> 
> On Wed, Nov 3, 2021 at 2:43 PM Oliver Upton <oupton@google.com> wrote:
> >
> > Hi Raghu,
> >
> > On Tue, Nov 02, 2021 at 12:21:56AM +0000, Raghavendra Rao Ananta wrote:
> > > Common hypercall firmware register handing is currently employed
> > > by psci.c. Since the upcoming patches add more of these registers,
> > > it's better to move the generic handling to hypercall.c for a
> > > cleaner presentation.
> > >
> > > While we are at it, collect all the firmware registers under
> > > fw_reg_ids[] to help implement kvm_arm_get_fw_num_regs() and
> > > kvm_arm_copy_fw_reg_indices() in a generic way.
> > >
> > > No functional change intended.
> > >
> > > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > > ---
> > >  arch/arm64/kvm/guest.c       |   2 +-
> > >  arch/arm64/kvm/hypercalls.c  | 151 +++++++++++++++++++++++++++++++
> > >  arch/arm64/kvm/psci.c        | 167 +++--------------------------------
> > >  include/kvm/arm_hypercalls.h |   7 ++
> > >  include/kvm/arm_psci.h       |   8 +-
> > >  5 files changed, 172 insertions(+), 163 deletions(-)
> > >
> > > diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> > > index 5ce26bedf23c..625f97f7b304 100644
> > > --- a/arch/arm64/kvm/guest.c
> > > +++ b/arch/arm64/kvm/guest.c
> > > @@ -18,7 +18,7 @@
> > >  #include <linux/string.h>
> > >  #include <linux/vmalloc.h>
> > >  #include <linux/fs.h>
> > > -#include <kvm/arm_psci.h>
> > > +#include <kvm/arm_hypercalls.h>
> > >  #include <asm/cputype.h>
> > >  #include <linux/uaccess.h>
> > >  #include <asm/fpsimd.h>
> > > diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
> > > index 30da78f72b3b..d030939c5929 100644
> > > --- a/arch/arm64/kvm/hypercalls.c
> > > +++ b/arch/arm64/kvm/hypercalls.c
> > > @@ -146,3 +146,154 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
> > >       smccc_set_retval(vcpu, val[0], val[1], val[2], val[3]);
> > >       return 1;
> > >  }
> > > +
> > > +static const u64 fw_reg_ids[] = {
> > > +     KVM_REG_ARM_PSCI_VERSION,
> > > +     KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1,
> > > +     KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2,
> > > +};
> > > +
> > > +int kvm_arm_get_fw_num_regs(struct kvm_vcpu *vcpu)
> > > +{
> > > +     return ARRAY_SIZE(fw_reg_ids);
> > > +}
> > > +
> > > +int kvm_arm_copy_fw_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
> > > +{
> > > +     int i;
> > > +
> > > +     for (i = 0; i < ARRAY_SIZE(fw_reg_ids); i++) {
> > > +             if (put_user(fw_reg_ids[i], uindices))
> > > +                     return -EFAULT;
> > > +     }
> > > +
> > > +     return 0;
> > > +}
> >
> > It would appear that this patch is separating out the hypercall services
> > to each handle their own FW regs. At the same time, this is
> > consolidating the register enumeration into a single place.
> >
> > It would be nice to keep the scoping consistent with your accessors
> > below, or simply just handle all regs in hypercalls.c. Abstracting
> > per-service might result in a lot of boilerplate, though.
> >
> It's neither here nor there, unfortunately, because of how the fw
> registers exists. We have a dedicated fw register for psci and a file
> of its own (psci.c). Some of the other services, such as TRNG, have
> their own file, but because of the bitmap design, they won't have
> their own fw register. And the ARCH_WORKAROUND have their dedicated
> registers, but no file of their own. So, at best I was aiming to push
> all the things relevant to a service in its own file (psci for
> example), just to have a better file-context, while leaving others
> (and generic handling stuff) in hypercall.c.
> 
> Just to maintain consistency, I can create a dedicated file for the
> ARCH_WORKAROUND registers, if you feel that's better.
>

Perhaps the easiest thing to do would be to keep all firmware ID
registers in one place, much like we do for the ARM feature ID regs in
sys_regs.c.

> > > +#define KVM_REG_FEATURE_LEVEL_WIDTH  4
> > > +#define KVM_REG_FEATURE_LEVEL_MASK   (BIT(KVM_REG_FEATURE_LEVEL_WIDTH) - 1)
> > > +
> > > +/*
> > > + * Convert the workaround level into an easy-to-compare number, where higher
> > > + * values mean better protection.
> > > + */
> > > +static int get_kernel_wa_level(u64 regid)
> > > +{
> > > +     switch (regid) {
> > > +     case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1:
> > > +             switch (arm64_get_spectre_v2_state()) {
> > > +             case SPECTRE_VULNERABLE:
> > > +                     return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_NOT_AVAIL;
> > > +             case SPECTRE_MITIGATED:
> > > +                     return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_AVAIL;
> > > +             case SPECTRE_UNAFFECTED:
> > > +                     return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_NOT_REQUIRED;
> > > +             }
> > > +             return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_NOT_AVAIL;
> > > +     case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2:
> > > +             switch (arm64_get_spectre_v4_state()) {
> > > +             case SPECTRE_MITIGATED:
> > > +                     /*
> > > +                      * As for the hypercall discovery, we pretend we
> > > +                      * don't have any FW mitigation if SSBS is there at
> > > +                      * all times.
> > > +                      */
> > > +                     if (cpus_have_final_cap(ARM64_SSBS))
> > > +                             return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_AVAIL;
> > > +                     fallthrough;
> > > +             case SPECTRE_UNAFFECTED:
> > > +                     return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_REQUIRED;
> > > +             case SPECTRE_VULNERABLE:
> > > +                     return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_AVAIL;
> > > +             }
> > > +     }
> > > +
> > > +     return -EINVAL;
> > > +}
> > > +
> > > +int kvm_arm_get_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
> > > +{
> > > +     void __user *uaddr = (void __user *)(long)reg->addr;
> > > +     u64 val;
> > > +
> > > +     switch (reg->id) {
> > > +     case KVM_REG_ARM_PSCI_VERSION:
> > > +             val = kvm_psci_version(vcpu, vcpu->kvm);
> >
> > Should this become kvm_arm_get_fw_reg() to consistently genericize the
> > PSCI FW register accessors?
> >
> Sorry, I didn't follow. Did you mean, "kvm_arm_get_psci_fw_reg()"?

Right :) Of course, this could become irrelevant depending on how you
address scoping of the FW regs.

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
