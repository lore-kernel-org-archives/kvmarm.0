Received: from mail-vs1-f51.google.com (mail-vs1-f51.google.com [209.85.217.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A378F4CE1F
	for <kvmarm@lists.linux.dev>; Mon, 22 Apr 2024 08:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713773491; cv=none; b=NRYxq8UpsXsr0FJTHmSRekEsvfl3rti/O4zsRvTDWOSazcQduLqb9dvK+SXxfogO+DaeaeRsgbp/I99wjTDwGXGmbXaL7PvLWyz0m4FSFhwyKp5JVyaYFT241p2/9IVuphejUFLKlFwhiAZZOvsdcsXuChSrthtIsqcNNXnE874=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713773491; c=relaxed/simple;
	bh=++fUnXTT9AOfGOCCT3gJOALGZJCzPt05GyclnMtRPf0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ciIesUVf5QggGf+R7cBQroRxPVusC2O26Q6hHT5U5E8XkhgtKW7RvqC89RqPw1ShIJgW6k+p5J0mD2NqrCjBCWOabaJKHXnIlzLdvtKPFzmAqHnLQikX2eBono7Vew9Gu2iXJJJ2TL3lZhbCLVRy6ZYkaw7mNyfbpgIDM6UDhCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=adtzfupD; arc=none smtp.client-ip=209.85.217.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="adtzfupD"
Received: by mail-vs1-f51.google.com with SMTP id ada2fe7eead31-479de34dc36so1297550137.1
        for <kvmarm@lists.linux.dev>; Mon, 22 Apr 2024 01:11:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713773488; x=1714378288; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FAKGzcg3iPDl08GJH2bWOFyNlpWwk4gtuhdrpKK0TAQ=;
        b=adtzfupDUOiyI5ol4q3DG2BSiagNnW4VqIb6wuLjn8R62Yy2NM1WxumiFLhv2LB7yD
         NZXFpmiC3wRz/VG3zVzmRviyZeBnM8Fsch+dKTLzoJpV75cfoSgjpErX0jRgbOVj4mdi
         /e2G305iGBS0o+aYKyjOSqEyc4GMCONUZdhVVnjXpjWbuEk+1yudYWX67WO8TK18qxYS
         AYGzqEXAP90JBjFLlt7jcCIZCd3zgRuhmE3eHFZxsq7tWEgD9lp6iCEHxBHEdimPsjSP
         z/6Iyk26UehuVH4bDakxZ0/EMD0Ir9Jj5/1ftxGWgfklKwZx1PrFb3g0u0mvCpEWB99P
         ckrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713773488; x=1714378288;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FAKGzcg3iPDl08GJH2bWOFyNlpWwk4gtuhdrpKK0TAQ=;
        b=uEteKg7tkkifhsBLE6jZxVVesNsWKxf6L0nO0QyXOKcLwLN5nbPMukDeGQCftK2AmV
         gVkKoPmyMSYXi7BSTVhxgZklMzcrFSrppIkKJoDVWHZyP5qootXBeekD3/EQTeeraH5I
         ysd8jWjOl66Qb/4l2jliMLRg0kflvqE5Z5F7Cfybvo5NF5+mDH3cRLleCN3d7ePs1lY9
         BuAK1AV148I8n0LbjJmMO/6U8eUwplsjJT04tT0QNVl8qwwqukFuMMll3sWqdE5OzCqy
         Y5OSgFPtFv7HAAiMrXlJWlpTz6PdKMUsh24Y2ccap7CKQE5hNyA7fXLC8oa6DXwu8+TT
         GCcg==
X-Gm-Message-State: AOJu0YwFwXlR/42Ta6rfRG3ioPnrRlWEmMfN5TNe+bHfUYwaWToN4Cdt
	QBHZQMxukxyFBCvJLqlpeEmtp55vVEhjnSbRRuTlPjCqQWMtGtDUzrSCgkIHxCrlkab3Nt6soQa
	CLmCNAWFcQGiituOQYPzIq1RqSz0zfwsKGxIZ
X-Google-Smtp-Source: AGHT+IHjSWRaNz+DQJw0uXdYOKV5H2CFOv0edt3xGqtnZSvHq9hewqqf6AMa6xc0kzTpWLd447n0tJJg5WFzx6XTET4=
X-Received: by 2002:a67:fc18:0:b0:47b:d6c8:a1fa with SMTP id
 o24-20020a67fc18000000b0047bd6c8a1famr8108208vsq.1.1713773488401; Mon, 22 Apr
 2024 01:11:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240419075941.4085061-1-tabba@google.com> <20240419075941.4085061-28-tabba@google.com>
 <ZiLZehsi1_arusae@linux.dev>
In-Reply-To: <ZiLZehsi1_arusae@linux.dev>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 22 Apr 2024 09:10:52 +0100
Message-ID: <CA+EHjTx67TOQKzsLJ_9PP_rYRiYb7j0RuJLzDK8B6jK_SdQMHA@mail.gmail.com>
Subject: Re: [PATCH v3 27/31] KVM: arm64: Use atomic refcount helpers for
 'struct hyp_page::refcount'
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvmarm@lists.linux.dev, maz@kernel.org, will@kernel.org, 
	qperret@google.com, seanjc@google.com, alexandru.elisei@arm.com, 
	catalin.marinas@arm.com, philmd@linaro.org, james.morse@arm.com, 
	suzuki.poulose@arm.com, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com, smostafa@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 19, 2024 at 9:52=E2=80=AFPM Oliver Upton <oliver.upton@linux.de=
v> wrote:
>
> On Fri, Apr 19, 2024 at 08:59:37AM +0100, Fuad Tabba wrote:
> > From: Will Deacon <will@kernel.org>
> >
> > Convert the 'struct hyp_page' refcount manipulation functions over to
> > the new atomic refcount helpers. For now, this will make absolutely no
> > difference because the 'struct hyp_pool' locking is still serialising
> > everything. One step at a time...
> >
> > Signed-off-by: Will Deacon <will@kernel.org>
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  arch/arm64/kvm/hyp/include/nvhe/memory.h | 18 +++++++-----------
> >  arch/arm64/kvm/hyp/nvhe/mem_protect.c    |  2 +-
> >  arch/arm64/kvm/hyp/nvhe/page_alloc.c     |  5 ++++-
> >  3 files changed, 12 insertions(+), 13 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/hyp/include/nvhe/memory.h b/arch/arm64/kvm/=
hyp/include/nvhe/memory.h
> > index ab205c4d6774..74474c82667b 100644
> > --- a/arch/arm64/kvm/hyp/include/nvhe/memory.h
> > +++ b/arch/arm64/kvm/hyp/include/nvhe/memory.h
> > @@ -6,6 +6,7 @@
> >  #include <asm/page.h>
> >
> >  #include <linux/types.h>
> > +#include <nvhe/refcount.h>
> >
> >  struct hyp_page {
> >       unsigned short refcount;
> > @@ -39,37 +40,32 @@ static inline phys_addr_t hyp_virt_to_phys(void *ad=
dr)
> >  #define hyp_page_to_pool(page)       (((struct hyp_page *)page)->pool)
> >
> >  /*
> > - * Refcounting for 'struct hyp_page'.
> > - * hyp_pool::lock must be held if atomic access to the refcount is req=
uired.
> > + * Refcounting wrappers for 'struct hyp_page'.
> >   */
> >  static inline int hyp_page_count(void *addr)
> >  {
> >       struct hyp_page *p =3D hyp_virt_to_page(addr);
> >
> > -     return p->refcount;
> > +     return hyp_refcount_get(p->refcount);
> >  }
> >
> >  static inline void hyp_page_ref_inc(struct hyp_page *p)
> >  {
> > -     BUG_ON(p->refcount =3D=3D USHRT_MAX);
> > -     p->refcount++;
> > +     hyp_refcount_inc(p->refcount);
>
> Adding a BUG_ON() for taking a reference on a non-refcounted page (i.e.
> p->refcount was 0) would be nice, especially since we're past the point o=
f
> serializing everything and you can theoretically have a zero count page
> outside of the free list.
>
> Seems like otherwise we'd get actually hit the BUG_ON() in an unrelated
> allocation path.

Will do.

Thanks,
/fuad
>
> --
> Thanks,
> Oliver
