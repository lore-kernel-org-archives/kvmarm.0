Return-Path: <SRS0=yjsw=MF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 928B0C07E95
	for <kvmarm@archiver.kernel.org>; Tue, 13 Jul 2021 16:15:55 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0701461175
	for <kvmarm@archiver.kernel.org>; Tue, 13 Jul 2021 16:15:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0701461175
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=armlinux.org.uk
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 674384A19F;
	Tue, 13 Jul 2021 12:15:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@armlinux.org.uk
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UK4k4-liTiRE; Tue, 13 Jul 2021 12:15:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4482E4A19E;
	Tue, 13 Jul 2021 12:15:52 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B652D4A00B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Jul 2021 12:15:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Ga9TdouyUGgc for <kvmarm@lists.cs.columbia.edu>;
 Tue, 13 Jul 2021 12:15:49 -0400 (EDT)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [78.32.30.218])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 57D8D40799
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Jul 2021 12:15:49 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
 MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=LQoPboS23ZJWmSVy61Mm/NOINFZejZIfzYMHAqlDOS0=; b=w/jsQrSI7bJ1ZrydFotmRErPM
 drc4eD9/xShHE8IkaqogtxmHN5jecAuKJe1hm1GnJxVZI+Khij+VACmFAts2xIJmVbR3YB7dWeQtB
 rAVxHNnrVUqg8xcQbgoZtOWF2WuPgAMssSGfm1kTR6/ZCoOvD1TPh0lXcVW9wQN4saPSvme4wD6c4
 IWhlSFvcCRZabQU6yLCEsX3+oSmROYeyyGEvCiZ6o+Sn1TclIMwaEC7OBz/LvArxRyJq2JjtkKXYG
 6ogFP2ohLPG23VtH/DfY1wn4GMrcPdgCqLuri45n/qazASEiOX9EifgyxP5LWYTsAcCqYMf1+wUo7
 tz0a/f/FQ==;
Received: from shell.armlinux.org.uk
 ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:46060)
 by pandora.armlinux.org.uk with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <linux@armlinux.org.uk>)
 id 1m3L4T-0006Iy-PN; Tue, 13 Jul 2021 17:15:45 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
 (envelope-from <linux@shell.armlinux.org.uk>)
 id 1m3L4S-0000SA-Fi; Tue, 13 Jul 2021 17:15:44 +0100
Date: Tue, 13 Jul 2021 17:15:44 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 1/3] KVM: arm64: Narrow PMU sysreg reset values to
 architectural requirements
Message-ID: <20210713161544.GL22278@shell.armlinux.org.uk>
References: <20210713135900.1473057-1-maz@kernel.org>
 <20210713135900.1473057-2-maz@kernel.org>
 <20210713143949.GJ22278@shell.armlinux.org.uk>
 <87mtqq6w75.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87mtqq6w75.wl-maz@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: kernel-team@android.com, kvm@vger.kernel.org,
 Robin Murphy <robin.murphy@arm.com>, kvmarm@lists.cs.columbia.edu,
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

On Tue, Jul 13, 2021 at 04:59:58PM +0100, Marc Zyngier wrote:
> On Tue, 13 Jul 2021 15:39:49 +0100,
> "Russell King (Oracle)" <linux@armlinux.org.uk> wrote:
> > 
> > On Tue, Jul 13, 2021 at 02:58:58PM +0100, Marc Zyngier wrote:
> > > +static void reset_pmu_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
> > > +{
> > > +	u64 n, mask;
> > > +
> > > +	/* No PMU available, any PMU reg may UNDEF... */
> > > +	if (!kvm_arm_support_pmu_v3())
> > > +		return;
> > > +
> > > +	n = read_sysreg(pmcr_el0) >> ARMV8_PMU_PMCR_N_SHIFT;
> > > +	n &= ARMV8_PMU_PMCR_N_MASK;
> > > +
> > > +	reset_unknown(vcpu, r);
> > > +
> > > +	mask = BIT(ARMV8_PMU_CYCLE_IDX);
> > > +	if (n)
> > > +		mask |= GENMASK(n - 1, 0);
> > > +
> > > +	__vcpu_sys_reg(vcpu, r->reg) &= mask;
> > 
> > Would this read more logically to structure it as:
> > 
> > 	mask = BIT(ARMV8_PMU_CYCLE_IDX);
> > 
> > 	n = read_sysreg(pmcr_el0) >> ARMV8_PMU_PMCR_N_SHIFT;
> > 	n &= ARMV8_PMU_PMCR_N_MASK;
> > 	if (n)
> > 		mask |= GENMASK(n - 1, 0);
> > 
> > 	reset_unknown(vcpu, r);
> > 	__vcpu_sys_reg(vcpu, r->reg) &= mask;
> > 
> > ?
> 
> Yup, that's nicer. Amended locally.

Thanks Marc.

For the whole series:

Acked-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
