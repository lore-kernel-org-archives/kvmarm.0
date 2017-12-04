From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 3/3] arm64/sve: KVM: Avoid dereference of dead task during
 guest entry
Date: Mon, 4 Dec 2017 13:53:21 +0000
Message-ID: <CAKv+Gu_e3SKsreYHrZEBUMEME-pYtxTXW1P6xLUR6YMQfj0cZw@mail.gmail.com>
References: <1512141582-17474-1-git-send-email-Dave.Martin@arm.com>
 <1512141582-17474-4-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1512141582-17474-4-git-send-email-Dave.Martin@arm.com>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <christoffer.dall@linaro.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 1 December 2017 at 15:19, Dave Martin <Dave.Martin@arm.com> wrote:
> When deciding whether to invalidate FPSIMD state cached in the cpu,
> the backend function sve_flush_cpu_state() attempts to dereference
> __this_cpu_read(fpsimd_last_state).  However, this is not safe:
> there is no guarantee that the pointer is still valid, because the
> task could have exited in the meantime.  For this reason, this
> percpu pointer should only be assigned or compared, never
> dereferenced.
>

Doesn't that mean the pointer could also be pointing to the
fpsimd_state of a newly created task that is completely unrelated?
IOW, are you sure comparison is safe?

> This means that we need another means to get the appropriate value
> of TIF_SVE for the associated task.
>
> This patch solves this issue by adding a cached copy of the TIF_SVE
> flag in fpsimd_last_state, which we can check without dereferencing
> the task pointer.
>
> Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Cc: Christoffer Dall <christoffer.dall@linaro.org>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm64/kernel/fpsimd.c | 28 ++++++++++++++++------------
>  1 file changed, 16 insertions(+), 12 deletions(-)
>
> diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
> index 007140b..3dc8058 100644
> --- a/arch/arm64/kernel/fpsimd.c
> +++ b/arch/arm64/kernel/fpsimd.c
> @@ -114,7 +114,12 @@
>   *   returned from the 2nd syscall yet, TIF_FOREIGN_FPSTATE is still set so
>   *   whatever is in the FPSIMD registers is not saved to memory, but discarded.
>   */
> -static DEFINE_PER_CPU(struct fpsimd_state *, fpsimd_last_state);
> +struct fpsimd_last_state_struct {
> +       struct fpsimd_state *st;
> +       bool sve_in_use;
> +};
> +
> +static DEFINE_PER_CPU(struct fpsimd_last_state_struct, fpsimd_last_state);
>
>  /* Default VL for tasks that don't set it explicitly: */
>  static int sve_default_vl = -1;
> @@ -905,7 +910,7 @@ void fpsimd_thread_switch(struct task_struct *next)
>                  */
>                 struct fpsimd_state *st = &next->thread.fpsimd_state;
>
> -               if (__this_cpu_read(fpsimd_last_state) == st
> +               if (__this_cpu_read(fpsimd_last_state.st) == st
>                     && st->cpu == smp_processor_id())
>                         clear_tsk_thread_flag(next, TIF_FOREIGN_FPSTATE);
>                 else
> @@ -997,9 +1002,12 @@ void fpsimd_signal_preserve_current_state(void)
>   */
>  static void fpsimd_bind_to_cpu(void)
>  {
> +       struct fpsimd_last_state_struct *last =
> +               this_cpu_ptr(&fpsimd_last_state);
>         struct fpsimd_state *st = &current->thread.fpsimd_state;
>
> -       __this_cpu_write(fpsimd_last_state, st);
> +       last->st = st;
> +       last->sve_in_use = test_thread_flag(TIF_SVE);
>         st->cpu = smp_processor_id();
>  }
>
> @@ -1057,7 +1065,7 @@ void fpsimd_flush_task_state(struct task_struct *t)
>
>  static inline void fpsimd_flush_cpu_state(void)
>  {
> -       __this_cpu_write(fpsimd_last_state, NULL);
> +       __this_cpu_write(fpsimd_last_state.st, NULL);
>  }
>
>  /*
> @@ -1070,14 +1078,10 @@ static inline void fpsimd_flush_cpu_state(void)
>  #ifdef CONFIG_ARM64_SVE
>  void sve_flush_cpu_state(void)
>  {
> -       struct fpsimd_state *const fpstate = __this_cpu_read(fpsimd_last_state);
> -       struct task_struct *tsk;
> -
> -       if (!fpstate)
> -               return;
> +       struct fpsimd_last_state_struct const *last =
> +               this_cpu_ptr(&fpsimd_last_state);
>
> -       tsk = container_of(fpstate, struct task_struct, thread.fpsimd_state);
> -       if (test_tsk_thread_flag(tsk, TIF_SVE))
> +       if (last->st && last->sve_in_use)
>                 fpsimd_flush_cpu_state();
>  }
>  #endif /* CONFIG_ARM64_SVE */
> @@ -1272,7 +1276,7 @@ static inline void fpsimd_pm_init(void) { }
>  #ifdef CONFIG_HOTPLUG_CPU
>  static int fpsimd_cpu_dead(unsigned int cpu)
>  {
> -       per_cpu(fpsimd_last_state, cpu) = NULL;
> +       per_cpu(fpsimd_last_state.st, cpu) = NULL;
>         return 0;
>  }
>
> --
> 2.1.4
>
