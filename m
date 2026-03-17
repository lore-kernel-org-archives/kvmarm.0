Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012059.outbound.protection.outlook.com [52.101.66.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBC963B0AF3
	for <kvmarm@lists.linux.dev>; Tue, 17 Mar 2026 11:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.59
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773748232; cv=fail; b=Pb+jZq+BGrh+zD/cbB5N+qJLgPVPOnj/JAay1s91cUIJrx5JmA6lqCsvG//eTB0WEJnI3HMUgFK9RWkhk0cOon8QTwotItRvOoh8qEIPEUwdB1YZx0+tRdzVC3sF7XMeDtgSL51utKfRsnCjf+JuYOVl1OirVC3yH7X4z9WpAhU=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773748232; c=relaxed/simple;
	bh=q5gy2AaVDs8MCE7rhPEQzIRf/wVd58xdLeoqYlYvpO8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=c2Z+aFu1tWkWJ3gc0z9A9cxLwBSpDWLwt3llO/WY24E2V8Ra0WVTweHGXKm4kfBQMZEoENCYCnXephzFA5EbHz4ItmmnUA8dSpmEexmT0FrKPj7HI8UIeVaEdNm09nhZcZWP8788PsMXr87F7XjijBRv8zPpiXT+5xYU85IkURU=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=iDjoA8kH; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=iDjoA8kH; arc=fail smtp.client-ip=52.101.66.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="iDjoA8kH";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="iDjoA8kH"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=pccStlslkMB4L3NIVBd+WA5JKrEIMiOorhs/wcXxQDdvROp7UHRg981sB8u87y2EOG7ejpig6QbpaCuBLA45x5EWJtn5kUKDf+ylnPwHxTaQg3GQLyqi6rMUGp+XcH5zHqjIfqtXD26NZylQnMuvx1pDjaWUAKBLAXPjGOMOHBV3BgN2mHqTTZPvBaTm9WlJzOK4hYWh2vVEN+pCHzyX2QVWUOVVmezJG7lt3DbOi9UI+LaCV1m3nIuJRga5qVX0ephoH2kGbrnPFHIvFA/nVw/SLr8zSGoamhciuf9C7UZ2T5xQpCi0VrEIOlmjvFugUSO7W2iRXsH2POD+7s6v3w==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gDZQV/4RuTis6K9nWMpwIW6VTdtu9zU19VjmNoDhv1g=;
 b=jQkA4i5BY2DoCMBLbYrzB8HmNgzOsa+XB9bZWhOFlWskcTSji7/4r/GXeQozQJpG1MvUjvqgKxnyj3n+hRtgLUqXNHlgf2jwP7mVtbEaYYwNcBuyvBEO5pYQJA+jWjzlyIcOCBfAVZj4A2hPW3omdCFX6xm0TWkdc5K70L36Rb2+B0HFCYRSEpWZD4aRuKt6oJUlGZjWG9l67Cvx8zk+DvE/QC5wNx7Gz533E5duYUNDHCd2DfWq124xDY//YNn3OwvbONXsoKYJI5ScYey4cGIFsGafT8n1IxD0ia8qsi8b6INbfi6JMKl6iZwmS0/HGZijHesNKEDMVZeKLlp27Q==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gDZQV/4RuTis6K9nWMpwIW6VTdtu9zU19VjmNoDhv1g=;
 b=iDjoA8kHc2XexSlQmuGcJFMOQi91TI7/N1p6qP10hT2kzq2f+zUGa8cqieoXwjGQPb+KRJh23pODiLPm6+gfEL7vMVedz+eNMDsvG50J44EvrpvVlqfZexWJIzfrlTtky9cIXTfcsUsvsi498Pvewk3YGyuCMeQY5H0dSOvYk4E=
Received: from DU7P191CA0022.EURP191.PROD.OUTLOOK.COM (2603:10a6:10:54e::22)
 by VI1PR08MB10074.eurprd08.prod.outlook.com (2603:10a6:800:1be::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.22; Tue, 17 Mar
 2026 11:50:23 +0000
Received: from DU6PEPF00009527.eurprd02.prod.outlook.com
 (2603:10a6:10:54e:cafe::1d) by DU7P191CA0022.outlook.office365.com
 (2603:10a6:10:54e::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9700.27 via Frontend Transport; Tue,
 17 Mar 2026 11:50:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU6PEPF00009527.mail.protection.outlook.com (10.167.8.8) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9700.17 via
 Frontend Transport; Tue, 17 Mar 2026 11:50:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CkLO3rnAdk6p0tNvXBv2luPrB6uhaqVHYBn1g+wnmm1pdRsUS2eMjict4HKAjWrrsAew04UqaamF3ZJzoOhjUzNstO8bNE9NUvpctKEnrkOfLyHkuQu+SJ5dgZ68Z0yUOJSqlrCR3LPXfZ7/Omtz32S4BRkZ15EEZzKVHHOWordGcxLNikGatA6BvuC/t14W0gJoGl7Bc+uOwoMXGUaveJmeMYW/5dwrQVqBFTz2n4dUOJy7yGWVuJl7F7t/bYRKSqCuqbaM2ajqfG075PIcrQtNOHe+7XiMLqq66kZE3dDgnBRDeTdYS6ZMxpxH+APjG9yoi4BcTAcQstIBQtOHKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gDZQV/4RuTis6K9nWMpwIW6VTdtu9zU19VjmNoDhv1g=;
 b=VboOwUB7ITow6dFXIKSFkIhaZ8A+DD0Gn+CrUv6FKfXXBYzghPHAbhHnYCRrgzhackImsEXOlCvkWaVx7LE5pjYmdJXaLOiTGbk78hNjwMoa1OTMgdd25VfIiEUXI4aerKoSJk1AFO63oFFvKSFat5HkoBXgtNzoU8Nkh+Qc0iYbnJFlNe6dYc/aA7eBGqfoCd7S24rZYXaGwphuCoNlxJLFBzz/rnbF8jJcM0mNUDxdvi5iUQ3iNXX4r6+sUUJtF3OF82M3g6Z0sBWFHVydauzOT6tbK37SYZHceOXDCqspOpZrMKTH/lN1wGILob7EPiySF6Gm2/xFt6hK60hSDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gDZQV/4RuTis6K9nWMpwIW6VTdtu9zU19VjmNoDhv1g=;
 b=iDjoA8kHc2XexSlQmuGcJFMOQi91TI7/N1p6qP10hT2kzq2f+zUGa8cqieoXwjGQPb+KRJh23pODiLPm6+gfEL7vMVedz+eNMDsvG50J44EvrpvVlqfZexWJIzfrlTtky9cIXTfcsUsvsi498Pvewk3YGyuCMeQY5H0dSOvYk4E=
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com (2603:10a6:20b:504::10)
 by DB9PR08MB8483.eurprd08.prod.outlook.com (2603:10a6:10:3d5::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.24; Tue, 17 Mar
 2026 11:49:18 +0000
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27]) by AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27%6]) with mapi id 15.20.9700.022; Tue, 17 Mar 2026
 11:49:17 +0000
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
Subject: [PATCH v6 36/39] Documentation: KVM: Introduce documentation for
 VGICv5
