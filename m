Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012007.outbound.protection.outlook.com [52.101.66.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 295E73E9580
	for <kvmarm@lists.linux.dev>; Thu, 19 Mar 2026 15:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.7
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773935644; cv=fail; b=scksQWzTf8SnGsLsHyEzvXNr+9VD+ZwKJqRx/5AnA0BC2wFMTCS9B+S/C0K7caPhGqhifRDn5gLogzzYz2i0TUlXBrydZFsfNrLzSlM9Jb5ypIgZy+0h2ZNStngXe9UJVITpgWYr+bPaX69Tc3GH3eHgyfJT8Cowpz/PV/2aqEA=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773935644; c=relaxed/simple;
	bh=rVQEetLyQLhTb8tWIZ3v03i1oT79KC6XJnztAlAhd/o=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ntR2b//5QSG8bClzW6EGhl28KWBe/X42zuqdoMRAcD2e954N+3RXsGLf7YwUCoELyYQNl3tLwyTqZwYudVfNp4k2ZjmvkB32RJnC2FoUtFXXrFkKCVPFcXPS7SrbRcCFOLYw0r1Pl10A7PbgCWvZC1c6Cqof63cS25r7IKjZxCk=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=PBdaHwiM; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=PBdaHwiM; arc=fail smtp.client-ip=52.101.66.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="PBdaHwiM";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="PBdaHwiM"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=dTAXnRt4sRYMZcIZ1sTjEoxX1dd+SQW3H3Ry5RJV2V54+59MQVEXW+xPkCBAVDk9XlPBQ2/LtwRa4uF1qWwwM5rxEVrPD5ADbizVrkRBcEuFiqv/45Ydwi+ue1GfHqejvf75rhlvUTLmyEtJyE7gCAuFNxIhKHEomAYZpO2Jpy6/j1m2WFAPkFCfbz26zLmX1SK9ozG4bIFhW+rQUCoaR5wdybspb7Tx+FRNzrz7w7bsolNYQBGxfsF7DciPlUXdwodJKUmRkW9EjG5bKzJYxnU2NNUO516mrBQJlYdE/4jd+Au7YKyc0I9G+EY0Z+viLQFQojTH/HH196Jx0yhOaQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hlHfzMTgcI/hHuaTDHtB95wiVf99CmBUXGQZO8V4tfU=;
 b=bLtj4ITwcsp8WOunKwpssdmbf4gT3CAlmLuNYEvAVg6fyAwyoRxzp9pobTSD0qZgSNRIjQcor2UyF7PpduSHoMmKRdVK663bKPrMCGZU2uRrq2jMh3J0oc/tW7GyZpOehqcBqRfNVCaxbkOSGVID3FOL4lxPCTcmJfWU7iPG3VibJxqJPhv/up6NNrZ6LrL8a1RQlOC5lGGRfU5Z3PPo168TL5kHam6QO4/ioTHWVkoTqjiFq8H44kh9uJ3PFJito8efrXAbFSUtXWpA8TSqREbkmPqXufua1fQXytGt4XQmUl0RQbwcj6wA9F3c+x2LYhnF22GSftAhzMjGmsjtXA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hlHfzMTgcI/hHuaTDHtB95wiVf99CmBUXGQZO8V4tfU=;
 b=PBdaHwiMF6QwY3dtdcbvsBaKlOWckm8u89zbOqSVpJ8syFjRo66XFwA/RnmG2eOgLSXudwwxstHjx/XL1w1gvZ+MNoOrHd5gnTdM+Z6OGv3rtXs+aIZieVfTmqVPfRk/Rm3T1pCRUCkOXn6UK+4KQw20PAmEEJOO/NHjk3VBqOQ=
Received: from DU2PR04CA0012.eurprd04.prod.outlook.com (2603:10a6:10:3b::17)
 by DU0PR08MB8068.eurprd08.prod.outlook.com (2603:10a6:10:3eb::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.16; Thu, 19 Mar
 2026 15:53:54 +0000
Received: from DB1PEPF0003922D.eurprd03.prod.outlook.com
 (2603:10a6:10:3b:cafe::fc) by DU2PR04CA0012.outlook.office365.com
 (2603:10a6:10:3b::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.19 via Frontend Transport; Thu,
 19 Mar 2026 15:53:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF0003922D.mail.protection.outlook.com (10.167.8.100) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.19
 via Frontend Transport; Thu, 19 Mar 2026 15:53:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=v+MDteuvgPVSJCunOBqmuc8twqAM6vIpnQJvV8GdmYA/KZQqIeAf3hNj+ZVNg1JRnI3vEUZMfycSr1bFWkXh0JVoFsIPGxj9PcQecrgSdQvB4hWZCGBT8MhpNYQW8yQIQzKy4nqwTxNe8JGFWJt6DgL4N383vOm0R1T8qi0gpvgCQHxB9WGk1TjKvXxKuSPZxiD483fQce8dxNz/xaKiwRziRtpNN/VnonCOAwBE6csR9eqN7fF4xaNcnt7oLpgQhOhZHskp90C+gcc4zuPwfkYCxsJwzyNdE/gINSF84Xv4G3yWgE7uwRGrcYayfS2qdD3EmnpXweno1BNvgDPG6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hlHfzMTgcI/hHuaTDHtB95wiVf99CmBUXGQZO8V4tfU=;
 b=mzk+kAJdJJrdAt7V2O60ZrTyG+wuZgyMEIGoMHql22Xjd4/qrRFgcwZDcqLXGFe81VIS1DqB53LkHyFteiaUMEcjq/K/06qGTKyCUC/JgjOJrss6ZvW8G4AyWyIXVbm0LSX/DSSy/ZEahTK+p6OgWnhuK1xBiYIk6mW0i1qpjWHWveO+NW4vKmkMt9kDkI0I9ZJ0gpVS8SZdEMJd15NIH47H2QO23AzY2SglUJzB2kqezYvvE4NJNWIct1N9aleDFRLUTQ0Aq90OGgESYxu6WrYyj3nRn7uOBTxLyZK6L9juqq9Tpyc93fcAgFPq71RPJ6pwz0gEp7LbLZDY3mu30g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hlHfzMTgcI/hHuaTDHtB95wiVf99CmBUXGQZO8V4tfU=;
 b=PBdaHwiMF6QwY3dtdcbvsBaKlOWckm8u89zbOqSVpJ8syFjRo66XFwA/RnmG2eOgLSXudwwxstHjx/XL1w1gvZ+MNoOrHd5gnTdM+Z6OGv3rtXs+aIZieVfTmqVPfRk/Rm3T1pCRUCkOXn6UK+4KQw20PAmEEJOO/NHjk3VBqOQ=
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com (2603:10a6:20b:504::10)
 by PA4PR08MB6191.eurprd08.prod.outlook.com (2603:10a6:102:f3::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Thu, 19 Mar
 2026 15:52:50 +0000
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27]) by AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27%6]) with mapi id 15.20.9723.018; Thu, 19 Mar 2026
 15:52:50 +0000
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
Subject: [PATCH v7 12/41] KVM: arm64: gic-v5: Sanitize ID_AA64PFR2_EL1.GCIE
Thread-Topic: [PATCH v7 12/41] KVM: arm64: gic-v5: Sanitize
 ID_AA64PFR2_EL1.GCIE
