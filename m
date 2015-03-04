From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH v4 2/3] linux-headers: update to 4.0-rc2
Date: Wed,  4 Mar 2015 14:16:16 +0000
Message-ID: <1425478577-32556-3-git-send-email-eric.auger@linaro.org>
References: <1425478577-32556-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 53C7046FF0
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Mar 2015 09:10:57 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LjeKUPI4H9Sw for <kvmarm@lists.cs.columbia.edu>;
 Wed,  4 Mar 2015 09:10:53 -0500 (EST)
Received: from mail-wg0-f44.google.com (mail-wg0-f44.google.com [74.125.82.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 99E4F479C4
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Mar 2015 09:10:53 -0500 (EST)
Received: by wghk14 with SMTP id k14so3109191wgh.7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 04 Mar 2015 06:16:55 -0800 (PST)
In-Reply-To: <1425478577-32556-1-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@st.com, christoffer.dall@linaro.org, qemu-devel@nongnu.org, agraf@suse.de, pbonzini@redhat.com, mst@redhat.com, b.reynal@virtualopensystems.com
Cc: alex.williamson@redhat.com, patches@linaro.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

This updates the Linux header to version 4.0-rc2.

Besides virtio_config.h now sets VIRTIO_TRANSPORT_F_END to 33.
Use the same value in duplicate definition located in
include/hw/virtio/virtio.h.

Signed-off-by: Eric Auger <eric.auger@linaro.org>
---
 include/hw/virtio/virtio.h          |  4 +--
 linux-headers/asm-arm/kvm.h         |  2 ++
 linux-headers/asm-arm64/kvm.h       |  9 +++++++
 linux-headers/asm-s390/kvm.h        | 37 ++++++++++++++++++++++++++
 linux-headers/asm-x86/hyperv.h      | 11 ++++++++
 linux-headers/linux/kvm.h           | 20 +++++++-------
 linux-headers/linux/vfio.h          |  1 +
 linux-headers/linux/virtio_config.h | 11 ++++++--
 linux-headers/linux/virtio_ring.h   | 52 +++++++++++++++++++++----------------
 linux-headers/linux/virtio_types.h  | 46 ++++++++++++++++++++++++++++++++
 10 files changed, 156 insertions(+), 37 deletions(-)
 create mode 100644 linux-headers/linux/virtio_types.h

diff --git a/include/hw/virtio/virtio.h b/include/hw/virtio/virtio.h
index f24997d..f09a7fb 100644
--- a/include/hw/virtio/virtio.h
+++ b/include/hw/virtio/virtio.h
@@ -35,10 +35,10 @@
 /* We've given up on this device. */
 #define VIRTIO_CONFIG_S_FAILED          0x80
 
-/* Some virtio feature bits (currently bits 28 through 31) are reserved for the
+/* Some virtio feature bits (currently bits 28 through 33) are reserved for the
  * transport being used (eg. virtio_ring), the rest are per-device feature bits. */
 #define VIRTIO_TRANSPORT_F_START        28
-#define VIRTIO_TRANSPORT_F_END          32
+#define VIRTIO_TRANSPORT_F_END          33
 
 /* We notify when the ring is completely used, even if the guest is suppressing
  * callbacks */
diff --git a/linux-headers/asm-arm/kvm.h b/linux-headers/asm-arm/kvm.h
index 09ee408..0db25bc 100644
--- a/linux-headers/asm-arm/kvm.h
+++ b/linux-headers/asm-arm/kvm.h
@@ -175,6 +175,8 @@ struct kvm_arch_memory_slot {
 #define   KVM_DEV_ARM_VGIC_OFFSET_SHIFT	0
 #define   KVM_DEV_ARM_VGIC_OFFSET_MASK	(0xffffffffULL << KVM_DEV_ARM_VGIC_OFFSET_SHIFT)
 #define KVM_DEV_ARM_VGIC_GRP_NR_IRQS	3
+#define KVM_DEV_ARM_VGIC_GRP_CTRL       4
+#define   KVM_DEV_ARM_VGIC_CTRL_INIT    0
 
 /* KVM_IRQ_LINE irq field index values */
 #define KVM_ARM_IRQ_TYPE_SHIFT		24
diff --git a/linux-headers/asm-arm64/kvm.h b/linux-headers/asm-arm64/kvm.h
index 8e38878..3ef77a4 100644
--- a/linux-headers/asm-arm64/kvm.h
+++ b/linux-headers/asm-arm64/kvm.h
@@ -78,6 +78,13 @@ struct kvm_regs {
 #define KVM_VGIC_V2_DIST_SIZE		0x1000
 #define KVM_VGIC_V2_CPU_SIZE		0x2000
 
+/* Supported VGICv3 address types  */
+#define KVM_VGIC_V3_ADDR_TYPE_DIST	2
+#define KVM_VGIC_V3_ADDR_TYPE_REDIST	3
+
+#define KVM_VGIC_V3_DIST_SIZE		SZ_64K
+#define KVM_VGIC_V3_REDIST_SIZE		(2 * SZ_64K)
+
 #define KVM_ARM_VCPU_POWER_OFF		0 /* CPU is started in OFF state */
 #define KVM_ARM_VCPU_EL1_32BIT		1 /* CPU running a 32bit VM */
 #define KVM_ARM_VCPU_PSCI_0_2		2 /* CPU uses PSCI v0.2 */
@@ -161,6 +168,8 @@ struct kvm_arch_memory_slot {
 #define   KVM_DEV_ARM_VGIC_OFFSET_SHIFT	0
 #define   KVM_DEV_ARM_VGIC_OFFSET_MASK	(0xffffffffULL << KVM_DEV_ARM_VGIC_OFFSET_SHIFT)
 #define KVM_DEV_ARM_VGIC_GRP_NR_IRQS	3
+#define KVM_DEV_ARM_VGIC_GRP_CTRL	4
+#define   KVM_DEV_ARM_VGIC_CTRL_INIT	0
 
 /* KVM_IRQ_LINE irq field index values */
 #define KVM_ARM_IRQ_TYPE_SHIFT		24
diff --git a/linux-headers/asm-s390/kvm.h b/linux-headers/asm-s390/kvm.h
index d36b2fa..c5a93eb 100644
--- a/linux-headers/asm-s390/kvm.h
+++ b/linux-headers/asm-s390/kvm.h
@@ -57,10 +57,44 @@ struct kvm_s390_io_adapter_req {
 
 /* kvm attr_group  on vm fd */
 #define KVM_S390_VM_MEM_CTRL		0
+#define KVM_S390_VM_TOD			1
+#define KVM_S390_VM_CRYPTO		2
+#define KVM_S390_VM_CPU_MODEL		3
 
 /* kvm attributes for mem_ctrl */
 #define KVM_S390_VM_MEM_ENABLE_CMMA	0
 #define KVM_S390_VM_MEM_CLR_CMMA	1
+#define KVM_S390_VM_MEM_LIMIT_SIZE	2
+
+/* kvm attributes for KVM_S390_VM_TOD */
+#define KVM_S390_VM_TOD_LOW		0
+#define KVM_S390_VM_TOD_HIGH		1
+
+/* kvm attributes for KVM_S390_VM_CPU_MODEL */
+/* processor related attributes are r/w */
+#define KVM_S390_VM_CPU_PROCESSOR	0
+struct kvm_s390_vm_cpu_processor {
+	__u64 cpuid;
+	__u16 ibc;
+	__u8  pad[6];
+	__u64 fac_list[256];
+};
+
+/* machine related attributes are r/o */
+#define KVM_S390_VM_CPU_MACHINE		1
+struct kvm_s390_vm_cpu_machine {
+	__u64 cpuid;
+	__u32 ibc;
+	__u8  pad[4];
+	__u64 fac_mask[256];
+	__u64 fac_list[256];
+};
+
+/* kvm attributes for crypto */
+#define KVM_S390_VM_CRYPTO_ENABLE_AES_KW	0
+#define KVM_S390_VM_CRYPTO_ENABLE_DEA_KW	1
+#define KVM_S390_VM_CRYPTO_DISABLE_AES_KW	2
+#define KVM_S390_VM_CRYPTO_DISABLE_DEA_KW	3
 
 /* for KVM_GET_REGS and KVM_SET_REGS */
 struct kvm_regs {
@@ -107,6 +141,9 @@ struct kvm_guest_debug_arch {
 	struct kvm_hw_breakpoint *hw_bp;
 };
 
+/* for KVM_SYNC_PFAULT and KVM_REG_S390_PFTOKEN */
+#define KVM_S390_PFAULT_TOKEN_INVALID	0xffffffffffffffffULL
+
 #define KVM_SYNC_PREFIX (1UL << 0)
 #define KVM_SYNC_GPRS   (1UL << 1)
 #define KVM_SYNC_ACRS   (1UL << 2)
diff --git a/linux-headers/asm-x86/hyperv.h b/linux-headers/asm-x86/hyperv.h
index 462efe7..90c458e 100644
--- a/linux-headers/asm-x86/hyperv.h
+++ b/linux-headers/asm-x86/hyperv.h
@@ -187,6 +187,17 @@
 #define HV_X64_MSR_SINT14			0x4000009E
 #define HV_X64_MSR_SINT15			0x4000009F
 
+/*
+ * Synthetic Timer MSRs. Four timers per vcpu.
+ */
+#define HV_X64_MSR_STIMER0_CONFIG		0x400000B0
+#define HV_X64_MSR_STIMER0_COUNT		0x400000B1
+#define HV_X64_MSR_STIMER1_CONFIG		0x400000B2
+#define HV_X64_MSR_STIMER1_COUNT		0x400000B3
+#define HV_X64_MSR_STIMER2_CONFIG		0x400000B4
+#define HV_X64_MSR_STIMER2_COUNT		0x400000B5
+#define HV_X64_MSR_STIMER3_CONFIG		0x400000B6
+#define HV_X64_MSR_STIMER3_COUNT		0x400000B7
 
 #define HV_X64_MSR_HYPERCALL_ENABLE		0x00000001
 #define HV_X64_MSR_HYPERCALL_PAGE_ADDRESS_SHIFT	12
diff --git a/linux-headers/linux/kvm.h b/linux-headers/linux/kvm.h
index 12045a1..60a54c8 100644
--- a/linux-headers/linux/kvm.h
+++ b/linux-headers/linux/kvm.h
@@ -491,6 +491,11 @@ struct kvm_s390_emerg_info {
 	__u16 code;
 };
 
+#define KVM_S390_STOP_FLAG_STORE_STATUS	0x01
+struct kvm_s390_stop_info {
+	__u32 flags;
+};
+
 struct kvm_s390_mchk_info {
 	__u64 cr14;
 	__u64 mcic;
@@ -509,6 +514,7 @@ struct kvm_s390_irq {
 		struct kvm_s390_emerg_info emerg;
 		struct kvm_s390_extcall_info extcall;
 		struct kvm_s390_prefix_info prefix;
+		struct kvm_s390_stop_info stop;
 		struct kvm_s390_mchk_info mchk;
 		char reserved[64];
 	} u;
@@ -647,11 +653,7 @@ struct kvm_ppc_smmu_info {
 #define KVM_CAP_MP_STATE 14
 #define KVM_CAP_COALESCED_MMIO 15
 #define KVM_CAP_SYNC_MMU 16  /* Changes to host mmap are reflected in guest */
-#define KVM_CAP_DEVICE_ASSIGNMENT 17
 #define KVM_CAP_IOMMU 18
-#ifdef __KVM_HAVE_MSI
-#define KVM_CAP_DEVICE_MSI 20
-#endif
 /* Bug in KVM_SET_USER_MEMORY_REGION fixed: */
 #define KVM_CAP_DESTROY_MEMORY_REGION_WORKS 21
 #define KVM_CAP_USER_NMI 22
@@ -663,10 +665,6 @@ struct kvm_ppc_smmu_info {
 #endif
 #define KVM_CAP_IRQ_ROUTING 25
 #define KVM_CAP_IRQ_INJECT_STATUS 26
-#define KVM_CAP_DEVICE_DEASSIGNMENT 27
-#ifdef __KVM_HAVE_MSIX
-#define KVM_CAP_DEVICE_MSIX 28
-#endif
 #define KVM_CAP_ASSIGN_DEV_IRQ 29
 /* Another bug in KVM_SET_USER_MEMORY_REGION fixed: */
 #define KVM_CAP_JOIN_MEMORY_REGIONS_WORKS 30
@@ -761,6 +759,7 @@ struct kvm_ppc_smmu_info {
 #define KVM_CAP_PPC_FIXUP_HCALL 103
 #define KVM_CAP_PPC_ENABLE_HCALL 104
 #define KVM_CAP_CHECK_EXTENSION_VM 105
+#define KVM_CAP_S390_USER_SIGP 106
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -960,6 +959,8 @@ enum kvm_device_type {
 #define KVM_DEV_TYPE_ARM_VGIC_V2	KVM_DEV_TYPE_ARM_VGIC_V2
 	KVM_DEV_TYPE_FLIC,
 #define KVM_DEV_TYPE_FLIC		KVM_DEV_TYPE_FLIC
+	KVM_DEV_TYPE_ARM_VGIC_V3,
+#define KVM_DEV_TYPE_ARM_VGIC_V3	KVM_DEV_TYPE_ARM_VGIC_V3
 	KVM_DEV_TYPE_MAX,
 };
 
@@ -1107,9 +1108,6 @@ struct kvm_s390_ucas_mapping {
 #define KVM_X86_SETUP_MCE         _IOW(KVMIO,  0x9c, __u64)
 #define KVM_X86_GET_MCE_CAP_SUPPORTED _IOR(KVMIO,  0x9d, __u64)
 #define KVM_X86_SET_MCE           _IOW(KVMIO,  0x9e, struct kvm_x86_mce)
-/* IA64 stack access */
-#define KVM_IA64_VCPU_GET_STACK   _IOR(KVMIO,  0x9a, void *)
-#define KVM_IA64_VCPU_SET_STACK   _IOW(KVMIO,  0x9b, void *)
 /* Available with KVM_CAP_VCPU_EVENTS */
 #define KVM_GET_VCPU_EVENTS       _IOR(KVMIO,  0x9f, struct kvm_vcpu_events)
 #define KVM_SET_VCPU_EVENTS       _IOW(KVMIO,  0xa0, struct kvm_vcpu_events)
diff --git a/linux-headers/linux/vfio.h b/linux-headers/linux/vfio.h
index 0f21aa6..95ba870 100644
--- a/linux-headers/linux/vfio.h
+++ b/linux-headers/linux/vfio.h
@@ -333,6 +333,7 @@ enum {
 	VFIO_PCI_MSI_IRQ_INDEX,
 	VFIO_PCI_MSIX_IRQ_INDEX,
 	VFIO_PCI_ERR_IRQ_INDEX,
+	VFIO_PCI_REQ_IRQ_INDEX,
 	VFIO_PCI_NUM_IRQS
 };
 
diff --git a/linux-headers/linux/virtio_config.h b/linux-headers/linux/virtio_config.h
index 75dc20b..a11101e 100644
--- a/linux-headers/linux/virtio_config.h
+++ b/linux-headers/linux/virtio_config.h
@@ -38,20 +38,27 @@
 #define VIRTIO_CONFIG_S_DRIVER		2
 /* Driver has used its parts of the config, and is happy */
 #define VIRTIO_CONFIG_S_DRIVER_OK	4
+/* Driver has finished configuring features */
+#define VIRTIO_CONFIG_S_FEATURES_OK	8
 /* We've given up on this device. */
 #define VIRTIO_CONFIG_S_FAILED		0x80
 
-/* Some virtio feature bits (currently bits 28 through 31) are reserved for the
+/* Some virtio feature bits (currently bits 28 through 32) are reserved for the
  * transport being used (eg. virtio_ring), the rest are per-device feature
  * bits. */
 #define VIRTIO_TRANSPORT_F_START	28
-#define VIRTIO_TRANSPORT_F_END		32
+#define VIRTIO_TRANSPORT_F_END		33
 
+#ifndef VIRTIO_CONFIG_NO_LEGACY
 /* Do we get callbacks when the ring is completely used, even if we've
  * suppressed them? */
 #define VIRTIO_F_NOTIFY_ON_EMPTY	24
 
 /* Can the device handle any descriptor layout? */
 #define VIRTIO_F_ANY_LAYOUT		27
+#endif /* VIRTIO_CONFIG_NO_LEGACY */
+
+/* v1.0 compliant. */
+#define VIRTIO_F_VERSION_1		32
 
 #endif /* _LINUX_VIRTIO_CONFIG_H */
diff --git a/linux-headers/linux/virtio_ring.h b/linux-headers/linux/virtio_ring.h
index 1b333e2..a81def3 100644
--- a/linux-headers/linux/virtio_ring.h
+++ b/linux-headers/linux/virtio_ring.h
@@ -32,6 +32,7 @@
  *
  * Copyright Rusty Russell IBM Corporation 2007. */
 #include <linux/types.h>
+#include <linux/virtio_types.h>
 
 /* This marks a buffer as continuing via the next field. */
 #define VRING_DESC_F_NEXT	1
@@ -61,32 +62,32 @@
 /* Virtio ring descriptors: 16 bytes.  These can chain together via "next". */
 struct vring_desc {
 	/* Address (guest-physical). */
-	__u64 addr;
+	__virtio64 addr;
 	/* Length. */
-	__u32 len;
+	__virtio32 len;
 	/* The flags as indicated above. */
-	__u16 flags;
+	__virtio16 flags;
 	/* We chain unused descriptors via this, too */
-	__u16 next;
+	__virtio16 next;
 };
 
 struct vring_avail {
-	__u16 flags;
-	__u16 idx;
-	__u16 ring[];
+	__virtio16 flags;
+	__virtio16 idx;
+	__virtio16 ring[];
 };
 
 /* u32 is used here for ids for padding reasons. */
 struct vring_used_elem {
 	/* Index of start of used descriptor chain. */
-	__u32 id;
+	__virtio32 id;
 	/* Total length of the descriptor chain which was used (written to) */
-	__u32 len;
+	__virtio32 len;
 };
 
 struct vring_used {
-	__u16 flags;
-	__u16 idx;
+	__virtio16 flags;
+	__virtio16 idx;
 	struct vring_used_elem ring[];
 };
 
@@ -100,6 +101,13 @@ struct vring {
 	struct vring_used *used;
 };
 
+/* Alignment requirements for vring elements.
+ * When using pre-virtio 1.0 layout, these fall out naturally.
+ */
+#define VRING_AVAIL_ALIGN_SIZE 2
+#define VRING_USED_ALIGN_SIZE 4
+#define VRING_DESC_ALIGN_SIZE 16
+
 /* The standard layout for the ring is a continuous chunk of memory which looks
  * like this.  We assume num is a power of 2.
  *
@@ -109,25 +117,25 @@ struct vring {
  *	struct vring_desc desc[num];
  *
  *	// A ring of available descriptor heads with free-running index.
- *	__u16 avail_flags;
- *	__u16 avail_idx;
- *	__u16 available[num];
- *	__u16 used_event_idx;
+ *	__virtio16 avail_flags;
+ *	__virtio16 avail_idx;
+ *	__virtio16 available[num];
+ *	__virtio16 used_event_idx;
  *
  *	// Padding to the next align boundary.
  *	char pad[];
  *
  *	// A ring of used descriptor heads with free-running index.
- *	__u16 used_flags;
- *	__u16 used_idx;
+ *	__virtio16 used_flags;
+ *	__virtio16 used_idx;
  *	struct vring_used_elem used[num];
- *	__u16 avail_event_idx;
+ *	__virtio16 avail_event_idx;
  * };
  */
 /* We publish the used event index at the end of the available ring, and vice
  * versa. They are at the end for backwards compatibility. */
 #define vring_used_event(vr) ((vr)->avail->ring[(vr)->num])
-#define vring_avail_event(vr) (*(__u16 *)&(vr)->used->ring[(vr)->num])
+#define vring_avail_event(vr) (*(__virtio16 *)&(vr)->used->ring[(vr)->num])
 
 static __inline__ void vring_init(struct vring *vr, unsigned int num, void *p,
 			      unsigned long align)
@@ -135,15 +143,15 @@ static __inline__ void vring_init(struct vring *vr, unsigned int num, void *p,
 	vr->num = num;
 	vr->desc = p;
 	vr->avail = p + num*sizeof(struct vring_desc);
-	vr->used = (void *)(((unsigned long)&vr->avail->ring[num] + sizeof(__u16)
+	vr->used = (void *)(((unsigned long)&vr->avail->ring[num] + sizeof(__virtio16)
 		+ align-1) & ~(align - 1));
 }
 
 static __inline__ unsigned vring_size(unsigned int num, unsigned long align)
 {
-	return ((sizeof(struct vring_desc) * num + sizeof(__u16) * (3 + num)
+	return ((sizeof(struct vring_desc) * num + sizeof(__virtio16) * (3 + num)
 		 + align - 1) & ~(align - 1))
-		+ sizeof(__u16) * 3 + sizeof(struct vring_used_elem) * num;
+		+ sizeof(__virtio16) * 3 + sizeof(struct vring_used_elem) * num;
 }
 
 /* The following is used with USED_EVENT_IDX and AVAIL_EVENT_IDX */
diff --git a/linux-headers/linux/virtio_types.h b/linux-headers/linux/virtio_types.h
new file mode 100644
index 0000000..6162bdf
--- /dev/null
+++ b/linux-headers/linux/virtio_types.h
@@ -0,0 +1,46 @@
+#ifndef _LINUX_VIRTIO_TYPES_H
+#define _LINUX_VIRTIO_TYPES_H
+/* Type definitions for virtio implementations.
+ *
+ * This header is BSD licensed so anyone can use the definitions to implement
+ * compatible drivers/servers.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ * 2. Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in the
+ *    documentation and/or other materials provided with the distribution.
+ * 3. Neither the name of IBM nor the names of its contributors
+ *    may be used to endorse or promote products derived from this software
+ *    without specific prior written permission.
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS ``AS IS'' AND
+ * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
+ * ARE DISCLAIMED.  IN NO EVENT SHALL IBM OR CONTRIBUTORS BE LIABLE
+ * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
+ * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
+ * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
+ * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
+ * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
+ * SUCH DAMAGE.
+ *
+ * Copyright (C) 2014 Red Hat, Inc.
+ * Author: Michael S. Tsirkin <mst@redhat.com>
+ */
+#include <linux/types.h>
+
+/*
+ * __virtio{16,32,64} have the following meaning:
+ * - __u{16,32,64} for virtio devices in legacy mode, accessed in native endian
+ * - __le{16,32,64} for standard-compliant virtio devices
+ */
+
+typedef __u16 __bitwise__ __virtio16;
+typedef __u32 __bitwise__ __virtio32;
+typedef __u64 __bitwise__ __virtio64;
+
+#endif /* _LINUX_VIRTIO_TYPES_H */
-- 
1.8.3.2
