Return-Path: <SRS0=VRSS=UC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72BCDC04AB5
	for <kvmarm@archiver.kernel.org>; Mon,  3 Jun 2019 22:31:49 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 38D8026A5D
	for <kvmarm@archiver.kernel.org>; Mon,  3 Jun 2019 22:31:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 38D8026A5D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D138E4A479;
	Mon,  3 Jun 2019 18:31:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id AqoFDfcaqbq1; Mon,  3 Jun 2019 18:31:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AF1604A4CA;
	Mon,  3 Jun 2019 18:31:46 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5F29D4A4BD
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Jun 2019 18:31:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 96rKrqcCfZj0 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  3 Jun 2019 18:31:44 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 528984A47A
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Jun 2019 18:31:44 -0400 (EDT)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
 [10.5.11.22])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mx1.redhat.com (Postfix) with ESMTPS id 9CED13082B63;
 Mon,  3 Jun 2019 22:31:43 +0000 (UTC)
Received: from x1.home (ovpn-116-22.phx2.redhat.com [10.3.116.22])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 8A2591001DE0;
 Mon,  3 Jun 2019 22:31:40 +0000 (UTC)
Date: Mon, 3 Jun 2019 16:31:39 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Eric Auger <eric.auger@redhat.com>
Subject: Re: [PATCH v8 26/29] vfio-pci: Register an iommu fault handler
Message-ID: <20190603163139.70fe8839@x1.home>
In-Reply-To: <20190526161004.25232-27-eric.auger@redhat.com>
References: <20190526161004.25232-1-eric.auger@redhat.com>
 <20190526161004.25232-27-eric.auger@redhat.com>
Organization: Red Hat
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16
 (mx1.redhat.com [10.5.110.45]); Mon, 03 Jun 2019 22:31:43 +0000 (UTC)
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

On Sun, 26 May 2019 18:10:01 +0200
Eric Auger <eric.auger@redhat.com> wrote:

> This patch registers a fault handler which records faults in
> a circular buffer and then signals an eventfd. This buffer is
> exposed within the fault region.
> 
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> 
> ---
> 
> v3 -> v4:
> - move iommu_unregister_device_fault_handler to vfio_pci_release
> ---
>  drivers/vfio/pci/vfio_pci.c         | 49 +++++++++++++++++++++++++++++
>  drivers/vfio/pci/vfio_pci_private.h |  1 +
>  2 files changed, 50 insertions(+)
> 
> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> index f75f61127277..520999994ba8 100644
> --- a/drivers/vfio/pci/vfio_pci.c
> +++ b/drivers/vfio/pci/vfio_pci.c
> @@ -30,6 +30,7 @@
>  #include <linux/vfio.h>
>  #include <linux/vgaarb.h>
>  #include <linux/nospec.h>
> +#include <linux/circ_buf.h>
>  
>  #include "vfio_pci_private.h"
>  
> @@ -296,6 +297,46 @@ static const struct vfio_pci_regops vfio_pci_fault_prod_regops = {
>  	.add_capability = vfio_pci_fault_prod_add_capability,
>  };
>  
> +int vfio_pci_iommu_dev_fault_handler(struct iommu_fault_event *evt, void *data)
> +{
> +	struct vfio_pci_device *vdev = (struct vfio_pci_device *) data;
> +	struct vfio_region_fault_prod *prod_region =
> +		(struct vfio_region_fault_prod *)vdev->fault_pages;
> +	struct vfio_region_fault_cons *cons_region =
> +		(struct vfio_region_fault_cons *)(vdev->fault_pages + 2 * PAGE_SIZE);
> +	struct iommu_fault *new =
> +		(struct iommu_fault *)(vdev->fault_pages + prod_region->offset +
> +			prod_region->prod * prod_region->entry_size);
> +	int prod, cons, size;
> +
> +	mutex_lock(&vdev->fault_queue_lock);
> +
> +	if (!vdev->fault_abi)
> +		goto unlock;
> +
> +	prod = prod_region->prod;
> +	cons = cons_region->cons;
> +	size = prod_region->nb_entries;
> +
> +	if (CIRC_SPACE(prod, cons, size) < 1)
> +		goto unlock;
> +
> +	*new = evt->fault;
> +	prod = (prod + 1) % size;
> +	prod_region->prod = prod;
> +	mutex_unlock(&vdev->fault_queue_lock);
> +
> +	mutex_lock(&vdev->igate);
> +	if (vdev->dma_fault_trigger)
> +		eventfd_signal(vdev->dma_fault_trigger, 1);
> +	mutex_unlock(&vdev->igate);
> +	return 0;
> +
> +unlock:
> +	mutex_unlock(&vdev->fault_queue_lock);
> +	return -EINVAL;
> +}
> +
>  static int vfio_pci_init_fault_region(struct vfio_pci_device *vdev)
>  {
>  	struct vfio_region_fault_prod *header;
> @@ -328,6 +369,13 @@ static int vfio_pci_init_fault_region(struct vfio_pci_device *vdev)
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
> @@ -570,6 +618,7 @@ static void vfio_pci_release(void *device_data)
>  	if (!(--vdev->refcnt)) {
>  		vfio_spapr_pci_eeh_release(vdev->pdev);
>  		vfio_pci_disable(vdev);
> +		iommu_unregister_device_fault_handler(&vdev->pdev->dev);


But this can fail if there are pending faults which leaves a device
reference and then the system is broken :(

>  	}
>  
>  	mutex_unlock(&vdev->reflck->lock);
> diff --git a/drivers/vfio/pci/vfio_pci_private.h b/drivers/vfio/pci/vfio_pci_private.h
> index 8e0a55682d3f..a9276926f008 100644
> --- a/drivers/vfio/pci/vfio_pci_private.h
> +++ b/drivers/vfio/pci/vfio_pci_private.h
> @@ -122,6 +122,7 @@ struct vfio_pci_device {
>  	int			ioeventfds_nr;
>  	struct eventfd_ctx	*err_trigger;
>  	struct eventfd_ctx	*req_trigger;
> +	struct eventfd_ctx	*dma_fault_trigger;
>  	struct mutex		fault_queue_lock;
>  	int			fault_abi;
>  	struct list_head	dummy_resources_list;

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
