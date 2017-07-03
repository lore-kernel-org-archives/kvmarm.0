From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH] KVM: arm/arm64: Handle hva aging while destroying the vm
Date: Mon, 3 Jul 2017 10:03:13 +0200
Message-ID: <20170703080313.GB4066@cbox>
References: <1498231319-199734-1-git-send-email-agraf@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 238CA40CE9
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Jul 2017 04:03:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OcGeMcx-hQMJ for <kvmarm@lists.cs.columbia.edu>;
 Mon,  3 Jul 2017 04:02:59 -0400 (EDT)
Received: from mail-wm0-f48.google.com (mail-wm0-f48.google.com [74.125.82.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D886040CE4
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Jul 2017 04:02:58 -0400 (EDT)
Received: by mail-wm0-f48.google.com with SMTP id i127so99342223wma.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 03 Jul 2017 01:03:17 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1498231319-199734-1-git-send-email-agraf@suse.de>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Alexander Graf <agraf@suse.de>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Alex,

On Fri, Jun 23, 2017 at 05:21:59PM +0200, Alexander Graf wrote:
> If we want to age an HVA while the VM is getting destroyed, we have a
> tiny race window during which we may end up dereferencing an invalid
> kvm->arch.pgd value.
> 
>    CPU0               CPU1
> 
>    kvm_age_hva()
>                       kvm_mmu_notifier_release()
>                       kvm_arch_flush_shadow_all()
>                       kvm_free_stage2_pgd()
>                       <grab mmu_lock>
>    stage2_get_pmd()
>    <wait for mmu_lock>
>                       set kvm->arch.pgd = 0
>                       <free mmu_lock>
>    <grab mmu_lock>
>    stage2_get_pud()
>    <access kvm->arch.pgd>
>    <use incorrect value>

I don't think this sequence, can happen, but I think kvm_age_hva() can
be called with the mmu_lock held and kvm->pgd already being NULL.

Is that possible for the mmu notifiers to be calling clear(_flush)_young
while also calling notifier_release?

If so, the patch below looks good to me.

Thanks,
-Christoffer


> 
> This patch adds a check for that case.
> 
> Signed-off-by: Alexander Graf <agraf@suse.de>
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
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
