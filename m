Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79E013EFFA9
	for <kvmarm@lists.linux.dev>; Wed, 23 Sep 2026 12:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790165015; cv=none; b=OPTO7KXh+3w9W/K74LYtkyXhOt8HY95gp8BfdRu43MJS6Frm6Elj7BLWS0WHH3ARLB/GRTTaIc+roUtyvaNP/sQ0Iv6cjIoBrCHrcfDWj5hiN/p2C23q2tL4675wJYLAJVGRTvVGw+8JYQj9GEfD5JEKEIEbxlSMW24rvXyvxAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790165015; c=relaxed/simple;
	bh=H2NPzrrws0FqCnXLTgS7FTxVhyxjuGqZv7SYvPCD6qc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jqF+/IuWBSJL8fKpYm9onp1xFzfrTt438uNOzsrLQ9jAdhlT+wQ+JkSb76VXy56zz3k0e2EDS4BLDsEgLDLtlkNPyr+K2pwT5BEoXRDTuMXMhrMYQg6cPxOtjeIWh2z7m9s/kMkdwE1IJsuO5wNSytinCRw7P/tKHhgcQGc2vrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=M0bV8tDm; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="M0bV8tDm"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-49e6425f96eso40675e9.1
        for <kvmarm@lists.linux.dev>; Wed, 23 Sep 2026 05:03:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790165000; x=1790769800; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Jivi9KM6L+A+vDAYK+1HL6GBVOU14mX2y+wEPboH2kM=;
        b=M0bV8tDmFc2rwYUjd2lQTyVEtKfGUYLAFldZvttF8n7w4++srW4/Tm8dtW5567aESZ
         t3IvQjjws1RCEPQwrbIekEcOULK5ltwsZ31fnaP/OwQgOSG8x5YgpCp79uJKto8ucR3S
         7xlcF6off0iV8Gdch6uAOlecunBeXmoynOaUcZbHAchu2n+pUndQI6n82TvmWrKTJ4g+
         IeA1rXDO3Opej01N4Pe034scgq7+PMoP/XKjOd71e+Cv1iBzfUkt4zZ1W92+gaj4Ba17
         LXu1droOkbbHn0JI9tB83wlYnebXbUim2Ern9QP9AOEAOA5h73UKpCuyZZ9EllMHlE4q
         dlXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790165000; x=1790769800;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Jivi9KM6L+A+vDAYK+1HL6GBVOU14mX2y+wEPboH2kM=;
        b=Xo0e3M9xQ9tIaIfNuJh9cm3Q3b/46NQXh5PZwOOYo9E7R6y1DLrnx36O1cUAsh8iyX
         wu62aQKw38IaA5BZHNrVTewT+tq9Ft/qcqVRkSa2+xxO8eYZ+9fq2sBb3IdCoPbz3/zj
         XG371F866tfzjLrtUX/svggZes51xR43fkrcVvZDVivPep4SOvtoUpzDQGZFa8mthAq2
         v9jKVGXRlkTJxb4MomlJPyliTONGsMcM4qhXD6S6amWJLOUk+s3NArkO36e7o2ZbnafA
         PEwmXoBeihu4v68h0b62RKi3D0EozWg8eWpQfzh4Ha+I1bCaDr8SFSqbOwHa8R/QM3yK
         GQOQ==
X-Forwarded-Encrypted: i=1; AKwUvBxULbz9aIFqDy7ORNket5b/kgSFzt0X5IzJDe5aC63UBtU3AyyEWiLNWGDfLInfW0ZKv+w7jXE=@lists.linux.dev
X-Gm-Message-State: AFuF++maXZS+B4+HnQUKO7yXeiGO6FlJoZ+ND7mQxqEQUisOeu0zCGWz
	bC7/pOu1X8zGfuB8soYTbRKT3bMZeOl281qlOugMn6nCRsSK+7CdEozSo9bb0z/RvA==
X-Gm-Gg: AYBFou1lf8eDpHICwABCGxXlrAoghqA2+T57gLbpxsIcKQWHIfGk0bAAlDv85VlXs9K
	k6xXD1aM2AedVXnCIY89+G2IClLIJGafLngPmau//E0lxOMQ1IYdDzHDFeHrBlCsh5ISwpcsap3
	cf7V00lNl33plZ1GQUFvM4RzxPp2Pb63AH5L9Ytf/50fyukWE+mI46GmNqlTvtviieHAyTDgRDl
	VmDu7G01SnhyBdUwquvqIsfizEGh8YHNV+IxO+sMWhNwLzDJZ7nUIc+eLx0vs6w8xkwxMyNiIv8
	/VohRgH+oQXYf4ZEcqoqLwFdzeEQoD+GUVaYKP5katSWN/woh7zj7FpNAgdfvrQOoLHPOTaV4zm
	CpkR8I/KJKJBeSl4CVDXfLblJMkEQ6L3E8kOdkma+c6l1js4EwZGmUQjrDv0ZcCoo5jTCzQzFwt
	p73Ac68QIdp6Xy0nwAcNZ3llMqvcoAeSUy/I8N2hiwdZ7pQHFIpw3r9Z+9ycfgkUrJRdUJ47WOz
	18evkT/gebX10pLcPPiJ4fBEe7mpb5oN1UAB+bTgui2BfgK4J0=
