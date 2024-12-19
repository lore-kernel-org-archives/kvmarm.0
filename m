Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 960212236EE
	for <kvmarm@lists.linux.dev>; Thu, 19 Dec 2024 11:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734607308; cv=none; b=QfcFEewsIgPdJjfZ0eC4BT4NMdi6E2MKCR+ZpkeLPkIs8027DI4pPL1CWraArYjsWMYzlAyNJvXeLOAldVjJpZXB8ELsHOKN/35bQXDCu71I9ndmSYqR8eOZs84Uj3hIZa3L6MwmwXq9DKO3mk25AxNzNbSC1wMP5k5InvU/lvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734607308; c=relaxed/simple;
	bh=l82VQ6MNWoJAziJkHRiYqGJu8wD4XsbM7Tq5GCvOgOs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PS0YhzKpoD4lCi60zO3Lo+0JlosehjxFKnDOAf7+URYNMkkiVoaX5GvCDpQQuKDoV0++R1jjaM4Unf18GSjufP9flmnJxG8gCS2NR/AGs+wO0GEXCUfsFFr/sQvFSYNAAVRwSgVBm4KEFiFbSz6wvAjfmERkRMMypk9+JKmpsKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Rq9icYwf; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Rq9icYwf"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-43622893c3cso35285e9.1
        for <kvmarm@lists.linux.dev>; Thu, 19 Dec 2024 03:21:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734607305; x=1735212105; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=WGkN0eIRMsbxDqZZzBkMr+wzaFkYCBiUXPyTbRF2MxQ=;
        b=Rq9icYwfK0T6ENK6Z+1fpj6H9eZst3oEGT/HYp87GGZqRsAmiGQPlvtsikVWT5zayW
         lqAvshkS4sMhxXC98caGs3dGz+6luj4+amQVsOQYMygUhSmhxh8i4+IVt6mvhObdzgUi
         PhIXFZAuz3HV95Xn7ABwZQ2Qdx0GFKlYUhlX/wW9iUzlFom8BAgrSPH7mYY+bvrSHTSi
         cbKiX0Q5TIGdeS6KCvLX7OtDMgDEE4Gw0/7el6Oa3YJ6g/WotJdSWNspTybtbBmICj8I
         SmsPy/x17zTLF6d5a6WRowKWHk0Hb9VdelhwV1O1F3r2+cH1ktyQ/ResLcZ7T/7++VpC
         e2ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734607305; x=1735212105;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WGkN0eIRMsbxDqZZzBkMr+wzaFkYCBiUXPyTbRF2MxQ=;
        b=dYd08mu5Ww3jZjKNlsY0bRrZTZV8LvQBN9f5Zn0CfWvhhSLHauNaHUMDlw0caXaxgu
         DrylzY4XW5YsXJtleBg5iHmd73mbQMkSH9V29BbU3YNiwmrlXXwxBo4/CPQpzV5q0mV4
         bJH93ksK5uyNX93J1A1EUfCB8H2Bj7RTljD+oj0J9OuXXJdmBTjP69kpP+YbBNCLQqeY
         GZeQz22gL9Mg43XpV8ARHjU5x9Opste0xR3deXQCEZe3iiw8dwmNeFWiQuErbuSDXCHU
         V4S5NYTZbmwWbKt++3ZAIud5uj7AzhclOazHZOucWrvmAqu+hBAVqyZmqei89UVvKsSk
         wREg==
X-Forwarded-Encrypted: i=1; AJvYcCXBF62epQfwm5hIeplpV0ov35c5PmvSG+vEgDnPFLcUq2q6OD2G+RJozklIbf20rZagmCTtJtA=@lists.linux.dev
X-Gm-Message-State: AOJu0YxqgiGQBqeE0P3pHpa6yp8kJRcXLuuVOWdQqbiNLrruRCLZAZcK
	bqHuXN78UGdEQULA791flV7iwbJXahv9fqWHoqxrQwCHLTpp4GwjiNEn0ZqrIA==
X-Gm-Gg: ASbGncsS6Oj52d44IkBl+iWSgZpk1uvisu26lNl53i25NXTByfb6/k1xqJ4/JAYF06X
	nQvhRfj4+wrvatG2tihb7Y9Ul4aOy4hitElFbNDp/JSu5vsOz1CzUDDQGN6xHZyIbERlTW8+Bex
	EHSrD2/MHhkcR5//2LmEr/2kz5va+bcsmhl2tiAPQhoFeeWJLOo/X+h/G/zlDJw5Qf/4aMfncdR
	uVFZKvwwopTiT85GdjX/B0pzEmU/2fPodUSCY95HsR2oxEUqH0qVTbd0ZokFhHN04G6u8jtJtmH
	DKxNJ4TVucBDD0xvfik=
X-Google-Smtp-Source: AGHT+IH3i8v/BrwemmECFyya82qa5WpmpoQwTNEogOS40Upy0/Fstoyzd3BnWRDUcSAESI7APhWcyQ==
X-Received: by 2002:a05:600c:4a01:b0:436:4e4c:7bae with SMTP id 5b1f17b1804b1-4365fca3ba4mr846885e9.1.1734607304693;
        Thu, 19 Dec 2024 03:21:44 -0800 (PST)
Received: from google.com (216.131.76.34.bc.googleusercontent.com. [34.76.131.216])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38a1c8bb4bcsm1308850f8f.111.2024.12.19.03.21.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Dec 2024 03:21:44 -0800 (PST)
Date: Thu, 19 Dec 2024 11:21:40 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Quentin Perret <qperret@google.com>
Cc: iommu@lists.linux.dev, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, robdclark@gmail.com, joro@8bytes.org,
	robin.murphy@arm.com, jean-philippe@linaro.org, jgg@ziepe.ca,
	nicolinc@nvidia.com, vdonnefort@google.com, tabba@google.com,
	danielmentz@google.com, tzukui@google.com
Subject: Re: [RFC PATCH v2 11/58] KVM: arm64: pkvm: Add pkvm_udelay()
Message-ID: <Z2QBxPyBsxGNSuzT@google.com>
References: <20241212180423.1578358-1-smostafa@google.com>
 <20241212180423.1578358-12-smostafa@google.com>
 <Z2QADxbdoYi5q9iT@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z2QADxbdoYi5q9iT@google.com>

On Thu, Dec 19, 2024 at 11:14:23AM +0000, Quentin Perret wrote:
> On Thursday 12 Dec 2024 at 18:03:35 (+0000), Mostafa Saleh wrote:
> > From: Jean-Philippe Brucker <jean-philippe@linaro.org>
> > 
> > Add a simple delay loop for drivers.
> > 
> > This could use more work. It should be possible to insert a wfe and save
> > power, but I haven't studied whether it is safe to do so with the host
> > in control of the event stream. The SMMU driver will use wfe anyway for
> > frequent waits (provided the implementation can send command queue
> > events).
> 
> Mooh, I'm thoroughly hating that we need this -- pKVM is non preemptible
> so we better not wait for too long.
> 
> I can surely figure it out from the following patches, but could you
> please expand on the use-case?

The driver needs to poll some SMMU MMIO, so it needs to measure time
in terms of udelay to timeout, at the moment its arbitrary set to 100ms.

Thanks,
Mostafa
> 
> On a side note I'm not too worried about the power impact of not having
> a wfe in there, again we better not be spinning for long enough that
> power starts to be noticeable.
