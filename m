Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010040.outbound.protection.outlook.com [52.101.56.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B1C31940B0;
	Tue, 25 Aug 2026 21:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787691628; cv=fail; b=KUW6oV/7Ey7bNMGvG+B1op1RPmTEfLD9iu5WgZgVuW6BCb4+kJvOtHDAjKJzNwmAPRwHIMJCXHmqki1aQ0NV3xxNgiq/LL8ImORyy6/UJZ2Fc6eYqZhAIrNIZwlZsD+MfPf80mafDRInd3aCN/cQGS4SGKrKlX04UH90dPYSGOU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787691628; c=relaxed/simple;
	bh=ILx/CE71z6jfTQML/ZQprdy1dkDX9d+2wavq805SuBM=;
	h=Content-Type:Subject:From:To:Cc:In-Reply-To:References:Date:
	 Message-Id:MIME-Version; b=SVEtyAwlFtGSv272OSZEUj83vVraxqdOrrbjU9YltMiDvqku7V6DrcHDAW+HY3K31KVo4Ve6Gzav/yq6TsmCm/vrcYKJAUGn+cbWE10cc3GTnhDnF5tXtbgWS88HFmnZZdhLa2MxoEDlGYp37+FTBFWyIA4c0+KSMH5YFB4yRdo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=IMraVzdd; arc=fail smtp.client-ip=52.101.56.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="IMraVzdd"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jatdX1xzBJAc7tFpFF4Pf7PcQhYMjVnsbLUPFpbT7QEaem9OIF40EHrEdTM3e6KpomjdvKFSrmnszHULJ4sy6hEWoHhBnMPFqi7y8KMFsXU1CAhj8uNilxCLBsfNXH57cs1Y09kBfCzSvt5SxehWS0xoEVH1dWxO74+D8FTK9D00GMck2Ao+8Ze3bfhPu84XiwKZXy9L9QYR22DUXJWztwHmMKccQMYAY7D/q8JLxXHA3NpoJE9AMhoBvIli7BpSgEFM1o1imC7dETd7QNQW1ReQgtPzwTC8Zp/vW/fP2/NfavtX/Cy1aU39nkvCmhZM6bLd2dvGHuuCbsihg2sg4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yfcCbC3snSesDXMFeT/5nA1eLwSThH//zJkXzyUt6iQ=;
 b=XQiceJViH56Ic9UlGQz3dim30aHCVQKrYND+zCn7G67klQBsauMZYso+mJ1Jd5HroeniA0ymAk+rVKdXIz/fne4KTPOWwxO+IsWSvc81dlKuoHzZeOQungu7JfErJ3OWV9hw9GHntP9FVG8uZWy/DJz5fs5EbLq/gg2/YKMB4ZoMmf93L826cdkf5pv64g+tsepxlv+YTSf86QDv6kBwvNyLMjUufWD7Qc6tEZKxOuvq1g7L4UgDO/yWY7PyJzvUM/fq3J/ZDn1v+8rpQSH4T5Wp+17E2ycOoxfE4HLYxNdY55aWouDNWW86i3XHbs9B41ok20MIj7J0di2LL7Cq+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yfcCbC3snSesDXMFeT/5nA1eLwSThH//zJkXzyUt6iQ=;
 b=IMraVzdd0itze9gqd3kmABDQUkD8x6/DFj4Zkc9n/IbsbB3YCo5N3qaHq+ces37Yzjr++TJ8D/Z/ZhOt76bUdNKKF4UfV52OvckUDwKgUT1p5OMFhNn27TUr1+DrTB5cwguLQFQbbSq1X+qxeJtSM8pC1I4AAbiQu6F4/0M6pWzdM3UG4dRq6rOoGEkFt/YBljIV+ZM9ZGJHI/ifzRomgb4DrK9Nu/qErE0BJQUSqBQDWyEODFyLbzHAUMXMTV8toNUVM5WyxXf79FQm4GKeyNDTtbeqsi8Ie+/yki816haPvsTErPWJ5jdSrKO6V3Z7MLhlvfdnycb0kbzsWVDg5w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by CY8PR12MB8215.namprd12.prod.outlook.com (2603:10b6:930:77::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.12; Tue, 25 Aug
 2026 20:59:54 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0339.012; Tue, 25 Aug 2026
 20:59:54 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v7 23/24] iommu/arm-smmu-v3-kvm: Enable nesting
From: Jason Gunthorpe <jgg@nvidia.com>
To: Mostafa Saleh <smostafa@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 kvmarm@lists.linux.dev, iommu@lists.linux.dev, catalin.marinas@arm.com, 
 will@kernel.org, maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
 suzuki.poulose@arm.com, yuzenghui@huawei.com, joro@8bytes.org, jgg@ziepe.ca, 
 mark.rutland@arm.com, qperret@google.com, tabba@google.com, 
 vdonnefort@google.com, sebastianene@google.com, keirf@google.com
In-Reply-To: <20260715115906.2664882-24-smostafa@google.com>
References: <20260715115906.2664882-1-smostafa@google.com>
 <20260715115906.2664882-24-smostafa@google.com>
Date: Tue, 25 Aug 2026 17:59:50 -0300
Message-Id: <178769159057.3356902.13161185498161727294.b4-review@b4>
X-Mailer: b4 0.17-dev
X-ClientProxiedBy: BN9P220CA0027.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:408:13e::32) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|CY8PR12MB8215:EE_
X-MS-Office365-Filtering-Correlation-Id: a270f4a2-fd9f-41b6-09a2-08df02ebcf8f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|7416014|366016|23010399003|11063799006|10067099003|4143699003|6133799003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	oNgXwXmbQHikf9mHHASqyTvBJ5UsJ/JIQ2fwP25TTCqfJJXAA31RqTbnsHmctcpq5Dw+S9EKUTM3CDQpfkTINfVN69q6YRPr6Jw0AxaYLn19Wt0Hp8tIIHn0TW3ikbqEjmctmPTvnuQyM72PO0Fyy/5nupdBLJ+ODTFcAXixr2QxGcIsg6L6q/pW8X1X/Peb5+uKm1bpG7lpDdvwesQWsrkC275WASLVyLumCbG90LM84SWLYFvEPXV93VIKuQdF7BIbCAMxfstYxk7/rjzaRGihAk4xgBHJUJyVV9+r84BO6H9moVnfJhy/mzZEqUvwkgFcTxKlrRk7ubboKuUNsDrWGVdjvMtkRq2eZ1B0bDjzO5zBy7f/DafbWfzmiK36vY+et/mqNoaXEvB3X81KJXTu0xNGReTNVcaKJj7MQ6cxo0GTu8oH1rfGEnFJgK0vMKhrvRfC4RYOakWYlBx6zMUIjnQaBxJYRoxQCCN3ZLJ/BURm8rGJH57XN/lUP6llujlwuDTYOeG0L+epoMKU3SE/KD8Ukaao8h8LLaN63CzmZTgYGlrxWQ2bLS+pjl9qVkQxJnQ2m41Np2Pke3DXNGjeKPKIK2tFYNt7UnTMUJ4xwQW2dSLhEwxeJIKWgJ2l6eZbvIF0i6M0Nw4r0DdHj5rh5Kb3/H+LWW9mR4hS2Ow=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016)(23010399003)(11063799006)(10067099003)(4143699003)(6133799003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?L1lNa0RVTzIweUJycmpPN1psQUlHVlpxanR2Nm95VGlpdmphRVBRZkYvOVFZ?=
 =?utf-8?B?eEdDaWZYY1RzWGZBSS84TVQrelZRZVpQOUhOR1NlS1VJd1QxMkJPeU9qTWhB?=
 =?utf-8?B?VmxLSFg4dWMrSjk2SFRBY2Y5MWZzT3ozOXdSK0JSRTdYcEZ1eEZmc2hWZUpw?=
 =?utf-8?B?UlIyemlHVjVLcWdQbXZjZzF0SXo3eENSa2xRbVNyRndrUFZaTXRWU3JYb1Fx?=
 =?utf-8?B?R1o3dVo5SU9wc2tQZ3FJSjBWaTZmVUNqOTY1S0F2RU5jQ0J0bTdsdG9NYU5h?=
 =?utf-8?B?QlFlQUdIanBMcFNpMHdQV01QVEZCNXRsRk5JaGdraFNhWUZSMlZadGFOMm4z?=
 =?utf-8?B?MUt5YjhQWjJEM0tOUndEenZlSThBQnRnU1g5VGhQN3RydmR4RGd5VVp0VlVV?=
 =?utf-8?B?KytjbGk1NlROa1BOUTZ2TjlTOE1nT3R4UVNWdnJzdzk3VXlNVmJiZUx1YTBY?=
 =?utf-8?B?UjlPeUUvYUdqNEpIa0RRM2RlKzZPTlpoR0xBRmEzT08vME03S2x6VXJMVk4y?=
 =?utf-8?B?bjNKY3hIUlFMNXU1T1BqTEsvdVA5NEQrQ2d1N01MZTV2U3ppMjdlaUROVWZ6?=
 =?utf-8?B?b2NxYytQSHN2UVhLNFFqTmhzMXNEcWVKckZJQ2IrKzR3MWwxWWV3STJKd0FO?=
 =?utf-8?B?UUpXMzI0bmovcmdtaWhadlNRUTNEbXJMOFROTElRaDBldlpQY0VtT2w5OTlj?=
 =?utf-8?B?WHByNzZBb2VUVUJqN0FnZExBZVhvaTc2WW1Hd05nMmN0Tm8xdDdqVzM1WHIz?=
 =?utf-8?B?bEp2K1lBdnJlTkx3RHk5Umg5cDM1V2x6UjhmdVZGSVJqQi9WZm1NNXE0ZEdy?=
 =?utf-8?B?QzhSSXdFbnFJODhIRnZudnNNNit2SkliWjZVU3k0UDdKNHEzUHZWZGM4Q2dz?=
 =?utf-8?B?TlRXd2lTdnUyaU1OekpWcFF5a25VQzlCZkI0N0ZIWDQxZG1YMXRGdy95RDFp?=
 =?utf-8?B?cUMyRUFLVy94TzQ2TFh3cHNIUFZlREttWU1NRmFibkZ6RGpEQ25XSlRRYzFM?=
 =?utf-8?B?M1E2V3E0VWsxaTBPTlUrd1lDYXVsRmxsbUNlMmxQaThqRkE0bzFDRmlWcFpu?=
 =?utf-8?B?aVlKejBhd0VhWXBmZXNvTUowWE5Hd1pwbUlKaXY5ZG5LaHBsWWQwL1c4UEkz?=
 =?utf-8?B?MG54R2tTMWlHNVJQUHNBeWJtS3RuWk85NndMTWthVkJEWGRJcDFabDcvcDdm?=
 =?utf-8?B?MTQ5U3NJUjlzUFBDRjBDdFJucWoranhpWldqcUJway9MQkw1TVFEU1RBVHpC?=
 =?utf-8?B?YVFZdTd5SFBqRlhpYVFmbzZvRUVoM3JEK1VidVhvandnTys1eUtmbXg5SGNS?=
 =?utf-8?B?SHY5amFQeUlsYkN3ZXU0cndEemVGeWczc2JWbng5Tk1LSTAxOUZ1VW9iQUlD?=
 =?utf-8?B?SmczMkpkNk9LbVBycUJaNWNDekYrTmtEM044Y283cmI5Nml1b3NPeDYrYWlq?=
 =?utf-8?B?Q3E4K01iek1xQWJ6LzU4NmQ2eTNIUkxoQjhaYjJCT2xWbTF4TThlMXhLejMy?=
 =?utf-8?B?cURMTkFvcHJQejZsVmVtSnpneFNHT3AwaWF6WnkyNUcvbUZQOHByem8rb0Y1?=
 =?utf-8?B?NEhBYUhWU2c4U2U1THpMaE00aWNjVTM4RktYbTRYMDREMjN4RGFpUnYycVM0?=
 =?utf-8?B?ckVhai96T1RtNVhQQjRDTnVJUTFCK0o0Ukk0U212c3ZtYW5SOXRpNUhSUE1G?=
 =?utf-8?B?ZUhoRnpZMlNQSUc0NTlVSis4VlFKTXhUeGpzNUo4aE8vNlYxek05cVNsRE5H?=
 =?utf-8?B?U3Bwa0VJYmlpSEVCdTQrMVZVL0cyaXh1em5BMUtQN2ZKT3l5Q3dJbHA2UkhL?=
 =?utf-8?B?Z1dvbmdkN21jR2VVMk9nV0p1WFBVZjRaa3d3UHFobnZnUjhtQ3I1WEZVMWpn?=
 =?utf-8?B?czZXcGNnWEkwYmNUeWZjd0srN2huNTZxaWo1eUtHNXNHSCszN1czZmlodVI5?=
 =?utf-8?B?R2Z2ZlRXc3BOVDJtczRaMkxTRUhlclZZdVZScE5MNWE4aWdUQ0NmdUp6VTBR?=
 =?utf-8?B?WVlqektualdUMjI5MnFhVjZTbVFQR2hON3M3VVlyNmJOV1RUS1lFRTZ2NU04?=
 =?utf-8?B?RFd3UDU1VE1raGkxeU9wTFRVWkJYVjRBSUw1TUlrdjlyNWRRdEtWUmtWMzZC?=
 =?utf-8?B?bGRUb3pidG1BbDhhbWpwTlFpNTFQOWlUZlk1VjZBQ09QOXVwanVRMkNtRnhT?=
 =?utf-8?B?Y3pSdnZKZDBXdXJGZXNXeG5RcGJSRUtVYVlNZTAwQVFjeTNKSGlWRjdnVlMx?=
 =?utf-8?B?aU9wN1psN1htRmZPSUwyS1Rqa0N1Sk16dnVoOXAwUkM1UTRITmx6dWZsZ2ZL?=
 =?utf-8?Q?mb+y0UU+mqiJcBG4+S?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a270f4a2-fd9f-41b6-09a2-08df02ebcf8f
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2026 20:59:53.5867
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FWJbuHAvB97sR0CC6KgNYNsGROuzCJZ4xW0AXvyfLwLTtLDlhoJc5rkdZ+8/2lEd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8215

> [ ... 129 lines skipped ... ]
> +	ret = smmu_attach_stage_2(&target);
> +	if (ret)
> +		return ret;
> +	hyp_spin_lock(&smmu->hw_lock);
> +	cur_valid = FIELD_GET(STRTAB_STE_0_V, le64_to_cpu(hyp_ste_ptr->data[0]));
> +	target_cfg = FIELD_GET(STRTAB_STE_0_CFG, le64_to_cpu(target.data[0]));
> +	target_valid = FIELD_GET(STRTAB_STE_0_V, le64_to_cpu(target.data[0]));
> +	if ((cur_valid && !target_valid) ||
> +	    (target_cfg == STRTAB_STE_0_CFG_ABORT)) {
> +		WRITE_ONCE(hyp_ste_ptr->data[0], target.data[0]);
> +		WARN_ON(smmu_send_cmd(smmu, &cfgi_cmd));
> +		for (i = 1; i < STRTAB_STE_DWORDS; i++)
> +			WRITE_ONCE(hyp_ste_ptr->data[i], target.data[i]);
> +	} else {
> +		for (i = 1; i < STRTAB_STE_DWORDS; i++)
> +			WRITE_ONCE(hyp_ste_ptr->data[i], target.data[i]);
> +		WARN_ON(smmu_send_cmd(smmu, &cfgi_cmd));
> +		WRITE_ONCE(hyp_ste_ptr->data[0], target.data[0]);
> +	}

This doesn't look good enough, a driver can't safe writely to a valid
STE in any order like this, and it can't make it non-valid or risk
breaking guests. We had this bug in linux already, the hitless STE
update in the hypervisor is mandatory for linux guests using PASID.

You should use the STE programmer logic from the main driver which
gets this right for every scenario a linux guest can trigger. I don't
think there is anything about it that would be difficult for pkvm.

-- 
Jason
