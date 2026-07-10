Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11021096.outbound.protection.outlook.com [40.107.208.96])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7D384279E0
	for <kvmarm@lists.linux.dev>; Fri, 10 Jul 2026 22:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.96
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783722106; cv=fail; b=QkAe7zhEIdS55zRUqHU4AodaiOholYZdd/qxcH4ujp1POW/Qc1u7mmluAv7JRi2MbP9Q0ZJzDYhzZr+H7mE29Y50nU+KhvwBZ52iPlGhEP52sHPE1wOG1/XkAeC8wahjdXyQ8BtPWSGKAYHqIF+MsXudxV4l5k94aME8AWp2EJ8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783722106; c=relaxed/simple;
	bh=QFMibYrC8AF5WassChOa9HdVCtR48XXjhPoop4VTpbs=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=U+vpvVTMffaP2f/tXeNGC6D4qAVVMJSj0Ak2oQoZ/8jORk50Hnye6MMl23O+23glB21hfPHYstzo7YV63qOnEl8Mqf7sFuEWVB19w4AVpaxTgyUaAH5vHUd4WFtwOCxeYt038xAMMcGMzQQ1bv7GDcDHsu630ILhsjOzhJ/zxLU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com; spf=pass smtp.mailfrom=os.amperecomputing.com; dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b=Ng1b+ffJ; arc=fail smtp.client-ip=40.107.208.96
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b="Ng1b+ffJ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ms6/60rsYcPJ6mSMzhNBdriiMTIy/a/lbS0XmrfZbbPgZl2eZAY6ewDRGKh0EkBIH0kyG+8r+cY6mQM8at/HPI2KyAgEBrSl1TsY7b4S7ExeQ1Fq4dNfQxHGDqlPXPpG+weWYi6Ar2tqSxiqowo+qBk8el5j85GeyWJQZ4wiqpBYXP6QWQs+QnxEbULfeKT1zCoHRrncVyuXTCR/MaUC729sOAWh2ZB2Gh5v2fLnD862ku5e52FUdb/tTGmPer0Shmn75TJ2rw798CtqIR1ubLU6HKtZDy+m4BojXqbVk0et/xJV0JsuCAGUEQP7c9q35gDsC1La+shMB//qlQoQ7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oLSjCHcLO8LSoL/wQ8Lt06TeK8Aa8h06+W/d/ABAWPc=;
 b=d14DCcC8UWwsIJ2pJ+92f9MONV8Sn6BQLloWRoQ4bQpgNSV2lZu4o6vu0cuT0MTSfWXYOBRFx53QDhkbFf4bIWI5zeO+0oCffBGkr4voyUTeduKtRCZZg7jL47AtuHluu/lGjHlchlbxpPi0t/T0kXpHx5yD+kR01PXbPRcFly/m+BQnyLAXKvX+aqON0I8vl6JYZa0HtIJS8AeQceXUAUeo1z5ciqUgGBv11y8e6nISoC/l6197NzbnOaimtZAi+1z+f6Jdbt3Fip9gPxD57FmJWXx4lyA7AV6lLJB3FIxNhHOXbaHRsCH7eNB7PZK+gNIpgBMtLl6U1nEl7CBsyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oLSjCHcLO8LSoL/wQ8Lt06TeK8Aa8h06+W/d/ABAWPc=;
 b=Ng1b+ffJPGqxkn5T5Y4CggYVSYJC/zV934e2vxa+Wr/nU8sJArtz/eIbd7cVtNa59tz3Y5HQdW5iUjBp7xXESE2NY4AanptzPB/nKxRFcdgmueUWEasQlgR4CaDxYgCEzL2zgiJ4nYp0yPqUS760VDGbXS4pKF7294sGMeKnLm4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from DS7PR01MB7782.prod.exchangelabs.com (2603:10b6:8:7d::17) by
 CO1PR01MB8769.prod.exchangelabs.com (2603:10b6:303:275::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.181.17; Fri, 10 Jul 2026 22:21:39 +0000
Received: from DS7PR01MB7782.prod.exchangelabs.com
 ([fe80::f34b:b148:1bd:402b]) by DS7PR01MB7782.prod.exchangelabs.com
 ([fe80::f34b:b148:1bd:402b%3]) with mapi id 15.21.0181.014; Fri, 10 Jul 2026
 22:21:38 +0000
From: D Scott Phillips <scott@os.amperecomputing.com>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Cc: Mark Rutland <mark.rutland@arm.com>,
	Zeng Heng <zengheng4@huawei.com>,
	Wei Xu <xuwei5@hisilicon.com>,
	Vladimir Murzin <vladimir.murzin@arm.com>,
	Lucas Wei <lucaswei@google.com>,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Sascha Bischoff <Sascha.Bischoff@arm.com>,
	Yicong Yang <yangyicong@hisilicon.com>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev
Subject: [PATCH] arm64: errata: Mitigate AmpereOne erratum AC03_CPU_57 and AC04_CPU_29
Date: Fri, 10 Jul 2026 15:21:28 -0700
Message-ID: <20260710222128.416581-1-scott@os.amperecomputing.com>
X-Mailer: git-send-email 2.52.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0247.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0::12) To DS7PR01MB7782.prod.exchangelabs.com
 (2603:10b6:8:7d::17)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR01MB7782:EE_|CO1PR01MB8769:EE_
