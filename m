Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2088.outbound.protection.outlook.com [40.107.244.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F2DD41C7F
	for <kvmarm@lists.linux.dev>; Sat, 21 Jun 2025 04:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750479685; cv=fail; b=TJ++2xB0F8kXa5e3mSGUlfrr++LjyXogvNVwpb8zqdlLy3NTXbjvv/M0VUDzzZHx88MhvMiZOGeN+5rF2BBR5Mvy9E7byUoUYOsjY6UkoS0vXLwmQIXwHZff/Yy+roC55/tcY5M6qpYUCgryoUFQd+JO1DMCQT2jmpFlZXd6SGk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750479685; c=relaxed/simple;
	bh=2K2mdmnM3qKpUimUB49IS38HNJlR8pHMhN+71Q3K76s=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=D75ARYmE2gpfOFdL0/UbKDp96QzzneIQWxSnxX+qF6xof2MKFGFiWoNDZ5e/ViOXizZCcbWn+RRVSNxdf9rA6gbQZz3u0klwTKFhIDL9l5GeAAP42gzpwZoSVCZY4vNDi74u6cfAAQLw8P2kNiUN9HumAXGBoazlKWsPBx11ZXU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=NEvBA5DN; arc=fail smtp.client-ip=40.107.244.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="NEvBA5DN"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mGLmXsLafWhXqgUR40igHh/zPWP0Hsf/tONLnlCYRxPGBmPfv/VAKKt+OgcWuRW9T2RfzQHWyqq94qPxJ8TocFF/YrChzN4jEiyVEhCIzNT894PdsIDhfbdHdk8+/ewbgomNIGsqoHEzgRVuNcrMPTX0xKD234Yux6tusBS1Q6RoAbQ6KdUGKs8DXWVGYr4Qm+lo1ZgerFrCI2zKt+A/QlhAi24lztjTWE9KTMPM4yOLkbfrZSYhYBdF1sgJlmcIxxP3n71m9aOXOX1Jaqq5a7l178Ar2xkt5LUHT0dt19l2Fl6FEu1NYghRBuMH3FvXTawXOYTIqxbH6KrHAbZMXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fe0lIOs1oKbyNePp87Ndh8CQicpBg5ZNs5OnELralbs=;
 b=hCVav1M0HsnfZruhg1aAscrx7nPDmg9phcVmNGq4E4th2xFYVLoX3tE6/RrCVibXWjkz1Q4TFMC07e5gTeug8B8H6IUDhmXL9NgVe5guBttcX2kDercNSYdF/vRBxZfj0WI+Su/9wSLdyatPXlKXKShPoxDaulupCXqDh3Lkw3wWmkjYgADHYBwEGykaHEG9KphpPc4fkfyxF7SdZaZuDKWZDMmfOfBTKvfEBOZk/1uHz61e88Eq2HqkqIuWbdkLFFXOCZYweFkEJqvSVodX8PvlWZo3MIIq9tei+/PwjegsOLCv4YmqcWP6/zhOEBp3CdVgsOplqtxKurLG2S3L9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fe0lIOs1oKbyNePp87Ndh8CQicpBg5ZNs5OnELralbs=;
 b=NEvBA5DNYykJuw2CevhHCXRnK/cHe19+Qxnc/c+3NQbxpjC/h26TZicLqnH7ReEszHuFtaUIqW7+3qOE5JCxwyGLEwIUHYZoMjbnvijHnAfl2atplmim2+UUDDQB/Q4VnquNFdE8UzFLokRg4+3Pwa9Suwb4LAwbu27vC8NKfRJmGGoYw35s1AnMAf/MQZFF1aYisAF/CDgDC0bm6MIsbiI2Bc/9+S8B+UV2CEjIrGAVS4vYe/8IdUmyeUZ1vsEz7674qugFfJXELkvYxMwaj46XMpxDngG5FCmjsmfWq4U30LrC4JDOUvhJ/T6wrghknN3Z3VUyIEsF5mr5mRJqdg==
Received: from MW4PR04CA0389.namprd04.prod.outlook.com (2603:10b6:303:81::34)
 by IA1PR12MB9524.namprd12.prod.outlook.com (2603:10b6:208:596::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.24; Sat, 21 Jun
 2025 04:21:16 +0000
Received: from SJ5PEPF000001E9.namprd05.prod.outlook.com
 (2603:10b6:303:81:cafe::43) by MW4PR04CA0389.outlook.office365.com
 (2603:10b6:303:81::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8835.32 via Frontend Transport; Sat,
 21 Jun 2025 04:21:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 SJ5PEPF000001E9.mail.protection.outlook.com (10.167.242.197) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8857.21 via Frontend Transport; Sat, 21 Jun 2025 04:21:16 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 20 Jun
 2025 21:21:12 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Fri, 20 Jun 2025 21:21:11 -0700
Received: from localhost.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Fri, 20 Jun 2025 21:21:11 -0700
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
Subject: [PATCH v9 0/6] KVM: arm64: Map GPU device memory as cacheable
Date: Sat, 21 Jun 2025 04:21:05 +0000
Message-ID: <20250621042111.3992-1-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001E9:EE_|IA1PR12MB9524:EE_
X-MS-Office365-Filtering-Correlation-Id: 59dd6257-5149-4876-2c4b-08ddb07b1087
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|1800799024|376014|7416014|13003099007|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?9ZbxZTIcaqHDPA8y9tZ53OmuBrZW+9hp2Ypg87L1d7Fzmio2eNEpSPYCpmK0?=
 =?us-ascii?Q?3OKsDKDciC8WEe22yqQ9cSj736kSsiBpKWZFIqaG8UFHQ/HAd5eUmo/2ZaI2?=
 =?us-ascii?Q?RlGSSRFgZ5ejY03NuWzPAV5OzCNOHtZit90bGi7eqfXYLrkIo3UvYMPnVuGA?=
 =?us-ascii?Q?qUadcLonV2EA9F7s4lNOJZQedhMTVcdS+20P3GwbrEAEoygwRQ/er1PkcdYH?=
 =?us-ascii?Q?kaYlnFyu801URPahaRqli6OwMmZSn6z9HFToJpAnb+8GiKbNzR1HZjLhikBs?=
 =?us-ascii?Q?yRtPV4LMwNLYE0www6Dt1UC0ehKptDGynMvg28qLMvrsngwsXFcvFa3lTOAa?=
 =?us-ascii?Q?FiifwL2BdKWmOkKsCszsGIqBw2mjhjP0BRA6lwrgXbRKZJqlw4gyuRSudBoY?=
 =?us-ascii?Q?sKioKS8ofNs8WoW/mGNJ25hNKLwje6GCXl5oKhiGdmmUF1oiwQlLUR9tVdY8?=
 =?us-ascii?Q?+r1ba25W2Cl3NYK4FOlEX33vvRj950CSiicVLkq0L8w0KN2WJanT+7JR6aG8?=
 =?us-ascii?Q?Y/LF/FVD7K8Hhj/sJvdU/TlvHu7HXifmLRxxuRkTZ6rn7PJlIWhToG4OzKlg?=
 =?us-ascii?Q?FacVC1WlbNACXQX9OtYIQ3B8brD35y0/wfklFetSnh3W4EqeDAk8v8eS5o9U?=
 =?us-ascii?Q?8wyMnI0ZRjr9/l+lrsvgeHZOB4VN1WXxlEuilR7lFzwhCa6HksuAXXNrR0lw?=
 =?us-ascii?Q?9CeKfdJQHeCS3IJ2NtTV7QcSRXnIbswplU485Z0jBv5aIUw7Ax6SQnujrX6S?=
 =?us-ascii?Q?aDrWUB9jyd9o/WTga4EtEe9CPSgr6vFz8QCu5CPhWoD0S5V+F0+b+RplS/Sd?=
 =?us-ascii?Q?fgcqzYSE8x5HY8ZanNSpVDaB0D2g+FGMLtwTcZlOEZ7C46iQqBHliPSmkHQt?=
 =?us-ascii?Q?OfpK2K1FjsrMfW6zPsxQL18O6yzBbC5hG8uA2qATmTYSKioBcBqQLUx2oFfD?=
 =?us-ascii?Q?XlC0rJu1MAbQtzd7dk+GFO3+5n1fnpPEwtLj7XrND3122poQiBNQ5J56BKwj?=
 =?us-ascii?Q?misXUJsB6kIP5Y6OTB0o56Hit23U2AFkIpXhqqM3pVB4vR+ql6b04UWhmxtO?=
 =?us-ascii?Q?2l2TkZ4AxJHVSx29WvieNj6dfDBfh7ZOK14uekV988jxbwPwMZirNGUMUo4n?=
 =?us-ascii?Q?Zy1WAAsCZnUdXNlaqKvmI3zZVhh+3feKjfnFN6ZMour7MmN1+JRyhQkKjw1y?=
 =?us-ascii?Q?GXapXmSj0LhFQTz4yySn/TdDETKc+9mQmrvbzDcybg/WIe4dO4xlOeeeQhlK?=
 =?us-ascii?Q?/ez7/3uaW08Nf+cFFi8g0z1uSM6iJYmJY+k/i6ZKe7aPT1M8AN2rv9nrplEz?=
 =?us-ascii?Q?UgJZNmNI/Koc1MftVN4jltjL1w9SK4N9GtLy9+Jv0QytPNtzaHA+vz2v1DK0?=
 =?us-ascii?Q?Mnemx0x61en46ZQXia3mKWt5QWv7e2r4arKqj8wH4zXKHgWZBaHyvQvTcn8t?=
 =?us-ascii?Q?o6Nl5d1A4IwSig3n5aWxFV0FYdms2V6DHlEsqucZwsedz1zJs7Y46T227cUX?=
 =?us-ascii?Q?giyFY28lm52I4/p08b9tPMbuyfo0VUpNDz6bXZ9EtZicq9sm2/TuMfkYlZ/2?=
 =?us-ascii?Q?O0cvFfGU9E0lY4KaC58=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(1800799024)(376014)(7416014)(13003099007)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2025 04:21:16.1019
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 59dd6257-5149-4876-2c4b-08ddb07b1087
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001E9.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB9524

From: Ankit Agrawal <ankita@nvidia.com>

Grace based platforms such as Grace Hopper/Blackwell Superchips have
CPU accessible cache coherent GPU memory. The GPU device memory is
essentially a DDR memory and retains properties such as cacheability,
unaligned accesses, atomics and handling of executable faults. This
requires the device memory to be mapped as NORMAL in stage-2.

Today KVM forces the memory to either NORMAL or DEVICE_nGnRE depending
on whether the memory region is added to the kernel. The KVM code is
thus restrictive and prevents device memory that is not added to the
kernel to be marked as cacheable. The patch aims to solve this.

A cachebility check is made by consulting the VMA pgprot value. If
the pgprot mapping type is cacheable, it is considered safe to be
mapped cacheable as the KVM S2 will have the same Normal memory type
as the VMA has in the S1 and KVM has no additional responsibility
for safety.

Note when FWB (Force Write Back) is not enabled, the kernel expects to
trivially do cache management by flushing the memory by linearly
converting a kvm_pte to phys_addr to a KVA. The cache management thus
relies on memory being mapped. Since the GPU device memory is not kernel
mapped, exit when the FWB is not supported. Similarly, ARM64_HAS_CACHE_DIC
allows KVM to avoid flushing the icache and turns icache_inval_pou() into
a NOP. So the cacheable PFNMAP is made contingent on these two hardware
features.

The ability to safely do the cacheable mapping of PFNMAP is exposed
through a KVM capability for userspace consumption.

The changes are heavily influenced by the discussions among
maintainers Marc Zyngier and Oliver Upton besides Jason Gunthorpe,
Catalin Marinas, David Hildenbrand, Sean Christopherson [1]. Many
thanks for their valuable suggestions.

Applied over next-20250610 and tested on the Grace Blackwell
platform by booting up VM, loading NVIDIA module [2] and running
nvidia-smi in the VM.

To run CUDA workloads, there is a dependency on the IOMMUFD and the
Nested Page Table patches being worked on separately by Nicolin Chen.
(nicolinc@nvidia.com). NVIDIA has provided git repositories which
includes all the requisite kernel [3] and Qemu [4] patches in case
one wants to try.

v8 -> v9
1. Included MIXEDMAP to also be considered for cacheable mapping.
(Jason Gunthorpe).
2. Minor text nits (Jason Gunthorpe).

v7 -> v8
1. Renamed device variable to s2_force_noncacheable. (Jason Gunthorpe,
Catalin Marinas)
2. Updated code location that block S1 cacheable, S2 non-cacheable mapping.
(Jason Gunthorpe, Catalin Marinas)
3. Added comments in the code for COW and cacheability checks.
(Jason Gunthorpe, Catalin Marinas)
4. Reorganised the code to setup s2_force_noncacheable variable.
(Jason Gunthorpe).
5. Collected Reviewed-By on patch 4/6. (Catalin Marinas)

v6 -> v7
1. New patch to rename symbols to more accurately reflect the
CMO usage functionality (Jason Gunthorpe).
2. Updated the block cacheable PFNMAP patch invert the cacheability
check function (Sean Christopherson).
3. Removed the memslot flag KVM_MEM_ENABLE_CACHEABLE_PFNMAP.
(Jason Gunthorpe, Sean Christopherson, Oliver Upton).
4. Commit message changes in 2/5. (Jason Gunthorpe)

v5 -> v6
1. 2/5 updated to add kvm_arch_supports_cacheable_pfnmap weak
definition to avoid build warnings. (Donald Dutile).

v4 -> v5
1. Invert the check to allow MT_DEVICE_* or NORMAL_NC instead of
disallowing MT_NORMAL in 1/5. (Catalin Marinas)
2. Removed usage of stage2_has_fwb and directly using the FWB
cap check. (Oliver Upton)
3. Introduced kvm_arch_supports_cacheable_pfnmap to check if
the prereq features are present. (David Hildenbrand)

v3 -> v4
1. Fixed a security bug due to mismatched attributes between S1 and
S2 mapping to move it to a separate patch. Suggestion by
Jason Gunthorpe (jgg@nvidia.com).
2. New minor patch to change the scope of the FWB support indicator
function.
3. Patch to introduce a new memslot flag. Suggestion by Oliver Upton
(oliver.upton@linux.dev) and Marc Zyngier (maz@kernel.org)
4. Patch to introduce a new KVM cap to expose cacheable PFNMAP support.
Suggestion by Marc Zyngier (maz@kernel.org).
5. Added checks for ARM64_HAS_CACHE_DIC. Suggestion by Catalin Marinas
(catalin.marinas@arm.com)

v2 -> v3
1. Restricted the new changes to check for cacheability to VM_PFNMAP
   based on David Hildenbrand's (david@redhat.com) suggestion.
2. Removed the MTE checks based on Jason Gunthorpe's (jgg@nvidia.com)
   observation that it already done earlier in
   kvm_arch_prepare_memory_region.
3. Dropped the pfn_valid() checks based on suggestions by
   Catalin Marinas (catalin.marinas@arm.com).
4. Removed the code for exec fault handling as it is not needed
   anymore.

v1 -> v2
1. Removed kvm_is_device_pfn() as a determiner for device type memory
   determination. Instead using pfn_valid()
2. Added handling for MTE.
3. Minor cleanup.

Link: https://lore.kernel.org/all/20250310103008.3471-1-ankita@nvidia.com [1]
Link: https://github.com/NVIDIA/open-gpu-kernel-modules [2]
Link: https://github.com/NVIDIA/NV-Kernels/tree/6.8_ghvirt [3]
Link: https://github.com/NVIDIA/QEMU/tree/6.8_ghvirt_iommufd_vcmdq [4]

v8 Link:
Link: https://lore.kernel.org/all/20250620120946.2991-1-ankita@nvidia.com/

Ankit Agrawal (6):
  KVM: arm64: Rename the device variable to s2_force_noncacheable
  KVM: arm64: Update the check to detect device memory
  KVM: arm64: Block cacheable PFNMAP mapping
  KVM: arm64: New function to determine hardware cache management
    support
  KVM: arm64: Allow cacheable stage 2 mapping using VMA flags
  KVM: arm64: Expose new KVM cap for cacheable PFNMAP

 Documentation/virt/kvm/api.rst |  13 +++-
 arch/arm64/kvm/arm.c           |   7 ++
 arch/arm64/kvm/mmu.c           | 134 +++++++++++++++++++++++++++------
 include/linux/kvm_host.h       |   2 +
 include/uapi/linux/kvm.h       |   1 +
 virt/kvm/kvm_main.c            |   5 ++
 6 files changed, 140 insertions(+), 22 deletions(-)

-- 
2.34.1

