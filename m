From: gengdongjiu <gengdongjiu@huawei.com>
Subject: =?gb2312?B?tPC4tDogW1BBVENIIHY0IDExLzEyXSBtbS9tZW1vcnktZmFpbHVyZTogaW5j?=
 =?gb2312?Q?rease_queued_recovery_work's_priority?=
Date: Sun, 20 May 2018 07:12:17 +0000
Message-ID: <0184EA26B2509940AA629AE1405DD7F201C714A0@DGGEMA503-MBX.china.huawei.com>
References: <20180516162829.14348-1-james.morse@arm.com>
 <20180516162829.14348-12-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20180516162829.14348-12-james.morse@arm.com>
Content-Language: zh-CN
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: James Morse <james.morse@arm.com>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Cc: "jonathan.zhang@cavium.com" <jonathan.zhang@cavium.com>, Rafael Wysocki <rjw@rjwysocki.net>, Tony Luck <tony.luck@intel.com>, "inux-mm@kvack.org" <inux-mm@kvack.org>, Xiexiuqi <xiexiuqi@huawei.com>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Tyler Baicar <tbaicar@codeaurora.org>, Will Deacon <will.deacon@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, Punit Agrawal <punit.agrawal@arm.com>, Borislav Petkov <bp@alien8.de>, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Len Brown <lenb@kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

> 
> arm64 can take an NMI-like error notification when user-space steps in some corrupt memory. APEI's GHES code will call
> memory_failure_queue() to schedule the recovery work. We then return to user-space, possibly taking the fault again.
> 
> Currently the arch code unconditionally signals user-space from this path, so we don't get stuck in this loop, but the affected process never
> benefits from memory_failure()s recovery work. To fix this we need to know the recovery work will run before we get back to user-space.
> 
> Increase the priority of the recovery work by scheduling it on the system_highpri_wq, then try to bump the current task off this CPU so that
> the recover work starts immediately.
> 
> Reported-by: Xie XiuQi <xiexiuqi@huawei.com>
> Signed-off-by: James Morse <james.morse@arm.com>
> Reviewed-by: Punit Agrawal <punit.agrawal@arm.com>
> Tested-by: Tyler Baicar <tbaicar@codeaurora.org>
> CC: Xie XiuQi <xiexiuqi@huawei.com>
> CC: gengdongjiu <gengdongjiu@huawei.com>

Tested-by: gengdongjiu <gengdongjiu@huawei.com>

> ---
>  mm/memory-failure.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c index 9d142b9b86dc..f0e69d7ac406 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -55,6 +55,7 @@
>  #include <linux/hugetlb.h>
>  #include <linux/memory_hotplug.h>
>  #include <linux/mm_inline.h>
> +#include <linux/preempt.h>
>  #include <linux/kfifo.h>
>  #include <linux/ratelimit.h>
>  #include "internal.h"
> @@ -1333,6 +1334,7 @@ static DEFINE_PER_CPU(struct memory_failure_cpu, memory_failure_cpu);
>   */
>  void memory_failure_queue(unsigned long pfn, int flags)  {
> +	int cpu = smp_processor_id();
>  	struct memory_failure_cpu *mf_cpu;
>  	unsigned long proc_flags;
>  	struct memory_failure_entry entry = {
> @@ -1342,11 +1344,14 @@ void memory_failure_queue(unsigned long pfn, int flags)
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
> +	} else {
>  		pr_err("Memory failure: buffer overflow when queuing memory failure at %#lx\n",
>  		       pfn);
> +	}
>  	spin_unlock_irqrestore(&mf_cpu->lock, proc_flags);
>  	put_cpu_var(memory_failure_cpu);
>  }
> --
> 2.16.2
