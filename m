Received: from out-185.mta1.migadu.com (out-185.mta1.migadu.com [95.215.58.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E1EF7E562
	for <kvmarm@lists.linux.dev>; Wed, 13 Dec 2023 20:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="T6LceOf1"
Date: Wed, 13 Dec 2023 20:24:59 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1702499103;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tNO556z6FFu06V81OQ+zyHsSpgoOG3daD8uh3SUI1ew=;
	b=T6LceOf1lh7wrllqQaFpMBvKcbmWs5Pk1nsncOiFxJKxrkHkBzMfunILFugu3pMqCSi4l1
	JxX1ftanMmMjMTsZ0G/v3WfDCy51zMJ78l7UAA9EsRVeCzyoMxsfin/ewGmRjUtgwUpLaX
	59UfWFQsum6fJnvdJllp7g0LlINclcA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: James Morse <james.morse@arm.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	Marc Zyngier <maz@kernel.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v2 0/4] KVM: arm64: Hide unsupported MPAM from the guest
Message-ID: <ZXoTG1Y4O16Cjq39@linux.dev>
References: <20231207150804.3425468-1-james.morse@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231207150804.3425468-1-james.morse@arm.com>
X-Migadu-Flow: FLOW_OUT

Hi James,

Thank you very much for posting these fixes.

On Thu, Dec 07, 2023 at 03:08:00PM +0000, James Morse wrote:
> 'lo
> 
> This series fixes up a long standing bug where MPAM was accidentally exposed
> to a guest, but the feature was not otherwise trapped or context switched.
> This could result in KVM warning about unexpected traps, and injecting an
> undef into the guest contradicting the ID registers.
> This would prevent an MPAM aware kernel from booting - fortunately, there
> aren't any of those.
> 
> Ideally, we'd take the MPAM feature away from the ID registers, but that
> would leave existing guests unable to migrate to a newer kernel. Instead,
> use the writable ID registers to allow MPAM to be re-enabled - but emulate
> it as RAZ/WI for the system registers that are trapped.

This is certainly a reasonable approach, but TBH I'm not too terribly
concerned about the completeness of the workaround plumbing that we need
here. Undoubtedly what you propose is the most complete solution to the
problem, but it is somewhat involved.

So long as we don't break migration at the userspace ioctl level I'm not
too worried. Maybe something like:

 - Ensure the reset value of ID_AA64PFR0_EL1.MPAM is 0

 - Allow userspace to write ID_AA64PFR0_EL1.MPAM as 1, *but*

 - KVM reinterprets this as '0' behind the scenes for the final register
   value

 - Add the MPAM registers to the sysreg table with trap_raz_wi() as the
   handler to avoid the unsupported sysreg printk, since it is possible
   that older VMs may've already seen the MPAM feature.

We've already done something similar to hide our mistakes with IMP DEF
PMU versions in commit f90f9360c3d7 ("KVM: arm64: Rewrite IMPDEF PMU
version as NI"), and I think MPAM may be a good candidate for something
similar.

-- 
Thanks,
Oliver
