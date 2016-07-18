From: Eric Auger <eric.auger@redhat.com>
Subject: [RFC v7 1/7] KVM: api: pass the devid in the msi routing entry
Date: Mon, 18 Jul 2016 13:25:51 +0000
Message-ID: <1468848357-2331-2-git-send-email-eric.auger@redhat.com>
References: <1468848357-2331-1-git-send-email-eric.auger@redhat.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1468848357-2331-1-git-send-email-eric.auger@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: eric.auger@redhat.com, eric.auger.pro@gmail.com, marc.zyngier@arm.com, christoffer.dall@linaro.org, andre.przywara@arm.com
Cc: drjones@redhat.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

On ARM, the MSI msg (address and data) comes along with
out-of-band device ID information. The device ID encodes the
device that writes the MSI msg. Let's convey the device id in
kvm_irq_routing_msi and use KVM_MSI_VALID_DEVID flag value in
kvm_irq_routing_entry to indicate the msi devid is populated.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Reviewed-by: Andre Przywara <andre.przywara@arm.com>

---

v6 -> v7:
- Added Andre's R-b

v4 -> v5:
- some rephrasing in api.txt according to Christoffer's comments
v2 -> v3:
- replace usage of KVM_IRQ_ROUTING_EXTENDED_MSI type by
  usage of KVM_MSI_VALID_DEVID flag
- add note about KVM_CAP_MSI_DEVID capability

v1 -> v2:
- devid id passed in kvm_irq_routing_msi instead of in
  kvm_irq_routing_entry

RFC -> PATCH
- remove kvm_irq_routing_extended_msi and use union instead
---
 Documentation/virtual/kvm/api.txt | 19 +++++++++++++++++--
 include/uapi/linux/kvm.h          |  5 ++++-
 2 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
index f60b137..0065c8e 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -1468,7 +1468,11 @@ struct kvm_irq_routing_entry {
 #define KVM_IRQ_ROUTING_S390_ADAPTER 3
 #define KVM_IRQ_ROUTING_HV_SINT 4
 
-No flags are specified so far, the corresponding field must be set to zero.
+flags:
+- KVM_MSI_VALID_DEVID: used along with KVM_IRQ_ROUTING_MSI
+  routing entry type, specifies that the devid field contains
+  a valid value.
+- zero otherwise
 
 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;
@@ -1479,9 +1483,20 @@ struct kvm_irq_routing_msi {
 	__u32 address_lo;
 	__u32 address_hi;
 	__u32 data;
-	__u32 pad;
+	union {
+		__u32 pad;
+		__u32 devid;
+	};
 };
 
+devid: If KVM_MSI_VALID_DEVID is set, contains a unique device identifier
+       for the device that wrote the MSI message.
+       For PCI, this is usually a BFD identifier in the lower 16 bits.
+
+The per-VM KVM_CAP_MSI_DEVID capability advertises the requirement to
+provide the device ID. If this capability is not set, userland cannot
+rely on the kernel to allow the KVM_MSI_VALID_DEVID flag being set.
+
 struct kvm_irq_routing_s390_adapter {
 	__u64 ind_addr;
 	__u64 summary_addr;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index d8c4c32..eb22208 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -879,7 +879,10 @@ struct kvm_irq_routing_msi {
 	__u32 address_lo;
 	__u32 address_hi;
 	__u32 data;
-	__u32 pad;
+	union {
+		__u32 pad;
+		__u32 devid;
+	};
 };
 
 struct kvm_irq_routing_s390_adapter {
-- 
1.9.1

