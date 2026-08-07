Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011016.outbound.protection.outlook.com [40.107.130.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE5863DFC6D
	for <kvmarm@lists.linux.dev>; Fri,  7 Aug 2026 11:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.16
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786101622; cv=fail; b=Pn1VFniRm9XnYYoscKEw012jqccStDZpZPWj+WZMqpPfSUjo9Fx1vD4daPeaFESduXqybPyaHoj7FVU98zm8tRDyHrT0MkPtWfG8a35zUfnGSM8tqzVTy0RJRJ2jZ6Pkjoz6NEoJkefh4iokZWCyoPYaqxPYBNpCx8fv6iKXH4Q=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786101622; c=relaxed/simple;
	bh=AhCN3qUolk3eT/M44KStVFUwFK2lsy8jHAU/5vG1xzQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=R/bGYF7DNsEvV2LQmI9p9CfBRtNgLdgruKBkRtf+jU480OvHPC/dBjdPygbkHP5zZJMAgtEjPXrpcLyOd2d0AUEEHv7QOSNkawSPOMiSxwnrxln73Ox5NfFuGvPdayfMaioUvFL5J/GqFYWs2mn3TT1ylrjrzve5y1GIWI0f1y0=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=L8Nznec8; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=L8Nznec8; arc=fail smtp.client-ip=40.107.130.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="L8Nznec8";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="L8Nznec8"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=X4eZghwNK5a3+9op5yjUJkI5TvNbp55v52Wy0h3jCjnKotUn/GgeszlanPQqxoSQMjTwtvRV3SnDgElJEMR7H+UY0jgAiA18kmdaGvJbFndffVCgXKXehrSwZ05bU5dj5E72nFYdMZNn6yhE6hDOpkVKVnW6QluEUKlkM2MFN7d7WlEXddHk6bIdMNDvf54ws+xZPfL5k/fcczRCUQif/0fR375sb/o3IYd92jw76yYw4J5M/DpeBYgck6jBykUMRgN2slvSkQPR7OmCs5YYJ4u8fCINupTRYMUGf/twYPLcTFkCs62Y90Y8r6oMAIMP0t1yhOQeJ6MY13fMzJIBUA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kBkWtniJGFnoVd+7lxjPoyDP0ZVwaps0oJAIbzoSbkc=;
 b=fku9RjzrSMUUjmfyLIyKMayHyomG8lwzMaIfymln4lD3R8jItmHfwpKpIVUlz72WVFjrl0dwJALUIh8wkbD65ulqcM0pAnrx74b7jyg54LO+f7V8W5pO3109wjaI39nPZHbemZ2uEfhYnyvw9pnJrQfbf8MFv04JiDJ+0e/si8QHyrIbtMcS7EZkMuos0Sk/kjVV4GLB48b2mB89umIiRhwBTw8ZPcPvqxznINSNacq6k27hOHWi/L3RIFrbODOtr8nz/rcMszhzrMyfawRTveAD/e5MzIIWYo+v35dppw14rkd+CwAgHnnMtsJWSp6qOiLf2LmYFBdaBVRZbuIZmA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kBkWtniJGFnoVd+7lxjPoyDP0ZVwaps0oJAIbzoSbkc=;
 b=L8Nznec8haQqRTCxwLoQqWDD2BbB7K+9LGdxzFSHuUDqLMBcDoAJSq+Ok9SKZ3t+3KASVvlDrVbgWDNzXDFozaR9M3qAntZ0YhKXCPT+Zm5e8KuQwIeH4lgC7He8KM5j8WEwAazWBiLirZUJM8PC2sye0rRfHAz8UfQSn08/Lng=
Received: from AM0PR10CA0052.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:150::32)
 by DU4PR08MB11812.eurprd08.prod.outlook.com (2603:10a6:10:644::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.21; Fri, 7 Aug
 2026 11:20:17 +0000
Received: from AMS0EPF000001A5.eurprd05.prod.outlook.com
 (2603:10a6:20b:150:cafe::7e) by AM0PR10CA0052.outlook.office365.com
 (2603:10a6:20b:150::32) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.23 via Frontend Transport; Fri, 7
 Aug 2026 11:20:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF000001A5.mail.protection.outlook.com (10.167.16.232) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.315.6
 via Frontend Transport; Fri, 7 Aug 2026 11:20:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vkRGg54V4tFrpyg1X5YH9Ryr8IlWlyITg1hxJK2dVC3pxhTdCmOZ6GJGoTSX8xDXeKlkrEmz+PBP7WGG4VJi1CDIf6WqOHvfXvC9+oPecB+/eDmTIWH4LBFpHz1J5zq1Y4B8DskboGxGmwaeD+0h4xpHhIw3y0E4aG/XDQaiZP24QeAZr8xmph848gLCn6JB52QH1C/QQ1SFeIeADNffutSmc32iNLTR4VW1/HyscTo5z+REWa5xMX9pQd93ec8BmVU7PsFl/L/46n7DrbJ43V6eFx4UFf5F5r44wmppMQhLLBI+NIwSOiN+58/aWW8Zt5giAFkEtSRAlM3C1Ls8dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kBkWtniJGFnoVd+7lxjPoyDP0ZVwaps0oJAIbzoSbkc=;
 b=HqRQ7UBFU6OGmqsCUthGZGiWIeYB+GZ7Eeqw0ThCoyVT3x9yTle9aRVdIZVvuclYLbmYRWoMq91Is+zgEQzjbuanCnL2UKuK+ktqiCgZQJlloMFMbLJ8gqa32mZ80Wpwpr1cVdvtyqatF1rkSHMHtvAvnsOdd0jhFDemFQO1+hRNMG0LMcegVcwAwi32yZqIfg5pEHqro4OY7ZAWQSadesUoUt4okZaW61ayrhif9hYl3qdJz8dTub2kCeChaZqju4XDo/QfEmHJa190hr+IabQ9sV+Ar8iPDW7KLzN0vRSFkND04ObsA+v4BVZWKDUaqa+bXJ1GmLN1Ifj+0RfUhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kBkWtniJGFnoVd+7lxjPoyDP0ZVwaps0oJAIbzoSbkc=;
 b=L8Nznec8haQqRTCxwLoQqWDD2BbB7K+9LGdxzFSHuUDqLMBcDoAJSq+Ok9SKZ3t+3KASVvlDrVbgWDNzXDFozaR9M3qAntZ0YhKXCPT+Zm5e8KuQwIeH4lgC7He8KM5j8WEwAazWBiLirZUJM8PC2sye0rRfHAz8UfQSn08/Lng=
Received: from GV1PR08MB8428.eurprd08.prod.outlook.com (2603:10a6:150:81::5)
 by GV2PR08MB8725.eurprd08.prod.outlook.com (2603:10a6:150:b4::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.23; Fri, 7 Aug
 2026 11:19:43 +0000
Received: from GV1PR08MB8428.eurprd08.prod.outlook.com
 ([fe80::9b97:c973:3308:5ba7]) by GV1PR08MB8428.eurprd08.prod.outlook.com
 ([fe80::9b97:c973:3308:5ba7%5]) with mapi id 15.21.0292.018; Fri, 7 Aug 2026
 11:19:43 +0000
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
Subject: [PATCH v5 14/49] KVM: arm64: gic-v5: Set up VMTEs and VPE doorbells
Thread-Topic: [PATCH v5 14/49] KVM: arm64: gic-v5: Set up VMTEs and VPE
 doorbells
Thread-Index: AQHdJl6lx9MNaBreRUOkFnaJF1gqlA==
Date: Fri, 7 Aug 2026 11:19:43 +0000
Message-ID: <20260807111159.429128-15-sascha.bischoff@arm.com>
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
	GV1PR08MB8428:EE_|GV2PR08MB8725:EE_|AMS0EPF000001A5:EE_|DU4PR08MB11812:EE_
X-MS-Office365-Filtering-Correlation-Id: 5ebdd8bc-ed56-41c5-8707-08def475dbe3
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|23010399003|366016|1800799024|38070700021|6133799003|10067099003|11063799006|5023799004|56012099006|22082099003|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info-Original:
 /MDaDbnxDJq1Z1+3W/icaguPmKq4J6iZ7IMS2mpEZwqfnfhXfN2Jmn2wYHKgSZ4vbc3rsB5IqQRS7zzCMSpq25KL4jJ6k9ZSwg1MZ5QuBKrVPhSRLwuhsbt2LXQMB585IEsN8i2EMTtkcYqnICZTejawUhyA+ntfccocLqgXvgP7P79zUGfNX9YaORKSmhgnLztxLeF+3T/99F1C20olAe0Xft2yNwSOQEh5VR/hJfNpsUAjfOmTbUsUvnuIQWL6ok2iKh0fD+PMK777PqEd1S8lS457r4OmjhvUVCkQtp+HEx+q/tssFblXBymF7cRwSRvagmOV2BNFDrF3vsrfkhT1hIVdo/PcN9mXoM2lSU5q+L5P0cjCXRx/rxn7/dX+nvyNaj2ANB/oonE4lyRCllAqZ5o+QB0hkTeZXx5+5QlRgX+jUksB1Wj1ZZTmxDsfNY0eJjrgUVysMaqQuMx/l0ed5jHTKim1gvWY4J1FTzO7aYCjFSuaS8xs/6TTaJl0HwYQl7FjVk67gpocEOmw7p6CJcvgyLihK9ge8tcronMNet/5hiXQEAp0kjqYsqB6932gyY3TxD4RkUnmu0oKt36d0qW38gBbdVtg4heECWKk61KeVuB7ZJDty1ZkvGhf38/QMA1zImKD4PmcR5NE2BtiFOkyTldC6v2YwIh+B9yG87rNJFu6+JbqmgfCPH5IUlbvtfh1eqsopfzLOIIaCtMWCMVODzyMMhE9vVE3u9M=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB8428.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(366016)(1800799024)(38070700021)(6133799003)(10067099003)(11063799006)(5023799004)(56012099006)(22082099003)(18002099003)(3023799007);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 OsS8c2UpYM4PcKPefqQKTKce+xypLDc/PYG9HEclxf3NGXMn54SzHTW/h2Au/v0MfViX+rr0xeuu+aKHp7uT8FSTK4MHKBq6sbm7DocOvWJvtp5lDpvBQyLuQ19MZYeJ2VmybLEcUqZDchMpZADJC4sABSmcPM8rj9L0Oic8+F7kb9UkwKw1bVR77hX3vI54n3dDlfKyVzZJ0mdmebz5BmwxUHVbBY0YC1LzZfD8XJ7S1Mc63E2++rPaVXyIpG0gDWag980oL7IKMBqrc5oYPVBa9kcpJImmjcB7P1TTe+/VsHSK8/89dSOjNb8KwusiUNtmEPmlnEliqwQykUYx1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR08MB8725
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF000001A5.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	d1f243c7-6e50-4108-3dcf-08def475c817
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|35042699022|36860700016|376014|23010399003|14060799003|82310400026|56012099006|18002099003|22082099003|3023799007|6133799003|10067099003|11063799006|5023799004;
X-Microsoft-Antispam-Message-Info:
	uslNyISB73qGWCWGiD45S99R4L6GiRyx1hGkBFRHlIil5im1ZGqW+mieHHIteG39jFvfAaDFYN1lxyPNJ1t/W8mSU68Tku/LkODmyyJwtF+9ZRGCd97FD9IbZiHoSOVkaABrQXHyVJbn0DwBYIQes3LfGa8ij4u/mlX8/XCN3qx+aOfbgMQHg1rucHhMpmKO1GucXw/dBtLqbF7scsIJGelRpyr6gjIddJsaFIYX8FYIjo+faZLmbV4uN2AbOdB/Pda+75gqZiF4usr2e3UxKjshhjIIkzpLLfgHZ4IOXbZKaOCXcr5vyoZ3ouGMDzTamSkLfiN8BcehC2DakpFBTp5SI09XODTqB2IWMHAWSebbnXrWqrz/adbcMtOA4Nbg05Y+/CRmD6SWvBlbB7Ekzqj/aHizOX5/xOOp9YoIdPoaxZAVV7n0A4a8uXMcjgPA98gtMZ1JnCB29oSO47Fpx+msEALfmBlN+nCcn/gQDbjkSCOnEUE9DyHQodJTgFJ5SK92M6ZbbcbwNytpSXLjiDs6i3Fe48vmv4GjQBjagwlGoVtDLF8Kp8Thd6UrO1k3bdoTaXFf5qRL02mo2iNUsbZoW9B4bOPf8+yRFJKOKT7fTgFNLiqFNF9q0y8jubkyLRjeOlwd1T5abKOGhQQOk0OrJ/qGpHdTt6s3hehLY9CAI7H1b0WUbnn0NfbI4qxjfs0yv9qr3SLYGKQR0Ln15g==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(35042699022)(36860700016)(376014)(23010399003)(14060799003)(82310400026)(56012099006)(18002099003)(22082099003)(3023799007)(6133799003)(10067099003)(11063799006)(5023799004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	7B1UjowUq95MzC16z0cPWrTmgQgUqzG1PunAzrEo2Do7YkWL2OscCZICznSkTPaSykJEw84+2fDQFaN6eW2iS3l8yrLH6E2K7YsogoaxwQlytDzFKmokUrV/8N2Fd9wNRFd2Bjpzpo0FK265oxHVSKXfji7l7P+uOBOUiqeqTTM7ILCti9TJ+tafroJNeclJhOA/aCzxO0uToEPbG3Dlq4XIWKscUFYzXUh1iTTy/priNj8xwPIPco8jaeujdJ+6jLyHLf9PWCbpqDF2jwPbp/xHT2k+IBwhSc1UOwNJxKQYjUG6mN4kLgLxxZYozLRogpmxPU3rBk6GF1LtDaAO7jFpFezahsl++sgd69LrCU5HheXPtMH4RQttFI14GwrYrc3/X7jXuvOdaRwPGV3ZZywuVQCIsH3fPO9Ny+WfIJeEJYvRS15EbRDHVNFGt/ZO
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2026 11:20:16.9539
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ebdd8bc-ed56-41c5-8707-08def475dbe3
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF000001A5.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU4PR08MB11812

A GICv5 VM needs a VM table entry before it can use SPIs and LPIs,
which are backed by the host IRS. The VM table itself is created at
probe time, but each VM still needs to claim and populate one VMTE
before it can use those interrupts.

VPE doorbells are allocated from the host LPI irq domain. Without that
domain, KVM cannot issue IRS commands or receive doorbell wakeups.
Fail the GICv5 KVM probe if the host driver did not create an LPI
domain.

Allocate a VM ID during vgic_v5_init(). The VM ID is also the index
into the VM table, so allocating it selects the VMTE slot that will be
used for the lifetime of the VM.

Create a per-VM VPE doorbell irq domain, allocate one doorbell
interrupt per vCPU, request the interrupts, and keep the doorbell IRQ
number in the vCPU's GICv5 state. The doorbell handler marks the VPE
doorbell as fired, raises KVM_REQ_IRQ_PENDING, and kicks the target
vCPU so that KVM can re-evaluate pending interrupt state.

The doorbell domain indexes its interrupts using the dense vcpu_idx,
while GICv5 uses the userspace-provided vcpu_id as the VPE ID. Store a
backpointer to the VM and use it to resolve the vCPU before issuing
VPE-specific IRS commands. This preserves the userspace VPE ID when
vCPU IDs are sparse.

With the VM ID and doorbells in place, initialise the VMTE backing
state, including the VM descriptor, VPE table, and preallocated VPED
storage. The doorbells have to exist before making the VMTE valid, as
they provide the IRQ-side conduit used by the IRS commands. Make the
VMTE valid via the IRS, then populate the VPETE for each vCPU.

Add vgic_v5_teardown() to unwind the state in the reverse order. Make
the VMTE invalid, clear the per-vCPU VPETEs, release the VMTE backing
state, free the doorbell IRQs and irq domain, and finally release the
VM ID so that the VMTE slot can be reused by a later VM. If hardware
invalidation or VMTE release fails, still free the software doorbells
and domain, but keep the VM ID allocated so that the VMTE slot is not
reused while hardware-visible state may remain.

On init failure, call the same teardown path so that partially created
state is unwound consistently.

As part of resetting vCPUs, mark them as valid in the VM's VPE table.
This informs the IRS that a specific VPE may be made resident. Without
this, the IRS will treat the VPE as invalid.

Also introduce vgic_v5_send_command(), a wrapper around the VPE
doorbells. It takes a struct kvm_vcpu pointer and the command to run,
and invokes the function bound to that command through the vCPU's
doorbell.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-v5.c | 228 +++++++++++++++++++++++++++++-----
 include/kvm/arm_vgic.h        |   2 +
 2 files changed, 197 insertions(+), 33 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index 2121f67d3b59c..f15a8309d7a93 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -100,6 +100,11 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
 		goto skip_v5;
 	}
=20
+	if (!gicv5_global_data.lpi_domain) {
+		kvm_err("GICv5 LPI domain unavailable\n");
+		return -ENODEV;
+	}
+
 	vgic_v5_irs_cache_id_regs(info);
 	vgic_v5_get_implemented_ppis();
=20
@@ -384,12 +389,35 @@ static int vgic_v5_irs_set_up_vpe(u16 vm_id, u16 vpe_=
id,
 	return 0;
 }
=20
+static irqreturn_t db_handler(int irq, void *data)
+{
+	struct kvm_vcpu *vcpu =3D data;
+
+	WRITE_ONCE(vcpu->arch.vgic_cpu.vgic_v5.gicv5_vpe.db_fired, true);
+
+	kvm_make_request(KVM_REQ_IRQ_PENDING, vcpu);
+	kvm_vcpu_kick(vcpu);
+
+	return IRQ_HANDLED;
+}
+
+static int vgic_v5_send_command(struct kvm_vcpu *vcpu, enum gicv5_vcpu_cmd=
 cmd)
+{
+	int irq =3D vgic_v5_vpe_db(vcpu);
+
+	if (!irq)
+		return -ENXIO;
+
+	return irq_set_vcpu_affinity(irq, &cmd);
+}
+
 static int vgic_v5_db_set_vcpu_affinity(struct irq_data *data, void *vcpu_=
info)
 {
 	struct vgic_v5_vm *vm =3D data->domain->host_data;
 	enum gicv5_vcpu_cmd *cmd =3D vcpu_info;
-	/* Our VPE ID is the index within the doorbell domain */
-	u16 vpe_id =3D data->hwirq;
+	unsigned int vcpu_idx =3D data->hwirq;
+	struct kvm_vcpu *vcpu;
+	u16 vpe_id;
=20
 	guard(raw_spinlock_irqsave)(&vgic_v5_irs_lock);
=20
@@ -401,6 +429,17 @@ static int vgic_v5_db_set_vcpu_affinity(struct irq_dat=
a *data, void *vcpu_info)
 	case VMTE_MAKE_INVALID:
 		return vgic_v5_irs_set_vm_invalid(vm->vm_id);
 	case VPE_MAKE_VALID:
+		/*
+		 * The index in the doorbell domain aligns with our flat
+		 * vcpu_idx index. However, we need the actual VPE ID, which
+		 * means we first need to resolve the actual vcpu.
+		 */
+		vcpu =3D kvm_get_vcpu(vm->kvm, vcpu_idx);
+		if (!vcpu)
+			return -EINVAL;
+
+		vpe_id =3D vgic_v5_vpe_id(vcpu);
+
 		/*
 		 * We need the actual LPI ID which lives in the top-most parent
 		 * domain. This hwirq won't include the type (LPI) but that's
@@ -456,15 +495,9 @@ static int vgic_v5_irq_db_domain_alloc(struct irq_doma=
in *domain,
 				       void *arg)
 {
 	const struct irq_chip *chip =3D &vgic_v5_db_irq_chip;
-	struct vgic_v5_vm *vm =3D arg;
 	struct irq_data *irqd;
 	int ret;
=20
-	if (!vm) {
-		kvm_err("invalid parameter for doorbell irq allocation\n");
-		return -EINVAL;
-	}
-
 	ret =3D irq_domain_alloc_irqs_parent(domain, virq, nr_irqs, NULL);
 	if (ret)
 		return ret;
@@ -491,20 +524,10 @@ static int vgic_v5_create_per_vm_domain(struct kvm *k=
vm)
 	int id =3D task_pid_nr(current);
 	int ret, db_virq =3D 0;
=20
-	if (!gicv5_global_data.lpi_domain) {
-		kvm_err("LPI domain uninitialized, can't set up KVM Doorbells\n");
-		return -ENODEV;
-	}
-
 	vm->fwnode =3D irq_domain_alloc_named_id_fwnode("GICv5-vpe-db", id);
 	if (!vm->fwnode)
 		return -ENOMEM;
=20
-	/*
-	 * KVM per-VM VPE DB domain; child of LPI domain; only ever handles
-	 * doorbells. We know how many doorbells we have, and therefore we
-	 * create a linear domain.
-	 */
 	vm->domain =3D irq_domain_create_hierarchy(gicv5_global_data.lpi_domain,
 						 0, nr_vcpus, vm->fwnode,
 						 &vgic_v5_irq_db_domain_ops, vm);
@@ -543,11 +566,6 @@ static void vgic_v5_teardown_per_vm_domain(struct vgic=
_v5_vm *vm)
 	if (!vm->domain)
 		return;
=20
-	if (vm->vpe_db_base) {
-		irq_domain_free_irqs(vm->vpe_db_base, vm->domain->revmap_size);
-		vm->vpe_db_base =3D 0;
-	}
-
 	irq_domain_remove(vm->domain);
 	irq_domain_free_fwnode(vm->fwnode);
 	vm->domain =3D NULL;
@@ -567,33 +585,121 @@ void vgic_v5_reset(struct kvm_vcpu *vcpu)
 	 * CPUIF (but potentially fewer in the IRS).
 	 */
 	vcpu->arch.vgic_cpu.num_pri_bits =3D 5;
+
+	/* Make the VPE valid in the VPET */
+	if (WARN_ON(vgic_v5_send_command(vcpu, VPE_MAKE_VALID)))
+		return;
+}
+
+static void vgic_v5_free_doorbells(struct kvm *kvm, unsigned int nr_dbs)
+{
+	struct vgic_v5_vm *vm =3D &kvm->arch.vgic.gicv5_vm;
+	struct kvm_vcpu *vcpu;
+	unsigned long i;
+	int db;
+
+	for (i =3D 0; i < nr_dbs; i++) {
+		vcpu =3D kvm_get_vcpu(kvm, i);
+		db =3D vgic_v5_vpe_db(vcpu);
+		if (!db)
+			continue;
+
+		free_irq(db, vcpu);
+		vcpu->arch.vgic_cpu.vgic_v5.gicv5_vpe.db =3D 0;
+	}
+
+	if (vm->vpe_db_base) {
+		irq_domain_free_irqs(vm->vpe_db_base,
+				     atomic_read(&kvm->online_vcpus));
+		vm->vpe_db_base =3D 0;
+	}
 }
=20
 void vgic_v5_teardown(struct kvm *kvm)
 {
+	struct vgic_dist *dist =3D &kvm->arch.vgic;
+	struct kvm_vcpu *vcpu, *vcpu0;
+	bool release_vm_id =3D true;
+	unsigned long i;
+	int rc;
+
+	lockdep_assert_held(&kvm->arch.config_lock);
+
+	/*
+	 * If the VM's ID isn't valid, then we either failed init very early or
+	 * we've been called a second time. Nothing to do here in either case.
+	 */
+	if (kvm->arch.vgic.gicv5_vm.vm_id =3D=3D VGIC_V5_VM_ID_INVAL)
+		return;
+
+	if (kvm->arch.vgic.gicv5_vm.vmte_allocated) {
+		/* Make the VM invalid  */
+		vcpu0 =3D kvm_get_vcpu(kvm, 0);
+		rc =3D vgic_v5_send_command(vcpu0, VMTE_MAKE_INVALID);
+		if (rc) {
+			kvm_err("could not make VMTE invalid\n");
+			release_vm_id =3D false;
+			goto out_free_doorbells;
+		}
+
+		kvm_for_each_vcpu(i, vcpu, kvm) {
+			if (vgic_v5_vmte_free_vpe(vcpu)) {
+				kvm_err("Failed to free VPE\n");
+				release_vm_id =3D false;
+			}
+		}
+
+		if (vgic_v5_vmte_release(kvm)) {
+			kvm_err("Failed to release VM 0x%x\n", dist->gicv5_vm.vm_id);
+			release_vm_id =3D false;
+		}
+	}
+
+out_free_doorbells:
+	vgic_v5_free_doorbells(kvm, atomic_read(&kvm->online_vcpus));
 	vgic_v5_teardown_per_vm_domain(&kvm->arch.vgic.gicv5_vm);
+
+	/*
+	 * We only release the VM ID itself if we didn't fail earlier. It does
+	 * mean that we might lose the VM ID (and associated VMTE, etc), but
+	 * given that we've failed to tear them down correctly there's no way to
+	 * safely reuse them. The VM ID allocating IDA will make sure we don't
+	 * accidentally reuse this partially torn down state.
+	 */
+	if (release_vm_id)
+		vgic_v5_release_vm_id(kvm);
 }
=20
+/*
+ * Claim and populate a VMTE (optionally making a new L2 VMT valid), creat=
e VPE
+ * doorbells, allocate VPET and populate for each VPE.
+ *
+ * Note: We do need to put the cart before the horse here. The VPE doorbel=
ls are
+ * our conduit for communication with the IRS, which means we need to have=
 those
+ * before making the VMTE valid.
+ *
+ * On failure, we clean up in the teardown path (vgic_v5_teardown()).
+ */
 int vgic_v5_init(struct kvm *kvm)
 {
-	struct kvm_vcpu *vcpu;
-	unsigned long idx;
-	int ret;
+	struct kvm_vcpu *vcpu, *vcpu0;
+	int nr_vcpus, ret =3D 0;
+	unsigned int db_virq;
+	unsigned long i;
=20
-	if (vgic_initialized(kvm))
-		return 0;
+	lockdep_assert_held(&kvm->arch.config_lock);
+
+	nr_vcpus =3D atomic_read(&kvm->online_vcpus);
+	if (nr_vcpus =3D=3D 0)
+		return -ENODEV;
=20
-	kvm_for_each_vcpu(idx, vcpu, kvm) {
+	kvm_for_each_vcpu(i, vcpu, kvm) {
 		if (vcpu_has_nv(vcpu)) {
 			kvm_err("Nested GICv5 VMs are currently unsupported\n");
 			return -EINVAL;
 		}
 	}
=20
-	ret =3D vgic_v5_create_per_vm_domain(kvm);
-	if (ret)
-		return ret;
-
 	/* We only allow userspace to drive the SW_PPI, if it is implemented. */
 	bitmap_zero(kvm->arch.vgic.gicv5_vm.userspace_ppis,
 		    VGIC_V5_NR_PRIVATE_IRQS);
@@ -602,7 +708,63 @@ int vgic_v5_init(struct kvm *kvm)
 		   kvm->arch.vgic.gicv5_vm.userspace_ppis,
 		   ppi_caps.impl_ppi_mask, VGIC_V5_NR_PRIVATE_IRQS);
=20
+	ret =3D vgic_v5_allocate_vm_id(kvm);
+	if (ret)
+		return ret;
+
+	/*
+	 * Stash a backpointer to struct kvm. It is required to resolve the VPE
+	 * ID from the doorbell index, which matches the flat vcpu_idx and not
+	 * the vcpu_id.
+	 */
+	kvm->arch.vgic.gicv5_vm.kvm =3D kvm;
+
+	ret =3D vgic_v5_create_per_vm_domain(kvm);
+	if (ret)
+		goto err;
+
+	db_virq =3D kvm->arch.vgic.gicv5_vm.vpe_db_base;
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		ret =3D request_irq(db_virq + i, db_handler, 0, "vcpu", vcpu);
+		if (ret)
+			goto err;
+
+		/* Stash it with the VCPU for easy retrieval */
+		vcpu->arch.vgic_cpu.vgic_v5.gicv5_vpe.db =3D db_virq + i;
+	}
+
+	/* Populate VMTE (with VPET and VM descriptor) */
+	ret =3D vgic_v5_vmte_init(kvm);
+	if (ret)
+		goto err;
+
+	/* We pick the first vcpu to make the VMTE valid - any would do */
+	vcpu0 =3D kvm_get_vcpu(kvm, 0);
+	ret =3D vgic_v5_send_command(vcpu0, VMTE_MAKE_VALID);
+	if (ret)
+		goto err;
+
+	/* Populate the VPETE for each VPE. */
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		ret =3D vgic_v5_vmte_alloc_vpe(vcpu);
+		if (ret)
+			goto err;
+	}
+
 	return 0;
+
+err:
+	/*
+	 * Explicitly tear everything down on failure. The teardown function is
+	 * written to handle any partial state we might have, so we don't need
+	 * to do any clean-up first. Teardown will be called a second time on VM
+	 * destruction, but that's fine - it is better to leave things in a
+	 * clean state now, and doubly so because userspace could actually go
+	 * and retry init.
+	 */
+	vgic_v5_teardown(kvm);
+
+	return ret;
 }
=20
 int vgic_v5_map_resources(struct kvm *kvm)
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 6d0cc38efa673..7fece54ff0925 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -371,6 +371,8 @@ struct vgic_redist_region {
 #define VGIC_V5_VM_ID_INVAL		(-1)
=20
 struct vgic_v5_vm {
+	struct kvm		*kvm;
+
 	/*
 	 * We only expose a subset of PPIs to the guest. This subset is a
 	 * combination of the PPIs that are actually implemented and what we
--=20
2.34.1
