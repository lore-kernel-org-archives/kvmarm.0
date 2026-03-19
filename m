Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010035.outbound.protection.outlook.com [52.101.69.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 032BE3EAC9C
	for <kvmarm@lists.linux.dev>; Thu, 19 Mar 2026 15:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.35
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773935862; cv=fail; b=sPmPjwEVsXWElyya1CyBlx0ZKOEKvSrC+Se91UoVaLKOQxYHGLen15W7nayQjhqInNfmoHddeJcb3CDjW6j0FZyBHoJzs8qEMyjN4w2iKi41QR3fBhbVDMJX153Mq8mOI5hKbG1E3jba0ggUucl4gccPrNFQIVD6dwJmrhDQdgE=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773935862; c=relaxed/simple;
	bh=vP4ss0r8hqfGcc/IRB0endD9iLYMjOdIejmOLX7/hBc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ZZZonWaGtiD8bKaXl4fcnowVGyQuDz/xIApmvXV3npoVfJaoBvPRtKR3iLZZm4p+rEOS6UdbKE4rgdzzq3pF1AkYkj8dC2InR9jYJ83TT5nft5iwPXcCi3kerrZWLKfWCVvZGJ6irRUeRt1i4Q072DgIm6e5cZ4f0JXEyMf/BD8=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=HKDoOhOU; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=HKDoOhOU; arc=fail smtp.client-ip=52.101.69.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="HKDoOhOU";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="HKDoOhOU"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=f9VWlp4+ZW4uCGryazAb59Ld4orbXnjWrAy9POzNrqihQBbaRw65/LNjPCOxY351w3r6bkl10o/Urx3wUdvr0eCqocKFBgqYBC4Fkelpg476nKgTvNASyJJknFeItWOzKrGaO8BuYLk9K0LYfYfzF4S9fy+RTjuGiMtcmpDFCpJPlU0CbGNa0nzDDxB8SpM6/woUv7SZEon8/Cza3ummbgEcFa44XoExgcYIZGNinO9lmmH/fgso3a5tBN6S41NX+QIq3lR62oqSyyACZ2GFMUTb7gEm6fUzhTk1pis5LCmhnL4pe8M3kfeKYP8R+rLoBMLnJ0yVOITmlekNDRNjZw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XSYsK5rJ2TFNQ5sx9fuQfPtKOQ3Ob9Kh4sC/NAg3v5U=;
 b=XI4D231fPVTLRO2mQkpazeZ0S4HGNrj+T9vynYyPAUWDOdsuPf8iaHX69P7E9mYQDvoeGx5jr0R9uzWwPn0tLJnloMfc1mxKua9+gj5SXChiAVeh/+l6zumJG8PwPCXufObNU5GgBqSComhDaqq6MVrKgvPNhVxKJZdmbP1XZ5JiwjeqjWxB13RJAhLSXBippRpdoNoud4AKwcHhW/suSwqczP0rNzA2MZ2hlLnN2gYysjKUA601BkUNwIUwXNpoFzcb5GdIkCXR3sruVxy41xcMXLnlgNWuLijDOSVBphi8zfSp/xpotb5SweiTI4evDjnkPBCFKgM8n3yI9kS3Fg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XSYsK5rJ2TFNQ5sx9fuQfPtKOQ3Ob9Kh4sC/NAg3v5U=;
 b=HKDoOhOUL5xVt2pAy2oTPpbY1kYwKl9sQiVwJwGfMe/CocTB3LAXApGVEni2iA2hyEFcFzutr3sNca2d95QY6PGBZeNmc7QuuNyrZe+2EmeItS+ln5W4u67J7N5zlLTiWKLpU2uK16neE4cjbOV9/Rk6gY+U7bwCFoB1eanpeFM=
Received: from AM8P190CA0003.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:219::8)
 by AS4PR08MB7530.eurprd08.prod.outlook.com (2603:10a6:20b:4f9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Thu, 19 Mar
 2026 15:57:32 +0000
Received: from AMS0EPF0000019F.eurprd05.prod.outlook.com
 (2603:10a6:20b:219:cafe::f6) by AM8P190CA0003.outlook.office365.com
 (2603:10a6:20b:219::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.19 via Frontend Transport; Thu,
 19 Mar 2026 15:57:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF0000019F.mail.protection.outlook.com (10.167.16.251) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.19
 via Frontend Transport; Thu, 19 Mar 2026 15:57:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=brYcWTymGCMQMlPWrBJE0DwwbiIbEH7eOS7p4mt8DOJVB3v7E14+H5IYvya1n4Hu8nBsibQ/sHxjRmklKjRXR6DvQyKcJX+xaKxPJIbw1kj4xl/fFXX40pth6L05o4n95nNm/qM96YCxlgpkriyjpDdI3MmBWiTiibfbyMBiHs39BugCXJ8gThhjzNmtBbdAU34QA6mT0R2dsJ4ttjGI91IdIiQFL1HSewRL9Ox1dt/DdnZrQZ6erz6AQKws8NXPErDW/QLtBP2O/xu/HCFMOYUGLs05jHHVkL6An+pk1MoqccUG5JQv3haOtKMCrhnupKEkUr9/5JKh1inX4Rk6DQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XSYsK5rJ2TFNQ5sx9fuQfPtKOQ3Ob9Kh4sC/NAg3v5U=;
 b=mSE1ArR9r3sosT7DFgP17/rsBHzRD7wJiuye0ETO+DgWa+qgcDsTcAWIwowBDiAo+KKb2aSs+9dovvVkWV8RzPv5TYbYS0QzH3yHvFHTsMem2o+B6Rn5SPdD0tEOHVWhpf0kbucl8b/rY9BYO80e0EJCyyT8pRW75VV+7CCf1dz7p90UZx1dy6QPwDehbMdxNReL4ALuvaebwINGKA1ZgQpXzTke7/blpBUJDHFf6zOkHke65rG9YpvuYJF5zrZHNkxuazxkuoV0i7cl0YJ7IuPaSZpCxRmNqMeNueamtFeZxCmVYzhuO44VriuzPONCPrYYpCnWgQbvVNQD3gXDRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XSYsK5rJ2TFNQ5sx9fuQfPtKOQ3Ob9Kh4sC/NAg3v5U=;
 b=HKDoOhOUL5xVt2pAy2oTPpbY1kYwKl9sQiVwJwGfMe/CocTB3LAXApGVEni2iA2hyEFcFzutr3sNca2d95QY6PGBZeNmc7QuuNyrZe+2EmeItS+ln5W4u67J7N5zlLTiWKLpU2uK16neE4cjbOV9/Rk6gY+U7bwCFoB1eanpeFM=
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com (2603:10a6:20b:504::10)
 by DU0PR08MB8345.eurprd08.prod.outlook.com (2603:10a6:10:40b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Thu, 19 Mar
 2026 15:56:28 +0000
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27]) by AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27%6]) with mapi id 15.20.9723.018; Thu, 19 Mar 2026
 15:56:28 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, Joey Gouly
	<Joey.Gouly@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>, "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	Timothy Hayes <Timothy.Hayes@arm.com>, "jonathan.cameron@huawei.com"
	<jonathan.cameron@huawei.com>
