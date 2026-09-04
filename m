Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010013.outbound.protection.outlook.com [52.101.84.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2B55387375;
	Fri,  4 Sep 2026 07:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.13
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788506892; cv=fail; b=T9AHxaDBNcoUGgYzArXMhi11zGeZMPMbTC6WajrJmvZ9bBzB31k71WkwunMsXcVDwitv5mxAv9LA9x19Jqjb+Vbfutn2oPSu1hGQbpri0NElFcZuHTjgnEi80k1gWeoziEL+6C8YTjJdRchrjexOUFJJqeTmRRZLlTNAUb9xPik=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788506892; c=relaxed/simple;
	bh=NLUk/Sr5yaSpx49b3jHW19TBPkLyLLmJ3tGi3KR8jO0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=bdu08sEUMFxoPoPRzNkFlrv8xEc4pveSiEOXKy6fsT+Xv/v63jDRkQ3IEKZuGX8rZVhsFGenFNckjdyLClXOO/F/ZAF+fXAgZM+xcKYqf0YV5OHuCN6O/T2+xcMP1Aa65FEzpfH+gCGHsBxuKbgnDXnVkouzrbqJqHuDF2v4gPw=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=npjEZaNI; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=npjEZaNI; arc=fail smtp.client-ip=52.101.84.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="npjEZaNI";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="npjEZaNI"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=f3M0q2QndJhs1Tx/pkgBGk/tTfQISfj1lvXD+JcZSm/2RCekkz2m7PK2kV/Nh3ANPb1m2gf04WoWKkn2tXnIoSrwMeY0+A3iekhAPEQ3TpudXiZIsEs9tt/EVJFfetcnArGfQhxhy+5nBVsDaCRSsqwmNGmUlVzfI5B8uwFee6mDCQZP/kcTHtvuCfa8nSCO2eoDUHro6LTEpmaGFRZ3/PNnGaeRklSNTt8tzu/kUHGP+w9T69YJI33+smVb7r4BFhdgFY4otSWLnMenIua/JcGp1AFEKzQXP4GnuArBuhFkvCX+jE3d6OCioKlp+C0T5XO4LfNkQzDS0sQRdoeVyQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NLUk/Sr5yaSpx49b3jHW19TBPkLyLLmJ3tGi3KR8jO0=;
 b=ByXL9G1m6y401D1+kfNmm6uVLaqtOTFWynzrfH2GZffDXkwHcKmgc7RwPoWUgzMWGINW+/JION4qI8NkGftOipy/GdaglvtKXUr0lhOuaUQVReB/hlZfi6pNR0RZ5Jlf59E67+qSusaY2YBtfzqEw52Vc5kza455c3lhanXQ9C7rAwVFmwkWAojijq+4k7h5IOXuejya0Xe8qtE/5gznr3y85tzuiXps22C6fhKm4CUBAVzkNtgDrDzSbA1lbEZgMKfsJqeQ/zOfdHsGZc5S32maKJkChwMND9b2GeKLUDVtJPHaCRQuhkqN1GTRexXrc36rzsNxkpvRpd+bnez41A==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NLUk/Sr5yaSpx49b3jHW19TBPkLyLLmJ3tGi3KR8jO0=;
 b=npjEZaNIgFQ9y7jn1gg/Eyg+AZwlMgh1yOs0Rq3myhSP+7RrcRqWl66XRib8oDp8S0s7JjAJgdUbE9zA60j/PHPEID9PCaXCJikE/gifDHN0n8kHkFpQNx6dZMwODDqKAP6n3Qr0dbWlK+8MV4feRngL4uaSy5H5UYYmT81mYqo=
Received: from AM0PR10CA0049.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:150::29)
 by AS2PR08MB10324.eurprd08.prod.outlook.com (2603:10a6:20b:5e7::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 07:28:05 +0000
Received: from AM3PEPF0000A794.eurprd04.prod.outlook.com
 (2603:10a6:20b:150:cafe::2b) by AM0PR10CA0049.outlook.office365.com
 (2603:10a6:20b:150::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.12 via Frontend Transport; Fri, 4
 Sep 2026 07:28:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM3PEPF0000A794.mail.protection.outlook.com (10.167.16.123) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.8
 via Frontend Transport; Fri, 4 Sep 2026 07:28:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ksY6GMYJE6/B5sEfR3MD2BmcNg4Xj4CsNt8LP87Sf9zJLFvyPpgR8bcMvBpspEnHcsjLKhxbS9HJkjMJcWs/RTZ0QDlHraYON2ONW9ssHiu7UfAg/mldrVMeu3wMsrYvq9mhwrFvfdjpP7lxjdgf21aMnAypy4BMk4pqygmI00e7sxF4fp2hXMSUk7kDopQOmaNQ6uUm8rKooeqIdbdZBrKB1lu8yRw7u9Duva4Eh/tQOJImMRw/VMOun7bnN+3wxpuNKS5PcLUM1MaoKLvl5avsuTBXVW4d3frgtULSzh6WgtITNbx4Q1eDWK3eNlEnM7Qxzx8sEa8ILfjon2hl8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NLUk/Sr5yaSpx49b3jHW19TBPkLyLLmJ3tGi3KR8jO0=;
 b=Rle4hD68pqPCzfmWCmBcRZr6UeQbn9KtNbEw2sOL0soR1cQCo4C9lhpMaWOhLbf40InTXcdVF7J7zmQ7BvP+dQMCz7TqVdyPM7yC4Tj3RjtghIlw09DGf7cWbB696WyClL00JD3JzxjldnxVCZ2fOJclLkvI6J+G8tPRBi/pQ3t2QV1CqXkZOleWZ6CXbe7PNIPF/s3wARkWR4gMv2787Z4CZ81FMeLxxY9Wsnr0kHYCwnCxZbq377qkykB4GvPqrQcTX3yCNUDpvTNfsnUswjWGkPxxd2kaMlGrhR8NP5cIlfMFUTm6LWPtfoZVYxxoZjSg7eweIDE+f2yH1MWJxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NLUk/Sr5yaSpx49b3jHW19TBPkLyLLmJ3tGi3KR8jO0=;
 b=npjEZaNIgFQ9y7jn1gg/Eyg+AZwlMgh1yOs0Rq3myhSP+7RrcRqWl66XRib8oDp8S0s7JjAJgdUbE9zA60j/PHPEID9PCaXCJikE/gifDHN0n8kHkFpQNx6dZMwODDqKAP6n3Qr0dbWlK+8MV4feRngL4uaSy5H5UYYmT81mYqo=
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com (2603:10a6:101:1d::23)
 by AS8PR08MB10004.eurprd08.prod.outlook.com (2603:10a6:20b:63d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 07:27:25 +0000
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e]) by PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e%4]) with mapi id 15.21.0382.007; Fri, 4 Sep 2026
 07:27:25 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "sashiko-reviews@lists.linux.dev" <sashiko-reviews@lists.linux.dev>
