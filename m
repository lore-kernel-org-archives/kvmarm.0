From: Julien Grall <julien.grall@arm.com>
Subject: Re: [PATCH RFC 01/14] arm64/mm: Introduce asid_info structure and
 move asid_generation/asid_map to it
Date: Thu, 21 Mar 2019 17:27:40 +0000
Message-ID: <247efb35-2082-289a-43cf-3342b586b1d8@arm.com>
References: <20190321163623.20219-1-julien.grall@arm.com>
 <20190321163623.20219-2-julien.grall@arm.com>
 <ad32ff02-a88f-ee8a-3296-f859638d66b9@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <ad32ff02-a88f-ee8a-3296-f859638d66b9@arm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Suzuki K Poulose <suzuki.poulose@arm.com>, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: christoffer.dall@arm.com, james.morse@arm.com, marc.zyngier@arm.com, julien.thierry@arm.com, catalin.marinas@arm.com, will.deacon@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

On 3/21/19 5:03 PM, Suzuki K Poulose wrote:
> Hi Julien,

Hi Suzuki,

> On 21/03/2019 16:36, Julien Grall wrote:
>> In an attempt to make the ASID allocator generic, create a new structure
>> asid_info to store all the information necessary for the allocator.
>>
>> For now, move the variables asid_generation and asid_map to the new 
>> structure
>> asid_info. Follow-up patches will move more variables.
>>
>> Note to avoid more renaming aftwards, a local variable 'info' has been
>> created and is a pointer to the ASID allocator structure.
>>
>> Signed-off-by: Julien Grall <julien.grall@arm.com>
>> ---
>>   arch/arm64/mm/context.c | 46 
>> ++++++++++++++++++++++++++--------------------
>>   1 file changed, 26 insertions(+), 20 deletions(-)
>>
>> diff --git a/arch/arm64/mm/context.c b/arch/arm64/mm/context.c
>> index 1f0ea2facf24..34db54f1a39a 100644
>> --- a/arch/arm64/mm/context.c
>> +++ b/arch/arm64/mm/context.c
>> @@ -30,8 +30,11 @@
>>   static u32 asid_bits;
>>   static DEFINE_RAW_SPINLOCK(cpu_asid_lock);
>> -static atomic64_t asid_generation;
>> -static unsigned long *asid_map;
>> +struct asid_info
>> +{
>> +    atomic64_t    generation;
>> +    unsigned long    *map;
>> +} asid_info;
> 
> Shouldn't this be static ? Rest looks fine.

Yes it should be static. I have updated my code.

Thank you for the review!

Cheers,

> 
> Cheers
> Suzuki

-- 
Julien Grall
