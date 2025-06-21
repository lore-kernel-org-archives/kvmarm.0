Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2063.outbound.protection.outlook.com [40.107.236.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24F151898E9
	for <kvmarm@lists.linux.dev>; Sat, 21 Jun 2025 04:21:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750479688; cv=fail; b=BpWTnMvRiIRnKAQ41K8onv6wdyoFaY/vzqA3U4N+EjvPIyYwYtsMF7b0RHU6w9tbDPUnLM1QGTBjhDrZtHpaKor3wANlSsSKv+XWKL49kGm2B8U631q3H9zRREHncqMV0vGFtoJQ6jF4FXF2oNRgCWytRLn+KEE0cIIp6FoPyq0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750479688; c=relaxed/simple;
	bh=dysODe5K/JGNI1C99eWlAizNObXue0iQlOqwbJoo9H4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SjA8PL5qcTzIs+oHLoFjHJiMEBMDfqsmIAV+9NmXw/ktpDjz61zUApyzFumwg5zVoHzcGdF1ZezuWVUFZt6qx7V3mslCZEDDn/4t/bS3p4alg8OhCSmGZm9LnE++j/O8tVQ6+KYjcc9rMRQ3dC8AW4o/CxeXNgBL4CTVhybddBM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=HgufHmTl; arc=fail smtp.client-ip=40.107.236.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="HgufHmTl"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IXnrnzsDF9GQYwTMB0qg06WyT0F6dPEDELgF6CeoNRIRsqmN7G70eQ7xtOdpmrK+6XEG3yG9I+loEGfCWPz2q2zsocz+10ioN8yTbHyxp16SSjghFmanad8q0RXSU2vuNGmmPg3QOxIxl//K3GpWH5jAHeFlKc12cNaSyCCVdaM+SroKLLSi3OJhLp5OcVziZWpftpAfjjdN2S+RKGdZpSUR85OACALOQawZ+UBAY20rSfkhAbw+NFEIUhoiOFkj2L2/6QBd+bndcd08M76tacvaj9MQTQvyASVCoi0cL/lMPTBQNnwQ+C15PcDmC0O75DnqkovCILChgdoriOOslg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YhbLla8v0WDPidQ8Xb23ycVc5S2jFjFD3o4RNS8/GHA=;
 b=dt8tN/DFihmk4SX4LOfoRVuQIbcTW2lDi4aZz1Vfg+Vp5fqihHmupYBa6Ptfe90mvSDRzbd7XymHPOtFACua4LQlc3IuySo3wpTgHqqonqNPbH8u1JTIKm5UEHr5IM8QmfCeDJwfkJ8WEmYf5BOo2OHQJtT87tGA1o3qY31dxVGEk1InXkEk6WnE3tleqOkf9bM7/+atSfo6MhNhq5ptzccUBKF5C884ayPRjjdjEoLuTEFf06Yd2+KgWBI8t619adzPWtkg3ooC/XqW2bi5Oq8Is+IHgk9C3AT5MUPMQocMqaIIn5vsB45y5fQKNJEchqvyxwrT5aMA91/YLFUEJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YhbLla8v0WDPidQ8Xb23ycVc5S2jFjFD3o4RNS8/GHA=;
 b=HgufHmTlm54OHu62Osn8IrhjCAcUOih/yjT7UHl5eaJnu/9iA5Q5lLDFX7HeABjs/+saLL3a+/jC5PWlJu7lP9rVdjg9rFrK9sCPmcwFcJf5FlQxrxMeS+1FXpz1y8wyKdW+TAFitnqdiq9nMcocbGFANVU9sllfA4Txo0HPxXzD51THrGYA/C7Wg59SUaNBgQ9XTPxdcAVsDFNFULbny4z4IMR/BsxfOeKxl+wFfPYVQQqfL95EVSOIfcfdrsjbHxk4/3ZR73rk2DuhOtvUKqr4aR8U4jSLjn6HN8jjRNgjJtfSATcRRTF7p1rpzrs+lVzuQEjpIGkR95CZieSFHw==
Received: from CH2PR14CA0040.namprd14.prod.outlook.com (2603:10b6:610:56::20)
 by PH7PR12MB8054.namprd12.prod.outlook.com (2603:10b6:510:27f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.28; Sat, 21 Jun
 2025 04:21:22 +0000
Received: from CH2PEPF0000013F.namprd02.prod.outlook.com
 (2603:10b6:610:56:cafe::5f) by CH2PR14CA0040.outlook.office365.com
 (2603:10b6:610:56::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8857.26 via Frontend Transport; Sat,
 21 Jun 2025 04:21:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CH2PEPF0000013F.mail.protection.outlook.com (10.167.244.71) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8857.21 via Frontend Transport; Sat, 21 Jun 2025 04:21:22 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 20 Jun
 2025 21:21:12 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Fri, 20 Jun 2025 21:21:12 -0700
Received: from localhost.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Fri, 20 Jun 2025 21:21:12 -0700
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
Subject: [PATCH v9 1/6] KVM: arm64: Rename the device variable to s2_force_noncacheable
Date: Sat, 21 Jun 2025 04:21:06 +0000
Message-ID: <20250621042111.3992-2-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CH2PEPF0000013F:EE_|PH7PR12MB8054:EE_
X-MS-Office365-Filtering-Correlation-Id: fd868bd5-cd79-42b9-9fd9-08ddb07b1439
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|36860700013|82310400026|376014|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?h7XfiP380ukc7G2ma364RMyIbo326GSC0voP3DzjhiO/vP4I556/uYu3adJU?=
 =?us-ascii?Q?mpi9sOKZbvpiU5tbs+XYBjMa5ENI1w+gvRvf6Jd/avWGOj/sOQSWGb0sus2E?=
 =?us-ascii?Q?82wsjs4eDwGVwk+Gko2bwQu9OqPN2eD2vobCp6fem4fnDWo6xt4DijWg7bQ5?=
 =?us-ascii?Q?40WS9UA+Xzj4oAEWYMV9cfvRtQmIsJDTyIqJqBwQJFQOY8Yr0eIWcga35GKo?=
 =?us-ascii?Q?Ew2yUjz4EPhafBYkkvlUfM9e6Wa7Nw33przg7B7iHczDmoccf7VHEpb4RG+F?=
 =?us-ascii?Q?l+Tam+S8OJdakvCva/Mu5DC4eMWxWt4A1CV7yLBa8tyTheKW2EnH5Erj//Bp?=
 =?us-ascii?Q?Iesr2Sp3X0Mr6+YGDrBUCoec7AJFFaIBxXMMgo9dVsUcsvfM6QKoSWhvcnn+?=
 =?us-ascii?Q?SQ2fostevbUQ4R8gALwLtd/SntWPw7IpwvovxHdhZZoQwj+2+z1ueGBQBIY9?=
 =?us-ascii?Q?b9FXBjUHbS02OtVPIqSRZ8adAW8ZhXZtSFoWpqJvqG//Pr3nIz6CeIYhcosF?=
 =?us-ascii?Q?oX6zmpcbGFPmbObguZ2HO3pCVNg2RkIYDg88B/4CtmmIR2yDO5kP3TSP92UP?=
 =?us-ascii?Q?vxE7K7/UsJchaMwM4oxvyeDlWPhBJ81shEqkJDR/JEYdBZS5nBS/Zo9vfwe1?=
 =?us-ascii?Q?OJSTKz41seK+kzDVqLAUB2YFit1gSsbr87ABX2UHU/Wc/3MQ7y2V/kG83dQQ?=
 =?us-ascii?Q?0FXhCHEjYelwGfsyGaPVJm6n0a61jToY7vLcWVtYv6tbXrS1p5NpB077G3fS?=
 =?us-ascii?Q?rNsXbzCP0K1mIA6ckRIYqzWTCecuNN03P5iqKmvTG9EqZnFWKqHi1qkrgKGB?=
 =?us-ascii?Q?DtsdnjBgjIhH+uPztWj1h2X/Kdm7ROG1OIyzs+xkdw8Op1fnT0m2Es7NiRdl?=
 =?us-ascii?Q?P9oYINCUE43T7CYHnaSmhm6r/GGJQToyaB1nhbOUrYs14f0FI7oOUSgYXl9c?=
 =?us-ascii?Q?2TSgYVMo5qAjdZ99uSGRj4znnAmDC80cKTmAkcTZZHt3MvV4U1a94fj2Pxld?=
 =?us-ascii?Q?miHEFf/t1Uhf9hLo3BE2e3SFJApXUwAYuhmYJBHCAnoeX4fqXSNQV1q1dOMY?=
 =?us-ascii?Q?xJpcxjVIilTGlFdCR7yedoppTEcZ8GASttOlBfE3J9smQWXMiWeDO/64rnWi?=
 =?us-ascii?Q?dN1rVohvPi+4DKaWY4P5K9M9+qvr7aErWeRaXWA/DFII2HgRRfzkp7794Q9h?=
 =?us-ascii?Q?Uhi6eUrZ4U+raI6JcCwKjrznF7oi8+9cYuldlFOXvPcBn1NJYbCc9fTt3AB2?=
 =?us-ascii?Q?vH/hlYz2UPXYp+WWq971iL6HgD9Iv7ajLqIaNzD4M4Bj6b6flw4EYFruuXS8?=
 =?us-ascii?Q?CrY+ibMOY/kQQyNVhFScWpTISr+pJz839QMIMtfZ3dp0NKDmK3OhUUswfUld?=
 =?us-ascii?Q?8dgVkzqiaW90oo7dZgJMIyq7W51etroTC76qeQuFeloUE0rPVWi3orPCnSmL?=
 =?us-ascii?Q?soW1k6LPR94th7FyNxbInYLma6/cXrhCB7PJ3anH1O6iwqEtb1s4aEqXtywh?=
 =?us-ascii?Q?ybvM03iSH6P7btTJSP94GzjRAZ8lUkuMJpGRjT6n9oalpUXvyInDhIJlWg?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(36860700013)(82310400026)(376014)(1800799024)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2025 04:21:22.2607
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fd868bd5-cd79-42b9-9fd9-08ddb07b1439
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF0000013F.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8054

From: Ankit Agrawal <ankita@nvidia.com>

For cache maintenance on a region, ARM KVM relies on that
region to be mapped to the Kernal virtual address as CMOs
operate on VA.

Currently the device variable is effectively trying to setup
the S2 mapping as non cacheable for memory regions that are
not mapped in the Kernel VA. This could be either device or
Normal_NC depending on the VM_ALLOW_ANY_UNCACHED flag in the
VMA.

Thus "device" could be better renamed to s2_force_noncacheable
which implies that it is ensuring that region be mapped as
non-cacheable.

CC: Catalin Marinas <catalin.marinas@arm.com>
Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 arch/arm64/kvm/mmu.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 2942ec92c5a4..1601ab9527d4 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1478,7 +1478,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	int ret = 0;
 	bool write_fault, writable, force_pte = false;
 	bool exec_fault, mte_allowed;
-	bool device = false, vfio_allow_any_uc = false;
+	bool s2_force_noncacheable = false, vfio_allow_any_uc = false;
 	unsigned long mmu_seq;
 	phys_addr_t ipa = fault_ipa;
 	struct kvm *kvm = vcpu->kvm;
@@ -1653,7 +1653,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		 * In both cases, we don't let transparent_hugepage_adjust()
 		 * change things at the last minute.
 		 */
-		device = true;
+		s2_force_noncacheable = true;
 	} else if (logging_active && !write_fault) {
 		/*
 		 * Only actually map the page as writable if this was a write
@@ -1662,7 +1662,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		writable = false;
 	}
 
-	if (exec_fault && device)
+	if (exec_fault && s2_force_noncacheable)
 		return -ENOEXEC;
 
 	/*
@@ -1695,7 +1695,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	 * If we are not forced to use page mapping, check if we are
 	 * backed by a THP and thus use block mapping if possible.
 	 */
-	if (vma_pagesize == PAGE_SIZE && !(force_pte || device)) {
+	if (vma_pagesize == PAGE_SIZE && !(force_pte || s2_force_noncacheable)) {
 		if (fault_is_perm && fault_granule > PAGE_SIZE)
 			vma_pagesize = fault_granule;
 		else
@@ -1709,7 +1709,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		}
 	}
 
-	if (!fault_is_perm && !device && kvm_has_mte(kvm)) {
+	if (!fault_is_perm && !s2_force_noncacheable && kvm_has_mte(kvm)) {
 		/* Check the VMM hasn't introduced a new disallowed VMA */
 		if (mte_allowed) {
 			sanitise_mte_tags(kvm, pfn, vma_pagesize);
@@ -1725,7 +1725,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	if (exec_fault)
 		prot |= KVM_PGTABLE_PROT_X;
 
-	if (device) {
+	if (s2_force_noncacheable) {
 		if (vfio_allow_any_uc)
 			prot |= KVM_PGTABLE_PROT_NORMAL_NC;
 		else
-- 
2.34.1

