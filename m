From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v3 07/12] ACPI / APEI: Make the nmi_fixmap_idx per-ghes
 to allow multiple in_nmi() users
Date: Thu, 17 May 2018 15:36:53 +0200
Message-ID: <20180517133653.GA27738@pd.tnic>
References: <20180427153510.5799-1-james.morse@arm.com>
 <20180427153510.5799-8-james.morse@arm.com>
 <20180505122719.GE3708@pd.tnic>
 <1511cfcc-dcd1-b3c5-01c7-6b6b8fb65b05@arm.com>
 <20180516110348.GA17092@pd.tnic>
 <7c871e15-689c-226d-760d-dd92614de2e9@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <7c871e15-689c-226d-760d-dd92614de2e9@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: James Morse <james.morse@arm.com>
Cc: jonathan.zhang@cavium.com, Rafael Wysocki <rjw@rjwysocki.net>, Tony Luck <tony.luck@intel.com>, Christoffer Dall <cdall@kernel.org>, Xie XiuQi <xiexiuqi@huawei.com>, linux-mm@kvack.org, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Tyler Baicar <tbaicar@codeaurora.org>, Will Deacon <will.deacon@arm.com>, Dongjiu Geng <gengdongjiu@huawei.com>, linux-acpi@vger.kernel.org, Punit Agrawal <punit.agrawal@arm.com>, Thomas Gleixner <tglx@linutronix.de>, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Len Brown <lenb@kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, May 16, 2018 at 03:51:14PM +0100, James Morse wrote:
> The first two overload existing architectural behavior, the third improves all
> this with a third standard option. Its the standard story!

:-)

> I thought this was safe because its just ghes_copy_tofrom_phys()s access to the
> fixmap slots that needs mutual exclusion.
>
> Polled and all the IRQ flavours are kept apart by the spin_lock_irqsave(), and
> the NMIs have their own fixmap entry. (This is fine until there is more than
> once source of NMI)

For example:

ghes_probe()

	switch (generic->notify.type) {

	...

        case ACPI_HEST_NOTIFY_NMI:
		ghes_nmi_add(ghes);
	}

	...

	ghes_proc();
	  ghes_read_estatus();
		 spin_lock_irqsave(&ghes_ioremap_lock_irq, flags);

		 memcpy...

	-> NMI

		ghes_notify_nmi();
		 ghes_read_estatus();
		 ..
		   if (in_nmi) {
			   raw_spin_lock(&ghes_ioremap_lock_nmi);

		...
	<- NMI

ghes->estatus from above, before the NMI fired, has gotten some nice
scribbling over. AFAICT.

Now, I don't know whether this can happen with the ARM facilities but if
they're NMI-like, I don't see why not.

Which means, that this code is not really reentrant and if should be
fixed to be callable from different contexts, then it should use private
buffers and be careful about locking.

Oh, and that

	if (in_nmi)
		lock()
	else
		lock_irqsave()

pattern is really yucky. And it is an explosion waiting to happen.

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
