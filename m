Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64516353EEB
	for <kvmarm@lists.linux.dev>; Mon,  4 May 2026 12:30:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777897841; cv=none; b=uW2i4V5PdCv2lIvI+ZzFEsSfYPF8cyvwm0aYHKqmPLeZDWvdxttq6U8NiK9xfLHENwgY5HQKXQdjkqdcejz1hbiKLO0z1OEfs9P1p1CTp8P5/ZMlwjBpBPfWfAqPBSHcLUhG24uu8CXHuUzjpEVdPLOz1O6N/QkZjNS8ivKJYaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777897841; c=relaxed/simple;
	bh=4ZOBMscc1HOs7kCpJsHpKzdFOrZP/gFzsttOdLIt+CQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fXKdUueDNJYkjMWUaOa9FB7G6URcJIsemZ5zVWdu3ff4xHZczXhfeRfKT8O50/wAMu4XqBmnwTHZ8f/QM/Y97TG4j5SR4Xg1AK75HMMZ2q9ZqeKnyH/y424Xk1avUQAl5gDBLqZQ7tCZC6ONgdTKXoLBPpgdKkBGmxQ0Q9GEeI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=v/E8mNj/; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="v/E8mNj/"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-488940ccfa6so171335e9.1
        for <kvmarm@lists.linux.dev>; Mon, 04 May 2026 05:30:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777897839; x=1778502639; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qOfQTG3NufNYyUm+WMPkXEQQNupQgi3c8ZHhQrRCx6U=;
        b=v/E8mNj/ljFvZDn/cR2FRurYlhqqWpjW1sbHLoYnsnDSGD6xifYCkZztpI76eixrpL
         7It8Qx0dQAGppsUgSWG70yYcTtTnZgw3qVEIx6fY6+Daino0ZB5cOgkkD4mgX+HHBjnz
         0QHacvpHEmDsJd3a3WTVC9F5cjEdbf+VnAt5YS9tpzXI4qhjtpIRX5pQ3MJQlcr9SU35
         noEvu5ou5DB5RtD1NH2MiOU/R2cOQ/RddZ+9RXEY1tjAiCVrgjqz8P3cG5HWUCagtDLT
         XSysGoNN9TP/xv4Jt0cKgYo7un2TC4HjaatS9YVqAzdyek9cEPFVQp43eUSa01z9RNcw
         VTfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777897839; x=1778502639;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qOfQTG3NufNYyUm+WMPkXEQQNupQgi3c8ZHhQrRCx6U=;
        b=TcDsyVesNeAIXfAueIVSr7LTFnLpTC6MYF4MMBHtIh84qmDEWlEjhwZqxLyfdxCjT8
         8N8O7RV4R1Mfuzs4PLYmgj79w23p0nxTGDQKALF6bMqwABAO9cZ4AAWD8o+hS+lU9H1v
         F7ewfhHwpQzQ4dUvHf5PtvDwBMbuzG+wZbzcESUAOLYzFbyWq2eBVQ2c/eWkpbcZznvV
         xVWpiYNQrr6MElOkQfVp4rGqoqRa0y0UO4RL6P9bA6B2f+DtKjAguNt0W5hvhtfw9eCg
         aJkvqn7gZosABk0oKTqJPnh7ihvrgJbgRPZOhHfGmzZEwdromukD4PY0SOoxflDJ61tV
         o5pQ==
X-Forwarded-Encrypted: i=1; AFNElJ+UB4nOZt1KToZhHlKm+O94m5MZ+W07XHGy3f+p8clzU7Ktr7Coj+I2mMOebz/rHyw9Z6a/XSc=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyr07/9qBhwak0yIqO+gYCF2Jqd0c/VSe0zdhtFvOSaSlHqDg67
	OgzhKfZzP31Gmc1plbFzJunDyPd5mDkbQbmcgEt+AhvjPgsOmS/Ko+4rEU5B7Gs9Vg==
X-Gm-Gg: AeBDieuOK4q/17kzVCtBSVE6wG74krdYCQcCpMBdCLCZSVQCHiGMITULcB3iqZ8ti9l
	4na5Gao9B35sFof4JoyKXALhWPjKvtFUszg0N6Ct4k9dzNso8MgL0ii1AgEhzjuXLyzgz7o5c7j
	SbfW7oJOlwS1MDU80XNhxJpUaXy153DqjsZSckXE+vVu9LSc16C6V9vkRq1etvrKZWDlFHcIq5D
	lwfJdG0dcrQCVRias5YvQWGYBsq7ufhStcRzceyikibuzRIX0vuu8oQYoo+WISB8bsCPhpXl/Xw
	lZITxtH8A80T3urvwLITfjERQ3MY90iNV3BfWdCY7M7+dsX8S3LCm8KA9wMAr8GS561t4E60hkV
	kG9/GOcVMr7oIL2gAtrmv3w0sIM88O0+lDpyEILRwrHEyafGhUTduv4nx7z72A8l1HNnOeTyio1
	FWPltIqANU5NKJVfWN5H1NL6lGxWU7hKUNMVqlwg8uSsOdiHNtrKn3gXwrsyRxI3Kfhire7Ppc3
	cjaLg==
