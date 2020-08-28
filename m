Return-Path: <SRS0=xBPq=CG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B600C433E2
	for <kvmarm@archiver.kernel.org>; Fri, 28 Aug 2020 16:31:25 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CFFE520872
	for <kvmarm@archiver.kernel.org>; Fri, 28 Aug 2020 16:31:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CFFE520872
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 557A14C266;
	Fri, 28 Aug 2020 12:31:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0jkxDE4IkDY0; Fri, 28 Aug 2020 12:31:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 260B94C25C;
	Fri, 28 Aug 2020 12:31:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 71F404C25C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Aug 2020 12:31:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1gcOw4uyVkHl for <kvmarm@lists.cs.columbia.edu>;
 Fri, 28 Aug 2020 12:31:20 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4132C4C239
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Aug 2020 12:31:20 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9F5781FB;
 Fri, 28 Aug 2020 09:31:19 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C69B83F71F;
 Fri, 28 Aug 2020 09:31:18 -0700 (PDT)
Subject: Re: [PATCH v3 04/21] KVM: arm64: Use generic allocator for hyp
 stage-1 page-tables
To: Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu
References: <20200825093953.26493-1-will@kernel.org>
 <20200825093953.26493-5-will@kernel.org>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <35435dcb-e821-3769-ac0f-e75b1ede237f@arm.com>
Date: Fri, 28 Aug 2020 17:32:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200825093953.26493-5-will@kernel.org>
Content-Language: en-US
Cc: Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
 linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Will,

The code looks much nicer with the el2 page table allocator. One minor nitpick below.

On 8/25/20 10:39 AM, Will Deacon wrote:
> Now that we have a shiny new page-table allocator, replace the hyp
> page-table code with calls into the new API. This also allows us to
> remove the extended idmap code, as we can now simply ensure that the
> VA size is large enough to map everything we need.
>
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Quentin Perret <qperret@google.com>
> Signed-off-by: Will Deacon <will@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_mmu.h       |  78 +----
>  arch/arm64/include/asm/kvm_pgtable.h   |   5 +
>  arch/arm64/include/asm/pgtable-hwdef.h |   6 -
>  arch/arm64/include/asm/pgtable-prot.h  |   6 -
>  arch/arm64/kvm/mmu.c                   | 414 +++----------------------
>  5 files changed, 45 insertions(+), 464 deletions(-)
>
> [..]
> @@ -2356,6 +2028,7 @@ static int kvm_map_idmap_text(pgd_t *pgd)
>  int kvm_mmu_init(void)
>  {
>  	int err;
> +	u32 hyp_va_bits;
>  
>  	hyp_idmap_start = __pa_symbol(__hyp_idmap_text_start);
>  	hyp_idmap_start = ALIGN_DOWN(hyp_idmap_start, PAGE_SIZE);
> @@ -2369,6 +2042,8 @@ int kvm_mmu_init(void)
>  	 */
>  	BUG_ON((hyp_idmap_start ^ (hyp_idmap_end - 1)) & PAGE_MASK);
>  
> +	hyp_va_bits = 64 - ((idmap_t0sz & TCR_T0SZ_MASK) >> TCR_T0SZ_OFFSET);

idmap_t0sz is defined in mm/mmu.c as: TCR_T0SZ(VA_BITS) = (UL(64) - VA_BITS) <<
TCR_T0SZ_OFFSET. Looks to me like hyp_va_bits == VA_BITS.

Thanks,
Alex
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
