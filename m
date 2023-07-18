Received: from mail-il1-f177.google.com (mail-il1-f177.google.com [209.85.166.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B949215AE3
	for <kvmarm@lists.linux.dev>; Tue, 18 Jul 2023 16:31:34 +0000 (UTC)
Received: by mail-il1-f177.google.com with SMTP id e9e14a558f8ab-346099c6f43so178485ab.0
        for <kvmarm@lists.linux.dev>; Tue, 18 Jul 2023 09:31:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689697893; x=1690302693;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FOUt0ycfIIC4G92ZHk96f3py83XofJ3hc7BWl3IwSXo=;
        b=70EYw8mQUne1cNpTuVS0kMr31zvHYUt7jMEY5WFkQMZBfCcJIiLIETbDzK0JXOJ4Nb
         o7zLGOeq5Y4Kcl59mMGBHYDHb1N2qivCEsecXmwhGzqyIktQtxxQgfZa0nuVzldc1mYK
         1YVDEGGtjV910sPWe+g+ml5wvq3TqGoCYgLeILNgyRlGhe6eJ3lIRsm7QrAHqbIc16iO
         xXQvaTZ84vTOaqA9NUMCMXvrhEiThuuMWZhAGrbCWnGHX7sDiEk0cnpqvdzZUB4ghQGY
         QtT89zT9eN26NqxZPsW6fDAu67sawQDnR4GVx8BwBSuTs2HltUcGsgtm53Amj8OI093n
         dK0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689697893; x=1690302693;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FOUt0ycfIIC4G92ZHk96f3py83XofJ3hc7BWl3IwSXo=;
        b=VWKSuOOwMjJHob/MP4dNHTm4h1Lnpoc9yTLvSoYRfXVJIzV1LNDGLkTkrlnY5O0RfG
         5Ixg+o9dkkTdGybmG0Hda1okXtT4b/qMt+mPoJ3GW7kuqfo9TT2otzG94WsAatYqTWFf
         UOIPvSiwpH2wAG6JmKDOr36FX8I2q8RiJkZVUSYi9msD21NIz+RUvByE0fejX1x7lz4o
         st6X0WYOidANFMSQBtxRq9VGvzHHWmfc3dUM6t71aq1hoHNGWZx9FMb5L4LPtaxzjajE
         +VYQKqZi4KF2D9UXsWpOaY7SWYwJEorMbUDBdXA1gVykaoMriuS0Ak5nEv5T6/4uwZDV
         8qcQ==
X-Gm-Message-State: ABy/qLZEgTDIy/V7g0wA4nRGDFcoE0NW9EtToHXnUsjXHaaXkiwS5Rrv
	khbHohW0aIWfgA5nLmoQimBqZvQEmuIxYTFYh8iacA==
X-Google-Smtp-Source: APBJJlFqQdwopGyRSQ6vPehJzW/apQ8j3vOGXsWwGhXT5m1KRrmjOL5Jyef2j1KLskn4+6D/a0FXbZ81TqZtnje6akU=
X-Received: by 2002:a05:6e02:1a0b:b0:33c:a46c:23b3 with SMTP id
 s11-20020a056e021a0b00b0033ca46c23b3mr252894ild.1.1689697893605; Tue, 18 Jul
 2023 09:31:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230715005405.3689586-1-rananta@google.com> <20230715005405.3689586-4-rananta@google.com>
 <199d18de-1214-7683-b87a-03cc7e49719a@redhat.com> <CAJHc60zhVco3uTq97vDHMk8cgg1psPtwHT6MN1eKP1Yr18d9cw@mail.gmail.com>
 <fb52139b-5854-6370-7de3-bd87b31e3148@redhat.com>
In-Reply-To: <fb52139b-5854-6370-7de3-bd87b31e3148@redhat.com>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Tue, 18 Jul 2023 09:31:20 -0700
Message-ID: <CAJHc60yYUYnPxdC3PAM_bcd4w2JpMvZFJ6R3mQWXjqt3YMQgUg@mail.gmail.com>
Subject: Re: [PATCH v6 03/11] KVM: Allow range-based TLB invalidation from
 common code
To: Shaoqin Huang <shahuang@redhat.com>
Cc: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Huacai Chen <chenhuacai@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>, 
	Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
	Jing Zhang <jingzhangos@google.com>, Colton Lewis <coltonlewis@google.com>, 
	David Matlack <dmatlack@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-mips@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Gavin Shan <gshan@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Shaoqin,

On Mon, Jul 17, 2023 at 7:49=E2=80=AFPM Shaoqin Huang <shahuang@redhat.com>=
 wrote:
>
>
>
> On 7/18/23 00:37, Raghavendra Rao Ananta wrote:
> > On Mon, Jul 17, 2023 at 4:40=E2=80=AFAM Shaoqin Huang <shahuang@redhat.=
com> wrote:
> >>
> >>
> >>
> >> On 7/15/23 08:53, Raghavendra Rao Ananta wrote:
> >>> From: David Matlack <dmatlack@google.com>
> >>>
> >>> Make kvm_flush_remote_tlbs_range() visible in common code and create =
a
> >>> default implementation that just invalidates the whole TLB.
> >>>
> >>> This paves the way for several future features/cleanups:
> >>>
> >>>    - Introduction of range-based TLBI on ARM.
> >>>    - Eliminating kvm_arch_flush_remote_tlbs_memslot()
> >>>    - Moving the KVM/x86 TDP MMU to common code.
> >>>
> >>> No functional change intended.
> >>>
> >>> Signed-off-by: David Matlack <dmatlack@google.com>
> >>> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> >>> Reviewed-by: Gavin Shan <gshan@redhat.com>
> >>> ---
> >>>    arch/x86/include/asm/kvm_host.h |  3 +++
> >>>    arch/x86/kvm/mmu/mmu.c          |  9 ++++-----
> >>>    arch/x86/kvm/mmu/mmu_internal.h |  3 ---
> >>>    include/linux/kvm_host.h        |  9 +++++++++
> >>>    virt/kvm/kvm_main.c             | 13 +++++++++++++
> >>>    5 files changed, 29 insertions(+), 8 deletions(-)
> >>>
> >>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/k=
vm_host.h
> >>> index a2d3cfc2eb75..08900afbf2ad 100644
> >>> --- a/arch/x86/include/asm/kvm_host.h
> >>> +++ b/arch/x86/include/asm/kvm_host.h
> >>> @@ -1804,6 +1804,9 @@ static inline int kvm_arch_flush_remote_tlbs(st=
ruct kvm *kvm)
> >>>                return -ENOTSUPP;
> >>>    }
> >>>
> >>> +#define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS_RANGE
> >>> +int kvm_arch_flush_remote_tlbs_range(struct kvm *kvm, gfn_t start_gf=
n, u64 pages);
> >>> +
> >>>    #define kvm_arch_pmi_in_guest(vcpu) \
> >>>        ((vcpu) && (vcpu)->arch.handling_intr_from_guest)
> >>>
> >>> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> >>> index ec169f5c7dce..aaa5e336703a 100644
> >>> --- a/arch/x86/kvm/mmu/mmu.c
> >>> +++ b/arch/x86/kvm/mmu/mmu.c
> >>> @@ -278,16 +278,15 @@ static inline bool kvm_available_flush_remote_t=
lbs_range(void)
> >>>        return kvm_x86_ops.flush_remote_tlbs_range;
> >>>    }
> >>>
> >>> -void kvm_flush_remote_tlbs_range(struct kvm *kvm, gfn_t start_gfn,
> >>> -                              gfn_t nr_pages)
> >>> +int kvm_arch_flush_remote_tlbs_range(struct kvm *kvm, gfn_t start_gf=
n, u64 pages)
> >>>    {
> >>>        int ret =3D -EOPNOTSUPP;
> >>>
> >>>        if (kvm_x86_ops.flush_remote_tlbs_range)
> >>>                ret =3D static_call(kvm_x86_flush_remote_tlbs_range)(k=
vm, start_gfn,
> >>> -                                                                nr_p=
ages);
> >>> -     if (ret)
> >>> -             kvm_flush_remote_tlbs(kvm);
> >>> +                                                                    =
 pages);
