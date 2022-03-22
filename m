Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 327B4C433F5
	for <kvmarm@archiver.kernel.org>; Wed, 23 Mar 2022 09:57:23 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E340349F04;
	Wed, 23 Mar 2022 05:57:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wRZULhSkzKjF; Wed, 23 Mar 2022 05:57:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 436594B091;
	Wed, 23 Mar 2022 05:57:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C38F8405AA
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Mar 2022 18:33:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id R0enuqu3EZxu for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Mar 2022 18:33:47 -0400 (EDT)
Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com
 [209.85.208.169])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A1C2E4012A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Mar 2022 18:33:47 -0400 (EDT)
Received: by mail-lj1-f169.google.com with SMTP id r22so25922484ljd.4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Mar 2022 15:33:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=S07AH0WG+avsPfFFCXY8ruiMhMyQ+txMHAKVZKwWZ2A=;
 b=Ng0nwZCHfZEOXPG+X8Pkkd1bBwYRJci6byKPVfO8KwVkFPEmh4d6JEu5kno4ppdDfb
 1RQSt98sr3n340+L4uIAp5gai8+EKW8VSgLRq3Dh0UnGflkTkuZ2sZc47297Pho+UquI
 kXDnPv+NeMCyPS0UhLu8H5+rWGv5jergWXzAgvq9C4KnJIY5Nc0yRUGQHGoJuSbQnUUe
 v/xhLLAGJhkGOVEar3pyS9crtf+PN7vJkCqTXvtyLTXVaVAe9Mmj+aVrqLsszya2DOva
 9mbVAhG8k75adaPiEGB198YWR+wIZIt/EDNNOdGBCY6odjFtePaKWLY/j2kg5fDdiOPR
 99Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=S07AH0WG+avsPfFFCXY8ruiMhMyQ+txMHAKVZKwWZ2A=;
 b=Z31Fjlm85t6VmcFXquncsCwSYeIE7rNofuaTnPmxy1Et7N5ShTG2d3xTCigh6vfQhv
 ZX66v4PulhkduZDWCiPIA2cKl9tYjqKNcPwunbb/avXD9BRJKmf+B2HX27YXaJGowbmi
 BIXyK2kxAQEyIIMBC0xf5enOzaABU1e2aVVfmX1x0w5qqC25CQbDUJpoxNvh7SMOc0EG
 wO8XAusgymRgFqRGjrEGs5LY78NU+Nw+k9aJna2KWV48ZY8VlBwy0aVOcDnXcADJsCG4
 BjIbOq0ntFr4V0Oc98spkK00wA5JGeuQuIjSL88HpNYvCkgwwArIiMNZTZ6De5t4ApPg
 docA==
X-Gm-Message-State: AOAM532vFz440Q2DGBLfyV64SIzpCNDsAp3Yln/6Opm4Kv1DSgVUocAv
 RiKQAOsCyTcyME99kNIczF2uyg9Y5ob6+KaKbQbjJA==
X-Google-Smtp-Source: ABdhPJworeA778z1gBXZTTzxjh4xsrDQFhXkFHaqJJL/0AKV8N60E1I4tQX6QbLoILy+wNmtvlVaubKG+aPV7dB41VU=
X-Received: by 2002:a2e:9119:0:b0:247:e306:1379 with SMTP id
 m25-20020a2e9119000000b00247e3061379mr20396060ljg.361.1647988425050; Tue, 22
 Mar 2022 15:33:45 -0700 (PDT)
MIME-Version: 1.0
References: <20220311002528.2230172-1-dmatlack@google.com>
 <20220311002528.2230172-11-dmatlack@google.com>
 <YjBo9iuSBm1hbqXz@xz-m1.local>
In-Reply-To: <YjBo9iuSBm1hbqXz@xz-m1.local>
From: David Matlack <dmatlack@google.com>
Date: Tue, 22 Mar 2022 15:33:18 -0700
Message-ID: <CALzav=fPeXcKbrdguPKBt13awjPt3+3AB_2hBWo_M9U9sKinWw@mail.gmail.com>
Subject: Re: [PATCH v2 10/26] KVM: x86/mmu: Use common code to free
 kvm_mmu_page structs
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

On Tue, Mar 15, 2022 at 3:23 AM Peter Xu <peterx@redhat.com> wrote:
>
> On Fri, Mar 11, 2022 at 12:25:12AM +0000, David Matlack wrote:
> >  static void tdp_mmu_free_sp(struct kvm_mmu_page *sp)
> >  {
> > -     free_page((unsigned long)sp->spt);
> > -     kmem_cache_free(mmu_page_header_cache, sp);
> > +     kvm_mmu_free_shadow_page(sp);
> >  }
>
> Perhaps tdp_mmu_free_sp() can be dropped altogether with this?

It certainly can but I prefer to keep it for 2 reasons:
 - Smaller diff.
 - It mirrors tdp_mmu_alloc_sp(), which I prefer to keep as well but
I'll explain that in the next patch.

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
