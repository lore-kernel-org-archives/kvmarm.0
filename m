Return-Path: <SRS0=Vsle=TB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6584C43219
	for <kvmarm@archiver.kernel.org>; Wed,  1 May 2019 16:20:14 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 26E0821743
	for <kvmarm@archiver.kernel.org>; Wed,  1 May 2019 16:20:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 26E0821743
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9DF5E4A4FE;
	Wed,  1 May 2019 12:20:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2KdA3ypPCoiW; Wed,  1 May 2019 12:20:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4D9854A4F3;
	Wed,  1 May 2019 12:20:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 01A904A4E6
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 May 2019 12:20:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5eOZHcm93x0L for <kvmarm@lists.cs.columbia.edu>;
 Wed,  1 May 2019 12:20:10 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ACB154A456
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 May 2019 12:20:10 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 245B3A78;
 Wed,  1 May 2019 09:20:10 -0700 (PDT)
Received: from localhost (unknown [10.37.6.20])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7860B3F719;
 Wed,  1 May 2019 09:20:09 -0700 (PDT)
Date: Wed, 1 May 2019 17:20:07 +0100
From: Andrew Murray <andrew.murray@arm.com>
To: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH] KVM: arm64: fix ptrauth ID register masking logic
Message-ID: <20190501162007.GB33049@e119886-lin.cambridge.arm.com>
References: <20190501161008.31498-1-kristina.martsenko@arm.com>
 <20190501161657.GD28109@fuggles.cambridge.arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20190501161657.GD28109@fuggles.cambridge.arm.com>
User-Agent: Mutt/1.10.1+81 (426a6c1) (2018-08-26)
Cc: Marc Zyngier <marc.zyngier@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Kristina Martsenko <kristina.martsenko@arm.com>, kvmarm@lists.cs.columbia.edu,
 Amit Kachhap <amit.kachhap@arm.com>, Dave P Martin <dave.martin@arm.com>,
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
Message-ID: <20190501162007.n-MpWuVzfHTzGEkXJZhER30Zllsc2WlLEWcYyINKaGQ@z>

On Wed, May 01, 2019 at 05:16:57PM +0100, Will Deacon wrote:
> On Wed, May 01, 2019 at 05:10:08PM +0100, Kristina Martsenko wrote:
> > When a VCPU doesn't have pointer auth, we want to hide all four pointer
> > auth ID register fields from the guest, not just one of them.
> > 
> > Fixes: 384b40caa8af ("KVM: arm/arm64: Context-switch ptrauth registers")
> > Reported-by: Andrew Murray <andrew.murray@arm.com>
> > Fsck-up-by: Marc Zyngier <marc.zyngier@arm.com>
> 
> Past tense is "fscked" ;)
> 
> With that:
> 
> Acked-by: Will Deacon <will.deacon@arm.com>
> 
> Will

This fixes the issue for me.

Tested-by: Andrew Murray <andrew.murray@arm.com>

Thanks,

Andrew Murray

> 
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index 9d02643bc601..857b226bcdde 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -1088,10 +1088,10 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu,
> >  	if (id == SYS_ID_AA64PFR0_EL1 && !vcpu_has_sve(vcpu)) {
> >  		val &= ~(0xfUL << ID_AA64PFR0_SVE_SHIFT);
> >  	} else if (id == SYS_ID_AA64ISAR1_EL1 && !vcpu_has_ptrauth(vcpu)) {
> > -		val &= ~(0xfUL << ID_AA64ISAR1_APA_SHIFT) |
> > -			(0xfUL << ID_AA64ISAR1_API_SHIFT) |
> > -			(0xfUL << ID_AA64ISAR1_GPA_SHIFT) |
> > -			(0xfUL << ID_AA64ISAR1_GPI_SHIFT);
> > +		val &= ~((0xfUL << ID_AA64ISAR1_APA_SHIFT) |
> > +			 (0xfUL << ID_AA64ISAR1_API_SHIFT) |
> > +			 (0xfUL << ID_AA64ISAR1_GPA_SHIFT) |
> > +			 (0xfUL << ID_AA64ISAR1_GPI_SHIFT));
> >  	}
> >  
> >  	return val;
> > -- 
> > 2.11.0
> > 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
