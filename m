Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=68.232.139.117
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795757868;
	b=ZaXjK/YUIE1xZh+w+eNWZf2nbQ1JCpuPlJ5a9C+efkYdljdKW7LQeVJ1tVc/UwW8u3c4
	 +0tNbLbGdWLuMKAhkwQGn/l8CvpFK+5MAV9ZFVmqKd9q2GTitB988Q0Uu3Wf2LOm4SPsi
	 DkKQVcbaP4YB9PqOeaBbbvmDf8cISzFkC6WDraWkaoqd5F/oWoZKJ9uo0IXN80ND33Qyq
	 PhFpPy9WxjRPdNKl8IHZ5mqEyn2PmNW/zuhu+Tuk0oAFEN1F/X04j1B4c/+dh0gVm0Lf/
	 NxvJnLZVrF0F/Jz27I23zbi1OWJBCbpW4J7dmbbc/iBjSp1jdjTiOqD8tOcIa5//pLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795757868;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:Received:Received:Received:From:
	 Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=GcwOmZOhg86jI0lRAL6VRDDi7N2nNyA6lCcyVCLLrs8=;
	b=E/KiAPhBRUwHPQxyQA0Ux1aHyO+UoMTifl75bIHGPem21qIRo9/Mzgh7BtjeQeigktSQ
	 Lc4o2pp/7sBclQeDFNC6ciVnGKmoXEWjyrRR+PbQZLvXpa6/8sihjMgms55srghcsbaUJ
	 rLtPY4UlS0ev1mpJ0ojqUIxISYbv/DRAb0Q74U3iBx96S1sSf6ZfddE0xqr30iorTbAE4
	 GXPcsgEVYp+RSDq39abgsVXPNYBspxUi1Sf3z6SzmKyV3aiKh1kJDUymD7oyWw9xk6rQe
	 Ooh7Y/gqIo5LXK/SPqik+zwufQ4EPxZSiSEM9+j3SeVcr/e2Rqvk7tT4FAU61OqN21A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fujitsu.com;
	spf=pass smtp.mailfrom=fujitsu.com;
	dkim=pass header.d=fujitsu.com header.i=@fujitsu.com header.a=rsa-sha256 header.s=fj2 header.b=marBrmv7;
	arc=none smtp.remote-ip=68.232.139.117
Received: from esa4.hc1455-7.c3s2.iphmx.com (esa4.hc1455-7.c3s2.iphmx.com [68.232.139.117])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38BEC606A323
	for <kvmarm@lists.linux.dev>; Fri, 27 Nov 2026 05:37:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 38BEC606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.a=rsa-sha256 header.s=fj2 header.b=marBrmv7
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1795757867; x=1827293867;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=njt+3iaAfTIgJguhwrDXASiiKgJTF4wH2ZIbGB+ON1k=;
  b=marBrmv7JEe7KmoYLAmNI2sTch+lQKBZNsq7VY+AllPUW2MLGvVFWnBa
   7K/iuO/FUiF20Su/nm4yL1d6eg34VmQLIIvU0toEEKg/xJBDzefL3WOAq
   P9W6oGaqppQERjZO9LO67QLgUypaZP6/HvJVSpvV1mDATGPaksL+mGYHT
   jHljR3zPjjTSaGRO7JIupCmf70RsCg2fbCIT+s2y2p/JeGeS7/g3Q1n+b
   UDmU/x+UO1QjmwRHgDzrT6zg8MN+CdDFJUi8ifIJttLOZ3/8axwjA/tpR
   rQD2O/tJidI/mJkDfQ8yImHftZSqTkNzCnIk4dUZnpV+OAtXc0tONL2ax
   Q==;
X-CSE-ConnectionGUID: cGFRYaC6TMeSsC6x21nsZg==
X-CSE-MsgGUID: qIFtj6jXT0OY3lMbY51rkg==
X-IronPort-AV: E=McAfee;i="6800,10657,11978"; a="262847562"
X-IronPort-AV: E=Sophos;i="6.27,236,1786978800"; 
   d="scan'208";a="262847562"
Received: from gmgwnl01.global.fujitsu.com (HELO mgmgwnl01.global.fujitsu.com) ([52.143.17.124])
  by esa4.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Nov 2026 14:37:39 +0900
Received: from az2nlsmgm3.fujitsu.com (unknown [10.150.26.205])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mgmgwnl01.global.fujitsu.com (Postfix) with ESMTPS id A48E933E3
	for <kvmarm@lists.linux.dev>; Fri, 27 Nov 2026 05:37:39 +0000 (UTC)
