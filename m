Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0F33307AE6
	for <kvmarm@lists.linux.dev>; Fri, 29 Aug 2025 10:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756462498; cv=none; b=qy3rABDdCcJmF/i3/4/Hz2J0VRwIr6tt9YIOLc4u6ka+Nwswo8RqYpc7PK3lz/56r/MdAfWLlETC8V7+YfZT0UR/ru+IvRO2UAlgjtNnbbjCzUgIjHuVjlvCQ5ksdCxD1ew76hbUvIU7Av1frAiPIS0UPf7IRyFv26mJjLmEUjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756462498; c=relaxed/simple;
	bh=0m0S64iSq+Rt93fI0lOrhxwuBHuzeGodZfb8z/1a7vU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=poBLinInpC8bcHNaD2bJ8HNB+vUMpwpARJMa6zAsYxgQdb1dDKSGoSRvX+8Nfe0DwQmEVxdMJMxz5zlqdh34SAa1U9BNZqcLjddYUKZXND2vMTY9EyuKM9qkyXwsXI3xbHlBKvnITXByHFxLoxCez8o8mbR5md6tgGzyh+BQD0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 847181758;
	Fri, 29 Aug 2025 03:14:47 -0700 (PDT)
Received: from J2N7QTR9R3 (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9DEDD3F694;
	Fri, 29 Aug 2025 03:14:52 -0700 (PDT)
Date: Fri, 29 Aug 2025 11:14:49 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Fuad Tabba <tabba@google.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	maz@kernel.org, oliver.upton@linux.dev, will@kernel.org,
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, vdonnefort@google.com, qperret@google.com,
	sebastianene@google.com, keirf@google.com, smostafa@google.com
Subject: Re: [PATCH v3 3/3] arm64: sysreg: Add validation checks to sysreg
 header generation script
Message-ID: <aLF9mSCs1B2gk8BU@J2N7QTR9R3>
References: <20250829095143.123476-1-tabba@google.com>
 <20250829095143.123476-4-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250829095143.123476-4-tabba@google.com>

On Fri, Aug 29, 2025 at 10:51:43AM +0100, Fuad Tabba wrote:
> The gen_sysreg.awk script processes the system register specification in
> the sysreg text file to generate C macro definitions. The current script
> will silently accept certain errors in the specification file, leading
> to incorrect header generation.
> 
> For example, a Sysreg or SysregFields can be accidentally duplicated,
> causing its macros to be emitted twice. An Enum can contain duplicate
> values for different items, which is architecturally incorrect.
> 
> Add checks to catch these errors at build time. The script now tracks
> all seen Sysreg and SysregFields definitions and checks for duplicates.
> It also tracks values within each Enum block to ensure entries are
> unique.
> 
> Acked-by: Marc Zyngier <maz@kernel.org>
> Signed-off-by: Fuad Tabba <tabba@google.com>

I wonder if it would make sense to treat SysregFields and Sysregs as one
group (both using defined_regs), so that we can catch:

	Sysreg	FOO_EL1	...
		...
	EndSysreg

	SysregFields	FOO_EL1
		...
	EndSysregFields

I have no strong feelings either way, so for this as-is OR for using
`defined_regs` for both:

Acked-by: Mark Rutland <mark.rutland@arm.com>

Mark.

> ---
>  arch/arm64/tools/gen-sysreg.awk | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
> 
> diff --git a/arch/arm64/tools/gen-sysreg.awk b/arch/arm64/tools/gen-sysreg.awk
> index f2a1732cb1f6..bbbb812603e8 100755
> --- a/arch/arm64/tools/gen-sysreg.awk
> +++ b/arch/arm64/tools/gen-sysreg.awk
> @@ -122,6 +122,10 @@ $1 == "SysregFields" && block_current() == "Root" {
>  	res1 = "UL(0)"
>  	unkn = "UL(0)"
>  
> +	if (reg in defined_fields)
> +		fatal("Duplicate SysregFields definition for " reg)
> +	defined_fields[reg] = 1
> +
>  	next_bit = 63
>  
>  	next
> @@ -162,6 +166,10 @@ $1 == "Sysreg" && block_current() == "Root" {
>  	res1 = "UL(0)"
>  	unkn = "UL(0)"
>  
> +	if (reg in defined_regs)
> +		fatal("Duplicate Sysreg definition for " reg)
> +	defined_regs[reg] = 1
> +
>  	define("REG_" reg, "S" op0 "_" op1 "_C" crn "_C" crm "_" op2)
>  	define("SYS_" reg, "sys_reg(" op0 ", " op1 ", " crn ", " crm ", " op2 ")")
>  
> @@ -284,6 +292,8 @@ $1 == "SignedEnum" && (block_current() == "Sysreg" || block_current() == "Sysreg
>  	define_field(reg, field, msb, lsb)
>  	define_field_sign(reg, field, "true")
>  
> +	delete seen_enum_vals
> +
>  	next
>  }
>  
> @@ -297,6 +307,8 @@ $1 == "UnsignedEnum" && (block_current() == "Sysreg" || block_current() == "Sysr
>  	define_field(reg, field, msb, lsb)
>  	define_field_sign(reg, field, "false")
>  
> +	delete seen_enum_vals
> +
>  	next
>  }
>  
> @@ -309,6 +321,8 @@ $1 == "Enum" && (block_current() == "Sysreg" || block_current() == "SysregFields
>  
>  	define_field(reg, field, msb, lsb)
>  
> +	delete seen_enum_vals
> +
>  	next
>  }
>  
> @@ -320,6 +334,8 @@ $1 == "EndEnum" && block_current() == "Enum" {
>  	lsb = null
>  	print ""
>  
> +	delete seen_enum_vals
> +
>  	block_pop()
>  	next
>  }
> @@ -329,6 +345,10 @@ $1 == "EndEnum" && block_current() == "Enum" {
>  	val = $1
>  	name = $2
>  
> +	if (val in seen_enum_vals)
> +		fatal("Duplicate Enum value " val " for " name)
> +	seen_enum_vals[val] = 1
> +
>  	define(reg "_" field "_" name, "UL(" val ")")
>  	next
>  }
> -- 
> 2.51.0.338.gd7d06c2dae-goog
> 
> 
