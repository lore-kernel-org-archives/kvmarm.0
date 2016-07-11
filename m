From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v8 00/17] KVM: arm64: GICv3 ITS emulation
Date: Mon, 11 Jul 2016 18:36:46 +0100
Message-ID: <5783D92E.6060700@arm.com>
References: <20160705112309.28877-1-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20160705112309.28877-1-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: Eric Auger <eric.auger@redhat.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 05/07/16 12:22, Andre Przywara wrote:
> Hi,
> 
> this series allows those KVM guests that use an emulated GICv3 to use LPIs
> as well, though in the moment this is limited to emulated PCI devices.
> This is based on kvmarm/queue, which now only features the new VGIC
> implementation.
> 
> This time only smaller corrections for the KVM ITS emulation support:
> I addressed the review comments, which pointed out some vgic_put_irq()
> omissions. Also the GICv2 init sequence has changed, so that we can now
> bail out a KVM_DEVICE init without leaking a HYP mapping.
> Also a bug in the MAPC emulation was fixed, which allowed multiple
> mappings of the same collection ID.
> The KVM_DEVICE init sequence has now some checks to ensure the right
> order. The requirements are a bit stricter than for the GICv2/GICv3
> devices: we need to setup the mapping address before calling the
> INIT ioctl. This apparently has some implications on QEMU, I just need
> to be convinced that we should follow QEMU's approach. It seems to look
> a bit ugly to stash the ITS init into the existing GICv3 code, especially
> since the ITS is a separate, optional device.
> 
> You can find all of this code (and the prerequisites) in the
> its-emul/v8 branch of my repository [1].
> This has been briefly tested on the model and on GICv3 hardware.
> If you have GICv3 capable hardware, please test it on your setup.
> Also of course any review comments are very welcome!
> 
> Cheers,
> Andre.
> 
> Changelog v7..v8:
> - rebase on old-VGIC removal patch
> - add missing vgic_put_irq()s
> - check and ensure proper ITS initialisation sequence
> - avoid double collection mapping
> - renaming vits_ function prefixes to vgic_its_
> - properly setup PENDBASER (for new VGIC now)
> - change vgic_v2_probe init order to allow clean exit
> 
> Changelog v6..v7:
> - use kref reference counting
> - remove RCU usage from lpi_list, use spinlock instead
> - copy list of LPIs before accessing guest memory
> - introduce kvm_io_bus_get_dev()
> - refactor parts of arm-gic-v3.h header file
> - provide proper initial values for redistributor and ITS base registers
> - rework sanitisation of base registers
> - rework VGIC MMIO dispatching to differentiate between VGIC parts
> - smaller fixes, also comments and commit messages amended
> 
> Changelog v5..v6:
> - remove its_list from VGIC code
> - add lpi_list and accessor functions
> - introduce reference counting to struct vgic_irq
> - replace its_lock spinlock with its_cmd and its_lock mutexes
> - simplify guest memory accesses (due to the new mutexes)
> - avoid unnecessary affinity updates
> - refine base register address masking
> - introduce sanity checks for PROPBASER and PENDBASER
> - implement BASER<n> registers
> - pass struct vgic_its directly into the MMIO handlers
> - convert KVM_SIGNAL_MSI ioctl into an MMIO write
> - add explicit INIT ioctl to the ITS KVM device
> - adjusting comments and commit messages
> 
> Changelog v4..v5:
> - adapting to final new VGIC (MMIO handlers, etc.)
> - new KVM device to model an ITS, multiple instances allowed
> - move redistributor data into struct vgic_cpu
> - separate distributor and ITS(es)
> - various bug fixes and amended comments after review comments
> 
> Changelog v3..v4:
> - adapting to new VGIC (changes in IRQ injection mechanism)
> 
> Changelog v2..v3:
> - adapt to 4.3-rc and Christoffer's timer rework
> - adapt spin locks on handling PROPBASER/PENDBASER registers
> - rework locking in ITS command handling (dropping dist where needed)
> - only clear LPI pending bit if LPI could actually be queued
> - simplify GICR_CTLR handling
> - properly free ITTEs (including our pending bitmap)
> - fix corner cases with unmapped collections
> - keep retire_lr() around
> - rename vgic_handle_base_register to vgic_reg64_access()
> - use kcalloc instead of kmalloc
> - minor fixes, renames and added comments
> 
> Changelog v1..v2
> - fix issues when using non-ITS GICv3 emulation
> - streamline frame address initialization (new patch 05/15)
> - preallocate buffer memory for reading from guest's memory
> - move locking into the actual command handlers
> -   preallocate memory for new structures if needed
> - use non-atomic __set_bit() and __clear_bit() when under the lock
> - add INT command handler to allow LPI injection from the guest
> - rewrite CWRITER handler to align with new locking scheme
> - remove unneeded CONFIG_HAVE_KVM_MSI #ifdefs
> - check memory table size against our LPI limit (65536 interrupts)
> - observe initial gap of 1024 interrupts in pending table
> - use term "configuration table" to be in line with the spec
> - clarify and extend documentation on API extensions
> - introduce new KVM_CAP_MSI_DEVID capability to advertise device ID requirement
> - update, fix and add many comments
> - minor style changes as requested by reviewers

I'm done for this round. Some issues are relatively cosmetic and can be
fixed pretty quickly. Some others need more attention. Overall, you seem
to leave crumbles of previous designs, which makes it hard to follow
sometimes (I love SW archaeology as much as the next guy, but the GIC
has stopped exciting me a while ago...).

Looking forward to v9.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
