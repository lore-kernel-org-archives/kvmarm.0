Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64140189
	for <kvmarm@lists.linux.dev>; Tue, 23 Sep 2025 17:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758649534; cv=none; b=Y6LBXRZQx+4CrFA6mVxW+sA8PurMPswUTefsoCLon81Yp43N0/XVIcSlcEPeNNjy1RGQj1jB4/vEJ1fXDspLPt9EwDXMNcyURZWUMdWd1xFivycKnxh0zr1hXou1POuxvX3t9oVAtgBusvdiIvHHGJXx8WASQJjW9RirU+icEB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758649534; c=relaxed/simple;
	bh=nKAZfoAjOKM9CWFiJ6E1W5BaQQoUhnD1jwF7C/Ohzg8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gWcaPMDtFKoIwdmHLqEX+BlqeSw2Hc3nUIbduHTJ4Thd5crj86oL7KcXXBxZ7RmCVtWSDXCFHcxjvvPXd55gQoFGyGRpNGbgDT+shuvcLzDVIyPmbzwqA4brMfbBgcyQ0NuUcUXYaNBkZJ6mgfjw3cJHqvNgSZe2Vzlo7nYKxRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=B9LiQvQF; arc=none smtp.client-ip=209.85.222.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="B9LiQvQF"
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-84b9484c061so230272885a.3
        for <kvmarm@lists.linux.dev>; Tue, 23 Sep 2025 10:45:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1758649531; x=1759254331; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ZBIJqbmEZbrWURHaKZlCYT/zn1TgwW+8+aRFRZatnkY=;
        b=B9LiQvQFhJpb7jWLz4oyluF4OxY0RyXzlFYmEw/fJHum5glkC7EA7GLfni58O5bVCE
         4vxvatzkUCj8VwJ9WYczds9dE4ZihxHnWUOrZw0lQK6a9QN0K5enLVufree4PPgDLjMQ
         4JCnMn8UggR0lWJss6wkymVgZvdg99E3Matlj75w03AbDumiTvSIdET8g6wqv+d/4oS7
         ZNuoK9Ov9soQxZvrLJTdxv+yM6HBydU22d07dEGX+uMVLk0u4/HW9FirxBl3WyxRrFWp
         lCXj1vkWLVmeL5aPQqJrLloA3bt71yDNzojwU9O4hQ4Lq7cBikr8NB32yyatrx/OLztK
         bM7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758649531; x=1759254331;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZBIJqbmEZbrWURHaKZlCYT/zn1TgwW+8+aRFRZatnkY=;
        b=KNChpofi1z1Uf1UvR7DC/T4BWJZQ0Sp1GJOHY835OvJZ5HpAfkYSPx7lSdCf7qH+QQ
         pq+NM49KoX2lRuOYqo5wbcGZPC0JTf5vk0MrtwhMWSwlfsN7ZYKk+P9pqkaDDqA44pQe
         JukKjakyDQaja+Ppc67uG9MgxrasOrFhza1XWHdwyZO5VAFhpJuAvCi+u2de5z7j2QXL
         xvFRtZRDoj337Pc+/P0+ykLh3dQ5ffuUExB/Bc4+sSguBiJsSzv4W7SrbkdHekC/gg45
         Rybm+7RodbK7ZKXJG400+XhJsN/X1idjzh6zr0IhvifYXlWTq/rIhS/qyEXL6PM19mfZ
         lG5Q==
X-Forwarded-Encrypted: i=1; AJvYcCWothcX6gqHJmmoRqIMsKGILpHeuHX5iPvUEJH/qEgjuiIr2jI90v2tjXEkHgPu7WQFq7XASd0=@lists.linux.dev
X-Gm-Message-State: AOJu0YzLJ8VnmshOSdtqPZdU6TtT/gYvrGtZQslN8DzjbG2Lay4e8I7W
	1F+dRIuOjags24Xoiijfe0K1hZCwbX+UnTtx/Mz7aNzyn9sH4Iq4nRjpmXl6gWG3tc43WzrpL9V
	hnrdq
X-Gm-Gg: ASbGncvliVkYSzCN2IVfCPp1ULcuTGX7mTqqv9OmiFqJlI/LfF+sjCULQkFkB9fN2Y3
	TFmp0hV1cphisDt1CUX6fN8w+NXQRjwXa8Xfm2/phdECDiO0BQ8yRaptq+8Ms26VXnNKWUGOPzE
	FCOvc5MzAgy/BiMimmJlTaHkVKxNbk+PlDJFc5OzUI8yvxQz714La+Zlej02XGEieYadkqs/bDd
	jgYJ9m3Pe2R9Ng7ROzyN4rnLKlYgCPgvB+GV6AwnrKNev1nzU3pXlRWcexu61umRNw9aCE1UyS4
	A7O7U/FmN12/P0wfAWzx3poLy6BhqzUghjmG2pRgByCjshwSgritDEVdoOUgETSORVT0UBnV
X-Google-Smtp-Source: AGHT+IEiUq4ZNiIQ/kvtshlpB8TY+qUCVv3sM7ttZqsjKZyYCVp5SpveErcNASTGPSdrjl/Eyj3Y1g==
X-Received: by 2002:a05:6870:15ca:b0:32f:ec51:a716 with SMTP id 586e51a60fabf-34c83545b23mr2456188fac.29.1758649088337;
        Tue, 23 Sep 2025 10:38:08 -0700 (PDT)
Received: from ziepe.ca ([130.41.10.202])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-336e3af73f5sm9720934fac.6.2025.09.23.10.38.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Sep 2025 10:38:07 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1v16xq-0000000AySS-4AaP;
	Tue, 23 Sep 2025 14:38:07 -0300
Date: Tue, 23 Sep 2025 14:38:06 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Mostafa Saleh <smostafa@google.com>
Cc: Will Deacon <will@kernel.org>, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	iommu@lists.linux.dev, maz@kernel.org, oliver.upton@linux.dev,
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, robin.murphy@arm.com,
	jean-philippe@linaro.org, qperret@google.com, tabba@google.com,
	mark.rutland@arm.com, praan@google.com
Subject: Re: [PATCH v4 15/28] iommu/arm-smmu-v3: Load the driver later in KVM
 mode
Message-ID: <20250923173806.GF2547959@ziepe.ca>
References: <20250819215156.2494305-1-smostafa@google.com>
 <20250819215156.2494305-16-smostafa@google.com>
 <aMQmA9cLaeYWG5_C@willie-the-truck>
 <aNKwROPzDCWgJBGQ@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aNKwROPzDCWgJBGQ@google.com>

On Tue, Sep 23, 2025 at 02:35:48PM +0000, Mostafa Saleh wrote:
> If we really want to avoid the current approach, we can keep deferring probe,
> until a check for a new flag set from “finalize_pkvm” which is called
> unconditionally of KVM state.

I still think the pkvm drivers should be bound to some special pkvm
device_driver and the driver core should handle all this special
dancing:
 - Wait for pkvm to decide if it will start or not
 - Claim a device for pkvm and make it visible in some generic way,eg
   in sysfs
 - Fall back to using the normal driver once we conclude pkvm won't
   run.

It sounds like a pain to open code all this logic in every pkvm
driver? How many do you have?

Jason
