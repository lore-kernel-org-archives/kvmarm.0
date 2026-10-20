Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.208.33
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792523544;
	b=elr4Dhk8uDfVN1yL5xxgG7YY3tqVT9Po5hUEe1AUuj+5oD0b0dMKn5E8y/534OQUpygo
	 9PThIurNwzm15xCKmA5ECT5uVDwA9dcuB9OYaTy8Us3kSNd0vuXSkr9Swv499pEXFVw77
	 SWzYhjr1OOFelZbz9lyaIqqWR5iXL0NbpIO/VPEDWCxtAThtJG7f1nz24S8W4Uw1F8qvE
	 j+4X83iCKaWw+rdK7PCa61qkGd+ROUtQ2q73T8ngA2Rv/tUhV5j1ISQImaW/a7k7tpyhU
	 M4UoQPewRLp66YQxsFpSHWMbptYNuzkM+hUaPph4Thfn7yQD1IUbTIFiUHPtBhywOqg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792523544;
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
	bh=4XTodJAsDoJNWSa3RC3URUXvrD/57eq5th1XRNWTcnI=;
	b=rY52KQuEtbFFLxhHcj8feFRgFd84c1WBFXRcAgq5QbY0m6wiCUXM/kx73UorORC0rRYF
	 gKraGtBfW6A8FqHImDJXenBLhXP1jYseafbr+oF2IsmTgXeIMOWs35+opG7/c3UTy1wIH
	 fTsTlAH1B54mHjIn3AMNUetNibOyz0Q/1YIh/cxSYhdXaaQPqeQ5EUXSQMWZFI0qH3yrh
	 fRvBrL+6P0xZg9/XNICVHblBNfoIpzgGtahR3+WcQGsBLftqN7+uKymT3dVUMrBHN6VWr
	 +MaVhgC9ddep7rCTfFfJRWAZgDT/YMCO76Mdn9VVB/GaETzz4CZoNpH/v2RJfLingIg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b="DxEw/MKK";
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.208.33
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011033.outbound.protection.outlook.com [40.107.208.33])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F8CA606A31C;
	Tue, 20 Oct 2026 19:12:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3F8CA606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=DxEw/MKK
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=n8wfiTCWn1L32g31kWWjmCwIT5r6JW7blg9L52mVNcHGP4xBU0y3oalGF6LnHMFP2CjRw74yKxj8zQh3PKhb4ud21R6OH9RVoCa8rDfa5/1udQX0tJ7kWCreoIyHstjk2w6qilcD38HG3PVfcDVnx15U9g9P82a4LdO7u6BBVo4XHdVBf8ucl6KBnNqXFv98G1XKjorRMt49wCKwri7N7gZc56VYXt8uiijLeaRvdRwKqpkVDQYX+y3dO6EuI4RRV7Rew2+SnUwGpNYQ87j8fBgsyEERsCIITqRSOoOztHqw0qUCbGDviBX7zpf0NF827tDkW83YqR3jRNzomPRKew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4XTodJAsDoJNWSa3RC3URUXvrD/57eq5th1XRNWTcnI=;
 b=orLNC6jbhTh7lr457neDfFnh+6iO4Wz0prolzF9b8wEtR14tub2ja+zVlyP/ovtZ2qmUocNy3NgIvsLNWvaLSLAd56FP6pSzgcWj97yTdQxAPH7T/65spbjHNp/KuO9Xecl3mrqlFA5RfNSkB5kljr2hEI0UxI3wsM+sddoHXST7Fog2JfHlPmLfIgk3Jqb8erRN5mQXI+wAsG7BbAUAmMpl7q3cHvI4IqND+o8ckJDeRN5p4FX0N926IxiU8piVYIEFw3Hr/Ijux5v8NWUvJkvPfsmBImU+hO7+J5ng6Cw7eju8pBG+qwhHvaH5TkfsaO98jx65WFoiHI/MjAGxnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=google.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4XTodJAsDoJNWSa3RC3URUXvrD/57eq5th1XRNWTcnI=;
 b=DxEw/MKKpf/9pUCFBMI5Gu9foK851lKl+w65K2x/fgMJiZ2TL2o1uqnA1Jy+W29xNC5GtRc6AozNlE6Lg1eg3wgU2gw+vo9aR1XyyKyBd9+wVLcambQlrPQvvP8wmpiezBMOrN4dc84QI+Hp5P6Y6UqKeaHIVrWJ3ilJDUASLARdQpYV6xILIi5jceZK9wseUH2Y25PZKfHAL76dvjV4ksvk5VZXXzRqeZCJ3jz8wKgcWNUm4k6gfWolEB7rv4Dg24hg+0k1RUn6ERhTvBMOgBTaAfo8L3YKvacZycsizHrbJieMDn9eibSRM6uLHCbIjp4AXitIx51pknfbsuQzoQ==
