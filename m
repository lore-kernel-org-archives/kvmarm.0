From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH v5] KVM: arm/arm64: Add VGICv3 save/restore API documentation
Date: Tue, 26 Jul 2016 12:39:40 +0200
Message-ID: <20160726103940.26243-1-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, Peter Maydell <peter.maydell@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Andre Przywara <andre.przywara@arm.com>, vijay.kilari@gmail.com, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

Factor out the GICv3 and ITS-specific documentation into a separate
documentation file.  Add description for how to access distributor,
redistributor, and CPU interface registers for GICv3 in this new file,
and add a group for accessing level triggered IRQ information for GICv3
as well.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
Changes since v4:
 - Clarify register reads as per Peter's comments on v4
 - Factored out ITS documenation into separate file
 - Clarified error conditions on all GRP_ADDR groups
 - Renamed KVM_VGIC_V3_ADDR_TYPE_ITS to KVM_VGIC_ITS_ADDR_TYPE in the
   documentation to be in line with the code.
 - Did not apply Peter's reviewed-by due to the conflicts and updates
   related to the ITS.

Changes since v3:
 - Fix typos
 - Clarified level register containing 32 IRQs
 - Removed limitations about priority support which are no longer true
 - Special-case the SPENDR register accesses to access the latch state
   and the CPENDR register accesses to be RAZ/WI.

Changes since v2:
 - Changed distributor access to be 32-bits in size
 - Clearly specified data type pointed to by addr field
 - Specified exception behavior for STATUSR registers
 - Added group for level-triggered IRQ status info
 - Removed acks from Marc/Peter as content has changed


 Documentation/virtual/kvm/devices/arm-vgic-its.txt |  38 ++++
 Documentation/virtual/kvm/devices/arm-vgic-v3.txt  | 207 +++++++++++++++++++++
 Documentation/virtual/kvm/devices/arm-vgic.txt     |  52 ++----
 3 files changed, 262 insertions(+), 35 deletions(-)
 create mode 100644 Documentation/virtual/kvm/devices/arm-vgic-its.txt
 create mode 100644 Documentation/virtual/kvm/devices/arm-vgic-v3.txt

