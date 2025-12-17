Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C30234E770
	for <kvmarm@lists.linux.dev>; Wed, 17 Dec 2025 14:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765980052; cv=none; b=qMFwLh1cr6q/u4dAW1jqGP0gj6xmXQ9cFGdRYZach+OoJzJ17CUGGmgMFNCIKTaJc3DI9Lvaxxw/F3NTiCfoc/azqCG/M10gr+qbbNA5B/3GXO6QlrF6h2ycpBNmW43tl+Zj+zFUVnZFAu+mXoR+E5HH7xJgDjy+6lUu+iKbi88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765980052; c=relaxed/simple;
	bh=Wa1BsId9QPfGeDLGHm5Ds6KJBFuQXBj9U+PxzlddFRk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mNceQGnWCe+v2hUJghrzmBjZmVBp8tz1EU1D9P7RefqSH4FXMNrOiykl8z3gyE+A1PmjY3z8Jcv/r3afI74KdaKh/C4gYA24kYYUN8PlrQ8lbEwK+0lMgWQBkzU5N/OljEL19c66QeWxmfiWn4AxrDNBTH/KNzQuCoZIDRhmXh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=e98xMo8D; arc=none smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="e98xMo8D"
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-4ed82ee9e57so75928561cf.0
        for <kvmarm@lists.linux.dev>; Wed, 17 Dec 2025 06:00:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1765980049; x=1766584849; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=mNOaMPGrnsuzc/K3PgD8W+kjT2zih8ixOp0jwu7uQa8=;
        b=e98xMo8DAhWZ6/+/Qi6uyV2yVyOOtnNl/mzZ4Dqj3M4nYhe9W6/GPOEuFNLpgrk19/
         IWRJ/UC51OPz+6nNb7Z+1GkJxJfkUCO0My9gRd2DG5+lktSkGs8JwpYLMDzyRtNDXdJD
         xauwTSZcdmIbeEE06hH4Z4fWnjGwfFMvzdvPeGrldqAUubcDmMngy/ZvSRwulL/NzvQj
         kSBuw2cebg68ulJno1XvF8goBU1w/uX7rtg3yz5NU6aG4gCxItvTX/ng1R04uCOVjIII
         pGpbZBeyOFHiN1vNP28VCoaYjq+K8ug16d7qxUtXtW/iH5IDKkOUP/bCMIgw6yFXweES
         OGKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765980049; x=1766584849;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mNOaMPGrnsuzc/K3PgD8W+kjT2zih8ixOp0jwu7uQa8=;
        b=soYw+cTqIZOo+Ym066Rs6kR/3U7JDM81L5plmS1QDYCN49TXtAP+7MAibX250zXS5u
         4Fj7UtGz4hSFuoslTW7SYLWDWmdL/1HahvozWqC/9WnuuhimNkpTL5QY1/eTBiIxEYR6
         bSUdmXf/Ser9ZLjufTjulXx9x5a8Cxq7dFbG9O/MELP5+Ymra754KnZF8e0wthTAJ+32
         6Kfs7KFeuJw4nbXBb8ZaRqA6dnTeRvqswCj1R8LnpT1pKhcv4lbvdQFdc6fVm8s6WSlR
         10wMI7tTy3DTxNGIgTgV2N4S25pez4AilAuosk99q7FJ4mwyF/Xmy4plS1yx5uv16HOU
         hrRg==
X-Forwarded-Encrypted: i=1; AJvYcCVTFRELBr444GS8lTn40UMMu/+57UFpqQtud1zU2z6qLi7FORW6Ku3UJ8e+dIDlOz1LsGD3MMs=@lists.linux.dev
X-Gm-Message-State: AOJu0YyGmkMn633OAl9Yrx4iUtd5qNY6xjXWYyZcZ0qifuAFr4jFKQNi
	K1UA/BoSbPknmSqP+n3qZalA0R0npNq2MFRmmfhHgizxhhm+3gJIDfDcBeXPWe6cFac=
