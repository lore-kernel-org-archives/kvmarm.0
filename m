From: Pavel Fedin <p.fedin@samsung.com>
Subject: [PATCH v3 2/4] KVM: arm64: Remove const from struct sys_reg_params
Date: Fri, 04 Dec 2015 14:42:57 +0300
Message-ID: <5a0277da769bbb2e6e5383ba0daaa0cd0660d645.1449229272.git.p.fedin@samsung.com>
References: <cover.1449229272.git.p.fedin@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 34127498A3
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Dec 2015 06:41:33 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DBP2rdqwOwe7 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  4 Dec 2015 06:41:31 -0500 (EST)
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com
 [210.118.77.12])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A88D3498A1
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Dec 2015 06:41:31 -0500 (EST)
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NYU00CGS0JTWDA0@mailout2.w1.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Fri, 04 Dec 2015 11:43:05 +0000 (GMT)
In-reply-to: <cover.1449229272.git.p.fedin@samsung.com>
In-reply-to: <cover.1449229272.git.p.fedin@samsung.com>
References: <cover.1449229272.git.p.fedin@samsung.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Marc Zyngier <marc.zyngier@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Further rework is going to introduce a dedicated storage for transfer
register value in struct sys_reg_params. Before doing this we have to
remove 'const' modifiers from it in all accessor functions and their
callers.

