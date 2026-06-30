Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EF403E2AD6
	for <kvmarm@lists.linux.dev>; Tue, 30 Jun 2026 10:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782814987; cv=none; b=pHLUk4ePEyshV52kKaQuI1Ehe7HeFOHnD43ThqNCvTaql1smCS9BDfvgT/uXfJ84mkEQ4l9HDpL/34otEEEY0bVrzCimHUyaow7RIB8joTvsOqcvL9kF06T5x6wB1DN1HxTEXTpJZL+qoStq39AgGcMxUJtlIMnluQciUlQf8rk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782814987; c=relaxed/simple;
	bh=xO1vPXr6jVIbv3ACOnD7BWtFjQzhqCaDlWJshtXaouc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mKnT99xkVp74xBSk1FWX2wpuojCdfVqvuIozLIz/8Yu8vIxw3MAL4bT/x67VleUw/k6drh8yqXpmsurcWXgkMwux7hkSAHyXC0BywZe04Hce0ZpsXdMGjHSvROVApp+CvSz6ETsx5vrl/UH+JzPvZgvg+83zfaIErFIU86Ys8TI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GIyOID5p; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GIyOID5p"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-493b8d92a4eso33875e9.1
        for <kvmarm@lists.linux.dev>; Tue, 30 Jun 2026 03:23:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782814984; x=1783419784; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=7eQrlr1iqvdXSCnGA9eKw5Pz71hnIxvtQ5reJnEwINc=;
        b=GIyOID5pNED4nRK8hqKIgIP8eUCd49MTRHGyWMDZvpndrFOebnysPy8rjRaYT4PIGE
         zk/OBKqKbFw93TA2cMVy6Saro6eP8x7iHeFfXkcBDV8w6Psr95iW2u0jW/d9ZNgMNYEC
         AH0OSsKAOCpCmb24T86M1XW7n3SbAGyBw4W5nRa9OWJaSjQACT0wNoyf21D/RJ1eQp+g
         fHryQIgdd4Z0l8d4bcNYbnismt1oozD+aEDKnLtE+G5It8BupWTjVPPfKSvsly4BWjqQ
         Ne+LF2NJHnLRd0jSjQhNPAk379Veak3G5dFKBnsGhcmoU0uSkRqqEBXQvSzPDmZrmA6D
         tIyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782814984; x=1783419784;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7eQrlr1iqvdXSCnGA9eKw5Pz71hnIxvtQ5reJnEwINc=;
        b=RKrLspKTiWD8hR0otNVhugD4c6LKPSz9loDx/zKrbECMhjDCzUHgpPJiofdM4Jr8UV
         QCTFMPuXiUWrmPjLZKFlgUo6CrOe5RcGdfRtFfcTa7K1/ERK8uLa/wHCwGzcooinnOdL
         pJMSqXmVYvLtfQtf+gwfxjxVmjfS6xOyYz/hITJX7Hl/sBHxotJ7q6VwcF+N5afSIOFv
         1247OYdiKP8QIixYYnB2SLIW9utEiBF048cD8g+KvgdjIWYXoOudTMpRz9EYGpz27315
         XbM3cv+K/dPiT4tPwGDr6BX/cVDIiepi9VdHRXdcneAQ1JXx7mxayQg6ONqOUhT4hlRJ
         1Z1w==
X-Forwarded-Encrypted: i=1; AFNElJ+CPo2lyNXpsUDpye+BjJhF14ZaGzTdzUXYXlxet/fq1kzoxJED8ljPBrkfe9+h1lXEWmHLgzk=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxyqy9WgV325ku0NQlUNs9h4/Xw++NYkSXDo9xckbHlT08PGQz9
	j4F1ipb64qbmVgsd2u6aba32nz2e2hhyFexJ0OYIEgv4neNfu3vsEwU0XF9Vz678ZA==