X-Gm-Gg: AY/fxX4c4agOSavX/vh625zTaxMf3menGXoc4if/RCxDeZ6sTlYVhIsKno0bHGIuVJ2
	qZdJQGidnlUyPkyoCXK21IwLeAr8xMyxnTkloFMfqFg8+yFMNULyjIH8Ovd1Qu5Jo6USsbohDSq
	W7CF6INtm5NiXeRWlvOeK7CKFolVSvHKB/fmxjmVzt/H+ZhIjaUx2OxGZ8qoo5iYnCHlCx2PWhJ
	aVL1DiO8FdnXa0KrwflzS1ArsT7ysZgxXqEFFW1FKIJ/iA0X/az4S0vNke4JtkPul3l77aTuKMC
	K6GaCYnxYFYEgSYaWNRi1xOZ4Oa+uh1V8zmepMV1LECVcwH0NIYw0T/Lft33kM7G8lGR6UVHfK6
	IkFr0JUJzh2L7mpEqZ0t1+XYnDsjtRs2d9kf7Hm1sHi/LOvrb2G+xrhFKVzLVFj5FKUw9jQOA3/
	zpxYpoU17enMTRYBw9fVIsgbfahB1EhkZRZWdJIy7eFT63AbAiMTMHW3KB
X-Google-Smtp-Source: AGHT+IEn7RK/pIYtYXrPbKMGVYlcUHkadYn8QaTKBX4Kd2HwfE2NzoNCX8QU7VpeXmpS/UZ6Pqr5SA==
X-Received: by 2002:ac8:7515:0:b0:4f3:4c1a:4c49 with SMTP id d75a77b69052e-4f34c1a5041mr45692141cf.48.1765980048007;
        Wed, 17 Dec 2025 06:00:48 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-889a85eaf02sm95103076d6.40.2025.12.17.06.00.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Dec 2025 06:00:47 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vVs58-00000000fUk-3YUQ;
	Wed, 17 Dec 2025 10:00:46 -0400
Date: Wed, 17 Dec 2025 10:00:46 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Mostafa Saleh <smostafa@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, iommu@lists.linux.dev,
	catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, joro@8bytes.org, jean-philippe@linaro.org,
	praan@google.com, danielmentz@google.com, mark.rutland@arm.com,
	qperret@google.com, tabba@google.com
Subject: Re: [PATCH v5 14/27] iommu/arm-smmu-v3: Support probing KVM emulated
 devices
Message-ID: <20251217140046.GF31492@ziepe.ca>
References: <20251117184815.1027271-1-smostafa@google.com>
 <20251117184815.1027271-15-smostafa@google.com>
 <20251128165616.GD812105@ziepe.ca>
 <aTw6afum4eqr5_e7@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aTw6afum4eqr5_e7@google.com>

On Fri, Dec 12, 2025 at 03:53:13PM +0000, Mostafa Saleh wrote:
> > It is OK I guess, I wouldn't insist you change it, but I think it is
> > kind of gross. Registering the iommu driver against the platform
> > device instead of the aux is pretty ugly and denies userspace the
> > ability to see that the hypervisor is sitting in there through the
> > sysfs topology.
> 
> Yes, that’s why I was wondering if it’s better to keep this as a platform
> driver and create the aux devices for the parent(KVM) but that was really
> complicated to handle the probe ordering.

That sounds worse and inverts the required probe ordering.

Attach it to the aux device :\

> > Not sure why the commentary about built-in though, what does that have
> > to do with anything? If the aux driver is not built in then it will
> > just module load later and everything should be fine?
> 
> As at the moment the KVM driver doesn’t use drvdata(nor any device
> resources) and the main driver(aux) does, but if that was a module, we
> can’t know which version does what (if that changes in the future,
> although unlikely).

Kernel is monolithic, you don't need to worry about people doing silly
games with modules.

Jason
