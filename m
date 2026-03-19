Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011038.outbound.protection.outlook.com [52.101.65.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8779C3E8C5E
	for <kvmarm@lists.linux.dev>; Thu, 19 Mar 2026 15:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.38
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773935577; cv=fail; b=uO/Nt0MT9HuNMfXCCxfFrw9SsI+eoNrhr5L3LBoXnPVaNblU8g8xzpwbP3RNdfYXDI9x5qjF0Nv98jM7ujEa1Mc2uPDiGz04ClAXPAnjxdRjdcsSIWc0CX1Fk++IZEQ841DnwPDf0jkGccDNSoQ2uQkobQ16RjIJbKuPxYx8+O0=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773935577; c=relaxed/simple;
	bh=IxQKQKwuM3NhVHsNFS/xQcWptvR/kylPD4nwQYjeerw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=n32pK16uiOM4PpFiLRGqx6h/9ZCpD94YmR9hxTGFT8u05nNXTUguTpMUla42yFK0sFsjug1LlnD251Tnx88agq39UsOwc2LyY52cYrrdZY6R0DHXWsb/TyYGJC2ckyFytOmgnLpiff0JvVnSHqkA+HgARpXmm0TDisd6O3E0FLU=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=h5mtJQKp; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=h5mtJQKp; arc=fail smtp.client-ip=52.101.65.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="h5mtJQKp";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="h5mtJQKp"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=izl5SQYLfGN7bMyiaUheGLfVw4RGfF3X5teT1VbvATa7QXcKlNin+90WTB5pIIvZ6loAM06fY+kiloHgJybOXkXPzGdGOiUqIl0RAnkjpnSy8h8X3bEjFwXZ9EY4SUuSxkyVrFklsLOYT04OREg/y3T5ejKToF9tuXK9/J/d7gX+E84n1BmvpFPUy7wvnIM/kTll4R89EuLX85owMHyghT2Rl/ijjhX4gPHAjZTNBOfGzzbhuEgHlYLCFkCT7hrOEp+eXuwRvUvN6tGrj8ziSIxgePCg2mn7lZFw2dC4cLUsOFJtuVYqDnlfwCAbkVEZR17dpWUhP+bvNeOxuKbHLg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YfZCFtsrXjI9tri9qxMnc13g8Gmgfqy3pw/vOMTFgkE=;
 b=LmtvNRjvbLI3NrszuV7sclP0l/nqUwNZ6fC7j/wOcoiWAKSbqJ43wmTvACo1GykZG4UcB8ebrZTBzX3s3FPRmRPgsxx7UkRkTT/8pIeTwjqeAWSn7tnU1Yy6dn3Zc1moY9zzz3hcCX6KQT+7fDkyfR7RFRwaIA+PwmeDfCE4ugtk68oV4NYAlUUNygMKuiu+EiPJdgy2Dw072q7SA3JnCFBJsBDW/yiZ7L6gPiQYSRlR78rmV956rFTI19/diRZlFH4TRHRRVfW2QIUX0VrRIXV5g2N+tBT7jzWNfgTbPZ8lHqGhhTOW0qpA+tEzWxjJiRflMAgMKRBVzA757dY1JA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YfZCFtsrXjI9tri9qxMnc13g8Gmgfqy3pw/vOMTFgkE=;
 b=h5mtJQKp8KGZo3KAu2sntuHPxuGNxuhZuMAdDbnOJ22mtFtqTCfKc2mPhMHPNv6Exu6/t86QqKLZ/PkQ+vHbYxcnJXKkUbCSo3YY8J3FgyPbP4AdK/VThgvZxga3XZ+pjWIvB1z6bC/JUmZ7d1Az0UQflsLSnUqzL5RYIqCJJa0=
Received: from AM0PR05CA0089.eurprd05.prod.outlook.com (2603:10a6:208:136::29)
 by MRWPR08MB11758.eurprd08.prod.outlook.com (2603:10a6:501:98::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Thu, 19 Mar
 2026 15:52:51 +0000
Received: from AM1PEPF000252DE.eurprd07.prod.outlook.com
 (2603:10a6:208:136:cafe::4e) by AM0PR05CA0089.outlook.office365.com
 (2603:10a6:208:136::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9700.27 via Frontend Transport; Thu,
 19 Mar 2026 15:52:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM1PEPF000252DE.mail.protection.outlook.com (10.167.16.56) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.19
 via Frontend Transport; Thu, 19 Mar 2026 15:52:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IE3H0zfvgyxeiQ/PhKrfHkyIzvWjvJn+sS6afXdI+7dqQ/F1dQSeNpFV2cFqMWnCd6M+3whk3e5zi4G34ucEF2MyVbY8NSqLwWps6nhhIf01dOP/aH0f0jyNd/xOjep7uUH6ICntC5QqQLd82i2UA4mBKxC+4uOah1WH6fUTx5BbqgTZWeMXpcuAvG1vC/4womCfvdzOSgbiIwwEAuGxlAcUlol/veDtkqHQAu3+4khTls3YO1q6P59nBBLxRV+5/RJ3fGOL5SWpizQADLGWppNpZMwjGLs1ntBVlSu3LCEUF2Z3kjLDXcHto/HvuwWfW08B47XO/ZatzmiffmD/3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YfZCFtsrXjI9tri9qxMnc13g8Gmgfqy3pw/vOMTFgkE=;
 b=yYXcBApiVzkDn3RyoVhuX1OZjoHp3/caMs2bmrYPPhlhSGrzVY0NE3bZ0VAaBgLBh/zLG1gHy+dIr0Es1XijVQLP/V9GZ4OAd89TDv00UEfIRrLKs29142IDyYUMuUm4t8UiayyZO1qgApwJr16c4Mk0DVrUPvMtPCNxCA4tC5CbOXozrEUqIAmYGe7G75MirQnqugs2NBggCjSM2QD7J4eO9i0vsQrJzGDRUTjMidQmQBs/d1g11elfIkAYoizGk7Y10Qa0CIGEIdfcN2F39yxFItByADAoNOlUoPLRgTLTrxX8y4sRpG4QtGS/3FGlC/sRfJIcvN21jUSENGsp9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YfZCFtsrXjI9tri9qxMnc13g8Gmgfqy3pw/vOMTFgkE=;
 b=h5mtJQKp8KGZo3KAu2sntuHPxuGNxuhZuMAdDbnOJ22mtFtqTCfKc2mPhMHPNv6Exu6/t86QqKLZ/PkQ+vHbYxcnJXKkUbCSo3YY8J3FgyPbP4AdK/VThgvZxga3XZ+pjWIvB1z6bC/JUmZ7d1Az0UQflsLSnUqzL5RYIqCJJa0=
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com (2603:10a6:20b:504::10)
 by AS2PR08MB10250.eurprd08.prod.outlook.com (2603:10a6:20b:641::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Thu, 19 Mar
 2026 15:51:48 +0000
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27]) by AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27%6]) with mapi id 15.20.9723.018; Thu, 19 Mar 2026
 15:51:47 +0000
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
Subject: [PATCH v7 08/41] KVM: arm64: gic-v5: Add ARM_VGIC_V5 device to KVM
 headers
