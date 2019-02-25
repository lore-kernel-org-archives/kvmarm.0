From: Vincent =?utf-8?Q?Stehl=C3=A9?= <vincent.stehle@arm.com>
Subject: Re: [PATCH v4 19/22] vfio-pci: Register an iommu fault handler
Date: Mon, 25 Feb 2019 15:22:10 +0100
Message-ID: <20190225142209.GC23257@debian>
References: <20190218135504.25048-1-eric.auger@redhat.com>
 <20190218135504.25048-20-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190218135504.25048-20-eric.auger@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Eric Auger <eric.auger@redhat.com>
Cc: eric.auger.pro@gmail.com, iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, joro@8bytes.org, alex.williamson@redhat.com, jacob.jun.pan@linux.intel.com, yi.l.liu@linux.intel.com, jean-philippe.brucker@arm.com, will.deacon@arm.com, robin.murphy@arm.com, kevin.tian@intel.com, ashok.raj@intel.com, marc.zyngier@arm.com, christoffer.dall@arm.com, peter.maydell@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Eric,

On Mon, Feb 18, 2019 at 02:55:00PM +0100, Eric Auger wrote:
> This patch registers a fault handler which records faults in
> a circular buffer and then signals an eventfd. This buffer is
> exposed within the fault region.
> 
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> ---
>  drivers/vfio/pci/vfio_pci.c         | 49 +++++++++++++++++++++++++++++
>  drivers/vfio/pci/vfio_pci_private.h |  1 +
>  2 files changed, 50 insertions(+)
> 
> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> index aaf63e5ca2b6..019c9fd380a5 100644
> --- a/drivers/vfio/pci/vfio_pci.c
> +++ b/drivers/vfio/pci/vfio_pci.c
(..)
>  static int vfio_pci_init_fault_region(struct vfio_pci_device *vdev)
>  {
>  	struct vfio_region_fault_prod *header;
> @@ -276,6 +317,13 @@ static int vfio_pci_init_fault_region(struct vfio_pci_device *vdev)
>  	header = (struct vfio_region_fault_prod *)vdev->fault_pages;
>  	header->version = -1;
>  	header->offset = PAGE_SIZE;
> +
> +	ret = iommu_register_device_fault_handler(&vdev->pdev->dev,
> +					vfio_pci_iommu_dev_fault_handler,
> +					vdev);
> +	if (ret)
> +		goto out;
> +
>  	return 0;
>  out:
>  	kfree(vdev->fault_pages);

This patch calls iommu_register_device_fault_handler from
vfio_pci_init_fault_region, leading to the following call stack:

iommu_register_device_fault_handler
vfio_pci_init_fault_region
vfio_pci_enable
vfio_pci_open
vfio_group_get_device_fd

> @@ -1420,6 +1468,7 @@ static void vfio_pci_remove(struct pci_dev *pdev)
>  	vfio_iommu_group_put(pdev->dev.iommu_group, &pdev->dev);
>  	kfree(vdev->region);
>  	kfree(vdev->fault_pages);
> +	iommu_unregister_device_fault_handler(&pdev->dev);
>  	mutex_destroy(&vdev->ioeventfds_lock);
>  	kfree(vdev);

And then this patch calls iommu_unregister_device_fault_handler from
vfio_pci_remove, and not from vfio_pci_release.

I think this means a device cannot be used twice in a row without unloading the
module.

Here is an example sequence:

1. modprobe vfio-pci
2. Userspace uses VFIO, calls ioctl(VFIO_GROUP_GET_DEVICE_FD)
    2.1. iommu_register_device_fault_handler is called
3. Userspace exits
    3.1. vfio_pci_release is called,
         but iommu_unregister_device_fault_handler is not called
4. Userspace uses VFIO agin, calls ioctl(VFIO_GROUP_GET_DEVICE_FD) again
    4.1. iommu_register_device_fault_handler is called again,
         notices a fault handler is already there,
         returns -EBUSY

Unloading the vfio-pci module will call vfio_pci_remove.

Maybe iommu_unregister_device_fault_handler should be called from
vfio_pci_release instead of vfio_pci_remove?

Best regards,
Vincent.
