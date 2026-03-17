Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011048.outbound.protection.outlook.com [52.101.70.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D4C93AE19A
	for <kvmarm@lists.linux.dev>; Tue, 17 Mar 2026 11:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.48
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773748201; cv=fail; b=rboCBIyF0fo0LMvroEqissNKvMuht9jB1ohyzXD2Azg+xFDwycaixT1+3qHNmjmINbmfTmcNSMSLwnpNi8uMBgweZr+pirxzJQIIBqiB3FaV6CuQhnZuYwqdR+2vr5JpBWC69fPSQ4XqT/xD944CGsf78h7VXyyZPVSmC3KfKB8=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773748201; c=relaxed/simple;
	bh=ETz9emsfBVfXnRBcxNTO1j6W4mII5tgpoyFRRjnGH9Q=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=frzgCfOzPtwNEjCPl6hh+snlrbnLhznzLQJmvoLpwXtS+n9n0ut0PjFVhvih2uIGzBwyZxA4NmM35XTyV8/NoXDsguI2TiTN0E0hRvA25GjPrULlZ6EYo4NIUZ6EY/6eR1DaMomrRS9I4Sa7KYGedjkuJrHqI1GmjFNfx/ebSKc=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=mEzFoUG1; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=mEzFoUG1; arc=fail smtp.client-ip=52.101.70.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="mEzFoUG1";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="mEzFoUG1"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=R72BZr/2AIuBt1GkjzVHLrLGnWVVnLAEa3FIKh/yCvQ/UbPSl7Y/h1ZWVshESCjRUO3n8e8/JgoNmRkJx6M2138iMEQJg2wzQRr5I0HhkIjnwUhIdiHIwpzsN3e3gx3ZAH0K9cvGQF7i4BYNtm/CIRfLLrAztzpFHTBRpP1Zn8qpkyFB/fQ0PXq9UCVFBo+L3XVqU7Ya4Cd33pwkzAwKmcoMMBVEmgwHqPXM4tUQr7bpZ40REHOSqyrKYZhcwwA4RDK4eMtbJOE+fUs9oKC7/Zb2fllHc1ITD/2KB1h8QkemUSxFPXX1yljR5Hp1mV+6hS2H3LJCxtP18p4uXiWSfw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8vgCkTG8eZDabbYo+b/p6DgRLZTdFmhd6KADxzqC1HA=;
 b=TKnpH0gKOZDYb/v7CzDc4Zpqthn3YLRV6OLdP13kh39PBI6+i5FFQkXqRZgp6355jOd/eiYQmg1a8NRPOJxhiOr9gWaWy5lsGWW8vslU5LuYhcqlwjC41UCQvpJkhZwWGu2xc1NmZ5afAB831v9NKO7QUXzzJviKFtyHHd2serkRIhtbF8l9JkmoKTGBcfN0g6qso9BPfdF8TX3ZUuiVOyGvplw9UchurHuHdimDBrJEQSM+4ZYrZGbDHII9FRUUJauPQF1I+LvJp8hg2mjlNLwTddxH6t/tDh1SNCGcqQQGmcebE4aDX1xbXGoy69HiIAbyKJplMmTrU0buDjAqDA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8vgCkTG8eZDabbYo+b/p6DgRLZTdFmhd6KADxzqC1HA=;
 b=mEzFoUG1qzbj3eKI6AJCk5PNhdnTqZX8i1nxplo4RyeyONa+2x5YT3+PuhvLfV5B06H6PUOcEnTcyPcv4STsOw5PEUS/wiWnkeQ7VWR7HWRe4L3BtFUQWdnJe+S+u/kaTdoicV0N1+AnWKDg6YShn3EGoDgV5scuf41h849HBQU=
Received: from DUZP191CA0061.EURP191.PROD.OUTLOOK.COM (2603:10a6:10:4fa::16)
 by VI0PR08MB11169.eurprd08.prod.outlook.com (2603:10a6:800:252::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.24; Tue, 17 Mar
 2026 11:49:50 +0000
Received: from DB5PEPF00014B93.eurprd02.prod.outlook.com
 (2603:10a6:10:4fa:cafe::1c) by DUZP191CA0061.outlook.office365.com
 (2603:10a6:10:4fa::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9700.27 via Frontend Transport; Tue,
 17 Mar 2026 11:49:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB5PEPF00014B93.mail.protection.outlook.com (10.167.8.231) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9700.17
 via Frontend Transport; Tue, 17 Mar 2026 11:49:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lADMZBAmcdShcFGaFztfpDrvC8fGccPyshmd6eKUMLK2a8tpnhAGHoSFM6eESy88oaM8VuUyaOZZsjwPc22PoQJPrdzl4qckCz47FXhub75Y7nCA4oBy2xPc1Xs2ZfxGhkoMoGWU8E2w/kHsIZ7GDS/OhMHlM2Jf2T9ZW9z7BJD2XeMeZja7KC8FbVh1tIoyTRifWvtIzQU5rxMQCEUV2gtx/95iiZ+ju5Y4hY3WzCGfT4zT5lU00UX1vALyl8jk87N6iruSdlymQvZNj1SN+Gm2SyhBlPBwgzW8X+NQuopmVjMgQWzLxx2qhZZdTUYMzc7RIYhET39N4+g/XDmbeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8vgCkTG8eZDabbYo+b/p6DgRLZTdFmhd6KADxzqC1HA=;
 b=Yf0jsnQ/OMedoHgWyr9FPC01WVX9uxL4X5Va4tHcC6o09S1308NAnYdOUQET7Qj/aO5sWKa0TSTrphNuRxbHjx5kO8SAxqwYF9YnOyVEd+5j7MFyVb0/1Gto75sFQ5jvETQE+a5LbSkXjQCvA8bvGpSD9oI0N15XK4RkAFBvxipBSX/K6N4eRkvmgiHxvNudPT7lp3DjJ/vu/Fwi/2hCqR26j5DlPhdB03Vzs34ms+TNN5JoJ+1bKs+iejlQmGziMXgIduqE5Y6hbQsmhHzhvxwoq6hoK6gN+Ysn09XFc23jKiHStlHtyawWgmScY0rnGfktZB4/DxmxIamrv/ERrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8vgCkTG8eZDabbYo+b/p6DgRLZTdFmhd6KADxzqC1HA=;
 b=mEzFoUG1qzbj3eKI6AJCk5PNhdnTqZX8i1nxplo4RyeyONa+2x5YT3+PuhvLfV5B06H6PUOcEnTcyPcv4STsOw5PEUS/wiWnkeQ7VWR7HWRe4L3BtFUQWdnJe+S+u/kaTdoicV0N1+AnWKDg6YShn3EGoDgV5scuf41h849HBQU=
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com (2603:10a6:20b:504::10)
 by DB9PR08MB8483.eurprd08.prod.outlook.com (2603:10a6:10:3d5::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.24; Tue, 17 Mar
 2026 11:48:47 +0000
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27]) by AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27%6]) with mapi id 15.20.9700.022; Tue, 17 Mar 2026
 11:48:47 +0000
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
Subject: [PATCH v6 34/39] KVM: arm64: gic-v5: Set ICH_VCTLR_EL2.En on boot
Thread-Topic: [PATCH v6 34/39] KVM: arm64: gic-v5: Set ICH_VCTLR_EL2.En on
 boot
