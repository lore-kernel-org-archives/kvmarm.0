Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2064.outbound.protection.outlook.com [40.107.223.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0079118C00B
	for <kvmarm@lists.linux.dev>; Sat, 21 Jun 2025 04:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750479689; cv=fail; b=ZjxVq6OXoH5O8xG8QQXpUg+w1taXFhixx1dlBz/WdH//gVKLPPjHnXKmHFljZT+yCEH+3aO6y5UBq8z0LZDViIdFxPCSuCc2iArXZfBwQ9g2QCZQWZHGw9aBqel9SuYB+xRg2WUZRS8BocVW8l6o0m6fnXbFwK5ZGJHD0YbTU0o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750479689; c=relaxed/simple;
	bh=3+moh0OZKUfUBXWWIl49fEtCdmeyDhWabI8f1Z0byiw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OnYXBhp0q0P8J5VhEHwiXdC21NmSgR103prZWNWFxTM9y/B9o6He/IflAtGQceSdmtiwOXYkOT/BvNK/SGB3jzQVRKbBV4HkZr0GSTUBSKwEqlmB2keY7VDDKRHBfuUMpGoNe+BDFohLJsoO6sNzfFSNvItPjGuwm6jdvVNVAE8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=maGoUXxJ; arc=fail smtp.client-ip=40.107.223.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="maGoUXxJ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vHl7tygYNZj95cwjF0MmDCqscxArfAgC1Y3sWLUv2yI3E7b79S1DDcmmX3bmMLjxWrhLfuGKDfaj6yg2iJtL5sHrTR6qDmDYAByqtm8re/k7CFkfN0WMcvuyHy82vp7PHN261oa0RlhKdTuPYJA1AGRLlEuT+5dHYFszZ8juuFtv1AIiN5lL7Zyl6M0sIsHE5DhmGwL6asCHDYohE1FPL2WlsH0PyUdaPJOFdg7l7BVZcY/1Yht6beOvwFIiopvfQbtF5HRmphgqKdDRwtJnGMDfcHhZKgkuhgUnHOWJgDcnJVcXeBhzaGfVU9U6ajJ5fAKA+4AOQbHIyzxVb0wiVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9qPPZZJ2UBQ842rogNTNRFs1AK2i4MWc6cZYer/+iGk=;
 b=W9iyLAF+gqYQqKv5LaewFGJWMTxFOWOS3O7dF4unUfRBoL/3/4Mz+8J5rfXh2f9oSd2MOgIeGX6G7WN2ChT5ajj8YMpj+ZXbnRzwEi2yrh7r+NvYhY6dONqtK7Wr1GLdrm9a3qu98oXrxdBbMif0e038kMLNvdlc/kVvSt0JdJLJSDffXLEU+8WCE0K4TPXNWh8jnMLmvMsHdl0m2a3aeGKmv8bx0agzc2ZkF0u686w/RmTlC72gpjKWjM9+PgOSFoDTd7zz+Rot8xk5k3pCd3nb1URp6E5QtiCBin5sU9iuCF4xEh2yWO/OGylefyECQcBi5LGYU60uI3Uhw85pEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9qPPZZJ2UBQ842rogNTNRFs1AK2i4MWc6cZYer/+iGk=;
 b=maGoUXxJLIG+il24OKHmWwSLFQE/qW9oG7x19a/XFyPLLxJkspugEPGhqCuPx2KeaWcXmohQ38LcN42+M5XjjKhY04YMfDLpEb7lf1CqxQeWcGRg9YW1kXG4LGnwm4b5QnMWs5G2nAVVMAD2AfvcgL+177YC7irZDMrzp49uZoxmtgsQAXa0Lh6mo6xZnb03pjNg1s7iaRPl2But5icX2xN+A7R6BGcIAePsszsxRjB06H3oJvfA0VixREwnGsph6WMkeoZvD32CU6j7KyGri538/khnwfi9RiHdhjwuZaU96oFu46NF6/mEzf4yqG9txYbQHf2ZLuycxCHZxOnYzg==
Received: from CH2PR14CA0031.namprd14.prod.outlook.com (2603:10b6:610:56::11)
 by CY8PR12MB7513.namprd12.prod.outlook.com (2603:10b6:930:91::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.23; Sat, 21 Jun
 2025 04:21:23 +0000
Received: from CH2PEPF0000013F.namprd02.prod.outlook.com
 (2603:10b6:610:56:cafe::69) by CH2PR14CA0031.outlook.office365.com
 (2603:10b6:610:56::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8857.26 via Frontend Transport; Sat,
 21 Jun 2025 04:21:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CH2PEPF0000013F.mail.protection.outlook.com (10.167.244.71) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8857.21 via Frontend Transport; Sat, 21 Jun 2025 04:21:23 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 20 Jun
 2025 21:21:13 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Fri, 20 Jun 2025 21:21:12 -0700
Received: from localhost.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Fri, 20 Jun 2025 21:21:12 -0700
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
Subject: [PATCH v9 2/6] KVM: arm64: Update the check to detect device memory
Date: Sat, 21 Jun 2025 04:21:07 +0000
Message-ID: <20250621042111.3992-3-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250621042111.3992-1-ankita@nvidia.com>
References: <20250621042111.3992-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CH2PEPF0000013F:EE_|CY8PR12MB7513:EE_
X-MS-Office365-Filtering-Correlation-Id: 844f9cbc-9bd3-43de-ac89-08ddb07b1502
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|376014|7416014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?GR8kjlXRk/HvAszTrkjUYC+3CSKXCyGhm/5g0hhupJlvA/5XavvvfRu9l4xg?=
 =?us-ascii?Q?Ub7tSyEXmGFLsluVFWKeqa3y0sZ8m+vvDWY670wA+L29NkQhQRBj75ViQPyx?=
 =?us-ascii?Q?9xNfGad7oIqUuU6rK3IKKYKF3nFYQRWN5Thbd38OMx2R/8M2ygmjEOJHyesT?=
 =?us-ascii?Q?GjN60Tk8xWkALY8nk/mtCgKlvw8qHjJiBeOLEwBncWlLm0Le+tSEgP40RMsR?=
 =?us-ascii?Q?XoNxBhpbvFQ7b4bb33ZY6IOsISl+khtOswFAC8k9A1DjxaCtM92evT5GRuTt?=
 =?us-ascii?Q?4FFQq+Gb/zEpZ5cbuqeDybFBkfPyNr0sBUU/+J0UHegLYdQFi5yY5KlJjI4G?=
 =?us-ascii?Q?492vVwzVEbqD9PVRgo5JsQ5N4nqnBXyVgFAJiiepqtTNpl/pz1G/MqJq6W9Q?=
 =?us-ascii?Q?AYV3TWuJC59riy1prSMSSUDbuG0y5lE2/G3XqEM86jcr6XW2jIdFkOjj3kml?=
 =?us-ascii?Q?3YUKyZ/EAjU4RprbwNVu6Cpi+4ySjM9tbVVRskDfzAYozgQrAoa1G/f34md/?=
 =?us-ascii?Q?6Wg2WRjQWg+U46Shr/57nDhUvAZncGXZqhrrN1rmbwL/MOn3enoi4lBvVXoA?=
 =?us-ascii?Q?22HNxA/FTyZ4Fl3SQW+rrrzrQBFVi0GLHsZB3g3DibmjqPjs+zTy1KTXVfH7?=
 =?us-ascii?Q?W1OnfJKbjXfaI1OOkEFZak8ko1yvYKF7IIrn5/D8AE4zyzPqQfXWZ67jXdJt?=
 =?us-ascii?Q?0ryCO6lKkTg2OCVQunche2QqJPWe3F7RzJ5mN+vy4alBDTaa3V/OQm8QpxnA?=
 =?us-ascii?Q?lz0/aHWdxPl8WjBia1NAP62evAVk7ZgxnC7QGLV+DSqy+Vxa4KMbxIcsA+ld?=
 =?us-ascii?Q?5uAhZb6IzFlguUNqOd/CrP9PWvx9U4nJY8dq/ImR0Ll+QxliH9y7cy7lAS5B?=
 =?us-ascii?Q?HjyAcW+GvkCxorh6lcmMOSHX23kN7UtDsTOOVfxpZp9jnt5JaTOZbnnV4WdK?=
 =?us-ascii?Q?a31fI9pWDE99/Uwav666pW7lp1WU6pGR3qo6lrl+7ZvRRlkIiMko9i+rxTg8?=
 =?us-ascii?Q?KRwetstcv+fb8gW02g+WyghHeWNWZUOYT3L1vzxATE7J1zbUrhCjjwRQLsUc?=
 =?us-ascii?Q?bQX2dalzX1Jbq2IiYBhMV0GTwSX6DIntVi8m7W+Ji450eV4OV8NP1gdZGrxs?=
 =?us-ascii?Q?1SSgNQTZRvlBZRcfMEBtvpbEsF9TNwleBNWbBGaQKUrJjL/0OwXzWkpG4AwQ?=
 =?us-ascii?Q?2ZS6wZ13aO4h01nRWXrtpo4k6QPxmF4Cv2rlalWXePwCGoDpCjXq4Vi6D6xQ?=
 =?us-ascii?Q?eEs2qthQkp4hz22RvHLYzjm9G9+DCUdGlgDnq6aYlzQczGFsgsE4gIGm0gH2?=
 =?us-ascii?Q?3xSthB5z0IRog2+8igjs0uZkHq8DFPViZ7cx7J4U2UgdUIILh3ycvJqXaTwO?=
 =?us-ascii?Q?pqT3vLvulBx/w8/XPaEDD9xfWX0brbnytYlP5mjzZCdGmOqCJcYqbFtLAgbd?=
 =?us-ascii?Q?NmAibyG4TmSPka3OcnzDu/dj0Pr5eAnpN7LVF9ywMYMmv0hwk/Sy86KqQIEH?=
 =?us-ascii?Q?m1dv61azicXwLi+uZnWKxmflMrF3hrmAHV4zILJQ2V6MAvqgvNm50S5BMA?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(376014)(7416014)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2025 04:21:23.5781
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 844f9cbc-9bd3-43de-ac89-08ddb07b1502
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF0000013F.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7513

From: Ankit Agrawal <ankita@nvidia.com>

Currently, the kvm_is_device_pfn() detects if the memory is kernel
mapped through pfn_is_map_memory. It thus implies whether KVM can
use Cache Maintenance Operations (CMOs) on that PFN. It is a bit
of a misnomer as it does not necessarily detect whether a PFN
is for a device memory. Moreover, the function is only used at
one place.

It would be better to directly call pfn_is_map_memory. Moreover
we should restrict this call to VM_PFNMAP or VM_MIXEDMAP. Otherwise
the VMA has struct pages in it and mapped in the kernel VA.

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
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

