Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7791C4FE2D4
	for <kvmarm@lists.linux.dev>; Fri, 16 Oct 2026 15:41:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792165262; cv=none; b=Fm5/kYGDNKkLl7mj1YuZ34dxBwK3T4XAM6puqwv08HRz4AJIsD3ZHo9NxeQLGEEUQW8ajK4USv4MxcLDEzbUidW6wLqWTk3a4jIg7jvagz3Zc2lihpZjhnp9QCX2x5uz4959JoUPKyiFRC/H4pukM1Q7hxs4WDeI5DA4tuX21cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792165262; c=relaxed/simple;
	bh=8qMpFw4L+rv+gGuKMndCPMvPj47N3i/09XTDUG+R2cg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hUPXggx4ARc+GSJAMpfEDOXf+f39mZR2audDZmWTCdCQn5ZaGd0zZBUhOx2ckSkBqLPkrFV3nXetTDU95C0dDE+GgL8dloNUgvKrURXxZOnWX3gAXZnT9qQdX1L9vsHoJpA+oC+/kOsiAubSClutkNr+21r7P8qqH3IM8BTG7qE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Ddzh6KM9; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Ddzh6KM9"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B3194143D;
	Fri, 16 Oct 2026 08:40:56 -0700 (PDT)
Received: from e133894.cambridge.arm.com (e133894.arm.com [10.2.80.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 013C33F673;
	Fri, 16 Oct 2026 08:40:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1792165260; bh=8qMpFw4L+rv+gGuKMndCPMvPj47N3i/09XTDUG+R2cg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ddzh6KM9YlehKshfrUns/Moj+sZoeKyMCd4rEwjsESZ0ioLvr7uVVyKWNjJgPY/5X
	 /f2o3jBSFV20JM3xNJ24iQT26Ctb37z6IChO68XMi7hJktusflYDhHtNo4fcDGPlWY
	 YvRgt+MQ3ES4Ia/CtNZyaq+gGTjDfsoP1jIFlOII=
From: Sascha Bischoff <sascha.bischoff@arm.com>
To: will@kernel.org,
	julien.thierry.kdev@gmail.com
Cc: maz@kernel.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	timothy.hayes@arm.com,
	Peter Maydell <peter.maydell@linaro.org>
Subject: [PATCH kvmtool v3 09/21] arm64: Describe the PMU interrupt for GICv5
Date: Fri, 16 Oct 2026 16:39:27 +0100
Message-Id: <20261016153939.913764-10-sascha.bischoff@arm.com>
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

Use the GICv5 PPI specifier in the DT. KVM also expects the PMU IRQ
attribute to contain the GICv5 interrupt type in the upper bits, so
encode it before setting KVM_ARM_VCPU_PMU_V3_IRQ.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arm64/pmu.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/arm64/pmu.c b/arm64/pmu.c
index ef7faca1..bc52d5fc 100644
--- a/arm64/pmu.c
+++ b/arm64/pmu.c
@@ -214,16 +214,22 @@ static int find_pmu(struct kvm *kvm)
 void pmu__generate_fdt_nodes(void *fdt, struct kvm *kvm)
 {
 	const char compatible[] = "arm,armv8-pmuv3";
+	int irq = KVM_ARM_PMUv3_PPI;
+	u32 irq_prop[3];
 	u32 cpu_mask = gic__get_fdt_irq_cpumask(kvm);
-	u32 irq_prop[] = {
-		cpu_to_fdt32(GIC_FDT_IRQ_TYPE_PPI),
-		cpu_to_fdt32(KVM_ARM_PMUv3_PPI - 16),
-		cpu_to_fdt32(cpu_mask | IRQ_TYPE_LEVEL_HIGH),
-	};
 
 	if (!kvm->cfg.arch.has_pmuv3)
 		return;
 
+	if (gic__is_v5()) {
+		irq_prop[0] = cpu_to_fdt32(GICV5_IRQ_TYPE_PPI);
+		irq_prop[1] = cpu_to_fdt32(irq);
+	} else {
+		irq_prop[0] = cpu_to_fdt32(GIC_FDT_IRQ_TYPE_PPI);
+		irq_prop[1] = cpu_to_fdt32(irq - 16);
+	}
+	irq_prop[2] = cpu_to_fdt32(cpu_mask | IRQ_TYPE_LEVEL_HIGH);
+
 	_FDT(fdt_begin_node(fdt, "pmu"));
 	_FDT(fdt_property(fdt, "compatible", compatible, sizeof(compatible)));
 	_FDT(fdt_property(fdt, "interrupts", irq_prop, sizeof(irq_prop)));
@@ -248,6 +254,13 @@ int pmu__init(struct kvm *kvm)
 		}
 	}
 
+	/*
+	 * For GICv5, we must encode the full IntID by adding the type (PPI)
+	 * when setting the PMUIRQ.
+	 */
+	if (gic__is_v5())
+		irq |= GICV5_IRQ_TYPE_PPI << GICV5_IRQ_TYPE_SHIFT;
+
 	for (i = 0; i < kvm->nrcpus; i++) {
 		vcpu = kvm->cpus[i];
 		set_pmu_attr(vcpu, &irq, KVM_ARM_VCPU_PMU_V3_IRQ);
-- 
2.34.1

