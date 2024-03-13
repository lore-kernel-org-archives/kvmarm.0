Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F515446BA
	for <kvmarm@lists.linux.dev>; Wed, 13 Mar 2024 13:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710336847; cv=none; b=clLiTDsVVzcwavzgguL362WGAp0cyK69Xn8/yN6ERwFX477T+GZ95R7/dPU7xFrhtvjNRjDpTuuNFYBvMqTirt5frgXABLQR4uf/TeGTbqmRXTeQPRYDocLqo1C/Ei6TArjKdSczpIin9rs26O7bCygIrCzEUjEgw7yuwSMpNuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710336847; c=relaxed/simple;
	bh=YtYXHrh16rFL2dlK6AeuHKPIT11j+xPYazuoPkbjZLc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gPwsAoXWSe4eCbg2N4/kOY5bnW/OkL/m+eV4I8UXtTW80VbpkoDHSbiwXmnbFOPNA+iJAl1XoeVv7A+Gn4ocEOGfFYx8cb5DXB62Z0HeQx8AEC4wtgC9U+jNNKTPe9a/whiicYsDhK7j8g5gqZxNr5wHxNmPAfr32S23hadEs9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GPt6xbkd; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GPt6xbkd"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-60a04bc559fso84277677b3.2
        for <kvmarm@lists.linux.dev>; Wed, 13 Mar 2024 06:34:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710336845; x=1710941645; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EeDuCrW/OzuKfmQ7trx25bc/3MeStGmMLBCg0AQiaHs=;
        b=GPt6xbkd5qpB5gIRrCmdl0Jz2z2u9uYFa45dR4PVovS5ntneoiGTmWOVfcvQg17Pid
         ErNEbtWpBc9KrDOsayQ4W5u4+qSRrCPcI/ah4m6qSxmzj250dqOOJPT7zGz1r+KwAuM0
         /GaHPrYpPCnlHkV0nQZOZxmA8dW6UOdAYZE9+rVco3b63QvsIoqt7igyQ72nhWDNYvVq
         sKSYOsPEaLDguG1nlUW41azp8WIJJWada5tECH9ScIwASOtUVehqGx9J6IeDzuj8kaH7
         S2D9lImXJsjxVTy9E7o2oTphNZfEJDZ9QK4bBFZ5MIJlZCXq5fmcxUEVIv26cN1ta3H0
         R2bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710336845; x=1710941645;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=EeDuCrW/OzuKfmQ7trx25bc/3MeStGmMLBCg0AQiaHs=;
        b=ZethIr6VVQuHDkU3+1JvnsaLD/YkVWZcALz2WTjMmqvT6hLxuLxDibfs3zmnjuWwpg
         cfX6c8/9+s5ayfjTf87q5GeYmusVavPvgWeQAaf76oeKM6KSQqE/kxJ4uAJ2aDoe31Sr
         GNT2iYuV7mkTet3xnQfU/0G5UYpJOPQaEhk1UXRUobT2xXfgNCxq9xDD0750Jvsz15yH
         gJrKe6a4m3mwq0gCBIhjHUrR4Wh2xvwHLrCHUnZHvh8e3X7pAaeZybr5xgcawhykUFis
         hjZze8PbFC5G1tmM90fOlihYu/nEC+sC3E6QhawdURVGLSK6BL4R5IjZBaGifX4Zu8PE
         wpbQ==
X-Forwarded-Encrypted: i=1; AJvYcCWjv9OgMPOxZG6e8RQPc37Kjx0aFXrYifEi7wV+WjVf1qLhWD2chE20b31KOocgchm/HnlCMEAJiY9hYyNtMLXNnfbKF/En
X-Gm-Message-State: AOJu0YwQNQGAxOAvfB6IwvNS3pMHSl5OAJKUf3hXSPO+sR5zcTCQT8w/
	qLnPnTGdqmwYjdqJCNAYwrldSxtl74s9/7Db4CzDnKCtoup7kZqScil+XKlI0eQjKT1Bz6JoPPU
	yMA==
X-Google-Smtp-Source: AGHT+IGzeTp0Kd/KVSxA1L/KjVh99PquENLfknjJ/YqzT8MDcFuAl63vKayUBQvut1tAWWM0sBlPgMKxY1Y=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:9251:0:b0:60c:b1d4:a9f9 with SMTP id
 j78-20020a819251000000b0060cb1d4a9f9mr277116ywg.10.1710336845403; Wed, 13 Mar
 2024 06:34:05 -0700 (PDT)