X-Gm-Gg: AfdE7ckFmWnPuj8LYAhiQpaCmSVY7ZBubgqgfAA201qfuUS3IPgKyflq32lOe6PCXFa
	KmDp/XEqu7sn2oHQ1vIeNPQjjFNAEY5hYrqJ0F1Rl9BNE2FSU/Sm+GyyawIlaOnDj5Wd+fPCs3U
	qz/713/Z3BLkgu0mF9aPUrLREeuKkuXJY4fcSpGPindWkbxSWcbgRtEAHS0gvCp/EJTfoPREs9Y
	RS1fY6DXNZu7miaSlHnepmQJQ5l8xnE/UfNuhsM2BjRWtZ+HIXgUw974e1aZF1rs7EPeB6gCvM9
	E3hyuFb7GhpUhXuoE7oAGmTpmqeXx7OCZUEb77E6jdNMPksownzrKux5ZsX9lHU5KvwzMPE8zbA
	7GSgt+k9e2KHDqJLtc55JVcn3rtRy8ZgjSCAl/ivV2xqwAeKasqntXsSN8HVBKUU4FlpEMBQd2p
	LWdH5O+7bDcZRkMRMArR9QKaiEAb/bAssspSNvUQMBYT2N3RZSR/uJ6rmx6EHwGQ==
X-Received: by 2002:a05:600c:4314:b0:493:b86f:c913 with SMTP id 5b1f17b1804b1-493bd77921amr14605e9.1.1782814984019;
        Tue, 30 Jun 2026 03:23:04 -0700 (PDT)
Received: from google.com (140.240.76.34.bc.googleusercontent.com. [34.76.240.140])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493b8cd8bccsm63196105e9.8.2026.06.30.03.23.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2026 03:23:03 -0700 (PDT)
Date: Tue, 30 Jun 2026 10:22:59 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Sebastian Ene <sebastianene@google.com>
Cc: Vincent Donnefort <vdonnefort@google.com>, catalin.marinas@arm.com,
	oupton@kernel.org, sudeep.holla@kernel.org, will@kernel.org,
	jens.wiklander@linaro.org, joey.gouly@arm.com,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, android-kvm@google.com,
	maz@kernel.org, mrigendra.chaubey@gmail.com,
	op-tee@lists.trustedfirmware.org, perlarsen@google.com,
	seiden@linux.ibm.com, sumit.garg@kernel.org, suzuki.poulose@arm.com,
	yuzenghui@huawei.com
Subject: Re: [PATCH v7 6/7] KVM: arm64: Ensure FFA ranges are page aligned
Message-ID: <akOZAwBn0JkbyzX4@google.com>
References: <20260617145130.3729015-1-sebastianene@google.com>
 <20260617145130.3729015-7-sebastianene@google.com>
 <ajQmN-UQD3uJJddJ@google.com>
 <akORop8Z9Levu9Sr@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <akORop8Z9Levu9Sr@google.com>

> Hey Vincent,
> 
> > I failed to parse this 
> > 
> > But I see 
> > 
> > /* The base IPA of the constituent memory region, aligned to 4 kiB */ 
> > 
> > So it sounds fair to prevent oversharing when PAGE_SIZE > 4KiB
> > 
> 
> I think the problem is when you have a mismatch between FFA_PAGE_SIZE
> and the system PAGE_SIZE. We expect a fixed FFA_PAGE_SIZE of 4kb and
> this is enforced by :
> https://elixir.bootlin.com/linux/v7.1.2/source/arch/arm64/kvm/hyp/nvhe/ffa.c#L761
> 
> if FFA_PAGE_SIZE = 4kb and PAGE_SIZE = 16kb you can end up annotating more pages with FF-A then
> needed when the range->address is unaligned.
> 
> It took me a while to understand this so I guess it is better to rephrase the commit msg.

The problem here is that we only check alignment for size and not
the address.
And the code later (__pkvm_host_unshare_ffa()) uses pfn which
truncates the extra bits.
So, in case we have an unaligned address and an aligned the size, it
will round down the address while the actual size spans an extra page.

For example if base = 0xFFF and size = 0x1000. pKVM will share
(0-0x1000) while the actual range spans till 0x1FFF causing FFA
to access an extra page that was not shared by pKVM.

Thanks,
Mostafa


