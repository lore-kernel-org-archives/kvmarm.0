Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B4C21D2FF
	for <kvmarm@lists.linux.dev>; Mon, 31 Jul 2023 18:02:05 +0000 (UTC)
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-40c72caec5cso31681cf.0
        for <kvmarm@lists.linux.dev>; Mon, 31 Jul 2023 11:02:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690826525; x=1691431325;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X0gCxxFfGpH7+EO1EgURYZAY2bdhrbnISyF1lBRoK6A=;
        b=qZXJd0+ffo+L4HQlrADJFOpNsrtneEkEjKGaCenKWHHQEco9dlSNxersD+gpofApiW
         o02MZh+LdJtBnpNbTaunNFo/yrUZVDlYroTi00ctwRDARSeVylQBSOGLLV6g3BPsFik1
         4KZESg4WwqRH2heMDI/gKOTA96YxqAHdeR6cwsxRS352/fhcTvniO25FMpqKBC+vkbG+
         7U3kQrA7UwBFicH5pD7tews8lYXa8aG2Rtx/WHVJ50zWYGSnD/DEpHGm5+dNWqrCjKzK
         vrB7i6HMlTdlHH7oSEErO/ezx1jdtNdTdwaGk/ao8HCv4z3XUdYfTfahIP4mt6yralea
         cWuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690826525; x=1691431325;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=X0gCxxFfGpH7+EO1EgURYZAY2bdhrbnISyF1lBRoK6A=;
        b=CCbq6CavTusEL8drR7/wjGUqf0SVnQPRdLFec4vZZoPwzvS8P1imwuBDIqwEdZ6z/A
         tr6VeNcC9FEO7gmU21ZfTdc/3GaBhSDBfmsVMNiJbg8gep2UDsHYk/TCVM4ytQmRPTFa
         PqUSOWLJ/mE6NL/5m5AxhDDNqC7mfZSnJmVkej2Rg/fqf1QHNFP+IWPolXt/TkHuc+by
         GWXYLeXS5rU7/4WWY2XSlEaRL/TWdOjL7f2aYxSdt39U+ILi+V7BLdam8SjvwxK6dpSi
         4qiP9BMkkOYL0bFcFgilvKX/z4WurijUng6klC69P4Uxubc98WC2XJebiXmvuk/Z8f59
         MNWw==
X-Gm-Message-State: ABy/qLYv/a98UMuLUbpJ3wt3OxkwxurloyNLi5dsbuEPN3/HnVku6VT3
	UpLxEhtI8p0z3VC4qyD8wpRxPfHrqvtBxunHinyuAQ==
X-Google-Smtp-Source: APBJJlEBpxAr+gWpuQ40S4Mxoz6DvPL1ZVwppPhat0hf9uVLuJsVRwWK349Eb3xEO5XCaxjIBjS+YDqgeGbyrEVO6AI=
X-Received: by 2002:a05:622a:104d:b0:403:9572:e37f with SMTP id
 f13-20020a05622a104d00b004039572e37fmr425212qte.22.1690826524611; Mon, 31 Jul
 2023 11:02:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230722022251.3446223-1-rananta@google.com> <20230722022251.3446223-9-rananta@google.com>
 <87o7jxr06t.wl-maz@kernel.org> <87lef1qzim.wl-maz@kernel.org>
In-Reply-To: <87lef1qzim.wl-maz@kernel.org>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Mon, 31 Jul 2023 11:01:53 -0700
Message-ID: <CAJHc60xC-Bs-0uoqkytDVcwHTxVnW7eyVxfHhO0mRrupVbdaYg@mail.gmail.com>
Subject: Re: [PATCH v7 08/12] KVM: arm64: Define kvm_tlb_flush_vmid_range()
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
	Gavin Shan <gshan@redhat.com>, Shaoqin Huang <shahuang@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 27, 2023 at 6:01=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrote=
