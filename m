From: Christoffer Dall <cdall@linaro.org>
Subject: [PULL 13/79] KVM: arm64: use common invariant sysreg definitions
Date: Sun, 23 Apr 2017 19:08:23 +0200
Message-ID: <20170423170929.27334-14-cdall@linaro.org>
References: <20170423170929.27334-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2C2C349C66
 for <kvmarm@lists.cs.columbia.edu>; Sun, 23 Apr 2017 13:07:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2ka9uaSxUxwN for <kvmarm@lists.cs.columbia.edu>;
 Sun, 23 Apr 2017 13:06:59 -0400 (EDT)
Received: from mail-wm0-f52.google.com (mail-wm0-f52.google.com [74.125.82.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C332149C54
 for <kvmarm@lists.cs.columbia.edu>; Sun, 23 Apr 2017 13:06:58 -0400 (EDT)
Received: by mail-wm0-f52.google.com with SMTP id r190so50446391wme.1
 for <kvmarm@lists.cs.columbia.edu>; Sun, 23 Apr 2017 10:09:45 -0700 (PDT)
In-Reply-To: <20170423170929.27334-1-cdall@linaro.org>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Mark Rutland <mark.rutland@arm.com>

Now that we have common definitions for the register encodings used by
KVM, make the KVM code uses thse for invariant sysreg definitions. This
makes said definitions a reasonable amount shorter, especially as many
comments are rendered redundant and can be removed.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvmarm@lists.cs.columbia.edu
---
 arch/arm64/kvm/sys_regs.c | 57 ++++++++++++++++-------------------------------
 1 file changed, 19 insertions(+), 38 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 860707f..e637e1d 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1857,44 +1857,25 @@ FUNCTION_INVARIANT(aidr_el1)
 
 /* ->val is filled in by kvm_sys_reg_table_init() */
 static struct sys_reg_desc invariant_sys_regs[] = {
-	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0000), Op2(0b000),
-	  NULL, get_midr_el1 },
-	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0000), Op2(0b110),
-	  NULL, get_revidr_el1 },
-	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0001), Op2(0b000),
-	  NULL, get_id_pfr0_el1 },
-	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0001), Op2(0b001),
-	  NULL, get_id_pfr1_el1 },
-	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0001), Op2(0b010),
-	  NULL, get_id_dfr0_el1 },
-	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0001), Op2(0b011),
-	  NULL, get_id_afr0_el1 },
-	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0001), Op2(0b100),
-	  NULL, get_id_mmfr0_el1 },
-	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0001), Op2(0b101),
-	  NULL, get_id_mmfr1_el1 },
-	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0001), Op2(0b110),
-	  NULL, get_id_mmfr2_el1 },
-	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0001), Op2(0b111),
-	  NULL, get_id_mmfr3_el1 },
-	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0010), Op2(0b000),
-	  NULL, get_id_isar0_el1 },
-	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0010), Op2(0b001),
-	  NULL, get_id_isar1_el1 },
-	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0010), Op2(0b010),
-	  NULL, get_id_isar2_el1 },
-	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0010), Op2(0b011),
-	  NULL, get_id_isar3_el1 },
-	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0010), Op2(0b100),
-	  NULL, get_id_isar4_el1 },
-	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0010), Op2(0b101),
-	  NULL, get_id_isar5_el1 },
-	{ Op0(0b11), Op1(0b001), CRn(0b0000), CRm(0b0000), Op2(0b001),
-	  NULL, get_clidr_el1 },
-	{ Op0(0b11), Op1(0b001), CRn(0b0000), CRm(0b0000), Op2(0b111),
-	  NULL, get_aidr_el1 },
-	{ Op0(0b11), Op1(0b011), CRn(0b0000), CRm(0b0000), Op2(0b001),
-	  NULL, get_ctr_el0 },
+	{ SYS_DESC(SYS_MIDR_EL1), NULL, get_midr_el1 },
+	{ SYS_DESC(SYS_REVIDR_EL1), NULL, get_revidr_el1 },
+	{ SYS_DESC(SYS_ID_PFR0_EL1), NULL, get_id_pfr0_el1 },
+	{ SYS_DESC(SYS_ID_PFR1_EL1), NULL, get_id_pfr1_el1 },
+	{ SYS_DESC(SYS_ID_DFR0_EL1), NULL, get_id_dfr0_el1 },
+	{ SYS_DESC(SYS_ID_AFR0_EL1), NULL, get_id_afr0_el1 },
+	{ SYS_DESC(SYS_ID_MMFR0_EL1), NULL, get_id_mmfr0_el1 },
+	{ SYS_DESC(SYS_ID_MMFR1_EL1), NULL, get_id_mmfr1_el1 },
+	{ SYS_DESC(SYS_ID_MMFR2_EL1), NULL, get_id_mmfr2_el1 },
+	{ SYS_DESC(SYS_ID_MMFR3_EL1), NULL, get_id_mmfr3_el1 },
+	{ SYS_DESC(SYS_ID_ISAR0_EL1), NULL, get_id_isar0_el1 },
+	{ SYS_DESC(SYS_ID_ISAR1_EL1), NULL, get_id_isar1_el1 },
+	{ SYS_DESC(SYS_ID_ISAR2_EL1), NULL, get_id_isar2_el1 },
+	{ SYS_DESC(SYS_ID_ISAR3_EL1), NULL, get_id_isar3_el1 },
+	{ SYS_DESC(SYS_ID_ISAR4_EL1), NULL, get_id_isar4_el1 },
+	{ SYS_DESC(SYS_ID_ISAR5_EL1), NULL, get_id_isar5_el1 },
+	{ SYS_DESC(SYS_CLIDR_EL1), NULL, get_clidr_el1 },
+	{ SYS_DESC(SYS_AIDR_EL1), NULL, get_aidr_el1 },
+	{ SYS_DESC(SYS_CTR_EL0), NULL, get_ctr_el0 },
 };
 
 static int reg_from_user(u64 *val, const void __user *uaddr, u64 id)
-- 
2.9.0
