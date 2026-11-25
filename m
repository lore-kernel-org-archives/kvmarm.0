Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795602420;
	b=mTXFILYG8YAzeLgx+l8C5dodG3hH6iPo6PlfBrGL/ZKXdrKkaNTxlO86JPKRBg40EDy+
	 Z0Zv/+/oOhxJvMj5b8CGR30ek4CPMyV1h42T08tHbsHrwksU/XFJ2f3W+MYHMRU8ZAYNW
	 7AVDZI/x/Y1fI9BH6knIEogejBoRn8bkX7ypoZxgSvEu8ULhMDjWiKgnx5KhmnuCR7frk
	 MfUDNzK6JZznUYN768v/f7Em0uSPGDwXePHDidQNeDTMtyHDWwDsXMLYC5uPeN4VWEVyC
	 hVNtOPOzPMSJ5LOy5hk7IKMRovItvavagrvbGxc7F95/KzF3BE4O5KmhScv13vrePTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795602420;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=usb6Z06Hk8KYQV8odRZafo7lcqGHFhPDFCx6kFOexg8=;
	b=jiQBm4bG+jZY++Qs+6QM9RdVRfkGcN/b6T6URTZ5wdRYcVWpjuN7CgIAJ4CaOUrt0+BO
	 tetRdUIKxnH93VyGDZhz1JRN2q/bAW9bKsB4Up1awKtO9VTv2lEh34VGeSbIDELkL3ouh
	 EWdOW8aNtltRmYfkQ1iGufE386ZLJegLVIXWCVk2rNnA/WKSd3YpSAJFCpsxY3VxEajzo
	 G9VzmMgv1zCgw5UKk2W5D1U5BXzbZNb/qB/nX6cUW1h7CeB1yJn1aHVneRjiD+2nhnGNy
	 T8b429ERhyoT8RTeFaVnaddbJcNbK439tAf0yIZAHOFK9eqpOt0AC7EeFmYdtHHqh7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=O4uHgzXP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8C7A606A323
	for <kvmarm@lists.linux.dev>; Wed, 25 Nov 2026 10:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=O4uHgzXP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F36C61F000D4
	for <kvmarm@lists.linux.dev>; Wed, 25 Nov 2026 10:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795602420;
	bh=usb6Z06Hk8KYQV8odRZafo7lcqGHFhPDFCx6kFOexg8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=O4uHgzXPpddrs5gBqi8u9B2aC0SyE1KCf5EIAftXmQf0Yz2Bd+cgo1AM8A56/XQ9b
	 QsOVezx8SE9qn+lvrJWJL1PlTp4gI/ODzeAfNUdCBjt4Yzly+8YEdh5lAto1BeiBtW
	 /7CFZIny7BW8SPGrIJQECs6/L+Gmln25txeh1jerNuB2R5ZuT5WsODPt16jq9ZSXN1
	 TAdyxky7rcl0q80azCDqg0LQDzoEB1/CSIuA4WL/UAjvZTNT3qWM2GLj5N0aZvZz1R
	 L8ZFxRiK9+1MKiLQyRnSM6v7F5pPkCH2LHiOaGB1sMe/Gxk8SHMRpzsNCp05SnHtNB
	 EfR1nLIQmF2Pg==
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-5c14f3dab0cso3148444e87.1
        for <kvmarm@lists.linux.dev>; Wed, 25 Nov 2026 02:26:59 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErGRtUWNClOom6pIvFADlPWuIigiHM03Ry7bOFBfspWRGyhlnkz0geL9MWCsD8r+XxFxDoXBlIM=@lists.linux.dev
X-Gm-Message-State: APuU4Z+7Ufl4r76c7SE2IeWv0aiyq4M4F+EZ7obSbATMRwt5Jub21G0q
	q/hkX0azwTPUnH/5nErLkIKXIF7yVfCM+5EO473iZELw6B5Tu+Qo8oM0XAbw6pbIkEaWT4tasyq
	fgaQae73gGyVs5jejCkveVBSyqMayqVE=
X-Received: by 2002:a05:6512:104d:b0:5c1:5a83:2fd7 with SMTP id
 2adb3069b0e04-5c1bc907072mr5199313e87.66.1795602418769; Wed, 25 Nov 2026
 02:26:58 -0800 (PST)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261015142552.4128028-1-ryan.roberts@arm.com>
In-Reply-To: <20261015142552.4128028-1-ryan.roberts@arm.com>
From: Linus Walleij <linusw@kernel.org>
Date: Wed, 25 Nov 2026 11:26:46 +0100
X-Gmail-Original-Message-ID: <CAD++jLm6VvPYB5UQS8Zm73pYifr7Oi=xX3S4Wt5c3WE7uMv+fQ@mail.gmail.com>
X-Gm-Features: Aa3M54rtYXT0tNMww-_rAs-DbnpD3x58pzG3L6crqferpf2a4MJ3rhFXSlspZ40
Message-ID: <CAD++jLm6VvPYB5UQS8Zm73pYifr7Oi=xX3S4Wt5c3WE7uMv+fQ@mail.gmail.com>
Subject: Re: [RFC PATCH v2 00/15] Arm Core Local Accelerator Driver
To: Ryan Roberts <ryan.roberts@arm.com>, Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@kernel.org>, Alex Williamson <alex@shazbot.org>, Jason Gunthorpe <jgg@nvidia.com>, 
	Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Jean-Philippe Brucker <jpb@kernel.org>, Oded Gabbay <ogabbay@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, devicetree@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Ryan, Jean-Philippe,

regarding this patch set I looked into historical precursors and
ongoing developments that could benefit from the same infrastructure.

1. Apple AMX: there is no ongoing effort for this accelerator but it
exists in all Apple silicon. This accelerator appears to be synchronous
using extended instructions and is just "some different SVE" and would
be handled the same way as these.

2. The PowerPC Cell SPU (Playstation 3)

This is more interesting: the Cell has accelerator cores that execute
entire litte programs (shaders?) on behalf of the CPU. These are
however not poilled like the CLA, but signal completion using a
mailbox interrupt. The accelerators are

What is interesting with the SPU is that it communicates by creating
a custom filesystem (spufs) mounted at /spu, so this is apparently
another design venue to consider.

I think Arnd Bergmann has worked extensively on the SPU so he will
likely be able to provide input on lessons learned, do's and dont's
when it comes to this and other accelerators.

My superficial appraisal is that the CLA is probably executing smaller
jobs, snippets of work rather than entire little programs/shaders like
the SPU does, so it is conceptually different, but may provide
additional ideas anyway. Arnd?

Yours,
Linus Walleij