:
>
> On Thu, 27 Jul 2023 13:47:06 +0100,
> Marc Zyngier <maz@kernel.org> wrote:
> >
> > On Sat, 22 Jul 2023 03:22:47 +0100,
> > Raghavendra Rao Ananta <rananta@google.com> wrote:
> > >
> > > Implement the helper kvm_tlb_flush_vmid_range() that acts
> > > as a wrapper for range-based TLB invalidations. For the
> > > given VMID, use the range-based TLBI instructions to do
> > > the job or fallback to invalidating all the TLB entries.
> > >
> > > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > > Reviewed-by: Gavin Shan <gshan@redhat.com>
> > > Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
> > > ---
> > >  arch/arm64/include/asm/kvm_pgtable.h | 10 ++++++++++
> > >  arch/arm64/kvm/hyp/pgtable.c         | 20 ++++++++++++++++++++
> > >  2 files changed, 30 insertions(+)
> > >
> > > diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/includ=
e/asm/kvm_pgtable.h
> > > index 8294a9a7e566..5e8b1ff07854 100644
> > > --- a/arch/arm64/include/asm/kvm_pgtable.h
> > > +++ b/arch/arm64/include/asm/kvm_pgtable.h
> > > @@ -754,4 +754,14 @@ enum kvm_pgtable_prot kvm_pgtable_stage2_pte_pro=
t(kvm_pte_t pte);
> > >   *    kvm_pgtable_prot format.
> > >   */
> > >  enum kvm_pgtable_prot kvm_pgtable_hyp_pte_prot(kvm_pte_t pte);
> > > +
> > > +/**
> > > + * kvm_tlb_flush_vmid_range() - Invalidate/flush a range of TLB entr=
ies
> > > + *
> > > + * @mmu:   Stage-2 KVM MMU struct
> > > + * @addr:  The base Intermediate physical address from which to inva=
lidate
> > > + * @size:  Size of the range from the base to invalidate
> > > + */
> > > +void kvm_tlb_flush_vmid_range(struct kvm_s2_mmu *mmu,
> > > +                           phys_addr_t addr, size_t size);
> > >  #endif     /* __ARM64_KVM_PGTABLE_H__ */
> > > diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtabl=
e.c
> > > index aa740a974e02..5d14d5d5819a 100644
> > > --- a/arch/arm64/kvm/hyp/pgtable.c
> > > +++ b/arch/arm64/kvm/hyp/pgtable.c
> > > @@ -670,6 +670,26 @@ static bool stage2_has_fwb(struct kvm_pgtable *p=
gt)
> > >     return !(pgt->flags & KVM_PGTABLE_S2_NOFWB);
> > >  }
> > >
> > > +void kvm_tlb_flush_vmid_range(struct kvm_s2_mmu *mmu,
> > > +                           phys_addr_t addr, size_t size)
> > > +{
> > > +   unsigned long pages, inval_pages;
> > > +
> > > +   if (!system_supports_tlb_range()) {
> > > +           kvm_call_hyp(__kvm_tlb_flush_vmid, mmu);
> > > +           return;
> > > +   }
> > > +
> > > +   pages =3D size >> PAGE_SHIFT;
> > > +   while (pages > 0) {
> > > +           inval_pages =3D min(pages, MAX_TLBI_RANGE_PAGES);
> > > +           kvm_call_hyp(__kvm_tlb_flush_vmid_range, mmu, addr, inval=
_pages);
> > > +
> > > +           addr +=3D inval_pages << PAGE_SHIFT;
> > > +           pages -=3D inval_pages;
> > > +   }
> > > +}
> > > +
> >
> > This really shouldn't live in pgtable.c. This code gets linked into
> > the EL2 object. What do you think happens if, for some reason, this
> > gets called *from EL2*?
>
> Ah, actually, nothing too bad would happen, as we convert the
> kvm_call_hyp() into a function call.
>
> But still, we don't need two copies of this stuff, and it can live in
> mmu.c.
>
But since we have a couple of references in pgtable.c to
kvm_tlb_flush_vmid_range(), wouldn't that be an (linking) issue if we
moved the definition to mmu.c?

ld: error: undefined symbol: __kvm_nvhe_kvm_tlb_flush_vmid_range
>>> referenced by pgtable.c:1148 (./arch/arm64/kvm/hyp/nvhe/../pgtable.c:11=
48)
>>>               arch/arm64/kvm/hyp/nvhe/kvm_nvhe.o:(__kvm_nvhe_kvm_pgtabl=
e_stage2_unmap) in archive vmlinux.a
...

Or is there some other way to make it work?

- Raghavendra

>         M.
>
> --
> Without deviation from the norm, progress is not possible.
