From: Eric Auger <eric.auger@linaro.org>
Subject: [RFC 1/6] KVM: api: add kvm_irq_routing_extended_msi
Date: Thu, 18 Jun 2015 19:40:53 +0200
Message-ID: <1434649258-27065-2-git-send-email-eric.auger@linaro.org>
References: <1434649258-27065-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 50E2255FF2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Jun 2015 13:30:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fCS1feTwzOuW for <kvmarm@lists.cs.columbia.edu>;
 Thu, 18 Jun 2015 13:30:40 -0400 (EDT)
Received: from mail-wi0-f173.google.com (mail-wi0-f173.google.com
 [209.85.212.173])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5E6A655FF4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Jun 2015 13:30:40 -0400 (EDT)
Received: by wicgi11 with SMTP id gi11so741265wic.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Jun 2015 10:41:21 -0700 (PDT)
In-Reply-To: <1434649258-27065-1-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@st.com, eric.auger@linaro.org, christoffer.dall@linaro.org, marc.zyngier@arm.com, andre.przywara@arm.com, p.fedin@samsung.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

On ARM, the MSI msg (address and data) comes along with
out-of-band device ID information. The device ID encodes the device
that composes the MSI msg. Let's create a new routing entry structure
that enables to encode that information on top of standard MSI
message

Signed-off-by: Eric Auger <eric.auger@linaro.org>
---
 Documentation/virtual/kvm/api.txt | 9 +++++++++
 include/uapi/linux/kvm.h          | 9 +++++++++
 2 files changed, 18 insertions(+)

diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
index d20fd94..bcec91e 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -1419,6 +1419,7 @@ struct kvm_irq_routing_entry {
 		struct kvm_irq_routing_irqchip irqchip;
 		struct kvm_irq_routing_msi msi;
 		struct kvm_irq_routing_s390_adapter adapter;
+		struct kvm_irq_routing_extended_msi ext_msi;
 		__u32 pad[8];
 	} u;
 };
@@ -1427,6 +1428,7 @@ struct kvm_irq_routing_entry {
 #define KVM_IRQ_ROUTING_IRQCHIP 1
 #define KVM_IRQ_ROUTING_MSI 2
 #define KVM_IRQ_ROUTING_S390_ADAPTER 3
+#define KVM_IRQ_ROUTING_EXTENDED_MSI 4
 
 No flags are specified so far, the corresponding field must be set to zero.
 
@@ -1442,6 +1444,13 @@ struct kvm_irq_routing_msi {
 	__u32 pad;
 };
 
+struct kvm_irq_routing_extended_msi {
+	__u32 address_lo;
+	__u32 address_hi;
+	__u32 data;
+	__u32 devid;
+};
+
 struct kvm_irq_routing_s390_adapter {
 	__u64 ind_addr;
 	__u64 summary_addr;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 2a23705..e3f65a0 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -829,6 +829,13 @@ struct kvm_irq_routing_msi {
 	__u32 pad;
 };
 
+struct kvm_irq_routing_extended_msi {
+	__u32 address_lo;
+	__u32 address_hi;
+	__u32 data;
+	__u32 devid;
+};
+
 struct kvm_irq_routing_s390_adapter {
 	__u64 ind_addr;
 	__u64 summary_addr;
@@ -841,6 +848,7 @@ struct kvm_irq_routing_s390_adapter {
 #define KVM_IRQ_ROUTING_IRQCHIP 1
 #define KVM_IRQ_ROUTING_MSI 2
 #define KVM_IRQ_ROUTING_S390_ADAPTER 3
+#define KVM_IRQ_ROUTING_EXTENDED_MSI 4
 
 struct kvm_irq_routing_entry {
 	__u32 gsi;
@@ -851,6 +859,7 @@ struct kvm_irq_routing_entry {
 		struct kvm_irq_routing_irqchip irqchip;
 		struct kvm_irq_routing_msi msi;
 		struct kvm_irq_routing_s390_adapter adapter;
+		struct kvm_irq_routing_extended_msi ext_msi;
 		__u32 pad[8];
 	} u;
 };
-- 
1.9.1
