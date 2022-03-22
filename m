Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2D49C433EF
	for <kvmarm@archiver.kernel.org>; Wed, 23 Mar 2022 09:57:18 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0F01549F21;
	Wed, 23 Mar 2022 05:57:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id S0TuZTv9ETAz; Wed, 23 Mar 2022 05:57:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BA5C24A19A;
	Wed, 23 Mar 2022 05:57:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 64B2F49ED8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Mar 2022 14:30:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id P9U5CY0jbyO1 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Mar 2022 14:30:35 -0400 (EDT)
Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com
 [209.85.208.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2ABAD49ED2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Mar 2022 14:30:35 -0400 (EDT)
Received: by mail-lj1-f172.google.com with SMTP id q14so11865366ljc.12
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Mar 2022 11:30:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=0CNUQIx7db9tcPXPC9iqjrJoWI5B8XllhjqFE5N8sVg=;
 b=CF2Wkl42pAxFG3JegPzy0+/N/gpywxj733ZXOFng8/BIcG6njGR+YAz27HK7YLMvj9
 zFdMX8QKWmGj9CEYEZtyS8SpNQ4Mtndo7DHMJf3YeTeITeLH4DAFFiV4R3Rq5+9j1MSf
 i1dZwBk/3skV8dWO5LjqtEL+QB2F6rU3Gpf8GrAbcSjnfNBllAacDIuTnr9VWfbbybWF
 +YFtcLfSfvwrvRkkoUmCPF/Le7MHeh2uBzbt41SRv1S+WHTomhdlwsURFgIMwhpIVTig
 EbbgVuPNES+r8im5hJ1+nIuCQwBaowhiv3JT0WSWqhNY+UATI4uYOpIqu9cu9XxqPW/s
 I2Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=0CNUQIx7db9tcPXPC9iqjrJoWI5B8XllhjqFE5N8sVg=;
 b=lJ0TfK9fplI4AIlsBZgCgJr0/QStD+JcCCQ/CzzSnEGZ95qXekbd0KmzLCI6d0zUqK
 ksx3mJHHm/rK7M1fpLIEqoAUYNC+IHEt4HXvMsUX9kC3LcB+AZHR1MpaK3hbZ3ZolhVA
 Y2QK6A009xq65BcgAakTvjBjuuvnYFNaBdWIcFUY8/0moS5tJl5CNWjuXZeGK74PR6dL
 v2wb+sFLsKgftKvybSEVcGQM4KSU1MHqlq4Uhmvv7nd/ckpfJMQ1scQ3k3pFgw5ti1HF
 e9eHTELMwrfeVYtTo/lpat9aliCE9mfukOBWosnrEDko5j1zTDgDqnrhexgOqOzfZZWu
 u2Tg==
X-Gm-Message-State: AOAM5307Zqs/GFO4OY2i1+LDiXPX9TdrjJD7DpiddKTPpf8Efd+H1x1c
 Kh81eU8a+pzrraM0pgdSLlfzWy7zw6PaBhsVqI6URQ==
X-Google-Smtp-Source: ABdhPJyNKn6/OXQhxmGccGBHaz+yDflLiBEtNop/JRI2h4pzs1fJKVRhlCid5p3SD4A9PdS2WyGUl7n7vQSW1PqSoi4=
X-Received: by 2002:a2e:6804:0:b0:245:f269:618 with SMTP id
 c4-20020a2e6804000000b00245f2690618mr19192245lja.198.1647973833489; Tue, 22
 Mar 2022 11:30:33 -0700 (PDT)
MIME-Version: 1.0
References: <20220311002528.2230172-1-dmatlack@google.com>
 <20220311002528.2230172-4-dmatlack@google.com>
 <YjBLFZWtdfwhNosG@xz-m1.local>
In-Reply-To: <YjBLFZWtdfwhNosG@xz-m1.local>
From: David Matlack <dmatlack@google.com>
Date: Tue, 22 Mar 2022 11:30:07 -0700
Message-ID: <CALzav=dAW999FKid08Ry0YxPA+3Dt8HERrbn6YMkAnk0h+4h_A@mail.gmail.com>
Subject: Re: [PATCH v2 03/26] KVM: x86/mmu: Derive shadow MMU page role from
 parent
To: Peter Xu <peterx@redhat.com>
X-Mailman-Approved-At: Wed, 23 Mar 2022 05:57:13 -0400
Cc: Marc Zyngier <maz@kernel.org>, Albert Ou <aou@eecs.berkeley.edu>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <kvm@vger.kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <linux-mips@vger.kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Palmer Dabbelt <palmer@dabbelt.com>,
 "open list:KERNEL VIRTUAL MACHINE FOR RISC-V \(KVM/riscv\)"
 <kvm-riscv@lists.infradead.org>, Paul Walmsley <paul.walmsley@sifive.com>,
 Ben Gardon <bgardon@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
 "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 \(KVM/arm64\)"
 <kvmarm@lists.cs.columbia.edu>, Peter Feiner <pfeiner@google.com>
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

On Tue, Mar 15, 2022 at 1:15 AM Peter Xu <peterx@redhat.com> wrote:
>
> On Fri, Mar 11, 2022 at 12:25:05AM +0000, David Matlack wrote:
> > Instead of computing the shadow page role from scratch for every new
> > page, we can derive most of the information from the parent shadow page.
> > This avoids redundant calculations and reduces the number of parameters
> > to kvm_mmu_get_page().
> >
> > Preemptively split out the role calculation to a separate function for
> > use in a following commit.
> >
> > No functional change intended.
> >
> > Signed-off-by: David Matlack <dmatlack@google.com>
>
> Looks right..
>
> Reviewed-by: Peter Xu <peterx@redhat.com>
>
> Two more comments/questions below.
>
> > +static union kvm_mmu_page_role kvm_mmu_child_role(u64 *sptep, bool direct, u32 access)
> > +{
> > +     struct kvm_mmu_page *parent_sp = sptep_to_sp(sptep);
> > +     union kvm_mmu_page_role role;
> > +
> > +     role = parent_sp->role;
> > +     role.level--;
> > +     role.access = access;
> > +     role.direct = direct;
> > +
> > +     /*
> > +      * If the guest has 4-byte PTEs then that means it's using 32-bit,
> > +      * 2-level, non-PAE paging. KVM shadows such guests using 4 PAE page
> > +      * directories, each mapping 1/4 of the guest's linear address space
> > +      * (1GiB). The shadow pages for those 4 page directories are
> > +      * pre-allocated and assigned a separate quadrant in their role.
> > +      *
> > +      * Since we are allocating a child shadow page and there are only 2
> > +      * levels, this must be a PG_LEVEL_4K shadow page. Here the quadrant
> > +      * will either be 0 or 1 because it maps 1/2 of the address space mapped
> > +      * by the guest's PG_LEVEL_4K page table (or 4MiB huge page) that it
> > +      * is shadowing. In this case, the quadrant can be derived by the index
> > +      * of the SPTE that points to the new child shadow page in the page
> > +      * directory (parent_sp). Specifically, every 2 SPTEs in parent_sp
> > +      * shadow one half of a guest's page table (or 4MiB huge page) so the
> > +      * quadrant is just the parity of the index of the SPTE.
> > +      */
> > +     if (role.has_4_byte_gpte) {
> > +             BUG_ON(role.level != PG_LEVEL_4K);
> > +             role.quadrant = (sptep - parent_sp->spt) % 2;
> > +     }
>
> This made me wonder whether role.quadrant can be dropped, because it seems
> it can be calculated out of the box with has_4_byte_gpte, level and spte
> offset.  I could have missed something, though..

I think you're right that we could compute it on-the-fly. But it'd be
non-trivial to remove since it's currently used to ensure the sp->role
and sp->gfn uniquely identifies each shadow page (e.g. when checking
for collisions in the mmu_page_hash).

>
> > +
> > +     return role;
> > +}
> > +
> > +static struct kvm_mmu_page *kvm_mmu_get_child_sp(struct kvm_vcpu *vcpu,
> > +                                              u64 *sptep, gfn_t gfn,
> > +                                              bool direct, u32 access)
> > +{
> > +     union kvm_mmu_page_role role;
> > +
> > +     role = kvm_mmu_child_role(sptep, direct, access);
> > +     return kvm_mmu_get_page(vcpu, gfn, role);
>
> Nit: it looks nicer to just drop the temp var?
>
>         return kvm_mmu_get_page(vcpu, gfn,
>                                 kvm_mmu_child_role(sptep, direct, access));

Yeah that's simpler. I just have an aversion to line wrapping :)

>
> Thanks,
>
> --
> Peter Xu
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
