From: Pavel Fedin <p.fedin@samsung.com>
Subject: [PATCH v5 7/7] KVM: arm/arm64: Update API documentation
Date: Mon, 12 Oct 2015 11:29:39 +0300
Message-ID: <e447a2b446db93f4459ebbcd1c2a33557b26945e.1444638023.git.p.fedin@samsung.com>
References: <cover.1444638023.git.p.fedin@samsung.com>
Return-path: <kvm-owner@vger.kernel.org>
In-reply-to: <cover.1444638023.git.p.fedin@samsung.com>
In-reply-to: <cover.1444638023.git.p.fedin@samsung.com>
References: <cover.1444638023.git.p.fedin@samsung.com>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

From: Christoffer Dall <christoffer.dall@linaro.org>

Factor out the GICv3-specific documentation into a separate
documentation file.  Add description for how to access distributor,
redistributor, and CPU interface registers for GICv3 in this new file.

Additionally, fix some mistakes in GICv2 documentation, noticed during
refactoring:
1. GICv2 always identified vCPU by index (using kvm_get_vcpu() function),
   but "cpu id" can be mistaken for affinity ID.
2. Some error codes were wrong.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Pavel Fedin <p.fedin@samsung.com>
---
 Documentation/virtual/kvm/devices/arm-vgic-v3.txt | 117 ++++++++++++++++++++++
 Documentation/virtual/kvm/devices/arm-vgic.txt    |  41 +++-----
 2 files changed, 132 insertions(+), 26 deletions(-)
 create mode 100644 Documentation/virtual/kvm/devices/arm-vgic-v3.txt

diff --git a/Documentation/virtual/kvm/devices/arm-vgic-v3.txt b/Documentation/virtual/kvm/devices/arm-vgic-v3.txt
new file mode 100644
index 0000000..e7be6d0
--- /dev/null
+++ b/Documentation/virtual/kvm/devices/arm-vgic-v3.txt
@@ -0,0 +1,117 @@
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
+
+
+  KVM_DEV_ARM_VGIC_GRP_DIST_REGS
+  KVM_DEV_ARM_VGIC_GRP_REDIST_REGS
+  Attributes:
+    The attr field of kvm_device_attr encodes two values:
+    bits:     | 63   ....  32  |  31   ....    0 |
+    values:   |      mpidr     |      offset     |
+
+    All distributor regs are (rw, 64-bit).
+
+    KVM_DEV_ARM_VGIC_GRP_DIST_REGS accesses the main distributor registers.
+    KVM_DEV_ARM_VGIC_GRP_REDIST_REGS accesses the redistributor of the CPU
+    specified by the mpidr.
+
+    The offset is relative to the "[Re]Distributor base address" as defined
+    in the GICv3/4 specs.  Getting or setting such a register has the same
+    effect as reading or writing the register on real hardware, and the mpidr
+    field is used to specify which redistributor is accessed.  The mpidr is
+    ignored for the distributor.
+
+    The mpidr encoding is based on the affinity information in the
+    architecture defined MPIDR, and the field is encoded as follows:
+      | 63 .... 56 | 55 .... 48 | 47 .... 40 | 39 .... 32 |
+      |    Aff3    |    Aff2    |    Aff1    |    Aff0    |
+
+    Note that distributor fields are not banked, but return the same value
+    regardless of the mpidr used to access the register.
+  Limitations:
+    - Priorities are not implemented, and registers are RAZ/WI
+  Errors:
+    -ENXIO: Getting or setting this register is not yet supported
+    -EBUSY: One or more VCPUs are running
+    -EINVAL: Invalid mpidr supplied
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
+      |    Aff3    |    Aff2    |    Aff1    |    Aff0   |
+    KVM_DEV_ARM_VGIC_SYSREG() macro is provided for building register ID.
+
+    The instr field encodes the system register to access based on the fields
+    defined in the A64 instruction set encoding for system register access
+    (RES means the bits are reserved for future use and should be zero):
+
+      | 15 ... 14 | 13 ... 11 | 10 ... 7 | 6 ... 3 | 2 ... 0 |
+      |   Op 0    |    Op1    |    CRn   |   CRm   |   Op2   |
+
+    All system regs accessed through this API are (rw, 64-bit).
+
+    KVM_DEV_ARM_VGIC_CPU_SYSREGS accesses the CPU interface registers for the
+    CPU specified by the mpidr field.
+
+
+  Limitations:
+    - Priorities are not implemented, and registers are RAZ/WI
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
diff --git a/Documentation/virtual/kvm/devices/arm-vgic.txt b/Documentation/virtual/kvm/devices/arm-vgic.txt
index 3fb9054..3f640d1 100644
--- a/Documentation/virtual/kvm/devices/arm-vgic.txt
+++ b/Documentation/virtual/kvm/devices/arm-vgic.txt
@@ -3,16 +3,16 @@ ARM Virtual Generic Interrupt Controller (VGIC)
 
 Device types supported:
   KVM_DEV_TYPE_ARM_VGIC_V2     ARM Generic Interrupt Controller v2.0