diff --git a/Documentation/virtual/kvm/devices/arm-vgic-its.txt b/Documentation/virtual/kvm/devices/arm-vgic-its.txt
new file mode 100644
index 0000000..ffae1cd
--- /dev/null
+++ b/Documentation/virtual/kvm/devices/arm-vgic-its.txt
@@ -0,0 +1,38 @@
+ARM Virtual Interrupt Translation Service (ITS)
+===============================================
+
+Device types supported:
+  KVM_DEV_TYPE_ARM_VGIC_ITS    ARM Interrupt Translation Service Controller
+
+Creating a virtual ITS controller also requires a host GICv3 (see
+arm-vgic-v3.txt), but does not depend on having physical ITS controllers.
+
+There can be multiple ITS controllers per guest, each of them has to have
+a separate, non-overlapping MMIO region.
+
+
+Groups:
+  KVM_DEV_ARM_VGIC_GRP_ADDR
+  Attributes:
+    KVM_VGIC_ITS_ADDR_TYPE (rw, 64-bit)
+      Base address in the guest physical address space of the GICv3 ITS
+      control register frame. The ITS allows MSI(-X) interrupts to be
+      injected into guests. This extension is optional.
+      This address needs to be 64K aligned and the region covers 128K.
+  Errors:
+    -E2BIG:  Address outside of addressable IPA range
+    -EINVAL: Incorrectly aligned address
+    -EEXIST: Address already configured
+    -EFAULT: Invalid user pointer for attr->addr.
+    -ENODEV: Incrorect attribute or the ITS is not supported.
+
+
+  KVM_DEV_ARM_VGIC_GRP_CTRL
+  Attributes:
+    KVM_DEV_ARM_VGIC_CTRL_INIT
+      request the initialization of the ITS, no additional parameter in
+      kvm_device_attr.addr.
+  Errors:
+    -ENXIO:  ITS not properly configured as required prior to calling
+             this attribute
+    -ENOMEM: Memory shortage when allocating ITS internal data
diff --git a/Documentation/virtual/kvm/devices/arm-vgic-v3.txt b/Documentation/virtual/kvm/devices/arm-vgic-v3.txt
new file mode 100644
index 0000000..017e085
--- /dev/null
+++ b/Documentation/virtual/kvm/devices/arm-vgic-v3.txt
@@ -0,0 +1,207 @@
+ARM Virtual Generic Interrupt Controller v3 and later (VGICv3)
+==============================================================
+
+
+Device types supported:
+  KVM_DEV_TYPE_ARM_VGIC_V3     ARM Generic Interrupt Controller v3.0
+
+Only one VGIC instance may be instantiated through this API.  The created VGIC
+will act as the VM interrupt controller, requiring emulated user-space devices
+to inject interrupts to the VGIC instead of directly to CPUs.  It is not
+possible to create both a GICv3 and GICv2 on the same VM.
+
+Creating a guest GICv3 device requires a host GICv3 as well.
+
+
+Groups:
+  KVM_DEV_ARM_VGIC_GRP_ADDR
+  Attributes:
+    KVM_VGIC_V3_ADDR_TYPE_DIST (rw, 64-bit)
+      Base address in the guest physical address space of the GICv3 distributor
+      register mappings. Only valid for KVM_DEV_TYPE_ARM_VGIC_V3.
+      This address needs to be 64K aligned and the region covers 64 KByte.
+
+    KVM_VGIC_V3_ADDR_TYPE_REDIST (rw, 64-bit)
+      Base address in the guest physical address space of the GICv3
+      redistributor register mappings. There are two 64K pages for each
+      VCPU and all of the redistributor pages are contiguous.
+      Only valid for KVM_DEV_TYPE_ARM_VGIC_V3.
+      This address needs to be 64K aligned.
+  Errors:
+    -E2BIG:  Address outside of addressable IPA range
+    -EINVAL: Incorrectly aligned address
+    -EEXIST: Address already configured
+    -ENXIO:  The group or attribute is unknown/unsupported for this device
+             or hardware support is missing.
+    -EFAULT: Invalid user pointer for attr->addr.
+
+
+
+  KVM_DEV_ARM_VGIC_GRP_DIST_REGS
+  KVM_DEV_ARM_VGIC_GRP_REDIST_REGS
+  Attributes:
+    The attr field of kvm_device_attr encodes two values:
+    bits:     | 63   ....  32  |  31   ....    0 |
+    values:   |      mpidr     |      offset     |
+
+    All distributor regs are (rw, 32-bit) and kvm_device_attr.addr points to a
+    __u32 value.  64-bit registers must be accessed by separately accessing the
+    lower and higher word.
+
+    Writes to read-only registers are ignored by the kernel.
+
+    KVM_DEV_ARM_VGIC_GRP_DIST_REGS accesses the main distributor registers.
+    KVM_DEV_ARM_VGIC_GRP_REDIST_REGS accesses the redistributor of the CPU
+    specified by the mpidr.
+
+    The offset is relative to the "[Re]Distributor base address" as defined
+    in the GICv3/4 specs.  Getting or setting such a register has the same
+    effect as reading or writing the register on real hardware, except for the
+    following registers: GICD_STATUSR, GICR_STATUSR, GICD_ISPENDR,
+    GICR_ISPENDR0, GICD_ICPENDR, and GICR_ICPENDR0.  These registers behave
+    differently when accessed via this interface compared to their
+    architecturally defined behavior to allow software a full view of the
+    VGIC's internal state.
+
+    The mpidr field is used to specify which
+    redistributor is accessed.  The mpidr is ignored for the distributor.
+
+    The mpidr encoding is based on the affinity information in the
+    architecture defined MPIDR, and the field is encoded as follows:
+      | 63 .... 56 | 55 .... 48 | 47 .... 40 | 39 .... 32 |
+      |    Aff3    |    Aff2    |    Aff1    |    Aff0    |
+
+    Note that distributor fields are not banked, but return the same value
+    regardless of the mpidr used to access the register.
+
+    The GICD_STATUSR and GICR_STATUSR registers are architecturally defined such
+    that a write of a clear bit has no effect, whereas a write with a set bit
+    clears that value.  To allow userspace to freely set the values of these two
+    registers, setting the attributes with the register offsets for these two
+    registers simply sets the non-reserved bits to the value written.
+
+
+    Accesses (reads and writes) to the GICD_ISPENDR register region and
+    GICR_ISPENDR0 registers get/set the value of the latched pending state for
+    the interrupts.
+
+    This is identical to the value returned by a guest read from ISPENDR for an
+    edge triggered interrupt, but may differ for level triggered interrupts.
+    For edge triggered interrupts, once an interrupt becomes pending (whether
+    because of an edge detected on the input line or because of a guest write
+    to ISPENDR) this state is "latched", and only cleared when either the
+    interrupt is activated or when the guest writes to ICPENDR. A level
+    triggered interrupt may be pending either because the level input is held
+    high by a device, or because of a guest write to the ISPENDR register. Only
+    ISPENDR writes are latched; if the device lowers the line level then the
+    interrupt is no longer pending unless the guest also wrote to ISPENDR, and
+    conversely writes to ICPENDR or activations of the interrupt do not clear
+    the pending status if the line level is still being held high.  (These
+    rules are documented in the GICv3 specification descriptions of the ICPENDR
+    and ISPENDR registers.) For a level triggered interrupt the value accessed
+    here is that of the latch which is set by ISPENDR and cleared by ICPENDR or
+    interrupt activation, whereas the value returned by a guest read from
+    ISPENDR is the logical OR of the latch value and the input line level.
+
+    Raw access to the latch state is provided to userspace so that it can save
+    and restore the entire GIC internal state (which is defined by the
+    combination of the current input line level and the latch state, and cannot
+    be deduced from purely the line level and the value of the ISPENDR
+    registers).
+
+    Accesses to GICD_ICPENDR register region and GICR_ICPENDR0 registers have
+    RAZ/WI semantics, meaning that reads always return 0 and writes are always
+    ignored.
+
+  Errors:
+    -ENXIO: Getting or setting this register is not yet supported
+    -EBUSY: One or more VCPUs are running
+
+
+  KVM_DEV_ARM_VGIC_CPU_SYSREGS
+  Attributes:
+    The attr field of kvm_device_attr encodes two values:
+    bits:     | 63      ....       32 | 31  ....  16 | 15  ....  0 |
+    values:   |         mpidr         |      RES     |    instr    |
+
+    The mpidr field encodes the CPU ID based on the affinity information in the
+    architecture defined MPIDR, and the field is encoded as follows:
+      | 63 .... 56 | 55 .... 48 | 47 .... 40 | 39 .... 32 |
+      |    Aff3    |    Aff2    |    Aff1    |    Aff0    |
+
+    The instr field encodes the system register to access based on the fields
+    defined in the A64 instruction set encoding for system register access
+    (RES means the bits are reserved for future use and should be zero):
+
+      | 15 ... 14 | 13 ... 11 | 10 ... 7 | 6 ... 3 | 2 ... 0 |
+      |   Op 0    |    Op1    |    CRn   |   CRm   |   Op2   |
+
+    All system regs accessed through this API are (rw, 64-bit) and
+    kvm_device_attr.addr points to a __u64 value.
+
+    KVM_DEV_ARM_VGIC_CPU_SYSREGS accesses the CPU interface registers for the
+    CPU specified by the mpidr field.
+
+  Errors:
+    -ENXIO: Getting or setting this register is not yet supported
+    -EBUSY: VCPU is running
+    -EINVAL: Invalid mpidr supplied
+
+
+  KVM_DEV_ARM_VGIC_GRP_NR_IRQS
+  Attributes:
+    A value describing the number of interrupts (SGI, PPI and SPI) for
+    this GIC instance, ranging from 64 to 1024, in increments of 32.
+
+    kvm_device_attr.addr points to a __u32 value.
+
+  Errors:
+    -EINVAL: Value set is out of the expected range
+    -EBUSY: Value has already be set.
+
+
+  KVM_DEV_ARM_VGIC_GRP_CTRL
+  Attributes:
+    KVM_DEV_ARM_VGIC_CTRL_INIT
+      request the initialization of the VGIC, no additional parameter in
+      kvm_device_attr.addr.
+  Errors:
+    -ENXIO: VGIC not properly configured as required prior to calling
+     this attribute
+    -ENODEV: no online VCPU
+    -ENOMEM: memory shortage when allocating vgic internal data
+
+
+  KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO
+  Attributes:
+    The attr field of kvm_device_attr encodes the following values:
+    bits:     | 63      ....       32 | 31   ....    10 | 9  ....  0 |
+    values:   |         mpidr         |      info       |   vINTID   |
+
+    The vINTID specifies which set of IRQs is reported on.
+
+    The info field specifies which information userspace wants to get or set
+    using this interface.  Currently we support two different pieces of
+    information:
+
+      VGIC_LEVEL_INFO_LINE_LEVEL:
+	Get/Set the input level of the IRQ line for a set of 32 contiguously
+	numbered interrupts.
+	vINTID must be a multiple of 32.
+
+	kvm_device_attr.addr points to a __u32 value which will contain a
+	bitmap where a set bit means the interrupt level is asserted.
+
+	Bit[n] indicates the status for interrupt vINTID + n.
+
+    SGIs and any interrupt with a higher ID than the number of interrupts
+    supported, will be RAZ/WI.  LPIs are always edge-triggered and are
+    therefore not supported by this interface.
+
+    PPIs are reported per VCPU as specified in the mpidr field, and SPIs are
+    reported with the same value regardless of the mpidr specified.
+
+    The mpidr field encodes the CPU ID based on the affinity information in the
+    architecture defined MPIDR, and the field is encoded as follows:
+      | 63 .... 56 | 55 .... 48 | 47 .... 40 | 39 .... 32 |
+      |    Aff3    |    Aff2    |    Aff1    |    Aff0    |
diff --git a/Documentation/virtual/kvm/devices/arm-vgic.txt b/Documentation/virtual/kvm/devices/arm-vgic.txt
index 89182f8..76e61c8 100644
--- a/Documentation/virtual/kvm/devices/arm-vgic.txt
+++ b/Documentation/virtual/kvm/devices/arm-vgic.txt
@@ -1,24 +1,19 @@
-ARM Virtual Generic Interrupt Controller (VGIC)
-===============================================
+ARM Virtual Generic Interrupt Controller v2 (VGIC)
+==================================================
 
 Device types supported:
   KVM_DEV_TYPE_ARM_VGIC_V2     ARM Generic Interrupt Controller v2.0
