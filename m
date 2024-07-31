Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AADEC1FB4
	for <kvmarm@lists.linux.dev>; Wed, 31 Jul 2024 15:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722438084; cv=none; b=mP98QuW49r8adz09G/ajNOUrW50JTITALtrcXfFo30Zfng2wCYDLBf336uerdQoQBgdqOHZg63ZCjdg16pD+5GcwBssPnnYymlzCXKBAYpsCzjgLDxAvkK4VWiT9Zvn2SjwJX6iHnNraotu1tXaw7bOde1zVzGhGl1RKZXT8bq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722438084; c=relaxed/simple;
	bh=wUHLhFS9SdXHmqa3PQC6xsI/T85uU0FHGAHHTqH7qew=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WJC0szHoCwRkw5VaChPpqNsLubY3Ny32kQMWilEpS4TFgXlXXe9sjabumrxrIKhPEqD3EXzkDIg4GEgnHQqsHdi7QVEifK4KJerKgtG1PNHCayb6wDyLLsht6j+XqND0y9/zZaa0ap/yIFhZ+HhQVFC3uC7C0Fde1XyOvmCa2t8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JAo8+erZ; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JAo8+erZ"
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-6fd42bf4316so4015015a12.2
        for <kvmarm@lists.linux.dev>; Wed, 31 Jul 2024 08:01:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722438082; x=1723042882; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gNJBybQopQ2ZrxRweqcaE48I1KQGrUoMT3Gla2tgL0c=;
        b=JAo8+erZQTnDW8xpNUTMdh24EWsjByQpWJ+D+Fq8UI91x9NLxDlqsPs6rjk53qt6I3
         JydqqNHwLSZHRS7l/39RXP2Okg/CqViTLbLzbPqKzXowYAFHwIqdknsbckJL7YxAdluE
         Pj897obdoAjC7tDSSgtfUCaHr83FxlEV7wBzcpaOug4hKvRGpcyhD5KCv62sXpsNujwG
         3ovqNpAtH9RjWWh5WDVBd+5fy+cJ1VFMxGIdICnv/5SsYBSMeep6ACiUZ2doW1WJRs1F
         6uxmcYZTis5UbVZ50dm8fRjOC7xymPWfYFkKhizQbDRD6bx4hvqnl4KUTwPGlCigtz/m
         smCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722438082; x=1723042882;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=gNJBybQopQ2ZrxRweqcaE48I1KQGrUoMT3Gla2tgL0c=;
        b=nWvkmH7AxGOWeoud9vgE6ZXO1kDyhJemZHYGdxYqyxvwM8L5igiqrFaqB791Uxm9QB
         TWkztwGbms7C5Vim4sdPXGf5PjFj/2Jxw1O6zu6HaucKaScewwAtI7E41jL4Medwvk6u
         K2XX8Yitmejdb2gdvWso+QWTxqk7F5UQz04GZmoF3kTtDkdjKJchB8+JRZizVvbJgI31
         itvJ65aiODJ52/mwnGG7RAjMggNHPw6cWGzmTRWRAub0Hg7zhzxgypUZGrOOBjW0CPQ6
         zLg5RNi5wqzgJs2xd6WuRv7rXvO4x4ePuxZs8kHTXiD2VfQD/idOhvm6dXaoUpNjdD0b
         AZRw==
X-Forwarded-Encrypted: i=1; AJvYcCUm8XBko0Zqu2+aP9AOU2kvA++x2P//Kn4kpzqBoT/mwe4a5gzW+dqE9neDfwQELQAsImUV7VYkXn9TMPloxL7dnjaTjxl8
X-Gm-Message-State: AOJu0YyBLWyNk0uw13qZRZccfrc47xwE3oxqSBsbDrVNbVjT1dhzIrx/
	FVdEGfge6NO21e9yIklWlKRiH7/jyzg6Az8z9rau9wvHLzEmLAF/yFmj7nTiAU0292IlztSu7Hm
	Jcg==
