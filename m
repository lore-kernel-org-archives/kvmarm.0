Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.198.6
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793994351;
	b=2I/mOsdRBi5dJR3SBIBU7Sne11k0PVVx5CtuzW970SK1aY6bEqlMxlGjoo5na2/rI7kp
	 Zw+4CdBO7idyuAxoGqMWwAB0IJUW9HxdqX61bsb4ZK8AlZH7Pfq90naYRqX34+QTaodM1
	 kojppcp6B1fy+ua3ZNigid1ly4OGMNjS5lz0VNG/YVg7ERaJmIrWiPQKZdrMksAYj6BZ0
	 WZrD6YoHhSxE52OEse9R/10kZ12U1x6nworTKHRvRZRC1QRYq+p9bGNHD/DLpNntRTLa0
	 +GoSwzHdDRaLU7l6bayZMKE3LUssZc+WjvbNUpaiZU0HOQ37ze4sFc1qvgLwx0zj2gw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793994351;
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
	bh=0d+0nbN7CSiyO7Qa/vyvuNKO9Cq3K2ZGFErHSZUY/iI=;
	b=aJE2maOeXsq/wL7x2yuLrn9i/8ZNGaw0ivA6JVbuUNu5i98AQj9CvyRJrNIx18ayM+ee
	 tJj6UubINSQO8mQ1CYmDRZyA8CyYZCiRxP2re0D0sCCRsbQVEhRXdVXMq8HMiEGG/slz1
	 bnKd0V248ryXH7CpDKdSZGXzZQlEj+Q821tpmRCL6E/dxPfQ5JLeAL3fcGZA68cZynLlu
	 YNjnryx369hyALUH8KvkuId2wCGYZMx7F+1gFozkPKfIo1L3RepWWF65vHbUTD7tvkltZ
	 B6FUj7xx0Ff/HebBUxtY/kVPQoZNJKf1hjh4tlCZ1f/3Vv+JyJRfQfRZ2ZbZCQjcfPg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=DpgSesyK;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.198.6
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010006.outbound.protection.outlook.com [40.93.198.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E878606A329;
	Fri,  6 Nov 2026 19:45:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8E878606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=DpgSesyK
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=auIsjh8I0mS/AQ4dsIi+og3vn0nIdUO2j3j6yQkbhQXkc9AqS2WtuSY0/Xly5uCPUNuNw+DJRUtWvJKWLA5Ea5cnIdo5gB9WYu8ID3wwdLLk/+SkBh+ULS3POH1hook2PGtQYWZw62gWP0xI0fbmZCGR74jzGBn5eofzCct0MuE6SZndVCDW9R66FdqUOQTa6/tMc9q+QAZiA0seAmYZmTz+ZEPHIQSD1547pBOlkKhwuIQ3747tKgFIAvxYFcIwxe7YxZBZLbQhoqNk8Ct3ey17L/gP6QZ9pw3TzRSn3MWyHP/sHexT8fK0HTxqz3fND0q4Ug8kILDsqfZWEh4G8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0d+0nbN7CSiyO7Qa/vyvuNKO9Cq3K2ZGFErHSZUY/iI=;
 b=GUK7vJFGty6yWksUvKJTjQTOwCjZEjKHy+a2AfaNlhRhUXpG73E+D/Hd6yJCPkfDy0SIPm9QuxGtlf1S9pk03yfbj6E2at6euq2rUgRBR5kGLqMcssFFGztltgGCox9KNb07kWrKdNQA6zlXwLrkcByTd6knBGYE6McEONgFtd8nlMkSEQL1esmRuX/Wjp0J6K4npcrvpYJOMn6ZP1TRDAPgXRBwu39Nam571vV7N9Mqzhpn6K1yC6GfT437wL/ps6313w6uNEdQ9af1IOhOTVl2FLdyPDJJKLnYxDXCEnHlH28wZ5UQ+1fGKsZc27ByHctZWbE5dPLOUTxerOLsxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=google.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0d+0nbN7CSiyO7Qa/vyvuNKO9Cq3K2ZGFErHSZUY/iI=;
 b=DpgSesyKDzpjmyOz1oKAuNpFAiSOrwIu7LSryBqqQvCi5U5aFKvY+A6qj+B2Pu/zGOtkcTUrESuNzv1isTW4wEg84zWUCyt1LOkXOsd0QzbCCIWPoGcFW92I6VO9em8CmZkfjNkbvYksOFtJEkDUxIV9RyY7NRJg/d8qc97MDZQf5kdGTl//ciFZp75KnBGACyf7x4Os1KLpJyXUJSK5lMhNUam7xuiT48IGKOifKt0y8lRrDM9nGg37E7XY/SkxmKpDEBZqRMr3A0OSc9BKmBidu5MFSbSYLtH/xMXfJbNUoSEqTHfuVE8DsZXQDTdawCOCDc6oxAQBE3iKOGsGPg==
Received: from BN0PR07CA0007.namprd07.prod.outlook.com (2603:10b6:408:141::24)
 by BN5PR12MB9461.namprd12.prod.outlook.com (2603:10b6:408:2a8::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.11; Fri, 6 Nov
 2026 19:45:46 +0000
Received: from BN3PEPF00022BC2.namprd05.prod.outlook.com
 (2603:10b6:408:141:cafe::36) by BN0PR07CA0007.outlook.office365.com
 (2603:10b6:408:141::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.11 via Frontend Transport; Fri, 6
 Nov 2026 19:45:46 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.232) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BN3PEPF00022BC2.mail.protection.outlook.com (10.167.248.213) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Fri, 6 Nov 2026 19:45:46 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Fri, 6 Nov
 2026 11:45:26 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Fri, 6 Nov 2026 11:45:25 -0800
Received: from nvidia.com (10.127.8.13) by mail.nvidia.com (10.126.190.181)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56 via Frontend
 Transport; Fri, 6 Nov 2026 11:45:22 -0800
Date: Fri, 6 Nov 2026 11:45:19 -0800
From: Nicolin Chen <nicolinc@nvidia.com>
To: Mostafa Saleh <smostafa@google.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<kvmarm@lists.linux.dev>, <iommu@lists.linux.dev>, <catalin.marinas@arm.com>,
	<will@kernel.org>, <maz@kernel.org>, <oliver.upton@linux.dev>,
	<joey.gouly@arm.com>, <suzuki.poulose@arm.com>, <yuzenghui@huawei.com>,
	<joro@8bytes.org>, <jgg@ziepe.ca>, <mark.rutland@arm.com>,
	<qperret@google.com>, <tabba@google.com>, <vdonnefort@google.com>
Subject: Re: [PATCH v9 17/25] iommu/arm-smmu-v3-kvm: Shadow stream table
Message-ID: <au4uTxliZFv12Bqn@nvidia.com>
References: <20261015200903.2735565-1-smostafa@google.com>
 <20261015200903.2735565-18-smostafa@google.com>
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
In-Reply-To: <20261015200903.2735565-18-smostafa@google.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF00022BC2:EE_|BN5PR12MB9461:EE_
X-MS-Office365-Filtering-Correlation-Id: 089db5eb-21d5-4e5c-1ec4-08df3c3e8d36
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|1800799024|82310400026|36860700016|11063799006|4143699003|56012099006|261021135927099003|261009223027099003|261026121527099003|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	GgFWkDZ9eiCTOvAfdDW8CEWmXIPm52inRCj8gcgtMroSjQv72Q5j1SXHafEu06ovKUl7KeiPWktEJGZr4Z09kPHz49Hc30mO2LvU8qp+XEzn0nMWm0v0jTE+ttVsrYIvXrQYickky3M63uTPQlfEakaaZxQUwpgqut/uS10NBkUpFcn7NhDBAgo5x79Rj/9sK8DToD3PMuOdI9sPlx9Hm9cJ2BcH4jb6ZSwj9hbuXebJKF85OHl+GS4brC3NhuzvqjLgjQ/DxUkz+UuLUj3ejw+npX5+JwIhCOxHX53o3EPYUGYPo94ZpHZgWSh53UjG2NKSp50/FvXAmh3MU5xNrVd4TBsnigaBnqJsUv94RrQPEPRjho9zXnK5YR0hRTYir38OgL0M9gz1qP1ywGNIODN2yR1zQ3a/X4pjPBWHreoqTMnfazn1WJMzCvgPlGXwBueCBzTH5Se+MK49/0HT9ToefSZsYJuLyIF7b2w8rnhcijguiiGugRIU2q98AUQkNHje/aL7pRAYz9Koi/z9ekcpT5XM/y/pBI45n6zMxVac7LoUcDoXCf11nET/91pRsIjc3/W/1FPBwPbXZ+IE/rgawdHbmufVg3Ahlo4419iphh44w4tcSk2souWUfw6mWxHt1y8PGCarCVO+EtqfX+12dFttVi0wJLH38MK+SlLHV4WJdhKrQ0EwOcmwnQg2KRXEr1YPGVg6FJXUjT8+qQ==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(1800799024)(82310400026)(36860700016)(11063799006)(4143699003)(56012099006)(261021135927099003)(261009223027099003)(261026121527099003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	WspYspq/lkfNwDQ0BCr6C/KXhr7yVMyBklVoUb8kMSKIWM+MM9AGJh4go+9GZD0l2tfOyHnHTE4y0rhyn+VePd16Tmme83YqJ50kDYpM0RrFzFv+JNm8gjr5Aaq8n8MzCkEklZ1bG49jH7wOsTm4Yyp3y36NyIzgjUW/kCMcsH3pw6jGiGal/FFn/+wFOQoTZ7x8UI9TfgWKheNbYZmfQCwm/FF2LrEsl+z/1LZGpCdauWCdWup+WXRf4M7XJV0ugsfP4rGz5mhjUoJ0m5ZZALnwf+l8bWyrslfIlhT3EU8h/X+c2kQ+hQX8uSTuFC8RJUcX0OZyYhokgmlrDbplHATS5m9fFod5WXfX+tEGcOKQfc8rwwIXm3AG3Z5on/kbML65Q9NI4tmTElPj+WqaQnA6rX09fwdZKBttD4GYUWEpkXV6rpwLz50Te9D0rW3I
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2026 19:45:46.2772
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 089db5eb-21d5-4e5c-1ec4-08df3c3e8d36
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF00022BC2.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN5PR12MB9461

On Thu, Oct 15, 2026 at 08:08:48PM +0000, Mostafa Saleh wrote:
> @@ -538,6 +655,7 @@ static bool smmu_dabt_device(struct hyp_arm_smmu_v3_device *smmu,
>  
>  		if (is_write) {
>  			bool last_cmdq_en = is_cmdq_enabled(smmu);
> +			bool last_smmu_en = is_smmu_enabled(smmu);

It'd read better with smmu_was_enabled and smmu_is_enabled.

> diff --git a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.h b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.h
> index 3903ae358555..31ab7a0335a8 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.h
> +++ b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.h
> @@ -27,6 +27,12 @@
>   * @cmdq_host:		Host view of the CMDQ, only q_base, base_dma and llq used
>   * @cmdq_max_shift:	Max shift for the CMDQ probed from HW
>   * @cr0:		Last value of CR0
> + * @host_ste_cfg:	Host stream table config
> + * @host_ste_base:	Host stream table base
> + * @strtab_cfg:		Stream table config as seen by HW
> + * @strtab_dma:		Physical address of the shadow stream table
> + * @strtab_size:	Size of the shadow stream table
> + *
>   * @mmio_addr, @mmio_size and ARM_SMMU_FEAT_COHERENCY are filled by the host
>   * before de-privilege, the rest by the hypervisor driver.
>   */
> @@ -50,6 +56,11 @@ struct hyp_arm_smmu_v3_device {
>  	struct arm_smmu_queue	cmdq_host;
>  	u32			cmdq_max_shift;
>  	u32			cr0;
> +	dma_addr_t		strtab_dma;
> +	size_t			strtab_size;
> +	u64			host_ste_cfg;
> +	u64			host_ste_base;
> +	struct arm_smmu_strtab_cfg strtab_cfg;

The order is different here than the kdocs.

Also, it might be cleaner to group host/shadow/hw stuff separately:

struct hyp_arm_smmu_v3_device {
	...
	struct hyp_arm_smmu_v3_device_host host;
	struct hyp_arm_smmu_v3_device_shadow shadow;
	struct hyp_arm_smmu_v3_device_hw hw;
	// Or
	struct {
		...
	} shadow;
	struct {
		...
	} host;
	struct {
		...
	} hw;
	...
};

Nicolin
