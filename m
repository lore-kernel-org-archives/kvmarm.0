Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010016.outbound.protection.outlook.com [52.101.69.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D438F38837A
	for <kvmarm@lists.linux.dev>; Tue, 11 Aug 2026 15:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.16
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786460667; cv=fail; b=ib9thmHETuVEsnDoozxK/LWZsw2zyk1Cs0Vh3oKfQv2rC5rS2uOUg/2rsGruyxEGWyHbW24PHZro4VUzGikIifRBRmH5MFH4EjR+AtRc4oItWcrb37nSrMryj3tfi7f6bL46w0IglI/caYcXGCDpPcMo35agEeoO/W8KrNRB2LI=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786460667; c=relaxed/simple;
	bh=n+0WC6pzHwSG5fEnlCqWUyQUPO7zdCYZ/jFCUdRiAGY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=PyOq/ssVy9aTZsz+KkdwwTKBmFDzz4TXSARqTGVrDFr+fJ8w0EH7SGNwTshLwI3t9X4ILWFPkMWH8aEZGUURAmYm9Fjvhjviq2Ie25ZQfGliL2Qqc3LRTuW/IPSGXyg/XDGmHeUEbRWu1QjlRY4EbZqv2beuL3yj7tPfec9y8ys=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=mBue9C2D; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=mBue9C2D; arc=fail smtp.client-ip=52.101.69.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="mBue9C2D";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="mBue9C2D"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=feoThaa8jWot6ERNf9SHxFiYg26GbOKyxs835WE3kHRHS2yzsMUHYRq4+r5Nlik8NCKzpdiIUAVakbq4qgCWjMnHVP3bGP+96FBEjdDkoyaTp00od8g23PxraBKq6J2d22xiLcnk/cMY6knbP4H+42Jd2cinTiv9NyneqDcqWI+B+xkSBfo5T3O4xCuDohwQ82C1dXoXKtaeyMsooF2+WNyQwp82PYa2rbujCuSHSQ3ywEQdrSMHWM5+FEO/L5WG+73e7r8CGGVyfAtfPR3k9JC+Y0kLLUTTFhn2YWahKCyZPj6xecSE1atAjFPCaKZfozEJitTMHNJYDZ+N99kseQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n+0WC6pzHwSG5fEnlCqWUyQUPO7zdCYZ/jFCUdRiAGY=;
 b=bAYesoZCW7g57F6EqFLhNuyDC/kyPnHV3geewbndNlBE/o7UVpQ+3iG3u1pViZBGeuqNtZN3OVYJ/oRs28RTuVmQ+RcZAPrxd/ZnCI7b9Ru0f3uYg5NhayTVzKdElIUxbAl2z7gl6qMQZ6RL+Cv4a+jMcI+pDyuUf+z61k2YT4VjXimdymNavywsdFTQyL5L4cLJGOaB54TVsrLlBC/ycCzT4P50ClxoSYid2zm9ZbqVFa2oKHmAr7OQsqHIq33bfsnRr6g9ATt5veSutQyHbGyjUPV5hj54j4jXIr7XD6mH7tpad4F4qMem3FAtPxYKVpKCY4e67CsHYtZw7vPY/A==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n+0WC6pzHwSG5fEnlCqWUyQUPO7zdCYZ/jFCUdRiAGY=;
 b=mBue9C2DSu60V+5BVSjaSTThDZQ7maQh9ghN28Gs3nWw8NJEfOsVPtpSHHyJX80IhI6NovYYihcYxPHuIoHkPbsD9+htKhU6SqLOhNpvZSC803dm4zFR881Kpj1F5Csvt2QZ1QufRmy8MzcIQbzeDFcmLwwFBTPWxm8m5HIHKDs=
Received: from DB8PR06CA0056.eurprd06.prod.outlook.com (2603:10a6:10:120::30)
 by DU5PR08MB10636.eurprd08.prod.outlook.com (2603:10a6:10:523::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.25; Tue, 11 Aug
 2026 15:04:21 +0000
Received: from DB1PEPF000509EB.eurprd03.prod.outlook.com
 (2603:10a6:10:120:cafe::47) by DB8PR06CA0056.outlook.office365.com
 (2603:10a6:10:120::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.315.11 via Frontend Transport; Tue,
 11 Aug 2026 15:04:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509EB.mail.protection.outlook.com (10.167.242.69) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.315.6
 via Frontend Transport; Tue, 11 Aug 2026 15:04:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Lg7PkgyW2kdN8RYSnRtwbElFqS2H5/e8HQHjNYsVhkTUrnUPcAqB3i3ti6e4hgifLB5Cq2f9pqWNq49cRLdr4VygqkkLlpvtbdH1ytRgzBNWjTd6n6RyQk7OQ9m+zVZYyzF7XqofVxx6l+FSeHAJDU6nH4FglVVC4PPntJEEgfzchsCMXtMijrE9bn9SLQvuAlX9k/75PHnzr34GH8zrf4X1ZmKa8EAV0B0edbsDya+nCap+ERXUWrfsjJ5S7t4Y2ghkbxCqnUvrREWVrr371REXttINc7LwP2KehxnQzFJd0Owjvf4BJoevMCSAnnvzFZAVT8qq841P9ZV+5Qr95w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n+0WC6pzHwSG5fEnlCqWUyQUPO7zdCYZ/jFCUdRiAGY=;
 b=p+cBGfV3dKvDUl4tlCknPieRkLbcq5YGbWXI7jSOs1cqQGpfcJlSw4ANZUy466QvbiTQTGi6TQu0JodnijRkpWjQpqbAgojGOiQJRkCiqfh89KpywjvrEwlsfMrg1+nC2nLiZJG17lFRz4cb+MoGd7WHKdlqg0+mcRYYzpOdpcoMIwc+ibyUY/eUNAPyvQdV7LeXN+p7v447FTiObXHFrSaGErO3Yl6VRD0Tr1/UqE/VCghtTbe4rYx30GBj1TgcqUI973Dp5VS4QyJpn7BXEd2ZEGXbfK61KBidpqMqKbfsQ+oPPMWCXj/CGeL5KZfVdKlhOG+7dRuWNHLY48qrwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n+0WC6pzHwSG5fEnlCqWUyQUPO7zdCYZ/jFCUdRiAGY=;
 b=mBue9C2DSu60V+5BVSjaSTThDZQ7maQh9ghN28Gs3nWw8NJEfOsVPtpSHHyJX80IhI6NovYYihcYxPHuIoHkPbsD9+htKhU6SqLOhNpvZSC803dm4zFR881Kpj1F5Csvt2QZ1QufRmy8MzcIQbzeDFcmLwwFBTPWxm8m5HIHKDs=
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com (2603:10a6:10:407::19)
 by AM7PR08MB5413.eurprd08.prod.outlook.com (2603:10a6:20b:10a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.11; Tue, 11 Aug
 2026 15:03:48 +0000
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e]) by DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e%6]) with mapi id 15.21.0315.008; Tue, 11 Aug 2026
 15:03:48 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "lpieralisi@kernel.org" <lpieralisi@kernel.org>
