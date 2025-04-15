Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11020114.outbound.protection.outlook.com [52.101.61.114])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8D361D79A5
	for <kvmarm@lists.linux.dev>; Tue, 15 Apr 2025 15:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.114
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744732040; cv=fail; b=Z0kZFNV4EUjQmWfhDyJUx9bv5vPxYSDH5BBMSZ/ri2p/DR+JH0qkcgcAESuPWg5iKMjfryGckjt4seGpj9sBRpMKTfDqga1CDzrZtZpqwbQQ0Kz+FRh9DZ+myH34RBYGpagWoKCtp/EBns7H491Q8fvwI68ToyU2i+tq4zgKn88=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744732040; c=relaxed/simple;
	bh=4bsURbRpIdDWSVVJdIUzL7sd+9DEITfejlGG9swKuh8=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=Ob44D05lvgtjlrP+XU6PqMwRU5zlkvMZH4HI5ACZZkm6FVix1lVgniagK2/h0jtG8R+YWbTm6Q2KCW0M2a2QQcoBa8R98pQxBor8ZOJf3YhzbBNFwTx5CI1FjU/dRj6czUv5t6o78D+NPRuFIgZ4jlkgaOlf1UDNLyBfq/7XTq4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com; spf=pass smtp.mailfrom=os.amperecomputing.com; dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b=Av4A3imh; arc=fail smtp.client-ip=52.101.61.114
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b="Av4A3imh"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GoZXoty2iBgJO4LVEfMqA+V1N9OvqEucXzJnCIQUOnEYWUUqOKcXuv+lOnsKJDbWB8AJCEMeANAp8aKCmeRgeB8vY15be1WyL00h2fWDjbQg6CQw2Wd8sp3SHXs2iPqmhejxmh3OpaeMlWZrH3f4b1z/7exfb1QchI2IUjIZbNxSOCvUXbULdu7BP6/4fOb2xcBpwqJVR7X+bslGs6B5GC/2Cvo9e24ikXjAS8n2j3FSYuap1IVYQbf/zJmCzN2EnI5TZnh5peeWAItzXRB89mm3PnEmkwScbLRNFas3BL1G78vCZFU+DvngV1L4It3pzX3km5KMGmBYQNpvEVl8kA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J1LVcwus9tj9RsDcxgv1L/IEfLbfbtqc1uY+s2Y3iYY=;
 b=wUJiO1kdNwqHpQche72fuJ+chVta42wc68pl7drxTOdnDLRVfOk4MmrqZw4Tqi2F9p1P1XDHXESmB8IpoXf9dk+FfPHjHeQQfoPc/3CpHHTTDmaJoyhzzPyu9WQ66rDB0X5z7wg1oLGKXUemeV6zC6wkZhQrM/ybUdcghJqQ242Hm9aE2dc+G5UbCJ0pk/A7LH+6y/HqWw49XN3vISgp6t8OF6F/4QtbdqsF5/bzZ+6mu5rCwHIcmoHkUQ4RxRQgwcW22SOvXpQloTd95HVUkKrAjiIsrBn/atSbha9e4cZJkTa66Y0UJf3JXp8wJzdv/pL9UzfOhNI7d4gtVLkMng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J1LVcwus9tj9RsDcxgv1L/IEfLbfbtqc1uY+s2Y3iYY=;
 b=Av4A3imhEl0cTcwtcBDCJAjYR4ZyD9iWCodMrHvaj5dNq7bKGe+McfFsLMKHu3v8zCQfyu6kEGo1zvEs91BBR6WGAGuaaohyDwdUzcxBvxZDBNPlycQvdPMObVvJGdINIlSflJLS0AI1xB9BIvIPxW8AtdYECxZcDp+52s7+698=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from LV2PR01MB7792.prod.exchangelabs.com (2603:10b6:408:14f::10) by
 IA0PR01MB8278.prod.exchangelabs.com (2603:10b6:208:488::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8632.32; Tue, 15 Apr 2025 15:47:15 +0000
Received: from LV2PR01MB7792.prod.exchangelabs.com
 ([fe80::2349:ebe6:2948:adb9]) by LV2PR01MB7792.prod.exchangelabs.com
 ([fe80::2349:ebe6:2948:adb9%5]) with mapi id 15.20.8632.030; Tue, 15 Apr 2025
 15:47:14 +0000
From: D Scott Phillips <scott@os.amperecomputing.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
	James Clark <james.clark@linaro.org>,
	James Morse <james.morse@arm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Shiqi Liu <shiqiliu@hust.edu.cn>,
	Will Deacon <will@kernel.org>,
	Yicong Yang <yangyicong@hisilicon.com>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 1/2] arm64: errata: Work around AmpereOne's erratum AC03_CPU_36
