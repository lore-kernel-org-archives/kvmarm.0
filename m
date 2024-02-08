Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83FF37318B
	for <kvmarm@lists.linux.dev>; Thu,  8 Feb 2024 12:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707394441; cv=none; b=R55w/cpnbR67NH/qPIzQLZ1SyZxqerZWJPX/epzwr+7XTs9Lh1KVfn2DELdfzA+O6U/gGhzNGmgZkR0EHg/X3EmWPmn2Xy2M43t0aJ8YO+BhvWFYcYzGz2Zz4EI4MZG+P9N4jum8TATZPwLvwl6zJL8PwQgu0bJ5eJYbRqJC1hI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707394441; c=relaxed/simple;
	bh=Vz0H0D/Z6mXxSHfpHKMpKgiT1VwEry53CobEOHay5Rw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hEh6PBVxTwtSPU4TlqZ/+u2OSBkNODMvCOaSup2mr6ZqPwNV/Nxn3976G6oB6fTSXycKQ3HC4TvWWrn+76HayVYerbpqTonTKwBC2tuSucn2Kpj+lNxKtdKlk7oIAso3QAXpaws1cU+VgncJjnZP1GYE1pZRn6bjRt1kyUN2x0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 168791FB;
	Thu,  8 Feb 2024 04:14:40 -0800 (PST)
Received: from arm.com (RQ4T19M611.cambridge.arm.com [10.1.31.53])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8CD193F5A1;
	Thu,  8 Feb 2024 04:13:56 -0800 (PST)
Date: Thu, 8 Feb 2024 12:13:54 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Ard Biesheuvel <ardb@kernel.org>, James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v4 02/10] arm64: cpufeatures: Correctly handle signed
 values
Message-ID: <ZcTFgpm8HlmP2XUK@arm.com>
References: <20240122181344.258974-1-maz@kernel.org>
 <20240122181344.258974-3-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240122181344.258974-3-maz@kernel.org>

On Mon, Jan 22, 2024 at 06:13:36PM +0000, Marc Zyngier wrote:
> Although we've had signed values for some features such as PMUv3
> and FP, the code that handles the comparaison with some limit
> has a couple of annoying issues:
> 
> - the min_field_value is always unsigned, meaning that we cannot
>   easily compare it with a negative value
> 
> - it is not possible to have a range of values, let alone a range
>   of negative values
> 
> Fix this by:
> 
> - adding an upper limit to the comparison, defaulting to all bits
>   being set to the maximum positive value
> 
> - ensuring that the signess of the min and max values are taken into
>   account
> 
> A ARM64_CPUID_FIELDS_NEG() macro is provided for signed features, but
> nothing is using it yet.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
