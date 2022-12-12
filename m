Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8E427475
	for <kvmarm@lists.linux.dev>; Mon, 12 Dec 2022 23:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1670886928;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=y59dQxuBZvH2dJ+QaunSC7VWD6qA2LCOofme/uP6yrs=;
	b=dG/1mNKss2ZquQbzI4sez2xc3gZtyqbuesut0z/jZkntO3zYOFSTRP/o5W37qqQ7GNWNpi
	oyL3ZV+bYRwIjag+GMGGvkbuza1HE5mRV+TyOPwsgko03qE/eowsCxhbaL1uo43y7Pnv/S
	GOYy/vi6IZrqlfMFiMvf4t5MHOnYLIs=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-459-jk-280IgPNSld1j6yuv-iA-1; Mon, 12 Dec 2022 18:15:25 -0500
X-MC-Unique: jk-280IgPNSld1j6yuv-iA-1
Received: by mail-wm1-f69.google.com with SMTP id b47-20020a05600c4aaf00b003d031aeb1b6so4765121wmp.9
        for <kvmarm@lists.linux.dev>; Mon, 12 Dec 2022 15:15:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=y59dQxuBZvH2dJ+QaunSC7VWD6qA2LCOofme/uP6yrs=;
        b=rYzd6hrh5BcAJYOgcc3Q/VVMhgw0EaKXaLYXG7mGQ4OeouDWG8kwvSJLtS3sU4CkOY
         qy2QPrQDdtG8eJ38JRoMuv5kSeEjECIvyo9s8JZeO9L4tcBkzlnWE8I+i8e0rCXFFD1P
         59ja3/A175hSqmfUbRnL++agNFtm6C0dlujCC3ARjN29XbQoCDE9Vqa0J1itqMRgNNch
         qZ5RqaVTISlNKRHr7ftbqJpPNqj92IoG3Z+Y5VNOHQRI/gHas1rjJytAuc5FHX+XwE8s
         N5rsh5xWDChrsLPDBAJHY3jtXHZ1zavp65mpx8lbeYLRaMXy3TAsSPAmQIDVnq3u+GuN
         /w+A==
X-Gm-Message-State: ANoB5pmoA6hQx0XVa/i81zO3psRENcAyiUEfZfcZdOQwe67z8sDSBRQO
	iFHTouaYd77d4v3hAXNGqsWV+qfO1Gw/gW7HzCCDEdP93DwkfHr7CwTnkonx+tvcJg5ZvE70Ndi
	0htEzEnA/R9MR+HtI
X-Received: by 2002:a05:600c:4f05:b0:3cf:674a:aefe with SMTP id l5-20020a05600c4f0500b003cf674aaefemr14677240wmq.22.1670886924316;
        Mon, 12 Dec 2022 15:15:24 -0800 (PST)
X-Google-Smtp-Source: AA0mqf69Du0IJa2CIROeqUOCPZXYcdHcFYucdO6uTVaYAPa30ljZoIeQ8u4jZT85a4ufCPYPRVLQBg==
X-Received: by 2002:a05:600c:4f05:b0:3cf:674a:aefe with SMTP id l5-20020a05600c4f0500b003cf674aaefemr14677202wmq.22.1670886924043;
        Mon, 12 Dec 2022 15:15:24 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id a12-20020a05600c348c00b003d070e45574sm10730652wmq.11.2022.12.12.15.15.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Dec 2022 15:15:23 -0800 (PST)
Message-ID: <b0e8eb55-c2ee-ce13-8806-9d0184678984@redhat.com>
Date: Tue, 13 Dec 2022 00:15:21 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [RFC PATCH 04/37] KVM: x86/mmu: Invert sp->tdp_mmu_page to
 sp->shadow_mmu_page
