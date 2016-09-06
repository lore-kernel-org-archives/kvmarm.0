From: Vladimir Murzin <vladimir.murzin@arm.com>
Subject: Re: [PATCH v2 3/7] KVM: arm: vgic-new: improve compatibility with
 32-bit
Date: Tue, 6 Sep 2016 14:54:01 +0100
Message-ID: <57CECA79.3040204@arm.com>
References: <1471344418-19568-1-git-send-email-vladimir.murzin@arm.com>
 <1471344418-19568-4-git-send-email-vladimir.murzin@arm.com>
 <20160905112904.GH26366@cbox> <57CEB981.6060600@arm.com>
 <20160906132219.GA23592@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 109EA49B53
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Sep 2016 09:45:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KoPg7No5Jo0D for <kvmarm@lists.cs.columbia.edu>;
 Tue,  6 Sep 2016 09:45:39 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B3DDE49B47
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Sep 2016 09:45:39 -0400 (EDT)
In-Reply-To: <20160906132219.GA23592@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: marc.zyngier@arm.com, andre.przywara@arm.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 06/09/16 14:22, Christoffer Dall wrote:
> On Tue, Sep 06, 2016 at 01:41:37PM +0100, Vladimir Murzin wrote:
>> Hi Christoffer,
>>
>> On 05/09/16 12:29, Christoffer Dall wrote:
>>> Hi Vladimir,
>>>
>>> I think commit title is too vague, can you be more specific?
>>>
>>
>> KVM: arm: vgic-new: make extract_bytes to always work on 64-bit data
>>
>> is it better?
> 
> I would suggest:
> 
> KVM: arm: vgic: Support 64-bit data manipulation on 32-bit host systems
> 
>>
>>> On Tue, Aug 16, 2016 at 11:46:54AM +0100, Vladimir Murzin wrote:
>>>> We have couple of 64-bit register defined in GICv3 architecture, so
>>>
>>> 'a couple',  'registers' (plural)
>>>
>>>> "unsigned long" kind of accessors wouldn't work for 32-bit. However,
>>>
>>> 'wouldn't work for 32-bit' is kind of generic as well.  Perhaps you mean
>>> that unsigned long accesses to these registers will only access a single
>>> 32-bit work of that register.
>>>
>>>> these registers can't be access as 64-bit in a one go if we run 32-bit
>>>
>>> 'accessed', 's/in one go/with a single instruction/' ?
>>>
>>> 'a 32-bit host'
>>>
>>>> host simply because KVM doesn't support multiple load/store on MMIO
>>>
>>> by 'multiple load/store' you mean the 'load/store multiple' instructions
>>> specifically, right?  Not a sequence of multiple loads and stores.  I
>>> think you should be more specific here as well, for example, I think
>>> ldrd and strd are problematic as well.
>>>
>>>> space.
>>>>
>>>> It means that 32-bit guest access these registers in 32-bit chunks, so
>>>
>>> 'a 32-bit guest', 'accesses'
>>>
>>
>> all suggestions you've made above are true. I'll rework commit message
>> to be more precise.
>>
> 
> Thanks!
> 
>>>> the only thing we need to do is to ensure that extract_bytes() always
>>>> takes 64-bit data.
>>>>
>>>> Since we are here fix couple of other width related issues by using
>>>> ULL variants over UL.
>>>>
>>>> Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
>>>> ---
>>>>  virt/kvm/arm/vgic/vgic-mmio-v3.c |    6 +++---
>>>>  virt/kvm/arm/vgic/vgic-mmio.h    |    2 +-
>>>>  2 files changed, 4 insertions(+), 4 deletions(-)
>>>>
>>>> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
>>>> index ff668e0..cc20b60 100644
>>>> --- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
>>>> +++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
>>>> @@ -23,7 +23,7 @@
>>>>  #include "vgic-mmio.h"
>>>>  
>>>>  /* extract @num bytes at @offset bytes offset in data */
>>>> -unsigned long extract_bytes(unsigned long data, unsigned int offset,
>>>> +unsigned long extract_bytes(u64 data, unsigned int offset,
>>>>  			    unsigned int num)
>>>>  {
>>>>  	return (data >> (offset * 8)) & GENMASK_ULL(num * 8 - 1, 0);
>>>> @@ -179,7 +179,7 @@ static unsigned long vgic_mmio_read_v3r_typer(struct kvm_vcpu *vcpu,
>>>>  	int target_vcpu_id = vcpu->vcpu_id;
>>>>  	u64 value;
>>>>  
>>>> -	value = (mpidr & GENMASK(23, 0)) << 32;
>>>> +	value = (mpidr & GENMASK_ULL(23, 0)) << 32;
>>>
>>> why does this make a difference when mpidr is an unsigned long?
>>
>> because we access a little bit further than unsigned long can accommodate
>>
>>   CC      arch/arm/kvm/../../../virt/kvm/arm/vgic/vgic-mmio-v3.o
>> arch/arm/kvm/../../../virt/kvm/arm/vgic/vgic-mmio-v3.c: In function
>> 'vgic_mmio_read_v3r_typer':
>> arch/arm/kvm/../../../virt/kvm/arm/vgic/vgic-mmio-v3.c:184:35: warning:
>> left shift count >= width of type [-Wshift-count-overflow]
>>   value = (mpidr & GENMASK(23, 0)) << 32;
>>                                    ^
>>
>> I can include this warning in commit message or maybe you want a
>> separate patch?
>>
> My point was that the code doesn't really make sense when compiled on a
> 32-bit platform without also modifing the type for the mpidr variable.
> Am I missing something?

I've not seen any difference in generated code, but for consistency I'll
update mpidr variable to u64.

Thanks
Vladimir

> 
> Thanks,
> -Christoffer
> 
> 
