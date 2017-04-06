From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v3 4/5] KVM: arm/arm64: Report PMU overflow interrupts to
 userspace irqchip
Date: Thu, 6 Apr 2017 21:04:13 +0200
Message-ID: <20170406190413.GH27123@cbox>
References: <20170405092815.22503-1-cdall@linaro.org>
 <20170405092815.22503-5-cdall@linaro.org>
 <6c476719-8fb3-27b6-c7f6-84088443dcd4@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <6c476719-8fb3-27b6-c7f6-84088443dcd4@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Alexander Graf <agraf@suse.de>, Peter Maydell <peter.maydell@linaro.org>, Pekka Enberg <penberg@iki.fi>, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Apr 06, 2017 at 06:12:10PM +0100, Marc Zyngier wrote:
> On 05/04/17 10:28, Christoffer Dall wrote:
> > From: Christoffer Dall <christoffer.dall@linaro.org>
> > 
> > When not using an in-kernel VGIC, but instead emulating an interrupt
> > controller in userspace, we should report the PMU overflow status to
> > that userspace interrupt controller using the KVM_CAP_ARM_USER_IRQ
> > feature.
> > 
> > Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> > ---
> >  arch/arm/kvm/arm.c    |  9 ++++++---
> >  include/kvm/arm_pmu.h |  7 +++++++
> >  virt/kvm/arm/pmu.c    | 42 ++++++++++++++++++++++++++++++++++++++----
> >  3 files changed, 51 insertions(+), 7 deletions(-)
> > 
> > diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
> > index efb16e5..f935383 100644
> > --- a/arch/arm/kvm/arm.c
> > +++ b/arch/arm/kvm/arm.c
> > @@ -635,11 +635,13 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
> >  
> >  		/*
> >  		 * If we have a singal pending, or need to notify a userspace
> > -		 * irqchip about timer level changes, then we exit (and update
> > -		 * the timer level state in kvm_timer_update_run below).
> > +		 * irqchip about timer or PMU level changes, then we exit (and
> > +		 * update the timer level state in kvm_timer_update_run
> > +		 * below).
> >  		 */
> >  		if (signal_pending(current) ||
> > -		    kvm_timer_should_notify_user(vcpu)) {
> > +		    kvm_timer_should_notify_user(vcpu) ||
> > +		    kvm_pmu_should_notify_user(vcpu)) {
> >  			ret = -EINTR;
> >  			run->exit_reason = KVM_EXIT_INTR;
> >  		}
> > @@ -713,6 +715,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
> >  
> >  	/* Tell userspace about in-kernel device output levels */
> >  	kvm_timer_update_run(vcpu);
> > +	kvm_pmu_update_run(vcpu);
> 
> Very minor nit: as we now have a couple of functions that are going to
> check the same thing (irqchip_in_kernel), we could consider moving the
> test here.  I don't have strong feelings about it though.

I like it:

diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index f935383..4263785 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -714,8 +714,10 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 	}
 
 	/* Tell userspace about in-kernel device output levels */
-	kvm_timer_update_run(vcpu);
-	kvm_pmu_update_run(vcpu);
+	if (unlikely(!irqchip_in_kernel(vcpu->kvm))) {
+		kvm_timer_update_run(vcpu);
+		kvm_pmu_update_run(vcpu);
+	}
 
 	if (vcpu->sigset_active)
 		sigprocmask(SIG_SETMASK, &sigsaved, NULL);
diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index 5dc2167..5976609 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -193,9 +193,6 @@ void kvm_timer_update_run(struct kvm_vcpu *vcpu)
 	struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
 	struct kvm_sync_regs *regs = &vcpu->run->s.regs;
 
-	if (likely(irqchip_in_kernel(vcpu->kvm)))
-		return;
-
 	/* Populate the device bitmap with the timer states */
 	regs->device_irq_level &= ~(KVM_ARM_DEV_EL1_VTIMER |
 				    KVM_ARM_DEV_EL1_PTIMER);
diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
index 51218be..4b43e7f 100644
--- a/virt/kvm/arm/pmu.c
+++ b/virt/kvm/arm/pmu.c
@@ -262,9 +262,6 @@ void kvm_pmu_update_run(struct kvm_vcpu *vcpu)
 {
 	struct kvm_sync_regs *regs = &vcpu->run->s.regs;
 
-	if (likely(irqchip_in_kernel(vcpu->kvm)))
-		return;
-
 	/* Populate the timer bitmap for user space */
 	regs->device_irq_level &= ~KVM_ARM_DEV_PMU;
 	if (vcpu->arch.pmu.irq_level)


Thanks,
-Christoffer
