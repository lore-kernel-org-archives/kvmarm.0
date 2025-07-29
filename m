Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A69A21C3C04
	for <kvmarm@lists.linux.dev>; Tue, 29 Jul 2025 09:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753782962; cv=none; b=jxa+8DsIJLVx3nVtsozpn1GWRKzNlGtiTHM/NjGh+xmOyP3bAT6GO5pqcsWm/PczTr0JC3hcZ0tUV84JqKt3YzpXbuatxoy4Xv3FWQ0/LlH5D1Ag10Xcf/gg6y6GKRTFIyY9G65kBZ+vKD8Wx4XCCGrOvTEAlYVfOkHBsRCyhGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753782962; c=relaxed/simple;
	bh=6J6O8lIPO8lPF6L2zLsyMC1bVxdBOnAwKLyRubhILW0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eavhvyM+pWvqMkv7r5agKqzNHZBlQ7SzBl9BF3Ikg48h6+WnOQ82Yjij75HaSwAspDrU4qSw/jDWvcA8pb1TKBZ9we8y9C+EOGI0qxVbog80sMeqDpbAg7w9eBbK/CTcvZeXTV3+6WQjdBZMPawmr3t5cVGliUjlK0loo+sOPoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=w+nCUqu6; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="w+nCUqu6"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4561b43de62so71285e9.0
        for <kvmarm@lists.linux.dev>; Tue, 29 Jul 2025 02:55:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753782958; x=1754387758; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=y8BeCJxT0E9y6LqcrNbSOsYh4JRswSE7zt76fN7xljQ=;
        b=w+nCUqu65Xxil6Ie+zqAw63dPVK5bf/4sEjm8SpBrZB6L2KH2weJtSKKwHnS5cYHJQ
         jUl8ytAWD1ISlirnsRMDKnPeVsTQkz6GsGEAP6VR6gu+gocXsQGbnFHTzxXw5uvGk3n7
         EjekMhEBL42wHJLiuk1jdSNu4SmdIp8rjmRZOcJy3raxiCwqXdn8kgPUyz63j07i23Hq
         XJJZjdhLyH7GmvHDqKCUIgu8HHOEOAZDGfn4CUOa7bjNqS6nuIef0dBcYTzd/EQyulh5
         eeoCCWSk34mSb7CSExZj5X2Ldc1Dz7Z0EBZcBeLWnI1UpjGa5elNLCR8VAYT2LRKco/e
         +yww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753782958; x=1754387758;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y8BeCJxT0E9y6LqcrNbSOsYh4JRswSE7zt76fN7xljQ=;
        b=I7gwgH7V2stMO5sFFA4skm5nbqw9RhNWQC3im3D1Cj4xt/FLoHOsb0IGnvTMGU15iE
         ETamc4lxuN5RhXrGfFYrq/83/i4Pn9oTvU92hNBsk53oGwUpDo213nH3oJ51HnXxSG5j
         JPKPJC/WWrE+V9EEPu5/AIgUoBQx32rDaoSvsTyNxMmTnj7IfNPAHY8pWaI47dngeLMl
         hoYLNfPEiSKwOdCWFjjPVnMpN094rAdhWowszsslCTFJbXUXRzrbGm+oGoqF7cCZVmKk
         0qCGvoVZsQeccMKq1LQBWq2kaQVZSjk1l1sc/sCLq+LhPcyHq/GKzw8UE/oGqgS+8Ujw
         xWvw==
X-Forwarded-Encrypted: i=1; AJvYcCW+tkXIdp4oQm+HZK0QQnf4wlyu2w5uVSeWvnqvyuM6STRX0NP3H4x+4elYexApF68SzrzA3c8=@lists.linux.dev
X-Gm-Message-State: AOJu0Yybom15g9cZFBWmEFwBX9qqaiASTA4PwQyB8ahPzkRMpZWg8FVG
	Z1dbOdVz3dsXZ6QcACuOmU5BFWitPABNYdQ2iJ0KXJqL443KmIKTBccbRzqHpRxu3w==
X-Gm-Gg: ASbGncutqqof691GnqdZ9R0B0axTBU0aR7UH8YpA1+vG3LZfxhXeuSzYZUf3WMwujuP
	VzmKhoUXLRBRNvOfmMYKeG0jPWKgQdbUX1snSEB2+rZJpSeYipZK7NUuHfHZRpTARxXBGJrO+AL
	dMlo2t6jMydRjweMECu1nJD55whQ+v/rwX+gYodtCIlunEUG41NOjWbdnBEYN6xOwAddvxu74r3
	aXYyV/HIvjAOHKge/glqOb4KpdUWcN+feHMIRszWclOaXuGD82NFSfUi2W7zFbA6VltvlRbt2ZG
	UdQDaFmt5teuVRpdwGAAUDSotFF2HJDNgtshlRCoWOuBgVtHJbkec+AhyEQODYjO1xYL2pXIyvK
	1wwVre35GiKygdw08Ui4pG3YqffKcwf8557dQTlPawSYfhjYi2aa1T/TfgSHA
X-Google-Smtp-Source: AGHT+IGzES6hqfjR1ngn6YMh6m2QMnuLZqGDQbq8stqciYuYMIFTwvOmpG+4EtUrCFw2V/nQTG/heg==
X-Received: by 2002:a05:600d:17:b0:453:6133:2e96 with SMTP id 5b1f17b1804b1-4588d58f585mr1058175e9.0.1753782957791;
        Tue, 29 Jul 2025 02:55:57 -0700 (PDT)
Received: from google.com (232.38.195.35.bc.googleusercontent.com. [35.195.38.232])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4588e33f8a2sm19702345e9.0.2025.07.29.02.55.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Jul 2025 02:55:57 -0700 (PDT)
Date: Tue, 29 Jul 2025 09:55:53 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
	maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, robin.murphy@arm.com,
	jean-philippe@linaro.org, qperret@google.com, tabba@google.com,
	jgg@ziepe.ca, mark.rutland@arm.com, praan@google.com
Subject: Re: [PATCH v3 20/29] iommu/arm-smmu-v3-kvm: Setup command queue
Message-ID: <aIiaqSVtSpX7hr8i@google.com>
References: <20250728175316.3706196-1-smostafa@google.com>
 <20250728175316.3706196-21-smostafa@google.com>
 <c8da60f6-4083-4aac-b921-d57b767fa895@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c8da60f6-4083-4aac-b921-d57b767fa895@kernel.org>

On Tue, Jul 29, 2025 at 08:44:03AM +0200, Krzysztof Kozlowski wrote:
> On 28/07/2025 19:53, Mostafa Saleh wrote:
> > Map the command queue allocated by the host into the hypervisor address
> > space. When the host mappings are finalized, the queue is unmapped from
> > the host.
> > 
> > Signed-off-by: Mostafa Saleh <smostafa@google.com>
> > Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
> 
> 
> Your SoB must be the last one.

I see, thanks for pointing it out.

Thanks,
Mostafa

> 
> 
> Best regards,
> Krzysztof
