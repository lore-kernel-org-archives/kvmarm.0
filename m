From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH v5 23/26] KVM: arm/arm64: GICv4: Prevent a VM using GICv4
 from being saved
Date: Wed, 8 Nov 2017 10:35:14 +0100
Message-ID: <c5640b41-62fd-0f16-1907-bc053f649ea5@redhat.com>
References: <20171027142855.21584-1-marc.zyngier@arm.com>
 <20171027142855.21584-24-marc.zyngier@arm.com>
 <1f75a11a-41c3-71b8-6abf-4aa2962e348e@redhat.com>
 <9c1e1c92-e0fa-737f-63ab-a335b93af6da@arm.com>
 <77d479e5-98f9-9081-a3a6-87bef1009775@redhat.com>
 <33f4de5f-004e-6b92-d4f6-651e536dc697@arm.com>
 <32f1d6ae-4ab5-25e4-587d-9a51fccb955f@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <32f1d6ae-4ab5-25e4-587d-9a51fccb955f@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Mark Rutland <mark.rutland@arm.com>, Andre Przywara <Andre.Przywara@arm.com>, Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>, Christoffer Dall <christoffer.dall@linaro.org>, Shanker Donthineni <shankerd@codeaurora.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On 07/11/2017 23:24, Auger Eric wrote:
> Hi
> 
> On 07/11/2017 17:34, Marc Zyngier wrote:
>> On 07/11/17 16:12, Auger Eric wrote:
>>> Hi Marc,
>>>
>>> On 07/11/2017 16:38, Marc Zyngier wrote:
>>>> On 07/11/17 15:24, Auger Eric wrote:
>>>>> Hi Marc,
>>>>>
>>>>> Hi Marc,
>>>>> On 27/10/2017 16:28, Marc Zyngier wrote:
>>>>>> The GICv4 architecture doesn't make it easy for save/restore to
>>>>>> work, as it doesn't give any guarantee that the pending state
>>>>>> is written into the pending table.
>>>>>
>>>>> I don't understand where does the limitation exactly come from. Can't we
>>>>> use the GICR_VPENDBASER table data?
>>>> You can't. None of the tables that are written by either the ITS or the
>>>> redistributors are architected. All you know is that there is one bit
>>>> per vLPI, but that's it (you don't even know which one is which).
>>> Oh I thought the redistributor config and pending tables were fully
>>> specified (6.1.2 and 6.1.3 of the spec), except the 1kB of the pending
>>> table.
>>
>> The property table is definitely architected. It is a lot less clear for
>> the pending table. The main issue is that you cannot really know when
>> the various bits have actually been flushed all the way from the
>> redistributor caches to memory to be introspected. Yes, it sucks.
> Oh OK the INV only guarantees the caches are consistent with the LPI
> config table. Maybe you could clarify the commit message with those details.
> 
> So
> Reviewed-by: Eric Auger <eric.auger@redhat.com>

Reading the spec further, looks setting the Valid bit of GICR_VPENDBASER
is supposed  to force the redistributor to retrieve pending interrupts
from the the VCPU I/F and ensure the VPT in memory is correct.

Anyway that's not a big deal at the moment as you pointed out...

Thanks

Eric
> 
> Thanks
> 
> Eric
> 
>>
>> Thanks,
>>
>> 	M.
>>
