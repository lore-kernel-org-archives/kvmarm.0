Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBED43A5455
	for <kvmarm@lists.linux.dev>; Fri,  1 May 2026 12:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777639912; cv=none; b=ESsJzRlY9jdqvyrKH+bwkWtAI+/oTviJDQv91D3rhmTGBAb1B9eGC3TIXvrpyZuuQdj6464aV1cg2vi7ZrEM2gJcet2Ry+QeZfJyCpBbZvOmKWxrP639c2kF7YtY2MgGOqCIMw+HoptklutsShIuBJ/vHyiVHlSfMWK4mWf3qGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777639912; c=relaxed/simple;
	bh=IwxVPwjsxBBZiuBupDhQYeG358F5s+BoySPudQUssGE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Za0cJxW7oNHh3QQdz0TdXeJ0HksIxdd/wCMxBy/MZanhz8msCK4lMjSbgXlNXVSFyaq+dwVKe45hZdUdzJTAZ/T+uV8rCwVXlyG5qQElTqxsB30+A1WdEPboq5J0yBAk2wbuVbHgJlupR1Q1B18fanQV6JUFS+Ou/0IsRbPi5EI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=pOIvT8NN; arc=none smtp.client-ip=209.85.222.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="pOIvT8NN"
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-8cb5c9ba82bso299830185a.2
        for <kvmarm@lists.linux.dev>; Fri, 01 May 2026 05:51:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1777639910; x=1778244710; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=BDMlaTUNGVqmc1jmP6u4TfGXv+GXsCG3iAN8BRJBeOs=;
        b=pOIvT8NNuxhlNSZLxeH8VIk/Kxtld6924gqzCybvrRurcZL2qLmQBtY+1nE9nqeiea
         1yP48aRqxzY2T7CJXoSf5RCJfXaJs7ind9iVminIFqNBisyBocV1A/SzymuKwAxAI15a
         XOkEODp4z/TdU0S4YZLutaYXAr4ZbMlpIbroS/aTAlTVPgv2+eWzS8LZbaoLHsIf6znh
         4vAbBSQ3r6f5X0XicyqCR0W7PuGMPCux1Q8xyYp3N4Xipe49MdFsjm7jA/lVFBIb/d2Q
         bgzTAf5XJ2ZcHKbfVOFlkbAeGZ2yJ6xmVzfig6kidDsJkYjmUY9/CW5oAGRr4kWdjAhD
         8UKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777639910; x=1778244710;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BDMlaTUNGVqmc1jmP6u4TfGXv+GXsCG3iAN8BRJBeOs=;
        b=qvjjVKoh6pLe6GeDf8hcUVJIZQOmDnS3FUKFMWV3Kzt3rfdvk/3yxOCZBIy46k2lgN
         hYVks5NqNklfapW4wmvGGrC6bod1ZzD6ioPy1qUHwQkieSfgODNckuhxM10uK7lf9ZP0
         keTXNijustNsuLov+YnMrBSVPZ6jKaXCnugo04isVdd32LYmPIlNgLxdZBeiLZdj5R4u
         PjaG5eoAA3tEQvCA3dJTwIeBRQIYPsDUOhOewLyFZ6IoOnZEvpZL949m9ZrQ0pKEhpoy
         /tnrR9w16CScWs1caDXVn6l0PkBXe6h74v4S/aeTpCKpir0EfyvzCdh7qtirOIg7ZHBd
         NdWw==
X-Forwarded-Encrypted: i=1; AFNElJ9zt6RgqagrGJFyaSFuCYvtzcKCJDPO6arFQbj3A9x5W6CP0VqwyeFS3usT4s5SqdpZm2r2Cfk=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxs/YAzoMbZRJL23Z/+Ngph/5f2Uv24ttyTiiXCp/NuQhdf3d/3
	p+Ae5bnNjEgy7VqCQVeeJylUq4da5x7GOsSpTu6B9NqurrMIX9HXKpRM4VPQThSOPRk=
X-Gm-Gg: AeBDietv4uTJynitsPFz0slfXLtW860n3koQd6Wjg0UxOx9VfaNY+Qe7OSDvB+9iNJp
	WDMujD9ZFSFulzLShBRHH9WPdphNgWLeHx2T4lBrScDsH/ZobwkkEQAh9LzKbEz8BHFfH64tCel
	MKWPPWMHXElQi4muSA6c9cVh3v0QFSoSJiXBU5ajd14LjRZTZUDsZvSQELfl3YI/9DWF8e77maQ
	8PD/2dme0GBAZZ7TKStC/tMSy0anp40NehxSUoNxsdvB/cXHQbEFw7CyHfh8GryAjkVbo22n1JW
	4RdqhUAWt+arIRr1kkJs9FqrwrjxnrJJVNMa1r+aYagCoILRhwFGHlWfvVo/u6GMuQr2q72CXOk
	fNrSY2XoNCmgbv6LxMZUm5+PL+XUir0XwmhRCL0xVP1CS8F23JTUcc5gv3ihvZUxaPtDrTIEwgt
	eQBOFEBThGgc6qFehKpUiXs9VSVcLd8U0KN3hR8xyI820eHhCE1kznx5rnIzbWcRzEfsHA9PBJj
	XyMhdBvRshfb9Pi
