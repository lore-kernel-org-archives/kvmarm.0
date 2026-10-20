Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792486934;
	b=U+Z+eKn/sxJYb72aWk+bPpSraJ4f/7JPREdGlrJ8WBk+zdtZk8MtMjQRwTOIk1wWAW1w
	 ioHhoYZ27YvxXuQVs7vDuSAzgPJ62HkODL4D3wHfpwPZWJpKsK4eddYKoupI/qlXxLtc1
	 CeNKPR2o0SYKkA/qT3sXkp8cJdjL0pNM0CPrGpUav9/qd3/vHkA9m1U0T4S03vwWjThm8
	 ifdaGeImwmCiJNeACDpbi3FOGthSLMV2mmJNZHhhesLvAtEZ/G4V8Ss3XUBXrb3Yyn++q
	 pSxpRDB7P65QI9Q9gFobAYa/YwSdp4v3xa6XOZuSBg+N58B716XXkaL019PaK9MxagQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792486934;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=9m8EJZJphILGcBqQZQvehuU/fPhn1XULUzvAHjdvFco=;
	b=3BQvzQCQShpWOCKME6RZA9kB0LM8l7eI+wSIyetPNUV9b4sMJaig9V1rawh2dth0Zk4K
	 Vj8pfgK1tCMwrt3RJ16AxuTTrq9b3WBx20RhjohPSOeUTSnmFewMSlqmXQzzL18/4SDNO
	 4LZZrzeQpEc50FK3SqJwb8k+LXl0/MhGA1LqNCLZiPh8gEru99FVXQ47UZ8lILEx1tSVX
	 dFkpDyidKEmfrF4XGmWQcUHI45/zRAx8O3S7ndWvweyO+vpvUs+1PGnzFBhJ5DzyrVNG3
	 0VLgWc9SP5ovy5DHkTrKY6gomfPjy25/uLvzpSjlKbsX4wKj8C4qQXqlcV4MXKKmhig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=OhccZ+Go;
	arc=none smtp.remote-ip=209.85.128.54
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1A31606A31A
	for <kvmarm@lists.linux.dev>; Tue, 20 Oct 2026 09:02:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F1A31606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=OhccZ+Go
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4a1ec92f655so5135445e9.0
        for <kvmarm@lists.linux.dev>; Tue, 20 Oct 2026 02:02:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792486932; x=1793091732; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=9m8EJZJphILGcBqQZQvehuU/fPhn1XULUzvAHjdvFco=;
        b=OhccZ+Goi/lQkzmt6WC7NK7X618mNeQN+2BBRZtP4yYl6L9tyFugCGOhr4XUxIoQxf
         3HadovLZOlV58K/4k5QKcmgIXKvqGN9J3isuk/hFOdGfxmX4IIbLm6FcxCwfLbVVl16m
         appMd6Z/CqHiqrhdzq+rG76Gcayh0fQN1fEb6cCs2I7Mi8H2oKdrkGIKl/ybAPkpuEJm
         qsLTlEyAeh2polJ8CWTQqLyPlAkkSKUco9qg70/hkXIDE70cPYOD/YOrRznwdsFOib1+
         trlLaIJfEaLZGB3zC7JtWv5zx3pSUusPxRay5bpUnacX2L2SArJMGiTup332cxjKUwxx
         9ukA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792486932; x=1793091732;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9m8EJZJphILGcBqQZQvehuU/fPhn1XULUzvAHjdvFco=;
        b=Zj2CJwvWHgnAiRVYT9eEshoIYjQa2xcCfJGx/E5Rcy3CwsyUwD2Z/euS/mQ+SDc1RA
         d6BHAcmgALDmcwzpYq52ESpS47Pujs8ksnkNTr/j6YM6COwLQ2Jw1hRFHCec1R6ZIjr3
         075HvrRfPnqz9wGdScF5rXMIn3E6lwbD/FcwQr8F/WtV0QeMuyOeZM2hcE3B1qe4n126
         fmlRsIrOLa+u8XwZywhTRdbE436A9pSRQjzQuuPNIHiHMXODjRfNteusGE3U2DGsxbtr
         lqE8NDz3vbaric7700lHillnbad23hc6TzU73t1HwRh5duT3WFcnZup2b++m6gGgPbAW
         sBeQ==
