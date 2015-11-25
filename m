From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: [PATCH v3 15/16] KVM: arm64: implement MSI injection in ITS
 emulation
Date: Wed, 25 Nov 2015 16:28:05 +0300
Message-ID: <011c01d12785$1e808d90$5b81a8b0$@samsung.com>
References: <1444229726-31559-1-git-send-email-andre.przywara@arm.com>
 <1444229726-31559-16-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 86DAA412D6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Nov 2015 08:27:09 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XYLXgJNMYN-A for <kvmarm@lists.cs.columbia.edu>;
 Wed, 25 Nov 2015 08:27:07 -0500 (EST)
Received: from mailout3.w1.samsung.com (mailout3.w1.samsung.com
 [210.118.77.13])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 78B41411AA
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Nov 2015 08:27:06 -0500 (EST)
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NYD00F9HHEU0800@mailout3.w1.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Wed, 25 Nov 2015 13:28:07 +0000 (GMT)
In-reply-to: <1444229726-31559-16-git-send-email-andre.przywara@arm.com>
Content-language: ru
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: 'Andre Przywara' <andre.przywara@arm.com>, marc.zyngier@arm.com, christoffer.dall@linaro.org
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

 Hello!

 I have discovered one more issue, and it is major one. It gets triggered by VFIO. See inline.

 P.S. What is the overall current status? Long time has passed since the last email...

