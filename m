Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794307297;
	b=mtxAg2JJjQ8RsLhKSubWKRz46GF+qafpg+An8VwwO5mbVic112/Iy1F3nNyJx9AGC1RL
	 iJ+N/B1Fqi/UN0omwhc+DgY9eSn5nFi+yvbxsd22Jy7trNFB8SsEJW4GGFOAVGjYHZWYo
	 gHq24O6PMJUaabf5uGNjN6UO7FFk5+j58V5GNAcBUVlSqInX8VfXqSS9SNO+lUX/4hlHu
	 H0egr60sZF1E/kyLtQ6XUfPZmKjAw+pot+IaZUaZRgbgm4tzRtuvnAE0C61cQQ69czu5s
	 i7TIkFQ9CIKPA5uCZVidLrviXMQUZszYBr/4FgKu5wFdTK2RzrNXmTw9J6HJbok6g/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794307297;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=R9ybw6cxS0shDJ4UVVgiEKCnqeSU4VPhRG8DzGKzjow=;
	b=EbIoWi6B/722o//o5Ol6uD0NyKITwEESL1W8ujoYYKMLiLCNjWgYMNJymYl1BQeeXp7f
	 LUNh1uGffcXrrtTgVPtZOwxGXR/hDbYsAGM630ubNzDOtldvPHYww9qB3If+kyE6quWl1
	 jhJKCW9vv5i5zF8dDP8MFs6u8vuJBsmDU2JVspOCkOJpD14X8m4KExv/70DheOc+2jOrc
	 TXVJ5J5ckPrIJg/KWwBVhdjmxaRtY9y8MXsHDI7cImVz/id3NBQvBlN3yycRF2CaKgdE3
	 jzUUumlJKvJTgZ26wN8VmZJQpNcHN0s+GFogw0A8EgyD8jpLj7HVigSX/dvA6SbO64g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=UTUVv5rm;
	arc=none smtp.remote-ip=209.85.128.54
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 683CB606A336
	for <kvmarm@lists.linux.dev>; Tue, 10 Nov 2026 10:41:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 683CB606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=UTUVv5rm
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4b76c15ae36so27515e9.1
        for <kvmarm@lists.linux.dev>; Tue, 10 Nov 2026 02:41:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794307296; x=1794912096; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=R9ybw6cxS0shDJ4UVVgiEKCnqeSU4VPhRG8DzGKzjow=;
        b=UTUVv5rmYt27Td+Kz1VAIJ3ADB8he8b/1Z2O5ynUmU4caxM+RiMT3OanRLpTLTtjrD
         tVTuFP1c6cnJZWUkOB7e7Dih3pK9zjDOLG4HIwB4Wj34rqxRPuV5JJPvv9/bl2FIkFRc
         E3P7XkrxHfH3nRF5nXGlW28N3FlG+BSpc3gg/KYx5YJUTYGTf5OujuCutuJ2zre1qg0V
         cG78PYnhtpKiYHWo2rlbrUuLtkAvW1peOBv2QVnq5vL+NAnqhS5GAtKOtjf+p/zeMKJ7
         A9uCda0GQrfXjQx/GFSGAgteTqOMvwVxOmKiixzQEB9rI1HVkQyw1JYhKk7nDuoodBV7
         YQQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794307296; x=1794912096;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=R9ybw6cxS0shDJ4UVVgiEKCnqeSU4VPhRG8DzGKzjow=;
        b=RZxBMnAMRSN6NLQFEReO55qZMzv4QEU89ULB9NwzxtsHAwIoztHoul9V2LUIKSraAT
         734VWFqIg2QGxH/Kdl3ZXcz7ka0Mj6vuYfzxyir6xrMafvIFMU1+RNYoKcnWz6mxJgQZ
         2Bpu7dY9uayGnsB/f0Q9KdKHGqtE1CE/73TPn8a7XdYYKvA3DnHTiP+RHigf6Sym1YX7
         xFFNrOtypITs8ISk4H70yqGolBhZhoG69GJcqrqksDN3NXix0KmUGzgYOvuGmywd1jFb
         wjvOk018l+1zFUDAwTw5sw1rkqL1a1ElbJeHZU7DNnGNHI4f0Qb3Z17cy5nyp8vQie7Z
         ceJg==
X-Forwarded-Encrypted: i=1; AL+hErHFSsq4nBr4q0aom4efQGzCDJCjMStUJa/uvyvoIu3kSUMkiLqnBhFoeZ2Q7fHdyozGyqtJiEQ=@lists.linux.dev
X-Gm-Message-State: APuU4Z/a9N6d3jZktOA4F5FN4SxYUX6whuN2mbZmo5cTQO4Q/BnwP1cJ
	nrId19r+fAsH1eNsqnlNOhsiJ7PlrNlJddtB1ZF3tIEMNQeJBt6OYgt/e7ntwboHmw==
