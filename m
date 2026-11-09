Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794242226;
	b=jQMeWI3DYv5tZgsHv885BNrWusHFXqifl5UDaDFfgqfp5uH1UzoJ8cTOINU9Uw/sGqIh
	 vYBXVjmV60L/nqnRGoURU46ANSkZh6kCB9G2pzUYEfHXAc1JIZFJUBLAWEAjeoUH8eTaL
	 Bxc3uXsJ7C6ekZrbashAyORxs0sCnv2VA+syOR/zu6iuN3exyuRBBAXTieMYwFzIhe1a8
	 6Kt4ikI+6m2az+O4FqDDb7BGmemQb8s4pXvIduvIMh0DJq38b1hKj8wuulSuYwmlnhE+c
	 1fcuN1LojvxiPXcKSLoD6oKajBj/dQww9dMmMNwTI8h9Dm3SZENV4yMWKLEFFPDBnSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794242226;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding;
	bh=vH/MYZkykAzSBl4zExRxk2S5v4k1DkLdhI45xxu98gw=;
	b=kKEmQb9w/qWBJe/WMP6GXdzXQcUfzsG10qSqyfT74O/KUkj7aZzT/PgX/F6YukGzB6R6
	 D6cNOv3jgKrpE88su2EnijDS9xeF04kJQvfDAkbp2bDoTSNybWzZdfIGxqxG4TuFpsNVV
	 6t8GnOdFGgNe+SbZtrU4iwSLwFPpjvjrMqfAzaQcA7BRLUTrp0ouAfCwMNEXOGa2bYRQs
	 qm2106k7GQ8FL8ZnX36dD51uMkVLecNrvEEjfCtQ4qNKkOFoH4gMp867V5durrt+ee9Wt
	 EP8LlHQt3z5ssOv/5OYienIXpwauyo6mjfSQOAtNfkt2F4s7ovz+3bI4r2qiU/iubmg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=GU69NTNP;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51CC360A261B
	for <kvmarm@lists.linux.dev>; Mon,  9 Nov 2026 16:37:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 51CC360A261B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=GU69NTNP
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 561A31477;
	Mon,  9 Nov 2026 08:37:01 -0800 (PST)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 059443F85F;
	Mon,  9 Nov 2026 08:37:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794242224; bh=HCZdSUSMy2O/BljBaRhjFP1G8QNBKQnh3QLPXli95GY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GU69NTNP0dzaMty4RnvxdaWbQPz8YF3Ihj4z4N9EXZLJoH6bHZHiJaqZ6YZP9TIjp
	 uNHkN9o7W9Gl73qNc1Wa0RjsX6gS+38dbjN+wKiZh8KmjTcoV/MFyRn+ouNfXr19ph
	 IVetg/jCLW7+PXRVCdMO38CWeSlso+85Jt1WuunU=
From: Leonardo Bras <leo.bras@arm.com>
To: Oliver Upton <oupton@kernel.org>
Cc: Leonardo Bras <leo.bras@arm.com>,
	kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Fuad Tabba <fuad.tabba@linux.dev>
