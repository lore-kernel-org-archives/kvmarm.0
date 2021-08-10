Return-Path: <SRS0=u6p1=NB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B81FC432BE
	for <kvmarm@archiver.kernel.org>; Tue, 10 Aug 2021 09:44:21 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AEDA1610CB
	for <kvmarm@archiver.kernel.org>; Tue, 10 Aug 2021 09:44:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org AEDA1610CB
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1D50D4B092;
	Tue, 10 Aug 2021 05:44:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1raole8zWpx6; Tue, 10 Aug 2021 05:44:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 268E04AC80;
	Tue, 10 Aug 2021 05:44:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6AFBF4A4A4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Aug 2021 05:44:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ogV+xtBfvLkb for <kvmarm@lists.cs.columbia.edu>;
 Tue, 10 Aug 2021 05:44:14 -0400 (EDT)
Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com
 [209.85.208.178])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 300074A4A0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Aug 2021 05:44:14 -0400 (EDT)
Received: by mail-lj1-f178.google.com with SMTP id u13so28095222lje.5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Aug 2021 02:44:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=yE5wXZDXK6p9cpZ2q0EZSEm3h7xR70bZBY+/kdRRL0c=;
 b=CRO03wZGW9IhDXyoC7tHi98Ja0XupCcBdJAnNO0LJgz5Hr/4tX8bE7lC8sh5nXSMz4
 r+qJDvdQOTJPMcSkKA/yt+ECcOjls9JMmmNgIfvfEbnxM4o2xQzyJUelT1TmznCjSYzs
 gGwHdKzl9m+H/hhxsyxOSa4DDTSAnlGCJsGkgMFlMB2hC8pZZEjX6C4Yphf8RjExvNff
 1rulAz0nxCsvsAdwaL/xE/pIPBdDLbeRyJC0Qubdu7z/oe4INRDK8fgSAu4JgknRPv96
 xtaOetA4RrzmQ4YJ6NLsjhuKMtZjvZybtrccCQH9GJrw+fTpwpiAfP/232Tf44PidSLD
 Lefg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=yE5wXZDXK6p9cpZ2q0EZSEm3h7xR70bZBY+/kdRRL0c=;
 b=iKk4w+bN+xevzOAPzFL3STQhDcXyikz5mVPdQUPXZFYSLxetr75aD92jYCe+7BFGaY
 zL+sQHFFUf9WLAnRpK8ZVuisPeYkK/w7grMCEFprIpIE9SsUL5371N4z7fsZAwMrxmXi
 iKABuxZ+b0aJVvT4GAn1FBakHHEggkf4Y/rFgYaBs3qT39lhyT83MYsMKmAqtlXoisDW
 GpWIzTh2aQ0t08mvKtp18/C4z2p7hZnBw4jXoPJ+sD4PWjs0Iho3g2yDI3KOg5zsBzSG
 y3XT+N4N32J60Yu3tKErZX0fVQJ2K18iBPoxJ99KtPog5JV/lvaZ1HseAfMivav2bnNp
 7+dw==
X-Gm-Message-State: AOAM533dL/yDYu+iEvhvByIBEzWiE9MO4om80v52f7Z0Hq1PqqyrynXy
 yic123lPIbAFYZ5lQhVWpVVxVN/sOppYEmohSHpcMA==
X-Google-Smtp-Source: ABdhPJxUnypR2IsyYSmdqkzIj2TFW6CoDKEXzQYFw/rzkhRclEucBFJqITY4bz5cpiueE/RXRyoyQxJgKvpb1EKKg+k=
X-Received: by 2002:a2e:89c4:: with SMTP id c4mr18569718ljk.275.1628588652559; 
 Tue, 10 Aug 2021 02:44:12 -0700 (PDT)
MIME-Version: 1.0
References: <20210804085819.846610-1-oupton@google.com>
 <20210804085819.846610-14-oupton@google.com>
 <87czqlbq15.wl-maz@kernel.org>
In-Reply-To: <87czqlbq15.wl-maz@kernel.org>
From: Oliver Upton <oupton@google.com>
Date: Tue, 10 Aug 2021 02:44:01 -0700
Message-ID: <CAOQ_Qsjiyp_HQLhgFfF-o7T=Qpe+djL9KCFjAU2xmj8OXhAf4w@mail.gmail.com>
Subject: Re: [PATCH v6 13/21] KVM: arm64: Allow userspace to configure a
 vCPU's virtual offset
