From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH] KVM: arm64: check for ITS device on MSI injection
Date: Tue, 9 Aug 2016 16:48:02 +0200
Message-ID: <20160809144802.GI9175@cbox>
References: <20160809095429.13393-1-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BC0B84998D
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Aug 2016 10:39:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EVG2lqB6QEex for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Aug 2016 10:39:07 -0400 (EDT)
Received: from mail-wm0-f47.google.com (mail-wm0-f47.google.com [74.125.82.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CCDA341145
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Aug 2016 10:39:06 -0400 (EDT)
Received: by mail-wm0-f47.google.com with SMTP id d196so5632395wmd.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 09 Aug 2016 07:46:13 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20160809095429.13393-1-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andre Przywara <andre.przywara@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Aug 09, 2016 at 10:54:29AM +0100, Andre Przywara wrote:
> When userspace provides the doorbell address for an MSI to be
> injected into the guest, we find a KVM device which feels responsible.
> Lets check that this device is really an emulated ITS before we make
> real use of the container_of-ed pointer.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  virt/kvm/arm/vgic/vgic-its.c | 25 +++++++++++++++++++++----
>  1 file changed, 21 insertions(+), 4 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
> index 18a6871..9aeb3a4 100644
> --- a/virt/kvm/arm/vgic/vgic-its.c
> +++ b/virt/kvm/arm/vgic/vgic-its.c
> @@ -471,6 +471,24 @@ static int vgic_its_trigger_msi(struct kvm *kvm, struct vgic_its *its,
>  	return 0;
>  }
>  
> +static struct vgic_io_device *vgic_get_its_iodev(struct kvm_io_device *dev)
> +{
> +	struct vgic_io_device *iodev;
> +
> +	if (!dev)
> +		return NULL;

this feels defensive.  Wouldn't it make more sense to check the return
of kvm_io_bus_get_dev where its' called, and then conditionally call
this function?

Otherwise:

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>


> +
> +	if (dev->ops != &kvm_io_gic_ops)
> +		return NULL;
> +
> +	iodev = container_of(dev, struct vgic_io_device, dev);
> +
> +	if (iodev->iodev_type != IODEV_ITS)
> +		return NULL;
> +
> +	return iodev;
> +}
> +
>  /*
>   * Queries the KVM IO bus framework to get the ITS pointer from the given
>   * doorbell address.
> @@ -493,10 +511,9 @@ int vgic_its_inject_msi(struct kvm *kvm, struct kvm_msi *msi)
>  	address = (u64)msi->address_hi << 32 | msi->address_lo;
>  
>  	kvm_io_dev = kvm_io_bus_get_dev(kvm, KVM_MMIO_BUS, address);
> -	if (!kvm_io_dev)
> -		return -ENODEV;
> -
> -	iodev = container_of(kvm_io_dev, struct vgic_io_device, dev);
> +	iodev = vgic_get_its_iodev(kvm_io_dev);
> +	if (!iodev)
> +		return -EINVAL;
>  
>  	mutex_lock(&iodev->its->its_lock);
>  	ret = vgic_its_trigger_msi(kvm, iodev->its, msi->devid, msi->data);
> -- 
> 2.9.0
> 
