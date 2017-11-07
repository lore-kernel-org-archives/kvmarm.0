From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [PATCH v5 15/30] arm64/sve: Signal handling support
Date: Tue, 07 Nov 2017 13:22:33 +0000
Message-ID: <87vaimql46.fsf@linaro.org>
References: <1509465082-30427-1-git-send-email-Dave.Martin@arm.com> <1509465082-30427-16-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-arch-owner@vger.kernel.org>
In-reply-to: <1509465082-30427-16-git-send-email-Dave.Martin@arm.com>
Sender: linux-arch-owner@vger.kernel.org
To: Dave Martin <Dave.Martin@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Okamoto Takayuki <tokamoto@jp.fujitsu.com>, kvmarm@lists.cs.columbia.edu, libc-alpha@sourceware.org, linux-arch@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu


Dave Martin <Dave.Martin@arm.com> writes:

> This patch implements support for saving and restoring the SVE
> registers around signals.
>
> A fixed-size header struct sve_context is always included in the
> signal frame encoding the thread's vector length at the time of
> signal delivery, optionally followed by a variable-layout structure
> encoding the SVE registers.
>
> Because of the need to preserve backwards compatibility, the FPSIMD
> view of the SVE registers is always dumped as a struct
> fpsimd_context in the usual way, in addition to any sve_context.
>
> The SVE vector registers are dumped in full, including bits 127:0
> of each register which alias the corresponding FPSIMD vector
> registers in the hardware.  To avoid any ambiguity about which
> alias to restore during sigreturn, the kernel always restores bits
> 127:0 of each SVE vector register from the fpsimd_context in the
> signal frame (which must be present): userspace needs to take this
> into account if it wants to modify the SVE vector register contents
> on return from a signal.
>
> FPSR and FPCR, which are used by both FPSIMD and SVE, are not
> included in sve_context because they are always present in
> fpsimd_context anyway.
>
> For signal delivery, a new helper
> fpsimd_signal_preserve_current_state() is added to update _both_
> the FPSIMD and SVE views in the task struct, to make it easier to
> populate this information into the signal frame.  Because of the
> redundancy between the two views of the state, only one is updated
> otherwise.
>
> Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> Cc: Alex Benn=C3=A9e <alex.bennee@linaro.org>
> Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Cc: Will Deacon <will.deacon@arm.com>

After adding SVE support for RISU I was able to confirm consistent
signal delivery with a decent context over multiple runs and after
hacking echo "32" > /proc/sys/abi/sve_default_vector_length to change
the default length the tests would fail (as expected).

Tested-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>

