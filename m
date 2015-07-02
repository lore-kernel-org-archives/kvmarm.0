From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: [PATCH 7/7] KVM: arm: implement kvm_set_msi by gsi direct mapping
Date: Thu, 02 Jul 2015 10:53:01 +0300
Message-ID: <015501d0b49c$1f1349c0$5d39dd40$@samsung.com>
References: <1435592237-17924-1-git-send-email-eric.auger@linaro.org>
 <1435592237-17924-8-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-reply-to: <1435592237-17924-8-git-send-email-eric.auger@linaro.org>
Content-language: ru
Sender: kvm-owner@vger.kernel.org
To: 'Eric Auger' <eric.auger@linaro.org>, eric.auger@st.com, linux-arm-kernel@lists.infradead.org, marc.zyngier@arm.com, christoffer.dall@linaro.org, andre.przywara@arm.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, patches@linaro.org, pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

 Hello!

> -----Original Message-----
> From: kvm-owner@vger.kernel.org [mailto:kvm-owner@vger.kernel.org] On Behalf Of Eric Auger
> Sent: Monday, June 29, 2015 6:37 PM
> To: eric.auger@st.com; eric.auger@linaro.org; linux-arm-kernel@lists.infradead.org;
> marc.zyngier@arm.com; christoffer.dall@linaro.org; andre.przywara@arm.com;
> kvmarm@lists.cs.columbia.edu; kvm@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org; patches@linaro.org; p.fedin@samsung.com; pbonzini@redhat.com
> Subject: [PATCH 7/7] KVM: arm: implement kvm_set_msi by gsi direct mapping
> 
> If the ITS modality is not available, let's simply support MSI
> injection by transforming the MSI.data into an SPI ID.
> 
> This becomes possible to use KVM_SIGNAL_MSI ioctl for arm too.
> 
> Signed-off-by: Eric Auger <eric.auger@linaro.org>
> ---
>  arch/arm/kvm/Kconfig | 1 +
>  virt/kvm/arm/vgic.c  | 5 +++++
>  2 files changed, 6 insertions(+)
> 
> diff --git a/arch/arm/kvm/Kconfig b/arch/arm/kvm/Kconfig
> index 151e710..0f58baf 100644
> --- a/arch/arm/kvm/Kconfig
> +++ b/arch/arm/kvm/Kconfig
> @@ -31,6 +31,7 @@ config KVM
>  	select KVM_VFIO
>  	select HAVE_KVM_EVENTFD
>  	select HAVE_KVM_IRQFD
> +	select HAVE_KVM_MSI
>  	select HAVE_KVM_IRQCHIP
>  	select HAVE_KVM_IRQ_ROUTING
>  	depends on ARM_VIRT_EXT && ARM_LPAE && ARM_ARCH_TIMER
> diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
> index 0b4c48c..b3c10dc 100644
> --- a/virt/kvm/arm/vgic.c
> +++ b/virt/kvm/arm/vgic.c
> @@ -2314,6 +2314,11 @@ int kvm_set_msi(struct kvm_kernel_irq_routing_entry *e,
>  			return kvm->arch.vgic.vm_ops.inject_msi(kvm, &msi);
>  		else
>  			return -ENODEV;
> +	case KVM_IRQ_ROUTING_MSI:
> +		if (kvm->arch.vgic.vm_ops.inject_msi)
> +			return -EINVAL;
> +		else
> +			return kvm_vgic_inject_irq(kvm, 0, e->msi.data, level);

 Given API change i suggest (using KVM_MSI_VALID_DEVID flag), we could get rid of all these if()'s
here. Just forward all parameters to vGIC implementation code and let it do its checks.

>  	default:
>  		return -EINVAL;
>  	}
> --
> 1.9.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia


