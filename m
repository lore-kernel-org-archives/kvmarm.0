Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3445D218EB0
	for <kvmarm@lists.linux.dev>; Fri, 18 Apr 2025 17:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744995879; cv=none; b=mFzsW6M/EL3LOC7ZB9cHuVVFR4IBkOQ1Qv60Cn3EWV7FPAFkAxYiCNzMZuICoBhMwxIEbHk0s40I/nDR/6ASduaAswak6TmRB5vO8sz/ZDX0MEI59Ye+MLUeF3a6Rt/AxugeNaJ0UuEgl6xu/eT2wSxgqHm1+pP7H97njmch/o0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744995879; c=relaxed/simple;
	bh=1pwYqEYc6XG1eoznV3U3yKal7d9cVfNd2CuRCZxOjN8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hPgfS6zHUv1p8qg4wfDJn+ZRewlcwgXI+RIEZOnX0bP81o6XFcXPyre/tNgmR0RKKsD62/zv6NivZP1RDL+hNf1ZDaoNi4WrM/bjwaS2MUfnd9fItWS3JVrx+LJIsq4FUT35avBtGcWJKDRc/7bP2E/kENZgogAQds9mfP/MP1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cdt7f8Sf; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cdt7f8Sf"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-736bfa487c3so1855494b3a.1
        for <kvmarm@lists.linux.dev>; Fri, 18 Apr 2025 10:04:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744995877; x=1745600677; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=GmDYdCFy/X2BM6MIhNTfkBMtV16BYD5eNM/8mtgykck=;
        b=cdt7f8SflisSncks3dN+V/RAqXYqVVRfiHDv/WsIwxmPEZEgerzoN+RrKuC2igapiV
         mWGJV8mEWRP7w+dj1gyyxL73tnQbM41RaXsJYt7jlZGPyaCtB9OFxvkhDTHIYHJ6iAAc
         35BAV0PZMft/lsy2RkCeXu9G58OQXSM6RNJPMrJIN5r7KzfHYFNYFAYwM79DYaHCmX6m
         agFHTQH47jErgnxyJ5r1e+PjhZY91EEOc+uO210Tv73fEaZ2JhLAia0CTkHkEeQx77K4
         0QRr/vvv5W4Ol7a1dM0KFBzhEuleKdhOO19HjToUuafYtRF1m+6ZNnw+wUFAQuTdhG+t
         iEmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744995877; x=1745600677;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GmDYdCFy/X2BM6MIhNTfkBMtV16BYD5eNM/8mtgykck=;
        b=ZINGIPUwReAQxS/A05tlArv/4G6aD/D6yDMq3/3XNz/2P5GYW6fuVa+qw+cqSMFMaf
         8EqAKpcuYp5R5+zDd9+h8xtg6kX/LeheWsYmhYqi+SZgYWp0FNkGOTYIu+rFPtpEVn9n
         Gs4frqxouz12lyKmTfKMQJc8Vb80IJjhjjWjqsVKOVYbMYnO+tjvtqVjpI3hdfzfuOfP
         BYxnGT56Zm2RhkD2gtvSXbM/3fnGG4pEy8O5Qfj0mJZ093fMGaVKpSLZWPho74vdCFFL
         9JaXepjbfb9htXKJGjHEWylQ/JZ8epvNacITHMbHI192VagtW0Gj4ry9LHhGQUao9eOP
         4Y0Q==
X-Forwarded-Encrypted: i=1; AJvYcCX9sz5kJYUOYU4M6dvu/us6b/Lzvezkj8Se54QNijxI9jxgE8uzrREKCVZ6Npnez4m/McWLrz8=@lists.linux.dev
X-Gm-Message-State: AOJu0YzK6bl9nRuC1y5L0yI0qq2C0og5nDSKQPwD7GwXzAt2Fl+FnRzI
	StfCwr6BIdVuLLG8DfSQtGTTunwQR8ek//4ZLSaFkFk0XkEHrelZ
X-Gm-Gg: ASbGncuGk+JAqH5uPZplF0GiVdSViVXW2zAaK90QwUjqW6HHhL7lbQYzLOSGsoBFzon
	FQu9oodGBrMzSvZfU96g1dol4hfR/Bspb34oABcPpGqh9hyjG9fhp6zw2Q4ZaBe5IB4bJrDDgSl
	0+vqm1IuXjeZPMC7FBi2Ucuq/9cuahSu8cnOb37tVCLeBCVukdM8BH6bnn7br+jumQ5CIc6zD7/
	VlDhHA5xolyqF0bcScnPsB+bpB+k242TI8MEyk+88uK6twqtkpH48YHMYNLMnsTwuQ7q2YEZ4Ln
	xhqMn+ZM+LCQiX1JBRjARJXiXYvNJN0b9KYA0M9A
X-Google-Smtp-Source: AGHT+IFLjBIAYmNf23xJJKoS/fi4jO2Zv3lRydVslbcuKYfFZSoy/LLNwK2RXNGDnjZOnf14RqtA6A==
X-Received: by 2002:a05:6a00:4489:b0:736:ab1e:b1ab with SMTP id d2e1a72fcca58-73dc119334amr4736522b3a.0.1744995877338;
        Fri, 18 Apr 2025 10:04:37 -0700 (PDT)
Received: from localhost ([216.228.127.131])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73dbfaace0dsm1823852b3a.126.2025.04.18.10.04.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Apr 2025 10:04:36 -0700 (PDT)
Date: Fri, 18 Apr 2025 13:04:28 -0400
From: Yury Norov <yury.norov@gmail.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Andrew Lunn <andrew@lunn.ch>, Luo Jie <quic_luoj@quicinc.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Julia Lawall <Julia.Lawall@inria.fr>,
	Nicolas Palix <nicolas.palix@imag.fr>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, linux-kernel@vger.kernel.org,
	cocci@inria.fr, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, quic_kkumarcs@quicinc.com,
	quic_linchen@quicinc.com, quic_leiwei@quicinc.com,
	quic_suruchia@quicinc.com, quic_pavir@quicinc.com
Subject: Re: [PATCH v3 0/6] Add FIELD_MODIFY() helper
Message-ID: <aAKGHIssRW5jXvdA@yury>
References: <20250417-field_modify-v3-0-6f7992aafcb7@quicinc.com>
 <86sem7jb5t.wl-maz@kernel.org>
 <0c97c659-bd28-45e0-8537-d9be2637cb22@lunn.ch>
 <86mscek7h3.wl-maz@kernel.org>
 <aAJq9mGswYsnAOS8@yury>
 <87plh9xz2d.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87plh9xz2d.wl-maz@kernel.org>

On Fri, Apr 18, 2025 at 04:35:22PM +0100, Marc Zyngier wrote:
> On Fri, 18 Apr 2025 16:08:38 +0100,
> Yury Norov <yury.norov@gmail.com> wrote:
> > 
> > On Thu, Apr 17, 2025 at 06:45:12PM +0100, Marc Zyngier wrote:
> > > On Thu, 17 Apr 2025 18:22:29 +0100,
> > > Andrew Lunn <andrew@lunn.ch> wrote:
> > > > 
> > > > On Thu, Apr 17, 2025 at 12:10:54PM +0100, Marc Zyngier wrote:
> > > > > On Thu, 17 Apr 2025 11:47:07 +0100,
> > > > > Luo Jie <quic_luoj@quicinc.com> wrote:
> > > > > > 
> > > > > > Add the helper FIELD_MODIFY() to the FIELD_XXX family of bitfield
> > > > > > macros. It is functionally similar as xxx_replace_bits(), but adds
> > > > > > the compile time checking to catch incorrect parameter type errors.
> > > > > > 
> > > > > > This series also converts the four instances of opencoded FIELD_MODIFY()
> > > > > > that are found in the core kernel files, to instead use the new
> > > > > > FIELD_MODIFY() macro. This is achieved with Coccinelle, by adding
> > > > > > the script field_modify.cocci.
> > > > > > 
> > > > > > The changes are validated on IPQ9574 SoC which uses ARM64 architecture.
> > > > > 
> > > > > We already have the *_replace_bits() functions (see
> > > > > include/linux/bitfield.h).
> > > > > 
> > > > > Why do we need extra helpers?
> > > > 
> > > > If you look at bitfield.h, the *_replace_bits() seem to be
> > > > undocumented internal macro magic, not something you are expected to
> > > > use. What you are expected to use in that file is however well
> > > > documented. The macro magic also means that cross referencing tools
> > > > don't find them.
> > > 
> > > $ git grep _replace_bits|  wc -l
> > > 1514
> > 
> > FIELD_PREP() only is used 10 times more.
> 
> And? I'm sure that if you count "+", you'll find it to be yet a few
> order of magnitudes more.

And nothing. It seems that you like statistics, so I shared some more.

> > > I think a bunch of people have found them, tooling notwithstanding.
> > > 
> > > As for the documentation, the commit message in 00b0c9b82663ac would
> > > be advantageously promoted to full-fledged kernel-doc.
> > 
> > The FIELD_MODIFY() and uxx_replace_bits() are simply different things.
> > 
> > FIELD_MODIFY() employs __BF_FIELD_CHECK(), which allows strict
> > parameters checking at compile time. And people like it. See
> > recent fixed-size GENMASK() series:
> > 
> > https://patchwork.kernel.org/comment/26283604/
> 
> I don't care much for what people like or not. I don't see this
> FIELD_MODIFY() as a particular improvement on *_replace_bits().

Sad to hear that. Those people are all kernel engineers, and they
deserve some respect.

We are talking about tooling here. People use tools only if they like
them. Luo likes FIELD_MODIFY() over (yes, undocumented and ungreppable)
xx_replace_bits() for the reasons he described very clearly. He's going
to use it in his driver shortly, and this arm64 detour has been made
after my request.

From my perspective, both functions have their right to live in kernel.
They are similar but not identical.

I'll take patch #1 in my branch. Regarding ARM64 part - it's up to you
either to switch to FIELD_MODIFY(), _replace_bits(), or do nothing.

Thanks,
Yury
