Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86E52C4332F
	for <kvmarm@archiver.kernel.org>; Tue, 17 May 2022 07:02:27 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F05AC4B2EA;
	Tue, 17 May 2022 03:02:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0VWGgyCD-0vq; Tue, 17 May 2022 03:02:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CC73F4B2A0;
	Tue, 17 May 2022 03:02:25 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 67B2249EBE
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 May 2022 17:38:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NicAQLHD7w84 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 May 2022 17:38:37 -0400 (EDT)
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com
 [209.85.167.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4675849EBB
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 May 2022 17:38:37 -0400 (EDT)
Received: by mail-lf1-f52.google.com with SMTP id d19so28080437lfj.4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 May 2022 14:38:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=RGRQiwR6nMDWdELQLZomuoHgNcB74pq7BSHN33rcyck=;
 b=IsfR/Ba8Lmb+VJH2OG0mIgzWKLWgJSZ7G3RtQlM9ozVeYj+IjPRW4gphkF+ePx5pPK
 /ARCnfbfKxB+CrmtIHAtVCy/macGC66sVlMQi2bYubo+LAEtIO2ur2X295UsCC4eOE7v
 82TwvhmCNXtTf3reKHYT8k0OGZeIsyEqRaJx26mbJ9PuGA9weeVgy1owjHYkgctW2uN4
 J04QlA82V/guPrOqw6heaj2eGWVasuQemmz6eps1IOJRq+16ntEJ8ldA2QCPV0k9PUqe
 +2W1gTouJaPx1cvAB/rQVOnqnr4Q4qGiHJtgvdFD2hP4wp1H9uXHLOnm7lsfl8f+cuQj
 zHVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=RGRQiwR6nMDWdELQLZomuoHgNcB74pq7BSHN33rcyck=;
 b=VQUQTNNIPvz+CxdQht4z2vyFZ8DPX2M0eY7oRzXjHlFM1fcbgnPi1UoKxCseG53J2X
 FHfQ5yYXLfrX7fNZyZCUYQvpPSr/EXY71I7SDDrjCVnHWuvhucKHnsJu+Z+3iMxqYS+a
 SLbB8tkIUyt22rrPZ59K47O3u86A+eCxIj3/arO4ypt8I9jt3sfoYOJByJ2bG04J8/Nk
 4DPDs2ejkLGQ3MkzmxBdyF7Q6KYOgfzIGfa9FYwKn2fZpsxfFRI24h2FT56OrdWrKKe1
 rS1tGVpIVaRvNC/PyobfK79M+WPd+d/lUbKb2/S9ZBv/hx+v30KBK29M3hmW7KlSFIbF
 Vsug==
X-Gm-Message-State: AOAM5323Zcd07SFKUy1Y/Lnwq6Gt2ttWtM7bOu+9HHR+K1eq0hDla/29
 /EIofKa9vyUyeZwNNtOH9eB9cyJqTIv/689cIP6aYA==
X-Google-Smtp-Source: ABdhPJzhERAS9lHQHB6Dz/Db29pEQFX1daKzVrhh48FjaZbwCqNewI9tJhfWv44RYQoQCBR3iXMGVI6TmcXJ2YsQ79g=
X-Received: by 2002:ac2:5399:0:b0:472:1f95:85df with SMTP id
 g25-20020ac25399000000b004721f9585dfmr14058450lfh.102.1652737115690; Mon, 16
 May 2022 14:38:35 -0700 (PDT)
MIME-Version: 1.0
References: <20220513202819.829591-1-dmatlack@google.com>
 <20220513202819.829591-4-dmatlack@google.com>
 <CAJhGHyAU_5Esn6i-eeBNKOh4XenOc9_1aiF8N0+CeMF5yyhxew@mail.gmail.com>
In-Reply-To: <CAJhGHyAU_5Esn6i-eeBNKOh4XenOc9_1aiF8N0+CeMF5yyhxew@mail.gmail.com>
From: David Matlack <dmatlack@google.com>
Date: Mon, 16 May 2022 14:38:09 -0700
Message-ID: <CALzav=cOS580FMr3zoDT+efYaBDSPSq+m84a1jQBv+jt3xvnqA@mail.gmail.com>
Subject: Re: [PATCH v5 03/21] KVM: x86/mmu: Derive shadow MMU page role from
 parent
To: Lai Jiangshan <jiangshanlai@gmail.com>
X-Mailman-Approved-At: Tue, 17 May 2022 03:02:25 -0400
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
 "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>,
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

On Sun, May 15, 2022 at 11:55 PM Lai Jiangshan <jiangshanlai@gmail.com> wrote:
>
> On Sat, May 14, 2022 at 4:28 AM David Matlack <dmatlack@google.com> wrote:
>
> > -static hpa_t mmu_alloc_root(struct kvm_vcpu *vcpu, gfn_t gfn, gva_t gva,
> > +static hpa_t mmu_alloc_root(struct kvm_vcpu *vcpu, gfn_t gfn, int quadrant,
> >                             u8 level, bool direct)
> >  {
> > +       union kvm_mmu_page_role role;
> >         struct kvm_mmu_page *sp;
> >
> > -       sp = kvm_mmu_get_page(vcpu, gfn, gva, level, direct, ACC_ALL);
> > +       role = vcpu->arch.mmu->root_role;
> > +       role.level = level;
> > +       role.direct = direct;
> > +       role.access = ACC_ALL;
> > +
> > +       if (role.has_4_byte_gpte)
> > +               role.quadrant = quadrant;
> > +
> > +       if (level <= vcpu->arch.mmu->cpu_role.base.level)
> > +               role.passthrough = 0;
> > +
>
>
>
> +       role.level = level;
> +
> +       if (role.has_4_byte_gpte)
> +               role.quadrant = quadrant;
>
> Only these lines are needed because of mmu->pae_root, others are
> the same as vcpu->arch.mmu->root_role.
>
> The argument @direct is vcpu->arch.mmu->root_role.direct.
> vcpu->arch.mmu->root_role.access is always set to be ACC_ALL.
>
> vcpu->arch.mmu->root_role.passthrough is 0 when mmu->pae_root is used.
> Or if vcpu->arch.mmu->root_role.passthrough is 1, @level must be 5
> and vcpu->arch.mmu->cpu_role.base.level must be 4, the code here
> is useless.

Ah, thank you for the tip. That is cleaner.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
