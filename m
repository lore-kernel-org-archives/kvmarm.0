Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=2 smtp.remote-ip=40.107.130.52
ARC-Seal: i=3; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795484407;
	b=Jv2dQLfqJ403ikHSdORw75KwcdpM/XEYQpO4AtytB3aDuEx+w1xxmTSVM4P0OrcHFtxn
	 c0K+kkBawyLN07+mGq4WrASAe0AusBDF3vokG+PTIoKgHXZK3L6AuB52mnwMLAZm3c0Xo
	 8055N7Zoiw3iVJH3lJ1fnuNQjxcM837MeeZvFAINj73jND7TOZncxpvdAZiCNJA+fx3vo
	 cMT6pV6Mwl9+DLROsxuE/o+3TKl56RBGzomnztBCUnxBW57byY+VkMe8YOcnRagULH5r9
	 p78Aq+YY1MPuX1b/tl6cCGYCLpuKdhIb4kjFbyng/vEMKKckeZiw1OUOtNOw1CmTwOg==
ARC-Message-Signature: i=3; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795484407;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:
	 DKIM-Signature:Received:Received:From:To:CC:Subject:Thread-Topic:
	 Thread-Index:Date:Message-ID:References:In-Reply-To:Accept-Language:
	 Content-Language:X-MS-Has-Attach:X-MS-TNEF-Correlator:
	 Authentication-Results-Original:x-ms-traffictypediagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:x-checkrecipientrouted:
	 nodisclaimer:X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam-Untrusted:
	 X-Microsoft-Antispam-Message-Info-Original:
	 X-Forefront-Antispam-Report-Untrusted:Content-Type:
	 Content-Transfer-Encoding:MIME-Version:
	 X-Exchange-RoutingPolicyChecked:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:
	 X-EOPAttributedMessage:
	 X-MS-Exchange-Transport-CrossTenantHeadersStripped:
	 X-MS-PublicTrafficType:X-MS-Office365-Filtering-Correlation-Id-Prvs:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=hRikMfhAOmk0wUY2+5TZW18vRffuRbN3w8hN7IBFVz8=;
	b=VgqFQmkNwMIg63p4GsCdnO5ZX8kVLrPXBao4gRVO8QRsZQy++Vac9T68TDqPtQlRrWL5
	 ZtyRr6xfJRTF823N2SotYzH/Q0bak9jJnkUjpRCvQ+oU0uewgqt74ZP/f3GRy1klV5fmQ
	 HSdIGVMTlimS6JTPd4byvKhYHDiXv9Ur6JzYah8Lt40ZJUb6YJOwUA/gkKV6hOXra+irC
	 MRRCFa4PfaFFcbLbDDCeuk/SrIULgPUr5XyOmEFjVtuC/gkDRZqkEcnBzfMWRtWWd9wU9
	 YxrumHnuoKZhN8il2jkJujZSneeH0AjXqqQwvmLmJDzg5wFQqahWz4F3wnuopPZi1kw==
ARC-Authentication-Results: i=3; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=selector1 header.b="RYdI/Geh";
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=selector1 header.b="RYdI/Geh";
	arc=pass header.oldest-pass=2 smtp.remote-ip=40.107.130.52
Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011052.outbound.protection.outlook.com [40.107.130.52])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 039A8606A321
	for <kvmarm@lists.linux.dev>; Tue, 24 Nov 2026 01:40:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 039A8606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=selector1 header.b=RYdI/Geh;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=selector1 header.b=RYdI/Geh
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=suuH2BTJdUYMJPZxmAYwX13kVv3DtC71v4eA2m9b69wSOGNyZIzQAW+AMReaYGboZZpX0YoeK0RgxdfM+w7U7HDG5B9aCjdhLPLDzsWPsKBHxQWX7l6jaVoXH4cHEKHM1//b5iP74EpTK2m40Y/FXw6EXZqmivlPh6uBAmHhVaoWtPfMZMvDuAjpi9NNDdBxX6u0nwzNCQGHZwWhU9caP0uy0co15gUxzc9FxyIJpr3nznwTmNHvuj9gfylGpp9JjN0mN539XwCSLgCQEAQBteVC/G7VF0rhJcy2hmXiCJU+NctdRn62yeFZqzmyyseiqcOnzuSje+ay2b3ehOvSzw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hRikMfhAOmk0wUY2+5TZW18vRffuRbN3w8hN7IBFVz8=;
 b=Yb3PtaiTw9uclnyd/8e8lXAZ5yl0JGJGtM91R6MTmbeeD9fLEB+9r9J3SDptvDuJASoig0SR26tcZwQDYr/IbSsVls+2wQ/8pngyNdVM/meUz9CCM8NavqtESx7cdtEVH69F7FcbKJa2EIaXD4xGUIE5kA5XUHOtMt1bNYuY2OF1B+2zVb+2eWNukYdRFaz+HmPPD4hDzcuBbJ6HZvE54ZcPvLyNdiUk8KanYTE3lg8VsQ0MtrRrp5SeEeA7oJ/JUJk1DK6j2khiDpYRza2lk8xIjuIdW6KJdUwD1yoIQp43pjU7A0U2p3XOxSGWMpqqY69b/o2xzNJtB87FxK6gzQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hRikMfhAOmk0wUY2+5TZW18vRffuRbN3w8hN7IBFVz8=;
 b=RYdI/GehypcaT5PJft7gWw4b/lkpMAbZXIjFLakZsc0xKSaEf48BldUJ2WF44SmDQBRuQA0DQlFdFMvw1KN2ZvSJ6CscJ9GIKPgZwViNGQZDsRKz8UDLFLoSMi1cipzM07T4POHU7/X50bwu9Nx01Gvddjl8vQ/PEkpS6B4szIw=