X-MS-Office365-Filtering-Correlation-Id: fe37eef6-8e53-40f9-ec86-08deded19bfc
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|23010399003|11063799006|6133799003|18002099003|56012099006|55112099003|921020;
X-Microsoft-Antispam-Message-Info:
	j+EdWUzRyXJX9ilZXDEGND197Y87kKLVU+H3teg7iIkCCZumAL4x0BcT/kjfFXiPGzpKImiUUmi6tv0b7aQSChQzTmn+Rf+74SNu845vaaVjc/CBhlbiFEQkYm3IKmyisjSQoDZ5lbGWMjtwwOLc4Uw0S6NZ0F4eX45sqR7s47ryjz5GwnvTKRDCcPjAMGUgbMyyJqZIWOQ8wS3o8NEwAkn9w+la9L+hXcP3P6ts5Zido6dHeB+h2ayTDIiVUHl3rwWF/NDkd1epYFuCXRqEkQaHERUjuEgV62Ch/IgiVNtBUUIAhuUNJuab2zkJg6Zq4Fz2jAJkJ+wUjkOp6eEV7wzko8X4j9GYslwcn9rUpm+irCPNWVDE6o+ZCtkt3jMa5V0X3sI7kaJlA9/DoCU7+KM597dljuSPA6I6oRdJlIKyzCkY6D2QWkA4q2Ns7LbZndr5481O3PEmWOZ2GrT3p9rO5n+PeZ4xk+Ms3jf6aRhet8WWFFKXka8jUucezxARd5LstREhlIyJ8gYGU0Qs6WvC3zbTF7CpGo26Wbws1iUCYv9SFnR/J0wPfdWMi+Hy2Mj7bivQCBvoIHXo5B53gChUugYjXbZTWwyuHFcJ9Z741+bQ1u6hQDf7qtm+Tf5VYJ7QHHTK7JAamAf5+yF19zlJyshUPauFzZyYCJSefbya1uKYCbk8+m3Ksd3V9gPB5xKXCvc+ejaJpUBDvh05/g==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR01MB7782.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(23010399003)(11063799006)(6133799003)(18002099003)(56012099006)(55112099003)(921020);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?n9+So/4nv0jSTL7c8dZu6JRQ1TraPErTAsU6+f5/ruwDki1dIvkEpuIMej36?=
 =?us-ascii?Q?x27bnWiiD5YZRkLuo8z+o/6UTpNUj8Eg51b8XWVd+7nfEdKoW5p1RxAj314x?=
 =?us-ascii?Q?gUqicuk6LMsVJhKk/pPa87C0KxNGbqtwR6mdrsUFDVXDD2kISGYGlT7sLoHd?=
 =?us-ascii?Q?PWUPUIZ8UqkIZ+7UjQAyq7Zsa+uioZ/ln7YdT9X7ZNueoCCzmNr6+ALw6ZJ5?=
 =?us-ascii?Q?lbmmBFm5dbTgWGJJ0v8UJag+6p0wiPZ+r1BPSkLnPLpeEtlduOSt0FcePnp4?=
 =?us-ascii?Q?Vz7rCCaU862UpOCZBBTkjcMQbHM5j2XupPQTBz+FPZRjjFfLxIve64I0cQpV?=
 =?us-ascii?Q?xl42RVj4V/PAuxE/5mVhGcTjU3JEf6/HBExmPyoDHq19T2EpPuPgkcFzk+hY?=
 =?us-ascii?Q?Rf3C6W361I5mz7itGyo81lWLTeIw4eiKkQ50JF3TIsZDGA1pBbtJW0Kra3Sx?=
 =?us-ascii?Q?bkWkuwj0SAYZuoUXya+B2ZOZeNAXpzITGrIrJC2yRZcSGY/GOk6uVH7ZevHz?=
 =?us-ascii?Q?WdTBXpOCxzAM7FdKrAdmAXbUJFxBWxlZunUnP1zyewUxo1O/yHUbCeAFOnZv?=
 =?us-ascii?Q?nKi6EnmreIE9VPMhr1o1KiiMHxf9xQfHLji5oO3HdH2qStzRaz9ciAywaqll?=
 =?us-ascii?Q?MKggNQZiu3a9TQVt2iyaMvTKJ1NXRBc40sbGD00T9ljC1q4Q1+dfGuo+5X7N?=
 =?us-ascii?Q?R+msJFXXxCfDl8/+/rW3pVCrtMUSrQj7uxLjxw2md+wuAkLS072TiuwCxRqV?=
 =?us-ascii?Q?+4j+h5gbwD5d4//HRhAP8u7gYVGKPyJKTseq16wG8tbZKL7MOlrY1OKj1a8u?=
 =?us-ascii?Q?S8Ppz/m+v+V40R2e+b2VvLt5eBOjuciGRC3KKTZiAqucsXh8rneOkik6nFmc?=
 =?us-ascii?Q?1kGHYDMbDFujeMX8JrtI24HSZtCICIoSWk21Fpdb++kDyxZ47FzICGgg80T6?=
 =?us-ascii?Q?xjAaOxZxOZi8XAa3OrWs3JoEUXaCGE2QJgl3hlPllcBkTGUqsbutqzk/Rjpu?=
 =?us-ascii?Q?EZPoaoSu1/qIcicn+y6BrSEGlJasTPPv+6hze1SsHwQtMDayEmnZLNe0td+r?=
 =?us-ascii?Q?fkzwj/ru/zGr3ctuKMWaiVbXO4ep3Agb5xinE2JtKavT+D1Xu9C9L2BgdadA?=
 =?us-ascii?Q?FMyhl2Aqj04OOOStJEHWJ5qIW0tw7/7LnRQGaUXbaBOg2IYEYEZeCBlo+7rJ?=
 =?us-ascii?Q?W3n9b1vYUayc8A7rmyNgLL9OT5ZRuh/7vwAb58KMaHEzoU535WdGmD4JR8Z/?=
 =?us-ascii?Q?m2n/tjK8UutPuszcdiflIOl72rcz4prW1K0p4r3qdtMvNiHLaB3jVlSxp9/o?=
 =?us-ascii?Q?oWwQj9J1tsWXPYB12U+2gGFSkU2hlq6JigCTMBe6F579Ir7YKaqImWupnVZG?=
 =?us-ascii?Q?e4Z7MUNIOkNWkL6fy8ZaBeA6ztxEnh3ClRRTR8uwK3oV9fSPGXfL96r6+DJo?=
 =?us-ascii?Q?qY88ZCFojA2aOza+Yq8spqceRhmj7K9Dt0wHsqHJuWBo5Hs8Ol5HF0fwjXvJ?=
 =?us-ascii?Q?98wsRR66g9b1N9kUmjHNqq9FIv6yymKGgzvKiLptm6TwpOXkIoTz6iwHSiEA?=
 =?us-ascii?Q?oO5orszGTPf0trNhzJ7d3LtMPV9Ibb5NP0kngABzgIwxV1PSFhZDeF4kGUvb?=
 =?us-ascii?Q?v+a3esP0Q4JC6EDKgiZSwzZBCkmZJm4Mabjr+U67u3xaRQt+9x9eiyhC4/Zf?=
 =?us-ascii?Q?99mJKOLS9YKPmGTUFVIvzlnVP5EHp11Vj5vsBZT3hu/qeV67eYQJdZ4Omhmz?=
 =?us-ascii?Q?vnGmGuRNc9WbaoOShHH3JRt/KV3xBXQ=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe37eef6-8e53-40f9-ec86-08deded19bfc