CC: "yuzenghui@huawei.com" <yuzenghui@huawei.com>, Suzuki Poulose
	<Suzuki.Poulose@arm.com>, nd <nd@arm.com>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "oupton@kernel.org" <oupton@kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, Joey Gouly <Joey.Gouly@arm.com>, "maz@kernel.org"
	<maz@kernel.org>
Subject: Re: [PATCH 2/5] irqchip/gic-v5: Clear per-CPU IRS data on teardown
Thread-Topic: [PATCH 2/5] irqchip/gic-v5: Clear per-CPU IRS data on teardown
Thread-Index: AQHdKLLvPsM/2AW83keL+Q+aPyfjVraXJ4QAgAHMToA=
Date: Tue, 11 Aug 2026 15:03:48 +0000
Message-ID: <3ca3458f7215c0e1d68657a2a1b2677ec8522fbb.camel@arm.com>
References: <20260810102652.758719-1-sascha.bischoff@arm.com>
	 <20260810102652.758719-3-sascha.bischoff@arm.com>
	 <anm3snqnGHcqUogW@red-moon>
In-Reply-To: <anm3snqnGHcqUogW@red-moon>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU0PR08MB8421:EE_|AM7PR08MB5413:EE_|DB1PEPF000509EB:EE_|DU5PR08MB10636:EE_
X-MS-Office365-Filtering-Correlation-Id: c8a41fdd-d48c-41d3-ddd2-08def7b9d284
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|23010399003|366016|1800799024|6133799003|10067099003|56012099006|11063799006|4143699003|22082099003|18002099003|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 H9+ZkczKxszcUBveLoyxPsWCrDEnYHPFTCk6lpyG/BhMhQX1q/dvXJbID/C+9EuWCVTN3yNqAVRpN2wdhUxuCWKq8UoR/XVCc9oMGsfuzno6f0n/rDQBCF2h9NhREsOOiHZefXKBr4/JcFrwzx6aq95LmNBmj7fAynVB6Jg1gqIRM58/ycWAY0f8/pKA3vuC+JaaXrRoawVP+G8YKSFty0gAtFmvw9/+a1CC1h51VpzVxnwhzk16VviDPNzXRIgIb413fZN116+dzvNbUyfY6yx+9BZUW2PLRttiIiw6BPgYnG2ivcZG1BjNnnHFstppY0eStkgxIC0gC1B51mmlAEF/Tn5KQ3SS27AUPRR8DJsj7sBzXoWXGQqj7gnWfcS3smvwJTGlINlTVbidHX97fqFjB1vdHgAyCDKniEaDEVXIhUijR3vvW5wncA7j/XKqaoR1OeTmIt5ab2UIGPMduKsHOtXdgtzsVn1iWwMM0ukdMEsjk1Sbm+5VP4NxWdLqwWcMaOsvGD+iVw24bScs8gQ21R0nGEfeMYb57t6hxvxGeEirE7soJ36GrNsXxnx0SxqO6nUAJRs6qu6kYaakwEc4ZiZBFxoQdVvzX//jWyh5lAG4R48wtpMMF+HWcdyqR1QV8Znbpc2AWSz0/W7nj6s+Loi5fnfnZ8YHIadF4uI=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB8421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(366016)(1800799024)(6133799003)(10067099003)(56012099006)(11063799006)(4143699003)(22082099003)(18002099003)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <2427B0764BF18A48A2CABF12A1245224@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 Yj9qmuVoDrS752Pvphsz9F9SaHC63pGtJLf5x7gQXOHGUqZXEGerVXKD1u9EY+6KS2cX1f1sJD+P1cTFpfMIB3gVOG68Sc3rhqdoouLl1K6GB5VegV0PvTi+0MYcOaOgYPRdtAw4xEuUlEwUBD31fawf8LFyWS8N5nu+DOcz5vjUZpGRxwguHiDSdlIiKcAoAhoGLlW8P4hgpEUY+slsG4EevOIH4yecjHL5ISjWwRR80hqCIdIf/91TzL/kHc6H6+46uOMyOeRJTQhCqzg4/MGwSq8OT+LSs0oJ8CMxyk7GEcxjjS/Uz9Sab/TJpNnePz4E9dw+a91iHa27e+U+pQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR08MB5413
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509EB.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	88dc62cb-7ae1-40c0-e72f-08def7b9bf2c
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|35042699022|1800799024|23010399003|82310400026|14060799003|36860700016|13003099007|6133799003|4143699003|56012099006|10067099003|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	l/qf8oIxx9EO9ffsmHY295/Nfp8GfI/tvKq8vJw1htQSVkf5hLf31vaAztkd7mx611FWzgc2wJ8MNRyGNtKQjxM6cSfG8wYCvwaeQhcdaKEox9xHLX0S2rphr3NtTnqj3TEb+/o+uamFX3gXtyd0JI2A8q7rOCrjR6Se6/+3mKz7Yt1rjJEClxkSw1jTXrbLaOOKGDg9BwEi3i28LNX4L1X1OnothnJcHx2n3WhYNleBW55xaz3CpAByFC3e14wNu/BSs9GV8u8gXyG5AARScaX7Mi5uf5kO5Ea7n+XHKNFAswbVWTf5U5GxidRNZDigZm1eRL95EP/IZ9G03W3hVXIM442SgKZiLlA+wc/DrAG8xNAToMX1uTttTp6bLHoRaD0/LknPRZnBGjh9qL4AREP6mF8CVur9wUtitjVwn8u1BbAKI9rCzXs2WtjCAQZoJ3WByHMP2tEI4jeXGEVDVueuIhoMRULfSUcwafoN3m9fmO0mcWs+lcIpFdH45UZiGmstUJUgoINFrDxSr4EYArGztNQkXVXMXajLw1b4FC/hTW0JzwvRDO1Q+l1Whh7LvcAPCWEFtItq9PVwyp2fiL4vvpNydn2Mw50gQjTP69BLVM6a1QIBg8T5gDFi25zzG9N0Ikc8lOj0DE801/3u0Q==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(35042699022)(1800799024)(23010399003)(82310400026)(14060799003)(36860700016)(13003099007)(6133799003)(4143699003)(56012099006)(10067099003)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	DpMOB+z7F/V0cklwGFRWNOcXz3X0do7t/OVvT+1vT8St7kaoQhoWM2FttU8OMJuo7CAVfKkVgSiFikMkLCgh/rBI2R3mk+54d1qnU8T0+s+/a4r10/xkod4d67QmJVgX70Kiswmoj+2MA5hnrMK8LfA3kerTqxGs7xUTE8m1oT22ysrsIHuHB04zr9mx1+mfVDtYwrtjlvRiDaFlM6NeP6WkA7oNcVQJTguaeYOGYr1+7QhxSHURvG5Vg6TEC3Kx6fELPmj05wzj8LSxu6xTMdPx33RzqiJUOP3AhGBscrMj5QC1swu/wdj4cI1okpUCYhGblSBBZmg0HkvT+66y6cKt35oZKuIz4PCYBfYNyKr69olXRNzntPR/KjF92lAiJBMsKvASfpiv3iTuCHlA8ZElklJt1kUc14HcOvfv2OR8L2AcN9/3+OcOXtjRlW8L
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2026 15:04:20.4991
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c8a41fdd-d48c-41d3-ddd2-08def7b9d284
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509EB.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU5PR08MB10636

