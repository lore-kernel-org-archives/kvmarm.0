Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20E41C433EF
	for <kvmarm@archiver.kernel.org>; Wed,  8 Dec 2021 14:57:51 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AAB374B17B;
	Wed,  8 Dec 2021 09:57:50 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id h1gJkV081ygy; Wed,  8 Dec 2021 09:57:49 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6EE604B150;
	Wed,  8 Dec 2021 09:57:49 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 085934B133
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Dec 2021 09:41:10 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2gbA3LH8B41U for <kvmarm@lists.cs.columbia.edu>;
 Wed,  8 Dec 2021 09:41:08 -0500 (EST)
Received: from mail-io1-f50.google.com (mail-io1-f50.google.com
 [209.85.166.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5CD9B4B132
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Dec 2021 09:41:08 -0500 (EST)
Received: by mail-io1-f50.google.com with SMTP id k21so3002042ioh.4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 08 Dec 2021 06:41:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=EifvKO8pkCxjynNmz7PWzO7emHYLJkPJiO8pUS2qQfo=;
 b=qhudb95dxd2TFju2GrhG2SL1Z1VNnPvllqgHWUOLGfDC5ik0baUOZlzOIqN/xKbIqA
 yCIPWUl2DLbXQvJeV3xPebpPbsflSRrJsFG4Z9QVI6ny5meKUmX8XvZEFiix/Yt0se5O
 tPTxP0zp8NDl9wFBqww4sD54seBtEc6PyRqbYe5xdxwPQMeCWqexc4uswyKPJhdS8ev1
 x3IBBMwQkga8O6DPEgJKM0gz+M1RUWI3v28z7MUB13IHMzkz8Xng+fkCvYkL2KZ4kvjg
 E+82LoUqvl1ix4Rk41SREpDYqunzR1rWlnryiOuxTl3BwTxAyISK1fN37E7V1YD9xzwr
 anfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=EifvKO8pkCxjynNmz7PWzO7emHYLJkPJiO8pUS2qQfo=;
 b=yWdOlHEORkhOaTGgw9Dsc3IUKQB8j6AVPiwE7aW+r/FoMjPaMsa23J2kw0kVdWXLSG
 zMdOT3MQ7rJGcZBbam2XHC+gXbwS4uYUeMKrhT9P5ATacx+dHGubLywQU7SkahG6RZey
 A13nxym1Gerc9o3CgYSF8jshy0lG2k6Rwg7erdIikgNvzPC8Za9/IIUrXN7tx/8w26dw
 xDi3lB8LjAzxMdDnFmtIKd7kyaK2iYqSnUwuBf7Id9AQI5wiaI+9gmjxvxIMI5U/wG0F
 modo4CnFt1BQ4916wc466el1qH2Tx3HCpm01BCh2nAJJCR0674AhwREm9gu2NnH/yDGq
 +Q9g==
X-Gm-Message-State: AOAM532YTwdXGrQsqAk/zakfBBJ1cucTexhac9HxbHsSzmxteSmlz3cA
 XzQEhZWxKZoks0SDGEnO17CAxXNnvqWGAqxoH2qe2g==
X-Google-Smtp-Source: ABdhPJy1Z52W9BY50LufdzM7SjUxflxMKG+cfNETPfhd4KgizIC94LI3ETFCIYVx59bz5DGr04qcTlzMotGlynMycoI=
X-Received: by 2002:a05:6638:2191:: with SMTP id
 s17mr63525834jaj.67.1638974466161; 
 Wed, 08 Dec 2021 06:41:06 -0800 (PST)
MIME-Version: 1.0
References: <20211201170411.1561936-1-qperret@google.com>
 <20211201170411.1561936-7-qperret@google.com>
 <CA+_y_2EEP5tYbBTd17c1wuOeZ2jSfhgu0M2b=CpGKjKRgU-=gw@mail.gmail.com>
 <YbCAJZAqUXngvjZ2@google.com>
In-Reply-To: <YbCAJZAqUXngvjZ2@google.com>
From: Andrew Walbran <qwandor@google.com>
Date: Wed, 8 Dec 2021 14:40:54 +0000
Message-ID: <CA+_y_2GJk-F8ju0yXsMc2iwd_yFRQGOY1LW2YV-8bZLANwfCHQ@mail.gmail.com>
Subject: Re: [PATCH v3 06/15] KVM: arm64: Implement kvm_pgtable_hyp_unmap() at
 EL2
To: Quentin Perret <qperret@google.com>
X-Mailman-Approved-At: Wed, 08 Dec 2021 09:57:48 -0500
Cc: kernel-team@android.com, Marc Zyngier <maz@kernel.org>,
 linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

On Wed, 8 Dec 2021 at 09:51, Quentin Perret <qperret@google.com> wrote:
>
> Hi Andrew,
>
> On Tuesday 07 Dec 2021 at 14:47:14 (+0000), Andrew Walbran wrote:
> > On Wed, 1 Dec 2021 at 17:04, 'Quentin Perret' via kernel-team
> > <kernel-team@android.com> wrote:
> > >
> > > From: Will Deacon <will@kernel.org>
> > >
> > > Implement kvm_pgtable_hyp_unmap() which can be used to remove hypervisor
> > > stage-1 mappings at EL2.
> > >
> > > Signed-off-by: Will Deacon <will@kernel.org>
> > > Signed-off-by: Quentin Perret <qperret@google.com>
> > > ---
> > >  arch/arm64/include/asm/kvm_pgtable.h | 21 ++++++++++
> > >  arch/arm64/kvm/hyp/pgtable.c         | 63 ++++++++++++++++++++++++++++
> > >  2 files changed, 84 insertions(+)
> > >
> > > diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> > > index 027783829584..9d076f36401d 100644
> > > --- a/arch/arm64/include/asm/kvm_pgtable.h
> > > +++ b/arch/arm64/include/asm/kvm_pgtable.h
> > > @@ -251,6 +251,27 @@ void kvm_pgtable_hyp_destroy(struct kvm_pgtable *pgt);
> > >  int kvm_pgtable_hyp_map(struct kvm_pgtable *pgt, u64 addr, u64 size, u64 phys,
> > >                         enum kvm_pgtable_prot prot);
> > >
> > > +/**
> > > + * kvm_pgtable_hyp_unmap() - Remove a mapping from a hypervisor stage-1 page-table.
> > > + * @pgt:       Page-table structure initialised by kvm_pgtable_hyp_init().
> > > + * @addr:      Virtual address from which to remove the mapping.
> > > + * @size:      Size of the mapping.
> > > + *
> > > + * The offset of @addr within a page is ignored, @size is rounded-up to
> > > + * the next page boundary and @phys is rounded-down to the previous page
> > > + * boundary.
> > > + *
> > > + * TLB invalidation is performed for each page-table entry cleared during the
> > > + * unmapping operation and the reference count for the page-table page
> > > + * containing the cleared entry is decremented, with unreferenced pages being
> > > + * freed. The unmapping operation will stop early if it encounters either an
> > > + * invalid page-table entry or a valid block mapping which maps beyond the range
> > > + * being unmapped.
> >
> > How is the caller expected to break up the block mapping? Why not
> > handle that within this function?
>
> We don't really use block mappings for the hyp stage-1, since pretty
> much forever (see the loop in pkvm_create_mappings_locked() for ex), so
> handling it here would be somewhat unnecessary complexity. Handling this
> in the pgtable code itself (which I assume would mean proactively
> re-mapping the rest of the range with page-granularity mappings or
> something along those lines) is tricky because of BBM and concurrency,
> so I'd rather avoid handling same-level aborts at EL2 and all that mess
> unless we have a good reason. Is there a use-case where you think that'd
> be needed?

Aha, I didn't realise that block mappings, but it makes sense in that
case. How about adding a note to the function comment here explaining
that reasoning? Otherwise it sounds like the caller has to handle it
somehow.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
