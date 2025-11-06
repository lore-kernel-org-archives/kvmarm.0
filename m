Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A920339B3B
	for <kvmarm@lists.linux.dev>; Thu,  6 Nov 2025 16:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762448087; cv=none; b=SOZvQVG4+WuqDTGKujPa9NHQ5w5n5rQjgnsMDh635a0NYlbFAkK3+x75KRAODm7B9uHeo9XlYS2ESvc7W9n7ZgR763lkAK1UfaZC3q1pt9/d/IYfT2r5T5Lsa527BgGQsrvb6OSQzGSU1r9fzuoZ/oz3EK8ldmsTAWRJLsPSlF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762448087; c=relaxed/simple;
	bh=+er897VeBk4n/vRglajwaZ5PSzwLJpIHytxIjwJ2hFI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LxswUqrBjMr3HVb5Ccyoy0InSJ5g2Wt1nWV/bRMziaV2DFo4tfGL+4U40sZ/bLm0kJ6YfR0Gf+hxhj+jcJRy7JRE4yyLx2BVS831FtGQXVMjfNn3gMkpL9BmLq/pPjoOcdxUFleaBX8eWmb6yATxzERHbzDE9ZyVaNqDOQ/MaTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aAU8tKa/; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aAU8tKa/"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-47754e0a13bso86535e9.0
        for <kvmarm@lists.linux.dev>; Thu, 06 Nov 2025 08:54:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762448083; x=1763052883; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=qy5jSwN7S6PcN2+UAQhcACOnAgI06MV590m9VcIejho=;
        b=aAU8tKa/VcTdl+T1ZP6xD1CyGGoCjhdsuTN/vYwq0PJoItKjGrPs5Bu+YOs6Sq3VOO
         S+aAQkbQzC4UWTlj2zsOwCHgG6xm7vMq0gq/51OygCmD2mABHfnlQi96TtbCVf4jjIuJ
         biI4T4suWnKeYHsOOvQuO/klq7PrQ3aIELF+tz/OP/HwMKzqFEqnP5cMZCFo7IMu/56q
         86wmmoH7NWj8lXUNUAtS+eLBHf37/TluLh08u39jPoziTieNXO8wsj/CdKn69+TiWpw6
         K57zWP2vBgQV9oLHty9n7S8ELKxatq8ByUV75N8jjUTjfqU7blPwyEId/VdIipdrwosn
         ojBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762448083; x=1763052883;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qy5jSwN7S6PcN2+UAQhcACOnAgI06MV590m9VcIejho=;
        b=u3/XwGHYqus0V6PnKvZrEMjuRVwaCMDI2KeiyNKl6VGXJ0wqnD1s2q34t/mZLUcF6p
         NRxKcRIa97gjZKCTBg2uKiOaxneYKheNiViOozVxkuO35fDkN5Nq7lEuZ+Lg4IzsPI0M
         dAa7MtseBTRZ5StsIh4bWz+uozep0P7JPfaKoALYB1i/bwkC+ea8lcHXJ/5GImGvVgJ5
         ukVisC2Ely6rYTy+6lJLzbbP2ze7PsmNpH1Z1NwuCK9AbAnC2sfi2WirlHWMXRi7kZc2
         DqIh6VSjawj061mZ4k0YplBNSymQ0tf+tiTo2znSlPt2NGzsMD3LkthvklHzdwcqtigf
         rH8A==
X-Forwarded-Encrypted: i=1; AJvYcCWihUxRWTHxtStiyDE5NhjiAK06yQvAVPUuha8r+x0dW8JvQAH88DAjo5Iwv5P4HbuVeE2L2uA=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw816cFuVzIODLnh3k69H6zhn7HOPG8u749c3zqYIP2qXHe6N38
	7s2IcB3EfpJvLsFyq7ad96ZJHnlC43VES8ZIDBwjHKBbSWORMpjBIByZTFgS9bOoVg==
X-Gm-Gg: ASbGncu7EqRsWiiwBmVl7/0Tl2z9vc3+r8yBLsckA4e8oVwxpD5yip2G2Q5rdSHAi5u
	W3gqGls4Bd4ShTrYbbZc1OdANobL9S+jjsEoZ84tqQGO7C0p8oFV2hyr+mCKzPkkTEmkejpF136
	iRIFbm1nm+UVUj9HCMbXr+IdhsFDOQyBixJvIruGkvwMZq+UsjPzrHeJrPyRmqzvbqz81u9uRsy
	dOFQp7ub93gWXws+BZKH8Upw8Zu9D9nb6Z2WJgPUlOkQmvVqY69ubDpxCVqQQtmAQCB+803jAia
	FAbvrm2ciwYdXyFK1VbZPMW52hR4lEKPX8wQaOwYu9NWgbUNQqmrq9CHHCyil5/18i3qGQoCmoa
	Uea1PUxyGecJhM16Wl4yV/yCfBlHp9KCF2KwT0halQB5I5xrsgpkXtO9z3cHbIsicL0g8dl3qXf
	VKzwJ247KEP5QsNVcO3VkHrrZxW2wwv2iTxz7ghpE0BklPMB0rTU61Vc8UA/Vd
X-Google-Smtp-Source: AGHT+IH9Sel42fS+BYooq+9ScS2mxKoFKXpJsaK/tHTCGPR8SBDeDrXp6AvREwD204lt8g8KrZ9JGg==
X-Received: by 2002:a05:600c:c10f:b0:477:1afe:b962 with SMTP id 5b1f17b1804b1-4776410ec16mr2231445e9.1.1762448083254;
        Thu, 06 Nov 2025 08:54:43 -0800 (PST)
