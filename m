Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 512701DDF6
	for <kvmarm@lists.linux.dev>; Thu, 28 Mar 2024 13:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711634347; cv=none; b=MyphtRoctHRvXPGt/ICBaSIS/uKcWntaYvFjiJnyATOYSzpJSvrzX1yc0gY51DVUzfQ4bv5qG+1qiU92HflLAxj5GZFSWWXEFDUsk6UbWtAW6cam5CglSYCMZA3XzaebJ14d18EDEmFvzuroihfDRyEpRySd8vnSdnNN+89jTlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711634347; c=relaxed/simple;
	bh=NK7LET77latJxFetZ4zO1WlQhyaBRI6+mpEFOHPiO1k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SwlTMgoZJwMhj6QYLc6Lq5OOuc7XuQWu/mm/ki5HsDBoD3OVOYp+nHVLHYNPVsajSGzb3ykFjzo9rWQ2rNxf6vjPBOkecE9EUUXtXnK9WVJLjoaOxHqHi4U9bWFGh9NitzbkyQJzRtrSpAnaFmCp+ZvYHULNSie+inSZBS04EG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XPoIQ5MR; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XPoIQ5MR"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-413f8c8192eso75045e9.0
        for <kvmarm@lists.linux.dev>; Thu, 28 Mar 2024 06:59:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1711634343; x=1712239143; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=UhSlWCplow3q0UiENwQXBqJUPqprxyAeOLjfYZq98Wg=;
        b=XPoIQ5MRFyuOvTaSy/QPMT+AqORSvKy0CM0uua1GwexcIo57QwEgfgEyyuVCrgBnHZ
         AI1KvOh/Zxc5cU695GZXTvc3AFAcx+j9PdyE7hcUL8QywwsU0zmYWLe6NrqJH1ATfERT
         i3q1MMCgdJ3a8exAr42dzF/T/BRwdSYwOJDmvbaCJpqiUn+IofSM8bUBJhhA4y5yhhG9
         +NLaOBDVtkPwGQAS+IgXQ+CeyF/BRTe78WxrvuP18wvuOoCEPCkI9GU1bh3dyWqfqPez
         Vg5GmrzLkws8bf1bFGyWzDYuwQDHRYsSooYq/i28TCLjzToG2BOG6HGWodHXTL4i/L1R
         koFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711634343; x=1712239143;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UhSlWCplow3q0UiENwQXBqJUPqprxyAeOLjfYZq98Wg=;
        b=mCqE00wvjQ6sfn5+lp8mhxR2pJQ+10eOPC6/m10C3X+/wSEs6LXXYlR5sw66TBvEF+
         VHAA1kZA1bogky+h+AWKHMTzqnMulyNP3gznXzfxBDsqKydpA5dBKc2MtbOFPk8k+/nc
         xhuMVtWzeCUnHZO5Hysi7vMI+Syz44iayKLw2ULbCczBUR0IalhyXJ1LQlRC6pYkl6WG
         9xAFCXxbyO4p4eLLXIT2Ya15DIbztutcWwZpFQ4Jw4zJCqwsypBOm9z5GyqYwiwEogZW
         /zTJH1krZb4vZGYfakDMUjBT8H2VtFGKE3vs68HXRnNhpH4e+9tBdS1+gdVLdIVVRhpi
         WFag==
X-Forwarded-Encrypted: i=1; AJvYcCUoLh1fXMSzpaptDdhr7/wfCoXScRiS9IL0bNku1+q/FMz/V3bXLAR2YNjjoP4Z6amxEmPODTWobVUku0o++IpTlwnOmjql
X-Gm-Message-State: AOJu0YwOnTYhnQB26hngZdUbTdS84rDgD57/a1Crl1Sx2bAZjn2oGQ+a
	glYNBaDqczdT7o8PvqjTq69+QCsaQhx2jyDEOJhS2QCdDAjv109lkbmC0GKNhw==
X-Google-Smtp-Source: AGHT+IFkjqEo9WYWh9uwV7qW8tTZm/X3G1itWmwY9D+9DsKXDmdQqm31owW8ZokBAn+BbbDZkcRWnw==
X-Received: by 2002:a05:600c:3584:b0:414:daa3:c192 with SMTP id p4-20020a05600c358400b00414daa3c192mr213991wmq.0.1711634343417;
        Thu, 28 Mar 2024 06:59:03 -0700 (PDT)
Received: from google.com (248.199.140.34.bc.googleusercontent.com. [34.140.199.248])
        by smtp.gmail.com with ESMTPSA id l6-20020a05600c4f0600b0041469869d11sm5499477wmq.47.2024.03.28.06.59.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Mar 2024 06:59:02 -0700 (PDT)
Date: Thu, 28 Mar 2024 13:59:00 +0000
From: Sebastian Ene <sebastianene@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: catalin.marinas@arm.com, james.morse@arm.com, jean-philippe@linaro.org,
	maz@kernel.org, qperret@google.com, qwandor@google.com,
	suzuki.poulose@arm.com, tabba@google.com, will@kernel.org,
	yuzenghui@huawei.com, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kernel-team@android.com
Subject: Re: [PATCH 2/2] KVM: arm64: Allow only the specified FF-A calls to
 be forwarded to TZ
Message-ID: <ZgV3pGvUhaK5otUL@google.com>
References: <20240322124303.309423-1-sebastianene@google.com>
 <20240322124303.309423-2-sebastianene@google.com>
 <Zf45eDs8Bd1UQ94Z@linux.dev>
 <ZgFgI0Ky2m4MUbw-@google.com>
 <ZgKKcurtndJaIwAV@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZgKKcurtndJaIwAV@linux.dev>

On Tue, Mar 26, 2024 at 01:42:26AM -0700, Oliver Upton wrote:
> On Mon, Mar 25, 2024 at 11:29:39AM +0000, Sebastian Ene wrote:
> > On Fri, Mar 22, 2024 at 07:07:52PM -0700, Oliver Upton wrote:
> > > On Fri, Mar 22, 2024 at 12:43:03PM +0000, Sebastian Ene wrote:
> > > > The previous logic used a deny list to filter the FF-A calls. Because of
> > > > this, some of the calls escaped the check and they were forwarded by
> > > > default to Trustzone. (eg. FFA_MSG_SEND_DIRECT_REQ was denied but the 64
> > > > bit version of the call was not).
> > > > Modify the logic to use an allowlist and allow only the calls specified in
> > > > the filter function to be proxied to TZ from the hypervisor.
> > 
> > Hi Oliver,
> > 
> > > 
> > > I had discussed this with Will back when the feature was upstreamed and
> > > he said there's a lot of off-label calls that necessitate a denylist
> > > implementation. Has anything changed to give us confidence that we can
> > > be restrictive, at least on the FF-A range?
> > > 
> > 
> > I remember your proposal for having an allowlist instead. The current change makes
> > sense if we have https://lore.kernel.org/kvmarm/20240322124303.309423-1-sebastianene@google.com/
> > which opens the window for more FF-A calls to be forwarded to TZ.
> 
> Got it. Last time I didn't catch the level of abuse we expect to endure
> from vendors, but now it seems we will not support non-conforming calls
> that appear in standardized SMC ranges.
> 
> Adding mention of this to the changelog might be a good idea then.
> 

That's a good point. I didn't create a changelog for this but I should
add one and specify this.

> -- 
> Thanks,
> Oliver

Thanks,
Sebastian
