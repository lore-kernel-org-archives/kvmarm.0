Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2129.outbound.protection.outlook.com [40.107.102.129])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4C59185941
	for <kvmarm@lists.linux.dev>; Tue, 27 Aug 2024 21:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.129
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724793432; cv=fail; b=H/CapQ13Babrv48V5QqcRRvjeQTI/wQDkkZ8ThyCmf6ITFjNSfYk29AODa+jhmyvecf0HMBLR7oeo2piWeMHzt2DyPpCLB3E4sH8BTTY3D5McRhadzEX8yuEiRHq1sW7tV1cvkb0YVek7c5KG9avO7jRNsQw4nLbFN120pgzITQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724793432; c=relaxed/simple;
	bh=/bMa7NQKiq7FaK49rIZ9IAe0KMfzrTU+SV1aINWvpDk=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=bEly9Vjf860ef16aw+y3c9mel0AKFBjkS1h5YQ42T7CWn6GHpXGgc+Nd8pRL07rKOCa844j04U+Uz2vARav7/pityURG8DjpxOOJW/5VY8ZzWgXiKF3XBj/2bQgze+vu3O0g5roVKaQY/x2NRx/pe3k3LTFeuBAh8p5dR23wmgg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com; spf=pass smtp.mailfrom=os.amperecomputing.com; dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b=u8AK1NBA; arc=fail smtp.client-ip=40.107.102.129
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b="u8AK1NBA"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=L4S5q6LG0ayXAcgoT5+hziHhF+ovIokZgrp1hA9fyMqYtGzU/n3lWvooSojQHXAGBvnRMW60mN4OCUkpaVyelknx5IjZaAWLSHzbGZLxYJs3hE4frwfMPPCvhs0+2gq99nByEMaE7qEaQmStEPHPnLhMGuFhBIsPCzG+QNFsTaLv55qhwxZmeXzVCL8OeWvIv7rjvm/CxAAtk9TJbPZJ7ypsA/LfppesZpHYiXYDijrHpZ4y+llbOYJ/uuZo8yj6hdzd3jza+qog80QBtVmgO71dOYu0RD/Ao40XhIItJfP/EsIT32rB2Vg/IOPe37SyU/AkH28gozo9TnX0U9QozA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rK6gW/WxiakV7SywqfO0Cnls+pg9dq+gDtMyCXBFuLY=;
 b=UJk4r6WqLCeQVskbEyksNQ6ERIPD2gDQ7Xc/0F9V9DwgvXy7uWrZLt5MKRU3Flt/ANGrVbBWydVEvUagmWLOXa7Z9OjrbWeTXCvsLRfWXLDnqvka4mTgmaleR9SOqOJWAL2cPBEhZHaxiD4lPZiI3eLYjHTIwGTuuBrum5Y9++cafhpCCGWG2ICPg0QDtlidryl0ye36DvCwr1eabehfluMITkdWMCTWTMLPwrg5WuiKyfs5DTHRxzp4SaJDn+wIqO73PieXeEPAR3T1PtfSeUHruuH6DN/JWzVqmq+bnGBeN8iBSPc0bV9olQyI317TTcpXmGcCpq7CP0rg5Yrffg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rK6gW/WxiakV7SywqfO0Cnls+pg9dq+gDtMyCXBFuLY=;
 b=u8AK1NBA42GXmoUCQI3dwb4NODi2SrFCr48onkOWkfDdwS7U8sHfQ44pFoe9Mzo7N3HpP6lrdmGIt2GWOmAapYO/jaUF1DZK1+9Zu3ws5zYa68gHsLW+oi6/jft3WU9A6tO2+opXRSPu0RqJTl0O1Iun05rOPkRQba27cBSRYxU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from LV2PR01MB7792.prod.exchangelabs.com (2603:10b6:408:14f::10) by
 DM8PR01MB7126.prod.exchangelabs.com (2603:10b6:8:4::11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7897.26; Tue, 27 Aug 2024 21:17:05 +0000
Received: from LV2PR01MB7792.prod.exchangelabs.com
 ([fe80::2349:ebe6:2948:adb9]) by LV2PR01MB7792.prod.exchangelabs.com
 ([fe80::2349:ebe6:2948:adb9%6]) with mapi id 15.20.7897.021; Tue, 27 Aug 2024
 21:17:05 +0000
From: D Scott Phillips <scott@os.amperecomputing.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Mark Rutland <mark.rutland@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	linux-arm-kernel@lists.infradead.org,
	linux-doc@vger.kernel.org
Cc: Besar Wicaksono <bwicaksono@nvidia.com>,
	Easwar Hariharan <eahariha@linux.microsoft.com>,
	Rob Herring <robh@kernel.org>,
	Andre Przywara <andre.przywara@arm.com>,
	linux-kernel@vger.kernel.org,
	patches@amperecomputing.com,
	Marc Zyngier <maz@kernel.org>,
	kvmarm@lists.linux.dev,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v2] arm64: errata: Enable the AC03_CPU_38 workaround for ampere1a
