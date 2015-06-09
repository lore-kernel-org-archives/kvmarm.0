From: Eric Auger <eric.auger@linaro.org>
Subject: Re: [PATCH 03/13] KVM: arm/arm64: add emulation model specific destroy
 function
Date: Tue, 09 Jun 2015 10:51:30 +0200
Message-ID: <5576A912.8020005@linaro.org>
References: <1432893209-27313-1-git-send-email-andre.przywara@arm.com> <1432893209-27313-4-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1432893209-27313-4-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>, christoffer.dall@linaro.org, marc.zyngier@arm.com
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Reviewed-by: Eric Auger <eric.auger@linaro.org>
On 05/29/2015 11:53 AM, Andre Przywara wrote:
> Currently we destroy the VGIC emulation in one function that cares for
> all emulated models. The ITS emulation will require some
> differentiation, so introduce a per-emulation-model destroy method.
> Use it for a tiny GICv3 specific code already.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  include/kvm/arm_vgic.h      |  1 +
>  virt/kvm/arm/vgic-v3-emul.c |  9 +++++++++
>  virt/kvm/arm/vgic.c         | 11 ++++++++++-
>  3 files changed, 20 insertions(+), 1 deletion(-)
> 
> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
> index 2ccfa9a..b18e2c5 100644
> --- a/include/kvm/arm_vgic.h
> +++ b/include/kvm/arm_vgic.h
> @@ -144,6 +144,7 @@ struct vgic_vm_ops {
>  	bool	(*queue_sgi)(struct kvm_vcpu *, int irq);
>  	void	(*add_sgi_source)(struct kvm_vcpu *, int irq, int source);
>  	int	(*init_model)(struct kvm *);
> +	void	(*destroy_model)(struct kvm *);
>  	int	(*map_resources)(struct kvm *, const struct vgic_params *);
>  };
>  
> diff --git a/virt/kvm/arm/vgic-v3-emul.c b/virt/kvm/arm/vgic-v3-emul.c
> index e9c3a7a..fbfdd6f 100644
> --- a/virt/kvm/arm/vgic-v3-emul.c
> +++ b/virt/kvm/arm/vgic-v3-emul.c
> @@ -818,6 +818,14 @@ static int vgic_v3_init_model(struct kvm *kvm)
>  	return 0;
>  }
>  
> +static void vgic_v3_destroy_model(struct kvm *kvm)
> +{
> +	struct vgic_dist *dist = &kvm->arch.vgic;
> +
> +	kfree(dist->irq_spi_mpidr);
> +	dist->irq_spi_mpidr = NULL;
> +}
> +
>  /* GICv3 does not keep track of SGI sources anymore. */
>  static void vgic_v3_add_sgi_source(struct kvm_vcpu *vcpu, int irq, int source)
>  {
> @@ -830,6 +838,7 @@ void vgic_v3_init_emulation(struct kvm *kvm)
>  	dist->vm_ops.queue_sgi = vgic_v3_queue_sgi;
>  	dist->vm_ops.add_sgi_source = vgic_v3_add_sgi_source;
>  	dist->vm_ops.init_model = vgic_v3_init_model;
> +	dist->vm_ops.destroy_model = vgic_v3_destroy_model;
>  	dist->vm_ops.map_resources = vgic_v3_map_resources;
>  
>  	kvm->arch.max_vcpus = KVM_MAX_VCPUS;
> diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
> index 037b723..6ea30e0 100644
> --- a/virt/kvm/arm/vgic.c
> +++ b/virt/kvm/arm/vgic.c
> @@ -102,6 +102,14 @@ int kvm_vgic_map_resources(struct kvm *kvm)
>  	return kvm->arch.vgic.vm_ops.map_resources(kvm, vgic);
>  }
>  
> +static void vgic_destroy_model(struct kvm *kvm)
> +{
> +	struct vgic_vm_ops *vm_ops = &kvm->arch.vgic.vm_ops;
> +
> +	if (vm_ops->destroy_model)
> +		vm_ops->destroy_model(kvm);
> +}
> +
>  /*
>   * struct vgic_bitmap contains a bitmap made of unsigned longs, but
>   * extracts u32s out of them.
> @@ -1631,6 +1639,8 @@ void kvm_vgic_destroy(struct kvm *kvm)
>  	struct kvm_vcpu *vcpu;
>  	int i;
>  
> +	vgic_destroy_model(kvm);
> +
>  	kvm_for_each_vcpu(i, vcpu, kvm)
>  		kvm_vgic_vcpu_destroy(vcpu);
>  
> @@ -1647,7 +1657,6 @@ void kvm_vgic_destroy(struct kvm *kvm)
>  	}
>  	kfree(dist->irq_sgi_sources);
>  	kfree(dist->irq_spi_cpu);
> -	kfree(dist->irq_spi_mpidr);
>  	kfree(dist->irq_spi_target);
>  	kfree(dist->irq_pending_on_cpu);
>  	kfree(dist->irq_active_on_cpu);
> 

