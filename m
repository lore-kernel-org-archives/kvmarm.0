From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH v3 5/7] KVM: arm/arm64: build a default routing table
Date: Mon,  3 Aug 2015 17:31:27 +0200
Message-ID: <1438615889-10892-6-git-send-email-eric.auger@linaro.org>
References: <1438615889-10892-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 10A7D59E9E
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Aug 2015 11:19:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qcc48cC4EHVu for <kvmarm@lists.cs.columbia.edu>;
 Mon,  3 Aug 2015 11:19:45 -0400 (EDT)
Received: from mail-wi0-f178.google.com (mail-wi0-f178.google.com
 [209.85.212.178])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 719C859E94
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Aug 2015 11:19:45 -0400 (EDT)
Received: by wicmv11 with SMTP id mv11so140549186wic.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 03 Aug 2015 08:32:27 -0700 (PDT)
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
index 8114235..1b092e3 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -1785,6 +1785,8 @@ int vgic_init(struct kvm *kvm)
 	ret |= vgic_init_bitmap(&dist->irq_cfg, nr_cpus, nr_irqs);
 	ret |= vgic_init_bytemap(&dist->irq_priority, nr_cpus, nr_irqs);
 
+	ret |= kvm_setup_default_irq_routing(kvm);
+
 	if (ret)
 		goto out;
 
@@ -2266,6 +2268,25 @@ out:
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
 /**
  * kvm_set_msi: inject the MSI corresponding to the
  * MSI routing entry
-- 
1.9.1
