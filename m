Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC9602AE99
	for <kvmarm@lists.linux.dev>; Fri, 12 Dec 2025 15:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765554800; cv=none; b=WnTWmzvJ/NHRm5twApFnDIKp+R5qpp+Hk3LTbP71CXT8OBi63qBJCG3GVDdUIavPM1zS6LwZ7XQm0SK5f7hr+Tg1iwahsNuk6wE+ZIkfp6GgnJmtIKkV8V+WVHeJg0ZI64UcZiAJ5QJxHxZ5cZfhZIBFLB73hDYmm47qILX4kA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765554800; c=relaxed/simple;
	bh=zBoGh7Qottv/rPDdH62OofJFkNYMMNwpVKElG2S2exg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aNJsIVxVgyGOKdstA7e5s9hLAVjDwiIlllkw6+Xu9mLPxWl4Vo7bkHaRq8t9uh13gClH03BtpHTznb6CpM7rhhlIdQfuanyJoUnfMM9x5K6vmjyZPRVn0FU5qm4ULKmYWvzr77KcBROqmMh3MSmY4UOqNbKiFaByiE7SkYBFWjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jjww8s+e; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jjww8s+e"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4779e2ac121so167065e9.1
        for <kvmarm@lists.linux.dev>; Fri, 12 Dec 2025 07:53:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765554797; x=1766159597; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=AoTM5VqqBSE/slfl8I1wW/rbVxxaz8QvUYFV+G2U2Oc=;
        b=jjww8s+elSQhKEf2MhRw2s159gHKz/OGs6j997dlwXaK6OlLx+uLiQB3F6qjK4RpBa
         iogvLMqe5ozvMCJMKN2t3m7FJ2yp2+dx+LB6aLka9nmzEJQXr+6KelmwiPtIRjLlyiy4
         hLhtdvVbxvriV5DyPn7xEeLophJ6EwhsAKrmhpSSwxI2EzzsAIRdcHLzpivLQJOyAXDG
         r7HVhqtsbGyoGIcTSIT+W1z2Ni04NtuxuzSPNFexfvBI5uJ70PZ4xImnsiKMbtpXXSKE
         UGbgN+E6Azg1/5+f5ho0m4hGgwZdU+S8QvCy5Pj7vOjQzIp2mNjsIi5GR1FFGkZiueWE
         zW8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765554797; x=1766159597;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AoTM5VqqBSE/slfl8I1wW/rbVxxaz8QvUYFV+G2U2Oc=;
        b=jIULdiWvmnPqqMU01FCDuCiSf08bAB6k6jr7Sb3eefe316/6RbG5Jdd/YZDMEijc5Z
         z20hAtDluN9QVuUKqonSwBwke48zq9OTXsjP8b7222PdQwmOKWxIlPRAtJPu9ECQcmOA
         nnxAD7H7neUffB5u3HAezZE7PbNJb8mwqgGX811+YhMdLbfNHLgSbunmk//qvI8QDiNo
         jMlzA5huVOgCQKlQXJsoxz7/OgptUhP8Ze28JJycF3HSDN1OhqbblORDInLVLdrVgNW8
         GhUWkHDQgWCj1H+GuXHp4FUaKHqcOLpw4+aHgLNekI1Xs7MfJjQ+MpyRLz1YJCAMzjKt
         ciUw==
X-Forwarded-Encrypted: i=1; AJvYcCX0YzYuEyXqEREP9QUc3UUCEp3U6MpDfUfRvSEyDVwDkSDUsHkKAxoVGghRMuejFpTFnsVJ4Qg=@lists.linux.dev
X-Gm-Message-State: AOJu0YxTGAM7QfQ6NgC6itQn/QH8TSAbzZwV0jpoD9w8e9WWeC81mO02
	iXAoUBrmuTKsoFhZYZPps9yKxUPA/5zwfmGP26cYnteF0cphFZGeejO/vlwTmEPfqA==
X-Gm-Gg: AY/fxX4/I5SU325SBadFPPc2fl68UaWAJuXdovkPJXHEcRwKeVybxQkXlD/VYjpTWze
	zADWwIuERx2YZ0J2+7jUoRAALLf98Mxy22ERwj5tVY5WlLPXVdktOClFQ46eDvrmT1LaQq5/eOi
	0KG5vDbVO+YtcumugkcwVzOh3laF5xqeIwqbmLJWELSK1BTYIsWvVxkx60sa/Cmo/RD91j5L1M+
	YgcKgI5kUw8DbrhfNS9BH6pNOkyHqOXCwZa3P3H1ImoXPn+A7qnokMTfqqj7ifmQOVj0g+n4wu7
	YHQXiQLpbawvs5P2RBSd3ha60it9qMF6mVU0xzlZDXIVQVPuVIAB8+HSr/ReSOKaRnmhmiUIoxN
	74AYjId4hH6MqodNcUajQRntwbRxAtWbzHwh8jvnZkFShQA2dQKdC7sRXVEw+D2JUZmfJVVYuUw
	jc63rY6XAHD+TAs2Ksz0mieWenJySPqXtV5FUS5yxWfR/RrcStUiQStXtli9BK
