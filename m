Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011018.outbound.protection.outlook.com [40.107.208.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D43A38DC74;
	Tue, 22 Sep 2026 18:23:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790101433; cv=fail; b=b+wpKaM0M1JL9kdPhDvcN8Vvy2gbKzQBzMxd3KQpU9G0MfK/+5GHrvH0ufaDr5HfB+0VNswf2//btACS2U6+kXA5Jc9DywLUXUhazuS32AUBrLbmqySION9tEjZX7S4fl9gnzKQxZqjW0muNoW7ChzsYSGpXFjQdJtd2//18hKc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790101433; c=relaxed/simple;
	bh=qx9tjfkWc4//Ko3o3ZApuPrx9CgoCy9GEhAmtHPeUxE=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OJLBMSns+6RHmzdlZ0RBwBnUQvWpsvowaMqMuFKG879UnJAqL/2l4Oq/SxdEZMONUCEvZrhIUowepijBk8XSJUdTd28UwulJzG+kgsyvxLLoLs/j3KwlMZzxm1qnXSOezNiZZyWjy2oXzdkTRdaJpno8PC+sjeFH/+E8I/JDR9E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=lXdnlxZu; arc=fail smtp.client-ip=40.107.208.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="lXdnlxZu"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fta3U01juUnohiAk7KVbwjcQxuAk3TDlq8+fe4P0hWwKl1y7sojSbDN8qXSv+96X4mVW/fbx2NOvjT0ewKGH7mKe5bD1wK+DXrMv6qJtssogckoBkX2ybZ6/QZ3VykrgfnTr37c+8wmSlnO0BJhTCXi7+Ufs30tx9mVoLbrL0Jh/MGd2pUqrhE5mtH4UUwDN+SkNc4aHji0h97RhkDzRd77xbaxTtF9DHjPT1n1q5Z00pODoiKw1z6YUFRgLqtmw7dyejSeEYIUA68RhG4JAxstuW8RkevNZD4Iqm9ruCLwVfnsFMiEv2dNAubT7f/Igr+0oj+3IbUOV0OvQVsJAsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PJ2vLxRJOkQPloNa2sZzRcDluTyH6MwkjdlwHIgY+k0=;
 b=M73gY6+Wgkzv0BIMGIFZC6PEdevU/g+wVstYw03o1GpaL8IzlGibUow25y65l6yvnAIexfZKMQRfkI0z2bnQqnEz9XBzYwqF5kGZdA6dk4SqDKA91Yiulv+0Q9GBEdA6J7/4gXYe1XM0w73FLMQAWv0leRPvzWy1Geb3RCAHcn8bFwkPzK2Ss9MeL/x6OnqSq8mtVzKgja1JlQY1r6XrZ2X9ltX/AxHXbmSbGAwLa6ynPBacSr7Scd48W4/H210suwabSTWNeSJ1o32DDRBkRSflA/VSbWTFPYd0OxqcJ3RSfNqHkAWfpJxRUs88sG1CbCsR5GcZwo5bM86tqL4+BQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=google.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PJ2vLxRJOkQPloNa2sZzRcDluTyH6MwkjdlwHIgY+k0=;
 b=lXdnlxZuMzq5/uoVFEnlx/uzZMcyOne5RISWS6oObn/FW/Urp7Bckba97Tq5YIqb7Eg7CvbF9up+iyanFN0zK7QUvxsBSNzpeO2fA/5EVkwSu6d3C+Dz4neRsllUouvm9MxyGgbCGNuWJyxQ1RS14aR7HJYU9zg1MVHA/LKxi8RTpsXfxYAGaA07visMhcBrOJKVhWTXScZ9/p7bx0Rm2z3o+uKsSISOQ3VcuARQv35kZ9ECCW6UfGWTDWfL98kP9YfhgFmWO6UWJf/5Hcg0LPSra9q4BHZs34dUcHklMzSfj+SsTTa4rquMCjgzYRb4zJX3QBNUPQn0PrC70YO9dw==
Received: from DS7PR03CA0188.namprd03.prod.outlook.com (2603:10b6:5:3b6::13)
 by SJ0PR12MB5675.namprd12.prod.outlook.com (2603:10b6:a03:42d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.16; Tue, 22 Sep
 2026 18:23:46 +0000
Received: from BL02EPF00021F6C.namprd02.prod.outlook.com
 (2603:10b6:5:3b6:cafe::69) by DS7PR03CA0188.outlook.office365.com
 (2603:10b6:5:3b6::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.16 via Frontend Transport; Tue,
 22 Sep 2026 18:23:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL02EPF00021F6C.mail.protection.outlook.com (10.167.249.8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.451.8 via Frontend Transport; Tue, 22 Sep 2026 18:23:45 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Tue, 22 Sep
 2026 11:23:15 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Tue, 22 Sep
 2026 11:23:15 -0700
Received: from nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49 via Frontend
 Transport; Tue, 22 Sep 2026 11:23:12 -0700
Date: Tue, 22 Sep 2026 11:23:11 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Mostafa Saleh <smostafa@google.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<kvmarm@lists.linux.dev>, <iommu@lists.linux.dev>, <catalin.marinas@arm.com>,
	<will@kernel.org>, <maz@kernel.org>, <oliver.upton@linux.dev>,
	<joey.gouly@arm.com>, <suzuki.poulose@arm.com>, <yuzenghui@huawei.com>,
	<joro@8bytes.org>, <jgg@ziepe.ca>, <mark.rutland@arm.com>,
	<qperret@google.com>, <tabba@google.com>, <vdonnefort@google.com>,
	<sebastianene@google.com>, <keirf@google.com>
Subject: Re: [PATCH v8 02/25] iommu/arm-smmu-v3: Move Queue and STE functions
 to header
Message-ID: <arLHj4/aXNBlUFvM@nvidia.com>
References: <20260922131259.2975334-1-smostafa@google.com>
 <20260922131259.2975334-3-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260922131259.2975334-3-smostafa@google.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF00021F6C:EE_|SJ0PR12MB5675:EE_
X-MS-Office365-Filtering-Correlation-Id: 9d31df3e-a6ce-409f-2509-08df18d6a3ac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|82310400026|376014|36860700016|1800799024|6133799003|18002099003|22082099003|4143699003|10067099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	P76+DNMHZdaJmtmOTL7TtTEoKs8qXGTEsS3bEAhtTO+8CDAcvkzHzhxN2r4u0Ik0NSxlLvWbMW8DhP2BtN8W4X9lY9Tk9tBpg4Iswa4ATiGv6KDanwgRh4MOvqiedNTPkIUWBeXa+wckYSbaYsBRWrpzs/JwF341llLYenVSde43fgJCmDI3H1vL/gozQLvE7OUyW7M36G2lk1Ni3wAD93vH3lVfd+xNWo3zNqaGo6sEp509Dsq2MNqL8/nQP1j+8jL+MuC0EDJNqRzrT4d7cRCttfp/XSbfXKVK/wlHOOeWZVmbGlc0f9Bm30TL1ttTeR8MFP5i5aiv3b1HVa7JIzaYuP525ugMwChmhk+SpLf23X/gONfdQhKQWAen4BjG+3i0DVx/4eq/JJJdoH9OE0dZAj8eBMKylxIVQQckE542699w54p9N73wzlmXpXC6WSmX2kmTV8x6kc3CW4ub6xWDO1HEK/4SDGpLnTiFIBF6RPDcW3MPNGs3SbAOkY/jYQV7h+4ObeoU2am2OwZSuKfkEYmLIL/EUVU2m4rOW+WUvfKul7QHgWuu7sIwuXzPF6BKyxBw7zDtEFYtmSsuVzydK8XGYRqBibRrZjrvelJB9Ange32iZYjyXZOe7lAqhHUt7D6Zw+AjcG8yWra2xm39bD+xc253Q/k5zDszclBmlPyJGs8ZQfl2NdcC5z2xFMNzfRH7ZzCrqVHRK3lQ+Q==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(82310400026)(376014)(36860700016)(1800799024)(6133799003)(18002099003)(22082099003)(4143699003)(10067099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	NiZU+9ofmNEaFHsVmJ+FdmOI6wFjcv69ypjNuOc+16igF4Sw1EbQcSWSsKJXclNiegGU9JThciv0633eklBYGJZYXHGj7eZFj+3o5MwDzd6bjt4I758AB2oPEI1Je8jc9dOHkGfDkwsldsKcUhcj2C633ry5FALYBcsWBDtc9PwAX1sMXDXkLyBluf78VYmEyj6L4g7cG2RnExFYmfyLopPxYgVmLHNQRzKMbMAh91QuUECiQS4740/AjVPlJiqokX65IrUqNm47BHHcRwTbCRcc6bgp5bb/hgFHS5n7J/EpWUXduqOp/PtlGQ48t/RUlT/2mR37THZRVftztwxJ90obgBqWrGpD2KlKcI9Appq8GkebUOJXH0arnDms4FFjWJHjNvamFzKLzi0mFIrGABy8NofwUa4lwgKTDE2hGAK25D37ErCyUdWiUckcqcxS
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2026 18:23:45.6020
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d31df3e-a6ce-409f-2509-08df18d6a3ac
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF00021F6C.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5675

On Tue, Sep 22, 2026 at 01:12:35PM +0000, Mostafa Saleh wrote:
> The KVM SMMUv3 driver would re-use some of the CMDQ and STE code
> inside the hypervisor. Move those functions to the header file that
> would be shared between the host kernel and the hypervisor.
> 
> Signed-off-by: Mostafa Saleh <smostafa@google.com>

Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
