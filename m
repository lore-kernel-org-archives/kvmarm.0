From: Xie XiuQi <xiexiuqi@huawei.com>
Subject: Re: [PATCH v7 22/25] ACPI / APEI: Kick the memory_failure() queue for
 synchronous errors
Date: Wed, 5 Dec 2018 10:02:53 +0800
Message-ID: <9d153a07-aa7a-6e0c-3bd3-994a66f9639a@huawei.com>
References: <20181203180613.228133-1-james.morse@arm.com>
 <20181203180613.228133-23-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 96D8B4A320
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Dec 2018 21:03:07 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EE-cJq3ulIP8 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  4 Dec 2018 21:03:06 -0500 (EST)
Received: from huawei.com (szxga04-in.huawei.com [45.249.212.190])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4D1344A1F2
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Dec 2018 21:03:06 -0500 (EST)
In-Reply-To: <20181203180613.228133-23-james.morse@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: James Morse <james.morse@arm.com>, Borislav Petkov <bp@alien8.de>
Cc: Rafael Wysocki <rjw@rjwysocki.net>, Tony Luck <tony.luck@intel.com>, Fan Wu <wufan@codeaurora.org>, linux-mm@kvack.org, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Dongjiu Geng <gengdongjiu@huawei.com>, Wang Xiongfeng <wangxiongfeng2@huawei.com>, linux-acpi@vger.kernel.org, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Len Brown <lenb@kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi James & Boris,

