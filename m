From: Suzuki K Poulose <Suzuki.Poulose@arm.com>
Subject: Re: [PATCH v2 14/17] kvm: arm64: Switch to per VM IPA limit
Date: Mon, 16 Apr 2018 11:25:46 +0100
Message-ID: <684e0890-6dde-58e3-7e9b-6839f6597c67@arm.com>
References: <1522156531-28348-1-git-send-email-suzuki.poulose@arm.com>
 <1522156531-28348-15-git-send-email-suzuki.poulose@arm.com>
 <87muy7vzoy.fsf@e105922-lin.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87muy7vzoy.fsf@e105922-lin.cambridge.arm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Punit Agrawal <punit.agrawal@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, ard.biesheuvel@linaro.org, kvm@vger.kernel.org, marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, kristina.martsenko@arm.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 13/04/18 17:27, Punit Agrawal wrote:
> Hi Suzuki,
> 
> I haven't had a chance to look at the code but noticed one issue below.
> 
> Suzuki K Poulose <suzuki.poulose@arm.com> writes:
> 
>> Now that we can manage the stage2 page table per VM, switch the
>> configuration details to per VM instance. We keep track of the
>> IPA bits, number of page table levels and the VTCR bits (which
>> depends on the IPA and the number of levels). While at it, remove
>> unused pgd_lock field from kvm_arch for arm64.
>>
>> Cc: Marc Zyngier <marc.zyngier@arm.com>
>> Cc: Christoffer Dall <cdall@kernel.org>
>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> ---
>>   arch/arm64/include/asm/kvm_host.h       | 14 ++++++++++++--
>>   arch/arm64/include/asm/kvm_mmu.h        | 11 +++++++++--
>>   arch/arm64/include/asm/stage2_pgtable.h |  1 -
>>   arch/arm64/kvm/hyp/switch.c             |  3 +--
>>   virt/kvm/arm/mmu.c                      |  4 ++++
>>   5 files changed, 26 insertions(+), 7 deletions(-)
>>
> 
> [...]
> 
>> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
>> index bb458bf..e86d7f4 100644
>> --- a/arch/arm64/include/asm/kvm_mmu.h
>> +++ b/arch/arm64/include/asm/kvm_mmu.h
>> @@ -136,9 +136,10 @@ static inline unsigned long __kern_hyp_va(unsigned long v)
>>    */
>>   #define KVM_PHYS_SHIFT	(40)
>>   
>> -#define kvm_phys_shift(kvm)		KVM_PHYS_SHIFT
>> +#define kvm_phys_shift(kvm)		(kvm->arch.phys_shift)
>>   #define kvm_phys_size(kvm)		(_AC(1, ULL) << kvm_phys_shift(kvm))
>>   #define kvm_phys_mask(kvm)		(kvm_phys_size(kvm) - _AC(1, ULL))
>> +#define kvm_stage2_levels(kvm)		(kvm->arch.s2_levels)
>>   
>>   static inline bool kvm_page_empty(void *ptr)
>>   {
> 
> [...]
> 
>> diff --git a/arch/arm64/include/asm/stage2_pgtable.h b/arch/arm64/include/asm/stage2_pgtable.h
>> index 33e8ebb..9b75b83 100644
>> --- a/arch/arm64/include/asm/stage2_pgtable.h
>> +++ b/arch/arm64/include/asm/stage2_pgtable.h
>> @@ -44,7 +44,6 @@
>>    */
>>   #define __s2_pgd_ptrs(pa, lvls)	(1 << ((pa) - pt_levels_pgdir_shift((lvls))))
>>   
>> -#define kvm_stage2_levels(kvm)		stage2_pt_levels(kvm_phys_shift(kvm))
>>   #define stage2_pgdir_shift(kvm)	\
>>   		pt_levels_pgdir_shift(kvm_stage2_levels(kvm))
>>   #define stage2_pgdir_size(kvm)		(_AC(1, UL) << stage2_pgdir_shift((kvm)))
> 
> [...]
> 
>> diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
>> index 7a264c6..746f38e 100644
>> --- a/virt/kvm/arm/mmu.c
>> +++ b/virt/kvm/arm/mmu.c
>> @@ -753,6 +753,10 @@ int kvm_alloc_stage2_pgd(struct kvm *kvm)
>>   		return -EINVAL;
>>   	}
>>   
>> +	/* Make sure we have the stage2 configured for this VM */
>> +	if (WARN_ON(!kvm_stage2_levels(kvm)))
>> +		return -EINVAL;
>> +
> 
> This hunk breaks the 32-bit build as kvm_stag2_levels() isn't defined on
> arm.

Thanks for spotting. I have fixed this locally in my next version to check
for the kvm_phys_shift(), as I plan to delay the levels selection to the
actual allocation of the table, giving us a fall back to increase the level
if we are unable to allocate contiguous pages (e.g, 16 * 64K pages with say 46bit
IPA).


Cheers
Suzuki
