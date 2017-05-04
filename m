From: Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v6 00/24] vITS save/restore
Date: Thu,  4 May 2017 13:44:20 +0200
Message-ID: <1493898284-29504-1-git-send-email-eric.auger@redhat.com>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, marc.zyngier@arm.com, christoffer.dall@linaro.org, andre.przywara@arm.com, vijayak@caviumnetworks.com, Vijaya.Kumar@cavium.com, peter.maydell@linaro.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Prasun.Kapoor@cavium.com, drjones@redhat.com, pbonzini@redhat.com, dgilbert@redhat.com, quintela@redhat.com, bjsprakash.linux@gmail.com
List-Id: kvmarm@lists.cs.columbia.edu

This series specifies and implements an API aimed at saving and restoring
the state of the in-kernel emulated ITS device.

The ITS is programmed through registers and tables. Those latter
are allocated by the guest. Their base address is programmed in
registers or table entries before the ITS is enabled.

The ITS is free to use some of them to flush its internal caches. This
is likely to be used when entering low power state.

Therefore, for save/restore use case, it looks natural to use this
guest RAM allocated space to save the table related data. However,
currently, The ITS in-kernel emulated device does not use all of those
tables and for those it uses, it does not always sync them with its
cached data. Additional sync must happen for:
- the collection table
- the device table
- the per-device translation tables
- the LPI pending tables.

The LPI configation table and the command queues do not need extra
syncs.

Best Regards

Eric

Git: complete series available at
https://github.com/eauger/linux/tree/v4.11-its-mig-v6

* Testing:
- on Cavium ThunderX using a virtio-net-pci guest,
  virsh save/restore commands and virt-manager live migration.
  Tested with 1 and 2 stage device table.

History:
v5 -> v6:
- address Christoffer's comments:
  - add restore sequence in the doc
  - sync with pending and config tables in its_add_lpi
  - change in return values when scanning the tables
  - several bug fixes pointed out by Christoffer
  - see full details in individual logs

v4 -> v5:
- user API changes:
  - ITS table save/restore triggered through ITS KVM device
    KVM_DEV_ARM_VGIC_GRP_CTRL group, KVM_DEV_ARM_ITS_SAVE_TABLES,
    KVM_DEV_ARM_ITS_RESTORE_TABLES
  - RDIST pending table flush triggered through GICV3 KVM device
    KVM_DEV_ARM_VGIC_GRP_CTRL/KVM_DEV_ARM_VGIC_SAVE_PENDING_TABLES
- Introduce an ABI infrastructure, entry size report using this infra
- IIDR reports ABI chosen set by userspace if any
- pending table save moved to vgic-v3.c
- use optimisation in pending table save
- check target_addr when restore cte
- pending table sync called from restore_tables
- added KVM: arm64: vgic-its: Fix pending table sync
- simplify loopup_table and use kvm_read_guest()
- sort the device and ITE list on save
- add defines for shifts and masks, GIC_ENCODE_SZ macro

v3 -> v4:
- update the DTE format (ITT_addr 52 bit support, validity bit addition)
- Document ABI revision and implement check
- iidr save/restore (including a new patch for iidr user write access)
- changed locking: kvm lock + vcpu lock
- fix nb_eventid_bits mixup
- 2 new patches aiming at exposing next_segment() and lock_all_vcpus()
- rework errror handling of lookup_table functions

- I took into account all Andre's comments/suggestions except:
  - trigger the save/restore of pending tables from GICV3 KVM device
    instead of ITS KVM device
  - implement ITS flush/restore in KVM_DEV_ARM_VGIC_GRP_CTRL
    ITS group

See the ML replies for current justifications. In case other people
strongly disagree of course I will change the code.

v2 -> v3:
- fix restore ITS ITT_addr bit masking

v1 -> v2:
- rebased on Vijaya's v11
- all entries now are 8 byte large
- devid/eventid indexing for device table and ITT
- support 2 stage device table
- common infra to read indexed tables
- add cpu <-> le64 conversions
- itte renamed into ite
- do not care anymore about pending table 1st KB
  (not needed at the moment for coarse mapping)

RFC v1
- creation


Eric Auger (24):
  KVM: arm/arm64: Add ITS save/restore API documentation
  KVM: arm/arm64: Add GICV3 pending table save API documentation
  KVM: arm/arm64: vgic-its: rename itte into ite
  arm/arm64: vgic: turn vgic_find_mmio_region into public
  KVM: arm64: vgic-its: KVM_DEV_ARM_VGIC_GRP_ITS_REGS group
  KVM: arm/arm64: vgic: expose (un)lock_all_vcpus
  KVM: arm64: vgic-its: Implement vgic_its_has_attr_regs and
    attr_regs_access
  KVM: arm64: vgic-its: Implement vgic_mmio_uaccess_write_its_creadr
  KVM: arm64: vgic-its: Introduce migration ABI infrastructure
  KVM: arm64: vgic-its: Implement vgic_mmio_uaccess_write_its_iidr
  KVM: arm64: vgic-its: Interpret MAPD Size field and check related
    errors
  KVM: arm64: vgic-its: Interpret MAPD ITT_addr field
  KVM: arm64: vgic-its: Check the device id matches TYPER DEVBITS range
  KVM: arm64: vgic-v3: vgic_v3_lpi_sync_pending_status
  KVM: arm64: vgic-its: Read config and pending bit in add_lpi()
  KVM: arm64: vgic-its: KVM_DEV_ARM_ITS_SAVE/RESTORE_TABLES
  KVM: arm64: vgic-its: vgic_its_alloc_ite/device
  KVM: arm64: vgic-its: Add infrastructure for table lookup
  KVM: arm64: vgic-its: Collection table save/restore
  KVM: arm64: vgic-its: vgic_its_check_id returns the entry's GPA
  KVM: arm64: vgic-its: Device table save/restore
  KVM: arm64: vgic-its: ITT save and restore
  KVM: arm64: vgic-its: Fix pending table sync
  KVM: arm64: vgic-v3: KVM_DEV_ARM_VGIC_SAVE_PENDING_TABLES

 Documentation/virtual/kvm/devices/arm-vgic-its.txt |  117 ++
 Documentation/virtual/kvm/devices/arm-vgic-v3.txt  |    6 +
 arch/arm/include/uapi/asm/kvm.h                    |    6 +-
 arch/arm64/include/uapi/asm/kvm.h                  |    6 +-
 include/kvm/arm_vgic.h                             |    3 +
 include/linux/irqchip/arm-gic-v3.h                 |   14 +
 virt/kvm/arm/vgic/vgic-its.c                       | 1148 +++++++++++++++++---
 virt/kvm/arm/vgic/vgic-kvm-device.c                |   24 +-
 virt/kvm/arm/vgic/vgic-mmio.c                      |   11 +-
 virt/kvm/arm/vgic/vgic-mmio.h                      |   14 +-
 virt/kvm/arm/vgic/vgic-v3.c                        |   95 ++
 virt/kvm/arm/vgic/vgic.h                           |   28 +
 12 files changed, 1330 insertions(+), 142 deletions(-)

-- 
2.5.5
