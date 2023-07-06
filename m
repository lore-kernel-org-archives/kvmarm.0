Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09702137C
	for <kvmarm@lists.linux.dev>; Thu,  6 Jul 2023 06:09:30 +0000 (UTC)
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-2b70404a5a0so3445461fa.2
        for <kvmarm@lists.linux.dev>; Wed, 05 Jul 2023 23:09:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1688623769; x=1691215769;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nnXCFXxOhLyq4lCoBGcKBYyF+4vukIbIpcnG55iOM5c=;
        b=Mb8mQeODhASdfKj+hHmylndEuVUiM/b1apoiBK04bLwBY4ajtvROBk8GMW7aZY/V0i
         W1Z+4ltSxdNVbESwxHXe2Nto30vwXM0F3QS91jS46XmSmaIFT07lHu3Fjhw9FLn8BQ2Y
         YvMVdpKSmiU70sMHWlcr+gv3eHgbBItZzvHwg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688623769; x=1691215769;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nnXCFXxOhLyq4lCoBGcKBYyF+4vukIbIpcnG55iOM5c=;
        b=XxGzZIesalsxHE15uaphigUyKC8oeygZoXL4byZdBWAHLiht46wnWKwgAYVB1VCUin
         0N1wKGS5EelUNio6Vr+mDq/cjXXOlpehoF+tSxkBfzrhS4e24z/OcgI5D2lBT/+b7Prf
         8Dym/kd4m7UvlAQU0VazcNWqkAEB6lDgvNRm+/NFmgayTF4ZpRffKRMeLy6Hkiv8IDuI
         CZsno28zIJzTW0QRO5i5oiW2C4MkeNppQxt1/l6bu4FOQcuUPB2YQo+IuqUYCVRVBz9a
         opdOJVNe/ZyfbMGzdd/tvhlLbS7DS/bq/BetAGBu07T/xg+2GEPwtbHsf6lz84S67FkC
         ywrg==
X-Gm-Message-State: ABy/qLZNnXRbzQh26k4LUxgH+tbecS6jZGNknpoXTCOJPnkSppAsO5o8
	cjqWpi6ypsz/1our1yFh1z6yuXqeI+s6o4CiE3caNA==
X-Google-Smtp-Source: APBJJlFQB6JQNb0dZ8JFG6eZYjbcpaXMlqxVbVKudZNWo1HIe+n1zgkzENdCl4UX7JHIJWm/W9286vJy7CQ1VvEz4L0=
X-Received: by 2002:a2e:9c46:0:b0:2b7:857:7cb5 with SMTP id
 t6-20020a2e9c46000000b002b708577cb5mr58264ljj.24.1688623768867; Wed, 05 Jul
 2023 23:09:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230704075054.3344915-1-stevensd@google.com> <20230704075054.3344915-4-stevensd@google.com>
 <20230705115653.5whvhvcvmflqmcse@linux.intel.com>
In-Reply-To: <20230705115653.5whvhvcvmflqmcse@linux.intel.com>
From: David Stevens <stevensd@chromium.org>
Date: Thu, 6 Jul 2023 15:09:17 +0900
Message-ID: <CAD=HUj4E84MxZn8=U3wkBtx-VYdeD1mqOH9BUYpG=Y2POvY6sg@mail.gmail.com>
Subject: Re: [PATCH v7 3/8] KVM: Make __kvm_follow_pfn not imply FOLL_GET
To: Yu Zhang <yu.c.zhang@linux.intel.com>
Cc: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Peter Xu <peterx@redhat.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 5, 2023 at 8:56=E2=80=AFPM Yu Zhang <yu.c.zhang@linux.intel.com=
> wrote:
>
> On Tue, Jul 04, 2023 at 04:50:48PM +0900, David Stevens wrote:
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
> > +      * be true if FOLL_GET is not set.
> > +      */
> > +     bool guarded_by_mmu_notifier;
>
> And how? Any place to check the invalidate seq?

kvm_follow_pfn can't meaningfully validate the seq number, since the
mmu notifier locking is handled by the caller. This is more of a
sanity check that the API is being used properly, as proposed here
[1]. I did deviate from the proposal with a bool instead of some type
of integer, since the exact value of mmu_seq wouldn't be useful.

[1] https://lore.kernel.org/all/ZGvUsf7lMkrNDHuE@google.com/#t

-David
