Received: from mail-il1-f174.google.com (mail-il1-f174.google.com [209.85.166.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 764571DDCA
	for <kvmarm@lists.linux.dev>; Mon, 31 Jul 2023 18:26:22 +0000 (UTC)
Received: by mail-il1-f174.google.com with SMTP id e9e14a558f8ab-3490b737f9aso14095ab.0
        for <kvmarm@lists.linux.dev>; Mon, 31 Jul 2023 11:26:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690827981; x=1691432781;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6LZEdaDlAMdQP6JhmjsArIuxox1zxEtjjTY2SzD6PsU=;
        b=5fgkkTfZTjvrkPsV2OAsWS7fGDKlkOo6NBkGxlUad6Djf9YF4mNXTcZwmQCCLJ1nBy
         ytvPZa3KoE6pLMDaS1L4gdmZaOfNzKXtsa1fikLeZSNL0jSNWYpUTY8GHiEMpPSUIhEf
         GKZr2wZjg6oExHWyVPblSGkoydBcnRJu278I6bHizaXll85ZaXfkAb9ISQ34veJLXVin
         H4LgRU66ITkpG1C45xmAlPZe5ifFrojIcI163nCjGKu3BAHmTrdfA2g91PJ4XmMzNAwE
         6qNdJbd/ZgVe0FTRRBae2q8TCC7NnJ6KmTDr6JnJgqJf5rkyLUFJCut3v7Lu9kIPHxwj
         tGnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690827981; x=1691432781;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6LZEdaDlAMdQP6JhmjsArIuxox1zxEtjjTY2SzD6PsU=;
        b=A4psQXNvJ7MAHtsxo/ljbKJCAa7vRi5y5ryNPrLznmDBqOBUu6r55qpSez4HOps7x4
         VTw5847zfdPDtMH1WO+ALIpps0nKFbGK/cVxllgDmzEXOZCuemhMvlGtHrZFGL1Vzt2v
         kkuQyV2isaLEidogVB7pRKHh4JF5ESNO61mBNvV5//5W5i7FQZMkximpgu16ZPXxZvWB
         BFEU23rYQyf6eLlg7YuN5ghjxtdNLT4dTx/m8Ey/g0LUIBlIfF4B3Fx9pZGcPgus+lpn
         pwHEYMKWSa7crQ3uQUcuZw65NKdUEoHsXqV5SYaGz84Byv7iTOh1VXFu5s1T0vU9s+gq
         N6GQ==
X-Gm-Message-State: ABy/qLbowXGsroR1ldB4Diu64qs6pV3Tl60sjW3TfE28T1NI0oFQSuSD
	RN6F2MzVRgvtAuR1F7rQ55zvLhEaq/iUKz76vIhTaw==
X-Google-Smtp-Source: APBJJlHJ2q+Ibhsyd21GC77gr96XZana1MhNnQDJBDO6Init3JyGxBHBc9FYe6705xtGHxT1vNNwqYdqSlhzUk4wwtA=
X-Received: by 2002:a05:6e02:16c5:b0:345:dcdf:206b with SMTP id
 5-20020a056e0216c500b00345dcdf206bmr693992ilx.25.1690827981339; Mon, 31 Jul
 2023 11:26:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230722022251.3446223-1-rananta@google.com> <20230722022251.3446223-13-rananta@google.com>
 <87jzulqz0v.wl-maz@kernel.org>
In-Reply-To: <87jzulqz0v.wl-maz@kernel.org>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Mon, 31 Jul 2023 11:26:09 -0700
Message-ID: <CAJHc60zGzAqWw2iZwNEG_bWERXkz_io7ae-K_tf_kh6xcOBxLA@mail.gmail.com>
Subject: Re: [PATCH v7 12/12] KVM: arm64: Use TLBI range-based intructions for unmap
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
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 27, 2023 at 6:12=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrote=
:
>
> On Sat, 22 Jul 2023 03:22:51 +0100,
> Raghavendra Rao Ananta <rananta@google.com> wrote:
> >
> > The current implementation of the stage-2 unmap walker traverses
> > the given range and, as a part of break-before-make, performs
> > TLB invalidations with a DSB for every PTE. A multitude of this
> > combination could cause a performance bottleneck on some systems.
> >
> > Hence, if the system supports FEAT_TLBIRANGE, defer the TLB
> > invalidations until the entire walk is finished, and then
> > use range-based instructions to invalidate the TLBs in one go.
> > Condition deferred TLB invalidation on the system supporting FWB,
> > as the optimization is entirely pointless when the unmap walker
> > needs to perform CMOs.
> >
> > Rename stage2_put_pte() to stage2_unmap_put_pte() as the function
> > now serves the stage-2 unmap walker specifically, rather than
> > acting generic.
> >
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > ---
> >  arch/arm64/kvm/hyp/pgtable.c | 67 +++++++++++++++++++++++++++++++-----
> >  1 file changed, 58 insertions(+), 9 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.=
c
> > index 5ef098af1736..cf88933a2ea0 100644
> > --- a/arch/arm64/kvm/hyp/pgtable.c
> > +++ b/arch/arm64/kvm/hyp/pgtable.c
> > @@ -831,16 +831,54 @@ static void stage2_make_pte(const struct kvm_pgta=
ble_visit_ctx *ctx, kvm_pte_t n
> >       smp_store_release(ctx->ptep, new);
> >  }
> >
> > -static void stage2_put_pte(const struct kvm_pgtable_visit_ctx *ctx, st=
ruct kvm_s2_mmu *mmu,
> > -                        struct kvm_pgtable_mm_ops *mm_ops)
> > +struct stage2_unmap_data {
> > +     struct kvm_pgtable *pgt;
> > +     bool defer_tlb_flush_init;
> > +};
> > +
> > +static bool __stage2_unmap_defer_tlb_flush(struct kvm_pgtable *pgt)
> > +{
> > +     /*
> > +      * If FEAT_TLBIRANGE is implemented, defer the individual
> > +      * TLB invalidations until the entire walk is finished, and
> > +      * then use the range-based TLBI instructions to do the
> > +      * invalidations. Condition deferred TLB invalidation on the
> > +      * system supporting FWB, as the optimization is entirely
> > +      * pointless when the unmap walker needs to perform CMOs.
> > +      */
> > +     return system_supports_tlb_range() && stage2_has_fwb(pgt);
> > +}
> > +
> > +static bool stage2_unmap_defer_tlb_flush(struct stage2_unmap_data *unm=
ap_data)
> > +{
> > +     bool defer_tlb_flush =3D __stage2_unmap_defer_tlb_flush(unmap_dat=
a->pgt);
> > +
> > +     /*
> > +      * Since __stage2_unmap_defer_tlb_flush() is based on alternative
> > +      * patching and the TLBIs' operations behavior depend on this,
> > +      * track if there's any change in the state during the unmap sequ=
ence.
> > +      */
> > +     WARN_ON(unmap_data->defer_tlb_flush_init !=3D defer_tlb_flush);
> > +     return defer_tlb_flush;
>
> I really don't understand what you're testing here. The ability to
> defer TLB invalidation is a function of the system capabilities
> (range+FWB) and a single flag that is only set on the host for pKVM.
>
> How could that change in the middle of the life of the system? if
> further begs the question about the need for the unmap_data data
> structure.
>
> It looks to me that we could simply pass the pgt pointer around and be
> done with it. Am I missing something obvious?
>
From one of the previous comments [1] (used in a different context),
I'm given to understand that since these feature checks are governed
by alternative patching, they can potentially change (at runtime?). Is
that not the case and I have misunderstood the idea in comment [1]
entirely? Is it solely used for optimization purposes and set only
once?
If that's the case, I can get rid of the WARN_ON() and unmap_data.

- Raghavendra

[1]: https://lore.kernel.org/all/ZGPPj1AXS0Uah2Ug@linux.dev/
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
