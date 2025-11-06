Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC5D82C08BC
	for <kvmarm@lists.linux.dev>; Thu,  6 Nov 2025 11:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762427179; cv=none; b=fRyHiPDwdlqJ5C5BmSnr33rquCPjs4LJatl2jU+F34C72s86uGyMP+4IDF6lANmJTR01+jPav4UD4nCtnkCxW/0F+/DdHolumIw/mSYJkjFEwTYD/cFcijiLEM3sHPTiK9eBsVWTctWT6vVxe0Wn36uEFvs+iIr5uPQ22T4qpNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762427179; c=relaxed/simple;
	bh=4cS4awkDakBBGs7QL/xXO0LyzLmqQrXz8qdFmMEuZhE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kEnUyUOLnmZREb1rlApYVztBUP0ikD/tksiqgYiKXoX0yQaDfgsAxVVxzNmwjEHGbvGE0XrjidNIRTyU1CkVXP8acDnzbE2yom6pI4jBF2rW2ShTLrf3hhE2RRkx4pt93HP7Q7UdwbYuV2Ju9dCJkj1fPorg/bbO2GRbd8CaaCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OatDnBtt; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OatDnBtt"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4770d4df4deso42465e9.1
        for <kvmarm@lists.linux.dev>; Thu, 06 Nov 2025 03:06:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762427176; x=1763031976; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=xP2QazUoPgLd8bd4CuoIUWxA+WJ3ehNooABdbD8w52A=;
        b=OatDnBttRf1EjzvOI6MKBjVHdN5pe8dDGYQsNhH0jt1qZ4ltKwB4qIjXu2+9rjU+JB
         +sTDu5ft0OzrQKlOwu65d62T/medrBlZ8bL5sDsLsfNG8rk/jlocfdMZ9e/4/qtUhDOA
         Gv1QLU3XnK/eG9Yc60mezPEhh1481BWj4Ko9Fd95xbYCzwlUqW1E7oAmbesW/76PT08v
         mvNz0Km+SohAJmYPUP1e/Kvch2Lzko07NXVsSxYWbzDB2G4xVSRxEZZGqIx4WSqoV9i0
         pbLTVS6j9zbzDGcOiBh0s6SBcJlazqXjWWXsI/Q9gSgVJCn+OU8DvOMCdgeD4mfzlFXp
         Jvvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762427176; x=1763031976;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xP2QazUoPgLd8bd4CuoIUWxA+WJ3ehNooABdbD8w52A=;
        b=rZ/Vdb77T8NiLjIZLYH7/7kodno5RgtMoxtzAgFHSsaA2hHOc+AawXHJbjTStAUMdZ
         5LgUaOYuD5Qq3DfHNFGvIqHOvJRI326TGQ3+vFp+pf+8/bS5eTOsWAPjr3VI0Y8HIouC
         nbnY/Kz+ZvcOkW9/3VgSoizPFXeWgScfcaWsBItEvzhMev8ZshL/pZet/lhm6sppB2Fm
         2ZNqtTykB08G9/HxXAQbH6MYJqv09AjQc10g/psghaAKsgd5+qnu1qRrBsby6avPi4mz
         scIlGv9ETjG8v+ckaAGOVq5eAJ6AoFXrIgb6IJ4+fnquybIMoxppbEuP42LHFvlZ9wFB
         UXOg==
X-Forwarded-Encrypted: i=1; AJvYcCWSpJQTxYI7Ma54y3TpyzNUiM/M+pgCgJCpMB2P6y4JHYRBQ8ZX+J797Dmspj2LU3BXjl5xPa0=@lists.linux.dev
X-Gm-Message-State: AOJu0YxzThZapyhdNlj3YPw+gl+ui2V1ZDh26CyhSbwqML2yLc/zVh57
	NBH+YbqNXAde1k6xeKj/4+pmQpl/+1B8qUj/LqcgOOBLW6hUENvgT2f+8vtEv+2o9g==
X-Gm-Gg: ASbGncs+H1gC8/KGdTQa7lGowJdvgKpgP7TXFzLH/H/J8aUiBaMI+/123cqzcpu4U4D
	F1o7Pg0DUQxEoFYJCxUB35isocT0wsPLGXCYTE3HkQBbkT9KxInpdeB8lWqZSuvLK4hhuhKsMdV
	c+ubIM+QNPNEUcXXjDQEH6aDqi4y9Zf1gTaDPmQ7/8xjDHsnYJGIvbYS6+pcm5rxVLWRnf78T89
	rPnnrLOL4CyJ9roKtGv1Z23Uchz5Le8xcoxry6AqoQpBBb9hA2K3w0eI5s+HWr75C71PCgzIt7q
	s12NAFMmVcTGHg5gvUI7l12u2K3AGyy/qc+Sw7+8DVD0c69FOHrPHA9oWZ8nusJMbEQLPRrKEtp
	3bKBlIlymgSXYeJ/1kz2/lQfRWK9mcu0yxKMMtAzCg0Vjs3ev52j1OUtouhY1OnffQ3OHiC1KI9
	796Si59ZfwzSATQWchJAuKMt1arIn4xfkQb0Sj9Ii7JIO8nZp3Ng==
