Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A16F51A2395
	for <kvmarm@lists.linux.dev>; Mon,  9 Dec 2024 13:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733752595; cv=none; b=EK8F5T5G5kuoyKA0SajpCOvNPS3iBDgd0aYJRZik7pKzF8YQyVRTT4H5HsiInEKafzoaCtY0PILQ+vb9tzQwrNcQfMISsTzPt8MSRT0qs9SHtgVAI55e9gv7W1Hyvi1ScuZdIkRwpy7BPgO3hqzTeJeT377BFUvnEi0wTkgE7r4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733752595; c=relaxed/simple;
	bh=EpajT4aNY/ORmO1xbU5SzM8tzGdGtBDOaPs7qqa4dYs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XZRrPAd7y/wo7lxz/QC8kp7cHS/aQJPQt3S+wEtblxo0Az2pWi86kQgAQPJtmOsiYeQlbxR3LfVjVawCWzvv4f4zDgVA4wilf2UnZckIDUkr16ueRonFqFJHJN84JCii98+0uNTa8zgETP9OcwQFN5yjJXbpHSbUnQfjIbCB41A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0D1EF113E;
	Mon,  9 Dec 2024 05:56:59 -0800 (PST)
Received: from J2N7QTR9R3.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C7C843F720;
	Mon,  9 Dec 2024 05:56:29 -0800 (PST)
Date: Mon, 9 Dec 2024 13:56:23 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH 1/4] arm64/sysreg: Allow a 'Mapping' descriptor for
 system registers
Message-ID: <Z1b3B2swQ0HrB3bO@J2N7QTR9R3.cambridge.arm.com>
References: <20241207190740.2607673-1-maz@kernel.org>
 <20241207190740.2607673-2-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241207190740.2607673-2-maz@kernel.org>

On Sat, Dec 07, 2024 at 07:07:37PM +0000, Marc Zyngier wrote:
> *EL02 and *_EL12 system registers are actually only accessors for
> EL0 and EL1 registers accessed from EL2 when HCR_EL2.E2H==1. They
> do not have fields of their own.
> 
> To that effect, introduce a 'Mapping' entry, describing which
> system register an _EL12 register maps to.
> 
> Implementation wise, this is handled the same was as Fields,
> which ls only a comment.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/tools/gen-sysreg.awk | 2 +-
>  arch/arm64/tools/sysreg         | 7 +++++++
>  2 files changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/tools/gen-sysreg.awk b/arch/arm64/tools/gen-sysreg.awk
> index d1254a056114e..1a2afc9fdd42e 100755
> --- a/arch/arm64/tools/gen-sysreg.awk
> +++ b/arch/arm64/tools/gen-sysreg.awk
> @@ -206,7 +206,7 @@ END {
>  
>  # Currently this is effectivey a comment, in future we may want to emit
>  # defines for the fields.
> -/^Fields/ && block_current() == "Sysreg" {
> +(/^Fields/ || /^Mapping/) && block_current() == "Sysreg" {
>  	expect_fields(2)
>  
>  	if (next_bit != 63)
> diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
> index b081b54d6d227..b6846c601df6c 100644
> --- a/arch/arm64/tools/sysreg
> +++ b/arch/arm64/tools/sysreg
> @@ -38,6 +38,13 @@
>  # Fields	<fieldsname>
>  # EndSysreg
>  
> +# For register names indicating a cross-EL access (*_EL12, *EL02),
> +# a Mapping entry describes the register it actually accesses:

It might be better to say:

| For VHE aliases (*_EL12, *_EL02) of system registers, a Mapping entry
| describes the register the alias actually accesses:

... and with that'd it's probably best to place this above the
description of SysregFields, so that people see this first and don't
copy the anti-pattern you're trying to remove.

For SysregFields we could clarify the existing wording to:

| Where multiple system regsiters are not VHE aliases but share a common
| layout, a SysregFields block can be used to describe the shared
| layout:

With or without those changes:

Acked-by: Mark Rutland <mark.rutland@arm.com>

Mark.

> +
> +# Sysreg 	<name_EL12>	<op0> 	<op1>	<crn>	<crm>	<op2>
> +# Mapping	<name_EL1>
> +# EndSysreg
> +
>  # For ID registers we adopt a few conventions for translating the
>  # language in the ARM into defines:
>  #
> -- 
> 2.39.2
> 
