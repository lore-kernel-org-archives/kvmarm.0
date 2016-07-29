From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [RFC v9 0/6] KVM: arm/arm64: gsi routing support
Date: Fri, 29 Jul 2016 08:51:17 +0200
Message-ID: <7637c5cb-76ab-a2ff-88f0-d7d63c3d8a74@redhat.com>
References: <1469204442-3220-1-git-send-email-eric.auger@redhat.com>
 <6ed49219-f9a7-e539-2bdb-920863299a4b@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <6ed49219-f9a7-e539-2bdb-920863299a4b@arm.com>
Sender: kvm-owner@vger.kernel.org
To: =?UTF-8?Q?Andr=c3=a9_Przywara?= <andre.przywara@arm.com>, eric.auger.pro@gmail.com, marc.zyngier@arm.com, christoffer.dall@linaro.org
Cc: drjones@redhat.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, pbonzini@redhat.com, rkrcmar@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi Andre,

On 29/07/2016 00:31, Andr=C3=A9 Przywara wrote:
> Hi,
>=20
> On 22/07/16 17:20, Eric Auger wrote:
>> With the advent of GICv3 ITS in-kernel emulation, KVM MSI routing
>> becomes mandated for proper VIRTIO-PCI vhost integration.
>>
>> In QEMU, when the VIRTIO-PCI device is programmed with the MSI messa=
ge,
>> we previously used direct_mapping trick: this consists in extracting=
 the
>> IRQ ID found in the MSI message and associating an irqfd to that IRQ=
 ID.
>> When vhost worker thread gets a new buffer it signals the irqfd and =
kvm
>> then injects this IRQ ID on guest. That way although the guest uses =
MSIs,
>> no MSI emulation is used.
>>
>> This worked fine with GICv2m but does not work anymore with GICV3 IT=
S.
>> Indeed this latter implements IRQ translation: what is found in the =
MSI
>> message no more is the target IRQ ID but is an intermediate event ID=
 used
>> in the translation process.
>>
>> Hence true MSI routing is needed so that the vhost back channel irqf=
d is
>> associated to a dummy gsi ID, routed towards the programmed MSI. Whe=
n KVM
>> injects the MSI through the in-kernel ITS emulation, the MSI is prop=
erly
>> translated and eventually the LPI ID associated to the event ID is i=
njected
>> on guest.
>>
>> MSI routing also mandates to integrate irqchip routing. The initial
>> implementation of irqfd on arm must be upgraded with the integration
>> of kvm irqchip.c code and the implementation of its standard hooks
>> in the architecture specific part.
>>
>> In case KVM_SET_GSI_ROUTING ioctl is not called, a default routing
>> table with flat irqchip routing entries is built enabling to inject =
gsi
>> corresponding to the SPI indexes seen by the guest.
>>
>> As soon as KVM_SET_GSI_ROUTING is called, user-space overwrites this
>> default routing table and is responsible for building the whole rout=
ing
>> table.
>>
>> for arm/arm64 KVM_SET_GSI_ROUTING has a limited support:
>> - only applies to KVM_IRQFD and not to KVM_IRQ_LINE
>>
>> - irqchip routing was tested on Calxeda midway (VFIO with irqfd)
>>   with and without explicit routing
>> - MSI routing was tested on AMD Overdrive and Cavium ThunderX
>>
>> Code + dependencies can be found at:
>> https://github.com/eauger/linux/tree/v4.7-rc7-its-emul-v10-gsi-routi=
ng-v9
>>
>> The series depends on
>>
>> [1]: [PATCH v10 00/17] KVM: arm64: GICv3 ITS emulation
>>      http://www.spinics.net/lists/kvm/msg135687.html
>>    + [PATCH] KVM: arm/arm64: fix vGICv2 KVM_DEV_ARM_VGIC_GRP_CPU/DIS=
T_REGS
>> [2]: [PATCH] KVM: arm/arm64: The GIC is dead, long live the GIC
>>
>> hence the RFC.
>>
>> GSI flat routing setup on QEMU can be found at:
>> https://lists.nongnu.org/archive/html/qemu-devel/2015-07/msg06262.ht=
ml
>=20
> So I gave this series (as part of -next atm) some testing on a Freesc=
ale
> machine.
>=20
> I quickly boot tested the following combinations of options:
> host kernel: next-20160728 and v4.7.0
> guest kernel: next-20160728 and v4.4.0
> QEMU: v2.6 and latest HEAD + Eric's ITS & GSI patches (from github)
>       gic-version=3D2 and gic-version=3D3
>       virtio-mmio and virtio-pci
> kvmtool: latest HEAD and vits-v7
>          --irqchip=3Dgic-{v2,v3,v3-its}
>          --force-pci and without (virtio-mmio)
>=20
> That summed up to 68 combinations for me, all booting fine. If every
> part supported ITS and MSIs (host kernel, userland tool, virtio-pci) =
I
> saw the ITS emulation being used.
> I also ran three guests (two QEMU and one kvmtool) in parallel with s=
ome
> interrupt load for some hours.
>=20
> For the records I could easily trigger our infamous kvmtool virtio ha=
ng
> with SMP guests on this machine, but as that happened with older kern=
els
> and kvmtools as well, affects only SMP guests and is totally absent w=
hen
> running with QEMU, it's not a regression and unrelated to this series=
=2E
>=20
> So FWIW:
>=20
> Tested-by: Andre Przywara <andre.przywara@arm.com>
Thank you very much for this testing time.

Cheers

