Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 825AD1F1501
	for <kvmarm@lists.linux.dev>; Thu, 20 Feb 2025 10:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740048279; cv=none; b=BkOrb73sLCEslc6K30fCMwqLNkJJUeQBD0YOB4sfGT3MLuUY4Ng0YRU+OxZFxyvCDJJ+n4/bu80hP1t3B4/1RyOWh4ZkK4s+O4Ia+XPTXMC4sEOljvrhI4Eyikbm5QFFJ0kwDdpAefKnPld//V6VPJfk1sCTwodc4hoBVDtuqso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740048279; c=relaxed/simple;
	bh=Fb86F/s98TMvJ4cUg1/PPyhGm3sTGbln1z8pzYDMHiQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R3LsEGXphTZvXXYtMQh9Po64iVNyrHojWMYJlhPutsy9dps8XCR7IoIegzLliOTrHVKmlBi/0a4xyQJnSmLPBmxJGAYvkpD8sY7UyiNIYtTMwXgHPYLtXRY8BVfQJ+uvZJC3+wIrPwd9+vJsH7Ev1AGOWaCwhKK0GAUDM60eonM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DA6D916A3;
	Thu, 20 Feb 2025 02:44:54 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 882E73F59E;
	Thu, 20 Feb 2025 02:44:35 -0800 (PST)
Date: Thu, 20 Feb 2025 10:44:19 +0000
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 0/2] KVM: arm64: EL2 PMU reset handling fixes
Message-ID: <20250220104419.GA2511466@e124191.cambridge.arm.com>
References: <20250217112412.3963324-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250217112412.3963324-1-maz@kernel.org>

On Mon, Feb 17, 2025 at 11:24:10AM +0000, Marc Zyngier wrote:
> Joey reports that some of his PMU tests do not behave quite as
> expected:
> 
> - MDCR_EL2.HPMN is set to 0 out of reset
> 
> - PMCR_EL0.P should reset all the counters when written from EL2
> 
> These couple of patches attempt to remedy the situation. Note that
> they have only been compile-tested.
> 
> Marc Zyngier (2):
>   KVM: arm64: Fix MDCR_EL2.HPMN reset value
>   KVM: arm64: Contextualise the handling of PMCR_EL0.P writes
> 
>  arch/arm64/kvm/pmu-emul.c | 21 ++++++++++++++++-----
>  arch/arm64/kvm/sys_regs.c |  7 ++++++-
>  2 files changed, 22 insertions(+), 6 deletions(-)

I see you're discussing the API around this, but this does fix the PMU tests, so:

Tested-by: Joey Gouly <joey.gouly@arm.com>
