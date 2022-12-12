Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED27CC4167B
	for <kvmarm@archiver.kernel.org>; Mon, 12 Dec 2022 19:32:20 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5F5C04B968;
	Mon, 12 Dec 2022 14:32:20 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XaBAY2KbJI6H; Mon, 12 Dec 2022 14:32:19 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1ED364B965;
	Mon, 12 Dec 2022 14:32:19 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E433D4B93F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 14:32:17 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8TBpfiuwz3bK for <kvmarm@lists.cs.columbia.edu>;
 Mon, 12 Dec 2022 14:32:16 -0500 (EST)
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com
 [209.85.222.176])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A598D4B917
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 14:32:16 -0500 (EST)
Received: by mail-qk1-f176.google.com with SMTP id m5so5609509qkg.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 11:32:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:from:to:cc:subject:date:message-id:reply-to;
 bh=8Mowh6IPNmR3LfyP4Dfupt4EtlOdkli9ymGjaw17vXI=;
 b=rm4I+wZFg2eJb2x8Va4Maw+iWq9AhwTPFcd5+4c65xHXN6A5VLXkr9Pzd+ERVn8WhT
 rXhKRHb0OCZ+Y251Cv06Op2FK6vM2ZvEcORuna52lFhL+6E0foSYaY0b0PInsi9lsPV8
 Bgem1uzt3AsOakc9GqY8CaGWz+mrz3XBlCJqtwog7YunyQdMthSrwnUiksKZYyXlRAE0
 U9EOqeHbYuzJisNspTwwqAApwqaC+6zidytdTp+shU4lKB0hfKRno0XiysILsLDo8L/z
 g3pQYrNCjufpK6hqXNdALJyiGfuRRPgueVHAc2pb1HOTaCnJmd2+UOOHx+8cakJYk0rR
 nBYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=8Mowh6IPNmR3LfyP4Dfupt4EtlOdkli9ymGjaw17vXI=;
 b=hspYVE3VFTgTINZcxZv1YLOmQBWosgINjQazt+0YtzwiKCAQoKBijXXMv7Y0FIlDej
 0Wc8JqkWq58cxYl/hRSwi0eUuMRXzrSUyYWQlNjQvMxkAUAAVenheWHsuOjxFhweZ5KE
 aLfX048RBVTsTMRh0gZ15p4URjpuAuyU5JwvHpOGDXnDNs5oyrAG3gyQ9rX/uer8yItE
 SMiuRO2i2SDqobpPqIyZsGenYhso9HhdOLF+JPgB6La1jNuSClpnYGzMJmN+1G1I4H4Q
 5/voWHfbPts3XqLdggUJRZtojbK+0hyops8b6gVnVTPFzAH+IIfCcfMVMb2cwRVukiwK
 Pfsg==
X-Gm-Message-State: ANoB5pnRpzhsQfXBfOUJD3J48jO/3ljcd3qPtuUk6H/O56T2ORKY2DcJ
 Ge7sYRHQtlYnR+0bVryMXxASklYW30y8bSVNrkqVLw==
X-Google-Smtp-Source: AA0mqf76PYiP6JK2x7WnSIvO5AyXyfgzfQ+XX+DgyhybSiTFwMNyTSUY4u6lHGW51+1mrY7J65iPpmVnUeYRL2TUxNA=
X-Received: by 2002:a05:620a:4394:b0:6ff:680:f3c with SMTP id
 a20-20020a05620a439400b006ff06800f3cmr1474664qkp.670.1670873535923; Mon, 12
 Dec 2022 11:32:15 -0800 (PST)
MIME-Version: 1.0
References: <20221208193857.4090582-1-dmatlack@google.com>
 <20221208193857.4090582-21-dmatlack@google.com>
In-Reply-To: <20221208193857.4090582-21-dmatlack@google.com>
From: Ben Gardon <bgardon@google.com>
Date: Mon, 12 Dec 2022 11:32:05 -0800
Message-ID: <CANgfPd-6LNdZ42tb0DnC21r1Z5JGR_1Lvvop8RKJJ8hEz+PUDg@mail.gmail.com>
Subject: Re: [RFC PATCH 20/37] KVM: x86/mmu: Abstract away computing the max
 mapping level
