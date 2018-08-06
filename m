From: Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: [RFC PATCH 09/16] KVM: arm64: Allow ID registers to by
 dynamically read-as-zero
Date: Mon, 6 Aug 2018 15:03:24 +0200
Message-ID: <20180806130324.GA5985@e113682-lin.lund.arm.com>
References: <1529593060-542-1-git-send-email-Dave.Martin@arm.com>
 <1529593060-542-10-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B75B849F94
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Aug 2018 09:03:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 05L31WwI2PpY for <kvmarm@lists.cs.columbia.edu>;
 Mon,  6 Aug 2018 09:03:28 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D7B0E40672
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Aug 2018 09:03:27 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <1529593060-542-10-git-send-email-Dave.Martin@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Dave Martin <Dave.Martin@arm.com>
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Dave,

I think there's a typo in the subject "to be" rather than "to by".

On Thu, Jun 21, 2018 at 03:57:33PM +0100, Dave Martin wrote:
> When a feature-dependent ID register is hidden from the guest, it
> needs to exhibit read-as-zero behaviour as defined by the Arm
> architecture, rather than appearing to be entirely absent.
> 
> This patch updates the ID register emulation logic to make use of
> the new check_present() method to determine whether the register
> should read as zero instead of yielding the host's sanitised
> value.  Because currently a false result from this method truncates
> the trap call chain before the sysreg's emulate method() is called,
> a flag is added to distinguish this special case, and helpers are
> refactored appropriately.

I don't understand this last sentence.

And I'm not really sure I understand the code either.

I can't seem to see any registers which are defined as !present && !raz,
which is what I thought this feature was all about.

In other words, what is the benefit of this more generic method as
opposed to having a wrapper around read_id_reg() for read_sve_id_reg()
which sets RAZ if there is no support for SVE in this context?

Thanks,
-Christoffer

