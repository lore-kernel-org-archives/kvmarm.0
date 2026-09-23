Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEAA2472098
	for <kvmarm@lists.linux.dev>; Wed, 23 Sep 2026 08:52:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790153587; cv=none; b=oJM7x1BZIXLRMvanxFTLhz77UaMf1AxmvqTBG0QHr4EHuieyqg5wcIB4nCFRqSkDFpfTyYTZx9O/fL8sIfVSrMipqS/SNFFNVlBY4iRrsuXckpLkozOE5YQX7pDQNq3l2sJDGOFt8ffYctp/QluNw7S9gN+Snj+gZItLUpRNRcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790153587; c=relaxed/simple;
	bh=+Cl6oGedBJJ+fMGdxql2VP3tbVmZikvWHze9Qm20rQQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eNpIn60RT13g0JHwfPsO7LRGOh9JEP1Q+f4xRQtfg2EEOWLq/kMq2GGpcHU8sovGs/rFJg7RUrD0aApk+2P9ufTFow8oKdkvFWL+A2jPIfy/1YG5oXB9UL4J4Du1BnPHiQI1WSTIDt2QzzQPETnANvyEbatfPBDJDrqDJNXsXjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=h4H35Clw; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="h4H35Clw"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-49e6425f96eso31035e9.1
        for <kvmarm@lists.linux.dev>; Wed, 23 Sep 2026 01:52:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790153574; x=1790758374; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=aefF/PiYK1b4Z/D8ikpDUgUaGPgIxFbZ+BKtTsI/MQI=;
        b=h4H35ClwdVm/RxwJ2BREKYyuurqlfhVAGcdSbt/P8xYAkvpM3Ju78D1nXF5AAd0QiG
         lUCIt77c4+URkPO0mpbs6Tteqv4GQU+vPQbKQHbiWN7h3iSafNAbNe6/mIGrdhaRrO1F
         1OW7WtYLKru4NJrJ41DAJXmDr3FnkBsrwHBZDfIiTUAO9AwIY43FMiDGR4B8gW47//pu
         FA+yc+Siud89PNKv4h6DtXhEQlDwemOGP/yhw8bL7ntL4w7+I0FGNcF+cfaACH/hE2fJ
         len5LlC+WhBvhiTcRS8U/Z1soeYDKy9mTs4PPNppcL+dYcQHF/FpJ3l3Lq7Wj0HegWzI
         YBVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790153574; x=1790758374;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=aefF/PiYK1b4Z/D8ikpDUgUaGPgIxFbZ+BKtTsI/MQI=;
        b=jzHzjl0w4139GkTQShlNEP5F8vkvLWdQU+d7g3VhdjXj8O59Ye8JVYOQhKROAC78o0
         BsQmGKSJBdpciVF7zbslyqNpFC5pS/VT/4Bjc/n1tadjRslkf8HdZ5HnKr66xkDg8WHA
         xbqNkOhmqVNPEIEAHYeXQwaBGbqU/GpJTQQgYl2Mm3NaT/8SoCtzTEAr/Fr2XkvlpRMc
         rDUfI5tUzI9CVx7Hc20apCDAp56X46rxXmzi5zbP9PEgqCILybhZeUWvWgV8/xPXUsEK
         hYQVdp8Dwev/kXem4pZnl+mVh4TbuLkKX9xR4wYcFsOY4nUZhGxAwEEXBcJdjY8FUy4b
         9EMA==
X-Forwarded-Encrypted: i=1; AKwUvByVmJiZ/n6zeByD8QfYFJD0AChVS8j8LRxo3BFaAD+oFZM67NEm9NEoUAIER7xuv13XtVKKnqg=@lists.linux.dev
X-Gm-Message-State: AFuF++kMqgFmKnWJXQdqL6845z+e3o2kgo0qUU3ckxR+ZKslILVRICuN
	oVhNYJW5ZUiYhXTDcGja9XNMweSumKo6R3vPqfhdWPSOtvqb+n2fsIvAiUHyyiwvEQ==