X-MS-Exchange-CrossTenant-AuthSource: DS7PR01MB7782.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2026 22:21:38.5059
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XfDmAL5EcEEaNP2DemUK/VNNHgFUvN2kR1MOXIqVZ97+wY/2cBHHDCDWxgAPAzipcP8E3z7lMkXdiqRJmbEd53yFmIVTDuuBu+yMxpTIn7BR0PA4JdAUjhNX9szZlrji
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR01MB8769

On AmpereOne, deactivating a physical interrupt through ICC_DIR_EL1 or
ICC_EOIRx_EL1 (depending on EOImode) which is not active, but is the
highest priority pending interrupt causes the cpu to lose the interrupt
pending state and also prevents the delivery of future interrupts.

Work around this in the vgic, avoiding the cpu issue.

Signed-off-by: D Scott Phillips <scott@os.amperecomputing.com>
---

Hi Marc, we've tracked down the nested virt hang reported
previously[1] to a cpu erratum in AmpereOne[2].

Here I'm just sort of parroting the change you had posted for
debugging. I'm not familiar with the vgic logic well enough to know if
this change is sufficient and doesn't have some unintended
consequences. I guess read this more are as "I've tested this and I'm
not seeing it hang now."

Sorry for sending this half-baked, I didn't want to further delay the
errata details on my ongoing vgic education. I'm happy to take any
advice you can give, otherwise I'll continue familiarizing myself and
will hopefully later have a patch which I can actually claim I think is
correct.

