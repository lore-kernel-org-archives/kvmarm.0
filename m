Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2041.outbound.protection.outlook.com [40.107.94.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D0971FECA1
	for <kvmarm@lists.linux.dev>; Sat,  5 Jul 2025 07:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751699858; cv=fail; b=YOzkP6Y0Xr4wu888m+R/IFB8Q6dgjL0+oZgwAm0ceDGl6BP2jfaiB5ZGAY4mRnEBgH9l9mLms0huuh2cV7sevlQBkiEGFBCN5d4s2LXyTEGnSRooqf8hmpqIYDSuxloTpu1BEa5u6JSj7LNjaKKwHLdS9wg1v/cXfzUuJmCph1E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751699858; c=relaxed/simple;
	bh=vqdRqK2v8g9Wqwe80KHYkdnepr2zUBwTsdVKu1Iyb8o=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gj505CLi1qi43oAcvj/CRsN6Ad8KFTLrWX29xfruHKuUuYvZTQ0bZ4lI5b0N0R5Z5fMTZ6PUIBeJ+dP58SHGQG5KPyGpuBifXU5X1h93uhEoIIbmf9KFp6kQhWUu+F6NwB+2zoueHGsfVsFJySp9WgSgbR8LWceEfohHpK1+kPQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=gXx6CGCK; arc=fail smtp.client-ip=40.107.94.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="gXx6CGCK"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ccO82VbCKpMqbiPEK05jr4pMoadJFXMmFH+sKcP6ocCE+SCGaFGTQXqIuVNnQuDEfZEPV6udyev6TvHEmYJsLgTToEkmCbluqxiFe1T6Xbkt90XlmwbWWC7w0tec04oZxTjchTNjMKGMwDzgQuXnKvVIvG+tmF6tJrPV7uh9qhr066LSv2EJeyk1DLyMIN7nJEnh+XXQYZD9pVk90SCjEp9G1nFFPjBagr4docZIAgxEk/4d+BA2J3Hp4GkC9vLrnyFEPde7KEdTP7CgD5Jx+e73xIbDBS0CP4DZyj3pe5G6yKlaj8Is8x+Ux+N3cumNIIoQ8EpH5fUhdsgrUyrBJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Bpm0bXsRM9yInaQMDqYb4M1DHhKTk0ZdmS+96+3Jjcc=;
 b=KsqFhtyPPm8e13PgbiY23mamNdakxjkChrSdmD5uRn4oujXsIAnNNK94/nKHH3EkVQC+O0QAZgquKFXMDDcg6nvhmBfQ0fZSi5R77c2964WhTyzMG1Wt6xkqmEHRpEQCsvLkiQR82QLgml0krhvVz4El1quqvmrG5zRUA31Pf2fOeRiSGDUGI7pv9zWhC31MxiElQX5C91eJ8R4O3/apodUK/C/LYnTd5feraua4Xja3i6gxhBDKaV84KZhMyEcyfdY1SWknlVD0gRz0nh78AD2zglZIPsZ1zIjbYRrT6b3f9Jg8PETtYocZm77olVcwWz43Wq0MAU72a6WNKP8T7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bpm0bXsRM9yInaQMDqYb4M1DHhKTk0ZdmS+96+3Jjcc=;
 b=gXx6CGCKhZPOrpnDyDtr9NWcKnZrq80mpsCH4hD+ciIv7QM6a5TFgJ31LiDLow5FM3opPTozdnPZcOIQQQv3+pwXCTaMilK9hQc98EBxOjNhcW7h+/f7spDBM4woee2lqs6DJsfG/Ybn6U2Zh90cnxkcMrhdhjPiZyBcEAcqZVHFCejlG9eJQneWiI7oqiFiUV1zQ78BWAUkT9cHssL4GAdZcL2IjUx5fcU7WvsYP5KBQnlVppk6PTgTVOKD8EkPSIPR1bwOu1hWFAjzB6BMiJUKsQTAg6edcZdt5v2ndje6iFMCBbz+c678ipLZyC1NK5XvvCnrYPeGTIiC74ZWAg==
Received: from SN1PR12CA0056.namprd12.prod.outlook.com (2603:10b6:802:20::27)
 by DS5PPFD22966BE3.namprd12.prod.outlook.com (2603:10b6:f:fc00::662) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.28; Sat, 5 Jul
 2025 07:17:29 +0000
Received: from SA2PEPF00001505.namprd04.prod.outlook.com
 (2603:10b6:802:20:cafe::39) by SN1PR12CA0056.outlook.office365.com
 (2603:10b6:802:20::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8901.23 via Frontend Transport; Sat,
 5 Jul 2025 07:17:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SA2PEPF00001505.mail.protection.outlook.com (10.167.242.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8901.15 via Frontend Transport; Sat, 5 Jul 2025 07:17:29 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Sat, 5 Jul 2025
 00:17:21 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Sat, 5 Jul
 2025 00:17:20 -0700
Received: from localhost.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Sat, 5 Jul 2025 00:17:19 -0700
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
Subject: [PATCH v10 1/6] KVM: arm64: Rename the device variable to s2_force_noncacheable
Date: Sat, 5 Jul 2025 07:17:12 +0000
Message-ID: <20250705071717.5062-2-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SA2PEPF00001505:EE_|DS5PPFD22966BE3:EE_
X-MS-Office365-Filtering-Correlation-Id: 97f8a7fe-d668-4354-2e2b-08ddbb940053
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|82310400026|36860700013|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?T/EBLtb42Jcz1rEBuSNKBHqPpg4u6adNAnA36kzit6Yd6sd/QWenycMswQD3?=
 =?us-ascii?Q?riIlSkOCuXFOrivi3tKrkSXw/E0v0HaNLwbs6dk/vuOUuqBX0CtYFB0cW+QY?=
 =?us-ascii?Q?+yAuauHj3gmo2QHQOCP7Puy+S+VTZCTZHZrMJS7sNiF+a6N+AFA9euMNN1qe?=
 =?us-ascii?Q?Wbdwn3dYsgLpLqwgthoiUSZUgPWOm++CKofCze0sC3fWIbVs7Uv5TQ5FFvTs?=
 =?us-ascii?Q?vjEN7bGDrNGBesRfRlnJb0I+zM6s5zPmvEcVngFoKfWFtLYo+PTvD48D2zz1?=
 =?us-ascii?Q?AADUVbxV94VSyU9vkUDd8v+yExD8vHdxkIkrXs+5owMz+jTFHKWt+jxoeHdB?=
 =?us-ascii?Q?uHdLdZQ7lxV9MI2VApr4tk2UoyKvYbKy+D/arvYaE1lW0N40J9IStE2c4U6F?=
 =?us-ascii?Q?4rSzIllE+adDScMPOx4r4g0AgTbSaHjWFh6zju0bq4oSVVnEDqdm1N05ogn3?=
 =?us-ascii?Q?VduDEz7pa3CXpWAvaexVBwvFdaePX/GVrNuzzQwwok0PA1JiCHwXLSUyT2mE?=
 =?us-ascii?Q?mqkGMrwdkGNiRBquESjkr7YkRmTK9ft44QSEhg0JGkdHmByCucNpA0SQwSOW?=
 =?us-ascii?Q?jLwtqJ9WxomageR7mpavGOe+dQFZOC7w/7oPnyx1ZKo6wqC1G/efNM0+mxYU?=
 =?us-ascii?Q?cVyg10aIu/95Jm875b2Q0rZzZd1dqAcTZiM4PBTNmbohRCDWNbaOjM+5+iB/?=
 =?us-ascii?Q?3RrMU6QD6wELmW0SqarHjKakiorcHVd3T0cQC6/lB5nrf5Vx2Brk2XGtgxlS?=
 =?us-ascii?Q?wl7QINYoSaGCbXSSxeodu2dZtdGvqI8fN7BRAlQFmGKYAJGvektOq9y/272c?=
 =?us-ascii?Q?jNCRbxyDs3zD1rmCxqdBe7nh7JapD53bzoVkWqvH2pbtDWi/h+FeOTmkMDDG?=
 =?us-ascii?Q?4JA0L6fXSayXCcsYcMwfRyDE0YsNArVJEULLNrqcbiRMt2uMOJbK7L4NT+K0?=
 =?us-ascii?Q?h9Uoh3tgzqtYtJUpCej1G7J4msj9ZcBx2iXzz+S6Rv1IMBdsw6XK2W6wd12H?=
 =?us-ascii?Q?tu8E8EzjXMVzl+Ups0VP655S5V2KWmmnm6Z4MHnc8H4kKjxjyWqLYEMPl6mA?=
 =?us-ascii?Q?CNSSmWj7MaftXAt9wMK43Gc5Dt2CmBlyuj46e4780qKTIm74tDVZw9GlHVg6?=
 =?us-ascii?Q?YTQXUtbQfPtIUsl6rnWfpfSgRM3IyDmgZyevDim1UtDJeuMMkQa2t9eT9atF?=
 =?us-ascii?Q?0Yay95nHepsMtxjyIERBpIYbrNjTo7aQIs4j6uHEymP6xCZSLmuHPzaa64Dp?=
 =?us-ascii?Q?oJo7l5N8E+2XiB3709vpL54JKOIZetDnq+8SGYdKHPhEQ+sqSQLJJIRV46/p?=
 =?us-ascii?Q?ji4qOR/vyXiJGrFYRVdromqdX274S3GLTmW/uOqAef9ByU9DrK4q7lHRdnqq?=
 =?us-ascii?Q?0d2OKSmKG14YsIc1AQn3ohAwgB6qEtUl1zQliHQEQu9dTmqDbNDnl1T2yksE?=
 =?us-ascii?Q?hpDjoiyHMyw/E3HCGXiEKv1Er+u0+djlR2x8e1pZ2xeej78x1g4EcbEWvKzM?=
 =?us-ascii?Q?USVVSn7Z6o2aqQMp8vdUJ8jukMIlRKkfYok/D29IcB3SdmZ0zqztTZvycw?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(82310400026)(36860700013)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jul 2025 07:17:29.0833
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 97f8a7fe-d668-4354-2e2b-08ddbb940053
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00001505.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS5PPFD22966BE3

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
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Tested-by: Donald Dutile <ddutile@redhat.com>
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

