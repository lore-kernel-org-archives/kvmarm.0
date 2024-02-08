Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80BD271B54
	for <kvmarm@lists.linux.dev>; Thu,  8 Feb 2024 12:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707395125; cv=none; b=CzHV8pbRUd1S0A3Xb2smpLIHDWf7mhXvNDAcDDHq/rghY/QrF87XzSDSpN2WhDJDO6DLrwAOHe3zs3J4aXrHCDkKUflv8H6FV9T7n2olqX5bzi6zdKtg0clDSvNViHzg6C2TEMu94vsPt8Vu/0r0nH5NTYDaMUkhMujKCw2z34I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707395125; c=relaxed/simple;
	bh=cEtkvtAoche8ioT1ZNm8FcbdGASfEllSTfD9bxX3ldg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Bd9+1b4V/trSW7g9tiqO0R5p5rP6ixMMjzCqtB3iz05v5vFVLFon8jbhcaJwDRL05xBxfUh82oI9Q7NMpAfBU5mjXDjD1k4NMvcGda5BlqONvfRV3ao5oZ32vJFtwB9/r4pwgEK2BK1JEgYHikoby0G1mIDQgclQ+tMPwDXYuBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0C0FB1FB;
	Thu,  8 Feb 2024 04:26:05 -0800 (PST)
Received: from arm.com (RQ4T19M611.cambridge.arm.com [10.1.31.53])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8A9AC3F5A1;
	Thu,  8 Feb 2024 04:25:21 -0800 (PST)
Date: Thu, 8 Feb 2024 12:25:19 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Ard Biesheuvel <ardb@kernel.org>, James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v4 04/10] arm64: sysreg: Add layout for ID_AA64MMFR4_EL1
Message-ID: <ZcTILxL_jeGvP0Z0@arm.com>
References: <20240122181344.258974-1-maz@kernel.org>
 <20240122181344.258974-5-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240122181344.258974-5-maz@kernel.org>

On Mon, Jan 22, 2024 at 06:13:38PM +0000, Marc Zyngier wrote:
> ARMv9.5 has infroduced ID_AA64MMFR4_EL1 with a bunch of new features.
> Add the corresponding layout.
> 
> This is extracted from the public ARM SysReg_xml_A_profile-2023-09
> delivery, timestamped d55f5af8e09052abe92a02adf820deea2eaed717.
> 
> Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
