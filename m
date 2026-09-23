Received: from mail-dl2-f26.google.com (mail-dl2-f26.google.com [74.125.229.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA77B4A0929
	for <kvmarm@lists.linux.dev>; Wed, 23 Sep 2026 13:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.229.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790168776; cv=none; b=VKs1a4BMjYBAWgCDBsq7T9kMEx51KYetFVBg157tPVifZ2/k1DegO1p1A+hK8MfLwTC/UgYvx0I9UR29O+7ef59/YIwxbZE6OtETTeTSv4UAFI2V4ZCbek5DKEz4BgOuK278sr+BwF/6YyeYvMotBdcGQ5z3LgRHuYBemiR9UX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790168776; c=relaxed/simple;
	bh=ih23spaVgrDHOFSey9aqnpQ7LFap1dWio/xJjG+h0zE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L8ZowKXtLOuMFFERxvY7dG6IeItPutozM0WvQcf7RCdnvkSq96kF3mh7Gk8e1d4sfqfK6p9f6QEwPgiXcu+kwZ36dIAUsR6zVb2PyaSxxIeBjIO2IQ3SVYthhbxe+V9eKVhPuk4y9rXESpGYSSyoB93YpDpCSuv+nzeFYHsFWco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=eCTbKQBv; arc=none smtp.client-ip=74.125.229.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="eCTbKQBv"
Received: by mail-dl2-f26.google.com with SMTP id a92af1059eb24-144f47a9b57so943677c88.2
        for <kvmarm@lists.linux.dev>; Wed, 23 Sep 2026 06:06:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1790168774; x=1790773574; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ih23spaVgrDHOFSey9aqnpQ7LFap1dWio/xJjG+h0zE=;
        b=eCTbKQBvSxJTopQ7hizAXUgVCSMoLgzGCIJznBHhD+Pk9lhzW/XqpaLX0bpveLpW0R
         dzwOYriXIBzERszea2HrTy/4EeDDapgBnTFWIQ2YOsCaW3vo2dNUyQTzTQ02wZC2kIDY
         WsI2f1GZ5vF9oSTJcjKvc2o1vY+JOBCqUcsvPZnr/hFWzA6vbbzsE/1SIinmlcQ4yRSN
         xpy0iZ0Qk5UFIQsj8H3hWBpHBKp+fMu9FEO67WldVjLTeY4xCMk2NNEUYwDjkBzRcu1T
         ll0xuOGg1tfwvr6tT9PPSkaNq7E825yvN1F+kKE77AMpsvSXxb3asoUI6FQRCzCrLFny
         HmHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790168774; x=1790773574;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ih23spaVgrDHOFSey9aqnpQ7LFap1dWio/xJjG+h0zE=;
        b=Lbcgw293+efE0SdLAPrDRTbsGgtVds+dD5QI4pkA3Ad0+jbZiR3BuBTL8c9ot8gwT+
         Hw1NLQPcuaruq8zG79oaxnDa94m3s8D5DzpYJp9WhRjY1iG0renL7g8hpRZLGquffm+U
         ToBkopyJvAV1rocSNO8IEV3SE953U9W6mFv6RohXdK+qzm70exxlSeg5LUV6BvNtdeRX
         lIGIaF5wuja/oNCWan3itR3oIsHWZ1hLsjzFD5aAR9wjoYmrbRMWcOeFwGoxOYys9IjN
         bY28pDybJkD92tPKcedRZmyipOVwQBmtBhDssTs4lbpnvk5NvH1mUcf6voDnxv+8ClXI
         3d5Q==
X-Forwarded-Encrypted: i=1; AKwUvBwnDAW9OD+528e4b1lGMLWp9uDp+sxfcw/D8BxrkHHrEP+754PEIOYBi4JRLANUAPdxkefNT44=@lists.linux.dev
X-Gm-Message-State: AFuF++lu56zZkRl8zMgbQIksKGHirEzE3VDnHfEh9GGxELxBHh/3dMOk
	le2CfONVSZDd9ozzCtDhHHkSdIhrgQnwW6Lvbj5vU7QYV7ctEKXw0JmEo+S6UHgecgE=
X-Gm-Gg: AYBFou14TjHdeCTY1mW15i+SXpW0eK7T9QZfAu1L0mPukyrUk3Xu8A/o3G9qKXLGwLv
	AIhCSEZMPJ5Y55oZCw1cCI8xfMhIE79Hs6YTQXygsYMfNOMXpif3SyJLxVOg9OtgkiIDMLNcxGS
	jm8wgd29I4+6FVRxTE3mRsmLn1z3BKbQR+QXX8LQbJHz+8F5JdMwc6UvLAL96fN8+yvezcUkz2r
	LqXjQtkELfZ3T5SpDcCUs0C34Us7LguRhJiUT/uIavhQ8T7Pa4KUX1zxcVq7CRKjUbpdRDMzoYx
	+h6OpIxIhiy/XihoVUjgzuiD9OL/L+GswReXaPk6Bb2gZPKmeEj+bu/Fn9EjnwlnGq5Hwb1KJcf
	+qogt+jsK8NoMUQsNal9J37IKoLnV0J7Bnnusv4A/WYm3Ec9mar9VQTwJtYBKlmER92VtKxgrDm
	qOyZuN31yaGx+yP1R8bJPn+RyvP355z5RyDUypItvkEj7D
X-Received: by 2002:a05:7022:1402:b0:143:2719:566c with SMTP id a92af1059eb24-144f9198b49mr2872815c88.40.1790168773123;
        Wed, 23 Sep 2026 06:06:13 -0700 (PDT)
Received: from ziepe.ca ([130.41.10.202])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-144f98a288esm10833873c88.13.2026.09.23.06.06.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 06:06:12 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1x9Mfr-0000000DZ6d-2NEP;
	Wed, 23 Sep 2026 10:06:11 -0300
Date: Wed, 23 Sep 2026 10:06:11 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	linux-coco@lists.linux.dev, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	iommu@lists.linux.dev, Andrew Morton <akpm@linux-foundation.org>,
	christian.koenig@amd.com, Joerg Roedel <joro@8bytes.org>,
	Marc Zyngier <maz@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Steven Price <steven.price@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Thomas Gleixner <tglx@kernel.org>, Will Deacon <will@kernel.org>,
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
	linux-media@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH v7 02/13] mm: Add an allocator for CoCo shared memory
Message-ID: <20260923130611.GF1540250@ziepe.ca>
References: <20260921144847.501151-1-aneesh.kumar@kernel.org>
 <20260921144847.501151-3-aneesh.kumar@kernel.org>
 <arKsFofudnTYpXj1@arm.com>
 <yq5aik3w344o.fsf@kernel.org>
 <arOfD6syXOgQhZYA@arm.com>
 <yq5a5wzw2ree.fsf@kernel.org>
 <arOspFxWZ1DjgcAr@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arOspFxWZ1DjgcAr@arm.com>

On Wed, Sep 23, 2026 at 11:40:36AM +0100, Catalin Marinas wrote:

> The simplest is probably to always zero in the backend and ignore
> __GFP_ZERO to the allocator. But it's probably only marginally smaller
> than passing a CC_SHARED_ZERO flag down. Get codex to try this as well
> and compare the diffstat.

For patch ordering I would convert to use the allocator first

The semantics of the new API should be clear

If you pass GFP_ZERO then the resulting allocated memory is zero

Otherwise the allocator does Whatever The Arch Needs to not leak
private data out.

Once places are converted to the allocator lets go see what is left
and ask why it is left and what API it actually needs.

I think HCH was right that nobody should be calling this in driver
code, lets aim to unexport set_memory_decrypted as an ideal goal

Jason
