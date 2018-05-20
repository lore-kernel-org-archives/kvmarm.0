From: gengdongjiu <gengdongjiu@huawei.com>
Subject: =?gb2312?B?tPC4tDogW1BBVENIIHY0IDExLzEyXSBtbS9tZW1vcnktZmFpbHVyZTogaW5j?=
 =?gb2312?Q?rease_queued_recovery_work's_priority?=
Date: Sun, 20 May 2018 07:13:40 +0000
Message-ID: <0184EA26B2509940AA629AE1405DD7F201C714B6@DGGEMA503-MBX.china.huawei.com>
References: <20180516162829.14348-1-james.morse@arm.com>
 <20180516162829.14348-12-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3BB194A0E9
 for <kvmarm@lists.cs.columbia.edu>; Sun, 20 May 2018 03:03:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3A1SwOXCmKQD for <kvmarm@lists.cs.columbia.edu>;
 Sun, 20 May 2018 03:03:22 -0400 (EDT)
Received: from huawei.com (szxga01-in.huawei.com [45.249.212.187])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C65E140478
 for <kvmarm@lists.cs.columbia.edu>; Sun, 20 May 2018 03:03:21 -0400 (EDT)
In-Reply-To: <20180516162829.14348-12-james.morse@arm.com>
Content-Language: zh-CN
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: James Morse <james.morse@arm.com>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Cc: "jonathan.zhang@cavium.com" <jonathan.zhang@cavium.com>, Rafael Wysocki <rjw@rjwysocki.net>, Tony Luck <tony.luck@intel.com>, "inux-mm@kvack.org" <inux-mm@kvack.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Tyler Baicar <tbaicar@codeaurora.org>, Will Deacon <will.deacon@arm.com>, Punit Agrawal <punit.agrawal@arm.com>, Borislav Petkov <bp@alien8.de>, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Len Brown <lenb@kernel.org>
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
