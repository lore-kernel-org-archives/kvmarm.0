Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794224888;
	b=x6CeKfkjHHpaXapv7hNiJlPDbm6+ZGYOQNSa3XPKroxGoJUYH6vZCHrFSq0P/TxZ4cRq
	 gs8YIqQuhMIrA3RYQq/DstKxZGKVxBmzuq/xwYJ/wfgg3CLI0jjC6FvUooGP7Ay+uty5E
	 gGy0zQl+ErPSCIiU8RcjWrzthrSghFX7ezxFe5cc5pNoX4nZ+z7y//KvZuC8K5bbNqzIm
	 PYy4lHIbtmOn9JRpcW7yS/3CAVxmXNDueeLDEPyb4FJkWBC8J4ib8tYQiaW7hqTE02bQo
	 si3kvvjzk0T5/77MNU7i5AsH613RchrGMnXGSq1X6QpvluW6Br9EJf9lu0tRJmz4h2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794224888;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=NTI6bfaVgGVs6WfACz4lcJC4XYY+Jhtgi4CMSA27Peo=;
	b=zE6O5RMl2kl4j1Bp7jzt4sgXgy089nwVY2FBm2fEtFAR3clNHeZ0AV8hxv7Vx94qwClu
	 9DcxmQ9+Gxcy1vT5MqCZf4GymmQg6K27kxj8pUV/0fgZ6w+6leBY3lNAyuP+7O3lae5oD
	 zUE0RxggssJ1LA6yvZhSreixyJwiCYtXwWaZgdMuedyFwtM+YcQJXZP3UtTmWGDazrhSM
	 hgoJ1anpKtugoT8ONlgy+o0hmqAcUkcuQbFtGlAgE5E0i1Y/W2P2MV3DEBXvy3TWJtVkr
	 sdh+dvZni12cmQrjsEjg5Sggzap2KWeI9pGkbw6eGuYEYZ5dpDg+SylgQyeH4hoDdVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=lUWIsvKR;
	arc=none smtp.remote-ip=209.85.128.54
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DE76606A326
	for <kvmarm@lists.linux.dev>; Mon,  9 Nov 2026 11:48:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7DE76606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=lUWIsvKR
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4b6266b5bc4so24355e9.1
        for <kvmarm@lists.linux.dev>; Mon, 09 Nov 2026 03:48:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794224886; x=1794829686; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=NTI6bfaVgGVs6WfACz4lcJC4XYY+Jhtgi4CMSA27Peo=;
        b=lUWIsvKRTr1hRQNI6a66k0XyS6CGwk76LruSlfaM3WUXFLmDjYFI42MGzZROwKUcog
         OZtmNLHZzPd+fqz364bdKj7e3tN8ilORr+l8N9p4DmeYHWfB1BNX/zXCARCehCzjv3xa
         0WMqQZn/PMp7uxZ/Lv3OuOvvjeDlbiOr3lXcQu4/MsYTSlpuztjaY0ytw68IFu8yrHFy
         Ux1AUVuVKIcd+IoEAA1ChA3KHSbaPKMZtLDOo/FiXKiQJxs2Y8pXMBNHSJBA/i1DciIu
         AstpoDQASPTxbG3uKq/IvmnNVFNlz/hd2Yv/kiv9kBpise0Cuoo6OeIGL+IlftxhiBUl
         3lQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794224886; x=1794829686;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NTI6bfaVgGVs6WfACz4lcJC4XYY+Jhtgi4CMSA27Peo=;
        b=t61K0sSysU0g9ptsazSfC9fvIJuwsJJywbvEeljB/Hzq3R1iSZWpG7bHcPZyeg8zr7
         6RFBUvHCKPqeM/pC04ZYImtxutKyxNTXKfWSPJvmQmaioZoRs90mKjKk4YBRm5B3UK7T
         Lah2xnFBqmhbgFnxjrbS9czyEpfg7qeO7KeCHDxM0DuqoQSSydiPnaD8wyxUoGKXqZ5c
         /7MZvt5H66/kslSjG/nal5eygoJD6tekeCtUfkji7OHuDaNn5cTdWWDgaz6vkQq2p0KU
         aOuUssgcsmrxuIDUjn+cDtuS1vA/q9cHZ2BbLObVjPyeAKJco/7pUVmfNhoVl4RwIC0N
         tVVQ==
X-Forwarded-Encrypted: i=1; AL+hErHuzHtd+GM6UPreyOCONfePqqlSDtDx/UIYzxoHbaRQRfrplhm2tYr3v3LAU1Z5Vpj0fyMWn1A=@lists.linux.dev
X-Gm-Message-State: APuU4Z/s5m7imRsfFzXA2C050aMlaqKTm0r4MjF9YzRqoT44kGlokF+l
	PDCap8Bxhr73TWOoqjn8caQ2+Z1oQoKSTaMp0QB60c/MuGS13qS0b1H9Q1rYqQp6wg==
