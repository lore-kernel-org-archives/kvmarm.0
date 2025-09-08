Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98F47309EF7;
	Mon,  8 Sep 2025 13:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757336834; cv=fail; b=NhW2OOmX6wovB5+X7c2TCzNUFZbSYIRHGsfFUR4Ci3w+if5v7Q3Nlw4V9qEhAp1OTZZIsUEjYEFN/Fg+bFM3/6MgcyzObFDVJ7POC3kG+dPoUxtppyTSNzJ1TTve6KFzg0wGN9FbAa4wau6nDLU368VqA9/EGRDl6YNOF/OaMZs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757336834; c=relaxed/simple;
	bh=TXNdF7fT34o9pPp0s7FTCOT/8FO3lYXw5XjlF/iFtzc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=t5kKKOCT4WH1d7NkBItT0LKVoKMgaExHa6SiWJrWHpav5YusxPN6pr5v1TveGQK7JMOyOj1iQZovJslE3sAJcUdsEAoRL7eqf1TFoow9VG9969nLGmOvdkXqwxQhWFXY/YUifiNiFWgSm08KvulmJ/DWGe7FPB/u2HZe4d8Y9Xw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Y5xslgtF; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=WaIoNQPc; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Y5xslgtF";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="WaIoNQPc"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 588D0mE9005766;
	Mon, 8 Sep 2025 13:06:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=HIyvFJlDLI5vaq5CLWI39kTFBUV2EejHd/Lj1YTV69g=; b=
	Y5xslgtFnJ+pBBKJGLggBrcafXBIJu+S2Jq1YJsNtBpm058+aLzkCbk7or9SfTu/
	lEyEJmzytA/xbajWOv2Du4Ac45GqUhd4A0+sXY1fG2yzOBaTkGeWY75WUT04a8Oi
	3rND+2pnb91hjmXhEHBan+0EdAx0v3dGi0QPLGouOdCeJWVFTv79fPclpRvTAifl
	psiZ9oRkyTMKnu4Y/xIms8EMEKtwaguFA2W85V+r3Lhl3JyRd7BvmdG5LGVMywbJ
	XVVr9Al9leaYHLq1CYFz0nw0X097VH46uaGKIrnoIjp7UJ4QrqDXc16UFJPbv0y6
	u+VMzNjJh8RCY/2bNApSng==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 491y4br2un-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 08 Sep 2025 13:06:57 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 588D5c74002821;
	Mon, 8 Sep 2025 13:06:56 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12on2088.outbound.protection.outlook.com [40.107.237.88])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 490bdep6bu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 08 Sep 2025 13:06:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vVinT3Qaw+e0YAaceL5WJX40+hGuNQEXoDslqhgEwjLo+XWvBZ2sZloOr4WZUour5L7jWQXFBCBRbBspLdOQNFofGaApqyycZHp0pK+RfWGECK9NKMiDjOG5F2FMbszUwjtCQOZHPoqPR4DkvC2RHaod5oE1cJMDFHhkQ8MYwp6d3wDF6TMN14y5HKqqm3fxl2d9Esq4qGXVD9FI/DPSkijQJxBNRBy9VhHg2mSiZQEISdMUXue2RZu1lUTbdVkw59rjjNUtzfR3oE9D4os2Nr5edAw5qEtysPEU1N3aI3/GManMDbCyGnJ6+BiLV6ic05mAao0DCePw/AQF0pyAmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HIyvFJlDLI5vaq5CLWI39kTFBUV2EejHd/Lj1YTV69g=;
 b=yWiMqq9B8G56RCQ8UmD2xnXiXnZ4ZaHtYiTCMi4TMqo59UzXCMf4v72bJBhBAe/JglvsEM57zFMnscTXz0tob27PTiRDlnVTwU0cYG95BM5lxxmiFE3cH9sHC1fhdnKLvlTMdeflRdrbvHvkNRE//wYz6JHY6s8SEV6x/wIYiS5TCpgkHTPB7kd0rwERphOpdQUuOs+pvdMufgWIa6qOv6GmlaCYqVwPffWEViGcPRWUsRhSdwppAiYd4Hohx6yXLTelGP3G99P4TGe0aomPd+SQdbttM7hhW9GxJbUwUUqVqtG4uBV694J76RkmaFZz+4FWIvkO6K+Ke9JnziGTXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HIyvFJlDLI5vaq5CLWI39kTFBUV2EejHd/Lj1YTV69g=;
 b=WaIoNQPcKbQUlcQRmamnDs3emiDcto1rODicitZ8HELPAMt16N4ZNLhz3/PVzqRBWmp1EIgGL3O31C9WpjPP0i8/57dQ8HMZUVNk9ecjcWFTLaPYAOpJCxqKTOtHarGoJ/QEqka4BAs+XfWHg8k70T5AI3LYvEwqOF3UsKTmL4I=
