From: Vladimir Murzin <vladimir.murzin@arm.com>
Subject: Re: [PATCH v4 07/10] ARM: Introduce MPIDR_LEVEL_SHIFT macro
Date: Tue, 13 Sep 2016 11:32:34 +0100
Message-ID: <57D7D5C2.6020105@arm.com>
References: <1473691764-29424-1-git-send-email-vladimir.murzin@arm.com>
 <1473691764-29424-8-git-send-email-vladimir.murzin@arm.com>
 <20160913083855.GC5680@cbox> <57D7C111.7000405@arm.com>
 <57D7D100.3040908@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9615B49BAE
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Sep 2016 06:23:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id b6XYmBHbOUPI for <kvmarm@lists.cs.columbia.edu>;
 Tue, 13 Sep 2016 06:23:54 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 761CC49BAD
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Sep 2016 06:23:54 -0400 (EDT)
In-Reply-To: <57D7D100.3040908@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: andre.przywara@arm.com, Russell King <rmk+kernel@armlinux.org.uk>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 13/09/16 11:12, Marc Zyngier wrote:
> On 13/09/16 10:04, Vladimir Murzin wrote:
>> On 13/09/16 09:38, Christoffer Dall wrote:
>>> On Mon, Sep 12, 2016 at 03:49:21PM +0100, Vladimir Murzin wrote:
>>>> vgic-v3 driver uses architecture specific MPIDR_LEVEL_SHIFT macro to
>>>> encode the affinity in a form compatible with ICC_SGI* registers.
>>>> Unfortunately, that macro is missing on ARM, so let's add it.
>>>>
>>>> Cc: Russell King <rmk+kernel@armlinux.org.uk>
>>>> Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
>>>> ---
>>>>  arch/arm/include/asm/cputype.h |    1 +
>>>>  1 file changed, 1 insertion(+)
>>>>
>>>> diff --git a/arch/arm/include/asm/cputype.h b/arch/arm/include/asm/cputype.h
>>>> index 1ee94c7..e2d94c1 100644
>>>> --- a/arch/arm/include/asm/cputype.h
>>>> +++ b/arch/arm/include/asm/cputype.h
>>>> @@ -55,6 +55,7 @@
>>>>  
>>>>  #define MPIDR_LEVEL_BITS 8
>>>>  #define MPIDR_LEVEL_MASK ((1 << MPIDR_LEVEL_BITS) - 1)
>>>> +#define MPIDR_LEVEL_SHIFT(level) (MPIDR_LEVEL_BITS * level)
>>>>  
>>>
>>> I'm not sure I follow the correctness of this completely.
>>>
>>> This is called from vgic_v3_dispatch_sgi, which takes a u64 value, which
>>> may have something in the Aff3 field, which we now shift left 24 bits,
>>> but that is not the Aff3 field of AArch32's MPIDR.
>>>
>>> What is the rationale for this making sense again?
>>
>> IIUC, in such case we construct mpidr which won't match in match_mpidr()
>> with the value we get from kvm_vcpu_get_mpidr_aff() and no SGI will be
>> sent to the guest.
>>
>> Since we get that u64 value from the guest, I'd think it is something
>> wrong is going on in the guest in case Aff3 is non-zero; however, we can
>> hide it by zeroing out SGI Aff3 bits in access_gic_sgi().
> 
> I don't think zeroing Aff3 is the right move, as the spec doesn't say
> that Aff3 should be ignored in a write to ICC_SGI1R. On the other hand,
> the spec says (in the context of the target list): "If a bit is 1 and
> the bit does not correspond to a valid target PE, the bit must be
> ignored by the Distributor".
> 
> This makes me think that, unless ICC_SGI1R.IMR is set, we should simply
> ignore that SGI because there is no way we can actually deliver it.
> 
> Could you cook a small patch that would go on top of this series?

I assume you've meant ICC_SGI1R.IRM, aka broadcast. In this case,
vgic_v3_dispatch_sgi() seems already matches the logic you've described:

- if IRM == 1, send to everyone except self without check for mpidr
- if IRM == 0, send to target iff matched to a valid mpidr

Am I missing something?

Thanks
Vladimir

> 
> Thanks,
> 
> 	M.
> 