On 2018/12/4 2:06, James Morse wrote:
> memory_failure() offlines or repairs pages of memory that have been
> discovered to be corrupt. These may be detected by an external
> component, (e.g. the memory controller), and notified via an IRQ.
> In this case the work is queued as not all of memory_failure()s work
> can happen in IRQ context.
> 
> If the error was detected as a result of user-space accessing a
> corrupt memory location the CPU may take an abort instead. On arm64
> this is a 'synchronous external abort', and on a firmware first
> system it is replayed using NOTIFY_SEA.
> 
> This notification has NMI like properties, (it can interrupt
> IRQ-masked code), so the memory_failure() work is queued. If we
> return to user-space before the queued memory_failure() work is
> processed, we will take the fault again. This loop may cause platform
> firmware to exceed some threshold and reboot when Linux could have
> recovered from this error.
> 
> If a ghes notification type indicates that it may be triggered again
> when we return to user-space, use the task-work and notify-resume
> hooks to kick the relevant memory_failure() queue before returning
> to user-space.
> 
> Signed-off-by: James Morse <james.morse@arm.com>
> 
> ---
> current->mm == &init_mm ? I couldn't find a helper for this.
> The intent is not to set TIF flags on kernel threads. What happens
> if a kernel-thread takes on of these? Its just one of the many
> not-handled-very-well cases we have already, as memory_failure()
> puts it: "try to be lucky".
> 
> I assume that if NOTIFY_NMI is coming from SMM it must suffer from
> this problem too.
> ---
>  drivers/acpi/apei/ghes.c | 65 ++++++++++++++++++++++++++++++++++++----
>  1 file changed, 60 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
> index 6cbf9471b2a2..3e7da9243153 100644
> --- a/drivers/acpi/apei/ghes.c
> +++ b/drivers/acpi/apei/ghes.c
> @@ -47,6 +47,7 @@
>  #include <linux/sched/clock.h>
>  #include <linux/uuid.h>
>  #include <linux/ras.h>
> +#include <linux/task_work.h>
>  
>  #include <acpi/actbl1.h>
>  #include <acpi/ghes.h>
> @@ -136,6 +137,26 @@ static atomic_t ghes_estatus_cache_alloced;
>  
>  static int ghes_panic_timeout __read_mostly = 30;
>  
> +static bool ghes_is_synchronous(struct ghes *ghes)
> +{
> +	switch (ghes->generic->notify.type) {
> +	case ACPI_HEST_NOTIFY_NMI:	/* fall through */
> +	case ACPI_HEST_NOTIFY_SEA:
> +		/*
> +		 * These notifications could be repeated if the interrupted
> +		 * instruction is run again. e.g. a read of bad-memory causing
> +		 * a trap to platform firmware.
> +		 */
> +		return true;
> +	default:
> +		/*
> +		 * Other notifications are asynchronous, and not related to the
> +		 * interrupted instruction. e.g. an IRQ.
> +		 */
> +		return false;
> +	}
> +}
> +
>  static void __iomem *ghes_map(u64 pfn, int fixmap_idx)
>  {
>  	phys_addr_t paddr;
> @@ -379,14 +400,33 @@ static void ghes_clear_estatus(struct acpi_hest_generic_status *estatus,
>  				      fixmap_idx);
>  }
>  
> -static void ghes_handle_memory_failure(struct acpi_hest_generic_data *gdata, int sev)
> +struct ghes_memory_failure_work {
> +	int cpu;
> +	struct callback_head work;
> +};
> +
> +static void ghes_kick_memory_failure(struct callback_head *head)
> +{
> +	struct ghes_memory_failure_work *callback;
> +
> +	callback = container_of(head, struct ghes_memory_failure_work, work);
> +	memory_failure_queue_kick(callback->cpu);
> +	kfree(callback);
> +}
> +
> +static void ghes_handle_memory_failure(struct ghes *ghes,
> +				       struct acpi_hest_generic_data *gdata,
> +				       int sev)
>  {
> -#ifdef CONFIG_ACPI_APEI_MEMORY_FAILURE
>  	unsigned long pfn;
> -	int flags = -1;
> +	int flags = -1, ret;
> +	struct ghes_memory_failure_work	*callback;
>  	int sec_sev = ghes_severity(gdata->error_severity);
>  	struct cper_sec_mem_err *mem_err = acpi_hest_get_payload(gdata);
>  
> +	if (!IS_ENABLED(CONFIG_ACPI_APEI_MEMORY_FAILURE))
> +		return;
> +
>  	if (!(mem_err->validation_bits & CPER_MEM_VALID_PA))
>  		return;
>  
> @@ -407,7 +447,22 @@ static void ghes_handle_memory_failure(struct acpi_hest_generic_data *gdata, int
>  
>  	if (flags != -1)
>  		memory_failure_queue(pfn, flags);

We may need to take MF_ACTION_REQUIRED flags for memory_failure() in SEA condition.
And there is no return value check for memory_failure() in memory_failure_work_func(),
I'm not sure whether we need to check the return value.

static void memory_failure_work_func(struct work_struct *work)
{
        struct memory_failure_cpu *mf_cpu;
        struct memory_failure_entry entry = { 0, };
        unsigned long proc_flags;
        int gotten;

        mf_cpu = container_of(work, struct memory_failure_cpu, work);
        for (;;) {
                spin_lock_irqsave(&mf_cpu->lock, proc_flags);
                gotten = kfifo_get(&mf_cpu->fifo, &entry);
                spin_unlock_irqrestore(&mf_cpu->lock, proc_flags);
                if (!gotten)
                        break;
                if (entry.flags & MF_SOFT_OFFLINE)
                        soft_offline_page(pfn_to_page(entry.pfn), entry.flags);
                else
                        memory_failure(entry.pfn, entry.flags);
        }
}

If the recovery fails here, we need to take other actions, such as force to send a SIGBUS signal.


> -#endif
> +
> +	/*
> +	 * If the notification indicates that it was the interrupted
> +	 * instruction that caused the error, try to kick the
> +	 * memory_failure() queue before returning to user-space.
> +	 */
> +	if (ghes_is_synchronous(ghes) && current->mm != &init_mm) {
> +		callback = kzalloc(sizeof(*callback), GFP_ATOMIC);
> +		if (!callback)
> +			return;
> +		callback->work.func = ghes_kick_memory_failure;
> +		callback->cpu = smp_processor_id();
> +		ret = task_work_add(current, &callback->work, true);
> +		if (ret)
> +			kfree(callback);
> +	}
>  }
>  
>  /*
> @@ -480,7 +535,7 @@ static void ghes_do_proc(struct ghes *ghes,
>  			ghes_edac_report_mem_error(sev, mem_err);
>  
>  			arch_apei_report_mem_error(sev, mem_err);
> -			ghes_handle_memory_failure(gdata, sev);
> +			ghes_handle_memory_failure(ghes, gdata, sev);
>  		}
>  		else if (guid_equal(sec_type, &CPER_SEC_PCIE)) {
>  			ghes_handle_aer(gdata);
> 

-- 
Thanks,
Xie XiuQi
