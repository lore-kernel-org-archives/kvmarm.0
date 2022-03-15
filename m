Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90F3FC433EF
	for <kvmarm@archiver.kernel.org>; Tue, 15 Mar 2022 08:51:08 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0801549F18;
	Tue, 15 Mar 2022 04:51:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id RpnHKh-HCGvH; Tue, 15 Mar 2022 04:51:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B954249F19;
	Tue, 15 Mar 2022 04:51:05 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D851849F19
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Mar 2022 04:51:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5AYFItTPgy72 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 15 Mar 2022 04:51:02 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 77E9F49F18
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Mar 2022 04:51:02 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1647334262;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=iJfPNwORsYGtURUoL7s3z0la28b4kkixiHIx/VOk9p4=;
 b=dNIltVhyoNUXcWyluhD3lPb5GAjbuJgDN1wCNN0jy0qfFi98zn3rLJLptXNwerKdocw0Re
 rkdzWqr9ZTV76mgTPkBMyymyDlP1XAE2QU7kcgLNFzUEyeKeDi6y5HBcUAYa589/XOSK35
 uYY+nZG5ArW9HrcNmDpEJy6gNj1FMtA=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-501-LsfhBLJnOH-wCh9n8c7mag-1; Tue, 15 Mar 2022 04:51:00 -0400
X-MC-Unique: LsfhBLJnOH-wCh9n8c7mag-1
Received: by mail-pl1-f198.google.com with SMTP id
 b4-20020a170902e94400b0015309b5c481so7375550pll.6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Mar 2022 01:50:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=iJfPNwORsYGtURUoL7s3z0la28b4kkixiHIx/VOk9p4=;
 b=tLXyHLMemEiQGNds/ERiqt+H9hBjTka/RkS/E/8Gn4NWEyFmLL1MrM/E05YgZsOpUT
 ze3yM3xlBd4K6OCJV3GhvtYzHNkhuLP5p3kjjMQffwP7FDgBj8WHSczq2EaZljmRcuqd
 kY3Qt+p1wzayyPFLk+kPEeXxVMC4MJK+4e55NKHEoCvr3U194i3TBTHbZUlJMy+bBuae
 I0VmcrEcVW2HPtpITKWOGx+9yP4xcpV9wLiwrGzf5TfpLeRSUCZH0Rv+mJJkJJByveQ1
 tpifxQbqAUfNTKRJgUtTopCqH9IH+IbpItDrCXtfd/piP49ijkj8OyV8H2sfzzK6sYgV
 98Ow==
X-Gm-Message-State: AOAM530MTZqJslhvBqCkPY1ALnna4IHwdz21Co7b1iHfl8OKp+FbgYMy
 /W4EXwcU1WlaXE8WGKqiysMdvO63B6znW2KX5QPsM7JpJjYb8BXEku2a5ttdZSRRtBUDMtenzsY
 /WdSQQ5iDc8Fa1GDFgp6ZJW6E
X-Received: by 2002:a17:903:3112:b0:151:a940:1574 with SMTP id
 w18-20020a170903311200b00151a9401574mr27501174plc.63.1647334258885; 
 Tue, 15 Mar 2022 01:50:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxHWj9bKrdm/9Y/tsKI6ZrYi5hSyGCM7zNyQtEZKMz/CbNWKzPkd9lMjLNsISJclLrmbrGh3w==
X-Received: by 2002:a17:903:3112:b0:151:a940:1574 with SMTP id
 w18-20020a170903311200b00151a9401574mr27501135plc.63.1647334258490; 
 Tue, 15 Mar 2022 01:50:58 -0700 (PDT)
Received: from xz-m1.local ([191.101.132.43]) by smtp.gmail.com with ESMTPSA id
 gb5-20020a17090b060500b001bd312f7396sm2197473pjb.45.2022.03.15.01.50.53
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 15 Mar 2022 01:50:58 -0700 (PDT)
Date: Tue, 15 Mar 2022 16:50:50 +0800
From: Peter Xu <peterx@redhat.com>
To: David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v2 04/26] KVM: x86/mmu: Decompose kvm_mmu_get_page() into
 separate functions
Message-ID: <YjBTal9gWoEKybxi@xz-m1.local>
References: <20220311002528.2230172-1-dmatlack@google.com>
 <20220311002528.2230172-5-dmatlack@google.com>