Subject: [PATCH v7 26/41] KVM: arm64: gic-v5: Implement direct injection of
 PPIs
Thread-Topic: [PATCH v7 26/41] KVM: arm64: gic-v5: Implement direct injection
 of PPIs
Thread-Index: AQHct7jywJWw0qDY7EyWrWFZfI5CFQ==
Date: Thu, 19 Mar 2026 15:56:28 +0000
Message-ID: <20260319154937.3619520-27-sascha.bischoff@arm.com>
References: <20260319154937.3619520-1-sascha.bischoff@arm.com>
In-Reply-To: <20260319154937.3619520-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AS4PR08MB8241:EE_|DU0PR08MB8345:EE_|AMS0EPF0000019F:EE_|AS4PR08MB7530:EE_
X-MS-Office365-Filtering-Correlation-Id: 04efffbd-5d3d-43be-9b9d-08de85d03b02
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|18002099003|22082099003|56012099003|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 2H+vN5UE3m127xp7dS81gJjVH7xl5VmtTkasTfAhiGKNkFrq90cpePw5lpWFmjvqooroM47SdkQ/fMeMWy6sdXjV93LndkMFgQQ+zoU/+iXQslYIHGlHLMDZ255saWv+ck7L2jQzU5DmYDUIBjwhs3VB0nB8CzpraDWopo6wDxsL67/BlMkNvzemxYDHcKHgo4LQXvC6GNIwgudiL/cxN6mbJNQqG+kbue4aQigpiolXxL2MZ9Ul/0H2z1k3wMlsIUDZh5v9hx5vViEMjck3Zz7OLpgQ8d0vZ1oirXAHoxNBjWaVvQnTUM+hxMkEDZN8CUq/UYV6+tcrBIcwlQOkXSfEY+LoDsxpGEHuadbcetKhlGfjrLI1BYZUONPPd8U/903J3kacW7AHB9rrNQPzYGt5mjdXrX+ZBsCi1QDjxxg4JQhn9S28yu95oDtDf6DQms/+fPOW83xhLGIIusQuYCDCdBDacHKhawnWueLNFY5dfhq3oYwEEmd9evZjAJBO/R6ttZ9SUHYzPo+0nAgWRctM1QAjJmi+uTZXTDF51y9lvEhzjSMLQdoQmMLz2LOL6mjEr7CYW67G0aeyWVKK8aIvgMmAJftEXq+fgQml2ISy8UHXYw5wlFGfVUskRc2Q0/ruTuYkUEn/8qaxya4hVm2I8Kh4MnyUDRvDIrZ/VixFYJjqqy5878x+H0Uqt8GspLF3HY+zCRv8dW1m1BmE3iCjpWARsYvkEsIc21YHnFDboPMAbirLcKexJXAE+Ker2Olh+q1c8oiWcnFTIM4rdsVCf+8CbtuDIVZdwX4avHs=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS4PR08MB8241.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(18002099003)(22082099003)(56012099003)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 tThYKRvRkpoxkw5zMG0YrG2gNdySPCth9wR/0wJhrPOQN8eEAtOGBgDfBvc+dKJW11aJXaL3lo62ANvXAbTA3rD1vm1MQ86g6oDCVe2NMsCwA0SOKdR/FtzK5awVmWK9L55tjUT8OG9+adRwoKuQ6I0NQiGH6vC8m0X0lkYPKH6BzYvqKoDsa1jZiG9iLdq+pVHHeQ0mBEjQJOWB0s0fM0yAF+NxoSOrmieofGD2KKMVUUL63PfctjlnFyLuf/c+TTZA07H8+bWLR2hzqA5yKt/9wP3byiFsUYxpqqUX4XmOPUmglS9jJjcvt9xntyina1Ev8sXtgnUQVjuWx8uLEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB8345
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF0000019F.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	1363ce06-3d62-44f0-7700-08de85d01500
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|35042699022|82310400026|1800799024|376014|14060799003|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	B6dlAp2MRUhLhq9KtnDcFkSSwZugvZolW8Wy/RlVdcrWZzmBKdfWUZOPRLh18gDQFx5UaHzAa3DhCacdtLP8JL2POc4oH4PDujXTkwiJkBA8z3a3jHY0DMcdYBow2xWpk8wxzBPNl5cz6kmqFgzOjaUdR5f3DuDNrpisl+fnYKuQWu/m7d8V+7WoOKlrN66wLacfBfxa1DLEAtlbXdKttTj/TXqRlkIz1wJiM9As+CWCmIX+zTPqyy4+LVgGfKbWknI9ETNJAHF7Yy8jZ4V4+CxNKyVifdQ3CJyKLIgTrpW9MjPp+x8568RyvfvdaUKNZNXQjduQajMuhLojppA8l+1kDL73wuHaFNdb1cpmmMxaFRRyZPECi/dZVkQDRWa90LOfzhmd60Wr/dlE1wjSoHcS08Of8j4NgzI3YXxf871MiXZ+1BMF1R8zsu/MCDJ2oEq0XTA9Ss3XcqxWKw2cg2gWhI6aHTI+h6NgGu2M2+dl1Ozazc+1Pd6nKaVAsucn6qrCHR2ui1xFhCxZoc/TWYz1QKmQbCzI53V0CjgdUmbLIcCVRl91T6kzVKj1D3kodWsExT9gSdlkUrWwB26JVSReZhwl5pmjhkROeeRZPuzB1DYrVuIdEI+TrajoKHiUBfw8irxZGBPjpJEQV6B++SHA/LhrTjibQpEeMEAUWTLzECslFWTPEX9FaD4lHXEPoCpiwCxL1hsazsI95Z4KQWNRvllCw5HO3CnftrKGSEdPf6+8fMUaUKfqCY3ZDct1/j2BqhPVmQZz3sK68Opa4w==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(35042699022)(82310400026)(1800799024)(376014)(14060799003)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	1r1juJF7hjGL16Zv/c+ZplzC+gcYQjb38XhaBMZurRp5c0H9Wj5kGxJ+HKLcSfN0xCd7piLipReTDuv7nRhezXadJeWonAKprI1zje8te9rZlf6aEZGj6tJj/E8EV5+pVujEhmfTaNufXugGI1g+vhDhKODXpXyJOqbbmVTe5Ea1W/KTck7z0NW+HknzAy90ab5LqEKDlM/X9Vkgg04JrDLJj9db/EXnfzzbKGouG1xYqEQt3zXNhCWrzCZshL9mLNyGW/+CSxOSiskwEODaUECv7LefmmY0yOBWnh67SwHG3s0OXEzun11g/05EVIgl4YLWYh5irtPFzFblOjLSiZq8M7CAKei32IdF4hRlMcInB7bnKJyg/VGYnIKJ6gg3/ktpB0jkQ8MAh84+itrDNZIKBjbvuAzmYHJbrgSeLd+xIsI0puSaTipyCakgJGfC
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2026 15:57:32.1244
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 04efffbd-5d3d-43be-9b9d-08de85d03b02
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF0000019F.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR08MB7530

