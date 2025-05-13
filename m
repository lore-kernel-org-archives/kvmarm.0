Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2137.outbound.protection.outlook.com [40.107.95.137])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 211248479
	for <kvmarm@lists.linux.dev>; Tue, 13 May 2025 18:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.137
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747161924; cv=fail; b=Cr2/0flkPfZ0NHdOuOE2wd/KQCe6aBq69dDtnR9I6sYzwzoy4nt9b4BS5bzVH9zrZKuE3vaFdMpeaApMdfyhVSer5yUnnc++Bb2WeavMLVEKZLbYqyp3u7Bu0cxSGcxjfoKJ3pYAP1SNf94cBMGdF6Cnt0+yDd5s8VT12I/OIH8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747161924; c=relaxed/simple;
	bh=GdCwJqTJ8HZ+KNCowkbIsoELsia+Hrxn23OqFibgmEA=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=ZNOKvm8ozxzAzkrLaqfBTEiK+51WIF1e3jP/o2yOV7tlpvwxNXt+3NIU+LJHfvfX6vvnZtQDRlqY2htqoNfRmdAswf9YU9cI471lJFR9ajxV0sgOq8KSfJ74YXMXhxvIVB1xn1mzlhXACd/Yl25Y27Eyp9U56FHhawCew40A7Z0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com; spf=pass smtp.mailfrom=os.amperecomputing.com; dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b=fgvgo96e; arc=fail smtp.client-ip=40.107.95.137
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b="fgvgo96e"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Rd48BDRVUmCLYkvyIKg2aUTREL27huLhpcPSppYbwfAg0rZzuFP8CajBRGfj9M2lx8pb7D5iJElF8pSSnlvYHA/b5JRVXBBxopJRLBdFE3vluz93C4pRIz2GWHZMCYIN4fncREIBNgpjm2/8eD0S7gYj6nOQgK4oXhKTQE3rFUTge8MhhSThi5pSWnuchaFb82ReekNImO3dMIx6FnJZdshzdeOmW8uMvPaQIC6AcntgnZOuBP1oAsh6UO918t0dCw5ELrtJqEyE3cdIG/m9RjowDUU3ekwA4r6IQyFeE26pA7SiX1v13GhaEXp8Qsd4Fikvj6TSZg8w4sQqZdL+pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=habv9dJAtv3q/6ngT6h1GC0sW3HIM3hff8eY8oqAhkg=;
 b=AQkSCY2M7JifcY8U+0TQa2FyN/nFDE8Hqhubc/QxUVp8mHsYLG5+MmQ2cjOe/wlalqehmeTJJ/dSmsZoXsWaXBmEnUsso8DI0AOFXJh6rEAmDqV/h2UU70vhAovQtQ0QAMAF+bJejTrR/wzLwLbXYgKhCh85Yp2LapkJpDai6xrgbnwphtU3fQ2q5i98O+Mg5bkwO+eli1lh75SdUgE5Yj117NGTQE6xl0nR1tq6UVPS6LGl24FInSCAocrN/cSf6UATDivnMNYOXZeuWWThXj67uIpig3lbUDi52+dkohrisX1alt5XhFTpbxrxiFUNP5K8aiIUOt1KYBKcEzk9tQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=habv9dJAtv3q/6ngT6h1GC0sW3HIM3hff8eY8oqAhkg=;
 b=fgvgo96eEtR2MRJC8F0wCjA7BKbfLaMrElRhSgAytVL+tAYbvtu0hGQD90uVuYE4hcQx/Nz5ElFR22n5uGPsXP3Sj/HA6YDc8GKNUyQebot5ao9io70TE8M6+RrWEPHDSz1WLgFJLqXmENkLoLsH9fx0KRgsCPA1OlY9YY9hmrc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from LV2PR01MB7792.prod.exchangelabs.com (2603:10b6:408:14f::10) by
 DS2PR01MB9229.prod.exchangelabs.com (2603:10b6:8:279::5) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8722.29; Tue, 13 May 2025 18:45:17 +0000
