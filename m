From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v3 5/6] KVM: arm/arm64: Stop using {pmd,pud,pgd}_populate
Date: Wed, 27 Jun 2018 15:45:01 +0100
Message-ID: <f421cfbb-46c7-e183-ab0c-46c73ef5c623@arm.com>
References: <20180627122058.8210-1-marc.zyngier@arm.com>
 <20180627122058.8210-6-marc.zyngier@arm.com>
 <fdc34d4f-73b6-4b5f-685b-d3775ee3122d@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <fdc34d4f-73b6-4b5f-685b-d3775ee3122d@arm.com>
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
Cc: Mark Rutland <mark.rutland@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Christoffer Dall <christoffer.dall@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 27/06/18 14:47, Suzuki K Poulose wrote:
> Hi Marc,
> 
> On 27/06/18 13:20, Marc Zyngier wrote:
>> The {pmd,pud,pgd}_populate accessors usage in the kernel have always
>> been a bit weird in KVM. We don't have a struct mm to pass (and
>> neither does the kernel most of the time, but still...), and
>> the 32bit code has all kind of cache maintenance that doesn't make
>> sense on ARMv7+ when MP extensions are mandatory (which is the
>> case when the VEs are present).
>>
>> Let's bite the bullet and provide our own implementations. The
>> only bit of architectural code left has to do with building the table
>> entry itself (arm64 having up to 52bit PA, arm lacking PUD level).
>>
>> Acked-by: Mark Rutland <mark.rutland@arm.com>
>> Acked-by: Christoffer Dall <christoffer.dall@arm.com>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> ---
>>   arch/arm/include/asm/kvm_mmu.h   | 4 ++++
>>   arch/arm64/include/asm/kvm_mmu.h | 7 +++++++
>>   virt/kvm/arm/mmu.c               | 8 +++++---
>>   3 files changed, 16 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
>> index b2feaea1434c..265ea9cf7df7 100644
>> --- a/arch/arm/include/asm/kvm_mmu.h
>> +++ b/arch/arm/include/asm/kvm_mmu.h
>> @@ -75,6 +75,10 @@ phys_addr_t kvm_get_idmap_vector(void);
>>   int kvm_mmu_init(void);
>>   void kvm_clear_hyp_idmap(void);
>>   
>> +#define kvm_mk_pmd(ptep)	__pmd(__pa(ptep) | PMD_TYPE_TABLE)
>> +#define kvm_mk_pud(pmdp)	__pud(__pa(pmdp) | PMD_TYPE_TABLE)
>> +#define kvm_mk_pgd(pudp)	({ BUILD_BUG(); 0; })
>> +
>>   static inline pte_t kvm_s2pte_mkwrite(pte_t pte)
>>   {
>>   	pte_val(pte) |= L_PTE_S2_RDWR;
>> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
>> index 25c9a91f6a87..2f05be2bed63 100644
>> --- a/arch/arm64/include/asm/kvm_mmu.h
>> +++ b/arch/arm64/include/asm/kvm_mmu.h
>> @@ -169,6 +169,13 @@ phys_addr_t kvm_get_idmap_vector(void);
>>   int kvm_mmu_init(void);
>>   void kvm_clear_hyp_idmap(void);
>>   
>> +#define kvm_mk_pmd(ptep)					\
>> +	__pmd(__phys_to_pmd_val(__pa(ptep) | PMD_TYPE_TABLE))
>> +#define kvm_mk_pud(pmdp)					\
>> +	__pud(__phys_to_pud_val(__pa(pmdp) | PMD_TYPE_TABLE))
>> +#define kvm_mk_pgd(pudp)					\
>> +	__pgd(__phys_to_pgd_val(__pa(pudp) | PUD_TYPE_TABLE))
>> +
> 
> I believe this is wrong, as the __phys_to_p.d_val could strip of the
> TABLE bit. The correct usage is :
> 
> __pXd(__phys_to_pXd_val(__pa(ptr)) | PxD_TYPE_TABLE)

Ah, you're absolutely correct! Fixed now.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