CC: "maz@kernel.org" <maz@kernel.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"oupton@kernel.org" <oupton@kernel.org>, nd <nd@arm.com>
Subject: Re: [PATCH v5 08/49] KVM: arm64: gic-v5: Add VPE doorbell domain
Thread-Topic: [PATCH v5 08/49] KVM: arm64: gic-v5: Add VPE doorbell domain
Thread-Index: AQHdJl44UYwKlt3VlUyepnPLCQGeRraSiGgAgCuohAA=
Date: Fri, 4 Sep 2026 07:27:25 +0000
Message-ID: <656d6e34e988102b53ed98c0bef1073ed00d5394.camel@arm.com>
References: <20260807111159.429128-1-sascha.bischoff@arm.com>
	 <20260807111159.429128-9-sascha.bischoff@arm.com>
	 <20260807124506.ED85C1F000E9@smtp.kernel.org>
In-Reply-To: <20260807124506.ED85C1F000E9@smtp.kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	PR2PR08MB4889:EE_|AS8PR08MB10004:EE_|AM3PEPF0000A794:EE_|AS2PR08MB10324:EE_
X-MS-Office365-Filtering-Correlation-Id: 68138118-1a71-4a77-93db-08df0a560f49
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|10067099003|56012099006|11063799006|4143699003|3023799007|22082099003|18002099003|6133799003|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 OvBhaDJyTH70RKkwhTCS2MTCLRyFh+xHSRFKBotnxQv/rXaDMx1eZ+kOqAsLCAwnqMNkxaG+mSLI2cXPriWU2on37w0JqbgCrjRPhjWxsfCRy3+RHoe9EJMlPsg+6wBJoZ1fxDC1ZHQ46MYMUeVmDwuMncH7hc/nOJwXn9ZYNweUG+EBqQv0gE9yQlOHpFMq3b7gi+MGq/fcbo03PsXc0PEUvcJcZkk5M6jP+9wqifXcO+ii5QwfU5OXZc2Jduw3PYZGYpu65LI4UsUvFo6ryGOIH+zr4oyl2fSRFqsVYnygbyE+UDNOmOu/qgtoWseY8GG9Oz35ngc/wqYEffIkHEwqeaEOLwi4khtMXUqzZtN6WfE93KPJSqTE4DCkC2sgwnii8vLY3cQxRHevIoi4ASFAE9BFkVzP9aNSr79aWhJL4Nzr4unVsXYbFPBVseU/sEt0HNyXXU46d6aT5AQhu2Iu+3zr4cyzP7m9vE0SZLU309YTNSUsv/+AJsJyV4L0mUoliJv+4NUPhf2CwUGJ5gka+/6CxcxKoIJ5r66YFbGcmd1gJxig74OZc1006AmL8nny6Hb0X4gdzjRqnG8DF8XpZtyyETPRaU90YSdyvW0EBfHNNk0y8RG7i2AmXNpZBPm39OjhfQCO57u+llrV2qQDsOUsn2O+d7pqtswvbD4gKI6KmZ+u692V0Ha/Zs9yGueZpbyQOj6EUTX+E+dk70/ddWzfvsKbJrIs02cESYs=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR2PR08MB4889.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(10067099003)(56012099006)(11063799006)(4143699003)(3023799007)(22082099003)(18002099003)(6133799003)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <FFFD65825A418E4C9B06D127757360BB@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 RngOIc2nWFCPAo0AewEn2aiGDs+UHdH2vFv6TflTHitZxRkiRX3B9pKCvkv1ajayPQN4FHYT5j4ZcffMp3jXf35OsAhzh2oLfqjFkEo4pq180aZbAnH1HVyei1SY/W18oHNVuc13bBuwFU8W+BNZ/T9TmKaxxe+B8D92v4jj0M4YPyykF/RSElcJq1/9I4pqq84yz1VneiK+beazySs5kI+Whgzfuq/D75rO6+WSIfVARvfZPRu0UmUCsV7bE7Nu2MkO6hKELwJPWibUxVBFIr/wDz87QakMEyJY+nb3BI0Vv2KjKl0QMdjz7+LsDv7pEU3LfhUKRVwLzN38Ynos8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB10004
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM3PEPF0000A794.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	518795b8-2fdf-4c02-eb64-08df0a55f7a0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|35042699022|36860700016|1800799024|82310400026|14060799003|4143699003|11063799006|10067099003|6133799003|22082099003|18002099003|3023799007|56012099006;
X-Microsoft-Antispam-Message-Info:
	bgZ0zr7oBHWAnOlrhCA8fANJiCQgguLxfkG0ZFPaUJ04WmH3Di1+g19x8t9HcN5mEQaRMUL6Y13DhoXpF4nGsJxO37SIKgcxmLxuLO8d2c4EJ/96970ROrqizXB0wb9vXjCd8DC4Hpm2Rw1IPxP/h6DKm9QBPrHwHUsvjDe3sYZO8nj3MTFoOaC2OVJfzbC1wsrgqV7OZHRUkhiDEIvOJfRDISnqHW13Qc3GDnnf+pIDohZv0MMonNnp4cs6yCZo/egwrvKDLVY0m3IOrMtjXyfmdL96MCZ//YVvGiYTxbFYHoPILDo9bRj6MewvKfan+tbUABQmjxulOjIJbzX+mMgXl6KTIQdlyiWPMpHaqHso+ln29XzqG5YgukULoAq89nI9UAnfDMA3fi6wm2QxVMlHdVA33Nb/Kok8De+xYHIWo9y4nho715olTWJLhthQD6FeG4thgUiZGA04FGdZACvRCplcDBv83kOfjGi14slCkISrWNwJCB90RgjoXLKXp46hPu6dTyi8Gom7LW55Lem35Yzc1qQD3+FTp9efhjiZkBCaGdYuqVNjlOVsWV9oreEiMu1Y9GXpyDxLwm55TYmmAtgZiKfT3OX0wrpLfu6HiS//RxZdMrcqtavAiVzAFX/sMbin+fx/QQNpcnVn/DA2/Rn5jCF1sra+PQr5mKU=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(23010399003)(35042699022)(36860700016)(1800799024)(82310400026)(14060799003)(4143699003)(11063799006)(10067099003)(6133799003)(22082099003)(18002099003)(3023799007)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	kLc2heq5FcjlzHajoHGkN7iKEfIefX+OlZxQcaaj96zaFJwSRdWXykMw6ot6IN3NgopXrxXLanCvXf2kZCK0tfGsODU/AxE4+8eC61kzibJeyy6oGPIJbjqBcsYEV8nrr7qZvztXJ3VlqkBle703V+bswYLQyy+6aYcxbPgSsQIAVQKqfdkyQyrYcripZRwz9O6dNsxRzN7fFPJI7rB87LVWvw7B5V+UrgdVkB974JxG0PVMi2cQN3oHWSIvMmoEoWVngPmCpRX7wVs3lzWUbl8KrUiRUO6HYrjC/0EWpGvgPb0CgAmwk/sCKXXA2cs/znrXyo1FvWhn9Tx0fmUEO28Jq3yQrthmugOnPWI7gnuurdU0Kjm0kF53ahsPvsnBS7tOpfV+vRtXQ++DHPZx3i5qzaBCOj3SuB2q8XLEpNH//I23lSlh45+CPTdDTkjg
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2026 07:28:04.8761
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 68138118-1a71-4a77-93db-08df0a560f49
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM3PEPF0000A794.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB10324

