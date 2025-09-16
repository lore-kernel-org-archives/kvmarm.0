Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83D3334575A
	for <kvmarm@lists.linux.dev>; Tue, 16 Sep 2025 15:19:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758035950; cv=none; b=JekwycEmvP9sorMcLElhYZIbvwaca/i9vO0sDnaO3ZkzDUkRWgb2vSVQbDe8By98B4o0fjvG51Il4YEom5VP6F80RgtRgyZqAqeE3x8LcCSx2smo2AR2U0m8pkwYAd6EapxPwEsWmdc6Sc6noG/o1FmNG0s1zLgzDWNGNs2AyDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758035950; c=relaxed/simple;
	bh=wBrIPR96d1vVz2LJ9BGOfDtmnzGJiG6F6ojCH1dA+qc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JQ2bGwcZrM2Mw6yP4yDtmV5cWiYGQKvhXy+lMgCqLCK0KJk541FW+ZaSiRXYe71+Ju1hQOWWnoYfjUK21DZzpzAigI2w6KCwKkh+Wdt+mjXUgNn5cxPRFSEJMDHBIX5gpFnpE+bWuMS6pLquLl7FyZvTg8S2b52TL0NZrRaK4nU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rSeenyNa; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rSeenyNa"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-45f2d21cbabso61905e9.1
        for <kvmarm@lists.linux.dev>; Tue, 16 Sep 2025 08:19:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758035947; x=1758640747; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=rIdF/st4oFvQewvhyAv6hWYWHihkA3x4ZWjHakET1Qg=;
        b=rSeenyNaRwRzOIq7rB9p1pZg3ugzmB7NNglG5P7xVJvc4bYBvyUHs6REyhGKUkJW/g
         OQzesJBzcPVMy8j2ykFerTpOpJGKLQp4vHYox2ugTlYGQx1fNcoAOEhbYyf/zPQL5OHJ
         f77k1ag+4C5nNO2vqFNoVXyV8fpKKzvu1qTaHXDLaj9tGumz/AvJTVZE5sB8mu9kOdaX
         zzQ4Sr0eQW4FUhO+EQxzcMl7f1F77KOKWsD3DtMEPVr2i6IaNTDPT8S1HFT5aV1ppFwR
         6Sd8OLVKulwb05CzKTszfLA0o0HlHQJCCl2T/hGTz8yjw0m25c+LrydOvuwk7jhETGOS
         PCmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758035947; x=1758640747;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rIdF/st4oFvQewvhyAv6hWYWHihkA3x4ZWjHakET1Qg=;
        b=Sy5J0zFJvR6Is3GJ3bl+il1sPOiPMv6cqctfqulK2WAzzt5HPaUPP/hSw/TBt5vYEQ
         58Lr0AKJ9iMgxbJHnU1CS7W4+LHRjmvILeOBI6xEHHrmkAduLI4asqtzjoFPL1DlWrdt
         aZ7jrugA1azYenze8ubQ6c4sD7CeqiO7cWtjzxqHSpTwrn0pAqj9iwCVw5FC8liFTXL8
         TJ8C4AvkZD7EbhCL9FB303B6/qTe0SN7nbscdmdwyu9ddcmy6lwidhG2JMRnwKPf3oVJ
         AAlFClo0AJmhvAkl3M3f4/I40Dv656ghYGuZ2ldVWQDjmhX5P9L6nQvmKEynA1gbrBS0
         Zk+Q==
X-Forwarded-Encrypted: i=1; AJvYcCWC49kJ3/aTj4LxItvlNzd/x7e9addW5xCIb6szwuIKbxTvxegOQnfgApR7HMJOJDXbbj6oOZQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YxENDnZQHy7bDLutpp6Wp5VcTjAJbnzb5CxmqoJU5BMQ1VBsqUK
	KYvYkqSs//qS4YNVgyeTKJ112uiH0S5G9TYcLO2TuQfP7VKF2knpsLmpMckHB0agSA==
