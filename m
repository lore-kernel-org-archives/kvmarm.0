From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v3 07/12] ACPI / APEI: Make the nmi_fixmap_idx per-ghes
 to allow multiple in_nmi() users
Date: Wed, 16 May 2018 13:05:43 +0200
Message-ID: <20180516110348.GA17092@pd.tnic>
References: <20180427153510.5799-1-james.morse@arm.com>
 <20180427153510.5799-8-james.morse@arm.com>
 <20180505122719.GE3708@pd.tnic>
 <1511cfcc-dcd1-b3c5-01c7-6b6b8fb65b05@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5619442121
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 May 2018 06:56:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rKZvzeGEjoI0 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 16 May 2018 06:56:17 -0400 (EDT)
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AC5F049EA2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 May 2018 06:55:55 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <1511cfcc-dcd1-b3c5-01c7-6b6b8fb65b05@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: James Morse <james.morse@arm.com>, Tyler Baicar <tbaicar@codeaurora.org>
Cc: jonathan.zhang@cavium.com, Rafael Wysocki <rjw@rjwysocki.net>, Tony Luck <tony.luck@intel.com>, Christoffer Dall <cdall@kernel.org>, Punit Agrawal <punit.agrawal@arm.com>, linux-mm@kvack.org, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Dongjiu Geng <gengdongjiu@huawei.com>, linux-acpi@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Len Brown <lenb@kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, May 08, 2018 at 09:45:01AM +0100, James Morse wrote:
> NOTIFY_NMI is x86's NMI, arm doesn't have anything that behaves in the same way,
> so doesn't use it. The equivalent notifications with NMI-like behaviour are:
> * SEA (synchronous external abort)
> * SEI (SError Interrupt)
> * SDEI (software delegated exception interface)

Oh wow, three! :)

> Alternatively, I can put the fixmap-page and spinlock in some 'struct
> ghes_notification' that only the NMI-like struct-ghes need. This is just moving
> the indirection up a level, but it does pair the lock with the thing it locks,
> and gets rid of assigning spinlock pointers.

Keeping the lock and what it protects in one place certainly sounds
better. I guess you could so something like this:

struct ghes_fixmap {
 union {
  raw_spinlock_t nmi_lock;
   spinlock_t lock;
 };
 void __iomem *(map)(struct ghes_fixmap *);
};

and assign the proper ghes_ioremap function to ->map.

The spin_lock_irqsave() call in ghes_copy_tofrom_phys() is kinda
questionable. Because we should have disabled interrupts so that you can
do

spin_lock(map->lock);

Except that we do get called with IRQs on and looking at that call of
ghes_proc() at the end of ghes_probe(), that's a deadlock waiting to
happen.

And that comes from:

  77b246b32b2c ("acpi: apei: check for pending errors when probing GHES entries")

Tyler, this can't work in any context: imagine the GHES NMI or IRQ or
the timer fires while that ghes_proc() runs...

What's up?

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
