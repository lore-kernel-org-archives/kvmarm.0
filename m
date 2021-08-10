Return-Path: <SRS0=u6p1=NB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75DA9C4338F
	for <kvmarm@archiver.kernel.org>; Tue, 10 Aug 2021 13:33:33 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D5F0A61008
	for <kvmarm@archiver.kernel.org>; Tue, 10 Aug 2021 13:33:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org D5F0A61008
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 603794A4CD;
	Tue, 10 Aug 2021 09:33:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Rwlk4RCGLsjX; Tue, 10 Aug 2021 09:33:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EF9774A483;
	Tue, 10 Aug 2021 09:33:26 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7370C40630
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Aug 2021 09:33:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2CnDaDivkW8G for <kvmarm@lists.cs.columbia.edu>;
 Tue, 10 Aug 2021 09:33:21 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E53B04029C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Aug 2021 09:33:20 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id EDFE960FDA;
 Tue, 10 Aug 2021 13:33:19 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1mDRsb-0044Ei-UE; Tue, 10 Aug 2021 14:33:18 +0100
MIME-Version: 1.0
Date: Tue, 10 Aug 2021 14:33:17 +0100
From: Marc Zyngier <maz@kernel.org>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: Re: [PATCH 1/5] KVM: arm64: Drop direct PAGE_[SHIFT|SIZE] usage as
 page size
In-Reply-To: <1628578961-29097-2-git-send-email-anshuman.khandual@arm.com>
References: <1628578961-29097-1-git-send-email-anshuman.khandual@arm.com>
 <1628578961-29097-2-git-send-email-anshuman.khandual@arm.com>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <25ee7799069492f2501003faec7f9732@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: anshuman.khandual@arm.com,
 linux-arm-kernel@lists.infradead.org, james.morse@arm.com,
 alexandru.elisei@arm.com, suzuki.poulose@arm.com, catalin.marinas@arm.com,
 will@kernel.org, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Will Deacon <will@kernel.org>, linux-kernel@vger.kernel.org,
 Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

On 2021-08-10 08:02, Anshuman Khandual wrote:
> All instances here could just directly test against 
> CONFIG_ARM64_XXK_PAGES
> instead of evaluating via PAGE_SHIFT or PAGE_SIZE. With this change, 
> there
> will be no such usage left.
> 
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: James Morse <james.morse@arm.com>
> Cc: Alexandru Elisei <alexandru.elisei@arm.com>
> Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: kvmarm@lists.cs.columbia.edu
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> ---
>  arch/arm64/kvm/hyp/pgtable.c | 6 +++---
>  arch/arm64/mm/mmu.c          | 2 +-
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/pgtable.c 
> b/arch/arm64/kvm/hyp/pgtable.c
> index 05321f4165e3..a6112b6d6ef6 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -85,7 +85,7 @@ static bool kvm_level_supports_block_mapping(u32 
> level)
>  	 * Reject invalid block mappings and don't bother with 4TB mappings 
> for
>  	 * 52-bit PAs.
>  	 */
> -	return !(level == 0 || (PAGE_SIZE != SZ_4K && level == 1));
> +	return !(level == 0 || (!IS_ENABLED(CONFIG_ARM64_4K_PAGES) && level 
> == 1));
>  }
> 
>  static bool kvm_block_mapping_supported(u64 addr, u64 end, u64 phys, 
> u32 level)
> @@ -155,7 +155,7 @@ static u64 kvm_pte_to_phys(kvm_pte_t pte)
>  {
>  	u64 pa = pte & KVM_PTE_ADDR_MASK;
> 
> -	if (PAGE_SHIFT == 16)
> +	if (IS_ENABLED(CONFIG_ARM64_64K_PAGES))
>  		pa |= FIELD_GET(KVM_PTE_ADDR_51_48, pte) << 48;
> 
>  	return pa;
> @@ -165,7 +165,7 @@ static kvm_pte_t kvm_phys_to_pte(u64 pa)
>  {
>  	kvm_pte_t pte = pa & KVM_PTE_ADDR_MASK;
> 
> -	if (PAGE_SHIFT == 16)
> +	if (IS_ENABLED(CONFIG_ARM64_64K_PAGES))
>  		pte |= FIELD_PREP(KVM_PTE_ADDR_51_48, pa >> 48);
> 
>  	return pte;
> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
> index 9ff0de1b2b93..8fdfca179815 100644
> --- a/arch/arm64/mm/mmu.c
> +++ b/arch/arm64/mm/mmu.c
> @@ -296,7 +296,7 @@ static void alloc_init_cont_pmd(pud_t *pudp,
> unsigned long addr,
>  static inline bool use_1G_block(unsigned long addr, unsigned long 
> next,
>  			unsigned long phys)
>  {
> -	if (PAGE_SHIFT != 12)
> +	if (!IS_ENABLED(CONFIG_ARM64_4K_PAGES))
>  		return false;
> 
>  	if (((addr | next | phys) & ~PUD_MASK) != 0)

I personally find it a lot less readable.

Also, there is no evaluation whatsoever. All the code guarded
by a PAGE_SIZE/PAGE_SHIFT that doesn't match the configuration
is dropped at compile time.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
