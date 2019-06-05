Return-Path: <SRS0=9SrU=UE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AF69C28CC5
	for <kvmarm@archiver.kernel.org>; Wed,  5 Jun 2019 22:42:55 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CA89B2083E
	for <kvmarm@archiver.kernel.org>; Wed,  5 Jun 2019 22:42:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CA89B2083E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2BD4A4A4E8;
	Wed,  5 Jun 2019 18:42:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UItMBCx3M1KS; Wed,  5 Jun 2019 18:42:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 058654A3A3;
	Wed,  5 Jun 2019 18:42:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B18764A3A3
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Jun 2019 18:42:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FoT0exlcjlYq for <kvmarm@lists.cs.columbia.edu>;
 Wed,  5 Jun 2019 18:42:50 -0400 (EDT)
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 091034A36B
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Jun 2019 18:42:49 -0400 (EDT)
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
 by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384;
 05 Jun 2019 15:42:48 -0700
X-ExtLoop1: 1
Received: from jacob-builder.jf.intel.com (HELO jacob-builder) ([10.7.199.155])
 by orsmga002.jf.intel.com with ESMTP; 05 Jun 2019 15:42:48 -0700
Date: Wed, 5 Jun 2019 15:45:53 -0700
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH v8 26/29] vfio-pci: Register an iommu fault handler
Message-ID: <20190605154553.0d00ad8d@jacob-builder>
In-Reply-To: <10dd60d9-4af0-c0eb-08c9-a0db7ee1925e@redhat.com>
References: <20190526161004.25232-1-eric.auger@redhat.com>
 <20190526161004.25232-27-eric.auger@redhat.com>
 <20190603163139.70fe8839@x1.home>
 <10dd60d9-4af0-c0eb-08c9-a0db7ee1925e@redhat.com>
