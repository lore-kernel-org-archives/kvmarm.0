From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v3 15/20] KVM: arm/arm64: Support EL1 phys timer register
 access in set/get reg
Date: Thu, 19 Oct 2017 10:32:33 +0200
Message-ID: <20171019083233.GP8900@cbox>
References: <20170923004207.22356-1-cdall@linaro.org>
 <20170923004207.22356-16-cdall@linaro.org>
 <87infnwepo.fsf@on-the-bus.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 123E540795
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Oct 2017 04:31:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id le35tnMB6P7n for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 Oct 2017 04:31:30 -0400 (EDT)
Received: from mail-wm0-f66.google.com (mail-wm0-f66.google.com [74.125.82.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E4512406D0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Oct 2017 04:31:29 -0400 (EDT)
Received: by mail-wm0-f66.google.com with SMTP id u138so14832283wmu.4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Oct 2017 01:32:32 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <87infnwepo.fsf@on-the-bus.cambridge.arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Oct 10, 2017 at 10:10:27AM +0100, Marc Zyngier wrote:
> On Sat, Sep 23 2017 at  2:42:02 am BST, Christoffer Dall <cdall@linaro.org> wrote:
> > Add suport for the physical timer registers in kvm_arm_timer_set_reg and
> > kvm_arm_timer_get_reg so that these functions can be reused to interact
> > with the rest of the system.
> >
> > Note that this paves part of the way for the physical timer state
> > save/restore, but we still need to add those registers to
> > KVM_GET_REG_LIST before we support migrating the physical timer state.
> >
> > Signed-off-by: Christoffer Dall <cdall@linaro.org>
> > ---
> >  arch/arm/include/uapi/asm/kvm.h   |  6 ++++++
> >  arch/arm64/include/uapi/asm/kvm.h |  6 ++++++
> >  virt/kvm/arm/arch_timer.c         | 33 +++++++++++++++++++++++++++++++--
> >  3 files changed, 43 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/arm/include/uapi/asm/kvm.h b/arch/arm/include/uapi/asm/kvm.h
> > index 5db2d4c..665c454 100644
> > --- a/arch/arm/include/uapi/asm/kvm.h
> > +++ b/arch/arm/include/uapi/asm/kvm.h
> > @@ -151,6 +151,12 @@ struct kvm_arch_memory_slot {
> >  	(__ARM_CP15_REG(op1, 0, crm, 0) | KVM_REG_SIZE_U64)
> >  #define ARM_CP15_REG64(...) __ARM_CP15_REG64(__VA_ARGS__)
> >  
> > +/* PL1 Physical Timer Registers */
> > +#define KVM_REG_ARM_PTIMER_CTL		ARM_CP15_REG32(0, 14, 2, 1)
> > +#define KVM_REG_ARM_PTIMER_CNT		ARM_CP15_REG64(0, 14)
> > +#define KVM_REG_ARM_PTIMER_CVAL		ARM_CP15_REG64(2, 14)
> > +
> > +/* Virtual Timer Registers */
> >  #define KVM_REG_ARM_TIMER_CTL		ARM_CP15_REG32(0, 14, 3, 1)
> >  #define KVM_REG_ARM_TIMER_CNT		ARM_CP15_REG64(1, 14)
> >  #define KVM_REG_ARM_TIMER_CVAL		ARM_CP15_REG64(3, 14)
> > diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> > index 9f3ca24..07be6e2 100644
> > --- a/arch/arm64/include/uapi/asm/kvm.h
> > +++ b/arch/arm64/include/uapi/asm/kvm.h
> > @@ -195,6 +195,12 @@ struct kvm_arch_memory_slot {
> >  
> >  #define ARM64_SYS_REG(...) (__ARM64_SYS_REG(__VA_ARGS__) | KVM_REG_SIZE_U64)
> >  
> > +/* EL1 Physical Timer Registers */
> 
> These are EL0 registers, even if we tend to restrict them to EL1. Even
> the 32bit version is not strictly a PL1 register, since PL1 can delegate
> it to userspace (but the ARMv7 ARM still carries this PL1 thing...).
> 

The latest publicly available ARM ARM also refers to the timer as the
"EL1 Physical Timer", for example, the EL0 register CNTP_CTL_EL0 is
described as "Control register for the EL1 physical timer", so the
associativity in my comment was "(EL1 Physical Timer) Registers", and
not "Physical Timer (EL1 Registers)" :)

How about "EL0 Registers for the EL1 Physical Timer" or "Physical Timer
EL0 Registers" or "EL1 Physical Timer EL0 Registers".  Take your pick...

> > +#define KVM_REG_ARM_PTIMER_CTL		ARM64_SYS_REG(3, 3, 14, 2, 1)
> > +#define KVM_REG_ARM_PTIMER_CVAL		ARM64_SYS_REG(3, 3, 14, 2, 2)
> > +#define KVM_REG_ARM_PTIMER_CNT		ARM64_SYS_REG(3, 3, 14, 0, 1)
> > +
> > +/* EL0 Virtual Timer Registers */
> >  #define KVM_REG_ARM_TIMER_CTL		ARM64_SYS_REG(3, 3, 14, 3, 1)
> >  #define KVM_REG_ARM_TIMER_CNT		ARM64_SYS_REG(3, 3, 14, 3, 2)
> >  #define KVM_REG_ARM_TIMER_CVAL		ARM64_SYS_REG(3, 3, 14, 0, 2)
> > diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
> > index 70110ea..d5b632d 100644
> > --- a/virt/kvm/arm/arch_timer.c
> > +++ b/virt/kvm/arm/arch_timer.c
> > @@ -626,10 +626,11 @@ static void kvm_timer_init_interrupt(void *info)
> >  int kvm_arm_timer_set_reg(struct kvm_vcpu *vcpu, u64 regid, u64 value)
> >  {
> >  	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
> > +	struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
> >  
> >  	switch (regid) {
> >  	case KVM_REG_ARM_TIMER_CTL:
> > -		vtimer->cnt_ctl = value;
> > +		vtimer->cnt_ctl = value & ~ARCH_TIMER_CTRL_IT_STAT;
> 
> Ah, interesting. Does this change anything to userspace behaviour?
> 

The only effect is that you don't get read-as-written from userspace
behavior, but we don't guarantee that anywhere in the API and the
current QEMU code doesn't rely on it.

It can't have any meaningful effect, because ISTATUS is purely a
function of the remaining state of the timer.

> >  		break;
> >  	case KVM_REG_ARM_TIMER_CNT:
> >  		update_vtimer_cntvoff(vcpu, kvm_phys_timer_read() - value);
> > @@ -637,6 +638,13 @@ int kvm_arm_timer_set_reg(struct kvm_vcpu *vcpu, u64 regid, u64 value)
> >  	case KVM_REG_ARM_TIMER_CVAL:
> >  		vtimer->cnt_cval = value;
> >  		break;
> > +	case KVM_REG_ARM_PTIMER_CTL:
> > +		ptimer->cnt_ctl = value & ~ARCH_TIMER_CTRL_IT_STAT;
> > +		break;
> > +	case KVM_REG_ARM_PTIMER_CVAL:
> > +		ptimer->cnt_cval = value;
> > +		break;
> > +
> >  	default:
> >  		return -1;
> >  	}
> > @@ -645,17 +653,38 @@ int kvm_arm_timer_set_reg(struct kvm_vcpu *vcpu, u64 regid, u64 value)
> >  	return 0;
> >  }
> >  
> > +static u64 read_timer_ctl(struct arch_timer_context *timer)
> > +{
> > +	/*
> > +	 * Set ISTATUS bit if it's expired.
> > +	 * Note that according to ARMv8 ARM Issue A.k, ISTATUS bit is
> > +	 * UNKNOWN when ENABLE bit is 0, so we chose to set ISTATUS bit
> > +	 * regardless of ENABLE bit for our implementation convenience.
> > +	 */
> > +	if (!kvm_timer_compute_delta(timer))
> > +		return timer->cnt_ctl | ARCH_TIMER_CTRL_IT_STAT;
> > +	else
> > +		return timer->cnt_ctl;
> 
> Can't we end-up with a stale IT_STAT bit here if the timer has been
> snapshoted with an interrupt pending, and then CVAL updated to expire
> later?
> 

Yes, but that's just the nature of doing business with the timer, and no
different from the behavior we had before, where you could have run the
guest, read the cnt_ctl as it was saved in the world-switch, run the
VCPU again which changes cval, and then the bit would be stale.

Do you see us changing that behavior in some worse way here?

> > +}
> > +
> >  u64 kvm_arm_timer_get_reg(struct kvm_vcpu *vcpu, u64 regid)
> >  {
> > +	struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
> >  	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
> >  
> >  	switch (regid) {
> >  	case KVM_REG_ARM_TIMER_CTL:
> > -		return vtimer->cnt_ctl;
> > +		return read_timer_ctl(vtimer);
> >  	case KVM_REG_ARM_TIMER_CNT:
> >  		return kvm_phys_timer_read() - vtimer->cntvoff;
> >  	case KVM_REG_ARM_TIMER_CVAL:
> >  		return vtimer->cnt_cval;
> > +	case KVM_REG_ARM_PTIMER_CTL:
> > +		return read_timer_ctl(ptimer);
> > +	case KVM_REG_ARM_PTIMER_CVAL:
> > +		return ptimer->cnt_cval;
> > +	case KVM_REG_ARM_PTIMER_CNT:
> > +		return kvm_phys_timer_read();
> >  	}
> >  	return (u64)-1;
> >  }
> 

Thanks,
-Christoffer
