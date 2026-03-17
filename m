Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013062.outbound.protection.outlook.com [40.107.159.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C3383AE1B7
	for <kvmarm@lists.linux.dev>; Tue, 17 Mar 2026 11:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.62
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773747924; cv=fail; b=QWEqKMm6wnPJBLawsPTWamMvWtnPpa1JhvSDT8knORx6doYngLt+i9kk3McBRXG8gZhRb3lADQYgb+H7ANY7376lekcVb65ODPWSw9P3fcggQUj9FPSqMK9Po24Eo5EtTfocf5oRJQmnCso7swvtqKiqCpRwSYQxmBj3PH8MNiU=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773747924; c=relaxed/simple;
	bh=YMlBAA2Kkmi42boY6G1P1sBGvdA7FnCE3zzzTFBwJLo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=CSmG+4bDOh6gV07vv8HfJPUz3GbAGt6hQ133/Er/JVSPYK2I6zONKWk5r9IVT9mMli17TJefL9kO2gVI+V2CFtsPsSJoyoPe3slMTjIPszs3EgF8noeVsFqpOhDqF+eG8UJvTaywD/cSTpRF3kypzetRn+DdU0j5yi5ws9e+5Ag=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Mer+Rv9Y; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Mer+Rv9Y; arc=fail smtp.client-ip=40.107.159.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Mer+Rv9Y";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Mer+Rv9Y"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=c9/PrNFU6J8rMRoJieGHo9WHC8LCKwrK6w+Z7c2262yTt8PO9aExK0OERbvx4B6i7er3A+sUD5icwGmrSvi9pxOX/Wpw9UyggspyRJNw2ffkDsKQ6y8JHZNHB01S4UZV6UyZZZ0VbcKwgYGq3nTubYngjE/0wcYee4b4mO48GTytRUyfDUqKV4TeIOIv/XXLQDMN1M+8hTVBeJA6WI1hU40nc1GV9PEMam2Q3OLsiu5vSGQioyZgSmBKbEMJIUWm/Zpcl+scx7ZD99DZo863WzpF0D1egmakZ7SGhH4cgdQWTAkUiZO0g8w+OimHbCqTyqA3V3/gpebiHBX+YM+kYA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ThP70AI7RN82U8GY8ikjc/c1uBRQN7Zc3DPAuOiFfA0=;
 b=AKWTOmOWnSuWb9mnEKB7VMc9ui8HpcE5gC7n5quhqJKa6FRmAvGQu42baAJqzoQXAJMpXEhtJUwYdLvbL9707cRcejuMMHLq6OnJ/JYVrW0nc0RtsGO9vrHgYC+dQqydrMfGk4yE+5bgc3kSZ1lDPXPHlmNMyQKd5YsfruTw7W5rXoZ5JIufTOTHOPAalpVJMYaxGjqlRgkuBNMePb/iPoVrOjzhWJUxSooLXQAf9mUzN4fimqdQTYsO7aUzXTOk+StU2lY3MkscQ0bVEAGlr4HzMYs+PikDF34Jfk/9AXOQ5BVUBFTgDvsx3RoptobYxe3AgiWzLLFgm2l3wNLUjA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ThP70AI7RN82U8GY8ikjc/c1uBRQN7Zc3DPAuOiFfA0=;
 b=Mer+Rv9Yy6KxDpNNClrRiYHTyvICzeH/Ke9ny6L+lIlOBW2xFL/ECPVRhjQWBVYCBzSmdxl1BIbcnl7b1BWFVuO082QV7qDuwn/scmBsUT+N6ce85jcsyIogXXUT3I+Hz3wYbLdZIeLzDHuLfrGJRBdq6P2PBYpdC5YL3FmDjgA=
Received: from AS4P191CA0014.EURP191.PROD.OUTLOOK.COM (2603:10a6:20b:5d5::20)
 by DBBPR08MB10771.eurprd08.prod.outlook.com (2603:10a6:10:53a::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.24; Tue, 17 Mar
 2026 11:45:12 +0000
Received: from AMS0EPF00000197.eurprd05.prod.outlook.com
 (2603:10a6:20b:5d5:cafe::62) by AS4P191CA0014.outlook.office365.com
 (2603:10a6:20b:5d5::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9700.27 via Frontend Transport; Tue,
 17 Mar 2026 11:45:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF00000197.mail.protection.outlook.com (10.167.16.219) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9700.17
 via Frontend Transport; Tue, 17 Mar 2026 11:45:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jv9n6kVQyLmCYGOnyQWaXzsmF1wz1kyZLI+gedxGs2C37WQJenxbnTWXJ8kAH/wUMJSgQeQClhKiEdlzFNTMsxEyIXuMw8SXa5AzCelEMhx6FT8mvBzTBAwJj0XNo90NLYO2DNFxgx1pxhTpVRORnY9TOM72vtlBnpcY0X1c4s9LUpmQjTH4cD6PYCYlpKs9wJRNjfJEvDZtghf4i0P5TOIhl3c/aLffC3AcHV9Nh5QcuF3x9A7UavlDhnKUxAlCJY5N3SOifd5zU3G0LbZQJo0wf2ZiDm+/A1x+Marf38150DrqSJPOz2pnWzefhSIjCkPep4/rwaH8zf+DXG5qGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ThP70AI7RN82U8GY8ikjc/c1uBRQN7Zc3DPAuOiFfA0=;
 b=KQS/n4KbwC2B2yDuEPLpdmVOGQWyo4Vycmgcw/Sb/ilRA+KhGi7AKL0bOz1PS7u3VPIpifRF41up1ID3vkbiacj7Q4sIfyWjvXcoA/6fR7F/gL3AIboqwB5D4o/O0a7BsTDmMsSfrKDEo2gYD1VAZodUP3Fd+n6v0EfciXwcgPp3q8leyCj9QPesWMUM8uJpJdIcd5EJ1kIm8EGc+S6OvXdVd/RYE9uJ3ixliWyDRwgLpb+9CTR+AAoUngtkMkGmNKgsQxYiclRnafqJkgA8sYA9D6MqRPfVmji+zBBByD2uNZCPsJNKLljSlFxGLxeDdAPJimvERUEtIMTkacjLxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ThP70AI7RN82U8GY8ikjc/c1uBRQN7Zc3DPAuOiFfA0=;
 b=Mer+Rv9Yy6KxDpNNClrRiYHTyvICzeH/Ke9ny6L+lIlOBW2xFL/ECPVRhjQWBVYCBzSmdxl1BIbcnl7b1BWFVuO082QV7qDuwn/scmBsUT+N6ce85jcsyIogXXUT3I+Hz3wYbLdZIeLzDHuLfrGJRBdq6P2PBYpdC5YL3FmDjgA=
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com (2603:10a6:20b:504::10)
 by PA6PR08MB10417.eurprd08.prod.outlook.com (2603:10a6:102:3cd::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.24; Tue, 17 Mar
 2026 11:44:05 +0000
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27]) by AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27%6]) with mapi id 15.20.9700.022; Tue, 17 Mar 2026
 11:44:05 +0000
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
Subject: [PATCH v6 16/39] KVM: arm64: gic-v5: Implement GICv5 load/put and
 save/restore
