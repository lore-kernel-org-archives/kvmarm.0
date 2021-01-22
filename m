Return-Path: <SRS0=o0cc=GZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66CC5C433E0
	for <kvmarm@archiver.kernel.org>; Fri, 22 Jan 2021 09:45:35 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C39BF23381
	for <kvmarm@archiver.kernel.org>; Fri, 22 Jan 2021 09:45:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C39BF23381
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CFEC14B11D;
	Fri, 22 Jan 2021 04:45:33 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QeapKqH5zjzy; Fri, 22 Jan 2021 04:45:32 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9440B4B13F;
	Fri, 22 Jan 2021 04:45:32 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8A6BB4B11D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Jan 2021 04:45:31 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iryiPa7DUp-I for <kvmarm@lists.cs.columbia.edu>;
 Fri, 22 Jan 2021 04:45:30 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 492794B10F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Jan 2021 04:45:30 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 045AE22DBF;
 Fri, 22 Jan 2021 09:45:29 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1l2t0Q-009NVo-MF; Fri, 22 Jan 2021 09:45:26 +0000
MIME-Version: 1.0
Date: Fri, 22 Jan 2021 09:45:26 +0000
From: Marc Zyngier <maz@kernel.org>
To: Keqian Zhu <zhukeqian1@huawei.com>
Subject: Re: [RFC PATCH] kvm: arm64: Try stage2 block mapping for host device
 MMIO
In-Reply-To: <20210122083650.21812-1-zhukeqian1@huawei.com>
References: <20210122083650.21812-1-zhukeqian1@huawei.com>
User-Agent: Roundcube Webmail/1.4.10
Message-ID: <09d89355cdbbd19c456699774a9a980a@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: zhukeqian1@huawei.com, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, will@kernel.org, catalin.marinas@arm.com,
 mark.rutland@arm.com, james.morse@arm.com, robin.murphy@arm.com,
 joro@8bytes.org, daniel.lezcano@linaro.org, tglx@linutronix.de,
 suzuki.poulose@arm.com, julien.thierry.kdev@gmail.com,
 akpm@linux-foundation.org, alexios.zavras@intel.com,
 wanghaibin.wang@huawei.com, jiangkunkun@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Andrew Morton <akpm@linux-foundation.org>, kvm@vger.kernel.org,
 Catalin Marinas <catalin.marinas@arm.com>, Joerg Roedel <joro@8bytes.org>,
 Daniel Lezcano <daniel.lezcano@linaro.org>, linux-kernel@vger.kernel.org,
 Alexios Zavras <alexios.zavras@intel.com>,
 Thomas Gleixner <tglx@linutronix.de>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 Robin Murphy <robin.murphy@arm.com>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 2021-01-22 08:36, Keqian Zhu wrote:
> The MMIO region of a device maybe huge (GB level), try to use block
> mapping in stage2 to speedup both map and unmap.
> 
> Especially for unmap, it performs TLBI right after each invalidation
> of PTE. If all mapping is of PAGE_SIZE, it takes much time to handle
> GB level range.

This is only on VM teardown, right? Or do you unmap the device more 
ofet?
Can you please quantify the speedup and the conditions this occurs in?

I have the feeling that we are just circling around another problem,
which is that we could rely on a VM-wide TLBI when tearing down the
guest. I worked on something like that[1] a long while ago, and parked
it for some reason. Maybe it is worth reviving.

[1] 
https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h=kvm-arm64/elide-cmo-tlbi

