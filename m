Return-Path: <SRS0=MGAT=6T=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E076BC47254
	for <kvmarm@archiver.kernel.org>; Tue,  5 May 2020 12:50:02 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 66352206D7
	for <kvmarm@archiver.kernel.org>; Tue,  5 May 2020 12:50:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 66352206D7
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BBFD44B348;
	Tue,  5 May 2020 08:50:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3NHY7ONvcnyq; Tue,  5 May 2020 08:50:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 63EF24B2BB;
	Tue,  5 May 2020 08:50:00 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A562D4B2BB
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 May 2020 08:49:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TndZFVmLSunN for <kvmarm@lists.cs.columbia.edu>;
 Tue,  5 May 2020 08:49:57 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3CC744B2B9
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 May 2020 08:49:57 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CB6AE30E;
 Tue,  5 May 2020 05:49:56 -0700 (PDT)
Received: from C02TD0UTHF1T.local (unknown [10.57.25.241])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D688E3F68F;
 Tue,  5 May 2020 05:49:54 -0700 (PDT)
Date: Tue, 5 May 2020 13:49:51 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Will Deacon <will@kernel.org>
Subject: Re: [PATCH V3 04/16] arm64/cpufeature: Introduce ID_PFR2 CPU register
Message-ID: <20200505124951.GD82823@C02TD0UTHF1T.local>
References: <1588426445-24344-1-git-send-email-anshuman.khandual@arm.com>
 <1588426445-24344-5-git-send-email-anshuman.khandual@arm.com>
 <20200505111241.GF19710@willie-the-truck>
 <20200505111607.GA82823@C02TD0UTHF1T.local>
 <20200505112718.GH19710@willie-the-truck>
 <20200505115054.GC82823@C02TD0UTHF1T.local>
 <20200505121239.GI19710@willie-the-truck>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200505121239.GI19710@willie-the-truck>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>, linux-kernel@vger.kernel.org,
 Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
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

On Tue, May 05, 2020 at 01:12:39PM +0100, Will Deacon wrote:
> On Tue, May 05, 2020 at 12:50:54PM +0100, Mark Rutland wrote:
> > On Tue, May 05, 2020 at 12:27:19PM +0100, Will Deacon wrote:
> > > On Tue, May 05, 2020 at 12:16:07PM +0100, Mark Rutland wrote:
> > > > On Tue, May 05, 2020 at 12:12:41PM +0100, Will Deacon wrote:
> > > > > On Sat, May 02, 2020 at 07:03:53PM +0530, Anshuman Khandual wrote:
> > > > > > diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> > > > > > index e5317a6367b6..c977449e02db 100644
> > > > > > --- a/arch/arm64/include/asm/sysreg.h
> > > > > > +++ b/arch/arm64/include/asm/sysreg.h
> > > > > > @@ -153,6 +153,7 @@
> > > > > >  #define SYS_MVFR0_EL1			sys_reg(3, 0, 0, 3, 0)
> > > > > >  #define SYS_MVFR1_EL1			sys_reg(3, 0, 0, 3, 1)
> > > > > >  #define SYS_MVFR2_EL1			sys_reg(3, 0, 0, 3, 2)
> > > > > > +#define SYS_ID_PFR2_EL1			sys_reg(3, 0, 0, 3, 4)
> > > > > 
> > > > > nit: but please group these defines by name rather than encoding.
> > > > 
> > > > So far we've *always* grouped these by encoding in this file, so can we
> > > > keep things that way for now? Otherwise we're inconsistent with both
> > > > schemes.
> > > 
> > > Hmm, but it's really hard to read sorted that way and we'll end up with
> > > duplicate definitions like we had for some of the field offsets already.
> > 
> > I appreciate that, and don't disagree that the current scheme is not
> > obvious.
> > 
> > I just want to ensure that we don't make things less consistent, and if
> > we're going to change the scheme in order to make that easier, it should
> > be a separate patch. There'll be other changes like MMFR4_EL1, and we
> > should probably add a comment as to what the policy is either way (e.g.
> > if we're just grouping at the top level, or if that should be sorted
> > too).
> 
> Ok, I added a comment below.

Thanks!

Acked-by: Mark Rutland <mark.rutland@arm.com>

Mark.

> 
> Will
> 
> --->8
> 
> commit be7ab6a6cdb0a6d7b10883094c2adf96f5d4e1e8
> Author: Will Deacon <will@kernel.org>
> Date:   Tue May 5 13:08:02 2020 +0100
> 
>     arm64: cpufeature: Group indexed system register definitions by name
>     
>     Some system registers contain an index in the name (e.g. ID_MMFR<n>_EL1)
>     and, while this index often follows the register encoding, newer additions
>     to the architecture are necessarily tacked on the end. Sorting these
>     registers by encoding therefore becomes a bit of a mess.
>     
>     Group the indexed system register definitions by name so that it's easier to
>     read and will hopefully reduce the chance of us accidentally introducing
>     duplicate definitions in the future.
>     
>     Signed-off-by: Will Deacon <will@kernel.org>
> 
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> index 2dd3f4ca9780..194684301df0 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -105,6 +105,10 @@
>  #define SYS_DC_CSW			sys_insn(1, 0, 7, 10, 2)
>  #define SYS_DC_CISW			sys_insn(1, 0, 7, 14, 2)
>  
> +/*
> + * System registers, organised loosely by encoding but grouped together
> + * where the architected name contains an index. e.g. ID_MMFR<n>_EL1.
> + */
>  #define SYS_OSDTRRX_EL1			sys_reg(2, 0, 0, 0, 2)
>  #define SYS_MDCCINT_EL1			sys_reg(2, 0, 0, 2, 0)
>  #define SYS_MDSCR_EL1			sys_reg(2, 0, 0, 2, 2)
> @@ -140,6 +144,7 @@
>  #define SYS_ID_MMFR1_EL1		sys_reg(3, 0, 0, 1, 5)
>  #define SYS_ID_MMFR2_EL1		sys_reg(3, 0, 0, 1, 6)
>  #define SYS_ID_MMFR3_EL1		sys_reg(3, 0, 0, 1, 7)
> +#define SYS_ID_MMFR4_EL1		sys_reg(3, 0, 0, 2, 6)
>  
>  #define SYS_ID_ISAR0_EL1		sys_reg(3, 0, 0, 2, 0)
>  #define SYS_ID_ISAR1_EL1		sys_reg(3, 0, 0, 2, 1)
> @@ -147,7 +152,6 @@
>  #define SYS_ID_ISAR3_EL1		sys_reg(3, 0, 0, 2, 3)
>  #define SYS_ID_ISAR4_EL1		sys_reg(3, 0, 0, 2, 4)
>  #define SYS_ID_ISAR5_EL1		sys_reg(3, 0, 0, 2, 5)
> -#define SYS_ID_MMFR4_EL1		sys_reg(3, 0, 0, 2, 6)
>  #define SYS_ID_ISAR6_EL1		sys_reg(3, 0, 0, 2, 7)
>  
>  #define SYS_MVFR0_EL1			sys_reg(3, 0, 0, 3, 0)
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
