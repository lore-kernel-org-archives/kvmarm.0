Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2068.outbound.protection.outlook.com [40.107.96.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 303D3296158
	for <kvmarm@lists.linux.dev>; Fri, 23 May 2025 15:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748015102; cv=fail; b=ezEGC4jX1cwu+0n+3v9PH8/VcnC5GnQJO9uv3pz5BRJ+AtTvfKKd0vdu77F4mcvhNG2TUomM9jzn/IBnyniTwYa4gq+t0v3+7UIOiWY3MttaFA46xf6PUVDhWtDQI/sHtR6s3Mga03pztu4sVmFaHMwP+mDLZIgUIkMOO43Iy/E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748015102; c=relaxed/simple;
	bh=WlA8Q3eudTJ21rsdqr8Xelu7x+qTruANsAunHmmOZz8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Vn1WD4BwwtCmLNf6hTf9UyoEoIpOlwPy/gq9xuExeP6ptTmfm/FYHcjsNu3r3pIUgMWU6qo56RuzLKsum4vQF39qcK2OYt/tbfdT/x3aJ3HSsxStbPfxCvkyTCE9MT2TlQSN0yZ72VeidPngDlCVfNAjwMqUgN4c8tPlzuaAkHA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Rlks4Kwn; arc=fail smtp.client-ip=40.107.96.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Rlks4Kwn"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wlLXrHyZpSYiGiqHvKK4rZGZxUUv09+8949TlmcQLzZ6MA1g9F8x113XUB2QFliuMX8wjGbdcsGhmSGAIeulCMAMQUvuSl1vQLiYLHKGEhTiZ/cGMFiohxPcHXfKXIX01a5qAcZn3eApFxzfc8rENmYgIcR1aWSBZ2PhD75MyQJ8wBhm/zKSxG0ZB3u1LalzrkHMAr+sD7X4spGezx7VhzGhF2WZGWO1r4C8w+TwGIpJWQt/upK8OqtUe0eAa3Pm7/dgP/WwdofJaxCQgkq0vitX5uC1kapt7DKIIYVb1c2wz0yuvyApmaotu6f5W1LhnVLevMlas9W2r5baoEpYpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JcIC5oOa1/q0xme3qWX3do4fSWKvRzBqq12MsnItkZM=;
 b=rlP6SB3VBIDqX3R9nQR+E0ITqEAwNMWfah16eaie4ZomdTaT4fgMGkv778TFdgn9j2AGICq94nbiKuCdp+y1mrPWmw2LGP5dEaEXq7Wl3Kezmjql+E+9Dn27el15IALzwlcF0opuqSO/V/uKuO3zcyLbQdIrsn+wyYNGPUTlB3BD9CtfB+SIkX4HTSED7cmOAP+X8+slNqfBy5vqBw5gSGs+qAeXXKOf5rk2QLK3ZXQ/BsOUsz76Ui5h+zyQccb0aBp8t9J5OzSBLTQXgcX11jE1rzEgJIFY17CviOKOnxSZF+LlzX8OZTQq+uF8cf7cTviaLt93vhnsI/VhwvugrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JcIC5oOa1/q0xme3qWX3do4fSWKvRzBqq12MsnItkZM=;
 b=Rlks4KwnskFI+QZ5VJWeJmigOZPAq3mQbKAjlijplDRBXuudkYmrZYCKPm6jIhE6eykZiwUefY/FqwI9BCkR5Z+6wLLX61EJMfLjsuzSNZLD4j5WcimEKPr4XDCfwRVBZ6DA0HGIRZui1HDyjXnhmrHu2Ks9JRygdw+ySxv1+girX5ZyqO8A92+FTMOjkS60SWyk3YPqVXtpkuziA7gOvxLkfCEWd8wMmC5B5nK3GjoLBRc/B8RrzEGC4Cel6LMtLAJmVedomjWMwSBO6d26sEdM1Vp4VYBi9BoULH6/9XBryl7g4ePHyK0yFzpbCQaKpaDX/VUwcty0pBavfXyD+Q==
Received: from SJ0PR03CA0286.namprd03.prod.outlook.com (2603:10b6:a03:39e::21)
 by IA1PR12MB6354.namprd12.prod.outlook.com (2603:10b6:208:3e2::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8746.30; Fri, 23 May
 2025 15:44:56 +0000
Received: from SJ1PEPF00002310.namprd03.prod.outlook.com
 (2603:10b6:a03:39e:cafe::9a) by SJ0PR03CA0286.outlook.office365.com
 (2603:10b6:a03:39e::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8746.31 via Frontend Transport; Fri,
 23 May 2025 15:44:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 SJ1PEPF00002310.mail.protection.outlook.com (10.167.242.164) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8769.18 via Frontend Transport; Fri, 23 May 2025 15:44:56 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 23 May
 2025 08:44:48 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Fri, 23 May 2025 08:44:47 -0700
Received: from localhost.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Fri, 23 May 2025 08:44:47 -0700
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
Subject: [PATCH v5 5/5] KVM: arm64: Expose new KVM cap for cacheable PFNMAP
Date: Fri, 23 May 2025 15:44:45 +0000
Message-ID: <20250523154445.3779-6-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250523154445.3779-1-ankita@nvidia.com>
References: <20250523154445.3779-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002310:EE_|IA1PR12MB6354:EE_
X-MS-Office365-Filtering-Correlation-Id: d1689343-a3db-4dd9-acbc-08dd9a10c475
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|376014|82310400026|7416014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?hBxiNiDXVvDWC4bDd9fmwnM/abozDkBaOjhRJwbfxGyMbtQG9Yzsd4LPBzlv?=
 =?us-ascii?Q?H0RTuKZuu9ll9NztqgNDPtAJlst42LRzFuiD5tFQAL8OQufDsyXqIYDfxSeU?=
 =?us-ascii?Q?QyV/91tud4rcqb/cnaYvbsr/8Chlz4inUqijHljvMvrEk/wj3BI9Go5+XfMn?=
 =?us-ascii?Q?Cra+R5DLr5RQAfUeAH92bpuDNcBkX4gKLVVkO5U5rwDQdHmgvlibj8R5Muzo?=
 =?us-ascii?Q?X8fqf9/Wg/I5PSsJ3hVn8Nq1QjdCvuB74H5RDQoiIHHQc8yc0jdM3q+CRvQL?=
 =?us-ascii?Q?zR+MrP/ZwT1QgqC/ZSABcIW4BcGKnyPEvSkjQLooACLwEYyS1PTAXKtj+/RY?=
 =?us-ascii?Q?UsH81lvqZS7ZEvQym7Jo5ikh9masQ9MF37HTAsDbpQRpc/8Ecx2tAvHlYZtO?=
 =?us-ascii?Q?A3u4cwsN9/IbHcKhCVpPrWuBQ5OE8er2Z3XvF01qBjOVegK+kj9DVGsLsRHa?=
 =?us-ascii?Q?dMjji9yp1SVg0RePCK6Ai4NdKkcmfdDBNWL8n+PBOQzudRVH58+BK2rtQuGj?=
 =?us-ascii?Q?z0T766ZSrZlkuQR6kpk9qzPLA/UCIuVaBv6rvwqqHMCzHBYTXwkBZJYOrCMk?=
 =?us-ascii?Q?RTeXehjOIP6S2Yc4cbBT5y50O5tQw5YIJsGDOs3WKYD3cpBpA8m95DS/YLJ+?=
 =?us-ascii?Q?OKtd5q+AY//dwUgxCRlyvnnL5wdK2HsRwgu/Jtu+XK7PHPNzKLrSNflSxGjr?=
 =?us-ascii?Q?wyCGHvGDYl30yk8R/ai7Yw2204A74LgUlkPZwn6MlQB7Dp3nv3h/ezaEGIbN?=
 =?us-ascii?Q?tur5DBikZ+w3ZxZbyf5r9+ipnHiFSQYX9Cb5KBsta7bOWikpY2cqbmIip5jT?=
 =?us-ascii?Q?Bnc4frJQsm2cDLlMlbAPsfQaa+xx1xWEzvSCkMU89PRTU4EZ+78H3aA/eb7C?=
 =?us-ascii?Q?pMZqzZMU6lHXpSje5fAHoRtv4dj4SBpV2YpMzoyhkuflT+ubdYe/KrFtMHEj?=
 =?us-ascii?Q?d2K0WT41wtDWLdYZDi9TX9qyuXZK3eqZ55XSKfvinu3i+fq5MMAPbLZ8e/JR?=
 =?us-ascii?Q?nCV5vqDV1mLGhdcURJCAX7h/qFXshDGOIU7Vq42ajCKAEUZQ3Hnbzquusp+d?=
 =?us-ascii?Q?+X9KM4/paGKl9Y6PRAfRidxJoMb3GuuS7qccHUYGcbKE7x7ONZ+ay4pDSOo9?=
 =?us-ascii?Q?76eP32HAZSG5K2ztU9LXjCNIWAAvt5CpYxao/pUbhQrw1VZd2GVi8vuiJbLh?=
 =?us-ascii?Q?N9NewkHTgNDSIxi9d3ALJyOU+ZCiywyiW1Gmy3m3HwMSVn5JM6CJJPUrkfQp?=
 =?us-ascii?Q?HhuhbCIt5P32RKHt183krlPudy8fs3+lK5aBhJFkTi4jkLJxhQKnsLnj9vNm?=
 =?us-ascii?Q?N5uQpaPjosJXwKFKkj71QskYtAu0EyHdMdmAC4ryYPNyheaQN3ZtpmDinYvr?=
 =?us-ascii?Q?8lehgwg6TA1S+2fsNDqgRV+RvZc5eO0bl0NPM+BWADolCpWaNXW2+H/wLlQv?=
 =?us-ascii?Q?ib8AMig+6djHZRpqKCjH5PiXlx0QN1SszmX1RJWTGf67fsB99Lvz3tL3Pxk7?=
 =?us-ascii?Q?8ACDy2emi4K5zBKxbxgsP0XfB/2OsJ9xcNcrIMHWczR4hv4azaHUUsG1EQ?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(376014)(82310400026)(7416014)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2025 15:44:56.2537
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d1689343-a3db-4dd9-acbc-08dd9a10c475
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002310.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6354

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
 virt/kvm/kvm_main.c            |  8 ++++++++
 4 files changed, 32 insertions(+), 1 deletion(-)

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
index 5e0532c3abc2..25af7292810c 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1527,11 +1527,19 @@ static void kvm_replace_memslot(struct kvm *kvm,
 	(KVM_MEM_LOG_DIRTY_PAGES | KVM_MEM_READONLY | \
 	 KVM_MEM_ENABLE_CACHEABLE_PFNMAP)
 
+bool __weak kvm_arch_supports_cacheable_pfnmap(void)
+{
+	return false;
+}
+
 static int check_memory_region_flags(struct kvm *kvm,
 				     const struct kvm_userspace_memory_region2 *mem)
 {
 	u32 valid_flags = KVM_MEM_LOG_DIRTY_PAGES;
 
+	if (kvm_arch_supports_cacheable_pfnmap())
+		valid_flags |= KVM_MEM_ENABLE_CACHEABLE_PFNMAP;
+
 	if (kvm_arch_has_private_mem(kvm))
 		valid_flags |= KVM_MEM_GUEST_MEMFD;
 
-- 
2.34.1

