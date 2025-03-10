Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2087.outbound.protection.outlook.com [40.107.243.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CAA91A7046
	for <kvmarm@lists.linux.dev>; Mon, 10 Mar 2025 10:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741602628; cv=fail; b=t7w/NuWFdBk+MJY/3vcf1SgTA/25v0dzOuo6C1LWJ6QK8ng+JhgJiwYOr9eRD9OUJvc7CsyoclNfZ9WpYhmlmf788JfWfWII6YmAW4C3IXSBRzptn/kjyIzmfGVkIQOys0ecE9ZGsW3beJx9iHhBBs41qYWl/P/0O3PSLD8ByyE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741602628; c=relaxed/simple;
	bh=rMo7hYzKc/Ka35Iwv6b/WO1LoSeM6kAYPz8K3xygl/I=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=p2wRo13eiSYxUOdZoEi72CbrOXzQ+cgoWKkH99BtKqwMRgYhvZkgDVo7Hib5JdZDUqaNOArNZKPXG+1lzvO6lJnIVzr3twBH8fxSxi1adSp4vGuY09aYGNiH6zuw3iKbtYCXhiAJmoDprNX4DxD2vjWjwmfUUY+uUOKht2akEMI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ITAPRysg; arc=fail smtp.client-ip=40.107.243.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ITAPRysg"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YvwqfUepCXe6YqWl8A64iE2Vmvqb9pJzpQHu5wbxUPYFMLzEL+zvmvRz4Lka8sPeiIhRC6X9zkM9f2/LpOZaCeWSjE8VYmC8GY3eQ+oaeCGhZjLwRN8INYmiDH49VPYWSATfEUAyItjg1LGPVR2vLjVRYQ0sc7nJHVPo8jFkjNW7pe56LIKRGJlNMSo9DyAmfs5oMmYUg4pJd4shc68kkaHcOQ0DllPI+m5GXPh4qWeeMl9xxsK85Fm/iV5orlpBO/MiujrtxPDFYHFzV4B3u+vlRc3p1EDOfR4gwBxHX7JaEYQLnARBPFf60udXhLQtiD70eQ6bhUcXgRv4fRr6kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cBjRbnn1cMYbiZFRuLSoqjhnUs8Os1KdY6aNAEpox+4=;
 b=bo5JPFFSi5jNlKGgkvdqblKlcZQiIhbU4geS7EyYwTUMfffnKlMpJnipDKOi0BEMLsv6sWBrST9a2QfemW9HnT8xcox0yqt8KVz/BZGF0q6xfMD0VA9onJEEzwsp2W46DKBTuHEDLi59219gFpsNHp3FZca7TFXEKg9baZr41oxzeFRQjHU//CbYx6QPVzG7YN2XDuSEyZ4j8iDWRKLfFKTrv/Uz5Wp1HkYMMpnE7B9LaHN0R3pOul+lp4/Nqw47UgLgs5J5ocfQbaQ0r3kwsDEWbd1KzNUpuQhT0HxlHpB86WiNqRnw5tF7OT9HJyWds7+ozr7+0vttqLbQRYR6Mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cBjRbnn1cMYbiZFRuLSoqjhnUs8Os1KdY6aNAEpox+4=;
 b=ITAPRysgGhQh3KJJnIxaPqiUm2kgPDR2NqznmUbIkirBp0566N+1k+76jnW0iz4RcQp49KNUyPhELnksnNlkMlHM8mPdTqsPAfDEaoziZ3MEGLNj+2K9fIraJVZ4fKb8VTG6NvTJwmBYgzJIf5tFu26nfIG2yAETcdjl7VcPSOxtvNrdQ0CycTFlIAQQrO5FsxU06Tpl39IlXQnfx1agkt+4JA9MHa4OPf/5CC6lncIH8WxL1s3lgpvYbjZQiq7+54njV1qYU2SikO10ZEeAbzKUwEZcCHhggyrXoh2BJCdgnPi/F2DWwC1+e2Dv9JFB2VgxqFkoTTUssA9O0UJHXw==
Received: from BN9PR03CA0870.namprd03.prod.outlook.com (2603:10b6:408:13d::35)
 by CY8PR12MB7242.namprd12.prod.outlook.com (2603:10b6:930:59::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.27; Mon, 10 Mar
 2025 10:30:22 +0000
Received: from BL6PEPF0001AB4D.namprd04.prod.outlook.com
 (2603:10b6:408:13d:cafe::6a) by BN9PR03CA0870.outlook.office365.com
 (2603:10b6:408:13d::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8511.26 via Frontend Transport; Mon,
 10 Mar 2025 10:30:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BL6PEPF0001AB4D.mail.protection.outlook.com (10.167.242.71) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8534.20 via Frontend Transport; Mon, 10 Mar 2025 10:30:21 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 10 Mar
 2025 03:30:09 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Mon, 10 Mar 2025 03:30:08 -0700
Received: from localhost.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Mon, 10 Mar 2025 03:30:08 -0700
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <jgg@nvidia.com>, <maz@kernel.org>,
	<oliver.upton@linux.dev>, <joey.gouly@arm.com>, <suzuki.poulose@arm.com>,
	<yuzenghui@huawei.com>, <catalin.marinas@arm.com>, <will@kernel.org>,
	<ryan.roberts@arm.com>, <shahuang@redhat.com>, <lpieralisi@kernel.org>,
	<david@redhat.com>
CC: <aniketa@nvidia.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
	<targupta@nvidia.com>, <vsethi@nvidia.com>, <acurrid@nvidia.com>,
	<apopple@nvidia.com>, <jhubbard@nvidia.com>, <danw@nvidia.com>,
	<zhiw@nvidia.com>, <mochs@nvidia.com>, <udhoke@nvidia.com>,
	<dnigam@nvidia.com>, <alex.williamson@redhat.com>, <sebastianene@google.com>,
	<coltonlewis@google.com>, <kevin.tian@intel.com>, <yi.l.liu@intel.com>,
	<ardb@kernel.org>, <akpm@linux-foundation.org>, <gshan@redhat.com>,
	<linux-mm@kvack.org>, <ddutile@redhat.com>, <tabba@google.com>,
	<qperret@google.com>, <seanjc@google.com>, <kvmarm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v3 0/1] KVM: arm64: Map GPU device memory as cacheable
Date: Mon, 10 Mar 2025 10:30:07 +0000
Message-ID: <20250310103008.3471-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB4D:EE_|CY8PR12MB7242:EE_
X-MS-Office365-Filtering-Correlation-Id: 50a4ab7e-c619-498e-224f-08dd5fbe8ffc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|376014|36860700013|1800799024|921020|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?uT31RF8Pf6Rn8x4Vmazj9HaMuxtG8k31+R4m2TQKeWvVD8JvDew8eCnp34jC?=
 =?us-ascii?Q?oXmhCLJMbpMcCKDsKefUq6mrXXRTXyAV+UM7PtNImSiKmnKEsKaL+1lM+O9L?=
 =?us-ascii?Q?stOiUFGPJ6DUO4Ei9KivLiPhyiBKKBZJ33wiwRcTfz+mOuu4vO+pPGbWmm1E?=
 =?us-ascii?Q?XBRw0rjDYTtWIkuuznMRrj/6EhOXd5GiSm5TUlEa0OfMqv/8JnCyKbQx6fyR?=
 =?us-ascii?Q?XQOy3BrR6eKxOUWtDgDHKpU4ASnrlSUHswT+Lt4WCB+//a9sWTxhgGxCGL/H?=
 =?us-ascii?Q?DV0r4/7KDczbeKaTNSqJ8JnJFGjTur5wcMD5Vfc0AewB/jxNvlXUq/gSbMGb?=
 =?us-ascii?Q?oZnM7IokouHKRPmPOWl1LhjSlwVaZDni3WFhbmX1ze6CY4XS4NNXTDyvEdK7?=
 =?us-ascii?Q?g0Xb+QR2ZNAv0FjMjd9zuudZZxrxWEkVqyKTF/VBfu0lt3FJzGFcsnx2SgjD?=
 =?us-ascii?Q?OwlXO/gatbj6NHcAacTGHIPdlqshyfT/kZfzgV6fOj29o6jb3KM69WMepfSs?=
 =?us-ascii?Q?qAHSpS81BAUDAlTgCYEZoaj7IXhFkOP2k/QGNqJ2kj4BQNCP1qH30W5uqXHh?=
 =?us-ascii?Q?jf6ymEfANZn8CJRgNelQ0NWUcGsNV2hHEiWCXieK4h/Y7610eQp34bwOWg0G?=
 =?us-ascii?Q?Bg94xQTaMDZYJxMXzv7q7e7PMoKb1XP0J1/lRk6AVqhIZUU1IOXMAf/HdAKk?=
 =?us-ascii?Q?mJFLXOKujYalMx7fJE1KX28/vME76T4wc7rYaVFrtfKxlAK/7rEDMOiQxyKc?=
 =?us-ascii?Q?mnvf+lj+f0wpo66IsjG0DTZ5AOEYFdxWNznVVcWOYRqle6Kx/OxDCBCGB1iT?=
 =?us-ascii?Q?y7NnApA5Hz94/qy6nDkykiQe+F13yQNsg0yJ1fZqPJZW1CcGuztZnInbVLWw?=
 =?us-ascii?Q?MUlpq1tcLDGmsqi8jJjMVcPOBewRPI626q+dyBKgGnmJTeLCyG2NJPeRNwGm?=
 =?us-ascii?Q?3rQyAC7sM6rapJ7rnGZmNU/M2UlkcyEtJfbGQK/pykHQkvqzXVK048YX8oud?=
 =?us-ascii?Q?7fKkqtijw+pt4cpgoi03STdZqHOfQLe4Gm8rs2AFgTaScDU9uODlvwujic6d?=
 =?us-ascii?Q?DfMNxip3vnqfa87UwhBtXCmt5HIgEpdv3En3giSQckXWp7QNV4f+k/SEWXFM?=
 =?us-ascii?Q?bi7QQwu6h2193zekwvtVJXnPgknTwpzYh7C/ehLtsm8pYzXonbXNYhCrCO9c?=
 =?us-ascii?Q?xfqk5/M5v4K3RK+0uTNOvdjoOzxx7lsm1jxioAdwQr2bK86GnLJZ5a2DNl77?=
 =?us-ascii?Q?gii0UTlfYqpDEQbpR2FvNjGUK+SvykU0AT4Dz0iPTqlfYckYDgh9JrAkJzub?=
 =?us-ascii?Q?Bgu9Aw2MdkUcnperQPb8PK5HgprRFD3+smoID6AVeyExMatzSfwtY/yjRkw9?=
 =?us-ascii?Q?EQMsjl8QopT7xfc3X87fd9FV8uQhgrznM9IBtKX6OR7k0nVFv0LFr/wAftnJ?=
 =?us-ascii?Q?xBieHNS2lzgHoJptmZWUisMf4AAn1dk25Jx9woSlKkoBm3npQbOKIwpnXBKF?=
 =?us-ascii?Q?JBhhqjwAltem20NQkh9+h+bhp5tv4U4u9dSM?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(376014)(36860700013)(1800799024)(921020)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2025 10:30:21.8694
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 50a4ab7e-c619-498e-224f-08dd5fbe8ffc
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB4D.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7242

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

Note when FWB is not enabled, the kernel expects to trivially do
cache management by flushing the memory by linearly converting a
kvm_pte to phys_addr to a KVA. The cache management thus relies on
memory being mapped. Since the GPU device memory is not kernel
mapped, exit when the FWB is not supported.

The changes are heavily influenced by the discussions between
Catalin Marinas, David Hildenbrand and Jason Gunthorpe [1] on v2.
Many thanks for their valuable suggestions.

Applied over next-20250305 and tested on the Grace Hopper and
Grace Blackwell platforms by booting up VM, loading NVIDIA module [2]
and running nvidia-smi in the VM.

To run CUDA workloads, there is a dependency on the IOMMUFD and the
Nested Page Table patches being worked on separately by Nicolin Chen.
(nicolinc@nvidia.com). NVIDIA has provided git repositories which
includes all the requisite kernel [3] and Qemu [4] patches in case
one wants to try.

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

Link: https://lore.kernel.org/all/20241118131958.4609-1-ankita@nvidia.com/ [1]
Link: https://github.com/NVIDIA/open-gpu-kernel-modules [2]
Link: https://github.com/NVIDIA/NV-Kernels/tree/6.8_ghvirt [3]
Link: https://github.com/NVIDIA/QEMU/tree/6.8_ghvirt_iommufd_vcmdq [4]

Ankit Agrawal (1):
  KVM: arm64: Allow cacheable stage 2 mapping using VMA flags

 arch/arm64/include/asm/kvm_pgtable.h |  8 ++++++
 arch/arm64/kvm/hyp/pgtable.c         |  2 +-
 arch/arm64/kvm/mmu.c                 | 43 +++++++++++++++++++++++++++-
 3 files changed, 51 insertions(+), 2 deletions(-)

-- 
2.34.1

