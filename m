Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 261A6C4332F
	for <kvmarm@archiver.kernel.org>; Tue, 26 Apr 2022 07:35:10 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 95F074B1EF;
	Tue, 26 Apr 2022 03:35:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4jMS92eJkuXt; Tue, 26 Apr 2022 03:35:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EB20F4B1CA;
	Tue, 26 Apr 2022 03:35:04 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 171294B156
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Apr 2022 03:35:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fL3GYeFwg6Dt for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 Apr 2022 03:35:01 -0400 (EDT)
Received: from mail-il1-f170.google.com (mail-il1-f170.google.com
 [209.85.166.170])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8D0F64B150
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Apr 2022 03:35:01 -0400 (EDT)
Received: by mail-il1-f170.google.com with SMTP id t4so10863435ilo.12
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Apr 2022 00:35:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=T6uVKqz/bxBh0XcbvcuRA0UyoUPF9VXe65F1cQD8y4Q=;
 b=ObEunFSl4crRLGfpGD9vb4uNjucdcW+SwMC5wjs68ErQM98eX2dd/1bhFqvb4MQrUZ
 aNBQiYOEZs6DAFrjwy4GxIX9P710BE5dNtb9ren8SoNbyoDCq1JSrqMW6bcxyN3g457u
 /+gBpA8szyFlMBKjZqPcqtIcg53tpCAgbfmBRZ+EQiSDL0bYkiLUkJAuAA+ESILGYbW5
 jVcb61+A+66M7v7MKaJKTdQY27E/r9amtlm20dB0rHCxpqld0qjq5eRsqvCmPNleg1uA
 MTGwgfxKApBNNdQAeaBp8qoeybFa8FJ6gos+fYTUTeB4wg78apx7w8FkSb2oMxvxLXSe
 mDTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=T6uVKqz/bxBh0XcbvcuRA0UyoUPF9VXe65F1cQD8y4Q=;
 b=kaCRyVX3MQDBoDZMgnDip5UbEzGJCFT+mZsl8jS6oU3kd6buAyksUnMFwNuaStql2C
 NfM1QPfEHPghY1ZrFg78GSMQ+/gwn7LGTrzF1vOFOo/HTy88VpaQDqQdyD22SjSx8wWw
 DILKUuZPomohvf/4SGm43dHkcEkb75GMo8fqy2JKtHFUzumTrWmhigUyeadAud/2+821
 juoJHAXXetk5ySXFA3UGc6Mffhsu/GqSJuyUJtw8sLB0O3iD/YidvyDRCovA320GU61q
 oO03UQl8QLl5Q1PJM6+RyJAJeUCQCz9zn2aau3vs9gfPzsnbIMQryfUwqnnR9uoppPA3
 35cQ==
X-Gm-Message-State: AOAM533VCkAsgPlRfkysJouqCW1lLiC8ZUvV1lKIUKbWXTvZ24diLeLE
 PHctjo0tEoPWzXbxdhvYeExNuw==
X-Google-Smtp-Source: ABdhPJzzgIPYx4mfeq03H4D4LkohxnIEdiAlT4JnSJ/rUPy7BWzzJro8BOalbut4cMQo3UF9wiXwfw==
X-Received: by 2002:a05:6e02:b23:b0:2cd:89db:f685 with SMTP id
 e3-20020a056e020b2300b002cd89dbf685mr5194103ilu.296.1650958500701; 
 Tue, 26 Apr 2022 00:35:00 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194]) by smtp.gmail.com with ESMTPSA id
 w5-20020a05660205c500b006546d0b5f6dsm9257784iox.41.2022.04.26.00.34.59
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 26 Apr 2022 00:34:59 -0700 (PDT)
Date: Tue, 26 Apr 2022 07:34:56 +0000
From: Oliver Upton <oupton@google.com>
To: Yosry Ahmed <yosryahmed@google.com>
Subject: Re: [PATCH v3 4/6] KVM: arm64/mmu: count KVM page table pages in
 pagetable stats
Message-ID: <YmegoB/fBkfwaE5z@google.com>
References: <20220426053904.3684293-1-yosryahmed@google.com>
 <20220426053904.3684293-5-yosryahmed@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220426053904.3684293-5-yosryahmed@google.com>
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Catalin Marinas <catalin.marinas@arm.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Michal Hocko <mhocko@kernel.org>,
 linux-mm@kvack.org, kvmarm@lists.cs.columbia.edu,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt <shakeelb@google.com>,
 Atish Patra <atishp@atishpatra.org>, cgroups@vger.kernel.org,
 Vitaly Kuznetsov <vkuznets@redhat.com>, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>, linux-mips@vger.kernel.org,
 linux-kernel@vger.kernel.org, kvm-riscv@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Yosry,

On Tue, Apr 26, 2022 at 05:39:02AM +0000, Yosry Ahmed wrote:
> Count the pages used by KVM in arm64 for page tables in pagetable stats.
> 
> Account pages allocated for PTEs in pgtable init functions and
> kvm_set_table_pte().
> 
> Since most page table pages are freed using put_page(), add a helper
> function put_pte_page() that checks if this is the last ref for a pte
> page before putting it, and unaccounts stats accordingly.
> 
> Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
> ---
>  arch/arm64/kernel/image-vars.h |  3 ++
>  arch/arm64/kvm/hyp/pgtable.c   | 50 +++++++++++++++++++++-------------
>  2 files changed, 34 insertions(+), 19 deletions(-)
> 
> diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
> index 241c86b67d01..25bf058714f6 100644
> --- a/arch/arm64/kernel/image-vars.h
> +++ b/arch/arm64/kernel/image-vars.h
> @@ -143,6 +143,9 @@ KVM_NVHE_ALIAS(__hyp_rodata_end);
>  /* pKVM static key */
>  KVM_NVHE_ALIAS(kvm_protected_mode_initialized);
>  
> +/* Called by kvm_account_pgtable_pages() to update pagetable stats */
> +KVM_NVHE_ALIAS(__mod_lruvec_page_state);
> +
>  #endif /* CONFIG_KVM */
>  
>  #endif /* __ARM64_KERNEL_IMAGE_VARS_H */
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index 2cb3867eb7c2..53e13c3313e9 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -152,6 +152,7 @@ static void kvm_set_table_pte(kvm_pte_t *ptep, kvm_pte_t *childp,
>  
>  	WARN_ON(kvm_pte_valid(old));
>  	smp_store_release(ptep, pte);
> +	kvm_account_pgtable_pages((void *)childp, +1);

What page tables do we want to account? KVM on ARM manages several page
tables.

For regular KVM, the host kernel manages allocations for the hyp stage 1
tables in addition to the stage 2 tables used for a particular VM. The
former is system overhead whereas the latter could be attributed to a
guest VM.

I imagine protected KVM is out of scope, since it actually manages its
own allocations outside of the host kernel.

Given this, I would recommend adding the accounting hooks to mmu.c as
that is where we alloc/free table pages and it is in the host address
space. kvm_s2_mm_ops and kvm_hyp_mm_ops point to all the relevant
functions, though the latter is only relevant if we want to count system
page tables too.

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
