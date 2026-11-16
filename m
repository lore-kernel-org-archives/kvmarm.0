Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.60
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794831987;
	b=TxNQRbqE+PIT16anUqlEKwiwguQq+OyWh2PILOyyXpm/u45Wo6fbwYjjCR2WK/L/vWha
	 lcl2zw/F44sCUdSuKfpxIMSSw717YX/VhFPPA/7wnHVxJyZuyAUdVX8mMeptDf864rKba
	 +6TCWAgt0UOX0WVhUhpVm0khKpWQBCW/MGOVtC7cl8sVtZ+jczm6+TUl1hraCp673R05j
	 QStM7mpcIgnJ885cGh4QDZGGFT7mEQw46Q2/AXGDcq/ucIfdRj5qhdqkfo9F7tyu8ICiU
	 zrGr0zBFnz52hzcOVG2lZ6lrJYc8KKFHAIgcFTJqNmjWrsuX9yM24bwEuT9m0eCEEeA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794831987;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=n0Epwbp8Lzi+kI0RuXeSMG9mic2jpFCzQkf5ONSBZoI=;
	b=cSx7tmv8LP+1MMLBTa8C1JDu5zsCwsvJcYsp268gAiNQR34b+2vx79+YzXmpnpXs4XTw
	 T/vT42QYkQyT/FQOwCF8l1uQzsEN5crWbhAhtwwcEFTei71jHksYvIT2wxaWC+AD+AwWY
	 Dl/M019l94nhoSSGexoD/KBz1iK0CZ8OVo/HcR/PIWpjLSkDabxXxXqq5Xd4n95S0YptI
	 N6KAEGHPA0ObQ2PdqJ/WQoSyxUw+WKHQwoBa12iahkwZv9Md5qYYLDc2eEj4QS60u3UFU
	 zIz0d/6oxeI7+5g+5M6eAycblmBfub3jshVSbuX+EWZ3/M6DyYcPEpA/jQhOQ2UKX/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=tGogcp67;
	arc=none smtp.remote-ip=95.215.58.60
Received: from mta1.migadu.com (out-60.mta1.migadu.com [95.215.58.60])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7D5B606A333
	for <kvmarm@lists.linux.dev>; Mon, 16 Nov 2026 12:26:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D7D5B606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=tGogcp67
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=rMg7ePytN4P08Ni21SDstdH+iA+/lX/CBMDE9CVdeAk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794831985; v=1; x=1795436785;
 b=tGogcp67w2qsswyi6vEI28wl/KlV4kNE1MicEWsAkiz34N+dm/BO6lu2nGTTsxYdPbtduJLg
 zVG5BhueE+BEUvkek7ZYkcBF8dF536TM1Ux8w5NQPiLMQwsvB/JdanZEVdtG0EtTKeK2Z3zfF88
 +ckgs/tCQ3xp7ypsms43a2jM=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 1c459341e44785fd;
	Mon, 16 Nov 2026 12:26:24 +0000
X-Mizu-Trace-ID: 1c459341e44785fd
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-5c14bc5a743so9073e87.0
        for <kvmarm@lists.linux.dev>; Mon, 16 Nov 2026 04:26:20 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErH8xA+1siEE/txt/LL9NM4OTEwOe/EvTNikIP64WBEG9/Sqary6vNExtybrlstLP1RgqKrHx/o=@lists.linux.dev
X-Gm-Message-State: APuU4Z+BNocSPOHe1ADWZas4ZoF1XMU7KcCtBZokmNZCz56+PdxDoZSj
	Y6o611OEvA8JhB9r1EiLQ7iSXyMOjFUSXUasyoA6erJUcFA4MSYK5/Rph/e0TjAnCr/0XZGAsGD
	h8AgxrXf+kz729zjIhNX4nuqYH5EERGhLOik8U8yN
X-Received: by 2002:a05:6512:3e22:b0:5c1:56f6:2f50 with SMTP id
 2adb3069b0e04-5c17d6151bemr251895e87.1.1794831979748; Mon, 16 Nov 2026
 04:26:19 -0800 (PST)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261116110549.1863653-1-fuad.tabba@linux.dev> <avro44jUWOARFzul@google.com>
In-Reply-To: <avro44jUWOARFzul@google.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Mon, 16 Nov 2026 12:25:43 +0000
X-Gmail-Original-Message-ID: <CA+EHjTxWuiyjmUc3vH_KxRtS_3oX5w=CE76LdsLcrqC+RzLGfg@mail.gmail.com>
X-Gm-Features: Aa3M54okcmr9MdJAy7XSmuEmAJr7gqz5micdc5fGZdFcC1JtmeOKxVLrP8oEceQ
Message-ID: <CA+EHjTxWuiyjmUc3vH_KxRtS_3oX5w=CE76LdsLcrqC+RzLGfg@mail.gmail.com>
Subject: Re: [PATCH] drivers/virt: pkvm: Zero and clean memory before sharing
 it with the host
To: Vincent Donnefort <vdonnefort@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	"Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Marc Zyngier <maz@kernel.org>, Mostafa Saleh <smostafa@google.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-coco@lists.linux.dev, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Vincent,

On Mon, 16 Nov 2026 at 11:28, Vincent Donnefort <vdonnefort@google.com> wrote:
[...]
> > +     /*
> > +      * The host can read the pages as soon as they are shared, possibly
> > +      * through a Non-cacheable mapping. No caller relies on their contents.
> > +      */
> > +     memset((void *)addr, 0, size);
>
> Are we sure we want that? The guest may want to setup memory and then share it.
> I am not sure about modifying this API.

Right! I wanted to fix the bug for the ITS property table, which is
shared before it's initialized, and totally forgot that this is the
path all sharing goes through... I'll drop this, and put that fix back
in the ITS series.

> > +     dcache_clean_poc(addr, addr + size);
>
> I believe the hypervisor is already doing the cache maintainance when the page
> is mapped back into the host. (see stage2_map_walker_try_leaf())

I don't think it does on this path. host_mmu.mm_ops doesn't have a
dcache_clean_inval_poc() callback, so stage2_map_walker_try_leaf()
doesn't do the CMO for a host mapping. On the guest's side,
__pkvm_guest_share_host() only changes the software bits of the
existing mapping, and the walker returns before the CMO in that case.

Cheers,
/fuad