-  KVM_DEV_TYPE_ARM_VGIC_V3     ARM Generic Interrupt Controller v3.0
 
 Only one VGIC instance may be instantiated through either this API or the
 legacy KVM_CREATE_IRQCHIP api.  The created VGIC will act as the VM interrupt
 controller, requiring emulated user-space devices to inject interrupts to the
 VGIC instead of directly to CPUs.
 
-Creating a guest GICv3 device requires a host GICv3 as well.
-GICv3 implementations with hardware compatibility support allow a guest GICv2
-as well.
+GICv3 implementations with hardware compatibility support allow creating a
+guest GICv2 through this interface.  For information on creating a guest GICv3
+device, see arm-vgic-v3.txt.  It is not possible to create both a GICv3 and
+GICv2 device on the same VM.
 
 Groups:
   KVM_DEV_ARM_VGIC_GRP_ADDR
@@ -27,45 +27,33 @@ Groups:
       interface register mappings. Only valid for KVM_DEV_TYPE_ARM_VGIC_V2.
       This address needs to be 4K aligned and the region covers 4 KByte.
 
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
-
   KVM_DEV_ARM_VGIC_GRP_DIST_REGS
   Attributes:
     The attr field of kvm_device_attr encodes two values:
-    bits:     | 63   ....  40 | 39 ..  32  |  31   ....    0 |
-    values:   |    reserved   |   cpu id   |      offset     |
+    bits:     | 63   ....  32  |  31   ....    0 |
+    values:   |  vcpu_index    |      offset     |
 
     All distributor regs are (rw, 32-bit)
 
     The offset is relative to the "Distributor base address" as defined in the
     GICv2 specs.  Getting or setting such a register has the same effect as
     reading or writing the register on the actual hardware from the cpu
-    specified with cpu id field.  Note that most distributor fields are not
-    banked, but return the same value regardless of the cpu id used to access
-    the register.
+    specified with vcpu_index field. Note that most distributor fields are not
+    banked, but return the same value regardless of the vcpu_index used to
+    access the register.
   Limitations:
     - Priorities are not implemented, and registers are RAZ/WI
     - Currently only implemented for KVM_DEV_TYPE_ARM_VGIC_V2.
   Errors:
-    -ENODEV: Getting or setting this register is not yet supported
+    -ENXIO: Getting or setting this register is not yet supported
     -EBUSY: One or more VCPUs are running
+    -EINVAL: Invalid VCPU index supplied
 
   KVM_DEV_ARM_VGIC_GRP_CPU_REGS
   Attributes:
     The attr field of kvm_device_attr encodes two values:
-    bits:     | 63   ....  40 | 39 ..  32  |  31   ....    0 |
-    values:   |    reserved   |   cpu id   |      offset     |
+    bits:     | 63   ....  32  |  31   ....    0 |
+    values:   |  vcpu_index    |      offset     |
 
     All CPU interface regs are (rw, 32-bit)
 
@@ -91,8 +79,9 @@ Groups:
     - Priorities are not implemented, and registers are RAZ/WI
     - Currently only implemented for KVM_DEV_TYPE_ARM_VGIC_V2.
   Errors:
-    -ENODEV: Getting or setting this register is not yet supported
+    -ENXIO: Getting or setting this register is not yet supported
     -EBUSY: One or more VCPUs are running
+    -EINVAL: Invalid VCPU index supplied
 
   KVM_DEV_ARM_VGIC_GRP_NR_IRQS
   Attributes:
-- 
2.4.4

