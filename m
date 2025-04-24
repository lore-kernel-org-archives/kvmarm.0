Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11020129.outbound.protection.outlook.com [52.101.51.129])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 956B61EA84
	for <kvmarm@lists.linux.dev>; Thu, 24 Apr 2025 22:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.51.129
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745533510; cv=fail; b=lAVgh6cR/D6Cz7lqtCGKA/rBzjyZ24HDz/ToAL4GYF0PPm2ZhAgg+EBJDS0TCLbIts2CLIfvDPXdkK0CDckI9pc5k5ivmv5k4LwpaACk5HIJeySIVtrRNxM0H/R9Hdo0XCpYIWfS1blAZkhLOsBGw/GCQLUeItnT7Bckf9gP/bo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745533510; c=relaxed/simple;
	bh=w9CB8nmIJb6Am+Lc7YvjkGrjYJvmIjT4XybQNIBOPzk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 Content-Type:MIME-Version; b=mr6X6CtDYIzy2mkHIDUGOt9EUabmEWKYxrdKvDiSKCe7WGnzi2T9XoC9Cp6vb0r08k8lDsug8ri6HhYAFWDaT8PAIekHsX6bwWU9dqCZwhAcHzseniV8/vYR35kS6GYL3t/Sq1g0VRfhTaVOYSNybdC+Kd1CCbPACtYDnn5d2xw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com; spf=pass smtp.mailfrom=os.amperecomputing.com; dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b=UF7CR5Qi; arc=fail smtp.client-ip=52.101.51.129
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b="UF7CR5Qi"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CLp/eD3ol/OZnnMY4+3Xpz1QLSSAoIvMxsCmvgYWbFsicij3ANiVaiRVUNEpcgIFkeP91qcks7rAQl2tRkOSW+ZxgGmtawbt8rqMWwGO4xsuLsRacRaQ8oUHbGAtkbi5LU9BSlsTK2ZA7IKWuvGR5yByXPY/XfXwNuLLdTCfOSlqxepSLAsg2di0dcH+5jOXYyAxWsW2WDOO+++lx18om9j5tV6oGKtho+YVUkenjbEIMoITzXhc4cidHSTLEXaZFtmUJWsynrsbJEN6DZRwm1G5IJqjwGB3nyoGBgxuhKR0MCJS7ewzR2OjMe9dNPWqnK98P7bgISxXa2oFjHZUjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+wSvMCUCxNhNC4gXsB5hDouWU948oYzzEBMH0SyGSuY=;
 b=WQW+ON2wBW4cKsPcVC7Ei/ok2AFhnjOKwjqtkNJu0VMDEe4xYT7hyhafD4If9r0z/vXxemYPkjI4HYcT607ZKYC7w9JcvLcCwD7f2FiSuZ+WfeKlpiVzh6YFoGsgp4CS0AJeMf4rb3yVDLPt4Jxbj7hyzHOS7XaogJ4g6lwi8S8v6r76S4FqMRSw2PCcitnoW36oaCYGjsu54NVxIioK7IwgJkTT7BuF0x7/hXJ5duco7SDjb/C/ufOju+mqZPQSNc0NkGjEhgBvdVaQFjpXxPt29fKry3NNlVf9LDJPCGOGphDwjRk4JzbidjCsRd+Ud6nrHAMOVw+ZfTAtPhl/nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+wSvMCUCxNhNC4gXsB5hDouWU948oYzzEBMH0SyGSuY=;
 b=UF7CR5QinNYrrWQ/DbasttoEkMEe+1KCirL20OD7PLdmARkxhQOQzL1hZDxcyFgR89Ik7Lie3XyHHxZStjyuztfl+/RyDLG7rbNRx04/tggGDo1X4TUg7Au+s+1mHGhWWRkdcjVQxuJSklM5Fo8spRXVmPQ3BLOORBqoUGNnzOE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from LV2PR01MB7792.prod.exchangelabs.com (2603:10b6:408:14f::10) by
 CO1PR01MB8987.prod.exchangelabs.com (2603:10b6:303:272::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8678.26; Thu, 24 Apr 2025 22:25:04 +0000
Received: from LV2PR01MB7792.prod.exchangelabs.com
 ([fe80::2349:ebe6:2948:adb9]) by LV2PR01MB7792.prod.exchangelabs.com
 ([fe80::2349:ebe6:2948:adb9%5]) with mapi id 15.20.8678.025; Thu, 24 Apr 2025
 22:25:03 +0000
From: D Scott Phillips <scott@os.amperecomputing.com>
To: Marc Zyngier <maz@kernel.org>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev
Cc: Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>, Zenghui
 Yu <yuzenghui@huawei.com>, Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH] KVM: arm64: Force HCR_EL2.xMO to 1 at all times in VHE
 mode