>
> ---
>
> **Dropped** Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
> (Non-trivial changes.)
>
> Changes since v4
> ----------------
>
> Requested by Will Deacon:
>
>  * Fix inconsistent return semantics in restore_sve_fpsimd_context().
>
>    Currently a nonzero return value from __copy_from_user() is passed
>    back as-is to the caller or restore_sve_fpsimd_context(), rather than
>    translating it do an error code as is done elsewhere.
>
>    Callers of restore_sve_fpsimd_context() only care whether the return
>    value is 0 or not, so this isn't a big deal, but it is more
>    consistent to return proper error codes on failure in case we grow a
>    use for them later.
>
>    This patch returns -EFAULT in the __copy_from_user() error cases
>    that weren't explicitly handled.
>
> Miscellaneous:
>
>  * Change inconsistent copy_to_user() calls to __copy_to_user() in
>    preserve_sve_context().
>
>    There are already __put_user_error() calls here.
>
>    The whole extended signal frame is already checked for
>    access_ok(VERIFY_WRITE) in get_sigframe().
> ---
>  arch/arm64/include/asm/fpsimd.h |   1 +
>  arch/arm64/kernel/fpsimd.c      |  55 ++++++++++---
>  arch/arm64/kernel/signal.c      | 167 ++++++++++++++++++++++++++++++++++=
++++--
>  arch/arm64/kernel/signal32.c    |   2 +-
>  4 files changed, 206 insertions(+), 19 deletions(-)
>
> diff --git a/arch/arm64/include/asm/fpsimd.h b/arch/arm64/include/asm/fps=
imd.h
> index 5655fe1..9bbd74c 100644
> --- a/arch/arm64/include/asm/fpsimd.h
> +++ b/arch/arm64/include/asm/fpsimd.h
> @@ -63,6 +63,7 @@ extern void fpsimd_load_state(struct fpsimd_state *stat=
e);
>  extern void fpsimd_thread_switch(struct task_struct *next);
>  extern void fpsimd_flush_thread(void);
>
> +extern void fpsimd_signal_preserve_current_state(void);
>  extern void fpsimd_preserve_current_state(void);
>  extern void fpsimd_restore_current_state(void);
>  extern void fpsimd_update_current_state(struct fpsimd_state *state);
> diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
> index c91be8e..e0b5ef5 100644
> --- a/arch/arm64/kernel/fpsimd.c
> +++ b/arch/arm64/kernel/fpsimd.c
> @@ -299,6 +299,32 @@ static void fpsimd_to_sve(struct task_struct *task)
>  		       sizeof(fst->vregs[i]));
>  }
>
> +/*
> + * Transfer the SVE state in task->thread.sve_state to
> + * task->thread.fpsimd_state.
> + *
> + * Task can be a non-runnable task, or current.  In the latter case,
> + * softirqs (and preemption) must be disabled.
> + * task->thread.sve_state must point to at least sve_state_size(task)
> + * bytes of allocated kernel memory.
> + * task->thread.sve_state must be up to date before calling this functio=
n.
> + */
> +static void sve_to_fpsimd(struct task_struct *task)
> +{
> +	unsigned int vq;
> +	void const *sst =3D task->thread.sve_state;
> +	struct fpsimd_state *fst =3D &task->thread.fpsimd_state;
> +	unsigned int i;
> +
> +	if (!system_supports_sve())
> +		return;
> +
> +	vq =3D sve_vq_from_vl(task->thread.sve_vl);
> +	for (i =3D 0; i < 32; ++i)
> +		memcpy(&fst->vregs[i], ZREG(sst, vq, i),
> +		       sizeof(fst->vregs[i]));
> +}
> +
>  #ifdef CONFIG_ARM64_SVE
>
>  /*
> @@ -500,9 +526,6 @@ void fpsimd_flush_thread(void)
>  /*
>   * Save the userland FPSIMD state of 'current' to memory, but only if th=
e state
>   * currently held in the registers does in fact belong to 'current'
> - *
> - * Currently, SVE tasks can't exist, so just WARN in that case.
> - * Subsequent patches will add full SVE support here.
>   */
>  void fpsimd_preserve_current_state(void)
>  {
> @@ -510,16 +533,23 @@ void fpsimd_preserve_current_state(void)
>  		return;
>
>  	local_bh_disable();
> -
> -	if (!test_thread_flag(TIF_FOREIGN_FPSTATE))
> -		fpsimd_save_state(&current->thread.fpsimd_state);
> -
> -	WARN_ON_ONCE(test_and_clear_thread_flag(TIF_SVE));
> -
> +	task_fpsimd_save();
>  	local_bh_enable();
>  }
>
>  /*
> + * Like fpsimd_preserve_current_state(), but ensure that
> + * current->thread.fpsimd_state is updated so that it can be copied to
> + * the signal frame.
> + */
> +void fpsimd_signal_preserve_current_state(void)
> +{
> +	fpsimd_preserve_current_state();
> +	if (system_supports_sve() && test_thread_flag(TIF_SVE))
> +		sve_to_fpsimd(current);
> +}
> +
> +/*
>   * Load the userland FPSIMD state of 'current' from memory, but only if =
the
>   * FPSIMD state already held in the registers is /not/ the most recent F=
PSIMD
>   * state of 'current'
> @@ -554,7 +584,12 @@ void fpsimd_update_current_state(struct fpsimd_state=
 *state)
>
>  	local_bh_disable();
>
> -	fpsimd_load_state(state);
> +	if (system_supports_sve() && test_thread_flag(TIF_SVE)) {
> +		current->thread.fpsimd_state =3D *state;
> +		fpsimd_to_sve(current);
> +	}
> +	task_fpsimd_load();
> +
>  	if (test_and_clear_thread_flag(TIF_FOREIGN_FPSTATE)) {
>  		struct fpsimd_state *st =3D &current->thread.fpsimd_state;
>
> diff --git a/arch/arm64/kernel/signal.c b/arch/arm64/kernel/signal.c
> index 4716729..64abf88 100644
> --- a/arch/arm64/kernel/signal.c
> +++ b/arch/arm64/kernel/signal.c
> @@ -63,6 +63,7 @@ struct rt_sigframe_user_layout {
>
>  	unsigned long fpsimd_offset;
>  	unsigned long esr_offset;
> +	unsigned long sve_offset;
>  	unsigned long extra_offset;
>  	unsigned long end_offset;
>  };
> @@ -179,9 +180,6 @@ static int preserve_fpsimd_context(struct fpsimd_cont=
ext __user *ctx)
>  	struct fpsimd_state *fpsimd =3D &current->thread.fpsimd_state;
>  	int err;
>
> -	/* dump the hardware registers to the fpsimd_state structure */
> -	fpsimd_preserve_current_state();
> -
>  	/* copy the FP and status/control registers */
>  	err =3D __copy_to_user(ctx->vregs, fpsimd->vregs, sizeof(fpsimd->vregs)=
);
>  	__put_user_error(fpsimd->fpsr, &ctx->fpsr, err);
> @@ -214,6 +212,8 @@ static int restore_fpsimd_context(struct fpsimd_conte=
xt __user *ctx)
>  	__get_user_error(fpsimd.fpsr, &ctx->fpsr, err);
>  	__get_user_error(fpsimd.fpcr, &ctx->fpcr, err);
>
> +	clear_thread_flag(TIF_SVE);
> +
>  	/* load the hardware registers from the fpsimd_state structure */
>  	if (!err)
>  		fpsimd_update_current_state(&fpsimd);
> @@ -221,10 +221,118 @@ static int restore_fpsimd_context(struct fpsimd_co=
ntext __user *ctx)
>  	return err ? -EFAULT : 0;
>  }
>
> +
>  struct user_ctxs {
>  	struct fpsimd_context __user *fpsimd;
> +	struct sve_context __user *sve;
>  };
>
> +#ifdef CONFIG_ARM64_SVE
> +
> +static int preserve_sve_context(struct sve_context __user *ctx)
> +{
> +	int err =3D 0;
> +	u16 reserved[ARRAY_SIZE(ctx->__reserved)];
> +	unsigned int vl =3D current->thread.sve_vl;
> +	unsigned int vq =3D 0;
> +
> +	if (test_thread_flag(TIF_SVE))
> +		vq =3D sve_vq_from_vl(vl);
> +
> +	memset(reserved, 0, sizeof(reserved));
> +
> +	__put_user_error(SVE_MAGIC, &ctx->head.magic, err);
> +	__put_user_error(round_up(SVE_SIG_CONTEXT_SIZE(vq), 16),
> +			 &ctx->head.size, err);
> +	__put_user_error(vl, &ctx->vl, err);
> +	BUILD_BUG_ON(sizeof(ctx->__reserved) !=3D sizeof(reserved));
> +	err |=3D __copy_to_user(&ctx->__reserved, reserved, sizeof(reserved));
> +
> +	if (vq) {
> +		/*
> +		 * This assumes that the SVE state has already been saved to
> +		 * the task struct by calling preserve_fpsimd_context().
> +		 */
> +		err |=3D __copy_to_user((char __user *)ctx + SVE_SIG_REGS_OFFSET,
> +				      current->thread.sve_state,
> +				      SVE_SIG_REGS_SIZE(vq));
> +	}
> +
> +	return err ? -EFAULT : 0;
> +}
> +
> +static int restore_sve_fpsimd_context(struct user_ctxs *user)
> +{
> +	int err;
> +	unsigned int vq;
> +	struct fpsimd_state fpsimd;
> +	struct sve_context sve;
> +
> +	if (__copy_from_user(&sve, user->sve, sizeof(sve)))
> +		return -EFAULT;
> +
> +	if (sve.vl !=3D current->thread.sve_vl)
> +		return -EINVAL;
> +
> +	if (sve.head.size <=3D sizeof(*user->sve)) {
> +		clear_thread_flag(TIF_SVE);
> +		goto fpsimd_only;
> +	}
> +
> +	vq =3D sve_vq_from_vl(sve.vl);
> +
> +	if (sve.head.size < SVE_SIG_CONTEXT_SIZE(vq))
> +		return -EINVAL;
> +
> +	/*
> +	 * Careful: we are about __copy_from_user() directly into
> +	 * thread.sve_state with preemption enabled, so protection is
> +	 * needed to prevent a racing context switch from writing stale
> +	 * registers back over the new data.
> +	 */
> +
> +	fpsimd_flush_task_state(current);
> +	barrier();
> +	/* From now, fpsimd_thread_switch() won't clear TIF_FOREIGN_FPSTATE */
> +
> +	set_thread_flag(TIF_FOREIGN_FPSTATE);
> +	barrier();
> +	/* From now, fpsimd_thread_switch() won't touch thread.sve_state */
> +
> +	sve_alloc(current);
> +	err =3D __copy_from_user(current->thread.sve_state,
> +			       (char __user const *)user->sve +
> +					SVE_SIG_REGS_OFFSET,
> +			       SVE_SIG_REGS_SIZE(vq));
> +	if (err)
> +		return -EFAULT;
> +
> +	set_thread_flag(TIF_SVE);
> +
> +fpsimd_only:
> +	/* copy the FP and status/control registers */
> +	/* restore_sigframe() already checked that user->fpsimd !=3D NULL. */
> +	err =3D __copy_from_user(fpsimd.vregs, user->fpsimd->vregs,
> +			       sizeof(fpsimd.vregs));
> +	__get_user_error(fpsimd.fpsr, &user->fpsimd->fpsr, err);
> +	__get_user_error(fpsimd.fpcr, &user->fpsimd->fpcr, err);
> +
> +	/* load the hardware registers from the fpsimd_state structure */
> +	if (!err)
> +		fpsimd_update_current_state(&fpsimd);
> +
> +	return err ? -EFAULT : 0;
> +}
> +
> +#else /* ! CONFIG_ARM64_SVE */
> +
> +/* Turn any non-optimised out attempts to use these into a link error: */
> +extern int preserve_sve_context(void __user *ctx);
> +extern int restore_sve_fpsimd_context(struct user_ctxs *user);
> +
> +#endif /* ! CONFIG_ARM64_SVE */
> +
> +
>  static int parse_user_sigframe(struct user_ctxs *user,
>  			       struct rt_sigframe __user *sf)
>  {
> @@ -237,6 +345,7 @@ static int parse_user_sigframe(struct user_ctxs *user,
>  	char const __user *const sfp =3D (char const __user *)sf;
>
>  	user->fpsimd =3D NULL;
> +	user->sve =3D NULL;
>
>  	if (!IS_ALIGNED((unsigned long)base, 16))
>  		goto invalid;
> @@ -287,6 +396,19 @@ static int parse_user_sigframe(struct user_ctxs *use=
r,
>  			/* ignore */
>  			break;
>
> +		case SVE_MAGIC:
> +			if (!system_supports_sve())
> +				goto invalid;
> +
> +			if (user->sve)
> +				goto invalid;
> +
> +			if (size < sizeof(*user->sve))
> +				goto invalid;
> +
> +			user->sve =3D (struct sve_context __user *)head;
> +			break;
> +
>  		case EXTRA_MAGIC:
>  			if (have_extra_context)
>  				goto invalid;
> @@ -363,9 +485,6 @@ static int parse_user_sigframe(struct user_ctxs *user,
>  	}
>
>  done:
> -	if (!user->fpsimd)
> -		goto invalid;
> -
>  	return 0;
>
>  invalid:
> @@ -399,8 +518,19 @@ static int restore_sigframe(struct pt_regs *regs,
>  	if (err =3D=3D 0)
>  		err =3D parse_user_sigframe(&user, sf);
>
> -	if (err =3D=3D 0)
> -		err =3D restore_fpsimd_context(user.fpsimd);
> +	if (err =3D=3D 0) {
> +		if (!user.fpsimd)
> +			return -EINVAL;
> +
> +		if (user.sve) {
> +			if (!system_supports_sve())
> +				return -EINVAL;
> +
> +			err =3D restore_sve_fpsimd_context(&user);
> +		} else {
> +			err =3D restore_fpsimd_context(user.fpsimd);
> +		}
> +	}
>
>  	return err;
>  }
> @@ -459,6 +589,18 @@ static int setup_sigframe_layout(struct rt_sigframe_=
user_layout *user)
>  			return err;
>  	}
>
> +	if (system_supports_sve()) {
> +		unsigned int vq =3D 0;
> +
> +		if (test_thread_flag(TIF_SVE))
> +			vq =3D sve_vq_from_vl(current->thread.sve_vl);
> +
> +		err =3D sigframe_alloc(user, &user->sve_offset,
> +				     SVE_SIG_CONTEXT_SIZE(vq));
> +		if (err)
> +			return err;
> +	}
> +
>  	return sigframe_alloc_end(user);
>  }
>
> @@ -500,6 +642,13 @@ static int setup_sigframe(struct rt_sigframe_user_la=
yout *user,
>  		__put_user_error(current->thread.fault_code, &esr_ctx->esr, err);
>  	}
>
> +	/* Scalable Vector Extension state, if present */
> +	if (system_supports_sve() && err =3D=3D 0 && user->sve_offset) {
> +		struct sve_context __user *sve_ctx =3D
> +			apply_user_offset(user, user->sve_offset);
> +		err |=3D preserve_sve_context(sve_ctx);
> +	}
> +
>  	if (err =3D=3D 0 && user->extra_offset) {
>  		char __user *sfp =3D (char __user *)user->sigframe;
>  		char __user *userp =3D
> @@ -599,6 +748,8 @@ static int setup_rt_frame(int usig, struct ksignal *k=
sig, sigset_t *set,
>  	struct rt_sigframe __user *frame;
>  	int err =3D 0;
>
> +	fpsimd_signal_preserve_current_state();
> +
>  	if (get_sigframe(&user, ksig, regs))
>  		return 1;
>
> diff --git a/arch/arm64/kernel/signal32.c b/arch/arm64/kernel/signal32.c
> index e09bf5d..22711ee 100644
> --- a/arch/arm64/kernel/signal32.c
> +++ b/arch/arm64/kernel/signal32.c
> @@ -239,7 +239,7 @@ static int compat_preserve_vfp_context(struct compat_=
vfp_sigframe __user *frame)
>  	 * Note that this also saves V16-31, which aren't visible
>  	 * in AArch32.
>  	 */
> -	fpsimd_preserve_current_state();
> +	fpsimd_signal_preserve_current_state();
>
>  	/* Place structure header on the stack */
>  	__put_user_error(magic, &frame->magic, err);
