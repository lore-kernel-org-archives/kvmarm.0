Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43C8C327C01
	for <kvmarm@lists.linux.dev>; Wed, 19 Nov 2025 19:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763579539; cv=none; b=BHM0/4mZ+B+RPq2bPTcOJX2eCXwawnFVGCicjtcAyLjIv1Cs3yCuZFn4u3Wbn85vFP1LkUG64wTUTVlJMNuMw2Z/SpW30iwfNb8kJmnCTdx3GsR/ZXnWFEGQCnSf0ac1NhL72gurKDxMJvMK4zPrrHvwVdVUbhUiOvi4IbyLAmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763579539; c=relaxed/simple;
	bh=YFYWHJim5jvnsNE5kctSr58nUHH8C6Iq4/D+0cJ/Qe4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ItVuEZAFksLMvbQV5vxbPZEXshpDTq1G03YxleiWiLDTKryHVr5VS7tiUpESq7tVanBHTqZjHTKZLcpqUCY/oNWMQs4bh9wc/jnrcjcvZzec1+c/YyDpoUc/oW6eJhbUjsaXr3mPCqBb5ToIgb6ZIgFmv9t6XzgoGEAlkF+mh6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Buwc6nLn; arc=none smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Buwc6nLn"
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-b6ceb3b68eeso24683a12.2
        for <kvmarm@lists.linux.dev>; Wed, 19 Nov 2025 11:12:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763579534; x=1764184334; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tGpjcoQG0e7rkN9MYV2/Te01/UoG0xUfXMTePukkKCU=;
        b=Buwc6nLnSA7Xh/0RzaS8vfEQN3e7gHfabGPNnlhvrDz2jkjUoq7Nf5O2UurQI4K3PV
         oD27ef0oKr5XanakfxSiHKYsmmZOcN8w4mFj3SGFP0hBYUwYSIXpHhRReC4x8+eYwJqq
         drhRMbpAzOP575MJf8oxF0HuiuycyUPe6a7aDkDRgtov0vr5f7f/Y9MRfCMKZn7KtxRE
         TWqi61a1byZ5k0qeJ4ebZYkxkilhbemiETYj7/PtqTJ45wCBaJc9F+TgL4BAGTb/fY8e
         YQ53HLlGBHfT3tuKNDU1AMy+6AX/kleuFg/4ko4k2JeggQSDgLK6tT37hQPrcGwlyVkk
         at3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763579534; x=1764184334;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tGpjcoQG0e7rkN9MYV2/Te01/UoG0xUfXMTePukkKCU=;
        b=ID7MKjh5UZS4E21/amNDS3IW2ajeUPPLxA8OGsaKyzQu660N9FEJWq3mu7LZEG86Nu
         QYpyzigfhVBRgvz4RjQh0MVzUszHNZKccUKXWU9UGXi/Efnadu3rWDwmxIdsv0xGVRgj
         DgKAFjXdlJ/BaKcZen+aUjRzhr1yOhamD7sQG2r3AKK0uh5POZkUf/5YfdnhhQSvdZER
         ndetIVDWT9t2AYDjMaALVIaLJovw63Hx3ztHTL4phyaDBp9FkNBw3IWpGWluFe/ogrhz
         ADMfzwVr+AXYtU1LIO0UafPdu/2NYuEEOe+qNDEM6y6jzWWXuKzbLXsbJCi/8Qv8I8P2
         SXZA==
X-Gm-Message-State: AOJu0YxKE4gr4hWZZl+I10oM1uxKu0Ud6jB4WNpK/EccTbeZXLDJlBrL
	k8RSHB4DSU1Pzw6EykvNtrfGuO+8eWm1A+UJNoRUnXtm/kd7AxbOGn3r
X-Gm-Gg: ASbGncsalUuBJpNsyLk3viv+Qbtc+uTm5HyHhQhFNHVkJn8mzrUG5GnEKFmBY8ux4hm
	MiAtQvQbDSSA5YoyLbU53HP1T/RA3YN205SooY7cN09LrONo0OVt6pi1zIuAfK9Cwy9Ddsk/UfJ
	/Xcz3JdnPPqSlgbfb3oTrJnb8Rkxr6EAeK8e2jriffX51y5pB2AaTWsPxOAgItDM+WsuGb4lin0
	OMuA0OVgFPuKcFb/iz93dZUYGGYxeEOv/9jlJy+fYrTWNPK3RtX3GjN1LE/Ei6QOj+YPnchjvoD
	gcOdXpCFCSGpT8xF2PF5kz+mJ2Pw83RYKBIjQc2OtYqS7BTlXs1uKTKKhrd5fG6YCxmXIRBO6bm
	NPKOR440ZDm09g1Z7Q3pbyw0aXuAf9+JCGzF97U9jws4mc6CsyloYc5DyAhNkKoIAtfthSkr15A
	nwh09ex3ZPezPguRd/ZQdY+ns1RFDtEShkyCvRXoD0yGIqc+TTZjORbw==
X-Google-Smtp-Source: AGHT+IE2LGJD/7c4DA3p6/9s6dAr0K6Ncy9jizQyd9jeLiMsAlG9mSVSRDL/rbnn7zDZI0B/YAvt2w==
X-Received: by 2002:a05:7300:880c:b0:2a4:75f1:fb27 with SMTP id 5a478bee46e88-2a6fd1215f4mr104587eec.25.1763579533584;
        Wed, 19 Nov 2025 11:12:13 -0800 (PST)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2a6fc38a66bsm1125718eec.1.2025.11.19.11.12.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Nov 2025 11:12:13 -0800 (PST)
Date: Wed, 19 Nov 2025 11:12:10 -0800
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: Oliver Upton <oupton@kernel.org>
Cc: kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 0/2] KVM: arm64: Fixes to KVM struct allocation
Message-ID: <aR4WiqooLbKfshKw@fedora>
References: <20251119093822.2513142-1-oupton@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251119093822.2513142-1-oupton@kernel.org>

On Wed, Nov 19, 2025 at 01:38:20AM -0800, Oliver Upton wrote:
> Small fix to drop __GFP_HIGHMEM from KVM struct allocation GFP flags,
> which was always completely pointless and now trips a WARN for passing
> such an unsupported flag to vmalloc().
> 
> Oliver Upton (2):
>   KVM: arm64: Drop useless __GFP_HIGHMEM from kvm struct allocation
>   KVM: arm64: Use kvzalloc() for kvm struct allocation
> 
>  arch/arm64/kvm/arm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

For the series:

Acked-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
