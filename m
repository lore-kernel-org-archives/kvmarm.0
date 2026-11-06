Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.85.44
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793924064;
	b=Hvb+xhSnPXx/MmAv8+W9eDPeVeY2rQ6jrQWArP0oejn++umFFpx5+uu7vPfXdQCU683l
	 CfSi8BRfwJO+NmqTbjfP64U06dUvSV5yokdQQcAYmLJoa3NBJJp0SgHe/E3kVp+b+pt7l
	 0CJ4drGzha4XXm+v8TjCdEzjXD+z/sq6h0poLIud5fOT29ZK8L76UepoQMVnzW1gG/mq0
	 pu8vwnTzadyzjZmmfg1XhDpqGIevPOYvjS8U2yE7Ngal+gXlPysl24Sx4miyYrpqcaSTI
	 OtjBT63W4ChLY2umCOdV3uHLwDvyYcU1U41Czo7IkEMvxLzC83fYplvXEWz/BG7XZOA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793924064;
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
	bh=DsEU2njoQasW9dUeihnGKG2BQIMo1tqQQtIULZmQOcg=;
	b=mWfvIZqU+OC5NLEf0KgoZyMJwcokUYty2V0tst2aQteOrVxQjiCr99PSPm9UX2cQXcu7
	 wRfgleR/v/ZQQ0/gNTjQhG34WHz0UpdaKu9NQQjFF85sWNDNf67shGvlL7A8WFA0FMQxD
	 VBHw+YCaEfzEAMAd6N6dhZ0mBCxNepd2zUozBXBHZx4ViaRqQo2/Z+gOLU0M1UDqd1+TT
	 A18mFDjiOtmXKkaXu7K5jqmi8MIOS5cOdC0nWODSlzhToVn99Rl2rNkRbVdBnJp1W4l+j
	 gEqeSHex6hzB/1ZQwD+mJLGBtXpbQm4md6ay6jYWtjG5HeZ2Fj7dBU1r9ZaASwfshNA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=X4LZjCPj;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.85.44
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010044.outbound.protection.outlook.com [52.101.85.44])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DE19606A326;
	Fri,  6 Nov 2026 00:14:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8DE19606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=X4LZjCPj
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yP7zAlyKJj+Ga3AHG7zJPk1GIJnYTwNoe1OMTw7Ss1dVAfUrphytM0SS9XWd+SgV/nxooQoKjKWC+PgC1TTJJHogKMiTZOwi9ZvGDlmScYHGHAYr7pwL98mtRPjZ8CeubZDGy8mnMP6QSAXrlpSQhtfbh3/DPvKYVJm6mFhQ+DGdgacZ69yVk+zwSViBTIrMbiB1MEZOiKGpkL4UFK+QgKe03wkFITstS556KlJOMZjLdTUITZm9taczMbqON9048Jk3EAuP7ZkvfTAxQJkvLJsJ+UqvWpcP8TwUqvoYPuM23FrSTMQ3V31FD6sfEtNCUTCC/o6pgW/JMkIeWmzYNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DsEU2njoQasW9dUeihnGKG2BQIMo1tqQQtIULZmQOcg=;
 b=dLGpXrZxiZyFOtYPpSSsNUegrMYR18D7bfvYzyMfugwHMxggm5pFU4R9aogbKBVNs4fkuB5o78oTOkmsOHKMLHLddvxFc9I5UpJzNSxL0vC+6F4GrVZZMQf334G7OI+h2LfC/4s/LnXgU1StTg/AXXaa7kLB9L9hTH7eahFmreKMazqXTdFgxIdWC6dQ9N3UIh2swDBT3D+s0rgKMBRNrnlr0lu+BekSE0hRYhUbfh5T90eOtLL2/JT3WdAnz77ch6/dtHNaS8tsy5G7BTPtAGpGfwVMq0GeZQmtXO/PjtNMheLk6Zum82y4U63L1FB+DckQfrzizDrA3mxK4kAhqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=google.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DsEU2njoQasW9dUeihnGKG2BQIMo1tqQQtIULZmQOcg=;
 b=X4LZjCPjMmAK+xcvj+7qT029aiNvbOkHTpH/K4Kn20FCFEM/ACbNEvuYhoTdcp0krsvZKpr14ksxxD0cE7YnBpTPDvPj1ghfqknL5MGu34A9pjwN62ZwZ57QEexZgj4JbOwt3arlncrca6P+iVX1HlS0vLa4d9XNR1AHqsfHwdzPiyILlkWUMeT7djNRRpUWxO0mv5q/FT0jTBOyD1WaTLsKAc8TmFJQMdnu/ZeJgwAfDx0jk5lUkmUjyoMB/frhnvQx46TSTPYNUDFKiYKBfODnGLqDsrrB3YnhPhnsqvVjjnOJ2OG+hHf/TyO7EG+OmTJh78oFYyNpMdeMA4CibQ==
