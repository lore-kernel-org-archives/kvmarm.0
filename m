From: Jintack Lim <jintack.lim@linaro.org>
Subject: [RFC PATCH v2 29/31] KVM: arm64: Respect the virtual HCR_EL2.AT and
 NV setting
Date: Mon,  2 Oct 2017 22:11:11 -0500
Message-ID: <1507000273-3735-27-git-send-email-jintack.lim@linaro.org>
References: <1507000273-3735-1-git-send-email-jintack.lim@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6C2D249D26
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Oct 2017 23:11:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QOhFlUebIvAs for <kvmarm@lists.cs.columbia.edu>;
 Mon,  2 Oct 2017 23:11:53 -0400 (EDT)
Received: from mail-it0-f43.google.com (mail-it0-f43.google.com
 [209.85.214.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EEDBC49D4F
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Oct 2017 23:11:51 -0400 (EDT)
Received: by mail-it0-f43.google.com with SMTP id v62so7439788itd.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 02 Oct 2017 20:12:11 -0700 (PDT)
In-Reply-To: <1507000273-3735-1-git-send-email-jintack.lim@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: christoffer.dall@linaro.org, marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, catalin.marinas@arm.com, will.deacon@arm.com, linux@armlinux.org.uk, linux-kernel@vger.kernel.org, pbonzini@redhat.com, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Forward system instruction traps to the virtual EL2 if a corresponding
bit in the virtual HCR_EL2 is set.

Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
---

Notes:
    v1-->v2:
    This is a new commit.  We can rework existing forward_nv_traps() and
    forward_nv1_traps() defined in rfc-v2 cpu patches to reuse forward_traps()
    function

 arch/arm64/include/asm/kvm_arm.h |  1 +
 arch/arm64/kvm/sys_regs.c        | 69 +++++++++++++++++++++++++---------------
 2 files changed, 44 insertions(+), 26 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index e160895..925edfd 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -23,6 +23,7 @@
 #include <asm/types.h>
 
 /* Hyp Configuration Register (HCR) bits */
+#define HCR_AT		(UL(1) << 44)
 #define HCR_NV1		(UL(1) << 43)
 #define HCR_NV		(UL(1) << 42)
 #define HCR_E2H		(UL(1) << 34)
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index eb91f00..89e73af 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -966,6 +966,23 @@ static bool access_cntp_cval(struct kvm_vcpu *vcpu,
 	return true;
 }
 
+static bool forward_traps(struct kvm_vcpu *vcpu, u64 control_bit)
+{
+	bool control_bit_set;
+
+	control_bit_set = vcpu_sys_reg(vcpu, HCR_EL2) & control_bit;
+	if (!vcpu_mode_el2(vcpu) && control_bit_set) {
+		kvm_inject_nested_sync(vcpu, kvm_vcpu_get_hsr(vcpu));
+		return true;
+	}
+	return false;
+}
+
+static bool forward_at_traps(struct kvm_vcpu *vcpu)
+{
+	return forward_traps(vcpu, HCR_AT);
+}
+
 /* This function is to support the recursive nested virtualization */
 bool forward_nv_traps(struct kvm_vcpu *vcpu)
 {
@@ -1948,32 +1965,32 @@ static bool handle_ipas2e1is(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 #define SYS_INSN_TO_DESC(insn, access_fn, forward_fn)	\
 	{ SYS_DESC((insn)), (access_fn), NULL, 0, 0, NULL, NULL, (forward_fn) }
 static struct sys_reg_desc sys_insn_descs[] = {
-	SYS_INSN_TO_DESC(AT_S1E1R, handle_s1e01, NULL),
-	SYS_INSN_TO_DESC(AT_S1E1W, handle_s1e01, NULL),
-	SYS_INSN_TO_DESC(AT_S1E0R, handle_s1e01, NULL),
-	SYS_INSN_TO_DESC(AT_S1E0W, handle_s1e01, NULL),
-	SYS_INSN_TO_DESC(AT_S1E1RP, handle_s1e01, NULL),
-	SYS_INSN_TO_DESC(AT_S1E1WP, handle_s1e01, NULL),
-	SYS_INSN_TO_DESC(AT_S1E2R, handle_s1e2, NULL),
-	SYS_INSN_TO_DESC(AT_S1E2W, handle_s1e2, NULL),
-	SYS_INSN_TO_DESC(AT_S12E1R, handle_s12r, NULL),
-	SYS_INSN_TO_DESC(AT_S12E1W, handle_s12w, NULL),
-	SYS_INSN_TO_DESC(AT_S12E0R, handle_s12r, NULL),
-	SYS_INSN_TO_DESC(AT_S12E0W, handle_s12w, NULL),
-	SYS_INSN_TO_DESC(TLBI_IPAS2E1IS, handle_ipas2e1is, NULL),
-	SYS_INSN_TO_DESC(TLBI_IPAS2LE1IS, handle_ipas2e1is, NULL),
-	SYS_INSN_TO_DESC(TLBI_ALLE2IS, handle_alle2is, NULL),
-	SYS_INSN_TO_DESC(TLBI_VAE2IS, handle_vae2, NULL),
-	SYS_INSN_TO_DESC(TLBI_ALLE1IS, handle_alle1is, NULL),
-	SYS_INSN_TO_DESC(TLBI_VALE2IS, handle_vae2, NULL),
-	SYS_INSN_TO_DESC(TLBI_VMALLS12E1IS, handle_vmalls12e1is, NULL),
-	SYS_INSN_TO_DESC(TLBI_IPAS2E1, handle_ipas2e1is, NULL),
-	SYS_INSN_TO_DESC(TLBI_IPAS2LE1, handle_ipas2e1is, NULL),
-	SYS_INSN_TO_DESC(TLBI_ALLE2, handle_alle2, NULL),
-	SYS_INSN_TO_DESC(TLBI_VAE2, handle_vae2, NULL),
-	SYS_INSN_TO_DESC(TLBI_ALLE1, handle_alle1is, NULL),
-	SYS_INSN_TO_DESC(TLBI_VALE2, handle_vae2, NULL),
-	SYS_INSN_TO_DESC(TLBI_VMALLS12E1, handle_vmalls12e1is, NULL),
+	SYS_INSN_TO_DESC(AT_S1E1R, handle_s1e01, forward_at_traps),
+	SYS_INSN_TO_DESC(AT_S1E1W, handle_s1e01, forward_at_traps),
+	SYS_INSN_TO_DESC(AT_S1E0R, handle_s1e01, forward_at_traps),
+	SYS_INSN_TO_DESC(AT_S1E0W, handle_s1e01, forward_at_traps),
+	SYS_INSN_TO_DESC(AT_S1E1RP, handle_s1e01, forward_at_traps),
+	SYS_INSN_TO_DESC(AT_S1E1WP, handle_s1e01, forward_at_traps),
+	SYS_INSN_TO_DESC(AT_S1E2R, handle_s1e2, forward_nv_traps),
+	SYS_INSN_TO_DESC(AT_S1E2W, handle_s1e2, forward_nv_traps),
+	SYS_INSN_TO_DESC(AT_S12E1R, handle_s12r, forward_nv_traps),
+	SYS_INSN_TO_DESC(AT_S12E1W, handle_s12w, forward_nv_traps),
+	SYS_INSN_TO_DESC(AT_S12E0R, handle_s12r, forward_nv_traps),
+	SYS_INSN_TO_DESC(AT_S12E0W, handle_s12w, forward_nv_traps),
+	SYS_INSN_TO_DESC(TLBI_IPAS2E1IS, handle_ipas2e1is, forward_nv_traps),
+	SYS_INSN_TO_DESC(TLBI_IPAS2LE1IS, handle_ipas2e1is, forward_nv_traps),
+	SYS_INSN_TO_DESC(TLBI_ALLE2IS, handle_alle2is, forward_nv_traps),
+	SYS_INSN_TO_DESC(TLBI_VAE2IS, handle_vae2, forward_nv_traps),
+	SYS_INSN_TO_DESC(TLBI_ALLE1IS, handle_alle1is, forward_nv_traps),
+	SYS_INSN_TO_DESC(TLBI_VALE2IS, handle_vae2, forward_nv_traps),
+	SYS_INSN_TO_DESC(TLBI_VMALLS12E1IS, handle_vmalls12e1is, forward_nv_traps),
+	SYS_INSN_TO_DESC(TLBI_IPAS2E1, handle_ipas2e1is, forward_nv_traps),
+	SYS_INSN_TO_DESC(TLBI_IPAS2LE1, handle_ipas2e1is, forward_nv_traps),
+	SYS_INSN_TO_DESC(TLBI_ALLE2, handle_alle2, forward_nv_traps),
+	SYS_INSN_TO_DESC(TLBI_VAE2, handle_vae2, forward_nv_traps),
+	SYS_INSN_TO_DESC(TLBI_ALLE1, handle_alle1is, forward_nv_traps),
+	SYS_INSN_TO_DESC(TLBI_VALE2, handle_vae2, forward_nv_traps),
+	SYS_INSN_TO_DESC(TLBI_VMALLS12E1, handle_vmalls12e1is, forward_nv_traps),
 };
 
 #define reg_to_match_value(x)						\
-- 
1.9.1
