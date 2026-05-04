Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76FD43CF683
	for <kvmarm@lists.linux.dev>; Mon,  4 May 2026 12:15:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777896929; cv=none; b=exInOtTXSlpwF8cN28tBM2p0s9RzOMTX73R78ftN5TDKcCTooCCapIuNM4Vu7hdcwBN2MJZxE/UPrVDgAb2HhsxHlao+gH9Oih6MZ78SCqGa1YLyCr9lFUx1RcR17vwHIGs3sfbztBVRCveIgFwRk3YMpTklKC94d3PHznUH0kg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777896929; c=relaxed/simple;
	bh=0Gz54lwfSjPa9nG3Ep3MHdH6f66hi1ICCw0nKbi2tng=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MePDSxC3KfRTEjM3lzi6PRsnnArKNtUJy6sA3zMkmH0UMyd4Ja4MOUP6NXWKTHi3sYf3O1yGvLWM9Cjh6x/Ma/O3IcXqzzmxiCNAly/n3NiaybO9PHIYA2ccB1DC7cee2iznh1Owkqd5K3L7muLUZNGrVLBFpoC4zQWV3kRs/6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cqUIq+Cc; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cqUIq+Cc"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4891ad5c074so202615e9.0
        for <kvmarm@lists.linux.dev>; Mon, 04 May 2026 05:15:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777896924; x=1778501724; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=fF7JaMofibfK5YJZe9N2mfIM5JCfx6a/BKfKMnCAPBc=;
        b=cqUIq+CcQOHUaYLSpwFsHNpyZQKcjKGmvnmxKUx3znwH8HL4M8P/k/BDRmnZiTPfu3
         2iIKcq2gmWUQ2uqQjZd9iHKdPbJ8OesFbtVufr4P5E1NAxzKawNB+3YlCSt/7IUEFTS7
         2Y0i/brHQPdOA7eIWQc7Vkf2OC1xw9T/Yqki5QyYb/tdYiBSA2iWnkgxTbBVFwBZijgV
         hqgxVLexx9HCoHFL0gBZGKeAiOjYvrmKnf9SmCfvfR0uQcbMUD6299Pe1ZPCn9R9XXQ/
         nvV8ZfbO17tz93ax7tVvEmqy5qd+Jn7x27XlAIiKXf6B6kSU2SXXHomtewbCo4t5vLlv
         IhIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777896924; x=1778501724;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fF7JaMofibfK5YJZe9N2mfIM5JCfx6a/BKfKMnCAPBc=;
        b=XL8a+WzBgP1WYi7FhaIq/Q5UtXX1SPMXcF92HnL8cWkzwk+lin8IXlWUcReo/+SXPP
         SdRvXtsXA+cr2+n44Zya9N1iH/hkWbu+Os17MfZvQhPiKM429Wzq62JlkmnCI/8++/QJ
         /45/GZuNX+TWu9XgZlFbkeMwD6dlJWLuIgEDNfJr6n8dB9oU0PCvy7hQ9umgRgK58tdc
         DJkgyezgOW8MsRrEXMmGt4bABBeFj5xViV/6JO41mNsIRpWpYZpgZaolUvXW04yfCuDC
         YEWgAKaIuqwtR96dExaAoqMGusWhT3aEHlnv+tRD9v0yVH6JBYiZfewlL4Rer/OF+k3B
         xZHw==
X-Forwarded-Encrypted: i=1; AFNElJ99Wj75fIA3oGlJd+xcFS/j7NLtbDox7vdffgxYn86TVlO1RSCi77N0fzLaLEvDgwzp9ML/Ta4=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx0iaYc+vvTse1FFoncOUTY7R/5lC4RebV0OChxnzqcO82wWi+V
	Uc9DGwnTOUbk1q89xBE2PatuGloq5TpO6lQIB77y/5/u6PDoiwKwUK9PGdfxsevqGA==
