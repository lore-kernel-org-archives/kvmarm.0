From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v3 07/12] ACPI / APEI: Make the nmi_fixmap_idx per-ghes to
 allow multiple in_nmi() users
Date: Tue, 8 May 2018 09:45:01 +0100
Message-ID: <1511cfcc-dcd1-b3c5-01c7-6b6b8fb65b05@arm.com>
References: <20180427153510.5799-1-james.morse@arm.com>
 <20180427153510.5799-8-james.morse@arm.com> <20180505122719.GE3708@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20180505122719.GE3708@pd.tnic>
Content-Language: en-US
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Borislav Petkov <bp@alien8.de>
Cc: jonathan.zhang@cavium.com, Rafael Wysocki <rjw@rjwysocki.net>, Tony Luck <tony.luck@intel.com>, Christoffer Dall <cdall@kernel.org>, Xie XiuQi <xiexiuqi@huawei.com>, linux-mm@kvack.org, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Tyler Baicar <tbaicar@codeaurora.org>, Will Deacon <will.deacon@arm.com>, Dongjiu Geng <gengdongjiu@huawei.com>, linux-acpi@vger.kernel.org, Punit Agrawal <punit.agrawal@arm.com>, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Len Brown <lenb@kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Borislav,

On 05/05/18 13:27, Borislav Petkov wrote:
> On Fri, Apr 27, 2018 at 04:35:05PM +0100, James Morse wrote:
>> Arm64 has multiple NMI-like notifications, but ghes.c only has one
>> in_nmi() path, risking deadlock if one NMI-like notification can
>> interrupt another.
>>
>> To support this we need a fixmap entry and lock for each notification
>> type. But ghes_probe() attempts to process each struct ghes at probe
>> time, to ensure any error that was notified before ghes_probe() was
>> called has been done, and the buffer released (and maybe acknowledge
>> to firmware) so that future errors can be delivered.
>>
>> This means NMI-like notifications need two fixmap entries and locks,
>> one for the ghes_probe() time call, and another for the actual NMI
>> that could interrupt ghes_probe().
>>
>> Split this single path up by adding an NMI fixmap idx and lock into
>> the struct ghes. Any notification that can be called as an NMI can
>> use these to separate its resources from any other notification it
>> may interrupt.
>>
>> The majority of notifications occur in IRQ context, so unless its
>> called in_nmi(), ghes_copy_tofrom_phys() will use the FIX_APEI_GHES_IRQ
>> fixmap entry and the ghes_fixmap_lock_irq lock. This allows
>> NMI-notifications to be processed by ghes_probe(), and then taken
>> as an NMI.
>>
>> The double-underscore version of fix_to_virt() is used because the index
>> to be mapped can't be tested against the end of the enum at compile
>> time.

>> @@ -986,6 +960,8 @@ int ghes_notify_sea(void)
>>  
>>  static void ghes_sea_add(struct ghes *ghes)
>>  {
>> +	ghes->nmi_fixmap_lock = &ghes_fixmap_lock_nmi;
>> +	ghes->nmi_fixmap_idx = FIX_APEI_GHES_NMI;
>>  	ghes_estatus_queue_grow_pool(ghes);
>>  
>>  	mutex_lock(&ghes_list_mutex);
>> @@ -1032,6 +1008,8 @@ static int ghes_notify_nmi(unsigned int cmd, struct pt_regs *regs)
>>  
>>  static void ghes_nmi_add(struct ghes *ghes)
>>  {
>> +	ghes->nmi_fixmap_lock = &ghes_fixmap_lock_nmi;
> 
> Ewww, we're assigning the spinlock to a pointer which we'll take later?
> Yuck.

> Why?

So that APEI doesn't need to know which lock goes with which fixmap page, and
how these notifications interact.


> Do I see it correctly that one can have ACPI_HEST_NOTIFY_SEA and
> ACPI_HEST_NOTIFY_NMI coexist in parallel on a single system?

NOTIFY_NMI is x86's NMI, arm doesn't have anything that behaves in the same way,
so doesn't use it. The equivalent notifications with NMI-like behaviour are:
* SEA (synchronous external abort)
* SEI (SError Interrupt)
* SDEI (software delegated exception interface)


> If not, you can use a single spinlock.

Today we could, but once we have SDEI and SEI this won't work:
SDEI behaves as two notifications, 'normal' and 'critical', a different fixmap
page is needed for these as they can interrupt each other, and a different lock.

SEA can interrupt SEI, so they need a different fixmap-pages and locks.
We can always disable SEI when we're handling another NMI-like notification.

I doubt anyone would implement all three, but if they did SEA can interrupt the lot.


I'd like to avoid describing any of these interactions in ghes.c, I think it
should be possible that any notification can interrupt any other notification
without the risk of deadlock.


> If yes, then I'd prefer to make it less ugly and do the notification
> type check ghes_probe() does:
> 
> 	switch (generic->notify.type)
> 
> and take the respective spinlock in ghes_copy_tofrom_phys(). This way it
> is a bit better than using a spinlock ptr.

I wanted to avoid duplicating that list, some of the locks are #ifdef'd so it
gets ugly quickly. (We would only need the NMI-like notifications though).

I'd really like to avoid the GHES code having to know about normal/critical SDEI
events.


Alternatively, I can put the fixmap-page and spinlock in some 'struct
ghes_notification' that only the NMI-like struct-ghes need. This is just moving
the indirection up a level, but it does pair the lock with the thing it locks,
and gets rid of assigning spinlock pointers.


Thanks,

James
