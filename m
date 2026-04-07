Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013020.outbound.protection.outlook.com [52.101.83.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6EDC2222AC
	for <kvmarm@lists.linux.dev>; Tue,  7 Apr 2026 13:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.83.20
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775569849; cv=fail; b=HOfRCXooPVrl+hr+F7YO5oJgEmrChVNd0o8ClbkXJ+3wudlNgkVpJMVB6OE7n4luQ6L8REv6Oc3OVeBmm9bdP50TulmnLRSXA126+SAUkfRIrwWBezx4mmRa/KBrTnNSjlVHD7dY27swinOZQVPBmQlWmgt2hz5iWO3chGLGhG4=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775569849; c=relaxed/simple;
	bh=T7srunrcxoFLHxyVRXANfaXJyDDEvW3oEyipvukdQ98=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=hUoFN4YDeJgGbW3whB8d+0G8Kq+aPiW2JsRsJqU7q/8kge9Lji9kMtU7sjC/9NEFr0MB4BYofyFFvESR9uPX+5YguAkuOmkeiuJ2bgi8/07uGxSWNbejSYV6jpKrTF3MPCcHE4KPwwSpfvhYXqzbH+HPtO4N8ndDnj1BqDjYJgE=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=VXZJUP/P; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=VXZJUP/P; arc=fail smtp.client-ip=52.101.83.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="VXZJUP/P";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="VXZJUP/P"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=JxX7hOTt9LUk+CvvbrYtma4lHp5pggSiO0nxYsN2nSot9g5bDJJg8fLoQwgQjOsSBi6TYANm/1mss8SU5P3473zAEUjJRz78w/+KKzjiK6mhteTmgZvMvSs9yzJEou6XNSCloHlt1koUkb+BG5ZvsIxlU7hdKQxMOi28SG+AJbg+Ka7gXqvI6qfTRCU0FNHT4/B9/Db4EYVlMgUHutjb3crgCO/DqAvPHWi5EOScCTh/EmK/SUhPKMAfLicjRF+0RuZsH6vnPEk01gNymOGhy1/ZhM+bHspLCRmzWZatALT7Yvsc0yviCOfphP0kwWXxaSGqhXTfXAOUosdABRd/Rw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T7srunrcxoFLHxyVRXANfaXJyDDEvW3oEyipvukdQ98=;
 b=jrgDeTZnsqU151sALslUClg+S90V+CawBd3KcE/XgTSxT7YkWEj43JhAzGw2yEqA4bdll50QF7N0g9+Dx9T818AUh29UhMO0/tEyznqXVZLu8PwboLKJsJOUqC4TrnzWMa9VQ8fYkcWIW7aHFv/xDWCATnyuQzJ3DrGHlUxyJVRyD9sDjgnCC7hA8dLmu7c/Rq9OEuECd7xrtxxKv0Ey40G4NCjNHuuOb/vGha6VpXt5Vps2Nrhxlwhc9RL7Hu7O828TTPeT+hd8+3D64qG62A94tzh+arDTRnJb7W+A471+QN5EF4lmgFWe7jMw+XupQZdfWOxc8uF9UORkhsevbA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T7srunrcxoFLHxyVRXANfaXJyDDEvW3oEyipvukdQ98=;
 b=VXZJUP/PgniK/kpGMC7FsAoBW/XqR3ihi4NjSIID1ZItSp9h68BsztzeNL3RTwqNAPpR2ClT6XjMZ7iAb+KOiVfumOqqIM2wiu1rKfL4s59XLkB0h6jg27kQtlVKlXbW6IkaTeI5PHlaESJ37qz7c7WB1Lam1ypX/NUaoi4o5a8=
Received: from DB9PR06CA0026.eurprd06.prod.outlook.com (2603:10a6:10:1db::31)
 by GVXPR08MB10940.eurprd08.prod.outlook.com (2603:10a6:150:1f7::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.20; Tue, 7 Apr
 2026 13:50:35 +0000
Received: from DB1PEPF0003922F.eurprd03.prod.outlook.com
 (2603:10a6:10:1db:cafe::5a) by DB9PR06CA0026.outlook.office365.com
 (2603:10a6:10:1db::31) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9769.32 via Frontend Transport; Tue,
 7 Apr 2026 13:50:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF0003922F.mail.protection.outlook.com (10.167.8.102) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9745.21
 via Frontend Transport; Tue, 7 Apr 2026 13:50:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=m6eq8qn1XRfAYiyw5FcayNDpGrpjRWEgohQ9QYpAFCZpsJphDQiCf5FKnfRz0uYb0i6UC5JeoOq2sFLx0YMEBxewWCUw3eLhNFRpXUMHqutKekbtBIO649MDt+gEB44+7QYO1ov86mGCDCAsYxFW/2yzOi0Lg48WfKkePrSOYjGXKJINeTtGHC26l9wxPCyEt8UKw/Jaw7mnb3K3PGG9PiDvKM+M1uaMA7ldludaDsPwSizYDASp/9iGMhNOYj9ay/ZH2mDcjquagNZXI+pxLYUR6cn4zexPglE00miTt6KzO/dB2x82SRLeeRGOSML0OQqazjHS7roOCoPF9+5BtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T7srunrcxoFLHxyVRXANfaXJyDDEvW3oEyipvukdQ98=;
 b=uWThMcRztSz8tVuHEk4+H12yyJIVtXv22m2ahLOtJhPcv75rXhoY1nOsS/7WcciW762HIS1qBg8+amByNmHe/y4sk0WGpNMwuYAe9YIKhh9ig7b1EW8ibmRG1PW/yeaqpDHVp5vq/duUkrdwWb4aGcv/AoG/54X7jLIniIUI7RsSqRZzvAHhrJg1YD1MXZqCcbcwDSfUcva792GwnUr2oWYoHUUcQPGe7nH/2uNH85xlZbejcNu9G0NJwC1ifgGtX2DmkilHSp3c3xJhrAc5vYIDzdYjOp0h861nvAomFjOSEZrccy/IWCzu4Pv+2K4kqvAW59ak+aD6q8JpDCfmaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T7srunrcxoFLHxyVRXANfaXJyDDEvW3oEyipvukdQ98=;
 b=VXZJUP/PgniK/kpGMC7FsAoBW/XqR3ihi4NjSIID1ZItSp9h68BsztzeNL3RTwqNAPpR2ClT6XjMZ7iAb+KOiVfumOqqIM2wiu1rKfL4s59XLkB0h6jg27kQtlVKlXbW6IkaTeI5PHlaESJ37qz7c7WB1Lam1ypX/NUaoi4o5a8=
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com (2603:10a6:20b:504::10)
 by PA4PR08MB7523.eurprd08.prod.outlook.com (2603:10a6:102:26c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.17; Tue, 7 Apr
 2026 13:49:25 +0000
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27]) by AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27%6]) with mapi id 15.20.9769.020; Tue, 7 Apr 2026
 13:49:24 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: Andre Przywara <Andre.Przywara@arm.com>, "will@kernel.org"
	<will@kernel.org>, "julien.thierry.kdev@gmail.com"
	<julien.thierry.kdev@gmail.com>
