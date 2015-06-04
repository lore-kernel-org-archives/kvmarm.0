From: Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH v16 0/9] KVM platform device passthrough
Date: Thu, 04 Jun 2015 12:11:01 -0600
Message-ID: <1433441461.3510.186.camel@redhat.com>
References: <1432717871-2393-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org>
In-Reply-To: <1432717871-2393-1-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.nongnu.org/mailman/options/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=unsubscribe>
List-Archive: <http://lists.nongnu.org/archive/html/qemu-devel>
List-Post: <mailto:qemu-devel@nongnu.org>
List-Help: <mailto:qemu-devel-request@nongnu.org?subject=help>
List-Subscribe: <https://lists.nongnu.org/mailman/listinfo/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=subscribe>
Errors-To: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
Sender: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
To: Eric Auger <eric.auger@linaro.org>
Cc: b.reynal@virtualopensystems.com, peter.maydell@linaro.org, eric.auger@st.com, vikrams@codeaurora.org, patches@linaro.org, qemu-devel@nongnu.org, agraf@suse.de, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, 2015-05-27 at 10:11 +0100, Eric Auger wrote:
> This series aims at enabling KVM platform device passthrough.
>=20
> On kernel side, the vfio platform driver is needed, available from
> 4.1-rc1 onwards.
>=20
> This series now only relies on the following QEMU series, for
> dynamic instantiation of the VFIO platform device from qemu command
> line:
>=20
> [1] [PATCH v12 0/4] machvirt dynamic sysbus device instantiation
> http://comments.gmane.org/gmane.comp.emulators.kvm.arm.devel/886


Hi Eric,

Now that your pre-req above is in, how do you want to proceed with this
series.  Patches 1-3 are entirely in vfio space, so I can sign-off and
request a pull of those.  I think that gives you basic functionality,
modulo dynamic instantiation of xgmac.  Patches 4-8 need to go in
through or at least be ack'd by their respective maintainers before I
can get to patch 9.  Let me know.  Thanks,

Alex

