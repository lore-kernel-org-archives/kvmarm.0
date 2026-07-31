Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011046.outbound.protection.outlook.com [40.107.130.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C4082798F8;
	Fri, 31 Jul 2026 13:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.46
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785503184; cv=fail; b=tpOQxcHmU/reNCpcNBLK92mCfz0sazzw/C/KTSX6M0NOx0AS8hGB59BoVod9RSEYODO5rtjUI7iOpUXn/W2jyde6HwLlpzsYQTGnNsVrKm8OPzIY0lubW7Ory6XYxRrBchBWFdq+XM/AqgMPkAJf1r1CDWup/1XaI33PrJwT2kA=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785503184; c=relaxed/simple;
	bh=4HwHTUzrtJObj2Yf8528I9kV86N9Z5Ckrb2mkQkFz9o=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=LLfTWDnr7DMcqQZ3gM5wDe0p0MMUegfysNhWIAv0C1mVMR3NKoWVdXEheKeIShp8o/I25Zn/afE+ZA0Y4/fmfCJK+p6d6hKpzkuYmINj8TmlHqkxGWhWPI/nJRkzhlN4J/z9tTCjFbQ6vdvbgI5/4F7I4BkUAelTtSw+dt58nGY=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=BWrtUgIq; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=BWrtUgIq; arc=fail smtp.client-ip=40.107.130.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="BWrtUgIq";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="BWrtUgIq"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=v0u+sIAobnkey5WiA9I5e4p++3Gn8Std0Wkfu3n6AhE2tCO6V8wAjx/u7s3g6BG0h4ylfm+o8bsi2RRoWLdaBY4XkvdxPtFjC2bp+a6cQH67KFFzPNYlqgmBy3+Y5iDbjLiKJ5jMVbcIr2Utxa4gzXSfAeBcV7EB8LwGjOx3+d4PLUau8tnJX74oNo8eKidnzzVRGfLiWrYhnEee7rYRKM7moDgPw195Bjue8e+lAXsA8H4qB9oWP9RCAAqJnCch5ECCugeknj7pTI4obASP1AejFA+rD0FUoVYL3Prjeba1tehaFkRjvqLPaBvTSfeA8smOYu52AWW8GWNdr+edhA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4HwHTUzrtJObj2Yf8528I9kV86N9Z5Ckrb2mkQkFz9o=;
 b=dweFpWoaUAzCt+GZanKQ8d1hFVV3lnjSAsSCTvkH3JEidlSYU/nwaHq44XnYoDhnCR9yd/WhGeaI0Twrgq4tb6DBbBw8te8oDhNzOPbES8ACwwsbTw6lUoD6G1QQc5X/qieqmI3Dd804DUVf1KyBXeTK55eqgGMkbetcvEmsnkROJixWdYxKx8Db8fyonrwsCM6mjl13h4tDl+wPUkSu8ZHLPXmBjXLFgPrHs+GH11BoyqzvZFHOVouoHBP29rq4ENjjRzAidr9XhHQh9OcMIO6GTXGfEHDxf+joSAFUyTevC1Qyeg08f719T9vtVVkur/3uCP+ZlLzukHjUD5Tm0Q==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4HwHTUzrtJObj2Yf8528I9kV86N9Z5Ckrb2mkQkFz9o=;
 b=BWrtUgIqfElnu/d4UYi6S88JO3eN5TmvROmTqV233t/lI34PwvDUu+2/Ti9tPCG97TnetkxeZCjmkO7uMkSAiYMthIFR3hPm27YkdeAQUsasae1vB7dLyQFM2BIfCqPbI8StV9Zzic16IcY5u9iMMmUY2dA7hAln0dDCT9I6AJY=
Received: from DU7PR01CA0005.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:50f::28) by GV1PR08MB11245.eurprd08.prod.outlook.com
 (2603:10a6:150:281::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.15; Fri, 31 Jul
 2026 13:06:17 +0000
Received: from DB5PEPF00014B97.eurprd02.prod.outlook.com
 (2603:10a6:10:50f:cafe::16) by DU7PR01CA0005.outlook.office365.com
 (2603:10a6:10:50f::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.15 via Frontend Transport; Fri,
 31 Jul 2026 13:06:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB5PEPF00014B97.mail.protection.outlook.com (10.167.8.235) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.8
 via Frontend Transport; Fri, 31 Jul 2026 13:06:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pktH8Y+z+mXiVPP8d1I2tBguScZMdhWkPIYjVDMLO/ySDz+okNqzkDEOYGNVy3NO+cir56bmiqbnFBed1K/+Ja6l2aEJBUVzkedTlQ4xD7mCNVIs+nGqtWhCJjwHOSGcxD93nfyw4cfnZVLrUOdjE5bhWs1IAMcWT8WGs5hZIR5mvIWhH9qIXsi3E1R+pDv/2QT3sPlIreh3QkZORYW7YxgAEN3bF41vF7lPnp/sEGEhWQC5t6FHnLkHFC/f+OYwP6aPkvR1QbJ4QfDdQmdI+0LNpFhUpDCHG9+GDU94A9X+5cZMfcfyuZjXAwPFsRYwiJ3Gc5io22tWVRb1UC8h+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4HwHTUzrtJObj2Yf8528I9kV86N9Z5Ckrb2mkQkFz9o=;
 b=MdPKP0M8kcTcdRNYk3xixtjfJl7CbdTXDB3I7lqoQw4YQ0mMif1Xv9C//8E7p5UhIq/l3Kv7oZky/KDlHH2o5Iy5j5SlfhW9jX1d9V2zbMI3E0E9d3tlEXPPIX67yvkRm2zKqodsSzx534L9L2hGsOrEmyIpVWCf7jU6PD84G//w4oHTww4HcmSdhnKn91oal0uhsnZjPy0Rjl/sluhJTePIEVqBpe8UcF2mH2VboUNvh4f8h/yQ1qPnt1Z0sFm3MJjz7HUbctZFr60KupRceWLR7JLUJLFwt+PLf5p6HpevtaOyCANi4EhT+JlN6V8A3sCqFMuqzufT6n7YBPwgrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4HwHTUzrtJObj2Yf8528I9kV86N9Z5Ckrb2mkQkFz9o=;
 b=BWrtUgIqfElnu/d4UYi6S88JO3eN5TmvROmTqV233t/lI34PwvDUu+2/Ti9tPCG97TnetkxeZCjmkO7uMkSAiYMthIFR3hPm27YkdeAQUsasae1vB7dLyQFM2BIfCqPbI8StV9Zzic16IcY5u9iMMmUY2dA7hAln0dDCT9I6AJY=
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com (2603:10a6:10:407::19)
 by VI0PR08MB11408.eurprd08.prod.outlook.com (2603:10a6:800:302::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.15; Fri, 31 Jul
 2026 13:05:13 +0000
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e]) by DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e%5]) with mapi id 15.21.0270.012; Fri, 31 Jul 2026
 13:05:13 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "sashiko-reviews@lists.linux.dev" <sashiko-reviews@lists.linux.dev>
