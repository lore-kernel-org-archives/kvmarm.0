Return-Path: <SRS0=046z=DI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9820FC4363D
	for <kvmarm@archiver.kernel.org>; Thu,  1 Oct 2020 01:55:38 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D22862193E
	for <kvmarm@archiver.kernel.org>; Thu,  1 Oct 2020 01:55:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="J97GH49X"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D22862193E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 23E484B1AF;
	Wed, 30 Sep 2020 21:55:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dgvmrJeL26PI; Wed, 30 Sep 2020 21:55:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 00FD44B165;
	Wed, 30 Sep 2020 21:55:36 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 49D494B107
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Sep 2020 21:55:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5ETHLH6Oyac0 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 30 Sep 2020 21:55:31 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B1ED74B0BF
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Sep 2020 21:55:31 -0400 (EDT)
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1601517331;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=9XhKsn6719+YnLKDXxVwE0QQhp6thYQjWNXmAzWCJto=;
 b=J97GH49XzyHZcBWy8/lMFa+58HBhzsYpjzsGI938lfx/l6k6WvNMYPL1cIjrx2rIi0cMCC
 6Iyvux3QIbw8MWRlfXclR16ZdxtvBSiUyu5R+9e65r1mCCDY0e4qmy+e4vMKE2vVuAVxfG
 DprmD0lpd2Y8/9Tct9iSj3IOvhKbbos=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-287-QlHC20ZTP7Gc0NwY6dkCZQ-1; Wed, 30 Sep 2020 21:55:29 -0400
X-MC-Unique: QlHC20ZTP7Gc0NwY6dkCZQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
 [10.5.11.14])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1795780EF8B;
 Thu,  1 Oct 2020 01:55:28 +0000 (UTC)
Received: from [10.64.54.133] (vpn2-54-133.bne.redhat.com [10.64.54.133])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D0AEC5D9D3;
 Thu,  1 Oct 2020 01:55:26 +0000 (UTC)
Subject: Re: [PATCH] KVM: arm64: Pass level hint to TLBI during stage-2
 permission fault
To: Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu
References: <20200930131801.16889-1-will@kernel.org>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <5d54d2cf-d0ec-8fa1-2d92-a89c036d6046@redhat.com>
Date: Thu, 1 Oct 2020 11:55:24 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20200930131801.16889-1-will@kernel.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=gshan@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: Marc Zyngier <maz@kernel.org>, kernel-team@android.com
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
Reply-To: Gavin Shan <gshan@redhat.com>
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

