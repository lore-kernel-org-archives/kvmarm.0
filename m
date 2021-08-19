Return-Path: <SRS0=/4wP=NK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA01EC4338F
	for <kvmarm@archiver.kernel.org>; Thu, 19 Aug 2021 10:21:02 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3B9F260EBC
	for <kvmarm@archiver.kernel.org>; Thu, 19 Aug 2021 10:21:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 3B9F260EBC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A83164A49C;
	Thu, 19 Aug 2021 06:21:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id nspIXCYf-lJw; Thu, 19 Aug 2021 06:20:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D32784A524;
	Thu, 19 Aug 2021 06:20:57 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C4A774A524
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Aug 2021 06:20:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UlqzVp62kYBL for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 Aug 2021 06:20:54 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C604A4A49C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Aug 2021 06:20:54 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1629368454;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=L1CCzAeJSpDDezCsXtRC9C3/Zrf0t5tN8EP1vLgFDsA=;
 b=PGsom/lHPOUwk23xAPZs0kT7+1kbMAkC5MPD2WlBwlgkFvM4L3M9PxCbBTGOStweljI+C+
 EtxzFXoc/Hf9PpnnOxyPSCqPgqpErKBOug5aP81gSANGTPuabnsfWDRXkXD5OByS/v6iuq
 KC/hwYt1X9yhkP9ih9FN9yeNmGm85To=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-309-YuIVsfDDM3ugQVi8ZxC5gA-1; Thu, 19 Aug 2021 06:20:53 -0400
X-MC-Unique: YuIVsfDDM3ugQVi8ZxC5gA-1
Received: by mail-ej1-f70.google.com with SMTP id
 s11-20020a170906060b00b005be824f15daso2070206ejb.2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Aug 2021 03:20:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=L1CCzAeJSpDDezCsXtRC9C3/Zrf0t5tN8EP1vLgFDsA=;
 b=cd8ICsXB14h1QkI1aFtFZ0KhPS7FBMbfmMB5uAFR1hpmjQicROts3Wu1lChSJy162g
 Ltcq4pXfckbLfEkFGK+RKMJT8zkdpXyBNw9srsOIQXHaiHvZXA/xTxnzv7ESUYj2xecv
 muKSR6n3rBMmNeURXQaLZC4scubbxx/OB50Ly52fLemHRfUOYBGpLMik1dkm5caECltF
 pfJLO/m7KlOALGN0yJvDOsEOux+WZ2aA2ygWb/eHhslvp0OEMXutsi+ckW0dDDj3WglS
 MTfeJw63B9AeBUUcXab5sIedT6v1ie0g0sLiE6+BM87Qa7p9SzTpQhU7bn0BTKi56x6Q
 m1jg==
X-Gm-Message-State: AOAM533lB0OiKU6zxwc2jyG5bIef/T58LWcshvq+vnVz55+Hm+myO2Fq
 gCNzh1L0wNTAbITCbtodBdHK8fG/dYt5v4iGhre4slXRfe/MaUxD9ZNopcou7tjRCrzAqROSG7o
 D1voJPbxKZsu9dZFQVSYJH8GH
X-Received: by 2002:a17:907:98b1:: with SMTP id
 ju17mr8008290ejc.184.1629368452321; 
 Thu, 19 Aug 2021 03:20:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzBfnTVCvp6rGinFVT8nbfW7JjQV7oLtknw18f9vGb86D+Jkir22d3T6cemMPFhCyhW/uyIrg==
X-Received: by 2002:a17:907:98b1:: with SMTP id
 ju17mr8008256ejc.184.1629368452082; 
 Thu, 19 Aug 2021 03:20:52 -0700 (PDT)
Received: from gator.home (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
 by smtp.gmail.com with ESMTPSA id f20sm1065910ejz.30.2021.08.19.03.20.50
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 19 Aug 2021 03:20:51 -0700 (PDT)
Date: Thu, 19 Aug 2021 12:20:49 +0200
From: Andrew Jones <drjones@redhat.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v7 3/7] KVM: arm64: Allow userspace to configure a vCPU's
 virtual offset
