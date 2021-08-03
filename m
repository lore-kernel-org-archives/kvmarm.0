Return-Path: <SRS0=p2dm=M2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9FFBC4338F
	for <kvmarm@archiver.kernel.org>; Tue,  3 Aug 2021 05:31:44 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5DC8F60F41
	for <kvmarm@archiver.kernel.org>; Tue,  3 Aug 2021 05:31:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 5DC8F60F41
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B681B40667;
	Tue,  3 Aug 2021 01:31:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8TzDlBM6K0fk; Tue,  3 Aug 2021 01:31:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A3F13406D3;
	Tue,  3 Aug 2021 01:31:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 823ED4066E
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Aug 2021 01:31:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nXPXHzeft13A for <kvmarm@lists.cs.columbia.edu>;
 Tue,  3 Aug 2021 01:31:40 -0400 (EDT)
Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com
 [209.85.210.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5DA5C402A9
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Aug 2021 01:31:40 -0400 (EDT)
Received: by mail-ot1-f46.google.com with SMTP id
 e13-20020a056830200db02904f06fa2790cso863051otp.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 02 Aug 2021 22:31:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=Po/YZOILTmzrKkwPCgFv0W6S5rEcnTiI475aJx7OtDk=;
 b=tspspKCzxf3dmvM9PbDYEPm3AmQpSu50tc9b+llKKl7n1mT4jrbe+Z6JGQDcifMAF+
 HQY90mmsaeiBqaBa0zJVodVm+2NmqPjcsViqcCVODxGkOF5ysu1zCjyeOvmQvutwqF2Q
 xyBGMpTCE/+qoBcJ9OZOU7EXqwbCN8VOrL8EA9myE9R0bcJs3uOPWRRr3HJNstqH1jHe
 M/awtkRnSp+XXF7yXRKRu0R6aVoLeZuxy4CgQzPVN95+XgmsjMVe7Rxalo7LE7ZsrA+P
 MBYrJ13XeNcKRFqBMNULhow1Bq3fV8f0w32XIuU7iAGaWWJwBU1MQat268IbtZ5tlcgV
 /L9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=Po/YZOILTmzrKkwPCgFv0W6S5rEcnTiI475aJx7OtDk=;
 b=AP8MnOr/wYRv2vIeWgAOmk0hvdxm4Icporx+02h1zebQGmAmNEGZ1+mNa8Fy709uWv
 pVVHSv7d0SYbEZdPHxrnc2V6yb4Y01bwTb4sY2DUL3eswYUrNQXboF9FOHRt9RvxarTw
 sPF39isWPBYct0MMNVtbaRpWFwDPg3uQCeN6GGXAJPZ5zhWxqD+Et6OBiF8HVY1XqM/t
 5I+E8FI45o/ZsKg+7AuAjjrRR8BofVdqDYOVCn8C771tk/PK6O3QFJrTpv+naWo0N/wL
 tlz5NgAix0CHd2KfiduEJaykE/Bnf8OlheGLdz2pRuBhJFiC+qQrnjBLHu+43IehmyQ8
 KcBg==
X-Gm-Message-State: AOAM530dWBtaWnDC+EQLrOfG8twb/xw25SD4yBnNRV+EhCMwyfEJkSF4
 yA1Mt8/u9I1EdHuSZCPvzLWnrY8xtwNalpbZN0bP3w==
X-Google-Smtp-Source: ABdhPJy1HDBBzhcvNCRK5xNSS9iFpgQuB17eEHlmHNL8ct6gYXoCpJTZVAjHq3COPZzflHgWQ+W5gfuj9ZOJYJghGNM=
X-Received: by 2002:a05:6830:1455:: with SMTP id
 w21mr14380175otp.365.1627968699557; 
 Mon, 02 Aug 2021 22:31:39 -0700 (PDT)
MIME-Version: 1.0
References: <20210729132818.4091769-1-qperret@google.com>
 <20210729132818.4091769-20-qperret@google.com>
In-Reply-To: <20210729132818.4091769-20-qperret@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 3 Aug 2021 07:31:03 +0200
Message-ID: <CA+EHjTwWt+jvRZsk5KEhQWzn+XqdV2gZSq7oCuOCVXRa1=JiWw@mail.gmail.com>
Subject: Re: [PATCH v3 19/21] KVM: arm64: Refactor protected nVHE stage-1
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

On Thu, Jul 29, 2021 at 3:29 PM Quentin Perret <qperret@google.com> wrote:
>
> Refactor the hypervisor stage-1 locking in nVHE protected mode to expose
> a new pkvm_create_mappings_locked() function. This will be used in later
> patches to allow walking and changing the hypervisor stage-1 without
> releasing the lock.
>
> Signed-off-by: Quentin Perret <qperret@google.com>
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

I'm wondering whether this patch should also refactor
__pkvm_create_mappings. It doesn't quite do the exact same thing and
has different parameters.

Thanks,
/fuad

>  int hyp_back_vmemmap(phys_addr_t phys, unsigned long size, phys_addr_t back)
>  {
>         unsigned long start, end;
> --
> 2.32.0.432.gabb21c7263-goog
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
