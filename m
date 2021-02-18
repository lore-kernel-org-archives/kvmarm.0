Return-Path: <SRS0=5K0R=HU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A082C433DB
	for <kvmarm@archiver.kernel.org>; Thu, 18 Feb 2021 10:48:53 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 57B4F64DE8
	for <kvmarm@archiver.kernel.org>; Thu, 18 Feb 2021 10:48:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 57B4F64DE8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AB0684B345;
	Thu, 18 Feb 2021 05:48:51 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ct5J+Fq1ysXn; Thu, 18 Feb 2021 05:48:50 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4DAF44B389;
	Thu, 18 Feb 2021 05:48:50 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F3BF64B384
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Feb 2021 05:48:48 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yvv8eG9pBD5i for <kvmarm@lists.cs.columbia.edu>;
 Thu, 18 Feb 2021 05:48:47 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [63.128.21.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D423C4B345
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Feb 2021 05:48:47 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1613645327;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=xrLVPyhrv8/F8fL5Wp8KW8EGwEwKdeCoRYS/Gw5ZWiY=;
 b=c2fSORLXEXocuTzPImYrz49ErfgjCheHv48a45VKWLR+LgqX/v4sC1Xgd6KSjNV4v/EUKy
 dNMZuk4PAncd0Y+d9BvLadvSgZpgPxqMi8GZ0eRNb3kpXzL6Y04A6tXATbGqgBexRA8NhZ
 Qo2goSNjy7A1V52Owv3bX65QL6Rg2pc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-220-zLEF85eQO1Sv2WJwOi_wrA-1; Thu, 18 Feb 2021 05:48:43 -0500
X-MC-Unique: zLEF85eQO1Sv2WJwOi_wrA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com
 [10.5.11.15])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EC3E2192CC42;
 Thu, 18 Feb 2021 10:48:40 +0000 (UTC)
Received: from [10.36.114.34] (ovpn-114-34.ams2.redhat.com [10.36.114.34])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5EB6762679;
 Thu, 18 Feb 2021 10:48:32 +0000 (UTC)
Subject: Re: [PATCH v11 12/13] vfio/pci: Register a DMA fault response region
To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
 "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
 "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
 "will@kernel.org" <will@kernel.org>, "joro@8bytes.org" <joro@8bytes.org>,
 "maz@kernel.org" <maz@kernel.org>,
 "robin.murphy@arm.com" <robin.murphy@arm.com>,
 "alex.williamson@redhat.com" <alex.williamson@redhat.com>
References: <20201116110030.32335-1-eric.auger@redhat.com>
 <20201116110030.32335-13-eric.auger@redhat.com>
 <6c00965615844f03954faecb6fcb9294@huawei.com>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <13efbf21-90cc-9b52-a6cd-68280ea73db2@redhat.com>
Date: Thu, 18 Feb 2021 11:48:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <6c00965615844f03954faecb6fcb9294@huawei.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
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

Hi Shameer,

