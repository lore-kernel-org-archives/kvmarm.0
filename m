Return-Path: <SRS0=HOrx=GL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 141A7C433DB
	for <kvmarm@archiver.kernel.org>; Fri,  8 Jan 2021 15:19:32 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0C68E207C5
	for <kvmarm@archiver.kernel.org>; Fri,  8 Jan 2021 15:19:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0C68E207C5
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 518C84B408;
	Fri,  8 Jan 2021 10:19:30 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9YerwmwSnmZ5; Fri,  8 Jan 2021 10:19:28 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9E3154B3F4;
	Fri,  8 Jan 2021 10:19:28 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 04B604B3E3
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Jan 2021 10:19:27 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Ghb6n5v3stIz for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Jan 2021 10:19:24 -0500 (EST)
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2411F4B37F
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Jan 2021 10:19:22 -0500 (EST)
Received: from DGGEMM403-HUB.china.huawei.com (unknown [172.30.72.57])
 by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4DC6DY2yL2z5D5C;
 Fri,  8 Jan 2021 23:18:05 +0800 (CST)
Received: from dggema713-chm.china.huawei.com (10.3.20.77) by
 DGGEMM403-HUB.china.huawei.com (10.3.20.211) with Microsoft SMTP Server (TLS)
 id 14.3.498.0; Fri, 8 Jan 2021 23:19:17 +0800
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 dggema713-chm.china.huawei.com (10.3.20.77) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Fri, 8 Jan 2021 23:19:16 +0800
Received: from lhreml710-chm.china.huawei.com ([169.254.81.184]) by
 lhreml710-chm.china.huawei.com ([169.254.81.184]) with mapi id
 15.01.2106.002; Fri, 8 Jan 2021 15:19:14 +0000
From: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To: Eric Auger <eric.auger@redhat.com>, "eric.auger.pro@gmail.com"
 <eric.auger.pro@gmail.com>, "iommu@lists.linux-foundation.org"
 <iommu@lists.linux-foundation.org>, "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
 "will@kernel.org" <will@kernel.org>, "joro@8bytes.org" <joro@8bytes.org>,
 "maz@kernel.org" <maz@kernel.org>, "robin.murphy@arm.com"
 <robin.murphy@arm.com>, "alex.williamson@redhat.com"
 <alex.williamson@redhat.com>
Subject: RE: [PATCH v11 12/13] vfio/pci: Register a DMA fault response region
Thread-Topic: [PATCH v11 12/13] vfio/pci: Register a DMA fault response region
Thread-Index: AQHWvAgGhwjLBSYC0UyC6ARc2a6ugaoeJVMQ
Date: Fri, 8 Jan 2021 15:19:14 +0000
Message-ID: <510be72d8b934f78960157a76966a093@huawei.com>
References: <20201116110030.32335-1-eric.auger@redhat.com>
 <20201116110030.32335-13-eric.auger@redhat.com>
In-Reply-To: <20201116110030.32335-13-eric.auger@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.47.94.9]
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Cc: "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
 "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
 "Zengtao \(B\)" <prime.zeng@hisilicon.com>,
 "linuxarm@openeuler.org" <linuxarm@openeuler.org>,
 "nicoleotsuka@gmail.com" <nicoleotsuka@gmail.com>,
 "vivek.gautam@arm.com" <vivek.gautam@arm.com>,
 "yi.l.liu@intel.com" <yi.l.liu@intel.com>,
 "zhangfei.gao@linaro.org" <zhangfei.gao@linaro.org>
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Eric,

