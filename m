Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1ACD2C4332F
	for <kvmarm@archiver.kernel.org>; Thu, 10 Nov 2022 05:30:25 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8300A4BA65;
	Thu, 10 Nov 2022 00:30:25 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UlJvmSUZJf+d; Thu, 10 Nov 2022 00:30:24 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3A0B34BA68;
	Thu, 10 Nov 2022 00:30:24 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 56A704BA61
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Nov 2022 00:30:22 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Hnz2JfVAltn9 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Nov 2022 00:30:21 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1B1D34BA3A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Nov 2022 00:30:21 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1668058220;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=Z+3st8TO3e855V6+DIflFvHBaMFaHjDgFwlaiI9v3DE=;
 b=Wi1gyxm5MfYM7DaTbw2cv7KD3eNjZL4bqprTrToPSO311Kh2ExLPKP5BGVRNFw2EK7dG1x
 YCr/owx0XpqHC1kooOOoACwXFz9eoixkVJZW1VezqotG65T8RHIR2gAn3m7AFmL7+HGnXQ
 4/L9N4lNnbzSmkhD729Z0NBte/mEHmw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-218-LmeqcBKxNzm9rStiBQzh0Q-1; Thu, 10 Nov 2022 00:30:17 -0500
X-MC-Unique: LmeqcBKxNzm9rStiBQzh0Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 730EA802804;
 Thu, 10 Nov 2022 05:30:16 +0000 (UTC)
Received: from [10.64.54.49] (vpn2-54-49.bne.redhat.com [10.64.54.49])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 512032166B29;
 Thu, 10 Nov 2022 05:30:11 +0000 (UTC)
Subject: Re: [PATCH v5 04/14] KVM: arm64: Don't pass kvm_pgtable through
 kvm_pgtable_walk_data
To: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>,
 James Morse <james.morse@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>
References: <20221107215644.1895162-1-oliver.upton@linux.dev>
 <20221107215644.1895162-5-oliver.upton@linux.dev>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <acce8160-a559-648f-ea9f-995843b9a3fb@redhat.com>
Date: Thu, 10 Nov 2022 13:30:08 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20221107215644.1895162-5-oliver.upton@linux.dev>
Content-Language: en-US
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Ben Gardon <bgardon@google.com>, David Matlack <dmatlack@google.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

Hi Oliver,

On 11/8/22 5:56 AM, Oliver Upton wrote:
> In order to tear down page tables from outside the context of
> kvm_pgtable (such as an RCU callback), stop passing a pointer through
> kvm_pgtable_walk_data.
> 
> No functional change intended.
> 
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>   arch/arm64/kvm/hyp/pgtable.c | 18 +++++-------------
>   1 file changed, 5 insertions(+), 13 deletions(-)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index db25e81a9890..93989b750a26 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -50,7 +50,6 @@
>   #define KVM_MAX_OWNER_ID		1
>   
>   struct kvm_pgtable_walk_data {
> -	struct kvm_pgtable		*pgt;
>   	struct kvm_pgtable_walker	*walker;
>   
>   	u64				addr;

Ok. Here is the answer why data->pgt->mm_ops isn't reachable in the walker
and visitor, and @mm_ops needs to be passed down.

> @@ -88,7 +87,7 @@ static u32 kvm_pgtable_idx(struct kvm_pgtable_walk_data *data, u32 level)
>   	return (data->addr >> shift) & mask;
>   }
>   
> -static u32 __kvm_pgd_page_idx(struct kvm_pgtable *pgt, u64 addr)
> +static u32 kvm_pgd_page_idx(struct kvm_pgtable *pgt, u64 addr)
>   {
>   	u64 shift = kvm_granule_shift(pgt->start_level - 1); /* May underflow */
>   	u64 mask = BIT(pgt->ia_bits) - 1;
> @@ -96,11 +95,6 @@ static u32 __kvm_pgd_page_idx(struct kvm_pgtable *pgt, u64 addr)
>   	return (addr & mask) >> shift;
>   }
>   
> -static u32 kvm_pgd_page_idx(struct kvm_pgtable_walk_data *data)
> -{
> -	return __kvm_pgd_page_idx(data->pgt, data->addr);
> -}
> -
>   static u32 kvm_pgd_pages(u32 ia_bits, u32 start_level)
>   {
>   	struct kvm_pgtable pgt = {
> @@ -108,7 +102,7 @@ static u32 kvm_pgd_pages(u32 ia_bits, u32 start_level)
>   		.start_level	= start_level,
>   	};
>   
> -	return __kvm_pgd_page_idx(&pgt, -1ULL) + 1;
> +	return kvm_pgd_page_idx(&pgt, -1ULL) + 1;
>   }
>   
>   static bool kvm_pte_table(kvm_pte_t pte, u32 level)
> @@ -255,11 +249,10 @@ static int __kvm_pgtable_walk(struct kvm_pgtable_walk_data *data,
>   	return ret;
>   }
>   
> -static int _kvm_pgtable_walk(struct kvm_pgtable_walk_data *data)
> +static int _kvm_pgtable_walk(struct kvm_pgtable *pgt, struct kvm_pgtable_walk_data *data)
>   {
>   	u32 idx;
>   	int ret = 0;
> -	struct kvm_pgtable *pgt = data->pgt;
>   	u64 limit = BIT(pgt->ia_bits);
>   
>   	if (data->addr > limit || data->end > limit)
> @@ -268,7 +261,7 @@ static int _kvm_pgtable_walk(struct kvm_pgtable_walk_data *data)
>   	if (!pgt->pgd)
>   		return -EINVAL;
>   
> -	for (idx = kvm_pgd_page_idx(data); data->addr < data->end; ++idx) {
> +	for (idx = kvm_pgd_page_idx(pgt, data->addr); data->addr < data->end; ++idx) {
>   		kvm_pte_t *ptep = &pgt->pgd[idx * PTRS_PER_PTE];
>   
>   		ret = __kvm_pgtable_walk(data, pgt->mm_ops, ptep, pgt->start_level);
> @@ -283,13 +276,12 @@ int kvm_pgtable_walk(struct kvm_pgtable *pgt, u64 addr, u64 size,
>   		     struct kvm_pgtable_walker *walker)
>   {
>   	struct kvm_pgtable_walk_data walk_data = {
> -		.pgt	= pgt,
>   		.addr	= ALIGN_DOWN(addr, PAGE_SIZE),
>   		.end	= PAGE_ALIGN(walk_data.addr + size),
>   		.walker	= walker,
>   	};
>   
> -	return _kvm_pgtable_walk(&walk_data);
> +	return _kvm_pgtable_walk(pgt, &walk_data);
>   }
>   
>   struct leaf_walk_data {
> 

Thanks,
Gavin

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
