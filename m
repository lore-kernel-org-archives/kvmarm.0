Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011035.outbound.protection.outlook.com [52.101.70.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E9C9280331
	for <kvmarm@lists.linux.dev>; Thu, 21 May 2026 14:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.35
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779375144; cv=fail; b=hNsbP6jlR5PG1aUqD1U7LZmGeLLHM3Tjjuc3Wi/kguz6DNSNkjaAW7mkYGIFHUZ5Q1rWDrzsfXGjwPUD6DPm8UFCVybMbXuC7dhZzUQJkfKorrzB7sPnjCO7oxvAoJMfJ+m67oSsqYQlHJWzMft6c3B3Fu5/04oHjGrZTtC1vyw=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779375144; c=relaxed/simple;
	bh=P6dK04Fm3cMumns1HjPZu1FhoROQ6UMmXjAimmyxDQE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=q/sEvZb3dxh7+bZU+qHVOGP72/itwoGuTUO64kaOAiFgj22AIX2thFjM28oIUPbs9pAuiBfOaaK4q70phrwg2kjztdVHuVNXE6fgQRk2owEo4tyAsOR00hXvpNIOeBrunIYf5WuN0O22yh34Ultnm3MBD66cFo3agbWf+sjDZ54=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=WI5nG9Na; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=WI5nG9Na; arc=fail smtp.client-ip=52.101.70.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="WI5nG9Na";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="WI5nG9Na"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=fail;
 b=StRz7hDmL+PApHKU5IBBkPUhNDhfhFWSNdhtTbfSHDGl85AgggcqWWRkkH15PVLtRLkeAr4Q0zWoXXgOSuDQZDbkvc9wWMGpn5w03Rq+23EOEDsFVfa6HrEtYnAuk43K8n1AXNQb5Bzcn3bfX3K1W3lHPXP+bHOe6UTConsVUSS4iMEn64gDew5/cCgZNRYxKbJeB+qasnwrg8xlxhzSsfJ1fcWLM9rq5Io8BbQ+ZYn909OHwyj6IFrB+yO0SdJO6ljSUGIQPun3XtSy3iMxKvvRXUm8jD17kpJf53LzVuQ2X/laIybPlo0Z+AzBtiauz/ZLDMZy57hD8Jp+6wYfaw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pxfBMiJAVszFzXJhUB89V+sCYs2b/JPiu3Ew90T+i14=;
 b=hYRNWhLW2OhS4DvJJIkxIaffWfDYDPmAKWdvxu0StAopQsinngZbGKNVc/sAD62j7GN5R921Gj9xkblBS8T1Xkc8WpxZApWmyNeqre+uWeLFeCFdgt4ov5U3NbmBvgAYxAQj5VLxOd1w+uQx29lwBW3/r3suOuzlCQWE00ld9Xit17178XObKppQBYoselW0/B4Qrog2p728CjJqiIR5q2SpvWhjeNUsOoPmj2hEvr3vKHQsWEG4wNT4NXiOpkaHC9E51sYj6e3o3RYr6wfM/Hzjc3qeALSXh/g3fYbCc/XK52Od3TaTRLXJD/VH0pGcP5eeK7AlAGFlE0tWUQwElQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=fail (48)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pxfBMiJAVszFzXJhUB89V+sCYs2b/JPiu3Ew90T+i14=;
 b=WI5nG9NaT78NQCEg29xd/AOJ5rfUgFJxx+7UJiQ5D80eGy1mEnqzMoLVq4GjzHkxS/Z1nCzavv95VpZIPlUcmeC3ApS5MKdHB7QrgprMXwyW7tIBl7lEUTTLAgScH/7JH3npQRb7+BmR8aUcOMbF+2uMlUn3Wh2W/G8YMc3ivjs=
Received: from CWLP265CA0483.GBRP265.PROD.OUTLOOK.COM (2603:10a6:400:18a::17)
 by VE1PR08MB5870.eurprd08.prod.outlook.com (2603:10a6:800:1a8::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.17; Thu, 21 May
 2026 14:52:14 +0000
Received: from AMS0EPF00000197.eurprd05.prod.outlook.com
 (2603:10a6:400:18a:cafe::f2) by CWLP265CA0483.outlook.office365.com
 (2603:10a6:400:18a::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.48.17 via Frontend Transport; Thu, 21
 May 2026 14:52:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF00000197.mail.protection.outlook.com (10.167.16.219) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.71.7 via
 Frontend Transport; Thu, 21 May 2026 14:52:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cGX46Z0smZuS9V7vk02RjMc67imcJ8fcTAXVHM6LS/lvu14El6VLJ1TTeYRHp7VLKO6hZo2ILMSAdaDYTsiBrDTBZDdbAhohE+/fSfVQ2+rFYSQMex+WiIuEMMhOayLIzZ710cs4qKla5M6PuIfpuzjT9vD+WyeZzMagNNvHEwQ/T7s5371F/FHWCmwI44MuqNwjB7heKEfqBtjIFE0NoAS/kEYiCSwVjE3b7mgx9uzDwLG4iMZUQv769hkoMMpEWYJe846tCQSIj6E58RsWuKqqX1NsE7XMsq+WTwQU6/+iEtIqGSI3Tm1NUV1Bzh7+hWZNT8uPcW4MzDIKbDCS1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pxfBMiJAVszFzXJhUB89V+sCYs2b/JPiu3Ew90T+i14=;
 b=LMBlx3fGiWY9qIiXl7WYKmcLDDoAh8wgWa/TWRR+N5TQFUPZDLXI1nlSrDFlI+KiUAeLN07Ao7LY31of+g10Za0QEbGOv6NWY+j6V+rGYjYaXNRMuAcoVdmFgJ60TMmhDwoLTAMtw+2dmzyfU2KqIKurliATh3IJQx/4115/vM1ZWd2V5i9xOUib2UpJT1Npp/o5rsksqKTTFczvATYeBPRRWpN73dBE4JqKo7eKwXLBjpNBxvQMcRhgnNlyR888LUbwJ91v6YyVUr3OkNZ6nKrwJIKyZARJULJbWDKkIv5G7GqyV1d4sNWWu0aeMWz2dzIUd+aFcvlqNgYoMAZ7ig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pxfBMiJAVszFzXJhUB89V+sCYs2b/JPiu3Ew90T+i14=;
 b=WI5nG9NaT78NQCEg29xd/AOJ5rfUgFJxx+7UJiQ5D80eGy1mEnqzMoLVq4GjzHkxS/Z1nCzavv95VpZIPlUcmeC3ApS5MKdHB7QrgprMXwyW7tIBl7lEUTTLAgScH/7JH3npQRb7+BmR8aUcOMbF+2uMlUn3Wh2W/G8YMc3ivjs=
Received: from GV1PR08MB7315.eurprd08.prod.outlook.com (2603:10a6:150:1e::15)
 by VE1PR08MB5856.eurprd08.prod.outlook.com (2603:10a6:800:1ab::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.17; Thu, 21 May
 2026 14:51:11 +0000
Received: from GV1PR08MB7315.eurprd08.prod.outlook.com
 ([fe80::c249:1aed:a4c2:4193]) by GV1PR08MB7315.eurprd08.prod.outlook.com
 ([fe80::c249:1aed:a4c2:4193%3]) with mapi id 15.21.0048.013; Thu, 21 May 2026
 14:51:11 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, Joey Gouly
	<Joey.Gouly@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>, "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	Timothy Hayes <Timothy.Hayes@arm.com>
Subject: [PATCH v2 06/39] arm64/sysreg: Update ICC_CR0_EL1 with LINK and
 LINK_IDLE fields
Thread-Topic: [PATCH v2 06/39] arm64/sysreg: Update ICC_CR0_EL1 with LINK and
 LINK_IDLE fields
Thread-Index: AQHc6TFDm/R9LHfjAUW/UDyfu82VOQ==
Date: Thu, 21 May 2026 14:51:11 +0000
Message-ID: <20260521144846.1899475-7-sascha.bischoff@arm.com>
References: <20260521144846.1899475-1-sascha.bischoff@arm.com>
In-Reply-To: <20260521144846.1899475-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	GV1PR08MB7315:EE_|VE1PR08MB5856:EE_|AMS0EPF00000197:EE_|VE1PR08MB5870:EE_
X-MS-Office365-Filtering-Correlation-Id: dfcbfef2-4c2c-48b4-b5c0-08deb7488bbf
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|38070700021|56012099003|18002099003|22082099003|11063799006|6133799003;
X-Microsoft-Antispam-Message-Info-Original:
 QmhHKZrcnLtl2X8F9FNODv8mhathd9MZuy7kRhmthKVnPXcr6XR7ewadZAG0yyr8WkorS4XAXDr7ZEruIye3qffDF5CKDsuMUQ+nxPdCcWUjFdwQWeW3AhopYzVO215PCiDI94hSxuSsNukMII10yglg0Rs5rVjOevbVaOwZ27etRAluqhjERCJP1ANhM/mPALXewixX24eOaaWBJImymag61XFeQYLcB5/yIa/2U+BMiprOguzKKsztiUbOAdBYmvcaZwIwKYG75ZRYBJMzYW69OgIqmNZJVPt3yU8ZBB2DOFjMGRbZTpQiP9g5yeaWXyh+SfubF6yOyK4+6+kD1T1GeGQavPygL7RNcWcNdbkJ3L/t4FinTBNc93o+NdWTa9SAML3uRUNO2zm3rKX/ZSSA6ydxwiHthlUj5nbyK60vcSCMm4CFV/v/H3f12YsAh97F/Jsc9+I7/zE7jG7LaShPXFGKIvtB5/spzLDvH8wlQLvCPCbvY3lCrrY9BaLDGgCrOByUQgzoLTrgsZtzFW72BckqNr0+rDWUF9622g3g/s5b0l7hkVKqGW8OfFTcpM0V3iuszOW17uPKOaVIRKefFRCjvGz4CnYK8hC/MEC/Etgi0LZW/3MMEce1eKiTEdEEmApqjQlZIWmEQZSmcTPf8XaSt0auRi4/c4X/q8vQRK3tnbMy0r43kXYpFEtzUkIGeG8THh+uUl1tDfqRNM6g6UAmqVKdZJa56fiDszooFlcC5sjMmu3IhSf31KS6
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB7315.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700021)(56012099003)(18002099003)(22082099003)(11063799006)(6133799003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 jh4R0H9eDZwG/2S1hfySQGY196/qW8wX4g05Cnk/XH664mdUiTOY6gRMi1pAQI92OB8sRKUOvvwRsnEx8+Ups7J8+cTP3EhE5ovdJVIfvqFeeYQEtWlbHwWJwdGRe1xOsFUevU6UR8qdF+55kLM6FvMk4hHpSvN9yILI9pSduQ/qh2pjcv6eiu8AteSC7QgQSDrFNgaCQU8JsJUcgyYPbssve4DDudRRPxIYyGDWpqD3kXcq3iu0b4BMTn+uvmzPvU9wyiBA7hnGOO+4WmLyeVBuGshtpnr28DV7DmcxzqODOgW/QV8RaItGJZDJX3TJ71AwTcwJ3o3EZDSyKL0R+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR08MB5856
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF00000197.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	43c2b139-bf43-4b36-fff3-08deb7486622
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|14060799003|35042699022|1800799024|376014|11063799006|6133799003|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	MRDshz8hWAvAFw8R97/eKp2rblGO3DoheIh9cwxvVSt9zbPNPSR4fglBVoYv3HN46Rz9Iv/00m7N83n3hQ+jIhBVIKa6M3NW5/KGVoGgqYeQdcp6shX+v9gL/t/RhsesglBeLb6PkmfMg4oFaNS9dwId6A45hvwK00INGg6IkBLuZgcowNTU707+AfKTOgf8Bz93PwWKfpd260//bM+d8lxFqcFHajzP7q2S0CqLcNytMYtapdrLcU/nvddL1QpGFalss/4oWbaIXML0sC03ecwVlOiORKOE8aWQtgmUhosEt2GOLShDfX7CPLwsNbttJe1P7nqKd0+E7+ZjceL9kbLbgyXEc/QeCv8AVqP/lqEy/4n1PSO9GOW/Of8uWz24Wmc6dHhH5jHKN8LFFKvXHevNlSxyiWKPPsl/HN0LjJzY595n4nk+++NQ81g1OAPw3rxtJZ1J6NvRwuv9cVKHGvZP8m3THXDbD4hoH3jzlDJXGddjQVUpnvZjpG3Vkqd3L2RpuS463lq5LlSpPctrpvdZKyxkyeTh/mTfP7rRR3WqJ9eVieWv5n6v9T7EmW6JR1eqy/YpmeaiJZcJPeGHEiClJeMktN+oarlr7YCH5L/ahRXAlL5V+hovDYEe/qDYGlpxuA9CT23HYX1h1Rve6EhkvNLf40oxDghF78Lht6cKEpZFPo+RHUVTRCzjg5x1LBK8fBcy6LBLSLkKkopPkbtosyir8ArH2mZLOmuG+ww=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(14060799003)(35042699022)(1800799024)(376014)(11063799006)(6133799003)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	E1swzivbOUXyiV3E+6Fo3DDDuRlw8trMJ51aU+dLQLyoPMjBYuqzScYS8r8bAUkjuHqwluLhw1Y2vHL4pRiB+QGNCaDqCtVnPI3EzLP3ofRk8T2FBjdYGlwyRyXXGjiTu8XJCU2LZmDLYualtatm1CJ1DI1/+Zf4FHVOf9Nq2Hj+kqgTvHgoDLAYR8UjqwxOXGvK80GGxs6DinKY1DyeVAW0fi9kVjc/ctTG3Qcncvje70eH7REw8Janp/e3ls6upWVugenUQi0eH6+gVODInT/B1QAQUXWBNkmQGj3O4vpS2NDjY8hACwQdWId+1ozI9sFuDPeuimv6kuUwLA4R/AufFTBuAXP+88p1hjnzdV0pNzgB8CSHj940/xycADMCfyrWCUTHybhMaLvT7uAva5XwqajcmEfwLGlMdTnsLbMs5uK0i96eBFl0moDPh7VV
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2026 14:52:14.2438
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dfcbfef2-4c2c-48b4-b5c0-08deb7488bbf
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF00000197.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR08MB5870

These fields have been added to the architecture since this register
was added to the generator, and were hence missing.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/tools/sysreg | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 6c3ff14e561e6..57ab09404267c 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -3736,7 +3736,9 @@ Sysreg	ICC_CR0_EL1	3	1	12	0	1
 Res0	63:39
 Field	38	PID
 Field	37:32	IPPT
-Res0	31:1
+Res0	31:3
+Field	2	LINK_IDLE
+Field	1	LINK
 Field	0	EN
 EndSysreg
=20
--=20
2.34.1