Subject: Re: [PATCH 3/8] KVM: arm64: Separate user / guest visibility flags
Date: Mon,  9 Nov 2026 16:36:57 +0000
Message-ID: <avH2qE6rdieP_fyY@LeoBrasDK>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104192124.3932743-4-oupton@kernel.org>
References: <20261104192124.3932743-1-oupton@kernel.org> <20261104192124.3932743-4-oupton@kernel.org>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Wed, Nov 04, 2026 at 11:21:19AM -0800, Oliver Upton wrote:
> There's need for even more visibility hacks to differentiate between
> userspace and guest. Decompose REG_HIDDEN into two parts and test for
> the user-specific flag on all the appropriate UAPI surfaces.
> 
> Signed-off-by: Oliver Upton <oupton@kernel.org>
> ---
>  arch/arm64/kvm/sys_regs.c        | 10 +++++-----
>  arch/arm64/kvm/sys_regs.h        | 23 +++++++++++++++++------
>  arch/arm64/kvm/vgic-sys-reg-v3.c |  2 +-
>  arch/arm64/kvm/vgic-sys-reg-v5.c |  2 +-
>  4 files changed, 24 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 850eba167aad..870dcb25d0d7 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -4866,7 +4866,7 @@ static void perform_access(struct kvm_vcpu *vcpu,
>  	trace_kvm_sys_access(*vcpu_pc(vcpu), params, r);
>  
>  	/* Check for regs disabled by runtime config */
> -	if (sysreg_hidden(vcpu, r)) {
> +	if (sysreg_guest_hidden(vcpu, r)) {
>  		kvm_inject_undefined(vcpu);
>  		return;
>  	}
> @@ -5490,7 +5490,7 @@ id_to_sys_reg_desc(struct kvm_vcpu *vcpu, u64 id,
>  	r = get_reg_by_id(id, table, num);
>  
>  	/* Not saved in the sys_reg array and not otherwise accessible? */
> -	if (r && (!(r->reg || r->get_user) || sysreg_hidden(vcpu, r)))
> +	if (r && (!(r->reg || r->get_user) || sysreg_user_hidden(vcpu, r)))
>  		r = NULL;
>  
>  	return r;
> @@ -5571,7 +5571,7 @@ int kvm_sys_reg_get_user(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg,
>  	int ret;
>  
>  	r = id_to_sys_reg_desc(vcpu, id, table, num);
> -	if (!r || sysreg_hidden(vcpu, r))
> +	if (!r || sysreg_user_hidden(vcpu, r))
>  		return -ENOENT;
>  
>  	if (r->get_user) {
> @@ -5611,7 +5611,7 @@ int kvm_sys_reg_set_user(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg,
>  		return -EFAULT;
>  
>  	r = id_to_sys_reg_desc(vcpu, id, table, num);
> -	if (!r || sysreg_hidden(vcpu, r))
> +	if (!r || sysreg_user_hidden(vcpu, r))
>  		return -ENOENT;
>  
>  	if (sysreg_user_write_ignore(vcpu, r))
> @@ -5705,7 +5705,7 @@ static int walk_one_sys_reg(const struct kvm_vcpu *vcpu,
>  	if (!(rd->reg || rd->get_user))
>  		return 0;
>  
> -	if (sysreg_hidden(vcpu, rd))
> +	if (sysreg_user_hidden(vcpu, rd))
>  		return 0;
>  
>  	if (!copy_reg_to_user(rd, uind))
> diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
> index a3cccad2766f..50214271b24a 100644
> --- a/arch/arm64/kvm/sys_regs.h
> +++ b/arch/arm64/kvm/sys_regs.h
> @@ -104,9 +104,14 @@ struct sys_reg_desc {
>  				   const struct sys_reg_desc *rd);
>  };
>  
> -#define REG_HIDDEN		(1 << 0) /* hidden from userspace and guest */
> -#define REG_RAZ			(1 << 1) /* RAZ from userspace and guest */
> -#define REG_USER_WI		(1 << 2) /* WI from userspace only */
> +#define REG_GUEST_HIDDEN	BIT(0)
> +#define REG_USER_HIDDEN		BIT(1)
> +	/* Hidden from userspace and guest */
> +#define REG_HIDDEN		(REG_GUEST_HIDDEN | REG_USER_HIDDEN)
> +	/* RAZ from userspace and guest */
> +#define REG_RAZ			BIT(2)
> +	/* WI from userspace only */
> +#define REG_USER_WI		BIT(3)

So REG_HIDDEN returned by visibility functions now means that it's 
hidden from both guest access and usersace, and you changed the test 
helpers to check only one of them at a time.  

IIUC 'user hidden' means "Userspace/VMM does not have access to this reg", 
while 'guest hidden' means "Guest does not have access to this reg". If 
that's the case, it makes sense all of the conversions that came from 
syscalls (getters/setters, etc) became 'user hidden' and the one that comes 
from kvm handlers became 'guest hidden'.

If I got that right, FWIW:
Reviewed-by: Leonardo Bras <leo.bras@arm.com>

Thanks!
Leo

>  
>  static __printf(2, 3)
>  inline void print_sys_reg_msg(const struct sys_reg_params *p,
> @@ -168,10 +173,16 @@ static inline unsigned int sysreg_visibility(const struct kvm_vcpu *vcpu,
>  	return r->visibility(vcpu, r);
>  }
>  
> -static inline bool sysreg_hidden(const struct kvm_vcpu *vcpu,
> -				 const struct sys_reg_desc *r)
> +static inline bool sysreg_user_hidden(const struct kvm_vcpu *vcpu,
> +				      const struct sys_reg_desc *r)
> +{
> +	return sysreg_visibility(vcpu, r) & REG_USER_HIDDEN;
> +}
> +
> +static inline bool sysreg_guest_hidden(const struct kvm_vcpu *vcpu,
> +				       const struct sys_reg_desc *r)
>  {
> -	return sysreg_visibility(vcpu, r) & REG_HIDDEN;
> +	return sysreg_visibility(vcpu, r) & REG_GUEST_HIDDEN;
>  }
>  
>  static inline bool sysreg_visible_as_raz(const struct kvm_vcpu *vcpu,
> diff --git a/arch/arm64/kvm/vgic-sys-reg-v3.c b/arch/arm64/kvm/vgic-sys-reg-v3.c
> index 89315336b9d3..f41c21ee9e89 100644
> --- a/arch/arm64/kvm/vgic-sys-reg-v3.c
> +++ b/arch/arm64/kvm/vgic-sys-reg-v3.c
> @@ -465,7 +465,7 @@ int vgic_v3_has_cpu_sysregs_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *
>  	r = get_reg_by_id(attr_to_id(attr->attr), gic_v3_icc_reg_descs,
>  			  ARRAY_SIZE(gic_v3_icc_reg_descs));
>  
> -	if (r && !sysreg_hidden(vcpu, r))
> +	if (r && !sysreg_user_hidden(vcpu, r))
>  		return 0;
>  
>  	return -ENXIO;
> diff --git a/arch/arm64/kvm/vgic-sys-reg-v5.c b/arch/arm64/kvm/vgic-sys-reg-v5.c
> index 6b255eacbf60..e62d5e908f5a 100644
> --- a/arch/arm64/kvm/vgic-sys-reg-v5.c
> +++ b/arch/arm64/kvm/vgic-sys-reg-v5.c
> @@ -495,7 +495,7 @@ int vgic_v5_has_cpu_sysregs_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *
>  	r = get_reg_by_id(attr_to_id(attr->attr), gic_v5_icc_reg_descs,
>  			  ARRAY_SIZE(gic_v5_icc_reg_descs));
>  
> -	if (r && !sysreg_hidden(vcpu, r))
> +	if (r && !sysreg_user_hidden(vcpu, r))
>  		return 0;
>  
>  	return -ENXIO;
> -- 
> 2.47.3
> 
