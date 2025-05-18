Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2062.outbound.protection.outlook.com [40.107.223.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41AD81519AC
	for <kvmarm@lists.linux.dev>; Sun, 18 May 2025 05:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747547292; cv=fail; b=qO52o/hpJpoGYPJ4yNxDpNQYdD45PCxtrY8ESkhvfFGRXwc2gm5m+f3KbFL5FjvPJGOd3icIwJ7YIW5Izd0DJbKELB2FpvoGR7ACztVcKr0ih4f4jvEuOEP7c1Qh77s2aG/I2IQI/sFWOApezeQXsH9ZjcFvhdbDtJgbYvKrR0I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747547292; c=relaxed/simple;
	bh=54xOwlhldMmrTqqiQHhTqs5DlrLG7AkwS+su5Qdu2Qo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=J4fDMlG7F9PQPzsQBMZkJT+je5QwdHPifoYvu61DqZIJiUAWBJi2Y3eyhsguN6wTv1cCr6ocMzgeIIrVNs2NRTHq57M4YIi8zH4S+eC9MPX7eTUO9QBuN6DPiIE2IzTy9rXeRnjEwuzXsRh+GdDtfUvEoO3tGhxLYOXKhYIdy8U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=IJIL0nge; arc=fail smtp.client-ip=40.107.223.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="IJIL0nge"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bVG5OovA7gTBLeFPPYd6wTczbvJTk1A2awMe81Y4dFe0gW6QvI6h1Fwje6/SncRX/S3aOlxSjqV033ZN/sUe7jFsjWypVPvoVTlTAko5QRefGFaO6+sR+2aq5+9XFWVTBRJBb4IUnIrX8fQfg4d+sDJR4noEmFwxaAMKcWMWn/fh5L2SMoCI5DmyjLm/swsb8OthuWho7G6aKJ0EgMcI9E98isbxfBk7QE6POwf+rO7oUx1hzS6KioYVG0HClOQALEDbjlHrSobkEV97aSIKQO1D6X+gBAHGzXkj7H/mQWBWPX107EYqx2TlCRmaoP/sk9CZ3bqhFArQZX2BNIU4bQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nKlxtIgssqSkxqfKtBG6FY7RwwRkwbGS8IJNv4B3Gh4=;
 b=p8GTpkLGcNvxn3J6egxjI+Mi0Qjs00jkFWMkgSXco2EOxnbx4AYGPa/9zsJkwEC5PXSSe7ed1amKs5BNikC5wJJzENpswX7zLf9nFV09m5eSJ2qNj36A0em3TOpsH7afm3ItAxRxPJNOoJzJJA8jBIL44vuEbzGMgGAWEi3daM8QeVa7IJtVqe7hvUpg5YSpiSu9L3pV7CkMkYwCCniRYy5ET6bVi6vztR5Evp4lcutNIjGiJZUwZqSNNW3midZ6S4IDVMk92AXR8GRVUcx3gRAA9WHou1WwJ3tRzWRm5szExIiCQi7Jc8FSxOsJ/+eWeBNVvrBy9qqf3bjXTP6drQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nKlxtIgssqSkxqfKtBG6FY7RwwRkwbGS8IJNv4B3Gh4=;
 b=IJIL0nge7Lf7u6o14QY4J23t5xYqMXrbH58hg2K46YT7MswvmYMl/GqanMDlei7PsN4lrWxZLq8s/IfEFi5/yfkJO5LyJuhCaU0MSZG0cgLem8RhKjSNllR/ngmsEcOYHFe0YefXpywzlnCn96qjbHnmN2wggkDw04i985um/RdBN9mB8yoMWNzyIc+MWgEVqzDYSG3SolKSOEr18yKbpQCXwJGsXcvaZ1N3XEIAnch1HC6oPEVpafEE4TxdWJD+klDOyhocYTX5nxyp+hiTLb9WfWmx+TRbt4Q+R03XnvMxgALRgXTVdvUzVQPpa6ktOZE7fUTi4xEaZiFTV/GIBA==
Received: from CH0PR07CA0025.namprd07.prod.outlook.com (2603:10b6:610:32::30)
 by CH3PR12MB7667.namprd12.prod.outlook.com (2603:10b6:610:14f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.33; Sun, 18 May
 2025 05:48:07 +0000
Received: from DS3PEPF0000C381.namprd04.prod.outlook.com
 (2603:10b6:610:32:cafe::f2) by CH0PR07CA0025.outlook.office365.com
 (2603:10b6:610:32::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8746.26 via Frontend Transport; Sun,
 18 May 2025 05:48:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DS3PEPF0000C381.mail.protection.outlook.com (10.167.23.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8746.27 via Frontend Transport; Sun, 18 May 2025 05:48:06 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Sat, 17 May
 2025 22:48:00 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Sat, 17 May
 2025 22:47:59 -0700
Received: from localhost.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Sat, 17 May 2025 22:47:58 -0700
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
Subject: [PATCH v4 2/5] KVM: arm64: Make stage2_has_fwb global scope
Date: Sun, 18 May 2025 05:47:51 +0000
Message-ID: <20250518054754.5345-3-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF0000C381:EE_|CH3PR12MB7667:EE_
X-MS-Office365-Filtering-Correlation-Id: c48f7870-68cb-4244-c805-08dd95cf905f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|36860700013|82310400026|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Dv7CAc6UQgLW/DRJaI4c9jBYxRnaiu+tZPDVRX8qN0IhbB7jM6FI20rAwidu?=
 =?us-ascii?Q?s9PD/N+ckj8qTunG2HEPma/Xc0tMnYkVv5aBxv5l7b+BpKjlYoP+QFH72e8N?=
 =?us-ascii?Q?at5vYLhAHMExJOzQwUFemBYVN2KRwyWNgeZyD26kdlP7wArCEfq7A4p19ZvJ?=
 =?us-ascii?Q?ZkOMZgR7DumzmZ04xKa7gamdcMUUAwUrRFzOcQaszmNWe8zQbCitwlLadfDW?=
 =?us-ascii?Q?4JVRcmO6kwbZW7Gsbl/Sb/Pi1lSHqfI5MjlEes5LrKjZ1B0QVrbjgTIm7CAa?=
 =?us-ascii?Q?CFQaLlYNVYYTmYzGzelGMjrSvJpuxV2rBybl9+jj2tXR2TE/lotGie+wc5uq?=
 =?us-ascii?Q?eWmrsC5Crg4ljxsxVwEhVLMlbDDc/uDMUBkFnBY/xcLLbrRm2Ad96j4Hns9z?=
 =?us-ascii?Q?bXSfGaXje5tlRpLJFTvbTWXL0oLcDui2fRqkWFnJlZ0j3SK5K1fgoSmYYGkN?=
 =?us-ascii?Q?HwzrPx8NddFkwce/xKIBD6xtMGYeNAE/oJrYivov/OqFUU6C2WRqzDvQbBw8?=
 =?us-ascii?Q?yU2cc3/QuXzX0fwZe/Awh71vRcjdFmhMp6cwMibL1TCGx5J2cEq1CMMgpJMz?=
 =?us-ascii?Q?WcINcUuhb/8AXZc4BZlzcjZAXuR8lo/2ujAgTUkGbC5ne+TM0PO22vf0okep?=
 =?us-ascii?Q?4u0HpYZEwMSww35YJgGrPKNFcM3QYB+spekQUXBBa3vFQtApID299ZOa3sUr?=
 =?us-ascii?Q?Tk4ocUFAHyGMQ5pP7q65ziGc2YIf7Yj3FRm+/ZkAEOue3CqC+hF1M7IrX7LM?=
 =?us-ascii?Q?FJGbv2zO5GJsyL4xHNmVfDwf8lfDNnLong/DOC0dj3x9oZkhkZj7MUO8PsVQ?=
 =?us-ascii?Q?9x+rxGuH5ruw6mz5npZeZhfEK6yE+fPS8EalY9e2lACxPqPuNnIzaoelDxbM?=
 =?us-ascii?Q?IsgS7dLg+u13mM70jN8vmX8NEybn13pPBFKakQ/BeQfTHnCLRrg0Eosiqwyt?=
 =?us-ascii?Q?iiauJQCdoyat4LpEReHCb+a9uIhm1lqMRYOhugin9Uex4si9gCmmncEAyObf?=
 =?us-ascii?Q?oGE+BY9+7oEO1YCH9MWgRfUGj/7DQCM5g6hQw6kQG1592m/+o+dWK+KLQSjJ?=
 =?us-ascii?Q?QRfhtwH3w2GCXY4siIKgoj5RNlkL7oFD0u9Ec24+0vcTDdayyQ0GHBj+KHfO?=
 =?us-ascii?Q?jTmGi5YRzKVe+/QTpn84x83HfWniEvnK2QGtdkqSe42EUcxRN7Hpx/WqYCN4?=
 =?us-ascii?Q?ABWP24kWcqPI3t5eRyToy0WI2wxlDsjiyfvWhiKFmOfIyHUDy5MlkllFwz26?=
 =?us-ascii?Q?gwASPNL9C2Ga/xiUpR5QVnfwslibolmpGuT7CC9a54e/LqAZr1v9gmQ1wXY5?=
 =?us-ascii?Q?37cyvEKOPdz9gmneVlXqqtrfFve9JN1HNUIkcPPZBUc8jP21y1ZLMtQO2uD4?=
 =?us-ascii?Q?TRkLraeGdwHeajkl1jI2chBDT+Y1+tcgz2FzCVKI0MDMl67oT+sYsJiNKhjE?=
 =?us-ascii?Q?LmaOPJchpfZitUoWmlOYFZ2S6Ye6bk4kWxPtjP1+w9deiUgy+nrzP1ew8fP6?=
 =?us-ascii?Q?Cyyq/VQznUIjjJkjsaCGj6g4PnqtEUmIyRr3K8fnR7wvp1eSZmvaHjj/XA?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(36860700013)(82310400026)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2025 05:48:06.8862
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c48f7870-68cb-4244-c805-08dd95cf905f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF0000C381.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7667

From: Ankit Agrawal <ankita@nvidia.com>

Change the scope of stage2_has_fwb as it will be used in
broader KVM code to determine whether the FWB feature is
supported by the hardware.

Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 arch/arm64/include/asm/kvm_pgtable.h | 8 ++++++++
 arch/arm64/kvm/hyp/pgtable.c         | 2 +-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 6b9d274052c7..f21e2fae2bfe 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -507,6 +507,14 @@ u64 kvm_pgtable_hyp_unmap(struct kvm_pgtable *pgt, u64 addr, u64 size);
  */
 u64 kvm_get_vtcr(u64 mmfr0, u64 mmfr1, u32 phys_shift);
 
+/**
+ * stage2_has_fwb() - Determine whether FWB is supported
+ * @pgt:    Page-table structure initialised by kvm_pgtable_stage2_init*()
+ *
+ * Return: True if FWB is supported.
+ */
+bool stage2_has_fwb(struct kvm_pgtable *pgt);
+
 /**
  * kvm_pgtable_stage2_pgd_size() - Helper to compute size of a stage-2 PGD
  * @vtcr:	Content of the VTCR register.
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index df5cc74a7dd0..ee6b98fefd61 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -637,7 +637,7 @@ u64 kvm_get_vtcr(u64 mmfr0, u64 mmfr1, u32 phys_shift)
 	return vtcr;
 }
 
-static bool stage2_has_fwb(struct kvm_pgtable *pgt)
+bool stage2_has_fwb(struct kvm_pgtable *pgt)
 {
 	if (!cpus_have_final_cap(ARM64_HAS_STAGE2_FWB))
 		return false;
-- 
2.34.1

