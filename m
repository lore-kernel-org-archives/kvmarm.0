Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17135C433EF
	for <kvmarm@archiver.kernel.org>; Sat, 25 Jun 2022 08:53:41 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C6AC44A1D9;
	Sat, 25 Jun 2022 04:53:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id or5kAJC0KWxe; Sat, 25 Jun 2022 04:53:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 911A14B231;
	Sat, 25 Jun 2022 04:53:36 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 32E69413E2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Jun 2022 17:51:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id u7x1-aKGrxpR for <kvmarm@lists.cs.columbia.edu>;
 Fri, 24 Jun 2022 17:51:06 -0400 (EDT)
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com
 [209.85.221.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B771440FF0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Jun 2022 17:51:06 -0400 (EDT)
Received: by mail-wr1-f50.google.com with SMTP id v14so4792389wra.5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Jun 2022 14:51:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=ygHo4kCjlplomgaDbLB/O69dvwBvbC5Loc23ldoxb3Y=;
 b=RsFWPuqWaoLcQtnQjgye0TXSrWqr2gSZP/JqpocE2GMf+HPDFUKs0eQ03fdTXAy25m
 mAn7ndJzQ5Ot91T0BnJG+wIfYUyXbMDliJ4XSKHWOEnrH2aYdvnWxWHTyWL3hSC7qMRM
 D+4z+0moSBKDpopAba4+GZrWcIQc0REx9PuZ0WTpskVsqewQAN6+HZOoG+I2UfNsPo35
 GCrp6xkZQ5Hhf/zCu2+zR0iTPTNgdPOD9lQJsDDwu/683Sn+qQmM26nXGaLzwhN/8Jj9
 xOKspLeH0Fp/qROPBWylrPNxLoMnTwmXJtKMHMrQsy30GTKTSM++YEegq1m0IhsbybZR
 hVSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=ygHo4kCjlplomgaDbLB/O69dvwBvbC5Loc23ldoxb3Y=;
 b=qx0uH4OZCjkphfZrgRP8hC16xYrRFTpUyRCKj8kWCpStB0OxXcNiOG+ADan6uJGeuj
 fFrlTT1f/N1G4Ear9SiJIcuQOkD9pvNr2UUALiAFaz2o6oBNWdKS0XsNSecp81CFUiDm
 tCURF3p3P0dM9HuG+nuxve7UOegwlxviruelu8YVcnpNZ+sWgB7mLSVCUHCJaXyOBCAi
 H74ZgyeRIvl9qXjfeIpIIRTu/5X1/NSsMRLQTNaoOa675zSraEZw9eHTwsvVZAUIqOoj
 3jdnG2tY7bXSLKwNghAEtWhQQPnVwPBEjItOazk4pb/TF3PP7RSwavVHcNLoqgDxxxsx
 2pZg==
X-Gm-Message-State: AJIora8ynCe3kw8ySS8D2j2e7ySsP1IgXmvFw1irURLxxeW23u1pAfUk
 7BmEEt3yUhZt1ZrKHXJejJl4L+qhMS02oXn9DHlKIQ==
X-Google-Smtp-Source: AGRyM1t2jcGW3PeWYunQh6GfpJeg8eVQCrLSWuOvf0glSyRhsk25Df+XOBeTdbLhrqqfHC+TqtbY7gSVXm3SdN2NYKk=
X-Received: by 2002:a05:6000:54f:b0:21b:944c:c70b with SMTP id
 b15-20020a056000054f00b0021b944cc70bmr1072670wrf.572.1656107465447; Fri, 24
 Jun 2022 14:51:05 -0700 (PDT)
MIME-Version: 1.0
References: <20220623234944.141869-1-pcc@google.com> <YrXu0Uzi73pUDwye@arm.com>
In-Reply-To: <YrXu0Uzi73pUDwye@arm.com>
From: Peter Collingbourne <pcc@google.com>
Date: Fri, 24 Jun 2022 14:50:53 -0700
Message-ID: <CAMn1gO7-qVzZrAt63BJC-M8gKLw4=60iVUo6Eu8T_5y3AZnKcA@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: permit MAP_SHARED mappings with MTE enabled
To: Catalin Marinas <catalin.marinas@arm.com>
X-Mailman-Approved-At: Sat, 25 Jun 2022 04:53:35 -0400
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Andy Lutomirski <luto@amacapital.net>, Evgenii Stepanov <eugenis@google.com>,
 Michael Roth <michael.roth@amd.com>, Chao Peng <chao.p.peng@linux.intel.com>,
 Steven Price <steven.price@arm.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, Linux ARM <linux-arm-kernel@lists.infradead.org>
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

On Fri, Jun 24, 2022 at 10:05 AM Catalin Marinas
<catalin.marinas@arm.com> wrote:
>
> + Steven as he added the KVM and swap support for MTE.
>
> On Thu, Jun 23, 2022 at 04:49:44PM -0700, Peter Collingbourne wrote:
> > Certain VMMs such as crosvm have features (e.g. sandboxing, pmem) that
> > depend on being able to map guest memory as MAP_SHARED. The current
> > restriction on sharing MAP_SHARED pages with the guest is preventing
> > the use of those features with MTE. Therefore, remove this restriction.
>
> We already have some corner cases where the PG_mte_tagged logic fails
> even for MAP_PRIVATE (but page shared with CoW). Adding this on top for
> KVM MAP_SHARED will potentially make things worse (or hard to reason
> about; for example the VMM sets PROT_MTE as well). I'm more inclined to
> get rid of PG_mte_tagged altogether, always zero (or restore) the tags
> on user page allocation, copy them on write. For swap we can scan and if
> all tags are 0 and just skip saving them.

A problem with this approach is that it would conflict with any
potential future changes that we might make that would require the
kernel to avoid modifying the tags for non-PROT_MTE pages.

Thinking about this some more, another idea that I had was to only
allow MAP_SHARED mappings in a guest with MTE enabled if the mapping
is PROT_MTE and there are no non-PROT_MTE aliases. For anonymous
mappings I don't think it's possible to create a non-PROT_MTE alias in
another mm (since you can't turn off PROT_MTE with mprotect), and for
memfd maybe we could introduce a flag that requires PROT_MTE on all
mappings. That way, we are guaranteed that either the page has been
tagged prior to fault or we have exclusive access to it so it can be
tagged on demand without racing. Let me see what effect that has on
crosvm.

> Another aspect is a change in the KVM ABI with this patch. It's probably
> not that bad since it's rather a relaxation but it has the potential to
> confuse the VMM, especially as it doesn't know whether it's running on
> older kernels or not (it would have to probe unless we expose this info
> to the VMM in some other way).
>
> > To avoid races between multiple tasks attempting to clear tags on the
> > same page, introduce a new page flag, PG_mte_tag_clearing, and test-set it
> > atomically before beginning to clear tags on a page. If the flag was not
> > initially set, spin until the other task has finished clearing the tags.
>
> TBH, I can't mentally model all the corner cases, so maybe a formal
> model would help (I can have a go with TLA+, though not sure when I find
> a bit of time this summer). If we get rid of PG_mte_tagged altogether,
> this would simplify things (hopefully).
>
> As you noticed, the problem is that setting PG_mte_tagged and clearing
> (or restoring) the tags is not an atomic operation. There are places
> like mprotect() + CoW where one task can end up with stale tags. Another
> is shared memfd mappings if more than one mapping sets PROT_MTE and
> there's the swap restoring on top.
>
> > diff --git a/arch/arm64/kernel/mte.c b/arch/arm64/kernel/mte.c
> > index f6b00743c399..8f9655053a9f 100644
> > --- a/arch/arm64/kernel/mte.c
> > +++ b/arch/arm64/kernel/mte.c
> > @@ -57,7 +57,18 @@ static void mte_sync_page_tags(struct page *page, pte_t old_pte,
> >        * the new page->flags are visible before the tags were updated.
> >        */
> >       smp_wmb();
> > -     mte_clear_page_tags(page_address(page));
> > +     mte_ensure_page_tags_cleared(page);
> > +}
> > +
> > +void mte_ensure_page_tags_cleared(struct page *page)
> > +{
> > +     if (test_and_set_bit(PG_mte_tag_clearing, &page->flags)) {
> > +             while (!test_bit(PG_mte_tagged, &page->flags))
> > +                     ;
> > +     } else {
> > +             mte_clear_page_tags(page_address(page));
> > +             set_bit(PG_mte_tagged, &page->flags);
> > +     }
> >  }
>
> mte_sync_tags() already sets PG_mte_tagged prior to clearing the page
> tags. The reason was so that multiple concurrent set_pte_at() would not
> all rush to clear (or restore) the tags. But we do have the risk of one
> thread accessing the page with the stale tags (copy_user_highpage() is
> worse as the tags would be wrong in the destination page). I'd rather be
> consistent everywhere with how we set the flags.
>
> However, I find it easier to reason about if we used the new flag as a
> lock. IOW, if PG_mte_tagged is set, we know that tags are valid. If not
> set, take the PG_mte_locked flag, check PG_mte_tagged again and
> clear/restore the tags followed by PG_mte_tagged (and you can use
> test_and_set_bit_lock() for the acquire semantics).

Okay, I can look at doing it that way as well.

> It would be interesting to benchmark the cost of always zeroing the tags
> on allocation and copy when MTE is not in use:
>
> diff --git a/arch/arm64/mm/copypage.c b/arch/arm64/mm/copypage.c
> index 0dea80bf6de4..d31708886bf9 100644
> --- a/arch/arm64/mm/copypage.c
> +++ b/arch/arm64/mm/copypage.c
> @@ -21,7 +21,7 @@ void copy_highpage(struct page *to, struct page *from)
>
>         copy_page(kto, kfrom);
>
> -       if (system_supports_mte() && test_bit(PG_mte_tagged, &from->flags)) {
> +       if (system_supports_mte()) {
>                 set_bit(PG_mte_tagged, &to->flags);
>                 page_kasan_tag_reset(to);
>                 /*
> diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
> index c5e11768e5c1..b42cad9b9349 100644
> --- a/arch/arm64/mm/fault.c
> +++ b/arch/arm64/mm/fault.c
> @@ -913,12 +913,7 @@ struct page *alloc_zeroed_user_highpage_movable(struct vm_area_struct *vma,
>  {
>         gfp_t flags = GFP_HIGHUSER_MOVABLE | __GFP_ZERO;
>
> -       /*
> -        * If the page is mapped with PROT_MTE, initialise the tags at the
> -        * point of allocation and page zeroing as this is usually faster than
> -        * separate DC ZVA and STGM.
> -        */
> -       if (vma->vm_flags & VM_MTE)
> +       if (system_supports_mte())
>                 flags |= __GFP_ZEROTAGS;
>
>         return alloc_page_vma(flags, vma, vaddr);
>
> If that's negligible, we can hopefully get rid of PG_mte_tagged. For
> swap we could move the restoring to arch_do_swap_page() (but move the
> call one line above set_pte_at() in do_swap_page()).

I could experiment with this but I'm hesistant given the potential to
cut off potential future changes.

Peter
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
