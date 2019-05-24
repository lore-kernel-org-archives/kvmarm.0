Return-Path: <SRS0=F0YX=TY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_MUTT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EA74C072B5
	for <kvmarm@archiver.kernel.org>; Fri, 24 May 2019 14:12:31 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DC333206A3
	for <kvmarm@archiver.kernel.org>; Fri, 24 May 2019 14:12:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DC333206A3
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5F6414A477;
	Fri, 24 May 2019 10:12:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id e12BTCdZMcqg; Fri, 24 May 2019 10:12:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 21E6D4A479;
	Fri, 24 May 2019 10:12:29 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 08D784A420
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 May 2019 10:12:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5aP27t+eJdNG for <kvmarm@lists.cs.columbia.edu>;
 Fri, 24 May 2019 10:12:26 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7D7A34A369
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 May 2019 10:12:26 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E549BA78;
 Fri, 24 May 2019 07:12:25 -0700 (PDT)
Received: from e107155-lin (e107155-lin.cambridge.arm.com [10.1.196.42])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CFD8C3F575;
 Fri, 24 May 2019 07:12:23 -0700 (PDT)
Date: Fri, 24 May 2019 15:12:18 +0100
From: Sudeep Holla <sudeep.holla@arm.com>
To: Julien Thierry <julien.thierry@arm.com>
Subject: Re: [PATCH v2 05/15] arm64: KVM: add access handler for SPE system
 registers
Message-ID: <20190524141218.GA29406@e107155-lin>
References: <20190523103502.25925-1-sudeep.holla@arm.com>
 <20190523103502.25925-6-sudeep.holla@arm.com>
 <c45323a8-92e4-e406-381b-2084e222a870@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <c45323a8-92e4-e406-381b-2084e222a870@arm.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>,
 linux-kernel@vger.kernel.org, Sudeep Holla <sudeep.holla@arm.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On Fri, May 24, 2019 at 12:36:24PM +0100, Julien Thierry wrote:
> Hi Sudeep,
> 
> On 23/05/2019 11:34, Sudeep Holla wrote:
> > SPE Profiling Buffer owning EL is configurable and when MDCR_EL2.E2PB
> > is configured to provide buffer ownership to EL1, the control registers
> > are trapped.
> > 
> > Add access handlers for the Statistical Profiling Extension(SPE)
> > Profiling Buffer controls registers. This is need to support profiling
> > using SPE in the guests.
> > 
> > Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
> > ---
> >  arch/arm64/include/asm/kvm_host.h | 13 ++++++++++++
> >  arch/arm64/kvm/sys_regs.c         | 35 +++++++++++++++++++++++++++++++
> >  include/kvm/arm_spe.h             | 15 +++++++++++++
> >  3 files changed, 63 insertions(+)
> > 
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index 611a4884fb6c..559aa6931291 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -147,6 +147,19 @@ enum vcpu_sysreg {
> >  	MDCCINT_EL1,	/* Monitor Debug Comms Channel Interrupt Enable Reg */
> >  	DISR_EL1,	/* Deferred Interrupt Status Register */
> >  
> > +	/* Statistical Profiling Extension Registers */
> > +
> > +	PMSCR_EL1,
> > +	PMSICR_EL1,
> > +	PMSIRR_EL1,
> > +	PMSFCR_EL1,
> > +	PMSEVFR_EL1,
> > +	PMSLATFR_EL1,
> > +	PMSIDR_EL1,
> > +	PMBLIMITR_EL1,
> > +	PMBPTR_EL1,
> > +	PMBSR_EL1,
> > +
> >  	/* Performance Monitors Registers */
> >  	PMCR_EL0,	/* Control Register */
> >  	PMSELR_EL0,	/* Event Counter Selection Register */
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index 857b226bcdde..dbf5056828d3 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -646,6 +646,30 @@ static void reset_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
> >  	__vcpu_sys_reg(vcpu, PMCR_EL0) = val;
> >  }
> >  
> > +static bool access_pmsb_val(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
> > +			    const struct sys_reg_desc *r)
> > +{
> > +	if (p->is_write)
> > +		vcpu_write_sys_reg(vcpu, p->regval, r->reg);
> > +	else
> > +		p->regval = vcpu_read_sys_reg(vcpu, r->reg);
> > +
> > +	return true;
> > +}
> > +
> > +static void reset_pmsb_val(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
> > +{
> > +	if (!kvm_arm_support_spe_v1()) {
> > +		__vcpu_sys_reg(vcpu, r->reg) = 0;
> > +		return;
> > +	}
> > +
> > +	if (r->reg == PMSIDR_EL1)
> 
> If only PMSIDR_EL1 has a non-zero reset value, it feels a bit weird to
> share the reset function for all these registers.
>

Ah, right. Initially I did have couple of other registers which were not
needed. So I removed them without observing that I could have just used
reset_val(0) for all except PMSIDR_EL1.

> I would suggest only having a reset_pmsidr() function, and just use
> reset_val() with sys_reg_desc->val set to 0 for all the others.
>

Thanks for pointing this out.

--
Regards,
Sudeep
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
