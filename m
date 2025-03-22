Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11012046.outbound.protection.outlook.com [52.101.66.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A53A21F8EEE
	for <kvmarm@lists.linux.dev>; Sat, 22 Mar 2025 13:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.46
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742651679; cv=fail; b=VSYxx4QOlqlz2jGr7T7H4PrQO6R7p+z2PRwRqW9ZGd4oFVadWaCfpd7CRmw3bWWLAClUiXREAfepm/gntWgiKOD576xkG8P2tGDy3a/u0eBtU/7fBf+oPpmFMbeZ2806tShpUeODmYscsCoRAKnT3yQvQ9vl33sWYa3eljFDt8Y=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742651679; c=relaxed/simple;
	bh=cLqANp4ef6QYH2nVJ/MdJHoobmsJVSv2KjmPtdMWdds=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=OH5qRP8uN9A+S/IlVhuWA9kiHbUtC+B0E0Xs8wunqJkyO+vEWoTNEMCiUosrALITn863vg13lyKLjKgwtfFh8JIyX28O2vxYE4ABQwtWvt9nBbgIvJl4mcagH/3enX7DWfrNrlv9BGUzjqnU8yS2IxGh9CVclGYDZOHsht9mgQE=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=mP5W1oGw; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=mP5W1oGw; arc=fail smtp.client-ip=52.101.66.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="mP5W1oGw";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="mP5W1oGw"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=K6RVbTdQBlVbfcXf4IzJprsbIJZ8YFr+fX+aoVFO5nHfh8i0GxTkrpR0iAG3p2Gs1C0TO5xmnUlPt/b5QUXGrtJEOrgh6NlQAFH25gNZgbE1DX3Ie9kjynUbLltewEG4+o5m+Z4RY4uRPrPI0iAQwBIYZgYsn/PQaIViqbKvYzemaKzxjOAzttPQt+DYASxKiIxlN1asdblmXSHKGGbm0xRiYcxiD8dmFs6UgMBouNdiL9jUu52WIvaEBCvoba12bYSyxZjLsplWbuBnjyWZJcJXbnnjkGZWgh7THQ5hfa6ttbI5dd6fOxD1qx1mFiZ+2nMHS4r4gS6D+z6sk+JQAg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cLqANp4ef6QYH2nVJ/MdJHoobmsJVSv2KjmPtdMWdds=;
 b=eMlDASUlqrIm2WdbNjjBUq8FCm2aXHCNxhzTUIYzhBtS3fCxDWKwF/cMkEqCAyXORWoSIgaawTdrtumYZktFOifN2zjl/LcuX58oTGlpgInkbOqJ9Q14rsV5CQNyOaKQlklgcNp4nW2ysKnz280VZhCMwi8etiIg0ygkr7w/f5/v8fTWTPvERxanRyHdC+A5ii/W8Wdp+1TwT5M4CU0nk62vJImPcAI50A77Ls93l4WSNO04VJ5y8pOysA+2rQG4+uzh5o8X2bPqlvPhAdMi/9v2JnAp7BRu8KQQxQ3vBxLzQd6OyxRQoR3Rb1Q8H+g2NNRX0G2vcQTKb9u13hHzBQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 63.35.35.123) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cLqANp4ef6QYH2nVJ/MdJHoobmsJVSv2KjmPtdMWdds=;
 b=mP5W1oGwZN2j5XDG6QXGaApH1e2bykyPGX9XbMrFAk6XNB8NyZi4sh5PfjKpV+X2KiuUpGqSn02o0pS5BbrzQcx+F1OGMGkIbxtgdWk5jPzsMR0YtUzlHx9Era6Q1P/+GLRQ/SpvtWTndmCiAKnwGtfS9teg8mo6yu4mhdHa+Rg=