MIME-Version: 1.0
In-Reply-To: <20220311002528.2230172-5-dmatlack@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=peterx@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
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

On Fri, Mar 11, 2022 at 12:25:06AM +0000, David Matlack wrote:
> Decompose kvm_mmu_get_page() into separate helper functions to increase
> readability and prepare for allocating shadow pages without a vcpu
> pointer.
> 
> Specifically, pull the guts of kvm_mmu_get_page() into 3 helper
> functions:
> 
> __kvm_mmu_find_shadow_page() -
>   Walks the page hash checking for any existing mmu pages that match the
>   given gfn and role. Does not attempt to synchronize the page if it is
>   unsync.
> 
> kvm_mmu_find_shadow_page() -
>   Wraps __kvm_mmu_find_shadow_page() and handles syncing if necessary.
> 
> kvm_mmu_new_shadow_page()
>   Allocates and initializes an entirely new kvm_mmu_page. This currently
>   requries a vcpu pointer for allocation and looking up the memslot but
>   that will be removed in a future commit.
> 
>   Note, kvm_mmu_new_shadow_page() is temporary and will be removed in a
>   subsequent commit. The name uses "new" rather than the more typical
>   "alloc" to avoid clashing with the existing kvm_mmu_alloc_page().
> 
> No functional change intended.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>

Looks good to me, a few nitpicks and questions below.

