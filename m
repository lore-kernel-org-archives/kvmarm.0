Return-Path: <SRS0=bv25=S2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.5 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F413C282CE
	for <kvmarm@archiver.kernel.org>; Wed, 24 Apr 2019 13:40:32 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id EAA9221773
	for <kvmarm@archiver.kernel.org>; Wed, 24 Apr 2019 13:40:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EAA9221773
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 868B44A46F;
	Wed, 24 Apr 2019 09:40:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id FQ16jdM7lbNW; Wed, 24 Apr 2019 09:40:30 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4D6574A48D;
	Wed, 24 Apr 2019 09:40:30 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 722B84A46F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Apr 2019 09:40:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vzcadt4tEHXh for <kvmarm@lists.cs.columbia.edu>;
 Wed, 24 Apr 2019 09:40:28 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0F84E4A3B4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Apr 2019 09:40:28 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8581E80D;
 Wed, 24 Apr 2019 06:40:27 -0700 (PDT)
Received: from e103592.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com
 [10.72.51.249])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CB1D03F238;
 Wed, 24 Apr 2019 06:40:25 -0700 (PDT)
Date: Wed, 24 Apr 2019 14:40:23 +0100
From: Dave Martin <Dave.Martin@arm.com>
To: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v10 2/5] KVM: arm/arm64: context-switch ptrauth registers
Message-ID: <20190424134023.GV3567@e103592.cambridge.arm.com>
References: <1555994558-26349-1-git-send-email-amit.kachhap@arm.com>
 <1555994558-26349-3-git-send-email-amit.kachhap@arm.com>
 <8636m9awmu.wl-marc.zyngier@arm.com>
 <c961a9d1-8cc8-6e40-de1d-527f7feb0f41@arm.com>
 <20190423154430.GM3567@e103592.cambridge.arm.com>
 <09bd4e79-c507-1f00-01c5-38afb2a62077@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <09bd4e79-c507-1f00-01c5-38afb2a62077@arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Cc: Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
 Kristina Martsenko <kristina.martsenko@arm.com>,
 Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>,
 Amit Daniel Kachhap <amit.kachhap@arm.com>, kvmarm@lists.cs.columbia.edu,
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
Message-ID: <20190424134023.SQTXP7g474TRvdkoyKhELV_YwytT3Gy8q6ma7xkJhx4@z>

On Wed, Apr 24, 2019 at 11:29:37AM +0100, Marc Zyngier wrote:
> On 23/04/2019 16:44, Dave Martin wrote:
> > On Tue, Apr 23, 2019 at 03:54:32PM +0530, Amit Daniel Kachhap wrote:
> >> Hi Mark,
> >>
> >> On 4/23/19 3:09 PM, Marc Zyngier wrote:
> >>> On Tue, 23 Apr 2019 05:42:35 +0100,
> >>> Amit Daniel Kachhap <amit.kachhap@arm.com> wrote:

[...]

> >>>> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> >>>> index 7e34b9e..3cfe2eb 100644
> >>>> --- a/arch/arm64/Kconfig
> >>>> +++ b/arch/arm64/Kconfig
> >>>> @@ -1301,8 +1301,9 @@ config ARM64_PTR_AUTH
> >>>>  	  context-switched along with the process.
> >>>>  	  The feature is detected at runtime. If the feature is not present in
> >>>> -	  hardware it will not be advertised to userspace nor will it be
> >>>> -	  enabled.
> >>>> +	  hardware it will not be advertised to userspace/KVM guest nor will it
> >>>> +	  be enabled. However, KVM guest also require VHE mode and hence
> >>>> +	  CONFIG_ARM64_VHE=y option to use this feature.
> >>>
> >>> SVE seems to have the exact same requirements, and has
> >>>
> >>> 	depends on !KVM || ARM64_VHE
> >>>
> >>> Why don't we have that for PTR_AUTH too?
> >> This point came up earlier also and it was suggested by  Dave[1] to leave
> >> userspace ptrauth for non-vhe mode as that would bring regression now.
> >> [1]:https://lkml.org/lkml/2019/3/27/583
> > 
> > I see Marc applied this change in
> > https://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git/commit/?h=queue&id=e19b245fa4c61558536bd34f80845f0c41eab65f0
> 
> That's only for me not to forget anything, and it hasn't been folded
> into the original patch yet.

Ah, right, misunderstood.

> > The risk here is that someone has a custom config from an old kernel
> > that explicitly turns CONFIG_ARM64_VHE off, and that try to use that
> > config with this patch.
> > 
> > I'm not sure how much we care about that.
> > 
> > Otherwise, blocking this config so that people don't accidentally rely
> > on it seems sensible.
> 
> What I'm trying to do is to reduce the amount of valid kernel
> configurations that we need to validate independently.
> 
> At this stage, I'm tempted to just restrict it as described above, and
> maybe relax it if someone shouts at me.

Sounds good to me.

Cheers
---Dave
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
