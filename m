Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=139.138.36.225
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795079138;
	b=pHDKboKPa4y1HsdxqeAwlmwdRfdgorN+xdVmNTlNwdbeQkLhNNKvHSrPOsth1PlhFqFG
	 Vv7ZE8RBedd/LTcpEmCcr39cKfjDoV22i6h6dcHbfpJn9d1cTO6DBjQHhsTJmJNiAp4Z1
	 1KF1GdK1tT12J4m9EyfhJfU8iuMlzwtaLwFAEohp1ryFll8bz+KeR84McN1/eGxgOW0/+
	 VyUi/A1rWDElznKeN1LQCNdLig6PV8hAK7zamEeXBib3v6uwm9KI+3wyJ7QijLDrv4UrF
	 HUjhJaCgKIVejNX1dr21cTE+IzkB9p/I/Yd3DJVZFxmv4D8WgSzOFnUgKuvAURibd9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795079138;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:Received:Received:Received:From:
	 Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=FF/80+RBUBxw5mWtW2KS5XSxoiO6Z7IYFbfOuIvu2Ac=;
	b=mDkBBwt/pjqTCgISphRcrfO8M85CZUP4iH3gO2R1oOPeHfKzwJLmzoVDP2EN7bRoOM7N
	 6PzAL33z2UJHFyeWt4qexJYkbASWcYx62M3NlMCEwuQZObUpsSUg59+hZUgUrJl2Ik0gx
	 zUS3QvjjzH22EwRPBrP20FE/7IXOab1FMEJRHrDOSXP8kDMQkXfhsZRyElsTNRGTjVOGl
	 GHJKpLCveM4i6KlOgphIyjoWp7pYtVYjeLuW2Y1DwWIRO70SQW4RgyinDqaiDc89xNwlm
	 wXWJsUl6CmWliTy20G8EkbSgXGlLnHryDyov3NlswZ43AGlrW6a17JRcTHuaW3NSm5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fujitsu.com;
	spf=pass smtp.mailfrom=fujitsu.com;
	dkim=pass header.d=fujitsu.com header.i=@fujitsu.com header.a=rsa-sha256 header.s=fj2 header.b=Ds8Bu0As;
	arc=none smtp.remote-ip=139.138.36.225
Received: from esa10.hc1455-7.c3s2.iphmx.com (esa10.hc1455-7.c3s2.iphmx.com [139.138.36.225])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51D2060A2624
	for <kvmarm@lists.linux.dev>; Thu, 19 Nov 2026 09:05:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 51D2060A2624
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.a=rsa-sha256 header.s=fj2 header.b=Ds8Bu0As
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1795079136; x=1826615136;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=doMhYgkYumk/+/XY9c0OXwpBFMZB2Q8qiBe5sUKK3+Q=;
  b=Ds8Bu0Asp3n9Kq9dNOY0c5HsicCgmvt7esUnRAcEyzwvvbRblDh90gm5
   GtPHbzgResVQuf1DIzqby5XSNVWADM0m3zdH+DFAzLT8UaQ4Ks2BggOhc
   hobgyUgsZaLoH0wpt14kuMk5LsK97vOBx+zw0MGm0lF0dIk7uhMRF27Tr
   OiEeu7wHgvEtw/qe0BxPvoQecw81zmF83iWTwX6xigTg54RjQVrRLh4Gq
   UzYiaUaGLcI55spJYuumcIuJ9nNjj1yUNaHLNO3BaYrZd/u2jztSFntE9
   oxXWv1prixVmnUklEi1SpWBxluK0MQgY5ZQ6YsfCdDSAIXeQlcvs0t0qL
   A==;
X-CSE-ConnectionGUID: 56ouUfJKTN2W5yfgOgrCGw==
X-CSE-MsgGUID: e4qLvSdHSDWSH/JW/ggPfg==
X-IronPort-AV: E=McAfee;i="6800,10657,11970"; a="248587114"
X-IronPort-AV: E=Sophos;i="6.27,220,1786978800"; 
   d="scan'208";a="248587114"
Received: from gmgwnl01.global.fujitsu.com ([52.143.17.124])
  by esa10.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2026 18:05:29 +0900
Received: from az2nlsmgm3.fujitsu.com (unknown [10.150.26.205])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by gmgwnl01.global.fujitsu.com (Postfix) with ESMTPS id 6F7CD1C0622B
	for <kvmarm@lists.linux.dev>; Thu, 19 Nov 2026 09:05:30 +0000 (UTC)
Received: from az2uksmom3.o.css.fujitsu.com (unknown [10.151.22.205])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2nlsmgm3.fujitsu.com (Postfix) with ESMTPS id 1E9581804146
	for <kvmarm@lists.linux.dev>; Thu, 19 Nov 2026 09:05:30 +0000 (UTC)
Received: from [127.0.1.1] (unknown [10.124.178.20])
	by az2uksmom3.o.css.fujitsu.com (Postfix) with ESMTP id 729FA1001166;
	Thu, 19 Nov 2026 09:05:22 +0000 (UTC)
From: Tomohiro Misono <misono.tomohiro@fujitsu.com>
Date: Thu, 19 Nov 2026 18:04:36 +0900
Subject: [PATCH v3 4/5] irqchip/gicv3: Add workaround for FUJITSU-MONAKA
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
Message-Id: <20261119-monaka-fix-for-upstream-v3-4-057df4d2ca3c@fujitsu.com>
References: <20261119-monaka-fix-for-upstream-v3-0-057df4d2ca3c@fujitsu.com>
In-Reply-To: <20261119-monaka-fix-for-upstream-v3-0-057df4d2ca3c@fujitsu.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795079092; l=5351;
 i=misono.tomohiro@fujitsu.com; s=20261002; h=from:subject:message-id;
 bh=BC5dTRfHfZlF2iCc7SBol6JXhnpQnG/aQ//ezaBWl+I=;
 b=vfU+0IA2fhy3UzVfpXqM9u6G3+iNGf0bGLxODcXQALoi+CiZGnSTZDpOOpNkV7t/FmzvCzBox
 mTGQewl0/AQBGE46EzU4OlPsJLCOZ7huh6dNfizInM/urs5eICGiPXn
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
index 65bbdaf1f925..df57078d3727 100644
--- a/Documentation/arch/arm64/silicon-errata.rst
+++ b/Documentation/arch/arm64/silicon-errata.rst
@@ -397,6 +397,8 @@ stable kernels.
 +----------------+-----------------+-----------------+-----------------------------+
 | Fujitsu        | MONAKA          | E#030002        | FUJITSU_ERRATUM_030002      |
 +----------------+-----------------+-----------------+-----------------------------+
+| Fujitsu        | MONAKA GICv3/v4 | E#030003        | N/A                         |
++----------------+-----------------+-----------------+-----------------------------+
 +----------------+-----------------+-----------------+-----------------------------+
 | ASR            | ASR8601         | #8601001        | N/A                         |
 +----------------+-----------------+-----------------+-----------------------------+
diff --git a/drivers/irqchip/irq-gic-v3.c b/drivers/irqchip/irq-gic-v3.c
index 94873646d46f..18f8b2b40543 100644
--- a/drivers/irqchip/irq-gic-v3.c
+++ b/drivers/irqchip/irq-gic-v3.c
@@ -80,6 +80,8 @@ static DEFINE_STATIC_KEY_FALSE(gic_nvidia_t241_erratum);
 
 static DEFINE_STATIC_KEY_FALSE(gic_arm64_2941627_erratum);
 
+static DEFINE_STATIC_KEY_FALSE(gic_fujitsu_030003_erratum);
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