Thread-Topic: [PATCH v6 36/39] Documentation: KVM: Introduce documentation for
 VGICv5
Thread-Index: AQHctgQVsspELgJw6Uyx1mRDvXuknA==
Date: Tue, 17 Mar 2026 11:49:17 +0000
Message-ID: <20260317113949.2548118-37-sascha.bischoff@arm.com>
References: <20260317113949.2548118-1-sascha.bischoff@arm.com>
In-Reply-To: <20260317113949.2548118-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AS4PR08MB8241:EE_|DB9PR08MB8483:EE_|DU6PEPF00009527:EE_|VI1PR08MB10074:EE_
X-MS-Office365-Filtering-Correlation-Id: e6dfb04e-d7b8-46ef-a5e1-08de841b5f30
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|38070700021|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info-Original:
 BjW2Wpw3AVIriIIu3pVm6Rl7pcFkyQOl8ymrQILbKgIyESkwS9PI2JFylRYg4Bju+vQaLm8qUG/q25xNUrEaQaNfKtxFZ7Fq6l9maExMLpcbXsYnC0Hryp4vimYiPB0cCSAzdtkObpH4om2LSoYNyiwNjDdL35b0g5nrqBIKZcTkkXVzFgTRfcL1O4ocfNjTpKZef26p7Oe8Zl5Ssz9V+BWr+26tY4wdK/+fbzQyxpIbWCBWVaFWgeR3oVUcJPFCfeV5vaaQGdT2EKQhjVjo3mXdF7KC54c6TfaMu7b9b944GPBNkwwDGt+hTLo3GOKSsSakKmX5YyaZcSteyB9q5n4VqLjL+Ton5ezUEst6DjKAlUex6Bzxazg5nfIutj0r1+b567D5zaddBTe9zx6i2RVTEvy3sSgTmpIvF/cjAstbuSyurWHiLZ0ik+gBAVJE20PFB7epwzeniWavwp8ncqRuSWIFaUb2cOstDL0dRFSoYgFk3pXgINZChlQixmGibEE1YS3VZiUXQHZaeJ2bUqwv3T6tXt0arVv1MmGhtmKiejnsWxmGhkf0EhMGQCgsiMLt85tW/7rSIqxrjuZm9PVSL/LISzzlV6rpgJckzabYMgwm9aCLz8rtvvsQK6mxfaDqinSk4JyNuWulOLFGJH2lixa2uh2WDb0TuuGgPbunZs8JFhsUnGkya3n4FyQNjiwlwRyfbKxvuehW8BuMIJb5wVWW8Ko70KRYcsZeIIdKT962WMViunglxXUZkcBQRTw38WscRWpZYNS28fzDphkOf5beJAAS3uD/m63NoXo=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS4PR08MB8241.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700021)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 nsTsmWGT83ofAoaV9EECFfc+lBB6ypr/qfiw9LD1ct9jxHMkl+HXZTDLVPkejXPDtRq9KtYeKoajd6LaFqt8aSxPf3V/ZDQVAH4fgAgHLLHMe2NRDWB621w8FQcvMhfK/ljmwV2c9jJLSYSYAd0jHZ97uA+OLGos5khZ9odGpQhdZi/o8+Zf19OrcXk1ILOMCthF65AMuNPvx7sKC9qfWemzzaZGRPztCF58MrPJ7E9l8CjxP+YQqhEbDlDhZ5DL+egyFALDUL0/j12CUS0ZeZOBvBn7LxvZ6IOc7K4P1flBDhNmmC6L8Ce63JWxX21UIEg3LZzNEh7LY/10+KYmyw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB8483
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU6PEPF00009527.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	47293682-80aa-4c98-a34a-08de841b3872
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|14060799003|82310400026|36860700016|376014|1800799024|30052699003|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	qdmugnjLQNGXWtpLMhCgWyr6MAQWgXdYqnvy+eK4zKLh6795hU6Q9kifTj5tr4JZ4xxWItFfU8QcQXhkVlIkYK4h70oZTLunv2aC1loXXBCASw8cO2enve/PSjMERqfu4jVQy8iHSaI/2j4NWxm1cPKbrDVGoQudDVDQaJTgUxfN8M6WXdUDOZsef/B9nc9bqwUld/8rN1ZMciAx2wzlI2MQ7jwO32eU2nDtsj6CfzcL5bPUeg7I19fXxZbh16uqUzdamCG5aAeh7gHgavMRqCX/bWE0/VMwA/OUbM9bfWra52zNo0y/AHgYsC84mBkX4Gf8GVaL8J54ZbW4emqcxmObv53ykhWLeqGZNhQeZDPINFcL/nFXQgrmJye+swL3HyglFvquZfId3iZoOE5WfBC4lIz9N/dw85zE168vhaxdxYOwHmeS68rfwNJ0nn5gAx+pyuD67hRYOHI0Rs3h++yGtugBoS56XCSqKVxbLIGSgG3cnwD711LVlCoJiulnlJGMMCbQI3RIvBZJIyoTGFKDmJ/rEMGna3GeC3hGyU+yVW6tkLoROyGCWklguvgXISv86wAUajod3oHuQO9DtqMGWAC6mbTS37LKwzuBQG7j8yKT1RSqChrilf499QN6zn+m2aG8XavS32K4frG+uIm2TQuyhDB7Mb4wLLCrkGmhoqMDgjx1AkU6FFXPO6xSlf4rpHh2xQKaLH3bDTflo/qDjf8G1uMMMdQ3cmjgFhr8QvYpDmpu7u7YLFqKrB55LmoV5fZdlcP6R7n6RevSYA==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(14060799003)(82310400026)(36860700016)(376014)(1800799024)(30052699003)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	GSi+y0UCziEv3HdKD3Zn1+WNRmutPJnz6EOrcT1NFj4YP6PwI84Pav8lfafrmjwdTD0HkxfbfyvppIXRqGsMNHvYbOeokQGrasum70A92iLmRMIsSq4m2ENa/HAym0C7j77yi/xZTjfYeSHchXFgg4tm3GW5gX4BKInBXlocP/1M+etZT3ZJKm3+fZ3tRGBMRrJbaKemRZKGXRW0wZWAMnsZ88nFspoQD5t63gItKVBLJ8T/VtnWpDVZ2wOdHp97pYKj3sYAFCyzL99L96tTfzGe0xXVdzHr9EYEnny0D7zP1y2VnDa/+0XDwLeMaU4swkikwLKHWzXU/RCYjvZWOqoW92aYHgYFAA8NVN89OrUcO06TbUX8tEYzKM/DmCvjYFi0DyBKAxtPUHYY8MW0jqRbZ2+uD9rQQceZre3dduIBCsm9B9UgOK92sKd2nc7E
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2026 11:50:22.8216
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e6dfb04e-d7b8-46ef-a5e1-08de841b5f30
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU6PEPF00009527.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB10074

