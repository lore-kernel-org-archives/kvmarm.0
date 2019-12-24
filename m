Return-Path: <SRS0=PUN/=2O=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EA51C2D0CF
	for <kvmarm@archiver.kernel.org>; Tue, 24 Dec 2019 15:17:48 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BD9E52077B
	for <kvmarm@archiver.kernel.org>; Tue, 24 Dec 2019 15:17:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BD9E52077B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F29384AF55;
	Tue, 24 Dec 2019 10:17:46 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bKuuoIoy0nAK; Tue, 24 Dec 2019 10:17:45 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 912634AF3E;
	Tue, 24 Dec 2019 10:17:45 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 56CAB4AF3E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Dec 2019 10:17:44 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FkG0Oq3DCZk0 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 24 Dec 2019 10:17:42 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A1CEB4AF0B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Dec 2019 10:17:42 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3037E1FB;
 Tue, 24 Dec 2019 07:17:42 -0800 (PST)
Received: from localhost (unknown [10.37.6.20])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 97CCD3F6CF;
 Tue, 24 Dec 2019 07:17:41 -0800 (PST)
Date: Tue, 24 Dec 2019 15:17:39 +0000
From: Andrew Murray <andrew.murray@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2 08/18] arm64: KVM: add support to save/restore SPE
 profiling buffer controls
Message-ID: <20191224151739.GP42593@e119886-lin.cambridge.arm.com>
References: <20191220143025.33853-1-andrew.murray@arm.com>
 <20191220143025.33853-9-andrew.murray@arm.com>
 <20191221135755.70a6e8df@why>
 <20191224104929.GE42593@e119886-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20191224104929.GE42593@e119886-lin.cambridge.arm.com>
User-Agent: Mutt/1.10.1+81 (426a6c1) (2018-08-26)
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 linux-kernel@vger.kernel.org, Sudeep Holla <sudeep.holla@arm.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
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