> -----Original Message-----
> From: kvm-owner@vger.kernel.org [mailto:kvm-owner@vger.kernel.org] On Behalf Of Andre Przywara
> Sent: Wednesday, October 07, 2015 5:55 PM
> To: marc.zyngier@arm.com; christoffer.dall@linaro.org
> Cc: eric.auger@linaro.org; p.fedin@samsung.com; kvmarm@lists.cs.columbia.edu; linux-arm-
> kernel@lists.infradead.org; kvm@vger.kernel.org
> Subject: [PATCH v3 15/16] KVM: arm64: implement MSI injection in ITS emulation
> 
> When userland wants to inject a MSI into the guest, we have to use
> our data structures to find the LPI number and the VCPU to receive
> the interrupt.
> Use the wrapper functions to iterate the linked lists and find the
> proper Interrupt Translation Table Entry. Then set the pending bit
> in this ITTE to be later picked up by the LR handling code. Kick
> the VCPU which is meant to handle this interrupt.
> We provide a VGIC emulation model specific routine for the actual
> MSI injection. The wrapper functions return an error for models not
> (yet) implementing MSIs (like the GICv2 emulation).
> We also provide the handler for the ITS "INT" command, which allows a
> guest to trigger an MSI via the ITS command queue.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
> Changelog v2..v3:
> - proper checking for unmapped collections
> 
>  include/kvm/arm_vgic.h      |  1 +
>  virt/kvm/arm/its-emul.c     | 65 +++++++++++++++++++++++++++++++++++++++++++++
>  virt/kvm/arm/its-emul.h     |  2 ++
>  virt/kvm/arm/vgic-v3-emul.c |  1 +
>  4 files changed, 69 insertions(+)
> 
> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
> index 4ea023c..7911059 100644
> --- a/include/kvm/arm_vgic.h
> +++ b/include/kvm/arm_vgic.h
> @@ -149,6 +149,7 @@ struct vgic_vm_ops {
>  	int	(*map_resources)(struct kvm *, const struct vgic_params *);
>  	bool	(*queue_lpis)(struct kvm_vcpu *);
>  	void	(*unqueue_lpi)(struct kvm_vcpu *, int irq);
> +	int	(*inject_msi)(struct kvm *, struct kvm_msi *);
>  };
> 
>  struct vgic_io_device {
> diff --git a/virt/kvm/arm/its-emul.c b/virt/kvm/arm/its-emul.c
> index 642effb..cd8526a 100644
> --- a/virt/kvm/arm/its-emul.c
> +++ b/virt/kvm/arm/its-emul.c
> @@ -333,6 +333,55 @@ static bool handle_mmio_gits_idregs(struct kvm_vcpu *vcpu,
>  }
> 
>  /*
> + * Translates an incoming MSI request into the redistributor (=VCPU) and
> + * the associated LPI number. Sets the LPI pending bit and also marks the
> + * VCPU as having a pending interrupt.
> + */
> +int vits_inject_msi(struct kvm *kvm, struct kvm_msi *msi)
> +{
> +	struct vgic_dist *dist = &kvm->arch.vgic;
> +	struct vgic_its *its = &dist->its;
> +	struct its_itte *itte;
> +	int cpuid;
> +	bool inject = false;
> +	int ret = 0;
> +
> +	if (!vgic_has_its(kvm))
> +		return -ENODEV;
> +
> +	if (!(msi->flags & KVM_MSI_VALID_DEVID))
> +		return -EINVAL;
> +
> +	spin_lock(&its->lock);
> +
> +	if (!its->enabled || !dist->lpis_enabled) {
> +		ret = -EAGAIN;
> +		goto out_unlock;
> +	}
> +
> +	itte = find_itte(kvm, msi->devid, msi->data);
> +	/* Triggering an unmapped IRQ gets silently dropped. */
> +	if (!itte || !its_is_collection_mapped(itte->collection))
> +		goto out_unlock;
> +
> +	cpuid = itte->collection->target_addr;
> +	__set_bit(cpuid, itte->pending);
> +	inject = itte->enabled;
> +
> +out_unlock:
> +	spin_unlock(&its->lock);
> +
> +	if (inject) {
> +		spin_lock(&dist->lock);

 At this point there can be a deadlock, because dist->lock is taken from within many places in KVM. If we are forwarding VFIO IRQ
using IRQFDs, then irqfd_wakeup() will directly call kvm_set_msi(), which ends up here. But, interrupts from VFIO devices can happen
at any moments, including those when dist->lock is taken by KVM status update code.
 Currently i added a simple workaround by disabling MSI fast path for KVM_ARM_HOST, but i believe it's not good solution. But can we
do it better?
 OTOH, i know, direct IRQ forwarding is on the way.

> +		__set_bit(cpuid, dist->irq_pending_on_cpu);
> +		spin_unlock(&dist->lock);
> +		kvm_vcpu_kick(kvm_get_vcpu(kvm, cpuid));
> +	}
> +
> +	return ret;
> +}
> +
> +/*
>   * Find all enabled and pending LPIs and queue them into the list
>   * registers.
>   * The dist lock is held by the caller.
> @@ -812,6 +861,19 @@ static int vits_cmd_handle_movall(struct kvm *kvm, u64 *its_cmd)
>  	return 0;
>  }
> 
> +/* The INT command injects the LPI associated with that DevID/EvID pair. */
> +static int vits_cmd_handle_int(struct kvm *kvm, u64 *its_cmd)
> +{
> +	struct kvm_msi msi = {
> +		.data = its_cmd_get_id(its_cmd),
> +		.devid = its_cmd_get_deviceid(its_cmd),
> +		.flags = KVM_MSI_VALID_DEVID,
> +	};
> +
> +	vits_inject_msi(kvm, &msi);
> +	return 0;
> +}
> +
>  /*
>   * This function is called with both the ITS and the distributor lock dropped,
>   * so the actual command handlers must take the respective locks when needed.
> @@ -846,6 +908,9 @@ static int vits_handle_command(struct kvm_vcpu *vcpu, u64 *its_cmd)
>  	case GITS_CMD_MOVALL:
>  		ret = vits_cmd_handle_movall(vcpu->kvm, its_cmd);
>  		break;
> +	case GITS_CMD_INT:
> +		ret = vits_cmd_handle_int(vcpu->kvm, its_cmd);
> +		break;
>  	case GITS_CMD_INV:
>  		ret = vits_cmd_handle_inv(vcpu->kvm, its_cmd);
>  		break;
> diff --git a/virt/kvm/arm/its-emul.h b/virt/kvm/arm/its-emul.h
> index 830524a..95e56a7 100644
> --- a/virt/kvm/arm/its-emul.h
> +++ b/virt/kvm/arm/its-emul.h
> @@ -36,6 +36,8 @@ void vgic_enable_lpis(struct kvm_vcpu *vcpu);
>  int vits_init(struct kvm *kvm);
>  void vits_destroy(struct kvm *kvm);
> 
> +int vits_inject_msi(struct kvm *kvm, struct kvm_msi *msi);
> +
>  bool vits_queue_lpis(struct kvm_vcpu *vcpu);
>  void vits_unqueue_lpi(struct kvm_vcpu *vcpu, int irq);
> 
> diff --git a/virt/kvm/arm/vgic-v3-emul.c b/virt/kvm/arm/vgic-v3-emul.c
> index f482e34..90f3628 100644
> --- a/virt/kvm/arm/vgic-v3-emul.c
> +++ b/virt/kvm/arm/vgic-v3-emul.c
> @@ -944,6 +944,7 @@ void vgic_v3_init_emulation(struct kvm *kvm)
>  	dist->vm_ops.init_model = vgic_v3_init_model;
>  	dist->vm_ops.destroy_model = vgic_v3_destroy_model;
>  	dist->vm_ops.map_resources = vgic_v3_map_resources;
> +	dist->vm_ops.inject_msi = vits_inject_msi;
>  	dist->vm_ops.queue_lpis = vits_queue_lpis;
>  	dist->vm_ops.unqueue_lpi = vits_unqueue_lpi;
> 
> --
> 2.5.1

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia
