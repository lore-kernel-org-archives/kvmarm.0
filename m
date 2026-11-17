Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.44
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794925056;
	b=P478bXPdjedjiBkNerj0uP+hHT0Pk6WmvvGBWvOkYCb6VM/SjtXnVKF6vrt87So1F/TT
	 LnQabqH2K3TvXRRf6YrbXarPzeigxDHIYuIiQdaP9ZbZA/bjzc/0UFK8wdi/roJDGshvg
	 x9ZqZ8yHWIoUlQ5SqemFXO6WWgUS3MPB9q/Bgf/O7TR516XSahZbskipNSZ3wOL6YOIzh
	 EbQbPT7RAoNI8wkp4hGAU7jfVzJa47GIT/qseJqfw9MtEsudxwXki0gwW1t9teO9BPWzS
	 M8nhU09LtIv6QfyPOO4FuX9AIfXPxF1Vd3aJz5UDtyZraZz+sPYmG76qOHEXw59nPpg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794925056;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=BLybj40HRrk+JRnjEtELwllmhvie6n0a34/NGObtXmQ=;
	b=hzzJSphNKw5+Oc7Bc4+rRa13lMifh/AmpWAvxCI3vuSoRUG8vLeSgW2daMLN8cqNrraX
	 DvzcX4bI7ElpCvehm4QwlTLzEMAzPZy4wRffLzdBt5IUe9VqeIsMU/TVYoejemAIXNnfw
	 q8JfkOdq4qbPEkKEus/vGxusukl7XTi6AQ6aBPqO0toIZYMAEhZ2epXG1pdsYRC02E4S1
	 m8ARjxZTuNQ3Wk/9c7OslDvkLXf0WTpQyGZLp7+FqAerlPotOzXH16Px8zlM4csXiylQF
	 4S96OAvBmuxY5TNjabiXGsai4eRDRvxSA+mrhRHZY65izkBddWwxWRQ0CsEH2Rozn0A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Zy7Y2I2V;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.44
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B0AF606A329
	for <kvmarm@lists.linux.dev>; Tue, 17 Nov 2026 14:17:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6B0AF606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Zy7Y2I2V
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-5c14bc5a743so9517e87.0
        for <kvmarm@lists.linux.dev>; Tue, 17 Nov 2026 06:17:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794925055; cv=none;
        d=google.com; s=arc-20260327;
        b=KzrZddeplvfgWYTXFd9zmwQIOiNIghxqjV/KXl9MdM1jrHA4sOgsifBUyGnF8u1oC3
         pvCbmKpXCVjkF/vljGJb+8coX8Ten6ExIgTkS9MeQv5C/H3scpjs4C8dYXpF+xWoPs+Q
         Vn0S7wTJmZiRuYJ6VwduZ7JPFkKBwTuSLS6BS/z58G7j91wj+Z6CQpstArbmO428seHI
         M5DMRdv2HDGFM8WD6KOn4SAhwptJNeBX8xmRs4Ng14VT78AS66d6ljb4FKy2ei9JNwkB
         YNz7K33m4RsltVuVdJIFD3rFwHGXzBdR2F9g2L9toEsK6ukCgGw8RNhh5TI/7RM9RAAD
         YsWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=BLybj40HRrk+JRnjEtELwllmhvie6n0a34/NGObtXmQ=;
        fh=9HC9ZnwQC0+nDbdbSFY4CfOTr/Y4fIEQ4onOPZu8D5M=;
        b=XJ/Me5Msr7dN3Dq3RTrI8VpTmkBiU4DxBumCm81O1pNxiVSrXzDxeQu6LJ4/72knqF
         WIhG6W01oPTY+s8M4usl8RNdoe0+ygjXU6m7jreTUxmiwlSwaYSjagwSeKfT1mSvo7SN
         s5ono+wI2g7JPahzzms1syF4aMO+rjlYie0KaEMlPxarj8wLHLh3oeJf5UWhVZedXR6c
         btKZDbXx0FsQ/I1UEfk76QkCZbg8JTIjGeqIHaz+YIfyb1BxMTcxoGWOEdCH268ArZXW
         Or3QzbIP9yN0xC2r0BTgmmI/NfMxFn+i8n3zxJHlc4ex8GkIKVu7YdcoBcuKmdiFzDWJ
         2i4Q==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794925054; x=1795529854; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BLybj40HRrk+JRnjEtELwllmhvie6n0a34/NGObtXmQ=;
        b=Zy7Y2I2V4Gu/thzoHqPBjMuzhdVyAiTKPySRmgGAf+r23tCJT89onYGEyoLIdNTiGK
         nT55I7je2PM/1av0glt/NIRNwhKi9+cq2jAAylcQGlPLpsBmmjWsBd0nCFkJg+sgWdTM
         QqrabDJeEajXOJLo+3GWPGjFeSAd7Pwzw/opRrAPPfpLdWUdz/aL0ft4hN25QkGTTMw8
         TwVuToIGmsKIU6M3yox1KKFfzLoRl7IcXeT6KDbmS5Imv9lmPSTJvZk1JlJTpqfgvFXP
         GV0x7vdoLh4azaJgQ9OsPKeqVjdwxiwaFcpWj0+7VKeUFtC/TJA06qVF46smdE17UJOf
         igsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794925054; x=1795529854;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=BLybj40HRrk+JRnjEtELwllmhvie6n0a34/NGObtXmQ=;
        b=m5Z/939c0yv9mDLyDw20NCXAnDeGNSnt7vd0UiGTuzqm4CDZWuRSZ4ZtyoqjT5kgle
         OTi6mg6lQTWVduYmq53AJzeQpyglOnp34MS+KQnFFlsIeH1yMCzqqzez/GEuLMlu9wJp
         OWLwkakiCEvN6awzRx28XuFK3eetpbLwVOUZ1KZtNn3GpAk7Wbfq0hiX2KY2MDaMnCF+
         ZvkMIC3Wl+VGqV89cR6Oh7Kxl1y+LUF4jAVdaFiaE+S1iPdCU2yGHV2rAghptgOatrtf
         p2NDlIol1Ewd/br5/lpzSN8PDxghaZaFQun7gGg1ZFm+4xJpAxB1STDYvUwkYicgPBlg
         VlkA==
X-Forwarded-Encrypted: i=1; AL+hErELicI20QwqibkiLfCcCPM7CmNAnUwK9dKyxYRUWr6woGdhOv0Oq3WgONjOt3/ScYp6RaFlYAE=@lists.linux.dev
X-Gm-Message-State: APuU4Z8SZNdgSxTCqLMssEDBykM1O5DxR/kBLoFUCuz57IvSv6nF7yIo
	ylt9ef3/a30wpACr86jMUtKMJK1SRpaRZ84MeXbws+NpHpv97GdpopocPVRPO5whqjCRkcXZxDB
	TSH6glVG2v7++sazsnonb8R+qDTlyDfQZNbnIkMaa
X-Gm-Gg: AYBFou0lR8iRR0i3Q0AB3ZKWGc9VISpiW3l+X9g3AAZXsLCYwYLTLrqq9KTomlVV50A
	NljqjxudMss1YA5ofHEx0tlGE/9kxfhLbASWSOAK7G0NPSPTR6MnJGrsJ+QM1G9gWFb7m1eNHIo
	zjBak3CLfxOYWq2pj2SJWBztQvrTKBJO/6JZB5gSE68VEXrPYB9jrbjWLPYDv/qSeJe2Rk6yPEl
	qF3CYrPP/NvYLKVNgveC3SK7SmlUEqLOyIpXWb3rHt88c3K/moi/dqV0QbLyP3jRC/g5Jnj97N+
	Eo+g72K46BeyFdHiq2lD0C510YDRFkXj6/4DMoilrbQChwARO7eC+Z77SzDwt3U+zcZARcYH4E6
	C3Z5K31zHHmSicJbY9uR6IiunhPyGdwvGHHqi8KSRdvFaC0gE7aRZS8WOZ15W+opj8ckf+tgH/M
	givMMBhSo03Bm2YWGD78kNV10=
X-Received: by 2002:a05:6512:1320:b0:5bf:f060:c0f3 with SMTP id
 2adb3069b0e04-5c1a218237bmr141450e87.12.1794925053973; Tue, 17 Nov 2026
 06:17:33 -0800 (PST)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261116164358.142785-1-steven.price@arm.com> <20261116164358.142785-4-steven.price@arm.com>
In-Reply-To: <20261116164358.142785-4-steven.price@arm.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 17 Nov 2026 14:16:57 +0000
X-Gm-Features: AclHuK961RRQGs05YcwTvTpXpMcWfGbS65nrobWrGykL5gw3Ev5XjAPi08pa1t0
Message-ID: <CA+EHjTyeE0gbLgfiDePPVRR88GFVa7G-G8sr8k6vzM7v_uHxdA@mail.gmail.com>
Subject: Re: [PATCH v3 03/11] KVM: arm64: Handle attributes in stage2_unmap_range
To: Steven Price <steven.price@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Christoffer Dall <christoffer.dall@arm.com>, linux-coco@lists.linux.dev, 
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, Gavin Shan <gshan@redhat.com>, 
	Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun <alpergun@google.com>, 
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>, 
	Vishal Annapurve <vannapurve@google.com>, WeiLin.Chang@arm.com, 
	Lorenzo Pieralisi <lpieralisi@kernel.org>, Kohei Enju <enju.kohei@fujitsu.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, 16 Nov 2026 16:43:49 +0000, Steven Price <steven.price@arm.com> wrote:
[...]
> With the introduction of private memory support, we need to
> handle invalidation requests with filters for a given type.
> Add support for passing the attributes down.

nit: what this passes down is a filter rather than attributes, in both
the subject and the message.

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>

Cheers,
/fuad
