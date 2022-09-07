Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3D63C6FA82
	for <kvmarm@archiver.kernel.org>; Thu,  8 Sep 2022 08:34:33 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 37E0B4CC6C;
	Thu,  8 Sep 2022 04:34:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6liNOfP0-eUT; Thu,  8 Sep 2022 04:34:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C3E7E4CD20;
	Thu,  8 Sep 2022 04:34:30 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E40614CABA
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Sep 2022 17:47:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QkU0cuIAAD6K for <kvmarm@lists.cs.columbia.edu>;
 Wed,  7 Sep 2022 17:47:16 -0400 (EDT)
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com
 [209.85.216.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C6E504CA66
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Sep 2022 17:47:16 -0400 (EDT)
Received: by mail-pj1-f49.google.com with SMTP id o4so15816596pjp.4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 07 Sep 2022 14:47:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc:subject:date;
 bh=a0onBmXPphYT3RuqfDE1tfHpBM48udC3uDDfIPbNeqQ=;
 b=qz8qKS17YDB74dB3eVq/ImHb/1panXWt9MKNv77sjzlXj8cL3XwLCX/xz8ZQn9FJSc
 pkuvn/eM3SPKQUCBDgtCZu6rnvnlsgeB696oCeiPN8LzQIFq4odPuYBB/o7hizZaRcRP
 tH7JasNxHZyEVsUyfz0V/dL1r9OPMoCaBwGTkGjH1jd/RD5/uG56v/Pc1g6Dr4EGnH6r
 hr+0E5wBEw/x3ik8lSEvklHAQ6eORvUgxri4N5u/Sr7xvTrdNUpSsXg71MROLD6JhtYd
 nyD3JCmVLfqxQWXd75Tk6Z+u4KPOxj45s6/oI+dRFkvHvvGKtM9qmtSw3qCoO59EWNNk
 GKXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
 bh=a0onBmXPphYT3RuqfDE1tfHpBM48udC3uDDfIPbNeqQ=;
 b=ErNT371vRElO/OjYeE1L+2aUHRD4SXwpaRJ+dlhGKSFNlRImtO2UpzOATjMV5wh6mD
 Y5YRc+fN2syU0A4vAZRiGDTigHiMI9SppgNUY9X7yGbjLlv5MKMMqToOFhixJnQgiXqf
 QuRg+TCHf7Ut9gKIrxJnf3prslkQpE/HG6qWY+kEROJOI1n8YdjOiF4KNskaWesI1JHS
 crMNZWjT0y1FefO0lHLOitElcnG8mG1sDb2InElYS7h8PI8H9huSQn/MfpW2tE/aG8pZ
 LsjZCvTP8lNyhSn4hLVavxUKHoo7SIybBvei25KNpPJlsCay81EVEZzCo9iAo3cHHB9z
 uRxQ==
X-Gm-Message-State: ACgBeo03ybgZCSPfWOgGx/0mKUKxOpell1gAEZ001DkS6LtXgpO1/pn+
 o3pd28bng1/oE9To0iePkkdT0A==
X-Google-Smtp-Source: AA6agR7u55ulppnpFE92xnBEjpQea4OXXBFThe+B3Pt6YcvMkX+Mwtq2DlhDFlWJGj73EGApy3OVsw==
X-Received: by 2002:a17:902:6b4c:b0:171:38ab:e762 with SMTP id
 g12-20020a1709026b4c00b0017138abe762mr5635735plt.42.1662587235722; 
 Wed, 07 Sep 2022 14:47:15 -0700 (PDT)
Received: from google.com (223.103.125.34.bc.googleusercontent.com.
 [34.125.103.223]) by smtp.gmail.com with ESMTPSA id
 n6-20020a170902e54600b00173cfaed233sm659052plf.62.2022.09.07.14.47.13
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 07 Sep 2022 14:47:14 -0700 (PDT)
Date: Wed, 7 Sep 2022 14:47:08 -0700
From: David Matlack <dmatlack@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [PATCH 08/14] KVM: arm64: Protect page table traversal with RCU
Message-ID: <YxkRXLsLuhjBNanT@google.com>
References: <20220830194132.962932-1-oliver.upton@linux.dev>
 <20220830194132.962932-9-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220830194132.962932-9-oliver.upton@linux.dev>
X-Mailman-Approved-At: Thu, 08 Sep 2022 04:34:28 -0400
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Ben Gardon <bgardon@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

On Tue, Aug 30, 2022 at 07:41:26PM +0000, Oliver Upton wrote:
> The use of RCU is necessary to change the paging structures in parallel.
> Acquire and release an RCU read lock when traversing the page tables.
> 
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>  arch/arm64/include/asm/kvm_pgtable.h | 19 ++++++++++++++++++-
>  arch/arm64/kvm/hyp/pgtable.c         |  7 ++++++-
>  2 files changed, 24 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> index 78fbb7be1af6..7d2de0a98ccb 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -578,9 +578,26 @@ enum kvm_pgtable_prot kvm_pgtable_stage2_pte_prot(kvm_pte_t pte);
>   */
>  enum kvm_pgtable_prot kvm_pgtable_hyp_pte_prot(kvm_pte_t pte);
>  
> +#if defined(__KVM_NVHE_HYPERVISOR___)
> +

Future readers will wonder why NVHE stubs out RCU support and how that
is even correct. Some comments here would be useful explain it.

> +static inline void kvm_pgtable_walk_begin(void) {}
> +static inline void kvm_pgtable_walk_end(void) {}
> +
> +#define kvm_dereference_ptep rcu_dereference_raw

How does NVHE have access rcu_dereference_raw()?

> +
> +#else	/* !defined(__KVM_NVHE_HYPERVISOR__) */
> +
> +#define kvm_pgtable_walk_begin	rcu_read_lock
> +#define kvm_pgtable_walk_end	rcu_read_unlock
> +#define kvm_dereference_ptep	rcu_dereference
> +
> +#endif	/* defined(__KVM_NVHE_HYPERVISOR__) */
> +
>  static inline kvm_pte_t kvm_pte_read(kvm_pte_t *ptep)
>  {
> -	return READ_ONCE(*ptep);
> +	kvm_pte_t __rcu *p = (kvm_pte_t __rcu *)ptep;
> +
> +	return READ_ONCE(*kvm_dereference_ptep(p));

What about all the other places where page table memory is accessed?

If RCU is going to be used to protect page table memory, then all
accesses have to go under an RCU critical section. This means that page
table memory should only be accessed through __rcu annotated pointers
and dereferenced with rcu_dereference().

>  }
>  
>  #endif	/* __ARM64_KVM_PGTABLE_H__ */
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index f911509e6512..215a14c434ed 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -284,8 +284,13 @@ int kvm_pgtable_walk(struct kvm_pgtable *pgt, u64 addr, u64 size,
>  		.end	= PAGE_ALIGN(walk_data.addr + size),
>  		.walker	= walker,
>  	};
> +	int r;
>  
> -	return _kvm_pgtable_walk(&walk_data);
> +	kvm_pgtable_walk_begin();
> +	r = _kvm_pgtable_walk(&walk_data);
> +	kvm_pgtable_walk_end();
> +
> +	return r;
>  }
>  
>  struct leaf_walk_data {
> -- 
> 2.37.2.672.g94769d06f0-goog
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