Received: from az2uksmom4.o.css.fujitsu.com (unknown [10.151.22.204])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2nlsmgm3.fujitsu.com (Postfix) with ESMTPS id 5526B18026DC
	for <kvmarm@lists.linux.dev>; Fri, 27 Nov 2026 05:37:39 +0000 (UTC)
Received: from [127.0.1.1] (unknown [10.124.178.20])
	by az2uksmom4.o.css.fujitsu.com (Postfix) with ESMTP id D293C4045EE;
	Fri, 27 Nov 2026 05:37:31 +0000 (UTC)
From: Tomohiro Misono <misono.tomohiro@fujitsu.com>
Date: Fri, 27 Nov 2026 14:36:33 +0900
Subject: [PATCH v4 4/5] irqchip/gicv3: Add workaround for FUJITSU-MONAKA
 Erratum E#030003
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261127-monaka-fix-for-upstream-v4-4-3395c415bbe4@fujitsu.com>
References: <20261127-monaka-fix-for-upstream-v4-0-3395c415bbe4@fujitsu.com>
In-Reply-To: <20261127-monaka-fix-for-upstream-v4-0-3395c415bbe4@fujitsu.com>
To: Tomohiro Misono <misono.tomohiro@fujitsu.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Mark Rutland <mark.rutland@arm.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, Marc Zyngier <maz@kernel.org>, 
 Thomas Gleixner <tglx@kernel.org>, Radu Rendec <radu@rendec.net>, 
 Oliver Upton <oupton@kernel.org>, Fuad Tabba <fuad.tabba@linux.dev>, 
 Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, 
 Vladimir Murzin <vladimir.murzin@arm.com>
Cc: Kohei Enju <enju.kohei@fujitsu.com>, 
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-doc@vger.kernel.org, linux-perf-users@vger.kernel.org, 
 kvmarm@lists.linux.dev
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795757822; l=5445;
 i=misono.tomohiro@fujitsu.com; s=20261002; h=from:subject:message-id;
 bh=AO0SHHOsMFpPJAvVfyvDbNvFFD/5lyT+73Egw7EYZus=;
 b=MoJMUgSq8ZSoPQ6LJVnl+zjtInKqgmzrK7igsHbtw0vapePHEGNvI2mXI6dXO7tjHaDWSt+8v
 zrIH0ndA+pQDH9HZHPCcOAtN9lHzIcrKQFkfYfUWJd5fivMh01KRuZO
X-Developer-Key: i=misono.tomohiro@fujitsu.com; a=ed25519;
 pk=VLRxj5y4GJrHLmj3e2NBg30fX2U//ydi7c2G2qiNo10=

From: Kohei Enju <enju.kohei@fujitsu.com>

On affected FUJITSU-MONAKA CPUs, the erratum may occur when an SGI is
generated by writing to ICC_SGI0R_EL1, ICC_SGI1R_EL1, or ICC_ASGI1R_EL1,
if the operation races with CPU interface processing triggered by the
arrival of a higher-priority interrupt, an update to a pending
interrupt, or a transition of the PE to the Sleep state. When the
erratum occurs, the SGI is lost and the system register write does not
complete, causing the issuing core to hang.

Guest accesses to these registers are not affected by this erratum, as
they are trapped to EL2 and handled without issuing the affected system
register write.

Work around the erratum by writing 1 to the bit corresponding to the
target SGI INTID in GICR_ISPENDR0 of each target PE's GIC Redistributor,
instead of writing to the affected system registers.

Accessing a target PE's GICR_ISPENDR0 requires its Redistributor base to
have been discovered. Affected platforms conform to SBBR, which requires
PSCI for secondary CPU boot. They therefore do not use the ACPI Parking
protocol, which sends an IPI before the secondary CPU has initialized
its Redistributor. With PSCI, a secondary CPU discovers its
Redistributor before becoming an IPI target.

Signed-off-by: Kohei Enju <enju.kohei@fujitsu.com>
Signed-off-by: Tomohiro Misono <misono.tomohiro@fujitsu.com>
---
Changes in v4:
- Fix unused variable 'gic_fujitsu_030003_erratum' warning.

Changes in v3:
- Remove the unnecessary DSB after writes to GICR_ISPENDR0.
- Fix build issue when CONFIG_ARM=y.
- Add an SoB of Tomohiro.

Changes in v2:
- Clarify the erratum description and document that virtual accesses are
  unaffected.
- Remove the gic_send_sgi_via_rdist() helper.
- Remove the write-count rationale.
- Use the CPU MIDR instead of the SoC ID for filtering.
---
 Documentation/arch/arm64/silicon-errata.rst |  2 ++
 drivers/irqchip/irq-gic-v3.c                | 35 +++++++++++++++++++++++++++++
 2 files changed, 37 insertions(+)

