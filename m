From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH RFC 1/7] ARM64: KVM: Add the definition of ID registers
Date: Sat, 28 Jan 2017 13:07:15 +0100
Message-ID: <20170128120715.nq4bla5aumxxrkeo@hawk.localdomain>
References: <1484559214-2248-1-git-send-email-zhaoshenglong@huawei.com>
 <1484559214-2248-2-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9AC5940838
 for <kvmarm@lists.cs.columbia.edu>; Sat, 28 Jan 2017 07:07:07 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ryMWiKITd7y1 for <kvmarm@lists.cs.columbia.edu>;
 Sat, 28 Jan 2017 07:07:06 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 88F4540187
 for <kvmarm@lists.cs.columbia.edu>; Sat, 28 Jan 2017 07:07:06 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <1484559214-2248-2-git-send-email-zhaoshenglong@huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Shannon Zhao <zhaoshenglong@huawei.com>
Cc: marc.zyngier@arm.com, qemu-arm@nongnu.org, wu.wubin@huawei.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Jan 16, 2017 at 05:33:28PM +0800, Shannon Zhao wrote:
> From: Shannon Zhao <shannon.zhao@linaro.org>
> 
> Add a new memeber in kvm_cpu_context to save the ID registers value.

Currently all the sysregs that need to be save/restored are in a single
array, sys_regs. This commit message needs to provide the rationale for
introducing the id_sys_regs array. If there is no good reason, then the
ID registers should be integrated with the rest. Also, what about the
ARMv7/AArch32 equivalent registers?

Thanks,
drew

> 
> Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
> ---
>  arch/arm64/include/asm/kvm_host.h | 46 +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 46 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index e505038..6034f92 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -187,12 +187,57 @@ enum vcpu_sysreg {
>  
>  #define NR_COPRO_REGS	(NR_SYS_REGS * 2)
>  
> +enum id_vcpu_sysreg {
> +	MIDR_EL1,
> +	/* ID group 1 registers */
> +	REVIDR_EL1,
> +	AIDR_EL1,
> +
> +	/* ID group 2 registers */
> +	CTR_EL0,
> +	CCSIDR_EL1,
> +	CLIDR_EL1,
> +
> +	/* ID group 3 registers */
> +	ID_PFR0_EL1,
> +	ID_PFR1_EL1,
> +	ID_DFR0_EL1,
> +	ID_AFR0_EL1,
> +	ID_MMFR0_EL1,
> +	ID_MMFR1_EL1,
> +	ID_MMFR2_EL1,
> +	ID_MMFR3_EL1,
> +	ID_ISAR0_EL1,
> +	ID_ISAR1_EL1,
> +	ID_ISAR2_EL1,
> +	ID_ISAR3_EL1,
> +	ID_ISAR4_EL1,
> +	ID_ISAR5_EL1,
> +	MVFR0_EL1,
> +	MVFR1_EL1,
> +	MVFR2_EL1,
> +	ID_AA64PFR0_EL1,
> +	ID_AA64PFR1_EL1,
> +	ID_AA64DFR0_EL1,
> +	ID_AA64DFR1_EL1,
> +	ID_AA64ISAR0_EL1,
> +	ID_AA64ISAR1_EL1,
> +	ID_AA64MMFR0_EL1,
> +	ID_AA64MMFR1_EL1,
> +	ID_AA64AFR0_EL1,
> +	ID_AA64AFR1_EL1,
> +	ID_MMFR4_EL1,
> +
> +	NR_ID_SYS_REGS
> +};
> +
>  struct kvm_cpu_context {
>  	struct kvm_regs	gp_regs;
>  	union {
>  		u64 sys_regs[NR_SYS_REGS];
>  		u32 copro[NR_COPRO_REGS];
>  	};
> +	u64 id_sys_regs[NR_ID_SYS_REGS];
>  };
>  
>  typedef struct kvm_cpu_context kvm_cpu_context_t;
> @@ -277,6 +322,7 @@ struct kvm_vcpu_arch {
>  
>  #define vcpu_gp_regs(v)		(&(v)->arch.ctxt.gp_regs)
>  #define vcpu_sys_reg(v,r)	((v)->arch.ctxt.sys_regs[(r)])
> +#define vcpu_id_sys_reg(v,r)	((v)->arch.ctxt.id_sys_regs[(r)])
>  /*
>   * CP14 and CP15 live in the same array, as they are backed by the
>   * same system registers.
> -- 
> 2.0.4
> 
> 
