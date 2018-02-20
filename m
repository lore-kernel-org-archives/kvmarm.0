From: Punit Agrawal <punit.agrawal@arm.com>
Subject: Re: [PATCH 02/11] ACPI / APEI: Generalise the estatus queue's
 add/remove and notify code
Date: Tue, 20 Feb 2018 18:26:44 +0000
Message-ID: <87sh9vzfdn.fsf@e105922-lin.cambridge.arm.com>
References: <20180215185606.26736-1-james.morse@arm.com>
 <20180215185606.26736-3-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6454140DAB
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Feb 2018 13:20:33 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1G0U88XCJRbK for <kvmarm@lists.cs.columbia.edu>;
 Tue, 20 Feb 2018 13:20:11 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 35EFC402C7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Feb 2018 13:20:11 -0500 (EST)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: James Morse <james.morse@arm.com>
Cc: Rafael Wysocki <rjw@rjwysocki.net>, Tony Luck <tony.luck@intel.com>, linux-mm@kvack.org, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Tyler Baicar <tbaicar@codeaurora.org>, Will Deacon <will.deacon@arm.com>, Dongjiu Geng <gengdongjiu@huawei.com>, linux-acpi@vger.kernel.org, Borislav Petkov <bp@alien8.de>, linux-arm-kernel@lists.infradead.org, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, kvmarm@lists.cs.columbia.edu, Len Brown <lenb@kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu


A few of typos and comments below.

James Morse <james.morse@arm.com> writes:

> To support asynchronous NMI-like notifications on arm64 we need to use
> the estatus-queue. These patches refactor it to allow multiple APEI
> notification types to use it.
>
> Refactor the estatus queue's pool grow/shrink code and notification
> routine from NOTIFY_NMI's handlers. This will allow another notification
> method to use the estatus queue without duplicating this code.
>
> This patch adds rcu_read_lock()/rcu_read_unlock() around the list
> list_for_each_entry_rcu() walker. These aren't strictly necessary as
> the whole nmi_enter/nmi_exit() window is a spooky RCU read-side
> critical section.
>
> Keep the oops_begin() call for x86, arm64 doesn't have one of these,
> and APEI is the only thing outside arch code calling this..
>
> The existing ghes_estatus_pool_shrink() is folded into the new
> ghes_estatus_queue_shrink_pool() as only the queue uses it.
>
> _in_nmi_notify_one() is separate from the rcu-list walker for a later
> caller that doesn't need to walk a list.
>
> Signed-off-by: James Morse <james.morse@arm.com>
> ---
>  drivers/acpi/apei/ghes.c | 103 +++++++++++++++++++++++++++++++----------------
>  1 file changed, 68 insertions(+), 35 deletions(-)
>
> diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
> index e42b587c509b..d3cc5bd5b496 100644
> --- a/drivers/acpi/apei/ghes.c
> +++ b/drivers/acpi/apei/ghes.c
> @@ -749,6 +749,54 @@ static void __process_error(struct ghes *ghes)
>  #endif
>  }
>  
> +static int _in_nmi_notify_one(struct ghes *ghes)
> +{
> +	int sev;
> +	int ret = -ENOENT;

If ret is initialised to 0 ...

> +
> +	if (ghes_read_estatus(ghes, 1)) {
> +		ghes_clear_estatus(ghes);
> +		return ret;

and return -ENOENT here...

> +	} else {
> +		ret = 0;
> +	}

... then the else block can be dropped.

> +
> +	sev = ghes_severity(ghes->estatus->error_severity);
> +	if (sev >= GHES_SEV_PANIC) {
> +#ifdef CONFIG_X86
> +		oops_begin();
> +#endif

Can you use IS_ENABLED() here as well?

> +		ghes_print_queued_estatus();
> +		__ghes_panic(ghes);
> +	}
> +
> +	if (!(ghes->flags & GHES_TO_CLEAR))
> +		return ret;
> +
> +	__process_error(ghes);
> +	ghes_clear_estatus(ghes);
> +
> +	return ret;
> +}
> +
> +static int ghes_estatus_queue_notified(struct list_head *rcu_list)
> +{
> +	int ret = -ENOENT;
> +	struct ghes *ghes;
> +
> +	rcu_read_lock();
> +	list_for_each_entry_rcu(ghes, rcu_list, list) {
> +		if (!_in_nmi_notify_one(ghes))
> +			ret = 0;
> +	}
> +	rcu_read_unlock();
> +
> +	if (IS_ENABLED(CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG) && ret == 0)
> +		irq_work_queue(&ghes_proc_irq_work);
> +
> +	return ret;
> +}
> +
>  static unsigned long ghes_esource_prealloc_size(
>  	const struct acpi_hest_generic *generic)
>  {
> @@ -764,11 +812,24 @@ static unsigned long ghes_esource_prealloc_size(
>  	return prealloc_size;
>  }
>  
> -static void ghes_estatus_pool_shrink(unsigned long len)
> +/* After removing a queue user, we can shrink to pool */
                                                 ^
                                                 the

Thanks,
Punit

> +static void ghes_estatus_queue_shrink_pool(struct ghes *ghes)
>  {
> +	unsigned long len;
> +
> +	len = ghes_esource_prealloc_size(ghes->generic);
>  	ghes_estatus_pool_size_request -= PAGE_ALIGN(len);
>  }
>  

[...]
