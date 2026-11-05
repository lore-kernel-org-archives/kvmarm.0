Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.73
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793894778;
	b=b6D1gbO5zyOsIs0IhSOTvA/te61uuViT+0O09GRWMN6pB/H7DFKRG1O+D9hdJ7MY6xRC
	 r4lEeu5NUbOqSk+Cvz8OnYZqKC12XeLrlD0p+lGMJTEpP1f1Nj3MwYviGr4Vb421mrzFd
	 KZl8+8UcnVqohhno7NlvAGL8XLQajqK8ewr6huPrRArTetWEh4CrYXC0Yoq59w0M+ilEI
	 UjbqjlbIFQ1MiyhHWwS295EtxeEGyE3zuZBivRKwyi/Rmge5x7F6HlZHfTtIcR0tJ3cTH
	 GukFLe9lVb4yFNHdg8PYoMb2+rMwDE8tR6ScBAGIEA/eaNp74Am1IU0cAtyGd2Eg+yg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793894778;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=/cWlRZ8SCFwTMb55OqToMLGSlbLAYefJerAulPP2VEQ=;
	b=aNgv4BdhL95n0c8Mczs9qaOsBe+xGPyDnNNaBqHD1AspgV7Cs0STum4akQABZDrhh/gm
	 pPls7RixR3xM2MovhWoQ5IHC0luTSKNBE9zZKOKyT9fZ01h30GBDizkZmIYan15Pbjdq4
	 wKK9Fkubys2dI/sg/i+sf7OUvqa3e757VN1K9BIFfDbBy3ESkji7/BEj7HeXJc1LZEiz3
	 XxO56yATQpXMnOVwxANS/R8BItuqqnObU0BkLWprt1Nk00L6vadITXA4+urj7kOhNBKN/
	 9Kaar9aFoVUk39O0R/4RYJEd/hP70Xa0yNfu/nNTrwj8do7oTTX0+dFzjCd1BQBHhlw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Pn7Wglhq;
	arc=none smtp.remote-ip=95.215.58.73
Received: from mta1.migadu.com (out-73.mta1.migadu.com [95.215.58.73])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF1E9606A33A
	for <kvmarm@lists.linux.dev>; Thu,  5 Nov 2026 16:06:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AF1E9606A33A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Pn7Wglhq
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=q1Jd3oCj3wElY/Ramn8yIWwh5Mzi3hHTvnQWrqt1nCM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793894774; v=1; x=1794499574;
 b=Pn7WglhqBntRYHjdsQbqRKyn7lHBPxai6iNEYbabp74BJ0buTkHTvlcRsdFYufNFUBCZ07ha
 gR0aM2pCLAKCkT4oXTKrbWA3gGB8l4Ctz7xVtC/wLRmglYS4m3MlkAfjemeI+wYcI1vKCkv1N1W
 CeNntVi3a8pq/wDVMBt6LV5s=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 3f6b86095d41b2ad;
	Thu, 05 Nov 2026 16:06:14 +0000
X-Mizu-Trace-ID: 3f6b86095d41b2ad
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-5bff701efa5so8055e87.0
        for <kvmarm@lists.linux.dev>; Thu, 05 Nov 2026 08:06:09 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBzOc3q7RDwWUZSnsLn89whaRdY6AN7PrvE7CymA3RyMFvscaPtW8VcpN3bEGCNivQQKsbjIzQ8=@lists.linux.dev
X-Gm-Message-State: APuU4Z9DlAfkE48PMZMvQxV6nEU64iKZHgMoAHkXmdZooYCQOnvJmKnA
	PC7M4iWD3wn+eQxKZRSE+rmHsMD160pe7xsg6rWEs97XJr3GEZpR6J3GMZyXNvjEx0VSt9nmxM1
	SFIwmhklJnVMz5yrN2F4oit2gmtHao5cYkOpaRd8J
X-Received: by 2002:a05:6512:6ce:b0:5bf:bec9:aaed with SMTP id
 2adb3069b0e04-5bffabc3e5emr166519e87.8.1793894769045; Thu, 05 Nov 2026
 08:06:09 -0800 (PST)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261105110050.1244525-1-fuad.tabba@linux.dev> <861p8z2s5w.wl-maz@kernel.org>
In-Reply-To: <861p8z2s5w.wl-maz@kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Thu, 5 Nov 2026 16:05:32 +0000
X-Gmail-Original-Message-ID: <CA+EHjTyEOfDf4ynYuGz1ejE3s6R2syP4=zZMcq1oKAqFfDxCNA@mail.gmail.com>
X-Gm-Features: AclHuK9sqVJFjm0gw0BfO1w3RU0O4-fEP04HRvITK947bPe5QzS5BG9idCL7ftg
Message-ID: <CA+EHjTyEOfDf4ynYuGz1ejE3s6R2syP4=zZMcq1oKAqFfDxCNA@mail.gmail.com>
Subject: Re: [PATCH 0/3] KVM: arm64: vgic: Drop stale LPI pending state
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Andre Przywara <andre.przywara@arm.com>, Eric Auger <eric.auger@redhat.com>, 
	Yuchao Zhang <ndaugoing@gmail.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 5 Nov 2026 at 15:51, Marc Zyngier <maz@kernel.org> wrote:
>
> On Thu, 05 Nov 2026 11:00:47 +0000,
> Fuad Tabba <fuad.tabba@linux.dev> wrote:
> >
> > Hi folks,
> >
> > The GIC just keeps on giving. Three follow-ups to my LPI fixes for
> > redistributors with LPIs disabled [1], to fix pre-existing bugs Sashiko
> > found.
>
> Can you *please* come up with a full series rather than this constant
> "here's another set of patches" that address the same thing, one
> pothole at a time?
>
> I'm now really tempted to drop all the patches I have queued on this
> so far, and wait for the "one true series".

Sorry about that. Every time I think I'm done with it, Sashiko pokes more holes!

I'll sit on this a bit more, make sure all the gaps are closed,
Sashiko it locally, before I respin.

Cheers,
/fuad

>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
