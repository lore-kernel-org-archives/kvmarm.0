From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH v12 8/9] linux-headers: update arm/arm64 KVM headers for irqfd
Date: Thu, 19 Mar 2015 17:16:40 +0000
Message-ID: <1426785402-2091-9-git-send-email-eric.auger@linaro.org>
References: <1426785402-2091-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8CD1A49333
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Mar 2015 13:10:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nzK19xndW0tm for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 Mar 2015 13:10:14 -0400 (EDT)
Received: from mail-wg0-f50.google.com (mail-wg0-f50.google.com [74.125.82.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A56424933B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Mar 2015 13:10:14 -0400 (EDT)
Received: by wgra20 with SMTP id a20so68313813wgr.3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Mar 2015 10:16:56 -0700 (PDT)
In-Reply-To: <1426785402-2091-1-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@st.com, eric.auger@linaro.org, qemu-devel@nongnu.org, alex.williamson@redhat.com, peter.maydell@linaro.org, agraf@suse.de
Cc: patches@linaro.org, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Update according to arm/arm64 kvm.h headers found in
ssh://git.linaro.org/people/eric.auger/linux.git
branch irqfd_v9_stdalone_official_release

Signed-off-by: Eric Auger <eric.auger@linaro.org>
---
 linux-headers/asm-arm/kvm.h   | 3 +++
 linux-headers/asm-arm64/kvm.h | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/linux-headers/asm-arm/kvm.h b/linux-headers/asm-arm/kvm.h
index 0db25bc..2499867 100644
--- a/linux-headers/asm-arm/kvm.h
+++ b/linux-headers/asm-arm/kvm.h
@@ -198,6 +198,9 @@ struct kvm_arch_memory_slot {
 /* Highest supported SPI, from VGIC_NR_IRQS */
 #define KVM_ARM_IRQ_GIC_MAX		127
 
+/* One single KVM irqchip, ie. the VGIC */
+#define KVM_NR_IRQCHIPS          1
+
 /* PSCI interface */
 #define KVM_PSCI_FN_BASE		0x95c1ba5e
 #define KVM_PSCI_FN(n)			(KVM_PSCI_FN_BASE + (n))
diff --git a/linux-headers/asm-arm64/kvm.h b/linux-headers/asm-arm64/kvm.h
index 3ef77a4..c154c0b 100644
--- a/linux-headers/asm-arm64/kvm.h
+++ b/linux-headers/asm-arm64/kvm.h
@@ -191,6 +191,9 @@ struct kvm_arch_memory_slot {
 /* Highest supported SPI, from VGIC_NR_IRQS */
 #define KVM_ARM_IRQ_GIC_MAX		127
 
+/* One single KVM irqchip, ie. the VGIC */
+#define KVM_NR_IRQCHIPS          1
+
 /* PSCI interface */
 #define KVM_PSCI_FN_BASE		0x95c1ba5e
 #define KVM_PSCI_FN(n)			(KVM_PSCI_FN_BASE + (n))
-- 
1.8.3.2
