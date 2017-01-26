From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 1/3] arm/arm64: KVM: Enforce unconditional flush to PoC
 when mapping to stage-2
Date: Thu, 26 Jan 2017 14:19:59 +0100
Message-ID: <20170126131959.GX15850@cbox>
References: <1485358591-12278-1-git-send-email-marc.zyngier@arm.com>
 <1485358591-12278-2-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0C5814019A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Jan 2017 08:20:05 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VeqW5PGaOaH9 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 26 Jan 2017 08:19:58 -0500 (EST)
Received: from mail-lf0-f45.google.com (mail-lf0-f45.google.com
 [209.85.215.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AE3D740064
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Jan 2017 08:19:56 -0500 (EST)
Received: by mail-lf0-f45.google.com with SMTP id n124so144973170lfd.2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Jan 2017 05:20:07 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1485358591-12278-2-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Jan 25, 2017 at 03:36:29PM +0000, Marc Zyngier wrote:
> When we fault in a page, we flush it to the PoC (Point of Coherency)
> if the faulting vcpu has its own caches off, so that it can observe
> the page we just brought it.
> 
> But if the vcpu has its caches on, we skip that step. Bad things
> happen when *another* vcpu tries to access that page with its own
> caches disabled. At that point, there is no garantee that the
> data has made it to the PoC, and we access stale data.
> 
> The obvious fix is to always flush to PoC when a page is faulted
> in, no matter what the state of the vcpu is.
> 
> Cc: stable@vger.kernel.org
> Fixes: 2d58b733c876 ("arm64: KVM: force cache clean on page fault when caches are off")
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>

> ---
>  arch/arm/include/asm/kvm_mmu.h   | 9 +--------
>  arch/arm64/include/asm/kvm_mmu.h | 3 +--
>  2 files changed, 2 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
> index 74a44727..a58bbaa 100644
> --- a/arch/arm/include/asm/kvm_mmu.h
> +++ b/arch/arm/include/asm/kvm_mmu.h
> @@ -150,18 +150,12 @@ static inline void __coherent_cache_guest_page(struct kvm_vcpu *vcpu,
>  	 * and iterate over the range.
>  	 */
>  
> -	bool need_flush = !vcpu_has_cache_enabled(vcpu) || ipa_uncached;
> -
>  	VM_BUG_ON(size & ~PAGE_MASK);
>  
> -	if (!need_flush && !icache_is_pipt())
> -		goto vipt_cache;
> -
>  	while (size) {
>  		void *va = kmap_atomic_pfn(pfn);
>  
> -		if (need_flush)
> -			kvm_flush_dcache_to_poc(va, PAGE_SIZE);
> +		kvm_flush_dcache_to_poc(va, PAGE_SIZE);
>  
>  		if (icache_is_pipt())
>  			__cpuc_coherent_user_range((unsigned long)va,
> @@ -173,7 +167,6 @@ static inline void __coherent_cache_guest_page(struct kvm_vcpu *vcpu,
>  		kunmap_atomic(va);
>  	}
>  
> -vipt_cache:
>  	if (!icache_is_pipt() && !icache_is_vivt_asid_tagged()) {
>  		/* any kind of VIPT cache */
>  		__flush_icache_all();
> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
> index 6f72fe8..6d22017 100644
> --- a/arch/arm64/include/asm/kvm_mmu.h
> +++ b/arch/arm64/include/asm/kvm_mmu.h
> @@ -241,8 +241,7 @@ static inline void __coherent_cache_guest_page(struct kvm_vcpu *vcpu,
>  {
>  	void *va = page_address(pfn_to_page(pfn));
>  
> -	if (!vcpu_has_cache_enabled(vcpu) || ipa_uncached)
> -		kvm_flush_dcache_to_poc(va, size);
> +	kvm_flush_dcache_to_poc(va, size);
>  
>  	if (!icache_is_aliasing()) {		/* PIPT */
>  		flush_icache_range((unsigned long)va,
> -- 
> 2.1.4
> 
