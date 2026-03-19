Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013038.outbound.protection.outlook.com [40.107.162.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5F283E92BF
	for <kvmarm@lists.linux.dev>; Thu, 19 Mar 2026 16:00:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.38
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773936061; cv=fail; b=ZI0nWXbGQbTyzlo05Mu0iXrJvhXCIfJagGC0XkFD9K1qIDvAzegR27vpvtqy5/yZhc1TtWTq4Zyf5ikRgSaNrlb051B8NvZpd+05MnDjHIyMmaLasYgXQ+sk1vAXx9B2SKHd8FB+RtvjqRQzscNcm8lAE65agmN6DO/d4peEGrY=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773936061; c=relaxed/simple;
	bh=smIRnltV8D4YDa0vlcACqih/07SNMi2YjMIJ8jti8Ak=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=OV5L0mZUVFJeLecSG7ac0l3y1X8U8pLBpfRyYpKlGAMNCGgF4ypHbAJvDL72CBJxQmTcH5AEzDvqcvATnuS2DdxSnU94Ceoug/Oes+lSvQSC6HhNuuIonw4WCM5FOaJbjfSGzVrfpeq7HFSZt08XCaPqa54TVrHcqqy6qKSDIo4=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=bh4JgfBZ; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=bh4JgfBZ; arc=fail smtp.client-ip=40.107.162.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="bh4JgfBZ";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="bh4JgfBZ"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=NHXOCfeX6v8RWX26Q4ttM0RGb2cYeRN5EaFnHO9cF2NbSjIQ7eIfmrmsT3T8+KE/oHAoWs220Na59AknGOho82aCsrE/jLzle/dRoT5sv2y9R1oH9QwCeOZ+NTeTAhTjHGm+k8l4UM2bh4dyqD9kRdedhk9LotVZ1N3IiC/yDbcrO+O9I4lcNVOxpe0/iqFmA4vbcuQ2awvbV4JRNnQwd/FGrH83rLJL8fPr5myJx5IviUnuh24xvSQVE5a6FmcG+QIcBDPp/WYui2sNl4FPWsgkW51PPtyrMjw869I8YJhiABINlUIiajstqMFTd7vd2X+Xpt3j2G2Gs/7yv5GNPA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0TFiIiXTqgxVNdl1VBnMb1dlvp0DI+/Oui3VMGeC9eM=;
 b=AlWFNLS/vGqXecMdvKsqVMq6D9jzKRyOcHFJVXYulAgy7oYu1NBAdA89txubzAfLSDdyxmxEzCgWD0n43FGkRQ8N4fsDzs0GzAr3e25WCxbME3CbM6H7LMWxRCZdErSu4FLEFcadGyDWW5Jyor7Avj8CGyggRRgzJkQjTFekULjdp520UOeN4gCalA1XE8RcBIKG6FmUmra5opHd/gyOopZ7ZCfwgxUokk9uT5F9xVvsNrVgyB5/OYIb4sk9n3OwCnB82Qz+eXyNZZ9pJhg6zilAC8ddQ4UNmmw5C+wwagFJJtiqQBOPS3g6pUy7MzI30G2rk3ultvz6PU4TliJ3JA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0TFiIiXTqgxVNdl1VBnMb1dlvp0DI+/Oui3VMGeC9eM=;
 b=bh4JgfBZwHrPGBg0WkUsSHCNpyhcnNQQVT8CJFzWrTG+1o02hPlbDDJTvBeOQaAyjmVjXiLnAqvmrAuBqntcVWBzZkiFt9YUPQ0QOpvfq04fn5UmuLMvN6m4gVRWZ3mofAvwhFrXtjuwqA7yfz1oEcwIb0u7p/ogoQxRUU0b4q8=
Received: from DUZPR01CA0076.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:46a::7) by DB9PR08MB8201.eurprd08.prod.outlook.com
 (2603:10a6:10:39c::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Thu, 19 Mar
 2026 16:00:53 +0000
Received: from DB5PEPF00014B99.eurprd02.prod.outlook.com
 (2603:10a6:10:46a:cafe::82) by DUZPR01CA0076.outlook.office365.com
 (2603:10a6:10:46a::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.19 via Frontend Transport; Thu,
 19 Mar 2026 16:00:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB5PEPF00014B99.mail.protection.outlook.com (10.167.8.166) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.19
 via Frontend Transport; Thu, 19 Mar 2026 16:00:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vfYgQeUjl2uhrLIVoEOZdHuA0RAsvCpeeQ/Th6fFXVdaZ10csF0rXUt577ZSMaNY9D5SMK44/m+c2CrUQ4NKTOvXsuwqClErEKSNpHwBuVwLzo7i08c5OYASNRUS3Pyv+wprviC5dYXy8lLh0s+HkjdSHA+FIi1NAHJM5e3Tg+mR9UAjtMnebR2U9zSyQwJdN7SZQShpbBj49EW9MXrxhmPSRUhySEPcUgekBWIp4EJ19jTOtEVDtXaZpOK7VH86Z5l1hLGLH8swrvmcl0W1MqMDI+KwhlSRnV2ZEVLE2K6g4TqGO/C+sx5efKNmyzKjkLX59p261eHWBhG5Frs2HA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0TFiIiXTqgxVNdl1VBnMb1dlvp0DI+/Oui3VMGeC9eM=;
 b=k73CLa238yfqPdoj0UEUzpCuHPfQu4/t61nporez8HhZR2vqPu5V8kQkYknr4ZOE4pY1yj5RyYFX1fSC/vlzyTBbD17WPUHWATOB9JfUhvZgRdc2INjjlNYsp1xU4z4CrYN2muShqy7qDr3j2JL1wG81+sFzwgV2viwjKUESQRzRY2Um1l5TjJ/H5dGAx4DhQISUz9GxgnOq80KMHYWL1S81wECE6/oExcIJRuQPmXqY2Whsxs9NJ8hPsX5aA57bGGOepGgfjhCH5ts0/wH68tMlLiZrg+yFZ4bDLi5+ZpgdApGzTe/vzxcS8+e14CK+yS3zXwl1gW74ZfHzRNhedw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0TFiIiXTqgxVNdl1VBnMb1dlvp0DI+/Oui3VMGeC9eM=;
 b=bh4JgfBZwHrPGBg0WkUsSHCNpyhcnNQQVT8CJFzWrTG+1o02hPlbDDJTvBeOQaAyjmVjXiLnAqvmrAuBqntcVWBzZkiFt9YUPQ0QOpvfq04fn5UmuLMvN6m4gVRWZ3mofAvwhFrXtjuwqA7yfz1oEcwIb0u7p/ogoQxRUU0b4q8=
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com (2603:10a6:20b:504::10)
 by AS2PR08MB9414.eurprd08.prod.outlook.com (2603:10a6:20b:596::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.20; Thu, 19 Mar
 2026 15:59:50 +0000
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27]) by AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27%6]) with mapi id 15.20.9723.018; Thu, 19 Mar 2026
 15:59:50 +0000
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
Subject: [PATCH v7 39/41] KVM: arm64: gic-v5: Communicate userspace-driveable
 PPIs via a UAPI
