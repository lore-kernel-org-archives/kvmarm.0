Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E7364A13A4
	for <kvmarm@lists.linux.dev>; Thu, 23 Jul 2026 12:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784811499; cv=none; b=bQpDeANCtCJe2yKnYaaQa7Fx+8Z1daduaDGRyITKBT3n70W7ao9JpWkQtSqjHWZRrgva2ZdcD/EoOH/+3BVBMO0Nw1D6GLwupzs4lL/hrCTODOch/BQMyMdJKDqf6EytsusWdIdKg+aQVr+RSKAFsK7vBng67cw9wKWj+pij/Ss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784811499; c=relaxed/simple;
	bh=tS3qt0hTqrRoA8Eare5/U/grQvdhUHhuH5FDy08Szas=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KowJ+ac5cfWZxBm6YjnIcs41SXqEO5/VtjFdIjZ5zCXwwVw2d4WO+gmVCZNHyeLnNBz0UQcSZcKrgnObONwywkPSiTUgwQKlaylMPenO2GLMmMZRgz6HbaaF4NjXjnUisPOx21jRhRzqZ/vv1ZvdCeUoPeOsaZERwML3zG6HNz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=JCu95jwu; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="JCu95jwu"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C24621595;
	Thu, 23 Jul 2026 05:58:12 -0700 (PDT)
Received: from J2N7QTR9R3.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BF5C93F59E;
	Thu, 23 Jul 2026 05:58:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784811496; bh=tS3qt0hTqrRoA8Eare5/U/grQvdhUHhuH5FDy08Szas=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JCu95jwuHdwvgEvwvBRQDHTAQhAyscg4Z8nM8CbNlXkEBNN9gvC/tjSRPEY9AmFXQ
	 YlOHo0P+NdKWLi4XGlyaQyNr57TtZJX3FgvYYRvRnaRCalGAv6LHFycsfnB6W1ne1S
	 ROoF87dO/gNP+odtZMxPE972Iu4paqR7pLVdgbOc=
Date: Thu, 23 Jul 2026 13:58:11 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Mark Brown <broonie@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>,
	Oliver Upton <oupton@kernel.org>, Dave Martin <Dave.Martin@arm.com>,
	Fuad Tabba <tabba@google.com>, Ben Horgan <ben.horgan@arm.com>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Eric Auger <eric.auger@redhat.com>
Subject: Re: [PATCH v13 02/32] arm64/fpsimd: Ensure all of ZCR_EL1 is
 initialised from idle
Message-ID: <amIP42yILYNsNk0e@J2N7QTR9R3.cambridge.arm.com>
References: <20260720-kvm-arm64-sme-v13-0-d9abd3ffa245@kernel.org>
 <20260720-kvm-arm64-sme-v13-2-d9abd3ffa245@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260720-kvm-arm64-sme-v13-2-d9abd3ffa245@kernel.org>

On Mon, Jul 20, 2026 at 12:07:29AM +0100, Mark Brown wrote:
> At present when exiting from idle we do not fully reinitialise ZCR_EL1,
> we update ZCR_EL1.LEN with a read/modify/write cycle when loading task
> state but never set any of the other bits to an explicit value.  Since
> currently they are all architecturally RES0 or RAZ/WI this is not a
> practical issue but it may become one if further fields are defined in
> the register so we should explicitly configure the whole register.
>
> Rename the existing sme_suspend_exit() (which handles this for SME) to
> fpsimd_suspend_exit() and add set ZCR_EL1 to 0 there, if needed LEN will
> be updated when loading task state.
>
> Signed-off-by: Mark Brown <broonie@kernel.org>

While this happens to work today, this is a more general architecture
problem, and I think we should cc stable such that kernels will work
reliably on future hardware.

All stable kernels support SVE, so this needs to go as far back as
v5.10.y.

One minor comment below, but with that fixed up (and a CC stable):

Acked-by: Mark Rutland <mark.rutland@arm.com>

> +void fpsimd_suspend_exit(void)
>  {
>  	u64 smcr = 0;
>  
> -	if (!system_supports_sme())
> -		return;
> +	if (system_supports_sve())
> +		write_sysreg_s(0, SYS_ZCR_EL1);
>  
> -	if (system_supports_fa64())
> -		smcr |= SMCR_ELx_FA64;
> -	if (system_supports_sme2())
> -		smcr |= SMCR_ELx_EZT0;
> +	if (system_supports_sme()) {

We should move the 'smcr' variable into this block. That way it's scoped
to where it matters.

> +		if (system_supports_fa64())
> +			smcr |= SMCR_ELx_FA64;
> +		if (system_supports_sme2())
> +			smcr |= SMCR_ELx_EZT0;
>  
> -	write_sysreg_s(smcr, SYS_SMCR_EL1);
> -	write_sysreg_s(0, SYS_SMPRI_EL1);
> +		write_sysreg_s(smcr, SYS_SMCR_EL1);
> +		write_sysreg_s(0, SYS_SMPRI_EL1);
> +	}
>  }

Mark.
