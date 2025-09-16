Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64BF017B505
	for <kvmarm@lists.linux.dev>; Tue, 16 Sep 2025 14:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758031754; cv=none; b=XEHn/9AKItoixsKVoN5JhFm+WKw6mDaoN82aglMLpmuzHixh4YRR1OE9X8uu/cN9DlSAi/5tEL7AiLWHaKCjcjkr9g6e2DfvNsMtREsYa8GRtXALFnbTfcb/bgMwAZ+cJkF/Rc963yrjtxXtQQx7+faQ5HoROPEtIIEvjz0MegM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758031754; c=relaxed/simple;
	bh=OivZHE65qXE5B/vTKRFEaDN3nIm3K+Gd2wwZUmavPgM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hIAAOz1+/4y6ZMsBDCEUEu9QpOcefmPiaM2acCiBkaeku8bfCBWJ52hzM7Dg+zNGo8tI2tHiZWNJeYbHroDmiA6Dx9Zr8U1lJ0mBkD5nCu6PZYGfzRYYvnvhkOl91Jf5Y4LDpBT/hDqCRIKfOHzuC3I2g2q3SplWu6VX1BXpggo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EIvPImKV; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EIvPImKV"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-45f2f894632so55285e9.0
        for <kvmarm@lists.linux.dev>; Tue, 16 Sep 2025 07:09:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758031751; x=1758636551; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=naxnlF8RW3uPyYwaOywJDf3OceUlrkorGyjKAmqFqDQ=;
        b=EIvPImKVXVgIK065FF2NouyOC3p44HIhB8iUXoyLjF29BdbarNWMs993QgS8gD6A3T
         /B2WDivM4iYW+qqSpLWD07TwR6khBuzlpdYQy36fwoD98ZUNdCkgqyDOXrO2yhMHyDkO
         9CMU33sUiFQT2y6vcAhqHRU70Htuqa6UkoVWqpbg6UC8qi65UpIT32GqUetBqFJXAJ2y
         ig99Bd7ev9A31K3ASpQjgdchaPJs2P/nWKm51ZtILZSgNIM/qoJeWcg4VjF8sE1mTm4n
         JUvEoJi8uAUoRjqJ/h/LIniaagz/QHY8XnpAzn8bHBr0uDPpnnovael9MMSjA/ekF/tr
         6JUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758031751; x=1758636551;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=naxnlF8RW3uPyYwaOywJDf3OceUlrkorGyjKAmqFqDQ=;
        b=jtn8CwFw/I4tKbSml5hd9tWJ7iS4w5gunyHgZ7lnXW12GtmBa96tlVc90/rnAv3INN
         I08wTQ4tu1ZqXfxe3LYGbNITN7h4luYXdENeYaFhW/+SMCOGPdisSDc9Jd781YMvb8yg
         Gmh4+8gcvXooBr1UJt3+xwaWOxeSSzUi0rfma7TVE8Qk3eCT8rtLNtU4T3eeO7y3wwVC
         DZn/rJUpghPKDaKx7FEE7H/kxi67RnxLAnxB3W3OQMfCr/sgS1ehRGbRRRTy2M8tpOoK
         6aNryvmgJmeTplX+PopntL9G8gSAZq3u5vaCAeFhP3cuDbV61iWQJA0crneQt0ouznkg
         DwBQ==
X-Forwarded-Encrypted: i=1; AJvYcCXc4uBJ6tZ44jfhmF4oHJdA0e40aCUNJn1xsabQSrbNi41xciOfOv1W03ciVWZ+G2FhRU9S0QU=@lists.linux.dev
X-Gm-Message-State: AOJu0YzLAmG2hp3z4gyV2LrAy+Eveiib3W2+FOZSVDJ1U8uBwdKj+t/E
	XLBOVEtvNjCXWvCCr6gAROox5kVDlVc9i5IFonKqBgD+29hJjNHzayyjBIXAV0NsQQ==
X-Gm-Gg: ASbGncv9gF0ORwitCWfFZ7DujqeVKQgpmVVSx2oxdE5xHtV9f3C1lLTLR6dFrnjxwBM
	94v4S0x+BTeUsKoRfcKBJE1eyHweS60PzkU/zLfCc0aGtTcABiELHvLp6+RFU+6s9LOqS5SVoTI
	Tb5F6EgdZJBLSspSXPDRj9UlIhq9smSlXBcDaYX09tM7pHiBD/vnQbdC03uBWb8S5O1oASu9z6f
	GjrCbDBklY0XtEL6JM3Hb8yIGDxYE83W0xQv9WY3/4C+ilFKeUh1TZ8xGCHvNWYFTMe9lp8hkd7
	FGyiNXMrdb5AvC9aQPtVCDov6iDqxkcAdj/+4geEjvh7Il8EvpajDTvmrvy9l8/YZRGCgOuMXxv
	O0eLF6Z33XOX3j+zDsD0+xVMEll+wr77bUp0F1Cf12sHbZYCEU7YfDN3kEODPGYbpb+zwkQ==
X-Google-Smtp-Source: AGHT+IHiAMHPDFkAjiAxoWmA+0eW1WUNEbjO+yxVuqDckIGe39OhDb7FDlwQGK8b0ego1xO8BRYMfQ==
X-Received: by 2002:a05:600c:4689:b0:43d:409c:6142 with SMTP id 5b1f17b1804b1-45f320079e2mr1928645e9.0.1758031750409;
        Tue, 16 Sep 2025 07:09:10 -0700 (PDT)
Received: from google.com (157.24.148.146.bc.googleusercontent.com. [146.148.24.157])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45f32083729sm19395835e9.0.2025.09.16.07.09.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Sep 2025 07:09:09 -0700 (PDT)
Date: Tue, 16 Sep 2025 14:09:06 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
	maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, robin.murphy@arm.com,
	jean-philippe@linaro.org, qperret@google.com, tabba@google.com,
	mark.rutland@arm.com, praan@google.com
Subject: Re: [PATCH v4 04/28] iommu/io-pgtable-arm: Move selftests to a
 separate file
Message-ID: <aMlvglecB0ZA2fmd@google.com>
References: <20250819215156.2494305-1-smostafa@google.com>
 <20250819215156.2494305-5-smostafa@google.com>
 <20250915164517.GL882933@ziepe.ca>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250915164517.GL882933@ziepe.ca>

On Mon, Sep 15, 2025 at 01:45:17PM -0300, Jason Gunthorpe wrote:
> On Tue, Aug 19, 2025 at 09:51:32PM +0000, Mostafa Saleh wrote:
> > Soon, io-pgtable-arm.c will be compiled as part of the KVM/arm64
> > in the hypervisor object, which doesn't have many of the kernel APIs,
> > as faux devices, printk...
> > 
> > We would need to factor this things outside of this file, this patch
> > moves the selftests outside, which remove many of the kernel
> > dependencies, which also is not needed by the hypervisor.
> > Create io-pgtable-arm-kernel.c for that, and in the next patch
> > the rest of the code is factored out.
> 
> Please send this as a stand alone patch, it looks like a good idea.
> 
> Also please add the boiler plate to wrap the selftest into a kunit and
> use the usual kunit machinery. We alredy have an kunit for
> smmuv3, it can just add another file to that.

Makes sense, I will do that (hopefully before the weekend)

Thanks,
Mostafa

> 
> Jason