Date: Tue, 27 Aug 2024 14:17:01 -0700
Message-ID: <20240827211701.2216719-1-scott@os.amperecomputing.com>
X-Mailer: git-send-email 2.46.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH7P221CA0004.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:510:32a::14) To LV2PR01MB7792.prod.exchangelabs.com
 (2603:10b6:408:14f::10)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR01MB7792:EE_|DM8PR01MB7126:EE_
X-MS-Office365-Filtering-Correlation-Id: da4cf427-2962-4df2-1a04-08dcc6dd99bb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|52116014|7416014|376014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?j3TWgoJoHz8IZnR4mJfjRcL5CKlergXizoDa8IbN2dn9xZYYjYnNYSqlp2IF?=
 =?us-ascii?Q?Vf83rDr2AnWmYORpwAEle4An87uaF2RtM0XC14k9rpEPst9qTvIH7zIIwoYM?=
 =?us-ascii?Q?3GD0/Kkd+vDHbpy7j4HWNyr5hpZR/6YynxXgzwmFGw2Vw45+IPt3rpFM2ZVq?=
 =?us-ascii?Q?yWfF9sEHh5zLVRuctS150ziWPj/Us9+ctLxWBAW9irp8sMmViQcM5ySluooU?=
 =?us-ascii?Q?ZqJZFF/6o42W7QuZN25jCyRD2f5FQK9xt3ELJyz4vXq2CVR2dzfebxFbPgaW?=
 =?us-ascii?Q?E6sp7i8p/2FN8BOewboQBSVa9yKwNMwNbQiKtivGUcS55aDOBHAqtGAtHk4Y?=
 =?us-ascii?Q?dFab6Fw5eRL65CKMdnY4n4GWWuCw3dSb1Z5xKEmXPgKfQBunEJl+haDAtDWV?=
 =?us-ascii?Q?x+blf5on5Gv8k1Fyca8pkFFbvLQuK/lrVMWqukdKO/M0YG3Uc7TLSuTHJICC?=
 =?us-ascii?Q?YPzhSNUZa7l3oS+dfj+qTS7O+mzw0f/0qitagHAOHnX9ZedKv0cSZJJhI1oN?=
 =?us-ascii?Q?77THeOGA4hF9mnxgOG9jYUupqhQF+Mh+DrEkFhyWaSizSKIhQu9WqcLexjjO?=
 =?us-ascii?Q?gYxfvSYG7T2b7C4WugZLnfFg/6rnUViUPlFjmqgHCGhdcalmw0TbWS/f9aZM?=
 =?us-ascii?Q?G17ncaYnFMoc/htVXC3zRbVpMmkCEUDYEOTL6Qz26cgcQ24NT6ZJT1yYWisG?=
 =?us-ascii?Q?Y66fCz6IeYEvUzaUUDj/4oTe+quHJZbADl8H+Z0BOFIoykPBDsk6b3Xh4o9T?=
 =?us-ascii?Q?p5DzQHsijuR+sbOhR4eF4cBoNXxiseRxTEA25dCKONHyABPgSdAK8JLPkzM1?=
 =?us-ascii?Q?SmYorjCPpHdJ6H8GCM0vkeWjDWQBQ8JnSeacUtFRD5Jc9e3bLzH1/69odDPr?=
 =?us-ascii?Q?44Cwkaq97/VBC7QV1Hz8ARZNDsfhGNmEwPCw2SHrqzQMReeC5Va1iM2AK8JI?=
 =?us-ascii?Q?Ws8Ibzr8fAfGZDZury6Z88wZW6PwXF+NaMaD1KdT58d/wja8blA+XzKf5saA?=
 =?us-ascii?Q?O/0gwfPowaUNeU8/Oq5AZSexcqq+lOhoGESdrVNJv3y1yRZdkhCjvN54mLJ2?=
 =?us-ascii?Q?6xLXLfGoSyPlT2hn3ETNKglokAmclZ58nKY8psjiyOnEWFgIFsjG0GwR2orp?=
 =?us-ascii?Q?RsCfqxo7Knt3XmCM5VfiqtAwfmv4oxVX3gFJFUd21xo+SG8osV/5Hw5SyEbT?=
 =?us-ascii?Q?lTWLG4X/xLW64ymuNxbf/++tzqLyWJzRPlaXv7nUHs1Oi6a6ATx9uWSVKbBy?=
 =?us-ascii?Q?VX/YMG0OH+2FqdsR+rgfLLLhAJDLz6Wfkb61kssuVneqWNJADq2TWhV9g8ls?=
 =?us-ascii?Q?Bvq5SaWnGrmw5kRgovXlUTRoZKSfwGR1KV6RCxZw1e17FD6B60AvMwX+kwH6?=
 =?us-ascii?Q?aqd6Qa2QgCq6xm2/aB/OGGQmkoBFCfEwEzeDJ1LMZLr4NI/04Q=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR01MB7792.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(52116014)(7416014)(376014)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?KZ2gOmmQbYniB7TsiylnVzd4uBfoP5Pj4PG3+OSkWG/4HGKQZzxhTcm4NPZu?=
 =?us-ascii?Q?lCsphr+BJ+fzUEIsQoUd0Ja8THnpj7P8Ig5cEbNO2KCx4QhrQeilS0yRRr3F?=
 =?us-ascii?Q?eUSlHyvcvsSgsUDVUB368cvRJ51oBWv3UBb0Ta8GS7zt3Dwiz50zjjaUi2c+?=
 =?us-ascii?Q?xKr9TNLaiCzGZeizD7bpnL9GPvuz/ksSDPNUzYBErfAsNk1iW8L+ljUSkZdF?=
 =?us-ascii?Q?1zt0ncDfk4mtU1hu1JD3m/DrnOQkFuq5z2+zV2NQJ44uP2NJDFpGAXkbJKAg?=
 =?us-ascii?Q?5I74Km+30sR0Guyy+pfZJHzyAeHufolDP9fMIhaG9U8HXY77dx54pmC8exjl?=
 =?us-ascii?Q?ZN5x+aKbHuUHHD8qrEBn/TPYFzd+3a0saVBxF1zOAJC2kp9wfTlwPXQZhv94?=
 =?us-ascii?Q?rIVuHJlWyaZtK9fojslvQZDSDh+bpCp726we5mSgkXYPSfKrUvgs1a3Z8QkX?=
 =?us-ascii?Q?5u80mvkT3JOoY0CHfZIFEfp3RCuzY2bqwRunVCuJkFj6dA7rzB5Jyxq7IvHv?=
 =?us-ascii?Q?Do8XGSA5vIvx450t3CEDSPfr3NJsKO1hCApRwG6alOAYanjusrbYlTtgPEs4?=
 =?us-ascii?Q?m31DlNO2Nr/LWt+1a6arYxPnLSOrJi2z3ehf6LITpATi/kcZVdFgQDMxEoL5?=
 =?us-ascii?Q?yfvXfB9y827lWSsL9M53DN16u8Xw86VqjEoHRZjmHeSkoe8rKQtskGLGJoPC?=
 =?us-ascii?Q?EFctK5Sb+7xgpjMegqgAykvNuVdweRxDKBck+ONNWLUS6fJe7jwPGzVGrrno?=
 =?us-ascii?Q?5yirYpb8Dh72xZ+HBZBq280s1B7EJwlKukY+VbOZTCy2XpRoWCngBBleZXJi?=
 =?us-ascii?Q?dweu7Rxacu73ZQAKJNAblffvs60prOd8nRCWcYwatrNaEEY3QQr4v5TGD9wg?=
 =?us-ascii?Q?BaitjDi+sZxFDfvP+bK+woAviLKo9eHqwW9sNHPkYxzpNa8z6Ks5bXavde2w?=
 =?us-ascii?Q?pm4RPs90yQKdSUKYMj1X96SLt4PB4jtWgs7WiEJB/YvUYo0bMtAaobwB+C09?=
 =?us-ascii?Q?ukb/OOFTF0Uwum9QAhTA3Mxgy9kwzb5frKgY3ljI9RJayqqVpD9A07Wm6nZQ?=
 =?us-ascii?Q?+AaoNqFCgu/pTkxZMyl3uwAfPV5xeZsY0W5tsz27iahSscuKcegw4ATM67XT?=
 =?us-ascii?Q?PJCrzbuf7J/Qn27f5159CW66Zg51vuaiHkMztAmg7vtP733He/7I3O1E6qF6?=
 =?us-ascii?Q?igIr17g4riHnzbnkqhOnZxRtDUn4LSKt4Lv9uc37hB8lGYCPLBPsUA3cL+4R?=
 =?us-ascii?Q?E6yAVngt2AhLnkKyLMhPt+WmZ1W8CyPvHlTLD9KyiZfS0NlKuc8Ra3B700cj?=
 =?us-ascii?Q?3ET5+bxzNphl4njwlYYY+dVdAf3klPBBLSWZKUKbsV4ucOAMv8LtPD2mJ06I?=
 =?us-ascii?Q?GWHF8SnWmdyNE8GTyfVnZBiCG4IZAPELG5mL3sRE3qH80TiWYreox75Mid8j?=
 =?us-ascii?Q?GDRYBYZw8n0D5stw+Uv6iiJ9SEbCGQqQvWOx9arbSaEFoMVIBonrd/zYJhDi?=
 =?us-ascii?Q?dRtpd+SZMToX999NUSFuZRG2jCPAmT2wrXeAESo53meVTuH2nMPHmX+aw70a?=
 =?us-ascii?Q?36w9kmftd2ef6dGarGmghtkwoxIJ0D8QeaKPv460MMVy9UTW0i5uwS/P25ev?=
 =?us-ascii?Q?F+Tm8pWGIqbTHlkWP73MHl4=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da4cf427-2962-4df2-1a04-08dcc6dd99bb
