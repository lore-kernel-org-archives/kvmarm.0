Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013022.outbound.protection.outlook.com [40.107.159.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0A2A444709;
	Wed, 15 Jul 2026 16:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.22
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784133711; cv=fail; b=mN53QqgUGnMiqhrxfvk0Dp7XqOdi3/7VKcPAdnGO8efZjs0ahWeEG6MPwnVo5C6sdCqXLV5KBWkHYoawT31acu4/4hrwWSd10z7TZefN64sRpYdKPtI9HWDcVyTpZEufzz2UyC6JxxfZ3Rd6AuzqlDg8SIIuLZ1ZPLi1kkv03SU=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784133711; c=relaxed/simple;
	bh=LSy0o3tarCAfP5zxPDVesdg6WiAyBsFhrSD/IIOW/hA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=qVplF9RHxaAEqlGxgmX9eeriqxxOKzRjgNK8i+KzgAl6y8OZv9dQ3llYExXFkNPRSAIU8oyR8mmwCoUNyujJeITiNxMwAeHTVrKXlDv9tF24BThxRifd21FEVbf03y0/ITrO2jf0EC4UkBkrtto4GFjr+3SqI8G7RGIC5hXICsg=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=KbNpgTDI; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=KbNpgTDI; arc=fail smtp.client-ip=40.107.159.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="KbNpgTDI";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="KbNpgTDI"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=C+PImYkay94dhQabJ1l2J7KQ/roZBngaXDVe3S5gL+mR8oONE22ic/O70Oi32eRSg3pZmzSy8mJMZxBkeDPNNNroMfbzNxhbGHVVxLgogxgowcoP/fDBVpcc8I4QyHtW0cL6NslTUukP05OhBC6IFrMe3XLCMhmmuCPZMvgRK6WpTwywGUb3FWYsrJ5rNcVfmo4K8jUaJZG/jsesV+NcUaXwJnc2aW4zZ6FTmIpDVaf8Acpwqw1utnOP2/r6gGjcqa0uivqW047umpOKKlWLiES8WWc5doAFrb8LpSdNmpXDE/M9ddBYYe/Sdv5G9nwzhNF/zmkZzfXY5j+7JxbaWg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LSy0o3tarCAfP5zxPDVesdg6WiAyBsFhrSD/IIOW/hA=;
 b=QmJIiEdgkjVR+6a52OLefRreswlpeHoLXfz8mDtwdzgUASF4ZxKCXzG3NMQ8zWroDn4fkY7r6mUAG5KYo/2B1do2bQ7PH31I9cZfLfpDagsiaae/wPnu8qU6SzzYdiZyr/lW6MkSRcFy7iz845Sb8OfX81HMy+pIpLoNprJPh0IOp9lADG331kpLnH1rv16kBxViTIS6r3kPwuxARBNAwQyJTDc5S3qHa2QCkCDGHpIzIyRrhxaKot9KyZ68iVYm8mCps8HNjbi3uQyLPCIJe6r5w5VsxqhTgLBN9Y9AkVxYqdXAypRdA/DLVmk7Y716+ihXmR9yxPMIOx2gvAzCng==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LSy0o3tarCAfP5zxPDVesdg6WiAyBsFhrSD/IIOW/hA=;
 b=KbNpgTDIfxv/2sE/8yj6rDsyPWgidP1D/HCb3oSpsXq6mQYxfjw4G2/SUCdLRcqz05IT95lnk0SEuUz9NouA9CuBfcs1Cs2lqNnvj0x4F9GB9yq6XER9hDjqUrYmr2VmBUaIU3V8JrgRUnsnspHuSlpjFEIPHvGgzPOD/Bagf38=
Received: from DU2P251CA0025.EURP251.PROD.OUTLOOK.COM (2603:10a6:10:230::23)
 by VI0PR08MB10445.eurprd08.prod.outlook.com (2603:10a6:800:205::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.11; Wed, 15 Jul
 2026 16:41:43 +0000
Received: from DB1PEPF000509F5.eurprd02.prod.outlook.com
 (2603:10a6:10:230:cafe::34) by DU2P251CA0025.outlook.office365.com
 (2603:10a6:10:230::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.223.11 via Frontend Transport; Wed,
 15 Jul 2026 16:41:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509F5.mail.protection.outlook.com (10.167.242.151) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.223.9
 via Frontend Transport; Wed, 15 Jul 2026 16:41:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yyIsojkTFr/5iiAfIfbwXdkv4O197RPLJE8G6S1jxYUX81rDn7qJNMkV/xha/y05CE0YbgN+JEZ63sISW2nZ2sjcKYvwHhVGd+ouJTNZ8GV9bvCVQRTlU6Cv2jEvNILwgIURJZJZ3GJgkzLyNK9RdG8HWlPv7YEeEjB/Ai6z1ATVGC0po2Y30IfokmCLYetRPlXmHmdzAs78U+aMhATK40yVAocYbc3IFnGkBs7JavFi6udweEP49IUDl2LLpX5of23hd4o8RUfLlXFlVUXXJIoOX6gJz3tO2BjB6lSteamIoK+8Rdb4TpCpoheBrncuOXt61f+VSalgqSKUmu3eBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LSy0o3tarCAfP5zxPDVesdg6WiAyBsFhrSD/IIOW/hA=;
 b=u0DGT3DCueEmYt1LP3Ujad2quGkKm1n5qk4oGdKF7TTqX13DTDLazRpIX4GaZissXH3v2teqEIHEaS+XBIy05a4pehdPXdhkMMMxdy/lHsIqjAhwwVpYY2PE4EWOy7C6iI3h1/oTdpeEgZAebyBz1fZk9L1klZHvcQIwsFXyFpW7j40y+GOTmgyF/9UPtG2SoARcAjc5OUdq3WCz/65Gy5ZHmob3DkbXK2bnNPnfVo71YC0FiPoGzcdZpoJ4J38UOA804bRYUEnj9cNU1oOT11MM824pJoGA7GgYX35UotZkpv4RCxrm095J0aa38868COPBUhsujzz2D21C7DfJtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LSy0o3tarCAfP5zxPDVesdg6WiAyBsFhrSD/IIOW/hA=;
 b=KbNpgTDIfxv/2sE/8yj6rDsyPWgidP1D/HCb3oSpsXq6mQYxfjw4G2/SUCdLRcqz05IT95lnk0SEuUz9NouA9CuBfcs1Cs2lqNnvj0x4F9GB9yq6XER9hDjqUrYmr2VmBUaIU3V8JrgRUnsnspHuSlpjFEIPHvGgzPOD/Bagf38=
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com (2603:10a6:10:407::19)
 by GV1PR08MB10840.eurprd08.prod.outlook.com (2603:10a6:150:160::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.202.18; Wed, 15 Jul
 2026 16:40:39 +0000
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e]) by DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e%5]) with mapi id 15.21.0223.008; Wed, 15 Jul 2026
 16:40:39 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "sashiko-reviews@lists.linux.dev" <sashiko-reviews@lists.linux.dev>
