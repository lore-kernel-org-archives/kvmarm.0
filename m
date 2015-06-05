From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH] kvmtool: don't use PCI config space IRQ line field
Date: Fri, 5 Jun 2015 17:41:58 +0100
Message-ID: <20150605164158.GL7420@arm.com>
References: <1433431245-23227-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1433431245-23227-1-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>
Cc: "penberg@kernel.org" <penberg@kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Jun 04, 2015 at 04:20:45PM +0100, Andre Przywara wrote:
> In PCI config space there is an interrupt line field (offset 0x3f),
> which is used to initially communicate the IRQ line number from
> firmware to the OS. _Hardware_ should never use this information,
> as the OS is free to write any information in there.
> But kvmtool uses this number when it triggers IRQs in the guest,
> which fails starting with Linux 3.19-rc1, where the PCI layer starts
> writing the virtual IRQ number in there.
> 
> Fix that by storing the IRQ number in a separate field in
> struct virtio_pci, which is independent from the PCI config space
> and cannot be influenced by the guest.
> This fixes ARM/ARM64 guests using PCI with newer kernels.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  include/kvm/virtio-pci.h | 8 ++++++++
>  virtio/pci.c             | 9 ++++++---
>  2 files changed, 14 insertions(+), 3 deletions(-)
> 
> diff --git a/include/kvm/virtio-pci.h b/include/kvm/virtio-pci.h
> index c795ce7..b70cadd 100644
> --- a/include/kvm/virtio-pci.h
> +++ b/include/kvm/virtio-pci.h
> @@ -30,6 +30,14 @@ struct virtio_pci {
>  	u8			isr;
>  	u32			features;
>  
> +	/*
> +	 * We cannot rely on the INTERRUPT_LINE byte in the config space once
> +	 * we have run guest code, as the OS is allowed to use that field
> +	 * as a scratch pad to communicate between driver and PCI layer.
> +	 * So store our legacy interrupt line number in here for internal use.
> +	 */
> +	u8			legacy_irq_line;
> +
>  	/* MSI-X */
>  	u16			config_vector;
>  	u32			config_gsi;
> diff --git a/virtio/pci.c b/virtio/pci.c
> index 7556239..e17e5a9 100644
> --- a/virtio/pci.c
> +++ b/virtio/pci.c
> @@ -141,7 +141,7 @@ static bool virtio_pci__io_in(struct ioport *ioport, struct kvm_cpu *vcpu, u16 p
>  		break;
>  	case VIRTIO_PCI_ISR:
>  		ioport__write8(data, vpci->isr);
> -		kvm__irq_line(kvm, vpci->pci_hdr.irq_line, VIRTIO_IRQ_LOW);
> +		kvm__irq_line(kvm, vpci->legacy_irq_line, VIRTIO_IRQ_LOW);
>  		vpci->isr = VIRTIO_IRQ_LOW;
>  		break;
>  	default:
> @@ -299,7 +299,7 @@ int virtio_pci__signal_vq(struct kvm *kvm, struct virtio_device *vdev, u32 vq)
>  			kvm__irq_trigger(kvm, vpci->gsis[vq]);
>  	} else {
>  		vpci->isr = VIRTIO_IRQ_HIGH;
> -		kvm__irq_trigger(kvm, vpci->pci_hdr.irq_line);
> +		kvm__irq_trigger(kvm, vpci->legacy_irq_line);
>  	}
>  	return 0;
>  }
> @@ -323,7 +323,7 @@ int virtio_pci__signal_config(struct kvm *kvm, struct virtio_device *vdev)
>  			kvm__irq_trigger(kvm, vpci->config_gsi);
>  	} else {
>  		vpci->isr = VIRTIO_PCI_ISR_CONFIG;
> -		kvm__irq_trigger(kvm, vpci->pci_hdr.irq_line);
> +		kvm__irq_trigger(kvm, vpci->legacy_irq_line);
>  	}
>  
>  	return 0;
> @@ -422,6 +422,9 @@ int virtio_pci__init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
>  	if (r < 0)
>  		goto free_msix_mmio;
>  
> +	/* save the IRQ that device__register() has allocated */
> +	vpci->legacy_irq_line = vpci->pci_hdr.irq_line;

I'd rather we used the container_of trick that we do for virtio-mmio
devices when assigning the irq in device__register. Then we can avoid
this line completely.

Will
