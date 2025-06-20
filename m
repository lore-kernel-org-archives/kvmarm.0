Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2060.outbound.protection.outlook.com [40.107.94.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6DC028A40D
	for <kvmarm@lists.linux.dev>; Fri, 20 Jun 2025 12:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750421395; cv=fail; b=jOJiaz4qRwPUlTuh57J5KQUDULvfDU2apKEWytBa2ftFQzILZVoso/pThepe3xRX0CDrVca+QywwefQfOMCcd91+uhAgBsEaRqKrOgblw1+NodNdE+hwLTRsJ3uYVAgRb1TTbn8Nwp1VQfw+KzjuwfZMuNJzoIuSRTC8f9Ov0FU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750421395; c=relaxed/simple;
	bh=UU7aRT5xJcqWCBN7m75VyVocoP7EixtDsaVOPU+2MGo=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=uk3uE/YK3eltuO1gPYoeHBO2E1oJaMG7BX6m3uCITfOg3gN2d3h7FZkGSTDjEGYlaFH5Z5KKXIx8E1KYydLkNTHBs45lwVVvWfD7sxRtAopYkR2DgdN31lH+z9trspv10NgzzUE90tOKyPznjxkrXKULXUQcsiaPb4ZhuUbXhpg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=l/Fl5Bzh; arc=fail smtp.client-ip=40.107.94.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="l/Fl5Bzh"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MuGTStW1+xWUADR9ewRd7croixHr0XO8FsOGAC2OHgXdeJZUiWhuMjwYHmI+6R5MRgKHHLQvXNPbYpFoOHpmDrN/ZIjjPzQpj1GilFwDBIIOupIejpvuATecK9c9BWimsYAfiTvKz6OVSaXMUEJNvcLPl2Uu9B+npp3QCCYE/yGDcNaSEtd1DNn0x/YgIknnndzV66JfVuGuMd2duXdStqRTjCzsTTzmzVQFPR2sQwOr7gvdczPPoG9j7V44K9jK4KTk4Shu/bohkqoFlI9u7T0fCor7Ckib2u+DB1axxdDdKlR5PySeUfz5yK3T5kOtQn5htW5k4QfiHiAhybMy7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f0I97Tz+e5F+JYnG24pF1mcUDS3gen7NrOIvGi0Lhzc=;
 b=ADHpZdVSujyD2UiJlRV/Z3DYHLnlYvH2e4yHJ1f4JWoXRdRWf0iKSom07G6Y+X93HDl0AHCTJKzYpcjrGe4RZn3IEvRcBXHwnvkfT9QQD2gdp+icLqMK6KrW+lQPQKSYIu9cZjgelNEF5YQlxdDT74SArM84cJETFpfgf28/1DjjJW3UpBv0zS5Y6/HGUvGacGNh0N+V9CJiZp7IhmkYL3UH4vK53RFXbi9rxgldgjLgLIjWWVBGg4CDWDooPBESFplG/X2y2bsvst38G1Yi1nCOEzXtxyfjk7BoroFJIXRf0I4pS2LztvdGcryHliAvgRFxvJMKWAkEHYUhREEISg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f0I97Tz+e5F+JYnG24pF1mcUDS3gen7NrOIvGi0Lhzc=;
 b=l/Fl5BzhvJWSt5wxmCrGBt2xrvcIqPUYRy6xDGDI5CgfPEKL9UJFwl4zYCRirkKCjt6rGy1l3Ia/Sa28wJ6onUsPgm9FJ28RzL7LqJVRtBfdOfWfV4U0rOUmuCaVu6VHaPz/RMkIdG9x/TXlIx/Yo65/Ug0I68xX2+yl6wHavGPpXSski0PnHpp9Uub5jWs630EGY/VlNb19Ge6AREYU8tX+kKyuPNhVI3LYDHIoxlXC7pHZCW105YyqZhCBwILd1oOxkLuWnHY5H+nrV15/dM+ax0LJ24CWci+eJxIQXXXe2QcfmSNHMEGjRVfARJDonm3IukOEAQWZbhRl0btPhw==
Received: from BL1PR13CA0210.namprd13.prod.outlook.com (2603:10b6:208:2be::35)
 by MW6PR12MB8758.namprd12.prod.outlook.com (2603:10b6:303:23d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.30; Fri, 20 Jun
 2025 12:09:50 +0000
Received: from BN1PEPF00005FFD.namprd05.prod.outlook.com
 (2603:10b6:208:2be:cafe::8) by BL1PR13CA0210.outlook.office365.com
 (2603:10b6:208:2be::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8880.11 via Frontend Transport; Fri,
 20 Jun 2025 12:09:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BN1PEPF00005FFD.mail.protection.outlook.com (10.167.243.229) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8857.21 via Frontend Transport; Fri, 20 Jun 2025 12:09:50 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 20 Jun
 2025 05:09:47 -0700
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
Subject: [PATCH v8 0/6] KVM: arm64: Map GPU device memory as cacheable
Date: Fri, 20 Jun 2025 12:09:40 +0000
Message-ID: <20250620120946.2991-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN1PEPF00005FFD:EE_|MW6PR12MB8758:EE_
X-MS-Office365-Filtering-Correlation-Id: d94a9223-17a5-4342-5f23-08ddaff35b5f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|82310400026|7416014|36860700013|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?DizwvAtgdFxI6vOVgz1+YugKT3HwuQ/7nTCCsdil3eQpbQ/f3iwjlyjbLr59?=
 =?us-ascii?Q?uXnya9L6reYWCMHcbs3SyEUcZIAXZK5zIGxuRn2u1GQGMV/dRjhXQvHP8cSX?=
 =?us-ascii?Q?HJpvxXVZ9ezR4bmXORHseml/uG/GVnn3eNSWGNN5ijVTorPyes7Ac53o6zky?=
 =?us-ascii?Q?ya0MmSyySQnhnup2yr0gwWQQKPiO7JkyFZdZjoGGrFHayYqpRcTO78+AaHmE?=
 =?us-ascii?Q?qcLooqEpZCyy34rPeLc1+bNSifDJopAcCdNhC23kLjy69rA04p9PKbePFIRF?=
 =?us-ascii?Q?x+JU8cZSNe7UH9i7SIcrtWBz5plSOBxesJUCYsL6tqD7e7apaAIjbCzbyQfN?=
 =?us-ascii?Q?MhsJLS9ThmH+h7VIHDFTG2wpDtoQcezyzuvykaS5IliZ1haj9zQweaRkg9za?=
 =?us-ascii?Q?Y1fVcdw8q6XHPjzvqRd5WobAxTG885OjhAthhMH/Cmq75bKP3gVqHqP7MGr2?=
 =?us-ascii?Q?LKNS2jpVb0Nj1cUOIJa70JCQaKzCKdUEK5mtYTwslrBHyVgZ3qjasdjz2sOx?=
 =?us-ascii?Q?mzTqABhcC19NGPjCUveJZtgoLvGrrGjvZA4BdBIhDPNDHwh+vx4wY1srZgnX?=
 =?us-ascii?Q?AFLV+Mndxjp/Y1R7y4iebFk2tqwFvHIQxj7SamIv4R2nMNL7KcPZPU7rcLwy?=
 =?us-ascii?Q?SaIIEdmxcrbgXAnlPIJweYeplpn1UrJFO+JKEeJYcKXqyklLe2dNhaHhvsyv?=
 =?us-ascii?Q?u3ARBenoKOL3xP15nd+v7S8rxFJrEsiUpfr+L4DDfHmRCCLT6j3lNou+85gh?=
 =?us-ascii?Q?GKRvustwjB/FghsjImrz7nHtJRIU5ixEB3soFSHkoMEuVOmjYq87ZuTQz0Zb?=
 =?us-ascii?Q?MDN9ghd63DOLVMK42jYvzhMONGvqRBC24ih+XIYEFRxINLlZVdcfvixF4R/Z?=
 =?us-ascii?Q?ja3rOdiOhX4g8hwfU9CiztOVQ8xxm4syjENY3VvYkpstpNAzFdZvGs45Q7GK?=
 =?us-ascii?Q?1EF5K6KPMmWxuH4qXQixzK+SUlIwxBVmqEN8abypwtehjvh2ez1PxYOeEcZu?=
 =?us-ascii?Q?KSARWOg/11D5P8PRiqAE14NUQHcZPvUHUcZcx+b5FrG7HqXWhdpxzV+WURdo?=
 =?us-ascii?Q?v44sSZljjcqXFpcij++58j9TlhrpuvSAg0xKCL+SiiPbfplRxZXMo2Ez7+Cd?=
 =?us-ascii?Q?KQ6JyVhT3C90QNWoOKE9c7SgSGdiElJXcYPN3V8TqiYbDntowhK35Jx/5BKH?=
 =?us-ascii?Q?xgZyyY8kAg1k1/8QpcI0e7eyP0wPfw+pOMxu6gA4L4b67HZr/dE58pIT2Yxv?=
 =?us-ascii?Q?O0BtO2FmlpiADfUazwjn0vSUsDZv84MTBbpQHf6TxibCoV+PXF3THKQOYR4z?=
 =?us-ascii?Q?rIlNVQLFLtJBW4KO87R+e9OZWGceFV9PSwCTMQZ1ekmnpSprqc2Nylk5t9vV?=
 =?us-ascii?Q?p3VWY4c7PeDc0Lbz12+VYuuz/6j0UzZ7YEpT8foDqxmyPe/JX/J2dOrFy/ac?=
 =?us-ascii?Q?/nt4O2HboIBSptvMdwfkNTGNVaREUwgNyML/PjKrf09GEUE40jiaCGtX9RNm?=
 =?us-ascii?Q?MEGubjP1k+6g9gHUzbmKLuOCfYugkbQAc/q/0RSIN1/w2rV2zXek4whfm9MO?=
 =?us-ascii?Q?HO920t1wPIL9QKkbEJE=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(1800799024)(82310400026)(7416014)(36860700013)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2025 12:09:50.0003
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d94a9223-17a5-4342-5f23-08ddaff35b5f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00005FFD.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8758

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

v7 Link:
Link: https://lore.kernel.org/all/20250618065541.50049-1-ankita@nvidia.com/

Ankit Agrawal (6):
  KVM: arm64: Rename the device variable to s2_force_noncacheable
  KVM: arm64: Update the check to detect device memory
  KVM: arm64: Block cacheable PFNMAP mapping
  KVM: arm64: New function to determine hardware cache management
    support
  KVM: arm64: Allow cacheable stage 2 mapping using VMA flags
  KVM: arm64: Expose new KVM cap for cacheable PFNMAP

 Documentation/virt/kvm/api.rst |  13 ++-
 arch/arm64/kvm/arm.c           |   7 ++
 arch/arm64/kvm/mmu.c           | 145 ++++++++++++++++++++++++++++-----
 include/linux/kvm_host.h       |   2 +
 include/uapi/linux/kvm.h       |   1 +
 virt/kvm/kvm_main.c            |   5 ++
 6 files changed, 151 insertions(+), 22 deletions(-)

-- 
2.34.1

