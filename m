Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98D432D8766
	for <kvmarm@lists.linux.dev>; Thu,  6 Nov 2025 17:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762449419; cv=none; b=hS8SSA1dhPLOfU+/ZnB3JfWIjU4pCi8yO7MMUcrADpVi9X2cEvq8dbBQ/yNhRxVHgY6wyUqfxpCUGcmrWuzkUAzEdN8otFudpgVKNerbVw2tCrGu06lcKvaKHfIyLIQzUsmNcQ/nzknPQg/P3ggpB3jpbxGagh1phNpMfQzTMww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762449419; c=relaxed/simple;
	bh=dIwybaZojCu29+P9gEfB8CIvmj6Bl08p1VgiPhwpKTo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dOSl3c466tLcJKZt4jX/f3LzjRieS/DtQubOfNB4FzpbheK6p1yWMr6iS0Y7WA2S6+6bVh1xZxgtpr6cDjGT0EQp2IQ9CJdJDIk/qsRyq9ui/TpjlrkZgADeYSwZk6lBjaUMwBzw7BrQnFg75O2C9JICZ2iUu/+kz09DYE0WO+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=fEmZskmt; arc=none smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="fEmZskmt"
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-4ecfc3f4a13so6515741cf.1
        for <kvmarm@lists.linux.dev>; Thu, 06 Nov 2025 09:16:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1762449416; x=1763054216; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=XyqXd6ge5y2aj27CRXRh3J8Q1q4rd+TcymckOxNEG8A=;
        b=fEmZskmtaptejch4msph1FdQkdP/R8M9OyiBrYBY5+0s8wjOoLMT1qg7wQk42FNbP0
         oAzW0rNsuy8yowrg1wZh1EAo4zNOSxhUviusHmHfQhE+xMRH6DC5a018eWDEtni+32kU
         zoSnaSO1Kkee9suZwzfGum/mKFaQXD3PkFJfI5pmkOm/uyD0DOjJmQjGJlM3Dn0PVP7g
         H217JKTo+71bC5hbjuzh+nFwDxePqy0XjfQZ5mmtkItpvv/GEeYCM0d7qjNXo0od1tIu
         FeZiiHPeghao2aQ6b+78dGAJO3UDJ4NSFsDxJ3nEalLe+2JBXZqYpE5fFMSAgqkkjsnl
         qLRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762449416; x=1763054216;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XyqXd6ge5y2aj27CRXRh3J8Q1q4rd+TcymckOxNEG8A=;
        b=SovyDW8kE7KeL77hw6Ye7G/m9boXDhUwl+ucqGi+QsqoXa9L4WvsToHZsc0MHbt2r3
         9HhNR/zetnumYVO7cJlcemtRdjuCzP1RBBT6rDJKQuInwDyj8JqfmQJRpOYMkmI/n6uc
         gRUZQ5uKtq9XuneOSyC6n/gg9s5GrObPPb8NvLeyy/a6b/SuJsLZtY19lLg1LcqgE7ws
         ywtUFNY0nnLSH5M1RJlCqsiCHmoSIt0XxQ0mbRGJzFllMj4DZ1jCSFt04pykwnuQU5wv
         dTlURrF8n4Fp5vIzGzyndBwMvGLvDJJpuz7wEZx/zysqR26GGZLU4r/C1luSX1SecK/g
         xQCA==
X-Forwarded-Encrypted: i=1; AJvYcCWI8PSBtzTUFbfnAZg1M09kqHepM6XgOCioui5AHrc4YObpQoOwT8if8tjg3KNZKDMLAh/KnZs=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz4qFV2gmv9ISnDGEo4Y/pt1u0XG+41RamjC+aNmhLvkQ0gN3fo
	ypmiEeONYZd5AKFO3S+4iF3kgJbwYfyhClBlpdX6Z1cNdbAf3Nh5kTg+owZgeRqM3F0=
