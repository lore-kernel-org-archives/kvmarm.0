Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2085.outbound.protection.outlook.com [40.107.237.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0626D28980E
	for <kvmarm@lists.linux.dev>; Sat,  5 Jul 2025 07:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751699867; cv=fail; b=ejdIrW48QDUtzomw39N249mBdC+3F764uu6BpvByxST2vcgw61/JOU1WsF4LPoPqMU/j9NaB3UmdJ8ioaV8dXPUDaalLqZT7Ly+HoiUuybGQMi4S69gFsU/Q16eiIbCcPy/jWTyY2IqlnbQplA0002GWmAn6U8J64D4lkYisPbE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751699867; c=relaxed/simple;
	bh=aOkMKc69mAv+aG1DKjrAA8VaFwTqhtXAyarylE+Sg5M=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rGs9fNAD2CGkCApX8TTo/N8H0aVhA3jZKvDxM/GqGG62fUGkI+nxer87+51/rwsEbbFyLH+P0xbbDDA89OOvViEeGTLXD7tPbN3xUaCA95C2zQJRowGw/m+84cGh0bN/i0I5m6MlmLbVHgHxKDfY6gcNazhY+NS8blgemMPy/hw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=rVeKoCOY; arc=fail smtp.client-ip=40.107.237.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="rVeKoCOY"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=f16ZxVriWcCmlWGR1unensQBkJFHEUa2+UGbzs6R04mbe3QHQiQHB7xZ+2WnQvMH/M3ElAQva7mT9GWR7ZXDNONscSMoz+I8FyfOlxoTLPXXwo0l8zM9qsWMBT4ui78pHY2hJ732Op/oBw1jnA8Zga1Ukf/hoFA122r3uwJuaNx/Ncv+XcoP6YcjxlaUJHB5g4PY3/hUIIV5SyFKaedtuDzl9W+YSamGl6ZImullSAZ5LO/0B1H80y7qwKJySs7/q/aKZ8T192ascfVoKVzpUaTuO629WjO0OM7dbrb2yvfQhIOHdSGR1tTKoFb5GdhA6TVGGlEbTF/ClGoBNHhDog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9BTGKYCMzZAm7U1kHldoTJky4SHTDmrEgJiQss8H/t0=;
 b=ZB1bOfTkxENe00XsC7ShE4g2lWHPURCwE6kvV+y5V8saC462dQWl/gg+t+aR6VRiWIc5pRm6Kl2Zr7GrBW7QzkJ61o/Q/ecNKMfuCXWSVs2zRjQNLNt9VXVL5eejBdHF2iHLu13bLO/908kekPWR5xhuNZxNmGbEnHnTyi8n2Zqi9ZP8XpPNXWxQuIaK5sEUW0SeICbW/iTv4GI/SWImRGNt4IHMgTdbqsV3JXdS3yzaPMAimvRybWyzPzEPPJJzvt41P4ckMsYB8ylxDBnSRZHIL5h2hST0UsVEuV90gL0mFUm8O/cw8qkHzYJqv/hNO55sXMiq4h1OZPGxghfGYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9BTGKYCMzZAm7U1kHldoTJky4SHTDmrEgJiQss8H/t0=;
 b=rVeKoCOYG62auxln06uQY6tFTxkExOJRSvgwPXvMtJNV7775vv+GwlnaxiO6MzVv4taKE19GQvZ3dOnA22nWEpl5v5f23wpgDCrQcgrHl1DXbyX87DB8ukohq6a39uT1zujBhp1HJZhYVmJdVuEz3OfLEe4+ygivRtMfvFbea5Xn1Xf4Nyrv9ZguTvxUihfuIwECRIN7rNY3HcBaTQe3FvJv4xkTQdYFDT568gNT729sxFfgi4dXpEOpgftPHrNpCz/whELxkiMHYwdCC+CH8LY4yQVgT7C329ror73n0AWIdO7tTTHwDX69hducU5ABpwrVP88K6xSadLXMoPtRpQ==
Received: from SN1PR12CA0046.namprd12.prod.outlook.com (2603:10b6:802:20::17)
 by DM4PR12MB8451.namprd12.prod.outlook.com (2603:10b6:8:182::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.22; Sat, 5 Jul
 2025 07:17:37 +0000
Received: from SA2PEPF00001505.namprd04.prod.outlook.com
 (2603:10b6:802:20:cafe::5f) by SN1PR12CA0046.outlook.office365.com
 (2603:10b6:802:20::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8901.23 via Frontend Transport; Sat,
 5 Jul 2025 07:17:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SA2PEPF00001505.mail.protection.outlook.com (10.167.242.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8901.15 via Frontend Transport; Sat, 5 Jul 2025 07:17:37 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Sat, 5 Jul 2025
 00:17:27 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Sat, 5 Jul
 2025 00:17:27 -0700
Received: from localhost.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Sat, 5 Jul 2025 00:17:26 -0700
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
Subject: [PATCH v10 6/6] KVM: arm64: Expose new KVM cap for cacheable PFNMAP
Date: Sat, 5 Jul 2025 07:17:17 +0000
Message-ID: <20250705071717.5062-7-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250705071717.5062-1-ankita@nvidia.com>
References: <20250705071717.5062-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SA2PEPF00001505:EE_|DM4PR12MB8451:EE_
X-MS-Office365-Filtering-Correlation-Id: 156b0b90-04fc-4b70-ca26-08ddbb940541
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|82310400026|376014|7416014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?7mq5rqkDF9/PJhCouC0nO2d8H2IRBRbQBgejhAi0t+Q4XC6wzAp1CTtMuvcM?=
 =?us-ascii?Q?wNzBBTvgzRzQbcopuixvRy670rdCF8izJ2ncCVRIjljZOZjv2Wh+ZkkZ6HIN?=
 =?us-ascii?Q?YMMmhh8DCS7rntcqBNsDYeeGnHVth3LGm6YVtuAOzwHUlg+qCQ3tWLmdEzhf?=
 =?us-ascii?Q?s6kg+kjeK5ea43HmSZZQulS5S1nthlrjLhjedfGaBJh85ym+i54Gla6A81d/?=
 =?us-ascii?Q?55VXqtky9c4Yz3yGKnH77TmBz6jQWi3uynfyEdr1RWrw3DWqPiIPWtCSY/dd?=
 =?us-ascii?Q?1A7zb90QBtINe5lktqIGKnuDz9nTLQ1H4aanJkpDRbw4vo1MmV2nAZXIUblH?=
 =?us-ascii?Q?TCsY/bRKoEtRC520Dwf41lvw8PxgH9TSZ1DOEV0zER1k+fTnoPizFmP0eU6M?=
 =?us-ascii?Q?R/cRq5VoZRxUc6v8ZfGaBDp+nI4RxtURTZ/MM4O9X6syRaqafYSfBDh8Rk4+?=
 =?us-ascii?Q?SgRDJtyR0kueILLhTfQ/3gbQTs6/uxSCkFk9pYvYad+QTdG5zO7O8psvPwvY?=
 =?us-ascii?Q?FXRlyMpRbI/7nTHL39NwtM4inQYmoU4zoh/XTzzFYWz1wE8cYv+7T2TuWfQn?=
 =?us-ascii?Q?98N111GU0aqHEpvOZKZJ4Zzl5v6HiBbDcBsRQX76T+b1/dUQ324uR6iqRDmo?=
 =?us-ascii?Q?Fj3WRJx9/H3uTmZie4fzm4rxndpRiO/77gj1Abk61SxuJEIcD3nnw3eVh0CO?=
 =?us-ascii?Q?iFR54ZchiQ23CW4l0FIIPkl2FbO0bVwTtgFgQx109vdhdDhmu2XFzHhl4dCV?=
 =?us-ascii?Q?6INQAdwhAGROG1lSa+/9EMqCyrMp5VUBv5dOhpGYEnwFmO2gCzpOVFDPqxyS?=
 =?us-ascii?Q?tvl37ctKz6DYztVbDskmSgv4trzOWdIcDexjjpN+3RYLE/lkj9ge7/13erT9?=
 =?us-ascii?Q?VtMXM5qK+0HAhjxSXdW62GNCT8t6ywRuyRWWhMMrrvRAM5Sdh0SlGtBKzjEa?=
 =?us-ascii?Q?zsBgaN47A2Htsua8k1xiospeE58aZ4595KAfanTb5Hp2k7CN/gki+sX/iiP+?=
 =?us-ascii?Q?Dd0/PSID0H5UrUkjIZ8ZhWOn4VbjE92K3FoQJDYbHeyD+bB8tytRHhIwJZxh?=
 =?us-ascii?Q?ApMOEnVb7XuMVugU8jAXqNrgtqYgKuoNOE38O0kZBnbRKIVemJZq6tIG6WFP?=
 =?us-ascii?Q?KzOeA6s2tQQGwmNhnDtA5pGOjR3zd3hqrgg96MbsIn9lK+VYCE2TbLCWecvY?=
 =?us-ascii?Q?WRlwiadKvdkxb4ZGhA+cFurWd0aJVrG+d2UB0J0sJc0sZ6N54sbyE/YZcEaR?=
 =?us-ascii?Q?m9I9weQXGZw/3U0bxtVNJop9ELMh2HMo5i/O21DuI11W8dF68F2WeVuzWlzb?=
 =?us-ascii?Q?F9tu5O6UNFDcUO1pi8w9jxYSM6Y5Km9IZTCA+isquEV6lmsa3Fqgv/rjtP59?=
 =?us-ascii?Q?PfV6Sa2gYxvblJnNnJUGPrJWXjNXV0z40CR+yA7l9GC5DYwu1kEtsowVqSGS?=
 =?us-ascii?Q?ErnYCqra7x1yB0Bs3ata0TfgFQ3eEXcmafmVt67B55wVX0Ctv4CfhF7xqloR?=
 =?us-ascii?Q?Q/8RidHhenqaK46G/2N+AICeF1wttl3tEutda+IFKz5O3Rkszbewx4DB/Q?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(82310400026)(376014)(7416014)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jul 2025 07:17:37.3593
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 156b0b90-04fc-4b70-ca26-08ddbb940541
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00001505.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB8451

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
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Tested-by: Donald Dutile <ddutile@redhat.com>
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

