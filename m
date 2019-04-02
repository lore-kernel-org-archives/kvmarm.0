From: Amit Daniel Kachhap <amit.kachhap@arm.com>
Subject: Re: [PATCH v6 11/27] KVM: arm64: Support runtime sysreg visibility
 filtering
Date: Tue, 2 Apr 2019 08:19:05 +0530
Message-ID: <CADGdYn7n826cnvFaBithcj4oaJ0v6kSdZhsCbZndbwoB1f5D_w@mail.gmail.com>
References: <1553017938-710-1-git-send-email-Dave.Martin@arm.com>
 <1553017938-710-12-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1553017938-710-12-git-send-email-Dave.Martin@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Dave Martin <Dave.Martin@arm.com>
Cc: Peter Maydell <peter.maydell@linaro.org>, Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Zhang Lei <zhang.lei@jp.fujitsu.com>, Julien Grall <julien.grall@arm.com>, =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>, kvmarm@lists.cs.columbia.edu, LAK <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Dave,

On Tue, Mar 19, 2019 at 11:26 PM Dave Martin <Dave.Martin@arm.com> wrote:
>
> Some optional features of the Arm architecture add new system
> registers that are not present in the base architecture.
>
> Where these features are optional for the guest, the visibility of
> these registers may need to depend on some runtime configuration,
> such as a flag passed to KVM_ARM_VCPU_INIT.
>
> For example, ZCR_EL1 and ID_AA64ZFR0_EL1 need to be hidden if SVE
> is not enabled for the guest, even though these registers may be
> present in the hardware and visible to the host at EL2.
>
> Adding special-case checks all over the place for individual
> registers is going to get messy as the number of conditionally-
> visible registers grows.
>
> In order to help solve this problem, this patch adds a new sysreg
> method visibility() that can be used to hook in any needed runtime
> visibility checks.  This method can currently return
> REG_HIDDEN_USER to inhibit enumeration and ioctl access to the
> register for userspace, and REG_HIDDEN_GUEST to inhibit runtime
> access by the guest using MSR/MRS.  Wrappers are added to allow
> these flags to be conveniently queried.
>
> This approach allows a conditionally modified view of individual
> system registers such as the CPU ID registers, in addition to
> completely hiding register where appropriate.
>
> Signed-off-by: Dave Martin <Dave.Martin@arm.com>

I used 2 of your patches in my patch series on KVM guest for pointer
authentication [1].

So for these 2 patches,
[PATCH v6 11/27] KVM: arm64: Support runtime sysreg visibility filtering
[PATCH v6 10/27] KVM: arm64: Propagate vcpu into read_id_reg()
Tested by: Amit Daniel Kachhap <amit.kachhap@arm.com>
Reviewed by: Amit Daniel Kachhap <amit.kachhap@arm.com>

[1]: https://patchwork.kernel.org/patch/10880933/

Thanks,
Amit Daniel