X-Gm-Gg: ASbGncvTW96lHOAqa/q3kL2QIllgryhJNh7PFemPfO6N0T/c3OAZla5iEgwxfptT14X
	ZUL6e/nPH3UAi8QqqVJWHIGMsQvBFrL7s0SkwCjaS4qbfdVA7kMRXqL8DDuLbgrKs0ca2sxletM
	MURNBdVpbSlDcEjVV9QkhHRoWGpE08CevtgGYdWaIsG1rrxBVFZtWiYOWKKr1Nwe3W9XzBVor9t
	lHRFg5U1+CGiwQlUnz9Oje/2laFS4N0XaAjheXLPA0dU8UD7PL0nQtoSmvjmB2jcbv9NyOiXuQD
	N5z2BpxwEy/Rmbrve2d0SXHVbFS1FPEIRi/ik0dMzZzMvOoppOc/2BUim80xxZ5ocA7n+u0lWeG
	w5lTU9tMeQN3N26oboKSYyCDPxCsMq8+dEjMQjBHbF11ATSWCpyfrX6EchPfCH9CpOt5EUL5XhS
	i8Hzaz2bfb7TZahHmrtfryC8zTYQx4aGtlZxFiqang8AyX8g==
X-Google-Smtp-Source: AGHT+IGm7rjI4btGT0uAp5U2+RTOpSSDx/JneJwxU99rel9EmV7Mer/iD0OJK3RWNsxIkY3fdHP+mA==
X-Received: by 2002:a05:622a:410d:b0:4e8:ac66:ee44 with SMTP id d75a77b69052e-4ed725e06eemr111576881cf.39.1762449415840;
        Thu, 06 Nov 2025 09:16:55 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4ed813b7ce2sm21908131cf.24.2025.11.06.09.16.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Nov 2025 09:16:55 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vH3bS-00000007OJk-2iYD;
	Thu, 06 Nov 2025 13:16:54 -0400
Date: Thu, 6 Nov 2025 13:16:54 -0400
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
Message-ID: <20251106171654.GV1204670@ziepe.ca>
References: <aMQmA9cLaeYWG5_C@willie-the-truck>
 <aNKwROPzDCWgJBGQ@google.com>
 <20250923173806.GF2547959@ziepe.ca>
 <aNppE9A3PDiDg_1W@google.com>
 <20251002151308.GG3195829@ziepe.ca>
 <aQt9-kTCe8TpuyVq@google.com>
 <20251105171208.GN1204670@ziepe.ca>
 <aQyBIohAuxNHV-XI@google.com>
 <20251106132331.GU1204670@ziepe.ca>
 <aQzSzhcndQ3Ry0a2@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aQzSzhcndQ3Ry0a2@google.com>

On Thu, Nov 06, 2025 at 04:54:38PM +0000, Mostafa Saleh wrote:
> Maybe I am misunderstanding this, but that looks really intrusive to me,
> at the moment arm-smmuv-3.c is a platform driver, and rely on the
> platform bus to understand the device (platform_get_resource...)
>
> You are suggesting to change that so it can also bind to AUX devices, then
> change the “arm_smmu_device_probe” function to understand that and possibly
> parse info from the parent device?

Yes, it is probably only a couple lines I think. You still have a
platform device, it just comes from a different spot.

I didn't it audit it closely, but basically it starts like this:

-static int arm_smmu_device_probe(struct platform_device *pdev)
+/*
+ * dev is the device that the driver is bound to
+ * pdev is the device that has the physical resources describing the smmu
+ */
+static int arm_smmu_device_probe_impl(struct device *dev,
+                                     struct platform_device *pdev)
 {
        int irq, ret;
        struct resource *res;
        resource_size_t ioaddr;
        struct arm_smmu_device *smmu;
-       struct device *dev = &pdev->dev;
 
        smmu = devm_kzalloc(dev, sizeof(*smmu), GFP_KERNEL);
        if (!smmu)

Probably needs some adjustments to switch places between pdev/dev, but
the ones I looked at were all OK already..

In the aux case dev is the aux dev, otherwise dev and pdev are the
same thing. devm related stuff has to dev.

> One of the main benefits from choosing trap and emulate was that it
> looks transparent from the kernel of point view, so doing such radical
> changes to adapt to KVM doesn't look right to me, I think the driver
> should remain as is (a platform driver that thinks it's directly
> talking to the HW).

I'm not so fixed on this idea, this kvm stuff makes enough meaningful
changes I don't think we need to sweep it all under the rug completely
fully transparently. If you need a couple of edits to the probe
function that's fine in my book.

Jason
