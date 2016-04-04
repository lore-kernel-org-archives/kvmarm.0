From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH v4 5/7] KVM: arm/arm64: build a default routing table
Date: Mon,  4 Apr 2016 10:47:35 +0200
Message-ID: <1459759657-7402-6-git-send-email-eric.auger@linaro.org>
References: <1459759657-7402-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3E6FC40F90
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Apr 2016 04:47:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1mQnoMIxRLrm for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Apr 2016 04:47:57 -0400 (EDT)
Received: from mail-lb0-f179.google.com (mail-lb0-f179.google.com
 [209.85.217.179])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CEFD740B40
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Apr 2016 04:47:56 -0400 (EDT)
Received: by mail-lb0-f179.google.com with SMTP id qe11so149850802lbc.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 04 Apr 2016 01:49:12 -0700 (PDT)
In-Reply-To: <1459759657-7402-1-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@st.com, eric.auger@linaro.org, christoffer.dall@linaro.org, marc.zyngier@arm.com, andre.przywara@arm.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: pbonzini@redhat.com, Manish.Jaggi@caviumnetworks.com, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

Implement a default routing table made of flat irqchip routing
entries (gsi = irqchip.pin) covering the VGIC SPI indexes.
This routing table is overwritten by the first user-space call
to KVM_SET_GSI_ROUTING ioctl.

Signed-off-by: Eric Auger <eric.auger@linaro.org>

---
---
 virt/kvm/arm/vgic/vgic_init.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/virt/kvm/arm/vgic/vgic_init.c b/virt/kvm/arm/vgic/vgic_init.c
index e4459e3..041443b 100644
--- a/virt/kvm/arm/vgic/vgic_init.c
+++ b/virt/kvm/arm/vgic/vgic_init.c
@@ -261,6 +261,10 @@ int vgic_init(struct kvm *kvm)
 	kvm_for_each_vcpu(i, vcpu, kvm)
 		kvm_vgic_vcpu_init(vcpu);
 
+	ret = kvm_setup_default_irq_routing(kvm);
+	if (ret)
+		goto out;
+
 	dist->initialized = true;
 out:
 	return ret;
@@ -454,3 +458,23 @@ out_free_irq:
 			kvm_get_running_vcpus());
 	return ret;
 }
+
+int kvm_setup_default_irq_routing(struct kvm *kvm)
+{
+	struct kvm_irq_routing_entry *entries;
+	struct vgic_dist *dist = &kvm->arch.vgic;
+	u32 nr = dist->nr_spis;
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
-- 
1.9.1
