From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v3a] KVM: arm/arm64: pmu: abstract access to number of
 SPIs
Date: Tue, 10 May 2016 16:22:19 +0100
Message-ID: <5731FCAB.9050109@arm.com>
References: <5731AF57.2040707@linaro.org>
 <1462890906-6134-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1462890906-6134-1-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Eric Auger <eric.auger@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 10/05/16 15:35, Andre Przywara wrote:
> Currently the PMU uses a member of the struct vgic_dist directly,
> which not only breaks abstraction, but will fail with the new VGIC.
> Abstract this access in the VGIC header file.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
> Hi Eric, Marc,
> 
> as this if-statement was quite confusing (it wasn't even the negation
> that was wrong), I rewrote it a bit to be more readable.
> This one works now with PPIs (after fixing kvmtool).
> 
> Does that make sense?
> 
> Cheers,
> Andre.
> 
>  include/kvm/arm_vgic.h |  2 ++
>  virt/kvm/arm/pmu.c     | 19 +++++++++++--------
>  2 files changed, 13 insertions(+), 8 deletions(-)
> 
> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
> index 6a98e05..d406f8e 100644
> --- a/include/kvm/arm_vgic.h
> +++ b/include/kvm/arm_vgic.h
> @@ -351,6 +351,8 @@ bool kvm_vgic_map_is_active(struct kvm_vcpu *vcpu, unsigned int virt_irq);
>  #define irqchip_in_kernel(k)	(!!((k)->arch.vgic.in_kernel))
>  #define vgic_initialized(k)	(!!((k)->arch.vgic.nr_cpus))
>  #define vgic_ready(k)		((k)->arch.vgic.ready)
> +#define vgic_valid_spi(k, i)	(((i) >= VGIC_NR_PRIVATE_IRQS) && \
> +				 ((i) < (k)->arch.vgic.nr_irqs))
>  
>  int vgic_v2_probe(struct device_node *vgic_node,
>  		  const struct vgic_ops **ops,
> diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
> index 575c7aa..6ab9d6b 100644
> --- a/virt/kvm/arm/pmu.c
> +++ b/virt/kvm/arm/pmu.c
> @@ -436,6 +436,11 @@ static int kvm_arm_pmu_v3_init(struct kvm_vcpu *vcpu)
>  	return 0;
>  }
>  
> +/*
> + * For one VM the interrupt type must be same for each vcpu.
> + * As a PPI, the interrupt number is the same for all vcpus,
> + * while as an SPI it must be a separate number per vcpu.
> + */
>  static bool irq_is_valid(struct kvm *kvm, int irq, bool is_ppi)
>  {
>  	int i;
> @@ -457,6 +462,7 @@ static bool irq_is_valid(struct kvm *kvm, int irq, bool is_ppi)
>  	return true;
>  }
>  
> +#define irq_is_ppi(irq) ((irq) >= VGIC_NR_SGIS && (irq) < VGIC_NR_PRIVATE_IRQS)

You might as well move this to the VGIC code.

>  
>  int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
>  {
> @@ -471,14 +477,11 @@ int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
>  		if (get_user(irq, uaddr))
>  			return -EFAULT;
>  
> -		/*
> -		 * The PMU overflow interrupt could be a PPI or SPI, but for one
> -		 * VM the interrupt type must be same for each vcpu. As a PPI,
> -		 * the interrupt number is the same for all vcpus, while as an
> -		 * SPI it must be a separate number per vcpu.
> -		 */
> -		if (irq < VGIC_NR_SGIS || irq >= vcpu->kvm->arch.vgic.nr_irqs ||
> -		    !irq_is_valid(vcpu->kvm, irq, irq < VGIC_NR_PRIVATE_IRQS))
> +		/* The PMU overflow interrupt can be a PPI or a valid SPI. */
> +		if (!(irq_is_ppi(irq) || vgic_valid_spi(vcpu->kvm, irq)))
> +			return -EINVAL;
> +
> +		if (!irq_is_valid(vcpu->kvm, irq, irq < VGIC_NR_PRIVATE_IRQS))

Why do we need to pass this boolean as a parameter? You could rewrite
irq_is_valid() to generate the is_ppi boolean by itself.

>  			return -EINVAL;
>  
>  		if (kvm_arm_pmu_irq_initialized(vcpu))
> 

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
