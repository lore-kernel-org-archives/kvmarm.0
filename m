Return-Path: <SRS0=VrFD=6U=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8F2DC47258
	for <kvmarm@archiver.kernel.org>; Wed,  6 May 2020 08:05:53 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 597A02075A
	for <kvmarm@archiver.kernel.org>; Wed,  6 May 2020 08:05:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="JDNKhr1P"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 597A02075A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D57EE4B287;
	Wed,  6 May 2020 04:05:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Su93fP+-XNko; Wed,  6 May 2020 04:05:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B07B94B283;
	Wed,  6 May 2020 04:05:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9A0364B283
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 May 2020 04:05:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GZPog35ClcA6 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  6 May 2020 04:05:49 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7CC1C4B281
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 May 2020 04:05:49 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 5300720661;
 Wed,  6 May 2020 08:05:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1588752348;
 bh=UjdxhpVscqX8eojhwkhNUe0wu2YW5eO/ax3nOE6DNr4=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=JDNKhr1Phvo7xXG9he3Gj9+ZGn5UNmxa9ERq7/dVBcwVNBfSq167LLMSAdeHkw1ry
 fk1DZbDYo1iI8fp1i3YFFLq2nhDpp1jnlaWBQbBY4kgxdF86Q7ueav7wetKcNq42mX
 AhFiHphOXgYdAR631rYeDrU0Lf7iZVGru3LeekpQ=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jWF3q-009sbR-L1; Wed, 06 May 2020 09:05:46 +0100
Date: Wed, 6 May 2020 09:05:44 +0100
From: Marc Zyngier <maz@kernel.org>
To: Andrew Scull <ascull@google.com>
Subject: Re: [PATCH 06/26] arm64: Add level-hinted TLB invalidation helper
Message-ID: <20200506090544.18620ed4@why>
In-Reply-To: <20200505171631.GC237572@google.com>
References: <20200422120050.3693593-1-maz@kernel.org>
 <20200422120050.3693593-7-maz@kernel.org>
 <20200505171631.GC237572@google.com>
Organization: Approximate
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: ascull@google.com, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, will@kernel.org,
 andre.przywara@arm.com, Dave.Martin@arm.com, gcherian@marvell.com,
 prime.zeng@hisilicon.com, catalin.marinas@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>,
 kvmarm@lists.cs.columbia.edu, George Cherian <gcherian@marvell.com>,
 "Zengtao \(B\)" <prime.zeng@hisilicon.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Dave Martin <Dave.Martin@arm.com>, linux-arm-kernel@lists.infradead.org
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

On Tue, 5 May 2020 18:16:31 +0100
Andrew Scull <ascull@google.com> wrote:

Hi Andrew,

> > +#define __tlbi_level(op, addr, level)					\
> > +	do {								\
> > +		u64 arg = addr;						\
> > +									\
> > +		if (cpus_have_const_cap(ARM64_HAS_ARMv8_4_TTL) &&	\
> > +		    level) {						\
> > +			u64 ttl = level;				\
> > +									\
> > +			switch (PAGE_SIZE) {				\
> > +			case SZ_4K:					\
> > +				ttl |= 1 << 2;				\
> > +				break;					\
> > +			case SZ_16K:					\
> > +				ttl |= 2 << 2;				\
> > +				break;					\
> > +			case SZ_64K:					\
> > +				ttl |= 3 << 2;				\
> > +				break;					\
> > +			}						\
> > +									\
> > +			arg &= ~TLBI_TTL_MASK;				\
> > +			arg |= FIELD_PREP(TLBI_TTL_MASK, ttl);		\  
> 
> Despite the spec saying both tables apply to TLB maintenance
> instructions that do not apply to a range of addresses I think it only
> means the 4-bit version (bug report to Arm, or I'm on the wrong spec).

I'm not quite sure what you mean by the 4-bit version here. Do you mean
the instructions taking a VA or IPA as input address? In this case,
yes, this macro is solely for the use of the invalidation of a given
translation, identified by a VA/IPA and a level (which is an implicit
TLB size for a given translation granule).

And yes, it looks like there is a bad copy-paste bug in the ARM ARM
(Rev F.a).

> This is consistent with Table D5-53 and the macro takes a single address
> argument to make misuse with range based tlbi less likely.
> 
> It relies on the caller to get the level right and getting it wrong
> could be pretty bad as the spec says all bets are off in that case. Is
> it worth adding a check of the level against the address (seems a bit
> involved), or that it is just 2 bits or adding a short doc comment to
> explain it?

I'd like to avoid checking code at that level, to be honest. If you are
writing TLB invalidation code, you'd better know what you are doing.
Happy to document it a bit more thoroughly though, and set the
expectations that if you misuse the level, you're in for a treat.

> (Looks like we get some constants for the levels in a later patch that
> could be referenced with some form of time travel)

I'm happy to bring these definitions forward, maybe in a more generic
form (they are very S2-specific at the moment).

> 
> > +		}							\
> > +									\
> > +		__tlbi(op,  arg);					\  
> 
> cosmetic nit: double space in here

Well spotted.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
