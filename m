Return-Path: <SRS0=jSi8=UD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0E80C282CE
	for <kvmarm@archiver.kernel.org>; Tue,  4 Jun 2019 15:45:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 80A3720717
	for <kvmarm@archiver.kernel.org>; Tue,  4 Jun 2019 15:45:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 80A3720717
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DB2D14A527;
	Tue,  4 Jun 2019 11:45:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id yw2SInrGZeaT; Tue,  4 Jun 2019 11:45:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 631704A503;
	Tue,  4 Jun 2019 11:45:13 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A70E74A503
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Jun 2019 11:45:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Dh3+jHPnL99h for <kvmarm@lists.cs.columbia.edu>;
 Tue,  4 Jun 2019 11:45:11 -0400 (EDT)
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 71E7C4A4EE
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Jun 2019 11:45:10 -0400 (EDT)
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
 by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384;
 04 Jun 2019 08:45:08 -0700
X-ExtLoop1: 1
Received: from jacob-builder.jf.intel.com (HELO jacob-builder) ([10.7.199.155])
 by orsmga002.jf.intel.com with ESMTP; 04 Jun 2019 08:45:07 -0700
Date: Tue, 4 Jun 2019 08:48:12 -0700
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH v8 04/29] iommu: Add recoverable fault reporting
Message-ID: <20190604084812.1f7158ae@jacob-builder>
In-Reply-To: <20190603163145.74f25426@x1.home>
References: <20190526161004.25232-1-eric.auger@redhat.com>
 <20190526161004.25232-5-eric.auger@redhat.com>
 <20190603163145.74f25426@x1.home>
Organization: OTC
X-Mailer: Claws Mail 3.13.2 (GTK+ 2.24.30; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Cc: jacob.jun.pan@linux.intel.com, kevin.tian@intel.com, yi.l.liu@intel.com,
 ashok.raj@intel.com, kvm@vger.kernel.org, joro@8bytes.org, will.deacon@arm.com,
 linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
 vincent.stehle@arm.com, marc.zyngier@arm.com, robin.murphy@arm.com,
 kvmarm@lists.cs.columbia.edu, eric.auger.pro@gmail.com
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

On Mon, 3 Jun 2019 16:31:45 -0600
Alex Williamson <alex.williamson@redhat.com> wrote:

> On Sun, 26 May 2019 18:09:39 +0200
> Eric Auger <eric.auger@redhat.com> wrote:
> 
> > From: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
> > 
> > Some IOMMU hardware features, for example PCI's PRI and Arm SMMU's
> > Stall, enable recoverable I/O page faults. Allow IOMMU drivers to
> > report PRI Page Requests and Stall events through the new fault
> > reporting API. The consumer of the fault can be either an I/O page
> > fault handler in the host, or a guest OS.
> > 
> > Once handled, the fault must be completed by sending a page
> > response back to the IOMMU. Add an iommu_page_response() function
> > to complete a page fault.
> > 
> > Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
> > Signed-off-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
> > ---
> >  drivers/iommu/iommu.c | 77
> > ++++++++++++++++++++++++++++++++++++++++++- include/linux/iommu.h |
> > 51 ++++++++++++++++++++++++++++ 2 files changed, 127 insertions(+),
> > 1 deletion(-)
> > 
> > diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> > index 795518445a3a..13b301cfb10f 100644
> > --- a/drivers/iommu/iommu.c
> > +++ b/drivers/iommu/iommu.c
> > @@ -869,7 +869,14 @@
> > EXPORT_SYMBOL_GPL(iommu_group_unregister_notifier);
> >   * @data: private data passed as argument to the handler
> >   *
> >   * When an IOMMU fault event is received, this handler gets called
> > with the
> > - * fault event and data as argument.
> > + * fault event and data as argument. The handler should return 0
> > on success. If
> > + * the fault is recoverable (IOMMU_FAULT_PAGE_REQ), the handler
> > should also
> > + * complete the fault by calling iommu_page_response() with one of
> > the following
> > + * response code:
> > + * - IOMMU_PAGE_RESP_SUCCESS: retry the translation
> > + * - IOMMU_PAGE_RESP_INVALID: terminate the fault
> > + * - IOMMU_PAGE_RESP_FAILURE: terminate the fault and stop
> > reporting
> > + *   page faults if possible.
> >   *
> >   * Return 0 if the fault handler was installed successfully, or an
> > error. */
> > @@ -904,6 +911,8 @@ int iommu_register_device_fault_handler(struct
> > device *dev, }
> >  	param->fault_param->handler = handler;
> >  	param->fault_param->data = data;
> > +	mutex_init(&param->fault_param->lock);
> > +	INIT_LIST_HEAD(&param->fault_param->faults);
> >  
> >  done_unlock:
> >  	mutex_unlock(&param->lock);
> > @@ -934,6 +943,12 @@ int
> > iommu_unregister_device_fault_handler(struct device *dev) if
> > (!param->fault_param) goto unlock;
> >  
> > +	/* we cannot unregister handler if there are pending
> > faults */
> > +	if (!list_empty(&param->fault_param->faults)) {
> > +		ret = -EBUSY;
> > +		goto unlock;
> > +	}  
> 
> Why?  Attempting to unregister a fault handler suggests the handler
> doesn't care about outstanding faults.  Can't we go ahead and dispatch
> them as failed?  Otherwise we need to be careful that we don't
> introduce an environment where the registered fault handler is blocked
> trying to shutdown and release the device due to a flood of errors.
> Thanks,
> 
My original thinking was that outstanding faults such as PRQ can be
cleared if the handler does not send PRS within timeout. This could be
the case of a malicious guest.

But now I think your suggestion makes sense, it is better to clear out
the pending faults immediately. Then registered fault handler will not
be blocked. And flood of faults will not be reported outside IOMMU
after handler is unregistered.

Jean, would you agree? I guess you are taking care of it in your
sva/api tree now :).

