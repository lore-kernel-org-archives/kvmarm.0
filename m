From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH 7/7] KVM: arm: implement kvm_set_msi by gsi direct mapping
Date: Mon, 29 Jun 2015 17:37:17 +0200
Message-ID: <1435592237-17924-8-git-send-email-eric.auger@linaro.org>
References: <1435592237-17924-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 17F2756A17
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Jun 2015 11:26:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aYehNkEMs0vG for <kvmarm@lists.cs.columbia.edu>;
 Mon, 29 Jun 2015 11:26:50 -0400 (EDT)
Received: from mail-wg0-f45.google.com (mail-wg0-f45.google.com [74.125.82.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E48AD569EA
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Jun 2015 11:26:48 -0400 (EDT)
Received: by wguu7 with SMTP id u7so144740545wgu.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Jun 2015 08:37:58 -0700 (PDT)
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

If the ITS modality is not available, let's simply support MSI
injection by transforming the MSI.data into an SPI ID.

This becomes possible to use KVM_SIGNAL_MSI ioctl for arm too.

Signed-off-by: Eric Auger <eric.auger@linaro.org>
---
 arch/arm/kvm/Kconfig | 1 +
 virt/kvm/arm/vgic.c  | 5 +++++
 2 files changed, 6 insertions(+)

diff --git a/arch/arm/kvm/Kconfig b/arch/arm/kvm/Kconfig
index 151e710..0f58baf 100644
--- a/arch/arm/kvm/Kconfig
+++ b/arch/arm/kvm/Kconfig
@@ -31,6 +31,7 @@ config KVM
 	select KVM_VFIO
 	select HAVE_KVM_EVENTFD
 	select HAVE_KVM_IRQFD
+	select HAVE_KVM_MSI
 	select HAVE_KVM_IRQCHIP
 	select HAVE_KVM_IRQ_ROUTING
 	depends on ARM_VIRT_EXT && ARM_LPAE && ARM_ARCH_TIMER
diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index 0b4c48c..b3c10dc 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -2314,6 +2314,11 @@ int kvm_set_msi(struct kvm_kernel_irq_routing_entry *e,
 			return kvm->arch.vgic.vm_ops.inject_msi(kvm, &msi);
 		else
 			return -ENODEV;
+	case KVM_IRQ_ROUTING_MSI:
+		if (kvm->arch.vgic.vm_ops.inject_msi)
+			return -EINVAL;
+		else
+			return kvm_vgic_inject_irq(kvm, 0, e->msi.data, level);
 	default:
 		return -EINVAL;
 	}
-- 
1.9.1
