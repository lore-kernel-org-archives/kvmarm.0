Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2068.outbound.protection.outlook.com [40.107.101.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A751F295DB8
	for <kvmarm@lists.linux.dev>; Fri, 23 May 2025 15:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748015117; cv=fail; b=bhZwsORyERJ5FBG6a2JWPh51VFw+TuMY4EL1vAN6EH/W46SqI7Icryu/652Yz0iiDi8KtstBt2qpMef8+4ctTcE56hT8y883nk8OU4OymfJcZqcZZqfyotOfS8AH52VJpVhPB37OcbJiV2Pw0FoZM7MTG+wzx/0Excoj3AbRW8Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748015117; c=relaxed/simple;
	bh=YCTABOeuYXthINnhf/StJlkplswkYPopNXMLpBUSQ5k=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=k5scn0GOal3NOqvBjcCtS/FUurO2PWXjC0rrNMBMMRiddSFZ9nNWb9u+9jcNLCOaEwbHWIlSENHAQG5JlHpE6LFIIFpgHyZG9RGYYQifaEhr6NubAO/3qbLFsANo139hN/sw1s1FUjMoNiwdEZGCCDA/9zQ3M2zvU45nRsr9QIY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=l83/P24H; arc=fail smtp.client-ip=40.107.101.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="l83/P24H"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=c0zruVgJ8pgSVFBxouJ9zlMtyaxzmLl4L7DOPDlOs08fDquSj6IYxDTJ77y8/nB4dbwYC4pILUHuHIgyy/t+zbWHvDCXpDYB/Qwkv65kDewmfKqQTam2tiq8BJ/k+4yrmC4DlHNc2NDZSN13sBkTQsaUUlewJsIZ3gpRM+vhyCnDmqxKALfHEdCZokgHmYPy5rV9atZPeaKuBAZy1ATH3Mkjqdf4qYtt6s+b+dyqVwAMIRqLQ+bkhxu0ZubZzcDOalz7GnDTwNMcQg5zE8Qznp/kzSBXmTH2S4SoSRiLr8EDrY/zt5iPKxeO2bZu576yyNnuTa13FqBAPNh1wt4EaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bW5E1oaD/9AgHG56rYr1wGHv7xbFYhUjEVEVXUoNReQ=;
 b=RHxV9AIBL42VZSDpR8ZgW7rosruzTTobk0yFV+H31+YVwwvO3lzvm51XFMsyAzP8KZZ6fBkVZruL9Pbv18QteVKo+o1rqvios/Pc3q4fREOCQlJ7IcGGKqIQT/g/7+jVafsLvUExiMUAnBleb1Noi/RGI5+tYX+V3EQE8IPHahPvV4UbAEA7e2YkdOaXiF1YDKtQSm8mTRSgwS+/r5rrY0ckNJ4F1TPO59dAFYF1f2i6WDqSQbcpgnjvvh3tUzIUUAzNIh6Kf4/gME9UotPsxME/DfFzMXTwUlMgZtDJg3LmXexA0wmMh9BkFLoY9pImTcmJb7sMba4pVAA5ZTs7cQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bW5E1oaD/9AgHG56rYr1wGHv7xbFYhUjEVEVXUoNReQ=;
 b=l83/P24HwDsKR0D3ndMJylg3lX2hJhdzyftgPZKQAlJVQCCT0OCErQG06mxvqjh/MrKRHSdZtZ55aoOKavyFTXuU9ulhcEm/PviwNpSIvw4JAsa9QUgPSqHaEOrjxY8SzEs1kp2LrFBxJF+eo9+6wRa0qHkmnUiXUDXHx1VguegCt8PS45eGKxI6x/Rs8rGWaIMzZkQ9HrJjYW8s7MqKr4QpTEzW4KogWPo1m31UGn7/hqcvOottGw14IooyjrxhGRR4oirxpMoIEaBnBz7QUeer9UcAcdlvr7Bmp4t0mEVRN1Uw0QEHtYPEpr9214Oeg2aTNYOT61z/PasOwXrbNg==
Received: from BN0PR04CA0199.namprd04.prod.outlook.com (2603:10b6:408:e9::24)
 by CY5PR12MB6381.namprd12.prod.outlook.com (2603:10b6:930:3f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8746.30; Fri, 23 May
 2025 15:45:11 +0000
Received: from BN1PEPF00004682.namprd03.prod.outlook.com
 (2603:10b6:408:e9:cafe::e8) by BN0PR04CA0199.outlook.office365.com
 (2603:10b6:408:e9::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8769.21 via Frontend Transport; Fri,
 23 May 2025 15:45:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BN1PEPF00004682.mail.protection.outlook.com (10.167.243.88) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8769.18 via Frontend Transport; Fri, 23 May 2025 15:45:10 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 23 May
 2025 08:44:46 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Fri, 23 May 2025 08:44:46 -0700
Received: from localhost.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Fri, 23 May 2025 08:44:46 -0700
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <jgg@nvidia.com>, <maz@kernel.org>,
	<oliver.upton@linux.dev>, <joey.gouly@arm.com>, <suzuki.poulose@arm.com>,
	<yuzenghui@huawei.com>, <catalin.marinas@arm.com>, <will@kernel.org>,
	<ryan.roberts@arm.com>, <shahuang@redhat.com>, <lpieralisi@kernel.org>,
	<david@redhat.com>
CC: <aniketa@nvidia.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
	<kjaju@nvidia.com>, <targupta@nvidia.com>, <vsethi@nvidia.com>,
	<acurrid@nvidia.com>, <apopple@nvidia.com>, <jhubbard@nvidia.com>,
	<danw@nvidia.com>, <zhiw@nvidia.com>, <mochs@nvidia.com>,
	<udhoke@nvidia.com>, <dnigam@nvidia.com>, <alex.williamson@redhat.com>,
	<sebastianene@google.com>, <coltonlewis@google.com>, <kevin.tian@intel.com>,
	<yi.l.liu@intel.com>, <ardb@kernel.org>, <akpm@linux-foundation.org>,
	<gshan@redhat.com>, <linux-mm@kvack.org>, <ddutile@redhat.com>,
	<tabba@google.com>, <qperret@google.com>, <seanjc@google.com>,
	<kvmarm@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <maobibo@loongson.cn>
Subject: [PATCH v5 2/5] KVM: arm64: New function to determine hardware cache management support
Date: Fri, 23 May 2025 15:44:42 +0000
Message-ID: <20250523154445.3779-3-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250523154445.3779-1-ankita@nvidia.com>
References: <20250523154445.3779-1-ankita@nvidia.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN1PEPF00004682:EE_|CY5PR12MB6381:EE_
X-MS-Office365-Filtering-Correlation-Id: 5274622d-4fe1-4b35-0fc7-08dd9a10cd22
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|7416014|1800799024|36860700013|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?0TjkH4urT9+RENMdsoNA5ctj8CYMF8CSIAcVLwyTs+xV5uv1qTx9viGFV3Ke?=
 =?us-ascii?Q?oY38QZEKtgIj37TMbn7n35+LcoZO8LmHfl2IcFWovmBjp2GOfjUxfBl4E9Ch?=
 =?us-ascii?Q?6Z/WEDyHPbQov7BBpm9n9yU8MW0BiO8XQAc4wkqoz8IH9oiNJHi8ZyU6OdsR?=
 =?us-ascii?Q?hMbuYcWLXlZQlt/J/U1sY1fAO8H3JoQwGUdqbbz/3PeVJRoYIt5Ir3FZg8aE?=
 =?us-ascii?Q?vn1dfLfFwqX01vK3qY+7s1B+H6tGopJxnuJih3IgiaZjvb7Qf4VhX2A3XYG/?=
 =?us-ascii?Q?it5vK5trvxamusJnwRWRUDfY8uNhFow57hiOOs4/ttkTbyMIhOPSkUJtyrVh?=
 =?us-ascii?Q?V57acJdHQItqjKmmEue8eDHSLRTj0Tzi6ClYl0532YdS4bukREtwyCH9lK+N?=
 =?us-ascii?Q?BdGggb05PC+LgAxywoCiiBghWqCC7FBNI804Ak0UfpwSYiyJHfuHBTBs8s5w?=
 =?us-ascii?Q?z7MXBf2/Nj14fIKnfcHVw2EEVMgIljE/i5358m0LlrgLG/SFQ64hqtsuyTVq?=
 =?us-ascii?Q?XBgzj4QCqGpy4bTf4LNPyd8ox1TDYJn8mX0VWlv9OIkVN0zuMoePefnYWwYZ?=
 =?us-ascii?Q?ejTVtD1iPfE9b8rQggb1uZzHpGN/hi9qxVnn8g1LDknIfx11J3nU30fJxDtH?=
 =?us-ascii?Q?4auIA3KZMCPcpDyoMJ4ckqlQ4nQryWFRH1fKYgkCfZz7qLRsayv+KgYy7RML?=
 =?us-ascii?Q?zCfyzQSWKKek5tXPCXt/pUHwJbc5enPx22KNAJgsuItgRub/qFD2WA/yHSoG?=
 =?us-ascii?Q?zzeEjViG1nuvlNs+AauYmnEpQ851kunVb5II4vQw2oycNlWf0EvhQZUsPcBk?=
 =?us-ascii?Q?UteoQA2giwucSSlrMNTkszNVjg+4GnCDe9EMOn51P7tXm1+T1wg796zQW61I?=
 =?us-ascii?Q?APHpfdz+BanzAmjuYR+nGuE6dPBS7JBMuithOcGcSc/fA1DxMSbLsF1egJBW?=
 =?us-ascii?Q?i6QmqndSUlUdVjDj3W/8dFXaD8ySE11P4rnpV2Yj1cAhF3JOpqmkxKdnGbUf?=
 =?us-ascii?Q?DEI+IRzjuw76V0aXgjVc+LjM9MyGrdE/TJupVVsPyBIllemUQkWPPhvggEtX?=
 =?us-ascii?Q?RsEbr5nqrG9iFoTlzRe+boI1NeuKKsItvdwSUtlG/tFyhWvSeKlIryQDBa5J?=
 =?us-ascii?Q?u36lfq3zlYNg/i2bCn3QnKIYv2UJFL6IzuZLfWmvPz1rQ00EDvAePCrwGte/?=
 =?us-ascii?Q?n7V7Xrhm1LnYRXzRjFevwuftETdRCaQ2EsB/qNEc7pT2xM2VnYpkbQWpY3AN?=
 =?us-ascii?Q?/wPqqIx2CfiTHGFscjpz6hN/rtIj/T7uYKfIPe9IH1ljMXEYMvdgjpbbkpHN?=
 =?us-ascii?Q?4NaYi1x5M+F8RP/j1a1yxoPNhp91Jm5mFxZVEuIxqEi3+Tg58q08YmQDmrqF?=
 =?us-ascii?Q?AHI9AgKbpmGwG/7/3U3RYRFnu7At5S5e8fXig5C34Xg8sb7WNt6OGVTTqLr3?=
 =?us-ascii?Q?okkmF9oixFsfHnSdA7fbtKkmm3ddkxNsnELC8WUWOc0EdcZqYxJcPcSwDwqf?=
 =?us-ascii?Q?YI/jTYUhPH3Vtdib6S/WUke01MoObXWK+YG2RWdtXgIS5Enu9e+VgOLyiA?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(376014)(7416014)(1800799024)(36860700013)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2025 15:45:10.7334
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5274622d-4fe1-4b35-0fc7-08dd9a10cd22
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00004682.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6381

From: Ankit Agrawal <ankita@nvidia.com>

The hardware supports safely mapping PFNMAP as cacheable if it
is capable of managing cache. This can be determined by the presence
of FWB (Force Write Back) and CACHE_DIC feature.

When FWB is not enabled, the kernel expects to trivially do cache
management by flushing the memory by linearly converting a kvm_pte to
phys_addr to a KVA. The cache management thus relies on memory being
mapped. Since the GPU device memory is not kernel mapped, exit when
the FWB is not supported. Similarly, ARM64_HAS_CACHE_DIC allows KVM
to avoid flushing the icache and turns icache_inval_pou() into a NOP.
So the cacheable PFNMAP is contingent on these two hardware features.

Introduce a new function to make the check for presence of those
features.

CC: David Hildenbrand <david@redhat.com>
Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 arch/arm64/kvm/mmu.c     | 12 ++++++++++++
 include/linux/kvm_host.h |  2 ++
 2 files changed, 14 insertions(+)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 305a0e054f81..124655da02ca 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1287,6 +1287,18 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
 	kvm_nested_s2_wp(kvm);
 }
 
+/**
+ * kvm_arch_supports_cacheable_pfnmap() - Determine whether hardware
+ *      supports cache management.
+ *
+ * Return: True if FWB and DIC is supported.
+ */
+bool kvm_arch_supports_cacheable_pfnmap(void)
+{
+	return cpus_have_final_cap(ARM64_HAS_STAGE2_FWB) &&
+	       cpus_have_final_cap(ARM64_HAS_CACHE_DIC);
+}
+
 static void kvm_send_hwpoison_signal(unsigned long address, short lsb)
 {
 	send_sig_mceerr(BUS_MCEERR_AR, (void __user *)address, lsb, current);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 291d49b9bf05..3750d216d456 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1231,6 +1231,8 @@ void kvm_arch_flush_shadow_all(struct kvm *kvm);
 /* flush memory translations pointing to 'slot' */
 void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
 				   struct kvm_memory_slot *slot);
+/* hardware support cache management */
+bool kvm_arch_supports_cacheable_pfnmap(void);
 
 int kvm_prefetch_pages(struct kvm_memory_slot *slot, gfn_t gfn,
 		       struct page **pages, int nr_pages);
-- 
2.34.1

