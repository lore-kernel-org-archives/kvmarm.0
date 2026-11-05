Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.46.24
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793922874;
	b=OLmkN5gTa6+fH4AwuLcfX0P8WDwIAlOorEqompNaWuOzRa7FPln5zo1/oTnSnO8N3lp1
	 6k2vY+/PEiuoDEeo1NLTfXFyT6q71qLR0K+nNt6w+C1JKfiJ/MrpvWXH6Qt+YHY9OUCMj
	 hmDCFHoBG0/p8b+uXJT2pwW4V35szpH5m29x3MaKR/OsLdE9iCR32PM6fpzwMcPGiUvt4
	 bilC3mxIBAM0gmD0zBjvfiukVT8MgZG8vLGumalE7FiDvapZgordmVB1gBbxB4Uje9Wyy
	 Fc9PcGiPM1h8F+5JbWuIzTbQqqXTKjN8jbNVE2f4dWV4+wzZmulYrrHuDRkUvPr/w/A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793922874;
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
	bh=sDFnvWXoTLa7Xv+J+Wo7o9EMgLKRLzK4PjIEz6OwDp8=;
	b=ekZ04Pml3pnhTr0hbtJtmyYvsCAf4x+qJtLcFf2KgkmIo1lRH1SVCEBQI9lAXsG9JjU/
	 HUPv3OH3Mc5FDkkc/cGhuGqOwlBG21LIigTkOLQaHvtk2M8g6i+toYxZSyLaGo50ZLBS+
	 tSQgnl6BlyuoFm575WB3cPG40lHDpQN8SXA2G+4gtydurYgo8P7t8wLqBnm8jJnLlTMYb
	 g3mA5EpcTB8uWCL4Ctqe6+qF8dh8ApHMSKFuWlc16FRN1BFKnxRh2qch9eQqOKPGO3ey4
	 oZ+IJzHerNG3C6pzC96mkh+n/P6QMgwafqCo7/fIssvx6OYVN7KdUpVuRVBOGk4cvHQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=bTzsEVYT;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.46.24
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010024.outbound.protection.outlook.com [52.101.46.24])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E39DF606A326;
	Thu,  5 Nov 2026 23:54:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E39DF606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=bTzsEVYT
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=waHuH6kgLty3XWnG04fw7gX++nc+mGsj4xRHADE+ex01Y1TE9cS2SOH18S/h09y8eZ2Ly/gnFZvuIBwV+Tc27WUWFqtq6YnaqV4fLWhABghCS92M0NZqeuUeZy2LhTxpjV1Aia0Mv73n7bbIoEzr0+QpVGBb3tGkDqH/QdojT9gcecGEkfHLCXzVXkujGRJ53BzciWfjSKP93TUj+phrss0LvaJ7f7WdU4IuY1k0irtiMytOCdwbjo6NhxI72Zy6bb6MIvmi1l++omMLhDpD34FPxdwxq9V4T8xWW2VhUuMJKTzYcdUSn7Sr0foivqAC58ZnCLL58wEod3dx6wgadg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sDFnvWXoTLa7Xv+J+Wo7o9EMgLKRLzK4PjIEz6OwDp8=;
 b=MQo2X9MKk1i0j84T4aLKo6+oaaIB5l8QOwAXlPFoqImgBUJcsBTsWBI6YyYAX+cCupq22ivmrHa9sWjNWX+g9O5e1fGJCJ1EndqdUdMnHbk/XszhzXXrnzJ7rg9VXNOCQQyNip/7iXjOsDAuRcQSuUtgpyaUCsWv0zd0RR2I6mc5xbuWkAfwHN60gHcM57yxHRhmo7q2BmEg/jqlHTW20CmwMnb0eK3n/ESGWPUGd3Fpgk8cX9d+uwR3FAd0NmKwtLQGZd967HOkMu4+sirIPmji+lbnRtWAQbazhnQsAROba5YFB4xdC7dIJoLV8JQ1FQkf+oj0sc5MKATm51pBZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=google.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sDFnvWXoTLa7Xv+J+Wo7o9EMgLKRLzK4PjIEz6OwDp8=;
 b=bTzsEVYTrXuzFDa248wCQBq5NC54mZ9wyl2QiXLPtukj0cLfHfIEkMNqHUp+rE9gCjbZirOUXCdZZ3mhzJUqx0RdYElQoYPAuamMM/GEMUFhMdNnRE823ivC7Trn7SxVzenWoFm/kmtz6yPDsdtVn3yrE5oudh6yV6fCz5vB2Qeos9EACYnP27JlU8g27GyxGkdw+4prNCc9BmSPB7koJKBct0fs6bTeKPAr/U9AWibWpWcyKH7cDU1O3ILuLp8IIqC3g08xKMB6nkM+tnaES6p6XjRKopFqtxs9M+FnGR7icDcuUWi7aDUhGZpUH82wfjJYyLduRJBOj/1xdVr6TA==
