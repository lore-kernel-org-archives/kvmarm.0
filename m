From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH 06/10] KVM: arm/arm64: Only clean the dcache on
 translation fault
Date: Mon, 16 Oct 2017 22:08:11 +0200
Message-ID: <20171016200811.GH1845@lvm>
References: <20171009152032.27804-1-marc.zyngier@arm.com>
 <20171009152032.27804-7-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1E8A649D09
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Oct 2017 16:07:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6XeNijxmhxQO for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 Oct 2017 16:07:18 -0400 (EDT)
Received: from mail-wm0-f49.google.com (mail-wm0-f49.google.com [74.125.82.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 28F1D40638
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Oct 2017 16:07:18 -0400 (EDT)
Received: by mail-wm0-f49.google.com with SMTP id i124so6274501wmf.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Oct 2017 13:08:14 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20171009152032.27804-7-marc.zyngier@arm.com>
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
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Oct 09, 2017 at 04:20:28PM +0100, Marc Zyngier wrote:
> The only case where we actually need to perform a dache maintenance
> is when we map the page for the first time, and subsequent permission
> faults do not require cache maintenance. Let's make it conditional
> on not being a permission fault (and thus a translation fault).

Why do we actually need to do any dcache maintenance when faulting in a
page?

Is this for the case when the stage 1 MMU is disabled, or to support
guest mappings using uncached attributes?  Can we do better, for example
by only flushing the cache if the guest MMU is disabled?

Beyond that:

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>

> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  virt/kvm/arm/mmu.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
> index 1d47da22f75c..1911fadde88b 100644
> --- a/virt/kvm/arm/mmu.c
> +++ b/virt/kvm/arm/mmu.c
> @@ -1400,7 +1400,9 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  			new_pmd = kvm_s2pmd_mkwrite(new_pmd);
>  			kvm_set_pfn_dirty(pfn);
>  		}
> -		coherent_dcache_guest_page(vcpu, pfn, PMD_SIZE);
> +
> +		if (fault_status != FSC_PERM)
> +			coherent_dcache_guest_page(vcpu, pfn, PMD_SIZE);
>  
>  		if (exec_fault) {
>  			new_pmd = kvm_s2pmd_mkexec(new_pmd);
> @@ -1416,7 +1418,9 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  			kvm_set_pfn_dirty(pfn);
>  			mark_page_dirty(kvm, gfn);
>  		}
> -		coherent_dcache_guest_page(vcpu, pfn, PAGE_SIZE);
> +
> +		if (fault_status != FSC_PERM)
> +			coherent_dcache_guest_page(vcpu, pfn, PAGE_SIZE);
>  
>  		if (exec_fault) {
>  			new_pte = kvm_s2pte_mkexec(new_pte);
> -- 
> 2.14.1
> 
