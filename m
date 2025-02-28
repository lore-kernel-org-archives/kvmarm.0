Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 318292580DB
	for <kvmarm@lists.linux.dev>; Fri, 28 Feb 2025 09:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740735003; cv=none; b=Su/hyM5+hDWGc3GnRU4DWQTmWvkOTkYPHsLjcu+XML0P+QOk0t+N1Jdqx88/ieFAMpeqecMpWn+xz4dEXYjKUVMG+mMl2R+2vcjeOqAem7B2a+4eNRvwJoknl2BXYwbhDUYcWxw9AH/k68lznUHeUhaD2ETxgnDqTscOHyIj0YM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740735003; c=relaxed/simple;
	bh=d0SuwmOKo/XBggeb/NDKybGU1Dc1X3o4zx0/1EssuJE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nQ6loqRJ7BRUZLKDgkp8ezu2k2EoAd2CmcxgYvWwkIq+/EZ9FsTGnG0cloSt2Ni3S09Jq4lJQ0YhWinmR++Wn51lFQrsjlVn1EIHo8iTKCjZxKYUUNjSBq+R9uPc1zLkCt0jnLmC74MYKUGQjpt3UyX0l4vMEY80I9OYkkRO/nw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 79A751515;
	Fri, 28 Feb 2025 01:30:15 -0800 (PST)
Received: from localhost (e132581.arm.com [10.2.76.71])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CC9783F673;
	Fri, 28 Feb 2025 01:29:59 -0800 (PST)
Date: Fri, 28 Feb 2025 09:29:55 +0000
From: Leo Yan <leo.yan@arm.com>
To: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, ahmed.genidi@arm.com,
	ben.horgan@arm.com, catalin.marinas@arm.com, kvmarm@lists.linux.dev,
	maz@kernel.org, oliver.upton@linux.dev, will@kernel.org
Subject: Re: [PATCH 1/2] KVM: arm64: Initialize HCR_EL2.E2H early
Message-ID: <20250228092955.GC2157064@e132581.arm.com>
References: <20250227180526.1204723-1-mark.rutland@arm.com>
 <20250227180526.1204723-2-mark.rutland@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250227180526.1204723-2-mark.rutland@arm.com>

Hi Mark,

On Thu, Feb 27, 2025 at 06:05:25PM +0000, Mark Rutland wrote:

[...]

> +.macro init_el2_hcr	val
> +	mov_q	x0, \val
> +
> +	/*
> +	 * Compliant CPUs advertise their VHE-onlyness with
> +	 * ID_AA64MMFR4_EL1.E2H0 < 0. On such CPUs HCR_EL2.E2H is RES1, but it
> +	 * can reset into an UNKNOWN state and might not read as 1 until it has
> +	 * been initialized explicitly.

For ID_AA64MMFR4_EL1.E2H0 < 0 case, the code actually clears the
HCR_EL2.E2H bit.

Hence, the comment should be corrected as: "... it can reset into an
UNKNOWN state and might not read as 0 until it has been initialized
explicitly".

> +	 *
> +	 * Fruity CPUs seem to have HCR_EL2.E2H set to RAO/WI, but
> +	 * don't advertise it (they predate this relaxation).
> +	 *
> +	 * Initalize HCR_EL2.E2H so that later code can rely upon HCR_EL2.E2H
> +	 * indicating whether the CPU is running in E2H mode.
> +	 */

I think it is even better to clear the HCR_E2H bit first. This can
avoid any dependency on the passed parameter 'val'.

        bic     x0, x0, #HCR_E2H

> +	mrs_s	x1, SYS_ID_AA64MMFR4_EL1
> +	sbfx	x1, x1, #ID_AA64MMFR4_EL1_E2H0_SHIFT, #ID_AA64MMFR4_EL1_E2H0_WIDTH
> +	cmp	x1, #0
> +	b.lt	.LnVHE_\@
> +
> +	orr	x0, x0, #HCR_E2H
> +.LnVHE_\@:
> +	msr	hcr_el2, x0
> +	isb
> +.endm
