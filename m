Received: from mail-oi1-f171.google.com (mail-oi1-f171.google.com [209.85.167.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 410BD14F9D4
	for <kvmarm@lists.linux.dev>; Mon, 22 Apr 2024 13:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713791337; cv=none; b=TcT21IJfo0n2iSP90IG8OgBpBdV4yuikuyqzDiMgpx/WRE1qFGoi0T80/gg+3sBuZI4QDXk2o08mlr1aahAsxFSns3N+hzdK5GGZY01ApvlMuqshNug96HKIsc3LKWk5G1+RK69sP5/qzeVr5jJkNFfTf+6QMDYLPOeYdlAYqck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713791337; c=relaxed/simple;
	bh=c0bMStBfW3JMkk8V/oqGfzxsEzoszur+POqM6C2rtGg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oXNXGTt5zCECb4oJ5k/mF87VdyLMU4duizKu8OBq0gYYMxuVJnliHZ3UF74tIoNTXQpmneOVYX5+HxN6Rn7d6dyC5KQ3bhSN+hpyKGcLpbgnq9j+kX6VdYcJPD3J03l+fFss6nhXo51C1Zw6ImSpMy9jA1MiATG0OEBbM+WEnTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MFkqeQed; arc=none smtp.client-ip=209.85.167.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MFkqeQed"
Received: by mail-oi1-f171.google.com with SMTP id 5614622812f47-3c745103fb8so1273759b6e.3
        for <kvmarm@lists.linux.dev>; Mon, 22 Apr 2024 06:08:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713791335; x=1714396135; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OpFSnl8lX2AL2nCmJTn1rcXxdkxTS3dWqVsmQfdbkfI=;
        b=MFkqeQedqFsh1+HKJzqZ/WidsKiq6+MrY4tN6hwleoHEzpuvWZt/d/jQQVIn2AHZP6
         GytH2ZgBO8k4nJTeeAHfxsvHLYsrUcoQPTckzzCfgKXDBJtu6FhsjEXDroLoc+PPn4tg
         TbGxhye2VPEyVrJSQJ+Mo8myDmgSa+w+N6/gwt5JtNZhCYR2H+6mbEZiN9kR3nDHDCK1
         0CkzoVt8gwTVjUXZC7Ibvxt1tvQXPCLAS0nqCxe6KnebrB1Dq3GzW4YqUB1xaGW2EALn
         yPngWvCeWsZrbUNx8/sQ1+pGPrhL8NOqN3hoskgVNqtltpqGPIG8IpNMN5w5QDxo+gRD
         xBig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713791335; x=1714396135;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OpFSnl8lX2AL2nCmJTn1rcXxdkxTS3dWqVsmQfdbkfI=;
        b=ZayM5C9GhGoEstNtcc8NL/9ibM7t3ZvdapdDdysAYm+PF6Kc4ihmNDDE3UoACyTk9J
         S62fgUzLKqbJBH16jnn3sCfKOBex4Dxk7Mt2Ymf9o3NSDCzKrn24EuKdaJmBvCELS4la
         IwSet7bxDPxuYkwg/tuAhKqQ+amJFjyH1qe3L+E3b1+jzhvPlcBtZWVobampL29i4CKN
         TO2DBc8wtJdln/RiGiTK8kSfKvh9cFFI22AThC83cSZk6gg53SNLVWShTQaWxi4AMB+q
         NAv9LemCtSXFV9x4PnHBxrnIogZ2L7MKaVFwr6rc3XTJpgak7jg0vmInpEWZXkIu6Y8B
         in6g==
X-Gm-Message-State: AOJu0YxryEjvZPMCpVJhPlg1SKasmDJUhLMpU9IOL9klvMyttGrYPvvi
	+/FdUOhjutoQF64cBlS1Iw0slMie//9lCwTCnARJFxngQp55KHzeojWHenq157CemJtqLVJ2CUm
	94BrOCSK+602RJPyitugzcgYVi6GFCPL8swFG
X-Google-Smtp-Source: AGHT+IG3mhGx9jujMe8Jz1muMIgJ6b6ZXPfotwgk2Cmlf/h4iqsz8Fy10lh/xxFGLo1bBhB3J7dj/qhePhE7F2tBTJw=
X-Received: by 2002:a05:6808:2228:b0:3c7:292a:7e27 with SMTP id
 bd40-20020a056808222800b003c7292a7e27mr14155297oib.28.1713791334316; Mon, 22
 Apr 2024 06:08:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240419075941.4085061-1-tabba@google.com> <20240419075941.4085061-28-tabba@google.com>
 <ZiLZehsi1_arusae@linux.dev> <CA+EHjTx67TOQKzsLJ_9PP_rYRiYb7j0RuJLzDK8B6jK_SdQMHA@mail.gmail.com>
In-Reply-To: <CA+EHjTx67TOQKzsLJ_9PP_rYRiYb7j0RuJLzDK8B6jK_SdQMHA@mail.gmail.com>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 22 Apr 2024 14:08:17 +0100
Message-ID: <CA+EHjTzc6h719kvP9FJA3xqLnOxr5gPWDq7iYOx7JfQz4Wn61w@mail.gmail.com>
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

Hi Oliver,

On Mon, Apr 22, 2024 at 9:10=E2=80=AFAM Fuad Tabba <tabba@google.com> wrote=
:
>
> On Fri, Apr 19, 2024 at 9:52=E2=80=AFPM Oliver Upton <oliver.upton@linux.=
dev> wrote:
> >
> > On Fri, Apr 19, 2024 at 08:59:37AM +0100, Fuad Tabba wrote:
> > > From: Will Deacon <will@kernel.org>
> > >
> > > Convert the 'struct hyp_page' refcount manipulation functions over to
> > > the new atomic refcount helpers. For now, this will make absolutely n=
o
> > > difference because the 'struct hyp_pool' locking is still serialising
> > > everything. One step at a time...
> > >
> > > Signed-off-by: Will Deacon <will@kernel.org>
> > > Signed-off-by: Fuad Tabba <tabba@google.com>
> > > ---
> > >  arch/arm64/kvm/hyp/include/nvhe/memory.h | 18 +++++++-----------
> > >  arch/arm64/kvm/hyp/nvhe/mem_protect.c    |  2 +-
> > >  arch/arm64/kvm/hyp/nvhe/page_alloc.c     |  5 ++++-
> > >  3 files changed, 12 insertions(+), 13 deletions(-)
> > >
> > > diff --git a/arch/arm64/kvm/hyp/include/nvhe/memory.h b/arch/arm64/kv=
m/hyp/include/nvhe/memory.h
> > > index ab205c4d6774..74474c82667b 100644
> > > --- a/arch/arm64/kvm/hyp/include/nvhe/memory.h
> > > +++ b/arch/arm64/kvm/hyp/include/nvhe/memory.h
> > > @@ -6,6 +6,7 @@
> > >  #include <asm/page.h>
> > >
> > >  #include <linux/types.h>
> > > +#include <nvhe/refcount.h>
> > >
> > >  struct hyp_page {
> > >       unsigned short refcount;
> > > @@ -39,37 +40,32 @@ static inline phys_addr_t hyp_virt_to_phys(void *=
addr)
> > >  #define hyp_page_to_pool(page)       (((struct hyp_page *)page)->poo=
l)
> > >
> > >  /*
> > > - * Refcounting for 'struct hyp_page'.
> > > - * hyp_pool::lock must be held if atomic access to the refcount is r=
equired.
> > > + * Refcounting wrappers for 'struct hyp_page'.
> > >   */
> > >  static inline int hyp_page_count(void *addr)
> > >  {
> > >       struct hyp_page *p =3D hyp_virt_to_page(addr);
> > >
> > > -     return p->refcount;
> > > +     return hyp_refcount_get(p->refcount);
> > >  }
> > >
> > >  static inline void hyp_page_ref_inc(struct hyp_page *p)
> > >  {
> > > -     BUG_ON(p->refcount =3D=3D USHRT_MAX);
> > > -     p->refcount++;
> > > +     hyp_refcount_inc(p->refcount);
> >
> > Adding a BUG_ON() for taking a reference on a non-refcounted page (i.e.
> > p->refcount was 0) would be nice, especially since we're past the point=
 of
> > serializing everything and you can theoretically have a zero count page
> > outside of the free list.
> >
> > Seems like otherwise we'd get actually hit the BUG_ON() in an unrelated
> > allocation path.

Actually, the refcount can be 0 without it being an error. For
example, when hyp pins memory shared with it by the host
(mem_protect.c:hyp_pin_shared_mem()).

Cheers,
/fuad

> Will do.
>
> Thanks,
> /fuad
> >
> > --
> > Thanks,
> > Oliver