diff --git a/Documentation/arch/arm64/silicon-errata.rst b/Documentation/arch/arm64/silicon-errata.rst
index 01db1b906ba4..e6bbc54208b1 100644
--- a/Documentation/arch/arm64/silicon-errata.rst
+++ b/Documentation/arch/arm64/silicon-errata.rst
@@ -403,6 +403,8 @@ stable kernels.
 +----------------+-----------------+-----------------+-----------------------------+
 | Fujitsu        | MONAKA          | E#030002        | FUJITSU_ERRATUM_030002      |
 +----------------+-----------------+-----------------+-----------------------------+
+| Fujitsu        | MONAKA GICv3/v4 | E#030003        | N/A                         |
++----------------+-----------------+-----------------+-----------------------------+
 +----------------+-----------------+-----------------+-----------------------------+
 | ASR            | ASR8601         | #8601001        | N/A                         |
 +----------------+-----------------+-----------------+-----------------------------+
diff --git a/drivers/irqchip/irq-gic-v3.c b/drivers/irqchip/irq-gic-v3.c
index 94873646d46f..c28447966158 100644
--- a/drivers/irqchip/irq-gic-v3.c
+++ b/drivers/irqchip/irq-gic-v3.c
@@ -80,6 +80,8 @@ static DEFINE_STATIC_KEY_FALSE(gic_nvidia_t241_erratum);
 
 static DEFINE_STATIC_KEY_FALSE(gic_arm64_2941627_erratum);
 
+static __maybe_unused DEFINE_STATIC_KEY_FALSE(gic_fujitsu_030003_erratum);
+
 static struct gic_chip_data gic_data __read_mostly;
 static DEFINE_STATIC_KEY_TRUE(supports_deactivate_key);
 
@@ -240,6 +242,9 @@ static DEFINE_PER_CPU(bool, has_rss);
 #define gic_data_rdist()		(this_cpu_ptr(gic_data.rdists.rdist))
 #define gic_data_rdist_rd_base()	(gic_data_rdist()->rd_base)
 #define gic_data_rdist_sgi_base()	(gic_data_rdist_rd_base() + SZ_64K)
+#define gic_data_rdist_cpu(cpu)		(per_cpu_ptr(gic_data.rdists.rdist, cpu))
+#define gic_data_rdist_rd_base_cpu(cpu)	(gic_data_rdist_cpu(cpu)->rd_base)
+#define gic_data_rdist_sgi_base_cpu(cpu)	(gic_data_rdist_rd_base_cpu(cpu) + SZ_64K)
 
 /* Our default, arbitrary priority value. Linux only uses one anyway. */
 #define DEFAULT_PMR_VALUE	0xf0
@@ -1388,6 +1393,16 @@ static void gic_ipi_send_mask(struct irq_data *d, const struct cpumask *mask)
 	 */
 	dsb(ishst);
 
+	if (static_branch_unlikely(&gic_fujitsu_030003_erratum)) {
+		for_each_cpu(cpu, mask) {
+			void __iomem *base = gic_data_rdist_sgi_base_cpu(cpu);
+
+			writel_relaxed(BIT(d->hwirq), base + GICR_ISPENDR0);
+		}
+
+		return;
+	}
+
 	for_each_cpu(cpu, mask) {
 		u64 cluster_id = MPIDR_TO_SGI_CLUSTER_ID(gic_cpu_to_affinity(cpu));
 		u16 tlist;
@@ -1874,6 +1889,18 @@ static bool gic_enable_quirk_rk3399(void *data)
 	return false;
 }
 
+#ifdef CONFIG_ARM64
+static bool gic_enable_quirk_fujitsu_030003(void *data)
+{
+	if (read_cpuid_implementor() != ARM_CPU_IMP_FUJITSU ||
+	    read_cpuid_part_number() != FUJITSU_CPU_PART_MONAKA)
+		return false;
+
+	static_branch_enable(&gic_fujitsu_030003_erratum);
+	return true;
+}
+#endif
+
 static bool rd_set_non_coherent(void *data)
 {
 	struct gic_chip_data *d = data;
@@ -1954,6 +1981,14 @@ static const struct gic_quirk gic_quirks[] = {
 		.mask	= 0xff000fff,
 		.init	= gic_enable_quirk_rk3399,
 	},
+#ifdef CONFIG_ARM64
+	{
+		.desc	= "GICv3: FUJITSU-MONAKA Erratum E#030003",
+		.iidr	= 0x0403043b,
+		.mask	= 0xffffffff,
+		.init	= gic_enable_quirk_fujitsu_030003,
+	},
+#endif
 	{
 	}
 };

-- 
2.43.0

