From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH 1/7] KVM: api: add kvm_irq_routing_extended_msi
Date: Mon, 29 Jun 2015 17:37:11 +0200
Message-ID: <1435592237-17924-2-git-send-email-eric.auger@linaro.org>
References: <1435592237-17924-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5AB0D569D6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Jun 2015 11:26:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gVuxP-w3wvtz for <kvmarm@lists.cs.columbia.edu>;
 Mon, 29 Jun 2015 11:26:39 -0400 (EDT)
Received: from mail-wi0-f181.google.com (mail-wi0-f181.google.com
 [209.85.212.181])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6509E569D2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Jun 2015 11:26:39 -0400 (EDT)
Received: by wicgi11 with SMTP id gi11so75971152wic.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Jun 2015 08:37:48 -0700 (PDT)
In-Reply-To: <1435592237-17924-1-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@st.com, eric.auger@linaro.org, linux-arm-kernel@lists.infradead.org, marc.zyngier@arm.com, christoffer.dall@linaro.org, andre.przywara@arm.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: pbonzini@redhat.com, p.fedin@samsung.com, linux-kernel@vger.kernel.org, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

On ARM, the MSI msg (address and data) comes along with
out-of-band device ID information. The device ID encodes the device
that composes the MSI msg. Let's create a new routing entry type,
dubbed KVM_IRQ_ROUTING_EXTENDED_MSI and use the __u32 pad space
to convey the device ID.

Signed-off-by: Eric Auger <eric.auger@linaro.org>

---

RFC -> PATCH
- remove kvm_irq_routing_extended_msi and use union instead
---
 Documentation/virtual/kvm/api.txt | 9 ++++++++-
 include/uapi/linux/kvm.h          | 6 +++++-
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
index d20fd94..6426ae9 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -1414,7 +1414,10 @@ struct kvm_irq_routing_entry {
 	__u32 gsi;
 	__u32 type;
 	__u32 flags;
-	__u32 pad;
+	union {
+		__u32 pad;
+		__u32 devid;
+	};
 	union {
 		struct kvm_irq_routing_irqchip irqchip;
 		struct kvm_irq_routing_msi msi;
@@ -1427,6 +1430,10 @@ struct kvm_irq_routing_entry {
 #define KVM_IRQ_ROUTING_IRQCHIP 1
 #define KVM_IRQ_ROUTING_MSI 2
 #define KVM_IRQ_ROUTING_S390_ADAPTER 3
+#define KVM_IRQ_ROUTING_EXTENDED_MSI 4
+
+In case of KVM_IRQ_ROUTING_EXTENDED_MSI routing type, devid is used to convey
+the device ID.
 
 No flags are specified so far, the corresponding field must be set to zero.
 
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 2a23705..8484681 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -841,12 +841,16 @@ struct kvm_irq_routing_s390_adapter {
 #define KVM_IRQ_ROUTING_IRQCHIP 1
 #define KVM_IRQ_ROUTING_MSI 2
 #define KVM_IRQ_ROUTING_S390_ADAPTER 3
+#define KVM_IRQ_ROUTING_EXTENDED_MSI 4
 
 struct kvm_irq_routing_entry {
 	__u32 gsi;
 	__u32 type;
 	__u32 flags;
-	__u32 pad;
+	union {
+		__u32 pad;
+		__u32 devid;
+	};
 	union {
 		struct kvm_irq_routing_irqchip irqchip;
 		struct kvm_irq_routing_msi msi;
-- 
1.9.1
