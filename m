Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2052.outbound.protection.outlook.com [40.107.93.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 011AB2580CC
	for <kvmarm@lists.linux.dev>; Wed, 18 Jun 2025 06:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750229766; cv=fail; b=RhBSYhFgh1yCnRJ1xCTzVbr1gjUUGqV9kQk7VAF2Ds0l9WqI6/Of48h895AUWnNoxKTJSwmY4kWEF5qrxLEbgAFnxXiGPCgwZUwao07aQjQmgs0Idnxo9j2TfVmUmALolG/KYR2ftuMNh/xLecaPwQBp9eNfBi5SSjFfKPZF+/g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750229766; c=relaxed/simple;
	bh=UDoaRJelfFLmKbw1IJ/tNyN2Di9TR0w5yCdfsGAWwCI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PhwsA/yc1FM1eTm04dACSiqXxnYS1xaEBSz54QKsk2CIB0HC2Pw3lE6KJvd115KzgkfUyVtkIYUR7GG3u7AprmDXa6SrAmbRHE5St4ZnmuOTqRWPGr9WUhNSHX3yDABU0Qoc0DZy6zev7733pg5KEt80jgP4bLMpOrLl2+y1WXw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=VpvQ7op6; arc=fail smtp.client-ip=40.107.93.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="VpvQ7op6"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fW0SVqlMZG3Nbtpeco3PtSatYPli0NriGEfHIiu67R0BYlkOKwsYFs9uSLAHeaWKIMMJNVOol/hLGY4Zo94LtfyE4GUvho+Iiasdh+5B6GIfanvKF+/uUDtshZicIqFcADG2r45c9Ho++KLdq3zUL1WfSOc13har9xuf2AqxYYnkGgLkXvmNxvQmYXcMji48KkDjNf4QDacTIiTE1JgM8HR1gzh61zpGNUChe5yh2dHuZFqrQ+USe92tcfTsbu8cYeJz6pTlxH0QJSRIUWI8n8DF/7bBeF7klAwQsaP/ykaJSNOqdYFzngZV8hucBdC70nxpRugEI6zCQ2pvqh66IA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bmpn7enO6x1CE0vhWWa5TJpoKWK13CaLaXZL4w0OjIc=;
 b=WrhNbIR0jwahcGWACri9oWDEZ8iCxvFC+Pu1pIMMsdzDNQdeV5TOujORnVp3b1K3ccDSMe+HKjFSItWvsMYZ2OW0Dm8iU+/Hu4RfuzW9P5YQCOj8RFuWg9QLBhl32UgMZEOUmRIfm+U8dus0pmj0cmJQg6WlHwlcAHPwhu/u4h4yqczxtrB7m+q8FOHBwHB8DCS5Lkh9APRaxVzfgB1IPVZKa44XV2U91cMEdRjbvJyAJtUKrzL2EWmUUI5+sDOpwq8tbN1Zru9zHfZc9aHz2uVLrhcdSgmFQ+bWa1dsLUswNSKTFga3eAE7EW5xVKEdXbqjeu6pAPhpV0vrEeXIlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bmpn7enO6x1CE0vhWWa5TJpoKWK13CaLaXZL4w0OjIc=;
 b=VpvQ7op6jSxXmsx/9CY/EI2HbD4dUN/8rSbIbkHRSdsqI2eBp3D4UwQ1OoISyskRdw4+I3K3Z/u6nTi3HPH5dtWUo544HXnUPttH6naYJBInux+S7NGr+BkF55QGEZIHEhF1GcFwDa+Yz7bPyvthqV/khL8M8KxADhY82XivVYzHz+p1lj0wavOW7MDviVTJohtzNJiDqPGkCKBixDmYuLJpa+Ke+chRfWUIAEbejrH6fZoGLPPfvvPsZmniBo9ws/g1i4vjy3bcW96sZznJTKj64N1RpV9d64D+MiQdPINPHj3YbVH1N0ibeZfSwiT9+cU3EqzdxkyPO5XMG079aw==
Received: from PH7P220CA0024.NAMP220.PROD.OUTLOOK.COM (2603:10b6:510:326::11)
 by PH7PR12MB5783.namprd12.prod.outlook.com (2603:10b6:510:1d2::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.27; Wed, 18 Jun
 2025 06:55:59 +0000
Received: from SA2PEPF000015CB.namprd03.prod.outlook.com
 (2603:10b6:510:326:cafe::d5) by PH7P220CA0024.outlook.office365.com
 (2603:10b6:510:326::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8835.27 via Frontend Transport; Wed,
 18 Jun 2025 06:55:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SA2PEPF000015CB.mail.protection.outlook.com (10.167.241.201) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8857.21 via Frontend Transport; Wed, 18 Jun 2025 06:55:58 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 17 Jun
 2025 23:55:44 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Tue, 17 Jun
 2025 23:55:44 -0700
Received: from localhost.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Tue, 17 Jun 2025 23:55:42 -0700
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <jgg@nvidia.com>, <maz@kernel.org>,
	<oliver.upton@linux.dev>, <joey.gouly@arm.com>, <suzuki.poulose@arm.com>,
	<yuzenghui@huawei.com>, <catalin.marinas@arm.com>, <will@kernel.org>,
	<ryan.roberts@arm.com>, <shahuang@redhat.com>, <lpieralisi@kernel.org>,
	<david@redhat.com>, <ddutile@redhat.com>, <seanjc@google.com>
CC: <aniketa@nvidia.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
	<kjaju@nvidia.com>, <targupta@nvidia.com>, <vsethi@nvidia.com>,
	<acurrid@nvidia.com>, <apopple@nvidia.com>, <jhubbard@nvidia.com>,
	<danw@nvidia.com>, <zhiw@nvidia.com>, <mochs@nvidia.com>,
	<udhoke@nvidia.com>, <dnigam@nvidia.com>, <alex.williamson@redhat.com>,
	<sebastianene@google.com>, <coltonlewis@google.com>, <kevin.tian@intel.com>,
	<yi.l.liu@intel.com>, <ardb@kernel.org>, <akpm@linux-foundation.org>,
	<gshan@redhat.com>, <linux-mm@kvack.org>, <tabba@google.com>,
	<qperret@google.com>, <kvmarm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<maobibo@loongson.cn>
Subject: [PATCH v7 1/5] KVM: arm64: Rename symbols to reflect whether CMO may be used
Date: Wed, 18 Jun 2025 06:55:37 +0000
Message-ID: <20250618065541.50049-2-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250618065541.50049-1-ankita@nvidia.com>
References: <20250618065541.50049-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SA2PEPF000015CB:EE_|PH7PR12MB5783:EE_
X-MS-Office365-Filtering-Correlation-Id: c17aa5cc-2fd0-4306-abe1-08ddae352e4f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|7416014|376014|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?UsdkWTYS6dtcUKNA8Ifrpra/lEdVCqFwaAygkHrh/9dn3vNIWvcV/Y6Wpwkd?=
 =?us-ascii?Q?fYmX2K0m/pPzVydS0PuZGjA+Pj4oe+SYqramI5vugGd9uDocu2n//i3Np5ZN?=
 =?us-ascii?Q?kHTEHaF0mYyz3VsxZxdLx0fkcjDbgnMy5thuYD9T9Eemygp3MjLRs6cg0YnJ?=
 =?us-ascii?Q?aaRW+bE1mr+OBLEwVdLiKCxKDOqx/FIP6uUJtkPrpncr1kMzzORc7xyYDIfD?=
 =?us-ascii?Q?eMPUcQSteels7NA6qkCnwzNQcE5m9AH4aBhCnvKl8UFxFsI6NUxDYWBR3zPO?=
 =?us-ascii?Q?OndphHR/Ic/oGhXLj+BFtsKbHlpcJD7FwUjhFvg3vFA6NoobqO6OtscDt8L2?=
 =?us-ascii?Q?MOmu+XGGGJGStwtANf22218BwRukONLgadPuPsNqq1BRo6xiC/OS5GG3iLnk?=
 =?us-ascii?Q?xx+8JzO6yfZvwhXAOZtc5HszSvft5LSMBjvQYH1tLal9f/1NF0fWRiqOCTDD?=
 =?us-ascii?Q?inPGSJWhJCNC2GwvGCwmHESERXrpnLIxO+zs5GGXnQ/uO3PcQNnUAYC1IACG?=
 =?us-ascii?Q?kIMyMIgfflJoY70YDSWWJ1M3l2CXNzeGreuPzro03M8qHCAHJ9ZxduHnHvIl?=
 =?us-ascii?Q?XjR5WB2z5HxP20rqghECcTwJeoy0Rz0IF3aJHolAZDuWprLGbt6saUUlJnnb?=
 =?us-ascii?Q?kccWzC0A9NrbQafcZ0KVNdYpqbrjvMak9zXR60dZDBmIxbYPuwjg8MVUsTKZ?=
 =?us-ascii?Q?ZOVvbylPooB4+zbPPxEmG/DZHnVkkihTLgN7IyUfMt8l54ic6Tcql1wSAXJz?=
 =?us-ascii?Q?4YyXMiAjkX77RHQg0l4YuAPhlJDbAu8LeJYfKOeZJBXKfLImM+TPikMpxGqr?=
 =?us-ascii?Q?/OROI4rcWEqjMnXye61G+BnZSccI1RvgaTdGSVnewnRHv6JqHsaTyhNAKWwb?=
 =?us-ascii?Q?43/G2d6CSEa85nEP/T980lGZjj91cHVOamxpMbUSATvy/LsQAY8RByeFLPMp?=
 =?us-ascii?Q?xJekoYIXFY3kdiCFRxEUXeOLmiVIqmU/3/89A8w0n0Xyr4Lj/ATczLfd07Wl?=
 =?us-ascii?Q?nBGoAAL5iv9nA4knWfbriVd45zP935fb+DG8Eh1kguz/eUE/RB9vaVJYOopH?=
 =?us-ascii?Q?0312KkXhX2asEql7rd+7V3KpZUKohkKN8L0lUMB8EgohwNIHZeva513OBel5?=
 =?us-ascii?Q?GEiey9VVx7hea21NMGgzoWX/+0nesOZn2CVK9o5a7KkHltEQ7J60k40TSStH?=
 =?us-ascii?Q?nbVuXdVkmB7/YjL5yTMN5p4Rl70xI3VSEcADQ3EX6KoZsuqPb7QBzK5LwCI0?=
 =?us-ascii?Q?i4xnQWYw1J3b715LgTjVXndIlZIo90gsM8mowRgutwA2XLkkioQOk6gCFpHh?=
 =?us-ascii?Q?dBQZy81o9a5jQhUlGuMZik16f0T2TVwnrkap62SgAtFjbxpmJ87qDSzirA47?=
 =?us-ascii?Q?ka7WdjTSZQb5X5XsKOX6kp2w5MzVYYSffmPOxhadwPCLRbr+ZLBFCYq9ctaV?=
 =?us-ascii?Q?Eegos0zN3ZKNgo17zisJ2F8Ipfk3m+xsoB5jBqnAx3/ZpinB4YaYx46cnyde?=
 =?us-ascii?Q?QSZtK+wG5D7vXCcHwFdPjr7wTMjjWobryphXPla/CnHfGcPXNPB4ne91Sg?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(7416014)(376014)(1800799024)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jun 2025 06:55:58.9356
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c17aa5cc-2fd0-4306-abe1-08ddae352e4f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF000015CB.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5783

From: Ankit Agrawal <ankita@nvidia.com>

Currently, the kvm_is_device_pfn() detects if the memory is kernel
mapped. It thus implies whether KVM can use Cache Maintenance
Operations (CMOs) on that PFN. Rename the function to reflect this.

Additionally, the "device" variable is effectively trying to setup the S2
to prevent CMOs. Calling it 'disable_cmo' would make this code clearer.

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 arch/arm64/kvm/mmu.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 2942ec92c5a4..3d77a278fc4f 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -193,9 +193,9 @@ int kvm_arch_flush_remote_tlbs_range(struct kvm *kvm,
 	return 0;
 }
 
-static bool kvm_is_device_pfn(unsigned long pfn)
+static bool kvm_can_use_cmo_pfn(unsigned long pfn)
 {
-	return !pfn_is_map_memory(pfn);
+	return pfn_is_map_memory(pfn);
 }
 
 static void *stage2_memcache_zalloc_page(void *arg)
@@ -1478,7 +1478,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	int ret = 0;
 	bool write_fault, writable, force_pte = false;
 	bool exec_fault, mte_allowed;
-	bool device = false, vfio_allow_any_uc = false;
+	bool disable_cmo = false, vfio_allow_any_uc = false;
 	unsigned long mmu_seq;
 	phys_addr_t ipa = fault_ipa;
 	struct kvm *kvm = vcpu->kvm;
@@ -1642,7 +1642,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	if (is_error_noslot_pfn(pfn))
 		return -EFAULT;
 
-	if (kvm_is_device_pfn(pfn)) {
+	if (!kvm_can_use_cmo_pfn(pfn)) {
 		/*
 		 * If the page was identified as device early by looking at
 		 * the VMA flags, vma_pagesize is already representing the
@@ -1653,7 +1653,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		 * In both cases, we don't let transparent_hugepage_adjust()
 		 * change things at the last minute.
 		 */
-		device = true;
+		disable_cmo = true;
 	} else if (logging_active && !write_fault) {
 		/*
 		 * Only actually map the page as writable if this was a write
@@ -1662,7 +1662,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		writable = false;
 	}
 
-	if (exec_fault && device)
+	if (exec_fault && disable_cmo)
 		return -ENOEXEC;
 
 	/*
@@ -1695,7 +1695,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	 * If we are not forced to use page mapping, check if we are
 	 * backed by a THP and thus use block mapping if possible.
 	 */
-	if (vma_pagesize == PAGE_SIZE && !(force_pte || device)) {
+	if (vma_pagesize == PAGE_SIZE && !(force_pte || disable_cmo)) {
 		if (fault_is_perm && fault_granule > PAGE_SIZE)
 			vma_pagesize = fault_granule;
 		else
@@ -1709,7 +1709,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		}
 	}
 
-	if (!fault_is_perm && !device && kvm_has_mte(kvm)) {
+	if (!fault_is_perm && !disable_cmo && kvm_has_mte(kvm)) {
 		/* Check the VMM hasn't introduced a new disallowed VMA */
 		if (mte_allowed) {
 			sanitise_mte_tags(kvm, pfn, vma_pagesize);
@@ -1725,7 +1725,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	if (exec_fault)
 		prot |= KVM_PGTABLE_PROT_X;
 
-	if (device) {
+	if (disable_cmo) {
 		if (vfio_allow_any_uc)
 			prot |= KVM_PGTABLE_PROT_NORMAL_NC;
 		else
-- 
2.34.1

