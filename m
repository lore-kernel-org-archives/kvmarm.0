Return-Path: <SRS0=qtHs=O2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60E01C433EF
	for <kvmarm@archiver.kernel.org>; Wed,  6 Oct 2021 10:41:38 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C6C0561039
	for <kvmarm@archiver.kernel.org>; Wed,  6 Oct 2021 10:41:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org C6C0561039
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 37B6B4B26A;
	Wed,  6 Oct 2021 06:41:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id thyEkdjnGnvl; Wed,  6 Oct 2021 06:41:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 235C74B26D;
	Wed,  6 Oct 2021 06:41:36 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4F7D34B268
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Oct 2021 06:41:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kA7-gT0S6SUb for <kvmarm@lists.cs.columbia.edu>;
 Wed,  6 Oct 2021 06:41:34 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 69BEF4B250
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Oct 2021 06:41:34 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1633516894;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=pSbAB1FpLz0EqbTVsytH0ZxguGzlBKGJojYvPvVsolc=;
 b=SZDT8TQ8wOLcNtrH4GrAht9hhAQ3vICyF3WqYrn/h0ko6RaLZKW7UivZDXK+rKvxuG9Q/O
 fOZqOgqVLW4P3ukvaalimJ89dEuDn8tl90DF8OVYsO7mM+k4V6Pylo7MCgzV/d3oF9zMqU
 kCZfmW4V4HuUYS1ZigN5LlYKFlmtVL0=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-450-Nc6i9wk9Mc-nbCmiU6vToQ-1; Wed, 06 Oct 2021 06:41:33 -0400
X-MC-Unique: Nc6i9wk9Mc-nbCmiU6vToQ-1
Received: by mail-ed1-f71.google.com with SMTP id
 w6-20020a50d786000000b003dabc563406so2195027edi.17
 for <kvmarm@lists.cs.columbia.edu>; Wed, 06 Oct 2021 03:41:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=pSbAB1FpLz0EqbTVsytH0ZxguGzlBKGJojYvPvVsolc=;
 b=op5UmZao5rcMcxcsHBdgsY/3i443RPb+JdvgfWqo/7ycHTrXlg3RhvNiAJClC9tGgm
 nq1f8U1rj//fJAlZuLOkCd0l4QiFCY13geva4wtjkDG6MsByncWQNBo4IcVXHmq9VmXq
 izud7FxOZYVarPDGsKScqc5uPN37Fu5eSG3BHPOfUdy3t4xmZhuc+6wPb6O/XTSd7N/N
 SJsbf7YjF3vg+8EgUhGeqK1FWsQUkDbtzCA57K+efTBuokfJ7zJNsax923pwzCSz69a6
 1jFOvcExkGHn3mPgPN0c9IGYWFqtjFtJ/sqDLhynwWgxcGqpRuujeZAX0xnudBuwJT0K
 6hBQ==
X-Gm-Message-State: AOAM531R4N1ZeW2cCn3k4t84mV8vCiPck1N+kjNKuzjzcwrZlZHuMEwf
 zuMzmc1mBITcE3FBbp8epNmrKcFSH1igR4xOgkRlIiu96fCMcWPEoz/Yx2XCKMu3NxTdcSRcBZe
 8LLlwTKE5QaW6oTsq9C0cKD5H
X-Received: by 2002:a05:6402:1259:: with SMTP id
 l25mr9211093edw.344.1633516891971; 
 Wed, 06 Oct 2021 03:41:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxsOxOanoU2WsmUTn0+TJD/8wKuiodjYexDFyKIk7g9DkrwyVhAlxgYFvN9xA5V8tJSD+COsA==
X-Received: by 2002:a05:6402:1259:: with SMTP id
 l25mr9211064edw.344.1633516891776; 
 Wed, 06 Oct 2021 03:41:31 -0700 (PDT)
Received: from gator.home (cst2-174-28.cust.vodafone.cz. [31.30.174.28])
 by smtp.gmail.com with ESMTPSA id q18sm8991596ejc.84.2021.10.06.03.41.30
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 06 Oct 2021 03:41:31 -0700 (PDT)
Date: Wed, 6 Oct 2021 12:41:29 +0200
From: Andrew Jones <drjones@redhat.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2 02/16] KVM: arm64: Check for PTE valitity when
 checking for executable/cacheable
Message-ID: <20211006104129.s5az46tpny2csfge@gator.home>
References: <20211004174849.2831548-1-maz@kernel.org>
 <20211004174849.2831548-3-maz@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20211004174849.2831548-3-maz@kernel.org>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: kernel-team@android.com, kvm@vger.kernel.org,
 Srivatsa Vaddagiri <vatsa@codeaurora.org>, linux-kernel@vger.kernel.org,
 Steven Price <steven.price@arm.com>,
 Shanker R Donthineni <sdonthineni@nvidia.com>, will@kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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


Hi Marc,

sed s/valitity/validity/ <<<"$SUBJECT"

On Mon, Oct 04, 2021 at 06:48:35PM +0100, Marc Zyngier wrote:
> Don't blindly assume that the PTE is valid when checking whether
> it describes an executable or cacheable mapping.
> 
> This makes sure that we don't issue CMOs for invalid mappings.
> 
> Suggested-by: Will Deacon <will@kernel.org>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/hyp/pgtable.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index f8ceebe4982e..6bbfd952f0c5 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -638,12 +638,12 @@ static void stage2_put_pte(kvm_pte_t *ptep, struct kvm_s2_mmu *mmu, u64 addr,
>  static bool stage2_pte_cacheable(struct kvm_pgtable *pgt, kvm_pte_t pte)
>  {
>  	u64 memattr = pte & KVM_PTE_LEAF_ATTR_LO_S2_MEMATTR;
> -	return memattr == KVM_S2_MEMATTR(pgt, NORMAL);
> +	return kvm_pte_valid(pte) && memattr == KVM_S2_MEMATTR(pgt, NORMAL);
>  }
>  
>  static bool stage2_pte_executable(kvm_pte_t pte)
>  {
> -	return !(pte & KVM_PTE_LEAF_ATTR_HI_S2_XN);
> +	return kvm_pte_valid(pte) && !(pte & KVM_PTE_LEAF_ATTR_HI_S2_XN);
>  }
>  
>  static bool stage2_leaf_mapping_allowed(u64 addr, u64 end, u32 level,
> @@ -688,8 +688,7 @@ static int stage2_map_walker_try_leaf(u64 addr, u64 end, u32 level,
>  	/* Perform CMOs before installation of the guest stage-2 PTE */
>  	if (mm_ops->dcache_clean_inval_poc && stage2_pte_cacheable(pgt, new))
>  		mm_ops->dcache_clean_inval_poc(kvm_pte_follow(new, mm_ops),
> -						granule);
> -
> +					       granule);
>  	if (mm_ops->icache_inval_pou && stage2_pte_executable(new))
>  		mm_ops->icache_inval_pou(kvm_pte_follow(new, mm_ops), granule);
>  
> @@ -1091,7 +1090,7 @@ static int stage2_flush_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
>  	kvm_pte_t pte = *ptep;
>  	kvm_pte_t *pte_follow;
>  
> -	if (!kvm_pte_valid(pte) || !stage2_pte_cacheable(pgt, pte))
> +	if (!stage2_pte_cacheable(pgt, pte))
>  		return 0;
>  
>  	pte_follow = kvm_pte_follow(pte, mm_ops);
> -- 
> 2.30.2
> 

Reviewed-by: Andrew Jones <drjones@redhat.com>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
