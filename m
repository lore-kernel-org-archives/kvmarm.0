Return-Path: <SRS0=SHHE=UG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6B28C28CC3
	for <kvmarm@archiver.kernel.org>; Fri,  7 Jun 2019 07:03:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 46C3E208C3
	for <kvmarm@archiver.kernel.org>; Fri,  7 Jun 2019 07:03:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 46C3E208C3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A7AE04A4E1;
	Fri,  7 Jun 2019 03:03:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id x4v+PQWfah0x; Fri,  7 Jun 2019 03:03:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CB6444A4BE;
	Fri,  7 Jun 2019 03:03:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3EB7A4A4BE
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Jun 2019 03:03:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MlMCgfDLB0dr for <kvmarm@lists.cs.columbia.edu>;
 Fri,  7 Jun 2019 03:03:11 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 290074A380
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Jun 2019 03:03:11 -0400 (EDT)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
 [10.5.11.13])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mx1.redhat.com (Postfix) with ESMTPS id 1DFC6C1EB214;
 Fri,  7 Jun 2019 07:02:52 +0000 (UTC)
Received: from [10.36.116.67] (ovpn-116-67.ams2.redhat.com [10.36.116.67])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id ECBA9783A4;
 Fri,  7 Jun 2019 07:02:41 +0000 (UTC)
Subject: Re: [PATCH v8 26/29] vfio-pci: Register an iommu fault handler
To: Jacob Pan <jacob.jun.pan@linux.intel.com>,
 Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
References: <20190526161004.25232-1-eric.auger@redhat.com>
 <20190526161004.25232-27-eric.auger@redhat.com>
 <20190603163139.70fe8839@x1.home>
 <10dd60d9-4af0-c0eb-08c9-a0db7ee1925e@redhat.com>
 <20190605154553.0d00ad8d@jacob-builder>
 <2753d192-1c46-d78e-c425-0c828e48cde2@arm.com>
 <20190606132903.064f7ac4@jacob-builder>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <10905d2d-16a5-7d6f-2db3-9cca10c3bde0@redhat.com>
Date: Fri, 7 Jun 2019 09:02:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190606132903.064f7ac4@jacob-builder>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16
 (mx1.redhat.com [10.5.110.32]); Fri, 07 Jun 2019 07:03:06 +0000 (UTC)
Cc: "kevin.tian@intel.com" <kevin.tian@intel.com>,
 "yi.l.liu@intel.com" <yi.l.liu@intel.com>,
 "ashok.raj@intel.com" <ashok.raj@intel.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 Marc Zyngier <Marc.Zyngier@arm.com>, "joro@8bytes.org" <joro@8bytes.org>,
 Will Deacon <Will.Deacon@arm.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
 Alex Williamson <alex.williamson@redhat.com>,
 Vincent Stehle <Vincent.Stehle@arm.com>, Robin Murphy <Robin.Murphy@arm.com>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
 "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>
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

Hi Jean, Jacob,

