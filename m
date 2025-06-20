Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2064.outbound.protection.outlook.com [40.107.93.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD92E28A735
	for <kvmarm@lists.linux.dev>; Fri, 20 Jun 2025 12:10:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750421402; cv=fail; b=lA65pjWnUZFuxLMM8VEuPtSAgpW/ww0LdKHzanwOhdEF1YgVfgwE0m5h1dKC0JVQYMICBHlvhGJ6AYrypoaIlnCa2MbrFy0tTNzRRHFqpV/GEQa8Nr8RpRlpVM5eKHr1o6tx42C8KV5F9ZNon28L7zfMlUpMdDcD/DeH8tRpp4U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750421402; c=relaxed/simple;
	bh=3+moh0OZKUfUBXWWIl49fEtCdmeyDhWabI8f1Z0byiw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=l1Njo+YWGjR7KsWbkdIAaY/hvffumN1ZbGlIojs0T2kBS+8pGCCgUwQlzFN9jVONUX/H054s/EPFaFxYuuVEQVOKHi3W/d1qyElTz2Stwa4WgfHL5iXvFJFfJIkpPPhA7KCBh85fiywVWNyzMuEyRBskp/uApCpxgrBs8BR3/No=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=kX6/8Ybt; arc=fail smtp.client-ip=40.107.93.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="kX6/8Ybt"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=d8vHygSwSJBS4GGElftCbQm7+zfXf/yrXpvJqr5o+OIo8IA6j2ZjNrs7c30amDP2FxfTl594s3iYdADeUBVQvT0TIh8i5MsMmqkERCX7l/9Nu6SDMOAJjV7I/BnWPxi7z7M4wA5zj31ZCado2SroxltbUl8sc07CYxtzA2lW9w8ECzt5RfX8sRTL9QJ5kyLjKnf+qwzVSGPvbvuzjAypl1IEFGUpcJFc2fSTMQQFpo73sj6Ue9CtUpZisfdchSGLp+r7IEr+G2ZuSf5DWJO/CyTcqvomwrHXhQPzAPtTMEvr1QnjUfXa2fOPG/WzzjRuk0Vsk86xX5sZ7luOw0FvIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9qPPZZJ2UBQ842rogNTNRFs1AK2i4MWc6cZYer/+iGk=;
 b=DofnOT78lryyl7Moe3w1M645vRXwZBwY4erY4sg3JB8lJp6nhuYB3YRdi3DGq0mGKj38pR9s/z6VgrhQSwuSqVOaqP2GQ76W0m5zdDCGyiwQKydRyBJm0Lwy9JeFczSKKWVM5ON5ixZUPEIrH8SGE4w2Sa3iKjKdJDqwEvbJitUqpdKnDSainHBqJte+x30vqd0AhHu1Xnuydf6XQ0gzYPyxoM3+JFEtS98bSt5K+kTVW41AIObtSqXTOHjVHa7SG1ue0rsYVwvECKk4jiNp5ODoxGnDabCU0Es6C8urFcLJBKnTDQan74Fdbti9WfkLukZzCF+sJ1vIxAQV7Sr2BQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9qPPZZJ2UBQ842rogNTNRFs1AK2i4MWc6cZYer/+iGk=;
 b=kX6/8YbtqEAYFVLmv4Ir33uHW2jYqQaHBX34Wt8raH0WcQhsdWnBsv/GsmxbnylL9Lophmif+nHQ112Zd1llAlxqjzlXtewlabC0/hYXvKCMJRRBo5J9FAN8Jzb1gQ1Ce0Ngfz7lj5wZMq/TaL6U/kE2T+rDB6DDZmvDmO0DDcbBd/4AgWhhHcJrB7owPXMas2Hdpr+F16TwVyvcqO4p/Z9ktjnWO7rvFTH/1C+jkCKh4Ka4OckIlh4+ARiunw/wem/WkcU+hr5NPKT/yyEg9XKtf51GD96J8eorhZ8pfGo+M8W/oXFsxQNZ1QkYy0SYTqEC28Xk2FiDlKstJ19nHg==
Received: from MW2PR16CA0044.namprd16.prod.outlook.com (2603:10b6:907:1::21)
 by SJ2PR12MB8062.namprd12.prod.outlook.com (2603:10b6:a03:4c8::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.28; Fri, 20 Jun
 2025 12:09:57 +0000
Received: from SJ1PEPF00002312.namprd03.prod.outlook.com
 (2603:10b6:907:1:cafe::d6) by MW2PR16CA0044.outlook.office365.com
 (2603:10b6:907:1::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8835.32 via Frontend Transport; Fri,
 20 Jun 2025 12:09:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 SJ1PEPF00002312.mail.protection.outlook.com (10.167.242.166) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8857.21 via Frontend Transport; Fri, 20 Jun 2025 12:09:57 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 20 Jun
 2025 05:09:52 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Fri, 20 Jun 2025 05:09:48 -0700
Received: from localhost.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Fri, 20 Jun 2025 05:09:47 -0700
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
Subject: [PATCH v8 2/6] KVM: arm64: Update the check to detect device memory
Date: Fri, 20 Jun 2025 12:09:42 +0000
Message-ID: <20250620120946.2991-3-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250620120946.2991-1-ankita@nvidia.com>
References: <20250620120946.2991-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002312:EE_|SJ2PR12MB8062:EE_
X-MS-Office365-Filtering-Correlation-Id: fa87a87d-14be-4902-72ad-08ddaff35fa2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|376014|7416014|36860700013|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?g+HZoScA4YECV8SSfikuyomGoDBULcX7Ytg6FH/8N2kaxkIy4gTj7Mobudka?=
 =?us-ascii?Q?4f7/xKGu0/XD4F8pvSiRqS8H4DMs+0hhCd7f2AfQN8Xe1lEp8uZBKco6tnd5?=
 =?us-ascii?Q?U0M1zJfz4Df0chl9wN1B0jcLqLJhwK7uKaaSFjFruOBfQFu0JLA4GXI81zWC?=
 =?us-ascii?Q?GVUuB9/ONtEdvcd89xCIQw08hEbSg4Oisw+pNcTF+X9SdPYM9fSQEtWnIhvI?=
 =?us-ascii?Q?/wckW60zj/uhtHcIE9NSDJLhfyW1IsTGKdnYhITYtSa2kZub/lbF97zu3NZY?=
 =?us-ascii?Q?bbagtvaP/82ExpxzZ4zX3urigvXZd8UmhyON9NAJXK2y99TIKpcT543Y+5DX?=
 =?us-ascii?Q?z6dKrvSZHJq50vDpH51JtUPxVqIEW1mI2j+aU78ZANGRf0Oq2WDmKjqTfILu?=
 =?us-ascii?Q?qWE28+f4h9YSvBw29LOJTZlDUb8/ExXTn9XxnKE2uhVoBQkP53RmS2twJSY0?=
 =?us-ascii?Q?knLMIRnum8UUCdldnif+JYaL6om7chmnu7HJPkydh3mZ3gimDe4b+peQ6ZgL?=
 =?us-ascii?Q?CaDovdRBFNvNjNB32otd2DHVsXpu7tWS+q4lBrrOwnxOjMEnP2XneUR73UWg?=
 =?us-ascii?Q?CZet6t6Sj4RPTIqTB6VyXzUItir1dNOG87uASoZUon+BqRMqk+w5dZyBlf+J?=
 =?us-ascii?Q?Zh1XjbAhZXe4iJd8somcAwfYPZhQQanH+P804UHU0OFeAP0XkBbxlaKn65OT?=
 =?us-ascii?Q?xjCObIvrvkAjix+16FpmBl4Y44pHuD8YIPZ2r+9Rv7an9ubtFUJ00GEvUiNE?=
 =?us-ascii?Q?MghsXxP9SMOyPbvyeaA1+xTw6+KlTzWn/V4RjbomsFSN2ap+wGo9YCk4lhyE?=
 =?us-ascii?Q?mqZzyKv+9nCLpTjXBLKcmp1NqRYBnr/SxkzT3Wa9FnlNvs+oRuMNb4nH2QrK?=
 =?us-ascii?Q?yIKADMC+B00LqC4ZZkzhDSqE09FnRf6CML7ZKWfJnXJX+oUYNOuRhcjecCVq?=
 =?us-ascii?Q?nfc0DyT4e1AdKOhpEOB6fKEy5x/AkOcz6Lbx8uboHefG3F8aQR4903WvigsR?=
 =?us-ascii?Q?CgtmlV1ocUFyJZz4BqSqj6ppSowoXPx9XOGJjBlLHanhmmvRZ+HEzCU9KQvL?=
 =?us-ascii?Q?PdRGPR5H01s8gZvAxCz3JOiLwiIxWZGJint21k86BBR0NAyuHBJIgOcbn64n?=
 =?us-ascii?Q?2aOXPxTMkoYW22pxzNR+aa0SZGC7fEjVKpcTKbzyUOBDPpa5MSbckAtmHA9V?=
 =?us-ascii?Q?AjV47QpMcLOYzoXk64JQMEObl+WPkyPzJL7msojzcp4kZe5LDFPPpBVaxXh8?=
 =?us-ascii?Q?/IcsVI0/K4/P9763j03nWADurHSQZUs7v5MmwvSTu4+3PwIVkaH41SC/ofOd?=
 =?us-ascii?Q?84pKgv8SgYaYpdkEz8EfuVu6wRyKIMYjWfOMNxbrwd9r/vURKqdckraSyZEi?=
 =?us-ascii?Q?0rjtDJS1VvyBd7BM7/zkoTMEj/UqqepWp+7u4DUt1VbPZaZVZqbCCtQCXNDU?=
 =?us-ascii?Q?IIJYK2ilUxq4M4zVx5876KIqMvN2UdhuujAMTi0MICbUJrFU/xXzQyzMWFmJ?=
 =?us-ascii?Q?7hljFIgBw3DY245gzlkJmW7QmVuuy0Wsckp2dPqhWK5yPVhr3jlDovF1og?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(376014)(7416014)(36860700013)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2025 12:09:57.2699
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fa87a87d-14be-4902-72ad-08ddaff35fa2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002312.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8062

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

