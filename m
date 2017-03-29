From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [kvmtool PATCH v9 12/15] PCI: inject PCI device ID on MSI
 injection
Date: Wed, 29 Mar 2017 09:50:03 +0100
Message-ID: <1655aef3-44f2-d07c-08ee-9d211b108628@arm.com>
References: <20170202163223.15372-1-andre.przywara@arm.com>
 <20170202163223.15372-13-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4514B40A7B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Mar 2017 04:48:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HXeIDgXTok9z for <kvmarm@lists.cs.columbia.edu>;
 Wed, 29 Mar 2017 04:48:06 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1E8AE40969
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Mar 2017 04:48:05 -0400 (EDT)
In-Reply-To: <20170202163223.15372-13-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andre Przywara <andre.przywara@arm.com>, Will Deacon <will.deacon@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 02/02/17 16:32, Andre Przywara wrote:
> The ITS emulation requires a unique device ID to be passed along the
> MSI payload when kvmtool wants to trigger an MSI in the guest.
> According to the proposed changes to the interface add the PCI
> bus/device/function triple to the structure passed with the ioctl.
> Check the respective capability before actually adding the device ID
> to the kvm_msi struct.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  virtio/pci.c | 16 +++++++++++++++-
>  1 file changed, 15 insertions(+), 1 deletion(-)
> 
> diff --git a/virtio/pci.c b/virtio/pci.c
> index 98bf6b7..cecfe8a 100644
> --- a/virtio/pci.c
> +++ b/virtio/pci.c
> @@ -321,14 +321,28 @@ static void virtio_pci__msix_mmio_callback(struct kvm_cpu *vcpu,
>  		update_msix_map(vpci, table, vecnum);
>  }
>  
> -static void virtio_pci__signal_msi(struct kvm *kvm, struct virtio_pci *vpci, int vec)
> +static void virtio_pci__signal_msi(struct kvm *kvm, struct virtio_pci *vpci,
> +				   int vec)
>  {
> +	static int needs_devid = 0;
>  	struct kvm_msi msi = {
>  		.address_lo = vpci->msix_table[vec].msg.address_lo,
>  		.address_hi = vpci->msix_table[vec].msg.address_hi,
>  		.data = vpci->msix_table[vec].msg.data,
>  	};
>  
> +	if (needs_devid == 0) {
> +		if (kvm__supports_vm_extension(kvm, KVM_CAP_MSI_DEVID))

Grump... Pretty horrible, even if it works. Even if we will never end-up
in a situation where we can mix ITS and non-ITS MSIs, could we instead
store this as a flag in the virtio_pci device?

> +			needs_devid = 1;
> +		else
> +			needs_devid = -1;
> +	}
> +
> +	if (needs_devid > 0) {
> +		msi.flags = KVM_MSI_VALID_DEVID;
> +		msi.devid = vpci->dev_hdr.dev_num << 3;
> +	}
> +
>  	ioctl(kvm->vm_fd, KVM_SIGNAL_MSI, &msi);
>  }
>  
> 

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
