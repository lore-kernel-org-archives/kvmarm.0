From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH v2 1/7] KVM: api: introduce KVM_IRQ_ROUTING_EXTENDED_MSI
Date: Thu,  9 Jul 2015 10:22:11 +0200
Message-ID: <1436430137-24205-2-git-send-email-eric.auger@linaro.org>
References: <1436430137-24205-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 97D005827F
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Jul 2015 04:11:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mIJ-Yt68qqsg for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Jul 2015 04:11:11 -0400 (EDT)
Received: from mail-wi0-f180.google.com (mail-wi0-f180.google.com
 [209.85.212.180])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CC0395827D
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Jul 2015 04:11:10 -0400 (EDT)
Received: by wifm2 with SMTP id m2so11064948wif.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 09 Jul 2015 01:22:45 -0700 (PDT)
In-Reply-To: <1436430137-24205-1-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@st.com, eric.auger@linaro.org, linux-arm-kernel@lists.infradead.org, marc.zyngier@arm.com, christoffer.dall@linaro.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: andre.przywara@arm.com, pbonzini@redhat.com, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

On ARM, the MSI msg (address and data) comes along with
out-of-band device ID information. The device ID encodes the
device that writes the MSI msg. Let's convey the device id in
kvm_irq_routing_msi and use a new routing entry type to
indicate the devid is populated.

Signed-off-by: Eric Auger <eric.auger@linaro.org>

---

v1 -> v2:
- devid id passed in kvm_irq_routing_msi instead of in
  kvm_irq_routing_entry

RFC -> PATCH
- remove kvm_irq_routing_extended_msi and use union instead
---
 Documentation/virtual/kvm/api.txt | 10 +++++++++-
 include/uapi/linux/kvm.h          |  6 +++++-
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
index bea8de7..3d920cd 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -1453,6 +1453,7 @@ struct kvm_irq_routing_entry {
 #define KVM_IRQ_ROUTING_IRQCHIP 1
 #define KVM_IRQ_ROUTING_MSI 2
 #define KVM_IRQ_ROUTING_S390_ADAPTER 3
+#define KVM_IRQ_ROUTING_EXTENDED_MSI 4
 
 No flags are specified so far, the corresponding field must be set to zero.
 
@@ -1465,9 +1466,16 @@ struct kvm_irq_routing_msi {
 	__u32 address_lo;
 	__u32 address_hi;
 	__u32 data;
-	__u32 pad;
+	union {
+		__u32 pad;
+		__u32 devid;
+	};
 };
 
+for KVM_IRQ_ROUTING_EXTENDED_MSI routing entry type, the kvm_irq_routing_msi
+routing entry is used and devid is populated with the device ID that wrote
+the MSI message. For PCI, this is usually a BFD identifier in the lower 16 bits.
+
 struct kvm_irq_routing_s390_adapter {
 	__u64 ind_addr;
 	__u64 summary_addr;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 9a261e5..39ec164 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -829,7 +829,10 @@ struct kvm_irq_routing_msi {
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
@@ -844,6 +847,7 @@ struct kvm_irq_routing_s390_adapter {
 #define KVM_IRQ_ROUTING_IRQCHIP 1
 #define KVM_IRQ_ROUTING_MSI 2
 #define KVM_IRQ_ROUTING_S390_ADAPTER 3
+#define KVM_IRQ_ROUTING_EXTENDED_MSI 4
 
 struct kvm_irq_routing_entry {
 	__u32 gsi;
-- 
1.9.1