Thread-Topic: [PATCH v7 08/41] KVM: arm64: gic-v5: Add ARM_VGIC_V5 device to
 KVM headers
Thread-Index: AQHct7hLgR855+nEDEOfwM27JPmJjA==
Date: Thu, 19 Mar 2026 15:51:47 +0000
Message-ID: <20260319154937.3619520-9-sascha.bischoff@arm.com>
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
	AS4PR08MB8241:EE_|AS2PR08MB10250:EE_|AM1PEPF000252DE:EE_|MRWPR08MB11758:EE_
X-MS-Office365-Filtering-Correlation-Id: 041fc941-6f86-495c-1974-08de85cf9310
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|38070700021|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 OZh6uX+KOHrRrNaWZUqp/oVCk6lbgOn2Mpj91M4nryfWo3o7rf4qWPQvWCR5miedpBIHPiZuBaGInvI3LrNzYsBd++0dVB32geuC3FM4AGTzK4Qnm+2Q71tirRbVkjOKlAEDjV9P38axZsnS4JAZkgyAY2G9vY98w4AGSoNRWRK731PqADLGAoCVchvSmU6kU8LM9h3KlTYJI18H1SOK/i9XE8zQp1+QEhyWghS/n4Ao/9PgXVLLJpmq/Ou9Gbx5QJVR+WUgzVGjINO5HLYJDWPd3XkIh9MccpwvULQIZ6wmtSoFpxTNERpjJCpGhdpVMET3lVPdivyBR3xtzGYIk8sOdryNfbPHygcgnnSt3x/p/w+9VfK8RsEdDxG2iWyLpzjIedZo4BCKUtukW6Zkr7WZLSKpki2YxRhqMVcsgGONxwubyKFlvURwjtYV35Lyk6hg5MpgghcE7SdOrAVM3yeVkhRQjvxpZeO4KHPuL0Ma8ay0wNzcP7BY04eD8/9UzOsXDnLEuh39vgkjfL5pjyk29g9/+Y3t5IQpq9NUOxHZSh9q9V23FEuMMwM8/WzBpZozNc9nhYGdPS/1MxVj8mBfRmb8//8Z3YpxP6zafXSN2U4o1a8Y9pKBhJbe0Vf7t5DJZaJoh8P9IegaLg+btVRb7Gg3cRg6qrfcroPsEwory2fO9mCnsky1k9QqM358mBWdp3Q7/sEO5INoABsIXMVAS50C20pZvbi5hdJq/gP7Yb7v4zOlQ24VVGq5Iixgck5Na4oOWfzRYIlAQ0k7QYhf4O+Csp1Y+gyiwp3QO1Y=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS4PR08MB8241.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700021)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 gzz6BKm/bw3zuW24y22lRWjMDs0Oj/71tpUPLAVbEAJ8uQY6aMyZKy88mtGoX3fob8XlVebw+MXaUhdKuWYDjhMAE1j77nKO/I+MphDIBdu4wszcGwcQgBtN5kAIVf5E12Cmzc6lze8Pm7sSK5es0zL1ibPIU1GHQpC5ayTkmYDzRZIoOGdpUhj/5p3059U5inmmYkUQFrikCRL+i122x/Lto0qAZrShgil2O7q0aZCXvaXCzvfxGGEa8upv9e5A5COSygsA1uZuh+JtMm5hSoM0VXQR+BN81LMqF88Be1VTmJP2X7hGyQBYL4qE0f224p6h4r8EUmqSgu0giXBcmQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB10250
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM1PEPF000252DE.eurprd07.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	8c10fb80-04b4-429c-7d0f-08de85cf6dbc
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|35042699022|14060799003|376014|1800799024|36860700016|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	nTeMUnfgk+a19TqhZ1qYOCeDY+Mbex1ScJMUHFTmOV5XH+t2HjwAtH0mhiJX1ct/pQW8hMui/QqXBPhjRi3SL1k8i2y0PWq00+jEuemPbNkeU9ylLsYuoP77s3oW6NICITGPEmFrO2v5RPWV01W5WzZfhRLtyVeHMVhtu3H+Ku2gq1OztnLRGv5/PU4Q/Pgem/yyzvKDBBJbY0wWxW5J6/7fak2DD1dcfVISOseI89fw6Slgdc/5Vm82grH/D7/aJYxHZ3zwGIGWJMrfVMIczFVhKf9Dg+y9k2ezVb1sc/WQnma8Kk5/IIUgXGWqLZuQVX009pRS3COQlDR6NNBzWjVyIOLeTqT4avDPeUe73HLbCe4FSR4sO+pM6rXN6bAThB9y1ViFiRQOOzAopKsHFHgyEXf05FTwBps/DhQclS0o4UvJhYeIdltqSeFoBPj2AyrlxHAwZn68u+d4bI23MGFlobnWEjCrFnoN1WLzqR1MHQE5aeH+6Rg7p+Cy/x25EjsCw5aS4HyzX/UG1Jutu789Hml7n6sipgDqcJv5gfzUfBvmHecFFMSu1W51JhgMFgOSEANjaLPKj9QUe1W0MxAPDYmswPz8WlIjlfSHDuDcL5PrfnDjNOXp4Y8vPT665dK35+Z2M0nzmNrhZS6ZjBrUTRx4Cufq0jgbj1Uy3Rh58d1M2OlZAAseG4r+d43wqKTf2NLpcwIjTwcPGzA2zCKNIEgTDfKdtgU6FAkzpnWoaODcMG2y0kvot0tyoz491HVpHES8EhJMgqvg5Bsh+w==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(35042699022)(14060799003)(376014)(1800799024)(36860700016)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Ll+IPnQ/FomlJMQ3BnDUCm3w98rzaxup8485XIZEPWvrRtTJqt2XM3I3ouMhr7vVD2IK+3e8c4202HJ0pHXSeAAfbkCljBoAJbwPhRST5Qm4ZvRgdYppcwxNGPE8ktS1cC8nBkfDzGDMLD3ytYXvuIO6u7Zg4NiIgsOmadOslbP4XsetaLir66fjXsDKrOPjxxIsw7UsXf46J3airjsOfN7Nzi5BnH2ASJtvCsg+fJAKqebRm4huPFg8tGmqR3ch3JhtUt4L1FIx8i1WlFRSevYj1cg142hr6IOwdUReGkRS0xzU/RZeJG2Xrc8CeULG8xQHNbMBb0de0upgX/QaOsDTa6ozXVmnvwvQZCCybHXs8J4CfJkoGghzjut0rTC6GNDNBgnaXMN+kodXho7evuA9QEWxuVPxbdeK7xMRtIy3go0cP5nrMUKSqxN/pRtG
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2026 15:52:50.4271
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 041fc941-6f86-495c-1974-08de85cf9310
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM1PEPF000252DE.eurprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MRWPR08MB11758

