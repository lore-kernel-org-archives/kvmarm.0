Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D70F6C43217
	for <kvmarm@archiver.kernel.org>; Tue, 10 May 2022 06:04:47 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9266A410DA;
	Tue, 10 May 2022 02:04:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4rZDBmDJQ+AU; Tue, 10 May 2022 02:04:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8A1C94B275;
	Tue, 10 May 2022 02:04:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CC0D949EF2
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 May 2022 17:27:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id W3IT6p0ib2AR for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 May 2022 17:27:08 -0400 (EDT)
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com
 [209.85.208.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 62BF149EF0
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 May 2022 17:27:08 -0400 (EDT)
Received: by mail-ed1-f49.google.com with SMTP id g20so17769701edw.6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 09 May 2022 14:27:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=0wI8fy4OzwxzyRjLG/BpgMXtWUTan7AaEmeWOc0KmU8=;
 b=XVUylxLfZr4wTBBAf53qguK656kMjGmwReylBuh+E19fjEmWr2h27UTdg1fI38RiGn
 8lwMbYHRGse1sNSQ6eC2rBYY+uitO09qRwa7vrzyBJU6WVbrEJb2FGlXd3yAg8cBRRK6
 Yih9tAUXZm3jXrv1iINzkAA+YWRBSxHUr0VPD0rPS3cMNIQ4fmlXLJtrEwEFOZlYoqMG
 +7tLyUxVNyXxrs6rOioILum49ZMJXe8wXbjni4a769F47yec1LP8gvAugGQhKSEM3WgF
 HVix7u8jQyc3SDDsuoS00kVZ8L482WHScY0XGcWlmorMWik7FT2DHxu1SFOa1mUeWDhm
 7LUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=0wI8fy4OzwxzyRjLG/BpgMXtWUTan7AaEmeWOc0KmU8=;
 b=bbrnTYItvZw2q8++lLaDOrp4UQPcdkNgiVeSa+/mt20CpJbZ6lLyBzRTZkr2CBDUnO
 +1CmA396ju2revAFhgbGpgb7yoreQwngRjbiahI4e/CdQny3C8BOwWOT34JrEl0VyDgs
 FJQhrHytBYEdI1qLUKzDIRicUfRc0KYUWSPyn2AWaEEINsQGfuTeQHno+31D+2wUPo5g
 Bm8qZ+LhtUydMkvkS2Sd9ibU6u7MLVYU+16k5qCEVQzk0gaMROiF8sPP28GJoA53ah7V
 kdI1bIONQ3RGgDytQNvRjSW8je8FIUZ4ZD790pPW3zQXeP6tBW/IuwcACta5U/ogmEbo
 J07w==
X-Gm-Message-State: AOAM530LriL3U9MndwOOt+Wij2VhM1pqiEJ8+NoEDbGIlblmyxJhCoES
 LP3RUqTl8Ee25wu5NxycX+FOqqlIMLSeE+HIVzyrNCq/cD4Mug==
X-Google-Smtp-Source: ABdhPJz9Vn1bR4LZrfiRLZV8AQMbZAt+0MKjbAL+S1RjonCsNbAqeb4YDyrtSSL4LLabggd1c9aq3rEOr8LOG2UZXuw=
X-Received: by 2002:a05:6512:1502:b0:474:28db:7b37 with SMTP id
 bq2-20020a056512150200b0047428db7b37mr4229039lfb.250.1652131616560; Mon, 09
 May 2022 14:26:56 -0700 (PDT)
MIME-Version: 1.0
References: <20220422210546.458943-1-dmatlack@google.com>
 <20220422210546.458943-12-dmatlack@google.com>
 <YnRerE5+FpwkUdQE@google.com>
In-Reply-To: <YnRerE5+FpwkUdQE@google.com>
From: David Matlack <dmatlack@google.com>
Date: Mon, 9 May 2022 14:26:29 -0700
Message-ID: <CALzav=de1=euis3WocTNBi+xNn1Ypo-GRROQNqmtAKk6q1NUqg@mail.gmail.com>
Subject: Re: [PATCH v4 11/20] KVM: x86/mmu: Allow for NULL vcpu pointer in
 __kvm_mmu_get_shadow_page()
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

On Thu, May 5, 2022 at 4:33 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Fri, Apr 22, 2022, David Matlack wrote:
> > Allow the vcpu pointer in __kvm_mmu_get_shadow_page() to be NULL. Rename
> > it to vcpu_or_null to prevent future commits from accidentally taking
> > dependency on it without first considering the NULL case.
> >
> > The vcpu pointer is only used for syncing indirect shadow pages in
> > kvm_mmu_find_shadow_page(). A vcpu pointer it not required for
> > correctness since unsync pages can simply be zapped. But this should
> > never occur in practice, since the only use-case for passing a NULL vCPU
> > pointer is eager page splitting which will only request direct shadow
> > pages (which can never be unsync).
> >
> > Even though __kvm_mmu_get_shadow_page() can gracefully handle a NULL
> > vcpu, add a WARN() that will fire if __kvm_mmu_get_shadow_page() is ever
> > called to get an indirect shadow page with a NULL vCPU pointer, since
> > zapping unsync SPs is a performance overhead that should be considered.
> >
> > Signed-off-by: David Matlack <dmatlack@google.com>
> > ---
> >  arch/x86/kvm/mmu/mmu.c | 40 ++++++++++++++++++++++++++++++++--------
> >  1 file changed, 32 insertions(+), 8 deletions(-)
> >
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 04029c01aebd..21407bd4435a 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -1845,16 +1845,27 @@ static void kvm_mmu_commit_zap_page(struct kvm *kvm,
> >         &(_kvm)->arch.mmu_page_hash[kvm_page_table_hashfn(_gfn)])     \
> >               if ((_sp)->gfn != (_gfn) || (_sp)->role.direct) {} else
> >
> > -static int kvm_sync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
> > -                      struct list_head *invalid_list)
> > +static int __kvm_sync_page(struct kvm *kvm, struct kvm_vcpu *vcpu_or_null,
> > +                        struct kvm_mmu_page *sp,
> > +                        struct list_head *invalid_list)
> >  {
> > -     int ret = vcpu->arch.mmu->sync_page(vcpu, sp);
> > +     int ret = -1;
> > +
> > +     if (vcpu_or_null)
>
> This should never happen.  I like the idea of warning early, but I really don't
> like that the WARN is far removed from the code that actually depends on @vcpu
> being non-NULL. Case in point, KVM should have bailed on the WARN and never
> reached this point.  And the inner __kvm_sync_page() is completely unnecessary.

Yeah that's fair.

>
> I also don't love the vcpu_or_null terminology; I get the intent, but it doesn't
> really help because understand why/when it's NULL.

Eh, I don't think it needs to encode why or when. It just needs to
flag to the reader (and future code authors) that this vcpu pointer
(unlike all other vcpu pointers in KVM) is NULL in certain cases.

>
> I played around with casting, e.g. to/from an unsigned long or void *, to prevent
> usage, but that doesn't work very well because 'unsigned long' ends up being
> awkward/confusing, and 'void *' is easily lost on a function call.  And both
> lose type safety :-(

Yet another shortcoming of C :(

(The other being our other discussion about the RET_PF* return codes
getting easily misinterpreted as KVM's magic return-to-user /
continue-running-guest return codes.)

Makes me miss Rust!

>
> All in all, I think I'd prefer this patch to simply be a KVM_BUG_ON() if
> kvm_mmu_find_shadow_page() encounters an unsync page.  Less churn, and IMO there's
> no real loss in robustness, e.g. we'd really have to screw up code review and
> testing to introduce a null vCPU pointer dereference in this code.

Agreed about moving the check here and dropping __kvm_sync_page(). But
I would prefer to retain the vcpu_or_null name (or at least something
other than "vcpu" to indicate there's something non-standard about
this pointer).

>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 3d102522804a..5aed9265f592 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -2041,6 +2041,13 @@ static struct kvm_mmu_page *kvm_mmu_find_shadow_page(struct kvm *kvm,
>                         goto out;
>
>                 if (sp->unsync) {
> +                       /*
> +                        * Getting indirect shadow pages without a vCPU pointer
> +                        * is not supported, i.e. this should never happen.
> +                        */
> +                       if (KVM_BUG_ON(!vcpu, kvm))
> +                               break;
> +
>                         /*
>                          * The page is good, but is stale.  kvm_sync_page does
>                          * get the latest guest state, but (unlike mmu_unsync_children)
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
