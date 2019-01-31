From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v7 22/25] ACPI / APEI: Kick the memory_failure() queue
 for synchronous errors
Date: Thu, 31 Jan 2019 15:04:42 +0100
Message-ID: <20190131140442.GL6749@zn.tnic>
References: <20181203180613.228133-1-james.morse@arm.com>
 <20181203180613.228133-23-james.morse@arm.com>
 <20190121175850.GO29166@zn.tnic>
 <58053f17-5f03-8408-7252-a38ed3d448a9@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 506C74A319
 for <kvmarm@lists.cs.columbia.edu>; Thu, 31 Jan 2019 09:04:54 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7HusbKePgYMK for <kvmarm@lists.cs.columbia.edu>;
 Thu, 31 Jan 2019 09:04:53 -0500 (EST)
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1D6CA4A2E7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 31 Jan 2019 09:04:53 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <58053f17-5f03-8408-7252-a38ed3d448a9@arm.com>
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

On Wed, Jan 23, 2019 at 06:40:08PM +0000, James Morse wrote:
> My SMM comment was because the CPU must jump from user-space->SMM, which injects
> an NMI into the kernel. The kernel's EIP must point into user-space, so
> returning from the NMI without doing the memory_failure() work puts us back the
> same position we started in.

Yeah, known issue. We dealt with that on x86 at the time:

d4812e169de4 ("x86, mce: Get rid of TIF_MCE_NOTIFY and associated mce tricks")

> > Now, memory_failure_queue() does that and can run from IRQ context so
> > you need only an irq_work which can queue from NMI context. We do it
> > this way in the MCA code:
> > 
> 
> (was there something missing here?)

Whoops. Yeah, I was about to paste this:

void mce_log(struct mce *m)
{
        if (!mce_gen_pool_add(m))
                irq_work_queue(&mce_irq_work);
}

we're basically queueing only into the lockless buffer and kicking the
IRQ work.

> > We queue in an irq_work in NMI context and work through the items in
> > process context.
> 
> How are you getting from NMI to process context in one go?

Well, #MC is basically an NMI context on x86 and when it is done, we
work through the items queued in process context. But see the commit
above too - for really urgent errors we run memory_failure *before* we
return to user.

> This patch causes the IRQ->process transition.
> The arch specific bit of this gives the irq work queue a kick if returning from
> the NMI would unmask IRQs. This makes it look like we moved from NMI to IRQ
> context without returning to user-space.
> 
> Once ghes_handle_memory_failure() runs in IRQ context, it task_work_add()s the
> call to ghes_kick_memory_failure().
> 
> Finally on the way out of the kernel to user-space that task_work runs and the
> memory_failure() work happens in process context.
> 
> During all this the user-space program counter can point at a poisoned location,
> but we don't return there until the memory_failure() work has been done.

Sounds very similar.

Actually, yours is even a bit more elegant. I wonder why we didn't use
task_work_add() then...

Thx.

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
