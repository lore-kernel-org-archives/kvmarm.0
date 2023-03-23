Received: from out-40.mta0.migadu.com (out-40.mta0.migadu.com [91.218.175.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22B76C95D
	for <kvmarm@lists.linux.dev>; Thu, 23 Mar 2023 19:47:08 +0000 (UTC)
Date: Thu, 23 Mar 2023 19:47:02 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1679600826;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=S1VdrSVQfIuDr4D4jJwJOYfhjoA47iDOv8dkTg0hErM=;
	b=wrWKddIbsxQKPwN7GRcrq+v/gdnhacecxn4oP/p8edGLtOhdMyteo463Glr6Ni0ObaLvat
	KR596BvhZysuAZLrfE2Q01BZ1hk3+XV8HWXdqasQm0otPn4tsPD8zcJkdszRY11ZxI1AqH
	aCVByGhWC4M4KSst0bNEHLhNA6WMkWY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>, kvmarm@lists.linux.dev,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH v2 1/4] KVM: arm64: Avoid vcpu->mutex v. kvm->lock
 inversion in CPU_ON
Message-ID: <ZBystq7XkN1Dt3ox@linux.dev>
References: <20230316211412.2651555-1-oliver.upton@linux.dev>
 <20230316211412.2651555-2-oliver.upton@linux.dev>
 <87mt45gfjj.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87mt45gfjj.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Wed, Mar 22, 2023 at 12:02:24PM +0000, Marc Zyngier wrote:
> On Thu, 16 Mar 2023 21:14:09 +0000,
> Oliver Upton <oliver.upton@linux.dev> wrote:
> > 
> > KVM/arm64 had the lock ordering backwards on vcpu->mutex and kvm->lock
> > from the very beginning. One such example is the way vCPU resets are
> > handled: the kvm->lock is acquired while handling a guest CPU_ON PSCI
> > call.
> > 
> > Add a dedicated lock to serialize writes to kvm_vcpu_arch::mp_state.
> > Hold the lock in kvm_psci_vcpu_on() to protect against changes while
> > the reset state is being configured. Ensure that readers read mp_state
> > exactly once. While at it, plug yet another race by taking the
> > mp_state_lock in the KVM_SET_MP_STATE ioctl handler.
> > 
> > As changes to MP state are now guarded with a dedicated lock, drop the
> > kvm->lock acquisition from the PSCI CPU_ON path. Similarly, move the
> > reader of reset_state outside of the kvm->lock and insert a barrier to
> > ensure reset_state is read before dropping the pending reset state.
> > 
> > While the kvm->lock inversion still exists in kvm_reset_vcpu(), at least
> > now PSCI CPU_ON no longer depends on it for serializing vCPU reset.
> > 
> > Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> > ---
> >  arch/arm64/include/asm/kvm_host.h |  1 +
> >  arch/arm64/kvm/arm.c              | 23 ++++++++++++++++++-----
> >  arch/arm64/kvm/psci.c             | 19 ++++++++++---------
> >  arch/arm64/kvm/reset.c            | 10 ++++++----
> >  4 files changed, 35 insertions(+), 18 deletions(-)
> > 
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index bcd774d74f34..917586237a4d 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -522,6 +522,7 @@ struct kvm_vcpu_arch {
> >  
> >  	/* vcpu power state */
> >  	struct kvm_mp_state mp_state;
> > +	spinlock_t mp_state_lock;
> >  
> >  	/* Cache some mmu pages needed inside spinlock regions */
> >  	struct kvm_mmu_memory_cache mmu_page_cache;
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index 3bd732eaf087..731a78f85915 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -326,6 +326,8 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
> >  {
> >  	int err;
> >  
> > +	spin_lock_init(&vcpu->arch.mp_state_lock);
> > +
> >  	/* Force users to call KVM_ARM_VCPU_INIT */
> >  	vcpu->arch.target = -1;
> >  	bitmap_zero(vcpu->arch.features, KVM_VCPU_MAX_FEATURES);
> > @@ -443,16 +445,23 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
> >  	vcpu->cpu = -1;
> >  }
> >  
> > -void kvm_arm_vcpu_power_off(struct kvm_vcpu *vcpu)
> > +static void __kvm_arm_vcpu_power_off(struct kvm_vcpu *vcpu)
> >  {
> >  	vcpu->arch.mp_state.mp_state = KVM_MP_STATE_STOPPED;
> >  	kvm_make_request(KVM_REQ_SLEEP, vcpu);
> >  	kvm_vcpu_kick(vcpu);
> >  }
> >  
> > +void kvm_arm_vcpu_power_off(struct kvm_vcpu *vcpu)
> > +{
> > +	spin_lock(&vcpu->arch.mp_state_lock);
> > +	__kvm_arm_vcpu_power_off(vcpu);
> > +	spin_unlock(&vcpu->arch.mp_state_lock);
> > +}
> > +
> >  bool kvm_arm_vcpu_stopped(struct kvm_vcpu *vcpu)
> >  {
> > -	return vcpu->arch.mp_state.mp_state == KVM_MP_STATE_STOPPED;
> > +	return READ_ONCE(vcpu->arch.mp_state.mp_state) == KVM_MP_STATE_STOPPED;
> >  }
> >  
> >  static void kvm_arm_vcpu_suspend(struct kvm_vcpu *vcpu)
> > @@ -464,13 +473,13 @@ static void kvm_arm_vcpu_suspend(struct kvm_vcpu *vcpu)
> >  
> >  static bool kvm_arm_vcpu_suspended(struct kvm_vcpu *vcpu)
> >  {
> > -	return vcpu->arch.mp_state.mp_state == KVM_MP_STATE_SUSPENDED;
> > +	return READ_ONCE(vcpu->arch.mp_state.mp_state) == KVM_MP_STATE_SUSPENDED;
> >  }
> >  
> >  int kvm_arch_vcpu_ioctl_get_mpstate(struct kvm_vcpu *vcpu,
> >  				    struct kvm_mp_state *mp_state)
> >  {
> > -	*mp_state = vcpu->arch.mp_state;
> > +	*mp_state = READ_ONCE(vcpu->arch.mp_state);
> >  
> >  	return 0;
> >  }
> > @@ -480,12 +489,14 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
> >  {
> >  	int ret = 0;
> >  
> > +	spin_lock(&vcpu->arch.mp_state_lock);
> > +
> >  	switch (mp_state->mp_state) {
> >  	case KVM_MP_STATE_RUNNABLE:
> >  		vcpu->arch.mp_state = *mp_state;
> 
> Given that the above helpers snapshot mp_state without holding the
> lock, it'd be better to at least turn this into a WRITE_ONCE().

Yeah, definitely need that.

> >  		break;
> >  	case KVM_MP_STATE_STOPPED:
> > -		kvm_arm_vcpu_power_off(vcpu);
> > +		__kvm_arm_vcpu_power_off(vcpu);
> >  		break;
> >  	case KVM_MP_STATE_SUSPENDED:
> >  		kvm_arm_vcpu_suspend(vcpu);
> > @@ -494,6 +505,8 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
> >  		ret = -EINVAL;
> >  	}
> >  
> > +	spin_unlock(&vcpu->arch.mp_state_lock);
> > +
> >  	return ret;
> >  }
> >  
> > diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
> > index 7fbc4c1b9df0..7f1bff1cd670 100644
> > --- a/arch/arm64/kvm/psci.c
> > +++ b/arch/arm64/kvm/psci.c
> > @@ -62,6 +62,7 @@ static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
> >  	struct vcpu_reset_state *reset_state;
> >  	struct kvm *kvm = source_vcpu->kvm;
> >  	struct kvm_vcpu *vcpu = NULL;
> > +	int ret = PSCI_RET_SUCCESS;
> >  	unsigned long cpu_id;
> >  
> >  	cpu_id = smccc_get_arg1(source_vcpu);
> > @@ -76,11 +77,15 @@ static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
> >  	 */
> >  	if (!vcpu)
> >  		return PSCI_RET_INVALID_PARAMS;
> > +
> > +	spin_lock(&vcpu->arch.mp_state_lock);
> >  	if (!kvm_arm_vcpu_stopped(vcpu)) {
> >  		if (kvm_psci_version(source_vcpu) != KVM_ARM_PSCI_0_1)
> > -			return PSCI_RET_ALREADY_ON;
> > +			ret = PSCI_RET_ALREADY_ON;
> >  		else
> > -			return PSCI_RET_INVALID_PARAMS;
> > +			ret = PSCI_RET_INVALID_PARAMS;
> > +
> > +		goto out_unlock;
> >  	}
> >  
> >  	reset_state = &vcpu->arch.reset_state;
> > @@ -108,7 +113,9 @@ static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
> >  	vcpu->arch.mp_state.mp_state = KVM_MP_STATE_RUNNABLE;
> >  	kvm_vcpu_wake_up(vcpu);
> >  
> > -	return PSCI_RET_SUCCESS;
> > +out_unlock:
> > +	spin_unlock(&vcpu->arch.mp_state_lock);
> > +	return ret;
> >  }
> >  
> >  static unsigned long kvm_psci_vcpu_affinity_info(struct kvm_vcpu *vcpu)
> > @@ -229,7 +236,6 @@ static unsigned long kvm_psci_check_allowed_function(struct kvm_vcpu *vcpu, u32
> >  
> >  static int kvm_psci_0_2_call(struct kvm_vcpu *vcpu)
> >  {
> > -	struct kvm *kvm = vcpu->kvm;
> >  	u32 psci_fn = smccc_get_function(vcpu);
> >  	unsigned long val;
> >  	int ret = 1;
> > @@ -254,9 +260,7 @@ static int kvm_psci_0_2_call(struct kvm_vcpu *vcpu)
> >  		kvm_psci_narrow_to_32bit(vcpu);
> >  		fallthrough;
> >  	case PSCI_0_2_FN64_CPU_ON:
> > -		mutex_lock(&kvm->lock);
> >  		val = kvm_psci_vcpu_on(vcpu);
> > -		mutex_unlock(&kvm->lock);
> >  		break;
> >  	case PSCI_0_2_FN_AFFINITY_INFO:
> >  		kvm_psci_narrow_to_32bit(vcpu);
> > @@ -395,7 +399,6 @@ static int kvm_psci_1_x_call(struct kvm_vcpu *vcpu, u32 minor)
> >  
> >  static int kvm_psci_0_1_call(struct kvm_vcpu *vcpu)
> >  {
> > -	struct kvm *kvm = vcpu->kvm;
> >  	u32 psci_fn = smccc_get_function(vcpu);
> >  	unsigned long val;
> >  
> > @@ -405,9 +408,7 @@ static int kvm_psci_0_1_call(struct kvm_vcpu *vcpu)
> >  		val = PSCI_RET_SUCCESS;
> >  		break;
> >  	case KVM_PSCI_FN_CPU_ON:
> > -		mutex_lock(&kvm->lock);
> >  		val = kvm_psci_vcpu_on(vcpu);
> > -		mutex_unlock(&kvm->lock);
> >  		break;
> >  	default:
> >  		val = PSCI_RET_NOT_SUPPORTED;
> > diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> > index 49a3257dec46..b874ec6a37c1 100644
> > --- a/arch/arm64/kvm/reset.c
> > +++ b/arch/arm64/kvm/reset.c
> > @@ -264,15 +264,17 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
> >  
> >  	mutex_lock(&vcpu->kvm->lock);
> >  	ret = kvm_set_vm_width(vcpu);
> > -	if (!ret) {
> > -		reset_state = vcpu->arch.reset_state;
> > -		WRITE_ONCE(vcpu->arch.reset_state.reset, false);
> > -	}
> >  	mutex_unlock(&vcpu->kvm->lock);
> >  
> >  	if (ret)
> >  		return ret;
> >  
> > +	reset_state = vcpu->arch.reset_state;
> > +
> > +	/* Ensure reset_state is read before clearing the pending state */
> > +	smp_rmb();
> > +	WRITE_ONCE(vcpu->arch.reset_state.reset, false);
> 
> What prevents a concurrent PSCI call from messing with this state? I'd
> have expected this to be done while holding the mp_state lock... There
> must be something, somewhere, but I fail to spot it right now.

It is a bit shaky, but my expectation was that the vCPU couldn't be
transitioned from RUNNABLE -> STOPPED w/o holding the vcpu->mutex, thus
any PSCI CPU_ON calls would fail as the vCPU is marked as RUNNABLE until
the reset completes.

However, looking at this with fresh eyes, the kvm_prepare_system_event()
flow breaks my expectation and does an unguarded transition to STOPPED
state.

So, in the interest of making the whole dance correct I'll take the
mp_state_lock here and in kvm_prepare_system_event(). Thanks for
spotting this.

--
Thanks,
Oliver
