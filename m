Received: from mta1.migadu.com (out-82.mta1.migadu.com [95.215.58.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B75D38BF75
	for <kvmarm@lists.linux.dev>; Tue, 25 Aug 2026 16:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.82
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787676154; cv=none; b=i7+6iSKcqTiKvZ55I4S5U/3zVb7u+mIHXMUeLfyUVVf9MaSQTt0AM9QMlolXWYgzAUdgQFE4GuPHLB/IG6mtGB+1odrJq6W+Qs/L4S+kKguwjSY0uZYfIHSQcyB67WvjRpU1ywkjltHiKnBkCvBdPPRlZMwRLh053TbHOd0mbtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787676154; c=relaxed/simple;
	bh=zQU2cneHWYiXgdAM5Ki7+W+91fket5ATQUH8SgIxbj8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=brnCUg+6ei/LhRa8/X/yeSNhn6IYtYHyYEh+NouCD1WFzqJMipEAR1F1eQEvlGu5TCKEQtNXsdSAF9dsa0udBkaCXIyg7eRD8FoSDP/55elYy72hTwUgK71kiwF3322HEEzvjLJHpOR+cU1tDzERP/Hzi8BFVplnzokXY6ORhY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=JeBT/yCI; arc=none smtp.client-ip=95.215.58.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="JeBT/yCI"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=zQU2cneHWYiXgdAM5Ki7+W+91fket5ATQUH8SgIxbj8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787676150; v=1; x=1788280950;
 b=JeBT/yCId6Nw/f6FxMpE+FJ9DvG61j0vYhq4T1ddN5O92skKQ2/Xas5uIh6bqC2269YRGDIT
 OZupAdBGbry7mKjL8YWmjq/L8j1aqi+wyrtFmP1IbnYDhK5fj2ykyIQwdCLagtJvPMpmITRas3k
 KXFYvJXlgUbcfeqFrJybgelk=
X-Envelope-To: kvmarm@lists.linux.dev
Received: from claudy.local (2a01:4b00:ad36:1d00:3a05:25ff:fe33:35a9)
	by smtp.migadu.com with ESMTPS id eb5a6faaae912dd9;
	Tue, 25 Aug 2026 16:42:30 +0000
X-Mizu-Trace-ID: eb5a6faaae912dd9
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Mark Brown <broonie@kernel.org>,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Fuad Tabba <tabba@google.com>
Subject: [PATCH v4 1/2] arm64: Apply overrides to CPU local capabilities
Date: Tue, 25 Aug 2026 17:42:18 +0100
Message-Id: <20260825164219.3347229-2-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260825164219.3347229-1-fuad.tabba@linux.dev>
References: <20260825164219.3347229-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Suzuki K Poulose <suzuki.poulose@arm.com>

If an override has been applied, make sure we apply that for the
secondary CPUs too, to limit the features.

Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/all/afc5bd00-28ca-413b-b047-ee53589c285d@arm.com/
Cc: stable@vger.kernel.org
[Fuad: whitespace and comment fixes]
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kernel/cpufeature.c | 42 +++++++++++++++++++++++++++-------
 1 file changed, 34 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 9a22df0c5120f..88b15b5ef2f7f 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -1232,10 +1232,43 @@ void __init init_cpu_features(struct cpuinfo_arm64 *info)
 		init_cpu_ftr_reg(SYS_GMID_EL1, info->reg_gmid);
 }
 
+/*
+ * Sanitise the register fields to clamp the values to the overrides that
+ * have been applied.
+ */
+static u64 override_cpu_ftr_reg(struct arm64_ftr_reg *reg, u64 val)
+{
+	const struct arm64_ftr_bits *ftrp;
+
+	if (!reg || !reg->override->mask)
+		return val;
+
+	for (ftrp = reg->ftr_bits; ftrp->width; ftrp++) {
+		u64 ftr_mask = arm64_ftr_mask(ftrp);
+		s64 ftr_val, ftr_ovr, ftr_safe;
+
+		/* Skip the fields not overridden */
+		if ((ftr_mask & reg->override->mask) != ftr_mask)
+			continue;
+
+		ftr_val = arm64_ftr_value(ftrp, val);
+		ftr_ovr = arm64_ftr_value(ftrp, reg->override->val);
+		ftr_safe = arm64_ftr_safe_value(ftrp, ftr_ovr, ftr_val);
+
+		if (ftr_safe != ftr_val)
+			val = arm64_ftr_set_value(ftrp, val, ftr_safe);
+	}
+
+	return val;
+}
+
 static void update_cpu_ftr_reg(struct arm64_ftr_reg *reg, u64 new)
 {
 	const struct arm64_ftr_bits *ftrp;
 
+	/* Apply the overrides */
+	new = override_cpu_ftr_reg(reg, new);
+
 	for (ftrp = reg->ftr_bits; ftrp->width; ftrp++) {
 		s64 ftr_cur = arm64_ftr_value(ftrp, reg->sys_val);
 		s64 ftr_new = arm64_ftr_value(ftrp, new);
@@ -1539,7 +1572,6 @@ EXPORT_SYMBOL_GPL(read_sanitised_ftr_reg);
  */
 u64 __read_sysreg_by_encoding(u32 sys_id)
 {
-	struct arm64_ftr_reg *regp;
 	u64 val;
 
 	switch (sys_id) {
@@ -1592,13 +1624,7 @@ u64 __read_sysreg_by_encoding(u32 sys_id)
 		return 0;
 	}
 
-	regp  = get_arm64_ftr_reg(sys_id);
-	if (regp) {
-		val &= ~regp->override->mask;
-		val |= (regp->override->val & regp->override->mask);
-	}
-
-	return val;
+	return override_cpu_ftr_reg(get_arm64_ftr_reg(sys_id), val);
 }
 
 #include <linux/irqchip/arm-gic-v3.h>
-- 
2.39.5

