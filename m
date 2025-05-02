Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E40423C515
	for <kvmarm@lists.linux.dev>; Fri,  2 May 2025 10:35:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746182155; cv=none; b=Iom7pATMu8+j9Q4hmgxuHI9XzitwyWIxzMCvbyuMYQGr6aU3vxSXUCkK6tGTUhm5dMhi5uPj+2nU2DzSNvxs4XrqAFIH7i/6dgNGiudqAJn/2r5vs+b8C2IHu0PvG0R/rrBjkq3H0qQtSeqjPTCNbLvGFBpMtwxMt1ciCNbJMr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746182155; c=relaxed/simple;
	bh=YMQVxwaVMwAxpI4MOStKXhl9OZJMpJXac6MsJyy1J3Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cm+//6Y/r/kBlSeuS8iKgJXGUzDmoZqyTgpxCUXiR2/kDTxHAq88SUFlDc8jzMUbPOl8jqLba0bPQuUJ8gctoaKPXi3N3r6ZpRygWVOdNOM88oUb6Fny9jnwxyi0kn3VbEDaHrGn6GPINod+ZSTdITTeu/FatacxT9l0leEVD6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ncQDjPV3; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ncQDjPV3"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-43cf3192d8bso33525e9.1
        for <kvmarm@lists.linux.dev>; Fri, 02 May 2025 03:35:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746182152; x=1746786952; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CtsSgTJXGapsZiIyWX9A+s/wE2QFs3U8FxXWY4U190Q=;
        b=ncQDjPV3H+68FU9I6kzZC6VNZ+6CIHelsqhTk1CsGRPUQfn0LVvHGCEgAzRxyUVVoj
         HQWoSo8IiBmSssOJMWC+lvnU29eFdUfFxxxzJZcjgl85mzyapwuJ19FtIhlASiT8WdBO
         x29zT6+q2PX/p0r4wcXeJDNX8DHjnksUC86+qm1aNmoMh8OemwUzV7DB3pPsNe+zagsu
         cLReca7rY/s++z2mz5N7MO2eEQ7TGLC99XX22JP1deJyUYhNOXV7T0AOaPZ3aOiES5P0
         LyOiPybPT6io0bZULE1LDSqoGeU822WIMzZxCFdfgTq+lc6pNaar15ah1qNYBbUvGd4+
         vrSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746182152; x=1746786952;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CtsSgTJXGapsZiIyWX9A+s/wE2QFs3U8FxXWY4U190Q=;
        b=hBSbpPf2woo5Yq+hmpRWzpcWQPe01v1JAr//kVXTqYiwUl1/xH6bU/HDT0vAvi7WkQ
         Tmoi+/0GDYVBHotRvEQiNvCfeSoYTbPvd5V6+JnvpVetzbH9eG2DUrzCgPdCZP80j6Ya
         lB76IGpuT6GE3EC6WmrzNmuXyKZ+TUgedKdYr42RACaFaXE5uP6wgW9SgPt72F6Kl9Qd
         NTouQxHz5vbTzplKfrrfPjh82FiUOXbkaeOSDo551tomLcfq9bogQCHV/dA3tixLNfuk
         rzjCQnt0Ygn/6L1gcJVBndyAKI44eTqr8Oz/BDrQJ7GLjjI5N0YByvC6bSnr68zhoSID
         9bJA==
X-Forwarded-Encrypted: i=1; AJvYcCXTYaKX2YKfy3iFbZJtS2+ctX6PSjrX9JrLQMkowEQ8yloxC/P4/gO5iiEfHjXbC3X/xH2VoDI=@lists.linux.dev
X-Gm-Message-State: AOJu0YwlcIrgxLCyM7JGj6X8RThLZUwW46pcbMvUINaZbO2Xetnnc5b4
	MiCbdTk/7HkndISngT/3SsDsJ0wY1GPRFOVQTwbc/oJSmafhZr1+NG5bBluoOQ==
