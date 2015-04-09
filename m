From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH 1/2] kvm: introduce kvm_arch_msi_data_to_gsi
Date: Thu,  9 Apr 2015 16:20:07 +0100
Message-ID: <1428592808-4424-2-git-send-email-eric.auger@linaro.org>
References: <1428592808-4424-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0C83C4BF0B
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Apr 2015 11:12:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iWKfEOSd8OvK for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Apr 2015 11:12:44 -0400 (EDT)
Received: from mail-wi0-f182.google.com (mail-wi0-f182.google.com
 [209.85.212.182])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C745B4BF01
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Apr 2015 11:12:43 -0400 (EDT)
Received: by wiaa2 with SMTP id a2so102716432wia.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 09 Apr 2015 08:20:19 -0700 (PDT)
In-Reply-To: <1428592808-4424-1-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@st.com, eric.auger@linaro.org, qemu-devel@nongnu.org, pbonzini@redhat.com, peter.maydell@linaro.org, cornelia.huck@de.ibm.com, borntraeger@de.ibm.com, agraf@suse.de, james.hogan@imgtec.com
Cc: aik@ozlabs.ru, kvmarm@lists.cs.columbia.edu, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

On ARM the MSI data corresponds to the shared peripheral interrupt (SPI)
ID. This latter equals to the SPI index + 32. to retrieve the SPI index,
matching the gsi, an architecture specific function is introduced.

Signed-off-by: Eric Auger <eric.auger@linaro.org>
---
 include/sysemu/kvm.h | 2 ++
 kvm-all.c            | 2 +-
 target-arm/kvm.c     | 5 +++++
 target-i386/kvm.c    | 5 +++++
 target-mips/kvm.c    | 5 +++++
 target-ppc/kvm.c     | 5 +++++
 target-s390x/kvm.c   | 5 +++++
 7 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
index 197e6c0..ebd8b17 100644
--- a/include/sysemu/kvm.h
+++ b/include/sysemu/kvm.h
@@ -286,6 +286,8 @@ void kvm_arch_init_irq_routing(KVMState *s);
 int kvm_arch_fixup_msi_route(struct kvm_irq_routing_entry *route,
                              uint64_t address, uint32_t data);
 
+int kvm_arch_msi_data_to_gsi(uint32_t data);
+
 int kvm_set_irq(KVMState *s, int irq, int level);
 int kvm_irqchip_send_msi(KVMState *s, MSIMessage msg);
 
diff --git a/kvm-all.c b/kvm-all.c
index dd44f8c..3e9675e 100644
--- a/kvm-all.c
+++ b/kvm-all.c
@@ -1228,7 +1228,7 @@ int kvm_irqchip_add_msi_route(KVMState *s, MSIMessage msg)
     int virq;
 
     if (kvm_gsi_direct_mapping()) {
-        return msg.data & 0xffff;
+        return kvm_arch_msi_data_to_gsi(msg.data);
     }
 
     if (!kvm_gsi_routing_enabled()) {
diff --git a/target-arm/kvm.c b/target-arm/kvm.c
index fdd9ba3..05d5634 100644
--- a/target-arm/kvm.c
+++ b/target-arm/kvm.c
@@ -598,3 +598,8 @@ int kvm_arch_fixup_msi_route(struct kvm_irq_routing_entry *route,
 {
     return 0;
 }
+
+int kvm_arch_msi_data_to_gsi(uint32_t data)
+{
+    return (data - 32) & 0xffff;
+}
diff --git a/target-i386/kvm.c b/target-i386/kvm.c
index 41d09e5..7c648e7 100644
--- a/target-i386/kvm.c
+++ b/target-i386/kvm.c
@@ -2764,3 +2764,8 @@ int kvm_arch_fixup_msi_route(struct kvm_irq_routing_entry *route,
 {
     return 0;
 }
+
+int kvm_arch_msi_data_to_gsi(uint32_t data)
+{
+    return data & 0xffff;
+}
diff --git a/target-mips/kvm.c b/target-mips/kvm.c
index 4d1f7ea..e53e059 100644
--- a/target-mips/kvm.c
+++ b/target-mips/kvm.c
@@ -694,3 +694,8 @@ int kvm_arch_fixup_msi_route(struct kvm_irq_routing_entry *route,
 {
     return 0;
 }
+
+int kvm_arch_msi_data_to_gsi(uint32_t data)
+{
+    return data & 0xffff;
+}
diff --git a/target-ppc/kvm.c b/target-ppc/kvm.c
index 12328a4..53569f6 100644
--- a/target-ppc/kvm.c
+++ b/target-ppc/kvm.c
@@ -2408,3 +2408,8 @@ int kvm_arch_fixup_msi_route(struct kvm_irq_routing_entry *route,
 {
     return 0;
 }
+
+int kvm_arch_msi_data_to_gsi(uint32_t data)
+{
+    return data & 0xffff;
+}
diff --git a/target-s390x/kvm.c b/target-s390x/kvm.c
index b48c643..6509aff 100644
--- a/target-s390x/kvm.c
+++ b/target-s390x/kvm.c
@@ -1940,3 +1940,8 @@ int kvm_arch_fixup_msi_route(struct kvm_irq_routing_entry *route,
     route->u.adapter.adapter_id = pbdev->routes.adapter.adapter_id;
     return 0;
 }
+
+int kvm_arch_msi_data_to_gsi(uint32_t data)
+{
+    return data & 0xffff;
+}
-- 
1.8.3.2
