From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH v2 5/7] KVM: arm/arm64: build a default routing table
Date: Thu,  9 Jul 2015 10:22:15 +0200
Message-ID: <1436430137-24205-6-git-send-email-eric.auger@linaro.org>
References: <1436430137-24205-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BC89A582BA
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Jul 2015 04:11:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WUhaUmcWk-YF for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Jul 2015 04:11:19 -0400 (EDT)
Received: from mail-wg0-f53.google.com (mail-wg0-f53.google.com [74.125.82.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CA08D582B6
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Jul 2015 04:11:18 -0400 (EDT)
Received: by wgjx7 with SMTP id x7so216374809wgj.2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 09 Jul 2015 01:22:53 -0700 (PDT)
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

Implement a default routing table made of flat irqchip routing
entries (gsi = irqchip.pin) covering the VGIC SPI indexes.
This routing table is overwritten by the first user-space call
to KVM_SET_GSI_ROUTING ioctl.

Signed-off-by: Eric Auger <eric.auger@linaro.org>

---

PATCH: creation
---
 virt/kvm/arm/vgic.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index 6c6c25e..63be67e 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -1781,6 +1781,8 @@ int vgic_init(struct kvm *kvm)
 	ret |= vgic_init_bitmap(&dist->irq_cfg, nr_cpus, nr_irqs);
 	ret |= vgic_init_bytemap(&dist->irq_priority, nr_cpus, nr_irqs);
 
+	ret |= kvm_setup_default_irq_routing(kvm);
+
 	if (ret)
 		goto out;
 
@@ -2258,6 +2260,25 @@ out:
 	return r;
 }
 
+int kvm_setup_default_irq_routing(struct kvm *kvm)
+{
+	struct kvm_irq_routing_entry *entries;
+	u32 nr = kvm->arch.vgic.nr_irqs - VGIC_NR_PRIVATE_IRQS;
+	int i, ret;
+
+	entries = kcalloc(nr, sizeof(struct kvm_kernel_irq_routing_entry),
+			  GFP_KERNEL);
+	for (i = 0; i < nr; i++) {
+		entries[i].gsi = i;
+		entries[i].type = KVM_IRQ_ROUTING_IRQCHIP;
+		entries[i].u.irqchip.irqchip = 0;
+		entries[i].u.irqchip.pin = i;
+	}
+	ret = kvm_set_irq_routing(kvm, entries, nr, 0);
+	kfree(entries);
+	return ret;
+}
+
 int kvm_set_msi(struct kvm_kernel_irq_routing_entry *e,
 		struct kvm *kvm, int irq_source_id,
 		int level, bool line_status)
-- 
1.9.1
