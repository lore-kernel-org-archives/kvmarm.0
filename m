From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH v11 0/4] machvirt dynamic sysbus device instantiation
Date: Wed,  4 Mar 2015 16:18:25 +0000
Message-ID: <1425485909-5091-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4140047B58
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Mar 2015 11:12:42 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7dFJHD78CRVk for <kvmarm@lists.cs.columbia.edu>;
 Wed,  4 Mar 2015 11:12:41 -0500 (EST)
Received: from mail-wg0-f44.google.com (mail-wg0-f44.google.com [74.125.82.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D8A4547B47
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Mar 2015 11:12:39 -0500 (EST)
Received: by wggz12 with SMTP id z12so47846166wgg.2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 04 Mar 2015 08:18:42 -0800 (PST)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@st.com, qemu-devel@nongnu.org, peter.maydell@linaro.org
Cc: patches@linaro.org, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

This patch series enables machvirt to dynamically instantiate sysbus
devices from command line (using -device option).

All those sysbus devices are plugged onto a platform bus. This latter
device is instantiated in machvirt and takes care of the binding of
children sysbus devices on a machine init done notifier. The device
tree node generation for children dynamic sysbus device also happens
on a subsequent notifier that must be executed after the above one.
machvirt registers that notifier before the platform bus creation to
make sure notifiers are executed in the right order: dt generation after
actual QOM binding.

Very few sysbus devices are supposed to be instantiated that
way. VFIO devices belong to them.

Node creation really is architecture specific. On ARM the dynamic
sysbus device node creation is implemented in a new C module,
hw/arm/sysbus-fdt.c and not in the machine file.

Machvirt transformations and sysbus-fdt are largely inspired from Alex work.

The patch series can be found at:
http://git.linaro.org/people/eric.auger/qemu.git,
branch official_dynsysbus_v11

Best Regards

Eric

v10 -> v11:
- rebase on v2.2.0 and especially Alex'
  "arm: Add PCIe host bridge in virt machine"

v9 -> v10:
- add assert and fix return value in add_fdt_node

v8 -> v9:
Take into account Peter's comments:
hw/arm/sysbus-fdt:
- s/Fdt/FDT in struct type names
- reorder fields in PlatformBusFdtNotifierParams and use DO_UPCAST
- use assert() when relevant (board model issue)
- g_free the ARMPlatformBusFDTParams and PlatformBusFDTNotifierParams
  pointers in platform_bus_fdt_notify
hw/arm/boot.c
- fix compilation with arm-linux-user
- reorder fields in ArmLoadKernelNotifier
hw/arm/virt.c
- PLATFORM_BUS_NUM_IRQS set to 32 instead of 20
- platform bus irq now start at 64 instead of 48
- remove change of indentation in  a15memmap
- correct misc style issues

add a separate patch file for re-indentation in virt a15memmap

v7 -> v8:
- rebase on 2.2.0 (boot.c and virt.c)
- in virt.c machvirt_init, create_platform_bus simply is added
  after the arm_load_kernel call instead of moving this latter.
  should ease the review.
- Add Alex & Shannon Reviewed-by

v6 -> v7:
Take into account Shannon's comments:
- hw/arm/sysbus-fdt.c: revert indentation in add_fdt_node_functions
- hw/arm/virt.c:
  - add an additional comment in a15irqmap related to PLATFORM_BUS_NUM_IRQS
  - correct platform bus size to 0x400000
  - remove PLATFORM_BUS_FIRST_IRQ macro

v5 -> v6:
Take into account Peter's comments:
- dtb overload mechanism rewritten: arm_load_kernel code is moved into a
  machine init done notifier notify instead. arm_load_kernel only registers
  that notifier. As a consequence the dtb is loaded once.
- v5 1-4 patch files are removed and replaced by a single patch file moving
  arm_load_kernel in the notifier (2).
- as a consequence arm_load_kernel must be called before sysbus-fdt
  arm_register_platform_bus_fdt_creator.
- In virt, platform_bus_params not a const anymore since its fields are
  initialized from vbi->memmap and vbi->irqmap. Hence create_platform_bus
  proto can be simplified.
- In sysbus-fdt add_all_platform_bus_fdt_nodes now takes a handle to
  an ARMPlatformBusFdtParams. This is not a modify_dtb function anymore
  fdt pointer is checked in case the callback is called after the load_dtb
  (this latter deallocated fdt pointer). Check of fdt_filename moved in here.
  upgrade_dtb is removed. copyright aligned between .h and .c.

v4 -> v5:
- in virt.c: platform_bus_params becomes static const
- sysbus-fdt: change indentation in add_fdt_node_functions array init
- s/load_dtb/arm_load_dtb in one boot.c comment

v3 -> v4:
- dyn_sysbus_binding removed since binding stuff now are implemented by
  the platform bus device
- due to a change in ARM load_dtb implementation using rom_add_blob_fixed,
  the dt no more is generated in a reset notifier but is generated on a
  machine init done notifier
- the augmented device tree is not generated from scratch anymore but is
  added using a modify_dtb function. This required some small change in
  boot.c
- the case where the user provides a dtb file now is handled
- some cleanup in virt additions
- implement a list of dyanmically instantiable devices in sysbus-fdt

v2 -> v3:
- patch now applies on top of Alex full patchset
- dyn_sysbus_devtree: add arm_prefix to emphasize the fact those
  functions are arm specific; arm_sysbus_device_create_devtree
  becomes static
- load_dtb renamed into arm_load_dtb
- add copyright in hw/arm/dyn_sysbus_devtree.c

v1 -> v2:
- device node generation no more in sysbus device but in
  dyn_sysbus_devtree
- VFIO region shrinked to 4MB and relocated in machvirt to avoid PCI
  shrink (dynamic vfio-mmio support might come latter)
- platform_bus_base removed from PlatformDevtreeData


Eric Auger (4):
  hw/arm/sysbus-fdt: helpers for platform bus nodes addition
  hw/arm/boot: arm_load_kernel implemented as a machine init done
    notifier
  hw/arm/virt: add dynamic sysbus device support
  hw/arm/virt: change indentation in a15memmap

 hw/arm/Makefile.objs        |   1 +
 hw/arm/boot.c               |  14 +++-
 hw/arm/sysbus-fdt.c         | 174 ++++++++++++++++++++++++++++++++++++++++++++
 hw/arm/virt.c               |  85 ++++++++++++++++++----
 include/hw/arm/arm.h        |  28 +++++++
 include/hw/arm/sysbus-fdt.h |  60 +++++++++++++++
 6 files changed, 348 insertions(+), 14 deletions(-)
 create mode 100644 hw/arm/sysbus-fdt.c
 create mode 100644 include/hw/arm/sysbus-fdt.h

-- 
1.8.3.2
