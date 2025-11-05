Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A6C9334C13
	for <kvmarm@lists.linux.dev>; Wed,  5 Nov 2025 17:12:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762362733; cv=none; b=nuT7wa5vxpXEuIoXhWE7DKbH/xWt0tLGLTqKYrK1JeDefV7wZJ13bZdukH1Wpkeu5kQRtyeFYqp+7878SArOVHDLqEz0fpDxUj55gqdo5CpKu+RmkpADCWNp+DVQYV4rPCEbJNSQrUtUyL791Psm6vN2CzU7DkKZn29DeIBSNoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762362733; c=relaxed/simple;
	bh=RxBxFvM3oAmYwj+WD7NzxAgbGcX4OOVwNkYZi+Tgv38=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mJpPRz7XuvUa/jEhzwu+512au6aWZm8h81eceSZ1O7rfrvUC3NUswStEDjxpLpm4jrwWD3k6WEON5dp0QTV53Rw/C6tFWw0TI+aso31c8SbMrxOYfTf9uG4BbmCNGwjfsdC9aTWJV5Y41+SG77FoF8peKBVwAg+FzGrGBh+2JWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=eAesbtpG; arc=none smtp.client-ip=209.85.222.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="eAesbtpG"
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-8b144ec3aa8so3703885a.2
        for <kvmarm@lists.linux.dev>; Wed, 05 Nov 2025 09:12:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1762362730; x=1762967530; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=wkO/YIgxaPM/wEK82kFqjfst+ouG4RuvuAOrJV+EoBw=;
        b=eAesbtpGTAwnPJBKNk1mNnYIIW5cAuVcZCJXemIHNUFegKvI3t59nXH56uaPq3A76j
         7BL91lypdZ9/otK/EtDjcA2stzhQE77eBatdK/zG7byA0iLlrEttUShLEGItp7VrTivH
         cRxsboVUleJjSjE1/0+5GrjN2fsJbIA0vHEeSkP7d3TXW6cc1dH7szEnqeHIqBV7skot
         NJq3W46iR7lb3E29JQ0vJQJqRyUro6e+hwIajaZp+FXbpE6X5K0prq/6yaWw4bKEDAgZ
         OZr7BPnxwI03CT1VJMg691JUzSug8WGesqLUK7pSCRBUe7rG7XYjzrQNcvYCQ9qFw5pK
         6vow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762362730; x=1762967530;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wkO/YIgxaPM/wEK82kFqjfst+ouG4RuvuAOrJV+EoBw=;
        b=NsyqUoid0uTcN+DwvJVov6ul3qVtdennhoKiReV9GHn5g8rZgJiLFwucXIeRwvYmsU
         sNc2uylt5DWo5PYDYXMjJVdUBoYGfOny0w5LjKxx7D4Sq5+XTdg/e/gaYsXKS9WzLCSw
         GK+V/pt8TxB+2jKYJzL8lZQUAr19XaNhOoFHdOCFZZ9OxpOUctDebdVDC7l4A9b2bTOv
         vkSqaDNloEYcneJio9WbED1zd5jRuJ+IlKyDTZcGiEBeFu90DSt60Z26Usi9yzPQL+SF
         7/EYQfWju2jhV/J/sG7DxgN3/5ypszUZpWF9yy1QVEnnwp3oG4XnpehR9koZD0+00/y1
         QEAA==
X-Forwarded-Encrypted: i=1; AJvYcCUhu6fd6ekjWRL0HPo5zc1OfBm2/Cq8dktu8srC8oV6S7jpzwnNnY2NO1597XBojlTc2mv1HGQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YxDA2jXvnVhvhNzyr54xjCc8r1WCnsM4hi7Pv5MdwByALCxFx1J
	QfbHKov6IoaRvNZPrbCl3J5wvo6YKcAICqwxbvlZpj6bx8/4l7Qx3yCvhq3XH3esqcE=
