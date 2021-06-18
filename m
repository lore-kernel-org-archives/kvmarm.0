Return-Path: <SRS0=A4hI=LM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89B06C49361
	for <kvmarm@archiver.kernel.org>; Fri, 18 Jun 2021 08:50:48 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 11A2F613CB
	for <kvmarm@archiver.kernel.org>; Fri, 18 Jun 2021 08:50:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 11A2F613CB
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7D27549FB7;
	Fri, 18 Jun 2021 04:50:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id tAVS7XF9ZyLN; Fri, 18 Jun 2021 04:50:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5AA3E4A1A7;
	Fri, 18 Jun 2021 04:50:46 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3333940FC7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Jun 2021 04:50:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6k14ZVnCxtGY for <kvmarm@lists.cs.columbia.edu>;
 Fri, 18 Jun 2021 04:50:44 -0400 (EDT)
Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com
 [209.85.167.174])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0329E4081C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Jun 2021 04:50:43 -0400 (EDT)
Received: by mail-oi1-f174.google.com with SMTP id w127so9779854oig.12
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Jun 2021 01:50:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=jdFKobz0v5eVip0thXQlonp2mF35EnH4oN1hYfZc5Y8=;
 b=eaI1qif8hWH4BDUPA4zAfU/JyLPIPsuOqFjMGM8Bena5fakXJe42h1NsUQcLTvKdJ1
 LOcf3Qw8GQpYgpe1f/t5BZwAua9NJK/G8Q5YA0x3gEUix6SK0puD0UuAtx+522RhyFpH
 v4eUaoWuflGssbIsWGhZ4Q0auBg7DdWZVHDrnnwfk2+9LefFaGFSuIuQ9zld9KS8IFv6
 Sd0rdtaCXNVsby6BzdgBjLciQorxLwS2MxQSfyQVweBhblWYkBi4L+gKasclg9l19zHq
 1GMpCGCj40H2EsIOBz8dw37C0Qe0+/jP52+2bQikzN3ft8mTNr0GKkink3eqiPd9DNE/
 sy/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=jdFKobz0v5eVip0thXQlonp2mF35EnH4oN1hYfZc5Y8=;
 b=HLTGAbz4mJXP2qPvPvOEAjVOz29l4nx2XTlhY2/mt9qR/cBKWuas15K3wbUdjNdt1E
 XinCfqUc1Ba5FRnOf8/H52LAiwmC8p4zPPu2JFc6kwJOjBIWcDVjC5vVs10tzlEbj1KB
 1vxSktC+rgvniPEXhLsUTmqBCHyanZCqaIoTEcKcLde79uGe0gwnDV45pwsqHiS1Va6Z
 4DyTLe9TxHvpaFiytL7gOa328Sjn0uExa7sj2tB+6Ljqjcef1a8HtsCxUb5RmAeHPRK5
 byfx6JaMMwvGz/Xe10g3ZwpX7dfErVjVV6FUj51WxfeLIAZuZ8Yi7z5+iCD5whGI0XrF
 iS+w==
X-Gm-Message-State: AOAM532oY2UAIdMNg5rr5EpvDRqZj62yc5VNIpzYpKE9t+UxZLvAoMy9
 bxtNuk9o2PISCG5Fbeuuac05d/RMIksKUCVbqiGw7A==
X-Google-Smtp-Source: ABdhPJypyxrsFJT695FL1xens+cccnkIs+C967czc330C77nK9BPZwBZ32eYzwZk3n/kX5cAq1Thkw1gKRvl10izUa0=
X-Received: by 2002:aca:de07:: with SMTP id v7mr13635036oig.8.1624006243106;
 Fri, 18 Jun 2021 01:50:43 -0700 (PDT)
MIME-Version: 1.0
References: <20210616095200.38008-1-wangyanan55@huawei.com>
 <20210616095200.38008-2-wangyanan55@huawei.com>
In-Reply-To: <20210616095200.38008-2-wangyanan55@huawei.com>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 18 Jun 2021 09:50:06 +0100
Message-ID: <CA+EHjTyVnHkk5rYb=W6msqoT5E_bVTBdhLtpeRR_b2wsib4Vgw@mail.gmail.com>
Subject: Re: [PATCH v6 1/4] KVM: arm64: Introduce cache maintenance callbacks
 for guest stage-2
To: Yanan Wang <wangyanan55@huawei.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

Hi Yanan,

On Wed, Jun 16, 2021 at 10:52 AM Yanan Wang <wangyanan55@huawei.com> wrote:
>
> To prepare for performing guest CMOs in the fault handlers in pgtable.c,
> introduce two cache maintenance callbacks in struct kvm_pgtable_mm_ops.
>
> The new callbacks are specific for guest stage-2, so they will only be
> initialized in 'struct kvm_pgtable_mm_ops kvm_s2_mm_ops'.
>
> Signed-off-by: Yanan Wang <wangyanan55@huawei.com>
> ---
>  arch/arm64/include/asm/kvm_pgtable.h | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> index c3674c47d48c..302eca32e0af 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -44,6 +44,11 @@ typedef u64 kvm_pte_t;
>   *                     in the current context.
>   * @virt_to_phys:      Convert a virtual address mapped in the current context
>   *                     into a physical address.
> + * @flush_dcache:      Clean data cache for a guest page address range before
> + *                     creating the corresponding stage-2 mapping.
> + * @flush_icache:      Invalidate instruction cache for a guest page address
> + *                     range before creating or updating the corresponding
> + *                     stage-2 mapping.
>   */
>  struct kvm_pgtable_mm_ops {
>         void*           (*zalloc_page)(void *arg);
> @@ -54,6 +59,8 @@ struct kvm_pgtable_mm_ops {
>         int             (*page_count)(void *addr);
>         void*           (*phys_to_virt)(phys_addr_t phys);
>         phys_addr_t     (*virt_to_phys)(void *addr);
> +       void            (*flush_dcache)(void *addr, size_t size);
> +       void            (*flush_icache)(void *addr, size_t size);
>  };
>

Just to add to Marc's comment on naming, flush_dcache is in this case
a clean and invalidate: I see that in patch 4 it eventually does a
civac. So, yes, although it is a mouthful, I think it should be
dcache_clean_inval and not just dcache_clean. An alternative, if it's
acceptable by Marc and the others, is to name the parameters dcmo/icmo
or something like that, where the nature of the maintenance operation
is not necessarily tied to the name.

For reference, this is the patch Marc mentioned, where we're trying to
fix the naming to make it consistent with Arm terminology (Arm doesn't
define what a flush is):
https://lore.kernel.org/linux-arm-kernel/20210524083001.2586635-19-tabba@google.com/

Otherwise:
Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad


>  /**
> --
> 2.23.0
>
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
