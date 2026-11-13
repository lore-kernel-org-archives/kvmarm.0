Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.220.87
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794601009;
	b=zJxdjVVi78J5DPn1ZHlQqplJMFqH28fbjf2j+j6nCkUn6vLBhns1TxITassSt80qowZW
	 oMt3drOlCoXgiSGV504kHfrfPWVKLiD38mld6BnSs5ZD3aUcrJeUXowemn/8faOFFk5y0
	 DkqtEPhKEQc1T/wxmc2KWtj4SD2ePNGNG3XJ4mjcDwwlTs56Zz98j0ZAp/IEgJgbtWukn
	 riHiMOzhtjSC6VmogZKiYdTzaP/GwXyL3lUqYV7W/3Si2WH3fBGW/E/cwEsh3hyj1zS9L
	 fF5POgwvimAN49QLLL1FjZ4K85OMcaorPCMjXtMemMGtXK8puq48M6/s2Hpuue4fVgg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794601009;
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
	bh=NpuHoShtujplrKZa6Gz+oKM/P706pHWd54zkRe1aGf0=;
	b=l29NJLC2cO7URBdLBLmhIxVU4d9j6mRhIa9uXgok2yZqo3hE8R0O+o98oLXnFpQ54Gld
	 8bmsMxOOzQzl0aPtLhpa1LhVgisIIY7WimnSaW1lyC1gOYIt26Xkp28yi2v8mVrxX7FPc
	 cpkJyKfqb8t9gUeHb3WKEYpppD3nwBQFFEp67oFDbUi9GzXDpm0S5zFnB37cT2Phww3Ah
	 dqsZPkS3N7JoIRDNiDELFdgf2SvMNqS2zqix9LRY9+/bItYVakE0VnoLb9VbQJZa9G2f5
	 L43pLFoRd4Yad3TAQanebXOGuNGH/O3M5mzoZQihYAuLp0wfXdVLolayS+g1z/DrwDw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=b+7gCQgQ;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.220.87
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2087.outbound.protection.outlook.com [40.107.220.87])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0C9B606A33E;
	Fri, 13 Nov 2026 20:16:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D0C9B606A33E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=b+7gCQgQ
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WOsvreCsav6KAe3anAXwlh1yjTEjRTxrtMbxx//R6w93Z4Yq0bfoVN1eGDstyug+YW4SGunb4PM0bhIBHo3F76Q6bFXEmNNRZ7+vURDJbv2ds96cnrmREolJfQAsXdfqKVuER/9LDjU3vDFqlhppz+Ok259Mcuq31oCL4vtSeB7vPWlo9PWXRqnrbn9EmOZyMI+UKihdFypgkc6q+c0DpUw3iHW7Tgddz1FfC7SXvPKF4yxlXUEjIYYWyytPu0WeU6LD0BJeLUC0OYA+WRGvqWfKcvaJ5+hY15vOyTP8Jf+U0MOs/dRPHuZnE7UDxdjMsRRP4egCVZp71dzWeZpDNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NpuHoShtujplrKZa6Gz+oKM/P706pHWd54zkRe1aGf0=;
 b=lZH1/4+zWHginiM/c9IeWpPQub5ARkhH2/+ML040kksWvnNfoq7WLDMEERyg24NqlcsQaEUxcP2zz6KTe6vP8J2TLlo0Owz64jFCzK2UCp8kCwRcC1I45NRvoLJhrcJaWd+JU6QsZWYbtzWLzuRnxsPZgvbs18ydGXyQSGGqFQs/j4MN/LWwGed9IbTasPfMT5vgk2a+lCFv4RdA3jdjGRuqxCUCxOAMmA9YmSo17jKMzxApZPQW84ZCIKs5zgs2D1Du2jvSqKcJW4rJMa9KoEOgqMNWKg3qTQrVKdgcStE1TUzpbTAFzRnDFyqJlWmx3UisYBLYRXhOpyDl74cutA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=google.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NpuHoShtujplrKZa6Gz+oKM/P706pHWd54zkRe1aGf0=;
 b=b+7gCQgQ4TCMqgv7M7EdcPG7PG8+bXeL9dzjfaBVIKHnUI5d6MAoqf9fjjxvYVr6zYE/eIysnGH8jU9JB4nggNnoqF+5PiITCv6TpQDrV7P1YLXqRMbeLCbCp3l6yVeisPM/WRCEcmcCFPIzB9jF4IeM0xiWgItuNyNoODiBtYbEvrZMbL8SGgRacCLu1eM6WDjOVsgVQFuEKkiF/3wrqbcU1/u4JNoE9z6FmT/zoDQG6PewAR79wiK5nDYdldwl3BHLoMrQyEIG+OKKuGoMLA8HTiPUeNr1yf2RcgTps0he5X/uEdjbu+jk53404IQzQOptXZxVuV5PwMTTcUUtug==
