From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v3 1/6] arm64: KVM: Add support for Stage-2 control of
 memory types and cacheability
Date: Wed, 27 Jun 2018 17:36:46 +0100
Message-ID: <d65a43bd-7b6b-8768-fb3c-878ee8ab70d2@arm.com>
References: <20180627122058.8210-1-marc.zyngier@arm.com>
 <20180627122058.8210-2-marc.zyngier@arm.com>
 <94512c9e-b625-ba7c-097b-cb7b18cb592d@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <94512c9e-b625-ba7c-097b-cb7b18cb592d@arm.com>
Content-Language: en-GB
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Suzuki K Poulose <Suzuki.Poulose@arm.com>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 27/06/18 17:20, Suzuki K Poulose wrote:
> Marc,
> 
> On 27/06/18 13:20, Marc Zyngier wrote:
>> Up to ARMv8.3, the combinaison of Stage-1 and Stage-2 attributes
>> results in the strongest attribute of the two stages.  This means
>> that the hypervisor has to perform quite a lot of cache maintenance
>> just in case the guest has some non-cacheable mappings around.
>>
>> ARMv8.4 solves this problem by offering a different mode (FWB) where
>> Stage-2 has total control over the memory attribute (this is limited
>> to systems where both I/O and instruction fetches are coherent with
>> the dcache). This is achieved by having a different set of memory
>> attributes in the page tables, and a new bit set in HCR_EL2.
>>
>> On such a system, we can then safely sidestep any form of dcache
>> management.
>>
>> Acked-by: Catalin Marinas <catalin.marinas@arm.com>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> ---
>>   arch/arm64/include/asm/cpucaps.h      |  3 ++-
>>   arch/arm64/include/asm/kvm_arm.h      |  1 +
>>   arch/arm64/include/asm/kvm_emulate.h  |  2 ++
>>   arch/arm64/include/asm/kvm_mmu.h      | 26 ++++++++++++++++++++------
>>   arch/arm64/include/asm/memory.h       |  7 +++++++
>>   arch/arm64/include/asm/pgtable-prot.h | 14 ++++++++++++--
>>   arch/arm64/include/asm/sysreg.h       |  1 +
>>   arch/arm64/kernel/cpufeature.c        | 20 ++++++++++++++++++++
>>   virt/kvm/arm/mmu.c                    |  4 ++++
>>   9 files changed, 69 insertions(+), 9 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/cpucaps.h b/arch/arm64/include/asm/cpucaps.h
>> index 8a699c708fc9..ed84d6536830 100644
>> --- a/arch/arm64/include/asm/cpucaps.h
>> +++ b/arch/arm64/include/asm/cpucaps.h
>> @@ -49,7 +49,8 @@
>>   #define ARM64_HAS_CACHE_DIC			28
>>   #define ARM64_HW_DBM				29
>>   #define ARM64_SSBD				30
>> +#define ARM64_HAS_STAGE2_FWB			31
>>   
>> -#define ARM64_NCAPS				31
>> +#define ARM64_NCAPS				32
>>   
>>   #endif /* __ASM_CPUCAPS_H */
>> diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
>> index 6dd285e979c9..aa45df752a16 100644
>> --- a/arch/arm64/include/asm/kvm_arm.h
>> +++ b/arch/arm64/include/asm/kvm_arm.h
>> @@ -23,6 +23,7 @@
>>   #include <asm/types.h>
>>   
>>   /* Hyp Configuration Register (HCR) bits */
>> +#define HCR_FWB		(UL(1) << 46)
>>   #define HCR_TEA		(UL(1) << 37)
>>   #define HCR_TERR	(UL(1) << 36)
>>   #define HCR_TLOR	(UL(1) << 35)
>> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
>> index 1dab3a984608..dd98fdf33d99 100644
>> --- a/arch/arm64/include/asm/kvm_emulate.h
>> +++ b/arch/arm64/include/asm/kvm_emulate.h
>> @@ -63,6 +63,8 @@ static inline void vcpu_reset_hcr(struct kvm_vcpu *vcpu)
>>   		/* trap error record accesses */
>>   		vcpu->arch.hcr_el2 |= HCR_TERR;
>>   	}
>> +	if (cpus_have_const_cap(ARM64_HAS_STAGE2_FWB))
>> +		vcpu->arch.hcr_el2 |= HCR_FWB;
>>   
>>   	if (test_bit(KVM_ARM_VCPU_EL1_32BIT, vcpu->arch.features))
>>   		vcpu->arch.hcr_el2 &= ~HCR_RW;
>> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
>> index fb9a7127bb75..620eb9e06bd8 100644
>> --- a/arch/arm64/include/asm/kvm_mmu.h
>> +++ b/arch/arm64/include/asm/kvm_mmu.h
>> @@ -257,6 +257,7 @@ static inline bool kvm_page_empty(void *ptr)
>>   struct kvm;
>>   
>>   #define kvm_flush_dcache_to_poc(a,l)	__flush_dcache_area((a), (l))
>> +#define kvm_flush_dcache_to_pou(a,l)	__clean_dcache_area_pou((a), (l))
> 
> We don't seem to use this new helper anywhere. Otherwise looks good to me.

Good point, I forgot to remove it when I dropped the flush to PoU...
I'll sort it.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
