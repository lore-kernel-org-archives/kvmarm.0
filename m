Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2080.outbound.protection.outlook.com [40.107.93.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F6E32571CD
	for <kvmarm@lists.linux.dev>; Wed, 18 Jun 2025 06:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.80
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750229764; cv=fail; b=u5/bLwL9LvcTBolf5A2hSw9TRmKb9osDKwsBAmysFJgyWfJ5hoZSkaJzastC+LVE19KvGivlRXlbFu+67kUteihjaQq1GlaxsGSUAOC6iI5ddUbu2v7yrfabCyQ8S0KmPUqQa6TwnYhsdCW7qM2YS6s6n6MgD50zfi4U2VP6Lok=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750229764; c=relaxed/simple;
	bh=GhKp7FvzESbLuQWCUQd1+AIWKhYfnbs2fZpjujjcNuY=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ijb8vW8vYOTWZ7b1A8fZZ+fxaVVX/EMaEi/MicZZt+C+WQ3JHTWFY10VTSS9yqy5X0sl2Hz8TN6UFu12OJYtDJxNuXqxGGs2JZGjWN9kqRZOXV/2f5YBUjIz31tcK+8/2U9DID7F8rlD57PPXWfj4smoHeOlAW2uYRiP2g1mzzI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=N8NwkUsP; arc=fail smtp.client-ip=40.107.93.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="N8NwkUsP"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Uvbm6/khrDJNIGE/fghfUy/VUp6VbgQrUDYkZucuW8+j9A3E/XgrqXq3XSwCmWvHusw06HE1NMffADgJplR245iHHPZTEXTAMJ80MRJxQh9TRpxwTIv2rrUm6pAXMKMpTfV6QNHlJovfooejBM5/KSaoP3uXO//PayCRozParn8BGmZ5UdMDMUw82EhJQCt81x6631hWopuaAGkWdsxtsJPGmDazt0xqH96a2SIQdiEF6jhX8reYW/2k3/QSiasV43fPJI+5geZReja9fjyuUckjb0gxVXDKkuNxVNrvxJnOT3AIBXU+yr6F6xwumygsNO7Sx+riBFa9yiLkYYSEVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HC56gVUWGnRt9uTvaSA+odw90NpXprVtkscIa9DkaVY=;
 b=QUiUlsmz+4mtNpx2YJm5zsl66iXBCC0ki6a1HGtDboel33ipKq9i/VmM8VYHCcD7k+/wELnnA5rD+SdyRkyYrUtUQLlh1O6Bd87wgYTWh3h6VkE9Emy/UBhE8wuIJhMcZvM0xrhRxt1H/9rMvFRGsQv6GKCBtGIKri8sm741rWk6Qh7F0fUpfRn2pw8FYJb9DryrTbcZ2iXZ5bV4oALwTkTGLF9v4Bw/kQ+Ek/479gVypPH3vOr8GdWsP8pSkgEPE7t7RPnf0buBVLB82TJqM95r57rwXh3mPQ1vUBj90rhnssMLJ/tpys2z23bu5EoljTKvQMpoBGEM7dJpcfkWhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HC56gVUWGnRt9uTvaSA+odw90NpXprVtkscIa9DkaVY=;
 b=N8NwkUsPAEIAlg7Es3MfSCgk1PP+d9qoym3hPYHhe3uTEmLI6JCTz9cEkryYAKIUjjfzrKQ/75ZuZgJTRAn7mrt1SjQphgkE4+e0ETURpuW/KvhaPf+qgONJmfBGcmliu1ECEYrxPJ+ObwUJKry1Dh4qSShI2oUfWbdCh7e7atwfGGaCe64MOACAlcMzNNoS+92J0D1JG1IYO7DxcRmrHKEh8YpXrZyERhBdfisHw79nZDVmf9MK1A7LlgWf2MyIPvH3OfwoVwtUcE1vhc/y1AZkLmdLkX8Yt/oY1aEfShl4U5Rny5PQZlm3I6FUbvrr36c8jiaCDpvdIGQ5dYc7kw==
Received: from SN7P222CA0029.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:124::23)
 by SA1PR12MB7152.namprd12.prod.outlook.com (2603:10b6:806:2b2::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.19; Wed, 18 Jun
 2025 06:55:57 +0000
Received: from SA2PEPF000015C6.namprd03.prod.outlook.com
 (2603:10b6:806:124:cafe::6e) by SN7P222CA0029.outlook.office365.com
 (2603:10b6:806:124::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8835.32 via Frontend Transport; Wed,
 18 Jun 2025 06:55:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SA2PEPF000015C6.mail.protection.outlook.com (10.167.241.196) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8857.21 via Frontend Transport; Wed, 18 Jun 2025 06:55:56 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 17 Jun
 2025 23:55:43 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Tue, 17 Jun
 2025 23:55:42 -0700
Received: from localhost.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Tue, 17 Jun 2025 23:55:41 -0700
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
Subject: [PATCH v7 0/5] KVM: arm64: Map GPU device memory as cacheable
Date: Wed, 18 Jun 2025 06:55:36 +0000
Message-ID: <20250618065541.50049-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SA2PEPF000015C6:EE_|SA1PR12MB7152:EE_
X-MS-Office365-Filtering-Correlation-Id: 3cee035a-78ea-4880-9adc-08ddae352d1d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|1800799024|376014|7416014|921020|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?i6cWShiFLfxgenWQ8mhckvoxuQi72tM1taWtHhFUL5cS+x5kbjAKttYP9ItA?=
 =?us-ascii?Q?Ja4yF4JWfjsupPrOUkU2zlFvpMT8uRfGh/yQkf1c/t55LW2FzNQP7psZng3E?=
 =?us-ascii?Q?+2Okmw9AazsL+BVmCxC830B+JBi4lvsIxCiM+N6zTYhjlbIFmNdoh1BTfiNw?=
 =?us-ascii?Q?p2Vqewn85GtPXdKL+8eWaT3pKGfhr7lnzGIzY1k3q3c2XEeofF4RkTnRLfSJ?=
 =?us-ascii?Q?sllSOugDA4yx2ijAlwl++Sf5+EPFz1NHZgASd3FGfG5x2hCdlaO0zimDmImQ?=
 =?us-ascii?Q?L4VhRjj+bGoM84In21aGoHCN5gppM5vyBBQSCW7j43spPwh73LMkpO2SZuI4?=
 =?us-ascii?Q?3xgWBFAuV5dkO6c9I01ngH1ZziEjC2d3ZwB1x4STnZm0liCujMN1eA64FopF?=
 =?us-ascii?Q?94dhQM2qIlp68qLfYtbLDXojCALVRXMI8kmT7c6fKHh/1pVY8mCqpDdg4sD9?=
 =?us-ascii?Q?dd7yEdAZhQkWf1zuQJ61BfgFt/HqjG5MV7QlUVk/fEQDc5jGUIHh8Fi2oy4x?=
 =?us-ascii?Q?cMQA+x2BpW/m2x00psGKyA/DOM5MnStRpfeYaVq+nyHnQQUrXQPr2CxdItUu?=
 =?us-ascii?Q?SAbKkv+TZ5foP55mDCvYc3v2S9Ae0l5LITOM0iEZ14G25Io9nHy6FpC0sWMH?=
 =?us-ascii?Q?l0ZTgiP/HPJccF12CS1pEE8GhXViiNiz0K3ZSrgPmm2M+/60NH0YAe27Ah/w?=
 =?us-ascii?Q?1QBrbSkIPYV3X4KI2y3PJHe4CF/fBTcM13S5NHZi+gRqMJBDAcZcF6BhABm9?=
 =?us-ascii?Q?YZ7keddzM8vSdxl/VnZUlxpp4YY5tUPyVQ203Q4FB8BRePjOfViQmryAdaet?=
 =?us-ascii?Q?5wpWh28MisTH3X/bnSR8KavrpAsC64S3AlZqhnllX7SSe5rydVxjhmP0RmCC?=
 =?us-ascii?Q?4bEF4TS9cBmqcIWahTALWwA9Z8B7bvddPdCCbC/pPaezhqoYB2IInwzCmiKU?=
 =?us-ascii?Q?TrdKaFlAHvlt+x4aHGv02p9q1z1X7nqyyaFta2WCZx4xoYfujFuSMuoZZFY9?=
 =?us-ascii?Q?wrpNxZrcX3IOjsH/P9V8c8QwlJPvJ9iX6Sqj1KOsy/3MGJ8jgusaXRLoB4sE?=
 =?us-ascii?Q?M9uYW2+IPQ+1OzkVZhniDZkpTltFtS3KwD6vaUsXyLfIPHX6KXt11cQ2l9Hf?=
 =?us-ascii?Q?mdhlVAbo1bHJ/f53WfcIY2PHoSorXEHYlDjMnDPyqKXh3dnihYFdXzhNexdc?=
 =?us-ascii?Q?jSakM4OiaBSwteFTDNmIe7I4LrJikZXiTQGjnZc4TpDdIS5R7anDLMGwY7L9?=
 =?us-ascii?Q?IU4fuRJYp7aQgHRtRYosYWRMbH2ZILYDQvSXTP46bT49P9KFTTBGQqVycNyx?=
 =?us-ascii?Q?SbOYMgz3pZsA/FtZhqO5VAzSihe8H85pZ3FhTSq8DsHz4nEIEK4Ywg/K7gQg?=
 =?us-ascii?Q?YvYX/FVIxhV1MJ6h/EN8TQDpnCcyAPmNpcGcXtmgtiJymUG0nC3hyXYw8Qmp?=
 =?us-ascii?Q?CBn3fF51DZ71dxKYM44Z8S9SgI3HKz7+4fTXGBvFoxVsgu2BVYMKWGs+qTYe?=
 =?us-ascii?Q?I2qAnQ2qbkM3IXocMGNo/oNdWdQPGWf8G/As3gq95yeB+8WEL0eS12Yi177P?=
 =?us-ascii?Q?xAzxTBO6d2lX6l4x1Wg=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(1800799024)(376014)(7416014)(921020)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jun 2025 06:55:56.9307
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3cee035a-78ea-4880-9adc-08ddae352d1d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF000015C6.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7152

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

v6 Link:
Link: https://lore.kernel.org/all/20250524013943.2832-1-ankita@nvidia.com/

Ankit Agrawal (5):
  KVM: arm64: Rename symbols to reflect whether CMO may be used
  KVM: arm64: Block cacheable PFNMAP mapping
  KVM: arm64: New function to determine hardware cache management
    support
  KVM: arm64: Allow cacheable stage 2 mapping using VMA flags
  KVM: arm64: Expose new KVM cap for cacheable PFNMAP

 Documentation/virt/kvm/api.rst | 13 ++++-
 arch/arm64/kvm/arm.c           |  7 +++
 arch/arm64/kvm/mmu.c           | 98 ++++++++++++++++++++++++++++++----
 include/linux/kvm_host.h       |  2 +
 include/uapi/linux/kvm.h       |  1 +
 virt/kvm/kvm_main.c            |  5 ++
 6 files changed, 115 insertions(+), 11 deletions(-)

-- 
2.34.1