X-Gm-Gg: AeBDies1pKO7hI8LQwrKWZwB4u55jW/ZcgL1NrVwWZ1ev4K1ykDrBteYSYfxLAMHrNn
	I1Qz931b7OH8akYUDQ6ti1siz5Pa7yQneYnTOy9VRA4Jp+SAN2eXolp8sseb00vbiPFN2KVH35P
	38LAyBk7Q51L28AuhdlOO5iSpsXGqwjbiJVGhgameUkhCb0NcfKvx3AkAA/gVeqWOE8vfna3T7X
	OHjmON/6sXnob3XQMmIJPNfeTUxTzfeJyJ1sxljcdGc2x9bfHmOc/iyCSoiAuIdAyh0yd6oFYRk
	BZSSXtsfb7pbFkgEb/oJsRdhJXy1/NHTU06fdijXPpP6FMzu6AMxNbUuOeYSOcCLXfIuWYveCZe
	yMmjAZk81mdQweb9mrSytB45nNN4BWMPl0C179xenpFlRIJFVgbuM5yz5PrbT5NpwqiSSOaa8fB
	TbjxwWsVhaJfmWcHpPj4573TQYDIKjjbx4qARi9JrzlptA4t4gV/GjixXDGbaMGVvhrGN4zQu92
	2ANnA==
X-Received: by 2002:a05:600c:8206:b0:485:2ab4:c1f9 with SMTP id 5b1f17b1804b1-48a9810f468mr968965e9.4.1777896923958;
        Mon, 04 May 2026 05:15:23 -0700 (PDT)
Received: from google.com (8.181.38.34.bc.googleusercontent.com. [34.38.181.8])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a8fe4b4edsm100731345e9.0.2026.05.04.05.15.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2026 05:15:22 -0700 (PDT)
Date: Mon, 4 May 2026 12:15:17 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, iommu@lists.linux.dev,
	catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, joro@8bytes.org, jean-philippe@linaro.org,
	mark.rutland@arm.com, qperret@google.com, tabba@google.com,
	vdonnefort@google.com, sebastianene@google.com, keirf@google.com
Subject: Re: [PATCH v6 04/25] iommu/arm-smmu-v3: Move TLB range invalidation
 into common code
Message-ID: <afiN1UwS9q6F6A_v@google.com>
References: <20260501111928.259252-1-smostafa@google.com>
 <20260501111928.259252-5-smostafa@google.com>
 <20260501124143.GB6912@ziepe.ca>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260501124143.GB6912@ziepe.ca>

On Fri, May 01, 2026 at 09:41:43AM -0300, Jason Gunthorpe wrote:
> On Fri, May 01, 2026 at 11:19:06AM +0000, Mostafa Saleh wrote:
> > Range TLB invalidation has a very specific algorithm. Instead of
> > re-writing it for the hypervisor, move it to a function that can
> > be re-used.
> 
> I think this is too narrow.
> 
> You should start at __arm_smmu_domain_inv_range() and shove all of
> that callchain into a new file "arm-smmuv3-tlbi.c" which you can then
> double compile for pkvm.
> 
> pkvm would have to present the tlbi description and the invs array
> which shouldn't be hard for it. Then it will enjoy all the same
> hypervisor optimizations we are working on for the normal driver.
> 
> I am about to send a patch series here for iommupt that significantly
> alters this. I think it will help your pkvm effort as the invalidation
> entry point becomes significantly decoupled from the
> iommu subsystem:
> 
> static void arm_smmu_domain_tlbi_inv(struct arm_smmu_tlbi *tlbi,
> 				     struct arm_smmu_invs *invs)
> 
> struct arm_smmu_tlbi {
> 	struct arm_smmu_domain *smmu_domain; // Can be removed 
> 	unsigned long start;
> 	unsigned long last;
> 	u8 leaf_levels_bitmap;
> 	u8 table_levels_bitmap;
> };
> 

I am not sure if it’s worth it, the hypervisor is much simpler, there
is a single page table, it’s locked (also identity mapped), it’s
updated on VM boot/teardown only, we don’t even use iotlb_gather at
the moment, although possible but I wanted to keep this series as
simple as I can then we can add more features later.
So this patch is the least intrusive change, as whatever the main SMMUv3
driver does, the range tlb invalidation logic is the same.
But I am happy to experiment with that when posted.

Thanks,
Mostafa


> Which pkvm should have no trouble invoking. It has to build an invs,
> but I guess that is pretty simple and done once at boot for pkvm?
> 
> Once done all the fiddly bits about building the commands would be
> shared. There is really no reason this should differ anyhow.
> 
> https://github.com/jgunthorpe/linux/commits/iommu_pt_arm64/
> 
> cover-letter: Organize SMMUv3 the invalidation flow so iommupt can use it
> 
> Jason
