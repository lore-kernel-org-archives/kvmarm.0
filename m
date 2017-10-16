From: Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v3 00/11] vITS Migration fixes and reset
Date: Mon, 16 Oct 2017 17:03:21 +0200
Message-ID: <1508166212-9599-1-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5C30949D2D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Oct 2017 11:02:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oAJ3OCQMMqYA for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 Oct 2017 11:02:51 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3B82249D2B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Oct 2017 11:02:51 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, cdall@linaro.org, peter.maydell@linaro.org, andre.przywara@arm.com, wanghaibin.wang@huawei.com
Cc: wu.wubin@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

This series fixes various bugs observed when saving/restoring the
ITS state before the guest writes the ITS registers (on first boot or
after reset/reboot).

This is a follow up of Wanghaibin's series [1] plus additional
patches following additional code review. It also proposes one
ITS reset implementation.

Currently, the in-kernel emulated ITS is not reset. After a
reset/reboot, the ITS register values and caches are left
unchanged. Registers may point to some tables in guest memory
which do not exist anymore. If an ITS state backup is initiated
before the guest re-writes the registers, the save fails
because inconsistencies are detected. Also restore of data saved
as such moment is failing.

Patches [1-7] attempt to fix the migration issues without
implementing the reset.
As such they may be candidate for stable:
- handle case where all collection, device and ITT entries are
  invalid on restore (which shouldn't be an error)
- limit the cases where we return -EINVAL in table save()
- never attempt to use GITS_BASER<n> and GITS_CBASER if they are
  not valid.
- Check GITS_BASER<n> and GITS_CBASER on ITS enable
- systematically do both device and collection save/restore even if
  one fails.

Patches [8-11] implement a new ITS reset IOCTL

Best Regards

Eric

Git: complete series available at
https://github.com/eauger/linux/tree/v4.14-rc5-its-reset-v3

* Testing:
- on Cavium using a virtio-net-pci guest and various sequences of
  guest shutdown -r now, virsh reset, virsh suspend/resume,
  virsh reboot, virsh save.restore, virsh shutdown

References:
[1] [RFC PATCH 0/3] fix migrate failed when vm is in booting
https://www.spinics.net/lists/kvm-arm/msg27121.html

History:
v2 -> v3:
- Revisited error handling in restore functions
- Added "KVM: arm/arm64: vgic-its: fix
        vgic_its_restore_collection_table returned value"
- Added "KVM: arm/arm64: vgic-its: Check CBASER/BASER validity
  before enabling the ITS"
- Removed KVM: arm/arm64: vgic-its: Always allow clearing
  GITS_CREADR/CWRITER
- Reworded documentation according to Christoffer's comments

v1 -> v2:
- added KVM: arm/arm64: vgic-its: Always attempt to save/restore
  device and collection tables

PATCH v1
- series including 2 modified patches of Wanghaibin


Eric Auger (10):
  KVM: arm/arm64: vgic-its: fix return value for device table restore
  KVM: arm/arm64: vgic-its: fix vgic_its_restore_collection_table
    returned value
  KVM: arm/arm64: vgic-its: Improve error reporting on device table save
  KVM: arm/arm64: vgic-its: Check CBASER/BASER validity before enabling
    the ITS
  KVM: arm/arm64: vgic-its: Check GITS_BASER Valid bit before saving
    tables
  KVM: arm/arm64: vgic-its: Check GITS_CBASER validity before processing
    commands
  KVM: arm/arm64: vgic-its: Always attempt to save/restore device and
    collection tables
  KVM: arm/arm64: vgic-its: free caches when GITS_BASER Valid bit is
    cleared
  KVM: arm/arm64: Document KVM_DEV_ARM_ITS_CTRL_RESET
  KVM: arm/arm64: vgic-its: Implement KVM_DEV_ARM_ITS_CTRL_RESET

wanghaibin (1):
  KVM: arm/arm64: vgic-its: new helper functions to free the caches

 Documentation/virtual/kvm/devices/arm-vgic-its.txt |  20 ++
 arch/arm/include/uapi/asm/kvm.h                    |   1 +
 arch/arm64/include/uapi/asm/kvm.h                  |   1 +
 virt/kvm/arm/vgic/vgic-its.c                       | 357 ++++++++++++++-------
 4 files changed, 267 insertions(+), 112 deletions(-)

-- 
2.5.5
