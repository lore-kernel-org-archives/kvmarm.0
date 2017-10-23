From: Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v5 00/10] vITS Migration fixes and reset
Date: Mon, 23 Oct 2017 16:08:19 +0200
Message-ID: <1508767709-15256-1-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D2DC449D20
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Oct 2017 10:07:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bgEfh8EqJaSP for <kvmarm@lists.cs.columbia.edu>;
 Mon, 23 Oct 2017 10:07:26 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9144D4078A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Oct 2017 10:07:26 -0400 (EDT)
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

Patches [1-5] attempt to fix the migration issues without
implementing the reset IOCTL.
They are candidate for stable:
- handle case where all collection, device and ITT entries are
  invalid on restore (which is not an error)
- Check the GITS_BASER<n> valid bit before attempting the save
  any table
- Check the GITS_BASER<n> and GITS_CBASER are valid before enabling
  the ITS
- save the collection table before device tables

Patches [6-10] allow to empty the caches on reset and implement a
new ITS reset IOCTL

Best Regards

Eric

Git: complete series available at
https://github.com/eauger/linux/tree/v4.14-rc5-its-reset-v5

* Testing:
- on Cavium using a virtio-net-pci guest and various sequences of
  guest shutdown -r now, virsh reset, virsh suspend/resume,
  virsh reboot, virsh save.restore, virsh shutdown

References:
[1] [RFC PATCH 0/3] fix migrate failed when vm is in booting
https://www.spinics.net/lists/kvm-arm/msg27121.html

History:
v4 -> v5:
- came back to the original version of
  KVM: arm/arm64: vgic-its: Fix return value for device table restore
  Rework of error handling will come later
- remove [PATCH v4 03/11] KVM: arm/arm64: vgic-its: Improve error reporting
  on device table save as of now
- remove KVM: arm/arm64: vgic-its: Always attempt to save/restore device
  and collection tables
  inversing the save order of device/collection tables fixes the same issue
- reword ITS IOCTL doc
- add mutex lock in vgic_its_free_collection_list
- remove vgic_its_unmap_device

v3 -> v4:
- fixes a bug in indirect mode: in handle_l1_dte, set
  *valid at the beginning of the function

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


Eric Auger (8):
  KVM: arm/arm64: vgic-its: Fix vgic_its_restore_collection_table
    returned value
  KVM: arm/arm64: vgic-its: Check CBASER/BASER validity before enabling
    the ITS
  KVM: arm/arm64: vgic-its: Check GITS_BASER Valid bit before saving
    tables
  KVM: arm/arm64: vgic-its: Save the collection table before device
    tables
  KVM: arm/arm64: vgic-its: Remove kvm_its_unmap_device
  KVM: arm/arm64: vgic-its: Free caches when GITS_BASER Valid bit is
    cleared
  KVM: arm/arm64: Document KVM_DEV_ARM_ITS_CTRL_RESET
  KVM: arm/arm64: vgic-its: Implement KVM_DEV_ARM_ITS_CTRL_RESET

wanghaibin (2):
  KVM: arm/arm64: vgic-its: Fix return value for device table restore
  KVM: arm/arm64: vgic-its: New helper functions to free the caches

 Documentation/virtual/kvm/devices/arm-vgic-its.txt |  21 +++
 arch/arm/include/uapi/asm/kvm.h                    |   1 +
 arch/arm64/include/uapi/asm/kvm.h                  |   1 +
 virt/kvm/arm/vgic/vgic-its.c                       | 205 ++++++++++++++-------
 4 files changed, 162 insertions(+), 66 deletions(-)

-- 
2.5.5
