From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH] arm64: KVM: Hide PMU from guests when disabled
Date: Mon, 8 Jan 2018 15:18:15 +0100
Message-ID: <20180108141815.GA15307@cbox>
References: <20171125174031.13117-1-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E113449D36
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Jan 2018 09:13:39 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pZyob4Vz2E80 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  8 Jan 2018 09:13:38 -0500 (EST)
Received: from mail-wm0-f67.google.com (mail-wm0-f67.google.com [74.125.82.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BF71649D32
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Jan 2018 09:13:38 -0500 (EST)
Received: by mail-wm0-f67.google.com with SMTP id i11so14486378wmf.4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 08 Jan 2018 06:18:18 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20171125174031.13117-1-drjones@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Jones <drjones@redhat.com>
Cc: cdall@linaro.org, kvm@vger.kernel.org, marc.zyngier@arm.com, Dave.Martin@arm.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi Drew,

On Sat, Nov 25, 2017 at 06:40:31PM +0100, Andrew Jones wrote:
> Since commit 93390c0a1b20 ("arm64: KVM: Hide unsupported AArch64 CPU
> features from guests") we can hide cpu features from guests. Apply
> this to a long standing issue where guests see a PMU available, but
> it's not, because it was not enabled by KVM's userspace.
> 
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
>  arch/arm64/kvm/sys_regs.c | 35 +++++++++++++++++++++--------------
>  1 file changed, 21 insertions(+), 14 deletions(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 1830ebc227d1..503144f13af0 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -881,18 +881,25 @@ static bool access_cntp_cval(struct kvm_vcpu *vcpu,
>  }
>  
>  /* Read a sanitised cpufeature ID register by sys_reg_desc */
> -static u64 read_id_reg(struct sys_reg_desc const *r, bool raz)
> +static u64 read_id_reg(struct kvm_vcpu *vcpu,
> +		       struct sys_reg_desc const *r,
> +		       bool raz)
>  {
>  	u32 id = sys_reg((u32)r->Op0, (u32)r->Op1,
>  			 (u32)r->CRn, (u32)r->CRm, (u32)r->Op2);
>  	u64 val = raz ? 0 : read_sanitised_ftr_reg(id);
>  
> -	if (id == SYS_ID_AA64PFR0_EL1) {
> +	switch (id) {
> +	case SYS_ID_AA64DFR0_EL1:
> +		if (!kvm_arm_pmu_v3_ready(vcpu))
> +			val &= ~(0xfUL << ID_AA64DFR0_PMUVER_SHIFT);

This is actually problematic, becuase it can break migration.  If
user space reads the guest state at some point after the guest has been
started with vPMU enabled, but then tries to restore the state before
creating a pmu, then we get an error.  See below...

> +		break;
> +	case SYS_ID_AA64PFR0_EL1:
>  		if (val & (0xfUL << ID_AA64PFR0_SVE_SHIFT))
>  			pr_err_once("kvm [%i]: SVE unsupported for guests, suppressing\n",
>  				    task_pid_nr(current));
> -
>  		val &= ~(0xfUL << ID_AA64PFR0_SVE_SHIFT);
> +		break;
>  	}
>  
>  	return val;
> @@ -908,7 +915,7 @@ static bool __access_id_reg(struct kvm_vcpu *vcpu,
>  	if (p->is_write)
>  		return write_to_read_only(vcpu, p, r);
>  
> -	p->regval = read_id_reg(r, raz);
> +	p->regval = read_id_reg(vcpu, r, raz);
>  	return true;
>  }
>  
> @@ -937,17 +944,17 @@ static u64 sys_reg_to_index(const struct sys_reg_desc *reg);
>   * are stored, and for set_id_reg() we don't allow the effective value
>   * to be changed.
>   */
> -static int __get_id_reg(const struct sys_reg_desc *rd, void __user *uaddr,
> -			bool raz)
> +static int __get_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
> +			void __user *uaddr, bool raz)
>  {
>  	const u64 id = sys_reg_to_index(rd);
> -	const u64 val = read_id_reg(rd, raz);
> +	const u64 val = read_id_reg(vcpu, rd, raz);
>  
>  	return reg_to_user(uaddr, &val, id);
>  }
>  
> -static int __set_id_reg(const struct sys_reg_desc *rd, void __user *uaddr,
> -			bool raz)
> +static int __set_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
> +			void __user *uaddr, bool raz)
>  {
>  	const u64 id = sys_reg_to_index(rd);
>  	int err;
> @@ -958,7 +965,7 @@ static int __set_id_reg(const struct sys_reg_desc *rd, void __user *uaddr,
>  		return err;
>  
>  	/* This is what we mean by invariant: you can't change it. */
> -	if (val != read_id_reg(rd, raz))
> +	if (val != read_id_reg(vcpu, rd, raz))

So since we modified read_id_reg above for the PMU, we have now broken
migration, because we've introduced an implicit ordering requirement for
creating the PMU.

One way to handle this is to remove this check at this point and verify
integrity when we're about to run a VCPU, but that changes behavior and
we've been happy with the invariant checks so far.

Perhaps a better approach is to let userspace write ID register values
that can be hidden, and then simply mask of features when the guest is
running which would allow snapshotting the id register values any time
before/after adding all features/peripherals to the VCPUs.

Thoughts?

I'll drop this patch from queue and next for now until we have a better
solution.

Thanks,
-Christoffer