[1]: https://lore.kernel.org/linux-arm-kernel/87ecjybz30.wl-maz@kernel.org/

[2]: https://amperecomputing.com/products/developer-errata

The updates with AC03_CPU_57 and AC04_CPU_29 have not yet been
published at the time I'm writing this. They should be coming
soon. I've reproduced the full entries from those two coming documents
collapsed together below:

| {AC03_CPU_57, AC04_CPU_29}: Deactivation of the non-active, highest
| priority pending interrupt prevents further interrupt delivery.
|
| Functional Unit: CPU
|
| Category: 4
|
| Affected Version(s): AmpereOne AC03 A0, AmpereOne AC03 B0
| Affected Version(s): AmpereOne AC04 A0, AmpereOne AC04_1 A0
|
| Fixed Version(s): Open
|
| Overview:
|
| If software directly deactivates a physical interrupt which is not
| in the active state, and the interrupt is also currently the highest
| priority pending interrupt, then interrupt delivery will cease on
| that PE. Deactivation can happen either through ICC_EOIRx_EL1 if
| ICC_CTLR_EL1.EOIMode==0, or through ICC_DIR_EL1 if
| ICC_CTLR_EL1.EOIMode==1. Deactivation of virtual interrupts that are
| redirected through ICV_ registers will not cause this issue, even
| when the virtual interrupt deactivation triggers a physical
| interrupt deactivation through ICH_LR<n>_EL2.HW=1.
|
| This has been observed with Nested Virtualization starting with
| Linux-KVM v6.19.
|
| Impact:
|
| Physical interrupts will not be delivered after the deactivation of
| the non-active, highest priority pending interrupt. A core may
| appear to be hung.
|
| Workaround:
|
| Software must only deactivate interrupts which are currently active


 Documentation/arch/arm64/silicon-errata.rst |  4 ++++
 arch/arm64/Kconfig                          | 17 +++++++++++++++++
 arch/arm64/kernel/cpu_errata.c              | 15 +++++++++++++++
 arch/arm64/kvm/vgic/vgic-v3.c               |  4 +++-
 arch/arm64/tools/cpucaps                    |  1 +
 5 files changed, 40 insertions(+), 1 deletion(-)

diff --git a/Documentation/arch/arm64/silicon-errata.rst b/Documentation/arch/arm64/silicon-errata.rst
index 014aa1c215a16..89130404ce572 100644
--- a/Documentation/arch/arm64/silicon-errata.rst
+++ b/Documentation/arch/arm64/silicon-errata.rst
@@ -55,10 +55,14 @@ stable kernels.
 +----------------+-----------------+-----------------+-----------------------------+
 | Ampere         | AmpereOne       | AC03_CPU_38     | AMPERE_ERRATUM_AC03_CPU_38  |
 +----------------+-----------------+-----------------+-----------------------------+
+| Ampere         | AmpereOne       | AC03_CPU_57     | AMPERE_ERRATUM_AC03_CPU_57  |
++----------------+-----------------+-----------------+-----------------------------+
 | Ampere         | AmpereOne AC04  | AC04_CPU_10     | AMPERE_ERRATUM_AC03_CPU_38  |
 +----------------+-----------------+-----------------+-----------------------------+
 | Ampere         | AmpereOne AC04  | AC04_CPU_23     | AMPERE_ERRATUM_AC04_CPU_23  |
 +----------------+-----------------+-----------------+-----------------------------+
