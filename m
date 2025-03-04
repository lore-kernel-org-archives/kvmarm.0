Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FD2115E97
	for <kvmarm@lists.linux.dev>; Tue,  4 Mar 2025 00:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741049612; cv=none; b=ME0vo7FV/nbXa3rw0PmU8fHf8pG3yt6yqF7P8J1KLNk1jw+Jco8q6K8JSDHiZaoCefAZZ/JvHjenLgsZwIyKOuPApZsMp/+x69PfYyrhVtmKNrKZ4PVdIYZTVi6KfpZIbdoqWcIoaD/VpaYsn604gSQAF6dzJOMgsr6L2qu0H+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741049612; c=relaxed/simple;
	bh=0+mIMIMzFWzCOIWniwtvw+BDMmwo8z0nfLGggh6sfXY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UnJfd4GZqKfn1k95xUtOJQiOpfuMvBs5HZFOA2IibyAklmxPeP8FFQPB1FbWONbWc5hRCWV0DgqX24AN1vpZ+TVaGSqjk5Rr+Gd+EgyophpXzrPDpRH1IQPXi2oGDQ2b2wd5Y/Tbz9h4zNNLi8NbRP76tVNOUlY1xgOnCHTZ2xE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xzsA1Pr6; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xzsA1Pr6"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-43bca0048c3so12125e9.1
        for <kvmarm@lists.linux.dev>; Mon, 03 Mar 2025 16:53:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741049609; x=1741654409; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=QcGW3hftQvU3jMggm2moyLYr9Q6yInAQjdzrqRR3vjc=;
        b=xzsA1Pr6mexY2H6VMiAq4TeERkOZlpzf01kUT52dq3P22G6M20HDxEGuQHZt6rCf+s
         P5RqLQksW7EYsbnvcrnosZdIkcrUtsxewEUeW6Nbo7RUIYmwqKtiNdIy5qNte18fY5df
         ZyIKvfhCyQK1jq18KClE8HVJ4ks17J0pytfbPoJ+/u/Bw+PXDdGxiGCXOQsU+jntYD4s
         eDXGzH2zJSKs7fu1yV6OJ1zOKE1tpFmk+DmtCdaoVQm8tCv9n8/zpGHJSB61lYEOO8EO
         wvF/nHCM+36X7scTFRxA/n7ni5Si+SImV3Lo0aD6LKRMjAcgeeDWqr7G3zSOhvu+ksDY
         Q8Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741049609; x=1741654409;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QcGW3hftQvU3jMggm2moyLYr9Q6yInAQjdzrqRR3vjc=;
        b=mwwygAdsHPBHMpMgns8A/yqUJya/AfGjSwwMH0alUkyJ9lHeQFeKUzT9bX+e9pBeUK
         QHHaSI39CgB8zktg+6Lnm6f5WpAGyNLBVKQbZoSUiRlq763tpqsl7nMLbHT3Aq6ImCXA
         ga/+JCgBR0a/Rgt7qvNYV2h0Q0Dhwwtct9WSepOjj0CvUcNoB9/Bj0X1d/v8J0RWpnb6
         NDfodyjb8+ej1b8qBd/s1OLZPbwa2YENS+F8j360Q6iGf4hHisU0wjXS2YyYVQRCev1J
         fHObSyrPInpkNZHEx8JgxSRlpl7DmKgd3HEC/bstW8KSBwJx2boT/7q5DbmZcXbGmH/m
         sD8g==
X-Forwarded-Encrypted: i=1; AJvYcCUdJ+4ofuYtnurUcWehj064uiYKW0RBFswcexbIZ841UKKLI8zgiBvVVYUuUAL2hNEBGO7qAZk=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywll0HzYrErKoAChYsC9juT92FGPb/tB/fA21yKnO9qMOV1Gic1
	/2vdekb+qmtYnybOTUzCko8K5PG7/5q55zrGZsLJmdojCfF+xTU5lYeRcWzIwg==
