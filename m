Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2045.outbound.protection.outlook.com [40.107.223.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C23F293720
	for <kvmarm@lists.linux.dev>; Fri, 23 May 2025 15:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748015099; cv=fail; b=TFMrpknjeZdV3OHUnPAQ835oEkPyuqsg09IE6Jb7yYv4nuF5FmsV8q0KMevTAHYDs46sE0O2UwWbCWEjKrMedGzQ68bR6EeLZSRGYfWU4zjkLskmEjBJuU/lV/78X8iXbfu6VSZ03CllmVIZfAcZpTJ4mMCP1BXWAj9pcnSJveU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748015099; c=relaxed/simple;
	bh=qEeUq/6NBwjqTdME6bWWYamWJR/prEA+1r+zsW1vQ2E=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QocJ4fvNIHxs5aqihO2D/0x6weW2ZOz4OzvftiAqqLVJt67IWZd3hahy5zVL1EbPL3hz0rCjpYL0rmtRq1yee6IaDKUYefxgfm7Mer/V8L9617gnBRJ9Cyjuz1Dv1OTbdrWSee9bQvTx1vIA2+w5TDNzNDARXTzabJU+QABGDVc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=jkJrEMH/; arc=fail smtp.client-ip=40.107.223.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="jkJrEMH/"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rZDfodrNuUXQzcZ9/mWd0g9zf/acUdTh9VoZLcASHXJgFSwgGR4afgmr4/pkGZJfwH9zGlbPcwUrkCSiKklySJmlzRHl4ykkJQrOg/z9WG24dqPs/m7OiJVL3vwNWB5qExI7rwuw3RAjMzgEoWuHd5iQzgJ0/V2ezN97NGL+yeRfq2A7VtxTywQoXihHNvRoqiaV3yFUyUz+B8mcWZTTppLDrzUOG0MllSx6lr8ltDyg017JfxzZQmtQ1ILOF8U+PlA1zFxcoke7oMFyLNb2SbsfzzdOfhLY2UGyhvJy2DGywnXYjVtbjUlRswmvSFlXx68/aomZS7DO6Pbi7vYc2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gymzk3KsFCNp8Z21DTOLHrkEpVUsP4yOo0PLr+aRcVg=;
 b=OS5SZOOmE82lgNxR013h63MtMxmAFmhvPRk3/3XilfOwQfSZ4TOAOeXhe86hKktrDk+wMKhFxBTfiYovtJEMPj103PC91lK1pFS7fEa8XpT21fKv5/UiV9/ukkxe/M1Z7CbzD6hJHYqIAsDckk0VXEw87yf1ptS//QYU9UaKDP4o5rlE6w9MXSn+tIPWTukIAN5rWVmwqTT2sWnebboT0viBwufSE1dP7EVeBAyWG9vJxHbC9w9MxGD2QQ2oDMP2Ry9BOYmj1eNmslYB3+Q8w12/QHEeB8iQ8yHjOQE5jHZot/cb81zl9QU06K6Ux7KM6q4rI8O7WdOwNqemJV4Qaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gymzk3KsFCNp8Z21DTOLHrkEpVUsP4yOo0PLr+aRcVg=;
 b=jkJrEMH/JYjaESzdY59QoKHIehqMDJj4CGq4SxKekRJvhY1xi+keIBee/nk5NGWdX+4wE8lnaqhx6v7daoACPphIv8aePWEyoKrMQm7lQNOUExWX2vTIvy68Kr2yW9GPLf5iITIeCJzq4UdPjTmT9QFR2Q3wfMT5CEsr/qrO2VkQbIY78yZUSFcl1a7ZPeHr3N3+zj3sMXQiYsOe8mrEiJTABNa3uC2QP2W0klqbgRPyv9m33OV8Ys00ejq8dJguXWbV0Ivmi68BQq6SeIx1mDrbicnKquMcTuBD8zQ3vsxyb5OOoNEQMpUPNzgtGkdVB4rtD+XdlJ4y93XPFA7IhQ==
Received: from SJ0PR03CA0295.namprd03.prod.outlook.com (2603:10b6:a03:39e::30)
 by SA1PR12MB7318.namprd12.prod.outlook.com (2603:10b6:806:2b3::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.31; Fri, 23 May
 2025 15:44:53 +0000
Received: from SJ1PEPF00002310.namprd03.prod.outlook.com
 (2603:10b6:a03:39e:cafe::4e) by SJ0PR03CA0295.outlook.office365.com
 (2603:10b6:a03:39e::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8769.18 via Frontend Transport; Fri,
 23 May 2025 15:44:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 SJ1PEPF00002310.mail.protection.outlook.com (10.167.242.164) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8769.18 via Frontend Transport; Fri, 23 May 2025 15:44:53 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 23 May
 2025 08:44:46 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Fri, 23 May 2025 08:44:45 -0700
Received: from localhost.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Fri, 23 May 2025 08:44:45 -0700
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
Subject: [PATCH v5 1/5] KVM: arm64: Block cacheable PFNMAP mapping
Date: Fri, 23 May 2025 15:44:41 +0000
Message-ID: <20250523154445.3779-2-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250523154445.3779-1-ankita@nvidia.com>
References: <20250523154445.3779-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002310:EE_|SA1PR12MB7318:EE_
X-MS-Office365-Filtering-Correlation-Id: 240bed3d-1325-417c-a10f-08dd9a10c29d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|7416014|376014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?53wbcYuAb3U0wpHWzSLJd2D1i1ntgsxMcMeEhG9M2WOUQ4WNyxe1eOJtX74z?=
 =?us-ascii?Q?W44mVg62Hgq2frgaeNLLbzgcGs+DNFexdUVwzax5dYa7An5GFWQt05nIxINV?=
 =?us-ascii?Q?KNs4XVT1EPwVEgAcluAS8sVxvgVgoxRD/e3UcoWlMmN4SYgzpggrle50H9A+?=
 =?us-ascii?Q?cbKc/Ls5nGsUP7XaYAl8C4gyX0Q/lrVN2SkhTturmaA+kzHQmXA7F0lp5Xrq?=
 =?us-ascii?Q?vq4GkZ/gnY7JyT08EKpWPc5Z7oVp8LFoQd48KDsQPGy3L2soHlVFsxjjYasa?=
 =?us-ascii?Q?RFtI8VfL3yX6sFnqy1FIGbxQq+qoRcJNY8IlEV45WKhQZ2dXihEHuOtiTlg/?=
 =?us-ascii?Q?4jw1rVp3iOigCvEbz2nDS47Tbu13aYHDsYNwFkjgFut7bUoBrBQKxlImE0Cw?=
 =?us-ascii?Q?lZHrE3dLfd1snsj2sePaKq+hEd7p4VKkHdioEjf0mXACH7uoPa0UrKi4Ghgc?=
 =?us-ascii?Q?azX9fyCsfhPGTTLfYiacCl0cxNfcpXI+ig/q4wNelCf036l92SGLN178ysoz?=
 =?us-ascii?Q?2BYCNIP0Mc9AoZpAjuo+EmgZbUQGm7VcHkfbMV6yen8TTUf01txL/6GmcqV0?=
 =?us-ascii?Q?gyTlnjAkHZcwVOn9wtVgVr76SSCI0oLXjn5Ybew/kmMnyBlkpwYrKUgcY5bN?=
 =?us-ascii?Q?YW8W2h2fh8Pqx66cJ15rhXcOXJiHpgydkpxhZcaAcqnPDcV4ID5EOuiwa2Bb?=
 =?us-ascii?Q?0Zh6cmXODLYXTQMHvDhMf5YyuGjA4iAFZdMWYMZjzJUTsdpvTHufTl53Ifrw?=
 =?us-ascii?Q?bTgWbBVS1MWDS4clDf6cRSJw1qs7Y5PJSoevViEhlt51I5G6gSeNCs1GGjrA?=
 =?us-ascii?Q?o7deyGDlOpOzRWJRqc2Wt/Jdbyy18YN6jo3d0flwrPBiJNZagHtPjzVKFT3h?=
 =?us-ascii?Q?z9ZXEZcruMU0aI1dS925AtNubKgkwS9Saq7Yz71CoYvp7+6UlSMU25gAoq+f?=
 =?us-ascii?Q?NW5F/EYNfgaquhsghxKxBk7vfBy6crd5+HK2KETQP40pgz5CeV3azLvx55AX?=
 =?us-ascii?Q?9GM2CqD2XgVZ3mJU1BCt31cMpOwy74zQY1eLmxov3p44VaT/N7kQfH45mHKB?=
 =?us-ascii?Q?ijZLUn7ewX4oPwfd7Qn20IX0r6rVq86NKLngxLdfU2TLnqbMHFTV9SE121hy?=
 =?us-ascii?Q?Yfws+UPSAmwCFHeHRJJPIw77ZzfxT6f06PUfTClrWL7gXNR0+66XcLJAe52e?=
 =?us-ascii?Q?biZw5gSzHoA5YV1acm4Jj+MyY2ybQIVH9v1e+tWd01BPOrL8WrGunicj1SjV?=
 =?us-ascii?Q?r4OwH8Kh64lZKzaPNBi1TiOK5nwcyEJGvtRvK9DpGeJicuTJ+ddQsTCh17zn?=
 =?us-ascii?Q?Er7BScrWNkjf0XVbxI8Eg3tJi+oGsRyxUByfxM7QdHl+9NddFQ2+LZe2aD/m?=
 =?us-ascii?Q?wbE82lUjXmW/IFetpJppC9ICvYIuchLZSlisVCgOyFNYqCfKZmx0Ywaq0GZq?=
 =?us-ascii?Q?9Yajz+Xy3i0uaEDe5B/YhpmucOT6a0nCO+mjjSwRMrhSfwnRxYBPMlWMUg4p?=
 =?us-ascii?Q?bwKv3cBg00Um1qiIiOJ256gYYsFJuDHkZCssRIm0UPHZTxJp6syjfVbE5A?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(7416014)(376014)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2025 15:44:53.1599
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 240bed3d-1325-417c-a10f-08dd9a10c29d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002310.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7318

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

