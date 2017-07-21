From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v2 6/8] KVM: arm/arm64: vgic: Implement forwarding setting
Date: Fri, 21 Jul 2017 15:13:46 +0200
Message-ID: <20170721131346.GH16350@cbox>
References: <1497531160-29162-1-git-send-email-eric.auger@redhat.com>
 <1497531160-29162-7-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1497531160-29162-7-git-send-email-eric.auger@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Eric Auger <eric.auger@redhat.com>
Cc: eric.auger.pro@gmail.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, alex.williamson@redhat.com, b.reynal@virtualopensystems.com, pbonzini@redhat.com, marc.zyngier@arm.com, christoffer.dall@linaro.org, drjones@redhat.com, wei@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Jun 15, 2017 at 02:52:38PM +0200, Eric Auger wrote:
> Implements kvm_vgic_[set|unset]_forwarding.
> 
> Handle low-level VGIC programming and consistent irqchip
> programming.
> 
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> 
> ---
> 
> v1 -> v2:
> - change the parameter names used in the declaration
> - use kvm_vgic_map/unmap_phys_irq and handle their returned value
> ---
>  include/kvm/arm_vgic.h   |  5 +++
>  virt/kvm/arm/vgic/vgic.c | 88 ++++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 93 insertions(+)
> 
> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
> index cceb31d..5064a57 100644
> --- a/include/kvm/arm_vgic.h
> +++ b/include/kvm/arm_vgic.h
> @@ -343,4 +343,9 @@ int kvm_send_userspace_msi(struct kvm *kvm, struct kvm_msi *msi);
>   */
>  int kvm_vgic_setup_default_irq_routing(struct kvm *kvm);
>  
> +int kvm_vgic_set_forwarding(struct kvm *kvm, unsigned int host_irq,
> +			    unsigned int vintid);
> +void kvm_vgic_unset_forwarding(struct kvm *kvm, unsigned int host_irq,
> +			       unsigned int vintid);
> +
>  #endif /* __KVM_ARM_VGIC_H */
> diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
> index 2e35ac7..9ee3e77 100644
> --- a/virt/kvm/arm/vgic/vgic.c
> +++ b/virt/kvm/arm/vgic/vgic.c
> @@ -781,3 +781,91 @@ bool kvm_vgic_map_is_active(struct kvm_vcpu *vcpu, unsigned int vintid)
>  	return map_is_active;
>  }
>  
> +/**
> + * kvm_vgic_set_forwarding - Set IRQ forwarding
> + *
> + * @kvm: kvm handle
> + * @host_irq: the host linux IRQ
> + * @vintid: the virtual INTID
> + *
> + * This function must be called when the IRQ is not active:
> + * ie. not active at GIC level and not currently under injection
> + * into the guest using the unforwarded mode. The physical IRQ must
> + * be disabled and all vCPUs must have been exited and prevented
> + * from being re-entered.
> + */
> +int kvm_vgic_set_forwarding(struct kvm *kvm, unsigned int host_irq,
> +			    unsigned int vintid)
> +{
> +	struct kvm_vcpu *vcpu;
> +	struct vgic_irq *irq;
> +	int ret;
> +
> +	kvm_debug("%s host_irq=%d vintid=%d\n", __func__, host_irq, vintid);

do you need to check if the vgic is initialized etc. here?

> +
> +	if (!vgic_valid_spi(kvm, vintid))
> +		return -EINVAL;
> +
> +	irq = vgic_get_irq(kvm, NULL, vintid);
> +	spin_lock(&irq->irq_lock);
> +
> +	if (irq->hw) {
> +		ret = -EINVAL;

is this because it's already forwarded?  How about EBUSY or EEXIST
instead then?

> +		goto unlock;
> +	}
> +	vcpu = irq->target_vcpu;
> +	if (!vcpu) {
> +		ret = -EAGAIN;

what is this case exactly?

> +		goto unlock;
> +	}
> +	
> +	ret = kvm_vgic_map_irq(vcpu, irq, host_irq);
> +	if (!ret)
> +		irq_set_vcpu_affinity(host_irq, vcpu);

so this is essentially map + set_vcpu_affinity.  Why do we want the GIC
to do this in one go as opposed to leaving it up to the caller?

> +unlock:
> +	spin_unlock(&irq->irq_lock);
> +	vgic_put_irq(kvm, irq);
> +	return ret;
> +}
> +
> +/**
> + * kvm_vgic_unset_forwarding - Unset IRQ forwarding
> + *
> + * @kvm: KVM handle
> + * @host_irq: the host Linux IRQ number
> + * @vintid: virtual INTID
> + *
> + * This function must be called when the host irq is disabled and
> + * all vCPUs have been exited and prevented from being re-entered.
> + */
> +void kvm_vgic_unset_forwarding(struct kvm *kvm,
> +			       unsigned int host_irq,
> +			       unsigned int vintid)
> +{
> +	struct vgic_irq *irq;
> +	bool active;
> +
> +	kvm_debug("%s host_irq=%d vintid=%d\n", __func__, host_irq, vintid);

do you need to check if the vgic is initialized etc. here?

> +
> +	if (!vgic_valid_spi(kvm, vintid))
> +		return;
> +
> +	irq = vgic_get_irq(kvm, NULL, vintid);
> +	spin_lock(&irq->irq_lock);
> +
> +	if (!irq->hw)
> +		goto unlock;
> +
> +	WARN_ON(irq_get_irqchip_state(host_irq, IRQCHIP_STATE_ACTIVE, &active));
> +
> +	if (active)
> +		irq_set_irqchip_state(host_irq, IRQCHIP_STATE_ACTIVE, false);
> +
> +	kvm_vgic_unmap_irq(irq);
> +	irq_set_vcpu_affinity(host_irq, NULL);
> +
> +unlock:
> +	spin_unlock(&irq->irq_lock);
> +	vgic_put_irq(kvm, irq);
> +}
> +
> -- 
> 2.5.5
> 

Thanks,
-Christoffer
