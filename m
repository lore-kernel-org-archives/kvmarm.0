Received: from out-185.mta1.migadu.com (out-185.mta1.migadu.com [95.215.58.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CCA443AA5
	for <kvmarm@lists.linux.dev>; Fri, 24 May 2024 19:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716577891; cv=none; b=Y095YmGt/mt6do+IS10N10Nc7+QRkBADSuB+k9isenEPo4ItlavKgAEhYGmPzT0CvVNVs7JGvDkDwmK/kns8TNL5iALF/3QhXm59vgYZkPpjwJfQpd9ZiVsQp4isb82vNV7qwAt0fxiaxEz7e39Z6+4RkxB40+l0DoD/XCDM9jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716577891; c=relaxed/simple;
	bh=adX1xvyfD3usb+V7xsW3URC7B2LLPhytLCkvyGh6WXM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Bc700IZNMNYjBT/kcXbw5USYGpOFLKTzk85RLlD2a+8bbN4Pl7nOinqkMEI/lzeXsMFVdYFAwHotTpj7nm5nrhw34i8aJjxJrv9wPuGxnwEC15zWmjMl/iM5lBWRrZKrE+14gDS6xndz7CMyKVNe5AkrDla88NoUCvwxl8fPse0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=XvmmdnH/; arc=none smtp.client-ip=95.215.58.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="XvmmdnH/"
X-Envelope-To: maz@kernel.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1716577886;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lhqVCrk4TUPu/R/gwdf3f4+jj1RHh1pN1QQ0wWRJLzw=;
	b=XvmmdnH/ZwwZ+1V+73CmrvodZeZMc6Bnw4R3V1H3u9HCUk5Ygjjp3BF1fCixBMX9PUA9Lo
	Fs3si+aEcD1ofbR9CG0qgd1gqK4Em5ifZ54Pv1ZQ580jznyrocpvC5SMf2lIxkWI3k/KRU
	NeSFKs4V+QgSCvE2QFBlo58NCwJKbBE=
X-Envelope-To: kvmarm@lists.linux.dev
X-Envelope-To: kvm@vger.kernel.org
X-Envelope-To: linux-arm-kernel@lists.infradead.org
X-Envelope-To: nsg@linux.ibm.com
X-Envelope-To: james.morse@arm.com
X-Envelope-To: suzuki.poulose@arm.com
X-Envelope-To: yuzenghui@huawei.com
X-Envelope-To: stable@vger.kernel.org
Date: Fri, 24 May 2024 12:11:20 -0700
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, stable@vger.kernel.org
Subject: Re: [PATCH 1/3] KVM: arm64: Fix AArch32 register narrowing on
 userspace write
Message-ID: <ZlDmWMtHMyOq5CLC@linux.dev>
References: <20240524141956.1450304-1-maz@kernel.org>
 <20240524141956.1450304-2-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240524141956.1450304-2-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Fri, May 24, 2024 at 03:19:54PM +0100, Marc Zyngier wrote:
> When userspace writes to once of the core registers, we make

s/once/one/

> sure to narrow the corresponding GPRs if PSTATE indicates
> an AArch32 context.
> 
> The code tries to check whether the context is EL0 or EL1 so
> that it narrows the correct registers. But it does so by checking
> the full PSTATE instead of PSTATE.M.
> 
> As a consequence, and if we are restoring an AArch32 EL0 context
> in a 64bit guest, and that PSTATE has *any* bit set outside of
> PSTATE.M, we narrow *all* registers instead of only the first 15,
> destroying the 64bit state.
> 
> Obviously, this is not something the guest is likely to enjoy.
> 
> Correctly masking PSTATE to only evaluate PSTATE.M fixes it.
> 
> Fixes: 90c1f934ed71 ("KVM: arm64: Get rid of the AArch32 register mapping code")
> Reported-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Cc: stable@vger.kernel.org
> ---
>  arch/arm64/kvm/guest.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> index e2f762d959bb..d9617b11f7a8 100644
> --- a/arch/arm64/kvm/guest.c
> +++ b/arch/arm64/kvm/guest.c
> @@ -276,7 +276,7 @@ static int set_core_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>  	if (*vcpu_cpsr(vcpu) & PSR_MODE32_BIT) {
>  		int i, nr_reg;
>  
> -		switch (*vcpu_cpsr(vcpu)) {
> +		switch (*vcpu_cpsr(vcpu) & PSR_AA32_MODE_MASK) {
>  		/*
>  		 * Either we are dealing with user mode, and only the
>  		 * first 15 registers (+ PC) must be narrowed to 32bit.
> -- 
> 2.39.2
> 
