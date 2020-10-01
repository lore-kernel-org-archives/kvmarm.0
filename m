Return-Path: <SRS0=046z=DI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0BEAC4727F
	for <kvmarm@archiver.kernel.org>; Thu,  1 Oct 2020 10:20:48 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 436DC20848
	for <kvmarm@archiver.kernel.org>; Thu,  1 Oct 2020 10:20:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 436DC20848
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9943F4B1E3;
	Thu,  1 Oct 2020 06:20:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id seVkRF99IwSZ; Thu,  1 Oct 2020 06:20:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 30E5C4B181;
	Thu,  1 Oct 2020 06:20:46 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EF5D84B17E
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Oct 2020 06:20:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2onojwITxFge for <kvmarm@lists.cs.columbia.edu>;
 Thu,  1 Oct 2020 06:20:43 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4AE1F4B181
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Oct 2020 06:20:43 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C2A9FD6E;
 Thu,  1 Oct 2020 03:20:42 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5F8B93F70D;
 Thu,  1 Oct 2020 03:20:41 -0700 (PDT)
Subject: Re: [PATCH v5 00/21] KVM: arm64: Rewrite page-table code and fault
 handling
To: Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu
References: <20200911132529.19844-1-will@kernel.org>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <4d89869a-3c36-eadf-ba44-0a65a1fa7d19@arm.com>
Date: Thu, 1 Oct 2020 11:21:43 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200911132529.19844-1-will@kernel.org>
Content-Language: en-US
Cc: Marc Zyngier <maz@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 kernel-team@android.com, linux-arm-kernel@lists.infradead.org
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

On 9/11/20 2:25 PM, Will Deacon wrote:
> It's me again, with version five of the KVM page-table rework previously
> seen at:
>
>   v1: https://lore.kernel.org/r/20200730153406.25136-1-will@kernel.org
>   v2: https://lore.kernel.org/r/20200818132818.16065-1-will@kernel.org
>   v3: https://lore.kernel.org/r/20200825093953.26493-1-will@kernel.org
>   v4: https://lore.kernel.org/r/20200907152344.12978-1-will@kernel.org
>
> Changes since v4 include:
>
>   * Add comments to the kerneldoc describing alignment behaviour for
>     addresses and size parameters
>   * Fix formatting of IPA size messages
>   * Fix handling of unaligned addresses in kvm_phys_addr_ioremap()
>   * Add DSB after zeroing stage-2 PGD pages
>   * Add reviewer tags
>
> Once again, thanks to Alex, Gavin and Andrew for their comments.

I didn't realize that there won't be another iteration of the series. I reviewed
all the patches with the exception of patch #5 ("KVM: arm64: Use generic allocator
for hyp stage-1 page-tables") because I don't know much about what needs to mapped
at EL2 stage 1, everything else looks alright to me. If the commit message can be
modified, you can add my Reviewed-by tag to the series (sans #5); it's fine if
that's not possible.

Thanks,
Alex
>
> Will
>
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Quentin Perret <qperret@google.com>
> Cc: James Morse <james.morse@arm.com>
> Cc: Suzuki Poulose <suzuki.poulose@arm.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Gavin Shan <gshan@redhat.com>
> Cc: Alexandru Elisei <alexandru.elisei@arm.com>
> Cc: Andrew Scull <ascull@google.com>
> Cc: kernel-team@android.com
> Cc: linux-arm-kernel@lists.infradead.org
>
> --->8
>
> Quentin Perret (4):
>   KVM: arm64: Add support for stage-2 write-protect in generic
>     page-table
>   KVM: arm64: Convert write-protect operation to generic page-table API
>   KVM: arm64: Add support for stage-2 cache flushing in generic
>     page-table
>   KVM: arm64: Convert memslot cache-flushing code to generic page-table
>     API
>
> Will Deacon (17):
>   KVM: arm64: Remove kvm_mmu_free_memory_caches()
>   KVM: arm64: Add stand-alone page-table walker infrastructure
>   KVM: arm64: Add support for creating kernel-agnostic stage-1 page
>     tables
>   KVM: arm64: Use generic allocator for hyp stage-1 page-tables
>   KVM: arm64: Add support for creating kernel-agnostic stage-2 page
>     tables
>   KVM: arm64: Add support for stage-2 map()/unmap() in generic
>     page-table
>   KVM: arm64: Convert kvm_phys_addr_ioremap() to generic page-table API
>   KVM: arm64: Convert kvm_set_spte_hva() to generic page-table API
>   KVM: arm64: Convert unmap_stage2_range() to generic page-table API
>   KVM: arm64: Add support for stage-2 page-aging in generic page-table
>   KVM: arm64: Convert page-aging and access faults to generic page-table
>     API
>   KVM: arm64: Add support for relaxing stage-2 perms in generic
>     page-table code
>   KVM: arm64: Convert user_mem_abort() to generic page-table API
>   KVM: arm64: Check the pgt instead of the pgd when modifying page-table
>   KVM: arm64: Remove unused page-table code
>   KVM: arm64: Remove unused 'pgd' field from 'struct kvm_s2_mmu'
>   KVM: arm64: Don't constrain maximum IPA size based on host
>     configuration
>
>  arch/arm64/include/asm/kvm_host.h       |    2 +-
>  arch/arm64/include/asm/kvm_mmu.h        |  251 +---
>  arch/arm64/include/asm/kvm_pgtable.h    |  309 ++++
>  arch/arm64/include/asm/pgtable-hwdef.h  |   24 -
>  arch/arm64/include/asm/pgtable-prot.h   |   19 -
>  arch/arm64/include/asm/stage2_pgtable.h |  215 ---
>  arch/arm64/kvm/arm.c                    |    2 +-
>  arch/arm64/kvm/hyp/Makefile             |    2 +-
>  arch/arm64/kvm/hyp/pgtable.c            |  883 ++++++++++++
>  arch/arm64/kvm/mmu.c                    | 1748 ++++-------------------
>  arch/arm64/kvm/reset.c                  |   40 +-
>  11 files changed, 1479 insertions(+), 2016 deletions(-)
>  create mode 100644 arch/arm64/include/asm/kvm_pgtable.h
>  create mode 100644 arch/arm64/kvm/hyp/pgtable.c
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
