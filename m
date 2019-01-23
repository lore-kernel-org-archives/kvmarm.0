From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v7 22/25] ACPI / APEI: Kick the memory_failure() queue for
 synchronous errors
Date: Wed, 23 Jan 2019 18:40:08 +0000
Message-ID: <58053f17-5f03-8408-7252-a38ed3d448a9@arm.com>
References: <20181203180613.228133-1-james.morse@arm.com>
 <20181203180613.228133-23-james.morse@arm.com>
 <20190121175850.GO29166@zn.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7F5504A3CD
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Jan 2019 13:40:15 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id b-nDiAjLyJib for <kvmarm@lists.cs.columbia.edu>;
 Wed, 23 Jan 2019 13:40:14 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9D2794A3CA
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Jan 2019 13:40:13 -0500 (EST)
In-Reply-To: <20190121175850.GO29166@zn.tnic>
Content-Language: en-GB
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Borislav Petkov <bp@alien8.de>
Cc: Rafael Wysocki <rjw@rjwysocki.net>, Tony Luck <tony.luck@intel.com>, Fan Wu <wufan@codeaurora.org>, linux-mm@kvack.org, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Dongjiu Geng <gengdongjiu@huawei.com>, linux-acpi@vger.kernel.org, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Len Brown <lenb@kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Boris,

On 21/01/2019 17:58, Borislav Petkov wrote:
> On Mon, Dec 03, 2018 at 06:06:10PM +0000, James Morse wrote:
>> memory_failure() offlines or repairs pages of memory that have been
>> discovered to be corrupt. These may be detected by an external
>> component, (e.g. the memory controller), and notified via an IRQ.
>> In this case the work is queued as not all of memory_failure()s work
>> can happen in IRQ context.
>>
>> If the error was detected as a result of user-space accessing a
>> corrupt memory location the CPU may take an abort instead. On arm64
>> this is a 'synchronous external abort', and on a firmware first
>> system it is replayed using NOTIFY_SEA.
>>
>> This notification has NMI like properties, (it can interrupt
>> IRQ-masked code), so the memory_failure() work is queued. If we
>> return to user-space before the queued memory_failure() work is
>> processed, we will take the fault again. This loop may cause platform
>> firmware to exceed some threshold and reboot when Linux could have
>> recovered from this error.
>>
>> If a ghes notification type indicates that it may be triggered again
>> when we return to user-space, use the task-work and notify-resume
>> hooks to kick the relevant memory_failure() queue before returning
>> to user-space.

>> ---

>> I assume that if NOTIFY_NMI is coming from SMM it must suffer from
>> this problem too.
> 
> Good question.
> 
> I'm guessing all those things should be queued on a normal struct
> work_struct queue, no?

ghes_notify_nmi() does this today with its:
|	irq_work_queue(&ghes_proc_irq_work);

Once its in IRQ context, the irq_work pokes memory_failure_queue(), which
schedule_work_on()s.

Finally we schedule() in process context, and can unmap the affected memory.


The problem is between each of these steps we might return to user-space and run
the instruction that tripped all this to begin with.


My SMM comment was because the CPU must jump from user-space->SMM, which injects
an NMI into the kernel. The kernel's EIP must point into user-space, so
returning from the NMI without doing the memory_failure() work puts us back the
same position we started in.


> Now, memory_failure_queue() does that and can run from IRQ context so
> you need only an irq_work which can queue from NMI context. We do it
> this way in the MCA code:
> 

(was there something missing here?)

> We queue in an irq_work in NMI context and work through the items in
> process context.

How are you getting from NMI to process context in one go?

This patch causes the IRQ->process transition.
The arch specific bit of this gives the irq work queue a kick if returning from
the NMI would unmask IRQs. This makes it look like we moved from NMI to IRQ
context without returning to user-space.

Once ghes_handle_memory_failure() runs in IRQ context, it task_work_add()s the
call to ghes_kick_memory_failure().

Finally on the way out of the kernel to user-space that task_work runs and the
memory_failure() work happens in process context.

During all this the user-space program counter can point at a poisoned location,
but we don't return there until the memory_failure() work has been done.


>> @@ -407,7 +447,22 @@ static void ghes_handle_memory_failure(struct acpi_hest_generic_data *gdata, int
>>  
>>  	if (flags != -1)
>>  		memory_failure_queue(pfn, flags);
>> -#endif
>> +
>> +	/*
>> +	 * If the notification indicates that it was the interrupted
>> +	 * instruction that caused the error, try to kick the
>> +	 * memory_failure() queue before returning to user-space.
>> +	 */
>> +	if (ghes_is_synchronous(ghes) && current->mm != &init_mm) {
>> +		callback = kzalloc(sizeof(*callback), GFP_ATOMIC);
> 
> Can we avoid that GFP_ATOMIC allocation and kfree() in
> ghes_kick_memory_failure()?
> 
> I mean, that struct ghes_memory_failure_work is small enough and we
> already do lockless allocation:
> 
> 	estatus_node = (void *)gen_pool_alloc(ghes_estatus_pool, node_len);
> 
> so I guess we could add that ghes_memory_failure_work struct to that
> estatus_node, hand it into ghes_do_proc() and then free it.

I forget estatus_node is a linux thing, not an ACPI-spec thing!

Hmmm, ghes_handle_memory_failure() runs for POLLED and irq error sources too,
they don't have an estatus_node. We don't care about this ret_to_user() problem
as they are all asynchronous, this is why we have ghes_is_synchronous()...

It feels like there should be a way to do this, let me have a go...


Thanks,

James
