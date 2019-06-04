Return-Path: <SRS0=jSi8=UD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F183EC28CC6
	for <kvmarm@archiver.kernel.org>; Tue,  4 Jun 2019 16:11:54 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9204020874
	for <kvmarm@archiver.kernel.org>; Tue,  4 Jun 2019 16:11:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9204020874
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 071244A4A9;
	Tue,  4 Jun 2019 12:11:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qBRmOUVyrbA4; Tue,  4 Jun 2019 12:11:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CA6C14A51A;
	Tue,  4 Jun 2019 12:11:52 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BE03A4A503
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Jun 2019 12:11:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MvKkuvRZyAwr for <kvmarm@lists.cs.columbia.edu>;
 Tue,  4 Jun 2019 12:11:50 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7C6F34A4A9
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Jun 2019 12:11:50 -0400 (EDT)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
 [10.5.11.11])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mx1.redhat.com (Postfix) with ESMTPS id E301D2F8BDD;
 Tue,  4 Jun 2019 16:11:21 +0000 (UTC)
Received: from [10.36.116.67] (ovpn-116-67.ams2.redhat.com [10.36.116.67])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C5C836064C;
 Tue,  4 Jun 2019 16:11:09 +0000 (UTC)
Subject: Re: [PATCH v8 26/29] vfio-pci: Register an iommu fault handler
To: Alex Williamson <alex.williamson@redhat.com>
References: <20190526161004.25232-1-eric.auger@redhat.com>
 <20190526161004.25232-27-eric.auger@redhat.com>
 <20190603163139.70fe8839@x1.home>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <10dd60d9-4af0-c0eb-08c9-a0db7ee1925e@redhat.com>
Date: Tue, 4 Jun 2019 18:11:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190603163139.70fe8839@x1.home>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16
 (mx1.redhat.com [10.5.110.38]); Tue, 04 Jun 2019 16:11:44 +0000 (UTC)
Cc: kevin.tian@intel.com, jacob.jun.pan@linux.intel.com, ashok.raj@intel.com,
 kvm@vger.kernel.org, joro@8bytes.org, will.deacon@arm.com,
 linux-kernel@vger.kernel.org, marc.zyngier@arm.com,
 iommu@lists.linux-foundation.org, yi.l.liu@intel.com, vincent.stehle@arm.com,
 robin.murphy@arm.com, kvmarm@lists.cs.columbia.edu, eric.auger.pro@gmail.com
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

Hi Alex,