> -----Original Message-----
> From: Eric Auger [mailto:eric.auger@redhat.com]
> Sent: 16 November 2020 11:00
> To: eric.auger.pro@gmail.com; eric.auger@redhat.com;
> iommu@lists.linux-foundation.org; linux-kernel@vger.kernel.org;
> kvm@vger.kernel.org; kvmarm@lists.cs.columbia.edu; will@kernel.org;
> joro@8bytes.org; maz@kernel.org; robin.murphy@arm.com;
> alex.williamson@redhat.com
> Cc: jean-philippe@linaro.org; zhangfei.gao@linaro.org;
> zhangfei.gao@gmail.com; vivek.gautam@arm.com; Shameerali Kolothum
> Thodi <shameerali.kolothum.thodi@huawei.com>;
> jacob.jun.pan@linux.intel.com; yi.l.liu@intel.com; tn@semihalf.com;
> nicoleotsuka@gmail.com; yuzenghui <yuzenghui@huawei.com>
> Subject: [PATCH v11 12/13] vfio/pci: Register a DMA fault response region
> 
> In preparation for vSVA, let's register a DMA fault response region,
> where the userspace will push the page responses and increment the
> head of the buffer. The kernel will pop those responses and inject them
> on iommu side.
> 
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> ---
>  drivers/vfio/pci/vfio_pci.c         | 114 +++++++++++++++++++++++++---
>  drivers/vfio/pci/vfio_pci_private.h |   5 ++
>  drivers/vfio/pci/vfio_pci_rdwr.c    |  39 ++++++++++
>  include/uapi/linux/vfio.h           |  32 ++++++++
>  4 files changed, 181 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> index 65a83fd0e8c0..e9a904ce3f0d 100644
> --- a/drivers/vfio/pci/vfio_pci.c
> +++ b/drivers/vfio/pci/vfio_pci.c
> @@ -318,9 +318,20 @@ static void vfio_pci_dma_fault_release(struct
> vfio_pci_device *vdev,
>  	kfree(vdev->fault_pages);
>  }
> 
> -static int vfio_pci_dma_fault_mmap(struct vfio_pci_device *vdev,
> -				   struct vfio_pci_region *region,
> -				   struct vm_area_struct *vma)
> +static void
> +vfio_pci_dma_fault_response_release(struct vfio_pci_device *vdev,
> +				    struct vfio_pci_region *region)
> +{
> +	if (vdev->dma_fault_response_wq)
> +		destroy_workqueue(vdev->dma_fault_response_wq);
> +	kfree(vdev->fault_response_pages);
> +	vdev->fault_response_pages = NULL;
> +}
> +
> +static int __vfio_pci_dma_fault_mmap(struct vfio_pci_device *vdev,
> +				     struct vfio_pci_region *region,
> +				     struct vm_area_struct *vma,
> +				     u8 *pages)
>  {
>  	u64 phys_len, req_len, pgoff, req_start;
>  	unsigned long long addr;
> @@ -333,14 +344,14 @@ static int vfio_pci_dma_fault_mmap(struct
> vfio_pci_device *vdev,
>  		((1U << (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT)) - 1);
>  	req_start = pgoff << PAGE_SHIFT;
> 
> -	/* only the second page of the producer fault region is mmappable */
> +	/* only the second page of the fault region is mmappable */
>  	if (req_start < PAGE_SIZE)
>  		return -EINVAL;
> 
>  	if (req_start + req_len > phys_len)
>  		return -EINVAL;
> 
> -	addr = virt_to_phys(vdev->fault_pages);
> +	addr = virt_to_phys(pages);
>  	vma->vm_private_data = vdev;
>  	vma->vm_pgoff = (addr >> PAGE_SHIFT) + pgoff;
> 
> @@ -349,13 +360,29 @@ static int vfio_pci_dma_fault_mmap(struct
> vfio_pci_device *vdev,
>  	return ret;
>  }
> 
> -static int vfio_pci_dma_fault_add_capability(struct vfio_pci_device *vdev,
> -					     struct vfio_pci_region *region,
> -					     struct vfio_info_cap *caps)
> +static int vfio_pci_dma_fault_mmap(struct vfio_pci_device *vdev,
> +				   struct vfio_pci_region *region,
> +				   struct vm_area_struct *vma)
> +{
> +	return __vfio_pci_dma_fault_mmap(vdev, region, vma,
> vdev->fault_pages);
> +}
> +
> +static int
> +vfio_pci_dma_fault_response_mmap(struct vfio_pci_device *vdev,
> +				struct vfio_pci_region *region,
> +				struct vm_area_struct *vma)
> +{
> +	return __vfio_pci_dma_fault_mmap(vdev, region, vma,
> vdev->fault_response_pages);
> +}
> +
> +static int __vfio_pci_dma_fault_add_capability(struct vfio_pci_device *vdev,
> +					       struct vfio_pci_region *region,
> +					       struct vfio_info_cap *caps,
> +					       u32 cap_id)
>  {
>  	struct vfio_region_info_cap_sparse_mmap *sparse = NULL;
>  	struct vfio_region_info_cap_fault cap = {
> -		.header.id = VFIO_REGION_INFO_CAP_DMA_FAULT,
> +		.header.id = cap_id,
>  		.header.version = 1,
>  		.version = 1,
>  	};
> @@ -383,6 +410,14 @@ static int vfio_pci_dma_fault_add_capability(struct
> vfio_pci_device *vdev,
>  	return ret;
>  }
> 
> +static int vfio_pci_dma_fault_add_capability(struct vfio_pci_device *vdev,
> +					     struct vfio_pci_region *region,
> +					     struct vfio_info_cap *caps)
> +{
> +	return __vfio_pci_dma_fault_add_capability(vdev, region, caps,
> +						   VFIO_REGION_INFO_CAP_DMA_FAULT);
> +}
> +
>  static const struct vfio_pci_regops vfio_pci_dma_fault_regops = {
>  	.rw		= vfio_pci_dma_fault_rw,
>  	.release	= vfio_pci_dma_fault_release,
> @@ -390,6 +425,13 @@ static const struct vfio_pci_regops
> vfio_pci_dma_fault_regops = {
>  	.add_capability = vfio_pci_dma_fault_add_capability,
>  };
> 
> +static const struct vfio_pci_regops vfio_pci_dma_fault_response_regops = {
> +	.rw		= vfio_pci_dma_fault_response_rw,
> +	.release	= vfio_pci_dma_fault_response_release,
> +	.mmap		= vfio_pci_dma_fault_response_mmap,
> +	.add_capability = vfio_pci_dma_fault_add_capability,
> +};
> +
>  int vfio_pci_iommu_dev_fault_handler(struct iommu_fault *fault, void *data)
>  {
>  	struct vfio_pci_device *vdev = (struct vfio_pci_device *)data;
> @@ -500,6 +542,55 @@ static int vfio_pci_dma_fault_init(struct
> vfio_pci_device *vdev)
>  	return ret;
>  }
> 
> +#define DMA_FAULT_RESPONSE_RING_LENGTH 512
> +
> +static int vfio_pci_dma_fault_response_init(struct vfio_pci_device *vdev)
> +{
> +	struct vfio_region_dma_fault_response *header;
> +	struct iommu_domain *domain;
> +	size_t size;
> +	bool nested;
> +	int ret;
> +
> +	domain = iommu_get_domain_for_dev(&vdev->pdev->dev);
> +	ret = iommu_domain_get_attr(domain, DOMAIN_ATTR_NESTING,
> &nested);

The above will fail((Thanks to Zengtao for reporting this) if the Guest is
booted in "enable_unsafe_noiommu_mode" (CONFIG_VFIO_NOIOMMU)
and dpdk testpmd is attempted.

This is because even though there is an iommu group created for this
mode, no iommu domain gets attached to it. And results in below
crash,

root@ubuntu:/mnt/dpdk/build/app# ./testpmd -w 0000:00:02.0 --file-prefix socket0 -l 0-1 -n 2 -- -i
EAL: Detected 8 lcore(s)
EAL: Detected 1 NUMA nodes
EAL: Multi-process socket /var/run/dpdk/socket0/mp_socket
EAL: Selected IOVA mode 'PA'
EAL: No available hugepages reported in hugepages-32768kB
EAL: No available hugepages reported in hugepages-64kB
EAL: No available hugepages reported in hugepages-1048576kB
EAL: Probing VFIO support...
EAL: VFIO support initialized
EAL:   Invalid NUMA socket, default to 0
EAL:   using IOMMU type 8 (No-IOMMU)
[   84.942213] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000008
[   84.943047] Mem abort info:
---

I have pushed a temp fix for this in my test branch here,
https://github.com/hisilicon/kernel-dev/commit/7784d96fbac9c48e8093ec9dbf43a172b1cbe3c3

Please take a look.

(I am seeing another issue with testpmd + vsmmu. I will explain that in another thread).

Thanks,
Shameer



  
> +	if (ret || !nested)
> +		return ret;
> +
> +	mutex_init(&vdev->fault_response_queue_lock);
> +
> +	/*
> +	 * We provision 1 page for the header and space for
> +	 * DMA_FAULT_RING_LENGTH fault records in the ring buffer.
> +	 */
> +	size = ALIGN(sizeof(struct iommu_page_response) *
> +		     DMA_FAULT_RESPONSE_RING_LENGTH, PAGE_SIZE) +
> PAGE_SIZE;
> +
> +	vdev->fault_response_pages = kzalloc(size, GFP_KERNEL);
> +	if (!vdev->fault_response_pages)
> +		return -ENOMEM;
> +
> +	ret = vfio_pci_register_dev_region(vdev,
> +		VFIO_REGION_TYPE_NESTED,
> +		VFIO_REGION_SUBTYPE_NESTED_DMA_FAULT_RESPONSE,
> +		&vfio_pci_dma_fault_response_regops, size,
> +		VFIO_REGION_INFO_FLAG_READ |
> VFIO_REGION_INFO_FLAG_WRITE |
> +		VFIO_REGION_INFO_FLAG_MMAP,
> +		vdev->fault_response_pages);
> +	if (ret)
> +		goto out;
> +
> +	header = (struct vfio_region_dma_fault_response
> *)vdev->fault_response_pages;
> +	header->entry_size = sizeof(struct iommu_page_response);
> +	header->nb_entries = DMA_FAULT_RESPONSE_RING_LENGTH;
> +	header->offset = PAGE_SIZE;
> +
> +	return 0;
> +out:
> +	vdev->fault_response_pages = NULL;
> +	return ret;
> +}
> +
>  static int vfio_pci_enable(struct vfio_pci_device *vdev)
>  {
>  	struct pci_dev *pdev = vdev->pdev;
> @@ -602,6 +693,10 @@ static int vfio_pci_enable(struct vfio_pci_device
> *vdev)
>  	if (ret)
>  		goto disable_exit;
> 
> +	ret = vfio_pci_dma_fault_response_init(vdev);
> +	if (ret)
> +		goto disable_exit;
> +
>  	vfio_pci_probe_mmaps(vdev);
> 
>  	return 0;
> @@ -2227,6 +2322,7 @@ static int vfio_pci_probe(struct pci_dev *pdev, const
> struct pci_device_id *id)
>  	INIT_LIST_HEAD(&vdev->ioeventfds_list);
>  	mutex_init(&vdev->vma_lock);
>  	INIT_LIST_HEAD(&vdev->vma_list);
> +	INIT_LIST_HEAD(&vdev->dummy_resources_list);
>  	init_rwsem(&vdev->memory_lock);
> 
>  	ret = vfio_add_group_dev(&pdev->dev, &vfio_pci_ops, vdev);
> diff --git a/drivers/vfio/pci/vfio_pci_private.h
> b/drivers/vfio/pci/vfio_pci_private.h
> index e180b5435c8f..035634521cd0 100644
> --- a/drivers/vfio/pci/vfio_pci_private.h
> +++ b/drivers/vfio/pci/vfio_pci_private.h
> @@ -144,7 +144,9 @@ struct vfio_pci_device {
>  	struct eventfd_ctx	*err_trigger;
>  	struct eventfd_ctx	*req_trigger;
>  	u8			*fault_pages;
> +	u8			*fault_response_pages;
>  	struct mutex		fault_queue_lock;
> +	struct mutex		fault_response_queue_lock;
>  	struct list_head	dummy_resources_list;
>  	struct mutex		ioeventfds_lock;
>  	struct list_head	ioeventfds_list;
> @@ -189,6 +191,9 @@ extern long vfio_pci_ioeventfd(struct vfio_pci_device
> *vdev, loff_t offset,
>  extern size_t vfio_pci_dma_fault_rw(struct vfio_pci_device *vdev,
>  				    char __user *buf, size_t count,
>  				    loff_t *ppos, bool iswrite);
> +extern size_t vfio_pci_dma_fault_response_rw(struct vfio_pci_device *vdev,
> +					     char __user *buf, size_t count,
> +					     loff_t *ppos, bool iswrite);
> 
>  extern int vfio_pci_init_perm_bits(void);
>  extern void vfio_pci_uninit_perm_bits(void);
> diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c b/drivers/vfio/pci/vfio_pci_rdwr.c
> index 164120607469..efde0793360b 100644
> --- a/drivers/vfio/pci/vfio_pci_rdwr.c
> +++ b/drivers/vfio/pci/vfio_pci_rdwr.c
> @@ -400,6 +400,45 @@ size_t vfio_pci_dma_fault_rw(struct vfio_pci_device
> *vdev, char __user *buf,
>  	return ret;
>  }
> 
> +size_t vfio_pci_dma_fault_response_rw(struct vfio_pci_device *vdev, char
> __user *buf,
> +				      size_t count, loff_t *ppos, bool iswrite)
> +{
> +	unsigned int i = VFIO_PCI_OFFSET_TO_INDEX(*ppos) -
> VFIO_PCI_NUM_REGIONS;
> +	loff_t pos = *ppos & VFIO_PCI_OFFSET_MASK;
> +	void *base = vdev->region[i].data;
> +	int ret = -EFAULT;
> +
> +	if (pos >= vdev->region[i].size)
> +		return -EINVAL;
> +
> +	count = min(count, (size_t)(vdev->region[i].size - pos));
> +
> +	if (iswrite) {
> +		struct vfio_region_dma_fault_response *header =
> +			(struct vfio_region_dma_fault_response *)base;
> +		uint32_t  new_head;
> +
> +		if (pos != 0 || count != 4)
> +			return -EINVAL;
> +
> +		if (copy_from_user((void *)&new_head, buf, count))
> +			return -EFAULT;
> +
> +		if (new_head >= header->nb_entries)
> +			return -EINVAL;
> +
> +		mutex_lock(&vdev->fault_response_queue_lock);
> +		header->head = new_head;
> +		mutex_unlock(&vdev->fault_response_queue_lock);
> +	} else {
> +		if (copy_to_user(buf, base + pos, count))
> +			return -EFAULT;
> +	}
> +	*ppos += count;
> +	ret = count;
> +	return ret;
> +}
> +
>  static void vfio_pci_ioeventfd_do_write(struct vfio_pci_ioeventfd *ioeventfd,
>  					bool test_mem)
>  {
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index 1e5c82f9d14d..5d106db7a4c5 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -345,6 +345,7 @@ struct vfio_region_info_cap_type {
> 
>  #define VFIO_REGION_TYPE_NESTED			(2)
>  #define VFIO_REGION_SUBTYPE_NESTED_DMA_FAULT	(1)
> +#define VFIO_REGION_SUBTYPE_NESTED_DMA_FAULT_RESPONSE	(2)
> 
>  /**
>   * struct vfio_region_gfx_edid - EDID region layout.
> @@ -1022,6 +1023,17 @@ struct vfio_region_info_cap_fault {
>  	__u32 version;
>  };
> 
> +/*
> + * Capability exposed by the DMA fault response region
> + * @version: ABI version
> + */
> +#define VFIO_REGION_INFO_CAP_DMA_FAULT_RESPONSE	7
> +
> +struct vfio_region_info_cap_fault_response {
> +	struct vfio_info_cap_header header;
> +	__u32 version;
> +};
> +
>  /*
>   * DMA Fault Region Layout
>   * @tail: index relative to the start of the ring buffer at which the
> @@ -1042,6 +1054,26 @@ struct vfio_region_dma_fault {
>  	__u32   head;
>  };
> 
> +/*
> + * DMA Fault Response Region Layout
> + * @head: index relative to the start of the ring buffer at which the
> + *        producer (userspace) insert responses into the buffer
> + * @entry_size: fault ring buffer entry size in bytes
> + * @nb_entries: max capacity of the fault ring buffer
> + * @offset: ring buffer offset relative to the start of the region
> + * @tail: index relative to the start of the ring buffer at which the
> + *        consumer (kernel) finds the next item in the buffer
> + */
> +struct vfio_region_dma_fault_response {
> +	/* Write-Only */
> +	__u32   head;
> +	/* Read-Only */
> +	__u32   entry_size;
> +	__u32	nb_entries;
> +	__u32	offset;
> +	__u32   tail;
> +};
> +
>  /* -------- API for Type1 VFIO IOMMU -------- */
> 
>  /**
> --
> 2.21.3

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