Thread-Topic: [PATCH v6 16/39] KVM: arm64: gic-v5: Implement GICv5 load/put
 and save/restore
Thread-Index: AQHctgNb9/4Mis+X3k6c3sLf2ujTyA==
Date: Tue, 17 Mar 2026 11:44:05 +0000
Message-ID: <20260317113949.2548118-17-sascha.bischoff@arm.com>
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
	AS4PR08MB8241:EE_|PA6PR08MB10417:EE_|AMS0EPF00000197:EE_|DBBPR08MB10771:EE_
X-MS-Office365-Filtering-Correlation-Id: 121eae23-9ec6-43b2-2a7f-08de841aa5ac
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|22082099003|18002099003|56012099003|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 JxxXWtDNc9XSkFjdUbdadjj+ywrrtN1d7PpuJz9WQ5RnKcrHWCH9MKohyjdN4yrq9I8vQjVd4TwbE3CDWng3ohmi7dSemlsDGl8Pe0UFsJNxeCTNDJmHSySm/mLhClnnkS03sDayY9OFp5SVZg6eG9HzCncZKt31/IFXOpSfvV8Kg5iG3B6f1CGBntXdq9lEAnq0auBFi2slKf5FhaU27TLSdWk8WDgmN2rhtId5SNYanaQusPgK7it8lsjUA82Svnmid1eL8lMQCtcNhaDWPRsukctoQr32OCQZzioMwPRH7nbgxtMRamhcsEAwN19SL0OBXl45zKfKlUgbH2AeLXkvVYbSTv+8D3CsDDbe32N8PwZvSQpu975t3BPV4GI0op108QhIfdWJV2Yvr3tfiu5F4YTpTElLMBUomizPY/dwVnfqab43omLp1ZTzPoB4ih46Cq/hZ+L1Nvqa7/LFCUduKYUStgvP5UHY7tXXnt9Y/MeyyXYoJZ7qfNtSR1oUdbSMUCV4eeHcMDt6Wsn1JLp/yAyH9zC/8Vf5iffJpbx4ndl+Rf10VDCGq8VIgvB+YEYcv/7C8/SXYZ52SD9LhwYnw4rzSheZ5ydFcGLmtR5CzT/9rRW+YBZBYCzjYMlxJQi3aq05qhMGu1FyDTyiu/Xlh5d7EQrVhWlTIU8E5TL4pLtcMPwwsEX8pR8ONEqS8audGRQxABTagazVVIXLjaeoC/l7O+fbBJR64Y+3f0W9aOQBMaRAtueXtH9cISPyHb6eYMhyNmFb/wCHjU0u1zexdFrxEoGk2MsFnbvMxz0=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS4PR08MB8241.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(22082099003)(18002099003)(56012099003)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 HTmNyWbW2s3BQkn8e/Rj1B4ZuPABgy0LBXk/hISRXr1Nmq60ONkI6npzm3IjDrnVLO5N53eABm2z+k9YSD3LXeTtebpPJ3FweriOX9CdnA8+JsbXMbaTSTcRR4kETe5KON5Gj2MXVggHqeb2gV5KLPK+DgM+ZvzHQfbPDXo1NtbsJ2wTiQZBrF7490CzHjjswsIFakzw7CM5U/Os742cFkljQUutUjMT3WhgnNjVgPvrijUfKS90215VKNAteI0flm0qNtgvROrdmH8/HGe/06RjtalZDmFzWQraLtIuHvl9BxVf5rZOJ+DS5QCYZuhXOT+pOwEEANChzLy1qEbzjw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA6PR08MB10417
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF00000197.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	7c2f7da6-f23f-4eb8-5af5-08de841a7e3d
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|1800799024|82310400026|14060799003|376014|35042699022|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	eecLOOk+f7JTgC1xSgG3weCIUM1vYb7r/NeapjZqKxAAlbERoy3Eh/nBpNX+pjzNh+cnPgTzfejk+p5t2lU61gGvJap17oV0lDL/ox9At1Vzw8sHUamQEEn3iyppooZHMg2aQUwlDTbjxyfTsOqU27mlkSg9ej0cTf8X8ltSl0aoPoabNk8pE8DpsAO5w2ULAxImvnHO3QlOLyDVB+k4eM13XsU2cRBipUK+5AYZxR+ySc+rh6nMXajd9tt2G6wAMynmDwz0LfAGlhVQUNpsPyRIOa9ZLCbbBFVH9lBeTqYydis4mn/NapRsn3f2KNoBlxEDxFlSukcR2TrLEpUez8wEfFbq9nNvOIfhGZjjUP96Mgrsw71MEs/6Z5k9E+gL9K/QBpS9gVjEw5NCuVXitE3IAbUCQE/fh/F9jjChwFH+AfrFNzKy3gINcWun8vj5G5mqft3apiWJfGD3LLftDrKCV7WIHcX2umJvJyIsNuuevVPVP7zRO7dDVKiZfIDX+gUeNG3ObR4ATsvQ/kDlv0PJ7KZTFcuawVo1jeknjuCduRBfOJecUkl61NA992rE6tOGmkC8NE+C/kKQiHNkCQv/zZreGvH5yQu1xlkUxyugaJN0Rhv60C3u7xsrI3o4GUDGg5+/he1MEih+NAsYSEnAUim+r78F9mwalhETBg3BnvQZ8HGzAtU6/3HKc6sJYix4evVcd361DBwXMvD/Q+SLzfRUjq48oqnxzdsj5hlHFKk7fEkV/oXvVIikVtzIYta5DodfvO8x+1nH0aJLPQ==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(1800799024)(82310400026)(14060799003)(376014)(35042699022)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	hWB+SbFH1yXQUbduXkaiG+Cjm7oUVhPDLZ5+/uBM/AR8bCffQgB19WeyaM0ofKZErmI2mlybbURqmLb79ABZv++PwAI50NTMLpWgKacZHFANucvK66SmTF+oAMoxzgcVtz/TDZ/GHdovNpSiksro2B+EIpiVKG7EZsyQtMElwxBouetXfUb9As9Yk61RT2Ku4OyOVYa5lFTH6lAe8CSWsBCej4rhCLSm/hdtaKZwyIw4ihrNHAwxrxpZ2hHqqF59wQ9WrQ3MHqoJDbJQUA1r1InVhIOhOAhK3Yg+Z+b/+hBzYFMpk52Zy3sYAVvsoztrKPpRy1m+pHHH3/Oqm14qbeSYfn+nk6PYNZ79LoB+i0BUZFN5qr4oK7P51DSlNd2YfKfZOrRCqLET0owdDa07svtiSzAqX+bCm/Vjkpt3dC+TESWaxR2g4SQVvUNjdIuD
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2026 11:45:11.5596
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 121eae23-9ec6-43b2-2a7f-08de841aa5ac
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF00000197.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR08MB10771