To: David Matlack <dmatlack@google.com>
Cc: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Huacai Chen <chenhuacai@kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>,
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Sean Christopherson <seanjc@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Anshuman Khandual <anshuman.khandual@arm.com>, Nadav Amit
 <namit@vmware.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Vlastimil Babka <vbabka@suse.cz>, "Liam R. Howlett"
 <Liam.Howlett@Oracle.com>, Suren Baghdasaryan <surenb@google.com>,
 Peter Xu <peterx@redhat.com>, xu xin <cgel.zte@gmail.com>,
 Arnd Bergmann <arnd@arndb.de>, Yu Zhao <yuzhao@google.com>,
 Colin Cross <ccross@google.com>, Hugh Dickins <hughd@google.com>,
 Ben Gardon <bgardon@google.com>, Mingwei Zhang <mizhang@google.com>,
 Krish Sadhukhan <krish.sadhukhan@oracle.com>,
 Ricardo Koller <ricarkol@google.com>, Jing Zhang <jingzhangos@google.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org,
 kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
 linux-riscv@lists.infradead.org
References: <20221208193857.4090582-1-dmatlack@google.com>
 <20221208193857.4090582-5-dmatlack@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20221208193857.4090582-5-dmatlack@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Message-ID: <20221212231521.VW2Dn5hR0e_JJBPb1W0fVtXO9scwSB0omvYnTdKlRLI@z>

On 12/8/22 20:38, David Matlack wrote:
> Invert the meaning of sp->tdp_mmu_page and rename it accordingly. This
> allows the TDP MMU code to not care about this field, which will be used
> in a subsequent commit to move the TDP MMU to common code.
> 
> No functional change intended.

Let's use a bit of the role instead.

Paolo

> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>   arch/x86/kvm/mmu/mmu.c          | 1 +
>   arch/x86/kvm/mmu/mmu_internal.h | 2 +-
>   arch/x86/kvm/mmu/tdp_mmu.c      | 3 ---
>   arch/x86/kvm/mmu/tdp_mmu.h      | 5 ++++-
>   4 files changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 355548603960..f7668a32721d 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -2180,6 +2180,7 @@ static struct kvm_mmu_page *kvm_mmu_alloc_shadow_page(struct kvm *kvm,
>   
>   	sp->gfn = gfn;
>   	sp->role = role;
> +	sp->shadow_mmu_page = true;
>   	hlist_add_head(&sp->hash_link, sp_list);
>   	if (sp_has_gptes(sp))
>   		account_shadowed(kvm, sp);
> diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> index e32379c5b1ad..c1a379fba24d 100644
> --- a/arch/x86/kvm/mmu/mmu_internal.h
> +++ b/arch/x86/kvm/mmu/mmu_internal.h
> @@ -52,7 +52,7 @@ struct kvm_mmu_page {
>   	struct list_head link;
>   	struct hlist_node hash_link;
>   
> -	bool tdp_mmu_page;
> +	bool shadow_mmu_page;
>   	bool unsync;
>   	u8 mmu_valid_gen;
>   
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 7ccac1aa8df6..fc0b87ceb1ea 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -133,8 +133,6 @@ void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root,
>   	if (!refcount_dec_and_test(&root->tdp_mmu_root_count))
>   		return;
>   
> -	WARN_ON(!is_tdp_mmu_page(root));
> -
>   	/*
>   	 * The root now has refcount=0.  It is valid, but readers already
>   	 * cannot acquire a reference to it because kvm_tdp_mmu_get_root()
> @@ -279,7 +277,6 @@ static void tdp_mmu_init_sp(struct kvm_mmu_page *sp, tdp_ptep_t sptep,
>   	sp->role = role;
>   	sp->gfn = gfn;
>   	sp->ptep = sptep;
> -	sp->tdp_mmu_page = true;
>   
>   	trace_kvm_mmu_get_page(sp, true);
>   }
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
> index 0a63b1afabd3..18d3719f14ea 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.h
> +++ b/arch/x86/kvm/mmu/tdp_mmu.h
> @@ -71,7 +71,10 @@ u64 *kvm_tdp_mmu_fast_pf_get_last_sptep(struct kvm_vcpu *vcpu, u64 addr,
>   					u64 *spte);
>   
>   #ifdef CONFIG_X86_64
> -static inline bool is_tdp_mmu_page(struct kvm_mmu_page *sp) { return sp->tdp_mmu_page; }
> +static inline bool is_tdp_mmu_page(struct kvm_mmu_page *sp)
> +{
> +	return !sp->shadow_mmu_page;
> +}
>   #else
>   static inline bool is_tdp_mmu_page(struct kvm_mmu_page *sp) { return false; }
>   #endif

