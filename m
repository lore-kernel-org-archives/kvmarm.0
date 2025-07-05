Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2047.outbound.protection.outlook.com [40.107.95.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C35D248881
	for <kvmarm@lists.linux.dev>; Sat,  5 Jul 2025 07:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751699862; cv=fail; b=O9QMhWcJvFXeFBMoa96wRW/Re6zu1H4CXMs8Ptm4Wq1iiDIpgwKpyRYGHR/x/yUOzX/n/Xb5hXxQkNLQm0vA7Uq1ZXAhmZcphTL8M0c8rHop1jtzeyUHa/bsQWgAUE5GTpjTdZEcscixx9nLfJ+Yqr+MFToVrfDXhk9kpOrhGx8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751699862; c=relaxed/simple;
	bh=jW0OheQ9UTQ8cQvKh/lDSXMp3WJB1B1A2JVNsH5jTkE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kz3y1jaPt6YKzFeZNbTddPYif3WT1ghRYLNqbsmc+IR/lDNOz9rsWYvm4cTujGTzFXLe1lSVEl3CdH0vliqTMIUIyfsyfJE99ppqj3lgPzFrWnV02nKF1Srgqq/trfVcQDuGYWYFpEMxgVlU/y3lW0dl8IGW+FWUo993nCDtiZM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=a8HLwxcT; arc=fail smtp.client-ip=40.107.95.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="a8HLwxcT"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=L0bqQ3okTpPyKaUg48g9249coO9l+T3RCOYsyYSfmsFM44PsQ+JrVo7VFbxNG+RBx0Fsyf58fXDU1Zpb8YJaK4UDhjfv5LSgsTd1uKR6lrUm3xaUJ5SY9376TEwLi7j+DBqMTNVFgK5r0da5+QuE+0kR4TLZv5Lem/m0Ph9eYI+dYnu4iaWq0yWvHxKZJBd8qfLy9m5PSJ2KzUgP+PUMYSuC15qlyn7nW9T58a5paFwzbhnEXIWoIFgEjIV5S+PUx0bOMDBLvOYAUB5zu7HGRfvUA87bYOCugK41aTPHxK9TiqYmYQQeZ10OOO+do3Z5WMMroKKMrgOYsz6a9nEioA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f0Cvkf2sp+kRgbkTK47mDMPpUm9D+BoyXCyZWjlpiO0=;
 b=n0R6JAK5GdqrSqJ0Jh//ZlwCoNh3dPBhxdwl3D6fXwN7U87vsJbiTuLDm7aztwlV5xFLrActQ6o+Jf7GH+DrjZx+gzY/rEpLtazMkHOdaM26ae8HA6nNXX+yOgZxiWEdPqz9wpZoCzpK+uq7gWBDPCj0Xekpz69NxQx7+8xt4etzW6edZ3y+AdEYEzagoR5YMGvR9OabbZn/368QkG9xd6xD7wihmoYhPkQdCjKQuCbYXsw1K1LBE+pyoedAjWr1oebhw9Hc9HYAE/sILYSjSNwVkSnSkxfEcOGz0xxVWCHF8Wh7grufqV1amvPXpiHSQTEJMqWmTQ0boO7SsMVLbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f0Cvkf2sp+kRgbkTK47mDMPpUm9D+BoyXCyZWjlpiO0=;
 b=a8HLwxcTEWISdCQ4/AuKZkiENiMKVdaT9G4NBwzoyrjHx9as2PmBbb2npe/HYXWWDa0WQo7YyDZX+XZOS/IvOktJaOu05XUBUJw84+V2soeAfStT3JvaSUcFPDnvqc1i9L0lFCrYWhua9NNkdMOySx0xdgvy8K67M7Yuv62ZBA8DkSRVrT8f3JQApuD7nv5EnhbqOCYTCqyT2Z1D3w3pGV5AuKycv8D4iIp7nfYc9BdgMVxVrq20mCWjwr0ZlF7rcdGbWYgNqH/rHIZ2yqvGuAYB7x9m0RY1/aZy4aWHr1jRqpxOe7WYH13tV8a6P2Yy88AU4sCXWoOr51jBQCSD4Q==
Received: from PH8PR02CA0028.namprd02.prod.outlook.com (2603:10b6:510:2da::29)
 by LV2PR12MB6014.namprd12.prod.outlook.com (2603:10b6:408:170::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.25; Sat, 5 Jul
 2025 07:17:35 +0000
Received: from CY4PEPF0000FCBE.namprd03.prod.outlook.com
 (2603:10b6:510:2da:cafe::8c) by PH8PR02CA0028.outlook.office365.com
 (2603:10b6:510:2da::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8901.24 via Frontend Transport; Sat,
 5 Jul 2025 07:17:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CY4PEPF0000FCBE.mail.protection.outlook.com (10.167.242.100) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8901.15 via Frontend Transport; Sat, 5 Jul 2025 07:17:34 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Sat, 5 Jul 2025
 00:17:22 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Sat, 5 Jul
 2025 00:17:21 -0700
Received: from localhost.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Sat, 5 Jul 2025 00:17:20 -0700
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
Subject: [PATCH v10 2/6] KVM: arm64: Update the check to detect device memory
Date: Sat, 5 Jul 2025 07:17:13 +0000
Message-ID: <20250705071717.5062-3-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250705071717.5062-1-ankita@nvidia.com>
References: <20250705071717.5062-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000FCBE:EE_|LV2PR12MB6014:EE_
X-MS-Office365-Filtering-Correlation-Id: c89a6c5e-7447-43ae-4047-08ddbb94037d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|82310400026|1800799024|36860700013|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?n/Pk61f9jY3EWwqvMSiVb8K4g3oFyzEDvc+kvpKbaLdJTPajVBIxEkLqDoX7?=
 =?us-ascii?Q?0vCPe4haSUTR3Uu6PlPyYLGU1lvXkQn8zei7akoToSKuFOHW62gLHGxWYHyw?=
 =?us-ascii?Q?iFgr410RMCAMneKmyQw+AQpUrBWNKuGqcsEuRfCBnFAS2z1u/2v0EZ9VaVQD?=
 =?us-ascii?Q?SBfBFmLwWLYcaoy9NrpOwd3JY142yN6/pPe2bb0+QRBkYojdiflqZ1X+jz1p?=
 =?us-ascii?Q?bFiTbXig0r4Eu2NSSMawUi4NOXu0vNtM5mdLnX7oWxAo23BlOORDkdZ88kwT?=
 =?us-ascii?Q?HhxHRev3gW5uo+nz7fyE9+Ikm4pRt4Fa3UEECAYJPnpyKHVhwDdFzrOzAOQC?=
 =?us-ascii?Q?uw5D7hNUz316UYJlkaDFXHlr9g+/bk1ReOF3mGr6PbBot0IhCD2m/he6O4TZ?=
 =?us-ascii?Q?CQFVBMAOTe5qeFKUvA3XCfYdLJG4OJHU1RR7PEXVqa0dsXL0dejRZPhVKT7W?=
 =?us-ascii?Q?nBRA1QNDILdR+hC/AunoE3dIkmn7HsBk2adt3jMiRxgNHptGRY5/gGUwu6k3?=
 =?us-ascii?Q?pShDjjh4Q1eKWZ1PhXbYeSsLywmY3RkxLTDqv3/Cy4/MnB+zxpoppXTPqwVq?=
 =?us-ascii?Q?x5j2nHbLxT6jryHMpn3kVF8bLj1rsmn/RDBP+5BGxV0PA04XcWxiMc1xlo5T?=
 =?us-ascii?Q?UY83qG1L0o5Oh/xYvVHu+vWDIgNz48D8zgyl3cYOx6FMk1mwXF4JbSvS3BHz?=
 =?us-ascii?Q?FfHPGMewDm4kTNnl2c/ZqlW4qIcgf5rpx985+ONivaa68Hk9HLve3/eSeZFa?=
 =?us-ascii?Q?RfjfyM/vs3aew5IjYm1rBoRS7isdhnFBKN51ezdz5UJN3Pa3/LgVzAGCGAJ6?=
 =?us-ascii?Q?US28PkvCu2Ku+U4CWf9PvyTdp22AtRbFKYxkZUv3OkUfSwLULDOWHD+usxqZ?=
 =?us-ascii?Q?aR5Han5JsizfrW/earPpkrXsSFHd5sw4ENtjzEVpWhkqs+gBzIY/YjFT7B4n?=
 =?us-ascii?Q?yYLmUxgIZdo++Jr5a5L2tovjWrvfcBCXszavOrY9kxS8GqJOn/ucRcqrT/oR?=
 =?us-ascii?Q?EA5sauBfu2PpRY5NT8+qERs9lszs1rSlrOekVhWDqgGxlHWxda2ISY664BJA?=
 =?us-ascii?Q?r65hzJ4lH/b9nW6qUuWtPqgHbT5jPqCmVKSSOHjzfwNxOPkMaobaAFDmofK8?=
 =?us-ascii?Q?cQKq05n33Yo/jPj9PoyBS3kC7DShevK8/fx4utDicv8WU5xAg1DGzItrDQaQ?=
 =?us-ascii?Q?aIMxpkgylt77S0BrjCKLQXxjptbU2muH8WQQ9AGD7OIzaQaEFPrQ4V8MJ6E6?=
 =?us-ascii?Q?S9Ja6/m9IUms84743+fdqibpbgojNVMu95DojvcIuiVP9v2J2Cmv5oVIDhUT?=
 =?us-ascii?Q?c7bgmlJNMDWNQB9Pf9BYG8x9viQHsokt5e6UE5K5y6kkrsfNTyPqsSlmfoNu?=
 =?us-ascii?Q?+rZ4vOe4wP8x/IrhZi144A3D6DM5VJL/vB5VAVC4LU+DxqfPD5mZ1pvoBa/o?=
 =?us-ascii?Q?Ig6ef5bIE6tKk2/gWkSwtqNtM+zmnitS6mpBFaxFLm2HMD1UYK61KFIlmY15?=
 =?us-ascii?Q?RsEmaIVYJCk4Ln2xOWQJvD4PR0hjCN9ESCwFoEV3T37X9HdVScXUTUeYVg?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(82310400026)(1800799024)(36860700013)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jul 2025 07:17:34.4001
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c89a6c5e-7447-43ae-4047-08ddbb94037d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000FCBE.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB6014

From: Ankit Agrawal <ankita@nvidia.com>

Currently, the kvm_is_device_pfn() detects if the memory is kernel
mapped through pfn_is_map_memory. It thus implies whether KVM can
use Cache Maintenance Operations (CMOs) on that PFN. It is a bit
of a misnomer as it does not necessarily detect whether a PFN
is for a device memory. Moreover, the function is only used at
one place.

It would be better to directly call pfn_is_map_memory. Moreover
we should restrict this call to VM_PFNMAP or VM_MIXEDMAP. Non PFMAP
or MIXEDMAP VMA's must always contain normal pages which are
struct page backed, have KVA's and are cachable. So we should always
be able to go from phys to KVA to do a CMO.

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Tested-by: Donald Dutile <ddutile@redhat.com>
Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 arch/arm64/kvm/mmu.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 1601ab9527d4..5fe24f30999d 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -193,11 +193,6 @@ int kvm_arch_flush_remote_tlbs_range(struct kvm *kvm,
 	return 0;
 }
 
-static bool kvm_is_device_pfn(unsigned long pfn)
-{
-	return !pfn_is_map_memory(pfn);
-}
-
 static void *stage2_memcache_zalloc_page(void *arg)
 {
 	struct kvm_mmu_memory_cache *mc = arg;
@@ -1492,6 +1487,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
 	struct kvm_pgtable *pgt;
 	struct page *page;
+	vm_flags_t vm_flags;
 	enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_HANDLE_FAULT | KVM_PGTABLE_WALK_SHARED;
 
 	if (fault_is_perm)
@@ -1619,6 +1615,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 
 	vfio_allow_any_uc = vma->vm_flags & VM_ALLOW_ANY_UNCACHED;
 
+	vm_flags = vma->vm_flags;
+
 	/* Don't use the VMA after the unlock -- it may have vanished */
 	vma = NULL;
 
@@ -1642,7 +1640,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	if (is_error_noslot_pfn(pfn))
 		return -EFAULT;
 
-	if (kvm_is_device_pfn(pfn)) {
+	if (vm_flags & (VM_PFNMAP | VM_MIXEDMAP) && !pfn_is_map_memory(pfn)) {
 		/*
 		 * If the page was identified as device early by looking at
 		 * the VMA flags, vma_pagesize is already representing the
-- 
2.34.1

