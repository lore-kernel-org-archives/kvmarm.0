From: vijay.kilari@gmail.com
Subject: [PATCH v9 10/11] arm: coproc: Introduce find_coproc_reg_by_id()
Date: Wed, 23 Nov 2016 18:31:57 +0530
Message-ID: <1479906118-15832-11-git-send-email-vijay.kilari@gmail.com>
References: <1479906118-15832-1-git-send-email-vijay.kilari@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 04E7540A7F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Nov 2016 08:02:05 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wE-1fJbTQ3dX for <kvmarm@lists.cs.columbia.edu>;
 Wed, 23 Nov 2016 08:01:59 -0500 (EST)
Received: from mail-pf0-f195.google.com (mail-pf0-f195.google.com
 [209.85.192.195])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4AA1340A7E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Nov 2016 08:01:58 -0500 (EST)
Received: by mail-pf0-f195.google.com with SMTP id i88so699146pfk.2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Nov 2016 05:02:38 -0800 (PST)
In-Reply-To: <1479906118-15832-1-git-send-email-vijay.kilari@gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: marc.zyngier@arm.com, christoffer.dall@linaro.org, peter.maydell@linaro.org
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Vijaya Kumar K <Vijaya.Kumar@cavium.com>
List-Id: kvmarm@lists.cs.columbia.edu

From: Vijaya Kumar K <Vijaya.Kumar@cavium.com>

To access CPU interface access in AArch32 mode, we need to
perform coproc_reg table lookup. For this introduce
find_coproc_reg_by_id() and export.

Also use this function internally in coproc.c wherever
required.

Signed-off-by: Vijaya Kumar K <Vijaya.Kumar@cavium.com>
---
 arch/arm/kvm/coproc.c | 22 +++++++++++++++-------
 arch/arm/kvm/coproc.h |  4 ++++
 2 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/arch/arm/kvm/coproc.c b/arch/arm/kvm/coproc.c
index 5753926..7d05700 100644
--- a/arch/arm/kvm/coproc.c
+++ b/arch/arm/kvm/coproc.c
@@ -616,6 +616,17 @@ static bool index_to_params(u64 id, struct coproc_params *params)
 	}
 }
 
+const struct coproc_reg *
+find_coproc_reg_by_id(u64 id, struct coproc_params *params,
+		      const struct coproc_reg table[],
+		      unsigned int num)
+{
+	if (!index_to_params(id, params))
+		return NULL;
+
+	return find_reg(params, table, num);
+}
+
 /* Decode an index value, and find the cp15 coproc_reg entry. */
 static const struct coproc_reg *index_to_coproc_reg(struct kvm_vcpu *vcpu,
 						    u64 id)
@@ -742,10 +753,8 @@ static int get_invariant_cp15(u64 id, void __user *uaddr)
 	const struct coproc_reg *r;
 	int ret;
 
-	if (!index_to_params(id, &params))
-		return -ENOENT;
-
-	r = find_reg(&params, invariant_cp15, ARRAY_SIZE(invariant_cp15));
+	r = find_coproc_reg_by_id(id, &params, invariant_cp15,
+				  ARRAY_SIZE(invariant_cp15));
 	if (!r)
 		return -ENOENT;
 
@@ -767,9 +776,8 @@ static int set_invariant_cp15(u64 id, void __user *uaddr)
 	int err;
 	u64 val;
 
-	if (!index_to_params(id, &params))
-		return -ENOENT;
-	r = find_reg(&params, invariant_cp15, ARRAY_SIZE(invariant_cp15));
+	r = find_coproc_reg_by_id(id, &params, invariant_cp15,
+				  ARRAY_SIZE(invariant_cp15));
 	if (!r)
 		return -ENOENT;
 
diff --git a/arch/arm/kvm/coproc.h b/arch/arm/kvm/coproc.h
index bbeff2a..2accd9d 100644
--- a/arch/arm/kvm/coproc.h
+++ b/arch/arm/kvm/coproc.h
@@ -157,4 +157,8 @@ bool access_vm_reg(struct kvm_vcpu *vcpu,
 		   struct coproc_params *p,
 		   const struct coproc_reg *r);
 
+const struct coproc_reg *
+find_coproc_reg_by_id(u64 id, struct coproc_params *params,
+		      const struct coproc_reg table[],
+		      unsigned int num);
 #endif /* __ARM_KVM_COPROC_LOCAL_H__ */
-- 
1.9.1
