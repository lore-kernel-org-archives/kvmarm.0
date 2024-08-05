Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C1E02C684;
	Mon,  5 Aug 2024 13:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722866389; cv=none; b=SR4Ag92GhH/1Da94ExVzt+k+NbYk0jtGCMu0ms8Zs0UPBL6kqxVQOLu1eyzNaL96DwXbTgKUXik6E9GpejXTKYauVhGNw4LJhF1eXQUEVVoCGW8o+YuRMLSt/Wm1P7L3QIIKC735pegN9U1PrPUELUSocrJs3p32XyHDimg27F8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722866389; c=relaxed/simple;
	bh=EyTSiPAafa66YyrGSKzx20HNcdBnILGm5FLS3y8oypQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Gwtk2DHZpRGZiT8o/S6g+IjU3NX4Ef4mYqKhuMStd9wExEdFfHFRhQaomnmkqLJPFqnvv02WdJbrRFQNu51Wi4VArYpQHUEyschzYYQIr5R6YideqoBJipZ1y0hKkw8oSgUBXh19E9eBgmO5Ba+SPEtIjD4eofRZNLJOaEFkKOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=t998Gk2N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t998Gk2N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5FD6C32782;
	Mon,  5 Aug 2024 13:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722866389;
	bh=EyTSiPAafa66YyrGSKzx20HNcdBnILGm5FLS3y8oypQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=t998Gk2NceJq97cj5UOfzb+BNyyqsd+QrO/qJtIHwHaTHZfGFYz/JwMmwj2B5rU2A
	 Miotl4sWUylpJK0ztkIzPC7o/Q48bl7ddXrBkQ/F7AJ3Jrr3cj9oG/XnXmpPOCdcBi
	 7HRg7VC6jB0TgldZ2hCMo0Yxyt8CmLVyeW1y1OJnpxSQa8FKAeLwOZpMEoUgmlXS4s
	 ZEheMORGq04OHCqjK1c5Y0Iu4m2SeQJ+rKfFqf4nGHwxFRjfxE0Y+9eCwzitBGpwKQ
	 4MXZL0C6NLmJn4kxpfadbii3WDDLsMei7h3YitRxXOMp/Iw9/T4BzKVDGQo3qeAP5j
	 iPVhTasgeVZ4w==
Date: Mon, 5 Aug 2024 14:59:42 +0100
From: Will Deacon <will@kernel.org>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, Jonathan Corbet <corbet@lwn.net>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC V2 1/3] arm64/cpufeature: Add field details for
 ID_AA64DFR1_EL1 register
Message-ID: <20240805135942.GA9866@willie-the-truck>
References: <20240620092607.267132-1-anshuman.khandual@arm.com>
 <20240620092607.267132-2-anshuman.khandual@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240620092607.267132-2-anshuman.khandual@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Thu, Jun 20, 2024 at 02:56:05PM +0530, Anshuman Khandual wrote:
> This adds required field details for ID_AA64DFR1_EL1, and also drops dummy
> ftr_raz[] array which is now redundant. These register fields will be used
> to enable increased breakpoint and watchpoint registers via FEAT_Debugv8p9
> later.
> 
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> cc: Mark Brown <broonie@kernel.org>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> ---
>  arch/arm64/kernel/cpufeature.c | 21 ++++++++++++++++-----
>  1 file changed, 16 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index 48e7029f1054..12f0a5181bf2 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -527,6 +527,21 @@ static const struct arm64_ftr_bits ftr_id_aa64dfr0[] = {
>  	ARM64_FTR_END,
>  };
>  
> +static const struct arm64_ftr_bits ftr_id_aa64dfr1[] = {
> +	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64DFR1_EL1_ABL_CMPs_SHIFT, 8, 0),
> +	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64DFR1_EL1_DPFZS_SHIFT, 4, 0),

I only got this far in the patch, but why is this FTR_STRICT +
FTR_LOWER_SAFE? The behaviour of the cycle counter on an SPE management
event sounds like it would be fine to differ between cores, no?

Please go through all the new fields, bearing in mind that most of the
PMU stuff is per-CPU type rather than global.

Will