On Tue, Dec 24, 2019 at 10:49:30AM +0000, Andrew Murray wrote:
> On Sat, Dec 21, 2019 at 01:57:55PM +0000, Marc Zyngier wrote:
> > On Fri, 20 Dec 2019 14:30:15 +0000
> > Andrew Murray <andrew.murray@arm.com> wrote:
> > 
> > > From: Sudeep Holla <sudeep.holla@arm.com>
> > > 
> > > Currently since we don't support profiling using SPE in the guests,
> > > we just save the PMSCR_EL1, flush the profiling buffers and disable
> > > sampling. However in order to support simultaneous sampling both in
> > 
> > Is the sampling actually simultaneous? I don't believe so (the whole
> > series would be much simpler if it was).
> 
> No the SPE is used by either the guest or host at any one time. I guess
> the term simultaneous was used to refer to illusion given to both guest
> and host that they are able to use it whenever they like. I'll update
> the commit message to drop the magic.
>  
> 
> > 
> > > the host and guests, we need to save and reatore the complete SPE
> > 
> > s/reatore/restore/
> 
> Noted.
> 
> 
> > 
> > > profiling buffer controls' context.
> > > 
> > > Let's add the support for the same and keep it disabled for now.
> > > We can enable it conditionally only if guests are allowed to use
> > > SPE.
> > > 
> > > Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
> > > [ Clear PMBSR bit when saving state to prevent spurious interrupts ]
> > > Signed-off-by: Andrew Murray <andrew.murray@arm.com>
> > > ---
> > >  arch/arm64/kvm/hyp/debug-sr.c | 51 +++++++++++++++++++++++++++++------
> > >  1 file changed, 43 insertions(+), 8 deletions(-)
> > > 
> > > diff --git a/arch/arm64/kvm/hyp/debug-sr.c b/arch/arm64/kvm/hyp/debug-sr.c
> > > index 8a70a493345e..12429b212a3a 100644
> > > --- a/arch/arm64/kvm/hyp/debug-sr.c
> > > +++ b/arch/arm64/kvm/hyp/debug-sr.c
> > > @@ -85,7 +85,8 @@
> > >  	default:	write_debug(ptr[0], reg, 0);			\
> > >  	}
> > >  
> > > -static void __hyp_text __debug_save_spe_nvhe(struct kvm_cpu_context *ctxt)
> > > +static void __hyp_text
> > > +__debug_save_spe_nvhe(struct kvm_cpu_context *ctxt, bool full_ctxt)
> > 
> > nit: don't split lines like this if you can avoid it. You can put the
> > full_ctxt parameter on a separate line instead.
> 
> Yes understood.
> 
> 
> > 
> > >  {
> > >  	u64 reg;
> > >  
> > > @@ -102,22 +103,46 @@ static void __hyp_text __debug_save_spe_nvhe(struct kvm_cpu_context *ctxt)
> > >  	if (reg & BIT(SYS_PMBIDR_EL1_P_SHIFT))
> > >  		return;
> > >  
> > > -	/* No; is the host actually using the thing? */
> > > -	reg = read_sysreg_s(SYS_PMBLIMITR_EL1);
> > > -	if (!(reg & BIT(SYS_PMBLIMITR_EL1_E_SHIFT)))
> > > +	/* Save the control register and disable data generation */
> > > +	ctxt->sys_regs[PMSCR_EL1] = read_sysreg_el1(SYS_PMSCR);
> > > +
> > > +	if (!ctxt->sys_regs[PMSCR_EL1])
> > 
> > Shouldn't you check the enable bits instead of relying on the whole
> > thing being zero?
> 
> Yes that would make more sense (E1SPE and E0SPE).
> 
> I feel that this check makes an assumption about the guest/host SPE
> driver... What happens if the SPE driver writes to some SPE registers
> but doesn't enable PMSCR? If the guest is also using SPE then those
> writes will be lost, when the host returns and the SPE driver enables
> SPE it won't work.
> 
> With a quick look at the SPE driver I'm not sure this will happen, but
> even so it makes me nervous relying on these assumptions. I wonder if
> this risk is present in other devices?

In fact, this may be a good reason to trap the SPE registers - this would
allow you to conditionally save/restore based on a dirty bit. It would
also allow you to re-evaluate the SPE interrupt (for example when the guest
clears the status register) and thus potentially reduce any black hole.

Thanks,

Andrew Murray

> 
> 
> > 
> > >  		return;
> > >  
> > >  	/* Yes; save the control register and disable data generation */
> > > -	ctxt->sys_regs[PMSCR_EL1] = read_sysreg_el1(SYS_PMSCR);
> > 
> > You've already saved the control register...
> 
> I'll remove that.
> 
> 
> > 
> > >  	write_sysreg_el1(0, SYS_PMSCR);
> > >  	isb();
> > >  
> > >  	/* Now drain all buffered data to memory */
> > >  	psb_csync();
> > >  	dsb(nsh);
> > > +
> > > +	if (!full_ctxt)
> > > +		return;
> > > +
> > > +	ctxt->sys_regs[PMBLIMITR_EL1] = read_sysreg_s(SYS_PMBLIMITR_EL1);
> > > +	write_sysreg_s(0, SYS_PMBLIMITR_EL1);
> > > +
> > > +	/*
> > > +	 * As PMBSR is conditionally restored when returning to the host we
> > > +	 * must ensure the service bit is unset here to prevent a spurious
> > > +	 * host SPE interrupt from being raised.
> > > +	 */
> > > +	ctxt->sys_regs[PMBSR_EL1] = read_sysreg_s(SYS_PMBSR_EL1);
> > > +	write_sysreg_s(0, SYS_PMBSR_EL1);
> > > +
> > > +	isb();
> > > +
> > > +	ctxt->sys_regs[PMSICR_EL1] = read_sysreg_s(SYS_PMSICR_EL1);
> > > +	ctxt->sys_regs[PMSIRR_EL1] = read_sysreg_s(SYS_PMSIRR_EL1);
> > > +	ctxt->sys_regs[PMSFCR_EL1] = read_sysreg_s(SYS_PMSFCR_EL1);
> > > +	ctxt->sys_regs[PMSEVFR_EL1] = read_sysreg_s(SYS_PMSEVFR_EL1);
> > > +	ctxt->sys_regs[PMSLATFR_EL1] = read_sysreg_s(SYS_PMSLATFR_EL1);
> > > +	ctxt->sys_regs[PMBPTR_EL1] = read_sysreg_s(SYS_PMBPTR_EL1);
> > >  }
> > >  
> > > -static void __hyp_text __debug_restore_spe_nvhe(struct kvm_cpu_context *ctxt)
> > > +static void __hyp_text
> > > +__debug_restore_spe_nvhe(struct kvm_cpu_context *ctxt, bool full_ctxt)
> > >  {
> > >  	if (!ctxt->sys_regs[PMSCR_EL1])
> > >  		return;
> > > @@ -126,6 +151,16 @@ static void __hyp_text __debug_restore_spe_nvhe(struct kvm_cpu_context *ctxt)
> > >  	isb();
> > >  
> > >  	/* Re-enable data generation */
> > > +	if (full_ctxt) {
> > > +		write_sysreg_s(ctxt->sys_regs[PMBPTR_EL1], SYS_PMBPTR_EL1);
> > > +		write_sysreg_s(ctxt->sys_regs[PMBLIMITR_EL1], SYS_PMBLIMITR_EL1);
> > > +		write_sysreg_s(ctxt->sys_regs[PMSFCR_EL1], SYS_PMSFCR_EL1);
> > > +		write_sysreg_s(ctxt->sys_regs[PMSEVFR_EL1], SYS_PMSEVFR_EL1);
> > > +		write_sysreg_s(ctxt->sys_regs[PMSLATFR_EL1], SYS_PMSLATFR_EL1);
> > > +		write_sysreg_s(ctxt->sys_regs[PMSIRR_EL1], SYS_PMSIRR_EL1);
> > > +		write_sysreg_s(ctxt->sys_regs[PMSICR_EL1], SYS_PMSICR_EL1);
> > > +		write_sysreg_s(ctxt->sys_regs[PMBSR_EL1], SYS_PMBSR_EL1);
> > > +	}
> > >  	write_sysreg_el1(ctxt->sys_regs[PMSCR_EL1], SYS_PMSCR);
> > >  }
> > >  
> > > @@ -198,7 +233,7 @@ void __hyp_text __debug_restore_host_context(struct kvm_vcpu *vcpu)
> > >  	guest_ctxt = &vcpu->arch.ctxt;
> > >  
> > >  	if (!has_vhe())
> > > -		__debug_restore_spe_nvhe(host_ctxt);
> > > +		__debug_restore_spe_nvhe(host_ctxt, false);
> > >  
> > >  	if (!(vcpu->arch.flags & KVM_ARM64_DEBUG_DIRTY))
> > >  		return;
> > > @@ -222,7 +257,7 @@ void __hyp_text __debug_save_host_context(struct kvm_vcpu *vcpu)
> > >  
> > >  	host_ctxt = kern_hyp_va(vcpu->arch.host_cpu_context);
> > >  	if (!has_vhe())
> > > -		__debug_save_spe_nvhe(host_ctxt);
> > > +		__debug_save_spe_nvhe(host_ctxt, false);
> > >  }
> > >  
> > >  void __hyp_text __debug_save_guest_context(struct kvm_vcpu *vcpu)
> > 
> > So all of this is for non-VHE. What happens in the VHE case?
> 
> By the end of the series this ends up in __debug_save_host_context which is
> called for both VHE/nVHE - on the re-spin I'll make it not look so confusing.
> 
> Thanks,
> 
> Andrew Murray
> 
> > 
> > 	M.
> > -- 
> > Jazz is not dead. It just smells funny...
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
