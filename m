Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 048C3C433F5
	for <kvmarm@archiver.kernel.org>; Tue, 19 Apr 2022 03:01:49 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4207249F3D;
	Mon, 18 Apr 2022 23:01:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 19T1W+5IbT6k; Mon, 18 Apr 2022 23:01:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3F2D14B0D6;
	Mon, 18 Apr 2022 23:01:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 678C749E43
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Apr 2022 23:01:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id onrn8+qwlFcL for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Apr 2022 23:01:46 -0400 (EDT)
Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com
 [209.85.208.180])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4D1B940BED
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Apr 2022 23:01:46 -0400 (EDT)
Received: by mail-lj1-f180.google.com with SMTP id o16so18901837ljp.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Apr 2022 20:01:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=KOKDemPG9w5pDIt9lxbcT1h2mNUqVQt2NYUz527H2FM=;
 b=BRVG64HEdUJe/6BxS9eFWGfdYcAnVqQxHDLB5x6yMtfpBCKh/6ZuT+HUdUAiOw6e4p
 O7F/hzLQ7OqSjmSKw+eZ+4Yynmg4nWZ3/hd/iNb2JAU+2vC1aa/A9dO1T3UNs8PF/kR0
 zZQLoaS86IcjcU8jGetyCvpA6p14dwTtRNdQGhZsYsqtnTD9pA58WuqvJ+PfMQOWguA0
 aOXFJeoAYAkZnPNaLW+dFQA7TK0wdnkIiq95yBduGVBtxirNX2rDBPweEgLz23uxKP/f
 01xCaMc/XwsiUSG8SZKg2qFFuRt2yOPtZix+OFvlM/Z7W/fFJemymVb3k0Sqp/ZVW3t6
 GYbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=KOKDemPG9w5pDIt9lxbcT1h2mNUqVQt2NYUz527H2FM=;
 b=rNPP0QbbLfkx98UnglwPb+V8o9d84OlwmCrN3dhpgfT0KSlT+XrXul709Sbgb/6XRJ
 q3EApnOZL0GXGYACvr+dEGW4mJBh4BT081dd2Mm6BM+hwqYMyU0Us5rnjP4H82DsW1zQ
 mZLQCDkD+InqMhODwTvh3VXSbqYWoyURl5gpKb3XKkokyv0OwgznP321My8U9/7b2RqW
 apqA9LidotViS2l9NCt2JuJkV+gFyU55EM+rSm8zlmwCftqwMDm5ysMFaWKVGJXVvTnh
 iLtcEHuxAfKECddeR8OPAu8KarVtV33ZQVCS0+LU+HazJ9hULE6w51ksA7bkraqX/E2N
 wlFw==
X-Gm-Message-State: AOAM5324Tb5IvHHLhZwqMYpBLQNtLSm54OgJe0sS6hVbik3JptyEtM8e
 T9FC2Y5uCYrZksxAQ0MT5k4AQiRs1RQFqVGqUMSQcw==
X-Google-Smtp-Source: ABdhPJy/iU7MkXvcxrILygpddagGbgHmjRKa8yLTk2ky4cPUEnqKc3r7duTSD1q19nSi+eG3N7uR8Svl3ql1n/oBryg=
X-Received: by 2002:a2e:5cc1:0:b0:24b:112f:9b36 with SMTP id
 q184-20020a2e5cc1000000b0024b112f9b36mr9107276ljb.337.1650337304523; Mon, 18
 Apr 2022 20:01:44 -0700 (PDT)
MIME-Version: 1.0
References: <20220415215901.1737897-1-oupton@google.com>
 <20220415215901.1737897-5-oupton@google.com>
 <Yl4knFR8E8XVbgDj@google.com>
In-Reply-To: <Yl4knFR8E8XVbgDj@google.com>
From: Oliver Upton <oupton@google.com>
Date: Mon, 18 Apr 2022 20:01:33 -0700
Message-ID: <CAOQ_Qsi624p_a7WM74akGZxt6u7=vz_5nrfdh+9iFaz2J6QmEA@mail.gmail.com>
Subject: Re: [RFC PATCH 04/17] KVM: arm64: Protect page table traversal with
 RCU
To: Ricardo Koller <ricarkol@google.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Ben Gardon <bgardon@google.com>, Peter Shier <pshier@google.com>,
 David Matlack <dmatlack@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On Mon, Apr 18, 2022 at 7:55 PM Ricardo Koller <ricarkol@google.com> wrote:
>
> On Fri, Apr 15, 2022 at 09:58:48PM +0000, Oliver Upton wrote:
> > Use RCU to safely traverse the page tables in parallel; the tables
> > themselves will only be freed from an RCU synchronized context. Don't
> > even bother with adding support to hyp, and instead just assume
> > exclusive access of the page tables.
> >
> > Signed-off-by: Oliver Upton <oupton@google.com>
> > ---
> >  arch/arm64/kvm/hyp/pgtable.c | 23 ++++++++++++++++++++++-
> >  1 file changed, 22 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> > index 5b64fbca8a93..d4699f698d6e 100644
> > --- a/arch/arm64/kvm/hyp/pgtable.c
> > +++ b/arch/arm64/kvm/hyp/pgtable.c
> > @@ -132,9 +132,28 @@ static kvm_pte_t kvm_phys_to_pte(u64 pa)
> >       return pte;
> >  }
> >
> > +
> > +#if defined(__KVM_NVHE_HYPERVISOR__)
> > +static inline void kvm_pgtable_walk_begin(void)
> > +{}
> > +
> > +static inline void kvm_pgtable_walk_end(void)
> > +{}
> > +
> > +#define kvm_dereference_ptep rcu_dereference_raw
> > +#else
> > +#define kvm_pgtable_walk_begin       rcu_read_lock
> > +
> > +#define kvm_pgtable_walk_end rcu_read_unlock
> > +
> > +#define kvm_dereference_ptep rcu_dereference
> > +#endif
> > +
> >  static kvm_pte_t *kvm_pte_follow(kvm_pte_t pte, struct kvm_pgtable_mm_ops *mm_ops)
> >  {
> > -     return mm_ops->phys_to_virt(kvm_pte_to_phys(pte));
> > +     kvm_pte_t __rcu *ptep = mm_ops->phys_to_virt(kvm_pte_to_phys(pte));
> > +
> > +     return kvm_dereference_ptep(ptep);
> >  }
> >
> >  static void kvm_clear_pte(kvm_pte_t *ptep)
> > @@ -288,7 +307,9 @@ int kvm_pgtable_walk(struct kvm_pgtable *pgt, u64 addr, u64 size,
> >               .walker = walker,
> >       };
> >
> > +     kvm_pgtable_walk_begin();
> >       return _kvm_pgtable_walk(&walk_data);
> > +     kvm_pgtable_walk_end();
>
> This might be fixed later in the series, but at this point the
> rcu_read_unlock is never called.

Well that's embarrassing!
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
