Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B12D671B29
	for <kvmarm@lists.linux.dev>; Thu,  8 Feb 2024 12:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707395278; cv=none; b=Ta0tQu/DW08zDdnN1dmWJzEHrAbpTZLiPa6pbto4m/Zn3LQzYhA7+27cl/aafcBNFxT9QID/KoaHE6dJVr0zwMWkRRsDBOHQPwDo+25CVznyeTaBuj6W1Lsne8t+IuozFpK0/yHHu9hF6JFUh6Q9dqCjnwvhwON0fhABdv07mEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707395278; c=relaxed/simple;
	bh=sqgTxQwT7uBNKjkQ+Be+eb7hU4Une5Qw+/4EGt6oJ9A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jEXumcH0oe7zRDJSc/jrNWPxNpoLjINhkG+o24pQqFzSYmdHPupVuc21hSnHnpvv2AnOAsXG3JSUQGLJYlg0zVzecttu9ntfHwtokx72FiQ2jPvl8ysdF124+z+6p7jgyl0Qniy5QLxeMD6kHcBkVIcAL6T2JE73Ixu8GfPcNe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5F1B61FB;
	Thu,  8 Feb 2024 04:28:38 -0800 (PST)
Received: from arm.com (RQ4T19M611.cambridge.arm.com [10.1.31.53])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DD1C83F5A1;
	Thu,  8 Feb 2024 04:27:54 -0800 (PST)
Date: Thu, 8 Feb 2024 12:27:52 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Ard Biesheuvel <ardb@kernel.org>, James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v4 07/10] arm64: Treat HCR_EL2.E2H as RES1 when
 ID_AA64MMFR4_EL1.E2H0 is negative
Message-ID: <ZcTIyM6W4_2RnOkt@arm.com>
References: <20240122181344.258974-1-maz@kernel.org>
 <20240122181344.258974-8-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240122181344.258974-8-maz@kernel.org>

On Mon, Jan 22, 2024 at 06:13:41PM +0000, Marc Zyngier wrote:
> For CPUs that have ID_AA64MMFR4_EL1.E2H0 as negative, it is important
> to avoid the boot path that sets HCR_EL2.E2H=0. Fortunately, we
> already have this path to cope with fruity CPUs.
> 
> Tweak init_el2 to look at ID_AA64MMFR4_EL1.E2H0 first.
> 
> Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
