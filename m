Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2868470136
	for <kvmarm@lists.linux.dev>; Wed, 23 Sep 2026 10:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790158155; cv=none; b=pcJrunaN1TeH9/weArSxdw9sRBjaHyiH+ZClVogRjxS2gltFKTZW+9Vuof8UNeCDaMO01Dv4mEmjdd+tfM0r6QTngdoI46wZgY0JShupdZZT9vK2Ou5IhzOh8eB/jUK62m4BdzQJqTVQCaFsUSIyFzP/Fd2YO34sOO7mynqfmV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790158155; c=relaxed/simple;
	bh=dX32iWje+JqeUCtYEXFI4UI2X1O0o2NEVWa/1KzRUAQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nmvP6pCZaC/mwj5RC7E/2S0gUBipSJ/B1imMxhepcAOsM+z71y3fUKDSJBADCEbRCls+ITIL/nkHu/nvwQrCXhFnbbcxFZwUYCYDTAuDe0Q8MtRJCgJYPWL2640VStZTbysAXr+g7SXD71sSByDij/BZ+tn1oAatiYNDmMiaJXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=j1y7B2o2; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="j1y7B2o2"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-49e6425f96eso35565e9.1
        for <kvmarm@lists.linux.dev>; Wed, 23 Sep 2026 03:09:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790158151; x=1790762951; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=NMB6bu75t+ZZ5TxFVUnvCCWgfugEUPmSZZ3Ssad5w0I=;
        b=j1y7B2o2reYUqZ/d89Z/ztwQuBalbNuxv49NG2OD3LCe+y+X3GBJJpeJX2uDw2Se4J
         OGLKSOfTfzS7CsfhK0ou3dq0NIk3WI16I3r80IT/09ckUp1C2coiIXkejjD16FwaMRoc
         57LPN4uJ+EgcnYEVsVZK4j7sqFZhEAG4tFO9zSAJuQzKTaBNZb/SqbNRpV0lxEo2NRYS
         8kHO7oVmhEQP6IWv1AggstMkwmLIniBsAdPCUz3XhjHfDFW1quGZ6c+u7jkYOch8Fgw0
         uzKrXF5zSd3QCisgW8AxrFu0Wiqqh7Q7BesQTJDyCIf3q6YFOBWV2Pdxyguj1xU7YJOQ
         Mh1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790158151; x=1790762951;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NMB6bu75t+ZZ5TxFVUnvCCWgfugEUPmSZZ3Ssad5w0I=;
        b=dK8TWzpDNYnnnwU9BNmVJ6C8no4pWFHjXBhzz4bFZ5uX8/KYJuwiyw0gUHdBKcRY9r
         iM4AGjsuug+DPhBIPlQ1kpDMztR0+8MmHq8HX/HoZqOENlbV5dkHnBkJL1urVhCoi5++
         dia7WULU5+47tySlZ4gP0rnvmeq+iucXmNN90lzWo69DHWokwBPaUz3GwxBcbn/C/8za
         sKp/W1VAUXHBXhZsOVSb0xKQXj1UFcYk5E5PcoviRLnAs4TpkjdrtVS12hva9Z/BPhje
         Dd0wPYJVnzXxkZw8K84ETlJrHDOz27yccMJKHzGt84Vbvpn1z85WTcu2rVqLdTjVVQPs
         Wckg==
X-Forwarded-Encrypted: i=1; AKwUvBz4HzRZJG2yloARCyNMZwDDtrDgm/CWn6KZaGcYLbBCa0fD5J5f6WZiCWIkBET+bx84ZALbmDs=@lists.linux.dev
X-Gm-Message-State: AFuF++l+tOLECqvGR9vSnVvpjDo2LFLfn4S9J+1Dhw6HoWPU7z66wT5K
	1k/QP3kCS+nzRW16xBM09JyIKzhu5caHWo/W8XopsSYR1Y5TSvgjv65FsJr9X00eow==
