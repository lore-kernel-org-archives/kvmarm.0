Return-Path: <SRS0=ROvZ=CM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9649BC433E7
	for <kvmarm@archiver.kernel.org>; Thu,  3 Sep 2020 04:55:45 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 19C0B20758
	for <kvmarm@archiver.kernel.org>; Thu,  3 Sep 2020 04:55:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="i/5hcZNf"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 19C0B20758
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A671A4B36C;
	Thu,  3 Sep 2020 00:55:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4nQ-nZD04c2N; Thu,  3 Sep 2020 00:55:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 946114B36A;
	Thu,  3 Sep 2020 00:55:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 68EDC4B36A
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Sep 2020 00:55:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JhDs6TxmZ+dG for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Sep 2020 00:55:41 -0400 (EDT)
Received: from us-smtp-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [205.139.110.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 820DF4B368
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Sep 2020 00:55:41 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1599108941;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=GeNpPjJerJbmLbrpY04BHAti5k/oaonALy6TuMm2dWQ=;
 b=i/5hcZNfpZnCTWGO+AsSooNYiNCUouQnhXs/pqb1Z04AEVg3wYBkOgP6PUtXMgXBwnmTdn
 uYmlVaC3U2mF7aMdB7DAHyo6kewZgQ1R/KFpiro5cOY6ng1ONW0x4OS76G4o4Pnuh5MFFx
 BfXKw0tjfcmB42ucUgbG4P2R25FHftQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-330-XrNZi_vzOH-WTNCbZtQqog-1; Thu, 03 Sep 2020 00:55:37 -0400
X-MC-Unique: XrNZi_vzOH-WTNCbZtQqog-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com
 [10.5.11.15])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1A91D801FC6;
 Thu,  3 Sep 2020 04:55:36 +0000 (UTC)
Received: from [10.64.54.159] (vpn2-54-159.bne.redhat.com [10.64.54.159])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E447B8118C;
 Thu,  3 Sep 2020 04:55:33 +0000 (UTC)
Subject: Re: [PATCH v3 16/21] KVM: arm64: Add support for relaxing stage-2
 perms in generic page-table code
To: Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu
References: <20200825093953.26493-1-will@kernel.org>
 <20200825093953.26493-17-will@kernel.org>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <da1c4375-aace-3cfd-ec9b-3d1f43e27a7c@redhat.com>
Date: Thu, 3 Sep 2020 14:55:31 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20200825093953.26493-17-will@kernel.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=gshan@redhat.com
X-Mimecast-Spam-Score: 0.002
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: Marc Zyngier <maz@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 kernel-team@android.com, linux-arm-kernel@lists.infradead.org
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

Hi Will,

On 8/25/20 7:39 PM, Will Deacon wrote:
> Add support for relaxing the permissions of a stage-2 mapping (i.e.
> adding additional permissions) to the generic page-table code.
> 
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Quentin Perret <qperret@google.com>
> Signed-off-by: Will Deacon <will@kernel.org>
> ---
>   arch/arm64/include/asm/kvm_pgtable.h | 17 +++++++++++++++++
>   arch/arm64/kvm/hyp/pgtable.c         | 20 ++++++++++++++++++++
>   2 files changed, 37 insertions(+)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> index ea823fe31913..0d7077c34152 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -216,6 +216,23 @@ kvm_pte_t kvm_pgtable_stage2_mkyoung(struct kvm_pgtable *pgt, u64 addr);
>    */
>   kvm_pte_t kvm_pgtable_stage2_mkold(struct kvm_pgtable *pgt, u64 addr);
>   
> +/**
> + * kvm_pgtable_stage2_relax_perms() - Relax the permissions enforced by a
> + *				      page-table entry.
> + * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init().
> + * @addr:	Intermediate physical address to identify the page-table entry.
> + * @prot:	Additional permissions to grant for the mapping.
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
>   /**
>    * kvm_pgtable_stage2_is_young() - Test whether a page-table entry has the
>    *				   access flag set.
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index 75887185f1e2..6e8ca1ec12b4 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -762,6 +762,26 @@ bool kvm_pgtable_stage2_is_young(struct kvm_pgtable *pgt, u64 addr)
>   	return pte & KVM_PTE_LEAF_ATTR_LO_S2_AF;
>   }
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
> +	return ret;
> +}
> +
>   static int stage2_flush_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
>   			       enum kvm_pgtable_walk_flags flag,
>   			       void * const arg)
> 

Thanks,
Gavin

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
