From: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Subject: Re: [PATCH v4 03/22] iommu: introduce device fault report API
Date: Tue, 5 Mar 2019 15:03:41 +0000
Message-ID: <fb5f84e6-812f-978d-3be1-673b3e9717ad@arm.com>
References: <20190218135504.25048-1-eric.auger@redhat.com>
 <20190218135504.25048-4-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190218135504.25048-4-eric.auger@redhat.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Eric Auger <eric.auger@redhat.com>, eric.auger.pro@gmail.com, iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, joro@8bytes.org, alex.williamson@redhat.com, jacob.jun.pan@linux.intel.com, yi.l.liu@linux.intel.com, will.deacon@arm.com, robin.murphy@arm.com
Cc: marc.zyngier@arm.com, peter.maydell@linaro.org, kevin.tian@intel.com, ashok.raj@intel.com, christoffer.dall@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

On 18/02/2019 13:54, Eric Auger wrote:
[...]> +/**
> + * iommu_register_device_fault_handler() - Register a device fault handler
> + * @dev: the device
> + * @handler: the fault handler
> + * @data: private data passed as argument to the handler
> + *
> + * When an IOMMU fault event is received, call this handler with the fault event
> + * and data as argument. The handler should return 0 on success. If the fault is
> + * recoverable (IOMMU_FAULT_PAGE_REQ), the handler can also complete
> + * the fault by calling iommu_page_response() with one of the following
> + * response code:
> + * - IOMMU_PAGE_RESP_SUCCESS: retry the translation
> + * - IOMMU_PAGE_RESP_INVALID: terminate the fault
> + * - IOMMU_PAGE_RESP_FAILURE: terminate the fault and stop reporting
> + *   page faults if possible.

The comment refers to function and values that haven't been defined yet.
Either the page_response() patch should come before, or we need to split
this patch.

Something I missed before: if the handler fails (returns != 0) it should
complete the fault by calling iommu_page_response(), if we're not doing
it in iommu_report_device_fault(). It should be indicated in this
comment. It's safe for the handler to call page_response() since we're
not holding fault_param->lock when calling the handler.

> + *
> + * Return 0 if the fault handler was installed successfully, or an error.
> + */
[...]
> +/**
> + * iommu_report_device_fault() - Report fault event to device
> + * @dev: the device
> + * @evt: fault event data
> + *
> + * Called by IOMMU model specific drivers when fault is detected, typically
> + * in a threaded IRQ handler.
> + *
> + * Return 0 on success, or an error.
> + */
> +int iommu_report_device_fault(struct device *dev, struct iommu_fault_event *evt)
> +{
> +	int ret = 0;
> +	struct iommu_fault_event *evt_pending;
> +	struct iommu_fault_param *fparam;
> +
> +	/* iommu_param is allocated when device is added to group */
> +	if (!dev->iommu_param | !evt)

Typo: ||

Thanks,
Jean

> +		return -EINVAL;
> +	/* we only report device fault if there is a handler registered */
> +	mutex_lock(&dev->iommu_param->lock);
> +	if (!dev->iommu_param->fault_param ||
> +		!dev->iommu_param->fault_param->handler) {
> +		ret = -EINVAL;
> +		goto done_unlock;
> +	}
> +	fparam = dev->iommu_param->fault_param;
> +	if (evt->fault.type == IOMMU_FAULT_PAGE_REQ &&
> +	    evt->fault.prm.flags & IOMMU_FAULT_PAGE_REQUEST_LAST_PAGE) {
> +		evt_pending = kmemdup(evt, sizeof(struct iommu_fault_event),
> +				GFP_KERNEL);
> +		if (!evt_pending) {
> +			ret = -ENOMEM;
> +			goto done_unlock;
> +		}
> +		mutex_lock(&fparam->lock);
> +		list_add_tail(&evt_pending->list, &fparam->faults);
> +		mutex_unlock(&fparam->lock);
> +	}
> +	ret = fparam->handler(evt, fparam->data);
> +done_unlock:
> +	mutex_unlock(&dev->iommu_param->lock);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(iommu_report_device_fault);
[...]
