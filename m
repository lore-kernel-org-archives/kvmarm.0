Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5250290F
	for <kvmarm@lists.linux.dev>; Wed, 19 Mar 2025 23:31:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742427076; cv=none; b=YIDIbb3iXT/zqSah8iiP5mvEdFGxgDL/ywJpKO2JX5IeNcZoDxm1iAwVrtTIAzm1okLfpfI8V+CyDleNkgCTekkUFBZTh/YZ4X+Q8zaL3wx/jOawZOMYB/0qEr+cKo5NL5yiPU2n8Rn6Wa06cFfRM3rZ7Yd8sHnBCjEPkrA1hgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742427076; c=relaxed/simple;
	bh=e/aVP6eOTZsft9iFZcwXAD1XtErl4pGxkmwMBFfGLBI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hUwfmHsX0jGTdecus57YqPJdszOgYnraFDAyeXG3Wm4zSkbifx+bnFtD2AFDheTijMx2HNTv7eNOJ0nD6xQx7zhj6nr8FfypfQ+gnV6YMsNHkjAHqCgyUXDpOhmY1QhyqYvM0kZeO/skiPkW6thKHz3fNMZCcLNBr6PynOiy6QE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=mZzs0yGg; arc=none smtp.client-ip=209.85.222.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="mZzs0yGg"
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-7c5b2472969so10606185a.1
        for <kvmarm@lists.linux.dev>; Wed, 19 Mar 2025 16:31:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1742427072; x=1743031872; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=pqUvfgCQOghdtTuF5HGBJ7Mi+2WRJ2Z/XQlW4JgLaXg=;
        b=mZzs0yGgByHeRArn0FDG4PmYx0PbwrvDFo/eHgVmDl7gGC2C8jOHEi27KZgQtgIZz8
         3HQQYjmCxe0g1DiBChVkVR/pB4DMVtHScRkSFDBbtR5R1wu3LZB7BVlf2tjPfQLRtIjf
         /KUCypcJivrZe+BZvXijFTHX2WDm/rlPomdaw/Lda8JGshsneJnBO6C5ZNfWmKJqM+G0
         foByq3jGdI/y/6BWayAD8YpWAreD8cZILcog/+aVqH0ObaBmNoQhSIj+K5OXPL5FH7Rh
         oEcfUcEDWnU2htWy7uOdr7U65Nk0FQ+QcPseEqja+TCj0oYkavzqUHXZ4FQnH4rlsOTw
         +oYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742427072; x=1743031872;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pqUvfgCQOghdtTuF5HGBJ7Mi+2WRJ2Z/XQlW4JgLaXg=;
        b=CzQQ9bmc/Pb4naCzCUTR2lrCQBjbVfworwkiRbgkMHQAk91+YOxhrOPMGvwldI9SZ2
         8CgkReM09LTCyPpLwXI21J0khYrqFRhYs0Jmq5qMhq86e7oqdHTL/SMTInAu/j2Vtdey
         zIWROtg7c2KkBlY6jX/l6LFhZTxlZ94tglQzPrnIzyw7xDN8xUdcQLwb4tgZgO1ouUUH
         Q8M2MZox1QTRJXQae1IVNVbbz3UjXLE3qw419WjClZ96hiuP3nLWsObFS6EuL64tg8pm
         55kmOTsxgdFISgoW/7X5t9lyr9RuosWjKn1Wud+Zq4ElkflF7zzdKrpmQPVefxkj130p
         C/RA==
X-Gm-Message-State: AOJu0YxBwA33gvQ2onyNu3TaXA2ImtL8/vARyF6Ez5G/xlmKytAM+L33
	gr34abycgwo8vJHSVllkjBeHyAus7rfZEWZcl0bXrLvqZd8I7gstpZMKZAf0bds=