Thread-Index: AQHct7hwdS7MT+FM+EyiBmp8zzKLmA==
Date: Thu, 19 Mar 2026 15:52:50 +0000
Message-ID: <20260319154937.3619520-13-sascha.bischoff@arm.com>
References: <20260319154937.3619520-1-sascha.bischoff@arm.com>
In-Reply-To: <20260319154937.3619520-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AS4PR08MB8241:EE_|PA4PR08MB6191:EE_|DB1PEPF0003922D:EE_|DU0PR08MB8068:EE_
X-MS-Office365-Filtering-Correlation-Id: 0f32bf2c-15a6-4151-69b2-08de85cfb8dd
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|18002099003|22082099003|56012099003|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 86Z8eRNDGMHvjBsJgrU+aS5uYOxGad6RZqAeT9taBNuD88VHXK+tkrbH7nyKFHUHE2fG3+ErZG3v8wBwNyie0jS7je/iVp8wbTTXSCsk14eEAhYxrvHyzU4Ke+4WT6gHqhpfg40hQYm7w4AI3It1EXLsARWoOXtdMupWnFMSvHWOLyzFqwtJ5nWMg7nWot0ofwQSqxLyOjP43E8b6KEWVGn7DYWmSBa8WEiKCSCFa9ucZvqga7ffr6VR16CrUNfzzMbJ2rIOgFPCLPPXsIONUFGKhy1QV9KNfkcwTPAxu+YbvZXDDxhNw7SAfF9dsoGAb3QtJGdeLES3noujJJDygV1pITWc3A29+98rwuHSsDa9VyCD3Dl56Txwvj0BgRorMD6dZD1RIvC0BSqra7RPmhDwwkZyf39mUkfdd71/kWC2dtjhInNpXE6+T9o/MnB3SDzb74DgyR/zxUnoQkSRnNZM4NQCBJd0wMONSx8I0khcl9dqN6/3H/sBI5z6Y8JwOOhsfXfuLicuwxaZYh81WdBjSrV9vw087qeb0SjwN/hyqLno/xtaGyzxCf896P5ZYC+0x3UzwWklY5hHnhdm6sA215C/ySAG3F2jPmAK2up/4fKfpdmtjczJULq8goKC1zfK/tREyx2NtEioBMB4vFPNxR/QCHvmaG/18IBThCBwQ80Ov6OcGKH+MdaSMWVmfpXYORn7C6+7WROwfYZPw9Dn42TkyJBWPCL2o84HxeZoEp4rCRSH2dMKnkKCAxM+Wh8hGNV2CUI3wgG4adxeaIjOPJpqWNApkp+ilY76N4I=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS4PR08MB8241.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(18002099003)(22082099003)(56012099003)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 F2nus0uFrM8LKCT4oXp+2fZNGsmNQnVqPAaLyUM91+YS1uhDHAY4eHiccXN7FOGp3is29Y66D4aU/gzq4y3iRbtzqQXcsVPMod/MCnpvZLH2TIhGGxNOK8dV5bB+mjy2bePVk2L2Sy+1esYYUDTSZxtOYJPtfBYFwuSQ2DYYhP+IDmPBuk4tJNmplDLTMDsKbiIvOIxiW6jdhNIuyDj63iUjYi1MWAjCNI8mzwEOzZO/F5u024iyfQxf0Pz+PgcuN50cDF4DNm9zACTAlH95nHQJ+yLn0TUp7N3sDa3DxAqBm6HD3qu9nIBLGsx9qBs55lqzzyAECEa3NJHXPCgKAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR08MB6191
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF0003922D.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	8e41610f-c8fe-4b37-3106-08de85cf9303
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|14060799003|82310400026|35042699022|376014|1800799024|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	3KhCT2+s8lipU47krHJYM/tx0DfwuCt1jepsDhSuKx2EVUIcsu1uv9ffC3gLIUpJ+IzavLMSrgpu1sCToHYhRpBCTSL4JU9oPkjv3iWc5OU3Krea0D5UFVG8SnPppPCckdo0XBGk7L8Pa5IKnMWAKOWk0z75901oAc3ex7bvCAijDWPZx1LhS/3kuhWhuHP3fiKN0sWp+MamgMirv9X+LGkD+oeIiPcV6qI9AKp3QbdY9sd0kN/2x3VWPtYUMacu0dprv0Y7gq0vSQEuUVrPC6AbzTnxfe614PKqg61Rh7suj2fuKp7wp648mKP3m7NtGfuY25JEzM7oqinnRDNo/vr0wDvxefs4N4//EzlSyFCtC1ayFgK98Ammj7FAsvaHydfgwGiA8BLX3EJaeMf3bUIeUw5juKraLWr6F2mE/4dXEjwwBEg7bm9AEYyM6pDNt1uSOUkHjlYFfJ+7Cq0xSAXtZUpuGXANMZfTaN31xzoBEfRt196f2VN+jCiY3X21EwGFN3berVuz1yphhp4ZGmIdkjjIFmh4dqMUc/kvi2RvQEnBgGsE43uNAk1KxkyTKs605veQYE2CdfMwQ/5IggQ5gLWFFPdFG4PiPojJ2WLqWfMEc9fJt6GmPtevwKMajp3jqCNFSF1QUByoC1Pb8uRdAamd1XVZHtfSUGt4JP294pUoUSjOfUSvQq9cP1bsNcbM6mV4ijSgacQX0jiyMY4IckrvylHuRTP10RACikpDocviOCY8IzPGEZnQ4mrbOVkStvLhjoQl0N3yJK4rAg==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(14060799003)(82310400026)(35042699022)(376014)(1800799024)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	tn1kONAaObuivp6Dt+5GGa44znX/a79RkWyY0dQhY1uZpAQdntz0BC0JG4ftxVagrTXRvYKjmj+oB3vzEDwHup53xa3x008lr+wyGmtTNXY9c8nwY226MMgO+6qWYkRZjiVKDQGg+d0G+j8Uqkds4j6hUSA3ovEWpGPWb7p3oz2NCGkh9JOPUyhtvBX3COSgC0H4An3dQvRbI8Yk7WACg968p12YPucgZdnX0nzD0mRfLK5frq0yaIWx/OjQjFEovKEwkreRkJgHcRYwRHUgJSQoaGXu2+XgYhwkRf+ZZmtLN+mD7MEP59J0sUjYvjZtYaZetdAn5R5hZOKE6rj6WC5k/uixLBiCedkFfLZcO0J+xwvz5ETAIdiG2Lx2Zl4Gk40ZONkmWaRS+ziGloiA5Gkb6TOcS7d3ChiI5bwabNPD+RuetE5+f18pm8SjOno4
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2026 15:53:53.8364
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f32bf2c-15a6-4151-69b2-08de85cfb8dd
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF0003922D.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB8068