Received: from SV0P279CA0051.NORP279.PROD.OUTLOOK.COM (2603:10a6:f10:13::20)
 by PAXPR08MB7441.eurprd08.prod.outlook.com (2603:10a6:102:2b9::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.35; Sat, 22 Mar
 2025 13:54:29 +0000
Received: from AM4PEPF00027A5F.eurprd04.prod.outlook.com
 (2603:10a6:f10:13:cafe::74) by SV0P279CA0051.outlook.office365.com
 (2603:10a6:f10:13::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8534.40 via Frontend Transport; Sat,
 22 Mar 2025 13:54:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
 pr=C
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AM4PEPF00027A5F.mail.protection.outlook.com (10.167.16.74) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8534.20
 via Frontend Transport; Sat, 22 Mar 2025 13:54:28 +0000
Received: ("Tessian outbound 79edf4140b33:v597"); Sat, 22 Mar 2025 13:54:28 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: f197257e67d43246
X-TessianGatewayMetadata: FQimT0uNdnrxc3SEn67aUEzPihdgyH0tCWnmK0jbQojZDKYKBf61BC3GrpraIdRM8JI98LQAiGvzN6BX9TXl4sz1s8ikwvcS/6zU+kqjxNePTEZ1gYFXPV2RdcLKMP0qd0IkXq1fVsbplOT9RBWXJ0Mw24ubCzwWAudpmRtjn3MoEd7XJUPrOoiaLP/benosr/CR4LAc3OO7BdZMXHDpCg==
X-CR-MTA-TID: 64aa7808
Received: from L2e4e36ce01ff.2
	by 64aa7808-outbound-1.mta.getcheckrecipient.com id 259975D4-04E2-460A-A360-D6761CA52D46.1;
	Sat, 22 Mar 2025 13:54:21 +0000
Received: from AS8PR04CU009.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id L2e4e36ce01ff.2
    (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
    Sat, 22 Mar 2025 13:54:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=W1m+kzWl3H6I8pRtsqeyOKWC4fmQJhxr9QsWqD5/uUgrVXewo3V4htoZohBabuOkpZNvoCFyhswaKpD4d+x/kO7azDO6x3Geb5OyY7PO1LLzbnSIcNZYNO11dafnWC6qWWzgHSYz/iARDKa3zXxJv97znq8be0FvHQRMtxI3feG2QKtEkiy3hJpwXus0QjdtGdDfCbUAwUNxoYJleODYqrZIX7YjjCG7FPTqzk3iKERdbLVFHEdsrc5O814/2DEFOYLV7RZpX08RlGYtO2yI3A8sUirN0embL6yDi4qzWOqbZNVAWplAZQLI6Oo6Okx4oNUqgl9HLPVweIlNpcy9/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cLqANp4ef6QYH2nVJ/MdJHoobmsJVSv2KjmPtdMWdds=;
 b=rVi1E3A727wcsBP1paL6kUid6yW7bbE7wn+qZ+KKQQLZYzyj8H2UyX4k/L6+UQcmzRwupVY//Yiq70wpOGlgSx7O42P8odML5pnMq9/bgRbi32lUS4C1ng/TfOptwbIKDPvXSUd4FwC0OZgLOb4i7YwW1zqOwUfI1/Kt2l2PzIAwtauO7/aOFBXUvfOHr8e/BE4XMOYKAU777jIdSH8NoDLsV+ENDYbQD5Hy+gEJKV7SQQ6gv7UwqEmNNfnxp17oXIU4Ue/kFJ2MeXuxYW2seEi/z6aKk5oBdVKQROV7HKzBplo+kHRiEnCfmu+vLnDLD7ls7kuDFtHZGkBylQbSQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cLqANp4ef6QYH2nVJ/MdJHoobmsJVSv2KjmPtdMWdds=;
 b=mP5W1oGwZN2j5XDG6QXGaApH1e2bykyPGX9XbMrFAk6XNB8NyZi4sh5PfjKpV+X2KiuUpGqSn02o0pS5BbrzQcx+F1OGMGkIbxtgdWk5jPzsMR0YtUzlHx9Era6Q1P/+GLRQ/SpvtWTndmCiAKnwGtfS9teg8mo6yu4mhdHa+Rg=
Received: from GV2PR08MB9206.eurprd08.prod.outlook.com (2603:10a6:150:d5::6)
 by PAWPR08MB9121.eurprd08.prod.outlook.com (2603:10a6:102:331::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.40; Sat, 22 Mar
 2025 13:54:19 +0000
Received: from GV2PR08MB9206.eurprd08.prod.outlook.com
 ([fe80::d431:f1c3:a2b9:5162]) by GV2PR08MB9206.eurprd08.prod.outlook.com
 ([fe80::d431:f1c3:a2b9:5162%5]) with mapi id 15.20.8534.036; Sat, 22 Mar 2025
 13:54:18 +0000
From: Justin He <Justin.He@arm.com>
To: Marc Zyngier <maz@kernel.org>
CC: Oliver Upton <oliver.upton@linux.dev>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, Joey Gouly <Joey.Gouly@arm.com>, Colton Lewis
	<coltonlewis@google.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>, Zenghui Yu
	<yuzenghui@huawei.com>, Catalin Marinas <Catalin.Marinas@arm.com>, Will
 Deacon <will@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] KVM: arm64: pmu: Avoid initializing KVM PMU when KVM is
 not initialised
Thread-Topic: [PATCH] KVM: arm64: pmu: Avoid initializing KVM PMU when KVM is
 not initialised
Thread-Index: AQHbmt23+1t6e59BE0a5Mo9Hw6bOt7N+7sYAgAA5YWA=
Date: Sat, 22 Mar 2025 13:54:17 +0000
Message-ID:
 <GV2PR08MB920679CA30617D465B69D79DF7DA2@GV2PR08MB9206.eurprd08.prod.outlook.com>
References: <20250322035115.118048-1-justin.he@arm.com>
 <867c4hml8v.wl-maz@kernel.org>
In-Reply-To: <867c4hml8v.wl-maz@kernel.org>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	GV2PR08MB9206:EE_|PAWPR08MB9121:EE_|AM4PEPF00027A5F:EE_|PAXPR08MB7441:EE_
X-MS-Office365-Filtering-Correlation-Id: 4f65bd7a-b739-4f5a-ee5b-08dd69491097
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?YVFCbFRIWW5LVmtQVFlyRDFrT242ZTBVd0lZUlBVTWFpb3oremlQUmh2bzFI?=
 =?utf-8?B?S2h4bldTVVNtTTVYYS9yRklCZllPcXlnc20rd3RJbTdxQkg3djlwMVljUmdO?=
 =?utf-8?B?WTBYMkQwTmxqRXZ5ekFMQkxNQlJlR0hEa0FqVVVJUEhucldXa1JySDRlaU9M?=
 =?utf-8?B?ZDZKVDVCZWhvekQ4TU4rNlpiYW5lcytuZXJYVEs5SlFuNlkzcnZYY2wwdnI1?=
 =?utf-8?B?TTB3c1lObzlRaXJDSEVvaU9nZCtiWUpwZlBMbUpuQ1dRY1JENEthdWVRbzdp?=
 =?utf-8?B?a05jT3NpRHZsblFrZC9rM0NKeUpHTlBWUWNLY3oyVWh2Z0RVeHU0bW4zZkE0?=
 =?utf-8?B?TjBoZThpOEo5T1lFSVhQdDNrQWRKRzA0ak1kM01SeDRqUDRGamppdXc2eXgz?=
 =?utf-8?B?YTFPV3ZidUZJVGFXaXFyR2FiM1Q0ck11WVkwUmpLaFUydnRuVmxrUUtGc1VW?=
 =?utf-8?B?OTl3RzZ4QVNoNVk5QnUyRVVoNHYyOVRQR1p6d0FuSzM5WXZza0xSUnRxRXRp?=
 =?utf-8?B?S1F0UE5HSHR4ZWpiMlZ4S2NWNXpXV3FLekp4dGtlQU1YcCtCb3M5YTBHcEN1?=
 =?utf-8?B?SVloYlZkWUZlYlh1MnE2Q2VMNy9Ub0VRbWlaRWwvOVZLc2FqYmtYYys3OUIy?=
 =?utf-8?B?c0dwajdFTFNjckZIdDFtelN4T2xtL1lzdEVHcGVrcjgrb3B4OXpXb3Vuak1y?=
 =?utf-8?B?WWZYTE5KZ1FoYUFuRTc2S3hWWnBuSC94K25KWHF6em9uOEloZDhqUmd0WFg4?=
 =?utf-8?B?UitLeFhSbGh4ejdKalBmYVpqOVNHWEgxNDY5Uis2WlFldmpHRW5hbFEyUmp0?=
 =?utf-8?B?ZXdwVFlXdWZiRmRWdnRiTzFnTDJxcUFWV2ExaUYrSHJuZmJtVDN2dG00bWxi?=
 =?utf-8?B?cjBPak9ZL3pONkVSalY4OTVmd1ZnVlp1c00rSVZnYk52MDB0MEJLVmJNTk12?=
 =?utf-8?B?MDMreU5yT2JwdGJTWDhuWW9FNndUUExSQzhkZ3BCYUtRaDhjc0ZadlJITmdQ?=
 =?utf-8?B?T1JxQnlHcC8ybDczU1hJWEhXUG0vWkJzTmxqS1lzQjhkMmNuWVpDR3BjTEs1?=
 =?utf-8?B?d3dqL1piMjNSZlpHVkdUQldZUVNIc21VVkgvNnZOaFpSM3RaeTg0VWdNUllr?=
 =?utf-8?B?STQrRVpFb2FldDdGREZaaWZXTUdETzBwak9BNWQ1V3pkcTBvK2pNdmFRdExD?=
 =?utf-8?B?d3RrZWdzeGJZYXYwOGhnbGx1Ym84OWRYeHNVclNhMVdIZXhSbzZ0dUpOYlVB?=
 =?utf-8?B?bzB0VFFsTmc3RHZXZXlNQlZmM0dXSnlJS2pUQ2srbFBTUVZiZndNSjhlRTJq?=
 =?utf-8?B?S2I0VDNNWHhWc2EycmwveEFteFE3RjU3MmpaazFHSExYenhLMGVqdTl1TmpI?=
 =?utf-8?B?Ym5LZi84R3pIUzkxSnZzUU80WTBxckdNSXZ0RmRZL01tOUwrOVNHajJMSE1M?=
 =?utf-8?B?THVKOVh3TnJ1cjJmUFJKbXJqT1ZuUVhSaGM4RUhCYStYZDhkVlVJbjJRdmdr?=
 =?utf-8?B?SVpUd2FMcmVYSzB2WWhtVy9oY3hPd2VUTnhqOSswSk5HVGxVWFdrRXZaWG11?=
 =?utf-8?B?SEFoMzMyYlB4Zm5zSDgxaG4rRDNUdVE4MkJCWXRsdE5oamhCaEpPNWNacndO?=
 =?utf-8?B?amVOYzJZbVltVHVibnIvdGdZcktqamlOazRSbmFVWE5sM0ZXaTY1MFNxczNV?=
 =?utf-8?B?bEt0ZU1FU3VVUGFvYm9QcVlmYzJWNjY0YWhwcThOQUlYQ0NuSmJVWVNacFo1?=
 =?utf-8?B?b29NL1M2QUVOMzJ4ZXVUMmFFUFNXVTQxUURXU3VjUk5lNkZubnBjdk9tQ1V0?=
 =?utf-8?B?Qm5rTStMNDA3SThWTWNKVDlISWJ0c3ViamJDcjA2cVlLRXVxc2hpWjhueWl1?=
 =?utf-8?B?aUpvek15L3N2cnN2U3BiOEtUc294dVErVkFSNlhDS2g4ajhTa2E3MjNzYi9y?=
 =?utf-8?Q?mWNr57KhrO/znRDx0f4saCm79wgeOgFX?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR08MB9206.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR08MB9121
Original-Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-SkipListedInternetSender:
 ip=[2603:10a6:150:d5::6];domain=GV2PR08MB9206.eurprd08.prod.outlook.com
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM4PEPF00027A5F.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	89e5ac36-7c5e-4eb3-7f16-08dd694909f5
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|35042699022|14060799003|36860700013|376014|13003099007|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UEFDT2p1RW16WkxTbW00NDhWWDRjVTE5R1ZqVkhTYXUrUlBGY1dkM3I0M0dp?=
 =?utf-8?B?R0JlYVlKb2UxWDdkSStFZkVPS3dCMjBNQzRLRFdTQ1RmbGJLMHJkTVc1dGFr?=
 =?utf-8?B?YUVFZ3FJNlN0VFErWGZuR1JiWWJPMHRhd3E1TjlEdXJ3c2NUUHA0Y05zOTVk?=
 =?utf-8?B?WHFwMWVQUUdGeENLaEpHWmcvMTZUaUl4R0lNMTNTWm5oVjJuRXpHak5sNk1a?=
 =?utf-8?B?WngrL0RFS3M5OVd1TTZlS3g2NFNCTGZJSnU3RGlCRXFTZzdrSUdYOStJc0tM?=
 =?utf-8?B?TEVDRlZ2UlZkd3gzRURnT2gzdUxxK1BrY1NlQlhVT0RKVUVMeUJHck9lbmg0?=
 =?utf-8?B?OXRyQVcxbUVMZTBWTWhwZTZoSGdjOU0yTnFyV1ZrMVFjUmQ4aSs5MW4yUUJu?=
 =?utf-8?B?SEJ6T1kxakZEb1loSlMxNmxYWFh1b0dwTGg0T1JwOFBuK1Y3Q1VzNUdYYkpa?=
 =?utf-8?B?KzRDa1RucUhIL3JIbGNmYjVKUTh1czVUbDlzU3lxZHZKakJaMldtYkhXL0FL?=
 =?utf-8?B?VkcwZXl3d0RqU2VOdWM4Y3pDazZhS1hVa3IvQjJ2bEZZNmhsU0xDK1pHRHF0?=
 =?utf-8?B?WVZ0OWVHanAvQmpDS01ESTBmNUVGdTdYekxIYnlkSEJpQm9ITDBiWVpZdEln?=
 =?utf-8?B?VDVsVUsyVTdzWHZqUjRibEpsQndZOWpZZ2t1QXgvVkhzbGt5MnJybzh6WUVu?=
 =?utf-8?B?QXVYeWVNSGpLT3BrWTFMNUV5VlFSVlB5UTBKOXpHeUVVZUJFNEliQlhQQWlt?=
 =?utf-8?B?V1Jmd1BXL1FYdWxRaWVsZVc0TjF6aUR4YVo2cVU0TFhPQzFSK0hBKyswZkJ3?=
 =?utf-8?B?R1VFcGJYMFMvTDhkNEc4ZWZ5RGFpSExsMXhja214S1ViTDJuRjVSbVBTR2Uy?=
 =?utf-8?B?ZU5iUzRLY1B2WmpNcWZsNk5ST25FNzdmVDVockgzOGg0Q2dUQ2IrQW54enky?=
 =?utf-8?B?dXFhcWk4YlQ1cWplTUIvVXZmUU1aL3hiVkxjS1BYRFpsZzFlUXB2N1lQMzNa?=
 =?utf-8?B?dWlOVTJkUFVwSkhTT0d2N2NNQUoxMmpLYnVtMjJDWTUwS2JLUm55MVc2em9y?=
 =?utf-8?B?ZDFBQTVRd1NhdFpEbHBkM1I4cmhONG5pK1h2dk9STFIvMWxHRlExTzJXcGcz?=
 =?utf-8?B?VmNsZk9JTk90ZGwxeGdINUd1UDNmMndrZEY1cGRueGE5blZZK2xzWGREdjVW?=
 =?utf-8?B?YkVEQVZRQndYT1h2WmN2eXc2ODBwLzFxNWpqNmpHanRUcEtTd1FkempwVkts?=
 =?utf-8?B?ZGc2a3BYVkFQSWhHMkdTY2M2U3FkSUdkMnEzWFZqR2wyQVQ5RGQ2b3ZTUWNH?=
 =?utf-8?B?ak92b0ZOOWlMYmVJei96SzI0a216dWFRUmkwRmdieFV0WVFKQVkwUndUWGRp?=
 =?utf-8?B?MzJFbDJhdW5ETE85Y1J0cEgwekdBbFNiUU5uZTFtdjZoNG1jWGRYV0kveElh?=
 =?utf-8?B?WklSSDBBbFNPSDJHTmI1aU9oeEdjdUs1TDNPZnpGOVoxZkZXdU5WODUwb2Zq?=
 =?utf-8?B?NjA3a3E5R0JFdTlCcTNGblJxazJOakUrZjIxUC9vRXdadUxnRGtYSWN5eUNW?=
 =?utf-8?B?WmsxVGdYdFgvZWZCT093M0pQTVRBK0pDQ1luQlJqOWx2b1ZrSjNsOHVFdm50?=
 =?utf-8?B?dnZBaXowcWNkZkhHdzE2bVA3V0lZRDhTa3Fkbm5md08rV2lzNm9aQktBRzFO?=
 =?utf-8?B?Z1oyRXIwZVNJSEVEUG14SmMwb053VnpqbHdDR0hHbTRxOEhXYmN4MjNpMzBI?=
 =?utf-8?B?TWJnUGJxSHloeSsvc21PZHlUcE5pM1VTbTJLbnJPdW5zdGxueDRsS1NIYVlT?=
 =?utf-8?B?U3lmUWNnRXlieW1YQkc5Sm13dys2cDYyTlRPaXJjWTBmN0dBZVFTZmpzVGZz?=
 =?utf-8?B?WEdibURCRlZjTE1QVnpEa0dpT0pmZTlBQjNXS0xTSGgwUlFjNk9xUmE4cmlm?=
 =?utf-8?B?U3p0Nk5MMnNoNk1XbDYrYkNzSDdRS3lERHNvN3lMNHhMUTJtYThyamoybzZq?=
 =?utf-8?Q?a1wFG/q5Yrv5jqd21ogq2Xdi6UgEsE=3D?=
X-Forefront-Antispam-Report:
	CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:64aa7808-outbound-1.mta.getcheckrecipient.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(35042699022)(14060799003)(36860700013)(376014)(13003099007)(7053199007);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2025 13:54:28.7618
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f65bd7a-b739-4f5a-ee5b-08dd69491097
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM4PEPF00027A5F.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR08MB7441

SGkgTWFyYywNCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBNYXJjIFp5
bmdpZXIgPG1hekBrZXJuZWwub3JnPg0KPiBTZW50OiBTYXR1cmRheSwgTWFyY2ggMjIsIDIwMjUg
NjowOCBQTQ0KPiBUbzogSnVzdGluIEhlIDxKdXN0aW4uSGVAYXJtLmNvbT4NCj4gQ2M6IE9saXZl
ciBVcHRvbiA8b2xpdmVyLnVwdG9uQGxpbnV4LmRldj47IGxpbnV4LWFybS0NCj4ga2VybmVsQGxp
c3RzLmluZnJhZGVhZC5vcmc7IGt2bWFybUBsaXN0cy5saW51eC5kZXY7IEpvZXkgR291bHkNCj4g
PEpvZXkuR291bHlAYXJtLmNvbT47IFN1enVraSBQb3Vsb3NlIDxTdXp1a2kuUG91bG9zZUBhcm0u
Y29tPjsNCj4gWmVuZ2h1aSBZdSA8eXV6ZW5naHVpQGh1YXdlaS5jb20+OyBDYXRhbGluIE1hcmlu
YXMNCj4gPENhdGFsaW4uTWFyaW5hc0Bhcm0uY29tPjsgV2lsbCBEZWFjb24gPHdpbGxAa2VybmVs
Lm9yZz47IGxpbnV4LQ0KPiBrZXJuZWxAdmdlci5rZXJuZWwub3JnDQo+IFN1YmplY3Q6IFJlOiBb
UEFUQ0hdIEtWTTogYXJtNjQ6IHBtdTogQXZvaWQgaW5pdGlhbGl6aW5nIEtWTSBQTVUgd2hlbg0K
PiBLVk0gaXMgbm90IGluaXRpYWxpc2VkDQo+IA0KPiBPbiBTYXQsIDIyIE1hciAyMDI1IDAzOjUx
OjE1ICswMDAwLA0KPiBKaWEgSGUgPGp1c3Rpbi5oZUBhcm0uY29tPiB3cm90ZToNCj4gPg0KPiA+
IEN1cnJlbnRseSwgYGt2bV9ob3N0X3BtdV9pbml0KClgIGRvZXMgbm90IGNoZWNrIGlmIEtWTSBo
YXMgYmVlbg0KPiA+IHN1Y2Nlc3NmdWxseSBpbml0aWFsaXplZCBiZWZvcmUgcHJvY2VlZGluZy4g
VGhpcyBjYW4gbGVhZCB0bw0KPiA+IHVuaW50ZW5kZWQgYmVoYXZpb3IgaWYgdGhlIGZ1bmN0aW9u
IGlzIGNhbGxlZCBpbiBhbiBlbnZpcm9ubWVudCB3aGVyZQ0KPiA+IEtWTSBpcyBub3QNCj4gDQo+
IFdoaWNoIHVuaW50ZW5kZWQgYmVoYXZpb3VyPyBPdGhlciB0aGFuIHRoZSBwb2ludGxlc3MgYWxs
b2NhdGlvbiBvZiBhIHRpbnkNCj4gYW1vdW50IG9mIG1lbW9yeT8gRG9lcyBhbnl0aGluZyByZWFs
bHkgZ28gd3Jvbmc/DQo+IA0KU29ycnkgZm9yIHRoZSBjb25mdXNpb24gLS0tIEkgc2hvdWxkIGV4
cGxhaW4gbW9yZSBjbGVhcmx5Lg0KSSBub3RpY2VkIHRoZSB1c2FnZSBvZiBob3N0X2RhdGFfcHRy
IGluIENvbHRvbiBMZXdpcydzIFJGQyBwYXRjaCBbMV0uIEFmdGVyDQphcHBseWluZyB0aGUgcGF0
Y2gsIHRoZSBndWVzdCBWTSBmYWlscyB0byBib290LlVwb24gaW52ZXN0aWdhdGluZyB0aGUgcm9v
dA0KY2F1c2UsIEkgZm91bmQgdGhhdCBob3N0X2RhdGFfcHRyIGNhbiB0cmlnZ2VyIGEga2VybmVs
IHBhbmljIGlmIEtWTSBpcyBub3QNCmluaXRpYWxpemVkLg0KDQpbMV0gaHR0cHM6Ly9wYXRjaHdv
cmsua2VybmVsLm9yZy9wcm9qZWN0L2t2bS9wYXRjaC8yMDI1MDIxMzE4MDMxNy4zMjA1Mjg1LTYt
Y29sdG9ubGV3aXNAZ29vZ2xlLmNvbS8NCj4gPiBhdmFpbGFibGUsIGUuZy4sIGtlcm5lbCBpcyBs
YW5kZWQgaW4gRUwxLg0KPiANCj4gcy9sYW5kZWQgaW4vYm9vdGVkIGZyb20vDQo+IA0KPiA+DQo+
ID4gU2lnbmVkLW9mZi1ieTogSmlhIEhlIDxqdXN0aW4uaGVAYXJtLmNvbT4NCj4gPiAtLS0NCj4g
PiAgYXJjaC9hcm02NC9rdm0vcG11LmMgfCA3ICsrKysrKysNCj4gPiAgMSBmaWxlIGNoYW5nZWQs
IDcgaW5zZXJ0aW9ucygrKQ0KPiA+DQo+ID4gZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQva3ZtL3Bt
dS5jIGIvYXJjaC9hcm02NC9rdm0vcG11LmMgaW5kZXgNCj4gPiA3MTY5YzFhMjRkZDYuLmUzOWM0
OGQxMmI4MSAxMDA2NDQNCj4gPiAtLS0gYS9hcmNoL2FybTY0L2t2bS9wbXUuYw0KPiA+ICsrKyBi
L2FyY2gvYXJtNjQva3ZtL3BtdS5jDQo+ID4gQEAgLTIyNyw2ICsyMjcsMTMgQEAgdm9pZCBrdm1f
aG9zdF9wbXVfaW5pdChzdHJ1Y3QgYXJtX3BtdSAqcG11KQ0KPiANCj4gSHVoOg0KPiANCj4gbWF6
QHZhbGxleS1naXJsOn4vaG90LXBvb3AvYXJtLXBsYXRmb3JtcyQgZ2l0IGdyZXAgLWwga3ZtX2hv
c3RfcG11X2luaXQNCj4gYXJjaC9hcm02NC9rdm0vcG11LWVtdWwuYyBkcml2ZXJzL3BlcmYvYXJt
X3BtdS5jDQo+IGluY2x1ZGUvbGludXgvcGVyZi9hcm1fcG11LmgNCj4gDQo+IEFtdXNpbmdseSwg
YXJjaC9hcm02NC9rdm0vcG11LmMgaXMgbm93aGVyZSB0byBiZSBzZWVuIGluIHRoaXMgbGlzdC4N
Cj4gSSBoYXZlIG5vIGlkZWEgd2hhdCB0aGlzIHBhdGNoIGFwcGxpZXMgdG8sIGJ1dCB0aGF0J3Mg
bmVpdGhlciA2LjEzLCB0aGUgY3VycmVudA0KPiB1cHN0cmVhbSwgbm9yIGt2bWFybS9uZXh0Lg0K
U29ycnkgZm9yIHRoZSBtaXN0YWtlLCB0aGUgcGF0Y2ggaXMgYmFzZWQgb24gQ29sdG9uIExld2lz
J3Mgc2VyaWVzLg0KSeKAmWxsIG5lZWQgdG8gcmVzcGluIGl0IGlmIHlvdSdyZSBpbnRlcmVzdGVk
IGluIHRoZSBmaXgg8J+Yig0KDQo+ID4gIHsNCj4gPiAgCXN0cnVjdCBhcm1fcG11X2VudHJ5ICpl
bnRyeTsNCj4gPg0KPiA+ICsJLyoNCj4gPiArCSAqIFByZXZlbnQgdW5pbnRlbmRlZCBiZWhhdmlv
ciB3aGVyZSBLVk0gaXMgbm90IGF2YWlsYWJsZSBvciBub3QNCj4gPiArCSAqIHN1Y2Nlc3NmdWxs
eSBpbml0aWFsaXNlZCwgZS5nLiwga2VybmVsIGlzIGxhbmRlZCBpbiBFTDEuDQo+IA0KPiBTYW1l
IGNvbW1lbnQgaGVyZS4NCj4gDQo+ID4gKwkgKi8NCj4gPiArCWlmICghaXNfa3ZtX2FybV9pbml0
aWFsaXNlZCgpKQ0KPiANCj4gVGhpcyBpcyBkZWZpbml0ZWx5IHRoZSB3cm9uZyB0aGluZyB0byBj
aGVjayBmb3IsIGFzIGl0IHJlbGllcyBvbiB0aGUgcHJvYmUNCj4gb3JkZXJpbmcgYmV0d2VlbiB0
aGUgUE1VIGRyaXZlcnMgYW5kIEtWTS4gUmVseWluZyBvbiB0aGF0IGlzIG5vdA0KPiBhY2NlcHRh
YmxlLg0KPiANCkluZGVlZCwgd291bGQgaXNfaHlwX21vZGVfYXZhaWxhYmxlKCkgYmUgYSBwcm9w
ZXIgcmVwbGFjZW1lbnQgZm9yDQppc19rdm1fYXJtX2luaXRpYWxpc2VkKCkgaGVyZT8NCk9yIHNo
b3VsZCB3ZSBhZGQgYSBwcmV2ZW50aW9uIGNvbmRpdGlvbiBpbiBob3N0X2RhdGFfcHRyIGluc3Rl
YWQ/DQoNCj4gSWYgeW91J3JlIHdvcnJpZWQgYWJvdXQgYSBrZXJuZWwgYm9vdGVkIGF0IEVMMSwg
dGhlbiBjaGVjayBmb3IgdGhhdC4NCj4gDQoNCi0tLSANCkNoZWVycywNCkp1c3RpbiBIZShKaWEg
SGUpDQoNCg0K
