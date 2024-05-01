Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F6387F
	for <kvmarm@lists.linux.dev>; Wed,  1 May 2024 06:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714546280; cv=none; b=C5NvO+KEe8ADAaPK6MVrYc5eScKuGxZqf3TUXkwH+XDM+qMzp4kXuryi1qzeIkNMnT8/ZH7zz3d3ouW3g1sBbvQbbtTr1zvpZSYgNcYOSJW39+goGBShHv93wiNVxZibDPKiu2MzQcVA9JJy3OCHXnvFhkQxK42uxQMhw84v3PA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714546280; c=relaxed/simple;
	bh=SireIWA+TEphRA7LVA2Cy7B/RDfmWBPVxRODIiZM74o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lPQ9niPh7vKVFfb86nOWoZA7vqsFN7S1gJarvOs2ACYYODvz55n+KSLr9nmWWwG4OpSZCUWPHa7DvBhWF+ZPIitA0ZWVyAO4tCCCTMcocmRo8B52qdSa7sMuXW7c8tgB8cmO+pAqhj1p1KRw3nTLnSGqrB7txH/h7x0qpZDUANI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Ai3adrx8; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Ai3adrx8"
Date: Wed, 1 May 2024 06:51:11 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1714546276;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CWi8bLLKtBukGh8G8zTTjC/3eWfwrHWDi/RHw99/oFY=;
	b=Ai3adrx8ClVvRwCA5urG/wBGSd0ZhpkPcliTI60FIvrx2jdMTcNTcAPxsu/H5gFxBmbKct
	WekqzR6yVfJLEqbAbu94jAWErnYXS1SV3YjuwOsusm1bkYZTEYOziCbwNY+whcWNh9JDRt
	P+Mfa/SaYLqy2nox9/YFZIiaU7wSGhg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Sebastian Ott <sebott@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH v2 2/6] KVM: arm64: unify trap setup code
Message-ID: <ZjHmX_O7KTInLuL5@linux.dev>
References: <20240426104950.7382-1-sebott@redhat.com>
 <20240426104950.7382-3-sebott@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240426104950.7382-3-sebott@redhat.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Apr 26, 2024 at 12:49:46PM +0200, Sebastian Ott wrote:
> There are 2 functions to set up traps via HCR_EL2:

nitpick: these functions *calculate* the trap values, but do not
actually set them up. HCR_EL2 doesn't get written to until further down
the line on KVM_RUN.

> +	if (cpus_have_final_cap(ARM64_HAS_STAGE2_FWB)) {
> +		vcpu->arch.hcr_el2 |= HCR_FWB;
> +	} else {
> +		/*
> +		 * For non-FWB CPUs, we trap VM ops (HCR_EL2.TVM) until M+C
> +		 * get set in SCTLR_EL1 such that we can detect when the guest
> +		 * MMU gets turned on and do the necessary cache maintenance
> +		 * then.
> +		 */
> +		vcpu->arch.hcr_el2 |= HCR_TVM;
> +	}

It seems to me like calling this once for the lifetime of a vCPU will
break non-FWB behavior.

Like the comment suggests, these traps are needed to catch the moment
the S1 MMU is turned on and do cache maintenance to make sure D$ agrees
with what the guest was doing before enabling the MMU.

KVM_ARM_VCPU_INIT resets SCTLR_EL1, but it seems we'd miss setting
HCR_TVM in that case.

-- 
Thanks,
Oliver
