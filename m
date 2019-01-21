From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v7 22/25] ACPI / APEI: Kick the memory_failure() queue
 for synchronous errors
Date: Mon, 21 Jan 2019 18:58:50 +0100
Message-ID: <20190121175850.GO29166@zn.tnic>
References: <20181203180613.228133-1-james.morse@arm.com>
 <20181203180613.228133-23-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5EC5D4A36B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Jan 2019 12:58:59 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MeDUPkmVh7ZY for <kvmarm@lists.cs.columbia.edu>;
 Mon, 21 Jan 2019 12:58:58 -0500 (EST)
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6BC864A330
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Jan 2019 12:58:58 -0500 (EST)
Content-Disposition: inline
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
To: James Morse <james.morse@arm.com>
Cc: Rafael Wysocki <rjw@rjwysocki.net>, Tony Luck <tony.luck@intel.com>, Fan Wu <wufan@codeaurora.org>, linux-mm@kvack.org, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Dongjiu Geng <gengdongjiu@huawei.com>, linux-acpi@vger.kernel.org, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Len Brown <lenb@kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Dec 03, 2018 at 06:06:10PM +0000, James Morse wrote:
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

Good question.

I'm guessing all those things should be queued on a normal struct
work_struct queue, no?

Now, memory_failure_queue() does that and can run from IRQ context so
you need only an irq_work which can queue from NMI context. We do it
this way in the MCA code:

We queue in an irq_work in NMI context and work through the items in
process context.

> ---
>  drivers/acpi/apei/ghes.c | 65 ++++++++++++++++++++++++++++++++++++----
>  1 file changed, 60 insertions(+), 5 deletions(-)

...

> @@ -407,7 +447,22 @@ static void ghes_handle_memory_failure(struct acpi_hest_generic_data *gdata, int
>  
>  	if (flags != -1)
>  		memory_failure_queue(pfn, flags);
> -#endif
> +
> +	/*
> +	 * If the notification indicates that it was the interrupted
> +	 * instruction that caused the error, try to kick the
> +	 * memory_failure() queue before returning to user-space.
> +	 */
> +	if (ghes_is_synchronous(ghes) && current->mm != &init_mm) {
> +		callback = kzalloc(sizeof(*callback), GFP_ATOMIC);

Can we avoid that GFP_ATOMIC allocation and kfree() in
ghes_kick_memory_failure()?

I mean, that struct ghes_memory_failure_work is small enough and we
already do lockless allocation:

	estatus_node = (void *)gen_pool_alloc(ghes_estatus_pool, node_len);

so I guess we could add that ghes_memory_failure_work struct to that
estatus_node, hand it into ghes_do_proc() and then free it.

No?

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
