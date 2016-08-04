From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 41/55] KVM: arm64: vgic-its: Implement MSI injection in
 ITS emulation
Date: Thu, 4 Aug 2016 12:47:36 +0200
Message-ID: <20160804104736.GA8211@lvm>
References: <1469208552-4155-1-git-send-email-marc.zyngier@arm.com>
 <1469208552-4155-42-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1469208552-4155-42-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>, Andre Przywara <andre.przywara@arm.com>, Eric Auger <eric.auger@redhat.com>, Dan Carpenter <dan.carpenter@oracle.com>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Andre and Marc,

On Fri, Jul 22, 2016 at 06:28:58PM +0100, Marc Zyngier wrote:
> From: Andre Przywara <andre.przywara@arm.com>
> 
> When userland wants to inject an MSI into the guest, it uses the
> KVM_SIGNAL_MSI ioctl, which carries the doorbell address along with
> the payload and the device ID.
> With the help of the KVM IO bus framework we learn the corresponding
> ITS from the doorbell address. We then use our wrapper functions to
> iterate the linked lists and find the proper Interrupt Translation Table
> Entry (ITTE) and thus the corresponding struct vgic_irq to finally set
> the pending bit.
> We also provide the handler for the ITS "INT" command, which allows a
> guest to trigger an MSI via the ITS command queue. Since this one knows
> about the right ITS already, we directly call the MMIO handler function
> without using the kvm_io_bus framework.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
> Tested-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  virt/kvm/arm/vgic/vgic-its.c | 77 ++++++++++++++++++++++++++++++++++++++++++++
>  virt/kvm/arm/vgic/vgic.h     |  6 ++++
>  2 files changed, 83 insertions(+)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
> index 1408c88..d8e8f14 100644
> --- a/virt/kvm/arm/vgic/vgic-its.c
> +++ b/virt/kvm/arm/vgic/vgic-its.c
> @@ -437,6 +437,65 @@ static unsigned long vgic_mmio_read_its_idregs(struct kvm *kvm,
>  	return 0;
>  }
>  
> +/*
> + * Find the target VCPU and the LPI number for a given devid/eventid pair
> + * and make this IRQ pending, possibly injecting it.
> + * Must be called with the its_lock mutex held.
> + */
> +static void vgic_its_trigger_msi(struct kvm *kvm, struct vgic_its *its,
> +				 u32 devid, u32 eventid)
> +{
> +	struct its_itte *itte;
> +
> +	if (!its->enabled)
> +		return;
> +
> +	itte = find_itte(its, devid, eventid);
> +	/* Triggering an unmapped IRQ gets silently dropped. */
> +	if (itte && its_is_collection_mapped(itte->collection)) {
> +		struct kvm_vcpu *vcpu;
> +
> +		vcpu = kvm_get_vcpu(kvm, itte->collection->target_addr);
> +		if (vcpu && vcpu->arch.vgic_cpu.lpis_enabled) {
> +			spin_lock(&itte->irq->irq_lock);
> +			itte->irq->pending = true;
> +			vgic_queue_irq_unlock(kvm, itte->irq);
> +		}
> +	}
> +}
> +
> +/*
> + * Queries the KVM IO bus framework to get the ITS pointer from the given
> + * doorbell address.
> + * We then call vgic_its_trigger_msi() with the decoded data.
> + */
> +int vgic_its_inject_msi(struct kvm *kvm, struct kvm_msi *msi)
> +{
> +	u64 address;
> +	struct kvm_io_device *kvm_io_dev;
> +	struct vgic_io_device *iodev;
> +
> +	if (!vgic_has_its(kvm))
> +		return -ENODEV;
> +
> +	if (!(msi->flags & KVM_MSI_VALID_DEVID))
> +		return -EINVAL;
> +
> +	address = (u64)msi->address_hi << 32 | msi->address_lo;
> +
> +	kvm_io_dev = kvm_io_bus_get_dev(kvm, KVM_MMIO_BUS, address);
> +	if (!kvm_io_dev)
> +		return -ENODEV;
> +
> +	iodev = container_of(kvm_io_dev, struct vgic_io_device, dev);

This container_of bothers me; as far as I can tell, the address we use
to look stuff up on the KVM_MMIO_BUS is purely given by userspace and we
can have other stuff registered on the KVM_MMIO_BUS, which is not
contained in a struct vgic_io_device (eventfd for example).

This smells like something that could be exploited, so if I'm right, we
should plug this for -rc2 in some way.

Thanks,
-Christoffer