X-Google-Smtp-Source: AGHT+IHmfLLjUS7AcR5ly1Ud2Cl5iPQrQoNP3+3/YuFuH/EESCUT2zan2BZpMVjz/bWfM1lUWrZeUg==
X-Received: by 2002:a05:600c:8885:b0:477:2f6f:44db with SMTP id 5b1f17b1804b1-47a8980f38emr1019575e9.5.1765554797030;
        Fri, 12 Dec 2025 07:53:17 -0800 (PST)
Received: from google.com (54.140.140.34.bc.googleusercontent.com. [34.140.140.54])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47a8f4b516bsm15647455e9.2.2025.12.12.07.53.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Dec 2025 07:53:16 -0800 (PST)
Date: Fri, 12 Dec 2025 15:53:13 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, iommu@lists.linux.dev,
	catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, joro@8bytes.org, jean-philippe@linaro.org,
	praan@google.com, danielmentz@google.com, mark.rutland@arm.com,
	qperret@google.com, tabba@google.com
Subject: Re: [PATCH v5 14/27] iommu/arm-smmu-v3: Support probing KVM emulated
 devices
Message-ID: <aTw6afum4eqr5_e7@google.com>
References: <20251117184815.1027271-1-smostafa@google.com>
 <20251117184815.1027271-15-smostafa@google.com>
 <20251128165616.GD812105@ziepe.ca>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251128165616.GD812105@ziepe.ca>

On Fri, Nov 28, 2025 at 12:56:16PM -0400, Jason Gunthorpe wrote:
> On Mon, Nov 17, 2025 at 06:48:01PM +0000, Mostafa Saleh wrote:
> > When KVM runs in protected mode, and CONFIG_ARM_SMMU_V3_PKVM
> > is enabled, it will manage the SMMUv3 HW using trap and emulate
> > and present emulated SMMUs to the host kernel.
> > 
> > In that case, those SMMUs will be on the aux bus, so make it
> > possibly to the driver to probe those devices.
> > Otherwise, everything else is the same as the KVM emulation
> > complies with the architecutre, so the driver doesn't need
> > to be modified.
> > 
> > Suggested-by: Jason Gunthorpe <jgg@ziepe.ca>
> > Signed-off-by: Mostafa Saleh <smostafa@google.com>
> > ---
> >  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 58 +++++++++++++++++++++
> >  1 file changed, 58 insertions(+)
> > 
> > diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> > index 7b1bd0658910..851d47bedae6 100644
> > --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> > +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> > @@ -11,6 +11,7 @@
> >  
> >  #include <linux/acpi.h>
> >  #include <linux/acpi_iort.h>
> > +#include <linux/auxiliary_bus.h>
> >  #include <linux/bitops.h>
> >  #include <linux/crash_dump.h>
> >  #include <linux/delay.h>
> > @@ -4604,6 +4605,63 @@ static struct platform_driver arm_smmu_driver = {
> >  module_driver(arm_smmu_driver, platform_driver_register,
> >  	      arm_smmu_driver_unregister);
> >  
> > +#ifdef CONFIG_ARM_SMMU_V3_PKVM
> > +/*
> > + * Now we have 2 devices, the aux device bound to this driver, and pdev
> > + * which is the physical platform device.
> > + * This part is a bit hairy but it works due to the fact that
> > + * CONFIG_ARM_SMMU_V3_PKVM forces both drivers to be built in.
> > + * The struct device for the SMMU is used in the following cases:
> > + * 1) Printing using dev_*()
> > + * 2) DMA memory alloc (dmam_alloc_coherent, devm_*)
> > + * 3) Requesting resources (iomem, sysfs)
> > + * 4) Probing firmware info (of_node, fwnode...)
> > + * 5) Dealing with abstracted HW resources (irqs, MSIs, RPM)
> > + * 6) Saving/reading driver data
> > + * For point 4) and 5) we must use the platform device.
> > + * For, 1) pdev is better for debuggability.
> > + * For 2), 3), 6) it's better to use the bound device.
> > + * However that doesn't really work:
> > + * For 2) The DMA allocation using the aux device will fail, as
> > + * we need to setup some device DMA attrs (mask), to match the
> > + * platform.
> > + * For 6) Some contexts from the pdev as MSI, it needs to use the
> > + * drvdata.
> > + * Based on the following:
> > + * 1- Both drivers must be built-in to enable this (enforced by Kconfig),
> > + *    which means that none of them can be removed.
> > + * 2- The KVM driver doesn't do anythng at runtime and doesn't use drvdata.
> > + * We can keep the driver simple and to claim the platform device in all cases.
> > + */
> 
> It is OK I guess, I wouldn't insist you change it, but I think it is
> kind of gross. Registering the iommu driver against the platform
> device instead of the aux is pretty ugly and denies userspace the
> ability to see that the hypervisor is sitting in there through the
> sysfs topology.

Yes, that’s why I was wondering if it’s better to keep this as a platform
driver and create the aux devices for the parent(KVM) but that was really
complicated to handle the probe ordering.

I will give this another though before v6.

> 
> Not sure why the commentary about built-in though, what does that have
> to do with anything? If the aux driver is not built in then it will
> just module load later and everything should be fine?

As at the moment the KVM driver doesn’t use drvdata(nor any device
resources) and the main driver(aux) does, but if that was a module, we
can’t know which version does what (if that changes in the future,
although unlikely).

Thanks,
Mostafa

> 
> Jason
