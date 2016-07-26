From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH v11 10/10] genirq/msi: use the MSI doorbell's IOVA when
 requested
Date: Tue, 26 Jul 2016 12:02:28 +0200
Message-ID: <33b72799-2408-054b-bbe6-2b7e3b67948f@redhat.com>
References: <1468933367-23159-1-git-send-email-eric.auger@redhat.com>
 <1468933367-23159-11-git-send-email-eric.auger@redhat.com>
 <alpine.DEB.2.11.1607201105310.3564@nanos>
 <08a930f2-8cc9-7d99-78c0-77d08ee40db3@redhat.com>
 <alpine.DEB.2.11.1607261101340.19896@nanos>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.11.1607261101340.19896@nanos>
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: eric.auger.pro@gmail.com, marc.zyngier@arm.com, christoffer.dall@linaro.org, andre.przywara@arm.com, robin.murphy@arm.com, alex.williamson@redhat.com, will.deacon@arm.com, joro@8bytes.org, jason@lakedaemon.net, linux-arm-kernel@lists.infradead.org, drjones@redhat.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, pbonzini@redhat.com, linux-kernel@vger.kernel.org, Bharat.Bhushan@freescale.com, pranav.sawargaonkar@gmail.com, p.fedin@samsung.com, iommu@lists.linux-foundation.org, Jean-Philippe.Brucker@arm.com, yehuday@marvell.com, Manish.Jaggi@caviumnetworks.com, robert.richter@caviumnetworks.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi Thomas,

On 26/07/2016 11:04, Thomas Gleixner wrote:
> Eric,
> 
> On Mon, 25 Jul 2016, Auger Eric wrote:
>> On 20/07/2016 11:09, Thomas Gleixner wrote:
>>> On Tue, 19 Jul 2016, Eric Auger wrote:
>>>> @@ -63,10 +63,18 @@ static int msi_compose(struct irq_data *irq_data,
>>>>  {
>>>>  	int ret = 0;
>>>>  
>>>> -	if (erase)
>>>> +	if (erase) {
>>>>  		memset(msg, 0, sizeof(*msg));
>>>> -	else
>>>> +	} else {
>>>> +		struct device *dev;
>>>> +
>>>>  		ret = irq_chip_compose_msi_msg(irq_data, msg);
>>>> +		if (ret)
>>>> +			return ret;
>>>> +
>>>> +		dev = msi_desc_to_dev(irq_data_get_msi_desc(irq_data));
>>>> +		WARN_ON(iommu_msi_msg_pa_to_va(dev, msg));
>>>
>>> What the heck is this call doing? And why is there only a WARN_ON and not a
>>> proper error return code handling?
>>
>> iommu_msi_msg_pa_to_va is part of the new iommu-msi API introduced in PART I
>> of this series. This helper function detects the physical address found in
>> the MSI message has a corresponding allocated IOVA. This happens if the MSI
>> doorbell is accessed through an IOMMU and this IOMMU do not bypass the MSI
>> addresses (ARM case). Allocation of this IOVA was performed in the previous
>> patch.
>>
>> So, if this is the case, the physical address is swapped with the IOVA
>> address. That way the PCIe device will send the MSI with this IOVA and
>> the address will be translated by the IOMMU into the target MSI doorbell PA.
>>
>> Hope this clarifies
> 
> No, it does not. You are explaining in great length what that function is
> doing, but you are not explaining WHY your don't do a proper return code
> handling and just do a WARN_ON() and happily proceed. If that function fails
> then the interrupt will not be functional, so WHY on earth are you continuing?
Oh sorry I focused on the function's goal. Originally I could not return an
error since there is a BUG_ON(ret) afterwards. And typically the userspace can
willingly omit to pass IPA range that map MSIs. But now we have this 2 phases where
we first map the MSIs on pci_enable_msi_range and use the IOVA at compose time
I need to analyze again if the userspace can induce a BUG_ON.

Thanks

Eric
> 
> Thanks,
> 
> 	tglx
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
