Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98EF81EC4D5
	for <kvmarm@lists.linux.dev>; Wed, 11 Dec 2024 10:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733912520; cv=none; b=P+JYFmYQxgkzJD7L3FuUlVO3MZmh6bL/fPZJNgwL1N3zoDp6Lxo3EwBeECa3GUnb5YMDvGyifN6Ir+vhldc3di/Fd8AWYpfILlGLx6DY/fPkfbAbXgKK8xFxNzQc/WI531iGHgtgmxsy8KO6B5VHA8YbCyH8UV2cHa0Dd8XjAYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733912520; c=relaxed/simple;
	bh=1ajsGx5epWGwETVA1PUvGD6fRkYAWzEtK6sJbfZFdYU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z5I71uPDzyXAYwmNsiErQV8p4WtbESJVyQ4E3crOIPOYJtv1BRjZ3i2u74HY3hIOEsV1LGFwN2dTFqf9Dh42v7nVdLq4QQxR87MpgeQW1XSGumNKEBTPtVclbN7N+7T0WzTKcW7F3E6gcd5v4//ejWvcfWXhUkKgV+jB/wyU5nY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aABLq3dH; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aABLq3dH"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-5d0ac27b412so8501849a12.1
        for <kvmarm@lists.linux.dev>; Wed, 11 Dec 2024 02:21:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733912517; x=1734517317; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=h/i8dNvXTaun9z8Q9pOEyBWkakhPhjAhJI5wRL2G2nQ=;
        b=aABLq3dHIIcSA5sqowPUF8JNKqEsddz9PXpPjNu5+RZm6gjf0/89aqrY9N44KgFRHN
         r/78z6NfnY51FMmUkBGaZPyr6+kd1ZrUDazFvyjAKNc9Xqe1EH+GDmuXShRdREOjCNbm
         UUP3HTKabp3Mk1LYjbJSiRt4YALkqnSMacmXOCf25z9kveMgGzLlEV1D3r/WKO8a1qjp
         /Yuz74J4dHPq0zo4JIJwlb577x5g0cjP2tfZFLeOcZoa+mBT9a1e6z4I3LvIitZar1Hl
         GXdtm4lKK8kD8vEfkdSJm3Uc2D0/xZ/W25/pLXBS2dmOK6WxkPM2iAAeWGMh546j85BP
         8z/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733912517; x=1734517317;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h/i8dNvXTaun9z8Q9pOEyBWkakhPhjAhJI5wRL2G2nQ=;
        b=f6DfBF66plhco+idC5hOc/qoAS0qMhYeN/BpE+1bOBtjBJum4jxxvnPdtYqfJ2/V6Z
         gZWZxHZT7d62N2umh2qpbCPlppyRoLdyDzrV7JwfgD28+Bfy2q0TkxvEUkyLsEhcOYba
         /m6Dn/TFWqQU/iisJNNmuS7GmAgvl/ig6lRc7nRkpR8oA9QQHjMpbUdNGFLQD9pPdR75
         WGad116UuGEG68HvUKZ8x0NzlW2VlEP/xr6lD2DJSQUNOBf0i4mb297ovfgvaOEL2kFM
         1aeiSkmbTuQTSz1IcOHYg3eu0FkxumDPDkbvbhefb86iFbXZ8/05QwLg+/dc/ApDjwjA
         gf4Q==
X-Forwarded-Encrypted: i=1; AJvYcCUuQ4R60RXOEpT9GLUKNo8ZxyxmNBQUi0+9BsczuVAbNlpschrnlcL0JrYwzcpqRyKBuy4DUW8=@lists.linux.dev
X-Gm-Message-State: AOJu0YzO9mjBsBvNxYCXXBeMrpF4CwvJcdDBngtTAnGYy5Pv5xScIyYO
	2pmWFAJD/ngTvNAvv4M6xdGofi47/MYqpXMnv8PX8tJARaoyHqfVrJZEK+0HRA==
X-Gm-Gg: ASbGncu9wV2fzI9LnoXqe5M8S1sQpULKgp6reEFqz2EQQ76PLUm7wuURZ5kGCZUBmnw
	ctoDsbQPYuMCxxK9ttVXAvkvjg6ZDf2vlbrVrLszf125Z6TlBC7SsBaZKSy5gx0OW4S41e8gXLk
	YzZp2r3hMud5BdHCA7WRuywNUnnnTfED7O3OV/E5nPJ0HnU50KR3T0V2y+5b6/QRNAfMo0gIcfP
	GmFXEfQuJ0N1vVI+Na+kN0hEqCVXSG0WTpNrSFuG13ofi74JYSsMskaGLI7B8LP/cglxznldIEJ
	0Gh+OY9myiM4
X-Google-Smtp-Source: AGHT+IELT5UzTgOIXuU7LZ69/dEjIwcPQX35BOSNVLAIcwuMifyoSthPeY6StXkxja6PnQSGI29ikg==
X-Received: by 2002:a05:6402:3806:b0:5d2:7396:b0ca with SMTP id 4fb4d7f45d1cf-5d4330a5108mr2074782a12.12.1733912516917;
        Wed, 11 Dec 2024 02:21:56 -0800 (PST)