X-Gm-Gg: ASbGncueb2WtpujL7TACSAsi2jHMqkRJqlj/0GAHiC3gCdxbwImb+I/A0vCvBqXzKXu
	UcAWgYwpKGvffq7uYE42lPRMI6jSRn0U1C+npaI4rrFX9mxL86296bKA9wNFFTDcdkv7VlodF1y
	0LcVTpHcoSMJ8oLkivWIoBrVP00HT0+rG5+cdPzJyqXCdfeRJOhGoXT/V5gMZfTWluAkwDo/bgb
	2GVrpP3qfj19dyD3vHuB5/PL7EUfqOJa4jMZTmMtMpbWTEdiFDcx7kjmKpKCBTWssZ5RBcRVynN
	CfZtVrMvoFaADaozKhKMni6hg1ugPqj5nkriY6ip/ie8FtBGlvfg5C1c259P/wLZI97MsBy8/I2
	NF8RW5wEarfus5pHE
X-Google-Smtp-Source: AGHT+IHBpu5+Cieu3gqJ8jXxnE8iNjMiOB9PP9JbLSiZk2YmB4uIxV8AkyqehbOtRxJxY1xSoUA/kQ==
X-Received: by 2002:a7b:cd08:0:b0:43d:5b3a:18cc with SMTP id 5b1f17b1804b1-441b641d324mr1930065e9.2.1746182152313;
        Fri, 02 May 2025 03:35:52 -0700 (PDT)
Received: from google.com (207.57.78.34.bc.googleusercontent.com. [34.78.57.207])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-441b2af2a0csm85602295e9.18.2025.05.02.03.35.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 May 2025 03:35:51 -0700 (PDT)
Date: Fri, 2 May 2025 10:35:45 +0000
From: Sebastian Ene <sebastianene@google.com>
To: Per Larsen <perl@immunant.com>
Cc: linux-kernel@vger.kernel.org, catalin.marinas@arm.com,
	james.morse@arm.com, jean-philippe@linaro.org,
	kernel-team@android.com, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, lpieralisi@kernel.org,
	maz@kernel.org, oliver.upton@linux.dev, qperret@google.com,
	qwandor@google.com, sudeep.holla@arm.com, suzuki.poulose@arm.com,
	tabba@google.com, will@kernel.org, yuzenghui@huawei.com,
	armellel@google.com, arve@android.com, ahomescu@google.com
Subject: Re: [PATCH 0/3] KVM: arm64: Support FF-A 1.2 and SEND_DIRECT2 ABI
Message-ID: <aBSgAScZUp9qIspT@google.com>
References: <20250502092108.3224341-1-perl@immunant.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250502092108.3224341-1-perl@immunant.com>

On Fri, May 02, 2025 at 02:21:05AM -0700, Per Larsen wrote:
> Hi,
> 
> The FF-A 1.2 specification introduces a new SEND_DIRECT2 ABI which
> allows registers x4-x17 to be used for the message payload. This patch
> set prevents the host from using a lower FF-A version than what has
> already been negotiated with the hypervisor. This is necessary because
> the hypervisor does not have the necessary compatibility paths to
> translate from the hypervisor FF-A version to a previous version.
> 
> Support for FF-A 1.2 in the hypervisor is added as a precursor to the
> addition of the FFA_MSG_SEND_DIRECT_REQ2 messaging interface. The bulk
> of this change has to do with the upgrade to SMCCC 1.2 required by
> FF-A 1.2. Additionally, unimplemented FF-A 1.2 interfaces are added to
> the list of unsupported functions.
> 
> Tested by booting Android under QEMU and loading Trusty as the guest
> VM and observing the SEND_DIRECT2 ABI being used successfully during
> guest boot.
> 
> (This is my second attempt at sending out these patches; sorry about
> my broken first try and the resulting duplicate messages.)

Please tag this series with v2 if this is the second one and include a
changelog.

> 
> Thanks,
> Per Larsen
> 
> Per Larsen (3):
>   KVM: arm64: Restrict FF-A host version renegotiation
>   KVM: arm64: Bump the supported version of FF-A to 1.2
>   KVM: arm64: Support FFA_MSG_SEND_DIRECT_REQ2 in host handler
> 
>  arch/arm64/kvm/hyp/nvhe/Makefile |   1 +
>  arch/arm64/kvm/hyp/nvhe/ffa.c    | 235 ++++++++++++++++++++++++++++---
>  include/linux/arm_ffa.h          |   2 +
>  3 files changed, 221 insertions(+), 17 deletions(-)
> 
> --
> 2.49.0
>

Thanks,
Seb
