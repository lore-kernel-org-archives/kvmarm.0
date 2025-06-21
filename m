Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2048.outbound.protection.outlook.com [40.107.94.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA60514AD0D
	for <kvmarm@lists.linux.dev>; Sat, 21 Jun 2025 04:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750479687; cv=fail; b=GXMI6FqCfl5YXPrrtWFAvmapo4ZIjAA13lRRmkWVEQVmYQv3m3FIRgwZxrhw/66nF54ZpGLORQygcoWsDhaEYglyBBlO3SzCLjJwk1qjzC1OnvT/41Ylz9Q9P55kNAm7UK40/BMM+DftKSTI4P7w7twU6vCIkS5bSPq1vwbqV6k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750479687; c=relaxed/simple;
	bh=bpP9rW3lvV9nr/dSewocHmVkezFfLIi1Hd+YohIapqU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RU/Za5JuR16KZz7ekTrmgpXRvZ2+ks46zJPTb0grwT7hrr1ZgFeD/IBc46F8YgBdI0/GsDOETI2z6tFRsafIulSbr1dhpWidprL+pxgrAPBBgeOHCpVLBJwnFE1j9ikJZfQ3+iV7gEArqjKvEBeanCmg5Eh3mxBW6COyD2P0Jf0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=nAaUh3sr; arc=fail smtp.client-ip=40.107.94.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="nAaUh3sr"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ypzl6rAvP2eo+sUdf40V2PJdqlViSvzGLR128b8piXJX0unjWEFrl49khCRUUPHF7ESjzrG/JxPc13O2vdTnVff9o1TzpSbDX6Xx4OjauSLTwmK8sPxj5kTYhzcjlJ8I5qYj17zBioU1S2izIEG+j9H96PcFt13umWnf5wLO8Ws4nBGbuYq7gTGImSICI9d/Yp2AHlikUjQ7yMTg/AjzSfQ2m2sgkx9nAI9qZHSmmWxpcoPvNjHBe1btFKlQVGXrnMFjvpGwgXzZXVRvrDwyJKKIp8fHIERmM0sV2X0kX/E4xRUYwozRbPYYzHcQ9wQIGUe3S26PKFxprvclacAwoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GkCBJLwsMBLjSVGWzfhuFJx+agdzxNGx1pRR5Z/t82s=;
 b=WGtdFaDuq7ty+eo2K7LAkKkac4yscewALDvhXbFBVclaDSwYhtxIZ4D21CDrSH/Gw/KaMa4NNC7qWb8WEfMQnElK66UyJRNR2YCGIyHqX/ijrYRGMTWE2br69XzIa0emp5/VzaMihPvE90dsZDSfUiXnzqzwTmyMH+KR+NL+ETD2+yt8yBylDDXsJ2gFgZx2S/ppCv2V2sBBFTmhwhKpn/uQtO8sDpjj9htBJ/dA/CM14sF8hnQoEG/zYhwaH1AqwPPNMRrMy9i1Dnd6ekTsVM2uP84hoAAIKmlRNYlWk3IT9weAJEpelICJV3Xdc8m25liWoPnHv+AIHwVCn7f2zA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GkCBJLwsMBLjSVGWzfhuFJx+agdzxNGx1pRR5Z/t82s=;
 b=nAaUh3srnN6JMQAlIfvGFO5BEBlgbJk0GR0Ofkqvi56trEdsePpVK+cH9FHXDKrss1JkSkstmcgbfwEPH/VHXFK6dNCvjv9ziqkjqeRk/FbkkU0NBUjmlC7/3b51hI7LhFvizclDW5NYmknXNLi25elhtzLAt/GNQQjAIOzWhHQyXkIpz30JHBD+sSTbT0/GOj7ncQmwia5sWqNDo5i07W/aklsjBQcyLpAHVReuNEmpW75fN+0dP/KKjH6jHXfhQdgfxu3pPb/KImrrjTf6zokPiUnyiB06THVCiYMWHxNL3BHMrDKMyXAzXIDd8bgQQdzOPSO+6d9Uk4rwQkpqjw==
Received: from MW4PR03CA0116.namprd03.prod.outlook.com (2603:10b6:303:b7::31)
 by IA1PR12MB6212.namprd12.prod.outlook.com (2603:10b6:208:3e4::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.20; Sat, 21 Jun
 2025 04:21:20 +0000
Received: from SJ5PEPF000001EF.namprd05.prod.outlook.com
 (2603:10b6:303:b7:cafe::67) by MW4PR03CA0116.outlook.office365.com
 (2603:10b6:303:b7::31) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8835.23 via Frontend Transport; Sat,
 21 Jun 2025 04:21:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 SJ5PEPF000001EF.mail.protection.outlook.com (10.167.242.203) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8857.21 via Frontend Transport; Sat, 21 Jun 2025 04:21:19 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
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
Subject: [PATCH v9 4/6] KVM: arm64: New function to determine hardware cache management support
Date: Sat, 21 Jun 2025 04:21:09 +0000
Message-ID: <20250621042111.3992-5-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001EF:EE_|IA1PR12MB6212:EE_
X-MS-Office365-Filtering-Correlation-Id: ec2712af-1997-4163-46b8-08ddb07b12d2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|7416014|82310400026|1800799024|376014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?vBC4AdlCFGc/3zhsere8qGdwgoAAGHB5zS9EsEAp+s5QgbMU/YFS/yW0njyS?=
 =?us-ascii?Q?vqImOqqn9i4UE5+BHwt4gsucRlbK/ddXZCZXPljSi4eR/qUdUo3CQf/TIPkX?=
 =?us-ascii?Q?zkyhlWLzDTES8C103LnL5PZYYh1gB5AwRzVEgH4PyshiFkfkrcg41BBxrPtP?=
 =?us-ascii?Q?DI8ia5y7SPw0LcixFoDuvT/kfgGCUEN/bDcbJGQBH4+XlOw4AkVUt2S6lZGC?=
 =?us-ascii?Q?TeYleB9gzImSbQVrOvI+GuPVcTkHN2Vgt0ytPCHRD+oclDJINsLl8bSYq8q8?=
 =?us-ascii?Q?9gzkFBQS19yxOxZnP6xbt3Rd1qiRKhPd8FvmL4MPE3qqhev2CebVuOHvvT5E?=
 =?us-ascii?Q?x8dwUfNBIiayzvkSbwk/Zs8aqrI2fShDBslgJc79OBtJ1I0tkBcNl+Np0+I+?=
 =?us-ascii?Q?siCdg9j7E6pY2Bie9SRy4nfZIDUxMGRQKmOPEETzYnJSXkLeC8RpEkswt3iI?=
 =?us-ascii?Q?x0jrMLeSRzcN9H8EVLjcb0zZtvK8fgCBo9xVo4+7fpdky25FB1Kp9GyKSaRl?=
 =?us-ascii?Q?jzTLtLSO8igT3G7Umnfrnm2DEfkt7TMlz05tUHVpVwwBBhasOuR+klrQPtzo?=
 =?us-ascii?Q?OZLwzpqJOOJcQHtBNEKeux+NFdPl8ObqNzclHYYOVSlAJVm3aEVGpSHktkZa?=
 =?us-ascii?Q?gX2cofK4133P7vXwzu1+9wBJGFJfNtC7xIlIzGrjMSUsI5kUzJugyM+dAQh5?=
 =?us-ascii?Q?UF2PZhQT4zWD8GKAAgZ55FPANGY/SIhPCy8yZ3GskQ1thRQZWjO1IObMvhuZ?=
 =?us-ascii?Q?ZtzGM582RsPngYWw2z9SoTt6sk195GszDKUlI7WYUsBT18W54J3E6GDcbfjU?=
 =?us-ascii?Q?031o3rMumpzyoQZoQgzGiXAF4n2X739ovLWq372PTsa1Pxx4L+K5y+NMqMuY?=
 =?us-ascii?Q?M2rLjw34ymyfbnvqnAhmxiyth03b8Qu1RdRhYSIWvD41JddoyQ1dRr0p1PdQ?=
 =?us-ascii?Q?MAwNE6ItKHTrCOBjWJ3arGRMTjxYzXbU9U3WUmxuOdwYXbEsUCIpxpwsr+kb?=
 =?us-ascii?Q?jsh6uFmP+S+iKsaNnEptoDAC75YXYszZCCSkQiJbbGIV7rBXnZ1zEMsaP+CH?=
 =?us-ascii?Q?ED47y9sUlHHTZQ+EZMwdwBg5j8umEgm9NCk6szbuxpqBqnF2CUq9LEMkgbgM?=
 =?us-ascii?Q?eufNiNL99UtRqfzu5ga+0Yp8yf4BWDwvdpcUPXKms01AC8jnJVpMsqo9OeVE?=
 =?us-ascii?Q?njXMpJbldPER3PnnNbIGgQ49eRZn0+N7m1ErenhegZmtlRtfCea69aIOmgEE?=
 =?us-ascii?Q?NqIiODuLvQcKZPLi4twTXHfFe0EcBlvtwOXQbf49APbnrGPwqBMdYKPRNwTq?=
 =?us-ascii?Q?32cW9BUGE5FuUnXbSAVNpWgELg5nwaCATwsGvsetowo3HdTGdkl+YceD4rLQ?=
 =?us-ascii?Q?fVLyQXf6omdOEXKBavnDvE+nrU84A/HMnnvMtkMg20X54IN4hejEoAmjIhof?=
 =?us-ascii?Q?6/35hcxV/e9TDB9tC1vu6s3W3fkkjxfrWvwHgVER51iL0qdfvniRwOvUpUh0?=
 =?us-ascii?Q?wKT1G0lxk31gNLB42dJ9iwv2q7RdXXOC7Dzpt61a8rTZlEmhGFbG+FFobg?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(7416014)(82310400026)(1800799024)(376014)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2025 04:21:19.9567
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ec2712af-1997-4163-46b8-08ddb07b12d2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001EF.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6212

From: Ankit Agrawal <ankita@nvidia.com>

VM_PFNMAP VMA's are allowed to contain PTE's which point to physical
addresses that does not have a struct page and may not be in the kernel
direct map.

However ARM64 KVM relies on a simple conversion from physaddr to a
kernel virtual address when it does cache maintenance as the CMO
instructions work on virtual addresses. This simple approach does not
work for physical addresses from VM_PFNMAP since those addresses may
not have a kernel virtual address, or it may be difficult to find it.

Fortunately if the ARM64 CPU has two features, S2FWB and CACHE DIC,
then KVM no longer needs to do cache flushing and NOP's all the
CMOs. This has the effect of no longer requiring a KVA for addresses
mapped into the S2.

Add a new function, kvm_arch_supports_cacheable_pfnmap(), to report
this capability. From a core prespective it means the arch can accept
a cachable VM_PFNMAP as a memslot. From an ARM64 perspective it means
that no KVA is required.

CC: Jason Gunthorpe <jgg@nvidia.com>
CC: David Hildenbrand <david@redhat.com>
CC: Donald Dutile <ddutile@redhat.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 arch/arm64/kvm/mmu.c     | 23 +++++++++++++++++++++++
 include/linux/kvm_host.h |  2 ++
 virt/kvm/kvm_main.c      |  5 +++++
 3 files changed, 30 insertions(+)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 68c0f1c25dec..d8d2eb8a409e 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1282,6 +1282,29 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
 	kvm_nested_s2_wp(kvm);
 }
 
+/**
+ * kvm_arch_supports_cacheable_pfnmap() - Determine whether hardware
+ *      supports cache management.
+ *
+ * ARM64 KVM relies on a simple conversion from physaddr to a kernel
+ * virtual address (KVA) when it does cache maintenance as the CMO
+ * instructions work on virtual addresses. This is incompatible with
+ * VM_PFNMAP VMAs which may not have a kernel direct mapping to a
+ * virtual address.
+ *
+ * With S2FWB and CACHE DIC features, KVM need not do cache flushing
+ * and CMOs are NOP'd. This has the effect of no longer requiring a
+ * KVA for addresses mapped into the S2. The presence of these features
+ * are thus necessary to support cacheable S2 mapping of VM_PFNMAP.
+ *
+ * Return: True if FWB and DIC is supported.
+ */
+bool kvm_arch_supports_cacheable_pfnmap(void)
+{
+	return cpus_have_final_cap(ARM64_HAS_STAGE2_FWB) &&
+	       cpus_have_final_cap(ARM64_HAS_CACHE_DIC);
+}
+
 static void kvm_send_hwpoison_signal(unsigned long address, short lsb)
 {
 	send_sig_mceerr(BUS_MCEERR_AR, (void __user *)address, lsb, current);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 3bde4fb5c6aa..c91d5b5f8c39 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1235,6 +1235,8 @@ void kvm_arch_flush_shadow_all(struct kvm *kvm);
 /* flush memory translations pointing to 'slot' */
 void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
 				   struct kvm_memory_slot *slot);
+/* hardware supports cache management */
+bool kvm_arch_supports_cacheable_pfnmap(void);
 
 int kvm_prefetch_pages(struct kvm_memory_slot *slot, gfn_t gfn,
 		       struct page **pages, int nr_pages);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index eec82775c5bf..feacfb203a70 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1583,6 +1583,11 @@ static void kvm_replace_memslot(struct kvm *kvm,
 #define KVM_SET_USER_MEMORY_REGION_V1_FLAGS \
 	(KVM_MEM_LOG_DIRTY_PAGES | KVM_MEM_READONLY)
 
+bool __weak kvm_arch_supports_cacheable_pfnmap(void)
+{
+	return false;
+}
+
 static int check_memory_region_flags(struct kvm *kvm,
 				     const struct kvm_userspace_memory_region2 *mem)
 {
-- 
2.34.1

