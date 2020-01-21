Return-Path: <SRS0=DlSC=3K=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 812AAC2D0DB
	for <kvmarm@archiver.kernel.org>; Tue, 21 Jan 2020 09:04:39 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F2FB624653
	for <kvmarm@archiver.kernel.org>; Tue, 21 Jan 2020 09:04:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="A0c+ow1H"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F2FB624653
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 712744AFDC;
	Tue, 21 Jan 2020 04:04:38 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id uasDUd9Fhhgv; Tue, 21 Jan 2020 04:04:34 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2B6224AFDF;
	Tue, 21 Jan 2020 04:04:34 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5F2884AFDF
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Jan 2020 04:04:32 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iMliN2SRtxnc for <kvmarm@lists.cs.columbia.edu>;
 Tue, 21 Jan 2020 04:04:27 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3D3DF4AFDC
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Jan 2020 04:04:27 -0500 (EST)
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id D8BCB24125;
 Tue, 21 Jan 2020 09:04:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1579597466;
 bh=0/vSnKkkercvxEdQWKR2hLON8AJtjT2I4490/GyPLJs=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=A0c+ow1H1hlJAxBTCst+Smkxrf4RVkQWSG6IHDMRiuVNKnyoyHK+C0v1+dblp8Qs8
 Myj59KfEUx5bDTXQ+qa+sAJADRBh4oOF2XHGwZH5ljRRrUKSk6wtnvbtVx9tvaxBYl
 lRtyFAf9sg4ouf6R8yUvCZ7GqnknsjBD/SB67U98=
Date: Tue, 21 Jan 2020 09:04:21 +0000
From: Will Deacon <will@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v3 2/3] KVM: arm64: limit PMU version to ARMv8.4
Message-ID: <20200121090420.GA9722@willie-the-truck>
References: <20200102123905.29360-1-andrew.murray@arm.com>
 <20200102123905.29360-3-andrew.murray@arm.com>
 <336acb6b88c2df5e6114e6f8811687e4@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <336acb6b88c2df5e6114e6f8811687e4@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu,
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

On Mon, Jan 20, 2020 at 05:55:17PM +0000, Marc Zyngier wrote:
> On 2020-01-02 12:39, Andrew Murray wrote:
> > ARMv8.5-PMU introduces 64-bit event counters, however KVM doesn't yet
> > support this. Let's trap the Debug Feature Registers in order to limit
> > PMUVer/PerfMon in the Debug Feature Registers to PMUv3 for ARMv8.4.
> > 
> > Signed-off-by: Andrew Murray <andrew.murray@arm.com>
> > Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> > ---
> >  arch/arm64/include/asm/sysreg.h |  4 ++++
> >  arch/arm64/kvm/sys_regs.c       | 36 +++++++++++++++++++++++++++++++--
> >  2 files changed, 38 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/arm64/include/asm/sysreg.h
> > b/arch/arm64/include/asm/sysreg.h
> > index 6e919fafb43d..1b74f275a115 100644
> > --- a/arch/arm64/include/asm/sysreg.h
> > +++ b/arch/arm64/include/asm/sysreg.h
> > @@ -672,6 +672,10 @@
> >  #define ID_AA64DFR0_TRACEVER_SHIFT	4
> >  #define ID_AA64DFR0_DEBUGVER_SHIFT	0
> > 
> > +#define ID_DFR0_PERFMON_SHIFT		24
> > +
> > +#define ID_DFR0_EL1_PMUVER_8_4		5
> > +
> >  #define ID_ISAR5_RDM_SHIFT		24
> >  #define ID_ISAR5_CRC32_SHIFT		16
> >  #define ID_ISAR5_SHA2_SHIFT		12
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index 9f2165937f7d..61b984d934d1 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -668,6 +668,37 @@ static bool
> > pmu_access_event_counter_el0_disabled(struct kvm_vcpu *vcpu)
> >  	return check_pmu_access_disabled(vcpu, ARMV8_PMU_USERENR_ER |
> > ARMV8_PMU_USERENR_EN);
> >  }
> > 
> > +static bool access_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
> > +				   struct sys_reg_params *p,
> > +				   const struct sys_reg_desc *rd)
> > +{
> > +	if (p->is_write)
> > +		return write_to_read_only(vcpu, p, rd);
> > +
> > +	/* Limit guests to PMUv3 for ARMv8.4 */
> > +	p->regval = read_sanitised_ftr_reg(SYS_ID_AA64DFR0_EL1);
> > +	p->regval = cpuid_feature_cap_signed_field_width(p->regval,
> > +						ID_AA64DFR0_PMUVER_SHIFT,
> > +						4, ID_DFR0_EL1_PMUVER_8_4);
> > +
> > +	return p->regval;
> 
> If feels very odd to return the register value in place of a something
> that actually indicates whether we should update the PC or not. I have
> no idea what is happening here in this case.

Crikey, yes, I missed that and it probably explains why the code looks so
odd. Andrew -- is there a missing hunk or something here?

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
