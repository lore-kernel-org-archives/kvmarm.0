Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18054376483
	for <kvmarm@lists.linux.dev>; Thu, 19 Mar 2026 15:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773934493; cv=none; b=EXxPKsYz+QchBHeCxJRnmZ7/pufqFSuP1hM5TPU8i358pMAsk80+82ODHe5H3/dAzXh6Wqe6Qd0mJ0bjejTeM/Z+K66IdSCrCJYtYzdorWnpmlfYnk8qe0gKYkLzfwKqQshqUkQ4pfVFUjRTgn2gaRj20pzaB5wrzN0Xt2veuwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773934493; c=relaxed/simple;
	bh=d+7Rp9uPvrCnRUQM9SWXYjajsmLqKol28+AsIto0qXs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tbH2m0G2J1h7KG7aMYkG+t30lbKKoPATIWuKVz3mnvGjwleNxySGpVk/d4+hut/pDlOfJXqHwM9e/4POsPLpopBoPpEMgfAwNg40HX1IBv9RjbzGQgqazCXeFfcyDuXFXgMNrZZ+8jgAV9/0K4YmKKspwtCgcKWZs3D0V2HBypE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5CCEC1A25;
	Thu, 19 Mar 2026 08:34:45 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 204EA3F778;
	Thu, 19 Mar 2026 08:34:50 -0700 (PDT)
Date: Thu, 19 Mar 2026 15:34:47 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	Fuad Tabba <tabba@google.com>, Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v2 01/11] arm64: Skip update of an idreg field affected
 by an override
Message-ID: <abwXl35xQ2ze1XwJ@arm.com>
References: <20260302115653.1517326-1-maz@kernel.org>
 <20260302115653.1517326-2-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260302115653.1517326-2-maz@kernel.org>

On Mon, Mar 02, 2026 at 11:56:42AM +0000, Marc Zyngier wrote:
> When computing the new value od an idreg that contains a field
> affected by an override, do not update that particular field.
> 
> The value computed at init-time must be kept as-is, as that's
> what the user has asked for, for better or worse.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kernel/cpufeature.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index c31f8e17732a3..28fc77443ccd3 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -1224,6 +1224,13 @@ static void update_cpu_ftr_reg(struct arm64_ftr_reg *reg, u64 new)
>  		s64 ftr_cur = arm64_ftr_value(ftrp, reg->sys_val);
>  		s64 ftr_new = arm64_ftr_value(ftrp, new);
>  
> +		/*
> +		 * Don't alter the initial value that has been forced
> +		 * by an override.
> +		 */
> +		if ((reg->override->mask & arm64_ftr_mask(ftrp)) == arm64_ftr_mask(ftrp))
> +			continue;

I got lost in the in the cpufeature framework, so I may be missing
something.

Let's say the primary CPU has a feature field with value 2 and we want
to override it to value 1. For e.g. a LOWER_SAFE feature, boot_cpu_data
will stored the overridden value of 1.

A secondary CPU comes online with the same feature missing, so value 0.
With the above change, we no longer update the system-wide feature
value, leave it as 1. Later on, for a system feature we may turn it on
even though the secondary CPU does not support it.

In summary, this makes the overridden field sticky for secondary CPUs
even if they don't support it.

Unrelated to your patch, I think we can similarly fail to reject
secondary CPUs in check_early_cpu_features() -> verify_local_cpu_caps()
because of __read_sysreg_by_encoding() which uses the override value
unconditionally. From this perspective, we are now consistent with your
patch above.

In all cases we taint the kernel for FTR_STRICT features but that may go
unnoticed or if we had FTR_NONSTRICT (does it even matter in this
case?).

Maybe that's the intended use and blame the user for passing the wrong
override. We are still slightly inconsistent depending on what the boot
CPU supports where we still decide whether accept or reject an override.
We don't do this for secondaries.

Anyway, I'm not opposing to this patch if that's what's intended. I'm
sure I'll forget everything about this framework in a couple of weeks.

-- 
Catalin
