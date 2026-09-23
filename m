Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDF284D17A1
	for <kvmarm@lists.linux.dev>; Wed, 23 Sep 2026 12:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790166083; cv=none; b=KTX/EIfNjg90o591y7EBS4pXJAvX9A/GCfUd+cc0T0tczqM7Gy5DN5HB0C9dL5ocVuqSYPEUIhdp9/3NDOTERdPccNRHh81kFdptaVAXoOhBniPE/z+zK9BmzAnkbBjgfgGbGz9UlDPRMvlTEIyl2GH0G53KNvSyvoKSQFJfurw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790166083; c=relaxed/simple;
	bh=bQcH3jTKNmXdXEb+sr4yWEqfbt2vZeJTXfNoUGfU04M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tOm//WAaTwrXlCHnZ5PP616dsTjPmIr7PKvICkcGd1GRoCLSVuotA0QJxrZiUCD6Z6fv/u9ZaGAZ7Zp9mTMao62+CtkdOjayC++MwNZehs57r9KonJihhXKhgRnD6WivwfsuiSCiXy8ItLAZ31ZmAehJUZ6rWfPcQEKyaRWvvhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RRLFY0xa; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RRLFY0xa"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-49e6425f96eso41845e9.1
        for <kvmarm@lists.linux.dev>; Wed, 23 Sep 2026 05:21:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790166079; x=1790770879; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=6u3N2T6sQi1Z1c8x0CoJeove0ost1XCLW14esiat9kw=;
        b=RRLFY0xa+Nz+QexxEVXO1kGxW5u7MPJ49RJZrMdxNxGhvA5mL1PeB7EarMbp+mcziS
         Is5u8uNcXXsk656od/HMhnoDIMsrmctq570Yt/GGPRFR8VsCu14Ell3yX52pg7SVLlcG
         Qc2S7SS9UTJJ6KJqaNdetAhxxO5Wzt8jwbgbPIADRqdk3OKEkdbwoKT6oAU4QFy4XK9l
         +dohjX29qTbbpG6SAH8yeC4zvN5egm12TkFjPbcSFGgWKn0hS4cuzWgMFuGlRL/tMgmG
         smGvpT1sf69RUD7T05vbOtYqSvaajGZLgiyHrnco16Ln6rKpQkmBocFmY9FCL2+z+a9A
         W6bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790166079; x=1790770879;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6u3N2T6sQi1Z1c8x0CoJeove0ost1XCLW14esiat9kw=;
        b=iSvGP0oBa+vMRvXH3f1ssewjgKC2nSjhIH5eBZbRBnmXj7UOTlOl0v9mQ5o3uJqDkz
         mDvB0qU+nZ6dkOIeWcJ1QWo0Fwm6OpGjoEDfGqXhJOJ1NCGX/0ClIpy/HW++0qeCCvov
         wpi+EQR3vbsPUmo0GTB96mkKwhBWBL/JJDomjIKT+e9WNfTvnYUdREDfM0mmDo1MUdwm
         V+iWMWSaD5U55Q3wu3gOgFB5IXjh32tUkHTkgsPoratlT6HxitFDgiq5Jv5CG+c3iIyp
         9bFVqbeHU7Bl5Z38YfVyEJOdequ3Ze9BFS+UGCB5KwFKQZdjkDkCdubngt7Fv0kN+CUy
         QSrQ==
X-Forwarded-Encrypted: i=1; AKwUvBwWwJep6KerGs7t9fiig64XXiIK53RsmdMswW2LY1iuJNkoyGPthCY96z3rt/16e9n85IBBAD0=@lists.linux.dev
X-Gm-Message-State: AFuF++lAZ+0LOJy9BE7EJWwquzRPU9mFz7rXsDh/LrkoGfZ2aqVm9ZWz
	5n+AEgE9kGqfBBwiGga+6EHbJdWq0TaU6+wapwBHRTDZGu80zcbJa0v4IzRe8o4TWw==