CC: "maz@kernel.org" <maz@kernel.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"oupton@kernel.org" <oupton@kernel.org>, nd <nd@arm.com>
Subject: Re: [PATCH v3 37/40] Documentation: KVM: Document
 KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS for VGICv5
Thread-Topic: [PATCH v3 37/40] Documentation: KVM: Document
 KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS for VGICv5
Thread-Index: AQHdCwZPDMLj8nZGrE6Ux5IB8a+Z4bZb/keAgBLdAQA=
Date: Wed, 15 Jul 2026 16:40:39 +0000
Message-ID: <40300ad5a1dd948ca1325b8335185476214bc2fd.camel@arm.com>
References: <20260703154811.3355680-1-sascha.bischoff@arm.com>
	 <20260703154811.3355680-38-sascha.bischoff@arm.com>
	 <20260703163657.A88C81F000E9@smtp.kernel.org>
In-Reply-To: <20260703163657.A88C81F000E9@smtp.kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU0PR08MB8421:EE_|GV1PR08MB10840:EE_|DB1PEPF000509F5:EE_|VI0PR08MB10445:EE_
X-MS-Office365-Filtering-Correlation-Id: f6ddd27c-bcad-42f8-432c-08dee28ff359
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|23010399003|376014|1800799024|3023799007|18002099003|22082099003|4143699003|56012099006|11063799006|10067099003|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 MJS25M2uqv1ggI6mrD7XCGFfVZJGufKB5OIssSnkSnpKmj0h80EN52EO84WjNYJBLLSHekjNj8KR3pYUYWrc/sGB/HInDoapI7T/twlSwR3XyN/yGhHcz9woHBOYSlpl8n0es5UK9fNn1GppjL61K1b3PwvzDfTVXNltysAl8Oh+nAGZoUeLISu+PoidMfCDDc1uK5bDtkcesyjL1sq40USH4WdiGz1QdtudPPjRqoFtaJ9FKCpGX+6ZTXPoaYsysJVO3lATrF6J1hzOtdZP4A1yl+bY782InHhoVxu1Dmq9HBgeyIFQWPV8PwGcx0Q3OSONO/U68lIg+DgJU1C9rFZb2Xch/liDJbi7h4gKI+N6z+3Z9iY9Hxevx/q01czX1ctDFPLR9Dx3uwlvzQsE7AsQndTZC6smRqzk5KTB5j5i266lhySqwT980VhbAFmQgEEEPVQNpjVA7Hxg2C4n6nm62U+iEXuw8x0Kc/JqsNZreEbBSXmQU1uA84BrDNZyEfoz+TUI6xsymofyVt7beE9KKUQydQ5De+Z/4JnxGJFmYFVkvbDQYdlZ+0Xdt88VElfloHifN09391IqwU42XQru2grgR0ee3JTH6jQJlgrye0JdIetz/RHd9SJhDq7yfxAznG12zNSi444wf65VVgcYdtVBw2p11VhKFLnjr11dSm7RqD05ItjqZqBSJ0gbvQUx05onwNZwmPoON2kIbgHLOGJAU4N8cCKrViEJHP0=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB8421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(1800799024)(3023799007)(18002099003)(22082099003)(4143699003)(56012099006)(11063799006)(10067099003)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <1658F8F8775B834B9D7D7CD7A96FB8D2@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 U5+MgEOprF1IF7CHkw+0udGaSbW7YboWrflIug/g66PyZDZl5aHX6O63l6sI6luYpk3meEcpKR5ePSYIMqbXxtE9nN0B7+MYtFmXBw7fK7bRzwqGnDJO4UgzFe5Bkh/Ypwaf3KFgeQ7wYuGj1n/UV/Z1+h8WjGbb3+ZGDK226X+2rb3SORbcUOSCE19aHNwML7GRHmttIOkjfY260+UycF65Pgqtj15mZv3VNDCmYjKxsO3cmH3/0RkRzPXi/tVJUaiXdLDkgXRIFlfRuaqJ89bfpCqG/EOhN6qS4Cx8Vp/SC8poZH9gqR28R9PDw7+alMnjhkS9y5VOy4xJYbZYvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR08MB10840
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509F5.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	59c62a40-9397-43fe-2121-08dee28fcdbc
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|35042699022|23010399003|1800799024|36860700016|14060799003|376014|56012099006|4143699003|11063799006|10067099003|3023799007|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	iPPn9sEpMS9Heoo3uEaXc2mj1fMWIxK69mfidQiPPVOAMI5EPIdHiK2KX6Eh61jFok/GQszalSnY1nZk6vpQQUpYCd1U1IhPRIApjjf6QRfMSS8pkCzYLIoK+vJqRg8WYI25OwipA1eBfluXUvAoNZXwVaA7Y24t072Yca8fXFavKDJhOkZ4W0mJJpa2jTt99ZeFuL7DL75+l2iGNz/I8BdPFdTmYW4tzLGuZJ5SKNbBdIc56HhcvT/+iUTfu+2lPyX43JBzH3KH5xeCzDUV9GVxasL6t0lK8fpRx6rhUNAayKrz/UWLMTvIg7wSYm/dcxr6zEB+sROrxdekNXOqa3hT6iVHiTG14ze8tqAbC+FFzc657l0nlEv0ktFg07G7yvgEh80IZXJOktHYoP3+gaR8nSyPitJyFsB8rzN22A5hPSs/nC7J00byIlEdWZ4+B3Hy4mmhyjn70jWgbq0UwaC1dGsVuT8ORjM01GdQMIJjsu5QYtB2CQwLmwwHleA36YUhjfZxA07jhx/NF/kbOVU/9gW+H5cGfbF9PBoNE4w00eOh9aoLVzKUddMjaRjv55RARYKEhrYbCw1fVLaFn4fXaVOLAqYTSZ8swyQTh80mJl0VoDSGbS/F4va97evtud5or6Z8CqRdqrV91jqPJU6xCpTOnsP7dP/yS0ITujPFQSiPyk3VDq5q+rgZvimCfxlWTGy5ebj3ae4fanVL4w==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(35042699022)(23010399003)(1800799024)(36860700016)(14060799003)(376014)(56012099006)(4143699003)(11063799006)(10067099003)(3023799007)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	3b1Wkv4H2IihIzsyycKKugF+37bzL9vfKoKCqpsmIyGtWQjB/PPvoMBNqGA3V+TnR269l4pPR8Gb1kD2ADrsLKlvzEmVgh4N4O8bQ2fYIZVy4RJEE0T+Ab+p3amnHJh+DC+QL4gXI72Mgrm020ltIVi8wtmmFSjNs2F495ayJQuWsmlsOkFiPOYB+QlO7qhkcLCO5SU7+QWgm8QQgve3+0IWTacybIVgnLZ+TL0gRunOJRwqu4XAdSipoygapkeYJBB+zqDfQyRjs8GOZhwpUzL9NhS6dc0WWvzuU55DeEB/ye9zP2k3bRFKDG4+HVzCzSjgxNJbl7WwWnvvujQlz7At4vjvmgXC2RSClV4fjJK83vBBVRV7UUzRSEKpjEH8LqInVk7923sCuLuKNKyri3MV+GuDvZgbSZW4k5D3P/yLI4PlYprIPx7FTBh4Ezso
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2026 16:41:42.3130
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f6ddd27c-bcad-42f8-432c-08dee28ff359
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509F5.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI0PR08MB10445