X-Received: by 2002:a05:620a:25d3:b0:8ed:d906:a8da with SMTP id af79cd13be357-8fa86fa6765mr1113897585a.18.1777639909805;
        Fri, 01 May 2026 05:51:49 -0700 (PDT)
Received: from ziepe.ca (crbknf0213w-47-54-130-67.pppoe-dynamic.high-speed.nl.bellaliant.net. [47.54.130.67])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8fc2667d5cesm157094985a.0.2026.05.01.05.51.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 May 2026 05:51:49 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1wInLQ-00000005BDs-2rAu;
	Fri, 01 May 2026 09:51:48 -0300
Date: Fri, 1 May 2026 09:51:48 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Mostafa Saleh <smostafa@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, iommu@lists.linux.dev,
	catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, joro@8bytes.org, jean-philippe@linaro.org,
	mark.rutland@arm.com, qperret@google.com, tabba@google.com,
	vdonnefort@google.com, sebastianene@google.com, keirf@google.com
Subject: Re: [PATCH v6 13/25] iommu/arm-smmu-v3-kvm: Probe SMMU HW
Message-ID: <20260501125148.GE6912@ziepe.ca>
References: <20260501111928.259252-1-smostafa@google.com>
 <20260501111928.259252-14-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260501111928.259252-14-smostafa@google.com>

On Fri, May 01, 2026 at 11:19:15AM +0000, Mostafa Saleh wrote:
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> index 61e6ab364086..157acde0436d 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -4738,12 +4738,6 @@ static int arm_smmu_device_reset(struct arm_smmu_device *smmu)
>  	return 0;
>  }
>  
> -#define IIDR_IMPLEMENTER_ARM		0x43b
> -#define IIDR_PRODUCTID_ARM_MMU_600	0x483
> -#define IIDR_PRODUCTID_ARM_MMU_700	0x487
> -#define IIDR_PRODUCTID_ARM_MMU_L1	0x48a
> -#define IIDR_PRODUCTID_ARM_MMU_S3	0x498
> -
>  static void arm_smmu_device_iidr_probe(struct arm_smmu_device *smmu)
>  {
>  	u32 reg;
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> index 64618299d03a..f904f4d19609 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> @@ -84,6 +84,12 @@ struct arm_vsmmu;
>  #define IIDR_REVISION			GENMASK(15, 12)
>  #define IIDR_IMPLEMENTER		GENMASK(11, 0)
>  
> +#define IIDR_IMPLEMENTER_ARM		0x43b
> +#define IIDR_PRODUCTID_ARM_MMU_600	0x483
> +#define IIDR_PRODUCTID_ARM_MMU_700	0x487
> +#define IIDR_PRODUCTID_ARM_MMU_L1	0x48a
> +#define IIDR_PRODUCTID_ARM_MMU_S3	0x498
> +
>  #define ARM_SMMU_AIDR			0x1C

Lets put these hunks in some earlier patch to migrate out the
functions/etc

I think all these pkvm/arm-smmu-v3.c should just be building up the
driver.

> +static bool smmu_nesting_supported(struct hyp_arm_smmu_v3_device *smmu)
> +{
> +	unsigned int implementer, productid, variant, revision;
> +	u32 reg;
> +
> +	if (!(smmu->features & ARM_SMMU_FEAT_TRANS_S1) ||
> +	    !(smmu->features & ARM_SMMU_FEAT_TRANS_S2))
> +		return false;
> +
> +	reg = readl_relaxed(smmu->base + ARM_SMMU_IIDR);
> +	implementer = FIELD_GET(IIDR_IMPLEMENTER, reg);
> +	productid = FIELD_GET(IIDR_PRODUCTID, reg);
> +	variant = FIELD_GET(IIDR_VARIANT, reg);
> +	revision = FIELD_GET(IIDR_REVISION, reg);
> +
> +	if (implementer != IIDR_IMPLEMENTER_ARM)
> +		return true;
> +
> +	if (productid == IIDR_PRODUCTID_ARM_MMU_600)
> +		return variant >= 2;
> +	else if (productid == IIDR_PRODUCTID_ARM_MMU_700)
> +		return !(variant < 1 || revision < 1);
> +
> +	return true;
> +}

Why not share all this errata stuff with the idr parsing code too?

We already have ARM_SMMU_FEAT_NESTING that has the above calculation.

The two drivers use the same ARM_SMMU_FEAT system, I would expect one
chunk of shared code to compute the FEATs, who cares if pkvm doesn't
use all of them?

Use the same errata logic and so on to get to the feat bitmap.

Jason
