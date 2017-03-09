From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 06/10] KVM: arm/arm64: VGIC: Fix command handling while ITS
 being disabled
Date: Thu,  9 Mar 2017 09:55:35 +0000
Message-ID: <20170309095539.14512-7-marc.zyngier@arm.com>
References: <20170309095539.14512-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 554E440962
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Mar 2017 04:55:07 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id A1p2jl1IdB5A for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Mar 2017 04:55:06 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 41E7640625
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Mar 2017 04:55:06 -0500 (EST)
In-Reply-To: <20170309095539.14512-1-marc.zyngier@arm.com>
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
Cc: Christoffer Dall <cdall@linaro.org>, kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>, Linu Cherian <linu.cherian@cavium.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Andre Przywara <andre.przywara@arm.com>

The ITS spec says that ITS commands are only processed when the ITS
is enabled (section 8.19.4, Enabled, bit[0]). Our emulation was not taking
this into account.
Fix this by checking the enabled state before handling CWRITER writes.

On the other hand that means that CWRITER could advance while the ITS
is disabled, and enabling it would need those commands to be processed.
Fix this case as well by refactoring actual command processing and
calling this from both the GITS_CWRITER and GITS_CTLR handlers.

Reviewed-by: Eric Auger <eric.auger@redhat.com>
Reviewed-by: Christoffer Dall <cdall@linaro.org>
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic/vgic-its.c | 109 ++++++++++++++++++++++++++-----------------
 1 file changed, 65 insertions(+), 44 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 571b64a01c50..8d1da1af4b09 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -360,29 +360,6 @@ static int its_sync_lpi_pending_table(struct kvm_vcpu *vcpu)
 	return ret;
 }
 
-static unsigned long vgic_mmio_read_its_ctlr(struct kvm *vcpu,
-					     struct vgic_its *its,
-					     gpa_t addr, unsigned int len)
-{
-	u32 reg = 0;
-
-	mutex_lock(&its->cmd_lock);
-	if (its->creadr == its->cwriter)
-		reg |= GITS_CTLR_QUIESCENT;
-	if (its->enabled)
-		reg |= GITS_CTLR_ENABLE;
-	mutex_unlock(&its->cmd_lock);
-
-	return reg;
-}
-
-static void vgic_mmio_write_its_ctlr(struct kvm *kvm, struct vgic_its *its,
-				     gpa_t addr, unsigned int len,
-				     unsigned long val)
-{
-	its->enabled = !!(val & GITS_CTLR_ENABLE);
-}
-
 static unsigned long vgic_mmio_read_its_typer(struct kvm *kvm,
 					      struct vgic_its *its,
 					      gpa_t addr, unsigned int len)
@@ -1161,33 +1138,16 @@ static void vgic_mmio_write_its_cbaser(struct kvm *kvm, struct vgic_its *its,
 #define ITS_CMD_SIZE			32
 #define ITS_CMD_OFFSET(reg)		((reg) & GENMASK(19, 5))
 
-/*
- * By writing to CWRITER the guest announces new commands to be processed.
- * To avoid any races in the first place, we take the its_cmd lock, which
- * protects our ring buffer variables, so that there is only one user
- * per ITS handling commands at a given time.
- */
-static void vgic_mmio_write_its_cwriter(struct kvm *kvm, struct vgic_its *its,
-					gpa_t addr, unsigned int len,
-					unsigned long val)
+/* Must be called with the cmd_lock held. */
+static void vgic_its_process_commands(struct kvm *kvm, struct vgic_its *its)
 {
 	gpa_t cbaser;
 	u64 cmd_buf[4];
-	u32 reg;
 
-	if (!its)
-		return;
-
-	mutex_lock(&its->cmd_lock);
-
-	reg = update_64bit_reg(its->cwriter, addr & 7, len, val);
-	reg = ITS_CMD_OFFSET(reg);
-	if (reg >= ITS_CMD_BUFFER_SIZE(its->cbaser)) {
-		mutex_unlock(&its->cmd_lock);
+	/* Commands are only processed when the ITS is enabled. */
+	if (!its->enabled)
 		return;
-	}
 
-	its->cwriter = reg;
 	cbaser = CBASER_ADDRESS(its->cbaser);
 
 	while (its->cwriter != its->creadr) {
@@ -1207,6 +1167,34 @@ static void vgic_mmio_write_its_cwriter(struct kvm *kvm, struct vgic_its *its,
 		if (its->creadr == ITS_CMD_BUFFER_SIZE(its->cbaser))
 			its->creadr = 0;
 	}
+}
+
+/*
+ * By writing to CWRITER the guest announces new commands to be processed.
+ * To avoid any races in the first place, we take the its_cmd lock, which
+ * protects our ring buffer variables, so that there is only one user
+ * per ITS handling commands at a given time.
+ */
+static void vgic_mmio_write_its_cwriter(struct kvm *kvm, struct vgic_its *its,
+					gpa_t addr, unsigned int len,
+					unsigned long val)
+{
+	u64 reg;
+
+	if (!its)
+		return;
+
+	mutex_lock(&its->cmd_lock);
+
+	reg = update_64bit_reg(its->cwriter, addr & 7, len, val);
+	reg = ITS_CMD_OFFSET(reg);
+	if (reg >= ITS_CMD_BUFFER_SIZE(its->cbaser)) {
+		mutex_unlock(&its->cmd_lock);
+		return;
+	}
+	its->cwriter = reg;
+
+	vgic_its_process_commands(kvm, its);
 
 	mutex_unlock(&its->cmd_lock);
 }
@@ -1287,6 +1275,39 @@ static void vgic_mmio_write_its_baser(struct kvm *kvm,
 	*regptr = reg;
 }
 
+static unsigned long vgic_mmio_read_its_ctlr(struct kvm *vcpu,
+					     struct vgic_its *its,
+					     gpa_t addr, unsigned int len)
+{
+	u32 reg = 0;
+
+	mutex_lock(&its->cmd_lock);
+	if (its->creadr == its->cwriter)
+		reg |= GITS_CTLR_QUIESCENT;
+	if (its->enabled)
+		reg |= GITS_CTLR_ENABLE;
+	mutex_unlock(&its->cmd_lock);
+
+	return reg;
+}
+
+static void vgic_mmio_write_its_ctlr(struct kvm *kvm, struct vgic_its *its,
+				     gpa_t addr, unsigned int len,
+				     unsigned long val)
+{
+	mutex_lock(&its->cmd_lock);
+
+	its->enabled = !!(val & GITS_CTLR_ENABLE);
+
+	/*
+	 * Try to process any pending commands. This function bails out early
+	 * if the ITS is disabled or no commands have been queued.
+	 */
+	vgic_its_process_commands(kvm, its);
+
+	mutex_unlock(&its->cmd_lock);
+}
+
 #define REGISTER_ITS_DESC(off, rd, wr, length, acc)		\
 {								\
 	.reg_offset = off,					\
-- 
2.11.0
