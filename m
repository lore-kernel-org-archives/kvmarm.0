Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B3441ABC25;
	Thu,  4 Jul 2024 14:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720102741; cv=none; b=WX+bnHIuf5EkFdvyhvJdfyr8UUydcNMzBvs1UnHsxixoOoHzMZKGN8Wbb3GierGgZ/y1brpy2NRhm3Tu0b7gdapqWfKDhj4NJIMiHgenSRq2q2djySNOV6z52Cjxl1hQnv/pAeQj30ZfG9cVfo7uREjXMqC3LD5VY8qPacp/NFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720102741; c=relaxed/simple;
	bh=ye510cXC3aVwECKsVGygh7Jks+sL52CExzDAGCpTe58=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Fk9yyrHEhVtf3MQbgky2SvKW1kCv3bc+b4K9oEZEOykTJEvBoMKcMqNe1hEvNANSkFBZ6kmChDeKSrq/uCiB360lxB++aFSIFCCNFS9LEUIl5hs/E+pi+iyHsWKoFJWP2qhpyZvMgDmgTnEx5S3AQe4870aNcAnuoSdd2C5z5BU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8585C3277B;
	Thu,  4 Jul 2024 14:18:58 +0000 (UTC)
Date: Thu, 4 Jul 2024 15:18:56 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Mark Brown <broonie@kernel.org>
Cc: Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Fuad Tabba <tabba@google.com>, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH v2 2/4] arm64/fpsimd: Discover maximum vector length
 implemented by any CPU
Message-ID: <ZoavUGcYLULHpVfg@arm.com>
References: <20240606-kvm-arm64-fix-pkvm-sve-vl-v2-0-c88f4eb4b14b@kernel.org>
 <20240606-kvm-arm64-fix-pkvm-sve-vl-v2-2-c88f4eb4b14b@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240606-kvm-arm64-fix-pkvm-sve-vl-v2-2-c88f4eb4b14b@kernel.org>

On Thu, Jun 06, 2024 at 04:21:44PM +0100, Mark Brown wrote:
> When discovering the vector lengths for SVE and SME we do not currently
> record the maximum VL supported on any individual CPU.  This is expected
> to be the same for all CPUs but the architecture allows asymmetry, if we
> do encounter an asymmetric system then some CPUs may support VLs higher
> than the maximum Linux will use.  Since the pKVM hypervisor needs to
> support saving and restoring anything the host can physically set it
> needs to know the maximum value any CPU could have, add support for
> enumerating it and validation for late CPUs.
> 
> Signed-off-by: Mark Brown <broonie@kernel.org>

Acked-by: Catalin Marinas <catalin.marinas@arm.com>

I guess the %lu suggested by Fuad can be done when applying the patch.
