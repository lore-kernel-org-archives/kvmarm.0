Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47CC8236F98
	for <kvmarm@lists.linux.dev>; Wed, 11 Dec 2024 10:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733911675; cv=none; b=Og4Heh316gywikG11j6tPanU9C1bVZcHf9D19K+lJT0m3dt/fLaIBoQjirJQG7xhuUxjhUnDC+o4QQwQ1xmkUtRJvrxW+e+Yw6474wMj5p4od7lBR+K0nCkYGoFHNDHOmhCjXVPU6/hC/OfZvTCtSqLEpHw1btXhNV4rz+CG/gc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733911675; c=relaxed/simple;
	bh=IzJHcTYEe6dNyeAoXCkYo1Oyp5gniRm+ej/UyY7tdNo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JWY1LXAKrsVeXqmo6adSoRhkce6PdhvIAHuapOir6RX3lU7cjocAgPDEocvjrYybfa29f/tqjZltVS7/2C3mTk1tq+Ac8jV4ypVshZ4YdaFbJl9R59NIqhdx0fL9HueQVCVFnWLNShaCa++Cr7FYEWWYoc8xBJJmOhKr7THFn9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4DlnKDHa; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4DlnKDHa"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-435b0df5dbdso28445e9.0
        for <kvmarm@lists.linux.dev>; Wed, 11 Dec 2024 02:07:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733911673; x=1734516473; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=x1c2ofmQLNeYYeju/JrDqhCfX9sIwSgC4rLZyCHsseg=;
        b=4DlnKDHaBgbNNHwFnWIioTXgBXNnAjcChL2VMK2MaY3TGEU/47ekvFy1bt6O395ue2
         lzFCPYvtt4sppaDOInHEcHnnWYvA7jrpg/GgFqX5sKoaQ+5EXJ/F3OhIypNopXkAzA8e
         Y3FFMiZzfu9Pzd1NjoJovL9TIXbF5BhnVJJbnP90aRb7wK7MFMYFxm8HUSRRpFa0OpZs
         +RqmfyWz6psj4RrpuconJmwY+5lwSc0F0c5+1OL88mM2KaN8AQi8ByjM5elHjc/DX72f
         J32qq4x2+yCleiQhHoJ+j30+ST8ciV5nRO7ZWUNaFsRefhFNoFQYb4EELmVN1JVAB2eI
         l6DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733911673; x=1734516473;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=x1c2ofmQLNeYYeju/JrDqhCfX9sIwSgC4rLZyCHsseg=;
        b=LfldFV221emdxjAuIIGTBPLcrqqDuifgQh8KofIf+t5kXZTl7w8bvyvaso70QRQHL2
         VSQKZ4gz91mWzxJCEsbwivBHKLXE8kk4rjHtrLsQ7afOJgG7ZwMKLBnZZ2ciZp6AHfsV
         bXapMuCO/GleI4AF4deImVbU0I5tnKZEuac6FdBiKeBCqJJkbrS74teaJfSaC+zKT7Mz
         jJKGhR2oS6ii+d5I6ztb4XY5x4vNpITB6SfLwI/ixitcMWJabo5iqDOodiKYkx4l7kFM
         y3YrVqgdp1KMLFlZikLXRds4biFo0qCvdWBSqYJMC8XBDQn+P27/Rt2yJginUospUnje
         R6zQ==
X-Forwarded-Encrypted: i=1; AJvYcCVUkYYxief3uj3cpqN04BGW1p1PTC/9bRcCrF0h2uuewrhP1RKTpja9r1QC11x08YRyh6n8gqM=@lists.linux.dev
X-Gm-Message-State: AOJu0YzhdggLTukig4sIbGQxy7ppS3vyzviRp+C51Cg9T8DuJpC4TqO+
	j6xOlPXVtln2nhR2YR+eH3HSvAZLW4SLDr3I0JGHozyIT/tnQTjd0TwzL0CM5MogrFLuy3BotAW
	AJYostW0O1n1/x7EMtLeMWPBPZ9PBwNXYPfqr
X-Gm-Gg: ASbGncvAbu46uah9p8a7BhqxyYKYVmWfwubkm+UR6E2n7YERCUnK8R97HNTvDJSks77
	IPpWMXTsHatGGL/6HFuJ7Loz0/63owM9ufgf+3sbRgN1DRZNKpa4cZV4v3lkTzU+o
