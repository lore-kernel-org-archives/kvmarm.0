From: Jintack Lim <jintack@cs.columbia.edu>
Subject: [RFC 51/55] KVM: arm64: Expose physical address of vcpu interface
Date: Mon,  9 Jan 2017 01:24:47 -0500
Message-ID: <1483943091-1364-52-git-send-email-jintack@cs.columbia.edu>
References: <1483943091-1364-1-git-send-email-jintack@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9D5BE4096A
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:24:59 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kdr1e1aB48Q4 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Jan 2017 01:24:58 -0500 (EST)
Received: from outprodmail01.cc.columbia.edu (outprodmail01.cc.columbia.edu
 [128.59.72.39])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D688940782
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:24:54 -0500 (EST)
Received: from hazelnut (hazelnut.cc.columbia.edu [128.59.213.250])
 by outprodmail01.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v096Q5sr017972
 for <kvmarm@lists.cs.columbia.edu>; Mon, 9 Jan 2017 01:26:36 -0500
Received: from hazelnut (localhost.localdomain [127.0.0.1])
 by hazelnut (Postfix) with ESMTP id 65A8B82
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:26:36 -0500 (EST)
Received: from sendprodmail01.cc.columbia.edu (sendprodmail01.cc.columbia.edu
 [128.59.72.13]) by hazelnut (Postfix) with ESMTP id 40AD987
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:26:36 -0500 (EST)
Received: from mail-qt0-f199.google.com (mail-qt0-f199.google.com
 [209.85.216.199])
 by sendprodmail01.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v096QZx0041818
 (version=TLSv1/SSLv3 cipher=AES128-GCM-SHA256 bits=128 verify=NOT)
 for <kvmarm@lists.cs.columbia.edu>; Mon, 9 Jan 2017 01:26:36 -0500
Received: by mail-qt0-f199.google.com with SMTP id t56so77869841qte.3
 for <kvmarm@lists.cs.columbia.edu>; Sun, 08 Jan 2017 22:26:36 -0800 (PST)
In-Reply-To: <1483943091-1364-1-git-send-email-jintack@cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: christoffer.dall@linaro.org, marc.zyngier@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, vladimir.murzin@arm.com, suzuki.poulose@arm.com, mark.rutland@arm.com, james.morse@arm.com, lorenzo.pieralisi@arm.com, kevin.brodsky@arm.com, wcohen@redhat.com, shankerd@codeaurora.org, geoff@infradead.org, andre.przywara@arm.com, eric.auger@redhat.com, anna-maria@linutronix.de, shihwei@cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Expose physical address of vgic virtual cpu interface.

Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
---
 include/kvm/arm_vgic.h      | 1 +
 virt/kvm/arm/vgic/vgic-v2.c | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 5bda20c..05c7811 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -331,6 +331,7 @@ static inline void vgic_handle_nested_maint_irq(struct kvm_vcpu *vcpu) { }
 #define vgic_valid_spi(k, i)	(((i) >= VGIC_NR_PRIVATE_IRQS) && \
 			((i) < (k)->arch.vgic.nr_spis + VGIC_NR_PRIVATE_IRQS))
 
+phys_addr_t vgic_vcpu_base(void);
 bool kvm_vcpu_has_pending_irqs(struct kvm_vcpu *vcpu);
 void kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu);
 void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu);
diff --git a/virt/kvm/arm/vgic/vgic-v2.c b/virt/kvm/arm/vgic/vgic-v2.c
index b8b73fd..5d85041 100644
--- a/virt/kvm/arm/vgic/vgic-v2.c
+++ b/virt/kvm/arm/vgic/vgic-v2.c
@@ -386,3 +386,9 @@ int vgic_v2_probe(const struct gic_kvm_info *info)
 
 	return ret;
 }
+
+/* Return physical address of vgic virtual cpu interface */
+phys_addr_t vgic_vcpu_base(void)
+{
+	return kvm_vgic_global_state.vcpu_base;
+}
-- 
1.9.1
