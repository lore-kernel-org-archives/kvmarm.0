From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v3 07/12] ACPI / APEI: Make the nmi_fixmap_idx per-ghes to
 allow multiple in_nmi() users
Date: Wed, 16 May 2018 15:51:14 +0100
Message-ID: <7c871e15-689c-226d-760d-dd92614de2e9@arm.com>
References: <20180427153510.5799-1-james.morse@arm.com>
 <20180427153510.5799-8-james.morse@arm.com> <20180505122719.GE3708@pd.tnic>
 <1511cfcc-dcd1-b3c5-01c7-6b6b8fb65b05@arm.com>
 <20180516110348.GA17092@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BCF0842121
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 May 2018 10:44:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id j8V+jzGRVRhU for <kvmarm@lists.cs.columbia.edu>;
 Wed, 16 May 2018 10:44:02 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CA6984043C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 May 2018 10:44:02 -0400 (EDT)
In-Reply-To: <20180516110348.GA17092@pd.tnic>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Borislav Petkov <bp@alien8.de>, Tyler Baicar <tbaicar@codeaurora.org>
Cc: jonathan.zhang@cavium.com, Rafael Wysocki <rjw@rjwysocki.net>, Tony Luck <tony.luck@intel.com>, Christoffer Dall <cdall@kernel.org>, Punit Agrawal <punit.agrawal@arm.com>, linux-mm@kvack.org, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Dongjiu Geng <gengdongjiu@huawei.com>, linux-acpi@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Len Brown <lenb@kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Borislav,

On 16/05/18 12:05, Borislav Petkov wrote:
> On Tue, May 08, 2018 at 09:45:01AM +0100, James Morse wrote:
>> NOTIFY_NMI is x86's NMI, arm doesn't have anything that behaves in the same way,
>> so doesn't use it. The equivalent notifications with NMI-like behaviour are:
>> * SEA (synchronous external abort)
>> * SEI (SError Interrupt)
>> * SDEI (software delegated exception interface)
> > Oh wow, three! :)

The first two overload existing architectural behavior, the third improves all
this with a third standard option. Its the standard story!


>> Alternatively, I can put the fixmap-page and spinlock in some 'struct
>> ghes_notification' that only the NMI-like struct-ghes need. This is just moving
>> the indirection up a level, but it does pair the lock with the thing it locks,
>> and gets rid of assigning spinlock pointers.
> 
> Keeping the lock and what it protects in one place certainly sounds
> better.

Yup, I was about to post a v4...


> I guess you could so something like this:
> 
> struct ghes_fixmap {
>  union {
>   raw_spinlock_t nmi_lock;
>    spinlock_t lock;
>  };

(heh, spinlock_t already contains a raw_spinlock_t)

>  void __iomem *(map)(struct ghes_fixmap *);
> };
> 
> and assign the proper ghes_ioremap function to ->map.

The function pointer is a problem because SDEI is effectively two notification
methods. Critical can interrupt normal. I'd really like to keep the differences
buried in the SDEI driver.

v4 has a separate structure for the fixmap-entry and lock, which
ghes_copy_tofrom_phys() reaches into if in_nmi().


> The spin_lock_irqsave() call in ghes_copy_tofrom_phys() is kinda
> questionable. Because we should have disabled interrupts so that you can
> do
> 
> spin_lock(map->lock);

I thought this was for the polled driver, but that must be backed by an
interrupt too...

linux/timer.h has:
|  * An irqsafe timer is executed with IRQ disabled and it's safe to wait for
|  * the completion of the running instance from IRQ handlers, for example,
|  * by calling del_timer_sync().
|  *
|  * Note: The irq disabled callback execution is a special case for
|  * workqueue locking issues. It's not meant for executing random crap
|  * with interrupts disabled. Abuse is monitored!

This irq-disable behaviour is controlled by the flags field:
| #define TIMER_DEFERRABLE	0x00080000
| #define TIMER_IRQSAFE		0x00200000

and ghes_probe() does this:
| timer_setup(&ghes->timer, ghes_poll_func, TIMER_DEFERRABLE);

So I think the ghes_poll_func() can be called with IRQs unmasked, hence the
spin_lock_irqsave().


> Except that we do get called with IRQs on and looking at that call of
> ghes_proc() at the end of ghes_probe(), that's a deadlock waiting to
> happen.
> 
> And that comes from:
> 
>   77b246b32b2c ("acpi: apei: check for pending errors when probing GHES entries")
> 
> Tyler, this can't work in any context: imagine the GHES NMI or IRQ or
> the timer fires while that ghes_proc() runs...

I thought this was safe because its just ghes_copy_tofrom_phys()s access to the
fixmap slots that needs mutual exclusion.

Polled and all the IRQ flavours are kept apart by the spin_lock_irqsave(), and
the NMIs have their own fixmap entry. (This is fine until there is more than
once source of NMI)


Thanks,

James
