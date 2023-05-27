Received: from mail-il1-f175.google.com (mail-il1-f175.google.com [209.85.166.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F26A27E
	for <kvmarm@lists.linux.dev>; Sat, 27 May 2023 20:13:44 +0000 (UTC)
Received: by mail-il1-f175.google.com with SMTP id e9e14a558f8ab-33164ec77ccso110165ab.0
        for <kvmarm@lists.linux.dev>; Sat, 27 May 2023 13:13:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685218424; x=1687810424;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hK0j7POD8nRAsgGVVyJyo0UAU2zdW6aeJVN1+UjYElg=;
        b=QKnbpAkfLda1TvWrqaHzwSET9fcih+s5ib+TdEQpynJiDGgVyvcDWnq3f1jN8iSFFh
         i4wFHU4TObni6/73zZFM2D/pTSqgWk3+PPUYZMhIR48y37fhDEuDC9+d1+t2fRyrNgkr
         ayuCVtu0XYwZQdosz7e+wfHDnmUd/KZvqBq519Uy5lfqbbTbuuKK9L+bNXaHlLVwpoUG
         cBLrrDoSDWDEZ8OZLuLbQmUVgsGX8ts8KOPplFja+x5y6f4LRsCZW4nMJ6qgcp4bf8BG
         SEOtEkefIHI1t2fsfFozpr5n9BYz9LMkdnQOauJRbx9hSkM/0nH1fRNwjjqiDsKIVZLy
         cqTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685218424; x=1687810424;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hK0j7POD8nRAsgGVVyJyo0UAU2zdW6aeJVN1+UjYElg=;
        b=P1Q5sE3UWPPWuWbcAKjDSd7k2su2vdKqKEUNlwQV/E+HQk7M3xXvT4KI6v99qUCVtz
         bYKtIrUKJb5tHEKQPKCHRGC/cURdAIerBLbBOuH1Hn2MeUumoEm2DkFku+cf5OGYMNm0
         /D4Kzj+cs/WuazZ6LqoW53peT/SWWu1QW7f4Ipcr4peNshFKazq8HEdpHPEgjL7+BzEp
         tJKipzb35TcisaBjREAHTJQ5P3SJbNB15ENFX1crA0asJC4WUsOgucmYVchNigSEucS5
         hodNFOWfIf2+67rmJytr8Jl2BQ9RW5gH219keUryxDLC4xGHrQQpqCMGxEONkuV39TOF
         LK2g==
X-Gm-Message-State: AC+VfDxEOYJMlhFUSyJdrIU+CVYqb1sKLdz5NOHsLeAXJ0ytpcwCRdST
	MIP+65zG/B2e9/tsMYNRNbcuMAWpieDzQgx6Scsbhw==
X-Google-Smtp-Source: ACHHUZ5RLdNfCuhTMMzeLnK0AkjXh46hEGbQ5DPXaiuA4QGSm27lLMiJSKz6HarBK0wHhmVvVqcZAJpytCQ/s6idEUA=
X-Received: by 2002:a05:6e02:2185:b0:337:c9ec:4ca with SMTP id
 j5-20020a056e02218500b00337c9ec04camr138001ila.2.1685218423829; Sat, 27 May
 2023 13:13:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230526234435.662652-1-yuzhao@google.com> <20230526234435.662652-5-yuzhao@google.com>
 <ZHJHJPBF6euzOFdw@linux.dev>
In-Reply-To: <ZHJHJPBF6euzOFdw@linux.dev>
From: Yu Zhao <yuzhao@google.com>
Date: Sat, 27 May 2023 14:13:07 -0600
Message-ID: <CAOUHufa74CufHziHSquO5bZwbFXz2MNssBzW+AH7=Xo5RCnQ0A@mail.gmail.com>
Subject: Re: [PATCH mm-unstable v2 04/10] kvm/arm64: make stage2 page tables
 RCU safe
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Alistair Popple <apopple@nvidia.com>, Anup Patel <anup@brainfault.org>, 
	Ben Gardon <bgardon@google.com>, Borislav Petkov <bp@alien8.de>, 
	Catalin Marinas <catalin.marinas@arm.com>, Chao Peng <chao.p.peng@linux.intel.com>, 
	Christophe Leroy <christophe.leroy@csgroup.eu>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Fabiano Rosas <farosas@linux.ibm.com>, Gaosheng Cui <cuigaosheng1@huawei.com>, 
	Gavin Shan <gshan@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, 
	James Morse <james.morse@arm.com>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Michael Larabel <michael@michaellarabel.com>, 
	Mike Rapoport <rppt@kernel.org>, Nicholas Piggin <npiggin@gmail.com>, Paul Mackerras <paulus@ozlabs.org>, 
	Peter Xu <peterx@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Thomas Huth <thuth@redhat.com>, Will Deacon <will@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linuxppc-dev@lists.ozlabs.org, linux-trace-kernel@vger.kernel.org, 
	x86@kernel.org, linux-mm@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, May 27, 2023 at 12:08=E2=80=AFPM Oliver Upton <oliver.upton@linux.d=
ev> wrote:
>
> Yu,
>
> On Fri, May 26, 2023 at 05:44:29PM -0600, Yu Zhao wrote:
> > Stage2 page tables are currently not RCU safe against unmapping or VM
> > destruction. The previous mmu_notifier_ops members rely on
> > kvm->mmu_lock to synchronize with those operations.
> >
> > However, the new mmu_notifier_ops member test_clear_young() provides
> > a fast path that does not take kvm->mmu_lock. To implement
> > kvm_arch_test_clear_young() for that path, unmapped page tables need
> > to be freed by RCU and kvm_free_stage2_pgd() needs to be after
> > mmu_notifier_unregister().
> >
> > Remapping, specifically stage2_free_removed_table(), is already RCU
> > safe.
> >
> > Signed-off-by: Yu Zhao <yuzhao@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_pgtable.h |  2 ++
> >  arch/arm64/kvm/arm.c                 |  1 +
> >  arch/arm64/kvm/hyp/pgtable.c         |  8 ++++++--
> >  arch/arm64/kvm/mmu.c                 | 17 ++++++++++++++++-
> >  4 files changed, 25 insertions(+), 3 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/=
asm/kvm_pgtable.h
> > index ff520598b62c..5cab52e3a35f 100644
> > --- a/arch/arm64/include/asm/kvm_pgtable.h
> > +++ b/arch/arm64/include/asm/kvm_pgtable.h
> > @@ -153,6 +153,7 @@ static inline bool kvm_level_supports_block_mapping=
(u32 level)
> >   * @put_page:                        Decrement the refcount on a page.=
 When the
> >   *                           refcount reaches 0 the page is automatica=
lly
> >   *                           freed.
> > + * @put_page_rcu:            RCU variant of the above.
>
> You don't need to add yet another hook to implement this. I was working
> on lock-free walks in a separate context and arrived at the following:
>
> commit f82d264a37745e07ee28e116c336f139f681fd7f
> Author: Oliver Upton <oliver.upton@linux.dev>
> Date:   Mon May 1 08:53:37 2023 +0000
>
>     KVM: arm64: Consistently use free_removed_table() for stage-2
>
>     free_removed_table() is essential to the RCU-protected parallel walki=
ng
>     scheme, as behind the scenes the cleanup is deferred until an RCU gra=
ce
>     period. Nonetheless, the stage-2 unmap path calls put_page() directly=
,
>     which leads to table memory being freed inline with the table walk.
>
>     This is safe for the time being, as the stage-2 unmap walker is calle=
d
>     while holding the write lock. A future change to KVM will further rel=
ax
>     the locking mechanics around the stage-2 page tables to allow lock-fr=
ee
>     walkers protected only by RCU. As such, switch to the RCU-safe mechan=
ism
>     for freeing table memory.
>
>     Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
>
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index 3d61bd3e591d..bfbebdcb4ef0 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -1019,7 +1019,7 @@ static int stage2_unmap_walker(const struct kvm_pgt=
able_visit_ctx *ctx,
>                                                kvm_granule_size(ctx->leve=
l));
>
>         if (childp)
> -               mm_ops->put_page(childp);
> +               mm_ops->free_removed_table(childp, ctx->level);

Thanks, Oliver.

A couple of things I haven't had the chance to verify -- I'm hoping
you could help clarify:
1. For unmapping, with free_removed_table(), wouldn't we have to look
into the table we know it's empty unnecessarily?
2. For remapping and unmapping, how does free_removed_table() put the
final refcnt on the table passed in? (Previously we had
put_page(childp) in stage2_map_walk_table_post(). So I'm assuming we'd
have to do something equivalent with free_removed_table().)