Date: Tue, 15 Apr 2025 08:47:10 -0700
Message-ID: <20250415154711.1698544-1-scott@os.amperecomputing.com>
X-Mailer: git-send-email 2.48.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SA0PR11CA0124.namprd11.prod.outlook.com
 (2603:10b6:806:131::9) To LV2PR01MB7792.prod.exchangelabs.com
 (2603:10b6:408:14f::10)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR01MB7792:EE_|IA0PR01MB8278:EE_
X-MS-Office365-Filtering-Correlation-Id: 1927314e-71d7-426e-c4b8-08dd7c34caed
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|52116014|7416014|376014|1800799024|38350700014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?oJSBYwvvUHmAj5rTkxwf88rk8nxJXSV1mcpi4lkwDzNj2KBgyxdjduS8+rSq?=
 =?us-ascii?Q?eETmQ2AJp4MNI/+ScPERUN6ckm2vi+388HCQ/fhEBjqhypiHiFkIjlL0ybn1?=
 =?us-ascii?Q?QqwVF2gYWD+0I4/fBgOsXxASI1o0FLEFHGzK3EyKug+Mvq34pCZbhQEDle9H?=
 =?us-ascii?Q?rlZImGRnOuz9vxzOMfBsuFjAIsvIwTfAFTUihUWz+G0Rp3x3lRTX9HXAnUQL?=
 =?us-ascii?Q?bdCd5MJLStEE2YS9B644cM4rmdpeblfnQNy6uwA8mq+4Scs/5+8vA49z/irb?=
 =?us-ascii?Q?WlOqil9ookmL5AGLa7cmls085oOm30bhLgJojKnG000NNpN+fMOb7FARzTir?=
 =?us-ascii?Q?GbnDr+dwPvhcirp4qyl7PC8hz4h/uvdahEZ/TQvt+fV108PUUPZY3exkLqm8?=
 =?us-ascii?Q?AIhmT/RrGc+nvNN1DasNrY6EdFZhttluiIzX8mBk5YpOUdy95FhSiR8icw0H?=
 =?us-ascii?Q?sfYrmFaiAzK85hznMT7zB6J0Ib74K/b7YsZPcmTZrsot2wklOXt0WCq5TzoF?=
 =?us-ascii?Q?pFxtO7o41m5AQ7cND7uwm8UX1/kBi5mVSKNO2OzCGbwbR7SnwY8d5nFEKlaD?=
 =?us-ascii?Q?CA73fqynMYCzqeqgH0pYzaWNzrfJV/ku56L2wBECGs/gMubgFJE4mFzyHFKS?=
 =?us-ascii?Q?tvAyrLDIql3aFp4d+HoLAVQD/Ssiamg9ftNLXfOsEmklU+FdckoWtnmiGlyz?=
 =?us-ascii?Q?AA/PEn5YrvsXdKSVf9l9Rcz1CEImROMN3WqGja8Dwi84DatQJ3JHRRRBiWrc?=
 =?us-ascii?Q?MuuoTOrx9gV9pf1R/voATNaJ9IHDqW8Smcw7ru+sQ/4kAq1FdfNxvfZWHQkZ?=
 =?us-ascii?Q?oVUVp6cbvvQQTY2QXXHX9QKxJVqbOLXQ5GF96lqlHplEyLnw+TMJU2Y/C3Yq?=
 =?us-ascii?Q?urVLYXpdmKvYzaoit+S6jnr7Jf84Xs+4ztGPscKn9IPP/2ZqokOXRW82WJXa?=
 =?us-ascii?Q?LNlp5dbBSfCI76ttPhrmHoTar+k3TJb74nUq1oQhd14oXcZ9XMUGzussYKOi?=
 =?us-ascii?Q?uyYdNNla5/tP9EDIj5YOoiDfx0zfWdJVSyRRDARiTsNlp0yzJDsies/eulZd?=
 =?us-ascii?Q?O7spkMCagwTBR1Hx0r0If0Fsm85KNjaSb9UoBmfyTf0LKTa0/EyMp3U+Zm4X?=
 =?us-ascii?Q?RYPa3Z1RA/6wFEtmZV6vVdelW2kKbdj3zNvTFCLYWkh3c6uBV14lptrGlud1?=
 =?us-ascii?Q?h3qSb2rN6ZqhGzRplXqXPsYdq/4VSAoSd4FMxNHeq1y90zhC8Nk5EMVsgdqr?=
 =?us-ascii?Q?n6RgvGHhA8dGnWfILCD41K0RUFly43mLlPzEKAFl6ytnCwceH0Vg+HLo4Tu6?=
 =?us-ascii?Q?Vs5Q1J5rR4a4RPPeSTyQrtvj1zlEjCH3HmEiMRVZoeqrIRsXQp2o3a4PbHOz?=
 =?us-ascii?Q?QTwNk/jCmoh1F9kUjDCbjTjBMaZmxAGNF+VJHK/83f+gPA5g0S0vPAUSyClJ?=
 =?us-ascii?Q?faNTOtJcOJLgK8NPn01ldolJ/FpQSGu/g/zBhn/FHDFEB02ihzzoL1Ssq4QZ?=
 =?us-ascii?Q?XzNxyiACMEm5zUM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR01MB7792.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(52116014)(7416014)(376014)(1800799024)(38350700014)(921020);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Ld9kN76C3a3yvBWSFXvEYlxfXqVA8m8Ky3VAgvjsoSBhNLtPbKVMjNNvfTju?=
 =?us-ascii?Q?mRrg0ykeWhENSN5RqODb/ldvn3KBxLU8a9bFr8k5l0UpCb1mBzjbUJ7xlRLI?=
 =?us-ascii?Q?iEaCNI0cSI8a9mgxCgmSZjTZ4vUUCQsoohl/Yct0JmkykEA3GVaEgxFo5GWp?=
 =?us-ascii?Q?npU1H2N5bs7CulIS/SyU+kE1/9mwokKWt/DzB+91brAXVYugl68RYI0+uy0Q?=
 =?us-ascii?Q?9bVvuN1Pd7KdLz2qjrELWmE51muq7FyYBm3GLqy6j7HP774Lf3UPtuVBZVHE?=
 =?us-ascii?Q?IZCPkkMDlOCq3oHLcszb/tLL9lF1MNBhllGFxFflO050JTY9ZHXSF4kuEdml?=
 =?us-ascii?Q?bQXverv7AKX0mIWbLSCCfhtCsaosTq/wAZ4mXO67/SF7dzeavgfL1ARQDb/f?=
 =?us-ascii?Q?ALeQkhfg59fxGR2NcWPn43AIFPOUm1UdhNDCmRqwf8ktu5EYot53aIzSxY40?=
 =?us-ascii?Q?RMyibWQp1CUf35HiaWluIpA0rSbVYJzXUWyBPAoJmAHk3SfgnXAEjAESu0vV?=
 =?us-ascii?Q?XQcdj8dmF36a6ekbWyCGprEIY+fO35qXbiyUVC99UerSDn1ch/XD7/Nr2qey?=
 =?us-ascii?Q?ByA6xJzjKs/XVVT+EfgTJSDyDEay2Fz5Esdm0POsZQ6WUFw8viH+3Nobgym0?=
 =?us-ascii?Q?n5D8ztn2pfTgFY5dhetUuwpce/Z0SE6nrZ5IHMNWJt9oDBjuxacq/zhHCshk?=
 =?us-ascii?Q?jKciz1/gBrS+p3eBMuXiM1tBkMSV2E+Wqh9hYjQ8wVcRreJ9ZvkwADE4LuLd?=
 =?us-ascii?Q?DabHAIIwDNG4y+Aznv25F7StuFV2hWDKZz+GHJ64wazpcBEmYZ8fr9t4AwVA?=
 =?us-ascii?Q?SNPlLLDB0ne624fYV/CLjd5PVLLjG4wqGVx6kfj2fsFiY9x9Xwkf3pGajOpx?=
 =?us-ascii?Q?4Au7WWmBaOZMJHHAedsvz6vSnaTS8C25+UKkZ5pJI4MAbIuDvWYppGqCRTaV?=
 =?us-ascii?Q?8l4jYx962jos+xjiJ5SkbGQVwmjgD2GMtD6fOTUtavkRGwQaNYKVXRNfVCf3?=
 =?us-ascii?Q?R+bIal3bpl2WHvIiIRbbqZROCh+mceIkgUONGBTn7lKq3CX2qEg4H17gYK6p?=
 =?us-ascii?Q?9n6saL9CeuxOpC3aXZuprBbWXPiJh8MN2JCXqWp21NkzPM7X5rW8O3AqVH3f?=
 =?us-ascii?Q?vIEiBeu/v0ERHO8x6wGPzxbtjAyz804FzEBbSPJlKvQE/BffjQHJybQmsrJp?=
 =?us-ascii?Q?vc9klPGqebVsoNRpSnSugHDMAems/U/v9+Fd9oYi6sUGl1iAQPdqlFtynuW8?=
 =?us-ascii?Q?+dVPsPqvrhvkXCbUJDxWIirxhi1Y5mPtQmL21ANu2MYTADmyQsekkDhnl0Oh?=
 =?us-ascii?Q?LiRRvZLVgjkh0H3ayfVZrdGI9eoGph0SS+OwmemFQxRvas7yup5HdHy1CSsU?=
 =?us-ascii?Q?B7IVAd/4j5WFA50Un91G+JHDJFX6ykbT+TjU+7+QOk75Uk+7VJbGoBWd0UOF?=
 =?us-ascii?Q?6ch2sNHuL+1dZGATjFTLWSFOzFUbAb+G0qviGyF3hO/isr+aPBAYSwmdue0Y?=
 =?us-ascii?Q?J9elnnOWXuC+cx+Ke8+1zwO/2mpN2/G7i9wlb/uFKxr2qjJkjLBkm8MXRZS7?=
 =?us-ascii?Q?if/YTUAYMGWHjU5H+/X7RSP89+ndgBazQN5yAXXL2359E5OU3RYNTNjRCa0z?=
 =?us-ascii?Q?JL5cghPl6tscks9Tw71SvaQ=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1927314e-71d7-426e-c4b8-08dd7c34caed
