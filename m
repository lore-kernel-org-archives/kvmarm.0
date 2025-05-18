Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2073.outbound.protection.outlook.com [40.107.236.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 703112CA6
	for <kvmarm@lists.linux.dev>; Sun, 18 May 2025 05:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747547291; cv=fail; b=CV6fi8PHQl/ic6QOXbcIDm85Iqgv84e5ERKhGMhzE92RavCKSbX8e8qabzFGwSy0Wd/Jvy6jMC2FW8Aa6+buxzf9RedVyqyX+AEVcimQ0s9E2WC75amw3cNPL3jdbXRF4rH41jdXJ2a0VZXTEl8GxUzNJEpAaVSiERdiIPP+PC8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747547291; c=relaxed/simple;
	bh=u10kwtIiJXP21KnnWxDVxB8fn0CdpwLbxDmOHJaxeOs=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=uxQBba/syusbzm5lhVigYTVTZshe1p1FOkV1T84wZuZxSs23jLpzXF8y+61gkLMMglliYFEMpYSlFuctE7uNUrMzGayiMlG6MhZZo0dP1Rsc+WK5q/hB9ajzuuTTh/J8kV6moKduAhI2CUBXeZp9XuKQfZ+zVf1qogWidX3Gh5Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=b8ODLuiZ; arc=fail smtp.client-ip=40.107.236.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="b8ODLuiZ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JsR4UU0JtSDjwUFAU/v3CQ0tZF9obW8BBD9Lkh0igpYKYk+ttokMV1XOLU0DXCtpg9srSy5eSxZ+eIV36hRHe7ozUc85WY8MX93txVsQBmJvG8uyQWgSwRt6XXYTl2IR2WPgjLJLYLTt03xz37xN9qr7z03cK5MFqSP1LEpergtmuB42XYSvOLCLqaQsEUjD6pVXdqY8kUNWsdUEHLUfXHwDb4yBnBlLl38C9Bj3zkrRU+A7k2DHug2zi+Mvu3K1/RLIAENdWFJLjomaJWlc4WQuBnwD+A1jx9UQdBikcX2XXwSho//NqLqh0IG6E7y3QiXKvAXv8OKyFHEzRVvz7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Cy6zb66uN3128n9dNhsV++mtrHhUWBuO1Ha4KlzCIvE=;
 b=mWv5DbeERBiBvTwZRXiISEbqA/RPwu6LyN7Sk5EmpJxnQddzUdw7G0A/1wcPr8XRV8x9ZIhJgPm7E7XVe/YRl5nCaVxL9GvXFhy/3STo6kfMy5ui4siqEr1ouRyXibBCc4S77pSRk8OC4gO5q3YrbaG8wlxn92fbb0hqvUk06/kc4cuKZn622mO0t56mMr2paB6LKo0rUyaplPSlBdW5wCE7aEd2qHC5bFV/y9rLyLBf9TiD45Ytm5VM+ZXuDa0KV+nukxKTZFfShYFN0hoIl9dNCTMqUjwqs1dZeYnyBGZjxDCxag4m1tbwUBKaSwqrhNjVDHQyXf3ChK1osoxrpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Cy6zb66uN3128n9dNhsV++mtrHhUWBuO1Ha4KlzCIvE=;
 b=b8ODLuiZEBQAIDvighH/lYJLqknpfcrFUgirttrVAOoX9+Xqk1XfrapBTWSwYcFDRIch0vTNmiTBsbjoiPKAwA4WlTVVszkfE2eSLU2/Swmnxn0go0tkm4ronxQ8CkgikcueGOOFjvCPv+rRhU60hzoMQ3tIH7lI3gD/SKUw4+ftnfGHyPcvC6oCjyUdv1wjcvjVUhem8MvN0oYHAGqKN5Y+v81eVYsbgdwuFNfGGMd1oVk1m50XAiBSLQ5Phd+JRSbuiAB+d5uK84II2KPC5Dxx2yUcTejcYb6gU6rW5anNgCWpgY0DaShMzQOExGO8M5WxyG+w4Ug5HjlNwd1XAQ==
Received: from DS0PR17CA0007.namprd17.prod.outlook.com (2603:10b6:8:191::14)
 by CY8PR12MB7315.namprd12.prod.outlook.com (2603:10b6:930:51::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.30; Sun, 18 May
 2025 05:48:04 +0000
Received: from DS3PEPF0000C380.namprd04.prod.outlook.com
 (2603:10b6:8:191:cafe::39) by DS0PR17CA0007.outlook.office365.com
 (2603:10b6:8:191::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8746.29 via Frontend Transport; Sun,
 18 May 2025 05:48:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DS3PEPF0000C380.mail.protection.outlook.com (10.167.23.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8746.27 via Frontend Transport; Sun, 18 May 2025 05:48:04 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Sat, 17 May
 2025 22:47:56 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Sat, 17 May
 2025 22:47:56 -0700
Received: from localhost.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Sat, 17 May 2025 22:47:55 -0700
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
Subject: [PATCH v4 0/5] KVM: arm64: Map GPU device memory as cacheable
Date: Sun, 18 May 2025 05:47:49 +0000
Message-ID: <20250518054754.5345-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF0000C380:EE_|CY8PR12MB7315:EE_
X-MS-Office365-Filtering-Correlation-Id: c2f6f6f2-eec2-4f4a-38bf-08dd95cf8ee9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|7416014|376014|1800799024|13003099007|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?81TDXdjnlIj7craZXN+kgVIj8vvx4dNkxHZDAGDtsDr2DIKBTRhyP71tSY90?=
 =?us-ascii?Q?u2P8gqfgdAK5p2qF3PV/VEJE0hUZRnD22EkXyzZcNPmbjnnEj3y3/gclxsK4?=
 =?us-ascii?Q?MFRp1ldEBpJDp4M+vfg/S7OFdGvNQxIb8iBoItTK695g87j7cMGFUN7+e9nl?=
 =?us-ascii?Q?8gVUf8hcFUL19vt1t6LMjuSH+X/SB2Kp/SEw12BZzvOawSI2kUmDZq6tECzL?=
 =?us-ascii?Q?ByVbre1tJmDaCA2zLpKhDRfGiH6q+4FxUIWhBYLCYTw93CnNqrVlTcVb8lj1?=
 =?us-ascii?Q?0fbF2Xsh+VZTpdFb2NP8LvBg7v08k2B67fI/1I+8FNUgmjObbkCv1uho7kva?=
 =?us-ascii?Q?l0DNJmZ29zRqt15vHdanOw0dTekxaLxD4xGyeFDQHJFjO7ndsDiENmad05su?=
 =?us-ascii?Q?AnNeG2AwfJqujnRLOERR+s7i8FHpy9C8pq7L9OV1tfe3bR/tSHXnC/WXx4mj?=
 =?us-ascii?Q?Uy6vdOkbNrX5aYC582IwuFWC6/DQgzh5FvtXfy4Q4JO6bNqO3CKJzOzjKHNA?=
 =?us-ascii?Q?3aJMSzqje/M2v0XXgQSE+OqjUWZC1LWBqG7glAJv9hq7/Cn5WnI994k64mNr?=
 =?us-ascii?Q?NNaw7Bl6R4So9Td/PJ+lycPFQ+3IQ9Fb7PA8wNbw1Y3MPkJBTnMxq6ovMMoP?=
 =?us-ascii?Q?bSht1h9lbI6ELy5MtpHnpt+Ad01QK9unU5eW5oxrd3luInWTXgXBubW2fMQT?=
 =?us-ascii?Q?cysvyD7o8iyHXzdrvA1nQ8e4BTAurEGKFrD5jwY0PXRIgrMYN8qKJSUP1M1G?=
 =?us-ascii?Q?tf75pGfdy+YjFsdNBEGOD86mHMX/RLqFzn5d89AoLKyTqybY9dvy64u9rJ53?=
 =?us-ascii?Q?PnMiYGf6LyB9Vx4f/HpEExIGrctfH72SmNn/1hUXe4BwnfoWt3IaUbv+3R01?=
 =?us-ascii?Q?SDNknE5COZ+PMLW5jc3jeU+ZqHudunTFuUWEAriaX1ZaO/eU+x/5GHlvjqbc?=
 =?us-ascii?Q?drLyhIUq4Cbzhi3LN9SG/ylqcGO3HrSCnd6VE3/utrAZpQwI3u8PHdlu6iuR?=
 =?us-ascii?Q?zR7Yuyp0ImhfIwLeaZr4yYNZmpHPYSFBy3FoKbTzlwjU4A7rSlq5IRtd2Asq?=
 =?us-ascii?Q?zQC3qSu276vgm5wEvWYmGTzTTReCo7eOBEy8r62q23jluzpZmzgFmFJjqy4l?=
 =?us-ascii?Q?qU/oqO0wJR2D09vhtM+6B0xu48qKIi76k2SBX1j/2JFVuxXQx5nFXQAD1gVb?=
 =?us-ascii?Q?814hM80fWBkbqEal1lHK2FX8c5qH6+HRSFEY54KW6XULv+b8537cxlcZpemg?=
 =?us-ascii?Q?dYsYqXaw4gDzv07ogrjEMCub4aR/GjdRmHIZbeX7Wan9+F+hFGKFkSmBnTiv?=
 =?us-ascii?Q?ZT+L1pSq3ywAue+iOM6b1jqCB1A/CckPO+hMTtoQ8Zfcb3roDsuenzWv8j/2?=
 =?us-ascii?Q?DYeGYcMaOwf+LD12WMJTs0X2bLKtM4BTCE9j7eCrYlzH79aYnB7hrg0t2B0z?=
 =?us-ascii?Q?OiAj7nFMYPobPqrSfyGNeVNdPZIJRgGlfPn61FfzwblbHWifD+xp4+FyAQ6M?=
 =?us-ascii?Q?I3SYQ4dgU3qX/ykJbXHGPV51xgT+KM32onZDo9kWuSWxsuxb3TDJCNSTQsgE?=
 =?us-ascii?Q?UxZQ/4xpAxB0Ly8mj8o=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(7416014)(376014)(1800799024)(13003099007)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2025 05:48:04.4311
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c2f6f6f2-eec2-4f4a-38bf-08dd95cf8ee9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF0000C380.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7315

From: Ankit Agrawal <ankita@nvidia.com>

Grace based platforms such as Grace Hopper/Blackwell Superchips have
CPU accessible cache coherent GPU memory. The GPU device memory is
essentially a DDR memory and retains properties such as cacheability,
unaligned accesses, atomics and handling of executable faults. This
requires the device memory to be mapped as NORMAL in stage-2.

Today KVM forces the memory to either NORMAL or DEVICE_nGnRE depending
on whethere the memory region is added to the kernel. The KVM code is
thus restrictive and prevents device memory that is not added to the
kernel to be marked as cacheable. The patch aims to solve this.

A cachebility check is made if the VM_PFNMAP is set in VMA flags by
consulting the VMA pgprot value. If the pgprot mapping type is MT_NORMAL,
it is considered safe to be mapped cacheable as the KVM S2 will have
the same Normal memory type as the VMA has in the S1 and KVM has no
additional responsibility for safety.

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
Catalin Marinas and Sean Christopherson [1] on v3. Many thanks for
their valuable suggestions.

Applied over next-20250407 and tested on the Grace Hopper and
Grace Blackwell platforms by booting up VM, loading NVIDIA module [2]
and running nvidia-smi in the VM.

To run CUDA workloads, there is a dependency on the IOMMUFD and the
Nested Page Table patches being worked on separately by Nicolin Chen.
(nicolinc@nvidia.com). NVIDIA has provided git repositories which
includes all the requisite kernel [3] and Qemu [4] patches in case
one wants to try.

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

Ankit Agrawal (5):
  KVM: arm64: Block cacheable PFNMAP mapping
  KVM: arm64: Make stage2_has_fwb global scope
  kvm: arm64: New memslot flag to indicate cacheable mapping
  KVM: arm64: Allow cacheable stage 2 mapping using VMA flags
  KVM: arm64: Expose new KVM cap for cacheable PFNMAP

 Documentation/virt/kvm/api.rst       | 17 ++++++++-
 arch/arm64/include/asm/kvm_pgtable.h |  8 +++++
 arch/arm64/kvm/arm.c                 |  8 +++++
 arch/arm64/kvm/hyp/pgtable.c         |  2 +-
 arch/arm64/kvm/mmu.c                 | 54 ++++++++++++++++++++++++++--
 include/uapi/linux/kvm.h             |  2 ++
 virt/kvm/kvm_main.c                  |  6 ++--
 7 files changed, 91 insertions(+), 6 deletions(-)

-- 
2.34.1

