Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BB2071B3D
	for <kvmarm@lists.linux.dev>; Thu,  8 Feb 2024 12:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707394487; cv=none; b=WRyNdmS7F1nPP3KVFCdDZ7F0TsUvARHtEauaIADl6fDZ0FPdYUYyWgTeudMFx5e++l+D2f4IgbaVTIe6Jpa398ykcWo1CA5rgHSv7oIAtMbozBWmXj05pxhGBlSJc06z0/1Zq83ZGBL7lNtZ8fuxRFIfUA74RV+axk+xq1ak6wI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707394487; c=relaxed/simple;
	bh=uW1v9ItkkU9ojB04tCeW8X3v9Ue41m9qORcdCLnbsxM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aWnBGLKhU6eIGm6VuRvRoJHX6UCzoIs9iP5w+nDUYEUmpmCR6SBZGqsO6Ur/LnzF8zsMN4tf8uYvkJuwW3rR8Pc/VVRJ7pyZqZkM+2YYjfA5+SKpwABQOuuDcowZlRiZg1u/s8S98N4JMfKUoWyGB6Ajo9DjjVNmKq83Lou7+L8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BA6371FB;
	Thu,  8 Feb 2024 04:15:27 -0800 (PST)
Received: from arm.com (RQ4T19M611.cambridge.arm.com [10.1.31.53])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 48F6B3F5A1;
	Thu,  8 Feb 2024 04:14:44 -0800 (PST)
Date: Thu, 8 Feb 2024 12:14:42 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Ard Biesheuvel <ardb@kernel.org>, James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v4 03/10] arm64: cpufeature: Correctly display signed
 override values
Message-ID: <ZcTFsmVpAt9QMxwj@arm.com>
References: <20240122181344.258974-1-maz@kernel.org>
 <20240122181344.258974-4-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240122181344.258974-4-maz@kernel.org>

On Mon, Jan 22, 2024 at 06:13:37PM +0000, Marc Zyngier wrote:
> When a field gets overriden, the kernel indicates the result of
> the override in dmesg. This works well with unsigned fields, but
> results in a pretty ugly output when the field is signed.
> 
> Truncate the field to its width before displaying it.
> 
> Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
> Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
