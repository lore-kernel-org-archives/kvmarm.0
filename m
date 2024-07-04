Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81E6A1AED39;
	Thu,  4 Jul 2024 14:20:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720102859; cv=none; b=uOdgF4pKfSQAbR3PD9vcPIO4j6P6c9PcJCriDEMlQfnDjzRDidSnnJ13Dbc5KvMfvC4waOJ7k5oYMBQOm3kb1dediwtrbcTVerJaImWGT+HKbQOStfHXwqR6Z53hA66cClgbgqiLI2bFVwb57ceZopc549bf5rOe1kVyPv5wSKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720102859; c=relaxed/simple;
	bh=X1wVDYSFUcylugE6Z6QPG//9bPbOUIaqnUCUF4kAxS0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rWrFqP4LwSpSCWFwn4QBMfahtv4ENF3CLr5PdoD6CqsLqkYoKcZkqVY2UjAm0RCDQ7bfeBDTXcaazXJOsgDnZi+qPd9yScyjd/J8bhAQaEOIyQ6M9oIfcI72rT6EO0hE+NrqmnOwKIhmudgteXBEKlCcTwjRdyk12x4NJFTxQ5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47ED2C3277B;
	Thu,  4 Jul 2024 14:20:57 +0000 (UTC)
Date: Thu, 4 Jul 2024 15:20:55 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Mark Brown <broonie@kernel.org>
Cc: Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Fuad Tabba <tabba@google.com>, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH v2 0/4] KVM: arm64: Fix underallocation of storage for
 SVE state
Message-ID: <Zoavx64l_slLUvfR@arm.com>
References: <20240606-kvm-arm64-fix-pkvm-sve-vl-v2-0-c88f4eb4b14b@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240606-kvm-arm64-fix-pkvm-sve-vl-v2-0-c88f4eb4b14b@kernel.org>

On Thu, Jun 06, 2024 at 04:21:42PM +0100, Mark Brown wrote:
> As observed during review the pKVM support for saving host SVE state is
> broken if an asymmetric system has VLs larger than the maximum shared
> VL, fix this by discovering then using the maximum VL for allocations
> and using RDVL during the save/restore process.
> 
> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---
> Changes in v2:
> - Downgrade check for a late CPU increasing maximum VL to a warning only
>   but do it unconditionally since pKVM prevents late CPUs anyway.
> - Commit log tweaks.
> - Link to v1: https://lore.kernel.org/r/20240605-kvm-arm64-fix-pkvm-sve-vl-v1-0-680d6b43b4c1@kernel.org
> 
> ---
> Mark Brown (4):
>       arm64/fpsimd: Introduce __bit_to_vl() helper
>       arm64/fpsimd: Discover maximum vector length implemented by any CPU
>       KVM: arm64: Fix FFR offset calculation for pKVM host state save and restore
>       KVM: arm64: Avoid underallocating storage for host SVE state

Since the patches address a KVM issue, I think it should go via
Oliver/Marc's tree. But happy to queue it via the arm64 tree if people
think otherwise.

Thanks.

-- 
Catalin
