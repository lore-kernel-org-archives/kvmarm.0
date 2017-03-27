From: Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v4 00/22] vITS save/restore
Date: Mon, 27 Mar 2017 11:30:50 +0200
Message-ID: <1490607072-21610-1-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4FE4A40A63
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Mar 2017 05:29:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ODRFYKDEcZNV for <kvmarm@lists.cs.columbia.edu>;
 Mon, 27 Mar 2017 05:29:26 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 14D1A40A14
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Mar 2017 05:29:25 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, marc.zyngier@arm.com, christoffer.dall@linaro.org, andre.przywara@arm.com, vijayak@caviumnetworks.com, Vijaya.Kumar@cavium.com, peter.maydell@linaro.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Prasun.Kapoor@cavium.com, quintela@redhat.com, dgilbert@redhat.com, pbonzini@redhat.com
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

Best Regards

Eric

Git: complete series available at
https://github.com/eauger/linux/tree/v4.11-rc3-its-mig-v4

* Testing:
- on Cavium ThunderX using a virtio-net-pci guest,
  virsh save/restore commands and virt-manager live migration.
  Tested with 1 and 2 stage device table.

History:
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

Eric Auger (22):
  KVM: arm/arm64: Add vITS save/restore API documentation
  KVM: arm/arm64: rename itte into ite
  arm/arm64: vgic: turn vgic_find_mmio_region into public
  KVM: arm64: ITS: KVM_DEV_ARM_VGIC_GRP_ITS_REGS group
  KVM: arm/arm64: vgic: expose (un)lock_all_vcpus
  KVM: arm64: ITS: Implement vgic_its_has_attr_regs and attr_regs_access
  KVM: arm64: ITS: Implement vgic_mmio_uaccess_write_its_creadr
  KVM: arm64: ITS: Implement vgic_mmio_uaccess_write_its_iidr
  KVM: arm64: ITS: Report the ITE size in GITS_TYPER
  KVM: arm64: ITS: Interpret MAPD Size field and check related errors
  KVM: arm64: ITS: Interpret MAPD ITT_addr field
  KVM: arm64: ITS: Check the device id matches TYPER DEVBITS range
  KVM: arm64: ITS: KVM_DEV_ARM_VGIC_GRP_ITS_TABLES group
  KVM: arm64: ITS: vgic_its_alloc_ite/device
  KVM: arm64: ITS: Sort the device and ITE lists
  KVM: expose next_segment()
  KVM: arm64: ITS: Add infrastructure for table lookup
  KVM: arm64: ITS: Collection table save/restore
  KVM: arm64: ITS: vgic_its_check_id returns the entry's GPA
  KVM: arm64: ITS: ITT flush and restore
  KVM: arm64: ITS: Device table save/restore
  KVM: arm64: ITS: Pending table save/restore

 Documentation/virtual/kvm/devices/arm-vgic-its.txt |  118 +++
 arch/arm/include/uapi/asm/kvm.h                    |    2 +
 arch/arm64/include/uapi/asm/kvm.h                  |    2 +
 include/kvm/arm_vgic.h                             |    2 +
 include/linux/irqchip/arm-gic-v3.h                 |    3 +
 include/linux/kvm_host.h                           |    8 +
 virt/kvm/arm/vgic/vgic-its.c                       | 1106 ++++++++++++++++++--
 virt/kvm/arm/vgic/vgic-kvm-device.c                |    4 +-
 virt/kvm/arm/vgic/vgic-mmio.c                      |   11 +-
 virt/kvm/arm/vgic/vgic-mmio.h                      |   14 +-
 virt/kvm/arm/vgic/vgic.h                           |    3 +
 virt/kvm/kvm_main.c                                |    8 -
 12 files changed, 1161 insertions(+), 120 deletions(-)

-- 
2.5.5
