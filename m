From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [PATCH v2 03/11] KVM: arm: enable to use the ARM_DSCR_MDBGEN macro from KVM assembly code
Date: Tue, 09 Jun 2015 14:42:24 +0100
Message-ID: <87r3pl6lrz.fsf@linaro.org>
References: <1433046432-1824-1-git-send-email-zhichao.huang@linaro.org> <1433046432-1824-4-git-send-email-zhichao.huang@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
In-reply-to: <1433046432-1824-4-git-send-email-zhichao.huang@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Zhichao Huang <zhichao.huang@linaro.org>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com, will.deacon@arm.com, huangzhichao@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu


Zhichao Huang <zhichao.huang@linaro.org> writes:

> Add #ifndef __ASSEMBLY__ in hw_breakpoint.h, in order to use
> the ARM_DSCR_MDBGEN macro from KVM assembly code.
>
> Signed-off-by: Zhichao Huang <zhichao.huang@linaro.org>

Reviewed-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>

> ---
>  arch/arm/include/asm/hw_breakpoint.h | 54 +++++++++++++++++++-------=
----------
>  1 file changed, 29 insertions(+), 25 deletions(-)
>
> diff --git a/arch/arm/include/asm/hw_breakpoint.h b/arch/arm/include/=
asm/hw_breakpoint.h
> index 8e427c7..f2f4c61 100644
> --- a/arch/arm/include/asm/hw_breakpoint.h
> +++ b/arch/arm/include/asm/hw_breakpoint.h
> @@ -3,6 +3,8 @@
> =20
>  #ifdef __KERNEL__
> =20
> +#ifndef __ASSEMBLY__
> +
>  struct task_struct;
> =20
>  #ifdef CONFIG_HAVE_HW_BREAKPOINT
> @@ -44,6 +46,33 @@ static inline void decode_ctrl_reg(u32 reg,
>  	ctrl->mismatch	=3D reg & 0x1;
>  }
> =20
> +struct notifier_block;
> +struct perf_event;
> +struct pmu;
> +
> +extern struct pmu perf_ops_bp;
> +extern int arch_bp_generic_fields(struct arch_hw_breakpoint_ctrl ctr=
l,
> +				  int *gen_len, int *gen_type);
> +extern int arch_check_bp_in_kernelspace(struct perf_event *bp);
> +extern int arch_validate_hwbkpt_settings(struct perf_event *bp);
> +extern int hw_breakpoint_exceptions_notify(struct notifier_block *un=
used,
> +					   unsigned long val, void *data);
> +
> +extern u8 arch_get_debug_arch(void);
> +extern u8 arch_get_max_wp_len(void);
> +extern void clear_ptrace_hw_breakpoint(struct task_struct *tsk);
> +
> +int arch_install_hw_breakpoint(struct perf_event *bp);
> +void arch_uninstall_hw_breakpoint(struct perf_event *bp);
> +void hw_breakpoint_pmu_read(struct perf_event *bp);
> +int hw_breakpoint_slots(int type);
> +
> +#else
> +static inline void clear_ptrace_hw_breakpoint(struct task_struct *ts=
k) {}
> +
> +#endif	/* CONFIG_HAVE_HW_BREAKPOINT */
> +#endif  /* __ASSEMBLY */
> +
>  /* Debug architecture numbers. */
>  #define ARM_DEBUG_ARCH_RESERVED	0	/* In case of ptrace ABI updates. =
*/
>  #define ARM_DEBUG_ARCH_V6	1
> @@ -110,30 +139,5 @@ static inline void decode_ctrl_reg(u32 reg,
>  	asm volatile("mcr p14, 0, %0, " #N "," #M ", " #OP2 : : "r" (VAL));=
\
>  } while (0)
> =20
> -struct notifier_block;
> -struct perf_event;
> -struct pmu;
> -
> -extern struct pmu perf_ops_bp;
> -extern int arch_bp_generic_fields(struct arch_hw_breakpoint_ctrl ctr=
l,
> -				  int *gen_len, int *gen_type);
> -extern int arch_check_bp_in_kernelspace(struct perf_event *bp);
> -extern int arch_validate_hwbkpt_settings(struct perf_event *bp);
> -extern int hw_breakpoint_exceptions_notify(struct notifier_block *un=
used,
> -					   unsigned long val, void *data);
> -
> -extern u8 arch_get_debug_arch(void);
> -extern u8 arch_get_max_wp_len(void);
> -extern void clear_ptrace_hw_breakpoint(struct task_struct *tsk);
> -
> -int arch_install_hw_breakpoint(struct perf_event *bp);
> -void arch_uninstall_hw_breakpoint(struct perf_event *bp);
> -void hw_breakpoint_pmu_read(struct perf_event *bp);
> -int hw_breakpoint_slots(int type);
> -
> -#else
> -static inline void clear_ptrace_hw_breakpoint(struct task_struct *ts=
k) {}
> -
> -#endif	/* CONFIG_HAVE_HW_BREAKPOINT */
>  #endif	/* __KERNEL__ */
>  #endif	/* _ARM_HW_BREAKPOINT_H */

--=20
Alex Benn=C3=A9e