>
> ---
>
> Changes since v5:
>
>  * Rename the visibility override flags, add some comments, and rename/
>    introduce helpers to make the purpose of this code clearer.
> ---
>  arch/arm64/kvm/sys_regs.c | 24 +++++++++++++++++++++---
>  arch/arm64/kvm/sys_regs.h | 25 +++++++++++++++++++++++++
>  2 files changed, 46 insertions(+), 3 deletions(-)
>
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index a5d14b5..c86a7b0 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1927,6 +1927,12 @@ static void perform_access(struct kvm_vcpu *vcpu,
>  {
>         trace_kvm_sys_access(*vcpu_pc(vcpu), params, r);
>
> +       /* Check for regs disabled by runtime config */
> +       if (sysreg_hidden_from_guest(vcpu, r)) {
> +               kvm_inject_undefined(vcpu);
> +               return;
> +       }
> +
>         /*
>          * Not having an accessor means that we have configured a trap
>          * that we don't know how to handle. This certainly qualifies
> @@ -2438,6 +2444,10 @@ int kvm_arm_sys_reg_get_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg
>         if (!r)
>                 return get_invariant_sys_reg(reg->id, uaddr);
>
> +       /* Check for regs disabled by runtime config */
> +       if (sysreg_hidden_from_user(vcpu, r))
> +               return -ENOENT;
> +
>         if (r->get_user)
>                 return (r->get_user)(vcpu, r, reg, uaddr);
>
> @@ -2459,6 +2469,10 @@ int kvm_arm_sys_reg_set_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg
>         if (!r)
>                 return set_invariant_sys_reg(reg->id, uaddr);
>
> +       /* Check for regs disabled by runtime config */
> +       if (sysreg_hidden_from_user(vcpu, r))
> +               return -ENOENT;
> +
>         if (r->set_user)
>                 return (r->set_user)(vcpu, r, reg, uaddr);
>
> @@ -2515,7 +2529,8 @@ static bool copy_reg_to_user(const struct sys_reg_desc *reg, u64 __user **uind)
>         return true;
>  }
>
> -static int walk_one_sys_reg(const struct sys_reg_desc *rd,
> +static int walk_one_sys_reg(const struct kvm_vcpu *vcpu,
> +                           const struct sys_reg_desc *rd,
>                             u64 __user **uind,
>                             unsigned int *total)
>  {
> @@ -2526,6 +2541,9 @@ static int walk_one_sys_reg(const struct sys_reg_desc *rd,
>         if (!(rd->reg || rd->get_user))
>                 return 0;
>
> +       if (sysreg_hidden_from_user(vcpu, rd))
> +               return 0;
> +
>         if (!copy_reg_to_user(rd, uind))
>                 return -EFAULT;
>
> @@ -2554,9 +2572,9 @@ static int walk_sys_regs(struct kvm_vcpu *vcpu, u64 __user *uind)
>                 int cmp = cmp_sys_reg(i1, i2);
>                 /* target-specific overrides generic entry. */
>                 if (cmp <= 0)
> -                       err = walk_one_sys_reg(i1, &uind, &total);
> +                       err = walk_one_sys_reg(vcpu, i1, &uind, &total);
>                 else
> -                       err = walk_one_sys_reg(i2, &uind, &total);
> +                       err = walk_one_sys_reg(vcpu, i2, &uind, &total);
>
>                 if (err)
>                         return err;
> diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
> index 3b1bc7f..2be9950 100644
> --- a/arch/arm64/kvm/sys_regs.h
> +++ b/arch/arm64/kvm/sys_regs.h
> @@ -64,8 +64,15 @@ struct sys_reg_desc {
>                         const struct kvm_one_reg *reg, void __user *uaddr);
>         int (*set_user)(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
>                         const struct kvm_one_reg *reg, void __user *uaddr);
> +
> +       /* Return mask of REG_* runtime visibility overrides */
> +       unsigned int (*visibility)(const struct kvm_vcpu *vcpu,
> +                                  const struct sys_reg_desc *rd);
>  };
>
> +#define REG_HIDDEN_USER                (1 << 0) /* hidden from userspace ioctls */
> +#define REG_HIDDEN_GUEST       (1 << 1) /* hidden from guest */
> +
>  static inline void print_sys_reg_instr(const struct sys_reg_params *p)
>  {
>         /* Look, we even formatted it for you to paste into the table! */
> @@ -102,6 +109,24 @@ static inline void reset_val(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r
>         __vcpu_sys_reg(vcpu, r->reg) = r->val;
>  }
>
> +static inline bool sysreg_hidden_from_guest(const struct kvm_vcpu *vcpu,
> +                                           const struct sys_reg_desc *r)
> +{
> +       if (likely(!r->visibility))
> +               return false;
> +
> +       return r->visibility(vcpu, r) & REG_HIDDEN_GUEST;
> +}
> +
> +static inline bool sysreg_hidden_from_user(const struct kvm_vcpu *vcpu,
> +                                          const struct sys_reg_desc *r)
> +{
> +       if (likely(!r->visibility))
> +               return false;
> +
> +       return r->visibility(vcpu, r) & REG_HIDDEN_USER;
> +}
> +
>  static inline int cmp_sys_reg(const struct sys_reg_desc *i1,
>                               const struct sys_reg_desc *i2)
>  {
> --
> 2.1.4
>
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
