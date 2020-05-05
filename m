Return-Path: <SRS0=MGAT=6T=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFB93C47258
	for <kvmarm@archiver.kernel.org>; Tue,  5 May 2020 11:27:28 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 82083206B9
	for <kvmarm@archiver.kernel.org>; Tue,  5 May 2020 11:27:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="ry4CXumT"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 82083206B9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2B4D04B285;
	Tue,  5 May 2020 07:27:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id P0x6S6xPtstc; Tue,  5 May 2020 07:27:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C69514B2CF;
	Tue,  5 May 2020 07:27:26 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1C5CD4B2A6
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 May 2020 07:27:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id c6T4-WdSNWic for <kvmarm@lists.cs.columbia.edu>;
 Tue,  5 May 2020 07:27:25 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DA4994B285
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 May 2020 07:27:24 -0400 (EDT)
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 5A50C206B9;
 Tue,  5 May 2020 11:27:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1588678043;
 bh=2qyj23dngg47wERUJsWyKoEE8tvAolSujJUARVwGSHg=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=ry4CXumTr926r/3eV5UJeAhNwO1TOsjR0/iUKFfDQs0pnRlplC1QQgY4b8yHoVDeE
 ZWc7fsttR0CsX+C6KAHnnDKepfun1WdhSXv+DbkYPXKMbwagSOvMICauAM/k6EaVpl
 TOTH3JYKfwu7YgDF/Xai67unQr9go1BONb32bfik=
Date: Tue, 5 May 2020 12:27:19 +0100
From: Will Deacon <will@kernel.org>
To: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH V3 04/16] arm64/cpufeature: Introduce ID_PFR2 CPU register
Message-ID: <20200505112718.GH19710@willie-the-truck>
References: <1588426445-24344-1-git-send-email-anshuman.khandual@arm.com>
 <1588426445-24344-5-git-send-email-anshuman.khandual@arm.com>
 <20200505111241.GF19710@willie-the-truck>
 <20200505111607.GA82823@C02TD0UTHF1T.local>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200505111607.GA82823@C02TD0UTHF1T.local>
User-Agent: Mutt/1.10.1 (2018-07-13)
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

On Tue, May 05, 2020 at 12:16:07PM +0100, Mark Rutland wrote:
> On Tue, May 05, 2020 at 12:12:41PM +0100, Will Deacon wrote:
> > On Sat, May 02, 2020 at 07:03:53PM +0530, Anshuman Khandual wrote:
> > > This adds basic building blocks required for ID_PFR2 CPU register which
> > > provides information about the AArch32 programmers model which must be
> > > interpreted along with ID_PFR0 and ID_PFR1 CPU registers. This is added
> > > per ARM DDI 0487F.a specification.
> > > 
> > > Cc: Catalin Marinas <catalin.marinas@arm.com>
> > > Cc: Will Deacon <will@kernel.org>
> > > Cc: Marc Zyngier <maz@kernel.org>
> > > Cc: Mark Rutland <mark.rutland@arm.com>
> > > Cc: James Morse <james.morse@arm.com>
> > > Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
> > > Cc: kvmarm@lists.cs.columbia.edu
> > > Cc: linux-arm-kernel@lists.infradead.org
> > > Cc: linux-kernel@vger.kernel.org
> > > 
> > > Suggested-by: Mark Rutland <mark.rutland@arm.com>
> > > Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> > > Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> > > ---
> > >  arch/arm64/include/asm/cpu.h    |  1 +
> > >  arch/arm64/include/asm/sysreg.h |  4 ++++
> > >  arch/arm64/kernel/cpufeature.c  | 11 +++++++++++
> > >  arch/arm64/kernel/cpuinfo.c     |  1 +
> > >  arch/arm64/kvm/sys_regs.c       |  2 +-
> > >  5 files changed, 18 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/arch/arm64/include/asm/cpu.h b/arch/arm64/include/asm/cpu.h
> > > index b4a40535a3d8..464e828a994d 100644
> > > --- a/arch/arm64/include/asm/cpu.h
> > > +++ b/arch/arm64/include/asm/cpu.h
> > > @@ -46,6 +46,7 @@ struct cpuinfo_arm64 {
> > >  	u32		reg_id_mmfr3;
> > >  	u32		reg_id_pfr0;
> > >  	u32		reg_id_pfr1;
> > > +	u32		reg_id_pfr2;
> > >  
> > >  	u32		reg_mvfr0;
> > >  	u32		reg_mvfr1;
> > > diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> > > index e5317a6367b6..c977449e02db 100644
> > > --- a/arch/arm64/include/asm/sysreg.h
> > > +++ b/arch/arm64/include/asm/sysreg.h
> > > @@ -153,6 +153,7 @@
> > >  #define SYS_MVFR0_EL1			sys_reg(3, 0, 0, 3, 0)
> > >  #define SYS_MVFR1_EL1			sys_reg(3, 0, 0, 3, 1)
> > >  #define SYS_MVFR2_EL1			sys_reg(3, 0, 0, 3, 2)
> > > +#define SYS_ID_PFR2_EL1			sys_reg(3, 0, 0, 3, 4)
> > 
> > nit: but please group these defines by name rather than encoding.
> 
> So far we've *always* grouped these by encoding in this file, so can we
> keep things that way for now? Otherwise we're inconsistent with both
> schemes.

Hmm, but it's really hard to read sorted that way and we'll end up with
duplicate definitions like we had for some of the field offsets already.
The only ID register that seems to be out of place atm is MMFR4, which I
can move (see below)

Will

--->8

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 2dd3f4ca9780..137201ea383b 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -140,6 +140,7 @@
 #define SYS_ID_MMFR1_EL1		sys_reg(3, 0, 0, 1, 5)
 #define SYS_ID_MMFR2_EL1		sys_reg(3, 0, 0, 1, 6)
 #define SYS_ID_MMFR3_EL1		sys_reg(3, 0, 0, 1, 7)
+#define SYS_ID_MMFR4_EL1		sys_reg(3, 0, 0, 2, 6)
 
 #define SYS_ID_ISAR0_EL1		sys_reg(3, 0, 0, 2, 0)
 #define SYS_ID_ISAR1_EL1		sys_reg(3, 0, 0, 2, 1)
@@ -147,7 +148,6 @@
 #define SYS_ID_ISAR3_EL1		sys_reg(3, 0, 0, 2, 3)
 #define SYS_ID_ISAR4_EL1		sys_reg(3, 0, 0, 2, 4)
 #define SYS_ID_ISAR5_EL1		sys_reg(3, 0, 0, 2, 5)
-#define SYS_ID_MMFR4_EL1		sys_reg(3, 0, 0, 2, 6)
 #define SYS_ID_ISAR6_EL1		sys_reg(3, 0, 0, 2, 7)
 
 #define SYS_MVFR0_EL1			sys_reg(3, 0, 0, 3, 0)
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