X-Gm-Gg: AYBFou2zwaE14+9hX9Li+3enMJmh3BSk2YW021d70ZfUn1eeGT3Pfe0yUepw2rJudRD
	abGfXNz3bTSiIUgvqb+nlC0HFQAcW1Zgthi3ETENwdzq5fBl5ES786spXBrRAZnpis0/hJr11Nf
	pQk+/X5b/v1U+qPpAGik45TnLLsGJWURiklXXhCoBa/qExnYBkfibt8lH0j85KKm2bgNkyJUbSl
	afs626Ya2kN2O0ZkPmu0ygpGa/NbNvEJLLBYOffJnhi+Q0Puxn5rFWcw1tXlm0yDLFWlEXc9KnL
	CNl27pJSS730xRjQ46eOdB0zAS2G9TIZtlt0DgrCfHaUPp2AjrtYrirzyy64g7XsmVibfwQP4wi
	KE5RhbR9gKDd1XRTLZecLtRvy9YJE1RujSGNh5HzyK4BRdE6QEqVRCZjpyX71MNRys6J+Ufz6yP
	t7IcZiDnMPPfbnqTJr8Gu3wDnGdHbbUWrOGwm9cdWrEx931S5C81MYGE4aMy6eQclEhgxQrhaGi
	aMoJdVg+5kw/MtqfPXUcFd3nPcGdnW4QNcanx3KHg==
X-Received: by 2002:a05:600c:35c3:b0:49d:24e2:5454 with SMTP id 5b1f17b1804b1-49fe0c4a230mr735295e9.13.1790153574217;
        Wed, 23 Sep 2026 01:52:54 -0700 (PDT)
Received: from google.com (250.192.189.35.bc.googleusercontent.com. [35.189.192.250])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fde18a8a0sm60265885e9.5.2026.09.23.01.52.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 01:52:53 -0700 (PDT)
Date: Wed, 23 Sep 2026 08:52:49 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, iommu@lists.linux.dev,
	catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, joro@8bytes.org, jgg@ziepe.ca,
	mark.rutland@arm.com, qperret@google.com, tabba@google.com,
	vdonnefort@google.com, sebastianene@google.com, keirf@google.com
Subject: Re: [PATCH v8 00/25] KVM: arm64: SMMUv3 driver for pKVM (trap and
 emulate)
Message-ID: <arOTYREAT_JEyp9U@google.com>
References: <20260922131259.2975334-1-smostafa@google.com>
 <arLD1qj8E+tE2MYw@nvidia.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arLD1qj8E+tE2MYw@nvidia.com>

On Tue, Sep 22, 2026 at 11:07:18AM -0700, Nicolin Chen wrote:
> On Tue, Sep 22, 2026 at 01:12:33PM +0000, Mostafa Saleh wrote:
> > Notes about Sashiko
> > ===================
> > I ran Sashiko locally and it was helpful in discovering problems in
> > the series. However, it still shows large number of critical and high
> > severity issues, I went through them and I believe they are false
> > positives, mainly because (in the order of frequently reported):
> > - It doesn't understand WARNs are fatal in the hypervisor.
> > - It doesn't understand that a malicious host can DoS the system and
> >   pKVM doesn't guarantee availability
> > - It doesn't understand the SMMUv3 spec and makes stuff up (eg. about
> >   CMD_SYC CS field it makes up an non-existent encoding or wrong
> >   semantics for the gbpa register)
> 
> Just my two cents here:
> 
> From my experience, making commit messages or inline notes slightly
> clearer against the findings that Sashiko reported could simply help
> it understand things better and mute most of the false positives.
> 

I try to do that also, it helps to a certain level, then the code
becomes too verbose and the comments will be trivial :/


> Otherwise, the number of the findings is a bit scaring; reviewers
> would have to go through the long list of findings to check whether
> each of them fits into one of the false-positive categories :-/
> 

My strategy is to reply to Sashiko on the list to save reviewers time.
But my main concern was the large number of false positives might
discourage reviewers thinking there will be a newer version with
fixes.

> > - It seems to look at one patch at a time and not the whole series, and
> >   as the series is written in a way to be bisectable that confuses it.
> 
> Yea, that happens too. Usually I would add a line at the end of the
> commit message "a subsequent change will do X", which could clarify.

There were a lot of those when I ran locally. However the one on
sashiko.dev does better.

Thanks,
Mostafa

> 
> Nicolin