On 2/18/21 11:36 AM, Shameerali Kolothum Thodi wrote:
> Hi Eric,
> 
>>> -----Original Message-----
>>> From: Eric Auger [mailto:eric.auger@redhat.com]
>>> Sent: 16 November 2020 11:00
>>> To: eric.auger.pro@gmail.com; eric.auger@redhat.com;
>>> iommu@lists.linux-foundation.org; linux-kernel@vger.kernel.org;
>>> kvm@vger.kernel.org; kvmarm@lists.cs.columbia.edu; will@kernel.org;
>>> joro@8bytes.org; maz@kernel.org; robin.murphy@arm.com;
>>> alex.williamson@redhat.com
>>> Cc: jean-philippe@linaro.org; zhangfei.gao@linaro.org;
>>> zhangfei.gao@gmail.com; vivek.gautam@arm.com; Shameerali Kolothum
>>> Thodi <shameerali.kolothum.thodi@huawei.com>;
>>> jacob.jun.pan@linux.intel.com; yi.l.liu@intel.com; tn@semihalf.com;
>>> nicoleotsuka@gmail.com; yuzenghui <yuzenghui@huawei.com>
>>> Subject: [PATCH v11 12/13] vfio/pci: Register a DMA fault response
>>> region
>>>
>>> In preparation for vSVA, let's register a DMA fault response region,
>>> where the userspace will push the page responses and increment the
>>> head of the buffer. The kernel will pop those responses and inject
>>> them on iommu side.
>>>
>>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>>> ---
>>>  drivers/vfio/pci/vfio_pci.c         | 114 +++++++++++++++++++++++++---
>>>  drivers/vfio/pci/vfio_pci_private.h |   5 ++
>>>  drivers/vfio/pci/vfio_pci_rdwr.c    |  39 ++++++++++
>>>  include/uapi/linux/vfio.h           |  32 ++++++++
>>>  4 files changed, 181 insertions(+), 9 deletions(-)
>>>
>>> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
>>> index 65a83fd0e8c0..e9a904ce3f0d 100644
>>> --- a/drivers/vfio/pci/vfio_pci.c
>>> +++ b/drivers/vfio/pci/vfio_pci.c
>>> @@ -318,9 +318,20 @@ static void vfio_pci_dma_fault_release(struct
>>> vfio_pci_device *vdev,
>>>  	kfree(vdev->fault_pages);
>>>  }
>>>
>>> -static int vfio_pci_dma_fault_mmap(struct vfio_pci_device *vdev,
>>> -				   struct vfio_pci_region *region,
>>> -				   struct vm_area_struct *vma)
>>> +static void
>>> +vfio_pci_dma_fault_response_release(struct vfio_pci_device *vdev,
>>> +				    struct vfio_pci_region *region) {
>>> +	if (vdev->dma_fault_response_wq)
>>> +		destroy_workqueue(vdev->dma_fault_response_wq);
>>> +	kfree(vdev->fault_response_pages);
>>> +	vdev->fault_response_pages = NULL;
>>> +}
>>> +
>>> +static int __vfio_pci_dma_fault_mmap(struct vfio_pci_device *vdev,
>>> +				     struct vfio_pci_region *region,
>>> +				     struct vm_area_struct *vma,
>>> +				     u8 *pages)
>>>  {
>>>  	u64 phys_len, req_len, pgoff, req_start;
>>>  	unsigned long long addr;
>>> @@ -333,14 +344,14 @@ static int vfio_pci_dma_fault_mmap(struct
>>> vfio_pci_device *vdev,
>>>  		((1U << (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT)) - 1);
>>>  	req_start = pgoff << PAGE_SHIFT;
>>>
>>> -	/* only the second page of the producer fault region is mmappable */
>>> +	/* only the second page of the fault region is mmappable */
>>>  	if (req_start < PAGE_SIZE)
>>>  		return -EINVAL;
>>>
>>>  	if (req_start + req_len > phys_len)
>>>  		return -EINVAL;
>>>
>>> -	addr = virt_to_phys(vdev->fault_pages);
>>> +	addr = virt_to_phys(pages);
>>>  	vma->vm_private_data = vdev;
>>>  	vma->vm_pgoff = (addr >> PAGE_SHIFT) + pgoff;
>>>
>>> @@ -349,13 +360,29 @@ static int vfio_pci_dma_fault_mmap(struct
>>> vfio_pci_device *vdev,
>>>  	return ret;
>>>  }
>>>
>>> -static int vfio_pci_dma_fault_add_capability(struct vfio_pci_device *vdev,
>>> -					     struct vfio_pci_region *region,
>>> -					     struct vfio_info_cap *caps)
>>> +static int vfio_pci_dma_fault_mmap(struct vfio_pci_device *vdev,
>>> +				   struct vfio_pci_region *region,
>>> +				   struct vm_area_struct *vma)
>>> +{
>>> +	return __vfio_pci_dma_fault_mmap(vdev, region, vma,
>>> vdev->fault_pages);
>>> +}
>>> +
>>> +static int
>>> +vfio_pci_dma_fault_response_mmap(struct vfio_pci_device *vdev,
>>> +				struct vfio_pci_region *region,
>>> +				struct vm_area_struct *vma)
>>> +{
>>> +	return __vfio_pci_dma_fault_mmap(vdev, region, vma,
>>> vdev->fault_response_pages);
>>> +}
>>> +
>>> +static int __vfio_pci_dma_fault_add_capability(struct vfio_pci_device *vdev,
>>> +					       struct vfio_pci_region *region,
>>> +					       struct vfio_info_cap *caps,
>>> +					       u32 cap_id)
>>>  {
>>>  	struct vfio_region_info_cap_sparse_mmap *sparse = NULL;
>>>  	struct vfio_region_info_cap_fault cap = {
>>> -		.header.id = VFIO_REGION_INFO_CAP_DMA_FAULT,
>>> +		.header.id = cap_id,
>>>  		.header.version = 1,
>>>  		.version = 1,
>>>  	};
>>> @@ -383,6 +410,14 @@ static int
>>> vfio_pci_dma_fault_add_capability(struct
>>> vfio_pci_device *vdev,
>>>  	return ret;
>>>  }
>>>
>>> +static int vfio_pci_dma_fault_add_capability(struct vfio_pci_device *vdev,
>>> +					     struct vfio_pci_region *region,
>>> +					     struct vfio_info_cap *caps) {
>>> +	return __vfio_pci_dma_fault_add_capability(vdev, region, caps,
>>> +						   VFIO_REGION_INFO_CAP_DMA_FAULT); }
>>> +
>>>  static const struct vfio_pci_regops vfio_pci_dma_fault_regops = {
>>>  	.rw		= vfio_pci_dma_fault_rw,
>>>  	.release	= vfio_pci_dma_fault_release,
>>> @@ -390,6 +425,13 @@ static const struct vfio_pci_regops
>>> vfio_pci_dma_fault_regops = {
>>>  	.add_capability = vfio_pci_dma_fault_add_capability,
>>>  };
>>>
>>> +static const struct vfio_pci_regops vfio_pci_dma_fault_response_regops = {
>>> +	.rw		= vfio_pci_dma_fault_response_rw,
>>> +	.release	= vfio_pci_dma_fault_response_release,
>>> +	.mmap		= vfio_pci_dma_fault_response_mmap,
>>> +	.add_capability = vfio_pci_dma_fault_add_capability,
> 
> As I mentioned in the Qemu patch ([RFC v7 26/26] vfio/pci: Implement 
> return_page_response page response callback), it looks like we are using the
> VFIO_REGION_INFO_CAP_DMA_FAULT cap id for the dma_fault_response here
> as well. Is that intentional?
> (Was wondering how it worked in the first place and noted this).
yep, copy paste error :-(

Thanks

Eric
> 
> Please check.
> 
> Thanks,
> Shameer
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