X-Gm-Gg: ASbGnct3gEe/ZPoadHXR/IcwAyng0ydcw3EuEg9iHIq7cbBkSZwp0eeRunkXVqsxpCJ
	Q5Myarcu6ZGq27a2N04IH67ROM86+Gj5xt3k1ysWG3hPjCiil9SoPOiDKy+68z5W9Yv/p3vgoqJ
	TR34l1Csz1EkgitmlWZZIGRcQzAZZ+UQXwuPOaDIntFT76jTacvBdWt1FGH6jk0U5kpnzhHBjBN
	wxoH5ucvshvfWq5a+KTlZHyoL9aJ9cgOA9FU7HnRb09zcm1HUDUj+G0VFUHnyl/ARZ03nHi/6B7
	9U0V8bPbRJGJEW5xXq9KAHScUplk6LSC80n0YfoWCWN/5mFyKUljNo+dX+VwUzYy/k9zeaVl3DX
	TmRm06XnM9aY2
X-Google-Smtp-Source: AGHT+IGGyKa5a4dpqv99Cmt1pAVAafiGZn4JUYC2/5rtkoVDs1twq+6HqnYQlt8PwwJ67CJIVwLsOA==
X-Received: by 2002:a05:600c:43d4:b0:439:9434:1b66 with SMTP id 5b1f17b1804b1-43bcbe262d7mr265745e9.1.1741049608743;
        Mon, 03 Mar 2025 16:53:28 -0800 (PST)
Received: from google.com (100.235.22.34.bc.googleusercontent.com. [34.22.235.100])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-390e4847fe5sm16074903f8f.73.2025.03.03.16.53.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Mar 2025 16:53:27 -0800 (PST)
Date: Tue, 4 Mar 2025 00:53:25 +0000
From: Sebastian Ene <sebastianene@google.com>
To: Will Deacon <will@kernel.org>
Cc: catalin.marinas@arm.com, joey.gouly@arm.com, maz@kernel.org,
	oliver.upton@linux.dev, snehalreddy@google.com,
	sudeep.holla@arm.com, suzuki.poulose@arm.com, vdonnefort@google.com,
	yuzenghui@huawei.com, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kernel-team@android.com
Subject: Re: [PATCH v2 3/4] KVM: arm64: Map the hypervisor FF-A buffers on
 ffa init
Message-ID: <Z8ZPBZF7J-qKdb_i@google.com>
References: <20250227181750.3606372-1-sebastianene@google.com>
 <20250227181750.3606372-4-sebastianene@google.com>
 <20250303234259.GA30749@willie-the-truck>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250303234259.GA30749@willie-the-truck>

On Mon, Mar 03, 2025 at 11:43:03PM +0000, Will Deacon wrote:
> On Thu, Feb 27, 2025 at 06:17:48PM +0000, Sebastian Ene wrote:
> > Map the hypervisor's buffers irrespective to the host and return
> > a linux error code from the FF-A error code on failure. Remove
> > the unmap ff-a buffers calls from the hypervisor as it will
> > never be called.
> > Prevent the host from using FF-A directly with Trustzone
> > if the hypervisor could not map its own buffers.
> > 
> > Signed-off-by: Sebastian Ene <sebastianene@google.com>
> > ---
> >  arch/arm64/kvm/hyp/nvhe/ffa.c | 46 +++++++++++++----------------------
> >  1 file changed, 17 insertions(+), 29 deletions(-)
> 
> [...]
> 
> > @@ -861,6 +842,7 @@ int hyp_ffa_init(void *pages)
> >  {
> >  	struct arm_smccc_res res;
> >  	void *tx, *rx;
> > +	int ret;
> >  
> >  	if (kvm_host_psci_config.smccc_version < ARM_SMCCC_VERSION_1_2)
> >  		return 0;
> > @@ -911,5 +893,11 @@ int hyp_ffa_init(void *pages)
> >  		.lock	= __HYP_SPIN_LOCK_UNLOCKED,
> >  	};
> >  
> > +	/* Map our hypervisor buffers into the SPMD */
> > +	ret = ffa_map_hyp_buffers();
> > +	if (ret)
> > +		return ret;
> 
> Doesn't calling RXTX_MAP here undo the fix from c9c012625e12 ("KVM:
> arm64: Trap FFA_VERSION host call in pKVM") where we want to allow for
> the host to negotiate the version lazily?

We still have the same behaviour where we don't allow memory
sharing to happen until the version is negotiated but this
separates the hypervisor buffer mapping part from the host.

> 
> Will

Thanks,
Sebastian
