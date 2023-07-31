Received: from mail-il1-f175.google.com (mail-il1-f175.google.com [209.85.166.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 929601D2F9
	for <kvmarm@lists.linux.dev>; Mon, 31 Jul 2023 17:45:13 +0000 (UTC)
Received: by mail-il1-f175.google.com with SMTP id e9e14a558f8ab-3460770afe2so7125ab.1
        for <kvmarm@lists.linux.dev>; Mon, 31 Jul 2023 10:45:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690825512; x=1691430312;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kGd0AsQAwp8H4S0Hha56MgdpWqYeFbEB+5/aXRn1dMo=;
        b=zhNx/6wzQh/59YeSRE6Zk4KX3oq74BFHs4UtLBkzn2jdHIAdFgvHuAar0N7QSKQ9f5
         gjQxMlF+fLNY+ZUISpJHI0elU+cLIdQf9GgISZnsqfCf83nff+p8ZoI4qwMxlGSHmRGS
         H9vLbyX49OVEAIxHJDj0yWOJiTKWw62piWzCVMyGtpsQzzwSHz6vu5Y5Kd4s7w/bM6ad
         yxqnXQ65tId6WoxniRpfQrscD+4ZkZbKquP8FbIAUUvtEeAJhDc8s8hf77qxAQblxC6d
         MGM+hARijf69iuafH7E2VxwLQh8Zk2A1wLG/KqMNKUk0JsY95RdIIY1aKBg+ToecJziV
         ljcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690825512; x=1691430312;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kGd0AsQAwp8H4S0Hha56MgdpWqYeFbEB+5/aXRn1dMo=;
        b=dAdSP9rTioghH6n+FxE5MZjICUhD433zLVOMRxvHRZGUEW2dS3ePsxYwUS2dCtggQM
         wO7CNntlLznnJ5tvo/w9iqBjHKBUOXyl5XAzlUjPUjS707J7VuBL3WrftIbDP9rgD+RY
         0gHcg081b53x0TA1CAVBaqfoyqSJ6X9OSdhSNWQ9KZX6kZuk8vO35kU13TOuLorxloqo
         FdqhhN4nqvmxdp8zl8ASP+XPAd469kocxIRtxonQT1oISy0NwUXqeDGd+UlQBYMxdhor
         +vIe42NkZoToeVTAyJUV72m4cNZbQ5WqmkgZsj41wjLpjjQiEC5P0FsPURZ2S5PWJrdP
         m61g==
X-Gm-Message-State: ABy/qLYS+NAy5tPwJxbTvqUzEAQE/FDAmuEiiJsEC+45ObnOLk7gXSxm
	z4bqNBU8klai/ywjZx3baS5MP396/1jcovffUSbKHQ==
X-Google-Smtp-Source: APBJJlHvsEicZK0ZV+JPaAOpuRWgNNmyNpC20X4iCvK3kUuw0MwfTIC6ClvWz7VEDkFWRsgU9lS/jm5d+jFZ3qI9OLA=
X-Received: by 2002:a05:6e02:1d8e:b0:345:fd14:c32e with SMTP id
 h14-20020a056e021d8e00b00345fd14c32emr460245ila.25.1690825512355; Mon, 31 Jul
 2023 10:45:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230722022251.3446223-1-rananta@google.com> <20230722022251.3446223-8-rananta@google.com>
 <87pm4dr0hd.wl-maz@kernel.org>
In-Reply-To: <87pm4dr0hd.wl-maz@kernel.org>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Mon, 31 Jul 2023 10:45:01 -0700
Message-ID: <CAJHc60ztA7pNQVHbd1WPmPNkoEzZWarDmxnLxh=-5ZYo9CWw2g@mail.gmail.com>
Subject: Re: [PATCH v7 07/12] KVM: arm64: Implement __kvm_tlb_flush_vmid_range()
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Huacai Chen <chenhuacai@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atishp@atishpatra.org>, Jing Zhang <jingzhangos@google.com>, 
	Reiji Watanabe <reijiw@google.com>, Colton Lewis <coltonlewis@google.com>, 
	David Matlack <dmatlack@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-mips@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Gavin Shan <gshan@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 27, 2023 at 5:40=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrote=
:
>
> On Sat, 22 Jul 2023 03:22:46 +0100,
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
> > Reviewed-by: Gavin Shan <gshan@redhat.com>
> > ---
> >  arch/arm64/include/asm/kvm_asm.h   |  3 +++
> >  arch/arm64/kvm/hyp/nvhe/hyp-main.c | 11 +++++++++++
> >  arch/arm64/kvm/hyp/nvhe/tlb.c      | 30 ++++++++++++++++++++++++++++++
> >  arch/arm64/kvm/hyp/vhe/tlb.c       | 27 +++++++++++++++++++++++++++
> >  4 files changed, 71 insertions(+)
> >
> > diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/=
kvm_asm.h
> > index 7d170aaa2db4..2c27cb8cf442 100644
> > --- a/arch/arm64/include/asm/kvm_asm.h
> > +++ b/arch/arm64/include/asm/kvm_asm.h
> > @@ -70,6 +70,7 @@ enum __kvm_host_smccc_func {
> >       __KVM_HOST_SMCCC_FUNC___kvm_tlb_flush_vmid_ipa,
> >       __KVM_HOST_SMCCC_FUNC___kvm_tlb_flush_vmid_ipa_nsh,
> >       __KVM_HOST_SMCCC_FUNC___kvm_tlb_flush_vmid,
> > +     __KVM_HOST_SMCCC_FUNC___kvm_tlb_flush_vmid_range,
> >       __KVM_HOST_SMCCC_FUNC___kvm_flush_cpu_context,
> >       __KVM_HOST_SMCCC_FUNC___kvm_timer_set_cntvoff,
> >       __KVM_HOST_SMCCC_FUNC___vgic_v3_read_vmcr,
> > @@ -229,6 +230,8 @@ extern void __kvm_tlb_flush_vmid_ipa(struct kvm_s2_=
mmu *mmu, phys_addr_t ipa,
> >  extern void __kvm_tlb_flush_vmid_ipa_nsh(struct kvm_s2_mmu *mmu,
> >                                        phys_addr_t ipa,
> >                                        int level);
> > +extern void __kvm_tlb_flush_vmid_range(struct kvm_s2_mmu *mmu,
> > +                                     phys_addr_t start, unsigned long =
pages);
> >  extern void __kvm_tlb_flush_vmid(struct kvm_s2_mmu *mmu);
> >
> >  extern void __kvm_timer_set_cntvoff(u64 cntvoff);
> > diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nv=
he/hyp-main.c
> > index a169c619db60..857d9bc04fd4 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > @@ -135,6 +135,16 @@ static void handle___kvm_tlb_flush_vmid_ipa_nsh(st=
ruct kvm_cpu_context *host_ctx
> >       __kvm_tlb_flush_vmid_ipa_nsh(kern_hyp_va(mmu), ipa, level);
> >  }
> >
> > +static void
> > +handle___kvm_tlb_flush_vmid_range(struct kvm_cpu_context *host_ctxt)
> > +{
> > +     DECLARE_REG(struct kvm_s2_mmu *, mmu, host_ctxt, 1);
> > +     DECLARE_REG(phys_addr_t, start, host_ctxt, 2);
> > +     DECLARE_REG(unsigned long, pages, host_ctxt, 3);
> > +
> > +     __kvm_tlb_flush_vmid_range(kern_hyp_va(mmu), start, pages);
> > +}
> > +
> >  static void handle___kvm_tlb_flush_vmid(struct kvm_cpu_context *host_c=
txt)
> >  {
> >       DECLARE_REG(struct kvm_s2_mmu *, mmu, host_ctxt, 1);
> > @@ -327,6 +337,7 @@ static const hcall_t host_hcall[] =3D {
> >       HANDLE_FUNC(__kvm_tlb_flush_vmid_ipa),
> >       HANDLE_FUNC(__kvm_tlb_flush_vmid_ipa_nsh),
> >       HANDLE_FUNC(__kvm_tlb_flush_vmid),
> > +     HANDLE_FUNC(__kvm_tlb_flush_vmid_range),
> >       HANDLE_FUNC(__kvm_flush_cpu_context),
> >       HANDLE_FUNC(__kvm_timer_set_cntvoff),
> >       HANDLE_FUNC(__vgic_v3_read_vmcr),
> > diff --git a/arch/arm64/kvm/hyp/nvhe/tlb.c b/arch/arm64/kvm/hyp/nvhe/tl=
b.c
> > index b9991bbd8e3f..09347111c2cd 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/tlb.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/tlb.c
> > @@ -182,6 +182,36 @@ void __kvm_tlb_flush_vmid_ipa_nsh(struct kvm_s2_mm=
u *mmu,
> >       __tlb_switch_to_host(&cxt);
> >  }
> >
> > +void __kvm_tlb_flush_vmid_range(struct kvm_s2_mmu *mmu,
> > +                             phys_addr_t start, unsigned long pages)
> > +{
> > +     struct tlb_inv_context cxt;
> > +     unsigned long stride;
> > +
> > +     /*
> > +      * Since the range of addresses may not be mapped at
> > +      * the same level, assume the worst case as PAGE_SIZE
> > +      */
> > +     stride =3D PAGE_SIZE;
> > +     start =3D round_down(start, stride);
> > +
> > +     /* Switch to requested VMID */
> > +     __tlb_switch_to_guest(mmu, &cxt, false);
> > +
> > +     __flush_tlb_range_op(ipas2e1is, start, pages, stride, 0, 0, false=
);
>
> I really think we need an abstraction here. All this ASID and user
> nonsense shouldn't appear here. Something such as
> __flush_s2_tlb_range_op(), which would pass the correct parameters
> that this code shouldn't have to worry about.
>
Yes, a simple wrapper would be nice. I'll implement this in v8.

> I'm also a bit concerned by the fact we completely lose the level
> here. This is a massive fast-path for the CPU, and we don't make use
> of it. It'd be worth thinking of how we can make use of it if at all
> possible...
>
Initial implementation of the series included the 'level', but had
some complexities [1], and so we had to get rid of it for things to at
least be correct.
But, we can think about it and include the 'level' as needed.

- Raghavendra

[1]: https://lore.kernel.org/all/ZCTjirkCgBkT65eP@linux.dev/

> > +
> > +     dsb(ish);
> > +     __tlbi(vmalle1is);
> > +     dsb(ish);
> > +     isb();
> > +
> > +     /* See the comment in __kvm_tlb_flush_vmid_ipa() */
> > +     if (icache_is_vpipt())
> > +             icache_inval_all_pou();
> > +
> > +     __tlb_switch_to_host(&cxt);
>
> Another thing is that it is high time that some of this call gets
> refactored. All these helpers are basically the same sequence, only
> differing by a couple of lines. Not something we need to do
> immediately, but eventually we'll have to bite the bullet.
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