Signed-off-by: Pavel Fedin <p.fedin@samsung.com>
---
 arch/arm64/kvm/sys_regs.c            | 36 ++++++++++++++++++------------------
 arch/arm64/kvm/sys_regs.h            |  4 ++--
 arch/arm64/kvm/sys_regs_generic_v8.c |  2 +-
 3 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 87a64e8..545a72a 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -78,7 +78,7 @@ static u32 get_ccsidr(u32 csselr)
  * See note at ARMv7 ARM B1.14.4 (TL;DR: S/W ops are not easily virtualized).
  */
 static bool access_dcsw(struct kvm_vcpu *vcpu,
-			const struct sys_reg_params *p,
+			struct sys_reg_params *p,
 			const struct sys_reg_desc *r)
 {
 	if (!p->is_write)
@@ -94,7 +94,7 @@ static bool access_dcsw(struct kvm_vcpu *vcpu,
  * sys_regs and leave it in complete control of the caches.
  */
 static bool access_vm_reg(struct kvm_vcpu *vcpu,
-			  const struct sys_reg_params *p,
+			  struct sys_reg_params *p,
 			  const struct sys_reg_desc *r)
 {
 	unsigned long val;
@@ -122,7 +122,7 @@ static bool access_vm_reg(struct kvm_vcpu *vcpu,
  * for both AArch64 and AArch32 accesses.
  */
 static bool access_gic_sgi(struct kvm_vcpu *vcpu,
-			   const struct sys_reg_params *p,
+			   struct sys_reg_params *p,
 			   const struct sys_reg_desc *r)
 {
 	u64 val;
@@ -137,7 +137,7 @@ static bool access_gic_sgi(struct kvm_vcpu *vcpu,
 }
 
 static bool trap_raz_wi(struct kvm_vcpu *vcpu,
-			const struct sys_reg_params *p,
+			struct sys_reg_params *p,
 			const struct sys_reg_desc *r)
 {
 	if (p->is_write)
@@ -147,7 +147,7 @@ static bool trap_raz_wi(struct kvm_vcpu *vcpu,
 }
 
 static bool trap_oslsr_el1(struct kvm_vcpu *vcpu,
-			   const struct sys_reg_params *p,
+			   struct sys_reg_params *p,
 			   const struct sys_reg_desc *r)
 {
 	if (p->is_write) {
@@ -159,7 +159,7 @@ static bool trap_oslsr_el1(struct kvm_vcpu *vcpu,
 }
 
 static bool trap_dbgauthstatus_el1(struct kvm_vcpu *vcpu,
-				   const struct sys_reg_params *p,
+				   struct sys_reg_params *p,
 				   const struct sys_reg_desc *r)
 {
 	if (p->is_write) {
@@ -200,7 +200,7 @@ static bool trap_dbgauthstatus_el1(struct kvm_vcpu *vcpu,
  *   now use the debug registers.
  */
 static bool trap_debug_regs(struct kvm_vcpu *vcpu,
-			    const struct sys_reg_params *p,
+			    struct sys_reg_params *p,
 			    const struct sys_reg_desc *r)
 {
 	if (p->is_write) {
@@ -225,7 +225,7 @@ static bool trap_debug_regs(struct kvm_vcpu *vcpu,
  * hyp.S code switches between host and guest values in future.
  */
 static inline void reg_to_dbg(struct kvm_vcpu *vcpu,
-			      const struct sys_reg_params *p,
+			      struct sys_reg_params *p,
 			      u64 *dbg_reg)
 {
 	u64 val = *vcpu_reg(vcpu, p->Rt);
@@ -240,7 +240,7 @@ static inline void reg_to_dbg(struct kvm_vcpu *vcpu,
 }
 
 static inline void dbg_to_reg(struct kvm_vcpu *vcpu,
-			      const struct sys_reg_params *p,
+			      struct sys_reg_params *p,
 			      u64 *dbg_reg)
 {
 	u64 val = *dbg_reg;
@@ -252,7 +252,7 @@ static inline void dbg_to_reg(struct kvm_vcpu *vcpu,
 }
 
 static inline bool trap_bvr(struct kvm_vcpu *vcpu,
-			    const struct sys_reg_params *p,
+			    struct sys_reg_params *p,
 			    const struct sys_reg_desc *rd)
 {
 	u64 *dbg_reg = &vcpu->arch.vcpu_debug_state.dbg_bvr[rd->reg];
@@ -294,7 +294,7 @@ static inline void reset_bvr(struct kvm_vcpu *vcpu,
 }
 
 static inline bool trap_bcr(struct kvm_vcpu *vcpu,
-			    const struct sys_reg_params *p,
+			    struct sys_reg_params *p,
 			    const struct sys_reg_desc *rd)
 {
 	u64 *dbg_reg = &vcpu->arch.vcpu_debug_state.dbg_bcr[rd->reg];
@@ -337,7 +337,7 @@ static inline void reset_bcr(struct kvm_vcpu *vcpu,
 }
 
 static inline bool trap_wvr(struct kvm_vcpu *vcpu,
-			    const struct sys_reg_params *p,
+			    struct sys_reg_params *p,
 			    const struct sys_reg_desc *rd)
 {
 	u64 *dbg_reg = &vcpu->arch.vcpu_debug_state.dbg_wvr[rd->reg];
@@ -380,7 +380,7 @@ static inline void reset_wvr(struct kvm_vcpu *vcpu,
 }
 
 static inline bool trap_wcr(struct kvm_vcpu *vcpu,
-			    const struct sys_reg_params *p,
+			    struct sys_reg_params *p,
 			    const struct sys_reg_desc *rd)
 {
 	u64 *dbg_reg = &vcpu->arch.vcpu_debug_state.dbg_wcr[rd->reg];
@@ -687,7 +687,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 };
 
 static bool trap_dbgidr(struct kvm_vcpu *vcpu,
-			const struct sys_reg_params *p,
+			struct sys_reg_params *p,
 			const struct sys_reg_desc *r)
 {
 	if (p->is_write) {
@@ -706,7 +706,7 @@ static bool trap_dbgidr(struct kvm_vcpu *vcpu,
 }
 
 static bool trap_debug32(struct kvm_vcpu *vcpu,
-			 const struct sys_reg_params *p,
+			 struct sys_reg_params *p,
 			 const struct sys_reg_desc *r)
 {
 	if (p->is_write) {
@@ -731,7 +731,7 @@ static bool trap_debug32(struct kvm_vcpu *vcpu,
  */
 
 static inline bool trap_xvr(struct kvm_vcpu *vcpu,
-			    const struct sys_reg_params *p,
+			    struct sys_reg_params *p,
 			    const struct sys_reg_desc *rd)
 {
 	u64 *dbg_reg = &vcpu->arch.vcpu_debug_state.dbg_bvr[rd->reg];
@@ -991,7 +991,7 @@ int kvm_handle_cp14_load_store(struct kvm_vcpu *vcpu, struct kvm_run *run)
  * Return 0 if the access has been handled, and -1 if not.
  */
 static int emulate_cp(struct kvm_vcpu *vcpu,
-		      const struct sys_reg_params *params,
+		      struct sys_reg_params *params,
 		      const struct sys_reg_desc *table,
 		      size_t num)
 {
@@ -1175,7 +1175,7 @@ int kvm_handle_cp14_32(struct kvm_vcpu *vcpu, struct kvm_run *run)
 }
 
 static int emulate_sys_reg(struct kvm_vcpu *vcpu,
-			   const struct sys_reg_params *params)
+			   struct sys_reg_params *params)
 {
 	size_t num;
 	const struct sys_reg_desc *table, *r;
diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
index eaa324e..953abfc 100644
--- a/arch/arm64/kvm/sys_regs.h
+++ b/arch/arm64/kvm/sys_regs.h
@@ -44,7 +44,7 @@ struct sys_reg_desc {
 
 	/* Trapped access from guest, if non-NULL. */
 	bool (*access)(struct kvm_vcpu *,
-		       const struct sys_reg_params *,
+		       struct sys_reg_params *,
 		       const struct sys_reg_desc *);
 
 	/* Initialization for vcpu. */
@@ -77,7 +77,7 @@ static inline bool ignore_write(struct kvm_vcpu *vcpu,
 }
 
 static inline bool read_zero(struct kvm_vcpu *vcpu,
-			     const struct sys_reg_params *p)
+			     struct sys_reg_params *p)
 {
 	*vcpu_reg(vcpu, p->Rt) = 0;
 	return true;
diff --git a/arch/arm64/kvm/sys_regs_generic_v8.c b/arch/arm64/kvm/sys_regs_generic_v8.c
index 1e45768..ccd3e35 100644
--- a/arch/arm64/kvm/sys_regs_generic_v8.c
+++ b/arch/arm64/kvm/sys_regs_generic_v8.c
@@ -31,7 +31,7 @@
 #include "sys_regs.h"
 
 static bool access_actlr(struct kvm_vcpu *vcpu,
-			 const struct sys_reg_params *p,
+			 struct sys_reg_params *p,
 			 const struct sys_reg_desc *r)
 {
 	if (p->is_write)
-- 
2.4.4
