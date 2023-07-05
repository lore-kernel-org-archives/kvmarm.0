Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C733E14A8F
	for <kvmarm@lists.linux.dev>; Wed,  5 Jul 2023 18:28:30 +0000 (UTC)
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-4036bd4fff1so45071cf.0
        for <kvmarm@lists.linux.dev>; Wed, 05 Jul 2023 11:28:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1688581709; x=1691173709;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e8dndtCGBviDKso48620x/RRDlxyTnfI7vX9Z8Kirm4=;
        b=qHerNChH5eP9A1oGMa/u9oWkmuCgznM2HVxsH+LjQhf818ADYLHImqByT6aQXQhInT
         lsPnmURbNPO6fppcnuOnamesFjBJKNU2VjGsp7/zxpl38hCRF7pbMARmx/fH4RtrBMXV
         lQCBcftHQe7vy8FS1hGBIKM2SVaXZc1yMDHJKL+p6iFTBjybLHnCmhC3ptpPAjUBADqF
         3xClQ5mQkWbYUptl2dibTwnozlhBXkK1U0l3tZ6Z5T6JHE7q8ixwHU+MB8RFml50gCT1
         uyWFL1uZ2eGNwS7NmGPjVfeFoLHTmgcENG6AZUnGhL3wV09Qm91ASD61v7QtiUdM7Tit
         M5jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688581709; x=1691173709;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=e8dndtCGBviDKso48620x/RRDlxyTnfI7vX9Z8Kirm4=;
        b=k+5C1JHR1iWq1VnaKyKM3HgadqXO++UEjJgsY0Snf8uVDQlMt3YMObAqF0OyTKN2Ex
         BQxcJOLQcwsec1JtoWfzu1UsX7m+oIR4yBRcIM+HosWrkCCWTMYvq4uxG6avBi+5YfuF
         TcBU+Pd00dwG3LoW0/efxtZnkgm/6UqbPikr3WnqHPRyHnp0anjbiZNpBkYP5zyRyfoH
         VL1ZjDOzj5fTTJRnSqHns8XrajrJ9m5fEu1oyGzbvgjQaUhVFGnQXmoo8HQJ2NYtA0zf
         0/0X0cTntC2cBGsVn/tPU1l+6UmTdcbVnRY7MSIsvRP2FTMm39o+HDKpCLQm+wEwBa6F
         k/fw==
X-Gm-Message-State: ABy/qLbQDi8klm0ANL50JSftP1LIE0ospIj3/MSICoYMlDSIVwVRQNnd
	hjZ0BPKV7EmpSFj+1pSLUh/6SkhhyLT6XR6aLOCbYg==
X-Google-Smtp-Source: APBJJlGb5UHuGR9v4dIzL9FTRyvRdUi3B9fkgynBbnAtVZ2X8ICkvXAlrTkWscrnk/Iu+8sDpm99vm1xuq8baNEkTO8=
X-Received: by 2002:ac8:580b:0:b0:3ed:86f6:6eab with SMTP id
 g11-20020ac8580b000000b003ed86f66eabmr26383qtg.14.1688581709489; Wed, 05 Jul
 2023 11:28:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230621175002.2832640-1-rananta@google.com> <20230621175002.2832640-8-rananta@google.com>
 <1fe280a7-0f10-e124-00aa-b137df722c33@redhat.com>
In-Reply-To: <1fe280a7-0f10-e124-00aa-b137df722c33@redhat.com>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Wed, 5 Jul 2023 11:28:18 -0700
Message-ID: <CAJHc60xQtjvVsWRE=w-pAioNJW6uh-qKuZz2wp6bkT=X4oCm5A@mail.gmail.com>
Subject: Re: [RESEND PATCH v5 07/11] KVM: arm64: Define kvm_tlb_flush_vmid_range()
To: Gavin Shan <gshan@redhat.com>
Cc: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Huacai Chen <chenhuacai@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>, 
	Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
	Jing Zhang <jingzhangos@google.com>, Colton Lewis <coltonlewis@google.com>, 
	David Matlack <dmatlack@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-mips@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 4, 2023 at 5:31=E2=80=AFPM Gavin Shan <gshan@redhat.com> wrote:
