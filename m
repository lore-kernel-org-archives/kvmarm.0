From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH 1/2] kvm: arm: Clean up the checking for huge mapping
Date: Thu, 11 Apr 2019 10:47:12 +0100
Message-ID: <ab173598-56a8-f9d3-1165-1bd748c2b8d6@arm.com>
References: <1554909297-6753-1-git-send-email-suzuki.poulose@arm.com>
 <1554909832-7169-1-git-send-email-suzuki.poulose@arm.com>
 <1554909832-7169-2-git-send-email-suzuki.poulose@arm.com>
 <529f8515-a069-948b-cb63-96fa35b291a6@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <529f8515-a069-948b-cb63-96fa35b291a6@huawei.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: yuzenghui@huawei.com, linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, julien.thierry@arm.com, christoffer.dall@arm.com, marc.zyngier@arm.com, andrew.murray@arm.com, eric.auger@redhat.com, zhengxiang9@huawei.com, wanghaibin.wang@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

On 04/11/2019 02:48 AM, Zenghui Yu wrote:
> 
> On 2019/4/10 23:23, Suzuki K Poulose wrote:
>> If we are checking whether the stage2 can map PAGE_SIZE,
>> we don't have to do the boundary checks as both the host
>> VMA and the guest memslots are page aligned. Bail the case
>> easily.
>>
>> Cc: Christoffer Dall <christoffer.dall@arm.com>
>> Cc: Marc Zyngier <marc.zyngier@arm.com>
>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> ---
>>   virt/kvm/arm/mmu.c | 4 ++++
>>   1 file changed, 4 insertions(+)
>>
>> diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
>> index a39dcfd..6d73322 100644
>> --- a/virt/kvm/arm/mmu.c
>> +++ b/virt/kvm/arm/mmu.c
>> @@ -1624,6 +1624,10 @@ static bool 
>> fault_supports_stage2_huge_mapping(struct kvm_memory_slot *memslot,
>>       hva_t uaddr_start, uaddr_end;
>>       size_t size;
>> +    /* The memslot and the VMA are guaranteed to be aligned to 
>> PAGE_SIZE */
>> +    if (map_size == PAGE_SIZE)
>> +        return true;
>> +
>>       size = memslot->npages * PAGE_SIZE;
>>       gpa_start = memslot->base_gfn << PAGE_SHIFT;
>>
> We can do a comment clean up as well in this patch.
> 
> s/<< PAGE_SIZE/<< PAGE_SHIFT/

Sure, I missed that. Will fix it in the next version.

Cheers
Suzuki