T24gRnJpLCAyMDI2LTA3LTAzIGF0IDE2OjM2ICswMDAwLCBzYXNoaWtvLWJvdEBrZXJuZWwub3Jn
IHdyb3RlOg0KPiBUaGFuayB5b3UgZm9yIHlvdXIgY29udHJpYnV0aW9uISBTYXNoaWtvIEFJIHJl
dmlldyBmb3VuZCAxIHBvdGVudGlhbA0KPiBpc3N1ZShzKSB0byBjb25zaWRlcjoNCj4gLSBbTG93
XSBUaGUgS1ZNX0RFVl9BUk1fVkdJQ19HUlBfQ1BVX1NZU1JFR1Mgc2VjdGlvbiBpbiB0aGUgVkdJ
Q3Y1DQo+IGRvY3VtZW50YXRpb24gb21pdHMgdGhlICdFcnJvcnM6JyBibG9jayBhbmQgdGhlIEFB
cmNoNjQgZW5jb2Rpbmcgbm90ZQ0KPiBwcmVzZW50IGluIHRoZSBWR0lDdjMgZG9jdW1lbnRhdGlv
bi4NCj4gLS0NCj4gDQo+IGNvbW1pdCAwNWNlNDJhYmI5YWY1ZDE0MjZkZWQ0YmJlZjRjYjVhZTU2
NTMzY2FmDQo+IEF1dGhvcjogU2FzY2hhIEJpc2Nob2ZmIDxTYXNjaGEuQmlzY2hvZmZAYXJtLmNv
bT4NCj4gDQo+IERvY3VtZW50YXRpb246IEtWTTogRG9jdW1lbnQgS1ZNX0RFVl9BUk1fVkdJQ19H
UlBfQ1BVX1NZU1JFR1MgZm9yDQo+IFZHSUN2NQ0KPiANCj4gVGhpcyBjb21taXQgZG9jdW1lbnRz
IHRoZSBLVk1fREVWX0FSTV9WR0lDX0dSUF9DUFVfU1lTUkVHUyBkZXZpY2UNCj4gYXR0cmlidXRl
DQo+IGdyb3VwIGZvciBWR0lDdjUuIEl0IGRldGFpbHMgdGhlIE1QSURSIGFuZCBpbnN0cnVjdGlv
biBlbmNvZGluZw0KPiBmb3JtYXQsIGFsb25nDQo+IHdpdGggdGhlIGxpc3Qgb2Ygc3VwcG9ydGVk
IHN5c3RlbSByZWdpc3RlcnMuDQo+IA0KPiA+IGRpZmYgLS1naXQgYS9Eb2N1bWVudGF0aW9uL3Zp
cnQva3ZtL2RldmljZXMvYXJtLXZnaWMtdjUucnN0DQo+ID4gYi9Eb2N1bWVudGF0aW9uL3ZpcnQv
a3ZtL2RldmljZXMvYXJtLXZnaWMtdjUucnN0DQo+ID4gaW5kZXggNWM2MzIzZDgyZjc4NC4uZTIw
NDViMDlmMjdkMCAxMDA2NDQNCj4gPiAtLS0gYS9Eb2N1bWVudGF0aW9uL3ZpcnQva3ZtL2Rldmlj
ZXMvYXJtLXZnaWMtdjUucnN0DQo+ID4gKysrIGIvRG9jdW1lbnRhdGlvbi92aXJ0L2t2bS9kZXZp
Y2VzL2FybS12Z2ljLXY1LnJzdA0KPiBbIC4uLiBdDQo+ID4gK8KgwqDCoCBJQ0NfUFBJX1BSSU9S
SVRZUjE0X0VMMQ0KPiA+ICvCoMKgwqAgSUNDX1BQSV9QUklPUklUWVIxNV9FTDENCj4gPiArwqDC
oMKgIElDQ19BUFJfRUwxDQo+ID4gK8KgwqDCoCBJQ0NfQ1IwX0VMMQ0KPiA+ICvCoMKgwqAgSUND
X1BDUl9FTDENCj4gPiArwqDCoMKgID09PT09PT09PT09PT09PT09PT09PT09wqANCj4gPiA9PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0NCj4gDQo+IFtT
ZXZlcml0eTogTG93XQ0KPiBUaGUgY29tbWl0IG1lc3NhZ2UgbWVudGlvbnMgdGhhdCB0aGUgbWFp
biBib2R5IG9mIGRvY3VtZW50YXRpb24gd2FzDQo+IGRpcmVjdGx5DQo+IGNvcGllZCBmcm9tIFZH
SUN2MyBhcyBpdCBoYXMgaWRlbnRpY2FsIG9wZXJhdGlvbi4gSG93ZXZlciwgdGhlDQo+ICdFcnJv
cnM6JyBibG9jaw0KPiAoZG9jdW1lbnRpbmcgLUVOWElPLCAtRUJVU1ksIC1FSU5WQUwpIGFuZCB0
aGUgbm90ZSBhYm91dCBBQXJjaDY0DQo+IGVuY29kaW5nDQo+IHByZXNlbnQgaW4gdGhlIFZHSUN2
MyBkb2N1bWVudGF0aW9uIGFwcGVhciB0byBiZSBtaXNzaW5nIGhlcmUuDQo+IA0KPiBTaG91bGQg
dGhpcyBzZWN0aW9uIGluY2x1ZGUgdGhlICdFcnJvcnM6JyBibG9jayBhbmQgZW5jb2Rpbmcgbm90
ZSB0bw0KPiBmdWxseSANCj4gbWF0Y2ggdGhlIEFQSSBjb250cmFjdCBkb2N1bWVudGVkIGZvciBW
R0lDdjM/DQo+IA0KDQpJJ3ZlIGFkZGVkIGluIHRoYXQgYmxvY2suIEl0IHdhcyBpbmRlZWQgbWlz
c2luZy4gSSd2ZSBub3QgYWRkZWQgaW4gdGhhdA0KQUFyY2g2NCBkZWNvZGluZyBibG9jayBhcyBp
dCBtYWtlcyB6ZXJvIHNlbnNlIGluIHRoZSBjb250ZXh0IG9mIEdJQ3Y1Lg0KDQpUaGFua3MsDQpT
YXNjaGENCg==