Now that it is possible to create a VGICv5 device, provide initial
documentation for it. At this stage, there is little to document.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
---
 .../virt/kvm/devices/arm-vgic-v5.rst          | 37 +++++++++++++++++++
 Documentation/virt/kvm/devices/index.rst      |  1 +
 2 files changed, 38 insertions(+)
 create mode 100644 Documentation/virt/kvm/devices/arm-vgic-v5.rst

diff --git a/Documentation/virt/kvm/devices/arm-vgic-v5.rst b/Documentation=
/virt/kvm/devices/arm-vgic-v5.rst
new file mode 100644
index 0000000000000..9904cb888277d
--- /dev/null
+++ b/Documentation/virt/kvm/devices/arm-vgic-v5.rst
@@ -0,0 +1,37 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
+ARM Virtual Generic Interrupt Controller v5 (VGICv5)
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
+
+
+Device types supported:
+  - KVM_DEV_TYPE_ARM_VGIC_V5     ARM Generic Interrupt Controller v5.0
+
+Only one VGIC instance may be instantiated through this API.  The created =
VGIC
+will act as the VM interrupt controller, requiring emulated user-space dev=
ices
+to inject interrupts to the VGIC instead of directly to CPUs.
+
+Creating a guest GICv5 device requires a host GICv5 host.  The current VGI=
Cv5
+device only supports PPI interrupts.  These can either be injected from em=
ulated
+in-kernel devices (such as the Arch Timer, or PMU), or via the KVM_IRQ_LIN=
E
+ioctl.
+
+Groups:
+  KVM_DEV_ARM_VGIC_GRP_CTRL
+   Attributes:
+
+    KVM_DEV_ARM_VGIC_CTRL_INIT
+      request the initialization of the VGIC, no additional parameter in
+      kvm_device_attr.addr. Must be called after all VCPUs have been creat=
ed.
+
+  Errors:
+
+    =3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+    -ENXIO   VGIC not properly configured as required prior to calling
+             this attribute
+    -ENODEV  no online VCPU
+    -ENOMEM  memory shortage when allocating vgic internal data
+    -EFAULT  Invalid guest ram access
+    -EBUSY   One or more VCPUS are running
+    =3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
diff --git a/Documentation/virt/kvm/devices/index.rst b/Documentation/virt/=
kvm/devices/index.rst
index 192cda7405c84..70845aba38f45 100644
--- a/Documentation/virt/kvm/devices/index.rst
+++ b/Documentation/virt/kvm/devices/index.rst
@@ -10,6 +10,7 @@ Devices
    arm-vgic-its
    arm-vgic
    arm-vgic-v3
+   arm-vgic-v5
    mpic
    s390_flic
    vcpu
--=20
2.34.1
