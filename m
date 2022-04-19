Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1D74C4332F
	for <kvmarm@archiver.kernel.org>; Tue, 19 Apr 2022 06:57:33 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4B3974B224;
	Tue, 19 Apr 2022 02:57:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XG2LXqnKbdCS; Tue, 19 Apr 2022 02:57:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 47C4E4B225;
	Tue, 19 Apr 2022 02:57:31 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 106384B1F0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Apr 2022 02:57:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3k+9TWjUU8LY for <kvmarm@lists.cs.columbia.edu>;
 Tue, 19 Apr 2022 02:57:28 -0400 (EDT)
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com
 [209.85.214.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E4C574B1DD
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Apr 2022 02:57:27 -0400 (EDT)
Received: by mail-pl1-f201.google.com with SMTP id
 i10-20020a1709026aca00b00158f14b4f2fso3811272plt.2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Apr 2022 23:57:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=mY58E5CEbgw/vqLwN8lNA68QyCXeYwjNR+19470Skts=;
 b=D9zNYiG8IagBlgPRP6t0YDQ+UlvsGKN1XK37MKVh6q28jhcUIa9Dmu/Pqz+qwMe1Hc
 9uD0B35UcJfiqoc71UhvmiHmKtEnNVWeNIkJoAMkRrdBl2be+AF27TcvlrHKPoTrMhaA
 e6v9dP6oybbI9bM7vBx8tYi68GW9bHnu7Bp71AuzVNDqc1f/4Oanh5XM5bbRDPpiCHTH
 vj2pgmJaD+pcfNRdyTlvO0suXsOBx+H3lOgtUjeIVkAy5nZn5baXdR5KIj6wRhjxvHMw
 TUKV8iYlDIpkM12jHcrfWsRj1X7mku9VxlrMDIz6YL8oEgOPUXW+T7IOQ5Mu6VRoxwbT
 O+sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=mY58E5CEbgw/vqLwN8lNA68QyCXeYwjNR+19470Skts=;
 b=C45i8/z3U+hS/ZAjq3vDWfzb8UoFzHUta3s1eOi0MGaD68140W7Q8lHRH8yRLBFEu3
 knA0g/vLRkGBA2TNB4Lxk/vstFxFF7jgcesHbnfbVzX9z/72aWnXU+CFdACytlk8p6FH
 Oke0GkUQ/v+WCZEaOfZ+BcrkYXwj1+xnRDC5yR53gr3bfLIevuEfXNiS9PltCyuIJviD
 lnbt2FHE4nrobcmq0ZlxB57UI7NFZHJYMhtNQ+zjFPfZaO1T1Tg1mwElUWZsWcRUAqm5
 RF4xtUVTQ56kH29YRX7vILzzjzcdNn7VWhKuep7JjM6qVsiOr6WjR/FWjTUkrsHdbaea
 w1IQ==
X-Gm-Message-State: AOAM531yeq1oIBcvkyQdP9aT+Oh67dvqONNng7yNapbGl1jXkmjaS3w0
 zfuvyEn63+84woqop4xj23CKg19TZj4=
X-Google-Smtp-Source: ABdhPJyb61f6We7WvnJKdvErxty6ITBIiKAYfzLLP0LpiwJQ8vRqfcew7l+CKCajxhuS3Re/rGFp4Iewv4A=
X-Received: from reiji-vws-sp.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:902:aa88:b0:156:914b:dc79 with SMTP id
 d8-20020a170902aa8800b00156914bdc79mr14409922plr.138.1650351447051; Mon, 18
 Apr 2022 23:57:27 -0700 (PDT)
Date: Mon, 18 Apr 2022 23:55:19 -0700
In-Reply-To: <20220419065544.3616948-1-reijiw@google.com>
Message-Id: <20220419065544.3616948-14-reijiw@google.com>
Mime-Version: 1.0
References: <20220419065544.3616948-1-reijiw@google.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [PATCH v7 13/38] KVM: arm64: Emulate dbgbcr/dbgbvr accesses
From: Reiji Watanabe <reijiw@google.com>
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Peter Shier <pshier@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Highest numbered breakpoints must be context aware breakpoints
(as specified by Arm ARM).  If the number of non-context aware
breakpoints for the guest is decreased by userspace (e.g. Lower
ID_AA64DFR0.BRPs keeping ID_AA64DFR0.CTX_CMPs the same), simply
narrowing the breakpoints will be problematic because it will
lead to narrowing context aware breakpoints for the guest.

Emulate dbgbcr/dbgbvr accesses in that case and map context
aware breakpoints for the vCPU to different numbered breakpoints
for the pCPU, but will maintain the offset in context aware
breakpoints.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/include/asm/sysreg.h |   9 +-
 arch/arm64/kvm/sys_regs.c       | 402 ++++++++++++++++++++++++++++++--
 2 files changed, 394 insertions(+), 17 deletions(-)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index b33b7ce87fb2..9b475ba95ffd 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -124,9 +124,16 @@
 #define SYS_OSDTRTX_EL1			sys_reg(2, 0, 0, 3, 2)
 #define SYS_OSECCR_EL1			sys_reg(2, 0, 0, 6, 2)
 #define SYS_DBGBVRn_EL1(n)		sys_reg(2, 0, 0, n, 4)
-#define SYS_DBGBCRn_EL1(n)		sys_reg(2, 0, 0, n, 5)
 #define SYS_DBGWVRn_EL1(n)		sys_reg(2, 0, 0, n, 6)
+
+#define SYS_DBGBCRn_EL1(n)		sys_reg(2, 0, 0, n, 5)
+#define SYS_DBGBCR_EL1_LBN_SHIFT	16
+#define SYS_DBGBCR_EL1_LBN_MASK		GENMASK(3, 0)
+
 #define SYS_DBGWCRn_EL1(n)		sys_reg(2, 0, 0, n, 7)
+#define SYS_DBGWCR_EL1_LBN_SHIFT	16
+#define SYS_DBGWCR_EL1_LBN_MASK		GENMASK(3, 0)
+
 #define SYS_MDRAR_EL1			sys_reg(2, 0, 1, 0, 0)
 
 #define SYS_OSLAR_EL1			sys_reg(2, 0, 1, 0, 4)
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index f4aae4ccffd0..2ee1e0b6c4ce 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -849,17 +849,230 @@ static bool trap_dbgauthstatus_el1(struct kvm_vcpu *vcpu,
 #define AA64DFR0_CTX_CMPS(v)	\
 	((u8)cpuid_feature_extract_unsigned_field(v, ID_AA64DFR0_CTX_CMPS_SHIFT))
 
+#define INVALID_BRPN	((u8)-1)
+
+static u8 get_bcr_lbn(u64 val)
+{
+	return ((val >> SYS_DBGBCR_EL1_LBN_SHIFT) & SYS_DBGBCR_EL1_LBN_MASK);
+}
+
+static u64 update_bcr_lbn(u64 val, u8 lbn)
+{
+	u64 new;
+
+	new = val & ~(SYS_DBGBCR_EL1_LBN_MASK << SYS_DBGBCR_EL1_LBN_SHIFT);
+	new |= ((u64)lbn & SYS_DBGBCR_EL1_LBN_MASK) << SYS_DBGBCR_EL1_LBN_SHIFT;
+	return new;
+}
+
+/*
+ * KVM will emulate breakpoints access when the number of non-context
+ * aware (normal) breakpoints is decreased for the guest. For instsance,
+ * it will happen when userspace decreases the number of breakpoints
+ * for the guest keeping the same number of context aware breakpoints.
+ * Simply narrowing the number of breakpoints for the guest will lead
+ * to narrowing context aware breakpoints for the guest because as per
+ * Arm ARM, highest numbered breakpoints are context aware breakpoints.
+ * So, in that case, KVM will map context aware breakpoints for the
+ * vCPU to different numbered breakpoints for the pCPU, but will
+ * maintain the offset in context aware breakpoints.
+ * For instance, if 5 breakpoints are supported, and 2 of them are
+ * context aware breakpoints, breakpoint#0, #1 and #2 are normal
+ * breakpoints, and #3 and #4 are context aware breakpoints.
+ * If userspace decreases the number of breakpoints to 4 keeping the
+ * same number of context aware breakpoints (== 2), the guest expects
+ * breakpoint#0 and #1 to be normal breakpoints, and #2 and #3 to be
+ * context aware breakpoints. So, KVM will map the (virtual) context
+ * aware breakpoint #2 and #3 for the vCPU to (physical) context aware
+ * breakpoint #3 and #4 for the pCPU as follows.
+ *
+ * [Example]
+ *
+ *           Normal Breakpoints   Context aware breakpoints
+ * Virtual     #0  #1              #2  #3
+ *              |   |               |   |
+ * Physical    #0  #1  #2          #3  #4
+ *
+ * So, dbg{b,w}cr.lbn (linked breakpoint number) for vCPU might be
+ * different from the ones for pCPU (e.g. With the above example,
+ * when the guest sets dbgbcr0.lbn to 2 for the vCPU, dbgbcr0.lbn
+ * for the pCPU should be set to 3).
+ * Values in vcpu_debug_state of kvm_vcpu_arch will basically be the ones
+ * that are going to be set to the physical registers (indexed by physical
+ * context breakpoint number). But, they hold the values from the guest
+ * point of view until the first KVM_RUN (physical/virtual breakpoint
+ * numbers mapping is fixed) and they will be converted to the
+ * physical values during the process of first KVM_RUN.
+ *
+ * As there is no functional difference between any watchpoints,
+ * virtual watchpoint# will be always same as physical watchpoint#.
+ */
+
+/*
+ * Convert breakpoint# for the guest to breakpoint# for the real hardware.
+ * Return INVALID_BRPN if the given breakpoint# is invalid.
+ */
+static inline u8 virt_to_phys_bpn(struct kvm_vcpu *vcpu, u8 v_bpn)
+{
+	u8 virt_ctx_base, phys_ctx_base;
+	u64 p_val, v_val;
+
+	v_val = read_id_reg_with_encoding(vcpu, SYS_ID_AA64DFR0_EL1);
+	if (v_bpn > AA64DFR0_BRPS(v_val)) {
+		/*
+		 * The virtual bpn is out of valid virtual breakpoint number
+		 * range. Return the invalid breakpoint number.
+		 */
+		return INVALID_BRPN;
+	}
+
+	if (!test_bit(KVM_ARCH_FLAG_EMULATE_DEBUG_REGS, &vcpu->kvm->arch.flags))
+		 /* physical bpn == virtual bpn when no emulation is needed */
+		return v_bpn;
+
+	/* The lowest virtual context aware bpn */
+	virt_ctx_base = AA64DFR0_BRPS(v_val) - AA64DFR0_CTX_CMPS(v_val);
+	if (v_bpn < virt_ctx_base)
+		/*
+		 * physical bpn == virtual bpn when v_bpn is not a
+		 * context aware breakpoint.
+		 */
+		return v_bpn;
+
+	p_val = read_sanitised_ftr_reg(SYS_ID_AA64DFR0_EL1);
+	/* The lowest physical context aware bpn */
+	phys_ctx_base = AA64DFR0_BRPS(p_val) - AA64DFR0_CTX_CMPS(p_val);
+
+	WARN_ON_ONCE(virt_ctx_base >= phys_ctx_base);
+
+	/*
+	 * Context aware bpn.  Map it to the same offset of physical
+	 * context aware registers.
+	 */
+	return phys_ctx_base + (v_bpn - virt_ctx_base);
+}
+
 /*
- * Set KVM_ARCH_FLAG_EMULATE_DEBUG_REGS in the VM flags when the number of
- * non-context aware breakpoints for the guest is decreased by userspace
- * (meaning that debug register accesses need to be emulated).
+ * Convert breakpoint# for the real hardware to breakpoint# for the guest.
+ * Return INVALID_BRPN if the given breakpoint# is not used for the guest.
+ */
+static inline u8 phys_to_virt_bpn(struct kvm_vcpu *vcpu, u8 p_bpn)
+{
+	u8 virt_ctx_base, phys_ctx_base, v_bpn;
+	u64 p_val, v_val;
+
+	if (!test_bit(KVM_ARCH_FLAG_EMULATE_DEBUG_REGS, &vcpu->kvm->arch.flags))
+		return p_bpn;
+
+	v_val = read_id_reg_with_encoding(vcpu, SYS_ID_AA64DFR0_EL1);
+
+	/* The lowest virtual context aware bpn */
+	virt_ctx_base = AA64DFR0_BRPS(v_val) - AA64DFR0_CTX_CMPS(v_val);
+	if (p_bpn < virt_ctx_base)
+		/*
+		 * physical bpn == virtual bpn when p_bpn is smaller than
+		 * the lowest virutual context aware breakpoint number.
+		 */
+		return p_bpn;
+
+	p_val = read_sanitised_ftr_reg(SYS_ID_AA64DFR0_EL1);
+
+	/* The lowest physical context aware bpn */
+	phys_ctx_base = AA64DFR0_BRPS(p_val) - AA64DFR0_CTX_CMPS(p_val);
+	if (p_bpn < phys_ctx_base)
+		/*
+		 * Unused non-context aware breakpoint.
+		 * No virtual breakpoint is assigned for this.
+		 */
+		return INVALID_BRPN;
+
+	WARN_ON_ONCE(virt_ctx_base >= phys_ctx_base);
+
+	/*
+	 * Context aware bpn. Map it to the same offset of virtual
+	 * context aware registers.
+	 */
+	v_bpn = virt_ctx_base + (p_bpn - phys_ctx_base);
+	if (v_bpn > AA64DFR0_BRPS(v_val)) {
+		/* This pysical bpn is not mapped to any virtual bpn */
+		return INVALID_BRPN;
+	}
+
+	return v_bpn;
+}
+
+static u8 get_unused_p_bpn(struct kvm_vcpu *vcpu)
+{
+	u64 p_val = read_sanitised_ftr_reg(SYS_ID_AA64DFR0_EL1);
+
+	WARN_ON_ONCE(!test_bit(KVM_ARCH_FLAG_EMULATE_DEBUG_REGS, &vcpu->kvm->arch.flags));
+
+	/*
+	 * The last normal (non-context aware) break point is always unused
+	 * (and disabled) when kvm_arm_need_emulate_debug_regs() is true.
+	 */
+	return AA64DFR0_BRPS(p_val) - AA64DFR0_CTX_CMPS(p_val) - 1;
+}
+
+/*
+ * virt_to_phys_bcr() converts the virtual bcr value (the bcr value from
+ * the guest point of view) to physical bcr value, which is going to be set
+ * to the real hardware.  More specifically, as a lbn field value of the
+ * virtual bcr includes the virtual breakpoint number, the function will
+ * update the bcr with physical breakpoint number, and will return it as
+ * the physical bcr value. phys_to_virt_bcr()) does the opposite.
+ *
+ * As per Arm ARM (ARM DDI 0487H.a), if a Linked Address breakpoint links
+ * to a breakpoint that is not implemented or that is not context aware,
+ * then reads of bcr.lbn return an unknown value, and the Linked Address
+ * breakpoint behaves as if it is either disabled or linked to an UNKNOWN
+ * context aware breakpoint. In such cases, KVM will return 0 to reads of
+ * bcr.lbn, and have the breakpoint behaves as if it is disabled by
+ * setting the lbn to unused (disabled) breakpoint.
+ */
+static u64 virt_to_phys_bcr(struct kvm_vcpu *vcpu, u64 v_bcr)
+{
+	u8 v_lbn, p_lbn;
+
+	v_lbn = get_bcr_lbn(v_bcr);
+	p_lbn = virt_to_phys_bpn(vcpu, v_lbn);
+	if (p_lbn == INVALID_BRPN)
+		p_lbn = get_unused_p_bpn(vcpu);
+
+	return update_bcr_lbn(v_bcr, p_lbn);
+}
+
+static u64 phys_to_virt_bcr(struct kvm_vcpu *vcpu, u64 p_bcr)
+{
+	u8 v_lbn, p_lbn;
+
+	p_lbn = get_bcr_lbn(p_bcr);
+	v_lbn = phys_to_virt_bpn(vcpu, p_lbn);
+	if (v_lbn == INVALID_BRPN)
+		v_lbn = 0;
+
+	return update_bcr_lbn(p_bcr, v_lbn);
+}
+
+/*
+ * Check if the number of normal breakpoints for the guest is same as
+ * the one for the host. If so, do nothing.
+ * Otherwise (accesses of debug registers needs to be emulated), set
+ * KVM_ARCH_FLAG_EMULATE_DEBUG_REGS in the VM flags, and convert values
+ * in vcpu->arch.vcpu_debug_state that are values from the guest
+ * point of view to values that are going to be set to hardware
+ * registers. See comments for set_bvr() for some more details.
  */
 void kvm_vcpu_breakpoint_config(struct kvm_vcpu *vcpu)
 {
 	u64 p_val = read_sanitised_ftr_reg(SYS_ID_AA64DFR0_EL1);
 	u64 v_val = read_id_reg_with_encoding(vcpu, SYS_ID_AA64DFR0_EL1);
 	u8 v_nbpn, p_nbpn;
+	u64 p_bcr;
 	struct kvm *kvm = vcpu->kvm;
+	int v;
+	u8 p_bpn;
+	struct kvm_guest_debug_arch *dbg = &vcpu->arch.vcpu_debug_state;
 
 	/*
 	 * Check the number of normal (non-context aware) breakpoints
@@ -877,11 +1090,39 @@ void kvm_vcpu_breakpoint_config(struct kvm_vcpu *vcpu)
 
 	if (!test_bit(KVM_ARCH_FLAG_EMULATE_DEBUG_REGS, &kvm->arch.flags))
 		set_bit(KVM_ARCH_FLAG_EMULATE_DEBUG_REGS, &kvm->arch.flags);
+
+	/*
+	 * Before the first KVM_RUN, vcpu->arch.vcpu_debug_state holds
+	 * values of the registers to be exposed to the guest and their
+	 * positions are indexed by virtual breakpoint numbers.
+	 * Convert the values to physical values that are going to set
+	 * to hardware registers, and move them to positions indexed
+	 * by physical breakpoint numbers.
+	 */
+	for (v = KVM_ARM_MAX_DBG_REGS - 1; v >= 0; v--) {
+		/* Get physical breakpoint number */
+		p_bpn = virt_to_phys_bpn(vcpu, v);
+		WARN_ON_ONCE(p_bpn < v);
+
+		if (p_bpn != INVALID_BRPN) {
+			/* Get physical bcr */
+			p_bcr = virt_to_phys_bcr(vcpu, dbg->dbg_bcr[v]);
+			dbg->dbg_bcr[p_bpn] = p_bcr;
+			dbg->dbg_bvr[p_bpn] = dbg->dbg_bvr[v];
+		}
+
+		/* Clear dbg_b{c,v}r, which might not be used */
+		if (p_bpn != v) {
+			dbg->dbg_bcr[v] = 0;
+			dbg->dbg_bvr[v] = 0;
+		}
+	}
 }
 
 /*
  * We want to avoid world-switching all the DBG registers all the
- * time:
+ * time unless userspace decrease number of non-context break points,
+ * where emulating of access to debug registers is required.
  *
  * - If we've touched any debug register, it is likely that we're
  *   going to touch more of them. It then makes sense to disable the
@@ -963,8 +1204,17 @@ static bool trap_bvr(struct kvm_vcpu *vcpu,
 		     struct sys_reg_params *p,
 		     const struct sys_reg_desc *rd)
 {
-	u64 *dbg_reg = &vcpu->arch.vcpu_debug_state.dbg_bvr[rd->CRm];
+	u64 p_bpn;
+	u64 *dbg_reg;
 
+	/* Convert the virt breakpoint num to phys breakpoint num */
+	p_bpn = virt_to_phys_bpn(vcpu, rd->CRm);
+	if (p_bpn == INVALID_BRPN) {
+		kvm_inject_undefined(vcpu);
+		return false;
+	}
+
+	dbg_reg = &vcpu->arch.vcpu_debug_state.dbg_bvr[p_bpn];
 	if (p->is_write)
 		reg_to_dbg(vcpu, p, rd, dbg_reg);
 	else
@@ -975,23 +1225,85 @@ static bool trap_bvr(struct kvm_vcpu *vcpu,
 	return true;
 }
 
+/*
+ * The behaviors of {s,g}et_b{c,v}r change depending on whether they
+ * are called before or after the first KVM_RUN.
+ *
+ * Before the first KVM_RUN (the number of breakpoints is not fixed yet),
+ * the vcpu->arch.vcpu_debug_state holds debug register values from
+ * the guest point of view. The set_b{c,v}r() simply save the value
+ * from userspace in vcpu->arch.vcpu_debug_state, and get_b{c,v}r()
+ * simply return the value in vcpu->arch.vcpu_debug_state to userspace.
+ *
+ * At the first KVM_RUN (where the number of breakpoints is immutable),
+ * b{c,v}r values in vcpu->arch.vcpu_debug_state are converted to
+ * the values that are going to be set to hardware registers.
+ * After that, vcpu->arch.vcpu_debug_state holds debug register values that
+ * are going to set to hardware registers.  The set_b{c,v}r functions convert
+ * the value from userspace to the one that will be set to the hardware
+ * register and save the converted value in vcpu->arch.vcpu_debug_state.
+ * The get_b{c,v}r functions read the value from vcpu->arch.vcpu_debug_state,
+ * convert it to the value as seen by the guest and return the converted
+ * value to the userspace.
+ *
+ * The {s,g}et_b{c,v}r will treat the invalid breakpoint registers,
+ * which are not mapped to physical breakpoints, as RAZ/WI after the first
+ * KVM_RUN (values that userspace attempts to set in those registers will
+ * not be saved anywhere), which shouldn't be a problem because they will
+ * never be exposed to the guest anyway. Until the first KVM_RUN, setting
+ * and getting of those work normally though (The number of breakpoints
+ * could be changed by userspace until the first KVM_RUN).
+ */
 static int set_bvr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 		const struct kvm_one_reg *reg, void __user *uaddr)
 {
-	__u64 *r = &vcpu->arch.vcpu_debug_state.dbg_bvr[rd->CRm];
+	u8 v_bpn, p_bpn;
+	__u64 bvr;
 
-	if (copy_from_user(r, uaddr, KVM_REG_SIZE(reg->id)) != 0)
+	if (copy_from_user(&bvr, uaddr, KVM_REG_SIZE(reg->id)) != 0)
 		return -EFAULT;
+
+	v_bpn = rd->CRm;
+
+	/*
+	 * Until the first KVM_RUN, vcpu_debug_state holds the virtual bvr.
+	 * After that, vcpu_debug_state holds the physical bvr.
+	 */
+	if (vcpu_has_run_once(vcpu)) {
+		/* Convert the virt breakpoint num to phys breakpoint num */
+		p_bpn = virt_to_phys_bpn(vcpu, v_bpn);
+		if (p_bpn != INVALID_BRPN)
+			vcpu->arch.vcpu_debug_state.dbg_bvr[p_bpn] = bvr;
+	} else {
+		vcpu->arch.vcpu_debug_state.dbg_bvr[v_bpn] = bvr;
+	}
+
 	return 0;
 }
 
 static int get_bvr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 	const struct kvm_one_reg *reg, void __user *uaddr)
 {
-	__u64 *r = &vcpu->arch.vcpu_debug_state.dbg_bvr[rd->CRm];
+	u8 v_bpn, p_bpn;
+	u64 bvr = 0;
 
-	if (copy_to_user(uaddr, r, KVM_REG_SIZE(reg->id)) != 0)
+	v_bpn = rd->CRm;
+	/*
+	 * Until the first KVM_RUN, vcpu_debug_state holds the virtual bvr.
+	 * After that, vcpu_debug_state holds the physical bvr.
+	 */
+	if (vcpu_has_run_once(vcpu)) {
+		/* Convert the virt breakpoint num to phys breakpoint num */
+		p_bpn = virt_to_phys_bpn(vcpu, v_bpn);
+		if (p_bpn != INVALID_BRPN)
+			bvr = vcpu->arch.vcpu_debug_state.dbg_bvr[p_bpn];
+	} else {
+		bvr = vcpu->arch.vcpu_debug_state.dbg_bvr[v_bpn];
+	}
+
+	if (copy_to_user(uaddr, &bvr, KVM_REG_SIZE(reg->id)) != 0)
 		return -EFAULT;
+
 	return 0;
 }
 
