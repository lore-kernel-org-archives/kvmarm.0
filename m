Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2067.outbound.protection.outlook.com [40.107.96.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 164C419EED2
	for <kvmarm@lists.linux.dev>; Sat, 24 May 2025 01:40:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748050815; cv=fail; b=o7iRDoOEZqFi9no0dMGoOKpx2Uexxy6J44vq7maT3+2nxQ68wbFsBUA+BiWF/BDCS5ebW4ajK11XUkpVX2IMGIbyHLTHSVg4SFWK3SS1ODeZOr/6VCaeH/77OH9K0J+aKrHz5WVfGaLkSn0y2V+C9C/biHeSQ5q7pVu8mfQrc8s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748050815; c=relaxed/simple;
	bh=HAJ5xDTqfGMgUYvtQdSovWsJBW2Epq4y5kTjtlEKgSw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rVe+J4Yz4wQnOeojI2JI6d7yTiCMjR95+AY4ZpJQ0jxdd9tym2XE79wOJjHmGkYXr65mjZ/f36GXj5KDSWjahgi8GDt+w9VZYkur6GIFnUvE4PVUUNz+Gr+OsL/6Fb5izJB63APEmeGZaGwJtsx5meHcZDKJdL4MeTl4uXAAyzE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=qnWGmh4q; arc=fail smtp.client-ip=40.107.96.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="qnWGmh4q"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bWQyrppmJXFMeEQDGs3M3LIINOsty3/iPFpAdYbJfOYuvHkqiZWnBRuIFDBVwMvdvtB/FKFqXbg55ml1j6GPiAQimQSwzbXNYczKC3ibrVri7urtT3d1dZUafeZ7ghpCfqZe9T1kB4z7po9bqprIfj2Yw8YsNa621nOb6QivbXsAoCVS0N+9Nj/YaNmyFgoBoQEGKpYesmcF4qcektAMPwiYbSDjLihdA0hg1rhGjRpSN0bLTBokaaMX7f0+Tz5JkJcS51MmB7slFC6Rb+awrBPjpZZuU4urKQxDDSAf5CFzBwQ+g+ORpWUp3E/xUS8EzeKcBJzQ1A4HdDVSt5DcUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oDVEJQMIZ/qBTRBwSLDqvgC4HklyJpnOl5a8RB6TJGg=;
 b=HW8BhaygrKOmu/zZvt2cfgpDg/+/xRDQglp0UmHF3H/8xk1k3N+zBgRlsELo+d5QfNH1jq8F1eBmiglCGCL7k8X+1ROgXZNVZL9ED2fwhEPLNNuBowhIjw7OZ2ZnI1dJLilBP+RV+ToHKNd5bH5dPwK480Dod9lyHuBa3y98t42ciT/Hd3SyTJJbUpyU0CzkqlwH8LDW68fR5b/0b18i6FHlniSxTMSv1H2+S7CwjilJiVp5CoO9MWoPRO74FBwl3hF0uXTiYoR9KsmEbbmUKWAAI1JBHtLnRrKOVTyEnOCKOjcClbV0q4BjatuJ4O+/oN0OQDWfdGBIjRnbSxnkvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oDVEJQMIZ/qBTRBwSLDqvgC4HklyJpnOl5a8RB6TJGg=;
 b=qnWGmh4qH0GI0xwCr6uJJhXQy3dbqJ4tPz2K3Al+1c2c8hoyrZ2hHvrPP6r9aEyIiKj52EDUrFs7lxYwC4VHD70W45Mcq3xYiDkYoSVWfllsk1uAMeXLsWdLmkrlK6jfzYdCRdftm3mHEYjOgCuMxq6V6jkf6bstjtmAbx8fsTH9i5hlngmXDcbq/DKYlhaPtZ46Q4AljxiIUI6uIyN03H6Kv5mWtykGEGjwvkzLVxDfg58zz50wLVMk91naMELhraRiLmCDNgP9hCZA/zw14l+dZC3HhKiMmsG5lIGXx/QFe/9yOivsZ6IULkrmdNcE6yW5e+eN+5RCVxVEfCYU+A==
Received: from DS7PR06CA0030.namprd06.prod.outlook.com (2603:10b6:8:54::22) by
 PH0PR12MB7816.namprd12.prod.outlook.com (2603:10b6:510:28c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.20; Sat, 24 May
 2025 01:40:08 +0000
Received: from CY4PEPF0000EE37.namprd05.prod.outlook.com
 (2603:10b6:8:54:cafe::56) by DS7PR06CA0030.outlook.office365.com
 (2603:10b6:8:54::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8769.18 via Frontend Transport; Sat,
 24 May 2025 01:40:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000EE37.mail.protection.outlook.com (10.167.242.43) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8769.18 via Frontend Transport; Sat, 24 May 2025 01:40:07 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 23 May
 2025 18:39:53 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Fri, 23 May
 2025 18:39:53 -0700
Received: from localhost.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Fri, 23 May 2025 18:39:51 -0700
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
Subject: [PATCH v6 5/5] KVM: arm64: Expose new KVM cap for cacheable PFNMAP
Date: Sat, 24 May 2025 01:39:43 +0000
Message-ID: <20250524013943.2832-6-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250524013943.2832-1-ankita@nvidia.com>
References: <20250524013943.2832-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE37:EE_|PH0PR12MB7816:EE_
X-MS-Office365-Filtering-Correlation-Id: 8ef3f43d-e260-4a6e-1c9e-08dd9a63ea39
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|376014|7416014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?aZ2+PFySyQ714MwEgkTIpWeN9IlDX+TKxtPTxzna+VT7+6eDGJRDofI8bqu7?=
 =?us-ascii?Q?eZltNefuW1wPqHBJ+srd/snK+/xq96QPce2c95GV5R9+FLTiGsbSKdw1B48F?=
 =?us-ascii?Q?SIsZpH26tgwXGJzM7PB0Q+BnrzlVpzVZAyLMXBAzXugWw8/czIzX8XDVXbEU?=
 =?us-ascii?Q?l7Xq86wckA4j9tpCmbY6/7kHl2nIsca0rWxThs9y5nmT2HfUykSYXqKLDJ++?=
 =?us-ascii?Q?sUDc5Z0j6HKWO9HIv6Bni9/HBUylEjoXZES+IIkCf0K2PUjQxwBxZ8XUXXLy?=
 =?us-ascii?Q?duzglZAHzJvcC+DQhK0AGHVnrEnDP86NEnxesZM0JjEAyAx8jz191TfNjavN?=
 =?us-ascii?Q?Q8WpeHiVBxD0pH4diHAZEDHhWDiiyeDg/oedN628O3c4ix0rN1gN3Hdf/y5j?=
 =?us-ascii?Q?mtISXViEv0oCGUAPoPBfqCVXDmKWIGnX5nAi9VDol5glNitL/h0aVGbFui50?=
 =?us-ascii?Q?/o7GFeRf3jllEaAHUcOJidKjEiFqmWUG2mAXDjeguft0ILlkcQFpEm8IbqL5?=
 =?us-ascii?Q?STsRc+eiKH38A46iVqy9Ue0w6MJFbZdR08gXzNwD+5IkWT3FsfaZEMIKjkPI?=
 =?us-ascii?Q?Cn4GXmtYwHpc6qYa8w0/Imkwat8lf4W1MH+lYRHTeEUK5fYLWOzhC7CMXAKj?=
 =?us-ascii?Q?QAaX9cKUPr3xCRc/WOiFZSGJwfvP+XqQWPeF/ugvE1gCTOpFMZqXLaH88dnB?=
 =?us-ascii?Q?AwboF/c5aAuZrqP/+hhA5NEx4zz6l6EMnCUb3b6k3eXOp3paRfq7mIPFdxOK?=
 =?us-ascii?Q?KkounFAh2oVA/GiA6ZkBtKlJP1zdOi3oZVZvcVVI7EOsCLYe9JDJ2fImfV3x?=
 =?us-ascii?Q?3AXdahXaaJeYqQCYR5KoVd2uJa5cM2FDlXJN5tLyUB8opTxUejAdlDMtjeFe?=
 =?us-ascii?Q?2DjMjTMUciIx9vcAojEfcppr2ixVXk3hCoNasjn7LxmVe5qRAmNpiG3zvOeb?=
 =?us-ascii?Q?jQVKlF5NBDUIRlPpQaku3UvcX/7sDnMOrAxkAFduFElqjCpPI/JDV8G0mmT8?=
 =?us-ascii?Q?H/2vhhOFWbo7zXRLZFlaU8F0oApfMml1QxaguThHAdu9TNiYqSIVwF2oqQPB?=
 =?us-ascii?Q?jO7S+SxNRjVBYXGkL2PFjQE6iIQ1GNj/xqXXmX421YluAMxkUX4GuzzJ4w94?=
 =?us-ascii?Q?VSgO2Gsl08sXV7+j6eWieQW4ZUfJe6RK7+KnPcWk8GnUcgUvwIawcF5u+RHb?=
 =?us-ascii?Q?JfNd4nhbjl/MI22STeDOyqwrZy3deeVM7The+Li2N4dSPw12y7VPB1kR33KL?=
 =?us-ascii?Q?2m9Ln0Iq06o3vqrKOOcbKFknO/+EBHEK3wlCdwITvHMkA+Skx42LFhI1oerO?=
 =?us-ascii?Q?JaopIZGdoJnIkTuiI2xCrCdKoIqjRaY1t/W7eFrhn0jZ0AZ1Ma9IPn7HddkL?=
 =?us-ascii?Q?jXM8Yi5LZb4lG8aCx8IuwBctohG3rm1TZvaNh9zRLX/lUYQixAv33Jk5hbFL?=
 =?us-ascii?Q?naigS+0EVeZ05bssY6eHql0/uE1hi85kwtxuw1LHyQjDO7AlvZ34OJXClzZ1?=
 =?us-ascii?Q?aWsty8qzBP4IH0tCQmdHgbHO+P60FlcmPVwPIKBQue67qQPIiFyGNL/qFA?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(376014)(7416014)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2025 01:40:07.8093
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ef3f43d-e260-4a6e-1c9e-08dd9a63ea39
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE37.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7816

From: Ankit Agrawal <ankita@nvidia.com>

Introduce a new KVM capability to expose to the userspace whether
cacheable mapping of PFNMAP is supported.

The ability to safely do the cacheable mapping of PFNMAP is contingent
on S2FWB and ARM64_HAS_CACHE_DIC. S2FWB allows KVM to avoid flushing
the D cache, ARM64_HAS_CACHE_DIC allows KVM to avoid flushing the icache
and turns icache_inval_pou() into a NOP. The cap would be false if
those requirements are missing and is checked by making use of
kvm_arch_supports_cacheable_pfnmap.

This capability would allow userspace to discover the support.
This would be used in conjunction with the
KVM_MEM_ENABLE_CACHEABLE_PFNMAP memslot flag. Userspace is
required to query this capability before it can set the memslot
flag.

This cap could also be used by userspace to prevent live-migration
across FWB and non-FWB hosts.

CC: Catalin Marinas <catalin.marinas@arm.com>
CC: Jason Gunthorpe <jgg@nvidia.com>
CC: Oliver Upton <oliver.upton@linux.dev>
CC: David Hildenbrand <david@redhat.com>
Suggested-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 Documentation/virt/kvm/api.rst | 17 ++++++++++++++++-
 arch/arm64/kvm/arm.c           |  7 +++++++
 include/uapi/linux/kvm.h       |  1 +
 virt/kvm/kvm_main.c            |  3 +++
 4 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 47c7c3f92314..ad4c5e131977 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -8478,7 +8478,7 @@ ENOSYS for the others.
 When enabled, KVM will exit to userspace with KVM_EXIT_SYSTEM_EVENT of
 type KVM_SYSTEM_EVENT_SUSPEND to process the guest suspend request.
 
-7.37 KVM_CAP_ARM_WRITABLE_IMP_ID_REGS
+7.42 KVM_CAP_ARM_WRITABLE_IMP_ID_REGS
 -------------------------------------
 
 :Architectures: arm64
@@ -8496,6 +8496,21 @@ aforementioned registers before the first KVM_RUN. These registers are VM
 scoped, meaning that the same set of values are presented on all vCPUs in a
 given VM.
 
+7.43 KVM_CAP_ARM_CACHEABLE_PFNMAP_SUPPORTED
+-------------------------------------------
+
+:Architectures: arm64
+:Target: VM
+:Parameters: None
+
+This capability indicate to the userspace whether a PFNMAP memory region
+can be safely mapped as cacheable. This relies on the presence of
+force write back (FWB) feature support on the hardware.
+
+The usermode could query this capability and subsequently set the
+KVM_MEM_ENABLE_CACHEABLE_PFNMAP memslot flag forming a handshake to
+activate the code.
+
 8. Other capabilities.
 ======================
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 68fec8c95fee..ea34b08237c4 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -402,6 +402,13 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_ARM_SUPPORTED_REG_MASK_RANGES:
 		r = BIT(0);
 		break;
+	case KVM_CAP_ARM_CACHEABLE_PFNMAP_SUPPORTED:
+		if (!kvm)
+			r = -EINVAL;
+		else
+			r = kvm_arch_supports_cacheable_pfnmap();
+		break;
+
 	default:
 		r = 0;
 	}
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 9defefe7bdf0..fb868586d73d 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -931,6 +931,7 @@ struct kvm_enable_cap {
 #define KVM_CAP_X86_APIC_BUS_CYCLES_NS 237
 #define KVM_CAP_X86_GUEST_MODE 238
 #define KVM_CAP_ARM_WRITABLE_IMP_ID_REGS 239
+#define KVM_CAP_ARM_CACHEABLE_PFNMAP_SUPPORTED 240
 
 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index cddda7f21413..25af7292810c 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1537,6 +1537,9 @@ static int check_memory_region_flags(struct kvm *kvm,
 {
 	u32 valid_flags = KVM_MEM_LOG_DIRTY_PAGES;
 
+	if (kvm_arch_supports_cacheable_pfnmap())
+		valid_flags |= KVM_MEM_ENABLE_CACHEABLE_PFNMAP;
+
 	if (kvm_arch_has_private_mem(kvm))
 		valid_flags |= KVM_MEM_GUEST_MEMFD;
 
-- 
2.34.1

