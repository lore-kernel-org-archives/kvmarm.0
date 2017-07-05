From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v2] KVM: arm/arm64: Handle hva aging while destroying the
 vm
Date: Wed, 5 Jul 2017 08:27:23 +0200
Message-ID: <20170705062723.GB18106@cbox>
References: <1499235631-141725-1-git-send-email-agraf@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1499235631-141725-1-git-send-email-agraf@suse.de>
Sender: stable-owner@vger.kernel.org
To: Alexander Graf <agraf@suse.de>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Andrea Arcangeli <aarcange@redhat.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, stable@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Jul 05, 2017 at 08:20:31AM +0200, Alexander Graf wrote:
> The kvm_age_hva callback may be called all the way concurrently while
> kvm_mmu_notifier_release() is running.
> 
> The release function sets kvm->arch.pgd = NULL which the aging function
> however implicitly relies on in stage2_get_pud(). That means they can
> race and the aging function may dereference a NULL pgd pointer.
> 
> This patch adds a check for that case, so that we leave the aging
> function silently.
> 
> Cc: stable@vger.kernel.org
> Fixes: 293f29363 ("kvm-arm: Unmap shadow pagetables properly")
> Signed-off-by: Alexander Graf <agraf@suse.de>

Reviewed-by: Christoffer Dall <cdall@linaro.org>

> 
> ---
> 
> v1 -> v2:
> 
>   - Fix commit message
>   - Add Fixes and stable tags
> ---
>  virt/kvm/arm/mmu.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
> index f2d5b6c..227931f 100644
> --- a/virt/kvm/arm/mmu.c
> +++ b/virt/kvm/arm/mmu.c
> @@ -861,6 +861,10 @@ static pud_t *stage2_get_pud(struct kvm *kvm, struct kvm_mmu_memory_cache *cache
>  	pgd_t *pgd;
>  	pud_t *pud;
>  
> +	/* Do we clash with kvm_free_stage2_pgd()? */
> +	if (!kvm->arch.pgd)
> +		return NULL;
> +
>  	pgd = kvm->arch.pgd + stage2_pgd_index(addr);
>  	if (WARN_ON(stage2_pgd_none(*pgd))) {
>  		if (!cache)
> -- 
> 1.8.5.6
> 
