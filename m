Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 027B1200BC
	for <kvmarm@lists.linux.dev>; Tue, 30 May 2023 21:14:53 +0000 (UTC)
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-1ac65ab7432so52545ad.0
        for <kvmarm@lists.linux.dev>; Tue, 30 May 2023 14:14:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685481293; x=1688073293;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2gh5dnQpsgjBKOU+RcwoOVtaH697jrO10M3XXwyKrxw=;
        b=gEHZlpDV1gS3U7R11i/ybKsA1BLsy6BTVa+o2jGu2x4lnavvKyfByLfT8+yIEo4oJt
         FQCH1R6pRS8p3zgQAWo7LW3bbVDeZpw493pWs7U7lGxtZ/xONCfGSDhzYD3owq4UQA01
         1KLjytMWBk0ni9BS9g/RurkA75dTJ3G+Vi6wp8PQT2eM4WuxNIsdFoovRbOqWB7xgKDV
         TmosDTAyT32PTzX0/eO8IGdjq2Zt5oizC26GCAKkQzYKyRrd7o5+ook9zHP/sNqx0pXa
         ilvwFszSVVgheJa5TBefr4CKd7UuCcxjRPMADgeM+Nv4rduXWUEYyBaylKyO4zfRnohK
         MVbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685481293; x=1688073293;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2gh5dnQpsgjBKOU+RcwoOVtaH697jrO10M3XXwyKrxw=;
        b=GExoufesV9EfCkNjtiAyMMuW6Ic1cRVG9M+3B7dfBEvSWiD1yD/hvpsf2FHvig4ehJ
         r8IKEeN8o0b/vWYI+CLz5juMuZp/618VwnDCcwO+C2mwytJSeoNMM7imhFBHOQ7BhDgF
         2bsZGLUVb1jHHvuCQ5mPwkGqj/q/NGHR9Gbs4MyXuNiZwNXxcJZu2v0mLesYLxQFFnP7
         9aOx1peWbhQzt1df1BgdG1R4hUwAH0hBC/pPmpy0IV6J38ZBci6XD2jpdBnKUY6r+wBG
         +0c1alG4dOPI8rUS3ouw6ezx72SrMwQMwbVcqR/TQIm0Zx8Wq38s/Va17H9nYENi6Bx9
         vdyQ==
X-Gm-Message-State: AC+VfDyHUSoyoO+GCBI4qdVs9Iv2KzVn9AepcK/hqOakD8PjTpZUDBpF
	6mXENquaZecqoI0vVnNSygZVXk1zQTS5xgu90HkByw==
X-Google-Smtp-Source: ACHHUZ6lJGHi7lHHnaSr2AHRqQcVYv99FZfhLmFSyvA//EnYGlySlJQ4iFp1g71OMhVOlfP5i8L2JuBtfeHq/SpIXks=
X-Received: by 2002:a17:903:cd:b0:1ac:3605:97dc with SMTP id
 x13-20020a17090300cd00b001ac360597dcmr1189plc.6.1685481293069; Tue, 30 May
 2023 14:14:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230519005231.3027912-1-rananta@google.com> <20230519005231.3027912-3-rananta@google.com>
 <87wn0rjla2.wl-maz@kernel.org>
In-Reply-To: <87wn0rjla2.wl-maz@kernel.org>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Tue, 30 May 2023 14:14:42 -0700
Message-ID: <CAJHc60wAD0vCD8pnsUURkGgmWSvEbAU3DmfjP8fwuCO74=AErg@mail.gmail.com>
Subject: Re: [PATCH v4 2/6] KVM: arm64: Implement __kvm_tlb_flush_vmid_range()
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Ricardo Koller <ricarkol@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Jing Zhang <jingzhangos@google.com>, 
	Colton Lewis <coltonlewis@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, May 29, 2023 at 6:54=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrote=
