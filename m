Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80186C4332F
	for <kvmarm@archiver.kernel.org>; Mon, 12 Dec 2022 23:15:31 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F04664B95A;
	Mon, 12 Dec 2022 18:15:30 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id s7VA0yH1267s; Mon, 12 Dec 2022 18:15:29 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AA9224B8C5;
	Mon, 12 Dec 2022 18:15:29 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 407E94B828
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 18:15:28 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oBf3Z6buv+u9 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 12 Dec 2022 18:15:26 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DC5B94B6C8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 18:15:26 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1670886926;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=y59dQxuBZvH2dJ+QaunSC7VWD6qA2LCOofme/uP6yrs=;
 b=cKPz7PQQEdk294SkAM5FWQCNFoqN+k/Wh7PLCnojrbMpkWbAquRKzMJxNVT43Gvk0bZy2Q
 wYbDzwTYO4nQ1iZhPWRC6VksqVhQu15hueOziy+jY8HwaHxfpePI+gZcLgUi/CAdKVwuax
 L6elkoY8y/+NNack4iPXSK2uWJxQpB8=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-224-34mzYVd1P0utvhw0HSD5yw-1; Mon, 12 Dec 2022 18:15:25 -0500
X-MC-Unique: 34mzYVd1P0utvhw0HSD5yw-1
Received: by mail-wr1-f69.google.com with SMTP id
 r6-20020adfbb06000000b002455227c5c5so2569614wrg.20
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 15:15:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=y59dQxuBZvH2dJ+QaunSC7VWD6qA2LCOofme/uP6yrs=;
 b=l/mg9GK1aiKWrtVBbnll8FgADGojhh1UMea5zfjKhtys7v5nLV/6WA0zU9TKq7iYQv
 hm5OQf+vdb5iDIya+KnLPXvwaTm5hPGQGf3r6iRUxiivfjZjCBmNA9MJhumajJigaZ2u
 rBeW3QYo49bxG5fs5HACDuAMllnhvYXesJTgb5tM/UqdJ+lmcY8AWsqdKgBZoVs7CbV4
 lTNqKzD5zT6r667AWQ7qqTyNSHpURArYPgrZ3/nNveppO6gcN32quCP3UhbJpWzM9eKW
 CCbgP+2Rz34TgEBtXziuqfvZLsx+LH3lXMKp0hgVuC/G1FGwWqL/z+jH+8g04nDPDK2U
 oENQ==
X-Gm-Message-State: ANoB5plrlYVpImgqWynRYRz+YMSASGONulnKLPUYJTBiIsyetsvs2SmH
 xjkXZMwgqDBt64UR6yTP/i3jHpiB5fbZVQ5b6BulwpNM+JZ0pMREKn0Po3+mFpQs5xHhZ+78qUE
 XAlHBYC0qXxepm/zrz4oL9h2/
X-Received: by 2002:a05:600c:4f05:b0:3cf:674a:aefe with SMTP id
 l5-20020a05600c4f0500b003cf674aaefemr14677244wmq.22.1670886924318; 
 Mon, 12 Dec 2022 15:15:24 -0800 (PST)
X-Google-Smtp-Source: AA0mqf69Du0IJa2CIROeqUOCPZXYcdHcFYucdO6uTVaYAPa30ljZoIeQ8u4jZT85a4ufCPYPRVLQBg==
X-Received: by 2002:a05:600c:4f05:b0:3cf:674a:aefe with SMTP id
 l5-20020a05600c4f0500b003cf674aaefemr14677202wmq.22.1670886924043; 
 Mon, 12 Dec 2022 15:15:24 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89?
 ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
 by smtp.googlemail.com with ESMTPSA id
 a12-20020a05600c348c00b003d070e45574sm10730652wmq.11.2022.12.12.15.15.22
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 12 Dec 2022 15:15:23 -0800 (PST)
Message-ID: <b0e8eb55-c2ee-ce13-8806-9d0184678984@redhat.com>
Date: Tue, 13 Dec 2022 00:15:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [RFC PATCH 04/37] KVM: x86/mmu: Invert sp->tdp_mmu_page to
 sp->shadow_mmu_page
To: David Matlack <dmatlack@google.com>
References: <20221208193857.4090582-1-dmatlack@google.com>
 <20221208193857.4090582-5-dmatlack@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20221208193857.4090582-5-dmatlack@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
 Hugh Dickins <hughd@google.com>, Paul Walmsley <paul.walmsley@sifive.com>,
 Nadav Amit <namit@vmware.com>, Colin Cross <ccross@google.com>,
 Ben Gardon <bgardon@google.com>, linux-riscv@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, Yu Zhao <yuzhao@google.com>,
 xu xin <cgel.zte@gmail.com>, Huacai Chen <chenhuacai@kernel.org>,
 "Matthew Wilcox \(Oracle\)" <willy@infradead.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Krish Sadhukhan <krish.sadhukhan@oracle.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Mingwei Zhang <mizhang@google.com>,
 Albert Ou <aou@eecs.berkeley.edu>, Arnd Bergmann <arnd@arndb.de>,
 "Liam R. Howlett" <Liam.Howlett@Oracle.com>, kvm@vger.kernel.org,
 Atish Patra <atishp@atishpatra.org>, kvmarm@lists.linux.dev,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>,
 linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org,
 kvm-riscv@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

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

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
