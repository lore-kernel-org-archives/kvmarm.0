Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2040.outbound.protection.outlook.com [40.107.102.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 540531DE3BB
	for <kvmarm@lists.linux.dev>; Sun, 18 May 2025 05:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747547295; cv=fail; b=RjkOtfG/XdRtmSkPTX7iIUvxV3hOsjGK7paW3zHrQXIPWea21OHvy8TFSfCAObjuEebzil43hElF7JJOexQEQJJzyubaTUJ3KLVb1AKqAWijzV39wNKPYYQcB3utagpQtXEDF+RUvO+mc9UB6+g9g9bprKsdtYpx9LB81THF30g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747547295; c=relaxed/simple;
	bh=eck8TYBgXxtqvDYp/HK77+ACRs39H2LP/t4Fp6IfpLQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nKtYwhapK3CbTWIB3um2zlWxIItqBUCxoTt5WUUIcUEdkaRfpMthHdqLCDVBJCQKNhDPvqmdvP7OzQkjy/ld/IzB1S9E4i7sNQFG0Z97Qa/lx1vXcrOpJ4+nTh3snuKzP6HgsPygQPqERen0A0sA/sto5WqH8jzVg1RoChcLqTE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=GAGyKGPQ; arc=fail smtp.client-ip=40.107.102.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="GAGyKGPQ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=E4eBxXtRhP3f5NmjRlYutAKq8JzsuTnwwRHFeGwUpFAEsYNWiFcOsgPv5cloz5ZlKguU8iK4MuIlcNaP3ErjBKfRxuvdQgK7JVNoLzWKk8MVrIB4xWpRlxxJ67aZn6eLryl3tnWfrmQbLd6/PuZfXAze1bTr0SyDwQjT9QjN8DmWktrEPN5P03EnaZSH5/25EiuXWNJBiexJL7v409MOOVw/HM+QAG0OWZ70QlhlecWo8AyfDffUTFQ/5zvc5kCfu/B+RYU/fnHPTeCrDmfMoOd/RaNOgn/rhuQtn0DTo5JfyRe6Ht/rR9nG0F9gaNOIv2N3Ai7evieAq2KmpvUg6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vRCnKzpRKiO/o4hmU5BKF4SePPAAHaKbgiItko2+brc=;
 b=e2p03vN7EJ5QsYPAeJSE1azb3ZJX/E0T6loMufN6vsyBShJfOEJSNQkPVN0nyf0VqPdiyysYgPmPRSnNpXZjpSbKd2tMnNY7aEjfusTCVlf7M6tFRJ70uToX5LfPSGVlk67z+Sxuiqlxs2TCJ9HjfPlQC9ru5Q47coCQW3ZQ/3uWkS8XRrAk9NuljWJJZPenYVQmKmxzyv/PseYMORl8F3QJRbuepR6Bf4ZF73A0jFuLLW6FSbtsLr5VIIoxNeHnybrL8aSZy+Nm8rVTegGOqZN4DevXJpg1gbOXjjQrqoi5HK0oIhvbPy+SLBstEH9jMZb8sHf3Bo52G3Ul3CWTBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vRCnKzpRKiO/o4hmU5BKF4SePPAAHaKbgiItko2+brc=;
 b=GAGyKGPQgL5PFLSxKm7AQ0PrJDYtmhdYs7TRa4FFUdFKviBqWRPddamfzJBKWeoszC62h7VntOmc16lqulJce4jp2FAEcLZVSuGELcdmdjQl6P29OhLn9WlFcMg87ZSy1hfWdiFfOc9cp5JyDfdklOMu9V1v6HP3o14EevSJ4KOlIKedmNZ43wSeVCwwIPirmoWbAY9q+8F7qRhjnrWzQeUXgYD+Pdaiijd0kok2DUAqeXGj1K+dp4i9J603k8IUIxSwiXwROVevkU76IJyB89IZwrte3iD1S0fey5yQMHoauz0x56mJ8+IOFmPRE2x8l8wkuzbImKHUxJmTdHVk9A==
Received: from MN0PR02CA0010.namprd02.prod.outlook.com (2603:10b6:208:530::8)
 by SA0PR12MB4399.namprd12.prod.outlook.com (2603:10b6:806:98::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.33; Sun, 18 May
 2025 05:48:09 +0000
Received: from BN1PEPF0000468D.namprd05.prod.outlook.com
 (2603:10b6:208:530:cafe::cd) by MN0PR02CA0010.outlook.office365.com
 (2603:10b6:208:530::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8746.27 via Frontend Transport; Sun,
 18 May 2025 05:48:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN1PEPF0000468D.mail.protection.outlook.com (10.167.243.138) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8746.27 via Frontend Transport; Sun, 18 May 2025 05:48:09 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Sat, 17 May
 2025 22:47:58 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Sat, 17 May
 2025 22:47:58 -0700
Received: from localhost.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Sat, 17 May 2025 22:47:56 -0700
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
Subject: [PATCH v4 1/5] KVM: arm64: Block cacheable PFNMAP mapping
Date: Sun, 18 May 2025 05:47:50 +0000
Message-ID: <20250518054754.5345-2-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN1PEPF0000468D:EE_|SA0PR12MB4399:EE_
X-MS-Office365-Filtering-Correlation-Id: f3d70ee3-536a-4528-c34e-08dd95cf91ca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|376014|7416014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?eGOxUbDc41cYaZVlM2AYSpWUq7/QoMmA134lC6Ma3JXQxpmbSu7EZf1r/c9g?=
 =?us-ascii?Q?0/wsKB75Yln6dciiy1k4FMBs7GahKyR3+gMbVXbrza+wjn+Wwbt2RdnasWoX?=
 =?us-ascii?Q?zn0lIlYMrpqeCzLvcHrcnl7jjBp/HY96SsfoQBh07aPw89C4qKmdEY41u51v?=
 =?us-ascii?Q?lQPsVb2sEyLH8MhKTSjigWxmV9qbaj8HgglNTe5KNWP6PZEwru9Tb7qPeNHG?=
 =?us-ascii?Q?gCyhqnfYCIFrNV2x45Z7Xzbv68Ij+oCY5PHRmkvB9dv465T1APxYpkCojVhe?=
 =?us-ascii?Q?ID73GzjbzwnjK9B5xoc8SWP2X0xj2txijPqKWTzAx7mOoRmV/YY70WRA2uDZ?=
 =?us-ascii?Q?r4T5sWab6URTLdOmxlA+Ggq3xmaipJIxXHzotSyP0oCTJXsXzjtGvLbfaGF9?=
 =?us-ascii?Q?+L1NuO4wTjigFHQWZbGg904D8KmCOe1nEaTH+K9WhtURXfq6/ygmeX72GvgA?=
 =?us-ascii?Q?zCknrysQMUXZxz42U0UAjC4a1VXHBKNMq1q1t1/Jjjxr0CX7iXAAPO4p52Sk?=
 =?us-ascii?Q?g4piikM74f9ypo4kDiDzI40HcKws3n5orDeAPMPs9gED0WQNWCPKvAS5C1PN?=
 =?us-ascii?Q?oTCz6IYEOrgWnyXWmNlLoiTHH97EghkwmWP0LqQjZQtk4M/PvirMvJpXFTmt?=
 =?us-ascii?Q?7NVax9f78PBXWIK68y7ujlBhCqz92DaGyfxBaTMJJ41LyigENIYf4JMnpNBZ?=
 =?us-ascii?Q?pCcOrL4PgY+SVkNmdQj7qti5/mZCxR8ONNaji16Mk+XQud8rT7XikxaSpmxk?=
 =?us-ascii?Q?ACY15pmtXnkg4mqRlzisdVBeXd0hpYv244frpgJYpqurbKkpNDraOHW4rWwQ?=
 =?us-ascii?Q?rqGAG1OCPC+W6hH7OQ8zHEIA/wPwPxyNYEJeVZKz2xLyWZvifhU/svQ8O9q0?=
 =?us-ascii?Q?rLBsIcvKy8RA+nz76Jw9EZSUbY7QybOW6Dr2S33IXOQuzvGIaHJfWSdDzF89?=
 =?us-ascii?Q?58NGqVyVulMprI9DRrv3Mw999n5oqOZ96Y/Ncvm9oY+maKuC2XIT+yNCDHkd?=
 =?us-ascii?Q?mdzoG04WDrVjgLBC7D3JkwC+Jxl6QuMkxm6qrwrKwFzJljN6V+56g8J9yyPc?=
 =?us-ascii?Q?bo/UEhlkVRgeO50RdJNzAkZtW57SL3mqf7Iivu3wva6udQYoeF5wWm3TSwVG?=
 =?us-ascii?Q?kBNY9YdwPetfTJ4DjoRSGOb1Xf3aXLkyOH2748Ev+irIQMciCqDXmWMXg+jq?=
 =?us-ascii?Q?KJZGIG1rqR1gH+G2hN3UxrYje23T070GHDQWHcBkwcTjx/TT3lr8wivDlnXZ?=
 =?us-ascii?Q?o8JAEK2Luji3FzHV+pBjS7PTRp4NViUk9dPWwTNpYw1dOli0OvafpSHOReif?=
 =?us-ascii?Q?NfeY8ChAcwROTJOE/dRRrDQtHieuWkKLv6Je17JJ8Qu34qE7d6nQdYlhWOA7?=
 =?us-ascii?Q?TqbalVgQ9o41hGB/xRsvPMMSxB+uyr0DtfaTKQytC3ZYC4wp2Is5LnaAjfAt?=
 =?us-ascii?Q?Qf90OIVhsQSCMUWqv6PzrVFN8dnsyou8OPgYlRuhJk8p6YkEGXGLbiJaUJ2a?=
 =?us-ascii?Q?SPcpwTxIQyz8/d8pmtXLMkX9toDDyu5EpUkRVb/f625J77yVI18Kfhs6EQ?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(376014)(7416014)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2025 05:48:09.1767
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f3d70ee3-536a-4528-c34e-08dd95cf91ca
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF0000468D.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4399

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
try to map PFNMAP cacheable.

CC: Oliver Upton <oliver.upton@linux.dev>
CC: Sean Christopherson <seanjc@google.com>
Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 arch/arm64/kvm/mmu.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 2feb6c6b63af..eaac4db61828 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1466,6 +1466,15 @@ static bool kvm_vma_mte_allowed(struct vm_area_struct *vma)
 	return vma->vm_flags & VM_MTE_ALLOWED;
 }
 
+/*
+ * Determine the memory region cacheability from VMA's pgprot. This
+ * is used to set the stage 2 PTEs.
+ */
+static unsigned long mapping_type(pgprot_t page_prot)
+{
+	return FIELD_GET(PTE_ATTRINDX_MASK, pgprot_val(page_prot));
+}
+
 static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 			  struct kvm_s2_trans *nested,
 			  struct kvm_memory_slot *memslot, unsigned long hva,
@@ -1612,6 +1621,10 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 
 	vfio_allow_any_uc = vma->vm_flags & VM_ALLOW_ANY_UNCACHED;
 
+	if ((vma->vm_flags & VM_PFNMAP) &&
+	    mapping_type(vma->vm_page_prot) == MT_NORMAL)
+		return -EINVAL;
+
 	/* Don't use the VMA after the unlock -- it may have vanished */
 	vma = NULL;
 
@@ -2207,6 +2220,12 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 				ret = -EINVAL;
 				break;
 			}
+
+			/* Cacheable PFNMAP is not allowed */
+			if (mapping_type(vma->vm_page_prot) == MT_NORMAL) {
+				ret = -EINVAL;
+				break;
+			}
 		}
 		hva = min(reg_end, vma->vm_end);
 	} while (hva < reg_end);
-- 
2.34.1

