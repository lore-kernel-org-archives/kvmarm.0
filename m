Return-Path: <SRS0=MGAT=6T=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41403C47254
	for <kvmarm@archiver.kernel.org>; Tue,  5 May 2020 11:51:04 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B878D206A4
	for <kvmarm@archiver.kernel.org>; Tue,  5 May 2020 11:51:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B878D206A4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3CEB84B2E6;
	Tue,  5 May 2020 07:51:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dj7eOSW-qo8b; Tue,  5 May 2020 07:51:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 00DE64B2F7;
	Tue,  5 May 2020 07:51:02 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EF6744B2E6
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 May 2020 07:51:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EZ44GXzXUwiJ for <kvmarm@lists.cs.columbia.edu>;
 Tue,  5 May 2020 07:50:59 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 963E54B2E5
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 May 2020 07:50:59 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4380230E;
 Tue,  5 May 2020 04:50:59 -0700 (PDT)
Received: from C02TD0UTHF1T.local (unknown [10.57.25.241])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3D3673F68F;
 Tue,  5 May 2020 04:50:57 -0700 (PDT)
Date: Tue, 5 May 2020 12:50:54 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Will Deacon <will@kernel.org>
Subject: Re: [PATCH V3 04/16] arm64/cpufeature: Introduce ID_PFR2 CPU register
Message-ID: <20200505115054.GC82823@C02TD0UTHF1T.local>
References: <1588426445-24344-1-git-send-email-anshuman.khandual@arm.com>
 <1588426445-24344-5-git-send-email-anshuman.khandual@arm.com>
 <20200505111241.GF19710@willie-the-truck>
 <20200505111607.GA82823@C02TD0UTHF1T.local>
 <20200505112718.GH19710@willie-the-truck>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200505112718.GH19710@willie-the-truck>
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

On Tue, May 05, 2020 at 12:27:19PM +0100, Will Deacon wrote:
> On Tue, May 05, 2020 at 12:16:07PM +0100, Mark Rutland wrote:
> > On Tue, May 05, 2020 at 12:12:41PM +0100, Will Deacon wrote:
> > > On Sat, May 02, 2020 at 07:03:53PM +0530, Anshuman Khandual wrote:
> > > > This adds basic building blocks required for ID_PFR2 CPU register which
> > > > provides information about the AArch32 programmers model which must be
> > > > interpreted along with ID_PFR0 and ID_PFR1 CPU registers. This is added
> > > > per ARM DDI 0487F.a specification.
> > > > 
> > > > Cc: Catalin Marinas <catalin.marinas@arm.com>
> > > > Cc: Will Deacon <will@kernel.org>
> > > > Cc: Marc Zyngier <maz@kernel.org>
> > > > Cc: Mark Rutland <mark.rutland@arm.com>
> > > > Cc: James Morse <james.morse@arm.com>
> > > > Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
> > > > Cc: kvmarm@lists.cs.columbia.edu
> > > > Cc: linux-arm-kernel@lists.infradead.org
> > > > Cc: linux-kernel@vger.kernel.org
> > > > 
> > > > Suggested-by: Mark Rutland <mark.rutland@arm.com>
> > > > Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> > > > Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> > > > ---
> > > >  arch/arm64/include/asm/cpu.h    |  1 +
> > > >  arch/arm64/include/asm/sysreg.h |  4 ++++
> > > >  arch/arm64/kernel/cpufeature.c  | 11 +++++++++++
> > > >  arch/arm64/kernel/cpuinfo.c     |  1 +
> > > >  arch/arm64/kvm/sys_regs.c       |  2 +-
> > > >  5 files changed, 18 insertions(+), 1 deletion(-)
> > > > 
> > > > diff --git a/arch/arm64/include/asm/cpu.h b/arch/arm64/include/asm/cpu.h
> > > > index b4a40535a3d8..464e828a994d 100644
> > > > --- a/arch/arm64/include/asm/cpu.h
> > > > +++ b/arch/arm64/include/asm/cpu.h
> > > > @@ -46,6 +46,7 @@ struct cpuinfo_arm64 {
> > > >  	u32		reg_id_mmfr3;
> > > >  	u32		reg_id_pfr0;
> > > >  	u32		reg_id_pfr1;
> > > > +	u32		reg_id_pfr2;
> > > >  
> > > >  	u32		reg_mvfr0;
> > > >  	u32		reg_mvfr1;
> > > > diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> > > > index e5317a6367b6..c977449e02db 100644
> > > > --- a/arch/arm64/include/asm/sysreg.h
> > > > +++ b/arch/arm64/include/asm/sysreg.h
> > > > @@ -153,6 +153,7 @@
> > > >  #define SYS_MVFR0_EL1			sys_reg(3, 0, 0, 3, 0)
> > > >  #define SYS_MVFR1_EL1			sys_reg(3, 0, 0, 3, 1)
> > > >  #define SYS_MVFR2_EL1			sys_reg(3, 0, 0, 3, 2)
> > > > +#define SYS_ID_PFR2_EL1			sys_reg(3, 0, 0, 3, 4)
> > > 
> > > nit: but please group these defines by name rather than encoding.
> > 
> > So far we've *always* grouped these by encoding in this file, so can we
> > keep things that way for now? Otherwise we're inconsistent with both
> > schemes.
> 
> Hmm, but it's really hard to read sorted that way and we'll end up with
> duplicate definitions like we had for some of the field offsets already.

I appreciate that, and don't disagree that the current scheme is not
obvious.

I just want to ensure that we don't make things less consistent, and if
we're going to change the scheme in order to make that easier, it should
be a separate patch. There'll be other changes like MMFR4_EL1, and we
should probably add a comment as to what the policy is either way (e.g.
if we're just grouping at the top level, or if that should be sorted
too).

Thanks,
Mark.

> The only ID register that seems to be out of place atm is MMFR4, which I
> can move (see below)
> 
> Will
> 
> --->8
> 
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> index 2dd3f4ca9780..137201ea383b 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -140,6 +140,7 @@
>  #define SYS_ID_MMFR1_EL1		sys_reg(3, 0, 0, 1, 5)
>  #define SYS_ID_MMFR2_EL1		sys_reg(3, 0, 0, 1, 6)
>  #define SYS_ID_MMFR3_EL1		sys_reg(3, 0, 0, 1, 7)
> +#define SYS_ID_MMFR4_EL1		sys_reg(3, 0, 0, 2, 6)
>  
>  #define SYS_ID_ISAR0_EL1		sys_reg(3, 0, 0, 2, 0)
>  #define SYS_ID_ISAR1_EL1		sys_reg(3, 0, 0, 2, 1)
> @@ -147,7 +148,6 @@
>  #define SYS_ID_ISAR3_EL1		sys_reg(3, 0, 0, 2, 3)
>  #define SYS_ID_ISAR4_EL1		sys_reg(3, 0, 0, 2, 4)
>  #define SYS_ID_ISAR5_EL1		sys_reg(3, 0, 0, 2, 5)
> -#define SYS_ID_MMFR4_EL1		sys_reg(3, 0, 0, 2, 6)
>  #define SYS_ID_ISAR6_EL1		sys_reg(3, 0, 0, 2, 7)
>  
>  #define SYS_MVFR0_EL1			sys_reg(3, 0, 0, 3, 0)
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
