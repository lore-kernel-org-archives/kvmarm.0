Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4855223C6A
	for <kvmarm@lists.linux.dev>; Thu, 19 Dec 2024 11:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734607736; cv=none; b=LO2O/QW8i3iOthBwctw4VqfRVWtYZ/AP9fywsSjRK5I56n3Zk+r01+t/0ofqP9CLYPNZAWLv2ax0Xxs7Q201QUZpRg062zTRnpIknVVEEJToQ1ACGYuDvqCl1ZYBqRZslwfSWdQS0t9X0IlRBgVz9gnH4C95hz0P6suCVFYEp7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734607736; c=relaxed/simple;
	bh=wYKv/Dx2yzx4NRTRmlHoRaJNN2B+pKE2rkXs/FSqNo4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YDZfFRHImeGTs5BL4So5fFbrxZews/M70uh23LEWd+9ofLVROV0lFRY2fB3AYOw5Asn5fV1O49/EsC1yJvHtxBURCzo5+hcFYOO35KAS+Iz80TSW0MQttcgpQPH5I/Ro23awkt2uqJvK8zu7JVCBngMbQMRTFzRGNx3yOBuKBY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=op5R8iBf; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="op5R8iBf"
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-5d3f57582a2so3203757a12.1
        for <kvmarm@lists.linux.dev>; Thu, 19 Dec 2024 03:28:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734607731; x=1735212531; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+efOnqODR5XSbllpBxRT6OF6WIdT5YO+sNBFdgpMN8Y=;
        b=op5R8iBfS7BCVAexGHKqtgC+D3noXl8r3fDfDZ91Zi9VtVi/l0VaNZc0+q22sPhCry
         zWpAf5nVQKqaDH3QrGzuDiTYWQFPeSA3MKTJigM/SymqBKQ1tWubmmF8WXcb2Y0Xa471
         drT6ZUulcakFrubTmheK6QdAHy69eZDdojEV92tary84RARLUAs16O7CdFTaUkXfp0rb
         ao2nw+7M7wT3NhPz9b2OWa5p8LleXbXrOKEUnXy70zLG+GqBn5heCxOy0suVTyq5qQc5
         pA9t8tmxOZV1DtQvLIP+mJAWscsFUuDLd4BKzG8VJKSlCJkUOJYKY0cu6RQsbIsm4Q5N
         w9XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734607731; x=1735212531;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+efOnqODR5XSbllpBxRT6OF6WIdT5YO+sNBFdgpMN8Y=;
        b=H7tfjZRQ6JOUDyOYxHrW7Bly3pSw0Pb9HveQibU8y9UYgxwxFbgX4q+aGi9zte3aB7
         TztKK8T2PYD/Zt89T0QiD7J/rmEBRkUeJ1quHFChBo4KJrlQ9gwBHqh+rZkZt7LosbWG
         kquNXhfw7pm59rZneDB8NQOchooPzyNfSFeYQ+0qfBMwgdsPPVdTHlkc/1di4e0rHWiI
         xPOmKbDU8Xav9O7SdH09fQNZaJa/17BKJk6wmzeXEb+vCm8UGwe78zxBasULlPetV6Hv
         46e8FLUr8WZRPujo3O3ZheCNmaxC7zPfMY3xNdNcLd2WTIOcFvYGQq0Hm7WJTEIETCll
         f1RA==
X-Forwarded-Encrypted: i=1; AJvYcCW6vpRfCxmcZXU3peEwgGQdxvviKbbVm5dX3QJbNBR/DfwttT/sNedx8XMG+w0RZ4FSZrjG+Vg=@lists.linux.dev
X-Gm-Message-State: AOJu0YwFK/kHSohl1WKqQIxGw6f5jLU6wNd/l8zUAxoqESYDloWApt/F
	xWQlRA7kcnqhUN0C5wTbnS9z+dT4RDu5JzTJVgAtpayk02JYPlySwIHQT1ruXg==
