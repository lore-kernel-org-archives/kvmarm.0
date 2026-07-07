Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013012.outbound.protection.outlook.com [52.101.83.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC0D037B40C;
	Tue,  7 Jul 2026 15:09:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.83.12
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783436962; cv=fail; b=aEyYpoQ0eed753Lt/331tauc5b8SRGMRLhD541KZi/V0ZH8rAfHvQEGKYdtYsQl77LIUek21xm36H5xfWfIvdu/6X8jTKz2x6CQDdcxvdoZaMxgpaGBaNQ+jHhhsP+skaay0qZ+O6sRZfC06G0dCm6y97P5tU4XY4g1QkOaRlnU=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783436962; c=relaxed/simple;
	bh=FVAVPm0wRnHRdpEDboiza9MnKPhdsRDfqj4SnZbeIHE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=gFuVzQo6HLvu/4QJkqJ+6WeWngmFlLRdrxSfbPxSp0E7I6eI2ZOjjhaw/YIghXZiSAigBz4Zj4H20bx8h2hdr7pGATykZrNk9MbSB/B1jACOC4kYEjrND0tESKAbduD8SSUmfk6X0eyGEmw1FIvnJp/v01yyzJ/2jlAXDgErI8g=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=jJdp7fz3; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=jJdp7fz3; arc=fail smtp.client-ip=52.101.83.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="jJdp7fz3";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="jJdp7fz3"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=MaIeDEa4oEAmMRL4rbDy22KDSuL4CXXQo3P2/ircBrEYrvyivDmBhqI9NUgM2x2El903wOTQZ/7TxEMsySAf5ElcAujLAPHJ+Y6MyD6zs4DVZdoliWIpkOlVwvXRTV7aJ1KibNXBz1mPcjOenqQt6G5RPCFNs/ei6BdCf684+TqBjj4fG2bnxu17RDypezOPiwB82MpIIOTMqDWFVwV0tZLB2/6J91DvJHPLGtpGQzMGJ/wjxJj2CK4O55ipE1MajxRoz3KRJZNlQEKPhZD8oyjI14Mg9LHE6BYZ+1a4654klFOjOwTc0JUmOLMSZs5WpwZ47p3GxKlosxRXwg57XA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FVAVPm0wRnHRdpEDboiza9MnKPhdsRDfqj4SnZbeIHE=;
 b=LyOUs53AcptFA3VF42u/a+G6JhcLLlGCtm7MnUDM7pzLR10KIQPxOQqJ7OyMc1ypcbsbWVR16GBCaGI7vhJTTj2cwCsEodrMpA2FbzfC6BW5jyXALdIhk6yDWTAM3vmMOnertj+m4iUvTvlMuQcgOt6/QgfOnRdxExP8BEQMH0IEkRBjvbVaV4skWnM5VB7AheOpChctuq6T+OMwwPO3roMg6S64rC9DAPnRtuoClBhtOeWE2HOEGKO3TMDefP4JWEuPI6dehHkQ5yCvsaJoSlOL9bl5VirutLD6PU7pMHm1QYkD5iAxvXq8UHWbKNawLtzK6nQogVZJfMKMuQj8AQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FVAVPm0wRnHRdpEDboiza9MnKPhdsRDfqj4SnZbeIHE=;
 b=jJdp7fz3nNWFCGMUF0YuGzVb5JOf1tBxyoPKCosqkfU1K4eJ8Rhm0w4IIV7+5dFr+tK9UzLi7HtE01XKZmekUD0llQM01uhIavHk2sumhwbFt5cFKy4kMAr7mrKFBtwk2Pd42tnTY4FrUy7BP4vjmEl9EtbBcwGITQQwNpVKhNs=
Received: from AS4P250CA0008.EURP250.PROD.OUTLOOK.COM (2603:10a6:20b:5df::9)
 by VI0PR08MB11551.eurprd08.prod.outlook.com (2603:10a6:800:2fe::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.11; Tue, 7 Jul
 2026 15:09:10 +0000
Received: from AMS1EPF00000043.eurprd04.prod.outlook.com
 (2603:10a6:20b:5df:cafe::14) by AS4P250CA0008.outlook.office365.com
 (2603:10a6:20b:5df::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.13 via Frontend Transport; Tue, 7
 Jul 2026 15:09:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS1EPF00000043.mail.protection.outlook.com (10.167.16.40) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.6
 via Frontend Transport; Tue, 7 Jul 2026 15:09:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PSAt8BO6SKIJFLRJ7cOJkVn2uEkXUAbifpDuQTShAlGyhj4oawLy1iOWw5FastYfvvxF0L0pR9voP25+2uNXpn95svdh4IEYbZnjioq9BtQcWDgQlkp07xcqGd/TmRv8MKA7SJNHPO7GTanx3kBdKiK6DQMPpbG7N1U1rx9KJV2HWM8/Hk9N+ppLDQsi5I71a4Tv46FA9Ycs8QwijBNtXkg/8N4XqmTLjsqdZq9ogUTthn2XshZnsnSGMgzxvwXWZG4sPVfmhX+QI5W/QX+Rng32kwm4p/4IVQJFMG0RCUEiyKthHqjcjrYCptjSH2Q3BhnvNf0BRZqVha/lZZbHDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FVAVPm0wRnHRdpEDboiza9MnKPhdsRDfqj4SnZbeIHE=;
 b=WtBl/WfMcfjHKoyDv2CwfLLZh0EBC1sfX71INjJqBnQksTgXTIIrjIX/fOLpq9eYE+EyinKEn7wpU0qOiEjoIL3hOUJCVhOI5+lBlRkCwBQZaGJC7uv81B0DoHBgLLB9w7L1elc68HpSBTUHdP6tiYCi0VaDdQcwoFQdApNfrXY1hQjO/P1nF9F7l0Hg+18T4+3wveMZi8TmzFgPP3P+EcNZJU0MAa+b8J9JXdxpamhBfxf7ogW6puzRejzv6ParYrK/xmYb7K7laDPxNQUYVqWWwLxPqfpd0xHhYGBcxiqqL2z528TJlS9VpPFMyybCwr53XJZupIaPDSlnJAkWTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FVAVPm0wRnHRdpEDboiza9MnKPhdsRDfqj4SnZbeIHE=;
 b=jJdp7fz3nNWFCGMUF0YuGzVb5JOf1tBxyoPKCosqkfU1K4eJ8Rhm0w4IIV7+5dFr+tK9UzLi7HtE01XKZmekUD0llQM01uhIavHk2sumhwbFt5cFKy4kMAr7mrKFBtwk2Pd42tnTY4FrUy7BP4vjmEl9EtbBcwGITQQwNpVKhNs=
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com (2603:10a6:10:407::19)
 by AS2PR08MB9075.eurprd08.prod.outlook.com (2603:10a6:20b:5ff::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.11; Tue, 7 Jul
 2026 15:08:05 +0000
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e]) by DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e%5]) with mapi id 15.21.0181.009; Tue, 7 Jul 2026
 15:08:05 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "sashiko-reviews@lists.linux.dev" <sashiko-reviews@lists.linux.dev>
