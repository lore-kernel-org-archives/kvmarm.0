From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v3 24/28] arm64/sve: KVM: Hide SVE from CPU features
 exposed to guests
Date: Wed, 11 Oct 2017 17:31:17 +0100
Message-ID: <ed1f4430-fb52-a6dc-9dc0-1201bc3cd06e@arm.com>
References: <1507660725-7986-1-git-send-email-Dave.Martin@arm.com>
 <1507660725-7986-25-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <1507660725-7986-25-git-send-email-Dave.Martin@arm.com>
Content-Language: en-GB
Sender: linux-arch-owner@vger.kernel.org
To: Dave Martin <Dave.Martin@arm.com>, linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Richard Sandiford <richard.sandiford@arm.com>, Okamoto Takayuki <tokamoto@jp.fujitsu.com>, kvmarm@lists.cs.columbia.edu, libc-alpha@sourceware.org, linux-arch@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

[+ Christoffer]

On 10/10/17 19:38, Dave Martin wrote:
> KVM guests cannot currently use SVE, because SVE is always
> configured to trap to EL2.
> 
> However, a guest that sees SVE reported as present in
> ID_AA64PFR0_EL1 may legitimately expect that SVE works and try to
> use it.  Instead of working, the guest will receive an injected
> undef exception, which may cause the guest to oops or go into a
> spin.
> 
> To avoid misleading the guest into believing that SVE will work,
> this patch masks out the SVE field from ID_AA64PFR0_EL1 when a
> guest attempts to read this register.  No support is explicitly
> added for ID_AA64ZFR0_EL1 either, so that is still emulated as
> reading as zero, which is consistent with SVE not being
> implemented.
> 
> This is a temporary measure, and will be removed in a later series
> when full KVM support for SVE is implemented.
> 
> Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> Reviewed-by: Alex Bennée <alex.bennee@linaro.org>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm64/kvm/sys_regs.c | 12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index b1f7552..a0ee9b0 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -23,6 +23,7 @@
>  #include <linux/bsearch.h>
>  #include <linux/kvm_host.h>
>  #include <linux/mm.h>
> +#include <linux/printk.h>
>  #include <linux/uaccess.h>
>  
>  #include <asm/cacheflush.h>
> @@ -897,8 +898,17 @@ static u64 read_id_reg(struct sys_reg_desc const *r, bool raz)
>  {
>  	u32 id = sys_reg((u32)r->Op0, (u32)r->Op1,
>  			 (u32)r->CRn, (u32)r->CRm, (u32)r->Op2);
> +	u64 val = raz ? 0 : read_sanitised_ftr_reg(id);
>  
> -	return raz ? 0 : read_sanitised_ftr_reg(id);
> +	if (id == SYS_ID_AA64PFR0_EL1) {
> +		if (val & (0xfUL << ID_AA64PFR0_SVE_SHIFT))
> +			pr_err_once("kvm [%i]: SVE unsupported for guests, suppressing\n",
> +				    task_pid_nr(current));
> +
> +		val &= ~(0xfUL << ID_AA64PFR0_SVE_SHIFT);
> +	}
> +
> +	return val;
>  }
>  
>  /* cpufeature ID register access trap handlers */
> 

Acked-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny...