>
>
> On 6/22/23 03:49, Raghavendra Rao Ananta wrote:
> > Implement the helper kvm_tlb_flush_vmid_range() that acts
> > as a wrapper for range-based TLB invalidations. For the
> > given VMID, use the range-based TLBI instructions to do
> > the job or fallback to invalidating all the TLB entries.
> >
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > ---
> >   arch/arm64/include/asm/kvm_pgtable.h | 10 ++++++++++
> >   arch/arm64/kvm/hyp/pgtable.c         | 20 ++++++++++++++++++++
> >   2 files changed, 30 insertions(+)
> >
>
> It may be reasonable to fold this to PATCH[08/11] since kvm_tlb_flush_vmi=
d_range() is
> only called by ARM64's kvm_arch_flush_remote_tlbs_range(), which is added=
 by PATCH[08/11].
> In either way, the changes look good to me:
>
Ah, the patches 10 and 11 also call kvm_tlb_flush_vmid_range(), so
probably it's better to keep the definition isolated?

Regards,
Raghavendra
> Reviewed-by: Gavin Shan <gshan@redhat.com>
>
> > diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/=
asm/kvm_pgtable.h
> > index 4cd6762bda805..1b12295a83595 100644
> > --- a/arch/arm64/include/asm/kvm_pgtable.h
> > +++ b/arch/arm64/include/asm/kvm_pgtable.h
> > @@ -682,4 +682,14 @@ enum kvm_pgtable_prot kvm_pgtable_stage2_pte_prot(=
kvm_pte_t pte);
> >    *     kvm_pgtable_prot format.
> >    */
> >   enum kvm_pgtable_prot kvm_pgtable_hyp_pte_prot(kvm_pte_t pte);
> > +
> > +/**
> > + * kvm_tlb_flush_vmid_range() - Invalidate/flush a range of TLB entrie=
s
> > + *
> > + * @mmu:     Stage-2 KVM MMU struct
> > + * @addr:    The base Intermediate physical address from which to inva=
lidate
> > + * @size:    Size of the range from the base to invalidate
> > + */
> > +void kvm_tlb_flush_vmid_range(struct kvm_s2_mmu *mmu,
> > +                             phys_addr_t addr, size_t size);
> >   #endif      /* __ARM64_KVM_PGTABLE_H__ */
> > diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.=
c
> > index 3d61bd3e591d2..df8ac14d9d3d4 100644
> > --- a/arch/arm64/kvm/hyp/pgtable.c
> > +++ b/arch/arm64/kvm/hyp/pgtable.c
> > @@ -631,6 +631,26 @@ static bool stage2_has_fwb(struct kvm_pgtable *pgt=
)
> >       return !(pgt->flags & KVM_PGTABLE_S2_NOFWB);
> >   }
> >
> > +void kvm_tlb_flush_vmid_range(struct kvm_s2_mmu *mmu,
> > +                             phys_addr_t addr, size_t size)
> > +{
> > +     unsigned long pages, inval_pages;
> > +
> > +     if (!system_supports_tlb_range()) {
> > +             kvm_call_hyp(__kvm_tlb_flush_vmid, mmu);
> > +             return;
> > +     }
> > +
> > +     pages =3D size >> PAGE_SHIFT;
> > +     while (pages > 0) {
> > +             inval_pages =3D min(pages, MAX_TLBI_RANGE_PAGES);
> > +             kvm_call_hyp(__kvm_tlb_flush_vmid_range, mmu, addr, inval=
_pages);
> > +
> > +             addr +=3D inval_pages << PAGE_SHIFT;
> > +             pages -=3D inval_pages;
> > +     }
> > +}
> > +
> >   #define KVM_S2_MEMATTR(pgt, attr) PAGE_S2_MEMATTR(attr, stage2_has_fw=
b(pgt))
> >
> >   static int stage2_set_prot_attr(struct kvm_pgtable *pgt, enum kvm_pgt=
able_prot prot,
>
> Thanks,
> Gavin
>
