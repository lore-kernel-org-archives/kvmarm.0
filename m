Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013063.outbound.protection.outlook.com [40.107.159.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9AC641E6A0
	for <kvmarm@lists.linux.dev>; Fri,  7 Aug 2026 11:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.63
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786102389; cv=fail; b=rd8jIfgIhBcIoUAC4nVV1ElvKlbXdHU4l05mjnK6Kf1WCDHivFRnKf1ScIcxhHGRvrchCBMuwgI3biWnoN2Z22LRKUpdckEM9WOjRFuYuC6oogGD9trwuhePeXJ+u/maUWKML8jpt7FXXaihEjiZQEO/EJgrXm6048o0AGJa4/I=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786102389; c=relaxed/simple;
	bh=2EssrHH7DPMZ7rEL5lTiV11QiKhElSfmkjAhG7+ngU4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=aDa0XuIejl4L0KObbq+nHWo1mnkqkC5Js84UzfuuIqLx+CbhklR2R/TBkH5eo1MzmUsupEiDhfMhMj+sG93ztEbEsncSlxdzs+sroP+9Z11ibT3U11ygfDDRjeU+GIfbxv+PGf2zDSmQB7EZaCIyldf1r79GjCGnMOKEl+ZOs+A=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Dtq7epeR; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Dtq7epeR; arc=fail smtp.client-ip=40.107.159.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Dtq7epeR";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Dtq7epeR"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=VmIAwCdvhZgoqImMtJisEkJKFTSgiAHz3Ce4IPR0pdaGza3z0E8UFQB/B9ilKMvfEAH/JYxfjAFlUxcQU1v4DHSvhgrTWvR24riJK0kf2tMioa/7IIOcKfuILELKZUUW2WOsKuCo4wuCthg93qUZLeCao7/aq0IkhWLIOkSO0v7ggAzlSZCiMOMLXUGEHlyQQhSqyCipLfuLLj4piZ7RyP6jJMc4wWPi1k8OBIKqnp1XKe3nxOaq3fr4fBXdgIn4j6EQo1AdqqGCiHj7pA0BmBfiIftTwujbHpE+48lssx5tBL8QdW62taA6dhmM1+si9NqN7TN/Gqvtc2Ll7AJbqQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iftDyEWHn/jdhEK2DytIW90H45FtgpzzvkNXoTy4Gg0=;
 b=I7hxtB0zAvhkrtnyZu0YBX3D0VRuJPuVI/G8aCQ49RBzHcMHxB7Py9WU046OHC439eTX4RP0E+LRC/HP6GzSkQn2vERK3A3tLrQ06EBK+5cR9LvhWD42YZeuHSAQkWsRfkvyRy+mgSofkhCM3UjVRANoLcFFLqzrYn1CyTR3vLtMVKYQrFAzCK9sgNgGJjeR8PmCBqw0YvxndM6rcbMutoRveMW16ZInID6R94DnqEm3d3gHRSM3Oimt5212s1guKLMV1ym8ysFbxvaEVLl8wpPkJ0AwzpjZhATiET5sLfxgO/OKHI+RB0KkWaHTvMxtz1o0I/jm94pO7nacuhpKOg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iftDyEWHn/jdhEK2DytIW90H45FtgpzzvkNXoTy4Gg0=;
 b=Dtq7epeRResWrbp+gQGyH8eYJibdUNEBOeMaXE3rgIl47Bm/euAIoA8iZt00lQr/It5OfoEsnRgRUUdutuO/DDlZK/q/1wLRWkW/dfjhnuz01pfBBWPuoEmTGdf7l/vxdANszk8v3OAyDTWCFHgEs4jZipoIoMm09N8hOdD+Z+E=
Received: from DU6P191CA0006.EURP191.PROD.OUTLOOK.COM (2603:10a6:10:540::8) by
 DB5PR08MB10286.eurprd08.prod.outlook.com (2603:10a6:10:4a9::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.16; Fri, 7 Aug
 2026 11:33:03 +0000
Received: from DB1PEPF000509FD.eurprd03.prod.outlook.com
 (2603:10a6:10:540:cafe::4c) by DU6P191CA0006.outlook.office365.com
 (2603:10a6:10:540::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.22 via Frontend Transport; Fri, 7
 Aug 2026 11:33:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509FD.mail.protection.outlook.com (10.167.242.39) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.8
 via Frontend Transport; Fri, 7 Aug 2026 11:33:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jvtbO7E9vQAzl4QS7SMLXz8mX764TbFs/oQ4C9W31YvPLXFe2dn14QGto3lpYYOw7waeewvkQvArRoln8IFrEnMmQ+6jXi/THhGc+9agDYp3GHI6iojjA3YJiXv+EZbyhUlMVGoBS7I6IvQrAD+wY0h3rNk+5Qe3IPwtwQHhWPxDVAu1kPuspPfd9rK9c9zqXQwccZFBAWk98J2MQvEOyL+rRveXfOjwZFrbToVwMLpQaKNPgyimmN/cJwfcHoH+GJpePLWEXxPBl3JbXnvuPLNRU2sDXFPASf5OO90M4DGMnVX6AhgO1HhuyoLw5jYRmEAkA5FXyZ65/BW4p6t8VQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iftDyEWHn/jdhEK2DytIW90H45FtgpzzvkNXoTy4Gg0=;
 b=NAOTd6TJgClTH53IhLLiitOSL2KZH8ZLC3/6NNuhPZDspPX+Big4mk6Lm0K3hhiOTJ0IOqiMNzGl9XcdHnsNbhanv1lee3Q/cfdt3xKONnbi/G27Jf2WtKREcHolE7gI5tdjcDdEOUSX7KMyZ5wiuN1BzHqG5NshgyhSFVBQKm5Njf4f9MK91aX3MBkgAcZA8CXEye3k3x4iY+v2TAi0UfYkCJy37gdD/y2qDHIvdzhx8RgchVkx2+ErnESU7K37/RgbXHPpr6AAhQxYUWxVb7cU4KgvvP2JUZwteoHy5dWRNxS5NBiRKH4Jm1YrwlFDX6MfLHnDQEh0AESP/6i+3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iftDyEWHn/jdhEK2DytIW90H45FtgpzzvkNXoTy4Gg0=;
 b=Dtq7epeRResWrbp+gQGyH8eYJibdUNEBOeMaXE3rgIl47Bm/euAIoA8iZt00lQr/It5OfoEsnRgRUUdutuO/DDlZK/q/1wLRWkW/dfjhnuz01pfBBWPuoEmTGdf7l/vxdANszk8v3OAyDTWCFHgEs4jZipoIoMm09N8hOdD+Z+E=
Received: from GV1PR08MB8428.eurprd08.prod.outlook.com (2603:10a6:150:81::5)
 by DU0PR08MB7565.eurprd08.prod.outlook.com (2603:10a6:10:316::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.19; Fri, 7 Aug
 2026 11:32:28 +0000
Received: from GV1PR08MB8428.eurprd08.prod.outlook.com
 ([fe80::9b97:c973:3308:5ba7]) by GV1PR08MB8428.eurprd08.prod.outlook.com
 ([fe80::9b97:c973:3308:5ba7%5]) with mapi id 15.21.0292.018; Fri, 7 Aug 2026
 11:32:28 +0000
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
Subject: [PATCH v5 39/49] Documentation: KVM: Add the VGICv5 IRS save/restore
 sequences
Thread-Topic: [PATCH v5 39/49] Documentation: KVM: Add the VGICv5 IRS
 save/restore sequences
Thread-Index: AQHdJmBtfBCaKJLJsEujAhqEShhz6A==
Date: Fri, 7 Aug 2026 11:32:28 +0000
Message-ID: <20260807111159.429128-40-sascha.bischoff@arm.com>
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
	GV1PR08MB8428:EE_|DU0PR08MB7565:EE_|DB1PEPF000509FD:EE_|DB5PR08MB10286:EE_
X-MS-Office365-Filtering-Correlation-Id: 4e2a7ea8-ace2-4207-cbd1-08def477a46e
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|1800799024|23010399003|376014|10067099003|56012099006|11063799006|6133799003|38070700021|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info-Original:
 9Jp6TVGZ53CVfCPRcPViPSnWfAEioDJgtez4KFQK+hA9CVi+2WCSACDb8g/4Qd6uZXdouhRINSmgpLpTCj6cdHxV9Pdi78hb6VJ99Ij9qqHTcm9ncA7wfNDAtlxtUsg0wN0bflBOaBew5LcTVQb9CF63v0BGcOmjAbmdRYLeUN7D/tAoiAyq/FZg33wM0WJ49Tyx08JWAaJkKGzIpUuOcVvvqMAAJSuDKiVUcujMDw/XgPg/GtJ3YhbDtY7IP11v51JOslt8P98cRlQjEpLaLPUSNtFW6IVgGbJUeoWUDIWU+Hv4+7ycW3AR7H9fGHUkJT1wEPovtG3nVIN60jYVJAerm9AJk3iMk61hGisd7Wems7iMOdulk3lG57oushNZMMhkwTQO6KYhcjhTzXAv9FYlpg956wmxzw2cpB/V8bn5FXTangM1twfs0PyWrbyu/G9dVIGYx7+z/wkHwwx8qgWbZurlAwD4oWBgSlshBhrMP1rC4GLRz77DjHl0oR92n7L6e5/kBR4lUiMaziudkqHJ707pGDX7BnRlbKKzUbuytz2WJEKFTYwmES3HddmJA7J8Hik9H4i1uwH/4BMq65eRUlkpf0unmIx29Db3M+2OiOUCnvvVUtRkpl/ugvpyAcL5a5D3uzAqXFVQFs33GZtwD71A2RYoj41t/6BhbUYmwiUQCgBug6BXE3wYJce22QzNvrC8swfuj0peEYCcMHLUx2nR5vk+eSq5xW4PBa4=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB8428.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(376014)(10067099003)(56012099006)(11063799006)(6133799003)(38070700021)(22082099003)(18002099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 chR687HX2fvUMGsoFDLROCai/b66S8p2xzVr0WcrjBDSbBoBbJIFX2r9mWxpvDGo3p5jgoF3A+eInc5KF6857FPvbJlI1TMfLX0hfpMHmMtXiL5yDnSt29nAPA2UlU1qGzxWM6WEmu9BgHkd33pqso9kzMOgJgSsXjnvdAqOxqhK88h36xRmO6pnJv5DrHhPsaQ7xmsT7RFx+u4XrycmU6ZJoL7nNPyCOiCFYz88DerUaeT3bIIN0cxmmRkFFcyp9kii06bbF/PqAjAUHFEbB/i+ZoMn34Tkli+IVs+yZ1h0K5Qbxa5E9azueUVha9FLJ95WyKEu6rpK3xJgttrmZg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB7565
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509FD.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	f439d2a0-b2f4-4253-d8d8-08def4778fac
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|14060799003|35042699022|376014|36860700016|1800799024|82310400026|6133799003|56012099006|11063799006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	dgzrhULBTt1hidCQBECuSA/q3OBKn+b3gN6kRQ5dLggTpPAtHtE1hI+QmFK9/vtAqtsjE8hfdLUqqdHGxCZ+z4/fD8AvqYAP9s8SrWfqeV1C7o4mm3iOQg4ZoHvZ/ic6Fc/MQHSpEzIGxkl4ZrotJClIpxAsFFgiHRYk6b3+/t3g8gNwOHEYGT8EEbN+d26XTi1Swl7N+spNbw2wRjvr+Dn318uvVctHTQSgot2Qos6LA6bMP+t7heenZIq6yNKqNAJ5Tn5oUTPhycAG4P8ED4d3ZqBGxIAWe18mhWskA6h120c6bMeO2BeUiGwMq0iCSnEB+Nz55Cihztt62BTq4dle7XdM6TI/5ZBYYOlz1jqOfu49ro65JadN82TQvwWU9xfeLUgD91A2xrxtqM9I2fkKBl6HTrCD5lPHNa8iraGj75fkC/jfGi8LBBHFzRlRhVq/alP1+uwiRVk0wbeZHWBzK4/rqVFr9+lEDyJH4RoiENfPSJqLbP4NET9l/DM7f7tVMIy3hff5G2QYVOdGKP+OxBBgZcHJM1Lf/ZFQWHjS8VJ6Y6EjZcMMuixip7CjANwcZ3tXku4HjqzNHySFIOyQICeBFmOFNsDO3CqUc4mmXY7rHlOVdVrNLl7Vs3ikc6VmIf5rXjh9AENg750noYHv2TG6XETRn4sM6UG5P2QrKs003HlDdjIknececUZO8AHvSAEnbEgxUyFqaPABbQ==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(14060799003)(35042699022)(376014)(36860700016)(1800799024)(82310400026)(6133799003)(56012099006)(11063799006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	9dOvWNYSaN45rau3ZwUS6x+0ZzKEqdxmuT8dVQUjm0cUr9PytU5/x7JUc4f5GCch6AJyfWvdH9ZFWTVz5B7pggLSZBJI7whOwXuD3R6CH6JrIYjv3qcJoWSE+L7xCz2/qviK+OOL++O8DwAgZjAVLcn/LO5R39xpd6pigRSFT3lVXDgLlHUuQh3QKCCXp2tq+7tl34ijBRad4fuWoQFMZOgoQ4qj+eDYvZ4RW5lkwt/BGudP1MQRbgip3c5KLPwpCoX8tMxN09vV0IN82r7R9oNAb9iZ0K7WmZ7dQoa/mLxZHoEAzJmDwZ2Uyi5KoAsmR7M651gvVBS208wa7LvQCLN59Rb2jNA4DXz3s7bqqhaZUSLSaOXgubaRoa6SAusnq95cBjXUFPsFgwXQ9aosjpvA4+6pTQZrkW/JTXOojmGhnQzhIDsS4/3jKTzecxAn
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2026 11:33:02.9165
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e2a7ea8-ace2-4207-cbd1-08def477a46e
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509FD.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB5PR08MB10286

Document the ordering requirements for saving and restoring the GICv5
IRS state.

The IST state is exposed through KVM_DEV_ARM_VGIC_GRP_IST and is
copied to or from userspace-provided buffers. Saving the ISTs
therefore does not update guest memory, so userspace does not need to
serialize guest memory after saving the IST state.

On restore, userspace must create the vCPUs, configure the IRS
address, restore the number of SPIs, and initialize the VGIC before
restoring IRS state. The IRS MMIO registers may be restored in any
order, but the final IRS_IDR* state and the IRS_IST_CFGR/IRS_IST_BASER
state that describes any LPI IST must be restored before
KVM_DEV_ARM_VGIC_GRP_IST.  KVM uses that state to validate the
userspace IST buffers and allocate any host LPI IST.

The IRS_*_STATUSR registers are observational state in KVM. Userspace
may save them for validation or debugging, but they are not required
as restore input and do not need to be replayed.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 .../virt/kvm/devices/arm-vgic-v5.rst          | 49 +++++++++++++++++++
 1 file changed, 49 insertions(+)

diff --git a/Documentation/virt/kvm/devices/arm-vgic-v5.rst b/Documentation=
/virt/kvm/devices/arm-vgic-v5.rst
index fc400f4fbb65b..45ad25604dfa9 100644
--- a/Documentation/virt/kvm/devices/arm-vgic-v5.rst
+++ b/Documentation/virt/kvm/devices/arm-vgic-v5.rst
@@ -262,3 +262,52 @@ KVM_DEV_ARM_VGIC_GRP_IRS_REGS
                    or tracking pending interrupts
       -ETIMEDOUT   An IRS save/VM operation timed out
       =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+IRS Save Sequence:
+------------------
+
+The following operations are required when saving the virtual GICv5 IRS:
+
+a) Save the ISTs by issuing KVM_GET_DEVICE_ATTR on KVM_DEV_ARM_VGIC_GRP_IS=
T.
+b) Save the IRS MMIO register state by issuing KVM_GET_DEVICE_ATTR on
+   KVM_DEV_ARM_VGIC_GRP_IRS_REGS.
+
+These two steps may be performed in either order. Saving the ISTs writes a=
ll
+IST state to userspace-provided buffers and does not update guest memory.
+
+IRS Restore Sequence:
+---------------------
+
+The following ordering must be followed when restoring the virtual GICv5 a=
nd
+IRS:
+
+a) Create vCPUs.
+b) Provide the IRS base address by issuing KVM_SET_DEVICE_ATTR on
+   KVM_DEV_ARM_VGIC_GRP_ADDR
+c) Restore the number of SPIs by issuing KVM_SET_DEVICE_ATTR on
+   KVM_DEV_ARM_VGIC_GRP_NR_IRQS.
+d) Initialise the GIC - this sets up the default state and creates the SPI
+   IST - by issuing KVM_SET_DEVICE_ATTR on KVM_DEV_ARM_VGIC_GRP_CTRL with
+   KVM_DEV_ARM_VGIC_CTRL_INIT
+e) Restore the IRS MMIO register state by issuing KVM_SET_DEVICE_ATTR on
+   KVM_DEV_ARM_VGIC_GRP_IRS_REGS. The IRS registers may be restored in any
+   order, but any IRS_IDR* state and the IRS_IST_CFGR/IRS_IST_BASER state
+   describing an LPI IST must be restored before restoring the ISTs. KVM u=
ses
+   the restored IRS_IST_CFGR and IRS_IST_BASER state to allocate the LPI I=
ST
+   during the following step.
+f) Restore the ISTs by issuing KVM_SET_DEVICE_ATTR on
+   KVM_DEV_ARM_VGIC_GRP_IST.
+
+The number of SPIs must be restored before VGIC initialization because
+initialization allocates the SPI state and fixes the SPI range exposed by =
the
+IRS ID registers.
+
+The IRS's MMIO registers must be restored prior to restoring the ISTs as t=
hese
+are used to convey the number of LPIs the guest has configured to KVM.
+
+The various ``*_STATUSR`` registers are observational state in the current=
 KVM
+implementation. Userspace may save them for validation or debugging purpos=
es,
+but they are not required as restore input and do not need to be replayed =
during
+restore.
+
+Then vCPUs can be started.
--=20
2.34.1
