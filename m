From: Christoffer Dall <cdall@linaro.org>
Subject: [PULL 06/13] KVM: arm/arm64: vgic-v3: Use PREbits to infer the number
 of ICH_APxRn_EL2 registers
Date: Thu, 18 May 2017 11:47:15 +0200
Message-ID: <20170518094722.9926-7-cdall@linaro.org>
References: <20170518094722.9926-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3278840C22
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 May 2017 05:44:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9V84stREREHu for <kvmarm@lists.cs.columbia.edu>;
 Thu, 18 May 2017 05:44:13 -0400 (EDT)
Received: from mail-wm0-f48.google.com (mail-wm0-f48.google.com [74.125.82.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 521E940905
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 May 2017 05:44:12 -0400 (EDT)
Received: by mail-wm0-f48.google.com with SMTP id d127so45808984wmf.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 May 2017 02:47:43 -0700 (PDT)
In-Reply-To: <20170518094722.9926-1-cdall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <cdall@linaro.org>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Marc Zyngier <marc.zyngier@arm.com>

The GICv3 documentation is extremely confusing, as it talks about
the number of priorities represented by the ICH_APxRn_EL2 registers,
while it should really talk about the number of preemption levels.

This leads to a bug where we may access undefined ICH_APxRn_EL2
registers, since PREbits is allowed to be smaller than PRIbits.
Thankfully, nobody seem to have taken this path so far...

The fix is to use ICH_VTR_EL2.PREbits instead.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Reviewed-by: Christoffer Dall <cdall@linaro.org>
Signed-off-by: Christoffer Dall <cdall@linaro.org>
---
 virt/kvm/arm/hyp/vgic-v3-sr.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/virt/kvm/arm/hyp/vgic-v3-sr.c b/virt/kvm/arm/hyp/vgic-v3-sr.c
index bce6037..32c3295 100644
--- a/virt/kvm/arm/hyp/vgic-v3-sr.c
+++ b/virt/kvm/arm/hyp/vgic-v3-sr.c
@@ -22,7 +22,7 @@
 #include <asm/kvm_hyp.h>
 
 #define vtr_to_max_lr_idx(v)		((v) & 0xf)
-#define vtr_to_nr_pri_bits(v)		(((u32)(v) >> 29) + 1)
+#define vtr_to_nr_pre_bits(v)		(((u32)(v) >> 26) + 1)
 
 static u64 __hyp_text __gic_v3_get_lr(unsigned int lr)
 {
@@ -135,13 +135,13 @@ void __hyp_text __vgic_v3_save_state(struct kvm_vcpu *vcpu)
 
 	if (used_lrs) {
 		int i;
-		u32 nr_pri_bits;
+		u32 nr_pre_bits;
 
 		cpu_if->vgic_elrsr = read_gicreg(ICH_ELSR_EL2);
 
 		write_gicreg(0, ICH_HCR_EL2);
 		val = read_gicreg(ICH_VTR_EL2);
-		nr_pri_bits = vtr_to_nr_pri_bits(val);
+		nr_pre_bits = vtr_to_nr_pre_bits(val);
 
 		for (i = 0; i < used_lrs; i++) {
 			if (cpu_if->vgic_elrsr & (1 << i))
@@ -152,7 +152,7 @@ void __hyp_text __vgic_v3_save_state(struct kvm_vcpu *vcpu)
 			__gic_v3_set_lr(0, i);
 		}
 
-		switch (nr_pri_bits) {
+		switch (nr_pre_bits) {
 		case 7:
 			cpu_if->vgic_ap0r[3] = read_gicreg(ICH_AP0R3_EL2);
 			cpu_if->vgic_ap0r[2] = read_gicreg(ICH_AP0R2_EL2);
@@ -162,7 +162,7 @@ void __hyp_text __vgic_v3_save_state(struct kvm_vcpu *vcpu)
 			cpu_if->vgic_ap0r[0] = read_gicreg(ICH_AP0R0_EL2);
 		}
 
-		switch (nr_pri_bits) {
+		switch (nr_pre_bits) {
 		case 7:
 			cpu_if->vgic_ap1r[3] = read_gicreg(ICH_AP1R3_EL2);
 			cpu_if->vgic_ap1r[2] = read_gicreg(ICH_AP1R2_EL2);
@@ -198,7 +198,7 @@ void __hyp_text __vgic_v3_restore_state(struct kvm_vcpu *vcpu)
 	struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
 	u64 used_lrs = vcpu->arch.vgic_cpu.used_lrs;
 	u64 val;
-	u32 nr_pri_bits;
+	u32 nr_pre_bits;
 	int i;
 
 	/*
@@ -217,12 +217,12 @@ void __hyp_text __vgic_v3_restore_state(struct kvm_vcpu *vcpu)
 	}
 
 	val = read_gicreg(ICH_VTR_EL2);
-	nr_pri_bits = vtr_to_nr_pri_bits(val);
+	nr_pre_bits = vtr_to_nr_pre_bits(val);
 
 	if (used_lrs) {
 		write_gicreg(cpu_if->vgic_hcr, ICH_HCR_EL2);
 
-		switch (nr_pri_bits) {
+		switch (nr_pre_bits) {
 		case 7:
 			write_gicreg(cpu_if->vgic_ap0r[3], ICH_AP0R3_EL2);
 			write_gicreg(cpu_if->vgic_ap0r[2], ICH_AP0R2_EL2);
@@ -232,7 +232,7 @@ void __hyp_text __vgic_v3_restore_state(struct kvm_vcpu *vcpu)
 			write_gicreg(cpu_if->vgic_ap0r[0], ICH_AP0R0_EL2);
 		}
 
-		switch (nr_pri_bits) {
+		switch (nr_pre_bits) {
 		case 7:
 			write_gicreg(cpu_if->vgic_ap1r[3], ICH_AP1R3_EL2);
 			write_gicreg(cpu_if->vgic_ap1r[2], ICH_AP1R2_EL2);
-- 
2.9.0
