Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8F02C433EF
	for <kvmarm@archiver.kernel.org>; Sat,  7 May 2022 09:15:02 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8CE8A4B2A0;
	Sat,  7 May 2022 05:15:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jwnlQ0BxUzn8; Sat,  7 May 2022 05:14:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DF3394B2F4;
	Sat,  7 May 2022 05:14:40 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D69454B248
 for <kvmarm@lists.cs.columbia.edu>; Sat,  7 May 2022 03:51:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FEJKDU9ULz0e for <kvmarm@lists.cs.columbia.edu>;
 Sat,  7 May 2022 03:51:57 -0400 (EDT)
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com
 [209.85.216.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8219E4B241
 for <kvmarm@lists.cs.columbia.edu>; Sat,  7 May 2022 03:51:57 -0400 (EDT)
Received: by mail-pj1-f49.google.com with SMTP id e24so8944917pjt.2
 for <kvmarm@lists.cs.columbia.edu>; Sat, 07 May 2022 00:51:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=message-id:date:mime-version:user-agent:subject:content-language:to
 :cc:references:from:in-reply-to:content-transfer-encoding;
 bh=FKFTVnqj1TSVH5UzHH+NO5fdnNT2aHzWK9Qt0Z+5p7o=;
 b=WrbhvaSR0rfRQ2ictV8jJhBIOD5Vbgm0vojL3lLq/cHeldCdx3DTbT5BZzoMWNuKra
 M9mVSR81V195rBTicolSZH5ZYQLVqJpHTNUrR0r2YIuqogcbHZ6O/8XCSksVHv5xY6DP
 LhmVFiFVQoqnEjHHYddIgnRHs3DFGAiXeYIapd9us7o6fxYn7dk93WfFuOR8FLp2+Eys
 vNazlyjrDi2toas6jLKU+axdRp71QkeBXunUG7ufE5djpFyRzXqDNEluAGugJgVdCO0y
 6SKAG4LBLZ3wVv1DP+mlH3l+hUbNSsBGvD93NdTJvSOwaqCvavnQ2Shgwp+nmLu/GrGC
 XUGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=FKFTVnqj1TSVH5UzHH+NO5fdnNT2aHzWK9Qt0Z+5p7o=;
 b=BXoO9S+eAe5c/T1uRDaKwzoVd23y2Y4lThyf3u6Ong9mRI2Xo0z3CHDOBjQUGwtGNp
 d+EPR1csSNfiHysHzAojSgPoaNzRnlxbPbziuTdtHYQQeaF6XuEJMafBeWzsmKsvvj8o
 YdfdHDYyzz5/viuFFPmZ9hClml/2bA5kHX8iQfOrkuzyfZ+A9jJSi7aly9XKzamIsCeW
 IARB5uUV5GP3OO/G+IHjZDZiRQuFSaUuCh/47A/M2z95k7k4IfE6hP2X18vB8H5N40KT
 W8KPMfqVclCCke1MxSC7h08tEqHsKbNwjQPYgOfCK/m4V55U/ZpFGEfJkhCTzPjmlJAx
 nH1w==
X-Gm-Message-State: AOAM530eEPVeG/g4G51pS96rxtcJiAc9vtFXwv/jSHKdJSl2mgfpNGja
 xUPMhdmwo72ygFGABc4VlAc=
X-Google-Smtp-Source: ABdhPJynlIeNwHKvFkAfj64vRfPLjoPtqup3wVpb8FZ4dGugmE0hMqTJ5mYlYb7kNjW4L1NekC5Exw==
X-Received: by 2002:a17:90b:3646:b0:1d8:15c5:464b with SMTP id
 nh6-20020a17090b364600b001d815c5464bmr16936437pjb.63.1651909916397; 
 Sat, 07 May 2022 00:51:56 -0700 (PDT)
Received: from [30.22.112.212] ([205.204.117.91])
 by smtp.gmail.com with ESMTPSA id
 f16-20020a170902ab9000b0015e8d4eb2c1sm2976004plr.267.2022.05.07.00.51.52
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Sat, 07 May 2022 00:51:56 -0700 (PDT)
Message-ID: <de48ed40-4e6e-c49d-426e-91aba4ce1337@gmail.com>
Date: Sat, 7 May 2022 15:51:50 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.1
Subject: Re: [PATCH v4 20/20] KVM: x86/mmu: Extend Eager Page Splitting to
 nested MMUs
Content-Language: en-US
To: David Matlack <dmatlack@google.com>, Paolo Bonzini <pbonzini@redhat.com>
References: <20220422210546.458943-1-dmatlack@google.com>
 <20220422210546.458943-21-dmatlack@google.com>
From: Lai Jiangshan <jiangshanlai@gmail.com>
In-Reply-To: <20220422210546.458943-21-dmatlack@google.com>
X-Mailman-Approved-At: Sat, 07 May 2022 05:14:38 -0400
Cc: Albert Ou <aou@eecs.berkeley.edu>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <kvm@vger.kernel.org>, Marc Zyngier <maz@kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <linux-mips@vger.kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Palmer Dabbelt <palmer@dabbelt.com>,
 "open list:KERNEL VIRTUAL MACHINE FOR RISC-V \(KVM/riscv\)"
 <kvm-riscv@lists.infradead.org>, Paul Walmsley <paul.walmsley@sifive.com>,
 Ben Gardon <bgardon@google.com>, maciej.szmigiero@oracle.com,
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu


On 2022/4/23 05:05, David Matlack wrote:
> Add support for Eager Page Splitting pages that are mapped by nested
> MMUs. Walk through the rmap first splitting all 1GiB pages to 2MiB
> pages, and then splitting all 2MiB pages to 4KiB pages.
>
> Note, Eager Page Splitting is limited to nested MMUs as a policy rather
> than due to any technical reason (the sp->role.guest_mode check could
> just be deleted and Eager Page Splitting would work correctly for all
> shadow MMU pages). There is really no reason to support Eager Page
> Splitting for tdp_mmu=N, since such support will eventually be phased
> out, and there is no current use case supporting Eager Page Splitting on
> hosts where TDP is either disabled or unavailable in hardware.
> Furthermore, future improvements to nested MMU scalability may diverge
> the code from the legacy shadow paging implementation. These
> improvements will be simpler to make if Eager Page Splitting does not
> have to worry about legacy shadow paging.
>
> Splitting huge pages mapped by nested MMUs requires dealing with some
> extra complexity beyond that of the TDP MMU:
>
> (1) The shadow MMU has a limit on the number of shadow pages that are
>      allowed to be allocated. So, as a policy, Eager Page Splitting
>      refuses to split if there are KVM_MIN_FREE_MMU_PAGES or fewer
>      pages available.
>
> (2) Splitting a huge page may end up re-using an existing lower level
>      shadow page tables. This is unlike the TDP MMU which always allocates
>      new shadow page tables when splitting.
>
> (3) When installing the lower level SPTEs, they must be added to the
>      rmap which may require allocating additional pte_list_desc structs.
>
> Case (2) is especially interesting since it may require a TLB flush,
> unlike the TDP MMU which can fully split huge pages without any TLB
> flushes. Specifically, an existing lower level page table may point to
> even lower level page tables that are not fully populated, effectively
> unmapping a portion of the huge page, which requires a flush.
>
> This commit performs such flushes after dropping the huge page and
> before installing the lower level page table. This TLB flush could
> instead be delayed until the MMU lock is about to be dropped, which
> would batch flushes for multiple splits.  However these flushes should
> be rare in practice (a huge page must be aliased in multiple SPTEs and
> have been split for NX Huge Pages in only some of them). Flushing
> immediately is simpler to plumb and also reduces the chances of tripping
> over a CPU bug (e.g. see iTLB multihit).
>
> Suggested-by: Peter Feiner <pfeiner@google.com>
> [ This commit is based off of the original implementation of Eager Page
>    Splitting from Peter in Google's kernel from 2016. ]
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>   .../admin-guide/kernel-parameters.txt         |   3 +-
>   arch/x86/include/asm/kvm_host.h               |  20 ++
>   arch/x86/kvm/mmu/mmu.c                        | 276 +++++++++++++++++-
>   arch/x86/kvm/x86.c                            |   6 +
>   4 files changed, 296 insertions(+), 9 deletions(-)
>
> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> index 3f1cc5e317ed..bc3ad3d4df0b 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -2387,8 +2387,7 @@
>   			the KVM_CLEAR_DIRTY ioctl, and only for the pages being
>   			cleared.
>   
> -			Eager page splitting currently only supports splitting
> -			huge pages mapped by the TDP MMU.
> +			Eager page splitting is only supported when kvm.tdp_mmu=Y.
>   
>   			Default is Y (on).
>   
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 15131aa05701..5df4dff385a1 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1240,6 +1240,24 @@ struct kvm_arch {
>   	hpa_t	hv_root_tdp;
>   	spinlock_t hv_root_tdp_lock;
>   #endif
> +
> +	/*
> +	 * Memory caches used to allocate shadow pages when performing eager
> +	 * page splitting. No need for a shadowed_info_cache since eager page
> +	 * splitting only allocates direct shadow pages.
> +	 */
> +	struct kvm_mmu_memory_cache split_shadow_page_cache;
> +	struct kvm_mmu_memory_cache split_page_header_cache;
> +
> +	/*
> +	 * Memory cache used to allocate pte_list_desc structs while splitting
> +	 * huge pages. In the worst case, to split one huge page, 512
> +	 * pte_list_desc structs are needed to add each lower level leaf sptep
> +	 * to the rmap plus 1 to extend the parent_ptes rmap of the lower level
> +	 * page table.
> +	 */
> +#define SPLIT_DESC_CACHE_CAPACITY 513
> +	struct kvm_mmu_memory_cache split_desc_cache;
>   };
>   
>   


I think it needs to document that the topup operations for these caches are

protected by kvm->slots_lock.

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
