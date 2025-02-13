Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43631145348
	for <kvmarm@lists.linux.dev>; Thu, 13 Feb 2025 17:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739466203; cv=none; b=I6RJ0TNBrLqqkCBk+v29nG0/4uB0kyZea9Glf14hUFHgunMpb/V2A3FdXmu1CDXj9BMzpRNN90XRmvSUQ0XoadxFVvzQOAphinvfOj26m906FhBEDegIVHKzhG+SQ27MjoUCZCVJ843iJOfFJUUjXVV6+3Vmlu0NAFrgSqjUAhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739466203; c=relaxed/simple;
	bh=vnxnylEp+XKENV3z/9ZNHoQdEM/a7qJdlV6rCttjW9w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MXMJrKIv0YjTofx22YmE0IzQ5aUSBWKqQscruI66nzXdaOuRNcCYTb3VLHmlIm2Xig/8LhtiDIwPyM2ABel17AQ0szCiZc5ncosGk+CswhhifnSZCFYzB6w6mRKB/4UEnoLr0HGmvHWzhPFYBG8pSeoPLnNUyx2rTVNtGuxULYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 429B3113E;
	Thu, 13 Feb 2025 09:03:42 -0800 (PST)
Received: from localhost (e132581.arm.com [10.2.76.71])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3C4D83F6A8;
	Thu, 13 Feb 2025 09:03:21 -0800 (PST)
Date: Thu, 13 Feb 2025 17:03:16 +0000
From: Leo Yan <leo.yan@arm.com>
To: "Rob Herring (Arm)" <robh@kernel.org>
Cc: Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	James Clark <james.clark@linaro.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH v19 10/11] KVM: arm64: nvhe: Disable branch generation in
 nVHE guests
Message-ID: <20250213170316.GG235556@e132581.arm.com>
References: <20250202-arm-brbe-v19-v19-0-1c1300802385@kernel.org>
 <20250202-arm-brbe-v19-v19-10-1c1300802385@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250202-arm-brbe-v19-v19-10-1c1300802385@kernel.org>

On Sun, Feb 02, 2025 at 06:43:04PM -0600, Rob Herring (Arm) wrote:

[...]

> +static void __debug_save_brbe(u64 *brbcr_el1)
> +{
> +       *brbcr_el1 = 0;
> +
> +       /* Check if the BRBE is enabled */
> +       if (!(read_sysreg_el1(SYS_BRBCR) & (BRBCR_ELx_E0BRE | BRBCR_ELx_ExBRE)))
> +               return;
> +
> +       /*
> +        * Prohibit branch record generation while we are in guest.
> +        * Since access to BRBCR_EL1 is trapped, the guest can't
> +        * modify the filtering set by the host.
> +        */
> +       *brbcr_el1 = read_sysreg_el1(SYS_BRBCR);
> +       write_sysreg_el1(0, SYS_BRBCR);
> +}

Should flush branch record and use isb() before exit host kernel?

I see inconsistence between the function above and BRBE's disable
function. Here it clears E0BRE / ExBRE bits for disabling BRBE, but the
BRBE driver sets the PAUSED bit in BRBFCR_EL1 for disabling BRBE.

Thanks,
Leo