X-Gm-Gg: ASbGncsXn3Ejx/PwIT4FhQx5NjqfY9pr9mXMldmYWAbRNWUHiaK9qOtx1NDzhidhMEn
	1XoQOSwrVlfhWCRi+m97NXTQ3506C3WBK9M88q1cgnNtKyd/sLzJ9YEJyAXKw/yZB30ohHqLKKd
	wKJmqUesftGaj25RTKwqPcxP1zfRMohk+SRbswIVT0QN9UYwFOlCv0o3vvVOZ3zR9V0TxrvLpX7
	WyEi0INPKmsXtVINMgdNkKUvs2MyP+MyHT88snwrkF4QdcM62OzDVuMTe2U4WM1q0fxfLTtniyd
	Pd/0bVdDRjvO9K8=
X-Google-Smtp-Source: AGHT+IG3dsXDyN2H9c+ztZK9RDs7OlGyiKmp55kArM+zF0vJy/3UJNS0k2iPLxglWUvLs+MgvKzUiA==
X-Received: by 2002:a17:906:308c:b0:aa6:abe7:ff49 with SMTP id a640c23a62f3a-aac08187acdmr234318566b.16.1734607731259;
        Thu, 19 Dec 2024 03:28:51 -0800 (PST)
Received: from google.com (61.134.90.34.bc.googleusercontent.com. [34.90.134.61])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aac0e82f58asm55970766b.39.2024.12.19.03.28.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Dec 2024 03:28:50 -0800 (PST)
Date: Thu, 19 Dec 2024 11:28:48 +0000
From: Quentin Perret <qperret@google.com>
To: Mostafa Saleh <smostafa@google.com>
Cc: iommu@lists.linux.dev, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, robdclark@gmail.com, joro@8bytes.org,
	robin.murphy@arm.com, jean-philippe@linaro.org, jgg@ziepe.ca,
	nicolinc@nvidia.com, vdonnefort@google.com, tabba@google.com,
	danielmentz@google.com, tzukui@google.com
Subject: Re: [RFC PATCH v2 11/58] KVM: arm64: pkvm: Add pkvm_udelay()
Message-ID: <Z2QDcODuqcJojTpG@google.com>
References: <20241212180423.1578358-1-smostafa@google.com>
 <20241212180423.1578358-12-smostafa@google.com>
 <Z2QADxbdoYi5q9iT@google.com>
 <Z2QBxPyBsxGNSuzT@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z2QBxPyBsxGNSuzT@google.com>

On Thursday 19 Dec 2024 at 11:21:40 (+0000), Mostafa Saleh wrote:
> On Thu, Dec 19, 2024 at 11:14:23AM +0000, Quentin Perret wrote:
> > On Thursday 12 Dec 2024 at 18:03:35 (+0000), Mostafa Saleh wrote:
> > > From: Jean-Philippe Brucker <jean-philippe@linaro.org>
> > > 
> > > Add a simple delay loop for drivers.
> > > 
> > > This could use more work. It should be possible to insert a wfe and save
> > > power, but I haven't studied whether it is safe to do so with the host
> > > in control of the event stream. The SMMU driver will use wfe anyway for
> > > frequent waits (provided the implementation can send command queue
> > > events).
> > 
> > Mooh, I'm thoroughly hating that we need this -- pKVM is non preemptible
> > so we better not wait for too long.
> > 
> > I can surely figure it out from the following patches, but could you
> > please expand on the use-case?
> 
> The driver needs to poll some SMMU MMIO, so it needs to measure time
> in terms of udelay to timeout, at the moment its arbitrary set to 100ms.

OK, I'll look at the patches to see how hard it'd be to return to the
host for scheduling while this is happening. It's probably hard because
we're presumably in a funky state, but it's worth trying to figure it
out. Any EL2 section longer than 100us or so is problematic in my view,
so a 100*ms* timeout is scary!
