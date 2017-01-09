From: Jintack Lim <jintack@cs.columbia.edu>
Subject: [RFC 29/55] KVM: arm/arm64: Set up the prepared vgic state
Date: Mon,  9 Jan 2017 01:24:25 -0500
Message-ID: <1483943091-1364-30-git-send-email-jintack@cs.columbia.edu>
References: <1483943091-1364-1-git-send-email-jintack@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E827A405DA
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:24:29 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XyS9q8JwEP5h for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Jan 2017 01:24:29 -0500 (EST)
Received: from outprodmail01.cc.columbia.edu (outprodmail01.cc.columbia.edu
 [128.59.72.39])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 46A584086C
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:24:28 -0500 (EST)
Received: from hazelnut (hazelnut.cc.columbia.edu [128.59.213.250])
 by outprodmail01.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v096Q5JW017983
 for <kvmarm@lists.cs.columbia.edu>; Mon, 9 Jan 2017 01:26:09 -0500
Received: from hazelnut (localhost.localdomain [127.0.0.1])
 by hazelnut (Postfix) with ESMTP id D87A481
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:26:09 -0500 (EST)
Received: from sendprodmail02.cc.columbia.edu (sendprodmail02.cc.columbia.edu
 [128.59.72.14]) by hazelnut (Postfix) with ESMTP id BD9F281
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:26:09 -0500 (EST)
Received: from mail-qt0-f198.google.com (mail-qt0-f198.google.com
 [209.85.216.198])
 by sendprodmail02.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v096Q9Z6042455
 (version=TLSv1/SSLv3 cipher=AES128-GCM-SHA256 bits=128 verify=NOT)
 for <kvmarm@lists.cs.columbia.edu>; Mon, 9 Jan 2017 01:26:09 -0500
Received: by mail-qt0-f198.google.com with SMTP id l7so63078048qtd.2
 for <kvmarm@lists.cs.columbia.edu>; Sun, 08 Jan 2017 22:26:09 -0800 (PST)
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

Since vgic state is properly prepared and is pointed by hw_v2_cpu_if,
let's use it to manipulate vgic.

Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
---
 virt/kvm/arm/hyp/vgic-v2-sr.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/virt/kvm/arm/hyp/vgic-v2-sr.c b/virt/kvm/arm/hyp/vgic-v2-sr.c
index c8aeb7b..5d4898f 100644
--- a/virt/kvm/arm/hyp/vgic-v2-sr.c
+++ b/virt/kvm/arm/hyp/vgic-v2-sr.c
@@ -22,10 +22,15 @@
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_hyp.h>
 
+static __hyp_text struct vgic_v2_cpu_if *__hyp_get_cpu_if(struct kvm_vcpu *vcpu)
+{
+	return kern_hyp_va(vcpu->arch.vgic_cpu.hw_v2_cpu_if);
+}
+
 static void __hyp_text save_maint_int_state(struct kvm_vcpu *vcpu,
 					    void __iomem *base)
 {
-	struct vgic_v2_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v2;
+	struct vgic_v2_cpu_if *cpu_if = __hyp_get_cpu_if(vcpu);
 	int nr_lr = (kern_hyp_va(&kvm_vgic_global_state))->nr_lr;
 	u32 eisr0, eisr1;
 	int i;
@@ -67,7 +72,7 @@ static void __hyp_text save_maint_int_state(struct kvm_vcpu *vcpu,
 
 static void __hyp_text save_elrsr(struct kvm_vcpu *vcpu, void __iomem *base)
 {
-	struct vgic_v2_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v2;
+	struct vgic_v2_cpu_if *cpu_if = __hyp_get_cpu_if(vcpu);
 	int nr_lr = (kern_hyp_va(&kvm_vgic_global_state))->nr_lr;
 	u32 elrsr0, elrsr1;
 
@@ -86,7 +91,7 @@ static void __hyp_text save_elrsr(struct kvm_vcpu *vcpu, void __iomem *base)
 
 static void __hyp_text save_lrs(struct kvm_vcpu *vcpu, void __iomem *base)
 {
-	struct vgic_v2_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v2;
+	struct vgic_v2_cpu_if *cpu_if = __hyp_get_cpu_if(vcpu);
 	int nr_lr = (kern_hyp_va(&kvm_vgic_global_state))->nr_lr;
 	int i;
 
@@ -107,7 +112,7 @@ static void __hyp_text save_lrs(struct kvm_vcpu *vcpu, void __iomem *base)
 void __hyp_text __vgic_v2_save_state(struct kvm_vcpu *vcpu)
 {
 	struct kvm *kvm = kern_hyp_va(vcpu->kvm);
-	struct vgic_v2_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v2;
+	struct vgic_v2_cpu_if *cpu_if = __hyp_get_cpu_if(vcpu);
 	struct vgic_dist *vgic = &kvm->arch.vgic;
 	void __iomem *base = kern_hyp_va(vgic->vctrl_base);
 
@@ -138,7 +143,7 @@ void __hyp_text __vgic_v2_save_state(struct kvm_vcpu *vcpu)
 void __hyp_text __vgic_v2_restore_state(struct kvm_vcpu *vcpu)
 {
 	struct kvm *kvm = kern_hyp_va(vcpu->kvm);
-	struct vgic_v2_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v2;
+	struct vgic_v2_cpu_if *cpu_if = __hyp_get_cpu_if(vcpu);
 	struct vgic_dist *vgic = &kvm->arch.vgic;
 	void __iomem *base = kern_hyp_va(vgic->vctrl_base);
 	int nr_lr = (kern_hyp_va(&kvm_vgic_global_state))->nr_lr;
-- 
1.9.1
