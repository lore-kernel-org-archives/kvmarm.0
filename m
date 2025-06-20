Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2071.outbound.protection.outlook.com [40.107.102.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C201028A40D
	for <kvmarm@lists.linux.dev>; Fri, 20 Jun 2025 12:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750421397; cv=fail; b=fsH3LddSmik8mLnNaV4hK+xM2cev2eMlaOlYkzbbB9HUD5vI9BHI01xASdRJXsuvGBDY9cBLhJxg9bZ8YyD7RbMnnSCPzqNRTKE89Qf5fNmU1J4ufHhATjghkcC8aAc/mnU9+N22T7egvhwUWs/vyJXWGIUF4suLw9FOcy8RqUs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750421397; c=relaxed/simple;
	bh=dysODe5K/JGNI1C99eWlAizNObXue0iQlOqwbJoo9H4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QL5LLRlUhukLilM3/p8MLqsb2UwaOhvtbIpSm+9VcqckJeS4mdiYRMKOJsazcpaY4MKkK+ceqB0/U5ReCWy/Q47PO3qGuBqKlg3OuJmY3cJbMdYSCu9SS5yYaeGDvp4HQhz2zCUCo821k1+bKu+VKCmwg/fD50fqjMJrvn8aRwc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Z1HA8sfA; arc=fail smtp.client-ip=40.107.102.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Z1HA8sfA"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vmjFzdM67Bc5vUCUlwevjvO1euMdbbSHTxXoU3tMjUg8zjpLlYTjGYPCwcRuo0V0M2zF5ED7cYhWvLTdqxOYUr+HRNFGRoSE4xRmv6/v+8MuHSSrCrlexqxlOHBaVr58fxgn/YgKapF0jUkYbzaL00AOAVj1zKYm4KlG00AmPf2JD21zbfq/2yA+dEcJPWmAGBxjRktxdYl5Y6XVH8udk6I17pUrN6mGsr60S7zWNDGdkxiNRbjP69SBE42gXABq30TGV3EbYQ4D89Gx3H+a+76zwVKVrh+eOVMY9pxgk9FESp8ZodxIaRTfCGA6WhjHu2ZcArE/k9vtlSu8IoMMqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YhbLla8v0WDPidQ8Xb23ycVc5S2jFjFD3o4RNS8/GHA=;
 b=J73IpBC0BcZodJH0KQ4jqty8dwCrSXE4yGIeWOOcpW31O991c7eqM80kws8DDqZfqpYJYn7O5WbRLVySddj5c1lbFvvHj1ph0fjy7QbT+/z5d3TN7DzAWlZjAJoMIwPzRVq3EZtW3BrJnxxReiquIPw2LNgJ7bOloXfgndOzxKRRDvFVcqFZLdMF2k2fg9YwgJb2CvLOPROMMiSYHB+haf4emIitmXRZv/GPmjRI5lRW0PB+4I2HpWnbYVCBzr039h+HcWp0ZOiNf0XyS8Satq70oy+dqLJFpb5DkN1YCpa2ODMH+hlpKWgs0+MR2Fqo7IndgQ/mggwPUy3c3zE7ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YhbLla8v0WDPidQ8Xb23ycVc5S2jFjFD3o4RNS8/GHA=;
 b=Z1HA8sfAsIqmRGnHMcJgJTQAYebFrgpqMHJ+JePN704mF7TuuKyr13C2BbANQwLYCz+k/xGyiAQVaUfF6MeQ8ehEMlKN/2G2Z1iV5s0e7Luk8V6kpawdz9/S8Sn5D20n3o2N/VpOyjuBnJQDs8Ks4vsffgoeb4aeyWEHDQfGaCCkfHDNUC8t7QpregczLDu9NSCZ7SjD18qzVJ2ixxMjD/d8YE7OVNeUYj9h88PJm/Waw+s6sKKUqRVpLJBW5+JG6JmBmbaRvtBTg1Vtj9FaU+iQDnq2XQJ4oZymX38KZx6A1LD6NR1kUXpCSNJ4dC+TDgqt+DEd11cIblI2CFn43Q==
Received: from MW2PR16CA0049.namprd16.prod.outlook.com (2603:10b6:907:1::26)
 by SA3PR12MB7832.namprd12.prod.outlook.com (2603:10b6:806:31f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.29; Fri, 20 Jun
 2025 12:09:49 +0000
Received: from SJ1PEPF00002312.namprd03.prod.outlook.com
 (2603:10b6:907:1:cafe::2d) by MW2PR16CA0049.outlook.office365.com
 (2603:10b6:907:1::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8835.23 via Frontend Transport; Fri,
 20 Jun 2025 12:09:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 SJ1PEPF00002312.mail.protection.outlook.com (10.167.242.166) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8857.21 via Frontend Transport; Fri, 20 Jun 2025 12:09:48 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 20 Jun
 2025 05:09:48 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Fri, 20 Jun 2025 05:09:47 -0700
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
Subject: [PATCH v8 1/6] KVM: arm64: Rename the device variable to s2_force_noncacheable
Date: Fri, 20 Jun 2025 12:09:41 +0000
Message-ID: <20250620120946.2991-2-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002312:EE_|SA3PR12MB7832:EE_
X-MS-Office365-Filtering-Correlation-Id: 242ab295-6288-4d48-9983-08ddaff35a51
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|376014|7416014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Jf5/QD6e4+m8iSx9IYWK4ipfGu1SopdfDOqgC+DTyqfopDq7LgQUn5pHiWzU?=
 =?us-ascii?Q?0li9biaTSUeQBS7HB5+2ux5JgBUFYNcYjvaEHqGRsmAo4obgYFxJBaHJNw3C?=
 =?us-ascii?Q?P8sm9ZEEP7STlj6wpOKHnSLjsaZK2syY+DrsuEjsIEjXM/w0Z/c7+PtITmfu?=
 =?us-ascii?Q?4cEOWOXiaqUBDneK1Vvr3uYaS3IhCecu/S0PD+bWpoayMQyWBpjfcOrbCsQc?=
 =?us-ascii?Q?HOU14nDKbiCan7hjfzoyRpmkqwD1k17p1w522LMp3+z8XCxvwPe5j4piR0b4?=
 =?us-ascii?Q?Hn6bSBdspxXCMSMQDxyDCYmQya0X93hJtcJFMEebFCVpC1S35JeNUffKBgEr?=
 =?us-ascii?Q?YbTUJe9NSSKtVatexjjPksp7xrCzXM1ijnsJQ/UeCMts5kqRqUNjqlDYFEui?=
 =?us-ascii?Q?q/YazhwBzhwXBdi4naUVdDGT9pYKV8OXQKS9ErcAB9Lnutz+kZXaMt4ggFod?=
 =?us-ascii?Q?CwS9VwFsV39QbXn8yTSeYbIZVsJpNE7FI/9XX3SLxtWGk7N9TzPCfRLIDEi4?=
 =?us-ascii?Q?ZVAxZnjvBmERr+iN4IyP2EmcmApMdbEHSXEjcKAPpvLq3dWBv//BRdeXOft9?=
 =?us-ascii?Q?vTBDO8eUE9794RibsjqczEHI7j/YDPsQVwFL21kn9Of8JrNlyNiM6norxvwm?=
 =?us-ascii?Q?XiOj1/87B4M3xvsTjJPDRnykmPSawXb9Vr47ZIXuIn57rBMwQnWMGIpgipFa?=
 =?us-ascii?Q?ziKZglAgo+XsDhnL0FiD8E75ULntF+hfMKKhCGMFF1S+tcptHv9mdZOPoyBE?=
 =?us-ascii?Q?qzzGJ6INWUNU+1Swmyr3mSkosT/GScnENu284jyJLwJ8FiC7Jey1LkWEd2O1?=
 =?us-ascii?Q?kHg2hjO675GwrMVULWMINFye1wgaYtW4Hdhdf4fnpDYEBZZJPdM1rGxcrWna?=
 =?us-ascii?Q?rdgZszKh4JqVRHh7qJaI4oBZkyotENms7/9t4gEIQ43IPU1PFwjSgI+3rEb3?=
 =?us-ascii?Q?ry2KoPYC/ekfKkSYJtTOJva7sWy4hKYOa987djZ5DAe8WIu2zg8AZwpkvLeU?=
 =?us-ascii?Q?M2U72STy5b9SKZkeLgfmlnh6BToziwIgKMRKEwMLQgmpJlJBfroBSozu5jqW?=
 =?us-ascii?Q?fLAJJNuyrx3E2fgbmlGRBMMH8oa7Xqr5F49+7B/VyAj5VD0PZTa2h0xRCov8?=
 =?us-ascii?Q?OglzJVNLgrTeTRgIeoqYSX1kZyPKNAuMdAs8xzikLGvrXhyDs67P44pvhsaT?=
 =?us-ascii?Q?n+DABsN0dMWtndwmUIXHAQ9Jj8hzfTv5xCpYYuarLAq3QxQJr6M78mM00vtz?=
 =?us-ascii?Q?6bgvxcBruc5G2rPaWksse572yKseO2F0/dmScKjPjMYq5Uf1VJHuaTErA0ds?=
 =?us-ascii?Q?LtE4O+OLjP0XVYlwOX+OM8jRHcS6osOBoGM/EB9AD4JChOEsZtz6SYsxZ8eq?=
 =?us-ascii?Q?EoyKzbOkf/fricT+ZdIYaPejg2ApA/5LbAiNRPwJkPzwB7B49NkU+zymytTh?=
 =?us-ascii?Q?+E2hwXQs5dr14t8lSDlqmg+/VlJtkyZYZJYYrYiqMOIqs378RdM4wtKGzi0b?=
 =?us-ascii?Q?WUngLVQU8q/pyzFkFGSva2tuH4H+8TYoO8KkJl7TwOYkHBcQf/HRltWm3Q?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(376014)(7416014)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2025 12:09:48.3512
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 242ab295-6288-4d48-9983-08ddaff35a51
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002312.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7832

From: Ankit Agrawal <ankita@nvidia.com>

For cache maintenance on a region, ARM KVM relies on that
region to be mapped to the Kernal virtual address as CMOs
operate on VA.

Currently the device variable is effectively trying to setup
the S2 mapping as non cacheable for memory regions that are
not mapped in the Kernel VA. This could be either device or
Normal_NC depending on the VM_ALLOW_ANY_UNCACHED flag in the
VMA.

Thus "device" could be better renamed to s2_force_noncacheable
which implies that it is ensuring that region be mapped as
non-cacheable.

CC: Catalin Marinas <catalin.marinas@arm.com>
Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 arch/arm64/kvm/mmu.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 2942ec92c5a4..1601ab9527d4 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1478,7 +1478,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	int ret = 0;
 	bool write_fault, writable, force_pte = false;
 	bool exec_fault, mte_allowed;
-	bool device = false, vfio_allow_any_uc = false;
+	bool s2_force_noncacheable = false, vfio_allow_any_uc = false;
 	unsigned long mmu_seq;
 	phys_addr_t ipa = fault_ipa;
 	struct kvm *kvm = vcpu->kvm;
@@ -1653,7 +1653,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		 * In both cases, we don't let transparent_hugepage_adjust()
 		 * change things at the last minute.
 		 */
-		device = true;
+		s2_force_noncacheable = true;
 	} else if (logging_active && !write_fault) {
 		/*
 		 * Only actually map the page as writable if this was a write
@@ -1662,7 +1662,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		writable = false;
 	}
 
-	if (exec_fault && device)
+	if (exec_fault && s2_force_noncacheable)
 		return -ENOEXEC;
 
 	/*
@@ -1695,7 +1695,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	 * If we are not forced to use page mapping, check if we are
 	 * backed by a THP and thus use block mapping if possible.
 	 */
-	if (vma_pagesize == PAGE_SIZE && !(force_pte || device)) {
+	if (vma_pagesize == PAGE_SIZE && !(force_pte || s2_force_noncacheable)) {
 		if (fault_is_perm && fault_granule > PAGE_SIZE)
 			vma_pagesize = fault_granule;
 		else
@@ -1709,7 +1709,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		}
 	}
 
-	if (!fault_is_perm && !device && kvm_has_mte(kvm)) {
+	if (!fault_is_perm && !s2_force_noncacheable && kvm_has_mte(kvm)) {
 		/* Check the VMM hasn't introduced a new disallowed VMA */
 		if (mte_allowed) {
 			sanitise_mte_tags(kvm, pfn, vma_pagesize);
@@ -1725,7 +1725,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	if (exec_fault)
 		prot |= KVM_PGTABLE_PROT_X;
 
-	if (device) {
+	if (s2_force_noncacheable) {
 		if (vfio_allow_any_uc)
 			prot |= KVM_PGTABLE_PROT_NORMAL_NC;
 		else
-- 
2.34.1

