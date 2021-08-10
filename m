Return-Path: <SRS0=u6p1=NB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7866BC4338F
	for <kvmarm@archiver.kernel.org>; Tue, 10 Aug 2021 04:42:36 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 02D5560EBD
	for <kvmarm@archiver.kernel.org>; Tue, 10 Aug 2021 04:42:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 02D5560EBD
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 751C84A7FD;
	Tue, 10 Aug 2021 00:42:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Slcm0H-daOwJ; Tue, 10 Aug 2021 00:42:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 85CB249FA6;
	Tue, 10 Aug 2021 00:42:31 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 031D04075E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Aug 2021 00:42:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2np7V3zu1gpK for <kvmarm@lists.cs.columbia.edu>;
 Tue, 10 Aug 2021 00:42:29 -0400 (EDT)
Received: from mail-oo1-f44.google.com (mail-oo1-f44.google.com
 [209.85.161.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1E17B405EE
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Aug 2021 00:42:29 -0400 (EDT)
Received: by mail-oo1-f44.google.com with SMTP id
 b25-20020a4ac2990000b0290263aab95660so5006109ooq.13
 for <kvmarm@lists.cs.columbia.edu>; Mon, 09 Aug 2021 21:42:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=Bd2e89EFb2qiItJyKlrlfgjBBM7/Zn2J3//6956bc/E=;
 b=Xvr6yqrQsDl0A5hIX0l7Y8z30odcy0GqB8nZ+F/pojyjJZAhyMmdiV1NihwKAAaNPX
 3dvNw+cunuzu90NjAFP3DWqj1KAKJOyNvKt7aRGvAePMvkeArlZEDjB13mC3GgJvXgUD
 PRHoKtQ/kOfx9LZ/9j7SqeEHfEtxDWCe/MERESwtrXaeS2WGlGyaQNEI325nf4TszPC0
 bLi5NITNN93RGxBTO3aqi9VXYWruC9o8QAWylkdPY1xNwWiiCZjCfRly5SUFKbqHBOLY
 yygUIBZXsU6rIfuuAIZm8dVmssbdXRVZj+mW5agjmoVSU/cdZJn45foey/yP+lnf8zBE
 ZieA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=Bd2e89EFb2qiItJyKlrlfgjBBM7/Zn2J3//6956bc/E=;
 b=RpVkByGob3eBSbOiGiy7zWT30l4i9lfyXa2g2OrEpekp7lw+jUhIFry4NzXKfh66QI
 8qmGIQXXQwbc5ZlEilaRMO8T19V4gzWkKwnA4H2xIk9mBW6yqq/uuvMaqUhGEEfDaxKS
 D4IfLUCaX134awCsCYdYc7nv8e5TW2e9fXMs/7osznkg0kDDYersmsyTPDH4dRHGi8V7
 QXuppch/tFnApjmYhBpmVN6aql3NmO53FC7BDkIY1ZFZv5CZOf37iNtjEMVnKZgBVXkL
 NP6iapvVF90EXa/uoOaSpAoiwHiKKVFfPYEX8uaeOLe2lsaGbqUd+0tUUbFrMusJYV+J
 q3iA==
X-Gm-Message-State: AOAM530X4cpKPhzPEDoVCYEwi+BoMgjt41BJGtOfkFJWaPcbt+1ME3qQ
 ho5SCLAxzhrDUcDNPl0k/AHxPwF+/zliE5GhGMvhtg==
X-Google-Smtp-Source: ABdhPJxn1pzJQUqJZiVp4uQHbWoRAbEwDouBRi0K1Wptkk8N3Hpeqq86pGs9alv+MsLMBL+2VJU0oDhNxLzdkd/Tibg=
X-Received: by 2002:a4a:e14f:: with SMTP id p15mr17359764oot.42.1628570548380; 
 Mon, 09 Aug 2021 21:42:28 -0700 (PDT)
MIME-Version: 1.0
References: <20210809152448.1810400-1-qperret@google.com>
 <20210809152448.1810400-20-qperret@google.com>
In-Reply-To: <20210809152448.1810400-20-qperret@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 10 Aug 2021 06:41:52 +0200
Message-ID: <CA+EHjTxfnNFwOk=V+w5BUMTCREX+FUpVnzKAhCoCMnyL3BPZBw@mail.gmail.com>
Subject: Re: [PATCH v4 19/21] KVM: arm64: Refactor protected nVHE stage-1
 locking
To: Quentin Perret <qperret@google.com>
Cc: kernel-team@android.com, qwandor@google.com, maz@kernel.org,
 linux-kernel@vger.kernel.org, catalin.marinas@arm.com, will@kernel.org,
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

Hi Quentin,

On Mon, Aug 9, 2021 at 5:25 PM Quentin Perret <qperret@google.com> wrote:
>
> Refactor the hypervisor stage-1 locking in nVHE protected mode to expose
> a new pkvm_create_mappings_locked() function. This will be used in later
> patches to allow walking and changing the hypervisor stage-1 without
> releasing the lock.
>
> Signed-off-by: Quentin Perret <qperret@google.com>

Reviewed-by: Fuad Tabba <tabba@google.com>

Thanks,
/fuad

> ---
>  arch/arm64/kvm/hyp/include/nvhe/mm.h |  1 +
>  arch/arm64/kvm/hyp/nvhe/mm.c         | 18 ++++++++++++++++--
>  2 files changed, 17 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm64/kvm/hyp/include/nvhe/mm.h b/arch/arm64/kvm/hyp/include/nvhe/mm.h
> index 8ec3a5a7744b..c76d7136ed9b 100644
> --- a/arch/arm64/kvm/hyp/include/nvhe/mm.h
> +++ b/arch/arm64/kvm/hyp/include/nvhe/mm.h
> @@ -23,6 +23,7 @@ int hyp_map_vectors(void);
>  int hyp_back_vmemmap(phys_addr_t phys, unsigned long size, phys_addr_t back);
>  int pkvm_cpu_set_vector(enum arm64_hyp_spectre_vector slot);
>  int pkvm_create_mappings(void *from, void *to, enum kvm_pgtable_prot prot);
> +int pkvm_create_mappings_locked(void *from, void *to, enum kvm_pgtable_prot prot);
>  int __pkvm_create_mappings(unsigned long start, unsigned long size,
>                            unsigned long phys, enum kvm_pgtable_prot prot);
>  unsigned long __pkvm_create_private_mapping(phys_addr_t phys, size_t size,
> diff --git a/arch/arm64/kvm/hyp/nvhe/mm.c b/arch/arm64/kvm/hyp/nvhe/mm.c
> index a8efdf0f9003..6fbe8e8030f6 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mm.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mm.c
> @@ -67,13 +67,15 @@ unsigned long __pkvm_create_private_mapping(phys_addr_t phys, size_t size,
>         return addr;
>  }
>
> -int pkvm_create_mappings(void *from, void *to, enum kvm_pgtable_prot prot)
> +int pkvm_create_mappings_locked(void *from, void *to, enum kvm_pgtable_prot prot)
>  {
>         unsigned long start = (unsigned long)from;
>         unsigned long end = (unsigned long)to;
>         unsigned long virt_addr;
>         phys_addr_t phys;
>
> +       hyp_assert_lock_held(&pkvm_pgd_lock);
> +
>         start = start & PAGE_MASK;
>         end = PAGE_ALIGN(end);
>
> @@ -81,7 +83,8 @@ int pkvm_create_mappings(void *from, void *to, enum kvm_pgtable_prot prot)
>                 int err;
>
>                 phys = hyp_virt_to_phys((void *)virt_addr);
> -               err = __pkvm_create_mappings(virt_addr, PAGE_SIZE, phys, prot);
> +               err = kvm_pgtable_hyp_map(&pkvm_pgtable, virt_addr, PAGE_SIZE,
> +                                         phys, prot);
>                 if (err)
>                         return err;
>         }
> @@ -89,6 +92,17 @@ int pkvm_create_mappings(void *from, void *to, enum kvm_pgtable_prot prot)
>         return 0;
>  }
>
> +int pkvm_create_mappings(void *from, void *to, enum kvm_pgtable_prot prot)
> +{
> +       int ret;
> +
> +       hyp_spin_lock(&pkvm_pgd_lock);
> +       ret = pkvm_create_mappings_locked(from, to, prot);
> +       hyp_spin_unlock(&pkvm_pgd_lock);
> +
> +       return ret;
> +}
> +
>  int hyp_back_vmemmap(phys_addr_t phys, unsigned long size, phys_addr_t back)
>  {
>         unsigned long start, end;
> --
> 2.32.0.605.g8dce9f2422-goog
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