> 
> This invloves some trivial updates to pass the vcpu pointer down
> into the ID register emulation/access functions.
> 
> A new ID_SANITISED_IF() macro is defined for declaring
> conditionally visible ID registers.
> 
> Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> ---
>  arch/arm64/kvm/sys_regs.c | 51 ++++++++++++++++++++++++++++++-----------------
>  arch/arm64/kvm/sys_regs.h | 11 ++++++++++
>  2 files changed, 44 insertions(+), 18 deletions(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 31a351a..87d2468 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -987,11 +987,17 @@ static bool access_cntp_cval(struct kvm_vcpu *vcpu,
>  }
>  
>  /* Read a sanitised cpufeature ID register by sys_reg_desc */
> -static u64 read_id_reg(struct sys_reg_desc const *r, bool raz)
> +static u64 read_id_reg(const struct kvm_vcpu *vcpu,
> +		       struct sys_reg_desc const *r, bool raz)
>  {
>  	u32 id = sys_reg((u32)r->Op0, (u32)r->Op1,
>  			 (u32)r->CRn, (u32)r->CRm, (u32)r->Op2);
> -	u64 val = raz ? 0 : read_sanitised_ftr_reg(id);
> +	u64 val;
> +
> +	if (raz || !sys_reg_present(vcpu, r))
> +		val = 0;
> +	else
> +		val = read_sanitised_ftr_reg(id);
>  
>  	if (id == SYS_ID_AA64PFR0_EL1) {
>  		if (val & (0xfUL << ID_AA64PFR0_SVE_SHIFT))
> @@ -1018,7 +1024,7 @@ static bool __access_id_reg(struct kvm_vcpu *vcpu,
>  	if (p->is_write)
>  		return write_to_read_only(vcpu, p, r);
>  
> -	p->regval = read_id_reg(r, raz);
> +	p->regval = read_id_reg(vcpu, r, raz);
>  	return true;
>  }
>  
> @@ -1047,16 +1053,18 @@ static u64 sys_reg_to_index(const struct sys_reg_desc *reg);
>   * are stored, and for set_id_reg() we don't allow the effective value
>   * to be changed.
>   */
> -static int __get_id_reg(const struct sys_reg_desc *rd, void __user *uaddr,
> +static int __get_id_reg(const struct kvm_vcpu *vcpu,
> +			const struct sys_reg_desc *rd, void __user *uaddr,
>  			bool raz)
>  {
>  	const u64 id = sys_reg_to_index(rd);
> -	const u64 val = read_id_reg(rd, raz);
> +	const u64 val = read_id_reg(vcpu, rd, raz);
>  
>  	return reg_to_user(uaddr, &val, id);
>  }
>  
> -static int __set_id_reg(const struct sys_reg_desc *rd, void __user *uaddr,
> +static int __set_id_reg(const struct kvm_vcpu *vcpu,
> +			const struct sys_reg_desc *rd, void __user *uaddr,
>  			bool raz)
>  {
>  	const u64 id = sys_reg_to_index(rd);
> @@ -1068,7 +1076,7 @@ static int __set_id_reg(const struct sys_reg_desc *rd, void __user *uaddr,
>  		return err;
>  
>  	/* This is what we mean by invariant: you can't change it. */
> -	if (val != read_id_reg(rd, raz))
> +	if (val != read_id_reg(vcpu, rd, raz))
>  		return -EINVAL;
>  
>  	return 0;
> @@ -1077,33 +1085,40 @@ static int __set_id_reg(const struct sys_reg_desc *rd, void __user *uaddr,
>  static int get_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
>  		      const struct kvm_one_reg *reg, void __user *uaddr)
>  {
> -	return __get_id_reg(rd, uaddr, false);
> +	return __get_id_reg(vcpu, rd, uaddr, false);
>  }
>  
>  static int set_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
>  		      const struct kvm_one_reg *reg, void __user *uaddr)
>  {
> -	return __set_id_reg(rd, uaddr, false);
> +	return __set_id_reg(vcpu, rd, uaddr, false);
>  }
>  
>  static int get_raz_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
>  			  const struct kvm_one_reg *reg, void __user *uaddr)
>  {
> -	return __get_id_reg(rd, uaddr, true);
> +	return __get_id_reg(vcpu, rd, uaddr, true);
>  }
>  
>  static int set_raz_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
>  			  const struct kvm_one_reg *reg, void __user *uaddr)
>  {
> -	return __set_id_reg(rd, uaddr, true);
> +	return __set_id_reg(vcpu, rd, uaddr, true);
>  }
>  
>  /* sys_reg_desc initialiser for known cpufeature ID registers */
> -#define ID_SANITISED(name) {			\
> +#define __ID_SANITISED(name)			\
>  	SYS_DESC(SYS_##name),			\
>  	.access	= access_id_reg,		\
>  	.get_user = get_id_reg,			\
> -	.set_user = set_id_reg,			\
> +	.set_user = set_id_reg
> +
> +#define ID_SANITISED(name) { __ID_SANITISED(name) }
> +
> +#define ID_SANITISED_IF(name, check) {		\
> +	__ID_SANITISED(name),			\
> +	.check_present = check,			\
> +	.flags = SR_RAZ_IF_ABSENT,		\
>  }
>  
>  /*
> @@ -1840,7 +1855,7 @@ static int emulate_cp(struct kvm_vcpu *vcpu,
>  
>  	r = find_reg(params, table, num);
>  
> -	if (likely(r) && sys_reg_present(vcpu, r)) {
> +	if (likely(r) && sys_reg_present_or_raz(vcpu, r)) {
>  		perform_access(vcpu, params, r);
>  		return 0;
>  	}
> @@ -2016,7 +2031,7 @@ static int emulate_sys_reg(struct kvm_vcpu *vcpu,
>  	if (!r)
>  		r = find_reg(params, sys_reg_descs, ARRAY_SIZE(sys_reg_descs));
>  
> -	if (likely(r) && sys_reg_present(vcpu, r)) {
> +	if (likely(r) && sys_reg_present_or_raz(vcpu, r)) {
>  		perform_access(vcpu, params, r);
>  	} else {
>  		kvm_err("Unsupported guest sys_reg access at: %lx\n",
> @@ -2313,7 +2328,7 @@ int kvm_arm_sys_reg_get_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg
>  	if (!r)
>  		return get_invariant_sys_reg(reg->id, uaddr);
>  
> -	if (!sys_reg_present(vcpu, r))
> +	if (!sys_reg_present_or_raz(vcpu, r))
>  		return -ENOENT;
>  
>  	if (r->get_user)
> @@ -2337,7 +2352,7 @@ int kvm_arm_sys_reg_set_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg
>  	if (!r)
>  		return set_invariant_sys_reg(reg->id, uaddr);
>  
> -	if (!sys_reg_present(vcpu, r))
> +	if (!sys_reg_present_or_raz(vcpu, r))
>  		return -ENOENT;
>  
>  	if (r->set_user)
> @@ -2408,7 +2423,7 @@ static int walk_one_sys_reg(struct kvm_vcpu *vcpu,
>  	if (!(rd->reg || rd->get_user))
>  		return 0;
>  
> -	if (!sys_reg_present(vcpu, rd))
> +	if (!sys_reg_present_or_raz(vcpu, rd))
>  		return 0;
>  
>  	if (!copy_reg_to_user(rd, uind))
> diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
> index dfbb342..304928f 100644
> --- a/arch/arm64/kvm/sys_regs.h
> +++ b/arch/arm64/kvm/sys_regs.h
> @@ -66,14 +66,25 @@ struct sys_reg_desc {
>  			const struct kvm_one_reg *reg, void __user *uaddr);
>  	bool (*check_present)(const struct kvm_vcpu *vpcu,
>  			      const struct sys_reg_desc *rd);
> +
> +	/* OR of SR_* flags */
> +	unsigned int flags;
>  };
>  
> +#define SR_RAZ_IF_ABSENT	(1 << 0)
> +
>  static inline bool sys_reg_present(const struct kvm_vcpu *vcpu,
>  				   const struct sys_reg_desc *rd)
>  {
>  	return likely(!rd->check_present) || rd->check_present(vcpu, rd);
>  }
>  
> +static inline bool sys_reg_present_or_raz(const struct kvm_vcpu *vcpu,
> +					  const struct sys_reg_desc *rd)
> +{
> +	return sys_reg_present(vcpu, rd) || (rd->flags & SR_RAZ_IF_ABSENT);
> +}
> +
>  static inline void print_sys_reg_instr(const struct sys_reg_params *p)
>  {
>  	/* Look, we even formatted it for you to paste into the table! */
> -- 
> 2.1.4
> 
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
