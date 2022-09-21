Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57877C6FA8B
	for <kvmarm@archiver.kernel.org>; Wed, 21 Sep 2022 09:17:44 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D041D4B7CE;
	Wed, 21 Sep 2022 05:17:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8XLwmWc8GOqN; Wed, 21 Sep 2022 05:17:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 423424B7FB;
	Wed, 21 Sep 2022 05:17:41 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F2D694B7C4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Sep 2022 05:17:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6VEGSbWf6ykJ for <kvmarm@lists.cs.columbia.edu>;
 Wed, 21 Sep 2022 05:17:38 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 627744B637
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Sep 2022 05:17:38 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0A1F5143D;
 Wed, 21 Sep 2022 02:17:44 -0700 (PDT)
Received: from [10.57.50.65] (unknown [10.57.50.65])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8CA703F73D;
 Wed, 21 Sep 2022 02:17:33 -0700 (PDT)
Message-ID: <1fd95a49-cf33-9b3b-3e3b-70333d78280a@arm.com>
Date: Wed, 21 Sep 2022 10:17:30 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v4 4/8] mm: Add PG_arch_3 page flag
Content-Language: en-GB
To: Peter Collingbourne <pcc@google.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
References: <20220921035140.57513-1-pcc@google.com>
 <20220921035140.57513-5-pcc@google.com>
From: Steven Price <steven.price@arm.com>
In-Reply-To: <20220921035140.57513-5-pcc@google.com>
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Cornelia Huck <cohuck@redhat.com>, Marc Zyngier <maz@kernel.org>,
 Vincenzo Frascino <vincenzo.frascino@arm.com>, Will Deacon <will@kernel.org>,
 Evgenii Stepanov <eugenis@google.com>
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

On 21/09/2022 04:51, Peter Collingbourne wrote:
> As with PG_arch_2, this flag is only allowed on 64-bit architectures due
> to the shortage of bits available. It will be used by the arm64 MTE code
> in subsequent patches.

NIT: It's now controlled by CONFIG_ARCH_USES_PG_ARCH_X and not
technically tied to 64-bit (although in practise obviously 32-bit
architectures won't have spare bits).

> 
> Signed-off-by: Peter Collingbourne <pcc@google.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Steven Price <steven.price@arm.com>
> [catalin.marinas@arm.com: added flag preserving in __split_huge_page_tail()]
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>

Reviewed-by: Steven Price <steven.price@arm.com>

> ---
>  fs/proc/page.c                    | 1 +
>  include/linux/kernel-page-flags.h | 1 +
>  include/linux/page-flags.h        | 1 +
>  include/trace/events/mmflags.h    | 1 +
>  mm/huge_memory.c                  | 1 +
>  5 files changed, 5 insertions(+)
> 
> diff --git a/fs/proc/page.c b/fs/proc/page.c
> index 6f4b4bcb9b0d..43d371e6b366 100644
> --- a/fs/proc/page.c
> +++ b/fs/proc/page.c
> @@ -220,6 +220,7 @@ u64 stable_page_flags(struct page *page)
>  	u |= kpf_copy_bit(k, KPF_ARCH,		PG_arch_1);
>  #ifdef CONFIG_ARCH_USES_PG_ARCH_X
>  	u |= kpf_copy_bit(k, KPF_ARCH_2,	PG_arch_2);
> +	u |= kpf_copy_bit(k, KPF_ARCH_3,	PG_arch_3);
>  #endif
>  
>  	return u;
> diff --git a/include/linux/kernel-page-flags.h b/include/linux/kernel-page-flags.h
> index eee1877a354e..859f4b0c1b2b 100644
> --- a/include/linux/kernel-page-flags.h
> +++ b/include/linux/kernel-page-flags.h
> @@ -18,5 +18,6 @@
>  #define KPF_UNCACHED		39
>  #define KPF_SOFTDIRTY		40
>  #define KPF_ARCH_2		41
> +#define KPF_ARCH_3		42
>  
>  #endif /* LINUX_KERNEL_PAGE_FLAGS_H */
> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> index 5dc7977edf9d..c50ce2812f17 100644
> --- a/include/linux/page-flags.h
> +++ b/include/linux/page-flags.h
> @@ -134,6 +134,7 @@ enum pageflags {
>  #endif
>  #ifdef CONFIG_ARCH_USES_PG_ARCH_X
>  	PG_arch_2,
> +	PG_arch_3,
>  #endif
>  #ifdef CONFIG_KASAN_HW_TAGS
>  	PG_skip_kasan_poison,
> diff --git a/include/trace/events/mmflags.h b/include/trace/events/mmflags.h
> index 4673e58a7626..9db52bc4ce19 100644
> --- a/include/trace/events/mmflags.h
> +++ b/include/trace/events/mmflags.h
> @@ -130,6 +130,7 @@ IF_HAVE_PG_HWPOISON(PG_hwpoison,	"hwpoison"	)		\
>  IF_HAVE_PG_IDLE(PG_young,		"young"		)		\
>  IF_HAVE_PG_IDLE(PG_idle,		"idle"		)		\
>  IF_HAVE_PG_ARCH_X(PG_arch_2,		"arch_2"	)		\
> +IF_HAVE_PG_ARCH_X(PG_arch_3,		"arch_3"	)		\
>  IF_HAVE_PG_SKIP_KASAN_POISON(PG_skip_kasan_poison, "skip_kasan_poison")
>  
>  #define show_page_flags(flags)						\
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 24974a4ce28f..c7c5f9fb226d 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -2446,6 +2446,7 @@ static void __split_huge_page_tail(struct page *head, int tail,
>  			 (1L << PG_unevictable) |
>  #ifdef CONFIG_ARCH_USES_PG_ARCH_X
>  			 (1L << PG_arch_2) |
> +			 (1L << PG_arch_3) |
>  #endif
>  			 (1L << PG_dirty) |
>  			 LRU_GEN_MASK | LRU_REFS_MASK));

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
