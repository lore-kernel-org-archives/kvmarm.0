Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3A47C433F5
	for <kvmarm@archiver.kernel.org>; Fri, 14 Jan 2022 13:49:22 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5C76549EAC;
	Fri, 14 Jan 2022 08:49:22 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9SRYL5Y5eAXe; Fri, 14 Jan 2022 08:49:20 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 20EEE49EC5;
	Fri, 14 Jan 2022 08:49:20 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D0AA649E5F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 14 Jan 2022 08:49:18 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id l1DlxxrntChU for <kvmarm@lists.cs.columbia.edu>;
 Fri, 14 Jan 2022 08:49:17 -0500 (EST)
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com
 [209.85.221.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7E5F049E34
 for <kvmarm@lists.cs.columbia.edu>; Fri, 14 Jan 2022 08:49:17 -0500 (EST)
Received: by mail-wr1-f42.google.com with SMTP id d19so15837208wrb.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 14 Jan 2022 05:49:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=SplDRCa6NNrw+jmw+XcUlhx9ZxjilxrjFesGl7lzU8g=;
 b=a8+JP378o1HAvFjmRAXUOS92EqYOCCF88AwdX0/glSzNwYInZgQODDEMtel8YNg43L
 yYJWvN218zskoZeANgcb1mJ8YkIikwhMIQ/j/c2EwwWlx1AyTftWuWJLK/q4DO2x9KhF
 SX2Q17/rj7UDxp1MxMU5n5EyscAbo+Y6gBeBFRUUqZnOhohMNv3u0xHpRXG88P5rCodV
 J6ZzYoj2CCEzrG1fanC9jK06RN3WeAj2R91MreRQDcoTPbOu0SdKk3oOkZyPWai0cSxg
 Run8+wVv5fEmM8o7zcChBaWTpUjMXF7lpEXzUR8WOjnviB7ezlfmvN16E2LaKXWslsnM
 g8PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=SplDRCa6NNrw+jmw+XcUlhx9ZxjilxrjFesGl7lzU8g=;
 b=qEPjvoXAj5aGqizF7gWeEwmU0k1/PBVEcW6k04wTZ7losd9jFsQV2Fl5LdXxESOccA
 VL+5GXjPIFiycFuIVPeuTYii+dlKSlAIoa9wqC2z0X9Oo7cfwfTGLja88FooliH5pWd7
 RAoXt+khypnOJx/rYmtHb5VmPg40FKV0z0l2sUBqAoNH73BfqKIGmzejzfrpwKCpXj+q
 RYZt5NsJruYO72caNIffBT5dbeEw3a0Ej4oMGKnBhGmAdhbdfDk2pyYPPlcTSh9lcKBz
 fc0J0zpLhVVxF2I5LVfUbwNmJlTG1PVJzoOUcQ3+Wec92/N2H8CSpcJZi8t/pqrYahzb
 FRJA==
X-Gm-Message-State: AOAM531T3ibVzj2sNx8eAzS3rg8YfDjnUV5hpWDd+efSaO46x9mqWIbl
 sMGG0c0Y/VBOciiBULZpmnqyjA==
X-Google-Smtp-Source: ABdhPJwoUoCO5g9qpmclfYXylg3VPdHOz196vgmYaxgcYpAG6lUSt03T/h3hujcZM8T0T16gsvO79w==
X-Received: by 2002:a05:6000:18a5:: with SMTP id
 b5mr8486696wri.24.1642168156403; 
 Fri, 14 Jan 2022 05:49:16 -0800 (PST)
Received: from google.com ([2a00:79e0:d:210:d47e:30f8:4fad:745b])
 by smtp.gmail.com with ESMTPSA id f15sm1858029wmq.38.2022.01.14.05.49.15
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 14 Jan 2022 05:49:15 -0800 (PST)
Date: Fri, 14 Jan 2022 13:49:12 +0000
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH] KVM: arm64: pkvm: Use the mm_ops indirection for cache
 maintenance
Message-ID: <YeF/WMXe4HL/n8qw@google.com>
References: <20220114125038.1336965-1-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220114125038.1336965-1-maz@kernel.org>
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
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

On Friday 14 Jan 2022 at 12:50:38 (+0000), Marc Zyngier wrote:
> CMOs issued from EL2 cannot directly use the kernel helpers,
> as EL2 doesn't have a mapping of the guest pages. Oops.
> 
> Instead, use the mm_ops indirection to use helpers that will
> perform a mapping at EL2 and allow the CMO to be effective.

Right, we were clearly lucky not to use those paths at EL2 _yet_, but
that's going to change soon and this is better for consistency, so:

Reviewed-by: Quentin Perret <qperret@google.com>

> Fixes: 25aa28691bb9 ("KVM: arm64: Move guest CMOs to the fault handlers")
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/hyp/pgtable.c | 18 ++++++------------
>  1 file changed, 6 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index 844a6f003fd5..2cb3867eb7c2 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -983,13 +983,9 @@ static int stage2_unmap_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
>  	 */
>  	stage2_put_pte(ptep, mmu, addr, level, mm_ops);
>  
> -	if (need_flush) {
> -		kvm_pte_t *pte_follow = kvm_pte_follow(pte, mm_ops);
> -
> -		dcache_clean_inval_poc((unsigned long)pte_follow,
> -				    (unsigned long)pte_follow +
> -					    kvm_granule_size(level));
> -	}
> +	if (need_flush && mm_ops->dcache_clean_inval_poc)
> +		mm_ops->dcache_clean_inval_poc(kvm_pte_follow(pte, mm_ops),
> +					       kvm_granule_size(level));
>  
>  	if (childp)
>  		mm_ops->put_page(childp);
> @@ -1151,15 +1147,13 @@ static int stage2_flush_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
>  	struct kvm_pgtable *pgt = arg;
>  	struct kvm_pgtable_mm_ops *mm_ops = pgt->mm_ops;
>  	kvm_pte_t pte = *ptep;
> -	kvm_pte_t *pte_follow;
>  
>  	if (!kvm_pte_valid(pte) || !stage2_pte_cacheable(pgt, pte))
>  		return 0;
>  
> -	pte_follow = kvm_pte_follow(pte, mm_ops);
> -	dcache_clean_inval_poc((unsigned long)pte_follow,
> -			    (unsigned long)pte_follow +
> -				    kvm_granule_size(level));
> +	if (mm_ops->dcache_clean_inval_poc)
> +		mm_ops->dcache_clean_inval_poc(kvm_pte_follow(pte, mm_ops),
> +					       kvm_granule_size(level));
>  	return 0;
>  }
>  
> -- 
> 2.30.2
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
