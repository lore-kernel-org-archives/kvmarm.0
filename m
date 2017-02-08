From: Eric Auger <eric.auger@redhat.com>
Subject: [RFC v2 00/19] vITS save/restore
Date: Wed,  8 Feb 2017 12:43:13 +0100
Message-ID: <1486554212-2774-1-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4C1134092C
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Feb 2017 06:43:10 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id c5QPjAHVXOx4 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  8 Feb 2017 06:43:08 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BCCDE408E9
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Feb 2017 06:43:08 -0500 (EST)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, marc.zyngier@arm.com, christoffer.dall@linaro.org, vijayak@caviumnetworks.com, Vijaya.Kumar@cavium.com, peter.maydell@linaro.org, linux-arm-kernel@lists.infradead.org, drjones@redhat.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: andre.przywara@arm.com, pbonzini@redhat.com, dgilbert@redhat.com, quintela@redhat.com, Prasun.Kapoor@cavium.com
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

The series applies on top of Vijaya's series:
- [PATCH v11 0/8] arm/arm64: vgic: Implement API for vGICv3 live
  migration
  https://www.spinics.net/lists/arm-kernel/msg558046.html

Best Regards

Eric

Git: complete series available at
https://github.com/eauger/linux/tree/kvmarm-queue-vgic-mig-v11-its-rfcv2

applied on kvmarm queue.

* Testing:
- on Cavium ThunderX using a virtio-net-pci guest (x3 vNIC),
  virsh save/restore commands and virt-manager live migration.
  Tested with 1 and 2 stage device table.

History:

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


Eric Auger (19):
  KVM: arm/arm64: Add vITS save/restore API documentation
  KVM: arm/arm64: rename itte into ite
  arm/arm64: vgic: turn vgic_find_mmio_region into public
  KVM: arm64: ITS: KVM_DEV_ARM_VGIC_GRP_ITS_REGS group
  KVM: arm64: ITS: Implement vgic_its_has_attr_regs and attr_regs_access
  KVM: arm64: ITS: Implement vgic_mmio_uaccess_write_its_creadr
  KVM: arm64: ITS: Report the ITE size in GITS_TYPER
  KVM: arm64: ITS: Interpret MAPD Size field and check related errors
  KVM: arm64: ITS: Interpret MAPD ITT_addr field
  KVM: arm64: ITS: Check the device id matches TYPER DEVBITS range
  KVM: arm64: ITS: KVM_DEV_ARM_VGIC_GRP_ITS_TABLES group
  KVM: arm64: ITS: vgic_its_alloc_ite/device
  KVM: arm64: ITS: Sort the device and ITE lists
  KVM: arm64: ITS: Add infrastructure for table lookup
  KVM: arm64: ITS: Collection table save/restore
  KVM: arm64: ITS: vgic_its_check_id returns the entry's GPA
  KVM: arm64: ITS: ITT flush and restore
  KVM: arm64: ITS: Device table save/restore
  KVM: arm64: ITS: Pending table save/restore

 Documentation/virtual/kvm/devices/arm-vgic-its.txt |   78 ++
 arch/arm/include/uapi/asm/kvm.h                    |    2 +
 arch/arm64/include/uapi/asm/kvm.h                  |    2 +
 include/linux/irqchip/arm-gic-v3.h                 |    3 +
 virt/kvm/arm/vgic/vgic-its.c                       | 1031 ++++++++++++++++++--
 virt/kvm/arm/vgic/vgic-mmio.c                      |    3 +-
 virt/kvm/arm/vgic/vgic-mmio.h                      |   14 +-
 7 files changed, 1022 insertions(+), 111 deletions(-)

-- 
2.5.5