X-MS-Exchange-CrossTenant-AuthSource: LV2PR01MB7792.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2024 21:17:05.1942
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bTEUv3WMiN4KoQdZDhGtPdEycrKKxDydB90vfQeYl/CyClrHT2MMqkfaYsL7t1LEGTS0gZ+K1OXC4ZpLNrD4nR+E6uERgutn+NvYdSlDTNCsYYmcj70EL/E49jWr5gi2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR01MB7126

The ampere1a cpu is affected by erratum AC04_CPU_10 which is the same
bug as AC03_CPU_38. Add ampere1a to the AC03_CPU_38 workaround midr list.

Signed-off-by: D Scott Phillips <scott@os.amperecomputing.com>
---
Changes since v1:
 - Link: https://lore.kernel.org/lkml/20240826215933.1263453-1-scott@os.amperecomputing.com/
 - Used ERRATA_MIDR_RANGE_LIST so both midrs are properly covered. (Oliver)

 Documentation/arch/arm64/silicon-errata.rst |  2 ++
 arch/arm64/Kconfig                          |  2 +-
 arch/arm64/include/asm/cputype.h            |  2 ++
 arch/arm64/kernel/cpu_errata.c              | 10 +++++++++-
 4 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/Documentation/arch/arm64/silicon-errata.rst b/Documentation/arch/arm64/silicon-errata.rst
