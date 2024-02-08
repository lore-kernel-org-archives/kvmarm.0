Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEDC671B29
	for <kvmarm@lists.linux.dev>; Thu,  8 Feb 2024 12:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707395189; cv=none; b=sX7p025cNlVuuGYlC2KhDXCYNUL9EkcuLJcPV6EgRS+fWisa9VTjCA56BATsN/gQ4Ls5YtA1YEgVeOnzfzueql9BL6MuyyUKy0nc+2IRHVNoOpNmibnYXz0k4zcvXGWiGNFtqu64xJvoF79qJ7ANvP6osxadKM37Kk+Q76IY8yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707395189; c=relaxed/simple;
	bh=VEMdI4miws6OolOBVwacav02EmP7olFAtmoaqw6hKGE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nzwFOYLkcqIZVmV9YeKGnRlNfvcCWvx1dtx5n7aQ9COSNSLspXwvp+9iR/tA+saVjTdHBE8kREZj/aM2PWja+55sSvYjjR90K2dCtAbYKcM9Ca8j3XAvY2Gfilh6E7bdgo0yIMwpGW17bD8bdgo0fVrzDB3lghhpFs2qQcDWaWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6BA3D1FB;
	Thu,  8 Feb 2024 04:27:09 -0800 (PST)
Received: from arm.com (RQ4T19M611.cambridge.arm.com [10.1.31.53])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DAF233F5A1;
	Thu,  8 Feb 2024 04:26:25 -0800 (PST)
Date: Thu, 8 Feb 2024 12:26:23 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Ard Biesheuvel <ardb@kernel.org>, James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v4 06/10] arm64: cpufeature: Detect HCR_EL2.NV1 being RES0
Message-ID: <ZcTIb66ALlbskvTC@arm.com>
References: <20240122181344.258974-1-maz@kernel.org>
 <20240122181344.258974-7-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240122181344.258974-7-maz@kernel.org>

On Mon, Jan 22, 2024 at 06:13:40PM +0000, Marc Zyngier wrote:
> A variant of FEAT_E2H0 not being implemented exists in the form of
> HCR_EL2.E2H being RES1 *and* HCR_EL2.NV1 being RES0 (indicating that
> only VHE is supported on the host and nested guests).
> 
> Add the necessary infrastructure for this new CPU capability.
> 
> Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
