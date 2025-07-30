Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACD2D174EE4
	for <kvmarm@lists.linux.dev>; Wed, 30 Jul 2025 16:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753891411; cv=none; b=cDwzEDUQW2ZKEgQM7Gn7A6vHY0+ugtGANW9dw8XNkQKYATm4Ggd36nScMx8FU+l2pCXlb+TBptZuWCHXtTKtWxynqh5guBHD6cfj8QBwIMWCdOM7XEvliMdFQSuRyVcU2F7fniTuJfAduaD0IpgxdoQmtbpo1cg6YMB5oOSVsjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753891411; c=relaxed/simple;
	bh=JD/vxYw0vyKQComxP4E1Z53ndDUYTzU3hErVNH+AgZo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JoKmHh9g0UlWege8q9+fOPZkSmf8HfZBWJQFGHLsYJsdJg0hQNTBDddbzf6uK4TQPKyU2Rzi8UGBngnFPWMhM1KyAwvWpwnfNR24DXdiwup2XBAGkS2HkyqFdyReEfCN0WfMFLpPQrs/by4gUGYh3Af/UPl9sLTmB+KC37Fwn48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=Suzp+4cX; arc=none smtp.client-ip=209.85.219.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="Suzp+4cX"
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-7074bad053aso28367286d6.3
        for <kvmarm@lists.linux.dev>; Wed, 30 Jul 2025 09:03:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1753891409; x=1754496209; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JD/vxYw0vyKQComxP4E1Z53ndDUYTzU3hErVNH+AgZo=;
        b=Suzp+4cXzfD/G53FQ6QfpAoSzMTC7udC7/m7lMRyTRjrnVyW2ULv0qJ62S/LglToi/
         hK0CJsxQ/CwymRhvEqUfYv0IrlWrSOrQNJncH/f0XSZQx1Xfs6jV1ugD6CtVpB8QgVaz
         +cBuvUPyqaziVDEIyc/LGDiDchJt7XfmP81uIKWeWGK3hMeIu0YFn/HtE3qH4BccVgdH
         UkBXSxwRjQgdoCkGiIuJ3bgNl61HcWgwbJrxFFKr5FYnq0ZS+T8DG5b1hCzMwX6N7fPi
         WnRQ6COJQQlxa7TuoIPbxmJfYO+8NQ0/8zRXm8D+TWHvVrsQM+vTplzfU1TeXe3fb1//
         4L6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753891409; x=1754496209;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JD/vxYw0vyKQComxP4E1Z53ndDUYTzU3hErVNH+AgZo=;
        b=pVepXQm2RNBTiPXnhC0gDqaT/hMo2RHkvbZyJrYCsTlS8tnvlbkMWw2UUO27iZ4ABE
         3WFnM+laUyIgcH1dc8QFGtNvYVKcNj611nJozt2bFYCcBMFO5MaRle7xgGtlJeDt9tqA
         fV7FoSqzoKbLya31tr+2jEqHQ9WaVY/oz4HKBI4FIrANOsGPT473/Yt7fYR/PCtxbw8w
         iYR5xBuSjtKMruY8f+M+uwm22Vvd6AoQR/qrhW90m82mtHCNZq/KdCINSVpcDd9TzDyw
         EFoyHIsa83dkxyGPD7Oxwc2yiKNS1mcE37ClFJOUcNqKxCcJq7I/OzSL/gHoLysKiMDV
         TWuA==
X-Forwarded-Encrypted: i=1; AJvYcCXc3V9Hvh0Xt4dVWXawQ980y2nTLm7FlkkQIQXjjOSrTOywAb1Dy1sT8SkoPJFoT94rBgXh61U=@lists.linux.dev
X-Gm-Message-State: AOJu0YwjMKbNltHKO6nC5sQcc051/+bPuZlOpH5Ol+U8YfdfRH4uCQLH
	DUOOKLZsxCvtZGsEEPEYgi+A1JhuXIxSZJc5cmRxg78bp2uVaRwAEWXtYY92b+u4zSxnmS37vPn
	reApq
X-Gm-Gg: ASbGncuPluRyasFDX4oLyfW5js4gSB7XuJS5vEdHyQPR7zmNYhC0EMYSl5TMy/b5CRh
	jKhy91n+nh1yk60nwA3pi+3hjhHl2T3JfbqN1rX/VKD8jIWxcpxj4IZWt8k7HquHJXvHTvs+S2J
	ERNH1tmsOyUq8O9XpTllUecaakwwo5eJRunaV026dBtQRbMC8sAFLH+oA1LdMAan1WrQzoX/PcF
	F3lFRK6BEUg2GNlPtG13f+8/T2c4daAy1LVG6B0GO+uwAQSChHmg0YT1qpGrLhNe0KnEt1791uC
	HABE6R6ldQ7Wkau+XwDwBhHssG0URruO1JIzDDktH24YqrGgaYNCeXZkGqEcFMUQ1wgbyAM7yVf
	JCZJyGBtoEpaY2akdrqIyGYj5G6H+x+oVXAydeAukPZ9D5Tb1fsvnu1HmIlsh+iH4Jfdt
X-Google-Smtp-Source: AGHT+IELABFxJjSRVnbcoDgQoyF3DZZtzde7lxM9LhmXgjrOqotsrSt3Aw3+tn7CmcIoh22Vu+LWXA==
X-Received: by 2002:a05:6214:5296:b0:707:4825:ff41 with SMTP id 6a1803df08f44-707672d91b7mr47058816d6.42.1753891407540;
        Wed, 30 Jul 2025 09:03:27 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-70742e70964sm47845006d6.23.2025.07.30.09.03.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Jul 2025 09:03:26 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1uh9H4-00000000SCB-0SyY;
	Wed, 30 Jul 2025 13:03:26 -0300
Date: Wed, 30 Jul 2025 13:03:26 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
Cc: linux-coco@lists.linux.dev, kvmarm@lists.linux.dev,
	linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
	aik@amd.com, lukas@wunner.de, Samuel Ortiz <sameo@rivosinc.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Steven Price <steven.price@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [RFC PATCH v1 00/38] ARM CCA Device Assignment support
Message-ID: <20250730160326.GN26511@ziepe.ca>
References: <20250728135216.48084-1-aneesh.kumar@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250728135216.48084-1-aneesh.kumar@kernel.org>

On Mon, Jul 28, 2025 at 07:21:37PM +0530, Aneesh Kumar K.V (Arm) wrote:
> This patch series implements support for Device Assignment in the ARM CCA
> architecture. The code changes are based on Alp12 specification published here
> [1].

Robin and I were talking about CCA and DMA here:

https://lore.kernel.org/r/6c5fb9f0-c608-4e19-8c60-5d8cef3efbdf@arm.com

What do you think about pulling some of this out and trying to
independently push a series getting the DMA API layers ready for
device assignment?

I think there will be some discussion on these points, it would be
good to get started.

Jason