X-Gm-Gg: AYBFou0fkIemzng+18v2Y/Kvulbkn6UoBhZqimnJ+SifKGd6Fbdue8YBFKIvGEDq8bo
	pIW3YAyhKNDY4SihZfAmyJtPM63MFKlJ0jgxuw83EjpZy89mdehWSpS9WgY0Q6UYcAzROIDsS/l
	tDiUWLI1Kjrvwbav703f9NivXMoFfy4SoEZO05h4P0Nka9JGMPn7HBw3S9xVuAdG+Tjj5R7azMR
	rNXMojxNbu4TFdR6x0weKOKRLz+byhdCb15CECq24WT3fyIGI7rCat97yPudaCm4nzriYeC8sYs
	TWN2eZ3Jmugs4zfndVU6fueDgiJsTvfeGnyT0cAxrgnuQ1XKBDYmmcRSyScnXnMCLVmEQnmzs5v
	TDJ/cMLeP+Kz8GNyEAIkB8unEULFuYwu6mGGLXg8c3NpMV4fipDyCXXON9pMGtiTTmSVYNrASI8
	uHts/kU3fBRzWtpNNkPj5rDccbsvB3kalufdAdBJBE+EPHfneQqeM4hudBp8cznADzf1H8k3pCJ
	exsUxkHNPp0gnDNXBFDZDPDjTgahJrsfLuJaKYJtNwXxBCHUU8=
X-Received: by 2002:a05:600c:8588:b0:49f:e185:f3ae with SMTP id 5b1f17b1804b1-49fe185f460mr486475e9.2.1790158150774;
        Wed, 23 Sep 2026 03:09:10 -0700 (PDT)
Received: from google.com (250.192.189.35.bc.googleusercontent.com. [35.189.192.250])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fde18555bsm68255055e9.2.2026.09.23.03.09.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 03:09:10 -0700 (PDT)
Date: Wed, 23 Sep 2026 10:09:06 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, iommu@lists.linux.dev,
	catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, joro@8bytes.org, jgg@ziepe.ca,
	mark.rutland@arm.com, qperret@google.com, tabba@google.com,
	vdonnefort@google.com, sebastianene@google.com, keirf@google.com,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [PATCH v8 04/25] iommu/arm-smmu-v3: Move IDR parsing to common
 functions
Message-ID: <arOlQtPYzF5yT8fP@google.com>
References: <20260922131259.2975334-1-smostafa@google.com>
 <20260922131259.2975334-5-smostafa@google.com>
 <arLa0E3xq5dGuPpd@nvidia.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arLa0E3xq5dGuPpd@nvidia.com>

On Tue, Sep 22, 2026 at 12:45:20PM -0700, Nicolin Chen wrote:
> On Tue, Sep 22, 2026 at 01:12:37PM +0000, Mostafa Saleh wrote:
> > Move parsing of IDRs to functions so that it can be re-used
> > from the hypervisor.
> > 
> > As the new functions operate on structs from both the hypervisor
> > and the kernel which would be different, we rely on the compilation
> > unit to having ARM_SMMU_OBJ point to the correct struct; some
> 
> s/to having/to have

Will do.

> 
> > best-effort static asserts were added .
> 
> s/added \./added\.

Will do.

> 
> > +#ifndef __ARM_SMMU_V3_COMMON_LIB_H
> > +#define __ARM_SMMU_V3_COMMON_LIB_H
> > +
> > +#include <linux/build_bug.h>
> > +#include <linux/compiler_types.h>
> > +#include <linux/kernel.h>
> > +
> > +/*
> > + * The IDR probe functions are used by the kernel and the
> > + * hypervisor drivers where ARM_SMMU_OBJ might be defined
> > + * differently.
> > + * Ensure fields used by them are defined and has the correct
> > + * types.
> 
> s/has/have
> 
> We have 80 cols per line to write comments :)

Will do.

> 
> > + */
> > +#ifndef __KVM_NVHE_HYPERVISOR__
> > +typedef struct arm_smmu_device ARM_SMMU_OBJ;
> > +#endif
> 
> It's probably safer to include arm-smmu-v3.h so everything would
> be self-defined.
> 

Yes, I was not sure about that, I was thinking of making this file
included strictly after the struct is defined first but I didn't
find a suitable place for that.
So, I can just add the include here before the typedef.

