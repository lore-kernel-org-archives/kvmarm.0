From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH v2 7/7] KVM: arm: implement kvm_set_msi by gsi direct mapping
Date: Thu,  9 Jul 2015 10:22:17 +0200
Message-ID: <1436430137-24205-8-git-send-email-eric.auger@linaro.org>
References: <1436430137-24205-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AC9375828A
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Jul 2015 04:11:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id plev+Gj28KtH for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Jul 2015 04:11:23 -0400 (EDT)
Received: from mail-wg0-f50.google.com (mail-wg0-f50.google.com [74.125.82.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DA201582CC
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Jul 2015 04:11:22 -0400 (EDT)
Received: by wgjx7 with SMTP id x7so216376731wgj.2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 09 Jul 2015 01:22:57 -0700 (PDT)
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

If the ITS modality is not available, let's simply support MSI
injection by transforming the MSI.data into an SPI ID.

This becomes possible to use KVM_SIGNAL_MSI ioctl for arm too.

Signed-off-by: Eric Auger <eric.auger@linaro.org>

---

v1 -> v2:
- introduce vgic_v2m_inject_msi in vgic-v2-emul.c following Andre's
  advice
---
 arch/arm/kvm/Kconfig        |  1 +
 virt/kvm/arm/vgic-v2-emul.c | 12 ++++++++++++
 2 files changed, 13 insertions(+)

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
diff --git a/virt/kvm/arm/vgic-v2-emul.c b/virt/kvm/arm/vgic-v2-emul.c
index 1390797..43013cc 100644
--- a/virt/kvm/arm/vgic-v2-emul.c
+++ b/virt/kvm/arm/vgic-v2-emul.c
@@ -478,6 +478,17 @@ static bool vgic_v2_queue_sgi(struct kvm_vcpu *vcpu, int irq)
 }
 
 /**
+ * Emulates GICv2M MSI injection by injecting the SPI ID matching
+ * the msi data
+ * @kvm: pointer to the kvm struct
+ * @msi: the msi struct handle
+ */
+static int vgic_v2m_inject_msi(struct kvm *kvm, struct kvm_msi *msi)
+{
+	return kvm_vgic_inject_irq(kvm, 0, msi->data, 1);
+}
+
+/**
  * kvm_vgic_map_resources - Configure global VGIC state before running any VCPUs
  * @kvm: pointer to the kvm struct
  *
@@ -566,6 +577,7 @@ void vgic_v2_init_emulation(struct kvm *kvm)
 	dist->vm_ops.add_sgi_source = vgic_v2_add_sgi_source;
 	dist->vm_ops.init_model = vgic_v2_init_model;
 	dist->vm_ops.map_resources = vgic_v2_map_resources;
+	dist->vm_ops.inject_msi = vgic_v2m_inject_msi;
 
 	kvm->arch.max_vcpus = VGIC_V2_MAX_CPUS;
 }
-- 
1.9.1
