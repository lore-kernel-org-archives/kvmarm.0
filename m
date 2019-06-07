Return-Path: <SRS0=SHHE=UG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2188AC2BCA1
	for <kvmarm@archiver.kernel.org>; Fri,  7 Jun 2019 12:48:38 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D881E208C3
	for <kvmarm@archiver.kernel.org>; Fri,  7 Jun 2019 12:48:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D881E208C3
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 729E74A4E6;
	Fri,  7 Jun 2019 08:48:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id kvAPEqTApYYb; Fri,  7 Jun 2019 08:48:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 49C854A418;
	Fri,  7 Jun 2019 08:48:36 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 222C54A3BF
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Jun 2019 08:48:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OZfvjYnH-0qH for <kvmarm@lists.cs.columbia.edu>;
 Fri,  7 Jun 2019 08:48:33 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D54644A389
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Jun 2019 08:48:33 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 77A82499;
 Fri,  7 Jun 2019 05:48:33 -0700 (PDT)
Received: from [10.1.196.129] (ostrya.cambridge.arm.com [10.1.196.129])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 734AA40151;
 Fri,  7 Jun 2019 05:48:31 -0700 (PDT)
Subject: Re: [PATCH v8 26/29] vfio-pci: Register an iommu fault handler
To: Eric Auger <eric.auger@redhat.com>,
 "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
 "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
 "joro@8bytes.org" <joro@8bytes.org>,
 "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
 "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
 "yi.l.liu@intel.com" <yi.l.liu@intel.com>, Will Deacon
 <Will.Deacon@arm.com>, Robin Murphy <Robin.Murphy@arm.com>
References: <20190526161004.25232-1-eric.auger@redhat.com>
 <20190526161004.25232-27-eric.auger@redhat.com>
From: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Message-ID: <63b37149-1f74-bca1-35ea-5e849c0c2bbb@arm.com>
Date: Fri, 7 Jun 2019 13:48:07 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190526161004.25232-27-eric.auger@redhat.com>
Content-Language: en-US
Cc: Marc Zyngier <Marc.Zyngier@arm.com>,
 "kevin.tian@intel.com" <kevin.tian@intel.com>,
 Vincent Stehle <Vincent.Stehle@arm.com>,
 "ashok.raj@intel.com" <ashok.raj@intel.com>
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

On 26/05/2019 17:10, Eric Auger wrote:
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

Could you check fault.type and return an error if it's not UNRECOV here?
If the fault is recoverable (very unlikely since the PRI capability is
disabled, but allowed) and we return an error here, then the caller
takes care of completing the fault. If we forward it to the guest
instead, the producer will wait indefinitely for a response.

Thanks,
Jean

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
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
