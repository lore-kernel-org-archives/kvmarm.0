Return-Path: <SRS0=u6p1=NB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37630C4338F
	for <kvmarm@archiver.kernel.org>; Tue, 10 Aug 2021 04:55:45 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 996106101E
	for <kvmarm@archiver.kernel.org>; Tue, 10 Aug 2021 04:55:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 996106101E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 02F7C4056A;
	Tue, 10 Aug 2021 00:55:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id BXhbSxLMzXr2; Tue, 10 Aug 2021 00:55:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0B66C4A5A0;
	Tue, 10 Aug 2021 00:55:40 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A3834401A4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Aug 2021 00:55:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8h0Aq7Sq22Z0 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 10 Aug 2021 00:55:37 -0400 (EDT)
Received: from mail-oo1-f51.google.com (mail-oo1-f51.google.com
 [209.85.161.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B397B4056A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Aug 2021 00:55:37 -0400 (EDT)
Received: by mail-oo1-f51.google.com with SMTP id
 y16-20020a4ad6500000b0290258a7ff4058so5018281oos.10
 for <kvmarm@lists.cs.columbia.edu>; Mon, 09 Aug 2021 21:55:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=EmsMf35zTdaoUj3oiQt7gw4OgBcT1En81zKadpNn/No=;
 b=shz03uptQm2duha7ZUkpvHh5KSx7nzGS2KJ6dhmO4x0Si2KLtPdk0kBOWmy6JCCefv
 rqwOp50eH2s07aFli9nZBL7AiawL3P5sZRTBlZTfdT2cWOO3Bvyz3gWuV+ZC476CIB9n
 /uIDBEXtKX8ARC3eNWzHugtQtVmifeiQXtrmH0APc88RHOMTY45PcTVZRhbHEB+KkG+X
 9g5jnuWZyzqZym4AWAtKzcl31PpiAn14PKc0WiGdEoNpUB3BhPU1d75vuG/X/R835hfT
 bRADrOvxCY4lXjRgvQ+zOj/mKv2o+wH+34IvyyvPg2xxkv2AgyxVsVi739zbFBoDMzxd
 B8xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=EmsMf35zTdaoUj3oiQt7gw4OgBcT1En81zKadpNn/No=;
 b=c94rkNaGbbt0OVW6acwXDIwQLrPQsrk8YkOkIzi6PL7jWTHtvmgv5qysVGMO14CIFv
 vYXNJ3FCAEcbLXnreRFIr4Dslxy980neDx5/YvwCa9rCnjPBq/PKXTZEWRiKTPnloT+P
 PD28ukXCOC8nSbJTlDXX530ZhmXOmxB2KkWReHghq9R6gwQLv5x0b5rzX1B0CRY8JDYw
 Voqu4moD70oleAnx8Y+LCH3iG8/kcEryleSZjxDeYLStMG9tngCHryqlUA+i+298Hs2S
 sUxLiKVp55LR3xxXmMPM0fbrNTHWWBGPjII5eil7ctA+tC3Gf9DvusIq0gm8u8Y2ZRLK
 vW6g==
X-Gm-Message-State: AOAM531yLpPn7QuT7NBbxGsAcg5hlNNTQ3JAn8OMg0JqfnvF99uK1tm/
 aMn4k5m2NHgNJueKnxOuVwWKJR5nHX8JS2qPZ5S7Jg==
X-Google-Smtp-Source: ABdhPJx3zBvrdOUCIqwcPKtkix3hMsfC8nzn+fHxLC6Fac+88W+YYZJh/qx7nmiwao/qYiR0gb/t05gmIgMkUHq88po=
X-Received: by 2002:a4a:c896:: with SMTP id t22mr8317214ooq.70.1628571336932; 
 Mon, 09 Aug 2021 21:55:36 -0700 (PDT)
MIME-Version: 1.0
References: <20210809152448.1810400-1-qperret@google.com>
 <20210809152448.1810400-22-qperret@google.com>
In-Reply-To: <20210809152448.1810400-22-qperret@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 10 Aug 2021 06:55:00 +0200
Message-ID: <CA+EHjTz4fYdAj50KXkeccb4SMxiwWeZBz1ORhs99kY76ZF=9OA@mail.gmail.com>
Subject: Re: [PATCH v4 21/21] KVM: arm64: Make __pkvm_create_mappings static
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
> The __pkvm_create_mappings() function is no longer used outside of
> nvhe/mm.c, make it static.
>
> Signed-off-by: Quentin Perret <qperret@google.com>
> ---

Reviewed-by: Fuad Tabba <tabba@google.com>

Thanks,
/fuad

>  arch/arm64/kvm/hyp/include/nvhe/mm.h | 2 --
>  arch/arm64/kvm/hyp/nvhe/mm.c         | 4 ++--
>  2 files changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/arch/arm64/kvm/hyp/include/nvhe/mm.h b/arch/arm64/kvm/hyp/include/nvhe/mm.h
> index c76d7136ed9b..c9a8f535212e 100644
> --- a/arch/arm64/kvm/hyp/include/nvhe/mm.h
> +++ b/arch/arm64/kvm/hyp/include/nvhe/mm.h
> @@ -24,8 +24,6 @@ int hyp_back_vmemmap(phys_addr_t phys, unsigned long size, phys_addr_t back);
>  int pkvm_cpu_set_vector(enum arm64_hyp_spectre_vector slot);
>  int pkvm_create_mappings(void *from, void *to, enum kvm_pgtable_prot prot);
>  int pkvm_create_mappings_locked(void *from, void *to, enum kvm_pgtable_prot prot);
> -int __pkvm_create_mappings(unsigned long start, unsigned long size,
> -                          unsigned long phys, enum kvm_pgtable_prot prot);
>  unsigned long __pkvm_create_private_mapping(phys_addr_t phys, size_t size,
>                                             enum kvm_pgtable_prot prot);
>
> diff --git a/arch/arm64/kvm/hyp/nvhe/mm.c b/arch/arm64/kvm/hyp/nvhe/mm.c
> index 6fbe8e8030f6..2fabeceb889a 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mm.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mm.c
> @@ -23,8 +23,8 @@ u64 __io_map_base;
>  struct memblock_region hyp_memory[HYP_MEMBLOCK_REGIONS];
>  unsigned int hyp_memblock_nr;
>
> -int __pkvm_create_mappings(unsigned long start, unsigned long size,
> -                         unsigned long phys, enum kvm_pgtable_prot prot)
> +static int __pkvm_create_mappings(unsigned long start, unsigned long size,
> +                                 unsigned long phys, enum kvm_pgtable_prot prot)
>  {
>         int err;
>
> --
> 2.32.0.605.g8dce9f2422-goog
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
