Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67C9AC433EF
	for <kvmarm@archiver.kernel.org>; Wed, 23 Mar 2022 09:57:25 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2197249F44;
	Wed, 23 Mar 2022 05:57:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Fv09b2HkCfti; Wed, 23 Mar 2022 05:57:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8BA6549F5F;
	Wed, 23 Mar 2022 05:57:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 246914086C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Mar 2022 19:08:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id poomfIGXNTVT for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Mar 2022 19:08:37 -0400 (EDT)
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com
 [209.85.167.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 094FB40797
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Mar 2022 19:08:36 -0400 (EDT)
Received: by mail-lf1-f47.google.com with SMTP id bu29so32372824lfb.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Mar 2022 16:08:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=mTTFE/78fuZDPiUjjJj3Ss+v6yYociVg/54x3WiDppI=;
 b=AtUMJgZ9t0Fiz5REAj00cuT2GhuBOVgcleoPH33KuSiD6KinBWwOwkTJUkr9PsgxDN
 TyDPGlBdULNNbsjEeWOukk/bVG7/QNX0CG1Sr3YVimBK2RTwFt9JEwHuXd89blOchI4O
 vwbvArTGQ9IPaoj9TTK+fhuX+VGfQF2u2DCC4WrtNhILbnJociZ7w1dQlFqaV2j0vf7n
 svQP5H4o/8R/VNvsQakatJxIytdbL7IJ3QIgcAEtDTHuN21fPSlb4cnYK4zu1p6CpS65
 YZFFJjFNFeCVNR5eCWbIo5vple/iraGnKrEDxh5nxpkupBxwR6jz94TEofxga2vrX8Dr
 RtoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=mTTFE/78fuZDPiUjjJj3Ss+v6yYociVg/54x3WiDppI=;
 b=Tse1lyDFFmWObJUmOFhvwsReP2/SAkjitd+LGWAFOWQWADqPlBsaHv1F3OKvkOqLAp
 vYCUexxrskl9X+Bof8N/JfcXeYPA1yqMBnSrzm1GKo/Txo+b+kLEC10m/+5EqlDINz6w
 pfGNvh9J7XPSsGAlumQttqg/aqobQ2fS0jQ/7Sn4PVLREEsNvsfS6ihne/72ZeJGYsQ5
 M32vG7csQaCBRSQEkyy+BDhgvPKyKU4wuPhe1TsLBNurgDa0WPTuGO1tGCC3bmAD5qQf
 lR5pyKBsKe0APK3iEaD24/Js2GTQ2n2yIZ5MKQoRZ1LTs/OsoVb6L3lffmE6gOrCWSzK
 9FcQ==
X-Gm-Message-State: AOAM533BOgWPW8PN2YnAq1g8kLnxh2CIFIMux3UgLvt7jVXHhjkoWFM/
 S6cUg1EyOtyPF1Nw/2uRfa/qSp3T3j0fTTrJaBVWmg==
X-Google-Smtp-Source: ABdhPJwvtLvpn2H6Z4lJn9F/iyZNFskD3MwkoE6H+EfWq/OlKZPPiQcbGScUEqtawLL0W5MBlHCvFgFE+wVkBkGa91U=
X-Received: by 2002:a19:674c:0:b0:448:3f49:e6d5 with SMTP id
 e12-20020a19674c000000b004483f49e6d5mr20032193lfj.518.1647990514538; Tue, 22
 Mar 2022 16:08:34 -0700 (PDT)
MIME-Version: 1.0
References: <20220311002528.2230172-1-dmatlack@google.com>
 <20220311002528.2230172-18-dmatlack@google.com>
 <YjGjWcmn+7sZPjNX@xz-m1.local>
In-Reply-To: <YjGjWcmn+7sZPjNX@xz-m1.local>
From: David Matlack <dmatlack@google.com>
Date: Tue, 22 Mar 2022 16:08:08 -0700
Message-ID: <CALzav=d1j-SUFEauqrQaJ5gE89ybSdW3OWnmdsaA6iADVnQfjA@mail.gmail.com>
Subject: Re: [PATCH v2 17/26] KVM: x86/mmu: Pass access information to
 make_huge_page_split_spte()
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

On Wed, Mar 16, 2022 at 1:44 AM Peter Xu <peterx@redhat.com> wrote:
>
> On Fri, Mar 11, 2022 at 12:25:19AM +0000, David Matlack wrote:
> > diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> > index 85b7bc333302..541b145b2df2 100644
> > --- a/arch/x86/kvm/mmu/tdp_mmu.c
> > +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> > @@ -1430,7 +1430,7 @@ static int tdp_mmu_split_huge_page(struct kvm *kvm, struct tdp_iter *iter,
> >        * not been linked in yet and thus is not reachable from any other CPU.
> >        */
> >       for (i = 0; i < PT64_ENT_PER_PAGE; i++)
> > -             sp->spt[i] = make_huge_page_split_spte(huge_spte, level, i);
> > +             sp->spt[i] = make_huge_page_split_spte(huge_spte, level, i, ACC_ALL);
>
> Pure question: is it possible that huge_spte is RO while we passed in
> ACC_ALL here (which has the write bit set)?

Yes that is possible, but only if KVM the page is RO due to host-side
policies (e.g. RO memslot or RO VMA). "access" here is the
guest-allowed access permissions, similar to the pte_access parameter
to mmu_set_spte(). e.g. notice how the TDP MMU passes ACC_ALL to
make_spte().

> Would it be better if we make it a "bool exec" to be clearer?

But all that being said, the ACC_ALL stuff is confusing for exactly
the reason you pointed out so it doesn't make sense to duplicate it
further. I agree it would make more sense to pass in bool exec.

>
> --
> Peter Xu
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
