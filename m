Return-Path: <SRS0=e8ws=CY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E58FC43461
	for <kvmarm@archiver.kernel.org>; Tue, 15 Sep 2020 10:46:49 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D9C1121D1B
	for <kvmarm@archiver.kernel.org>; Tue, 15 Sep 2020 10:46:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D9C1121D1B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 372A94B329;
	Tue, 15 Sep 2020 06:46:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id m0iJBeEMJVLV; Tue, 15 Sep 2020 06:46:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EC6AE4B315;
	Tue, 15 Sep 2020 06:46:46 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 31E9E4B315
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Sep 2020 06:46:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bgrztZWiFjAT for <kvmarm@lists.cs.columbia.edu>;
 Tue, 15 Sep 2020 06:46:44 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E7B3B4B311
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Sep 2020 06:46:43 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 695701FB;
 Tue, 15 Sep 2020 03:46:43 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F0BEE3F718;
 Tue, 15 Sep 2020 03:46:41 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH v5 06/21] KVM: arm64: Add support for stage-2
 map()/unmap() in generic page-table
To: Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu
References: <20200911132529.19844-1-will@kernel.org>
 <20200911132529.19844-7-will@kernel.org>
Message-ID: <0576714b-ed1a-5bcc-1a98-bca874bf1650@arm.com>
Date: Tue, 15 Sep 2020 11:47:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200911132529.19844-7-will@kernel.org>
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
> Add stage-2 map() and unmap() operations to the generic page-table code.
>
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Quentin Perret <qperret@google.com>
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> Signed-off-by: Will Deacon <will@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_pgtable.h |  46 +++++
>  arch/arm64/kvm/hyp/pgtable.c         | 273 +++++++++++++++++++++++++++
>  2 files changed, 319 insertions(+)
>
> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> index 21d71395a377..895b2238062b 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -140,6 +140,52 @@ int kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm *kvm);
>   */
>  void kvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt);
>  
> +/**
> + * kvm_pgtable_stage2_map() - Install a mapping in a guest stage-2 page-table.
> + * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init().
> + * @addr:	Intermediate physical address at which to place the mapping.
> + * @size:	Size of the mapping.
> + * @phys:	Physical address of the memory to map.
> + * @prot:	Permissions and attributes for the mapping.
> + * @mc:		Cache of pre-allocated GFP_PGTABLE_USER memory from which to
> + *		allocate page-table pages.

In v5.9-rc5, kvm_mmu_topup_memory_cache() allocates GFP_KERNEL_ACCOUNT ==
GFP_KERNEL|__GFP_ACCOUNT memory, not GFP_PGTABLE_USER ==
GFP_KERNEL|__GFP_ZERO|__GFP_ACCOUNT.

Thanks,
Alex
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