> Alex
> 
> > +
> >  	kfree(param->fault_param);
> >  	param->fault_param = NULL;
> >  	put_device(dev);
> > @@ -958,6 +973,7 @@
> > EXPORT_SYMBOL_GPL(iommu_unregister_device_fault_handler); int
> > iommu_report_device_fault(struct device *dev, struct
> > iommu_fault_event *evt) { struct iommu_param *param =
> > dev->iommu_param;
> > +	struct iommu_fault_event *evt_pending;
> >  	struct iommu_fault_param *fparam;
> >  	int ret = 0;
> >  
> > @@ -972,6 +988,20 @@ int iommu_report_device_fault(struct device
> > *dev, struct iommu_fault_event *evt) ret = -EINVAL;
> >  		goto done_unlock;
> >  	}
> > +
> > +	if (evt->fault.type == IOMMU_FAULT_PAGE_REQ &&
> > +	    (evt->fault.prm.flags &
> > IOMMU_FAULT_PAGE_REQUEST_LAST_PAGE)) {
> > +		evt_pending = kmemdup(evt, sizeof(struct
> > iommu_fault_event),
> > +				      GFP_KERNEL);
> > +		if (!evt_pending) {
> > +			ret = -ENOMEM;
> > +			goto done_unlock;
> > +		}
> > +		mutex_lock(&fparam->lock);
> > +		list_add_tail(&evt_pending->list, &fparam->faults);
> > +		mutex_unlock(&fparam->lock);
> > +	}
> > +
> >  	ret = fparam->handler(evt, fparam->data);
> >  done_unlock:
> >  	mutex_unlock(&param->lock);
> > @@ -1513,6 +1543,51 @@ int iommu_attach_device(struct iommu_domain
> > *domain, struct device *dev) }
> >  EXPORT_SYMBOL_GPL(iommu_attach_device);
> >  
> > +int iommu_page_response(struct device *dev,
> > +			struct page_response_msg *msg)
> > +{
> > +	struct iommu_param *param = dev->iommu_param;
> > +	int ret = -EINVAL;
> > +	struct iommu_fault_event *evt;
> > +	struct iommu_domain *domain =
> > iommu_get_domain_for_dev(dev); +
> > +	if (!domain || !domain->ops->page_response)
> > +		return -ENODEV;
> > +
> > +	/*
> > +	 * Device iommu_param should have been allocated when
> > device is
> > +	 * added to its iommu_group.
> > +	 */
> > +	if (!param || !param->fault_param)
> > +		return -EINVAL;
> > +
> > +	/* Only send response if there is a fault report pending */
> > +	mutex_lock(&param->fault_param->lock);
> > +	if (list_empty(&param->fault_param->faults)) {
> > +		pr_warn("no pending PRQ, drop response\n");
> > +		goto done_unlock;
> > +	}
> > +	/*
> > +	 * Check if we have a matching page request pending to
> > respond,
> > +	 * otherwise return -EINVAL
> > +	 */
> > +	list_for_each_entry(evt, &param->fault_param->faults,
> > list) {
> > +		if (evt->fault.prm.pasid == msg->pasid &&
> > +		    evt->fault.prm.grpid == msg->grpid) {
> > +			msg->iommu_data = evt->iommu_private;
> > +			ret = domain->ops->page_response(dev, msg);
> > +			list_del(&evt->list);
> > +			kfree(evt);
> > +			break;
> > +		}
> > +	}
> > +
> > +done_unlock:
> > +	mutex_unlock(&param->fault_param->lock);
> > +	return ret;
> > +}
> > +EXPORT_SYMBOL_GPL(iommu_page_response);
> > +
> >  static void __iommu_detach_device(struct iommu_domain *domain,
> >  				  struct device *dev)
> >  {
> > diff --git a/include/linux/iommu.h b/include/linux/iommu.h
> > index b87b74c63cf9..950347be47f9 100644
> > --- a/include/linux/iommu.h
> > +++ b/include/linux/iommu.h
> > @@ -191,6 +191,42 @@ struct iommu_sva_ops {
> >  
> >  #ifdef CONFIG_IOMMU_API
> >  
> > +/**
> > + * enum page_response_code - Return status of fault handlers,
> > telling the IOMMU
> > + * driver how to proceed with the fault.
> > + *
> > + * @IOMMU_PAGE_RESP_SUCCESS: Fault has been handled and the page
> > tables
> > + *	populated, retry the access. This is "Success" in PCI
> > PRI.
> > + * @IOMMU_PAGE_RESP_FAILURE: General error. Drop all subsequent
> > faults from
> > + *	this device if possible. This is "Response Failure" in
> > PCI PRI.
> > + * @IOMMU_PAGE_RESP_INVALID: Could not handle this fault, don't
> > retry the
> > + *	access. This is "Invalid Request" in PCI PRI.
> > + */
> > +enum page_response_code {
> > +	IOMMU_PAGE_RESP_SUCCESS = 0,
> > +	IOMMU_PAGE_RESP_INVALID,
> > +	IOMMU_PAGE_RESP_FAILURE,
> > +};
> > +
> > +/**
> > + * struct page_response_msg - Generic page response information
> > based on PCI ATS
> > + *                            and PASID spec
> > + * @addr: servicing page address
> > + * @pasid: contains process address space ID
> > + * @pasid_present: the @pasid field is valid
> > + * @resp_code: response code
> > + * @grpid: page request group index
> > + * @iommu_data: data private to the IOMMU
> > + */
> > +struct page_response_msg {
> > +	u64 addr;
> > +	u32 pasid;
> > +	u32 pasid_present:1;
> > +	enum page_response_code resp_code;
> > +	u32 grpid;
> > +	u64 iommu_data;
> > +};
> > +
> >  /**
> >   * struct iommu_ops - iommu ops and capabilities
> >   * @capable: check capability
> > @@ -227,6 +263,7 @@ struct iommu_sva_ops {
> >   * @sva_bind: Bind process address space to device
> >   * @sva_unbind: Unbind process address space from device
> >   * @sva_get_pasid: Get PASID associated to a SVA handle
> > + * @page_response: handle page request response
> >   * @pgsize_bitmap: bitmap of all possible supported page sizes
> >   */
> >  struct iommu_ops {
> > @@ -287,6 +324,8 @@ struct iommu_ops {
> >  	void (*sva_unbind)(struct iommu_sva *handle);
> >  	int (*sva_get_pasid)(struct iommu_sva *handle);
> >  
> > +	int (*page_response)(struct device *dev, struct
> > page_response_msg *msg); +
> >  	unsigned long pgsize_bitmap;
> >  };
> >  
> > @@ -311,11 +350,13 @@ struct iommu_device {
> >   * unrecoverable faults such as DMA or IRQ remapping faults.
> >   *
> >   * @fault: fault descriptor
> > + * @list: pending fault event list, used for tracking responses
> >   * @iommu_private: used by the IOMMU driver for storing
> > fault-specific
> >   *                 data. Users should not modify this field before
> >   *                 sending the fault response.
> >   */
> >  struct iommu_fault_event {
> > +	struct list_head list;
> >  	struct iommu_fault fault;
> >  	u64 iommu_private;
> >  };
> > @@ -325,10 +366,14 @@ struct iommu_fault_event {
> >   *
> >   * @handler: Callback function to handle IOMMU faults at device
> > level
> >   * @data: handler private data
> > + * @faults: holds the pending faults which needs response, e.g.
> > page response.
> > + * @lock: protect pending faults list
> >   */
> >  struct iommu_fault_param {
> >  	iommu_dev_fault_handler_t handler;
> >  	void *data;
> > +	struct list_head faults;
> > +	struct mutex lock;
> >  };
> >  
> >  /**
> > @@ -443,6 +488,7 @@ extern int
> > iommu_unregister_device_fault_handler(struct device *dev); extern
> > int iommu_report_device_fault(struct device *dev, struct
> > iommu_fault_event *evt); 
> > +extern int iommu_page_response(struct device *dev, struct
> > page_response_msg *msg); extern int iommu_group_id(struct
> > iommu_group *group); extern struct iommu_group
> > *iommu_group_get_for_dev(struct device *dev); extern struct
> > iommu_domain *iommu_group_default_domain(struct iommu_group *); @@
> > -770,6 +816,11 @@ int iommu_report_device_fault(struct device *dev,
> > struct iommu_fault_event *evt) return -ENODEV; }
> >  
> > +static inline int iommu_page_response(struct device *dev, struct
> > page_response_msg *msg) +{
> > +	return -ENODEV;
> > +}
> > +
> >  static inline int iommu_group_id(struct iommu_group *group)
> >  {
> >  	return -ENODEV;  
> 

[Jacob Pan]
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
