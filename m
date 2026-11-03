Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.240
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793723300;
	b=o1eHjfaSaPtBJ7WDPjAXD4DqXOIHTGOZe8R7g+ouDE1i/zCLPnbLf5R+Uiu8eYZDqDWN
	 j7yvMnkfBxr1Wc8hKdi2JWLVV6+4g6Mb8nUFuc6///fPeL+/xTTOqO6pXHvcFnrUGHEax
	 31CH7X4Zb9Ie2ycmm8p7L/1Gzk/NYGRDWSCf8pczOsVcOkSp6nf1jtkh7jf1Q39pmwkbP
	 WXG/SYlSgJUBYOD8bJZGfgGu8G2Zj6iQGGrLTm+mNnKY3Xdjs3vqrTJNUN2nByAyMxBzq
	 bxAhcKaknLmQQGboOqZ4d+dMtQrZfSoj2VecOR8ZOFMsqj29EwQkuYRhvzS62nCxMXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793723300;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=iPFbuhVhE1g4yui1cmP0KhQNdE0EYgL9kQOJwYevAeY=;
	b=CxzXijNBy44R16EkxMBeRW8huzEG9yP9E44/RzaMpOZ/c/RmyzR7POCGC4BK8hjxaZgA
	 RqS5RBlEUHErKt+Q236roF1qkuCxm0RcdwQXEznxcta4f/2kT8r+3eixUCf4ZBqau8M8l
	 ZZyHJyPpGYFvU9QNng/H2RRKMLjo40Vqop/H9jQf3ooXIWTqjy64In/+JhheQc4UZQ5Xc
	 cr2vd9Kuu8AzU1dSJs3Ae7Grj/34Q1TVH7iMSaDk5IrvUqhF6M71cP7DNe9GXDPArA4jw
	 kY5Fexs/vUdZ9h3Lw3y376aDDDoYQMhKpcgzIhYHKwnbtv1yf+EdJFsnbW8W61SK84g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=mGtz2hnM;
	arc=none smtp.remote-ip=91.218.175.240
Received: from mta0.migadu.com (out-240.mta0.migadu.com [91.218.175.240])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F32C606A324
	for <kvmarm@lists.linux.dev>; Tue,  3 Nov 2026 16:28:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7F32C606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=mGtz2hnM
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=CUR3VrnT7Ns3nP5+yfIqfY8w9gLzlAPh5PghOBj2uBY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793723296; v=1; x=1794328096;
 b=mGtz2hnM3M7mFqDglK4h5Xa+Wh9Ekbi1dCzjerADHrknOi7WSmdYIgLz+iX0sc/Gl6JDSmfj
 x55SpmDSoVx4IJa8N/ynLh5Eq10g2n7IBDI7+/RzRozIwbITElFKiG+99DRAYHrgn9FFz0vc3lm
 FPKbtnZLkn4kxk+GBRMMmygQ=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 0fdbe88ee19d641a;
	Tue, 03 Nov 2026 16:28:16 +0000
X-Mizu-Trace-ID: 0fdbe88ee19d641a
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-5bfca2a2af4so7837e87.1
        for <kvmarm@lists.linux.dev>; Tue, 03 Nov 2026 08:28:16 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBymh1EqzQRs1SBWJ8OiuPC6TzYHTow4Ds0XsFQw6XPmUKsv8cIrBEr8Lul6uS3rcE3P0fBPIfo=@lists.linux.dev
X-Gm-Message-State: APuU4Z+CVNaMGvnKVtfaZyte+j/nzpB9TcAF6AGbRSGYCjIoTsQ4+uaU
	D5xA/bh8r6Z+cOJ6AUUxC+jBk9wiLco51eAMSr83oxUZ6/KH9RiaMdf58xEIGFCcPID+RFGhE9n
	javjSUyCZpMmze93sLSboBz8TniYlW+ISN6klQSzG
X-Received: by 2002:a05:6512:3e0f:b0:5bf:d226:862e with SMTP id
 2adb3069b0e04-5bfefdaa5bamr205874e87.2.1793723295372; Tue, 03 Nov 2026
 08:28:15 -0800 (PST)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261103084742.1302597-1-fuad.tabba@linux.dev>
 <20261103084742.1302597-2-fuad.tabba@linux.dev> <aun1NJNtnOeSL4oc@google.com>
 <CA+EHjTwCPHp_odMPJAJ8pfPtymtU5ia_RrH30DavFeiZqvhVAQ@mail.gmail.com> <865wyd3mqu.wl-maz@kernel.org>
In-Reply-To: <865wyd3mqu.wl-maz@kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 3 Nov 2026 16:27:39 +0000
X-Gmail-Original-Message-ID: <CA+EHjTxfQ5P+Q9jrGxr6A4CjtewetFE9apskj061iJQbtwAsyQ@mail.gmail.com>
X-Gm-Features: AclHuK9bqtJuUq_-qqIlTFI2gjtDBN-F09-mdn7cW-n-Iv21GT3fzkXnYFOU20Q
Message-ID: <CA+EHjTxfQ5P+Q9jrGxr6A4CjtewetFE9apskj061iJQbtwAsyQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] KVM: arm64: Don't walk the whole IPA space when
 destroying a pKVM stage-2
To: Marc Zyngier <maz@kernel.org>
Cc: Vincent Donnefort <vdonnefort@google.com>, Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Raghavendra Rao Ananta <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, 3 Nov 2026 at 16:26, Marc Zyngier <maz@kernel.org> wrote:
[...]
> > > > Fixes: 4ddfab5436b69 ("KVM: arm64: Reschedule as needed when destroying the stage-2 page-tables")
> > >
> > > Isn't it an optimisation?
> >
> > No, it fixes a regression: 4ddfab5436b6 replaced a single walk of the
> > mapping tree with the 2^27 lookups, as described in the commit
> > message.
>
> But that's a configuration that simply does not exist in HW.
>
> Therefore this isn't a fix, this is an opportunistic optimisation that
> may or may not become useful. So not a fix, no backporting.

I'll drop the tag then.

Cheers,
/fuad

>         M.
>
> --
> Without deviation from the norm, progress is not possible.
