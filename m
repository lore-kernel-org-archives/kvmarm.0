From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH v11 09/10] genirq/msi: map/unmap the MSI doorbells on
 msi_domain_alloc/free_irqs
Date: Tue, 26 Jul 2016 11:54:55 +0200
Message-ID: <f8e83628-5fb0-70d4-c32c-237d190ec98f@redhat.com>
References: <1468933367-23159-1-git-send-email-eric.auger@redhat.com>
 <1468933367-23159-10-git-send-email-eric.auger@redhat.com>
 <alpine.DEB.2.11.1607201016060.3564@nanos>
 <75f5e846-6ca4-4178-e7aa-fed90e45e546@redhat.com>
 <alpine.DEB.2.11.1607261022330.19896@nanos>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 906A349B6F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jul 2016 05:48:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id V1faa6kVIHgC for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 Jul 2016 05:48:37 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E3D4B49B6D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jul 2016 05:48:36 -0400 (EDT)
In-Reply-To: <alpine.DEB.2.11.1607261022330.19896@nanos>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Thomas Gleixner <tglx@linutronix.de>
Cc: kvm@vger.kernel.org, will.deacon@arm.com, kvmarm@lists.cs.columbia.edu, eric.auger.pro@gmail.com, joro@8bytes.org, robert.richter@caviumnetworks.com, Jason Cooper <jason@lakedaemon.net>, Marc Zyngier <marc.zyngier@arm.com>, andre.przywara@arm.com, Manish.Jaggi@caviumnetworks.com, alex.williamson@redhat.com, Bjorn Helgaas <bhelgaas@google.com>, LAK <linux-arm-kernel@lists.infradead.org>, LKML <linux-kernel@vger.kernel.org>, iommu@lists.linux-foundation.org, pbonzini@redhat.com, robin.murphy@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi Thomas,

On 26/07/2016 11:00, Thomas Gleixner wrote:
> B1;2802;0cEric,
> 
> On Mon, 25 Jul 2016, Auger Eric wrote:
>> On 20/07/2016 11:04, Thomas Gleixner wrote:
>>> On Tue, 19 Jul 2016, Eric Auger wrote:
>>>> +		if (ret) {
>>>> +			for (; i >= 0; i--) {
>>>> +				struct irq_data *d = irq_get_irq_data(virq + i);
>>>> +
>>>> +				msi_handle_doorbell_mappings(d, false);
>>>> +			}
>>>> +			irq_domain_free_irqs(virq, desc->nvec_used);
>>>> +			desc->irq = 0;
>>>> +			goto error;
>>>
>>> How is that supposed to work? You clear desc->irq and then you call
>>> ops->handle_error.
>>
>> if I don't clear the desc->irq I enter an infinite loop in
>> pci_enable_msix_range.
>>
>> This happens because msix_capability_init and pcie_enable_msix returns 1.
>> In msix_capability_init, at out_avail: we enumerate the msi_desc which have
>> a non zero irq, hence the returned value equal to 1.
>>
>> Currently the only handle_error ops I found, pci_msi_domain_handle_error
>> does not use irq field so works although questionable.
> 
> The logic here is: If the allocation does not succeed for the requested number
> of interrupts, we tell the caller how many interrupts we were able to set up.
> So the caller can decide what to do.
> 
> In your case you don't want to have a partial allocation, so instead of
> playing silly games with desc->irq you should add a flag which tells the PCI
> code that you are not interested in a partial allocation and that it should
> return an error code instead.

In that case can we consider we even succeeded in allocating 1 MSI? In case the
IOMMU mapping fails, the MSI transaction will never reach the target MSI frame
so it is not usable. So when you mean "partial" I understand we did not succeed
in allocating maxvec IRQs, correct? Here we succeeded in allocating 0 IRQ and still
msi_capability_init returns 1.

msi_capability_init doc-comment says "a positive return value indicates the number of
interrupts which could have been allocated."

I understand allocation success currently only depends on the fact virq was allocated
and set to desc->irq. But with that IOMMU stuff doesn't the criteria changes?


> Something like PCI_DEV_FLAGS_MSI_NO_PARTIAL_ALLOC should do the trick.
> 
>> As for the irq_domain_free_irqs I think I can remove it since handled later.
> 
> Not only the free_irqs(). You should let the teardown function handle
> everything including your doorbell mapping teardown. It's nothing special and
> free_msi_irqs() at the end of msix_capability_init() will take care of it.
Yep I was forced to call free_irqs myself since free_msi_irqs was doing nothing
due the fact I resetted the irq field. Wrong thing loop ;-)

Thanks

Eric

> 
> Thanks,
> 
> 	tglx
> 
