From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH v5 12/26] KVM: arm/arm64: GICv4: Unmap VLPI when freeing
 an LPI
Date: Wed, 8 Nov 2017 15:14:03 +0100
Message-ID: <1da6c685-28f0-ae5c-b47c-738730d2faa9@redhat.com>
References: <20171027142855.21584-1-marc.zyngier@arm.com>
 <20171027142855.21584-13-marc.zyngier@arm.com>
 <052a6676-c15a-6d91-da1e-660312c29f1b@redhat.com>
 <aa3f7570-d200-d138-2a45-798d9d051274@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <aa3f7570-d200-d138-2a45-798d9d051274@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Shanker Donthineni <shankerd@codeaurora.org>, Mark Rutland <mark.rutland@arm.com>, Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>, Andre Przywara <Andre.Przywara@arm.com>, Christoffer Dall <cdall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On 08/11/2017 12:52, Marc Zyngier wrote:
> On 07/11/17 20:28, Auger Eric wrote:
>> Hi Marc,
>>
>> On 27/10/2017 16:28, Marc Zyngier wrote:
>>> When freeing an LPI (on a DISCARD command, for example), we need
>>> to unmap the VLPI down to the physical ITS level.
>>>
>>> Acked-by: Christoffer Dall <cdall@linaro.org>
>>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>>> ---
>>>  virt/kvm/arm/vgic/vgic-its.c | 6 +++++-
>>>  1 file changed, 5 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
>>> index b2a678d131d0..c9b1c0967426 100644
>>> --- a/virt/kvm/arm/vgic/vgic-its.c
>>> +++ b/virt/kvm/arm/vgic/vgic-its.c
>>> @@ -628,8 +628,12 @@ static void its_free_ite(struct kvm *kvm, struct its_ite *ite)
>>>  	list_del(&ite->ite_list);
>>>  
>>>  	/* This put matches the get in vgic_add_lpi. */
>>> -	if (ite->irq)
>>> +	if (ite->irq) {
>>> +		if (ite->irq->hw)
>>> +			WARN_ON(its_unmap_vlpi(ite->irq->host_irq));
>>> +
>>>  		vgic_put_irq(kvm, ite->irq);
>> You could have put the its_unmap_vlpi() directly in vgic_put_irq which
>> is meant to decr the ref/release the LPI irq.
> 
> Do you see this as an issue?

not really. I just thought it would be nicer in vgic_put_irq but that's
a detail.

Thanks

Eric
> 
> I'm trying hard to keep the GICv4 changes local to the ITS code, and not
> spread it everywhere in the vgic, but I'll happily change it if you spot
> something that seems wrong.
> 
> Thanks,
> 
> 	M.
> 