On 6/6/19 10:29 PM, Jacob Pan wrote:
> On Thu, 6 Jun 2019 19:54:05 +0100
> Jean-Philippe Brucker <jean-philippe.brucker@arm.com> wrote:
> 
>> On 05/06/2019 23:45, Jacob Pan wrote:
>>> On Tue, 4 Jun 2019 18:11:08 +0200
>>> Auger Eric <eric.auger@redhat.com> wrote:
>>>   
>>>> Hi Alex,
>>>>
>>>> On 6/4/19 12:31 AM, Alex Williamson wrote:  
>>>>> On Sun, 26 May 2019 18:10:01 +0200
>>>>> Eric Auger <eric.auger@redhat.com> wrote:
>>>>>     
>>>>>> This patch registers a fault handler which records faults in
>>>>>> a circular buffer and then signals an eventfd. This buffer is
>>>>>> exposed within the fault region.
>>>>>>
>>>>>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>>>>>>
>>>>>> ---
>>>>>>
>>>>>> v3 -> v4:
>>>>>> - move iommu_unregister_device_fault_handler to vfio_pci_release
>>>>>> ---
>>>>>>  drivers/vfio/pci/vfio_pci.c         | 49
>>>>>> +++++++++++++++++++++++++++++ drivers/vfio/pci/vfio_pci_private.h
>>>>>> |  1 + 2 files changed, 50 insertions(+)
>>>>>>
>>>>>> diff --git a/drivers/vfio/pci/vfio_pci.c
>>>>>> b/drivers/vfio/pci/vfio_pci.c index f75f61127277..520999994ba8
>>>>>> 100644 --- a/drivers/vfio/pci/vfio_pci.c
>>>>>> +++ b/drivers/vfio/pci/vfio_pci.c
>>>>>> @@ -30,6 +30,7 @@
>>>>>>  #include <linux/vfio.h>
>>>>>>  #include <linux/vgaarb.h>
>>>>>>  #include <linux/nospec.h>
>>>>>> +#include <linux/circ_buf.h>
>>>>>>  
>>>>>>  #include "vfio_pci_private.h"
>>>>>>  
>>>>>> @@ -296,6 +297,46 @@ static const struct vfio_pci_regops
>>>>>> vfio_pci_fault_prod_regops = { .add_capability =
>>>>>> vfio_pci_fault_prod_add_capability, };
>>>>>>  
>>>>>> +int vfio_pci_iommu_dev_fault_handler(struct iommu_fault_event
>>>>>> *evt, void *data) +{
>>>>>> +	struct vfio_pci_device *vdev = (struct vfio_pci_device
>>>>>> *) data;
>>>>>> +	struct vfio_region_fault_prod *prod_region =
>>>>>> +		(struct vfio_region_fault_prod
>>>>>> *)vdev->fault_pages;
>>>>>> +	struct vfio_region_fault_cons *cons_region =
>>>>>> +		(struct vfio_region_fault_cons
>>>>>> *)(vdev->fault_pages + 2 * PAGE_SIZE);
>>>>>> +	struct iommu_fault *new =
>>>>>> +		(struct iommu_fault *)(vdev->fault_pages +
>>>>>> prod_region->offset +
>>>>>> +			prod_region->prod *
>>>>>> prod_region->entry_size);
>>>>>> +	int prod, cons, size;
>>>>>> +
>>>>>> +	mutex_lock(&vdev->fault_queue_lock);
>>>>>> +
>>>>>> +	if (!vdev->fault_abi)
>>>>>> +		goto unlock;
>>>>>> +
>>>>>> +	prod = prod_region->prod;
>>>>>> +	cons = cons_region->cons;
>>>>>> +	size = prod_region->nb_entries;
>>>>>> +
>>>>>> +	if (CIRC_SPACE(prod, cons, size) < 1)
>>>>>> +		goto unlock;
>>>>>> +
>>>>>> +	*new = evt->fault;
>>>>>> +	prod = (prod + 1) % size;
>>>>>> +	prod_region->prod = prod;
>>>>>> +	mutex_unlock(&vdev->fault_queue_lock);
>>>>>> +
>>>>>> +	mutex_lock(&vdev->igate);
>>>>>> +	if (vdev->dma_fault_trigger)
>>>>>> +		eventfd_signal(vdev->dma_fault_trigger, 1);
>>>>>> +	mutex_unlock(&vdev->igate);
>>>>>> +	return 0;
>>>>>> +
>>>>>> +unlock:
>>>>>> +	mutex_unlock(&vdev->fault_queue_lock);
>>>>>> +	return -EINVAL;
>>>>>> +}
>>>>>> +
>>>>>>  static int vfio_pci_init_fault_region(struct vfio_pci_device
>>>>>> *vdev) {
>>>>>>  	struct vfio_region_fault_prod *header;
>>>>>> @@ -328,6 +369,13 @@ static int vfio_pci_init_fault_region(struct
>>>>>> vfio_pci_device *vdev) header = (struct vfio_region_fault_prod
>>>>>> *)vdev->fault_pages; header->version = -1;
>>>>>>  	header->offset = PAGE_SIZE;
>>>>>> +
>>>>>> +	ret =
>>>>>> iommu_register_device_fault_handler(&vdev->pdev->dev,
>>>>>> +
>>>>>> vfio_pci_iommu_dev_fault_handler,
>>>>>> +					vdev);
>>>>>> +	if (ret)
>>>>>> +		goto out;
>>>>>> +
>>>>>>  	return 0;
>>>>>>  out:
>>>>>>  	kfree(vdev->fault_pages);
>>>>>> @@ -570,6 +618,7 @@ static void vfio_pci_release(void
>>>>>> *device_data) if (!(--vdev->refcnt)) {
>>>>>>  		vfio_spapr_pci_eeh_release(vdev->pdev);
>>>>>>  		vfio_pci_disable(vdev);
>>>>>> +
>>>>>> iommu_unregister_device_fault_handler(&vdev->pdev->dev);    
>>>>>
>>>>>
>>>>> But this can fail if there are pending faults which leaves a
>>>>> device reference and then the system is broken :(    
>>>> This series only features unrecoverable errors and for those the
>>>> unregistration cannot fail. Now unrecoverable errors were added I
>>>> admit this is confusing. We need to sort this out or clean the
>>>> dependencies.  
>>> As Alex pointed out in 4/29, we can make
>>> iommu_unregister_device_fault_handler() never fail and clean up all
>>> the pending faults in the host IOMMU belong to that device. But the
>>> problem is that if a fault, such as PRQ, has already been injected
>>> into the guest, the page response may come back after handler is
>>> unregistered and registered again.  
>>
>> I'm trying to figure out if that would be harmful in any way. I guess
>> it can be a bit nasty if we handle the page response right after
>> having injected a new page request that uses the same PRGI. In any
>> other case we discard the page response, but here we forward it to
>> the endpoint and:
>>
>> * If the response status is success, endpoint retries the
>> translation. The guest probably hasn't had time to handle the new
>> page request and translation will fail, which may lead the endpoint
>> to give up (two unsuccessful translation requests). Or send a new
>> request
>>
> Good point, there shouldn't be any harm if the page response is a
> "fake" success. In fact it could happen in the normal operation when
> PRQs to two devices share the same non-leaf translation structure. The
> worst case is just a retry. I am not aware of the retry limit, is it in
> the PCIe spec? I cannot find it.
> 
> I think we should just document it, similar to having a spurious
> interrupt. The PRQ trace event should capture that as well.
> 
>> * otherwise the endpoint won't retry the access, and could also
>> disable PRI if the status is failure.
>>
> That would be true regardless this race condition with handler
> registration. So should be fine.
> 
>>> We need a way to reject such page response belong
>>> to the previous life of the handler. Perhaps a sync call to the
>>> guest with your fault queue eventfd? I am not sure.  
>>
>> We could simply expect the device driver not to send any page response
>> after unregistering the fault handler. Is there any reason VFIO would
>> need to unregister and re-register the fault handler on a live guest?
>>
> There is no reason for VFIO to unregister and register again, I was
> just thinking from security perspective. Someone could write a VFIO app
> do this attack. But I agree the damage is within the device, may get
> PRI disabled as a result.

At the moment the handler unregistration is done on the vfio-pci release
function() when the last reference is released so I am not sure this can
even be achieved.
> 
> So it seems we agree on the following:
> - iommu_unregister_device_fault_handler() will never fail
> - iommu driver cleans up all pending faults when handler is unregistered
> - assume device driver or guest not sending more page response _after_
>   handler is unregistered.
> - system will tolerate rare spurious response
> 
> Sounds right?

sounds good for me

Thanks

Eric
> 
>> Thanks,
>> Jean
> 
> [Jacob Pan]
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
