Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C195C433F5
	for <kvmarm@archiver.kernel.org>; Tue, 30 Nov 2021 00:57:19 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AB4C64B121;
	Mon, 29 Nov 2021 19:57:18 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0LQ-RO3ErJQ5; Mon, 29 Nov 2021 19:57:16 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A5ACB4B1B0;
	Mon, 29 Nov 2021 19:57:16 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 44A9849E57
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Nov 2021 19:57:16 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nX2GMz6RTmdw for <kvmarm@lists.cs.columbia.edu>;
 Mon, 29 Nov 2021 19:57:14 -0500 (EST)
Received: from mail-yb1-f171.google.com (mail-yb1-f171.google.com
 [209.85.219.171])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CA9E64B125
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Nov 2021 19:57:14 -0500 (EST)
Received: by mail-yb1-f171.google.com with SMTP id q74so47437350ybq.11
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Nov 2021 16:57:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=esRLWzH6dw+Ce7phJ2ONogztplO8dpDdVUer7uLYFyE=;
 b=U5aJzHs/FlOo0fNLHNpFTCG7aV5AVGzHjOwJv+ZRQZ2UYblO/Xoq68Mh+LgMAMEAwG
 gwa4zJ90Q4Vp3p//JZbIjVpEVxN22f3h+4+7sxeGO3sWwSmqmkrdz9jnHCSb8YiN2upS
 D5/Ndr10UjtHbiuh4FI5cWeoCkqsB0aTL44awIBISsM9N3zTXpwRLBVNjjFjIWCBIAR2
 CqaFqQtCrMACvIkUHE15giu+ir9UH3UZ8bOr0YqtuXy0pXWMKyxt97pf5dNW50HQAd3P
 Xq4aMkwtelVEamSaY/KLEzVzDqoYGw++6mQuJua5WoTXkJxRUXI/ALyHcOXeHdQOkQOB
 T1FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=esRLWzH6dw+Ce7phJ2ONogztplO8dpDdVUer7uLYFyE=;
 b=fVt5fqxk3d6hAHrCCbNb8f/gEfrm26X2o6oTMG1JCErC+fE24KXbfZpCgf9Xu+hcXG
 8V9Hn27HQlEiaPsXeFn4lAHT3pauhrAUpzFZ0W/Yn1faXpplXSnjtKKnj1HswDgI2p6+
 ijDpKi69kC+UAU0Jy55x8LSZDgePV6bLztuhsHkIybyy8LpwAnxTxrOWFeNWGucpqRvD
 Z6+coZ1YAWdInUijUWDoU4jTB2EYchKkjzY5yCFUhcFSPzghEj0ETUEyXP42OjGq650t
 HgHarKPmZHqCylts/gvtMwf0Dus6wp5Z3QITFfvIemAETtlsNNoPn0toMIx1NFjz/pLj
 RXkQ==
X-Gm-Message-State: AOAM533TlQEU31mpaHP6rs/OtsKmgs007MtvrtH53giQDAaj3wROYQ0X
 B13+dRoVEtZem1lfzzoYcIEdRjLywzsCzl4XtaEerg==
X-Google-Smtp-Source: ABdhPJxBtrnBwZDK0SfMN9ZP26BpdgE0OykhJRvFEkCn6qO1fburjBb59wkMhZpu1UbE5WIus+YADqwKUV0GYHNYlNY=
X-Received: by 2002:a25:d003:: with SMTP id h3mr33831953ybg.184.1638233834133; 
 Mon, 29 Nov 2021 16:57:14 -0800 (PST)
MIME-Version: 1.0
References: <20211113012234.1443009-1-rananta@google.com>
 <20211113012234.1443009-2-rananta@google.com>
 <20211127131628.iihianybqbeyjdbg@gator.home>
In-Reply-To: <20211127131628.iihianybqbeyjdbg@gator.home>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Mon, 29 Nov 2021 16:57:03 -0800
Message-ID: <CAJHc60yfmkPxchCgLT7FMabcmodYLhcJJDiJA3EDiS2nMSHQgg@mail.gmail.com>
Subject: Re: [RFC PATCH v2 01/11] KVM: arm64: Factor out firmware register
 handling from psci.c
To: Andrew Jones <drjones@redhat.com>
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
 linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

On Sat, Nov 27, 2021 at 5:16 AM Andrew Jones <drjones@redhat.com> wrote:
>
> On Sat, Nov 13, 2021 at 01:22:24AM +0000, Raghavendra Rao Ananta wrote:
> > Common hypercall firmware register handing is currently employed
> > by psci.c. Since the upcoming patches add more of these registers,
> > it's better to move the generic handling to hypercall.c for a
> > cleaner presentation.
> >
> > While we are at it, collect all the firmware registers under
> > fw_reg_ids[] to help implement kvm_arm_get_fw_num_regs() and
> > kvm_arm_copy_fw_reg_indices() in a generic way.
> >
> > No functional change intended.
> >
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > ---
> >  arch/arm64/kvm/guest.c       |   2 +-
> >  arch/arm64/kvm/hypercalls.c  | 170 +++++++++++++++++++++++++++++++++++
> >  arch/arm64/kvm/psci.c        | 166 ----------------------------------
> >  include/kvm/arm_hypercalls.h |   7 ++
> >  include/kvm/arm_psci.h       |   7 --
> >  5 files changed, 178 insertions(+), 174 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> > index 5ce26bedf23c..625f97f7b304 100644
> > --- a/arch/arm64/kvm/guest.c
> > +++ b/arch/arm64/kvm/guest.c
> > @@ -18,7 +18,7 @@
> >  #include <linux/string.h>
> >  #include <linux/vmalloc.h>
> >  #include <linux/fs.h>
> > -#include <kvm/arm_psci.h>
> > +#include <kvm/arm_hypercalls.h>
> >  #include <asm/cputype.h>
> >  #include <linux/uaccess.h>
> >  #include <asm/fpsimd.h>
> > diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
> > index 30da78f72b3b..9e136d91b470 100644
> > --- a/arch/arm64/kvm/hypercalls.c
> > +++ b/arch/arm64/kvm/hypercalls.c
> > @@ -146,3 +146,173 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
> >       smccc_set_retval(vcpu, val[0], val[1], val[2], val[3]);
> >       return 1;
> >  }
> > +
> > +static const u64 fw_reg_ids[] = {
> > +     KVM_REG_ARM_PSCI_VERSION,
> > +     KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1,
> > +     KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2,
> > +};
> > +
> > +int kvm_arm_get_fw_num_regs(struct kvm_vcpu *vcpu)
> > +{
> > +     return ARRAY_SIZE(fw_reg_ids);
> > +}
> > +
> > +int kvm_arm_copy_fw_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
> > +{
> > +     int i;
> > +
> > +     for (i = 0; i < ARRAY_SIZE(fw_reg_ids); i++) {
> > +             if (put_user(fw_reg_ids[i], uindices))
>
> This is missing the ++ on uindices, so it just writes the same offset
> three times.
>
Thanks for catching this! I believe I realized this later and
corrected it in patch-04/11 of the series and missed it here.
I'll fix it here as well.

> > +                     return -EFAULT;
> > +     }
> > +
> > +     return 0;
> > +}
>
> I assume the rest of the patch is just a cut+paste move of code.
>
That's right.

Regards,
Raghavendra

> Thanks,
> drew
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
