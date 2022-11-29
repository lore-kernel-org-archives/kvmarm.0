Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 655C4C433FE
	for <kvmarm@archiver.kernel.org>; Tue, 29 Nov 2022 21:00:53 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D8E444B3D2;
	Tue, 29 Nov 2022 16:00:52 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Lc9b2ixSrgbo; Tue, 29 Nov 2022 16:00:51 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9F9B540DE1;
	Tue, 29 Nov 2022 16:00:51 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 121B640DE1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Nov 2022 16:00:51 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oohKm7hywMzQ for <kvmarm@lists.cs.columbia.edu>;
 Tue, 29 Nov 2022 16:00:49 -0500 (EST)
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com
 [209.85.215.171])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AFFA2403D4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Nov 2022 16:00:49 -0500 (EST)
Received: by mail-pg1-f171.google.com with SMTP id 82so6696162pgc.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Nov 2022 13:00:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
 bh=Cv7bP6Ykoos9p/GSChQ3hTQpD+T90m2BXvicS8ztKkY=;
 b=LjZa0NyucvKgdFLDZuq/BMDOGwBjA+nS/RFT6FpAkCYZ7VfBn0Zxee9PeRD82I1fN8
 E1bQmWmUQrYGjJni2jrPozVvZT6FDGsqjfy66v3/QQydBYikDmMXH+ULHSk0nfg5QSgP
 h2iuulqYQXz4Su5XKM7uealW6p3CrNk550WHCTnvyoaxLQ2nrEZ/yq8ti7QR4HBj3SgA
 e2RMNQY1NIW38zpdVC5XjX/JXKOVp5mVsxFXRDDscvhzdzCyA92Vs9g2XJUGfFl2xb2C
 kMb9AoRdkWS7O20ZHucbwBET0m1JZX9LwgAZUQyQ6um1Fl+numP+ifFobdYTGf4+VA8/
 rP2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=Cv7bP6Ykoos9p/GSChQ3hTQpD+T90m2BXvicS8ztKkY=;
 b=O9WSvqtyomBYRPwQdEIFtcgvjTd1CQjf2MlCt3pZWIYifAlqhdR0ead8K5jKDckLpL
 nbRAGtJh+RZfGbcQeHIUobxGfrVxWkE+ZhuGqCJZgx9Ao76OW72QAZVKrRq/QJusnEEN
 BycxQBL1wYFIur231Eu3ha+3VmUyMP6lXTe4YoSuBzBd509NWA7+A/hq2GiYARvf6WWU
 k0c7/qoaoCvHrmqEsQMYMkhM9a63kHhO1MY6jX1cLAT3DDpvxTH7ygcnk25x9D+9ZD1y
 Q7ptxTi8/OjjyVm6M3jgdoQKT+li74cm1jJNOJSlBPg43VJNsXkUKhoeWcq5ClZpmaWO
 oY3A==
X-Gm-Message-State: ANoB5pmTno5othpXV1yyHTm0uRAZ4s7bGMK/cPPwt6OduUPZErcjc76C
 sIa2hNMoeyGkJ1oRdV0GfsuZoQ==
X-Google-Smtp-Source: AA0mqf6LGlNdkJlLDcwfP4oo7asFABbkB+ZP9oQrvqjFFePdLkCPII5mdqk5RqRXD5AGhShcjzDHXg==
X-Received: by 2002:a63:5a62:0:b0:476:ed2a:6215 with SMTP id
 k34-20020a635a62000000b00476ed2a6215mr34342882pgm.559.1669755648622; 
 Tue, 29 Nov 2022 13:00:48 -0800 (PST)
Received: from google.com (220.181.82.34.bc.googleusercontent.com.
 [34.82.181.220]) by smtp.gmail.com with ESMTPSA id
 f14-20020a170902ce8e00b0018957322953sm11407727plg.45.2022.11.29.13.00.48
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 29 Nov 2022 13:00:48 -0800 (PST)
Date: Tue, 29 Nov 2022 13:00:44 -0800
From: Ricardo Koller <ricarkol@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [PATCH 3/4] KVM: arm64: Handle access faults behind the read lock
Message-ID: <Y4Zy/MtIgeLyRGy9@google.com>
References: <20221129191946.1735662-1-oliver.upton@linux.dev>
 <20221129191946.1735662-4-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20221129191946.1735662-4-oliver.upton@linux.dev>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 kvmarm@lists.linux.dev, Will Deacon <will@kernel.org>,
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

On Tue, Nov 29, 2022 at 07:19:45PM +0000, Oliver Upton wrote:
> As the underlying software walkers are able to traverse and update
> stage-2 in parallel there is no need to serialize access faults.
> 
> Only take the read lock when handling an access fault.
> 
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>  arch/arm64/kvm/hyp/pgtable.c | 2 +-
>  arch/arm64/kvm/mmu.c         | 4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index 9626f615d9b8..1a3dd9774707 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -1097,7 +1097,7 @@ kvm_pte_t kvm_pgtable_stage2_mkyoung(struct kvm_pgtable *pgt, u64 addr)
>  	int ret;
>  
>  	ret = stage2_update_leaf_attrs(pgt, addr, 1, KVM_PTE_LEAF_ATTR_LO_S2_AF, 0,
> -				       &pte, NULL, 0);
> +				       &pte, NULL, KVM_PGTABLE_WALK_SHARED);
>  	if (!ret)
>  		dsb(ishst);
>  
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 886ad5ee767a..347985a56414 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1404,10 +1404,10 @@ static void handle_access_fault(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa)
>  
>  	trace_kvm_access_fault(fault_ipa);
>  
> -	write_lock(&vcpu->kvm->mmu_lock);
> +	read_lock(&vcpu->kvm->mmu_lock);
>  	mmu = vcpu->arch.hw_mmu;
>  	pte = kvm_pgtable_stage2_mkyoung(mmu->pgt, fault_ipa);
> -	write_unlock(&vcpu->kvm->mmu_lock);
> +	read_unlock(&vcpu->kvm->mmu_lock);
>  
>  	if (kvm_pte_valid(pte))
>  		kvm_set_pfn_accessed(kvm_pte_to_pfn(pte));
> -- 
> 2.38.1.584.g0f3c55d4c2-goog
> 
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

Reviewed-by: Ricardo Koller <ricarkol@google.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