X-MS-Exchange-CrossTenant-AuthSource: LV2PR01MB7792.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2025 15:47:14.2632
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NRBzqV9cuyEOMUhF2EoODeFZfcxBljFtYnk/FvQ0zg0IBND7UlmKpmnD7DC4AFtJ1VDmlUM74KYtku9pC3rxmdmnEiDnym9H7r3SWA84wN6L+urypdCe1bX6iIpSm5Rj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR01MB8278

AC03_CPU_36 can cause asynchronous exceptions to be routed to the wrong
exception level if an async exception coincides with an update to the
controls for the target exception level in HCR_EL2. On affected
machines, always do writes to HCR_EL2 with async exceptions blocked.

Signed-off-by: D Scott Phillips <scott@os.amperecomputing.com>
---
 arch/arm64/Kconfig              | 17 +++++++++++++++++
 arch/arm64/include/asm/sysreg.h | 18 ++++++++++++++++--
 arch/arm64/kernel/cpu_errata.c  | 14 ++++++++++++++
 arch/arm64/tools/cpucaps        |  1 +
 4 files changed, 48 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index a182295e6f08b..e5fd87446a3b8 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -445,6 +445,23 @@ menu "Kernel Features"
 
 menu "ARM errata workarounds via the alternatives framework"
 
