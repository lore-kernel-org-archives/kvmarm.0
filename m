From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH] kvm/arm: return 0 when the number of objects is not less
 than min
Date: Wed, 5 Dec 2018 09:32:36 +0100
Message-ID: <20181205083236.5tzhnxfhi4h4nknn@kamzik.brq.redhat.com>
References: <1543972551-60951-1-git-send-email-peng.hao2@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1543972551-60951-1-git-send-email-peng.hao2@zte.com.cn>
Sender: linux-kernel-owner@vger.kernel.org
To: Peng Hao <peng.hao2@zte.com.cn>
Cc: christoffer.dall@arm.com, marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Dec 05, 2018 at 09:15:51AM +0800, Peng Hao wrote:
> Return 0 when there is enough kvm_mmu_memory_cache object.
> 
> Signed-off-by: Peng Hao <peng.hao2@zte.com.cn>
> ---
>  virt/kvm/arm/mmu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
> index ed162a6..fcda0ce 100644
> --- a/virt/kvm/arm/mmu.c
> +++ b/virt/kvm/arm/mmu.c
> @@ -127,7 +127,7 @@ static int mmu_topup_memory_cache(struct kvm_mmu_memory_cache *cache,
>  	while (cache->nobjs < max) {
>  		page = (void *)__get_free_page(PGALLOC_GFP);
>  		if (!page)
> -			return -ENOMEM;
> +			return cache->nobjs >= min ? 0 : -ENOMEM;

This condition will never be true here, as the exact same condition is
already checked above, and if it had been true, then we wouldn't be here.

What problem are you attempting to solve?

>  		cache->objects[cache->nobjs++] = page;
>  	}
>  	return 0;
> -- 
> 1.8.3.1
> 
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