Date: Wed, 13 Mar 2024 06:34:03 -0700
In-Reply-To: <72285e50-6ffc-4f24-b97b-8c381b1ddf8e@amd.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240229025759.1187910-1-stevensd@google.com> <ZeCIX5Aw5s1L0YEh@infradead.org>
 <CAD=HUj7fT2CVXLfi5mty0rSzpG_jK9fhcKYGQnTf_H8Hg-541Q@mail.gmail.com> <72285e50-6ffc-4f24-b97b-8c381b1ddf8e@amd.com>
Message-ID: <ZfGrS4QS_WhBWiDl@google.com>
Subject: Re: [PATCH v11 0/8] KVM: allow mapping non-refcounted pages
From: Sean Christopherson <seanjc@google.com>
To: "Christian =?utf-8?B?S8O2bmln?=" <christian.koenig@amd.com>
Cc: David Stevens <stevensd@chromium.org>, Christoph Hellwig <hch@infradead.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Yu Zhang <yu.c.zhang@linux.intel.com>, 
	Isaku Yamahata <isaku.yamahata@gmail.com>, Zhi Wang <zhi.wang.linux@gmail.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 13, 2024, Christian K=C3=B6nig wrote:
> Am 13.03.24 um 05:55 schrieb David Stevens:
> > On Thu, Feb 29, 2024 at 10:36=E2=80=AFPM Christoph Hellwig <hch@infrade=
ad.org> wrote:
> > > On Thu, Feb 29, 2024 at 11:57:51AM +0900, David Stevens wrote:
> > > > Our use case is virtio-gpu blob resources [1], which directly map h=
ost
> > > > graphics buffers into the guest as "vram" for the virtio-gpu device=
.
> > > > This feature currently does not work on systems using the amdgpu dr=
iver,
> > > > as that driver allocates non-compound higher order pages via
> > > > ttm_pool_alloc_page().
> > > .. and just as last time around that is still the problem that needs
> > > to be fixed instead of creating a monster like this to map
> > > non-refcounted pages.
> > >=20
> > Patches to amdgpu to have been NAKed [1] with the justification that
> > using non-refcounted pages is working as intended and KVM is in the
> > wrong for wanting to take references to pages mapped with VM_PFNMAP
> > [2].
> >=20
> > The existence of the VM_PFNMAP implies that the existence of
> > non-refcounted pages is working as designed. We can argue about
> > whether or not VM_PFNMAP should exist, but until VM_PFNMAP is removed,
> > KVM should be able to handle it. Also note that this is not adding a
> > new source of non-refcounted pages, so it doesn't make removing
> > non-refcounted pages more difficult, if the kernel does decide to go
> > in that direction.
>=20
> Well, the meaning of VM_PFNMAP is that you should not touch the underlyin=
g
> struct page the PTE is pointing to. As far as I can see this includes
> grabbing a reference count.
>=20
> But that isn't really the problem here. The issue is rather that KVM assu=
mes
> that by grabbing a reference count to the page that the driver won't chan=
ge
> the PTE to point somewhere else.. And that is simply not true.

No, KVM doesn't assume that.

> So what KVM needs to do is to either have an MMU notifier installed so th=
at
> updates to the PTEs on the host side are reflected immediately to the PTE=
s
> on the guest side.

KVM already has an MMU notifier and reacts accordingly.

> Or (even better) you use hardware functionality like nested page tables s=
o
> that we don't actually need to update the guest PTEs when the host PTEs
> change.

That's not how stage-2 page tables work.=20

> And when you have either of those two functionalities the requirement to =
add
> a long term reference to the struct page goes away completely. So when th=
is
> is done right you don't need to grab a reference in the first place.

The KVM issue that this series is solving isn't that KVM grabs a reference,=
 it's
that KVM assumes that any non-reserved pfn that is backed by "struct page" =
is
refcounted.

What Christoph is objecting to is that, in this series, KVM is explicitly a=
dding
support for mapping non-compound (huge)pages into KVM guests.  David is arg=
uing
that Christoph's objection to _KVM_ adding support is unfair, because the r=
eal
problem is that the kernel already maps such pages into host userspace.  I.=
e. if
the userspace mapping ceases to exist, then there are no mappings for KVM t=
o follow
and propagate to KVM's stage-2 page tables.