X-Google-Smtp-Source: AGHT+IGEK/kmaBbvJg7dQQuM7x7JBMiV8OyKxexKpfiXpXx2u22fSrw6Y0U2iME6zU8KhU7EMyWrc0PbCi5O2GMxpU4=
X-Received: by 2002:a05:600c:2105:b0:434:9fac:3408 with SMTP id
 5b1f17b1804b1-4361c0f4f80mr1026945e9.2.1733911672546; Wed, 11 Dec 2024
 02:07:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241203103735.2267589-1-qperret@google.com> <20241203103735.2267589-11-qperret@google.com>
 <CA+EHjTwHSyQ1FJc7axbLNuBxSWpRVE6brb34nO+F59=QRmfQEg@mail.gmail.com>
 <Z1hhHRdpCZcLs046@google.com> <CA+EHjTw4GX3j_ssN-tWnf780xkvyKO5mBN6fnvXeWvQcBDmcNg@mail.gmail.com>
 <Z1liL3BtoPnSyvlh@google.com>
In-Reply-To: <Z1liL3BtoPnSyvlh@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 11 Dec 2024 10:07:16 +0000
Message-ID: <CA+EHjTw+3oAcp3ujjPmbcu42=95nw8WA=rZHYFL91ZK_Wfs_vA@mail.gmail.com>
Subject: Re: [PATCH v2 10/18] KVM: arm64: Introduce __pkvm_host_share_guest()
To: Quentin Perret <qperret@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Vincent Donnefort <vdonnefort@google.com>, 
	Sebastian Ene <sebastianene@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Wed, 11 Dec 2024 at 09:58, Quentin Perret <qperret@google.com> wrote:
>
> On Tuesday 10 Dec 2024 at 15:51:01 (+0000), Fuad Tabba wrote:
> > On Tue, 10 Dec 2024 at 15:41, Quentin Perret <qperret@google.com> wrote:
> > > > Initially I thought the comment was related to the warning below,
> > > > which confused me.
> > >
> > > It actually is about the warning below :-)
> > >
> > > > Now I think what you're trying to say is that we'll
> > > > allow the share, and the (unrelated to the comment) warning is to
> > > > ensure that the PKVM_PAGE_SHARED_OWNED is consistent with the share
> > > > count.
> > >
> > > So, the only case where the host should ever attempt do use
> > > __pkvm_host_share_guest() on a page that is already shared is for a page
> > > already shared *with an np-guest*. The page->host_share_guest_count being
> > > elevated is the easiest way to check that the page is indeed in that
> > > state, hence the warning.
> > >
> > > If for example the host was trying to share with an np-guest a page that
> > > is currently shared with the hypervisor, that check would fail. We can
> > > discuss whether or not we would want to allow it, but for now there is
> > > strictly no need for it so I went with the restrictive option. We can
> > > relax that constraint later if need be.
> > >
> > > > I think what you should have here, which would work better with the
> > > > comment, is something like:
> > > >
> > > >                 /* Only host to np-guest multi-sharing is tolerated */
> > > > +               if (pkvm_hyp_vcpu_is_protected(vcpu))
> > > > +                       return -EPERM;
> > > >
> > > > That would even make the comment unnecessary.
> > >
> > > I would prefer not adding this here, handle___pkvm_host_share_guest() in
> > > hyp-main.c already does that for us.
> >
> > I understand now, and I agree that an additional check isn't
> > necessary. Could you clarify the comment though? It's the word "only"
> > that threw me off, since to me it implied that the check was enforcing
> > the word "only". Maybe:
> >
> > >                 /* Tolerate host to np-guest multi-sharing. */
>
> I guess 'only' is somewhat important, it is the _only_ type of
> multi-sharing that we allow and the check enforces precisely that. The
> WARN_ON() will be triggered for any other type of multi-sharing, so we
> are really checking that _only_ np-guest multi-sharing goes through.
>
> Perhaps the confusing part is that the code as-is relies on WARN_ON()
> being fatal for the enforcement. Would it help if I changed the 'break'
> statement right after to 'fallthrough' so we proceed to return -EPERM?
> In practice we won't return anything as the hypervisor will panic, but
> I presume it is better from a logic perspective.

It would, but then we wouldn't be tolerating np-guest multisharing,
but like you said, it's not like we're tolerating it now anyway.

I wonder if it would be better simply not to allow multisharing at all for now.

Cheers,
/fuad


> Cheers,
> Quentin