Thread-Index: AQHctgQDBuR6c0Hmr0+We92bNjUXtA==
Date: Tue, 17 Mar 2026 11:48:46 +0000
Message-ID: <20260317113949.2548118-35-sascha.bischoff@arm.com>
References: <20260317113949.2548118-1-sascha.bischoff@arm.com>
In-Reply-To: <20260317113949.2548118-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AS4PR08MB8241:EE_|DB9PR08MB8483:EE_|DB5PEPF00014B93:EE_|VI0PR08MB11169:EE_
X-MS-Office365-Filtering-Correlation-Id: 7c1a086a-46a3-4c46-5c22-08de841b4bd2
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|38070700021|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info-Original:
 R43OTDs/f+FnpzNeKZtbEhSfU9C1XbhPy5kKvIcY08Oljss+p6OOWuFAVJ7iJHZjUCnBkK2i9uS9dFn9HZL7b/5trW/7+akknHHHKVZ2rDWWzyOiEQEaW4leB/ezoRb3/iRWOoEhF/vg5uOgl+dEMb9plQwbj++As3Q2aj9WGse7eZB6wEuTtXLjHh8ufkfVmdApjTkkAKAe9voqlcjZ//WTBygQB2NJI8+7dc5rkhGbHC3aZ2lH3jbQf87jECGDOwsSIWEX9iMAKrpbwOEMJh/9REzkH6rKwLzz3hEFLDNdsTpsU9q1byfiXtDTlIv4D+Wcy0HLCgyOxx9grk1Gkz/ufrlun1HH7KD7z7ibKMZW31sOE/ZjOC5+lemQRtMcAEYgZQJS/2yAwVfFaf49/Ul77m+9NbLOzjrYt7qwsfJ9qj+fcrwGnTKMwl607Uf2c3ml0d7NDsAS6gFqkduQ2AT+gx6ZS3K1dCZMbK4yjTMrBg5z2m1LjcVERf4a2M65sCLL1SaqwSSUiV/Ht0uzUqMbmEOPfkWhP2efdvkR2TuuX3E5xYD6hDkO+b7+vmzbMRyx5M5iOLj6fGxEBQe+dVn05ozfZAYiCwIktni6kDxhTbY2pmwTBXNLLpCne5IcCtiY5jsinQL+OOAU+pTuLzSGYD9MIZDDLVyQ8JzL1PdS9NoprclVxAoLtHAZ1xlfPfnfl5kWB3k4NXwJg3mlqGVwTuA0R464UnL3hhppoqq9rl9HTCqvbyTUPDFEDumq3rbyiW/nsheuSTudDuC0Gh7gIEDJSC1Soff7NAJKGd4=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS4PR08MB8241.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700021)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 OaMhaY4OvKBINizg9BvsXHgUmZrvRhHVX7zkOUYlbvuj8juarbySENWN9zJkxlS3udbnXioWC76hpMnyv35zpv7TiiLsQgeUSev1p7jb7oTQSVPU5QuTLuUsPz43fmcvZCN7iZOlRGOPdGy4N7+KskADMxE8jICHxv7BcQKCrtwOQ0gV9gaQoxRGvgm/yoskU5bgXFN5AG96vyAOw9QjB2kSSKrlPdgn0F+Rt8Oab1pR6zuS4Q+Dhza2oVcMhPRpSUpRl6cfELBHGz1sm+5r5xTdJZE8N/VooY3hR6UQaHsO9NjRM3eWkaZZ3Tixc1ptPrtniVKVR+EBjTrxs7bmSw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB8483
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB5PEPF00014B93.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	5ae295d4-cb74-4c05-7e53-08de841b2606
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|376014|14060799003|36860700016|35042699022|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	ARv+Q6MDkKF18izHw46X3aeAHv8kPU6Zuh9xIkDA0lCnCRTuyrkQstkG83Ae8JZdv65Q/uTLDckzUp2AaWrYdO/58WOx9ZybTHXtzEZ9+/hEpM8iDgp3IcdwsELFxyjOdmkD5maATzoL2insMpgZwUoNAmY3tNs+YoS8btX+sHadOmQ0kZ61+V0AvuTAeMoEGXu5YeULaywcq/vO7tdEH67h1H4+eP6FBH3V4I0Hn/5ESE92TzDGdO96wEOrdy/DVfr95c2zPBhZUkWq029gLSYY467Y5nZrf7RWLl0/SiMlBgrqHxH7j9ts8SVSmAG4Qx/a0K7PnGgJJBQ/wvZO88JwuV0uKENHIRMulk+Nw0luaLuQ+uBxfvp5YEjJIr43NMXRgYXYFuQhsiHAK5gHMLtQhPYqUlEXcyGnjt3f1LCv9YisJUosVBmGtgO3pBvFWHb+9Llstaic0eTXUO0bfJS7wVGLPR1nxLcsn6jwVzQKeYbRtoi215jufPR4lR4I7Du9XNTVle7sDPvQcj/WHcP8PEF2x2g0Jk8fWyS/Xf+1DLYSce+9Lhi+7MRXwgjqU1EE6q7RZFupAdDCR/UMM902FqNborvvbHWSX8ANsqAfFsYRUhNM3BPk27/hLn+lZi5Fnzyz4K+2NprPAIhM+3ScFmsswlXdyVztGG1bziwowWnMXurNPVna14JpXWVtxtGaPApxIzHx8dDawQeM9CN4wzAc2MliAu8K5mhlBKmivhoMBPB0nBX2IVgkC2lClFHY6G9ktDoB0X5Ybxv9kA==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(376014)(14060799003)(36860700016)(35042699022)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	TsP9RswD1+Vj5ljPgSaRKCWk7bYcamhDHpkEh5Uep7fIwIG+nUwQrGNZG1BMG35wksQwo9W0KHBJI5jNfBi7En/6biaG5H21NZ0wT51tQ1IQICSUVWJ/3CwqAc1RtJYSE2mzawJ5XWsjfD0WasmJd+5ffum0GhXL00+ZQHn/tmupZ94QhO+ZhCOh4pkRZyIdkMHy3KxuVBurIWRnTPyBUOpvB2AdG52LQ60yyWhNBhLAsq/EAYaEkUUo2hbcLA8deDsscJ7cdvd5MZXC0ARx+kqyD6RZs7MuniGh8TgfX3SzgNxSeiBqPcK85kcUCIawMmaNvyxi0CmN5i2gfTvA8CUd8jI6K4Q4RGoJ2De6vR5jT9TehDIhquy4fqsa/l/JASL4vlEVsUJeFdf7Rvvh2cBckt4J605Z19q2kv17OvaVM0wPbM1x3fMJ5FWzbjAP
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2026 11:49:50.3254
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c1a086a-46a3-4c46-5c22-08de841b4bd2
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB5PEPF00014B93.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI0PR08MB11169

This control enables virtual HPPI selection, i.e., selection and
delivery of interrupts for a guest (assuming that the guest itself has
opted to receive interrupts). This is set to enabled on boot as there
is no reason for disabling it in normal operation as virtual interrupt
signalling itself is still controlled via the HCR_EL2.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/include/asm/el2_setup.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/asm/el=
2_setup.h
index 85f4c1615472d..998b2a3f615a7 100644
--- a/arch/arm64/include/asm/el2_setup.h
+++ b/arch/arm64/include/asm/el2_setup.h
@@ -248,6 +248,8 @@
 		     ICH_HFGWTR_EL2_ICC_CR0_EL1			| \
 		     ICH_HFGWTR_EL2_ICC_APR_EL1)
 	msr_s	SYS_ICH_HFGWTR_EL2, x0		// Disable reg write traps
+	mov	x0, #(ICH_VCTLR_EL2_En)
+	msr_s	SYS_ICH_VCTLR_EL2, x0		// Enable vHPPI selection
 .Lskip_gicv5_\@:
 .endm
=20
--=20
2.34.1
