Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8FFB23535C
	for <kvmarm@lists.linux.dev>; Wed, 26 Feb 2025 18:10:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740593455; cv=none; b=Gpuaac11pbs7otZMOVsybSDJz7IwgvZxg84jenjv76r2xfQMv5HLyjQfUgYyAvC0vpVQxHSqNHwHy926Wz29eEHQDFBbIZ5Q5AWXJeyFT6RKvo3OgJPz2R7ttX22qaxydGD9DPqG3xzjdac4RN4tVWK0sNmnIao0SHX9PIvCpn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740593455; c=relaxed/simple;
	bh=EbaACQr0vW701BtG20JwXpLEEwmHg6MVq+JFkWjYS7w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WVdryFpUd3fY0XR1sU91C674L1zm1Wkbmt+clYIj59CHRPUE8XvOEXz0Yd71CV8CrmYVanrK9gCKmiSqVxveCln+qFB8IBeTN5Z2xNbPf4/TvxUbjPFuNFdZ/TzVJEWHJG8nBJX4pJtl4uTQ1go15yKV5g58SVQ5Vi2MpIcPFNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=neqMUtey; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="neqMUtey"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-5e0373c7f55so7956a12.0
        for <kvmarm@lists.linux.dev>; Wed, 26 Feb 2025 10:10:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740593452; x=1741198252; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=V/V8Jj9rYZChtFzsP4NciMXPlW80o7eEp6Sp5AawXIs=;
        b=neqMUteyl/wO0zgEkAn9MCTK7z5urbKrsMvKbvPyKqELy7Fb3Bns5epuZz8f+TOBRb
         FnGmjxPYJhJ+G8cTit+vpV1NQ5RhLvCeI0gtqHglfrTkxDByXGLymkXQygiezGFKR3a2
         A7D3hXw/JOp1MXTf2xs9SBX4jA+2lNHQJClTxCMR2urkCUSCquZE2vFn/MQYH9fmFt7o
         698dqcFukbguLyx3qy7JIQWI2f21OEWscst2/eIc2xQb7NTQErcYvvjvUO1GVdPqpmz3
         9DDK0i9ihxazvgnZ4XUN/ZWn1sHF+WftsCNjV8n+ulKwqOLx4hcwzpvlMX1/xqzGLdh3
         6wKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740593452; x=1741198252;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V/V8Jj9rYZChtFzsP4NciMXPlW80o7eEp6Sp5AawXIs=;
        b=CddaUoGH/g2+hNnHxpAqViVrIzCXm1ilUDbuB9mMrsNW2l+yyVcCWJ4PZf6RsHi3B5
         BFIErHzwqLQmjXeN3IsQfc3reWHMzMfuyfuHn9DXqcK+hz6SthibRmeYYd4teLRZ2uL8
         504ehwcluIStRnFsB5kQGXJ/bs0yaoFbOLT5qNiKAsEoKEsjB7qcr5k37UYVkJ0Ejg0P
         50xCFa/XEGNQi1kJaVXQGWeW9XgWsBx6NqdngSgU+Nu7s1Pv6G3BbQ8mKbaT4O0MjMSs
         KxtikwzHR/WT/IKw5PLMzHy7aIo6e7YNiCrfR40RDOYCFkew+U7LexaKGKUlQ1yB9whw
         6utg==
X-Forwarded-Encrypted: i=1; AJvYcCVhUu4K46H69vSnqRFSKzt7EHWLxzfJ3oAXmhStN106s0JulZR/AbCDtAYa+hUkRMFl2UpGRgE=@lists.linux.dev
X-Gm-Message-State: AOJu0YwwzyiKUJqU+tkh69EWSk5EGjz8yqjJQSApg27ndznL9rYERumW
	mfCNtM3RUwbLnEZFnlo/acq2myDV+1CF2lH5diHf4RX9vLgYFZQF68l59lchpA==
