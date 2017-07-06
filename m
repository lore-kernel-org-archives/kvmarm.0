From: Alexander Graf <agraf@suse.de>
Subject: Re: [PATCH v2] KVM: arm/arm64: Handle hva aging while destroying the
 vm
Date: Thu, 6 Jul 2017 09:07:49 +0200
Message-ID: <f8794311-ddec-fdb4-9ef2-2e2c05ca7467@suse.de>
References: <1499235631-141725-1-git-send-email-agraf@suse.de>
 <20170705085700.GA16881@e107814-lin.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20170705085700.GA16881@e107814-lin.cambridge.arm.com>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: Suzuki K Poulose <Suzuki.Poulose@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Christoffer Dall <cdall@linaro.org>, Andrea Arcangeli <aarcange@redhat.com>, stable@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu



On 05.07.17 10:57, Suzuki K Poulose wrote:
> Hi Alex,
> 
> On Wed, Jul 05, 2017 at 08:20:31AM +0200, Alexander Graf wrote:
>> The kvm_age_hva callback may be called all the way concurrently while
>> kvm_mmu_notifier_release() is running.
>>
>> The release function sets kvm->arch.pgd = NULL which the aging function
>> however implicitly relies on in stage2_get_pud(). That means they can
>> race and the aging function may dereference a NULL pgd pointer.
>>
>> This patch adds a check for that case, so that we leave the aging
>> function silently.
>>
>> Cc: stable@vger.kernel.org
>> Fixes: 293f29363 ("kvm-arm: Unmap shadow pagetables properly")
>> Signed-off-by: Alexander Graf <agraf@suse.de>
>>
>> ---
>>
>> v1 -> v2:
>>
>>    - Fix commit message
>>    - Add Fixes and stable tags
>> ---
>>   virt/kvm/arm/mmu.c | 4 ++++
>>   1 file changed, 4 insertions(+)
>>
>> diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
>> index f2d5b6c..227931f 100644
>> --- a/virt/kvm/arm/mmu.c
>> +++ b/virt/kvm/arm/mmu.c
>> @@ -861,6 +861,10 @@ static pud_t *stage2_get_pud(struct kvm *kvm, struct kvm_mmu_memory_cache *cache
>>   	pgd_t *pgd;
>>   	pud_t *pud;
>>   
>> +	/* Do we clash with kvm_free_stage2_pgd()? */
>> +	if (!kvm->arch.pgd)
>> +		return NULL;
>> +
> 
> I think this check should be moved up in the chain. We call kvm_age_hva(), with
> the kvm->mmu_lock held and we don't release it till we reach here. So, ideally,
> if we find the PGD is null when we reach kvm_age_hva(), we could simply return
> there, like we do for other call backs from the KVM mmu_notifier.

That probably works too - I'm not sure which version is more consistent 
as well as more maintainable in the long run. I'll leave the call here 
to Christoffer.


Alex