X-Google-Smtp-Source: AGHT+IGcAn8E6dkVWW8sE36BP9jCnCmxK5HfcNcn6NYUeDPjrXiDSAMLJMNmKjWnCHzC8DBP855Q/NibcH4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a02:610:b0:7a1:6633:6a07 with SMTP id
 41be03b00d2f7-7ac8dcbb142mr75473a12.2.1722438081874; Wed, 31 Jul 2024
 08:01:21 -0700 (PDT)
Date: Wed, 31 Jul 2024 08:01:20 -0700
In-Reply-To: <87cymtdc0t.fsf@draig.linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240229025759.1187910-1-stevensd@google.com> <ZnXHQid_N1w4kLoC@google.com>
 <87cymtdc0t.fsf@draig.linaro.org>
Message-ID: <ZqpRwCKxVkDmmDB3@google.com>
Subject: Re: [PATCH v11 0/8] KVM: allow mapping non-refcounted pages
From: Sean Christopherson <seanjc@google.com>
To: "Alex =?utf-8?Q?Benn=C3=A9e?=" <alex.bennee@linaro.org>
Cc: David Stevens <stevensd@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Yu Zhang <yu.c.zhang@linux.intel.com>, Isaku Yamahata <isaku.yamahata@gmail.com>, 
	Zhi Wang <zhi.wang.linux@gmail.com>, Maxim Levitsky <mlevitsk@redhat.com>, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 31, 2024, Alex Benn=C3=A9e wrote:
> Sean Christopherson <seanjc@google.com> writes:
>=20
> > On Thu, Feb 29, 2024, David Stevens wrote:
> >> From: David Stevens <stevensd@chromium.org>
> >>=20
> >> This patch series adds support for mapping VM_IO and VM_PFNMAP memory
> >> that is backed by struct pages that aren't currently being refcounted
> >> (e.g. tail pages of non-compound higher order allocations) into the
> >> guest.
> >>=20
> >> Our use case is virtio-gpu blob resources [1], which directly map host
> >> graphics buffers into the guest as "vram" for the virtio-gpu device.
> >> This feature currently does not work on systems using the amdgpu drive=
r,
> >> as that driver allocates non-compound higher order pages via
> >> ttm_pool_alloc_page().
> >>=20
> >> First, this series replaces the gfn_to_pfn_memslot() API with a more
> >> extensible kvm_follow_pfn() API. The updated API rearranges
> >> gfn_to_pfn_memslot()'s args into a struct and where possible packs the
> >> bool arguments into a FOLL_ flags argument. The refactoring changes do
> >> not change any behavior.
> >>=20
> >> From there, this series extends the kvm_follow_pfn() API so that
> >> non-refconuted pages can be safely handled. This invloves adding an
> >> input parameter to indicate whether the caller can safely use
> >> non-refcounted pfns and an output parameter to tell the caller whether
> >> or not the returned page is refcounted. This change includes a breakin=
g
> >> change, by disallowing non-refcounted pfn mappings by default, as such
> >> mappings are unsafe. To allow such systems to continue to function, an
> >> opt-in module parameter is added to allow the unsafe behavior.
> >>=20
> >> This series only adds support for non-refcounted pages to x86. Other
> >> MMUs can likely be updated without too much difficulty, but it is not
> >> needed at this point. Updating other parts of KVM (e.g. pfncache) is n=
ot
> >> straightforward [2].
> >
> > FYI, on the off chance that someone else is eyeballing this, I am worki=
ng on
> > revamping this series.  It's still a ways out, but I'm optimistic that =
we'll be
> > able to address the concerns raised by Christoph and Christian, and may=
be even
> > get KVM out of the weeds straightaway (PPC looks thorny :-/).
>=20
> I've applied this series to the latest 6.9.x while attempting to
> diagnose some of the virtio-gpu problems it may or may not address.
> However launching KVM guests keeps triggering a bunch of BUGs that
> eventually leave a hung guest:

Can you give v12 (which is comically large) a spin?  I still need to do mor=
e
testing, but if it too is buggy, I definitely want to know sooner than late=
r.

Thanks!

https://lore.kernel.org/all/20240726235234.228822-1-seanjc@google.com
