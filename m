Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.201.19
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795554751;
	b=X44AS8RVyLK2faByDdNxBR+3Kmg+u5SyYYxseavltulpUhPpNHz5ErBVtS653vqOzf2C
	 bReu7erSInrWJEe02Bx0UN8CvsoJf90IFSUonunmHpxwIFQDtk9bSDRMD2go3rYRS0exC
	 48etFGg7871Gy3MiAdrTw7EkotqBHZxVQnD81ws2tpWrxuF0i8iL5onBaLKjQy09FGBUp
	 hOjiQFyAm51FCrDa0oxK65gHM8ZjsOyEMi5d1cwOHC6gmmcF5xmuqydGX6nat3yd6NBm6
	 8Hy/8xuxJx/8Tm6lmI4b25l/uNkD5uJwxoPJzlMVAbbf0/HoNNvoiggIAoB0xmFMqhQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795554751;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:
	 Content-Transfer-Encoding:Content-Type:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=3QDeZ2E6JVSmOjpVLTizsdvzMIuExQwZ3bWcUhyvNFY=;
	b=XE2+jItMaLO8Ou1toocjsdWmHxbIGg338tTeiSbca8TNNOGqv5zgj+PPgFS3NnWHxe9g
	 Txv4JYKOXjwvG+84gbbDdlT+hkoolzWQhut/a+zxKnpzpfIDndj9J3CylcxIyvXYtVBzE
	 iqbM4pzTV1jn92vkfcsLvVtrkj3ss31uKXZoHU842aPTh3GuixSK5/Yi1c9Yk9yienaaB
	 ZEU1D8a0a6ahigdjbI3mky9o02CNtnrvP5cWBHquvc1WkaB0kSWtGSQUvrTnE8h80ugN7
	 BqbhVvs9/CrJtW93rJzoTom/3DV4CCSfyxCsVRvby3OBPYvkiMU+ovJ/VUO9zXe3WqA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=KWYoeD4i;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.201.19
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013019.outbound.protection.outlook.com [40.93.201.19])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D588606A687
	for <kvmarm@lists.linux.dev>; Tue, 24 Nov 2026 21:12:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8D588606A687
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=KWYoeD4i
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NIdija6vEA8UO9mGRHtZG7pUsn611lun5Qhn1wh6YL5ki6kOXP+5JU+IR9oTQdvsKDCz6AzKm8+HKw2kkQrmUDyIQFP4o1MZ4H7ALGxTZ883wOaUM0EVBjpCoaIWgCsXg9befEK0MD4DkfxQf2H4MKp7hVdUIdlajI0/erT1x6Db551D79mqC3Zke4wAxaRy8HuwN2/79WWAv6ipUC7hmwqkowawbqzHunBkRSbyKf9KuboiSRel4Bvn6hhVW/Mwg3NSg5Vow7TvEuyxiBRoZxlG6s2Tpxt1u6+2cwRXOHiP91qSsCeNQHbvD7tYSoPtpmQHUNQ06pqzOAQ2sxvaEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3QDeZ2E6JVSmOjpVLTizsdvzMIuExQwZ3bWcUhyvNFY=;
 b=vTJP53PLUVn1rJY7MpkIJeacjnzOh6UU9FMCEwH42Y/NJFfSadL/Lise/XcyriCDh2TM8yOAtwXd3Mgo3Dh7+GulD6mXojeYmWqCA8jbgjeAsO/3uiFkfue9nlda/NrItiklDKidhzl2+4v81Gl4m9snXjZ7EpEzMYiCrh8XuouMM1KddW5IOBNqLL5lXtPjB5pWl2ojdU3+Wq12/JAx8sFiJXyH3W41IU92dobP9V7GCTOdIeL7McFQ428jLHqYJl9cLTlMjf7NY2EhHulF3lKTWqD/ebmhMoa6SYtONQehCY0RxhO5S1pPzzEz7ssEGp4d9ZwaEqBJAYf+yhsLpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3QDeZ2E6JVSmOjpVLTizsdvzMIuExQwZ3bWcUhyvNFY=;
 b=KWYoeD4id3aGTpy/zY46nHVah0P8rve+y9ka2Aa8TDXLU2M0IvzqlO51xstgFYRasxGIhDolkZClWxXEqFL8my9Fv0pOOqT4uQI7jsSIPt3hRc7Jx/VOOQvyi8wbCO8iPeCFDCEtnM0ihLCC0aDdbk08j/fVk+xAglPMS0zAE+P87f8fb7snphOnsrr7JqmrF7b/xCeldNOO6WKjCEuBtEmO3TnNowDsKZvrbMPTt5XOAkoR08ejwB9wLuAuDawPElYv3qA9VWlrTkEM2H1X5agjhGTDkne7cTtekYNG3yfumnIFxV8CbIAJ76udVM9NcIBFhFkCEJ2mYN7pesLW+A==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5390.namprd12.prod.outlook.com (2603:10b6:5:389::15)
 by LV9PR12MB9784.namprd12.prod.outlook.com (2603:10b6:408:2ed::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.13; Tue, 24 Nov
 2026 21:12:27 +0000
Received: from DM4PR12MB5390.namprd12.prod.outlook.com
 ([fe80::2815:c27e:a0a:2720]) by DM4PR12MB5390.namprd12.prod.outlook.com
 ([fe80::2815:c27e:a0a:2720%3]) with mapi id 15.21.0662.001; Tue, 24 Nov 2026
 21:12:27 +0000
From: Nathan Chen <nathanc@nvidia.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Mark Rutland <mark.rutland@arm.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Oliver Upton <oupton@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Tom Matthias <tmatthias@nvidia.com>,
	Shameer Kolothum Thodi <skolothumtho@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Julian Miller <julianmiller@nvidia.com>
Subject: [RFC PATCH 4/6] KVM: arm64: nv: Grow the shadow S2 MMU pool on demand
Date: Tue, 24 Nov 2026 13:12:16 -0800
Message-ID: <20261124211218.2751086-5-nathanc@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261124211218.2751086-1-nathanc@nvidia.com>
References: <20261124211218.2751086-1-nathanc@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR02CA0007.namprd02.prod.outlook.com
 (2603:10b6:303:16d::33) To DM4PR12MB5390.namprd12.prod.outlook.com
 (2603:10b6:5:389::15)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5390:EE_|LV9PR12MB9784:EE_
X-MS-Office365-Filtering-Correlation-Id: ea3b35aa-af62-419d-64c8-08df4a6fa457
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|23010399003|1800799024|261028144727099003|261022113327099003|10067099003|11063799006|5023799004|56012099006|261021121427099003|261022115727099003|261022105027099003|261021133027099003|261026140227099003|261021130227099003|261022075727099003|261021123027099003|261009223027099003|261026135527099003|261102123227099003|261026130827099003|261021135927099003|261026121527099003|18002099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	YP3sXyhZj6DHO2IWf41YHYV3RSMb7BIw5KdeJm6lHkpXw5yDGl2R7Pz14SyFQIe/MoQrvRIXiQELmx/Z43TIUO9KiblwiH/XizFumEBEqaSAiJJ0Z0KAqwD12j8WVS830cbGXM2ItJqGjFjwOWHzYOLPW0MiTl/8BqtzPVafS9A9jVx9ARJhugkIY/t5r08PC1MDQesDTDMigE++uj/UCDRpyCksrriL1zphRm7+ob5rxcH2fuBIxHdfXGixWI/ES3h2/IvUWln9Zh4/JG7dGudZlzaX2skCBG7ywhNvGJ7wUQVGUrpP7R5EHTxDALNI0h3FiUsz24Zh4/QsyCyCFPM6o4wVnC7c2PPbgmJ6eH/9rtmNOBOZCZ2M8wn2llCAO+IDoeAbnpxWx2GzQA027OOgRiomuGZZKbnDHL3GLIM77zwgQrnFMtBwKeeaBdKPtzac4zHYGo3J+eTRQAgYBdGiQJjoTiZRgxl6c5z1aGLwZLx6ZDIoc4dvdQYDTHJEx70Ti/1eXYXyUCe0tEk1p9c7WmxRSVISSNWmAzqYndWOfd6AFgjNyexhglKBfQ2zl24OOhSOjzfEY3thGRaTJwnN8w/KqpTON7jzyYsMp/J/yL7MLlL1qA8Y9CuYviHU9FjMWEShUG1zYr/qkV9krBCJJEOWAeN3fYWhebZ8hc0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5390.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(23010399003)(1800799024)(261028144727099003)(261022113327099003)(10067099003)(11063799006)(5023799004)(56012099006)(261021121427099003)(261022115727099003)(261022105027099003)(261021133027099003)(261026140227099003)(261021130227099003)(261022075727099003)(261021123027099003)(261009223027099003)(261026135527099003)(261102123227099003)(261026130827099003)(261021135927099003)(261026121527099003)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jdVh1p8Vfpc3KpOSwnx9UC30Tbv7aVNC/DqvTCiUf+ILoSyboJazt3d52cMX?=
 =?us-ascii?Q?XwCRBLNem17WXmz2sMtdbScCWbs12uEeXZ7sFdgj4XrTutmEsZw3q1b+sv/P?=
 =?us-ascii?Q?9RkWxm3aF9Z1wdhEFOS4g+Ln6A+L9KydcnxRd+TeppBWfNiiX+3eM/lAN0g3?=
 =?us-ascii?Q?X/ud/+hg+X7cRdiOZRIBFCXzMYzM30GCSmxDa50ZXWAj2yBtMHVGIg2T6gGJ?=
 =?us-ascii?Q?Wj4F1GQZ/H0wpKQxTIuRSuv6VFOjYHxgt/trX3hrXGxTzbTdlAdT7jvJ8ok8?=
 =?us-ascii?Q?4KZxwcY02E2EuSB2RBFgpQH0UaOoyIKre3R6IB0i0Hy0f83biSbDs+u2kXAa?=
 =?us-ascii?Q?v5eU/yOcE/xW0+csCjqeiIqvZ20cblwkpbCx9wShAyfY9Ai8lhSV9aa9xP3m?=
 =?us-ascii?Q?k9WBAV2BUf631x9pm0Bu6vMLbJb0kQbCo7qbmC2/3AFk272ZP8fLJm2e91hR?=
 =?us-ascii?Q?PVkfThx+xn3Eb7RJ7qZLgvVVSyS7a/BK2o1av3c38FXLb9zHbXrXAr0+3Ewk?=
 =?us-ascii?Q?5+D1wxMK7IcC+q+8QMIuFs3MhdwTDzidx2iaJgT4X9IVqhzMwn5rXdZj9STj?=
 =?us-ascii?Q?ewbn7A9j1FM0vU8nQTgSK7gAZcQI83o3r5FDOPoVF79Y4KuPdZiJBMp5nMNh?=
 =?us-ascii?Q?q7LPM52GS1wW/FiYiS567pSWFdO2gptVG4fp34+q4iITga6ECwSIt8bVEWog?=
 =?us-ascii?Q?dDkUVrR6w7PzjqUMn4g3UEDP8ljA/hUNePIDYzCt4eP75ofg/Emcwnq43qNm?=
 =?us-ascii?Q?P7dyf4B4aSn0S6YqX3kcHu+qUyBHuGo1QeCaKHYd5EkK6xhlESC/DoDiKd4F?=
 =?us-ascii?Q?hLOotmU0nxRzA6HQww/H6lDUBdCVblbC/VMeLFdugpj16ydafrk3YXiN+L8z?=
 =?us-ascii?Q?pvbNBhQQCCtKT/5z2WLZMukPnjhdXrccurOfE6jKq+xo+SZfFjMj8oqIyj45?=
 =?us-ascii?Q?HRtXTSxV/fqYO737iJyaWuLxxt9PsR68b0d5stscSqF7PbYnfAEArM5F4ErP?=
 =?us-ascii?Q?sh5PtjrGiYNMs7LjAv2ghFdyRZ70X+nw+9aGQaouPoiDwmlrBHnJ8BMs33kN?=
 =?us-ascii?Q?sc0QV81aW1lB1yi9Z7bPxwll/77pQoC0B0CRsd7sdbL/aESHPrhLjR3oUuRl?=
 =?us-ascii?Q?Oj6jq5YTqAZrvA4gppEkcyzE9j4lff8x/O6v2/+JL8hvR/fd3Wwxm53iU+sI?=
 =?us-ascii?Q?adRJNZxIDrQ7hV/T0tkQ6z53aYAG3Pgf+E5gsTSlZsWBBLHU1TuMmrncM/KE?=
 =?us-ascii?Q?fQSiWfTHMKLe46b6R2n7uay+QaWlDGe4L9HRjgVjcIsij9PMg4z8jss+tUJS?=
 =?us-ascii?Q?Hmq1CgWzlQNyPbDi9Uy4BPmcWT28c6ptX2za2mPkGO9uv+mja8B1ERSyLx45?=
 =?us-ascii?Q?6BC4dc2FlCOIbmSr3WjQ/ufDZ1ujh7533eqatfnrTefmwFgr0wyadLZTEkRM?=
 =?us-ascii?Q?XJaGPGfFLvZbtWAO7YNkbQFRYBElgLDU8ijclKqqhfJYlnuPNHaEaOTKLx4N?=
 =?us-ascii?Q?GCAfTZBZNjF1QXfpPduPjcixxQAqAQ34/RNpdDtjVeSnTcT+R+ZacB4V+GlT?=
 =?us-ascii?Q?dhVqvldiOfbT8kRKLsjp02zWybdz/S86KffWhrODzmJMbAkTpGhhtvdy9c7B?=
 =?us-ascii?Q?B2q1VAV3iPl4bBQWmrEeH2Vc4dwles5R3z+1ADUXPsXD9+eLPUkMOKo77que?=
 =?us-ascii?Q?4WQNFmogJC2yI1w8ihh32Fbr0wiQVqg1rmAEXj2uIkRCKptaMy8Dsat7B6r9?=
 =?us-ascii?Q?JhRUy/wu1w=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea3b35aa-af62-419d-64c8-08df4a6fa457
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5390.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2026 21:12:27.1342
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oDoOOMYusr32MUf7SuIJOsB15JOVF2BUdIW8sRUK+i/88TxCx2iEtORV1eXlLT94C1gpx5uFr4B4OIg/VQtJlg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV9PR12MB9784

A nested-capable VM gets online_vcpus * S2_MMU_PER_VCPU shadow stage-2
MMUs, with S2_MMU_PER_VCPU currently hardcoded to 2. When the guest
hypervisor runs more than that number of concurrent nested VMs,
get_s2_mmu_nested() recycles live MMUs on nearly every nested context
switch, tearing down and rebuilding shadow stage-2 tables and issuing
VMID TLB invalidations each time. This causes a sharp spike in host CPU
usage.

Keep S2_MMU_PER_VCPU as the initial allocation, and grow the VM's pool
when the guest's working set outgrows it. To keep growth from exhausting
the VMID space, grown MMUs are counted across all VMs on the host and
limited to half of what kvm_arm_vmid_nr_usable() returns.

If an allocation fails, growth stops for good, so that a VM at its
memory limit doesn't retry on every recycle.

The nested_mmus pointer table is reallocated when full. Only the table
moves, not the MMUs, so cached hw_mmu pointers stay valid.

Signed-off-by: Nathan Chen <nathanc@nvidia.com>
---
 arch/arm64/include/asm/kvm_host.h |   8 +-
 arch/arm64/kvm/nested.c           | 153 +++++++++++++++++++++++++++---
 2 files changed, 148 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 6ae86bc96600..9307b86285a5 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -62,6 +62,7 @@
 #define KVM_REQ_MAP_L1_VNCR_EL2		KVM_ARCH_REQ(10)
 #define KVM_REQ_VGIC_PROCESS_UPDATE	KVM_ARCH_REQ(11)
 #define KVM_REQ_RELOAD_GICv5		KVM_ARCH_REQ(12)
+#define KVM_REQ_NESTED_S2_GROW		KVM_ARCH_REQ(13)
 
 /* Bit indices for kvm_arch::flags */
 enum {
@@ -434,12 +435,17 @@ struct kvm_arch {
 	/*
 	 * Stage 2 paging state for VMs with nested S2 using a virtual
 	 * VMID. The MMUs are allocated in blocks tracked on
-	 * nested_mmu_blocks.
+	 * nested_mmu_blocks, and the pool grows on demand.
 	 */
 	struct kvm_s2_mmu **nested_mmus;
 	size_t nested_mmus_size;
+	size_t nested_mmus_capacity;
 	struct list_head nested_mmu_blocks;
+	/* Grown MMUs, counted in the host budget, under mmu_lock */
+	unsigned int nested_mmus_grown;
 	int nested_mmus_next;
+	bool nested_mmus_grow;
+	bool nested_mmus_no_grow;
 
 	/*
 	 * Serializes guest s2 tracking trees access when the mmu_lock
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 44dc6780fe6f..d530a37716be 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -39,14 +39,58 @@ struct vncr_tlb {
 };
 
 /*
- * Ratio of live shadow S2 MMU per vcpu. This is a trade-off between
- * memory usage and potential number of different sets of S2 PTs in
- * the guests. Running out of S2 MMUs only affects performance (we
- * will invalidate them more often).
+ * Initial ratio of shadow S2 MMU per vcpu. When a vcpu has to recycle an
+ * MMU that is still in concurrent use, the VM's pool, which all its vcpus
+ * share, grows by one MMU per vcpu within the host-wide budget below.
+ * The pool then follows the number of different sets of S2 PTs the guest
+ * uses at the same time.
  */
 #define S2_MMU_PER_VCPU		2
 #define S2_MMU_PER_VM		(KVM_MAX_VCPUS * S2_MMU_PER_VCPU)
 
+/* The MMU index is kept in the low bits of a tracked nested IPA */
+#define S2_MMU_MAX_PER_VM	SZ_4K
+
+/*
+ * Each shadow S2 MMU that runs takes a host VMID, and VMIDs are shared
+ * by all VMs on the host. Running out of them causes a rollover, which
+ * invalidates the TLBs for every VM. MMUs added beyond the initial
+ * S2_MMU_PER_VCPU are therefore counted host-wide and limited to half
+ * of the VMIDs the allocator can hand out. Hosts with 8-bit VMIDs don't
+ * have enough to spare, so they never grow.
+ */
+static atomic_t nested_s2_mmus_grown;
+
+static int nested_s2_mmus_budget(void)
+{
+	if (kvm_arm_vmid_bits <= 8)
+		return 0;
+
+	return kvm_arm_vmid_nr_usable() / 2;
+}
+
+/* Lockless hint, checked on recycle before asking for a grow */
+static bool nested_s2_mmus_budget_left(void)
+{
+	return atomic_read(&nested_s2_mmus_grown) < nested_s2_mmus_budget();
+}
+
+/* Take up to @nr MMUs from the budget, returning how many were taken */
+static int nested_s2_mmus_budget_take(int nr)
+{
+	int budget = nested_s2_mmus_budget();
+	int old = atomic_read(&nested_s2_mmus_grown);
+	int take;
+
+	do {
+		take = min(nr, budget - old);
+		if (take <= 0)
+			return 0;
+	} while (!atomic_try_cmpxchg(&nested_s2_mmus_grown, &old, old + take));
+
+	return take;
+}
+
 struct nested_s2_mmu_block {
 	struct list_head	list;
 	struct kvm_s2_mmu	mmus[];
@@ -55,10 +99,12 @@ struct nested_s2_mmu_block {
 int kvm_init_nested(struct kvm *kvm)
 {
 	INIT_LIST_HEAD(&kvm->arch.nested_mmu_blocks);
+	kvm->arch.nested_mmus_capacity = S2_MMU_PER_VM;
 	kvm->arch.nested_mmus = kvmalloc_objs(struct kvm_s2_mmu *,
-					      S2_MMU_PER_VM,
+					      kvm->arch.nested_mmus_capacity,
 					      GFP_KERNEL_ACCOUNT);
 	kvm->arch.nested_mmus_size = 0;
+	kvm->arch.nested_mmus_no_grow = !nested_s2_mmus_budget();
 	atomic_set(&kvm->arch.vncr_tlb_count, 0);
 	spin_lock_init(&kvm->arch.guest_s2_tracking_lock);
 
@@ -72,6 +118,8 @@ void kvm_destroy_nested(struct kvm *kvm)
 	list_for_each_entry_safe(blk, tmp, &kvm->arch.nested_mmu_blocks, list)
 		kvfree(blk);
 
+	atomic_sub(kvm->arch.nested_mmus_grown, &nested_s2_mmus_grown);
+	kvm->arch.nested_mmus_grown = 0;
 	kvm->arch.nested_mmus_size = 0;
 	kvfree(kvm->arch.nested_mmus);
 }
@@ -91,16 +139,25 @@ static int init_nested_s2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu)
 	return kvm_init_stage2_mmu(kvm, mmu, kvm_get_pa_bits(kvm));
 }
 
-/* Add a block of @nr shadow S2 MMUs to the pool */
-static int kvm_nested_add_s2_mmus(struct kvm *kvm, int nr)
+/*
+ * Add a block of @nr shadow S2 MMUs to the pool, reallocating the
+ * pointer table if it is full. Only the table moves, never the MMUs, so
+ * cached hw_mmu pointers stay valid. Runtime walkers of the table hold
+ * mmu_lock, and kvm_arch_flush_shadow_all() only runs once no vcpu can
+ * enter the guest, so it can't race with a grow.
+ */
+static int kvm_nested_add_s2_mmus(struct kvm *kvm, int nr, bool grow)
 {
+	gfp_t gfp = GFP_KERNEL_ACCOUNT | (grow ? __GFP_NORETRY : 0);
 	size_t size = kvm->arch.nested_mmus_size;
+	size_t cap = kvm->arch.nested_mmus_capacity;
+	struct kvm_s2_mmu **table = NULL;
 	struct nested_s2_mmu_block *blk;
 	int i, ret = 0;
 
 	lockdep_assert_held(&kvm->arch.config_lock);
 
-	blk = kvzalloc_flex(*blk, mmus, nr, GFP_KERNEL_ACCOUNT);
+	blk = kvzalloc_flex(*blk, mmus, nr, gfp);
 	if (!blk)
 		return -ENOMEM;
 
@@ -112,14 +169,36 @@ static int kvm_nested_add_s2_mmus(struct kvm *kvm, int nr)
 		blk->mmus[i].s2_mmu_idx = size + i;
 	}
 
+	if (size + nr > cap) {
+		cap = max(cap * 2, size + nr);
+		table = kvmalloc_objs(struct kvm_s2_mmu *, cap, gfp);
+		if (!table) {
+			ret = -ENOMEM;
+			goto out_free;
+		}
+	}
+
 	scoped_guard(write_lock, &kvm->mmu_lock) {
+		if (table) {
+			memcpy(table, kvm->arch.nested_mmus,
+			       size_mul(size, sizeof(*table)));
+			swap(kvm->arch.nested_mmus, table);
+			kvm->arch.nested_mmus_capacity = cap;
+		}
+
 		for (i = 0; i < nr; i++)
 			kvm->arch.nested_mmus[size + i] = &blk->mmus[i];
 
 		kvm->arch.nested_mmus_size = size + nr;
+		if (grow)
+			kvm->arch.nested_mmus_grown += nr;
+
+		/* Hand out the new, unused MMUs before recycling live ones */
+		kvm->arch.nested_mmus_next = size;
 	}
 
 	list_add(&blk->list, &kvm->arch.nested_mmu_blocks);
+	kvfree(table);
 
 	for (i = 0; i < nr; i++)
 		kvm_nested_s2_ptdump_create_debugfs(&blk->mmus[i], size + i);
@@ -134,6 +213,42 @@ static int kvm_nested_add_s2_mmus(struct kvm *kvm, int nr)
 	return ret;
 }
 
+/*
+ * A vcpu had to recycle a shadow S2 MMU in concurrent use. The request
+ * is per vcpu, but the pool belongs to the VM: grow it by one MMU per
+ * vcpu, within the budget and S2_MMU_MAX_PER_VM. If the budget is used
+ * up, the pool keeps recycling until another VM's destruction returns
+ * some. Stop growing for good if an allocation fails, so that a VM at
+ * its memory limit doesn't retry on every recycle.
+ */
+static void kvm_nested_s2_grow(struct kvm *kvm)
+{
+	int nr, add;
+
+	guard(mutex)(&kvm->arch.config_lock);
+
+	/* Other vcpus may have asked too, before a grow or a failure */
+	if (!READ_ONCE(kvm->arch.nested_mmus_grow) ||
+	    READ_ONCE(kvm->arch.nested_mmus_no_grow))
+		return;
+
+	nr = nested_s2_mmus_budget_take(atomic_read(&kvm->online_vcpus));
+	if (!nr) {
+		WRITE_ONCE(kvm->arch.nested_mmus_grow, false);
+		return;
+	}
+
+	add = min_t(int, nr, S2_MMU_MAX_PER_VM - kvm->arch.nested_mmus_size);
+	if (add && kvm_nested_add_s2_mmus(kvm, add, true)) {
+		WRITE_ONCE(kvm->arch.nested_mmus_no_grow, true);
+		add = 0;
+	}
+	WRITE_ONCE(kvm->arch.nested_mmus_grow, false);
+
+	if (nr - add)
+		atomic_sub(nr - add, &nested_s2_mmus_grown);
+}
+
 int kvm_vcpu_init_nested(struct kvm_vcpu *vcpu)
 {
 	struct kvm *kvm = vcpu->kvm;
@@ -155,7 +270,7 @@ int kvm_vcpu_init_nested(struct kvm_vcpu *vcpu)
 	num_mmus = atomic_read(&kvm->online_vcpus) * S2_MMU_PER_VCPU;
 
 	if (num_mmus > kvm->arch.nested_mmus_size) {
-		int ret = kvm_nested_add_s2_mmus(kvm, S2_MMU_PER_VCPU);
+		int ret = kvm_nested_add_s2_mmus(kvm, S2_MMU_PER_VCPU, false);
 
 		if (ret) {
 			free_page((unsigned long)vcpu->arch.ctxt.vncr_array);
@@ -842,6 +957,7 @@ static struct kvm_s2_mmu *get_s2_mmu_nested(struct kvm_vcpu *vcpu)
 {
 	struct kvm *kvm = vcpu->kvm;
 	struct kvm_s2_mmu *s2_mmu;
+	bool in_use = true;
 	int i, victim = -1;
 
 	lockdep_assert_held_write(&vcpu->kvm->mmu_lock);
@@ -859,8 +975,8 @@ static struct kvm_s2_mmu *get_s2_mmu_nested(struct kvm_vcpu *vcpu)
 	 * hasn't been used since the search last went past it (such as
 	 * one left behind by a torn down guest), is recycled straight
 	 * away. Other free MMUs lose their accessed bit and get a second
-	 * chance. If every free MMU was used since the last pass, the
-	 * first one found is recycled.
+	 * chance. If every free MMU was used since the last pass, they
+	 * are all in concurrent use and the pool is too small.
 	 */
 	for (i = kvm->arch.nested_mmus_next;
 	     i < (kvm->arch.nested_mmus_size + kvm->arch.nested_mmus_next);
@@ -873,6 +989,7 @@ static struct kvm_s2_mmu *get_s2_mmu_nested(struct kvm_vcpu *vcpu)
 
 		if (!kvm_s2_mmu_valid(mmu) || !mmu->accessed) {
 			victim = i;
+			in_use = false;
 			break;
 		}
 
@@ -891,6 +1008,14 @@ static struct kvm_s2_mmu *get_s2_mmu_nested(struct kvm_vcpu *vcpu)
 	if (kvm_s2_mmu_valid(s2_mmu))
 		s2_mmu->pending_unmap = true;
 
+	/* Every free MMU is in concurrent use: the pool is too small */
+	if (in_use && !READ_ONCE(kvm->arch.nested_mmus_no_grow) &&
+	    kvm->arch.nested_mmus_size < S2_MMU_MAX_PER_VM &&
+	    nested_s2_mmus_budget_left()) {
+		WRITE_ONCE(kvm->arch.nested_mmus_grow, true);
+		kvm_make_request(KVM_REQ_NESTED_S2_GROW, vcpu);
+	}
+
 	/*
 	 * The virtual VMID (modulo CnP) will be used as a key when matching
 	 * an existing kvm_s2_mmu.
@@ -924,7 +1049,8 @@ static struct kvm_s2_mmu *get_s2_mmu_nested(struct kvm_vcpu *vcpu)
 static void tag_s2_mapping_mmu(struct kvm_guest_s2_mapping *mapping,
 			       struct kvm_s2_mmu *mmu)
 {
-	BUILD_BUG_ON(S2_MMU_PER_VM > SZ_4K);
+	BUILD_BUG_ON(S2_MMU_PER_VM > S2_MMU_MAX_PER_VM);
+	BUILD_BUG_ON(S2_MMU_MAX_PER_VM - 1 > S2_MMU_IDX_MASK);
 	mapping->nested.start &= ~S2_MMU_IDX_MASK;
 	mapping->nested.start |= mmu->s2_mmu_idx;
 }
@@ -2210,6 +2336,9 @@ void check_nested_vcpu_requests(struct kvm_vcpu *vcpu)
 		write_unlock(&vcpu->kvm->mmu_lock);
 	}
 
+	if (kvm_check_request(KVM_REQ_NESTED_S2_GROW, vcpu))
+		kvm_nested_s2_grow(vcpu->kvm);
+
 	if (kvm_check_request(KVM_REQ_MAP_L1_VNCR_EL2, vcpu))
 		kvm_map_l1_vncr(vcpu);
 
-- 
2.43.0