CC: "maz@kernel.org" <maz@kernel.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"oupton@kernel.org" <oupton@kernel.org>, nd <nd@arm.com>
Subject: Re: [PATCH v4 22/48] KVM: arm64: gic-v5: Register the IRS IODEV
Thread-Topic: [PATCH v4 22/48] KVM: arm64: gic-v5: Register the IRS IODEV
Thread-Index: AQHdG1q+qpbeSOrkREKmE8gEsg+CKLZ8ieAAgAsZ2wA=
Date: Fri, 31 Jul 2026 13:05:13 +0000
Message-ID: <10a033292802dd8b57172353edd8350fc2c23374.camel@arm.com>
References: <20260724104819.1296803-1-sascha.bischoff@arm.com>
	 <20260724104819.1296803-23-sascha.bischoff@arm.com>
	 <20260724113349.0E5791F000E9@smtp.kernel.org>
In-Reply-To: <20260724113349.0E5791F000E9@smtp.kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU0PR08MB8421:EE_|VI0PR08MB11408:EE_|DB5PEPF00014B97:EE_|GV1PR08MB11245:EE_
X-MS-Office365-Filtering-Correlation-Id: 78287d18-c1dc-45e4-f51b-08deef0481bc
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|1800799024|23010399003|376014|18002099003|22082099003|4143699003|38070700021|11063799006|10067099003|56012099006|6133799003;
X-Microsoft-Antispam-Message-Info-Original:
 0+bAkc4r1WX9S/nVchsejK65C21KX0GycG0FZa98cxK1UOipgKTVGTc/sxFXQPNfg4xKHmh3AIPn1IXiDSJH0Rg83u1lkuwX2eoZYedlpDuCrONgojO99ulgqLAtU5dT9Kjjof9ISu17h1Zlx3CKXDOmrWLYA6X6p5zxthRee2+oIi+igkmybPK6j2bZK4k8dPwaWeggjeryvZnC7JBX2UXzyVyCM//DMmhcaeOZWA3Zn/+zsbfcbpOrEI6oBuenPfq8agSEFUkZ83U8LeOGAz8y5umIRgHRw+nUfV8DavyvjYPhTrRRfAHyTLiL6B4JSyWo8eRZ0Qi6uzT1COan/KJ4F+h8WbczmjkmbRXA/BaEtmzsXXqg4XtS1Zw/IjA1E6/TECxW7R0CnQVBYZRjC1r5tgnf92R52nZiUjVjRhlLeOYQGrzrdMUtqPDtP7FXtHZKaSRtToN9SUr7vsfJEsTqCoJ/ShncMRYVhWonq2Jkam8Kpqy5tgUrVWZkN2oeh7M1BEMN8YWHYDQdKEOcwG1cxVYBNfnLBccDt4p3KT3CP0E8ozm8qhsBPIJEQLP3yPTpORQK1lpHYBen3Emmy9jAiiElQ3jBZ47/SPRxKSqTkc3TwVJXEboNXx2b8aaXgJEVZNfT8ZkWn/m/kSr22SQxvqSRlxgASOEiBqDMjLUU9XB6AQPmLRaR4B++tZ7YgoOL4qxPb+58xWUoy51R7CQwZf3o0b7i2ncP+To6+gE=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB8421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(376014)(18002099003)(22082099003)(4143699003)(38070700021)(11063799006)(10067099003)(56012099006)(6133799003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <081564FF54BEED49B5AF2E03CAF9407E@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 jdPW43TNrK0wGXKjyElhs5gh5zBfCxmN1X/VYQLMF225GiUVfABPQUTYEIJafFGVz8/COWdrhj7BsQfIadXHP/vHPMtsWSdnf/Rxqt19/qlB/9Mar8pOTql9cWJU6q3c+uYOkInR5jShmwbYMlW0ZSxARc5ywmNo0p5aGtmthAznp9OmsZIBLRzResArnyjtNy6eb/bMppmCj2vtq4PHXOiV+U349/s7NTSWQYwdGdEGdvrXCdSyl/8NB9cv6LqQ7LUX2loHuYcwcdSPvPQ7NhU2UJrHSsBAezPho5nnVYwIIvd4ElnVyWcx/NQxZZVz0gWS3vrTtYprv8Mdkr0DuA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI0PR08MB11408
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB5PEPF00014B97.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	3600914f-5316-4232-c47c-08deef045c02
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|36860700016|376014|1800799024|23010399003|14060799003|82310400026|18002099003|22082099003|10067099003|11063799006|6133799003|4143699003|56012099006;
X-Microsoft-Antispam-Message-Info:
	baFbgHv0C721CRrl0FpZMmZYYuqDiof/6prHnLQUjLDi7ngPl6J+z7fBCdKbxXq5+8C+UDm5EYiy5WhBDQhk4wA0asNDirt2/rYgBxB1f1bOlzC74tViO29hNwzTgPGX68qIEWUIYU9gua2G35ET1gIDX6LBo3hWgwmPwgCnqBTOnHgB0IVIdlxiLnRH1n3uI2bLa4vFakc/A+LZQNkGqyvEPQTm3WUfAu9FHsOvYh8gZ4GsfoAKj6DnAYLEzOhvcp4MDYp4NhieInCD7XnZ/SBSXih0HGGu/p5ebO/yTDNqqExHRnZMcH/o3t4/ty+cBh13yxiWVlL0E1EgmlVZJ42J4S0Gz/yjuKgOFqtlVsMf0IiHTnmwDYsVpSNlVv+7pBjR2roxzBsVrckZiKqUVDCRd9oYeDvpMay3/u9oLxntAI6NePOSJzb2IZ1+gTeJfncpq1R4wMGG+gQNOwmNDOrYZIN2XHsri8q04hVQQa2FVvEzQ4Ex4NZcjeb5sJdUsPwW9hZlUtRahAJlVVSaqstNMF8x79b4dF5cXTSjEdl8UFP1RoDVAzJpJdAW8ArzypLIbi2XhfH7L/0GU+SzvdupVSOJWRpeXkLvpSg2YV4W98lbzTeXU1b84zndEMzATPkDONtr4b5DQnCy46uiZ6TXKAeIrNiiK5rl416ukpMEo7wj6lALxbRy9tMEXB9V9TyEjFzPyh9L2hghaCVWhQ==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(36860700016)(376014)(1800799024)(23010399003)(14060799003)(82310400026)(18002099003)(22082099003)(10067099003)(11063799006)(6133799003)(4143699003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	8O3AuJKS3ILy2wBw5lLZ2rpjWMcOWZLg5TfiJ7n2PZWgddamE6kpcvDI6RfShjjNRsEDgwqLMA/JVMaC/Jqbw2afyFLEtkxvB0bjrm+gGkjR5I+5SZiGdlgIsuiYELS3qLNbziD9ww1bvHgE0fvS9T0vTRhODwUj/tsUwN2Dh7GUKyWU8yvIu9FxGWUYUZ/XbEZrrtOYK3PBvdWp/Qm0CH095jVSWtykP2W/GcT5po3xbO7a0Ts0fwa5gsU7pCsYgDavxoznX8tWZqiox4nohu+21LL7rtEqBZ5L8Lb85/4tGvfQuFSS0fCR/qLDkRXtPaZGw8WPV5RSevNfwH0bCsTVEzsyLmJmJ3nnAFgJC2RUIzs+d4MoghSBGDUDym2758KTefMcrxy87tL5cz9rcNBoTAAUj4pvy0PN2BG3WCl8NhTzELbYqMZNbPsCPflp
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2026 13:06:16.7652
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 78287d18-c1dc-45e4-f51b-08deef0481bc
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB5PEPF00014B97.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR08MB11245

T24gRnJpLCAyMDI2LTA3LTI0IGF0IDExOjMzICswMDAwLCBzYXNoaWtvLWJvdEBrZXJuZWwub3Jn
IHdyb3RlOg0KPiBUaGFuayB5b3UgZm9yIHlvdXIgY29udHJpYnV0aW9uISBTYXNoaWtvIEFJIHJl
dmlldyBmb3VuZCAyIHBvdGVudGlhbA0KPiBpc3N1ZShzKSB0byBjb25zaWRlcjoNCj4gLSBbSGln
aF0gR0lDdjUgU1BJcyBjYW5ub3QgYmUgcmV0cmlldmVkIGJlY2F1c2UgdmdpY19nZXRfaXJxKCkN
Cj4gZXhwbGljaXRseSByZWplY3RzIG5vbi1wcml2YXRlIEdJQ3Y1IElSUXMsIHJlbmRlcmluZyB0
aGUgbmV3bHkNCj4gYWN0aXZhdGVkIElSUyBTUEkgY29uZmlndXJhdGlvbiBicm9rZW4uDQo+IC0g
W0hpZ2hdIEFsbG93aW5nIHVzZXJzcGFjZSB0byBjb25maWd1cmUgdXAgdG8gNjUsNTM2IEdJQ3Y1
IFNQSXMNCj4gdHJpZ2dlcnMgYSBsYXJnZSBjb250aWd1b3VzIG1lbW9yeSBhbGxvY2F0aW9uIHZp
YSBrY2FsbG9jLCB3aGljaCBjYW4NCj4gZGV0ZXJtaW5pc3RpY2FsbHkgZmFpbCBhbmQgY2F1c2Ug
a2VybmVsIHdhcm5pbmdzLCByZXN1bHRpbmcgaW4gYQ0KPiBob3N0LXNpZGUgRG9TLg0KPiAtLQ0K
PiANCj4gLS0tIFBhdGNoIFsyMl06IFtQQVRDSCB2NCAyMi80OF0gS1ZNOiBhcm02NDogZ2ljLXY1
OiBSZWdpc3RlciB0aGUgSVJTDQo+IElPREVWIC0tLQ0KPiBjb21taXQgZDBmNDk1MDNjOWU5MGFi
NmFiOWY3MWNiNWJhMjJkNTljNTY0YmNkOA0KPiBBdXRob3I6IFNhc2NoYSBCaXNjaG9mZiA8U2Fz
Y2hhLkJpc2Nob2ZmQGFybS5jb20+DQo+IEtWTTogYXJtNjQ6IGdpYy12NTogUmVnaXN0ZXIgdGhl
IElSUyBJT0RFVg0KPiANCj4gTm93IHRoYXQgd2UgaGF2ZSBhbiBlbXVsYXRlZCBJUlMsIGl0IG5l
ZWRzIHRvIGJlIHJlZ2lzdGVyZWQsIHdoaWNoDQo+IGVuc3VyZXMgdGhhdA0KPiBndWVzdCBhY2Nl
c3NlcyB0byB0aGUgTU1JTyByZWdpb25zIGhhbmRsZWQgYnkgdGhlIGRldmljZSBhcmUgaGFuZGxl
ZA0KPiBhcHByb3ByaWF0ZWx5IGluIEtWTS4gQXMgcGFydCBvZiB0aGlzIGNoYW5nZSwgZXhwb3Nl
IHNldHRpbmcgdGhlDQo+IGFkZHJlc3Mgb2YNCj4gdGhlIGVtdWxhdGVkIElSUyB2aWEgS1ZNX1ZH
SUNfVjVfQUREUl9UWVBFX0lSUyB0byB1c2Vyc3BhY2UuIEFsc28NCj4gYWxsb3cNCj4gdXNlcnNw
YWNlIHRvIHNldCB0aGUgbnVtYmVyIG9mIFNQSXMgaGFuZGxlZCBieSB0aGUgZW11bGF0ZWQgR0lD
djUNCj4gaW1wbGVtZW50YXRpb24uDQo+IA0KPiA+IGRpZmYgLS1naXQgYS9hcmNoL2FybTY0L2t2
bS92Z2ljL3ZnaWMta3ZtLWRldmljZS5jDQo+ID4gYi9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMt
a3ZtLWRldmljZS5jDQo+ID4gaW5kZXggOTBiZTk5NDQzZGYzYi4uOGMyYzY4ODZhZjRlMyAxMDA2
NDQNCj4gPiAtLS0gYS9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMta3ZtLWRldmljZS5jDQo+ID4g
KysrIGIvYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLWt2bS1kZXZpY2UuYw0KPiANCj4gWyAuLi4g
XQ0KPiANCj4gPiBAQCAtMjI0LDMxICsyMzIsNDggQEAgc3RhdGljIGludCB2Z2ljX3NldF9jb21t
b25fYXR0cihzdHJ1Y3QNCj4gPiBrdm1fZGV2aWNlICpkZXYsDQo+ID4gwqAJCWlmIChnZXRfdXNl
cih2YWwsIHVhZGRyKSkNCj4gPiDCoAkJCXJldHVybiAtRUZBVUxUOw0KPiA+IMKgDQo+ID4gLQkJ
LyoNCj4gPiAtCQkgKiBXZSByZXF1aXJlOg0KPiA+IC0JCSAqIC0gYXQgbGVhc3QgMzIgU1BJcyBv
biB0b3Agb2YgdGhlIDE2IFNHSXMgYW5kIDE2DQo+ID4gUFBJcw0KPiA+IC0JCSAqIC0gYXQgbW9z
dCAxMDI0IGludGVycnVwdHMNCj4gPiAtCQkgKiAtIGEgbXVsdGlwbGUgb2YgMzIgaW50ZXJydXB0
cw0KPiA+IC0JCSAqLw0KPiA+IC0JCWlmICh2YWwgPCAoVkdJQ19OUl9QUklWQVRFX0lSUVMgKyAz
MikgfHwNCj4gPiAtCQnCoMKgwqAgdmFsID4gVkdJQ19NQVhfUkVTRVJWRUQgfHwNCj4gPiAtCQnC
oMKgwqAgKHZhbCAmIDMxKSkNCj4gPiAtCQkJcmV0dXJuIC1FSU5WQUw7DQo+ID4gKwkJaWYgKCF2
Z2ljX2lzX3Y1KGRldi0+a3ZtKSkgew0KPiANCj4gWyAuLi4gXQ0KPiANCj4gPiArCQl9IGVsc2Ug
ew0KPiA+ICsJCQkvKg0KPiA+ICsJCQkgKiBHSUN2NSByZXBvcnRzIGEgbnVtYmVyIG9mIFNQSXMs
IG5vdCBhDQo+ID4gdG90YWwgbnVtYmVyIG9mDQo+ID4gKwkJCSAqIGludGVycnVwdHMuIFJlcXVp
cmUgYSBtdWx0aXBsZSBvZiAzMg0KPiA+IFNQSXMuDQo+ID4gKwkJCSAqLw0KPiA+ICsJCQlpZiAo
dmFsIDwgVkdJQ19WNV9ERUZBVUxUX05SX1NQSVMgfHwNCj4gPiArCQkJwqDCoMKgIHZhbCA+IFZH
SUNfVjVfTUFYX05SX1NQSVMgfHwNCj4gPiArCQkJwqDCoMKgICh2YWwgJiAzMSkpDQo+ID4gKwkJ
CQlyZXR1cm4gLUVJTlZBTDsNCj4gDQo+IFtTZXZlcml0eTogSGlnaF0NCj4gRG9lcyBhbGxvd2lu
ZyB1c2Vyc3BhY2UgdG8gc2V0IG5yX3NwaXMgdXAgdG8gVkdJQ19WNV9NQVhfTlJfU1BJUw0KPiAo
NjU1MzYpIHJpc2sNCj4gdHJpZ2dlcmluZyBhIGhvc3Qtc2lkZSBhbGxvY2F0aW9uIHdhcm5pbmcg
b3IgZmFpbHVyZT8NCj4gDQo+IElmIHVzZXJzcGFjZSBzZXRzIG5yX3NwaXMgdG8gdGhlIG1heGlt
dW0sIEtWTSB3aWxsIGV2ZW50dWFsbHkgY2FsbA0KPiBrY2FsbG9jKCkNCj4gZm9yIHRoZSBTUElz
Og0KPiANCj4gYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLWlycy12NS5jOmt2bV92Z2ljX3Y1X2ly
c19pbml0KCkgew0KPiDCoMKgwqAgLi4uDQo+IAlkaXN0LT5zcGlzID0ga2NhbGxvYyhucl9zcGlz
LCBzaXplb2Yoc3RydWN0IHZnaWNfaXJxKSwNCj4gCQkJwqDCoMKgwqAgR0ZQX0tFUk5FTF9BQ0NP
VU5UKTsNCj4gwqDCoMKgIC4uLg0KPiB9DQo+IA0KPiBTaW5jZSBzaXplb2Yoc3RydWN0IHZnaWNf
aXJxKSBpcyBvdmVyIDEwMCBieXRlcywgdGhpcyByZXF1aXJlcyBhDQo+IHBoeXNpY2FsbHkNCj4g
Y29udGlndW91cyBhbGxvY2F0aW9uIG9mIHJvdWdobHkgN01CLiBUaGlzIGV4Y2VlZHMgdGhlIHR5
cGljYWwNCj4gS01BTExPQ19NQVhfU0laRQ0KPiBvZiA0TUIsIHdoaWNoIHdvdWxkIGNhdXNlIHRo
ZSBhbGxvY2F0aW9uIHRvIGRldGVybWluaXN0aWNhbGx5IGZhaWwNCj4gYW5kDQo+IHBvdGVudGlh
bGx5IHRyaWdnZXIgYSBrZXJuZWwgd2FybmluZyBvciBwYW5pYyAoaWYgcGFuaWNfb25fd2FybiBp
cw0KPiBzZXQpLA0KPiBhbGxvd2luZyBhbiB1bnByaXZpbGVnZWQgdXNlciB0byBjYXVzZSBhIGhv
c3Qtc2lkZSBkZW5pYWwgb2Ygc2VydmljZS4NCg0KT0ssIHllcywgdGhpcyB3b3VsZCBiZSBhbiBp
c3N1ZS4NCg0KRm9sbG93aW5nIGFuIG9mZmxpbmUgZGlzY3Vzc2lvbiB3aXRoIE1hcmMsIEknbSBn
b2luZyB0byBjYXAgU1BJcyBmb3INCkdJQ3Y1IGF0IDEwMjQgZm9yIHRoZSB0aW1lIGJlaW5nLiBU
aGlzIGlzIGEgc2ltaWxhciB1cHBlciBsaW1pdCB0byB3aGF0DQp3ZSBoYXZlIGZvciBHSUN2MyB1
bmRlciBLVk0sIGFuZCB0aGlzIGhhcyBzbyBmYXIgbm90IGJlZW4gYW4gaXNzdWUNCnRoZXJlLiBJ
ZiBhbmQgd2hlbiB0aGUgbmVlZCBhcmlzZXMgaW4gdGhlIGZ1dHVyZSwgdGhpcyBjb3VsZCBiZSBi
dW1wZWQNCnVwLg0KDQo+IA0KPiA+ICsNCj4gPiArCQkJbXV0ZXhfbG9jaygmZGV2LT5rdm0tPmFy
Y2guY29uZmlnX2xvY2spOw0KPiA+ICsJCQlpZiAodmdpY19pbml0aWFsaXplZChkZXYtPmt2bSkg
fHwgZGV2LQ0KPiA+ID5rdm0tPmFyY2gudmdpYy5ucl9zcGlzKQ0KPiA+ICsJCQkJcmV0ID0gLUVC
VVNZOw0KPiA+ICsJCQllbHNlDQo+ID4gKwkJCQlkZXYtPmt2bS0+YXJjaC52Z2ljLm5yX3NwaXMg
PSB2YWw7DQo+IA0KPiBbU2V2ZXJpdHk6IEhpZ2hdDQo+IEFyZSB3ZSBhYmxlIHRvIHJldHJpZXZl
IHRoZXNlIEdJQ3Y1IFNQSXMgb25jZSB0aGV5IGFyZSBjb25maWd1cmVkDQo+IGhlcmU/DQo+IA0K
PiBDdXJyZW50bHksIHZnaWNfZ2V0X2lycSgpIGV4cGxpY2l0bHkgcmVqZWN0cyBub24tcHJpdmF0
ZSBHSUN2NSBJUlFzOg0KPiANCj4gYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLmM6dmdpY19nZXRf
aXJxKCkgew0KPiDCoMKgwqAgLi4uDQo+IAkvKiBOb24tcHJpdmF0ZSBJUlFzIGFyZSBub3QgeWV0
IGltcGxlbWVudGVkIGZvciBHSUN2NSAqLw0KPiAJaWYgKHZnaWNfaXNfdjUoa3ZtKSkNCj4gCQly
ZXR1cm4gTlVMTDsNCj4gwqDCoMKgIC4uLg0KPiB9DQo+IA0KPiBUaGlzIG1lYW5zIHRoYXQgd2hl
biB0aGUgZ3Vlc3QgYWNjZXNzZXMgdGhlIElSUyBNTUlPIGludGVyZmFjZSBmb3INCj4gU1BJcywg
dGhlDQo+IGhhbmRsZXIgKGUuZy4sIHZnaWNfdjVfbW1pb193cml0ZV9pcnNfc3BpKSB3aWxsIGZh
aWwgdG8gcmV0cmlldmUgdGhlDQo+IFNQSQ0KPiBzdHJ1Y3R1cmUgYW5kIHNpbGVudGx5IGFib3J0
LiBXaWxsIHRoaXMgbGVhdmUgR0lDdjUgU1BJcw0KPiB1bmNvbmZpZ3VyYWJsZT8NCg0KV2l0aCBq
dXN0IHRoaXMgY29tbWl0LCB5ZXMuIFRoZSBzdXBwb3J0IGNvbWVzIGluIGEgbGF0ZXIgY29tbWl0
Lg0KDQo+IA0KPiA+ICsJCQltdXRleF91bmxvY2soJmRldi0+a3ZtLT5hcmNoLmNvbmZpZ19sb2Nr
KTsNCj4gPiArCQl9DQo+ID4gwqANCj4gPiDCoAkJcmV0dXJuIHJldDsNCj4gPiDCoAl9DQo+IA0K
DQpUaGFua3MsDQpTYXNjaGENCg==
