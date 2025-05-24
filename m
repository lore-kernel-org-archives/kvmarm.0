Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2070.outbound.protection.outlook.com [40.107.93.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A3BE14E2E2
	for <kvmarm@lists.linux.dev>; Sat, 24 May 2025 01:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748050806; cv=fail; b=qNncdOKcMYCJDF0qIPuqTOjoMsw4Q//SePUhsGW+41ONszguMvfOeNOyemXQJK4S0Xy5z0GGUz4EeVEnblzh2U2TtfYbg7nltCIz+Xh52PtuadzMKNArgPKYgeJds5CPM0DBsx4wzlsaYy2vJzzY2G/4jTl+Txfy6kKRZJEM/LM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748050806; c=relaxed/simple;
	bh=pXHqVcMwOsBE6Vr17A85TQwgKbOj17sCGJQSrprH2NI=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=UMO3vCF80m8UisSV0574MJiWO76qNPzMT0+ph/5cjc3q6Fx7ePFz5EpYabOhudFfDLBiraaco0J7QZYP4a/6OVL0rY+ySSgrlEvFBkmFrNLwPHHFuMTyvHWhZrGl5/XTac0RtW+gx+KiaDuU9LDZ4VDSGnL+b9S9ovMZNIFLDxk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=pOR8gPkm; arc=fail smtp.client-ip=40.107.93.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="pOR8gPkm"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kxKYFLq/nmA/LrSitwHdAfq3m/N5FQUPdegUxKLfwJcaZukJkCT9tIGyUJFkKAjS+WefF2EdJGfG1DM+JCTFBdSgi7Z5GW42BxF38/XLJIVmJyi0e6PPfMlzsizc7Z0ehKpTFEtij3Hkrlj8XK3rx9LzDuV7ynyE6iRSXgL8+A380/VEfdRfzXTB4jcnJrx1I7U5wbjo9PqnOxUGT+yW1MxMrgjlv49eF/8Ny/YJS6UcXJv6wWCsXmEbK5weEQacyPUt17eBp+eNmxIbJkruinbQryoEYVFH+BJrg4YtiJ2pjJ+sxBF9ty00pgkFSLPuecirknuQCSA9YepaBeCDlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Li7sNzQGl9tVZj5oyEKzHBhs9+kEpTCJSgF5LtlqWs4=;
 b=MdYKolaDuglB0YkBJ2PTPzjgAq87LTy2tdS6z5FTfR0c5xx8PTDacCWMInNI9AzE6YzLq9zdlwJRTDlXPBXrrgQkR4cDqvUku2Yo5HdWljv1rCoxRNYZdpwvv40odE8K8d2KZrDWBPz1Hyxn1H7OLdB8UVn3wTV3+HOkDcwQOmGkYkHfEvkA6cceFbUtSqoIy2Y0T1X623YSUurXN66HuqLvodCWYmONj11UDuR3rFkMv08OdyvJjSGmpHIOmaK4SJNmMKXQx+GGIn3oIu8r3uCs91ORpA0nLcfP/VMmD9/sDZFVEwEbPAFuBBaYuqUM5QHcc+8fWPG1pUJzRajhFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Li7sNzQGl9tVZj5oyEKzHBhs9+kEpTCJSgF5LtlqWs4=;
 b=pOR8gPkmQeRsmRcXKTLnEcE8E0mUruk3HdxN20Y2vfXRDfcw6+wlXJChXYvdI5mGWI4PijDFGhNR/19gEJHjfH1HUnMBoIU1jfSWf561t+npfTcdx5MBF71yAm78HWr9aipeY40xVPclUQ6IkVBSYoh2Pgem8/i/6owMH0HdusOi+Ly/o0t1I6392da0JOme9MEXTuMoZj9Q33cOELW8V+5gujOv89t+Nt6OJFbwIcp/skt/n+clGm9hRf9bB+7Rc1bmx5AQsWlGYC6eC8e9l7ykyznmGz21tZTPdP5USQah/N3fP/Pf5CZi+Xv9etZo/2gLoQ6PuN8IwiVuMb1x4g==
Received: from BL1P223CA0039.NAMP223.PROD.OUTLOOK.COM (2603:10b6:208:5b6::10)
 by MW4PR12MB6873.namprd12.prod.outlook.com (2603:10b6:303:20c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.26; Sat, 24 May
 2025 01:39:58 +0000
Received: from BL6PEPF0001AB78.namprd02.prod.outlook.com
 (2603:10b6:208:5b6:cafe::a8) by BL1P223CA0039.outlook.office365.com
 (2603:10b6:208:5b6::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8769.22 via Frontend Transport; Sat,
 24 May 2025 01:39:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL6PEPF0001AB78.mail.protection.outlook.com (10.167.242.171) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8769.18 via Frontend Transport; Sat, 24 May 2025 01:39:57 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 23 May
 2025 18:39:45 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Fri, 23 May
 2025 18:39:44 -0700
Received: from localhost.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Fri, 23 May 2025 18:39:43 -0700
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
Subject: [PATCH v6 0/5] KVM: arm64: Map GPU device memory as cacheable
Date: Sat, 24 May 2025 01:39:38 +0000
Message-ID: <20250524013943.2832-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB78:EE_|MW4PR12MB6873:EE_
X-MS-Office365-Filtering-Correlation-Id: 936ce884-4186-4166-18a3-08dd9a63e464
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|82310400026|36860700013|921020|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?PY57DJjBEwi06LIZ0OW5AiuRcjNjPNgOpUG8HxV54VeUpxKHkQrWABYdKAow?=
 =?us-ascii?Q?5ds0+VmUBADYgTWZivaGa71ZcZFVfQClPurvdUbupk23dd+d9icnmQrVvSba?=
 =?us-ascii?Q?BOUDE8Gf6u51beInzJSYHyl9iVYIlEDgaKl+GURd300BqEx7R0dZT5dbCX8B?=
 =?us-ascii?Q?MQJkBbvw7S5VaUPwIpurBkdozKNJQsE7LuR2cQURDnHY5sB85e0J80nATmUR?=
 =?us-ascii?Q?ZR1H+K3CZBkv8ZJ8NJXxytYIaLjCTN9RIXDT3c24L7qDE+ttBMhfKq8unJUH?=
 =?us-ascii?Q?pIINzgHCVDuF9lqq132GOFSLE4o17P9Mj1G4ciMWgEaU/Rzv0teDcRbOeuK/?=
 =?us-ascii?Q?EVKzFYMMSUUejEXRAYZBPI20RHKcln3jMpR9tZLJyTnWQkUHzPumaj6f2+IO?=
 =?us-ascii?Q?6sN4hcveEuQd1BYffk0re7AISnUSHAlN2r1n4pWqsKHgC730V2FYWdho0dvI?=
 =?us-ascii?Q?8OuRHtw0yBnt3Od3Vr9F/yVxXNFlkwCDrcVl6mj6EnuQhvVBphnPgJpZvV/d?=
 =?us-ascii?Q?1lMjzkF3uC6qBMbtdquxphj+Uz3BSzCtHiYgL173GnU4fKs4fEmhajngV9Fz?=
 =?us-ascii?Q?SI5nMNo00GvHt4HISK2HCcy6LCjVQqCA2B/zuKQt64heanh6yYB8bGFuHHPR?=
 =?us-ascii?Q?5wLz6AaCiNTeKC9rn9OsIfvGXqjPuXgMmZOqV6dhXwwa88hGd3IsW1Nx8Nu3?=
 =?us-ascii?Q?MmfRyhXZlGe5ewuC9KVSP1xR6mk6mKR6KJwe5htXj0OUuvxsqqrKR2aUI4ON?=
 =?us-ascii?Q?dK9kcktsrivZs1HmSAlNdkKospuv0dXzjgxZozghU1rEgjlpecXiXnhArMho?=
 =?us-ascii?Q?RnB5f6VRjTQOLgoFeUqzI/l9znbDjBKzgyyb5xjPrQ/1pbuLhJP7THKOfXqs?=
 =?us-ascii?Q?gCl31GetPvWUZdwxIiL6Bm8lHTtpjr00cUSEbUvX7FKUGtO5LbtpTaIXKsx6?=
 =?us-ascii?Q?jwgyZrGdwUUcgB/ntYFrDMjjQG6Qeh++97AyUQN64H3inOvp9/L8sU7lL2J7?=
 =?us-ascii?Q?fgrH8CgK9H7oZLzB+tV/UVtccJGotc3UkIdfYU13smhfyTw+7MwNAiuQK1o6?=
 =?us-ascii?Q?LnOYeQ1PThuwo1QjoCpSYGorS3mPNAHfoyPKBZjPOLWA05yXgtZSBUOIMTS2?=
 =?us-ascii?Q?oGyiPdfBi/eO2NVIkoZzNHL9Mfw/ZlQ+gL3yGWR58Ck/XwwBj9beriLnCa5i?=
 =?us-ascii?Q?HFZ7jj9alMofj1h/gsHJOU9Upg+PKaQ0N4G0TdmsDSe5jDmn9li1zSSljZIt?=
 =?us-ascii?Q?P1ZRBFu6+3q5RX9xOYkguRQx3i3Y0NousIzhX8KYgQ/dByaNNa5KF9yfZ1tN?=
 =?us-ascii?Q?7Y7aAvqt96tlaCvDhKBkuLnqvS8nHt0m2nfiEVUZ62F7s8JvZKjyZWjpLog0?=
 =?us-ascii?Q?SKuIoAXkTv5kxjvaHzk7t3ODLmfl6sOo5KfeW7+E66sf+OotZx5br2xxBvH3?=
 =?us-ascii?Q?b40k0U9COTm7dE/mEoM+3jl7KhCpqX7/0t0ZLaxQgSbnlnwJ8HSnY76KCLOP?=
 =?us-ascii?Q?081Gtu1iw8lDKzbJfY2Z9S2FjftgFr6Yg+F0B37ogHpkGDdAn4WS2wqEKlVM?=
 =?us-ascii?Q?Lzu/rpVcLOLry06owe0=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(82310400026)(36860700013)(921020)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2025 01:39:57.9769
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 936ce884-4186-4166-18a3-08dd9a63e464
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB78.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6873

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

v5 Link:
Link: https://lore.kernel.org/all/20250523154445.3779-1-ankita@nvidia.com/

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