> 
> Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
> ---
>  arch/arm64/include/asm/kvm_pgtable.h | 11 +++++++++++
>  arch/arm64/kvm/hyp/pgtable.c         | 15 +++++++++++++++
>  arch/arm64/kvm/mmu.c                 | 12 ++++++++----
>  3 files changed, 34 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_pgtable.h
> b/arch/arm64/include/asm/kvm_pgtable.h
> index 52ab38db04c7..2266ac45f10c 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -82,6 +82,17 @@ struct kvm_pgtable_walker {
>  	const enum kvm_pgtable_walk_flags	flags;
>  };
> 
> +/**
> + * kvm_supported_pgsize() - Get the max supported page size of a 
> mapping.
> + * @pgt:	Initialised page-table structure.
> + * @addr:	Virtual address at which to place the mapping.
> + * @end:	End virtual address of the mapping.
> + * @phys:	Physical address of the memory to map.
> + *
> + * The smallest return value is PAGE_SIZE.
> + */
> +u64 kvm_supported_pgsize(struct kvm_pgtable *pgt, u64 addr, u64 end, 
> u64 phys);
> +
>  /**
>   * kvm_pgtable_hyp_init() - Initialise a hypervisor stage-1 
> page-table.
>   * @pgt:	Uninitialised page-table structure to initialise.
> diff --git a/arch/arm64/kvm/hyp/pgtable.c 
> b/arch/arm64/kvm/hyp/pgtable.c
> index bdf8e55ed308..ab11609b9b13 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -81,6 +81,21 @@ static bool kvm_block_mapping_supported(u64 addr,
> u64 end, u64 phys, u32 level)
>  	return IS_ALIGNED(addr, granule) && IS_ALIGNED(phys, granule);
>  }
> 
> +u64 kvm_supported_pgsize(struct kvm_pgtable *pgt, u64 addr, u64 end, 
> u64 phys)
> +{
> +	u32 lvl;
> +	u64 pgsize = PAGE_SIZE;
> +
> +	for (lvl = pgt->start_level; lvl < KVM_PGTABLE_MAX_LEVELS; lvl++) {
> +		if (kvm_block_mapping_supported(addr, end, phys, lvl)) {
> +			pgsize = kvm_granule_size(lvl);
> +			break;
> +		}
> +	}
> +
> +	return pgsize;
> +}
> +
>  static u32 kvm_pgtable_idx(struct kvm_pgtable_walk_data *data, u32 
> level)
>  {
>  	u64 shift = kvm_granule_shift(level);
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 7d2257cc5438..80b403fc8e64 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -499,7 +499,8 @@ void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
>  int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
>  			  phys_addr_t pa, unsigned long size, bool writable)
>  {
> -	phys_addr_t addr;
> +	phys_addr_t addr, end;
> +	unsigned long pgsize;
>  	int ret = 0;
>  	struct kvm_mmu_memory_cache cache = { 0, __GFP_ZERO, NULL, };
>  	struct kvm_pgtable *pgt = kvm->arch.mmu.pgt;
> @@ -509,21 +510,24 @@ int kvm_phys_addr_ioremap(struct kvm *kvm,
> phys_addr_t guest_ipa,
> 
>  	size += offset_in_page(guest_ipa);
>  	guest_ipa &= PAGE_MASK;
> +	end = guest_ipa + size;
> 
> -	for (addr = guest_ipa; addr < guest_ipa + size; addr += PAGE_SIZE) {
> +	for (addr = guest_ipa; addr < end; addr += pgsize) {
>  		ret = kvm_mmu_topup_memory_cache(&cache,
>  						 kvm_mmu_cache_min_pages(kvm));
>  		if (ret)
>  			break;
> 
> +		pgsize = kvm_supported_pgsize(pgt, addr, end, pa);
> +
>  		spin_lock(&kvm->mmu_lock);
> -		ret = kvm_pgtable_stage2_map(pgt, addr, PAGE_SIZE, pa, prot,
> +		ret = kvm_pgtable_stage2_map(pgt, addr, pgsize, pa, prot,
>  					     &cache);
>  		spin_unlock(&kvm->mmu_lock);
>  		if (ret)
>  			break;
> 
> -		pa += PAGE_SIZE;
> +		pa += pgsize;
>  	}
> 
>  	kvm_mmu_free_memory_cache(&cache);

This otherwise looks neat enough.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