X-Gm-Gg: ASbGncvSEZ7GMw6epQbeQelY8Hrr9VqIBPJfkELg6/r6cwAbfeRpi3faUHToLn9u+TX
	WNdnFdxFYbZV6VVvWtCH6JtH8KiTQ997oA96U0qp+7IeYWfAXp/TzA1v5Ufln+PPrNu7gKVPYj8
	P3Z1ujYUrLS5YDqv7MrW6F4nPWR39VejH78CQVY2fGm5v3uRTrbTgXHRYDHLAKGmPkk6RloxE5R
	luCOsYdKgU9GYMHQy9Pu5metK7MN4y7S0S9KDASNM+HFqRZNN/ZqvrXOLRnrNVUtX9bNpzZNbmZ
	dlwRvnBLRrqcLyYkXmKGddQl791gB55KWjcJsxoNHg7K32qSh9C5DHBQDFCtm0xGbjjjWYphjUt
	ZWuoHSMmZzMKOZVblIQ==
X-Google-Smtp-Source: AGHT+IGNIMXR9mOReHrVF+QcyuezWXU/5MU0g6sktMSQ902CBz/Kbj5Gj4SCICqdqfl7AjCygX5vIA==
X-Received: by 2002:a05:620a:1a28:b0:7c5:47d3:10c2 with SMTP id af79cd13be357-7c5a84a2882mr665758285a.52.1742427072577;
        Wed, 19 Mar 2025 16:31:12 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-128-5.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.128.5])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7c573b3a042sm926026885a.0.2025.03.19.16.31.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Mar 2025 16:31:11 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1tv2sR-00000000cc7-0ov1;
	Wed, 19 Mar 2025 20:31:11 -0300
Date: Wed, 19 Mar 2025 20:31:11 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Cc: kvmarm@lists.linux.dev, iommu@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linuxarm@huawei.com,
	kevin.tian@intel.com, alex.williamson@redhat.com, maz@kernel.org,
	oliver.upton@linux.dev, will@kernel.org, robin.murphy@arm.com,
	nicolinc@nvidia.com, jean-philippe@linaro.org,
	jonathan.cameron@huawei.com
Subject: Re: [RFC PATCH v3 3/5] iommu/arm-smmu-v3-iommufd: Pass in kvm
 pointer to viommu_alloc
Message-ID: <20250319233111.GE126678@ziepe.ca>
References: <20250319173202.78988-1-shameerali.kolothum.thodi@huawei.com>
 <20250319173202.78988-4-shameerali.kolothum.thodi@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250319173202.78988-4-shameerali.kolothum.thodi@huawei.com>

On Wed, Mar 19, 2025 at 05:32:00PM +0000, Shameer Kolothum wrote:
> diff --git a/drivers/iommu/iommufd/viommu.c b/drivers/iommu/iommufd/viommu.c
> index 69b88e8c7c26..e157d786f295 100644
> --- a/drivers/iommu/iommufd/viommu.c
> +++ b/drivers/iommu/iommufd/viommu.c
> @@ -47,7 +47,8 @@ int iommufd_viommu_alloc_ioctl(struct iommufd_ucmd *ucmd)
>  		goto out_put_hwpt;
>  	}
>  
> -	viommu = ops->viommu_alloc(idev->dev, hwpt_paging->common.domain,
> +	viommu = ops->viommu_alloc(idev->dev, idev->kvm,
> +				   hwpt_paging->common.domain,
>  				   ucmd->ictx, cmd->type);
>  	if (IS_ERR(viommu)) {
>  		rc = PTR_ERR(viommu);

This has a lifetime issue on the kvm pointer.

Because nothing is taking a refcount on the kvm we are relying on the
caller to hold the kvm refcount for the lifetime of the
iommufd_device_bind()/unbind() which is creating the idev.

However, the lifetime of the viommu object is not linked to the
lifetime of the idev. So the idev could be destroyed, and the kvm
refcount put before the viommu is destroyed.

Probably the right answer is to take a refcount on the kvm for the
viommu object somewhere along this path.

Jason
