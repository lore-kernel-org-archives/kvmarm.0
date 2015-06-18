From: Eric Auger <eric.auger@linaro.org>
Subject: [RFC 5/6] KVM: arm/arm64: enable MSI routing
Date: Thu, 18 Jun 2015 19:40:57 +0200
Message-ID: <1434649258-27065-6-git-send-email-eric.auger@linaro.org>
References: <1434649258-27065-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 46C2356018
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Jun 2015 13:30:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JOIkryVBEIxV for <kvmarm@lists.cs.columbia.edu>;
 Thu, 18 Jun 2015 13:30:47 -0400 (EDT)
Received: from mail-wi0-f172.google.com (mail-wi0-f172.google.com
 [209.85.212.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6E2065600D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Jun 2015 13:30:47 -0400 (EDT)
Received: by wicnd19 with SMTP id nd19so29825034wic.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Jun 2015 10:41:28 -0700 (PDT)
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

Up to now, only irqchip routing entries could be set. This patch
adds the capability to insert MSI routing entries, extended or
standard ones. Although standard MSI entries can be set, their
injection still is not supported. For ARM64, let's also increase
KVM_MAX_IRQ_ROUTES to 4096.

Signed-off-by: Eric Auger <eric.auger@linaro.org>
---
 include/linux/kvm_host.h |  2 ++
 virt/kvm/arm/vgic.c      | 13 +++++++++++++
 2 files changed, 15 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index e1c1c0d..6cacf11 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -927,6 +927,8 @@ static inline int mmu_notifier_retry(struct kvm *kvm, unsigned long mmu_seq)
 
 #ifdef CONFIG_S390
 #define KVM_MAX_IRQ_ROUTES 4096 //FIXME: we can have more than that...
+#elif defined(CONFIG_ARM64)
+#define KVM_MAX_IRQ_ROUTES 4096 //FIXME: we can have more than that too...
 #else
 #define KVM_MAX_IRQ_ROUTES 1024
 #endif
diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index 212a5ff..16d232f 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -2256,6 +2256,19 @@ int kvm_set_routing_entry(struct kvm_kernel_irq_routing_entry *e,
 		    (e->irqchip.irqchip >= KVM_NR_IRQCHIPS))
 			goto out;
 		break;
+	case KVM_IRQ_ROUTING_MSI:
+		e->set = kvm_set_msi;
+		e->msi.address_lo = ue->u.msi.address_lo;
+		e->msi.address_hi = ue->u.msi.address_hi;
+		e->msi.data = ue->u.msi.data;
+		break;
+	case KVM_IRQ_ROUTING_EXTENDED_MSI:
+		e->set = kvm_set_msi;
+		e->ext_msi.address_lo = ue->u.ext_msi.address_lo;
+		e->ext_msi.address_hi = ue->u.ext_msi.address_hi;
+		e->ext_msi.data = ue->u.ext_msi.data;
+		e->ext_msi.devid = ue->u.ext_msi.devid;
+		break;
 	default:
 		goto out;
 	}
-- 
1.9.1
