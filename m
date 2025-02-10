Received: from out-187.mta0.migadu.com (out-187.mta0.migadu.com [91.218.175.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4EB21F4627
	for <kvmarm@lists.linux.dev>; Mon, 10 Feb 2025 18:17:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739211427; cv=none; b=jE9tFT98AGsxycOH0Ov9K7GCrP+voNdthvQFGnAX7FRmazdiEiXLN4stS4gAnnexN8KAKe/V9hNMwOY9PD5YaonLRUlC2CCLhZv9/eBbUWbfSUI21RMXbSm4tYJzOKhIDZ0lYJlh5BBFxlPGFck764mQeTBgvF/50czM6KpHG7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739211427; c=relaxed/simple;
	bh=1i5xK3PtNVk7aMFsQPExY/UXlMe/f3hYdRXcGrB9HuU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P/qK+4lfoq1ugk+7jz+R2ot/twpjTTFBb44BJ2aIe4NV9oHGnlMXZ2qAB8aBPho2af8j3BuR5AZfcZNeQ35N/yWZSxOO2pwcnMAdZlu/1xDKnnsrmpPYyaLXQoXT9iKajUisJS3UKdl4FP+BFwxnBfVm/ZIXOc4TN8mM/snfIe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=QeYON7ld; arc=none smtp.client-ip=91.218.175.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="QeYON7ld"
Date: Mon, 10 Feb 2025 10:16:57 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1739211423;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fRjmSWXkgABW1qpkTdJ7gnXQ6hI9dHeWH9NqwvBbzK8=;
	b=QeYON7ldbVu3bB34nzRPNtGJme9Q+O9wy5BEvSFH8exR89BE0xNfv9libOoqRXSWSWElJ8
	zBLYH+2vNHb8QCHhZDGgOsz6WiBWZmc9ysxca47L/Eoyu7Mi1hWi3S4kzQG8sHYoWKMaRx
	QeGUNq5yoEEPhLj8QMTucEbNpnuresM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Sebastian Ott <sebott@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Cornelia Huck <cohuck@redhat.com>,
	Eric Auger <eric.auger@redhat.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] KVM: arm64: writable MIDR/REVIDR
Message-ID: <Z6pCmYo3AdjDG9Di@linux.dev>
References: <20250210154953.27002-1-sebott@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250210154953.27002-1-sebott@redhat.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Feb 10, 2025 at 04:49:49PM +0100, Sebastian Ott wrote:
> Based on prior discussion [1] this series allows VMMs to change
> MIDR/REVIDR to enable migration between machines that differ in
> these registers. Since these are used for errata handling the
> errata management series [2] is a prerequisite for this one.
> 
> Note that guest access to MIDR_EL1 is not trapped.
> 
> [1] https://lore.kernel.org/kvmarm/20250124151732.6072-1-shameerali.kolothum.thodi@huawei.com/T/#mb855bc51714095a164a7b26bb8bead1606e4b753
> [2] https://lore.kernel.org/kvmarm/20250205132222.55816-1-shameerali.kolothum.thodi@huawei.com/T/
> 
> Sebastian Ott (4):
>   KVM: arm64: Allow userspace to change MIDR_EL1
>   KVM: arm64: Allow userspace to change REVIDR_EL1
>   KVM: arm64: Allow userspace to change AIDR_EL1
>   KVM: arm64: trap guest access for REVIDR_EL1 and AIDR_EL1

Please reorganize the series such that guest accesses to REVIDR/AIDR are
trapped as soon as we allow userspace to change them. Also, can you
extend the set_id_regs selftest to assert that the guest sees the
correct value for these registers?

-- 
Thanks,
Oliver