Received: from DS7PR10MB5328.namprd10.prod.outlook.com (2603:10b6:5:3a6::12)
 by BN0PR10MB4936.namprd10.prod.outlook.com (2603:10b6:408:123::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Mon, 8 Sep
 2025 13:06:53 +0000
Received: from DS7PR10MB5328.namprd10.prod.outlook.com
 ([fe80::ea13:c6c1:9956:b29c]) by DS7PR10MB5328.namprd10.prod.outlook.com
 ([fe80::ea13:c6c1:9956:b29c%5]) with mapi id 15.20.9073.026; Mon, 8 Sep 2025
 13:06:53 +0000
Message-ID: <f618abc2-666c-4455-8a69-62669d367333@oracle.com>
Date: Mon, 8 Sep 2025 18:36:45 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [External] : Re: [PATCH] KVM: arm64: vgic: fix incorrect spinlock
 API usage
To: Marc Zyngier <maz@kernel.org>
Cc: jintack@cs.columbia.edu, christoffer.dall@arm.com, oliver.upton@linux.dev,
        joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
        catalin.marinas@arm.com, will@kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org
References: <20250907201421.3612784-1-alok.a.tiwari@oracle.com>
 <86v7ltcqb9.wl-maz@kernel.org>
Content-Language: en-US
From: ALOK TIWARI <alok.a.tiwari@oracle.com>
In-Reply-To: <86v7ltcqb9.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0061.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:4b::9) To DS7PR10MB5328.namprd10.prod.outlook.com
 (2603:10b6:5:3a6::12)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB5328:EE_|BN0PR10MB4936:EE_