Thread-Topic: [PATCH v7 39/41] KVM: arm64: gic-v5: Communicate
 userspace-driveable PPIs via a UAPI
Thread-Index: AQHct7lr4DjXg8oZpUWN7yCTb0zzow==
Date: Thu, 19 Mar 2026 15:59:50 +0000
Message-ID: <20260319154937.3619520-40-sascha.bischoff@arm.com>
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
	AS4PR08MB8241:EE_|AS2PR08MB9414:EE_|DB5PEPF00014B99:EE_|DB9PR08MB8201:EE_
X-MS-Office365-Filtering-Correlation-Id: 78fbb644-7710-4b6c-0194-08de85d0b2be
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|22082099003|56012099003|18002099003|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 ByIU8ErBA8cAjIWFVVlrhq6I6ZuQnMZoyDe8CD8Str7284yW6ABJutetiu7xGeYQ3aqiG4lJfYQp2Z4OcTWeAtqNMizpohVxN5jHW8SsuwquZiTDFCeBLOXDCC0T+5rfsieahA1/+xDCt4J0ZRzwP+K8V8nQajZQWiusQn5x8En9hmypfL0EAk/bVB6swJ9EFmiow7dqxtceYCiqqVxhwzGCWW0tah+RCNRBH0w61L1hklN3kd4gl9820WGUU8MsmRfxWyJxDz3PZXiPraj/1nkIcOMbPVFopeRrPlnJcwD6CYyWwN2n03zhXo9er0R0wObeLjiEo5IvmJuKwPQLDSrOYcjV+UO85oSmQKRJEO6NuMFGX//AzNT7W0/S1LOKSSdND71CTAodzT4Igxnq3Xy5sI9bKLSa+59c3XYMJHRueQXWwPdKphkrTY6twqRLDzvkVRyMXa0v+gf2gYnf38950ADUhFbfLCP4j+h5HS05I2Q5R+sYV91CtQApf9Rf25Ja1mi5eWJQp1xf42dJWNNsOObHJRod361CztpbEXjJJ0xXIE3HXqMrt60moU/o1Qq9MwUiNxOPUFxiu9qVEBMlMm1bupCdPdvqV2+GRBSyLTpgBapjp5XPsKICoUGdngvDCEuwEclycpaMQ5Ud6MZU/YghHQrH1EWNeekr1NirZ0ZvQ22N/RX9c/feN7cMUlDFGBDbOvwtzVepzyDUN/UG24PxtW92J4yRrHrIHtfBxukyGMaURvJp/5uRE6zZzY3coIR5aElidV9w7sIddgGPAVA7YIxLoq/MT9LSSx4=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS4PR08MB8241.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(22082099003)(56012099003)(18002099003)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 cMLom+LBg+jbNwRkbwKjByyfFEPz7iIFcdXP8z5+I73pTst8584DjJOLcCgeER5Q7VZrn3yofFuFM1Y/p2zwTuAfCvW4IS6E2hshVRp45nurNI3MTWmK2r0tvnk6WHaWSRFlEyusSa2M0OOB52uXo4UsmqaWoNV5i2yD1PAHkfjJPfQpl/phX0A0xNYGZCKE8MDEmg+lGMsm9Fog7Yih4e6dLvFNXB0r3IkRJmAN9QwHT1XxnJ+snA1YY3Pdp2WylVsmRRWlcwrIngPqb8afIwBavLs0UYA2LTSUFiQJTpt8/uWdZ2kvPyfx9vkEJn+lGgFS4VlVU7QIZ7gCRa1Q3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB9414
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB5PEPF00014B99.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	71d432fc-eeb3-48b2-df29-08de85d08d89
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|82310400026|35042699022|36860700016|376014|1800799024|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	zZOTsJoEtrY98pvsFL4NGb8HYPzMfT1wJHRAt6IQtzFbB2p7MpJza+wPjGLpy707AJIabWtrJ88Nlpc7JxX4VZ+r/QnySTP4DX+83lqSJep2xbvIURtc5yekuDLWbdAT3EmrE0oo/cJqVS9RAa0fgEI6KTY+eQrrkPxFFcM4PeQ/0E/XLwJRkW1ixkrVErtlTIbyRQn2QrUeLAYQJsKU76jH8dufg3kFxCBuu265IkJNAARkhDSQql2+wSbOMSc0ETlSvALWnDI83T1pcKgi8KTx+Z9bvIeO/LmViAna7y+EoLAxj2LMTaVW1mCDK0yWVcnpbMsgAJigROHD+icmzhMUrPuwGXyET/dByxwFxiKnca3jx1M2/43A2V5nPy9q+y8TWxfCyJAnLmDir9Gv7EXWBUVtId2utj1rj+5SWHEAyYL4iR/JoEa9ths6twgd9VjYtF1EwVb1IFHtrI/u6jq7VesJ5zXIXO2fUbueyrPan0LyYdj7VJWOtSxUYROhHvR53tWEDDcSBuiuehf91tX/DgJRDeFtJ9Lpa4aJmxszmmebnHunEJPFPHNKo71fprs4PZ82JH+shWd6dl104uoazY0UNSeBcQKFD7PE8GEaJ6MuE2TfSHKUnIzKUWNgTn3ksGqj7BDyvNA6St8jHNkJQlnneVdHTVk4eQo7R0P6YtT/wis9wH78jYolYtc3cug2mg1uHWg34eCz1pqaP7/t2N3H7Nur/2gbQCN6G+rU4ToA25ivOTuKgaM9wGWlBhdsnqwlfTMwvqilEOfCHw==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(82310400026)(35042699022)(36860700016)(376014)(1800799024)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	YwL19kAwoY8ujdoeaWGvHoGH/8i87+or7Sn9EAGwh/3kAAacE1gLdhse/FUPgVfVZl6sKdDZOk45s5Df3Q7ggJYnEhsYC9Fww6SK8NLx69lIqEuy5qnQP0qNf72iMcvcA4KL8GRXz1TmNnzHY+BcFdV7Jg2bOSoenzAXiGxoKLdq9E98nkSZViZByUmS8IZpHhxBZfD4/bRp0MPtmHHghyHeV/ObtAeGzjh/sArSuwVtvr32RI8uhdRw5snngUL8cIGHlm/mZ3qXvD0NMva/3QUr/BCbI402zDvd0drqldvRfgrQIdpOpnzqK56ShTfsQANSOKZTTAuirXZfMe8cdteolVJRQQZ0dBfF/LsB7fTLOfnHooAN7Ov/aHROifnyiXNXN4oaG4sPW6gAeeriqfVjP0FmJQmYor7xib/BdIUe10m+oGhEu3Q2w4ziIA3A
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2026 16:00:53.0442
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 78fbb644-7710-4b6c-0194-08de85d0b2be
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB5PEPF00014B99.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB8201

