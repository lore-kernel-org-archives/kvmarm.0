Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011003.outbound.protection.outlook.com [40.107.130.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7548642A7BC
	for <kvmarm@lists.linux.dev>; Fri, 24 Jul 2026 10:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.3
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784890641; cv=fail; b=udtd1C6byM9GJE2Hq1JEMA8DS/jIbmYi8vgin/w/bHeQduVmmbUJ3M35QDSZo3qQxDaUVDi4i/oDCO2HIHNmhZMSHGCpSTS4pyHuEkwEfbUwhNjJk9IjBcx0ONzZCue+IvHZ1b9i8NJHvBqaLvHzoZXdq/nZEnvT2LLuyvNW0oI=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784890641; c=relaxed/simple;
	bh=Rll1k4hw/gJgJlO3vCXdvsj3Y+Q6PUfNC5vymy/6LG4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=nrHvmrZ9WUhbW0YDGsa7Q3+bPBS6vvJZ4LA8Iic4NpnOvyW7PQvmt6F72pJmGbREdh2tpOAySgXpfHfBXlxAw++hNiLHLJkXaCEkd0bvd10oKNu8EACb803gRIISt8lrwTz4DCmx6tfmeYe1OtT3HHWL6XDs+ZG2YqsueEP0A6o=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=fc/s7DRh; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=fc/s7DRh; arc=fail smtp.client-ip=40.107.130.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="fc/s7DRh";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="fc/s7DRh"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=Rbre6miCOgjXIzYuuj9ttQxxCFC7Bs9U1wLlZZ7GQxJnBtb0/5KSGzMBuW+N7MR1Z3dknXBCJpGVPJ1HtLfOfT5/lORl5X7m1OdD5I/FctbLt/FAhM/3VTxNSYWv1TXm5rbsI5XgquJtAG5eqE9aD7KxpC9fj4FQqI14ALB2Iskm3toe7FzrVSyfR/whwQtEJ1h7zyKb3BzSpmxysmCshjC5sR4OnaOoY+LPl53+clI4IZ0x+m037RM9Jo+2wckZ7VjBlbfTGCSbjxoQuUQhHNI6dg7gvl0F9M/HUBqJXrNq0Q+qziHKaylsl7DFBYVm8W9jJ4c/+84ZjJ5o/xhZAg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rrBdCRL+m5Y2XGaou8ATSM1vf37XTI14SNVQEP5oTHk=;
 b=kQdu9qBtlTxlfVQKKIKzjtgkv+FvleUjHPWg7yGXegclYXCf8ZNJZBS1R8wSK1kIGd3R1oSQFN6T3jj9IkMF6/y0sg02DjnG6XsX5iVZ/4LhMZTXD5nXJlPI58E9EKMAmzbQYj5LM6IuXVQ52ojlaXn4HJ2/YFfhFfD7q283CKWtrArQVlbvRbFroJvOIvgaKzBir4lAba+oqFlK0E69YArWkHmoX4EqlkZ6FdrkFH0clk3SVA/cGefbKj/KMyJRy6WtZAYvyWpVviWjSQVRCs1NkA803vPLjobyd8dV3n+H0A9qrt5l3m+Fd4at7aIE5qnReeQds2UXunDe5U+kLA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rrBdCRL+m5Y2XGaou8ATSM1vf37XTI14SNVQEP5oTHk=;
 b=fc/s7DRhJ6+ycdobfw+0l9Q6SRCLc4bPxJs49hMbCk6Qe8zCM93R/ERUsSBZaYfHGdMLy33kzPiSFEHcNzMMlxrzt65+wL9YrANuryEzHErApBSP0DNXSvi3INmBhQkKIx1V1CGrzi9XgIXRCnvf744OAH9TImDoBLbEks3AM5w=
Received: from AS4P192CA0026.EURP192.PROD.OUTLOOK.COM (2603:10a6:20b:5e1::10)
 by FRWPR08MB11614.eurprd08.prod.outlook.com (2603:10a6:d10:1b0::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.10; Fri, 24 Jul
 2026 10:57:11 +0000
Received: from AMS1EPF0000003F.eurprd04.prod.outlook.com
 (2603:10a6:20b:5e1:cafe::53) by AS4P192CA0026.outlook.office365.com
 (2603:10a6:20b:5e1::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.11 via Frontend Transport; Fri,
 24 Jul 2026 10:57:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS1EPF0000003F.mail.protection.outlook.com (10.167.16.36) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.5
 via Frontend Transport; Fri, 24 Jul 2026 10:57:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Mmp3LUSRPjaSyWU/wS+ZOSum5Qf/053Ce2JM3RYZFsjkUWhMucWT3tJ6y+aayJqSixJDISJgzGBNyXbzoyJeWkuJSfI8r0Q3ak+IlCvnFqbn/xKXRGQYTr0Dymo3r4g6nSvryBZJhcz2zvZD3PEDT0YQ1Gem8gG6Kgz39ugWMCOBPKbOXToaneXQuBqzXoFLBSDnvtvRFSW7ngCUtjYp/324rprEj+zCMeSpJM1ZtoNR8ah5QnBrfJx/OVVdIsbb7TZXZaIQD82JOCyUe07gA+RT/1EjZ+Ez6erNXwaFL1lpBk86EKgKP38qPnOQgOT6BVoaDs+2dCRqKKK4UsRUEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rrBdCRL+m5Y2XGaou8ATSM1vf37XTI14SNVQEP5oTHk=;
 b=LZ/X+9MRaPCIvKlihfiJyL6Cfw5UvRjkl/NpsQ10MqiE0ts2Ie5i+he6sF97i3njfZrNgeso/WxrJTcu6JfbieUi88mYDyiDdIdlcy/vmnwFsGGBQaaNWuVDz5epYM6eh06EytwWCZ5ZVCG0hXTvsAYXtBXUsFDXrXKKSECnCqWBd8X4XISuJOttfLh4xPigL/GkyinbB0R2a0DZbGj7Lgn18iA6IHivPujw6oj2kPKP0r13+evuqs5lDQl1Axg6RKptJRSwP1kPu5tV3A5E3rf3MYdKdaKPYgpLKMS3lMqYldD7FrDXzpMGCY24SEAaThIWN51LzcLwTWW5WPSIcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rrBdCRL+m5Y2XGaou8ATSM1vf37XTI14SNVQEP5oTHk=;
 b=fc/s7DRhJ6+ycdobfw+0l9Q6SRCLc4bPxJs49hMbCk6Qe8zCM93R/ERUsSBZaYfHGdMLy33kzPiSFEHcNzMMlxrzt65+wL9YrANuryEzHErApBSP0DNXSvi3INmBhQkKIx1V1CGrzi9XgIXRCnvf744OAH9TImDoBLbEks3AM5w=
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com (2603:10a6:10:407::19)
 by DB9PR08MB7769.eurprd08.prod.outlook.com (2603:10a6:10:395::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Fri, 24 Jul
 2026 10:56:08 +0000
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e]) by DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e%5]) with mapi id 15.21.0245.009; Fri, 24 Jul 2026
 10:56:08 +0000
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
Subject: [PATCH v4 30/48] KVM: arm64: gic-v5: Mask per-vcpu PPI state in
 vgic_v5_finalize_ppi_state()
