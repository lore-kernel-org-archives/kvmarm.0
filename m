Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2053.outbound.protection.outlook.com [40.107.92.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 080F41991C9
	for <kvmarm@lists.linux.dev>; Sat, 24 May 2025 01:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748050811; cv=fail; b=RUT0lLAEZ26qNJ/Qc8v/lSzOzOup3iKcoR+cLNnXrmOYWJ9ej7YZ1o21wGswlnoDaBFuZKdjvMbl2zmk2voUzeyh1e8ZHWWbHbz8mUZOTmnXylcMoICQWtGXLps3vBZulWxlW2u6MyQdzcoKmyAUq+jX0eEmXhdMk6ltaGCEeRw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748050811; c=relaxed/simple;
	bh=F+0e0RYKO46vjRViwito35uPOiLboGIs46G0rA6C+cU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=l/7Ynb4d4/Ms5t4qag6rw7ah8JKYKDi/XekXcjIWiy0R91FuGIUci93YlG7N5/AMJQ7vXPwrzvn8OgHY34GZa1g3tOsudC57Fq/3adcWstzGyDHE+BgyYWWsax/yQw6jyrhYusU34UFyyz6+dhOl2eBv9qcwr6GD5Up5auzAaMg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=dGszXiNT; arc=fail smtp.client-ip=40.107.92.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="dGszXiNT"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=M91IWNFDUlsDpmyakw3JURmFhEuLuBwzqC67cr2K3L2Vqf6TQBkCmYo+ibMlh+UoKrSWovE+MtaHljHSU5mHJ/RX+cDzHIxtZe8SIBYz3wsKiUGMWOXHIz4/NX7K3fZOSudyw70n02liyADLj4cKYtCU6n3Ib4aujEIhIsqWG++64/qy1J5yMrIwB2+OW3DOo+VVXUnNrbwfgHkZ8zV3GgSZJCX1NBKf/KEQ1hAtO5fyTxeF0wGpYom9RtZJKpRroCKK0jQIR6PfOjaJM5GkiaTikCKYpP7pVQ0QgcQTxiGfnJTG02/r986OB+RG4StueyQD4UoZGzpZRS5ku6i3WA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o95VMtW+3WjKpHbHaHSt6KuOSqKj2ku7WMRMg1uQq34=;
 b=Gv6WnQ1yPWoWW5/suhhO+E+YTDjcUawB3osFFC4T6TFEKTzM/5J/cHaqIeIlqI/oyuoGWj2Fd4onbj0qpY4CR9djEEKJRrecfk0QcGX0EWSjaoTiq86UxIcdGIjUd86QFzFnRFo2jvvnCUT+UG2/We6IkxhY9u0GMF3RMSBQzIUlHZYHmcJa/0IoAeIW6QJMWyatvYdizhLouciFOssDo3YCsJlFi6QtbN23EpvqY7HjdkatfLhAD/qQ6WLPAQJ2vHnb4Efpm6j0UqkE89whXyM5jAZJExj5+DhFKKp4dbDp4JizXyRFCztV0PMppPeSrKrMg1sQXQp21wsZDMGvtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o95VMtW+3WjKpHbHaHSt6KuOSqKj2ku7WMRMg1uQq34=;
 b=dGszXiNTEf+8hfiqcmkOk8De7kKK366i8AoIwK8+5N5jw/KegW3boJPoy9u5xuGzov+rD8qH0b+hKnGnkkQMkwi2ABqKSOUyUjmYQ0dUHfmXF8ZrQGa1QpFUoDtfeqKsyC17G1HA8akJ+1WRzGk6TMQg0w+yT44w9FvIbABqoY551R04TtCPoR74OAt/ckRfnXFKS238grkkAuM4QfQhqCI7B1Fdbu52JbsFg+bBMGtRVUbHGFHFPvZhdqcszUIwnfum7cxMh/WMAQpp/c5ZXewn3gnaUBBgKpoDOCRS8HaQZ3Ctb6q8RoE0OwMO094uVElOk3kPC4s0YkXyfTf6NA==
Received: from PH7PR17CA0012.namprd17.prod.outlook.com (2603:10b6:510:324::12)
 by PH0PR12MB7981.namprd12.prod.outlook.com (2603:10b6:510:26c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.24; Sat, 24 May
 2025 01:40:05 +0000
Received: from CY4PEPF0000EE31.namprd05.prod.outlook.com
 (2603:10b6:510:324:cafe::a3) by PH7PR17CA0012.outlook.office365.com
 (2603:10b6:510:324::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8746.34 via Frontend Transport; Sat,
 24 May 2025 01:40:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000EE31.mail.protection.outlook.com (10.167.242.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8769.18 via Frontend Transport; Sat, 24 May 2025 01:40:04 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 23 May
 2025 18:39:50 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Fri, 23 May
 2025 18:39:49 -0700
Received: from localhost.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Fri, 23 May 2025 18:39:48 -0700
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
Subject: [PATCH v6 3/5] kvm: arm64: New memslot flag to indicate cacheable mapping
Date: Sat, 24 May 2025 01:39:41 +0000
Message-ID: <20250524013943.2832-4-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE31:EE_|PH0PR12MB7981:EE_
X-MS-Office365-Filtering-Correlation-Id: afdcdcd1-2b6e-4285-b15c-08dd9a63e889
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|1800799024|376014|7416014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Sq5VOmmicQDeKEMiCdBcvq2dTIdxjQpIB1/+eXgdqmu6xkWKmuw6QaoVEkar?=
 =?us-ascii?Q?T6+r+9gYr6os2UQQtHvKLitDurLechLUwPRd66KoOJ4KG/ygapfs7qxCyzKJ?=
 =?us-ascii?Q?cewhWr6BZiQx9YEnJ+BCnqvcyc4ZJVb+DN4b538fWEqCaWXWEFvwJ6JUzqrg?=
 =?us-ascii?Q?C5JLMPoY4jdZP2Jd8ivu2kJHu+kgTdpzsPvtY6X3cuZUf3HldnjB2Esv/TY/?=
 =?us-ascii?Q?yaU85zq2g2pV74SDhLutEIYr+5iNOQ6vHia+8l4yHC9vZf3fzURxyQY5iuj+?=
 =?us-ascii?Q?AVGs9A0hqQGlMaoS2RRcKViXB05d/3TqaxD9W7DG5umMDG15s3LQK4zrxI5M?=
 =?us-ascii?Q?/vdqAIFQVKC7xPgLzeT71TNmZj6lnHNLjxXuTSXJIqCgahND2g/ueEoUqnrc?=
 =?us-ascii?Q?JtNBuTwk1AmgCXtG1e7ic58k+y9w1AWSiOAmlP24j1fRXtiPl+vbd7bc+WmK?=
 =?us-ascii?Q?+VtCOfIpVkSgXZ6LGKTDv6ykT0L68unG21l3bVUc9dRXOysllE1bzqLsIacN?=
 =?us-ascii?Q?ya3HjQwzWmeXXTje5t4VWzsXMjiItRBiDlwchwjeZqxzshD0y6urLxu9qYW5?=
 =?us-ascii?Q?4abcU/CdLeMIZeo0P922ne6YOYhcpkBHm54f7+MQbohPdhZRevwA74Lfpvg2?=
 =?us-ascii?Q?3Ywjsgv6TQRyGdxlhIt+zsKcIHfGV9nN1s2Z37D3L8cVCqJ73B7VFjxMwNz0?=
 =?us-ascii?Q?Jo/M8VS301pxU9tD/euF5C0dGQ2ZrfaaCoJI6Bw7Op5j8XJSspI3UfpD+r0T?=
 =?us-ascii?Q?C79EcIYF8hEi3PUhBrX6lZDCvuK01YZlYDWvXxjp4n6px1pI5pXVpx4CwP61?=
 =?us-ascii?Q?DSR+ddpSMF22YO5gdb+YzWIdTNUrkhuP3dV/2xNTulP/1CfyfpXMmo/OaMpD?=
 =?us-ascii?Q?D64EQXT0s0V7CZLBDA5R750jcUNp3tao91fR7AlLkNliSqwldkw2R0eyBGbe?=
 =?us-ascii?Q?Xm3Ay3S/ffMDd3AT8WFpaE1vETBhgAYpXkX+Ufu1c33+rdCNvK4NMajgNrlZ?=
 =?us-ascii?Q?gi3snF/oh6pkpB0Jqbb/M7XTPE22M7o23be/xzl4RsaKVZqjBVm9BC8dUzEH?=
 =?us-ascii?Q?1G466DX8Is6CYX47B1gI+/2iGT1NHxXd3dtr0Bu/UUEkN2JYIJIWZEbA+Sg7?=
 =?us-ascii?Q?fhNk4lNj4UKRv0mGzXMud20mAEntZB7y1XKp2I6ftLacdk8JsBj82fJBWxZX?=
 =?us-ascii?Q?i3ZPeSTWRl0UD9RU0fHkYjjmZ9AXsAPPTu59Qj3dZC8uLgrKjaHOvBaUQ9X6?=
 =?us-ascii?Q?kamzM7bVmDNNr+qRWYX/qUSZ3bbUCy73LUqQWYLK2qAwcdfZ8o4C1PDLv6TX?=
 =?us-ascii?Q?GSKQFr4RS64OycxJkHIOZdItG/iLwvghPc/4zfX/mZZW5WZp0e+BNrNO8j4V?=
 =?us-ascii?Q?4Ca+QDVnlHrV61rjRTMH0nak33b+Fa7+zHJFjwqMDPVcuarA64fDaiCeEBPm?=
 =?us-ascii?Q?/i0MAEdNDPdQBn/qltUmApldQ36e/+Ewt0pJa4bC2aQCun82u3N64f8S8Yns?=
 =?us-ascii?Q?G+lnVvAGl0XnSPZrjxAd4DCh6Td2xaU4eV8HUJy5uZCcvIMP+I/dycKw8g?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(1800799024)(376014)(7416014)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2025 01:40:04.9816
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: afdcdcd1-2b6e-4285-b15c-08dd9a63e889
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE31.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7981

From: Ankit Agrawal <ankita@nvidia.com>

Introduce a new memslot flag KVM_MEM_ENABLE_CACHEABLE_PFNMAP
as a tool for userspace to indicate that it expects a particular
PFN range to be mapped cacheable.

This will serve as a guide for the KVM to activate the code that
allows cacheable PFNMAP.

CC: Oliver Upton <oliver.upton@linux.dev>
CC: Catalin Marinas <catalin.marinas@arm.com>
CC: Jason Gunthorpe <jgg@nvidia.com>
Suggested-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 include/uapi/linux/kvm.h | 1 +
 virt/kvm/kvm_main.c      | 3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index b6ae8ad8934b..9defefe7bdf0 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -51,6 +51,7 @@ struct kvm_userspace_memory_region2 {
 #define KVM_MEM_LOG_DIRTY_PAGES	(1UL << 0)
 #define KVM_MEM_READONLY	(1UL << 1)
 #define KVM_MEM_GUEST_MEMFD	(1UL << 2)
+#define KVM_MEM_ENABLE_CACHEABLE_PFNMAP	(1UL << 3)
 
 /* for KVM_IRQ_LINE */
 struct kvm_irq_level {
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index c7ecca504cdd..cddda7f21413 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1524,7 +1524,8 @@ static void kvm_replace_memslot(struct kvm *kvm,
  * only allows these.
  */
 #define KVM_SET_USER_MEMORY_REGION_V1_FLAGS \
-	(KVM_MEM_LOG_DIRTY_PAGES | KVM_MEM_READONLY)
+	(KVM_MEM_LOG_DIRTY_PAGES | KVM_MEM_READONLY | \
+	 KVM_MEM_ENABLE_CACHEABLE_PFNMAP)
 
 bool __weak kvm_arch_supports_cacheable_pfnmap(void)
 {
-- 
2.34.1

