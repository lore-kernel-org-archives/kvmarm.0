Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB415129A60
	for <kvmarm@lists.linux.dev>; Mon, 26 Feb 2024 14:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708956760; cv=none; b=qWdSYb3R1BPa4Ux14hAmjL6iIrfyb0KRZTYuo4pAquxQ6GkilRTVhtiMSPl1Q/Yh5eIKnwbAD447L1t1+1sugvUOz8qHc2B5oBFLrYHIp0ZgNBfw9MTWSAIS1+331mEhjzG/DHmX6fQKlKw4bpg2Fv1/81DodTHsy7hTJFZQm78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708956760; c=relaxed/simple;
	bh=A/EwKKFTHq9+UV9wd+Ov3mtNuR3zx7HttqwVAOODPzg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EkPepnIim93hZYOSlB0+rViLTK+7EgiZgp6Gs61mPkdkhHxJrRbak/9FhbKQT3buYVW7aivCLkk3sjjK0dPnC+Gux/TEKhqmcWyO9gA/3HRVx4nX23LoYD6j+daVDlzZiEvN3maHbMduAzT6u422SRD1SoD83cylqv7BZnLxQY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Jm4sd/mb; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Jm4sd/mb"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-412a8d9402eso2553145e9.0
        for <kvmarm@lists.linux.dev>; Mon, 26 Feb 2024 06:12:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1708956757; x=1709561557; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=opvKQ7pk9+ZOHfw7awaAV2ZGrvnpC0iaXUg4k8IUpnw=;
        b=Jm4sd/mb1qo1O5MK9fCPRPCfynTeHyqLOlPsoP5ms4TQQDL/OZmwPH0nk8Lb47AU26
         pIfFKoDwFDNhFrV0bdCxYrRDcWGFLA2VjPyYchHg5utct79Rsmn277sc5qro2wEVKF+L
         3eP1Tpyj6QlIQbcZAd2saZ9fmhP/5Zj4IaA+55/mfilq1oEWYk7vy3ojX/dhL/UGJT5B
         BYbRP52ty8SILVjOLVpBz1FyirawqtpBeQpBwO5ff3qH7KrUGv6TDdl/Lifry8ArKz8R
         XEQlZgAEs7yzyvUF5atwGW2wMEJAgTeYqiTgSNsbIRhpVlpCkNKNjuWHfx60Pbngd572
         RzgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708956757; x=1709561557;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=opvKQ7pk9+ZOHfw7awaAV2ZGrvnpC0iaXUg4k8IUpnw=;
        b=K1up5Nyzh+LVHBLYaUj15Ab254zFfi5wO4rTKxv45InRUV3ezowiPUgyIJoEdhiJ9J
         kiMe49vKSBEQMJTkwqxHNkLi9oQ6jaKduVg2s4CAdPxpIUfmEtDFaYg5glAKAeQ2Z8AD
         rlR07HJx28iPB9Ydh6d50U6aEGN/MukaFuESoQSwukxqGYhBTe7mUcc+eSPW9uhdm8Xk
         IpkWu7aY3tKKLNSTj5simTAdjM9XNQYri0GYoHtpq59QBW5he5dg2UhGATlRMUk+j+DD
         4qEiexvxRRH0TdRVW2plxeoktuj5oW3Ped97oG2D7YmF1z9d38xiyoPJ0khaODNkC1Q2
         0ueg==
X-Forwarded-Encrypted: i=1; AJvYcCUQ4QbswAJfZA/oQGQvpUtJWDGfsk1n5bccJ+5q+6YOotP+Q7qhB4g8RkzyzNaKDTtbi6mqBeZkEO/B2kdXs6IZlevHjDPW
X-Gm-Message-State: AOJu0YyijdHVaRSG+emouwdDurPY6AvwuxZnX3sEK6b2x8P1SZeSnJAu
	ClTcKPaJG+ao3J/JDEjBzzr3TKa2DL7t97wuVX6uPTj85WIRDhqD2F0m+V7Wh0Q=
X-Google-Smtp-Source: AGHT+IEXDyGxCMeMUIAcAEuPZ7NNSc7bU/cKvZtROLGEJzvNqVfVr4GRFQDgQFpthCMgqCFSmsPRPw==
X-Received: by 2002:a05:6000:120a:b0:33d:2567:995c with SMTP id e10-20020a056000120a00b0033d2567995cmr5185055wrx.1.1708956757142;
        Mon, 26 Feb 2024 06:12:37 -0800 (PST)
Received: from myrica ([2.221.137.100])
        by smtp.gmail.com with ESMTPSA id k29-20020adfb35d000000b0033de2f2a88dsm1434832wrd.103.2024.02.26.06.12.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Feb 2024 06:12:36 -0800 (PST)
Date: Mon, 26 Feb 2024 14:12:13 +0000
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: Mostafa Saleh <smostafa@google.com>
Cc: maz@kernel.org, catalin.marinas@arm.com, will@kernel.org,
	joro@8bytes.org, robin.murphy@arm.com, james.morse@arm.com,
	suzuki.poulose@arm.com, oliver.upton@linux.dev,
	yuzenghui@huawei.com, dbrazdil@google.com, ryan.roberts@arm.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	iommu@lists.linux.dev
Subject: Re: [RFC PATCH 20/45] KVM: arm64: iommu: Add map() and unmap()
 operations
Message-ID: <20240226141213.GB1579460@myrica>
References: <20230201125328.2186498-1-jean-philippe@linaro.org>
 <20230201125328.2186498-21-jean-philippe@linaro.org>
 <Zc9OHq2NO3X7DsSO@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zc9OHq2NO3X7DsSO@google.com>

On Fri, Feb 16, 2024 at 11:59:26AM +0000, Mostafa Saleh wrote:
> > +#define IOMMU_PROT_MASK (IOMMU_READ | IOMMU_WRITE | IOMMU_CACHE |\
> > +			 IOMMU_NOEXEC | IOMMU_MMIO)
> Is there a reason IOMMU_PRIV is not allowed?

No I probably just forgot it

Thanks,
Jean

