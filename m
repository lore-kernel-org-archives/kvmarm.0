Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C064C433EF
	for <kvmarm@archiver.kernel.org>; Thu,  5 May 2022 22:10:37 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C3E164B128;
	Thu,  5 May 2022 18:10:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id I-7osSnY-DOz; Thu,  5 May 2022 18:10:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 78B254B186;
	Thu,  5 May 2022 18:10:35 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C13BC4B186
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 May 2022 18:10:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZLKlLeRFOS-N for <kvmarm@lists.cs.columbia.edu>;
 Thu,  5 May 2022 18:10:33 -0400 (EDT)
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com
 [209.85.214.178])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 434B74B128
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 May 2022 18:10:33 -0400 (EDT)
Received: by mail-pl1-f178.google.com with SMTP id x18so5655275plg.6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 05 May 2022 15:10:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=4yANqmx2Ha2H5KKnZT4vayRpvNWYePsYuao7lny+AJM=;
 b=WbQtNTmD+Ll3JRwpNhBd4c/qZ7ZhI3rJDChU04IDGWARrptUSht8lO2pyXKueUKszR
 zxvkcbj4UNrrDCndk2TZ02kD+oFXEXd+YMm58AuZR/yxlohmpGUhM+5UKtK2plTMf4JP
 2ud5uPhWODIRQy52Jy606FlgPkZii5ykeoLbqhaIQhU7zzlfVD9xFz19uBldHEUWxpPJ
 Jr/VL/9fvFPsuu15nPzSXepo62Xn5V1fBuW2gof7fs1K332ekNk6WtgjH6NgWGkweqrS
 HXl6ELl8SE6ge/fgDMMwYR1lwCldudc4HKLmkJtBeEDLEtgkViKqaNWxT/SZqtIa5TZS
 aoww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=4yANqmx2Ha2H5KKnZT4vayRpvNWYePsYuao7lny+AJM=;
 b=giuZAMzGvXaSY4RK8IpG/K8k9TXOI/k+7gs+RllcmGnxDJud6dc6L213qnjpqYjZlz
 qFYQWE+TINbvQ4FyyxXYpR5U5zYaTZqZBxBDLzdv04Iwa6iOqf4vwgmMZn+zbr7EMaMb
 suKEYtK7BDlGCzEf1vfnFYzMsPqzCUFJTFWTbMF4/q1BXjdRDXb+iZ6K81HlJyjWZYDV
 9MITkhz6MO2GEvAiE7wPXp5hN9Q0qn9YB1EuKL4jqwygdVzt/j2osH6RfiwzaLRiomXe
 AehVRykJ+2KOqmEOJOdxHsog5iECzdL7cb+n6e9VesfY6HNxWbhv8T2712u6wGJkUD4a
 V9eQ==
X-Gm-Message-State: AOAM530EKdoktTbk1bCr9vc2fIEOo5gh+u5soE3QG3lQCb3NB7urAZLk
 2s9kDjAKsE/SgIu+AZ/sZo7dwQ==
X-Google-Smtp-Source: ABdhPJzheC8ozkQRQlg0u//bWzdNAJ7gKjw8V68pwITeoxj4Y3vaCAJqiTmLvoMgLTNgmx9kjJjymw==
X-Received: by 2002:a17:90b:4c8a:b0:1dc:6ff1:e2e1 with SMTP id
 my10-20020a17090b4c8a00b001dc6ff1e2e1mr436607pjb.217.1651788632009; 
 Thu, 05 May 2022 15:10:32 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157]) by smtp.gmail.com with ESMTPSA id
 b12-20020a170902d50c00b0015e8d4eb21csm124933plg.102.2022.05.05.15.10.31
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 05 May 2022 15:10:31 -0700 (PDT)
Date: Thu, 5 May 2022 22:10:28 +0000
From: Sean Christopherson <seanjc@google.com>
To: David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v4 05/20] KVM: x86/mmu: Consolidate shadow page
 allocation and initialization
