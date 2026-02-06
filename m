Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3296394481
	for <kvmarm@lists.linux.dev>; Fri,  6 Feb 2026 18:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770403354; cv=none; b=RA7nA+XjkKuLCnpzG4HTELhk2nkm4hH3VLsfsJ3N/LbnVGYVENpOOdRkfZC8TsmfTjZj4ipgyICifAP0XeOAGNJYWyKnnZgLXhboGnH7LcRsGmtNwiu2dutPWDENCZis9RbrYvxsOVO9W1F8SsZN7BcG6qJ9iokEtZqb1KU72Y0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770403354; c=relaxed/simple;
	bh=Vu/2LLFUBaWX30JMWOHUiF1W1U2pUpnVlCaswsosITM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l+1Y0qN+e3vDfi01HqNPHDT0v/qKd1Nydre1tZUxwlVr8CIdX2Ckl4tnvKYLZvWcY3tyrA727ojdZx0USppjx+tztXvS923yNkHESUQgGhv5lHCGgG222Ns8DQa03VyLeLx9R+0zbUr68MWrjJc3SNPM7XY9LPbeNi/1JazyWkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E90B7339;
	Fri,  6 Feb 2026 10:42:26 -0800 (PST)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 333FE3F632;
	Fri,  6 Feb 2026 10:42:30 -0800 (PST)
Date: Fri, 6 Feb 2026 18:42:19 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org, will@kernel.org, maz@kernel.org,
	broonie@kernel.org, oliver.upton@linux.dev, miko.lenczewski@arm.com,
	kevin.brodsky@arm.com, ardb@kernel.org, suzuki.poulose@arm.com,
	lpieralisi@kernel.org, scott@os.amperecomputing.com,
	joey.gouly@arm.com, yuzenghui@huawei.com, pbonzini@redhat.com,
	shuah@kernel.org, mark.rutland@arm.com, arnd@arndb.de
Subject: Re: [PATCH v12 2/7] arm64: cpufeature: add FEAT_LSUI
Message-ID: <aYY2CyHWtplQ-fuS@arm.com>
References: <20260121190622.2218669-1-yeoreum.yun@arm.com>
 <20260121190622.2218669-3-yeoreum.yun@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260121190622.2218669-3-yeoreum.yun@arm.com>

On Wed, Jan 21, 2026 at 07:06:17PM +0000, Yeoreum Yun wrote:
> +#ifdef CONFIG_ARM64_LSUI
> +static bool has_lsui(const struct arm64_cpu_capabilities *entry, int scope)
> +{
> +	if (!has_cpuid_feature(entry, scope))
> +		return false;
> +
> +	/*
> +	 * A CPU that supports LSUI should also support FEAT_PAN,
> +	 * so that SW_PAN handling is not required.
> +	 */
> +	if (WARN_ON(!__system_matches_cap(ARM64_HAS_PAN)))
> +		return false;
> +
> +	return true;
> +}
> +#endif

I still find this artificial dependency a bit strange. Maybe one doesn't
want any PAN at all (software or hardware) and won't get LSUI either
(it's unlikely but possible).

We have the uaccess_ttbr0_*() calls already for !LSUI, so maybe
structuring the macros in a way that they also take effect with LSUI.
For futex, we could add some new functions like uaccess_enable_futex()
which wouldn't do anything if LSUI is enabled with hw PAN.

-- 
Catalin