Received: from GVZP280CA0035.SWEP280.PROD.OUTLOOK.COM (2603:10a6:150:26f::12)
 by GV2PR08MB11417.eurprd08.prod.outlook.com (2603:10a6:150:2c9::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.14; Tue, 24 Nov
 2026 01:39:58 +0000
Received: from WA1PEPF000099D1.eurprd04.prod.outlook.com
 (2603:10a6:150:26f:cafe::7f) by GVZP280CA0035.outlook.office365.com
 (2603:10a6:150:26f::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.639.14 via Frontend Transport; Tue,
 24 Nov 2026 01:39:58 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 4.158.2.129) smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 WA1PEPF000099D1.mail.protection.outlook.com (10.167.242.25) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.662.3
 via Frontend Transport; Tue, 24 Nov 2026 01:39:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dvCU6h7hJnlUKZtwKP5T28bhllsJtOHwX/sB5+azIdq4PjF0W7lQKq6AISKVguUfAG7gOfzvJLSf+794snyjBuJBWkp1TTQZ+fv0wXtqrA/didpeUjxYm+ZHjzzIu0INXZenFETo6ETnwzjsoIrpleXgkCoTJASy3+mVKpupEJhJpxnVIkqQpdLJkqBqp24iWix57ZcWarZnXekCiWDsyw43F6/7j1HP1ssJ/v2L/YnruL7l1XkMz9mKYep58CNFvFpIZ6T5I72XpNa6/6RdY8vRqGBbAQhEdnPrCXzkKFhAQUIATL6zxHisRUk9BuaxY1bLpGzX3AMDzr/HgdMZFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hRikMfhAOmk0wUY2+5TZW18vRffuRbN3w8hN7IBFVz8=;
 b=PRAgagQ2yZ1kids1Rmat6sKb41kN67EosMpAEvAb5TMPg0LmmNMQQ6zzjIk8r67eAIIqgdqFyUhjsdWzUybPZhnKPBwoF08+/ef4KjseaaB+zw6ArD/FBSlE8NREbW6PHOLb7rmkV1HcuUriMWEtMVna1sv2DicpehU/c5lcwU0Wz65I4e7IimoirUFOS/Qu4yo6ZVO7Lfos4UwFVsNHnxujR7YeWRfdMIRJnyRvOANp3qzVqQMp8vgohaIa33eFdsdDsGcn8+UnhdlQ69sKJN6LuERBlc8fiuH9JfSyzD59O3bbXUPIQUD78B0IxZDqO2FssKXbXRH5oPLDHRmtVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hRikMfhAOmk0wUY2+5TZW18vRffuRbN3w8hN7IBFVz8=;
 b=RYdI/GehypcaT5PJft7gWw4b/lkpMAbZXIjFLakZsc0xKSaEf48BldUJ2WF44SmDQBRuQA0DQlFdFMvw1KN2ZvSJ6CscJ9GIKPgZwViNGQZDsRKz8UDLFLoSMi1cipzM07T4POHU7/X50bwu9Nx01Gvddjl8vQ/PEkpS6B4szIw=
Received: from AS2PR08MB9786.eurprd08.prod.outlook.com (2603:10a6:20b:605::22)
 by AS8PR08MB9072.eurprd08.prod.outlook.com (2603:10a6:20b:5c0::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.13; Tue, 24 Nov
 2026 01:39:23 +0000
Received: from AS2PR08MB9786.eurprd08.prod.outlook.com
 ([fe80::d721:dfdb:2f83:155]) by AS2PR08MB9786.eurprd08.prod.outlook.com
 ([fe80::d721:dfdb:2f83:155%6]) with mapi id 15.21.0639.012; Tue, 24 Nov 2026
 01:39:23 +0000
From: Justin He <Justin.He@arm.com>
To: Marc Zyngier <maz@kernel.org>
CC: Oliver Upton <oupton@kernel.org>, Fuad Tabba <fuad.tabba@linux.dev>, Joey
 Gouly <Joey.Gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, Suzuki
 Poulose <Suzuki.Poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, Catalin
 Marinas <Catalin.Marinas@arm.com>, Will Deacon <will@kernel.org>, Mark
 Rutland <Mark.Rutland@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, Sean
 Christopherson <seanjc@google.com>, Shuah Khan <shuah@kernel.org>, Sascha
 Bischoff <Sascha.Bischoff@arm.com>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>, Lorenzo
 Stoakes <ljs@kernel.org>
Subject: RE: [PATCH 1/3] KVM: arm64: Don't load hardware vCPU state before
 first run
Thread-Topic: [PATCH 1/3] KVM: arm64: Don't load hardware vCPU state before
 first run
Thread-Index: AQHde1zAtBC9mmT//0CTNvJgc0eqU7c75woAgACKa9A=
Date: Tue, 24 Nov 2026 01:39:23 +0000
Message-ID:
 <AS2PR08MB978600ED2150F773D3E1631DF7442@AS2PR08MB9786.eurprd08.prod.outlook.com>
References: <20261123150917.2679600-1-justin.he@arm.com>
	<20261123150917.2679600-2-justin.he@arm.com> <86eccbzcqh.wl-maz@kernel.org>
In-Reply-To: <86eccbzcqh.wl-maz@kernel.org>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Authentication-Results-Original: mx.microsoft.com 1; dkim=none (message not
 signed) header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AS2PR08MB9786:EE_|AS8PR08MB9072:EE_|WA1PEPF000099D1:EE_|GV2PR08MB11417:EE_
X-MS-Office365-Filtering-Correlation-Id: f47065bf-5900-4cb4-573b-08df49cbd91d
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|1800799024|376014|7416014|23010399003|38070700021|261102123227099003|10067099003|56012099006|11063799006|4143699003|261022105027099003|261026140227099003|261028144727099003|261026121527099003|261022075727099003|261021135927099003|261021121427099003|22082099003|6133799003|18002099003|261009223027099003;
X-Microsoft-Antispam-Message-Info-Original:
 mpEPE/ItsBQaAmIKLsQ94WCoOXzytY6tIn/5H8Lmw7PqC0wh4URgcJKfal0YxZ6bstkkWnLAoYIKzUXxOehMeQsNyfql0709+0fmnE/ALkglDmpwm0Lc4lgovaKvo2Kqz2Rtw+Q2sQfAil+C06H5xce28arreNJuEetZO5TAif9cHW8Cv0B+UNhtAvLjeB6VLDKnW1YP++wMuTywvwKtMAnV862jbdYs/kjjikovkaNL9CJ2cTepctgA6plgktyAsGmPHtEvb5q6NBSMLjDmDVlxg0qodLxjL2KWyFgkds2FPtEzBPwxidllqWk/+W3AZax5ZR23V/6isVwgF76Gf3Ke6CKMRYK0yXZWyoX60e+3gdzhda9j+5C5Oa0xTUwJLeXBvHtqoywV5GDOZou4puStNArJYFBhDXV+pqU5KtJgJhigQ0gx5Rzc/VqCWKs2cjEKfPRCShCz5KJ6MThx/m/HVU6VtiPWomcKiueJ77XWN2NeQaZEo/LI8y3Dgr9KOt7gakun6rLr6cYxr7uvGlGYnMpjnJ71IfXtreASBECnSDeDjTLIl8E6vtvH42AryRKxi5XpZbJg6HQEUie7Najfhp147wn52l7luxrm/+YCRcgvQKnQxtl1WRcouNEONskdiKrpKNHhMsuLGJhFF09YyvLriwdYE/8jjpMD/N6xONVDqB8lSJ9F/PGLAIhKKFE5B6Cm0DlOpkFTLgZlm9SmwRQZS5BiJb4Km4bk1Yk=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS2PR08MB9786.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(23010399003)(38070700021)(261102123227099003)(10067099003)(56012099006)(11063799006)(4143699003)(261022105027099003)(261026140227099003)(261028144727099003)(261026121527099003)(261022075727099003)(261021135927099003)(261021121427099003)(22082099003)(6133799003)(18002099003)(261009223027099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 RE/b39+J0Kqd1rNsM6c1cNC0mCS3rceupCU0UFq3XB6bqEXQCdekDrisFEB7Rl6SnTsCks6hYAB5vMDbJRrTs4+ZRMkpofEOCAm4cgH53Z5sNDrqtdhCdBw9UOMLY95sye768vSTBxCCMS63CvWTrtUjxBdGjdYwTHgFu1xTZFes4Vi5RiYx90i/wVe9TbHZ5YJzTbxQEshhRvA+zYus1/c2IyVoDNHlNNnaKA4izj95NRjA1chXWwzHlQhgQkXfCtwkKHUTLF67WDm8Z4icLlCkHzSmGY55vFk25dHeZwJ3MLxts9xhW0GKIgPmEEpiDoI2+Rog8bFTXepTSgxd6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB9072
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 WA1PEPF000099D1.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	3bb031df-dca3-4bd3-e855-08df49cbc483
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|23010399003|14060799003|36860700016|82310400026|1800799024|376014|7416014|261102123227099003|261026121527099003|261022075727099003|261022105027099003|261026140227099003|261028144727099003|261021121427099003|261021135927099003|10067099003|11063799006|4143699003|56012099006|261009223027099003|18002099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	BGCUzdwhvL4GXIMz1Eq2J5Zbph8zAQxXzsrJ0LeH3iCFxpCFXx/4IGoof4pIUvOXSmdiK96/gOQgUWM6zY300N6wawdUnSXAYQKcIkeff9Z+wuXGGp/PnQDtSTjT3DQOavG725000VNfXbddTHX8jnsmwYcfiRbX8MRBjXQ3UtySGZ5TSGnprzGxhtAap7JeqlzS3bdJiX9XZlw8LM0XJ4CZCShTLovyzhxlhDEfceoeEn7sW0ZE3PVVr8vEJSKWNhjCHeZ43loj2wfbZm5/EWx2+R4pRWnFRsf6WaIY/VKWO5AzbrHVLV4Sui8PQgH7qWXxtymajVLwWVSbS99vz5VdghWrHqGlIcksuKhmO4XOWIGiKGUTdif4Q35Wou0MmANxG9YQUTWM9iGMXLjkzP9Su8x4QwYN/454t14/CU5sTAAYR9vXy2P1k/y2Vg/ry+ku/C3+DXuGo3OJkMnMyDPHJheDCCLZalvcX62S/eaVXDAwJX/HaQ55gq3SUklCLnj0urAANt/ZIzFHd2RiZDzN4n99mgJQVoaaTE8omucFlCCnnmuFyzpqChsPWyHwKMdCO7bT+9VWKfP4XMzlaLizuLo4wZhttSze2mZpJ5Ju00kd/AH6mKyOFsGGBKEUg9n896hyMtVq96ZFxMk7vPlpCfP/lcyUimfSXh0E5KLeRgzm90wVlkHgwSib06QkhLwUJqZOTisUP0u0QUSfRA==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(23010399003)(14060799003)(36860700016)(82310400026)(1800799024)(376014)(7416014)(261102123227099003)(261026121527099003)(261022075727099003)(261022105027099003)(261026140227099003)(261028144727099003)(261021121427099003)(261021135927099003)(10067099003)(11063799006)(4143699003)(56012099006)(261009223027099003)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	E+GOguSOWPGziyHLMOkQ7K+2oKW6OWqlAx+zig2VjT15N488oSWcvEjw20UWE2u/VTQeiWA/BfgwhCgEUkC3T6kZjVZg+xIRD65MsW/6PmyFZH1t/Sg92jY4lj89mQIHs0Ygr1kP5Ltgpn410r7jhRic159jTBKid2/z28k1FQ6t61ouoiRff5Ni51iII1ENVW+72EXTZn5XxOtb4E0IfLcH5ZAvdfKnpLyJNI8I3MiVzwjg8We1nOndlQk17SVg6v5JYnTw2zXmfF6e8dQPIDujaKDu/MwXcl+mkTBX0LhqNYUaiByg+y9UEo9Dcj1MCq4s50fdlRYD4dOPAymwsyGuPCRvyopekptB2hpcYOzzhD/yNXnxU1ViMdEnDB5kvFXaynANsw6675b9tG5LkLFgzUORqHuyA8B48LIqu/DNfq+Gsnlxedpm3rWV+ZiK
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2026 01:39:57.7839
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f47065bf-5900-4cb4-573b-08df49cbd91d
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	WA1PEPF000099D1.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR08MB11417

Hi, Marc

> -----Original Message-----
[...]
> > KVM_PRE_FAULT_MEMORY calls vcpu_load() as soon as
> KVM_ARM_VCPU_INIT has
> > completed. On arm64, however, kvm->arch.sysreg_masks, the trap
> > configuration, vncr_tlb and nested vGIC state are only set up on the
> > first KVM_RUN in kvm_arch_vcpu_run_pid_change().
>=20
> I think I'm going to queue a patch disabling prefaulting immediately,
> and then we can fix this crap.
>=20
Fine with me. I'll rebase on top of it and have v2 re-enable
pre-faulting together with the load/put change.

> >
> > Running the full vcpu_load() path before then reads unsanitised guest
> > sysregs and touches uninitialised nested state: get_s2_mmu_nested()
> > populates nested_mmus[] from raw VTTBR_EL2/VTCR_EL2/HCR_EL2 values,
> FGT
> > and HCRX_EL2 are written before kvm_calculate_traps() has run, and
> > kvm_vgic_load() can enter vgic_v3_load_nested() early. In particular, i=
f
> > userspace creates an EL2 vCPU with ID_AA64MMFR4_EL1.NV_frac cleared
> to 0
> > (so vncr_tlb is never allocated), sets HCR_EL2.NV=3D1 and an EL1 PSTATE=
,
> > and calls KVM_PRE_FAULT_MEMORY, kvm_vcpu_load_hw_mmu() queues
> > KVM_REQ_MAP_L1_VNCR_EL2. The next KVM_RUN then dereferences a
> NULL
> > vncr_tlb in kvm_map_l1_vncr() with preemption disabled and kvm-
> >mmu_lock
> > held for read:
> >
> >   [   73.636014] Unable to handle kernel NULL pointer dereference at vi=
rtual
> address 0000000000000078
> >   [   73.801972] pc : kvm_map_l1_vncr+0x48/0x2d0
> >   [   73.884820] Call trace:
> >   [   73.887253]  kvm_map_l1_vncr+0x48/0x2d0 (P)
> >   [   73.891422]  check_nested_vcpu_requests+0xb8/0x168
> >   [   73.896200]  check_vcpu_requests+0x2a0/0x428
> >   [   73.900458]  kvm_arch_vcpu_ioctl_run+0x2d8/0x6d8
> >   [   73.905062]  kvm_vcpu_ioctl+0x388/0xaf0
> >
> > KVM_PRE_FAULT_MEMORY still needs generic vcpu_load() to set
> > kvm_running_vcpu for dirty-ring tracking in mark_page_dirty_in_slot(),
> > but kvm_arch_vcpu_pre_fault_memory() only walks and populates
> > &kvm->arch.mmu and does not use any hardware vCPU state. Skip the arch
> > vcpu_load()/vcpu_put() callbacks until vcpu_has_run_once() is true. In
> > KVM_RUN, vcpu->pid is set under vcpu->mutex right after
> > kvm_arch_vcpu_run_pid_change() succeeds and before
> > kvm_arch_vcpu_ioctl_run() calls vcpu_load().
> >
> > Since kvm_running_vcpu can now be set without VHE state on the CPU, use
> > host_ctxt->__hyp_running_vcpu in VHE enter_vmid_context() (matching
> > nVHE)
>=20
> Can you clarify under which circumstances we end-up on the TLB
> invalidation path? Simply faulting things in should not result in
> invalidation. Unless we end-up with MMU notifiers firing?
>=20
I found this by code inspection, not from a failure. A TLBI from a stage-2
BBM or an MMU notifier can hit this path during pre-faulting, but before
the first run hw_mmu is canonical, so it makes no difference. As Lorenzo
said, I'll drop this hunk.

> > and check vcpu_has_run_once() in vgic_maintenance_handler().
>=20
> I have similar questions here. It isn't obvious how you end-up getting
> a VGIC MI if you don't run and don't load the state on the CPU.
I can't construct a case either. It was defensive, so I'll drop it.

Thanks,
Jia He (Justin)