Received: from LV2PR01MB7792.prod.exchangelabs.com
 ([fe80::2349:ebe6:2948:adb9]) by LV2PR01MB7792.prod.exchangelabs.com
 ([fe80::2349:ebe6:2948:adb9%5]) with mapi id 15.20.8722.027; Tue, 13 May 2025
 18:45:17 +0000
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
	"Rob Herring  (Arm)" <robh@kernel.org>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Shiqi Liu <shiqiliu@hust.edu.cn>,
	Will Deacon <will@kernel.org>,
	Yicong Yang <yangyicong@hisilicon.com>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4] arm64: errata: Work around AmpereOne's erratum AC04_CPU_23
Date: Tue, 13 May 2025 11:45:14 -0700
Message-ID: <20250513184514.2678288-1-scott@os.amperecomputing.com>
X-Mailer: git-send-email 2.48.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR02CA0023.namprd02.prod.outlook.com
 (2603:10b6:610:4e::33) To LV2PR01MB7792.prod.exchangelabs.com
 (2603:10b6:408:14f::10)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR01MB7792:EE_|DS2PR01MB9229:EE_
X-MS-Office365-Filtering-Correlation-Id: c1f4b771-c43c-4e2e-fba6-08dd924e4e56
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|52116014|376014|1800799024|366016|38350700014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?vrrfTrF+7xwJy2mL6eXUQKTTpfo0vqqZ4CkdrEuS6hCRyMWjAJCWMbejq+YI?=
 =?us-ascii?Q?IRvlc/hkXE6CYEvqVjFPw1VDlHzH4s5wI3Gmpw5+DxUY8yeV+VCox3/lAqKX?=
 =?us-ascii?Q?atHhUp0wBOk1cWwwd78i9IfVjGPLHl4q2uvcZUS7QQAx5zUCt9W5xgBBoVSG?=
 =?us-ascii?Q?asTNkZRjVD7mOb1mWgGf39183ExRRxs8VV2mLae3nWFnjrX/vB0Y1gFoAuMG?=
 =?us-ascii?Q?b//37Siwcvbg4al83cHZrARpWPJqTuIe6XR/SOnxomDVECR+T8knR2v7u6X2?=
 =?us-ascii?Q?Olwog3kNy8FHvyHru2OhqbTO12sCbS77jH2khmJK+jkV4mxiRjqBmlv/EXA6?=
 =?us-ascii?Q?Dk8rrSJ5quPA/3unk858l+9M6pDWeGb5ZJexGYAzVZ0KKTk6ZoUEaEiMvM/Q?=
 =?us-ascii?Q?IjhSdBJWO2FS2v1rpxOdM9fi33gTEIJPcqQ1HtIvHMYEhyo5JyIrgwlRjOP9?=
 =?us-ascii?Q?5Xm2BgsmAApsfdVZYMsAyev+Q4cFnBNHAvPangXN1SB19XHIWZX00DGSzLWi?=
 =?us-ascii?Q?VLIfEmxzp5KFz+D6Im5xpSsvLiEM4AiEzME0TycV+EKz++QN7ZBmm130oCaJ?=
 =?us-ascii?Q?Y4RwMPN67b4NuPU/vrryN7XQ/QTEwL8wOW1nilln3qploHAhjJ+NuihYWv11?=
 =?us-ascii?Q?OWxWYhhccu8v6kLLtWQhSNfjQrAWf1wUytr6+OkGf6TrmR0sp/UkQdu9w0Jy?=
 =?us-ascii?Q?M63vIQ7Rd55MQTAl1owdl9YwyHI/XgU/NsDC+qs3/rYxXXVCz8GLB0k3TVlD?=
 =?us-ascii?Q?Y68BOGbh8DMbwjsqGXD9u7E4+d7P9p9+3SENxE8C6e0cN+/Nt8EEv+K0/Rr/?=
 =?us-ascii?Q?c0Kj6JQy3LP/XqErySLNgKUdv9eiddYcLqUlbyA1O5Pcm/c/fgmR5mIQFpn3?=
 =?us-ascii?Q?ttUscRN3wmoIqfnJKLFx0XWInx0mtSxG4mThFEMipxAv20cK+YHEeUV1fo7W?=
 =?us-ascii?Q?UV5zKWs3K1+47UqBR6dW77dvO4+6kj6q93E+mh0T4SEFBJJTh/g3ERJ2S+y1?=
 =?us-ascii?Q?vDbGit9bVb9ALnxJvTG1gjL2juDzmqooCkjNWd1aZIFsnfy6Xx49eR0j3f8p?=
 =?us-ascii?Q?JnAPUGNcIzWy4fvkPm5leHiBysG9PxyNuSqtx9qcqb/OT/tEvHsJ3JxVI4Ok?=
 =?us-ascii?Q?Ndv94jLwuaslYhHHj10zFDq6F7XrdwM0k8AwW55W+u11gdUlPiBoBjVKJ09x?=
 =?us-ascii?Q?mIEwf5XtAY7bsNGrBjjZpu+giYnqELr7T52zkHRY3k4IdnYsK+bZFrjyDdIG?=
 =?us-ascii?Q?afblXYmU6PfcqhbcbSe9E7O8AB7KKbth9kzbVwhiKj8DpYv45HiHxtarKBMa?=
 =?us-ascii?Q?HnAFI/fFzwiZRDaz6ZgAX7UJXD+ljBQ9OZuuUEPUYOdU+YpDNMGLad2yadpD?=
 =?us-ascii?Q?L+AvMNXfElXC2Gk7b/c49/7yiN1ugaxKayRxphzdi07DLlyUrIWR3REyqWb7?=
 =?us-ascii?Q?WGSbkcN2SXbNRpVL0SgkMh389tqjrO2LZk/7M9NABthzabbPfegI/C91SFI+?=
 =?us-ascii?Q?rY7UwbpZYToGRfQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR01MB7792.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(52116014)(376014)(1800799024)(366016)(38350700014)(921020);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?GgX4mFzos1J6Km51f8/j0aywUS+tg5/NF2SP1mI883gFSGb5dXnJkGS6zFfL?=
 =?us-ascii?Q?GgIXjLGH4TlupLOIuPp+KVSoQPtUOB9SdDxrv0sQia0EtoWgcqkfIhWfijwp?=
 =?us-ascii?Q?KWLmZDInzi8c+Zen06yyikNuqGD6+FJG8/XZDmE6XuVycbS2CCBgGfw4EEPw?=
 =?us-ascii?Q?5Zki7zyNBiBYPgOddQIqQYGa9kgToVh77HY8Ga0iFt5V+JJoRvNO/ZtPMYya?=
 =?us-ascii?Q?S4zrO6vKfJWpXtCZ7TCvDRfUni9sO/dLRmcvS4iWZ5Es07Q8TBiWP2mgZiqL?=
 =?us-ascii?Q?+tyfsDYDX2+NXqCk2lxg2nuq31M0Wrveau6lDYif5p3nGPqUyVruUKJ0Qelg?=
 =?us-ascii?Q?MtrP7Sjig4jK/Mn7atpTROBTtYh794oSyv4sgoEBBA5e4pnzugWV7ZAS25Dr?=
 =?us-ascii?Q?TNV1paNaFMNnixJJEFE9vI25BbfKu4ul8TiZsatcAbF2l3ORjaWXaP233Ag6?=
 =?us-ascii?Q?Z3mVenOq2V/cSjlB6UI7yNcX8IH1cf4NeC+4GuJxjdojZSEs7SSfX5DsObDY?=
 =?us-ascii?Q?b5VOlaRWscEABhnb4EFcwjMg8Af0jPXbv653bVKIcpk19Kc/k3m9b0b6Hcr2?=
 =?us-ascii?Q?QL7NfyOO4Z8VKG6BCz1VcRpgeZLDWn7/l830eMlAXxfYnGRaS57Xt8sL3TAF?=
 =?us-ascii?Q?Nyp3FIkUMEXN+DsIW/7rziRuUTrmT5FArvMrMyRdxo2J8MqYBCmrLpjc5yhy?=
 =?us-ascii?Q?WZbX9hu+83Lqs0e+ggHr3cBBLXNteOqPdK9MxvdxaLyqG1TNsoy8usOItkY0?=
 =?us-ascii?Q?qX+bLupswCFTjP6VwfLH0ZJ9hHBetS8bsOYJCtKia15mdJrMmwmTMzd4fbgx?=
 =?us-ascii?Q?aKt9+AGBv+3aM0JbtWiIjbpjmmb+HBQJybKIhR/3nwCObARD4Bsw4ZDUM/OV?=
 =?us-ascii?Q?Y8nTSZoi6At0FK/GBdguh5KPpt9ifpRzOFu6NByU8id8cm7abNXJz1DO9CQv?=
 =?us-ascii?Q?xo5rb15Qky+Jlr/GThcNuqUM/vAT96bQFMZZTiUA9FBSm34YdweQ641AeOs9?=
 =?us-ascii?Q?mRWf86yovd7vP2t/QuA8sf4JrjbaI2KGjPGjEaGb6xys0KGDIuVnMdYDVE7P?=
 =?us-ascii?Q?RxpHsWtBBw4aXsDxEQQ7qRDfCeLG1l4vk2HXczJWSWQj6tOIu4cd9dBQBIVn?=
 =?us-ascii?Q?hj35IIQ+GSRZhVpAd55eYAM9Hq94nmF1VotETAVT4CWAKXR2423k1vH/Mf0B?=
 =?us-ascii?Q?JWrGThYaRJ8tbPlBvj6Zha1gzHHDUqeP72VSyLqMFphesN2hk9+YJ2FJ/UGP?=
 =?us-ascii?Q?j5Hs9nNKC7Eom5C/DXQdcm6vpMHOlCfY9FkxWGG648RlygYf/H60lMV3Pc9/?=
 =?us-ascii?Q?0HPVlNspkUgvFzNgxNyxmU92ySyz0DI55zaNE/9R6boDLj3m2JoGv8WYBucu?=
 =?us-ascii?Q?OtDUSVTeeWWxBe4l5XfOpIFjMUqvE/ZWducG/aEwXQGXsL0elrV59eNf4/op?=
 =?us-ascii?Q?xoXvm42lY/zh6jDoseUFvUDxn+4Ug7FFT+b7n16eX5Ra4pa3Jw5KuPbptGRv?=
 =?us-ascii?Q?u+8bi4qUHKGYc0ab8swWJz/UAz0VBt0S4Ba2fdPkUb/0LLZejJJCLuR6G3pZ?=
 =?us-ascii?Q?B8Mi5BuEXBSWnlkyHhh8zzMPd46Vy7S/FkbbuScKp+RZPJWO6h4Ey23HCzuX?=
 =?us-ascii?Q?nfX7V6NECBfnA7d52gEIxWc=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1f4b771-c43c-4e2e-fba6-08dd924e4e56