X-Gm-Gg: ASbGncsdIX84c76bJ1ViXVZbrsoHsEEeR46A3xEj3YYBmpOo/iCmivapfkSMJnx6KRy
	mTGztxMiBlJuEOHapXOk0hH1pi/qsfjF67SNjGl2t57nXqxdk4YcZWZNI4MzBS4jg2olMtZ3WnT
	NzIqG4QztJef+lZ/yf4Zz0V3kN7Huybo4LZD2xVko1paPAaCYmK3krx2iL9RizVqJZtjyjB8BIO
	3vTsHZEHPJJo1OdqAGjXTvpe81L6PG2s4sdjmQP5qrDKUmfsWyiCOlGAREl54pUnxnRfbSE8J7y
	HA8ddw194KOF+O0nKeU7DvEbrBe5uUOd0DOrxH8vpbO/CXmWQOvDLWjVgxpiokfhituPCKorR1B
	LXRLfeap2gD2Bmpiidae8ZW6ffvQKhZh3iHRUJCYw3RW0BJAUypHGC03mkXWy4Rw8bWWAfz1FMK
	dm2qS4GLA2+orrg0QBehMnbqILRgRZM0LN0FBk3H/4NGa1vQ==
X-Google-Smtp-Source: AGHT+IE+H5A+GWBd94mKAScAzkbN/plh8wCL54OtyUq33k2cpyVKMqW/YnW1kIG+WLt6H619/vMFBw==
X-Received: by 2002:ac8:7e93:0:b0:4ed:2140:7a96 with SMTP id d75a77b69052e-4ed7262fff1mr49444101cf.58.1762362729905;
        Wed, 05 Nov 2025 09:12:09 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4ed5fabbbc9sm40585631cf.6.2025.11.05.09.12.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Nov 2025 09:12:09 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vGh3I-00000007Bqn-3NXB;
	Wed, 05 Nov 2025 13:12:08 -0400
Date: Wed, 5 Nov 2025 13:12:08 -0400
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
Message-ID: <20251105171208.GN1204670@ziepe.ca>
References: <20250819215156.2494305-1-smostafa@google.com>
 <20250819215156.2494305-16-smostafa@google.com>
 <aMQmA9cLaeYWG5_C@willie-the-truck>
 <aNKwROPzDCWgJBGQ@google.com>
 <20250923173806.GF2547959@ziepe.ca>
 <aNppE9A3PDiDg_1W@google.com>
 <20251002151308.GG3195829@ziepe.ca>
 <aQt9-kTCe8TpuyVq@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aQt9-kTCe8TpuyVq@google.com>

On Wed, Nov 05, 2025 at 04:40:26PM +0000, Mostafa Saleh wrote:
> However, that didn’t work because, as from Linux perspective the
> nested driver was bound to all the SMMUs which means that any
> device that is connected to an SMMUv3 has its dependencies met, which
> caused those drivers to start probing without IOMMU ops.

??

What code is doing this?

If a struct device gets a fwspec attached to it then it should not
permit any driver to probe until iommu_init_device() has
succeeded. This broadly needs to work to support iommu drivers as
modules that are loaded by the initrd.

So the general principal of causing devices to not progress should
already be there and work, if it doesn't then maybe it needs some
fixing.

I expect iommu_init_device() to fail on devices up until the actual
iommu driver is loaded. iommu_fwspec_ops() should fail because
iommu_from_fwnode() will not find fwnode in the iommu_device_list
until the iommu subsystem driver is bound, the kvm driver cannot
supply this.

So where do things go wrong for you?

> It seems device links are not the write tool to use.

Yes
 
> So far, the requirements we need to satisfy are:
> 1- No driver should bind to the SMMUs before KVM initialises.

Using the above I'd expect a sequence where the KVM SMMU driver loads
first, it does it's bit, then once KVM is happy it creates the actual
SMMU driver which registers in iommu_device_list and triggers driver
binding.

This is basically an identical sequence to loading an iommu driver
from the initrd - just the trigger for the delayed load is the kvm
creating the device, not udev runnign.

> 2- Check if KVM is initialised from the SMMUv3 driver,
>    if not -EPROBE_DEFER (as Will suggested), that will guarded by the
>    KVM driver macro and cmdline to enable protected mode.

SMMUv3 driver shouldn't even be bound until KVM is ready and it is an
actual working driver? Do this by not creating the struct device until
it is ready.

Also Greg will not like if you use platform devices here, use an aux
device..

Jason