X-Gm-Gg: AYBFou2OY49PkWw0D89yofein8o1lW/wPsbEasAhRvXjeJkSGdwuUcqpXw3lUHzpWpn
	OOBsexsyYc6qRwPdotpuMJDu1okVLfUZxQBIRPqaoSHabhPJinJqbAf6X1UZz/fI6cSHxk+tH45
	LjmJLEe6ZoudO0af9GWPv0Zw1gGwtjTeWBO5wlFTxIyXIYfVQABGXmGSbQIU0xLQRgznqC/8jdG
	EhLfxzGRR/1iUBgR+zEVgC1bXE6HSB3371O4QpJS33CGHzh6slXngyi9mcznnTGnuGCh22+w4Lu
	x0ICzhrLjBavWK3e6uHLe5aFSRkINtSSNRYJyGUN8dhlUlI7d9UPgKjKl31zgWKySIhqEwfxao0
	FRHT1+alSDE+rSZVNAa0JPUzcZQmRvbjFBq+BYq119GFKJGqU5kPk6v+XQ4E0+RR5oe2lid/kx3
	ybKMS1cV4YkoMC7nHxlNeGTlFqWr2OeoHwkBQ/ujg2CZnZTjmbgR1he2hMZx+xx0HFKPsbLPlYs
	H0IfNuwpgrO6uwSXpvGOTaP7LzF7MBWE/gmoTCy2H3GLQ+wp2aZwFqeSCBcQcjTh6wTT/nactDY
	7t4BDVreVeOCzXsXkqFBuN/BjJcTfxyB+qCoXPA0jwWC5jd9gFo9fuR0zO8O3nGcKSr+0es=
X-Received: by 2002:a05:600d:640f:20b0:4a1:e368:cbf7 with SMTP id 5b1f17b1804b1-4ba022dacbemr640635e9.0.1794307295364;
        Tue, 10 Nov 2026 02:41:35 -0800 (PST)
Received: from google.com (160.193.189.35.bc.googleusercontent.com. [35.189.193.160])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4ba01fe63e6sm87694655e9.7.2026.11.10.02.41.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 02:41:34 -0800 (PST)
Date: Tue, 10 Nov 2026 10:41:27 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, iommu@lists.linux.dev,
	catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, joro@8bytes.org, jgg@ziepe.ca,
	mark.rutland@arm.com, qperret@google.com, tabba@google.com,
	vdonnefort@google.com
Subject: Re: [PATCH v9 11/25] iommu/arm-smmu-v3-kvm: Add the kernel driver
Message-ID: <avL016l_xASN5paR@google.com>
References: <20261015200903.2735565-1-smostafa@google.com>
 <20261015200903.2735565-12-smostafa@google.com>
 <auzvygiGRTWgJXzF@nvidia.com>
 <avGk0ilyJh3obmKx@google.com>
 <avJidXM9yQOX4VBJ@nvidia.com>
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
In-Reply-To: <avJidXM9yQOX4VBJ@nvidia.com>

On Mon, Nov 09, 2026 at 04:16:53PM -0800, Nicolin Chen wrote:
> On Mon, Nov 09, 2026 at 10:47:46AM +0000, Mostafa Saleh wrote:
> > On Thu, Nov 05, 2026 at 01:06:18PM -0800, Nicolin Chen wrote:
> > > On Thu, Oct 15, 2026 at 08:08:42PM +0000, Mostafa Saleh wrote:
> > > > diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> > > > +#ifdef CONFIG_ARM_SMMU_V3_PKVM
> > > > +/*
> > > > + * Two devices are involved: the aux device bound to this driver, and the
> > > > + * physical platform device bound to the pKVM init driver, which only uses it
> > > > + * for discovery. This driver keeps using the platform device, as it carries
> > > > + * the fwnode the IOMMU core and consumers link to, the DMA configuration and
> > > > + * the IRQs.
> > > 
> > > It would be nicer to have a diagram or so to show the co-relationship
> > > among different devices and drivers.
> > > 
> > > I assume the regular arm-smmu-v3 driver is a part of the picture too,
> > > when the pkvm driver binding fails?
> > > 
> > 
> > I can add some ASCII diagram.
> > If pKVM driver fails, no aux devices are created and the main driver
> > probes the platform SMMUv3 devices as usual.
> 
> I didn't check closely, but would it be safe to do so?
> 
> Is pkvm aware of the missing SMMU device and handling it properly?
> 
> When pkvm is enabled and the SMMU device is supposed to be a pkvm
> device, should it not fall back to the main driver?

If pKVM fails to init for any reason (unsupported layout or non-coherent
HW) the SMMU will be bound to the main driver so the system remains
functional.

However, pKVM will not be safe in that case regarding DMA isolation
as the status quo.
In Android, in that case, pKVM clears the FW (called pvmfw) that loads
the protected VM and authenticate it so any protected VM knows the
system is not trusted. This part is not upstream yet. [1]

However, there is not much that pKVM can do and I think it is better to
keep the system functional in that case than causing a panic or failing
KVM init for example.

[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/virt/kvm/arm/pkvm.rst#n106
Thanks,
Mostafa

> 
> Nicolin
