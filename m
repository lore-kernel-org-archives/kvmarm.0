From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 2/3] arm64: fpsimd: Abstract out binding of task's fpsimd
 context to the cpu.
Date: Mon, 4 Dec 2017 13:46:57 +0000
Message-ID: <CAKv+Gu8BzFrc1U7r7iURfZqGKRqpwHJVFM6hvHOX5xghrXojtA@mail.gmail.com>
References: <1512141582-17474-1-git-send-email-Dave.Martin@arm.com>
 <1512141582-17474-3-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1512141582-17474-3-git-send-email-Dave.Martin@arm.com>
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
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 1 December 2017 at 15:19, Dave Martin <Dave.Martin@arm.com> wrote:
> There is currently some duplicate logic to associate current's
> FPSIMD context with the cpu when loading FPSIMD state into the cpu
> regs.
>
> Subsequent patches will update that logic, so in order to ensure it
> only needs to be done in one place, this patch factors the relevant
> code out into a new function fpsimd_bind_to_cpu().
>
> Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  arch/arm64/kernel/fpsimd.c | 25 +++++++++++++++----------
>  1 file changed, 15 insertions(+), 10 deletions(-)
>
> diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
> index 143b3e7..007140b 100644
> --- a/arch/arm64/kernel/fpsimd.c
> +++ b/arch/arm64/kernel/fpsimd.c
> @@ -992,6 +992,18 @@ void fpsimd_signal_preserve_current_state(void)
>  }
>
>  /*
> + * Associate current's FPSIMD context with this cpu
> + * Preemption must be disabled when calling this function.
> + */
> +static void fpsimd_bind_to_cpu(void)
> +{
> +       struct fpsimd_state *st = &current->thread.fpsimd_state;
> +
> +       __this_cpu_write(fpsimd_last_state, st);
> +       st->cpu = smp_processor_id();
> +}
> +
> +/*
>   * Load the userland FPSIMD state of 'current' from memory, but only if the
>   * FPSIMD state already held in the registers is /not/ the most recent FPSIMD
>   * state of 'current'
> @@ -1004,11 +1016,8 @@ void fpsimd_restore_current_state(void)
>         local_bh_disable();
>
>         if (test_and_clear_thread_flag(TIF_FOREIGN_FPSTATE)) {
> -               struct fpsimd_state *st = &current->thread.fpsimd_state;
> -
>                 task_fpsimd_load();
> -               __this_cpu_write(fpsimd_last_state, st);
> -               st->cpu = smp_processor_id();
> +               fpsimd_bind_to_cpu();
>         }
>
>         local_bh_enable();
> @@ -1032,12 +1041,8 @@ void fpsimd_update_current_state(struct fpsimd_state *state)
>         }
>         task_fpsimd_load();
>
> -       if (test_and_clear_thread_flag(TIF_FOREIGN_FPSTATE)) {
> -               struct fpsimd_state *st = &current->thread.fpsimd_state;
> -
> -               __this_cpu_write(fpsimd_last_state, st);
> -               st->cpu = smp_processor_id();
> -       }
> +       if (test_and_clear_thread_flag(TIF_FOREIGN_FPSTATE))
> +               fpsimd_bind_to_cpu();
>
>         local_bh_enable();
>  }

Reviewed-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
