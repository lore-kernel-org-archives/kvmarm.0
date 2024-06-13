Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D21913B580
	for <kvmarm@lists.linux.dev>; Thu, 13 Jun 2024 22:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718317209; cv=none; b=QLIJJg5gVWub+eNKQ1S/dL0vOPkMRUcPao7Vzh5g61hd4gT2Iwavi4BtrIyqFpwVqO8xRoeYCJK/pnkFBWsS9KBM1LVqfSRR0OtGw/mflLl0dDTmZQHdw+YV2i3jY5nZOh78zr5NAJOpiAy+Hr0h5qcF7xPLjT6RCr3O0f2yghs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718317209; c=relaxed/simple;
	bh=YxAoiIkLTLK4wU88qIS8E6Ui4uKTEiKoutR7YpdL6ro=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EpQSf6cxvqQmL/8JqkvJ4Xuqnih+NPyDm7KB7b86439GLUd5NrujAXC0evVPZNHX/YsHX5GabSJ3b8V7wPvOa47+KBPOmQ+TO2jmc/Umkd0ZhpmxRIbyFC6yplq0NU17vyNZqqaSHqEsDpBLkF9dn17FIXJ2RkaM1Rlsm2BIDC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Hve6XeQu; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Hve6XeQu"
X-Envelope-To: sebott@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1718317203;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gvCVPrByglYHE/HphLfz/4s/chgo2zEH02FdJCIN0CE=;
	b=Hve6XeQuraY6xBWjfm3sMkSRrAEP0y8s/jcC1TS3Nk3c45SuqDIP/DtIq9iIsGsYY7ualL
	H40UQUxMkjXkNAhyjm6qv5IapVLxsUMva5/wzcIa2lQQUfD5XWLnX746+0FMwOihNz5RuC
	G1TaP73AgWKgPybrbQtboRjn2JtXWp0=
X-Envelope-To: linux-arm-kernel@lists.infradead.org
X-Envelope-To: kvmarm@lists.linux.dev
X-Envelope-To: linux-kernel@vger.kernel.org
X-Envelope-To: maz@kernel.org
X-Envelope-To: james.morse@arm.com
X-Envelope-To: suzuki.poulose@arm.com
X-Envelope-To: catalin.marinas@arm.com
X-Envelope-To: will@kernel.org
X-Envelope-To: shahuang@redhat.com
X-Envelope-To: eric.auger@redhat.com
Date: Thu, 13 Jun 2024 22:19:56 +0000
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Sebastian Ott <sebott@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Shaoqin Huang <shahuang@redhat.com>,
	Eric Auger <eric.auger@redhat.com>
Subject: Re: [PATCH v4 3/6] KVM: arm64: add emulation for CTR_EL0 register
Message-ID: <ZmtwjLbP283ra0Xq@linux.dev>
References: <20240603130507.17597-1-sebott@redhat.com>
 <20240603130507.17597-4-sebott@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240603130507.17597-4-sebott@redhat.com>
X-Migadu-Flow: FLOW_OUT

Hi Sebastian,

On Mon, Jun 03, 2024 at 03:05:04PM +0200, Sebastian Ott wrote:

[...]

> +static int validate_cache_topology(struct kvm_vcpu *vcpu, u64 ctr_el0)
> +{
> +	const struct sys_reg_desc *clidr_el1;
> +	unsigned int i;
> +	int ret;
> +
> +	clidr_el1 = get_sys_reg_desc(SYS_CLIDR_EL1);
> +	if (!clidr_el1)
> +		return -ENOENT;

This doesn't actually matter if we agree on dropping the cross-checking,
but if this lookup fails it is 100% a KVM bug. Returning ENOENT isn't
exactly right here, since it gives userspace the impression that the
sysreg index it tried to access does not exist.

So in the future it'd be good to return EINVAL in places where the
kernel did something stupid, probably with a warning for good measure.

> +static int set_ctr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
> +		   u64 val)
> +{
> +	u64 ctr, writable_mask = rd->val;
> +	int ret = 0;
> +
> +	mutex_lock(&vcpu->kvm->arch.config_lock);
> +	ctr  = vcpu->kvm->arch.ctr_el0;
> +	if (val == ctr)
> +		goto out_unlock;
> +
> +	ret = -EBUSY;
> +	if (kvm_vm_has_ran_once(vcpu->kvm))
> +		goto out_unlock;
> +
> +	ret = -EINVAL;
> +	if ((ctr & ~writable_mask) != (val & ~writable_mask))
> +		goto out_unlock;
> +
> +	if (((ctr & CTR_EL0_DIC_MASK) < (val & CTR_EL0_DIC_MASK)) ||
> +	    ((ctr & CTR_EL0_IDC_MASK) < (val & CTR_EL0_IDC_MASK)) ||
> +	    ((ctr & CTR_EL0_DminLine_MASK) < (val & CTR_EL0_DminLine_MASK)) ||
> +	    ((ctr & CTR_EL0_IminLine_MASK) < (val & CTR_EL0_IminLine_MASK))) {
> +		goto out_unlock;

I'd prefer if we addressed the issue w/ arm64_check_features() by making
CTR_EL0 behave like the other registers in the ID space instead of
open-coding these sorts of checks.

I believe that can be accomplished by using kvm_read_sanitised_id_reg()
as the ::reset() function in the descriptor and initializing
kvm->arch.ctr_el0 in kvm_reset_id_regs().

> +	}
> +	ret = validate_cache_topology(vcpu, val);
> +	if (ret)
> +		goto out_unlock;

My concerns about adding these sort of cross-checks remains. The sysreg
code will become exponentially more messy with each cross-register check
we add, given the complete lack of ordering on the UAPI.

So long as KVM has independently tested the validity of the cache
hierarchy and CTR_EL0 against the capabilities of hardware, we know that
userspace cannot advertise more than what's supported in hardware.

If CLIDR_EL1 doesn't line up with the value of CTR_EL0 exposed to the
guest then it is a userspace bug. There simply is no amount of
foolproofing that can be done in KVM to protect against a buggy VMM.

-- 
Thanks,
Oliver
