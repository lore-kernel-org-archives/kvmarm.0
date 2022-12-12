Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABBE7C4332F
	for <kvmarm@archiver.kernel.org>; Mon, 12 Dec 2022 19:16:37 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 18F194B921;
	Mon, 12 Dec 2022 14:16:37 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id yg6Gjd3vRPs6; Mon, 12 Dec 2022 14:16:35 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CF9AE4B971;
	Mon, 12 Dec 2022 14:16:35 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 764464B921
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 14:16:34 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nuXS7JTd6iRS for <kvmarm@lists.cs.columbia.edu>;
 Mon, 12 Dec 2022 14:16:33 -0500 (EST)
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com
 [209.85.160.181])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5372A4B91F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 14:16:33 -0500 (EST)
Received: by mail-qt1-f181.google.com with SMTP id cg5so9838815qtb.12
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 11:16:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:from:to:cc:subject:date:message-id:reply-to;
 bh=7FMUUUtCYecfXpbEXjiOLj576wn1MKIcly3I5EGbnCU=;
 b=l/2Fzg7K2w6LeoqTVQRvr6MNT6h2CWF7uWpi6AcpSeXPJLWs93b53h4/DaxEs3S7yg
 FmBJ/eQjHKTHyIyyljJe+i4llG7szE8ICe++PVGg48c7nvViW1blvdm1AR6l1CmHD6AX
 kFg6hl4Vs3u7X1Twn6fsy9hoN7ccZU342euVFVUW7uX/cmNpk616/caD/CinGqNjNJTs
 QTXe7MFJ/La+/mPWZPg9ETEbrRrOv6B0InpYW9oHi8Mnc2qFUGeBchwY4K2AfUssSRcy
 qozMFX4bvtu0bwAtdxAWkGgcgPw5BFdhXNT0jyS/Adf7ohyw+Ajj3xoMSPGHpP0wiv8S
 7Qfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=7FMUUUtCYecfXpbEXjiOLj576wn1MKIcly3I5EGbnCU=;
 b=ftME7KfjrLFsfmRR9ZEUAJh+yf2K/eH6sD/UNXbAqf7KwZGlERVqGLdPk807Zye7Vb
 1EPwLZsjvNImeLuLhvJsjH/2CyG2uPsiP00mq/670sCppT8TXpuCDfFqRjZ5sFM+xYL7
 kUhaC8wmJdl1UbOjNZg8VjAMMg4ynlMoGh2kcCjMbf+xQqKrDk0PHGf9SKaT3kTBoIEY
 wBiWHrz126ZbVrjQLMEjedSnwDOaHKMyYr3GiqlViLnfKggA+cpnmlWvu9hWR+qK4Cfq
 KjPG+FRhFs8/GtkinTeqRZtNAgOncbV50z56BtV0JwhyampifcSgEVH4z/ouRz2zL5mq
 CvhQ==
X-Gm-Message-State: ANoB5pmCDkfauSDM83t9LidsY/TrB7p0Div+mAS1OpYcOzHyhpSx+cwe
 hVH+5cTzvkPUkXJbHMXATt3K/Xhm7ZdqaKUj2g2Q2g==
X-Google-Smtp-Source: AA0mqf4WGpfWfLWnwQ8p9857/jw1O9njOLrhyCmKuR5bGk3QqXvLgKt7CBUEWjv6tK1F7/dZkHnouU9Un9Kr3J8bgV4=
X-Received: by 2002:ac8:4415:0:b0:3a6:a81b:c971 with SMTP id
 j21-20020ac84415000000b003a6a81bc971mr18259926qtn.437.1670872592731; Mon, 12
 Dec 2022 11:16:32 -0800 (PST)
MIME-Version: 1.0
References: <20221208193857.4090582-1-dmatlack@google.com>
 <20221208193857.4090582-18-dmatlack@google.com>
In-Reply-To: <20221208193857.4090582-18-dmatlack@google.com>
From: Ben Gardon <bgardon@google.com>
Date: Mon, 12 Dec 2022 11:16:21 -0800
Message-ID: <CANgfPd_JKw+Vtzk30GE1R3_zphOD19w4XYZ6uXQsU0AmZrXo9Q@mail.gmail.com>
Subject: Re: [RFC PATCH 17/37] KVM: Move struct kvm_gfn_range to kvm_types.h
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
> Move struct kvm_gfn_range to kvm_types.h so that it's definition can be
> accessed in a future commit by arch/x86/include/asm/kvm/tdp_pgtable.h
> without needing to include the mega-header kvm_host.h.
>
> No functional change intended.
>
> Signed-off-by: David Matlack <dmatlack@google.com>

Reviewed-by: Ben Gardon <bgardon@google.com>

> ---
>  include/linux/kvm_host.h  | 7 -------
>  include/linux/kvm_types.h | 8 ++++++++
>  2 files changed, 8 insertions(+), 7 deletions(-)
>
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 22ecb7ce4d31..469ff4202a0d 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -256,13 +256,6 @@ int kvm_async_pf_wakeup_all(struct kvm_vcpu *vcpu);
>  #endif
>
>  #ifdef KVM_ARCH_WANT_MMU_NOTIFIER

I don't have any problem with always having this defined, but might be
worth noting that it's now defined on all archs, regardless of
KVM_ARCH_WANT_MMU_NOTIFIER.

> -struct kvm_gfn_range {
> -       struct kvm_memory_slot *slot;
> -       gfn_t start;
> -       gfn_t end;
> -       pte_t pte;
> -       bool may_block;
> -};
>  bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range);
>  bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range);
>  bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range);
> diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
> index 59cf958d69df..001aad9ea987 100644
> --- a/include/linux/kvm_types.h
> +++ b/include/linux/kvm_types.h
> @@ -132,4 +132,12 @@ struct kvm_vcpu_stat_generic {
>
>  #define KVM_STATS_NAME_SIZE    48
>
> +struct kvm_gfn_range {
> +       struct kvm_memory_slot *slot;
> +       gfn_t start;
> +       gfn_t end;
> +       pte_t pte;
> +       bool may_block;
> +};
> +
>  #endif /* __KVM_TYPES_H__ */
> --
> 2.39.0.rc1.256.g54fd8350bd-goog
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
