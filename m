Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2046.outbound.protection.outlook.com [40.107.92.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CE4A2957B4
	for <kvmarm@lists.linux.dev>; Fri, 23 May 2025 15:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748015115; cv=fail; b=V+JAdYY4GibJO0edJuzzFXlhDzQPlTxG8vPz3pi+LlEzxPUwKggUi4/pt86/C6rb6rs07ihTZLTL0MchBId2LQjBzfDiyNQxpHJhK0kPwwZDrbta8VIrgg1GhiKUHGzywmaehXHMuLcS/RDyWilgoDVN4HfsGG3RlFqxFP9VblA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748015115; c=relaxed/simple;
	bh=OPLCjEqxqx/e5OpjmknzlbnwMPXuX0C/Zd2wXAyllIw=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=BqwwxuKWBzrLnxmIRd6mYFFc54vrO3NciRyb/XNYyYJbGgELgpqxHC9GJTOg/8zjVnXH8jviIq+GbxKnWg7NRdGhYtRkIITgtR63N//rOqCHCEkeYxRFD/7G6pmFRBfn9aN6c+FauTmQHKPt78JELyeRBFl+F4+SlvhF/4YRWao=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=sZsHUsIt; arc=fail smtp.client-ip=40.107.92.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="sZsHUsIt"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=amlZ2QZ3Eomwv+WqeENGPkHducBhJ8suGqqGAcyAFm9zcr3gT81+TzkAw+XGxX0sh/O+V5+3VMXUPjoimwha1m0WzsvaK8NeE6DCefI/vGcSC6QWscTiwX6srknEazpRGTzc3pQRqRQGFdDfjfoKaFrECIVY5kCq3zQk5pl+M00NsfuZ995S/Up1hKyCc/4YXR7LXqPO08mvRKU0Gx4HuM6DvO3elBZwstPF31U0VUNKl7V5LuS+sDJ9EHy2CFZPnOPJak6TWcTVqFnZtLhSP2G/gDYHYGNHJBJ0fHs6BjfuivHlpNqvnI9A0QPZk1TQ4qrIBvJs0SO2SzwGP4UD2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+U5BmXBCwXq7dcG8dVOYzzidUz4anQB0juElHap6PK4=;
 b=NeDxPG03gxnibkBcKjAMqzY7N2bD+FowVUPZhwkL1hXHTqTsg9ooViUSQScei2yhZ44GcCApBI66DwgroWpoTBixa/5hhfXa1hwkAMIVnElFNycv8GUTIgYuOPuLh6iPvtiG44+82gCQ49SRiNH63Kp+yjhbEotEi3KNvjlFzL7LQaBNOkIU+6xER+oNC9Y9QrzIOsohI64m4eC2Xbv9b8FJE3QousXV7R3Pe+vMwx4k38xewuH6fJidQh02GqgZzIe13QDcYKOAmw8I7M+VRE5BbnZ0nkEf31vGqTS3/MswKgxY+ObR2zXVBVVqYhYKd89dldKSvKm28Q42LPPzyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+U5BmXBCwXq7dcG8dVOYzzidUz4anQB0juElHap6PK4=;
 b=sZsHUsItHlwBjVYrOOF5n/ZLszufAntgb26LP/TjLhsvEWNyubIIaAcJ0xttqKXVtjQzsOGKcedLdOEfyqoocpaVsUPaCuO9adiqrxvromEmVawig1bkIipF2tV30TvXJC8KO9n6ah0Yv59GKf1ljdA62m7YddvlG+FhXKtklSspBZQc5uh8GowY9nbKAqoIP7V+U+xdnxTOah4pQUCAhCTk5j1upSO19y3pZ8FrQEzZye+S98P7lral07HPGVA9Mu5nML6BEfVmRgA1B83Xwg7fQPUffv7tWB8uSRjD2N+OMYdqyHD5YTEUgB2fmmhgQ9UWqv0yQhmg/GsT9yOfqw==
Received: from BN9PR03CA0434.namprd03.prod.outlook.com (2603:10b6:408:113::19)
 by DS0PR12MB9348.namprd12.prod.outlook.com (2603:10b6:8:1a0::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.24; Fri, 23 May
 2025 15:45:10 +0000
Received: from BN1PEPF00004685.namprd03.prod.outlook.com
 (2603:10b6:408:113:cafe::53) by BN9PR03CA0434.outlook.office365.com
 (2603:10b6:408:113::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8746.31 via Frontend Transport; Fri,
 23 May 2025 15:45:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BN1PEPF00004685.mail.protection.outlook.com (10.167.243.86) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8769.18 via Frontend Transport; Fri, 23 May 2025 15:45:10 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
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
Subject: [PATCH v5 0/5] KVM: arm64: Map GPU device memory as cacheable
Date: Fri, 23 May 2025 15:44:40 +0000
Message-ID: <20250523154445.3779-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN1PEPF00004685:EE_|DS0PR12MB9348:EE_
X-MS-Office365-Filtering-Correlation-Id: 0b585a95-d0d5-48bb-70a7-08dd9a10ccb9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|1800799024|376014|7416014|921020|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?gnLNWLOHFq6cc3oJ/97PTbcRgYeZ8flik1gIzBdW9VyjOJPoCzdLqVVVYXVq?=
 =?us-ascii?Q?YweLzTmEruQchGRlVX3z+1QkH5xTKJiN0/0Hpml37kqZJOJ17cgmkgi+/p/l?=
 =?us-ascii?Q?9Oom8BR3NwTlMDBUhRkCbBjQg+kjnxzcXkxhEiKyddrhWDpEG8tpCWokQj3U?=
 =?us-ascii?Q?ICzFnw8NlgVKoC62Tf4Y4iLLsClJ6854N0RHqa16Q/w7DT99bE/z96lUiLh2?=
 =?us-ascii?Q?OnEPsXHKJFI9s4ILEmVJc/NdHabPQjmbXk/Jrh6vHOAFDmi+QAcF+ztNtIog?=
 =?us-ascii?Q?0exNPxAaFgEwWK+Hshec5SKHhqbO6I1pfxhDCePtbuKo9RhK95zEHrMDhETK?=
 =?us-ascii?Q?V/2/Xpcmj4725KiUfqbBa9fxSR6zNZt6t7OCtLxwxszIYcGQS+BoMYrI+qlJ?=
 =?us-ascii?Q?edI4G10jlsGAA9iUC7vZCmWTnWk8TLyisB8Hj6bBHbgmnUDac7B4TBsJpk+k?=
 =?us-ascii?Q?cHUcqkCy/BVaEPq6O/ntoOKHcYRjtTjmVxDszPmLSDWCLIv9SoIXTrbWlWvh?=
 =?us-ascii?Q?wSVCE8lTGELAYi/Tpp2qXCZBwt2JQvslJQaY+BjSsRUm/YG1SNQWesLjAAp2?=
 =?us-ascii?Q?BH4i4MmFzFW/GRdvPqisjAzN4cYCRaHo/O3QUx2hZCOz8oFndHmDC6EmvArK?=
 =?us-ascii?Q?u+ke8y4fUnVor8Oc/fmZRrqLlpiSuWq9q0KJxwdSYbX1vL2/3QXG1gV25htu?=
 =?us-ascii?Q?uAeAd36bTQV4dGI/hfb00e5DiipCuPSHnPIT2eLR3VysxDrTR8DnU2SGorgm?=
 =?us-ascii?Q?7y8INA3DfzITamHEsPzzLnl82ZeEQl0yY3wPjR0yaneIB7OoZSs6XHnrS0vh?=
 =?us-ascii?Q?m9wHS25URuWg1/hGm0LJ84Aa1bDeRdY/A1cCUAiyYyzsvhx7zQJGdxRRyIp3?=
 =?us-ascii?Q?dfrk4H4VoPaDVg+aULvKNrksbgEwkC2SZoSKAd3/8pe45glbAn82PO8cQg79?=
 =?us-ascii?Q?DXouAHp0ff2PuvGStmN7ej5IOTOlxDW3YPRpvD34F/hW+3PyKJw6UNZBgvZZ?=
 =?us-ascii?Q?LCT6lwgq+vq6docmXD2YsYfz2d5dreX+xJZFBkYRtVPAGS5s4Vg7aD1ZzV3A?=
 =?us-ascii?Q?OIHqw0pDAMVQu/FKgEwhTgrjx+CQqBOdBegxiE/l4Ni2wRtmWCUZeFL2jn06?=
 =?us-ascii?Q?P8lJRMUNqXOuvNiTr9s4JyENvz4YftulsYPFOJs4E0JYhHpl38CafiQI3r1b?=
 =?us-ascii?Q?YKD8CN8htTzal5LaqKwNYrluB6jizuAViigfqSsXD+DQ7fe/c2m4+AuPnSvF?=
 =?us-ascii?Q?xa02rGKYZ2FDOovT2UBhOvpBKl4LYaKrauyFdJXRBgBQHpxm1q7FUbF2lbEG?=
 =?us-ascii?Q?zP7oCTEXGvf6uhjzclcauV4OsuuE/ot4FBfI5j5RiU6E+ldXqteypDQQpCws?=
 =?us-ascii?Q?gCH7xi04ET0k3WgKhBMzB95CausdpXQCYSx1bZzFczp8Tqx6yXf+JlA6ZE4z?=
 =?us-ascii?Q?i9tO3XmiFQu4Sk/VydS1EnPapUme1iaawifrZW3y05iGhs3XwsOeqYAi7TRa?=
 =?us-ascii?Q?aKTXhjfFwJ/F4c0s8nOPP2TArKBpj34zz18cqbU4axqz6o+2ELUkP4PROgx9?=
 =?us-ascii?Q?6lQLDuy4WYBYf0BiT3Q=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(1800799024)(376014)(7416014)(921020)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2025 15:45:10.0476
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b585a95-d0d5-48bb-70a7-08dd9a10ccb9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00004685.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB9348

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

A cachebility check is made if the VM_PFNMAP is set in VMA flags by
consulting the VMA pgprot value. If the pgprot mapping type is
cacheable, it is considered safe to be mapped cacheable as the KVM
S2 will have the same Normal memory type as the VMA has in the S1
and KVM has no additional responsibility for safety.

Note when FWB (Force Write Back) is not enabled, the kernel expects to
trivially do cache management by flushing the memory by linearly
converting a kvm_pte to phys_addr to a KVA. The cache management thus
relies on memory being mapped. Since the GPU device memory is not kernel
mapped, exit when the FWB is not supported. Similarly, ARM64_HAS_CACHE_DIC
allows KVM to avoid flushing the icache and turns icache_inval_pou() into
a NOP. So the cacheable PFNMAP is made contingent on these two hardware
features.

The ability to safely do the cacheable mapping of PFNMAP is exposed
through a KVM capability. The userspace is supposed to query it and
consequently set a new memslot flag if it desire to do such mapping.

The changes are heavily influenced by the discussions among
maintainers Marc Zyngier and Oliver Upton besides Jason Gunthorpe,
Catalin Marinas, David Hildenbrand, Sean Christopherson [1] in v3.
Many thanks for their valuable suggestions.

Applied over next-20250407 and tested on the Grace Hopper and
Grace Blackwell platforms by booting up VM, loading NVIDIA module [2]
and running nvidia-smi in the VM.

To run CUDA workloads, there is a dependency on the IOMMUFD and the
Nested Page Table patches being worked on separately by Nicolin Chen.
(nicolinc@nvidia.com). NVIDIA has provided git repositories which
includes all the requisite kernel [3] and Qemu [4] patches in case
one wants to try.

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

v4 Link:
Link: https://lore.kernel.org/all/20250310103008.3471-1-ankita@nvidia.com

Ankit Agrawal (5):
  KVM: arm64: Block cacheable PFNMAP mapping
  KVM: arm64: New function to determine hardware cache management
    support
  kvm: arm64: New memslot flag to indicate cacheable mapping
  KVM: arm64: Allow cacheable stage 2 mapping using VMA flags
  KVM: arm64: Expose new KVM cap for cacheable PFNMAP

 Documentation/virt/kvm/api.rst | 17 ++++++++-
 arch/arm64/kvm/arm.c           |  7 ++++
 arch/arm64/kvm/mmu.c           | 70 +++++++++++++++++++++++++++++++++-
 include/linux/kvm_host.h       |  2 +
 include/uapi/linux/kvm.h       |  2 +
 virt/kvm/kvm_main.c            | 11 +++++-
 6 files changed, 105 insertions(+), 4 deletions(-)

-- 
2.34.1