+config AMPERE_ERRATUM_AC03_CPU_36
+        bool "AmpereOne: AC03_CPU_36: CPU can take an invalid exception, if an asynchronous exception to EL2 occurs while EL2 software is changing the EL2 exception controls."
+	default y
+	help
+	  This option adds an alternative code sequence to work around Ampere
+	  errata AC03_CPU_36 on AmpereOne.
+
+	  If an async exception happens at the same time as an update to the
+	  controls for the target EL for async exceptions, an exception can be
+	  delivered to the wrong EL. For example, an EL may be routed from EL2
+	  to EL1.
+
+	  The workaround masks all asynchronous exception types when writing
+	  to HCR_EL2.
+
+	  If unsure, say Y.
+
 config AMPERE_ERRATUM_AC03_CPU_38
         bool "AmpereOne: AC03_CPU_38: Certain bits in the Virtualization Translation Control Register and Translation Control Registers do not follow RES0 semantics"
 	default y
diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 2639d3633073d..e7781f7e7f7a7 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -1136,14 +1136,28 @@
 	__val;							\
 })
 
+#define __sysreg_is_hcr_el2(r)					\
+	(__builtin_strcmp("hcr_el2", __stringify(r)) == 0)
+#define __hcr_el2_ac03_cpu_36(r)				\
+	(IS_ENABLED(CONFIG_AMPERE_ERRATUM_AC03_CPU_36) &&	\
+	 __sysreg_is_hcr_el2(r) &&				\
+	 alternative_has_cap_unlikely(ARM64_WORKAROUND_AMPERE_AC03_CPU_36))
+
 /*
  * The "Z" constraint normally means a zero immediate, but when combined with
  * the "%x0" template means XZR.
  */
 #define write_sysreg(v, r) do {					\
 	u64 __val = (u64)(v);					\