X-Gm-Gg: ASbGncvpCXDp3FEDq05fgDS27TtN+0A0BO2atZFA7bQqj5hdXLNcq+eMBrGwhMfqhSB
	m6G+nxWEeKGaOhtx6W6tyaY17/1HjGPjCTJ5TamvBD0nO51F54Gt0vQoXtJVtfLiYVNftjXQNxx
	cgvIv0mlje152iPD84HK4N6hwDt+B/ZCXSV/wHtfK+u8mp4YgIkCnNUklKKOraitliyfX9TtNQg
	gE1ygwVwJDTRp52ZgEnIBust0eM3lzcxooIA5nFOw1SHggw4037ov7UuZWhGg4Hr2Cs0SjwXHi0
	/etzyX6aGKQO5h+fxGvEp/xGq9Ceyp/sdIdSqBJeddO0oxwtV5vaEkL92LqrCeo=
X-Google-Smtp-Source: AGHT+IFSemQuFVxhcR1OJIBHEWyJQf2Hjrc2hP3J/LbxvQX6+WX1I3uywZ6yJMAv4hfkJ2aaAYgxNQ==
X-Received: by 2002:a05:6402:501a:b0:5de:a6a8:5ecc with SMTP id 4fb4d7f45d1cf-5e4a0d490aamr5970613a12.5.1740593451852;
        Wed, 26 Feb 2025 10:10:51 -0800 (PST)
Received: from google.com (229.112.91.34.bc.googleusercontent.com. [34.91.112.229])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5e45a8b8c4esm3155601a12.26.2025.02.26.10.10.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2025 10:10:50 -0800 (PST)
Date: Wed, 26 Feb 2025 18:10:45 +0000
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/4] KVM: arm64: Selftest for pKVM transitions
Message-ID: <Z79ZJVOHtNu6YsVt@google.com>
References: <20250225015327.3708420-1-qperret@google.com>
 <20250225015327.3708420-4-qperret@google.com>
 <867c5crd2j.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <867c5crd2j.wl-maz@kernel.org>

On Wednesday 26 Feb 2025 at 14:32:52 (+0000), Marc Zyngier wrote:
> On Tue, 25 Feb 2025 01:53:26 +0000,
> Quentin Perret <qperret@google.com> wrote:
> > 
> > We have recently found a bug [1] in the pKVM memory ownership
> > transitions by code inspection, but it could have been caught with a
> > test.
> > 
> > Introduce a boot-time selftest exercising all the known pKVM memory
> > transitions and importantly checks the rejection of illegal transitions.
> > 
> > The new test is hidden behind a new Kconfig option separate from
> > CONFIG_EL2_NVHE_DEBUG on purpose as that has side effects on the
> > transition checks ([1] doesn't reproduce with EL2 debug enabled).
> 
> That's a bit annoying, isn't it? Without EL2_DEBUG selected, you won't
> get any stacktrace, and the WARN_ON()s are a guaranteed panic. Yes,
> this is better than nothing, but I'm a bit worried this is going to be
> hard to use.

Right, so you _can_ enable EL2_DEBUG on top of the selftest stuff, and
if you're not hitting one of those hard-to-find bugs described in the
commit message above, then you're golden. In practice I suspect that if
enabling the selftest alone leads to a panic, the next logical step is
to enable EL2_DEBUG and see what you get. If enabling EL2_DEBUG makes
the issue go away, then that'll require digging a bit deeper, but that
should be pretty rare I presume.

> Is there a way to reduce the impact the EL2 debug has on the rest of
> the code? It feels like it is more invasive than it should be...

Turns out I have a WiP series that moves the hypervisor ownership state
to the hyp_vmemmap, similar to what we did for the host ownership. A
nice property of that is that hyp state lookups become really cheap, no
page-table walks required. So we could probably afford to drop the
EL2_DEBUG ifdefery in host_share_hyp() and friends, and just
unconditionally cross-check the hyp state on all transitions where it is
involved. And with that we should probably just fold the pkvm selftest
under EL2_DEBUG and call it a day. Would that work?

Thanks,
Quentin
