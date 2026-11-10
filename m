Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794297279;
	b=vVVrMh6mDZDx/U5JWcIiPNdIhKw6pbovOndpKRBRuKJoOad9wqp7/5n7nxSV/zyTNT0O
	 mqAz6eAAairRt90Hd6nceWorMStbFxKsR6bTACnvBlLeUi3mXrGUf4sbwSTTULlkgn/hW
	 KiEhUw1d2oCsqfOzatb7oufZvLn/Fq2cyhcPzBfujV7j2YT8HMNvzBN88KZRRIFj7yY/V
	 BEBxKJIQHtpYBTMOnkAMQeH/dYGA3umc11xoKlkpXzgXJoljWHaNt4npahSwEJBvizze9
	 5jbtS1NBDaMlJppE/N94TOkKJO8NeRBk1sK+816h5oS/p6MsFaFRM7yp2W1yOLxIRpA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794297279;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=uUsvdS/MCn3r1szB7mIiUrOB1nUvy7lbcFJPAYnC6lk=;
	b=LPfz0orBKtdnTeslGdHP/RxQ72/UeWJi5RZvylrDtt3QMMzYag0eX/7A5cP+b+Z5r/GY
	 pqiTN0/Sh3Uh/QY/6VYgUOpaaZY4Cu+lJIWQDWUYeWCaKZeMosJ0F0VlRIhVJmvtZLzdy
	 68E7lELc6BFOHp0TL+zCaMogmQT986evzOkR2mtb493GsIKHRgeFbDJ54FRukanGC7wYL
	 Lro84Xc8makqqlQYuyNbV7TXRTi3Q25mwASEtXCIX/N0vOhbkTfCkAcCBNJOJIBb7J9WS
	 XX4Ian1lITwXj/v8srhc8vgxoDgqh979iOV2wnDeoh9J6xXSwFeZF6B4ugMxoY1Az/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=v1oHthRT;
	arc=none smtp.remote-ip=95.215.58.44
Received: from mta1.migadu.com (out-44.mta1.migadu.com [95.215.58.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E5B3606A974
	for <kvmarm@lists.linux.dev>; Tue, 10 Nov 2026 07:54:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3E5B3606A974
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=v1oHthRT
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=7+GiAWiV7wSGiwtjJVTDPfGh8sdqdWnHMtmCVSJqVyQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794297276; v=1; x=1794902076;
 b=v1oHthRT/GawqTNLzXcAXwam+GomFdE4hu/zRE3KFuhIGtb5bjmXqfLvQ3gKEjKDi4wpiPq/
 Ao3WPQFz6Tr23ltK/G3r4++/ZtS0/3Vs2yVg2CWYH0OjR9rr45isD+TIWFuqmkUfO4uJgYVhsFz
 0RI008FFsXWqVpbmjm0J4MIw=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 157605c2ea1504e1;
	Tue, 10 Nov 2026 07:54:36 +0000
X-Mizu-Trace-ID: 157605c2ea1504e1
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-5c00d7ac49dso3175e87.1
        for <kvmarm@lists.linux.dev>; Mon, 09 Nov 2026 23:54:33 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErGTHSlTSHasrtcNKlZeSUoyHBWm9ag6lgn96YGn8Ob09c3gq/wgr5BEtmQiimJtQEcaGh9FlEI=@lists.linux.dev
X-Gm-Message-State: APuU4Z9UNuvrewoz39+AyMbEurWtK7rSz7N8ziHDG3h3KMOzVuCAITrP
	OllF/0KIjYDxSNxEAEfTzNfBKwUv/XzcAS+DdvXvHwSTpUbs5WaMNEK+UF6xZjxG1iQGMSw9onB
	UCEkNrY6ZwX4AP7ATgP3IFUrhw7EOBD4TEIM2lXKn
X-Received: by 2002:a05:6512:138d:b0:5bf:f0fb:2c9c with SMTP id
 2adb3069b0e04-5c15704f10cmr100054e87.5.1794297272416; Mon, 09 Nov 2026
 23:54:32 -0800 (PST)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261109083205.806619-1-fuad.tabba@linux.dev> <avIq9AIE-9igDzsV@kernel.org>
In-Reply-To: <avIq9AIE-9igDzsV@kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 10 Nov 2026 07:53:55 +0000
X-Gmail-Original-Message-ID: <CA+EHjTysJ4biucKNDsJS_ocEeGbvV8bJbrMvkEZ23nvV+qeLdg@mail.gmail.com>
X-Gm-Features: AclHuK8yWZn8Qr7IEdMRqVfNRXGcQQCa7v4yX1k-Pc7fDzArB9Aod9u9nR3PGag
Message-ID: <CA+EHjTysJ4biucKNDsJS_ocEeGbvV8bJbrMvkEZ23nvV+qeLdg@mail.gmail.com>
Subject: Re: [PATCH 00/16] KVM: arm64: Support debug, SVE, MOPS, PIE/POE, FPMR
 and more in protected VMs
To: Oliver Upton <oupton@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Vincent Donnefort <vdonnefort@google.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Oliver,

On Mon, 9 Nov 2026 at 20:20, Oliver Upton <oupton@kernel.org> wrote:
[...]
> Ok, we really need to slow down the rate of patches here. I had already
> applied the SVE series locally and now we've got a grab-bag of CPU
> features in addition to what I was ready to apply.
>
> The whole point of respinning a series is so we can converge on the
> shape of the feature and get it merged. Adding a whole pile of things
> that wasn't asked for just muddies the context for us dumb humans and
> slows down the rate at which you're going to land things upstream.

I'm sorry. My intent was to make life easier by avoiding conflicts
within these series, but I see how it ended up having the opposite
effect.

The SVE patches in this series are unchanged from the SVE series [1],
so what you applied is still current, and the same goes for the debug
patch [2]. I'll hold off on the rest until you've had a chance to deal
with those two.

>
> Going forward, can you please:
>
>  - Keep an individual series focused on the original intent. Don't
>    unnecessarily expand scope.
>
>  - Only iterate on a couple of series on the list at a time. Sashiko
>    findings are interesting, but you're gonna have to draw a cutline in
>    terms of how many additional patches are going to ride the coattails
>    of any particular series.

Ack.

>    You're obviously a very active contributor and reviewer, so I don't
>    anticipate such a rate limit to actually impede your patch velocity.
>
> Sorry, I really do appreciate the amount of work that you're doing to
> get pKVM in good shape upstream. I just get the sense that Marc and I
> are going to quickly encounter bandwidth limitations.

I appreciate the work you both do. Other than being more careful with
my own patches, let me know if there's anything else I could help to
take work off your plate.

Cheers,
/fuad

[1] https://lore.kernel.org/all/20261105130456.1617185-1-fuad.tabba@linux.dev/
[2] https://lore.kernel.org/all/20261102093950.2922035-1-fuad.tabba@linux.dev/

> Thanks,
> Oliver