Add in a sanitization function for ID_AA64PFR2_EL1, preserving the
already-present behaviour for the FPMR, MTEFAR, and MTESTOREONLY
fields. Add sanitisation for the GCIE field, which is set to IMP if
the host supports a GICv5 guest and NI, otherwise.

Extend the sanitisation that takes place in kvm_vgic_create() to zero
the ID_AA64PFR2.GCIE field when a non-GICv5 GIC is created. More
importantly, move this sanitisation to a separate function,
kvm_vgic_finalize_sysregs(), and call it from kvm_finalize_sys_regs().

We are required to finalize the GIC and GCIE fields a second time in
kvm_finalize_sys_regs() due to how QEMU blindly reads out then
verbatim restores the system register state. This avoids the issue
where both the GCIE and GIC features are marked as present (an
architecturally invalid combination), and hence guests fall over. See
the comment in kvm_finalize_sys_regs() for more details.

Overall, the following happens:

* Before an irqchip is created, FEAT_GCIE is presented if the host
  supports GICv5-based guests.
* Once an irqchip is created, all other supported irqchips are hidden
  from the guest; system register state reflects the guest's irqchip.
* Userspace is allowed to set invalid irqchip feature combinations in
  the system registers, but...
* ...invalid combinations are removed a second time prior to the first
  run of the guest, and things hopefully just work.

