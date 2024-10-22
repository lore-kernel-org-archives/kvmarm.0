Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E20331BE858
	for <kvmarm@lists.linux.dev>; Tue, 22 Oct 2024 16:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729613443; cv=none; b=BJgwTk6ZwvJWVVmWc8aSKYLRZrVn9lXMTGDU2n9Pt3ni4dgdKM1abrMiHPnQ5tKMaePY99h5FPKV2hbfc8xQDklW+qfrcBu4/M6XDMJK926Betb4GTcKJYat4XmfzYwYnSMrc769Ks/uaXSlSYlt3srvAQqQSfIejF9nu+vCSP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729613443; c=relaxed/simple;
	bh=sJlwNI5V9oYYAabgfoaSfOAgFY0ULQEOwfiJkm4D2tw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V9eoLqSQ3fc1U3f9bpPY+otL2wWxGZyPHVzJB5GNCrphqEcLG945vCM6dnKUXd1iUou3UykiaCLxqJV/WpgO5IhTTsQRdlC2TUA0OlP9kpbwc6l30tyDBVq6Ub6PcebOOczznYLMnWB0jM3LYd3ycavazK7yHJa32q26914tq7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 07E99497;
	Tue, 22 Oct 2024 09:11:10 -0700 (PDT)
Received: from J2N7QTR9R3 (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CCF923F73B;
	Tue, 22 Oct 2024 09:10:37 -0700 (PDT)
Date: Tue, 22 Oct 2024 17:10:34 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Brown <broonie@kernel.org>,
	kvmarm@lists.linux.dev, linux-doc@vger.kernel.org
Subject: Re: [PATCH 2/3] arm64/boot: Enable EL2 requirements for
 FEAT_Debugv8p9
Message-ID: <ZxfOeqyb3RvsdYbU@J2N7QTR9R3>
References: <20241001043602.1116991-1-anshuman.khandual@arm.com>
 <20241001043602.1116991-3-anshuman.khandual@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241001043602.1116991-3-anshuman.khandual@arm.com>

On Tue, Oct 01, 2024 at 10:06:01AM +0530, Anshuman Khandual wrote:
> Fine grained trap control for MDSELR_EL1 register needs to be configured in
> HDFGRTR2_EL2, and HDFGWTR2_EL2 registers when kernel enters at EL1, but EL2
> is also present. This adds a new helper __init_el2_fgt2() initializing this
> new FEAT_FGT2 based fine grained registers.
> 
> MDCR_EL2.EBWE needs to be enabled for additional (beyond 16) breakpoint and
> watchpoint exceptions when kernel enters at EL1, but EL2 is also present.
> This updates __init_el2_debug() as required for FEAT_Debugv8p9.
> 
> While here, also update booting.rst with MDCR_EL3 and SCR_EL3 requirements.

[...]

> +  For CPUs with FEAT_Debugv8p9 extension present:
> +
> +  - If the kernel is entered at EL1 and EL2 is present:
> +
> +    - HDFGRTR2_EL2.nMDSELR_EL1 (bit 5) must be initialized to 0b1
> +    - HDFGWTR2_EL2.nMDSELR_EL1 (bit 5) must be initialized to 0b1
> +    - MDCR_EL2.EBWE (bit 43) must be initialized to 0b1
> +
> +  - If EL3 is present:
> +
> +    - MDCR_EL3.TDA (bit 9) must be initialized to 0b0

AFAICT we need TDA==0 this regardless of FEAT_Debugv8p9 (and e.g. we need
MDCR_EL3.TPM==0 where FEAT_PMUv3 is implemented), so we should probably
check if there's anything else we haven't yet documented in MDCR_EL3.

[...]

>  .Lskip_trace_\@:
> +	mrs	x1, id_aa64dfr0_el1
> +	ubfx	x1, x1, #ID_AA64DFR0_EL1_DebugVer_SHIFT, #4
> +	cmp	x1, #ID_AA64DFR0_EL1_DebugVer_V8P9
> +	b.lt	.Lskip_dbg_v8p9_\@
> +
> +	mov	x0, #MDCR_EL2_EBWE
> +	orr	x2, x2, x0

That can be:

	orr	x2, x2, #MDCR_EL2_EBWE

Mark.
