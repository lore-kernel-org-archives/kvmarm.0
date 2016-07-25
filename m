From: Auger Eric <eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v11 10/10] genirq/msi: use the MSI doorbell's IOVA when
	requested
Date: Mon, 25 Jul 2016 18:31:55 +0200
Message-ID: <08a930f2-8cc9-7d99-78c0-77d08ee40db3@redhat.com>
References: <1468933367-23159-1-git-send-email-eric.auger@redhat.com>
	<1468933367-23159-11-git-send-email-eric.auger@redhat.com>
	<alpine.DEB.2.11.1607201105310.3564@nanos>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.11.1607201105310.3564@nanos>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, eric.auger.pro-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, yehuday-eYqpPyKDWXRBDgjK7y7TUQ@public.gmane.org, p.fedin-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, robert.richter-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org, drjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jason-NLaQJdtUoK4Be96aLqz0jA@public.gmane.org, marc.zyngier-5wv7dgnIgG8@public.gmane.org, andre.przywara-5wv7dgnIgG8@public.gmane.org, Manish.Jaggi-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, pranav.sawargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Thomas,

On 20/07/2016 11:09, Thomas Gleixner wrote:
> On Tue, 19 Jul 2016, Eric Auger wrote:
> 
> First of all - valid for all patches:
> 
> Subject: sys/subsys: Sentence starts with an uppercase letter
OK understood.
> 
> Now for this particular one:
> 
> genirq/msi: use the MSI doorbell's IOVA when requested
> 
>> On MSI message composition we now use the MSI doorbell's IOVA in
>> place of the doorbell's PA in case the device is upstream to an
>> IOMMU that requires MSI addresses to be mapped. The doorbell's
>> allocation and mapping happened on an early stage (pci_enable_msi).
> 
> This changelog is completely useless. At least I cannot figure out what that
> patch actually does. And the implementation is not self explaining either.

>  
>> @@ -63,10 +63,18 @@ static int msi_compose(struct irq_data *irq_data,
>>  {
>>  	int ret = 0;
>>  
>> -	if (erase)
>> +	if (erase) {
>>  		memset(msg, 0, sizeof(*msg));
>> -	else
>> +	} else {
>> +		struct device *dev;
>> +
>>  		ret = irq_chip_compose_msi_msg(irq_data, msg);
>> +		if (ret)
>> +			return ret;
>> +
>> +		dev = msi_desc_to_dev(irq_data_get_msi_desc(irq_data));
>> +		WARN_ON(iommu_msi_msg_pa_to_va(dev, msg));
> 
> What the heck is this call doing? And why is there only a WARN_ON and not a
> proper error return code handling?

iommu_msi_msg_pa_to_va is part of the new iommu-msi API introduced in PART I of
this series. This helper function detects the physical address found in the
MSI message has a corresponding allocated IOVA. This happens if the MSI doorbell
is accessed through an IOMMU and this IOMMU do not bypass the MSI addresses
(ARM case). Allocation of this IOVA was performed in the previous patch.

So, if this is the case, the physical address is swapped with the IOVA
address. That way the PCIe device will send the MSI with this IOVA and
the address will be translated by the IOMMU into the target MSI doorbell PA.

Hope this clarifies

Thanks

Eric 
> 
> Thanks,
> 
> 	tglx
> 
