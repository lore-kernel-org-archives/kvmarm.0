Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013018.outbound.protection.outlook.com [52.101.83.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A74FD335563
	for <kvmarm@lists.linux.dev>; Fri, 31 Oct 2025 10:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.83.18
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761905366; cv=fail; b=PnRi1CBIcW1UQT/qUueNf3T4GE9AWINrGJP8wqTviolRUmQPUfWUo4g6L3lMrt4BRYU4ziwZbpUMQ6zHFXGw05oVoKg0eezMmtBWWUzJ4f6aGJnFW+skl4NXxHSPCop6Rmi+yUC3eTP5nzRWrYdiCVX3i1se59dbP8cwBwlH628=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761905366; c=relaxed/simple;
	bh=vmNX1wFNUOlUigeDX3ossihzCDj81NNQWLW8jx5k2VQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=h6tdGeForDonffCPEDPyiRD6Ikkj1ChksJrh6m0dlt+7DcYxnl/TmzhKbt5cH1fHr4GL2QlOO+OwYDjGfpzVpu6/yhw75DyTO42qWvX9AtkwlPECqmbEm/1lT0aZ46cnQr003dGCa5k741ARm3AOwaZNtRDHzNaCv6oh/6I1QOc=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Wq8w6nMD; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Wq8w6nMD; arc=fail smtp.client-ip=52.101.83.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Wq8w6nMD";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Wq8w6nMD"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=Kk0tuvLk6mqIvVCfkIe2OG5pyV3B+3mXeA9TL0pOZ/r6szEe4T3J71FB3gRZMvElYWPxz4Vbja2SPgFxCVc3fWtuFL/uSPvd4Z4LYJWb0SsSOsYWEM2bIRCJhSZU+UHvNjDzXFta3yUWGpFlEKl/ZMTsvLZ7xgztm93VJiFPVpFQ+wV3Zjwc7opd4vlJ6xbDFDyzsv2HmuV6FCrhn7xeBbRoXUvQgdfBY69KyirJZSQlYfovkGK/7j34fj90yk8gyl0c7qUd5U0WDYkDelaO25wamQPP9iDsE4wHtq9pgi5KGE7+K51ht3EGoBc7OnJExEfyuGxHNEW6St9dy3o+Fw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NDo1HdIgtgzOI9rcAevWeDsD5aHIZT2J/lFerKY2z+Q=;
 b=iSTxhg1pxhQGdxbmjOo4JIdtG1RarvGe1SUn8yY9DLx9L+ZPNZ507Bss3RJ55h4n1TK2TAFnYmsUvGQw+tFschexzWRKlsFQBreoEwBjZhJ6EG4amzdoQq1pX8Au6la5mrMIwDBbTIuzxwuHPO6NQApAVaAyzh0t0uCKr5++iFrvCyittSIrc5SvX42Lwkcm9Uzq1Hbttr/E3Edz+wt2r8hTTrVQ80El3u43TR4YvAOWZ8EUMISYqSWl+5BQNrVyHtjROV7KYyYXzFg9x0I8sP//hzxQ/rXXdLx3HQS+jaUp+FgfpHPWoEforLJM6Nv0ptPfdO0ZbTTQGiUgL+1w8Q==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=google.com smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NDo1HdIgtgzOI9rcAevWeDsD5aHIZT2J/lFerKY2z+Q=;
 b=Wq8w6nMDKZvIvC/CiRWrui9x+y1PMwXGl71JkXTLJiG++BnUSs3Tik/KzJqnPAY2vO6wq8mAyzY0C8h33TL+cKZDhCcNrB2fw1ORY83uyL+XQkDGPgHpGk8WYwneV0+ymwpur6+6FOrY4TxoOuFfeImRMDh6qBOa8QaBcJAWvaM=
Received: from CWLP123CA0175.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:19b::13)
 by DBBPR08MB6284.eurprd08.prod.outlook.com (2603:10a6:10:20e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.17; Fri, 31 Oct
 2025 10:09:16 +0000
Received: from AM2PEPF0001C712.eurprd05.prod.outlook.com
 (2603:10a6:400:19b:cafe::71) by CWLP123CA0175.outlook.office365.com
 (2603:10a6:400:19b::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9275.15 via Frontend Transport; Fri,
 31 Oct 2025 10:09:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM2PEPF0001C712.mail.protection.outlook.com (10.167.16.182) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9275.10
 via Frontend Transport; Fri, 31 Oct 2025 10:09:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vvNN9DxiuXsZC427XyakVLFr/7STN7QuVUVkOkjKB9SGtuKg8q5G1BLSTbvzfnQUB1L5JD5/dLDN2qEcjCshqoGcLZWtv1Bmkh26Q5lx/A+MHDhk7Gihv6zw78506zZp96Iqd7mt0gryOMiWrdtU2+mi1XCB68D4Wo/J8zyoV3smIKaxNLx1Ah0B5TGJ/FVq6+/Xg6LoLBMCxmQ8b/bk+xVnpcmDl10tU+SQJh+Xcb08MZtt1ud3l+K7g4m7Gp4G8ja6eTvXI39O1urg9bB2u9phWFMnolzYvo6zvh94sgbCcdoB7wANpnZWDCsGk5iQoZ2Z40aS72WHEKnIODIXpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NDo1HdIgtgzOI9rcAevWeDsD5aHIZT2J/lFerKY2z+Q=;
 b=YZ2cAXCbsTj2zfnl+HGXoy9lZiSyBHylsygY1qQixpTjeM7thnSUI8wXQsIhs5B5XNCrlLOSuxzgeB6b+OD28btP1mhMxpzzGTneu4Q/Ds0FMXBuaRaiLS+l5bkV/qQJmC11RoSy3XBWT4h3pYMSPcyPdPauOhNgRByi4le1T6ElZP5Tn1wfbFjSht65AWmxoAZhWpHXeqoBrN2nw6xD4YlV2TwaasO5VeLHR4KYd2VoBOo5zOLDpW86dltnS+7SNCNQkrToSoeVMZR+WjWbMXVqy0C/ru05vr+dzBpgCJm35McrVnijOB88wGkcyrfTDvMonPqLebeKukTRn1vkeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NDo1HdIgtgzOI9rcAevWeDsD5aHIZT2J/lFerKY2z+Q=;
 b=Wq8w6nMDKZvIvC/CiRWrui9x+y1PMwXGl71JkXTLJiG++BnUSs3Tik/KzJqnPAY2vO6wq8mAyzY0C8h33TL+cKZDhCcNrB2fw1ORY83uyL+XQkDGPgHpGk8WYwneV0+ymwpur6+6FOrY4TxoOuFfeImRMDh6qBOa8QaBcJAWvaM=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20) by DB9PR08MB9540.eurprd08.prod.outlook.com
 (2603:10a6:10:451::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.13; Fri, 31 Oct
 2025 10:08:42 +0000
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739]) by GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739%3]) with mapi id 15.20.9275.013; Fri, 31 Oct 2025
 10:08:41 +0000
