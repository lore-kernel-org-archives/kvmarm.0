Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54BA93A1E7F
	for <kvmarm@lists.linux.dev>; Fri,  1 May 2026 12:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777638268; cv=none; b=lbIIUYekyeODhazUo91Rnm2K+BW7gowAO0TSvoipCyXi9jDOzfeO0eYeeuavKi2d0ZN22Ha2SmNY5W4VqjrW7Gi30btBEbuYDq0WsFl6SGgiT1pe5wJlOIW1RFIy/Ub67Lz42BKPpgknLkgjkIDU1Fu6Po7DTdPIt5t9l1zCmrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777638268; c=relaxed/simple;
	bh=luClRKdKtr+gw6gaUUzzdrRT4LDrSrv4Cxo3nK/hb5s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R+cZ4fPMhdNKJ/fMDGZ0X3WesMw5fCebl9iLInzaAR6AXn4n4y86edgZVqXz7o/r4XVglw5Kh/SSiPRU8n0TkU1uTAcgFlvQm2xuj0jGDKGvQNa2lG98eTm//aDcRhnuwz/U2xjFcHs8Y/LwAw3WkQwsJX4oEStXyA/sEEO32PI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=iwzgfwV2; arc=none smtp.client-ip=209.85.222.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="iwzgfwV2"
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-8ee62a19730so202389985a.3
        for <kvmarm@lists.linux.dev>; Fri, 01 May 2026 05:24:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1777638266; x=1778243066; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=SxL2PZx/4KiAYlM/BSrsH2KIM4aSQy8bJWmezhmWpbU=;
        b=iwzgfwV2SyQUgS9XtoqPPArBWP/kdDMSgVmBXtD9y7BiQfQPdYlgNhQBIY3RUdNH89
         LYboIV/buR+ZgNQynlmvZy8jqGULgYmj2/neuE7KFyJ/Mf6MPmJodNzHNbTS77GjS1Ku
         6iOj5hPx5A2+pc19+vNavOCg8pVbrQ7g9AyplPJ0z0Ref6K24q+1lY71tHTQPcPjxBMa
         MxBeMKtukpyw1xzsbamrTk1rWUIeOoC79RkudzTedjrG+ayG4BEo2d8jWSbMHv9zAU4Q
         jMuOq6qLpLA1TT65xw5gX5pOfGvmRb8iqvuW1Jh8/Igg8kNeV1YmZTFa01EEtyTiHUxZ
         AZnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777638266; x=1778243066;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SxL2PZx/4KiAYlM/BSrsH2KIM4aSQy8bJWmezhmWpbU=;
        b=YikLLdbhnmwUNkk65pue2Z0D1B9z2daag9Yaody5FCekwjoC5YxxebeYLy4g+ijvgV
         EGsBxDlFxcMoGlUcKETUYlN7sUPtbI5zdxmRJBY/4p4VSVpCZqBx2X3vCMEhw145Tjqj
         B9BJdSyTQ+b6EOTP0gmL2QptYPSd51tzSMSxDJNCQQYCZs8pBBjH5tsNLh0lqQWnAJSs
         iS11UPFrmJwwfvd7bLGCcsR58gZ2NMwdtewFX4HRj9YbFsw6GgWbjIiJctO7zRxZ5mon
         Q/z9srC7rIsTRiyRlyGxrZBxX+Z3nZPEZPoZp4bOzyZb7bBa3lV2Hb00Z7CLIhNpVoEK
         /7QA==
X-Forwarded-Encrypted: i=1; AFNElJ8tMQ7oD4w7Kk9zyGEFjI2G4sG7vNQ8xPOZf6my+kHnwHQZhdcVkLBOxTxiL5ORkV90b0Elb2Y=@lists.linux.dev
X-Gm-Message-State: AOJu0YzQDagp0tO3miscGsMA4114Qllv2qerf4cItFDzxr3OxtxnKiin
	wUlzUt1QQZEK2lVStJ/uQdlt2QYvVbexA1iyDINsSI0EMV+jw0Yg8mokNYw6se6SLkc=
