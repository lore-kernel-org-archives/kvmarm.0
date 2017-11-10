From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [PATCH v5 16/30] arm64/sve: Backend logic for setting the vector length
Date: Fri, 10 Nov 2017 10:27:36 +0000
Message-ID: <8760aiqvhj.fsf@linaro.org>
References: <1509465082-30427-1-git-send-email-Dave.Martin@arm.com> <1509465082-30427-17-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-arch-owner@vger.kernel.org>
In-reply-to: <1509465082-30427-17-git-send-email-Dave.Martin@arm.com>
Sender: linux-arch-owner@vger.kernel.org
To: Dave Martin <Dave.Martin@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Okamoto Takayuki <tokamoto@jp.fujitsu.com>, kvmarm@lists.cs.columbia.edu, libc-alpha@sourceware.org, linux-arch@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu


Dave Martin <Dave.Martin@arm.com> writes:

> This patch implements the core logic for changing a task's vector
> length on request from userspace.  This will be used by the ptrace
> and prctl frontends that are implemented in later patches.
>
> The SVE architecture permits, but does not require, implementations
> to support vector lengths that are not a power of two.  To handle
> this, logic is added to check a requested vector length against a
> possibly sparse bitmap of available vector lengths at runtime, so
> that the best supported value can be chosen.
>
> Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Alex Benn=C3=A9e <alex.bennee@linaro.org>

Reviewed-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>

