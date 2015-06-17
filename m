From: Eric Auger <eric.auger@linaro.org>
Subject: Re: [PATCH 08/10] KVM: arm/arm64: vgic: Add vgic_{get,set}_phys_irq_active
Date: Wed, 17 Jun 2015 17:11:29 +0200
Message-ID: <55818E21.4030707@linaro.org>
References: <1433783045-8002-1-git-send-email-marc.zyngier@arm.com> <1433783045-8002-9-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1433783045-8002-9-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Christoffer Dall <christoffer.dall@linaro.org>, =?windows-1252?Q?Alex?= =?windows-1252?Q?_Benn=E9e?= <alex.bennee@linaro.org>, Andre Przywara <andre.przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Reviewed-by: Eric Auger <eric.auger@linaro.org>
On 06/08/2015 07:04 PM, Marc Zyngier wrote:
> In order to control the active state of an interrupt, introduce
> a pair of accessors allowing the state to be set/queried.
> 
> This only affects the logical state, and the HW state will only be
> applied at world-switch time.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  include/kvm/arm_vgic.h |  2 ++
>  virt/kvm/arm/vgic.c    | 12 ++++++++++++
>  2 files changed, 14 insertions(+)
> 
> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
> index 33d121a..1c653c1 100644
> --- a/include/kvm/arm_vgic.h
> +++ b/include/kvm/arm_vgic.h
> @@ -349,6 +349,8 @@ int kvm_vgic_vcpu_active_irq(struct kvm_vcpu *vcpu);
>  struct irq_phys_map *vgic_map_phys_irq(struct kvm_vcpu *vcpu,
>  				       int virt_irq, int irq);
>  int vgic_unmap_phys_irq(struct kvm_vcpu *vcpu, struct irq_phys_map *map);
> +bool vgic_get_phys_irq_active(struct irq_phys_map *map);
> +void vgic_set_phys_irq_active(struct irq_phys_map *map, bool active);
>  
>  #define irqchip_in_kernel(k)	(!!((k)->arch.vgic.in_kernel))
>  #define vgic_initialized(k)	(!!((k)->arch.vgic.nr_cpus))
> diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
> index 495ac7d..f376b56 100644
> --- a/virt/kvm/arm/vgic.c
> +++ b/virt/kvm/arm/vgic.c
> @@ -1744,6 +1744,18 @@ static struct irq_phys_map *vgic_irq_map_search(struct kvm_vcpu *vcpu,
>  	return this;
>  }
>  
> +bool vgic_get_phys_irq_active(struct irq_phys_map *map)
> +{
> +	BUG_ON(!map);
> +	return map->active;
> +}
> +
> +void vgic_set_phys_irq_active(struct irq_phys_map *map, bool active)
> +{
> +	BUG_ON(!map);
> +	map->active = active;
> +}
> +
>  int vgic_unmap_phys_irq(struct kvm_vcpu *vcpu, struct irq_phys_map *map)
>  {
>  	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
> 

