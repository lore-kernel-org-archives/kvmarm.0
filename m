From: Steven Price <steven.price@arm.com>
Subject: Re: [PATCH] kvm/arm: return 0 when the number of objects is not less
 than min
Date: Fri, 7 Dec 2018 14:49:29 +0000
Message-ID: <4c32963e-0dc7-1867-aa76-7314334315c4@arm.com>
References: <1543972551-60951-1-git-send-email-peng.hao2@zte.com.cn>
 <20181205083236.5tzhnxfhi4h4nknn@kamzik.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181205083236.5tzhnxfhi4h4nknn@kamzik.brq.redhat.com>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Jones <drjones@redhat.com>, Peng Hao <peng.hao2@zte.com.cn>
Cc: marc.zyngier@arm.com, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 05/12/2018 08:32, Andrew Jones wrote:
> On Wed, Dec 05, 2018 at 09:15:51AM +0800, Peng Hao wrote:
>> Return 0 when there is enough kvm_mmu_memory_cache object.
>>
>> Signed-off-by: Peng Hao <peng.hao2@zte.com.cn>
>> ---
>>  virt/kvm/arm/mmu.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
>> index ed162a6..fcda0ce 100644
>> --- a/virt/kvm/arm/mmu.c
>> +++ b/virt/kvm/arm/mmu.c
>> @@ -127,7 +127,7 @@ static int mmu_topup_memory_cache(struct kvm_mmu_memory_cache *cache,
>>  	while (cache->nobjs < max) {
>>  		page = (void *)__get_free_page(PGALLOC_GFP);
>>  		if (!page)
>> -			return -ENOMEM;
>> +			return cache->nobjs >= min ? 0 : -ENOMEM;
> 
> This condition will never be true here, as the exact same condition is
> already checked above, and if it had been true, then we wouldn't be here.

The condition can be true if the loop is executed at least once. This
change would appear to allow the call to succeed in the case where the
cache can be topped up to at least "min", but not as far as "max".

It would be good to know in what situation this has actually been hit
though (and indeed whether this has actually been seen) - the system
must be very short on memory to need this, and I'd be surprised if
further failures didn't happen later on.

> What problem are you attempting to solve?
> 
>>  		cache->objects[cache->nobjs++] = page;
>>  	}
>>  	return 0;
>> -- 
>> 1.8.3.1
>>
>> _______________________________________________
>> kvmarm mailing list
>> kvmarm@lists.cs.columbia.edu
>> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
> 
