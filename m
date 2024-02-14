Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1330E535D6
	for <kvmarm@lists.linux.dev>; Wed, 14 Feb 2024 13:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707916715; cv=none; b=Ob/dQoVHOqIuFKdzGDCW/qvwrcw7DUQ6YGYS/RxEVu39oE7ObjIQYJi5dciREosjowVPcMlk1Ct43jYfJTo9o7XsP0W0QCbhlNzHp07/9JWHx4PRgRCsHTPzayOOfhmzTnEqIWx19Lrq0JFbZNafnfnPHJOuqABIL3Z5+QXDIik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707916715; c=relaxed/simple;
	bh=OHKwGkcUNa8hZUYF/koFF9Wff87/WyQ3U9RNP5c77Pk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rYp5OQye73xCysBCtRY/xOWD6rrlE0mJ74EFjNQ+y0WvJmZTnSijxoll9opOJOnOnL7C8SbG6+GxRKxf0KOTTHAsZRVk6lxFDlokFahjqYe0qcSAfxr68fAMiOS94y8e5nsYo+MvWRNHjoKCERUKcfc/pOtyge2QW5LDd1vL7cM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uYa7Yqqe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uYa7Yqqe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8A40C433F1;
	Wed, 14 Feb 2024 13:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707916714;
	bh=OHKwGkcUNa8hZUYF/koFF9Wff87/WyQ3U9RNP5c77Pk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uYa7YqqeXB+lTb4hl5TRk2G2t8KHikfFgfqbpO2Xap1he/eFqo6+p3W1XVwqLrJFo
	 h3G7h1UQ9zc+BWDs1KdQHZHjle477xrnGCpUNxCDs4rhWG1/W6P8uVUvho9qs+X/uT
	 1lNPCLn9VRMMTLdMuZsymCyWjxDQz4j2m+vB2O1mzKypz26aKfd0D2lcWOKNwsw2HT
	 T/paOjiH8RdDX4mWqTTIvl8IpFMXtJaMDS+I3F2WXj4sa/Ob/xxMn6olCF4yBQ2Jyf
	 9WBHt1PdsqpxDLXBR5r+g9QU6nr4dwNpVr/FI6qfOj/WZMMzTAwcPytlOJwTolTZEB
	 9xMSL6Z8sxuMg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1raF9k-00394l-Ou;
	Wed, 14 Feb 2024 13:18:32 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH v4 10/26] KVM: arm64: nv: Turn encoding ranges into discrete XArray stores
Date: Wed, 14 Feb 2024 13:18:11 +0000
Message-Id: <20240214131827.2856277-11-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240214131827.2856277-1-maz@kernel.org>
References: <20240214131827.2856277-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, joey.gouly@arm.com, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

In order to be able to store different values for member of an
encoding range, replace xa_store_range() calls with discrete
xa_store() calls and an encoding iterator.

We end-up using a bit more memory, but we gain some flexibility
that we will make use of shortly.

Take this opportunity to tidy up the error handling path.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Joey Gouly <joey.gouly@arm.com>
---
 arch/arm64/kvm/emulate-nested.c | 49 ++++++++++++++++++++++++---------
 1 file changed, 36 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index ef46c2e45307..42f5b4483c80 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -1757,6 +1757,28 @@ static __init void print_nv_trap_error(const struct encoding_to_trap_config *tc,
 		err);
 }
 
+static u32 encoding_next(u32 encoding)
+{
+	u8 op0, op1, crn, crm, op2;
+
+	op0 = sys_reg_Op0(encoding);
+	op1 = sys_reg_Op1(encoding);
+	crn = sys_reg_CRn(encoding);
+	crm = sys_reg_CRm(encoding);
+	op2 = sys_reg_Op2(encoding);
+
+	if (op2 < Op2_mask)
+		return sys_reg(op0, op1, crn, crm, op2 + 1);
+	if (crm < CRm_mask)
+		return sys_reg(op0, op1, crn, crm + 1, 0);
+	if (crn < CRn_mask)
+		return sys_reg(op0, op1, crn + 1, 0, 0);
+	if (op1 < Op1_mask)
+		return sys_reg(op0, op1 + 1, 0, 0, 0);
+
+	return sys_reg(op0 + 1, 0, 0, 0, 0);
+}
+
 int __init populate_nv_trap_config(void)
 {
 	int ret = 0;
@@ -1775,23 +1797,18 @@ int __init populate_nv_trap_config(void)
 			ret = -EINVAL;
 		}
 
-		if (cgt->encoding != cgt->end) {
-			prev = xa_store_range(&sr_forward_xa,
-					      cgt->encoding, cgt->end,
-					      xa_mk_value(cgt->tc.val),
-					      GFP_KERNEL);
-		} else {
-			prev = xa_store(&sr_forward_xa, cgt->encoding,
+		for (u32 enc = cgt->encoding; enc <= cgt->end; enc = encoding_next(enc)) {
+			prev = xa_store(&sr_forward_xa, enc,
 					xa_mk_value(cgt->tc.val), GFP_KERNEL);
 			if (prev && !xa_is_err(prev)) {
 				ret = -EINVAL;
 				print_nv_trap_error(cgt, "Duplicate CGT", ret);
 			}
-		}
 
-		if (xa_is_err(prev)) {
-			ret = xa_err(prev);
-			print_nv_trap_error(cgt, "Failed CGT insertion", ret);
+			if (xa_is_err(prev)) {
+				ret = xa_err(prev);
+				print_nv_trap_error(cgt, "Failed CGT insertion", ret);
+			}
 		}
 	}
 
@@ -1804,6 +1821,7 @@ int __init populate_nv_trap_config(void)
 	for (int i = 0; i < ARRAY_SIZE(encoding_to_fgt); i++) {
 		const struct encoding_to_trap_config *fgt = &encoding_to_fgt[i];
 		union trap_config tc;
+		void *prev;
 
 		if (fgt->tc.fgt >= __NR_FGT_GROUP_IDS__) {
 			ret = -EINVAL;
@@ -1818,8 +1836,13 @@ int __init populate_nv_trap_config(void)
 		}
 
 		tc.val |= fgt->tc.val;
-		xa_store(&sr_forward_xa, fgt->encoding,
-			 xa_mk_value(tc.val), GFP_KERNEL);
+		prev = xa_store(&sr_forward_xa, fgt->encoding,
+				xa_mk_value(tc.val), GFP_KERNEL);
+
+		if (xa_is_err(prev)) {
+			ret = xa_err(prev);
+			print_nv_trap_error(fgt, "Failed FGT insertion", ret);
+		}
 	}
 
 	kvm_info("nv: %ld fine grained trap handlers\n",
-- 
2.39.2