In-Reply-To: <20250422123901.2675976-1-maz@kernel.org>
References: <20250422123901.2675976-1-maz@kernel.org>
Date: Thu, 24 Apr 2025 15:24:59 -0700
Message-ID: <86jz799ozo.fsf@scott-ph-mail.amperecomputing.com>
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0046.namprd03.prod.outlook.com
 (2603:10b6:303:8e::21) To LV2PR01MB7792.prod.exchangelabs.com
 (2603:10b6:408:14f::10)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR01MB7792:EE_|CO1PR01MB8987:EE_
X-MS-Office365-Filtering-Correlation-Id: cbdf4c24-86f3-495b-4cfb-08dd837edbe1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|52116014|38350700014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?8ET/HW+VpiDTlvju5enuyLizIHh1lIgMReg7C0EFVng9Jzv4W0OtsuPjXyyo?=
 =?us-ascii?Q?ktUMmC1HNBB5teyJPlZHp4DKiV06GsLoSWdb9iExNCYYE0KyKZqOlO0lCBrW?=
 =?us-ascii?Q?Q+rbh54aq87fnAsDFAzLKVnARoaY05/MGRhcfbQRTajCqmibkJLONTlFftia?=
 =?us-ascii?Q?1tmKRk9bwQikvVkjIyOyftY/RCTnpvYNxItFT746SUYOFRaRLzroYb56BGBR?=
 =?us-ascii?Q?C8iSuhBVrQeg6533UA9+FylfFAi7aL4POqGoBdoS3dG1yiO5jFa+Pq55O+PA?=
 =?us-ascii?Q?hJwAzfjb7NmyVIAN2OcuoKis2qbFr/FyRV/pLSr74NNRZQRIpxcwxdL/CDUM?=
 =?us-ascii?Q?mgdgs7aov2GghIzaMZlJuKp3hWlEJ25ZtrUxMyuhv5iC12n922MEOyrMldWE?=
 =?us-ascii?Q?SbRJXCRuoeXo9u2HRlQ30VVdFehB0bK0C2z3JYY0+PJGMkRjn3IKf5qjiqit?=
 =?us-ascii?Q?Y1TRwTN15X9hWk3WruPoQWpv1ru5TcQKCr3HYLQ4uiVJPy9DgV1vPb85FjA8?=
 =?us-ascii?Q?lYFX0jMj9bXiThSCpN5oMHM1+92Py7rZJ6/I8RMapHE7rE7NhcAXmyU+Mfx5?=
 =?us-ascii?Q?SRXSLdHSgT8RZ5Tb1Mua0NBHlw1atSUCbejkB6ifrucwgaifODgMUbW3+vtK?=
 =?us-ascii?Q?/JLopaB5dWAz/bJy+i+cUzSiaRtR2/FGZSPzXqR/8jSatgiM5Nv36xHR74RK?=
 =?us-ascii?Q?vSQOzjhUo37uWaeHTMN/glOvHMk9mepvnOwtJYR18Qxg+0Ha8z5KLOuKNM72?=
 =?us-ascii?Q?zpeHBi4hEFoyKPqhIf3LN2Hl7DIOFxuWPCGjbRJHEmyV1jJjj2ClGi4WiF2a?=
 =?us-ascii?Q?GWzxDoxPq034wE/8Mlgvf5Uk+AosnnUA4FFr/ssEKto8HtpnKTuy3JRmwL4y?=
 =?us-ascii?Q?0oWVypk/CFmff6nmZeZ3lCRwA71M0fRbwWMoRsmxk4Zd65LCbANwVMjp73nE?=
 =?us-ascii?Q?rxO+sSIeeEXX2jEQJ5Vcz/744uE5rLBWU/vOBResPRWdSU7yzD+11sZyymut?=
 =?us-ascii?Q?6YrpvX0GK6FPFHP4b47a96ciw9nAuqQrmWgVYD461Btd+VSGyAP+e0fRTCqG?=
 =?us-ascii?Q?Euw5txlKH2F/Lm4OOAyQkDAnJYW51sImBL+RRYmci/jBEc6gN7P5yhfXjgPV?=
 =?us-ascii?Q?zBGx8+u/HRrN4Q0Pn7l5l3njOYJjXtDjMskkDvYJcrAAoUUP7PWWwAEX4yOr?=
 =?us-ascii?Q?YwEQ/7YAYdtPf/qdx432YWcksjitAqfiq3HCqFtrfAgjIgHbO3K+3sy+i244?=
 =?us-ascii?Q?CrdGrwwaec9tkhP/HdTF36kn+pehcE45eIbpRs2vO2o0UB+ZICNia80k7g+D?=
 =?us-ascii?Q?rpy9eS7Wtg+i9eczldk3ru7KsckNwwewQNx3GTUItkcZGV6JZ/u+KTJgCKSq?=
 =?us-ascii?Q?sRwkS/a+XJqz6ZTzdFav52F2p5nrSdckrZhBGufUfVs4yalrBwQBc2k8s0wq?=
 =?us-ascii?Q?M9QU/JzkUsNMYr24H1t37U4Y8A/BLpoGI3fLGfrnpjaaHPIXTdggVQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR01MB7792.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(52116014)(38350700014)(7053199007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?S+d8ktJDTR0aTgjxwWkUotW6z5cGUk/e8H8myOx0U5X26/xosqgWKJ0B4l8h?=
 =?us-ascii?Q?CXkmUONsH0SqmzQqtkIC8cpAW54wZaDdBr5ZVireRxtblT6M32RlRDclZ8J6?=
 =?us-ascii?Q?MHe5BtYAzrmTG37ey76KN4yJlQt3opoYwnk7p6fvrnGKzjdfm+IC0w5wRY9n?=
 =?us-ascii?Q?ledve59SM9jE+BKcYTmox/wIzT9qTadqT1FfAAe/4YTDhc2EJngP3Ook9xfy?=
 =?us-ascii?Q?SnBP7lStkghtNAi9AH617Tt1o3mASBn50qDrdydQEvIT8cNV13CgwcWablJk?=
 =?us-ascii?Q?fbUWs+hNLhIEN+zdG9hSl2uTP+apAbbX7W9Qe9nrHL0A/AQt1uLAef7wIa0W?=
 =?us-ascii?Q?uJOikPf3AKKkqe8u5uRVHKft2Gk08umYK3B1dTmnU9XQC1ZxwZwGXqJVeQZx?=
 =?us-ascii?Q?s2ts+tUD5ri109m6DVDPcmcW6gnCeWbsL8WgFnb/af0T9Ij1eAwTY287I6g3?=
 =?us-ascii?Q?RyRnLP+8N5RcA8o4UpmkOxsqBQjC+4vKofgVUDCkpMLkVb4bTkpJ8rzt8FgD?=
 =?us-ascii?Q?1xwUOl1xGQjVyu2sFxz/y+a6vKJRAQ/wP9ZKs7hKo1b5bpD5IPa8wTY+DjdB?=
 =?us-ascii?Q?Z3gnbZrH5OXAFiuR13mLHVK9eBgTiXUFMwQXQUHtNcq2lbTDNSoBMGDSqIdW?=
 =?us-ascii?Q?v4biG428n9TKoMKR+Ig/Oo7oE03GnD0j/kFiqbf6Tubwl3/bSxu6itIS2ol2?=
 =?us-ascii?Q?pSGjWwEl1gdtENUNm73kXZjy5uKZVx6qZcGyEKBTCtpw/l8OR3xRiCzValZ+?=
 =?us-ascii?Q?gjy9bior5CxZ+QBcuuzv0LEJ5Ie8b9AAC0DbhyA67l+WKSo7uxywOnZd60Mt?=
 =?us-ascii?Q?o81LLOEdCu//kSc2eW4Bfv/9SODTxkjwiZKGnsU9WPRLTKKUN/kayv7UVsd9?=
 =?us-ascii?Q?yJNQ6Z0j0U1IhkZtB8AUlFCaM0dhCuTy7P6FJ0sJS7PR29NZJ0Ls+reXCF04?=
 =?us-ascii?Q?mPQDOzur4N6qR4lVmDx5P9Beh1NaCSq7RPA4DKp2PQSKwUwN2mG33XGaGjk+?=
 =?us-ascii?Q?MvPVNjrJO+VVLTOBzC/+lTY6JCQNOy4j8rz2JeeVbAfy8/IXFi0p95jwCwLg?=
 =?us-ascii?Q?PLsMvwQwAG0jwb4fg4PRfdikoN5Nbh3U97fwNSi47izCIv9dj0FRRkv/Fvuw?=
 =?us-ascii?Q?miwBgp/dZsVzJjh//CB6bkb1IXS9lFeaUvzlEGSNgN0LUbv32by52rl2ciqV?=
 =?us-ascii?Q?jAB8hArBgkfA2veKiNm1d16WDm4RM9xsE48JqHgDc63uFlFiFjmpFgmL4Pmb?=
 =?us-ascii?Q?eimDfI8i0gxZ+gYsM3nQfgibnyszE/63KOhC/ali5mL+Jq6G8Bp/oPoOCJbU?=
 =?us-ascii?Q?+yks9XIT1dygrHFJe23it6sqnKdjEnRY9OHrUXm0omBeFwDzhnP0kvKcDVOV?=
 =?us-ascii?Q?TXxeTb4dAENvscQjjdF9bYHa20zmMFle5CHaAq7EuThqgu+G7fW5reVuzufD?=
 =?us-ascii?Q?nMQSfxVla+587UMjMkzMEBy3wJ2V3jitTiS8YNUqjQ321eJ6plGNjgCc7Qwt?=
 =?us-ascii?Q?V7MLg542piI+8f562095mNeY1NiF4VDj6l/ipeldbgTtWfnB0pjBRioSMGp0?=
 =?us-ascii?Q?popTPcZjcCV3V3obFLYxkYHxBu3TDwTHLGOFkhgbrk8ZRSkCGXQ1LiecReYA?=
 =?us-ascii?Q?TiM8sJFx0be8Hj6VeXt8Yrk=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cbdf4c24-86f3-495b-4cfb-08dd837edbe1
X-MS-Exchange-CrossTenant-AuthSource: LV2PR01MB7792.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2025 22:25:03.8089
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VQQh2+JW+F5hZ1vULRQYMWU18TIiFnrqp/EuiL9cQdhMUTt6DmKf4/4rtAgG7+OojnTcuo2DudJV/O45jyMXGbGDGHgr83AIR61neYjUaCPR4PfAv7X+L9P4O7YiwrM8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR01MB8987

Marc Zyngier <maz@kernel.org> writes:

> We keep setting and clearing these bits depending on the role of
> the host kernel, mimicking what we do for nVHE. But that's actually
> pretty pointless, as we always want physical interrupts to make it
> to the host, at EL2.
>
> This has also two problems:
>
> - it prevents IRQs from being taken when these bits are cleared
>   if the implementation has chosen to implement these bits as
>   masks when HCR_EL2.{TGE,xMO}=={0,0}
>
> - it triggers a bad erratum on the AmpereOne HW, which catches
>   fire on clearing these bits while an interrupt is being taken
>   (AC03_CPU_36).
>
> Let's kill these two birds with a single stone.
>
> Reported-by: D Scott Phillips <scott@os.amperecomputing.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_arm.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
> index 974d72b5905b8..bba4b0e930915 100644
> --- a/arch/arm64/include/asm/kvm_arm.h
> +++ b/arch/arm64/include/asm/kvm_arm.h
> @@ -100,7 +100,7 @@
>  			 HCR_FMO | HCR_IMO | HCR_PTW | HCR_TID3 | HCR_TID1)
>  #define HCR_HOST_NVHE_FLAGS (HCR_RW | HCR_API | HCR_APK | HCR_ATA)
>  #define HCR_HOST_NVHE_PROTECTED_FLAGS (HCR_HOST_NVHE_FLAGS | HCR_TSC)
> -#define HCR_HOST_VHE_FLAGS (HCR_RW | HCR_TGE | HCR_E2H)
> +#define HCR_HOST_VHE_FLAGS (HCR_RW | HCR_TGE | HCR_E2H | HCR_AMO | HCR_IMO | HCR_FMO)
>  
>  #define HCRX_HOST_FLAGS (HCRX_EL2_MSCEn | HCRX_EL2_TCR2En | HCRX_EL2_EnFPM)
>  #define MPAMHCR_HOST_FLAGS	0

Should the xMO twiddling in __vgic_v3_get_gic_config() also get dropped
here?
