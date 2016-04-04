From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH v4 1/7] KVM: api: pass the devid in the msi routing entry
Date: Mon,  4 Apr 2016 10:47:31 +0200
Message-ID: <1459759657-7402-2-git-send-email-eric.auger@linaro.org>
References: <1459759657-7402-1-git-send-email-eric.auger@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1459759657-7402-1-git-send-email-eric.auger@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: eric.auger@st.com, eric.auger@linaro.org, christoffer.dall@linaro.org, marc.zyngier@arm.com, andre.przywara@arm.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: patches@linaro.org, pbonzini@redhat.com, p.fedin@samsung.com, Manish.Jaggi@caviumnetworks.com
List-Id: kvmarm@lists.cs.columbia.edu

On ARM, the MSI msg (address and data) comes along with
out-of-band device ID information. The device ID encodes the
device that writes the MSI msg. Let's convey the device id in
kvm_irq_routing_msi and use KVM_MSI_VALID_DEVID flag value in
kvm_irq_routing_entry to indicate the msi devid is populated.

Signed-off-by: Eric Auger <eric.auger@linaro.org>

---
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
 Documentation/virtual/kvm/api.txt | 18 ++++++++++++++++--
 include/uapi/linux/kvm.h          |  5 ++++-
 2 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
index 536f19b..c436bb6 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -1462,7 +1462,10 @@ struct kvm_irq_routing_entry {
 #define KVM_IRQ_ROUTING_S390_ADAPTER 3
 #define KVM_IRQ_ROUTING_HV_SINT 4
 
-No flags are specified so far, the corresponding field must be set to zero.
+flags:
+- KVM_MSI_VALID_DEVID: used along with KVM_IRQ_ROUTING_MSI
+  routing entry type, it tells the msi devid contains a valid value.
+- zero otherwise
 
 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;
@@ -1473,9 +1476,20 @@ struct kvm_irq_routing_msi {
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
+The per-VM KVM_CAP_MSI_DEVID capability advertises the need to provide
+the device ID. If this capability is not set, userland cannot rely on
+the kernel to allow the KVM_MSI_VALID_DEVID flag being set.
+
 struct kvm_irq_routing_s390_adapter {
 	__u64 ind_addr;
 	__u64 summary_addr;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 6a02871..52a973f 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -865,7 +865,10 @@ struct kvm_irq_routing_msi {
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