CC: "maz@kernel.org" <maz@kernel.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	Alexandru Elisei <Alexandru.Elisei@arm.com>, nd <nd@arm.com>
Subject: Re: [PATCH kvmtool v7 6/6] arm64: Handle virtio endianness reset when
 running nested
Thread-Topic: [PATCH kvmtool v7 6/6] arm64: Handle virtio endianness reset
 when running nested
Thread-Index: AQHcuuTDEPOksgLcoEuASevPbnL8XbXTtOSA
Date: Tue, 7 Apr 2026 13:49:24 +0000
Message-ID: <14785aa3b087d6b38beba26c85048fb26bf486bb.camel@arm.com>
References: <20260323164717.2571585-1-andre.przywara@arm.com>
	 <20260323164717.2571585-7-andre.przywara@arm.com>
In-Reply-To: <20260323164717.2571585-7-andre.przywara@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AS4PR08MB8241:EE_|PA4PR08MB7523:EE_|DB1PEPF0003922F:EE_|GVXPR08MB10940:EE_
X-MS-Office365-Filtering-Correlation-Id: 279a62f9-bbc8-40cd-098d-08de94aca4fa
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|1800799024|376014|38070700021|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info-Original:
 JILHJ2JtCPuwe+jl96rBBdUF0aPFqT3sKKDe2fa19UH3ve9uxUzyo78zkPe2wTiUuxv0zMc2ImNXhZRUdSAtJrfmgAIKG5X4R1aJqagHPH4OKktLQ3FbyBgaMCLAe3hPjTMbygxjVlnFsPEAw2aLWERMz2a7ts0FWKp4yugo8Lpl2sqCkVoRcR0OKRXLdzuxT0WUUx08zk1giIoKfXbjfU+nuci+Wvg8BIQqAY/NUMBRET34m0hU2eVVguoFqmx9di5+2gohgd7417Sa3ZZqq5B4roEjKdw3O3NlnpVw5TJPsK2hpCZXrSMnf0SybmZAjLkK0yLVNYnZYocuz7B6QbEE3j556QnksIdnP7m2pxPhXgVDzcKyuaCWXwZYVvR6cy5ce+mmvcQLf9sHnXQt29b0Mlqw+v+rwf4xRyzKCcS4xSMyXlqyc1eE6QNfn6jjM5ryIDdQ+SjSSGUjTOh9oMNG9IVt1IEk1atl0iwVBNraDArShXG2/sHCSZFRfDXgGY971qaufqzBuW0UIBeOA5nsEuNn0b97ZzQ+ZhB2HU9G+5mAKD2FEMyRDgRPrTlVRFoP4fy8ogulPXqmm5oXQ+QDQHjpUK+yOCWXqDu3WUVhQ1Pc3hDWCFG0nJ1SuO/MOoRW7n5riCoLETOTTVqZ3mt5hx/5TDOJ19AG4/OqMlKooRQoL0CGu8yIuuyBdofB/ULWNfSwuQU7XMEN/SUTnMllhBjGzTfWw6YnVgJ0OXgzmOwMYahMbieyY+mXBQkvLTk9TGIfWiA/N/RMLYZHUQPFBzhAQcpKLG3Rx9WFwqY=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS4PR08MB8241.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700021)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <BA1EFCCEADDFD248A64D7CB8907B17BF@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 MTw4ksVAykpdRM/POUu3SazO+cdUPfKeQ/aoNT5/KD1z/NYRpFaAvxrUtCWWBbnCbgp2Lq2aOVwsQSUS5CXwC1qW+UZcZuPNLcdr11QAqQZC9BafIdJKKmgQB94ChtFICb2XISEKcsJsMgETTsiBHJ5H6PxD3wAzHQyzlJU+0Y9gO85AetylsiXFMbVklx03ygE93jwgGKFcYZPOih2x0tEURDIsB9tQz0yiaSeQUsAZGYcoBEZOxdQjAFDRtAQGxXnE5xHuyH6JMsVQWN4/mJWWZg6uzGpAgJX5NrvXz+9jl8DKrXjefW/t/oiiPbejVMhlsibiJycA5L6vBMYeIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR08MB7523
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF0003922F.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	5eda4047-f4f9-45b6-4b1b-08de94ac7ab3
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|376014|82310400026|14060799003|35042699022|1800799024|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	n+4TzzLfUDC1utcCj7qqnm01U05KXr1W7UrNbGLi0mqM4okgAMdiTdSGj1WVZUluOAUMtngvwLYAHLr/9bMDCr6/qTCLxrywsL1kJY+7n55vxQJY0LarFolDeOvIbkUzUoploePLx4aYsX2wRMeLg7d7h/XdNJ5nA0zUC9HwDb0JMpzvUX2Y4mtobXovvroG5K2w7DGdBJxhKXP4T4SlXytuGZ6Y9Xpb5tkZvwP31yf5icwemVHYu7Ieh0hMqbO/5ePbGSXbWYxjpFt3OrKYRWCINraXgBdQD8eIrybkHft/juzB4AACeah2Mn8VxxC3mUrDdMaVZAtYEymUcoTTfv1t2+GVIM8HICLgP/FCORrcMknfds/lJlMpcLHCcrQtBQwzthDpmZ/IR2t4Vas0/aeRweXAAnLjP7MZVRTxIyhlAh4QB9l5p3VQxHToDitHdf4fKJnMu4jXsbgPWtoYNWAI17FSOpRWw7bTAqfpsqh4hFhR+VlTH35yipGZ2ue7h/YyYITANlUPrqg+iiJcHGX/0B3AytqFUxAG/UoV8PRSUtQrj7x7B3LRzeU5aAh7SFyg5kXf+e0csflQBVPbZ/T7314TmJutP4QweXjv4PmCDp064Q7DtNW2jkkB/N5MLQpJu5sDH6yGHDVKMCr9hgrLsDcCwEenE9berKM+TQz0+Ec/zCxbVNU7ocVqhRA+di65eaQS9Ln1JzQjy1la5cJGQEXSX/fHOd4gFzfhQ9S+IBoenvBeaTpZTnKQ7iB0JhyInom+NVd47pWSv4lomQ==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(376014)(82310400026)(14060799003)(35042699022)(1800799024)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	vTPUwgGDOZmdgXTYr2zqIbxBDmnYaq4D9rxxMTxeLdRvnZMk5t6inmMX+l/BBIVVTHIJ1aWW2ldwirBCsnayCbx5p7yjC+hCbg6/GJ7l1HXclnIijaO2pQ8tWHD06xbfOe6zm9ISbRq3jOuWemsgKEjCpFKFePvI/oHM+9RNHgxIO5YniJBo2LhEnDjQJVvggOJnYe66KFVfe/WsGL4UQ3/zyuSGHCrsn9NazUeXpLuH5Wa8rCTmzF8h9JmvaWNYbdIwF67choMmt80t6Klhj3coO1Uf2pperrmBletNSKqDeES0DxroW5pxc93aYYvRLhnii8N2BZY+YS49mpD5kqr6qgB7qVdpvL0eS/pOe2RLPrVrQcSDVWJrAmx1K4ygD0kBf9wllM7ViGLubqgfUxK36QkwF/hzJexlooy9atJzvEDMlgl90yqjFbkXUPdc
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2026 13:50:35.5230
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 279a62f9-bbc8-40cd-098d-08de94aca4fa
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF0003922F.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVXPR08MB10940