index 50327c05be8d1..39c52385f11fb 100644
--- a/Documentation/arch/arm64/silicon-errata.rst
+++ b/Documentation/arch/arm64/silicon-errata.rst
@@ -55,6 +55,8 @@ stable kernels.
 +----------------+-----------------+-----------------+-----------------------------+
 | Ampere         | AmpereOne       | AC03_CPU_38     | AMPERE_ERRATUM_AC03_CPU_38  |
 +----------------+-----------------+-----------------+-----------------------------+
+| Ampere         | AmpereOne AC04  | AC04_CPU_10     | AMPERE_ERRATUM_AC03_CPU_38  |
++----------------+-----------------+-----------------+-----------------------------+
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-A510     | #2457168        | ARM64_ERRATUM_2457168       |
 +----------------+-----------------+-----------------+-----------------------------+
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index a2f8ff354ca67..c8cba20a4d11b 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -423,7 +423,7 @@ config AMPERE_ERRATUM_AC03_CPU_38
 	default y
 	help
 	  This option adds an alternative code sequence to work around Ampere
-	  erratum AC03_CPU_38 on AmpereOne.
+	  errata AC03_CPU_38 and AC04_CPU_10 on AmpereOne.
 
 	  The affected design reports FEAT_HAFDBS as not implemented in
 	  ID_AA64MMFR1_EL1.HAFDBS, but (V)TCR_ELx.{HA,HD} are not RES0
