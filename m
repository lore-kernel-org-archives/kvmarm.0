Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010039.outbound.protection.outlook.com [52.101.69.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A5D045FFB4
	for <kvmarm@lists.linux.dev>; Fri,  7 Aug 2026 11:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.39
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786102608; cv=fail; b=bY8WAv1mwUpY+1hHiNaURIL1cNFeflHVOhFQoaUXhZQcdydbLJhpULBJ7pajuYcA1tkur9lPXluwQYBp2ID6bhsgyjCFn4Mq1JiIyDG+CIf4FOfLqdVGqVIMp3qjGdRtFMij9K+ten/Jb9+jzK1Ag8ihCyboc736rJFFwdxxFzo=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786102608; c=relaxed/simple;
	bh=NaVnswrM6RsqQjk8XOajWoTlc5zl3npnQ/ew7jv5jmw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ONcpMA00v0oRVN1k8X91h87DuRWQk4+A/ewTWk4ky7iUQ2spFBd4Ts7vfsPHjLQQXzfq9g5SwZPBlGYLD+KAyNIo87zkejMnM/n1MrCmVfyuWrq5LC7wsdA200QO5QJ6JBSITLEppOxAqFw0zJxuzr4rXHjMcM3hBHV2WFTuiqs=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Bqhjtm18; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Bqhjtm18; arc=fail smtp.client-ip=52.101.69.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Bqhjtm18";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Bqhjtm18"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=OXKCPdMGTjxAAxU5kV7TqgWaeBxQgOnsfi0TE8g6AY496oLS28IWzlXVjL9a58xWJSPvS3Gt/dcIumyBI1Q9G3pGwnHLbZzc2loNAEaNDeJp3IzKZ5LcnEWUN3IWaFajZ8QDG5J/u2icZrIJi/EuljvNfOa+/y1q5Mm9UGeawtOsWRMcBACXgQvKSLUXu4TUG0MEJHeeWuL2Zx7xLxcA/XnkliErAWEkTuy6jbGn+Nc78l0E4k1s2Mglh2WdGnhPTvhtIZbRPC7vUz9q+v8AWp6bM743fPLUvq+6a03iqc39QXlTFnsz2zAJV7Mfbru7Fk0HQhglZs5HN18N90Ccow==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LbEZAOrq5Igqf5fye26JrDvG/xKbjA5Vgzi+GueXJOM=;
 b=TIxGpMD+GjaF6byhmRxvvXIE5iDtksdvUobOhEm2oy1fVxBbmLJYZQ8MUGnxH/vRuTPvQa0uEBsdyqXr5yteaL+sX+1GDXc0BVufeRwNKMtmvopaaOaRBIw82OKs8HbIDwr+N7u4qgtaomZRz9UCr9ZV3f/DJ0KxjsR3Y4GNB96UGCLmuxYNbPWmvqPJQcKY/X7wJs845gMnLqb+8pXyjZ8zvSw6LAS0Fpau9RDDX3UkD5lfLupD9IuD1qfmg/ZnwrRyGcSOhJKTUeacbH5TyOqF4kV09m2To/9GEhRCtGPRhjTZGuRIwbionh71dCvUcNELVqL//eJiujFkNGeVpw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LbEZAOrq5Igqf5fye26JrDvG/xKbjA5Vgzi+GueXJOM=;
 b=Bqhjtm18FHul8FdZ4NOBZBVkHRly7MTadrrmy+v1UGMPAZL5Z4m9xPNFHcrYjdnGpTpr2H1i52UTxONgtrxnwuk99YG0QN70/ByNCP5W6OqcJvJUUh8BlNAcWuom4z+dofsuoD3kWAMYKZ8Rmo5UccmOZlJltEl1tDsU+Jthg/0=
Received: from AS8P189CA0041.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:458::9)
 by DB9PR08MB7819.eurprd08.prod.outlook.com (2603:10a6:10:39b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.23; Fri, 7 Aug
 2026 11:36:35 +0000
Received: from AM4PEPF00027A62.eurprd04.prod.outlook.com
 (2603:10a6:20b:458:cafe::45) by AS8P189CA0041.outlook.office365.com
 (2603:10a6:20b:458::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.23 via Frontend Transport; Fri, 7
 Aug 2026 11:36:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM4PEPF00027A62.mail.protection.outlook.com (10.167.16.71) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.315.6
 via Frontend Transport; Fri, 7 Aug 2026 11:36:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WjqiMMloC1qXPUlnrpAcXO4YKtYNVPJUuWyIlC0exbl515p2RYoIGfhZIohrmnAtEuy7Pf00ZOdB/6vK83KmPq81+EsYyrrXEqdGfTEaJ48/N0t3Tu1rb0Ziyq8XhYKNCDRtgr/0uksgUCNVeZFUHdbUsQDG8SAgGTuwLV/lQN9x/WFjp9MQkNc++95zkfJhoYgAPbQO7NIB5HxQoxZfZk7HgTb0Qbih2uuPBDA0uJmq/cdDhWaAPN5ziUHv9bwgMkZIEQzrX4ulhufVZwZMSrLz581y2MPt3pgHBgST5HzOdGiGzTqMCXazWimfvlVrECKMjnf3VSjUZ48osboy1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LbEZAOrq5Igqf5fye26JrDvG/xKbjA5Vgzi+GueXJOM=;
 b=Uhf3nO2eJFnSMY9d2wI331iRnv79IghK5/zG8ekf3DZ9nC0DRYQdYfLwwKgfWoClGTonnrbiQHwfbaugBo01UYH7qBlvlNTiuaEbVdK5vK4UyIC+735iI5xHU0euTk8KKBkIWeEM7Qeb0VOR9okYtb+FOG1aGa8NBdDyyi4Q2jBIwVOpjQomVEJYjzqUg5fb1rDBmb9SxhiPevPUsmm+64XRI0OOMVjQYYgNhjFRNRCTW0eQy6VBDA7ttdtUsdQq/3w/lmCbmkhup3qqsSgfhEPpqhqHH4N1++MC64IUsZpQekiHxsVhfO/qxAC/kM62q9DpMF0MMwpUUjqrnCvGYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LbEZAOrq5Igqf5fye26JrDvG/xKbjA5Vgzi+GueXJOM=;
 b=Bqhjtm18FHul8FdZ4NOBZBVkHRly7MTadrrmy+v1UGMPAZL5Z4m9xPNFHcrYjdnGpTpr2H1i52UTxONgtrxnwuk99YG0QN70/ByNCP5W6OqcJvJUUh8BlNAcWuom4z+dofsuoD3kWAMYKZ8Rmo5UccmOZlJltEl1tDsU+Jthg/0=
Received: from GV1PR08MB8428.eurprd08.prod.outlook.com (2603:10a6:150:81::5)
 by DBBPR08MB10793.eurprd08.prod.outlook.com (2603:10a6:10:53d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.23; Fri, 7 Aug
 2026 11:36:02 +0000
Received: from GV1PR08MB8428.eurprd08.prod.outlook.com
 ([fe80::9b97:c973:3308:5ba7]) by GV1PR08MB8428.eurprd08.prod.outlook.com
 ([fe80::9b97:c973:3308:5ba7%5]) with mapi id 15.21.0292.018; Fri, 7 Aug 2026
 11:36:02 +0000
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
Subject: [PATCH v5 46/49] KVM: selftests: Add VGICv5 SPI injection tests
Thread-Topic: [PATCH v5 46/49] KVM: selftests: Add VGICv5 SPI injection tests
Thread-Index: AQHdJmDsEW/evhkxiEyxn8ww1ocZvg==
Date: Fri, 7 Aug 2026 11:36:02 +0000
Message-ID: <20260807111159.429128-47-sascha.bischoff@arm.com>
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
	GV1PR08MB8428:EE_|DBBPR08MB10793:EE_|AM4PEPF00027A62:EE_|DB9PR08MB7819:EE_
X-MS-Office365-Filtering-Correlation-Id: 141c15c2-416a-4457-52ff-08def47822a5
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|23010399003|22082099003|18002099003|38070700021|6133799003|11063799006|10067099003|56012099006;
X-Microsoft-Antispam-Message-Info-Original:
 WDC/9Tde84jU/zDEv+eDg0HaDemvLQzTS/MEizF+8ly6fZm5bkLZafBzT0cJH1cZREXFDyJ0uDbnirvxHOL9W9GJSzwWiPD6HqNNKjgbeun+cb1EpcXrTzu2KlkeE7sCqr0XlSZS0W7CBeZyS+jMhqrMaJDkxG7rAWWTRR/Cbkp4gfAPPc01NYZPyiEKyKmkFLReXRmum1GENrUz2HTizdVqyJPFl3o0I8AFzocf6Qg3do/eFx666TvSfgkui9CZd0I3vmaoJbRtYVpFqxOgI/bohKOzkeR4sy3D0c8JtOgy4u5y1zgN0vaq6J2dEnveeXZo/0yP7cftBgHdDr0j75yyAXor15+g7w1YzWmLKgS04toc8JjQ+5IkDyVGtRpgU75Z8we9ibiufs2jJxqnGCH84FLvGWvcsB+JC763xpFCHCDUMwmfh7x6i9jR4yQ5NymIr929PIOQ6nPiaVB0n49HYkOcW+BicvSwGozXBz8HxCTbgQIFX+IdkGyJD9BlhX1XO16A0z/8R5tzYWBELTl7/Rlt5Bn5iQRcbcxolgrGB9wAzFwR9AuuQXpMzdDxmTR/biD8AXgNXyNbo6LCnujkdEwPT/jA2hzpJlSQG2agxa7pmhuwra06SRxPa61XFZ8nt4LTS8jVv6a5ZciVX38w2xf68T3ZfkY/0ImudVHmB0mVMqa0chAkuNo1mD6kBwInAxWA1eiyjtXOIQZbjvLL166haV5awM/+UFpFj1U=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB8428.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(23010399003)(22082099003)(18002099003)(38070700021)(6133799003)(11063799006)(10067099003)(56012099006);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 NTv2IPhSWQNWxsNCt1JmSBESTvmXj9JHF/Hzq6gEGLsFptvjCxIZ4q4qpQPLpRWS7iKohSl09ADNgWCIhvKVTvS2yr3moT1ODo2qCRZ48l8V/Df4cLhbAMz3Y2XoIMq3pRyQePSaJME0RXoRXh7x48m6ce5ghUSj1ES2FDcns7x/k7WGt0eyJZXnqq7LHUKWP7Ji1yqPK29tBwnVcRzDi2+3Sna+pp5JBH80eAItrb1bP7oxl9VsIkhYrZZ4cpZhxzSPU9K9hm5ttLXgQ76BUsRrnfDbASwF+SzzHjV1O03Z2O3eBXG04kmB4mfcX53aZG+EnJtT3J/W2bNS9K3NCw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR08MB10793
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM4PEPF00027A62.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	f1ef01af-1dee-4411-fc07-08def4780f43
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|23010399003|82310400026|35042699022|1800799024|36860700016|376014|22082099003|18002099003|56012099006|11063799006|10067099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	9ln45m//HIIe4x3G8PP+v3FXpbd6sMeYrYd7jQuLai+Ae4Rq3TKn9myFFJ3c755RA6lihvapI3EK0+Vh7ZAMmyKkqGpd4lREzuwsiJ86M6a8wEvQFWyxpdnypqkwpGftFtiTHT+YG6KMBHe2fSRegK12cM4o+K6CNDjiuL1O+eCxNWihYS4LolXcpEcVJBAo426yQq3zV/E7fZ6CrylIV5dzLgbWYEx8ZxsNMVX6v1F8nirQX2EE7EYY79MskTl9G5KIoAra2osB9HN6MTBMPEHoCHZenVv2yFrI/msUgXPlZWuGsgsWlaODy3wqX2gMVCT6wijXaoerJ4MGOXnonp0eLLRFxJWTitYOo7DVkizIsYI+qaoON9RCP+36b9pYZU/X+DQL34e7dx5fDnE1AZNWkXtxzUiEHmPHsa+czZhs8cg3PGoGQC78Cqj1rg1FTGbMlC+9We6bui+lUKwzsBQJwL3QsSPQwY7ix3+sWEjUZLZQZeeSw+YS9F2VxIvnr0B3io4PtbRJlQH92lN0MPvJP1bUbvYjRHf631ohZGNSJwKixWZiWylalg81bxr6W1HMd33lDkEntcqaStVhErpdWnduRPiQEPw4RRR8Ats/oV5o/9IxSBYi1DAhJVN+H/lDSOp/SoaWP9xoBCx1/Eqcr8apBnT5wfXPa98QbscLL4lig5bpnTOARpwa9rHaKxnFY92og/lBv3+sLGKsbw==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(23010399003)(82310400026)(35042699022)(1800799024)(36860700016)(376014)(22082099003)(18002099003)(56012099006)(11063799006)(10067099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	RR7W7A9FdQXNRE2vqT0v1GJlcOKNRkZUWV7Djd+bzqiotQ+mfFGjZ81kQGlg3ATS+8FDUInj+aDJQAv4g42ogQ7Lp88y5OjF7loyE4ZoQW6QdgtFNcIeMr1aGfd6gWLvDZ60BItrZyVAn8CgYNQMHnv5JTlq1J93cLjZOPVrF2m3hdXFe7liWyrPZt+6UnczW/MP9Ilk0HG9LS+1iw5i+Nobep9N4y7s/3AKOAINRzC9oBLuMKfqoaVhyrqI0M7UAE15SfAsfL0zh2NjvF7EEg834gUbJ+Iz6fGk2MjmyMf8d/gBBJRjxOl5zc3mDpYK78x4QkMBmGOmLR0mairqpaTkjq1pTjtU5VLBhzlCyxafQM1iGD5sYBeWaJ5hrrSuJghDlfSA0cO4tZ97y2M+Y4xTyIkPN2+yMvIw8NWyMkU4viRKrXzfFwLO4bHjv4bQ
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2026 11:36:34.6626
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 141c15c2-416a-4457-52ff-08def47822a5
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM4PEPF00027A62.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB7819

Add VGICv5 SPI delivery coverage through KVM_IRQ_LINE. SPIs are
configured through the virtual IRS and delivered through the GICv5 CPU
interface, so the test needs to exercise both the userspace injection
path and the guest-side IRS programming path.

Map the virtual IRS into the guest, enable the IRS, configure SPI
trigger mode and target VPE from the guest, and check delivery of a
default SPI and SPI 1023, the last SPI in the maximum configured
range.  This also exercises VGIC initialization and the IRS selector
at KVM's upper bound. Verify that invalid SPI numbers are rejected,
that lowering an edge-triggered SPI after it is pending does not
recall it, and that level-sensitive SPIs are delivered.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 tools/testing/selftests/kvm/arm64/vgic_v5.c   | 267 +++++++++++++++++-
 .../selftests/kvm/include/arm64/gic_v5.h      |  11 +
 2 files changed, 268 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/kvm/arm64/vgic_v5.c b/tools/testing/se=
lftests/kvm/arm64/vgic_v5.c
index e99e24812052c..23fbd2db50c43 100644
--- a/tools/testing/selftests/kvm/arm64/vgic_v5.c
+++ b/tools/testing/selftests/kvm/arm64/vgic_v5.c
@@ -15,7 +15,9 @@
 #define NR_VCPUS		1
 #define VGIC_V5_NR_PRIVATE_IRQS	64
 #define VGIC_V5_DEFAULT_NR_SPIS	32
-#define VGIC_V5_MAX_NR_SPIS	BIT(16)
+#define VGIC_V5_MAX_NR_SPIS	BIT(10)
+#define VGIC_V5_IRS_SIZE		0x20000
+#define VGIC_V5_IRS_WAIT_RETRIES	1000000
=20
 static u64 max_phys_size;
=20
@@ -43,7 +45,71 @@ static struct kvm_vgic_v5_ist vgic_v5_ist_attr(void *spi=
_ist, size_t spi_size,
 	};
 }
=20
-static void guest_irq_handler(struct ex_regs *regs)
+static u32 spi_line_expected;
+static bool spi_line_level_sensitive;
+
+static u64 gicv5_spi_hwirq(u32 spi)
+{
+	return FIELD_PREP(GICV5_HWIRQ_TYPE, GICV5_HWIRQ_TYPE_SPI) |
+	       FIELD_PREP(GICV5_HWIRQ_ID, spi);
+}
+
+static void gicv5_setup_and_enable_hwirq(u64 hwirq, u32 target_vpe)
+{
+	u64 val;
+
+	val =3D hwirq | FIELD_PREP(GICV5_GIC_CDPRI_PRIORITY_MASK,
+				 GICV5_IRQ_DEFAULT_PRI);
+	gic_insn(val, CDPRI);
+
+	val =3D hwirq | FIELD_PREP(GICV5_GIC_CDAFF_IAFFID_MASK, target_vpe);
+	gic_insn(val, CDAFF);
+
+	gic_insn(hwirq, CDEN);
+}
+
+static void gicv5_enable_spi(u32 spi, u32 target_vpe)
+{
+	gicv5_setup_and_enable_hwirq(gicv5_spi_hwirq(spi), target_vpe);
+}
+
+static void gicv5_wait_for_irs_idle(u32 reg, u32 idle)
+{
+	int i;
+
+	for (i =3D 0; i < VGIC_V5_IRS_WAIT_RETRIES; i++) {
+		if (readl(GICV5_IRS_CONFIG_BASE_GVA + reg) & idle)
+			return;
+
+		cpu_relax();
+	}
+
+	GUEST_FAIL("IRS operation did not become idle");
+}
+
+static void gicv5_configure_spi(u32 spi, bool level)
+{
+	u32 val;
+
+	val =3D FIELD_PREP(GICV5_IRS_SPI_SELR_ID, spi);
+	writel(val, GICV5_IRS_CONFIG_BASE_GVA + GICV5_IRS_SPI_SELR);
+	gicv5_wait_for_irs_idle(GICV5_IRS_SPI_STATUSR,
+				GICV5_IRS_SPI_STATUSR_IDLE);
+
+	val =3D level ? GICV5_IRS_SPI_CFGR_TM : 0;
+	writel(val, GICV5_IRS_CONFIG_BASE_GVA + GICV5_IRS_SPI_CFGR);
+	gicv5_wait_for_irs_idle(GICV5_IRS_SPI_STATUSR,
+				GICV5_IRS_SPI_STATUSR_IDLE);
+}
+
+static void gicv5_enable_irs(void)
+{
+	writel(GICV5_IRS_CR0_IRSEN,
+	       GICV5_IRS_CONFIG_BASE_GVA + GICV5_IRS_CR0);
+	gicv5_wait_for_irs_idle(GICV5_IRS_CR0, GICV5_IRS_CR0_IDLE);
+}
+
+static void guest_ppi_irq_handler(struct ex_regs *regs)
 {
 	bool valid;
 	u32 hwirq;
@@ -100,6 +166,49 @@ static void guest_code(void)
 		cpu_relax();
 }
=20
+static void guest_spi_irq_handler(struct ex_regs *regs)
+{
+	bool valid;
+	u32 hwirq;
+	u64 ia;
+
+	ia =3D gicr_insn(CDIA);
+	valid =3D GICV5_GICR_CDIA_VALID(ia);
+
+	if (!valid)
+		return;
+
+	gsb_ack();
+	isb();
+
+	hwirq =3D FIELD_GET(GICV5_GICR_CDIA_INTID, ia);
+
+	GUEST_ASSERT_EQ(hwirq, gicv5_spi_hwirq(READ_ONCE(spi_line_expected)));
+
+	gic_insn(hwirq, CDDI);
+	gic_insn(0, CDEOI);
+
+	GUEST_DONE();
+}
+
+static void guest_spi_line_code(void)
+{
+	local_irq_disable();
+
+	gicv5_enable_irs();
+	gicv5_cpu_enable_interrupts();
+	gicv5_configure_spi(READ_ONCE(spi_line_expected),
+			    READ_ONCE(spi_line_level_sensitive));
+	gicv5_enable_spi(READ_ONCE(spi_line_expected), 0);
+
+	local_irq_enable();
+
+	GUEST_SYNC(GUEST_CMD_IS_READY);
+
+	while (1)
+		wfi();
+}
+
 /* we don't want to assert on run execution, hence that helper */
 static int run_vcpu(struct kvm_vcpu *vcpu)
 {
@@ -112,6 +221,17 @@ static void vm_gic_destroy(struct vm_gic *v)
 	kvm_vm_free(v->vm);
 }
=20
+static void vgic_v5_map_irs(struct kvm_vm *vm)
+{
+	unsigned int nr_irs_pages;
+
+	nr_irs_pages =3D vm_calc_num_guest_pages(vm->mode, VGIC_V5_IRS_SIZE);
+
+	/* Map the IRS at VA =3D=3D IPA so guest MMIO writes hit the IRS IODEV. *=
/
+	virt_map(vm, GICV5_IRS_CONFIG_BASE_GPA,
+		 GICV5_IRS_CONFIG_BASE_GPA, nr_irs_pages);
+}
+
 static u32 vgic_v5_irq_line_payload(u32 type, u32 num)
 {
 	return (type << KVM_ARM_IRQ_TYPE_SHIFT) |
@@ -123,6 +243,93 @@ static int __vgic_v5_irq_line(struct kvm_vm *vm, u32 t=
ype, u32 num, int level)
 	return _kvm_irq_line(vm, vgic_v5_irq_line_payload(type, num), level);
 }
=20
+static void vgic_v5_spi_line(struct kvm_vm *vm, u32 spi, int level)
+{
+	int ret =3D __vgic_v5_irq_line(vm, KVM_ARM_IRQ_TYPE_SPI, spi, level);
+
+	TEST_ASSERT(!ret, "KVM_IRQ_LINE failed for SPI %u level %d",
+		    spi, level);
+}
+
+static void vgic_v5_spi_line_vm_create(struct vm_gic *v,
+				       struct kvm_vcpu **vcpu,
+				       u32 nr_spis)
+{
+	u64 attr;
+
+	v->gic_dev_type =3D KVM_DEV_TYPE_ARM_VGIC_V5;
+	v->vm =3D __vm_create(VM_SHAPE_DEFAULT, NR_VCPUS, 0);
+	v->gic_fd =3D kvm_create_device(v->vm, v->gic_dev_type);
+	*vcpu =3D vm_vcpu_add(v->vm, 0, guest_spi_line_code);
+	TEST_ASSERT(*vcpu, "Failed to create vCPU");
+
+	vm_init_descriptor_tables(v->vm);
+	vm_install_exception_handler(v->vm, VECTOR_IRQ_CURRENT,
+				     guest_spi_irq_handler);
+	vcpu_init_descriptor_tables(*vcpu);
+
+	kvm_device_attr_set(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_NR_IRQS, 0,
+			    &nr_spis);
+
+	attr =3D GICV5_IRS_CONFIG_BASE_GPA;
+	kvm_device_attr_set(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+			    KVM_VGIC_V5_ADDR_TYPE_IRS, &attr);
+	vgic_v5_map_irs(v->vm);
+	kvm_device_attr_set(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
+			    KVM_DEV_ARM_VGIC_CTRL_INIT, NULL);
+}
+
+static void vgic_v5_run_spi_line_test(u32 nr_spis, u32 expected_spi,
+				      bool level_sensitive,
+				      bool lower_before_run)
+{
+	struct kvm_vcpu *vcpu;
+	struct vm_gic v;
+	struct ucall uc;
+	int ret;
+
+	spi_line_expected =3D expected_spi;
+	spi_line_level_sensitive =3D level_sensitive;
+
+	vgic_v5_spi_line_vm_create(&v, &vcpu, nr_spis);
+
+	sync_global_to_guest(v.vm, spi_line_expected);
+	sync_global_to_guest(v.vm, spi_line_level_sensitive);
+
+	ret =3D run_vcpu(vcpu);
+	TEST_ASSERT(!ret, "Failed to run GICv5 IRQ_LINE VM");
+	TEST_ASSERT(get_ucall(vcpu, &uc) =3D=3D UCALL_SYNC &&
+		    uc.args[1] =3D=3D GUEST_CMD_IS_READY,
+		    "GICv5 IRQ_LINE guest did not become ready");
+
+	vgic_v5_spi_line(v.vm, expected_spi, 1);
+	/*
+	 * For edge-triggered SPIs, a following low transition must be ignored:
+	 * once the edge has made the SPI pending, it cannot be recalled. This
+	 * allows us to test that.
+	 */
+	if (lower_before_run)
+		vgic_v5_spi_line(v.vm, expected_spi, 0);
+
+	while (1) {
+		ret =3D run_vcpu(vcpu);
+		TEST_ASSERT(!ret, "Failed to run GICv5 IRQ_LINE VM");
+
+		switch (get_ucall(vcpu, &uc)) {
+		case UCALL_ABORT:
+			REPORT_GUEST_ASSERT(uc);
+			break;
+		case UCALL_DONE:
+			goto done;
+		default:
+			TEST_FAIL("Unknown ucall %lu", uc.cmd);
+		}
+	}
+
+done:
+	vm_gic_destroy(&v);
+}
+
 struct vgic_region_attr {
 	u64 attr;
 	u64 size;
@@ -324,7 +531,6 @@ static void test_vgic_v5_addr_attrs(void)
=20
 static void test_vgic_v5_nr_irqs_attrs(void)
 {
-	const u32 max_nr_spis =3D BIT(10);
 	struct kvm_vcpu *vcpu;
 	struct vm_gic v;
 	u32 nr_irqs;
@@ -356,13 +562,13 @@ static void test_vgic_v5_nr_irqs_attrs(void)
 	TEST_ASSERT(ret && errno =3D=3D EINVAL, "GICv5 NR_IRQS not 32-aligned");
=20
 	/* Larger than KVM's supported VGICv5 SPI count */
-	nr_irqs =3D max_nr_spis + 32;
+	nr_irqs =3D VGIC_V5_MAX_NR_SPIS + 32;
 	ret =3D __kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_NR_IRQS,
 				    0, &nr_irqs);
 	TEST_ASSERT(ret && errno =3D=3D EINVAL, "GICv5 NR_IRQS above maximum");
=20
 	/* Valid custom SPI count */
-	nr_irqs =3D max_nr_spis;
+	nr_irqs =3D VGIC_V5_MAX_NR_SPIS;
 	ret =3D __kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_NR_IRQS,
 				    0, &nr_irqs);
 	TEST_ASSERT(!ret, "GICv5 NR_IRQS accepts valid custom SPI count");
@@ -370,7 +576,7 @@ static void test_vgic_v5_nr_irqs_attrs(void)
 	nr_irqs =3D 0xbad;
 	ret =3D __kvm_device_attr_get(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_NR_IRQS,
 				    0, &nr_irqs);
-	TEST_ASSERT(!ret && nr_irqs =3D=3D max_nr_spis,
+	TEST_ASSERT(!ret && nr_irqs =3D=3D VGIC_V5_MAX_NR_SPIS,
 		    "GICv5 NR_IRQS returns SPI count only");
=20
 	/* A second successful configuration attempt must be rejected. */
@@ -847,7 +1053,8 @@ static void test_vgic_v5_ppis(u32 gic_dev_type)
 		vcpus[i] =3D vm_vcpu_add(v.vm, i, guest_code);
=20
 	vm_init_descriptor_tables(v.vm);
-	vm_install_exception_handler(v.vm, VECTOR_IRQ_CURRENT, guest_irq_handler)=
;
+	vm_install_exception_handler(v.vm, VECTOR_IRQ_CURRENT,
+				     guest_ppi_irq_handler);
=20
 	for (i =3D 0; i < NR_VCPUS; i++)
 		vcpu_init_descriptor_tables(vcpus[i]);
@@ -903,9 +1110,9 @@ static void test_vgic_v5_ppis(u32 gic_dev_type)
=20
 				kvm_irq_line(v.vm, irq, level);
 			} else if (uc.args[1] =3D=3D GUEST_CMD_IS_AWAKE) {
-				pr_info("Guest skipping WFI due to pending IRQ\n");
+				pr_debug("Guest skipping WFI due to pending IRQ\n");
 			} else if (uc.args[1] =3D=3D GUEST_CMD_IRQ_CDIA) {
-				pr_info("Guest acknowledged IRQ\n");
+				pr_debug("Guest acknowledged IRQ\n");
 			}
=20
 			continue;
@@ -925,6 +1132,44 @@ static void test_vgic_v5_ppis(u32 gic_dev_type)
 	vm_gic_destroy(&v);
 }
=20
+static void test_vgic_v5_spis(void)
+{
+	struct kvm_vcpu *vcpu;
+	struct vm_gic v;
+	int ret;
+
+	/* Default NR_IRQS exposes 32 SPIs, numbered 0..31 in KVM_IRQ_LINE. */
+	vgic_v5_spi_line_vm_create(&v, &vcpu, VGIC_V5_DEFAULT_NR_SPIS);
+	ret =3D __vgic_v5_irq_line(v.vm, KVM_ARM_IRQ_TYPE_SPI,
+				 VGIC_V5_DEFAULT_NR_SPIS, 1);
+	TEST_ASSERT(ret && errno =3D=3D EINVAL, "GICv5 accepted first invalid SPI=
");
+
+	vm_gic_destroy(&v);
+
+	/* Basic SPI injection through KVM_IRQ_LINE. */
+	vgic_v5_run_spi_line_test(VGIC_V5_DEFAULT_NR_SPIS, 0, false, false);
+
+	/* The last valid SPI in the maximum configured range is injectable. */
+	vgic_v5_run_spi_line_test(VGIC_V5_MAX_NR_SPIS,
+				  VGIC_V5_MAX_NR_SPIS - 1, false, false);
+
+	vgic_v5_spi_line_vm_create(&v, &vcpu, VGIC_V5_MAX_NR_SPIS);
+	ret =3D __vgic_v5_irq_line(v.vm, KVM_ARM_IRQ_TYPE_SPI,
+				 VGIC_V5_MAX_NR_SPIS, 1);
+	TEST_ASSERT(ret && errno =3D=3D EINVAL, "GICv5 accepted configured invali=
d SPI");
+	vm_gic_destroy(&v);
+
+	/*
+	 * Edge SPIs remain pending after the line is lowered.  The low
+	 * transition is injected before the guest runs and must be ignored:
+	 * once an edge interrupt is pending, lowering the line cannot recall it.
+	 */
+	vgic_v5_run_spi_line_test(VGIC_V5_DEFAULT_NR_SPIS, 1, false, true);
+
+	/* Level SPIs can be raised and delivered through KVM_IRQ_LINE. */
+	vgic_v5_run_spi_line_test(VGIC_V5_DEFAULT_NR_SPIS, 2, true, false);
+}
+
 /*
  * Returns 0 if it's possible to create GIC device of a given type (V5).
  */
@@ -974,9 +1219,11 @@ void run_tests(u32 gic_dev_type)
 	pr_info("Test VGICv5 CPU sysreg attrs\n");
 	test_vgic_v5_cpu_sysreg_attrs();
=20
-
 	pr_info("Test VGICv5 PPIs\n");
 	test_vgic_v5_ppis(gic_dev_type);
+
+	pr_info("Test VGICv5 SPIs\n");
+	test_vgic_v5_spis();
 }
=20
 int main(int ac, char **av)
diff --git a/tools/testing/selftests/kvm/include/arm64/gic_v5.h b/tools/tes=
ting/selftests/kvm/include/arm64/gic_v5.h
index 0ad6dcc3d510b..091d9dbd3c01d 100644
--- a/tools/testing/selftests/kvm/include/arm64/gic_v5.h
+++ b/tools/testing/selftests/kvm/include/arm64/gic_v5.h
@@ -12,6 +12,7 @@
=20
 /* GIC component base address is guest PA space */
 #define GICV5_IRS_CONFIG_BASE_GPA	0x8000000ULL
+#define GICV5_IRS_CONFIG_BASE_GVA	((volatile void *)GICV5_IRS_CONFIG_BASE_=
GPA)
=20
 #define GICV5_IRS_SIZE			0x20000
 #define GICV5_IRS_ALIGN			0x10000
@@ -79,6 +80,12 @@
=20
 #define GICV5_IRS_IDR1_PRIORITY_BITS	GENMASK(22, 20)
=20
+#define GICV5_IRS_CR0_IDLE		BIT(1)
+#define GICV5_IRS_CR0_IRSEN		BIT(0)
+
+#define GICV5_IRS_SPI_SELR_ID		GENMASK(23, 0)
+#define GICV5_IRS_SPI_CFGR_TM		BIT(0)
+
 #define GICV5_IRS_SYNC_STATUSR_IDLE	BIT(0)
 #define GICV5_IRS_SPI_STATUSR_IDLE	BIT(0)
 #define GICV5_IRS_PE_STATUSR_IDLE	BIT(0)
@@ -155,6 +162,10 @@
 #define GICV5_GICR_CDNMIA_TYPE_MASK	GENMASK_ULL(31, 29)
 #define GICV5_GICR_CDNMIA_ID_MASK	GENMASK_ULL(23, 0)
=20
+#define GICV5_HWIRQ_TYPE		GENMASK_ULL(31, 29)
+#define GICV5_HWIRQ_ID			GENMASK_ULL(23, 0)
+#define GICV5_HWIRQ_TYPE_SPI		0x3
+
 #define gicr_insn(insn)			read_sysreg_s(GICV5_OP_GICR_##insn)
 #define gic_insn(v, insn)		write_sysreg_s(v, GICV5_OP_GIC_##insn)
=20
--=20
2.34.1
