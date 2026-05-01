Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB9453A5428
	for <kvmarm@lists.linux.dev>; Fri,  1 May 2026 12:41:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777639308; cv=none; b=BuIiF7U4cQ/Xv1X+2J0b5lxbdEl3mz4GM16QkIFDvR58IXYvP1Uyn0lKGs+K+unOzZ+podNDX9ZA6rdh+dqpADVTCNJTtd4wjHBCuaQQQ4VUefqgaSIXptPK5kJHk5nwvHlzhnEhU9S9X6ZRkbZuioWw8lMzAd5WjPcBmrHodv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777639308; c=relaxed/simple;
	bh=yfsSDvdRmO1iaabYp9r8F4bUp37m0+9RdlEMuJAwRXU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B+lCTgZIQ+6p+2bgB9mgxX7xY/tevDOP1EHnvM0kKllyNokWWAGhg2Bm1ugLOLYjizyN1E31JMJo/hK10KRCj7JmDJw++nGwvBRJnYdHwbMWgkTchDaMjQFXCcXOHteBJbSlBv1o/KiTmwSYMqLar+gN70w7wstl49odZ3yaOaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=YNU5o1bz; arc=none smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="YNU5o1bz"
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-50fbd79350dso17008881cf.3
        for <kvmarm@lists.linux.dev>; Fri, 01 May 2026 05:41:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1777639305; x=1778244105; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2W3ZOFfDhqX8vh6C4yIuWTuxJv6mmoplDTMsMIIiSDs=;
        b=YNU5o1bzHt0z3e273K3tZy0rh2AJsXtz4muhC8aAcqL6Epg9TNd7d9EeDkzGuA2K8J
         NThPh9QjiWd1Jw/HE7nGL2RYdXvgVzZ0IxmRfT/tJPXVEA7PuLaQMal0Jm7kJIGndiV3
         2+m3B4kc4x/eiNAJk76bG4CCSmo5w4E5XkFamITiGtW/143yJI6nzMuAQGGQHOtQdQG8
         yCoZA+iEh37A70Ouxe836Vw2jy8A+yMZX5er7bjSrcYjpNHKRjYz1fPwXRLbw5P5Fe4w
         PR8LPrKd6ujVol9qA62gIUZxy+YLz11juqAYoRoDsh9ckpdeJRZALaAGwle4tdqXjQZQ
         d5fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777639305; x=1778244105;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2W3ZOFfDhqX8vh6C4yIuWTuxJv6mmoplDTMsMIIiSDs=;
        b=tSMr9muFA7uj1Owl5ba7GadTcZiVG+EN4ta8UrqOTbgrByLBEMUfBO+QjyULGqyjo4
         +AWFFIy4GNzjYPSPXG7brM1MOYcVDyO/Dj8EokX2aETMuOmHuQOodnyqz/aEUkt9Ymde
         4b9KuDRAMdn4Kd4dde7if3/IGDOOv1+Qx+rZ0A0JBDcahlRKSlh/2eQSqxzl4BqZ5ZR6
         fp8BN4id2r7SQRI1GrS2Yn6a8nN5J7RMdFUaXNjgD1H4EtkFcib4Pe2NMlwq8BPgJZZD
         Ec4KV3TaainTXzypTkzQKHvNHhTyhgHolhsqsZtldCVPGtU80rO/pzu1LbOXcpBliR61
         o1UQ==
X-Forwarded-Encrypted: i=1; AFNElJ+gRsiezACaC4rbhWHhWJSKF4vQPpjCvPvJBWpVbQb+ZgyBHMhg6/TsTR2x5Wl/il7IbDbdzC8=@lists.linux.dev
X-Gm-Message-State: AOJu0YxD9crNC6hBnRHOmZMj+PLlWSSLihwOUvoNEjqQ++xjM7QmHG5C
	nONsaLwCVIO3Df567GvSIbjVyWBCs+egUTbsWmzvKIwx/wsUD+d5wvmy2RZIVXtvBJc=