+| Ampere         | AmpereOne AC04  | AC04_CPU_29     | AMPERE_ERRATUM_AC03_CPU_57  |
++----------------+-----------------+-----------------+-----------------------------+
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-A510     | #2457168        | ARM64_ERRATUM_2457168       |
 +----------------+-----------------+-----------------+-----------------------------+
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index b3afe0688919b..ee5421283d8df 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -436,6 +436,23 @@ config AMPERE_ERRATUM_AC03_CPU_38
 
 	  If unsure, say Y.
 
+config AMPERE_ERRATUM_AC03_CPU_57
+	bool "AmpereOne: AC03_CPU_57: Deactivation of the non-active, highest priority pending interrupt prevents further interrupt delivery."
+	default y
+	help
+	  This option adds an alternative code sequence to work around Ampere
+	  errata AC03_CPU_57 and AC04_CPU_29 on AmpereOne.
+
+	  Deactivating a physical interrupt through ICC_DIR_EL1 or
+	  ICC_EOIR1_EL1 (depending on EOImode) which is not active, but is the
+	  highest priority pending interrupt causes the cpu to lose the
+	  interrupt pending state and also prevents the delivery of future
+	  interrupts.
+
+	  The workaround is for KVM to not deactivate interrupts for nested vgics.
+
+	  If unsure, say Y.
+
 config AMPERE_ERRATUM_AC04_CPU_23
         bool "AmpereOne: AC04_CPU_23:  Failure to synchronize writes to HCR_EL2 may corrupt address translations."
 	default y
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index 1995e1198648e..9b03dccd55e09 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -631,6 +631,14 @@ static const struct midr_range erratum_ac03_cpu_38_list[] = {
 };
 #endif
 
+#ifdef CONFIG_AMPERE_ERRATUM_AC03_CPU_57
+static const struct midr_range erratum_ac03_cpu_57_list[] = {
+	MIDR_ALL_VERSIONS(MIDR_AMPERE1),
+	MIDR_ALL_VERSIONS(MIDR_AMPERE1A),
+	{},
+};
+#endif
+
 #ifdef CONFIG_AMPERE_ERRATUM_AC04_CPU_23
 static const struct midr_range erratum_ac04_cpu_23_list[] = {
 	MIDR_ALL_VERSIONS(MIDR_AMPERE1A),
@@ -987,6 +995,13 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 		ERRATA_MIDR_RANGE_LIST(erratum_ac03_cpu_38_list),
 	},
 #endif
+#ifdef CONFIG_AMPERE_ERRATUM_AC03_CPU_57
+	{
+		.desc = "AmpereOne erratum AC03_CPU_57",
+		.capability = ARM64_WORKAROUND_AMPERE_AC03_CPU_57,
+		ERRATA_MIDR_RANGE_LIST(erratum_ac03_cpu_57_list),
+	},
+#endif
 #ifdef CONFIG_AMPERE_ERRATUM_AC04_CPU_23
 	{
 		.desc = "AmpereOne erratum AC04_CPU_23",
diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index 9e841e7afd4a7..8f1d10872360c 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -275,7 +275,9 @@ void vgic_v3_deactivate(struct kvm_vcpu *vcpu, u64 val)
 		lr = vgic_v3_compute_lr(vcpu, irq) & ~ICH_LR_ACTIVE_BIT;
 	}
 
-	if (lr & ICH_LR_HW)
+	if ((lr & ICH_LR_HW) &&
+	    !(cpus_have_final_cap(ARM64_WORKAROUND_AMPERE_AC03_CPU_57) &&
+	      vgic_state_is_nested(vcpu)))
 		vgic_v3_deactivate_phys(FIELD_GET(ICH_LR_PHYS_ID_MASK, lr));
 
 	vgic_v3_fold_lr(vcpu, lr);
diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
index 9b85a84f6fd49..7a63f3f7c982b 100644
--- a/arch/arm64/tools/cpucaps
+++ b/arch/arm64/tools/cpucaps
@@ -109,6 +109,7 @@ WORKAROUND_2658417
 WORKAROUND_4193714
 WORKAROUND_4311569
 WORKAROUND_AMPERE_AC03_CPU_38
+WORKAROUND_AMPERE_AC03_CPU_57
 WORKAROUND_AMPERE_AC04_CPU_23
 WORKAROUND_TRBE_OVERWRITE_FILL_MODE
 WORKAROUND_TSB_FLUSH_FAILURE
-- 
2.52.0

