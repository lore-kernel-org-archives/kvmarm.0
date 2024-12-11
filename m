Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4930236F98
	for <kvmarm@lists.linux.dev>; Wed, 11 Dec 2024 10:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733912098; cv=none; b=l7tPCzWEC1oo8xmQRLM0uC7ujL/7docQ+KUW2XknkGtqoGMjxE6VnKxUjiK+eVS54iZhLiCP32izmcaURLlaWkQxFdBi7fPoV7M/p1RFCp/XtNrYQxkU7u3sg63QgbCdAFRIUcjcWDEDHFPTruORP1hXPIRrZTDVuNcH2/lg4sw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733912098; c=relaxed/simple;
	bh=8kPuR/R4ZmuxjLQhM3C4+YPUUpyXPzxmYEFgc4jJ63Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DXURn/TlL4Wt1g0hn5ervkes2CBfJrEV8gSJBcn8ROD9IHL3NoSxLeXOAqHQFQG2stYTjB5bky80z159GLQS03KdWbsbLJeFl25dkVOXEcLSQjVUrPldP6l0JYCyGdJonFgnEJUHQH2zsF3K6cXf06R2KwtXAA18h14vz2RbLyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=F4pBhHHs; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="F4pBhHHs"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-a9ec267b879so1283927566b.2
        for <kvmarm@lists.linux.dev>; Wed, 11 Dec 2024 02:14:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733912095; x=1734516895; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=aAYNlgaGtbIb3faMoAC6BM9L0RPwmWJIn6sYTEEwFWM=;
        b=F4pBhHHsdF8qeYaVYYcMjbkCwcQZ0IpLlnY86bZJ5JNWPdwF87Cd2KUKnz33OHSpdE
         inO3epWVvJatxv0PauGxIpSRkd0y8IQMWmzHR7XR73v5o/q7y8u2L2hMaft2CNicbi9C
         tkUSzXIS8Vssqrt3uKijftwWBcVNDSa3ZSt/JvhhSkkNxgnos7vr+rHVMaNTaznfk2JK
         6As0S7lO4VeBTJhCeJkvbllpoQviLlk5MrX5tGeO3iyN0Tr0zjBVdHyDnOqXUBBBR4ys
         Ltl1Hiprxh+IkusktDmsJe49NuNYmy+yhfwZprQV5fhUaHhualJRTI05jNsjRAsBy2kO
         FhYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733912095; x=1734516895;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aAYNlgaGtbIb3faMoAC6BM9L0RPwmWJIn6sYTEEwFWM=;
        b=B8huuMMfCFwPzglIgDZmib2g2KAZF2UVxDiBjc8CIoYMOn4aApfiI4/iQfUkX1ihjb
         Pcb4bETIMUA0m6szRevsSv8/8E0AiSxwWGaZ85exbD51/+B+xJkqITUwRG/tSHIA6RLP
         YYL4Pt+RbZRbrE0Hc3TZ3ofzpq9Zsd7zfeyuSdQx6L/+TvGBTx1c2xzfou7xl4+0YFID
         sAnBwjsaIlqw8BN5sLWMNCFRCyaVWSiUghuOvWpcTZQCo17Z495DnNPLs+Q5hfXGoKH8
         cpTprRfdUPhjI5uVsppMV+BVG6sBydVu69AQRimM+0j7J163bIMPUNklsyDM2SHdp13m
         vxRg==
X-Forwarded-Encrypted: i=1; AJvYcCWIYmKvmStqkmhjHtfJL9Vd2zTbvuG5WlzUEAT8IOgNyQUENfJgj30umolCM9JFjoVUlhxLAtU=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzh3idoIa9yUKyujixun4X7ZKnFQVZVA3jevcfA7tmZg0djenjY
	PbKDiEYSN3SU2OAkJVHXfYr1ODuVXv7oA9sk7hlQBKCidlnDC3Ep2kv2o611Xw==
X-Gm-Gg: ASbGncuflccHm9h73jol3+kOiGZ0KyuwAMxsARyNpq0G7U/PrDHCYi2+qktK5utY9Hw
	g6KY4P0v9xoUA507hH/zSINpxW4tWLmyYp+0Lyg8FFJ5ulQLpLRfGucwNDMsy07sRU06eV4ExcX
	htr7tYj7Ef9nzyjTapQCG9TpVhgIH0EIcD7DuVEkR/AxlSApJ41DM7mzYD4unm5R/yqLTDknwDP
	oo5Ey89HgI4ODPXg6iYhmgYj5X6v4shqKJ5rpxCOvl81naxqVHpPj3cGvf+B3OCk9J/3v0pq6FC
	1EZ6KBiUJnXN
X-Google-Smtp-Source: AGHT+IFMcTlkeGboQKqbrDdMcECPHEth8gqU16Ievc6ebB6cHKDKOmVuqDalLIEjr7JcNgbRfs9Dnw==
X-Received: by 2002:a17:907:1587:b0:aa6:6e02:e885 with SMTP id a640c23a62f3a-aa6b13b1375mr155243166b.47.1733912095003;
        Wed, 11 Dec 2024 02:14:55 -0800 (PST)
