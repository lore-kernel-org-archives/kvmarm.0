Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CE047B3E9
	for <kvmarm@lists.linux.dev>; Thu,  8 Feb 2024 15:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707407026; cv=none; b=uuGHj3znM9geBIxeS8Mzx4YDH0dP8jmjRbo/4END/ATOxo+gXsUQ36H4qBoXicG2F2swpIJsxHCDp2OVzV1tBp8zsXVb+kTRTkwzIrMs6u8IQO6oeU01iTPm6L6XmzNyVQgnpvDKVnB1bEJlKBAmkrG38SiFzkrN8nRVBYaBZzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707407026; c=relaxed/simple;
	bh=cy8cbti6Dul24rz/YjI+T7QEGKXHWZwAnuJm3Q9Lg1w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FHBdYzj5pagreNDj8BbRQZtvDa4rq8JVarRCN5ImwHhV9X7Q9fG3ebBH/TCGDo7GAyjyYZ7cDChCblHM04GcTAxSCZdZRyTobDtXjOOjDOjzDLZHFOfwDfRkU3g2rjeItcGjK8IHBycD72e4ZgMeoCVHDZ2SJgn5kXBggAuKOLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=nXKzRX/c; arc=none smtp.client-ip=209.85.210.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="nXKzRX/c"
Received: by mail-ot1-f50.google.com with SMTP id 46e09a7af769-6e117eec348so902715a34.2
        for <kvmarm@lists.linux.dev>; Thu, 08 Feb 2024 07:43:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1707407024; x=1708011824; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=42fCYQTEim9hrnMCqp+EazxamRSYzlJTG+y6cKqWJb4=;
        b=nXKzRX/calVBDfMy8IR5UZupsYQhmx9DTwz5V2GfdtmbJpvrQJCJcMVWmweEy+p25v
         SsRhyew3jVTkxblY5jWhVGJZSIzR7RbrPw8rXy78q05QptkLeqFtkPb+mNdKdguiKXxv
         CzsV5CyFffQqMSc/9t3DB6+AqpZI6C6a5qQ2H9kdR/d0nmEsEMykx4PkNHEuzcOiP7p9
         wABSdC8cOIawQXelDc/5JKnfOxghCZikBGo5ORnoF3a7SoojXTvx5/SrG1eERCIx4MxY
         p8uBNoGDIyvnmV6BO3w+gDRakdqV4y9BtFxJm9OzM/tAq/lD+Rar9K27b5FgEjk8fqw8
         YSHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707407024; x=1708011824;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=42fCYQTEim9hrnMCqp+EazxamRSYzlJTG+y6cKqWJb4=;
        b=pFAMjQj78yZl5rn36wot8PdHH1FRelTgvdgmFshsIVjlpqIji33JR0Ug6y5E6obTw8
         N9psczMqRcVSlN2qX9xptBNZ8iPO0+sZzed5390G8b8jUc05rVlMFyFPkapPVoEuHZ3E
         r02OodYETLqLm1XyikBGYOJvNe07Oovj9SyFcKl+lYm5yRTrz9cj3nrIbqXnj1KphKxc
         X+r3fbPcl/J10cbeuRGFK1X8xi65CZTrkkuxQGKSNgllswyGFe/fXAoNji45bOMJYHmm
         cGDS+ZsPxzyTUyJXXU8z58eOf5QEIkGns8WtIEBEg/vj1EIT6XmHFD9PtQpcbAqKzieg
         NZ3w==
X-Gm-Message-State: AOJu0YxyL8htVL1KK02eURLWTgA4eyqM3MczFs9gMrxmkoi+3U44BRFh
	S6YPdRUKlFXd+AwPo2xPVkRNKJP7HuZE3bGL7kUe6LoAdGfjyadBGdUD8QWwVZY=
X-Google-Smtp-Source: AGHT+IF3FjBMczgGjBzvG8YNkJEYtMzlNp4gkaCQSwrhLDd62dAkSovFu4zT3VE8jqZVndY/ZXxDlg==
X-Received: by 2002:a9d:7692:0:b0:6e0:e52b:ccad with SMTP id j18-20020a9d7692000000b006e0e52bccadmr9448106otl.16.1707407024266;
        Thu, 08 Feb 2024 07:43:44 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUy9Rv8dR6osIwGKkh+Uw//I7/9AqSZbUIwaLPMCn1d0CFcvfsy0etmKamm1kX8HW4VknXjc4+1VHqUIDKYJhOaB6R0yPlYfF4M+Felb0fJ3ckSJQTJ3Svem8lh8Zc8cE935goYrk2tQ4WSYvqMdaYxqmHFVhj7ZRNV0U9an+3dTmKTL8XL++yZLJAiHR54Ssc9vBo0CkM3S2qMDziNKb1hHHKiH1dQExWOI/ZBBcjo8WU5u4cDzlIqcZPcTM20173tMAeBhhk1q0vw3aFVFAFEILFJS366poCgMec+ieKMXqzDpeCZM82X62ASA53goyBMVQiplsOqH7at0Gf0Tq+ffSekhbgTmwKlPMsrMb38AxBgTUMxB+1JkHf78dzLEsaXEjUx6aX9gB/XG/2qG6QjT6ehjmp0mGE=
Received: from ziepe.ca (hlfxns017vw-142-68-80-239.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.80.239])
        by smtp.gmail.com with ESMTPSA id n6-20020a9d64c6000000b006dc5edf4de7sm583267otl.32.2024.02.08.07.43.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Feb 2024 07:43:43 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.95)
	(envelope-from <jgg@ziepe.ca>)
	id 1rY6Yx-00Eu84-2G;
	Thu, 08 Feb 2024 11:43:43 -0400
Date: Thu, 8 Feb 2024 11:43:43 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Cc: kvmarm@lists.linux.dev, iommu@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linuxarm@huawei.com,
	kevin.tian@intel.com, alex.williamson@redhat.com, maz@kernel.org,
	oliver.upton@linux.dev, will@kernel.org, robin.murphy@arm.com,
	jean-philippe@linaro.org, jonathan.cameron@huawei.com
Subject: Re: [RFC PATCH v2 5/7] iommu: Pass in kvm pointer to
 domain_alloc_user
Message-ID: <20240208154343.GQ31743@ziepe.ca>
References: <20240208151837.35068-1-shameerali.kolothum.thodi@huawei.com>
 <20240208151837.35068-6-shameerali.kolothum.thodi@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240208151837.35068-6-shameerali.kolothum.thodi@huawei.com>

On Thu, Feb 08, 2024 at 03:18:35PM +0000, Shameer Kolothum wrote:
> diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
> index 4283dd8191f0..75e0f4e9253a 100644
> --- a/drivers/iommu/amd/iommu.c
> +++ b/drivers/iommu/amd/iommu.c
> @@ -2244,6 +2244,7 @@ static struct iommu_domain *amd_iommu_domain_alloc(unsigned int type)
>  static struct iommu_domain *
>  amd_iommu_domain_alloc_user(struct device *dev, u32 flags,
>  			    struct iommu_domain *parent,
> +			    struct kvm *kvm,
>  			    const struct iommu_user_data *user_data)

It would also be fine to stick this in iommu_user_data - since it is
fully optional to any driver. 

The other parameters are things the drivers must check and do
something with.

Jason
