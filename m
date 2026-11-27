Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=207.54.90.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795757853;
	b=k/bxorrfarMTX6i6wHYs13P2O0boAyX7UObTSzuLIQo1xq2Dq7lK5Ab0nqbTgPUD2FSh
	 TO0SDpn+JecX8z+a35fhYW9juJ9xZFzAamvJyzCqU5mcifcmKf3D2sndDS0MP4R+YTaWQ
	 L3M7tKclD19B3z1whN3/2L3rMktpIe/8/C+tsVYQ90ME2DbTUZoAUtuwBLhD9q8qqfho5
	 WYPbtu1tUQLH8N6x2iXTrE7holtYZMnSxvvYICHq/YZgH/rXAzA2AGV2L9CHQQv5fjQgT
	 zEzFBcQu8IlK1Arn1yRRX1JjjbX2VFN0rQaD9YuB8YUivKOTc8/UvdKgiwGTJoYXM5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795757853;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:Received:Received:Received:From:
	 Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=SC1dzg38tmfFOoUKwD0WOCR1qU5zAAB5z/g5TkovgI0=;
	b=OxLUIECvb1JGz1vw7p/+Ob/rADsAlrwU7FLfcMfUYpMwphNiKuU9O+8EmPEgOq435CLi
	 mazU9yWkbkVPB9rJXZSs+4m9P5/7U2tTszXejfMHDRhuJ0aIzjzQvcxVuuzIEokg2zDAq
	 BR54Tr0CnQyVFHsx4A9eJByheLI6bQFC/jVhhqxiaQiUXFDJCubkAHatDOebmXuBzD1qV
	 ieEKEbwKVGDcAsVyR5PCRv2YtjCPEMx1fgC0HHh0x6F0R0WWhdzLSirxMZvKlevWSJJiD
	 mNusdMBpDMPlpIiOGdWPiwzeG0PX3+ChhCifncwBaJ7XkGpTR7F4PSxWMmby6ny+bfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fujitsu.com;
	spf=pass smtp.mailfrom=fujitsu.com;
	dkim=pass header.d=fujitsu.com header.i=@fujitsu.com header.a=rsa-sha256 header.s=fj2 header.b="gcNH/OFT";
	arc=none smtp.remote-ip=207.54.90.49
Received: from esa3.hc1455-7.c3s2.iphmx.com (esa3.hc1455-7.c3s2.iphmx.com [207.54.90.49])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30505606A323
	for <kvmarm@lists.linux.dev>; Fri, 27 Nov 2026 05:37:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 30505606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.a=rsa-sha256 header.s=fj2 header.b=gcNH/OFT
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1795757862; x=1827293862;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=RpGsDpiAVD3WqMP1+3FHOIWafrnqy5vDJu7yd3Zvd8I=;
  b=gcNH/OFTP8MAmds4I0wBGw/37mG9TrU0uBUR1X2R4wKgTKDXRbC/Xjrw
   34pA8jG1rjuQYqsVHS2pMCkzjF9qqX5bYzWybJhLoil11/yNG0zsqnFAs
   OjP4tnNTWuxvMxhL8g7HOtvHJ0fEyCZlqDeyC7eeHVKQODUMri1sn9fMy
   trFCNAi9c5hBqvU/tU2ThX+OuZJme+Nu3ZMP9vNd87kHUqJgKXlgff5Y7
   IBBJ4bRqjnKd8QrSKKIDYOvQ2YWxJMygCZZV8vJC2eUbf7VgIVP1JO1nG
   hF7qB9dhQFdVA13iGS8Lg1KYRYhMh8ijCHDCZ7qznkG4ZE6yHyQSc8L39
   Q==;
X-CSE-ConnectionGUID: MsfrSnv+SAmIpX7L5xgqDA==
X-CSE-MsgGUID: Xf64J9FoQ9WrU62yTGKY3A==
X-IronPort-AV: E=McAfee;i="6800,10657,11978"; a="263228339"
X-IronPort-AV: E=Sophos;i="6.27,236,1786978800"; 
   d="scan'208";a="263228339"
Received: from gmgwnl01.global.fujitsu.com (HELO mgmgwnl01.global.fujitsu.com) ([52.143.17.124])
  by esa3.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Nov 2026 14:37:34 +0900
Received: from az2nlsmgm1.o.css.fujitsu.com (unknown [10.150.26.203])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mgmgwnl01.global.fujitsu.com (Postfix) with ESMTPS id 7C81117299
	for <kvmarm@lists.linux.dev>; Fri, 27 Nov 2026 05:37:25 +0000 (UTC)
