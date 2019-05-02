Return-Path: <SRS0=zWKl=TC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FC68C43219
	for <kvmarm@archiver.kernel.org>; Thu,  2 May 2019 08:53:33 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2352B2089E
	for <kvmarm@archiver.kernel.org>; Thu,  2 May 2019 08:53:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2352B2089E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 64E134A4F0;
	Thu,  2 May 2019 04:53:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ZL7DWS484EcQ; Thu,  2 May 2019 04:53:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1F5A24A4DB;
	Thu,  2 May 2019 04:53:31 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BD5694A4DB
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 May 2019 04:53:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Dg26VDMBDec8 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 May 2019 04:53:28 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5A07A4A4D0
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 May 2019 04:53:28 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6BBA5374;
 Thu,  2 May 2019 01:53:27 -0700 (PDT)
Received: from e103592.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com
 [10.72.51.249])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D51253F5AF;
 Thu,  2 May 2019 01:53:25 -0700 (PDT)
Date: Thu, 2 May 2019 09:53:23 +0100
From: Dave Martin <Dave.Martin@arm.com>
To: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH] KVM: arm64: fix ptrauth ID register masking logic
Message-ID: <20190502085322.GN3567@e103592.cambridge.arm.com>
References: <20190501161008.31498-1-kristina.martsenko@arm.com>
 <5dbccc2a-655b-00d4-a168-e9ff60a455a7@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5dbccc2a-655b-00d4-a168-e9ff60a455a7@arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Cc: Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will.deacon@arm.com>,
 Kristina Martsenko <kristina.martsenko@arm.com>,
 Amit Kachhap <amit.kachhap@arm.com>, kvmarm@lists.cs.columbia.edu,
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
Message-ID: <20190502085323.JheNWbSCrXaqPyRAZStuneyxwtHQB7fNOJfq3HTTXzg@z>

On Wed, May 01, 2019 at 05:20:49PM +0100, Marc Zyngier wrote:
> On 01/05/2019 17:10, Kristina Martsenko wrote:
> > When a VCPU doesn't have pointer auth, we want to hide all four pointer
> > auth ID register fields from the guest, not just one of them.
> > 
> > Fixes: 384b40caa8af ("KVM: arm/arm64: Context-switch ptrauth registers")
> > Reported-by: Andrew Murray <andrew.murray@arm.com>
> > Fsck-up-by: Marc Zyngier <marc.zyngier@arm.com>
> > Signed-off-by: Kristina Martsenko <kristina.martsenko@arm.com>
> > ---
> >  arch/arm64/kvm/sys_regs.c | 8 ++++----
> >  1 file changed, 4 insertions(+), 4 deletions(-)
> > 
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
> > 
> 
> Applied and pushed to -next. Thanks Andrew for reporting it, and
> Kristina for putting me right!

I was worried this was my mistake... but it looks like my original
suggstion did have the extra ().

Anyway, FWIW,

Acked-by: Dave Martin <Dave.Martin@arm.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
