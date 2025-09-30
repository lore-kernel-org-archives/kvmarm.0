Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BAFF1F91C8
	for <kvmarm@lists.linux.dev>; Tue, 30 Sep 2025 12:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759236920; cv=none; b=OWi3zele8vysXftrwcj6Ey53DDmg/YNdG4gKjUk1k7ejnIr12FY5ZmffUt37fzCN6AlSRvJZh0coirKCl6FH1RDL9gguz4MZHSFfHACTnNammx5TEIb1YKYJWd5H/VfKI19df1ttZJFHlD0zUsKrAl21Sa6x7rogby8wA31DeRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759236920; c=relaxed/simple;
	bh=okTR4CFO8MIzrLxFXPLqjpVRU4bOViPDogPk46r3FDk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AgdnOqaJz8aSAHKGp9XND24ZxxWHwZeKMk1FullV8oNAFQqDs4Kz9zE24oOlyzl0Nfw4tDP4O+eauXJArgoykak5Ubbm7LftQbaLz6ALKCvU5IIqS8kD0lmkIke8NZXONeWpPLlq/hCZfepSxh2n5FKAWTV+8tt97EIqv+d6MNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=La9022dn; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="La9022dn"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-46e32c0e273so51325e9.1
        for <kvmarm@lists.linux.dev>; Tue, 30 Sep 2025 05:55:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759236917; x=1759841717; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9r+cvVvthJeda6jwwlkAlFYev3VYphC/LLXDxRNEd7E=;
        b=La9022dn9+WG7mJkkQdH0VqzD0lpzfBZMJW+UaFabR+/uO8tRtwPqYu9nK2AnjKNID
         UeigeBWlcuUcv2KdjgN3cmFRtFNKCDSDx6ox5HMfedrBRZRLD1UlQmN7PnisCY22MdCO
         owfpW8l/TPykr4LvmnhKKBsvndfrMvLfl7Cr3finA+ew+dtk1oB/3SR7WgasIr/gKvuj
         eSc3Llg9DkgoJdQpqJ/VL+YpA1bTnazI7KJ5Bl5+jUNjYdz/obR+yMgIhuqhhboe1HTC
         yx3GhqgjgrOaT9SIadk2SYOMLOnnO4sZaoBG7Sya6S6KfYVFgx4VK8aXN4SkajYDlwqU
         ILRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759236917; x=1759841717;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9r+cvVvthJeda6jwwlkAlFYev3VYphC/LLXDxRNEd7E=;
        b=mnroD4pqS8qOi8te5pA57TImIoqa0BVsrVwLjS8AgSyx039YSs1O1BZCW2DlcFRZUO
         awl5Oyy9ooA23MWhqRs6DVjG5a96ggxBZAfCyzRc4btsUoczTDW7Neo4zQbkIUQkCIil
         Ew9KfNya4uCKxVheFUisNhG9Tr1RO4tQmt99yV+0/ZqKdz9gDTeNl4V0D5yOKDyNuaRl
         lMEy/1QUqwbjtanDP+VZJJP6Qz9BcqFwHMc1J1UrtoJeTa7IlfGQEDxej+xKv5d81zYe
         Q3DEgj40d8Z2ANO49rtvDjdH7iHRszabt/Y5eJPcR8ySO2SVgaEC+3WE+eGZ0Ucf/EOd
         NxVw==
X-Forwarded-Encrypted: i=1; AJvYcCVrDYRWnjYwYTBnMXp9koZ2wKojiJSMAb1Vd8ooNDBVSESqA17i2sd1cJrZeJVTMXNTBAyYhsk=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx06k9sOKsHibRNyLc12tDfcOJyc7FV1QXuPWpqo4BjDk7Uzq91
	70v+5yB97Rp4hUNxc71kW3QRrZmoZBeFx+JgsqZ4Npnf/HwmZS29cG+Q5EJmpb3hNA==