All of this extra work is required to make sure that "legacy" GICv3
guests based on QEMU transparently work on compatible GICv5 hosts
without modification.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
---
 arch/arm64/kvm/sys_regs.c       | 70 +++++++++++++++++++++++++++++----
 arch/arm64/kvm/vgic/vgic-init.c | 49 ++++++++++++++++-------
 include/kvm/arm_vgic.h          |  1 +
 3 files changed, 98 insertions(+), 22 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 42c84b7900ff5..140cf35f4eeb4 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1758,6 +1758,7 @@ static u8 pmuver_to_perfmon(u8 pmuver)
=20
 static u64 sanitise_id_aa64pfr0_el1(const struct kvm_vcpu *vcpu, u64 val);
 static u64 sanitise_id_aa64pfr1_el1(const struct kvm_vcpu *vcpu, u64 val);
+static u64 sanitise_id_aa64pfr2_el1(const struct kvm_vcpu *vcpu, u64 val);
 static u64 sanitise_id_aa64dfr0_el1(const struct kvm_vcpu *vcpu, u64 val);
=20
 /* Read a sanitised cpufeature ID register by sys_reg_desc */
@@ -1783,10 +1784,7 @@ static u64 __kvm_read_sanitised_id_reg(const struct =
kvm_vcpu *vcpu,
 		val =3D sanitise_id_aa64pfr1_el1(vcpu, val);
 		break;
 	case SYS_ID_AA64PFR2_EL1:
-		val &=3D ID_AA64PFR2_EL1_FPMR |
-			(kvm_has_mte(vcpu->kvm) ?
-			 ID_AA64PFR2_EL1_MTEFAR | ID_AA64PFR2_EL1_MTESTOREONLY :
-			 0);
+		val =3D sanitise_id_aa64pfr2_el1(vcpu, val);
 		break;
 	case SYS_ID_AA64ISAR1_EL1:
 		if (!vcpu_has_ptrauth(vcpu))
@@ -2027,6 +2025,23 @@ static u64 sanitise_id_aa64pfr1_el1(const struct kvm=
_vcpu *vcpu, u64 val)
 	return val;
 }
