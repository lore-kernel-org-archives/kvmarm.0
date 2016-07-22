From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH v11 06/10] genirq/msi-doorbell: msi_doorbell_safe
Date: Fri, 22 Jul 2016 16:08:57 +0200
Message-ID: <20646d2e-b75f-b088-3ead-2aca039cde79@redhat.com>
References: <1468933367-23159-1-git-send-email-eric.auger@redhat.com>
 <1468933367-23159-7-git-send-email-eric.auger@redhat.com>
 <alpine.DEB.2.11.1607201010350.3564@nanos>
 <3f188661-1d68-199b-3fcc-4da432bae633@redhat.com>
 <alpine.DEB.2.11.1607221443090.3906@nanos>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.11.1607221443090.3906@nanos>
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: eric.auger.pro@gmail.com, marc.zyngier@arm.com, christoffer.dall@linaro.org, andre.przywara@arm.com, robin.murphy@arm.com, alex.williamson@redhat.com, will.deacon@arm.com, joro@8bytes.org, jason@lakedaemon.net, linux-arm-kernel@lists.infradead.org, drjones@redhat.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, pbonzini@redhat.com, linux-kernel@vger.kernel.org, Bharat.Bhushan@freescale.com, pranav.sawargaonkar@gmail.com, p.fedin@samsung.com, iommu@lists.linux-foundation.org, Jean-Philippe.Brucker@arm.com, yehuday@marvell.com, Manish.Jaggi@caviumnetworks.com, robert.richter@caviumnetworks.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi Thomas,
On 22/07/2016 14:44, Thomas Gleixner wrote:
> On Thu, 21 Jul 2016, Auger Eric wrote:
>> On 20/07/2016 10:12, Thomas Gleixner wrote:
>>> On Tue, 19 Jul 2016, Eric Auger wrote:
>>>> +bool msi_doorbell_safe(void)
>>>> +{
>>>> +	struct irqchip_doorbell *db;
>>>> +	bool irq_remapping = true;
>>>> +
>>>> +	mutex_lock(&irqchip_doorbell_mutex);
>>>> +	list_for_each_entry(db, &irqchip_doorbell_list, next) {
>>>> +		irq_remapping &= db->info.irq_remapping;
>>>
>>> db->info.irq_remapping is set in msi_doorbell_register(). So you can keep book
>>> about that there. No need to iterate here.
>> Yes makes sense to store the info at registration time. Currently this
>> function is not in any fast path but that's cleaner from a general
>> perspective. I will need to do such iteration at un-registration though.
> 
> Two simple counter should be sufficient.
> 
>   nr_registered_bells;
>   nr_remapped_bells;

Yes definitively smarter to use counters! mental viscosity.

Thanks

Eric
> 
> ....
> 
> Thanks,
> 
> 	tglx
> 