Thread-Topic: [PATCH v4 30/48] KVM: arm64: gic-v5: Mask per-vcpu PPI state in
 vgic_v5_finalize_ppi_state()
Thread-Index: AQHdG1sINndSYDiiUkegoFapvxqoag==
Date: Fri, 24 Jul 2026 10:56:08 +0000
Message-ID: <20260724104819.1296803-31-sascha.bischoff@arm.com>
References: <20260724104819.1296803-1-sascha.bischoff@arm.com>
In-Reply-To: <20260724104819.1296803-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU0PR08MB8421:EE_|DB9PR08MB7769:EE_|AMS1EPF0000003F:EE_|FRWPR08MB11614:EE_
X-MS-Office365-Filtering-Correlation-Id: 4d019675-4953-4213-45b9-08dee9724feb
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|23010399003|366016|1800799024|38070700021|6133799003|10067099003|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 W5AetIsLDC2S1zyMs15AGORZx7ttpHgGF1YOCxWfXjnVg4vhXXGzA6Li7uAa+Ky2BNGNhqT57gL2v4Ehxa8gVEv3DhhVQRot8JNtoPtdoXjmoWLLocllF1exnw2B3O0ainh423iS3LF31PBFDf19B4Zkts5w/spNBzX13dsj1ahyf72ZFj0B7DR0ut/9HzXw7zCziOW7ssVGATMDTNBW2hGz1k221tzEkOx8n9o4UdPifSKVYYQonVvOlRSUVb2n5KMCKISKjrGkLfaMTPmPWUZ5R3u8iw5QejoR68zV+bz6+KnhnveGwRst0glOHao7JFrb+PMj1ViQ8qoPeMhqLkeM6Xly7xnztDDGMQ+fW/rb5XUr/L7vZxd1oI6Vh63CsSS+Mu4RZPjV/MwY66Nf2RQGGUoPIdQbHp72DC+rFNZWfHYPfHso3ThMJRxkcPbF65uGqhhb2gx+qBK3fSDNQKq7HGfAWnU5JIedOIxX6F971vdRtU7tZTBdkZtJvRSitHMGuB28gouAy/WJp0Zdr6KCC8xuWSEV3lK1QXfDPrP/QDZ2UAcy0eGm/DvY/AX+0OlVS39UCTU785z6ixhW4bTtlLrnafV6Yg48+Hx4l8pt5TDHMA8zmmyQdC80PbPJLqZzRIrEs7wUX12sSnQWuHbG9ezjBCgCQ7yS/9NLPjFTk1xnFOz7Mb33hMVk22aEzRyoC+dF9umTlJFoxVPyhJ/q2EmaB5OlkLj22VYgZj8=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB8421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(366016)(1800799024)(38070700021)(6133799003)(10067099003)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 RhNKSTaNE4BXkqzbtiCFBGG2ClTBMACKEmOrw7gln0wCs3S3Epicl7Nt1pEmuH9cLMF50LrYESeK1eQjGPVbnNZU5RdFLbJ7dyP+fFV99hRHap3wGqjRw4iVddPGIXj4xAthUiTwfY1jKpz6rTi1cHqgwLI+57AOeZYuO9mQ/E2OGB2kAebshesbvX63CX8OLvHaPNNCB/4r4Hz7wAw7grwnN2vTdaYdaQ+xoLCpdHJ4Etf7BL9ESD6kMHBwACssgUsjXgHWN2LzuqsgNzVofVWSz60rF7CnQK1KaH7NV8e0Yod0xEhxKCFT3rHWYS5PnfjhzLHkBONDP0UPtZm1iQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB7769
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS1EPF0000003F.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	3a7f08eb-6b9e-4f09-c9d8-08dee9722aa2
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|1800799024|14060799003|23010399003|376014|35042699022|82310400026|6133799003|10067099003|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	c2fZzK7cdC0j/+EYJ+O3uTrMNxnZhZutbCARGfWds1n8fKpEFlB3CApvLzOBmzNDTSaGvj2uD0hBa4bY1NH1JeUW3lMg32E4THKsEe21khaMuh2YsQFtJsFSWhsVayKA3OiWi8o3DyK5wHe/rNfm4FZ8zLIKWuyRZdGauL7goEOfmyqjXprBbu/Re9O4qKoXhseZEXhp/VyZsvD5j4jX1ImThJlVVw/CuSOoIPKPw90cymmX1LN7kCU7mSjxenz8AWC3rLbrbwEnnmalAaDshZzt4JqxysJjEbJBr5BUwvA0KgaEsm79kLZb4uyktqN7QO6aekr1hQVVcAGrhzD9xbJXi9nKzOnxxV7fshPB6nzaALJpenI60FdkVEimyP4uJajFtiJ9pr8UabXirKxVv8uYaJn75+Lrr7IkSFdOJSwztSqZ9YsQYFbO4DeLx4WUQBR3iYN22n332Jv65wv6VydTIFReMMt6Ah85yRkFh5HsgqT4t747rrU2DTtyE2MHFwfnN+EFgUVapsItjpn/JWh3xon7aU7jeuiPZxLB+GtowWOQ/iW5I1HJr14I4iwfCTfrg9KrsBkZopGPYC9qoPYasuzNfYksUqY3spAsrPXZkkhqOSGVIwJ4GsT06kgc3DFPiITNXCvQRMYuvasvFn5Sn4kN/NQhgVm2XUVKaWoPkDATgVoYvA6PnemDz551Yh7h/tIsFJJd5rTwTVpZYQ==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(1800799024)(14060799003)(23010399003)(376014)(35042699022)(82310400026)(6133799003)(10067099003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	8z+XppkQcvNf7d0rw7vdrlfC+EeEBboAnsKLsjQ4OWJX25ixob1jnwbiSWKt2UcpYElbc39ReFxtomJd9iX4Xy73fvziaUSELrgKL9Fav1B0ZekIH6My/e142At2EgWKhUDIgP0L+tcLOoadjIGHqfEP+PUfa7Hh2r8xZeOrte8deCS2g8Hsiqn9eJxiXVOyZXx4AE2zLx0fcF5G2wS00f5ZfwEdbZqVfNX9rBxhyMWaMBMpCgHDC3xqR13apJ+f9IZhy8kkyaX+cLI+0vBP41DcyVLhMWckCatyse97BVaPDg068MRbwtRZGXtC9q6lfmVHSDKVDYaU0q4rrWI1Gfxa9chlmqtl+B5zlcjL3HMxNKDX9CM1F2yKi71veQenzoPl/2b9XI/oIZIA8KaSk/uizMp+zTbgjiEJ0QVIotX0NdlHfjdj3TwlABKgioiE
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2026 10:57:10.8532
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d019675-4953-4213-45b9-08dee9724feb
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS1EPF0000003F.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: FRWPR08MB11614

Only a subset of the possible PPIs are exposed to a guest when running
with a vGICv5. First of all, only the architected PPIs are considered
by KVM. Secondly, only a set of those is exposed to a guest - those
corresponding to devices that KVM emulates (timers, PMU) and the GICv5
SW_PPI.

The finalisation of exposed PPIs happens on first vCPU run as this is
the first time when the full set of exposed devices is known. At this
stage a mask is calculated, and this mask is applied to both hide
non-exposed PPI state from the guest and to reduce overhead when
iterating over the PPIs.

As part of introducing support for userspace accesses to the GICv5
system registers it has become apparent that userspace sets of the
GICv5 PPI registers can result in a mismatch between the state exposed
to the guest and what KVM expects to be exposed. Effectively,
userspace can set the Enable, Active, Pending state of PPIs that KVM
has chosen to hide from a guest.

Under the assumption that on a VM restore userspace will set the PPI
state prior to running the vCPU(s) for the first time, rework
vgic_v5_finalize_ppi_state() to not only calculate the mask of exposed
PPIs, but also to clear any state for the non-exposed PPIs. This
ensures that only the state that KVM intends to expose to the guest is
exposed.

Note: If userspace chooses to set the state of PPI registers after
running a vCPU for the first time, then no masking takes place and
that state is directly exposed to a guest.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/arm.c          |  2 +-
 arch/arm64/kvm/vgic/vgic-v5.c | 71 +++++++++++++++++++++++++----------
 include/kvm/arm_vgic.h        |  2 +-
 3 files changed, 53 insertions(+), 22 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index e1b5cc1e01a6e..7c59f9b451049 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -961,7 +961,7 @@ int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
 			return ret;
 	}
