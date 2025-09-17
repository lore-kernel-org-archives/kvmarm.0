Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37A4234BA3E
	for <kvmarm@lists.linux.dev>; Wed, 17 Sep 2025 16:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758126222; cv=none; b=S5aOzlDc22ELivr1+oozENPHx2yKcjGMpKsjwHD/lD3x1OUYmjuKdkMk+f/3oC8Y8haHbeYR3Iz/7Az9/mauqe+gE+mvdtv1/S+qggHhrM9e33Pk+Bq80yuh849VveT/sZO750Wgn2iLhx0cUKDS1JP82ZGvRfiMxJkhov0Rco4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758126222; c=relaxed/simple;
	bh=TzMcduB+dYNSr41rwhXSZY0U6gi844eOHxpTSsSIPn8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Qj/v5EANZJXzChQp87HyvCzKkl6qnPk3vCjyr+XVRrMuaGoSMyJ4PkW18opP/6pUBGKhbcVBIBOb5vfIe+RPYbXb6KmB2JLpX2oP1LgFBlIXhyg1FYJ3nsZ3c68wzYCMn0flH3YGpmhovELLGp2xeOmCOkY5+KhWrsIIr/UFnv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=coS8lQSd; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="coS8lQSd"
Date: Wed, 17 Sep 2025 09:23:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758126217;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VEWfwup8HkaFVKYNuzYL4Zw5tlWfBk4oey4f4O/y5yw=;
	b=coS8lQSdLxDOzsi5y+YOpKTBPky/cJt2tuWoMiaNAWZnBCictOlfwr6AfiL/2Fj6Pjys0h
	uWD4+wRSlAxbv5zGYGbqt00sceWNzJN35T67JXUeSfyn9kIA3UvmaIB5PPPvSM9u+F4hOF
	tM5aAlI01f1Pxb2gIhgAdTySJxg3Ypo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Fuad Tabba <tabba@google.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	maz@kernel.org, ankita@nvidia.com, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org
Subject: Re: [PATCH v1] KVM: arm64: Fix page leak in user_mem_abort()
Message-ID: <aMrgeuZur2Zd6ybX@linux.dev>
References: <20250917130737.2139403-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250917130737.2139403-1-tabba@google.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Sep 17, 2025 at 02:07:37PM +0100, Fuad Tabba wrote:
> The user_mem_abort() function acquires a page reference via
> __kvm_faultin_pfn() early in its execution. However, the subsequent
> checks for mismatched attributes between stage 1 and stage 2 mappings
> would return an error code directly, bypassing the corresponding page
> release.
> 
> Fix this by storing the error and releasing the unused page before
> returning the error.
> 
> Fixes: 6d674e28f642 ("KVM: arm/arm64: Properly handle faulting of device mappings")
> Fixes: 2a8dfab26677 ("KVM: arm64: Block cacheable PFNMAP mapping")
> Signed-off-by: Fuad Tabba <tabba@google.com>

Yikes, nice catch.

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

Thanks,
Oliver