Received: from google.com (54.140.140.34.bc.googleusercontent.com. [34.140.140.54])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4775ce210a7sm120476545e9.12.2025.11.06.08.54.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Nov 2025 08:54:42 -0800 (PST)
Date: Thu, 6 Nov 2025 16:54:38 +0000
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
Message-ID: <aQzSzhcndQ3Ry0a2@google.com>
References: <20250819215156.2494305-16-smostafa@google.com>
 <aMQmA9cLaeYWG5_C@willie-the-truck>
 <aNKwROPzDCWgJBGQ@google.com>
 <20250923173806.GF2547959@ziepe.ca>
 <aNppE9A3PDiDg_1W@google.com>
 <20251002151308.GG3195829@ziepe.ca>
 <aQt9-kTCe8TpuyVq@google.com>
 <20251105171208.GN1204670@ziepe.ca>
 <aQyBIohAuxNHV-XI@google.com>
 <20251106132331.GU1204670@ziepe.ca>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251106132331.GU1204670@ziepe.ca>

On Thu, Nov 06, 2025 at 09:23:31AM -0400, Jason Gunthorpe wrote:
> On Thu, Nov 06, 2025 at 11:06:11AM +0000, Mostafa Saleh wrote:
> > Thanks for the explanation, I had a closer look, and indeed I was
> > confused, iommu_init_device() was failing because of .probe_device().
> > Because of device_set_node(), now both devices have the same fwnode,
> > so bus_find_device_by_fwnode() from arm_smmu_get_by_fwnode() was returning
> > the wrong device.
> > 
> > driver_find_device_by_fwnode() seems to work, but that makes me question
> > the reliability of this approach.
> 
> Yeah, this stuff is nasty. See the discussion here.
> 
> https://lore.kernel.org/linux-iommu/0d5d4d02-eb78-43dc-8784-83c0760099f7@arm.com/
> 
> riscv doesn't search, so maybe ARM should follow it's technique:
> 
> static struct iommu_device *riscv_iommu_probe_device(struct device *dev)
> {
>         struct iommu_fwspec *fwspec = dev_iommu_fwspec_get(dev);
>         struct riscv_iommu_device *iommu;
>         struct riscv_iommu_info *info;
>         struct riscv_iommu_dc *dc;
>         u64 tc;
>         int i;
> 
>         if (!fwspec || !fwspec->iommu_fwnode->dev || !fwspec->num_ids)
>                 return ERR_PTR(-ENODEV);
> 
>         iommu = dev_get_drvdata(fwspec->iommu_fwnode->dev);
>         if (!iommu)
>                 return ERR_PTR(-ENODEV);
> 
> It would make it reliable..

That makes sense, and it will address the problem Robin was solving also:
https://lore.kernel.org/r/6d7ce1dc31873abdb75c895fb8bd2097cce098b4.1733406914.git.robin.murphy@arm.com

> 
> > > > 2- Check if KVM is initialised from the SMMUv3 driver,
> > > >    if not -EPROBE_DEFER (as Will suggested), that will guarded by the
> > > >    KVM driver macro and cmdline to enable protected mode.
> > > 
> > > SMMUv3 driver shouldn't even be bound until KVM is ready and it is an
> > > actual working driver? Do this by not creating the struct device until
> > > it is ready.
> > > 
> > > Also Greg will not like if you use platform devices here, use an aux
> > > device..
> > 
> > But I am not sure if it is possible with built-in drivers to delay
> > the binding.
> 
> You should never be delaying binding, you should be delaying creating
> the device that will be bound.
> 
> pkvm claims the platform device.
> 
> pkvm completes its initialization and then creates an aux device
> 
> smmu driver binds the aux device and grabs the real platform_device
> 
> smmu driver grabs the resources it needs from the parent, including
> the of node. No duplication.
> 
> Seems straightforward to me.

Maybe I am misunderstanding this, but that looks really intrusive to me,
at the moment arm-smmuv-3.c is a platform driver, and rely on the
platform bus to understand the device (platform_get_resource...)

You are suggesting to change that so it can also bind to AUX devices, then
change the “arm_smmu_device_probe” function to understand that and possibly
parse info from the parent device?

One of the main benefits from choosing trap and emulate was that it
looks transparent from the kernel of point view, so doing such radical
changes to adapt to KVM doesn't look right to me, I think the driver
should remain as is (a platform driver that thinks it's directly
talking to the HW).
The only thing we need to do is to make the SMMUs available after
KVM is up (at device_sync initcall).

> 
> > Also, I had to use platform devices for this, as the KVM driver binds
> > to the actual SMMUv3 nodes, and then duplicates them so the SMMUv3
> > driver can bind to the duplicate nodes, where the KVM devices are the
> > parent, but this approach seems complicated, besides the problems
> > mentioned above.
> 
> I don't think you need to do this this, you can use aux device and the
> fwspec things all search the iommu_devices_list to find the
> iommu_driver. You don't need to duplicate anything.
> 
> Create the aux driver when the emulated smmu is ready to go.

See my point above.

> 
> > That works for me. And if we want to back the KVM driver with device I was
> > thinking we can rely on impl_ops, that has 2 benefits:
> 
> > 1- The SMMUv3 devices can be the parent instead of KVM.
> > 2- The KVM devices can be faux/aux as they are not coming from FW and
> >    don't need to be on the platform bus.
> 
> IMHO this is backwards. The kvm driver should be probing first, the
> smmu driver should come later once kvm is ready to go.

Agree.

>  
> > Besides this approach and the one in this patch, I don't see a simple way
> > of achieving this without adding extra support in the driver model/platform
> > bus to express such dependency.
> 
> You shouldn't need anything like this.

Agree.

Thanks,
Mostafa

> 
> Jason
