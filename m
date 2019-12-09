Return-Path: <SRS0=BIup=Z7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA18AC43603
	for <kvmarm@archiver.kernel.org>; Mon,  9 Dec 2019 10:32:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2E3C02077B
	for <kvmarm@archiver.kernel.org>; Mon,  9 Dec 2019 10:32:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2E3C02077B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8C0744AEEA;
	Mon,  9 Dec 2019 05:32:51 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id MOrg08o8pyL7; Mon,  9 Dec 2019 05:32:50 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6C86C4AEE6;
	Mon,  9 Dec 2019 05:32:50 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5B87E4AEBF
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Dec 2019 05:32:49 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JZL9XLSdW2H0 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Dec 2019 05:32:48 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0B7D54AEBE
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Dec 2019 05:32:48 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 925861FB;
 Mon,  9 Dec 2019 02:32:47 -0800 (PST)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com
 [10.121.207.14])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9160F3F6CF;
 Mon,  9 Dec 2019 02:32:46 -0800 (PST)
Date: Mon, 9 Dec 2019 10:32:40 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 2/2] kvm/arm64: don't log IMP DEF sysreg traps
Message-ID: <20191209103240.GA40574@lakrids.cambridge.arm.com>
References: <20191205180652.18671-1-mark.rutland@arm.com>
 <20191205180652.18671-3-mark.rutland@arm.com>
 <86h82dz1pf.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <86h82dz1pf.wl-maz@kernel.org>
User-Agent: Mutt/1.11.1+11 (2f07cb52) (2018-12-01)
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
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

On Fri, Dec 06, 2019 at 07:35:56PM +0000, Marc Zyngier wrote:
> On Thu, 05 Dec 2019 18:06:52 +0000,
> Mark Rutland <mark.rutland@arm.com> wrote:
> > 
> > We don't intend to support IMPLEMENATION DEFINED system registers, but
> > have to trap them (and emulate them as UNDEFINED). These traps aren't
> > interesting to the system administrator or to the KVM developers, so
> > let's not bother logging when we do so.
> > 
> > Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> > Cc: Alexandru Elisei <alexandru.elisei@arm.com>
> > Cc: James Morse <james.morse@arm.com>
> > Cc: Julien Thierry <julien.thierry.kdev@gmail.com>
> > Cc: Marc Zyngier <maz@kernel.org>
> > Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
> > Cc: kvmarm@lists.cs.columbia.edu
> > ---
> >  arch/arm64/kvm/sys_regs.c | 8 ++++++++
> >  1 file changed, 8 insertions(+)
> > 
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index d128abd38656..61f019104841 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -2233,6 +2233,12 @@ int kvm_handle_cp14_32(struct kvm_vcpu *vcpu, struct kvm_run *run)
> >  				NULL, 0);
> >  }
> >  
> > +static bool is_imp_def_sys_reg(struct sys_reg_params *params)
> > +{
> > +	// See ARM DDI 0487E.a, section D12.3.2
> > +	return params->Op0 == 3 && (params->CRn & 0b1011) == 0b1011;
> > +}
> > +
> >  static int emulate_sys_reg(struct kvm_vcpu *vcpu,
> >  			   struct sys_reg_params *params)
> >  {
> > @@ -2248,6 +2254,8 @@ static int emulate_sys_reg(struct kvm_vcpu *vcpu,
> >  
> >  	if (likely(r)) {
> >  		perform_access(vcpu, params, r);
> > +	} else if (is_imp_def_sysreg(params)) {
> 
> Meh. Doesn't compile... :-(
> Fixing it locally.

Whoops, sorry about that. I "fixed" this at the last moment to match
emulate_sys_reg(), but evidently failed to rebuild. I had tested the
patch before the rename on my machine, at least.

Mark.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