Message-ID: <YnRLVB+t0bLBeu+/@google.com>
References: <20220422210546.458943-1-dmatlack@google.com>
 <20220422210546.458943-6-dmatlack@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220422210546.458943-6-dmatlack@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Albert Ou <aou@eecs.berkeley.edu>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <kvm@vger.kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <linux-mips@vger.kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Palmer Dabbelt <palmer@dabbelt.com>,
 "open list:KERNEL VIRTUAL MACHINE FOR RISC-V \(KVM/riscv\)"
 <kvm-riscv@lists.infradead.org>, Paul Walmsley <paul.walmsley@sifive.com>,
 Ben Gardon <bgardon@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 maciej.szmigiero@oracle.com,
 "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 \(KVM/arm64\)"
 <kvmarm@lists.cs.columbia.edu>, Peter Feiner <pfeiner@google.com>
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

On Fri, Apr 22, 2022, David Matlack wrote:
> Consolidate kvm_mmu_alloc_page() and kvm_mmu_alloc_shadow_page() under
> the latter so that all shadow page allocation and initialization happens
> in one place.
> 
> No functional change intended.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 39 +++++++++++++++++----------------------
>  1 file changed, 17 insertions(+), 22 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 5582badf4947..7d03320f6e08 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -1703,27 +1703,6 @@ static void drop_parent_pte(struct kvm_mmu_page *sp,
>  	mmu_spte_clear_no_track(parent_pte);
>  }
>  
> -static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu, bool direct)
> -{
> -	struct kvm_mmu_page *sp;
> -
> -	sp = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_page_header_cache);
> -	sp->spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_shadow_page_cache);
> -	if (!direct)
> -		sp->gfns = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_gfn_array_cache);
> -	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
> -
> -	/*
> -	 * active_mmu_pages must be a FIFO list, as kvm_zap_obsolete_pages()
> -	 * depends on valid pages being added to the head of the list.  See
> -	 * comments in kvm_zap_obsolete_pages().
> -	 */
> -	sp->mmu_valid_gen = vcpu->kvm->arch.mmu_valid_gen;
> -	list_add(&sp->link, &vcpu->kvm->arch.active_mmu_pages);
> -	kvm_mod_used_mmu_pages(vcpu->kvm, +1);
> -	return sp;
> -}
> -
>  static void mark_unsync(u64 *spte);
>  static void kvm_mmu_mark_parents_unsync(struct kvm_mmu_page *sp)
>  {
> @@ -2100,7 +2079,23 @@ static struct kvm_mmu_page *kvm_mmu_alloc_shadow_page(struct kvm_vcpu *vcpu,
>  						      struct hlist_head *sp_list,
>  						      union kvm_mmu_page_role role)
>  {
> -	struct kvm_mmu_page *sp = kvm_mmu_alloc_page(vcpu, role.direct);
> +	struct kvm_mmu_page *sp;
> +
> +	sp = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_page_header_cache);
> +	sp->spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_shadow_page_cache);
> +	if (!role.direct)
> +		sp->gfns = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_gfn_array_cache);
> +
> +	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
> +
> +	/*
> +	 * active_mmu_pages must be a FIFO list, as kvm_zap_obsolete_pages()
> +	 * depends on valid pages being added to the head of the list.  See
> +	 * comments in kvm_zap_obsolete_pages().
> +	 */
> +	sp->mmu_valid_gen = vcpu->kvm->arch.mmu_valid_gen;
> +	list_add(&sp->link, &vcpu->kvm->arch.active_mmu_pages);
> +	kvm_mod_used_mmu_pages(vcpu->kvm, +1);

To reduce churn later on, what about opportunistically grabbing vcpu->kvm in a
local variable in this patch?

Actually, at that point, it's a super trivial change, so you can probably just drop 

	KVM: x86/mmu: Replace vcpu with kvm in kvm_mmu_alloc_shadow_page()

and do the vcpu/kvm swap as part of

	KVM: x86/mmu: Pass memory caches to allocate SPs separately

>  	sp->gfn = gfn;
>  	sp->role = role;
> -- 
> 2.36.0.rc2.479.g8af0fa9b8e-goog
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