Received: from CH0PR03CA0422.namprd03.prod.outlook.com (2603:10b6:610:10e::19)
 by SACPR12MB275847.namprd12.prod.outlook.com (2603:10b6:806:549::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.10; Thu, 5 Nov
 2026 23:54:30 +0000
Received: from CH1PEPF0000A34C.namprd04.prod.outlook.com
 (2603:10b6:610:10e:cafe::ad) by CH0PR03CA0422.outlook.office365.com
 (2603:10b6:610:10e::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.10 via Frontend Transport; Thu, 5
 Nov 2026 23:54:29 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.233) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 CH1PEPF0000A34C.mail.protection.outlook.com (10.167.244.6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Thu, 5 Nov 2026 23:54:29 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Thu, 5 Nov
 2026 15:54:18 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Thu, 5 Nov 2026 15:54:18 -0800
Received: from nvidia.com (10.127.8.13) by mail.nvidia.com (10.126.190.180)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56 via Frontend
 Transport; Thu, 5 Nov 2026 15:54:14 -0800
Date: Thu, 5 Nov 2026 15:54:12 -0800
From: Nicolin Chen <nicolinc@nvidia.com>
To: Mostafa Saleh <smostafa@google.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<kvmarm@lists.linux.dev>, <iommu@lists.linux.dev>, <catalin.marinas@arm.com>,
	<will@kernel.org>, <maz@kernel.org>, <oliver.upton@linux.dev>,
	<joey.gouly@arm.com>, <suzuki.poulose@arm.com>, <yuzenghui@huawei.com>,
	<joro@8bytes.org>, <jgg@ziepe.ca>, <mark.rutland@arm.com>,
	<qperret@google.com>, <tabba@google.com>, <vdonnefort@google.com>
Subject: Re: [PATCH v9 14/25] iommu/arm-smmu-v3-kvm: Shadow the command queue
Message-ID: <au0XJPD81XkBgpyF@nvidia.com>
References: <20261015200903.2735565-1-smostafa@google.com>
 <20261015200903.2735565-15-smostafa@google.com>
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
In-Reply-To: <20261015200903.2735565-15-smostafa@google.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PEPF0000A34C:EE_|SACPR12MB275847:EE_
X-MS-Office365-Filtering-Correlation-Id: 1388204c-89a7-4123-8bb0-08df3b9821dd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|23010399003|376014|1800799024|82310400026|36860700016|11063799006|4143699003|56012099006|261102123227099003|261021121427099003|261026121527099003|261021135927099003|18002099003|22082099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	bXaOEGvFBm5oaRz85gfsYGQshxqbmqDfSobRKK+G4/UQfuonc+IqllFgJBisOLj3W3z0f3GKD1oZXvo2E7iDcAXMFUrvhg20SznvzVMSVB2uYj/F37F5zIQr7vX5wKHJgVfVQDewQl1lLXeV8+oQ/egi7zIJM1hFX1t/GcyFLQutMu0p8250U5vzRHBLdP6S2zIxsBwQC3+sJk5J6ZHtqh6z1fma0qDgAaagn9ww56yrrZPuCyXWjSB4ea8eXlDwSn/pj+OmAzPyoAmoCOZN4mGsj4wLJirLJ5enom/rZryZxu3/xUihrXCrH+0CR/4RSILo1lQM3tREl3ysFrwPiqX1DAvWrrkOfMSf9Vagr+EHAu3om6iaPgkpbyIH8DyjOkTrx9pKsu9KyXxO7oV+6CVnL/B4qsj6Z3UgJ/koCAzZIasV0WMlW4ujEEqPs2poCtuKxJcSD3kaKSDMaaiBFigPksXyaFlYEKtP6mMO49O/WIDgb9M6B9a2SPe0/uE8xOpkYaK4gGDi1/kDIn/lXuspXbhgsKqB34FI6JMV0Oa4GEMjeR9ZyFgUaIPKhUGo/fVYueYyTb6lHE/0EWx4JdIySLt7CT0wXJuFZ5nogqlN2v+u71WYzgUnxiJ69sj2r3yyAqwrTlTyT61DNGqeC7UPEEtkrRY+FEL4lZyZExhg6CaXDVetwC7q9k4oWWvxLpKdzfuYBpC3hN0o+hd8yw==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(23010399003)(376014)(1800799024)(82310400026)(36860700016)(11063799006)(4143699003)(56012099006)(261102123227099003)(261021121427099003)(261026121527099003)(261021135927099003)(18002099003)(22082099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Nusorx8oNSwZhRq6x7omkLmH4DDLHNbC5xlMRh+hE/Q2VTz7YOdtPjmq8nQ/K16DWJFLIMzb+BUT+grXZm21yJ89wAZB3PpXwVMbYpeeFtOFe7dF+WEVJbnbTqzQeA1tmM6emIdN/aurInwa6LwIlQlwIUOFHF7OhBFsM565VHqoFntPKvLvByCZ8dZJ+SSFaOnc3557BD/itZ7oTBWF5jxzjsEhq3N4NXGUYaos0jM+M4rVaECd5bZ0AI22VSI+BLjMqzaswAngkYX0MhxEwByoIEaCVwS//PJxtC5U1Z/3J68kUHVUcX3Ha12MSYiAzJkMlxoj9Cb2uocBqEzLIQtoJve4NZQOD426G3Ck5yvh38bWtPdjb/egPoF8T+MJxQzBO1rklaY05WXGE1buMWaR0LvVCGVK4YNR7b7h0Y9E60GdICA1qYZ4d7UGbadx
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2026 23:54:29.7926
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1388204c-89a7-4123-8bb0-08df3b9821dd
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000A34C.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SACPR12MB275847

On Thu, Oct 15, 2026 at 08:08:45PM +0000, Mostafa Saleh wrote:
> At boot, allocate a command queue per SMMU which is used as a shadow
> by the hypervisor.
> 
> The command queue size is 64K which is more than enough, as the
> hypervisor would consume all the entries per a command queue prod
> write, which means it can handle up to 4096 at a time.
> 
> Then, the host command queue needs to be pinned in a shared state, so
> it can't be donated to VMs, and avoid tricking the hypervisor into
> accessing them. This is done each time the command queue is enabled,
> and undone each time the command queue is disabled.
> The hypervisor won't access the host command queue when it is disabled
> from the host.
> 
> Signed-off-by: Mostafa Saleh <smostafa@google.com>

Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>

With some nits:

> @@ -23,6 +25,15 @@ static size_t kvm_arm_smmu_cur;
>  static void __init kvm_arm_smmu_array_free(void)
>  {
>  	int order;
> +	int i;
> +
> +	for (i = 0 ; i < kvm_arm_smmu_cur ; ++i) {

s/ ;/;/g

> @@ -158,6 +268,14 @@ static bool smmu_dabt_device(struct hyp_arm_smmu_v3_device *smmu,
>  		break;
>  	/* Passthrough the register access for bisectability, handled later */
>  	case ARM_SMMU_CMDQ_BASE:
> +		if (is_write) {
> +			/* Not allowed by the architecture */
> +			if (is_cmdq_enabled(smmu))
> +				break;

Sashiko reported the same WARN_ON issue. You might want to confirm.

> @@ -170,9 +288,16 @@ static bool smmu_dabt_device(struct hyp_arm_smmu_v3_device *smmu,
>  			break;
>  
>  		if (is_write) {
> +			bool last_cmdq_en = is_cmdq_enabled(smmu);

Maybe cmdq_was_enabled (local) and cmdq_is_enabled (helper)

Nicolin
