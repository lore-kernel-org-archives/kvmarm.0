From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v6 17/18] mm/memory-failure: increase queued recovery
 work's priority
Date: Mon, 15 Oct 2018 18:49:13 +0200
Message-ID: <20181015164913.GE11434@zn.tnic>
References: <20180921221705.6478-1-james.morse@arm.com>
 <20180921221705.6478-18-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0E1174A211
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Oct 2018 12:49:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QfaFKZmXtjkl for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Oct 2018 12:49:31 -0400 (EDT)
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 14EA140493
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Oct 2018 12:49:31 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20180921221705.6478-18-james.morse@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: James Morse <james.morse@arm.com>, Peter Zijlstra <peterz@infradead.org>
Cc: jonathan.zhang@cavium.com, Rafael Wysocki <rjw@rjwysocki.net>, Tony Luck <tony.luck@intel.com>, linux-mm@kvack.org, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Tyler Baicar <tbaicar@codeaurora.org>, Will Deacon <will.deacon@arm.com>, Dongjiu Geng <gengdongjiu@huawei.com>, linux-acpi@vger.kernel.org, Punit Agrawal <punit.agrawal@arm.com>, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Len Brown <lenb@kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

+ Peter.

On Fri, Sep 21, 2018 at 11:17:04PM +0100, James Morse wrote:
> arm64 can take an NMI-like error notification when user-space steps in
> some corrupt memory. APEI's GHES code will call memory_failure_queue()
> to schedule the recovery work. We then return to user-space, possibly
> taking the fault again.
> 
> Currently the arch code unconditionally signals user-space from this
> path, so we don't get stuck in this loop, but the affected process
> never benefits from memory_failure()s recovery work. To fix this we
> need to know the recovery work will run before we get back to user-space.
> 
> Increase the priority of the recovery work by scheduling it on the
> system_highpri_wq, then try to bump the current task off this CPU
> so that the recovery work starts immediately.
> 
> Reported-by: Xie XiuQi <xiexiuqi@huawei.com>
> Signed-off-by: James Morse <james.morse@arm.com>
> Reviewed-by: Punit Agrawal <punit.agrawal@arm.com>
> Tested-by: Tyler Baicar <tbaicar@codeaurora.org>
> Tested-by: gengdongjiu <gengdongjiu@huawei.com>
> CC: Xie XiuQi <xiexiuqi@huawei.com>
> CC: gengdongjiu <gengdongjiu@huawei.com>
> ---
>  mm/memory-failure.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index 0cd3de3550f0..4e7b115cea5a 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -56,6 +56,7 @@
>  #include <linux/memory_hotplug.h>
>  #include <linux/mm_inline.h>
>  #include <linux/memremap.h>
> +#include <linux/preempt.h>
>  #include <linux/kfifo.h>
>  #include <linux/ratelimit.h>
>  #include <linux/page-isolation.h>
> @@ -1454,6 +1455,7 @@ static DEFINE_PER_CPU(struct memory_failure_cpu, memory_failure_cpu);
>   */
>  void memory_failure_queue(unsigned long pfn, int flags)
>  {
> +	int cpu = smp_processor_id();
>  	struct memory_failure_cpu *mf_cpu;
>  	unsigned long proc_flags;
>  	struct memory_failure_entry entry = {
> @@ -1463,11 +1465,14 @@ void memory_failure_queue(unsigned long pfn, int flags)
>  
>  	mf_cpu = &get_cpu_var(memory_failure_cpu);
>  	spin_lock_irqsave(&mf_cpu->lock, proc_flags);
> -	if (kfifo_put(&mf_cpu->fifo, entry))
> -		schedule_work_on(smp_processor_id(), &mf_cpu->work);
> -	else
> +	if (kfifo_put(&mf_cpu->fifo, entry)) {
> +		queue_work_on(cpu, system_highpri_wq, &mf_cpu->work);
> +		set_tsk_need_resched(current);
> +		preempt_set_need_resched();

What guarantees the workqueue would run before the process? I see this:

``WQ_HIGHPRI``
  Work items of a highpri wq are queued to the highpri
  worker-pool of the target cpu.  Highpri worker-pools are
  served by worker threads with elevated nice level.

but is that enough?

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
