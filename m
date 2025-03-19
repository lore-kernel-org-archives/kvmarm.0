Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AF1B2236EF
	for <kvmarm@lists.linux.dev>; Wed, 19 Mar 2025 23:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742426934; cv=none; b=X02kmbGuioyAudRqFCO2VA8Vo204fXtzjCWxhrAXmodFfrLBaGRsbezfuoKyasybEdt5O3aMwzgJ2bS6UFiDuoELT0plGbGp8BXwqKJEbwkCknHS2AFzPuAbK5EJBDgU75gEXL8UgJDJIVcomPOdZVKXz1+jolTHpYV508evMaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742426934; c=relaxed/simple;
	bh=+OBKGUBEWc/g1Gl9a7Xn2ThforE0sB8K2V6ZOvRyXn8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KpOSIb7ZIC79ZCeKN4A3+DfcTOSd4By7PZQ++8CzeXCnkXMxn8CHEIj5TKROA8RDHXXFWoYHVTpup4eXv7AF6shw04cFbpeE/zGMnGXKJje269BAhjvFMc4wppi6WRKPpOXKv0GObtnqmaosBaW82e8PS7XVTGy2aweVMOmqrdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=mWVt/+q3; arc=none smtp.client-ip=209.85.219.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="mWVt/+q3"
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-6e8f254b875so1641786d6.1
        for <kvmarm@lists.linux.dev>; Wed, 19 Mar 2025 16:28:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1742426930; x=1743031730; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gseEEcgxR2PUFeV7iG/jei3VTxYiomeFsvivAthjJ6c=;
        b=mWVt/+q3kJ4Ik1ZXs18+JTmIKX7cPVyimUROl3DA7orru59qqd11Uc8U2Y3ykl3pbP
         X60fL0J9D+B+YOGX8rddB85S1+YcDdX+TQKff0jyV0QDzVncEY34TLc+tGDU6fkabUER
         wFu62CZ7DFpUcfxakuLyj6gLSrYce6iJVUZBvjnFeTYokIrM92jH8v63IgP7vgFDqMqy
         gZQ35+ZJ3NoNw2mxmeFhFRQaTPaS3D06t8r0PYxdTNCbT+YJzxMfCfLTwzv7b43OkUds
         r8dzHGjEtbDzRQbrCsoNeMruYGlzCfemB2I/PY7XqsQK8jQEtTOdfirnHm3U8aT0ncdn
         yrAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742426930; x=1743031730;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gseEEcgxR2PUFeV7iG/jei3VTxYiomeFsvivAthjJ6c=;
        b=MPtSX1IXk5TjA1a/H9QrEGwZC74MZtozoLhxzFnvxbywVmwl1xevoJ+tlUjBNVEi8g
         ObmmrdfnF3uTehcSBvcrUDuD9BUIj5evdU2GtEja314oX10ScR7rxgJBLxOQ+ar1iuh0
         nbnIwpUa4SinYG6RP5/e+Pp9FZJCeM/7+tL6KUcisqCYARPxMoumNRA4hkraSnxwiGsa
         iXn3krw0ZIIE/K1ifahCFz9b3gP/Bww1EI3C18v085WTT3b2ZE440JUJSmXsdEKiGGmL
         NLUICLwOA+n2ZyaBrQ1UPN6QhapYS2R2im6J7UPAYf4IyXk07unzfzpZWLChS2gn16Mu
         9pHw==
X-Gm-Message-State: AOJu0YyH2SXtv1CTE/zKV0QdvgiCcsQqMeGJVxB+fCiMd8w/wJuS+XFx
	xkZ3zUdKLNenp/7uXqJdWg02CxpqXD2dusSE/96S3iaYTI1/6siQSeScjFVGezg=
X-Gm-Gg: ASbGnctqP6qq6EOa0Ywv+ItHvjZdSDLMGa21f4XEUAbiVQ9TuoRXzIj7yrs3Yz7QJ7j
	8yltVVspGAFbzKSHDmY8e4QtspncSjPCrBMFTUeR6+lWPKrUPvYSlO/xDFyWiv0eVvNyveZM5t9
	ZLaocJywEbiwPhoHs501c7HTtpzzOPzTsSBZN3ufPLvKIbzpVcc8FXzF+0V86XIE9iLv1sBSj6+
	zjqOXhVpG9hNHcjNVEVGj50NqBrOHLETvyLGJW0tY/0MMGH1eKjWOdGwtJIhFFVs2jwWjOumTX2
	f/HnIbMiamO497mNTQlAt4gzzJ8PVf2aG8lEtdfMI4w6a5CoCUIzfVVpUpR40GH/bBCSkafiFfu
	gtmEEtfN3UJ0KQWwLlQ==
X-Google-Smtp-Source: AGHT+IGbrUJL++VHjNdJiRp2wbmBFeF1zO3i2g8SKEiaH6sIBdq4CqOBZ41CKMhKYzBCvXB+fzodAg==
X-Received: by 2002:a05:6214:4111:b0:6e4:2e5f:c03b with SMTP id 6a1803df08f44-6eb293a5ef9mr61501766d6.22.1742426930195;
        Wed, 19 Mar 2025 16:28:50 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-128-5.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.128.5])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6eade24ea1dsm85642276d6.65.2025.03.19.16.28.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Mar 2025 16:28:49 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1tv2q8-00000000cbM-47kn;
	Wed, 19 Mar 2025 20:28:48 -0300
Date: Wed, 19 Mar 2025 20:28:48 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Cc: kvmarm@lists.linux.dev, iommu@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linuxarm@huawei.com,
	kevin.tian@intel.com, alex.williamson@redhat.com, maz@kernel.org,
	oliver.upton@linux.dev, will@kernel.org, robin.murphy@arm.com,
	nicolinc@nvidia.com, jean-philippe@linaro.org,
	jonathan.cameron@huawei.com
Subject: Re: [RFC PATCH v3 2/5] iommufd/device: Associate a kvm pointer to
 iommufd_device
Message-ID: <20250319232848.GD126678@ziepe.ca>
References: <20250319173202.78988-1-shameerali.kolothum.thodi@huawei.com>
 <20250319173202.78988-3-shameerali.kolothum.thodi@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250319173202.78988-3-shameerali.kolothum.thodi@huawei.com>

On Wed, Mar 19, 2025 at 05:31:59PM +0000, Shameer Kolothum wrote:
> Add a struct kvm * to iommufd_device_bind() fn and associate it
> with idev if bind is successful.
> 
> Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> ---
>  drivers/iommu/iommufd/device.c          | 5 ++++-
>  drivers/iommu/iommufd/iommufd_private.h | 2 ++
>  drivers/vfio/iommufd.c                  | 2 +-
>  include/linux/iommufd.h                 | 4 +++-
>  4 files changed, 10 insertions(+), 3 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

I'd probably explain more in the commit message that this is to allow
VFIO to pass the KVM to iommufd so it can later be associated with
downstream objects like the viommu.

Jason