X-Forwarded-Encrypted: i=1; AKwUvBxd6kYfPJqm82WclKZZmeyLGzFFUn3hG8QKxLdx8exjd1y0kQItKZYC1MaRR5VLN/4wepEC/qk=@lists.linux.dev
X-Gm-Message-State: AFq9FYKyY4Xnp3A7whJJq0rk49Pw5aue96lGj4w/6TL3vHmenh2lSPyQ
	YqvzIKs9kZpuA+WDjn3A9BdXMqg8k4utPPTEH0AZpkkOKjvIn91C3EOYNLjQWhkGoQ==
X-Gm-Gg: AYBFou33I9RCTtS25aRbyuXbg0dBimqff4DJAFu1T72T6fW3XDRQ6qpwrmZhA3+ad73
	4P5fGh8J1rQ+NfvuS3qxUuMFVSENmq8Tpt00b7L3ZXZJmZN0Ud9RbTuwDH5bxfooQr2mUOOvI1c
	zn8p952fAsZ9/Syc67byHqvVg7LQ+uISYwEb+c/65UPpMVe8ty+7uzFiqQDDNZK2438Fu3G+vnB
	7Zfc+IJ3DPEEeKKTrQeqB5jrP17OXbB74UZjj1mDT0x6hYWanBwHY1I4NKdDaQ0Upv1pqT0qBSM
	nDOXPtJixl8aDXvr9Jf/2w42QkltUuPh40YAsG8+mJUgslnpE2pfv2XwiT2ZYB17jkiOCj/LfNv
	sLWYvc74IFTO+kJW84Ed73gHHDWCbZY98GiNb5gT145Z80HvgMFunjnS3fEKOcLcW2fq2Aklvnv
	zi84MZVD5C7qX7EFrkquqqtCoza9OdQjTYjnEDsagF721fsYUL1Varuk1aBII3Hrg6p/pUy/CYb
	PuuLEx19LrFpACMoXVWmY+mErXz+gHajEqjp9OH87Q=
X-Received: by 2002:a05:600c:4743:b0:4a1:d899:b62f with SMTP id 5b1f17b1804b1-4a1f45f8877mr30834125e9.0.1792486931667;
        Tue, 20 Oct 2026 02:02:11 -0700 (PDT)
Received: from google.com (197.183.140.34.bc.googleusercontent.com. [34.140.183.197])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1cca30aa5sm33064205e9.2.2026.10.20.02.02.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 02:02:08 -0700 (PDT)
Date: Tue, 20 Oct 2026 10:02:00 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Snehal Koukuntla <snehalreddy@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Sebastian Ene <sebastianene@google.com>,
	Mostafa Saleh <smostafa@google.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 2/2] KVM: arm64: Support FFA_MEM_RECLAIM2 in host
 handler
Message-ID: <atcuCDHAAKZJEbHC@google.com>
References: <20261016082341.4030770-1-snehalreddy@google.com>
 <20261016082341.4030770-3-snehalreddy@google.com>
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
In-Reply-To: <20261016082341.4030770-3-snehalreddy@google.com>

On Fri, Oct 16, 2026 at 08:23:41AM +0000, Snehal Koukuntla wrote:
> FF-A v1.3 ALP5 (DEN0140 rev J) adds the FFA_MEM_RECLAIM2 interface,
> allowing an Owner to reclaim a subset of pages from a shared or lent
> memory region by populating constituent memory region descriptors in
> its TX buffer along with a starting descriptor byte offset and initial
> page index. Upon completion, the Relayer returns the number of 4K pages
> reclaimed in x3.
> 
> Support FFA_MEM_RECLAIM2 in the host FF-A proxy handler. Validate the
> register arguments, copy the constituent descriptors from the host TX
> buffer into the hypervisor's TX buffer, and check the descriptor bounds,
> the total page count and the initial page index on that copy before
> forwarding the call to the SPMD. On success, unshare the reclaimed page
> ranges from the host stage-2 page tables.
> 
> Link: https://support.arm.com/documentation/den0140/j
> Signed-off-by: Snehal Koukuntla <snehalreddy@google.com>

Reviewed-by: Vincent Donnefort <vdonnefort@google.com>

> ---
> Changes in v2:
> - Rename FFA_FN64_MEM_RECLAIM2 to FFA_MEM_RECLAIM2
> - Check that the sum of pg_cnt across all constituent descriptors
>   matches total_pages, guarding against overflow (Vincent)
> - Simplify the flags and offset alignment checks (Vincent)
> 
>  arch/arm64/kvm/hyp/nvhe/ffa.c | 126 ++++++++++++++++++++++++++++++++++
>  1 file changed, 126 insertions(+)
>

[...]
