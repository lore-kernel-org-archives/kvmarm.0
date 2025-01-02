Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DFBA4C9A;
	Thu,  2 Jan 2025 15:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735833479; cv=none; b=g9LTCkFofBMfdIgrwPjyR7Br2JcAypuwRKa4uUErh/POrR6MMb2OvdTWHF9LZpddS6yCxnh0jbVipNgdqB5DRkO+nNU9SF8jCFam49kX2XYFIZKgBc8ywVejhUCcugxuGYY9cqlPPmB59EYxZnoVsQvxN5Y3ZPH/hcR7dwCH8NY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735833479; c=relaxed/simple;
	bh=B30R5SQxntFNwn4kc/nsN10P1pyoNqOIX5a/V2t/rZ0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dhbYW3QBBlQxDrwE+Pz4wG5uoYVq6AmiifLMtQlx/LY5P8Ob5iwbvXSFT1boe6ld3dcMY49DKcc1orhBlQhWoq0zBYigoaB6cxULxKvxEw8zliC0rrQz9eEiow3Zv/NDaxwDO79W9F9UYACfokiEZETdaQUnvlwmXqMiVTLjCpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M7t9WfYM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M7t9WfYM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2CA1C4CED0;
	Thu,  2 Jan 2025 15:57:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735833479;
	bh=B30R5SQxntFNwn4kc/nsN10P1pyoNqOIX5a/V2t/rZ0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=M7t9WfYMlZoULmdlPdsFuOCpI0tSONfMmQJ/b9UZeW4Mk3wxQC5zLJZKOnKbUF2Kn
	 NzLKkK79r0p4HDWLy+Lkty8tEI8sdHTIdqflBNkPx8pQENmcKFSFtcqQKSfvvv+Ibu
	 /eOijlyST9sR2bSdgIZDsGuvUsIB8OnM4E4MuHEjxo6JTBf7V3V2o1CasME3NQUGGS
	 pHxeN4F/rmwkowJdE1jRvX5MZAEZWovLTVrMoetBAt8CqmFZMhsbnfmzSj+VYeVZtK
	 kiYFX0hDJ1FAyFYXufvzl1IXC0qR/uq5CoHKBS9y2+15yoNWg9ckkIlx0UfN5Dx9Yj
	 mwpnzUdprdKAQ==
Date: Thu, 2 Jan 2025 09:57:56 -0600
From: Rob Herring <robh@kernel.org>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-arm-kernel@lists.infradead.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Jonathan Corbet <corbet@lwn.net>,
	Eric Auger <eric.auger@redhat.com>, kvmarm@lists.linux.dev,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/7] arm64/boot: Enable EL2 requirements for FEAT_PMUv3p9
Message-ID: <20250102155756.GA3990035-robh@kernel.org>
References: <20241220072240.1003352-1-anshuman.khandual@arm.com>
 <20241220072240.1003352-8-anshuman.khandual@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241220072240.1003352-8-anshuman.khandual@arm.com>

On Fri, Dec 20, 2024 at 12:52:40PM +0530, Anshuman Khandual wrote:
> FEAT_PMUv3p9 registers such as PMICNTR_EL0, PMICFILTR_EL0, and PMUACR_EL1
> access from EL1 requires appropriate EL2 fine grained trap configuration
> via FEAT_FGT2 based trap control registers HDFGRTR2_EL2 and HDFGWTR2_EL2.
> Otherwise such register accesses will result in traps into EL2.
> 
> Add a new helper __init_el2_fgt2() which initializes FEAT_FGT2 based fine
> grained trap control registers HDFGRTR2_EL2 and HDFGWTR2_EL2 (setting the
> bits nPMICNTR_EL0, nPMICFILTR_EL0 and nPMUACR_EL1) to enable access into
> PMICNTR_EL0, PMICFILTR_EL0, and PMUACR_EL1 registers.
> 
> Also update booting.rst with SCR_EL3.FGTEn2 requirement for all FEAT_FGT2
> based registers to be accessible in EL2.
> 
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Rob Herring <robh@kernel.org>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Oliver Upton <oliver.upton@linux.dev>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-doc@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: kvmarm@lists.linux.dev
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> ---
>  Documentation/arch/arm64/booting.rst | 18 ++++++++++++++++++
>  arch/arm64/include/asm/el2_setup.h   | 25 +++++++++++++++++++++++++
>  2 files changed, 43 insertions(+)

Tested-by: Rob Herring (Arm) <robh@kernel.org>
Reviewed-by: Rob Herring (Arm) <robh@kernel.org>