-  KVM_DEV_TYPE_ARM_VGIC_V3     ARM Generic Interrupt Controller v3.0
-  KVM_DEV_TYPE_ARM_VGIC_ITS    ARM Interrupt Translation Service Controller
 
-Only one VGIC instance of the V2/V3 types above may be instantiated through
-either this API or the legacy KVM_CREATE_IRQCHIP api.  The created VGIC will
-act as the VM interrupt controller, requiring emulated user-space devices to
-inject interrupts to the VGIC instead of directly to CPUs.
+Only one VGIC instance may be instantiated through either this API or the
+legacy KVM_CREATE_IRQCHIP API.  The created VGIC will act as the VM interrupt
+controller, requiring emulated user-space devices to inject interrupts to the
+VGIC instead of directly to CPUs.
 
-Creating a guest GICv3 device requires a host GICv3 as well.
-GICv3 implementations with hardware compatibility support allow a guest GICv2
-as well.
+GICv3 implementations with hardware compatibility support allow creating a
+guest GICv2 through this interface.  For information on creating a guest GICv3
+device and guest ITS devices, see arm-vgic-v3.txt.  It is not possible to
+create both a GICv3 and GICv2 device on the same VM.
 
-Creating a virtual ITS controller requires a host GICv3 (but does not depend
-on having physical ITS controllers).
-There can be multiple ITS controllers per guest, each of them has to have
-a separate, non-overlapping MMIO region.
 
 Groups:
   KVM_DEV_ARM_VGIC_GRP_ADDR
