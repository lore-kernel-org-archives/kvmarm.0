Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 282024688
	for <kvmarm@lists.linux.dev>; Wed, 12 Jun 2024 13:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718200719; cv=none; b=pa/9q+GxRgod+it9kl3RdSbDacDZRlNr52N8OG5PK3SdPPX4sS6aPLyJgNTu7EtyZXt38ifhhyB3c67VPxPDfiw7gH3FfPOYR9Q0jUCUa13Oajcq+4spu/3zipfXC2EnoXNkqEEdsI3h3a/HJsTAt1+yEK+aG+w4brmnVJV1Rfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718200719; c=relaxed/simple;
	bh=Gy/lm/jdUpZeiX3Bu0wEuYgsJ1o06Dcw4DdUBsQN11Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NDGBgHCCtkCHVijEmDPKRffOyall1XniA/OqBfdHlZV9Vybf6PgmwFiGtbEWXKDrcX64IG24DW/Bitx0tjJmDaiUc0iKAUo7nMnEH2dE1M4JzA402lR36K3dPNlNxLLAOMRbJ8v36WNy596xgXQXfFl8Jm+6wJPkAaYo+6YULK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F14BB367;
	Wed, 12 Jun 2024 06:59:01 -0700 (PDT)
Received: from bogus (e103737-lin.cambridge.arm.com [10.1.197.49])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4678F3F64C;
	Wed, 12 Jun 2024 06:58:35 -0700 (PDT)
Date: Wed, 12 Jun 2024 14:58:31 +0100
From: Sudeep Holla <sudeep.holla@arm.com>
To: Sebastian Ene <sebastianene@google.com>
Cc: catalin.marinas@arm.com, james.morse@arm.com, jean-philippe@linaro.org,
	Sudeep Holla <sudeep.holla@arm.com>, maz@kernel.org,
	oliver.upton@linux.dev, qperret@google.com, qwandor@google.com,
	suzuki.poulose@arm.com, tabba@google.com, will@kernel.org,
	yuzenghui@huawei.com, lpieralisi@kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kernel-team@android.com
Subject: Re: [PATCH v2 1/4] KVM: arm64: Trap FFA_VERSION host call in pKVM
Message-ID: <Zmmph6YlIsBhJQqd@bogus>
References: <20240515172258.1680881-1-sebastianene@google.com>
 <20240515172258.1680881-2-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240515172258.1680881-2-sebastianene@google.com>

On Wed, May 15, 2024 at 05:22:55PM +0000, Sebastian Ene wrote:
> The pKVM hypervisor initializes with FF-A version 1.0. The spec requires
> that no other FF-A calls to be issued before the version negotiation
> phase is complete. Split the hypervisor proxy initialization code in two
> parts so that we can move the later one after the host negotiates its
> version.

Blank line here would be nice.

> Without trapping the call, the host drivers can negotiate a higher
> version number with TEE which can result in a different memory layout
> described during the memory sharing calls.
>

LGTM(apart from minor nits),

Reviewed-by: Sudeep Holla <sudeep.holla@arm.com>

> Signed-off-by: Sebastian Ene <sebastianene@google.com>
> ---
>  arch/arm64/kvm/hyp/nvhe/ffa.c | 123 +++++++++++++++++++++++++---------
>  1 file changed, 92 insertions(+), 31 deletions(-)
>
> diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> index 320f2eaa14a9..72f1206c85fb 100644
> --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
> @@ -1,4 +1,5 @@
>  // SPDX-License-Identifier: GPL-2.0-only
> +//

It should be OK but still spurious for $subject 😉

[...]

> @@ -700,7 +789,6 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
>  int hyp_ffa_init(void *pages)
>  {
>  	struct arm_smccc_res res;
> -	size_t min_rxtx_sz;
>  	void *tx, *rx;
>
>  	if (kvm_host_psci_config.smccc_version < ARM_SMCCC_VERSION_1_2)
> @@ -726,35 +814,7 @@ int hyp_ffa_init(void *pages)
>  	if (FFA_MAJOR_VERSION(res.a0) != 1)
>  		return -EOPNOTSUPP;
>
> -	arm_smccc_1_1_smc(FFA_ID_GET, 0, 0, 0, 0, 0, 0, 0, &res);
> -	if (res.a0 != FFA_SUCCESS)
> -		return -EOPNOTSUPP;
> -
> -	if (res.a2 != HOST_FFA_ID)
> -		return -EINVAL;
> -
> -	arm_smccc_1_1_smc(FFA_FEATURES, FFA_FN64_RXTX_MAP,
> -			  0, 0, 0, 0, 0, 0, &res);
> -	if (res.a0 != FFA_SUCCESS)
> -		return -EOPNOTSUPP;
> -
> -	switch (res.a2) {
> -	case FFA_FEAT_RXTX_MIN_SZ_4K:
> -		min_rxtx_sz = SZ_4K;
> -		break;
> -	case FFA_FEAT_RXTX_MIN_SZ_16K:
> -		min_rxtx_sz = SZ_16K;
> -		break;
> -	case FFA_FEAT_RXTX_MIN_SZ_64K:
> -		min_rxtx_sz = SZ_64K;
> -		break;
> -	default:
> -		return -EINVAL;
> -	}
> -
> -	if (min_rxtx_sz > PAGE_SIZE)
> -		return -EOPNOTSUPP;
> -
> +	hyp_ffa_version = FFA_VERSION_1_0;
>  	tx = pages;
>  	pages += KVM_FFA_MBOX_NR_PAGES * PAGE_SIZE;
>  	rx = pages;
> @@ -773,8 +833,9 @@ int hyp_ffa_init(void *pages)
>  	};
>
>  	host_buffers = (struct kvm_ffa_buffers) {
> -		.lock	= __HYP_SPIN_LOCK_UNLOCKED,
> +		.lock   = __HYP_SPIN_LOCK_UNLOCKED,

Spurious or intentional whitespace change ? I can't make out from the mail.

--
Regards,
Sudeep