Received: from SJ0PR03CA0061.namprd03.prod.outlook.com (2603:10b6:a03:331::6)
 by IA4PR12MB9787.namprd12.prod.outlook.com (2603:10b6:208:54d::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.9; Fri, 13 Nov
 2026 19:35:35 +0000
Received: from CO1PEPF00018867.namprd03.prod.outlook.com
 (2603:10b6:a03:331:cafe::8a) by SJ0PR03CA0061.outlook.office365.com
 (2603:10b6:a03:331::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.522.18 via Frontend Transport; Fri,
 13 Nov 2026 19:35:35 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1PEPF00018867.mail.protection.outlook.com (10.167.249.151) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Fri, 13 Nov 2026 19:35:34 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Thu, 12 Nov
 2026 21:44:23 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Thu, 12 Nov
 2026 21:44:23 -0800
Received: from nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56 via Frontend
 Transport; Thu, 12 Nov 2026 21:44:21 -0800
Date: Thu, 12 Nov 2026 21:44:20 -0800
From: Nicolin Chen <nicolinc@nvidia.com>
To: Mostafa Saleh <smostafa@google.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<kvmarm@lists.linux.dev>, <iommu@lists.linux.dev>, <catalin.marinas@arm.com>,
	<will@kernel.org>, <maz@kernel.org>, <oliver.upton@linux.dev>,
	<joey.gouly@arm.com>, <suzuki.poulose@arm.com>, <yuzenghui@huawei.com>,
	<joro@8bytes.org>, <jgg@ziepe.ca>, <mark.rutland@arm.com>,
	<qperret@google.com>, <tabba@google.com>, <vdonnefort@google.com>
Subject: Re: [PATCH v9 11/25] iommu/arm-smmu-v3-kvm: Add the kernel driver
Message-ID: <avajtITOOJiT1AnX@nvidia.com>
References: <20261015200903.2735565-1-smostafa@google.com>
 <20261015200903.2735565-12-smostafa@google.com>
 <auzvygiGRTWgJXzF@nvidia.com>
 <avGk0ilyJh3obmKx@google.com>
 <avJidXM9yQOX4VBJ@nvidia.com>
 <avL016l_xASN5paR@google.com>
 <avNhekBYqiiZ9IM2@nvidia.com>
 <avW_9A48mtnK383x@google.com>
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
In-Reply-To: <avW_9A48mtnK383x@google.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF00018867:EE_|IA4PR12MB9787:EE_
X-MS-Office365-Filtering-Correlation-Id: d9c3544a-408d-4a3e-95c8-08df41bd499f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|376014|23010399003|1800799024|36860700016|18002099003|22082099003|4143699003|11063799006|261026140227099003|56012099006|261028144727099003|261022105027099003|10067099003|261009223027099003|261021135927099003|261022075727099003|261026121527099003;
X-Microsoft-Antispam-Message-Info:
	ArkP8BgKbAfRAy3AIGiK0vtS4Al2sFq9PNxQfpOtbxqynMiYESz1zWqvgA9JMo2ZtxbNlotchlq02vtTqqzJ0vQk09C6JiohqkQAacEoPJYLLcYxJQ78B7Z5u6x7ZkI7uG7yHwhCCLIoPiMPK4xmPGtNhPmuZdm9xk1bBJqy5TZ04nBoVzJxM9Hz7kGWfIzwb4MNiHk1NeNrtGRiSmx1mpkmUzBFnHlsjqVBKUtAa5YulZgwqf/vardyWhulvMNNE5RM3R1Rig6ZA3X14pLnLiDMfh6kRQcHbhhmRaiC6IeZ78Kpg9yL1WK0+2SyeIAQXzrWkawKBjjaw6CYloLLrJZmY7aa9EBx/6FHP1cHPgRj2TQd2wGKGUXi1JDfnvOaI5AM++n/DLJmukbAPxcFeYTmBNnIDR4l+n82I6A4s/G26jEjw26wy1GgJUtRUgYQ/pU5nPmAy2kx3PLBd8uvDX7RrLII8te7bR5PUyFxpiO8RsphpC33YD/npUdLFDZ6dll/xLn7SDKXs5VVjyo5sb5l6QWJJ0+HIO+TAiWDZi3YCeU7kpfRsuVwM75L5wsEDi7Xrmm8L1YpjmKS86kyNIGPTrDgnxT2LfKNDk19v9feGyKxLnGDlkaCJgcJmgE8Gt4mSCr1rL4ZabOwXg8G6cC0/opgcW6Dn43E7Uyzps/kJ615EeeQCd37zWSL2Sjfrri6kR9V2S6Ejw0rI7WQbw==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(376014)(23010399003)(1800799024)(36860700016)(18002099003)(22082099003)(4143699003)(11063799006)(261026140227099003)(56012099006)(261028144727099003)(261022105027099003)(10067099003)(261009223027099003)(261021135927099003)(261022075727099003)(261026121527099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	osLOfVODl1ubX94GzuJkmgwVaG/39o/acf1xjfFqQ5+d5SDblt4W3T1MnebsF3uO2nq6f1UuCChs2XzkCFPG/XhlsOYhHvWTPYQ7ZgGkz4EVzkVl9+xXxlc1EgY+tp26xAZ4phy3wjtiiiNXSVLfLn0GYagAfDrIvVQoHtttEpxt1phjTKeq77GqXTId6QN9beLkLPz50wDa+fxf1L6IW983QRXB8h2Fit1bOvgHDtV8wO5zWrxFAmhn8yP1EDwLTw2ARErgeYnzRN7aE3HZsRJr4miL1nlbdDy7RCVmpB7UXBr10as66iDwYGAY830ucEbBD9E8LPQAf9mje9OuJSGGD3O+COVTuHrfpZN0l0anJ1Mn+2/pCqZSkUSi8YtSD0ZeW/EDgt/dll7YYke2WVvRmZzhLRadHwO4bn9MIKihvRmI80wsQH1Ht6d7Lbht
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2026 19:35:34.8679
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d9c3544a-408d-4a3e-95c8-08df41bd499f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF00018867.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR12MB9787

On Thu, Nov 12, 2026 at 01:32:36PM +0000, Mostafa Saleh wrote:
> On Tue, Nov 10, 2026 at 10:24:58AM -0800, Nicolin Chen wrote:
> > You might want to double check a dual-SMMU case, where one gets
> > accepted by pkvm driver and the other fails and so bound to the
> > main driver.
> > 
> > It seems the pkvm driver would still pkvm_iommu_register_driver
> > and carry on with an untrusted SMMU. Would it also clear the FW
> > and mark the system as not trusted?
> > 
> 
> That shouldn't be possible, if one SMMU fail the whole thing will
> and the driver should clean up after as the probe is done through:
> 	ret = platform_driver_probe(&smmuv3_nesting_driver, smmuv3_nesting_probe);

If I read __platform_driver_probe correctly:
 * __driver_attach() doesn't propagate ret from driver_probe_device()
   via bus_for_each_dev to the caller
 * bus_for_each_dev(..., is_bound_to_driver) at the end also returns
   true, as one SMMU is bound to the driver while the other failed.
?

Nicolin
