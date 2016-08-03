From: Stefan Agner <stefan@agner.ch>
Subject: Re: [PATCH] KVM: arm/arm64: initialize new VGIC even without host GIC
Date: Tue, 02 Aug 2016 23:11:33 -0700
Message-ID: <889c440b4dd5e34f20d900ef5c5ba0b1@agner.ch>
References: <20160802143445.14005-1-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0712F41145
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Aug 2016 02:09:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xhtOQsVHf+Sy for <kvmarm@lists.cs.columbia.edu>;
 Wed,  3 Aug 2016 02:09:35 -0400 (EDT)
Received: from mail.kmu-office.ch (mail.kmu-office.ch [178.209.48.109])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8DFFB4113E
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Aug 2016 02:09:35 -0400 (EDT)
In-Reply-To: <20160802143445.14005-1-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andre Przywara <andre.przywara@arm.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 2016-08-02 07:34, Andre Przywara wrote:
> The new VGIC code is always in the VCPU entry/exit path, even when the
> actual GIC hardware initialization found the VGIC unusable (due to
> non-aligned base addresses or a missing maintenance interrupt, for
> instance).
> Since in this case the VGIC structures aren't initialized properly, the
> host kernel crashes on a NULL pointer dereference.
> Initialize each VCPU's ap_list even with the VGIC unavailable, so the
> VGIC code now just iterates an empty list in that case and no longer
> crashes the kernel.
> Also take care of the arch timer (which becomes unusable as well without
> a VGIC) by using a static key to prevent arch timer code to run in the
> hot path.
> Much of the code was inspired by Marc Zyngier.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> Reported-by: Stefan Agner <stefan@agner.ch>
> ---
> Hi Stefan, Drew,
> 
> can you test this on your systems which showed the issue?

Looks that this catches the issue nicely too, the guest kernel boots
fine!

Tested-by: Stefan Agner <stefan@agner.ch>

--
Stefan


> 
> Cheers,
> Andre.
> 
>  arch/arm/kvm/arm.c            | 14 ++++++++++----
>  include/kvm/arm_arch_timer.h  |  2 ++
>  virt/kvm/arm/arch_timer.c     | 11 +++++++++++
>  virt/kvm/arm/vgic/vgic-init.c |  9 ++++-----
>  4 files changed, 27 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
> index f1bde7c..cef35ce 100644
> --- a/arch/arm/kvm/arm.c
> +++ b/arch/arm/kvm/arm.c
> @@ -294,7 +294,8 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
>  	bitmap_zero(vcpu->arch.features, KVM_VCPU_MAX_FEATURES);
>  
>  	/* Set up the timer */
> -	kvm_timer_vcpu_init(vcpu);
> +	if (vgic_present)
> +		kvm_timer_vcpu_init(vcpu);
>  
>  	kvm_arm_reset_debug_ptr(vcpu);
>  
> @@ -1208,6 +1209,7 @@ static int init_subsystems(void)
>  		break;
>  	case -ENODEV:
>  	case -ENXIO:
> +		kvm_err("No useable vgic detected\n");
>  		vgic_present = false;
>  		err = 0;
>  		break;
> @@ -1218,9 +1220,13 @@ static int init_subsystems(void)
>  	/*
>  	 * Init HYP architected timer support
>  	 */
> -	err = kvm_timer_hyp_init();
> -	if (err)
> -		goto out;
> +	if (vgic_present) {
> +		err = kvm_timer_hyp_init();
> +		if (err)
> +			goto out;
> +	} else {
> +		static_branch_enable(&kvm_arch_timer_disabled);
> +	}
>  
>  	kvm_perf_init();
>  	kvm_coproc_table_init();
> diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
> index dda39d8..64f361f 100644
> --- a/include/kvm/arm_arch_timer.h
> +++ b/include/kvm/arm_arch_timer.h
> @@ -23,6 +23,8 @@
>  #include <linux/hrtimer.h>
>  #include <linux/workqueue.h>
>  
> +extern struct static_key_false kvm_arch_timer_disabled;
> +
>  struct arch_timer_kvm {
>  	/* Virtual offset */
>  	cycle_t			cntvoff;
> diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
> index 4fde8c7..71fb04c 100644
> --- a/virt/kvm/arm/arch_timer.c
> +++ b/virt/kvm/arm/arch_timer.c
> @@ -34,6 +34,8 @@ static struct timecounter *timecounter;
>  static struct workqueue_struct *wqueue;
>  static unsigned int host_vtimer_irq;
>  
> +DEFINE_STATIC_KEY_FALSE(kvm_arch_timer_disabled);
> +
>  void kvm_timer_vcpu_put(struct kvm_vcpu *vcpu)
>  {
>  	vcpu->arch.timer_cpu.active_cleared_last = false;
> @@ -41,6 +43,9 @@ void kvm_timer_vcpu_put(struct kvm_vcpu *vcpu)
>  
>  static cycle_t kvm_phys_timer_read(void)
>  {
> +	if (static_branch_unlikely(&kvm_arch_timer_disabled))
> +		return 0;
> +
>  	return timecounter->cc->read(timecounter->cc);
>  }
>  
> @@ -104,6 +109,9 @@ static u64 kvm_timer_compute_delta(struct kvm_vcpu *vcpu)
>  {
>  	cycle_t cval, now;
>  
> +	if (static_branch_unlikely(&kvm_arch_timer_disabled))
> +		return 0;
> +
>  	cval = vcpu->arch.timer_cpu.cntv_cval;
>  	now = kvm_phys_timer_read() - vcpu->kvm->arch.timer.cntvoff;
>  
> @@ -148,6 +156,9 @@ static bool kvm_timer_irq_can_fire(struct kvm_vcpu *vcpu)
>  {
>  	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
>  
> +	if (static_branch_unlikely(&kvm_arch_timer_disabled))
> +		return false;
> +
>  	return !(timer->cntv_ctl & ARCH_TIMER_CTRL_IT_MASK) &&
>  		(timer->cntv_ctl & ARCH_TIMER_CTRL_ENABLE);
>  }
> diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
> index 2c7f0d5..b92133c 100644
> --- a/virt/kvm/arm/vgic/vgic-init.c
> +++ b/virt/kvm/arm/vgic/vgic-init.c
> @@ -56,6 +56,10 @@ void kvm_vgic_early_init(struct kvm *kvm)
>  
>  void kvm_vgic_vcpu_early_init(struct kvm_vcpu *vcpu)
>  {
> +	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
> +
> +	INIT_LIST_HEAD(&vgic_cpu->ap_list_head);
> +	spin_lock_init(&vgic_cpu->ap_list_lock);
>  }
>  
>  /* CREATION */
> @@ -392,11 +396,6 @@ int kvm_vgic_hyp_init(void)
>  	if (!gic_kvm_info)
>  		return -ENODEV;
>  
> -	if (!gic_kvm_info->maint_irq) {
> -		kvm_err("No vgic maintenance irq\n");
> -		return -ENXIO;
> -	}
> -
>  	switch (gic_kvm_info->type) {
>  	case GIC_V2:
>  		ret = vgic_v2_probe(gic_kvm_info);
