Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F9F7C433EF
	for <kvmarm@archiver.kernel.org>; Tue, 10 May 2022 06:04:49 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D5D2E4B210;
	Tue, 10 May 2022 02:04:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7DinCcRCZUqn; Tue, 10 May 2022 02:04:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BA7B84B2B4;
	Tue, 10 May 2022 02:04:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8B11349EBC
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 May 2022 17:30:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id P+-JBcR80U4f for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 May 2022 17:30:07 -0400 (EDT)
Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com
 [209.85.208.178])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4BE9A49EBB
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 May 2022 17:30:07 -0400 (EDT)
Received: by mail-lj1-f178.google.com with SMTP id q130so18588057ljb.5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 09 May 2022 14:30:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=MvwsQDLTKMJTgQOuZM3iVmxfL3yQn70yj6MptUuzyQ4=;
 b=KogQHf/McB9aIwAxL6BCyTJQgbxIayVYsDYOtKkeewIVQ3A710pUY39TcaMq8U+T88
 gv5ruaQ8w1yni6W7HlnAW1N5dHfHt1WakHv8tKw4thLTmjxF5UXYrTav0m+YNbRZNcVT
 +xVoGcPvGLNpEro0SP/zK6DkXhaiaFO9Y8/8D2b9GnaAOzzXtJ+VOxQ0//82acn4t0Vr
 EyNaOMSqCvxhgna4lq3UZ1jUYA59iu4tqGmRv5m5PnsaV+jRbOkS28/53sy/KiAk4Ce5
 91WjSvdmCd1bOkDfCR6jDhvHCuzTjEWGIYJ0Tf8aeQw5yq6MjnvQwk+dlbeoHl04Hrif
 5Wzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=MvwsQDLTKMJTgQOuZM3iVmxfL3yQn70yj6MptUuzyQ4=;
 b=4ofo1uSwBTaIns5o+CFAsxpLkWOHznB9pVe+f4aSlisj1nbVSaUf+R2r8Hyz5YP3R0
 Q9PPpWwiTeoMcpWNiIptV0sXhvLkkKlsNzKKAybyk78VPTFFsCje4vdUGB9V/4fyNOGK
 QP8JM/3jz6bs1fkwDoGyg6C6r8WzxmmmDyYm/HVj7Cc7nIrplVK5SSXvf7jW0ohfm3lt
 jSjmP2IIxOf/j7Y3keDIdVQjP9cPdXfi/luv39PtVmJXtCod2lDNkfhsc54hxYPYq/v7
 EoX7TwDwnydXL/b3c/F495ynNE4M5vgtvqXvMD41BmGDs0JxPVnK5QHACOdrhzIV7X0m
 NeBw==
X-Gm-Message-State: AOAM5315vSDR1yfNJ1U5G/6CBSyO15R72QU+8NFhnBs0z3RwYA1ngGB2
 XjTYyi1h/XkSefVjW/k+JTx18eUFfOJ1uC7LRmBTdg==
X-Google-Smtp-Source: ABdhPJx+6UQM4mLeHjKTgMzcIwGXK2jygDZun4KACvit/KIbJo02fyOw9JvUPx0VkZs/cp8bQ8Ty95f5uyusbVuZ7zI=
X-Received: by 2002:a2e:9e54:0:b0:250:d6c8:c2a6 with SMTP id
 g20-20020a2e9e54000000b00250d6c8c2a6mr830767ljk.16.1652131805713; Mon, 09 May
 2022 14:30:05 -0700 (PDT)
MIME-Version: 1.0
References: <20220422210546.458943-1-dmatlack@google.com>
 <20220422210546.458943-16-dmatlack@google.com>
 <Ynk84xydEn4/3xkT@google.com>
In-Reply-To: <Ynk84xydEn4/3xkT@google.com>
From: David Matlack <dmatlack@google.com>
Date: Mon, 9 May 2022 14:29:38 -0700
Message-ID: <CALzav=daCnHcUV7ffwvpMGcpdvV5vqHg0JD7Wfs-F6jfaJnfSA@mail.gmail.com>
Subject: Re: [PATCH v4 15/20] KVM: x86/mmu: Cache the access bits of shadowed
 translations
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

On Mon, May 9, 2022 at 9:10 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Fri, Apr 22, 2022, David Matlack wrote:
> > @@ -2820,7 +2861,10 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
> >
> >       if (!was_rmapped) {
> >               WARN_ON_ONCE(ret == RET_PF_SPURIOUS);
> > -             rmap_add(vcpu, slot, sptep, gfn);
> > +             rmap_add(vcpu, slot, sptep, gfn, pte_access);
> > +     } else {
> > +             /* Already rmapped but the pte_access bits may have changed. */
> > +             kvm_mmu_page_set_access(sp, sptep - sp->spt, pte_access);
> >       }
> >
> >       return ret;
>
> ...
>
> > diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
> > index a8a755e1561d..97bf53b29b88 100644
> > --- a/arch/x86/kvm/mmu/paging_tmpl.h
> > +++ b/arch/x86/kvm/mmu/paging_tmpl.h
> > @@ -978,7 +978,8 @@ static gpa_t FNAME(gva_to_gpa)(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
> >  }
> >
> >  /*
> > - * Using the cached information from sp->gfns is safe because:
> > + * Using the information in sp->shadowed_translation (kvm_mmu_page_get_gfn()
> > + * and kvm_mmu_page_get_access()) is safe because:
> >   * - The spte has a reference to the struct page, so the pfn for a given gfn
> >   *   can't change unless all sptes pointing to it are nuked first.
> >   *
> > @@ -1052,12 +1053,15 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
> >               if (sync_mmio_spte(vcpu, &sp->spt[i], gfn, pte_access))
> >                       continue;
> >
> > -             if (gfn != sp->gfns[i]) {
> > +             if (gfn != kvm_mmu_page_get_gfn(sp, i)) {
> >                       drop_spte(vcpu->kvm, &sp->spt[i]);
> >                       flush = true;
> >                       continue;
> >               }
> >
> > +             if (pte_access != kvm_mmu_page_get_access(sp, i))
>
> I think it makes sense to do this unconditionally, same as mmu_set_spte().  Or
> make the mmu_set_spte() case conditional.  I don't have a strong preference either
> way, but the two callers should be consistent with each other.

I'll make them both unconditional.

>
> > +                     kvm_mmu_page_set_access(sp, i, pte_access);
> > +
> >               sptep = &sp->spt[i];
> >               spte = *sptep;
> >               host_writable = spte & shadow_host_writable_mask;
> > --
> > 2.36.0.rc2.479.g8af0fa9b8e-goog
> >
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
