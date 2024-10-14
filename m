Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2073.outbound.protection.outlook.com [40.107.22.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C17291553B7;
	Mon, 14 Oct 2024 08:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.22.73
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728896194; cv=fail; b=foWJdHKlntccRvoa3knAZ90w/ogb1+PWQD9kQYY7dkX6CKUW4VYYHCBfbFKYThRTDOqBSoY4nOr7NAd+l8gaRJSeoUaNrKmn6r4796iEwtM8ycZz/IijiYWveNwXhb/e8GImstZCmKc2LQSzz45H2QjNH4Nak2zrU6tcydELcJI=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728896194; c=relaxed/simple;
	bh=2eoOI3q5LEDLsLx+6KrYEkKYva2Gf3F23zpdQFClKPg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ErdVPQPsUfsAiaj/ST24GzZaudb4SBRT2vClZ1eJE6kZmi8PgjESzuZS0Y8QNYIrrcc4Fb+PT+sTNm1aZczVCABeth3mTJyE/btCEE+tctRm35sgF0R+Y3EYqOk9eqU+z7sWJnTr/MtcWJeFQlEWGoVZAOhD/1zgYWapJdUiyNo=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=rqMJRPT5; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=rqMJRPT5; arc=fail smtp.client-ip=40.107.22.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="rqMJRPT5";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="rqMJRPT5"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=r9ZvGWmCLvOl4zr7h1GBhEXG/QGjinDyzPx9CvrCg5EFM2A8R/rOVh3wFORx5689BmdPrcKVcYwhedTXLWeYKKCtUtl5N6W5Z5zfn3XTZjKEsv4KgBR9nZ/GN++fx1TwkSgi26nLsbDiymGyuibRiUe6ciMKzS/6Vl0sztxVqi8KwJzRdA3PgLkownD3t7Zovz2aliCOKdI4Dsevs9QBkDjsc3yYkYx/4Mp53pLs/nlNQ+NTg/sueJskFqKvMnrQErE/h8zR89k4pdH99DB36UYMikCqeLHu3u9eLznWP0Kb3FKM55u3jB9M28v1itxZEkHNPTXY5HHNZHIindY8Dg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hj9ulef/ECGcrazQrOsCM2HA8rJXxjA+D3YADl+rRpc=;
 b=qm/YHO7y/3tEV23ddjkWUGjAqCfLmMG04BkiKcmqXoPThcKNe2I3tduyheOw4J0tQtp6aKpvvRA9h/8RdtlDpxzVUyD3W6ZZeSinbo0czGYquaZX5pxqaZjKd8/h+9TPwnkrrUJ01HyRmxO4N79pFkVH5WYgKBC6jbmHlwk+ghA6hG+fB6cvGrvQaZs+l/GBWMb0Lcju6XOJyizm5EYObUNiMYinBeAjaVE/v5ZZq5HslVGmaAYECcw5yeZEGHqOu7F0Y+shB9PHgHx0eHYDAFya8iRhfHndDk1fZfNw+ygiuAecXXGvbV+3OgefY4J9rk3/TD7x8EQJIlNos2OZvQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 63.35.35.123) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hj9ulef/ECGcrazQrOsCM2HA8rJXxjA+D3YADl+rRpc=;
 b=rqMJRPT5EZx2QuzL4Yv5JpE0/astDsMZ9ifWGxF57SqRajpOGKCw9fCYF6PrNs4a0yKXqwr/7g65Fy92aPcIDF3LXe4S8bj28ywxJr5QlgaxrBCbeL1LzP3U1/YNk81QTgWhg14Ye8vLyKhrHRAWqBhudXOuh47nrhyNQDCy3dw=