X-MS-Office365-Filtering-Correlation-Id: 4b907c6e-1e4e-40dc-8086-08ddeed894d3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZERPN3RmZWp0RDk0Wk9PS3M3QTMya25vb2lZR2VuOHRJa2xHUUhtM0FudkZp?=
 =?utf-8?B?V3lpcDJSQmdybmpjTzZTanVISzAvejN2RUZXcjQ5dVgvWDVlQ0ZUWDg1OU1q?=
 =?utf-8?B?MTRHN0xwY1YzQmJBSmZ2RE9FMFc5SmRUSWRqWG1BWGJRTUpKM0loaGRmRjdx?=
 =?utf-8?B?RVYxcXhiWW9nd21TNnFFV1NzTDJsRXJxZVlQblZPREtiQ2MzYVNoQUF1aFov?=
 =?utf-8?B?eWVrTHBlV08zYk13MzBUNFBxZlFDZzJLR3h6SU1kaVROd0pibGhHd2V1TUk2?=
 =?utf-8?B?bHJRcUk1UEtqa0xUQ1BzMmZBR2hiS2NDNXJCVFlHYmZadzNaQ0VXdzVoMGZP?=
 =?utf-8?B?NmxnOGZiaGErY3VUek1VcEZpUDV2aTJWQy9tQTZnNmhHeGg4alFLK3RQYTQr?=
 =?utf-8?B?Z1ZJanJNNWxRSXFVTVczNlBlcHhsaGp2Y0cvRnAwTFc4b080V25VdmVKU0xx?=
 =?utf-8?B?RmlGRzZvZG9XNC9HdnJuV05EbmVlOXlrcHdQSWhsdFZGSG9CT2JpRTczZ29p?=
 =?utf-8?B?Ym9rWmx3Um1vUWtDUEZuTlAvUXJTZmZjaHJlblV2SzVtSFF2S21TdU8xNlhH?=
 =?utf-8?B?MjZaNTZoMUwwTzZNR0N5MzJBMTNpVDlHaXdUL09mSE9JSDF6L2ZhUVozTVZX?=
 =?utf-8?B?bVVzcGN4clBIS21FcEFneHppN3d6UkU4U1piVzZOemhTaWhTU1hhTUIxeXJE?=
 =?utf-8?B?eFVGNEp2ak81bUdKMURXUmxmL0hGRXAyRUdiN1hzMFI2ZDZLZ2pUaEh0a1h1?=
 =?utf-8?B?ZWdVYjdkUjZyczNNUENXZFZyWTIwODhPS0RWUThVN2lMcTBjRXltNGdjcTZH?=
 =?utf-8?B?V05MbFpUN09WNXoyM0hPSjJ5c01rV1BDNVkyendReU1uSEU3aG5IOEg4dXJF?=
 =?utf-8?B?WjhqZXp6c2dJL05vV3Q0L1RPdlVXdytnRVdXOXFyZGFVNUNobGp6N0cveG1P?=
 =?utf-8?B?eU5yR29HZFcrTlk3Uyt4TEZuNWNNaHp5V1BMYXpWcXIyb0VQYXk3ekE3dWlL?=
 =?utf-8?B?L0VDbXBEUmNta214NW9kMWY5c1U5eHQ1UEhRTCtGcS9LZ09hand5TnJ3ajNh?=
 =?utf-8?B?N1FQQTErUHRrbTJCcTdBV1Nnd0cvK05FdEpDSXZidjc4Z2pCaVMzUThkclhK?=
 =?utf-8?B?bmRPcWFYNlJDeFd6dERvODJjV09saXVkNWpOai9seEczSWRZektLTVdTR04x?=
 =?utf-8?B?MkVBYXFSNXdwTkhJNFhTZVlSZStuenFBTnhWaDJwbzdQSGR3ZmJKcytseEZr?=
 =?utf-8?B?L0wxMjI1c0MxbU5TUG93NGhmY0pSTnRxcU5GUFNScFdQeFpjVlFISDFlTjd2?=
 =?utf-8?B?NkxzMVdrWG9aSDI4UE4vOVBPcjY4MXlQZHJaVzNVRndsQWtRZzhDQ3R6dzR6?=
 =?utf-8?B?NVBYSXN0V3hGMjcwNEI2RklSbE12bHhlWmxJRko2WHhBaXdENUlVcWVRUkVm?=
 =?utf-8?B?eU5weVUxYWRRcG03NUFOV0VQVEV5WkFxdlZaUng1eVRaRmcvVDVGVCtqK3d6?=
 =?utf-8?B?QThLczdhaHRBVUw2b1dqQm1hUFdrZGdidWZibnJtd1hmU09iaEl5TnQ5eXhK?=
 =?utf-8?B?Q0tRVlJBMFRIT0tXek0rdjIzbXhCM2Rva1A0aHBGK0s3cDBLN0owbks4dFNC?=
 =?utf-8?B?VjdXY0RGNWc2NzM4QTkvKzg0SVo3dEVNMFVWcCs0RUhaeDZ6QlBDRkdTL3Ix?=
 =?utf-8?B?ajlxNkVYcklxYmN1NTJlSG94d29zbnJTRGhodEF0L2Rlc2FtUDh4aGhQR0Er?=
 =?utf-8?B?aFIxbzFvRXZxekpBQldJTjhvUThtL3hCcnRkOXhnVDZDWWN2QkxsWWN6OXpp?=
 =?utf-8?B?akhoWW9KSGtleVAxUVB2YjlxNUd6akh1NDRCeHhMVFVZWEw1b00yY2Joaml3?=
 =?utf-8?B?QXpmYXlkbllFOS9oSjgrdFdjK2E4eFJWdHlGbjRtRjVWVStpMFB6cFdxWTh1?=
 =?utf-8?Q?AFLV0KuoE+k=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5328.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?N1pNVXlOQ1RMS3J5UVJ2SGdNOFBRTnpmUVFpVUlja3Q2dEhxN1VidytTUEdt?=
 =?utf-8?B?bXhpR3BVOXMxbFNNblRDRmZSQXZJMHdCMVZncEJqN3JyYkM3cis5ck13SW9q?=
 =?utf-8?B?cnM1Nk42QzVvcHNwT0NTaWxMWmxjQzZNbEZSMm1McmFJTG5MUGtNS1BobTY1?=
 =?utf-8?B?S2V4ZG4yc29FL0hGR1daaGUzdHdyMWhuL1dqcU1OaTRnOWNIZ20wR0tFWlNE?=
 =?utf-8?B?VDZqOHp1WCtkclFuK0JkTFh6cFpQMmMzUHFSbVA4ZzM5aVc4cDJTb3VJNzhy?=
 =?utf-8?B?a1gxZEcza1JIa280QVZkTVNNWHJoeGlsWTZFa0hXTEpuUU05UmxtczY2ZGNw?=
 =?utf-8?B?V2M5QjFYbHh6SFZRVUxnY3Q2U0tycUxmSmdvNmFLYkVWcitLczhYUWxQNkh5?=
 =?utf-8?B?M2htOFR1MzB3TEZ0K1FKSk9IZTBINDFraG5NSTk0aHpXclpEa2haQm85MUwy?=
 =?utf-8?B?bHBzMUlqcnlXTEs1bHJSRlZUTjYvU29QOTBGd3FCTnNUc25zdUhYbjRzamdy?=
 =?utf-8?B?dUtNcVVtZE1GMkdMZDZPdE9SWXNnRzVWQk8ybTljd3VMRG1sUmIyOThUcGlE?=
 =?utf-8?B?aU1JUVRXKzhsWWhsaUdKRG9wWWxxQ1lML1dqVWlWbS9kZ2V4Zm83eUFSVTAv?=
 =?utf-8?B?SzU5Q2gzMFc0VWhwVFlWRnp6SjRXTjdIdDF2cEhqTUg3UjE1eHF3V0pKOVdH?=
 =?utf-8?B?S2xJMlJVa1JrVmtxQSt3bXN6NTAvTzlMQW5ZMlVaZlk4aDBUKzBkWWUxaERo?=
 =?utf-8?B?ZFhvRjEyZEo0NXNhcU9CUGVONWdqWUc2Z09Ick0vN0o5YldaY1lmWFVGaWtr?=
 =?utf-8?B?NHVxZGYxdi9HUXh4cHlMdXA5ckVpV05pWWVmRnZlL25FNGZueXdHRFR4d2ZF?=
 =?utf-8?B?Qm9KWE5iVTduZStqaE12SzY1ZmVPc2Q2a1JqZnRSQlcxcDZJVkI0c282dHd3?=
 =?utf-8?B?UHR0VnFxUkdDUVhjMHU0MXJyZEovRkx3cmNYcWpVRC9lUXhrREpuaFpIMlNM?=
 =?utf-8?B?ZHcxNHBidk5UeXd5Z2V0TW12L2JFalJwR0lxOG5pWi8va2M3bHJERm1LK1Uw?=
 =?utf-8?B?c1hMbWdvTzE2OFRHektacnlOcWw0eEdXSVBvTG9Eak5EUW9Ucmc5SzdzRTVJ?=
 =?utf-8?B?MjJuYmNJUEE3bTJ5Rjlodk1SYVdVaE10OU9XSnc4M1pLK1U4a2Y1ZlhFS1JK?=
 =?utf-8?B?aWh0dU1mUExjK2h5TGNueG9sYis2VWZUTFlzQS9ENlFNZ0RkaUdlUmNoL1FW?=
 =?utf-8?B?M0pLNXJLQ1R6R3BkR0doRVU2T0hvOHBTK2hwcmxvamdwWjVnYzJLWVIzYm9H?=
 =?utf-8?B?K3RXMDBnTklYelVLUDV3c3R1RFVUdEl6a0ljRlZTbWl0YkgyMTdEbGQ1OUNu?=
 =?utf-8?B?eXRvbG9mNTNubFR5Rk45ME5aZk81cTU0L3lDZktqbk9ibnpZbmNnLy95bkVm?=
 =?utf-8?B?K0RWN0R2UHJLZ002dFB0ZWVpZDdtcGNPMUxxS1RTTG13Q2ZHYkVLMHM2MnpC?=
 =?utf-8?B?dmtxQ2Ztb2N5TTBJSkFlYysweXlPdkZBcVBEV2IweWdQY2hadTl4cjZtekxi?=
 =?utf-8?B?S2drUmdyRjBHcnJqbEtkSm0rQVg4Z04zM0RubWtiRnNhaHpSOVZaam5SSDFC?=
 =?utf-8?B?d2NJdytCZENGaUs0Ky9ZQW5BYW9uZjRFMmVnOVFud0tLVFBYZWJwY0huQ3pW?=
 =?utf-8?B?NVFEblJaY0IvZ2Z3OWdkbU41T2xPYlpRQUJzaEVJU2IxUkdHZDB5NVJDdUhq?=
 =?utf-8?B?YnczcUNzVFlwODg5TmV1VGY2bE45Uzh1ejdQM2krZVF0eVFRcFZLcHFMeEtV?=
 =?utf-8?B?T1RzZUlqRjNqRlRjMExmakFjTXFMSkNuNVNRZ2tsQlMyeG1rZ2EzUGpFSGhk?=
 =?utf-8?B?VGh0UGxYaTFGTVNhRU1ubVdaUWhRM2JTYlNua0xhTll5ZUZOQXJXQ3l6WUww?=
 =?utf-8?B?M2ZrV1BaaWNRaFFrdVd1ME5QY040UEJoK0pPcm9XYUR5YlRqWnlkMm5GTTBi?=
 =?utf-8?B?TUpHVzQ2UFo1eTlkS04xUFVEQlVYa1pNd3VCWTcybVRnVWJnUmxwUVFNSTVH?=
 =?utf-8?B?QitHMVJ3QjE0NkorVmx2YmVtSjkzeSs1bjNYcUtPLy9RdXpUWVYxTVA4NHl6?=
 =?utf-8?B?dGZlcmlSYWVLRHdQUG1Qa0JZb2JLMWJwRmVNaUtNOXBxdTMzaWVRWnU2b1BQ?=
 =?utf-8?B?UGc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	dKsb4bg1P2eyTLokvOEZ1HbuSirtj80tQkI8Z4hZD3j/Yyg92jk3vYIH3+SkgOsrd12OuqIETcAnc/6X6QeyJKrKxMbDI528QboZ7Qleko8uenxPfFb7bVwJkx3gQ+p+TFTuL24USrZCJH4uI5DktDUeLwv8lvlmnPgaH6GdQogJ09u5KJlxc0YOMmz9PEUmWRjXR+TLBvqBkjvuqsMxyXzd6sbyVgDAzGBU5iW6NljOpqkcd5Fbf8DsIQm2mnFgyWz3+VNmvDvFLXkvqYYtA9NPk6NIq3ihdfa9RXcwrdXFTkmpkRt3ye2Kf1LSpQxhbqWJifrtm58ivdkmwum0Lg/l3c6CC7wq6N7EgUrNJn/AtS7jfyNY8QyHybx/Os6enJPJ7qSJtsoNijjgdbHa80mTdwK4NtCDdceD+i12a5+958tGOaXgXV+xCJu4NfB8mpvlJRpWfZ+RA3M4cw3S9KoTTxJtb8kqx/VnL6gLj9tz+unIPgxT4POguso9sCcebW1Ek7CzHwnFjdXU2Z5KDrbfLTZS39UqlrhW4RxCR51IeHJ6EwS11wf0YbW+e9ElR/FJDkdwy2nt1aeFwM/I3Hj8cTdglUGBiy9FGRGhDZQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b907c6e-1e4e-40dc-8086-08ddeed894d3
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5328.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2025 13:06:53.6459
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NF5ibwl4gEbI1q/ydyq/ZBSf5dNth/sOwiG3KZXV1wWqrShU2tZ/oGzTEbklBEbttwsNUsCLBr9zjXu9GI/qAjniFH/AJHP20dOnXJkx8gQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB4936
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-08_04,2025-09-08_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 suspectscore=0
 bulkscore=0 mlxscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509080131
