From: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Subject: Re: [PATCH kvmtool v2 2/3] vfio-pci: Remove useless FDs reservation
 in vfio_pci_enable_intx()
Date: Mon, 25 Mar 2019 18:28:00 +0000
Message-ID: <e39e21d5-48ca-7707-8263-75c873db077c@arm.com>
References: <20190320062046.3895-1-leo.yan@linaro.org>
 <20190320062046.3895-3-leo.yan@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 272FF4A3B3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Mar 2019 14:28:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zxNgrgTrJbaQ for <kvmarm@lists.cs.columbia.edu>;
 Mon, 25 Mar 2019 14:28:21 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EB5BC4A2B6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Mar 2019 14:28:20 -0400 (EDT)
In-Reply-To: <20190320062046.3895-3-leo.yan@linaro.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Leo Yan <leo.yan@linaro.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, Will Deacon <Will.Deacon@arm.com>, Marc Zyngier <Marc.Zyngier@arm.com>, Eric Auger <eric.auger@redhat.com>, Robin Murphy <Robin.Murphy@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 20/03/2019 06:20, Leo Yan wrote:
> Since INTx only uses 2 FDs, it's not particularly useful to reserve FDs
> in function vfio_pci_enable_intx(); so this patch is to remove FDs
> reservation in this function.
> 
> Signed-off-by: Leo Yan <leo.yan@linaro.org>

The main reason for this is that we want to call enable_intx() multiple
times and reserve_irq_fds() increments a static variable. That function
makes an approximation of the number of fds used by kvmtool and given
that we count a margin of 100 fds, the 2 INTx fds are already included
in that approximation (assuming we're not assigning hundreds of devices
to the guest).

But given that patch 3 highlights the need for a one-time init function,
maybe we can move the reserve_irq_fds() call there as well?

Thanks,
Jean

> ---
>  vfio/pci.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/vfio/pci.c b/vfio/pci.c
> index 5224fee..d025581 100644
> --- a/vfio/pci.c
> +++ b/vfio/pci.c
> @@ -1025,8 +1025,6 @@ static int vfio_pci_enable_intx(struct kvm *kvm, struct vfio_device *vdev)
>  		.index = VFIO_PCI_INTX_IRQ_INDEX,
>  	};
>  
> -	vfio_pci_reserve_irq_fds(2);
> -
>  	ret = ioctl(vdev->fd, VFIO_DEVICE_GET_IRQ_INFO, &irq_info);
>  	if (ret || irq_info.count == 0) {
>  		vfio_dev_err(vdev, "no INTx reported by VFIO");
> 
