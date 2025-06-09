Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com [209.85.128.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC998226527
	for <kvmarm@lists.linux.dev>; Mon,  9 Jun 2025 23:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749510303; cv=none; b=h61jDPu9bMkMPYijniZZBhrfMurCZakoEzPcqNzGrwVv2lAHoj3HY9nlRZnwLI5OZlNX09cctEXiQXXNMVvF5YLRRVu0+8pXO/jqD9gyAdFxtU0JeRgn0LZD5v8+8j1DryPgaXTikseVJkJvCg8KSWHh/nttnXx4O5u+cjQJ9+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749510303; c=relaxed/simple;
	bh=8JQVGbTAqQUabzFe20anuyHGA4gpZl+ONkN6GLx8ymI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lKOc54G6hVFGatR04sW014PfucOksz2++ygsNvxRIhilyqr+k42/UB6fX7xbd0fk4fTt6+sZOAtupUJbDbEj+4X1iK6Qg0sa5Ph+0CBF7U+/6o+7NhVxN8axGlGbrDznS9N2hrsZN6RIWg3N1lmDY6u5LI3ogCUg/N47/xcPo1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Jm2WZKw5; arc=none smtp.client-ip=209.85.128.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Jm2WZKw5"
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-6ff4faf858cso31663157b3.2
        for <kvmarm@lists.linux.dev>; Mon, 09 Jun 2025 16:05:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749510301; x=1750115101; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q7+cVr8dsExjTk3ijrllXSzAu8Gblm5oL77kdyoH2ZE=;
        b=Jm2WZKw5xVxH04I8I0p81gTd8CcJiYUL71KaVCsVFSec0JJOKe/RuDWX4PhNUgBEIs
         rF3x4TzUtTzxlJZteAUN/ZktkllmMpjN6uxx2XXymr46N7YYb7DsHLHtHDm54Hck2+NM
         7hKJba0cMH4XCWML4YaInkt+8dVXLSfHGZLz2Xd/LMJZoVuk0HhHT1h02bE+YFYdEuEA
         K1fAEcn+BripJdfgulK1Jm4ao8nsGhc3gGmzDIFrL1FChkxfdRoyE226GuisNir4gBr4
         MUF4+hg9WfIYGoJTjYkzXkLYvHPxPozoa5J0+p0N8CFmD9eStFJXrTWgB8CvpinOYds/
         S10Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749510301; x=1750115101;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=q7+cVr8dsExjTk3ijrllXSzAu8Gblm5oL77kdyoH2ZE=;
        b=LotY3Qc30AhAnnPbGCAiZNILmKkBmcWcXhbuUxyi9xAgalltQVhHGaVCwRoaspWuI0
         iAqvF+lBBWvRBHXMqF2WZ1OSVH4xSkk00a3jfLOwQOCMeGtei6XawADct/hNLidG1ixF
         oiXoSnTdT7Rj2U+DDhsGNBU270m0gyzBMTNkkTfZ825JpfUrV0+6jPK7fC3zv8WuMYpD
         FhTgRHkM1UEeugG7tGM/xo85BjCH8n1cbJRZCgTSXosGOZfReM+w7Wx6umRE65iEZchJ
         DDrkK/xU3rOVZr9/PaWStR7UJY7h8/SUhHg9ivl9gHcr1LL85EkrdP1RhyAiu88FyqXC
         CCOA==
X-Forwarded-Encrypted: i=1; AJvYcCVXK11UKy4XXOhaHz57n/7GHsQDd31+4350YIEIsMLj2vmNF67Me0QFjcHSl5816aKhE1NCQR4=@lists.linux.dev
X-Gm-Message-State: AOJu0YxvPboBXD4sE3fpLNH1VKitvbKulQtgN1qd+kOJTAA39gKWAtd/
	bIP07saxMZTtu4FwGmEGM5nAo1ginsWgX0IusCJ5lyd1ULGGIfkTwAsvipVBjQMw7OgK2y/Uwi7
	sC7674O40a4xgGHXFBGfLErt6r9haxgqNbByDlsQp
X-Gm-Gg: ASbGncugCv6JXLL8wvNKlP6ckESxc3/TWjhPEUrEjLTOoDO05qVmlKucDHMAwWi8/LW
	LKK/0S8lXjBa6uezBQ6+lRfZr+5fLDg4EEI81daNNuwGhu7TzF4egD0Xf7AM40oHJZkrM5ZcF9a
	7TcDPj9KEmmj+wLcbTPmGQm5KY4H7sP8KmoHmgFJj9Ew26/43mvo85IPDyOTbHyCrqlwiyQpL5E
	w==
X-Google-Smtp-Source: AGHT+IHDN7yYiqZfvU9YYp0Xn0iNVyQLG2U2NkvCT1T2HFwTM8W1uiwWGtxc6CrVQKMfQxc4kQw9Dq00AIFK5/ldCts=
X-Received: by 2002:a05:690c:360e:b0:70d:f3bb:a731 with SMTP id
 00721157ae682-710f76949a7mr201808267b3.9.1749510300215; Mon, 09 Jun 2025
 16:05:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <aDdILHOu9g-m5hSm@google.com> <20250528201756.36271-1-jthoughton@google.com>
 <aDebZD1Kmmg15zs7@google.com>
In-Reply-To: <aDebZD1Kmmg15zs7@google.com>
From: James Houghton <jthoughton@google.com>
Date: Mon, 9 Jun 2025 16:04:24 -0700
X-Gm-Features: AX0GCFsscOLeJsC5afeLhStDd6O3F0bHoTP2OBA-juWmkL4Q85V0QPpPjCgJ_5E
Message-ID: <CADrL8HWwWN6tgV5ws8HMmeONmmhx_xS5ZSHgV7E6Cg=NDrqCTQ@mail.gmail.com>
Subject: Re: [PATCH v2 06/13] KVM: arm64: Add support for KVM_MEM_USERFAULT
To: Sean Christopherson <seanjc@google.com>
Cc: amoorthy@google.com, corbet@lwn.net, dmatlack@google.com, 
	kalyazin@amazon.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	pbonzini@redhat.com, peterx@redhat.com, pgonda@google.com, 
	wei.w.wang@intel.com, yan.y.zhao@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 28, 2025 at 4:25=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Wed, May 28, 2025, James Houghton wrote:
> > On Wed, May 28, 2025 at 1:30=E2=80=AFPM Sean Christopherson <seanjc@goo=
gle.com> wrote:
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index c5d21bcfa3ed4..f1db3f7742b28 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -2127,15 +2131,23 @@ void kvm_arch_commit_memory_region(struct kvm *=
kvm,
> >                                  const struct kvm_memory_slot *new,
> >                                  enum kvm_mr_change change)
> >  {
> > -     bool log_dirty_pages =3D new && new->flags & KVM_MEM_LOG_DIRTY_PA=
GES;
> > +     u32 old_flags =3D old ? old->flags : 0;
> > +     u32 new_flags =3D new ? new->flags : 0;
> > +
> > +     /*
> > +      * If only changing flags, nothing to do if not toggling
> > +      * dirty logging.
> > +      */
> > +     if (change =3D=3D KVM_MR_FLAGS_ONLY &&
> > +         !((old_flags ^ new_flags) & KVM_MEM_LOG_DIRTY_PAGES))
> > +             return;
> >
> >       /*
> >        * At this point memslot has been committed and there is an
> >        * allocated dirty_bitmap[], dirty pages will be tracked while th=
e
> >        * memory slot is write protected.
> >        */
> > -     if (log_dirty_pages) {
> > -
> > +     if (new_flags & KVM_MEM_LOG_DIRTY_PAGES) {
> >               if (change =3D=3D KVM_MR_DELETE)
> >                       return;
> >
> >
> > So we need to bail out early if we are enabling KVM_MEM_USERFAULT but
> > KVM_MEM_LOG_DIRTY_PAGES is already enabled, otherwise we'll be
> > write-protecting a bunch of PTEs that we don't need or want to WP.
> >
> > When *disabling* KVM_MEM_USERFAULT, we definitely don't want to WP
> > things, as we aren't going to get the unmap afterwards anyway.
> >
> > So the check we started with handles this:
> > > > > > +       u32 old_flags =3D old ? old->flags : 0;
> > > > > > +       u32 new_flags =3D new ? new->flags : 0;
> > > > > > +
> > > > > > +       /* Nothing to do if not toggling dirty logging. */
> > > > > > +       if (!((old_flags ^ new_flags) & KVM_MEM_LOG_DIRTY_PAGES=
))
> > > > > > +               return;
> >
> > So why also check for `change =3D=3D KVM_MR_FLAGS_ONLY` as well? Everyt=
hing I just
> > said doesn't really apply when the memslot is being created, moved, or
> > destroyed. Otherwise, consider the case where we never enable dirty log=
ging:
> >
> >  - Memslot deletion would be totally broken; we'll see that
> >    KVM_MEM_LOG_DIRTY_PAGES is not getting toggled and then bail out, sk=
ipping
> >    some freeing.
>
> No, because @new and thus new_flags will be 0.  If dirty logging wasn't e=
nabled,
> then there's nothing to be done.
>
> >  - Memslot creation would be broken in a similar way; we'll skip a bunc=
h of
> >    setup work.
>
> No, because @old and thus old_flags will be 0.  If dirty logging isn't be=
ing
> enabled, then there's nothing to be done.
>
> >  - For memslot moving, the only case that we could possibly be leaving
> >    KVM_MEM_LOG_DIRTY_PAGES set without the change being KVM_MR_FLAGS_ON=
LY,
> >    I think we still need to do the split and WP stuff.
>
> No, because KVM invokes kvm_arch_flush_shadow_memslot() on the memslot an=
d marks
> it invalid prior to installing the new, moved memslot.  See kvm_invalidat=
e_memslot().
>
> So I'm still not seeing what's buggy.

Sorry, I didn't see your reply, Sean. :(

You're right, I was confusing the KVM_MEM_USERFAULT and
KVM_MEM_LOG_DIRTY_PAGES. I'll undo the little change I said I was
going to make.

Thank you!