Date: Fri, 31 Oct 2025 10:08:37 +0000
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Sebastian Ene <sebastianene@google.com>
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, perlarsen@google.com,
	ayrton@google.com, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] KVM: arm64: fix FF-A call failure when ff-a driver
 is built-in
Message-ID: <aQSKpZDrLzf/bcx7@e129823.arm.com>
References: <20251027191729.1704744-1-yeoreum.yun@arm.com>
 <20251027191729.1704744-2-yeoreum.yun@arm.com>
 <aQRuvu8V3woqnqCV@google.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aQRuvu8V3woqnqCV@google.com>
X-ClientProxiedBy: LO4P123CA0606.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:314::14) To GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	GV1PR08MB10521:EE_|DB9PR08MB9540:EE_|AM2PEPF0001C712:EE_|DBBPR08MB6284:EE_
X-MS-Office365-Filtering-Correlation-Id: 506799e2-13b5-4c65-316c-08de18658be9
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?UytsUzJ2TUZzQm9rd1FPeEJoUndsZ3ltSmlpZFNMd1VOdjBHTEM2bFgwWlZE?=
 =?utf-8?B?dGZ6RTdON0ZlQXZaZXdMcVdGcGtEVWxjS2Y2YTJmbmVxR1hHQjlTZVg4Tmsy?=
 =?utf-8?B?dWxsYW5LMUFnbzFsMUFqZjFFK04yTnVBd2cyRmJMSDZ5NzRYQ1RiaGxieitC?=
 =?utf-8?B?VmNweHl5ZkZJMWpIZWFjeUdVaEo4a0NSUXNsZmpib2RPRWJvYVhNTlE5SDFE?=
 =?utf-8?B?djFMSk5rQnZGVmNQN0N6M2FvbDNkY2YyNmdjdW51MDNPN29YeGNOQnY3NDNs?=
 =?utf-8?B?NUNzV1dwd2RnczcyMFJDejN4a0VMck5hM1lZK0dzYVdnSXUxalBlRnF2b21t?=
 =?utf-8?B?R05EZnY5S2NvRk91OTV6ZzVjcEtDajZxZGs5Y2VYcjdjOWNCekpkMDBOV09j?=
 =?utf-8?B?U0ozYjBZakNHZGdGV01oYk9JRTJkWUFBUm5ka3J1MHQyRnp6bkZ6TlRoQVFn?=
 =?utf-8?B?bmN3T0lkZW5nTmdFRytVSTRGSjdSYTdGVjhoOWQ1VHZBT1JMN1FWWEJ6TjM3?=
 =?utf-8?B?aW9aTzRWUzc2T0NidE5weTdSc3ZoeWxmdlRFMngrQ0pxdEtwRE9oT3ptSTF2?=
 =?utf-8?B?cERkYVlFSE9CcTdSclNqYUVuc2N4ZjVqc3NqT2hWZTIrbzJPZTJTaTNBWWd3?=
 =?utf-8?B?TWVxMTBhVVJJZ0Z3bitZa3Roc01XUElOZ1BxeXRHcjhTWXo3TFNSMzZsdXFC?=
 =?utf-8?B?VUJiK0VUR3BQNEhpdThrNFQxNUVLWlJqQkkwK25ZK3oxUDRVUlQ3bTA2TWh5?=
 =?utf-8?B?N0tDVS9hVU43UFRnY2o0Tkpveko2S0ppaWdSR1ZjNG85SS8xeVJQYUVWbWZZ?=
 =?utf-8?B?V1NCZUZDdE1TSjBRTEFUNlgxUHZ3YmJmU0NVU09hT3FXcExwd2o2bGVjT0Vv?=
 =?utf-8?B?aEpMVFBqbERUVVJwdkhDaDVBRGc1Tjh5LzNvbFo2NmI0eW5qOHFLYUtjTTQx?=
 =?utf-8?B?cXRXWVRGM2VRMmlBSHEyV0dya0hIS2ZyMEtodzlQS1pJd2tYd0xXbktlQkQ2?=
 =?utf-8?B?SWJuQWh2UWt2OThqVEJLV0lsSkROYmh3N2lqSzZSVy9VNTExK2k3UGZTSkRB?=
 =?utf-8?B?YTBSUStHODBpd1I3ak9XTjI1V09iQWp2cFJJMmlOdXp2U0M0SVNGZU8wYmFZ?=
 =?utf-8?B?ZExMd1dlZ2d0SlVDOGk0Um5TM0h4N1dPdjNyZUF4Q3FHSGJ4U2Q5UEgzaXVn?=
 =?utf-8?B?cC9oVGlLNG11Q1BESUh5TWxSNlNWb1RvSGFRcjZkdlVaNkpiYXBMODEzd0kz?=
 =?utf-8?B?N01vSnhSVXBtQ1BDYW5wTit1MW1UbitleTVpMGpONHZjS3pKTUZyUUdBc2Fm?=
 =?utf-8?B?WThhbVlvTm13bU9pLzdYS0JoNUZlTkg5RGJYVFJUVXJ1SU1sWG44amhEVHZO?=
 =?utf-8?B?VE5JeGFWdGthTmNyQmM2M3orNGZraUladXhKeGVkMS83MmZVeXdDeTdkbTlm?=
 =?utf-8?B?Zjk0RDBEdWl1TjlPbmEyUTNKbkpWMVhFM1o2N1BJVHJJbzBoOEpPc1lYMThk?=
 =?utf-8?B?MnBaWndDTFJhNU1zZnlmVlJQWk1QNHJCODBVMzRmajZKeFZpSWc5Zk1TNmFG?=
 =?utf-8?B?d0FPdmFYTlR0RDcvMys0Vjgxazg4MlVpV1VmRGxyUS8xYWd5TGFUT016UGhR?=
 =?utf-8?B?Y0JLOGJaem9MRGtSckVFTFVRK0wxRkVyK1VqTHlZR3E3d0hxNVB0NTRvVnpC?=
 =?utf-8?B?b2QyQnVWUk9DOElDdGJBSGUxeVdVdDNaV2x3V1NKYjdpaGF6UVp3Qjc2TFJo?=
 =?utf-8?B?b0JRdkdFTTBaSFd4QW8zNE1kaTlaOVdjcFhTaVJpSHNGaWFrYUlrV1RuYm9M?=
 =?utf-8?B?eWpobnVRTzlBS0NCNjJuUzBPemRSNFhtcFgxS0dSWDZBejd4YldhaTd2enk5?=
 =?utf-8?B?RmZYY0tEa0MzWXR3c0RxQ2NFMFBVL25BM201SnptcHhCMFF6RGVySG5OMUpS?=
 =?utf-8?B?V3NtZ3ZhazJjaUxFa3NvOUdhYnMyQXVYd09FK0VJR2ZiYWxkZDAzZjBXcDJM?=
 =?utf-8?B?dFIxT0ppc1hBPT0=?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB10521.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB9540
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM2PEPF0001C712.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	5e679d45-2c11-411d-2dd2-08de18657745
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|35042699022|7416014|1800799024|376014|82310400026|14060799003;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OFhNc1JManpmTDI0S2ZJR0ZlUE5CeUVJaTh5Z1BYRGQ3OExWZkJabzJRQlRw?=
 =?utf-8?B?Q2p3UjkyME9VREJYZSswL3MvelU4MTJIVzFyTGgzTEUvRHNXak0yWGJueVl6?=
 =?utf-8?B?T2xkK2hVelF0dS9sNmI4N0g0YTFJaFBZVWtuU3dBWGMxbTBsK1R2ODB6YUo3?=
 =?utf-8?B?ZzhQeEo3amxWTi82N0tlaDRQdUFtSUdCWVFPWWIxZWl1MytUR1JyTW9ueU44?=
 =?utf-8?B?NGxHNWFPVWdDTm4zVWhGdUZZRUYwM2t1RnlCdlIyUi9uV25NSXRZUCs5ZEY2?=
 =?utf-8?B?TWt0bU9xMjlleFp4MFlaNStORjhFa3RiSTNObkU1ZllmUmFoVDhZNDJsak1D?=
 =?utf-8?B?YzdnNGdpWmtiWTA3TWF4VnNRbGEwM3NjQ1NZU2t1TUZCeDZ2RTVPZ2IrcXBE?=
 =?utf-8?B?dWxCUkswUGZSTWE4SmdZQ09MUk03emNtNnNmcWR0VDhVTjJBT3JYL2QzVTVP?=
 =?utf-8?B?NlozQnM4dTVrZlhhc1ZQRzNmU2pHTEFWNzl1bHFYOVlxUnNiY2NoVnpUbVh2?=
 =?utf-8?B?ajcvNUFhVTVJR3hhR3VWU3FJMXBxaWtIMjhTY1VEdEVlc09acWx2aXpUVW5J?=
 =?utf-8?B?cml6TGgzcGhXaXcxMllHT0hJM1dCd04yNCtTZjMrWml6cGxNaTRxYm93THl6?=
 =?utf-8?B?OS9YczRBMVhvNzJPNW9CTC8zUzQ4NW5FT1ZiRHBGSXNwRWMzVDdabkNNVFpO?=
 =?utf-8?B?b3VLRnZhVnZGKy9aMG9VUEs0dVgvTFRNOUFjSm9QUVdUUFBwVmk5SkhmQjJx?=
 =?utf-8?B?KzZ6OGtTNzVtUWlxbEphVUlhaGNiWU1VOHFnMGk0Skloako1U0dEb2dMMnpF?=
 =?utf-8?B?VVNZaThXcVN4WnlLY2doa3U2dmhJUllDWVdYRzhrTlQvaTJIWUdpSldOdlc0?=
 =?utf-8?B?RUdqTE9nVHc3TmlObnRpcUdlZ3BYOUdONU5PaEI5TCtnSytmbDkwY3RXZjA3?=
 =?utf-8?B?YkVielFpejNmRU10Q1ZhbXFUaDBBMEhIMGV0bE9yenk5QWxIRjdQaWdER3Qz?=
 =?utf-8?B?MzN5VTllaEtDckdWMmdsNEdWL25ya2JhWkJrU1VzZTk1YlViZm5vTTlweDQ3?=
 =?utf-8?B?Qm5ZL0YwSE9LdWQvYmIzU3MxQUcwZlk4MDRwR0pRUWUzdzR0WEF1ak5jbWh5?=
 =?utf-8?B?UzFBdi9RSEM4TzBQYnlkeVk5RXU2L0x2TUdZWFR6TEtkb2h6TXRxL0FhNk9N?=
 =?utf-8?B?WkdIblhoU3l5THpNZmNyb0xFSXVyZGlGaHpFMit3d0JTamRtYWhkSzFIWGk4?=
 =?utf-8?B?T2JyTSt6dUUwcHptZ1k1anB2ZzA2Y25jT2psbytFSXJBajNackRnRHNUUU1p?=
 =?utf-8?B?RUJLVXRCVlZBVEVhYnVBMmtyK05XT2xBRlZ5L1RKV0wrNjdwK1VKREc5VzBG?=
 =?utf-8?B?dFhUaFNodjIxdmJlN0RIbHZtWUtYL3ltYTN4Wk1hdndGem90NHdzVjBOTjJM?=
 =?utf-8?B?eUsxS1BMV25STWpDVzI4MDBSZlpqeHo0Q3diL3FsT2M4blNOL0Z6d3oxQnNO?=
 =?utf-8?B?blUrN2VsZjQ2WkNiUlFNbW11TGF4amR3YzUwVU40NFVLSFZxWUliLzBKQzF5?=
 =?utf-8?B?R0xwdjQ2Z1BUanVmejl2VTdjMkg2WXEyNjZzM01FMWsvUGhoV3pTWGIyWlUy?=
 =?utf-8?B?NHFJV0FTSTNmRlNtN2VHT0I5VFY1aUxMRVQ2M2lma3VoU0MwanpLYUpyVFox?=
 =?utf-8?B?K0xydDYwOXZMWXBJRk51WHl6aFJFbjBLVkNhU0RGZllGWm5lMWlrYjc5cEdz?=
 =?utf-8?B?V3plU1hTRjBpRE1CTDE1VXBFaXdwaUM1SXFOaHBqNkNUMlNKVFRKSXM3UllU?=
 =?utf-8?B?Z2xBckV4cVlIVmFSSGF5NlpiUFBBYjZPWjk5bHdTcGg0WXhsWFg3M1V2NDlS?=
 =?utf-8?B?Zi9xOGdmbW03STg3VWgvZnJTdVJpWGZvYVRtVEhDTytTNjVmdE1CWDd4Q2Ey?=
 =?utf-8?B?Wmp1TFZ3R3Y1NGVjY1ZqYnVGWHRsOEdjRzBOQVdBUUhvRDkzakJ5cmR4SmhK?=
 =?utf-8?B?OXY0VDREYTZtQldybCt1UWRGZko1V0RwNkV0azRrTHVWa3hRcDFwZkw4K213?=
 =?utf-8?B?RTlheGJyNkF4bXk5WUw4ZjVMS0M1WjFlQnBwNFoxUko3MzZmZEJ6RG9sdFAv?=
 =?utf-8?Q?/Fr4=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(35042699022)(7416014)(1800799024)(376014)(82310400026)(14060799003);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2025 10:09:15.0287
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 506799e2-13b5-4c65-316c-08de18658be9
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM2PEPF0001C712.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR08MB6284