Received: from google.com (61.134.90.34.bc.googleusercontent.com. [34.90.134.61])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5d3d871f1c8sm6587655a12.13.2024.12.11.02.21.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Dec 2024 02:21:56 -0800 (PST)
Date: Wed, 11 Dec 2024 10:21:53 +0000
From: Quentin Perret <qperret@google.com>
To: Fuad Tabba <tabba@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Vincent Donnefort <vdonnefort@google.com>,
	Sebastian Ene <sebastianene@google.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 10/18] KVM: arm64: Introduce __pkvm_host_share_guest()
Message-ID: <Z1lnwZPrx9GzgFCG@google.com>
References: <20241203103735.2267589-1-qperret@google.com>
 <20241203103735.2267589-11-qperret@google.com>
 <CA+EHjTwHSyQ1FJc7axbLNuBxSWpRVE6brb34nO+F59=QRmfQEg@mail.gmail.com>
 <Z1hhHRdpCZcLs046@google.com>
 <CA+EHjTw4GX3j_ssN-tWnf780xkvyKO5mBN6fnvXeWvQcBDmcNg@mail.gmail.com>
 <Z1liL3BtoPnSyvlh@google.com>
 <CA+EHjTw+3oAcp3ujjPmbcu42=95nw8WA=rZHYFL91ZK_Wfs_vA@mail.gmail.com>
 <Z1lmG-3KnOZrOCCa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z1lmG-3KnOZrOCCa@google.com>

On Wednesday 11 Dec 2024 at 10:14:51 (+0000), Quentin Perret wrote:
> On Wednesday 11 Dec 2024 at 10:07:16 (+0000), Fuad Tabba wrote:
> > On Wed, 11 Dec 2024 at 09:58, Quentin Perret <qperret@google.com> wrote:
> > >
> > > On Tuesday 10 Dec 2024 at 15:51:01 (+0000), Fuad Tabba wrote:
> > > > On Tue, 10 Dec 2024 at 15:41, Quentin Perret <qperret@google.com> wrote:
> > > > > > Initially I thought the comment was related to the warning below,
> > > > > > which confused me.
> > > > >
> > > > > It actually is about the warning below :-)
> > > > >
> > > > > > Now I think what you're trying to say is that we'll
> > > > > > allow the share, and the (unrelated to the comment) warning is to
> > > > > > ensure that the PKVM_PAGE_SHARED_OWNED is consistent with the share
> > > > > > count.
> > > > >
> > > > > So, the only case where the host should ever attempt do use
> > > > > __pkvm_host_share_guest() on a page that is already shared is for a page
> > > > > already shared *with an np-guest*. The page->host_share_guest_count being
> > > > > elevated is the easiest way to check that the page is indeed in that
> > > > > state, hence the warning.
> > > > >
> > > > > If for example the host was trying to share with an np-guest a page that
> > > > > is currently shared with the hypervisor, that check would fail. We can
> > > > > discuss whether or not we would want to allow it, but for now there is
> > > > > strictly no need for it so I went with the restrictive option. We can
> > > > > relax that constraint later if need be.
> > > > >
> > > > > > I think what you should have here, which would work better with the
> > > > > > comment, is something like:
> > > > > >
> > > > > >                 /* Only host to np-guest multi-sharing is tolerated */
> > > > > > +               if (pkvm_hyp_vcpu_is_protected(vcpu))
> > > > > > +                       return -EPERM;
> > > > > >
> > > > > > That would even make the comment unnecessary.
> > > > >
> > > > > I would prefer not adding this here, handle___pkvm_host_share_guest() in
> > > > > hyp-main.c already does that for us.
> > > >
> > > > I understand now, and I agree that an additional check isn't
> > > > necessary. Could you clarify the comment though? It's the word "only"
> > > > that threw me off, since to me it implied that the check was enforcing
> > > > the word "only". Maybe:
> > > >
> > > > >                 /* Tolerate host to np-guest multi-sharing. */
> > >
> > > I guess 'only' is somewhat important, it is the _only_ type of
> > > multi-sharing that we allow and the check enforces precisely that. The
> > > WARN_ON() will be triggered for any other type of multi-sharing, so we
> > > are really checking that _only_ np-guest multi-sharing goes through.
> > >
> > > Perhaps the confusing part is that the code as-is relies on WARN_ON()
> > > being fatal for the enforcement. Would it help if I changed the 'break'
> > > statement right after to 'fallthrough' so we proceed to return -EPERM?
> > > In practice we won't return anything as the hypervisor will panic, but
> > > I presume it is better from a logic perspective.
> > 
> > It would, but then we wouldn't be tolerating np-guest multisharing,
> > but like you said, it's not like we're tolerating it now anyway.
> > 
> > I wonder if it would be better simply not to allow multisharing at all for now.
> 
> That would mean turning off MMU notifiers in the host and taking
> long-term GUP pins on np-guest pages I think. Multi-sharing can be
> caused by many things, KSM, the zero page ... so we we'd need to turn
> all of that off (IOW, no MMU notifiers).
> 
> That's more or less the status quo in Android, but I vote for not going
> down that path upstream. pKVM should ideally be transparent for np-guest
> support if at all possible.

And to clarify my suggestion above, we should fallthrough IFF
host_share_guest_count is 0, but break otherwise to retain multi-sharing
support. So it's not a simple s/break/fallthrough change, that needs a
tiny bit of added logic.