GICv5 systems will likely not support the full set of PPIs. The
presence of any virtual PPI is tied to the presence of the physical
PPI. Therefore, the available PPIs will be limited by the physical
host. Userspace cannot drive any PPIs that are not implemented.

Moreover, it is not desirable to expose all PPIs to the guest in the
first place, even if they are supported in hardware. Some devices,
such as the arch timer, are implemented in KVM, and hence those PPIs
shouldn't be driven by userspace, either.

Provided a new UAPI:
  KVM_DEV_ARM_VGIC_GRP_CTRL =3D> KVM_DEV_ARM_VGIC_USERPSPACE_PPIs

This allows userspace to query which PPIs it is able to drive via
KVM_IRQ_LINE.

Additionally, introduce a check in kvm_vm_ioctl_irq_line() to reject
any PPIs not in the userspace mask.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
---
 .../virt/kvm/devices/arm-vgic-v5.rst          | 13 ++++++++
 arch/arm64/include/uapi/asm/kvm.h             |  1 +
 arch/arm64/kvm/arm.c                          | 11 ++++++-
 arch/arm64/kvm/vgic/vgic-kvm-device.c         | 31 +++++++++++++++++++
 arch/arm64/kvm/vgic/vgic-v5.c                 | 10 ++++++
 include/kvm/arm_vgic.h                        |  3 ++
 tools/arch/arm64/include/uapi/asm/kvm.h       |  1 +
 7 files changed, 69 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/devices/arm-vgic-v5.rst b/Documentation=