This change introduces GICv5 load/put. Additionally, it plumbs in
save/restore for:

* PPIs (ICH_PPI_x_EL2 regs)
* ICH_VMCR_EL2
* ICH_APR_EL2
* ICC_ICSR_EL1

A GICv5-specific enable bit is added to struct vgic_vmcr as this
differs from previous GICs. On GICv5-native systems, the VMCR only
contains the enable bit (driven by the guest via ICC_CR0_EL1.EN) and
the priority mask (PCR).

A struct gicv5_vpe is also introduced. This currently only contains a
single field - bool resident - which is used to track if a VPE is
currently running or not, and is used to avoid a case of double load
or double put on the WFI path for a vCPU. This struct will be extended
as additional GICv5 support is merged, specifically for VPE doorbells.

Co-authored-by: Timothy Hayes <timothy.hayes@arm.com>
Signed-off-by: Timothy Hayes <timothy.hayes@arm.com>
Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
---
 arch/arm64/kvm/hyp/nvhe/switch.c   | 12 +++++
 arch/arm64/kvm/vgic/vgic-mmio.c    | 40 +++++++++++++---
 arch/arm64/kvm/vgic/vgic-v5.c      | 74 ++++++++++++++++++++++++++++++
 arch/arm64/kvm/vgic/vgic.c         | 74 ++++++++++++++++++++++++------
 arch/arm64/kvm/vgic/vgic.h         |  7 +++
 include/kvm/arm_vgic.h             |  2 +
 include/linux/irqchip/arm-gic-v5.h |  5 ++
 7 files changed, 193 insertions(+), 21 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/swi=
