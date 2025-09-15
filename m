Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDB4E284684
	for <kvmarm@lists.linux.dev>; Mon, 15 Sep 2025 16:45:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757954722; cv=none; b=NwgeZrrYpWvdbN1vTbw9+BcVjVxW5vzWoIrdgvqoOuonLUJ6t7bj59YQ4DZ5UnyX92O/B0Fa/XoIIpHrbRAm/2UKndoewzk0x8U2LDDxWXbIbpONYXjtm6/VxH48/iDR8Hw9W2MhZoCTWQ8vOQBSWj/aIQ6a4CdsQCVGz7KH1TQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757954722; c=relaxed/simple;
	bh=vkx6SM9gqmpLvlgtVI8pwEBIHZtD0Q9irwN6qy/aYaQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FyMbIBDY2Sr7hyyRu3ohQLloXy+4R9x1+wOP9HghKuH2oxr8SwW53vEEpctozJOWGcnMz9Yl7Q8bTwBIwJULWB0++CVGjvXWOUH2faDSPtiXBgjMi3f8t3m5BIc/O6gZ2aVPwkoPHP2+1Rm9U/Q9ZCUc+VCtQuHdn/HeeUmebaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=VxoQA76n; arc=none smtp.client-ip=209.85.215.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="VxoQA76n"
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-b54dd647edcso12820a12.1
        for <kvmarm@lists.linux.dev>; Mon, 15 Sep 2025 09:45:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1757954719; x=1758559519; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MQDjqbiT9oGuFNrzjLvyS3Lnpn5E/CxPnw6kf2pPIuk=;
        b=VxoQA76nsIo/f91Aklk+FZzSoWss2B/LtZzctMqFuC0nvFQk1vQ7wzgdyQQog98Ou9
         rBaXqECR7D6JrGI8ZBqBg/PGAL9UXaI7l2+lSHgzLQGHJacOdUyBXbBasT6WXbGsPjki
         /8hIRGq+FduCB98M3Xm8kDmsOkY0X4HaVYnMQWmPyB36/9wiZK4fUtvqyQf4NgT5k+Vd
         XnFxtwUWYXlhMfWBO0BXeRpWKPc15Si2ek3uGBEJ56J6GCk/jeRxh8nMswgaJ0feSYBE
         dPJGR+T3LF22xqkgQADDSCsxheGp5VomyU8TqdfKBqY4jQmRqhCFDiIIoAEs7lTcUT2e
         1m+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757954719; x=1758559519;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MQDjqbiT9oGuFNrzjLvyS3Lnpn5E/CxPnw6kf2pPIuk=;
        b=WZkvhgJztmLO5+dBAHTCc5SYia/IP98JG6N14NZpM1ig0Q55r4ShLvHYO88ciXirbb
         61+HM7zVWWb5iWMCAMrH09gVY+gxQw4Chc+Iq/Unh56OJIbvtJuFfWI6jotB3V4EF/Bu
         SZn0GT48pVDFXvzjRNUUuLESa7Jwd1rNgC6y2H7auJHdqlVwq7uL/5tEKU0MaqtfL/hw
         G8/xyqtK0Gnpq4UnNPsRcgZbtIa0Y3W1wcBQeQMA3P2JBw8uOJUBhUM0yLx50XfrXUxo
         zwqZcML8MSsYoHZe4NgQFLCitbYeNVKuu7PXMRGDjtM8rzqMq2oXCsVkz99pwy+Kmfns
         jXHg==
X-Forwarded-Encrypted: i=1; AJvYcCVRWOOG+WnP8d5T7FHS9mhNHvxKFqNKabqMfxUwrBjJJSi8CnTvpAuRR/DSCEIsc9dII1yQCps=@lists.linux.dev
X-Gm-Message-State: AOJu0YwqAcdMgnX8YUCcAp7N+K42bTJtoEBwtOwJDx4Po9lCtvEHuFKk
	AP65N3l8I0HEQ57QkugvMdebozKVBjKcPOFXtUwldIvRWQ2dO1uQTvpBm/She/OZTn4=
X-Gm-Gg: ASbGncvWBzMbUR4JK0P4c+MGWaDqt8h1eKnS01+i+47xYPk3ly6BUY1u2QB+gpXDMAs
	9ULgKAXIBt9c3warnbWkJgmgyVkwbD+bbUBUt3r13isoqQw3BpSwvl7n02YFFtEm6pzpJCxHQUX
	Q7GBwp8Gq+IDTMXrrj6ge3NPkW5DUlVLSIjBBVuZoA8PjfiQ45C5+8jcZneAkVh8ZsZgMoK0728
	XElEtTfg/ItrVK+QiSgC6H26OOrZQ5HyDiSS3aI9NA/ywEEFTsgsxY7mUNwZ4eNOiTc7yETN3Mv
	4JOfOYKK/EQd1GxNClook+oIFNaGZU8xrITGqK8mjuomPcoOfmxbAdb51v3jnvF9YUsq8kOA
X-Google-Smtp-Source: AGHT+IEueZRPYz6Ovwnbpjg7oIfp7yjCHZ9L0M0q/iZt1RonHcNLG+PurDsqJLquezOzfjlKgS1iDA==
X-Received: by 2002:a17:90b:3d0e:b0:32b:ab1f:5113 with SMTP id 98e67ed59e1d1-32de4f7ee8fmr16124999a91.28.1757954719094;
        Mon, 15 Sep 2025 09:45:19 -0700 (PDT)
Received: from ziepe.ca ([130.41.10.202])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b54a3aa1a22sm12075579a12.52.2025.09.15.09.45.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Sep 2025 09:45:18 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1uyCKL-00000004TKd-1naj;
	Mon, 15 Sep 2025 13:45:17 -0300
Date: Mon, 15 Sep 2025 13:45:17 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Mostafa Saleh <smostafa@google.com>
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
	maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, robin.murphy@arm.com,
	jean-philippe@linaro.org, qperret@google.com, tabba@google.com,
	mark.rutland@arm.com, praan@google.com
Subject: Re: [PATCH v4 04/28] iommu/io-pgtable-arm: Move selftests to a
 separate file
Message-ID: <20250915164517.GL882933@ziepe.ca>
References: <20250819215156.2494305-1-smostafa@google.com>
 <20250819215156.2494305-5-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250819215156.2494305-5-smostafa@google.com>

On Tue, Aug 19, 2025 at 09:51:32PM +0000, Mostafa Saleh wrote:
> Soon, io-pgtable-arm.c will be compiled as part of the KVM/arm64
> in the hypervisor object, which doesn't have many of the kernel APIs,
> as faux devices, printk...
> 
> We would need to factor this things outside of this file, this patch
> moves the selftests outside, which remove many of the kernel
> dependencies, which also is not needed by the hypervisor.
> Create io-pgtable-arm-kernel.c for that, and in the next patch
> the rest of the code is factored out.

Please send this as a stand alone patch, it looks like a good idea.

Also please add the boiler plate to wrap the selftest into a kunit and
use the usual kunit machinery. We alredy have an kunit for
smmuv3, it can just add another file to that.

Jason
