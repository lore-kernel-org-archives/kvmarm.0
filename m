Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013051.outbound.protection.outlook.com [52.101.72.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ABB134D910
	for <kvmarm@lists.linux.dev>; Mon, 27 Apr 2026 16:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.72.51
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777306400; cv=fail; b=llLsEOx0B2CKzG1sTCtlWhJhkBVu9vFSnaZNh+OnSSdGeH/wdPSOYbHnl/502nh7B+LpmGxSLcJ57XNp7ac9RggmXHR0IxCMR+UASqCJpJZUsxXwp3GPd6IwxnLuDKPidIOcTVfyzoAr9AtRH7fNDB4J7Ly/YdYFkuGYS4lIcBI=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777306400; c=relaxed/simple;
	bh=h/eof02pENrYduODUhWy+Xf5AAexXKKgIYdvgc/HvFw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=KHJ+N7rjnT0YpklZ5lzUQKgo+Ru6sBI+hoTRkPOr1W5fR6ks86SFt255VaNB3XL3dF+ERIl83scpxNNDYOxJxrgCOV2W+tIPv8W3x2q5Z5Kja+o/bxoRDnn8gkECtRO5CrwYEf90IH7jkhocTEbnWdoBSlWdLk7PAal7vj9ORig=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=HPZsL3WW; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=HPZsL3WW; arc=fail smtp.client-ip=52.101.72.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="HPZsL3WW";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="HPZsL3WW"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=vqj+1TU5iLGh8YKEd34G+HgTqv1in3R/4kWtmUu/ks8J1uVp60aMjMtNVPiI/d/Rry/NBn3JERM0Y8Lxv+uWWEfVEok97Lnn1ArDRjUZttzKzvi+U/QYQuQGdEeg/Ng72PAOg+YLCV8MNskTHbW7J7f5p+U023Z2ylll3kkVrO6YA+8GIpDRqykHZqbcpuHZG2bLI9h52Lk2JQSMZ1pmSQ+ryJuf0Tkm3ODfADsY7KxdXyph6sy2yrBpND1zwiQbXGt2+CPO8j5+hnLZoJ9ZpwwPpCFijXYFhQqCvOMIYSHtPSWvGBJZqFyGn90Cy/SSTYsLf3C0W2/WqLjOHTVN0g==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XdQkScqp1Du3GNwdsHeULg1BMP8sOJhVqPuPajwADNI=;
 b=PDbT7Xu+1tG7xm5KnjdXibnjehQ67BsJ50eyFu1fKDWOuTADsDKL4ol9rdW0MDDPRXZC8Uc8yMrkHKrez45QUuYEiaiW8PPfsPtf8K8ESxVUtekbuer3nNTIiQbTxtckviUAOIeVR2D7RuWVUb/bhr1c5++07UGybRUBqMWgxJx77wbe0Hqzz8TW1gb/SkH6HLi7bcNrfTilnwRHhwnB0rYLaneIsfIqGlUnFXnoGpUNxBEOyKHhs8nG/Fsp8NhLnde5nrbX4Qfzu0uHL4L5t7puRXZjcywoeCf3uE5GcHxpu6KrYoxIrRWguU8JMDjuSLMqFOfJy+PuxWyzT7Y7mQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XdQkScqp1Du3GNwdsHeULg1BMP8sOJhVqPuPajwADNI=;
 b=HPZsL3WWmRC2xKG2qWs0Ifr48aSPMGq1SjrANfO0QYLVAilYMyk7NEnxOi0gH60n4B8ZOtmLJrDSRrDBVWRzADMicXRhjFYI1LaeOJrJJgD3DicYGwohe5Cy7zD5+yPR5EILpsDG5YN2DMoXeHU1zLPEx8rvlqNIjfMP6dEZ9cE=
Received: from DU2PR04CA0213.eurprd04.prod.outlook.com (2603:10a6:10:2b1::8)
 by DB9PR08MB7649.eurprd08.prod.outlook.com (2603:10a6:10:30c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Mon, 27 Apr
 2026 16:13:14 +0000
Received: from DB1PEPF000509ED.eurprd03.prod.outlook.com
 (2603:10a6:10:2b1:cafe::3d) by DU2PR04CA0213.outlook.office365.com
 (2603:10a6:10:2b1::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9846.26 via Frontend Transport; Mon,
 27 Apr 2026 16:13:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509ED.mail.protection.outlook.com (10.167.242.71) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9791.48
 via Frontend Transport; Mon, 27 Apr 2026 16:13:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=G2aokcWvN+htDks22t5U2Y5z4KfuBw2Apmi2rbk+KlED1e3nyxGz778qXVZ6vF15DtDwOYCTuPATegP76emLzvYwqXkApUJsJh3XDYZJZ/FXGyWA0XOHzohjXTghy8KtMdIzFfMTmWVD3HwUrDy99VRYRDtnLnnf8sSJ8itWpMNTRBDtiWypXwYM+RTJc1iOS+sGSL69452zEmLC9f39hWJ4QkOR2rHVlYIh6dvzM5ZMZEZ5unNdMyEaWS8w2PcJPnEQ3wCUYxekNEizIstJ+5alN+qbbdom4lI9c83HuW0unIr2jIrvh3Ssj3MiXDl5DbCHWZGIRd0UWffe0yTunw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XdQkScqp1Du3GNwdsHeULg1BMP8sOJhVqPuPajwADNI=;
 b=mqCbgVEUmEWFuL7DA7fDSWjHC8pB+ea/fDZ3ADKuQkW5wdT3CeeHTkFvnf6C6+Zv4cxgaytd8qei2JvmAC9/BLX/6vR8J5e2ttWDB9CziojBR5ELvm/elN25hPLtZuqJ9aaXqlnvshLAwYfFAFvVkw83qEjfHJyjbwHZQH/0VN7LEbPuYvZC3qmsxBeH/OsAkXJA+Bp45VhHSY0pI8Ursr772ULcKWVpD3ATJ3DC2h7zgp0NBIyNJSSI5TMBgWLwbc+iRGoqhEntwtjjZYoSpkW8QNBrZJSwLm8HxA+N3EZCtU3kkUXnpx1ZViBsst+Yd7NsszSvHwjpxz+kz5wTsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XdQkScqp1Du3GNwdsHeULg1BMP8sOJhVqPuPajwADNI=;
 b=HPZsL3WWmRC2xKG2qWs0Ifr48aSPMGq1SjrANfO0QYLVAilYMyk7NEnxOi0gH60n4B8ZOtmLJrDSRrDBVWRzADMicXRhjFYI1LaeOJrJJgD3DicYGwohe5Cy7zD5+yPR5EILpsDG5YN2DMoXeHU1zLPEx8rvlqNIjfMP6dEZ9cE=
Received: from VI1PR08MB3408.eurprd08.prod.outlook.com (2603:10a6:803:7c::10)
 by PAXPR08MB7383.eurprd08.prod.outlook.com (2603:10a6:102:22e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Mon, 27 Apr
 2026 16:12:11 +0000
Received: from VI1PR08MB3408.eurprd08.prod.outlook.com
 ([fe80::6daa:d2f4:acf1:84ba]) by VI1PR08MB3408.eurprd08.prod.outlook.com
 ([fe80::6daa:d2f4:acf1:84ba%7]) with mapi id 15.20.9846.025; Mon, 27 Apr 2026
 16:12:11 +0000
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
Subject: [PATCH 18/43] KVM: arm64: gic-v5: Define remaining IRS MMIO registers
Thread-Topic: [PATCH 18/43] KVM: arm64: gic-v5: Define remaining IRS MMIO
 registers
Thread-Index: AQHc1mCagCdxNLkTJEG77syuWaw5DA==
Date: Mon, 27 Apr 2026 16:12:11 +0000
Message-ID: <20260427160547.3129448-19-sascha.bischoff@arm.com>
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
	VI1PR08MB3408:EE_|PAXPR08MB7383:EE_|DB1PEPF000509ED:EE_|DB9PR08MB7649:EE_
X-MS-Office365-Filtering-Correlation-Id: 11796e11-c3af-46aa-4a76-08dea477e273
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|366016|1800799024|38070700021|22082099003|18002099003|56012099003|18096099003;
X-Microsoft-Antispam-Message-Info-Original:
 TgXbiHUR7vtXG+5uJfxN4sVzMAE4hJ4kk3LU1wmYOl0v4x4MLGNIwNWkf3d0jfL96Rofw6yjHe3aOHF+a8XbBmNQ4OvskT8+ei4ezueVUj5BZSv9o2qpI4mwhabCVSwYuo1FO2skOeYHaPkj6JjMuNQlsyShuwlgXwYfWUHO+MwtflkDSXMSKnhlXMF/Rk7fV5SIi3nU3RCugPwLFkt7IeZvuCL3NeSBaGJ1eORosptkUn/uoDuv3zuBcKTaB9DmgWnl4SzRWB6QOndb8LZdVI2qhkpYUeSQW7e6T3Wt8UqeTZwT5pXn/Bv5wqSXT3ASLbjIZ+9W48ZmZ37NipulUvBvfqiXnhC08DJlZ62WwxQZjRc8ZH3P07dBrk1+k3Bh1f/kYDXUKg4fCHZhOV9F/1ejWaGPIL0tYNEkO37QEU8S0NHjdQ4dtc4roQ3WfS1+DuB1rJ5AI9rfUDKuWAZ0z+0eAx6mI4EPXP0pYMEXZk63CN95I+wzfNdcowbkcluKYVWy/0rzPwzlKkq4yu5dJXii0ZbAUL0Wni1O0ik44YMJ61/0KOnhy2IKaMoxxI5GX+ATU4vh6aWYsVx5rvCpRq2EtWiuyT4vZDmLFj4xBGkvezMQANKK4xkX/cL51nwt9jhgo45uA/H9568f1TW9z0Cwc2yD1QFLpyKaRvTE1CTfkN//KY1iMMpv7MuYyYZYuLDu1Zet+I8Yz85/jPCX8dqlSk4fufmD1PSiJxXZ4fKX9ph8Q/eu7EkuPfVbLny+7DkE/60QR/3xbqDujw8Ci7BPek1/8gZDO6e8p++m54U=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3408.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700021)(22082099003)(18002099003)(56012099003)(18096099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 GnTqohGXl/MNWPxqSZnzKmmsyhsDtMFTIfz+ODZufZtr1XUKh5JCqLyncTn4ZmnP+RU/I+gc7KHbjDiigv6sMLz672kmrKh4RxpDUeWgoBABqxKMA4LU00PbiibMnMsW3qTBg+jrIaOcfTF3+KCZZ6d8u6+ATeFl/kHTOeA6r3ZNB4r8T+dbxHUPKL1omz/2WRsxpMZ7aj3jS63wm283uqr6p+A5T14+dnPQYRvCigvBZJ9FnzXQRdcYrFBSsnINhRBmY5oOGCw3WAZRbTxrReac2cTFb6kG+v1OmlhoSsG3/FGZ3cwUZzyMsVW59lVmpWbP3gylbtazX3bZNmoa2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR08MB7383
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509ED.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	2553b8fd-5468-42e0-086a-08dea477bd27
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|14060799003|35042699022|82310400026|1800799024|376014|56012099003|18002099003|22082099003|18096099003;
X-Microsoft-Antispam-Message-Info:
	FWRQNKhIFrEgsb0aswdsg2DfPmJudqNh72pe6c7cnRqTkYjQxGgP6Sv6sq4WO7rt0arHDeDFvX4lQ4bXpDGqa8VPFfgNNAV0Kio/dfs0lQT9WgyozDpyk0wQswTOo9M0fHIuwMuAxVCggqcX2WDmDICxMuIMWK2Cflbn9ZaZS+vT3pjDVPQPFL/c8i1JcmV3Bx4Nge0luSkXFrb00Hbpcl+p4aSw79RuULzf7F+uGbTRD49Wz2caVEl6EE36i7cq3LhUBE/caUh05Q03FboHBKNy/LL4/6KbGcC2xT3ttwUyXGtvwp7GC2LVjA5UnGRUXCBrWEA4ATggmZJRl3d0lOPf6MGbXnvrxwHphWWZhtgLu2tQj65V0RX0YYyaVmF3h7CE+MMJbsFi4mab5oI1POGPvl9x4Y3eprQNXWJ9/Oamkd2CUgDaufNNlh2kdnpyefHA12z4JN6IzieE+zsiz14ykFk3lfNBxgU4A26VkH7SWFs9FaCrrQP2OcZ29mPso6RUXxTuKyiRJRM04vWNmHTrTPqOff/B084h4wPaMajW5ynDBbmMYKYR7HBQGmRgZEP+Kym895u+eQUpznsNjMQmg/j7nWB4Bt1zVGMwTeBwVs1BqeJAGMc0sZzs2Bwxj0IpVysQgIEx5TOxOFNTqpz7hEMKtoT9ZO+isJtDxtauQDCsgkCjLq55omGftpSUJi4/VU34EGpjB2p7iBDntA4E5dFgCGsOISg0XevpCX17Q1Si3h8OnJuVdwAYp4vb8u7Svt5aCO9z+VO+kaICeg==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(14060799003)(35042699022)(82310400026)(1800799024)(376014)(56012099003)(18002099003)(22082099003)(18096099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	VEzRb8nTR+5QOYG8XuGPeHzM4QtnlTyeqFHZjQJRCpXykka0IQxSBPuTH15s2X8s0S77KZSsg9x27rcd0lrrmi9rhX2PgtT45akCC9hrR+EZUsA5YXYh0r1780F1wDijVo0D/klzCI+UVr1efJOy3+QnbV/Ts1qpK3DruhzBwr5USzE4Z6tUJxxxXR9X3IET5ZucUzDDmsAPIm4Yknlc1kT56dqVqzArxrwyjXJZY2MTOTr8/zdqqVqw2qYYKA+BRWIfhNPw/geKvBw/BnzwKF0YItdeWjn14kzo8rNGuawVrDn9VfzYO5SmIhvnj6XgCx6CfO5VhD6IeS4JLwE/CeVr1aaU0XJNhR4fTA7JFh+jPP3goxZXM+xdndHDDCHVgQmPu/DZ3jER7k/QFGbIA6pSzvJ9htpePIMxjUry7DLXWMrShYOwnnAK2cKGPISQ
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2026 16:13:13.9379
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 11796e11-c3af-46aa-4a76-08dea477e273
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509ED.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB7649

Complete the set of defined IRS MMIO registers in the GICv5 header
file. Up until now, the set of defined IRS MMIO registers has been
driven by code requirements. However, in order to properly emulate the
IRS MMIO interface in KVM, the complete set of IRS MMIO registers
needs to be added.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 include/linux/irqchip/arm-gic-v5.h | 105 ++++++++++++++++++++++++++---
 1 file changed, 96 insertions(+), 9 deletions(-)

diff --git a/include/linux/irqchip/arm-gic-v5.h b/include/linux/irqchip/arm=
-gic-v5.h
index 54b573783cd75..9ea3674a6613b 100644
--- a/include/linux/irqchip/arm-gic-v5.h
+++ b/include/linux/irqchip/arm-gic-v5.h
@@ -62,6 +62,14 @@
 #define GICV5_OUTER_SHARE		0b10
 #define GICV5_INNER_SHARE		0b11
=20
+#define GICV5_AIDR_COMPONENT_IRS	0b00
+#define GICV5_AIDR_COMPONENT_ITS	0b01
+#define GICV5_AIDR_COMPONENT_IWB	0b10
+
+#define GICV5_AIDR_ARCH_MAJ_REV_V5	0
+#define GICV5_AIDR_ARCH_MIN_REV_V0	0
+#define GICV5_IIDR_IMPLEMENTER_ARM	0x43b
+
 /*
  * IRS registers and tables structures
  */
@@ -73,11 +81,16 @@
 #define GICV5_IRS_IDR5			0x0014
 #define GICV5_IRS_IDR6			0x0018
 #define GICV5_IRS_IDR7			0x001c
+#define GICV5_IRS_IIDR			0x0040
+#define GICV5_IRS_AIDR			0x0044
 #define GICV5_IRS_CR0			0x0080
 #define GICV5_IRS_CR1			0x0084
 #define GICV5_IRS_SYNCR			0x00c0
 #define GICV5_IRS_SYNC_STATUSR		0x00c4
+#define GICV5_IRS_SPI_VMR		0x0100
 #define GICV5_IRS_SPI_SELR		0x0108
+#define GICV5_IRS_SPI_DOMAINR		0x010c
+#define GICV5_IRS_SPI_RESAMPLER		0x0110
 #define GICV5_IRS_SPI_CFGR		0x0114
 #define GICV5_IRS_SPI_STATUSR		0x0118
 #define GICV5_IRS_PE_SELR		0x0140
@@ -92,17 +105,48 @@
 #define GICV5_IRS_VMT_STATUSR		0x0214
 #define GICV5_IRS_VPE_SELR		0x0240
 #define GICV5_IRS_VPE_DBR		0x0248
+#define GICV5_IRS_VPE_HPPIR		0x0250
 #define GICV5_IRS_VPE_CR0		0x0258
 #define GICV5_IRS_VPE_STATUSR		0x025c
+#define GICV5_IRS_VM_DBR		0x0280
+#define GICV5_IRS_VM_SELR		0x0288
+#define GICV5_IRS_VM_STATUSR		0x028c
 #define GICV5_IRS_VMAP_L2_VMTR		0x02c0
 #define GICV5_IRS_VMAP_VMR		0x02c8
 #define GICV5_IRS_VMAP_VISTR		0x02d0
+#define GICV5_IRS_VMAP_L2_VISTR		0x02d8
 #define GICV5_IRS_VMAP_VPER		0x02e0
-
+#define GICV5_IRS_SAVE_VMR		0x0300
+#define GICV5_IRS_SAVE_VM_STATUSR	0x0308
+#define GICV5_IRS_MEC_IDR		0x0340
+#define GICV5_IRS_MEC_MECID_R		0x0344
+#define GICV5_IRS_MPAM_IDR		0x0380
+#define GICV5_IRS_MPAM_PARTID_R		0x0384
+#define GICV5_IRS_SWERR_STATUSR		0x03c0
+#define GICV5_IRS_SWERR_SYNDROMER0	0x03c8
+#define GICV5_IRS_SWERR_SYNDROMER1	0x03d0
+
+#define GICV5_IRS_SETLPIR		0x0000
+
+#define GICV5_IRS_IDR0_IRSID		GENMASK(31, 16)
+#define GICV5_IRS_IDR0_SWE		BIT(12)
+#define GICV5_IRS_IDR0_MPAM		BIT(11)
+#define GICV5_IRS_IDR0_MEC		BIT(10)
+#define GICV5_IRS_IDR0_SETLPI		BIT(9)
+#define GICV5_IRS_IDR0_VIRT1OFN		BIT(8)
+#define GICV5_IRS_IDR0_ONEOFN		BIT(7)
 #define GICV5_IRS_IDR0_VIRT		BIT(6)
+#define GICV5_IRS_IDR0_PA_RANGE		GENMASK(5, 2)
+#define GICV5_IRS_IDR0_DOM		GENMASK(1, 0)
+
+#define GICV5_IRS_IDR0_DOMAIN_SECURE		0b00
+#define GICV5_IRS_IDR0_DOMAIN_NON_SECURE	0b01
+#define GICV5_IRS_IDR0_DOMAIN_EL3		0b10
+#define GICV5_IRS_IDR0_DOMAIN_REALM		0b11
=20
 #define GICV5_IRS_IDR1_PRIORITY_BITS	GENMASK(22, 20)
 #define GICV5_IRS_IDR1_IAFFID_BITS	GENMASK(19, 16)
+#define GICV5_IRS_IDR1_PE_CNT		GENMASK(15, 0)
=20
 #define GICV5_IRS_IDR1_PRIORITY_BITS_1BITS	0b000
 #define GICV5_IRS_IDR1_PRIORITY_BITS_2BITS	0b001
@@ -118,6 +162,10 @@
 #define GICV5_IRS_IDR2_LPI		BIT(5)
 #define GICV5_IRS_IDR2_ID_BITS		GENMASK(4, 0)
=20
+#define GICV5_IRS_IST_L2SZ_SUPPORT_4KB(r)	FIELD_GET(BIT(11), (r))
+#define GICV5_IRS_IST_L2SZ_SUPPORT_16KB(r)	FIELD_GET(BIT(12), (r))
+#define GICV5_IRS_IST_L2SZ_SUPPORT_64KB(r)	FIELD_GET(BIT(13), (r))
+
 #define GICV5_IRS_IDR3_VMT_LEVELS	BIT(10)
 #define GICV5_IRS_IDR3_VM_ID_BITS	GENMASK(9, 5)
 #define GICV5_IRS_IDR3_VMD_SZ		GENMASK(4, 1)
@@ -130,9 +178,14 @@
 #define GICV5_IRS_IDR6_SPI_IRS_RANGE	GENMASK(24, 0)
 #define GICV5_IRS_IDR7_SPI_BASE		GENMASK(23, 0)
=20
-#define GICV5_IRS_IST_L2SZ_SUPPORT_4KB(r)	FIELD_GET(BIT(11), (r))
-#define GICV5_IRS_IST_L2SZ_SUPPORT_16KB(r)	FIELD_GET(BIT(12), (r))
-#define GICV5_IRS_IST_L2SZ_SUPPORT_64KB(r)	FIELD_GET(BIT(13), (r))
+#define GICV5_IRS_IIDR_PRODUCT_ID	GENMASK(31, 20)
+#define GICV5_IRS_IIDR_VARIANT		GENMASK(19, 16)
+#define GICV5_IRS_IIDR_REVISION		GENMASK(15, 12)
+#define GICV5_IRS_IIDR_IMPLEMENTER	GENMASK(11, 0)
+
+#define GICV5_IRS_AIDR_COMPONENT	GENMASK(11, 8)
+#define GICV5_IRS_AIDR_ARCHMAJORREV	GENMASK(7, 4)
+#define GICV5_IRS_AIDR_ARCHMINORREV	GENMASK(3, 0)
=20
 #define GICV5_IRS_CR0_IDLE		BIT(1)
 #define GICV5_IRS_CR0_IRSEN		BIT(0)
@@ -155,21 +208,39 @@
=20
 #define GICV5_IRS_SYNC_STATUSR_IDLE	BIT(0)
=20
-#define GICV5_IRS_SPI_STATUSR_V		BIT(1)
-#define GICV5_IRS_SPI_STATUSR_IDLE	BIT(0)
+#define GICV5_IRS_SPI_VMR_VIRT		BIT_ULL(63)
+#define GICV5_IRS_SPI_VMR_VM_ID		GENMASK_ULL(15, 0)
=20
 #define GICV5_IRS_SPI_SELR_ID		GENMASK(23, 0)
=20
+#define GICV5_IRS_SPI_DOMAINR_DOMAIN	GENMASK(1, 0)
+
+#define GICV5_IRS_SPI_DOMAINR_DOMAIN_SECURE	0b00
+#define GICV5_IRS_SPI_DOMAINR_DOMAIN_NON_SECURE	0b01
+#define GICV5_IRS_SPI_DOMAINR_DOMAIN_EL3	0b10
+#define GICV5_IRS_SPI_DOMAINR_DOMAIN_REALM	0b11
+
+#define GICV5_IRS_SPI_RESAMPLER_RESAMPLE	BIT(0)
+
 #define GICV5_IRS_SPI_CFGR_TM		BIT(0)
=20
+#define GICV5_IRS_SPI_CFGR_TM_EDGE	0b0
+#define GICV5_IRS_SPI_CFGR_TM_LEVEL	0b1
+
+#define GICV5_IRS_SPI_STATUSR_V		BIT(1)
+#define GICV5_IRS_SPI_STATUSR_IDLE	BIT(0)
+
 #define GICV5_IRS_PE_SELR_IAFFID	GENMASK(15, 0)
=20
+#define GICV5_IRS_PE_STATUSR_ONLINE	BIT(2)
 #define GICV5_IRS_PE_STATUSR_V		BIT(1)
 #define GICV5_IRS_PE_STATUSR_IDLE	BIT(0)
=20
 #define GICV5_IRS_PE_CR0_DPS		BIT(0)
=20
-#define GICV5_IRS_IST_STATUSR_IDLE	BIT(0)
+#define GICV5_IRS_IST_BASER_ADDR_MASK	GENMASK_ULL(55, 6)
+#define GICV5_IRS_IST_BASER_VALID	BIT_ULL(0)
+#define GICV5_IRS_IST_BASER_ADDR_SHIFT	6ULL
=20
 #define GICV5_IRS_IST_CFGR_STRUCTURE	BIT(16)
 #define GICV5_IRS_IST_CFGR_ISTSZ	GENMASK(8, 7)
@@ -187,8 +258,7 @@
 #define GICV5_IRS_IST_CFGR_L2SZ_16K	0b01
 #define GICV5_IRS_IST_CFGR_L2SZ_64K	0b10
=20
-#define GICV5_IRS_IST_BASER_ADDR_MASK	GENMASK_ULL(55, 6)
-#define GICV5_IRS_IST_BASER_VALID	BIT_ULL(0)
+#define GICV5_IRS_IST_STATUSR_IDLE	BIT(0)
=20
 #define GICV5_IRS_MAP_L2_ISTR_ID	GENMASK(23, 0)
=20
@@ -213,12 +283,24 @@
 #define GICV5_IRS_VPE_DBR_DBPM		GENMASK_ULL(36, 32)
 #define GICV5_IRS_VPE_DBR_LPI_ID	GENMASK_ULL(23, 0)
=20
+#define GICv5_VPE_HPPIR_HPPIV		BIT_ULL(32)
+#define GICv5_VPE_HPPIR_TYPE		GENMASK_ULL(31, 29)
+#define GICv5_VPE_HPPIR_ID		GENMASK_ULL(23, 0)
+
 #define GICV5_IRS_VPE_CR0_DPS		BIT(0)
=20
 #define GICV5_IRS_VPE_STATUSR_F		BIT(2)
 #define GICV5_IRS_VPE_STATUSR_V		BIT(1)
 #define GICV5_IRS_VPE_STATUSR_IDLE	BIT(0)
=20
+#define GICV5_IRS_VM_DBR_EN		BIT_ULL(63)
+#define GICV5_IRS_VM_DBR_VPE_ID		GENMASK_ULL(15, 0)
+
+#define GICV5_IRS_VM_SELR_VM_ID		GENMASK(15, 0)
+
+#define GICV5_IRS_VM_STATUSR_V		BIT(1)
+#define GICV5_IRS_VM_STATUSR_IDLE	BIT(0)
+
 #define GICV5_IRS_VMAP_L2_VMTR_M	BIT_ULL(63)
 #define GICV5_IRS_VMAP_L2_VMTR_VM_ID	GENMASK_ULL(15, 0)
=20
@@ -231,6 +313,11 @@
 #define GICV5_IRS_VMAP_VISTR_VM_ID	GENMASK_ULL(47, 32)
 #define GICV5_IRS_VMAP_VISTR_TYPE	GENMASK_ULL(31, 29)
=20
+#define GICV5_IRS_VMAP_L2_VISTR_M	BIT_ULL(63)
+#define GICV5_IRS_VMAP_L2_VISTR_VM_ID	GENMASK_ULL(47, 32)
+#define GICV5_IRS_VMAP_L2_VISTR_TYPE	GENMASK_ULL(31, 29)
+#define GICV5_IRS_VMAP_L2_VISTR_ID	GENMASK_ULL(23, 0)
+
 #define GICV5_IRS_VMAP_VPER_M		BIT_ULL(63)
 #define GICV5_IRS_VMAP_VPER_VM_ID	GENMASK_ULL(47, 32)
 #define GICV5_IRS_VMAP_VPER_VPE_ID	GENMASK_ULL(15, 0)
--=20
2.34.1