@@ -32,26 +27,13 @@ Groups:
       Base address in the guest physical address space of the GIC virtual cpu
       interface register mappings. Only valid for KVM_DEV_TYPE_ARM_VGIC_V2.
       This address needs to be 4K aligned and the region covers 4 KByte.
-
-    KVM_VGIC_V3_ADDR_TYPE_DIST (rw, 64-bit)
-      Base address in the guest physical address space of the GICv3 distributor
-      register mappings. Only valid for KVM_DEV_TYPE_ARM_VGIC_V3.
-      This address needs to be 64K aligned and the region covers 64 KByte.
-
-    KVM_VGIC_V3_ADDR_TYPE_REDIST (rw, 64-bit)
-      Base address in the guest physical address space of the GICv3
-      redistributor register mappings. There are two 64K pages for each
-      VCPU and all of the redistributor pages are contiguous.
-      Only valid for KVM_DEV_TYPE_ARM_VGIC_V3.
-      This address needs to be 64K aligned.
-
-    KVM_VGIC_V3_ADDR_TYPE_ITS (rw, 64-bit)
-      Base address in the guest physical address space of the GICv3 ITS
-      control register frame. The ITS allows MSI(-X) interrupts to be
-      injected into guests. This extension is optional. If the kernel
-      does not support the ITS, the call returns -ENODEV.
-      Only valid for KVM_DEV_TYPE_ARM_VGIC_ITS.
-      This address needs to be 64K aligned and the region covers 128K.
+  Errors:
+    -E2BIG:  Address outside of addressable IPA range
+    -EINVAL: Incorrectly aligned address
+    -EEXIST: Address already configured
+    -ENXIO:  The group or attribute is unknown/unsupported for this device
+             or hardware support is missing.
+    -EFAULT: Invalid user pointer for attr->addr.
 
   KVM_DEV_ARM_VGIC_GRP_DIST_REGS
   Attributes:
-- 
2.9.0

