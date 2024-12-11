Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D66701E9B03
	for <kvmarm@lists.linux.dev>; Wed, 11 Dec 2024 09:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733911094; cv=none; b=hphiT4225mGw0tuyobKkbUko9USxPFf/o+1z80c6/jhKm3loMBuBO72uZwDTNyoz+SuCTozNP2MrNzRXP/WuFNRrj4KPXpBPlmqo5JPVxWKr0gSKVcET1GqDYjIeesD5G/WPykROY5kFvILumio/X3YvjJVGeq0zK/cZp5UNyMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733911094; c=relaxed/simple;
	bh=y55wIex4pQa90iKPixPdpPl4dg3F27VPnM0gGblWQU0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lsc644qNFOIc4PZtgV9/P6/VWWm3twnFxnE749xJo7Ym7IWssLvIw51aR73d6SEKgoUlJVuRf9h/CnIFlHW4LFBHF/BA6Q7iPdmmmaGZV02V6bJZjUj4w2iKiVITd0GvYdaB8/DvVivMFzw0QiK8gTK5u6gsNfE7tHNCWD3Vd2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=x0ClyGFQ; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="x0ClyGFQ"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-aa696d3901bso502292166b.1
        for <kvmarm@lists.linux.dev>; Wed, 11 Dec 2024 01:58:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733911091; x=1734515891; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=NoxTFED1OV6IIvC50S+pNWi2oVo0JYbWqlKUFL/WbNs=;
        b=x0ClyGFQMT8LlqkAp+0VFWhrfoWPXSKThXBimiCSxZYtfYtOhKttJpX7k4KbXDwMWN
         6iEW+cjSI2dOCU9HEpF6Vyr21y3oMMI8ruwACD2WWJkHzD4Jp6H62c00i7M+dev1pr8/
         OPQ6cpxV74SakQe4/KsqNqJ+t4bSPgEPzz/ZmHFraaOdfzTYLVcnX2IDvlztaJA1NRcJ
         Wg2susPyb5z+wJLHTstJPwB1drWHEDvWlJb+9Wl0kWrmoH0Nu+42+f2JgONVoSgN/Hzu
         O987HhrAA21FV4P6yaZ3UYntYESKyt349qSAW0ecqQbE529ZPTG9vQwdumPc2luaK+NN
         2neQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733911091; x=1734515891;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NoxTFED1OV6IIvC50S+pNWi2oVo0JYbWqlKUFL/WbNs=;
        b=sZsAnVMGcJOU66RYkulXrz8Czg7yMGP8exN189fArCeZMC3+m/pjRrrXAWictsVawC
         +zH59O2htnKcFjVFHjP/7tDZlxFu1mB1vCpQuIQkX97DR4aJwGwkA5dLPeDopCdFgB+1
         TEErbfb3GSrOX/OT1VpOR2uit7BzkCZbu+QfLcxgwjeCt8WqHZbZnOwpzwrau2ZC9qm4
         uSWRWl525cFkxYRCuff/ZnhwQpKw9zF3RtfoeQ1ckkrV4lQlD47y+cpPwU/sYMb2vrCO
         uTzbbe13PIJz1GNqy6ctU4J2yrbrQ3D6iHpJFP2X4Dz8fa2jxxHzS3adYj92czBVgy0m
         mm6g==
X-Forwarded-Encrypted: i=1; AJvYcCX0GayKEZvpLBXS8htZ24sUmaTHxcNwZNV62/zkRHrdXkT7ImrxqgXRXoMH1D/a3Y2Ieyb+Xk4=@lists.linux.dev
X-Gm-Message-State: AOJu0YzIvNikMfzbcDmiKeJ45/6N90qs47rPwqnDOjC5A4hTfwJCQka1
	yszkUcaRYb7JtfcwIiLfjJCnuo9jPbzRukCA1JNHONPkDSb5BJrFwUDOer/RcPOxfZMhUmHzpUO
	C36rs
