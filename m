From: Jintack Lim <jintack.lim@linaro.org>
Subject: [RFC PATCH v2 18/31] KVM: arm64: Enumerate AT and TLBI instructions
 to emulate
Date: Mon,  2 Oct 2017 22:11:00 -0500
Message-ID: <1507000273-3735-16-git-send-email-jintack.lim@linaro.org>
References: <1507000273-3735-1-git-send-email-jintack.lim@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 79CE949D26
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Oct 2017 23:11:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uV9Ch-mJMXic for <kvmarm@lists.cs.columbia.edu>;
 Mon,  2 Oct 2017 23:11:40 -0400 (EDT)
Received: from mail-it0-f44.google.com (mail-it0-f44.google.com
 [209.85.214.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3A22749D34
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Oct 2017 23:11:39 -0400 (EDT)
Received: by mail-it0-f44.google.com with SMTP id y138so10005697itc.5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 02 Oct 2017 20:11:58 -0700 (PDT)
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

List all system instructions to emulate. This patch only introduces the
definitions, emulation handlers will be added in subsequent patches.

Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
---
 arch/arm64/include/asm/sysreg.h | 38 ++++++++++++++++++++++++++++++++++++++
 arch/arm64/kvm/sys_regs.c       | 26 ++++++++++++++++++++++++++
 2 files changed, 64 insertions(+)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index a051d42..53df733 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -367,6 +367,44 @@
 
 #define SYS_SP_EL2			sys_reg(3, 6, 4, 1, 0)
 
+/* AT instructions */
+#define AT_Op0 1
+#define AT_CRn 7
+
+#define AT_S1E1R	sys_insn(AT_Op0, 0, AT_CRn, 8, 0)
+#define AT_S1E1W	sys_insn(AT_Op0, 0, AT_CRn, 8, 1)
+#define AT_S1E0R	sys_insn(AT_Op0, 0, AT_CRn, 8, 2)
+#define AT_S1E0W	sys_insn(AT_Op0, 0, AT_CRn, 8, 3)
+#define AT_S1E1RP	sys_insn(AT_Op0, 0, AT_CRn, 9, 0)
+#define AT_S1E1WP	sys_insn(AT_Op0, 0, AT_CRn, 9, 1)
+#define AT_S1E2R	sys_insn(AT_Op0, 4, AT_CRn, 8, 0)
+#define AT_S1E2W	sys_insn(AT_Op0, 4, AT_CRn, 8, 1)
+#define AT_S12E1R	sys_insn(AT_Op0, 4, AT_CRn, 8, 4)
+#define AT_S12E1W	sys_insn(AT_Op0, 4, AT_CRn, 8, 5)
+#define AT_S12E0R	sys_insn(AT_Op0, 4, AT_CRn, 8, 6)
+#define AT_S12E0W	sys_insn(AT_Op0, 4, AT_CRn, 8, 7)
+
+/* TLBI instructions */
+#define TLBI_Op0	1
+#define TLBI_Op1_EL2	4	/* Accessible from EL2 or higher */
+#define TLBI_CRn	8
+#define tlbi_insn_el2(CRm, Op2)	sys_insn(TLBI_Op0, TLBI_Op1_EL2, TLBI_CRn, (CRm), (Op2))
+
+#define TLBI_IPAS2E1IS	tlbi_insn_el2(0, 1)
+#define TLBI_IPAS2LE1IS	tlbi_insn_el2(0, 5)
+#define TLBI_ALLE2IS	tlbi_insn_el2(3, 0)
+#define TLBI_VAE2IS	tlbi_insn_el2(3, 1)
+#define TLBI_ALLE1IS	tlbi_insn_el2(3, 4)
+#define TLBI_VALE2IS	tlbi_insn_el2(3, 5)
+#define TLBI_VMALLS12E1IS	tlbi_insn_el2(3, 6)
+#define TLBI_IPAS2E1	tlbi_insn_el2(4, 1)
+#define TLBI_IPAS2LE1	tlbi_insn_el2(4, 5)
+#define TLBI_ALLE2	tlbi_insn_el2(7, 0)
+#define TLBI_VAE2	tlbi_insn_el2(7, 1)
+#define TLBI_ALLE1	tlbi_insn_el2(7, 4)
+#define TLBI_VALE2	tlbi_insn_el2(7, 5)
+#define TLBI_VMALLS12E1	tlbi_insn_el2(7, 6)
+
 /* Common SCTLR_ELx flags. */
 #define SCTLR_ELx_EE    (1 << 25)
 #define SCTLR_ELx_I	(1 << 12)
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 481bea64..8d04926 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1624,6 +1624,32 @@ static bool access_id_aa64mmfr0_el1(struct kvm_vcpu *v,
 #define SYS_INSN_TO_DESC(insn, access_fn, forward_fn)	\
 	{ SYS_DESC((insn)), (access_fn), NULL, 0, 0, NULL, NULL, (forward_fn) }
 static struct sys_reg_desc sys_insn_descs[] = {
+	SYS_INSN_TO_DESC(AT_S1E1R, NULL, NULL),
+	SYS_INSN_TO_DESC(AT_S1E1W, NULL, NULL),
+	SYS_INSN_TO_DESC(AT_S1E0R, NULL, NULL),
+	SYS_INSN_TO_DESC(AT_S1E0W, NULL, NULL),
+	SYS_INSN_TO_DESC(AT_S1E1RP, NULL, NULL),
+	SYS_INSN_TO_DESC(AT_S1E1WP, NULL, NULL),
+	SYS_INSN_TO_DESC(AT_S1E2R, NULL, NULL),
+	SYS_INSN_TO_DESC(AT_S1E2W, NULL, NULL),
+	SYS_INSN_TO_DESC(AT_S12E1R, NULL, NULL),
+	SYS_INSN_TO_DESC(AT_S12E1W, NULL, NULL),
+	SYS_INSN_TO_DESC(AT_S12E0R, NULL, NULL),
+	SYS_INSN_TO_DESC(AT_S12E0W, NULL, NULL),
+	SYS_INSN_TO_DESC(TLBI_IPAS2E1IS, NULL, NULL),
+	SYS_INSN_TO_DESC(TLBI_IPAS2LE1IS, NULL, NULL),
+	SYS_INSN_TO_DESC(TLBI_ALLE2IS, NULL, NULL),
+	SYS_INSN_TO_DESC(TLBI_VAE2IS, NULL, NULL),
+	SYS_INSN_TO_DESC(TLBI_ALLE1IS, NULL, NULL),
+	SYS_INSN_TO_DESC(TLBI_VALE2IS, NULL, NULL),
+	SYS_INSN_TO_DESC(TLBI_VMALLS12E1IS, NULL, NULL),
+	SYS_INSN_TO_DESC(TLBI_IPAS2E1, NULL, NULL),
+	SYS_INSN_TO_DESC(TLBI_IPAS2LE1, NULL, NULL),
+	SYS_INSN_TO_DESC(TLBI_ALLE2, NULL, NULL),
+	SYS_INSN_TO_DESC(TLBI_VAE2, NULL, NULL),
+	SYS_INSN_TO_DESC(TLBI_ALLE1, NULL, NULL),
+	SYS_INSN_TO_DESC(TLBI_VALE2, NULL, NULL),
+	SYS_INSN_TO_DESC(TLBI_VMALLS12E1, NULL, NULL),
 };
 
 #define reg_to_match_value(x)						\
-- 
1.9.1
