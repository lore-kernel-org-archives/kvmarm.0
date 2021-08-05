Return-Path: <SRS0=fmYt=M4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95786C4338F
	for <kvmarm@archiver.kernel.org>; Thu,  5 Aug 2021 06:28:05 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E59C461050
	for <kvmarm@archiver.kernel.org>; Thu,  5 Aug 2021 06:28:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org E59C461050
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 607104B096;
	Thu,  5 Aug 2021 02:28:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id B+UXtkoNx+Wz; Thu,  5 Aug 2021 02:28:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 551A44B087;
	Thu,  5 Aug 2021 02:28:03 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 442E74083E
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Aug 2021 02:28:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iaPNJnCm888b for <kvmarm@lists.cs.columbia.edu>;
 Thu,  5 Aug 2021 02:28:01 -0400 (EDT)
Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com
 [209.85.208.180])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 30BDB405A6
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Aug 2021 02:28:01 -0400 (EDT)
Received: by mail-lj1-f180.google.com with SMTP id u13so5633843lje.5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 04 Aug 2021 23:28:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=qZujMoRT1ZKK0WrlZq2+xupgWWhgF2cPYjSHNhOFfkU=;
 b=A8TcVfSSUWhwH5Gwiljw1kOaURLOTjY3Hxlw0BvexgCrBmDI1AmbOksHtYpHNO437X
 qp4U2afG8SepZqohJ7E240SqnKG4GNQHuoWvyXSw2H1dzAvMsncgsrBfw3zjGrAXZ+e7
 ajsp/PW3uLnjA29mTqPLW5EHlBUXd90yI+BNEeE2qnEK763ozktvU3lIcjFV3s3ne4T9
 zxUIr5Umhmq6LDpa2oZzfgWtiMt5cdUhDpT/UVszVdo4XnLpU9yGsa21inrQgX3XQ7ab
 DnD51btLSrRk72pk4bh0tDrVV41dNOYd3T5yhe58dzQD+fkuEWM0uenNb5JytQKfUKOu
 AmbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=qZujMoRT1ZKK0WrlZq2+xupgWWhgF2cPYjSHNhOFfkU=;
 b=pPMaICbplfkFuafrqahuHUH0JhXDxXbxdz0grgdHC0Lz1ThAMo3ELYmxXBztWn8IC4
 1Juf6ipC5DGePrig0e2tXBNuuBST9FmVgrin9bUyItvBOfJO868HaJBeYqBtDURoZutN
 L7yRkJpIkOlYYdDwnjFK959aIUVt+WkxwABuGDJDWURwfmt3isLhdxbVdVLz6xDf8m2A
 7zjmqqTEaLTvIHrZUIiNEXu32xYxC7A+l1b3TJTwstlPt2UljMZoGTOoOFxGrLbdC2+x
 cgTEI4hyamc1ULjILV6SIyMSTkjIL7kJRdTOx7vp+JL2y8bwUJbsJsJ2WNks+S1P725v
 mRew==
X-Gm-Message-State: AOAM531KXs0LkkxP/9qL8saBaqms3iUjtCqQq2v1JRpwbIzdWbR5Ncu+
 1S9GATChaJFY9aIJtbTaGDDu3+cxMfTZELGcUNYJ0g==
X-Google-Smtp-Source: ABdhPJx71BAqveU+GESvhEqPQ6+JEFcqk5SdIMktg0RjCYmjLebuoo+kva+QCUatWyOaLmvBQuiQznsARu5ehNolva4=
X-Received: by 2002:a2e:9b4f:: with SMTP id o15mr2061197ljj.22.1628144879477; 
 Wed, 04 Aug 2021 23:27:59 -0700 (PDT)
MIME-Version: 1.0
References: <20210804085819.846610-1-oupton@google.com>
 <20210804085819.846610-20-oupton@google.com>
 <20210804110531.x6gm2bpygg7laiau@gator.home>
In-Reply-To: <20210804110531.x6gm2bpygg7laiau@gator.home>
From: Oliver Upton <oupton@google.com>
Date: Wed, 4 Aug 2021 23:27:48 -0700
Message-ID: <CAOQ_QsgzsS1iMPQ8t+-ivjiTWJbbOQ2k_AmBHar3NqKJ=YydsA@mail.gmail.com>
Subject: Re: [PATCH v6 19/21] KVM: arm64: Emulate physical counter offsetting
 on non-ECV systems
To: Andrew Jones <drjones@redhat.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, kvm@vger.kernel.org,
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
 Raghavendra Rao Anata <rananta@google.com>, Peter Shier <pshier@google.com>,
 Sean Christopherson <seanjc@google.com>, David Matlack <dmatlack@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>
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

Hi Drew,

On Wed, Aug 4, 2021 at 4:05 AM Andrew Jones <drjones@redhat.com> wrote:
> > +static bool ptimer_emulation_required(struct kvm_vcpu *vcpu)
> > +{
> > +     return timer_get_offset(vcpu_ptimer(vcpu)) &&
> > +                     !cpus_have_const_cap(ARM64_ECV);
>
> Whenever I see a static branch check and something else in the same
> condition, I always wonder if we could trim a few instructions for
> the static branch is false case by testing it first.

Good point, I'll reclaim those few cycles in the next spin ;-)

> > @@ -1539,11 +1551,8 @@ int kvm_arm_timer_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
> >       switch (attr->attr) {
> >       case KVM_ARM_VCPU_TIMER_IRQ_VTIMER:
> >       case KVM_ARM_VCPU_TIMER_IRQ_PTIMER:
> > -             return 0;
> >       case KVM_ARM_VCPU_TIMER_OFFSET:
> > -             if (cpus_have_const_cap(ARM64_ECV))
> > -                     return 0;
> > -             break;
> > +             return 0;
>
> So now, if userspace wants to know when they're using an emulated
> TIMER_OFFSET vs. ECV, then they'll need to check the HWCAP. I guess
> that's fair. We should update the selftest to report what it's testing
> when the HWCAP is available.
>

Hmm...

I hadn't yet wired up the ECV cpufeature bits to an ELF HWCAP, but
this point is a bit interesting. I can see the argument being made
that we shouldn't have two ELF HWCAP bits for ECV (depending on
partial or full ECV support). ECV=0x1 is most certainly of interest to
userspace, since self-synchronized views of the counter are then
available. However, ECV=0x2 is purely of interest to EL2.

What if we only had only one ELF HWCAP bit for ECV >= 0x1? We could
let userspace read ID_AA64MMFR0_EL1.ECV if it really needs to know
about ECV = 0x2.

> > +     if (vcpu_ptimer(vcpu)->host_offset && !cpus_have_const_cap(ARM64_ECV))
>
> Shouldn't we expose and reuse ptimer_emulation_required() here?
>

Agreed, makes it much cleaner.

> > +             val &= ~CNTHCTL_EL1PCTEN;
> > +     else
> > +             val |= CNTHCTL_EL1PCTEN;
> >       write_sysreg(val, cnthctl_el2);
> >  }
> > --
> > 2.32.0.605.g8dce9f2422-goog
> >
>
> Otherwise,
>
> Reviewed-by: Andrew Jones <drjones@redhat.com>
>

Thanks!

--
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
