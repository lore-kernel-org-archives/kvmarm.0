Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 427582989BF
	for <kvmarm@lists.linux.dev>; Fri, 12 Dec 2025 15:42:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765554142; cv=none; b=qdTtzyIHPvHKN2qGnfo+kr8HHvT3OuW5g1J9Uh5vLyK1l+PD7QFDy7iNnpfxG0guAKAVc1SOrdy+f0nTO8WkU7Vfw2HQ8lW0s7ykPbcHcXHcu54zFjSuStXSmljaogMbYj+b0j+CAnwkTRGVMMNe9DGC+oQE4WQb7KrZVigJqOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765554142; c=relaxed/simple;
	bh=joFWG7Hooms9HHmPDBpxzWGrRsZoETvTZljAbbg12/I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YjBcKlhwW+Pu/wd9vYXPKZNK5CElbOnI1mmSRxVNMRVTjjXFAwoZPHsXu4z79p0XkCIeUxNsZO2LRg7ybmux6+joHxLSDmrxKeOfvrlz4Lszuhgzb+C9azlVEFHRUBbEhZjD2tfur23e/pKZ6aIbQJdbALioZtrBOdLimf7cxe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WOo+oOhT; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WOo+oOhT"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-47a815c43baso132365e9.1
        for <kvmarm@lists.linux.dev>; Fri, 12 Dec 2025 07:42:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765554139; x=1766158939; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gfg2SmLr3HbDKANFq8sDAahr7BVj1MWtGDCHWff86x0=;
        b=WOo+oOhTeYDcRIuVH5AMq4opHmR7R5tAATbtJbieeyTsY9KT3YzceXPqKZzeUNWtZF
         sNQ+Iqb5WaUNl52/lA8iBCF0GKZFkY6T7BGztM9vQ+aWHODiBdgm0Esiy6nnITk3jGYQ
         CBSUk3QAmgkhNp7CljELTkaGWc92bnTtSn2uXIe4ikbJzgUZZnK9Qu98pqBzSvEfN2V2
         sFCs5vBCCNP5mR3szD8pC3qd8t5BpFDEIdkS2J8vHsOb9VX6td1LiTkzP7zxkdqoGurB
         yMqjAPAbNtmNkgFsWF/0SWWEWb8W3lHxr594YbqweGrXriFnp6jNfVtlzfFVOkZQW7Qq
         FaeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765554139; x=1766158939;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gfg2SmLr3HbDKANFq8sDAahr7BVj1MWtGDCHWff86x0=;
        b=POPDHXMl26pX+H6dK5P0k4b0Y0pGPn+sOkNwfvLv+vWUNh40nKuaf08GZGCFgQoFw9
         /GzGdvEvQbAte/ZF4stHQjokpVLkUpSp+iGYrKtdj8wFOVGmEFM9uIbmyzG3QU6rJ6Vl
         OpVDnGwl8GfoUL+gsJX38FUZHxBcJ58+pQ8ay+wpNnDNaz1jQKHGMDDa7jeeltoaPZdM
         5nNM4DdeiMAHxvSpQDIRA3qeA32eU8TAbHTxPKRrN04KhHkjcxj3g7cpdyweSKzoz/L6
         Uyuj1xhHClU6TIr2siX1sQWr6T7unlpG5qDV2ZYElatQGBrIi1aN1dnsSjeZ3tQu54YJ
         6Lxw==
X-Forwarded-Encrypted: i=1; AJvYcCXUgL1Gp3Nsexjk5Ahz6He1Mc3mlZE1o7C++N0qKG5YoBXt1+o7Z/DMhh+adOdj2fwEtroYTv8=@lists.linux.dev
X-Gm-Message-State: AOJu0YzLtuCgUE8oInvqHo1OIh1VfUUFkYfSmGcHLpBOOlQFDM+e0bhA
	g0W44eGPssCNsw/64ednErh5+XymxuFmfa2LCAYdJMV2GfXiV6MQxMTIlQw65H+wUg==
X-Gm-Gg: AY/fxX5o8tPoI2n/aBnLjTX+ee6+Fh3m0px/+imz7qmYPICebDohZyWfmX+8e778E5y
	ps3Q5GOBh2G/l2UWUZdvU/CLvAhIdB7QWIV+sGki1reIKb/fO8x+Pu0hp8cL+ktS+ipuRr3hA2x
	Odvvq4hdTHR/hK4Gei5+IuSetWSrkEFEg4+UGX6rXMKXUlyhzwxQwdmabqKKQrw7zGJNkU0YcQx
	5035QZk1mAdVfpNbfyqAb7IVqBpCBsKPPJFvvnEJLRoBky8tvvRwZRQWW0R/Y5l1ttWreGtvW7j
	OordPJgb9/ZnmuPK9gGOlQ4H+vMpVnyvU+kPOCWZ39+D0cQqx8fuXt3uusATyselfc7lj3miZt+
	2AvH+ndWdIRDPIP/Vb1mP/AydXZFCKqqmVRTywl0GHLKcVzwjTz4HkM1dcWu9TM7HPgxxA/k8U1
	R40ZBd3sXc2K5B6fNphKlw3SwPSvaw/9k5lk/tHJGY+UPI9uDpAw==
X-Google-Smtp-Source: AGHT+IGt3F8L3ODVzdoshKJbidZOroW1R1wmPFQ9WkER5xE0kT1roC/MUuXOsH8BQJj1YtvxKpKD7A==
X-Received: by 2002:a05:600c:a103:b0:477:563a:135c with SMTP id 5b1f17b1804b1-47a88b7b11bmr1671425e9.0.1765554139413;
        Fri, 12 Dec 2025 07:42:19 -0800 (PST)
Received: from google.com (54.140.140.34.bc.googleusercontent.com. [34.140.140.54])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42fa8b8a97esm15331584f8f.31.2025.12.12.07.42.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Dec 2025 07:42:18 -0800 (PST)
Date: Fri, 12 Dec 2025 15:42:15 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, iommu@lists.linux.dev,
	catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, joro@8bytes.org, jean-philippe@linaro.org,
	praan@google.com, danielmentz@google.com, mark.rutland@arm.com,
	qperret@google.com, tabba@google.com
Subject: Re: [PATCH v5 07/27] iommu/arm-smmu-v3: Move IDR parsing to common
 functions
Message-ID: <aTw31-mh8z81yi4Y@google.com>
References: <20251117184815.1027271-1-smostafa@google.com>
 <20251117184815.1027271-8-smostafa@google.com>
 <20251128164816.GC812105@ziepe.ca>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251128164816.GC812105@ziepe.ca>

On Fri, Nov 28, 2025 at 12:48:16PM -0400, Jason Gunthorpe wrote:
> On Mon, Nov 17, 2025 at 06:47:54PM +0000, Mostafa Saleh wrote:
> > Move parsing of IDRs to functions so that it can be re-used
> > from the hypervisor.
> > 
> > Signed-off-by: Mostafa Saleh <smostafa@google.com>
> > ---
> >  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 112 +++-----------------
> >  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h | 111 +++++++++++++++++++
> >  2 files changed, 126 insertions(+), 97 deletions(-)
> 
> I don't see that this slow path stuff needs to be inlined?
> 
> +10 to my prior remark to not dump all the huge inlines in the main
> header.

They are inline as they are defined in the header file, otherwise they
get defined multiple times.

I am ok with adding a new common file.

Thanks,
Mostafa

> 
> Jason
