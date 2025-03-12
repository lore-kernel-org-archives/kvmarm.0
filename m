Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5625B198E76
	for <kvmarm@lists.linux.dev>; Wed, 12 Mar 2025 17:32:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741800746; cv=none; b=LYKUrRf6E0L1papeTKI1nMpZDaKIARe0a6hLUXbYrYs5GAGcdGDGiYyw7Fr3ca++jmfUigbF/ueY1POe87iQ67+i3AYN9bND6Okcxr8XDn03J8CkwXrd0u1BsvEJ1JZyn0JR1xoJOhVIZ4PY6Y2O64pkpWyl4JpYu01mi8+Ends=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741800746; c=relaxed/simple;
	bh=CfaKg21h1SLchsyMHjVjdRmtRE2GGhngxM2giOK+PCQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FBBJ59fMMSFzZowBd+r7PGjEQMiwXKi++Yq2CJEiNDOQBxqf3urmVYwT84cFhWokWy7jBrEiJlAWY0RmYmEx1l4zcXtK2w+n+I4D5csIH6u/T7zCeBaNrJVXTEylKBUgwlyxYn5Km2KvRMZNB7C88W8yTDschqQiD1UPfUQLuXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=vXDF0426; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="vXDF0426"
Date: Wed, 12 Mar 2025 10:32:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741800732;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SdaEm1VNGTVs7e8vROCN0lC4A4+/l+BdkvlB4cJdMRM=;
	b=vXDF0426B5OZljtJCJNvlYdWu08s1ZbpovJJYcgUb07F0RA1TGjYRncGuVg7BWpEEyxA5e
	R2OpLHpeoM8w4dUA9uveEie1VFlSCfaIJcejGMODufGunQU9JLK5NI8iVIQxAlGhNvihC6
	iKdeT9RNrMqqWa6L1IL5nnubsLGDELM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Sebastian Ott <sebott@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: Writable TGRAN*_2
Message-ID: <Z9HE92ZlNlJbHJBB@linux.dev>
References: <20250306184013.30008-1-sebott@redhat.com>
 <Z9HCQ40LxShzL4nj@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z9HCQ40LxShzL4nj@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Wed, Mar 12, 2025 at 10:20:03AM -0700, Oliver Upton wrote:
> Hi Sebastian,
> 
> On Thu, Mar 06, 2025 at 07:40:13PM +0100, Sebastian Ott wrote:
> > Allow userspace to write the safe (NI) value for ID_AA64MMFR0_EL1.TGRAN*_2.
> > Disallow to change these fields for NV since kvm provides a sanitized view
> > for them based on the PAGE_SIZE.
> > Also add these bits to the set_id_regs selftest.
> > 
> > Signed-off-by: Sebastian Ott <sebott@redhat.com>
> 
> I can't tell what you've based this patch on, it certainly doesn't apply
> on a 6.14 rc. Consider telling git to include the base commit next time
> you generate a patch.

/me finishes a cup of coffee

The conflict is obviously with 9d6745572899 ("KVM: arm64: Hide
ID_AA64MMFR2_EL1.NV from guest and userspace"), which is in
kvmarm/next...

> > ---
> >  arch/arm64/kvm/sys_regs.c                     | 21 +++++++++++++++----
> >  .../testing/selftests/kvm/arm64/set_id_regs.c |  3 +++
> >  2 files changed, 20 insertions(+), 4 deletions(-)
> > 
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index 14faf213d483..0730ed8314d0 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -1948,6 +1948,21 @@ static int set_id_aa64pfr1_el1(struct kvm_vcpu *vcpu,
> >  	return set_id_reg(vcpu, rd, user_val);
> >  }
> >  
> > +static int set_id_aa64mmfr0_el1(struct kvm_vcpu *vcpu,
> > +				const struct sys_reg_desc *rd, u64 user_val)
> > +{
> > +	u64 sanitized_val = kvm_read_sanitised_id_reg(vcpu, rd);
> > +	u64 tgran2_mask = ID_AA64MMFR0_EL1_TGRAN4_2_MASK |
> > +			  ID_AA64MMFR0_EL1_TGRAN16_2_MASK |
> > +			  ID_AA64MMFR0_EL1_TGRAN64_2_MASK;
> > +
> > +	if (vcpu_has_nv(vcpu) &&
> > +	    ((sanitized_val & tgran2_mask) != (user_val & tgran2_mask)))
> > +		return -EINVAL;
> > +
> > +	return set_id_reg(vcpu, rd, user_val);
> > +}
> > +
> >  static int set_id_aa64mmfr2_el1(struct kvm_vcpu *vcpu,
> >  				const struct sys_reg_desc *rd, u64 user_val)
> >  {
> > @@ -2787,10 +2802,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
> >  	ID_UNALLOCATED(6,7),
> >  
> >  	/* CRm=7 */
> > -	ID_WRITABLE(ID_AA64MMFR0_EL1, ~(ID_AA64MMFR0_EL1_RES0 |
> > -					ID_AA64MMFR0_EL1_TGRAN4_2 |
> > -					ID_AA64MMFR0_EL1_TGRAN64_2 |
> > -					ID_AA64MMFR0_EL1_TGRAN16_2 |
> > +	ID_FILTERED(ID_AA64MMFR0_EL1, id_aa64mmfr0_el1,
> > +				      ~(ID_AA64MMFR0_EL1_RES0 |
> >  					ID_AA64MMFR0_EL1_ASIDBITS)),
> >  	ID_WRITABLE(ID_AA64MMFR1_EL1, ~(ID_AA64MMFR1_EL1_RES0 |
> >  					ID_AA64MMFR1_EL1_HCX |
> > diff --git a/tools/testing/selftests/kvm/arm64/set_id_regs.c b/tools/testing/selftests/kvm/arm64/set_id_regs.c
> > index 1d65f4a09e6f..322b9d3b0125 100644
> > --- a/tools/testing/selftests/kvm/arm64/set_id_regs.c
> > +++ b/tools/testing/selftests/kvm/arm64/set_id_regs.c
> > @@ -146,6 +146,9 @@ static const struct reg_ftr_bits ftr_id_aa64pfr1_el1[] = {
> >  static const struct reg_ftr_bits ftr_id_aa64mmfr0_el1[] = {
> >  	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64MMFR0_EL1, ECV, 0),
> >  	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64MMFR0_EL1, EXS, 0),
> > +	REG_FTR_BITS(FTR_EXACT, ID_AA64MMFR0_EL1, TGRAN4_2, 1),
> > +	REG_FTR_BITS(FTR_EXACT, ID_AA64MMFR0_EL1, TGRAN64_2, 1),
> > +	REG_FTR_BITS(FTR_EXACT, ID_AA64MMFR0_EL1, TGRAN16_2, 1),
> >  	S_REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64MMFR0_EL1, TGRAN4, 0),
> >  	S_REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64MMFR0_EL1, TGRAN64, 0),
> >  	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64MMFR0_EL1, TGRAN16, 0),
> 
> Please do selftests changes in a separate patch.
> 
> Don't worry about respinning, I'll fix this up and queue it in a moment.
> 
> Thanks,
> Oliver
> 
