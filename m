Return-Path: <SRS0=e8ws=CY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC066C43461
	for <kvmarm@archiver.kernel.org>; Tue, 15 Sep 2020 16:15:18 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2994B21D41
	for <kvmarm@archiver.kernel.org>; Tue, 15 Sep 2020 16:15:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2994B21D41
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 86F724B28A;
	Tue, 15 Sep 2020 12:15:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id euF8+qlynFw9; Tue, 15 Sep 2020 12:15:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 637FC4B266;
	Tue, 15 Sep 2020 12:15:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 660F34B20A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Sep 2020 12:15:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bJ7SY9Mk1G9F for <kvmarm@lists.cs.columbia.edu>;
 Tue, 15 Sep 2020 12:15:14 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2C0654B206
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Sep 2020 12:15:14 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9E38E1FB;
 Tue, 15 Sep 2020 09:15:13 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 33FEF3F68F;
 Tue, 15 Sep 2020 09:15:12 -0700 (PDT)
Subject: Re: [PATCH v5 16/21] KVM: arm64: Add support for relaxing stage-2
 perms in generic page-table code
To: Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu
References: <20200911132529.19844-1-will@kernel.org>
 <20200911132529.19844-17-will@kernel.org>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <595cc73e-636e-8b3a-f93a-b4e9fb218db8@arm.com>
Date: Tue, 15 Sep 2020 17:16:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200911132529.19844-17-will@kernel.org>
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
> Add support for relaxing the permissions of a stage-2 mapping (i.e.
> adding additional permissions) to the generic page-table code.
>
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Quentin Perret <qperret@google.com>
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> Signed-off-by: Will Deacon <will@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_pgtable.h | 19 +++++++++++++++++++
>  arch/arm64/kvm/hyp/pgtable.c         | 20 ++++++++++++++++++++
>  2 files changed, 39 insertions(+)
>
> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> index 77c027456c61..52ab38db04c7 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -236,6 +236,25 @@ kvm_pte_t kvm_pgtable_stage2_mkyoung(struct kvm_pgtable *pgt, u64 addr);
>   */
>  kvm_pte_t kvm_pgtable_stage2_mkold(struct kvm_pgtable *pgt, u64 addr);
>  
> +/**
> + * kvm_pgtable_stage2_relax_perms() - Relax the permissions enforced by a
> + *				      page-table entry.
> + * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init().
> + * @addr:	Intermediate physical address to identify the page-table entry.
> + * @prot:	Additional permissions to grant for the mapping.
> + *
> + * The offset of @addr within a page is ignored.
> + *
> + * If there is a valid, leaf page-table entry used to translate @addr, then
> + * relax the permissions in that entry according to the read, write and
> + * execute permissions specified by @prot. No permissions are removed, and
> + * TLB invalidation is performed after updating the entry.
> + *
> + * Return: 0 on success, negative error code on failure.
> + */
> +int kvm_pgtable_stage2_relax_perms(struct kvm_pgtable *pgt, u64 addr,
> +				   enum kvm_pgtable_prot prot);
> +
>  /**
>   * kvm_pgtable_stage2_is_young() - Test whether a page-table entry has the
>   *				   access flag set.
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index d382756a527c..603d6b415337 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -782,6 +782,26 @@ bool kvm_pgtable_stage2_is_young(struct kvm_pgtable *pgt, u64 addr)
>  	return pte & KVM_PTE_LEAF_ATTR_LO_S2_AF;
>  }
>  
> +int kvm_pgtable_stage2_relax_perms(struct kvm_pgtable *pgt, u64 addr,
> +				   enum kvm_pgtable_prot prot)
> +{
> +	int ret;
> +	kvm_pte_t set = 0, clr = 0;
> +
> +	if (prot & KVM_PGTABLE_PROT_R)
> +		set |= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R;
> +
> +	if (prot & KVM_PGTABLE_PROT_W)
> +		set |= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;
> +
> +	if (prot & KVM_PGTABLE_PROT_X)
> +		clr |= KVM_PTE_LEAF_ATTR_HI_S2_XN;
> +
> +	ret = stage2_update_leaf_attrs(pgt, addr, 1, set, clr, NULL);
> +	kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, pgt->mmu, addr, 0);

We know the level at which the entry is updated, as the visitor has a "level"
parameter, I was wondering if it makes sense to do the TLBI invalidation there.
Struct stage2_attr_data could have an extra field to control if the invalidation
should be done in the visitor.

Thanks,
Alex
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