tch.c
index b41485ce295ab..a88da302b6d08 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -113,6 +113,12 @@ static void __deactivate_traps(struct kvm_vcpu *vcpu)
 /* Save VGICv3 state on non-VHE systems */
 static void __hyp_vgic_save_state(struct kvm_vcpu *vcpu)
 {
+	if (vgic_is_v5(kern_hyp_va(vcpu->kvm))) {
+		__vgic_v5_save_state(&vcpu->arch.vgic_cpu.vgic_v5);
+		__vgic_v5_save_ppi_state(&vcpu->arch.vgic_cpu.vgic_v5);
+		return;
+	}
+
 	if (static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif)) {
 		__vgic_v3_save_state(&vcpu->arch.vgic_cpu.vgic_v3);
 		__vgic_v3_deactivate_traps(&vcpu->arch.vgic_cpu.vgic_v3);
@@ -122,6 +128,12 @@ static void __hyp_vgic_save_state(struct kvm_vcpu *vcp=
u)
 /* Restore VGICv3 state on non-VHE systems */
 static void __hyp_vgic_restore_state(struct kvm_vcpu *vcpu)
 {
+	if (vgic_is_v5(kern_hyp_va(vcpu->kvm))) {
+		__vgic_v5_restore_state(&vcpu->arch.vgic_cpu.vgic_v5);
+		__vgic_v5_restore_ppi_state(&vcpu->arch.vgic_cpu.vgic_v5);
+		return;
+	}
+
 	if (static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif)) {
 		__vgic_v3_activate_traps(&vcpu->arch.vgic_cpu.vgic_v3);
 		__vgic_v3_restore_state(&vcpu->arch.vgic_cpu.vgic_v3);
diff --git a/arch/arm64/kvm/vgic/vgic-mmio.c b/arch/arm64/kvm/vgic/vgic-mmi=
o.c
index a573b1f0c6cbe..74d76dec97304 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio.c
@@ -842,18 +842,46 @@ vgic_find_mmio_region(const struct vgic_register_regi=
on *regions,
=20
 void vgic_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr)
 {
-	if (kvm_vgic_global_state.type =3D=3D VGIC_V2)
-		vgic_v2_set_vmcr(vcpu, vmcr);
-	else
+	const struct vgic_dist *dist =3D &vcpu->kvm->arch.vgic;
+
+	switch (dist->vgic_model) {
+	case KVM_DEV_TYPE_ARM_VGIC_V5:
+		vgic_v5_set_vmcr(vcpu, vmcr);
+		break;
+	case KVM_DEV_TYPE_ARM_VGIC_V3:
 		vgic_v3_set_vmcr(vcpu, vmcr);
+		break;
+	case KVM_DEV_TYPE_ARM_VGIC_V2:
+		if (static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
+			vgic_v3_set_vmcr(vcpu, vmcr);
+		else
+			vgic_v2_set_vmcr(vcpu, vmcr);
+		break;
+	default:
+		BUG();
+	}
 }
=20
 void vgic_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr)
 {
-	if (kvm_vgic_global_state.type =3D=3D VGIC_V2)
-		vgic_v2_get_vmcr(vcpu, vmcr);
-	else
+	const struct vgic_dist *dist =3D &vcpu->kvm->arch.vgic;
+
+	switch (dist->vgic_model) {
+	case KVM_DEV_TYPE_ARM_VGIC_V5:
+		vgic_v5_get_vmcr(vcpu, vmcr);
+		break;
+	case KVM_DEV_TYPE_ARM_VGIC_V3:
 		vgic_v3_get_vmcr(vcpu, vmcr);
+		break;
+	case KVM_DEV_TYPE_ARM_VGIC_V2:
+		if (static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
+			vgic_v3_get_vmcr(vcpu, vmcr);
+		else
+			vgic_v2_get_vmcr(vcpu, vmcr);
+		break;
+	default:
+		BUG();
+	}
 }
=20
 /*
diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index cf8382a954bbc..41317e1d94a2f 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -86,3 +86,77 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
=20
 	return 0;
 }
+
+void vgic_v5_load(struct kvm_vcpu *vcpu)
+{
+	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+
+	/*
+	 * On the WFI path, vgic_load is called a second time. The first is when
+	 * scheduling in the vcpu thread again, and the second is when leaving
+	 * WFI. Skip the second instance as it serves no purpose and just
+	 * restores the same state again.
+	 */
+	if (cpu_if->gicv5_vpe.resident)
+		return;
+
+	kvm_call_hyp(__vgic_v5_restore_vmcr_apr, cpu_if);
+
+	cpu_if->gicv5_vpe.resident =3D true;
+}
+
+void vgic_v5_put(struct kvm_vcpu *vcpu)
+{
+	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+
+	/*
+	 * Do nothing if we're not resident. This can happen in the WFI path
+	 * where we do a vgic_put in the WFI path and again later when
+	 * descheduling the thread. We risk losing VMCR state if we sync it
+	 * twice, so instead return early in this case.
+	 */
+	if (!cpu_if->gicv5_vpe.resident)
+		return;
+
+	kvm_call_hyp(__vgic_v5_save_apr, cpu_if);
+
+	cpu_if->gicv5_vpe.resident =3D false;
+}
+
+void vgic_v5_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcrp)
+{
+	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+	u64 vmcr =3D cpu_if->vgic_vmcr;
+
+	vmcrp->en =3D FIELD_GET(FEAT_GCIE_ICH_VMCR_EL2_EN, vmcr);
+	vmcrp->pmr =3D FIELD_GET(FEAT_GCIE_ICH_VMCR_EL2_VPMR, vmcr);
+}
+
+void vgic_v5_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcrp)
+{
+	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+	u64 vmcr;
+
+	vmcr =3D FIELD_PREP(FEAT_GCIE_ICH_VMCR_EL2_VPMR, vmcrp->pmr) |
+	       FIELD_PREP(FEAT_GCIE_ICH_VMCR_EL2_EN, vmcrp->en);
+
+	cpu_if->vgic_vmcr =3D vmcr;
+}
+
+void vgic_v5_restore_state(struct kvm_vcpu *vcpu)
+{
+	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+
+	__vgic_v5_restore_state(cpu_if);
+	__vgic_v5_restore_ppi_state(cpu_if);
+	dsb(sy);
+}
+
+void vgic_v5_save_state(struct kvm_vcpu *vcpu)
+{
+	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+
+	__vgic_v5_save_state(cpu_if);
+	__vgic_v5_save_ppi_state(cpu_if);
+	dsb(sy);
+}
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index d95fbf20002f4..6df03d0d55078 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -1028,7 +1028,10 @@ static inline bool can_access_vgic_from_kernel(void)
=20
 static inline void vgic_save_state(struct kvm_vcpu *vcpu)
 {
-	if (!static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
+	/* No switch statement here. See comment in vgic_restore_state() */
+	if (vgic_is_v5(vcpu->kvm))
+		vgic_v5_save_state(vcpu);
+	else if (!static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
 		vgic_v2_save_state(vcpu);
 	else
 		__vgic_v3_save_state(&vcpu->arch.vgic_cpu.vgic_v3);
@@ -1037,14 +1040,16 @@ static inline void vgic_save_state(struct kvm_vcpu =
*vcpu)
 /* Sync back the hardware VGIC state into our emulation after a guest's ru=
n. */
 void kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu)
 {
-	/* If nesting, emulate the HW effect from L0 to L1 */
-	if (vgic_state_is_nested(vcpu)) {
-		vgic_v3_sync_nested(vcpu);
-		return;
-	}
+	if (vgic_is_v3(vcpu->kvm)) {
+		/* If nesting, emulate the HW effect from L0 to L1 */
+		if (vgic_state_is_nested(vcpu)) {
+			vgic_v3_sync_nested(vcpu);
+			return;
+		}
=20
-	if (vcpu_has_nv(vcpu))
-		vgic_v3_nested_update_mi(vcpu);
+		if (vcpu_has_nv(vcpu))
+			vgic_v3_nested_update_mi(vcpu);
+	}
=20
 	if (can_access_vgic_from_kernel())
 		vgic_save_state(vcpu);
@@ -1066,7 +1071,18 @@ void kvm_vgic_process_async_update(struct kvm_vcpu *=
vcpu)
=20
 static inline void vgic_restore_state(struct kvm_vcpu *vcpu)
 {
-	if (!static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
+	/*
+	 * As nice as it would be to restructure this code into a switch
+	 * statement as can be found elsewhere, the logic quickly gets ugly.
+	 *
+	 * __vgic_v3_restore_state() is doing a lot of heavy lifting here. It is
+	 * required for GICv3-on-GICv3, GICv2-on-GICv3, GICv3-on-GICv5, and the
+	 * no-in-kernel-irqchip case on GICv3 hardware. Hence, adding a switch
+	 * here results in much more complex code.
+	 */
+	if (vgic_is_v5(vcpu->kvm))
+		vgic_v5_restore_state(vcpu);
+	else if (!static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
 		vgic_v2_restore_state(vcpu);
 	else
 		__vgic_v3_restore_state(&vcpu->arch.vgic_cpu.vgic_v3);
@@ -1120,30 +1136,58 @@ void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu)
=20
 void kvm_vgic_load(struct kvm_vcpu *vcpu)
 {
+	const struct vgic_dist *dist =3D &vcpu->kvm->arch.vgic;
+
 	if (unlikely(!irqchip_in_kernel(vcpu->kvm) || !vgic_initialized(vcpu->kvm=
))) {
 		if (has_vhe() && static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpu=
if))
 			__vgic_v3_activate_traps(&vcpu->arch.vgic_cpu.vgic_v3);
 		return;
 	}
=20
-	if (!static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
-		vgic_v2_load(vcpu);
-	else
+	switch (dist->vgic_model) {
+	case KVM_DEV_TYPE_ARM_VGIC_V5:
+		vgic_v5_load(vcpu);
+		break;
+	case KVM_DEV_TYPE_ARM_VGIC_V3:
 		vgic_v3_load(vcpu);
+		break;
+	case KVM_DEV_TYPE_ARM_VGIC_V2:
+		if (static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
+			vgic_v3_load(vcpu);
+		else
+			vgic_v2_load(vcpu);
+		break;
+	default:
+		BUG();
+	}
 }
=20
 void kvm_vgic_put(struct kvm_vcpu *vcpu)
 {
+	const struct vgic_dist *dist =3D &vcpu->kvm->arch.vgic;
+
 	if (unlikely(!irqchip_in_kernel(vcpu->kvm) || !vgic_initialized(vcpu->kvm=
))) {
 		if (has_vhe() && static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpu=
if))
 			__vgic_v3_deactivate_traps(&vcpu->arch.vgic_cpu.vgic_v3);
 		return;
 	}
=20
-	if (!static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
-		vgic_v2_put(vcpu);
-	else
+	switch (dist->vgic_model) {
+	case KVM_DEV_TYPE_ARM_VGIC_V5:
+		vgic_v5_put(vcpu);
+		break;
+	case KVM_DEV_TYPE_ARM_VGIC_V3:
 		vgic_v3_put(vcpu);
+		break;
+	case KVM_DEV_TYPE_ARM_VGIC_V2:
+		if (static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
+			vgic_v3_put(vcpu);
+		else
+			vgic_v2_put(vcpu);
+		break;
+	default:
+		BUG();
+	}
 }
=20
 int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu)
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index 7b7eed69d7973..cc487a69d0389 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -187,6 +187,7 @@ static inline u64 vgic_ich_hcr_trap_bits(void)
  * registers regardless of the hardware backed GIC used.
  */
 struct vgic_vmcr {
+	u32	en; /* GICv5-specific */
 	u32	grpen0;
 	u32	grpen1;
=20
@@ -363,6 +364,12 @@ void vgic_debug_init(struct kvm *kvm);
 void vgic_debug_destroy(struct kvm *kvm);
=20
 int vgic_v5_probe(const struct gic_kvm_info *info);
+void vgic_v5_load(struct kvm_vcpu *vcpu);
+void vgic_v5_put(struct kvm_vcpu *vcpu);
+void vgic_v5_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
+void vgic_v5_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
+void vgic_v5_restore_state(struct kvm_vcpu *vcpu);
+void vgic_v5_save_state(struct kvm_vcpu *vcpu);
=20
 static inline int vgic_v3_max_apr_idx(struct kvm_vcpu *vcpu)
 {
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 07e394690dccb..b27bfc463a311 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -447,6 +447,8 @@ struct vgic_v5_cpu_if {
 	 * it is the hyp's responsibility to keep the state constistent.
 	 */
 	u64	vgic_icsr;
+
+	struct gicv5_vpe gicv5_vpe;
 };
=20
 /* What PPI capabilities does a GICv5 host have */
diff --git a/include/linux/irqchip/arm-gic-v5.h b/include/linux/irqchip/arm=
-gic-v5.h
index b1566a7c93ecb..40d2fce682940 100644
--- a/include/linux/irqchip/arm-gic-v5.h
+++ b/include/linux/irqchip/arm-gic-v5.h
@@ -387,6 +387,11 @@ int gicv5_spi_irq_set_type(struct irq_data *d, unsigne=
d int type);
 int gicv5_irs_iste_alloc(u32 lpi);
 void gicv5_irs_syncr(void);
=20
+/* Embedded in kvm.arch */
+struct gicv5_vpe {
+	bool			resident;
+};
+
 struct gicv5_its_devtab_cfg {
 	union {
 		struct {
--=20
2.34.1
