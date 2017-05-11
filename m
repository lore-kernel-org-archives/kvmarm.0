From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [PATCH v2 1/2] KVM: arm: plug potential guest hardware debug leakage
Date: Thu, 11 May 2017 13:46:11 +0100
Message-ID: <20170511124612.11212-2-alex.bennee@linaro.org>
References: <20170511124612.11212-1-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170511124612.11212-1-alex.bennee@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: christoffer.dall@linaro.org, marc.zyngier@arm.com
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, Zhichao Huang <zhichao.huang@linaro.org>, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, Russell King <linux@armlinux.org.uk>, Vladimir Murzin <vladimir.murzin@arm.com>, open list <linux-kernel@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

From: Zhichao Huang <zhichao.huang@linaro.org>

Hardware debugging in guests is not intercepted currently, it means
that a malicious guest can bring down the entire machine by writing
to the debug registers.

This patch enable trapping of all debug registers, preventing the
guests to access the debug registers. This includes access to the
debug mode(DBGDSCR) in the guest world all the time which could
otherwise mess with the host state. Reads return 0 and writes are
ignored (RAZ_WI).

The result is the guest cannot detect any working hardware based debug
support. As debug exceptions are still routed to the guest normal
debug using software based breakpoints still works.

To support debugging using hardware registers we need to implement a
debug register aware world switch as well as special trapping for
registers that may affect the host state.

Signed-off-by: Zhichao Huang <zhichao.huang@linaro.org>
Signed-off-by: Alex Bennée <alex.bennee@linaro.org>

---
ajb v2:
 - don't (void) unused return value
 - fix some 0/1 bool usage
 - further re-factor to avoid hacky if (cp15) in trap path
ajb v1:
  - convert to C world switch
  - reword commit message
---
 arch/arm/include/asm/kvm_coproc.h |  3 +-
 arch/arm/kvm/coproc.c             | 77 ++++++++++++++++++++++++++++++---------
 arch/arm/kvm/handle_exit.c        |  4 +-
 arch/arm/kvm/hyp/switch.c         |  4 +-
 4 files changed, 66 insertions(+), 22 deletions(-)

diff --git a/arch/arm/include/asm/kvm_coproc.h b/arch/arm/include/asm/kvm_coproc.h
index 4917c2f7e459..e74ab0fbab79 100644
--- a/arch/arm/include/asm/kvm_coproc.h
+++ b/arch/arm/include/asm/kvm_coproc.h
@@ -31,7 +31,8 @@ void kvm_register_target_coproc_table(struct kvm_coproc_target_table *table);
 int kvm_handle_cp10_id(struct kvm_vcpu *vcpu, struct kvm_run *run);
 int kvm_handle_cp_0_13_access(struct kvm_vcpu *vcpu, struct kvm_run *run);
 int kvm_handle_cp14_load_store(struct kvm_vcpu *vcpu, struct kvm_run *run);
-int kvm_handle_cp14_access(struct kvm_vcpu *vcpu, struct kvm_run *run);
+int kvm_handle_cp14_32(struct kvm_vcpu *vcpu, struct kvm_run *run);
+int kvm_handle_cp14_64(struct kvm_vcpu *vcpu, struct kvm_run *run);
 int kvm_handle_cp15_32(struct kvm_vcpu *vcpu, struct kvm_run *run);
 int kvm_handle_cp15_64(struct kvm_vcpu *vcpu, struct kvm_run *run);
 
diff --git a/arch/arm/kvm/coproc.c b/arch/arm/kvm/coproc.c
index 3e5e4194ef86..c3ed6bd5ddf3 100644
--- a/arch/arm/kvm/coproc.c
+++ b/arch/arm/kvm/coproc.c
@@ -93,12 +93,6 @@ int kvm_handle_cp14_load_store(struct kvm_vcpu *vcpu, struct kvm_run *run)
 	return 1;
 }
 
