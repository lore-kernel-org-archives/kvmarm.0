Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012036.outbound.protection.outlook.com [52.101.66.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF3472D0C7B
	for <kvmarm@lists.linux.dev>; Mon, 27 Oct 2025 12:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.36
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761566517; cv=fail; b=HO9ey/OWF4yGSPCcFqV06+VBZzcC0QZfCStT65GzD94RTcErkz6Ng2G6i5nqqDLz2152k2wVJleiBznt21Ug7ctNexRcMX/Bi2708aOi7EyrIinZ051dgAPVp2LeehsT2cGqsOtFysGvuvvR3n9B7IKl3NXziIiTFX6/RxiG+aU=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761566517; c=relaxed/simple;
	bh=s31Av9v1YL6+NhgM243AAZj+LBkWodVOZKV63w25QLY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=CtQMLdgGX/TWxPYBjgKErSqDrextsl5JkcaBN6qxNM3/Z9Z+T66O4XeLA1hLTNzEuiq+QIvEY9d/VNGIIhe+oUojKGn6Lg1DFrKnWX2/MXzyF77DeAIpCPtfdjlUaXL5f4UqHr3uj1hjs0DxE2OJ7MAByosSDhIfYqZalQPoLM4=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=S+qkKhU5; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=S+qkKhU5; arc=fail smtp.client-ip=52.101.66.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="S+qkKhU5";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="S+qkKhU5"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=oSDLCm882gU813zI3dGkXp3Ye2TysHVyzvSTuJ+S6RzZGqviEFFbxwUnmyGd0EeGcOGlBpVKDr9QBVoyUTXqA1sBXs/6QKcgZTsTB2WSdGAAkK/ckXLPEqv5pKvRn0SgwxpcCHriupf8sXpKFJ7Bjh5YvHaDvMJ6Fe47pIX6Rt5QdsUlRusCU9Y80BD99XLTHvHFJUs8v/i6wFrlL+hx7ux8N3Y2OtdXyOnF7DRpnz1MJ8qLMPaoksnwqNiYXJsdtmzyIgR/Git5akfLQDdhhFxFAEF5dh5XC/yDZBGibUCwCzYiA6O7TFV1GkLG47ETPzfRhkaQhdXwyKHa4TYekQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s31Av9v1YL6+NhgM243AAZj+LBkWodVOZKV63w25QLY=;
 b=gPhnDzQ6BWPr0cqOZIc7+BNB70fACv7zkBDZ4XAm1dERxwxiBL3KLgdnYLRI3NVEQLPvJOwAWllVMj0/AFyXEwwZBPOzHMTKFSlZcJ3bJ9kRR1EiUfa3h+YZ+kbgp/CvqeLYsHnJxk+THVwfgr5EamOduwnQC116h4+gfkkEtPakv2f93DMzTq/Uo/iVUyaIyGvrVqRM8U3bUf2zkzihY3r/0u5Ezz01HJubQXRlyD0S0y3jKI1/EO9HyokMsHhDT535E9Lv+hal1UDtpmmVLN3/Xju4ZNxDw6eY0+tlYe/EnfgXP8HHBmFF3pGSJXHroxFm6JI9jXZ72QD6Qwt3QQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s31Av9v1YL6+NhgM243AAZj+LBkWodVOZKV63w25QLY=;
 b=S+qkKhU53jvbCjNp3TPiaAv7Y6lfoE2V7O5a0aZG+KLKJW+Llpskqr1V1cv2PYA0/+Iu7ymDha1XrZrZ83gpzkU+e7vLkJCHZ7klRxNywFqWQBXCEyZPKaMaG7cXoSepHs57qzQxFuqoiEpuip477ieCMhULCtEXynxbUCQq7mk=
Received: from AM0PR02CA0183.eurprd02.prod.outlook.com (2603:10a6:20b:28e::20)
 by DB9PR08MB9636.eurprd08.prod.outlook.com (2603:10a6:10:45c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.18; Mon, 27 Oct
 2025 12:01:51 +0000
Received: from AM3PEPF0000A796.eurprd04.prod.outlook.com
 (2603:10a6:20b:28e:cafe::ad) by AM0PR02CA0183.outlook.office365.com
 (2603:10a6:20b:28e::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9253.18 via Frontend Transport; Mon,
 27 Oct 2025 12:01:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM3PEPF0000A796.mail.protection.outlook.com (10.167.16.101) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9275.10
 via Frontend Transport; Mon, 27 Oct 2025 12:01:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Kmjbjd5nghrMhQbW9mmkku0g/t7sCOk+QTs/6mAfHeuR33cSwzdC0PFXVsSFhI+4AKHkmeTDOZKUZSchXy1pkYdcP1XSoIxFy0VipTD+GgWDM/tNaTqpT58CBM0eBBSAGgEDsDlGeTfSKsUXT41CPow/L7GWrfyJTq1+xCaGXoWZ8x3CuRU/Dq+xF07PsmUIZ2J8l7n2XtWg2qb/fkZDkOszagSVX8mfvsSlsxzZangFUDnQ3OIvDdYSDr/54zRrRkRU2dQAOahvnIzseUVgOoQQ5nmyT70L2PVbROy8rH68Co3fgUN8a9WtJE7laRINRRxRRqs9heHBWFd0KpRaBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s31Av9v1YL6+NhgM243AAZj+LBkWodVOZKV63w25QLY=;
 b=U+GaRcgau7kubTor54lPIRD6l85jq0iB9wAEamc63FTrVZJHQob/AkHImZ2+K70ymqKEiM7RZKeS+rsvCGA6CXhedMKSUQn5B4x4WRMfGIcJzel3vQibGeYbK9PNw4Wajm6MBPn+KhG+Wb+pyAWeIXnzKSWoii7UR7Kruu0bqq6D0IjCq2ziFR+i/lbQMzdp+LQdDu/nRRdtm4GhDmSrLrlsO+3w2r97D6RN4GCB137RCj94hkSNNn2qfSoiQozFMnSWNE+N5mx5lXeh93vPBUVJMzwAYNa/O62uaPrqSL67H7cmJejK6Gk01YGyS3g9hZ7qI8kHlriL6UgaropNIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s31Av9v1YL6+NhgM243AAZj+LBkWodVOZKV63w25QLY=;
 b=S+qkKhU53jvbCjNp3TPiaAv7Y6lfoE2V7O5a0aZG+KLKJW+Llpskqr1V1cv2PYA0/+Iu7ymDha1XrZrZ83gpzkU+e7vLkJCHZ7klRxNywFqWQBXCEyZPKaMaG7cXoSepHs57qzQxFuqoiEpuip477ieCMhULCtEXynxbUCQq7mk=
Received: from AM9PR08MB6850.eurprd08.prod.outlook.com (2603:10a6:20b:2fd::7)
 by PA6PR08MB10567.eurprd08.prod.outlook.com (2603:10a6:102:3cc::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.18; Mon, 27 Oct
 2025 12:01:15 +0000
Received: from AM9PR08MB6850.eurprd08.prod.outlook.com
 ([fe80::e3e:d073:8744:60e2]) by AM9PR08MB6850.eurprd08.prod.outlook.com
 ([fe80::e3e:d073:8744:60e2%4]) with mapi id 15.20.9253.017; Mon, 27 Oct 2025
 12:01:15 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "maz@kernel.org" <maz@kernel.org>, "sebott@redhat.com"
	<sebott@redhat.com>, "oliver.upton@linux.dev" <oliver.upton@linux.dev>
CC: "yuzenghui@huawei.com" <yuzenghui@huawei.com>, Suzuki Poulose
	<Suzuki.Poulose@arm.com>, nd <nd@arm.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "will@kernel.org" <will@kernel.org>,
	Joey Gouly <Joey.Gouly@arm.com>
Subject: Re: Failing no-vgic-v3 test
Thread-Topic: Failing no-vgic-v3 test
Thread-Index: AQHcRzYoSBMKlXrUG0yIiW6aO4sTtrTV5FwA
Date: Mon, 27 Oct 2025 12:01:14 +0000
Message-ID: <985e9c0d9079ea2a27114a8b088ddf10482e1f37.camel@arm.com>
References: <f9c7fffa-53ba-a506-b48b-07e3df2d1d5a@redhat.com>
In-Reply-To: <f9c7fffa-53ba-a506-b48b-07e3df2d1d5a@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AM9PR08MB6850:EE_|PA6PR08MB10567:EE_|AM3PEPF0000A796:EE_|DB9PR08MB9636:EE_
X-MS-Office365-Filtering-Correlation-Id: 5d5dd2c7-4da3-4349-d63a-08de15509c10
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|1800799024|376014|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?cG1yN0d3TWpPNEc1NlhYWW1xQlIwbHpGR0NGVExSZWdzQkdEeFZHUWFlRUND?=
 =?utf-8?B?L1g2anZvYUgrYUIvVnVZRitzME5GSVpoeVJZOVl0dnNMZDEyYTRNQkRRYjJz?=
 =?utf-8?B?Q1JZcjFZQnBWRm5UK3Z2anRYTWttbkhKTWgxT2p2QnduVHFCM3VOMytTVEVT?=
 =?utf-8?B?bEZCM3FuQlBkb0F0YWpNTFo4OWVKeS91ZTdNKzh1ZXYyU3Q5YWlwUGZmZjh6?=
 =?utf-8?B?cXBGcEh3UjREalZNbjdZcStEUllGV242SXhybTVYek81ZkxueE52TjNnQ3pK?=
 =?utf-8?B?WUV2aUZxa3BoQWVIVUJEUVhmYytjZzFGWWUwaFluZWpFUzlOM3EvL204MExn?=
 =?utf-8?B?cmp5dzNxYzlZbmdCZndoQzNzSmhkN0h5bHZza01NSGRvTXBhVzdncTJpOGFM?=
 =?utf-8?B?aUY5WkFlMnNnTlpNSm1VUGVYbUNia2Vvalo5anJsK0R3dkJvd0hUK0xXZlhL?=
 =?utf-8?B?TkNWTk9SS0YyV2g2aFc2YXNDMWN3V1pFMHZDV1FUZkNVOUZXTDNiVVBoUkFa?=
 =?utf-8?B?NzhHR2ozSlhOdWNpdTVSMHJ0Z1dUYkZrZ1ZDU0Y5YmpESm9zNi9vMnEzNi9u?=
 =?utf-8?B?cFNleGpUMDFWUS9XakVFZVhtMC9BT1R4VVdOL1RrY0NWdWxsSFVpZHRlaG1z?=
 =?utf-8?B?ekhId0hsWFFxbHhVeEx4ZUV2eGdFTGxWaGJUZjF2TzFXSVdCbDE0NDdsQVlJ?=
 =?utf-8?B?STdnMlAyME5GRlZGY3ZsVGRZUGhndjJJMmp6TDBvdXRxd29CbDZRSjFGNTky?=
 =?utf-8?B?VWxxODVvR0g5dTk3ZDdzU2lOb2xkZ3ladGJGQ3cyeURjU0hwc0VQVXV6bEpa?=
 =?utf-8?B?Z1BHWDZDT2lxYUdLd2NianRzT3U1RmJKOWErRmhUczFkVDF2Uit3R2w5eDBm?=
 =?utf-8?B?TkpBL1dIY0xUdE9tdmJ2RDNUUmpBNUEvVEk1MjlJQkNSTzY4TkF1UkJUQ1dh?=
 =?utf-8?B?d0RjNFpFMTF6WVYxWWNYcFhVcmllYkNaYUVXQ3FscFJNbzhFaCtZdU9XbmE5?=
 =?utf-8?B?bUtwLzRDcWxPcUVNd3hWZHR0aVBKN1F4WFE0VnhGQzRtb3lmcFVxZ1RKRnZT?=
 =?utf-8?B?YUJYS1NMalA0SUxmOXp6K3ZGbTc5eU02T3RGK0k2SVRuUUh1L0ROVUU1L0c4?=
 =?utf-8?B?VW45LzZZOEhVaHhxM2owanhUY1JDNGVuUEhXYTlqbXpNSG5WOEVZSVJ0WDd0?=
 =?utf-8?B?Umk0ZmhYSjJMSU1VWnhBcnFMOGovL2l5VFB5alFZdlpUS0hPOThxMnl0YnZq?=
 =?utf-8?B?cGxRTkF2cTU2Z1ZnQWdwc0lZWEtKaWhYQ0dzSG1ZTzJGNytkQWxKV2duRW9o?=
 =?utf-8?B?TWt5YXpjWGlEbTJMaytHQzZtS0lRd1duSFRxVWJlc0VxTVhTMkdsZHV5dUdy?=
 =?utf-8?B?VFRneXVCZyt4eDRoUzdCckhMR3V1cE9iZ0M0dmk2SDEzVGNzcFVmRzV5dmtG?=
 =?utf-8?B?NzVpaEh5RnpvZWdzVzRnSUxxNXdMcDFzQ0lBcTlldGY3Q05BaUY5OWVFajRF?=
 =?utf-8?B?MG1zK0k0MHVoZHlHc1VXVEJjNW5YQ1Q4OUxyejdISitzRDgrVFo2L3pYSXpt?=
 =?utf-8?B?dVBtUGhzQkM0bkYwbnYveGtrSGJ0TjNMOEc4OFo2K1FiMzlqZ1F2ekFmSzlu?=
 =?utf-8?B?ZlhpSjVqK3R6TnQ1TTlQQnk5dy9ldFg1Ri9BYzB3K2FuZTgwLzR2d2RDcjQz?=
 =?utf-8?B?MGhaazg5K2F2R25FK1FMa0RrbTFWNVJXRjdQZEU3a3I5WnZRdUhTa0RpWjhS?=
 =?utf-8?B?ZTA1K1BVRUtXak9VTTNVU05ObG03OVU4djAzRGV2QzVZaVpES21kOFdwKzZU?=
 =?utf-8?B?NEtldENtSi9SVjkwYzlPMEQwL1lITEpwTkpEeWx0NTZRYWtyMG5qbHFZQ3cx?=
 =?utf-8?B?WXg5dkFhNjFMTGM4czV4cG5tWUpuMlRUQmdLQVVrNGNOclFxemx6V24zTEhP?=
 =?utf-8?B?NGV5SXQvZU44YVAzNFZGc2dyTlU2K3V1VzYzd2Ntak5KS1FRVFFERmw5VmFy?=
 =?utf-8?B?a0F6WGVLRExOaUpmM3JqZXVnaUt3aHQrTVorVXpOY1ROeUxRejNER2RYRnBZ?=
 =?utf-8?Q?QQdVsf?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR08MB6850.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <0911854DB4E7F94780007F4BD2B09D11@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA6PR08MB10567
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM3PEPF0000A796.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	6d5e27a3-8fa8-4249-0210-08de15508794
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|36860700013|1800799024|376014|14060799003|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?M3A5Njl6R0YzR254TnRtUTJhWTBSQm5hd0VvbnhvOFlxSGgzZ0ZtMGJCd1Jn?=
 =?utf-8?B?MUVqWDJyWXdrd2kxSWhSalRlYmxjb2w3NUhoVzBVeXlEbmhUYTlCdTBla0JZ?=
 =?utf-8?B?QVk1c3NKTjdlMEVWaDZqR2RmQTl0Y2hxUFBPOENzd0grU0F0RllUVFl6Tm5y?=
 =?utf-8?B?TFlEQWkyTk9VNXBXbGxEOC9kRVlWbVpQeTU3ZWpSM0czbElGcm5sYjZDd0di?=
 =?utf-8?B?eUVITkNBK3JBUm91UDd0UXBTSEtrYnRwT0JWenNJM1BqVEMvL3JtZ0Y4QUNZ?=
 =?utf-8?B?S1hZSVpIcU1XV0pFRkgvT2RnbnE4UEFRTTdGU2o2NTRlUHprMTR4b3hQbFNk?=
 =?utf-8?B?c3Z6b3Fhd3MrS1B3K3lsaGZKZUZmZWcxRk9Zdmt5Q3pIRGdHVUpGUmlqQU1T?=
 =?utf-8?B?ZjJkZm44UTl3Q2NYTGthTWtrVU9nUXNMdFZ1WTl2cUtiVU1UUU1DT25QZHVG?=
 =?utf-8?B?QVdjTHVxY0QrWDEvUmpIT1pQcUNEUGlIQ2U5TkRBZTdPdWQrZ1RLbTZSVjEv?=
 =?utf-8?B?c3MyYUpOU3h3d2YzeXN0ajFzTUxiUEMweGVTRjRTbTh0VjlsYm9Zei9LWjVU?=
 =?utf-8?B?YS8xejA5MlpJNU9JdEd5ZGNwUS9GTzhRa1UwSzRSWUtTdEtLWDJkdkJ2SEFZ?=
 =?utf-8?B?dDhDVG5GWFdjcGhpV1QvY2VDZ2V4MklaaEIxV3U4UUZHelZGRjJ3dUZaRDJD?=
 =?utf-8?B?eHc4N3dmM3MySFU1RUFxcW9Jb3dpcXVuay9na2VwNUFOZjloRllOdjZ2TUZO?=
 =?utf-8?B?VjBkOFhFd01YUVJob054Ty9lcWpVWUF1YTNJOGJpaWVpeHJSTFdmcFRPWDVW?=
 =?utf-8?B?cm5wcmljQmQrZGN6QXJWRHJIMytrOGZFbU5xNFlubnJ3REMwUHNWOHYxV0Fh?=
 =?utf-8?B?MXltUnppelRLZm1oQk1IMTJXbWtrUTJMMFZOQ3pIdFh6dGlZbTJuSFo1bHJq?=
 =?utf-8?B?bnBOVkdkMEh1SXk3dEdEVFQ2bHUrTC9DbWRmeFdUVUlsSldadDVTcmR0M013?=
 =?utf-8?B?ZW96d0JFUEgzSlFjSi9HS3lIMjNPWlR6bUhKWkN5MlpJVmdKajJhWm15R2E4?=
 =?utf-8?B?K05YMGtwOG1pVjlXR2ZyYlBhMU90UXkrRFBiNEltZ2hJRS9pZ3o2MHc3WkhC?=
 =?utf-8?B?SWo1U1Q3ZTFYQURXN2VhRDhwL3d5M2wyUFFmakZBRTJDK1Mwa3hGb0x0a2xQ?=
 =?utf-8?B?ZXYwby81MlM3aCsyQlYzUjE2L0RCRDVLVFdaY1NVcnBVUEZxL1BkMm9ENUZw?=
 =?utf-8?B?eTY0OC9KbE5xWkl6Y28rZHJqZGFBV3d4d24vUzRxMUpyWEh3bkU1VGhNQkxo?=
 =?utf-8?B?NjUvMDZLQTI3OWJYQWFxSjBhR1dZQUxzVU1vcmJpdlB2djRzUDRWaWJZV0lF?=
 =?utf-8?B?SXptV2MwaGNhdGN1ZVVLNGJlSzlncjN1cHAwNWFORWJqSVNLS08rSHZ0S2lz?=
 =?utf-8?B?QjV5eVhlVG1GZlMwUEJ4cnFyS0l6bHI0dnpnV0MrbjVCb3U0WnNSMXI2TVlt?=
 =?utf-8?B?NDRuVHBta213eU5mSGFnZEc0endXM1JvMGQ4QVQ2aTVvLzFVb2E4K0xNK2hz?=
 =?utf-8?B?bzJUUUttT0lmeTRXQ2dnQWpqKzBsUENCdmxrWXlTdnQ2YVp1QUFHT0ZkWWlQ?=
 =?utf-8?B?QzVIckFqTVUxZm1STjZuM0pxK3FXWDNyRmtzUmVYZmZjNFpkNlVMblM3Y1JL?=
 =?utf-8?B?UWVCc2FYQzd5Ny9wa2ZRM1o0bE0wRG5XVUdpVmxwU2U4VHpHRFBnZm50ZldS?=
 =?utf-8?B?VmhOdGw2YW1EV2t1U3ArVjdMYjVGdFJUWWxFajE1ZkJMbEF5QnJlZGVVelkv?=
 =?utf-8?B?Y2N2ZGVwZS9vUDZiUUp2V3JRRllJQkk5SXBzckdaVWY2LzZ5N3Z5OEVKSXVu?=
 =?utf-8?B?dFpaR0MwZWdiN1NmWk0zVTAwaUlxbUQvUDEveGcyU05hM3JLK2pDaXZOSDJk?=
 =?utf-8?B?ckduZHlCb3lGWlhHWDhsaXhNSUtqclNCUHJaQjdpWWhvWlJLeUFWZ0dvZkVO?=
 =?utf-8?B?SnNaQ3ByQlBld056eDh6Tkdya2hCY3dvT0VEbTBkUEVIY1BPd2QwQjF3MERM?=
 =?utf-8?B?dE1qRzV0dGNkQTRrS25XbDM2dzk5UTE3T1pxbGxMUVlsZk5TUXdPbDEwYlV0?=
 =?utf-8?Q?yEu8=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(36860700013)(1800799024)(376014)(14060799003)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2025 12:01:49.2011
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d5dd2c7-4da3-4349-d63a-08de15509c10
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM3PEPF0000A796.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB9636

T24gTW9uLCAyMDI1LTEwLTI3IGF0IDEyOjM3ICswMTAwLCBTZWJhc3RpYW4gT3R0IHdyb3RlOg0K
PiBIZXksDQo+IA0KPiBvbiBhbiBhbXBlcmUgYWx0cmEgSSd2ZSBnb3QgYSBzYWQgc2VsZnRlc3Q6
DQo+IA0KPiBbcm9vdEB2aXJ0bGFiLWFybTExIGt2bV0jIC4vYXJtNjQvbm8tdmdpYy12Mw0KPiBS
YW5kb20gc2VlZDogMHg2YjhiNDU2Nw0KPiA9PT09IFRlc3QgQXNzZXJ0aW9uIEZhaWx1cmUgPT09
PQ0KPiDCoMKgIGFybTY0L25vLXZnaWMtdjMuYzo2NjogaGFuZGxlZA0KPiDCoMKgIHBpZD0zNzkz
IHRpZD0zNzkzIGVycm5vPTQgLSBJbnRlcnJ1cHRlZCBzeXN0ZW0gY2FsbA0KPiDCoMKgwqDCoMKg
IDHCoCAweDAwMDAwMDAwMDA0MDJmZWI6IHRlc3RfcnVuX3ZjcHUgYXQgbm8tdmdpYy12My5jOjEy
OA0KPiDCoMKgwqDCoMKgIDLCoCAweDAwMDAwMDAwMDA0MDIxNGY6IHRlc3RfZ3Vlc3Rfbm9fZ2lj
djMgYXQgbm8tdmdpYy12My5jOjE1NQ0KPiAoZGlzY3JpbWluYXRvciAxNykNCj4gwqDCoMKgwqDC
oCAzwqDCoCAoaW5saW5lZCBieSkgbWFpbiBhdCBuby12Z2ljLXYzLmM6MTc0IChkaXNjcmltaW5h
dG9yIDE3KQ0KPiDCoMKgwqDCoMKgIDTCoCAweDAwMDBmZmZmODczZWI1ODc6ID8/ID8/OjANCj4g
wqDCoMKgwqDCoCA1wqAgMHgwMDAwZmZmZjg3M2ViNjVmOiA/PyA/PzowDQo+IMKgwqDCoMKgwqAg
NsKgIDB4MDAwMDAwMDAwMDQwMjJhZjogX3N0YXJ0IGF0ID8/Oj8NCj4gwqDCoCBJQ0NfUE1SX0VM
MSBubyByZWFkIHRyYXANCj4gDQo+IFRoaXMgaXMgYSBndWVzdCB3aXRob3V0IFZHSUN2MyBvbiBH
SUN2MyBIVy4gVGhlIHRlc3QgZXhwZWN0cyBVTkRFRiBvbg0KPiByZWcNCj4gYWNjZXNzIC0gd2hp
Y2ggaXMgbm90IGhhcHBlbmluZyBzaW5jZToNCj4gDQo+IDMxOTMyODdkZGZmYiBLVk06IGFybTY0
OiBnaWMtdjM6IE9ubHkgc2V0IElDSF9IQ1IgdHJhcHMgZm9yIHYyLW9uLXYzDQo+IG9yIHYzIGd1
ZXN0cw0KPiANCj4gQXMgYSBsb2NhbCBmaXggSSd2ZSBkb25lOg0KPiBkaWZmIC0tZ2l0IGEvYXJj
aC9hcm02NC9rdm0vdmdpYy92Z2ljLXYzLmMNCj4gYi9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMt
djMuYw0KPiBpbmRleCA2ZmJiNGIwOTk4NTUuLjFmZTUzYTAyMTkyNiAxMDA2NDQNCj4gLS0tIGEv
YXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLXYzLmMNCj4gKysrIGIvYXJjaC9hcm02NC9rdm0vdmdp
Yy92Z2ljLXYzLmMNCj4gQEAgLTI5NywxMSArMjk3LDE1IEBAIHZvaWQgdmNwdV9zZXRfaWNoX2hj
cihzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpDQo+IMKgIHsNCj4gwqDCoAlzdHJ1Y3QgdmdpY192M19j
cHVfaWYgKnZnaWNfdjMgPSAmdmNwdS0NCj4gPmFyY2gudmdpY19jcHUudmdpY192MzsNCj4gDQo+
IMKgwqAJaWYgKCF2Z2ljX2lzX3YzKHZjcHUtPmt2bSkpDQo+IMKgwqAJCXJldHVybjsNCj4gDQo+
IMKgwqAJLyogSGlkZSBHSUN2MyBzeXNyZWcgaWYgbmVjZXNzYXJ5ICovDQo+IC0JaWYgKHZjcHUt
Pmt2bS0+YXJjaC52Z2ljLnZnaWNfbW9kZWwgPT0NCj4gS1ZNX0RFVl9UWVBFX0FSTV9WR0lDX1Yy
KSB7DQo+ICsJaWYgKCFrdm1faGFzX2dpY3YzKHZjcHUtPmt2bSkgfHwNCj4gKwnCoMKgwqAgdmNw
dS0+a3ZtLT5hcmNoLnZnaWMudmdpY19tb2RlbCA9PQ0KPiBLVk1fREVWX1RZUEVfQVJNX1ZHSUNf
VjIpIHsNCj4gwqDCoAkJdmdpY192My0+dmdpY19oY3IgfD0gKElDSF9IQ1JfRUwyX1RBTEwwIHwN
Cj4gSUNIX0hDUl9FTDJfVEFMTDEgfA0KPiDCoMKgCQkJCcKgwqDCoMKgwqAgSUNIX0hDUl9FTDJf
VEMpOw0KPiDCoMKgCQlyZXR1cm47DQo+IA0KPiANCj4gYnV0IGZvbGxvd2luZyB0aGUgaW50ZW50
aW9uIG9mIHRoZSBwYXRjaCBhYm92ZSBtYXliZSB3ZSBzaG91bGQgZG8NCj4gc210aA0KPiBsaWtl
Og0KPiBkaWZmIC0tZ2l0IGEvYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLXYzLmMNCj4gYi9hcmNo
L2FybTY0L2t2bS92Z2ljL3ZnaWMtdjMuYw0KPiBpbmRleCA2ZmJiNGIwOTk4NTUuLjFmZTUzYTAy
MTkyNiAxMDA2NDQNCj4gLS0tIGEvYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLXYzLmMNCj4gKysr
IGIvYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLXYzLmMNCj4gQEAgLTI5NywxMSArMjk3LDE1IEBA
IHZvaWQgdmNwdV9zZXRfaWNoX2hjcihzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpDQo+IMKgIHsNCj4g
wqDCoAlzdHJ1Y3QgdmdpY192M19jcHVfaWYgKnZnaWNfdjMgPSAmdmNwdS0NCj4gPmFyY2gudmdp
Y19jcHUudmdpY192MzsNCj4gDQo+IMKgwqAJaWYgKCF2Z2ljX2lzX3YzKHZjcHUtPmt2bSkpDQo+
IMKgwqAJCXJldHVybjsNCj4gDQo+IMKgwqAJLyogSGlkZSBHSUN2MyBzeXNyZWcgaWYgbmVjZXNz
YXJ5ICovDQo+IC0JaWYgKHZjcHUtPmt2bS0+YXJjaC52Z2ljLnZnaWNfbW9kZWwgPT0NCj4gS1ZN
X0RFVl9UWVBFX0FSTV9WR0lDX1YyKSB7DQo+ICsJaWYgKGt2bV9oYXNfZmVhdCh2Y3B1LT5rdm0s
IElEX0FBNjRQRlIwX0VMMSwgR0lDLCBOSSkgfHwNCj4gKwnCoMKgwqAgdmNwdS0+a3ZtLT5hcmNo
LnZnaWMudmdpY19tb2RlbCA9PQ0KPiBLVk1fREVWX1RZUEVfQVJNX1ZHSUNfVjIpIHsNCj4gwqDC
oAkJdmdpY192My0+dmdpY19oY3IgfD0gKElDSF9IQ1JfRUwyX1RBTEwwIHwNCj4gSUNIX0hDUl9F
TDJfVEFMTDEgfA0KPiDCoMKgCQkJCcKgwqDCoMKgwqAgSUNIX0hDUl9FTDJfVEMpOw0KPiDCoMKg
CQlyZXR1cm47DQo+IA0KPiBUaG91Z2h0cz8NCj4gU2ViYXN0aWFuDQo+IA0KDQpIaSBTZWJhc3Rp
YW4uDQoNCkFwb2xvZ2llcyAtIEkgYnJva2UgdGhhdCB0ZXN0IGJ5IGZhaWxpbmcgdG8gY29uc2lk
ZXIgdGhhdCBpdCBpcw0KcG9zc2libGUgdG8gbm90IGNyZWF0ZSBhbiBpbi1rZXJuZWwgdmdpYy4g
V2UgbmVlZCB0byB0cmFwIGFsbCBhY2Nlc3Nlcw0Kb24gYSBHSUN2My1jb21wYXRpYmxlIGhvc3Qg
aWYgZWl0aGVyIHdlJ3JlIHJ1bm5pbmcgYSBHSUN2MiBndWVzdCwgb3IgaWYNCndlIGRvbid0IGhh
dmUgYW4gaW4ta2VybmVsIHZnaWMgYXQgYWxsICh0aGUgY2FzZSBJJ2QgbWlzc2VkKS4NCg0KSSBw
b3N0ZWQgYSBmaXggZm9yIHRoYXQgdGhlIG90aGVyIGRheToNCg0KaHR0cHM6Ly9sb3JlLmtlcm5l
bC5vcmcvYWxsLzIwMjUxMDIxMDk0MzU4LjE5NjM4MDctMS1zYXNjaGEuYmlzY2hvZmZAYXJtLmNv
bS8NCg0KQ291bGQgeW91IHBsZWFzZSB0cnkgdGhlIGZpeCBhbmQgY29uZmlybSBpZiBpdCB3b3Jr
cyBmb3IgeW91Pw0KDQpUaGFua3MsDQpTYXNjaGENCg0K