CC: "maz@kernel.org" <maz@kernel.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"oupton@kernel.org" <oupton@kernel.org>, nd <nd@arm.com>
Subject: Re: [PATCH v3 06/40] arm64/sysreg: Update ICC_CR0_EL1 with LINK and
 LINK_IDLE fields
Thread-Topic: [PATCH v3 06/40] arm64/sysreg: Update ICC_CR0_EL1 with LINK and
 LINK_IDLE fields
Thread-Index: AQHdCwQc5Nm/2v6DSkuvWwqmfo36BLZb+lkAgAY0cAA=
Date: Tue, 7 Jul 2026 15:08:05 +0000
Message-ID: <1539a527910fccc3a1e4864ed60df15c9935f062.camel@arm.com>
References: <20260703154811.3355680-1-sascha.bischoff@arm.com>
	 <20260703154811.3355680-7-sascha.bischoff@arm.com>
	 <20260703162250.AC8B11F000E9@smtp.kernel.org>
In-Reply-To: <20260703162250.AC8B11F000E9@smtp.kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU0PR08MB8421:EE_|AS2PR08MB9075:EE_|AMS1EPF00000043:EE_|VI0PR08MB11551:EE_
X-MS-Office365-Filtering-Correlation-Id: 0cb0f023-d52f-4898-0d0e-08dedc39b14f
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|23010399003|1800799024|38070700021|18002099003|22082099003|11063799006|4143699003|56012099006|6133799003|3023799007;
X-Microsoft-Antispam-Message-Info-Original:
 bOKa16I0/U7H7a4GljQmdSqHqSKeN1E7qUV7F0zTRIETokfNewdHuAIZ2EuWO4Inhqxok0sb/F7O3y36TTXuZytM5g5f6DNw1rgwjbaT+TP2cGCmYr5Bp5pkswFqvrHlQz4OoP+Dih5nw8aaiwoKhAqJtTPeV7qZ44h5ihnFn/hLjqQ4PihO0Xio/sksmWZ9bkHQ3xcDgdgJEtF2FGS0MkoAM6YnKSqYZ99fjwMBrUi9c6QPCQ7krAikcPDJ+w8H63HoPIWj1228l0xWxbbFaHk8DZS4lxhOJkP986+8OEUrLiEQnZKF6Hkh+TIh6yL2O2wzYxuHGtkxpTfRZ+CPCGvaqNJJmA/O6K0tvCiuKAnmXRv7Zqn5vjAi7d3UkOOxvwbloouQUVPiz6gSB5ro3/1/Ap3syn6oOPc7a+5O2nHe8LhYRB4OUE/alUVf7cp5C4tCBSzjbwO13S6K2cMyXfr/DoekRCB2gkFHjEBzwzHjJf+8T/yCfv4C7AmcPgEmvhFllLce025o/aDUWE3m1iEab18fq9HQeQ9PMnbfFTXBkzl7kFKJmzjfOUdSH7BBDm3TcYLWo5Iqgkof2NxInVFNTry+2CTvYkXJrGp94xHajcvaAUcz7murw5m6Zq5VYiQXRz6I3amrPOhOjnyn/U4Kd1QH3WzykK03Nz6akgnlCIIG74eWCaDnY1MeGCA+5uoX95+lIuoA9RU3PTv4sNeFnAM4x1WbygX+g/ZM/xE=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB8421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(23010399003)(1800799024)(38070700021)(18002099003)(22082099003)(11063799006)(4143699003)(56012099006)(6133799003)(3023799007);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <058B5B87DE875B478F324489A8052655@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 a9yxRfhQS7hJlu/J0+/m8p+F213dwojzLoRi+w+tlXpbOXpEdHUVV7Rp/WiiXiHq/MIkii/BhJfSQOrEN0g9h7WajfMiaveQ/ue/dM/r2+IsHunko2h5fBpo7+1Lq8kTYyRz9AO/j2PjsGsRf4FyS12FANpDFy+WitKyVT6WhKwn/MVvuPTTH/3EFVKGNbdCJ7tBRDfNY5Uyjq2DtFqD5zsEKkRTytm+b/U9MXomkO7rxrC1iEGbi1BE4oToMdDFKjI0vNCep0r9Oswb2XaVux7RX+YpjJtzEkFVOKqLt1/bkt8qGcPnnBmYg/yzVi3MBD2QsyUNWIDfgCKR4GXfXQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB9075
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS1EPF00000043.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	36a004dc-9cc3-4e71-19bc-08dedc398be5
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700016|35042699022|23010399003|14060799003|376014|22082099003|18002099003|3023799007|6133799003|4143699003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	kUIZsdREkHzVErxgXJFuiN0S7n+RJ7RiTBQVlLuszYAzVDxq/RRabl5W3qqKJLvsLh2ixADK2OYzMIqdczvKqrjk2wytUTo7QgKE1Pz9EVuIsDQLsWJKdajKqZApnSShP7JIe90dDrDKy3ETALAwSOs1GVHZTT9yMRvSaAfBLtCx1hnYI2GaA0AH5G9nf9O1PjgMhBkkxrFNYyBapofK/4SYOrvQ02r0nNyi4frPEQzDGvaGAB4rdJJtDpssYYPRKylf/GZoN23zK3wnmyRSQ22f8J57ij9inPJl0BDXvOXPDEU5rGxxO+WVcSIa2oXdTABAE9GlMShRizVsOWTDAPB+v1gnATSZOXPmosZqlWQthvo4rF714EJ6PuwgoHSxIG3WAl4A5RFMFy+gWd1xmb/zwXz1ZXZ2+CoCtqUKj6rD2duK44RJURPUQ/AxY7WWb9yqY3hdtxPZ4I2oqSuAvCiBY5Y5xzBywQnrG+fcurBT2e/XdsV24NGJPTosgcAocSpXAwu+gD0FTB1FLJnYsHF1C3sy96UqTq/QaUlgoyJT5ju5S4FWjG+DfnaKAHGcP4uqniUXT9DD1h43Cjy7D8cu9m7Jb3xiUMo/zW6wgEWzMx0nGzgMCYqnzSLe7VbCYQbbt8fi0aa+tnCJ0DEre2wjcyvTjDQlnZ+WOhcIzI1VYg+kvMiYt1YNCurOsaPmquDZQpMqXg/pRXUvqynQuA==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700016)(35042699022)(23010399003)(14060799003)(376014)(22082099003)(18002099003)(3023799007)(6133799003)(4143699003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	AqTsWNLFu5z+FFiuQk/Cfxa8OqOXyeJq1EjFHlUWLoQw90iv6QYM0XxMiGclY1KcY/A/oY31TFmapFnBnzmTNFuBVqIH3F37uDE7OD3b/p3yRW8ZK/DDkswQXDWp8LQ30l7IX2ac5IgVyAZrjun+sIdxueGx+16f58uJcbqUdRjnnkx5lulYZvzsScWkS3vjamOgxmNX2phTTRL+AFd7lCepXTv53y2NqcQgVick83YQ8iZdT8MTL9JUX7T22sKu01dLTRow8pwQMvCutr/MdZKsRo3Mb8yn9QfgAthb866dQVhoIwyNC+e1x/9nusXKeMx+x1Hvj0ImCmekb+y80OXoy1IMbZJa5sy5sw/I9eaj6TA92+OD9kgyQ4CuJuq9ejQ3MB6Z6fuycNxZKVU2rS6vG5sRw22zM9Z9u+Cz3oeR6NqZKoxexUUafoatswjg
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2026 15:09:07.8176
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0cb0f023-d52f-4898-0d0e-08dedc39b14f
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS1EPF00000043.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI0PR08MB11551

T24gRnJpLCAyMDI2LTA3LTAzIGF0IDE2OjIyICswMDAwLCBzYXNoaWtvLWJvdEBrZXJuZWwub3Jn
IHdyb3RlOg0KPiBUaGFuayB5b3UgZm9yIHlvdXIgY29udHJpYnV0aW9uISBTYXNoaWtvIEFJIHJl
dmlldyBmb3VuZCAxIHBvdGVudGlhbA0KPiBpc3N1ZShzKSB0byBjb25zaWRlcjoNCj4gDQo+IFBy
ZS1leGlzdGluZyBpc3N1ZXM6DQo+IC0gW0hpZ2hdIFdyaXRlcyB0byBjb250cm9sLXBsYW5lIHN5
c3RlbSByZWdpc3RlcnMgKGUuZy4sIElDQ19DUjBfRUwxLA0KPiBJQ0NfUENSX0VMMSwgSUNDX1BQ
SV9FTkFCTEVSeF9FTDEpIGFyZSBub3QgZm9sbG93ZWQgYnkgYW4gaW1tZWRpYXRlDQo+IGlzYigp
IGluc3RydWN0aW9uLg0KPiAtLQ0KPiANCj4gY29tbWl0IGE3MTFjNmE4MTE2N2Q1NjhhYjFmOTU1
MzNhMzg1MThhZGYxN2E0ODQNCj4gQXV0aG9yOiBTYXNjaGEgQmlzY2hvZmYgPFNhc2NoYS5CaXNj
aG9mZkBhcm0uY29tPg0KPiANCj4gYXJtNjQvc3lzcmVnOiBVcGRhdGUgSUNDX0NSMF9FTDEgd2l0
aCBMSU5LIGFuZCBMSU5LX0lETEUgZmllbGRzDQo+IA0KPiBUaGlzIGNvbW1pdCB1cGRhdGVzIHRo
ZSBzeXNyZWcgZ2VuZXJhdG9yIGRlZmluaXRpb24gZm9yIElDQ19DUjBfRUwxDQo+IHRvDQo+IGlu
Y2x1ZGUgdGhlIExJTksgYW5kIExJTktfSURMRSBmaWVsZHMsIHdoaWNoIGhhdmUgYmVlbiBhZGRl
ZCB0byB0aGUNCj4gYXJjaGl0ZWN0dXJlLg0KPiANCj4gPiBkaWZmIC0tZ2l0IGEvYXJjaC9hcm02
NC90b29scy9zeXNyZWcgYi9hcmNoL2FybTY0L3Rvb2xzL3N5c3JlZw0KPiA+IGluZGV4IDZjM2Zm
MTRlNTYxZTYuLjU3YWIwOTQwNDI2N2MgMTAwNjQ0DQo+ID4gLS0tIGEvYXJjaC9hcm02NC90b29s
cy9zeXNyZWcNCj4gPiArKysgYi9hcmNoL2FybTY0L3Rvb2xzL3N5c3JlZw0KPiA+IEBAIC0zNzM2
LDcgKzM3MzYsOSBAQA0KPiA+IFN5c3JlZwlJQ0NfQ1IwX0VMMQkzCTEJMTIJMAkxDQo+ID4gwqBS
ZXMwCTYzOjM5DQo+ID4gwqBGaWVsZAkzOAlQSUQNCj4gPiDCoEZpZWxkCTM3OjMyCUlQUFQNCj4g
PiAtUmVzMAkzMToxDQo+ID4gK1JlczAJMzE6Mw0KPiA+ICtGaWVsZAkyCUxJTktfSURMRQ0KPiA+
ICtGaWVsZAkxCUxJTksNCj4gPiDCoEZpZWxkCTAJRU4NCj4gPiDCoEVuZFN5c3JlZw0KPiANCj4g
W1NldmVyaXR5OiBIaWdoXQ0KPiBUaGlzIGlzbid0IGEgYnVnIGludHJvZHVjZWQgYnkgdGhpcyBw
YXRjaCwgYnV0IHNpbmNlIGl0IHVwZGF0ZXMgdGhlDQo+IGRlZmluaXRpb24NCj4gb2YgSUNDX0NS
MF9FTDEsIEkgbm90aWNlZCB0aGF0IHdyaXRlcyB0byBjb250cm9sLXBsYW5lIHN5c3RlbQ0KPiBy
ZWdpc3RlcnMgKGUuZy4sDQo+IElDQ19DUjBfRUwxLCBJQ0NfUENSX0VMMSwgSUNDX1BQSV9FTkFC
TEVSeF9FTDEpIGFyZSBtaXNzaW5nIGltbWVkaWF0ZQ0KPiBpc2IoKQ0KPiBzeW5jaHJvbml6YXRp
b24gaW4gc2V2ZXJhbCBwbGFjZXMuDQo+IA0KPiBGb3IgZXhhbXBsZSwgaW4gZHJpdmVycy9pcnFj
aGlwL2lycS1naWMtDQo+IHY1LmM6Z2ljdjVfY3B1X2Rpc2FibGVfaW50ZXJydXB0cygpOg0KPiAN
Cj4gCWNyMCA9IEZJRUxEX1BSRVAoSUNDX0NSMF9FTDFfRU4sIDApOw0KPiAJd3JpdGVfc3lzcmVn
X3MoY3IwLCBTWVNfSUNDX0NSMF9FTDEpOw0KPiB9DQo+IA0KPiBBbmQgaW4gZHJpdmVycy9pcnFj
aGlwL2lycS1naWMtdjUuYzpnaWN2NV9jcHVfZW5hYmxlX2ludGVycnVwdHMoKToNCj4gDQo+IAlw
Y3IgPSBGSUVMRF9QUkVQKElDQ19QQ1JfRUwxX1BSSU9SSVRZLCBHSUNWNV9JUlFfUFJJX01JKTsN
Cj4gCXdyaXRlX3N5c3JlZ19zKHBjciwgU1lTX0lDQ19QQ1JfRUwxKTsNCj4gDQo+IAljcjAgPSBG
SUVMRF9QUkVQKElDQ19DUjBfRUwxX0VOLCAxKTsNCj4gCXdyaXRlX3N5c3JlZ19zKGNyMCwgU1lT
X0lDQ19DUjBfRUwxKTsNCj4gDQo+IFRoZXJlIGFyZSBhbHNvIGluc3RhbmNlcyB3aGVyZSBtdWx0
aXBsZSB3cml0ZXMgYXJlIGJhdGNoZWQgd2l0aG91dCBhbg0KPiBpbW1lZGlhdGUNCj4gaXNiKCkg
aW4gYmV0d2Vlbiwgc3VjaCBhcyBpbiBnaWN2NV9jcHVfZW5hYmxlX2ludGVycnVwdHMoKToNCj4g
DQo+IAl3cml0ZV9zeXNyZWdfcygwLCBTWVNfSUNDX1BQSV9FTkFCTEVSMF9FTDEpOw0KPiAJd3Jp
dGVfc3lzcmVnX3MoMCwgU1lTX0lDQ19QUElfRU5BQkxFUjFfRUwxKTsNCj4gDQo+IAlnaWN2NV9w
cGlfcHJpb3JpdHlfaW5pdCgpOw0KPiANCj4gQW5kIGluIGRyaXZlcnMvaXJxY2hpcC9pcnEtZ2lj
LXY1LmM6Z2ljdjVfcHBpX3ByaW9yaXR5X2luaXQoKToNCj4gDQo+IAl3cml0ZV9zeXNyZWdfcyhS
RVBFQVRfQllURShHSUNWNV9JUlFfUFJJX01JKSwNCj4gU1lTX0lDQ19QUElfUFJJT1JJVFlSMF9F
TDEpOw0KPiAJd3JpdGVfc3lzcmVnX3MoUkVQRUFUX0JZVEUoR0lDVjVfSVJRX1BSSV9NSSksDQo+
IFNZU19JQ0NfUFBJX1BSSU9SSVRZUjFfRUwxKTsNCj4gDQo+IFRoZSBleGFjdCBzYW1lIG1pc3Np
bmcgaXNiKCkgcGF0dGVybnMgYXBwZWFyIGluIHRoZSBzZWxmdGVzdA0KPiBpbXBsZW1lbnRhdGlv
bnMNCj4gaW4gdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMva3ZtL2luY2x1ZGUvYXJtNjQvZ2ljX3Y1
LmguDQo+IA0KPiBDb3VsZCB0aGlzIGxlYXZlIHRoZSBDUFUgb3BlcmF0aW5nIHVuZGVyIGFuIGFy
Y2hpdGVjdHVyYWxseSB1bmRlZmluZWQNCj4gcGlwZWxpbmUgc3RhdGU/wqANCg0KV2hhdCBpcyAi
dW5kZWZpbmVkIHBpcGVsaW5lIHN0YXRlIj8gVGhhdCBkb2Vzbid0IG1ha2Ugc2Vuc2UuDQoNCj4g
QWNjb3JkaW5nIHRvIGFyY2hpdGVjdHVyYWwgcnVsZXMsIGV2ZXJ5IHdyaXRlIHRvIGEgY29udHJv
bC1wbGFuZQ0KPiBzeXN0ZW0NCj4gcmVnaXN0ZXIgKGluY2x1ZGluZyBhbGwgSUNDXypfRUwxIHJl
Z2lzdGVycyBleGNlcHQgSUNDX1BNUl9FTDEpIG11c3QNCj4gYmUNCj4gZm9sbG93ZWQgYnkgYW4g
aXNiKCkgYXMgdGhlIHZlcnkgbmV4dCBpbnN0cnVjdGlvbi4NCj4gDQo+IEJhdGNoaW5nIHdyaXRl
cyBvciBleGVjdXRpbmcgYW55IGluc3RydWN0aW9uIGJldHdlZW4gdGhlIHdyaXRlIGFuZA0KPiB0
aGUgaXNiKCkNCj4gbWlnaHQgbGVhZCB0byB1bnByZWRpY3RhYmxlIGJlaGF2aW9yLCBzcHVyaW91
cyB0cmFwcywgb3Iga2VybmVsDQo+IHBhbmljcy4NCj4gDQpObywgaXQgd29uJ3QuIFRoZSBJU0Ig
aXMgbm90IHJlcXVpcmVkIGluIHRoZXNlIHNpdHVhdGlvbnMgLSB3ZSdyZSBub3QNCnJlbHlpbmcg
b24gdGhlIGVmZmVjdHMgb2YgdGhlIHByZXZpb3VzIHJlZ2lzdGVyIHdyaXRlcyB0byBoYXZlDQpj
b21wbGV0ZWQsIHNvIHdlIGRvbid0IG5lZWQgYW4gSVNCLg0KDQpUaGUgb25lIGNhc2UgbWVudGlv
bmVkIGhlcmUgdGhhdCBtaWdodCBiZW5lZml0IGZyb20gYW4gSVNCIGlzDQpnaWN2NV9jcHVfZGlz
YWJsZV9pbnRlcnJ1cHRzKCksIHdoZXJlIGFuIGFkZGVkIElTQiB3b3VsZCBlbnN1cmUgdGhhdA0K
dGhlIGludGVyZmFjZSBpcyBkaXNhYmxlZCBiZWZvcmUgY29udGludWluZy4gSSdsbCBsb29rIGlu
dG8gaXQgYXMgcGFydA0Kb2YgZnV0dXJlIGZpeHVwcy4NCg0KVGhhbmtzLA0KU2FzY2hhDQo=