On 6/4/19 12:31 AM, Alex Williamson wrote:
> On Sun, 26 May 2019 18:10:01 +0200
> Eric Auger <eric.auger@redhat.com> wrote:
> 
>> This patch registers a fault handler which records faults in
>> a circular buffer and then signals an eventfd. This buffer is
>> exposed within the fault region.
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>>
>> ---
>>
>> v3 -> v4:
>> - move iommu_unregister_device_fault_handler to vfio_pci_release
>> ---
>>  drivers/vfio/pci/vfio_pci.c         | 49 +++++++++++++++++++++++++++++
>>  drivers/vfio/pci/vfio_pci_private.h |  1 +
>>  2 files changed, 50 insertions(+)
>>
>> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
>> index f75f61127277..520999994ba8 100644
>> --- a/drivers/vfio/pci/vfio_pci.c
>> +++ b/drivers/vfio/pci/vfio_pci.c
>> @@ -30,6 +30,7 @@
>>  #include <linux/vfio.h>
>>  #include <linux/vgaarb.h>
>>  #include <linux/nospec.h>
>> +#include <linux/circ_buf.h>
>>  
>>  #include "vfio_pci_private.h"
>>  
>> @@ -296,6 +297,46 @@ static const struct vfio_pci_regops vfio_pci_fault_prod_regops = {
>>  	.add_capability = vfio_pci_fault_prod_add_capability,
>>  };
>>  
>> +int vfio_pci_iommu_dev_fault_handler(struct iommu_fault_event *evt, void *data)
>> +{
>> +	struct vfio_pci_device *vdev = (struct vfio_pci_device *) data;
>> +	struct vfio_region_fault_prod *prod_region =
>> +		(struct vfio_region_fault_prod *)vdev->fault_pages;
>> +	struct vfio_region_fault_cons *cons_region =
>> +		(struct vfio_region_fault_cons *)(vdev->fault_pages + 2 * PAGE_SIZE);
>> +	struct iommu_fault *new =
>> +		(struct iommu_fault *)(vdev->fault_pages + prod_region->offset +
>> +			prod_region->prod * prod_region->entry_size);
>> +	int prod, cons, size;
>> +
>> +	mutex_lock(&vdev->fault_queue_lock);
>> +
>> +	if (!vdev->fault_abi)
>> +		goto unlock;
>> +
>> +	prod = prod_region->prod;
>> +	cons = cons_region->cons;
>> +	size = prod_region->nb_entries;
>> +
>> +	if (CIRC_SPACE(prod, cons, size) < 1)
>> +		goto unlock;
>> +
>> +	*new = evt->fault;
>> +	prod = (prod + 1) % size;
>> +	prod_region->prod = prod;
>> +	mutex_unlock(&vdev->fault_queue_lock);
>> +
>> +	mutex_lock(&vdev->igate);
>> +	if (vdev->dma_fault_trigger)
>> +		eventfd_signal(vdev->dma_fault_trigger, 1);
>> +	mutex_unlock(&vdev->igate);
>> +	return 0;
>> +
>> +unlock:
>> +	mutex_unlock(&vdev->fault_queue_lock);
>> +	return -EINVAL;
>> +}
>> +
>>  static int vfio_pci_init_fault_region(struct vfio_pci_device *vdev)
>>  {
>>  	struct vfio_region_fault_prod *header;
>> @@ -328,6 +369,13 @@ static int vfio_pci_init_fault_region(struct vfio_pci_device *vdev)
>>  	header = (struct vfio_region_fault_prod *)vdev->fault_pages;
>>  	header->version = -1;
>>  	header->offset = PAGE_SIZE;
>> +
>> +	ret = iommu_register_device_fault_handler(&vdev->pdev->dev,
>> +					vfio_pci_iommu_dev_fault_handler,
>> +					vdev);
>> +	if (ret)
>> +		goto out;
>> +
>>  	return 0;
>>  out:
>>  	kfree(vdev->fault_pages);
>> @@ -570,6 +618,7 @@ static void vfio_pci_release(void *device_data)
>>  	if (!(--vdev->refcnt)) {
>>  		vfio_spapr_pci_eeh_release(vdev->pdev);
>>  		vfio_pci_disable(vdev);
>> +		iommu_unregister_device_fault_handler(&vdev->pdev->dev);
> 
> 
> But this can fail if there are pending faults which leaves a device
> reference and then the system is broken :(
This series only features unrecoverable errors and for those the
unregistration cannot fail. Now unrecoverable errors were added I admit
this is confusing. We need to sort this out or clean the dependencies.

Thanks

Eric
> 
>>  	}
>>  
>>  	mutex_unlock(&vdev->reflck->lock);
>> diff --git a/drivers/vfio/pci/vfio_pci_private.h b/drivers/vfio/pci/vfio_pci_private.h
>> index 8e0a55682d3f..a9276926f008 100644
>> --- a/drivers/vfio/pci/vfio_pci_private.h
>> +++ b/drivers/vfio/pci/vfio_pci_private.h
>> @@ -122,6 +122,7 @@ struct vfio_pci_device {
>>  	int			ioeventfds_nr;
>>  	struct eventfd_ctx	*err_trigger;
>>  	struct eventfd_ctx	*req_trigger;
>> +	struct eventfd_ctx	*dma_fault_trigger;
>>  	struct mutex		fault_queue_lock;
>>  	int			fault_abi;
>>  	struct list_head	dummy_resources_list;
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