/virt/kvm/devices/arm-vgic-v5.rst
index 9904cb888277d..29335ea823fc5 100644
--- a/Documentation/virt/kvm/devices/arm-vgic-v5.rst
+++ b/Documentation/virt/kvm/devices/arm-vgic-v5.rst
@@ -25,6 +25,19 @@ Groups:
       request the initialization of the VGIC, no additional parameter in
       kvm_device_attr.addr. Must be called after all VCPUs have been creat=
ed.
=20
+   KVM_DEV_ARM_VGIC_USERPSPACE_PPIs
+      request the mask of userspace-drivable PPIs. Only a subset of the PP=
Is can
+      be directly driven from userspace with GICv5, and the returned mask
+      informs userspace of which it is allowed to drive via KVM_IRQ_LINE.
+
+      Userspace must allocate and point to __u64[2] of data in
+      kvm_device_attr.addr. When this call returns, the provided memory wi=
ll be
+      populated with the userspace PPI mask. The lower __u64 contains the =
mask
+      for the lower 64 PPIS, with the remaining 64 being in the second __u=
64.
+
+      This is a read-only attribute, and cannot be set. Attempts to set it=
 are
+      rejected.
+
   Errors:
=20
     =3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/as=
m/kvm.h
index a792a599b9d68..1c13bfa2d38aa 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -428,6 +428,7 @@ enum {
 #define   KVM_DEV_ARM_ITS_RESTORE_TABLES        2
 #define   KVM_DEV_ARM_VGIC_SAVE_PENDING_TABLES	3
 #define   KVM_DEV_ARM_ITS_CTRL_RESET		4
+#define   KVM_DEV_ARM_VGIC_USERSPACE_PPIS	5
=20
 /* Device Control API on vcpu fd */
 #define KVM_ARM_VCPU_PMU_V3_CTRL	0
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 05a2c1ed117dd..e7d07752143be 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1449,10 +1449,11 @@ static int vcpu_interrupt_line(struct kvm_vcpu *vcp=
u, int number, bool level)
 int kvm_vm_ioctl_irq_line(struct kvm *kvm, struct kvm_irq_level *irq_level=
,
 			  bool line_status)
 {
-	u32 irq =3D irq_level->irq;
 	unsigned int irq_type, vcpu_id, irq_num;
 	struct kvm_vcpu *vcpu =3D NULL;
 	bool level =3D irq_level->level;
+	u32 irq =3D irq_level->irq;
+	unsigned long *mask;
=20
 	irq_type =3D (irq >> KVM_ARM_IRQ_TYPE_SHIFT) & KVM_ARM_IRQ_TYPE_MASK;
 	vcpu_id =3D (irq >> KVM_ARM_IRQ_VCPU_SHIFT) & KVM_ARM_IRQ_VCPU_MASK;
@@ -1486,6 +1487,14 @@ int kvm_vm_ioctl_irq_line(struct kvm *kvm, struct kv=
m_irq_level *irq_level,
 			if (irq_num >=3D VGIC_V5_NR_PRIVATE_IRQS)
 				return -EINVAL;
=20
+			/*
+			 * Only allow PPIs that are explicitly exposed to
+			 * usespace to be driven via KVM_IRQ_LINE
+			 */
+			mask =3D kvm->arch.vgic.gicv5_vm.userspace_ppis;
+			if (!test_bit(irq_num, mask))
+				return -EINVAL;
+
 			/* Build a GICv5-style IntID here */
 			irq_num =3D vgic_v5_make_ppi(irq_num);
 		} else if (irq_num < VGIC_NR_SGIS ||
diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vg=
ic-kvm-device.c
index 772da54c1518b..a96c77dccf353 100644
--- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
+++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
@@ -720,6 +720,32 @@ struct kvm_device_ops kvm_arm_vgic_v3_ops =3D {
 	.has_attr =3D vgic_v3_has_attr,
 };
=20
+static int vgic_v5_get_userspace_ppis(struct kvm_device *dev,
+				      struct kvm_device_attr *attr)
+{
+	struct vgic_v5_vm *gicv5_vm =3D &dev->kvm->arch.vgic.gicv5_vm;
+	u64 __user *uaddr =3D (u64 __user *)(long)attr->addr;
+	int ret;
+
+	guard(mutex)(&dev->kvm->arch.config_lock);
+
+	/*
+	 * We either support 64 or 128 PPIs. In the former case, we need to
+	 * return 0s for the second 64 bits as we have no storage backing those.
+	 */
+	ret =3D put_user(bitmap_read(gicv5_vm->userspace_ppis, 0, 64), uaddr);
+	if (ret)
+		return ret;
+	uaddr++;
+
+	if (VGIC_V5_NR_PRIVATE_IRQS =3D=3D 128)
+		ret =3D put_user(bitmap_read(gicv5_vm->userspace_ppis, 64, 128), uaddr);
+	else
+		ret =3D put_user(0, uaddr);
+
+	return ret;
+}
+
 static int vgic_v5_set_attr(struct kvm_device *dev,
 			    struct kvm_device_attr *attr)
 {
@@ -732,6 +758,7 @@ static int vgic_v5_set_attr(struct kvm_device *dev,
 		switch (attr->attr) {
 		case KVM_DEV_ARM_VGIC_CTRL_INIT:
 			return vgic_set_common_attr(dev, attr);
+		case KVM_DEV_ARM_VGIC_USERSPACE_PPIS:
 		default:
 			return -ENXIO;
 		}
@@ -753,6 +780,8 @@ static int vgic_v5_get_attr(struct kvm_device *dev,
 		switch (attr->attr) {
 		case KVM_DEV_ARM_VGIC_CTRL_INIT:
 			return vgic_get_common_attr(dev, attr);
+		case KVM_DEV_ARM_VGIC_USERSPACE_PPIS:
+			return vgic_v5_get_userspace_ppis(dev, attr);
 		default:
 			return -ENXIO;
 		}
@@ -773,6 +802,8 @@ static int vgic_v5_has_attr(struct kvm_device *dev,
 		switch (attr->attr) {
 		case KVM_DEV_ARM_VGIC_CTRL_INIT:
 			return 0;
+		case KVM_DEV_ARM_VGIC_USERSPACE_PPIS:
+			return 0;
 		default:
 			return -ENXIO;
 		}
diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index f7a24ea6ad784..2b6cd5c3f9c2f 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -143,6 +143,16 @@ int vgic_v5_init(struct kvm *kvm)
 		}
 	}
=20
+	/* We only allow userspace to drive the SW_PPI, if it is implemented. */
+	bitmap_zero(kvm->arch.vgic.gicv5_vm.userspace_ppis,
+		    VGIC_V5_NR_PRIVATE_IRQS);
+	__assign_bit(GICV5_ARCH_PPI_SW_PPI,
+		     kvm->arch.vgic.gicv5_vm.userspace_ppis,
+		     VGIC_V5_NR_PRIVATE_IRQS);
+	bitmap_and(kvm->arch.vgic.gicv5_vm.userspace_ppis,
+		   kvm->arch.vgic.gicv5_vm.userspace_ppis,
+		   ppi_caps.impl_ppi_mask, VGIC_V5_NR_PRIVATE_IRQS);
+
 	return 0;
 }
=20
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 8cc3a7b4d8152..1388dc6028a9a 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -350,6 +350,9 @@ struct vgic_v5_vm {
 	 */
 	DECLARE_BITMAP(vgic_ppi_mask, VGIC_V5_NR_PRIVATE_IRQS);
=20
+	/* A mask of the PPIs that are exposed for userspace to drive. */
+	DECLARE_BITMAP(userspace_ppis, VGIC_V5_NR_PRIVATE_IRQS);
+
 	/*
 	 * The HMR itself is handled by the hardware, but we still need to have
 	 * a mask that we can use when merging in pending state (only the state
diff --git a/tools/arch/arm64/include/uapi/asm/kvm.h b/tools/arch/arm64/inc=
lude/uapi/asm/kvm.h
index a792a599b9d68..1c13bfa2d38aa 100644
--- a/tools/arch/arm64/include/uapi/asm/kvm.h
+++ b/tools/arch/arm64/include/uapi/asm/kvm.h
@@ -428,6 +428,7 @@ enum {
 #define   KVM_DEV_ARM_ITS_RESTORE_TABLES        2
 #define   KVM_DEV_ARM_VGIC_SAVE_PENDING_TABLES	3
 #define   KVM_DEV_ARM_ITS_CTRL_RESET		4
+#define   KVM_DEV_ARM_VGIC_USERSPACE_PPIS	5
=20
 /* Device Control API on vcpu fd */
 #define KVM_ARM_VCPU_PMU_V3_CTRL	0
--=20
2.34.1
