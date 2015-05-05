From: =?UTF-8?q?J=C3=A9r=C3=A9my=20Fangu=C3=A8de?=
	<j.fanguede@virtualopensystems.com>
Subject: [RFC] ARM/ARM64: KVM: Implement KVM_FLUSH_DCACHE_GPA ioctl
Date: Tue,  5 May 2015 11:13:11 +0200
Message-ID: <1430817191-6231-1-git-send-email-j.fanguede@virtualopensystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Paolo Bonzini <pbonzini@redhat.com>, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, qemu-devel@nongnu.org, tech@virtualopensystems.com, =?UTF-8?q?J=C3=A9r=C3=A9my=20Fangu=C3=A8de?= <j.fanguede@virtualopensystems.com>
List-Id: kvmarm@lists.cs.columbia.edu

To maintain cache coherency on ARM, we may need a mechanism to flush
the data cache.

This patch implements KVM_FLUSH_DCACHE_GPA vm ioctl which flushes the
data cache at a specified address range. The input argument is a
struct kvm_mem_addr containing the guest physical address and the
length.

Signed-off-by: J=C3=A9r=C3=A9my Fangu=C3=A8de <j.fanguede@virtualopensy=
stems.com>
---
 arch/arm/kvm/arm.c       | 13 +++++++++++++
 include/uapi/linux/kvm.h |  6 ++++++
 2 files changed, 19 insertions(+)

diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index d9631ec..8638fd2 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -886,6 +886,19 @@ long kvm_arch_vm_ioctl(struct file *filp,
=20
 		return 0;
 	}
+	case KVM_FLUSH_DCACHE_GPA: {
+		struct kvm_mem_addr mem_addr;
+		hva_t hva;
+		gpa_t gpa;
+
+		if (copy_from_user(&mem_addr, argp, sizeof(mem_addr)))
+			return -EFAULT;
+
+		gpa =3D mem_addr.addr;
+		hva =3D gfn_to_hva(kvm, gpa_to_gfn(gpa)) | (gpa & ~PAGE_MASK);
+		kvm_flush_dcache_to_poc((void *)hva, mem_addr.len);
+		return 0;
+	}
 	default:
 		return -EINVAL;
 	}
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 4b60056..3bc599e 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -978,6 +978,11 @@ struct kvm_arm_device_addr {
 	__u64 addr;
 };
=20
+struct kvm_mem_addr {
+	__u64 addr;
+	__u32 len;
+};
+
 /*
  * Device control API, available with KVM_CAP_DEVICE_CTRL
  */
@@ -1199,6 +1204,7 @@ struct kvm_s390_ucas_mapping {
 /* Available with KVM_CAP_S390_IRQ_STATE */
 #define KVM_S390_SET_IRQ_STATE	  _IOW(KVMIO, 0xb5, struct kvm_s390_irq=
_state)
 #define KVM_S390_GET_IRQ_STATE	  _IOW(KVMIO, 0xb6, struct kvm_s390_irq=
_state)
+#define KVM_FLUSH_DCACHE_GPA     _IOW(KVMIO,  0xb7, struct kvm_mem_add=
r)
=20
 #define KVM_DEV_ASSIGN_ENABLE_IOMMU	(1 << 0)
 #define KVM_DEV_ASSIGN_PCI_2_3		(1 << 1)
--=20
1.9.1

