Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2044.outbound.protection.outlook.com [40.107.92.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FBE019F130
	for <kvmarm@lists.linux.dev>; Sat, 21 Jun 2025 04:21:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750479693; cv=fail; b=ARtf2XjOcdKTyptgmiRsZrIYf6bE/GT/b7gczMc2Cb4iizT0m2V+l5lY2z7FK9KzSDBYsD7/q7J4wxVYnOKlbY5ygYilYJi2DOnzKDnjH3r6/bUARuZpPzI4/ShLtRUV+SGM0sRNBwQ7m8jGqB++G+BY7X0S2NKM7jMgS04Bvi8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750479693; c=relaxed/simple;
	bh=cZ5atSUrn1I2RJcTv984uqa8Cc/hYuWLGMOADbBuZmw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Fh7ltmVbERZy+oEhhcV0Tvsbcup199WPazalurNvjAQ4JxogpD/jl8p1NdNe0NSBzgCAPAK+sOrDoUTWA4L0QAAoz4qHNmVFcBmYaDBgKlBhAzgwE5MS4B3s7DQx10PngnoxrIdtGfipHUZ2Hw1QKLan5GHSr+i3HcJAR7g+gOE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=lEG7AklU; arc=fail smtp.client-ip=40.107.92.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="lEG7AklU"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ymliTTkXYLzRyf00J6BU5YXUZ5lKoHVZDwUC4jejHPhX3F+sV09VqgZEIKNja4gln9MOoXyeH7V0cYRDiu5uqDjPFkXURIn2iAsAN2GZSPtxx/zR1IrPVpBFEwX9n1GyPne4pe+fzIE/DXvTxUUVUMWDj6ItRMZoCZrci1UBb3d4Vbx6JLHemF2E0L0Es7lMRyD6v6KLwp6Hm+v6/0dm7Cci5fehpIvQ1AYbmSOp5qsOHZgYXI4NGKukGiiCWL8FaGuPAhjDq2gYAuIZ6VROHHc+0nCBakwRcxkQot4sPdxWO0ru4HU/grgse+1ex0iIRDyp/XlFT88uTV9wf/tsVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WJcob8QYfo5hlHn0Ev0TZ2EMAwugli1iZYAf5iub76M=;
 b=dHuGeZHdCrPFv1r2xG8mzVoZ8aKTmXKff+Q/LLhWUxNzX9+Y/Wi7m+Ycsa7r/L9Vkm2480hWj+jzcKRpYHr9pETTkH2Fl6XGM2WTsgUWAYuHoK3sk1z4SA+Tx9l9Er5DmwysbN2/qqrJ9Un01XsF7vR+4mpA1duCDko0xdKhw+qLQYGhzL/J5ioIedYilKPVQJ7tt21YOwOE+KdeIbrpVNYIMgnGnPgZqMT/hA7rUwfiLIBSaXEdUQyo4SiNTCxKAsTtpPSaKQwv47rJBNLtcKSASqOLSB+vjj8fPb9UHQ5yczWXct5AbLccEkSiDE1bGKKRxa3PiC9xbl58JPr/KA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WJcob8QYfo5hlHn0Ev0TZ2EMAwugli1iZYAf5iub76M=;
 b=lEG7AklUf2ckzhoNUCjZ0fiO83lvuNbGKDEaMO9PfXjXPzUUi6klsB8fbSaVQiI7qTbJYxMMbYuooWlCmFgp2qcpys2uxCWkdNK6JdCTbrRsnRCMDn7LKc1yjZuQM7CjYTlN+hZvANxHehra2qiFnuia+d8yAHrlcrHTRIktuGLgf8XzCDlBYUKXETVUn8zlq3TgMojcK+lzh7zIIhscPYZnsfWd39026H62OMSLk++Qe08bUmlI6EYoLL9/OMnpAIr84rXRpRFeKT+1l2/P3ZGNw2ZRvmeTUW+C2pq6+p7hsGDvis4ve9X4+DcKBIVR31FLQProCWlISAPaW2+ypw==
Received: from CH2PR14CA0038.namprd14.prod.outlook.com (2603:10b6:610:56::18)
 by DS0PR12MB8344.namprd12.prod.outlook.com (2603:10b6:8:fe::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8835.29; Sat, 21 Jun 2025 04:21:25 +0000
Received: from CH2PEPF0000013F.namprd02.prod.outlook.com
 (2603:10b6:610:56:cafe::6c) by CH2PR14CA0038.outlook.office365.com
 (2603:10b6:610:56::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8857.26 via Frontend Transport; Sat,
 21 Jun 2025 04:21:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CH2PEPF0000013F.mail.protection.outlook.com (10.167.244.71) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8857.21 via Frontend Transport; Sat, 21 Jun 2025 04:21:25 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 20 Jun
 2025 21:21:14 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Fri, 20 Jun 2025 21:21:13 -0700
Received: from localhost.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Fri, 20 Jun 2025 21:21:13 -0700
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
Subject: [PATCH v9 5/6] KVM: arm64: Allow cacheable stage 2 mapping using VMA flags
Date: Sat, 21 Jun 2025 04:21:10 +0000
Message-ID: <20250621042111.3992-6-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250621042111.3992-1-ankita@nvidia.com>
References: <20250621042111.3992-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CH2PEPF0000013F:EE_|DS0PR12MB8344:EE_
X-MS-Office365-Filtering-Correlation-Id: ed5e89f3-bce4-4bbf-20ed-08ddb07b1644
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|7416014|36860700013|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Lc19nwvt/DEKAM8dXygyOKID5wi8w28BheC4i35UyJwJQvIHFqNZG1WGMChC?=
 =?us-ascii?Q?u1sdElFBuFl+i2bSxOAjOXzy274XjyPXRRpsQjAYp3+//Llt1R8RSsYZedH1?=
 =?us-ascii?Q?4Uz37G7CWDQe3OZGkVHkp9+9GR3egwyAhPRgAn31OuBqOSkNjyVRYoi/jVS9?=
 =?us-ascii?Q?FjCwDoHlZSq64E6lxLdi1JiFgHaHR9+Pv0hNHwlA+I33Mfvu4buIzMi6aCRK?=
 =?us-ascii?Q?ZlXwYGIOwYAPxrvFTkKZ73IAGSs+62itl04WcK5kEuX+e5+zFvfkOk7EhGiB?=
 =?us-ascii?Q?M2VUVGL+PpsrFlE8AXdYxnQtQPk48lx96wiThOqvKOIPxwXwofMLkM1HPfh/?=
 =?us-ascii?Q?xi2Sb03QU80tQBEEJiUnrr1NPKm1nrnesO/Hq4UfGIJETnz0mEYceadvukRz?=
 =?us-ascii?Q?otEOew8bCJ+eF0VgiSm7zITWNRK6jBuumKnPCohOWiKkW/jYtQX0m4aK/ps4?=
 =?us-ascii?Q?VRqPNPTJheMEX4nDK1j7cnhM271w7Ng9Gm0P1A8SEm5uMqSMK7tRPABL476r?=
 =?us-ascii?Q?SBfbyN6I3Qn7eQZi6Kabvfo6LKqxjy0A3eoSYHiJ77EOXYA6WYM8CC0k7lZz?=
 =?us-ascii?Q?hcIoA+OMf5xlujgeBXGdnBgbhtKsKGIoj48FQftI0kpAswYtXqK0yLhjt6K2?=
 =?us-ascii?Q?C/J7qB91RitUOjT2/iDpDT7d24WcralfqdYUJld2CtHr6Ws1D5RzgAsXSF8V?=
 =?us-ascii?Q?dsHtKTzyC0p1XQixxwXIQ0EfoLGDbWSMvV3i7LMuygJzpw5xDn/wwZJMGxfT?=
 =?us-ascii?Q?z/h178tJcE1wTbSzRWOSLwVvW54/nZFjC9JLKLfykkwVAQIUzWhO5Pa2gw/D?=
 =?us-ascii?Q?zZcLEj8RUzEZ08KW0b5suVkbIwTqxpUPh/lBzBrpd2+yOiUK8RNEzHLIvG7W?=
 =?us-ascii?Q?kW+xgEpDx2v/gN0B93Pg1qV1tKWmFbp0uP4UpLvIQpJDEZH8xvbJbhaGtYyn?=
 =?us-ascii?Q?hc0Znzwf9wuTsdWyACWg59O+oVthQGHP9XZETMAv418/ebRqHZPKO6pV26Aw?=
 =?us-ascii?Q?GW9ZU1Yhs74DBxoGXWUNglOQ2bJ/V3z+cZHZv7o2dk7CdO4JIyXVz07omHK4?=
 =?us-ascii?Q?s8mjYOih7pmSKFBkfAXvzYuNtIktQTo4GxGA7Vxv23XiFecLP433dkLwt/jU?=
 =?us-ascii?Q?vD4nny5ZtpC7HF62ir3YhK+iod1qJHYTpUgaO7MXC5IK1fK8srHYAez7NxBN?=
 =?us-ascii?Q?w0XtJhOzoP0myWoN+XOMce8WceOcv4r4FjfSaqyye34pfJLDm5qUsk6jWYuJ?=
 =?us-ascii?Q?hQYleu+ocA97r1udHYEzmyN0cMc/c0C2StJyOPA9dGWxfAiT6YIXC4Y/dVzR?=
 =?us-ascii?Q?877xqWnElgsxAvOGOdXosq0zrWyMQd42ORyMDmiOKs+sJEYRiellTjFUAiZy?=
 =?us-ascii?Q?gHUGEqXTSk7jl2DO5RGXLdtJKTYIiwcGqoNaISnGrpRiuAy6TLV4+UY3NMah?=
 =?us-ascii?Q?qEyVnfPEamSq8/o99HEV+6fg5H0X1fFLULesyYnaFEU8rBnr8hespWYM2G2p?=
 =?us-ascii?Q?4l8hrLeDxKtntw41BK9IhodQvhbywsw7Jv1ZrnEBus4/4uDswL94HwDELw?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(376014)(7416014)(36860700013)(1800799024)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2025 04:21:25.6850
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ed5e89f3-bce4-4bbf-20ed-08ddb07b1644
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF0000013F.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8344

From: Ankit Agrawal <ankita@nvidia.com>

Today KVM forces the memory to either NORMAL or DEVICE_nGnRE
based on pfn_is_map_memory (which tracks whether the device memory
is in the kernel map) and ignores the per-VMA flags that indicates the
memory attributes. The KVM code is thus restrictive and allows only for
the memory that is added to the kernel to be marked as cacheable.

The device memory such as on the Grace Hopper/Blackwell systems
is interchangeable with DDR memory and retains properties such as
cacheability, unaligned accesses, atomics and handling of executable
faults. This requires the device memory to be mapped as NORMAL in
stage-2.

Given that the GPU device memory is not added to the kernel (but is rather
VMA mapped through remap_pfn_range() in nvgrace-gpu module which sets
VM_PFNMAP), pfn_is_map_memory() is false and thus KVM prevents such memory
to be mapped Normal cacheable. The patch aims to solve this use case.

Note when FWB is not enabled, the kernel expects to trivially do
cache management by flushing the memory by linearly converting a
kvm_pte to phys_addr to a KVA, see kvm_flush_dcache_to_poc(). The
cache management thus relies on memory being mapped. Moreover
ARM64_HAS_CACHE_DIC CPU cap allows KVM to avoid flushing the icache
and turns icache_inval_pou() into a NOP. These two capabilities
are thus a requirement of the cacheable PFNMAP feature. Make use of
kvm_arch_supports_cacheable_pfnmap() to check them.

A cachebility check is made by consulting the VMA pgprot value.
If the pgprot mapping type is cacheable, it is safe to be mapped S2
cacheable as the KVM S2 will have the same Normal memory type as the
VMA has in the S1 and KVM has no additional responsibility for safety.
Checking pgprot as NORMAL is thus a KVM sanity check.

It is possible to have COW VM_PFNMAP when doing a MAP_PRIVATE
/dev/mem mapping on systems that allow such mapping. Add check for
COW VM_PFNMAP and refuse such mapping.

No additional checks for MTE are needed as kvm_arch_prepare_memory_region()
already tests it at an early stage during memslot creation. There would
not even be a fault if the memslot is not created.

CC: Oliver Upton <oliver.upton@linux.dev>
CC: Sean Christopherson <seanjc@google.com>
Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Suggested-by: Catalin Marinas <catalin.marinas@arm.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 arch/arm64/kvm/mmu.c | 61 ++++++++++++++++++++++++++++++++++++--------
 1 file changed, 50 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index d8d2eb8a409e..ddcbbcc8a9ae 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1681,18 +1681,53 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	if (is_error_noslot_pfn(pfn))
 		return -EFAULT;
 
+	/*
+	 * Check if this is non-struct page memory PFN, and cannot support
+	 * CMOs. It could potentially be unsafe to access as cachable.
+	 */
 	if (vm_flags & (VM_PFNMAP | VM_MIXEDMAP) && !pfn_is_map_memory(pfn)) {
 		/*
-		 * If the page was identified as device early by looking at
-		 * the VMA flags, vma_pagesize is already representing the
-		 * largest quantity we can map.  If instead it was mapped
-		 * via __kvm_faultin_pfn(), vma_pagesize is set to PAGE_SIZE
-		 * and must not be upgraded.
-		 *
-		 * In both cases, we don't let transparent_hugepage_adjust()
-		 * change things at the last minute.
+		 * COW VM_PFNMAP is possible when doing a MAP_PRIVATE
+		 * /dev/mem mapping on systems that allow such mapping.
+		 * Reject such case.
 		 */
-		s2_force_noncacheable = true;
+		if (is_cow_mapping(vm_flags))
+			return -EINVAL;
+
+		if (is_vma_cacheable) {
+			/*
+			 * Whilst the VMA owner expects cacheable mapping to this
+			 * PFN, hardware also has to support the FWB and CACHE DIC
+			 * features.
+			 *
+			 * ARM64 KVM relies on kernel VA mapping to the PFN to
+			 * perform cache maintenance as the CMO instructions work on
+			 * virtual addresses. VM_PFNMAP region are not necessarily
+			 * mapped to a KVA and hence the presence of hardware features
+			 * S2FWB and CACHE DIC are mandatory for cache maintenance.
+			 *
+			 * Check if the hardware supports it before allowing the VMA
+			 * owner request for cacheable mapping.
+			 */
+			if (!kvm_arch_supports_cacheable_pfnmap())
+				return -EFAULT;
+
+			/* Cannot degrade cachable to non cachable */
+			if (s2_force_noncacheable)
+				return -EINVAL;
+		} else {
+			/*
+			 * If the page was identified as device early by looking at
+			 * the VMA flags, vma_pagesize is already representing the
+			 * largest quantity we can map.  If instead it was mapped
+			 * via __kvm_faultin_pfn(), vma_pagesize is set to PAGE_SIZE
+			 * and must not be upgraded.
+			 *
+			 * In both cases, we don't let transparent_hugepage_adjust()
+			 * change things at the last minute.
+			 */
+			s2_force_noncacheable = true;
+		}
 	} else if (logging_active && !write_fault) {
 		/*
 		 * Only actually map the page as writable if this was a write
@@ -2269,8 +2304,12 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 				break;
 			}
 
-			/* Cacheable PFNMAP is not allowed */
-			if (kvm_vma_is_cacheable(vma)) {
+			/*
+			 * Cacheable PFNMAP is allowed only if the hardware
+			 * supports it.
+			 */
+			if (kvm_vma_is_cacheable(vma) &&
+			    !kvm_arch_supports_cacheable_pfnmap()) {
 				ret = -EINVAL;
 				break;
 			}
-- 
2.34.1

