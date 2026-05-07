Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86D8A3D646C
	for <kvmarm@lists.linux.dev>; Thu,  7 May 2026 10:13:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778148807; cv=none; b=hw8dHvXfu2uTqmZl69C3IEoCfXgVztpGw/NnJEgSu7/RnjvguOtmw4+v12Vhg+9BzBAlvPPK9XXzRCcwHtQFIHx/bq5DMQlJ/asDNE7SLmqbNy7EJGocOjUAkWMqptlfusCwjTYICZdGWyiK4T2s5WYTbCcXJQX5KhRuPnMIYF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778148807; c=relaxed/simple;
	bh=iHSSMm5XmsR+SC8q2k1hfxidjzifsoc17tRBa7hWxWk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XpUsiLZPZMV+ogaO7wtI76JM1M0qghtGpYN3IhJLsW/dkkQG6DZ4nxMSRcnIMo1YGaItdE89p9bcU3LV0lCaClx/7ic7K8YRVIFSzAGARX6dJRbo892AaFEGUkEzQJ0dL2XZ2TNWIOEWjEuT4JyKg1GMLUvheQGurKFgGItl6KA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dxyqLO2I; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dxyqLO2I"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-48d1c670255so83975e9.0
        for <kvmarm@lists.linux.dev>; Thu, 07 May 2026 03:13:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778148799; x=1778753599; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=4DTS0qUVxwfbisiyGTh7vOJzKa4BtZMrsDae9RELKmk=;
        b=dxyqLO2IGpXHLzSkpK97jc7slOwIG4K8DVwjFEsBwKMym23ZJxUBmfuWUeFUsFwz09
         H0neWCLx44ZcMYtXo9AHbPbkefTQJaue+URCUUTHaIfGD/kpbCHmn1Wsl2LXxw6gfyTq
         h3r09ICgmhpsMyOs/aGlX9gzz1QLiJjMg5SS8oEKLUMmUvcjybPLuSSIt8HBq26w9YeZ
         R6MAwJ6p+bMoj/VNJkWushbN5vHfj656tQarkO0uDzJ/skodJCWUX0zuYC1y3DLhe/3Y
         tvDEdsAI6jV97AhjlKM5PKT96SbFZEQZCauOHTXWYAxql548Rck3FxDCvwwB2ifvlQ/Y
         JrRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778148799; x=1778753599;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4DTS0qUVxwfbisiyGTh7vOJzKa4BtZMrsDae9RELKmk=;
        b=gR7317zGOoIkz0t3evAdleDh6GOA/Zhc5fmOQ2sbWhqH6F8j3ahmQfLxYIVB8VsHp1
         oDYm0qFB1blFcZJbzhDHfdARvUGhU6ru7zTU79h9TlDZQHNhcdJm/i+Rb+llJpdlYRjx
         tqIen+nY82EvAvM14MPV/XsRq+UWktuY9Po23E/cHNh7gSGmnq9wUc1jS2MevZJa/fnv
         0f9quLleF9wWdEaZy4F44vbrSVKN/CUQopCwcylneg1gEWtTkDh7hiDL0pN9rmH5FjM3
         x/1qXhUHU8nzAXoQ9DfzM/4+dIEu6wuUJ6hZB76wzipNhHhXsNTlO3HI+RWU5PWMO1hT
         /c3Q==
X-Forwarded-Encrypted: i=1; AFNElJ+5f9kUCWjW0cd5aaeN61/rQvCHDfIAGvhw5zc5UDAYWI9TIpo45rxjbj3ooehfUymN6IIG+eM=@lists.linux.dev
X-Gm-Message-State: AOJu0YxJr+8Y6e84BDgcsodO6BUu+EAeae3DSNF6jb0VxAM1HhZkHoIx
	Q/iNtoxe5khiHgTLr45fesKX8ufakhdSP3S4f03bwo8murK1sYlfAJsFmy0NvpvgCxeAeAGfaMf
	Aa8z9ag==
X-Gm-Gg: AeBDietRIIhi21Mb3eiyoU1hwxiH+haCwdOYy65/PiHqd70ruslIUpyvfKP8FKg2XBj
	lZB0Lqvkagp+ccadk33K4Hjc5+UkPM6qCKZF3l2UxpZ1GXCrMHg51/qRKV58bFc3fD6xY5ub3+s
	iqnBB1LdyZVdW4vrKcjjsepnqYY7CUP8C/mQcZDJSeEEgMDE1uCSeh3GlgZf7iiP4ZwTdUFeLDS
	ey84r0uNJbof6SZBpA+lavWVGatBMNCXHJL51Q+7PLDucI1kethI0O0uSuW7l6Nl2y+RhwtSCOS
	Zfvcu94J9gaWAJFALpp72rEnw9ljndoHUALkwLLI0H4lEgeB0nij5InR6CKQLlqxfEmwG1ueXt1
	u6plK7hDFaKp1BDklNqpl+5bnv156ieZLvCaIpnx9Ffk4On+HbPOoPGq+Lo3dxbqDajDpC2zBep
	kWshgdW1EJ/XPfNm3CowRzGuczprxa2RNJqoxHHkeETgLqiTkwwRDeN1elCs9Wqar/qC4TIyLQZ
	S9rtA==