X-Gm-Gg: AYBFou0Z87rt4hzaFNxDuvhSS6rzqQ005HimzqvCOrF4rkloboAes22K+dC/LyM9dMj
	3tlEoOQ+Kdzj1HGg7tbxhsVdwAXDb3KqkdDI4h8jlb8zFNPO7Ce5JPP7B0KzheHqipmd0nCapdt
	xRGVRLssqmfbmkf835HHVhOc7ste29gWZI2hRGauX+4o0TKJ0DLESlu3iv3p3JhiN3shdtG6aPo
	az0AXT9EWJCcoy2c5nP0iN/qguHr4qCyW4XeXMccFhzdvXJIYmuwGhTAJMG+xnS2aByv9X3MVp/
	dfunm5mLvsZKFm0CKxEE8SjDj/B5EtvFRcmosiblIkTmY9vUXyYn+bniHMZm3u9D9Emy0IcuMDx
	mdoCzPS3V/1nmlutaIg8F8r6HiPFfji2UzZRObYCI9IXR5yDOZXE6oRaoO4+3mUOE8bQbX2OKjJ
	nhGeqLzkMuGlbTsanJwvUUhI7/oWETI4G6Mmieup4dN7ttuhot6ozicM0IFkMAU07w4XB7rvbur
	KW85NAyLXbvZBi8aE6YDFT2dXzgbNrTc3cFrnJa
X-Received: by 2002:a05:600c:a415:b0:49e:65b0:7b7c with SMTP id 5b1f17b1804b1-49fe0c3692cmr754895e9.7.1790166078185;
        Wed, 23 Sep 2026 05:21:18 -0700 (PDT)
Received: from google.com (250.192.189.35.bc.googleusercontent.com. [35.189.192.250])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fde1c159esm82068375e9.4.2026.09.23.05.21.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 05:21:16 -0700 (PDT)
Date: Wed, 23 Sep 2026 12:21:13 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Nicolin Chen <nicolinc@nvidia.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, iommu@lists.linux.dev,
	catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, joro@8bytes.org, mark.rutland@arm.com,
	qperret@google.com, tabba@google.com, vdonnefort@google.com,
	sebastianene@google.com, keirf@google.com
Subject: Re: [PATCH v8 04/25] iommu/arm-smmu-v3: Move IDR parsing to common
 functions
Message-ID: <arPEOTzER6gberB5@google.com>
References: <20260922131259.2975334-1-smostafa@google.com>
 <20260922131259.2975334-5-smostafa@google.com>
 <arLa0E3xq5dGuPpd@nvidia.com>
 <20260922214818.GA2545495@nvidia.com>
 <arOmSxqRxhd717Xy@google.com>
 <20260923115501.GD2545495@nvidia.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260923115501.GD2545495@nvidia.com>

On Wed, Sep 23, 2026 at 08:55:01AM -0300, Jason Gunthorpe wrote:
> On Wed, Sep 23, 2026 at 10:13:31AM +0000, Mostafa Saleh wrote:
> > > If kvm doesn't want to dev_err log that's fine, we should able to
> > > #define that away too shouldn't we? And maybe it does want to log?
> > 
> > The hypervisor can not print to the kernel console, so dev_err()
> > will not compile, I'd rather keep that outside and let the caller
> > decide what is a probe failure and print it's own message that keeping
> > the code and stubbing dev_err().
> 
> I'd rather stub the dev_err than split it like this. Every driver
> should still do these checks, it doesn't entirely make sense to omit
> them from the pkvm flow.. No print, fine (and really, pkvm has no
> tracing, printing or anything?)

Tracing is supported, trace_printk() might be coming soon to upstream,
but console printing is not supported at the moment.

> 
> As a stube I'd do something like arm_smmu_err(smmu, "blah"); pkvm can
> do whatever with that.

That's ok by me, we can define those next to the struct typedefs for
each one.

Thanks,
Mostafa

> 
> Jason
