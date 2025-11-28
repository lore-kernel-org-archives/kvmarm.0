Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4D2D285CA7
	for <kvmarm@lists.linux.dev>; Fri, 28 Nov 2025 16:46:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764348419; cv=none; b=unw6+0JOCk6mh2Mb810jX5hSXdCFEwAm+GcL7tGoMnd9CIYSDxx3M74v7FS2cRtI/ozcyuxZ2tu7nVqYIK8GkEGjeiW7ndhSrYb3DlPjgnvOnngIUFSUwIW6jjlnnaX5hU4kSlECFtdHE2buCcmgSHgt47/ZCEj6N80vq7s8lqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764348419; c=relaxed/simple;
	bh=WX4pc9BQeZW3s5krELSMAl7NSmtfwDPPbwwaGWHKB0w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LTnN7E7vKMUoRh7oMUFV844iBCeI6S3/KYWrNrgq2V93uKUK9D34KRDCGHTzIhNxEF7WCnaHsKaQEoYuaVebAu705/yYSQvPy6OznRl8IS0oAwjVsQ6QBifuUIjlMAF8cwu7uw0xWihLoe6oGHUNlJqoEWjYKwq8TdwLuI4ThbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=T/je1K8N; arc=none smtp.client-ip=209.85.222.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="T/je1K8N"
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-8b29ff9d18cso185366385a.3
        for <kvmarm@lists.linux.dev>; Fri, 28 Nov 2025 08:46:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1764348416; x=1764953216; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=WyDxOQ8Lw5prQGezJfzgyKDZ5+VnUcEleF9/ih+sij8=;
        b=T/je1K8Ngl531nFzyaKxrO3Hx00Vo3CHjpJw0D+FDi4IrXcgRlSsO7rXSIvojrn9MP
         JBrNQy43Q0w4IcLAUnanrzblCimGwmX/2M5+nciuGeDiFv9n4S0eQTkJr0D+/+N15+CH
         RZYtyeIO6sZ7RXJqqYQQhg2Lb/x66sWDNapgfMZtPFUEzV5l2LfynasMYk1i4zoRJTJ4
         MW770fWfwjQkahKDv19jlJexKLnESMKoquTxo6sMdhqleePTDUAgH/gxjZQvxEQkS1t5
         1MME71P5NUk1kKpwL4AXvANDgPIpC9pA3ncDNcvvCIY2F0AAie+KFfiIr6Xvvb+XXfdW
         QPJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764348417; x=1764953217;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WyDxOQ8Lw5prQGezJfzgyKDZ5+VnUcEleF9/ih+sij8=;
        b=WrL0YnDTPfgKOvxSkhQRIhhnpxQKcjDsWQgFBXU61a9WIQBsZidrmhxd8W8HjszyWY
         eYZdkI12M1UPYQXH6YvwDPA7ZtT3WqRfaLxa2/E6t70NtgsKmXX2cNH7osJrHEcIZi9a
         xcShJ8CzV/2e4SrkRqrj5LjX0jVNy6jk982Q7fVjFLaTUmphR/kd9eNLwrmQQO7AVjgU
         Vdb/NB86YAmob+NmB6V7aSvP9XofKOzMjiWTPEI3lUGP4dT4HkNEGM48MmptSTcd7Hre
         FcP47UYqP3/uIM6C96VF9uHUyRUjcQZftANep+4sGTh7bPc1yoWSxBGvJ44zqcT4SOsV
         WRmA==
X-Forwarded-Encrypted: i=1; AJvYcCXn/w3rRJ+meCNuss0WFQCwab7v3GgpVQkH6BDYRS1c3CPTd8L3LWIrmswaV6VlWUgtztyi57E=@lists.linux.dev
X-Gm-Message-State: AOJu0YxeFlx8ip2TLXj7LFOtoIcwKNzJnXMqkUGx+2/yqbATGiZC9IKk
	Xlz3U4bDFS/rve+TdCD/eAvGUTYrR3OtLbcDQmMCuELqgsc3729eg/PJXpGA9WBIUIo=
X-Gm-Gg: ASbGncs+wQRawHz6qmuK/N/7G6oTR+eT3JOh2nlei/KnmGISK/U6XFWfLx4GX6znDT6
	798ZnEKoWIeWA/WC6r0l6hf8OmE335DeQvFbJJuye/9QdJTrISEOYsxczoCSSAi1bDlLvLTzl1B
	nvusZI9FyEP8/KxENkoE/uhU76V4ZPxxKPYHnRM4GJF44l7bITh4P2iPL/9M/KUHuu0rKZMYS+2
	A56NJKaGhEKPncA4oiEdE/qljU3PXO/jcI1/2KwOfDVqItvj6Ub06X4jcD5OSKtWwrSf2Dom0V0
	4gW/KN/jj0QuVYyx//o6cL5dIM9Y/C81Ta92MCyGj5AsCiZCZSBc3z0Rz424t56b7DCwKI19b38
	o88pS6IQkbMYGTLAAKLbVa88GKVgQlduAKs/fbHmmDMoYWESAUo+GQ82LC78orQCeXv8taypyDD
	5gxIhr0MYrhC9Lm6OxxcW+IWaq64QLcj2xGtKn6NMuhw8sxaBl8DnHdsk0Ojoxyj968wE=
X-Google-Smtp-Source: AGHT+IEp5YYm0eW3jhapM8OVullA+b9CRrzLXKAGXQfH68FS3XEeNccrfEDUvP/XIE+WOdxNSzgv+g==
X-Received: by 2002:a05:620a:4694:b0:8b2:e986:26ff with SMTP id af79cd13be357-8b33d469db8mr3847315685a.66.1764348416499;
        Fri, 28 Nov 2025 08:46:56 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8b52a1b6591sm338772785a.30.2025.11.28.08.46.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Nov 2025 08:46:55 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vP1cV-00000003Pw0-0IzM;
	Fri, 28 Nov 2025 12:46:55 -0400
Date: Fri, 28 Nov 2025 12:46:55 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Mostafa Saleh <smostafa@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, iommu@lists.linux.dev,
	catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, joro@8bytes.org, jean-philippe@linaro.org,
	praan@google.com, danielmentz@google.com, mark.rutland@arm.com,
	qperret@google.com, tabba@google.com
Subject: Re: [PATCH v5 05/27] iommu/arm-smmu-v3: Split code with hyp
Message-ID: <20251128164655.GB812105@ziepe.ca>
References: <20251117184815.1027271-1-smostafa@google.com>
 <20251117184815.1027271-6-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251117184815.1027271-6-smostafa@google.com>

On Mon, Nov 17, 2025 at 06:47:52PM +0000, Mostafa Saleh wrote:
> The KVM SMMUv3 driver would re-use some of the cmdq code inside
> the hypervisor, move these functions to a new common c file that
> is shared between the host kernel and the hypervisor.
> 
> Signed-off-by: Mostafa Saleh <smostafa@google.com>
> ---
>  drivers/iommu/arm/arm-smmu-v3/Makefile        |   2 +-
>  .../arm/arm-smmu-v3/arm-smmu-v3-common-lib.c  | 114 +++++++++++++
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 161 ------------------
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  61 +++++++

I would think these inlines should go in some -common.h instead of
arm-smmu-v3.h for better clarity, and ideally pkvm stuff does not
include arm-smmu-v3.h at all?

Jason