Hi Sebastian,

> > Until has_version_negotiated is set to true,
> > all FF-A function calls fail except FFA_VERSION.
> > The has_version_negotiated flag is set to true when
> > the first FFA_VERSION call is made after init_hyp_mode().
> >
> > This works fine when the FF-A driver is built as a module,
> > since ffa_init() is invoked after kvm_arm_init(), allowing do_ffa_version()
> > to set has_version_negotiated to true.
> >
> > However, when the FF-A driver is built-in (CONFIG_ARM_FFA_TRANSPORT=y),
> > all FF-A calls fail. This happens because ffa_init() runs before
> > kvm_arm_init() — the init level of ffa_init() is rootfs_initcall.
> > As a result, the hypervisor cannot set has_version_negotiated,
> > since the FFA_VERSION call made in ffa_init() does not trap to the hypervisor
> > (HCR_EL2.TSC is cleared before kvm_arm_init()).
> >
>
> I understand the reason behind the patch but this is problematic to have
> the builtin driver load before pKVM because the hypervisor would be
> un-aware of the host mapped buffers. (eg. the call from ffa_rxtx_map is
> not trapped because it is too early). Essentially, you will end up
> bypassing the hyp FF-A proxy which I think you will want to avoid.

Ah. I've overlooed the ffa_rxtx_map proxy.
But unfortunately, some of depndency with the driver using arm_ffa
driver, ffa_init() should be called first then other drivers' initcall
(usually, these kind of driver defines its one initcall with
device_initcall()) (i.e) https://lore.kernel.org/all/20250618102302.2379029-1-yeoreum.yun@arm.com/.

