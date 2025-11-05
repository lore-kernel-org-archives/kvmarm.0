Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C8F332549C
	for <kvmarm@lists.linux.dev>; Wed,  5 Nov 2025 16:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762360834; cv=none; b=D0rE7giirG3kwPxjfybcinjcOKg2D590Fqmulg+duPShj/kLiDoFZoZiJekjbaJLYjY8BGRf7TvOjWHgrMmLbS9VWI98IoI+uTHu76kdGBadsMoXKEqSoFN43+uadvlw+8Db+yC4WWp0Vaf39gNxca7KLZTQ/GFyJPMEKIRu4t4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762360834; c=relaxed/simple;
	bh=atIZzAToir8eRpbQcVVHtDtwnLdnBANcxYeOYHDiA2g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AeZ+KFU7oKva211pZmd5RyLXmL+Ia8Bx3h8hiwKk+7pRj+qBXx89XiFN1ylcKZSw+ECjCwZVl2hYz8rmaeTfC5Cu6dG11c6ksD6aDgUnQwLpQGt3ny65sD4nS+JipSEYYrRlF+lUPCCJM0nlYmWlwCo7DVNNFYRg3hmWGP8SrWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dPFAwrcU; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dPFAwrcU"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4770d4df4deso30375e9.1
        for <kvmarm@lists.linux.dev>; Wed, 05 Nov 2025 08:40:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762360832; x=1762965632; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=0eEl5tuPcKQIbbiQU4HmtriawKnG+Y/aITWPg2eK/vk=;
        b=dPFAwrcUZ8t0Kn9OCOm4bsOAv4iqUtZ4IjUshi7gUn18Ug/0hkKn7d+l19u8kbakPd
         WStkeLUBYljlna/IyAGTlzDwym/KW672Dhx97P75otL+wT5bQo6GIEtRiYOE2ddFKfky
         mm4EFlywgfuUu9TwJaE/VLINIK2rwZJLGbrazPQ1omu9v+g6voBbZOrbsScPf+P3HHli
         ofQrVzrgrB8roLwKsUhkN4lFFk7IFOmEeJ6JAL291WADSNx07xvSo2s63c7EODrW5PT2
         whbPO4uRa0ZA/Vz9SbhVK/K+JDYG93OAyoRef6MoMEmcFCNW4V7fW7lLURG+r5TsrwJH
         Te9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762360832; x=1762965632;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0eEl5tuPcKQIbbiQU4HmtriawKnG+Y/aITWPg2eK/vk=;
        b=pH7NBh79Z60J47M2x6X02CMwIhRW0mK1ZNOmWcD67AKf657FLMq909cGLthKqZDQNG
         hLUuauW405gHneLR9EBn1JNNFcvqzWaYtvZ+W6+t7S9hM9sqrDdrzC9vFN++O4Ka2nnW
         wp4Q9CQfB3xFIFyA8HZa/4bWzbRTO8FtrnfVwzl1EHUKMkV7nmtmGg213kTgnR7EI3fW
         Atzup7eTdixlj6YVd8uIuFWsv/4GL6xSIYYQKCsqsNuGaA3Y5nn7KaEiCzIMd/z2juun
         8PK/JQY/kBuZj3yhKJe6mGECa1XhfN6mP9DeXu0hN3VLnpQGShFohBTG+3w0UGeYiDnQ
         F2FA==
X-Forwarded-Encrypted: i=1; AJvYcCXi7Atfl2JsQMMVDkjhVEc2NttUzLX1dedmwt0LbyCDe4Y8P6jxEkuMQw956f1cJPnZrEaKusw=@lists.linux.dev
X-Gm-Message-State: AOJu0YzY7AJPmCvw6pRVWfYb3bzg+cSApIVNOTfP4iAfDCZVY6NCMbau
	aJu1oOBXrjTDO1jUuuhazbG3K6fowIl2wvYVJa+2Hnhd375qhtV9RjOzTdLUVHernNNGgRUlqQv
	Yedgh5A==
X-Gm-Gg: ASbGnctOdwqNUL4eVnZTQexjpJg8VWdeZUHo2iu6kUR8Nqk8gcnJrvlY4+53dFHuooq
	S1ZOv/UrKlq5/D6I5Irgrm6qhV2SC87w+D6gQ5ce+q265CK+UtZ2Z22Ubd0R3qwN6z6z4JMC724
	qlBxW8bKsooER52vSlkpvvIZGGVdb/Zf+ogZr+LTYeW5/8vDHXmQaFr9kxLf0d8OYonOsohsg2R
	WbtY16h/rERqzIfwAvmXfj4FOERTn3wh3TC8ofamZz0rrxEQMoB9CHxgszZlk0YP2+ase8XD4xT
	nslt3AQX61+wMtby0vnwGC8ZiekXXf3gdLA+FCwZzHzvpP2cokWP3UAbIndWtGZsDq8w0Z5quXb
	jBFr9Jq5whYbbXrN6i5q+wjXEpWfUxikBtieyCB9tk2f84HyWN+6BAEreF9VRuoOGm12zBXCajR
	DDpk90yswkldnnpfeLFrWTzmUF9UNeCAeZx2VkMnljbbY0CgtSJjh871aUD+2e