This is the base GICv5 device which is to be used with the
KVM_CREATE_DEVICE ioctl to create a GICv5-based vgic.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
---
 include/uapi/linux/kvm.h       | 2 ++
 tools/include/uapi/linux/kvm.h | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 80364d4dbebb0..d0c0c86059767 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1224,6 +1224,8 @@ enum kvm_device_type {
 #define KVM_DEV_TYPE_LOONGARCH_EIOINTC	KVM_DEV_TYPE_LOONGARCH_EIOINTC
 	KVM_DEV_TYPE_LOONGARCH_PCHPIC,
 #define KVM_DEV_TYPE_LOONGARCH_PCHPIC	KVM_DEV_TYPE_LOONGARCH_PCHPIC
+	KVM_DEV_TYPE_ARM_VGIC_V5,
+#define KVM_DEV_TYPE_ARM_VGIC_V5	KVM_DEV_TYPE_ARM_VGIC_V5
=20
 	KVM_DEV_TYPE_MAX,
=20
diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kvm.=
h
index 65500f5db3799..713e4360eca00 100644
--- a/tools/include/uapi/linux/kvm.h
+++ b/tools/include/uapi/linux/kvm.h
@@ -1220,6 +1220,8 @@ enum kvm_device_type {
 #define KVM_DEV_TYPE_LOONGARCH_EIOINTC	KVM_DEV_TYPE_LOONGARCH_EIOINTC
 	KVM_DEV_TYPE_LOONGARCH_PCHPIC,
 #define KVM_DEV_TYPE_LOONGARCH_PCHPIC	KVM_DEV_TYPE_LOONGARCH_PCHPIC
+	KVM_DEV_TYPE_ARM_VGIC_V5,
+#define KVM_DEV_TYPE_ARM_VGIC_V5	KVM_DEV_TYPE_ARM_VGIC_V5
=20
 	KVM_DEV_TYPE_MAX,
=20
--=20
2.34.1
