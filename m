Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00AE028CF79
	for <kvmarm@lists.linux.dev>; Fri,  1 Aug 2025 18:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754074774; cv=none; b=JqRoBRB+FGNpdEIux64Y2MI6BVKTxHkVZg3XEqFAb0asXDHqw2QeY05s2l55fH2PSKdDeSPCgajDL9zLn2K30hCJvnxBLSS7EQaEN3LHxOQDKMyZy2ysfnuYKm7GipuoVHlsWv0wfgdj2orfD2cMpED0p9WG6dY2Rtak+F35nsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754074774; c=relaxed/simple;
	bh=ZCus/7TYCpdBpSHkNX8J3JFdhNbHBG34XLdpJYdbpIQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RKkpGCp/ZTDHqmDABFOyXIvUcWPU5OoGpRIwTSpDXqZujqMFybltHyr11jpmb+IbSmPDItOg6m000LzEnD3v3MbXnjYq4L6xeO/Xjjf2YwqIPJ0gK+A2Z0V6LjGgcr6fFlfzUlva+E+09OtzVdYTr6b818tCB0DyOFeTtjh9osM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=WBn0PiQg; arc=none smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="WBn0PiQg"
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-4aeea691687so13754241cf.1
        for <kvmarm@lists.linux.dev>; Fri, 01 Aug 2025 11:59:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1754074772; x=1754679572; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=AyIY9+7qRYH18QG3yHqvpWY8fQNePxyU0Y1cLmmOWtc=;
        b=WBn0PiQgZniBXhNPZqC8wShHxgEgzYqWEbDyCsO0Z7dT1zIJF6UEeUzzvHByHqxMSd
         Bh9gi2gbBO07hYEJn0WqPCkZBaiA6yhQL+5XXaYXqPISOhKQynondEM/S8+AnQNwf5GG
         T6Ou8cjsvlfF4dSRLFFEzqBPxkVCcGWzrEtuhOqt5yDCua+02h0XIAxhcE0A7BqqXgeS
         Xo5UTXKtJaX9SuyIIKnJ580QASlpQqdAGIj3bugUYb4DZIrCgOxUO66g01MOTP+uGMKh
         EZ2byuVaEkv5iwofKIA4UFdCsz1C+6FB/54aK+qhDw7DLS75T6nugtAVq8pqBFgxDO2N
         Knsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754074772; x=1754679572;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AyIY9+7qRYH18QG3yHqvpWY8fQNePxyU0Y1cLmmOWtc=;
        b=PKvtu5SQor1e3QPM4xUNXcwfYO/Nx2NRSbJ2vsBBNE+gtthru+Ld6UOtlJNTSaMypv
         xb3ZMopljlpR6fFNb/O7PbCteAE4L0pfyUoGiCOuMHkP+yGzUyLIfxpt/q+YmFYTiDRT
         hp5FiDdXjOQvfFbOskax71emQadogyrtXX3A8vHKf8Iey37tq2wa7MTYj+kaNzPhTTD0
         M86S5TD/NNp+zstP3XhJaYhScxL0POLKjNvZYeG2EbE4G1G8zm/WDU7V/LEBTSSrcpEn
         frhzfTYKPwILPjJ6FbnrJTYTaEnv9LQj1qLBq2pV3yC9K4Te26dPTrkgcgsF3dER3NaT
         LPgQ==
X-Forwarded-Encrypted: i=1; AJvYcCX6nSZT/aHMIoY5fG1qEdCnBb7kBhaU7bePjUgsHr1bVKbAxoJ57e1bvV1Y2mDniMk5kAOmA7s=@lists.linux.dev
X-Gm-Message-State: AOJu0YyWJol1mG2TkCyIK+uzxCWZtZRt2wJ2woXL1fSk+WyforsFpQLL
	Wegne0DHIygHe8/PXSsQVqJPMkAPqQTtMs5dI3cjLwWltAikSLUxh7OALzOtCPzmjfQ=
X-Gm-Gg: ASbGncueN1M1NPVJQJ+spP0/u5+iRWODWoAzAsYgKuOTullAgrB8Y6Inj4xjhiFLttu
	JzsBKur4XLT8FuZawAIBFqGoN1HyPiA7UCM8TUfxamN2QSxhhfMw8M6339uM1ZDc5mvuPi4RAaz
	ZZtJKKoV8poHuJez/Hk9g7vYaXgcc4lq/roR6u5TD2x2K65rlG+AeRRJjWvB6/sdgszuLknw9Hg
	K1MJjb+pJKqnPU3lpwSRjlhpc/T9Y+U0/c8FohMOWjLXbwEMClo4Jo7n+VUBLFRVRiEVfEp7Oj/
	lrqifPx1sX/HlvwCRXscaFx8tMMD2ogFNlkH25A5QTHFBt4x88jyXXGooGngr+wLwKXQeKTTHeF
	roBjWiN4RcmErdHSVbZyr4o/VR+rff+kT8em+JMLwYL/Ngoxj2k6PrN8c5WIq0gUwzYFM
