Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11023087.outbound.protection.outlook.com [40.93.201.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C6CF149C4D
	for <kvmarm@lists.linux.dev>; Fri, 25 Apr 2025 02:47:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745549270; cv=fail; b=rDgT6c3/zq1RGP5ZclbAJFQ5yJ0wIzBF5fzvvvVlszU331b72IevmnPVfp/SXJS0KB/lIJefNohx4hB4HCKVuvFuQE6ASp/89WTrlrP4yW1ZeSmvE+mu64N5Oeg9j7z3szAZSsAsDzFEBtkNtWLKfDjO4x/RHwbZAGs4ANqG/Tk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745549270; c=relaxed/simple;
	bh=I/3k38D12zq3dNpWDQqZAHTu8HasKvIwyXWi3BX25tU=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=Qv4mVDOo5xcNeFTHAnike5b6e0RKYmUgzSewYQekgpKuBBiRqopbhFCwgUcUEV1c5Pjez77+kWBRmV+FD/VVL8ps/iXaKfm2BDSV3OIEZRwYK25gJq5gMZMpiMgTgI9NB/8dJcPmdDC2HoZXnY2LFXyFCPZT46AU8D7M1+cdzMo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com; spf=pass smtp.mailfrom=os.amperecomputing.com; dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b=b/19hm32; arc=fail smtp.client-ip=40.93.201.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b="b/19hm32"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PGoHx8SC5I4fO3hcJ8zsweSTLT78OmmmT5u0VblsJ5RtXM2dU9D/FmfdZZhM9eBO0bPMg+uKeNS1DHyqNSArg7B2ZyTwK1iIVnvIuoEV7zq9iXz6xq6++Fdu80IskmWCvA5jtUqAp5Yq8VJhP8/qYxpoW2hiTL65BM8FLzk7pUBs5kLpURvIMdxZwDRTGqyGiTS23c+5RkdEsaI7SRpyx3VNgX4wLR07tEbbixlZJlrPKznwvE0wSrw4crPAaX3jKJLZcPNneZNrWo9q21BkJbVIzGiMaLuQIkQqDrWRcdPuGeNqbanVsz7APn8Wae8OxGVD0pPlFh7JB3bKAIT7Pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ir5CLKZHZp8nhKacR+e4wgtXGCIYRrhVvWd7oZfDbdM=;
 b=veiWx3mLoaNogpZvXnVYNFzjQf7aXnrD/dSozVMbvgL83x81YywrUObHOK1B3+Va+MaKq3l3ulfdsUhjJel/+HM6xXsO5ScZyPJ06COTwxjmreFdJ/J1nq1FkKcML/XiQxLAn/2TvRfAZAYZRLuyidPapWQRmPgJevPthkhi0mhJFsV5iFKdEEGLrF+NOti/7Q/CiDk7s9mdhfTlIEkLm4e/m6Z3dJvWH6d2otbn7mnmgDaaMz3XYgu2CgMzJAf0UZ5Vl0Chr/YTH4MYd5zl1Phakkn1QayYmmhqjEXlKM1CliZDW0+4zQzazK+GIuGGZCYy/Ro33uOdfMyq0bP+yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ir5CLKZHZp8nhKacR+e4wgtXGCIYRrhVvWd7oZfDbdM=;
 b=b/19hm32oTVAtldfnSPKXtjj4dkK4BPiuB4CC1QEjRHgjmMuN7R2bviv8Vo51/mMEgXVSUYHfaKMHZSgUrf0cGmEoY9acPdTNdqtlCWKhwhQpUI0Yu+mQJdlBpUINh6L7gclzaX3y+XhDDUDw5ymIHsUr1puknqKdHiXSxODHtQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from LV2PR01MB7792.prod.exchangelabs.com (2603:10b6:408:14f::10) by
 SN4PR01MB7486.prod.exchangelabs.com (2603:10b6:806:202::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8606.52; Fri, 25 Apr 2025 02:47:45 +0000
Received: from LV2PR01MB7792.prod.exchangelabs.com
 ([fe80::2349:ebe6:2948:adb9]) by LV2PR01MB7792.prod.exchangelabs.com
 ([fe80::2349:ebe6:2948:adb9%5]) with mapi id 15.20.8678.025; Fri, 25 Apr 2025
 02:47:44 +0000
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
Subject: [PATCH v2] arm64: errata: Work around AmpereOne's erratum AC04_CPU_23
Date: Thu, 24 Apr 2025 19:47:41 -0700
Message-ID: <20250425024741.1309893-1-scott@os.amperecomputing.com>
X-Mailer: git-send-email 2.48.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SN1PR12CA0090.namprd12.prod.outlook.com
 (2603:10b6:802:21::25) To LV2PR01MB7792.prod.exchangelabs.com
 (2603:10b6:408:14f::10)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR01MB7792:EE_|SN4PR01MB7486:EE_
X-MS-Office365-Filtering-Correlation-Id: abd91832-0ebb-421a-2355-08dd83a38e59
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|52116014|7416014|376014|38350700014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?rmRZAFvRUCKwebSTIOU/wpf1eK6TeHATWSr+wh4P7qRwPzryHPoWmeXKja+E?=
 =?us-ascii?Q?QTGPCS4LKoqZEalop9akMpK1Ts7i+BtqT+dXex9vVi5G4ulMqKk4RF+kI+fD?=
 =?us-ascii?Q?FGKiUemFmLzOsFghovFfyCbi99ysBNV+2JaRlscapQgtG2dfZjQi/hEOmfeR?=
 =?us-ascii?Q?y9Mw00KPgoqcZmmLo7HyD1QxRNfeHjlrzSBzKbq2XJThpatVTnciK+NrKUAT?=
 =?us-ascii?Q?nhsuJN5nN+BUK2RsUvCCHxd4xfpHAvM2qPLhwEAog/b8q6N3DDeA0EgWGBEX?=
 =?us-ascii?Q?M9zWdp1BGb8G3nv69ZqbQ83OuO89shRIiunbkWxfrKrOtRMqIIZ3GDHa8y+e?=
 =?us-ascii?Q?zhyFqEQMEqh2eaaGtluTRAG/RH+o5ACqcKUItswgE+gI0y/fZ9k8UFIGFUUz?=
 =?us-ascii?Q?NIC6mRWys71aQehpEe5frY4kFW0N6IiAD/W19uiYC9dDSZmawGkVaG/XqOq8?=
 =?us-ascii?Q?bfHVucxYSf6YPB4ZsvsFUsfz7IkbK02j6cznlbvBkMcUp2IZvkinYHnF164e?=
 =?us-ascii?Q?uAvX0ixFXBSJznncwzZpN0LlHQvDGJrFOV4soxss0a+tcmVTulvsjOBnKR3N?=
 =?us-ascii?Q?gpqHm12wZseXYyIpc2dX4E27ExO+lFU7t8Z7wq59/zoRjmg9DIj2r9ZLGUMQ?=
 =?us-ascii?Q?CgPY8m7v6RDcYc330IpuN1Q72Togw8/GB+yFtnZEh50fqGugfVtiG4X7/hgO?=
 =?us-ascii?Q?aaOsYBcBF25YXVCsinSFFC3Cb/JLtLZ0cfTTC5p998Tx9LDaeDLPhYZveprE?=
 =?us-ascii?Q?sRs7gWRd7cmhFJPXRbLeEa3Eedmb+hUNEMWP+BZJY5v1y1EwiGrw9L5fRx46?=
 =?us-ascii?Q?6DoMAwBawjHyi9HldOyrCTyjA1b5nZcxAJJTi9526sk2atRZEatJD7gl6UTG?=
 =?us-ascii?Q?w7T0kNwvXfyGs9wOhw+m5N8qOnkDvDCzQ90aN3INyGnq0Hk9nuX784Spqtrn?=
 =?us-ascii?Q?Bu5xAOH1SeQZ+BY1BSDr68DZI32skbxqH7sfAB4WlpCU6738KsC43/G5FzIt?=
 =?us-ascii?Q?F6bS48Ls056AY9Y6+cqD+zR73nXxqLCrG9dIz7+O8y57TXGrnv+cRm2SFB3v?=
 =?us-ascii?Q?VBRIJPIFfpTPx0uNP16KH70aDF5mhGZkKx3Bo6cEtS/5rGPURxWW6e32Dx4E?=
 =?us-ascii?Q?z06Cyma9pJ9IsXqKiWHj175mJI2939w/SO9zXYvt3ffgQkURaXNA1vItaZpr?=
 =?us-ascii?Q?ASI/wOjTXP8QR7sU1teNvo9uFDMBlJQXAY9uQ04cqxwX5YenTJ+YrjTAcQ9a?=
 =?us-ascii?Q?1Db58Tn1P1G01og/bzbcZEleonvC9mWpIuYWrc3YT07Q9yzMeds27EX6nNUu?=
 =?us-ascii?Q?Rdk+2kFPX6OtFrPHWns9I66fpRFJzoRlaHTWkusjR4OxSSRe2Bv6LJYVhKQn?=
 =?us-ascii?Q?ZvUMchhUa2/wsJOD3vHPQDWDQRF6GsT02H5p4121HRKrwe8Ic19cr60oNNZB?=
 =?us-ascii?Q?aD7g5tYtDUut1nLZF5tfis7/+2Le0aBK5eQcntcSF4vYXoytPO/W/bL1IzIO?=
 =?us-ascii?Q?A3o/37YXlBqu57suoauRaNpIhhO7lkkPlBXf?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR01MB7792.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(52116014)(7416014)(376014)(38350700014)(921020);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?nEkV4ckLJ8Sv7e6861Pm6jLFz3SqPKvnifjkoEO6r/GW5P9p8EQV4klBwVxW?=
 =?us-ascii?Q?ZHfTqt/bZKGPoAI9jWgHDTKUNqn5Fm24Yff8m+vR1RCaNFIACkd2jRj+TpsM?=
 =?us-ascii?Q?muv1f9BjjQv4I0DkhGmYx4vy/wHzz4N25e/nCY9XTfe+YkSPrWG9U2lkg1LG?=
 =?us-ascii?Q?rjGvalrCu8HBcqPCZVoa75YNht6+h9qlQFoz6Fs5a0YyoJRlMoz1yDKE7GUp?=
 =?us-ascii?Q?TO7xp/x8KNKlEcosNirxT8aPVF2B1U1+5N7Z/51hXs7tn2XfHu4YsxFSVJCw?=
 =?us-ascii?Q?nxl+rFD2WuMt3sG47MfRpFj1hhGZPewMy3fH2qHadKg1o8j3vGe1NT3kTd/x?=
 =?us-ascii?Q?YE4mTAKTfJPxmgtq2k/+Qj/Fr07M7utq7/Mu1jxPb2hsGhJF4/Vd9qjort9C?=
 =?us-ascii?Q?vbVa9gHiy6wgV+yVzkuiKHnKdJ48UWcDDZ1zB2NDZPJdYoQ9TttUyskXFYFU?=
 =?us-ascii?Q?QFimCU/mofAD8vw40xTxozlAnTdxAIDBXBOrqZMxFHyWIi7FmSYxUJAqyxwS?=
 =?us-ascii?Q?sWT1Z8VNco5FP/bNyzRn67NkL5Fhe9DdaqO1NYC5ZbrgOxKvv3CcMekAOUIs?=
 =?us-ascii?Q?8goq8W1RhYVq6vkCOvcgvZtJt31Q4It7y1uj42zyHU5fKhbfPYiOi6u2D6uv?=
 =?us-ascii?Q?oSbYCoXUmfHvUYh5XDW+idNm25zinLniMimlJEed6a1FZL67phUMYt+wodIL?=
 =?us-ascii?Q?UEQPUPccQ3suhEHrOWRsdLGJ/QgJsRly2NqUtAKwYxNdSAcJp4SCxriQ/JiY?=
 =?us-ascii?Q?DTzP/gjp+Cs3E1ce3H3N1Yq/7f8ywNiTbHhY4Sk/bfTtUkDsHZufTkpwJNHv?=
 =?us-ascii?Q?2Iqmo76am5zOIY9fVuWRV90xvOTi2QzrzkxDhPt10mbWZAPKQg7mZr4uyPCD?=
 =?us-ascii?Q?QSV8EaL1wI1mSDbSAtj84Jg2+KsmvXjfW9YAhbTIUHPPhB2Zq3FFkE6nP0VR?=
 =?us-ascii?Q?j1c4Jq3Tl8wIoB2x14NNhxpw+uKvY+aOKaGYvjy6BG97udEfoAthoqPTyrrf?=
 =?us-ascii?Q?tLYU+d6CsoviA8XQJ5CchWnTqG+aAuqbrGtp+5QKOjURqnoBHSPhEs7xelGZ?=
 =?us-ascii?Q?ts24ih83PXnuAMhUS0pwIFpmbyCos2Koo81BXoV+/gkeUniXjhwW0hEwprzz?=
 =?us-ascii?Q?+Xh1KIxdQXPmdLKpYw3G/VyOiQBtESIhxtcWZQ6rdwDW8WyBaG2PQdYyy9Lp?=
 =?us-ascii?Q?u9vumb/gX7ZNdsEo1b3X0ZrXlpRf1a6Xl/uuYwIriOWBXNt6tkWyWPw2R3tx?=
 =?us-ascii?Q?Yt/lDOLiQdkxJP+MrqzLKTB1nUTkm/xvQZe5bt4IfH+lAjKqDU801qCYCRtS?=
 =?us-ascii?Q?Pqbu5Y8GYz4J4uvKsxuBdS/sGx7RHQh62oQ5fm8AbbKTTI5PtJ4E1xHZaM8V?=
 =?us-ascii?Q?l6Qlm7AVT5OrkwF3CBfhdyVckjHyiWjLm5WRpXDHH0RLidxlSY1QGSk1y2oW?=
 =?us-ascii?Q?hvJMg8bJ8O4X2DwomMb/GkSiw+w2VgwCa66hrTaz4EtG7R9hP7IuEZbKc0Wi?=
 =?us-ascii?Q?D5dzW+GlJP/42EKNoRwDiQSLZsq7ETchJ2quJwAIDFeTidkz4U1prcHmLbgG?=
 =?us-ascii?Q?pd1o3+Af1yX2jkvVJT6BOh4p4olQCkXvZY8zLPCWrSnXteFOJDWtrfAgKhbo?=
 =?us-ascii?Q?K/50KFQ4HISp8dpqvEqVRaY=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: abd91832-0ebb-421a-2355-08dd83a38e59
X-MS-Exchange-CrossTenant-AuthSource: LV2PR01MB7792.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Apr 2025 02:47:44.9284
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uAscoDHP6LVBTXJZSaYGVj+O5Cgp8oVHMope/pfx0kMB3XfyENi8pJPeNFAHHHnzrPzS3zuaBeaN/cCN8/CP6Xg8l5hFF1pNMVjYt8ZUzX1l1tsiNCP2ACXXgzK/WxCl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR01MB7486

Updates to HCR_EL2 can rarely corrupt simultaneous translations for data
addresses initiated by load/store instructions. Only instruction
initiated translations are vulnerable, not translations from prefetches
for example. A DSB before the store to HCR_EL2 is sufficient to prevent older
instructions from hitting the window for corruption, and an ISB after
is sufficient to prevent younger instructions from hitting the window
for corruption.

Signed-off-by: D Scott Phillips <scott@os.amperecomputing.com>
---
v1: https://lore.kernel.org/kvmarm/20250415154711.1698544-2-scott@os.amperecomputing.com/
Changes since v1:
 - Add a write_sysreg_hcr() helper (Oliver)
 - Add more specific wording in the errata description (Oliver & Marc)

 arch/arm64/Kconfig                      | 17 +++++++++++++++++
 arch/arm64/include/asm/hardirq.h        |  4 ++--
 arch/arm64/include/asm/sysreg.h         | 10 ++++++++++
 arch/arm64/kernel/cpu_errata.c          | 14 ++++++++++++++
 arch/arm64/kvm/at.c                     |  8 ++++----
 arch/arm64/kvm/hyp/include/hyp/switch.h |  2 +-
 arch/arm64/kvm/hyp/nvhe/mem_protect.c   |  2 +-
 arch/arm64/kvm/hyp/nvhe/switch.c        |  2 +-
 arch/arm64/kvm/hyp/vhe/switch.c         |  2 +-
 arch/arm64/kvm/hyp/vhe/tlb.c            |  4 ++--
 arch/arm64/tools/cpucaps                |  1 +
 11 files changed, 54 insertions(+), 12 deletions(-)

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
index 2639d3633073d..d41eeba7f8201 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -1185,6 +1185,16 @@
 		write_sysreg_s(__scs_new, sysreg);			\
 } while (0)
 
+#define write_sysreg_hcr(__val) do {					\
+	if(IS_ENABLED(CONFIG_AMPERE_ERRATUM_AC04_CPU_23) &&		\
+	   alternative_has_cap_unlikely(ARM64_WORKAROUND_AMPERE_AC04_CPU_23)) \
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
index b55f5f7057502..60f1b70fc0845 100644
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
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 2a5284f749b42..3aca6278d2f6d 100644
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
2.49.0

