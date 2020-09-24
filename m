Return-Path: <SRS0=RYKq=DB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AC60C4346E
	for <kvmarm@archiver.kernel.org>; Thu, 24 Sep 2020 08:23:28 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D9AD42376F
	for <kvmarm@archiver.kernel.org>; Thu, 24 Sep 2020 08:23:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D9AD42376F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 203634B11B;
	Thu, 24 Sep 2020 04:23:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Cr++M9JGvS-l; Thu, 24 Sep 2020 04:23:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E47D44B297;
	Thu, 24 Sep 2020 04:23:25 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9A6D24B11B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Sep 2020 04:23:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MMf+NO3xY3TG for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Sep 2020 04:23:22 -0400 (EDT)
Received: from huawei.com (szxga07-in.huawei.com [45.249.212.35])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7107D4B103
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Sep 2020 04:23:22 -0400 (EDT)
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
 by Forcepoint Email with ESMTP id BED77B6AD300A22DF907;
 Thu, 24 Sep 2020 16:23:17 +0800 (CST)
Received: from [10.174.185.226] (10.174.185.226) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.487.0; Thu, 24 Sep 2020 16:23:10 +0800
Subject: Re: [PATCH v10 04/11] vfio/pci: Add VFIO_REGION_TYPE_NESTED region
 type
To: Eric Auger <eric.auger@redhat.com>, <eric.auger.pro@gmail.com>,
 <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
 <kvm@vger.kernel.org>, <kvmarm@lists.cs.columbia.edu>, <joro@8bytes.org>,
 <alex.williamson@redhat.com>, <jacob.jun.pan@linux.intel.com>,
 <yi.l.liu@intel.com>, <robin.murphy@arm.com>
References: <20200320161911.27494-1-eric.auger@redhat.com>
 <20200320161911.27494-5-eric.auger@redhat.com>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <d21e74e5-00a7-79f9-24d2-c9385409cc05@huawei.com>
Date: Thu, 24 Sep 2020 16:23:10 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200320161911.27494-5-eric.auger@redhat.com>
Content-Language: en-US
X-Originating-IP: [10.174.185.226]
X-CFilter-Loop: Reflected
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Eric,

On 2020/3/21 0:19, Eric Auger wrote:
> Add a new specific DMA_FAULT region aiming to exposed nested mode
> translation faults.
> 
> The region has a ring buffer that contains the actual fault
> records plus a header allowing to handle it (tail/head indices,
> max capacity, entry size). At the moment the region is dimensionned
> for 512 fault records.
> 
> Signed-off-by: Eric Auger <eric.auger@redhat.com>

[...]

> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> index 379a02c36e37..586b89debed5 100644
> --- a/drivers/vfio/pci/vfio_pci.c
> +++ b/drivers/vfio/pci/vfio_pci.c
> @@ -260,6 +260,69 @@ int vfio_pci_set_power_state(struct vfio_pci_device *vdev, pci_power_t state)
>   	return ret;
>   }
>   
> +static void vfio_pci_dma_fault_release(struct vfio_pci_device *vdev,
> +				       struct vfio_pci_region *region)
> +{
> +}
> +
> +static int vfio_pci_dma_fault_add_capability(struct vfio_pci_device *vdev,
> +					     struct vfio_pci_region *region,
> +					     struct vfio_info_cap *caps)
> +{
> +	struct vfio_region_info_cap_fault cap = {
> +		.header.id = VFIO_REGION_INFO_CAP_DMA_FAULT,
> +		.header.version = 1,
> +		.version = 1,
> +	};
> +	return vfio_info_add_capability(caps, &cap.header, sizeof(cap));
> +}
> +
> +static const struct vfio_pci_regops vfio_pci_dma_fault_regops = {
> +	.rw		= vfio_pci_dma_fault_rw,
> +	.release	= vfio_pci_dma_fault_release,
> +	.add_capability = vfio_pci_dma_fault_add_capability,
> +};
> +
> +#define DMA_FAULT_RING_LENGTH 512
> +
> +static int vfio_pci_init_dma_fault_region(struct vfio_pci_device *vdev)
> +{
> +	struct vfio_region_dma_fault *header;
> +	size_t size;
> +	int ret;
> +
> +	mutex_init(&vdev->fault_queue_lock);
> +
> +	/*
> +	 * We provision 1 page for the header and space for
> +	 * DMA_FAULT_RING_LENGTH fault records in the ring buffer.
> +	 */
> +	size = ALIGN(sizeof(struct iommu_fault) *
> +		     DMA_FAULT_RING_LENGTH, PAGE_SIZE) + PAGE_SIZE;
> +
> +	vdev->fault_pages = kzalloc(size, GFP_KERNEL);
> +	if (!vdev->fault_pages)
> +		return -ENOMEM;
> +
> +	ret = vfio_pci_register_dev_region(vdev,
> +		VFIO_REGION_TYPE_NESTED,
> +		VFIO_REGION_SUBTYPE_NESTED_DMA_FAULT,
> +		&vfio_pci_dma_fault_regops, size,
> +		VFIO_REGION_INFO_FLAG_READ | VFIO_REGION_INFO_FLAG_WRITE,
> +		vdev->fault_pages);
> +	if (ret)
> +		goto out;
> +
> +	header = (struct vfio_region_dma_fault *)vdev->fault_pages;
> +	header->entry_size = sizeof(struct iommu_fault);
> +	header->nb_entries = DMA_FAULT_RING_LENGTH;
> +	header->offset = sizeof(struct vfio_region_dma_fault);
> +	return 0;
> +out:
> +	kfree(vdev->fault_pages);
> +	return ret;
> +}
> +
>   static int vfio_pci_enable(struct vfio_pci_device *vdev)
>   {
>   	struct pci_dev *pdev = vdev->pdev;
> @@ -358,6 +421,10 @@ static int vfio_pci_enable(struct vfio_pci_device *vdev)
>   		}
>   	}
>   
> +	ret = vfio_pci_init_dma_fault_region(vdev);
> +	if (ret)
> +		goto disable_exit;
> +
>   	vfio_pci_probe_mmaps(vdev);
>   
>   	return 0;
> @@ -1383,6 +1450,7 @@ static void vfio_pci_remove(struct pci_dev *pdev)
>   
>   	vfio_iommu_group_put(pdev->dev.iommu_group, &pdev->dev);
>   	kfree(vdev->region);
> +	kfree(vdev->fault_pages);
>   	mutex_destroy(&vdev->ioeventfds_lock);
>   
>   	if (!disable_idle_d3)
> diff --git a/drivers/vfio/pci/vfio_pci_private.h b/drivers/vfio/pci/vfio_pci_private.h
> index 8a2c7607d513..a392f50e3a99 100644
> --- a/drivers/vfio/pci/vfio_pci_private.h
> +++ b/drivers/vfio/pci/vfio_pci_private.h
> @@ -119,6 +119,8 @@ struct vfio_pci_device {
>   	int			ioeventfds_nr;
>   	struct eventfd_ctx	*err_trigger;
>   	struct eventfd_ctx	*req_trigger;
> +	u8			*fault_pages;

What's the reason to use 'u8'? It doesn't match the type of header, nor
the type of ring buffer.

> +	struct mutex		fault_queue_lock;
>   	struct list_head	dummy_resources_list;
>   	struct mutex		ioeventfds_lock;
>   	struct list_head	ioeventfds_list;
> @@ -150,6 +152,14 @@ extern ssize_t vfio_pci_vga_rw(struct vfio_pci_device *vdev, char __user *buf,
>   extern long vfio_pci_ioeventfd(struct vfio_pci_device *vdev, loff_t offset,
>   			       uint64_t data, int count, int fd);
>   
> +struct vfio_pci_fault_abi {
> +	u32 entry_size;
> +};

This is not used by this patch (and the whole series).

> +
> +extern size_t vfio_pci_dma_fault_rw(struct vfio_pci_device *vdev,
> +				    char __user *buf, size_t count,
> +				    loff_t *ppos, bool iswrite);
> +
>   extern int vfio_pci_init_perm_bits(void);
>   extern void vfio_pci_uninit_perm_bits(void);
>   
> diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c b/drivers/vfio/pci/vfio_pci_rdwr.c
> index a87992892a9f..4004ab8cad0e 100644
> --- a/drivers/vfio/pci/vfio_pci_rdwr.c
> +++ b/drivers/vfio/pci/vfio_pci_rdwr.c
> @@ -274,6 +274,51 @@ ssize_t vfio_pci_vga_rw(struct vfio_pci_device *vdev, char __user *buf,
>   	return done;
>   }
>   
> +size_t vfio_pci_dma_fault_rw(struct vfio_pci_device *vdev, char __user *buf,
> +			     size_t count, loff_t *ppos, bool iswrite)
> +{
> +	unsigned int i = VFIO_PCI_OFFSET_TO_INDEX(*ppos) - VFIO_PCI_NUM_REGIONS;
> +	loff_t pos = *ppos & VFIO_PCI_OFFSET_MASK;
> +	void *base = vdev->region[i].data;
> +	int ret = -EFAULT;
> +
> +	if (pos >= vdev->region[i].size)
> +		return -EINVAL;
> +
> +	count = min(count, (size_t)(vdev->region[i].size - pos));
> +
> +	mutex_lock(&vdev->fault_queue_lock);
> +
> +	if (iswrite) {
> +		struct vfio_region_dma_fault *header =
> +			(struct vfio_region_dma_fault *)base;
> +		u32 new_tail;
> +
> +		if (pos != 0 || count != 4) {
> +			ret = -EINVAL;
> +			goto unlock;
> +		}
> +
> +		if (copy_from_user((void *)&new_tail, buf, count))
> +			goto unlock;
> +
> +		if (new_tail > header->nb_entries) {

Maybe

new_tail >= header->nb_entries ?

> +			ret = -EINVAL;
> +			goto unlock;
> +		}
> +		header->tail = new_tail;
> +	} else {
> +		if (copy_to_user(buf, base + pos, count))
> +			goto unlock;
> +	}
> +	*ppos += count;
> +	ret = count;
> +unlock:
> +	mutex_unlock(&vdev->fault_queue_lock);
> +	return ret;
> +}
> +
> +
>   static int vfio_pci_ioeventfd_handler(void *opaque, void *unused)
>   {
>   	struct vfio_pci_ioeventfd *ioeventfd = opaque;


Thanks,
Zenghui
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
