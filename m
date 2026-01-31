Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011038.outbound.protection.outlook.com [40.107.208.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2806C8C1F
	for <kvmarm@lists.linux.dev>; Sat, 31 Jan 2026 02:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.38
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769826612; cv=fail; b=kkLBWGVjzkgWHvqrDgbVO0KufizeOxc6tZXuoIj0ERSxorxlaNgQtxJnL1QsL0LN+hNR+VD3+NwDoE0/xKLdYaXwG4e+TCS5CxyuFmt/8vv31dnlFSYh2cN2/kcrQ3mTknV6KrlR26OFgsFG+ZawbNZqIzYNsGmC10FgPyXK9QE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769826612; c=relaxed/simple;
	bh=kcQKBaUR/VkAhtSVlBhOAZfgAx+RQlzzbEKzw50vcJ8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=i2JdbA8IoWik1h6kwIdhDQt4FZ2A27d+JNtuKPhpFurOIOWFidqdam8VwIvCTMuj6vowO13GQ3B/SiqtryhqbHQjSBS6eURhMNYTvZc5IrKxTkg0cpEFwZonwgDQ/lWAObnU0qlxNNKUMOIDZ0UvBFacO9We3fzdeNiZQJOIcTA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=gsUM+Il1; arc=fail smtp.client-ip=40.107.208.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="gsUM+Il1"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XR/vrlIgum2609PEJQoLs6BhbO0LHjka2e1ukZjGDZTWziVcycRS22PqMzG2YMcM/NMsjON5ohCP39eeZ2dNJamH41RaqehARZPEhquE7QsltIG2ihQg8wYwFY2ORqgLUVFb9hzYyUhGydgdQGCRw7s9/IQoeJ37oilyQgxJk5I0JsdfUS8p9GD8JPzMh+7D4vItoSXx1r4UVx+CdxDlbWAl+77urxwvuSBtDZslYLdKVd4adLV+/xkkatPlXqnkYc/J1TzJTnFo6Fnz2nE6tHX4BstvZcjSB0PtAcYb4zuP9F3eSMQ2suPEQZQ7jlGee2ZIJzAejhXdjnIm2LZfzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zOcgW+5biuJA7b2/w1+EwCVfZFkqb5UziDhIrT4AB7A=;
 b=HJ6ZaUDcWBK7KcASTgRC4eTzshNOlk7IsNjWVdYjWEuSsOpdhub9IPzwthQ0MsQznwcKVC10coFNQfIo4GI5vr+t00k3R77200HtVXsjlfrGCcrsBKKEzo55LmYZPXh5oa5hGt+hH3SCso6e8ayDM+dIbWNqMlGCqKYgxF85hLbtWzQ87b3qgRf+DccLwaqcKj3Xo3j5v2qd3ZSvD7bYfFiJ7NQ/bWG68kg/lxXvuuGu+vlk9+mUhs0aVi4t7sqoRnstp5vTpRq5zkxHHl2u8zLksWHeRHqGI4v8aMdvwDUFj9JLEdr9VEhmxIh89KUtJz403Bv8NnabvPZsAxy3Wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zOcgW+5biuJA7b2/w1+EwCVfZFkqb5UziDhIrT4AB7A=;
 b=gsUM+Il1lYN1+i0IQXrlV8q50CPRYBMm8DAyz+iwijAAZe9nyXI5Re2XnFR3TQO23bn0J3LZSYp4HGNNytxuw8yvL/E2S4fYdW4mmfs4QUtCI9sZ4HE+rsRiKm0j1xXgDBRLPuh1PVs9BBTm0/MXSbpJjI6o1n364Ev+r0qt4CwNneWug3nDWz9W5oDHQgByNu065yFDqEpAnBqHx6OLG8Ndg2y4xPCVtMNi1H5d2J/vI5bUpojBqd+Cmh9X1pski8WqADppsQBB74en+DRGA1jtZwxKoFGebKtJWCZ9w4ahvxylE/6JxJ+mOMwsu3qocIf1952h8XsEQgWxt+mm+g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL4PR12MB9506.namprd12.prod.outlook.com (2603:10b6:208:590::12)
 by SJ0PR12MB6831.namprd12.prod.outlook.com (2603:10b6:a03:47d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.12; Sat, 31 Jan
 2026 02:30:05 +0000
Received: from BL4PR12MB9506.namprd12.prod.outlook.com
 ([fe80::1250:4d33:ce3a:82af]) by BL4PR12MB9506.namprd12.prod.outlook.com
 ([fe80::1250:4d33:ce3a:82af%3]) with mapi id 15.20.9564.006; Sat, 31 Jan 2026
 02:30:04 +0000
Message-ID: <9e01328f-7f28-4b43-aaf4-59d3ce80c268@nvidia.com>
Date: Fri, 30 Jan 2026 20:30:01 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 41/47] arm_mpam: Generate a configuration for min
 controls
To: Ben Horgan <ben.horgan@arm.com>,
 Jonathan Cameron <jonathan.cameron@huawei.com>,
 "fenghuay@nvidia.com" <fenghuay@nvidia.com>
Cc: amitsinght@marvell.com, baisheng.gao@unisoc.com,
 baolin.wang@linux.alibaba.com, carl@os.amperecomputing.com,
 dave.martin@arm.com, david@kernel.org, dfustini@baylibre.com,
 gshan@redhat.com, james.morse@arm.com, kobak@nvidia.com,
 lcherian@marvell.com, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, peternewman@google.com,
 punit.agrawal@oss.qualcomm.com, quic_jiles@quicinc.com,
 reinette.chatre@intel.com, rohit.mathew@arm.com,
 scott@os.amperecomputing.com, tan.shaopeng@fujitsu.com,
 xhao@linux.alibaba.com, catalin.marinas@arm.com, will@kernel.org,
 corbet@lwn.net, maz@kernel.org, oupton@kernel.org, joey.gouly@arm.com,
 suzuki.poulose@arm.com, kvmarm@lists.linux.dev,
 Zeng Heng <zengheng4@huawei.com>
References: <20260112165914.4086692-1-ben.horgan@arm.com>
 <20260112165914.4086692-42-ben.horgan@arm.com>
 <20260113153938.00007d6e@huawei.com>
 <80db7035-07d3-4fb4-a228-f9c67d2df1f4@arm.com>
Content-Language: en-US
From: Shanker Donthineni <sdonthineni@nvidia.com>
In-Reply-To: <80db7035-07d3-4fb4-a228-f9c67d2df1f4@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DM6PR08CA0056.namprd08.prod.outlook.com
 (2603:10b6:5:1e0::30) To BL4PR12MB9506.namprd12.prod.outlook.com
 (2603:10b6:208:590::12)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR12MB9506:EE_|SJ0PR12MB6831:EE_
X-MS-Office365-Filtering-Correlation-Id: 056b9e2a-81d2-4694-f864-08de6070a48f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dGRBZTFjNTN2bkVVVXFaRDNBMFpOL2phZXR0VE05Vk9uckNCRnBhcS9GZVRV?=
 =?utf-8?B?OXdoNndwSXFxS05SVmYzMHl4MHlvTnF2TU16VDl0ai9ic2p4MUIyc3NnYzZW?=
 =?utf-8?B?VXBWVlZFb24rUHVQRk9RNDlWd29zaENqN1MrR3lBYkdJMHZ0eklsUElmSjEw?=
 =?utf-8?B?MjVrU2xKL1Q4cUEzV3lKbHI2Y04vZzFZUFU1bGVTZWdCbUhYcUNBQzhPVHl2?=
 =?utf-8?B?SG91cEF1MHR4WTlTOE5uQitCNG1ERGlFZnN0U05OSWZLalhoN2RvdHBjUE1z?=
 =?utf-8?B?ZGJYK1ZnZTJKb05qbUpoellUcWFhUUV6QzZTd1Zsa1dvc2FwQnBVU0ZsYS81?=
 =?utf-8?B?MzlXT3FqWmhwdGFXMUsyZldDcG4vaGhuZzdudEViSSs2bEJZYm9WaWk5QlJx?=
 =?utf-8?B?RFREczA4Zmd2SVJaeWF4a1Rkcy9IVnB0ci90OUYyb1lDNi9NS0NSNC9CZElu?=
 =?utf-8?B?Y2p6UTdzSmIya3Nocy8zR0RZOERRYldlTU5XWU54MThTbVptVmJ4SGdKSncv?=
 =?utf-8?B?R2JCcjlhZUdpdk9GU0VwNUEzWGZvMG9LbDRUY3FqR0p6U0xjdUZKdDY4UUQ2?=
 =?utf-8?B?ZnZET255ajZ1OUdudzh5ZEFLRFdxMTJnZTJxVHAyaWNkMnZCYWJyZmlGcCtq?=
 =?utf-8?B?eTlkOUJCeDF5cmg1TFEwRXN3WmdOOEpjZDdVZUhoZHcrYm5kMGVsb2YyQ3N0?=
 =?utf-8?B?dmw3N09DOUFXT3BkZ1hxdXdIbFZ2WmRaVGJoVlJ6TXBmaTFBM1J6KytlN2Ez?=
 =?utf-8?B?enRrSXlJZC9iQ1JvSFgvR05oeXQzckxYZE13b1IxWjYxUko2RWJ2WXcyOGlY?=
 =?utf-8?B?WFVBYjFLQjFwMFVUSERISDdDaUJJNGNoWnVGSk9rVmtyQ3ZNSEtndW8vcE54?=
 =?utf-8?B?MC9CVVZXSU9iRENyVEVPR2xwclcyUnBYOWlWc01yc2ZpTWI0ZTVGNUJjd2xo?=
 =?utf-8?B?UHliSTRLQmpWaHA4K2o5TXhxOXJUQk1pQ2h3Q1pZck53Qkd0aTYxNkhRc1Zr?=
 =?utf-8?B?K1dpeS9USWI1ejdLME1odUhPRHZBVUdMV2xSSytGa0hmRGgzMzllSVM1SmlG?=
 =?utf-8?B?c0xJaXBpMlJJRWhuU1FGZisyRmpzWlZIU1NYR0luc0VJL2g2TGw3OFhub2VT?=
 =?utf-8?B?NmVCeG5vS09LNlp6R1pNTHlGK2R2OWVzcGtreFdvckh0U1FtTmlJTGtIWDJW?=
 =?utf-8?B?ZjJkeXplOUxwM3gxM3UyVC8ybVZMcHBYK0I1WVBIcDdIK01NZ1VxOHVyUGFo?=
 =?utf-8?B?b2NyWGIwWWN5YllZMzFKZy9ERFdPUSthU21IZjg4Y1JDMjJiTHhtYmRUY1o4?=
 =?utf-8?B?NU84UmxjRzJ1WUNLYnI3OXBOcmpveitJdm5DcURydUgzZ1ZEM0hJR2pucnBl?=
 =?utf-8?B?MVR3WXh2ZlM3cG5DbTdaVmlqZjE5YlloWDkyNmt1RkRJaGNSM2hZZklOSDJP?=
 =?utf-8?B?c0FSQ1FCODMrRzlTdFZWYjM0VXBZYWVYazRxVVF6OUxlQ0RTbU8rTEk1TVV0?=
 =?utf-8?B?bkZtTHBScXA1S3ZpNE13aWNQVFBCZ09pVTVpZUZDRFJ0TmIwWHFHLzdpNnZX?=
 =?utf-8?B?aWx3MjBPNnA1dUxtWi91bFo5cmpZUVY2YkRyUUxPNFN1cnU0bUdqVnNjeFlh?=
 =?utf-8?B?enVYdEVmSTZjWVQ4bkNmSTNqVVpMSE9ENGNkaUlMRHFhbHZhcHRPeGxvSko0?=
 =?utf-8?B?dk9Ja1F0d0k0eUV2elhLQ2U1VWxuejhvRHBvN0NYVVRTbUQ1bWhUOWNvUTZP?=
 =?utf-8?B?U2V6QkJnYzBzSXBrWFd6T2xPMDVOM1ROejZQbXlRMWxoOFdxMFYrejN6ZXlj?=
 =?utf-8?B?RTFLQWpoblI4UlFZZnFmd2V3dW8vR2tCZGNSSUdXSmpmeUVTOEduNExtbG1l?=
 =?utf-8?B?UHNrZ0xkZVE2NUV4Z0daU0VGd2F6WVM5cVBPTkpkZzl4aE10QVp3Q0E2eW1M?=
 =?utf-8?B?YjVsbUFrZ0k0QjROTythdnpubGdtdEdhNnMzMmNVeUJNRnh2R2JNamJFZE9N?=
 =?utf-8?B?M2ZwTXcxeGNsQWJGVVBjSGNNQ2tId0dRT1JWOUJhSVdKRWZMSDdxWEhDcHAx?=
 =?utf-8?B?Q04xRHhsS0xnUGJ0Ti83ZVg1THdGeVRiSkRiMzEwL1pyL3BPdm02QnVMbUFi?=
 =?utf-8?Q?FJxI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR12MB9506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dDJEcCtoU3gwWVlTdTRqR0Y5OHNTQUo2UU9UVVlxVmZ0MzhXcEFlb2t4OUJ3?=
 =?utf-8?B?VlJsOEZwd3dacmVqdUVmYTZIMnlGdnUzYklkbFB5eU1BMnVRdnNsRnV4T0ph?=
 =?utf-8?B?ZTRkcFo4cytjaDZkam1tcmpYMCtUajlWaW8vaHp3U2tPVGkyME02Q0d6U0F3?=
 =?utf-8?B?OVBnYjRxaitWVmlvMTM2cFVIWFROcWdkTytHc0FGQXJUUmlpQ3lYVXRBOTdv?=
 =?utf-8?B?NFVVQWxSMytWQVBsZUh6dGJVajRwTXBkM3BRblRJTDcvV0VjMGxxM0l4aXJY?=
 =?utf-8?B?eGhvdkY5SXZVZmJJcERJZG1KblpTRTZseGM2MnU0ajl2VjdsVzVGYktqREg0?=
 =?utf-8?B?VHkxREdZUXhmelk2OHlQUkVuQ1J1aWZpWnpDNE5POThGSjVPVlRmTGdCT0JG?=
 =?utf-8?B?ODJyeS9HOS9iK01BSGFiQ3N0VUdWVDNORGdYL2ZSMitsYWZITCswUlhmdlNE?=
 =?utf-8?B?OW00NnhsREVZVXdHQWRyb2tUZ0lqN1dOMExsSFhFUW1WZ0o5UW1aWkdNZFV0?=
 =?utf-8?B?b1hIaTNNODA4Z2NoQUdTelRjSGg5L0hiQzRqTlN1SWhoUGJ6SzlMVkFRdkEz?=
 =?utf-8?B?NHB0SFpaWUpaRFY2M1RERDd4OC9NdWRRMlpicGlCWU5yU2lyNWNxaHBJYW1S?=
 =?utf-8?B?MXhCQWhjdUdGRkFnV1RYaURSZ29ESlB0a1VramNKL2FiWC9nRUwvSlFyd1Br?=
 =?utf-8?B?U2U1VDRvRmoxKzVKYTZTVVBjanFhNlFWOUVGbEt3S0VwVzlQS3NxZjJmZDBa?=
 =?utf-8?B?emE3TWhqMUd2T3IrTEJaZ2toR1dNSksyaEViaUZxUjFSMzVrYVFDamdPbzdL?=
 =?utf-8?B?L2lvSExLcnRXdEt4SVJqN0FEc1RGd2x6Qk1uTDN3dzY2aWMxYTM0YVdrTW9q?=
 =?utf-8?B?WUxYOGswT2tKdE54a29FdU9wM29vYVY2K3NFNGQ0RjZPSEFCTjdTcFRObDNm?=
 =?utf-8?B?UXQ2OWZGQ21zUzYrMnlNK0o2bkUrQ0V1NEZQOXgxY3VYWUVlT3Fpb0RDRFpu?=
 =?utf-8?B?NDkzcm5mK0ZpSXRvaGV2dlVkOFFOMzA1elp1MFlYd3FOMVJTZVZNZ1F2bkx2?=
 =?utf-8?B?bncwRDZIU0FER0lLNjhpY0ZqcUVzeWsyeXpodmZNUVhxbjZWNENhU2x1RTNv?=
 =?utf-8?B?STdoTFUzeUkrYjI5Q3hJMTB6ekhzK3h0WGRRMm5JSnVFN0J2NlEyN2hKZ2hj?=
 =?utf-8?B?bU5ydGJlOFZFamZ0UlJGejJVdmpNV0diR20yU0lEb3c5VWd4OTRkMjZDQjB3?=
 =?utf-8?B?MHd3NE1YNWJ5bmFDckUzb0RGalg3TlpWazBlSXZXWUN6Q25JS0wvcW1tQitJ?=
 =?utf-8?B?L3Ezd2xxdnBxUEY0UDF3aEdsTVhBR3ROMmZMSDRyQU5wVitPWGxFdk9JVyth?=
 =?utf-8?B?aERUMEtFYS9SeEN2U0pqSE1jRU44c0hEVHFYWTNzZi92MEU0Zkx4YTRyS1hw?=
 =?utf-8?B?OVA4UEJyRGkzdS9TTm5ncnNWTGNrdDlQR210dDJTeUQwZGZZRWh3QmZtS3A3?=
 =?utf-8?B?azZIKzJtalZRNGplRVNQTm42UEY4VWRDamRXU3ZHdjBRTEJ3NG1lMk9XWko4?=
 =?utf-8?B?RGREWDEyZUFkQlQ2OEsvTzZwbkZwVDNuTC82WFR0c1AvVTlyUDJheE01M1Uz?=
 =?utf-8?B?QkZ2NGljalpSOHBYcldCSlhTWC93N0gvbFVLb3E4UUhxR2ZodWYrR2doZUxs?=
 =?utf-8?B?QXEvWWxiMEhpbTFDZkV1RFFDTkJOSENLekxGQStTd3lhVWk2SUE0RFRtMTNR?=
 =?utf-8?B?cU12OUJSR2psSTVpWHAxN0p2cmIwYUg1QlRxSWV1amhZUGVEcTZxSDZweEJt?=
 =?utf-8?B?RUY0bWhVQzNwUzUyaEVXeFE4ZXJ5QzBpekwrR1NkR0E3clhnYjhwMjQzbVFP?=
 =?utf-8?B?c2hPK0p0Tyt5ZFVxUHc2MWcvSC84UnRGYVNNcVhuMFdiVUtOME94TFJjcTY0?=
 =?utf-8?B?dTMwL2RaajBQNVBQUHlhVXAzaThtU3pQajBsTHhabkR1dXF0bmh6and3T1Zp?=
 =?utf-8?B?aXE2L3VzYUtGdEN4UGhhNjV6T0lpMnVWOW9icmVPakpLTGhERmlZcEkyd2Iw?=
 =?utf-8?B?T1dLdGpudzNiT09aZVlOSzNsT2hSeG5wTjdkRTYxcDIvcVcrWnpqVStBa21m?=
 =?utf-8?B?eEV0NURKbmF3aWViWEYrYTlCQTlLcTZ3NElGc2ljOVBBdkI3Nk1sQVNWaGhY?=
 =?utf-8?B?bjd5NTI4QmN3S0l0dnZVVzdmUW5NU2trMExrZ1hiK0JLQmhEMStDR2gzVXYy?=
 =?utf-8?B?RXJpZHN1WThPTTlzVjZJTlArcnlzTDR6cnV3OTBldkNxTUtFdG5TWnJndUVa?=
 =?utf-8?B?SjJydjQzTmxzU1VTc0htaEZJVmJ1WHB6aFVtU1dwU0IwK3lOY2ZVZz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 056b9e2a-81d2-4694-f864-08de6070a48f
X-MS-Exchange-CrossTenant-AuthSource: BL4PR12MB9506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2026 02:30:04.7933
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xqS+Iy+6bAsUXLlIW/qWkMdtsDuPQRi6qmrSU3TiQmSw9eHGTnpDADfrhGCXPcG5JLV1uLF0s5TUNb13Ix+uuQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6831

Hi Ben,

On 1/30/2026 8:17 AM, Ben Horgan wrote:
> External email: Use caution opening links or attachments
>
>
> Hi Fenghua, Jonathan,
>
> On 1/13/26 15:39, Jonathan Cameron wrote:
>> On Mon, 12 Jan 2026 16:59:08 +0000
>> Ben Horgan <ben.horgan@arm.com> wrote:
>>
>>> From: James Morse <james.morse@arm.com>
>>>
>>> MPAM supports a minimum and maximum control for memory bandwidth. The
>>> purpose of the minimum control is to give priority to tasks that are below
>>> their minimum value. Resctrl only provides one value for the bandwidth
>>> configuration, which is used for the maximum.
>>>
>>>
>>> Hence, I'll drop this patch, and update the mbw_min default to be 0xFFFF
>>> and for the value not to change even if mbw_max changes. I think this
>>> leaves us in the best position going forward without any heuristics that
>>> may come back to bite us later when proper support for a schema
>>> supporting mbw_min is added to resctrl.

Background: I previouslyshared original fix(seecodesnippet below) with 
James Morse
~2 years ago to address the errata, which explicitly recommends usinga 
5% gap for
mitigation of the Hardware issue (the problem described in commit text 
of T241-MPAM-4)

For some reason theoriginalimplementationwas splitinto two patches:
   - Generic change applicable toall chips
   - Specific fixfor Graceerrata T241-MPAM-4


Issue: Dropping this patch impacts[PATCH v3 45/47] forthe errata fix. If 
removalis
necessary, please mergethis changeinto the T241-MPAM-4-specific patch.

--- a/drivers/platform/mpam/mpam_devices.c
+++ b/drivers/platform/mpam/mpam_devices.c
@@ -1190,8 +1190,12 @@ static void mpam_reprogram_ris_partid(struct
mpam_msc_ris *ris, u16 partid, rprops->mbw_pbm_bits);
          }