Received: from az2uksmom4.o.css.fujitsu.com (unknown [10.151.22.204])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2nlsmgm1.o.css.fujitsu.com (Postfix) with ESMTPS id 23F7AC013F8
	for <kvmarm@lists.linux.dev>; Fri, 27 Nov 2026 05:37:25 +0000 (UTC)
Received: from [127.0.1.1] (unknown [10.124.178.20])
	by az2uksmom4.o.css.fujitsu.com (Postfix) with ESMTP id A47BE406873;
	Fri, 27 Nov 2026 05:37:17 +0000 (UTC)
From: Tomohiro Misono <misono.tomohiro@fujitsu.com>
Date: Fri, 27 Nov 2026 14:36:31 +0900
Subject: [PATCH v4 2/5] arm64: tlb: Add tlbi workaround for FUJITSU-MONAKA
 Erratum E#030001
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
Message-Id: <20261127-monaka-fix-for-upstream-v4-2-3395c415bbe4@fujitsu.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795757822; l=6029;
 i=misono.tomohiro@fujitsu.com; s=20261002; h=from:subject:message-id;
 bh=RpGsDpiAVD3WqMP1+3FHOIWafrnqy5vDJu7yd3Zvd8I=;
 b=ZC+iJhuGH4xq2Hmw7kU/IsVfaZUjPMLI3EX220PAhc3VsHgdxi6EH/4zF0yqy2vme8NcWJYN4
 pJC6o6z1++0DhS1MvVESll+Np4SGb1Dvvdxo6/O2kih8chAxkNzIjs0
X-Developer-Key: i=misono.tomohiro@fujitsu.com; a=ed25519;
 pk=VLRxj5y4GJrHLmj3e2NBg30fX2U//ydi7c2G2qiNo10=

FUJITSU-MONAKA Erratum E#030001 affects FUJITSU-MONAKA CPU
when using TLBI range operations.

On affected FUJITSU-MONAKA CPUs, range-based TLBI operations
targeting a VA or IPA may fail to invalidate TLB entries when
addr[34:29] == all 1 && addr[28:0] == 0 for 512MB mappings.
The affected instructions are:
  RVA[L]E{1,2,3}*, RVAA[L]E1*, and RIPAS2[L]E1*.

Work around the erratum by dropping TLB range capability from
ID_AA64ISAR0_EL1 before detecting system capability. This means
TLB range operations are disabled on both host and guest.

Signed-off-by: Tomohiro Misono <misono.tomohiro@fujitsu.com>

---
Changes in v4:
 - rework patch to drop TLB range capability from ID_AA64ISAR0_EL1
   before detecting system capability so that both KVM/pKVM sees
   the sanitized reg value
Changes in v3:
 - disable TLB range operations on both host and guest
 - use ERRATA_MIDR_ALL_VERSIONS macro
---
 Documentation/arch/arm64/silicon-errata.rst |  2 ++
 arch/arm64/Kconfig                          | 18 ++++++++++++++++++
 arch/arm64/include/asm/cpucaps.h            |  2 ++
 arch/arm64/kernel/cpu_errata.c              |  7 +++++++
 arch/arm64/kernel/cpufeature.c              | 17 +++++++++++++++++
 arch/arm64/tools/cpucaps                    |  1 +
 6 files changed, 47 insertions(+)

diff --git a/Documentation/arch/arm64/silicon-errata.rst b/Documentation/arch/arm64/silicon-errata.rst
index bffaa46c664b..751f478a71b7 100644
--- a/Documentation/arch/arm64/silicon-errata.rst
+++ b/Documentation/arch/arm64/silicon-errata.rst
@@ -399,6 +399,8 @@ stable kernels.
 +----------------+-----------------+-----------------+-----------------------------+
 | Fujitsu        | A64FX           | E#010001        | FUJITSU_ERRATUM_010001      |
 +----------------+-----------------+-----------------+-----------------------------+
+| Fujitsu        | MONAKA          | E#030001        | FUJITSU_ERRATUM_030001      |
++----------------+-----------------+-----------------+-----------------------------+
 +----------------+-----------------+-----------------+-----------------------------+
 | ASR            | ASR8601         | #8601001        | N/A                         |
 +----------------+-----------------+-----------------+-----------------------------+
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 9b08b2457a55..8a0c94a0c879 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -1384,6 +1384,24 @@ config FUJITSU_ERRATUM_010001
 
 	  If unsure, say Y.
 