To: Marc Zyngier <maz@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, kvm@vger.kernel.org,
 Will Deacon <will@kernel.org>, Sean Christopherson <seanjc@google.com>,
 Peter Shier <pshier@google.com>, Raghavendra Rao Anata <rananta@google.com>,
 David Matlack <dmatlack@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>
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

On Tue, Aug 10, 2021 at 2:35 AM Marc Zyngier <maz@kernel.org> wrote:
>
> On Wed, 04 Aug 2021 09:58:11 +0100,
> Oliver Upton <oupton@google.com> wrote:
> >
> > Allow userspace to access the guest's virtual counter-timer offset
> > through the ONE_REG interface. The value read or written is defined to
> > be an offset from the guest's physical counter-timer. Add some
> > documentation to clarify how a VMM should use this and the existing
> > CNTVCT_EL0.
> >
> > Signed-off-by: Oliver Upton <oupton@google.com>
> > ---
> >  Documentation/virt/kvm/api.rst    | 10 ++++++++++
> >  arch/arm64/include/uapi/asm/kvm.h |  1 +
> >  arch/arm64/kvm/arch_timer.c       | 11 +++++++++++
> >  arch/arm64/kvm/guest.c            |  6 +++++-
> >  include/kvm/arm_arch_timer.h      |  1 +
> >  5 files changed, 28 insertions(+), 1 deletion(-)
> >
> > diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> > index 8d4a3471ad9e..28a65dc89985 100644
> > --- a/Documentation/virt/kvm/api.rst
> > +++ b/Documentation/virt/kvm/api.rst
> > @@ -2487,6 +2487,16 @@ arm64 system registers have the following id bit patterns::
> >       derived from the register encoding for CNTV_CVAL_EL0.  As this is
> >       API, it must remain this way.
> >
> > +.. warning::
> > +
> > +     The value of KVM_REG_ARM_TIMER_OFFSET is defined as an offset from
> > +     the guest's view of the physical counter-timer.
> > +
> > +     Userspace should use either KVM_REG_ARM_TIMER_OFFSET or
> > +     KVM_REG_ARM_TIMER_CVAL to pause and resume a guest's virtual
>
> You probably mean KVM_REG_ARM_TIMER_CNT here, despite the broken
> encoding.

Indeed I do!

>
> > +     counter-timer. Mixed use of these registers could result in an
> > +     unpredictable guest counter value.
> > +
> >  arm64 firmware pseudo-registers have the following bit pattern::
> >
> >    0x6030 0000 0014 <regno:16>
> > diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> > index b3edde68bc3e..949a31bc10f0 100644
> > --- a/arch/arm64/include/uapi/asm/kvm.h
> > +++ b/arch/arm64/include/uapi/asm/kvm.h
> > @@ -255,6 +255,7 @@ struct kvm_arm_copy_mte_tags {
> >  #define KVM_REG_ARM_TIMER_CTL                ARM64_SYS_REG(3, 3, 14, 3, 1)
> >  #define KVM_REG_ARM_TIMER_CVAL               ARM64_SYS_REG(3, 3, 14, 0, 2)
> >  #define KVM_REG_ARM_TIMER_CNT                ARM64_SYS_REG(3, 3, 14, 3, 2)
> > +#define KVM_REG_ARM_TIMER_OFFSET     ARM64_SYS_REG(3, 4, 14, 0, 3)
>
> I don't think we can use the encoding for CNTPOFF_EL2 here, as it will
> eventually clash with a NV guest using the same feature for its own
> purpose. We don't want this offset to overlap with any of the existing
> features.
>
> I actually liked your previous proposal of controlling the physical
> offset via a device property, as it clearly indicated that you were
> dealing with non-architectural state.

That's actually exactly what I did here :) That said, the macro name
is horribly obfuscated from CNTVOFF_EL2. I did this for the sake of
symmetry with other virtual counter-timer registers above, though this
may warrant special casing given the fact that we have a similarly
named device attribute to handle the physical offset.

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
