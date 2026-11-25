Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.203
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795616844;
	b=WGMJCZPeZQWq9GiNnj8A/MkR5vr6LXsBRbJIsvAU4AHaS25savaMvZ3QBjvhQZcrWdpn
	 It3n4hEHNiqdaIPNOjwepAPGI4RR8aXKb5lnq32l0a29TW/2LwuzZHUVWLwe/9hyrW6ad
	 CmeeybtwrmDYLtYw2gSQ+i6rIZ8YyT40lWV5j7b8zWpuBwtCQ1HUOKCrindLp0itzdWGB
	 tVflCF1/XpA11I8G/5THiuY4ZkAm6W4q2ROsq45PGRQbE3vMubcvzPPs0jIrOx67e3Gvq
	 HtNgPJg3EUJQIBkOqrCZqgnh+s73gktD6DL7f83044fBv5yqIEcZv40kPUDV+qMSARw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795616844;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=mZc2jCgr+ZEG71mhrtI7bu0QzE46TwhUiStHpCur4nU=;
	b=XGRkI9IYz/8V4tzFJm/S6lAo+k4TGPJlW8rnKs6189utORL/66Gcv6pm4KXSocB3VDEQ
	 Wn3Y7QSZivgtN1/dyqXdQ3mnrV5nR9wjqGwJdhc9iNCFJmVEwdrRwSW+XA03iCqMWzL1V
	 pJi3Ew1SYCFCh3sTOsy5N3upsW3w1bJHydlntXZRXA6F0vzueAyIHbAkgbZJIrzzMzk+S
	 jHxZnsS/U+vf8dYNuivrriYY6MFGMvnbpnVRX7G6OB6L8s06AzQQxDPP1DFky8zJ54hPR
	 J4gNvzZDsUHOFpno7x7O9wah82j/R3of0cKf7D4x3yMB0o34CJ9JPCinqj156BkCeAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=auEWpafx;
	arc=none smtp.remote-ip=91.218.175.203
Received: from mta0.migadu.com (out-203.mta0.migadu.com [91.218.175.203])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96A1F606A321
	for <kvmarm@lists.linux.dev>; Wed, 25 Nov 2026 14:27:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 96A1F606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=auEWpafx
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=mZc2jCgr+ZEG71mhrtI7bu0QzE46TwhUiStHpCur4nU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795616841; v=1; x=1796221641;
 b=auEWpafxO5FC+N+IWoifGbM9SehItG+Z6S+6/YE/iLY6kN8nvAGhZGwh2h+vw/aJTHnApfU8
 XnNjcl1SnhqgTMKW5F4/okMoSfE3SutzqfqX2XrEkXjE93XhhbPApcYyRGFOGNPo34i30u1pTv9
 Rdj6/txOJ72bH2QiXYfXyFkM=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id d6e7e1e82acdb99c;
	Wed, 25 Nov 2026 14:27:21 +0000
X-Mizu-Trace-ID: d6e7e1e82acdb99c
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-5c14bc5a743so35952e87.0
        for <kvmarm@lists.linux.dev>; Wed, 25 Nov 2026 06:27:20 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErGi/UncaEWCasaCjeL3K/EpiGRQwJwi14+Fw7AuhMfEieJYYY4uySav6ybEHlYMIBF1nfEd5rU=@lists.linux.dev
X-Gm-Message-State: APuU4Z87ElttR8l43af3EO+4PFR9ia1ftdpMx449tDQTq+q+xrVkNWeN
	kL/t2dVEQdVTfOTGT2BG/ENQZC6TVasn4Imd+fPzBMqpyaDkNPVOcgIqqnJearULfWAV8Dw/X9E
	zdd0cZZrAwOssOyCTHZPgG281nljm/TNgLRVkeX3M
X-Received: by 2002:a05:6512:3ca7:b0:5bf:f060:c0f3 with SMTP id
 2adb3069b0e04-5c21a26fab2mr555752e87.12.1795616839635; Wed, 25 Nov 2026
 06:27:19 -0800 (PST)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261104140612.137869-1-vdonnefort@google.com>
In-Reply-To: <20261104140612.137869-1-vdonnefort@google.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Wed, 25 Nov 2026 14:26:43 +0000
X-Gmail-Original-Message-ID: <CA+EHjTy=DTmPBQd1tiM2Qo9CN=wRJT_S+7fX5u+gwUTWXK9+Rw@mail.gmail.com>
X-Gm-Features: Aa3M54pbT2MD_xSnGtMFqbfMy5Tkwgi8UvFa3y0WAMmC7PRuqL5G_h-h3jfQvGU
Message-ID: <CA+EHjTy=DTmPBQd1tiM2Qo9CN=wRJT_S+7fX5u+gwUTWXK9+Rw@mail.gmail.com>
Subject: Re: [PATCH v2 0/5] KVM: arm64: pkvm: Extend hypervisor entering
 tracing reasons
To: Vincent Donnefort <vdonnefort@google.com>
Cc: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, 
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, kernel-team@android.com, 
	qperret@google.com
Content-Type: text/plain; charset="UTF-8"

Hi Vincent,

For the series:
Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>

Tested on QEMU with the hypervisor trace enabled, running protected
and non-protected guests in pKVM and a non-protected guest in nVHE.

Tested-by: Fuad Tabba <fuad.tabba@linux.dev>

Cheers,
/fuad
