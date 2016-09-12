From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v3 6/8] ARM: Change MPIDR_AFFINITY_LEVEL to ignore Aff3
Date: Mon, 12 Sep 2016 10:48:54 +0100
Message-ID: <57D67A06.8090107@arm.com>
References: <1473350810-10857-1-git-send-email-vladimir.murzin@arm.com>
 <1473350810-10857-7-git-send-email-vladimir.murzin@arm.com>
 <57D2EA7F.9030705@arm.com> <57D677EE.4080706@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BF75740F9B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Sep 2016 05:40:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eRLUqJvZsrpY for <kvmarm@lists.cs.columbia.edu>;
 Mon, 12 Sep 2016 05:40:16 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BB27E40C9A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Sep 2016 05:40:16 -0400 (EDT)
In-Reply-To: <57D677EE.4080706@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Vladimir Murzin <vladimir.murzin@arm.com>, kvmarm@lists.cs.columbia.edu
Cc: andre.przywara@arm.com, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 12/09/16 10:39, Vladimir Murzin wrote:
> On 09/09/16 17:59, Marc Zyngier wrote:
>> On 08/09/16 17:06, Vladimir Murzin wrote:
>>> vgic-v3 driver queries CPU affinity level up to Aff3, which is valid
>>> for arm64.  However, for arm up to Aff2 levels are supported, so
>>> querying for third level ends with upper bits of MPIDR are treated as
>>> valid affinity level which is not true. Make sure we report zero for
>>> any affinity level above two.
>>>
>>> Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
>>> ---
>>>  arch/arm/include/asm/cputype.h |    3 ++-
>>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/arch/arm/include/asm/cputype.h b/arch/arm/include/asm/cputype.h
>>> index 1ee94c7..f08fac4 100644
>>> --- a/arch/arm/include/asm/cputype.h
>>> +++ b/arch/arm/include/asm/cputype.h
>>> @@ -55,9 +55,10 @@
>>>  
>>>  #define MPIDR_LEVEL_BITS 8
>>>  #define MPIDR_LEVEL_MASK ((1 << MPIDR_LEVEL_BITS) - 1)
>>> +#define MPIDR_LEVEL_SHIFT(level) (MPIDR_LEVEL_BITS * level)
>>>  
>>>  #define MPIDR_AFFINITY_LEVEL(mpidr, level) \
>>> -	((mpidr >> (MPIDR_LEVEL_BITS * level)) & MPIDR_LEVEL_MASK)
>>> +	(((mpidr & MPIDR_HWID_BITMASK) >> MPIDR_LEVEL_SHIFT(level)) & MPIDR_LEVEL_MASK)
>>>  
>>>  #define ARM_CPU_IMP_ARM			0x41
>>>  #define ARM_CPU_IMP_INTEL		0x69
>>>
>>
>> There is something I don't quite get. Is this patch really necessary?
>> Are there cases where we construct a MPIDR that can have Aff3 set on 32bit?
> 
> I've just checked and it seems that I've been keeping the change for
> MPIDR_AFFINITY_LEVEL() since vgic-old era where it was used with
> 
> static u32 compress_mpidr(unsigned long mpidr)
> {
>         u32 ret;
> 
>         ret = MPIDR_AFFINITY_LEVEL(mpidr, 0);
>         ret |= MPIDR_AFFINITY_LEVEL(mpidr, 1) << 8;
>         ret |= MPIDR_AFFINITY_LEVEL(mpidr, 2) << 16;
>         ret |= MPIDR_AFFINITY_LEVEL(mpidr, 3) << 24;
> 
>         return ret;
> }
> 
> and now that code gone and nobody passes level 3 into this macro, so I
> can drop this change.
> 
> However, I do need MPIDR_LEVEL_SHIFT() macro since it is used in vgic-v3.
> 
> Should I leave patch as is or you have something in mind?

I think that for the sake of keeping the change minimal, it'd be better
to just add the MPIDR_LEVEL_SHIFT macro, and drop the other changes.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
