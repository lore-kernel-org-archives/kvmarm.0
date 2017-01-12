From: Eric Auger <eric.auger@redhat.com>
Subject: [RFC 00/13] vITS save/restore
Date: Thu, 12 Jan 2017 16:56:40 +0100
Message-ID: <1484236613-24633-1-git-send-email-eric.auger@redhat.com>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, marc.zyngier@arm.com, christoffer.dall@linaro.org, vijayak@caviumnetworks.com, Vijaya.Kumar@cavium.com, peter.maydell@linaro.org, linux-arm-kernel@lists.infradead.org, drjones@redhat.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: andre.przywara@arm.com, Prasun.Kapoor@cavium.com, pbonzini@redhat.com, dgilbert@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

This series specifies and implements an API aimed at saving and restoring
the state of the in-kernel emulated ITS device.

The ITS is programmed through registers and tables. Those later tables
are allocated by the guest.  Their base address is programmed in
registers or table entries before the ITS is enabled.

The ITS is free to use some of them to flush its internal caches. This
is likely to be used when entering low power state.

Therefore, for save/restore use case, it looks natural to use this
guest RAM allocated space to save the table related data. However,
currently,The ITS in-kernel emulated device does not use all of those
tables and for those it uses, it does not always sync them with its
cached data. Additional sync must happen for:
- the collection table
- the device table
- the per-device translation tables
- the LPI pending tables.

The LPI configration table and the command queues do not need extra
syncs.

So the bulk of the work in this series consists in the table
save/restore rather than register save/restore.

An alternative to flushing the tables into guest RAM could have been
to flush them into a separate user-space buffer. However the drawback
of this alternative is that the virtualizer would allocate dedicated
buffers to store the data that should normally be laid out in guest
RAM. It would also be obliged to re-compute their size from
register/table content.

So saving the tables in guest RAM better fit the ITS programming
model and optimizes the memory usage. The drawback of this solution
is it brings additional challenges at user-space level to make sure
the guest RAM is frozen after table sync.

The code is functional while saving/restoring a guest using
virtio-net-pci.  However many points deserve additional tests.
I share the series at that stage to get the documentation reviewed
and main principles discussed.

The series applies on top of Vijaya's series:
- [PATCH v10 0/8] arm/arm64: vgic: Implement API for vGICv3 live
  migration
  http://www.spinics.net/lists/arm-kernel/msg546383.html

Best Regards

Eric

Git: complete series available at
https://github.com/eauger/linux/tree/v4.10-rc3-its-mig-rfc-v1

* Testing:
- on Cavium using a virtio-net-pci guest and virsh save/restore
  commands

Eric Auger (13):
  KVM: arm/arm64: Add vITS save/restore API documentation
  arm/arm64: vgic: turn vgic_find_mmio_region into public
  KVM: arm64: ITS: KVM_DEV_ARM_VGIC_GRP_ITS_REGS group
  KVM: arm64: ITS: Implement vgic_its_has_attr_regs and attr_regs_access
  KVM: arm64: ITS: Implement vgic_mmio_uaccess_write_its_creadr
  KVM: arm64: ITS: Expose ITT_Entry_Size in GITS_TYPER
  KVM: arm64: ITS: Change entry_size and indirect bit in BASER
  KVM: arm64: ITS: On MAPD interpret and store itt_addr and size
  KVM: arm64: ITS: KVM_DEV_ARM_VGIC_GRP_ITS_TABLES group
  KVM: arm64: ITS: vgic_its_alloc_itte/device
  KVM: arm64: ITS: Collection table save/restore
  KVM: arm64: ITS: Device and translation table flush
  KVM: arm64: ITS: Pending table save/restore

 Documentation/virtual/kvm/devices/arm-vgic-its.txt |  70 +++
 arch/arm/include/uapi/asm/kvm.h                    |   2 +
 arch/arm64/include/uapi/asm/kvm.h                  |   2 +
 include/kvm/arm_vgic.h                             |   3 +
 include/linux/irqchip/arm-gic-v3.h                 |   1 +
 virt/kvm/arm/vgic/vgic-its.c                       | 655 +++++++++++++++++++--
 virt/kvm/arm/vgic/vgic-mmio.c                      |   3 +-
 virt/kvm/arm/vgic/vgic-mmio.h                      |  14 +-
 8 files changed, 705 insertions(+), 45 deletions(-)

-- 
2.5.5

