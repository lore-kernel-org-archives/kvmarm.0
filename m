Return-Path: <SRS0=PUN/=2O=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 442F3C2D0CF
	for <kvmarm@archiver.kernel.org>; Tue, 24 Dec 2019 11:50:40 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CA63D206CB
	for <kvmarm@archiver.kernel.org>; Tue, 24 Dec 2019 11:50:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CA63D206CB
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3E5624AF2C;
	Tue, 24 Dec 2019 06:50:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QMgu2jzLpn4Q; Tue, 24 Dec 2019 06:50:37 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D54404AF31;
	Tue, 24 Dec 2019 06:50:37 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4F7BD4AF2C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Dec 2019 06:50:36 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4bGY7N3-8rXs for <kvmarm@lists.cs.columbia.edu>;
 Tue, 24 Dec 2019 06:50:34 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6054C4AF28
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Dec 2019 06:50:34 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0136A1FB;
 Tue, 24 Dec 2019 03:50:34 -0800 (PST)
Received: from localhost (unknown [10.37.6.20])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 685EF3F534;
 Tue, 24 Dec 2019 03:50:33 -0800 (PST)
Date: Tue, 24 Dec 2019 11:50:31 +0000
From: Andrew Murray <andrew.murray@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2 14/18] KVM: arm64: spe: Provide guest virtual
 interrupts for SPE
Message-ID: <20191224115031.GG42593@e119886-lin.cambridge.arm.com>
References: <20191220143025.33853-1-andrew.murray@arm.com>
 <20191220143025.33853-15-andrew.murray@arm.com>
 <867e2oimw9.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <867e2oimw9.wl-maz@kernel.org>
User-Agent: Mutt/1.10.1+81 (426a6c1) (2018-08-26)
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

