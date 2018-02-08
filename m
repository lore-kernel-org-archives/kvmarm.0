From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v1 07/16] kvm: arm/arm64: Remove spurious WARN_ON
Date: Thu, 8 Feb 2018 12:00:52 +0100
Message-ID: <20180208110052.GJ29286@cbox>
References: <20180109190414.4017-1-suzuki.poulose@arm.com>
 <20180109190414.4017-8-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180109190414.4017-8-suzuki.poulose@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, linux-kernel@vger.kernel.org, kristina.martsenko@arm.com, peter.maydell@linaro.org, pbonzini@redhat.com, rkrcmar@redhat.com, will.deacon@arm.com, ard.biesheuvel@linaro.org, mark.rutland@arm.com, catalin.marinas@arm.com, Christoffer Dall <cdall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Jan 09, 2018 at 07:04:02PM +0000, Suzuki K Poulose wrote:
> On a 4-level page table pgd entry can be empty, unlike a 3-level
> page table. Remove the spurious WARN_ON() in stage_get_pud().

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>

> 
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Cc: Christoffer Dall <cdall@linaro.org>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> ---
>  virt/kvm/arm/mmu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
> index e6548c85c495..78253fe00fc4 100644
> --- a/virt/kvm/arm/mmu.c
> +++ b/virt/kvm/arm/mmu.c
> @@ -870,7 +870,7 @@ static pud_t *stage2_get_pud(struct kvm *kvm, struct kvm_mmu_memory_cache *cache
>  	pud_t *pud;
>  
>  	pgd = kvm->arch.pgd + stage2_pgd_index(addr);
> -	if (WARN_ON(stage2_pgd_none(*pgd))) {
> +	if (stage2_pgd_none(*pgd)) {
>  		if (!cache)
>  			return NULL;
>  		pud = mmu_memory_cache_alloc(cache);
> -- 
> 2.13.6
> 