Though I arm_ffa driver provide an API getting mapped rx/tx buffer,
But this seems to reverse dependency -- kvm depends on arm_ffa driver.

I’ve been thinking about some possible solutions,
but in my narrow idea, valid solution is kvm_arm_init() as
subsys_initcall_sync() and call kvm_init() in module_init() like
attached modification.

Do you have any idea?

Thanks.

------<&--------

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 870953b4a8a7..44711f3c7e04 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -65,7 +65,7 @@ DECLARE_KVM_NVHE_PER_CPU(struct kvm_nvhe_init_params, kvm_init_params);

 DECLARE_KVM_NVHE_PER_CPU(struct kvm_cpu_context, kvm_hyp_ctxt);

-static bool vgic_present, kvm_arm_initialised;
+static bool vgic_present, in_hyp_mode, okvm_arm_early_initialised, kvm_arm_initialised;

 static DEFINE_PER_CPU(unsigned char, kvm_hyp_initialized);

@@ -2827,11 +2827,42 @@ void kvm_arch_irq_bypass_start(struct irq_bypass_consumer *cons)
        kvm_arm_resume_guest(irqfd->kvm);
 }

+static __init int kvm_arm_post_init(void)
+{
+       int err;
+
+       if (!kvm_arm_early_initialised)
+               return -ENODEV;
+
+       /*
+        * FIXME: Do something reasonable if kvm_init() fails after pKVM
+        * hypervisor protection is finalized.
+        */
+       err = kvm_init(sizeof(struct kvm_vcpu), 0, THIS_MODULE);
+       if (err) {
+               teardown_subsystems();
+               if (!in_hyp_mode)
+                       teardown_hyp_mode();
+               kvm_arm_vmid_alloc_free();
+               return err;
+       }
+
+       /*
+        * This should be called after initialization is done and failure isn't
+        * possible anymore.
+        */
+       if (!in_hyp_mode)
+               finalize_init_hyp_mode();
+
+       kvm_arm_initialised = true;
+       return 0;
+}
+
+
 /* Initialize Hyp-mode and memory mappings on all CPUs */
 static __init int kvm_arm_init(void)
 {
        int err;
-       bool in_hyp_mode;

        if (!is_hyp_mode_available()) {
                kvm_info("HYP mode not available\n");
@@ -2893,30 +2924,18 @@ static __init int kvm_arm_init(void)
                                     "h" : "n"),
                 cpus_have_final_cap(ARM64_HAS_NESTED_VIRT) ? "+NV2": "");

