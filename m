Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010001.outbound.protection.outlook.com [52.101.201.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7840172622
	for <kvmarm@lists.linux.dev>; Mon,  9 Feb 2026 01:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770599785; cv=fail; b=UmcIl9eCKahiC0eed3YmXAhMa7q2JDXxdrEIm0hBqkgDySdUim+xITxSl3rduHtL928deN6iwuhAGwJsDvwgNacvfhCOK3Dawr38eZkCFW31kU9U3FSNKKRxpODWctwKLPVlNkVDsV6JYrUT2L7VKOadrWSg/g4dTquVC4JGyy0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770599785; c=relaxed/simple;
	bh=orsCTw+InUCLJzCyWIZG/z+M+V/rPvNHdCx7FK6TBnQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=G9HILKnQYC9LzAc4OopjeyJLOPTqD6f9F8UVKzd3nt9WqkxaVloT85JOfRuLFMr2+slsQcetzj4yFeN467qQ4KkgW+IV8lFq3x6L9S13odCn/+JVfXvZCuLyR+zdEgCNnjY3f79TajeFuxe5qN7HvlABg/CxKMtN/sQRsT0cibs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=IEzwBD2A; arc=fail smtp.client-ip=52.101.201.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="IEzwBD2A"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pDwlHRAbx16ixATCLBR2m5URsbz0hprGX5lYbtXx1TbGGlMJ3/7Oz+lu/jBBnNLTCGYUevrUVdorjfc7XuYM6rIHFIkfYtIX9HIpSEAimNJL/kNpTC9hV5L8hV99Y4bO9AfFPhuXYuQ8N9wfd3iSrqWW8G53BWMrQnbgkGYONjSWFwcitawcDdEdhhZVuzyEiBolidOTNjTaQ1Ahxz/gkIo9ttAOfIhPuSKCvUygrWxmJfhTvDvGoKqehGb4B8D9R2YYdSc++M+c+eM7VFHzonaOFAtMAwfC9QBxVtHVLSEkgjskAPL4r++7O2NWDbEVsou84nQCcybxFfZlTbUzwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TQcm7AkG6fBDR3h+gb9/oOvwR8AJEnoYlO2+pCwFih4=;
 b=WLKCr4RmLvZRyxaEuU11ugmMQIl0IwhNekZc+DOlGRGSus/K+X040wdmviyiAVzHAYNYkPg8KefnzxiMar5mxvsY4+60RthbEjKPmrizRfL0SMEUW8px0DPamNBRNB3i5YXTW8voLKK9d+CfHQz7jSLtzcMpF5VV3/FkpmO/BGVO0msMesi2A+POFQVJ2qjgxj/Ve2ovEYGw3YruC14y8Fm7OwvlDFUqKfvpzoP7yNS69/GUy+7+YDSv3U76Hs1Oxqz1rUTvxNIK3MTPcXqVuJNwvyWIarQWypKhxJ2wAOlJgeT5EMa3/Hn7YQ9AnUFWNlwH1QhEPP8A4FRBemwaPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TQcm7AkG6fBDR3h+gb9/oOvwR8AJEnoYlO2+pCwFih4=;
 b=IEzwBD2AQxpI9VL1ui+8q/b7C8D0WXmRjW84YkQ3PCbWg6xWKS171s8iguX0x90iaDp0DNNvYENsr8RQknseFHEDhyiQCMSqNgH5tiV2mH9E/nFAgm4KP3+sA+fPEJ4fVHi61V8Xq//thenw6FDQY29/jCthgcli/8lBp0eiCyYgDof07w/zPurP/U11INp17h6AZDIeaiUc7yzZSVGiHoOf0I6rvvuZvxMVjoaGBQAjwa0L6XvMRpkkgwrZjw9pXkLyfdvQx5KZ4qatb2LQG866dePH36KYtIE2cLrulagY6FVyxJSbie/vLAVEZRcG30IGfH2dNT28/Sio7vO1Rw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB2667.namprd12.prod.outlook.com (2603:10b6:5:42::28) by
 DS2PR12MB9639.namprd12.prod.outlook.com (2603:10b6:8:27a::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9587.14; Mon, 9 Feb 2026 01:16:19 +0000
Received: from DM6PR12MB2667.namprd12.prod.outlook.com
 ([fe80::aa9a:b827:90c6:506b]) by DM6PR12MB2667.namprd12.prod.outlook.com
 ([fe80::aa9a:b827:90c6:506b%7]) with mapi id 15.20.9587.017; Mon, 9 Feb 2026
 01:16:18 +0000
Message-ID: <2271224c-1796-4823-8c2c-6f529814e645@nvidia.com>
Date: Sun, 8 Feb 2026 17:16:15 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 20/41] arm_mpam: resctrl: Add CDP emulation
To: Ben Horgan <ben.horgan@arm.com>
Cc: amitsinght@marvell.com, baisheng.gao@unisoc.com,
 baolin.wang@linux.alibaba.com, carl@os.amperecomputing.com,
 dave.martin@arm.com, david@kernel.org, dfustini@baylibre.com,
 gshan@redhat.com, james.morse@arm.com, jonathan.cameron@huawei.com,
 kobak@nvidia.com, lcherian@marvell.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 peternewman@google.com, punit.agrawal@oss.qualcomm.com,
 quic_jiles@quicinc.com, reinette.chatre@intel.com, rohit.mathew@arm.com,
 scott@os.amperecomputing.com, sdonthineni@nvidia.com,
 tan.shaopeng@fujitsu.com, xhao@linux.alibaba.com, catalin.marinas@arm.com,
 will@kernel.org, corbet@lwn.net, maz@kernel.org, oupton@kernel.org,
 joey.gouly@arm.com, suzuki.poulose@arm.com, kvmarm@lists.linux.dev,
 zengheng4@huawei.com, linux-doc@vger.kernel.org,
 Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
References: <20260203214342.584712-1-ben.horgan@arm.com>
 <20260203214342.584712-21-ben.horgan@arm.com>
Content-Language: en-US
From: Fenghua Yu <fenghuay@nvidia.com>
In-Reply-To: <20260203214342.584712-21-ben.horgan@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0137.namprd03.prod.outlook.com
 (2603:10b6:a03:33c::22) To DM6PR12MB2667.namprd12.prod.outlook.com
 (2603:10b6:5:42::28)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB2667:EE_|DS2PR12MB9639:EE_
X-MS-Office365-Filtering-Correlation-Id: 4cfbbd67-cae3-4e72-94b0-08de6778d401
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?L1FVb0VRRmo0Q2NEbnd1TG1zaFVuamVrcGlJZUlQdUF2ZG9GdlN2US9iUnFs?=
 =?utf-8?B?MnhtL3A5Uld2VjhuT1pFUHMwU3pTK0RHZEFDKy8wMUFPdkJpRnVESXUzNllS?=
 =?utf-8?B?VUtOd1Bnc0djcHhLQTF5U1FMUFM2QXNBazRHcDUzcTZiZWFPMEhYSEZSVWNW?=
 =?utf-8?B?cGZlaTFUUjFpaUJHT2VBaHJLL1dMU1d0bWxER3NxMzlnUWJNdTl6Sm1wOU1N?=
 =?utf-8?B?U2M5bEZvamhYRGJFRDErQURodlp0U3l3bzlFam52b1locSt3cnBUeW8wL2k2?=
 =?utf-8?B?ZXR1ZHM2Z25tb0R6OEM3NkNYU3FPUkdieWJNbXZnK3BNTFNlWXVTYVBUU3lO?=
 =?utf-8?B?bHVzTm94SEx2Tk1LQnZhdS9va1c1ck1KSm1CMUxnYXVsNkp3OWF6MlhwbjZ6?=
 =?utf-8?B?KzlQVnZMM0lvRVhOYUhneFhHTVBtODVXbDdnV1RaY09xdkNCYmVtVit2eW9r?=
 =?utf-8?B?alk0RTBKZWt5NlltNEs2SHREclFzZHNBU0x6MmRvaTlKVW5OT3hwQTVxWDAx?=
 =?utf-8?B?VzVrS242NkdTU2RGWlRJMUVDbXdzUFE5V2xsRzRSQURidGhvWWZrOGZFRWhF?=
 =?utf-8?B?R0hzWnVONnFBdTgxaEM2RlNlR0tVa1FiVktiSWhBZ2xZRjJxY1ZHcC9IU3hB?=
 =?utf-8?B?STFDR1VFSHp4STdsZ2NuaUN3VlpsUjd5OHZydHBJYVJodGt4MEhWQ2w0SVhx?=
 =?utf-8?B?SlBUWkRlcG82aVR2NXU3ODhlL2g2ckJDaUZyQzRVcTh2anlJNGM4RWQ4Ym1m?=
 =?utf-8?B?enppcEpqQXhUd2tSTmtVWjNmNFFVZjZFV0xPWUNHcDBtL29GS1lPeU9aZW51?=
 =?utf-8?B?YjYwbFUzcTBXVzljdm0rcitGa2JwSmc1WU9QdmhGNjdFS2s1dFhmMmJHZThm?=
 =?utf-8?B?N1djYjY5VFRoSHRsSWJaODljaHk1S1lxaWwzNmdBWUpFREpqQ1RJWitBdFJm?=
 =?utf-8?B?aFRhdVRhVVZMNHpiSGdqUFIzMjVnaXZCeFRockZhZVo1c1BYeE14bndUeTNV?=
 =?utf-8?B?Tzk0MXlySCthOExNRjBubVNXT1Y3dzJkTWZYa21QWkNLTzRKWVExVVpmS3BQ?=
 =?utf-8?B?RFVRUlFJbHVTZHJrTVgyempvMmxtVDVabkh3UEpYRjUrS3IrRUNGd3FvUUFC?=
 =?utf-8?B?SkV1N090bkpteGNvVEt4Wm5nSUlUYjlFNXJ1SE5LdXpQeHpENUU3eE82MEJB?=
 =?utf-8?B?Um5NM1ZEci9FaFhwanY2REE0VjFEbVBsbDk3Nm9CM1E5eTVPMWdmdVNnazVD?=
 =?utf-8?B?WUpUWDJFRHFGNXJnT2V0M2VhdHd5cnljU1d6SkhuTmhWWjlKQmc1WXpyenE3?=
 =?utf-8?B?MGdtSW9Ea1ltSXc4WE11MkFQcENPWFNncWMrdXZPc3NZZFVsL050akw5L04r?=
 =?utf-8?B?Rmdud25nT1QyQU9sVTJndUl2VVZhbVRNUjZxbFRwMy9ONGlpV1l1MVo1VVRm?=
 =?utf-8?B?eHBTcFRBSmVZSGJQekExMEhmR1hHaDA0RGg3WnZzVTVtTi9ickxRMXE1Z01I?=
 =?utf-8?B?ZHVTeXFDT1JpeG1JeXVyQVcyc042bCt0QmRWYVBwYmpYdWg0SWpmZnpQdDh2?=
 =?utf-8?B?cUZnaDJoWXpXNzd6bmpZWUxjc3pYdGtPUVhnQnZhaGxkWXRnYkRMdk1NTjVj?=
 =?utf-8?B?aFl2UitLcFdQSytSaTllNmdUTE1DNzUzTTI1T1pQdDBNZ2I5K0s4ZmtqRDBX?=
 =?utf-8?B?YXlkblZyRGdvakxQa1I4MCtDTVg1Q29aMnhkS1BpeXJDRGFNeDhqQXRqeTIx?=
 =?utf-8?B?cWt1OHYzM3BLV0xrRnJLRjdtbmtUQjR1N2trTUo4QWg5UVkzTlNzQUVOY0h5?=
 =?utf-8?B?djU3d1B4eXdoUU5McmFyRC9MSVlGbFR2eEJwaS9tUnBueStINTJlMlNYeDN0?=
 =?utf-8?B?S3hLdTlrZHFRVGhlZGY2RHhva1pMRndjOUhnUHBDa0dOMmNlYjJOVGMrYkZK?=
 =?utf-8?B?R0J5cnVQZnRZZHg3bEorWUsrZUFiN3ovU1cwbUwvRU94NlBxSnNaNjArSHRi?=
 =?utf-8?B?SFNlT0VSMCswYlp1T0hxZ3YyZUZPRVdBYVIrSUcwY21heXpDYURIcXJ0eU9n?=
 =?utf-8?B?YUhmRlFIdGlXY3ptMmJuaUsxZlo2VXVLVnovL0lYMmkrbElQd3luUEtRckVG?=
 =?utf-8?Q?TDnI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB2667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dlRsWHNtR2JOSnpNekg2MmpwcFh4Vzlra0oxYURLdWJNNDRtU1NoOGtYQXJO?=
 =?utf-8?B?bDRBNURRMjkvSUtydkRCR1haK3pGVmpadU8walZNbUxMYVNINmdoTGxYVnZE?=
 =?utf-8?B?enBDWEQ2Um5telJpY05TSVc2TFFxUUJWenhaNGxVdXhDQThPVU8rTGhHZkxB?=
 =?utf-8?B?SkNrU3pQaHptSzVPQjVPKzhoS1pMRjduMldQTzZaSjYrT2FiTlpPK3IzQ2hT?=
 =?utf-8?B?bGJnR1dydW5QeTFkbUV5Nk9NTXQ0QmZkMHJ1RlVvcUxnVjExOGRXYlFXKzQ2?=
 =?utf-8?B?ZEI0RWRPcTZxUEFwR1NsUG9Dd1oxWmZrdmhNd3ZXWk84RXBCa2NFWEJwZ1hK?=
 =?utf-8?B?QXlRaHFGREV6NVowM1RPeUhWOE8rYzRIUkR6RUpYblFLc01XOTV5bEYrQWNu?=
 =?utf-8?B?Yjc5byt3bGNqc2I3UmRVamZEMitpblJ2ei82T2Y3YXhkdGcwV2Q4VjYrdlhV?=
 =?utf-8?B?dHFIWEFnK3RsRjBXVjNwemdkUkZDeXZnakpmak84V1VBN3hiYmRuYVBjTFlU?=
 =?utf-8?B?aFI2dWtjNUt6ZGptNTdKNkhHaVREdk1TSDZiN2RJMFZrRjFBSStIYnRxWENa?=
 =?utf-8?B?bEZVL2J1ejVJWE9zeEp4VDBtZmt6THNyR0hRYm9yTGFBeHVJd1hYSG02NS9s?=
 =?utf-8?B?YnRSWXcyeGJkUHNtdGJRTTd3dVhrNnBNUUV2OXFHNVdYcTd1S0d6dmZ2WGNh?=
 =?utf-8?B?aGMza0lDSnBRdThEWkV6aHBtVEpGUVBaZ051bW41MXJGMUN6NzljVW5LN1ZI?=
 =?utf-8?B?aFJ0U05kZnZPb0JjejJ0bE5UTVhtdzlxakRjNDR5bmEzUVlBK1M4UTl0MGM0?=
 =?utf-8?B?c1IzR1lRL25YR2daVFVINGJhYjRndmpIL1VGbHZsQm5GSjZjRVFQNHN2MW5F?=
 =?utf-8?B?SVYxT2NHdlhsaldTcGZlMU9sQXJaTUJ5RkNXdmdqeEljSHlyWTcyWGo3aUVS?=
 =?utf-8?B?bFFYR1lMRmxkdlNIZEZRRFFnQndKYVVWZzJBNjFoUW9oVjF3YXhjMFZoQ013?=
 =?utf-8?B?ZmxPOHhzaHBsU0tySlNiSkRTeVNjR0h3QjZGYUpNMXl6UFEzUFA1TU1wa1JO?=
 =?utf-8?B?by83cUdRNGhiZHRCbmFiRWJVaTFzakNCRzlkYitFK3o4K1V6cUQ1WVVvL0tm?=
 =?utf-8?B?R1JHM2paaDRDczgvbTdVSDJab0hvU2E2T3BSVnZyK0VhWExNaDVCb2NGK1Vu?=
 =?utf-8?B?UjhrOXoyMFpGbS9iWnRmTWtYV3QyNkdmb21qM2phdStmQnVyRVdRUjJ5R2l5?=
 =?utf-8?B?ZGtxcnkvYmN0STBnQnFZNVBaUi9NMCsvRlEzcHdLdU5lZ3J2YXVieEIvRDJm?=
 =?utf-8?B?bCtHemlKUzRRK0R1RGNYRVMxMEJ4enlKdVZIYmNvNXQvWXFXdWFDT21ieDFY?=
 =?utf-8?B?N042SDJMZVFPZEtUY05LU2Z5RUdteFR0RmNsZlZiRFBJa3lidCs2YXA1cUww?=
 =?utf-8?B?QUFrcjlDbW5TZzJ1YitQazcxdTgxck1iN0orbDZCOUVVaVVoS3JUcDFFWFpl?=
 =?utf-8?B?NjJHWHMxOGFVSU94VUlHakVJb1hLTE1YbTdxRkpMYzhSbUh3cjBOYjY0VStk?=
 =?utf-8?B?aFdCaHRYcURxaUhDV3dsT3VkSEhOM1d1TVpGZThaQjhtYXFzaWU1RU5rSHpi?=
 =?utf-8?B?SmpkdkI0RGY1dUpwYUFOYlZCeHdvc1hyYUw4Y0w3bWdXeEsrNHpMWFB5bEQz?=
 =?utf-8?B?QlIrdXdCQUhERlZKbTVWL055RUU1dTJvbGFPVWhjUHFRVDRXRjBheDNzTDg4?=
 =?utf-8?B?YnBtc1ZIa3FPUWpuVXlRUXFMWkZYNGJsd1ZRcVhqVmVsWDV0MU9CZkttQWFQ?=
 =?utf-8?B?WTAySmE0QnZkQlJERDVnQTd3VkNDQzhBd2FVQU5JWlo2U2NZWmtHYXVJYVFw?=
 =?utf-8?B?NW5KTVd1L2d2Sk5IR2d5cU05cTlSQ2Z5MUpRT2hqa1l6MW1UQW1Bc0s2dHdN?=
 =?utf-8?B?SGhHYjlhdkQ1UjJlNjBERkMvNGljTUtSUkF0cjUxUlZ4b1I1UnlrdDhibkto?=
 =?utf-8?B?N0cybk1BM20zKzBlWk9WN1RYQWExdWlQQmYwRmt3bW04ZUdVK0NjTk1xaFZT?=
 =?utf-8?B?YjNWWHJBZmpsT3NLdWNoZDJ0dFFhc0pKeEVrNzZVM2hVU210clJxdjJKR2hz?=
 =?utf-8?B?My9BZ0M1anhDbG1BOWszMXpaTmlzcXBDTGs4a3IrTDI5dDM0bUxCU1IwYlJx?=
 =?utf-8?B?Z1BzQ1VqSnMveU5WWUgyb08yTXJpNmdaQXVzanNEalRwaHZjcjg1NyttSnlW?=
 =?utf-8?B?YzhwSHY3UmlEMVNlWTY3Y3dZdWtIcStKQzdWRlJwSWthSzFUM3plVG5sditP?=
 =?utf-8?B?Z3ExZ3hTSUo4S1BvcTlzVGFwSmdwVkVSMDdzMEJuMlB5NWhlQ2ZnZz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4cfbbd67-cae3-4e72-94b0-08de6778d401
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB2667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2026 01:16:18.6588
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ekPr1FV7oYS21sAjvtT5zwY3ZwiTr8F/iLWivmLqcwyuy94j4FEDGeYT4d+j/LMlGoLeuiVbRf+983cYydUm+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS2PR12MB9639

Hi, Ben,

On 2/3/26 13:43, Ben Horgan wrote:
> From: James Morse <james.morse@arm.com>
> 
> Intel RDT's CDP feature allows the cache to use a different control value
> depending on whether the accesses was for instruction fetch or a data
> access. MPAM's equivalent feature is the other way up: the CPU assigns a
> different partid label to traffic depending on whether it was instruction
> fetch or a data access, which causes the cache to use a different control
> value based solely on the partid.
> 
> MPAM can emulate CDP, with the side effect that the alternative partid is
> seen by all MSC, it can't be enabled per-MSC.
> 
> Add the resctrl hooks to turn this on or off. Add the helpers that match a
> closid against a task, which need to be aware that the value written to
> hardware is not the same as the one resctrl is using.
> 
> Update the 'arm64_mpam_global_default' variable the arch code uses during
> context switch to know when the per-cpu value should be used instead. Also,
> update these per-cpu values and sync the resulting mpam partid/pmg
> configuration to hardware.
> 
> Awkwardly, the MB controls don't implement CDP. To emulate this, the MPAM
> equivalent needs programming twice by the resctrl glue, as resctrl expects
> the bandwidth controls to be applied independently for both data and
> instruction-fetch.
> 
> Tested-by: Gavin Shan <gshan@redhat.com>
> Tested-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
> Tested-by: Peter Newman <peternewman@google.com>
> CC: Dave Martin <Dave.Martin@arm.com>
> CC: Amit Singh Tomar <amitsinght@marvell.com>
> Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
> Signed-off-by: James Morse <james.morse@arm.com>
> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
> ---
> Changes since rfc:
> Fail cdp initialisation if there is only one partid
> Correct data/code confusion
> 
> Changes since v2:
> Don't include unused header
> 
> Changes since v3:
> Update the per-cpu values and sync to h/w
> ---
>   arch/arm64/include/asm/mpam.h  |   1 +
>   drivers/resctrl/mpam_resctrl.c | 117 +++++++++++++++++++++++++++++++++
>   include/linux/arm_mpam.h       |   2 +
>   3 files changed, 120 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/mpam.h b/arch/arm64/include/asm/mpam.h
> index 05aa71200f61..70d396e7b6da 100644
> --- a/arch/arm64/include/asm/mpam.h
> +++ b/arch/arm64/include/asm/mpam.h
> @@ -4,6 +4,7 @@
>   #ifndef __ASM__MPAM_H
>   #define __ASM__MPAM_H
>   
> +#include <linux/arm_mpam.h>
>   #include <linux/bitfield.h>
>   #include <linux/jump_label.h>
>   #include <linux/percpu.h>
> diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
> index cd52ca279651..12017264530a 100644
> --- a/drivers/resctrl/mpam_resctrl.c
> +++ b/drivers/resctrl/mpam_resctrl.c
> @@ -38,6 +38,10 @@ static DEFINE_MUTEX(domain_list_lock);
>   static bool exposed_alloc_capable;
>   static bool exposed_mon_capable;
>   
> +/*
> + * MPAM emulates CDP by setting different PARTID in the I/D fields of MPAM0_EL1.
> + * This applies globally to all traffic the CPU generates.
> + */
>   static bool cdp_enabled;
>   
>   bool resctrl_arch_alloc_capable(void)
> @@ -50,6 +54,72 @@ bool resctrl_arch_mon_capable(void)
>   	return exposed_mon_capable;
>   }
>   
> +bool resctrl_arch_get_cdp_enabled(enum resctrl_res_level rid)
> +{
> +	switch (rid) {
> +	case RDT_RESOURCE_L2:
> +	case RDT_RESOURCE_L3:
> +		return cdp_enabled;
> +	case RDT_RESOURCE_MBA:
> +	default:
> +		/*
> +		 * x86's MBA control doesn't support CDP, so user-space doesn't

s/x86's/ARM's/

Thanks.

-Fenghua

[SNIP]