T24gTW9uLCAyMDI2LTAzLTIzIGF0IDE3OjQ3ICswMTAwLCBBbmRyZSBQcnp5d2FyYSB3cm90ZToN
Cj4gRnJvbTogTWFyYyBaeW5naWVyIDxtYXpAa2VybmVsLm9yZz4NCj4gDQo+IFdoZW4gcnVubmlu
ZyBhbiBFTDIgZ3Vlc3QsIHdlIG5lZWQgdG8gbWFrZSBzdXJlIHdlIGRvbid0IHNhbXBsZQ0KPiBT
Q1RMUl9FTDEgdG8gd29yayBvdXQgdGhlIHZpcnRpbyBlbmRpYW5uZXNzLCBhcyB0aGlzIGlzIGxp
a2VseQ0KPiB0byBiZSBhIGJpdCByYW5kb20uDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBNYXJjIFp5
bmdpZXIgPG1hekBrZXJuZWwub3JnPg0KPiBTaWduZWQtb2ZmLWJ5OiBBbmRyZSBQcnp5d2FyYSA8
YW5kcmUucHJ6eXdhcmFAYXJtLmNvbT4NCg0KVGhpcyBhbHNvIGxvb2tzIGdvb2QgdG8gbWUgbm93
Lg0KDQpSZXZpZXdlZC1ieTogU2FzY2hhIEJpc2Nob2ZmIDxzYXNjaGEuYmlzY2hvZmZAYXJtLmNv
bT4NCg0KVGhhbmtzLA0KU2FzY2hhDQoNCj4gLS0tDQo+IMKgYXJtNjQvaW5jbHVkZS9rdm0va3Zt
LWNwdS1hcmNoLmggfMKgIDUgKy0tDQo+IMKgYXJtNjQva3ZtLWNwdS5jwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoCB8IDU4ICsrKysrKysrKysrKysrKysrKysrKysrKysrLS0tLQ0K
PiAtLQ0KPiDCoDIgZmlsZXMgY2hhbmdlZCwgNTEgaW5zZXJ0aW9ucygrKSwgMTIgZGVsZXRpb25z
KC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvYXJtNjQvaW5jbHVkZS9rdm0va3ZtLWNwdS1hcmNoLmgN
Cj4gYi9hcm02NC9pbmNsdWRlL2t2bS9rdm0tY3B1LWFyY2guaA0KPiBpbmRleCAxYWYzOTRhYS4u
ODhjZWY4MTMgMTAwNjQ0DQo+IC0tLSBhL2FybTY0L2luY2x1ZGUva3ZtL2t2bS1jcHUtYXJjaC5o
DQo+ICsrKyBiL2FybTY0L2luY2x1ZGUva3ZtL2t2bS1jcHUtYXJjaC5oDQo+IEBAIC0xMCw4ICsx
MCw5IEBADQo+IMKgI2RlZmluZSBBUk1fTVBJRFJfSFdJRF9CSVRNQVNLCTB4RkYwMEZGRkZGRlVM
DQo+IMKgI2RlZmluZSBBUk1fQ1BVX0lECQkzLCAwLCAwLCAwDQo+IMKgI2RlZmluZSBBUk1fQ1BV
X0lEX01QSURSCTUNCj4gLSNkZWZpbmUgQVJNX0NQVV9DVFJMCQkzLCAwLCAxLCAwDQo+IC0jZGVm
aW5lIEFSTV9DUFVfQ1RSTF9TQ1RMUl9FTDEJMA0KPiArI2RlZmluZSBTWVNfU0NUTFJfRUwxCQkz
LCAwLCAxLCAwLCAwDQo+ICsjZGVmaW5lIFNZU19TQ1RMUl9FTDIJCTMsIDQsIDEsIDAsIDANCj4g
KyNkZWZpbmUgU1lTX0hDUl9FTDIJCTMsIDQsIDEsIDEsIDANCj4gwqANCj4gwqBzdHJ1Y3Qga3Zt
X2NwdSB7DQo+IMKgCXB0aHJlYWRfdAl0aHJlYWQ7DQo+IGRpZmYgLS1naXQgYS9hcm02NC9rdm0t
Y3B1LmMgYi9hcm02NC9rdm0tY3B1LmMNCj4gaW5kZXggNWU0ZjNhN2QuLjdiMDEyZTdhIDEwMDY0
NA0KPiAtLS0gYS9hcm02NC9rdm0tY3B1LmMNCj4gKysrIGIvYXJtNjQva3ZtLWNwdS5jDQo+IEBA
IC0xMiw2ICsxMiw4IEBADQo+IMKgDQo+IMKgI2RlZmluZSBTQ1RMUl9FTDFfRTBFX01BU0sJKDEg
PDwgMjQpDQo+IMKgI2RlZmluZSBTQ1RMUl9FTDFfRUVfTUFTSwkoMSA8PCAyNSkNCj4gKyNkZWZp
bmUgSENSX0VMMl9UR0UJCSgxVUwgPDwgMjcpDQo+ICsjZGVmaW5lIEhDUl9FTDJfRTJICQkoMVVM
IDw8IDM0KQ0KPiDCoA0KPiDCoHN0YXRpYyBpbnQgZGVidWdfZmQ7DQo+IMKgDQo+IEBAIC00MDgs
NyArNDEwLDggQEAgaW50IGt2bV9jcHVfX2dldF9lbmRpYW5uZXNzKHN0cnVjdCBrdm1fY3B1ICp2
Y3B1KQ0KPiDCoHsNCj4gwqAJc3RydWN0IGt2bV9vbmVfcmVnIHJlZzsNCj4gwqAJdTY0IHBzcjsN
Cj4gLQl1NjQgc2N0bHI7DQo+ICsJdTY0IHNjdGxyLCBiaXQ7DQo+ICsJdTY0IGhjciA9IDA7DQo+
IMKgDQo+IMKgCS8qDQo+IMKgCSAqIFF1b3RpbmcgdGhlIGRlZmluaXRpb24gZ2l2ZW4gYnkgUGV0
ZXIgTWF5ZGVsbDoNCj4gQEAgLTQxOSw4ICs0MjIsOSBAQCBpbnQga3ZtX2NwdV9fZ2V0X2VuZGlh
bm5lc3Moc3RydWN0IGt2bV9jcHUgKnZjcHUpDQo+IMKgCSAqIFdlIGZpcnN0IGNoZWNrIGZvciBh
biBBQXJjaDMyIGd1ZXN0OiBpdHMgZW5kaWFubmVzcyBjYW4NCj4gwqAJICogY2hhbmdlIHdoZW4g
dXNpbmcgU0VURU5ELCB3aGljaCBhZmZlY3RzIHRoZSBDUFNSLkUgYml0Lg0KPiDCoAkgKg0KPiAt
CSAqIElmIHdlJ3JlIEFBcmNoNjQsIHVzZSBTQ1RMUl9FTDEuRTBFIGlmIGFjY2VzcyBjb21lcyBm
cm9tDQo+IC0JICogRUwwLCBhbmQgU0NUTFJfRUwxLkVFIGlmIGFjY2VzcyBjb21lcyBmcm9tIEVM
MS4NCj4gKwkgKiBJZiB3ZSdyZSBBQXJjaDY0LCBkZXRlcm1pbmUgd2hpY2ggU0NUTFIgcmVnaXN0
ZXIgdG8gdXNlLA0KPiArCSAqIGRlcGVuZGluZyBvbiBOViBiZWluZyB1c2VkIG9yIG5vdC4gVGhl
biB1c2UgZWl0aGVyIHRoZQ0KPiBFMEUNCj4gKwkgKiBiaXQgZm9yIEVMMCwgb3IgdGhlIEVFIGJp
dCBmb3IgRUwxL0VMMi4NCj4gwqAJICovDQo+IMKgCXJlZy5pZCA9IEFSTTY0X0NPUkVfUkVHKHJl
Z3MucHN0YXRlKTsNCj4gwqAJcmVnLmFkZHIgPSAodTY0KSZwc3I7DQo+IEBAIC00MzAsMTYgKzQz
NCw1MCBAQCBpbnQga3ZtX2NwdV9fZ2V0X2VuZGlhbm5lc3Moc3RydWN0IGt2bV9jcHUNCj4gKnZj
cHUpDQo+IMKgCWlmIChwc3IgJiBQU1JfTU9ERTMyX0JJVCkNCj4gwqAJCXJldHVybiAocHNyICYg
Q09NUEFUX1BTUl9FX0JJVCkgPyBWSVJUSU9fRU5ESUFOX0JFIDoNCj4gVklSVElPX0VORElBTl9M
RTsNCj4gwqANCj4gLQlyZWcuaWQgPSBBUk02NF9TWVNfUkVHKEFSTV9DUFVfQ1RSTCwNCj4gQVJN
X0NQVV9DVFJMX1NDVExSX0VMMSk7DQo+ICsJaWYgKHZjcHUtPmt2bS0+Y2ZnLmFyY2gubmVzdGVk
X3ZpcnQpIHsNCj4gKwkJcmVnLmlkID0gQVJNNjRfU1lTX1JFRyhTWVNfSENSX0VMMik7DQo+ICsJ
CXJlZy5hZGRyID0gKHU2NCkmaGNyOw0KPiArCQlpZiAoaW9jdGwodmNwdS0+dmNwdV9mZCwgS1ZN
X0dFVF9PTkVfUkVHLCAmcmVnKSA8IDApDQo+ICsJCQlkaWUoIktWTV9HRVRfT05FX1JFRyBmYWls
ZWQgKEhDUl9FTDIpIik7DQo+ICsJfQ0KPiArDQo+ICsJc3dpdGNoIChwc3IgJiBQU1JfTU9ERV9N
QVNLKSB7DQo+ICsJY2FzZSBQU1JfTU9ERV9FTDB0Og0KPiArCQlzd2l0Y2ggKGhjciAmIChIQ1Jf
RUwyX0UySCB8IEhDUl9FTDJfVEdFKSkgew0KPiArCQljYXNlIEhDUl9FTDJfRTJIIHwgSENSX0VM
Ml9UR0U6IC8qIEVMMiYwICovDQo+ICsJCQlyZWcuaWQgPSBBUk02NF9TWVNfUkVHKFNZU19TQ1RM
Ul9FTDIpOw0KPiArCQkJYml0ID0gU0NUTFJfRUwxX0UwRV9NQVNLOw0KPiArCQkJYnJlYWs7DQo+
ICsJCWNhc2UgSENSX0VMMl9UR0U6CQkvKiBFTDIgKi8NCj4gKwkJCXJlZy5pZCA9IEFSTTY0X1NZ
U19SRUcoU1lTX1NDVExSX0VMMik7DQo+ICsJCQliaXQgPSBTQ1RMUl9FTDFfRUVfTUFTSzsNCj4g
KwkJCWJyZWFrOw0KPiArCQljYXNlIEhDUl9FTDJfRTJIOgkJLyogRUwxJjAgKFZIRSkgKi8NCj4g
KwkJZGVmYXVsdDoJCQkvKiBFTDEmMCAoIVZIRSkgKi8NCj4gKwkJCXJlZy5pZCA9IEFSTTY0X1NZ
U19SRUcoU1lTX1NDVExSX0VMMSk7DQo+ICsJCQliaXQgPSBTQ1RMUl9FTDFfRTBFX01BU0s7DQo+
ICsJCQlicmVhazsNCj4gKwkJfQ0KPiArCQlicmVhazsNCj4gKwljYXNlIFBTUl9NT0RFX0VMMXQ6
DQo+ICsJY2FzZSBQU1JfTU9ERV9FTDFoOg0KPiArCQlyZWcuaWQgPSBBUk02NF9TWVNfUkVHKFNZ
U19TQ1RMUl9FTDEpOw0KPiArCQliaXQgPSBTQ1RMUl9FTDFfRUVfTUFTSzsNCj4gKwkJYnJlYWs7
DQo+ICsJY2FzZSBQU1JfTU9ERV9FTDJ0Og0KPiArCWNhc2UgUFNSX01PREVfRUwyaDoNCj4gKwkJ
cmVnLmlkID0gQVJNNjRfU1lTX1JFRyhTWVNfU0NUTFJfRUwyKTsNCj4gKwkJYml0ID0gU0NUTFJf
RUwxX0VFX01BU0s7DQo+ICsJCWJyZWFrOw0KPiArCWRlZmF1bHQ6DQo+ICsJCWRpZSgiV2hhdCdz
IHRoYXQgbW9kZT8/P1xuIik7DQo+ICsJfQ0KPiArDQo+IMKgCXJlZy5hZGRyID0gKHU2NCkmc2N0
bHI7DQo+IMKgCWlmIChpb2N0bCh2Y3B1LT52Y3B1X2ZkLCBLVk1fR0VUX09ORV9SRUcsICZyZWcp
IDwgMCkNCj4gLQkJZGllKCJLVk1fR0VUX09ORV9SRUcgZmFpbGVkIChTQ1RMUl9FTDEpIik7DQo+
ICsJCWRpZSgiS1ZNX0dFVF9PTkVfUkVHIGZhaWxlZCAoU0NUTFJfRUx4KSIpOw0KPiDCoA0KPiAt
CWlmICgocHNyICYgUFNSX01PREVfTUFTSykgPT0gUFNSX01PREVfRUwwdCkNCj4gLQkJc2N0bHIg
Jj0gU0NUTFJfRUwxX0UwRV9NQVNLOw0KPiAtCWVsc2UNCj4gLQkJc2N0bHIgJj0gU0NUTFJfRUwx
X0VFX01BU0s7DQo+IC0JcmV0dXJuIHNjdGxyID8gVklSVElPX0VORElBTl9CRSA6IFZJUlRJT19F
TkRJQU5fTEU7DQo+ICsJcmV0dXJuIChzY3RsciAmIGJpdCkgPyBWSVJUSU9fRU5ESUFOX0JFIDog
VklSVElPX0VORElBTl9MRTsNCj4gwqB9DQo+IMKgDQo+IMKgdm9pZCBrdm1fY3B1X19zaG93X2Nv
ZGUoc3RydWN0IGt2bV9jcHUgKnZjcHUpDQoNCg==