-int kvm_handle_cp14_access(struct kvm_vcpu *vcpu, struct kvm_run *run)
-{
-	kvm_inject_undefined(vcpu);
-	return 1;
-}
-
 static void reset_mpidr(struct kvm_vcpu *vcpu, const struct coproc_reg *r)
 {
 	/*
@@ -514,12 +508,7 @@ static int emulate_cp15(struct kvm_vcpu *vcpu,
 	return 1;
 }
 
-/**
- * kvm_handle_cp15_64 -- handles a mrrc/mcrr trap on a guest CP15 access
- * @vcpu: The VCPU pointer
- * @run:  The kvm_run struct
- */
-int kvm_handle_cp15_64(struct kvm_vcpu *vcpu, struct kvm_run *run)
+static struct coproc_params decode_64bit_hsr(struct kvm_vcpu *vcpu)
 {
 	struct coproc_params params;
 
@@ -533,9 +522,38 @@ int kvm_handle_cp15_64(struct kvm_vcpu *vcpu, struct kvm_run *run)
 	params.Rt2 = (kvm_vcpu_get_hsr(vcpu) >> 10) & 0xf;
 	params.CRm = 0;
 
+	return params;
+}
+
+/**
+ * kvm_handle_cp15_64 -- handles a mrrc/mcrr trap on a guest CP15 access
+ * @vcpu: The VCPU pointer
+ * @run:  The kvm_run struct
+ */
+int kvm_handle_cp15_64(struct kvm_vcpu *vcpu, struct kvm_run *run)
+{
+	struct coproc_params params = decode_64bit_hsr(vcpu);
+
 	return emulate_cp15(vcpu, &params);
 }
 
+/**
+ * kvm_handle_cp14_64 -- handles a mrrc/mcrr trap on a guest CP14 access
+ * @vcpu: The VCPU pointer
+ * @run:  The kvm_run struct
+ */
+int kvm_handle_cp14_64(struct kvm_vcpu *vcpu, struct kvm_run *run)
+{
+	struct coproc_params params = decode_64bit_hsr(vcpu);
+
+	/* raz_wi cp14 */
+	pm_fake(vcpu, &params, NULL);
+
+	/* handled */
+	kvm_skip_instr(vcpu, kvm_vcpu_trap_il_is32bit(vcpu));
+	return 1;
+}
+
 static void reset_coproc_regs(struct kvm_vcpu *vcpu,
 			      const struct coproc_reg *table, size_t num)
 {
@@ -546,12 +564,7 @@ static void reset_coproc_regs(struct kvm_vcpu *vcpu,
 			table[i].reset(vcpu, &table[i]);
 }
 
-/**
- * kvm_handle_cp15_32 -- handles a mrc/mcr trap on a guest CP15 access
- * @vcpu: The VCPU pointer
- * @run:  The kvm_run struct
- */
-int kvm_handle_cp15_32(struct kvm_vcpu *vcpu, struct kvm_run *run)
+static struct coproc_params decode_32bit_hsr(struct kvm_vcpu *vcpu)
 {
 	struct coproc_params params;
 
@@ -565,9 +578,37 @@ int kvm_handle_cp15_32(struct kvm_vcpu *vcpu, struct kvm_run *run)
 	params.Op2 = (kvm_vcpu_get_hsr(vcpu) >> 17) & 0x7;
 	params.Rt2 = 0;
 
+	return params;
+}
+
+/**
+ * kvm_handle_cp15_32 -- handles a mrc/mcr trap on a guest CP15 access
+ * @vcpu: The VCPU pointer
+ * @run:  The kvm_run struct
+ */
+int kvm_handle_cp15_32(struct kvm_vcpu *vcpu, struct kvm_run *run)
+{
+	struct coproc_params params = decode_32bit_hsr(vcpu);
 	return emulate_cp15(vcpu, &params);
 }
 
+/**
+ * kvm_handle_cp14_32 -- handles a mrc/mcr trap on a guest CP14 access
+ * @vcpu: The VCPU pointer
+ * @run:  The kvm_run struct
+ */
+int kvm_handle_cp14_32(struct kvm_vcpu *vcpu, struct kvm_run *run)
+{
+	struct coproc_params params = decode_32bit_hsr(vcpu);
+
+	/* raz_wi cp14 */
+	pm_fake(vcpu, &params, NULL);
+
+	/* handled */
+	kvm_skip_instr(vcpu, kvm_vcpu_trap_il_is32bit(vcpu));
+	return 1;
+}
+
 /******************************************************************************
  * Userspace API
  *****************************************************************************/
diff --git a/arch/arm/kvm/handle_exit.c b/arch/arm/kvm/handle_exit.c
index 96af65a30d78..42f5daf715d0 100644
--- a/arch/arm/kvm/handle_exit.c
+++ b/arch/arm/kvm/handle_exit.c
@@ -95,9 +95,9 @@ static exit_handle_fn arm_exit_handlers[] = {
 	[HSR_EC_WFI]		= kvm_handle_wfx,
 	[HSR_EC_CP15_32]	= kvm_handle_cp15_32,
 	[HSR_EC_CP15_64]	= kvm_handle_cp15_64,
-	[HSR_EC_CP14_MR]	= kvm_handle_cp14_access,
+	[HSR_EC_CP14_MR]	= kvm_handle_cp14_32,
 	[HSR_EC_CP14_LS]	= kvm_handle_cp14_load_store,
-	[HSR_EC_CP14_64]	= kvm_handle_cp14_access,
+	[HSR_EC_CP14_64]	= kvm_handle_cp14_64,
 	[HSR_EC_CP_0_13]	= kvm_handle_cp_0_13_access,
 	[HSR_EC_CP10_ID]	= kvm_handle_cp10_id,
 	[HSR_EC_HVC]		= handle_hvc,
diff --git a/arch/arm/kvm/hyp/switch.c b/arch/arm/kvm/hyp/switch.c
index 92678b7bd046..624a510d31df 100644
--- a/arch/arm/kvm/hyp/switch.c
+++ b/arch/arm/kvm/hyp/switch.c
@@ -48,7 +48,9 @@ static void __hyp_text __activate_traps(struct kvm_vcpu *vcpu, u32 *fpexc_host)
 	write_sysreg(HSTR_T(15), HSTR);
 	write_sysreg(HCPTR_TTA | HCPTR_TCP(10) | HCPTR_TCP(11), HCPTR);
 	val = read_sysreg(HDCR);
-	write_sysreg(val | HDCR_TPM | HDCR_TPMCR, HDCR);
+	val |= HDCR_TPM | HDCR_TPMCR; /* trap performance monitors */
+	val |= HDCR_TDRA | HDCR_TDOSA | HDCR_TDA; /* trap debug regs */
+	write_sysreg(val, HDCR);
 }
 
 static void __hyp_text __deactivate_traps(struct kvm_vcpu *vcpu)
-- 
2.11.0
