Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793966649;
	b=Mc5ykSa1U0aRPmnnSZfWZXnat/qUEQvs0+fBs5UREoHs9//qTBO2Trxy/ypbHeM2CwHa
	 oKAeDAuKCZZcGUdfBcNNBG+G/90BeiPSkhtS23lChDfYD8G9k9DoAu7FoAXPiQrbrEFEb
	 dg5qQyNxe+sZv1OphlndtPfTFR32K+yTwfGJAlerKjilqxMzSVkQFykLw8OUhVEEWroVy
	 AyRCxS8Vk8ELhlALLGEkrbqoahN/OTfec0iscADi8SKmVGgbH8RIuWRVnNC+eLX2PwOEr
	 4etF+KBfKkqQHOsj7axPKNd/rxu99FHC1DtkYKfI4wrdd0L1w7mGR5MPDbcy8IyvSVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793966649;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=z2fWxPIivUBhMftF8Gk1vKGE8eRaXMmvpg6wPiGqf2I=;
	b=k3KbeTgPDpGCV3cBD3Riuvn/ROJe65RU5QwUx+2q8aYYH3Iyqy8c9/KHIIhd7kO8LWBK
	 eXaEamT1dMrMaeJYh6FAv5EKqA55pG2PbnYYL1HSZIFQ5CY71yRCuUJeCsmL0rHzMsvbN
	 bfLTvFU18gp3ZcUigcv7WBGVa8XbCLNcoZMdYpwRfHKoKje9esnXK3QuDXqNxogiSnXb2
	 GsxWSmlpsSI790ODjHBBg8Kw1y+iX/VBZa6gtCoN1sHD/PWBn1RIO5xBEbiaTuIC3Cb9J
	 pVNYT6tnqD24TuKPIBs/zmPFo8Ckupq2BfV4ywen0kdAScNmXHKG3YKq/x3XBU8mpXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=nekQqXgK;
	arc=none smtp.remote-ip=91.218.175.80
Received: from mta0.migadu.com (out-80.mta0.migadu.com [91.218.175.80])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 822BF606A33C
	for <kvmarm@lists.linux.dev>; Fri,  6 Nov 2026 12:04:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 822BF606A33C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=nekQqXgK
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=rj2O/1Kb6OAaGvUDXfJ6mwWrzDMaFwYbI8RyxwywtBQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793966646; v=1; x=1794571446;
 b=nekQqXgKCxkjsjQHV7dWIGVkBywacPlx9dqsf7JHYoqCVMHwjFpbGjsWP93zDVJH5IEBismm
 FnuwI6IZ/hvwAgjHYbmOOyqj+7iSN8bkFH6y+/guvXAyFIzHeKbGLD/BeuCg5lzGiQdRCeylYhd
 Kh7WiP6RV4tXt+/y/xuCjkBM=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 5260556b8edc27b8;
	Fri, 06 Nov 2026 12:04:06 +0000
X-Mizu-Trace-ID: 5260556b8edc27b8
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-5bff701efa5so3356e87.0
        for <kvmarm@lists.linux.dev>; Fri, 06 Nov 2026 04:04:06 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBzKhHkaR38Y/bkzROqJLdx+Xubq1XMnjM2sRgX3JopL5jD1fAVJdYASMhOsiGqIU0eiHx+Lc1g=@lists.linux.dev
X-Gm-Message-State: APuU4Z+Y8TMXb0cBhC31nWJk5lIIFFOyQn2IhTN6xKU+3TT9PVuUlmSk
	ZhOKQ3yi6ZunEtxK4TqotCmkcuIfsmUPjUsjGevm0H3RL/eLM6ESoQh/kh9eDZR87/5/svwfDIv
	EUFTere2E0nG212wqMjLbQPCDqLxUsQ3VuxhJpw5W
X-Received: by 2002:ac2:4f13:0:b0:5bf:f1ea:16cb with SMTP id
 2adb3069b0e04-5c00641eea8mr72074e87.4.1793966645378; Fri, 06 Nov 2026
 04:04:05 -0800 (PST)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261105-hyp-pool-and-map-v2-0-44a6ca90190b@cs.columbia.edu> <20261105-hyp-pool-and-map-v2-3-44a6ca90190b@cs.columbia.edu>
In-Reply-To: <20261105-hyp-pool-and-map-v2-3-44a6ca90190b@cs.columbia.edu>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Fri, 6 Nov 2026 12:03:29 +0000
X-Gmail-Original-Message-ID: <CA+EHjTx-X_2DaO6Yt-AHsP55SFWjz_EYxEr-TB9WSN-ZT+d3FQ@mail.gmail.com>
X-Gm-Features: AclHuK9hNEpLkAP5NVJokscwbXhyIypQ1gKGYucY4gZvymjkk3c1yRLXlhMVEq0
Message-ID: <CA+EHjTx-X_2DaO6Yt-AHsP55SFWjz_EYxEr-TB9WSN-ZT+d3FQ@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] KVM: arm64: Don't replace a valid hyp block
 mapping with a table
To: xuheng@cs.columbia.edu
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Quentin Perret <qperret@google.com>, Will Deacon <will@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>, 
	Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Xuheng,

On Thu, 05 Nov 2026 22:59:50 +0000, Xuheng Li <xuheng@cs.columbia.edu> wrote:
[...]
> No in-tree caller maps into an existing hyp block mapping today, so this
> cannot be triggered in mainline.  Fail such a request with -EEXIST
> instead, so that a future caller gets an error rather than silently
> losing the rest of the block.

Could you mention in the message that the WARN_ON() is fatal at EL2,
so a caller there gets a hyp panic rather than -EEXIST?
kvm_pgtable_hyp_map() is already documented as rejecting such a
mapping "with an error and a WARN()", which is a better reason than a
future caller.

Also, please don't respin series so fast. Give us time to digest the
series first :)

Cheers,
/fuad
