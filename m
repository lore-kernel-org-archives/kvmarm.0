Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.55
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793866089;
	b=xg1oW8AAbkz/h8Gf03+OrBiwLSGyXXJbvhFJCAylna26m6rsIozZcQxjj9ctAoT7NqI7
	 FrNXVjBM+rb51iP4p9HOrf3W6VWH4QyGg1QrE0Be9+b4ugbmTe4hgnboUISXzp9HDcQA2
	 udLvJamezv7aGkvb2+wZX1cTLCO3ttEuZo/z2NtnuYjsPHM3CWRzvtmg0iHCbRvhuNvCI
	 TPvd8dqYqp0WpxsvXTU1HbweWXJcknZ8tBquvmHmxbhb32nwsntQ4VtjBl7KPBSNHxbzY
	 MT4Nc/1bR9zck9SYCEnBCZFqxIssDiTrRIb+uBay+O6vyEhuW1UHp+PPnGUn7tTuneg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793866089;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=slAjwWQDYVO39KamLXHsue/lfUEBTiuulu/3jpX05gc=;
	b=vFz+wIXE1TNFqbYgpKAjTkjHFDskISGNer2BK+Zk9j78ZYFjGlwdGcJ6pvGE4OyFkcEl
	 qeMp+AuMiqJRvqpuIoKKsfPpOFWI/uxLyyPvPNBEFnBrwdNZGsN0jHZ4pn4rehX8oP4p+
	 juAt2ozZjhU6kf9oKT0eRvxtWQGP4ZzElejuURgleccwmqd1647xCRsbxMDQHMgqTwcWV
	 eNRG6+Skg2C7dQJ5T9OlrWxLW3GWY3QXS0ObEbVMaNhnB6+5Q0M8WlHyFThpmom006Y+P
	 o8nOjWod6Wt2E/I6MGZ4b37SOBNrBfBGOy0QPLaVli9vX/gNkGs5ZShJnSsx2AoMt4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b="QR/ysJBv";
	arc=none smtp.remote-ip=95.215.58.55
Received: from mta1.migadu.com (out-55.mta1.migadu.com [95.215.58.55])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C079606A32C
	for <kvmarm@lists.linux.dev>; Thu,  5 Nov 2026 08:08:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4C079606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=QR/ysJBv
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=5dNzhcTaPSPAHoNbodXyj+zv2hdRrCEJXr1Y2dhrWX8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793866086; v=1; x=1794470886;
 b=QR/ysJBvl+GJUPglNTkM/A6Z59ex+vCXeglEdffePj1QVKtsCiB1QoXap51GWfQ59mC3JGVk
 efi0mTPVzaLQU/qpgA1PGp79vKCvudR4xl+jVA+j7qLIrYqVcwuJAYwRBwDgEDvoVn4dVM0aGwH
 7lx6AfxZbzVT09HtZOTl5UWA=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id f36153c12708478f;
	Thu, 05 Nov 2026 08:08:05 +0000
X-Mizu-Trace-ID: f36153c12708478f
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-5be58ad9600so5849e87.0
        for <kvmarm@lists.linux.dev>; Thu, 05 Nov 2026 00:08:01 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBxwXWPA007Y3iPLw4btHz0md75qUIvcq4REpFA49bl8dNvDz6JKswewcYLvMCAP2rU880cYu88=@lists.linux.dev
X-Gm-Message-State: APuU4Z8tfy6J1cx9nUxAbKKyMw8fYMrNgzULVJDTLIJ6mz9sf1IbohSC
	D6zZVJpSJggvG+NRhMkBbgwj3uMCoaV6fpb5gNRWLo1EphhftTIPNGTfppBKe9AiEIs+d1N126T
	rLdJfMtASDcOmu/GfIfnrTQAsBfRVWUkKpzq0uCfh
X-Received: by 2002:a05:6512:3e02:b0:5bf:f0fb:2c9c with SMTP id
 2adb3069b0e04-5bffb1dc195mr77268e87.5.1793866080846; Thu, 05 Nov 2026
 00:08:00 -0800 (PST)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261104124451.2148724-1-fuad.tabba@linux.dev>
 <20261104124451.2148724-2-fuad.tabba@linux.dev> <aut5t605onnuBWfk@kernel.org>
In-Reply-To: <aut5t605onnuBWfk@kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Thu, 5 Nov 2026 08:07:24 +0000
X-Gmail-Original-Message-ID: <CA+EHjTzEa-VZZ7TffdR0dY=92-iqX68yWkPR1zz7uzEX+c+f3A@mail.gmail.com>
X-Gm-Features: AclHuK__AB0z6apl_Wv0YuqPm4x2AvnN93O1z8V4Fr2KgOylyOBS-uUCz6gu5jo
Message-ID: <CA+EHjTzEa-VZZ7TffdR0dY=92-iqX68yWkPR1zz7uzEX+c+f3A@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] KVM: arm64: Resume stage-2 teardown where the walk stopped
To: Oliver Upton <oupton@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Raghavendra Rao Ananta <rananta@google.com>, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, 4 Nov 2026 at 18:30, Oliver Upton <oupton@kernel.org> wrote:
>
> Hi Fuad,
>
> On Wed, Nov 04, 2026 at 12:44:50PM +0000, Fuad Tabba wrote:
> > +u64 kvm_pgtable_stage2_destroy_range(struct kvm_pgtable *pgt,
> > +                                  u64 addr, u64 size)
>
> Returning a signed value here would be a good idea so you can percolate
> walk failures back up to the caller. Since that WARN_ON() below may as
> well be a BUG_ON() in hyp code.

Ack.

> Otherwise, rest looks good.

Thanks Oliver!
/fuad
