Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18E373E1D05
	for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 14:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790087653; cv=none; b=lWYHHWqij/AtcmjH2T9PPnXSR6NXOb2+6u8e7GdjcDu67BviM6m3oQLXO/KtF3LI5Vz/066bC8gJHqi16mikMIJlPUiCTn1xuPdIJkP3RSRRqvyGwMPcqaHg3iGuTdKywffNk448bgE7BIStcrmV1qTfyDHPoblOVsQDOXhgNzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790087653; c=relaxed/simple;
	bh=K21XGOUA9YfV1+eQEuI51oLR4dYD99Sxvqak9SUwBjo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qneSFF/CHAAMRLg9uaADc26WkcxldV2LdCMpX0RPyvkDussNSigjGxPa8+WNtPLyEoKNW21rYvjJ2IgZEzySQFWdeGRD6PCIwU1RQybfcQCh0A9l1UVGOnX9Gc8BU9XoQGMKwa/9wsicNjP3IxFVYZFpfOSkDoNL/T7toZarH4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jy+44kfl; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jy+44kfl"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-498012a61f6so43655e9.0
        for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 07:34:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790087649; x=1790692449; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=YmpZ+Mv1AgiT9MIxHNsuvdnEJp2bjZlRzb8als0FR8E=;
        b=jy+44kflb5hbg5/BmXhRR8bRajGj3YYTvAxogbXXnfSu02ABjKC+lvlFW9HvKO7+v2
         rcWaBa7PT4QtWjrdYBOwtTbP4vXnUkNlFKRq/RgqAQAM6oTB0ZFsdBypDKX3J8Llt4qZ
         atBo+TtiPNJ022Wz8WgbKtnDVLZYJNDOxI/WQyP7cXg+ifg4/sMpYONq5kNlZcj4ex5I
         X/f4NJKOf6Y41OQ+fK4A0doD/VxufJBeNdxu2WX/Y9JkK0Dt60DgH/vL99AOhxMUlZkv
         ilUN5PGl4OEIUMWMQqkY94jgs6PLlQIhT2GjiW9Go9LrDcUk7Vo9ddmJDYnUEdiDTHZR
         9XVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790087649; x=1790692449;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=YmpZ+Mv1AgiT9MIxHNsuvdnEJp2bjZlRzb8als0FR8E=;
        b=i9FF8jdx7A7cDDeZjL34zME1vqa61xHDcohZ6/s1TSUVbOcei1hbXPJbrSE06oggzE
         AH4hQWMws6/D/X9QHuBC8vB11nToFidcyvWv8gfTNQvn3XJsWYKiDEJYYrxy0Oh4x+AN
         JLvIb9sc2Yp0DOjvVF6DMVRE9s0kMkm52RwNnHcdd/ZFP/JQU3XavfKBqyNN/GTFcB80
         xQRaPxtzgBzbkKhN3FdJ0sO4ongcNTI9IZkGVf6+W33WMfXxyyyPDph0n4p2vi+AQZee
         7RgorlMG9c7IGxHZpXYP9OgRT8zyS4NU4QZiDDu6z1RF2LxsKfrG8BH3r5jSID5MvdWl
         yAmA==
X-Forwarded-Encrypted: i=1; AKwUvBytAzf8A4WRrTsERrD4QVr6zXy5NHcSwxJwvvBQEMGuyZZB9TqTQhBFo++kCXMYDR7vryq/9KQ=@lists.linux.dev
X-Gm-Message-State: AFuF++kka8f6Qu+AesP9ouUzypI28y6se+Xt9ML3E4oH2dPMk2tHl1V3
	iGkS49SBmQhlJeMhHLNrmUHLVMfOPLiaGr1qzwSQE7oF/SobDTmYYrF/YKqtl2jGVA==
X-Gm-Gg: AYBFou27ZUo+xW7YeEypNb/T2AzjznyJug8jftbleRsq9zyr1Hyv0JAweBzkwdkIL3C
	SyDN0hfgQr+r+VI4oKrkgwq2gJ/zAcxFWxnRiJRyKFlUYVhe4yLOdUFsK6QZeKr6uQsnSjFUBNl
	uKuk4uyWv/DUeaeaJSyx4S21YUE9oBrHFq/+n4MtZhDdiDEaPz32d18RgWpMUJ01F80YQfAwwsB
	24/WLkPMHEvftA7tNC/KcB2bKumzD2Zti3FUzKHGPQ9vNX2x/cgj8Ur34YdRJqpSYciKXaAXDY4
	o76C6fh3Cf5tZoTi1z0OPnZ5SfWRk6XbdlZH1gRucjb56DTs0M4h6gOROc3rfsjlZKeo0DueEfA
	GJkgHJR98XZk6j3kPBs+i7Smz5T6AhSQ5qQrAuiqJ0/6FYFQ5CGxG7fJbn1OarOsM09hF8iDWmf
	1iOSO0g+ni3dMmjQZuKnZ03TJImG2JNj+/BoLpWknn8+NCB3qVij7MMyzxw2fCpeSfPqeHC8kIG
	aXnWncARD8ZMJtPivcZnalhgZsg7gVdmkKS0vbI
X-Received: by 2002:a05:600c:6005:b0:49e:642a:9279 with SMTP id 5b1f17b1804b1-49fdd97d911mr93055e9.4.1790087648466;
        Tue, 22 Sep 2026 07:34:08 -0700 (PDT)
