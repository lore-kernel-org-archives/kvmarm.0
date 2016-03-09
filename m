From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 18/95] ARM: KVM: Add populating of fault data structure
Date: Wed,  9 Mar 2016 07:30:12 +0000
Message-ID: <1457508689-19672-19-git-send-email-marc.zyngier@arm.com>
References: <1457508689-19672-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6FA20410B5
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Mar 2016 02:32:37 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FLlhbcQIO9Fg for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Mar 2016 02:32:36 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D909841145
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Mar 2016 02:32:35 -0500 (EST)
In-Reply-To: <1457508689-19672-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Gleb Natapov <gleb@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Shannon Zhao <shannon.zhao@linaro.org>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On guest exit, we must take care of populating our fault data
structure so that the host code can handle it. This includes
resolving the IPA for permission faults, which can result in
restarting the guest.

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/kvm/hyp/hyp.h    |  4 ++++
 arch/arm/kvm/hyp/switch.c | 54 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 58 insertions(+)

diff --git a/arch/arm/kvm/hyp/hyp.h b/arch/arm/kvm/hyp/hyp.h
index ef582c9..8b1156b 100644
--- a/arch/arm/kvm/hyp/hyp.h
+++ b/arch/arm/kvm/hyp/hyp.h
@@ -76,10 +76,14 @@
 #define IFSR		__ACCESS_CP15(c5, 0, c0, 1)
 #define ADFSR		__ACCESS_CP15(c5, 0, c1, 0)
 #define AIFSR		__ACCESS_CP15(c5, 0, c1, 1)
+#define HSR		__ACCESS_CP15(c5, 4, c2, 0)
 #define DFAR		__ACCESS_CP15(c6, 0, c0, 0)
 #define IFAR		__ACCESS_CP15(c6, 0, c0, 2)
 #define HDFAR		__ACCESS_CP15(c6, 4, c0, 0)
+#define HIFAR		__ACCESS_CP15(c6, 4, c0, 2)
+#define HPFAR		__ACCESS_CP15(c6, 4, c0, 4)
 #define ICIALLUIS	__ACCESS_CP15(c7, 0, c1, 0)
+#define ATS1CPR		__ACCESS_CP15(c7, 0, c8, 0)
 #define TLBIALLIS	__ACCESS_CP15(c8, 0, c3, 0)
 #define TLBIALLNSNHIS	__ACCESS_CP15(c8, 4, c3, 4)
 #define PRRR		__ACCESS_CP15(c10, 0, c2, 0)
diff --git a/arch/arm/kvm/hyp/switch.c b/arch/arm/kvm/hyp/switch.c
index a1f3c1c..0dd0ba3 100644
--- a/arch/arm/kvm/hyp/switch.c
+++ b/arch/arm/kvm/hyp/switch.c
@@ -84,6 +84,56 @@ static void __hyp_text __vgic_restore_state(struct kvm_vcpu *vcpu)
 	__vgic_v2_restore_state(vcpu);
 }
 
+static bool __hyp_text __populate_fault_info(struct kvm_vcpu *vcpu)
+{
+	u32 hsr = read_sysreg(HSR);
+	u8 ec = hsr >> HSR_EC_SHIFT;
+	u32 hpfar, far;
+
+	vcpu->arch.fault.hsr = hsr;
+
+	if (ec == HSR_EC_IABT)
+		far = read_sysreg(HIFAR);
+	else if (ec == HSR_EC_DABT)
+		far = read_sysreg(HDFAR);
+	else
+		return true;
+
+	/*
+	 * B3.13.5 Reporting exceptions taken to the Non-secure PL2 mode:
+	 *
+	 * Abort on the stage 2 translation for a memory access from a
+	 * Non-secure PL1 or PL0 mode:
+	 *
+	 * For any Access flag fault or Translation fault, and also for any
+	 * Permission fault on the stage 2 translation of a memory access
+	 * made as part of a translation table walk for a stage 1 translation,
+	 * the HPFAR holds the IPA that caused the fault. Otherwise, the HPFAR
+	 * is UNKNOWN.
+	 */
+	if (!(hsr & HSR_DABT_S1PTW) && (hsr & HSR_FSC_TYPE) == FSC_PERM) {
+		u64 par, tmp;
+
+		par = read_sysreg(PAR);
+		write_sysreg(far, ATS1CPR);
+		isb();
+
+		tmp = read_sysreg(PAR);
+		write_sysreg(par, PAR);
+
+		if (unlikely(tmp & 1))
+			return false; /* Translation failed, back to guest */
+
+		hpfar = ((tmp >> 12) & ((1UL << 28) - 1)) << 4;
+	} else {
+		hpfar = read_sysreg(HPFAR);
+	}
+
+	vcpu->arch.fault.hxfar = far;
+	vcpu->arch.fault.hpfar = hpfar;
+	return true;
+}
+
 static int __hyp_text __guest_run(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpu_context *host_ctxt;
@@ -111,9 +161,13 @@ static int __hyp_text __guest_run(struct kvm_vcpu *vcpu)
 	__banked_restore_state(guest_ctxt);
 
 	/* Jump in the fire! */
+again:
 	exit_code = __guest_enter(vcpu, host_ctxt);
 	/* And we're baaack! */
 
+	if (exit_code == ARM_EXCEPTION_HVC && !__populate_fault_info(vcpu))
+		goto again;
+
 	fp_enabled = __vfp_enabled();
 
 	__banked_save_state(guest_ctxt);
-- 
2.1.4
