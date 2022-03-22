Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C74F1C433EF
	for <kvmarm@archiver.kernel.org>; Wed, 23 Mar 2022 09:57:23 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 668DB4A7FD;
	Wed, 23 Mar 2022 05:57:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8XNgagDuzinB; Wed, 23 Mar 2022 05:57:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5AB124B099;
	Wed, 23 Mar 2022 05:57:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C6AD549EDF
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Mar 2022 18:36:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id K18CAsUqHdzZ for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Mar 2022 18:36:05 -0400 (EDT)
Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com
 [209.85.208.177])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A749C49E44
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Mar 2022 18:36:05 -0400 (EDT)
Received: by mail-lj1-f177.google.com with SMTP id s25so25933375lji.5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Mar 2022 15:36:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=xOVVu/q0Ku1P/VW4cpKoWIMKe104EsaHhNWgjj4aCF8=;
 b=Y7qK379YZwjwJ93fuYIEVEDITu46iSrJOQ0tZ8SSc7IVS8czHo+MH4DJ7Pt7CL2biv
 GMjsHvy2T2x2DnT7OfrTkJ/sO5zmepZkjcXthCPZ4S9i4u64E9R4NOXDMYXHd5xJdO3a
 ahkV/xEP+lQEfsObo1RcXS1j/+oHAk5Z5+t01bDijgjmBhtKAhib6SUKp/zQZxG4XLPd
 nY5kbhVDTSTIFbGGM7tOW78wkSioZ/5SiaF2e2vzZ4kyh8DaZB9XrnkFb9KxGdW4Irty
 2fzpNLrPi8SnEn0OVzetEpoHsp6JrPqr2b9SACCkU3eSFZUiaZxL/5o/v/qMLVYzTDiF
 adTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=xOVVu/q0Ku1P/VW4cpKoWIMKe104EsaHhNWgjj4aCF8=;
 b=DPq2VqfkM4PVygrc++sFGnxX3sNu+6cSJpJgLxG2cD99p7vBAmNsIMEYD3vhZZtqWj
 fmP4aze1kuQud2CLmXWANHX6k4ZWHfzvWEisgaeTmodkwq7doTlscdmdK/qXfV+ZsQP0
 UjiyEzAzrtJaBhhCGu++PfTIhX7/LZvsUNDH2DB7Y8tq8mrSRlKvtYmUDutE8m4LopDZ
 flfdhlGpjl3gaBZ+GEX3Q6l0BBtt9IKRurFdwrxakKWCPa+iXYZamUZkgI81SDlLXyYE
 wu1GtxwJvp3JU/dvhJd/6wDwPHTBvmn8Qe7VVND7t6U1gDYtaghe0nv/YErpfqmH4JpT
 qw3Q==
X-Gm-Message-State: AOAM530mB/mei1EOkXfflFWUFPm/cw2gli8UAALX5QqNL4NNd6v+Jrrl
 m+wIjJhJ/53TsGuNnXeSaS4DQjv2CN8a2erDnF+t8A==
X-Google-Smtp-Source: ABdhPJwluBUdrQ3S0RKAvUXwpNmDB1zewZyw9nwYwRGoo/UMdP6fAUCPu5hPz027Wbt0/gETfLhJ81bzY9PXcrOyUew=
X-Received: by 2002:a2e:8255:0:b0:247:dff4:1f with SMTP id
 j21-20020a2e8255000000b00247dff4001fmr20990052ljh.16.1647988564022; 
 Tue, 22 Mar 2022 15:36:04 -0700 (PDT)
MIME-Version: 1.0
References: <20220311002528.2230172-1-dmatlack@google.com>
 <20220311002528.2230172-12-dmatlack@google.com>
 <YjBqAL+bPmcQpTgM@xz-m1.local>
In-Reply-To: <YjBqAL+bPmcQpTgM@xz-m1.local>
From: David Matlack <dmatlack@google.com>
Date: Tue, 22 Mar 2022 15:35:37 -0700
Message-ID: <CALzav=ehyvZiM-JH6gcZo_yw9R-T5mR18UQF_GecM-qZCQs=Uw@mail.gmail.com>
Subject: Re: [PATCH v2 11/26] KVM: x86/mmu: Use common code to allocate
 kvm_mmu_page structs from vCPU caches
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

On Tue, Mar 15, 2022 at 3:27 AM Peter Xu <peterx@redhat.com> wrote:
>
> On Fri, Mar 11, 2022 at 12:25:13AM +0000, David Matlack wrote:
> >  static struct kvm_mmu_page *tdp_mmu_alloc_sp(struct kvm_vcpu *vcpu)
> >  {
> > -     struct kvm_mmu_page *sp;
> > -
> > -     sp = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_page_header_cache);
> > -     sp->spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_shadow_page_cache);
> > -     set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
> > -
> > -     return sp;
> > +     return kvm_mmu_alloc_shadow_page(vcpu, true);
> >  }
>
> Similarly I had a feeling we could drop tdp_mmu_alloc_sp() too.. anyway:

Certainly, but I think it simplifies the TDP MMU code to keep it. It abstracts
away the implementation detail that a TDP MMU shadow page is allocated
the same way as a shadow MMU shadow page with direct=true.


>
> Reviewed-by: Peter Xu <peterx@redhat.com>
>
> --
> Peter Xu
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