-       /*
-        * FIXME: Do something reasonable if kvm_init() fails after pKVM
-        * hypervisor protection is finalized.
-        */
-       err = kvm_init(sizeof(struct kvm_vcpu), 0, THIS_MODULE);
-       if (err)
-               goto out_subs;
-
-       /*
-        * This should be called after initialization is done and failure isn't
-        * possible anymore.
-        */
-       if (!in_hyp_mode)
-               finalize_init_hyp_mode();
-
-       kvm_arm_initialised = true;
+       kvm_arm_early_initialised = true;

-       return 0;
+#ifdef MODULE
+       err = kvm_arm_post_init();
+#endif
+       return err;

-out_subs:
-       teardown_subsystems();
 out_hyp:
-       if (!in_hyp_mode)
+       if (!in_hyp_mode) {
                teardown_hyp_mode();
+               in_hyp_mode = false;
+       }
 out_err:
        kvm_arm_vmid_alloc_free();
        return err;
@@ -2995,4 +3014,7 @@ enum kvm_mode kvm_get_mode(void)
        return kvm_mode;
 }

-module_init(kvm_arm_init);
+subsys_initcall_sync(kvm_arm_init);
+#ifndef MODULE
+module_init(kvm_arm_post_init);
+#endif

[...]

--
Sincerely,
Yeoreum Yun
