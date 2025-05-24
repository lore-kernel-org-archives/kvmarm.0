Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2067.outbound.protection.outlook.com [40.107.243.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02FBD42AA5
	for <kvmarm@lists.linux.dev>; Sat, 24 May 2025 01:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748050803; cv=fail; b=D980pZGcfi4xztPGXDpjbWeSXJUy5RpLUhQSDin7Kkint8bZuJXzc/fFauVPypYzX9UVP/MGeZ5SlFOh0s0apjhQ5b0RrXMNSUtlL+6yeThZ6F5EWzhTu3RfBA4cMPzAd1RQxpigraZJ8XYDgIL85az126EjK/qXEvIABovwogk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748050803; c=relaxed/simple;
	bh=qEeUq/6NBwjqTdME6bWWYamWJR/prEA+1r+zsW1vQ2E=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FuyeMQ8BsqwPn8GS2x2tdm+W4qohwC04KsQsWnVeScydPZXwxsEwjpHC7c5H3Y4F0rVhjJ1CPPfL8z8/Z0cQ5MqF/GjkWuMvv1jPm1fmW9Na1YMQxDBsxd44Tt5xI5oE4CAMNE1D9PcEP+fW5sbqZ0uT5Q0p618Qtt4bfEsbGos=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=QN761z9G; arc=fail smtp.client-ip=40.107.243.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="QN761z9G"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SLIaR7K4kKK9MKY/1QmyrB4a69KDvSdE3LtO7cVPlzpvLPLP0TW9s9zNhUbGqh+zolaeMzF24oYBYX824PtCnk7giiuR6zev1jagJQeSwpHHlhjqR6iek0dsLHiwbWxnJJobvL+NwFnU6I1V9/07M3N6oEXDIVK+NiaY8V911Og6if+dpZnpf0TA0/XIdDKNlqE5DmCXbIQ8MfNC3ltBFRju//2MkcCqtO/YVHQqlPAFvrplI2Y6RFeahlOHda7OUxX5zLutisSAmH5xsoSXSAdC3NeQyD4JZBJXstNAGFMF3HcWelMmeJK9K/GLrNcD6ZCxJGin2begy1+phbMmvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gymzk3KsFCNp8Z21DTOLHrkEpVUsP4yOo0PLr+aRcVg=;
 b=ElJmRLgWJcJlbnxoT40S/XRCvd3nLkEUAikxGjoOFagOSfzQbEIqFBj6WQyav3eTipq5QVC/UofycuDkd8oTnSZ584TpeMclwdkVe5+8qwFGO+A7YNTDEix0ADXKH64tmXWgPR16bKGOCEXdUI3ODl1L0LzeS/yfw+PIjZuXKDz1v68WWLn/Upb2mifhgYIsU8JQ+JRKbGhDHueCK/iyMgkTK5aj2SoHRJ/bhAXQ+ovcTVs1B5R450bQU6n2OQ8oUIkzbgztd0w2PdIO223sntQzM4V3+Qoys5CZ/2B81bLB7PweeaqBUtnYRdzwlM9bwP6tfLUZBLUWUB32Sg28mQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gymzk3KsFCNp8Z21DTOLHrkEpVUsP4yOo0PLr+aRcVg=;
 b=QN761z9Gah9rc2BkVxo/Gh5I1wzFIZzWhxekQk/0JTecZ2pnM32OAxwqJgXedL69c8CW5SS7+NunS2M29w57R1Pk0T3pnDTIVVAEoH6IHj9U6BrsTGDuBJsQcOP65OpjiVP0IJW+5hZWQuvfF7ALMoywvrCwF+E//tYo/tg6NNzH4sTruTQgxI2jbhXshR9R7na25VP0Cc45n1qdSj6/lBWjEoQ8yklNzog9psO/a1Utf9ZiBs2M8h91oGASzZHwsdnx5msX2f5E115vYCQlKudk9M9hqaoM8EI1LrmYP/1kU6xAU0kxj2o31Ba7UQbLgvqKxBh0k2kdaw+KSBWOGg==
Received: from PH7PR17CA0004.namprd17.prod.outlook.com (2603:10b6:510:324::15)
 by DM6PR12MB4139.namprd12.prod.outlook.com (2603:10b6:5:214::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.31; Sat, 24 May
 2025 01:39:56 +0000
Received: from CY4PEPF0000EE31.namprd05.prod.outlook.com
 (2603:10b6:510:324:cafe::96) by PH7PR17CA0004.outlook.office365.com
 (2603:10b6:510:324::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8746.32 via Frontend Transport; Sat,
 24 May 2025 01:39:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000EE31.mail.protection.outlook.com (10.167.242.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8769.18 via Frontend Transport; Sat, 24 May 2025 01:39:55 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 23 May
 2025 18:39:47 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Fri, 23 May
 2025 18:39:46 -0700
Received: from localhost.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Fri, 23 May 2025 18:39:45 -0700
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
Subject: [PATCH v6 1/5] KVM: arm64: Block cacheable PFNMAP mapping
Date: Sat, 24 May 2025 01:39:39 +0000
Message-ID: <20250524013943.2832-2-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250524013943.2832-1-ankita@nvidia.com>
References: <20250524013943.2832-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE31:EE_|DM6PR12MB4139:EE_
X-MS-Office365-Filtering-Correlation-Id: 470d9e0c-931c-41c4-0132-08dd9a63e313
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|376014|7416014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ERDLZkeAAACLanuiRokXO99M+sAQAiwv7Qh7nZr92CkZBtQ8JlKAth9Vw8l8?=
 =?us-ascii?Q?2sISCzNvodKAs8zCrHuBO+ZnTqH/H63FQLg4VUl3VbnKsVA+kdarFwU57/6V?=
 =?us-ascii?Q?IWMARsePfbhT1hi2rEAY5WpRTxGHdN5pcEOqojlv/m/AkllFoCDN4QCLkHia?=
 =?us-ascii?Q?uFyZVdqvcrNogffw7kpGphS01OXWLgU0+9oKVKnzCAYO/zPvhqYdxvqkWRyI?=
 =?us-ascii?Q?A8sdbG3XtI4FlzGgwGUbY6K+c9HE3WaBfT256A/ohmOmfSFTFbhB8JYB4iEY?=
 =?us-ascii?Q?dRhZF4CZqqH6mF4NgKBry/fGgOElM/hEt2a9E26+x350kBCyvaKMufbyPBAz?=
 =?us-ascii?Q?WnOyfhFQhOYkc2zXaEu3I34DP6/05VOS4b7VWtJPERbWqhJI6y5ieC1/diLE?=
 =?us-ascii?Q?K/rea8EfQI1aPXOaWw+H56QRo//OSpFVWOqN+BErNo7lQhtypbiS957jjHBt?=
 =?us-ascii?Q?Ic4Ft4NF4uDP/aQNRbvmwRTEW2uJoqiYS8zDYtz8bvwo/3vcVHYMWB8IIXH9?=
 =?us-ascii?Q?j3yktibiTHSuLThXWjOMg96URK25xHeUhqDCxPh0F2nq9AeOOjy3X+HwOutP?=
 =?us-ascii?Q?J2FospPPtV/uMm2ZZxEW9CnpuIxEkg5yMJ7G1scDvbP1lgZnuhHIkRFpcbvT?=
 =?us-ascii?Q?2caDdoiCrpX9hETe94Obl/StTavV3jJLwYFhUMfuVlYYD/m0D54E2O98QXd+?=
 =?us-ascii?Q?2aGrjOtZkGt1BYmAfOF9N6bmzQkR/vthqVotsEMrOlhJJF7e+jJBJr17QysR?=
 =?us-ascii?Q?oW/CWQWUaZjR9SG1sw6DeZwzKCJCRDm/k1FILSZEKAFFzJU5Cxpf+sZTKeQe?=
 =?us-ascii?Q?xRmQisZqb3F+nKyMnZm7QERJwD5pcDMKuHAhOg4+Zf/Gw4EYfGnOxQFh+IdQ?=
 =?us-ascii?Q?KkEcH2Og/RA5gbZw1U9Chnyc1aoSKJLc590qHCyvh/Ei6n1nS53/6WiDAah9?=
 =?us-ascii?Q?Q8gtwRBcrmNoZkDheAMSoYmhyDHDnjmz2SfUyuXIutcVIxaBHdrj5y33dYL0?=
 =?us-ascii?Q?piLUegXghhpiFbn07GrbZ3FaKce9HeMpwJqV8tUBPZ7yWlMyOXdl8Im04+0G?=
 =?us-ascii?Q?f4P3KKijkcBG6+2wV/ifd5QZ5QKBAd3ymm/6jVuFIZ7Bb5KV6YTEIpSPL6xT?=
 =?us-ascii?Q?N9zK8csjmdQi/nj2Yt5VhnNu6PbmRUoCGrr7y+/9jZ6jSqjYNrOBlEwluUmi?=
 =?us-ascii?Q?bwX6hrWZ1Kng6xfctqSsqtFppldo+ulmDqaF5f2efpN1nY5WA8MvQVAXUlFN?=
 =?us-ascii?Q?T3WTJ7p92Hni/ClBtou4jt7sLP1M6Qf1tzJ0tFQHv8HDI7gndB3/XmFxhIdb?=
 =?us-ascii?Q?Y8Br8mQymd1EsOu8P91h1phy8AjsT0Vo98HAPwOLQki4tluf3LDtM3uWcKyB?=
 =?us-ascii?Q?b0haIWJKXKQL1CycYbiFQ5VRf1BoyUPwe6+PIEhyFpk3eCX83c3rVxgFqTYB?=
 =?us-ascii?Q?sW9swVksb/4qAaR5SIniXXj815WAK9b7W5XQRUrIDzseaW7TfjayNOLzVg2u?=
 =?us-ascii?Q?0clRJd/nw/rIlsQaPsKmnWWDGj5RoJpMPOqcqR5ANqfK9Xia1xgSCMSPbA?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(376014)(7416014)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2025 01:39:55.8170
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 470d9e0c-931c-41c4-0132-08dd9a63e313
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE31.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4139

From: Ankit Agrawal <ankita@nvidia.com>

Fixes a security bug due to mismatched attributes between S1 and
S2 mapping.

Currently, it is possible for a region to be cacheable in S1, but mapped
non cached in S2. This creates a potential issue where the VMM may
sanitize cacheable memory across VMs using cacheable stores, ensuring
it is zeroed. However, if KVM subsequently assigns this memory to a VM
as uncached, the VM could end up accessing stale, non-zeroed data from
a previous VM, leading to unintended data exposure. This is a security
risk.

Block such mismatch attributes case by returning EINVAL when userspace
try to map PFNMAP cacheable. Only allow NORMAL_NC and DEVICE_*.

CC: Oliver Upton <oliver.upton@linux.dev>
CC: Sean Christopherson <seanjc@google.com>
CC: Catalin Marinas <catalin.marinas@arm.com>
Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 arch/arm64/kvm/mmu.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 2feb6c6b63af..305a0e054f81 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1466,6 +1466,18 @@ static bool kvm_vma_mte_allowed(struct vm_area_struct *vma)
 	return vma->vm_flags & VM_MTE_ALLOWED;
 }
 
+/*
+ * Determine the memory region cacheability from VMA's pgprot. This
+ * is used to set the stage 2 PTEs.
+ */
+static unsigned long mapping_type_noncacheable(pgprot_t page_prot)
+{
+	unsigned long mt = FIELD_GET(PTE_ATTRINDX_MASK, pgprot_val(page_prot));
+
+	return (mt == MT_NORMAL_NC || mt == MT_DEVICE_nGnRnE ||
+		mt == MT_DEVICE_nGnRE);
+}
+
 static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 			  struct kvm_s2_trans *nested,
 			  struct kvm_memory_slot *memslot, unsigned long hva,
@@ -1612,6 +1624,10 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 
 	vfio_allow_any_uc = vma->vm_flags & VM_ALLOW_ANY_UNCACHED;
 
+	if ((vma->vm_flags & VM_PFNMAP) &&
+	    !mapping_type_noncacheable(vma->vm_page_prot))
+		return -EINVAL;
+
 	/* Don't use the VMA after the unlock -- it may have vanished */
 	vma = NULL;
 
@@ -2207,6 +2223,12 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 				ret = -EINVAL;
 				break;
 			}
+
+			/* Cacheable PFNMAP is not allowed */
+			if (!mapping_type_noncacheable(vma->vm_page_prot)) {
+				ret = -EINVAL;
+				break;
+			}
 		}
 		hva = min(reg_end, vma->vm_end);
 	} while (hva < reg_end);
-- 
2.34.1

