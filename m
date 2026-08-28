Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 777903DAAC6
	for <kvmarm@lists.linux.dev>; Fri, 28 Aug 2026 11:25:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787916343; cv=none; b=I4GY7frFbmOC4os0PKOsd1uSLRowS9C4EdsEqToyyqDzrwJo6TwnEf4ub+AHacEEEIoo9Ey1GoCfopr96wQ0Qe83vHjOI5edrLAPrWbLA9BeSbE3PtzA08LrYvVIgE9B2ss1/2Mmc7p1REvTixUd5TnfXFIy5j2hUxyCBqrulqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787916343; c=relaxed/simple;
	bh=G4NNTqXUUlllGRV82KBeaeI9jVQh6puFB8yXhyo25yM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XoE2ufPFO1n5lS7RbEPo9G1YyCmgws7KNibSNK7iEg98J3a+jMNFJ2binWiJRMDWoTm1O2Bk4R+8qSvPRW3huNDihRNJ2XX/TMzy/aZl/dGsX7cQRu00Pap0hiCuUwjxCs6aBaHgV68NweriDU0e6nOLg5fWVJj/W4wh2h9/g5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Ing26+oI; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Ing26+oI"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EEE451595;
	Fri, 28 Aug 2026 04:25:36 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0A31D3F7D8;
	Fri, 28 Aug 2026 04:25:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1787916340; bh=G4NNTqXUUlllGRV82KBeaeI9jVQh6puFB8yXhyo25yM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ing26+oIP/P8N81Cz0AeBYfSEGQrRytcer4hynY8HTK1RARADq78fljn8zIaS5qon
	 v74nbv0UxIr4G9H3syTtgYa3CbckU3o7cgpF2bNV73rjyb0KqdNe7U6Us3DwZrbZYi
	 eSYgG5SkYnO/uh5cMN0f89dZRDWjJa8XvCzhTm7Y=
Date: Fri, 28 Aug 2026 12:25:27 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org,
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Mark Brown <broonie@kernel.org>, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH v5] arm64: Don't read GMID_EL1 when MTE is disabled
Message-ID: <apFwJ-HHukM7XLCD@arm.com>
References: <20260827185937.1369099-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260827185937.1369099-1-fuad.tabba@linux.dev>

On Thu, Aug 27, 2026 at 07:59:37PM +0100, Fuad Tabba wrote:
> +bool gmid_el1_accessible(const struct cpuinfo_arm64 *info)
> +{
> +	const struct arm64_ftr_bits *ftrp;
> +	s64 mte, ovr;
> +	u64 ftr_mask;
> +
> +	/* No ID register reflects CONFIG_ARM64_MTE. */
> +	if (!IS_ENABLED(CONFIG_ARM64_MTE))
> +		return false;
> +
> +	for (ftrp = ftr_id_aa64pfr1; ftrp->width; ftrp++) {
> +		if (ftrp->shift == ID_AA64PFR1_EL1_MTE_SHIFT)
> +			break;
> +	}
> +
> +	ftr_mask = arm64_ftr_mask(ftrp);
> +	mte = arm64_ftr_value(ftrp, info->reg_id_aa64pfr1);
> +
> +	/* The boot CPU runs before init_cpu_ftr_reg() strips unsafe overrides. */
> +	if ((id_aa64pfr1_override.mask & ftr_mask) == ftr_mask) {
> +		ovr = arm64_ftr_value(ftrp, id_aa64pfr1_override.val);
> +		mte = arm64_ftr_safe_value(ftrp, ovr, mte);
> +	}

This works. Or we could cut a few lines and just do
cpuid_feature_extract_unsigned_field() for mte and ovr and do a
hard-coded min(mte, ovr) as we now it's lower-safe. I don't have a
strong opinion either way, so for this patch:

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
