From: Steven Price <steven.price@arm.com>
Subject: [PATCH 01/12] KVM: arm64: Document PV-time interface
Date: Wed, 28 Nov 2018 14:45:16 +0000
Message-ID: <20181128144527.44710-2-steven.price@arm.com>
References: <20181128144527.44710-1-steven.price@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C5D224A33B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Nov 2018 09:46:32 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id b1+Ekqo4vp6i for <kvmarm@lists.cs.columbia.edu>;
 Wed, 28 Nov 2018 09:46:30 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6D4484A348
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Nov 2018 09:46:30 -0500 (EST)
In-Reply-To: <20181128144527.44710-1-steven.price@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Steven Price <steven.price@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

We introduce a paravirtualization interface for KVM/arm64 based on the
"Arm Paravirtualized Time for Arm-Base Systems" specification DEN 0057A.

User space can specify a reserved area of memory for the guest and
inform KVM to populate the memory with information on stolen time and
Live Physical Time (LPT) that can be used to derive a stable
counter/timer for a guest subject to migration between hosts with
different counter frequencies.

A hypercall interface is provided for the guest to interrogate the
hypervisor's support for this interface and the location of the shared
memory structures.

Signed-off-by: Steven Price <steven.price@arm.com>
---
 Documentation/virtual/kvm/arm/pvtime.txt | 169 +++++++++++++++++++++++
 1 file changed, 169 insertions(+)
 create mode 100644 Documentation/virtual/kvm/arm/pvtime.txt