X-MS-Exchange-CrossTenant-AuthSource: LV2PR01MB7792.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2025 18:45:17.7694
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i09mhM6x+eTm3xv6u83o+3Tr52G9kuGg1dCOOsJXb2VzzW2dtG5fn9pavFEpzYazehgvL7dhTWV3CkBy/CRkzpujvm4jE8LiEAb3zjqd/+Kkiwek3yx6R8vPIKSwOvVB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS2PR01MB9229

On AmpereOne AC04, updates to HCR_EL2 can rarely corrupt simultaneous
translations for data addresses initiated by load/store instructions.
Only instruction initiated translations are vulnerable, not translations
from prefetches for example. A DSB before the store to HCR_EL2 is
sufficient to prevent older instructions from hitting the window for
corruption, and an ISB after is sufficient to prevent younger
instructions from hitting the window for corruption.

Signed-off-by: D Scott Phillips <scott@os.amperecomputing.com>
Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
---
v3: https://lore.kernel.org/kvmarm/20250508210009.428998-1-scott@os.amperecomputing.com/
Changes since v3:
 - Added entry in silicon-errata.rst (Marc)

v2: https://lore.kernel.org/kvmarm/20250425024741.1309893-1-scott@os.amperecomputing.com/
Changes since v2:
 - Apply the workaround before alternatives are applied (Marc)
 - Also catch stores to HCR_EL2 in assembly files (Marc)
 - Added a sysreg_clear_set_hcr() helper for the HCR_EL2 fiddling in
   vgic-v3-sr.c that I had previously missed.