T24gTW9uLCAyMDI2LTA4LTEwIGF0IDEzOjM2ICswMjAwLCBMb3JlbnpvIFBpZXJhbGlzaSB3cm90
ZToNCj4gT24gTW9uLCBBdWcgMTAsIDIwMjYgYXQgMTA6Mjg6MDdBTSArMDAwMCwgU2FzY2hhIEJp
c2Nob2ZmIHdyb3RlOg0KPiA+IElSUyBhZmZpbml0eSBzZXR1cCBwdWJsaXNoZXMgYW4gSVJTIHBv
aW50ZXIgYW5kIElBRkZJRCBzdGF0ZSBpbiB0aGUNCj4gPiBwZXItQ1BVIGRhdGEgYmVmb3JlIHRo
ZSByZW1haW5pbmcgSVJTIGluaXRpYWxpemF0aW9uIGNhbiBmYWlsLiBUaGUNCj4gPiBlcnJvciBw
YXRoIHRoZW4gZnJlZXMgdGhlIElSUyBkYXRhIHdpdGhvdXQgY2xlYXJpbmcgdGhhdCBwdWJsaXNo
ZWQNCj4gPiBzdGF0ZSwgbGVhdmluZyBDUFVzIGFzc29jaWF0ZWQgd2l0aCBmcmVlZCBtZW1vcnku
DQo+ID4gDQo+ID4gT24gaW5pdGlhbGl6YXRpb24gZmFpbHVyZSBhbmQgbm9ybWFsIElSUyB0ZWFy
ZG93biwgY2xlYXIgdGhlIHBlci0NCj4gPiBDUFUNCj4gPiBJUlMgYXNzb2NpYXRpb24gYnkgcmVt
b3ZpbmcgdGhlIHN0YWxlIHBvaW50ZXIgdG8gaXJzX2RhdGEuIEFsc28NCj4gPiBjbGVhcg0KPiA+
IHRoZSBwZXItQ1BVIElBRkZJRCBzdGF0ZSBmb3IgYW55IENQVXMgdGhhdCB3ZXJlIHRpZWQgdG8g
dGhlIElSUw0KPiA+IGJlZm9yZQ0KPiA+IGl0IHdhcyBmcmVlZC4NCj4gPiANCj4gPiBGaXhlczog
NWNiMWI2ZGFiMmRlICgiaXJxY2hpcC9naWMtdjU6IEFkZCBHSUN2NSBJUlMvU1BJIHN1cHBvcnQi
KQ0KPiA+IEZpeGVzOiAzNTg2NmVmYTUyZmUgKCJpcnFjaGlwL2dpYy12NTogQWRkIEFDUEkgSVJT
IHByb2JpbmciKQ0KPiA+IExpbms6DQo+ID4gaHR0cHM6Ly9zYXNoaWtvLmRldi8jL3BhdGNoc2V0
LzIwMjYwNzI0MTA0ODE5LjEyOTY4MDMtMS1zYXNjaGEuYmlzY2hvZmZAYXJtLmNvbT9wYXJ0PTIN
Cj4gPiBTaWduZWQtb2ZmLWJ5OiBTYXNjaGEgQmlzY2hvZmYgPHNhc2NoYS5iaXNjaG9mZkBhcm0u
Y29tPg0KPiA+IC0tLQ0KPiA+IMKgZHJpdmVycy9pcnFjaGlwL2lycS1naWMtdjUtaXJzLmMgfCAx
NiArKysrKysrKysrKysrKysrDQo+ID4gwqAxIGZpbGUgY2hhbmdlZCwgMTYgaW5zZXJ0aW9ucygr
KQ0KPiANCj4gVGhhbmsgeW91IFNhc2NoYSwgYSBtaW5vciBjb21tZW50IGJlbG93IG90aGVyd2lz
ZToNCj4gDQo+IFJldmlld2VkLWJ5OiBMb3JlbnpvIFBpZXJhbGlzaSA8bHBpZXJhbGlzaUBrZXJu
ZWwub3JnPg0KDQpUaGFua3MhDQoNCj4gDQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvaXJxY2hp
cC9pcnEtZ2ljLXY1LWlycy5jDQo+ID4gYi9kcml2ZXJzL2lycWNoaXAvaXJxLWdpYy12NS1pcnMu
Yw0KPiA+IGluZGV4IGYzZmNlMGIxZTI1ZDkuLjY3OTQwZWE5ZTM5YjcgMTAwNjQ0DQo+ID4gLS0t
IGEvZHJpdmVycy9pcnFjaGlwL2lycS1naWMtdjUtaXJzLmMNCj4gPiArKysgYi9kcml2ZXJzL2ly
cWNoaXAvaXJxLWdpYy12NS1pcnMuYw0KPiA+IEBAIC02NTEsNiArNjUxLDE5IEBAIHN0YXRpYyBp
bnQgX19pbml0DQo+ID4gZ2ljdjVfaXJzX29mX2luaXRfYWZmaW5pdHkoc3RydWN0IGRldmljZV9u
b2RlICpub2RlLA0KPiA+IMKgCXJldHVybiByZXQ7DQo+ID4gwqB9DQo+ID4gwqANCj4gPiArc3Rh
dGljIHZvaWQgX19pbml0IGdpY3Y1X2lyc19jbGVhcl9hZmZpbml0eShzdHJ1Y3QNCj4gPiBnaWN2
NV9pcnNfY2hpcF9kYXRhICppcnNfZGF0YSkNCj4gPiArew0KPiA+ICsJaW50IGNwdTsNCj4gPiAr
DQo+ID4gKwlmb3JfZWFjaF9wb3NzaWJsZV9jcHUoY3B1KSB7DQo+ID4gKwkJaWYgKHBlcl9jcHUo
cGVyX2NwdV9pcnNfZGF0YSwgY3B1KSA9PSBpcnNfZGF0YSkgew0KPiA+ICsJCQlwZXJfY3B1KGNw
dV9pYWZmaWQsIGNwdSkuaWFmZmlkID0gMDsNCj4gDQo+IEFzIGxvbmcgd2Ugc2V0IHZhbGlkIHRv
IGZhbHNlIHRoaXMgaXMgbm90IG5lY2Vzc2FyaWx5IG5lZWRlZCwgMCBpcyBhDQo+IHZhbGlkDQo+
IHZhbHVlLg0KDQpUaGFua3MsIExvcmVuem8uIFRoYXQncyBhIGdvb2QgcG9pbnQuIEkndmUgZHJv
cHBlZCB0aGUgc2V0dGluZyBvZg0KaWFmZmlkIHRvIDAgYXMgbWFya2luZyBpdCBhcyBpbnZhbGlk
IHNob3VsZCBiZSBzdWZmaWNpZW50Lg0KDQpTYXNjaGENCg0KPiANCj4gVGhhbmtzLA0KPiBMb3Jl
bnpvDQo+IA0KPiA+ICsJCQlwZXJfY3B1KGNwdV9pYWZmaWQsIGNwdSkudmFsaWQgPSBmYWxzZTsN
Cj4gPiArCQkJcGVyX2NwdShwZXJfY3B1X2lyc19kYXRhLCBjcHUpID0gTlVMTDsNCj4gPiArCQl9
DQo+ID4gKwl9DQo+ID4gK30NCj4gPiArDQo+ID4gwqBzdGF0aWMgdm9pZCBpcnNfc2V0dXBfcHJp
X2JpdHModTMyIGlkcjEpDQo+ID4gwqB7DQo+ID4gwqAJc3dpdGNoIChGSUVMRF9HRVQoR0lDVjVf
SVJTX0lEUjFfUFJJT1JJVFlfQklUUywgaWRyMSkpIHsNCj4gPiBAQCAtNzczLDYgKzc4Niw3IEBA
IHN0YXRpYyBpbnQgX19pbml0IGdpY3Y1X2lyc19vZl9pbml0KHN0cnVjdA0KPiA+IGRldmljZV9u
b2RlICpub2RlKQ0KPiA+IMKgCXJldHVybiByZXQ7DQo+ID4gwqANCj4gPiDCoG91dF9pb21lbToN
Cj4gPiArCWdpY3Y1X2lyc19jbGVhcl9hZmZpbml0eShpcnNfZGF0YSk7DQo+ID4gwqAJaW91bm1h
cChpcnNfYmFzZSk7DQo+ID4gwqBvdXRfZXJyOg0KPiA+IMKgCWtmcmVlKGlyc19kYXRhKTsNCj4g
PiBAQCAtNzg3LDYgKzgwMSw3IEBAIHZvaWQgX19pbml0IGdpY3Y1X2lyc19yZW1vdmUodm9pZCkN
Cj4gPiDCoAlnaWN2NV9kZWluaXRfbHBpcygpOw0KPiA+IMKgDQo+ID4gwqAJbGlzdF9mb3JfZWFj
aF9lbnRyeV9zYWZlKGlyc19kYXRhLCB0bXBfZGF0YSwgJmlyc19ub2RlcywNCj4gPiBlbnRyeSkg
ew0KPiA+ICsJCWdpY3Y1X2lyc19jbGVhcl9hZmZpbml0eShpcnNfZGF0YSk7DQo+ID4gwqAJCWlv
dW5tYXAoaXJzX2RhdGEtPmlyc19iYXNlKTsNCj4gPiDCoAkJbGlzdF9kZWwoJmlyc19kYXRhLT5l
bnRyeSk7DQo+ID4gwqAJCWtmcmVlKGlyc19kYXRhKTsNCj4gPiBAQCAtOTUxLDYgKzk2Niw3IEBA
IHN0YXRpYyBpbnQgX19pbml0IGdpY19hY3BpX3BhcnNlX21hZHRfaXJzKHVuaW9uDQo+ID4gYWNw
aV9zdWJ0YWJsZV9oZWFkZXJzICpoZWFkZXIsDQo+ID4gwqAJcmV0dXJuIDA7DQo+ID4gwqANCj4g
PiDCoG91dF9tYXA6DQo+ID4gKwlnaWN2NV9pcnNfY2xlYXJfYWZmaW5pdHkoaXJzX2RhdGEpOw0K
PiA+IMKgCWlvdW5tYXAoaXJzX2Jhc2UpOw0KPiA+IMKgb3V0X3JlbGVhc2U6DQo+ID4gwqAJcmVs
ZWFzZV9tZW1fcmVnaW9uKHItPnN0YXJ0LCByZXNvdXJjZV9zaXplKHIpKTsNCj4gPiAtLSANCj4g
PiAyLjM0LjENCg0K
