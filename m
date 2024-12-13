Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2057.outbound.protection.outlook.com [40.107.94.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E2E81DFE08
	for <kvmarm@lists.linux.dev>; Fri, 13 Dec 2024 15:06:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734102375; cv=fail; b=ohUVnB+FMewIyNAgfp3fC4gGcAnG2IcFNbHJ0a9zQvM5QK/Mbtw0t3zIpdkjuspMPeJJsj4alMfIgpcvpf1nk1K8lqkVO5EIMQB2/53D3Nm3qgnZtLVH7uoairhjdhPqdldTXsaEyTVLb46AjMbBKFF11FZAxCG0MiZaWbKbjmw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734102375; c=relaxed/simple;
	bh=D3+22+zOVwCVZKCDAKpAwDboowyDT+myZq0MwCiuoKI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=lmxSvSs+xQSUhmaHaALZEpuMMmYLhD1WW1exHri9w4rQLzBu0Oq04lY2ywoGvHGIO0H42dsgsaajNMx8UWOdcu1xtnZoVo8b7R2sLX4I2tQpgao5H6nlInVXL5kImr5l3UhSiQk3tIFyMzo/lLPf0flVgIznYwBZdUuWaLq64/w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=BPH8ecJv; arc=fail smtp.client-ip=40.107.94.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="BPH8ecJv"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OCTGcYfjWZqOsO1hGn989X0NCE1ic/EEp3FMX70uXUTOlSnCorMrA8DOylC3LM+BLyk2znUZbrDQ8RkFVxT8c8hNYC2tNs7bDziBnLY2+4K7L6j25xbWLpeTvt9L68j+2XA/SLQgtTu3HaFIhcrkKRlVwbSdQTTHhXB6hh5W+niUpDUfSHxn57cSAsS+4fMobJXqexEMZHKQxrlJm+QpDChJzzqWayPhgSzNLqsLTwRDsCvK0syi3nFUV3xP48Kq+dQ6S79vFl7wRZlVSGKLv+kCICiBxYLNPDyUhXzSt9VHZVLjaojw90hBssMFHYA3Wbuem3Q9hxDoDmDzsGk+MA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Au40W+IPq+W9f7QBAl2itYFTkZ2nUW6lOkg6FZm3o44=;
 b=OW9w1ktS36wBBVNcB5bcipSpG5u9hKrZLhSMWSeJpcKDhWYMcEY64VPJRP21QTJNYFFxFAMFxublmiAhbGw7KTbUZdm+FHTxHmyyVcap1SJ6RH0FsOFw0PuiI6spcHYbcHTJ8uUXuYLkYfRswdgTwHCXIB98Nvk70Tkp9MLSVQQZSRme86yZSuciH6tJCuZTwkW6qrUFB5ohxx9/L+nYjWWk0N4gT9vH/webFqBjZd/0QqJCLNZNrWl6i4IPnQW0Gn1XG9OMJlEbUtAKiC4ucnI3ffZiFPXM6AXSL/ukKpIhonbUMFE9d13mCZUPu/YhGlRryJwkZWcbNC88eVcW5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Au40W+IPq+W9f7QBAl2itYFTkZ2nUW6lOkg6FZm3o44=;
 b=BPH8ecJvhs2uuwejfBmRovJUkzTB7QBwQMe7A1cAke+YAzYFjtZY35aVwpI/EEDhOA3kPqxX3mPXa3YZo3vML/I19nQfSC6v5SQf18mjfA1FgOM4Mfqlz84ydXfl9EniqH/Mo2PsLkhdWMkMvybEcvm9bQhzlb5NqTsqueB34yM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SJ2PR12MB8109.namprd12.prod.outlook.com (2603:10b6:a03:4f5::8)
 by SJ1PR12MB6313.namprd12.prod.outlook.com (2603:10b6:a03:458::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8251.16; Fri, 13 Dec
 2024 15:06:09 +0000
Received: from SJ2PR12MB8109.namprd12.prod.outlook.com
 ([fe80::7f35:efe7:5e82:5e30]) by SJ2PR12MB8109.namprd12.prod.outlook.com
 ([fe80::7f35:efe7:5e82:5e30%5]) with mapi id 15.20.8251.015; Fri, 13 Dec 2024
 15:06:09 +0000
Message-ID: <cd2e2945-1b62-4fce-82fb-68f0692bf053@amd.com>
Date: Fri, 13 Dec 2024 16:05:59 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] mailbox: zynqmp: Remove invalid __percpu annotation
 in zynqmp_ipi_probe()
To: Uros Bizjak <ubizjak@gmail.com>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Cc: Jassi Brar <jassisinghbrar@gmail.com>
References: <20241213145809.2918-1-ubizjak@gmail.com>
 <20241213145809.2918-3-ubizjak@gmail.com>
Content-Language: en-US
From: Michal Simek <michal.simek@amd.com>
Autocrypt: addr=michal.simek@amd.com; keydata=
 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
 3i3l5DA=
In-Reply-To: <20241213145809.2918-3-ubizjak@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: VI1PR09CA0173.eurprd09.prod.outlook.com
 (2603:10a6:800:120::27) To SJ2PR12MB8109.namprd12.prod.outlook.com
 (2603:10b6:a03:4f5::8)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR12MB8109:EE_|SJ1PR12MB6313:EE_
X-MS-Office365-Filtering-Correlation-Id: 5dc41c33-f920-401d-cbd0-08dd1b87acdc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QWxNRzdCcFppMTNiWUpieWNPcDIxNUprcG5kVG1hM3Bmbmo1OEVlckNxOGZq?=
 =?utf-8?B?QUxDc1RDWVhNMklxTDZRVTc0aU1qMkRrbkpOWHhIeGZVN3VsS3BvZWN6MENX?=
 =?utf-8?B?NUYySS8rdjVIcC9JYllPWm15QTFkOWZnM2wyeGhIVE9ERjA3dXh6YWdnVWpy?=
 =?utf-8?B?QVA1Q0ZPOERFSGhOdkVDSXFYZlQwVnFkVzd1Sm5vN0pyUCtuN0Vrc3NIeE5a?=
 =?utf-8?B?ODRRQUw2aVVtcmd5dHBQUW9HSnE3VzExUWNCckRTcmFYSkpYc0VTeFJmY05C?=
 =?utf-8?B?Uml4VUhwWTk2MDVKcnhyVnR4cHRMQmxhSDMwRVRDV0orVHZwN05oNVpXU29S?=
 =?utf-8?B?OXJ4dWRhRTFwRUFaNHRBbDBuTEE5MFE5SVdOTXQwdlN2T3l3QVgzOFYyZVhE?=
 =?utf-8?B?R1pVZnBiMEhSdzN0TVovSDJVbTZaanBMWWZuSjR1eHNxWlVnUXpYaUNHS3Fi?=
 =?utf-8?B?c0R0YkZvbndPbG1GeENIQW9TMlJsbElXZ0VRcy9ES2JKcENXOTJoSHg3VnNy?=
 =?utf-8?B?ZXIxMTZUVWEzdVpqSE43QVdnT2JCQldtUVBnZG5KQys1Zmo1eXMvOTVMbUM4?=
 =?utf-8?B?YlVtdU1ZdzNGTnN3SWVzV25xeWlvb2NiL1dGUW1hS29paVVkUXh4WW1XK2RS?=
 =?utf-8?B?UkVTQlJHTEhDMTczMmx6SUorT1R4UzdmNHV6OVd2dU81TlFQMkhOMkdMTEh0?=
 =?utf-8?B?MVlDektvUjBWNlZHd0luZDV0d1BGNnR6elhsZEY3NnpvWW8zRitBNUdYRWx4?=
 =?utf-8?B?R2Z2amIxUXNvSTAxOGgwdXdZVlMzbi9tS3pxRVd2WW9yditDQVhOUzRGTjh2?=
 =?utf-8?B?Z3NCWXRDK1pzMFQwQnRURnkwNEhBOUlDUXhzSGJvTlhaRFJvRGVuWTVFeEJq?=
 =?utf-8?B?c0NqbWdTbHpLT09yYS9KQ2xYdkhKK0xXbTBXTHVyT1ZSOVhTd0tvTnZNSXhD?=
 =?utf-8?B?QU5xZC9WTDJCajhuTngyL0U0WlpkNGRsZ1RiQjFkclkvZmZVS2t3M2JQUWZw?=
 =?utf-8?B?VFFkMGJVckpiZE83T2cvbmI3QXNPTG5WQkV3aU9FbklCbVA5MlhkTWdaWTJU?=
 =?utf-8?B?STBIRW5XT0VZVlhVYzFwRVN3Q3h1MGVBSU5GVjdZU3NOaWxWM3djbzZoODY4?=
 =?utf-8?B?dWhaaEFGNjVTTjg1KzF2bkI5b09iRklwUmgrZFllQ1N0OUxmZDN3eWVJRG12?=
 =?utf-8?B?aWpGdC9qaG96eE5xMmx2NmM2RlZuQmUzdnFLY21WUWViT09vWTJLRDhMR3RT?=
 =?utf-8?B?eVJqb21YMCtjWE5wRGIwTUhLQXJMVFROMXRrZ1BpdFIyWEJCcTl4MWdJcFds?=
 =?utf-8?B?dFdSaFhud0tUWFd1eWo1bHRIa2JOb1Zlb0R3T241Y0Y0b2lmVng2WjNKNmFV?=
 =?utf-8?B?UjNMWEpTSDEza3U2K3ZMVGtsLzE1STZpVzdhTjhGU0NTei9WSEIrN1QrOE9B?=
 =?utf-8?B?S0lGc29YVjQ4K2c2ZHRlanhJeVdqNDdVZHdNL0RWVFJLNlVscVF1Tm90amhC?=
 =?utf-8?B?UlEwY0NYR2JNbjdkTitqVTdPTEJhV2ovV0hWZE53MzBnY1EvREp5NHZkYi9x?=
 =?utf-8?B?M0F2OS9jNUlQSVo5YTRKMGhtYW5UTjR3Y0YxKzg2MzIxK3BQY3gwQ1crSzZw?=
 =?utf-8?B?N3VKZmRXd05RR2FYNEJocE55d2JLOHR2eEZvQzFGak8wbGV3eWNibXJRL2xk?=
 =?utf-8?B?MTMzdGpkWHlYeUdMSWo0ZFZEUHU2NHBnN3hwN1l2WmpGUlI2OG1QNHU0dnJq?=
 =?utf-8?B?bVQ3cE5aOVRwbDMvL295ZnhRNk9nQWJZblFjWGZ1OUdOZ0dXM2RmaHJ4VHJa?=
 =?utf-8?B?REJ3L3BXNWNKQVRCcTl3QT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR12MB8109.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SlJmRmFZd3A4V3FCVGtuUTQyL1VXZW1oSGJ2OTJJcjJBT0U4eEFid0o3ZjJy?=
 =?utf-8?B?c05qZmtpRjVJaStlUzNpRHNuVHRMQzUrSnQ1K21DT3FqTFpiR2NJZk9WTjhK?=
 =?utf-8?B?aHNFamhlaldPM3BNQmJIWHN5cU84YnRQUWphTDdrSmh1MFJJWnV5ZWhFZXp5?=
 =?utf-8?B?RFptS01VVm9TamMzQkF4dEtUNzN5QTF5VDNDTHhmenAzdmQxTjFOSXk1M0VM?=
 =?utf-8?B?MDRpOWZZMDRnMElOVFNsYWJqbCtzNCtPdTY4Z0NGelZNOWdzNjFhb3BqVTBk?=
 =?utf-8?B?V1hUbUhMaGNQNEJZRDgrWkk1aHl2S09jY2Zma1ozOVMzTitNckxBaWRIS1pX?=
 =?utf-8?B?MFl4T25PWHJ6UGNHV1g1OUg0c0crTS9rM1ljblBOdGJnYTZmMlc4UldJblhV?=
 =?utf-8?B?WlZFUEJHMk02dUN1VzBnZ21lWHcvZm03dXM4NGdHTEE2YXdNM0wzRGxBcEVB?=
 =?utf-8?B?ZEdCaGNEa2xKYlVzOTRTdzhHVGdCaitTRmxCcXZ5MnVxdDFqS0hWUUVKVnln?=
 =?utf-8?B?WlN5Y0NHcU53S0h1cWhZdjgvOEZINStmMk1DemlJaFRYVXpJMEJwVnBrd0NY?=
 =?utf-8?B?VDlWWnJDMCtUZS9sTWZlWCt2OUZOTTNzWEZSWkViWUEyRHNieDVqek56bmJX?=
 =?utf-8?B?eXZ0Si83SUJZVVBZbzBESGFVQzBRUkNKam1ZOGgwc1lyMU5KajJwYmFVKytP?=
 =?utf-8?B?bTFHbDNGM0dqOERtMm5iUmxRTUExWjE5d01uM2g4MC9WTW56Vlc1T01qSnZ5?=
 =?utf-8?B?TzVOOC9Eb0cwTXljOWs2bURsVytoQWdHLzhTenJZcnpTbmgyeHF4N3dRUjBv?=
 =?utf-8?B?SWpZT2h6Q3ROKzRTcUpieFA5eXhJamI4ZVg5cmhpc01qSDFWajc5eDBkWGpl?=
 =?utf-8?B?STVVT3FKSnpVeTJjTzgyclVvcDJWWEZNRmJMSitNVGJyT0hPZFZGUkh0ZTdt?=
 =?utf-8?B?L0RhNzZGL2p3MDFMSjZoeGgvVW9rb3Z2ZnlpRzBrWUtIQTd0cGdkaTBjVnF5?=
 =?utf-8?B?Ui8vYkozY2tjbkxBZzRMakdtQ2FFdDJPT1o4bUtZd3BqbEZFRGpHbi9pK2c3?=
 =?utf-8?B?enZDL1R1TVdsbG1WTHlZejY4VmwzZ3drZytMSU56a2ZTTEhUMndUcmRwWnVF?=
 =?utf-8?B?Mlh4cVF2bnMranBIcHRjbTQ1a2pOTTBKZzdwQUxtZTZ3Um14MUpPVkxxdkR5?=
 =?utf-8?B?N0Z1eXV5cVhIeVNIenJpK1NrS29KU24xN242ZzRVZyttV0k0UXZIWU5WakJm?=
 =?utf-8?B?aUo3allUeEF0QTI2ODBHb01mZDZveitIZjkvOEhJSEhoTG5RdlFOVDYrV3hQ?=
 =?utf-8?B?R0ZQRmNyOXRhRW9ZcU9wNndjSWpveEE4K3pob3NueE5yZmFTbm5LR2lUclBp?=
 =?utf-8?B?eUt1Q21ES2kybmZFNG1zQS9oN2RxanZ2U1VaRS9KdFdic3lMUkZuVjlNeWJ4?=
 =?utf-8?B?VlEzcC9vMklBT0hRZEQ0QzVZWmcxNzM3TDJhTFVZZFhYQ2FQWXZyVDQ2eklH?=
 =?utf-8?B?THpScndOUDJIUlowUGQyTkQ4dzRkaEhsenowa21zbGFqanJLZUdZVzg0YlA2?=
 =?utf-8?B?T0NzdVA3dkJkRHFmVVR2VHpqQS8vV0pYMERja0xRQTZLZ3p2c2MyQ1Z6d0I2?=
 =?utf-8?B?U0FJS2pIYjl0SVVUZFRkOWxFTlNpQ2dDbkFVdE5PSkhhbXlBcHVSTjNhV0Jr?=
 =?utf-8?B?Rm9hVk1adkxFZkgyWkx1bDZMUXlESGtwdXltc0FmcWFkWkk1ZVg5NTY4SzhZ?=
 =?utf-8?B?d0RTblVHWnBFN2NzQTdkUkdnVmlMM2NibU45NkxRMWdSbkhTVHlSaGo5R1p3?=
 =?utf-8?B?SFBxT1RKM3RaR1k5WXV6VnlXTXh5TDhQK0VURG9qanpOUG8xS0lVV3hyZUo1?=
 =?utf-8?B?aGZ0Nkd4S2x3cEg2NHQzSVVLRzRsd0VRRFVWTHhHanYrT05Od3pYTERMSTZw?=
 =?utf-8?B?UWozdnVLYlNvbWs3cVdVRFdQZ2dqd0E3MVVwWm5uQzJjTHFDOE9OUGtYcTg3?=
 =?utf-8?B?clA5RENqQi8zcUpUYUgweWRoYmI4ang3MmtoU2RSQ0N1Tm1LSjh5eVV2VnRW?=
 =?utf-8?B?UlFFSjdUTGJTNGZWWUFrZmxBdzZXYWNBQkdnZ1R2eTBSUWN3UWlPTHJpcnkx?=
 =?utf-8?Q?37RTS7WHC1B6k7MDQCi1D8l9I?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5dc41c33-f920-401d-cbd0-08dd1b87acdc
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR12MB8109.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Dec 2024 15:06:09.3733
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8KOXaGuj8rvrBcNs632EX+ot3Camis5I7uONdMIq+w76aK9QezQxkXu9jCQ+8DV1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6313



On 12/13/24 15:57, Uros Bizjak wrote:
> struct zynqmp_ipi_pdata __percpu *pdata is not a per-cpu variable,
> so it shoul not be annotated with __percpu annotation.

typo here.

> 
> Remove invalid __percpu annotation to fix several
> 
> zynqmp-ipi-mailbox.c:920:15: warning: incorrect type in assignment (different address spaces)
> zynqmp-ipi-mailbox.c:920:15:    expected struct zynqmp_ipi_pdata [noderef] __percpu *pdata
> zynqmp-ipi-mailbox.c:920:15:    got void *
> zynqmp-ipi-mailbox.c:927:56: warning: incorrect type in argument 3 (different address spaces)
> zynqmp-ipi-mailbox.c:927:56:    expected unsigned int [usertype] *out_value
> zynqmp-ipi-mailbox.c:927:56:    got unsigned int [noderef] __percpu *
> ...
> 
> and several
> 
> drivers/mailbox/zynqmp-ipi-mailbox.c:924:9: warning: dereference of noderef expression
> ...
> 
> sparse warnings.
> 
> There were no changes in the resulting object files.
> 
> Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
> Cc: Jassi Brar <jassisinghbrar@gmail.com>
> Cc: Michal Simek <michal.simek@amd.com>
> ---
>   drivers/mailbox/zynqmp-ipi-mailbox.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/mailbox/zynqmp-ipi-mailbox.c b/drivers/mailbox/zynqmp-ipi-mailbox.c
> index aa5249da59b2..0c143beaafda 100644
> --- a/drivers/mailbox/zynqmp-ipi-mailbox.c
> +++ b/drivers/mailbox/zynqmp-ipi-mailbox.c
> @@ -905,7 +905,7 @@ static int zynqmp_ipi_probe(struct platform_device *pdev)
>   {
>   	struct device *dev = &pdev->dev;
>   	struct device_node *nc, *np = pdev->dev.of_node;
> -	struct zynqmp_ipi_pdata __percpu *pdata;
> +	struct zynqmp_ipi_pdata *pdata;
>   	struct of_phandle_args out_irq;
>   	struct zynqmp_ipi_mbox *mbox;
>   	int num_mboxes, ret = -EINVAL;


Feel free to also find commit which introduced this issue and add
Fixes and cc: stable to v2.

Thanks,
Michal
