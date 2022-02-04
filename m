Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74409C433EF
	for <kvmarm@archiver.kernel.org>; Fri,  4 Feb 2022 16:01:16 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CACFD40FAA;
	Fri,  4 Feb 2022 11:01:15 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id JGb7cxtbtzx6; Fri,  4 Feb 2022 11:01:14 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 64ECD40FD3;
	Fri,  4 Feb 2022 11:01:14 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B299440AFA
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Feb 2022 11:01:13 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 23619mYeP0je for <kvmarm@lists.cs.columbia.edu>;
 Fri,  4 Feb 2022 11:01:08 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1BCD540C2B
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Feb 2022 11:01:08 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7C8511396;
 Fri,  4 Feb 2022 08:01:07 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 54B503F718;
 Fri,  4 Feb 2022 08:01:04 -0800 (PST)
Date: Fri, 4 Feb 2022 16:01:13 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v6 22/64] KVM: arm64: nv: Respect virtual HCR_EL2.TWX
 setting
Message-ID: <Yf1Nq1XFJqayJCSt@monolith.localdoman>
References: <20220128121912.509006-1-maz@kernel.org>
 <20220128121912.509006-23-maz@kernel.org>
 <Yf1I3w/xPjwM9IiO@monolith.localdoman>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <Yf1I3w/xPjwM9IiO@monolith.localdoman>
Cc: kernel-team@android.com, kvm@vger.kernel.org,
 Andre Przywara <andre.przywara@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>,
 Chase Conklin <chase.conklin@arm.com>, kvmarm@lists.cs.columbia.edu,
 mihai.carabas@oracle.com,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 "Russell King \(Oracle\)" <linux@armlinux.org.uk>,
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

Hi,

On Fri, Feb 04, 2022 at 03:40:15PM +0000, Alexandru Elisei wrote:
> Hi Marc,
> 
> On Fri, Jan 28, 2022 at 12:18:30PM +0000, Marc Zyngier wrote:
> > From: Jintack Lim <jintack.lim@linaro.org>
> > 
> > Forward exceptions due to WFI or WFE instructions to the virtual EL2 if
> > they are not coming from the virtual EL2 and virtual HCR_EL2.TWX is set.
> > 
> > Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
> > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > ---
> >  arch/arm64/include/asm/kvm_nested.h |  2 ++
> >  arch/arm64/kvm/Makefile             |  2 +-
> >  arch/arm64/kvm/handle_exit.c        | 11 ++++++++++-
> >  arch/arm64/kvm/nested.c             | 28 ++++++++++++++++++++++++++++
> >  4 files changed, 41 insertions(+), 2 deletions(-)
> >  create mode 100644 arch/arm64/kvm/nested.c
> > 
> > diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
> > index 5a85be6d8eb3..79d382fa02ea 100644
> > --- a/arch/arm64/include/asm/kvm_nested.h
> > +++ b/arch/arm64/include/asm/kvm_nested.h
> > @@ -65,4 +65,6 @@ static inline u64 translate_cnthctl_el2_to_cntkctl_el1(u64 cnthctl)
> >  		(cnthctl & (CNTHCTL_EVNTI | CNTHCTL_EVNTDIR | CNTHCTL_EVNTEN)));
> >  }
> >  
> > +int handle_wfx_nested(struct kvm_vcpu *vcpu, bool is_wfe);
> > +
> >  #endif /* __ARM64_KVM_NESTED_H */
> > diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
> > index b67c4ebd72b1..dbaf42ff65f1 100644
> > --- a/arch/arm64/kvm/Makefile
> > +++ b/arch/arm64/kvm/Makefile
> > @@ -14,7 +14,7 @@ kvm-y += arm.o mmu.o mmio.o psci.o hypercalls.o pvtime.o \
> >  	 inject_fault.o va_layout.o handle_exit.o \
> >  	 guest.o debug.o reset.o sys_regs.o \
> >  	 vgic-sys-reg-v3.o fpsimd.o pmu.o pkvm.o \
> > -	 arch_timer.o trng.o emulate-nested.o \
> > +	 arch_timer.o trng.o emulate-nested.o nested.o \
> >  	 vgic/vgic.o vgic/vgic-init.o \
> >  	 vgic/vgic-irqfd.o vgic/vgic-v2.o \
> >  	 vgic/vgic-v3.o vgic/vgic-v4.o \
> > diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> > index 0cedef6e0d80..a1b1bbf3d598 100644
> > --- a/arch/arm64/kvm/handle_exit.c
> > +++ b/arch/arm64/kvm/handle_exit.c
> > @@ -119,7 +119,16 @@ static int handle_no_fpsimd(struct kvm_vcpu *vcpu)
> >   */
> >  static int kvm_handle_wfx(struct kvm_vcpu *vcpu)
> >  {
> > -	if (kvm_vcpu_get_esr(vcpu) & ESR_ELx_WFx_ISS_WFE) {
> > +	bool is_wfe = !!(kvm_vcpu_get_esr(vcpu) & ESR_ELx_WFx_ISS_WFE);
> > +
> > +	if (vcpu_has_nv(vcpu)) {
> > +		int ret = handle_wfx_nested(vcpu, is_wfe);
> > +
> > +		if (ret != -EINVAL)
> > +			return ret;
> 
> I find this rather clunky. The common pattern is that a function returns
> early when it encounters an error, but here this pattern is reversed:
> -EINVAL means that handle_wfx_nested() failed in handling the WFx, so
> proceed as usual; conversly, anything but -EINVAL means handle_wfx_nested()
> was successful in handling WFx, so exit early from kvm_handle_wfx().
> 
> That would be ok by itself, but if we dig deeper, handle_wfx_nested() ends up
> calling kvm_inject_nested(), where -EINVAL is actually an error code. Granted,
> that should never happen, because kvm_handle_wfx() first checks vcpu_has_nv(),
> but still feels like something that could be improved.
> 
> Maybe changing handle_wfx_nested() like this would be better:
> [..]

Or change kvm_handle_wfx() to handle the WFx trap like kvm_handle_fpasimd():

	if (guest_wfx_traps_enabled(vcpu))
		return kvm_inject_nested_sync(vcpu, kvm_vcpu_get_esr(vcpu));

Thanks,
Alex
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
