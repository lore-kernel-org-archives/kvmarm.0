From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2 8/9] arm: KVM: Make unexpected register accesses inject an
 undef
Date: Mon, 27 Mar 2017 17:03:44 +0100
Message-ID: <20170327160345.12402-9-marc.zyngier@arm.com>
References: <20170327160345.12402-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CA1C640C22
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Mar 2017 12:02:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HXzJmsAHJ4Bi for <kvmarm@lists.cs.columbia.edu>;
 Mon, 27 Mar 2017 12:02:16 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C9A1140C5B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Mar 2017 12:02:11 -0400 (EDT)
In-Reply-To: <20170327160345.12402-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Shannon Zhao <shannon.zhao@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

Reads from write-only system registers are generally confined to
EL1 and not propagated to EL2 (that's what the architecture
mantates). In order to be sure that we have a sane behaviour
even in the unlikely event that we have a broken system, we still
handle it in KVM. Same goes for write to RO registers.

In that case, let's inject an undef into the guest.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/kvm/coproc.c | 18 ++++++++++++++++++
 arch/arm/kvm/coproc.h | 18 ------------------
 2 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/arch/arm/kvm/coproc.c b/arch/arm/kvm/coproc.c
index 3e5e4194ef86..519aac12b365 100644
--- a/arch/arm/kvm/coproc.c
+++ b/arch/arm/kvm/coproc.c
@@ -40,6 +40,24 @@
  * Co-processor emulation
  *****************************************************************************/
 
+static bool write_to_read_only(struct kvm_vcpu *vcpu,
+			       const struct coproc_params *params)
+{
+	WARN_ONCE(1, "CP15 write to read-only register\n");
+	print_cp_instr(params);
+	kvm_inject_undefined(vcpu);
+	return false;
+}
+
+static bool read_from_write_only(struct kvm_vcpu *vcpu,
+				 const struct coproc_params *params)
+{
+	WARN_ONCE(1, "CP15 read to write-only register\n");
+	print_cp_instr(params);
+	kvm_inject_undefined(vcpu);
+	return false;
+}
+
 /* 3 bits per cache level, as per CLIDR, but non-existent caches always 0 */
 static u32 cache_levels;
 
diff --git a/arch/arm/kvm/coproc.h b/arch/arm/kvm/coproc.h
index eef1759c2b65..3a41b7d1eb86 100644
--- a/arch/arm/kvm/coproc.h
+++ b/arch/arm/kvm/coproc.h
@@ -81,24 +81,6 @@ static inline bool read_zero(struct kvm_vcpu *vcpu,
 	return true;
 }
 
-static inline bool write_to_read_only(struct kvm_vcpu *vcpu,
-				      const struct coproc_params *params)
-{
-	kvm_debug("CP15 write to read-only register at: %08lx\n",
-		  *vcpu_pc(vcpu));
-	print_cp_instr(params);
-	return false;
-}
-
-static inline bool read_from_write_only(struct kvm_vcpu *vcpu,
-					const struct coproc_params *params)
-{
-	kvm_debug("CP15 read to write-only register at: %08lx\n",
-		  *vcpu_pc(vcpu));
-	print_cp_instr(params);
-	return false;
-}
-
 /* Reset functions */
 static inline void reset_unknown(struct kvm_vcpu *vcpu,
 				 const struct coproc_reg *r)
-- 
2.11.0
