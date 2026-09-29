Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C00AD2AF1D;
	Tue, 29 Sep 2026 23:02:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790722945; cv=none; b=CNqbKyM+/NoStNsi9CwV3feWW5pltsqsI1OonJo7i8B//g5YGgTALIQCSEOG8oFeC5b8vChFPB4aMHg6bE2qFbN7m5LE3DRiQjA3ulf9ZONX3PjtZnkQrGP6h9wXYNRxCYpd4HDxUIe0B6MurinXTgHlo6ihq0lCJA6M/aJUNdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790722945; c=relaxed/simple;
	bh=AlezsuwdXKU96nosGq08Sdrfu3J5rACKi8PcjOcLuOA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mJjLsmn0V1kfCTcWfvqpoKn6s/Nkywwrvsbpmks0WyyuoNM7rdm0bjTkDBPtpU7c66owxAwxpJKMvMvOK4GlsaQ3G9dRSRiGdQLVmtjzj3UdOA/opTivw8TVk+IM1Ew3f8eSmqLMCmyF9uc5CF7wSwrSHmr0WXlUTpbTR/O/Jw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BkBWs7S7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BkBWs7S7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DD831F000FF;
	Tue, 29 Sep 2026 23:02:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790722944;
	bh=c34lg2SSqJP/prfJ37melYcw0xJkVhsVpZy4ROI6WNQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BkBWs7S7hjdEq6uQaiSmWQOfcDATgPWULZ+J7guuGa/CU28Q6gfTkC+xbHVOa7zs7
	 nH8RqrxpXqmeeiv4pA4MwgjKL8ROwIfLjpax4MKm8UKqaheqx447y8hifovoEIGaaT
	 PhurxWdQI7W3gaqoym/sj5LVd3M5OZLKKQXCtfGNBUYC6g2q9k2LH4lt4taA1+Xp8T
	 PNfVW6O+KTAbYQQsF1s0A6bROVcYg/8PQr/Q64mS1FJCGaLdVpXbbCFVygH/CLR0Tf
	 wkq3K5hcLAS9B+jUmby2sJPK6crtqvW7RCrMCMO27wbmLp7wsCKNAvPS6wUog1sIUV
	 mn4T4WaGnv1Cg==
Date: Tue, 29 Sep 2026 16:02:23 -0700
From: Oliver Upton <oupton@kernel.org>
To: Mark Brown <broonie@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Fuad Tabba <fuad.tabba@linux.dev>,
	Peter Maydell <peter.maydell@linaro.org>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: Re: [PATCH v4 0/3] KVM: arm64: ID register finalisation fixes
Message-ID: <arxDf3AHHjKCv6rD@kernel.org>
References: <20260929-kvm-arm64-idreg-final-v4-0-75296dde994d@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260929-kvm-arm64-idreg-final-v4-0-75296dde994d@kernel.org>

Hi,

On Tue, Sep 29, 2026 at 12:57:57PM +0100, Mark Brown wrote:
> While looking at some feature enablement I noticed that there are some
> scenarios where we can end up with an inconsistently configured vCPU due
> to finalizing configuration based on ID registers before we have blocked
> writes to the ID registers. This series aims to clean up these issues.
> 
> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---
> Changes in v4:
> - Rebase onto v7.3-rc3.
> - Add a lockdep assert.
> - Update Fuad's LLM tag.
> - Link to v3: https://patch.msgid.link/20260901-kvm-arm64-idreg-final-v3-0-a0ffa06fa872@kernel.org
> 
> Changes in v3:
> - Rebase onto v7.3-rc1.
> - Explain why KVM_ARCH_FLAG_ID_REGS_INITIALIZED is not reused.
> - Pull in Fuad's test cases.
> - Link to v2: https://patch.msgid.link/20260803-kvm-arm64-idreg-final-v2-0-d7d7e4efc640@kernel.org
> 
> Changes in v2:
> - Also replace the kvm_vm_has_ran_once() usage in kvm_set_vm_id_rg() and
>   kvm_vm_finalize_sys_regs() with kvm_id_regs_final().
> - Link to v1: https://patch.msgid.link/20260731-kvm-arm64-idreg-final-v1-0-3de2a5616dc6@kernel.org
> 
> ---
> Fuad Tabba (1):
>       KVM: arm64: selftests: Check ID regs are immutable after a failed run
> 
> Mark Brown (2):
>       KVM: arm64: Finalize guest-wide sysregs prior to per-vCPU sysregs
>       KVM: arm64: Block ID register changes after we rely on the values

I'm not too terribly jazzed about testing the relative ordering of
errors in the selftest, but I see why we need to do it. Otherwise,
everything looks good.

Reviewed-by: Oliver Upton <oupton@kernel.org>

Thanks,
Oliver
