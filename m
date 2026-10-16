Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9960C4F7CB4
	for <kvmarm@lists.linux.dev>; Fri, 16 Oct 2026 15:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792165269; cv=none; b=YLFsmHqpqcAFrDmm/KclLIeEYfWrlMPOKZBKG45SeIepX289pnLvVMwbBgne7WS8J3CNaaecnMpH2ABEHT36NzYl4xaCAwP3hGHCk8MsW7KawdQk7Gm/h8wooXUk56hqRW/w3xVmkiG+SEgAlUYULNyDDJs22Xe63ixMFPKYKWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792165269; c=relaxed/simple;
	bh=+0LfY6TvBlBDuwhIKQfCKpedRgZWycFlJlT0dHTl6ik=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nBEA3RplJA8f5wIjD5RGBZpujRDGOoOwpd3/wz5eliJgIA+sioUyfxpSojbSflnbyNd/OgKY9EGjTEW1i9GNYVYhO042rIzZnk0T9tIeaDyjae0ZuFZOWzaf2wQX3Z3B3t9ECt0WUCH+Iu8EM65HFDqt2JsrAvAXZmaQWgnJHIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=MZsOh8eH; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="MZsOh8eH"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E48BE143D;
	Fri, 16 Oct 2026 08:41:04 -0700 (PDT)
Received: from e133894.cambridge.arm.com (e133894.arm.com [10.2.80.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EEE3A3F673;
	Fri, 16 Oct 2026 08:41:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1792165268; bh=+0LfY6TvBlBDuwhIKQfCKpedRgZWycFlJlT0dHTl6ik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MZsOh8eHIXivssFQddq4fmxwYc4cAnsFWxXEcXF2ZzdHXKZHx2VbkpbRba1UUB+Ot
	 M9lyow+CdYK2CXffByrjwLUe5o/hf/Z10ro65egdwQYa/ANxjrP+D5p6A3+Ud24/t0
	 RC8xbov/2YOsx7lt8fqVmPxCFxSM4fE+o+tzewxk=
From: Sascha Bischoff <sascha.bischoff@arm.com>
To: will@kernel.org,
	julien.thierry.kdev@gmail.com
Cc: maz@kernel.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	timothy.hayes@arm.com,
	Peter Maydell <peter.maydell@linaro.org>
Subject: [PATCH kvmtool v3 10/21] arm64: Describe timer PPIs for GICv5
Date: Fri, 16 Oct 2026 16:39:28 +0100
Message-Id: <20261016153939.913764-11-sascha.bischoff@arm.com>
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

GICv5 DT specifiers use absolute PPI numbers due to having separate
namespaces for the different interrupt types. Keep the existing
GICv2/v3 specifiers by subtracting the legacy PPI base for those
irqchips.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arm64/timer.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/arm64/timer.c b/arm64/timer.c
index 2ac6144f..b791956b 100644
--- a/arm64/timer.c
+++ b/arm64/timer.c
@@ -9,16 +9,31 @@ void timer__generate_fdt_nodes(void *fdt, struct kvm *kvm)
 {
 	const char compatible[] = "arm,armv8-timer\0arm,armv7-timer";
 	u32 cpu_mask = gic__get_fdt_irq_cpumask(kvm);
-	int irqs[5] = {13, 14, 11, 10, 12};
+	const int irqs[5] = { 29, 30, 27, 26, 28 };
 	int nr = ARRAY_SIZE(irqs);
 	u32 irq_prop[nr * 3];
+	u32 type;
+	int offset;
 
 	if (!kvm->cfg.arch.nested_virt)
 		nr--;
 
+	/*
+	 * For GICv5 guests, we can directly use the IRQs above in the FDT, but
+	 * for older GICs one specifies the offset into the PPI range, which is
+	 * adjusted using the offset below.
+	 */
+	if (gic__is_v5()) {
+		type = GICV5_IRQ_TYPE_PPI;
+		offset = 0;
+	} else {
+		type = GIC_FDT_IRQ_TYPE_PPI;
+		offset = -16;
+	}
+
 	for (int i = 0; i < nr; i++) {
-		irq_prop[i * 3 + 0] = cpu_to_fdt32(GIC_FDT_IRQ_TYPE_PPI);
-		irq_prop[i * 3 + 1] = cpu_to_fdt32(irqs[i]);
+		irq_prop[i * 3 + 0] = cpu_to_fdt32(type);
+		irq_prop[i * 3 + 1] = cpu_to_fdt32(irqs[i] + offset);
 		irq_prop[i * 3 + 2] = cpu_to_fdt32(cpu_mask | IRQ_TYPE_LEVEL_LOW);
 	}
 
-- 
2.34.1