=20
-	ret =3D vgic_v5_finalize_ppi_state(kvm);
+	ret =3D vgic_v5_finalize_ppi_state(vcpu);
 	if (ret)
 		return ret;
=20
diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index 04392b686c2e2..6af1264ed2371 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -784,9 +784,10 @@ int vgic_v5_map_resources(struct kvm *kvm)
 	return 0;
 }
=20
-int vgic_v5_finalize_ppi_state(struct kvm *kvm)
+int vgic_v5_finalize_ppi_state(struct kvm_vcpu *vcpu)
 {
-	struct kvm_vcpu *vcpu0;
+	struct kvm *kvm	=3D vcpu->kvm;
+	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
 	int i;
=20
 	if (!vgic_is_v5(kvm))
@@ -795,35 +796,65 @@ int vgic_v5_finalize_ppi_state(struct kvm *kvm)
 	guard(mutex)(&kvm->arch.config_lock);
=20
 	/*
-	 * If SW_PPI has been advertised, then we know we already
-	 * initialised the whole thing, and we can return early. Yes,
-	 * this is pretty hackish as far as state tracking goes...
+	 * Discover the set of PPIs that are exposed to the guest once per VM.
+	 * Once known, apply that mask to each VCPU's restored PPI state as the
+	 * VCPUs are first run.
 	 */
-	if (test_bit(GICV5_ARCH_PPI_SW_PPI, kvm->arch.vgic.gicv5_vm.vgic_ppi_mask=
))
-		return 0;
-
-	/* The PPI state for all VCPUs should be the same. Pick the first. */
-	vcpu0 =3D kvm_get_vcpu(kvm, 0);
+	if (!test_bit(GICV5_ARCH_PPI_SW_PPI, kvm->arch.vgic.gicv5_vm.vgic_ppi_mas=
k)) {
+		bitmap_zero(kvm->arch.vgic.gicv5_vm.vgic_ppi_mask,
+			    VGIC_V5_NR_PRIVATE_IRQS);
+		bitmap_zero(kvm->arch.vgic.gicv5_vm.vgic_ppi_hmr,
+			    VGIC_V5_NR_PRIVATE_IRQS);
+
+		for_each_set_bit(i, ppi_caps.impl_ppi_mask, VGIC_V5_NR_PRIVATE_IRQS) {
+			const u32 intid =3D vgic_v5_make_ppi(i);
+			struct vgic_irq *irq;
+
+			irq =3D vgic_get_vcpu_irq(vcpu, intid);
+
+			/* Expose PPIs with an owner or the SW_PPI, only */
+			scoped_guard(raw_spinlock_irqsave, &irq->irq_lock) {
+				if (irq->owner || i =3D=3D GICV5_ARCH_PPI_SW_PPI) {
+					__set_bit(i, kvm->arch.vgic.gicv5_vm.vgic_ppi_mask);
+					__assign_bit(i, kvm->arch.vgic.gicv5_vm.vgic_ppi_hmr,
+						     irq->config =3D=3D VGIC_CONFIG_LEVEL);
+				}
+			}
=20
-	bitmap_zero(kvm->arch.vgic.gicv5_vm.vgic_ppi_mask, VGIC_V5_NR_PRIVATE_IRQ=
S);
-	bitmap_zero(kvm->arch.vgic.gicv5_vm.vgic_ppi_hmr, VGIC_V5_NR_PRIVATE_IRQS=
);
+			vgic_put_irq(kvm, irq);
+		}
+	}
=20
-	for_each_set_bit(i, ppi_caps.impl_ppi_mask, VGIC_V5_NR_PRIVATE_IRQS) {
+	/*
+	 * Apply the mask to Enable, Active. Skip pending as that's calculated
+	 * on guest entry.
+	 */
+	bitmap_and(cpu_if->vgic_ppi_enabler, cpu_if->vgic_ppi_enabler,
+		   kvm->arch.vgic.gicv5_vm.vgic_ppi_mask, VGIC_V5_NR_PRIVATE_IRQS);
+	bitmap_and(cpu_if->vgic_ppi_activer, cpu_if->vgic_ppi_activer,
+		   kvm->arch.vgic.gicv5_vm.vgic_ppi_mask, VGIC_V5_NR_PRIVATE_IRQS);
+
+	/* Also update the vgic_irqs */
+	for (i =3D 0; i < VGIC_V5_NR_PRIVATE_IRQS; i++) {
+		bool visible =3D test_bit(i, kvm->arch.vgic.gicv5_vm.vgic_ppi_mask);
 		const u32 intid =3D vgic_v5_make_ppi(i);
 		struct vgic_irq *irq;
=20
-		irq =3D vgic_get_vcpu_irq(vcpu0, intid);
+		irq =3D vgic_get_vcpu_irq(vcpu, intid);
=20
-		/* Expose PPIs with an owner or the SW_PPI, only */
 		scoped_guard(raw_spinlock_irqsave, &irq->irq_lock) {
-			if (irq->owner || i =3D=3D GICV5_ARCH_PPI_SW_PPI) {
-				__set_bit(i, kvm->arch.vgic.gicv5_vm.vgic_ppi_mask);
-				__assign_bit(i, kvm->arch.vgic.gicv5_vm.vgic_ppi_hmr,
-					     irq->config =3D=3D VGIC_CONFIG_LEVEL);
+			if (!visible) {
+				irq->enabled =3D false;
+				irq->active =3D false;
+				irq->pending_latch =3D false;
+				irq->line_level =3D false;
+			} else {
+				irq->enabled =3D test_bit(i, cpu_if->vgic_ppi_enabler);
+				irq->active =3D test_bit(i, cpu_if->vgic_ppi_activer);
 			}
 		}
=20
-		vgic_put_irq(vcpu0->kvm, irq);
+		vgic_put_irq(kvm, irq);
 	}
=20
 	return 0;
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index dc09ed1a2612c..d3dcf1598c421 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -770,7 +770,7 @@ int vgic_v4_load(struct kvm_vcpu *vcpu);
 void vgic_v4_commit(struct kvm_vcpu *vcpu);
 int vgic_v4_put(struct kvm_vcpu *vcpu);
=20
-int vgic_v5_finalize_ppi_state(struct kvm *kvm);
+int vgic_v5_finalize_ppi_state(struct kvm_vcpu *vcpu);
 bool vgic_v5_ppi_queue_irq_unlock(struct kvm *kvm, struct vgic_irq *irq,
 				  unsigned long flags);
 void vgic_v5_set_ppi_dvi(struct kvm_vcpu *vcpu, struct vgic_irq *irq, bool=
 dvi);
--=20
2.34.1