Received: from MW4PR03CA0087.namprd03.prod.outlook.com (2603:10b6:303:b6::32)
 by LV8PR12MB9450.namprd12.prod.outlook.com (2603:10b6:408:202::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.10; Fri, 6 Nov
 2026 00:14:15 +0000
Received: from SJ5PEPF00000206.namprd05.prod.outlook.com
 (2603:10b6:303:b6:cafe::7c) by MW4PR03CA0087.outlook.office365.com
 (2603:10b6:303:b6::32) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.10 via Frontend Transport; Fri, 6
 Nov 2026 00:14:15 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SJ5PEPF00000206.mail.protection.outlook.com (10.167.244.39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Fri, 6 Nov 2026 00:14:15 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Thu, 5 Nov
 2026 16:13:58 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Thu, 5 Nov
 2026 16:13:57 -0800
Received: from nvidia.com (10.127.8.13) by mail.nvidia.com (10.129.68.6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56 via Frontend
 Transport; Thu, 5 Nov 2026 16:13:54 -0800
Date: Thu, 5 Nov 2026 16:13:50 -0800
From: Nicolin Chen <nicolinc@nvidia.com>
To: Mostafa Saleh <smostafa@google.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<kvmarm@lists.linux.dev>, <iommu@lists.linux.dev>, <catalin.marinas@arm.com>,
	<will@kernel.org>, <maz@kernel.org>, <oliver.upton@linux.dev>,
	<joey.gouly@arm.com>, <suzuki.poulose@arm.com>, <yuzenghui@huawei.com>,
	<joro@8bytes.org>, <jgg@ziepe.ca>, <mark.rutland@arm.com>,
	<qperret@google.com>, <tabba@google.com>, <vdonnefort@google.com>
Subject: Re: [PATCH v9 15/25] iommu/arm-smmu-v3-kvm: Add CMDQ functions
Message-ID: <au0bvjRBF7X+zpc+@nvidia.com>
References: <20261015200903.2735565-1-smostafa@google.com>
 <20261015200903.2735565-16-smostafa@google.com>
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
In-Reply-To: <20261015200903.2735565-16-smostafa@google.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF00000206:EE_|LV8PR12MB9450:EE_
X-MS-Office365-Filtering-Correlation-Id: e788d155-7dad-41bd-07b1-08df3b9ae45a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|1800799024|82310400026|36860700016|261026140227099003|11063799006|4143699003|56012099006|261022105027099003|261026121527099003|261021121427099003|261021135927099003|261102123227099003|261028144727099003|10067099003|18002099003|22082099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	LAPH5rEkAwyVxUpTjw2FHmnplKXgPN1sCviXnbxs6xo7f97krFE23WiAjqFtlPwh/hqtPnlVtNEZncWTA1n0Pl8Fo35DWzB0hMYtaVCz5rrgxntksJ/uEA7cv4/6358nXzydJ+e3QKYEJKGnucnGasP50VsnYOWeyL3qMfpxRMOIrShJWN72CzvdJGyKoKEiX+bTAkja5gue7bwKIlBqMd44Qqt/yFWJV4ig+YLNJjQvjVIIZpQ+vaHNgn5LwjQKiDt+ebkkAgQ2ChRFgkaYdIoZrM6Tg6j+gTCZAvuLLLAbt0+a34u/7BpzeM+SJdknjAaT3i6FOmgN4JOJYyl4IsnkYA7cZsosmj64i3EAOSU/HQT0OnFkHR/+V1A99z1aVmw7t8XcLF2FpwWJe8KK01QBneJgTcu3bd6BoU2tIFS3cHhImQiUg2Z694kD4PB/32hCCxlwaKBtsmu6wwN+pffYkXALlWp+afyQN8m98wJSM1LJxkhslyf3Zgj0Gvb77P1abGTQeW3XPcwtaiqVDjRxTIS/0boKu0ZHnnRWD7B5+E2wsR+pkpWcNqgFkwxR1asenOZnoifCxjYfMFn2liepCwx6EAGhSFv9ErNPsaUhUwXJb0caXs9MvQwexXHl6BEgOA5f5JNiitQldBFZumqD0quFIv994G1VoUfYcEWMGR4J0zeVYupOPemE7mZpbgTd6yv0aHDGtzfvRBw60w==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(1800799024)(82310400026)(36860700016)(261026140227099003)(11063799006)(4143699003)(56012099006)(261022105027099003)(261026121527099003)(261021121427099003)(261021135927099003)(261102123227099003)(261028144727099003)(10067099003)(18002099003)(22082099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	ISdUsgVn+G+XHd0kq3Vb/V0UCUU79VxRjTuOhyfLrEUqcoGM9KqzMb/P8Pe/JWG9F+G+H6xAUNZz0qKP6iBYpPemec/gZrcQ4CHZdCvv3EyTyiTsBd42hVbxauFsVANOY7cnVBmUEHDYYp3hC57LOQWaPclQJOk9BOe7PyUPegxDhutyh1vXuBsLEZRIjG5eg2cPOz0RnSllXOhFP6gNQJN1tMEtIKRZUHWz5X4R/O5Nvhw+8K6IUaib79Axj4zwSk8SIWe3H2vUFLLMxa2i5f/2oJ+HX1xQT139SejtYMpxj9s+7KH6jxVodysIsrHT4OQOreZsWEiNsHQopeiwGl1lzaPjcF+pliCfV6vzQ4cKnl6dzpIRdHhCvXfnRc8wjZZ/bZRDbdO2Ysr3P2j7U5ofmW3ISmHTyGMAFmG1851aY2waVUYwERz9i2bHWDP1
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2026 00:14:15.1733
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e788d155-7dad-41bd-07b1-08df3b9ae45a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF00000206.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9450

On Thu, Oct 15, 2026 at 08:08:46PM +0000, Mostafa Saleh wrote:
> Add the command queue accessors. The hypervisor's own commands, such as
> TLB invalidations, go through smmu_send_cmd(), which queues the command
> followed by a CMD_SYNC and waits for completion. Filtered host commands
> are copied into the shadow queue with smmu_add_cmd_raw().
> 
> Polling is bounded by a 1 ms timeout measured with the architected
> counter, and sleeps in WFE when the SMMU supports SEV.
> 
> Split queue_space() out of queue_has_space(), as the emulation will
> check the space in the host's queue.
> 
> Signed-off-by: Mostafa Saleh <smostafa@google.com>

Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