GICv5 is able to directly inject PPI pending state into a guest using
a mechanism called DVI whereby the pending bit for a paticular PPI is
driven directly by the physically-connected hardware. This mechanism
itself doesn't allow for any ID translation, so the host interrupt is
directly mapped into a guest with the same interrupt ID.

When mapping a virtual interrupt to a physical interrupt via
kvm_vgic_map_irq for a GICv5 guest, check if the interrupt itself is a
PPI or not. If it is, and the host's interrupt ID matches that used
for the guest DVI is enabled, and the interrupt itself is marked as
directly_injected.

When the interrupt is unmapped again, this process is reversed, and
DVI is disabled for the interrupt again.

Note: the expectation is that a directly injected PPI is disabled on
the host while the guest state is loaded. The reason is that although
DVI is enabled to drive the guest's pending state directly, the host
pending state also remains driven. In order to avoid the same PPI
firing on both the host and the guest, the host's interrupt must be
disabled (masked). This is left up to the code that owns the device
generating the PPI as this needs to be handled on a per-VM basis. One
VM might use DVI, while another might not, in which case the physical
PPI should be enabled for the latter.

Co-authored-by: Timothy Hayes <timothy.hayes@arm.com>
Signed-off-by: Timothy Hayes <timothy.hayes@arm.com>
Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
---
 arch/arm64/kvm/vgic/vgic-v5.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index f0600be619b14..b84324f0a3114 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -188,8 +188,24 @@ static bool vgic_v5_ppi_queue_irq_unlock(struct kvm *k=
vm, struct vgic_irq *irq,
 	return false;
 }
=20
+/*
+ * Sets/clears the corresponding bit in the ICH_PPI_DVIR register.
+ */
+static void vgic_v5_set_ppi_dvi(struct kvm_vcpu *vcpu, struct vgic_irq *ir=
q,
+				bool dvi)
+{
+	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+	u32 ppi;
+
+	lockdep_assert_held(&irq->irq_lock);
+
+	ppi =3D vgic_v5_get_hwirq_id(irq->intid);
+	__assign_bit(ppi, cpu_if->vgic_ppi_dvir, dvi);
+}
+
 static struct irq_ops vgic_v5_ppi_irq_ops =3D {
 	.queue_irq_unlock =3D vgic_v5_ppi_queue_irq_unlock,
+	.set_direct_injection =3D vgic_v5_set_ppi_dvi,
 };
=20
 void vgic_v5_set_ppi_ops(struct kvm_vcpu *vcpu, u32 vintid)
--=20
2.34.1