X-Gm-Gg: AeBDieucqFXW6qh7LESjgbZyHQ4Fr2T8w5fNSMs56YwbTGX5b69t0OruVEyIJSH09uL
	8lZbiCgtWSZzunCsZ9xNIedQfSk8MEt0etaJbSnrL1HH2yNfWEr2jVpZdzxG4t+fvfbk0F9vnxA
	Ief90DsSwhsNRz/yapd3TvFpdleRcQEmohoZrFz1c1+7W0Z1qDqhCNlFI0CEi6dt6HHodYAmqcH
	K5fCEKzHw783tUDGVzOSNTjeUDMX3MKJJnfidExMlZAbJPOSdaKlmphGJ7AGbPY2RNt7lTH7WzU
	m+X1/mIf7pBdPbDW2EcCQ+ANnMFc4Kf0LLa3aSZne+hOKDAnWJno+lrXQtKpmmV008+O/ptx2aJ
	N9mbURrPpQo1FYekY6vfcfTkuHHoai6mkdvMpVnjxQDTnzuwcLlOb+/KOfEieLu0xISr3TiWYCi
	S285YR8y4mNfR7ffSVDd/FZFPBFswa+6GYot2Fr5UD45gAzQd/BmKoivif78veWSXBS8Qf0938/
	zkBLHcE3mwEW/MzAgGJxL0++sA=
X-Received: by 2002:a05:622a:1354:b0:50d:5f34:9a with SMTP id d75a77b69052e-5102add7284mr102979121cf.28.1777638266137;
        Fri, 01 May 2026 05:24:26 -0700 (PDT)
Received: from ziepe.ca (crbknf0213w-47-54-130-67.pppoe-dynamic.high-speed.nl.bellaliant.net. [47.54.130.67])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8b538c14514sm22998866d6.8.2026.05.01.05.24.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 May 2026 05:24:25 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1wImuu-000000053e9-3BRf;
	Fri, 01 May 2026 09:24:24 -0300
Date: Fri, 1 May 2026 09:24:24 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Mostafa Saleh <smostafa@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, iommu@lists.linux.dev,
	catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, joro@8bytes.org, jean-philippe@linaro.org,
	mark.rutland@arm.com, qperret@google.com, tabba@google.com,
	vdonnefort@google.com, sebastianene@google.com, keirf@google.com
Subject: Re: [PATCH v6 06/25] iommu/io-pgtable-arm: Rework to use the
 iommu-pages API
Message-ID: <20260501122424.GA6912@ziepe.ca>
References: <20260501111928.259252-1-smostafa@google.com>
 <20260501111928.259252-7-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260501111928.259252-7-smostafa@google.com>

On Fri, May 01, 2026 at 11:19:08AM +0000, Mostafa Saleh wrote:
> To prepare for supporting io-pgtable-arm in the pKVM hypervisor,
> we need to abstract away standard kernel allocations, frees, virt/phys
> conversions, and DMA API mapping.
> 
> This patch introduces a set of generic wrappers in iommu-pages.h:
> - iommu_alloc_data
> - iommu_free_data
> - iommu_virt_to_phys
> - iommu_phys_to_virt
> - iommu_pages_dma_map
> - iommu_pages_dma_mapping_error
> - iommu_pages_dma_unmap

Wah? This has nothing to do with iommu pages? This just leaking
everything iommu pages abstracted out :(

When I said to use iommu-pages, I meant to use the existing API, not a
completely different one.

From an iommu-pages perspective the issue is this code open codes
dma_map_single()/etc instead of using the API surface
iommu_pages_start_incoherent()

This is annoying to fix beacuse the external allocator messes it up,
but I think with some #ifdef you can probably fix it up.

So.. I suggest you update it to use the iommu_pages API, #ifdef out
the allocator so the pkvm pkvm doesn't need to deal with it. Then
compile a special iommu-pages for the pkvm side presenting the same
API.

You should have a pkvm shim header that provides
kmalloc/kfree/virt_to_phys in the normal way and just #include that in
io-pgtable when doing a pkvm build instead of hacking up all the code.

Jason