diff --git a/arch/arm64/include/asm/cputype.h b/arch/arm64/include/asm/cputype.h
index 5fd7caea44193..5a7dfeb8e8eb5 100644
--- a/arch/arm64/include/asm/cputype.h
+++ b/arch/arm64/include/asm/cputype.h
@@ -143,6 +143,7 @@
 #define APPLE_CPU_PART_M2_AVALANCHE_MAX	0x039
 
 #define AMPERE_CPU_PART_AMPERE1		0xAC3
+#define AMPERE_CPU_PART_AMPERE1A	0xAC4
 
 #define MICROSOFT_CPU_PART_AZURE_COBALT_100	0xD49 /* Based on r0p0 of ARM Neoverse N2 */
 
@@ -212,6 +213,7 @@
 #define MIDR_APPLE_M2_BLIZZARD_MAX MIDR_CPU_MODEL(ARM_CPU_IMP_APPLE, APPLE_CPU_PART_M2_BLIZZARD_MAX)
 #define MIDR_APPLE_M2_AVALANCHE_MAX MIDR_CPU_MODEL(ARM_CPU_IMP_APPLE, APPLE_CPU_PART_M2_AVALANCHE_MAX)
 #define MIDR_AMPERE1 MIDR_CPU_MODEL(ARM_CPU_IMP_AMPERE, AMPERE_CPU_PART_AMPERE1)
+#define MIDR_AMPERE1A MIDR_CPU_MODEL(ARM_CPU_IMP_AMPERE, AMPERE_CPU_PART_AMPERE1A)
 #define MIDR_MICROSOFT_AZURE_COBALT_100 MIDR_CPU_MODEL(ARM_CPU_IMP_MICROSOFT, MICROSOFT_CPU_PART_AZURE_COBALT_100)
 
 /* Fujitsu Erratum 010001 affects A64FX 1.0 and 1.1, (v0r0 and v1r0) */
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index f6b6b45073571..dfefbdf4073a6 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -456,6 +456,14 @@ static const struct midr_range erratum_spec_ssbs_list[] = {
 };
 #endif
 
+#ifdef CONFIG_AMPERE_ERRATUM_AC03_CPU_38
+static const struct midr_range erratum_ac03_cpu_38_list[] = {
+	MIDR_ALL_VERSIONS(MIDR_AMPERE1),
+	MIDR_ALL_VERSIONS(MIDR_AMPERE1A),
+	{},
+};
+#endif
+
 const struct arm64_cpu_capabilities arm64_errata[] = {
 #ifdef CONFIG_ARM64_WORKAROUND_CLEAN_CACHE
 	{
@@ -772,7 +780,7 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 	{
 		.desc = "AmpereOne erratum AC03_CPU_38",
 		.capability = ARM64_WORKAROUND_AMPERE_AC03_CPU_38,
-		ERRATA_MIDR_ALL_VERSIONS(MIDR_AMPERE1),
+		ERRATA_MIDR_RANGE_LIST(erratum_ac03_cpu_38_list),
 	},
 #endif
 	{
-- 
2.46.0

