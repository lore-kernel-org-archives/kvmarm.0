From: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Subject: Re: [PATCH v4 03/22] iommu: introduce device fault report API
Date: Thu, 7 Mar 2019 11:42:59 +0000
Message-ID: <1500594f-d7ea-94f2-01aa-0dc0e08b391b@arm.com>
References: <20190218135504.25048-1-eric.auger@redhat.com>
 <20190218135504.25048-4-eric.auger@redhat.com>
 <fb5f84e6-812f-978d-3be1-673b3e9717ad@arm.com>
 <20190306154616.648e2523@jacob-builder>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190306154616.648e2523@jacob-builder>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Eric Auger <eric.auger@redhat.com>, "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>, "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "joro@8bytes.org" <joro@8bytes.org>, "alex.williamson@redhat.com" <alex.williamson@redhat.com>, "yi.l.liu@linux.intel.com" <yi.l.liu@linux.intel.com>, Will Deacon <Will.Deacon@arm.com>, Robin Murphy <Robin.Murphy@arm.com>, Marc Zyngier <Marc.Zyngier@arm.com>, "peter.maydell@linaro.org" <peter.maydell@linaro.org>, "kevin.tian@intel.com" <kevin.tian@intel.com>, "ashok.raj@intel.com" <ashok.raj@intel.com>, Christoffer Dall <Christoffer.Dall@a>
List-Id: kvmarm@lists.cs.columbia.edu

On 06/03/2019 23:46, Jacob Pan wrote:
> On Tue, 5 Mar 2019 15:03:41 +0000
> Jean-Philippe Brucker <jean-philippe.brucker@arm.com> wrote:
> 
>> On 18/02/2019 13:54, Eric Auger wrote:
>> [...]> +/**
>> > + * iommu_register_device_fault_handler() - Register a device fault
>> > handler
>> > + * @dev: the device
>> > + * @handler: the fault handler
>> > + * @data: private data passed as argument to the handler
>> > + *
>> > + * When an IOMMU fault event is received, call this handler with
>> > the fault event
>> > + * and data as argument. The handler should return 0 on success.
>> > If the fault is
>> > + * recoverable (IOMMU_FAULT_PAGE_REQ), the handler can also
>> > complete
>> > + * the fault by calling iommu_page_response() with one of the
>> > following
>> > + * response code:
>> > + * - IOMMU_PAGE_RESP_SUCCESS: retry the translation
>> > + * - IOMMU_PAGE_RESP_INVALID: terminate the fault
>> > + * - IOMMU_PAGE_RESP_FAILURE: terminate the fault and stop
>> > reporting
>> > + *   page faults if possible.  
>> 
>> The comment refers to function and values that haven't been defined
>> yet. Either the page_response() patch should come before, or we need
>> to split this patch.
>> 
>> Something I missed before: if the handler fails (returns != 0) it
>> should complete the fault by calling iommu_page_response(), if we're
>> not doing it in iommu_report_device_fault(). It should be indicated
>> in this comment. It's safe for the handler to call page_response()
>> since we're not holding fault_param->lock when calling the handler.
>> 
> If the page request fault is to be reported to a guest, the report
> function cannot wait for the completion status. As long as the fault is
> injected into the guest, the handler should complete with success. If
> the PRQ report fails, IMHO, the caller of iommu_report_device_fault()
> should send page_response, perhaps after clean up all partial response
> of the group too.

Ok, the caller (IOMMU driver) sending the page_response if
iommu_report_device_fault() fails does make more sense. Agreed on the
partial cleanup as well, we don't keep track of them here, but I need to
add that to the io-pgfault layer. However some cleanup should probably
happen in here...

>> > +   /* we only report device fault if there is a handler
>> > registered */
>> > +   mutex_lock(&dev->iommu_param->lock);
>> > +   if (!dev->iommu_param->fault_param ||
>> > +           !dev->iommu_param->fault_param->handler) {
>> > +           ret = -EINVAL;
>> > +           goto done_unlock;
>> > +   }
>> > +   fparam = dev->iommu_param->fault_param;
>> > +   if (evt->fault.type == IOMMU_FAULT_PAGE_REQ &&
>> > +       evt->fault.prm.flags &
>> > IOMMU_FAULT_PAGE_REQUEST_LAST_PAGE) {
>> > +           evt_pending = kmemdup(evt, sizeof(struct
>> > iommu_fault_event),
>> > +                           GFP_KERNEL);
>> > +           if (!evt_pending) {
>> > +                   ret = -ENOMEM;
>> > +                   goto done_unlock;
>> > +           }
>> > +           mutex_lock(&fparam->lock);
>> > +           list_add_tail(&evt_pending->list, &fparam->faults);
>> > +           mutex_unlock(&fparam->lock);
>> > +   }
>> > +   ret = fparam->handler(evt, fparam->data);

... if ret != 0, removing and freeing the pending event seems more
appropriate here than asking our caller to do it

Thanks,
Jean

>> > +done_unlock:
>> > +   mutex_unlock(&dev->iommu_param->lock);
>> > +   return ret;
>> > +}
>> > +EXPORT_SYMBOL_GPL(iommu_report_device_fault);  
>> [...]
> 
> [Jacob Pan]
