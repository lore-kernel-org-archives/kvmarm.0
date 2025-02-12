Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC86F209F5F
	for <kvmarm@lists.linux.dev>; Wed, 12 Feb 2025 11:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739358671; cv=none; b=SvbM7i4OLdixHYxBgjHxqlxRKDXu7bRqpyOxTyc6hdT9Wf/Ek6059syV+FWqhc/ygrIXrGrZwDl10ggdMJfTHJtxayhwK+SoteKdTu15BLLmtdw8u4snRBxc75XnA7kEdwPFGE/mnpCYXWGoJquR6r/px5O+IPjUvjx3+PQQ3pI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739358671; c=relaxed/simple;
	bh=xET6YkcH2j0vaisNGf0x3m2n2EEuhFREA0JODlbMwCw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mLnu2uRE3lkPhE5lQ5YVteBTiM9RMkcECPjhAoxlsuPklGHJ9lnpscA8tizAhU9OCRnF9sC/8ZaqLoQE6wYwIUpz0rOdyxOWp3khIUwVipJ7F5xnRzQ4ji2KU70dfCzA/zhHbv8UFCrDDCGkoKgXhQzwMcdOBkC5JxtK8vS93ks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1A91C106F;
	Wed, 12 Feb 2025 03:11:30 -0800 (PST)
Received: from J2N7QTR9R3 (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1436B3F6A8;
	Wed, 12 Feb 2025 03:11:06 -0800 (PST)
Date: Wed, 12 Feb 2025 11:11:04 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Mark Brown <broonie@kernel.org>, Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, Fuad Tabba <tabba@google.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH v7] KVM: arm64: Fix confusion in documentation for pKVM
 SME assert
Message-ID: <Z6yByMUBPDUyEWOr@J2N7QTR9R3>
References: <20250212-kvm-arm64-sme-assert-v7-1-0f786db838d3@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250212-kvm-arm64-sme-assert-v7-1-0f786db838d3@kernel.org>

On Wed, Feb 12, 2025 at 12:44:57AM +0000, Mark Brown wrote:
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
> Cc: Mark Rutland <mark.rutland@arm.com>
> ---
> Changes in v7:
> - Reword the comment.
> - Link to v6: https://lore.kernel.org/r/20250210-kvm-arm64-sme-assert-v6-1-cc26c46d1b43@kernel.org
> 
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
> index 4d3d1a2eb157047b4b2488e9c4ffaabc6f5a0818..e37e53883c357093ff4455f5afdaec90e662d744 100644
> --- a/arch/arm64/kvm/fpsimd.c
> +++ b/arch/arm64/kvm/fpsimd.c
> @@ -93,11 +93,14 @@ void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu)
>  	}
>  
>  	/*
> -	 * If normal guests gain SME support, maintain this behavior for pKVM
> -	 * guests, which don't support SME.
> +	 * Protected and non-protected KVM modes require that
> +	 * SVCR.{SM,ZA} == {0,0} when entering a guest so that no
> +	 * host/guest SME state needs to be saved/restored by hyp code.
> +	 *
> +	 * In protected mode, hyp code will verify this later.
>  	 */
> -	WARN_ON(is_protected_kvm_enabled() && system_supports_sme() &&
> -		read_sysreg_s(SYS_SVCR));
> +	WARN_ON_ONCE(is_protected_kvm_enabled() && system_supports_sme() &&
> +		     read_sysreg_s(SYS_SVCR));

As I mentioned on the last round, we can drop the is_protected_kvm_enabled()
check, i.e. have:

	/*
	 * Protected and non-protected KVM modes require that
	 * SVCR.{SM,ZA} == {0,0} when entering a guest so that no
	 * host/guest SME state needs to be saved/restored by hyp code.
	 *
	 * In protected mode, hyp code will verify this later.
	 */
	WARN_ON_ONCE(system_supports_sme() && read_sysreg_s(SYS_SVCR));

Either way:

Acked-by: Mark Rutland <mark.rutland@arm.com>

Marc, are you happy to queue this atop the recent fixes from me? Those
try to ensure SVCR.{SM,ZA} == {0,0} regardless of whether KVM is in
protected mode.

Mark.
