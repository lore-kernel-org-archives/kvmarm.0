Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2041.outbound.protection.outlook.com [40.107.96.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CDD12749C2
	for <kvmarm@lists.linux.dev>; Sat,  5 Jul 2025 07:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751699858; cv=fail; b=YpRFl+JAPtpZcgZCBF+qNFa/4ml5wpZQeNksUjGrmL20zS/7g6d82yNvUDSNCYMu9Up/GjzrG6okTIxAhJVY6Zr2tOiobesnMNjd3H1S6mU9IO5qoudpM8WCglEln0c8F7JObd2AUP/sMrv35d9YhNHxXbZBFbclIEo1o3WBC9Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751699858; c=relaxed/simple;
	bh=4N7TfrbtSC0NurVCPo2zURGVo/AP+kedQJm8jDUD7bM=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=kVvwuoH7s7J5e61Sy8pNFhFqYRfiiE46/yXfDwSBgp1y/4kJ0SXwnkIaZv3E+T8XJGJ2StyohWnRWp2W/cGgDINsp3ASh0hLCAlvOOS5r5if6QidnqJ9sn47ZuRulyuAVoLr4SDgx60jx5BKv3GfVydoJ+DeDV0MkGkRvCiW83w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=k2YYtmrF; arc=fail smtp.client-ip=40.107.96.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="k2YYtmrF"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XtX7ze1m2G10l2ApN1LpB7REDv3vSu/CwfvTXC5kihaNQXkq24OXIST5VDffgTCpzO9KgPPzQ0EUfohGV5zcqqLi1cXjcmoltk9WeNJC9p14ITw76NmOqgloPuc050KVI3VWLyzE4SF0x2BdogEO8QLwNqma5RfSEnP41auJZEaAaTW928DlDIPInHVAw92vvW1PeoxzhyTR2NX7y4kMuMoFEYYsCwwtsgBJyAC2N+wpgjdHGJasIAL0w+CeQa6cV9j1G2cMu33trytKedbhqAoetL7a9WXYjTziGmnJr/X71LAIRnADblwlFJls/q2nKWXWXI72VkZpLdMAmeFlqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6pO2AnmF2IHeUS3oTGhiHSB9u8m1mmATRh5C+zY7RBQ=;
 b=iw6bkymrit4JZ8Hrtagr2UcB7Oy4jk87vpizm3WLOfLG7bRGbvYG8jcJmHLWAngllVETvjPGELJydNKXK3laKndw0H4jm9+vF4kyzJpEdmdiwVmNyDeVNOQEb/edervQa7ZjMr82s9yHhy5ddpLlu0gQwNfLQim465q9rPcddcQNYVFAr3G6NYFPgIK4NAnBD7H0Edmi6oxqfnz/AV8Ii2QtrfpgL8lrzNJcYAcDKmE7rWE3GT0Z6co+NSNcrwU0maVWt02ms1fP/7h4OZaf4W+sK8emfAVKFXPeYbDwedhXPdU8a+j/aHICR2RV9X68rB5H1/nQrLTrB/PbGIj4NA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6pO2AnmF2IHeUS3oTGhiHSB9u8m1mmATRh5C+zY7RBQ=;
 b=k2YYtmrFvrIbd6hqJ6v8F6Alub4RveNPcp4zZ3d0CVfq74omHjual66Lmcs3Vi55mOHJoUsywH/GMRGKTNN508YZifdC6DwCYmfmeJuNhpayrlKT2bCHbbl7uhrZYoDSEzJHb5RCMZWA9yngbNBxIFj5NbCamwiu3ejIV/+vS5PL5opMxRRgfNujn4RCqAvCr5eWq+2aUKqEcUlkrIGNT9A3cxfO9SJOtLCRb5WgSewvdTR9vArxeXJhijyHGl+iufKiWMg2Ic6M8J3/DBO17oTVwv4VPozVvwHNbMOqRfuWtKsmFC1w6gREq8Y7eFXxcKutUQaPoKtZkBGmJTwVPQ==
Received: from MW4PR04CA0055.namprd04.prod.outlook.com (2603:10b6:303:6a::30)
 by SA5PPF06C91DA0C.namprd12.prod.outlook.com (2603:10b6:80f:fc04::8c4) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.28; Sat, 5 Jul
 2025 07:17:30 +0000
Received: from CY4PEPF0000FCC5.namprd03.prod.outlook.com
 (2603:10b6:303:6a:cafe::d8) by MW4PR04CA0055.outlook.office365.com
 (2603:10b6:303:6a::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8901.24 via Frontend Transport; Sat,
 5 Jul 2025 07:17:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CY4PEPF0000FCC5.mail.protection.outlook.com (10.167.242.107) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8901.15 via Frontend Transport; Sat, 5 Jul 2025 07:17:29 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Sat, 5 Jul 2025
 00:17:19 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Sat, 5 Jul
 2025 00:17:19 -0700
Received: from localhost.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Sat, 5 Jul 2025 00:17:18 -0700
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
Subject: [PATCH v10 0/6] KVM: arm64: Map GPU device memory as cacheable
Date: Sat, 5 Jul 2025 07:17:11 +0000
Message-ID: <20250705071717.5062-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000FCC5:EE_|SA5PPF06C91DA0C:EE_
X-MS-Office365-Filtering-Correlation-Id: 334f9c6b-f1cd-41ef-497b-08ddbb9400af
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|82310400026|1800799024|36860700013|921020|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?pZP/S1I2TYAU+OxTC0DHweDSSfW5xZTcr5KBaVM77G3Rx/ra+OkBGESRIOKi?=
 =?us-ascii?Q?707ZaSKyngJA91mbq1j5n2r7GRjbc5C0PLzMTuTcTCbYaVJ0h11UURKJokyK?=
 =?us-ascii?Q?7g/ZS7YXsMspi4+RAgv7q1J6I765NI0EpGr/qJc6ZLP2xjG9IobafcYfXBPO?=
 =?us-ascii?Q?Qn0CkLJo3+OO3aSanyRe/hIrj3Q54iYV8/We5oFXP6dv0GTPtK9DydjJuC92?=
 =?us-ascii?Q?66ZJhDNZzohwtV/wOgnscwEZgkNvC0/+FvBe6SvFH01pcfJQIRho+ID6iddm?=
 =?us-ascii?Q?QMVHaQVdzazDxAbkgq/v3lDJTnf1LXEBFbFkVNIiLLRzMttF0H8CiEBDekdx?=
 =?us-ascii?Q?0Knfa/fMCiJojJTTDZfvw6tfvhAp4ZTTx+D9WJ17jNYilEr5jbNAeeQm/186?=
 =?us-ascii?Q?W1jG4yYc4v6Qou1YFIT3v6RvQCFRijQBBn2cITZ7oQzYlrvP7mIpli+mdhja?=
 =?us-ascii?Q?6PL+37SC+iWFgSNA6wWH0wllzf/bv4rBx+j9QUY6cHdbP1wv7Hjw85zhG2gL?=
 =?us-ascii?Q?xcysqlgR2grzn7cu6WxRdLQzulGeg4KgScpdLsnDlRgfGsqhqRdRewm4iF/9?=
 =?us-ascii?Q?o5F9HLXO7F0HoGPrLkmYFchzFpQP/c07+Eqt19HVRppZbmoErXxSSmHq21+f?=
 =?us-ascii?Q?OUdLd59p35W6P2Lfim37FaOfk7oFvcBU3BnREBXMfma2/N7kf4/4xn30qj1v?=
 =?us-ascii?Q?byZ1UDZzpHxgd6b8UacVayu8MavZIygI/pw8t/C2UOlJBknI9ojYZhLQTVrP?=
 =?us-ascii?Q?CCDWZBWi+mixyBK0pFkBF5hxqobjL9azQBCAzt3el6uUN2q/EZemItbx7baF?=
 =?us-ascii?Q?nOS2oMa2DsxZOOeTN/2Np4qbAyyGqCBm6hDKbQIDic1lB7jU+ClxIUlO3Kyk?=
 =?us-ascii?Q?Parfr/NRouVlGKsTTElPd32lw7A3yVMocc0yNg608nxZp3k/J7RzLWxagjmC?=
 =?us-ascii?Q?8f0sDUTU38FflM5dbpfPRjoMAkw9QYca9sknQNLtCvyJScyGn0v5AwK006XW?=
 =?us-ascii?Q?ObDwNiYThkkDJvQbCJp6xJvzshtNXxCFV7rMWkTGWclZqMC/D8oPee0RXG4W?=
 =?us-ascii?Q?5csOUCjtpIC/RTwHW/6f6CDZE3zwlKtP6CMFqa2HhWEQRv2CpQjj0NJAPVL8?=
 =?us-ascii?Q?IuBdWZv0Y37+E6Jwme7fFGYZmB2tjxbfTcr7Olk+VI3+hUU2XAhphxOmN94q?=
 =?us-ascii?Q?waFnu95JmGq+m9R+AOB4S3z2F4VaRcrXfJdjSY7DXLprZaSrefYAxCq6IGsZ?=
 =?us-ascii?Q?D2obHs8+on6IHt4+eFk5anMRIzJRC66fJDyrEn5X+2FvUOwSSLBZsX5sTIgk?=
 =?us-ascii?Q?qvSM0oWm15Y18JG2O6/0eByzzdcdcoz3PUDQ0OMmfV5+3Qu8ht5dL1+RLpRT?=
 =?us-ascii?Q?zocmFwjRFvTFgL6ugv37NQEEkNKLT+9pn5K7K6aw8s7WJNc7b0PUqMnKsspJ?=
 =?us-ascii?Q?fg+8rY/0VncOnMrbinE1ca+3jGVvHhw1e3oezbbTGtinW7hSNEFufBUwOk70?=
 =?us-ascii?Q?cPEfXZ4JKUi9lRRUwNyKCI3fJSbQIliFfLMS1o2x4lDPbwmST8Nu5YEjrGRQ?=
 =?us-ascii?Q?41g+tkGJHhHeqf4MgQg=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(82310400026)(1800799024)(36860700013)(921020)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jul 2025 07:17:29.6881
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 334f9c6b-f1cd-41ef-497b-08ddbb9400af
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000FCC5.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA5PPF06C91DA0C

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
thanks for their valuable suggestions. Thanks to Donald Dutile
for testing the patch series and providing Tested-by.

Applied over next-20250610 and tested on the Grace Blackwell
platform by booting up VM, loading NVIDIA module [2] and running
nvidia-smi in the VM.

To run CUDA workloads, there is a dependency on the IOMMUFD and the
Nested Page Table patches being worked on separately by Nicolin Chen.
(nicolinc@nvidia.com). NVIDIA has provided git repositories which
includes all the requisite kernel [3] and Qemu [4] patches in case
one wants to try.

v9 -> v10
1. Removed dead code in 5/6 (Jason Gunthorpe).
2. Collected Reviewed-by from Jason Gunthorpe and David Hildenbrand
on all but 5/6 patch. (Thanks!)
3. Collected Tested-by from Donald Dutile (Thanks!).

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

v9 Link:
Link: https://lore.kernel.org/all/20250621042111.3992-1-ankita@nvidia.com/

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
 arch/arm64/kvm/mmu.c           | 118 ++++++++++++++++++++++++++-------
 include/linux/kvm_host.h       |   2 +
 include/uapi/linux/kvm.h       |   1 +
 virt/kvm/kvm_main.c            |   5 ++
 6 files changed, 122 insertions(+), 24 deletions(-)

-- 
2.34.1