X-Gm-Gg: ASbGncvNF/g/ZX/GAHprPriMGu4TPQsm9PgPP9lsm4am0AHAnAMpkHAacKjxJnDGT4g
	ur8NvpSep4VO335DKTT5RnRACnyj7uGBtZ8UhBEtQglTpkPCLhE+v5kSN/4uyY8p7hx3Pjoy+wf
	TD2SESsvwGIAsz4zhM4WLL2Ox/uAXxADLGCknKuasSKvsaO0ZFcgm3M2FkXGrRNC06m31t286Nm
	emo0enR4oObP2Zy56Gzy99CO0QbbcJhFxInkV9affCr3vPP6OW+iShBglDDSBufzMNWLo44EO46
	UDk0XUKdZrcvhKczKTed/ZQICdsSI9vgpBFYKs1WJPVc8v+6bDs0Jds4hgJhXlvsZHXdl/hHguw
	9ZCXUe7XCtzKAL1lMNNYrX7A7MOZOe1PYUjkISSTn3vjvTqwzjC8CH8I1HDjaNPTqBEFy+C4i+V
	JsoIXNKAx6oxdpOpWnIWDsp/nAUQ==
X-Google-Smtp-Source: AGHT+IGGZCxjhudadmu4TvjrKZEZvXrYowNUd3ws5uFCLuqdd4dGNuu0nzAp9pr9x9cv/JDPj1LoPw==
X-Received: by 2002:a05:600c:63d6:b0:43d:409c:6142 with SMTP id 5b1f17b1804b1-46e59bd9020mr1747905e9.0.1759236916661;
        Tue, 30 Sep 2025 05:55:16 -0700 (PDT)
Received: from google.com (140.240.76.34.bc.googleusercontent.com. [34.76.240.140])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-40fc5602dc2sm22503716f8f.32.2025.09.30.05.55.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Sep 2025 05:55:16 -0700 (PDT)
Date: Tue, 30 Sep 2025 12:55:12 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Will Deacon <will@kernel.org>, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	iommu@lists.linux.dev, maz@kernel.org, oliver.upton@linux.dev,
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, robin.murphy@arm.com,
	jean-philippe@linaro.org, qperret@google.com, tabba@google.com,
	mark.rutland@arm.com, praan@google.com
Subject: Re: [PATCH v4 10/28] KVM: arm64: iommu: Shadow host stage-2 page
 table
Message-ID: <aNvTME-Fmw8lpT25@google.com>
References: <20250819215156.2494305-1-smostafa@google.com>
 <20250819215156.2494305-11-smostafa@google.com>
 <aMA8vz0v0Vn-02QP@willie-the-truck>
 <aMlzLsj5slPQhWEr@google.com>
 <aNamXlTErXDs1K8Z@willie-the-truck>
 <aNpm9odmzv__2RyA@google.com>
 <20250930123839.GL2695987@ziepe.ca>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250930123839.GL2695987@ziepe.ca>

On Tue, Sep 30, 2025 at 09:38:39AM -0300, Jason Gunthorpe wrote:
> On Mon, Sep 29, 2025 at 11:01:10AM +0000, Mostafa Saleh wrote:
> 
> > > If the SMMU is in stage-1 bypass, we still have the incoming memory
> > > attributes from the transaction (modulo MTCFG which we shouldn't be
> > > setting) and they should combine with the stage-2 attributes in roughly
> > > the same way as the CPU, no?
> > 
> > Makes sense, we can remove that for now and map all stage-2 with
> > IOMMU_CACHE. 
> 
> Robin was saying in another thread that the DMA API has to use
> IOMMU_MMIO properly or it won't work.. I think what happens depends on
> the SOC design.
> 
> Yes, the incoming attribute combines, but unlike the CPU which will
> have per-page memory attributes in the S1, the DMA initiator will
> almost always use the same memory attributes.
> 
> In other words, we cannot rely on the DMA initiator to indicate if the
> underlying memory should be MMIO or CACHE like the CPU can.
> 
> I think you have to set CACHE/MMIO correctly here.

I see, I think you mean[1], thanks for pointing it, I think we have to
keep things as is.

Thanks,
Mostafa

[1] https://lore.kernel.org/all/8f912671-f1d9-4f73-9c1d-e39938bfc09f@arm.com/

> 
> Jason
