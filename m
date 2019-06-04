Return-Path: <SRS0=jSi8=UD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9672C282CE
	for <kvmarm@archiver.kernel.org>; Tue,  4 Jun 2019 16:11:58 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7FC1520851
	for <kvmarm@archiver.kernel.org>; Tue,  4 Jun 2019 16:11:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7FC1520851
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 35C064A4F4;
	Tue,  4 Jun 2019 12:11:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xkp9ZL0geLTn; Tue,  4 Jun 2019 12:11:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ED4C64A503;
	Tue,  4 Jun 2019 12:11:56 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4B4C24A503
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Jun 2019 12:11:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oE4XTEt5kXpZ for <kvmarm@lists.cs.columbia.edu>;
 Tue,  4 Jun 2019 12:11:55 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1C6564A51E
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Jun 2019 12:11:55 -0400 (EDT)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
 [10.5.11.22])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mx1.redhat.com (Postfix) with ESMTPS id 0EB493001757;
 Tue,  4 Jun 2019 16:11:27 +0000 (UTC)
Received: from [10.36.116.67] (ovpn-116-67.ams2.redhat.com [10.36.116.67])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0E74A1001DFD;
 Tue,  4 Jun 2019 16:11:11 +0000 (UTC)
Subject: Re: [PATCH v8 28/29] vfio-pci: Add VFIO_PCI_DMA_FAULT_IRQ_INDEX
To: Alex Williamson <alex.williamson@redhat.com>
References: <20190526161004.25232-1-eric.auger@redhat.com>
 <20190526161004.25232-29-eric.auger@redhat.com>
 <20190603163130.3f7497ba@x1.home>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <7ba39c76-0b4d-b94f-c516-6414189698f6@redhat.com>
Date: Tue, 4 Jun 2019 18:11:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190603163130.3f7497ba@x1.home>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16
 (mx1.redhat.com [10.5.110.46]); Tue, 04 Jun 2019 16:11:49 +0000 (UTC)
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
> On Sun, 26 May 2019 18:10:03 +0200
> Eric Auger <eric.auger@redhat.com> wrote:
> 
>> Add a new VFIO_PCI_DMA_FAULT_IRQ_INDEX index. This allows to
>> set/unset an eventfd that will be triggered when DMA translation
>> faults are detected at physical level when the nested mode is used.
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>> ---
>>  drivers/vfio/pci/vfio_pci.c       |  3 +++
>>  drivers/vfio/pci/vfio_pci_intrs.c | 19 +++++++++++++++++++
>>  include/uapi/linux/vfio.h         |  1 +
>>  3 files changed, 23 insertions(+)
> 
> 
> Note that I suggested to Intel folks trying to add a GVT-g page
> flipping eventfd to convert to device specific interrupts the same way
> we added device specific regions:
> 
> https://patchwork.kernel.org/patch/10962337/
> 
> I'd probably suggest the same here so we can optionally expose it when
> supported.  Thanks,

Agreed, I will follow the other thread.

Thanks

Eric
> 
> Alex
> 
>> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
>> index a9c8af2a774a..65a1e6814f5c 100644
>> --- a/drivers/vfio/pci/vfio_pci.c
>> +++ b/drivers/vfio/pci/vfio_pci.c
>> @@ -746,6 +746,8 @@ static int vfio_pci_get_irq_count(struct vfio_pci_device *vdev, int irq_type)
>>  			return 1;
>>  	} else if (irq_type == VFIO_PCI_REQ_IRQ_INDEX) {
>>  		return 1;
>> +	} else if (irq_type == VFIO_PCI_DMA_FAULT_IRQ_INDEX) {
>> +		return 1;
>>  	}
>>  
>>  	return 0;
>> @@ -1082,6 +1084,7 @@ static long vfio_pci_ioctl(void *device_data,
>>  		switch (info.index) {
>>  		case VFIO_PCI_INTX_IRQ_INDEX ... VFIO_PCI_MSIX_IRQ_INDEX:
>>  		case VFIO_PCI_REQ_IRQ_INDEX:
>> +		case VFIO_PCI_DMA_FAULT_IRQ_INDEX:
>>  			break;
>>  		case VFIO_PCI_ERR_IRQ_INDEX:
>>  			if (pci_is_pcie(vdev->pdev))
>> diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
>> index 1c46045b0e7f..28a96117daf3 100644
>> --- a/drivers/vfio/pci/vfio_pci_intrs.c
>> +++ b/drivers/vfio/pci/vfio_pci_intrs.c
>> @@ -622,6 +622,18 @@ static int vfio_pci_set_req_trigger(struct vfio_pci_device *vdev,
>>  					       count, flags, data);
>>  }
>>  
>> +static int vfio_pci_set_dma_fault_trigger(struct vfio_pci_device *vdev,
>> +					  unsigned index, unsigned start,
>> +					  unsigned count, uint32_t flags,
>> +					  void *data)
>> +{
>> +	if (index != VFIO_PCI_DMA_FAULT_IRQ_INDEX || start != 0 || count > 1)
>> +		return -EINVAL;
>> +
>> +	return vfio_pci_set_ctx_trigger_single(&vdev->dma_fault_trigger,
>> +					       count, flags, data);
>> +}
>> +
>>  int vfio_pci_set_irqs_ioctl(struct vfio_pci_device *vdev, uint32_t flags,
>>  			    unsigned index, unsigned start, unsigned count,
>>  			    void *data)
>> @@ -671,6 +683,13 @@ int vfio_pci_set_irqs_ioctl(struct vfio_pci_device *vdev, uint32_t flags,
>>  			break;
>>  		}
>>  		break;
>> +	case VFIO_PCI_DMA_FAULT_IRQ_INDEX:
>> +		switch (flags & VFIO_IRQ_SET_ACTION_TYPE_MASK) {
>> +		case VFIO_IRQ_SET_ACTION_TRIGGER:
>> +			func = vfio_pci_set_dma_fault_trigger;
>> +			break;
>> +		}
>> +		break;
>>  	}
>>  
>>  	if (!func)
>> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
>> index 13e041b84d48..66b6b08c4a38 100644
>> --- a/include/uapi/linux/vfio.h
>> +++ b/include/uapi/linux/vfio.h
>> @@ -559,6 +559,7 @@ enum {
>>  	VFIO_PCI_MSIX_IRQ_INDEX,
>>  	VFIO_PCI_ERR_IRQ_INDEX,
>>  	VFIO_PCI_REQ_IRQ_INDEX,
>> +	VFIO_PCI_DMA_FAULT_IRQ_INDEX,
>>  	VFIO_PCI_NUM_IRQS
>>  };
>>  
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
