Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013049.outbound.protection.outlook.com [52.101.83.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01392265CD9
	for <kvmarm@lists.linux.dev>; Fri,  3 Jul 2026 16:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.83.49
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783094980; cv=fail; b=cXQd8cfVRPVwf1LBzfn9Gz83gYO4IOZ4RDBZ+wx1iJJZga1Ywh+h1ehqttsByWNG0yJHl2rtMmzSEB9mGtvEGMP8F5EVu49w67EB/d4OLaS2hkc5CbSr6KjJKQuWa6G8CvqztP4XTaQnotkBVSoH9mESj5zv6q/yCZk2ypbkJ8I=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783094980; c=relaxed/simple;
	bh=syPkVK84EetW3JEdcirrVZyFPOAHNNzq+Rcj45Ss7ZQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=eiX/r54h3h7G2BB8KYfoJ6Az4SBlar/hl+rHZAhJyzCuuSNFennq29XK1BecWvpNqRVW5zixg0PNA67jscP7slqoYymRA06RECgr6MbpSfXKV9RxT5r+jIRXPSpprMtTxBks62ZhMNsALeJJ6Zd3mqu6UWmV0+vOeRR7AbHtlRk=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=eiCOkALN; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=eiCOkALN; arc=fail smtp.client-ip=52.101.83.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="eiCOkALN";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="eiCOkALN"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=eVoNtsdmhPGTeFJEqwGiFqP1aRUCCSVqHHlTseSKuhSfO2r6pMxV7jiO6eDJJluwojLEoC4d9WHc3VoxOBumJYyOOJUY/IndWMqF5mYx+cFyi0wHofDHATFN19aDDg6UdSKhnc/2AtQR0M1CruHJnCP+yFVuDbXO5O3BxOOMe2iy1x2xme3ECRjXEz0SRU9AB+zU7kiHUo3zs1yZZ9plSxXk8NEIhcTDmQ/3MVrzoVgylYMxnJmX+pcpKyJ+GUdbuU2PmCOpJhX9UDuiSK31J1zRwcu1fPT+md9lX8nINwNkc2dZkdm9q6HYh06W4YgtHE4ILjAZK4tF0QCvlzwayw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=axXqXkI/YELoAWCdhjPvoNkshwFdF7fLJzzwnfcVfVc=;
 b=m06Gxp9O7qLsLrxkx4TNyRnt5fbxI8w60+Ht+6L3ylxZPQr5u+4LZDZw7AUTXl3gFrPEUysLokid2ArgPwn4/uE1IXnagAHeUq3mo1BFE3BgrPjUceALhBEBAXAWFRvOAIxkxA9UDL/1XPyMvT0vPJS1j77qUCb0lBopoIz4pk2WzG1TApAvIYL60CNjw2L2lynAt7OmY09pj9c1JBlCdn9m7hTTozEao3x0JX6xjp5nAm+7Qeh3tzz6vn6KqfwmMAXDidDrJ0WnllbaRUhu+oGz8bpS2/Qnj56MiIJ1+JWvtQ7xd5vv+73AyqZtvAmdx7NWinNSsY7If3zp2+NycQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=axXqXkI/YELoAWCdhjPvoNkshwFdF7fLJzzwnfcVfVc=;
 b=eiCOkALNDwS96/tlMbgodKz1SHebURR1/IDbo8uTmktyeoerNRIn21ypJZlUVpvyY5vXcyX3cmI+vSn21LDJqR7LVqP/QO+W2Q69SdAKCjDd37Cm199mV2kLOEDzyUKUiNuxcH7HaS6lbKLG2Mc0WfAjYuftT/QOuJ59++BZ0N0=
Received: from DB8P191CA0024.EURP191.PROD.OUTLOOK.COM (2603:10a6:10:130::34)
 by AS2PR08MB8382.eurprd08.prod.outlook.com (2603:10a6:20b:559::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.139.11; Fri, 3 Jul
 2026 16:09:30 +0000
Received: from DU2PEPF00028D07.eurprd03.prod.outlook.com
 (2603:10a6:10:130:cafe::a4) by DB8P191CA0024.outlook.office365.com
 (2603:10a6:10:130::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.11 via Frontend Transport; Fri, 3
 Jul 2026 16:09:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU2PEPF00028D07.mail.protection.outlook.com (10.167.242.167) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.6
 via Frontend Transport; Fri, 3 Jul 2026 16:09:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KTgrijZnO9xR3mjXYxpv0xbXKkDIuLLcmpECatlnQw2bI8MFroPKMlmieSaoqvfRYdIMzlmJ3PF4YlnLp/Dw7IRL9+TCYlngbs/dvR7iz1pJ4Tj8i6FwokEhfrTuJPeIoBA89VWHC9Wb03q7pn+Y54y86k1nnQo+HSCc6svyuC8uRF4DwXSQuYoXoOeB2b4+39JJjoNBGgSI7rbQtbwRoZQH9tSS4/R+i7DY0/SvcFqqxV1y4D2PKaSlW/xaTyWxzDJ9/xpLKzx/MpJU2gHw/pPOmKDRzqpOiBykLDMUn1p6Li20u9jn8ban4NmrIyMXYLGjTI6HciU+x0OG4brvlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=axXqXkI/YELoAWCdhjPvoNkshwFdF7fLJzzwnfcVfVc=;
 b=cjbCPh4ksD2CoRTW+ua6YVrSVDE7CHSisTaVUHiuQAHdxlpdZpEwR49sqyRacY2YvZme496eNoejc0OQLlNc4vORqgGOyuZBiqfYwnTqgREeqUFYNpwdnAZUNtjsqSv2E3S42UZvm4WQCc98dnTjbCSRwwPAwq7tppPwwKub6PUeNhcYDY53rpJ2BMoJ4NM8clUAweEr8ptvjTkbd8Fsc/A0gP4ugvIjiRF+BPi7S8fwLN+lVifNoBao5THJxKz1DcTcvlEzAbe3KyUS7fMPtLFmc72FN6vn93WsumgAQmYqRvuc/nlQU+U6J+KYyh83FGKTRVB8mj/2YxMGqz4b4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=axXqXkI/YELoAWCdhjPvoNkshwFdF7fLJzzwnfcVfVc=;
 b=eiCOkALNDwS96/tlMbgodKz1SHebURR1/IDbo8uTmktyeoerNRIn21ypJZlUVpvyY5vXcyX3cmI+vSn21LDJqR7LVqP/QO+W2Q69SdAKCjDd37Cm199mV2kLOEDzyUKUiNuxcH7HaS6lbKLG2Mc0WfAjYuftT/QOuJ59++BZ0N0=
Received: from DU2PR08MB7310.eurprd08.prod.outlook.com (2603:10a6:10:2e5::5)
 by AM0PR08MB5459.eurprd08.prod.outlook.com (2603:10a6:208:186::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.11; Fri, 3 Jul
 2026 16:08:28 +0000
Received: from DU2PR08MB7310.eurprd08.prod.outlook.com
 ([fe80::e007:b494:8a24:1fc0]) by DU2PR08MB7310.eurprd08.prod.outlook.com
 ([fe80::e007:b494:8a24:1fc0%4]) with mapi id 15.21.0181.009; Fri, 3 Jul 2026
 16:08:21 +0000
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
Subject: [PATCH v3 35/40] KVM: arm64: gic-v5: Add CoreSight MMIO regs to IRS
Thread-Topic: [PATCH v3 35/40] KVM: arm64: gic-v5: Add CoreSight MMIO regs to
 IRS
Thread-Index: AQHdCwYrVcyZMgeIn0GYMvKA+miVSQ==
Date: Fri, 3 Jul 2026 16:08:21 +0000
Message-ID: <20260703154811.3355680-36-sascha.bischoff@arm.com>
References: <20260703154811.3355680-1-sascha.bischoff@arm.com>
In-Reply-To: <20260703154811.3355680-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU2PR08MB7310:EE_|AM0PR08MB5459:EE_|DU2PEPF00028D07:EE_|AS2PR08MB8382:EE_
X-MS-Office365-Filtering-Correlation-Id: 82bac9fb-dbc4-4145-a2a4-08ded91d76b6
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|18002099003|22082099003|6133799003|56012099006|11063799006|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 nO+NM9MGbqCgPgmGr/ckp5CQ4zzU7GB36uTjF7oVI6XAoraLccN4/9vXdyLaXGlPqbP8nzkKLkReTEVOv6o+S3sGYnu5ue6PzRYhi7Tu2ap/hjzAcx9wTgJrheI77VCxR7a+4R4ICTI2icfFJv2TKc3EQEh3E0yHMVl/HCTzeqEDPlWrxRw4Dr23bPNT+uGMoXaiCtLscJWVArvYEW6GwI2tS9H7QQaglIWHdpVqMgOQ04lkaqTYoY5vyscPLkp1A7Fpz1cFz4hWWxOddbuxkTmaJObDkH4rSiP+mOdrCddOpywWjhQnlE2Fmtutyiaozn/SZHhZOQ9k1F3BVhD0lkw9bKHBJkixk8U8gWJcoCxONeTjvqPEVxmk6hVa77ffcO316R1QAAXLVQeGxswUNWsZNsjlBjr3xNl+J7tvTbbtiUFXtsbzh21At0w0mr8bRDTl4km+AaK5XPGUwEltBF8JWTXyr0/nXnYX3HLdQGxZgZSwamiSFb+M3rZuy0Jtp5sxXf7gCkVl4Y2PpfDBHT7FA7Bs06JLMunMB6wb23Adh0JLd43373SewlGfs/CWDIriJuJfhbyBueY39RRVWM+x/afU91tHb01Ycb2UtaE1C9e82KAxTqknEjBBt0CjGSCmg9XUmTHhbDvev+FkY3YLajUx40vWxpS9rfj4133Ns2zfu7Sjy/BgNcQlbdw4FuvbkeBHD+c6DrDUVvGg5FqK8ja37Uz3V8WiCPZTFTE=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU2PR08MB7310.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(18002099003)(22082099003)(6133799003)(56012099006)(11063799006)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 hFaJSxXGKzx5b9tezLthBRg0SCnNDWRUzrzlZ49eSJEfLosONgp2GxSMs0apS0yV47bw4p8iruCyNaYCotrAG7C+fdu3RRWooQDFvds7QratX30irZ1j49dwIedeLzq4Th4Jlc1euzN4DKho4TPA3GN6HE8trvaStUfRDi02xIOFqKdiNsomP+nOenkWVClPpE2pamPVv5biZ3kwIjQBIgCuCjL8uJX+Kcpq9Kl603LLrebcITZOBvNO0rv66cipaE9WHpkC19kDlPZaBIuCQUKvuIr1x0ENf5de3+JZVaRD0L8DuCRZSq31t9IVjIv/9Es88YBFboe3oYl5EyWKCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR08MB5459
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU2PEPF00028D07.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	b9a056d7-5522-432f-eedb-08ded91d4e02
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|82310400026|376014|1800799024|14060799003|35042699022|36860700016|56012099006|6133799003|18002099003|11063799006|22082099003;
X-Microsoft-Antispam-Message-Info:
	XdWLJPn6UME+cWuS4ExnDA+Hce/+4iYbST1SmhUOsYiEPKCo/JCXzwyFpURe5od5ltod+Styg/P9MTjb9a3EyPZoHiqJr3UxCgu1yEGiuwh0A/Sgph4trIJ0wcuT4eE7cAqZKH8r2QKjPKbS1w3WKTA7IjdQpwyzawEIbB/2Wjrqajx8NMCGens9cYLMrhVQzQahjlJiUUAAxfNieJhPyzNmySrnjgZMgwL14bnIh461/PvM6Zh+RawY9JS49mkAP6DHx1R1hBewLoEc9AUO8FejjEG5ka7m7FEVoPW7ufFOxz2tJ2AwNK9IXq7P2XYuQJFHahhLJWZtctm2tJfusXKbTXnVy1QWOnvDnKbugmCfTbyCP4rZKLtS1nrUBpwq2KwyBG0yOi3l3Uy+2ZSq4zZhsGd93xnSNg4BP4SKJ2RrfeM6V31xjlhkZgSuNlA+UlvJ5VTVaLanYXya8H7Riky+m1MiZ953h0pUSnv7ACljNKrExvyHYu9t+TMP+NMB2SX2Gk12A7b9ZdrYC0E6GbFnPRFcxRz7VSWVUhpI0/3z4947TE+je5dKGYoP56ate4+SjvH6ZXf79saAW3YEEqafX8XrGo7x+ukfTBET/HoWacKJANVuflEj+dHHVah8Do7yywV42gtWEmLJymdq+qf5bCWW1EzhYtqSy4xXAYPhArCWkfOhPp9ZNti8NuFM72nFIOF7cjVrPYIRD0TMgQ==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(82310400026)(376014)(1800799024)(14060799003)(35042699022)(36860700016)(56012099006)(6133799003)(18002099003)(11063799006)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	xKGSfHW8ELKeDh0hXWDy1zV4UHFIQ0yVL4oKOUOsu/yNQqnOdeHo8/ZBWUDwiMEvqrFuuFkJ2JKxl6IELp7zB4gukmF/8Nm1TY9SVkZ4Jtjhhydt9NWvmP0G7fL4oqq7IluuOPv6rEJmABZkIjqZugFoyDPAVYVT1cv0FXJTv4PGQ3WmGmFMG0bmulYMJw5I1HojOXNXMXeqmM+iubpfGXYVNynqOTSd/HrYZz1EcHWPN2C4iWI1yme1fmiRZZj2vKeMMIHjsj5x8xQJn2bbcn5frqdirKj6aNN1FGAlVXESfIEC83vGcnpwj8XRsrM4zQmk//8H1LGjgaxWsqTr0KZe92HJjarohttc9Mnz+MWTcNHedg7uP43bdx6nOmP9+aGxJ1qiqrum2nKq9m3bakaHX8r5Z1+G3M7B+4IkWZTsbkzOOfgekVFDySVEOkPV
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2026 16:09:30.1168
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 82bac9fb-dbc4-4145-a2a4-08ded91d76b6
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF00028D07.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB8382

Expose the CoreSight identification registers in the emulated GICv5 IRS
MMIO region. These registers are read-only from the guest's point of
view, so return the architectural identification values and ignore
writes.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-irs-v5.c | 78 +++++++++++++++++++++++++++++++
 1 file changed, 78 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-irs-v5.c b/arch/arm64/kvm/vgic/vgic-i=
rs-v5.c
index 1d63cfe704fda..17be776b4a2b9 100644
--- a/arch/arm64/kvm/vgic/vgic-irs-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-irs-v5.c
@@ -465,6 +465,43 @@ static void vgic_v5_mmio_write_irs_ist(struct kvm_vcpu=
 *vcpu, gpa_t addr,
 	}
 }
=20
+static unsigned long vgic_v5_coresight_read(struct kvm_vcpu *vcpu,
+					    gpa_t addr, unsigned int len)
+{
+	const size_t offset =3D addr & (SZ_64K - 1);
+
+	switch (offset) {
+	case GICV5_CORESIGHT_DEVARCH:
+		return GICV5_CORESIGHT_DEVARCH_VAL;
+	case GICV5_CORESIGHT_PIDR4:
+		return GICV5_CORESIGHT_PIDR4_JEP106_CONT;
+	case GICV5_CORESIGHT_PIDR5:
+		return GICV5_CORESIGHT_PIDR5_RES0;
+	case GICV5_CORESIGHT_PIDR6:
+		return GICV5_CORESIGHT_PIDR6_RES0;
+	case GICV5_CORESIGHT_PIDR7:
+		return GICV5_CORESIGHT_PIDR7_RES0;
+	case GICV5_CORESIGHT_PIDR0:
+		return GICV5_CORESIGHT_PIDR0_PART_0;
+	case GICV5_CORESIGHT_PIDR1:
+		return GICV5_CORESIGHT_PIDR1_DES_0_PART_1;
+	case GICV5_CORESIGHT_PIDR2:
+		return GICV5_CORESIGHT_PIDR2_DES_1;
+	case GICV5_CORESIGHT_PIDR3:
+		return GICV5_CORESIGHT_PIDR3_REVAND_CMOD;
+	case GICV5_CORESIGHT_CIDR0:
+		return GICV5_CORESIGHT_CIDR0_VAL;
+	case GICV5_CORESIGHT_CIDR1:
+		return GICV5_CORESIGHT_CIDR1_VAL;
+	case GICV5_CORESIGHT_CIDR2:
+		return GICV5_CORESIGHT_CIDR2_VAL;
+	case GICV5_CORESIGHT_CIDR3:
+		return GICV5_CORESIGHT_CIDR3_VAL;
+	default:
+		return 0;
+	}
+}
+
 static unsigned long vgic_v5_mmio_uaccess_read_irs_status(struct kvm_vcpu =
*vcpu,
 							  gpa_t addr,
 							  unsigned int len)
@@ -776,6 +813,47 @@ static const struct vgic_register_region vgic_v5_irs_r=
egisters[] =3D {
 	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_SWERR_SYNDROMER1,
 				  vgic_mmio_read_raz, vgic_mmio_write_wi, 8,
 				  VGIC_ACCESS_64bit),
+
+	/* CoreSight identification registers */
+	REGISTER_DESC_WITH_LENGTH(GICV5_CORESIGHT_DEVARCH,
+				  vgic_v5_coresight_read, vgic_mmio_write_wi, 4,
+				  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_CORESIGHT_PIDR4,
+				  vgic_v5_coresight_read, vgic_mmio_write_wi, 4,
+				  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_CORESIGHT_PIDR5,
+				  vgic_v5_coresight_read, vgic_mmio_write_wi, 4,
+				  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_CORESIGHT_PIDR6,
+				  vgic_v5_coresight_read, vgic_mmio_write_wi, 4,
+				  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_CORESIGHT_PIDR7,
+				  vgic_v5_coresight_read, vgic_mmio_write_wi, 4,
+				  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_CORESIGHT_PIDR0,
+				  vgic_v5_coresight_read, vgic_mmio_write_wi, 4,
+				  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_CORESIGHT_PIDR1,
+				  vgic_v5_coresight_read, vgic_mmio_write_wi, 4,
+				  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_CORESIGHT_PIDR2,
+				  vgic_v5_coresight_read, vgic_mmio_write_wi, 4,
+				  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_CORESIGHT_PIDR3,
+				  vgic_v5_coresight_read, vgic_mmio_write_wi, 4,
+				  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_CORESIGHT_CIDR0,
+				  vgic_v5_coresight_read, vgic_mmio_write_wi, 4,
+				  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_CORESIGHT_CIDR1,
+				  vgic_v5_coresight_read, vgic_mmio_write_wi, 4,
+				  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_CORESIGHT_CIDR2,
+				  vgic_v5_coresight_read, vgic_mmio_write_wi, 4,
+				  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_CORESIGHT_CIDR3,
+				  vgic_v5_coresight_read, vgic_mmio_write_wi, 4,
+				  VGIC_ACCESS_32bit),
 };
=20
 unsigned int vgic_v5_init_irs_iodev(struct vgic_io_device *dev)
--=20
2.34.1
