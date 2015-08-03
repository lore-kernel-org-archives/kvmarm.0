From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH v3 1/7] KVM: api: pass the devid in the msi routing entry
Date: Mon,  3 Aug 2015 17:31:23 +0200
Message-ID: <1438615889-10892-2-git-send-email-eric.auger@linaro.org>
References: <1438615889-10892-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3AB5059E50
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Aug 2015 11:19:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id m7RXVcEiyHmj for <kvmarm@lists.cs.columbia.edu>;
 Mon,  3 Aug 2015 11:19:39 -0400 (EDT)
Received: from mail-wi0-f169.google.com (mail-wi0-f169.google.com
 [209.85.212.169])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DA9A659E4C
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Aug 2015 11:19:38 -0400 (EDT)
Received: by wicmv11 with SMTP id mv11so140545198wic.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 03 Aug 2015 08:32:20 -0700 (PDT)
In-Reply-To: <1438615889-10892-1-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@st.com, eric.auger@linaro.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, christoffer.dall@linaro.org, marc.zyngier@arm.com
Cc: pbonzini@redhat.com, andre.przywara@arm.com, linux-kernel@vger.kernel.org, patches@linaro.org
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
index 1b53155..d4b29df 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -1454,7 +1454,10 @@ struct kvm_irq_routing_entry {
 #define KVM_IRQ_ROUTING_MSI 2
 #define KVM_IRQ_ROUTING_S390_ADAPTER 3
 
-No flags are specified so far, the corresponding field must be set to zero.
+flags:
+- KVM_MSI_VALID_DEVID: used along with KVM_IRQ_ROUTING_MSI
+  routing entry type, it tells the msi devid contains a valid value.
+- zero otherwise
 
 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;
@@ -1465,9 +1468,20 @@ struct kvm_irq_routing_msi {
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
index 1c48def..3c865b9 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -830,7 +830,10 @@ struct kvm_irq_routing_msi {
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
