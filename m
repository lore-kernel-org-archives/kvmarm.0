Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2056.outbound.protection.outlook.com [40.107.100.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D9CD1A2C27
	for <kvmarm@lists.linux.dev>; Sat, 21 Jun 2025 04:21:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750479694; cv=fail; b=TqQk5jKDHFFl2H3TRAfuN5SN4ghSRH/Suc8a6rLSGZyPSZJf3KYYk6Pe6TXh+dLno/m18OYjWRLlmhRKjA014QInp36pJv+LU/uFBwX0Rx6pdOEzifnuRckZ2KZ3jGDIq+DGCYRrRpF9qVdFYJBpZiMsFvrXghQ0Z2nUkxVQk0M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750479694; c=relaxed/simple;
	bh=dCOfEuRYAdP2wsiIm13Y0g3+7qHnT1VWOzI4lgHfxi0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EJQYr88HsBaECE2BicXPToUyh3w3zLLQfm3Dmq5X6Kjxm/IPNYv5iiPCpPnLLAhYYrgVBUYRESZTYmvbD/PqIlD503oarMPZ7d5uOPb6E1RoCLuSKnQpMi78Rja0RFfW2Hv2BG0mZ4478a8eKarL0hCoEAksjBdKWUYya5Cn4j4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=B6kxVD3H; arc=fail smtp.client-ip=40.107.100.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="B6kxVD3H"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=deQy7lzyqbhWQjr5qG9KVXFz5iTfuiC3Bq3iBs558xRvB/W8b01pU9Zy+BjlmjPb2fX2edNVsiBnh6ikTzk624FNYaZMhTb4X+qXPLVBwwb+3wY52McpPw1LFl2AP3eN5N3z+mmN3YSv/zyHib6i60DP3YA4uCWDm14jSxBaTzuDTum6R9zsw5z6QGgX8mKQFr3TkPq/5IWCRbWhfKogGcYgP+0/jj2ENzKhl091M8Dx0zkJWxIF2GZfogxUgmfFFSx0ZWRGqRMmkAncqQqA5Uj9GN8eya3ACn0aymz4NxImBcKB8WtEMwsZGDZSsJx/zYcODTbtzae+jI+5KOIc5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v5jJ8n+EtfFv9cDVIlDdNHGufzfaA7lJO2j+NzWgp/c=;
 b=it7Pfx24S64VT+ZLcICigW4djK/4O3vt1J1VRKWQBK0T6VMjviZO98GMLWVoQt4be59T/Fw57KlD5AlRVDtjSuEm+5+XOC43Cj296SopofFPH8wJuHR8ssvVRM5pcnFiZOQTXEbQOan5BwHjSPdaRqiFR9QcKR8rDr65JOz4LEON36KOJZGRZCm2DBesuud+kYk7TQRlotAQ2hp3TAiOxYZmy8v8wOAs2wdm4qyIhfPU8ucEfZijSA5uy86cFJ25hQb8ywdORq+nPkHssPe8oxC5gPWSF/O3AeYxBtkHL4og42Sslqk7uK3LIHjT5rUVh3dUwsU6LQGY8cjPBbUVAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v5jJ8n+EtfFv9cDVIlDdNHGufzfaA7lJO2j+NzWgp/c=;
 b=B6kxVD3HO5WeEnU99jOC1Z0YcEuU9OgRcj0D0ZqyPYrgfzLYpwXqcQyvTQOgKAeQrtad8v9bJ5tvNS/oYqVxhXL0EbcpnAvhYfJEG/7FWdfqAsIjTBmSpqrSdvZp+cyjs6jqXmp+SkFcJfMIR8iAIVotr+zhvccPFMEBm2X1cJsDqJx08MA2yOPM0A69Gw3/PimLPSyz+LR2XolvVFtW60B4JMVltNlyxYj+X41sm8WfSp8QcO0cTp90wpevn2DRUxVvxxSzforYExQIr+CVsPDJpGEgwanht4ymNEADdWW+wxxFX2sXM5l35fJ0l+FiaNoJPh55zza6IuWLHnys+w==
Received: from CH2PR14CA0047.namprd14.prod.outlook.com (2603:10b6:610:56::27)
 by DM4PR12MB6352.namprd12.prod.outlook.com (2603:10b6:8:a0::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.21; Sat, 21 Jun
 2025 04:21:26 +0000
Received: from CH2PEPF0000013F.namprd02.prod.outlook.com
 (2603:10b6:610:56:cafe::87) by CH2PR14CA0047.outlook.office365.com
 (2603:10b6:610:56::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8857.27 via Frontend Transport; Sat,
 21 Jun 2025 04:21:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CH2PEPF0000013F.mail.protection.outlook.com (10.167.244.71) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8857.21 via Frontend Transport; Sat, 21 Jun 2025 04:21:26 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 20 Jun
 2025 21:21:14 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Fri, 20 Jun 2025 21:21:14 -0700
Received: from localhost.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Fri, 20 Jun 2025 21:21:14 -0700
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
Subject: [PATCH v9 6/6] KVM: arm64: Expose new KVM cap for cacheable PFNMAP
Date: Sat, 21 Jun 2025 04:21:11 +0000
Message-ID: <20250621042111.3992-7-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CH2PEPF0000013F:EE_|DM4PR12MB6352:EE_
X-MS-Office365-Filtering-Correlation-Id: 50eba1a9-52d2-49ee-38c8-08ddb07b16e3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|36860700013|82310400026|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?EUrtfx73MHsynccVJgt+lZgeytaF9+9morZsbGPe3OWCeaxsfQ1l+wD5D3FD?=
 =?us-ascii?Q?dOuNoGp3D6dsvD8BN/5ZEf6ZPw9cXzZGEohihpgeOyia2oetBIOBIT0iXuL3?=
 =?us-ascii?Q?riYR/cc2VlkdcGWjI3U9Un9yIgllqbHwmmoqfvqWsx2wLh9KkfU2q//CZ06M?=
 =?us-ascii?Q?kbAhUY9nB1FgmevSStPSZ93l/AtEPnd5XeVIxpLqqvF4agNM/62hsevG+hBo?=
 =?us-ascii?Q?Y8/oolp3RrJUKtaDLkRhFDyv4oxbNAqd80aOGp+vFYL4DpcuyzYu3J7wjRpX?=
 =?us-ascii?Q?bPPK8XzUFO8JMxU0HKwu66bB5o+9seBD0y/Qta3wUKwmkAGN8wg1LdcT+nCn?=
 =?us-ascii?Q?U2Y9XFMTMkGCKqSq+1kwqphNrA+D7h5VRWDIUQi02A5GmBB/fpJLW6nC1LrJ?=
 =?us-ascii?Q?QovRmefau93FLNQYkUtbLBu2IVC68ma/wPUVehdttLk2LTyH9xl4T2fXtRB/?=
 =?us-ascii?Q?TnHI7OWJEeiQsX2pO1mLCP/heYR72+6sn+90ckbfbhKv57uh+mdlnsa19Xkl?=
 =?us-ascii?Q?biamhVowJ6Nga9YQKHjIpJVHlvbF6lYygQLWCc3Ic9qZYZTXMukfpuDv5/4r?=
 =?us-ascii?Q?WIVpglTorUF4xAg2TMBl3pAEmJi5E91SyEu4iFr6t1KLiAuG1YPcfxeIsacv?=
 =?us-ascii?Q?uRRfmEAYD2xMexeS480uKXiykQSJJ1XEML1ILD8Y18ZChvNBD1lCwJc2yb3R?=
 =?us-ascii?Q?udlZaOw9zJCWCqdmh1WbRZlw5sN2ylGajUgwjkby/YEC+z1ZtTIxxAhPo4cg?=
 =?us-ascii?Q?H3w0Q5OnM4N99et0oMtg/wTHX04xn/g2lp+bE6lPvgzu7QWK4PV88UD2dgqZ?=
 =?us-ascii?Q?/kHE1Oxw2GZXZvWlQVCXrOBbntRua5s+5ddsgjPZSUvzJhGb8SFtnlM373bE?=
 =?us-ascii?Q?+dhmGIdyw21WOEoRoG+beout/SbWWPyfZ+eGoWYviQGL5hwJr6rRdnxcnvCi?=
 =?us-ascii?Q?TMRr0AGEceFcCn3hoogkdUe0k03gi4PDcb8YlhJWJavDY2j6+SlBY5PSR6ed?=
 =?us-ascii?Q?FaivIZE0rp8UG0CiiwqZGSGL2KgPoGfqBF4bPviT0yrR6sGOnAayeQpArYBC?=
 =?us-ascii?Q?nAsw0p42/tP3UVOP+LWwpySRtRsEDI1DoDnn5XUQBNeIvmW8WtY/61U9d26i?=
 =?us-ascii?Q?0b6459IQmaYgJhhh976zkWr2FDIoG0VWV5chXwWySfiwdVB5HWJZKSxHQYxt?=
 =?us-ascii?Q?3ghbus440GaLut07aVlxfY+JrrhVUiF7LGCQP3F1obn9dhxSR9HsqfukWAyq?=
 =?us-ascii?Q?FtKmm4rSGBBGDG/oJ/OAm5xyqI6uVzEPxIcBm5l+rgufBz9aBOvHOpOg4IHB?=
 =?us-ascii?Q?FJjLXQnGSrUKPfkRhi+GY1s8N5W7a6QOuAnBNjK0k1zwopBos2/xsseHNRPV?=
 =?us-ascii?Q?6jKzmns5YE1xa/UiwIdoA9Vcbz2H/tVznUjggrXWXwt3UcEF3gl9WFVXhxAv?=
 =?us-ascii?Q?Mq5xaW0a8tzCDl+S+AhDwPr/gqDCgeuA416sAYt2l6mFzQQaUveOVOC5vD74?=
 =?us-ascii?Q?n37SPZSoK5Z4zvwOoIdUmzDiSnhDGVBb9pio0LjHZJhsTOXFP2G2xSqC6w?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(36860700013)(82310400026)(1800799024)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2025 04:21:26.7277
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 50eba1a9-52d2-49ee-38c8-08ddb07b16e3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF0000013F.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6352

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
It could for instance be used by userspace to prevent live-migration
across FWB and non-FWB hosts.

CC: Catalin Marinas <catalin.marinas@arm.com>
CC: Jason Gunthorpe <jgg@nvidia.com>
CC: Oliver Upton <oliver.upton@linux.dev>
CC: David Hildenbrand <david@redhat.com>
Suggested-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 Documentation/virt/kvm/api.rst | 13 ++++++++++++-
 arch/arm64/kvm/arm.c           |  7 +++++++
 include/uapi/linux/kvm.h       |  1 +
 3 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 1bd2d42e6424..615cdbdd505f 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -8528,7 +8528,7 @@ ENOSYS for the others.
 When enabled, KVM will exit to userspace with KVM_EXIT_SYSTEM_EVENT of
 type KVM_SYSTEM_EVENT_SUSPEND to process the guest suspend request.
 
-7.37 KVM_CAP_ARM_WRITABLE_IMP_ID_REGS
+7.42 KVM_CAP_ARM_WRITABLE_IMP_ID_REGS
 -------------------------------------
 
 :Architectures: arm64
@@ -8557,6 +8557,17 @@ given VM.
 When this capability is enabled, KVM resets the VCPU when setting
 MP_STATE_INIT_RECEIVED through IOCTL.  The original MP_STATE is preserved.
 
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
 8. Other capabilities.
 ======================
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index de2b4e9c9f9f..9fb8901dcd86 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -408,6 +408,13 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
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
index d00b85cb168c..ed9a46875a49 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -934,6 +934,7 @@ struct kvm_enable_cap {
 #define KVM_CAP_ARM_EL2 240
 #define KVM_CAP_ARM_EL2_E2H0 241
 #define KVM_CAP_RISCV_MP_STATE_RESET 242
+#define KVM_CAP_ARM_CACHEABLE_PFNMAP_SUPPORTED 243
 
 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;
-- 
2.34.1

