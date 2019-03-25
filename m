From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH] KVM: arm/arm64: Comments cleanup in mmu.c
Date: Mon, 25 Mar 2019 09:58:09 +0000
Message-ID: <194b5370-0ed2-5dbd-9a5d-e20e4f8413ec@arm.com>
References: <1553500925-26000-1-git-send-email-yuzenghui@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1553500925-26000-1-git-send-email-yuzenghui@huawei.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: yuzenghui@huawei.com, christoffer.dall@arm.com, marc.zyngier@arm.com
Cc: james.morse@arm.com, julien.thierry@arm.com, wanghaibin.wang@huawei.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu



On 25/03/2019 08:02, Zenghui Yu wrote:
> Some comments in virt/kvm/arm/mmu.c are outdated and incorrect.
> Get rid of these comments, to keep the code&comment correct and
> current as a whole.
> 
> Only a cleanup here, no functional change.
> 
> Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
> ---
>   virt/kvm/arm/mmu.c | 23 +++++++++--------------
>   1 file changed, 9 insertions(+), 14 deletions(-)
> 
> diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
> index ffd7acd..0a6efe7 100644
> --- a/virt/kvm/arm/mmu.c
> +++ b/virt/kvm/arm/mmu.c
> @@ -102,8 +102,7 @@ static bool kvm_is_device_pfn(unsigned long pfn)
>    * @addr:	IPA
>    * @pmd:	pmd pointer for IPA
>    *
> - * Function clears a PMD entry, flushes addr 1st and 2nd stage TLBs. Marks all
> - * pages in the range dirty.
> + * Function clears a PMD entry, flushes addr 1st and 2nd stage TLBs.
>    */
>   static void stage2_dissolve_pmd(struct kvm *kvm, phys_addr_t addr, pmd_t *pmd)
>   {
> @@ -121,8 +120,7 @@ static void stage2_dissolve_pmd(struct kvm *kvm, phys_addr_t addr, pmd_t *pmd)
>    * @addr:	IPA
>    * @pud:	pud pointer for IPA
>    *
> - * Function clears a PUD entry, flushes addr 1st and 2nd stage TLBs. Marks all
> - * pages in the range dirty.
> + * Function clears a PUD entry, flushes addr 1st and 2nd stage TLBs.
>    */
>   static void stage2_dissolve_pud(struct kvm *kvm, phys_addr_t addr, pud_t *pudp)
>   {
> @@ -899,9 +897,8 @@ int create_hyp_exec_mappings(phys_addr_t phys_addr, size_t size,
>    * kvm_alloc_stage2_pgd - allocate level-1 table for stage-2 translation.
>    * @kvm:	The KVM struct pointer for the VM.
>    *
> - * Allocates only the stage-2 HW PGD level table(s) (can support either full
> - * 40-bit input addresses or limited to 32-bit input addresses). Clears the
> - * allocated pages.
> + * Allocates only the stage-2 HW PGD level table(s) of size defined by
> + * stage2_pgd_size(kvm).
>    *
>    * Note we don't need locking here as this is only called when the VM is
>    * created, which can only be done once.
> @@ -1451,13 +1448,11 @@ static void stage2_wp_pmds(struct kvm *kvm, pud_t *pud,
>   }
>   
>   /**
> -  * stage2_wp_puds - write protect PGD range
> -  * @pgd:	pointer to pgd entry
> -  * @addr:	range start address
> -  * @end:	range end address
> -  *
> -  * Process PUD entries, for a huge PUD we cause a panic.
> -  */
> + * stage2_wp_puds - write protect PGD range
> + * @pgd:	pointer to pgd entry
> + * @addr:	range start address
> + * @end:	range end address
> + */


Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