X-Gm-Gg: ASbGncsqcMr7kWp8WDja+IgvWMD5LqHh2W57EoWHF+SYnRH9dUMrSdr0W6niDcYTx/K
	t0hrS7HBlWsvPjzdGIA6//aGaEfVbjv7MnYyqBu/g3JjOxet+bhrz4IPBzRmvKXefDxyPN6NYi0
	jNGFYJQrRB7HLQu74kSlObbnODmFmo8OYWNk+vYCLALtyjXtqRbwtg7R8dHbVGlB/47SqWH24/K
	89bxtUquvik3nk+DCFIB9oyfpBAbONgnF8I1vr+LYfsIx1NPXUk90DEZmTMfarBxuQUlej4W33b
	Dwc4gsa+p+m8
X-Google-Smtp-Source: AGHT+IF/0ntKZsypMhJqLoHZz7Y4KeXzGESSzQOBIbmcxUlmHH3DEZpbKATmONAsAAvwZztD3FrYtg==
X-Received: by 2002:a17:907:7707:b0:aa6:79fa:b483 with SMTP id a640c23a62f3a-aa6b0f1f0c0mr192342966b.0.1733911090953;
        Wed, 11 Dec 2024 01:58:10 -0800 (PST)
Received: from google.com (61.134.90.34.bc.googleusercontent.com. [34.90.134.61])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa68880b3f7sm432885166b.92.2024.12.11.01.58.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Dec 2024 01:58:10 -0800 (PST)
Date: Wed, 11 Dec 2024 09:58:07 +0000
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
Message-ID: <Z1liL3BtoPnSyvlh@google.com>
References: <20241203103735.2267589-1-qperret@google.com>
 <20241203103735.2267589-11-qperret@google.com>
 <CA+EHjTwHSyQ1FJc7axbLNuBxSWpRVE6brb34nO+F59=QRmfQEg@mail.gmail.com>
 <Z1hhHRdpCZcLs046@google.com>
 <CA+EHjTw4GX3j_ssN-tWnf780xkvyKO5mBN6fnvXeWvQcBDmcNg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EHjTw4GX3j_ssN-tWnf780xkvyKO5mBN6fnvXeWvQcBDmcNg@mail.gmail.com>

On Tuesday 10 Dec 2024 at 15:51:01 (+0000), Fuad Tabba wrote:
> On Tue, 10 Dec 2024 at 15:41, Quentin Perret <qperret@google.com> wrote:
> > > Initially I thought the comment was related to the warning below,
> > > which confused me.
> >
> > It actually is about the warning below :-)
> >
> > > Now I think what you're trying to say is that we'll
> > > allow the share, and the (unrelated to the comment) warning is to
> > > ensure that the PKVM_PAGE_SHARED_OWNED is consistent with the share
> > > count.
> >
> > So, the only case where the host should ever attempt do use
> > __pkvm_host_share_guest() on a page that is already shared is for a page
> > already shared *with an np-guest*. The page->host_share_guest_count being
> > elevated is the easiest way to check that the page is indeed in that
> > state, hence the warning.
> >
> > If for example the host was trying to share with an np-guest a page that
> > is currently shared with the hypervisor, that check would fail. We can
> > discuss whether or not we would want to allow it, but for now there is
> > strictly no need for it so I went with the restrictive option. We can
> > relax that constraint later if need be.
> >
> > > I think what you should have here, which would work better with the
> > > comment, is something like:
> > >
> > >                 /* Only host to np-guest multi-sharing is tolerated */
> > > +               if (pkvm_hyp_vcpu_is_protected(vcpu))
> > > +                       return -EPERM;
> > >
> > > That would even make the comment unnecessary.
> >
> > I would prefer not adding this here, handle___pkvm_host_share_guest() in
> > hyp-main.c already does that for us.
> 
> I understand now, and I agree that an additional check isn't
> necessary. Could you clarify the comment though? It's the word "only"
> that threw me off, since to me it implied that the check was enforcing
> the word "only". Maybe:
> 
> >                 /* Tolerate host to np-guest multi-sharing. */

I guess 'only' is somewhat important, it is the _only_ type of
multi-sharing that we allow and the check enforces precisely that. The
WARN_ON() will be triggered for any other type of multi-sharing, so we
are really checking that _only_ np-guest multi-sharing goes through.

Perhaps the confusing part is that the code as-is relies on WARN_ON()
being fatal for the enforcement. Would it help if I changed the 'break'
statement right after to 'fallthrough' so we proceed to return -EPERM?
In practice we won't return anything as the hypervisor will panic, but
I presume it is better from a logic perspective.

Cheers,
Quentin