-       if (mpam_has_feature(mpam_feat_mbw_min, rprops))
-               mpam_write_partsel_reg(msc, MBW_MIN, 0);
+       if (mpam_has_feature(mpam_feat_mbw_min, rprops)) {
+               if (mpam_has_feature(mpam_feat_mbw_max, cfg))
+                       mpam_write_partsel_reg(msc, MBW_MIN, cfg->mbw_min);
+               else
+                       mpam_write_partsel_reg(msc, MBW_MIN, 0);
+       }
         if (mpam_has_feature(mpam_feat_mbw_max, rprops)) {
                 if (mpam_has_feature(mpam_feat_mbw_max, cfg)) @@
-2332,6 +2336,31 @@ static int __write_config(void *arg)
          return 0;
   }
+static void mpam_extend_config(struct mpam_class *class, struct mpam_config *cfg)
+{
+       struct mpam_props *cprops = &class->props;
+       u32 min, delta;
+
+       /*
+        * MAX and MIN should be set together. If only one is provided,
+        * generate a configuration for the other. If only one control
+        * type is supported, the other value will be ignored.
+        *
+        * Resctrl can only configure the MAX.
+        *
+        * Parts affected by Nvidia's T241-MPAM-4 depend on this occurring,
+        * and recommend a 5% difference.
+        */
+       if (mpam_has_feature(mpam_feat_mbw_max, cfg) &&
+           !mpam_has_feature(mpam_feat_mbw_min, cfg)){
+               delta = ((5 * MPAMCFG_MBW_MAX_MAX) / 100) - 1;
+               min = max_t(s32, cfg->mbw_max - delta, BIT(cprops->bwa_wd));
+
+               cfg->mbw_min = max_t(s32, cfg->mbw_max - delta, BIT(16 - cprops->bwa_wd));
+               mpam_set_feature(mpam_feat_mbw_min, cfg);
+       }
+}

Shanker