> Also, Jason's suggestion in v7 was hyp_arm_smmu_v3_device, which
> looks nicer than ARM_SMMU_OBJ...
> 

I think having another name makes the code more readable (not sure if
some tools can be confused also) than renaming the hypervisor struct
to the kernel one. That makes it clear what is the intent of this.

> > +static_assert(__same_type(typeof_member(ARM_SMMU_OBJ, features), u32));
> > +static_assert(__same_type(typeof_member(ARM_SMMU_OBJ, options), u32));
> > +static_assert(__same_type(typeof_member(ARM_SMMU_OBJ, oas), unsigned long));
> > +static_assert(__same_type(typeof_member(ARM_SMMU_OBJ, pgsize_bitmap), unsigned long));
> > +static_assert(__same_type(typeof_member(ARM_SMMU_OBJ, base), void __iomem *));
> > +
> > +void arm_smmu_device_iidr_probe(ARM_SMMU_OBJ *smmu);
> > +u32 arm_smmu_idr0_probe(ARM_SMMU_OBJ *smmu);
> > +void arm_smmu_idr3_probe(ARM_SMMU_OBJ *smmu);
> > +u32 arm_smmu_idr5_probe(ARM_SMMU_OBJ *smmu);
> 
> Can we use "arm_smmu_device_xyz_probe" matching with the existing
> arm_smmu_device_iidr_probe?

Sure.

> 
> > +	if (coherent && !disable_msipolling &&
> > +	    smmu->features & ARM_SMMU_FEAT_MSI)
> > +		smmu->options |= ARM_SMMU_OPT_MSIPOLL;
> 
> Will pKVM ever use MSIPOLL?

No, this version does not support MSI and hides it.
And this check can not be moved because disable_msipolling is a
module_param.
Although it might be possible to pass it as an argument to the
function and assume (smmu->features & ARM_SMMU_FEAT_COHERENCY) is set
based on FW before the IDR probe similarly, no strong opinion, so this
part can all be moved as is.

> 
> > +	if (smmu->features & ARM_SMMU_FEAT_HYP &&
> > +	    cpus_have_cap(ARM64_HAS_VIRT_HOST_EXTN))
> > +		smmu->features |= ARM_SMMU_FEAT_E2H;
> 
> Why is ARM64_HAS_VIRT_HOST_EXTN left behind?
> 

cpus_have_cap() can not be used in the hypervisor.
Also, ARM_SMMU_FEAT_E2H is not exactly FEAT_HYP. As it defines the
world the translation lives in based on the kernel EL.

With pKVM at EL2 ARM64_HAS_VIRT_HOST_EXTN is always true anyway.
And the hypervisor never owns a page table itself, so it never
checks this feature.
Otherwise, I think we can move this check and use cpus_have_final_cap()
instead as it can be used in the hypervisor.

> > -	if (!(reg & (IDR0_S1P | IDR0_S2P))) {
> > +	if (!(smmu->features & (ARM_SMMU_FEAT_TRANS_S1 | ARM_SMMU_FEAT_TRANS_S2))) {
> >  		dev_err(smmu->dev, "no translation support!\n");
> >  		return -ENXIO;
> 
> This change seems unnecessary. The code above and below this line
> still uses "reg" returned by idr0_probe(). So, the original code
> should have read well:

True, I will change it back.

Thanks,
Mostafa
> 
>         if (!!(reg & IDR0_COHACC) != coherent)
>                 dev_warn(smmu->dev, "IDR0.COHACC overridden by FW configuration (%s)\n",
>                          str_true_false(coherent));
> 
> 	if (!(reg & (IDR0_S1P | IDR0_S2P))) {
>                 dev_err(smmu->dev, "no translation support!\n");
>                 return -ENXIO;
>         }
> 
>         /* We only support the AArch64 table format at present */
>         if (!(FIELD_GET(IDR0_TTF, reg) & IDR0_TTF_AARCH64)) {
>                 dev_err(smmu->dev, "AArch64 table format not supported!\n");
>                 return -ENXIO;
>         }
> 
> Nicolin