X-Received: by 2002:a05:600c:8886:b0:483:6a76:11a6 with SMTP id 5b1f17b1804b1-48e52d0a2cemr1856915e9.5.1778148798935;
        Thu, 07 May 2026 03:13:18 -0700 (PDT)
Received: from google.com (8.181.38.34.bc.googleusercontent.com. [34.38.181.8])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e530fdc50sm57573975e9.5.2026.05.07.03.13.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2026 03:13:18 -0700 (PDT)
Date: Thu, 7 May 2026 10:13:13 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, iommu@lists.linux.dev,
	catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, joro@8bytes.org, jean-philippe@linaro.org,
	mark.rutland@arm.com, qperret@google.com, tabba@google.com,
	vdonnefort@google.com, sebastianene@google.com, keirf@google.com
Subject: Re: [PATCH v6 05/25] iommu/arm-smmu-v3: Move IDR parsing to common
 functions
Message-ID: <afxlufh3t3hRe4-G@google.com>
References: <20260501111928.259252-1-smostafa@google.com>
 <20260501111928.259252-6-smostafa@google.com>
 <20260501124716.GD6912@ziepe.ca>
 <afiODW2sVMeOj3Ag@google.com>
 <afoagb/wVBJD1IX+@ziepe.ca>
 <afofSPQbepd_fpom@google.com>
 <afsQTwO3eW+Ks2fe@ziepe.ca>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <afsQTwO3eW+Ks2fe@ziepe.ca>

On Wed, May 06, 2026 at 06:56:31AM -0300, Jason Gunthorpe wrote:
> On Tue, May 05, 2026 at 04:48:08PM +0000, Mostafa Saleh wrote:
> > On Tue, May 05, 2026 at 01:27:45PM -0300, Jason Gunthorpe wrote:
> > > On Mon, May 04, 2026 at 12:16:13PM +0000, Mostafa Saleh wrote:
> > > > On Fri, May 01, 2026 at 09:47:16AM -0300, Jason Gunthorpe wrote:
> > > > > On Fri, May 01, 2026 at 11:19:07AM +0000, Mostafa Saleh wrote:
> > > > > > Move parsing of IDRs to functions so that it can be re-used
> > > > > > +unsigned long smmu_idr5_to_pgsize(u32 reg)
> > > > > > +{
> > > > > > +	unsigned long pgsize_bitmap = 0;
> > > > > > +
> > > > > > +	if (reg & IDR5_GRAN64K)
> > > > > > +		pgsize_bitmap |= SZ_64K | SZ_512M;
> > > > > > +	if (reg & IDR5_GRAN16K)
> > > > > > +		pgsize_bitmap |= SZ_16K | SZ_32M;
> > > > > > +	if (reg & IDR5_GRAN4K)
> > > > > > +		pgsize_bitmap |= SZ_4K | SZ_2M | SZ_1G;
> > > > > > +	return pgsize_bitmap;
> > > > > > +}
> > > > > 
> > > > > I think this should include:
> > > > > 
> > > > > > +	smmu->oas = smmu_idr5_to_oas(reg);
> > > > > > +	if (smmu->oas == 52)
> > > > > >  		smmu->pgsize_bitmap |= 1ULL << 42; /* 4TB */
> > > > > > -		break;
> > > > > 
> > > > > ie it should return the supported page sizes by inspecting all the
> > > > > idrs and don't leave this tricky bit to be open coded..
> > > > 
> > > > This way was easier as each function only returns one thing, otherwise
> > > > we have to pass stuff by address as we can’t pass the smmu struct as it
> > > > is not shared between the drivers.
> > > > But no strong opinion, I can change that.
> > > 
> > > Could you share the struct? With multi-compilation you do get two
> > > structs with the same name and different layout, it is OK?
> > > 
> > > That would give a cleaner setup too because you can just shove all
> > > this into a function and have it setup the same struct which is more a
> > > copy and paste than break up into little functions?
> > 
> > Yes, that’s possible, but I didn't want to contaminate the main struct,
> > also we can’t compile the main one for KVM because of things such as
> > “struct device, struct mutex...”
> > May we can do:
> > - struct arm_smmu_device_common: Basic stuff (ioaddress, features,
> >   oas...)
> > - arm_smmu_device: For the main driver which inherits arm_smmu_device_common
> > - arm_smmu_nested_device for KVM which also inherits arm_smmu_device_common
> 
> Less keen on this, it would need more usages to justify it
>  
> > What do you think?
> 
> I was thinking more like
> 
> #define arm_smmu arm_pkvm_smmu
> 
> Before the pkvm compile of the shared code. 

Oh, so we rely on arm_pkvm_smmu and arm_smmu having the same field
names and types?

I don’t think that’s better for maintainability, I can look into it
if Robin and Will are OK with that.

> 
> How does pkvm compilation work anyhow? Is it all rolled into a unique
> link, or do you have to worry about symbol conflicts with the main
> kernel?

All pkvm symbols are prefixed with __kvm_nvhe_ in the main kernel.

Thanks,
Mostafa

> 
> Jason