+config FUJITSU_ERRATUM_030001
+	bool "FUJITSU-MONAKA erratum E#030001: Range TLBI may fail to invalidate some entries"
+	default y
+	help
+	  This option adds a workaround for FUJITSU-MONAKA erratum E#030001.
+	  On affected FUJITSU-MONAKA CPUs, range-based TLBI operation
+	  targeting a VA or IPA may fail to invalidate some TLB entries
+	  when hugepage is used in a certain condition. The affected
+	  instructions are RVA[L]E{1,2,3}*, RVAA[L]E1*, and RIPAS2[L]E1*
+	  and this affects on both S1 and S2 tables.
+
+	  Work around the erratum by disabling TLB range operations on both
+	  host and guest.
+
+	  The erratum only affects the FUJITSU-MONAKA.
+
+	  If unsure, say Y.
+
 config HISILICON_ERRATUM_161600802
 	bool "Hip07 161600802: Erroneous redistributor VLPI base"
 	default y
diff --git a/arch/arm64/include/asm/cpucaps.h b/arch/arm64/include/asm/cpucaps.h
index 0c3bfbe99aad..7c73a739eee1 100644
--- a/arch/arm64/include/asm/cpucaps.h
+++ b/arch/arm64/include/asm/cpucaps.h
@@ -68,6 +68,8 @@ cpucap_is_possible(const unsigned int cap)
 		return IS_ENABLED(CONFIG_ARM64_ERRATUM_4193714);
 	case ARM64_WORKAROUND_NXP_ERR050104:
 		return IS_ENABLED(CONFIG_NXP_IMX8QM_ERRATUM_ERR050104);
+	case ARM64_WORKAROUND_FUJITSU_030001:
+		return IS_ENABLED(CONFIG_FUJITSU_ERRATUM_030001);
 	case ARM64_MPAM:
 		/*
 		 * KVM MPAM support doesn't rely on the host kernel supporting MPAM.
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index ca31d33152e9..c8a0ea73ec1a 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -1096,6 +1096,13 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 		.matches = has_impdef_pmuv3,
 		.cpu_enable = cpu_enable_impdef_pmuv3_traps,
 	},
+#ifdef CONFIG_FUJITSU_ERRATUM_030001
+	{
+		.desc = "FUJITSU-MONAKA Erratum E#030001",
+		.capability = ARM64_WORKAROUND_FUJITSU_030001,
+		ERRATA_MIDR_ALL_VERSIONS(MIDR_FUJITSU_MONAKA),
+	},
+#endif
 	{
 		.desc = "Known broken GICv3 SEIS implementation",
 		.capability = ARM64_WORKAROUND_GICv3_BROKEN_SEIS,
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index a8a1a73ba1b8..caeb72935f2c 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -3998,8 +3998,25 @@ void __init setup_boot_cpu_features(void)
 	setup_boot_cpu_capabilities();
 }
 
+static void __init apply_fujitsu_030001_workaround(void)
+{
+	struct arm64_ftr_reg *regp;
+	u64 val;
+
+	if (!cpus_have_cap(ARM64_WORKAROUND_FUJITSU_030001))
+		return;
+
+	regp = get_arm64_ftr_reg(SYS_ID_AA64ISAR0_EL1);
+	/* disable TLBI range operation */
+	val = regp->sys_val & ~ID_AA64ISAR0_EL1_TLB_MASK;
+	val |= SYS_FIELD_PREP_ENUM(ID_AA64ISAR0_EL1, TLB, OS);
+	update_cpu_ftr_reg(regp, val);
+}
+
 static void __init setup_system_capabilities(void)
 {
+	/* Apply workaround before detecting system capabilies */
+	apply_fujitsu_030001_workaround();
 	/*
 	 * The system-wide safe feature register values have been finalized.
 	 * Detect, enable, and patch alternatives for the available system
diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
index 3125695122a0..1a199502614d 100644
--- a/arch/arm64/tools/cpucaps
+++ b/arch/arm64/tools/cpucaps
@@ -134,3 +134,4 @@ WORKAROUND_SPECULATIVE_SSBS
 WORKAROUND_SPECULATIVE_UNPRIV_LOAD
 WORKAROUND_BROKEN_AMU_CONSTCNT
 WORKAROUND_BROKEN_AMU_CORECNT
+WORKAROUND_FUJITSU_030001

-- 
2.43.0