diff --git a/Documentation/virtual/kvm/arm/pvtime.txt b/Documentation/virtual/kvm/arm/pvtime.txt
new file mode 100644
index 000000000000..1870b904075b
--- /dev/null
+++ b/Documentation/virtual/kvm/arm/pvtime.txt
@@ -0,0 +1,169 @@
+Paravirtualized time support for arm64
+======================================
+
+Arm specification DEN0057/A defined a standard for paravirtualised time
+support for Aarch64 guests:
+
+https://developer.arm.com/docs/den0057/a
+
+KVM/Arm64 implements this specification by providing some hypervisor service
+calls to support a paravirtualized guest obtaining a view of the amount of
+time stolen from its execution and a concept of Live Physical Time (LPT) which
+represents time during which the guest is running and works across migrations.
+
+Three new SMCCC compatible hypercalls are defined:
+
+PV_FEATURES 0xC5000020
+PV_TIME_LPT 0xC5000021
+PV_TIME_ST  0xC5000022
+
+These are only available in the SMC64/HVC64 calling convention as
+paravirtualized time is not available to 32 bit Arm guests.
+
+PV_FEATURES
+    Function ID:  (uint32)  : 0xC5000020
+    PV_func_id:   (uint32)  : Either PV_TIME_LPT or PV_TIME_ST
+    Return value: (int32)   : NOT_SUPPORTED (-1) or SUCCESS (0) if the relevant
+                              PV-time feature is supported by the hypervisor.
+
+PV_TIME_LPT
+    Function ID:  (uint32)  : 0xC5000021
+    Flags:        (uint32)  : Bit[0]: Request migration interrupts
+                                      (not currently supported by KVM)
+    Return value: (int64)   : IPA of the shared live physical time data
+                              structure or negative error code on failure:
+                              NOT_SUPPORTED (-1)
+                              INVALID_PARAMETERS (-2)
+
+PV_TIME_ST
+    Function ID:  (uint32)  : 0xC5000022
+    Return value: (int64)   : IPA of the stolen time data structure for this
+                              (V)CPU. On failure:
+                              NOT_SUPPORTED (-1)
+
+Live Physical Time
+------------------
+
+The structure pointed to by the PV_TIME_LPT hypercall is as follows:
+
+  Field           | Byte Length | Byte Offset | Description
+  --------------- | ----------- | ----------- | -------------------------------
+  Revision        |      4      |      0      | Must be 0 for this revision
+  Attributes      |      4      |      4      | Must be 0
+  sequence_number |      8      |      8      | Bit 0: reserved
+                  |             |             | Bits 1:63 number of migrations
+  scale_mult      |      8      |      16     | Multiplier to scale from native
+                  |             |             | frequency to PV frequency
+  shift           |      4      |      24     | Shift applied before multiplier
+  Reserved        |      4      |      28     | Must be 0
+  Fn              |      8      |      32     | Native frequency
+  Fpv             |      8      |      40     | Paravirtualized frequency seen
+                  |             |             | by guest
+  div_by_fpv_mult |      8      |      48     | Multiplier to implement fast
+                  |             |             | divide by Fpv
+
+Where scale_mult is defined as 2^(64-shift) * Fpv / Fn
+
+The structure will be updated by the hypervisor whenever the guest is migrated
+to a new host. It will be present within a reserved region of the normal
+memory given to the guest. The guest should not attempt to write into this
+memory.
+
+Stolen Time
+-----------
+
+The structure pointed to by the PV_TIME_ST hypercall is as follows:
+
+  Field       | Byte Length | Byte Offset | Description
+  ----------- | ----------- | ----------- | --------------------------
+  Revision    |      4      |      0      | Must be 0 for version 0.1
+  Attributes  |      4      |      4      | Must be 0
+  Stolen time |      8      |      8      | Stolen time in unsigned
+              |             |             | nanoseconds indicating how
+              |             |             | much time this VCPU thread
+              |             |             | was involuntarily not
+              |             |             | running on a physical CPU.
+
+The structure will be updated by the hypervisor periodically as time is stolen
+from the VCPU. It will be present within a reserved region of the normal
+memory given to the guest. The guest should not attempt to write into this
+memory. There is a structure by VCPU of the guest.
+
+User space interface
+====================
+
+User space can request that KVM provide the paravirtualized time interface to
+a guest by creating a KVM_DEV_TYPE_ARM_PV_TIME device, for example:
+
+    struct kvm_create_device pvtime_device = {
+            .type = KVM_DEV_TYPE_ARM_PV_TIME,
+            .attr = 0,
+            .flags = 0,
+    };
+
+    pvtime_fd = ioctl(vm_fd, KVM_CREATE_DEVICE, &pvtime_device);
+
+The guest IPA of the structures must be given to KVM. This is the address of
+the LPT structure and the base address of an array of stolen time structures
+(one for each VCPU). For example:
+
+    struct kvm_device_attr lpt_base = {
+            .group = KVM_DEV_ARM_PV_TIME_PADDR,
+            .attr = KVM_DEV_ARM_PV_TIME_LPT,
+            .addr = (u64)(unsigned long)&lpt_paddr
+    };
+    struct kvm_device_attr st_base = {
+            .group = KVM_DEV_ARM_PV_TIME_PADDR,
+            .attr = KVM_DEV_ARM_PV_TIME_ST,
+            .addr = (u64)(unsigned long)&st_paddr
+    };
+
+    ioctl(pvtime_fd, KVM_SET_DEVICE_ATTR, &lpt_base);
+    ioctl(pvtime_fd, KVM_SET_DEVICE_ATTR, &st_base);
+
+The paravirtualized frequency of the guest can also be set. By default this
+will be the counter frequency of the host. However when migrating a guest from
+another host, this must be manually set to ensure that the guest sees the same
+frequency.
+
+    u32 frequency;
+
+    struct kvm_device_attr lpt_freq = {
+            .group = KVM_DEV_ARM_PV_TIME_FREQUENCY,
+            .attr = KVM_DEV_ARM_PV_TIME_LPT,
+            .addr = (u64)(unsigned long)&frequency
+    };
+
+    ioctl(pvtime_fd, KVM_SET_DEVICE_ATTR, &lpt_freq);
+
+For migration (or save/restore) of a guest it is necessary to save the contents
+of the shared pages and later restore them. KVM_DEV_ARM_PV_TIME_STATE_SIZE
+provides the size of this data and KVM_DEV_ARM_PV_TIME_STATE allows the state
+to be read/written. The state for stolen time and LPT are accessed separately.
+It is also necessary for the physical address and frequency to be set
+identically when restoring. The kernel will update the structure on first run
+of the vCPU(s) to contain the new coefficients.
+
+    void *save_state(int fd, u64 attr, u32 *size) {
+        struct kvm_device_attr get_size = {
+                .group = KVM_DEV_ARM_PV_TIME_STATE_SIZE,
+                .attr = attr,
+                .addr = (u64)(unsigned long)size
+        };
+
+        ioctl(fd, KVM_GET_DEVICE_ATTR, get_size);
+
+        void *buffer = malloc(*size);
+
+        struct kvm_device_attr get_state = {
+                .group = KVM_DEV_ARM_PV_TIME_STATE,
+                .attr = attr,
+                .addr = (u64)(unsigned long)size
+        };
+
+        ioctl(fd, KVM_GET_DEVICE_ATTR, buffer);
+    }
+
+    void *lpt_state = save_state(pvtime_fd, KVM_DEV_ARM_PV_TIME_LPT, &lpt_size);
+    void *st_state = save_state(pvtime_fd, KVM_DEV_ARM_PV_TIME_ST, &st_size);
+
-- 
2.19.2
