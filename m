From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [RFC v6 6/6] KVM: arm: enable KVM_SIGNAL_MSI and MSI routing
Date: Mon, 11 Jul 2016 17:26:32 +0100
Message-ID: <5010e7f6-a915-8c88-251e-b7c426f68d98@arm.com>
References: <1467794875-5237-1-git-send-email-eric.auger@redhat.com>
 <1467794875-5237-7-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5F51349B7D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Jul 2016 12:19:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KLQ9kMFgj52X for <kvmarm@lists.cs.columbia.edu>;
 Mon, 11 Jul 2016 12:19:56 -0400 (EDT)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5D68349B7B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Jul 2016 12:19:56 -0400 (EDT)
In-Reply-To: <1467794875-5237-7-git-send-email-eric.auger@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Eric Auger <eric.auger@redhat.com>, eric.auger.pro@gmail.com, marc.zyngier@arm.com, christoffer.dall@linaro.org, drjones@redhat.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On 06/07/16 09:47, Eric Auger wrote:
> If the ITS modality is not available, let's simply support MSI
> injection by transforming the MSI.data into an SPI ID.
> 
> This becomes possible to use KVM_SIGNAL_MSI ioctl and MSI
> routing for arm too.
> 
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> 
> ---
> 
> v4 -> v5:
> - on vgic_v2m_inject_msi check the msi->data is within the SPI range
> - move KVM_HAVE_MSI in the KVM section (to be symetrical with ARM64)
> 
> v2 -> v3:
> - reword the commit message
> - add sanity check about devid provision
> 
> v1 -> v2:
> - introduce vgic_v2m_inject_msi in vgic-v2-emul.c following Andre's
>   advice
> ---
>  arch/arm/kvm/Kconfig           |  1 +
>  virt/kvm/arm/vgic/vgic-irqfd.c |  2 +-
>  virt/kvm/arm/vgic/vgic-v2.c    | 17 +++++++++++++++++
>  virt/kvm/arm/vgic/vgic.h       |  1 +
>  4 files changed, 20 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm/kvm/Kconfig b/arch/arm/kvm/Kconfig
> index 3e1cd04..90d0176 100644
> --- a/arch/arm/kvm/Kconfig
> +++ b/arch/arm/kvm/Kconfig
> @@ -34,6 +34,7 @@ config KVM
>  	select HAVE_KVM_IRQFD
>  	select HAVE_KVM_IRQCHIP
>  	select HAVE_KVM_IRQ_ROUTING
> +	select HAVE_KVM_MSI
>  	depends on ARM_VIRT_EXT && ARM_LPAE && ARM_ARCH_TIMER
>  	---help---
>  	  Support hosting virtualized guest machines.
> diff --git a/virt/kvm/arm/vgic/vgic-irqfd.c b/virt/kvm/arm/vgic/vgic-irqfd.c
> index 5d9ed39..6612209 100644
> --- a/virt/kvm/arm/vgic/vgic-irqfd.c
> +++ b/virt/kvm/arm/vgic/vgic-irqfd.c
> @@ -98,7 +98,7 @@ int kvm_set_msi(struct kvm_kernel_irq_routing_entry *e,
>  	msi.devid = e->devid;
>  
>  	if (!vgic_has_its(kvm))
> -		return -ENODEV;
> +		return vgic_v2m_inject_msi(kvm, &msi);
>  
>  	return vgic_its_inject_msi(kvm, &msi);
>  }
> diff --git a/virt/kvm/arm/vgic/vgic-v2.c b/virt/kvm/arm/vgic/vgic-v2.c
> index 0bf6709..88e77db 100644
> --- a/virt/kvm/arm/vgic/vgic-v2.c
> +++ b/virt/kvm/arm/vgic/vgic-v2.c
> @@ -241,6 +241,23 @@ static bool vgic_v2_check_base(gpa_t dist_base, gpa_t cpu_base)
>  	return false;
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
> +	if (!vgic_valid_spi(kvm, msi->data))
> +		return -EINVAL;
> +
> +	return kvm_vgic_inject_irq(kvm, 0, msi->data, 1);
> +}
> +

Is that the right file to live in?
If I got this right, then vgic-v2.c contains functions specific to a
GICv2 host, whereas this function is connected to the GICv2 _emulation_,
which would work as well on top of a GICv3 host.
So can you move this to either vgic.c or vgic-irqfd.c?

>  int vgic_v2_map_resources(struct kvm *kvm)
>  {
>  	struct vgic_dist *dist = &kvm->arch.vgic;
> diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
> index b3e5678..223e946 100644
> --- a/virt/kvm/arm/vgic/vgic.h
> +++ b/virt/kvm/arm/vgic/vgic.h
> @@ -64,6 +64,7 @@ int vgic_v2_probe(const struct gic_kvm_info *info);
>  int vgic_v2_map_resources(struct kvm *kvm);
>  int vgic_register_dist_iodev(struct kvm *kvm, gpa_t dist_base_address,
>  			     enum vgic_type);
> +int vgic_v2m_inject_msi(struct kvm *kvm, struct kvm_msi *msi);

If you would move this to vgic-irqfd.c, you could avoid this prototype here.

Cheers,
Andre.

>  
>  #ifdef CONFIG_KVM_ARM_VGIC_V3
>  void vgic_v3_process_maintenance(struct kvm_vcpu *vcpu);
> 
