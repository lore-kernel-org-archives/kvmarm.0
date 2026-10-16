Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 649E94E0B9C
	for <kvmarm@lists.linux.dev>; Fri, 16 Oct 2026 15:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792165303; cv=none; b=J5lV0fDksRtZofQlXoZ5Ku4p5yPQEiwRr7kA+pfq5cuHXhKOUshSg91W3Bs91+A6GuVU+rES/Ew/rBi28tgSLTrlckPN4gXtxMqkKj5F6rN8N4gcDO/xG76bjf7HDlflvmOpWT/S7BofUCgPQNseAKpSY3on9zqvIcC9eOW4viE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792165303; c=relaxed/simple;
	bh=nO/Nj2YNAFzZ5QpEDlII32D3CjaDCym3GHvOEVdEmOo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=NwSv7+Of4TE/iGfoP90AQMrn9ztTavDrvBiv643HRQBBCWBt/57CIOXyqb+DqmLu+6sk1k9McVYCOGjhUBpLdee63RXxANGCG+bFBYRMGpexqtpiCWXYQHwsmajW1Emop2nf16Z6ZvJ2qIru5rgaE4DhNrOvHolUmRK09voXaAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=gZnVu4ev; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="gZnVu4ev"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 77576143D;
	Fri, 16 Oct 2026 08:41:37 -0700 (PDT)
Received: from e133894.cambridge.arm.com (e133894.arm.com [10.2.80.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 878673F673;
	Fri, 16 Oct 2026 08:41:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1792165300; bh=nO/Nj2YNAFzZ5QpEDlII32D3CjaDCym3GHvOEVdEmOo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gZnVu4evc7Y3sHnBFMjtw/xGC3/YM3qYOWBE5VHOIaUhJ3ZnqaXKkhavA6YNoTpui
	 slDJVtSfALxrt8p+gnb6vcLNnbwj5ZlCM94NqUf8NqH4+97ENff278Dr5gsayOQ0qb
	 N2pbUecd8Ow3o6gkGk377MNVmC/giWNeY9J4+unU=
From: Sascha Bischoff <sascha.bischoff@arm.com>
To: will@kernel.org,
	julien.thierry.kdev@gmail.com
Cc: maz@kernel.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	timothy.hayes@arm.com,
	Peter Maydell <peter.maydell@linaro.org>
Subject: [PATCH kvmtool v3 14/21] arm64: Generate GICv5 SPI specifiers for platform devices
Date: Fri, 16 Oct 2026 16:39:32 +0100
Message-Id: <20261016153939.913764-15-sascha.bischoff@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261016153939.913764-1-sascha.bischoff@arm.com>
References: <20261016153939.913764-1-sascha.bischoff@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use the GICv5 interrupt type and absolute SPI number for platform
devices. Preserve the legacy GICv2/v3 DT encoding for other VMs.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arm64/fdt.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/arm64/fdt.c b/arm64/fdt.c
index d4cbcff3..e9447b3f 100644
--- a/arm64/fdt.c
+++ b/arm64/fdt.c
@@ -64,11 +64,20 @@ static void generate_cpu_nodes(void *fdt, struct kvm *kvm)
 
 static void generate_irq_prop(void *fdt, u8 irq, enum irq_type irq_type)
 {
-	u32 irq_prop[] = {
-		cpu_to_fdt32(GIC_FDT_IRQ_TYPE_SPI),
-		cpu_to_fdt32(irq - GIC_SPI_IRQ_BASE),
-		cpu_to_fdt32(irq_type)
-	};
+	u32 irq_prop[3];
+	u32 type, intid;
+
+	if (gic__is_v5()) {
+		type = GICV5_IRQ_TYPE_SPI;
+		intid = irq;
+	} else {
+		type = GIC_FDT_IRQ_TYPE_SPI;
+		intid = irq - GIC_SPI_IRQ_BASE;
+	}
+
+	irq_prop[0] = cpu_to_fdt32(type);
+	irq_prop[1] = cpu_to_fdt32(intid);
+	irq_prop[2] = cpu_to_fdt32(irq_type);
 
 	_FDT(fdt_property(fdt, "interrupts", irq_prop, sizeof(irq_prop)));
 }
-- 
2.34.1

