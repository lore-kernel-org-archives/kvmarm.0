From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2 04/17] ARM: KVM: Rename struct coproc_reg::is_64 to is_64bit
Date: Wed, 17 Feb 2016 16:40:36 +0000
Message-ID: <1455727249-24752-5-git-send-email-marc.zyngier@arm.com>
References: <1455727249-24752-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CFA134998C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Feb 2016 11:34:51 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nurmm96r6GJJ for <kvmarm@lists.cs.columbia.edu>;
 Wed, 17 Feb 2016 11:34:49 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 626EF49947
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Feb 2016 11:34:48 -0500 (EST)
In-Reply-To: <1455727249-24752-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

As we're going to play some tricks on the struct coproc_reg,
make sure its 64bit indicator field matches that of coproc_params.

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/kvm/coproc.c | 4 ++--
 arch/arm/kvm/coproc.h | 8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm/kvm/coproc.c b/arch/arm/kvm/coproc.c
index 03f5d14..2a67f00 100644
--- a/arch/arm/kvm/coproc.c
+++ b/arch/arm/kvm/coproc.c
@@ -423,7 +423,7 @@ static const struct coproc_reg *find_reg(const struct coproc_params *params,
 	for (i = 0; i < num; i++) {
 		const struct coproc_reg *r = &table[i];
 
-		if (params->is_64bit != r->is_64)
+		if (params->is_64bit != r->is_64bit)
 			continue;
 		if (params->CRn != r->CRn)
 			continue;
@@ -1105,7 +1105,7 @@ static int write_demux_regids(u64 __user *uindices)
 static u64 cp15_to_index(const struct coproc_reg *reg)
 {
 	u64 val = KVM_REG_ARM | (15 << KVM_REG_ARM_COPROC_SHIFT);
-	if (reg->is_64) {
+	if (reg->is_64bit) {
 		val |= KVM_REG_SIZE_U64;
 		val |= (reg->Op1 << KVM_REG_ARM_OPC1_SHIFT);
 		/*
diff --git a/arch/arm/kvm/coproc.h b/arch/arm/kvm/coproc.h
index 88d24a3..5acd097 100644
--- a/arch/arm/kvm/coproc.h
+++ b/arch/arm/kvm/coproc.h
@@ -37,7 +37,7 @@ struct coproc_reg {
 	unsigned long Op1;
 	unsigned long Op2;
 
-	bool is_64;
+	bool is_64bit;
 
 	/* Trapped access from guest, if non-NULL. */
 	bool (*access)(struct kvm_vcpu *,
@@ -141,7 +141,7 @@ static inline int cmp_reg(const struct coproc_reg *i1,
 		return i1->Op1 - i2->Op1;
 	if (i1->Op2 != i2->Op2)
 		return i1->Op2 - i2->Op2;
-	return i2->is_64 - i1->is_64;
+	return i2->is_64bit - i1->is_64bit;
 }
 
 
@@ -150,8 +150,8 @@ static inline int cmp_reg(const struct coproc_reg *i1,
 #define CRm64(_x)       .CRn = _x, .CRm = 0
 #define Op1(_x) 	.Op1 = _x
 #define Op2(_x) 	.Op2 = _x
-#define is64		.is_64 = true
-#define is32		.is_64 = false
+#define is64		.is_64bit = true
+#define is32		.is_64bit = false
 
 bool access_vm_reg(struct kvm_vcpu *vcpu,
 		   const struct coproc_params *p,
-- 
2.1.4
