Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11022132.outbound.protection.outlook.com [40.107.200.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A1A61CA9C
	for <kvmarm@lists.linux.dev>; Tue, 10 Dec 2024 12:48:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.132
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733834898; cv=fail; b=FYKQy43TZrPZZuzrXAgcUI63QB3dAp8agDuOsP4vcmWSzFE7g56w0kwn/MKahYeBOlSoQqIugUzK4Aiwanuzq/7+OwKL3F6JxEz2AMDUKgPk6ncNUS5inL1EZorRU+tFVPJloygDJeHdbbOWE8aluYgUCTq9y35/F/5tHNd9+2U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733834898; c=relaxed/simple;
	bh=GXrfREQqyfQkmquUjgxj2+SZ+xhAaQ9R1x4Re9na2cY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=LR6iPmWzyZ3xSHaWQz6IWvSU6llYGsl1P/hUVI5ZtQh+fqk9104DfvXCnuMgtwMVEROjxoP73u2dwiPTj+/nzdeMyn07yQsLpZ84txRPRJdkFvZ3nPxcmCKVGlVmlTRtRNT7U29su/fxksLFDuLL0NuvYE0zl8nqvFuu2sUMVa8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com; spf=pass smtp.mailfrom=os.amperecomputing.com; dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b=eP6rfkr3; arc=fail smtp.client-ip=40.107.200.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b="eP6rfkr3"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=D7Ibkt1Kz2/SRZ1TcoDr3jVRTMZ1MZG6riBWlFwIzT3rVUDkzbi8CQMZp8gAxmBmBg+NdQ88uv+79p6rNJ9y+XI/k9pM66TLq1Gan0eRGZLwTzPD8+WfqhvCmNPuyuZbmwQ5lqRDacrT9rQ0vs3kKsYklCCKqYLzkZKLVg0/eAahAy7bUBkYnhIgwhYY5LA1v793zvfM5GsjKne6fk8A9H15ACc/RdpDgVoDxCuSOB2jy3ia1wQ5nNWZR88PJX97w7BkFtoBoQ9C6ZT6aPmXz9UuiDxIoZj4Zbr7G19mkGPQo2v3MwL5gHAv/fQS/xEZCVFTay9pMmL551BtAShgIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J8x1udZZHvdT+JK8AgVjGOdciByLjSbhqk4gHF4lK3M=;
 b=jnv7MaCn5C1Puhl7J0BQzarSygnjK4MY/GKWkeBLiVHymvy4NvK+JmRy/XoyKgd79iZEAidzHVIoqF2aonnBI1oaqnQEZyAVZ/1tCJGPTyYe+j1nbskQYWDh0w3IguxC4sedU6B7mDVPfOTjWr94ztrPJtUbrfFThyOPRAKM2Eel7bzMF+i7gjSuJD/1TMt3Kc6aQOltExtiSM7/qVaUV5S1aYdCdmuQ233vLtYzTc2dDN7vlPB1HLDvSmX7hedFnXPIA/yZUFtDNh3wmH6qtT0myFLBcsQh1R4qVMoHllKHIPgCDVxIhfEg/mAH/ayWtDLcuLXwo4yhqob0PTmKUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J8x1udZZHvdT+JK8AgVjGOdciByLjSbhqk4gHF4lK3M=;
 b=eP6rfkr3iZ2eJyV2TrmlU2AOrVI5T2RoRN8SDAigBxrdpd6H06RoU8x7h8Lr6mo898EVDIJYb+fFYFKUtUsgHEsdVzai8TYBCKHRhNWF+7kZaHN3Oop+s6EZmrdHcz9wTaBDFlFkh2p6408aFOeln74RZITsZVtDAuZ9BYG0lFk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from SJ2PR01MB8101.prod.exchangelabs.com (2603:10b6:a03:4f6::10) by
 SA3PR01MB8476.prod.exchangelabs.com (2603:10b6:806:37f::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8251.12; Tue, 10 Dec 2024 12:48:12 +0000
Received: from SJ2PR01MB8101.prod.exchangelabs.com
 ([fe80::292:6d9c:eb9a:95c9]) by SJ2PR01MB8101.prod.exchangelabs.com
 ([fe80::292:6d9c:eb9a:95c9%5]) with mapi id 15.20.8251.008; Tue, 10 Dec 2024
 12:48:12 +0000
Message-ID: <20a6d0d5-2733-4959-a9a1-bc6c2e64111f@os.amperecomputing.com>
Date: Tue, 10 Dec 2024 18:18:04 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: arm64: nv: Set ISTATUS for emulated timers, If timer
 expired
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm <kvmarm@lists.linux.dev>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, oliver.upton@linux.dev,
 christoffer.dall@arm.com, suzuki.poulose@arm.com, will@kernel.org,
 catalin.marinas@arm.com, coltonlewis@google.com, joey.gouly@arm.com,
 yuzenghui@huawei.com, darren@os.amperecomputing.com,
 vishnu@os.amperecomputing.com
References: <20241209053201.339939-1-gankulkarni@os.amperecomputing.com>
 <867c89tc4q.wl-maz@kernel.org>
 <c5b1c3d7-56ca-4afc-a831-045dba4beffa@os.amperecomputing.com>
 <865xntt2kv.wl-maz@kernel.org>
Content-Language: en-US
From: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
In-Reply-To: <865xntt2kv.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA1PR01CA0146.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:71::16) To SJ2PR01MB8101.prod.exchangelabs.com
 (2603:10b6:a03:4f6::10)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR01MB8101:EE_|SA3PR01MB8476:EE_
X-MS-Office365-Filtering-Correlation-Id: ee69a2e2-bfff-448e-b3b4-08dd1918e814
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WlZyUXFrTlJ1dzkrWmhrWHE3eE5PemVYcEt6Nm81UCsvbW96M2J6RWhJQnhN?=
 =?utf-8?B?UjJKVDZXSTNvamVObmx4d2JkTHlTc01SQ1RiaW5JYzcxc1YvZGhFRThxUXg5?=
 =?utf-8?B?TG5DU3dyVXRzc0RNMzhhTUx0RmRHSlJIL2syUml2SXoxRWc2VUdVS25OYmpU?=
 =?utf-8?B?bjZ3WWw1Nkd6N0dGMFRNTHljR2FqaG9qNXBBNjcyOS9NMElkR0ZNSXZXbW1K?=
 =?utf-8?B?aDFXcFNseTRCbTFjQ0REUFFBdkc1NW5QVzdUc0VFbVZhU1ZVN2RERy9TYWVO?=
 =?utf-8?B?OFRnRkxyb3Nab3NwOXF4OVZOcU9Eb0dreUFId2xNalU5cHZ4ZGtsTlczK3h6?=
 =?utf-8?B?eUd6dG1OZlM1a0dYa1lsdG9JT0swQXdsTHpoTUpDUWpaR1N2QW1TaEtyMUlM?=
 =?utf-8?B?V0JseUJmNTV2RDB0UTFNWWtBelE1cW92R0Mzb0RrN2dobzRHRytVVEZzZHdq?=
 =?utf-8?B?YmpQdTVTemlkVUR3LzB5aThoYk5LcnNTYUllZXB5dHRmY2N3dHk0NGRCWS8w?=
 =?utf-8?B?cVNzSUp6NXRPamxOUXBlTWVrTnVKTi9QMXAxS21NQ1JYckExaDEybzVqMHVJ?=
 =?utf-8?B?UFJYSjljVzNNd0YvTE80eVBMdWhyekdJc2hyQ2hGMUtOYU0rWUFRdkNNcnMz?=
 =?utf-8?B?TUQyTXpCWlVHbHpZUXB2Y0habGZZeE42aTgxWkttclU3RHFDY3ZVT3plN3lG?=
 =?utf-8?B?TS9oNXVuMDl3VmVDaC9Td2lDYldjUlJyZVVSQk0vV0c3N1BxUWpQaG5aclpJ?=
 =?utf-8?B?MnRrcURsVEtFQytsdndyQzZNRWFKVlpaUWhyczg3R2huUVdPa0RWVjQ2R0Rh?=
 =?utf-8?B?L1JZazhmT0RDS1RoUDU0eHdjRTVtTThTZHhBTS9wQnh0TFRucTRwbHE1ZkNv?=
 =?utf-8?B?NXV6MTZxdVJjMGNieHpOcFYvakJPWGdsaXNSbVpiR1NvT1prN25POXBsRVZr?=
 =?utf-8?B?VkJQMG1QdmVyTWx6bWZwZitYbnhpQXh4QzFRRm44UmpNR1VSbXdLY01KS3JB?=
 =?utf-8?B?Ympya0kxQWd0YkZIR012N1lkOXYreHFtTGZYMUJBVTh1S2FqYzdlNmRBM2Nr?=
 =?utf-8?B?enk4NHI4ZGcwb1dyZHVYSnJ5b3NmT1JMOXo3QUp0TDVHc1QxMElpOHpyMUpL?=
 =?utf-8?B?WVRkZlNkd0VNV3FURWtBV3Q0UWdhN1M4RXA2eC9tc2NyL0VQaVNaMGVoZmla?=
 =?utf-8?B?YlR4MVFzQjVPZVZVdDNRRHA3L0pkQTl2ZGRwcEpBTWRQVnE2MTlFcjdVbU4z?=
 =?utf-8?B?Q3NBTDJGbVBxVjlCUnRJQTFYWnl4UUNlemNGUHJJb2VINnpjK3p0N3ZuQk8z?=
 =?utf-8?B?S3ZhYjdUOTZZTmpyT3l2UUdNaE81MU9WbFFnb2ZTQloyL3EyS1hFMTI2elZ3?=
 =?utf-8?B?NHZGUDkxQjN1dytwcU16aEVhZ01CMEVIYms1ZmlCdElOMVV4WVNPaWFPTVZo?=
 =?utf-8?B?Y0wrZjJ6cWx6MkNRK1d0Tm1ZQ05kQWpSVTBKQ3FFcnhPUWV2VnBmL0s0OXFO?=
 =?utf-8?B?UWw2WlpiOEpLMm4wd1lUb0kyNm5keVVvZnYwY3RVY3YwSnhiTENsWVMzNUR3?=
 =?utf-8?B?SUU0ajdLVnRpckk5d00xTXBGNFpicUlwd3d6V3FkRGpvdkFUbWtHU0dEWXU4?=
 =?utf-8?B?SjZqbW0xcmdWUGV5cE9xUmJjeHM5cFoyWE12UU5PUUtUK2Y4TmhPUDhPVTA5?=
 =?utf-8?B?dXJNdldHZmxvRUMraW1RWnVDTVdzamFzNEdDM1FWc0o0bnVaZlUxdkYzc0NW?=
 =?utf-8?B?QUd3aTJMMFFiUmQycG5la0tQK0FNT0NLS0FQSDVHYmhyNmMwTGZCOFlCMzNI?=
 =?utf-8?Q?CYCVQmoR4HmR/t8Hs35X1w5ejp8NF/cSg+NDs=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR01MB8101.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(7053199007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UnNhckxkd3Qxd3Q3K2ppSUZZMDhpTkU4cTF3Q1JMQkVycjBQb045REloeW9L?=
 =?utf-8?B?cUo4bnFBUllNUFZjNW54RFJNanVpelZIelVmdCtlVkM1cHdFSkt4ZlIvQVd2?=
 =?utf-8?B?NWNQaWRUWGw2YlFzM0RzdzdPSTR2NzdxMmo2amhvQWF6MTBXVTdIT1Jaanlz?=
 =?utf-8?B?UVlTNlhRYjVtcEVlQ1FlNGpnVGhIRms0U2Zhck90WExCSnBzN2ZzVVQ3TEFq?=
 =?utf-8?B?UHhVQXJYQTZzSzYrd1FhMTFlV2xLTTRlWnQ5dkZsUmd5bmh5T2NrRG9udkxR?=
 =?utf-8?B?aE9zbUl5SWo0KzR2Y1VRQ3B0QXF1Nmd2WTZyS2dvc05PUHBzK2ZtcGFkMjB1?=
 =?utf-8?B?UFdEaVo0N3p6ZjJTZ25DdmxzcE1xSnFiQW1TNys2bFdsNTZrT3VFbDFtMWJr?=
 =?utf-8?B?YWRPejlhak1YVUphTGVjQzZMWnF6Y1VKT3puZVlQb0Q4blFzditvUlNKZ0gz?=
 =?utf-8?B?Y2g4cHZUOTNsUHlJQzNrZGNRdG1ZdUVlbFJyVHVGOGtZRHBBNUxwY2lSS0JH?=
 =?utf-8?B?UEt1OHNaZ3NicHI1WGtQWUVUNjhCUnNYK012cFpvZ2ljcVFkY2hBWlM5TXVL?=
 =?utf-8?B?R2x1Z3BGQUFVYXN6ZkpuQnVOdG45djJKbCtnMlJETG5ydUEveHRtRFV6aWZi?=
 =?utf-8?B?Yzg4dTFyZkF4VE04dDA1K0VpTnJNQlY2Q3c3WmcrdlNIQ01YV051NFVYZ3FU?=
 =?utf-8?B?bE5ERXhtNXM0dkI4K3FFMUtTcXdTallCSzd6SWxVR292Tld3MnZCd25UNGky?=
 =?utf-8?B?dEJDR0dvZ0k5RDRmVWRxVzFKdTJiMFIyMzNNajZyMkswMmpoekd6SjlpSEJS?=
 =?utf-8?B?TUVLNlllUkd2Q0p0L2xRQ0NZcjl5TjN1SkFFT0lrc1ZSSjZZc20wdHFxMUFF?=
 =?utf-8?B?aElXUG5LeDFRK0ZVQzVaUjUzZXJ4cDVCSGxkUUhJMDRTcTBtYzAwbGZVL2x3?=
 =?utf-8?B?bGJtZzF3L1pjZGV4bDNrVU1QUzlKbi80N0VqOWw0UytKdjJhc1pGc2NlK3gx?=
 =?utf-8?B?M2RIZTYxVmFUUlVIeWpZTnRrNFlScjlNbzd5R2p0SzhhVzRHb3NydldnMmsr?=
 =?utf-8?B?NW1nTFZkaG9HM3IvcWd5a1l4U0hIdEU2WGx1SVE0SFFyQ2FrWUsrTXZZU0Nh?=
 =?utf-8?B?OXlsUU9lcEs2d3FyWURqM2xCT2tGbUI0akgrTVRYUTZCYzk4NjBVb21JZDVX?=
 =?utf-8?B?TXkycmdESncwakVQMCswbktVY0RYcjRaSG1tZm1mYitaRzhXQXdOWnVHdlVy?=
 =?utf-8?B?WFdnWXRFVzA1cDZvaWd3bmc1SDBPemd0N2RpVU43czZ1ZG1vTTk1enB6M2VG?=
 =?utf-8?B?UE9FMFVHeFhuUkxkczBQdzNRaEkxVVdOT1lVby83WSsvNjNhcG5HZy8vZVlR?=
 =?utf-8?B?OHpGSm5oUmVHbGdsaXlEdlk3eStwZHo3ckhvVEE5cHRKYndBMmYxK3YwQjNq?=
 =?utf-8?B?cDZ5NGVrOStKRGdWREpxMEd0S3VyOGpiRWhZQzR3WkVyWkV6Q1picXZWVWh2?=
 =?utf-8?B?WFBpUzNRaXBHSllkeVcyNkVBamVVK2tiU0h2N0o4cStSdS9JdVdoZEgwSGVY?=
 =?utf-8?B?ZHBuaVdwNkk2c0M1Ujd1b3g1NE92eEltU05qUUd4NkQ2ZWFqVkViQkpVZDRZ?=
 =?utf-8?B?cFRwK2tqeUV3dFBpZHh3N0FGTURHOXVpa0JQeStvUVp2bkFRczFnNStmaHps?=
 =?utf-8?B?OXlzaW9YdWo4KytlVW9pbisyZHN4bmtCMklxRXBzWHl2d1loMndseEJxWDU2?=
 =?utf-8?B?a0I2NjRSRm9HSGk0RlNWdFpYZDgrL1dLTWJ3UkIrOThrR1BEQUlZTE4zeEdT?=
 =?utf-8?B?V0JZYkk0Z2NVbndOZDRnUmpJbDNhYmUrTlg3em5pR0ZUdjl3d3pjcjFkdS9I?=
 =?utf-8?B?TVVFZEU0T0szaEg2WVNMemgwWGVFazY0WDJmY0hadnh2anNhcitwTmY3ZDlI?=
 =?utf-8?B?aWw5bmNEZVZTZVA0OE1FUEJxYkFWVGk3NnpGM3pTM2tXcnZ6TjBPOW1mQW1W?=
 =?utf-8?B?Z0Fybmw3Vlo1MXBINlM3aWRrUy9vUnFMTmQ5cFpqaVN1RUg0SmVCbHFUMmVF?=
 =?utf-8?B?TXJlaFdTRkh3ZzZDRzkvTzM2WCtxOWVIK2R1TGNpQUZOSk44YWZybmo4THFH?=
 =?utf-8?B?Yk5IM1pWYVQ3eW1wV3N1OUxKS0NSYzRjVldoZFNFa2VZVGdOZEUxUHRWdWNx?=
 =?utf-8?Q?GNE2CjeB7LdZNQhknnaMsKFo3PRmTfg/K9yI+kceizPd?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee69a2e2-bfff-448e-b3b4-08dd1918e814
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR01MB8101.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2024 12:48:12.3321
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EQMebjXOgP/bg6FrOfN56TFarZoJ4G270AYRDTNiBtw1hENYuDLTguHvJQECX6xf7P46uMm59EsZBsIfVEFHBbhw9f9zFMWvJur2yMG0Ux2I3xZ6ZMaSeuI8XVEV2zHy
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR01MB8476

> Please give the fixup below a go.
> 
> 	M.
> 
> [1] https://lore.kernel.org/all/20241202172134.384923-6-maz@kernel.org/
> 
>  From 2bbd6f9b41a20ad573376c20c158ff3c12db5009 Mon Sep 17 00:00:00 2001
> From: Marc Zyngier <maz@kernel.org>
> Date: Mon, 9 Dec 2024 10:58:08 +0000
> Subject: [PATCH] fixup! KVM: arm64: nv: Publish emulated timer interrupt state
>   in the in-memory state
> 
> ---
>   arch/arm64/kvm/arch_timer.c | 32 +++++++++++++-------------------
>   1 file changed, 13 insertions(+), 19 deletions(-)
> 
> diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
> index 895f09658ef83..91bda986c344b 100644
> --- a/arch/arm64/kvm/arch_timer.c
> +++ b/arch/arm64/kvm/arch_timer.c
> @@ -432,25 +432,6 @@ static void kvm_timer_update_irq(struct kvm_vcpu *vcpu, bool new_level,
>   {
>   	int ret;
>   
> -	/*
> -	 * Paper over NV2 brokenness by publishing the interrupt status
> -	 * bit. This still results in a poor quality of emulation (guest
> -	 * writes will have no effect until the next exit).
> -	 *
> -	 * But hey, it's fast, right?
> -	 */
> -	if (is_hyp_ctxt(vcpu) &&
> -	    (timer_ctx == vcpu_vtimer(vcpu) || timer_ctx == vcpu_ptimer(vcpu))) {
> -		u32 ctl = timer_get_ctl(timer_ctx);
> -
> -		if (new_level)
> -			ctl |= ARCH_TIMER_CTRL_IT_STAT;
> -		else
> -			ctl &= ~ARCH_TIMER_CTRL_IT_STAT;
> -
> -		timer_set_ctl(timer_ctx, ctl);
> -	}
> -
>   	timer_ctx->irq.level = new_level;
>   	trace_kvm_timer_update_irq(vcpu->vcpu_id, timer_irq(timer_ctx),
>   				   timer_ctx->irq.level);
> @@ -471,6 +452,19 @@ static void timer_emulate(struct arch_timer_context *ctx)
>   
>   	trace_kvm_timer_emulate(ctx, should_fire);
>   
> +	/*
> +	 * Paper over NV2 brokenness by publishing the interrupt status
> +	 * bit. This still results in a poor quality of emulation (guest
> +	 * writes will have no effect until the next exit).
> +	 *
> +	 * But hey, it's fast, right?
> +	 */
> +	if (is_hyp_ctxt(ctx->vcpu)) {
> +		unsigned long val = timer_get_ctl(ctx);
> +		__assign_bit(__ffs(ARCH_TIMER_CTRL_IT_STAT), &val, should_fire);
> +		timer_set_ctl(ctx, val);
> +	}
> +
>   	if (should_fire != ctx->irq.level) {
>   		kvm_timer_update_irq(ctx->vcpu, should_fire, ctx);
>   		return;

I tried this patch and it did not work, looks like there are some 
exit/entry paths which updates timer interrupt without going though 
timer_emulate (like kvm_hrtimer_expire). If I undo the deleted lines in 
above diff in the function kvm_timer_update_irq, then it is working.

below is the diff which is working.

diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index dd038d62e99b..a54bdb6dc566 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -432,23 +432,11 @@ static void kvm_timer_update_irq(struct kvm_vcpu 
*vcpu, bool new_level,
  {
         int ret;

-       /*
-        * Paper over NV2 brokenness by publishing the interrupt status
-        * bit. This still results in a poor quality of emulation (guest
-        * writes will have no effect until the next exit).
-        *
-        * But hey, it's fast, right?
-        */
         if (is_hyp_ctxt(vcpu) &&
             (timer_ctx == vcpu_vtimer(vcpu) || timer_ctx == 
vcpu_ptimer(vcpu))) {
-               u32 ctl = timer_get_ctl(timer_ctx);
-
-               if (new_level)
-                       ctl |= ARCH_TIMER_CTRL_IT_STAT;
-               else
-                       ctl &= ~ARCH_TIMER_CTRL_IT_STAT;
-
-               timer_set_ctl(timer_ctx, ctl);
+               unsigned long val = timer_get_ctl(timer_ctx);
+               __assign_bit(__ffs(ARCH_TIMER_CTRL_IT_STAT), &val, 
new_level);
+               timer_set_ctl(timer_ctx, val);
         }

         timer_ctx->irq.level = new_level;
@@ -471,6 +459,19 @@ static void timer_emulate(struct arch_timer_context 
*ctx)

         trace_kvm_timer_emulate(ctx, should_fire);

+       /*
+        * Paper over NV2 brokenness by publishing the interrupt status
+        * bit. This still results in a poor quality of emulation (guest
+        * writes will have no effect until the next exit).
+        *
+        * But hey, it's fast, right?
+        */
+       if (is_hyp_ctxt(ctx->vcpu)) {
+               unsigned long val = timer_get_ctl(ctx);
+               __assign_bit(__ffs(ARCH_TIMER_CTRL_IT_STAT), &val, 
should_fire);
+               timer_set_ctl(ctx, val);
+       }
+
         if (should_fire != ctx->irq.level) {
                 kvm_timer_update_irq(ctx->vcpu, should_fire, ctx);
                 return;
@@ -948,9 +949,6 @@ void kvm_timer_sync_nested(struct kvm_vcpu *vcpu)
          * which allows trapping of the timer registers even with NV2.
          * Still, this is still worse than FEAT_NV on its own. Meh.
          */
-       if (cpus_have_final_cap(ARM64_HAS_ECV) || !is_hyp_ctxt(vcpu))
-               return;
-
         if (!vcpu_el2_e2h_is_set(vcpu)) {
                 /*
                  * A non-VHE guest hypervisor doesn't have any direct 
access
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 2c35e1f8193e..52a263e7dcca 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1238,7 +1238,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
                 if (static_branch_unlikely(&userspace_irqchip_in_use))
                         kvm_timer_sync_user(vcpu);

-               if (vcpu_has_nv(vcpu))
+               if (is_hyp_ctxt(vcpu))
                         kvm_timer_sync_nested(vcpu);

                 kvm_arch_vcpu_ctxsync_fp(vcpu);


-- 
Thanks,
Ganapat/GK

