Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6EE733F6
	for <kvmarm@lists.linux.dev>; Mon, 12 Dec 2022 19:16:33 +0000 (UTC)
Received: by mail-qt1-f173.google.com with SMTP id fu10so9879635qtb.0
        for <kvmarm@lists.linux.dev>; Mon, 12 Dec 2022 11:16:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
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
        b=J1l9Ze3Bv+3dx4XvJhq3ZHvpz1aTCAbF/TJJ/nGBa+SrAo12ffRwD/SOY+9SmBezgI
         6OwWjNed0NBrFnFe4piebdMxK1qcm/KwmiwpO0xKfSysl4BXbgTvYNPWKNUUjv1DDkjz
         ZyD6kOmW5tr5+4eiNrRhsASA9ebYmeL6Ts0cF5nhP3zgy3z78A8xQXUZEpigLbfctkID
         2M+2UV3Goz1oA/B1dlyt7kzVyVbRj/LYMLB1dD9l5uzu/J5ZfSvox7KboLvRqQtIHH4h
         oYEtph+1m0PTlF6N4sCg76bL3edqp2fRwlhyD/BksvhNxXNAvZBGApouePuhDXa9pYlI
         uWNQ==
X-Gm-Message-State: ANoB5pmgaBR5Mbj9mW0x+yBeAUqP9pOD2tcrz5VFUO1bTLi6NMR5KlKJ
	I7KyL0pxo1YUtYOb5dk454N9gox6yi5yHTUX3aYBKA==
X-Google-Smtp-Source: AA0mqf4WGpfWfLWnwQ8p9857/jw1O9njOLrhyCmKuR5bGk3QqXvLgKt7CBUEWjv6tK1F7/dZkHnouU9Un9Kr3J8bgV4=
X-Received: by 2002:ac8:4415:0:b0:3a6:a81b:c971 with SMTP id
 j21-20020ac84415000000b003a6a81bc971mr18259926qtn.437.1670872592731; Mon, 12
 Dec 2022 11:16:32 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221208193857.4090582-1-dmatlack@google.com> <20221208193857.4090582-18-dmatlack@google.com>
In-Reply-To: <20221208193857.4090582-18-dmatlack@google.com>
From: Ben Gardon <bgardon@google.com>
Date: Mon, 12 Dec 2022 11:16:21 -0800
Message-ID: <CANgfPd_JKw+Vtzk30GE1R3_zphOD19w4XYZ6uXQsU0AmZrXo9Q@mail.gmail.com>
Subject: Re: [RFC PATCH 17/37] KVM: Move struct kvm_gfn_range to kvm_types.h
To: David Matlack <dmatlack@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Huacai Chen <chenhuacai@kernel.org>, 
	Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atishp@atishpatra.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Sean Christopherson <seanjc@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Anshuman Khandual <anshuman.khandual@arm.com>, Nadav Amit <namit@vmware.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Vlastimil Babka <vbabka@suse.cz>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Suren Baghdasaryan <surenb@google.com>, 
	Peter Xu <peterx@redhat.com>, xu xin <cgel.zte@gmail.com>, Arnd Bergmann <arnd@arndb.de>, 
	Yu Zhao <yuzhao@google.com>, Colin Cross <ccross@google.com>, Hugh Dickins <hughd@google.com>, 
	Mingwei Zhang <mizhang@google.com>, Krish Sadhukhan <krish.sadhukhan@oracle.com>, 
	Ricardo Koller <ricarkol@google.com>, Jing Zhang <jingzhangos@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Message-ID: <20221212191621.kahZdhXufBzd9Eei8Kq2FovJZgyzCnKWNobXCQmzL7M@z>

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