X-Received: by 2002:a05:600c:63c4:b0:485:b6e4:9808 with SMTP id 5b1f17b1804b1-48ac315a359mr2185965e9.1.1777897838152;
        Mon, 04 May 2026 05:30:38 -0700 (PDT)
Received: from google.com (8.181.38.34.bc.googleusercontent.com. [34.38.181.8])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a8fee32fesm113417605e9.3.2026.05.04.05.30.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2026 05:30:37 -0700 (PDT)
Date: Mon, 4 May 2026 12:30:33 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, iommu@lists.linux.dev,
	catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, joro@8bytes.org, jean-philippe@linaro.org,
	mark.rutland@arm.com, qperret@google.com, tabba@google.com,
	vdonnefort@google.com, sebastianene@google.com, keirf@google.com
Subject: Re: [PATCH v6 13/25] iommu/arm-smmu-v3-kvm: Probe SMMU HW
Message-ID: <afiRaQRmu7Evbzfn@google.com>
References: <20260501111928.259252-1-smostafa@google.com>
 <20260501111928.259252-14-smostafa@google.com>
 <20260501125148.GE6912@ziepe.ca>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260501125148.GE6912@ziepe.ca>

On Fri, May 01, 2026 at 09:51:48AM -0300, Jason Gunthorpe wrote:
> On Fri, May 01, 2026 at 11:19:15AM +0000, Mostafa Saleh wrote:
> > diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> > index 61e6ab364086..157acde0436d 100644
> > --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> > +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> > @@ -4738,12 +4738,6 @@ static int arm_smmu_device_reset(struct arm_smmu_device *smmu)
> >  	return 0;
> >  }
> >  
> > -#define IIDR_IMPLEMENTER_ARM		0x43b
> > -#define IIDR_PRODUCTID_ARM_MMU_600	0x483
> > -#define IIDR_PRODUCTID_ARM_MMU_700	0x487
> > -#define IIDR_PRODUCTID_ARM_MMU_L1	0x48a
> > -#define IIDR_PRODUCTID_ARM_MMU_S3	0x498
> > -
> >  static void arm_smmu_device_iidr_probe(struct arm_smmu_device *smmu)
> >  {
> >  	u32 reg;
> > diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> > index 64618299d03a..f904f4d19609 100644
> > --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> > +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> > @@ -84,6 +84,12 @@ struct arm_vsmmu;
> >  #define IIDR_REVISION			GENMASK(15, 12)
> >  #define IIDR_IMPLEMENTER		GENMASK(11, 0)
> >  
> > +#define IIDR_IMPLEMENTER_ARM		0x43b
> > +#define IIDR_PRODUCTID_ARM_MMU_600	0x483
> > +#define IIDR_PRODUCTID_ARM_MMU_700	0x487
> > +#define IIDR_PRODUCTID_ARM_MMU_L1	0x48a
> > +#define IIDR_PRODUCTID_ARM_MMU_S3	0x498
> > +
> >  #define ARM_SMMU_AIDR			0x1C
> 
> Lets put these hunks in some earlier patch to migrate out the
> functions/etc
> 
> I think all these pkvm/arm-smmu-v3.c should just be building up the
> driver.

Will do.

> 
> > +static bool smmu_nesting_supported(struct hyp_arm_smmu_v3_device *smmu)
> > +{
> > +	unsigned int implementer, productid, variant, revision;
> > +	u32 reg;
> > +
> > +	if (!(smmu->features & ARM_SMMU_FEAT_TRANS_S1) ||
> > +	    !(smmu->features & ARM_SMMU_FEAT_TRANS_S2))
> > +		return false;
> > +
> > +	reg = readl_relaxed(smmu->base + ARM_SMMU_IIDR);
> > +	implementer = FIELD_GET(IIDR_IMPLEMENTER, reg);
> > +	productid = FIELD_GET(IIDR_PRODUCTID, reg);
> > +	variant = FIELD_GET(IIDR_VARIANT, reg);
> > +	revision = FIELD_GET(IIDR_REVISION, reg);
> > +
> > +	if (implementer != IIDR_IMPLEMENTER_ARM)
> > +		return true;
> > +
> > +	if (productid == IIDR_PRODUCTID_ARM_MMU_600)
> > +		return variant >= 2;
> > +	else if (productid == IIDR_PRODUCTID_ARM_MMU_700)
> > +		return !(variant < 1 || revision < 1);
> > +
> > +	return true;
> > +}
> 
> Why not share all this errata stuff with the idr parsing code too?
> 
> We already have ARM_SMMU_FEAT_NESTING that has the above calculation.
> 
> The two drivers use the same ARM_SMMU_FEAT system, I would expect one
> chunk of shared code to compute the FEATs, who cares if pkvm doesn't
> use all of them?
> 
> Use the same errata logic and so on to get to the feat bitmap.

Makes sense.

Thanks,
Mostafa

> 
> Jason