On 9/30/20 11:18 PM, Will Deacon wrote:
> Alex pointed out that we don't pass a level hint to the TLBI instruction
> when handling a stage-2 permission fault, even though the walker does
> at some point have the level information in its hands.
> 
> Rework stage2_update_leaf_attrs() so that it can optionally return the
> level of the updated pte to its caller, which can in turn be used to
> provide the correct TLBI level hint.
> 
> Cc: Marc Zyngier <maz@kernel.org>
> Link: https://lore.kernel.org/r/595cc73e-636e-8b3a-f93a-b4e9fb218db8@arm.com
> Reported-by: Alexandru Elisei <alexandru.elisei@arm.com>
> Signed-off-by: Will Deacon <will@kernel.org>
> ---
>   arch/arm64/kvm/hyp/pgtable.c | 23 ++++++++++++++++-------
>   1 file changed, 16 insertions(+), 7 deletions(-)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index 603d6b415337..0cdf6e461cbd 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -694,6 +694,7 @@ struct stage2_attr_data {
>   	kvm_pte_t	attr_set;
>   	kvm_pte_t	attr_clr;
>   	kvm_pte_t	pte;
> +	u32		level;
>   };
>   
>   static int stage2_attr_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
> @@ -706,6 +707,7 @@ static int stage2_attr_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
>   	if (!kvm_pte_valid(pte))
>   		return 0;
>   
> +	data->level = level;
>   	data->pte = pte;
>   	pte &= ~data->attr_clr;
>   	pte |= data->attr_set;
> @@ -723,7 +725,8 @@ static int stage2_attr_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
>   
>   static int stage2_update_leaf_attrs(struct kvm_pgtable *pgt, u64 addr,
>   				    u64 size, kvm_pte_t attr_set,
> -				    kvm_pte_t attr_clr, kvm_pte_t *orig_pte)
> +				    kvm_pte_t attr_clr, kvm_pte_t *orig_pte,
> +				    u32 *level)
>   {
>   	int ret;
>   	kvm_pte_t attr_mask = KVM_PTE_LEAF_ATTR_LO | KVM_PTE_LEAF_ATTR_HI;
> @@ -743,20 +746,24 @@ static int stage2_update_leaf_attrs(struct kvm_pgtable *pgt, u64 addr,
>   
>   	if (orig_pte)
>   		*orig_pte = data.pte;
> +
> +	if (level)
> +		*level = data.level;
>   	return 0;
>   }
>   
>   int kvm_pgtable_stage2_wrprotect(struct kvm_pgtable *pgt, u64 addr, u64 size)
>   {
>   	return stage2_update_leaf_attrs(pgt, addr, size, 0,
> -					KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W, NULL);
> +					KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W,
> +					NULL, NULL);
>   }
>   
>   kvm_pte_t kvm_pgtable_stage2_mkyoung(struct kvm_pgtable *pgt, u64 addr)
>   {
>   	kvm_pte_t pte = 0;
>   	stage2_update_leaf_attrs(pgt, addr, 1, KVM_PTE_LEAF_ATTR_LO_S2_AF, 0,
> -				 &pte);
> +				 &pte, NULL);
>   	dsb(ishst);
>   	return pte;
>   }
> @@ -765,7 +772,7 @@ kvm_pte_t kvm_pgtable_stage2_mkold(struct kvm_pgtable *pgt, u64 addr)
>   {
>   	kvm_pte_t pte = 0;
>   	stage2_update_leaf_attrs(pgt, addr, 1, 0, KVM_PTE_LEAF_ATTR_LO_S2_AF,
> -				 &pte);
> +				 &pte, NULL);
>   	/*
>   	 * "But where's the TLBI?!", you scream.
>   	 * "Over in the core code", I sigh.
> @@ -778,7 +785,7 @@ kvm_pte_t kvm_pgtable_stage2_mkold(struct kvm_pgtable *pgt, u64 addr)
>   bool kvm_pgtable_stage2_is_young(struct kvm_pgtable *pgt, u64 addr)
>   {
>   	kvm_pte_t pte = 0;
> -	stage2_update_leaf_attrs(pgt, addr, 1, 0, 0, &pte);
> +	stage2_update_leaf_attrs(pgt, addr, 1, 0, 0, &pte, NULL);
>   	return pte & KVM_PTE_LEAF_ATTR_LO_S2_AF;
>   }
>   
> @@ -786,6 +793,7 @@ int kvm_pgtable_stage2_relax_perms(struct kvm_pgtable *pgt, u64 addr,
>   				   enum kvm_pgtable_prot prot)
>   {
>   	int ret;
> +	u32 level;
>   	kvm_pte_t set = 0, clr = 0;
>   
>   	if (prot & KVM_PGTABLE_PROT_R)
> @@ -797,8 +805,9 @@ int kvm_pgtable_stage2_relax_perms(struct kvm_pgtable *pgt, u64 addr,
>   	if (prot & KVM_PGTABLE_PROT_X)
>   		clr |= KVM_PTE_LEAF_ATTR_HI_S2_XN;
>   
> -	ret = stage2_update_leaf_attrs(pgt, addr, 1, set, clr, NULL);
> -	kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, pgt->mmu, addr, 0);
> +	ret = stage2_update_leaf_attrs(pgt, addr, 1, set, clr, NULL, &level);
> +	if (!ret)
> +		kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, pgt->mmu, addr, level);
>   	return ret;
>   }
>   
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