=20
+static u64 sanitise_id_aa64pfr2_el1(const struct kvm_vcpu *vcpu, u64 val)
+{
+	val &=3D ID_AA64PFR2_EL1_FPMR |
+	       ID_AA64PFR2_EL1_MTEFAR |
+	       ID_AA64PFR2_EL1_MTESTOREONLY;
+
+	if (!kvm_has_mte(vcpu->kvm)) {
+		val &=3D ~ID_AA64PFR2_EL1_MTEFAR;
+		val &=3D ~ID_AA64PFR2_EL1_MTESTOREONLY;
+	}
+
+	if (vgic_host_has_gicv5())
+		val |=3D SYS_FIELD_PREP_ENUM(ID_AA64PFR2_EL1, GCIE, IMP);
+
+	return val;
+}
+
 static u64 sanitise_id_aa64dfr0_el1(const struct kvm_vcpu *vcpu, u64 val)
 {
 	val =3D ID_REG_LIMIT_FIELD_ENUM(val, ID_AA64DFR0_EL1, DebugVer, V8P8);
@@ -2216,6 +2231,12 @@ static int set_id_aa64pfr1_el1(struct kvm_vcpu *vcpu=
,
 	return set_id_reg(vcpu, rd, user_val);
 }
=20
+static int set_id_aa64pfr2_el1(struct kvm_vcpu *vcpu,
+			       const struct sys_reg_desc *rd, u64 user_val)
+{
+	return set_id_reg(vcpu, rd, user_val);
+}
+
 /*
  * Allow userspace to de-feature a stage-2 translation granule but prevent=
 it
  * from claiming the impossible.
@@ -3197,10 +3218,11 @@ static const struct sys_reg_desc sys_reg_descs[] =
=3D {
 				       ID_AA64PFR1_EL1_RES0 |
 				       ID_AA64PFR1_EL1_MPAM_frac |
 				       ID_AA64PFR1_EL1_MTE)),
-	ID_WRITABLE(ID_AA64PFR2_EL1,
-		    ID_AA64PFR2_EL1_FPMR |
-		    ID_AA64PFR2_EL1_MTEFAR |
-		    ID_AA64PFR2_EL1_MTESTOREONLY),
+	ID_FILTERED(ID_AA64PFR2_EL1, id_aa64pfr2_el1,
+		    ~(ID_AA64PFR2_EL1_FPMR |
+		      ID_AA64PFR2_EL1_MTEFAR |
+		      ID_AA64PFR2_EL1_MTESTOREONLY |
+		      ID_AA64PFR2_EL1_GCIE)),
 	ID_UNALLOCATED(4,3),
 	ID_WRITABLE(ID_AA64ZFR0_EL1, ~ID_AA64ZFR0_EL1_RES0),
 	ID_HIDDEN(ID_AA64SMFR0_EL1),
@@ -5671,8 +5693,40 @@ int kvm_finalize_sys_regs(struct kvm_vcpu *vcpu)
=20
 		val =3D kvm_read_vm_id_reg(kvm, SYS_ID_AA64PFR0_EL1) & ~ID_AA64PFR0_EL1_=
GIC;
 		kvm_set_vm_id_reg(kvm, SYS_ID_AA64PFR0_EL1, val);
+		val =3D kvm_read_vm_id_reg(kvm, SYS_ID_AA64PFR2_EL1) & ~ID_AA64PFR2_EL1_=
GCIE;
+		kvm_set_vm_id_reg(kvm, SYS_ID_AA64PFR2_EL1, val);
 		val =3D kvm_read_vm_id_reg(kvm, SYS_ID_PFR1_EL1) & ~ID_PFR1_EL1_GIC;
 		kvm_set_vm_id_reg(kvm, SYS_ID_PFR1_EL1, val);
+	} else {
+		/*
+		 * Certain userspace software - QEMU - samples the system
+		 * register state without creating an irqchip, then blindly
+		 * restores the state prior to running the final guest. This
+		 * means that it restores the virtualization & emulation
+		 * capabilities of the host system, rather than something that
+		 * reflects the final guest state. Moreover, it checks that the
+		 * state was "correctly" restored (i.e., verbatim), bailing if
+		 * it isn't, so masking off invalid state isn't an option.
+		 *
+		 * On GICv5 hardware that supports FEAT_GCIE_LEGACY we can run
+		 * both GICv3- and GICv5-based guests. Therefore, we initially
+		 * present both ID_AA64PFR0.GIC and ID_AA64PFR2.GCIE as IMP to
+		 * reflect that userspace can create EITHER a vGICv3 or a
+		 * vGICv5. This is an architecturally invalid combination, of
+		 * course. Once an in-kernel GIC is created, the sysreg state is
+		 * updated to reflect the actual, valid configuration.
+		 *
+		 * Setting both the GIC and GCIE features to IMP unsurprisingly
+		 * results in guests falling over, and hence we need to fix up
+		 * this mess in KVM. Before running for the first time we yet
+		 * again ensure that the GIC and GCIE fields accurately reflect
+		 * the actual hardware the guest should see.
+		 *
+		 * This hack allows legacy QEMU-based GICv3 guests to run
+		 * unmodified on compatible GICv5 hosts, and avoids the inverse
+		 * problem for GICv5-based guests in the future.
+		 */
+		kvm_vgic_finalize_idregs(kvm);
 	}
