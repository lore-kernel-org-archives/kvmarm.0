Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00AE7F4FA
	for <kvmarm@lists.linux.dev>; Thu, 21 Mar 2024 20:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711052180; cv=none; b=EqJ9BKpqFDYRlJoRbaFKZxLTHVJUBNaz7vN4ohE8VCEiF1a0MicQehcYIaf1cP57U4/JCRf0mpoBJSHIAUUXdWVA510YWNaKWmkZXiSA41vp3MPe9tMVpm+cVvRf957eTUs1WiCxVmPTLM0vw+rv4enumig4eB05vlzva+Jtj8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711052180; c=relaxed/simple;
	bh=XDYRtpFYGTLWSwntVaOCXTd2tcPD/B7ThWnThgt9yLk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z5Ixk7+03v2ieUMUs/P2rke45MAHIRTOsEmcvC0K0mB1jMgcPoPOK9a/oGxlKLV6M6+DRi90gZZuWdS79CRdLssAzqVAXtelzlSHJcGXQXcIRrYHn8fMzLetA5nJJNbfNph+lY84hvaqdxSl7QnS1T8YPNEMEY0Y16ktcl4m9r8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10044C433F1;
	Thu, 21 Mar 2024 20:16:17 +0000 (UTC)
Date: Thu, 21 Mar 2024 20:16:15 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH] arm64: Fix early handling of FEAT_E2H0 not being
 implemented
Message-ID: <ZfyVj8txU6WngPGH@arm.com>
References: <20240321115414.3169115-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240321115414.3169115-1-maz@kernel.org>

On Thu, Mar 21, 2024 at 11:54:14AM +0000, Marc Zyngier wrote:
> Commit 3944382fa6f2 introduced checks for the FEAT_E2H0 not being
> implemented. However, the check is absolutely wrong and makes a
> point it testing a bit that is guaranteed to be zero.
> 
> On top of that, the detection happens way too late, after the
> init_el2_state has done its job.
> 
> This went undetected because the HW this was tested on has E2H being
> RAO/WI, and not RES1. However, the bug shows up when run as a nested
> guest, where HCR_EL2.E2H is not necessarily set to 1. As a result,
> booting the kernel in hVHE mode fails with timer accesses being
> cought in a trap loop (which was fun to debug).
> 
> Fix the check for ID_AA64MMFR4_EL1.E2H0, and set the HCR_EL2.E2H bit
> early so that it can be checked by the rest of the init sequence.
> 
> With this, hVHE works again in a NV environment that doesn't have
> FEAT_E2H0.
> 
> Fixes: 3944382fa6f2 ("arm64: Treat HCR_EL2.E2H as RES1 when ID_AA64MMFR4_EL1.E2H0 is negative")
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Acked-by: Catalin Marinas <catalin.marinas@arm.com>

I assume Oliver will take it, otherwise I can pick it up after -rc1
since I don't have the fixed commit in my tree.

-- 
Catalin