Organization: OTC
X-Mailer: Claws Mail 3.13.2 (GTK+ 2.24.30; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Cc: jacob.jun.pan@linux.intel.com, kevin.tian@intel.com, yi.l.liu@intel.com,
 ashok.raj@intel.com, kvm@vger.kernel.org, joro@8bytes.org, will.deacon@arm.com,
 linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
 marc.zyngier@arm.com, Alex Williamson <alex.williamson@redhat.com>,
 vincent.stehle@arm.com, robin.murphy@arm.com, kvmarm@lists.cs.columbia.edu,
 eric.auger.pro@gmail.com
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

On Tue, 4 Jun 2019 18:11:08 +0200
Auger Eric <eric.auger@redhat.com> wrote:

> Hi Alex,
> 
> On 6/4/19 12:31 AM, Alex Williamson wrote:
> > On Sun, 26 May 2019 18:10:01 +0200
> > Eric Auger <eric.auger@redhat.com> wrote:
> >   
> >> This patch registers a fault handler which records faults in
> >> a circular buffer and then signals an eventfd. This buffer is
> >> exposed within the fault region.
> >>
> >> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> >>
> >> ---
> >>
> >> v3 -> v4:
> >> - move iommu_unregister_device_fault_handler to vfio_pci_release
> >> ---
> >>  drivers/vfio/pci/vfio_pci.c         | 49
> >> +++++++++++++++++++++++++++++ drivers/vfio/pci/vfio_pci_private.h
> >> |  1 + 2 files changed, 50 insertions(+)
> >>
> >> diff --git a/drivers/vfio/pci/vfio_pci.c
> >> b/drivers/vfio/pci/vfio_pci.c index f75f61127277..520999994ba8
> >> 100644 --- a/drivers/vfio/pci/vfio_pci.c
> >> +++ b/drivers/vfio/pci/vfio_pci.c
> >> @@ -30,6 +30,7 @@
> >>  #include <linux/vfio.h>
> >>  #include <linux/vgaarb.h>
> >>  #include <linux/nospec.h>
> >> +#include <linux/circ_buf.h>
> >>  
> >>  #include "vfio_pci_private.h"
> >>  
> >> @@ -296,6 +297,46 @@ static const struct vfio_pci_regops
> >> vfio_pci_fault_prod_regops = { .add_capability =
> >> vfio_pci_fault_prod_add_capability, };
> >>  
> >> +int vfio_pci_iommu_dev_fault_handler(struct iommu_fault_event
> >> *evt, void *data) +{
> >> +	struct vfio_pci_device *vdev = (struct vfio_pci_device *)
> >> data;
> >> +	struct vfio_region_fault_prod *prod_region =
> >> +		(struct vfio_region_fault_prod
> >> *)vdev->fault_pages;
> >> +	struct vfio_region_fault_cons *cons_region =
> >> +		(struct vfio_region_fault_cons
> >> *)(vdev->fault_pages + 2 * PAGE_SIZE);
> >> +	struct iommu_fault *new =
> >> +		(struct iommu_fault *)(vdev->fault_pages +
> >> prod_region->offset +
> >> +			prod_region->prod *
> >> prod_region->entry_size);
> >> +	int prod, cons, size;
> >> +
> >> +	mutex_lock(&vdev->fault_queue_lock);
> >> +
> >> +	if (!vdev->fault_abi)
> >> +		goto unlock;
> >> +
> >> +	prod = prod_region->prod;
> >> +	cons = cons_region->cons;
> >> +	size = prod_region->nb_entries;
> >> +
> >> +	if (CIRC_SPACE(prod, cons, size) < 1)
> >> +		goto unlock;
> >> +
> >> +	*new = evt->fault;
> >> +	prod = (prod + 1) % size;
> >> +	prod_region->prod = prod;
> >> +	mutex_unlock(&vdev->fault_queue_lock);
> >> +
> >> +	mutex_lock(&vdev->igate);
> >> +	if (vdev->dma_fault_trigger)
> >> +		eventfd_signal(vdev->dma_fault_trigger, 1);
> >> +	mutex_unlock(&vdev->igate);
> >> +	return 0;
> >> +
> >> +unlock:
> >> +	mutex_unlock(&vdev->fault_queue_lock);
> >> +	return -EINVAL;
> >> +}
> >> +
> >>  static int vfio_pci_init_fault_region(struct vfio_pci_device
> >> *vdev) {
> >>  	struct vfio_region_fault_prod *header;
> >> @@ -328,6 +369,13 @@ static int vfio_pci_init_fault_region(struct
> >> vfio_pci_device *vdev) header = (struct vfio_region_fault_prod
> >> *)vdev->fault_pages; header->version = -1;
> >>  	header->offset = PAGE_SIZE;
> >> +
> >> +	ret =
> >> iommu_register_device_fault_handler(&vdev->pdev->dev,
> >> +
> >> vfio_pci_iommu_dev_fault_handler,
> >> +					vdev);
> >> +	if (ret)
> >> +		goto out;
> >> +
> >>  	return 0;
> >>  out:
> >>  	kfree(vdev->fault_pages);
> >> @@ -570,6 +618,7 @@ static void vfio_pci_release(void *device_data)
> >>  	if (!(--vdev->refcnt)) {
> >>  		vfio_spapr_pci_eeh_release(vdev->pdev);
> >>  		vfio_pci_disable(vdev);
> >> +
> >> iommu_unregister_device_fault_handler(&vdev->pdev->dev);  
> > 
> > 
> > But this can fail if there are pending faults which leaves a device
> > reference and then the system is broken :(  
> This series only features unrecoverable errors and for those the
> unregistration cannot fail. Now unrecoverable errors were added I
> admit this is confusing. We need to sort this out or clean the
> dependencies.
As Alex pointed out in 4/29, we can make
iommu_unregister_device_fault_handler() never fail and clean up all the
pending faults in the host IOMMU belong to that device. But the problem
is that if a fault, such as PRQ, has already been injected into the
guest, the page response may come back after handler is unregistered
and registered again. We need a way to reject such page response belong
to the previous life of the handler. Perhaps a sync call to the guest
with your fault queue eventfd? I am not sure.

Jacob
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
