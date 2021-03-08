Return-Path: <SRS0=mzoY=IG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BC8FC433DB
	for <kvmarm@archiver.kernel.org>; Mon,  8 Mar 2021 13:31:06 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6B645651CC
	for <kvmarm@archiver.kernel.org>; Mon,  8 Mar 2021 13:31:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6B645651CC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C16624B5C3;
	Mon,  8 Mar 2021 08:31:04 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8QHqJRSlWuI1; Mon,  8 Mar 2021 08:31:02 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4ECEB4B6D3;
	Mon,  8 Mar 2021 08:31:02 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BA5AE4B6C7
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Mar 2021 08:31:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UJHVTn5cNDyH for <kvmarm@lists.cs.columbia.edu>;
 Mon,  8 Mar 2021 08:31:00 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 05A464B5C3
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Mar 2021 08:30:59 -0500 (EST)
Received: by mail.kernel.org (Postfix) with ESMTPSA id EA44964DA3;
 Mon,  8 Mar 2021 13:30:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1615210258;
 bh=pEXNet6N/egXd7wBXv+XZqh8Z0VGXmL8Y0GWpDXYgSU=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=cKyWPlExbizCNVfKpN0ou+bCV20Y4lb3vpBkQS2Vmo3MZrrlJQh/iUsAO0JLf7oom
 Aflt8QGqmFYVUY8Zoiag1rK2aK5nf7xwG+EThpUDEqEjn6MScpRvXvHbMLGDeywvrw
 WWiK5i+VSUsi8FHgLgoDTguaw2tETYur8CDLJvxvop3CT1bE01EW2xjxsh8OQ4qdXj
 GwOH4MfOsamqJ4lC32GoG/POx0M8kDUF82rFM3HPT6hBlwnQ+glrbXy0A7BO3OfZGU
 4cUoYzdmvTf2bToG82yD3eHRe2YFbLqF1oklALbm0QeZuNe7ARB0QrZ1vjAHnhVRDX
 9nL4V2qDnHBug==
Date: Mon, 8 Mar 2021 13:30:53 +0000
From: Will Deacon <will@kernel.org>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: Re: [PATCH] arm64/mm: Fix __enable_mmu() for new TGRAN range values
Message-ID: <20210308133053.GA26128@willie-the-truck>
References: <1614954969-14338-1-git-send-email-anshuman.khandual@arm.com>
 <20210305145111.GA78884@C02TD0UTHF1T.local>
 <1f339512-34ac-9779-e534-bee6698b99aa@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1f339512-34ac-9779-e534-bee6698b99aa@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: linux-efi@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 Marc Zyngier <maz@kernel.org>, linux-arm-kernel@lists.infradead.org
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

On Sun, Mar 07, 2021 at 05:24:21PM +0530, Anshuman Khandual wrote:
> 
> 
> On 3/5/21 8:21 PM, Mark Rutland wrote:
> > On Fri, Mar 05, 2021 at 08:06:09PM +0530, Anshuman Khandual wrote:
> >> From: James Morse <james.morse@arm.com>
> >>
> >> As per ARM ARM DDI 0487G.a, when FEAT_LPA2 is implemented, ID_AA64MMFR0_EL1
> >> might contain a range of values to describe supported translation granules
> >> (4K and 16K pages sizes in particular) instead of just enabled or disabled
> >> values. This changes __enable_mmu() function to handle complete acceptable
> >> range of values (depending on whether the field is signed or unsigned) now
> >> represented with ID_AA64MMFR0_TGRAN_SUPPORTED_[MIN..MAX] pair. While here,
> >> also fix similar situations in EFI stub and KVM as well.
> >>
> >> Cc: Catalin Marinas <catalin.marinas@arm.com>
> >> Cc: Will Deacon <will@kernel.org>
> >> Cc: Marc Zyngier <maz@kernel.org>
> >> Cc: James Morse <james.morse@arm.com>
> >> Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
> >> Cc: Ard Biesheuvel <ardb@kernel.org>
> >> Cc: Mark Rutland <mark.rutland@arm.com>
> >> Cc: linux-arm-kernel@lists.infradead.org
> >> Cc: kvmarm@lists.cs.columbia.edu
> >> Cc: linux-efi@vger.kernel.org
> >> Cc: linux-kernel@vger.kernel.org
> >> Signed-off-by: James Morse <james.morse@arm.com>
> >> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> >> ---
> >>  arch/arm64/include/asm/sysreg.h           | 20 ++++++++++++++------
> >>  arch/arm64/kernel/head.S                  |  6 ++++--
> >>  arch/arm64/kvm/reset.c                    | 23 ++++++++++++-----------
> >>  drivers/firmware/efi/libstub/arm64-stub.c |  2 +-
> >>  4 files changed, 31 insertions(+), 20 deletions(-)
> >>
> >> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> >> index dfd4edb..d4a5fca9 100644
> >> --- a/arch/arm64/include/asm/sysreg.h
> >> +++ b/arch/arm64/include/asm/sysreg.h
> >> @@ -796,6 +796,11 @@
> >>  #define ID_AA64MMFR0_PARANGE_48		0x5
> >>  #define ID_AA64MMFR0_PARANGE_52		0x6
> >>  
> >> +#define ID_AA64MMFR0_TGRAN_2_SUPPORTED_DEFAULT	0x0
> >> +#define ID_AA64MMFR0_TGRAN_2_SUPPORTED_NONE	0x1
> >> +#define ID_AA64MMFR0_TGRAN_2_SUPPORTED_MIN	0x2
> >> +#define ID_AA64MMFR0_TGRAN_2_SUPPORTED_MAX	0x7
> >
> > The TGRAN2 fields doesn't quite follow the usual ID scheme rules, so how
> > do we deteremine the max value? Does the ARM ARM say anything in
> > particular about them, like we do for some of the PMU ID fields?
> 
> Did not find anything in ARM ARM, regarding what scheme TGRAN2 fields
> actually follow. I had arrived at more restrictive 0x7 value, like the
> usual signed fields as the TGRAN4 fields definitely do not follow the
> unsigned ID scheme. Would restricting max value to 0x3 (i.e LPA2) be a
> better option instead ?

I don't think it helps much, as TGRAN64_2 doesn't even define 0x3.

So I think this patch is probably the best we can do, but the Arm ARM could
really do with describing the scheme here.

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
