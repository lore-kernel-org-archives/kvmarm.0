Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDC4A152E05
	for <kvmarm@lists.linux.dev>; Sat,  1 Jun 2024 16:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717260453; cv=none; b=V4IKJENFOQ2D+54G/xr9H3JEEpolcYbPQGDg3c62at++qnb9AstmXVcm8pYz7txuZdqOHtvVAXX1JawzGktkXs5BqngtMl0wKPvNlDLN1svVxR00uPevZn50GJ68v+qXSfYjHDwPeZdTr5A2ndUrCgWGhZjCatTDGbFP3L9+6L8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717260453; c=relaxed/simple;
	bh=hcEKQjFR+BDHEaDgJvrNjjER+d6AUCCf9SO7wlCq5TM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P0cARAFM8/W8nrHsSHKe3ajINbal00e9i9Q3NHVg0UDCNI2997rv/dcSFonNzXYF+b+zJbZmdAB8SugBX9ebAiIS2DMDH3sOEgnZA1zYqoMjWzLRBvFKiqGulkJTd0WxwgtM/N69hA51biRs3UAsl9g9zHoqdSGl111dHHyoWLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=PrlnCk5k; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="PrlnCk5k"
X-Envelope-To: maz@kernel.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1717260449;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HftneTOpLCAadUKPhKOwEoi7rTto1zNpLVNsoOs4x/0=;
	b=PrlnCk5k6vLw7X94ebIoV2LgLdldxYG+fz/LmaAWknrUvh06Fn3fyIdzFbnOB3zux+Hg/O
	9G+kylB7U+fD1/9iLTfsnK6MwJttAEY9hNNaex0RAUj80KukyhWbujfbue1OaKQdw0x3Bh
	3c3n+huzFU/pQ1GinLHnHezd9e1ZwRQ=
X-Envelope-To: kvmarm@lists.linux.dev
X-Envelope-To: james.morse@arm.com
X-Envelope-To: suzuki.poulose@arm.com
X-Envelope-To: yuzenghui@huawei.com
X-Envelope-To: kvm@vger.kernel.org
Date: Sat, 1 Jun 2024 09:47:23 -0700
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, kvm@vger.kernel.org
Subject: Re: [PATCH 03/11] KVM: arm64: nv: Load guest FP state for ZCR_EL2
 trap
Message-ID: <ZltQm5a8CFtX1emJ@linux.dev>
References: <20240531231358.1000039-1-oliver.upton@linux.dev>
 <20240531231358.1000039-4-oliver.upton@linux.dev>
 <87le3p2dvg.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87le3p2dvg.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Sat, Jun 01, 2024 at 10:47:47AM +0100, Marc Zyngier wrote:
> On Sat, 01 Jun 2024 00:13:50 +0100, Oliver Upton <oliver.upton@linux.dev> wrote:
> > +static bool kvm_hyp_handle_zcr(struct kvm_vcpu *vcpu, u64 *exit_code)
> > +{
> > +	u32 sysreg = esr_sys64_to_sysreg(kvm_vcpu_get_esr(vcpu));
> > +
> > +	if (!vcpu_has_nv(vcpu))
> > +		return false;
> > +
> > +	if (sysreg != SYS_ZCR_EL2)
> > +		return false;
> > +
> > +	if (guest_owns_fp_regs())
> > +		return false;
> > +
> > +	return kvm_hyp_handle_fpsimd(vcpu, exit_code);
> 
> For my own understanding of the flow: let's say the L1 guest accesses
> ZCR_EL2 while the host own the FP regs:
> 
> - ZCR_EL2 traps
> - we restore the guest's state, enable SVE
> - ZCR_EL2 traps again
> - emulate the access on the slow path
> 
> In contrast, the same thing using ZCR_EL1 in L1 results in:
> 
> - ZCR_EL1 traps
> - we restore the guest's state, enable SVE
> 
> and we're done.
> 
> Is that correct? If so, a comment would help... ;-)

Yeah, and I agree having a comment for this would be a good idea. Now
that I'm looking at this code again, I had wanted to avoid the second
trap on ZCR_EL2, so I'll probably fold in a change to bounce out to the
slow path after loading SVE state.

-- 
Thanks,
Oliver