=20
 	if (vcpu_has_nv(vcpu)) {
diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-ini=
t.c
index e9b8b5fc480c7..e1be9c5ada7b3 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -71,7 +71,6 @@ static int vgic_allocate_private_irqs_locked(struct kvm_v=
cpu *vcpu, u32 type);
 int kvm_vgic_create(struct kvm *kvm, u32 type)
 {
 	struct kvm_vcpu *vcpu;
-	u64 aa64pfr0, pfr1;
 	unsigned long i;
 	int ret;
=20
@@ -145,19 +144,11 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
 	kvm->arch.vgic.implementation_rev =3D KVM_VGIC_IMP_REV_LATEST;
 	kvm->arch.vgic.vgic_dist_base =3D VGIC_ADDR_UNDEF;
=20
-	aa64pfr0 =3D kvm_read_vm_id_reg(kvm, SYS_ID_AA64PFR0_EL1) & ~ID_AA64PFR0_=
EL1_GIC;
-	pfr1 =3D kvm_read_vm_id_reg(kvm, SYS_ID_PFR1_EL1) & ~ID_PFR1_EL1_GIC;
-
-	if (type =3D=3D KVM_DEV_TYPE_ARM_VGIC_V2) {
-		kvm->arch.vgic.vgic_cpu_base =3D VGIC_ADDR_UNDEF;
-	} else {
-		INIT_LIST_HEAD(&kvm->arch.vgic.rd_regions);
-		aa64pfr0 |=3D SYS_FIELD_PREP_ENUM(ID_AA64PFR0_EL1, GIC, IMP);
-		pfr1 |=3D SYS_FIELD_PREP_ENUM(ID_PFR1_EL1, GIC, GICv3);
-	}
-
-	kvm_set_vm_id_reg(kvm, SYS_ID_AA64PFR0_EL1, aa64pfr0);
-	kvm_set_vm_id_reg(kvm, SYS_ID_PFR1_EL1, pfr1);
+	/*
+	 * We've now created the GIC. Update the system register state
+	 * to accurately reflect what we've created.
+	 */
+	kvm_vgic_finalize_idregs(kvm);
=20
 	kvm_for_each_vcpu(i, vcpu, kvm) {
 		ret =3D vgic_allocate_private_irqs_locked(vcpu, type);
@@ -617,6 +608,36 @@ int kvm_vgic_map_resources(struct kvm *kvm)
 	return ret;
 }
=20
+void kvm_vgic_finalize_idregs(struct kvm *kvm)
+{
+	u32 type =3D kvm->arch.vgic.vgic_model;
+	u64 aa64pfr0, aa64pfr2, pfr1;
+
+	aa64pfr0 =3D kvm_read_vm_id_reg(kvm, SYS_ID_AA64PFR0_EL1) & ~ID_AA64PFR0_=
EL1_GIC;
+	aa64pfr2 =3D kvm_read_vm_id_reg(kvm, SYS_ID_AA64PFR2_EL1) & ~ID_AA64PFR2_=
EL1_GCIE;
+	pfr1 =3D kvm_read_vm_id_reg(kvm, SYS_ID_PFR1_EL1) & ~ID_PFR1_EL1_GIC;
+
+	switch (type) {
+	case KVM_DEV_TYPE_ARM_VGIC_V2:
+		kvm->arch.vgic.vgic_cpu_base =3D VGIC_ADDR_UNDEF;
+		break;
+	case KVM_DEV_TYPE_ARM_VGIC_V3:
+		INIT_LIST_HEAD(&kvm->arch.vgic.rd_regions);
+		aa64pfr0 |=3D SYS_FIELD_PREP_ENUM(ID_AA64PFR0_EL1, GIC, IMP);
+		pfr1 |=3D SYS_FIELD_PREP_ENUM(ID_PFR1_EL1, GIC, GICv3);
+		break;
+	case KVM_DEV_TYPE_ARM_VGIC_V5:
+		aa64pfr2 |=3D SYS_FIELD_PREP_ENUM(ID_AA64PFR2_EL1, GCIE, IMP);
+		break;
+	default:
+		WARN_ONCE(1, "Unknown VGIC type!!!\n");
+	}
+
+	kvm_set_vm_id_reg(kvm, SYS_ID_AA64PFR0_EL1, aa64pfr0);
+	kvm_set_vm_id_reg(kvm, SYS_ID_AA64PFR2_EL1, aa64pfr2);
+	kvm_set_vm_id_reg(kvm, SYS_ID_PFR1_EL1, pfr1);
+}
+
 /* GENERIC PROBE */
=20
 void kvm_vgic_cpu_up(void)
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 0fabeabedd6d7..24969fa8d02d6 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -485,6 +485,7 @@ int kvm_vgic_create(struct kvm *kvm, u32 type);
 void kvm_vgic_destroy(struct kvm *kvm);
 void kvm_vgic_vcpu_destroy(struct kvm_vcpu *vcpu);
 int kvm_vgic_map_resources(struct kvm *kvm);
+void kvm_vgic_finalize_idregs(struct kvm *kvm);
 int kvm_vgic_hyp_init(void);
 void kvm_vgic_init_cpu_hardware(void);
=20
--=20
2.34.1