Received: from DU2P251CA0015.EURP251.PROD.OUTLOOK.COM (2603:10a6:10:230::19)
 by PAVPR08MB9037.eurprd08.prod.outlook.com (2603:10a6:102:325::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.22; Mon, 14 Oct
 2024 08:56:25 +0000
Received: from DB3PEPF0000885D.eurprd02.prod.outlook.com
 (2603:10a6:10:230:cafe::f8) by DU2P251CA0015.outlook.office365.com
 (2603:10a6:10:230::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.26 via Frontend
 Transport; Mon, 14 Oct 2024 08:56:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
 pr=C
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DB3PEPF0000885D.mail.protection.outlook.com (10.167.242.8) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8048.13
 via Frontend Transport; Mon, 14 Oct 2024 08:56:23 +0000
Received: ("Tessian outbound cd6aa7fa963a:v473"); Mon, 14 Oct 2024 08:56:22 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 5604085107f330c0
X-TessianGatewayMetadata: W6TcyfcGyEb/Vei9lv8HJAMQDmox2ER3Xj/Q7v5gcGrudAF4tophR2DDHYk4E6jgVVNIlXoPhPV/+dWEfjKObt1KDzMDejO3FdOAh6NXlXzi9I06h/kh78ZIQqqHgmF4oMJIvLS2Mmh6DFpY3NgQn/CNty9XeonbYn1R2R1b4VU=
X-CR-MTA-TID: 64aa7808
Received: from L7b83a0262f09.2
	by 64aa7808-outbound-1.mta.getcheckrecipient.com id 5C623BA8-42A4-41E5-B140-CC887C14EC62.1;
	Mon, 14 Oct 2024 08:56:11 +0000
Received: from EUR05-DB8-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id L7b83a0262f09.2
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Mon, 14 Oct 2024 08:56:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yV2WQoR6LbK0ThR5Iiv1bo/S/tBCuPV+EE/kqW0CEk8qoGCtCQj7r60KP8cMGmlziO4uM0g1u0AC6TzaJ9YmFPlq8+8TreTV33G440xsMHF1gRyxX7DifWCAamanuTyU1fDCADAxRWWLWmgIacnUQDsRYerLRILoRgGKAEkoYDrp/caqPoE71PFzM2igjvn4F0X7O3Ukv4uzhHb9zK9QAKIOC2FTdMIy80ypWNrOS6cLMIiySIawJ0Gt+UXIy6Uong+CI4fV0Td0+ser5S2Yr8W5LkAmWxOSngSKVN5ZFvIJE2xE3rJH5j8ldpoR3GujviV9EiaKyRGO/n4u+EDkRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hj9ulef/ECGcrazQrOsCM2HA8rJXxjA+D3YADl+rRpc=;
 b=vOOfVkOUWcavzruWP2vIUJCxzIIZP04ZfTnA624yscqa4BpUBXDAjNOTi02JPueerX3aLW/CJZC3jh9Fb1OjkxwlyNh2yTsk9j6sfDuYIyN+TCsGNIh+/Xbz/z5vZJdI28OsmJnp1r3cicqZwOAQbyuPmvq5EaFaTYwJV0u3HHV6d+XE2DTSj+eLX1a1jccIGkm/l+fdg+sj5exLQWe/GFPmdKvdnP9oc/E6ZvuY8eOz9ShPD0nTwhyhAOtI9Dk8/xLQJWEAnOuZTj50S+KsYnsLLawFoJ8q5cJAo/WlknmTEgRVMaBMY/di8bWX2+JSc337Bquct5eiqs6Ype4tbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hj9ulef/ECGcrazQrOsCM2HA8rJXxjA+D3YADl+rRpc=;
 b=rqMJRPT5EZx2QuzL4Yv5JpE0/astDsMZ9ifWGxF57SqRajpOGKCw9fCYF6PrNs4a0yKXqwr/7g65Fy92aPcIDF3LXe4S8bj28ywxJr5QlgaxrBCbeL1LzP3U1/YNk81QTgWhg14Ye8vLyKhrHRAWqBhudXOuh47nrhyNQDCy3dw=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from GVXPR08MB7727.eurprd08.prod.outlook.com (2603:10a6:150:6b::6)
 by VI1PR08MB10297.eurprd08.prod.outlook.com (2603:10a6:800:1be::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.25; Mon, 14 Oct
 2024 08:56:05 +0000
Received: from GVXPR08MB7727.eurprd08.prod.outlook.com
 ([fe80::9672:63f7:61b8:5469]) by GVXPR08MB7727.eurprd08.prod.outlook.com
 ([fe80::9672:63f7:61b8:5469%7]) with mapi id 15.20.8048.020; Mon, 14 Oct 2024
 08:56:04 +0000
Message-ID: <11cff100-3406-4608-9993-c29caf3d086d@arm.com>
Date: Mon, 14 Oct 2024 09:56:01 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 10/11] virt: arm-cca-guest: TSM_REPORT support for
 realms
Content-Language: en-GB
To: Gavin Shan <gshan@redhat.com>, Steven Price <steven.price@arm.com>,
 kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: Sami Mujawar <sami.mujawar@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun
 <alpergun@google.com>, Dan Williams <dan.j.williams@intel.com>,
 "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
References: <20241004144307.66199-1-steven.price@arm.com>
 <20241004144307.66199-11-steven.price@arm.com>
 <5a3432d1-6a79-434c-bc93-6317c8c6435c@redhat.com>
 <6c306817-fbd7-402c-8425-a4523ed43114@arm.com>
 <7a83461d-40fd-4e61-8833-5dae2abaf82b@arm.com>
 <5999b021-0ae3-4d90-ae29-f18f187fd115@redhat.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <5999b021-0ae3-4d90-ae29-f18f187fd115@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P265CA0197.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:318::13) To GVXPR08MB7727.eurprd08.prod.outlook.com
 (2603:10a6:150:6b::6)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	GVXPR08MB7727:EE_|VI1PR08MB10297:EE_|DB3PEPF0000885D:EE_|PAVPR08MB9037:EE_
X-MS-Office365-Filtering-Correlation-Id: ae504ccf-b8dc-4133-f942-08dcec2e14b0
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?d2xIbC9oQkpQc3FKc0M1MEVuNWhUU3pGWmovS3d1UkxPcGJDb2t4ZVJ2ZXBk?=
 =?utf-8?B?K29SZzFtT3dFZFo5WGxIbG9IQ1NGR2U1M0NPYlgzZ1dKNnBNZktUTm1Tak1K?=
 =?utf-8?B?TFpqbXorWjVVOVVzelhvOEpCR3ZRYS9BOVl6SXRJSitlak11SXFhd1lQRG1M?=
 =?utf-8?B?OVlyZzVTc3h2cjlmOUhOSGgySzRsSHh6S0NURG5GbzNadlJsTnpadE03aWRV?=
 =?utf-8?B?NWtDN0JwOENpNGt0SU12MWJWZkprWDFwbElBb21qMnYrR0hhaDBFQnZpZkxM?=
 =?utf-8?B?aVFHOExzNWJydzY5NUc3R24zUGE2cDRiUEVFbVVSelBNMUtOdUl5REt6WnNG?=
 =?utf-8?B?MEdrdWswWXFESURkMDFYd2liZFFpd3VweW8wRTZaOFArNkh5SjA1TnFTRERC?=
 =?utf-8?B?VlEzY0syOVYzZDNsbU56UllRamYyUFh1ZDJxOGxxcEhLaHFkc2NMNU9VdlRR?=
 =?utf-8?B?a1dHTlJxOE0yZXN5d1ptem5NS1IzVy9xUkx5b2hUZmx1c1c0UGkrOEFVcDBw?=
 =?utf-8?B?WUF1cVhmVTdqOEJ6SDhYZzhHRHVPQXBvaGFZbklsMVlkeTlSa1NDOS84akdw?=
 =?utf-8?B?TnVEdFZ4QmphdDkwenVBRzA4Q1Q0aGJQam5objEvUEowbkRVNlF2c1REY3NL?=
 =?utf-8?B?RlF4cEV5WnBDNlNudGE2UjU2WmM5VkxyTHo5WXc2Z0E4S1ZMK2ZaVHlwU09P?=
 =?utf-8?B?S1poRnJ5ZnVvRENZS0lqVVVsOWE0U2Fqdncwd1NvWGtuMFN6TXlsVFVwQ0NU?=
 =?utf-8?B?WC83SGJCV0dBOFhHK0kyK05RRlRUcSt4N2x0U1NmS3cvZDNTSm5hcmpsV3JU?=
 =?utf-8?B?eDR0M0RiQnVCMWRvK1ZrM2dvV2haTUNxZGhWclU0YjVqY2tST0I2WG8vRWcx?=
 =?utf-8?B?czJTYkYwNS93MTVuY0psVEExZ1pSTlFHOS9zRkErdGY4dERJRDJITlRjVmFB?=
 =?utf-8?B?ZGlNTjlOZ1ZBbUFIMkdlNjZDMldEdUxKMTM3RnhvcUc0VGI3dzVjNGxOR3pF?=
 =?utf-8?B?aXBNY0R6T0duY3B2dlBxeHFJMGEyVVo1ME1vbXRsVzQ2b0cxa0o5anlPSkMy?=
 =?utf-8?B?Tzc4R2pTS2ZPN1BkMTMrRG1YeXBrWTFnOFdlb3VkQmVqeURxYUJFMWRhUG16?=
 =?utf-8?B?SFpnb1BHSzhwaFNWeUJmcndVVGJwZW5tSjNyK0p3UU5WRFNYamFubE42VGk2?=
 =?utf-8?B?ZEdvT0Urb0VXbXNsWlJ3SjhmaEhKaC9sN2FjdS9HQVpYempaa3pXYUF0SHlL?=
 =?utf-8?B?TkxPbjVCOE9McER5NG9KdE54V1hMRHFoTkRyaG1Wa0lQeEVvKzNtanNUYXM3?=
 =?utf-8?B?ZnUzeDZwRGJhL3VXalVnQW80SE8yY2pTblhTdFJYK21qbWtxYm1rN1drdFQy?=
 =?utf-8?B?THFsb3VwbWtxS2toYlA4Ym4wM1FyV3RtaFVEOC9OcmswVzBzaTIxamJ5aHVE?=
 =?utf-8?B?R2RGZnhDdE5vdlU3TGFuQ3JWT3M5RGFJN3hsWFdwMHpDaXExMldPUUdtd1BZ?=
 =?utf-8?B?S3ZEc2RKUjlrbUxJdTlyMUVmb2pZTFhoWWlxbE1ldUNNelNkY010eFJXZmhL?=
 =?utf-8?B?b245bUE2SnpJQUt6d1M4NTZPcEZOK1NJRmFBOWJXT3pIRDJQRkllUlgrSG8w?=
 =?utf-8?B?ZjN6YXlVcDVqRUtGaUx0dFJ2bzlHK1p6a1JON056TTU4c3ZrUUFtZ1huSUdn?=
 =?utf-8?B?WG95TnFTOWgwQjNBUzNqTGdYMksvT3pEQWtNYUZxTWVXMHozU1B1dkRnPT0=?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GVXPR08MB7727.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB10297
Original-Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-SkipListedInternetSender:
 ip=[2603:10a6:150:6b::6];domain=GVXPR08MB7727.eurprd08.prod.outlook.com
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB3PEPF0000885D.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	c84eb775-37d5-4ef3-5296-08dcec2e08fc
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|35042699022|1800799024|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VnBmRnhzVWNrQzhyRUNzZlpyU3B3QWttWjFUek1STWREc1VzRCtoVXk4RGhu?=
 =?utf-8?B?bk42cFFySHkrSTFpMlJHdzdXR25ZdS90VDVDaXo4N0tzQ05STjdJOGVCdmkr?=
 =?utf-8?B?WXk1aTJVNEYzZUtYY2dpMzdDWEdaMGVhWkdvSzZKZkN1cEpDQlZyUFVXUWov?=
 =?utf-8?B?dm90Kzk0bnJnQ2V1RE5kR0JMOWljV3k5OGd6aUlzZ2M1b01HbVlmTkdYWWhv?=
 =?utf-8?B?MklGSHRNZGxmR0dlYTJoY2YvbVM4V3JOY1lqK1VocHJOajV5a2ZFejZSVDB3?=
 =?utf-8?B?YjZwRWRZMStqVW8wbXpiTDAvMC9xQUdrN3B4Zk1uYXdmSzZyYjlubkNnUFV4?=
 =?utf-8?B?ZkJwNU9LN2NLd0pTdDFWd0wzNnZHOHRwWjV6aDBLemR4N2ZtbnZTTEQrQko3?=
 =?utf-8?B?djVaVDV5OStldkRlc2EvUHd2ZndWZk9tRzNHUDhzZzIyd2lTaFNXblRid2RI?=
 =?utf-8?B?bjB0a1RWV0lSRHhleWxsTDdteGZJdnJJTEY2Q1V2REJZWk5nNHB2RnVpL3Q5?=
 =?utf-8?B?T2R3VkYxd01lZkVKRVRsSGVjRmhGUUNxZ3JGUzdndFVJRkVrY3lpd1ZnRFY0?=
 =?utf-8?B?bTBSVWo0VFZvbVN2OFd5N0UvTGM3UzE1Zmc2OHM5amxDQTFsT21xM0orSTZL?=
 =?utf-8?B?L3N6dVlBd0tPdElXSUZ5dFRSYVJtR2ZZdGxhRVJuQWhVM0tkd2R0VnFXdUtG?=
 =?utf-8?B?c1d0eFdOZXNlT2szU255R1RwWnIxQTJFTFJMRXVyVUlxR0J3ekNtTjgybWly?=
 =?utf-8?B?ZmdjaWtqSGx4NUdZT2t6UmQ4ZC8xQXhIWit3UUZvaFZoaml5MFF2UEtEa0tv?=
 =?utf-8?B?cFJwSm55VFJhVkozWmlmbXE5ZDc1VTVzcE9qM05iMmVqYnU5RmFCZ1NqTG4y?=
 =?utf-8?B?TGNCSU5HeC9TRlVjUWt3aUlVZTZBeUM4ZjJ4QWpxenJzblJNcS9XN2pSRG5L?=
 =?utf-8?B?aS9RU2VORjVsSkVBcHpDNy9WUStYZGZEam9nbDEycEN3WUE2MTdVVzd6ZWNn?=
 =?utf-8?B?ZVR4TURYeG5JOEx0NkZkOXFZdFNKWldBUnJDMjdSamJlbEpXTHp4bGozeDV6?=
 =?utf-8?B?RU5VMmE5dGZUanZkVmNzd1AvTktCcnV6MnhFM0lTZG8vVUc5em1NNFlOaG1h?=
 =?utf-8?B?SWZUTldsMHpoV2hlQlpwK2Uyb1R4QTBPNkNBWXRBL0lSVE1zQkxGNUNqenpp?=
 =?utf-8?B?YjVTUWRnbzVhMTQxaE1GR3VYU1A3cGhUSlYxVURxWTNWd1BxTFo5WTA4TjFV?=
 =?utf-8?B?d0ZnK0FIcW5lVGVQWDRhUDN0aVkxc2U5MnhaQ0EzcmZNbjJHbGRLL0JjZlI0?=
 =?utf-8?B?VDhyN3djU0N0Q0JXMC9TdXlmNGliYmQra1B4QzRmYnpUdUxyWUt0ZGhJTVp1?=
 =?utf-8?B?MXIzSzZYd0I3ajNhY21DT3VVYXlVbzFCR1lOeFZNd04ySk9IRFN1UnN3WENh?=
 =?utf-8?B?aG0wM2J1WHpVZkpZcGZsWmhSdmZGNkZSMHJuVmg4WTQ5TFNJdC9tbU1lZFVn?=
 =?utf-8?B?T2RDVDI5Ym0xZnFyM245OGlNNEJjN1ZOSFo3NmxXMEdmNUEwQ3BQLzErMVlu?=
 =?utf-8?B?VGF5U3pteGlKSUJOY1RRalcwVTBYdERWbFFnelI3ek1vK1FlYnpDQm5IekNy?=
 =?utf-8?B?RkRNM0FiNUdUdkF3OS9Zb3RYR1RFWTRQNHhDZ1ZaYWdJdGdBL05reHZMeGpi?=
 =?utf-8?B?YnR2ZG1VSy9kbjVhZXllR3BUSXBBTExaTHZTaFBIWDA2eWhUR1FrdEpQMGIx?=
 =?utf-8?B?Mjh2ZkNzRldnM2NuSHlKVmtJZWhQU09STW16MzQvRVVodmxBWUt6d0cxbmwx?=
 =?utf-8?B?WkI5RXFrWTlXdUxmRk5FUFRRdFlHVHQxaGMxQTREeGZLaXpVRlNzMTUyanJa?=
 =?utf-8?Q?umbj0KIInjwie?=
X-Forefront-Antispam-Report:
	CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(13230040)(82310400026)(35042699022)(1800799024)(376014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2024 08:56:23.9404
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ae504ccf-b8dc-4133-f942-08dcec2e14b0
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB3PEPF0000885D.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAVPR08MB9037

On 12/10/2024 07:06, Gavin Shan wrote:
> On 10/12/24 2:22 AM, Suzuki K Poulose wrote:
>> On 11/10/2024 15:14, Steven Price wrote:
>>> On 08/10/2024 05:12, Gavin Shan wrote:
>>>> On 10/5/24 12:43 AM, Steven Price wrote:
>>>>> From: Sami Mujawar <sami.mujawar@arm.com>
>>>>>
>>>>> Introduce an arm-cca-guest driver that registers with
>>>>> the configfs-tsm module to provide user interfaces for
>>>>> retrieving an attestation token.
>>>>>
>>>>> When a new report is requested the arm-cca-guest driver
>>>>> invokes the appropriate RSI interfaces to query an
>>>>> attestation token.
>>>>>
>>>>> The steps to retrieve an attestation token are as follows:
>>>>>     1. Mount the configfs filesystem if not already mounted
>>>>>        mount -t configfs none /sys/kernel/config
>>>>>     2. Generate an attestation token
>>>>>        report=/sys/kernel/config/tsm/report/report0
>>>>>        mkdir $report
>>>>>        dd if=/dev/urandom bs=64 count=1 > $report/inblob
>>>>>        hexdump -C $report/outblob
>>>>>        rmdir $report
>>>>>
>>>>> Signed-off-by: Sami Mujawar <sami.mujawar@arm.com>
>>>>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>>>>> Signed-off-by: Steven Price <steven.price@arm.com>
>>>>> ---
>>>>> v3: Minor improvements to comments and adapt to the renaming of
>>>>> GRANULE_SIZE to RSI_GRANULE_SIZE.
>>>>> ---
>>>>>    drivers/virt/coco/Kconfig                     |   2 +
>>>>>    drivers/virt/coco/Makefile                    |   1 +
>>>>>    drivers/virt/coco/arm-cca-guest/Kconfig       |  11 +
>>>>>    drivers/virt/coco/arm-cca-guest/Makefile      |   2 +
>>>>>    .../virt/coco/arm-cca-guest/arm-cca-guest.c   | 211 ++++++++++++ 
>>>>> ++++++
>>>>>    5 files changed, 227 insertions(+)
>>>>>    create mode 100644 drivers/virt/coco/arm-cca-guest/Kconfig
>>>>>    create mode 100644 drivers/virt/coco/arm-cca-guest/Makefile
>>>>>    create mode 100644 drivers/virt/coco/arm-cca-guest/arm-cca-guest.c
> 
> [...]
> 
>>>>> +/**
>>>>> + * arm_cca_report_new - Generate a new attestation token.
>>>>> + *
>>>>> + * @report: pointer to the TSM report context information.
>>>>> + * @data:  pointer to the context specific data for this module.
>>>>> + *
>>>>> + * Initialise the attestation token generation using the challenge 
>>>>> data
>>>>> + * passed in the TSM descriptor. Allocate memory for the attestation
>>>>> token
>>>>> + * and schedule calls to retrieve the attestation token on the 
>>>>> same CPU
>>>>> + * on which the attestation token generation was initialised.
>>>>> + *
>>>>> + * The challenge data must be at least 32 bytes and no more than 64
>>>>> bytes. If
>>>>> + * less than 64 bytes are provided it will be zero padded to 64 
>>>>> bytes.
>>>>> + *
>>>>> + * Return:
>>>>> + * * %0        - Attestation token generated successfully.
>>>>> + * * %-EINVAL  - A parameter was not valid.
>>>>> + * * %-ENOMEM  - Out of memory.
>>>>> + * * %-EFAULT  - Failed to get IPA for memory page(s).
>>>>> + * * A negative status code as returned by 
>>>>> smp_call_function_single().
>>>>> + */
>>>>> +static int arm_cca_report_new(struct tsm_report *report, void *data)
>>>>> +{
>>>>> +    int ret;
>>>>> +    int cpu;
>>>>> +    long max_size;
>>>>> +    unsigned long token_size;
>>>>> +    struct arm_cca_token_info info;
>>>>> +    void *buf;
>>>>> +    u8 *token __free(kvfree) = NULL;
>>>>> +    struct tsm_desc *desc = &report->desc;
>>>>> +
>>>>> +    if (!report)
>>>>> +        return -EINVAL;
>>>>> +
>>>>
>>>> This check seems unnecessary and can be dropped.
>>>
>>> Ack
>>>
>>>>> +    if (desc->inblob_len < 32 || desc->inblob_len > 64)
>>>>> +        return -EINVAL;
>>>>> +
>>>>> +    /*
>>>>> +     * Get a CPU on which the attestation token generation will be
>>>>> +     * scheduled and initialise the attestation token generation.
>>>>> +     */
>>>>> +    cpu = get_cpu();
>>>>> +    max_size = rsi_attestation_token_init(desc->inblob,
>>>>> desc->inblob_len);
>>>>> +    put_cpu();
>>>>> +
>>>>
>>>> It seems that put_cpu() is called early, meaning the CPU can go away 
>>>> before
>>>> the subsequent call to arm_cca_attestation_continue() ?
>>>
>>> Indeed, good spot. I'll move it to the end of the function and update
>>> the error paths below.
>>
>> Actually this was on purpose, not to block the CPU hotplug. The
>> attestation must be completed on the same CPU.
>>
>> We can detect the failure from "smp_call" further down and make sure
>> we can safely complete the operation or restart it.
>>
> 
> Yes, It's fine to call put_cpu() early since we're tolerant to error 
> introduced
> by CPU unplug. It's a bit confused that rsi_attestation_token_init() is 
> called
> on the local CPU while arm_cca_attestation_continue() is called on same CPU
> with help of smp_call_function_single(). Does it make sense to unify so 
> that
> both will be invoked with the help of smp_call_function_single() ?
> 
>      int cpu = smp_processor_id();
> 
>      /*
>       * The calling and target CPU can be different after the calling 
> process
>       * is migrated to another different CPU. It's guaranteed the 
> attestatation
>       * always happen on the target CPU with smp_call_function_single().
>       */
>      ret = smp_call_function_single(cpu, 
> rsi_attestation_token_init_wrapper,
>                                     (void *)&info, true);

Well, we want to allocate sufficient size buffer (size returned from
token_init())  outside an atomic context (thus not in smp_call_function()).

May be we could make this "allocation" restriction in a comment to
make it clear, why we do it this way.

Suzuki




>      if (ret) {
>          ...
>      }
> 
> Thanks,
> Gavin
> 

