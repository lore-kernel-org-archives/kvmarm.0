Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DE2B1D5AB7
	for <kvmarm@lists.linux.dev>; Thu, 27 Feb 2025 16:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740675530; cv=none; b=I67z3H6nFx0zwA3aspBbhT0+XO94WsuKFqHV5Nh16wC5jUVb8Qc19zBcZrsFFFtnlWSjo8HotYsNLdA09HkA7OCQhABmhd4opH6XKs8Fw4tv2DbqrvAyUIt3XM25vvqGqWDaYv7DlWK/WQL+ncZ7aidB0CmV3Hj/GN136TDLpNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740675530; c=relaxed/simple;
	bh=hDbgNEOoh8cOO6QZfvFtz/A3WlCByOfqSVxiyA1QLB8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eLS8uxS7kvCcH4R28d9mbwzPGqFoF2sM2Y7AvhhDyB79EMYpFvTnE1yv237IZeyNbP30jQ4Loc6GzI/HJakTKryF8FXaSMlUQk9ZTX/SAzW5qbY6R5GCTC8lLrtF9U1OadeE/m7gVmzkA3DHQmXIArL1YpZD8C51VvDsuUzvhRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1EDB9153B;
	Thu, 27 Feb 2025 08:59:04 -0800 (PST)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 579613F5A1;
	Thu, 27 Feb 2025 08:58:47 -0800 (PST)
Date: Thu, 27 Feb 2025 16:58:36 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Joey Gouly <joey.gouly@arm.com>
Cc: kvm@vger.kernel.org, drjones@redhat.com, kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [kvm-unit-tests PATCH v1 5/7] arm64: selftest: update test for
 running at EL2
Message-ID: <Z8CZvKW1fBBt6lZN@raptor>
References: <20250220141354.2565567-1-joey.gouly@arm.com>
 <20250220141354.2565567-6-joey.gouly@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250220141354.2565567-6-joey.gouly@arm.com>

Hi Joey,

On Thu, Feb 20, 2025 at 02:13:52PM +0000, Joey Gouly wrote:
> Remove some hard-coded assumptions that this test is running at EL1.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>

We discussed this privately, and this patch was split from from the bigger
patch that added support to all tests to run at EL2 [1]. Joey kept my
Signed-off-by, but accidently dropped the authorship.

[1] https://lore.kernel.org/all/1577972806-16184-3-git-send-email-alexandru.elisei@arm.com/

> Signed-off-by: Joey Gouly <joey.gouly@arm.com>
> ---
>  arm/selftest.c | 18 +++++++++++++-----
>  1 file changed, 13 insertions(+), 5 deletions(-)
> 
> diff --git a/arm/selftest.c b/arm/selftest.c
> index 1553ed8e..eccdc3d4 100644
> --- a/arm/selftest.c
> +++ b/arm/selftest.c
> @@ -232,6 +232,7 @@ static void user_psci_system_off(struct pt_regs *regs)
>  	__user_psci_system_off();
>  }
>  #elif defined(__aarch64__)
> +static unsigned long expected_level;
>  
>  /*
>   * Capture the current register state and execute an instruction
> @@ -276,8 +277,7 @@ static bool check_regs(struct pt_regs *regs)
>  {
>  	unsigned i;
>  
> -	/* exception handlers should always run in EL1 */
> -	if (current_level() != CurrentEL_EL1)
> +	if (current_level() != expected_level)
>  		return false;
>  
>  	for (i = 0; i < ARRAY_SIZE(regs->regs); ++i) {
> @@ -301,7 +301,11 @@ static enum vector check_vector_prep(void)
>  		return EL0_SYNC_64;
>  
>  	asm volatile("mrs %0, daif" : "=r" (daif) ::);
> -	expected_regs.pstate = daif | PSR_MODE_EL1h;
> +        expected_regs.pstate = daif;
> +        if (current_level() == CurrentEL_EL1)
> +                expected_regs.pstate |= PSR_MODE_EL1h;
> +        else
> +                expected_regs.pstate |= PSR_MODE_EL2h;
>  	return EL1H_SYNC;
>  }
>  
> @@ -317,8 +321,8 @@ static bool check_und(void)
>  
>  	install_exception_handler(v, ESR_EL1_EC_UNKNOWN, unknown_handler);
>  
> -	/* try to read an el2 sysreg from el0/1 */
> -	test_exception("", "mrs x0, sctlr_el2", "", "x0");
> +	/* try to read an el3 sysreg from el0/1/2 */
> +	test_exception("", "mrs x0, sctlr_el3", "", "x0");
>  
>  	install_exception_handler(v, ESR_EL1_EC_UNKNOWN, NULL);
>  
> @@ -429,6 +433,10 @@ int main(int argc, char **argv)
>  	if (argc < 2)
>  		report_abort("no test specified");
>  
> +#if defined(__aarch64__)
> +        expected_level = current_level();
> +#endif
> +
>  	report_prefix_push(argv[1]);
>  
>  	if (strcmp(argv[1], "setup") == 0) {

Looks good to me:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,
Alex
