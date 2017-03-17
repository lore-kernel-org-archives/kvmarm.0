From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH] kvm: arm/arm64: Simplify lock relaxation in
 stage2_wp_range
Date: Fri, 17 Mar 2017 09:48:34 +0100
Message-ID: <20170317084834.GV1277@cbox>
References: <1489688674-17692-1-git-send-email-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6091240AE8
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Mar 2017 04:47:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WqC-iCV1DFH7 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 17 Mar 2017 04:47:10 -0400 (EDT)
Received: from mail-wm0-f46.google.com (mail-wm0-f46.google.com [74.125.82.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7E7F0405DA
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Mar 2017 04:47:10 -0400 (EDT)
Received: by mail-wm0-f46.google.com with SMTP id t189so10153219wmt.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Mar 2017 01:48:49 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1489688674-17692-1-git-send-email-suzuki.poulose@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Mar 16, 2017 at 06:24:34PM +0000, Suzuki K Poulose wrote:
> From: Marc Zyngier <marc.zyngier@arm.com>
> 
> Add checks to make sure that kvm->mmu_lock is held while calling
> stage2_wp_range. Also avoid explicit checks already done by cond_resched_lock().
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> [ Added assert_spin_locked check ]
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>

Reviewed-by: Christoffer Dall <cdall@linaro.org>

> ---
>  arch/arm/kvm/mmu.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
> index 7628ef1..37e67f5 100644
> --- a/arch/arm/kvm/mmu.c
> +++ b/arch/arm/kvm/mmu.c
> @@ -1162,6 +1162,8 @@ static void stage2_wp_range(struct kvm *kvm, phys_addr_t addr, phys_addr_t end)
>  	pgd_t *pgd;
>  	phys_addr_t next;
>  
> +	assert_spin_locked(&kvm->mmu_lock);
> +
>  	pgd = kvm->arch.pgd + stage2_pgd_index(addr);
>  	do {
>  		/*
> @@ -1171,8 +1173,7 @@ static void stage2_wp_range(struct kvm *kvm, phys_addr_t addr, phys_addr_t end)
>  		 * CONFIG_LOCKDEP. Additionally, holding the lock too long
>  		 * will also starve other vCPUs.
>  		 */
> -		if (need_resched() || spin_needbreak(&kvm->mmu_lock))
> -			cond_resched_lock(&kvm->mmu_lock);
> +		cond_resched_lock(&kvm->mmu_lock);
>  
>  		next = stage2_pgd_addr_end(addr, end);
>  		if (stage2_pgd_present(*pgd))
> -- 
> 2.7.4
> 
