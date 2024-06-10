Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34E81156883;
	Mon, 10 Jun 2024 13:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718027044; cv=none; b=KanY+p6Gz9ytjesyXIH/pgoZ27BlR/3qvXHvEo27/psKWtJ8ZTKzfkGZtAgmXRZM5w7KTHUoFrIuMGGBg4M1MAY+xgCBlHKOZMedaIp1NdXbu9JhnKTUCCy+CkE8ZOq+LzclQLQ4WD6P4RC+AnS0TCfJy2H/4KTF4lBb2yrzI1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718027044; c=relaxed/simple;
	bh=q8zrjufdqG2e65l2pDcruZuD7djK4hiuptKw5Qkylyw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nybTy24BqLaCQQ0coMBgEGmcaxC6DfZKXeUaK0ZVOw3auDJAX/lhSEkgW7DgIUFNljGNG3lgHnNyVBR8pXzN+m6MbnrAEnPTFPdkA8zL4Q/5vMYt/cL8PVGZx4vg7nP/qtYEnKHAhMJm/rdAnNuZBYzGKSr5SI6bh6w1mPkoBlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 64FF91688;
	Mon, 10 Jun 2024 06:44:27 -0700 (PDT)
Received: from e122027.cambridge.arm.com (e122027.cambridge.arm.com [10.1.35.41])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B2E643F58B;
	Mon, 10 Jun 2024 06:44:00 -0700 (PDT)
From: Steven Price <steven.price@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: Steven Price <steven.price@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>,
	linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Subject: [PATCH v3 32/43] arm_pmu: Provide a mechanism for disabling the physical IRQ
Date: Mon, 10 Jun 2024 14:41:51 +0100
Message-Id: <20240610134202.54893-33-steven.price@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240610134202.54893-1-steven.price@arm.com>
References: <20240610134202.54893-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Arm CCA assigns the physical PMU device to the guest running in realm
world, however the IRQs are routed via the host. To enter a realm guest
while a PMU IRQ is pending it is necessary to block the physical IRQ to
prevent an immediate exit. Provide a mechanism in the PMU driver for KVM
to control the physical IRQ.

Signed-off-by: Steven Price <steven.price@arm.com>
---
v3: Add a dummy function for the !CONFIG_ARM_PMU case.
---
 drivers/perf/arm_pmu.c       | 15 +++++++++++++++
 include/linux/perf/arm_pmu.h |  5 +++++
 2 files changed, 20 insertions(+)

diff --git a/drivers/perf/arm_pmu.c b/drivers/perf/arm_pmu.c
index 8458fe2cebb4..1e024acc98bb 100644
--- a/drivers/perf/arm_pmu.c
+++ b/drivers/perf/arm_pmu.c
@@ -735,6 +735,21 @@ static int arm_perf_teardown_cpu(unsigned int cpu, struct hlist_node *node)
 	return 0;
 }
 
+void arm_pmu_set_phys_irq(bool enable)
+{
+	int cpu = get_cpu();
+	struct arm_pmu *pmu = per_cpu(cpu_armpmu, cpu);
+	int irq;
+
+	irq = armpmu_get_cpu_irq(pmu, cpu);
+	if (irq && !enable)
+		per_cpu(cpu_irq_ops, cpu)->disable_pmuirq(irq);
+	else if (irq && enable)
+		per_cpu(cpu_irq_ops, cpu)->enable_pmuirq(irq);
+
+	put_cpu();
+}
+
 #ifdef CONFIG_CPU_PM
 static void cpu_pm_pmu_setup(struct arm_pmu *armpmu, unsigned long cmd)
 {
diff --git a/include/linux/perf/arm_pmu.h b/include/linux/perf/arm_pmu.h
index b3b34f6670cf..f9fa628ae2ae 100644
--- a/include/linux/perf/arm_pmu.h
+++ b/include/linux/perf/arm_pmu.h
@@ -168,6 +168,7 @@ void kvm_host_pmu_init(struct arm_pmu *pmu);
 #endif
 
 bool arm_pmu_irq_is_nmi(void);
+void arm_pmu_set_phys_irq(bool enable);
 
 /* Internal functions only for core arm_pmu code */
 struct arm_pmu *armpmu_alloc(void);
@@ -178,6 +179,10 @@ void armpmu_free_irq(int irq, int cpu);
 
 #define ARMV8_PMU_PDEV_NAME "armv8-pmu"
 
+#else /* CONFIG_ARM_PMU */
+
+static inline void arm_pmu_set_phys_irq(bool enable) {}
+
 #endif /* CONFIG_ARM_PMU */
 
 #define ARMV8_SPE_PDEV_NAME "arm,spe-v1"
-- 
2.34.1