T24gRnJpLCAyMDI2LTA4LTA3IGF0IDEyOjQ1ICswMDAwLCBzYXNoaWtvLWJvdEBrZXJuZWwub3Jn
IHdyb3RlOg0KPiBUaGFuayB5b3UgZm9yIHlvdXIgY29udHJpYnV0aW9uISBTYXNoaWtvIEFJIHJl
dmlldyBmb3VuZCA0IHBvdGVudGlhbA0KPiBpc3N1ZShzKSB0byBjb25zaWRlcjoNCj4gLSBbSGln
aF0gUmVzb3VyY2UgbGVhayBvZiBHSUN2NSBWUEUgZG9vcmJlbGwgZG9tYWluIGFuZCBmd25vZGUg
b24NCj4gVkdJQyBpbml0aWFsaXphdGlvbiByZXRyeS4NCj4gLSBbSGlnaF0gVE9DVE9VIHJhY2Ug
YmV0d2VlbiBgS1ZNX0NSRUFURV9WQ1BVYCBhbmQNCj4gYEtWTV9ERVZfQVJNX1ZHSUNfQ1RSTF9J
TklUYCBsZWFkcyB0byB1bmRlcnNpemVkIGRvb3JiZWxsIGRvbWFpbg0KPiBhbGxvY2F0aW9uLg0K
PiAtIFtNZWRpdW1dIEZ3bm9kZSBJRCBjb2xsaXNpb24gZm9yIFZNcyBjcmVhdGVkIGJ5IHRoZSBz
YW1lIHVzZXJzcGFjZQ0KPiB0aHJlYWQuDQo+IC0gW0xvd10gVW5yZWFjaGFibGUgZGVhZCBjb2Rl
IGluIGRvb3JiZWxsIGRvbWFpbiBlcnJvciBoYW5kbGluZyBwYXRoLg0KPiAtLQ0KPiANCj4gLS0t
IFBhdGNoIFs4XTogW1BBVENIIHY1IDA4LzQ5XSBLVk06IGFybTY0OiBnaWMtdjU6IEFkZCBWUEUg
ZG9vcmJlbGwNCj4gZG9tYWluIC0tLQ0KPiBjb21taXQgMDg3OTg5ZmVlZjM3NzdiZWVkZjc1YTAx
NTEyZGE1YjllMzMxYjZmYQ0KPiBBdXRob3I6IFNhc2NoYSBCaXNjaG9mZiA8U2FzY2hhLkJpc2No
b2ZmQGFybS5jb20+DQo+IEtWTTogYXJtNjQ6IGdpYy12NTogQWRkIFZQRSBkb29yYmVsbCBkb21h
aW4NCj4gDQo+IFRoaXMgY29tbWl0IGFkZHMgc3VwcG9ydCBmb3IgYSBwZXItVk0gVlBFIGRvb3Ji
ZWxsIGlycSBkb21haW4gZm9yDQo+IEdJQ3Y1Lg0KPiBJdCBjcmVhdGVzIHRoZSBkb21haW4gdW5k
ZXIgdGhlIEdJQ3Y1IExQSSBkb21haW4gd2l0aCBvbmUgZG9vcmJlbGwNCj4gYWxsb2NhdGVkDQo+
IHBlciBWUEUsIGFuZCBzdG9yZXMgdGhlIHN0YXRlIGZvciBsYXRlciBJUlMgY29tbWFuZHMgYW5k
IHdha2V1cHMuDQo+IA0KPiBkaWZmIC0tZ2l0IGEvYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLXY1
LmMNCj4gYi9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMtdjUuYw0KPiBpbmRleCA0MWNhMjA5OGVj
YjczLi43NTIzMjlmYzNkNTY2IDEwMDY0NA0KPiAtLS0gYS9hcmNoL2FybTY0L2t2bS92Z2ljL3Zn
aWMtdjUuYw0KPiArKysgYi9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMtdjUuYw0KPiBbIC4uLiBd
DQo+ID4gK3N0YXRpYyBpbnQgdmdpY192NV9jcmVhdGVfcGVyX3ZtX2RvbWFpbihzdHJ1Y3Qga3Zt
ICprdm0pDQo+ID4gK3sNCj4gPiArCXN0cnVjdCB2Z2ljX3Y1X3ZtICp2bSA9ICZrdm0tPmFyY2gu
dmdpYy5naWN2NV92bTsNCj4gPiArCWludCBucl92Y3B1cyA9IGF0b21pY19yZWFkKCZrdm0tPm9u
bGluZV92Y3B1cyk7DQo+IA0KPiBbU2V2ZXJpdHk6IEhpZ2hdDQo+IENhbiBhIHJhY2UgY29uZGl0
aW9uIGhlcmUgbGVhZCB0byBhbiB1bmRlcnNpemVkIGRvb3JiZWxsIGRvbWFpbg0KPiBhbGxvY2F0
aW9uPw0KPiANCj4gSWYgYSB1c2Vyc3BhY2UgdGhyZWFkIGNhbGxzIHRoZSBpbml0aWFsaXphdGlv
biBpb2N0bCwgaXQgY2hlY2tzIGZvcg0KPiBjb25jdXJyZW50DQo+IFZDUFUgY3JlYXRpb24sIGJ1
dCB0aGlzIGNoZWNrIGlzIHBlcmZvcm1lZCBsb2NrbGVzc2x5IHdpdGggcmVzcGVjdCB0bw0KPiB0
aGUNCj4ga3ZtLT5sb2NrIGhlbGQgZHVyaW5nIFZDUFUgY3JlYXRpb24uDQo+IA0KPiBDb25jdXJy
ZW50bHksIGEgc2Vjb25kIHRocmVhZCBjb3VsZCBjcmVhdGUgYSBWQ1BVLCB3aGljaCB0YWtlcyBr
dm0tDQo+ID5sb2NrIGFuZA0KPiBpbmNyZW1lbnRzIGNyZWF0ZWRfdmNwdXMuIFNpbmNlIGluaXRp
YWxpemF0aW9uIGhhc24ndCBjb21wbGV0ZWQgeWV0LA0KPiBWQ1BVDQo+IGNyZWF0aW9uIGlzIGFs
bG93ZWQgdG8gcHJvY2VlZC4NCj4gDQo+IFdoZW4gdGhlIGZpcnN0IHRocmVhZCByZWFjaGVzIHRo
aXMgcG9pbnQsIGl0IGFsbG9jYXRlcyBleGFjdGx5IHRoZQ0KPiBudW1iZXINCj4gb2Ygb25saW5l
IFZDUFVzIGF0IHRoaXMgbW9tZW50LiBBcyB0aGUgc2Vjb25kIHRocmVhZCBjb21wbGV0ZXMgYW5k
DQo+IGluY3JlbWVudHMNCj4gb25saW5lX3ZjcHVzLCB0aGUgVk0gbm93IGhhcyBtb3JlIFZDUFVz
IHRoYW4gYWxsb2NhdGVkIGRvb3JiZWxsIElSUXMsDQo+IHdoaWNoDQo+IGNhbiBsZWFkIHRvIG91
dC1vZi1ib3VuZHMgSVJRIGFycmF5IGFjY2VzcyBsYXRlci4NCg0KQWdyZWVkLCBJIHRoaW5rIHRo
YXQgdGhpcyBpcyBhbiBpc3N1ZS4gVGhlIGV4aXN0aW5nIGNoZWNrIG9ubHkgZGV0ZWN0cw0KdkNQ
VSBjcmVhdGlvbiB0aGF0IGlzIGFscmVhZHkgaW4gcHJvZ3Jlc3MuIFNpbmNlIENUUkxfSU5JVCBk
b2VzIG5vdA0KaG9sZCBrdm0tPmxvY2ssIGFub3RoZXIgY3JlYXRpb24gY2FuIHN0YXJ0IGFmdGVy
d2FyZHMgYW5kIGxlYXZlIHRoZQ0KcGVyLXZDUFUgcmVzb3VyY2VzLCBpbmNsdWRpbmcgdGhlIGRv
b3JiZWxsIGRvbWFpbiwgdW5kZXJzaXplZC4gRldJVywgSQ0KdGhpbmsgdGhpcyBhZmZlY3RzIEdJ
Q3Y0LCB0b28uDQoNCkkgd2lsbCBwb3N0IGEgc2VwYXJhdGUgZml4dXAgdG8gc2VyaWFsaXNlIENU
UkxfSU5JVCBhZ2FpbnN0IHZDUFUNCmNyZWF0aW9uLg0KDQo+IA0KPiA+ICsJaW50IGlkID0gdGFz
a19waWRfbnIoY3VycmVudCk7DQo+ID4gKwlpbnQgcmV0LCBkYl92aXJxID0gMDsNCj4gPiArDQo+
ID4gKwlpZiAoIWdpY3Y1X2dsb2JhbF9kYXRhLmxwaV9kb21haW4pIHsNCj4gPiArCQlrdm1fZXJy
KCJMUEkgZG9tYWluIHVuaW5pdGlhbGl6ZWQsIGNhbid0IHNldCB1cA0KPiA+IEtWTSBEb29yYmVs
bHNcbiIpOw0KPiA+ICsJCXJldHVybiAtRU5PREVWOw0KPiA+ICsJfQ0KPiA+ICsNCj4gPiArCXZt
LT5md25vZGUgPSBpcnFfZG9tYWluX2FsbG9jX25hbWVkX2lkX2Z3bm9kZSgiR0lDdjUtdnBlLQ0K
PiA+IGRiIiwgaWQpOw0KPiANCj4gW1NldmVyaXR5OiBIaWdoXQ0KPiBDYW4gdGhpcyBsZWFrIHRo
ZSBHSUN2NSBWUEUgZG9vcmJlbGwgZG9tYWluIGFuZCBmd25vZGUgaWYNCj4gaW5pdGlhbGl6YXRp
b24NCj4gaXMgcmV0cmllZD8NCj4gDQo+IElmIHRoZSBpbml0aWFsaXphdGlvbiBmYWlscyBsYXRl
ciBpbiB0aGUgc2V0dXAgcHJvY2VzcyAoZm9yIGV4YW1wbGUsDQo+IGlmDQo+IGt2bV92Z2ljX3Nl
dHVwX2RlZmF1bHRfaXJxX3JvdXRpbmcoKSBmYWlscyBpbiB2Z2ljX2luaXQoKSksIHRoZSBWR0lD
DQo+IHN0YXRlDQo+IHJlbWFpbnMgdW5pbml0aWFsaXplZC4NCj4gDQo+IElmIHVzZXJzcGFjZSB0
aGVuIHJldHJpZXMgdGhlIGluaXRpYWxpemF0aW9uLCB0aGlzIGZ1bmN0aW9uIGlzIGNhbGxlZA0K
PiBhZ2Fpbg0KPiBhbmQgdW5jb25kaXRpb25hbGx5IGFsbG9jYXRlcyBhIG5ldyBmd25vZGUgYW5k
IElSUSBkb21haW4sDQo+IG92ZXJ3cml0aW5nDQo+IHRoZSBwcmV2aW91cyBwb2ludGVycyB3aXRo
b3V0IGZyZWVpbmcgdGhlbS4NCg0KSSd2ZSB1cGRhdGVkIHRoaXMgY29tbWl0IHRvIGNhbGwgdmdp
Y192NV90ZWFyZG93bigpIG9uIHN1YnNlcXVlbnQNCmZhaWx1cmUuIFRoaXMgd2F5IG5vIHN0YXRl
IGlzIGxlYWtlZC4NCg0KPiANCj4gDQo+IFtTZXZlcml0eTogTWVkaXVtXQ0KPiBDb3VsZCB1c2lu
ZyB0aGUgdGhyZWFkIElEIGhlcmUgY2F1c2UgZndub2RlIG5hbWluZyBjb2xsaXNpb25zPw0KPiAN
Cj4gU2luY2UgdGFza19waWRfbnIoY3VycmVudCkgaXMgdXNlZCBhcyB0aGUgSUQgZm9yIHRoZSBm
d25vZGUgbmFtZSwgYQ0KPiBzaW5nbGUNCj4gVk1NIHRocmVhZCBzZXF1ZW50aWFsbHkgY3JlYXRp
bmcgbXVsdGlwbGUgS1ZNIFZNcyB3aWxsIGNhdXNlIHRoZW0gdG8NCj4gc2hhcmUNCj4gdGhlIGV4
YWN0IHNhbWUgZndub2RlIG5hbWUuDQo+IA0KPiBXaGVuIHRoZSBJUlEgZG9tYWluIGlzIHJlZ2lz
dGVyZWQsIHRoaXMgZHVwbGljYXRlIG5hbWUgY2F1c2VzIGRlYnVnZnMNCj4gZGlyZWN0b3J5IGNy
ZWF0aW9uIGZhaWx1cmVzIGR1ZSB0byB0aGUgZGlyZWN0b3J5IGFscmVhZHkgYmVpbmcNCj4gcHJl
c2VudC4NCj4gDQo+IFdvdWxkIGl0IGJlIG1vcmUgcmVsaWFibGUgdG8gdXNlIHRoZSBWTSdzIHVu
aXF1ZSB2bV9pZCBpbnN0ZWFkPw0KDQpUaGUgY3VycmVudCBjb2RlIG1hdGNoZXMgd2hhdCBHSUN2
NCBkb2VzIGZvciB0aGUgZndub2RlLiBJbiBteQ0Ka25vd2xlZGdlLCBpdCBpc24ndCBhIGNvbW1v
biB0aGluZyBmb3IgYSBzaW5nbGUgdGhyZWFkIHRvIGNyZWF0ZQ0KbXVsdGlwbGUgVk1zLiBJZiB0
aGlzIGlzIGluZGVlZCBhbiBpc3N1ZSwgaXQgY2FuIGJlIHJldmlzaXRlZCBhbmQNCmZpeGVkLCBi
dXQgdGhlIGZvciB0aGUgdGltZSBiZWluZyBJIHN1Z2dlc3QgbGVhdmluZyB0aGlzIGFzIGlzLg0K
DQo+IA0KPiA+ICsJaWYgKCF2bS0+Zndub2RlKQ0KPiA+ICsJCXJldHVybiAtRU5PTUVNOw0KPiBb
IC4uLiBdDQo+ID4gKwlkYl92aXJxID0gaXJxX2RvbWFpbl9hbGxvY19pcnFzKHZtLT5kb21haW4s
IG5yX3ZjcHVzLA0KPiA+IE5VTUFfTk9fTk9ERSwgdm0pOw0KPiA+ICsJaWYgKGRiX3ZpcnEgPD0g
MCkgew0KPiA+ICsJCXJldCA9IGRiX3ZpcnE7DQo+ID4gKwkJZ290byBlcnI7DQo+ID4gKwl9DQo+
ID4gKw0KPiA+ICsJa3ZtLT5hcmNoLnZnaWMuZ2ljdjVfdm0udnBlX2RiX2Jhc2UgPSBkYl92aXJx
Ow0KPiA+ICsNCj4gPiArCXJldHVybiAwOw0KPiA+ICsNCj4gPiArZXJyOg0KPiA+ICsJaWYgKGRi
X3ZpcnEgPiAwKQ0KPiANCj4gW1NldmVyaXR5OiBMb3ddDQo+IElzIHRoaXMgZXJyb3IgY2xlYW51
cCBwYXRoIHVucmVhY2hhYmxlPw0KPiANCj4gVGhlIG9ubHkgYnJhbmNoIHRoYXQganVtcHMgdG8g
dGhlIGVyciBsYWJlbCBhZnRlciBtb2RpZnlpbmcgZGJfdmlycQ0KPiBleHBsaWNpdGx5IGNoZWNr
cyB0aGF0IGRiX3ZpcnEgaXMgbGVzcyB0aGFuIG9yIGVxdWFsIHRvIDAuDQo+IA0KPiBCZWNhdXNl
IGRiX3ZpcnEgY2FuIG5ldmVyIGJlIHN0cmljdGx5IHBvc2l0aXZlIGF0IHRoaXMgbGFiZWwsIHRo
ZQ0KPiBpcnFfZG9tYWluX2ZyZWVfaXJxcygpIGJsb2NrIHdpbGwgbmV2ZXIgYmUgZXhlY3V0ZWQu
DQoNClRydWUuIERyb3BwZWQgdGhlIHVucmVhY2hhYmxlIGNvZGUuDQoNCj4gDQo+ID4gKwkJaXJx
X2RvbWFpbl9mcmVlX2lycXMoZGJfdmlycSwgbnJfdmNwdXMpOw0KPiA+ICsJaWYgKHZtLT5kb21h
aW4pDQo+ID4gKwkJaXJxX2RvbWFpbl9yZW1vdmUodm0tPmRvbWFpbik7DQo+IFsgLi4uIF0NCj4g
DQoNClRoYW5rcywNClNhc2NoYQ0K
