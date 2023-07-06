Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com [209.85.208.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 895541102
	for <kvmarm@lists.linux.dev>; Thu,  6 Jul 2023 06:49:52 +0000 (UTC)
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-2b700e85950so3945461fa.3
        for <kvmarm@lists.linux.dev>; Wed, 05 Jul 2023 23:49:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1688626190; x=1691218190;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r5eWkSj4KC5nS3P+RLvcZXPptH23EBW7FjX/9bZ4xeY=;
        b=ja4IOO3xVZ6/Tc75u/mIiFFibtnYxJ3DyQJiezKFRO1BT/i/tInsQdPBwqV1K6c8OB
         NzrTW0CCdwtJDcyKr+K7eaRAfl7gSY3EPoTgo/V1gOdfqehluk6JZK6F4LvwA1z4DQCk
         aCMPhrABaGhAhTIgENGDgkn/PB5cEiYnULzWI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688626190; x=1691218190;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=r5eWkSj4KC5nS3P+RLvcZXPptH23EBW7FjX/9bZ4xeY=;
        b=eoF1TyBgvTvLPtawoDWxXvCWT/gRHNo1oax+66MYy9D6JyaxPpHqztAiwLOQcgeHmE
         9mnjY9FadA2ZD5bCjRSoCsCv1C5fl620dE7jj1k4EZjrNKT3ngnsrzHt+jjZpmQoVjyN
         av5odf3QU8PUfFNDeLW9aBz//nO7X19Y5zEOieV6zmhoneGUJW7ReY26QtQSLpgLatxX
         VxeamKx6rX7uyCOpgMaWcNE5HeBkTdTFzTGykUZ9yBchdp4KwHN/KbeY+/XeXIez5wWc
         OcJvsepWS2brZ36lBn/cKazCJCZ1kiFOggmTtB/mXGkp4cVovLF+vW17u8ER3nCTyIDy
         RILA==
X-Gm-Message-State: ABy/qLZf7FZtqDbuHHhpb7oLSROlWRFMMGW0rrBBhmttjCcwRZjPgar5
	iU3jDGhkNLTrj2+IXIZwsFM72Qhf0Coxg7xxnnUktg==
X-Google-Smtp-Source: APBJJlF7htU9Rd6ty5mPrsHjdKtTcK7sc+s+47FH3YkpHGjHXvbMbW6eRVcyDM6GyWvtGpLRUG3fOJ+jUV4yvf2Vv+s=
X-Received: by 2002:a2e:b60d:0:b0:2b6:bb08:91c4 with SMTP id
 r13-20020a2eb60d000000b002b6bb0891c4mr609674ljn.42.1688626190310; Wed, 05 Jul
 2023 23:49:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230704075054.3344915-1-stevensd@google.com> <20230704075054.3344915-4-stevensd@google.com>
 <20230705161914.00004070.zhi.wang.linux@gmail.com>
In-Reply-To: <20230705161914.00004070.zhi.wang.linux@gmail.com>
From: David Stevens <stevensd@chromium.org>
Date: Thu, 6 Jul 2023 15:49:39 +0900
Message-ID: <CAD=HUj5cbzjrc0KD7xcibtRMRCzoJRJAzt7jTHSXUSpzyAYbdg@mail.gmail.com>
Subject: Re: [PATCH v7 3/8] KVM: Make __kvm_follow_pfn not imply FOLL_GET
To: Zhi Wang <zhi.wang.linux@gmail.com>
Cc: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Peter Xu <peterx@redhat.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 5, 2023 at 10:19=E2=80=AFPM Zhi Wang <zhi.wang.linux@gmail.com>=
 wrote:
>
> On Tue,  4 Jul 2023 16:50:48 +0900
> David Stevens <stevensd@chromium.org> wrote:
>
> > From: David Stevens <stevensd@chromium.org>
> >
> > Make it so that __kvm_follow_pfn does not imply FOLL_GET. This allows
> > callers to resolve a gfn when the associated pfn has a valid struct pag=
e
> > that isn't being actively refcounted (e.g. tail pages of non-compound
> > higher order pages). For a caller to safely omit FOLL_GET, all usages o=
f
> > the returned pfn must be guarded by a mmu notifier.
> >
> > This also adds a is_refcounted_page out parameter to kvm_follow_pfn tha=
t
> > is set when the returned pfn has an associated struct page with a valid
> > refcount. Callers that don't pass FOLL_GET should remember this value
> > and use it to avoid places like kvm_is_ad_tracked_page that assume a
> > non-zero refcount.
> >
> > Signed-off-by: David Stevens <stevensd@chromium.org>
> > ---
> >  include/linux/kvm_host.h | 10 ++++++
> >  virt/kvm/kvm_main.c      | 67 +++++++++++++++++++++-------------------
> >  virt/kvm/pfncache.c      |  2 +-
> >  3 files changed, 47 insertions(+), 32 deletions(-)
> >
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index ef2763c2b12e..a45308c7d2d9 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -1157,6 +1157,9 @@ unsigned long gfn_to_hva_memslot_prot(struct kvm_=
memory_slot *slot, gfn_t gfn,
> >  void kvm_release_page_clean(struct page *page);
> >  void kvm_release_page_dirty(struct page *page);
> >
> > +void kvm_set_page_accessed(struct page *page);
> > +void kvm_set_page_dirty(struct page *page);
> > +
> >  struct kvm_follow_pfn {
> >       const struct kvm_memory_slot *slot;
> >       gfn_t gfn;
> > @@ -1164,10 +1167,17 @@ struct kvm_follow_pfn {
> >       bool atomic;
> >       /* Allow a read fault to create a writeable mapping. */
> >       bool allow_write_mapping;
> > +     /*
> > +      * Usage of the returned pfn will be guared by a mmu notifier. Mu=
st
>                                               ^guarded
> > +      * be true if FOLL_GET is not set.
> > +      */
> > +     bool guarded_by_mmu_notifier;
> >
> It seems no one sets the guraded_by_mmu_notifier in this patch. Is
> guarded_by_mmu_notifier always equal to !foll->FOLL_GET and set by the
> caller of __kvm_follow_pfn()?

Yes, this is the case.

> If yes, do we have to use FOLL_GET to resolve GFN associated with a tail =
page?
> It seems gup can tolerate gup_flags without FOLL_GET, but it is more like=
 a
> temporary solution. I don't think it is a good idea to play tricks with
> a temporary solution, more like we are abusing the toleration.

I'm not sure I understand what you're getting at. This series never
calls gup without FOLL_GET.

This series aims to provide kvm_follow_pfn as a unified API on top of
gup+follow_pte. Since one of the major clients of this API uses an mmu
notifier, it makes sense to support returning a pfn without taking a
reference. And we indeed need to do that for certain types of memory.

> Is a flag like guarded_by_mmu_notifier (perhaps a better name) enough to
> indicate a tail page?

What do you mean by to indicate a tail page? Do you mean to indicate
that the returned pfn refers to non-refcounted page? That's specified
by is_refcounted_page.

-David
