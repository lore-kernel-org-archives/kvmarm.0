Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.57.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794269841;
	b=bJs2+kiVRVMkEg4g54QkTYxlIIpjjXz3kKrWh8BxR/Wt5b9uZnEXyXnW0EFkf0NQsqkU
	 kCTgPsx9XAi5V4u289TTSyEuCuScynBh7r7lv0O8fLxOecIYv4sLFvf+ldI+m0VOvaW6G
	 6aHfjU0/M3Xk2vhDN3YvvtW6vwRrWu3iBu6bY9wqrJC+krlcJzY3okFVzD/0itrRjAdKh
	 WdnR878p8245RkcUzSyM9RTlg1PYbYrIq14H/musYiNR+3M7OYf5EayvVTBwMNKJ1IsbE
	 yM+uLQ7GMdxC2Vhv6/uY56kg3S93gnB/aZ6oq/MZJEMrR4t2D5XIudU9j2q4OMwZi8w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794269841;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:Received:Date:From:To:CC:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:
	 X-NV-OnPremToCloud:X-EOPAttributedMessage:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=RJ36JhmwCAUCGImNmtkvC2/pUrrSeH9vb42BEBLFWFU=;
	b=csiHsBlyQA8Fl5HcY/XWC9LLJ3ivYAC+wh/mH8RzNkwSjZiyRTkmqnTsZG9oNNyQEl+b
	 mMrkTFeAPrp5NV1hMEE9zd3yDfoabPbOplOKaYsy1HTT0TOVvQxFQvCWk4Pesaxm3gvkA
	 O2ASfg+Tj5zMIHysGLFHG3NI+RJiTSsqIIx4WR+UfIimVr36OfOizjsUcOahTaD9xP9gw
	 P7ZVgcBUVyyq0LYb/vQFEf7T1UUtm8kAbnlk3JOBYhXDwb9UH4LxLgibQ6Cd3NcjS7bRU
	 QBTcMSCzXe+WARQlfXprGLGJppp8l1wGDRyrg4tDVMWaJP7JAH+UH+c+qrIcFh1U4jQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=Tu3dGBVQ;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.57.18
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011018.outbound.protection.outlook.com [52.101.57.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B5BC606A333;
	Tue, 10 Nov 2026 00:17:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7B5BC606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=Tu3dGBVQ
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=roxaZgc9k47bExUmqxsSAGoe9/iYNAoi7milX1hCi6wBkEV5LofY5XXQKtVs3Y4ENDqNmy3Se2XYXf6JsgaMJp/a6ilywJYpsP9KtxhPbf4aqBcykvbzwB4PhV0AL/3Z/yPJp4HTU82iEdtYuX03KTRsfZ7vUbKuL98/g3M2tEzyd0uWeivOyuwUVe0o2Skvqx2+14/dEzwa2WONPpo6HY+XExaKMDAOHJAowsANrlM7SPBWLAW0IF+Yg1J3C1CxPBicJkZTQkriNYSIPSVPjJLpFj0g10K7+oa1+EinwXo1Y4/c5Q1kBuYXIdCCabnaX0OKXe+zl/cSbyFQmmRhHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RJ36JhmwCAUCGImNmtkvC2/pUrrSeH9vb42BEBLFWFU=;
 b=vFAJTSRX7Wn6B5iOId8vVKafysZxJ9u7BRNI6EUCo8zgfZnB9TTsHvVNa0jH7VgM5Qhf2nNB30T6VKl8CY2UgwhrD8x73nYAVR+JC5Bqx7ioNvbepc7CRic1q1XBc2zaL/DPoUCJ3t0QUD8y1MfezlnuvbZ5FV1wLl9Q3xrYOZ6XXdTplVpmYy6faRhQ+XkTPmG7abddi9eSUogNNsJKLe3vvclxxArNN5WvdjucEfQ618T3f+7Tg8VDPlZEXl2csx7b3Mi91sW9o2llOtz+N0cy+tOJffaSy3xnqCMVLz/lb0eiLpTLwXXO8Qe+TxyV2smkqEVe+T91oBYKDafwLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=google.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RJ36JhmwCAUCGImNmtkvC2/pUrrSeH9vb42BEBLFWFU=;
 b=Tu3dGBVQ21tYrLHRxi5n3RqISNEp80umU7v3U5OwPd3bCK67uz/zVdDYl35GnT35WoQ03PhBKF4yq5BlwWJnXyVOoENUAczHtRClZu0OxtLrf7ENGBq1RuxgVLT5RJ0Xfjp8eHsn8G4QzEvEwFok92CXVVCnZCLU6IERomTeueqO1tqpV9VOfkItAGJ4LHykV3KCyjte7Sl5VUMcR1alF06w6VDAFzsRL6oL4Qv/pNZwNTFxdqw4BaVe9YVMgd38WCDS7CSOE/VCXZSGYusjOp/3Fy1yOI2+BfAwhVKOAjtcBaS9xFZPa8Jbx1w/q2Tckg0ALGG9kDi3wXNAhqxp9g==
Received: from BN1PR14CA0010.namprd14.prod.outlook.com (2603:10b6:408:e3::15)
 by MN0PR12MB6344.namprd12.prod.outlook.com (2603:10b6:208:3d3::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.12; Tue, 10 Nov
 2026 00:17:14 +0000
Received: from BN2PEPF0000A894.namprd04.prod.outlook.com
 (2603:10b6:408:e3:cafe::45) by BN1PR14CA0010.outlook.office365.com
 (2603:10b6:408:e3::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.12 via Frontend Transport; Tue,
 10 Nov 2026 00:17:14 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN2PEPF0000A894.mail.protection.outlook.com (10.167.248.186) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Tue, 10 Nov 2026 00:17:14 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Mon, 9 Nov
 2026 16:16:58 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Mon, 9 Nov
 2026 16:16:57 -0800
Received: from nvidia.com (10.127.8.9) by mail.nvidia.com (10.129.68.7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56 via Frontend
 Transport; Mon, 9 Nov 2026 16:16:55 -0800
Date: Mon, 9 Nov 2026 16:16:53 -0800
From: Nicolin Chen <nicolinc@nvidia.com>
To: Mostafa Saleh <smostafa@google.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<kvmarm@lists.linux.dev>, <iommu@lists.linux.dev>, <catalin.marinas@arm.com>,
	<will@kernel.org>, <maz@kernel.org>, <oliver.upton@linux.dev>,
	<joey.gouly@arm.com>, <suzuki.poulose@arm.com>, <yuzenghui@huawei.com>,
	<joro@8bytes.org>, <jgg@ziepe.ca>, <mark.rutland@arm.com>,
	<qperret@google.com>, <tabba@google.com>, <vdonnefort@google.com>
Subject: Re: [PATCH v9 11/25] iommu/arm-smmu-v3-kvm: Add the kernel driver
Message-ID: <avJidXM9yQOX4VBJ@nvidia.com>
References: <20261015200903.2735565-1-smostafa@google.com>
 <20261015200903.2735565-12-smostafa@google.com>
 <auzvygiGRTWgJXzF@nvidia.com>
 <avGk0ilyJh3obmKx@google.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <avGk0ilyJh3obmKx@google.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF0000A894:EE_|MN0PR12MB6344:EE_
X-MS-Office365-Filtering-Correlation-Id: 052168f3-9c1b-47cf-e8bc-08df3ebff909
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|376014|7416014|23010399003|36860700016|261028144727099003|10067099003|11063799006|4143699003|56012099006|261021121427099003|261022075727099003|261022105027099003|261021135927099003|261009223027099003|261026140227099003|261102123227099003|261026121527099003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	3Q4cIg2JIJ84/HScjow2VXcMI1uuyQ543+nYiY9qwwBDx/7gKhWFTfdYEcWEi3YhGLcmfMEmT6ZyJaj3zW1CZPfjHm16XaJj6RZlFOujV8fxPO7oTGwmpYOmMV6hZj1ueUi1+k9WDQvvAQKqc2KSMUfRiTlyTBZ+Cu5PdA2mPouf83JQPf3Ep9LZaZloJTItylVnTWVNFNxDpwkRpJ0h1C8aBKvEhIS4M8WrkqTe09JUnYV2gE0dx0zTSoUkqyuc20jnJEajZkWn4jFX/Eo+GODIqJi5nr/KG2D+DPUNayEdTEvZBZsvTxbil1IwGWqW2OE+TdcUtyc9JcWIBkz6r8p5VSZCt17THz52H+5/sv8a7HmXtwkLT8AqPC39s1lMVQqHcApSnIMFqTvYsYofrQtt0gws68HbJl4Yt8IpsTWvfvTMi22PM7kXy65CDhSFd6b8EM7tarA0uE2wlz2Jqx7GecbjwsFy/Z+02Ep/HsxsOaqBf9HBdqEU6lCOv/jpu4o2wXGtW+gfajNF+jfaoyRcIzOAC+fE0curF8Z6kNHnBp+RTdImd2Vuh6I5ZsZjyVoHf/vz/fnQViE6sP4T7dElhWVDYrAx47l5S0cV7z2r+AWEn3MqkcdCD6xChggZkuDecPyYhMDxBPCeJ6gl2aiEUIm05KAyWsZOjqI42z/0C6r6g2/3CZmhcmgnAx4sntqeBm8fRhT+esL9tBSM4Q==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(376014)(7416014)(23010399003)(36860700016)(261028144727099003)(10067099003)(11063799006)(4143699003)(56012099006)(261021121427099003)(261022075727099003)(261022105027099003)(261021135927099003)(261009223027099003)(261026140227099003)(261102123227099003)(261026121527099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	ZCTX0zLr47gHJcPHYTwZqvSZ0cSODxq0DwoEbbyvD2bctkLclvoFCmT5QzhtujTz/vMetUFJGHaD02jHzdA/sg9fAsTq45eLyWU7RKbtBfBM0+DjFNXRwEVk8KQU0krwKglVHE0UzToxZQ0MGY1glUVCKGktpOcf2EmnC/YcHhaMpatxg5bY8KT9K2KUDmZGDj5sJU9z0w8uR1zDdhW/d+pPWTqet+ugCN7oOt/3JDFGDO5L4EDQg9jyaadWwN36sjXVqifw26BAi4lkdiD1DtEhSjbUEcFuAkRx3NHDEF2L6zNiFDH+1ZaJPUlL5TuKuWcwW5bw8537vn3nivN/i6eXiZabc2bTXqEWIrqbtCotKZX5ZQrrg/oPiUMihDxgqUkZrVY0ZRUyyDekix9E7UEfPgbU1Rm0GAOvR6HueyX6Wcgl9dstC45jIJbzPu7m
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2026 00:17:14.5815
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 052168f3-9c1b-47cf-e8bc-08df3ebff909
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF0000A894.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6344

On Mon, Nov 09, 2026 at 10:47:46AM +0000, Mostafa Saleh wrote:
> On Thu, Nov 05, 2026 at 01:06:18PM -0800, Nicolin Chen wrote:
> > On Thu, Oct 15, 2026 at 08:08:42PM +0000, Mostafa Saleh wrote:
> > > diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> > > +#ifdef CONFIG_ARM_SMMU_V3_PKVM
> > > +/*
> > > + * Two devices are involved: the aux device bound to this driver, and the
> > > + * physical platform device bound to the pKVM init driver, which only uses it
> > > + * for discovery. This driver keeps using the platform device, as it carries
> > > + * the fwnode the IOMMU core and consumers link to, the DMA configuration and
> > > + * the IRQs.
> > 
> > It would be nicer to have a diagram or so to show the co-relationship
> > among different devices and drivers.
> > 
> > I assume the regular arm-smmu-v3 driver is a part of the picture too,
> > when the pkvm driver binding fails?
> > 
> 
> I can add some ASCII diagram.
> If pKVM driver fails, no aux devices are created and the main driver
> probes the platform SMMUv3 devices as usual.

I didn't check closely, but would it be safe to do so?

Is pkvm aware of the missing SMMU device and handling it properly?

When pkvm is enabled and the SMMU device is supposed to be a pkvm
device, should it not fall back to the main driver?

Nicolin