Eric
>=20
> Cheers,
> Andre
>=20
>>
>> History:
>> v8 -> v9:
>> - remove "[RFC v8 7/7] KVM: arm: Enable KVM_SIGNAL_MSI and MSI routi=
ng"
>> - fix spi id check at IRQ injection
>> - use default in irqchip switch(ue->type)
>>
>> v7 -> v8:
>> - take into account Radim's comments:
>>   x rework kvm_kernel_irq_routing_entry and remove msi_msg now
>>     replaced by a custom struct
>>   x check user entry flags depending on user entry type
>>   x I kept last patch although challenged by Radim. It can be droppe=
d
>>     according to the consensus.
>>
>> v6 -> v7:
>> - take into account Drew's and Andre's comments
>> - new patch moving declarations of kvm_setup_default_irq_routing and
>>   kvm_setup_empty_irq_routing outside of kvm_host.h
>> - vgic_v2m_inject_msi moved in vgic-irqfd
>> - re-introduce irq.h
>> - add msi_ prefix to flags/devid kvm_kernel_irq_routing_entry fields
>> - move kvm_vgic_setup_default_irq_routing declaration in arm_vgic.h
>>   and definition in vgic-irqfd.c
>> - remove BUG_ON(!vgic_initialized(kvm) in vgic_irqfd_set_irq
>> - move KVM_IRQCHIP_NUM_PINS in arm_vgic.h and use VGIC_MAX_SPI inste=
ad
>>   of 1020
>>
>> v5 -> v6:
>> - rebase on Andre's v8 + removal of old vgic
>> - tested on Cavium ThunderX
>>
>> V4 -> v5:
>> - rebase on Andre's v7 + final new vgic code
>> - check msi->data is within SPI range in vgic_v2m_inject_msi
>> - squashed enable irq routing and default irqchip table patches
>> - handle default irqchip table allocation failure
>> - some rephrasing in doc & comment according to Christoffer's feedba=
cks
>> - lock issue reported by Pavel seems to have disappear after 4.2 (MS=
I injection
>>   fast path)
>>
>> v3 -> v4:
>> - rebase on top of NEW-VGIC RFC and ITS emulation series v4. This is=
 not
>>   a stable foundation yet. Hence the revert to RFC. This v4 mostly i=
s a
>>   reflesh/reminder.
>> - rewrite the cover letter
>>
>> v2 -> v3:
>> - don't use KVM_IRQ_ROUTING_EXTENDED_MSI type at uapi and kernel lev=
el anymore;
>>   use KVM_MSI_VALID_DEVID flag instead
>> - propagate user flags downto the kernel to make sure the userspace
>>   correctly set devid in GICv3 ITS case (still under discussion)
>>
>> v1 -> v2:
>> - user API changed:
>>   x devid id passed in kvm_irq_routing_msi
>>   x kept the new routing entry type: KVM_IRQ_ROUTING_EXTENDED_MSI
>> - kvm_host.h: adopt Andre's proposal to replace the msi_msg by a str=
uct
>>   composed of the msi_msg and devid in kvm_kernel_irq_routing_entry
>> - Fix bug reported by Pavel: Added KVM_IRQ_ROUTING_EXTENDED_MSI hand=
ling
>>   in eventfd.c
>> - added vgic_v2m_inject_msi in vgic-v2-emul.c as suggested by Andre
>> - fix bug reported by Andre: bad setting of msi.flags and msi.devid
>>   in kvm_send_userspace_msi
>> - avoid injecting reserved IRQ numbers in vgic_irqfd_set_irq
>>
>> RFC -> PATCH:
>> - clearly state limited support on arm/arm64:
>>   KVM_IRQ_LINE not impacted by GSI routing
>> - add default routing table feature (new patch file)
>> - changed uapi to use padding field area
>> - reword api.txt
>>
>>
>> Eric Auger (6):
>>   KVM: api: Pass the devid in the msi routing entry
>>   KVM: Add devid in kvm_kernel_irq_routing_entry
>>   KVM: irqchip: Convey devid to kvm_set_msi
>>   KVM: Move kvm_setup_default/empty_irq_routing declaration in arch
>>     specific header
>>   KVM: arm/arm64: Enable irqchip routing
>>   KVM: arm/arm64: Enable MSI routing
>>
>>  Documentation/virtual/kvm/api.txt |  34 +++++++++---
>>  arch/arm/kvm/Kconfig              |   2 +
>>  arch/arm/kvm/Makefile             |   1 +
>>  arch/arm/kvm/irq.h                |  19 +++++++
>>  arch/arm64/kvm/Kconfig            |   2 +
>>  arch/arm64/kvm/Makefile           |   1 +
>>  arch/arm64/kvm/irq.h              |  19 +++++++
>>  arch/x86/kvm/irq.h                |   3 ++
>>  include/kvm/arm_vgic.h            |   7 +++
>>  include/linux/kvm_host.h          |  12 +++--
>>  include/uapi/linux/kvm.h          |   5 +-
>>  virt/kvm/arm/vgic/vgic-init.c     |   4 ++
>>  virt/kvm/arm/vgic/vgic-irqfd.c    | 108 +++++++++++++++++++++++++++=
++++-------
>>  virt/kvm/arm/vgic/vgic.c          |   7 ---
>>  virt/kvm/irqchip.c                |  28 ++++++----
>>  15 files changed, 207 insertions(+), 45 deletions(-)
>>  create mode 100644 arch/arm/kvm/irq.h
>>  create mode 100644 arch/arm64/kvm/irq.h
>>
