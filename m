From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v3 07/12] ACPI / APEI: Make the nmi_fixmap_idx per-ghes
 to allow multiple in_nmi() users
Date: Sat, 5 May 2018 14:27:19 +0200
Message-ID: <20180505122719.GE3708@pd.tnic>
References: <20180427153510.5799-1-james.morse@arm.com>
 <20180427153510.5799-8-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20180427153510.5799-8-james.morse@arm.com>
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
Cc: jonathan.zhang@cavium.com, Rafael Wysocki <rjw@rjwysocki.net>, Tony Luck <tony.luck@intel.com>, Christoffer Dall <cdall@kernel.org>, Xie XiuQi <xiexiuqi@huawei.com>, linux-mm@kvack.org, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Tyler Baicar <tbaicar@codeaurora.org>, Will Deacon <will.deacon@arm.com>, Dongjiu Geng <gengdongjiu@huawei.com>, linux-acpi@vger.kernel.org, Punit Agrawal <punit.agrawal@arm.com>, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Len Brown <lenb@kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Apr 27, 2018 at 04:35:05PM +0100, James Morse wrote:
> Arm64 has multiple NMI-like notifications, but ghes.c only has one
> in_nmi() path, risking deadlock if one NMI-like notification can
> interrupt another.
> 
> To support this we need a fixmap entry and lock for each notification
> type. But ghes_probe() attempts to process each struct ghes at probe
> time, to ensure any error that was notified before ghes_probe() was
> called has been done, and the buffer released (and maybe acknowledge
> to firmware) so that future errors can be delivered.
> 
> This means NMI-like notifications need two fixmap entries and locks,
> one for the ghes_probe() time call, and another for the actual NMI
> that could interrupt ghes_probe().
> 
> Split this single path up by adding an NMI fixmap idx and lock into
> the struct ghes. Any notification that can be called as an NMI can
> use these to separate its resources from any other notification it
> may interrupt.
> 
> The majority of notifications occur in IRQ context, so unless its
> called in_nmi(), ghes_copy_tofrom_phys() will use the FIX_APEI_GHES_IRQ
> fixmap entry and the ghes_fixmap_lock_irq lock. This allows
> NMI-notifications to be processed by ghes_probe(), and then taken
> as an NMI.
> 
> The double-underscore version of fix_to_virt() is used because the index
> to be mapped can't be tested against the end of the enum at compile
> time.
> 
> Signed-off-by: James Morse <james.morse@arm.com>
> 
> ---
> Changes since v1:
>  * Fixed for ghes_proc() always calling every notification in process context.
>    Now only NMI-like notifications need an additional fixmap-slot/lock.

...

> @@ -986,6 +960,8 @@ int ghes_notify_sea(void)
>  
>  static void ghes_sea_add(struct ghes *ghes)
>  {
> +	ghes->nmi_fixmap_lock = &ghes_fixmap_lock_nmi;
> +	ghes->nmi_fixmap_idx = FIX_APEI_GHES_NMI;
>  	ghes_estatus_queue_grow_pool(ghes);
>  
>  	mutex_lock(&ghes_list_mutex);
> @@ -1032,6 +1008,8 @@ static int ghes_notify_nmi(unsigned int cmd, struct pt_regs *regs)
>  
>  static void ghes_nmi_add(struct ghes *ghes)
>  {
> +	ghes->nmi_fixmap_lock = &ghes_fixmap_lock_nmi;

Ewww, we're assigning the spinlock to a pointer which we'll take later?
Yuck.

Why?

Do I see it correctly that one can have ACPI_HEST_NOTIFY_SEA and
ACPI_HEST_NOTIFY_NMI coexist in parallel on a single system?

If not, you can use a single spinlock.

If yes, then I'd prefer to make it less ugly and do the notification
type check ghes_probe() does:

	switch (generic->notify.type)

and take the respective spinlock in ghes_copy_tofrom_phys(). This way it
is a bit better than using a spinlock ptr.

Thx.

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