To: David Matlack <dmatlack@google.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
 Hugh Dickins <hughd@google.com>, Paul Walmsley <paul.walmsley@sifive.com>,
 Nadav Amit <namit@vmware.com>, Colin Cross <ccross@google.com>,
 linux-riscv@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 Yu Zhao <yuzhao@google.com>, Marc Zyngier <maz@kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 "Matthew Wilcox \(Oracle\)" <willy@infradead.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Krish Sadhukhan <krish.sadhukhan@oracle.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Mingwei Zhang <mizhang@google.com>,
 Albert Ou <aou@eecs.berkeley.edu>, xu xin <cgel.zte@gmail.com>,
 Arnd Bergmann <arnd@arndb.de>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 kvm@vger.kernel.org, Atish Patra <atishp@atishpatra.org>,
 kvmarm@lists.linux.dev, Suren Baghdasaryan <surenb@google.com>,
 Vlastimil Babka <vbabka@suse.cz>, linux-arm-kernel@lists.infradead.org,
 linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org,
 Paolo Bonzini <pbonzini@redhat.com>, Andrew Morton <akpm@linux-foundation.org>
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

On Thu, Dec 8, 2022 at 11:39 AM David Matlack <dmatlack@google.com> wrote:
>
> Abstract away kvm_mmu_max_mapping_level(), which is an x86-specific
> function for computing the max level that a given GFN can be mapped in
> KVM's page tables. This will be used in a future commit to enable moving
> the TDP MMU to common code.
>
> Provide a default implementation for non-x86 architectures that just
> returns the max level. This will result in more zapping than necessary
> when disabling dirty logging (i.e. less than optimal performance) but no
> correctness issues.

Apologies if you already implemented it in a later patch in this
series, but would it not at least be possible to port
host_pfn_mapping_level to common code and check that?
I'm assuming, though I could be wrong, that all archs map GFNs with at
most a host page table granularity mapping.
I suppose that doesn't strictly need to be included in this series,
but it would be worth addressing in the commit description.

>
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  arch/x86/kvm/mmu/tdp_mmu.c     | 14 ++++++++++----
>  arch/x86/kvm/mmu/tdp_pgtable.c |  7 +++++++
>  2 files changed, 17 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 7670fbd8e72d..24d1dbd0a1ec 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1696,6 +1696,13 @@ void kvm_tdp_mmu_clear_dirty_pt_masked(struct kvm *kvm,
>                 clear_dirty_pt_masked(kvm, root, gfn, mask, wrprot);
>  }
>
> +__weak int tdp_mmu_max_mapping_level(struct kvm *kvm,
> +                                    const struct kvm_memory_slot *slot,
> +                                    struct tdp_iter *iter)
> +{
> +       return TDP_MAX_HUGEPAGE_LEVEL;
> +}
> +
>  static void zap_collapsible_spte_range(struct kvm *kvm,
>                                        struct kvm_mmu_page *root,
>                                        const struct kvm_memory_slot *slot)
> @@ -1727,15 +1734,14 @@ static void zap_collapsible_spte_range(struct kvm *kvm,
>                 /*
>                  * If iter.gfn resides outside of the slot, i.e. the page for
>                  * the current level overlaps but is not contained by the slot,
> -                * then the SPTE can't be made huge.  More importantly, trying
> -                * to query that info from slot->arch.lpage_info will cause an
> +                * then the SPTE can't be made huge. On x86, trying to query
> +                * that info from slot->arch.lpage_info will cause an
>                  * out-of-bounds access.
>                  */
>                 if (iter.gfn < start || iter.gfn >= end)
>                         continue;
>
> -               max_mapping_level = kvm_mmu_max_mapping_level(kvm, slot,
> -                                                             iter.gfn, PG_LEVEL_NUM);
> +               max_mapping_level = tdp_mmu_max_mapping_level(kvm, slot, &iter);
>                 if (max_mapping_level < iter.level)
>                         continue;
>
> diff --git a/arch/x86/kvm/mmu/tdp_pgtable.c b/arch/x86/kvm/mmu/tdp_pgtable.c
> index b07ed99b4ab1..840d063c45b8 100644
> --- a/arch/x86/kvm/mmu/tdp_pgtable.c
> +++ b/arch/x86/kvm/mmu/tdp_pgtable.c
> @@ -163,3 +163,10 @@ void tdp_mmu_arch_unlink_sp(struct kvm *kvm, struct kvm_mmu_page *sp,
>         if (shared)
>                 spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
>  }
> +
> +int tdp_mmu_max_mapping_level(struct kvm *kvm,
> +                             const struct kvm_memory_slot *slot,
> +                             struct tdp_iter *iter)
> +{
> +       return kvm_mmu_max_mapping_level(kvm, slot, iter->gfn, PG_LEVEL_NUM);
> +}
> --
> 2.39.0.rc1.256.g54fd8350bd-goog
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