On Sun, Dec 22, 2019 at 12:07:50PM +0000, Marc Zyngier wrote:
> On Fri, 20 Dec 2019 14:30:21 +0000,
> Andrew Murray <andrew.murray@arm.com> wrote:
> > 
> > Upon the exit of a guest, let's determine if the SPE device has generated
> > an interrupt - if so we'll inject a virtual interrupt to the guest.
> > 
> > Upon the entry and exit of a guest we'll also update the state of the
> > physical IRQ such that it is active when a guest interrupt is pending
> > and the guest is running.
> > 
> > Finally we map the physical IRQ to the virtual IRQ such that the guest
> > can deactivate the interrupt when it handles the interrupt.
> > 
> > Signed-off-by: Andrew Murray <andrew.murray@arm.com>
> > ---
> >  include/kvm/arm_spe.h |  6 ++++
> >  virt/kvm/arm/arm.c    |  5 ++-
> >  virt/kvm/arm/spe.c    | 71 +++++++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 81 insertions(+), 1 deletion(-)
> > 
> > diff --git a/include/kvm/arm_spe.h b/include/kvm/arm_spe.h
> > index 9c65130d726d..91b2214f543a 100644
> > --- a/include/kvm/arm_spe.h
> > +++ b/include/kvm/arm_spe.h
> > @@ -37,6 +37,9 @@ static inline bool kvm_arm_support_spe_v1(void)
> >  						      ID_AA64DFR0_PMSVER_SHIFT);
> >  }
> >  
> > +void kvm_spe_flush_hwstate(struct kvm_vcpu *vcpu);
> > +inline void kvm_spe_sync_hwstate(struct kvm_vcpu *vcpu);
> > +
> >  int kvm_arm_spe_v1_set_attr(struct kvm_vcpu *vcpu,
> >  			    struct kvm_device_attr *attr);
> >  int kvm_arm_spe_v1_get_attr(struct kvm_vcpu *vcpu,
> > @@ -49,6 +52,9 @@ int kvm_arm_spe_v1_enable(struct kvm_vcpu *vcpu);
> >  #define kvm_arm_support_spe_v1()	(false)
> >  #define kvm_arm_spe_irq_initialized(v)	(false)
> >  
> > +static inline void kvm_spe_flush_hwstate(struct kvm_vcpu *vcpu) {}
> > +static inline void kvm_spe_sync_hwstate(struct kvm_vcpu *vcpu) {}
> > +
> >  static inline int kvm_arm_spe_v1_set_attr(struct kvm_vcpu *vcpu,
> >  					  struct kvm_device_attr *attr)
> >  {
> > diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
> > index 340d2388ee2c..a66085c8e785 100644
> > --- a/virt/kvm/arm/arm.c
> > +++ b/virt/kvm/arm/arm.c
> > @@ -741,6 +741,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
> >  		preempt_disable();
> >  
> >  		kvm_pmu_flush_hwstate(vcpu);
> > +		kvm_spe_flush_hwstate(vcpu);
> >  
> >  		local_irq_disable();
> >  
> > @@ -782,6 +783,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
> >  		    kvm_request_pending(vcpu)) {
> >  			vcpu->mode = OUTSIDE_GUEST_MODE;
> >  			isb(); /* Ensure work in x_flush_hwstate is committed */
> > +			kvm_spe_sync_hwstate(vcpu);
> >  			kvm_pmu_sync_hwstate(vcpu);
> >  			if (static_branch_unlikely(&userspace_irqchip_in_use))
> >  				kvm_timer_sync_hwstate(vcpu);
> > @@ -816,11 +818,12 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
> >  		kvm_arm_clear_debug(vcpu);
> >  
> >  		/*
> > -		 * We must sync the PMU state before the vgic state so
> > +		 * We must sync the PMU and SPE state before the vgic state so
> >  		 * that the vgic can properly sample the updated state of the
> >  		 * interrupt line.
> >  		 */
> >  		kvm_pmu_sync_hwstate(vcpu);
> > +		kvm_spe_sync_hwstate(vcpu);
> 
> The *HUGE* difference is that the PMU is purely a virtual interrupt,
> while you're trying to deal with a HW interrupt here.
> 
> >  
> >  		/*
> >  		 * Sync the vgic state before syncing the timer state because
> > diff --git a/virt/kvm/arm/spe.c b/virt/kvm/arm/spe.c
> > index 83ac2cce2cc3..097ed39014e4 100644
> > --- a/virt/kvm/arm/spe.c
> > +++ b/virt/kvm/arm/spe.c
> > @@ -35,6 +35,68 @@ int kvm_arm_spe_v1_enable(struct kvm_vcpu *vcpu)
> >  	return 0;
> >  }
> >  
> > +static inline void set_spe_irq_phys_active(struct arm_spe_kvm_info *info,
> > +					   bool active)
> > +{
> > +	int r;
> > +	r = irq_set_irqchip_state(info->physical_irq, IRQCHIP_STATE_ACTIVE,
> > +				  active);
> > +	WARN_ON(r);
> > +}
> > +
> > +void kvm_spe_flush_hwstate(struct kvm_vcpu *vcpu)
> > +{
> > +	struct kvm_spe *spe = &vcpu->arch.spe;
> > +	bool phys_active = false;
> > +	struct arm_spe_kvm_info *info = arm_spe_get_kvm_info();
> > +
> > +	if (!kvm_arm_spe_v1_ready(vcpu))
> > +		return;
> > +
> > +	if (irqchip_in_kernel(vcpu->kvm))
> > +		phys_active = kvm_vgic_map_is_active(vcpu, spe->irq_num);
> > +
> > +	phys_active |= spe->irq_level;
> > +
> > +	set_spe_irq_phys_active(info, phys_active);
> 
> So you're happy to mess with the HW interrupt state even when you
> don't have a HW irqchip? If you are going to copy paste the timer code
> here, you'd need to support it all the way (no, don't).
> 
> > +}
> > +
> > +void kvm_spe_sync_hwstate(struct kvm_vcpu *vcpu)
> > +{
> > +	struct kvm_spe *spe = &vcpu->arch.spe;
> > +	u64 pmbsr;
> > +	int r;
> > +	bool service;
> > +	struct kvm_cpu_context *ctxt = &vcpu->arch.ctxt;
> > +	struct arm_spe_kvm_info *info = arm_spe_get_kvm_info();
> > +
> > +	if (!kvm_arm_spe_v1_ready(vcpu))
> > +		return;
> > +
> > +	set_spe_irq_phys_active(info, false);
> > +
> > +	pmbsr = ctxt->sys_regs[PMBSR_EL1];
> > +	service = !!(pmbsr & BIT(SYS_PMBSR_EL1_S_SHIFT));
> > +	if (spe->irq_level == service)
> > +		return;
> > +
> > +	spe->irq_level = service;
> > +
> > +	if (likely(irqchip_in_kernel(vcpu->kvm))) {
> > +		r = kvm_vgic_inject_irq(vcpu->kvm, vcpu->vcpu_id,
> > +					spe->irq_num, service, spe);
> > +		WARN_ON(r);
> > +	}
> > +}
> > +
> > +static inline bool kvm_arch_arm_spe_v1_get_input_level(int vintid)
> > +{
> > +	struct kvm_vcpu *vcpu = kvm_arm_get_running_vcpu();
> > +	struct kvm_spe *spe = &vcpu->arch.spe;
> > +
> > +	return spe->irq_level;
> > +}
> 
> This isn't what such a callback is for. It is supposed to sample the
> HW, an nothing else.
> 
> > +
> >  static int kvm_arm_spe_v1_init(struct kvm_vcpu *vcpu)
> >  {
> >  	if (!kvm_arm_support_spe_v1())
> > @@ -48,6 +110,7 @@ static int kvm_arm_spe_v1_init(struct kvm_vcpu *vcpu)
> >  
> >  	if (irqchip_in_kernel(vcpu->kvm)) {
> >  		int ret;
> > +		struct arm_spe_kvm_info *info;
> >  
> >  		/*
> >  		 * If using the SPE with an in-kernel virtual GIC
> > @@ -57,10 +120,18 @@ static int kvm_arm_spe_v1_init(struct kvm_vcpu *vcpu)
> >  		if (!vgic_initialized(vcpu->kvm))
> >  			return -ENODEV;
> >  
> > +		info = arm_spe_get_kvm_info();
> > +		if (!info->physical_irq)
> > +			return -ENODEV;
> > +
> >  		ret = kvm_vgic_set_owner(vcpu, vcpu->arch.spe.irq_num,
> >  					 &vcpu->arch.spe);
> >  		if (ret)
> >  			return ret;
> > +
> > +		ret = kvm_vgic_map_phys_irq(vcpu, info->physical_irq,
> > +					    vcpu->arch.spe.irq_num,
> > +					    kvm_arch_arm_spe_v1_get_input_level);
> 
> You're mapping the interrupt int the guest, and yet you have never
> forwarded the interrupt the first place. All this flow is only going
> to wreck the host driver as soon as an interrupt occurs.
> 
> I think you should rethink the interrupt handling altogether. It would
> make more sense if the interrupt was actually completely
> virtualized. If you can isolate the guest state and compute the
> interrupt state in SW (and from the above, it seems that you can),
> then you shouldn't mess with the whole forwarding *at all*, as it
> isn't designed for devices shared between host and guests.

Yes it's possible to read SYS_PMBSR_EL1_S_SHIFT and determine if SPE wants
service. If I understand correctly, you're suggesting on entry/exit to the
guest we determine this and inject an interrupt to the guest. As well as
removing the kvm_vgic_map_phys_irq mapping to the physical interrupt?

My understanding was that I needed knowledge of the physical SPE interrupt
number so that I could prevent the host SPE driver from getting spurious
interrupts due to guest use of the SPE. 

Thanks,

Andrew Murray

> 
> 	M.
> 
> -- 
> Jazz is not dead, it just smells funny.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