@@ -1005,12 +1317,27 @@ static bool trap_bcr(struct kvm_vcpu *vcpu,
 		     struct sys_reg_params *p,
 		     const struct sys_reg_desc *rd)
 {
-	u64 *dbg_reg = &vcpu->arch.vcpu_debug_state.dbg_bcr[rd->CRm];
+	u8 p_bpn;
+	u64 *dbg_reg;
 
-	if (p->is_write)
+	/* Convert the given virt breakpoint num to phys breakpoint num */
+	p_bpn = virt_to_phys_bpn(vcpu, rd->CRm);
+	if (p_bpn == INVALID_BRPN) {
+		/* Invalid breakpoint number */
+		kvm_inject_undefined(vcpu);
+		return false;
+	}
+
+	dbg_reg = &vcpu->arch.vcpu_debug_state.dbg_bcr[p_bpn];
+	if (p->is_write) {
+		/* Convert virtual bcr to physical bcr */
+		p->regval = virt_to_phys_bcr(vcpu, p->regval);
 		reg_to_dbg(vcpu, p, rd, dbg_reg);
-	else
+	} else {
 		dbg_to_reg(vcpu, p, rd, dbg_reg);
+		/* Convert physical bcr to virtual bcr */
+		p->regval = phys_to_virt_bcr(vcpu, p->regval);
+	}
 
 	trace_trap_reg(__func__, rd->CRm, p->is_write, *dbg_reg);
 
@@ -1020,21 +1347,64 @@ static bool trap_bcr(struct kvm_vcpu *vcpu,
 static int set_bcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 		const struct kvm_one_reg *reg, void __user *uaddr)
 {
-	__u64 *r = &vcpu->arch.vcpu_debug_state.dbg_bcr[rd->CRm];
+	u8 v_bpn, p_bpn;
+	u64 v_bcr, p_bcr;
 
-	if (copy_from_user(r, uaddr, KVM_REG_SIZE(reg->id)) != 0)
+	if (copy_from_user(&v_bcr, uaddr, KVM_REG_SIZE(reg->id)) != 0)
 		return -EFAULT;
 
+	v_bpn = rd->CRm;
+
+	/*
+	 * Until the first KVM_RUN, vcpu_debug_state holds the virtual bcr.
+	 * After that, vcpu_debug_state holds the physical bcr.
+	 */
+	if (vcpu_has_run_once(vcpu)) {
+		/* Convert the virt breakpoint num to phys breakpoint num */
+		p_bpn = virt_to_phys_bpn(vcpu, v_bpn);
+		if (p_bpn != INVALID_BRPN) {
+			/* Convert virt bcr to phys bcr, and save it */
+			p_bcr = virt_to_phys_bcr(vcpu, v_bcr);
+			vcpu->arch.vcpu_debug_state.dbg_bcr[p_bpn] = p_bcr;
+		}
+	} else {
+		vcpu->arch.vcpu_debug_state.dbg_bcr[v_bpn] = v_bcr;
+	}
+
 	return 0;
 }
 
 static int get_bcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 	const struct kvm_one_reg *reg, void __user *uaddr)
 {
-	__u64 *r = &vcpu->arch.vcpu_debug_state.dbg_bcr[rd->CRm];
+	u8 v_bpn, p_bpn;
+	u64 v_bcr = 0;
+	u64 p_bcr;
 
-	if (copy_to_user(uaddr, r, KVM_REG_SIZE(reg->id)) != 0)
+	v_bpn = rd->CRm;
+	/*
+	 * Until the first KVM_RUN, vcpu_debug_state holds the virtual bcr.
+	 * After that, vcpu_debug_state holds the physical bcr.
+	 */
+	if (vcpu_has_run_once(vcpu)) {
+		/*
+		 * Convert the virtual breakpoint num to phys breakpoint num,
+		 * and get the physical bcr value.
+		 */
+		p_bpn = virt_to_phys_bpn(vcpu, v_bpn);
+		if (p_bpn != INVALID_BRPN) {
+			p_bcr = vcpu->arch.vcpu_debug_state.dbg_bcr[p_bpn];
+
+			/* Convert physical bcr to  */
+			v_bcr = phys_to_virt_bcr(vcpu, p_bcr);
+		}
+	} else {
+		v_bcr = vcpu->arch.vcpu_debug_state.dbg_bcr[v_bpn];
+	}
+
+	if (copy_to_user(uaddr, &v_bcr, KVM_REG_SIZE(reg->id)) != 0)
 		return -EFAULT;
+
 	return 0;
 }
 
-- 
2.36.0.rc0.470.gd361397f0d-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
