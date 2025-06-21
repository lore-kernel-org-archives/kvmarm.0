Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2052.outbound.protection.outlook.com [40.107.236.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBEF618BC3B
	for <kvmarm@lists.linux.dev>; Sat, 21 Jun 2025 04:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750479689; cv=fail; b=MQvNgvYzP93S2in7ZcL4XUyQtZxNO9ewxf+KXzbJHi0ziMM2mWsGmst0NbNZerCeSidaOndzaVvjjOcrsB80YZ/NUACczBVhNngb9HsYMjDYTgIL9DtC0y8jc0amsP3XMGv23ovyvruirswznhDMKjtHJujMYcAMFDL8gtojjxQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750479689; c=relaxed/simple;
	bh=K1A9meQeof9rBgV+v7BXlANJ8oaClq5ZlobMDdSaDH0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GHwITz1ntDiASHOaCuRbw87og4Eym/bDhqHWlz/1Kq0x2nk6/tsZYWgSNMmL1ZbcahQ6Sg7U8/pbemPIa07ks2Y3mublMY762AS5FLhBSingUHYdDhZPm/Un3RxB+qIIDvnajT9rFVjDlA5VwpwAguK4Hu28A6M0AeyI9CIT86A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=gTbAFUBl; arc=fail smtp.client-ip=40.107.236.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="gTbAFUBl"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RE1kXwUYdGyuJ4q68wNNmLP6OcmRGcCNKQsH5IBDILZ594KD7o0auFwGEWVZu2lq/WkYG/RplmIos/P9Jt9tvRCBLeeWVfXimgu0ekvpEVheLGg9KcMtxSsAFleOJ8987dUazY5z305A/z18Ch9RQ0rqhSFscOIPHEOlXHXtsvsYORmW2gNGsD8lqhLZzwsIuepKU5BFL6vLwducDgvL+5I1BjZttGWZM/uzz5hwkuMjdum2cZm8DcS+nEZwndZWsGIVtrOeJLsG+6uGioWKwgQa5+mp2XiSv/+q+b95PATnruXfAyuvCK19MgL39QeXQDB8s11T56pga4onh0BHfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gIQt+tY6R4HF3xyakMnOf2Mpw6CcfJPzeKMWV3H3vDk=;
 b=ml3PhuirImnR2W/Hp3iNJF1PPG5CRQrDyv9qG61JDH1tfCqre5TyKau1US+vPp77cjPCKQGy3AkPIF8+QhHWe8p65ARx8/on4K9DXG5+Y17HSQo4OQIOpwJy0SNL0wKHc5FeUruZW8xCm9D0LNhUT0N3nr5FgtMDwBDctsWsh7F/3susz5fsWtr+1VXTkXbfqYb0lXtIjh+xaHgH8lGaJ2rOLoLxFVsXBY3U15MceROJtw9IOqz45cd4yM7OG5zXW31WBn9wDIOcnkwGbuuofnIM7zka1csNgIqtqbfupXxSkxs2osaWTADsVe/lvDoL0s0+MYk2GBn1Z2c730mdaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gIQt+tY6R4HF3xyakMnOf2Mpw6CcfJPzeKMWV3H3vDk=;
 b=gTbAFUBl64wO3UAZ2mFZuO8jEOeZZCvWEGbjtHyvYYc94rh/mgeDO+ei5SJ+7d5J/rSk/BfyNaS3wUN9is8wN0ix4/pQ6MGoj7h+aGuY8ZkVhNd9NfKmvWrHkMjbAgWS3Sr8Hx/U/7h3sguaPNX8oE/9HrQ4xdYqiqXCuS4VSSm7Kxo3ktGaaBF+6ynjWNI3GdMd6fLwSrPE7bHWHCKBjE13yYFEG4ydqRiVhAFwgPbOQCldWdZeIMou1RJPPunImf65PJIybdveLbPGbClPpugwFyyjsz5a28RkeXQ8M4KdIkdM+PXOX6uYNcYDiKc/Nne20NW5bWKz10wfeJdFZA==
Received: from MW4PR04CA0365.namprd04.prod.outlook.com (2603:10b6:303:81::10)
 by DS7PR12MB6168.namprd12.prod.outlook.com (2603:10b6:8:97::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8857.21; Sat, 21 Jun 2025 04:21:18 +0000
Received: from SJ5PEPF000001E9.namprd05.prod.outlook.com
 (2603:10b6:303:81:cafe::d1) by MW4PR04CA0365.outlook.office365.com
 (2603:10b6:303:81::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8857.26 via Frontend Transport; Sat,
 21 Jun 2025 04:21:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 SJ5PEPF000001E9.mail.protection.outlook.com (10.167.242.197) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8857.21 via Frontend Transport; Sat, 21 Jun 2025 04:21:18 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 20 Jun
 2025 21:21:13 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Fri, 20 Jun 2025 21:21:13 -0700
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
Subject: [PATCH v9 3/6] KVM: arm64: Block cacheable PFNMAP mapping
Date: Sat, 21 Jun 2025 04:21:08 +0000
Message-ID: <20250621042111.3992-4-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001E9:EE_|DS7PR12MB6168:EE_
X-MS-Office365-Filtering-Correlation-Id: 67d95c7a-d3f9-458e-f9f7-08ddb07b11c1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|82310400026|36860700013|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?f/RVfkGg/fXXav/JQlwH7pnxpeY2OZAEWztMI535haN4tDMDCSuKJG+P45nT?=
 =?us-ascii?Q?KeIAZO+wUmuY/438G5fZb+LqVYhbeXOOZ0q5KK5yTWlrYVrd+rRzpeaRKlsc?=
 =?us-ascii?Q?NcAsl/QdSnyDH0aTodGXJAL6jzyTRXWLtrpVmYn2H5FT+fzUVhTD2y0vTPkq?=
 =?us-ascii?Q?UfmFjRkUrlCDU/P5Jremt+ZV4RiEWWi4qL4+bJQPA3XjRdQWH5NfmBbP5DD9?=
 =?us-ascii?Q?pN59GMRszrsbzRsqXT51ruKbOvUDfBk60fBsGbi0QkmoyBUZjWlbUSj6Ln1r?=
 =?us-ascii?Q?jioXiw65dzKIjr1Dar7H4YNgO6NE/9wEXYYjzyzp+CcrrKgNNKKbyul/h63C?=
 =?us-ascii?Q?z0s82tGtN0mVMHRCk7H4AclhEjOoeEnSEttp+4Iagc25nL3YPPemfZ9L4qZr?=
 =?us-ascii?Q?2H9OS1ctzeJXeZvfbptVozXjHxmz819xMnQXeYYt8yk37sETbbvvdNLOfYwl?=
 =?us-ascii?Q?lAMMH+1vWUpTtx/+DxktrzZfQo0OY3QEJ3DjufqAzuVOFXx9CEuMBJk7DTN+?=
 =?us-ascii?Q?6Ja2sAYtOFzJ3Vl+n59US51RUviOhFQJwoLJ2pAK8+O5QXk0A2upTTP3F5Ae?=
 =?us-ascii?Q?ae2UBnlcbpMt9x4Rqfe2yPrJ/B1GhMG6wS+PY2/tGZgVBnalNOwfcneePMLv?=
 =?us-ascii?Q?vnosg+H7nY5DYkpDnvpjumoZjmYxDHMOdvARbuIUnldCyHMny3fqcgYC5FMt?=
 =?us-ascii?Q?yUIMss6qijPCBAnyNkYX+l9uwkXbQT/oCnv4N7/EhoEj0FIkbQD6bltxCecK?=
 =?us-ascii?Q?mjKM2nzWrZYqp01QlJwZFMNMDXGs5dOUOuNHvzrEMVe6h/6piDAViYfsFbFX?=
 =?us-ascii?Q?gKQUs5oVmRWgj4eBthlgr30wUwSnSom8riHbpzQeBpBhhUJBGK2cuJtLIpvJ?=
 =?us-ascii?Q?AFllL6abtKra7331+4tFomd8wn4ukD7EncGec0CTp0OngG/rtFmWfGYdRiTx?=
 =?us-ascii?Q?jJLBuLP4Zm7QOYEo9w9AC7zNTaGXKQBGxLk8RBm7FOhJNs9cpqo2VYGFOLw1?=
 =?us-ascii?Q?Q7GlZ1Jq0mfKXrW+phar10owEhlreR8Zdny/DH2W1GDSjHClokYpsSvJFiTZ?=
 =?us-ascii?Q?Fhj49zroe6N46Hvdgmp90d7u6C5McQJRf4gMPHWRQzLQ4b/T3BqLpDh7QAak?=
 =?us-ascii?Q?fXoPqYSVJwEdftxoIF5pVJR1X2HDHNC1JjzAJWj+syfPcMqfPQxiArRPG2HE?=
 =?us-ascii?Q?lg6slS3S3ON6hNfQJMUdzFOFj33MMPgptW+KpkYdZgFD01BSRtxi8C34IJja?=
 =?us-ascii?Q?F2L4egAMCCY5EidZEQicEsGayXU4DoKvb1Q+Q1mqaTn/gNz2bynnJ8akkKX8?=
 =?us-ascii?Q?ndvxVMnRAxoXqCdpQF48E9a5U2Qhzjchn6snnToaRnr6fw8zZHINaTysmufD?=
 =?us-ascii?Q?IN7fqcj/D6u9aLgcPaPwOMezCWD6LJzV6Ukr5lDDJPUDrfE6HVi7dqEbJIzL?=
 =?us-ascii?Q?gk6rVpKfjKkh3TNQ91eBqOviMmdCbW5Z6I4y4uIsFdW2/TEBfuMZdstTjsZ9?=
 =?us-ascii?Q?tBc6QftacSlmJPXfWKSzghxqf9GAl7Z3FV8+fmArBifB86yLHU/wCA1Fjg?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(82310400026)(36860700013)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2025 04:21:18.1645
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 67d95c7a-d3f9-458e-f9f7-08ddb07b11c1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001E9.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6168

From: Ankit Agrawal <ankita@nvidia.com>

Fixes a security bug due to mismatched attributes between S1 and
S2 mapping.

Currently, it is possible for a region to be cacheable in the userspace
VMA, but mapped non cached in S2. This creates a potential issue where
the VMM may sanitize cacheable memory across VMs using cacheable stores,
ensuring it is zeroed. However, if KVM subsequently assigns this memory
to a VM as uncached, the VM could end up accessing stale, non-zeroed data
from a previous VM, leading to unintended data exposure. This is a security
risk.

Block such mismatch attributes case by returning EINVAL when userspace
try to map PFNMAP cacheable. Only allow NORMAL_NC and DEVICE_*.

CC: Oliver Upton <oliver.upton@linux.dev>
CC: Catalin Marinas <catalin.marinas@arm.com>
CC: Sean Christopherson <seanjc@google.com>
Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 arch/arm64/kvm/mmu.c | 34 +++++++++++++++++++++++++++++++++-
 1 file changed, 33 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 5fe24f30999d..68c0f1c25dec 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1465,6 +1465,22 @@ static bool kvm_vma_mte_allowed(struct vm_area_struct *vma)
 	return vma->vm_flags & VM_MTE_ALLOWED;
 }
 
+/*
+ * Determine the memory region cacheability from VMA's pgprot. This
+ * is used to set the stage 2 PTEs.
+ */
+static bool kvm_vma_is_cacheable(struct vm_area_struct *vma)
+{
+	switch (FIELD_GET(PTE_ATTRINDX_MASK, pgprot_val(vma->vm_page_prot))) {
+	case MT_NORMAL_NC:
+	case MT_DEVICE_nGnRnE:
+	case MT_DEVICE_nGnRE:
+		return false;
+	default:
+		return true;
+	}
+}
+
 static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 			  struct kvm_s2_trans *nested,
 			  struct kvm_memory_slot *memslot, unsigned long hva,
@@ -1472,7 +1488,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 {
 	int ret = 0;
 	bool write_fault, writable, force_pte = false;
-	bool exec_fault, mte_allowed;
+	bool exec_fault, mte_allowed, is_vma_cacheable;
 	bool s2_force_noncacheable = false, vfio_allow_any_uc = false;
 	unsigned long mmu_seq;
 	phys_addr_t ipa = fault_ipa;
@@ -1617,6 +1633,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 
 	vm_flags = vma->vm_flags;
 
+	is_vma_cacheable = kvm_vma_is_cacheable(vma);
+
 	/* Don't use the VMA after the unlock -- it may have vanished */
 	vma = NULL;
 
@@ -1660,6 +1678,14 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		writable = false;
 	}
 
+	/*
+	 * Prohibit a region to be mapped non cacheable in S2 and marked as
+	 * cacheabled in the userspace VMA. Such mismatched mapping is a
+	 * security risk.
+	 */
+	if (is_vma_cacheable && s2_force_noncacheable)
+		return -EINVAL;
+
 	if (exec_fault && s2_force_noncacheable)
 		return -ENOEXEC;
 
@@ -2219,6 +2245,12 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 				ret = -EINVAL;
 				break;
 			}
+
+			/* Cacheable PFNMAP is not allowed */
+			if (kvm_vma_is_cacheable(vma)) {
+				ret = -EINVAL;
+				break;
+			}
 		}
 		hva = min(reg_end, vma->vm_end);
 	} while (hva < reg_end);
-- 
2.34.1