Received: from google.com (250.192.189.35.bc.googleusercontent.com. [35.189.192.250])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fdab0c240sm38525415e9.4.2026.09.22.07.34.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 07:34:07 -0700 (PDT)
Date: Tue, 22 Sep 2026 14:34:03 +0000
From: Mostafa Saleh <smostafa@google.com>
To: sashiko-reviews@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
	Oliver Upton <oupton@kernel.org>
Subject: Re: [PATCH v8 08/25] KVM: arm64: iommu: Add memory pool
Message-ID: <arKR23P92jOirpn-@google.com>
References: <20260922131259.2975334-1-smostafa@google.com>
 <20260922131259.2975334-9-smostafa@google.com>
 <20260922132531.4E3C91F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260922132531.4E3C91F000FF@smtp.kernel.org>

On Tue, Sep 22, 2026 at 01:25:30PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> - [Medium] kvm: incorrect WARN_ON() on expected OOM during IOMMU shadow page table allocation
> - [Low] kvm: math error in early_iommu_pgt_mem() bounds check artificially limits IOMMU pool to 4GB
> --
> 
> commit c0283e6a54103e1cdad88307cf87917d222a0087
> Author: Mostafa Saleh <smostafa@google.com>
> 
> KVM: arm64: iommu: Add memory pool
> 
> This commit introduces an IOMMU memory pool for shadow page tables, allocating
> it early from the KVM carveout based on the kvm-arm.iommu_pgt_mem command
> line parameter.
> 
> > diff --git a/arch/arm64/kvm/hyp/nvhe/iommu.c b/arch/arm64/kvm/hyp/nvhe/iommu.c
> > --- a/arch/arm64/kvm/hyp/nvhe/iommu.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/iommu.c
> [ ... ]
> > @@ -122,6 +123,14 @@ int pkvm_iommu_init(void)
> >  	    !pkvm_iommu_ops->host_stage2_idmap)
> >  		return 0;
> >  
> > +	if (!nr_pages)
> > +		return -ENOMEM;
> > +
> > +	ret = hyp_pool_init(&iommu_pages_pool, hyp_virt_to_pfn(pool_base),
> > +			    nr_pages, 0);
> > +	if (ret)
> > +		return ret;
> > +
> >  	ret = pkvm_iommu_ops->init();
> >  	if (ret)
> >  		return ret;
> 
> [Severity: Medium]
> Does wrapping pkvm_iommu_snapshot_host_stage2() in WARN_ON() safely
> handle expected out-of-memory conditions?
> 
> Looking at the rest of pkvm_iommu_init(), it ends with:
> 
> 	return WARN_ON(pkvm_iommu_snapshot_host_stage2());
> 
> The snapshot function walks the host page tables and allocates memory for
> IOMMU shadow mappings from the fixed-size pool configured by the host via
> kvm-arm.iommu_pgt_mem.
> 
> If the user-provided pool is too small, the allocation fails and returns
> -ENOMEM. At EL2, WARN_ON() expands to a fatal BRK instruction, which panics
> the hypervisor and crashes the host.
> 
> Could we return the error directly without panicking, since this turns a
> recoverable initialization failure into a host-trusted denial of service
> vector?


Yes, as mentioned in patch-7, this is by design, the IOMMU pool should
never get -ENOMEM similar to the CPU pool.

Otherwise, recovery from this would be too complicated as the hypervisor
already poked the HW.

> 
> > diff --git a/arch/arm64/kvm/iommu.c b/arch/arm64/kvm/iommu.c
> > --- a/arch/arm64/kvm/iommu.c
> > +++ b/arch/arm64/kvm/iommu.c
> [ ... ]
> > +static int __init early_iommu_pgt_mem(char *arg)
> > +{
> > +	unsigned long long requested_size;
> > +
> > +	if (!arg)
> > +		return -EINVAL;
> > +
> > +	requested_size = memparse(arg, NULL);
> > +
> > +	if (requested_size > UINT_MAX) {
> 
> [Severity: Low]
> Is this math check bounding the IOMMU pool size to 4GB?
> 
> The early_iommu_pgt_mem() function parses the user-requested size into
> bytes, and bounds requested_size against UINT_MAX.
> 
> Since the target variable hyp_kvm_iommu_pages stores a page count as an
> unsigned int, the byte limit could safely be much larger, up to
> (u64)UINT_MAX * PAGE_SIZE.
> 
> Does this artificially reject valid configurations on systems with massive
> RAM that might require larger page table pools?

Not artificially, that is added due to the hypervisor buddy allocator
limits, I sent a separate patch for that:
https://lore.kernel.org/all/20260715150125.2798116-1-smostafa@google.com/

> 
> > +		kvm_err("kvm-arm.iommu_pgt_mem is too large\n");
> > +		return -EINVAL;
> > +	}
> > +
> > +	kvm_nvhe_sym(hyp_kvm_iommu_pages) = DIV_ROUND_UP(requested_size, PAGE_SIZE);
> > +	return 0;
> > +}
> > +early_param("kvm-arm.iommu_pgt_mem", early_iommu_pgt_mem);
> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20260922131259.2975334-1-smostafa@google.com?part=8