X-Google-Smtp-Source: AGHT+IHvW1P/vYfLuQdieKRLav2sj0iL8HcBFcWOObvqQ/GoW+Jjhx1hxhp1NE0qHlpxeA4ab2Hb6w==
X-Received: by 2002:a05:622a:15c2:b0:4ab:887c:8b with SMTP id d75a77b69052e-4af10a88ee3mr13217181cf.42.1754074771752;
        Fri, 01 Aug 2025 11:59:31 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4aeeed670c6sm24010891cf.37.2025.08.01.11.59.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Aug 2025 11:59:31 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1uhuyY-000000014Fy-2vCk;
	Fri, 01 Aug 2025 15:59:30 -0300
Date: Fri, 1 Aug 2025 15:59:30 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Mostafa Saleh <smostafa@google.com>
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
	maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, robin.murphy@arm.com,
	jean-philippe@linaro.org, qperret@google.com, tabba@google.com,
	mark.rutland@arm.com, praan@google.com
Subject: Re: [PATCH v3 29/29] iommu/arm-smmu-v3-kvm: Add IOMMU ops
Message-ID: <20250801185930.GH26511@ziepe.ca>
References: <20250728175316.3706196-1-smostafa@google.com>
 <20250728175316.3706196-30-smostafa@google.com>
 <20250730144253.GM26511@ziepe.ca>
 <aIo1ImP7R7VhRpVE@google.com>
 <20250730164752.GO26511@ziepe.ca>
 <aIt67bOzp6XS_yO-@google.com>
 <20250731165757.GZ26511@ziepe.ca>
 <aIurlx5QzEtjpFLd@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aIurlx5QzEtjpFLd@google.com>

On Thu, Jul 31, 2025 at 05:44:55PM +0000, Mostafa Saleh wrote:
> > > They are not random, as part of this series the SMMUv3 driver is split
> > > where some of the code goes to “arm-smmu-v3-common.c” which is used by
> > > both drivers, this reduces a lot of duplication.
> > 
> > I find it very confusing.
> > 
> > It made sense to factor some of the code out so that pKVM can have
> > it's own smmv3 HW driver, sure.
> > 
> > But I don't understand why a paravirtualized iommu driver for pKVM has
> > any relation to smmuv3. Shouldn't it just be calling some hypercalls
> > to set IDENTITY/BLOCKING?
> 
> Well it’s not really “paravirtualized” as virtio-iommu, this is an SMMUv3
> driver (it uses the same binding a the smmu-v3)

> It re-use the same probe code, fw/hw parsing and so on (inside the kernel),
> also re-use the same structs to make that possible. 

I think this is not quite true, I think you have some part of the smmu driver
bootstrap the pkvm protected driver.

But then the pkvm takes over all the registers and the command queue.

Are you saying the event queue is left behind for the kernel? How does
that work if it doesn't have access to the registers?

So what is left of the actual *iommu subsystem* driver is just some
pkvm hypercalls?

It seems more sensible to me to have a pkvm HW driver for SMMUv3 that
is split between pkvm and kernel, that operates the HW - but is NOT an
iommu subsystem driver

Then an iommu subsystem driver that does the hypercalls, that is NOT
connected to SMMUv3 at all.

In other words you have two cleanly seperate concerns here, an "pkvm
iommu subsystem" that lets pkvm control iommu HW - and the current
"iommu subsystem" that lets the kernel control iommu HW. The same
driver should not register to both.

> As mentioned in the cover letter, we can also still build nesting on top of
> this driver, and I plan to post an RFC for that, once this one is sorted.

I would expect nesting to present an actual paravirtualized SMMUv3
though, with a proper normal SMMUv3 IOMMU subystem driver. This is how
ARM architecture is built to work, why mess it up?

So my advice above seems cleaner, you have the pkvm iommu HW driver
that turns around and presents a completely normal SMMUv3 HW API which
is bound by the ordinately SMMUv3 iommu subsystem driver.

Jason