v1: https://lore.kernel.org/kvmarm/20250415154711.1698544-2-scott@os.amperecomputing.com/
Changes since v1:
 - Add a write_sysreg_hcr() helper (Oliver)
 - Add more specific wording in the errata description (Oliver & Marc)

 Documentation/arch/arm64/silicon-errata.rst |  2 ++
 arch/arm64/Kconfig                          | 17 +++++++++++++
 arch/arm64/include/asm/el2_setup.h          |  2 +-
 arch/arm64/include/asm/hardirq.h            |  4 +--
 arch/arm64/include/asm/sysreg.h             | 27 +++++++++++++++++++++
 arch/arm64/kernel/cpu_errata.c              | 14 +++++++++++
 arch/arm64/kernel/hyp-stub.S                |  2 +-
 arch/arm64/kvm/at.c                         |  8 +++---
 arch/arm64/kvm/hyp/include/hyp/switch.h     |  2 +-
 arch/arm64/kvm/hyp/nvhe/host.S              |  2 +-
 arch/arm64/kvm/hyp/nvhe/hyp-init.S          |  4 +--
 arch/arm64/kvm/hyp/nvhe/mem_protect.c       |  2 +-
 arch/arm64/kvm/hyp/nvhe/switch.c            |  2 +-
 arch/arm64/kvm/hyp/vgic-v3-sr.c             |  4 +--
 arch/arm64/kvm/hyp/vhe/switch.c             |  2 +-
 arch/arm64/kvm/hyp/vhe/tlb.c                |  4 +--
 arch/arm64/tools/cpucaps                    |  1 +
 17 files changed, 80 insertions(+), 19 deletions(-)