X-Google-Smtp-Source: AGHT+IEy+8V+O2C0Flc9TdN/DCHlTtarKl1lxRtJWgoMhvht/+272KjjM3JvTIZWVNcKN9O18oV/xA==
X-Received: by 2002:a05:600c:3ba3:b0:477:1afe:b962 with SMTP id 5b1f17b1804b1-4775dae9364mr3187645e9.1.1762360831358;
        Wed, 05 Nov 2025 08:40:31 -0800 (PST)
Received: from google.com (54.140.140.34.bc.googleusercontent.com. [34.140.140.54])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429dc200878sm11360022f8f.45.2025.11.05.08.40.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Nov 2025 08:40:30 -0800 (PST)
Date: Wed, 5 Nov 2025 16:40:26 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Will Deacon <will@kernel.org>, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	iommu@lists.linux.dev, maz@kernel.org, oliver.upton@linux.dev,
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, robin.murphy@arm.com,
	jean-philippe@linaro.org, qperret@google.com, tabba@google.com,
	mark.rutland@arm.com, praan@google.com
Subject: Re: [PATCH v4 15/28] iommu/arm-smmu-v3: Load the driver later in KVM
 mode
Message-ID: <aQt9-kTCe8TpuyVq@google.com>
References: <20250819215156.2494305-1-smostafa@google.com>
 <20250819215156.2494305-16-smostafa@google.com>
 <aMQmA9cLaeYWG5_C@willie-the-truck>
 <aNKwROPzDCWgJBGQ@google.com>
 <20250923173806.GF2547959@ziepe.ca>
 <aNppE9A3PDiDg_1W@google.com>
 <20251002151308.GG3195829@ziepe.ca>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251002151308.GG3195829@ziepe.ca>

On Thu, Oct 02, 2025 at 12:13:08PM -0300, Jason Gunthorpe wrote:
> On Mon, Sep 29, 2025 at 11:10:11AM +0000, Mostafa Saleh wrote:
> > Another possible solution, to keep a device bound to the KVM driver,
> > is to probe the SMMUs from the KVM driver, then to create child devices;
> > possibly use something as device_set_of_node_from_dev to bind those to
> > the main SMMUv3 or find another way to probe the main SMMUv3 without
> > changes.
> 
> I do prefer something more like this one, I think it is nice that the
> kvm specific driver will remain bound and visible so there is some
> breadcrumbs about what happened to the system for debugging/etc.
> 
> Not sure how to do it, but I think it should be achievable..
> 
> Maybe even a simple faux/aux device and just pick up the of_node from
> the parent..

I spent some time looking into this

With the approach of creating new devices as:

	pdev = platform_device_alloc(dev_name(dev), PLATFORM_DEVID_AUTO);
	pdev->dev.parent = dev;
	device_set_node(&pdev->dev, dev->fwnode);
	platform_device_add_resources(pdev, cur_pdev->resource,
				      cur_pdev->num_resources);
	platform_device_add(pdev);

That is done from an init call after KVM init, where the KVM driver
probes the SMMUs, which then does
	bus_rescan_devices(&platform_bus_type);

In the KVM driver probe, it had:
	if (pdev->dev.parent->driver == &smmuv3_nesting_driver.driver)
		return -ENODEV;

Which causes the main SMMU driver to probe the new devices.

However, that didn’t work because, as from Linux perspective the
nested driver was bound to all the SMMUs which means that any
device that is connected to an SMMUv3 has its dependencies met, which
caused those drivers to start probing without IOMMU ops.

Also, the approach with bind/unbind seemed to not work reliably
because of the same reason.

Looking into the probe path, it roughly does.
1) Device / Driver matching driver_match_device
2) Check suppliers before probe (device_links_check_suppliers)
3) Actual probe

I can’t see a way of adding dependencies in #1

For #2, there 2 problems,
i) It’s not clear how to create links, something as fwnode_link_add()
   won’t work as one of the devices won’t have fwnode and device_link_add()
   will need the device to be already created (and not sure how
   to guarantee it won’t probe)
ii) Assuming we were able to create the link, it will be set to
    DL_STATE_AVAILABLE once the nested driver probes, which won’t prevent
    the main driver from probing till KVM initialises.

It seems device links are not the write tool to use.

So far, the requirements we need to satisfy are:
1- No driver should bind to the SMMUs before KVM initialises.
2- Back the nested driver with devices and possibly link them

The only possible solutions I see:
1- Keep patch as is
2- Check if KVM is initialised from the SMMUv3 driver,
   if not -EPROBE_DEFER (as Will suggested), that will guarded by the
   KVM driver macro and cmdline to enable protected mode.

Then if needed, we can create devices from the nested driver and link
them to the main ones in same initcall after the devices are created.

I can to look into more suggestions, otherwise, I will try with #2
with the -EPROBE_DEFER.

Thanks,
Mostafa

> 
> Jason
