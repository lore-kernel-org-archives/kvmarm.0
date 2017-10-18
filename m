From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH 2/5] KVM: arm/arm64: replace power_off with
 mp_state=STOPPED
Date: Wed, 18 Oct 2017 14:04:07 +0200
Message-ID: <20171018120407.i63ranrwko5g6h2u@kamzik.brq.redhat.com>
References: <20170929113041.24371-1-drjones@redhat.com>
 <20170929113041.24371-3-drjones@redhat.com>
 <20171014191254.GA1929@lvm>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E614749D21
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Oct 2017 08:03:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5h5V+PPcHdwZ for <kvmarm@lists.cs.columbia.edu>;
 Wed, 18 Oct 2017 08:03:11 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 41F62406BB
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Oct 2017 08:03:11 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20171014191254.GA1929@lvm>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <cdall@linaro.org>
Cc: marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Sat, Oct 14, 2017 at 09:12:54PM +0200, Christoffer Dall wrote:
> On Fri, Sep 29, 2017 at 01:30:38PM +0200, Andrew Jones wrote:
> > This prepares for more MP states to be used.
> > 
> > Signed-off-by: Andrew Jones <drjones@redhat.com>
> > ---
> >  arch/arm/include/asm/kvm_host.h   |  6 ++++--
> >  arch/arm64/include/asm/kvm_host.h |  6 ++++--
> >  virt/kvm/arm/arm.c                | 26 ++++++++++++++------------
> >  virt/kvm/arm/psci.c               | 17 +++++------------
> >  4 files changed, 27 insertions(+), 28 deletions(-)
> > 
> > diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
> > index 4a879f6ff13b..85f3c20b9759 100644
> > --- a/arch/arm/include/asm/kvm_host.h
> > +++ b/arch/arm/include/asm/kvm_host.h
> > @@ -171,8 +171,8 @@ struct kvm_vcpu_arch {
> >  	 * here.
> >  	 */
> >  
> > -	/* vcpu power-off state */
> > -	bool power_off;
> > +	/* Current VCPU MP state */
> > +	u32 mp_state;
> >  
> >  	 /* Don't run the guest (internal implementation need) */
> >  	bool pause;
> > @@ -227,6 +227,8 @@ int kvm_test_age_hva(struct kvm *kvm, unsigned long hva);
> >  
> >  struct kvm_vcpu *kvm_arm_get_running_vcpu(void);
> >  struct kvm_vcpu __percpu **kvm_get_running_vcpus(void);
> > +void kvm_arm_vcpu_power_off(struct kvm_vcpu *vcpu);
> > +void kvm_arm_vcpu_power_on(struct kvm_vcpu *vcpu);
> >  void kvm_arm_halt_guest(struct kvm *kvm);
> >  void kvm_arm_resume_guest(struct kvm *kvm);
> >  
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index e923b58606e2..25545a87de11 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -255,8 +255,8 @@ struct kvm_vcpu_arch {
> >  		u32	mdscr_el1;
> >  	} guest_debug_preserved;
> >  
> > -	/* vcpu power-off state */
> > -	bool power_off;
> > +	/* Current VCPU MP state */
> > +	u32 mp_state;
> >  
> >  	/* Don't run the guest (internal implementation need) */
> >  	bool pause;
> > @@ -328,6 +328,8 @@ int kvm_test_age_hva(struct kvm *kvm, unsigned long hva);
> >  
> >  struct kvm_vcpu *kvm_arm_get_running_vcpu(void);
> >  struct kvm_vcpu * __percpu *kvm_get_running_vcpus(void);
> > +void kvm_arm_vcpu_power_off(struct kvm_vcpu *vcpu);
> > +void kvm_arm_vcpu_power_on(struct kvm_vcpu *vcpu);
> >  void kvm_arm_halt_guest(struct kvm *kvm);
> >  void kvm_arm_resume_guest(struct kvm *kvm);
> >  
> > diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
> > index e4bec508ee5b..954e77608d29 100644
> > --- a/virt/kvm/arm/arm.c
> > +++ b/virt/kvm/arm/arm.c
> > @@ -368,21 +368,23 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
> >  	kvm_timer_vcpu_put(vcpu);
> >  }
> >  
> > -static void vcpu_power_off(struct kvm_vcpu *vcpu)
> > +void kvm_arm_vcpu_power_off(struct kvm_vcpu *vcpu)
> >  {
> > -	vcpu->arch.power_off = true;
> > +	vcpu->arch.mp_state = KVM_MP_STATE_STOPPED;
> >  	kvm_make_request(KVM_REQ_SLEEP, vcpu);
> >  	kvm_vcpu_kick(vcpu);
> >  }
> >  
> > +void kvm_arm_vcpu_power_on(struct kvm_vcpu *vcpu)
> > +{
> > +	vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
> > +	kvm_vcpu_kick(vcpu);
> 
> Given your rant about request-less kicks, shouldn't this be a
> kvm_vcpu_wake_up() ?

Wow, people actually listen to my rants? :-) Yes, I agree that
kvm_vcpu_wake_up() is more appropriate. I'll change that.