X-Google-Smtp-Source: AGHT+IEUOv1ZE3UbDFaV92jPApWKF4Ndj0TjhhcPgVhbXYQBhOFnOW3XBZWOwcR3RPC6W7WWXNjURQ==
X-Received: by 2002:a05:600c:58d1:b0:475:d905:9f12 with SMTP id 5b1f17b1804b1-477628cece0mr1822875e9.4.1762427175811;
        Thu, 06 Nov 2025 03:06:15 -0800 (PST)
Received: from google.com (54.140.140.34.bc.googleusercontent.com. [34.140.140.54])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429eb49a079sm4426519f8f.32.2025.11.06.03.06.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Nov 2025 03:06:15 -0800 (PST)
Date: Thu, 6 Nov 2025 11:06:11 +0000
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
Message-ID: <aQyBIohAuxNHV-XI@google.com>
References: <20250819215156.2494305-1-smostafa@google.com>
 <20250819215156.2494305-16-smostafa@google.com>
 <aMQmA9cLaeYWG5_C@willie-the-truck>
 <aNKwROPzDCWgJBGQ@google.com>
 <20250923173806.GF2547959@ziepe.ca>
 <aNppE9A3PDiDg_1W@google.com>
 <20251002151308.GG3195829@ziepe.ca>
 <aQt9-kTCe8TpuyVq@google.com>
 <20251105171208.GN1204670@ziepe.ca>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251105171208.GN1204670@ziepe.ca>

On Wed, Nov 05, 2025 at 01:12:08PM -0400, Jason Gunthorpe wrote:
> On Wed, Nov 05, 2025 at 04:40:26PM +0000, Mostafa Saleh wrote:
> > However, that didn’t work because, as from Linux perspective the
> > nested driver was bound to all the SMMUs which means that any
> > device that is connected to an SMMUv3 has its dependencies met, which
> > caused those drivers to start probing without IOMMU ops.
> 
> ??
> 
> What code is doing this?
> 
> If a struct device gets a fwspec attached to it then it should not
> permit any driver to probe until iommu_init_device() has
> succeeded. This broadly needs to work to support iommu drivers as
> modules that are loaded by the initrd.
> 
> So the general principal of causing devices to not progress should
> already be there and work, if it doesn't then maybe it needs some
> fixing.
> 
> I expect iommu_init_device() to fail on devices up until the actual
> iommu driver is loaded. iommu_fwspec_ops() should fail because
> iommu_from_fwnode() will not find fwnode in the iommu_device_list
> until the iommu subsystem driver is bound, the kvm driver cannot
> supply this.
> 
> So where do things go wrong for you?

Thanks for the explanation, I had a closer look, and indeed I was
confused, iommu_init_device() was failing because of .probe_device().
Because of device_set_node(), now both devices have the same fwnode,
so bus_find_device_by_fwnode() from arm_smmu_get_by_fwnode() was returning
the wrong device.

driver_find_device_by_fwnode() seems to work, but that makes me question
the reliability of this approach.

> 
> > It seems device links are not the write tool to use.
> 
> Yes
>  
> > So far, the requirements we need to satisfy are:
> > 1- No driver should bind to the SMMUs before KVM initialises.
> 
> Using the above I'd expect a sequence where the KVM SMMU driver loads
> first, it does it's bit, then once KVM is happy it creates the actual
> SMMU driver which registers in iommu_device_list and triggers driver
> binding.
> 
> This is basically an identical sequence to loading an iommu driver
> from the initrd - just the trigger for the delayed load is the kvm
> creating the device, not udev runnign.

SMMUv3 driver as a module won't be a problem as modules are loaded later
after KVM initialises. The problem is mainly with the SMMUv3 driver
built-in, I don't think there is a way to delay loading of the driver,
besides this patch, which registers the driver later in case of KVM.

> 
> > 2- Check if KVM is initialised from the SMMUv3 driver,
> >    if not -EPROBE_DEFER (as Will suggested), that will guarded by the
> >    KVM driver macro and cmdline to enable protected mode.
> 
> SMMUv3 driver shouldn't even be bound until KVM is ready and it is an
> actual working driver? Do this by not creating the struct device until
> it is ready.
> 
> Also Greg will not like if you use platform devices here, use an aux
> device..
> 

But I am not sure if it is possible with built-in drivers to delay
the binding.

Also, I had to use platform devices for this, as the KVM driver binds
to the actual SMMUv3 nodes, and then duplicates them so the SMMUv3
driver can bind to the duplicate nodes, where the KVM devices are the
parent, but this approach seems complicated, besides the problems
mentioned above.


The other approach would be to keep defering in case of KVM:

@@ -4454,6 +4454,10 @@ static int arm_smmu_device_probe(struct platform_device *pdev)
 	struct arm_smmu_device *smmu;
 	struct device *dev = &pdev->dev;
 
+	if (IS_ENABLED(CONFIG_ARM_SMMU_V3_PKVM) && is_protected_kvm_enabled() &&
+	    !static_branch_unlikely(&kvm_protected_mode_initialized))
+		return -EPROBE_DEFER;

That works for me. And if we want to back the KVM driver with device I was
thinking we can rely on impl_ops, that has 2 benefits:

1- The SMMUv3 devices can be the parent instead of KVM.
2- The KVM devices can be faux/aux as they are not coming from FW and
   don't need to be on the platform bus.

And this is simpler.

Besides this approach and the one in this patch, I don't see a simple way
of achieving this without adding extra support in the driver model/platform
bus to express such dependency.

Thanks,
Mostafa



> Jason