X-Gm-Gg: AYBFou3DCDvxSrKcr4BTK+xuU7Frk1PcGFGjM5M1vtEEnvANrAmdQ3xS0QNMRVtaBMy
	hCVQFsPWJfuHG+qHHIEwesSmGilUOJDVkA9JFiLWzw63K9NzUOI0uYxS420d0IM1yPJPcqvKC8T
	eGHC1fLtULYtN2uUettztDTERt4BKKrq73mBp7ULyWiVBNVjQ3ufymCAm2HeoxEsS4zrFLMACV1
	yq5rkSvRINYD0wOgz8s88Hd64DX/rAKvxY8hWSQj3fFLj93nxoMvc8VH0NrauNPM88fRr4Js6Q1
	3mY1d/y4eHiO1za4ph+eh8ghL0zqnn9M+xGTeKf9/kvzTWOJbn9xnf9pZSrzm8hUs2C44YjRDd4
	jwYZZG/9edSgwdBc55NtehDf+VixLDLMw/64vf9T0DeLfWBDhivAUbJmnttjCnHfrQ7CM0erteb
	zbOChTq0sonEky7u90cBL0rttu5SgaZqyYgZMMN9VEc+HIckvBa2U95roU8xePuClNi8AuPmiJm
	FU/Q5wS25Vp/i66eYg9iNB1NLAXtKNGbva1c3aLrPHzGIURuQ7tfhN+SYv3H+FIvvHtraNDEyrP
	fHgqL/fP5lt3NhQP8ipoaUcDylgSY2GT2BXRFUlTxAEwEpU04lprIJ/nhvxkzZvKHXr48Q==
X-Received: by 2002:a05:600c:528f:b0:4b6:5035:d54a with SMTP id 5b1f17b1804b1-4b8aec15d44mr2258615e9.1.1794224885385;
        Mon, 09 Nov 2026 03:48:05 -0800 (PST)
Received: from google.com (160.193.189.35.bc.googleusercontent.com. [35.189.193.160])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49596f9a9ffsm9878242f8f.30.2026.11.09.03.48.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 03:48:04 -0800 (PST)
Date: Mon, 9 Nov 2026 11:47:58 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, iommu@lists.linux.dev,
	catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, joro@8bytes.org, jgg@ziepe.ca,
	mark.rutland@arm.com, qperret@google.com, tabba@google.com,
	vdonnefort@google.com
Subject: Re: [PATCH v9 16/25] iommu/arm-smmu-v3-kvm: Emulate CMDQ for host
Message-ID: <avGy7mS5A0SGib0m@google.com>
References: <20261015200903.2735565-1-smostafa@google.com>
 <20261015200903.2735565-17-smostafa@google.com>
 <au4lp8sAnWm3/Sw5@nvidia.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <au4lp8sAnWm3/Sw5@nvidia.com>

On Fri, Nov 06, 2026 at 11:08:23AM -0800, Nicolin Chen wrote:
> On Thu, Oct 15, 2026 at 08:08:47PM +0000, Mostafa Saleh wrote:
> > @@ -385,18 +482,51 @@ static bool smmu_dabt_device(struct hyp_arm_smmu_v3_device *smmu,
> >  		 */
> >  		mask = read_only & ~(IDR0_S2P | IDR0_VMID16 | IDR0_MSI | IDR0_HYP | IDR0_ATS);
> >  		break;
> > -	/* Passthrough the register access for bisectability, handled later */
> >  	case ARM_SMMU_CMDQ_BASE:
> > +		/*
> > +		 * Although allowed to use smaller size, we rely on the SMMUv3 driver
> > +		 * using 64-bit store instruction for simplicity.
> > +		 */
> > +		if (len != sizeof(u64))
> > +			break;
> >  		if (is_write) {
> >  			/* Not allowed by the architecture */
> >  			if (is_cmdq_enabled(smmu))
> 
> The spec says the register is RO when CMDQEN=0. So, maybe it should
> be allowed by just ignoring the write?
> 

Yes, that's possible, I am slightly inclined to be more strict here,
as this should never happen and if the kernel is buggy or malicous
it is better to catch the point it goes wrong rather than trying to
debug the side effects of ignoring the write as most likely it will
go wrong shortly after (timeouts or commands are ignored causing TLB
corruption...).

An alternative would be to ignore it and log something, at the moment
tracing is supported in EL2, and IIRC, logging to dmesg is also planned.

Thanks,
Mostafa

> >  	case ARM_SMMU_CMDQ_CONS:
> > +		if (len != sizeof(u32))
> > +			break;
> > +		if (is_write) {
> > +			if (WARN_ON(is_cmdq_enabled(smmu)))
> > +				break;
> 
> Ditto
> 
> Nicolin
