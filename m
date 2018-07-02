From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v3 06/20] kvm: arm/arm64: Remove spurious WARN_ON
Date: Mon, 2 Jul 2018 11:01:51 +0100
Message-ID: <daa9d67d-069a-c413-223f-28444341d99d@arm.com>
References: <1530270944-11351-1-git-send-email-suzuki.poulose@arm.com>
 <1530270944-11351-7-git-send-email-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1530270944-11351-7-git-send-email-suzuki.poulose@arm.com>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: Suzuki K Poulose <suzuki.poulose@arm.com>, linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, james.morse@arm.com, cdall@kernel.org, eric.auger@redhat.com, julien.grall@arm.com, will.deacon@arm.com, catalin.marinas@arm.com, punit.agrawal@arm.com, qemu-devel@nongnu.org
List-Id: kvmarm@lists.cs.columbia.edu

On 29/06/18 12:15, Suzuki K Poulose wrote:
> On a 4-level page table pgd entry can be empty, unlike a 3-level
> page table. Remove the spurious WARN_ON() in stage_get_pud().
> 
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Acked-by: Christoffer Dall <cdall@kernel.org>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> ---
>  virt/kvm/arm/mmu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
> index 061e6b3..308171c 100644
> --- a/virt/kvm/arm/mmu.c
> +++ b/virt/kvm/arm/mmu.c
> @@ -976,7 +976,7 @@ static pud_t *stage2_get_pud(struct kvm *kvm, struct kvm_mmu_memory_cache *cache
>  	pud_t *pud;
>  
>  	pgd = kvm->arch.pgd + stage2_pgd_index(addr);
> -	if (WARN_ON(stage2_pgd_none(*pgd))) {
> +	if (stage2_pgd_none(*pgd)) {
>  		if (!cache)
>  			return NULL;
>  		pud = mmu_memory_cache_alloc(cache);
> 

Acked-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny...
