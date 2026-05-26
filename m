Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0924E22B594
	for <kvmarm@lists.linux.dev>; Tue, 26 May 2026 12:53:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779800023; cv=none; b=nCIfMHfev3gFp8ekJuPq1swprURQuUBZx6hvUEjDjEAqySoDP9whMyYRC9j631Q1iTTHp14VZPBLe/qVcxR0/K/B5cjleLpE99qlw/y79n/RPxnAUxgQ6mb2Ohy/sy78k7HptQRNb2ZAonmqZ1T3WOc1LY8xuxe9URrkx8zc0Zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779800023; c=relaxed/simple;
	bh=Nf1wOqkOkww7+3uMdBvetcAtVOV8bY2s9Q9u+8JrwuI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XasbLIM/XHOQjRfCNqBV3rMK19W7u6PEPmV8Mj39apT6clsYGkus/wDg1jr57bIVRg8TWh3UHexUTjacrdIwkoMYSsP9TKnxt7zrZUZRpeMnWl0l/wg1m5KmTOC0PHe2pQ7t+ti+XhtQ8eejV9TlfnwxaIEt7kuWhw5mNgS777Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=fCQ816MZ; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="fCQ816MZ"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 42E68169C;
	Tue, 26 May 2026 05:53:36 -0700 (PDT)
Received: from J2N7QTR9R3 (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1662E3F7B4;
	Tue, 26 May 2026 05:53:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779800021; bh=Nf1wOqkOkww7+3uMdBvetcAtVOV8bY2s9Q9u+8JrwuI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fCQ816MZEwvQhB2vTUsb+mbg5kA1F2C4IaZMzycKOrNWwB2LbaaEHzwx/x2vWCMUv
	 0VBGW3JPYfEOqoTkaXTM/zomWyYwmUvQyq5zn7+cv9lh20KnTJTDCT6Ug1Ak3AHEaC
	 FuM2eMKuzV+aIV7cOOPVVtxu7NZDNLeIYPXZ5NS0=
Date: Tue, 26 May 2026 13:53:35 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Mark Brown <broonie@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>,
	Oliver Upton <oupton@kernel.org>, Dave Martin <Dave.Martin@arm.com>,
	Fuad Tabba <tabba@google.com>, Ben Horgan <ben.horgan@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Eric Auger <eric.auger@redhat.com>
Subject: Re: [PATCH v10 03/30] arm64/fpsimd: Decide to save ZT0 and streaming
 mode FFR at bind time
Message-ID: <ahWXz4u7cXtG2PS_@J2N7QTR9R3>
References: <20260306-kvm-arm64-sme-v10-0-43f7683a0fb7@kernel.org>
 <20260306-kvm-arm64-sme-v10-3-43f7683a0fb7@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260306-kvm-arm64-sme-v10-3-43f7683a0fb7@kernel.org>

On Fri, Mar 06, 2026 at 05:00:55PM +0000, Mark Brown wrote:
> Some parts of the SME state are optional, enabled by additional features
> on top of the base FEAT_SME and controlled with enable bits in SMCR_ELx. We
> unconditionally enable these for the host but for KVM we will allow the
> feature set exposed to guests to be restricted by the VMM. These are the
> FFR register (FEAT_SME_FA64) and ZT0 (FEAT_SME2).
> 
> We defer saving of guest floating point state for non-protected guests to
> the host kernel. We also want to avoid having to reconfigure the guest
> floating point state if nothing used the floating point state while running
> the host. If the guest was running with the optional features disabled then
> traps will be enabled for them so the host kernel will need to skip
> accessing that state when saving state for the guest.
> 
> Support this by moving the decision about saving this state to the point
> where we bind floating point state to the CPU, adding a new variable to
> the cpu_fp_state which uses the enable bits in SMCR_ELx to flag which
> features are enabled.
> 
> Reviewed-by: Fuad Tabba <tabba@google.com>
> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---
>  arch/arm64/include/asm/fpsimd.h |  1 +
>  arch/arm64/kernel/fpsimd.c      | 10 ++++++++--
>  arch/arm64/kvm/fpsimd.c         |  1 +
>  3 files changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/fpsimd.h b/arch/arm64/include/asm/fpsimd.h
> index 7361b3b4a5f5..e97729aa3b2f 100644
> --- a/arch/arm64/include/asm/fpsimd.h
> +++ b/arch/arm64/include/asm/fpsimd.h
> @@ -87,6 +87,7 @@ struct cpu_fp_state {
>  	void *sme_state;
>  	u64 *svcr;
>  	u64 *fpmr;
> +	u64 sme_features;
>  	unsigned int sve_vl;
>  	unsigned int sme_vl;

It would be simpler to store the full SMCR value, and remove the
'sme_vl' field. Likewise for ZCR and the 'sve_vl` field.

If nothing else, it would make the format of these fields more obvious,
and easier to reason about.

It would also potentially allow us to extend the VL sanity-check in
fpsimd_save_user_state() to check all the relevant control bits prior to
saving state.

[...]

> @@ -1632,6 +1632,12 @@ static void fpsimd_bind_task_to_cpu(void)
>  	last->to_save = FP_STATE_CURRENT;
>  	current->thread.fpsimd_cpu = smp_processor_id();
>  
> +	last->sme_features = 0;
> +	if (system_supports_fa64())
> +		last->sme_features |= SMCR_ELx_FA64;
> +	if (system_supports_sme2())
> +		last->sme_features |= SMCR_ELx_EZT0;

With my proposal on patch 2, this conditional logic would be
centralised within a helper function.

Mark.