Received: from BN0PR04CA0175.namprd04.prod.outlook.com (2603:10b6:408:eb::30)
 by DM4PR12MB8557.namprd12.prod.outlook.com (2603:10b6:8:18b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.15; Tue, 20 Oct
 2026 19:12:11 +0000
Received: from IA0PEPF0000003C.namprd03.prod.outlook.com
 (2603:10b6:408:eb:cafe::97) by BN0PR04CA0175.outlook.office365.com
 (2603:10b6:408:eb::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.522.20 via Frontend Transport; Tue,
 20 Oct 2026 19:12:09 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.232) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 IA0PEPF0000003C.mail.protection.outlook.com (10.167.249.73) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.546.15 via Frontend Transport; Tue, 20 Oct 2026 19:12:09 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 20 Oct
 2026 12:11:37 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Tue, 20 Oct 2026 12:11:37 -0700
Received: from nvidia.com (10.127.8.13) by mail.nvidia.com (10.126.190.182)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49 via Frontend
 Transport; Tue, 20 Oct 2026 12:11:36 -0700
Date: Tue, 20 Oct 2026 12:11:34 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Mostafa Saleh <smostafa@google.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<kvmarm@lists.linux.dev>, <iommu@lists.linux.dev>, <catalin.marinas@arm.com>,
	<will@kernel.org>, <maz@kernel.org>, <oliver.upton@linux.dev>,
	<joey.gouly@arm.com>, <suzuki.poulose@arm.com>, <yuzenghui@huawei.com>,
	<joro@8bytes.org>, <jgg@ziepe.ca>, <mark.rutland@arm.com>,
	<qperret@google.com>, <tabba@google.com>, <vdonnefort@google.com>
Subject: Re: [PATCH v9 05/25] iommu/arm-smmu-v3: Move RangeInval to common
 code
Message-ID: <ate85hw0FJGHpYCF@nvidia.com>
References: <20261015200903.2735565-1-smostafa@google.com>
 <20261015200903.2735565-6-smostafa@google.com>
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
In-Reply-To: <20261015200903.2735565-6-smostafa@google.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PEPF0000003C:EE_|DM4PR12MB8557:EE_
X-MS-Office365-Filtering-Correlation-Id: 5a4870a1-940b-47a0-6e0a-08df2ede09ff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|23010399003|1800799024|36860700016|82310400026|56012099006|11063799006|4143699003|261009223027099003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	p1JrVareuJFHESBMW9JZA6nYQhLqEPSgrqXLZWF+3GuKoCG+uOZ+WUfcnkV1RnlQNVGpXhS8aGuGWsKMQwjSpLu1c6rXbnG4djeDAziVoRm98ysJXRITi5StBP40IQsc2eHmB6nzDS3VzVBhCKM1NaCZjgoZ2C5zB7dyrGJUrluzOE7dx2VPkuSYdEsvEEF8jUF4uJymOSBeqNdEp5vzn81K84daSwgXTZRyxtud0GxSeJGSKPq/ZYAWpRsfIF1m91F96IxAfvikFvnc6ReD4gEm2YbIWz9grlbncinM9MgaztcOoOlgeuy9dtpYp3RnRj/aQt2fqzYD74P5QX4andWU/9l/49srSzXpapp6St7KtZ9JLdvNdLz+Uls8Ep5W7XWSDskDwtSTkZfNBUIh3feA6c478lzeRd3YNm7ua3dpZr3ZpcLBUl0LDdpC7bc4ItzGLFHjQQ7BMHK/g9mJVgBTxQ4Ac2Fmf3UogOGt90zb/iU14O0pXxATleCrOmlR0tmYHFUu3B7R5VsLZQAUDjl/2np4ZKtVC/EF5xj96ZI09u8Wt4oTg+9hUevnA5aG3e7D7JMkuHrNBGzBWl5ZKsf4KrLPN1OGxnqMC49K4Loh/r4xy0YpyXyp8aw6Zm0RmcIHve1nRokzRMqAp3HfGwNmJCdEWXXgA2m11f3y/DTUW2ATW/s1CaEY4EIB7K4njoPoH4iwajVdt8huv0uU1A==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(23010399003)(1800799024)(36860700016)(82310400026)(56012099006)(11063799006)(4143699003)(261009223027099003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	aMp5TlbV3k3g0oO0gssBv3A67eI3jTqq+qhH65I6Dm8qWZTtNEGWNYvSRsY8kRViUdYZT0fJgsL/VFNzMfh4dP8gPxHf/bKNL/z8L1K32980/EuKSy41xWjfolZUF+HoePw3ZBvL3sbfBf8lalkMEnP3gdH/3NEUlOFXhoAkwpoIbmOf+i3Y2oOUQSR/6u5nEthOxGXsUal/rO+E7mlArME+CaCrM/X9ak1Mb0l7bYS5iN7crX8eiOUD12yT+jaxUl/jlXZ3lx2xpZSBOKEDIFO2oYDAS+IvwsGFEWKP3Jkc4rl+mx+wQ09rek8JWdM0C/HAkaMb7nkGj8TxkOEf+8rZLgmprQmT+7ITyQYge/bP54BP+glYkNhDUc35noWOac/qenHsUpUu8eoM2CuzT03/fHDDxqi0X+ViiXGjdYtxkUbzrwkgIaW0kjurwXZf
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2026 19:12:09.3301
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a4870a1-940b-47a0-6e0a-08df2ede09ff
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	IA0PEPF0000003C.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB8557

On Thu, Oct 15, 2026 at 08:08:36PM +0000, Mostafa Saleh wrote:
> Move arm_smmu_tlbi_calc_range() to the common code shared with the
> hypervisor as it will use it later to populate TLBIs for the SMMUv3
> stage-2 page table.
> 
> Signed-off-by: Mostafa Saleh <smostafa@google.com>

Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
