From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [kvmtool PATCH v9 06/15] PCI: Only allocate IRQ routing entry
 when available
Date: Wed, 29 Mar 2017 09:30:23 +0100
Message-ID: <d26dea9f-386b-316c-a2b3-d42ea1883997@arm.com>
References: <20170202163223.15372-1-andre.przywara@arm.com>
 <20170202163223.15372-7-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170202163223.15372-7-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>, Will Deacon <will.deacon@arm.com>
Cc: Vladimir Murzin <vladimir.murzin@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 02/02/17 16:32, Andre Przywara wrote:
> If we need to inject an MSI into the guest, we rely at the moment on a
> working GSI MSI routing functionality. However we can get away without
> IRQ routing, if the host supports MSI injection via the KVM_SIGNAL_MSI
> ioctl.
> So we try the GSI routing first, but if that fails due to a missing
> IRQ routing functionality, we fall back to KVM_SIGNAL_MSI (if that is
> supported).
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  virtio/pci.c | 16 ++++++++++++++--
>  1 file changed, 14 insertions(+), 2 deletions(-)
> 
> diff --git a/virtio/pci.c b/virtio/pci.c
> index 7cc0ba4..98bf6b7 100644
> --- a/virtio/pci.c
> +++ b/virtio/pci.c
> @@ -193,8 +193,14 @@ static bool virtio_pci__specific_io_out(struct kvm *kvm, struct virtio_device *v
>  
>  			gsi = irq__add_msix_route(kvm,
>  						  &vpci->msix_table[vec].msg);
> -			if (gsi >= 0)
> +			if (gsi >= 0) {
>  				vpci->config_gsi = gsi;
> +				break;
> +			}
> +			if (gsi == -ENXIO &&
> +			    vpci->features & VIRTIO_PCI_F_SIGNAL_MSI)
> +					break;
> +			die("failed to configure MSIs");
>  			break;
>  		case VIRTIO_MSI_QUEUE_VECTOR:
>  			vec = ioport__read16(data);
> @@ -205,8 +211,14 @@ static bool virtio_pci__specific_io_out(struct kvm *kvm, struct virtio_device *v
>  
>  			gsi = irq__add_msix_route(kvm,
>  						  &vpci->msix_table[vec].msg);
> -			if (gsi < 0)
> +			if (gsi < 0) {
> +				if (gsi == -ENXIO &&
> +				    vpci->features & VIRTIO_PCI_F_SIGNAL_MSI)
> +					break;
> +
> +				die("failed to configure MSIs");
>  				break;
> +			}
>  			vpci->gsis[vpci->queue_selector] = gsi;

Is it really expected to find -ENXIO in this array instead of a GSI?

>  			if (vdev->ops->notify_vq_gsi)
>  				vdev->ops->notify_vq_gsi(kvm, vpci->dev,
> 

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