Message-ID: <20210819102049.xbpwancdrram6ujj@gator.home>
References: <20210816001217.3063400-1-oupton@google.com>
 <20210816001217.3063400-4-oupton@google.com>
 <874kblsssy.wl-maz@kernel.org>
MIME-Version: 1.0
In-Reply-To: <874kblsssy.wl-maz@kernel.org>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: Catalin Marinas <catalin.marinas@arm.com>, kvm@vger.kernel.org,
 Sean Christopherson <seanjc@google.com>, Peter Shier <pshier@google.com>,
 Raghavendra Rao Anata <rananta@google.com>,
 David Matlack <dmatlack@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
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

On Thu, Aug 19, 2021 at 10:11:09AM +0100, Marc Zyngier wrote:
> On Mon, 16 Aug 2021 01:12:13 +0100,
> Oliver Upton <oupton@google.com> wrote:
> > 
> > Allow userspace to access the guest's virtual counter-timer offset
> > through the ONE_REG interface. The value read or written is defined to
> > be an offset from the guest's physical counter-timer. Add some
> > documentation to clarify how a VMM should use this and the existing
> > CNTVCT_EL0.
> > 
> > Signed-off-by: Oliver Upton <oupton@google.com>
> > Reviewed-by: Andrew Jones <drjones@redhat.com>
> > ---
> >  Documentation/virt/kvm/api.rst    | 10 ++++++++++
> >  arch/arm64/include/uapi/asm/kvm.h |  1 +
> >  arch/arm64/kvm/arch_timer.c       | 23 +++++++++++++++++++++++
> >  arch/arm64/kvm/guest.c            |  6 +++++-
> >  include/kvm/arm_arch_timer.h      |  1 +
> >  5 files changed, 40 insertions(+), 1 deletion(-)
> > 
> > diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> > index dae68e68ca23..adb04046a752 100644
> > --- a/Documentation/virt/kvm/api.rst
> > +++ b/Documentation/virt/kvm/api.rst
> > @@ -2463,6 +2463,16 @@ arm64 system registers have the following id bit patterns::
> >       derived from the register encoding for CNTV_CVAL_EL0.  As this is
> >       API, it must remain this way.
> >  
> > +.. warning::
> > +
> > +     The value of KVM_REG_ARM_TIMER_OFFSET is defined as an offset from
> > +     the guest's view of the physical counter-timer.
> > +
> > +     Userspace should use either KVM_REG_ARM_TIMER_OFFSET or
> > +     KVM_REG_ARM_TIMER_CNT to pause and resume a guest's virtual
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
> >  #define KVM_REG_ARM_TIMER_CTL		ARM64_SYS_REG(3, 3, 14, 3, 1)
> >  #define KVM_REG_ARM_TIMER_CVAL		ARM64_SYS_REG(3, 3, 14, 0, 2)
> >  #define KVM_REG_ARM_TIMER_CNT		ARM64_SYS_REG(3, 3, 14, 3, 2)
> > +#define KVM_REG_ARM_TIMER_OFFSET	ARM64_SYS_REG(3, 4, 14, 0, 3)
> >
> 
> Andrew, does this warrant an update to the selftest that checks for
> sysreg visibility?

Yup, until we do, the test will emit a warning with a suggestion to add
the new register to the list. It won't be a test FAIL, because adding new
registers doesn't break migration from older kernels, but we might as well
update the list sooner than later.

> 
> I am also wondering how a VMM such as QEMU is going to deal with the
> above restriction, given the way it blindly saves/restores all the
> registers that KVM exposes, hence hitting that mixed-use that the
> documentation warns about...

You're right and I think it's a problem. While we can special case
registers in QEMU using a cpreg "level" so they won't get saved/restored
all the time, it doesn't help here since we won't be special casing
KVM_REG_ARM_TIMER_OFFSET in older QEMU. We need a way for the VMM to opt
in to using KVM_REG_ARM_TIMER_OFFSET, such as with a CAP we can enable.

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
