From: "Rafael J. Wysocki" <rafael@kernel.org>
Subject: Re: [PATCH v8 00/26] APEI in_nmi() rework and SDEI wire-up
Date: Mon, 11 Feb 2019 12:05:52 +0100
Message-ID: <CAJZ5v0ibUO7F=+_GBbhEz4nc0jtC=UaK+cOcLCBrXd2pfc0iLg@mail.gmail.com>
References: <20190129184902.102850-1-james.morse@arm.com>
 <15200237.N8Ro7ITLGE@aspire.rjw.lan>
 <a8b9983d-5eef-2f30-441f-73ce50da7bca@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <a8b9983d-5eef-2f30-441f-73ce50da7bca@arm.com>
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
Cc: Tony Luck <tony.luck@intel.com>, ACPI Devel Maling List <linux-acpi@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, Will Deacon <will.deacon@arm.com>, Xie XiuQi <xiexiuqi@huawei.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Christoffer Dall <christoffer.dall@arm.com>, Dongjiu Geng <gengdongjiu@huawei.com>, Linux Memory Management List <linux-mm@kvack.org>, Borislav Petkov <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, kvmarm@lists.cs.columbia.edu, Linux ARM <linux-arm-kernel@lists.infradead.org>, Len Brown <lenb@kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Feb 8, 2019 at 3:13 PM James Morse <james.morse@arm.com> wrote:
>
> Hi Rafael,
>
> On 08/02/2019 11:40, Rafael J. Wysocki wrote:
> > On Tuesday, January 29, 2019 7:48:36 PM CET James Morse wrote:
> >> This series aims to wire-up arm64's fancy new software-NMI notifications
> >> for firmware-first RAS. These need to use the estatus-queue, which is
> >> also needed for notifications via emulated-SError. All of these
> >> things take the 'in_nmi()' path through ghes_copy_tofrom_phys(), and
> >> so will deadlock if they can interact, which they might.
>
> >> Known issues:
> >>  * ghes_copy_tofrom_phys() already takes a lock in NMI context, this
> >>    series moves that around, and makes sure we never try to take the
> >>    same lock from different NMIlike notifications. Since the switch to
> >>    queued spinlocks it looks like the kernel can only be 4 context's
> >>    deep in spinlock, which arm64 could exceed as it doesn't have a
> >>    single architected NMI. This would be fixed by dropping back to
> >>    test-and-set when the nesting gets too deep:
> >>  lore.kernel.org/r/1548215351-18896-1-git-send-email-longman@redhat.com
> >>
> >> * Taking an NMI from a KVM guest on arm64 with VHE leaves HCR_EL2.TGE
> >>   clear, meaning AT and TLBI point at the guest, and PAN/UAO are squiffy.
> >>   Only TLBI matters for APEI, and this is fixed by Julien's patch:
> >>  http://lore.kernel.org/r/1548084825-8803-2-git-send-email-julien.thierry@arm.com
> >>
> >> * Linux ignores the physical address mask, meaning it doesn't call
> >>   memory_failure() on all the affected pages if firmware or hypervisor
> >>   believe in a different page size. Easy to hit on arm64, (easy to fix too,
> >>   it just conflicts with this series)
>
>
> >> James Morse (26):
> >>   ACPI / APEI: Don't wait to serialise with oops messages when
> >>     panic()ing
> >>   ACPI / APEI: Remove silent flag from ghes_read_estatus()
> >>   ACPI / APEI: Switch estatus pool to use vmalloc memory
> >>   ACPI / APEI: Make hest.c manage the estatus memory pool
> >>   ACPI / APEI: Make estatus pool allocation a static size
> >>   ACPI / APEI: Don't store CPER records physical address in struct ghes
> >>   ACPI / APEI: Remove spurious GHES_TO_CLEAR check
> >>   ACPI / APEI: Don't update struct ghes' flags in read/clear estatus
> >>   ACPI / APEI: Generalise the estatus queue's notify code
> >>   ACPI / APEI: Don't allow ghes_ack_error() to mask earlier errors
> >>   ACPI / APEI: Move NOTIFY_SEA between the estatus-queue and NOTIFY_NMI
> >>   ACPI / APEI: Switch NOTIFY_SEA to use the estatus queue
> >>   KVM: arm/arm64: Add kvm_ras.h to collect kvm specific RAS plumbing
> >>   arm64: KVM/mm: Move SEA handling behind a single 'claim' interface
> >>   ACPI / APEI: Move locking to the notification helper
> >>   ACPI / APEI: Let the notification helper specify the fixmap slot
> >>   ACPI / APEI: Pass ghes and estatus separately to avoid a later copy
> >>   ACPI / APEI: Make GHES estatus header validation more user friendly
> >>   ACPI / APEI: Split ghes_read_estatus() to allow a peek at the CPER
> >>     length
> >>   ACPI / APEI: Only use queued estatus entry during
> >>     in_nmi_queue_one_entry()
> >>   ACPI / APEI: Use separate fixmap pages for arm64 NMI-like
> >>     notifications
> >>   mm/memory-failure: Add memory_failure_queue_kick()
> >>   ACPI / APEI: Kick the memory_failure() queue for synchronous errors
> >>   arm64: acpi: Make apei_claim_sea() synchronise with APEI's irq work
> >>   firmware: arm_sdei: Add ACPI GHES registration helper
> >>   ACPI / APEI: Add support for the SDEI GHES Notification type
>
>
> > I can apply patches in this series up to and including patch [21/26].
> >
> > Do you want me to do that?
>
> 9-12, 17-19, 21 are missing any review/ack tags, so I wouldn't ask, but as
> you're offering, yes please!
>
>
> > Patch [22/26] requires an ACK from mm people.
> >
> > Patch [23/26] has a problem that randconfig can generate a configuration
> > in which memory_failure_queue_kick() is not present, so it is necessary
> > to add a CONFIG_MEMORY_FAILURE dependency somewhere for things to
> > work (or define an empty stub for that function in case the symbol is
> > not set).
>
> Damn-it! Thanks, I was just trying to work that report out...
>
>
> > If patches [24-26/26] don't depend on the previous two, I can try to
> > apply them either, so please let me know.
>
> 22-24 depend on each other. Merging 24 without the other two is no-improvement,
> so I'd like them to be kept together.
>
> 25-26 don't depend on 22-24, but came later so that they weren't affected by the
> same race.
> (note to self: describe that in the cover letter next time.)
>
>
> If I apply the tag's and Boris' changes and post a tested v9 as 1-21, 25-26, is
> that easier, or does it cause extra work?

Actually, I went ahead and applied them, since I had the 1-21 ready anyway.

I applied the Boris' fixups manually which led to a bit of rebasing,
so please check my linux-next branch.

Thanks!