diff --git a/Documentation/arch/arm64/silicon-errata.rst b/Documentation/arch/arm64/silicon-errata.rst
index f968c13b46a78..b18ef4064bc04 100644
--- a/Documentation/arch/arm64/silicon-errata.rst
+++ b/Documentation/arch/arm64/silicon-errata.rst
@@ -57,6 +57,8 @@ stable kernels.
 +----------------+-----------------+-----------------+-----------------------------+
 | Ampere         | AmpereOne AC04  | AC04_CPU_10     | AMPERE_ERRATUM_AC03_CPU_38  |
 +----------------+-----------------+-----------------+-----------------------------+
+| Ampere         | AmpereOne AC04  | AC04_CPU_23     | AMPERE_ERRATUM_AC04_CPU_23  |
++----------------+-----------------+-----------------+-----------------------------+
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-A510     | #2457168        | ARM64_ERRATUM_2457168       |
 +----------------+-----------------+-----------------+-----------------------------+
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index a182295e6f08b..3ae4e80e3002b 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -464,6 +464,23 @@ config AMPERE_ERRATUM_AC03_CPU_38
 
 	  If unsure, say Y.
 
+config AMPERE_ERRATUM_AC04_CPU_23
+        bool "AmpereOne: AC04_CPU_23:  Failure to synchronize writes to HCR_EL2 may corrupt address translations."
+	default y
+	help
+	  This option adds an alternative code sequence to work around Ampere
+	  errata AC04_CPU_23 on AmpereOne.
+
+	  Updates to HCR_EL2 can rarely corrupt simultaneous translations for
+	  data addresses initiated by load/store instructions. Only
+	  instruction initiated translations are vulnerable, not translations
+	  from prefetches for example. A DSB before the store to HCR_EL2 is
+	  sufficient to prevent older instructions from hitting the window
+	  for corruption, and an ISB after is sufficient to prevent younger
+	  instructions from hitting the window for corruption.
+
+	  If unsure, say Y.
+
 config ARM64_WORKAROUND_CLEAN_CACHE
 	bool
 
diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/asm/el2_setup.h
index ebceaae3c749b..2500fd0a1f66a 100644
--- a/arch/arm64/include/asm/el2_setup.h
+++ b/arch/arm64/include/asm/el2_setup.h
@@ -38,7 +38,7 @@
 
 	orr	x0, x0, #HCR_E2H
 .LnVHE_\@:
-	msr	hcr_el2, x0
+	msr_hcr_el2 x0
 	isb
 .endm
 
diff --git a/arch/arm64/include/asm/hardirq.h b/arch/arm64/include/asm/hardirq.h
index cbfa7b6f2e098..77d6b8c63d4e6 100644
--- a/arch/arm64/include/asm/hardirq.h
+++ b/arch/arm64/include/asm/hardirq.h
@@ -41,7 +41,7 @@ do {									\
 									\
 	___hcr = read_sysreg(hcr_el2);					\
 	if (!(___hcr & HCR_TGE)) {					\
-		write_sysreg(___hcr | HCR_TGE, hcr_el2);		\
+		write_sysreg_hcr(___hcr | HCR_TGE);			\
 		isb();							\
 	}								\
 	/*								\
@@ -82,7 +82,7 @@ do {									\
 	 */								\
 	barrier();							\
 	if (!___ctx->cnt && !(___hcr & HCR_TGE))			\
-		write_sysreg(___hcr, hcr_el2);				\
+		write_sysreg_hcr(___hcr);				\
 } while (0)
 
 static inline void ack_bad_irq(unsigned int irq)
diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 2639d3633073d..7284828f0dc9e 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -1091,6 +1091,15 @@
 	__emit_inst(0xd5000000|(\sreg)|(.L__gpr_num_\rt))
 	.endm
 
+	.macro	msr_hcr_el2, reg
+#if IS_ENABLED(CONFIG_AMPERE_ERRATUM_AC04_CPU_23)
+	dsb	nsh
+	msr	hcr_el2, \reg
+	isb
+#else
+	msr	hcr_el2, \reg
+#endif
+	.endm
 #else
 
 #include <linux/bitfield.h>
@@ -1178,6 +1187,13 @@
 		write_sysreg(__scs_new, sysreg);			\
 } while (0)
 
+#define sysreg_clear_set_hcr(clear, set) do {				\
+	u64 __scs_val = read_sysreg(hcr_el2);				\
+	u64 __scs_new = (__scs_val & ~(u64)(clear)) | (set);		\
+	if (__scs_new != __scs_val)					\
+		write_sysreg_hcr(__scs_new);			\
+} while (0)
+
 #define sysreg_clear_set_s(sysreg, clear, set) do {			\
 	u64 __scs_val = read_sysreg_s(sysreg);				\
 	u64 __scs_new = (__scs_val & ~(u64)(clear)) | (set);		\
@@ -1185,6 +1201,17 @@
 		write_sysreg_s(__scs_new, sysreg);			\
 } while (0)
 
+#define write_sysreg_hcr(__val) do {					\
+	if (IS_ENABLED(CONFIG_AMPERE_ERRATUM_AC04_CPU_23) &&		\
+	   (!system_capabilities_finalized() ||				\
+	    alternative_has_cap_unlikely(ARM64_WORKAROUND_AMPERE_AC04_CPU_23))) \
+		asm volatile("dsb nsh; msr hcr_el2, %x0; isb"		\
+			     : : "rZ" (__val));				\
+	else								\
+		asm volatile("msr hcr_el2, %x0"				\
+			     : : "rZ" (__val));				\
+} while (0)
+
 #define read_sysreg_par() ({						\
 	u64 par;							\
 	asm(ALTERNATIVE("nop", "dmb sy", ARM64_WORKAROUND_1508412));	\
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index 6b0ad5070d3e0..59d723c9ab8f5 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -557,6 +557,13 @@ static const struct midr_range erratum_ac03_cpu_38_list[] = {
 };
 #endif
 