> >> This will be good if parameter pages aligned with parameter kvm.
> >>
> > Agreed, but pulling 'pages' above brings the char count to 83. If
> > that's acceptable, I'm happy to do it in v7.
> > Hi Raghavendra,
>
> no need to pulling 'pages' above, just delete one tab, and add some
> space before the pages, just like the original `nr_pages` position.
>
Oh yes, that can be done. Thanks!

- Raghavendra
> Thanks,
> Shaoqin
> > Thank you.
> > Raghavendra
> >> Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
> >>> +
> >>> +     return ret;
> >>>    }
> >>>
> >>>    static gfn_t kvm_mmu_page_get_gfn(struct kvm_mmu_page *sp, int ind=
ex);
> >>> diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_i=
nternal.h
> >>> index d39af5639ce9..86cb83bb3480 100644
> >>> --- a/arch/x86/kvm/mmu/mmu_internal.h
> >>> +++ b/arch/x86/kvm/mmu/mmu_internal.h
> >>> @@ -170,9 +170,6 @@ bool kvm_mmu_slot_gfn_write_protect(struct kvm *k=
vm,
> >>>                                    struct kvm_memory_slot *slot, u64 =
gfn,
> >>>                                    int min_level);
> >>>
> >>> -void kvm_flush_remote_tlbs_range(struct kvm *kvm, gfn_t start_gfn,
> >>> -                              gfn_t nr_pages);
> >>> -
> >>>    /* Flush the given page (huge or not) of guest memory. */
> >>>    static inline void kvm_flush_remote_tlbs_gfn(struct kvm *kvm, gfn_=
t gfn, int level)
> >>>    {
> >>> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> >>> index e3f968b38ae9..a731967b24ff 100644
> >>> --- a/include/linux/kvm_host.h
> >>> +++ b/include/linux/kvm_host.h
> >>> @@ -1359,6 +1359,7 @@ int kvm_vcpu_yield_to(struct kvm_vcpu *target);
> >>>    void kvm_vcpu_on_spin(struct kvm_vcpu *vcpu, bool yield_to_kernel_=
mode);
> >>>
> >>>    void kvm_flush_remote_tlbs(struct kvm *kvm);
> >>> +void kvm_flush_remote_tlbs_range(struct kvm *kvm, gfn_t gfn, u64 pag=
es);
> >>>
> >>>    #ifdef KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE
> >>>    int kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, in=
t min);
> >>> @@ -1486,6 +1487,14 @@ static inline int kvm_arch_flush_remote_tlbs(s=
truct kvm *kvm)
> >>>    }
> >>>    #endif
> >>>
> >>> +#ifndef __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS_RANGE
> >>> +static inline int kvm_arch_flush_remote_tlbs_range(struct kvm *kvm,
> >>> +                                                gfn_t gfn, u64 pages=
)
> >>> +{
> >>> +     return -EOPNOTSUPP;
> >>> +}
> >>> +#endif
> >>> +
> >>>    #ifdef __KVM_HAVE_ARCH_NONCOHERENT_DMA
> >>>    void kvm_arch_register_noncoherent_dma(struct kvm *kvm);
> >>>    void kvm_arch_unregister_noncoherent_dma(struct kvm *kvm);
> >>> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> >>> index d6b050786155..804470fccac7 100644
> >>> --- a/virt/kvm/kvm_main.c
> >>> +++ b/virt/kvm/kvm_main.c
> >>> @@ -366,6 +366,19 @@ void kvm_flush_remote_tlbs(struct kvm *kvm)
> >>>    }
> >>>    EXPORT_SYMBOL_GPL(kvm_flush_remote_tlbs);
> >>>
> >>> +void kvm_flush_remote_tlbs_range(struct kvm *kvm, gfn_t gfn, u64 pag=
es)
> >>> +{
> >>> +     if (!kvm_arch_flush_remote_tlbs_range(kvm, gfn, pages))
> >>> +             return;
> >>> +
> >>> +     /*
> >>> +      * Fall back to a flushing entire TLBs if the architecture rang=
e-based
> >>> +      * TLB invalidation is unsupported or can't be performed for wh=
atever
> >>> +      * reason.
> >>> +      */
> >>> +     kvm_flush_remote_tlbs(kvm);
> >>> +}
> >>> +
> >>>    static void kvm_flush_shadow_all(struct kvm *kvm)
> >>>    {
> >>>        kvm_arch_flush_shadow_all(kvm);
> >>
> >> --
> >> Shaoqin
> >>
> >
>
> --
> Shaoqin
>
