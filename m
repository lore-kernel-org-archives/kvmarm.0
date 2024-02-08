Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE69B71B5E
	for <kvmarm@lists.linux.dev>; Thu,  8 Feb 2024 12:25:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707395147; cv=none; b=KKbraWXpiar9iMN3OqzxuJimaU6Nk1ySoqMMwNRDSE5JXBbpJbWLeUGS3bJa39ZMwVx98qsEmsDNFiU9kWzMq34jvGjBkcrQQuu0WTI8AKBei+ddj8uFfV6oROAugR0kYqBiF4gQGan1b34FHcaZLw2r9B34xDvBhFe60fqDPOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707395147; c=relaxed/simple;
	bh=NA7uS9+rfhc8lYP9OF9Bzf5US48UGMEEr+Nw7bnQBeI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k9FtDu9n2gEquO46+YughTMLiylcENVgxUjGaPG1b2Lx1KIEjD1++HG0mnJFPA8YK6XuYoMmu6Bwu7cin/1TcEs8vTIYD8IUy0F+roP6pkook8Mhd6AQNiaUuEAnB/6IM8naW4D3fk1r/NKlYDs76C44u7m5iWzzyg471COZnV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0F57B1FB;
	Thu,  8 Feb 2024 04:26:27 -0800 (PST)
Received: from arm.com (RQ4T19M611.cambridge.arm.com [10.1.31.53])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 894D83F5A1;
	Thu,  8 Feb 2024 04:25:43 -0800 (PST)
Date: Thu, 8 Feb 2024 12:25:41 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Ard Biesheuvel <ardb@kernel.org>, James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v4 05/10] arm64: cpufeature: Add ID_AA64MMFR4_EL1 handling
Message-ID: <ZcTIRQ4s7kiqosgw@arm.com>
References: <20240122181344.258974-1-maz@kernel.org>
 <20240122181344.258974-6-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240122181344.258974-6-maz@kernel.org>

On Mon, Jan 22, 2024 at 06:13:39PM +0000, Marc Zyngier wrote:
> Add ID_AA64MMFR4_EL1 to the list of idregs the kernel knows about,
> and describe the E2H0 field.
> 
> Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
> Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
