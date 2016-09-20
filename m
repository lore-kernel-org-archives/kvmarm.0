From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH] KVM: arm/arm64: timer: Fix hw sync for user space irqchip
 path
Date: Tue, 20 Sep 2016 18:28:15 +0100
Message-ID: <57E171AF.1080903@arm.com>
References: <1474002971-31434-1-git-send-email-agraf@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1474002971-31434-1-git-send-email-agraf@suse.de>
Sender: kvm-owner@vger.kernel.org
To: Alexander Graf <agraf@suse.de>, kvmarm@lists.cs.columbia.edu
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, stable@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Alex,

On 16/09/16 06:16, Alexander Graf wrote:
> While adding the new vgic implementation, apparently nobody tested
> the non-vgic path where user space controls the vgic, so two functions
> slipped through the cracks that get called in generic code but don't
> check whether hardware support is enabled.
> 
> This patch guards them with proper checks to ensure we only try to
> use vgic data structures if they are available. Without this, I get
> a stack trace:
> 
> [   74.363037] Unable to handle kernel paging request at virtual address ffffffffffffffe8
> [...]
> [   74.929654] [<ffff000008824bcc>] _raw_spin_lock+0x1c/0x58
> [   74.935133] [<ffff0000080b7f20>] kvm_vgic_flush_hwstate+0x88/0x288
> [   74.941406] [<ffff0000080ab0b4>] kvm_arch_vcpu_ioctl_run+0xfc/0x630
> [   74.947766] [<ffff0000080a15bc>] kvm_vcpu_ioctl+0x2f4/0x710
> [   74.953420] [<ffff0000082788a8>] do_vfs_ioctl+0xb0/0x728
> [   74.958807] [<ffff000008278fb4>] SyS_ioctl+0x94/0xa8
> [   74.963844] [<ffff000008083744>] el0_svc_naked+0x38/0x3c
> 
> Fixes: 0919e84c0
> Cc: stable@vger.kernel.org
> Signed-off-by: Alexander Graf <agraf@suse.de>
> ---
>  virt/kvm/arm/vgic/vgic.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
> index e83b7fe..9f312ba 100644
> --- a/virt/kvm/arm/vgic/vgic.c
> +++ b/virt/kvm/arm/vgic/vgic.c
> @@ -645,6 +645,9 @@ next:
>  /* Sync back the hardware VGIC state into our emulation after a guest's run. */
>  void kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu)
>  {
> +	if (!vcpu->kvm->arch.vgic.enabled)
> +		return;
> +
>  	vgic_process_maintenance_interrupt(vcpu);
>  	vgic_fold_lr_state(vcpu);
>  	vgic_prune_ap_list(vcpu);
> @@ -653,6 +656,9 @@ void kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu)
>  /* Flush our emulation state into the GIC hardware before entering the guest. */
>  void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu)
>  {
> +	if (!vcpu->kvm->arch.vgic.enabled)
> +		return;
> +
>  	spin_lock(&vcpu->arch.vgic_cpu.ap_list_lock);
>  	vgic_flush_lr_state(vcpu);
>  	spin_unlock(&vcpu->arch.vgic_cpu.ap_list_lock);
> 

I hate that fix, because it papers over the fact that we have uninitialized
structures all over the shop, and that's not exactly great.

How about the following instead:

diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index c94b90d..0961128 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -472,6 +472,9 @@ static int kvm_vcpu_first_run_init(struct kvm_vcpu *vcpu)
 			return ret;
 	}
 
+	if (unlikely(!irqchip_in_kernel(kvm)))
+		kvm_no_vgic_init(kvm);
+
 	/*
 	 * Enable the arch timers only if we have an in-kernel VGIC
 	 * and it has been properly initialized, since we cannot handle
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index bb46c03..1b70b1e 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -327,4 +327,6 @@ int kvm_send_userspace_msi(struct kvm *kvm, struct kvm_msi *msi);
  */
 int kvm_vgic_setup_default_irq_routing(struct kvm *kvm);
 
+void kvm_no_vgic_init(struct kvm *kvm);
+
 #endif /* __KVM_ARM_VGIC_H */
diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
index 83777c1..7b8f12b 100644
--- a/virt/kvm/arm/vgic/vgic-init.c
+++ b/virt/kvm/arm/vgic/vgic-init.c
@@ -151,9 +151,11 @@ static int kvm_vgic_dist_init(struct kvm *kvm, unsigned int nr_spis)
 	INIT_LIST_HEAD(&dist->lpi_list_head);
 	spin_lock_init(&dist->lpi_list_lock);
 
-	dist->spis = kcalloc(nr_spis, sizeof(struct vgic_irq), GFP_KERNEL);
-	if (!dist->spis)
-		return  -ENOMEM;
+	if (nr_spis) {
+		dist->spis = kcalloc(nr_spis, sizeof(struct vgic_irq), GFP_KERNEL);
+		if (!dist->spis)
+			return  -ENOMEM;
+	}
 
 	/*
 	 * In the following code we do not take the irq struct lock since
@@ -325,6 +327,21 @@ int vgic_lazy_init(struct kvm *kvm)
 	return ret;
 }
 
+void kvm_no_vgic_init(struct kvm *kvm)
+{
+	mutex_lock(&kvm->lock);
+	if (unlikely(!vgic_initialized(kvm))) {
+		struct kvm_vcpu *vcpu;
+		int i;
+
+		kvm_vgic_dist_init(kvm, 0);
+		kvm_for_each_vcpu(i, vcpu, kvm)
+			kvm_vgic_vcpu_init(vcpu);
+		kvm->arch.vgic.initialized = true;
+	}
+	mutex_unlock(&kvm->lock);
+}
+
 /* RESOURCE MAPPING */
 
 /**

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