-	asm volatile("msr " __stringify(r) ", %x0"		\
-		     : : "rZ" (__val));				\
+	if (__hcr_el2_ac03_cpu_36(r)) {				\
+		u64 __daif;					\
+		asm volatile("mrs %0, daif; msr daifset, #0xf;"	\
+			     "msr hcr_el2, %x1; msr daif, %0"	\
+		: "=&r"(__daif) : "rZ" (__val));		\
+	} else {						\
+		asm volatile("msr " __stringify(r) ", %x0"	\
+			     : : "rZ" (__val));			\
+	}							\
 } while (0)
 
 /*
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index b55f5f7057502..89be85bf631fd 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -549,6 +549,13 @@ static const struct midr_range erratum_spec_ssbs_list[] = {
 };
 #endif
 
+#ifdef CONFIG_AMPERE_ERRATUM_AC03_CPU_36
+static const struct midr_range erratum_ac03_cpu_36_list[] = {
+	MIDR_ALL_VERSIONS(MIDR_AMPERE1),
+	{},
+};
+#endif
+
 #ifdef CONFIG_AMPERE_ERRATUM_AC03_CPU_38
 static const struct midr_range erratum_ac03_cpu_38_list[] = {
 	MIDR_ALL_VERSIONS(MIDR_AMPERE1),
@@ -869,6 +876,13 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 		ERRATA_MIDR_RANGE_LIST(erratum_spec_unpriv_load_list),
 	},
 #endif
+#ifdef CONFIG_AMPERE_ERRATUM_AC03_CPU_36
+	{
+		.desc = "AmpereOne erratum AC03_CPU_36",
+		.capability = ARM64_WORKAROUND_AMPERE_AC03_CPU_36,
+		ERRATA_MIDR_RANGE_LIST(erratum_ac03_cpu_36_list),
+	},
+#endif
 #ifdef CONFIG_AMPERE_ERRATUM_AC03_CPU_38
 	{
 		.desc = "AmpereOne erratum AC03_CPU_38",
diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
index 772c1b008e437..f430fd5900d15 100644
--- a/arch/arm64/tools/cpucaps
+++ b/arch/arm64/tools/cpucaps
@@ -93,6 +93,7 @@ WORKAROUND_2077057
 WORKAROUND_2457168
 WORKAROUND_2645198
 WORKAROUND_2658417
+WORKAROUND_AMPERE_AC03_CPU_36
 WORKAROUND_AMPERE_AC03_CPU_38
 WORKAROUND_TRBE_OVERWRITE_FILL_MODE
 WORKAROUND_TSB_FLUSH_FAILURE
-- 
2.48.1

