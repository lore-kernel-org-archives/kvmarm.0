Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.81
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793722825;
	b=DK95i37zXzmIh8Gv9xZugodIUQ8v3zyFafaXQ9Oje++grd6nfxVmRA9OOe/gE0sMBns0
	 JiNxtxVNPMnebkKqAsUjvAg1WTy7V+DhiFc9IuK2bYDCOPy4o5bYoNGZAjSnHVOBNnNjt
	 P6LOYcktaM4hxZxNGNtRQsq3lOqDvzzK1hAeJx20u1/XS5KczbA1KDVe4iY9E6oCSoAoj
	 ChZE67nKDDJWtgYak/FmVuExnmsLaN2d+JH1iZQKRLs+UpbvfNA7Ip5q9IwYbE5gGUO8s
	 aQEU0YeJ1+CPp/z8vveYZaRQDs1rUnh0L8+JqJHh+57ogQWf4WZvvyaSmDo1wskE6aw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793722825;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=hWrA8NhtxzstAUEu/T8XI9QJuMJO8OlRPrMrAUmaBE0=;
	b=XbFHIzzB4FjaH54GbxRsInOeSxgdpi/Vv3jVy51lxmGwzv2NlItd/KK+9VoIxyNKlC+3
	 6ZM7Kl0SJj+5T8HlExU7M08MBseSS+9lquvhMIUFd9yQWdqmM6vEhMBRTK/O9/GX3DqTI
	 qkHSgtg5lONyzGxSS9K1J+JWybo81UispEYtTljf/jUAXdMNa1lkwMK4HsXZ3TNGVMOH4
	 os4jeNxtkbMO2J/biIp70vB4Ew/XgNBaW5PmwnG3jeFX2/r6LBlCGBlOQddJ1V5hncRiz
	 M3d/KiTUlYB6sYEL5cmNLyXJ7fatEeAXbuAgwF751+/y+EnqLNCFFUYBk191R6sHYyg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=eampla5P;
	arc=none smtp.remote-ip=91.218.175.81
Received: from mta0.migadu.com (out-81.mta0.migadu.com [91.218.175.81])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A11FF606A324
	for <kvmarm@lists.linux.dev>; Tue,  3 Nov 2026 16:20:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A11FF606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=eampla5P
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=5E02A5wHBmpYnX5KdvdmDO0B3Uy/0sGJV6ZUwMIlvIE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793722822; v=1; x=1794327622;
 b=eampla5PIU9YMQPYmh7+NspcMUJR1pQe8zkxLgBVgyphBBdQPOOiJAcBD1V/S41fKEjaLW9v
 ztAK5S5qY1BqJxs0/gBjuEXtCgWyZevWZ9JEs9xB/PFPjxMPfjvqYFhFiE2mnoOAV/1oYYkA0Qc
 deOkh5haGz8rfydZi2TRLkt8=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 46e1288a74423270;
	Tue, 03 Nov 2026 16:20:15 +0000
X-Mizu-Trace-ID: 46e1288a74423270
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-5be3b2f17c1so6891e87.1
        for <kvmarm@lists.linux.dev>; Tue, 03 Nov 2026 08:20:15 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBxjh9FhheaBrjm38xQi2vxQqLZfvl+Dnkn+lMT3vsV5OtBsrIxNqf907djE+hbNpY5J2o3/D6c=@lists.linux.dev
X-Gm-Message-State: APuU4Z+H5oe4+dNyAeA3z7uvuMZjNkTCwNwNf3vO70YuR0AZ2z7o7XMf
	AO3rrH7K4VaJ013gGZm9TTAERg2qEE9TqLNGGAB3H/2nuWsEaDqixBliqBJ/gHLpJSDPqSoJgmM
	XsFnj3qQrI07G3SavGwpt0vpANt64ustHLXZnChLJ
X-Received: by 2002:a05:6512:1087:b0:5bf:c0d0:8fff with SMTP id
 2adb3069b0e04-5bff0efda80mr116496e87.11.1793722814476; Tue, 03 Nov 2026
 08:20:14 -0800 (PST)
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
 <20261103084742.1302597-3-fuad.tabba@linux.dev> <9841ba98-7f07-4d5d-8397-a07e22ba7f51@arm.com>
In-Reply-To: <9841ba98-7f07-4d5d-8397-a07e22ba7f51@arm.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 3 Nov 2026 16:19:38 +0000
X-Gmail-Original-Message-ID: <CA+EHjTxWA2o7RkZw_17QMfYjXYN2dW-X6Rmj95YN1iYBvBzrCg@mail.gmail.com>
X-Gm-Features: AclHuK-ekQu6wnuQHHw6haPOsqIeceQhl_GCt9dfFhk4lQ1KKTD7xUnwcbQL5cQ
Message-ID: <CA+EHjTxWA2o7RkZw_17QMfYjXYN2dW-X6Rmj95YN1iYBvBzrCg@mail.gmail.com>
Subject: Re: [PATCH 2/3] KVM: arm64: Skip empty IPA ranges when destroying
 stage-2 page-tables
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Raghavendra Rao Ananta <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"

Hi Suzuki,

On Tue, 03 Nov 2026 10:27:54 +0000, Suzuki K Poulose
<suzuki.poulose@arm.com> wrote:
[...]
> > After destroying each chunk, look up the entry at its start and, if it
> > is empty and larger than a chunk, skip its whole range. The lookup reads
>
> Could we not lookup first before we destroy, that way we can avoid
> destroy walks ?

I'd rather keep it after the walk. Looking first relies on no empty
table being left linked above KVM_PGTABLE_MIN_BLOCK_LEVEL: the lookup
would return one of its empty entries, and the loop would skip past
the table without freeing it.

I don't think anything leaves such a table behind today, but looking
after the walk doesn't depend on that, since the walk frees every
empty table it passes through. That's one extra walk per empty region.
I'll add to the comment why the lookup comes after the walk.

[...]
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
[...]
> > @@ -1010,9 +1010,20 @@ static void stage2_destroy_range(struct kvm_pgtable *pgt, phys_addr_t addr,
[...]
> >                   next = stage2_range_addr_end(addr, end);
> > -                KVM_PGT_FN(kvm_pgtable_stage2_destroy_range)(pgt, addr,
> > -                                                             next - addr);
> > +                kvm_pgtable_stage2_destroy_range(pgt, addr, next - addr);
>
> minor nit: Given the kvm_pgtable_stage2_destroy_range() is the only
> called from here, and this caller would benefit from the walk
> information, would it make sense to return a hint back ? Not sure how
> much of that is possible. We do this in the RMM, always return a hint
> of the next possible address. Of course this is not that expensive
> as the CCA case and could be dealt in a separate series.

kvm_pgtable_stage2_destroy_range() is also called by
kvm_pgtable_stage2_destroy(), which EL2 uses to free a pKVM guest's
stage-2, so I'd rather not change it in a fix.

Cheers,
/fuad
