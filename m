Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F2AB2BAEE
	for <kvmarm@lists.linux.dev>; Fri, 19 Apr 2024 20:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713559355; cv=none; b=VBC7XpRpxluEKuV1lQIJlVnB8eaPwO+7btBPmVnWUarNMyvzenkIirMp+bbn4xNxZotL2lv+rpnxf8xiMtEmTrXL9Dsd84KnqksBRsUWK/zrMAJdXPFQAmICZQX3R81H9omNsIterWxkEQPNoXe0LtOA/Hu/eis27PSOeP68Ul4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713559355; c=relaxed/simple;
	bh=CUPah+/HTMQGBUquSp3Z6+22COc+PvnprnSc5pYvwk4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B4sYhPVxOxlPH+EborHwYWazoNyxLxY8y/GNC3kfz+0ChkJp1zxng5bDBVFHf02Nc5jyjnIRhmZOhxl0Em1QLPFAb+nl61HQuSVUIsDpA6cFdPHkpUnXYelN5mTiLBP9faZl07YlbCd3G1lRIMrUGFdIpqtn01SSnMw7IXXfC0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Oho0n0YA; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Oho0n0YA"
Date: Fri, 19 Apr 2024 20:42:26 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1713559351;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=myXM7mlnEcsFhu94nqY/qoGDHPyXeSJUIsv+GRr2k2M=;
	b=Oho0n0YA5et95Xvow62jGjxU386vqG+ilmmOh2Asyo3/C5OQA3EsebLwR+73LUEJtiJJkt
	BQW4I7yMXu0Pc+Zeom3Ynn5X7YQIs1A3k2CsqUXAS5Q4A7JWnHlBI7yAA2xIXrGQ6bHlyc
	5IznwXWflV0d3IuHWsre8tqVRrdS0nY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Fuad Tabba <tabba@google.com>
Cc: kvmarm@lists.linux.dev, maz@kernel.org, will@kernel.org,
	qperret@google.com, seanjc@google.com, alexandru.elisei@arm.com,
	catalin.marinas@arm.com, philmd@linaro.org, james.morse@arm.com,
	suzuki.poulose@arm.com, mark.rutland@arm.com, broonie@kernel.org,
	joey.gouly@arm.com, rananta@google.com, smostafa@google.com
Subject: Re: [PATCH v3 11/31] KVM: arm64: Remove locking from EL2 allocation
 fast-paths
Message-ID: <ZiLXMo1nFkgXGS-H@linux.dev>
References: <20240419075941.4085061-1-tabba@google.com>
 <20240419075941.4085061-12-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240419075941.4085061-12-tabba@google.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Apr 19, 2024 at 08:59:21AM +0100, Fuad Tabba wrote:
> From: Will Deacon <will@kernel.org>
> 
> hyp_{get,put}_page() are called extensively from the page-table code
> to adjust reference counts on page-table pages. As a small step towards
> removing reader serialisation on these paths, drop the 'hyp_pool' lock
> in the case where the refcount remains positive, only taking the lock
> if the page is to be freed back to the allocator.

Surely the ordering of these patches is wrong... The refcount accessors
are non-atomic until patch 27.

-- 
Thanks,
Oliver
