Received: from vmicros1.altlinux.org (vmicros1.altlinux.org [194.107.17.57])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 208F81A2550
	for <kvmarm@lists.linux.dev>; Tue, 10 Dec 2024 02:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=194.107.17.57
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733799097; cv=none; b=ASvRgOoS2Me01yve1/g0XjsuFrr8TCJJMS30cSzqWlaoA68UZ1sSvWX503Bjdhvzr8v8tHCIQiQkptD5PShcy/UcpdvwGSnA4aVKMfKs9JoEcZvKDXd1yS7t981I5eU7lvfWlcVtvthSf7TBLEqJCYT8gliaNY6ul7zcE+2AXvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733799097; c=relaxed/simple;
	bh=ikP2AZ1QNPCVrbja1AFpFnlbiV4vcygxdxdBVYqzhWs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cCSwGbgmB8WJZVouY6mT7laP7lHkqXLpw+UiUS7y8B/Zsp6V6bhmGhDgJmLOqG01KdfbZ1I/8jZrg2LLl8XJBdYDrIVvZmg6pscg3Cl3bqyPIF/arEtsuNQtx91l75mnCwJRw8Ch/QfYspBV82kQqnNawrOnTrIpWthLUVRMOow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=altlinux.org; spf=pass smtp.mailfrom=altlinux.org; arc=none smtp.client-ip=194.107.17.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=altlinux.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=altlinux.org
Received: from imap.altlinux.org (imap.altlinux.org [194.107.17.38])
	by vmicros1.altlinux.org (Postfix) with ESMTP id D828F72C8CC;
	Tue, 10 Dec 2024 05:51:27 +0300 (MSK)
Received: from altlinux.org (sole.flsd.net [185.75.180.6])
	by imap.altlinux.org (Postfix) with ESMTPSA id C789B36D018A;
	Tue, 10 Dec 2024 05:51:27 +0300 (MSK)
Date: Tue, 10 Dec 2024 05:51:27 +0300
From: Vitaly Chikunov <vt@altlinux.org>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>
Cc: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	Will Deacon <will@kernel.org>,
	"james.morse@arm.com" <james.morse@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	"Wangzhou (B)" <wangzhou1@hisilicon.com>,
	Gleb Fotengauer-Malinovskiy <glebfm@altlinux.org>
Subject: Re: v6.13-rc1: Internal error: Oops - Undefined instruction:
 0000000002000000 [#1] SMP
Message-ID: <20241210025127.jmkcpw7ixu4r7hxl@altlinux.org>
References: <20241202153618.GA6834@willie-the-truck>
 <86ttbmt71k.wl-maz@kernel.org>
 <20241202155940.p267a3tz5ypj4sog@altlinux.org>
 <86ser6t6fs.wl-maz@kernel.org>
 <20241202223119.k3uod4ksnlf7gqh2@altlinux.org>
 <20241203092721.j473dthkbq6wzez7@altlinux.org>
 <1847e34fa7724d28aeb22d93752f64f2@huawei.com>
 <20241203221453.mwh6sozyczi4ec2k@altlinux.org>
 <87jzcfsuep.wl-maz@kernel.org>
 <20241206205602.7phcrxqsv4c6oul4@altlinux.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20241206205602.7phcrxqsv4c6oul4@altlinux.org>

On Fri, Dec 06, 2024 at 11:56:02PM +0300, Vitaly Chikunov wrote:
> On Wed, Dec 04, 2024 at 08:51:26AM +0000, Marc Zyngier wrote:
> > On Tue, 03 Dec 2024 22:14:53 +0000,
> > Vitaly Chikunov <vt@altlinux.org> wrote:
> > > On Tue, Dec 03, 2024 at 10:03:11AM +0000, Shameerali Kolothum Thodi wrote:
> > 
> > Mark has described what the problem is likely to be. 6.6-stable needs
> > to have 6685f5d572c22e10 backported, and it probably should have been
> > Cc: to stable. Can you please apply the following patch to your *host*
> > machine and retest?
> 
> We tested the host with this patch applied over 6.6.63 and 6.13-rc1
> guest does not Oops anymore.
> 
> I'd suggest this is also get backported to 6.12.y branch.

Please, can someone backport this patch to v6.12 and send to stable? This
would be really useful to have this fixed and it's noted this is a
critical bug.

Thanks,

> 
> Thanks,
> 
> > 
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index 370a1a7bd369..258a39bcd3c7 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -1330,6 +1330,7 @@ static u64 __kvm_read_sanitised_id_reg(const struct kvm_vcpu *vcpu,
> >  			val &= ~ARM64_FEATURE_MASK(ID_AA64PFR1_EL1_MTE);
> >  
> >  		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR1_EL1_SME);
> > +		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR1_EL1_MPAM_frac);
> >  		break;
> >  	case SYS_ID_AA64ISAR1_EL1:
> >  		if (!vcpu_has_ptrauth(vcpu))
> > @@ -1472,6 +1473,13 @@ static u64 read_sanitised_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
> >  
> >  	val &= ~ID_AA64PFR0_EL1_AMU_MASK;
> >  
> > +	/*
> > +	 * MPAM is disabled by default as KVM also needs a set of PARTID to
> > +	 * program the MPAMVPMx_EL2 PARTID remapping registers with. But some
> > +	 * older kernels let the guest see the ID bit.
> > +	 */
> > +	val &= ~ID_AA64PFR0_EL1_MPAM_MASK;
> > +
> >  	return val;
> >  }
> >  
> > @@ -1560,6 +1568,29 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
> >  	return set_id_reg(vcpu, rd, val);
> >  }
> >  
> > +static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
> > +			       const struct sys_reg_desc *rd, u64 user_val)
> > +{
> > +	u64 hw_val = read_sanitised_ftr_reg(SYS_ID_AA64PFR0_EL1);
> > +	u64 mpam_mask = ID_AA64PFR0_EL1_MPAM_MASK;
> > +
> > +	/*
> > +	 * Commit 011e5f5bf529f ("arm64/cpufeature: Add remaining feature bits
> > +	 * in ID_AA64PFR0 register") exposed the MPAM field of AA64PFR0_EL1 to
> > +	 * guests, but didn't add trap handling. KVM doesn't support MPAM and
> > +	 * always returns an UNDEF for these registers. The guest must see 0
> > +	 * for this field.
> > +	 *
> > +	 * But KVM must also accept values from user-space that were provided
> > +	 * by KVM. On CPUs that support MPAM, permit user-space to write
> > +	 * the sanitizied value to ID_AA64PFR0_EL1.MPAM, but ignore this field.
> > +	 */
> > +	if ((hw_val & mpam_mask) == (user_val & mpam_mask))
> > +		user_val &= ~ID_AA64PFR0_EL1_MPAM_MASK;
> > +
> > +	return set_id_reg(vcpu, rd, user_val);
> > +}
> > +
> >  /*
> >   * cpufeature ID register user accessors
> >   *
> > @@ -2018,7 +2049,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
> >  	{ SYS_DESC(SYS_ID_AA64PFR0_EL1),
> >  	  .access = access_id_reg,
> >  	  .get_user = get_id_reg,
> > -	  .set_user = set_id_reg,
> > +	  .set_user = set_id_aa64pfr0_el1,
> >  	  .reset = read_sanitised_id_aa64pfr0_el1,
> >  	  .val = ID_AA64PFR0_EL1_CSV2_MASK | ID_AA64PFR0_EL1_CSV3_MASK, },
> >  	ID_SANITISED(ID_AA64PFR1_EL1),
> > 
