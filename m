Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37900C433EF
	for <kvmarm@archiver.kernel.org>; Thu, 23 Jun 2022 23:54:10 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7E78B49F0C;
	Thu, 23 Jun 2022 19:54:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xrjUPqZdXvBC; Thu, 23 Jun 2022 19:54:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3F47149F19;
	Thu, 23 Jun 2022 19:54:08 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 76BF349F19
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Jun 2022 19:54:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3q8TIB-knEXm for <kvmarm@lists.cs.columbia.edu>;
 Thu, 23 Jun 2022 19:54:05 -0400 (EDT)
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com
 [209.85.214.182])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 57DF541175
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Jun 2022 19:54:05 -0400 (EDT)
Received: by mail-pl1-f182.google.com with SMTP id l6so595791plg.11
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Jun 2022 16:54:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=wd94p2+WqQP2Ii1WcqvC1IXTIcgtiGxYezXGFIQe4aw=;
 b=KRbCcVbxTFuDlazWUaKQUOPh9qGmRm7JwBluWdtIN5lgQADy/y7Up21hjyeZeQys9Z
 NMqMid/gRBBHHYlCK7KIkeKD3DLErorhP5V+TeYnyI1mbE93G5ic0rsWpsJWV1C+42LU
 PrYQmevMfKBsIGm95i+gNd0xYzQmBNyHGbpvH3LVLLxC5rB1V6KN19Cl9M0sp5s2w9l6
 WLbDnhaJ7u2YbmxJX0UAAtHMm5VyarVBixum6aehiJ5wufCuioLQdpujYZHlxrQGAQod
 hl/cO0Ueg3xaFoThE8ukKSg2RezOKgvSQvZsrkDGOCohZDFk9SBliO8ffRLHYo8T0d61
 lPwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=wd94p2+WqQP2Ii1WcqvC1IXTIcgtiGxYezXGFIQe4aw=;
 b=IrAZ2S3uqPxRM6KGjELkq3xHqpSB7ree6BJwoQU+NP9sfrGiPbGTLjPiBifzxTcZj7
 OuxiOgguuJG5Q6XgrFSW/4ehR52nB/mllg1LRBgqL1PSdDSn1a7iG+9Z79SCeYYZ83WB
 fGYe6tg7+6MkddI0JVopLVAzjFMdhzERCmQhzATfh5LavS8UYaZrS5NWqD/MatQOgSfE
 2JYJ+A6rl1xvzrs0YgthNOE/9G0V/zKbDQXQaTl+w/6HXGpTEB4/4jYU3wuTS+VHprkJ
 tWyd6V6rVotAblLNkvCgF3+rseEDf+Z9YK22k9kgadx53AuAPoeOZvj9Y+wbOOeq44+e
 V3Lg==
X-Gm-Message-State: AJIora/cFckkKW3OnIfKjzoAr5FQwOkpDiLrq1wSC8ykquOdGQXFgIZH
 9r+SiL6UOF2cE7I44m/t6/kEKQ==
X-Google-Smtp-Source: AGRyM1siQHqmIeCYJDWhvQWr1e0zNrxAB/HYSnquYY9LulXlxpDsnuWHIYP6tBFrXyXqdMpDCmOmEg==
X-Received: by 2002:a17:902:dac5:b0:164:13b2:4916 with SMTP id
 q5-20020a170902dac500b0016413b24916mr41737113plx.32.1656028444167; 
 Thu, 23 Jun 2022 16:54:04 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com.
 [35.230.65.123]) by smtp.gmail.com with ESMTPSA id
 bf27-20020a056a000d9b00b0051bd9981ccbsm220385pfb.39.2022.06.23.16.54.03
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 23 Jun 2022 16:54:03 -0700 (PDT)
Date: Thu, 23 Jun 2022 23:53:59 +0000
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v7 19/23] KVM: x86/mmu: Zap collapsible SPTEs in shadow
 MMU at all possible levels
Message-ID: <YrT9F6S/PjYVk6Hr@google.com>
References: <20220622192710.2547152-1-pbonzini@redhat.com>
 <20220622192710.2547152-20-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220622192710.2547152-20-pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, maz@kernel.org, jiangshanlai@gmail.com,
 linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org,
 kvm-riscv@lists.infradead.org, bgardon@google.com, dmatlack@google.com,
 maciej.szmigiero@oracle.com, kvmarm@lists.cs.columbia.edu, pfeiner@google.com
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

On Wed, Jun 22, 2022, Paolo Bonzini wrote:
> From: David Matlack <dmatlack@google.com>
> 
> Currently KVM only zaps collapsible 4KiB SPTEs in the shadow MMU. This
> is fine for now since KVM never creates intermediate huge pages during
> dirty logging. In other words, KVM always replaces 1GiB pages directly
> with 4KiB pages, so there is no reason to look for collapsible 2MiB
> pages.
> 
> However, this will stop being true once the shadow MMU participates in
> eager page splitting. During eager page splitting, each 1GiB is first
> split into 2MiB pages and then those are split into 4KiB pages. The
> intermediate 2MiB pages may be left behind if an error condition causes
> eager page splitting to bail early.
> 
> No functional change intended.
> 
> Reviewed-by: Peter Xu <peterx@redhat.com>
> Signed-off-by: David Matlack <dmatlack@google.com>
> Message-Id: <20220516232138.1783324-20-dmatlack@google.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 21 ++++++++++++++-------
>  1 file changed, 14 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 13a059ad5dc7..36bc49f08d60 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -6154,18 +6154,25 @@ static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
>  	return need_tlb_flush;
>  }
>  
> +static void kvm_rmap_zap_collapsible_sptes(struct kvm *kvm,
> +					   const struct kvm_memory_slot *slot)
> +{
> +	/*
> +	 * Note, use KVM_MAX_HUGEPAGE_LEVEL - 1 since there's no need to zap
> +	 * pages that are already mapped at the maximum possible level.
> +	 */
> +	if (slot_handle_level(kvm, slot, kvm_mmu_zap_collapsible_spte,
> +			      PG_LEVEL_4K, KVM_MAX_HUGEPAGE_LEVEL - 1,
> +			      true))

Can you fix this up to put "true" on the previous line?

And if you do that, maybe also tweak the comment to reference "hugepage level"
instead of "possible level"?

---
 arch/x86/kvm/mmu/mmu.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 8825716060e4..34b0e85b26a4 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6450,12 +6450,11 @@ static void kvm_rmap_zap_collapsible_sptes(struct kvm *kvm,
 					   const struct kvm_memory_slot *slot)
 {
 	/*
-	 * Note, use KVM_MAX_HUGEPAGE_LEVEL - 1 since there's no need to zap
-	 * pages that are already mapped at the maximum possible level.
+	 * Note, use KVM_MAX_HUGEPAGE_LEVEL - 1, there's no need to zap pages
+	 * that are already mapped at the maximum hugepage level.
 	 */
 	if (slot_handle_level(kvm, slot, kvm_mmu_zap_collapsible_spte,
-			      PG_LEVEL_4K, KVM_MAX_HUGEPAGE_LEVEL - 1,
-			      true))
+			      PG_LEVEL_4K, KVM_MAX_HUGEPAGE_LEVEL - 1, true))
 		kvm_arch_flush_remote_tlbs_memslot(kvm, slot);
 }


base-commit: fd43332c2900db8ca852676f37f0ab423d0c369a
--

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
