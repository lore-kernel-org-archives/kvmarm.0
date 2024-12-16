Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47BE1203D74
	for <kvmarm@lists.linux.dev>; Mon, 16 Dec 2024 10:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734346718; cv=none; b=BO0lxSiozP6lqc4pqJ97r5EJGPjEZtGwVB6Y1kTiLOxwKo6oc5q/7YT04lGjls60HaL1Sp+BlMKsTcSnYuziv0yiAw2CJEbQJqSTNNvjBcOSxDsbkosVKA//13miDjtG92xNf/M1o1t7StQQgCxqGEpu4EdSllz/0LN5Z87+MGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734346718; c=relaxed/simple;
	bh=JOo6wPxJ6ysz80wcr9pNjtL4GUZrRp3iY0iQwT4lypE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VnpX6R2Q7r1Qs7iN1Vg/y9vIl10x3hE7a7zeXsDlekbRHD2Hip1DJZnyuLsjrgcYUsNKAm0jkbeU3utDfnARok7DWkUDQUdUYH+OiR5cTfPPYL1WBerGkEHhKHUvd7wQOYws5TPkwFLo8Ev6+ZFaqKHs1CzmO5zwRILsZwY/MeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BD235113E;
	Mon, 16 Dec 2024 02:59:03 -0800 (PST)
Received: from J2N7QTR9R3 (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 901093F720;
	Mon, 16 Dec 2024 02:58:33 -0800 (PST)
Date: Mon, 16 Dec 2024 10:58:29 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Brown <broonie@kernel.org>,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH V3 7/7] arm64/hw_breakpoint: Enable FEAT_Debugv8p9
Message-ID: <Z2AH1SN5CipWkkE4@J2N7QTR9R3>
References: <20241216040831.2448257-1-anshuman.khandual@arm.com>
 <20241216040831.2448257-8-anshuman.khandual@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241216040831.2448257-8-anshuman.khandual@arm.com>

On Mon, Dec 16, 2024 at 09:38:31AM +0530, Anshuman Khandual wrote:
> Currently there can be maximum 16 breakpoints, and 16 watchpoints available
> on a given platform - as detected from ID_AA64DFR0_EL1.[BRPs|WRPs] register
> fields. But these breakpoint, and watchpoints can be extended further up to
> 64 via a new arch feature FEAT_Debugv8p9.
> 
> This first enables banked access for the breakpoint and watchpoint register
> set via MDSELR_EL1, extended exceptions via MDSCR_EL1.EMBWE and determining
> available breakpoints and watchpoints in the platform from ID_AA64DFR1_EL1,
> when FEAT_Debugv8p9 is enabled.

[...]

> +static u64 read_wb_reg(int reg, int n)
> +{
> +	unsigned long flags;
> +	u64 val;
> +
> +	if (!is_debug_v8p9_enabled())
> +		return __read_wb_reg(reg, n);
> +
> +	/*
> +	 * Bank selection in MDSELR_EL1, followed by an indexed read from
> +	 * breakpoint (or watchpoint) registers cannot be interrupted, as
> +	 * that might cause misread from the wrong targets instead. Hence
> +	 * this requires mutual exclusion.
> +	 */
> +	local_irq_save(flags);
> +	write_sysreg_s(SYS_FIELD_PREP(MDSELR_EL1, BANK, n / MAX_PER_BANK), SYS_MDSELR_EL1);
> +	isb();
> +	val = __read_wb_reg(reg, n % MAX_PER_BANK);
> +	local_irq_restore(flags);
> +	return val;
> +}
>  NOKPROBE_SYMBOL(read_wb_reg);

I don't believe that disabling interrupts here is sufficient. On the
last version I asked about the case of racing with a watchpoint handler:

| For example, what prevents watchpoint_handler() from firing in the
| middle of arch_install_hw_breakpoint() or
| arch_uninstall_hw_breakpoint()?

... and disabling interrupts cannot prevent that, because
local_irq_{save,restore}() do not affect the behaviour of watchpoints or
breakpoints.

Please can you try to answer the questions I asked last time, i.e.

| What prevents a race with an exception handler? e.g. 
| 
| * Does the structure of the code prevent that somehow?
| 
| * What context(s) does this code execute in?
|   - Are debug exceptions always masked?
|   - Do we disable breakpoints/watchpoints around (some) manipulation of
|     the relevant registers?

... and the question form the earlier comment, i.e.

| Is the existing code correct?

I suspect that the existing code might not have the necessary mutual
exclusion in all cases, but it's difficult to trigger an issue by
accident. Is there any way a handler could race with some other
manipulation of watchpoints/breakpoints such that some data structure
gets corrupted, or such that the kernel deadlocks?

Mark.