+#ifdef CONFIG_AMPERE_ERRATUM_AC04_CPU_23
+static const struct midr_range erratum_ac04_cpu_23_list[] = {
+	MIDR_ALL_VERSIONS(MIDR_AMPERE1A),
+	{},
+};
+#endif
+
 const struct arm64_cpu_capabilities arm64_errata[] = {
 #ifdef CONFIG_ARM64_WORKAROUND_CLEAN_CACHE
 	{
@@ -875,6 +882,13 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 		.capability = ARM64_WORKAROUND_AMPERE_AC03_CPU_38,
 		ERRATA_MIDR_RANGE_LIST(erratum_ac03_cpu_38_list),
 	},
+#endif
+#ifdef CONFIG_AMPERE_ERRATUM_AC04_CPU_23
+	{
+		.desc = "AmpereOne erratum AC04_CPU_23",
+		.capability = ARM64_WORKAROUND_AMPERE_AC04_CPU_23,
+		ERRATA_MIDR_RANGE_LIST(erratum_ac04_cpu_23_list),
+	},
 #endif
 	{
 		.desc = "Broken CNTVOFF_EL2",
diff --git a/arch/arm64/kernel/hyp-stub.S b/arch/arm64/kernel/hyp-stub.S
index ae990da1eae5a..36e2d26b54f5c 100644
--- a/arch/arm64/kernel/hyp-stub.S
+++ b/arch/arm64/kernel/hyp-stub.S
@@ -97,7 +97,7 @@ SYM_CODE_START_LOCAL(__finalise_el2)
 2:
 	// Engage the VHE magic!
 	mov_q	x0, HCR_HOST_VHE_FLAGS
-	msr	hcr_el2, x0
+	msr_hcr_el2 x0
 	isb
 
 	// Use the EL1 allocated stack, per-cpu offset
diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index f74a66ce3064b..9c13e70fadf5e 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -516,7 +516,7 @@ static void __mmu_config_save(struct mmu_config *config)
 
 static void __mmu_config_restore(struct mmu_config *config)
 {
-	write_sysreg(config->hcr,	hcr_el2);
+	write_sysreg_hcr(config->hcr);
 
 	/*
 	 * ARM errata 1165522 and 1530923 require TGE to be 1 before
@@ -1267,7 +1267,7 @@ static u64 __kvm_at_s1e01_fast(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
 
 skip_mmu_switch:
 	/* Clear TGE, enable S2 translation, we're rolling */
-	write_sysreg((config.hcr & ~HCR_TGE) | HCR_VM,	hcr_el2);
+	write_sysreg_hcr((config.hcr & ~HCR_TGE) | HCR_VM);
 	isb();
 
 	switch (op) {
@@ -1350,7 +1350,7 @@ void __kvm_at_s1e2(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
 		if (!vcpu_el2_e2h_is_set(vcpu))
 			val |= HCR_NV | HCR_NV1;
 
-		write_sysreg(val, hcr_el2);
+		write_sysreg_hcr(val);
 		isb();
 
 		par = SYS_PAR_EL1_F;
@@ -1375,7 +1375,7 @@ void __kvm_at_s1e2(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
 		if (!fail)
 			par = read_sysreg_par();
 
-		write_sysreg(hcr, hcr_el2);
+		write_sysreg_hcr(hcr);
 		isb();
 	}
 
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index b741ea6aefa58..06aa37dbc957d 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -301,7 +301,7 @@ static inline void ___activate_traps(struct kvm_vcpu *vcpu, u64 hcr)
 	if (cpus_have_final_cap(ARM64_WORKAROUND_CAVIUM_TX2_219_TVM))
 		hcr |= HCR_TVM;
 
-	write_sysreg(hcr, hcr_el2);
+	write_sysreg_hcr(hcr);
 
 	if (cpus_have_final_cap(ARM64_HAS_RAS_EXTN) && (hcr & HCR_VSE))
 		write_sysreg_s(vcpu->arch.vsesr_el2, SYS_VSESR_EL2);
diff --git a/arch/arm64/kvm/hyp/nvhe/host.S b/arch/arm64/kvm/hyp/nvhe/host.S
index 58f0cb2298cc2..eef15b374abb0 100644
--- a/arch/arm64/kvm/hyp/nvhe/host.S
+++ b/arch/arm64/kvm/hyp/nvhe/host.S
@@ -124,7 +124,7 @@ SYM_FUNC_START(__hyp_do_panic)
 	/* Ensure host stage-2 is disabled */
 	mrs	x0, hcr_el2
 	bic	x0, x0, #HCR_VM
-	msr	hcr_el2, x0
+	msr_hcr_el2 x0
 	isb
 	tlbi	vmalls12e1
 	dsb	nsh
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-init.S b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
index f8af11189572f..aada42522e7be 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-init.S
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
@@ -100,7 +100,7 @@ SYM_CODE_START_LOCAL(___kvm_hyp_init)
 	msr	mair_el2, x1
 
 	ldr	x1, [x0, #NVHE_INIT_HCR_EL2]
-	msr	hcr_el2, x1
+	msr_hcr_el2 x1
 
 	mov	x2, #HCR_E2H
 	and	x2, x1, x2
@@ -262,7 +262,7 @@ reset:
 
 alternative_if ARM64_KVM_PROTECTED_MODE
 	mov_q	x5, HCR_HOST_NVHE_FLAGS
-	msr	hcr_el2, x5
+	msr_hcr_el2 x5
 alternative_else_nop_endif
 
 	/* Install stub vectors */
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 31173c6946951..d1488d4e51413 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -309,7 +309,7 @@ int __pkvm_prot_finalize(void)
 	 */
 	kvm_flush_dcache_to_poc(params, sizeof(*params));
 
-	write_sysreg(params->hcr_el2, hcr_el2);
+	write_sysreg_hcr(params->hcr_el2);
 	__load_stage2(&host_mmu.arch.mmu, &host_mmu.arch);
 
 	/*
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 7d2ba6ef02618..4024fafbe3594 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -142,7 +142,7 @@ static void __deactivate_traps(struct kvm_vcpu *vcpu)
 
 	__deactivate_traps_common(vcpu);
 
-	write_sysreg(this_cpu_ptr(&kvm_init_params)->hcr_el2, hcr_el2);
+	write_sysreg_hcr(this_cpu_ptr(&kvm_init_params)->hcr_el2);
 
 	__deactivate_cptr_traps(vcpu);
 	write_sysreg(__kvm_hyp_host_vector, vbar_el2);
diff --git a/arch/arm64/kvm/hyp/vgic-v3-sr.c b/arch/arm64/kvm/hyp/vgic-v3-sr.c
index 50aa8dbcae75b..f8a91780e49a9 100644
--- a/arch/arm64/kvm/hyp/vgic-v3-sr.c
+++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c
@@ -446,7 +446,7 @@ u64 __vgic_v3_get_gic_config(void)
 	if (has_vhe()) {
 		flags = local_daif_save();
 	} else {
-		sysreg_clear_set(hcr_el2, 0, HCR_AMO | HCR_FMO | HCR_IMO);
+		sysreg_clear_set_hcr(0, HCR_AMO | HCR_FMO | HCR_IMO);
 		isb();
 	}
 
@@ -461,7 +461,7 @@ u64 __vgic_v3_get_gic_config(void)
 	if (has_vhe()) {
 		local_daif_restore(flags);
 	} else {
-		sysreg_clear_set(hcr_el2, HCR_AMO | HCR_FMO | HCR_IMO, 0);
+		sysreg_clear_set_hcr(HCR_AMO | HCR_FMO | HCR_IMO, 0);
 		isb();
 	}
 
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 731a0378ed132..faacdfb328af6 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -184,7 +184,7 @@ static void __deactivate_traps(struct kvm_vcpu *vcpu)
 
 	___deactivate_traps(vcpu);
 
-	write_sysreg(HCR_HOST_VHE_FLAGS, hcr_el2);
+	write_sysreg_hcr(HCR_HOST_VHE_FLAGS);
 
 	if (has_cntpoff()) {
 		struct timer_map map;
diff --git a/arch/arm64/kvm/hyp/vhe/tlb.c b/arch/arm64/kvm/hyp/vhe/tlb.c
index 3d50a1bd2bdbc..ec25698186297 100644
--- a/arch/arm64/kvm/hyp/vhe/tlb.c
+++ b/arch/arm64/kvm/hyp/vhe/tlb.c
@@ -63,7 +63,7 @@ static void enter_vmid_context(struct kvm_s2_mmu *mmu,
 	__load_stage2(mmu, mmu->arch);
 	val = read_sysreg(hcr_el2);
 	val &= ~HCR_TGE;
-	write_sysreg(val, hcr_el2);
+	write_sysreg_hcr(val);
 	isb();
 }
 
@@ -73,7 +73,7 @@ static void exit_vmid_context(struct tlb_inv_context *cxt)
 	 * We're done with the TLB operation, let's restore the host's
 	 * view of HCR_EL2.
 	 */
-	write_sysreg(HCR_HOST_VHE_FLAGS, hcr_el2);
+	write_sysreg_hcr(HCR_HOST_VHE_FLAGS);
 	isb();
 
 	/* ... and the stage-2 MMU context that we switched away from */
diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
index 772c1b008e437..72f10b74ce807 100644
--- a/arch/arm64/tools/cpucaps
+++ b/arch/arm64/tools/cpucaps
@@ -94,6 +94,7 @@ WORKAROUND_2457168
 WORKAROUND_2645198
 WORKAROUND_2658417
 WORKAROUND_AMPERE_AC03_CPU_38
+WORKAROUND_AMPERE_AC04_CPU_23
 WORKAROUND_TRBE_OVERWRITE_FILL_MODE
 WORKAROUND_TSB_FLUSH_FAILURE
 WORKAROUND_TRBE_WRITE_OUT_OF_RANGE
-- 
2.48.1