X-Received: by 2002:a05:600c:35c3:b0:49d:24e2:5454 with SMTP id 5b1f17b1804b1-49fe0c4a230mr920275e9.13.1790164999501;
        Wed, 23 Sep 2026 05:03:19 -0700 (PDT)
Received: from google.com (250.192.189.35.bc.googleusercontent.com. [35.189.192.250])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fde1ccb90sm73291145e9.6.2026.09.23.05.03.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 05:03:16 -0700 (PDT)
Date: Wed, 23 Sep 2026 12:03:12 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, iommu@lists.linux.dev,
	catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, joro@8bytes.org, jgg@ziepe.ca,
	mark.rutland@arm.com, qperret@google.com, tabba@google.com,
	vdonnefort@google.com, sebastianene@google.com, keirf@google.com
Subject: Re: [PATCH v8 12/25] iommu/arm-smmu-v3-kvm: Probe SMMU HW
Message-ID: <arPAAK_O0d68dorh@google.com>
References: <20260922131259.2975334-1-smostafa@google.com>
 <20260922131259.2975334-13-smostafa@google.com>
 <arMu0An215TY3tM9@nvidia.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arMu0An215TY3tM9@nvidia.com>

On Tue, Sep 22, 2026 at 06:43:44PM -0700, Nicolin Chen wrote:
> On Tue, Sep 22, 2026 at 01:12:45PM +0000, Mostafa Saleh wrote:
> > +++ b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.h
> > @@ -11,6 +11,9 @@
> >   *
> >   * Other members are filled and used at runtime by the SMMU driver.
> >   * @base		Virtual address of SMMU registers
> > + * @oas			PA size
> > + * @pgsize_bitmap	Supported page sizes
> > + * @sid_bits		Max number of SID bits supported
> >   */
> 
> Some of them belongs to one of the prior patches.
> 
> And, if we are going to list them all, could we do in kdoc style?

I will fix it.

> 
> > +++ b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
> > @@ -29,6 +29,47 @@ static void smmu_deinit_device(struct hyp_arm_smmu_v3_device *smmu)
> >  	smmu->base = NULL;
> >  }
> >  
> > +/*
> > + * Mini-probe and validation for the hypervisor.
> > + */
> > +static int smmu_probe(struct hyp_arm_smmu_v3_device *smmu)
> > +{
> > +	u32 reg;
> > +
> > +	if (!(smmu->features & ARM_SMMU_FEAT_COHERENCY))
> > +		return -EINVAL;
> 
> Does this need to check IDR0.COHACC? If not, an inline note that
> explains why?
> 

This is similar to the kernel driver logic, where FW will override
coherency and in case of mismatch the driver will just WARN and trust
the FW.
pKVM can't print a warning as WARN is fatal in EL2. So it just picks
what the FW says. I am not sure what systems rely on this, but I can
add more strict checks and fail probe in case of mismatch with pKVM.

> > +
> > +	reg = arm_smmu_idr0_probe(smmu);
> > +
> > +	if (!(FIELD_GET(IDR0_TTF, reg) & IDR0_TTF_AARCH64))
> > +		return -ENXIO;
> > +
> > +	if (!(smmu->features & (ARM_SMMU_FEAT_TT_LE | ARM_SMMU_FEAT_TT_BE)))
> > +		return -ENXIO;
> > +
> > +	reg = readl_relaxed(smmu->base + ARM_SMMU_IDR1);
> > +	if (reg & (IDR1_TABLES_PRESET | IDR1_QUEUES_PRESET | IDR1_REL))
> > +		return -EINVAL;
> > +
> > +	smmu->sid_bits = FIELD_GET(IDR1_SIDSIZE, reg);
> > +	/* Follows the kernel logic */
> > +	if (smmu->sid_bits <= STRTAB_SPLIT)
> > +		smmu->features &= ~ARM_SMMU_FEAT_2_LVL_STRTAB;
> 
> The IDR1 reg guard and sid_bits can be shared with the main driver.
> 
> Maybe add an arm_smmu_device_idr1_probe()?
> 

I thought about that, but this will be only used for sid_bits, the
hypervisor struct doesn't have ssid_bits as it doesn't use it, it
only shadows the STE and not the CD as the CD is translated by stage-2.

Other fields also not used by the hypervisor (PRIQS, EVTQS...)

As sashiko pointed, I will need to add ARM_SMMU_FEAT_ATTR_TYPES_OVR
check in the hypervisor, so maybe arm_smmu_device_idr1_probe() can be added
to partially probe the register and return the value so it can be probed the
main driver.

> > +
> > +	arm_smmu_idr3_probe(smmu);
> > +
> > +	arm_smmu_idr5_probe(smmu);
> > +	if (!smmu->oas)
> > +		smmu->oas = 48;
> 
> The truncation can be shared with the main driver too?

The main driver will print an error, if arm_smmu_idr5_probe() fix it
silently we will lose that.

> 
> > @@ -43,8 +84,14 @@ static int smmu_init_device(struct hyp_arm_smmu_v3_device *smmu)
> >  		return ret;
> >  
> >  	smmu->base = (void __iomem *)haddr;
> > +	ret = smmu_probe(smmu);
> > +	if (ret)
> > +		goto out_ret;
> >  
> >  	return 0;
> > +out_ret:
> > +	smmu_deinit_device(smmu);
> 
> Nit: out_deinit

Sure.

Thanks,
Mostafa

> 
> Nicolin
