From: Jean-philippe Brucker <jphilippe.brucker-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 3/7] PCI: OF: Allow endpoints to bypass the iommu
Date: Mon, 15 Oct 2018 20:45:47 +0100
Message-ID: <6abc7321-c46a-5618-1ce7-4be85fcc38ec@gmail.com>
References: <20181012145917.6840-1-jean-philippe.brucker@arm.com>
	<20181012145917.6840-4-jean-philippe.brucker@arm.com>
	<20181012194158.GX5906@bhelgaas-glaptop.roam.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <20181012194158.GX5906-1RhO1Y9PlrlHTL0Zs8A6p5iNqAH0jzoTYJqu5kTmcBRl57MIdRCFDg@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Bjorn Helgaas <helgaas-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Mark Rutland <Mark.Rutland-5wv7dgnIgG8@public.gmane.org>, "peter.maydell-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <peter.maydell-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "tnowicki-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org" <tnowicki-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org>, "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "jasowang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <jasowang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Will Deacon <Will.Deacon-5wv7dgnIgG8@public.gmane.org>, "virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, jean-philippe.brucker-5wv7dgnIgG8@public.gmane.org, Marc Zyngier <Marc.Zyngier-5wv7dgnIgG8@public.gmane.org>, Robin Murphy <Robin.Murphy-5wv7dgnIgG8@public.gmane.org>, "kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org" <kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org>
List-Id: kvmarm@lists.cs.columbia.edu

[Replying with my personal address because we're having SMTP issues]

On 12/10/2018 20:41, Bjorn Helgaas wrote:
> s/iommu/IOMMU/ in subject
> 
> On Fri, Oct 12, 2018 at 03:59:13PM +0100, Jean-Philippe Brucker wrote:
>> Using the iommu-map binding, endpoints in a given PCI domain can be
>> managed by different IOMMUs. Some virtual machines may allow a subset of
>> endpoints to bypass the IOMMU. In some case the IOMMU itself is presented
> 
> s/case/cases/
> 
>> as a PCI endpoint (e.g. AMD IOMMU and virtio-iommu). Currently, when a
>> PCI root complex has an iommu-map property, the driver requires all
>> endpoints to be described by the property. Allow the iommu-map property to
>> have gaps.
> 
> I'm not an IOMMU or virtio expert, so it's not obvious to me why it is
> safe to allow devices to bypass the IOMMU.  Does this mean a typo in
> iommu-map could inadvertently allow devices to bypass it?

As Robin said, a device that is absent from iommu-map will be ignored by
the IOMMU layer, so it depends on the specific IOMMU implementation and
driver. By default the SMMU and virtio-iommu drivers disable bypass, but
I'm not sure about the others. I'll try to find a more accurate title for
this patch

>  Should we
> indicate something in dmesg (and/or sysfs) about devices that bypass
> it?

Good idea, I'll replace the pr_err() below with a pr_info(), instead of
simply removing it.

>> Relaxing of_pci_map_rid also allows the msi-map property to have gaps,
> 
> s/of_pci_map_rid/of_pci_map_rid()/
> 
>> which is invalid since MSIs always reach an MSI controller. Thankfully
>> Linux will error out later, when attempting to find an MSI domain for the
>> device.
> 
> Not clear to me what "error out" means here.  In a userspace program,
> I would infer that the program exits with an error message, but I
> doubt you mean that Linux exits.

Right, I'll clarify this. It's pci_msi_setup_msi_irqs() that returns an
error if the device is missing from msi-map, so the device driver won't be
able to request MSIs.

Thanks,
Jean

>> Signed-off-by: Jean-Philippe Brucker <jean-philippe.brucker-5wv7dgnIgG8@public.gmane.org>
>> ---
>>  drivers/pci/of.c | 7 ++++---
>>  1 file changed, 4 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/pci/of.c b/drivers/pci/of.c
>> index 1836b8ddf292..2f5015bdb256 100644
>> --- a/drivers/pci/of.c
>> +++ b/drivers/pci/of.c
>> @@ -451,9 +451,10 @@ int of_pci_map_rid(struct device_node *np, u32 rid,
>>  		return 0;
>>  	}
>>  
>> -	pr_err("%pOF: Invalid %s translation - no match for rid 0x%x on %pOF\n",
>> -		np, map_name, rid, target && *target ? *target : NULL);
>> -	return -EFAULT;
>> +	/* Bypasses translation */
>> +	if (id_out)
>> +		*id_out = rid;
>> +	return 0;
>>  }
>>  
>>  #if IS_ENABLED(CONFIG_OF_IRQ)
>> -- 
>> 2.19.1
>>
> 