> 
> > +}
> > +
> >  int kvm_arch_vcpu_ioctl_get_mpstate(struct kvm_vcpu *vcpu,
> >  				    struct kvm_mp_state *mp_state)
> >  {
> > -	if (vcpu->arch.power_off)
> > -		mp_state->mp_state = KVM_MP_STATE_STOPPED;
> > -	else
> > -		mp_state->mp_state = KVM_MP_STATE_RUNNABLE;
> > -
> > +	mp_state->mp_state = vcpu->arch.mp_state;
> >  	return 0;
> >  }
> >  
> > @@ -391,10 +393,10 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
> >  {
> >  	switch (mp_state->mp_state) {
> >  	case KVM_MP_STATE_RUNNABLE:
> > -		vcpu->arch.power_off = false;
> > +		kvm_arm_vcpu_power_on(vcpu);
> >  		break;
> >  	case KVM_MP_STATE_STOPPED:
> > -		vcpu_power_off(vcpu);
> > +		kvm_arm_vcpu_power_off(vcpu);
> >  		break;
> >  	default:
> >  		return -EINVAL;
> > @@ -405,7 +407,7 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
> >  
> >  static bool vcpu_should_sleep(struct kvm_vcpu *vcpu)
> >  {
> > -	return vcpu->arch.power_off || vcpu->arch.pause;
> > +	return vcpu->arch.mp_state == KVM_MP_STATE_STOPPED || vcpu->arch.pause;
> >  }
> >  
> >  /**
> > @@ -919,9 +921,9 @@ static int kvm_arch_vcpu_ioctl_vcpu_init(struct kvm_vcpu *vcpu,
> >  	 * Handle the "start in power-off" case.
> >  	 */
> >  	if (test_bit(KVM_ARM_VCPU_POWER_OFF, vcpu->arch.features))
> > -		vcpu_power_off(vcpu);
> > +		kvm_arm_vcpu_power_off(vcpu);
> >  	else
> > -		vcpu->arch.power_off = false;
> > +		kvm_arm_vcpu_power_on(vcpu);
> >  
> >  	return 0;
> >  }
> > diff --git a/virt/kvm/arm/psci.c b/virt/kvm/arm/psci.c
> > index f1e363bab5e8..a7bf152f1247 100644
> > --- a/virt/kvm/arm/psci.c
> > +++ b/virt/kvm/arm/psci.c
> > @@ -64,16 +64,13 @@ static unsigned long kvm_psci_vcpu_suspend(struct kvm_vcpu *vcpu)
> >  
> >  static void kvm_psci_vcpu_off(struct kvm_vcpu *vcpu)
> >  {
> > -	vcpu->arch.power_off = true;
> > -	kvm_make_request(KVM_REQ_SLEEP, vcpu);
> > -	kvm_vcpu_kick(vcpu);
> > +	kvm_arm_vcpu_power_off(vcpu);
> >  }
> >  
> >  static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
> >  {
> >  	struct kvm *kvm = source_vcpu->kvm;
> >  	struct kvm_vcpu *vcpu = NULL;
> > -	struct swait_queue_head *wq;
> >  	unsigned long cpu_id;
> >  	unsigned long context_id;
> >  	phys_addr_t target_pc;
> > @@ -90,7 +87,7 @@ static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
> >  	 */
> >  	if (!vcpu)
> >  		return PSCI_RET_INVALID_PARAMS;
> > -	if (!vcpu->arch.power_off) {
> > +	if (vcpu->arch.mp_state != KVM_MP_STATE_STOPPED) {
> >  		if (kvm_psci_version(source_vcpu) != KVM_ARM_PSCI_0_1)
> >  			return PSCI_RET_ALREADY_ON;
> >  		else
> > @@ -118,11 +115,7 @@ static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
> >  	 * the general puspose registers are undefined upon CPU_ON.
> >  	 */
> >  	vcpu_set_reg(vcpu, 0, context_id);
> > -	vcpu->arch.power_off = false;
> > -	smp_mb();		/* Make sure the above is visible */
> > -
> > -	wq = kvm_arch_vcpu_wq(vcpu);
> > -	swake_up(wq);
> > +	kvm_arm_vcpu_power_on(vcpu);
> >  
> >  	return PSCI_RET_SUCCESS;
> >  }
> > @@ -156,7 +149,7 @@ static unsigned long kvm_psci_vcpu_affinity_info(struct kvm_vcpu *vcpu)
> >  		mpidr = kvm_vcpu_get_mpidr_aff(tmp);
> >  		if ((mpidr & target_affinity_mask) == target_affinity) {
> >  			matching_cpus++;
> > -			if (!tmp->arch.power_off)
> > +			if (tmp->arch.mp_state != KVM_MP_STATE_STOPPED)
> >  				return PSCI_0_2_AFFINITY_LEVEL_ON;
> >  		}
> >  	}
> > @@ -182,7 +175,7 @@ static void kvm_prepare_system_event(struct kvm_vcpu *vcpu, u32 type)
> >  	 * re-initialized.
> >  	 */
> >  	kvm_for_each_vcpu(i, tmp, vcpu->kvm)
> > -		tmp->arch.power_off = true;
> > +		tmp->arch.mp_state = KVM_MP_STATE_STOPPED;
> >  	kvm_make_all_cpus_request(vcpu->kvm, KVM_REQ_SLEEP);
> >  
> >  	memset(&vcpu->run->system_event, 0, sizeof(vcpu->run->system_event));
> > -- 
> > 2.13.5
> > 
> 
> Otherwise looks good to me:
> 
> Reviewed-by: Christoffer Dall <cdall@linaro.org>

Thanks,
drew