>=20
> Both series are candidate for QEMU 2.4 and available at
>=20
> http://git.linaro.org/people/eric.auger/qemu.git
> (branch vfio_integ_v16)
>=20
> The series was tested on Calxeda Midway (ARMv7) where one xgmac
> is assigned to KVM host while the second one is assigned to the guest.
>=20
> Wiki for Calxeda Midway setup:
> https://wiki.linaro.org/LEG/Engineering/Virtualization/Platform_Device_=
Passthrough_on_Midway
>=20
> Tested by Vikram Sethi on a device featuring 2 MMIO regions.
> Code also exercised successfully by VOSYS for AMBA derivative series.
>=20
> Best Regards
>=20
> Eric
>=20
> History:
>=20
> v15 -> v16:
> - no code change
> - add Vikram's T-b
> - rebase on 0915aed
> - remove linux header update patch file
>=20
> v14 -> v15:
> - add Peter R-b on sysbus: add irq_routing_notifier
> - correct g_malloc0_n usage in skeleton
> - correct return values of reset related functions
> - include Cornelia's patch for header update
>=20
> v13 -> v14:
> - remove v13 9, 10, 11 patch files and replace them by a single patch f=
ile
>   "sysbus: add irq_routing_notifier".
> - in skeleton, fix ENAMETOOLONG sign
> - remove VFIOINTp virtualID in "add irq assignment" patch file
> - removed trace_vfio_platform_start_eventfd
>=20
> v12 -> v13:
> - header update but same update was already sent by Cornelia
> - Rework VFIO signaling & irqfd setup: restored 2-step setup featuring
>   eventfd setup on realize and then irqfd setup on irq binding.
> - irqfd setup now uses kvm_irqchip_add_irqfd_notifier and
>   sysbus irq_set_hook override. This leads to the introduction of 6 pat=
ch
>   files enabling those 2 features. Paolo advised to introduce
>   kvm_irqchip_add_irqfd_notifier series in the VFIO one. I did the
>   same for irq_set_hook series but if it is better I can submit it asid=
e.
> - above changes made possible to remove
>   x hw/vfio/platform: add capability to start IRQ propagation"
>   x hw/arm/virt: start VFIO IRQ propagation
> - in sysbus-fdt.c, use platform_bus_get_mmio_addr instead of deprecated
>   mmio[0] property. Thanks to Bharat who pointed this issue out. also
>   cpu_to_be32 was used for size and base (Vikram input) .
> - in skeleton misc corrections following Alex review.
>=20
> v11->v12:
> - add x-mmap property definition, without which the default value of
>   vbasedev.allow_mmap is false, hence preventing the reg space from
>   being mmapped.
>=20
> v10->v11:
> - rebase onto v2.3.0-rc0 (mainly related to PCIe support in virt)
> - add dma-coherent property for calxeda midway (fix revealed by removal
>   of kernel-side "vfio: type1: support for ARM SMMUS with VFIO_IOMMU_TY=
PE1")
> - virt modifications to start VFIO IRQ forwarding are now in a separate
>   patch
> - rearrange linux header exports (those are still partial exports
>   waiting for definitive 4.1-rc0)
> - take into account Alex Benn=C3=83=C2=A9e comments:
>   - use g_malloc0_n instead of g_malloc0
>   - use block declarations when possible
>   - rework readlink returned value treatment
>   - use g_strlcat in place strncat
>   - re-arrange mutex locking for multiple IRQ support (user-side handle=
d
>     eventfds)
> - use g_snprintf instead of snprintf
> - change the order of functions to avoid pre-declaration in platform.c
> - add flags in VFIOINTp struct to detect whether the IRQ is automasked
> - some comment rewriting
>=20
> v9->v10:
> - rebase on "vfio: cleanup vfio_get_device error path, remove
>   vfio_populate_device": vfio_populate_device no more called in
>   vfio_get_device but in vfio_base_device_init
> - update VFIO header according to vfio platform driver v13 (no AMBA)
>=20
> v8->v9:
> - rebase on 2.2.0 and machvirt dynamic sysbus instantiation v10
> - v8 1-11 were pulled
> - patch files related to forwarding are moved in a seperate series sinc=
e
>   it depends on kernel series still in RFC.
> - introduction of basic VFIO platform device split into 3 patch files t=
o
>   ease the review (hope it will help).
> - add an author in platform.c
> - add deallocation in vfio_populate_device error case
> - add patch file doing the VFIO header sync
> - use VFIO_DEVICE_FLAGS_PLATFORM in vfio_populate_device
> - rename calxeda_xgmac.c into calxeda-xgmac.c
> - sysbus-fdt: add_calxeda_midway_xgmac_fdt_node g_free in case of error=
s
> - reword of linux-headers patch files
>=20
> v7->v8:
> - rebase on v2.2.0-rc3 and integrate
>   "Add skip_dump flag to ignore memory region during dump"
> - KVM header evolution with subindex addition in kvm_arch_forwarded_irq
> - split [PATCH v7 03/16] hw/vfio/pci: introduce VFIODevice into 4 patch=
es
> - vfio_compute_needs_reset does not return bool anymore
> - add some comments about exposed MMIO region and IRQ in calxeda xgmac
>   device
> - vfio_[un]mask_irqindex renamed into vfio_[un]mask_single_irqindex
> - rework IRQ startup: former machine init done notifier is replaced by =
a
>   reset notifier. machine file passes the interrupt controller
>   DeviceState handle (not the platform bus first irq parameter).
> - sysbus-fdt:
>   - move the add_fdt_node_functions array declaration between the devic=
e
>     specific code and the generic code to avoid forward declarations of
>     decice specific functions
>   - rename add_basic_vfio_fdt_node into add_calxeda_midway_xgmac_fdt_no=
de
>     emphasizing the fact it is xgmac specific
>=20
> v6->v7:
> - fake injection test modality removed
> - VFIO_DEVICE_TYPE_PLATFORM only introduced with VFIO platform
> - new helper functions to start VFIO IRQ on machine init done notifier
>   (introduced in hw/vfio/platform: add vfio-platform support and notifi=
er
>   registration invoked in hw/arm/virt: add support for VFIO devices).
>   vfio_start_irq_injection is replaced by vfio_register_irq_starter.
>=20
> v5->v6:
> - rebase on 2.1rc5 PCI code
> - forwarded IRQ first integraton
> - vfio_device property renamed into host property
> - split IRQ setup in different functions that match the 3 supported
>   injection techniques (user handled eventfd, irqfd, forwarded IRQ):
>   removes dynamic switch between injection methods
> - introduce fake interrupts as a test modality:
>   x makes possible to test multiple IRQ user-side handling.
>   x this is a test feature only: enable to trigger a fd as if the
>     real physical IRQ hit. No virtual IRQ is injected into the guest
>     but handling is simulated so that the state machine can be tested
> - user handled eventfd:
>   x add mutex to protect IRQ state & list manipulation,
>   x correct misleading comment in vfio_intp_interrupt.
>   x Fix bugs using fake interrupt modality
> - irqfd no more advertised in this patchset (handled in [3])
> - VFIOPlatformDeviceClass becomes abstract and Calxeda xgmac device
>   and class is re-introduced (as per v4)
> - all DPRINTF removed in platform and replaced by trace-points
> - corrects compilation with configure --disable-kvm
> - simplifies the split for vfio_get_device and introduce a unique
>   specialized function named vfio_populate_device
> - group_list renamed into vfio_group_list
> - hw/arm/dyn_sysbus_devtree.c currently only support vfio-calxeda-xgmac
>   instantiation. Needs to be specialized for other VFIO devices
> - fix 2 bugs in dyn_sysbus_devtree(reg_attr index and compat)
>=20
> v4->v5:
> - rebase on v2.1.0 PCI code
> - take into account Alex Williamson comments on PCI code rework
>   - trace updates in vfio_region_write/read
>   - remove fd from VFIORegion
>   - get/put ckeanup
> - bug fix: bar region's vbasedev field duly initialization
> - misc cleanups in platform device
> - device tree node generation removed from device and handled in
>   hw/arm/dyn_sysbus_devtree.c
> - remove "hw/vfio: add an example calxeda_xgmac": with removal of
>   device tree node generation we do not have so many things to
>   implement in that derived device yet. May be re-introduced later
>   on if needed typically for reset/migration.
> - no GSI routing table anymore
>=20
> v3->v4 changes (Eric Auger, Alvise Rigo)
> - rebase on last VFIO PCI code (v2.1.0-rc0)
> - full git history rework to ease PCI code change review
> - mv include files in hw/vfio
> - DPRINTF reformatting temporarily moved out
> - support of VFIO virq (removal of resamplefd handler on user-side)
> - integration with sysbus dynamic instantiation framwork
> - removal of unrealize and cleanup routines until it is better
>   understood what is really needed
> - Support of VFIO for Amba devices should be handled in an inherited
>   device to specialize the device tree generation (clock handle current=
ly
>   missing in framework however)
> - "Always use eventfd as notifying mechanism" temporarily moved out
> - static instantiation is not mainstream (although it remains possible)
>   note if static instantiation is used, irqfd must be setup in machine =
file
>   when virtual IRQ is known
> - create the GSI routing table on qemu side
>=20
> v2->v3 changes (Alvise Rigo, Eric Auger):
> - Following Alex W recommandations, further efforts to factorize the
>   code between PCI:introduction of VFIODevice and VFIORegion
>   as base classes
> - unique reset handler for platform and PCI
> - cleanup following Kim's comments
> - multiple IRQ support mechanics should be in place although not
>   tested
> - Better handling of MMIO multiple regions
> - New features and fixes by Alvise (multiple compat string, exec
>   flag, force eventfd usage, amba device tree support)
> - irqfd support
>=20
> v1->v2 changes (Kim Phillips, Eric Auger):
> - IRQ initial support (legacy mode where eventfds are handled on
>   user side)
> - hacked dynamic instantiation
>=20
> v1 (Kim Phillips):
> - initial split between PCI and platform
> - MMIO support only
> - static instantiation
>=20
>=20
> Eric Auger (9):
>   hw/vfio/platform: vfio-platform skeleton
>   hw/vfio/platform: add irq assignment
>   hw/vfio/platform: calxeda xgmac device
>   hw/arm/sysbus-fdt: enable vfio-calxeda-xgmac dynamic instantiation
>   kvm: rename kvm_irqchip_[add,remove]_irqfd_notifier with gsi suffix
>   kvm-all.c: add qemu_irq/gsi hash table and utility routines
>   intc: arm_gic_kvm: set the qemu_irq/gsi mapping
>   sysbus: add irq_routing_notifier
>   hw/vfio/platform: add irqfd support
>=20
>  hw/arm/sysbus-fdt.c                  |  72 ++++
>  hw/core/sysbus.c                     |   6 +
>  hw/intc/arm_gic_kvm.c                |   6 +
>  hw/s390x/virtio-ccw.c                |   8 +-
>  hw/vfio/Makefile.objs                |   2 +
>  hw/vfio/calxeda-xgmac.c              |  54 +++
>  hw/vfio/pci.c                        |   6 +-
>  hw/vfio/platform.c                   | 723 +++++++++++++++++++++++++++=
++++++++
>  hw/virtio/virtio-pci.c               |   4 +-
>  include/hw/sysbus.h                  |   1 +
>  include/hw/vfio/vfio-calxeda-xgmac.h |  46 +++
>  include/hw/vfio/vfio-common.h        |   1 +
>  include/hw/vfio/vfio-platform.h      |  77 ++++
>  include/sysemu/kvm.h                 |  11 +-
>  kvm-all.c                            |  44 ++-
>  kvm-stub.c                           |   7 +-
>  trace-events                         |  13 +
>  17 files changed, 1064 insertions(+), 17 deletions(-)
>  create mode 100644 hw/vfio/calxeda-xgmac.c
>  create mode 100644 hw/vfio/platform.c
>  create mode 100644 include/hw/vfio/vfio-calxeda-xgmac.h
>  create mode 100644 include/hw/vfio/vfio-platform.h
>=20
