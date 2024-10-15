Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2088.outbound.protection.outlook.com [40.107.20.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 191831E32D0;
	Tue, 15 Oct 2024 09:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.20.88
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728986172; cv=fail; b=mDs0ioYjTBNsm32O51SA6uftg96V3x4St97kjyknNdHX2gR91qx302a4AYzfvqMUqSn2VO5CI6xrXS+VBS5lczni+T6eLgLkJBGKYOaBWlIZx/VrRAI6FigKw5/apkB9sgY3QLPioraQ8LzLfTznyNynej7nU8+grMrfhfYefCs=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728986172; c=relaxed/simple;
	bh=R1GPs8UE6POR+Nt294U4EhhKNyZsm0aQulrPqD3Vr/Q=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=EnltJCYFG6dBgSPAAS6dQw/D/VgFbi9tH1kC8ZNcPxQAbRoVJWHgIg5tp1rX35qFpzP0k5ADf24emJZSh1Ey7B6iQHa7QkQZ3RPViLFWF4Jcn6OO3yhgohvK2LOcIR6a75QJI6niqmKu/X8ePzr4qzBKwZ1A4OF5t7BpyK+w2og=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=pnhgSmBD; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=pnhgSmBD; arc=fail smtp.client-ip=40.107.20.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="pnhgSmBD";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="pnhgSmBD"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=xtZsTooySEXu+SLJn16QsfpWOUn8CrBERnDQm5TYf5mz6ZM68CYWPxlSBOyA+Wks7q+JqUiWV6FltrCxy8YM910WdcmeHJ+CUh7oFjTT7Nmt+8J9TLfbMkEZWzU37aKMyd2mDMixOvFcySRsEIpLDwesbVr2XD1Ljs8uIJIa11em35rJyNNLydqySxMyvCoQfllkjUIc+VGxKFizIV2VjTDPUIRV3F12Uc568YONL9cHCGzqoX+nKjopNm3s1+P8Ozm1pWxaGG/6T/96S/KFnTMfMdfTXEk88ZJu1UsM8BZ5CwIcE0V4QNQ/9/1RNjGULZe4Ey46buWZnu+9m/a7TQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fxo0034oQei77aEQA8eboxrK3kfTKT64TeU9b4BwAlA=;
 b=giiQZHnOznSTSSz//RewR2xmNiZZH6ageuKnjGKxdJHE0eWUsmdstUDGfIqjBWFEc3N4PbA/W22ZRDipO+5XLALTAU+1khOsieQwaEKtI76weoF0AT80ig4GrJCw8EMAegthR+I93tT5ZR7UnmffCpIa64virlTWdiEUwRag4gClpYkV3Q7NgkpXoAYsZtRCLAZGp47gj5vcR4xlM9He8hmLbsSBDveXlB/j0nZolHztcdH3P5yxYooxGXkjIPCFQzQSRX+XcSbxrF6v8ie60/DhI6bUZIcPCRGka0a7jl9zZk+k0ytUiFuVhtmE//P9zTW5I1ABSPF1pxKexzmq8g==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 63.35.35.123) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fxo0034oQei77aEQA8eboxrK3kfTKT64TeU9b4BwAlA=;
 b=pnhgSmBDaxdhQ+zDNwT3bNCFza1JIamKWb+1fdect8zdLLhRjYFJePeF0cngEE81baGm17+G67PWkg5SHW5rEWC/EhQreBeA3NPqTCNrRRiRRdZ4A0kT7AZ15R4KZb9sAbJsdVRm7oTB35qGVO7G9F8khTAvXHA2E713jCKMgqc=
Received: from DU2PR04CA0212.eurprd04.prod.outlook.com (2603:10a6:10:2b1::7)
 by GV1PR08MB8401.eurprd08.prod.outlook.com (2603:10a6:150:a6::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.18; Tue, 15 Oct
 2024 09:56:01 +0000
Received: from DU6PEPF0000B61F.eurprd02.prod.outlook.com
 (2603:10a6:10:2b1:cafe::84) by DU2PR04CA0212.outlook.office365.com
 (2603:10a6:10:2b1::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.27 via Frontend
 Transport; Tue, 15 Oct 2024 09:56:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
 pr=C
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DU6PEPF0000B61F.mail.protection.outlook.com (10.167.8.134) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8069.17
 via Frontend Transport; Tue, 15 Oct 2024 09:55:59 +0000
Received: ("Tessian outbound 5c9bb61b4476:v473"); Tue, 15 Oct 2024 09:55:59 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 1fe33367947a5308
X-TessianGatewayMetadata: 3awlzYEwt0DMe7+iprxZjrCQERfzQG8heXlNJnaWxbSqhWiQWGmcRG+jqQNoGy4pOa3JkH1ASWoODvJSyG5R2iRIhjkaOnZ8/1F08TXnLkBTiPN3+HCfQ66q4h90gVLbow8LFNkxUr2IE6wa0jCdz1O2HMxVX1iy5KFypGV1vCc=
X-CR-MTA-TID: 64aa7808
Received: from L5030f799defd.2
	by 64aa7808-outbound-1.mta.getcheckrecipient.com id 544C5CF6-6824-463A-81A5-5C4C3A0C76E3.1;
	Tue, 15 Oct 2024 09:55:48 +0000
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id L5030f799defd.2
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Tue, 15 Oct 2024 09:55:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=u7xgFIvTgKlbyRShrTo/HgeWy8/OK3K0wcAdmxTAD3MG4fbFnUkoeezoEQb4BIaUWNHtNVWnmc5CmTEktHyApJPLYBoJFwhg2F6SV6PUWyRgk0sS9OJTVZhcgJm2cc5bp23jvYRaD2ObivZJECf5rSv+Oiq+cSMB5qVM8xCmHaKP3h8vp2138JHa0TfKSCtDUY3M3KE5o0UkYHCvGgbudEJrb6bg5N5M3mEMLH5w5NyOO1TjEwxQu8E/ai/lRPUeo3WOKGKxQRhsgk9B44MkmXY8/npIIEhI+OjL4826RIgEiSFg5Olrv5j6cTFtDPpsiQROXIGyaXesSGtqGjc5VQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fxo0034oQei77aEQA8eboxrK3kfTKT64TeU9b4BwAlA=;
 b=TArszB6JuH5tDU0ujJrvsCXniCRIpcFOswC65PWXWRjk6aFuCV+iPcAc+H/ic7Ibgrni8kryhe6Ei7KtAoWVG0NtdQnafKhnl3pdZfkIdKjEoHeP0tWBCEDhX7sOUihH9Ld6sPUJJSIItz47el402xc6zWJ3tf1JCo8CJxAMDM2SmynTlGGH3h35ci1fHgZBXQeX7Ay5EKchXIUaAzXaLAd96A5TPAHKFVjTYi6Gc7ZUaOzZ9g2g7zRRluUhL50pIQ9WQdJ2sdJ53L0ypwQcfOysibSd8XFJp9XrSqGj0BIzTlk1jjTbIVwf0Ts84boMx+E2+a9XkSwERKKoJrVOPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fxo0034oQei77aEQA8eboxrK3kfTKT64TeU9b4BwAlA=;
 b=pnhgSmBDaxdhQ+zDNwT3bNCFza1JIamKWb+1fdect8zdLLhRjYFJePeF0cngEE81baGm17+G67PWkg5SHW5rEWC/EhQreBeA3NPqTCNrRRiRRdZ4A0kT7AZ15R4KZb9sAbJsdVRm7oTB35qGVO7G9F8khTAvXHA2E713jCKMgqc=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from GVXPR08MB7727.eurprd08.prod.outlook.com (2603:10a6:150:6b::6)
 by AS8PR08MB6293.eurprd08.prod.outlook.com (2603:10a6:20b:23e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.20; Tue, 15 Oct
 2024 09:55:45 +0000
Received: from GVXPR08MB7727.eurprd08.prod.outlook.com
 ([fe80::9672:63f7:61b8:5469]) by GVXPR08MB7727.eurprd08.prod.outlook.com
 ([fe80::9672:63f7:61b8:5469%7]) with mapi id 15.20.8048.020; Tue, 15 Oct 2024
 09:55:45 +0000
Message-ID: <0bb96cfd-8994-4a74-8ef2-fe5dcd5a1508@arm.com>
Date: Tue, 15 Oct 2024 10:55:41 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 11/11] arm64: Document Arm Confidential Compute
Content-Language: en-GB
To: Steven Price <steven.price@arm.com>,
 Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>, "Aneesh Kumar K . V"
 <aneesh.kumar@kernel.org>
References: <20241004144307.66199-1-steven.price@arm.com>
 <20241004144307.66199-12-steven.price@arm.com>
 <20241008110549.GA1058742@myrica>
 <846c43a8-9720-4dd5-b40a-73ec00b9a9a7@arm.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <846c43a8-9720-4dd5-b40a-73ec00b9a9a7@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0614.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:314::15) To GVXPR08MB7727.eurprd08.prod.outlook.com
 (2603:10a6:150:6b::6)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	GVXPR08MB7727:EE_|AS8PR08MB6293:EE_|DU6PEPF0000B61F:EE_|GV1PR08MB8401:EE_
X-MS-Office365-Filtering-Correlation-Id: 542ba75c-2097-4fd1-4cf5-08dcecff9288
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?UDdOOUVzMStYTitGTERWK3ZvT2d6YXJGZFlyNG9GdUZwcGFxTzlUYXg0blNs?=
 =?utf-8?B?UDM2T1ZKZFk0R015TU5qN1hXeWhDUkxSVzVhV3JkeGIxa0MrSmVpNXcrRlBh?=
 =?utf-8?B?Wmx5ejJLMU8yQXJVR0tVVmVwUDVyMFI1djdjWDFlS2Z0Z0xEZ3FGWkVKdlBK?=
 =?utf-8?B?SkxJclg3UGhGZVk5Tkd4bkFJcC9ZQ0Exc3BNUUJKWnNwSnBUdnZFYmdkbzky?=
 =?utf-8?B?WlNpb1RqL205aUVnWElOQXg0K1F1TFBmVnFLOW1NV1FvQTVOR2MxQmNSZk5u?=
 =?utf-8?B?R3BKb1k1RHhEZWk0L3pqNXhiVHJ1L2tFNVdqR21lZGxWV1BSdFdIbDFTT1lK?=
 =?utf-8?B?V256RDk2dkRrbjh4QS9HckxmVnZ1cEY2MmRySENpTDN5Q0F5TW9abktqL0pi?=
 =?utf-8?B?UkdaSEhNVlNLUjYrYUc1UGYyd2tiYVE5OXVHT2NndTdCK0MrU2ZVZ3Z6bkRU?=
 =?utf-8?B?ekRCUU0rc085dXFFTXpyV3o2Uk1SVjJrblBVOE1FNlUvZ1o0c1pHTGRzRHZN?=
 =?utf-8?B?bGpVUHRIbTM1dE4zNkxMTVh4L0JrWDMrdld5OEVHeThWSkFDMHM4Y3I3YlRx?=
 =?utf-8?B?Ri9LUU41LzMrTjlFNkhOc0xjNmxrRERicEdvSkcrb3BxbFJQeHp2TVlSOGww?=
 =?utf-8?B?d1dvUDRMUXBNWndReHNmUWd1MFQ4YTE3N0M0QlY1ZzhydDR6TU1ER2tMRXZE?=
 =?utf-8?B?ODMrMnA2ZStEYzdGblA2TjMxNFV3YTBuTEVEZ0xRWG9OK2N0bzdOL2xHd1RT?=
 =?utf-8?B?QTFaVGM2ckJOa2RIS1FKWjZqY1lpL3lIR29qM1BxckpteWVPNHNhK2Zwa0hj?=
 =?utf-8?B?RWFjSlRYa205QW1zcit0ZTVZNjJ1R2xwUWNoankwVERzUmU5VGJOM1I3ZWtE?=
 =?utf-8?B?OUFSN0dOa3VxTlR1VXl3Q1pYalNmc2kxRGR6b0w2aXhRSmVYYm1GS1ZyVTh5?=
 =?utf-8?B?NFhoYkI3cmNDcitOOTViN3BvOFl3WXZuNSsrZk9jMFgzTk5Ibzc0QTNaSWNI?=
 =?utf-8?B?NjFEWStaN0lhd0doSWxyeUFHelZqU0l1MzduQStxZTkwR1FoSWl5a3plMktn?=
 =?utf-8?B?dlZ0TXI3SVl6VnFvMW1QTisxMTkvQTJaNUJ6L2k5VnN6SVU4QndVMUFMSDdo?=
 =?utf-8?B?RkxLekpFY3JxRVJSci83WEhrRWJFdnlWTEptRXZWZklHUWRRV0hDZjVOMkNi?=
 =?utf-8?B?QytNeXVhM01DSWdlZG9lZ05YU294MkYvY1NuOWlPNTZrWElGNU9LOXBGYW1B?=
 =?utf-8?B?VVhkUzI4UHBoMkx5Nklaelp1cjM1ZWViOTRpR3FaZjBvWWl4aGlRL3ZSaHJ6?=
 =?utf-8?B?NmMrQUhuekRrQ2VObHIxcGRodFNldGVUNjdZWTRSRGJURC9YZnl1b0JRYXRS?=
 =?utf-8?B?S2hvQ2ZEcDN1V1ovRFVkd0o1UnptdE1NdGdTaVpPeFdITzF1T3VJcWpvUy9t?=
 =?utf-8?B?L1RpUk1zNmhPT2pDRytwb1RzL0NZajVVWU9jaGhmS2srZTJrU1EvLzE2NnVk?=
 =?utf-8?B?QUVPaXN0TGplZjh0ZFpaT01LN2M2SWhwU0ttUE8rVzdyT0NvSWltb2kyenhL?=
 =?utf-8?B?aE9tWTJKL3hNV2RLb1NNVVdIMGc4eUwzYnZVdmhudHdxSS9aU0pwTitjRDVu?=
 =?utf-8?B?NVdKdTZBbnpNR1ozdHkwMDBFNzROUmgyS29SbXhKMXZpaEVURlJzR3E5S2Jw?=
 =?utf-8?B?UDZtd2pVN1NUTFVFRUMwbDJsWS9OcUFHZUE4Tms1YTdYT1NKU3F2WklRPT0=?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GVXPR08MB7727.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB6293
Original-Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-SkipListedInternetSender:
 ip=[2603:10a6:150:6b::6];domain=GVXPR08MB7727.eurprd08.prod.outlook.com
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU6PEPF0000B61F.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	35582aeb-555b-425a-0e4a-08dcecff8988
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700013|82310400026|35042699022|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?S3JNdDBEM2taMjV0blhxek5RUWxMcEd0SlFGb1c4Tkh5ejhWUTZMSDJORWpI?=
 =?utf-8?B?c1U2Y1VlM3d0ajJySHg1Y3lGbEpqNmZ4VHVWVjc0NkxaOGtiM3N2K0NXbnFP?=
 =?utf-8?B?VEZZdElDMGQrTDRLNnVyTHA0dDZvL2dQMUo2RHo1QU44dURzMGZOcTJiMHlX?=
 =?utf-8?B?RXNqVUN6S1lNZWExaXpGK3BNdWhaR29xUFdPWjdlL2tyb3JocU1BRC9DbTNX?=
 =?utf-8?B?RThpS1VoaDdUZzRFZG9XTWpILzJDQkxxb0FhWVN5R1UzbExGVWdkS1d6ODhY?=
 =?utf-8?B?MVExR1V5b2VKeG9uWU1tVEtDU3ZEVkppdEduek9ibHYrRGFzWS9xMWs1dUtH?=
 =?utf-8?B?TDIxL0FkYTREb2hiUkZ2UWZ5Vi9vSkdLK1NTaU1ibkdtdmZIc2JzYWxKc2p0?=
 =?utf-8?B?bUFHNUcvVUMweFJqMTR3SmNkYUNSK3R6M0N2bndJVHhwbC95Nk9OVEZuOTYr?=
 =?utf-8?B?bjN1NDI5VW45anF3eGxrQ2YyNFBiS09HODI2VXNhendQVC9Qa3RtaXRvWTkr?=
 =?utf-8?B?VzhnNGJ5cmdPb0VUeU1WczBDWUNnQ29jM3dibDdyV1kvTTBQUE1oOVVSeVJi?=
 =?utf-8?B?Vko1NTNCODlEYkNsSXZmeWhxcTljY1htczgrNTRpcFJRK25GaU9QRDlZcXNS?=
 =?utf-8?B?TElkckhHdXZZMFBlMW9KRm11cFlBRFlZTDBuaUF6d0VCY0RpOCt0aHR4VzhP?=
 =?utf-8?B?d2NGbUVGMWFwYW9PeXY3QUswZ0xYMklOR1JPeHFtcFBmMVRCdzMwZkY1Y0xT?=
 =?utf-8?B?ZU9ZbnBTKzB5WC9QUC8vT3dzRHZlOENSOFV1REw5WU94bjdnTjVHclF0Si83?=
 =?utf-8?B?MUZYTExPUVYvYzBCSTBMdnlkRDBDMGcxc1FZSXpPaE1RNnNxYVkxVGUxQ05z?=
 =?utf-8?B?azQycjA1U1AzcTJzREYwUzhOZlh5NVkvc2h5eWtSRjVab1pZMERxbUUrT01L?=
 =?utf-8?B?NzRvQXYzeFhZMkVvTHM5RFNMVzRyOHFhd25OQzM5Q2dtc21ZK1BWMThJVkRk?=
 =?utf-8?B?bXJQZHlnMk9QbEJqVFF0a2oyYjA0NWFwY3RtQmtwYlBJZ2N0RmNmZjh1ZGE3?=
 =?utf-8?B?ZjZBdTNOUm5raE1hZHhWeHplZjVCS3d1eFVHUFNGOUlvUmhxSlBnUWEzZHJL?=
 =?utf-8?B?ZHN5S3kwbWYvVGM3VzZZMEcveUZSM2ExaUJYbVZ6S0ZwaG1MWjVtc3pCY3g1?=
 =?utf-8?B?VUFqSEZiQTFVTWF3QkNNSXFmVCtSY1plZlo1WjdQVXpzTVFoVGVqNHN2OFRJ?=
 =?utf-8?B?bmNzUm44RjMzNmZqQjhLcVhXRmcyTDNBck9MZlFkR3JKTXVPbjlqalhxcGNC?=
 =?utf-8?B?M2V5eGlSRkVLSGdSQVA0L3V5dzNESldDNG1SakpJOVhzV1A0emwzbkQxZ0xm?=
 =?utf-8?B?ZUN2SXg4VWIzOUVKZ2FVZEhEYkEyZzlDTjFUSDVPdXh2MVlHcWM1RlNyeFA3?=
 =?utf-8?B?QnlEQTU2SVg4WXRyenFmZlVBaEZHV05HQldCY05oK1U0TjBxYjFlYVNFV09p?=
 =?utf-8?B?VmZqL3pGdkVWc0xkWHd2UDRIVGQ4bGh1dG5KeTZQMWpYNWJ1SEluVlc5Y0Zo?=
 =?utf-8?B?LzlGOThnNlJsbnlOL3hqOGdKc1pIOHpTZDRJNWNOS1YzQ0xwZm9ZL3dPKzFw?=
 =?utf-8?B?dS9hZ2FubGtaTnhIZVVrQ3NaQU4zNExxYVJnS3ZuM01FU1ZCT2tuME9aQWVU?=
 =?utf-8?B?dWhseDhWWWl6ekx2Y1dWRndiMkdDa0RWcTQ3amQ2NUYwb3VNOTlNN2t1QTNn?=
 =?utf-8?B?V0xlYUEyVSs5b2FYQmFLRGJKdU5EU3ppU0dmWlkySm9vNVJ5VnBXVGZFeTht?=
 =?utf-8?B?UnJhMzZPdFJrdUtGSGZVL2czMzBzeGVnM2ZGNVltZit6NXp2SjQwZW9XL05J?=
 =?utf-8?Q?F+Sumf40R1ju4?=
X-Forefront-Antispam-Report:
	CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(13230040)(376014)(36860700013)(82310400026)(35042699022)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2024 09:55:59.7739
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 542ba75c-2097-4fd1-4cf5-08dcecff9288
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU6PEPF0000B61F.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR08MB8401

On 11/10/2024 15:14, Steven Price wrote:
> On 08/10/2024 12:05, Jean-Philippe Brucker wrote:
>> On Fri, Oct 04, 2024 at 03:43:06PM +0100, Steven Price wrote:
>>> Add some documentation on Arm CCA and the requirements for running Linux
>>> as a Realm guest. Also update booting.rst to describe the requirement
>>> for RIPAS RAM.
>>>
>>> Signed-off-by: Steven Price <steven.price@arm.com>
>>> ---
>>>   Documentation/arch/arm64/arm-cca.rst | 67 ++++++++++++++++++++++++++++
>>>   Documentation/arch/arm64/booting.rst |  3 ++
>>>   Documentation/arch/arm64/index.rst   |  1 +
>>>   3 files changed, 71 insertions(+)
>>>   create mode 100644 Documentation/arch/arm64/arm-cca.rst
>>>
>>> diff --git a/Documentation/arch/arm64/arm-cca.rst b/Documentation/arch/arm64/arm-cca.rst
>>> new file mode 100644
>>> index 000000000000..ab7f90e64c2f
>>> --- /dev/null
>>> +++ b/Documentation/arch/arm64/arm-cca.rst
>>> @@ -0,0 +1,67 @@
>>> +.. SPDX-License-Identifier: GPL-2.0
>>> +
>>> +=====================================
>>> +Arm Confidential Compute Architecture
>>> +=====================================
>>> +
>>> +Arm systems that support the Realm Management Extension (RME) contain
>>> +hardware to allow a VM guest to be run in a way which protects the code
>>> +and data of the guest from the hypervisor. It extends the older "two
>>> +world" model (Normal and Secure World) into four worlds: Normal, Secure,
>>> +Root and Realm. Linux can then also be run as a guest to a monitor
>>> +running in the Realm world.
>>> +
>>> +The monitor running in the Realm world is known as the Realm Management
>>> +Monitor (RMM) and implements the Realm Management Monitor
>>> +specification[1]. The monitor acts a bit like a hypervisor (e.g. it runs
>>> +in EL2 and manages the stage 2 page tables etc of the guests running in
>>> +Realm world), however much of the control is handled by a hypervisor
>>> +running in the Normal World. The Normal World hypervisor uses the Realm
>>> +Management Interface (RMI) defined by the RMM specification to request
>>> +the RMM to perform operations (e.g. mapping memory or executing a vCPU).
>>> +
>>> +The RMM defines an environment for guests where the address space (IPA)
>>> +is split into two. The lower half is protected - any memory that is
>>> +mapped in this half cannot be seen by the Normal World and the RMM
>>> +restricts what operations the Normal World can perform on this memory
>>> +(e.g. the Normal World cannot replace pages in this region without the
>>> +guest's cooperation). The upper half is shared, the Normal World is free
>>> +to make changes to the pages in this region, and is able to emulate MMIO
>>> +devices in this region too.
>>> +
>>> +A guest running in a Realm may also communicate with the RMM to request
>>> +changes in its environment or to perform attestation about its
>>> +environment. In particular it may request that areas of the protected
>>> +address space are transitioned between 'RAM' and 'EMPTY' (in either
>>> +direction). This allows a Realm guest to give up memory to be returned
>>> +to the Normal World, or to request new memory from the Normal World.
>>> +Without an explicit request from the Realm guest the RMM will otherwise
>>> +prevent the Normal World from making these changes.
>>
>> We could mention that this interface is "RSI", so readers know what to
>> look for next
> 
> Good idea.
> 
>>> +
>>> +Linux as a Realm Guest
>>> +----------------------
>>> +
>>> +To run Linux as a guest within a Realm, the following must be provided
>>> +either by the VMM or by a `boot loader` run in the Realm before Linux:
>>> +
>>> + * All protected RAM described to Linux (by DT or ACPI) must be marked
>>> +   RIPAS RAM before handing over the Linux.
>>
>> "handing control over to Linux", or something like that?
> 
> Indeed that actually makes grammatical sense! ;)
> 
>>> +
>>> + * MMIO devices must be either unprotected (e.g. emulated by the Normal
>>> +   World) or marked RIPAS DEV.
>>> +
>>> + * MMIO devices emulated by the Normal World and used very early in boot
>>> +   (specifically earlycon) must be specified in the upper half of IPA.
>>> +   For earlycon this can be done by specifying the address on the
>>> +   command line, e.g.: ``earlycon=uart,mmio,0x101000000``
>>
>> This is going to be needed frequently, so maybe we should explain in a
>> little more detail how we come up with this value: "e.g. with an IPA size
>> of 33 and the base address of the emulated UART at 0x1000000,
>> ``earlycon=uart,mmio,0x101000000``"
>>
>> (Because the example IPA size is rather unintuitive and specific to the
>> kvmtool memory map)
> 

With the above addressed:

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>


