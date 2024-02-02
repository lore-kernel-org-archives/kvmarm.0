Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 132F71474D6
	for <kvmarm@lists.linux.dev>; Fri,  2 Feb 2024 16:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706891173; cv=none; b=iGs9lDogBi5+r6/dQbk+H2hGMJY6hoYMAdeoG/v6MTOwuIKgaWE+o6dbrPaEQuhqyz3t13+o8adgGGM9JrtjTDdLKsM7F1q6XNsW8iSXHoXHSbnHEF3qotdOplA6wdTWxkriSQHl8QYmgfjTwGLOAycxOjqYNPUo0zHvwE8CDOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706891173; c=relaxed/simple;
	bh=sfsn8zLJ9eCvP+K/MtYLIeo1muLaZEq7/NFMWMeByiU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sA7VNM3b7zk97YFEdXwutnUCnP29ifsnWE7j10/MoRKyREQNFRjyF+DRwjIalCGMFwOpOKAFXH3SHLLG2fsp2hdlB1UDpun+2JEgOssO5/jOZ54qZL3nqDfEvO919uqLA0mcXRu2p/Atj/nKXrrBPpIg7ESmCzIoWYLKBzneMZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B6003DA7;
	Fri,  2 Feb 2024 08:26:52 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E0BFC3F5A1;
	Fri,  2 Feb 2024 08:26:08 -0800 (PST)
Date: Fri, 2 Feb 2024 16:26:03 +0000
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v2 04/25] KVM: arm64: nv: Add sanitising to EL2
 configuration registers
Message-ID: <20240202162603.GA2636885@e124191.cambridge.arm.com>
References: <20240130204533.693853-1-maz@kernel.org>
 <20240130204533.693853-5-maz@kernel.org>
 <20240201145607.GH2284078@e124191.cambridge.arm.com>
 <86cyte7vh9.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86cyte7vh9.wl-maz@kernel.org>

On Fri, Feb 02, 2024 at 03:10:26PM +0000, Marc Zyngier wrote:
> On Thu, 01 Feb 2024 14:56:07 +0000,
> Joey Gouly <joey.gouly@arm.com> wrote:
> > 
> > On Tue, Jan 30, 2024 at 08:45:11PM +0000, Marc Zyngier wrote:
> > > We can now start making use of our sanitising masks by setting them
> > > to values that depend on the guest's configuration.
> > > 
> > > First up are VTTBR_EL2, VTCR_EL2, VMPIDR_EL2 and HCR_EL2.
> > > 
> > > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > > ---
> > >  arch/arm64/kvm/nested.c | 56 ++++++++++++++++++++++++++++++++++++++++-
> > >  1 file changed, 55 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> > > index c976cd4b8379..ee461e630527 100644
> > > --- a/arch/arm64/kvm/nested.c
> > > +++ b/arch/arm64/kvm/nested.c
> > > @@ -181,7 +181,7 @@ u64 kvm_vcpu_sanitise_vncr_reg(const struct kvm_vcpu *vcpu, enum vcpu_sysreg sr)
> > >  	return v;
> > >  }
> > >  
> > > -static void __maybe_unused set_sysreg_masks(struct kvm *kvm, int sr, u64 res0, u64 res1)
> > > +static void set_sysreg_masks(struct kvm *kvm, int sr, u64 res0, u64 res1)
> > >  {
> > >  	int i = sr - __VNCR_START__;
> > >  
> > > @@ -191,6 +191,7 @@ static void __maybe_unused set_sysreg_masks(struct kvm *kvm, int sr, u64 res0, u
> > >  
> > >  int kvm_init_nv_sysregs(struct kvm *kvm)
> > >  {
> > > +	u64 res0, res1;
> > >  	int ret = 0;
> > >  
> > >  	mutex_lock(&kvm->arch.config_lock);
> > > @@ -209,6 +210,59 @@ int kvm_init_nv_sysregs(struct kvm *kvm)
> > >  		kvm->arch.id_regs[i] = limit_nv_id_reg(IDX_IDREG(i),
> > >  						       kvm->arch.id_regs[i]);
> > >  
> > > +	/* VTTBR_EL2 */
> > > +	res0 = res1 = 0;
> > > +	if (!kvm_has_feat_enum(kvm, ID_AA64MMFR1_EL1, VMIDBits, 16))
> > > +		res0 |= GENMASK(63, 56);
> > > +	set_sysreg_masks(kvm, VTTBR_EL2, res0, res1);
> > > +
> > > +	/* VTCR_EL2 */
> > > +	res0 = GENMASK(63, 32) | GENMASK(30, 20);
> > > +	res1 = BIT(31);
> > > +	set_sysreg_masks(kvm, VTCR_EL2, res0, res1);
> > > +
> > > +	/* VMPIDR_EL2 */
> > > +	res0 = GENMASK(63, 40) | GENMASK(30, 24);
> > > +	res1 = BIT(31);
> > > +	set_sysreg_masks(kvm, VMPIDR_EL2, res0, res1);
> > > +
> > > +	/* HCR_EL2 */
> > > +	res0 = BIT(48);
> > > +	res1 = HCR_RW;
> > 
> > Just want to clarify this bit actually, this is restricting the (first level
> > only?) nested EL1 to run as AArch64?
> 
> This is restricting it at all levels. The guest hypervisor will
> eventually write its own view of HCR_EL2.RW in the VNCR page, and if
> it has promised AArch32 to its own guest (at any level), it is in for
> a treat, because we will forcefully reset this bit to 1.

Alright, thanks, I'll have to work through that some more.

> 
> > Should we be sanitising ID_AA64PFR0_EL1.EL1=0b0001?
> 
> We already do. See limit_nv_id_reg() and how it constraints
> ID_AA64PFR0_EL1.ELx to 0b0001.
> 

I forgot about that, was looking at read_sanitised_id_aa64pfr0_el1() in the non-
NV parts.

Thanks,
Joey