:
>
> On Fri, 19 May 2023 01:52:27 +0100,
> Raghavendra Rao Ananta <rananta@google.com> wrote:
> >
> > Define  __kvm_tlb_flush_vmid_range() (for VHE and nVHE)
> > to flush a range of stage-2 page-tables using IPA in one go.
> > If the system supports FEAT_TLBIRANGE, the following patches
> > would conviniently replace global TLBI such as vmalls12e1is
> > in the map, unmap, and dirty-logging paths with ripas2e1is
> > instead.
> >
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_asm.h   |  3 +++
> >  arch/arm64/kvm/hyp/nvhe/hyp-main.c | 11 +++++++++
> >  arch/arm64/kvm/hyp/nvhe/tlb.c      | 39 ++++++++++++++++++++++++++++++
> >  arch/arm64/kvm/hyp/vhe/tlb.c       | 35 +++++++++++++++++++++++++++
> >  4 files changed, 88 insertions(+)
> >
> > diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/=
kvm_asm.h
> > index 43c3bc0f9544d..33352d9399e32 100644
> > --- a/arch/arm64/include/asm/kvm_asm.h
> > +++ b/arch/arm64/include/asm/kvm_asm.h
> > @@ -79,6 +79,7 @@ enum __kvm_host_smccc_func {
> >       __KVM_HOST_SMCCC_FUNC___pkvm_init_vm,
> >       __KVM_HOST_SMCCC_FUNC___pkvm_init_vcpu,
> >       __KVM_HOST_SMCCC_FUNC___pkvm_teardown_vm,
> > +     __KVM_HOST_SMCCC_FUNC___kvm_tlb_flush_vmid_range,
>
> nit: please keep this close to the other TLB operations.
>
Sure, I'll reorder this.

> >  };
> >
> >  #define DECLARE_KVM_VHE_SYM(sym)     extern char sym[]
> > @@ -225,6 +226,8 @@ extern void __kvm_flush_vm_context(void);
> >  extern void __kvm_flush_cpu_context(struct kvm_s2_mmu *mmu);
> >  extern void __kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *mmu, phys_addr=
_t ipa,
> >                                    int level);
> > +extern void __kvm_tlb_flush_vmid_range(struct kvm_s2_mmu *mmu,
> > +                                     phys_addr_t start, phys_addr_t en=
d);
> >  extern void __kvm_tlb_flush_vmid(struct kvm_s2_mmu *mmu);
> >
> >  extern void __kvm_timer_set_cntvoff(u64 cntvoff);
> > diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nv=
he/hyp-main.c
> > index 728e01d4536b0..81d30737dc7c9 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > @@ -125,6 +125,16 @@ static void handle___kvm_tlb_flush_vmid_ipa(struct=
 kvm_cpu_context *host_ctxt)
> >       __kvm_tlb_flush_vmid_ipa(kern_hyp_va(mmu), ipa, level);
> >  }
> >
> > +static void
> > +handle___kvm_tlb_flush_vmid_range(struct kvm_cpu_context *host_ctxt)
> > +{
> > +     DECLARE_REG(struct kvm_s2_mmu *, mmu, host_ctxt, 1);
> > +     DECLARE_REG(phys_addr_t, start, host_ctxt, 2);
> > +     DECLARE_REG(phys_addr_t, end, host_ctxt, 3);
> > +
> > +     __kvm_tlb_flush_vmid_range(kern_hyp_va(mmu), start, end);
> > +}
> > +
> >  static void handle___kvm_tlb_flush_vmid(struct kvm_cpu_context *host_c=
txt)
> >  {
> >       DECLARE_REG(struct kvm_s2_mmu *, mmu, host_ctxt, 1);
> > @@ -315,6 +325,7 @@ static const hcall_t host_hcall[] =3D {
> >       HANDLE_FUNC(__kvm_vcpu_run),
> >       HANDLE_FUNC(__kvm_flush_vm_context),
> >       HANDLE_FUNC(__kvm_tlb_flush_vmid_ipa),
> > +     HANDLE_FUNC(__kvm_tlb_flush_vmid_range),
> >       HANDLE_FUNC(__kvm_tlb_flush_vmid),
> >       HANDLE_FUNC(__kvm_flush_cpu_context),
> >       HANDLE_FUNC(__kvm_timer_set_cntvoff),
> > diff --git a/arch/arm64/kvm/hyp/nvhe/tlb.c b/arch/arm64/kvm/hyp/nvhe/tl=
b.c
> > index 978179133f4b9..d4ea549c4b5c4 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/tlb.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/tlb.c
> > @@ -130,6 +130,45 @@ void __kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *m=
mu,
> >       __tlb_switch_to_host(&cxt);
> >  }
> >
> > +void __kvm_tlb_flush_vmid_range(struct kvm_s2_mmu *mmu,
> > +                             phys_addr_t start, phys_addr_t end)
> > +{
> > +     struct tlb_inv_context cxt;
> > +     unsigned long pages, stride;
> > +
> > +     /*
> > +      * Since the range of addresses may not be mapped at
> > +      * the same level, assume the worst case as PAGE_SIZE
> > +      */
> > +     stride =3D PAGE_SIZE;
> > +     start =3D round_down(start, stride);
> > +     end =3D round_up(end, stride);
> > +     pages =3D (end - start) >> PAGE_SHIFT;
> > +
> > +     if (!system_supports_tlb_range() || pages >=3D MAX_TLBI_RANGE_PAG=
ES) {
> > +             __kvm_tlb_flush_vmid(mmu);
> > +             return;
>
> Why do we give up on "pages >=3D MAX_TLBI_RANGE_PAGES"? I see no
> rationale for it in the patch. My understanding is that this is the
> maximum representable as a range, in which case this is a programming
> error.
>
> Or are you *on purpose* making the two equivalent?
>
Yes basically, I was trying to align the logic with what we have for
__flush_tlb_range(). But, if you feel that it's mostly caused by a
programming error, do we want to not do any flush at all?

Thank you.

Raghavendra
> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