X-Gm-Gg: AeBDievSJolNnyjTFJt+B9BxT/Zq6FcgBuA9+WmLpTI/J+O9McKiRPNjhaVybDJhk7g
	Bo/+Ky+GRH9TIZbJObg6j0B+vHhS8LZsUPTipHvhN8V5ruj0JVmqvoAyHzQWi29xoBLaAljhShK
	PZdag/gDnbvP/RwlK9gIAaX6Xptz1xwqPzEuIMfYqhIPXb9KHnoj5iWdBPP4/0xB1XVt99UgbGc
	GBFXmtx277yRhPTRSFm5+rvF6DbEsa8EndrEz0CuzeizKe5yRij4sZHHdgImMUJDiGq+AogrOaN
	Ko3tcFEhGsMOk/V+vX0SJW8XcKjaCsYB0EfdU9g3uB3P6PA2KuR+10IJbb8q9ULZQHe/4iVVYcy
	+2Q3+ScvdJsXNnoswRA6qcPnmD7XgeHgUOgz1jvlMvsXa2YNikysu1ZJc0g5h+ipXBSgzDVS/q4
	H8KxRwWWIw8kePV0271194tRG8G8Gkmg5n+hjoFKylb/XRHTB5lcnzJsj2iyfcwZXr1g4qdesKd
	I+TIccUJExKGq1F
X-Received: by 2002:ac8:7f84:0:b0:510:1b61:d0e4 with SMTP id d75a77b69052e-5103e8fad49mr37362611cf.35.1777639304723;
        Fri, 01 May 2026 05:41:44 -0700 (PDT)
Received: from ziepe.ca (crbknf0213w-47-54-130-67.pppoe-dynamic.high-speed.nl.bellaliant.net. [47.54.130.67])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51040b8174csm14655201cf.25.2026.05.01.05.41.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 May 2026 05:41:44 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1wInBf-000000058bc-2ERN;
	Fri, 01 May 2026 09:41:43 -0300
Date: Fri, 1 May 2026 09:41:43 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Mostafa Saleh <smostafa@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, iommu@lists.linux.dev,
	catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, joro@8bytes.org, jean-philippe@linaro.org,
	mark.rutland@arm.com, qperret@google.com, tabba@google.com,
	vdonnefort@google.com, sebastianene@google.com, keirf@google.com
Subject: Re: [PATCH v6 04/25] iommu/arm-smmu-v3: Move TLB range invalidation
 into common code
Message-ID: <20260501124143.GB6912@ziepe.ca>
References: <20260501111928.259252-1-smostafa@google.com>
 <20260501111928.259252-5-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260501111928.259252-5-smostafa@google.com>

On Fri, May 01, 2026 at 11:19:06AM +0000, Mostafa Saleh wrote:
> Range TLB invalidation has a very specific algorithm. Instead of
> re-writing it for the hypervisor, move it to a function that can
> be re-used.

I think this is too narrow.

You should start at __arm_smmu_domain_inv_range() and shove all of
that callchain into a new file "arm-smmuv3-tlbi.c" which you can then
double compile for pkvm.

pkvm would have to present the tlbi description and the invs array
which shouldn't be hard for it. Then it will enjoy all the same
hypervisor optimizations we are working on for the normal driver.

I am about to send a patch series here for iommupt that significantly
alters this. I think it will help your pkvm effort as the invalidation
entry point becomes significantly decoupled from the
iommu subsystem:

static void arm_smmu_domain_tlbi_inv(struct arm_smmu_tlbi *tlbi,
				     struct arm_smmu_invs *invs)

struct arm_smmu_tlbi {
	struct arm_smmu_domain *smmu_domain; // Can be removed 
	unsigned long start;
	unsigned long last;
	u8 leaf_levels_bitmap;
	u8 table_levels_bitmap;
};

Which pkvm should have no trouble invoking. It has to build an invs,
but I guess that is pretty simple and done once at boot for pkvm?

Once done all the fiddly bits about building the commands would be
shared. There is really no reason this should differ anyhow.

https://github.com/jgunthorpe/linux/commits/iommu_pt_arm64/

cover-letter: Organize SMMUv3 the invalidation flow so iommupt can use it

Jason
