From: Vladimir Murzin <vladimir.murzin@arm.com>
Subject: Re: [PATCH v2 4/7] ARM: update MPIDR accessors macro
Date: Tue, 6 Sep 2016 13:42:18 +0100
Message-ID: <57CEB9AA.6080109@arm.com>
References: <1471344418-19568-1-git-send-email-vladimir.murzin@arm.com>
 <1471344418-19568-5-git-send-email-vladimir.murzin@arm.com>
 <20160905112909.GI26366@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4C5C049B4E
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Sep 2016 08:33:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3oXuy-WAsJgM for <kvmarm@lists.cs.columbia.edu>;
 Tue,  6 Sep 2016 08:33:56 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 84BF449B4A
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Sep 2016 08:33:56 -0400 (EDT)
In-Reply-To: <20160905112909.GI26366@cbox>
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

On 05/09/16 12:29, Christoffer Dall wrote:
> The title of this patch is quite generic, especially the 'update'.
> Perhaps say: 
> 
> "ARM: Change MPIDR_AFFINITY_LEVEL to ignore Aff3"
> 

Fixed.

> On Tue, Aug 16, 2016 at 11:46:55AM +0100, Vladimir Murzin wrote:
>> vgic-v3 driver queries CPU affinity level up to Aff3, which is valid for arm64.
>> However, for arm up to Aff2 levels are supported, so querying for 3rd level
>> ends with upper bits of MPIDR are treated as valid affinity level which
>> is not true. So, report zero for any affinity level above 2.
>>
>> Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
>> ---
>>  arch/arm/include/asm/cputype.h |    3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/arm/include/asm/cputype.h b/arch/arm/include/asm/cputype.h
>> index 1ee94c7..96cef49 100644
>> --- a/arch/arm/include/asm/cputype.h
>> +++ b/arch/arm/include/asm/cputype.h
>> @@ -55,9 +55,10 @@
>>  
>>  #define MPIDR_LEVEL_BITS 8
>>  #define MPIDR_LEVEL_MASK ((1 << MPIDR_LEVEL_BITS) - 1)
>> +#define MPIDR_LEVEL_SHIFT(level) (MPIDR_LEVEL_BITS * level)
>>  
>>  #define MPIDR_AFFINITY_LEVEL(mpidr, level) \
>> -	((mpidr >> (MPIDR_LEVEL_BITS * level)) & MPIDR_LEVEL_MASK)
>> +	((level < 3) ? ((mpidr >> MPIDR_LEVEL_SHIFT(level)) & MPIDR_LEVEL_MASK) : 0)
> 
> Instead of using a conditional here, you could just apply the
> MPIDR_HWID_BITMASK to the mpidr argument instead.
> 

Fixed.

Thanks
Vladimir

>>  
>>  #define ARM_CPU_IMP_ARM			0x41
>>  #define ARM_CPU_IMP_INTEL		0x69
>> -- 
>> 1.7.9.5
>>
> 
> 
