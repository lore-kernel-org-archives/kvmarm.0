Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D70CAC433FE
	for <kvmarm@archiver.kernel.org>; Tue, 10 May 2022 06:04:47 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 877424B20A;
	Tue, 10 May 2022 02:04:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id DHisuf7WXa7E; Tue, 10 May 2022 02:04:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A17914B29C;
	Tue, 10 May 2022 02:04:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E195949F01
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 May 2022 17:28:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1pTWxljguHIu for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 May 2022 17:28:14 -0400 (EDT)
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com
 [209.85.167.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DF8DB49EF2
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 May 2022 17:28:13 -0400 (EDT)
Received: by mail-lf1-f45.google.com with SMTP id y32so26046732lfa.6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 09 May 2022 14:28:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=lLXDpS9aIKv2BOfm7qGe20v7/h2Jmvrj+hyHCut5ohw=;
 b=oyNullodeqUuuE421QfGbnwxO+DFaD2869iT7IedC61l5rZttPc/rSSzE78vqgW1qc
 /yDSeSm/xObDW0SQYPjuLw/oabxydsD1u1pqk6iDs+C4RePn/EBKPD26MXSn/Bqau+vE
 0vOQ0geMRnQRwNm4gtwQvXfhzE5wxzP2IR9rDPAfNyK+lM2iV9Bq1y9YKNHQPxElg7dK
 HLSVmL0ZsXbI6xxQJD5n9kbgUSl73kAzVVOPO5r4rxxie5OCXNJsiaS4Mk11+iplA7nS
 pCdRT/tZG9CzS1KAbQLLw6d11fWTcP/PbyYKjlJt8m4+EMQMD/pL6baQwgIfp/nZSGYH
 OVEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=lLXDpS9aIKv2BOfm7qGe20v7/h2Jmvrj+hyHCut5ohw=;
 b=3z3LCW5SWnXy7j/TisVbxuGH2ivtiUIJrVHI/1BCw/1k/AIjYg1VlNMtED8S9mPAUw
 wuM4AduaGcMGqhr59fBosl8RYTW9S05dpX2CUpfBehtD9q25bUiqwDfEBEbEQE11cOjM
 L9JQhzIPk0gJ1iljRgwC7lwKNhqZi5MXpF2TOwa+NDgprTZdGZN2EDYgJwmYji5pkYWe
 1sCkb/TLHeVtacz7LPTdt6sCvs0GyHd0Jml5MCk52SFAY2P9bxMGoPraiv5qXGM2C06d
 6xpTl/i5xaUXdDZovdZxOwqe8XBMerpv3XvHqRcM3DdxpNgzq6boi9aoFIJ3S3fPQuT9
 KtFg==
X-Gm-Message-State: AOAM530CWELHNbSCePvfSNVoi9pVo7usatLE3jlDb+74Cc7jw1WfCVHL
 fgBXaoSHSMl1dTEPwCJ1DccG1RKWdndhV2F6YJGeMg==
X-Google-Smtp-Source: ABdhPJw+OcXl75VxXUJHRSc/tzKR8oEQPG36TfGqgX3Q27P6+ehDBJMpPmSmVmU2xY3hI4g12NO5ncUZ1l7YDKxM7wo=
X-Received: by 2002:ac2:4c54:0:b0:473:a414:1768 with SMTP id
 o20-20020ac24c54000000b00473a4141768mr13960522lfk.537.1652131692052; Mon, 09
 May 2022 14:28:12 -0700 (PDT)
MIME-Version: 1.0
References: <20220422210546.458943-1-dmatlack@google.com>
 <20220422210546.458943-14-dmatlack@google.com>
 <YnRh6yyGQZ+U31U1@google.com>
In-Reply-To: <YnRh6yyGQZ+U31U1@google.com>
From: David Matlack <dmatlack@google.com>
Date: Mon, 9 May 2022 14:27:45 -0700
Message-ID: <CALzav=fSx2VdaLD=pz_wmESCSA8M0n1omLsy9UwSw1GHED7vgQ@mail.gmail.com>
Subject: Re: [PATCH v4 13/20] KVM: x86/mmu: Decouple rmap_add() and
 link_shadow_page() from kvm_vcpu
To: Sean Christopherson <seanjc@google.com>
X-Mailman-Approved-At: Tue, 10 May 2022 02:04:42 -0400
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

On Thu, May 5, 2022 at 4:46 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Fri, Apr 22, 2022, David Matlack wrote:
> > -static void link_shadow_page(struct kvm_vcpu *vcpu, u64 *sptep,
> > -                          struct kvm_mmu_page *sp)
> > +static void __link_shadow_page(struct kvm_mmu_memory_cache *cache, u64 *sptep,
> > +                            struct kvm_mmu_page *sp)
> >  {
> >       u64 spte;
> >
> > @@ -2297,12 +2300,17 @@ static void link_shadow_page(struct kvm_vcpu *vcpu, u64 *sptep,
> >
> >       mmu_spte_set(sptep, spte);
> >
> > -     mmu_page_add_parent_pte(vcpu, sp, sptep);
> > +     mmu_page_add_parent_pte(cache, sp, sptep);
> >
> >       if (sp->unsync_children || sp->unsync)
> >               mark_unsync(sptep);
> >  }
> >
> > +static void link_shadow_page(struct kvm_vcpu *vcpu, u64 *sptep, struct kvm_mmu_page *sp)
>
> Nit, would prefer to wrap here, especially since __link_shadow_page() wraps.

Will do.

>
> > +{
> > +     __link_shadow_page(&vcpu->arch.mmu_pte_list_desc_cache, sptep, sp);
> > +}
> > +
> >  static void validate_direct_spte(struct kvm_vcpu *vcpu, u64 *sptep,
> >                                  unsigned direct_access)
> >  {
> > --
> > 2.36.0.rc2.479.g8af0fa9b8e-goog
> >
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