> ---
>  arch/x86/kvm/mmu/mmu.c         | 132 ++++++++++++++++++++++++---------
>  arch/x86/kvm/mmu/paging_tmpl.h |   5 +-
>  arch/x86/kvm/mmu/spte.c        |   5 +-
>  3 files changed, 101 insertions(+), 41 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 23c2004c6435..80dbfe07c87b 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -2027,16 +2027,25 @@ static void clear_sp_write_flooding_count(u64 *spte)
>  	__clear_sp_write_flooding_count(sptep_to_sp(spte));
>  }
>  
> -static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu, gfn_t gfn,
> -					     union kvm_mmu_page_role role)
> +/*
> + * Searches for an existing SP for the given gfn and role. Makes no attempt to
> + * sync the SP if it is marked unsync.
> + *
> + * If creating an upper-level page table, zaps unsynced pages for the same
> + * gfn and adds them to the invalid_list. It's the callers responsibility
> + * to call kvm_mmu_commit_zap_page() on invalid_list.
> + */
> +static struct kvm_mmu_page *__kvm_mmu_find_shadow_page(struct kvm *kvm,
> +						       gfn_t gfn,
> +						       union kvm_mmu_page_role role,
> +						       struct list_head *invalid_list)
>  {
>  	struct hlist_head *sp_list;
>  	struct kvm_mmu_page *sp;
>  	int collisions = 0;
> -	LIST_HEAD(invalid_list);
>  
> -	sp_list = &vcpu->kvm->arch.mmu_page_hash[kvm_page_table_hashfn(gfn)];
> -	for_each_valid_sp(vcpu->kvm, sp, sp_list) {
> +	sp_list = &kvm->arch.mmu_page_hash[kvm_page_table_hashfn(gfn)];
> +	for_each_valid_sp(kvm, sp, sp_list) {
>  		if (sp->gfn != gfn) {
>  			collisions++;
>  			continue;
> @@ -2053,60 +2062,109 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu, gfn_t gfn,
>  			 * upper-level page will be write-protected.
>  			 */
>  			if (role.level > PG_LEVEL_4K && sp->unsync)
> -				kvm_mmu_prepare_zap_page(vcpu->kvm, sp,
> -							 &invalid_list);
> +				kvm_mmu_prepare_zap_page(kvm, sp, invalid_list);
> +
>  			continue;
>  		}
>  
> -		/* unsync and write-flooding only apply to indirect SPs. */
> -		if (sp->role.direct)
> -			goto trace_get_page;
> +		/* Write-flooding is only tracked for indirect SPs. */
> +		if (!sp->role.direct)
> +			__clear_sp_write_flooding_count(sp);
>  
> -		if (sp->unsync) {
> -			/*
> -			 * The page is good, but is stale.  kvm_sync_page does
> -			 * get the latest guest state, but (unlike mmu_unsync_children)
> -			 * it doesn't write-protect the page or mark it synchronized!
> -			 * This way the validity of the mapping is ensured, but the
> -			 * overhead of write protection is not incurred until the
> -			 * guest invalidates the TLB mapping.  This allows multiple
> -			 * SPs for a single gfn to be unsync.
> -			 *
> -			 * If the sync fails, the page is zapped.  If so, break
> -			 * in order to rebuild it.
> -			 */
> -			if (!kvm_sync_page(vcpu, sp, &invalid_list))
> -				break;
> +		goto out;
> +	}
>  
> -			WARN_ON(!list_empty(&invalid_list));
> -			kvm_flush_remote_tlbs(vcpu->kvm);
> -		}
> +	sp = NULL;
>  
> -		__clear_sp_write_flooding_count(sp);
> +out:
> +	if (collisions > kvm->stat.max_mmu_page_hash_collisions)
> +		kvm->stat.max_mmu_page_hash_collisions = collisions;
> +
> +	return sp;
> +}
>  
> -trace_get_page:
> -		trace_kvm_mmu_get_page(sp, false);
> +/*
> + * Looks up an existing SP for the given gfn and role if one exists. The
> + * return SP is guaranteed to be synced.
> + */
> +static struct kvm_mmu_page *kvm_mmu_find_shadow_page(struct kvm_vcpu *vcpu,
> +						     gfn_t gfn,
> +						     union kvm_mmu_page_role role)
> +{
> +	struct kvm_mmu_page *sp;
> +	LIST_HEAD(invalid_list);
> +
> +	sp = __kvm_mmu_find_shadow_page(vcpu->kvm, gfn, role, &invalid_list);
> +	if (!sp)
>  		goto out;
> +
> +	if (sp->unsync) {
> +		/*
> +		 * The page is good, but is stale.  kvm_sync_page does
> +		 * get the latest guest state, but (unlike mmu_unsync_children)
> +		 * it doesn't write-protect the page or mark it synchronized!
> +		 * This way the validity of the mapping is ensured, but the
> +		 * overhead of write protection is not incurred until the
> +		 * guest invalidates the TLB mapping.  This allows multiple
> +		 * SPs for a single gfn to be unsync.
> +		 *
> +		 * If the sync fails, the page is zapped and added to the
> +		 * invalid_list.
> +		 */
> +		if (!kvm_sync_page(vcpu, sp, &invalid_list)) {
> +			sp = NULL;
> +			goto out;
> +		}
> +
> +		WARN_ON(!list_empty(&invalid_list));

Not related to this patch because I think it's a pure movement here,
however I have a question on why invalid_list is guaranteed to be empty..

I'm thinking the case where when lookup the page we could have already
called kvm_mmu_prepare_zap_page() there, then when reach here (which is the
kvm_sync_page==true case) invalid_list shouldn't be touched in
kvm_sync_page(), so it looks possible that it still contains some page to
be commited?

> +		kvm_flush_remote_tlbs(vcpu->kvm);
>  	}
>  
> +out:

I'm wondering whether this "out" can be dropped.. with something like:

        sp = __kvm_mmu_find_shadow_page(...);

        if (sp && sp->unsync) {
                if (kvm_sync_page(vcpu, sp, &invalid_list)) {
                        ..
                } else {
                        sp = NULL;
                }
        }

[...]

> +static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu, gfn_t gfn,
> +					     union kvm_mmu_page_role role)
> +{
> +	struct kvm_mmu_page *sp;
> +	bool created = false;
> +
> +	sp = kvm_mmu_find_shadow_page(vcpu, gfn, role);
> +	if (sp)
> +		goto out;
> +
> +	created = true;
> +	sp = kvm_mmu_new_shadow_page(vcpu, gfn, role);
> +
> +out:
> +	trace_kvm_mmu_get_page(sp, created);
>  	return sp;

Same here, wondering whether we could drop the "out" by:

        sp = kvm_mmu_find_shadow_page(vcpu, gfn, role);
        if (!sp) {
                created = true;
                sp = kvm_mmu_new_shadow_page(vcpu, gfn, role);
        }

        trace_kvm_mmu_get_page(sp, created);
        return sp;

Thanks,

-- 
Peter Xu

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
