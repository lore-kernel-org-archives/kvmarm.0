Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD55E1FAC42
	for <kvmarm@lists.linux.dev>; Fri, 23 Jan 2026 16:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769187066; cv=none; b=PVagB54JQfiDVAhsfKA2PvvXVmDjDJ0kp2JelD4zClI6ANd2O/S5LOP6huyl3C5i6W381da7ivRObfkHTOFsqLzPH/8OrioQPbO4TXTgg5t8LdBvweP3sgXaxKFx5VxxTK9omtr6jJTwGdyf52n9md5l9USixR+0CuhPcMTfeTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769187066; c=relaxed/simple;
	bh=wxg5ZBPO5HAXFaDpTGVL3O4DjwEwHXNnvPx24iqgHgU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VzPqHz+QzfQpUvj8SbAk6CkCCcwojZ4cSQIwA5o41QCukjNrDrhGauieJU0D3tWHod/JrOjFCR05b5G/7SLMFxzbWaUiPqaDYThKViTtDl9WApPCd3daaN9lukX9uguJQavPDquN33B4+N7lwZBW842THsnurUoqyP/jQkdjDXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 70F551515;
	Fri, 23 Jan 2026 08:50:57 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8DFA33F694;
	Fri, 23 Jan 2026 08:51:02 -0800 (PST)
From: Joey Gouly <joey.gouly@arm.com>
To: linux-arm-kernel@lists.infradead.org
Cc: alexandru.elisei@arm.com,
	andrew.jones@linux.dev,
	eric.auger@redhat.com,
	joey.gouly@arm.com,
	maz@kernel.org,
	kvmarm@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [kvm-unit-tests PATCH v6 01/14] arm64: fix overflow in gic-v2 initialisation
Date: Fri, 23 Jan 2026 16:50:40 +0000
Message-Id: <20260123165053.2250754-2-joey.gouly@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260123165053.2250754-1-joey.gouly@arm.com>
References: <20260123165053.2250754-1-joey.gouly@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The gic-v2 DT bindings can have up to 4 registers, GIC dist base, GIC cpu
interface base, vGIC dist base and vGIC cpu interface base.

QEMU when booting at EL1 fills out the first 2, when booting at EL2 it fills
out all 4 reg values in the DT.

However `struct gicv2_data` only contains fields for 2 bases, causing the loop
over GICV3_NR_REDISTS to write to random areas of memory after `gicv2_data`.

Fix this by only looping if we know it's a gic-v3, and only reading 2 bases if
it's a gic-v2.

Fixes: a5a2d35cba2e ("arm/arm64: gicv3: support up to 8 redistributor regions")
Signed-off-by: Joey Gouly <joey.gouly@arm.com>
---
 lib/arm/gic.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/lib/arm/gic.c b/lib/arm/gic.c
index af43a96d..1b2dc101 100644
--- a/lib/arm/gic.c
+++ b/lib/arm/gic.c
@@ -69,6 +69,16 @@ gic_get_dt_bases(const char *compatible, void **base1, void **base2, void **base
 	assert(ret == 0);
 	*base1 = ioremap(reg.addr, reg.size);
 
+	if (!base3) {
+		assert(!strcmp(compatible, "arm,cortex-a15-gic"));
+		ret = dt_pbus_translate(&gic, 1, &reg);
+		assert(ret == 0);
+		*base2 = ioremap(reg.addr, reg.size);
+		return true;
+	}
+
+	assert(!strcmp(compatible, "arm,gic-v3"));
+
 	for (i = 0; i < GICV3_NR_REDISTS; ++i) {
 		ret = dt_pbus_translate(&gic, i + 1, &reg);
 		if (ret == -FDT_ERR_NOTFOUND)
@@ -77,13 +87,6 @@ gic_get_dt_bases(const char *compatible, void **base1, void **base2, void **base
 		base2[i] = ioremap(reg.addr, reg.size);
 	}
 
-	if (!base3) {
-		assert(!strcmp(compatible, "arm,cortex-a15-gic"));
-		return true;
-	}
-
-	assert(!strcmp(compatible, "arm,gic-v3"));
-
 	dt_for_each_subnode(node, subnode) {
 		const struct fdt_property *prop;
 
-- 
2.25.1

