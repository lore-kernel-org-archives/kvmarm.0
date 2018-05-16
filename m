From: Tyler Baicar <tbaicar@codeaurora.org>
Subject: Re: [PATCH v3 07/12] ACPI / APEI: Make the nmi_fixmap_idx per-ghes to
 allow multiple in_nmi() users
Date: Wed, 16 May 2018 11:38:16 -0400
Message-ID: <39bde8c5-4dfb-c1b9-02a4-ba467539ea24@codeaurora.org>
References: <20180427153510.5799-1-james.morse@arm.com>
 <20180427153510.5799-8-james.morse@arm.com> <20180505122719.GE3708@pd.tnic>
 <1511cfcc-dcd1-b3c5-01c7-6b6b8fb65b05@arm.com>
 <20180516110348.GA17092@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20180516110348.GA17092@pd.tnic>
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
To: Borislav Petkov <bp@alien8.de>, James Morse <james.morse@arm.com>
Cc: jonathan.zhang@cavium.com, Rafael Wysocki <rjw@rjwysocki.net>, Tony Luck <tony.luck@intel.com>, Christoffer Dall <cdall@kernel.org>, Punit Agrawal <punit.agrawal@arm.com>, linux-mm@kvack.org, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Xie XiuQi <xiexiuqi@huawei.com>, Will Deacon <will.deacon@arm.com>, Dongjiu Geng <gengdongjiu@huawei.com>, linux-acpi@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Len Brown <lenb@kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 5/16/2018 7:05 AM, Borislav Petkov wrote:
> On Tue, May 08, 2018 at 09:45:01AM +0100, James Morse wrote:
>> Alternatively, I can put the fixmap-page and spinlock in some 'struct
>> ghes_notification' that only the NMI-like struct-ghes need. This is just moving
>> the indirection up a level, but it does pair the lock with the thing it locks,
>> and gets rid of assigning spinlock pointers.
> Keeping the lock and what it protects in one place certainly sounds
> better. I guess you could so something like this:
>
> struct ghes_fixmap {
>   union {
>    raw_spinlock_t nmi_lock;
>     spinlock_t lock;
>   };
>   void __iomem *(map)(struct ghes_fixmap *);
> };
>
> and assign the proper ghes_ioremap function to ->map.
>
> The spin_lock_irqsave() call in ghes_copy_tofrom_phys() is kinda
> questionable. Because we should have disabled interrupts so that you can
> do
>
> spin_lock(map->lock);
>
> Except that we do get called with IRQs on and looking at that call of
> ghes_proc() at the end of ghes_probe(), that's a deadlock waiting to
> happen.
>
> And that comes from:
>
>    77b246b32b2c ("acpi: apei: check for pending errors when probing GHES entries")
>
> Tyler, this can't work in any context: imagine the GHES NMI or IRQ or
> the timer fires while that ghes_proc() runs...
>
> What's up?
Hello Boris,

I haven't seen a deadlock from that, but it looks possible. What if the 
ghes_proc() call in ghes_probe()
is moved before the second switch statement? That way it is before the 
NMI/IRQ/poll is setup. At quick
glance I think that should avoid the deadlock and still provide the 
functionality that call was added for. I
can test that out if you all agree.

Thanks,
Tyler

-- 
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project.
