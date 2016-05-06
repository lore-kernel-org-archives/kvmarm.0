From: Tom Hanson <thomas.hanson@linaro.org>
Subject: Re: [PATCH v3 19/55] KVM: arm/arm64: vgic-new: Add GICv3 world switch
 backend
Date: Fri, 6 May 2016 13:07:21 -0600
Message-ID: <572CEB69.8040009@linaro.org>
References: <1462531568-9799-1-git-send-email-andre.przywara@arm.com>
 <1462531568-9799-20-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1462531568-9799-20-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 05/06/2016 04:45 AM, Andre Przywara wrote:
> From: Marc Zyngier <marc.zyngier@arm.com>
>
> As the GICv3 virtual interface registers differ from their GICv2
> siblings, we need different handlers for processing maintenance
> interrupts and reading/writing to the LRs.
> Implement the respective handler functions and connect them to
> existing code to be called if the host is using a GICv3.
>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
> Changelog RFC..v1:
> - remove outdated comment about the dist_lock
> - add WARN_ON about LR_STATE not being 0 in maintenance interrupts
>
> Changelog v1 .. v2:
> - inject the IRQ priority into the list register
>
> Changelog v2 .. v3:
> - remove no longer needed irqchip/arm-gic.h inclusion
>
>   include/linux/irqchip/arm-gic-v3.h |   1 +
>   virt/kvm/arm/vgic/vgic-v3.c        | 168 +++++++++++++++++++++++++++++++++++++
>   virt/kvm/arm/vgic/vgic.c           |  25 ++++--
>   virt/kvm/arm/vgic/vgic.h           |  29 +++++++
>   4 files changed, 218 insertions(+), 5 deletions(-)
>   create mode 100644 virt/kvm/arm/vgic/vgic-v3.c
>
> diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
> index ec938d1..35e93cf 100644
> --- a/include/linux/irqchip/arm-gic-v3.h
> +++ b/include/linux/irqchip/arm-gic-v3.h
> @@ -275,6 +275,7 @@
>   #define ICH_LR_ACTIVE_BIT		(1ULL << 63)
>   #define ICH_LR_PHYS_ID_SHIFT		32
>   #define ICH_LR_PHYS_ID_MASK		(0x3ffULL << ICH_LR_PHYS_ID_SHIFT)
> +#define ICH_LR_PRIORITY_SHIFT		48
>
>   /* These are for GICv2 emulation only */
>   #define GICH_LR_VIRTUALID		(0x3ffUL << 0)
> diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
> new file mode 100644
> index 0000000..43d1dd7
> --- /dev/null
> +++ b/virt/kvm/arm/vgic/vgic-v3.c

...

> +void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu)
> +{
> +	struct vgic_v3_cpu_if *cpuif = &vcpu->arch.vgic_cpu.vgic_v3;
> +	u32 model = vcpu->kvm->arch.vgic.vgic_model;
> +	int lr;
> +
> +	/* Assumes ap_list_lock held */


If truly required that ap_list_lock already be locked, then the code should enforce it. At least in dev mode. Maybe:
          DEBUG_SPINLOCK_BUG_ON(!spin_is_locked(&vcpu->ap_list_lock));

...

> +/* Requires the irq to be locked already */
> +void vgic_v3_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr)


Similarly, if required then the code should enforce it.
          DEBUG_SPINLOCK_BUG_ON(!spin_is_locked(&irq->irq_lock));

  ...
