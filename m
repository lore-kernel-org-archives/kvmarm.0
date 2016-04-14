From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v4 7/7] KVM: arm: enable KVM_SIGNAL_MSI and MSI routing
Date: Thu, 14 Apr 2016 14:12:16 +0200
Message-ID: <20160414121216.GH30804@cbox>
References: <1459759657-7402-1-git-send-email-eric.auger@linaro.org>
 <1459759657-7402-8-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1459759657-7402-8-git-send-email-eric.auger@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Eric Auger <eric.auger@linaro.org>
Cc: eric.auger@st.com, marc.zyngier@arm.com, andre.przywara@arm.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, patches@linaro.org, pbonzini@redhat.com, p.fedin@samsung.com, Manish.Jaggi@caviumnetworks.com
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Apr 04, 2016 at 10:47:37AM +0200, Eric Auger wrote:
> If the ITS modality is not available, let's simply support MSI
> injection by transforming the MSI.data into an SPI ID.
> 
> This becomes possible to use KVM_SIGNAL_MSI ioctl and MSI
> routing for arm too.
> 
> Signed-off-by: Eric Auger <eric.auger@linaro.org>
> 
> ---
> 
> v2 -> v3:
> - reword the commit message
> - add sanity check about devid provision
> 
> v1 -> v2:
> - introduce vgic_v2m_inject_msi in vgic-v2-emul.c following Andre's
>   advice
> 
> Conflicts:
> 	arch/arm/kvm/Kconfig
> 
> Conflicts:
> 	arch/arm/kvm/Kconfig
> ---
>  arch/arm/kvm/Kconfig           |  1 +
>  virt/kvm/arm/vgic/vgic-v2.c    | 15 +++++++++++++++
>  virt/kvm/arm/vgic/vgic.h       |  1 +
>  virt/kvm/arm/vgic/vgic_irqfd.c |  2 +-
>  4 files changed, 18 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm/kvm/Kconfig b/arch/arm/kvm/Kconfig
> index 92c3aec..67019e5 100644
> --- a/arch/arm/kvm/Kconfig
> +++ b/arch/arm/kvm/Kconfig
> @@ -50,6 +50,7 @@ config KVM_NEW_VGIC
>  	bool "New VGIC implementation"
>  	depends on KVM
>  	default y
> +	select HAVE_KVM_MSI
>  	select HAVE_KVM_IRQCHIP
>  	select HAVE_KVM_IRQ_ROUTING
>  	---help---
> diff --git a/virt/kvm/arm/vgic/vgic-v2.c b/virt/kvm/arm/vgic/vgic-v2.c
> index 5f7c289..7400af0 100644
> --- a/virt/kvm/arm/vgic/vgic-v2.c
> +++ b/virt/kvm/arm/vgic/vgic-v2.c
> @@ -248,6 +248,21 @@ void vgic_v2_enable(struct kvm_vcpu *vcpu)
>  	vcpu->arch.vgic_cpu.vgic_v2.vgic_hcr = GICH_HCR_EN;
>  }
>  
> +/**
> + * vgic_v2m_inject_msi: emulates GICv2M MSI injection by injecting
> + * the SPI ID matching the msi data
> + *
> + * @kvm: pointer to the kvm struct
> + * @msi: the msi struct handle
> + */
> +int vgic_v2m_inject_msi(struct kvm *kvm, struct kvm_msi *msi)
> +{
> +	if (msi->flags & KVM_MSI_VALID_DEVID)
> +		return -EINVAL;
> +
> +	return kvm_vgic_inject_irq(kvm, 0, msi->data, 1);

I think you need to validate the msi->data here, otherwise
vgic_get_irq() is going to raise warnings etc.

> +}
> +
>  int vgic_v2_map_resources(struct kvm *kvm)
>  {
>  	struct vgic_dist *dist = &kvm->arch.vgic;
> diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
> index 223c778..354a865 100644
> --- a/virt/kvm/arm/vgic/vgic.h
> +++ b/virt/kvm/arm/vgic/vgic.h
> @@ -44,6 +44,7 @@ int vgic_v2_probe(struct device_node *vgic_node);
>  int vgic_v2_map_resources(struct kvm *kvm);
>  int vgic_register_dist_regions(struct kvm *kvm, gpa_t dist_base_address,
>  			       enum vgic_type);
> +int vgic_v2m_inject_msi(struct kvm *kvm, struct kvm_msi *msi);
>  
>  #ifdef CONFIG_KVM_ARM_VGIC_V3
>  void vgic_v3_irq_change_affinity(struct kvm *kvm, u32 intid, u64 mpidr);
> diff --git a/virt/kvm/arm/vgic/vgic_irqfd.c b/virt/kvm/arm/vgic/vgic_irqfd.c
> index a3a7f02..588cdd6 100644
> --- a/virt/kvm/arm/vgic/vgic_irqfd.c
> +++ b/virt/kvm/arm/vgic/vgic_irqfd.c
> @@ -100,7 +100,7 @@ int kvm_set_msi(struct kvm_kernel_irq_routing_entry *e,
>  	msi.devid = e->devid;
>  
>  	if (!vgic_has_its(kvm))
> -		return -ENODEV;
> +		return vgic_v2m_inject_msi(kvm, &msi);
>  
>  	return vits_inject_msi(kvm, &msi);
>  }
> -- 
> 1.9.1
> 
