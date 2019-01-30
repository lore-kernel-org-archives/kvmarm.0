From: Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: [PATCH 2/5] arm/arm64: KVM: Allow a VCPU to fully reset itself
Date: Wed, 30 Jan 2019 10:34:31 +0100
Message-ID: <20190130093431.GE13482@e113682-lin.lund.arm.com>
References: <20190125094656.5026-1-christoffer.dall@arm.com>
 <20190125094656.5026-3-christoffer.dall@arm.com>
 <20190129160347.fcbry76igwyatqzx@kamzik.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4D4534A32D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Jan 2019 04:34:36 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id opkYSTmXA7hc for <kvmarm@lists.cs.columbia.edu>;
 Wed, 30 Jan 2019 04:34:34 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9EC304A2E4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Jan 2019 04:34:34 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20190129160347.fcbry76igwyatqzx@kamzik.brq.redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Jones <drjones@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Jan 29, 2019 at 05:03:47PM +0100, Andrew Jones wrote:
> On Fri, Jan 25, 2019 at 10:46:53AM +0100, Christoffer Dall wrote:
> > From: Marc Zyngier <marc.zyngier@arm.com>
> > 
> > The current kvm_psci_vcpu_on implementation will directly try to
> > manipulate the state of the VCPU to reset it.  However, since this is
> > not done on the thread that runs the VCPU, we can end up in a strangely
> > corrupted state when the source and target VCPUs are running at the same
> > time.
> > 
> > Fix this by factoring out all reset logic from the PSCI implementation
> > and forwarding the required information along with a request to the
> > target VCPU.
> 
> The last patch makes more sense, now that I see this one. I guess their
> order should be swapped.
> 
> > 
> > Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> > Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
> > ---
> >  arch/arm/include/asm/kvm_host.h   | 10 +++++++++
> >  arch/arm/kvm/reset.c              | 24 +++++++++++++++++++++
> >  arch/arm64/include/asm/kvm_host.h | 11 ++++++++++
> >  arch/arm64/kvm/reset.c            | 24 +++++++++++++++++++++
> >  virt/kvm/arm/arm.c                | 10 +++++++++
> >  virt/kvm/arm/psci.c               | 36 ++++++++++++++-----------------
> >  6 files changed, 95 insertions(+), 20 deletions(-)
> > 
> > diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
> > index ca56537b61bc..50e89869178a 100644
> > --- a/arch/arm/include/asm/kvm_host.h
> > +++ b/arch/arm/include/asm/kvm_host.h
> > @@ -48,6 +48,7 @@
> >  #define KVM_REQ_SLEEP \
> >  	KVM_ARCH_REQ_FLAGS(0, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
> >  #define KVM_REQ_IRQ_PENDING	KVM_ARCH_REQ(1)
> > +#define KVM_REQ_VCPU_RESET	KVM_ARCH_REQ(2)
> >  
> >  DECLARE_STATIC_KEY_FALSE(userspace_irqchip_in_use);
> >  
> > @@ -147,6 +148,13 @@ struct kvm_cpu_context {
> >  
> >  typedef struct kvm_cpu_context kvm_cpu_context_t;
> >  
> > +struct vcpu_reset_state {
> > +	unsigned long	pc;
> > +	unsigned long	r0;
> > +	bool		be;
> > +	bool		reset;
> > +};
> > +
> >  struct kvm_vcpu_arch {
> >  	struct kvm_cpu_context ctxt;
> >  
> > @@ -186,6 +194,8 @@ struct kvm_vcpu_arch {
> >  	/* Cache some mmu pages needed inside spinlock regions */
> >  	struct kvm_mmu_memory_cache mmu_page_cache;
> >  
> > +	struct vcpu_reset_state reset_state;
> > +
> >  	/* Detect first run of a vcpu */
> >  	bool has_run_once;
> >  };
> > diff --git a/arch/arm/kvm/reset.c b/arch/arm/kvm/reset.c
> > index 5ed0c3ee33d6..de41255eebcd 100644
> > --- a/arch/arm/kvm/reset.c
> > +++ b/arch/arm/kvm/reset.c
> > @@ -26,6 +26,7 @@
> >  #include <asm/cputype.h>
> >  #include <asm/kvm_arm.h>
> >  #include <asm/kvm_coproc.h>
> > +#include <asm/kvm_emulate.h>
> >  
> >  #include <kvm/arm_arch_timer.h>
> >  
> > @@ -69,6 +70,29 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
> >  	/* Reset CP15 registers */
> >  	kvm_reset_coprocs(vcpu);
> >  
> > +	/*
> > +	 * Additional reset state handling that PSCI may have imposed on us.
> > +	 * Must be done after all the sys_reg reset.
> > +	 */
> > +	if (vcpu->arch.reset_state.reset) {
> > +		unsigned long target_pc = vcpu->arch.reset_state.pc;
> > +
> > +		/* Gracefully handle Thumb2 entry point */
> > +		if (target_pc & 1) {
> > +			target_pc &= ~1UL;
> > +			vcpu_set_thumb(vcpu);
> > +		}
> > +
> > +		/* Propagate caller endianness */
> > +		if (vcpu->arch.reset_state.be)
> > +			kvm_vcpu_set_be(vcpu);
> > +
> > +		*vcpu_pc(vcpu) = target_pc;
> > +		vcpu_set_reg(vcpu, 0, vcpu->arch.reset_state.r0);
> > +
> > +		vcpu->arch.reset_state.reset = false;
> > +	}
> > +
> >  	/* Reset arch_timer context */
> >  	return kvm_timer_vcpu_reset(vcpu);
> >  }
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index 7732d0ba4e60..da3fc7324d68 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -48,6 +48,7 @@
> >  #define KVM_REQ_SLEEP \
> >  	KVM_ARCH_REQ_FLAGS(0, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
> >  #define KVM_REQ_IRQ_PENDING	KVM_ARCH_REQ(1)
> > +#define KVM_REQ_VCPU_RESET	KVM_ARCH_REQ(2)
> >  
> >  DECLARE_STATIC_KEY_FALSE(userspace_irqchip_in_use);
> >  
> > @@ -208,6 +209,13 @@ struct kvm_cpu_context {
> >  
> >  typedef struct kvm_cpu_context kvm_cpu_context_t;
> >  
> > +struct vcpu_reset_state {
> > +	unsigned long	pc;
> > +	unsigned long	r0;
> > +	bool		be;
> > +	bool		reset;
> > +};
> > +
> >  struct kvm_vcpu_arch {
> >  	struct kvm_cpu_context ctxt;
> >  
> > @@ -297,6 +305,9 @@ struct kvm_vcpu_arch {
> >  	/* Virtual SError ESR to restore when HCR_EL2.VSE is set */
> >  	u64 vsesr_el2;
> >  
> > +	/* Additional reset state */
> > +	struct vcpu_reset_state	reset_state;
> > +
> >  	/* True when deferrable sysregs are loaded on the physical CPU,
> >  	 * see kvm_vcpu_load_sysregs and kvm_vcpu_put_sysregs. */
> >  	bool sysregs_loaded_on_cpu;
> > diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> > index f21a2a575939..f16a5f8ff2b4 100644
> > --- a/arch/arm64/kvm/reset.c
> > +++ b/arch/arm64/kvm/reset.c
> > @@ -32,6 +32,7 @@
> >  #include <asm/kvm_arm.h>
> >  #include <asm/kvm_asm.h>
> >  #include <asm/kvm_coproc.h>
> > +#include <asm/kvm_emulate.h>
> >  #include <asm/kvm_mmu.h>
> >  
> >  /* Maximum phys_shift supported for any VM on this host */
> > @@ -146,6 +147,29 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
> >  	/* Reset system registers */
> >  	kvm_reset_sys_regs(vcpu);
> >  
> > +	/*
> > +	 * Additional reset state handling that PSCI may have imposed on us.
> > +	 * Must be done after all the sys_reg reset.
> > +	 */
> > +	if (vcpu->arch.reset_state.reset) {
> > +		unsigned long target_pc = vcpu->arch.reset_state.pc;
> > +
> > +		/* Gracefully handle Thumb2 entry point */
> > +		if (vcpu_mode_is_32bit(vcpu) && (target_pc & 1)) {
> > +			target_pc &= ~1UL;
> > +			vcpu_set_thumb(vcpu);
> > +		}
> > +
> > +		/* Propagate caller endianness */
> > +		if (vcpu->arch.reset_state.be)
> > +			kvm_vcpu_set_be(vcpu);
> > +
> > +		*vcpu_pc(vcpu) = target_pc;
> > +		vcpu_set_reg(vcpu, 0, vcpu->arch.reset_state.r0);
> > +
> > +		vcpu->arch.reset_state.reset = false;
> > +	}
> > +
> >  	/* Reset PMU */
> >  	kvm_pmu_vcpu_reset(vcpu);
> >  
> > diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
> > index 9e350fd34504..9c486fad3f9f 100644
> > --- a/virt/kvm/arm/arm.c
> > +++ b/virt/kvm/arm/arm.c
> > @@ -626,6 +626,13 @@ static void vcpu_req_sleep(struct kvm_vcpu *vcpu)
> >  		/* Awaken to handle a signal, request we sleep again later. */
> >  		kvm_make_request(KVM_REQ_SLEEP, vcpu);
> >  	}
> > +
> > +	/*
> > +	 * Make sure we will observe a potential reset request if we've
> > +	 * observed a change to the power state. Pairs with the smp_wmb() in
> > +	 * kvm_psci_vcpu_on().
> > +	 */
> > +	smp_rmb();
> 
> I don't believe this should be necessary, because...
> 
> >  }
> >  
> >  static int kvm_vcpu_initialized(struct kvm_vcpu *vcpu)
> > @@ -639,6 +646,9 @@ static void check_vcpu_requests(struct kvm_vcpu *vcpu)
> >  		if (kvm_check_request(KVM_REQ_SLEEP, vcpu))
> >  			vcpu_req_sleep(vcpu);
> >  
> > +		if (kvm_check_request(KVM_REQ_VCPU_RESET, vcpu))
> > +			kvm_reset_vcpu(vcpu);
> 
> ... we do kvm_check_request here before using the reset data, and we do...
> 
> > +
> >  		/*
> >  		 * Clear IRQ_PENDING requests that were made to guarantee
> >  		 * that a VCPU sees new virtual interrupts.
> > diff --git a/virt/kvm/arm/psci.c b/virt/kvm/arm/psci.c
> > index 9b73d3ad918a..b9cff1d4b06d 100644
> > --- a/virt/kvm/arm/psci.c
> > +++ b/virt/kvm/arm/psci.c
> > @@ -104,12 +104,10 @@ static void kvm_psci_vcpu_off(struct kvm_vcpu *vcpu)
> >  
> >  static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
> >  {
> > +	struct vcpu_reset_state *reset_state;
> >  	struct kvm *kvm = source_vcpu->kvm;
> >  	struct kvm_vcpu *vcpu = NULL;
> > -	struct swait_queue_head *wq;
> >  	unsigned long cpu_id;
> > -	unsigned long context_id;
> > -	phys_addr_t target_pc;
> >  
> >  	cpu_id = smccc_get_arg1(source_vcpu) & MPIDR_HWID_BITMASK;
> >  	if (vcpu_mode_is_32bit(source_vcpu))
> > @@ -130,32 +128,30 @@ static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
> >  			return PSCI_RET_INVALID_PARAMS;
> >  	}
> >  
> > -	target_pc = smccc_get_arg2(source_vcpu);
> > -	context_id = smccc_get_arg3(source_vcpu);
> > +	reset_state = &vcpu->arch.reset_state;
> >  
> > -	kvm_reset_vcpu(vcpu);
> > -
> > -	/* Gracefully handle Thumb2 entry point */
> > -	if (vcpu_mode_is_32bit(vcpu) && (target_pc & 1)) {
> > -		target_pc &= ~((phys_addr_t) 1);
> > -		vcpu_set_thumb(vcpu);
> > -	}
> > +	reset_state->pc = smccc_get_arg2(source_vcpu);
> >  
> >  	/* Propagate caller endianness */
> > -	if (kvm_vcpu_is_be(source_vcpu))
> > -		kvm_vcpu_set_be(vcpu);
> > +	reset_state->be = kvm_vcpu_is_be(source_vcpu);
> >  
> > -	*vcpu_pc(vcpu) = target_pc;
> >  	/*
> >  	 * NOTE: We always update r0 (or x0) because for PSCI v0.1
> >  	 * the general puspose registers are undefined upon CPU_ON.
> >  	 */
> > -	smccc_set_retval(vcpu, context_id, 0, 0, 0);
> > -	vcpu->arch.power_off = false;
> > -	smp_mb();		/* Make sure the above is visible */
> > +	reset_state->r0 = smccc_get_arg3(source_vcpu);
> > +
> > +	reset_state->reset = true;
> > +	kvm_make_request(KVM_REQ_VCPU_RESET, vcpu);
> 
> ... this kvm_make_request() after writing the reset data. The
> kvm_make_request/kvm_check_request embeds the necessary barriers.
> 
> >  
> > -	wq = kvm_arch_vcpu_wq(vcpu);
> > -	swake_up_one(wq);
> > +	/*
> > +	 * Make sure the reset request is observed if the change to
> > +	 * power_state is observed.
> > +	 */
> > +	smp_wmb();
> > +
> > +	vcpu->arch.power_off = false;
> 
> Or you want to tie the reset data to the observability of the power_off
> state? Why not just tie it to the KVM_REQ_VCPU_RESET request?
> 

The barrier in kvm_make_request is *before* the write to vcpu->requests,
so doesn't enforce any ordering of stores occurring *after* that write.

We don't want to wake up the target VCPU thread, have it observe that it
is powered on, yet not observe the reset request (my comment above
inversed).

I wrote this Litmus test (which is probably so appalingly obvious to
memory ordering folks that it is unnecessary) to convince myself the
barrier is needed:

----<8----
C vcpu-reset

{}

P0(int *power, int *reset)
{
	smp_wmb(); // from kvm_make_request
	WRITE_ONCE(*reset, 1); // kvm_psci_vcpu_on: kvm_make_request(KVM_REQ_RESET, vcpu);
	smp_wmb();
	WRITE_ONCE(*power, 1); // kvm_psci_vcpu_on: vcpu->arch.power_state = KVM_ARM_VCPU_ON;
}

P1(int *power, int *reset, spinlock_t *wqlock)
{
	int r0;
	int r1;

	spin_lock(wqlock);
	smp_mb(); // from prepare_to_wait -> set_current_state
	spin_unlock(wqlock);
	r0 = READ_ONCE(*power); // vcpu_req_sleep: if (vcpu_sleeping(vcpu))
	smp_rmb();
	r1 = READ_ONCE(*reset); // check_vcpu_requests: if (kvm_check_request(KVM_REQ_RESET, vcpu))
}

exists (1:r0=1 /\ 1:r1=0)
----<8----


Hope this helps,

    Christoffer