Received: from google.com (61.134.90.34.bc.googleusercontent.com. [34.90.134.61])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa67557f0desm553688466b.144.2024.12.11.02.14.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Dec 2024 02:14:54 -0800 (PST)
Date: Wed, 11 Dec 2024 10:14:51 +0000
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
Message-ID: <Z1lmG-3KnOZrOCCa@google.com>
References: <20241203103735.2267589-1-qperret@google.com>
 <20241203103735.2267589-11-qperret@google.com>
 <CA+EHjTwHSyQ1FJc7axbLNuBxSWpRVE6brb34nO+F59=QRmfQEg@mail.gmail.com>
 <Z1hhHRdpCZcLs046@google.com>
 <CA+EHjTw4GX3j_ssN-tWnf780xkvyKO5mBN6fnvXeWvQcBDmcNg@mail.gmail.com>
 <Z1liL3BtoPnSyvlh@google.com>
 <CA+EHjTw+3oAcp3ujjPmbcu42=95nw8WA=rZHYFL91ZK_Wfs_vA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EHjTw+3oAcp3ujjPmbcu42=95nw8WA=rZHYFL91ZK_Wfs_vA@mail.gmail.com>

On Wednesday 11 Dec 2024 at 10:07:16 (+0000), Fuad Tabba wrote:
> On Wed, 11 Dec 2024 at 09:58, Quentin Perret <qperret@google.com> wrote:
> >
> > On Tuesday 10 Dec 2024 at 15:51:01 (+0000), Fuad Tabba wrote:
> > > On Tue, 10 Dec 2024 at 15:41, Quentin Perret <qperret@google.com> wrote:
> > > > > Initially I thought the comment was related to the warning below,
> > > > > which confused me.
> > > >
> > > > It actually is about the warning below :-)
> > > >
> > > > > Now I think what you're trying to say is that we'll
> > > > > allow the share, and the (unrelated to the comment) warning is to
> > > > > ensure that the PKVM_PAGE_SHARED_OWNED is consistent with the share
> > > > > count.
> > > >
> > > > So, the only case where the host should ever attempt do use
> > > > __pkvm_host_share_guest() on a page that is already shared is for a page
> > > > already shared *with an np-guest*. The page->host_share_guest_count being
> > > > elevated is the easiest way to check that the page is indeed in that
> > > > state, hence the warning.
> > > >
> > > > If for example the host was trying to share with an np-guest a page that
> > > > is currently shared with the hypervisor, that check would fail. We can
> > > > discuss whether or not we would want to allow it, but for now there is
> > > > strictly no need for it so I went with the restrictive option. We can
> > > > relax that constraint later if need be.
> > > >
> > > > > I think what you should have here, which would work better with the
> > > > > comment, is something like:
> > > > >
> > > > >                 /* Only host to np-guest multi-sharing is tolerated */
> > > > > +               if (pkvm_hyp_vcpu_is_protected(vcpu))
> > > > > +                       return -EPERM;
> > > > >
> > > > > That would even make the comment unnecessary.
> > > >
> > > > I would prefer not adding this here, handle___pkvm_host_share_guest() in
> > > > hyp-main.c already does that for us.
> > >
> > > I understand now, and I agree that an additional check isn't
> > > necessary. Could you clarify the comment though? It's the word "only"
> > > that threw me off, since to me it implied that the check was enforcing
> > > the word "only". Maybe:
> > >
> > > >                 /* Tolerate host to np-guest multi-sharing. */
> >
> > I guess 'only' is somewhat important, it is the _only_ type of
> > multi-sharing that we allow and the check enforces precisely that. The
> > WARN_ON() will be triggered for any other type of multi-sharing, so we
> > are really checking that _only_ np-guest multi-sharing goes through.
> >
> > Perhaps the confusing part is that the code as-is relies on WARN_ON()
> > being fatal for the enforcement. Would it help if I changed the 'break'
> > statement right after to 'fallthrough' so we proceed to return -EPERM?
> > In practice we won't return anything as the hypervisor will panic, but
> > I presume it is better from a logic perspective.
> 
> It would, but then we wouldn't be tolerating np-guest multisharing,
> but like you said, it's not like we're tolerating it now anyway.
> 
> I wonder if it would be better simply not to allow multisharing at all for now.

That would mean turning off MMU notifiers in the host and taking
long-term GUP pins on np-guest pages I think. Multi-sharing can be
caused by many things, KSM, the zero page ... so we we'd need to turn
all of that off (IOW, no MMU notifiers).

That's more or less the status quo in Android, but I vote for not going
down that path upstream. pKVM should ideally be transparent for np-guest
support if at all possible.

Thanks,
Quentin
