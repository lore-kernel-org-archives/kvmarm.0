Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29647211276
	for <kvmarm@lists.linux.dev>; Fri,  7 Mar 2025 11:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741347322; cv=none; b=AbuSJMBWNyGWwMHaC5VdijtsJUSmjt+DLShdtAtFs+g8Ic6oloDVsw/pzxd795nIoK9X6SYEDOnAe/kZNhjHFZe1Wf93s2w9cWmZsVMXby+ZwEYmTPRU2Ljf3NTD5e3QicR5o7uTyvy1Nwmuop6f53hwDxL+slPswl6rDnhNFtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741347322; c=relaxed/simple;
	bh=IoVuQEdepfRvzlxrsClyF2IYX1axCE/yG9AQE63tqvk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bJf3DSAoidUd146IxVmMRR523bhPekIKvw5DEEwgmYXEfeveh3P1KQxndOReArfQFJQzISk5dILeR2KWeGgvX9icNgNJPc+qeJ1CESPvFODHIyGwCDSPEAvqOuHefXi1JT8T9tLsheuT1DfdtV6muQpEecAull65lbBLhrgvE0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hdNo69VN; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hdNo69VN"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-43bccfa7b89so14415275e9.2
        for <kvmarm@lists.linux.dev>; Fri, 07 Mar 2025 03:35:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741347318; x=1741952118; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=BNAp1guL3DdfnvorYMboaljiCgvGEgEmNmgxMM62RUY=;
        b=hdNo69VNeIxDIduk27DNGpojo50ku+TRvEPVcGpsR3hiq//JeLk4prA9ikG69bBE8M
         btMD3v/DuvXrPxln44VMCLKiVdhNifa77sDIluymLV/qvp0ZrNzgPjyjB9QkBwx+0t4R
         MAFZJafceXlqICwnd91utHM+4o42ui2WjxgcahlSOAgfFKkGd8v0fwG+u5xP1qEUfX+Y
         4XQPsqalmeRbGKFjw1BsjZWdwAatYJDh2hIVbUzjvyg0MjzpJRrsOd3ZyhaZJQQ2e6om
         Txe1MoUzvOEH3PnL/m/NhpPn1qvdadoDHYVuTu6L+/fihJ2FcuP3WZh1lVNTnUk6HfuO
         du9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741347318; x=1741952118;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BNAp1guL3DdfnvorYMboaljiCgvGEgEmNmgxMM62RUY=;
        b=ZKL/AyKHN0vR5lxjUJ8rEfjtdMMm1+Dgz1j2xdskH2ihmN22F8fe75VSubT6lKOgul
         PCgXECECFblxePW13qBjzq+bVkqNnYnP8WwSeMcSkbDeu+dm4H/4yf0/AC1oUcgN1F67
         VU5v06mskGEhRj7qf/lPOJzdTVPZZu3r1AqeKBiKl3FUfJMdHmMwi6xswOKp60XjMeeY
         uGPJ0G97OL8l3TsBsMQB5PHIYxHxuMauDvKSh9lNCmNeHRJeXw9dYMCsH/aHWt3EeIi9
         VDm0whcsyRZL/C4GU0tiKtcgxJG5n4nAbIrubJHH1NB2woPmOo8K8JnKLZP/D3YH+kCK
         64Mw==
X-Forwarded-Encrypted: i=1; AJvYcCWmoTY1yHMKwmDXXIUSrPgcXM/2t6vUOhvKIwqAflfUO/TFez2K+HFIkGwCiSIFdZ1qCStwDyI=@lists.linux.dev
X-Gm-Message-State: AOJu0YwKjh6tZPrlcus7WFiXMBaZ99oOQrFmYvvd4GSM0UrPuE7pkG8l
	fZTRcDZEWFKZjGvlYxSMtxeLZrMwwknIgZvgEXvjWHf5W1OfUIsddynF2I9Y3w==
X-Gm-Gg: ASbGnctllC8fz+GfuLWfog0xX4Ud5aaAIj+goZSXWu9aSIkeu2bGG+KsX0V/M5xbMBy
	tKoZzXGznEFDAcdt7zpCPOCybGsXygDhgNr97BWuBSkbsTx75oXudbm4m5HEKVDHLIpkIPOrOgn
	5czrqwO+37xWTMDpcExuf1ypatvPvKmw+yttnnmtNqcUxXCX66h8928GnF6WjACEvcZVEhfRdAW
	u2yl1O9NWupWmxIdf+wFP9vp74T26IeJaV0db4XvYYqAvek6syi3Eo2sgUjTyZdgNO/sxjRGy+e
	qFYWGz/Y8GWItFhR4TVeGDgzRVuYdGYJxbcndEFUtI39gyzE9xgfEhG1AEVuWnQE+3GVKMEU7SY
	sJaZtWDfGJF7W
X-Google-Smtp-Source: AGHT+IGjS32YvEDJ0dggC62JcymX/iPFtuS61I6Hr817oYxnTdUEtKfb2H4jSY7/r9bkym5Nc7UyVQ==
X-Received: by 2002:a05:600c:1c92:b0:43b:c284:5bc2 with SMTP id 5b1f17b1804b1-43c54a13899mr24034885e9.0.1741347318291;
        Fri, 07 Mar 2025 03:35:18 -0800 (PST)
Received: from google.com (105.168.195.35.bc.googleusercontent.com. [35.195.168.105])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3912c01957csm5051720f8f.47.2025.03.07.03.35.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Mar 2025 03:35:17 -0800 (PST)
Date: Fri, 7 Mar 2025 11:35:13 +0000
From: Vincent Donnefort <vdonnefort@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: maz@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org,
	qperret@google.com, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org,
	kernel-team@android.com
Subject: Re: [PATCH v2 1/3] KVM: arm64: Add flags to kvm_hyp_memcache
Message-ID: <Z8rZ8bBnSllaZCEs@google.com>
References: <20250304134347.369854-1-vdonnefort@google.com>
 <20250304134347.369854-2-vdonnefort@google.com>
 <Z8qeIPfTOJU6w_8l@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z8qeIPfTOJU6w_8l@linux.dev>

On Thu, Mar 06, 2025 at 11:20:00PM -0800, Oliver Upton wrote:
> Hi Vincent,
> 
> On Tue, Mar 04, 2025 at 01:43:44PM +0000, Vincent Donnefort wrote:
> > Add flags to kvm_hyp_memcache and propagate them up to the allocation
> > and free callbacks. This will later allow to account for memory, based
> > on the memcache configuration.
> 
> It seems slightly more obvious to me if we pass a pointer to the
> memcache instead, but that's just a minor nit.

That sounds good!

> 
> Unless you have a preference on this, I can change it when I apply the
> patch.

I have just sent a v3 to save you the trouble.

> 
> Thanks,
> Oliver
