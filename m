From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH 7/7] KVM: arm: implement kvm_set_msi by gsi direct mapping
Date: Thu, 2 Jul 2015 18:10:04 +0100
Message-ID: <5595706C.9010108@arm.com>
References: <1435592237-17924-1-git-send-email-eric.auger@linaro.org>
 <1435592237-17924-8-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 03363577F2
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jul 2015 12:58:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 03qzsgWWxvfo for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Jul 2015 12:58:49 -0400 (EDT)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F10A0577E7
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jul 2015 12:58:48 -0400 (EDT)
In-Reply-To: <1435592237-17924-8-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Eric Auger <eric.auger@linaro.org>, "eric.auger@st.com" <eric.auger@st.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <Marc.Zyngier@arm.com>, "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Cc: "pbonzini@redhat.com" <pbonzini@redhat.com>, "p.fedin@samsung.com" <p.fedin@samsung.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Eric,

On 29/06/15 16:37, Eric Auger wrote:
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

If you add:

static int vgic_v2m_inject_msi(struct kvm *kvm, struct kvm_msi *msi)
{
	return kvm_vgic_inject_irq(kvm, 0, msi->data, 1);
}

to vgic-v2-emul.c and wire it up accordingly, you can simplify the above
kvm_set_msi, getting rid of all those extra case handling.
This also helps merging KVM_IRQ_ROUTING_MSI and the extended case.

I have hacked this up and it seems to work for me.

Cheers,
Andre.
