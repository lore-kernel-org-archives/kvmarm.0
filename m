Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013014.outbound.protection.outlook.com [52.101.72.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8A1134B669
	for <kvmarm@lists.linux.dev>; Fri,  7 Aug 2026 11:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.72.14
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786101353; cv=fail; b=N8t0OC9LLDZ6vV/xZyAXc+YhRz258Z3lpUPtaa/Nqx9w8ciyO6Bf0/77f24A/5+v6c2tQqMDp3lf3bfJJfWi632zCDv6v22N6NLIkrq3pFpZtk6x7RuwTN99OS13I5aFpZIKWJ/VHnkTvgFTI6N4LcWvpFQovg6C4Y2vFkEu4uk=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786101353; c=relaxed/simple;
	bh=/HgK0MUKOsuwapKxhhqaeOlLsVmWogbowN6BCq4mGUw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=tKJ6iLf/1DlxdzkpZNZzUcH4sIugmoVS/wdPJwhK1F7YgqBtY2+5v3gSndIyRyWiH4izQpcrR5GpC6/8hOvqQEzcR8uE7FVpHFMa2VKBJcrWZ5Fo+zXhTM+8iF1sFCQr8eTwFR8EmaDqlo+V0Z+WF93XRUuhG904astoxsA+SzM=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=pgQXGLX/; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=pgQXGLX/; arc=fail smtp.client-ip=52.101.72.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="pgQXGLX/";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="pgQXGLX/"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=dczKWnIR1+OjWti98GzfAzlM27NfTZNqdmj30t4YNjwTx22kRzbWEBdMnXUPDx5nvliyQzN1BhU+HhULu5Yp85jx9ST4Q5g9uo8XkJxDB4AmhGARugbLQ/Ys2dCmhNhRYNi4q1YVmS00UHpE0fNmV/VarezPEDqxZJK1Kss9fIKipm3gWfYj4IC9X3cShxzJOTL2jFb3I8nRFqah9Z3fM2hfydh7RtuI35W3zxLPaWI8OExyIZN2GXOjzZfJoSDINz2WOPQW1Z897pnDWQ9nQSjVAh+356JnnVQRuPpJSCtEn0Kcbfo4a1qbt5BW7YE4Kk/VawDhQX5O5SFu3qHfCQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zCalhb05CxZ1gDL/cWbJWSU2QHc55x+70R2AKTjCVfA=;
 b=dfV24s+3L0TxpokuPzeW/Ry4MW7H9+TyCmwfS3hy9kzQrhVTmugP22Ot4ESZlrmxKXOOprJUY8qu9SXqPpR5TXP/3aRukKD78jJXs/ec2ELmrDiceuJxmW1d1aoBu/7cg86td5DjF9YEiRiTR+54HuZ35MlyXjjSQ/UxkEby/qMsrRC+L/Lzm9IrUwRS9oZ9+M6TGGRVC6+LS8vn2gYZJ+Yfw6f60zQBEJbpvIKfgEfQ30iy0tYavkxO7jU+SOfQUyqxsAEv5w4g9AbjVO/Y3hQv+T6IKjj0TdeDCKc4PYW5fBvHlzIziocz2sxGVxZkf/7cpY1p7Y3HSjpS08tNpg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zCalhb05CxZ1gDL/cWbJWSU2QHc55x+70R2AKTjCVfA=;
 b=pgQXGLX/Fl5nfrxtUutTCYOOHbs6P9N4QSsNX4uXhOU7c/4iV64zUuGposcQylY+2CZn20SS5A5j1R+Fe51ZSd8flAmufktZDNFtZsKRo3DNYpTbPtSsjrX7b1SYZZ+qOH0wrnxsDP3VXPbRMBBFZCdkR4m0nRgCZFb7fbSE07g=
Received: from AS9PR06CA0380.eurprd06.prod.outlook.com (2603:10a6:20b:460::34)
 by GV1PR08MB10478.eurprd08.prod.outlook.com (2603:10a6:150:16a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.23; Fri, 7 Aug
 2026 11:15:42 +0000
Received: from AMS0EPF000001A6.eurprd05.prod.outlook.com
 (2603:10a6:20b:460:cafe::54) by AS9PR06CA0380.outlook.office365.com
 (2603:10a6:20b:460::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.23 via Frontend Transport; Fri, 7
 Aug 2026 11:15:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF000001A6.mail.protection.outlook.com (10.167.16.233) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.315.6
 via Frontend Transport; Fri, 7 Aug 2026 11:15:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T4hG4sow7rhyyuZscyE64Ik0cIW1vTa12r5x8vGUkBADsxd3t7kkafttA5tCDwV8FpQpfMwXdgameiWrNap1P9RloViq32GOkqER31kbGMwI/siZI79d0h3KQmRcAfNgksMur8ltsWOpm/nBc14Nv4Fp1JBBHJkhLZUQr4hjT1bLFefUlji6inMUh53pLbG06LmccihgCPdFbWJFzTx3n49krAIBeOx4j657ov6UTkhXgSxft9lLMFqoi61qjfDE75bdgoGu++ny6AnkdjXGCXDodUfhqTWhYSBrYe5V6sy3ZEID8GfvRPKrfzcwIxGHONxrQFUI51ogvTJmPwT/1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zCalhb05CxZ1gDL/cWbJWSU2QHc55x+70R2AKTjCVfA=;
 b=oi2AVdD4KHxN5FUIgwfB+7F3psQC9tIsP0eOVHk+fiXr+GZihhC4jqf97CFcJ7LyPDNF3jUKjMo6MI9dYMtUqEg65RFT+LSuo1lKaurJaFsKubH6CiIP2I+mnVssEy4cbo6AjqfI/Jd3+VSQmaNwsFElRfhu4/OVIj0m9zYj6FPvTQfSo9NtuebJhsHct+gMWGjWnUoSeOCZg5cvgyrMkb47TTtlSsUlXp0ok+SDpV84mHkmq6vANm+MXFUZjnZ2OBf3HGC0RivqM2LDaxNxpcJ9l+xCis9lPREdJLl98N0f9py9bgdcwBmPYSZNEW0ZGGR9VYi2fw5q2NmN1TuvuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zCalhb05CxZ1gDL/cWbJWSU2QHc55x+70R2AKTjCVfA=;
 b=pgQXGLX/Fl5nfrxtUutTCYOOHbs6P9N4QSsNX4uXhOU7c/4iV64zUuGposcQylY+2CZn20SS5A5j1R+Fe51ZSd8flAmufktZDNFtZsKRo3DNYpTbPtSsjrX7b1SYZZ+qOH0wrnxsDP3VXPbRMBBFZCdkR4m0nRgCZFb7fbSE07g=
Received: from GV1PR08MB8428.eurprd08.prod.outlook.com (2603:10a6:150:81::5)
 by DB8PR08MB5356.eurprd08.prod.outlook.com (2603:10a6:10:f9::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.21; Fri, 7 Aug
 2026 11:15:09 +0000
Received: from GV1PR08MB8428.eurprd08.prod.outlook.com
 ([fe80::9b97:c973:3308:5ba7]) by GV1PR08MB8428.eurprd08.prod.outlook.com
 ([fe80::9b97:c973:3308:5ba7%5]) with mapi id 15.21.0292.018; Fri, 7 Aug 2026
 11:15:08 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, Joey Gouly
	<Joey.Gouly@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>, "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	Timothy Hayes <Timothy.Hayes@arm.com>, "fuad.tabba@linux.dev"
	<fuad.tabba@linux.dev>
Subject: [PATCH v5 05/49] arm64/sysreg: Add GICv5 GIC VDPEND encoding
Thread-Topic: [PATCH v5 05/49] arm64/sysreg: Add GICv5 GIC VDPEND encoding
Thread-Index: AQHdJl4Bhh5ZI+77R0adkg/h1VzBDQ==
Date: Fri, 7 Aug 2026 11:15:08 +0000
Message-ID: <20260807111159.429128-6-sascha.bischoff@arm.com>
References: <20260807111159.429128-1-sascha.bischoff@arm.com>
In-Reply-To: <20260807111159.429128-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	GV1PR08MB8428:EE_|DB8PR08MB5356:EE_|AMS0EPF000001A6:EE_|GV1PR08MB10478:EE_
X-MS-Office365-Filtering-Correlation-Id: 541bec2f-a02e-4b34-5818-08def4753838
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|366016|1800799024|23010399003|56012099006|11063799006|10067099003|6133799003|3023799007|22082099003|18002099003|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 5V/3euTJWQ7TXcke/hShwwLM1Ch7VSG/26tEImUPEuELSzR23sloCEzPUCGPo/0B6xg3n9uoFiejJqexkMlf79VIqxdUQGcvDP8FgED/j0BbvdW9qILYQWMBhX5RR7eF8Z8jPEviRVKgFsUT/zHHPZZUGcQy/+uN6OBVSFC4K6dBfy7tdpsUJMTWCzO/1MGUp30izmsy4aXV1Oroig4xnZI3E4juc0LRx7Ie+cottcPONzDZovQjbn63s/4Au95TOnGtBmUKZe7FzjMKcXMA1dQAeIZmXVLaS/awCrTktT361PXxftzbb13hZejSAJ3aeHkyNY3D2dI48zbX1FuE1IUXqdthlFoepzzinpRxz5KjuSHvaZqoR7VH3o0XPFQns+jYguAIt5wkpAG5EQVzc/H3g7PDitmiEeBKfyOjv4cBWKIVcT4IEsR/L5Kh6fe7npJwS4vwy4b8qejxoDcPOT6dgA88D9bTJqb75MkFGUQdCYIznnhoanQMQC7Ot+iC7ywP2JS8ee1oc3eQsGqM9M06EkOVF9aDJrsqyUzdlPlCY8vv0VpmAYaKm7j0b89qx0z2Ri6TIliuakAklejqK3e7TyfpHQqo2z3SlgOTgaI5BHXjWCWjt41JvrrJS/einc72mMmhE5XdV/QMLkVHvgg+K+YkKGtqtrka0RffhklFCnQuKHgEKBPb5/biODqDrigbMnOt75jNjdnRAig6LQhlccYLtPLk5l2UiA1W/g8=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB8428.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(23010399003)(56012099006)(11063799006)(10067099003)(6133799003)(3023799007)(22082099003)(18002099003)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 Z7zdDrc+luZBRPPLSoJlMTU3zQJrMSIUE6/PW6kEsz1nzVUTt0Y8kLB7QMPQwFaDGBbPiKwHMQo0H4iWoONuQj4e7WIVHbGlR28F1j0Rv5TnUPimgziGmJQedO4lsxFjj0eSBJvEbzzKFCvMqcF0mp5v9uqxDkuhsNN/5kT3Xu5YW0c8kGkpimWlQFx+UyRDkY5iEU5uq1tviUB7zAdsQTW/Pxx/HPEw8gDWZjUC+ATLMTw2aidlXdbPfPWvRGwAaKqNMLe9ymzmfA/EE9Pa+cSW4BdkPX0c+TAiC56QIPJjV/GMTzizKjLSfS1FKLzZomETOvZBTDJF2lwMbrozLw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR08MB5356
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF000001A6.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	54d4857d-0550-4315-b442-08def475241d
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|35042699022|14060799003|36860700016|1800799024|82310400026|6133799003|10067099003|11063799006|56012099006|18002099003|22082099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	RDFE7t17mewonxNqLX37J0eQgIAcFpvd66XP2Z/rPZcYnuinzXa9TZChWsGpffGeyZR6HGaL1My5NXRxIdVdgaLNQgYUcAGExzl0q+EH4E7PaixDXCKRaP/a9f3CxDdZm4bgE0iN9NLr1CJDU1N5AeiBuSdQl5Ld9ovMZwJTxcIjZRA56vBgjrlGK12fSaiCSmDbzOyehAeXKIh6ZVESoRPRTz3mylnZDlgyl5Hzw+3j0Nh7qJDnT9qgepvLlqZOjJo8zSCuh+S4Wy8DdL5dkKJAts9Z/ej2oiIqzwrNm2gj9Yn6fe/Tg8L2UNfZj6frdZGBCGRv3XReJIAQZ+Xi2362fH9YhTxY8JxlGeDk/wf9fGYom4Hk01bQ5r4vDhZC6uYsNqcaMR+GMBvaWCSSjwRbCLaUDlWQJWApryDa0UwCC/dKla8dbQjnbw4hlr8LJvewJCkDWbUAcD1KV/BqaFtR/3zxAJ4ncxs8OA0cKIoisaMRQ0ajopscYirXy/zsJmKmW34KdxK08P9GY+8WQrS1eUmi9Sciwylha0Lmr4aEfXPOrkFV1h73LFkQLXwNh25gsKeoxAHZj+1DLhfKRUlvUsvH8qMeDmT3O29xwcBumb13gcIgA3SdO02zNxlYEyEadWfcRWIMpHsMwcTb5AgOyCKRGh6w1fbdSGGFfKlpLigQhoxyunprjVWEygicoJ8YqKAjEjudOoxW6s9Puw==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(376014)(35042699022)(14060799003)(36860700016)(1800799024)(82310400026)(6133799003)(10067099003)(11063799006)(56012099006)(18002099003)(22082099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	m6fMi56YyRT/UEACFIMPT53b4S/Yp7CvUpmuxoRpdDbcZHyS+rC81HqZ69dAF5fA6GtU+vI3WXFs97Mtg5Smt+xr/M5UU97jEVm3X2xy+3E4b3TGRjxFyrxDfyOk3+Hciz8M1ee05AfGbWebed35rbERhsOaAB6mdstjty0ExnON3MoQ9TciOSTon5kpnUwSEyWhT+KjrKmzji4ZpM3OtdAahfaM3UYldNET6ZfRUDBXvxaRxWacRZnE9otsRlWPll+jXQBtAIXJUlyX6OC6DpR1ae71XX+/Lnz9O/7a48i8sBGx9v2Kxtuavy8k5QZEUekIer12LpvFdajXESV9icOfN1HSx51qsnNUxVij/AdBr7z6Yr1WrzxTrvpzdRlkge6Rs3XUgQYKTIqMSed5RSTsEV70JtS4jbxI8fHsDMNhqkxDn4jRsyi++m3dhHfq
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2026 11:15:42.3773
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 541bec2f-a02e-4b34-5818-08def4753838
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF000001A6.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR08MB10478

Add the encoding for the GIC VDPEND system instruction. This operates
on the virtual interrupt domain, and is used to make interrupts
pending for a VM.

This is part of enabling GICv5 KVM support, and is required for
injection of SPIs and LPIs.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/include/asm/sysreg.h | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysre=
g.h
index 7aa08d59d4944..c840b37adb2fb 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -1040,7 +1040,7 @@
 #define GCS_CAP(x)	((((unsigned long)x) & GCS_CAP_ADDR_MASK) | \
 					       GCS_CAP_VALID_TOKEN)
 /*
- * Definitions for GICv5 instructions
+ * Definitions for GICv5 instructions for the Current Domain
  */
 #define GICV5_OP_GIC_CDAFF		sys_insn(1, 0, 12, 1, 3)
 #define GICV5_OP_GIC_CDDI		sys_insn(1, 0, 12, 2, 0)
@@ -1105,6 +1105,17 @@
 #define GICV5_GICR_CDNMIA_TYPE_MASK	GENMASK_ULL(31, 29)
 #define GICV5_GICR_CDNMIA_ID_MASK	GENMASK_ULL(23, 0)
=20
+/*
+ * Definitions for GICv5 instructions for the Virtual Domain
+ */
+#define GICV5_OP_GIC_VDPEND		sys_insn(1, 4, 12, 1, 4)
+
+/* Shift and mask definitions for GIC VDPEND */
+#define GICV5_GIC_VDPEND_PENDING_MASK	BIT_ULL(63)
+#define GICV5_GIC_VDPEND_VM_MASK	GENMASK_ULL(47, 32)
+#define GICV5_GIC_VDPEND_TYPE_MASK	GENMASK_ULL(31, 29)
+#define GICV5_GIC_VDPEND_ID_MASK	GENMASK_ULL(23, 0)
+
 #define gicr_insn(insn)			read_sysreg_s(GICV5_OP_GICR_##insn)
 #define gic_insn(v, insn)		write_sysreg_s(v, GICV5_OP_GIC_##insn)
=20
--=20
2.34.1
