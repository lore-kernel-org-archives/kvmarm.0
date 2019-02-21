From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v6 5/6] arm64/kvm: control accessibility of ptrauth key
 registers
Date: Thu, 21 Feb 2019 15:53:59 +0000
Message-ID: <20190221155359.GZ3567@e103592.cambridge.arm.com>
References: <1550568271-5319-1-git-send-email-amit.kachhap@arm.com>
 <1550568271-5319-6-git-send-email-amit.kachhap@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1550568271-5319-6-git-send-email-amit.kachhap@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Amit Daniel Kachhap <amit.kachhap@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Kristina Martsenko <kristina.martsenko@arm.com>, kvmarm@lists.cs.columbia.edu, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Feb 19, 2019 at 02:54:30PM +0530, Amit Daniel Kachhap wrote:
> According to userspace settings, ptrauth key registers are conditionally
> present in guest system register list based on user specified flag
> KVM_ARM_VCPU_PTRAUTH.
> 
> Reset routines still sets these registers to default values but they are
> left like that as they are conditionally accessible (set/get).
> 
> Signed-off-by: Amit Daniel Kachhap <amit.kachhap@arm.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Cc: Christoffer Dall <christoffer.dall@arm.com>
> Cc: kvmarm@lists.cs.columbia.edu
> ---
> This patch needs patch [1] by Dave Martin and adds feature to manage accessibility in a scalable way.
> 
> [1]: https://lore.kernel.org/linux-arm-kernel/1547757219-19439-13-git-send-email-Dave.Martin@arm.com/ 

FYI, check_present() has changed a bit in the SVE v5 series [2].

The precise interface is still under discussion, so please take a look
and feel free to comment.

You'll probably need to tweak some things so that the KVM_GET_REG_LIST
output is consistent with the set of regs that do/don't yield -ENOENT in
KVM_GET_ONE_REG/KVM_SET_ONE_REG.

See other patches in the series for examples of how I use the modified
interface.

[...]

> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index f7bcc60..c2f4974 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1005,8 +1005,13 @@ static bool trap_ptrauth(struct kvm_vcpu *vcpu,
>  	return false;
>  }
>  
> +static bool check_ptrauth(const struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd)
> +{
> +	return kvm_arm_vcpu_ptrauth_allowed(vcpu);
> +}
> +
>  #define __PTRAUTH_KEY(k)						\
> -	{ SYS_DESC(SYS_## k), trap_ptrauth, reset_unknown, k }
> +	{ SYS_DESC(SYS_## k), trap_ptrauth, reset_unknown, k , .check_present = check_ptrauth}

Cheers
---Dave


[2] [PATCH v5 12/26] KVM: arm64: Support runtime sysreg visibility filtering
https://lists.cs.columbia.edu/pipermail/kvmarm/2019-February/034671.html
