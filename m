Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 847AC1A8409
	for <kvmarm@lists.linux.dev>; Fri,  3 Jan 2025 15:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735919281; cv=none; b=dSWFzac7e8AfXmdXvWxZYNnhz8ixGwXVR3+sllIDkc+nX0NSppHYptJSvhVpagxIU7bhCdyyp/Hh8YbXm8M0zhN7rc8zjC1gYEjEv1W/zTloIxTS8xNj2o6WRb3sv/iLohHpf2QiD4AHyTEImvvAf2xp5BW+3QzZ19xVQpw83RA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735919281; c=relaxed/simple;
	bh=x1YRhiBcjzePAFHkv66VCQ/BK2Y0AMCZi/UgyHe1DBM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z9jlWtG6pOpVYzy1mDvIyDdZ3RmIfC1DMNLn/q9a2DFsQGzi9XDyFIGKgiFfFeCF51tb6gktFbT4LtQbwszbviywXgb06Yf91tNzz3RjVsFvtAEVvJfEkNh1UE5whuFsFEFBZ55glHPb+fs8vdsisaNLpJrbX9B7cae9hS0m+Bk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=XM2X9T3z; arc=none smtp.client-ip=209.85.219.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="XM2X9T3z"
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-6d8fd060e27so89733096d6.1
        for <kvmarm@lists.linux.dev>; Fri, 03 Jan 2025 07:47:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1735919278; x=1736524078; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=x1YRhiBcjzePAFHkv66VCQ/BK2Y0AMCZi/UgyHe1DBM=;
        b=XM2X9T3ziwxKTI2VA5vWogy+pcZjpaXd1o+HT6yrIuDalHHaJmeJnFOcyTyJ2xj4/a
         LIoQIXE49JYF59hyvx+E1iEEVkjZu98kdBBjcK2wrQzVJLad9+2/q93dpDy+ZQl6fWT1
         I1IF58jQ9GiY6kROpL1oaeWYroAsTo+svUP+bE/4bPCajNOdGY5NPOBrtD8b9y+UTXNd
         M/RpEFk/LH3N8cE7UhMyCq8Ntb6zmMUdlTZpoc1IIWsYfON8svKz6tTg4zmp/L2idgFk
         Vhq1aZcLeOC4bOKs1Tv51fUAcH272LzS6liqdH8cZdA3KMLf62FjD1AaXLgtHsmWEvnJ
         SRBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735919278; x=1736524078;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x1YRhiBcjzePAFHkv66VCQ/BK2Y0AMCZi/UgyHe1DBM=;
        b=lF1v4XxWTlDcD5a1kbWyjTr35m9twSs+PFtNzBb9Lm8kFZJ7Wc7zu4PNjkFVVNx8TV
         7ivHHr361mFemQRGy/Et3H3ysZDBMTPjp1Lfo0fXbQ5Do99g3Ia08NQY5jyCVCXRkpsS
         bs3c5fiMcErIpH5ActLUSEIMGen0639wyu7wOz2O461fzcFpvYXXagPQ9SJwQVjyXjbv
         lgRWS0FDdkvPSLJsCS9u+HEFX/LkxhVznguBeQBfcxch1hTaAYSw3keGaMU7kbOxHY+Z
         QnwDLDrGmRWholWSPjPzXeg2FBoEMbOoASEk5Tnknog/Lby7SwJzkvtPyElOVqU47/jM
         Jixg==
X-Forwarded-Encrypted: i=1; AJvYcCXxuRMBSkM6ndxPz1Vz2zuH6ijRZ5sZ/CrBsPDd53/4yJpOa61gdHa8slm/KdSnVwmbaMV3FuY=@lists.linux.dev
X-Gm-Message-State: AOJu0YyA2PIbeH7FUcrEd0vMu/1b5r8Pbvo3YBFLg+M4IHVpHXf9Y3LK
	o5erjdwAoST+WfTpj8pwuVFvvUbkGeqIoLCJ+gSAJLUGbX9+GYBP+TJPfZ0BJis=
X-Gm-Gg: ASbGncsL+4ZLrQrY8uiZzLeIFreNwV6S7daPeIFjpcKxsotku9t4neMOwb6B6YgiuH0
	Jjtic+kHLour5/qMKtDiHNcV9CdGksHo5qm+hNPNAAwlR9fPdycfVITNovl5C3tcWPSdZf1I96J
	lhHyGJzAakOELjQlv+1jdFJC0TsJudegIWPVhAqfTgswS27lnap08CJTloDNyu/k/z6CtSz+1nr
	35JeQtmUnU2Ztim/ytk02WLNqT5L+6z3IHcei4FzqmcuNWYXw2UPdM90BAzUQh9soPUwXt/XIhA
	yfaoEo9UApSHZSCAcJ/u/991sEfraQ==
X-Google-Smtp-Source: AGHT+IHsMKKIkxQ7rcmRTm1VnxBXPwiUOd3sAui5NPCMrkirqlLHWMPVy74SUV1oTWvKIM353GCAdg==
X-Received: by 2002:a05:6214:1314:b0:6d9:2e0c:56c9 with SMTP id 6a1803df08f44-6dd23308374mr932119066d6.9.1735919278451;
        Fri, 03 Jan 2025 07:47:58 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-68-128-5.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.128.5])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6dd31faa052sm120006416d6.9.2025.01.03.07.47.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jan 2025 07:47:57 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1tTju1-00000000jEE-0Nuy;
	Fri, 03 Jan 2025 11:47:57 -0400
Date: Fri, 3 Jan 2025 11:47:57 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Mostafa Saleh <smostafa@google.com>
Cc: Robin Murphy <robin.murphy@arm.com>, iommu@lists.linux.dev,
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com,
	will@kernel.org, maz@kernel.org, oliver.upton@linux.dev,
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	robdclark@gmail.com, joro@8bytes.org, jean-philippe@linaro.org,
	nicolinc@nvidia.com, vdonnefort@google.com, qperret@google.com,
	tabba@google.com, danielmentz@google.com, tzukui@google.com
Subject: Re: [RFC PATCH v2 55/58] drivers/iommu: Add deferred map_sg
 operations
Message-ID: <20250103154757.GG26854@ziepe.ca>
References: <20241212180423.1578358-1-smostafa@google.com>
 <20241212180423.1578358-56-smostafa@google.com>
 <ce4c8db4-4895-426b-8d9d-97dc5d74fbc4@arm.com>
 <Z2Qshft8lQjI-x7c@google.com>
 <20250102201831.GB26854@ziepe.ca>
 <Z3gDuPe5C1Uj7y4m@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z3gDuPe5C1Uj7y4m@google.com>

On Fri, Jan 03, 2025 at 03:35:20PM +0000, Mostafa Saleh wrote:

> An alternative approach as Robin suggested, is to treat all iommu_map as sg map,
> and when the driver gets the iotlb_sync_map() call it can just issue the hypercall,
> however this call only provides the IOVA range, which requires extra work or locking
> as mentioned in the thread, and as Robin mentioned s390 doing something similar,
> I was highlighting that in their driver, this call only notifies the hypervisor
> about an IOVA and not an actual pv map as pKVM, so it much simpler in their case.

Oh, that is much clearer, maybe incorporate some of that into the
commit message.

We are going in a general direction of trying to make the fast dma
mapping path not require sg, so adding sg specific optimizations to
the low level driver is not good.

Batching the hypercalls in the gather and then flushing to execute the
batch seems more reasonable.

You could probably work on advancing this infrastructure separately
via virtio-iommu..

Jason
