Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013060.outbound.protection.outlook.com [52.101.72.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0BEA34A3DB
	for <kvmarm@lists.linux.dev>; Mon, 27 Apr 2026 16:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.72.60
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777306488; cv=fail; b=cE64pO+fAP8dUwp8322I2+bvZmmGSuj9FuJ6c1eIgVDGHdgiIRD2K3ywso+Fvk9Athg5wLoVwjvCrqLsTBDTQVFzssk02OryidhtiA04cV7hJmLnDma42AYDJ1oU+H+pSDHoPa3YpJVj54XKEoMTDC3QbnIX+F3m1NBqVgxA/HM=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777306488; c=relaxed/simple;
	bh=5VWJ533osLtdVLiVLcXeVvZywU7y4bjgu4ENHdU6wAA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=luipmCyCtlPGG+mOTPB3sAyweyw7NNXbKDsBnGF606R3rVMbt02OYxqH/656jb1SPWt7hbSDoOtVUUBzmZ2whZ9Hz/SZ2eCgiQWAY0dsQOH5SoJ6IIJSPE8deg0q7T8wlGSi0Q69OOLyknJ9/PQJ9+w6AqyRGpfu2F/sRY5N/5Y=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=hh67xTU5; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=hh67xTU5; arc=fail smtp.client-ip=52.101.72.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="hh67xTU5";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="hh67xTU5"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=BdgAQBZapGEc2FmwG76aUn38/s+inUURGUIEPq5cVgh4UrwOAGqjeIvDzUjo+QcTITFPST5QC9Gyo6LJqttLNbltlduXEyle2QxK7qZODX2ZeuxOoH6IT6brNSwKJZw1MQIHj5rXiofpoFXRHRQA6zGiLjK0iCiB0jvswJ4F42ymg0g1kWxUxCfIUUBsNoRyS61Qi71h3w4Rw3TdwwKHsRXNJ2KOHrewy+OD3i6YOh4be9Etv6BEK+SBAnc10Vy2mgzzfCczfwIIkaEUFtrfSrQTZLFYl32OTpOtxtPjbYZTigsxRh2aeuAOfCw6LjSBpFo/14fCCpiCRfonhNv3Gw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UwKVkcM/21WKqT+aGOQ1T5s1vp2PGXZy3RSFjXb7b84=;
 b=A4p/a9RocouZA6QdNWIbfPzv07cMGzBnnu4k9fiNyEZ078oFLxTwGnHCmCfJ7kxtF0bQ7PbJEaTGpAThsE0xD0SQ0H0KozTz5aZ/Ie5eE7I5Gzd+EbPhpWH8aQN3lNSsQ8WLWG1HkcYFxj0SoNerpK99ZXlLa/jwnJ9vdz9LirKTfJmdOLIhZOFKhzecmajJnmI3QVGdVDS4vdXbAAIiWFQWdsK2VELhK+ib77nqByh1x5WfNljgUVixx97sP304P14x+WwE1xiH9VrIYLHZVTsjI8Q508ktmsQz2V85ic8U+kepL+CmvGuY1ObQJgUh6yvoAyMcihKtWOMQirlFyw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UwKVkcM/21WKqT+aGOQ1T5s1vp2PGXZy3RSFjXb7b84=;
 b=hh67xTU5apwt5kiz535OFNr/tlk8MX6bEkCsya9RBVhd98BoK2gc+Y/UqMYftPo+bUPMdvGFICI8nmLrrRSetS4dJc7lzgFUzptRpO9qa9tysPFnODy+Og6/2IPycZ+VH+/VfQE8q/X4aMu+adoN7EXsX2r3VW+Uvf5EuIMaDIU=
Received: from CWLP265CA0396.GBRP265.PROD.OUTLOOK.COM (2603:10a6:400:1d6::15)
 by AS8PR08MB8565.eurprd08.prod.outlook.com (2603:10a6:20b:568::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Mon, 27 Apr
 2026 16:14:36 +0000
Received: from AMS0EPF000001A7.eurprd05.prod.outlook.com
 (2603:10a6:400:1d6:cafe::13) by CWLP265CA0396.outlook.office365.com
 (2603:10a6:400:1d6::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9846.26 via Frontend Transport; Mon,
 27 Apr 2026 16:14:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF000001A7.mail.protection.outlook.com (10.167.16.234) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9846.18
 via Frontend Transport; Mon, 27 Apr 2026 16:14:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SpcJtZ9hkkp6HYg8SsVw7R57LStKoRoF3gqAJyrwgkaCi/TWm3l2St/Ps1wjCKE2ucaLTRRn7nsLx9J7tBixurjjEXHqSgNRVOch0OQKOt72+C/vWpbCC8vkupRIg8tgO/j16U9dh6m4XMbcO2XTZYichNq0l/50JQteuJvRDUnTeiTV/QgGuWz52Uitoym1rKZSk7FeS/ar6FUQkHqZsZ2lD3bHilXQ45JGQvaNssFmw57B3Sw8bJXZ6f1WQUKZXjC1GbVeZHGcfavGAWSsraaBTHm50bslusgBmcj69jhKDPD0rRwaBNtNvHw27t/wgMbuqUNE0wMCtsbpy9t0XA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UwKVkcM/21WKqT+aGOQ1T5s1vp2PGXZy3RSFjXb7b84=;
 b=siHzlGkX9ARHNHFD/OGensAspzBySYCEIqLu98cQVItVcoPu8tme1OduY+KlbDvawnyYjKscQPZdHktPnhfg5JI+KxqgiYlGMXpDARWV8OktSILTEXWceyhv3AwtHY8/RVngHgr+9IUfISfFhmYbGRScrC72AEN+vX4YUsWfqYz2mlbxAncUSSvwxqu6dXQn0/aH/ykKjIfQz2Jdeq8hNdy27ao0p5PcNKcGXCGPEo/LbkNOfaMwkCRnvjF3h+uRObMVtSd1nGiNRBNiEhaMit9EKaaYoIg8FJ0UKWiaL2s4MdYnXO/zwN+5rlqema6Ani6xxbCcNC57iV0qFnPJjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UwKVkcM/21WKqT+aGOQ1T5s1vp2PGXZy3RSFjXb7b84=;
 b=hh67xTU5apwt5kiz535OFNr/tlk8MX6bEkCsya9RBVhd98BoK2gc+Y/UqMYftPo+bUPMdvGFICI8nmLrrRSetS4dJc7lzgFUzptRpO9qa9tysPFnODy+Og6/2IPycZ+VH+/VfQE8q/X4aMu+adoN7EXsX2r3VW+Uvf5EuIMaDIU=
Received: from VI1PR08MB3408.eurprd08.prod.outlook.com (2603:10a6:803:7c::10)
 by PAXPR08MB7383.eurprd08.prod.outlook.com (2603:10a6:102:22e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Mon, 27 Apr
 2026 16:13:33 +0000
Received: from VI1PR08MB3408.eurprd08.prod.outlook.com
 ([fe80::6daa:d2f4:acf1:84ba]) by VI1PR08MB3408.eurprd08.prod.outlook.com
 ([fe80::6daa:d2f4:acf1:84ba%7]) with mapi id 15.20.9846.025; Mon, 27 Apr 2026
 16:13:33 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, Joey Gouly
	<Joey.Gouly@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>, "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	Timothy Hayes <Timothy.Hayes@arm.com>
Subject: [PATCH 22/43] KVM: arm64: gic-v5: Add GICv5 IRS IODEV and MMIO
 emulation
Thread-Topic: [PATCH 22/43] KVM: arm64: gic-v5: Add GICv5 IRS IODEV and MMIO
 emulation
Thread-Index: AQHc1mDL92K+sHwwa0mh+R4EQHHvYg==
Date: Mon, 27 Apr 2026 16:13:33 +0000
Message-ID: <20260427160547.3129448-23-sascha.bischoff@arm.com>
References: <20260427160547.3129448-1-sascha.bischoff@arm.com>
In-Reply-To: <20260427160547.3129448-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	VI1PR08MB3408:EE_|PAXPR08MB7383:EE_|AMS0EPF000001A7:EE_|AS8PR08MB8565:EE_
X-MS-Office365-Filtering-Correlation-Id: cded0285-a599-4a7c-302d-08dea47813aa
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|366016|1800799024|38070700021|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info-Original:
 jiNrsmpAVoWADK3bppN3OUCDjFvFBVItvIKo+5mh9bqyHs96MBQy/GJH2ReGjaz2EktZIuCkahtYdP7ep1vBUGYg2ANyuJRvRFo/AgOgYMEFEABy4v1pphUEgXdZR8z/oEF+tUeFZtrZP5yHLxiPIF1f+2XAlmJzvwQvRHPM6kMsD5r9+jcZF5R5KcBgk9Dx5mkpybpClfucWECNGAu0cE3txB36BAbKMqAurrkjAYGyVeunlYt54K0B+oDrZrNaNuI2i5qkcmPiy8EbcQ72LB3dO7+mwQOFwNptNVRs2YrkJLT85iDnH3iuZzIDQLT1n8DjQUwygI3lAClWgN21VJs0ZEdTqnlGmsOLXWfB2ngohsx24qTZ1hQ1DOeC3HQMSIMrny7Ns0tMFHJQ80M3vyjYGpmUgNr/GUe+CoL05mmpa6xkb43wV+s0ohn6jExrA9u8GorHX3q06H+GKdmHH34EXgH01Wyy4FMDJuOwxfbe2AIS4/OSeDHVHhOz8qEsmH35aAXEijqwlOto0dXoe3RYyozd00zewoQKkotg9FmR6Om4XGfn+5GrGQtYTPupryZ4YX8T/kOmZ09/MPi7sXzQvMWTxQy+4GBULiC6NkxK0wFZefg7QUMvNBpxukr7H7SdKSk0wnQe9k0fgqANy/nfqCb3Ty0L2vY7Ul42PSiJYiyNUCyJTVbdx+rHkpzLsYZ2DQXvtWmO2eZHN6iE7rIe/cL4Ll5irmBHpncsKC4rK6MmiF3sSz+MQFFTdKpKwlRevv0tcH4dhiCRWJT76wkyglsFSozS5SRQMDxnBks=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3408.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700021)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 uA7roD7W9oR1Bx06IZq0Mcd/fmPBgLLYDy0KDTGEroL8vOPCbGSwcA3g3Rri0liiVhGmV7kyRyXcID40w+M6B+dtvaSSxluy7bPoISCuxCcYEXywDdnE+fEhzaxgbEUK0BYxF6WGe4x66V9iA930nwgkqjwUQJScnvU+P3wpL8o/RAbRT8WVCrFhLITVyzqclJvbMmGd+P5/infxyGCbeaer9zaMWSTiA7mw4ihDEppRl6yDz9sr3jMEJJty904M+Xh2TveRLtPxdkCTxFyXNiNZ5UuAcpvtx5wPyj5oo0ZJNGp50xH7X2728Vsf2HPrvJZ+FT3R6abX7Ezevf3KPw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR08MB7383
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF000001A7.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	3fefbf0b-7572-417e-325b-08dea477edf6
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|35042699022|36860700016|376014|1800799024|82310400026|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	QDjhhI/mnxrY1HpjpwHjVc7C6s45quuSeqgFvOlZDcADIHcYltaGhTfcAZhys9Ble+Wue0s2u1TiYlkxjLbwgGIqIFBUhzakNh5aK7Ip126UmNg1lOTGuj0SHCnjFU4fy9enJCIPgCJi1+ufCrMSGe4jr1EmsZbx1Ea/c7oluarNOcgLDUfFG2oNyCMlR7XIJS7FM7Y3enPOGx8l/DqzGII7NEmLwmPJ236SPEqDWscbx5JZ65DdnIXmIS3aogd5hngJI7Ls3aVKJIQKTwLqmTvIf38T0pJ1yUjynucgzNVhXUBwMNjGTtLebj6FYZ3Bn/zNPzHOtgLqSRy2nG6QKp+CVykpkvpuNzcJIqLQYoiPDEPRIGEHu2I+P3a1Yf9odEvzT8/DrWFwVoVy5rq6foHSG25I5GqPdU546dSD9yCQ6UWV5sr5TxURr3keM6cwUJ67INQUyANIEgvCZ3wjHS4nFTZ6x1OyVO4XxuKWVrlXDRRixw7UZ85HVSODS5Gy1A6PlLGQ8lwBHUAHIp8GFM+T1JFsaRkmejZS62SV+Ln6xMpJhAouk1QflQZ5dWnonpOPdSjqvxQbNl7HsPWWNUl4GIAw86Psy8/lkzIgqHyaeamzjEGIxVV1f6EavVeUFJ+LSmYK6Gi2ZIVTMkCNq3AmFW9hbj5qw+sTlHWRB7xsX5mBIDj0VxAMYCUHigwoQJxoHT5Mb2GcYLFJvMSyoUMyrCegTkplE6+VBhHRdiVAwJX+TEUSrLilvhjSKEY5JFm8Xs+Kwolfi03goe2xvA==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(35042699022)(36860700016)(376014)(1800799024)(82310400026)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	hV3gpZmwJT/8OlYUs4Kw/nxPuFwlhy+6abBiWnWSevntyKi6twYDs3Pz5u+k3RqoJMY1eRDXXwP+lJXETbESpvuDmvlKek96DJpDrGhyzOXWt5lzKhtU1643hdiVFqkIGsMR87e/3SeHRpZy2ghUukk6AhzW363CBhsuiHMoAAR6byFIPh7d1fmtEdmb9eE7sJNZk3dwPa3hxyw9xiRV6csKeqQCmgLv2xmv3IVRxFBe66axkxZS0/Wi/f2MtCwLAKl/xhukgRYEoGVC0tqus5b1cd9pttnkSgXePFqHali8p5iQOJeVO+ii3Gj9Tlude3c2JrNstMq5tZxfNZ+zOkz3mphUicVc09bV/CnMulszKyg7oge/E8bd707Zn4yMYxZyGXVs7Do2/pGL2kvW+wzxbnopF9jmgPn8GrwxATcu32YuMTGIxR/DyzyoKWCv
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2026 16:14:36.5111
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cded0285-a599-4a7c-302d-08dea47813aa
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF000001A7.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB8565

In order to properly support GICv5-based VMs in KVM, we need to
emulate the CONFIG_FRAME for a virtual IRS. This emulation needs to
handle all guest accesses to the MMIO region, and mimic the behaviour
of a real IRS.

Introduce an IODEV for the GICv5 IRS, and an associated init function
that sets up the SPIs and initial state for the IRS. The MMIO emulation
provides support for the guest to query the IRS_IDx registers,
manipulate SPIs, configure ISTs, and so forth.

Some of the guest's interactions with the MMIO region require KVM to
interact with the host IRS to complete the operation. One example of
this is a guest write to the emulated IRS_PE_CR0. First of all, the
guest must write to the IRS_PE_SELR register to select a PE by IAFFID
- this is the VPE ID for a VM, but the guest doesn't know this - which
is stashed. Ideally, the guest should read the IRS_PE_STATUSR at this
point in order to check that the written IAFFID is valid. At this
point, the IRS emulation code checks this, and sets the V bit
accordingly. Finally, when the guest writes to the emulated
IRS_PE_CR0, we again check that the selected VPE is valid, and then
relay this write to the host IRS via a VPE doorbell.

Similar interactions take place for SPIs too.

When it comes to the LPI IST this also requires KVM to perform actions
on behalf of the guest. When the emulated IRS_IST_BASER is written,
KVM re-allocates the IST on the host, matching the guest's
configuration (from the emulated IRS_IST_CFGR) where appropriate. This
is then provided to the physical IRS via the VMTE. As far as the guest
is concerned, the IST it allocated is being used by the hardware, but
in reality the host IST is used instead.

This change provides the IRS IODEV as a whole, but this is not plumbed
into the rest of KVM yet.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/Makefile              |   2 +-
 arch/arm64/kvm/vgic/vgic-irs-v5.c    | 823 +++++++++++++++++++++++++++
 arch/arm64/kvm/vgic/vgic-v5-tables.c |  16 +
 arch/arm64/kvm/vgic/vgic-v5-tables.h |   1 +
 arch/arm64/kvm/vgic/vgic.h           |   2 +
 5 files changed, 843 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm64/kvm/vgic/vgic-irs-v5.c

diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index 431de9b145ca1..92dda57c08766 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -24,7 +24,7 @@ kvm-y +=3D arm.o mmu.o mmio.o psci.o hypercalls.o pvtime.=
o \
 	 vgic/vgic-mmio.o vgic/vgic-mmio-v2.o \
 	 vgic/vgic-mmio-v3.o vgic/vgic-kvm-device.o \
 	 vgic/vgic-its.o vgic/vgic-debug.o vgic/vgic-v3-nested.o \
-	 vgic/vgic-v5.o vgic/vgic-v5-tables.o
+	 vgic/vgic-v5.o vgic/vgic-v5-tables.o vgic/vgic-irs-v5.o
=20
 kvm-$(CONFIG_HW_PERF_EVENTS)  +=3D pmu-emul.o pmu.o
 kvm-$(CONFIG_ARM64_PTR_AUTH)  +=3D pauth.o
diff --git a/arch/arm64/kvm/vgic/vgic-irs-v5.c b/arch/arm64/kvm/vgic/vgic-i=
rs-v5.c
new file mode 100644
index 0000000000000..729a3a3aca3a3
--- /dev/null
+++ b/arch/arm64/kvm/vgic/vgic-irs-v5.c
@@ -0,0 +1,823 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2025 ARM Limited, All Rights Reserved.
+ */
+#include <linux/bitops.h>
+#include <linux/bsearch.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <linux/kvm.h>
+#include <linux/kvm_host.h>
+#include <kvm/iodev.h>
+#include <kvm/arm_arch_timer.h>
+#include <kvm/arm_vgic.h>
+
+#include "vgic.h"
+#include "vgic-mmio.h"
+#include "vgic-v5-tables.h"
+
+static struct vgic_dist *vgic_v5_get_vgic(struct kvm_vcpu *vcpu)
+{
+	return &vcpu->kvm->arch.vgic;
+}
+
+static struct vgic_v5_irs *vgic_v5_get_irs(struct kvm_vcpu *vcpu)
+{
+	return vcpu->kvm->arch.vgic.vgic_v5_irs_data;
+}
+
+static unsigned long vgic_v5_mmio_read_irs_misc(struct kvm_vcpu *vcpu,
+						gpa_t addr, unsigned int len)
+{
+	struct vgic_v5_irs *irs =3D vgic_v5_get_irs(vcpu);
+	const size_t offset =3D addr & (SZ_64K - 1);
+	struct gicv5_cmd_info cmd_info;
+	struct kvm_vcpu *target_vcpu;
+	u64 value =3D 0;
+	int rc;
+
+	switch (offset) {
+	case GICV5_IRS_IDR0:
+		value =3D FIELD_PREP(GICV5_IRS_IDR0_DOM, irs->idr0.domain);
+		value |=3D FIELD_PREP(GICV5_IRS_IDR0_PA_RANGE, irs->idr0.pa_range);
+		value |=3D FIELD_PREP(GICV5_IRS_IDR0_VIRT, irs->idr0.virt);
+		value |=3D FIELD_PREP(GICV5_IRS_IDR0_ONEOFN, irs->idr0.one_of_n);
+		value |=3D FIELD_PREP(GICV5_IRS_IDR0_VIRT1OFN, irs->idr0.virt_one_of_n);
+		value |=3D FIELD_PREP(GICV5_IRS_IDR0_SETLPI, irs->idr0.setlpi);
+		value |=3D FIELD_PREP(GICV5_IRS_IDR0_MEC, irs->idr0.mec);
+		value |=3D FIELD_PREP(GICV5_IRS_IDR0_MPAM, irs->idr0.mpam);
+		value |=3D FIELD_PREP(GICV5_IRS_IDR0_SWE, irs->idr0.swe);
+		value |=3D FIELD_PREP(GICV5_IRS_IDR0_IRSID, irs->idr0.irs_id);
+		break;
+	case GICV5_IRS_IDR1:
+		value =3D FIELD_PREP(GICV5_IRS_IDR1_PE_CNT,
+				   atomic_read(&vcpu->kvm->online_vcpus));
+		value |=3D FIELD_PREP(GICV5_IRS_IDR1_IAFFID_BITS, vgic_v5_vmte_vpe_id_bi=
ts(vcpu));
+		value |=3D FIELD_PREP(GICV5_IRS_IDR1_PRIORITY_BITS, irs->idr1.priority_b=
its);
+		break;
+	case GICV5_IRS_IDR2:
+		value =3D FIELD_PREP(GICV5_IRS_IDR2_ISTMD_SZ, irs->idr2.istmd_sz);
+		value |=3D FIELD_PREP(GICV5_IRS_IDR2_ISTMD, irs->idr2.istmd);
+		value |=3D FIELD_PREP(GICV5_IRS_IDR2_IST_L2SZ, irs->idr2.ist_l2sz);
+		value |=3D FIELD_PREP(GICV5_IRS_IDR2_IST_LEVELS, irs->idr2.ist_levels);
+		value |=3D FIELD_PREP(GICV5_IRS_IDR2_MIN_LPI_ID_BITS, irs->idr2.min_lpi_=
id_bits);
+		value |=3D GICV5_IRS_IDR2_LPI; /* We always support LPIs */
+		value |=3D FIELD_PREP(GICV5_IRS_IDR2_ID_BITS, irs->idr2.id_bits);
+		break;
+	case GICV5_IRS_IDR5:
+		value =3D FIELD_PREP(GICV5_IRS_IDR5_SPI_RANGE, irs->idr5.spi_range);
+		break;
+	case GICV5_IRS_IDR6:
+		value =3D FIELD_PREP(GICV5_IRS_IDR6_SPI_IRS_RANGE, irs->idr6.spi_irs_ran=
ge);
+		break;
+	case GICV5_IRS_IDR7:
+		value =3D FIELD_PREP(GICV5_IRS_IDR7_SPI_BASE, irs->idr7.spi_base);
+		break;
+	case GICV5_IRS_IIDR:
+		/* Revision, Variant, ProductID are implementation defined */
+		value =3D FIELD_PREP(GICV5_IRS_IIDR_PRODUCT_ID, PRODUCT_ID_KVM);
+		value |=3D FIELD_PREP(GICV5_IRS_IIDR_VARIANT, 0);
+		value |=3D FIELD_PREP(GICV5_IRS_IIDR_REVISION, 0);
+		value |=3D FIELD_PREP(GICV5_IRS_IIDR_IMPLEMENTER, IMPLEMENTER_ARM);
+		break;
+	case GICV5_IRS_AIDR:
+		value =3D FIELD_PREP(GICV5_IRS_AIDR_COMPONENT,
+				   GICV5_AIDR_COMPONENT_IRS);
+		value |=3D FIELD_PREP(GICV5_IRS_AIDR_ARCHMAJORREV,
+				    GICV5_AIDR_ARCH_MAJ_REV_V5);
+		value |=3D FIELD_PREP(GICV5_IRS_AIDR_ARCHMINORREV,
+				    GICV5_AIDR_ARCH_MIN_REV_V0);
+		break;
+	case GICV5_IRS_CR0:
+		/*
+		 * The IRS is ALWAYS idle as we handle things instantaneously
+		 * from a guest's viewpoint.
+		 */
+		value =3D GICV5_IRS_CR0_IDLE;
+		value |=3D FIELD_PREP(GICV5_IRS_CR0_IRSEN,
+				    irs->enabled);
+		break;
+	case GICV5_IRS_CR1:
+		value =3D FIELD_PREP(GICV5_IRS_CR1_VPED_WA, irs->cr1.vped_wa);
+		value |=3D FIELD_PREP(GICV5_IRS_CR1_VPED_RA, irs->cr1.vped_ra);
+		value |=3D FIELD_PREP(GICV5_IRS_CR1_VMD_WA, irs->cr1.vmd_wa);
+		value |=3D FIELD_PREP(GICV5_IRS_CR1_VMD_RA, irs->cr1.vmd_ra);
+		value |=3D FIELD_PREP(GICV5_IRS_CR1_VPET_RA, irs->cr1.vpet_ra);
+		value |=3D FIELD_PREP(GICV5_IRS_CR1_VMT_RA, irs->cr1.vmt_ra);
+		value |=3D FIELD_PREP(GICV5_IRS_CR1_IST_WA, irs->cr1.ist_wa);
+		value |=3D FIELD_PREP(GICV5_IRS_CR1_IST_RA, irs->cr1.ist_ra);
+		value |=3D FIELD_PREP(GICV5_IRS_CR1_IC, irs->cr1.ic);
+		value |=3D FIELD_PREP(GICV5_IRS_CR1_OC, irs->cr1.oc);
+		value |=3D FIELD_PREP(GICV5_IRS_CR1_SH, irs->cr1.sh);
+		break;
+	case GICV5_IRS_SYNC_STATUSR:
+		value =3D GICV5_IRS_SYNC_STATUSR_IDLE;
+		break;
+	case GICV5_IRS_PE_SELR:
+		value =3D FIELD_PREP(GICV5_IRS_PE_SELR_IAFFID, irs->pe_selr.iaffid);
+		break;
+	case GICV5_IRS_PE_STATUSR:
+		/* We assume that the PE is Online if present. Always IDLE too */
+		value =3D GICV5_IRS_PE_STATUSR_IDLE;
+
+		/* Set ONLINE and V if IAFFID selects a present PE */
+		if (kvm_get_vcpu_by_id(vcpu->kvm, irs->pe_selr.iaffid)) {
+			value |=3D GICV5_IRS_PE_STATUSR_ONLINE;
+			value |=3D GICV5_IRS_PE_STATUSR_V;
+		}
+		break;
+	case GICV5_IRS_PE_CR0:
+		/*
+		 * Make sure that we are doing something reasonable first.
+		 * Remember, the IAFFID is the same as the VPE_ID
+		 */
+		target_vcpu =3D kvm_get_vcpu_by_id(vcpu->kvm, irs->pe_selr.iaffid);
+		if (!target_vcpu) {
+			kvm_err("Guest programmed invalid IAFFID (0x%x) into the IRS_PE_SELR\n"=
,
+				irs->pe_selr.iaffid);
+			break;
+		}
+
+		mutex_lock(&vcpu->kvm->arch.config_lock);
+
+		/*
+		 * Read the corresponding IRS_VPE_CR0. We do so via the doorbell
+		 * for the specific vcpu we have in the PE_SELR.
+		 */
+		cmd_info.cmd_type =3D VPE_CR0_READ;
+		rc =3D irq_set_vcpu_affinity(vgic_v5_vpe_db(target_vcpu), &cmd_info);
+		if (rc)
+			kvm_err("Could not read VPE_CR0 in IRS: %d\n", rc);
+		else
+			value =3D cmd_info.data;
+
+		mutex_unlock(&vcpu->kvm->arch.config_lock);
+
+		break;
+	default:
+		return 0;
+	}
+
+	return value;
+}
+
+static void vgic_v5_mmio_write_irs_misc(struct kvm_vcpu *vcpu, gpa_t addr,
+					unsigned int len, unsigned long val)
+{
+	struct vgic_v5_irs *irs =3D vgic_v5_get_irs(vcpu);
+	struct vgic_dist *vgic =3D vgic_v5_get_vgic(vcpu);
+	const size_t offset =3D addr & (SZ_64K - 1);
+	struct gicv5_cmd_info cmd_info;
+	struct kvm_vcpu *target_vcpu;
+	int rc;
+
+	switch (offset) {
+	case GICV5_IRS_CR0:
+		mutex_lock(&vcpu->kvm->arch.config_lock);
+		/*
+		 * We need to make sure that the IRS coming online (or
+		 * going offline) is visible to all vCPUs, even if
+		 * they are currently resident. Halt all of the vCPUs
+		 * now, and resume once we've done the update.
+		 */
+		kvm_arm_halt_guest(vcpu->kvm);
+
+		if (FIELD_GET(GICV5_IRS_CR0_IRSEN, val)) {
+			irs->enabled =3D true;
+			/*
+			 * This second enable is the one used by the existing,
+			 * non-GICv5 code.
+			 */
+			vgic->enabled =3D true;
+		} else {
+			irs->enabled =3D false;
+			/* Ditto */
+			vgic->enabled =3D false;
+		}
+
+		kvm_arm_resume_guest(vcpu->kvm);
+		mutex_unlock(&vcpu->kvm->arch.config_lock);
+
+		return;
+	case GICV5_IRS_CR1:
+		irs->cr1.sh =3D FIELD_GET(GICV5_IRS_CR1_SH, val);
+		irs->cr1.oc =3D FIELD_GET(GICV5_IRS_CR1_OC, val);
+		irs->cr1.ic =3D FIELD_GET(GICV5_IRS_CR1_IC, val);
+		irs->cr1.ist_ra =3D FIELD_GET(GICV5_IRS_CR1_IST_RA, val);
+		irs->cr1.ist_wa =3D FIELD_GET(GICV5_IRS_CR1_IST_WA, val);
+		irs->cr1.vmt_ra =3D FIELD_GET(GICV5_IRS_CR1_VMT_RA, val);
+		irs->cr1.vpet_ra =3D FIELD_GET(GICV5_IRS_CR1_VPET_RA, val);
+		irs->cr1.vmd_ra =3D FIELD_GET(GICV5_IRS_CR1_VMD_RA, val);
+		irs->cr1.vmd_wa =3D FIELD_GET(GICV5_IRS_CR1_VMD_WA, val);
+		irs->cr1.vped_ra =3D FIELD_GET(GICV5_IRS_CR1_VPED_RA, val);
+		irs->cr1.vped_wa =3D FIELD_GET(GICV5_IRS_CR1_VPED_WA, val);
+		return;
+	case GICV5_IRS_PE_SELR:
+		irs->pe_selr.iaffid =3D FIELD_GET(GICV5_IRS_PE_SELR_IAFFID, val);
+		return;
+	case GICV5_IRS_PE_CR0:
+		/*
+		 * Make sure that we are doing something reasonable first.
+		 * Remember, the IAFFID is the same as the VPE_ID.
+		 */
+		target_vcpu =3D kvm_get_vcpu_by_id(vcpu->kvm, irs->pe_selr.iaffid);
+		if (!target_vcpu)
+			return;
+
+		mutex_lock(&vcpu->kvm->arch.config_lock);
+
+		/*
+		 * Write the corresponding IRS_VPE_CR0. We do so via the
+		 * doorbell for the specific vcpu we have in the PE_SELR.
+		 */
+		cmd_info.cmd_type =3D VPE_CR0_WRITE;
+		cmd_info.data =3D val;
+		rc =3D irq_set_vcpu_affinity(vgic_v5_vpe_db(target_vcpu), &cmd_info);
+		if (rc)
+			kvm_err("Could not update VPE_CR0 in IRS: %d\n", rc);
+
+		mutex_unlock(&vcpu->kvm->arch.config_lock);
+		return;
+	default:
+		return;
+	}
+}
+
+static bool vgic_v5_is_spi_selr_valid(struct vgic_v5_irs *irs)
+{
+	/* Invalid - we don't have any SPIs at all */
+	if (irs->idr5.spi_range =3D=3D 0)
+		return false;
+
+	/* Invalid - we don't have any on this IRS */
+	if (irs->idr6.spi_irs_range =3D=3D 0)
+		return false;
+
+	/* Invalid - ID is less than min */
+	if (irs->spi_selr.id < irs->idr7.spi_base)
+		return false;
+
+	/* Invalid - ID is greater than max */
+	if (irs->spi_selr.id >=3D
+	    (irs->idr7.spi_base + irs->idr6.spi_irs_range))
+		return false;
+
+	return true;
+}
+
+static unsigned long vgic_v5_mmio_read_irs_spi(struct kvm_vcpu *vcpu,
+					       gpa_t addr, unsigned int len)
+{
+	struct vgic_v5_irs *irs =3D vgic_v5_get_irs(vcpu);
+	struct vgic_dist *vgic =3D vgic_v5_get_vgic(vcpu);
+	const size_t offset =3D addr & (SZ_64K - 1);
+	u64 value =3D 0;
+
+	switch (offset) {
+	case GICV5_IRS_SPI_SELR:
+		/* Return whatever was last written */
+		value =3D FIELD_PREP(GICV5_IRS_SPI_SELR_ID, irs->spi_selr.id);
+		break;
+	case GICV5_IRS_SPI_STATUSR:
+		/* We assume that we can always claim to be idle */
+		value =3D GICV5_IRS_SPI_STATUSR_IDLE;
+		value |=3D FIELD_PREP(GICV5_IRS_SPI_STATUSR_V, vgic_v5_is_spi_selr_valid=
(irs));
+		break;
+	case GICV5_IRS_SPI_DOMAINR:
+		value =3D FIELD_PREP(GICV5_IRS_SPI_DOMAINR_DOMAIN,
+				   GICV5_IRS_SPI_DOMAINR_DOMAIN_NON_SECURE);
+		break;
+	case GICV5_IRS_SPI_CFGR:
+		if (!vgic_v5_is_spi_selr_valid(irs)) {
+			/* Fault with IRS_SPI_SELR; return 0*/
+			value =3D 0;
+			break;
+		}
+
+		/* Sanity check for KVM's sake */
+		if (irs->spi_selr.id >=3D vgic->nr_spis) {
+			kvm_err("Guest trying to access SPI not backed by KVM\n");
+			value =3D 0;
+			break;
+		}
+
+		if (vgic->spis[irs->spi_selr.id].config =3D=3D VGIC_CONFIG_EDGE)
+			value =3D FIELD_PREP(GICV5_IRS_SPI_CFGR_TM, GICV5_IRS_SPI_CFGR_TM_EDGE)=
;
+		else
+			value =3D FIELD_PREP(GICV5_IRS_SPI_CFGR_TM, GICV5_IRS_SPI_CFGR_TM_LEVEL=
);
+
+		break;
+	default:
+		return 0;
+	}
+
+	return value;
+}
+
+static void vgic_v5_mmio_write_irs_spi(struct kvm_vcpu *vcpu, gpa_t addr,
+				       unsigned int len, unsigned long val)
+{
+	struct vgic_v5_irs *irs =3D vgic_v5_get_irs(vcpu);
+	const size_t offset =3D addr & (SZ_64K - 1);
+	struct vgic_irq *irq;
+
+	switch (offset) {
+	case GICV5_IRS_SPI_SELR:
+		irs->spi_selr.id =3D FIELD_GET(GICV5_IRS_SPI_SELR_ID, val);
+		return;
+	case GICV5_IRS_SPI_CFGR:
+		if (!vgic_v5_is_spi_selr_valid(irs))
+			return;
+
+		/*
+		 * Find KVM's representation of the interrupt - we need to make
+		 * sure that KVM's view agrees with the guest's, else interrupt
+		 * injection won't work properly for level-triggered interrupts
+		 * (we fail to handle the clearing of the pending state if KVM
+		 * thinks that the interrupt is edge-triggered, which is the
+		 * default.)
+		 */
+		irq =3D vgic_get_irq(vcpu->kvm, vgic_v5_make_spi(irs->spi_selr.id));
+		if (!irq)
+			return;
+
+		scoped_guard(raw_spinlock_irqsave, &irq->irq_lock) {
+			if (FIELD_GET(GICV5_IRS_SPI_CFGR_TM, val))
+				irq->config =3D VGIC_CONFIG_LEVEL;
+			else
+				irq->config =3D VGIC_CONFIG_EDGE;
+		}
+
+		vgic_put_irq(vcpu->kvm, irq);
+
+		return;
+	default:
+		return;
+	}
+}
+
+static bool vgic_v5_ist_cfgr_valid(struct vgic_v5_irs *irs)
+{
+	unsigned int expected_istsz;
+
+	if (irs->ist_cfgr.lpi_id_bits < irs->idr2.min_lpi_id_bits ||
+	    irs->ist_cfgr.lpi_id_bits > irs->idr2.id_bits)
+		return false;
+
+	if (!irs->idr2.istmd)
+		expected_istsz =3D GICV5_IRS_IST_CFGR_ISTSZ_4;
+	else if (irs->ist_cfgr.lpi_id_bits >=3D irs->idr2.istmd_sz)
+		expected_istsz =3D GICV5_IRS_IST_CFGR_ISTSZ_16;
+	else
+		expected_istsz =3D GICV5_IRS_IST_CFGR_ISTSZ_8;
+
+	if (irs->ist_cfgr.istsz !=3D expected_istsz)
+		return false;
+
+	if (irs->ist_cfgr.structure && !irs->idr2.ist_levels)
+		return false;
+
+	if (!irs->ist_cfgr.structure)
+		return true;
+
+	return irs->ist_cfgr.l2sz =3D=3D irs->idr2.ist_l2sz;
+}
+
+static unsigned long vgic_v5_mmio_read_irs_ist(struct kvm_vcpu *vcpu,
+					       gpa_t addr, unsigned int len)
+{
+	struct vgic_v5_irs *irs =3D vgic_v5_get_irs(vcpu);
+	const size_t offset =3D addr & (SZ_64K - 1);
+	u64 value =3D 0;
+
+	switch (offset) {
+	case GICV5_IRS_IST_STATUSR:
+		return GICV5_IRS_IST_STATUSR_IDLE;
+	case GICV5_IRS_IST_CFGR:
+		value =3D FIELD_PREP(GICV5_IRS_IST_CFGR_STRUCTURE, irs->ist_cfgr.structu=
re);
+		value |=3D FIELD_PREP(GICV5_IRS_IST_CFGR_ISTSZ, irs->ist_cfgr.istsz);
+		value |=3D FIELD_PREP(GICV5_IRS_IST_CFGR_L2SZ, irs->ist_cfgr.l2sz);
+		value |=3D FIELD_PREP(GICV5_IRS_IST_CFGR_LPI_ID_BITS, irs->ist_cfgr.lpi_=
id_bits);
+		break;
+	case GICV5_IRS_IST_BASER:
+		value =3D FIELD_PREP(GICV5_IRS_IST_BASER_ADDR_MASK,
+				   irs->ist_baser.addr >> GICV5_IRS_IST_BASER_ADDR_SHIFT);
+		value |=3D FIELD_PREP(GICV5_IRS_IST_BASER_VALID, irs->ist_baser.valid);
+		break;
+	default:
+		return 0;
+	}
+
+	return value;
+}
+
+static void vgic_v5_mmio_write_irs_ist(struct kvm_vcpu *vcpu, gpa_t addr,
+				       unsigned int len, unsigned long val)
+{
+	struct vgic_v5_irs *irs =3D vgic_v5_get_irs(vcpu);
+	const size_t offset =3D addr & (SZ_64K - 1);
+	struct gicv5_cmd_info cmd_info;
+	int rc;
+
+	switch (offset) {
+	case GICV5_IRS_IST_CFGR:
+		irs->ist_cfgr.lpi_id_bits =3D FIELD_GET(GICV5_IRS_IST_CFGR_LPI_ID_BITS, =
val);
+		irs->ist_cfgr.l2sz =3D FIELD_GET(GICV5_IRS_IST_CFGR_L2SZ, val);
+		irs->ist_cfgr.istsz =3D FIELD_GET(GICV5_IRS_IST_CFGR_ISTSZ, val);
+		irs->ist_cfgr.structure =3D FIELD_GET(GICV5_IRS_IST_CFGR_STRUCTURE, val)=
;
+		return;
+	case GICV5_IRS_IST_BASER: {
+		bool valid =3D FIELD_GET(GICV5_IRS_IST_BASER_VALID, val);
+
+		guard(mutex)(&vcpu->kvm->arch.config_lock);
+
+		/* Valid -> Invalid */
+		if (irs->ist_baser.valid && !valid) {
+			/* Make the LPI IST invalid and then ... */
+			cmd_info.cmd_type =3D LPI_VIST_MAKE_INVALID;
+			rc =3D irq_set_vcpu_affinity(vgic_v5_vpe_db(vcpu), &cmd_info);
+			if (WARN_ON_ONCE(rc))
+				break;
+
+			/*
+			 * ... free the host IST if we successfully marked the
+			 * IST as invalid. Frankly, if we failed to make the
+			 * guest's IST as invalid, we're cooked because it means
+			 * that the IRS may still be using the memory that we
+			 * want to free. Hence, we leave it allocated and skip
+			 * the clearing of valid bit in the baser.
+			 */
+			rc =3D vgic_v5_lpi_ist_free(vcpu->kvm);
+			if (WARN_ON_ONCE(rc))
+				break;
+		} else if (!irs->ist_baser.valid && valid) { /* Invalid -> Valid */
+			if (!vgic_v5_ist_cfgr_valid(irs)) {
+				kvm_err("Guest programmed invalid IRS_IST_CFGR\n");
+				break;
+			}
+
+			rc =3D vgic_v5_lpi_ist_alloc(vcpu->kvm,
+						   irs->ist_cfgr.lpi_id_bits);
+			if (WARN_ON_ONCE(rc))
+				break;
+		}
+
+		/* Now that we've handled the edges, update the valid bit and addr */
+		irs->ist_baser.valid =3D FIELD_GET(GICV5_IRS_IST_BASER_VALID, val);
+		irs->ist_baser.addr =3D FIELD_GET(GICV5_IRS_IST_BASER_ADDR_MASK, val)
+			<< GICV5_IRS_IST_BASER_ADDR_SHIFT;
+
+		return;
+	}
+	default:
+		return;
+	}
+}
+
+static const struct vgic_register_region vgic_v5_irs_registers[] =3D {
+	/*
+	 * This is the IRS_CONFIG_FRAME.
+	 */
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IDR0, vgic_v5_mmio_read_irs_misc,
+				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IDR1, vgic_v5_mmio_read_irs_misc,
+				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IDR2, vgic_v5_mmio_read_irs_misc,
+				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IDR3, vgic_mmio_read_raz,
+				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IDR4, vgic_mmio_read_raz,
+				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IDR5, vgic_v5_mmio_read_irs_misc,
+				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IDR6, vgic_v5_mmio_read_irs_misc,
+				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IDR7, vgic_v5_mmio_read_irs_misc,
+				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IIDR, vgic_v5_mmio_read_irs_misc,
+				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_AIDR, vgic_v5_mmio_read_irs_misc,
+				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_CR0, vgic_v5_mmio_read_irs_misc,
+				  vgic_v5_mmio_write_irs_misc, 4,
+				  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_CR1, vgic_v5_mmio_read_irs_misc,
+				  vgic_v5_mmio_write_irs_misc, 4,
+				  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_SYNCR, vgic_mmio_read_raz,
+				  vgic_mmio_write_wi, 4,
+				  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_SYNC_STATUSR,
+				  vgic_v5_mmio_read_irs_misc,
+				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_SPI_VMR, vgic_mmio_read_raz,
+				  vgic_mmio_write_wi, 8,
+				  VGIC_ACCESS_64bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_SPI_SELR, vgic_v5_mmio_read_irs_spi,
+				  vgic_v5_mmio_write_irs_spi, 4,
+				  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(
+		GICV5_IRS_SPI_DOMAINR, vgic_v5_mmio_read_irs_spi,
+		vgic_v5_mmio_write_irs_spi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_SPI_RESAMPLER, vgic_mmio_read_raz,
+				  vgic_mmio_write_wi, 4,
+				  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_SPI_CFGR, vgic_v5_mmio_read_irs_spi,
+				  vgic_v5_mmio_write_irs_spi, 4,
+				  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_SPI_STATUSR,
+				  vgic_v5_mmio_read_irs_spi, vgic_mmio_write_wi,
+				  4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_PE_SELR, vgic_v5_mmio_read_irs_misc,
+				  vgic_v5_mmio_write_irs_misc, 4,
+				  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_PE_STATUSR,
+				  vgic_v5_mmio_read_irs_misc,
+				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_PE_CR0, vgic_v5_mmio_read_irs_misc,
+				  vgic_v5_mmio_write_irs_misc, 4,
+				  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(
+		GICV5_IRS_IST_BASER, vgic_v5_mmio_read_irs_ist,
+		vgic_v5_mmio_write_irs_ist, 8, VGIC_ACCESS_64bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IST_CFGR, vgic_v5_mmio_read_irs_ist,
+				  vgic_v5_mmio_write_irs_ist, 4,
+				  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IST_STATUSR,
+				  vgic_v5_mmio_read_irs_ist, vgic_mmio_write_wi,
+				  4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_MAP_L2_ISTR, vgic_mmio_read_raz,
+				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+
+	/*
+	 * The following registers are only for running VMs. They are not yet
+	 * supported as we don't currently support nested, so expose them as
+	 * read-as-zero/write-ignored.
+	 */
+	REGISTER_DESC_WITH_LENGTH(
+		GICV5_IRS_VMT_BASER, vgic_mmio_read_raz,
+		vgic_mmio_write_wi, 8, VGIC_ACCESS_64bit),
+	REGISTER_DESC_WITH_LENGTH(
+		GICV5_IRS_VMT_CFGR, vgic_mmio_read_raz,
+		vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(
+		GICV5_IRS_VMT_STATUSR, vgic_mmio_read_raz,
+		vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(
+		GICV5_IRS_VPE_SELR, vgic_mmio_read_raz,
+		vgic_mmio_write_wi, 8, VGIC_ACCESS_64bit),
+	REGISTER_DESC_WITH_LENGTH(
+		GICV5_IRS_VPE_DBR, vgic_mmio_read_raz,
+		vgic_mmio_write_wi, 8, VGIC_ACCESS_64bit),
+	REGISTER_DESC_WITH_LENGTH(
+		GICV5_IRS_VPE_HPPIR, vgic_mmio_read_raz,
+		vgic_mmio_write_wi, 8, VGIC_ACCESS_64bit),
+	REGISTER_DESC_WITH_LENGTH(
+		GICV5_IRS_VPE_CR0, vgic_mmio_read_raz,
+		vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(
+		GICV5_IRS_VPE_STATUSR, vgic_mmio_read_raz,
+		vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(
+		GICV5_IRS_VM_DBR, vgic_mmio_read_raz,
+		vgic_mmio_write_wi, 8, VGIC_ACCESS_64bit),
+	REGISTER_DESC_WITH_LENGTH(
+		GICV5_IRS_VM_SELR, vgic_mmio_read_raz,
+		vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(
+		GICV5_IRS_VM_STATUSR, vgic_mmio_read_raz,
+		vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(
+		GICV5_IRS_VMAP_L2_VMTR, vgic_mmio_read_raz,
+		vgic_mmio_write_wi, 8, VGIC_ACCESS_64bit),
+	REGISTER_DESC_WITH_LENGTH(
+		GICV5_IRS_VMAP_VMR, vgic_mmio_read_raz,
+		vgic_mmio_write_wi, 8, VGIC_ACCESS_64bit),
+	REGISTER_DESC_WITH_LENGTH(
+		GICV5_IRS_VMAP_VISTR, vgic_mmio_read_raz,
+		vgic_mmio_write_wi, 8, VGIC_ACCESS_64bit),
+	REGISTER_DESC_WITH_LENGTH(
+		GICV5_IRS_VMAP_L2_VISTR, vgic_mmio_read_raz,
+		vgic_mmio_write_wi, 8, VGIC_ACCESS_64bit),
+	REGISTER_DESC_WITH_LENGTH(
+		GICV5_IRS_VMAP_VPER, vgic_mmio_read_raz,
+		vgic_mmio_write_wi, 8, VGIC_ACCESS_64bit),
+	REGISTER_DESC_WITH_LENGTH(
+		GICV5_IRS_SAVE_VMR, vgic_mmio_read_raz,
+		vgic_mmio_write_wi, 8, VGIC_ACCESS_64bit),
+	REGISTER_DESC_WITH_LENGTH(
+		GICV5_IRS_SAVE_VM_STATUSR, vgic_mmio_read_raz,
+		vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+
+	/* MEC, MPAM, SWERR - all unimplemented */
+
+	REGISTER_DESC_WITH_LENGTH(
+		GICV5_IRS_MEC_IDR, vgic_mmio_read_raz,
+		vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(
+		GICV5_IRS_MEC_MECID_R, vgic_mmio_read_raz,
+		vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(
+		GICV5_IRS_MPAM_IDR, vgic_mmio_read_raz,
+		vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(
+		GICV5_IRS_MPAM_PARTID_R, vgic_mmio_read_raz,
+		vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(
+		GICV5_IRS_SWERR_STATUSR, vgic_mmio_read_raz,
+		vgic_mmio_write_wi, 8, VGIC_ACCESS_64bit),
+	REGISTER_DESC_WITH_LENGTH(
+		GICV5_IRS_SWERR_SYNDROMER0, vgic_mmio_read_raz,
+		vgic_mmio_write_wi, 8, VGIC_ACCESS_64bit),
+	REGISTER_DESC_WITH_LENGTH(
+		GICV5_IRS_SWERR_SYNDROMER1, vgic_mmio_read_raz,
+		vgic_mmio_write_wi, 8, VGIC_ACCESS_64bit),
+};
+
+unsigned int vgic_v5_init_irs_iodev(struct vgic_io_device *dev)
+{
+	dev->regions =3D vgic_v5_irs_registers;
+	dev->nr_regions =3D ARRAY_SIZE(vgic_v5_irs_registers);
+
+	kvm_iodevice_init(&dev->dev, &kvm_io_gic_ops);
+
+	/* We represent both of the IRS frames back to back, so this is 128K */
+	return KVM_VGIC_V5_IRS_SIZE;
+}
+
+int vgic_v5_register_irs_iodev(struct kvm *kvm, gpa_t irs_base_address)
+{
+	struct vgic_io_device *io_device =3D &kvm->arch.vgic.vgic_v5_irs_data->io=
dev;
+	unsigned int len;
+
+	/*
+	 * Design choice: Force MMIO region to be 64k aligned. Simplifies
+	 * pulling out registers.
+	 */
+	if (!IS_ALIGNED(irs_base_address, SZ_64K)) {
+		kvm_err("IRS Base address is not aligned to 64k\n");
+		return -EINVAL;
+	}
+
+	len =3D vgic_v5_init_irs_iodev(io_device);
+
+	io_device->base_addr =3D irs_base_address;
+	io_device->iodev_type =3D IODEV_GICV5_IRS;
+	io_device->redist_vcpu =3D NULL;
+
+	return kvm_io_bus_register_dev(kvm, KVM_MMIO_BUS, irs_base_address, len,
+				       &io_device->dev);
+}
+
+/**
+ * kvm_vgic_v5_irs_init: initialize the IRS data structures
+ * @kvm: kvm struct pointer
+ * @nr_spis: number of spis, frozen by caller
+ */
+int kvm_vgic_v5_irs_init(struct kvm *kvm, unsigned int nr_spis)
+{
+	struct vgic_dist *dist =3D &kvm->arch.vgic;
+	struct vgic_v5_irs *irs =3D dist->vgic_v5_irs_data;
+	struct kvm_vcpu *vcpu0 =3D kvm_get_vcpu(kvm, 0);
+	size_t istsz, nr_spi_bits, istmd_sz;
+	phys_addr_t spi_ist_phys_base;
+	u64 mmfr0;
+	int ret;
+	int i;
+
+	/*
+	 * We (KVM) allocate an Interrupt State Table (IST) for SPIs. The
+	 * hardware mandates that lower 6 bits of the address are 0. Each ISTE
+	 * is 4 bytes in size (or larger if metadata storage is required). In
+	 * order to simplify the allocation logic, we round up the minimum
+	 * number of SPIs to 16 (2^6 =3D 64, 64/4 =3D 16).
+	 */
+	if (nr_spis && nr_spis < 16)
+		nr_spis =3D 16;
+
+	if (nr_spis) {
+		dist->spis =3D kcalloc(nr_spis, sizeof(struct vgic_irq),
+				     GFP_KERNEL_ACCOUNT);
+		if (!dist->spis)
+			return -ENOMEM;
+
+		/*
+		 * In the following code we do not take the irq struct lock since
+		 * no other action on irq structs can happen while the VGIC is
+		 * not initialized yet.
+		 */
+		for (i =3D 0; i < nr_spis; i++) {
+			struct vgic_irq *irq =3D &dist->spis[i];
+
+			irq->intid =3D vgic_v5_make_spi(i);
+			INIT_LIST_HEAD(&irq->ap_list);
+			raw_spin_lock_init(&irq->irq_lock);
+			irq->vcpu =3D NULL;
+			irq->target_vcpu =3D vcpu0;
+			refcount_set(&irq->refcount, 0);
+			/*
+			 * The guest controls the enable state, and again it is
+			 * directly handled by the hardware. From our point of
+			 * view it is always enabled.
+			 */
+			irq->enabled =3D 1;
+		}
+
+		nr_spi_bits =3D fls(roundup_pow_of_two(nr_spis)) - 1;
+
+		istsz =3D GICV5_IRS_IST_CFGR_ISTSZ_4;
+		if (vgic_v5_host_caps()->istmd) {
+			istmd_sz =3D vgic_v5_host_caps()->istmd_sz;
+
+			if (nr_spi_bits < istmd_sz)
+				istsz =3D GICV5_IRS_IST_CFGR_ISTSZ_8;
+			else
+				istsz =3D GICV5_IRS_IST_CFGR_ISTSZ_16;
+		}
+
+		ret =3D vgic_v5_spi_ist_allocate(kvm, &spi_ist_phys_base,
+					       nr_spi_bits, istsz);
+		if (ret)
+			return ret;
+
+		ret =3D vgic_v5_vmte_assign_ist(kvm, spi_ist_phys_base, false,
+					      nr_spi_bits, 0, istsz, true);
+		if (ret) {
+			vgic_v5_free_allocated_spi_ist(kvm);
+			return ret;
+		}
+	}
+
+	/* Set sane initial state for the IRS MMIO registers */
+
+	irs->idr0.domain =3D GICV5_IRS_IDR0_DOMAIN_NON_SECURE;
+
+	mmfr0 =3D read_sanitised_ftr_reg(SYS_ID_AA64MMFR0_EL1);
+	irs->idr0.pa_range =3D cpuid_feature_extract_unsigned_field(
+		mmfr0, ID_AA64MMFR0_EL1_PARANGE_SHIFT);
+
+	irs->idr0.virt =3D 0;
+	irs->idr0.one_of_n =3D 0;
+	irs->idr0.virt_one_of_n =3D 0;
+	irs->idr0.setlpi =3D 0;
+	irs->idr0.mec =3D 0;
+	irs->idr0.mpam =3D 0;
+	irs->idr0.swe =3D 0;
+	irs->idr0.irs_id =3D 0;
+
+		irs->idr1.priority_bits =3D gicv5_global_data.irs_pri_bits - 1;
+
+	/*
+	 * Support 16-bits of ID space for the IRS. This should be sufficient
+	 * for most applications, and the CPUIF is guaranteed to have at least
+	 * 16-bits of ID space support (we actually present 16-bits there, even
+	 * if the hardware supports more). Warn if the hardware doesn't support
+	 * 16 bits, and use the smaller value. YMMV!
+	 *
+	 * As for the minimum number of ID bits, we match the hardware's
+	 * capability.
+	 */
+	if (vgic_v5_host_caps()->ist_id_bits < 16)
+		pr_warn("Host IRS supports fewer than 16 ID bits for ISTs (%u)\n",
+			vgic_v5_host_caps()->ist_id_bits);
+
+	irs->idr2.id_bits =3D min(16, vgic_v5_host_caps()->ist_id_bits);
+	irs->idr2.min_lpi_id_bits =3D vgic_v5_host_caps()->min_lpi_id_bits;
+
+	/* Only allow the guest to create Linear ISTs - simplifies Save/Restore *=
/
+	irs->idr2.ist_levels =3D 0;
+	irs->idr2.ist_l2sz =3D GICV5_IRS_IST_CFGR_L2SZ_4K;
+	irs->idr2.istmd =3D 0;
+	irs->idr2.istmd_sz =3D 0;
+
+	/* We have a single IRS, only. All SPIs reside here! */
+	irs->idr5.spi_range =3D nr_spis;
+	irs->idr6.spi_irs_range =3D nr_spis;
+	irs->idr7.spi_base =3D 0;
+
+	irs->cr1.sh =3D 0;
+	irs->cr1.oc =3D 0;
+	irs->cr1.ic =3D 0;
+	irs->cr1.ist_ra =3D 0;
+	irs->cr1.ist_wa =3D 0;
+	irs->cr1.vmt_ra =3D 0;
+	irs->cr1.vpet_ra =3D 0;
+	irs->cr1.vmd_ra =3D 0;
+	irs->cr1.vmd_wa =3D 0;
+	irs->cr1.vped_ra =3D 0;
+	irs->cr1.vped_wa =3D 0;
+
+	irs->spi_selr.id =3D -1;
+
+	irs->pe_selr.iaffid =3D -1;
+
+	irs->ist_cfgr.lpi_id_bits =3D 0;
+	irs->ist_cfgr.l2sz =3D 0;
+	irs->ist_cfgr.istsz =3D 0;
+	irs->ist_cfgr.structure =3D 0;
+
+	irs->ist_baser.valid =3D 0;
+	irs->ist_baser.addr =3D 0;
+
+	return 0;
+}
diff --git a/arch/arm64/kvm/vgic/vgic-v5-tables.c b/arch/arm64/kvm/vgic/vgi=
c-v5-tables.c
index 0120c3205dea6..77fc5fb27f30d 100644
--- a/arch/arm64/kvm/vgic/vgic-v5-tables.c
+++ b/arch/arm64/kvm/vgic/vgic-v5-tables.c
@@ -578,6 +578,22 @@ int vgic_v5_vmte_release(struct kvm *kvm)
 	return 0;
 }
=20
+/*
+ * Provide a way for the IRS MMIO emulation to correctly populate the numb=
er of
+ * IAFFID bits (which correspond to our vpe_id_bits.
+ */
+u8 vgic_v5_vmte_vpe_id_bits(struct kvm_vcpu *vcpu)
+{
+	u16 vm_id =3D vgic_v5_vm_id(vcpu->kvm);
+	struct vgic_v5_vm_info *vmi;
+
+	vmi =3D xa_load(&vm_info, vm_id);
+	if (WARN_ON_ONCE(!vmi))
+		return 0;
+
+	return vmi->vpe_id_bits;
+}
+
 /*
  * Allocate a VPE descriptor and provide it to the hardware via the VPE Ta=
ble.
  */
diff --git a/arch/arm64/kvm/vgic/vgic-v5-tables.h b/arch/arm64/kvm/vgic/vgi=
c-v5-tables.h
index 6a024337eba79..25e1c9fff87b4 100644
--- a/arch/arm64/kvm/vgic/vgic-v5-tables.h
+++ b/arch/arm64/kvm/vgic/vgic-v5-tables.h
@@ -158,6 +158,7 @@ void vgic_v5_release_vm_id(struct kvm *kvm);
=20
 int vgic_v5_vmte_init(struct kvm *kvm);
 int vgic_v5_vmte_release(struct kvm *kvm);
+u8 vgic_v5_vmte_vpe_id_bits(struct kvm_vcpu *vcpu);
 int vgic_v5_vmte_alloc_vpe(struct kvm_vcpu *vcpu);
 int vgic_v5_vmte_free_vpe(struct kvm_vcpu *vcpu);
=20
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index f2f5fdc3211d7..282278e4a6c19 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -366,6 +366,7 @@ void vgic_debug_destroy(struct kvm *kvm);
 int vgic_v5_probe(const struct gic_kvm_info *info);
 void vgic_v5_reset(struct kvm_vcpu *vcpu);
 int vgic_v5_init(struct kvm *kvm);
+int kvm_vgic_v5_irs_init(struct kvm *kvm, unsigned int nr_spis);
 void vgic_v5_teardown(struct kvm *kvm);
 int vgic_v5_map_resources(struct kvm *kvm);
 void vgic_v5_set_ppi_ops(struct kvm_vcpu *vcpu, u32 vintid);
@@ -378,6 +379,7 @@ void vgic_v5_set_vmcr(struct kvm_vcpu *vcpu, struct vgi=
c_vmcr *vmcr);
 void vgic_v5_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
 void vgic_v5_restore_state(struct kvm_vcpu *vcpu);
 void vgic_v5_save_state(struct kvm_vcpu *vcpu);
+int vgic_v5_register_irs_iodev(struct kvm *kvm, gpa_t irs_base_address);
=20
 #define for_each_visible_v5_ppi(__i, __k)		\
 	for_each_set_bit(__i, (__k)->arch.vgic.gicv5_vm.vgic_ppi_mask, VGIC_V5_NR=
_PRIVATE_IRQS)
--=20
2.34.1
