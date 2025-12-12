Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A68FD21D3E4
	for <kvmarm@lists.linux.dev>; Fri, 12 Dec 2025 16:07:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765555639; cv=none; b=LM/FPrPrWZJ8fqA4wzTG1h87+ujntH1mpjkGSEQ5Ut+12DAC+RR/qsjOtxmjazCxk/1veN4eqJbfzWaxUrrgW5NviPW9HepS3Bsa8Mk3fTGN3bQRjFwMLL4h2vMQXvAtGgpALfXI1L+t3/A9mNSvY5BulbdUzVakhcTstnFvWlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765555639; c=relaxed/simple;
	bh=CadN1clJTjA4RMo1uLhmMUV7CPVXKBuCrjugsR4QrFI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q3mKjKK4D8WOCoxQKeN5ponKLZM048VylW4WjjY7AnR+LhNpZVaq36jjin34nYLrDgsmQC1Bk9Jhxj9LDSsgof9qX7YVllgScDt8CsQSnYToBGM+aiDXBF0M0vIcAj68uiOJrOqbdcmENCph+6PGPXByfBYG5TpZtu0Dg9N5rZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aIOKpbzC; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aIOKpbzC"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4779e2ac121so168545e9.1
        for <kvmarm@lists.linux.dev>; Fri, 12 Dec 2025 08:07:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765555636; x=1766160436; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=j/MUKGMtq/AZXEzw4+AUVbVepsRjCX4PBUc6yHK/8Wg=;
        b=aIOKpbzCNl5YCsxyp0nEUuGxg1fJ4dkxmPqFtWySShgJUK9UD0MalHRKfwSsAd0zlk
         ou8WbFsrcphW55kxSJNDvMCGLzqQolkleBID8hhQsUVZC8F8hgOQWLTgtfZkFOtHxYDs
         0e5DTmkpNwIFzTqTE6S87ZHu5BmnGC12+Uh82sPBfdpKxXMAj68v4+nIdRNRa2/zFG7j
         BbRlKuOw1RU0XeXZMiEUzmSraSt4TAFUDuujmuoFO87Zq6GCAM5fjU1BHYBG50h1J8xv
         +Zy6vuwS/19fkr1n4+OhJ2hEvgL1kIoeYnj2QFV0twbbM/yOOCpmM14jfAK6NY6hGKkd
         qjsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765555636; x=1766160436;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=j/MUKGMtq/AZXEzw4+AUVbVepsRjCX4PBUc6yHK/8Wg=;
        b=PpUQAFgSKrcjrw51Agb7wt1b6vHy15tYHTJtOSlFNpA4eRyZIgTzJAix9dW9bRy53B
         aK7LcCOzF7rdglB0z8sOeaVx3cIuwjaGDlPg9a+BuiL2IUk2YP/zXX072HFzjWDL/TUQ
         4JlWlAoFjKaIubICMtFojfei9xLjS1gFEGK4W/BuVu5Cfe9+e6Rsi6WZQIepuwfmumHn
         O6nVOXhGLOOIU8+sJAGouog0Dcf2aahpLHJf1qP25lfR8AXN1s9uwuSMP8lhJc9/c6Ad
         lDFexT4QyUNbZUBnkDdkZAdUAYFprNQhyjRA/7f6czglWDmahxiIfWj/j4G0U6NkNHST
         cfIw==
X-Forwarded-Encrypted: i=1; AJvYcCXit280NGAjm6R5DBkX2/9LsqF5jjsdI32oSJi01XUBknkDSpNMScoATiktKHYf79rrS2SeAv4=@lists.linux.dev
X-Gm-Message-State: AOJu0YzctEWpucSP62k+8KkrQYwJt7DZEbzXhcs50cKMi5T1oO9JF32Y
	976humZkPbc6vuOT5ivITJ3PB/s/eBTATPMMnI6S57RbNvN/7dRdopLcS0w7Pw5zOg==
