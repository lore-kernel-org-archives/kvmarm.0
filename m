From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH v11 0/9] KVM platform device passthrough
Date: Thu, 19 Mar 2015 10:05:29 +0000
Message-ID: <1426759538-18030-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 89B67491F6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Mar 2015 05:59:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GyQKEP9asPSH for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 Mar 2015 05:59:06 -0400 (EDT)
Received: from mail-we0-f169.google.com (mail-we0-f169.google.com
 [74.125.82.169])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 00D43491F2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Mar 2015 05:59:05 -0400 (EDT)
Received: by wegp1 with SMTP id p1so52991105weg.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Mar 2015 03:05:46 -0700 (PDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@st.com, eric.auger@linaro.org, qemu-devel@nongnu.org, alex.williamson@redhat.com, peter.maydell@linaro.org, agraf@suse.de, b.reynal@virtualopensystems.com
Cc: patches@linaro.org, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

This series aims at enabling KVM platform device passthrough.

Kernel dependencies were pulled for 4.1-rc0 (vfio platform driver and
irqfd for ARM)

This series now only relies on the following QEMU series that allows
to instantiate the VFIO platform device from QEMU command line:

[1] [PATCH v11 0/4] machvirt dynamic sysbus device instantiation
    https://lists.gnu.org/archive/html/qemu-devel/2015-03/msg00804.html

Both series are candidate for QEMU 2.4.

- QEMU pieces can be found at:
  http://git.linaro.org/people/eric.auger/qemu.git
  (branch vfio_integ_v11)

- kernel pieces can be found at:
  http://git.linaro.org/people/eric.auger/linux.git
  (branch vfio_integ_v11_kernel)

The series was tested on Calxeda Midway (ARMv7) where one xgmac
is assigned to KVM host while the second one is assigned to the guest.

Wiki for Calxeda Midway setup:
https://wiki.linaro.org/LEG/Engineering/Virtualization/Platform_Device_Passthrough_on_Midway

History:
v10->v11:
- rebase onto v2.3.0-rc0 (mainly related to PCIe support in virt)
- add dma-coherent property for calxeda midway (fix revealed by removal
  of kernel-side "vfio: type1: support for ARM SMMUS with VFIO_IOMMU_TYPE1")
- virt modifications to start VFIO IRQ forwarding are now in a separate
  patch
- rearrange linux header exports (those are still partial exports
  waiting for definitive 4.1-rc0)
- take into account Alex Bennee comments:
  - use g_malloc0_n instead of g_malloc0
  - use block declarations when possible
  - rework readlink returned value treatment
  - use g_strlcat in place strncat
  - re-arrange mutex locking for multiple IRQ support (user-side handled
    eventfds)
- use g_snprintf instead of snprintf
- change the order of functions to avoid pre-declaration in platform.c
- add flags in VFIOINTp struct to detect whether the IRQ is automasked
- some comment rewriting

v9->v10:
- rebase on "vfio: cleanup vfio_get_device error path, remove
  vfio_populate_device": vfio_populate_device no more called in
  vfio_get_device but in vfio_base_device_init
- update VFIO header according to vfio platform driver v13 (no AMBA)

v8->v9:
- rebase on 2.2.0 and machvirt dynamic sysbus instantiation v10
- v8 1-11 were pulled
- patch files related to forwarding are moved in a seperate series since
  it depends on kernel series still in RFC.
- introduction of basic VFIO platform device split into 3 patch files to
  ease the review (hope it will help).
- add an author in platform.c
- add deallocation in vfio_populate_device error case
- add patch file doing the VFIO header sync
- use VFIO_DEVICE_FLAGS_PLATFORM in vfio_populate_device
- rename calxeda_xgmac.c into calxeda-xgmac.c
- sysbus-fdt: add_calxeda_midway_xgmac_fdt_node g_free in case of errors
- reword of linux-headers patch files

v7->v8:
- rebase on v2.2.0-rc3 and integrate
  "Add skip_dump flag to ignore memory region during dump"
- KVM header evolution with subindex addition in kvm_arch_forwarded_irq
- split [PATCH v7 03/16] hw/vfio/pci: introduce VFIODevice into 4 patches
- vfio_compute_needs_reset does not return bool anymore
- add some comments about exposed MMIO region and IRQ in calxeda xgmac
  device
- vfio_[un]mask_irqindex renamed into vfio_[un]mask_single_irqindex
- rework IRQ startup: former machine init done notifier is replaced by a
  reset notifier. machine file passes the interrupt controller
  DeviceState handle (not the platform bus first irq parameter).
- sysbus-fdt:
  - move the add_fdt_node_functions array declaration between the device
    specific code and the generic code to avoid forward declarations of
    decice specific functions
  - rename add_basic_vfio_fdt_node into add_calxeda_midway_xgmac_fdt_node
    emphasizing the fact it is xgmac specific

v6->v7:
- fake injection test modality removed
- VFIO_DEVICE_TYPE_PLATFORM only introduced with VFIO platform
- new helper functions to start VFIO IRQ on machine init done notifier
  (introduced in hw/vfio/platform: add vfio-platform support and notifier
  registration invoked in hw/arm/virt: add support for VFIO devices).
  vfio_start_irq_injection is replaced by vfio_register_irq_starter.

v5->v6:
- rebase on 2.1rc5 PCI code
- forwarded IRQ first integraton
- vfio_device property renamed into host property
- split IRQ setup in different functions that match the 3 supported
  injection techniques (user handled eventfd, irqfd, forwarded IRQ):
  removes dynamic switch between injection methods
- introduce fake interrupts as a test modality:
  x makes possible to test multiple IRQ user-side handling.
  x this is a test feature only: enable to trigger a fd as if the
    real physical IRQ hit. No virtual IRQ is injected into the guest
    but handling is simulated so that the state machine can be tested
- user handled eventfd:
  x add mutex to protect IRQ state & list manipulation,
  x correct misleading comment in vfio_intp_interrupt.
  x Fix bugs using fake interrupt modality
- irqfd no more advertised in this patchset (handled in [3])
- VFIOPlatformDeviceClass becomes abstract and Calxeda xgmac device
  and class is re-introduced (as per v4)
- all DPRINTF removed in platform and replaced by trace-points
- corrects compilation with configure --disable-kvm
- simplifies the split for vfio_get_device and introduce a unique
  specialized function named vfio_populate_device
- group_list renamed into vfio_group_list
- hw/arm/dyn_sysbus_devtree.c currently only support vfio-calxeda-xgmac
  instantiation. Needs to be specialized for other VFIO devices
- fix 2 bugs in dyn_sysbus_devtree(reg_attr index and compat)

v4->v5:
- rebase on v2.1.0 PCI code
- take into account Alex Williamson comments on PCI code rework
  - trace updates in vfio_region_write/read
  - remove fd from VFIORegion
  - get/put ckeanup
- bug fix: bar region's vbasedev field duly initialization
- misc cleanups in platform device
- device tree node generation removed from device and handled in
  hw/arm/dyn_sysbus_devtree.c
- remove "hw/vfio: add an example calxeda_xgmac": with removal of
  device tree node generation we do not have so many things to
  implement in that derived device yet. May be re-introduced later
  on if needed typically for reset/migration.
- no GSI routing table anymore

v3->v4 changes (Eric Auger, Alvise Rigo)
- rebase on last VFIO PCI code (v2.1.0-rc0)
- full git history rework to ease PCI code change review
- mv include files in hw/vfio
- DPRINTF reformatting temporarily moved out
- support of VFIO virq (removal of resamplefd handler on user-side)
- integration with sysbus dynamic instantiation framwork
- removal of unrealize and cleanup routines until it is better
  understood what is really needed
- Support of VFIO for Amba devices should be handled in an inherited
  device to specialize the device tree generation (clock handle currently
  missing in framework however)
- "Always use eventfd as notifying mechanism" temporarily moved out
- static instantiation is not mainstream (although it remains possible)
  note if static instantiation is used, irqfd must be setup in machine file
  when virtual IRQ is known
- create the GSI routing table on qemu side

v2->v3 changes (Alvise Rigo, Eric Auger):
- Following Alex W recommandations, further efforts to factorize the
  code between PCI:introduction of VFIODevice and VFIORegion
  as base classes
- unique reset handler for platform and PCI
- cleanup following Kim's comments
- multiple IRQ support mechanics should be in place although not
  tested
- Better handling of MMIO multiple regions
- New features and fixes by Alvise (multiple compat string, exec
  flag, force eventfd usage, amba device tree support)
- irqfd support

v1->v2 changes (Kim Phillips, Eric Auger):
- IRQ initial support (legacy mode where eventfds are handled on
  user side)
- hacked dynamic instantiation

v1 (Kim Phillips):
- initial split between PCI and platform
- MMIO support only
- static instantiation

Best Regards

Eric


Eric Auger (9):
  linux-headers: update VFIO header for VFIO platform/amba drivers
  hw/vfio/platform: vfio-platform skeleton
  hw/vfio/platform: add irq assignment
  hw/vfio/platform: add capability to start IRQ propagation
  hw/arm/virt: start VFIO IRQ propagation
  hw/vfio/platform: calxeda xgmac device
  hw/arm/sysbus-fdt: enable vfio-calxeda-xgmac dynamic instantiation
  linux-headers: update arm/arm64 KVM headers for irqfd
  hw/vfio/platform: add irqfd support

 hw/arm/sysbus-fdt.c                  |  72 ++++
 hw/arm/virt.c                        |  34 +-
 hw/vfio/Makefile.objs                |   2 +
 hw/vfio/calxeda-xgmac.c              |  54 +++
 hw/vfio/platform.c                   | 772 +++++++++++++++++++++++++++++++++++
 include/hw/vfio/vfio-calxeda-xgmac.h |  46 +++
 include/hw/vfio/vfio-common.h        |   1 +
 include/hw/vfio/vfio-platform.h      |  90 ++++
 linux-headers/asm-arm/kvm.h          |   3 +
 linux-headers/asm-arm64/kvm.h        |   3 +
 linux-headers/linux/vfio.h           |   8 +-
 trace-events                         |  14 +
 12 files changed, 1082 insertions(+), 17 deletions(-)
 create mode 100644 hw/vfio/calxeda-xgmac.c
 create mode 100644 hw/vfio/platform.c
 create mode 100644 include/hw/vfio/vfio-calxeda-xgmac.h
 create mode 100644 include/hw/vfio/vfio-platform.h

-- 
1.8.3.2
