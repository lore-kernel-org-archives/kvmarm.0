Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2064.outbound.protection.outlook.com [40.107.243.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 594BC1EB9FF
	for <kvmarm@lists.linux.dev>; Sun, 18 May 2025 05:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747547300; cv=fail; b=oE90KInmuUVj8+YBVnqRrubnpKl5+z0PWf3eHg/EoNbW7nKJwGd5+1CwADZWk7sXCEKY45/RCPP4j6+T9w/2OS4IRv1tGs9OsfYWRKjs+FZ38EW8a/Mm5PJt1OW/t6QRUmBZzEGVeWZBF2RUGVafpDz9AC6a0SmejhF28l5SNrE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747547300; c=relaxed/simple;
	bh=khaLw+yiCVM9D31l0Qe33WNBhSqy7NhfLR8v3nwBWfs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=i9RF56Vr5lT8aUXjcDT2sMITKnrwcaFjRZqO51g5VlWSCUYl5J0S3W63nBVNdnDZAVu5djUP0gpIsrRUuhuqoubAQJA1RW9Oh9X5AkL6hmbEXzWg8ik2ylqO9v2aM5BOBt4Yi94NvSzdus6qwApb0fztLZJGAckuhuzpDqLC9jA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=DikQ1xfC; arc=fail smtp.client-ip=40.107.243.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="DikQ1xfC"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wKqZ0KqCirE3XU8jLWxr3SPvESAdWk19fA7KSt+TnjhUVSv17e+aYCA6BUjERbUh8aettZkmBphhcP7H1Dqi1A+oZAqJTskETeJu9Dc4TyAQ5osiv0aYQHdWevSfBXlg+AoIRUzCJIvduiMaENreYdQLUOnwO82yKnbIl4ZyES+rJcM5aVv67gqIGXcAUVMIBcS4EUaJ2HXWDhkQ1jiXiojBMQfzj6lxPeXlNwDHsTyZJ45SQv6II7lfQeZzto8c/qZ31E5Ukt4oOQHMdyxfb/rD9SMA2wTHgxpTX58MokKQ4xPKoK42RDcZVB5tN3KHjSrQ9gQ+enAlCy48Qr5nTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XWbuZWcNiPWD3ZDdaUj0w55UKlT0T3//WOrIqoGV+0w=;
 b=qBlwRlWQMd33GaStr4XxEuOxF5rUv8U91iMWZE5OeSY83R66KEUHktkHSIP/dbbiYoFJddiSxvLoX2rnWBMGSyzYrTibfeIlUc1Jibg6pt0+1MPhoJd2VZylX+kx2oUu5ifOezLMf1Gi/KCEMOH4BB/eoW+Q93O9ICHONF0Jifvsax+/lJYA2qq6aTVvqJA6i2GK6xa5FCZ0PQUT2haSIeaQJ4x+PlZVnBqDrbV5jCnJSAmvRlBcFYlYg6h37qGBueKZUkgAUziRDysqNvYY5MYx7UJcTemIdlgdQ1ioMqZQubxTP2unl4cqoneTyHy3eKsHPB/DZIvvSl34fmzJFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XWbuZWcNiPWD3ZDdaUj0w55UKlT0T3//WOrIqoGV+0w=;
 b=DikQ1xfCSc1grr2opcBEEb3mJ+SQ4lAnQKJ4OP9WmkGcH2lsc4ecHxP1IY1Zv85NM/5LZ7oPL+8Lx/VNRyF3oIydu+BItL/QbHPAkVK+0s5ED8P8SYnE7RgYPUGrdc4WQfD3nPvGZYgBiHgmpbHeAJnBLdWqTZgAlhateocqg+bzhSqXkTD6S/vVsN+YSJ6bCBwm4vLNkDJ0t1HXhmeORJgYg9xlCQW7xGv1mOF6rdIZXNmaY23I7hD1vpwfxzj+wcEN7aq4tK+xIfp2qj8PcYKUXCw16aDbRskR0UagCXKoEcR0B0+K2RDgO9t9rj32YFVwGA1XfyZkTn/WGgoUZw==
Received: from DS7PR07CA0014.namprd07.prod.outlook.com (2603:10b6:5:3af::17)
 by CYXPR12MB9388.namprd12.prod.outlook.com (2603:10b6:930:e8::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.26; Sun, 18 May
 2025 05:48:14 +0000
Received: from DS3PEPF0000C37C.namprd04.prod.outlook.com
 (2603:10b6:5:3af:cafe::7a) by DS7PR07CA0014.outlook.office365.com
 (2603:10b6:5:3af::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8746.27 via Frontend Transport; Sun,
 18 May 2025 05:48:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DS3PEPF0000C37C.mail.protection.outlook.com (10.167.23.6) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8746.27 via Frontend Transport; Sun, 18 May 2025 05:48:13 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Sat, 17 May
 2025 22:48:04 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Sat, 17 May
 2025 22:48:04 -0700
Received: from localhost.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Sat, 17 May 2025 22:48:03 -0700
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
Subject: [PATCH v4 5/5] KVM: arm64: Expose new KVM cap for cacheable PFNMAP
Date: Sun, 18 May 2025 05:47:54 +0000
Message-ID: <20250518054754.5345-6-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250518054754.5345-1-ankita@nvidia.com>
References: <20250518054754.5345-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF0000C37C:EE_|CYXPR12MB9388:EE_
X-MS-Office365-Filtering-Correlation-Id: 8f184e58-7a3b-493f-6324-08dd95cf949c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|82310400026|36860700013|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?x3EhGHspUKnTbbeTYz1CsccSv37P0Sxfc0E6KVr6eRI+82+UE4aBkDfy9FJB?=
 =?us-ascii?Q?dnzNrMqzfm5MIovr1YOYdarssrd+9UOf1FmwfAn8w/nSHCK8i1eosMBIVtXx?=
 =?us-ascii?Q?GUK57xOklGqhGFS7vIzoO1G4gg2ReY+mGzsggKvQUdNmWPiHX9BJNsC3zbFZ?=
 =?us-ascii?Q?XZh+/KqegLqwtXdO1d6ty9tWunq1VFGg2UqbP3jWt6D+xt/KsaG9z0uKCqOr?=
 =?us-ascii?Q?v1zFriss3j1KweO1BhmJxPdiPfIObrGFqgSCwsnjh3AF+R2LRY6scjcpamFQ?=
 =?us-ascii?Q?cpu2BLvDDll52cKzN3Cq4Tflq/aVnvZHg/ZLp5aDe2AxOKBHJIoBdVL2aaHl?=
 =?us-ascii?Q?oPlgbu0ec+nvXS59+ahY7XRo2iCi0OWPOZz4fwSg7nJycX/e3+bn4PHhZcTE?=
 =?us-ascii?Q?t5QzuhhNtsPdqXnxz/vNNM6c6sZ75ATOR5FlHspsBKPEXH7H4HPRG3P4xYUp?=
 =?us-ascii?Q?0EWLTXQQDYz3P4WO6AQJWzdGz0XubUZNJkFynLQsliGK4QM0WsaiHhzzxNqp?=
 =?us-ascii?Q?BGSTb/cEDCnAkphlHb6JaDldmTljWeebBNwy/WW7+w5wE79ZN3x6kcY/ZYjA?=
 =?us-ascii?Q?oTAYjc8bP7l55CurueN0oJn8Xvd5UA3XqW57ymm3ww/2cWIR2IfN0WmJLFha?=
 =?us-ascii?Q?JOTeVFHS+me5bB/vFIiXiTEGj0iJEpBwUFwT5Am7uvGvytPEYQ3zdkEd4zIT?=
 =?us-ascii?Q?Op7R3j3QhDHfq3GD9D53/iVKgpBecFz72LOyZ/53mr8WdaDBF55qdClXcp++?=
 =?us-ascii?Q?xvjD3JWVw6TqCI+WhZ5gswP5o66lRYMRY+W2+ryTVzASYiXnPFHziMp2iO0L?=
 =?us-ascii?Q?G5ozQ38Ntu08SAs/5e+W+LguNl6dlsAv8ppr6oJaMOVGfkz497eZ7wNHXuq8?=
 =?us-ascii?Q?Rgj7chXnB25zu9RkQQvYqWSGgiTcRDKPEUuFDNZIzDQajD7tmTyKMGNQ2r0x?=
 =?us-ascii?Q?iLR6xysNn4aqv37ZsDuFShOHuP4E6ZmI4C6okwpDrUn54/CqgAonMs/a07BN?=
 =?us-ascii?Q?1uLfhGFIYwAPrz4kV60lkTPwKOyuwkSM6QtYcAyCuI0mijpH5BaEvFyph7Sp?=
 =?us-ascii?Q?Hbzwv7L/pJPA8jlALwdUjZEzfjSMcLJ7g0uqdu72SeD4xq6N1sTCxw88xcVL?=
 =?us-ascii?Q?FFUGNWtU8j7pdWIkmXlyJngHy9kfgIXt1rG2iCNBZQiYLbD662O/TpuB9yb/?=
 =?us-ascii?Q?6ZhcYmcRSmMzZcEHwDsfKnN6xmwsRfjL+Q5jaIa4Z0+AOEyDEFmqqgdMAmnF?=
 =?us-ascii?Q?spIqBRcttsArLWkQTATt4qPhnuusizo/npd1DiWhNsNHV6rVYjRhwZQPSFMA?=
 =?us-ascii?Q?gIfEx+XYxXV5YhSXZN23bldqZS3P+kF9cOfNDd326MOAgiVrW4aUQiQA5z2X?=
 =?us-ascii?Q?cVSGYSNudV6fVOHcWsAfcqXSHM89Yzj3VHfsiD+omVLO4DXPfWIMlXDrI/Q2?=
 =?us-ascii?Q?zvzqLZKOfY81mMYsLMjCY+wAOWMrw6u3XFeAReGkPzCcgvqXwVcpbedzJePX?=
 =?us-ascii?Q?8pcpYoDJK8IqC6HGvCYPN5dk/m1xrsDfwUfT1DevjCgQFiEAFEG5Ghzirw?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(82310400026)(36860700013)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2025 05:48:13.9505
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f184e58-7a3b-493f-6324-08dd95cf949c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF0000C37C.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYXPR12MB9388

From: Ankit Agrawal <ankita@nvidia.com>

Introduce a new KVM capability to expose to the userspace whether
cacheable mapping of PFNMAP is supported.

The ability to safely do the cacheable mapping of PFNMAP is contingent
on S2FWB and ARM64_HAS_CACHE_DIC. S2FWB allows KVM to avoid flushing
the D cache, ARM64_HAS_CACHE_DIC allows KVM to avoid flushing the icache
and turns icache_inval_pou() into a NOP. The cap would be false if
those requirements are missing.

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
Suggested-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 Documentation/virt/kvm/api.rst | 17 ++++++++++++++++-
 arch/arm64/kvm/arm.c           |  8 ++++++++
 include/uapi/linux/kvm.h       |  1 +
 3 files changed, 25 insertions(+), 1 deletion(-)

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
index 68fec8c95fee..7855f579fb82 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -402,6 +402,14 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_ARM_SUPPORTED_REG_MASK_RANGES:
 		r = BIT(0);
 		break;
+	case KVM_CAP_ARM_CACHEABLE_PFNMAP_SUPPORTED:
+		if (!kvm)
+			r = -EINVAL;
+		else
+			r = stage2_has_fwb(kvm->arch.mmu.pgt) &&
+			    cpus_have_final_cap(ARM64_HAS_CACHE_DIC);
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
-- 
2.34.1