X-Gm-Gg: AY/fxX4TBXctDCnCw/qtMLyGWpYxnkxc98rz0c/hMcJF+tGKdIQF0sJ9AA3FN4T3TL6
	GEdTY4A1/wYD8OcbSANnW0Y9VkvgiQhxkRRKh9Noe9t4tlzF3Bt0yvr3E9WHVE8taU65ul7waps
	fHdCf/yZxzFMspgPy7iVHU5q6BSDz5IlqEv+9ISFsRvg94tMAtJ5Ffadoxv5OvkmWJYMrbciro9
	GhDJtDjTb0QDq5elMHVNm3ppM+p81J3u6ueObqm9+zi/8j6I6vvRdVRALBGLHvqjUF4242hn6Qp
	z3UT5dfI9Kv6l537u/bHgQZq2Mi5h6hVdmYDRy7GxzZFg39gN4RElVabsDzig4v02+3z7zH6YG6
	yJt6Pm0/ofh7sILtHNYnTzuvNpVy7xodx3YXQ8MPO5DCIFlUItvs+icvt64GGdVnoLE9wIHj66o
	yhsrRC4X4mOLqsteYbTB6JM4GOoZx3oHRBcfP5E1s2O4Il6BcyUA==
X-Google-Smtp-Source: AGHT+IEIDx819rvyhX5iStRqL6toam/KgB5ggWiYCL8nDHKAqrNj8ytrnyVKvwTwKQ6ON9JUhN4seg==
X-Received: by 2002:a05:600c:4a19:b0:477:b358:c0cc with SMTP id 5b1f17b1804b1-47a8981f631mr1202285e9.17.1765555635793;
        Fri, 12 Dec 2025 08:07:15 -0800 (PST)
Received: from google.com (54.140.140.34.bc.googleusercontent.com. [34.140.140.54])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42fb68866f3sm3708879f8f.36.2025.12.12.08.07.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Dec 2025 08:07:15 -0800 (PST)
Date: Fri, 12 Dec 2025 16:07:11 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, iommu@lists.linux.dev,
	catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, joro@8bytes.org, jean-philippe@linaro.org,
	praan@google.com, danielmentz@google.com, mark.rutland@arm.com,
	qperret@google.com, tabba@google.com
Subject: Re: [PATCH v5 17/27] iommu/arm-smmu-v3-kvm: Probe SMMU HW
Message-ID: <aTw9r9syCwJH7hgz@google.com>
References: <20251117184815.1027271-1-smostafa@google.com>
 <20251117184815.1027271-18-smostafa@google.com>
 <20251128170748.GE812105@ziepe.ca>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251128170748.GE812105@ziepe.ca>

On Fri, Nov 28, 2025 at 01:07:48PM -0400, Jason Gunthorpe wrote:
> On Mon, Nov 17, 2025 at 06:48:04PM +0000, Mostafa Saleh wrote:
> 
> > +/*
> > + * Mini-probe and validation for the hypervisor.
> > + */
> > +static int smmu_probe(struct hyp_arm_smmu_v3_device *smmu)
> > +{
> > +	u32 reg;
> > +
> > +	/* IDR0 */
> > +	reg = readl_relaxed(smmu->base + ARM_SMMU_IDR0);
> > +	smmu->features = smmu_idr0_features(reg);
> > +
> > +	/*
> > +	 * Some MMU600 and MMU700 have errata that prevent them from using nesting,
> > +	 * not sure how can we identify those, so it's recommended not to enable this
> > +	 * drivers on such systems.
> > +	 * And preventing any of those will be too restrictive
> > +	 */
> 
> This driver is doing nesting though ??
> 
> Shouldn't you detect those IPs and not support a S1 at all so there is
> no nesting? Identity only?

I can see that the errarta are fixed in r1p1, and from the MMU-700 TRM,
we can extract this information from IIDR[1], I guess we can allow
nesting for all SMMUs except the one affected. Actually we can do that
at the moment from the main driver too, I can prepare a patch for that.

However nesting is still mandatroy, the fallback path for the KVM driver
if nesting is not supported (just S2 for example) is to fail and let the
upstream driver probe the platform devices with KVM out of the picture.

The main reason for this is that the KVM driver relies on CFGI to know
which SIDs to configure, for s2 only cases there won’t be trap and emulate
as the hypervisor would be take control of all the SMMUs (as v3 of this
series which requires HVCs)

It might be useful to support only S2 SMMUs, but I’d like to keep this
series simple and then we can build on top of it.

[1] https://developer.arm.com/documentation/101542/0001/Functional-description/Constraints-and-limitations-of-use/SMMUv3-implementation

Thanks,
Mostafa

> 
> Jason
