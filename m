Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CF271F63D6
	for <kvmarm@lists.linux.dev>; Tue, 11 Feb 2025 11:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739273712; cv=none; b=BXOEuaNcXldEr+WIwb/rJUx0Y3CM2IpXs9dEipNt7kF7ZrOtYJSoHTtqq9GYGpY63/psGdOk1X++d9lMriSvXwZMYtnidJPTF4h+I+cqPowIaRPeux6GKD1OHJrBOwcJp8IY6u6MmItes2Ln9th5YMpvO0NB42+/aMXsH4MR+XU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739273712; c=relaxed/simple;
	bh=xcBYWHeQFRNWxiLoR5K9RpPqhW8/hq4zAlf+CCKVN6I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QzCahvq0udmwt2iKHEqW5P9HN77x/ZMa1s5CleZ5rqD62ItwAhSLT1v/Y0xc4cACskY1mVm8KfpNNADR38A/D9pvr1/k2CTcscW0/5svumKNyZItJ2T72BOL7Msw0xoWFcXLnTsDGbpAGm89D9+/Y9xSDR5JMQgRHpz4AwFW7ns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 770D21424;
	Tue, 11 Feb 2025 03:35:31 -0800 (PST)
Received: from J2N7QTR9R3 (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 546A73F5A1;
	Tue, 11 Feb 2025 03:35:08 -0800 (PST)
Date: Tue, 11 Feb 2025 11:34:57 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Mark Brown <broonie@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, Fuad Tabba <tabba@google.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH v6] KVM: arm64: Fix confusion in documentation for pKVM
 SME assert
Message-ID: <Z6s14V_4LzD3dATB@J2N7QTR9R3>
References: <20250210-kvm-arm64-sme-assert-v6-1-cc26c46d1b43@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250210-kvm-arm64-sme-assert-v6-1-cc26c46d1b43@kernel.org>

On Mon, Feb 10, 2025 at 09:33:32PM +0000, Mark Brown wrote:
> As raised in the review comments for the original patch the assert and
> comment added in afb91f5f8ad7 ("KVM: arm64: Ensure that SME controls are
> disabled in protected mode") are bogus. The comments says that we check
> that we do not have SME enabled for a pKVM guest but the assert actually
> checks to see if the host has anything set in SVCR which is unrelated to
> the guest features or state, regardless of if those guests are protected
> or not. This check is also made in the hypervisor, it will refuse to run
> a guest if the check fails, so it appears that the assert here is
> intended to improve diagnostics.
> 
> Update the comment to reflect the check in the code, and to clarify that
> we do actually enforce this in the hypervisor. While we're here also
> update to use a WARN_ON_ONCE() to avoid log spam if this triggers.
> 
> Fixes: afb91f5f8ad7 ("KVM: arm64: Ensure that SME controls are disabled in protected mode")
> Reviewed-by: Fuad Tabba <tabba@google.com>
> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---
> This has been sent with v6.10 with only positive review comments after
> the first revision, if there is some issue with the change please share
> it.
> 
> To: Marc Zyngier <maz@kernel.org>
> To: Oliver Upton <oliver.upton@linux.dev>
> To: James Morse <james.morse@arm.com>
> To: Suzuki K Poulose <suzuki.poulose@arm.com>
> To: Catalin Marinas <catalin.marinas@arm.com>
> To: Will Deacon <will@kernel.org>
> To: Fuad Tabba <tabba@google.com>
> ---
> Changes in v6:
> - Rebase onto v6.14-rc1.
> - Link to v5: https://lore.kernel.org/r/20241210-kvm-arm64-sme-assert-v5-1-995c8dd1025b@kernel.org
> 
> Changes in v5:
> - Rebase onto v6.13-rc1.
> - Link to v4: https://lore.kernel.org/r/20240930-kvm-arm64-sme-assert-v4-1-3c9df71db688@kernel.org
> 
> Changes in v4:
> - Rebase onto v6.12-rc1
> - Link to v3: https://lore.kernel.org/r/20240730-kvm-arm64-sme-assert-v3-1-8699454e5cb8@kernel.org
> 
> Changes in v3:
> - Rebase onto v6.11-rc1.
> - Link to v2: https://lore.kernel.org/r/20240605-kvm-arm64-sme-assert-v2-1-54391b0032f4@kernel.org
> 
> Changes in v2:
> - Commit message tweaks.
> - Change the assert to WARN_ON_ONCE().
> - Link to v1: https://lore.kernel.org/r/20240604-kvm-arm64-sme-assert-v1-1-5d98348d00f8@kernel.org
> ---
>  arch/arm64/kvm/fpsimd.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
> index 4d3d1a2eb157047b4b2488e9c4ffaabc6f5a0818..f3455641e9c8a65470cdeb9d7daba7d59d78748e 100644
> --- a/arch/arm64/kvm/fpsimd.c
> +++ b/arch/arm64/kvm/fpsimd.c
> @@ -93,11 +93,14 @@ void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu)
>  	}
>  
>  	/*
> -	 * If normal guests gain SME support, maintain this behavior for pKVM
> -	 * guests, which don't support SME.
> +	 * The pKVM hypervisor does not yet understand how to save or
> +	 * restore SME state for the host so double check that if we
> +	 * are running with pKVM we have disabled SME.  The hypervisor
> +	 * enforces this when the guest is run, this check is for
> +	 * clearer diagnostics.
>  	 */
> -	WARN_ON(is_protected_kvm_enabled() && system_supports_sme() &&
> -		read_sysreg_s(SYS_SVCR));
> +	WARN_ON_ONCE(is_protected_kvm_enabled() && system_supports_sme() &&
> +		     read_sysreg_s(SYS_SVCR));

This implies that non-protected modes do understand how to save/restore
SME state, and the wording is somewhat clunky.

Given we've just queued up patches requiring that the host has saved
away the FPSIMD/SVE/SME state, I reckon it'd make more sense to simplify
this to:

	/*
	 * Protected and non-protected KVM modes require that
	 * SVCR.{SM,ZA} == {0,0} when entering a guest so that no
	 * host/guest SME state needs to be saved/restored by hyp code.
	 *
	 * In protected mode, hyp code will verify this later.
	 */
	WARN_ON_ONCE(system_supports-sme() && read_sysreg_s(SYS_SVCR));

... and then if/when we enable SME for non-protected modes we can
constrain that further.

Mark.