X-Proofpoint-ORIG-GUID: n4Ohb73MeuTmAnM5wBkNkOwDTIbxYpCq
X-Authority-Analysis: v=2.4 cv=ILACChvG c=1 sm=1 tr=0 ts=68bed4f1 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=yEagc-ZzJlukW6ZPOxwA:9
 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12069
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA4MDEyNCBTYWx0ZWRfX7CwW16T977gu
 TFh2KzRgYUS5LR6A4vx8TVijZDaMk7GX+gnvmm1oDq7HS60qLseyJLRpmIk7dUnf/UmaQQeDpju
 WeqBvODdLOoysrVXyoqrD/IvvDZUYncSIx1aVJQggG7X3na5td0JcJdTwAKoIZD7aFEgy8owgKB
 6Ksv0cpXAlMLS4YEdC8hX/fHXrAu8mb+Ji7RhXskJ79R9++T5P45pb0zSkKfspWLWUkn244xEFj
 ncsRLgVQTLiAdBIfiY5tAoD3g/ENd2ELgjd6oZL1kgBsA3V5f8KoQSi71k7ZLBuvrF6q4uEAoUV
 tC0tUrDL1lWjDs5Gony/NTO+Y7w7J4970fh25y/L1evly+84lslsxBvo64iFS9PBRsUKlj7FC5z
 VV6QkeMipzklhodpBE1QXri1sbJ+CQ==
X-Proofpoint-GUID: n4Ohb73MeuTmAnM5wBkNkOwDTIbxYpCq



On 9/8/2025 1:46 PM, Marc Zyngier wrote:
>> diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
>> index f5148b38120a..c74d6120a12c 100644
>> --- a/arch/arm64/kvm/vgic/vgic.c
>> +++ b/arch/arm64/kvm/vgic/vgic.c
>> @@ -818,7 +818,7 @@ static void vgic_flush_lr_state(struct kvm_vcpu *vcpu)
>>   		 * the AP list has been sorted already.
>>   		 */
>>   		if (multi_sgi && irq->priority > prio) {
>> -			_raw_spin_unlock(&irq->irq_lock);
>> +			raw_spin_unlock(&irq->irq_lock);
>>   			break;
>>   		}
>>   
> With the above fixed:
> 
> Acked-by: Marc Zyngier<maz@kernel.org>


Thanks Marc, I will send v2 with your suggestions.

Thanks,
Alok