X-Gm-Gg: ASbGncu9zJlY7AcXgQ4Fj4EP1PKI48dTcrXVBY1oOTXhSzRc3oxIn8GULWMN9GBT4Hk
	pmwCRXcpNF0SSJDZoPkMT5KDbBmJD0YxroORmwR4UAHaomb5l/bWydHk4QJFgZem38+qItRyunz
	Zp7WIMFeBw2kyodDndSExuSvmWBCnn98hEXSrhERj1nQNa9KdhlHNKtDmDPWmVOqzvD3mlvNBDd
	nBU2pZSwNV3LmnvYkOUHw54OLM57J7SQ5hUNqZp/efaX5gM0dP72ChdDK2EBPg9w5nGci0NA1VI
	T+n6dlyi5jdNC4RbwaVF4tSiIK7ufkrdF08p7z+RhG+PyCdYJvvpx5sFj2zhKsDTtHTcZTyxrF6
	BE7Gy87+aaE2LH8MhQpE+EyynZtPT0gIm+aGhvTHbhIw021A5Vj4sB/bASwmHoCC6ej05oQ==
X-Google-Smtp-Source: AGHT+IFZBaWrZvk9P69IbqntWvXL1sAk3O+k3JpJsQacEjetwuxi2scOhS4JAiiLO+ZhfieA/FFXgA==
X-Received: by 2002:a05:600c:8b6a:b0:45f:5b02:b0cb with SMTP id 5b1f17b1804b1-45f5b02b390mr1308995e9.0.1758035946681;
        Tue, 16 Sep 2025 08:19:06 -0700 (PDT)
Received: from google.com (157.24.148.146.bc.googleusercontent.com. [146.148.24.157])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45e41b6dbdbsm211187025e9.22.2025.09.16.08.19.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Sep 2025 08:19:06 -0700 (PDT)
Date: Tue, 16 Sep 2025 15:19:02 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Will Deacon <will@kernel.org>, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	iommu@lists.linux.dev, maz@kernel.org, oliver.upton@linux.dev,
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, robin.murphy@arm.com,
	jean-philippe@linaro.org, qperret@google.com, tabba@google.com,
	mark.rutland@arm.com, praan@google.com
Subject: Re: [PATCH v4 22/28] iommu/arm-smmu-v3-kvm: Emulate CMDQ for host
Message-ID: <aMl_5j8G3IGulAC6@google.com>
References: <20250819215156.2494305-1-smostafa@google.com>
 <20250819215156.2494305-23-smostafa@google.com>
 <aMQroI4NDu74PDGT@willie-the-truck>
 <20250915163858.GK882933@ziepe.ca>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250915163858.GK882933@ziepe.ca>

On Mon, Sep 15, 2025 at 01:38:58PM -0300, Jason Gunthorpe wrote:
> On Fri, Sep 12, 2025 at 03:18:08PM +0100, Will Deacon wrote:
> > Ideally, the data structures that are shadowed by the hypervisor would
> > be mapped as normal-WB cacheable in both the host and the hypervisor so
> > we don't have to worry about coherency and we get the performance
> > benefits from the caches. Indeed, I think that's how you've mapped
> > 'host_cmdq' above _however_ I sadly don't think we can do that if the
> > actual SMMU hardware isn't coherent.
> 
> That seems like the right conclusion to me, pkvm should not be mapping
> as cachable unless it knows the IORT/IDR is marked as coherent.
> 
> This is actually something I want to fix in the SMMU driver, it should
> always be allocating cachable memory and using
> dma_sync_single_for_device() instead of non-cachable DMA coherent
> allocations. (Or perhaps better is to use
> iommu_pages_flush_incoherent())
> 
> I'm hearing about an interesting use case where we'd want to tell the
> SMMU to walk STEs non-cachable even if the HW is capable to do
> cachable. Apparently in some SOCs it gives better isochronous
> properties for realtime DMA.

Interesting, I guess that would be more noticable for the page table
walks rather than the STE, as Linux doesn't invalidate STEs that much.
>
> 
> IMHO for this series at this point pkvm should just require a coherent
> SMMU until the above revisions happen.

I think the fix for the problem Will mentioned is to just use CMOs
before accessing the host structures, so that should be simple.
If it turns to be more complicated, I am happy to drop the support
for non-coherent devices from this series and we can add it later.

Thanks,
Mostafa
> 
> Jason