> ---
>  arch/arm64/include/asm/fpsimd.h |   8 +++
>  arch/arm64/kernel/fpsimd.c      | 137 ++++++++++++++++++++++++++++++++++=
+++++-
>  include/uapi/linux/prctl.h      |   5 ++
>  3 files changed, 149 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm64/include/asm/fpsimd.h b/arch/arm64/include/asm/fps=
imd.h
> index 9bbd74c..86f550c 100644
> --- a/arch/arm64/include/asm/fpsimd.h
> +++ b/arch/arm64/include/asm/fpsimd.h
> @@ -20,6 +20,7 @@
>
>  #ifndef __ASSEMBLY__
>
> +#include <linux/cache.h>
>  #include <linux/stddef.h>
>
>  /*
> @@ -70,17 +71,24 @@ extern void fpsimd_update_current_state(struct fpsimd=
_state *state);
>
>  extern void fpsimd_flush_task_state(struct task_struct *target);
>
> +/* Maximum VL that SVE VL-agnostic software can transparently support */
> +#define SVE_VL_ARCH_MAX 0x100
> +
>  extern void sve_save_state(void *state, u32 *pfpsr);
>  extern void sve_load_state(void const *state, u32 const *pfpsr,
>  			   unsigned long vq_minus_1);
>  extern unsigned int sve_get_vl(void);
>
> +extern int __ro_after_init sve_max_vl;
> +
>  #ifdef CONFIG_ARM64_SVE
>
>  extern size_t sve_state_size(struct task_struct const *task);
>
>  extern void sve_alloc(struct task_struct *task);
>  extern void fpsimd_release_task(struct task_struct *task);
> +extern int sve_set_vector_length(struct task_struct *task,
> +				 unsigned long vl, unsigned long flags);
>
>  #else /* ! CONFIG_ARM64_SVE */
>
> diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
> index e0b5ef5..1ceb069 100644
> --- a/arch/arm64/kernel/fpsimd.c
> +++ b/arch/arm64/kernel/fpsimd.c
> @@ -17,8 +17,10 @@
>   * along with this program.  If not, see <http://www.gnu.org/licenses/>.
>   */
>
> +#include <linux/bitmap.h>
>  #include <linux/bottom_half.h>
>  #include <linux/bug.h>
> +#include <linux/cache.h>
>  #include <linux/compat.h>
>  #include <linux/cpu.h>
>  #include <linux/cpu_pm.h>
> @@ -28,6 +30,7 @@
>  #include <linux/init.h>
>  #include <linux/percpu.h>
>  #include <linux/preempt.h>
> +#include <linux/prctl.h>
>  #include <linux/ptrace.h>
>  #include <linux/sched/signal.h>
>  #include <linux/signal.h>
> @@ -113,6 +116,20 @@ static DEFINE_PER_CPU(struct fpsimd_state *, fpsimd_=
last_state);
>  /* Default VL for tasks that don't set it explicitly: */
>  static int sve_default_vl =3D SVE_VL_MIN;
>
> +#ifdef CONFIG_ARM64_SVE
> +
> +/* Maximum supported vector length across all CPUs (initially poisoned) =
*/
> +int __ro_after_init sve_max_vl =3D -1;
> +/* Set of available vector lengths, as vq_to_bit(vq): */
> +static DECLARE_BITMAP(sve_vq_map, SVE_VQ_MAX);
> +
> +#else /* ! CONFIG_ARM64_SVE */
> +
> +/* Dummy declaration for code that will be optimised out: */
> +extern DECLARE_BITMAP(sve_vq_map, SVE_VQ_MAX);
> +
> +#endif /* ! CONFIG_ARM64_SVE */
> +
>  /*
>   * Call __sve_free() directly only if you know task can't be scheduled
>   * or preempted.
> @@ -270,6 +287,50 @@ static void task_fpsimd_save(void)
>  	}
>  }
>
> +/*
> + * Helpers to translate bit indices in sve_vq_map to VQ values (and
> + * vice versa).  This allows find_next_bit() to be used to find the
> + * _maximum_ VQ not exceeding a certain value.
> + */
> +
> +static unsigned int vq_to_bit(unsigned int vq)
> +{
> +	return SVE_VQ_MAX - vq;
> +}
> +
> +static unsigned int bit_to_vq(unsigned int bit)
> +{
> +	if (WARN_ON(bit >=3D SVE_VQ_MAX))
> +		bit =3D SVE_VQ_MAX - 1;
> +
> +	return SVE_VQ_MAX - bit;
> +}
> +
> +/*
> + * All vector length selection from userspace comes through here.
> + * We're on a slow path, so some sanity-checks are included.
> + * If things go wrong there's a bug somewhere, but try to fall back to a
> + * safe choice.
> + */
> +static unsigned int find_supported_vector_length(unsigned int vl)
> +{
> +	int bit;
> +	int max_vl =3D sve_max_vl;
> +
> +	if (WARN_ON(!sve_vl_valid(vl)))
> +		vl =3D SVE_VL_MIN;
> +
> +	if (WARN_ON(!sve_vl_valid(max_vl)))
> +		max_vl =3D SVE_VL_MIN;
> +
> +	if (vl > max_vl)
> +		vl =3D max_vl;
> +
> +	bit =3D find_next_bit(sve_vq_map, SVE_VQ_MAX,
> +			    vq_to_bit(sve_vq_from_vl(vl)));
> +	return sve_vl_from_vq(bit_to_vq(bit));
> +}
> +
>  #define ZREG(sve_state, vq, n) ((char *)(sve_state) +		\
>  	(SVE_SIG_ZREG_OFFSET(vq, n) - SVE_SIG_REGS_OFFSET))
>
> @@ -364,6 +425,76 @@ void sve_alloc(struct task_struct *task)
>  	BUG_ON(!task->thread.sve_state);
>  }
>
> +int sve_set_vector_length(struct task_struct *task,
> +			  unsigned long vl, unsigned long flags)
> +{
> +	if (flags & ~(unsigned long)(PR_SVE_VL_INHERIT |
> +				     PR_SVE_SET_VL_ONEXEC))
> +		return -EINVAL;
> +
> +	if (!sve_vl_valid(vl))
> +		return -EINVAL;
> +
> +	/*
> +	 * Clamp to the maximum vector length that VL-agnostic SVE code can
> +	 * work with.  A flag may be assigned in the future to allow setting
> +	 * of larger vector lengths without confusing older software.
> +	 */
> +	if (vl > SVE_VL_ARCH_MAX)
> +		vl =3D SVE_VL_ARCH_MAX;
> +
> +	vl =3D find_supported_vector_length(vl);
> +
> +	if (flags & (PR_SVE_VL_INHERIT |
> +		     PR_SVE_SET_VL_ONEXEC))
> +		task->thread.sve_vl_onexec =3D vl;
> +	else
> +		/* Reset VL to system default on next exec: */
> +		task->thread.sve_vl_onexec =3D 0;
> +
> +	/* Only actually set the VL if not deferred: */
> +	if (flags & PR_SVE_SET_VL_ONEXEC)
> +		goto out;
> +
> +	if (vl =3D=3D task->thread.sve_vl)
> +		goto out;
> +
> +	/*
> +	 * To ensure the FPSIMD bits of the SVE vector registers are preserved,
> +	 * write any live register state back to task_struct, and convert to a
> +	 * non-SVE thread.
> +	 */
> +	if (task =3D=3D current) {
> +		local_bh_disable();
> +
> +		task_fpsimd_save();
> +		set_thread_flag(TIF_FOREIGN_FPSTATE);
> +	}
> +
> +	fpsimd_flush_task_state(task);
> +	if (test_and_clear_tsk_thread_flag(task, TIF_SVE))
> +		sve_to_fpsimd(task);
> +
> +	if (task =3D=3D current)
> +		local_bh_enable();
> +
> +	/*
> +	 * Force reallocation of task SVE state to the correct size
> +	 * on next use:
> +	 */
> +	sve_free(task);
> +
> +	task->thread.sve_vl =3D vl;
> +
> +out:
> +	if (flags & PR_SVE_VL_INHERIT)
> +		set_tsk_thread_flag(task, TIF_SVE_VL_INHERIT);
> +	else
> +		clear_tsk_thread_flag(task, TIF_SVE_VL_INHERIT);
> +
> +	return 0;
> +}
> +
>  /*
>   * Called from the put_task_struct() path, which cannot get here
>   * unless dead_task is really dead and not schedulable.
> @@ -480,7 +611,7 @@ void fpsimd_thread_switch(struct task_struct *next)
>
>  void fpsimd_flush_thread(void)
>  {
> -	int vl;
> +	int vl, supported_vl;
>
>  	if (!system_supports_fpsimd())
>  		return;
> @@ -508,6 +639,10 @@ void fpsimd_flush_thread(void)
>  		if (WARN_ON(!sve_vl_valid(vl)))
>  			vl =3D SVE_VL_MIN;
>
> +		supported_vl =3D find_supported_vector_length(vl);
> +		if (WARN_ON(supported_vl !=3D vl))
> +			vl =3D supported_vl;
> +
>  		current->thread.sve_vl =3D vl;
>
>  		/*
> diff --git a/include/uapi/linux/prctl.h b/include/uapi/linux/prctl.h
> index a8d0759..1b64901 100644
> --- a/include/uapi/linux/prctl.h
> +++ b/include/uapi/linux/prctl.h
> @@ -197,4 +197,9 @@ struct prctl_mm_map {
>  # define PR_CAP_AMBIENT_LOWER		3
>  # define PR_CAP_AMBIENT_CLEAR_ALL	4
>
> +/* arm64 Scalable Vector Extension controls */
> +# define PR_SVE_SET_VL_ONEXEC		(1 << 18) /* defer effect until exec */
> +# define PR_SVE_VL_LEN_MASK		0xffff
> +# define PR_SVE_VL_INHERIT		(1 << 17) /* inherit across exec */
> +
>  #endif /* _LINUX_PRCTL_H */
