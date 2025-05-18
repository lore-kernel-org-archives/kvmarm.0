Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2044.outbound.protection.outlook.com [40.107.93.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EF851E0DBA
	for <kvmarm@lists.linux.dev>; Sun, 18 May 2025 05:48:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747547298; cv=fail; b=YNFxWSRGMvpz0XIyR3Q0uQcsQImLLsW+Ys+eoKpXmSoq7XrMshJFp1JPWaMajIazsaAnNE44QedFobzQ6czwA23S5H9oh3ODWgcZ4Wa26DKTJ1NfADKpBDp4K3+2dqPnGgu4EqgVYqhZaSYwtV4arbjL1x6qnpelPFJG0mqwaQ0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747547298; c=relaxed/simple;
	bh=RURD/fN0Ndbv2kiREiRjjiVKJJgme9IcbOtu8QUSY/U=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r7L0mPFZgNr6y40Fevf3cxN3k6R9TJdfn1EmIM7qjZxRdSEgdneJeTxaChhYJqCPeY6NVFFxLTXSgQHtRa3eM/JLi2MTz300Dud6VmAxyNkOj5cDtwopUze9r5KPUkHTopJkFTwx1BDcSWHMQ7/yfqKzBjyfMKdDiZHkrUblzVU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=EA2R4/kD; arc=fail smtp.client-ip=40.107.93.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="EA2R4/kD"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hiLQRCnxQvjGUprjDYqk8w/8A7B27XRnQG06biajodsc1eN/URNIvJSoBohbXFVbtqcS3HWT7aijLLxUW9avxGG/UIVcVzefpn1pJHyxzJ+eDOmwrUAy2CLdpEwqV/fUdo/XaJjQBguMSUKCgRE67oKgFm7aadVIdce6Go0a4b7q+ra+yAHcvLwmt5+ho9Y57YRlBtBlTA/xjgiLjS+2xSFuQHQUSEHSD7Ch6KD3Z7CvrUQ/fam4NDd0ZyNsXoF1wwb5RApeXT39pLfi+62l5B6xtkVCnSpqCk8nAdrTo4pD0TgPhuMV/Xzv0RTtqJnpAVJPSO9eKKd7Nr73eFJ08w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VOZ0tmoyNmJEAK6a3622Y44zwFr4qbGROQhZjh6zjCY=;
 b=HhmlQY4jYNYFG1JEnN6MDuIwTaul9jy4AoFpIFqsPuA1Tv8R18rtkXqha6IC/E3SjZhC15v59ejLQ6PFCJjYbTTvYHESI4f298gvfz1F3mnRJ08cTK2AJ3xBlUCGR9u6WyE8cERokbDZB+YMe1ihuCECKtQY4Y6Zq/gL5Nbbw1c7wLwdzHujfkGwSh1NoT0JvKBOd/GDCoyiNvhYlQCkDxYVXP5trcKj30To/IWwlPjUjkDYtKMJDaQqq7uNwgPcfv/F62AhjzzrCBTdKX8GrQbXfYyutH+Hq3zf0i7LkRTYBoBRGhl3/eURM1td7z9N3089/DbQDYI5CmFV78934A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VOZ0tmoyNmJEAK6a3622Y44zwFr4qbGROQhZjh6zjCY=;
 b=EA2R4/kDTNicSsgSJJCM+TSxDKO0BiUAH/R5p0mpjOeM+DH79BMg2KchqeUl/5HrR11GKobR1VY1rgmg7wYExTYTFCaXGvYoUDtkRoOfO75dxwbz0Y4scATm08aFunFnJLM9dwO0yMW8Z1m3ZeXrN8YW7pEyZ1i2uJAwJgu6ViLZzPWp/lGROjJVR7yfCg7aq1j0r25Gdmrl9dyatSIBRuHSLEGGvvN9JesGU/228hVqiWO0aF/klraDYaozSHCiF2vlIzofQ+2zl2kYoDvZxZO+IT9OBrk1T3yjtp6lYzV4JQZswkfjnjj6a/7C36jpyzhnnzAy5+dz08bwb853yA==
Received: from DS7PR06CA0030.namprd06.prod.outlook.com (2603:10b6:8:54::22) by
 MW3PR12MB4361.namprd12.prod.outlook.com (2603:10b6:303:5a::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8746.29; Sun, 18 May 2025 05:48:08 +0000
Received: from DS3PEPF0000C37A.namprd04.prod.outlook.com
 (2603:10b6:8:54:cafe::f9) by DS7PR06CA0030.outlook.office365.com
 (2603:10b6:8:54::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8746.29 via Frontend Transport; Sun,
 18 May 2025 05:48:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DS3PEPF0000C37A.mail.protection.outlook.com (10.167.23.4) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8746.27 via Frontend Transport; Sun, 18 May 2025 05:48:08 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Sat, 17 May
 2025 22:48:01 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Sat, 17 May
 2025 22:48:01 -0700
Received: from localhost.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Sat, 17 May 2025 22:47:59 -0700
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
Subject: [PATCH v4 3/5] kvm: arm64: New memslot flag to indicate cacheable mapping
Date: Sun, 18 May 2025 05:47:52 +0000
Message-ID: <20250518054754.5345-4-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250518054754.5345-1-ankita@nvidia.com>
References: <20250518054754.5345-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF0000C37A:EE_|MW3PR12MB4361:EE_
X-MS-Office365-Filtering-Correlation-Id: 3369aa85-7d0e-48e4-a5ed-08dd95cf9140
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|1800799024|376014|7416014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?lGCmwwj7sztHV3QkjtA57oto20ivQiD9BgSeTEavbSxZCJT9YQ7Pq7UYoNg5?=
 =?us-ascii?Q?jX/WXDR8lWbPv6KFha4NQzymBS0VctVm0EXAHhOM/2QNkL9yhbdTxFUAsK31?=
 =?us-ascii?Q?y5GjWuAH9+43kgw46ddrBykAzqAqiYBzWwVhwgGkb+4obmb+o4Z/leWC1UW5?=
 =?us-ascii?Q?bp7ofi+NLlzhhJ1zU0wruYJ5YtM1AJ/p5q9BOYxq90fsxF34l6HracSjrhsP?=
 =?us-ascii?Q?R2i8HTdOU8eB4qg0zSXz3Mzm68Q9RYHmgzVRDcoM+4SEsv/JFUZnkkj81mHe?=
 =?us-ascii?Q?NmreAlAzcrnzsYa3t3L/N5Si2QTIe9jTIMLdiu4Atz05xyyhwwG+dSzVWZ0f?=
 =?us-ascii?Q?fca/5KyrklrOXjBj90Wysw1JIdvRqJVIZwWtX2NVguTXXBe0r6pZYt9Yml5P?=
 =?us-ascii?Q?I5lwFprHSl1x7Mrwy728l7RihvaiWQpYPK5tjyLLiESBKpkgbOK3qXAAyQCg?=
 =?us-ascii?Q?wRoIuwHa71TL2wVMRdArD44vq+W6siBUtowq64aB/ezJtf0JdcTdNRgYIcBe?=
 =?us-ascii?Q?Rq4u7q+bZ1rJC2fWLdnNaKgoLS6gA5D6xnwHHU/z7AyiTbvXWu/KYAQcvgrw?=
 =?us-ascii?Q?7pbTURlmg1QWky7vcbkGf2rtkdS48tzH2G9ZGtmI+1OxF8PNbBiJrBCjIbo+?=
 =?us-ascii?Q?Is/pnRC1u5bybI1BksH21cJ2LjABQ8kaMIAaZzpIBvE7tL6ZiMGVlGrVVo27?=
 =?us-ascii?Q?lH6P6R25XRRL+dc6lPZJm/V/r4EzBzgMFsWbUUzyxSiktzY0hV0Oj7+qAXLn?=
 =?us-ascii?Q?A8n4XtqfR3mjhZBL2PuVJUIZWfNFPKkS8ZPKmls/UCH/hqJrLNrsuDOhG/Q5?=
 =?us-ascii?Q?IgWZg/lxXE56PXtkIrEi+LBS1CA1SIHXxhlleEIKqG6MLCP9ev8L/BOChrsm?=
 =?us-ascii?Q?4FR2bv2qeFm8TcOFyrSa2p3VddP101Zpru0jqOB68Usrds0oSMd2P7LixXbJ?=
 =?us-ascii?Q?5Z47mvK7KjyvsRmcl0/kIp7jvPFnmeTrbnBcw0FHZ/a+n4l4g0+aHff9ao2w?=
 =?us-ascii?Q?MpXCQQMtPMlW+fUjfTeNHiJEUPWG/RLbi7JmYe6WRonjXXP7WUXUsz4Ic0+m?=
 =?us-ascii?Q?6d4ZRpUBgGWNylXFMxtIVGpmGwwiN/dM6rr09JAVPXiCaHrR9qSXhKUao1BW?=
 =?us-ascii?Q?CTx3Fo9lPcK6aYu2ul++Tj6DUTgRKvHkdJBb4c/yGwL/wAwAe7GUnt7MxZAV?=
 =?us-ascii?Q?yLqxg10pAGemRiRTsrzTfB2YZguC2+ammg8xlxddH7UfTDJAJ7ebwHMOt2VP?=
 =?us-ascii?Q?PlaQhqR9eg5mm8YobaVdxfGPWjjFx5k0HHeQGKiMbw68qrohRGsTU13sq8Rl?=
 =?us-ascii?Q?YW6bQGN4uF9CnqpDCV1NncQdEWF6LmnA9dYRLdrdrJc/CD2rLMGjGZC6sMM8?=
 =?us-ascii?Q?B9EbMRmltX6Jgd5xSsLNBwIPnzHaH5L4huQLOh/a6KXK4mrKrSA7g0djtyMZ?=
 =?us-ascii?Q?RDFGh2Yuu9PrxekaBZe7bCtMgTi9srCrJcxbQy1IYGLic1Im5br/dAG1j+2F?=
 =?us-ascii?Q?43U9Kym15MSoiURyWF0/Aisv6PyjuMPELpKbxOQLOjedGY2xOx9C0X6arw?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(1800799024)(376014)(7416014)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2025 05:48:08.3008
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3369aa85-7d0e-48e4-a5ed-08dd95cf9140
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF0000C37A.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4361

From: Ankit Agrawal <ankita@nvidia.com>

Introduce a new memslot flag KVM_MEM_ENABLE_CACHEABLE_PFNMAP
as a tool for userspace to indicate that it expects a particular
PFN range to be mapped cacheable.

This will serve as a guide for the KVM to activate the code that
allows cacheable PFNMAP.

CC: Oliver Upton <oliver.upton@linux.dev>
CC: Catalin Marinas <catalin.marinas@arm.com>
CC: Jason Gunthorpe <jgg@nvidia.com>
Suggested-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 include/uapi/linux/kvm.h | 1 +
 virt/kvm/kvm_main.c      | 6 ++++--
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index b6ae8ad8934b..9defefe7bdf0 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -51,6 +51,7 @@ struct kvm_userspace_memory_region2 {
 #define KVM_MEM_LOG_DIRTY_PAGES	(1UL << 0)
 #define KVM_MEM_READONLY	(1UL << 1)
 #define KVM_MEM_GUEST_MEMFD	(1UL << 2)
+#define KVM_MEM_ENABLE_CACHEABLE_PFNMAP	(1UL << 3)
 
 /* for KVM_IRQ_LINE */
 struct kvm_irq_level {
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index e85b33a92624..a3e77fe57cc4 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1524,12 +1524,14 @@ static void kvm_replace_memslot(struct kvm *kvm,
  * only allows these.
  */
 #define KVM_SET_USER_MEMORY_REGION_V1_FLAGS \
-	(KVM_MEM_LOG_DIRTY_PAGES | KVM_MEM_READONLY)
+	(KVM_MEM_LOG_DIRTY_PAGES | KVM_MEM_READONLY | \
+	 KVM_MEM_ENABLE_CACHEABLE_PFNMAP)
 
 static int check_memory_region_flags(struct kvm *kvm,
 				     const struct kvm_userspace_memory_region2 *mem)
 {
-	u32 valid_flags = KVM_MEM_LOG_DIRTY_PAGES;
+	u32 valid_flags = KVM_MEM_LOG_DIRTY_PAGES |
+			  KVM_MEM_ENABLE_CACHEABLE_PFNMAP;
 
 	if (kvm_arch_has_private_mem(kvm))
 		valid_flags |= KVM_MEM_GUEST_MEMFD;
-- 
2.34.1

