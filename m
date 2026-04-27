Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011009.outbound.protection.outlook.com [52.101.70.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37D9D3396F4
	for <kvmarm@lists.linux.dev>; Mon, 27 Apr 2026 16:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.9
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777306138; cv=fail; b=sEXYm/q/m2lSaP/+jk+vLsrXCfnFrPoouxCIFNsyHjoM1LTe9S2Sb3WkutkCblYwCDkVpyLSAgfzqxRvqTiMwBIsCQaRULHrcuAnEdaHXK4SNy5DpsyXTMPCtuc9/HQlInKFeb8pxD4SNpyU2+Qaz0wAKYiNAgYaC49Lx0QLihc=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777306138; c=relaxed/simple;
	bh=fGkviUfsu8rU5wl+ARlVLeAIed2+UVIZd+bIAkjyGkA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=h1xQci8Pel5w2NzL+3WYgutE967lk6ycAsQY9UKt3R5cme0JqiOcdCwo3ENHNhGBvamQ9bfnJ2wJjlIz4GBK4epTUH/BUHDB1zxQ9o2JabaD6mvLsNEdSB88wq2Zr2MSnhsZgXWyCp4GsSHsTjeDX/g3dTLumEl1t2HfG4sGB1A=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=EO9B47d+; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=EO9B47d+; arc=fail smtp.client-ip=52.101.70.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="EO9B47d+";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="EO9B47d+"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=aYRoht6vDTxaqWJII+TkO9UttXi8vasRS+pxxYqWXl3zcA+Jc0dbvFnTldpJXiXC40iN5aF0vNo8dsABhAuXKLI6Yo1KWUCG2F65IeAmkTfiyd05XXIrqyLOoMdLoZOD9TECm8ERJJv7FM6UVrGPe/gyOxRFSnDuWqQ4RwLuJvtb9W6wfL6RX03Cxu8kLOGVxVVUOZBpfVfVtL2gXFz061IUw+adl5kjgrfebuDHZNlMjqNvfJeT2Jm3n+LkJY3QL/ywvpIhsdFLUnQFc+BpmNrhlXmyIDUgpGWR97SB79BqZwMyl9BxGu725j67pQxGaD2S2mK6AyZ5Xo8tzyHgiw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3aW8jfs3TC2kpN4aRqj81hJZjEARl+qEO72fNUtOTO4=;
 b=XQ+z9qEFwlDMQ6/uzMewVJRxV6TCDoPotehrquSyZJwD9yrc1l3tCvscW9Y75JjL2YpH2MTJV7NmQW+4uthuzOw2EBiYoMu8yoSISoYpoliR+uk/p7JBAimOJvVww+rFgPF9S2fpYb0ZQ49uB3Zlbu4Y/BBX7RM+sEOFQV8Z2f3Sj4khQevX1CtTUrclj5cY4RVH1tEdtnMeIT4/cQP739JWCgaI9A8b8dZzqkA+7mHoui4TURDTNsZnX+aak0aYpLNlahDIsracsF7ZdpUs5LiU/8YDYJqOuBbURLtDHNvtbeCNCtmf/70CAvuvO8Vn5tfiG2RsyIWveZpTp+Jj5g==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3aW8jfs3TC2kpN4aRqj81hJZjEARl+qEO72fNUtOTO4=;
 b=EO9B47d+ydmKJAWndR+j2IMSmYUeYucQHA3KQYfudIa8MZ70O4F0yW34OokHkuyxvNatiMaH9KuLzlZD0Gsxfaf99gGAiyqozmjGoP3WmWtP+5oRM5SHTdf46Y8tRND+hv2wDmCCpV5Su3PW4UD0YN4FIMJJ12rbYijQNcHOfHE=
Received: from DU7P190CA0017.EURP190.PROD.OUTLOOK.COM (2603:10a6:10:550::24)
 by VI0PR08MB11648.eurprd08.prod.outlook.com (2603:10a6:800:309::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Mon, 27 Apr
 2026 16:08:47 +0000
Received: from DB1PEPF000509FF.eurprd03.prod.outlook.com
 (2603:10a6:10:550:cafe::b4) by DU7P190CA0017.outlook.office365.com
 (2603:10a6:10:550::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9846.26 via Frontend Transport; Mon,
 27 Apr 2026 16:08:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509FF.mail.protection.outlook.com (10.167.242.41) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9791.48
 via Frontend Transport; Mon, 27 Apr 2026 16:08:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sG5bzmi9UQ1Z9xTyUhfnumYUoe47Hl/hIflYpNwrLuoEo9TzlEG80PMwfT6jm6KDq3PEZw37umUeZCV9LLDc6wlq4RyVAJjPnElFYj+knAwpGY+nwpCaoEftG+RGZ5PgDrl6uBSVt3w+Be8FOWhf3kQ3lOb/k+JQJcPZjCpZBiFTJhjLkwr63noQFgBpbCXbbbYk+ta6t4wNIKTMyJh2Z44zOtXRA1SOv2UcLe8Um67VW0S8NoXv9QJxkVXGOvWKLCDae21a+BNuZQm2ytIfqpJHwYY3Oy7fxVUkp2ZF7W24dBrazPDsB2K2aYem8YIq08j75pI2nv/pQMh5kpgRnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3aW8jfs3TC2kpN4aRqj81hJZjEARl+qEO72fNUtOTO4=;
 b=XszfA8c7u2QlVMKIAlZuM+Kf1Caur/UTge32JnyqRcHGVKQamHAGIHcNZPRvrMdu4j1XWJsKtVMLylQfBhGUI9FRABMIFEcIEKGnmXE8NLbTS7m8gQ3d+65Ym1Xm3KUdUNUjKCTBiK33Jt3Ookodxw4zx6k78XlB1iH8E5IuFpKfZRKVrTv9tKrs4gD2uusp4NOqjlX6b1xbx05YytSNPSw5OrsEpg8YwdP5BIxJMaX58QmswIlCoPxQt6MKisRnAy/gWxgGHCjot6jwc7JPemy5gkRVW+xG2PokGXMfRH3965KaVLzGI3jGBrqYM/bco16eSVmFiAce1kadH5Eb2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3aW8jfs3TC2kpN4aRqj81hJZjEARl+qEO72fNUtOTO4=;
 b=EO9B47d+ydmKJAWndR+j2IMSmYUeYucQHA3KQYfudIa8MZ70O4F0yW34OokHkuyxvNatiMaH9KuLzlZD0Gsxfaf99gGAiyqozmjGoP3WmWtP+5oRM5SHTdf46Y8tRND+hv2wDmCCpV5Su3PW4UD0YN4FIMJJ12rbYijQNcHOfHE=
Received: from VI1PR08MB3408.eurprd08.prod.outlook.com (2603:10a6:803:7c::10)
 by VE1PR08MB5792.eurprd08.prod.outlook.com (2603:10a6:800:1a6::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.20; Mon, 27 Apr
 2026 16:07:44 +0000
Received: from VI1PR08MB3408.eurprd08.prod.outlook.com
 ([fe80::6daa:d2f4:acf1:84ba]) by VI1PR08MB3408.eurprd08.prod.outlook.com
 ([fe80::6daa:d2f4:acf1:84ba%7]) with mapi id 15.20.9846.025; Mon, 27 Apr 2026
 16:07:44 +0000
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
Subject: [PATCH 05/43] KVM: arm64: gic-v5: Extract host IRS caps from IRS
 config frame
Thread-Topic: [PATCH 05/43] KVM: arm64: gic-v5: Extract host IRS caps from IRS
 config frame
Thread-Index: AQHc1l/7N0W5rhjXIUy+56mjABgqtQ==
Date: Mon, 27 Apr 2026 16:07:44 +0000
Message-ID: <20260427160547.3129448-6-sascha.bischoff@arm.com>
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
	VI1PR08MB3408:EE_|VE1PR08MB5792:EE_|DB1PEPF000509FF:EE_|VI0PR08MB11648:EE_
X-MS-Office365-Filtering-Correlation-Id: 84480f79-fce7-4690-2e4e-08dea47743a3
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|38070700021|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 nIvJcB4Z5FtkVxzxE5XjVC9MsXdHe9HrHJZ3htgEDBuBu+vHSgB7xyruDVaWrS0KqJin4ruggR8SAoeJlMyF2kt3lLRFG5cED5hKBs4BZyYtbUI2srNa5XFRF+4QNTevIPO532AqFcEhb0XAzGIdeOzcHkpmAw5sixyYO4vs+g9m59z0ZUhFTxvUZt+pXuyGMB1UHljnhDHC1BJBKSlE+mQAhsqax8h4Pj4qFKdaEW97M0rWzDCf2LiMIU8MuAgNsfJIzG6rjzdE7d06XcM3VhGWsypYBmPwjO3roTnMROirZc2JvNuaOJjHv8UTEYhgBhB32EsE+4C0UiLSJh0AAyRAQi5FBpA+y0ZYzkih0JyGbucv9qGGH91zWSRxp1Ur0w6yP4qpLFPS3sAPTFlI4mcFdBRSS8jWaIYKFo4Z+SWGbYuFzPT9s+5d+Jgl8YKpVJawomyVfzAHIBSHShg13uT7EFqdvYawdHligWMd5E/LsL4bz9Y6EDkUj1dFYaD3mNRMSt4rKJQqlpo2vHJlI8d6Gd1BmB9O+KAap5C8tD0sL11YQGaE/xTC1hdzI7rnUBBSawvokrWU/8PxCJ2Tw9O3TVfeQ6HHFMuGM6MvHXwZcBXLKsP1lBe6CLWUMho71mWPKYOsuO93JuwePIyxmwf+jKCMOK2TIQ0AZYhw8mVFWUcFukJAX/t3WvucTxMjbHMJqcShwH68TnCASNAJbQNXB6Ld36H/9aAgJ67ZZEq2jSbi5xMv8plZatpIor+rn22ZfypfI3vCyABH4oF8afLqWIOx9ebIMGMaPKj6/fg=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3408.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700021)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 WBrb6reqHSgyz89v1b1ehx16nT+GwpPngXvKfN9uoYiUry0gQeNKpAfFY7XcrfIoV5L5kyn5GEhlSFE47Gtyilr/j82b2Npq87TJ36X3HbK59Km76kr2Q/X2C1GHh9QPlHjGUMNhKgMCrsgphAZrwAuO89dpkXaZo1CoIH9czriTMrqAU5NVPAiCvSyS96z0ADKFAtY3gRtpjfnK5kD/qKTGiVIJwwrpehHW1cumLmJG1xFdLnc5/HMS33gzvPvI4UGyqUW6iKT0jr5Rl1a1c5X5673ZuffGdbzrqCU6SEEZFs87RVxcNhm+YDlBHBsvlAbiT1tQUmRTZw1lIEu7lg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR08MB5792
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509FF.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	8c8daf2f-6f82-4a6a-031a-08dea4771e22
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|14060799003|36860700016|35042699022|376014|1800799024|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	6v/W/b1J8WhrCz1JKlUgvjqzQKjoCkpM5hg+aa5mo6OY0T3GyNWPthmCj0ySSKq5pDJDty9QGkDD2RHth2CLnpmy5z2opi5UBHPjxPO+VGc7jeuNd6+KddGSH7GBKdZhFhTby+nQ1f19iprqmq8STuo5kduMUHwAlig8pSqM57k5sPyL/hGzQ08SGMQeUK0YEFVzhI7j3OQ+uN6j/JYacIpLWkK34KjsOxXjOntZ1i51cH9tNIVCRJwkGxTuLJeYqeap8fP5ZTG3Ry0rITZiH/cUcATDhz3xAdOzaxPm9tFNEhnuVOsseKkoV3ILzaZouCIXknAijXeGNzJryiFErwd1+uuGQbH3g6xp0UynksQxzTUuh0hIbxMTEeVyV3OgDxbLHRUMivvp/6rI1p+1veFyHkmlGASGgd0/9EE/U9Mmw46TICLQZz4ubzFiomK3dUCgB74sYI7A3lE1jczwxN5+mDDOUjoCmUDTyZkSkrj35qTdVuQ7aLrQqSJMUpsB+keYrSQTAoEZRxHNpmiUl0wz1+q/ulkcarVYdv0GYF0QRXcRUY/pZKJcyDIdrZ9EtVF+yX+9rJBlfKqsAIBrfdRpnR9D+P8DEWQBLj8mzSq8HJNqcQS1YKqF9DV2iznB0Crgr2WMkLraoEQP33BK//va+qGOHwtd7sCERem39DYKVbeI8DBGiBQ79WjQ5pfh2rdI1kDASeRI8o+Chf2VWfR28aTUmEku4Rp5ra5rl7/glZsHsoWHY0BWQtnihcr+U++fysGYP2RwlPzSjmgeaQ==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(14060799003)(36860700016)(35042699022)(376014)(1800799024)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	3vnJ4zUp/FbSeAuouqOAmQhwb2q6R8Pjcm4zpZJ+HmbsX7iV893Lb7QwTuynJMIQ3Nm9OZ0SBn7JFbAOO0owYGlMay2GLy1MII1tP5Lo//TpTAHbl+zXex++7r9Xi2xh3e7huqO40W0vyWmJ1nBO7WCl2rOGbIZcyxMnym+0ztd3QPBZy866gPBPJusLnawue0tT75lh1E0R2Q0nOHKbfvt3hkufUevAtxJ3tZjlf9aObPq3Y3fbOQMat9IvKVhW7yTd2XEsABE/QGMtE85mPDa83oC2UWDeBwI+1as8+ntmCFQArQmdkOahg9BHpaBBCCGwztB+G8kGthNP/NjdMDpdLrcJjHgt39x23PmSVEa9XDO/+S19nDQG7CiGbWJdHN9KPHEoGmSRuNL2cI7d/uYnXxD7FnGymc2tiwhug08L0ZnggeA9ee4EVzl1uf5R
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2026 16:08:47.4762
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 84480f79-fce7-4690-2e4e-08dea47743a3
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509FF.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI0PR08MB11648

The host irqchip driver provides KVM with a pointer to an IRS's config
frame, which allows KVM to directly interact with the host's IRS. The
MMIO registers in the config frame are used to configure VMs (in
addition to them being used by the host). The IRS's config frame also
includes a set of ID registers which describe the capabilities that
the IRS has.

Stash the pointer to the config frame, and extract the VM capabilities
(from IRS_IDR3 & IRS_IDR4), as well as the IST
capabilities/requirements (IRS_IDR2) from the IRS.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/Makefile              |  2 +-
 arch/arm64/kvm/vgic/vgic-v5-tables.c |  8 +++++
 arch/arm64/kvm/vgic/vgic-v5-tables.h | 41 ++++++++++++++++++++++
 arch/arm64/kvm/vgic/vgic-v5.c        | 52 ++++++++++++++++++++++++++++
 include/linux/irqchip/arm-gic-v5.h   | 10 ++++++
 5 files changed, 112 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm64/kvm/vgic/vgic-v5-tables.c
 create mode 100644 arch/arm64/kvm/vgic/vgic-v5-tables.h

diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index 59612d2f277c1..431de9b145ca1 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -24,7 +24,7 @@ kvm-y +=3D arm.o mmu.o mmio.o psci.o hypercalls.o pvtime.=
o \
 	 vgic/vgic-mmio.o vgic/vgic-mmio-v2.o \
 	 vgic/vgic-mmio-v3.o vgic/vgic-kvm-device.o \
 	 vgic/vgic-its.o vgic/vgic-debug.o vgic/vgic-v3-nested.o \
-	 vgic/vgic-v5.o
+	 vgic/vgic-v5.o vgic/vgic-v5-tables.o
=20
 kvm-$(CONFIG_HW_PERF_EVENTS)  +=3D pmu-emul.o pmu.o
 kvm-$(CONFIG_ARM64_PTR_AUTH)  +=3D pauth.o
diff --git a/arch/arm64/kvm/vgic/vgic-v5-tables.c b/arch/arm64/kvm/vgic/vgi=
c-v5-tables.c
new file mode 100644
index 0000000000000..30e2b108b1aa3
--- /dev/null
+++ b/arch/arm64/kvm/vgic/vgic-v5-tables.c
@@ -0,0 +1,8 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2025, 2026 Arm Ltd.
+ */
+
+#include "vgic-v5-tables.h"
+
+struct vgic_v5_host_ist_caps gicv5_host_ist_caps;
diff --git a/arch/arm64/kvm/vgic/vgic-v5-tables.h b/arch/arm64/kvm/vgic/vgi=
c-v5-tables.h
new file mode 100644
index 0000000000000..cf00a248eabd5
--- /dev/null
+++ b/arch/arm64/kvm/vgic/vgic-v5-tables.h
@@ -0,0 +1,41 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (C) 2025, 2026 Arm Ltd.
+ */
+
+#ifndef __KVM_ARM_VGICV5_TABLES_H__
+#define __KVM_ARM_VGICV5_TABLES_H__
+
+#include <linux/irqchip/arm-gic-v5.h>
+
+struct vgic_v5_host_ist_caps {
+	/* IST Capabilities */
+
+	/* Apply to LPIs and SPIs */
+	u8	ist_id_bits;
+	bool	ist_levels;
+	u8	ist_l2sz;
+	bool	istmd;
+	u8	istmd_sz;
+
+	/* LPI only */
+	u8	min_lpi_id_bits;
+
+	/* VM Table, VPE Table */
+	bool	two_level_vmt_support;
+	u32	max_vms;
+	u32	max_vpes;
+	u16	vmd_size;
+	u16	vped_size;
+
+	/* Is the IRS coherent with us, or not? */
+	bool	irs_non_coherent;
+};
+
+extern struct vgic_v5_host_ist_caps gicv5_host_ist_caps;
+static inline struct vgic_v5_host_ist_caps *vgic_v5_host_caps(void)
+{
+	return &gicv5_host_ist_caps;
+}
+
+#endif
diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index d4789ff3e7402..fd3d6299a2baa 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -9,6 +9,7 @@
 #include <linux/irqchip/arm-vgic-info.h>
=20
 #include "vgic.h"
+#include "vgic-v5-tables.h"
=20
 #define ppi_caps	kvm_vgic_global_state.vgic_v5_ppi_caps
=20
@@ -34,6 +35,54 @@ static void vgic_v5_get_implemented_ppis(void)
 	__assign_bit(GICV5_ARCH_PPI_PMUIRQ, ppi_caps.impl_ppi_mask, system_suppor=
ts_pmuv3());
 }
=20
+static void __iomem *irs_base;
+
+static u32 irs_readl_relaxed(const u32 reg_offset)
+{
+	return readl_relaxed(irs_base + reg_offset);
+}
+
+static int gicv5_irs_extract_vm_caps(const struct gic_kvm_info *info)
+{
+	u64 idr;
+
+	irs_base =3D info->gicv5_irs.base;
+	if (!irs_base) {
+		kvm_info("No GICv5 MMIO IRS address; no GICv5 support\n");
+		return -ENODEV;
+	}
+
+	vgic_v5_host_caps()->irs_non_coherent =3D info->gicv5_irs.non_coherent;
+
+	idr =3D irs_readl_relaxed(GICV5_IRS_IDR2);
+
+	/* We skip the LPI field as it only applies to physical LPIs */
+	vgic_v5_host_caps()->ist_id_bits =3D FIELD_GET(GICV5_IRS_IDR2_ID_BITS, id=
r);
+	vgic_v5_host_caps()->min_lpi_id_bits =3D FIELD_GET(GICV5_IRS_IDR2_MIN_LPI=
_ID_BITS, idr);
+	vgic_v5_host_caps()->ist_levels =3D !!FIELD_GET(GICV5_IRS_IDR2_IST_LEVELS=
, idr);
+	vgic_v5_host_caps()->ist_l2sz =3D FIELD_GET(GICV5_IRS_IDR2_IST_L2SZ, idr)=
;
+	vgic_v5_host_caps()->istmd =3D !!FIELD_GET(GICV5_IRS_IDR2_ISTMD, idr);
+	vgic_v5_host_caps()->istmd_sz =3D FIELD_GET(GICV5_IRS_IDR2_ISTMD_SZ, idr)=
;
+
+	idr =3D irs_readl_relaxed(GICV5_IRS_IDR3);
+
+	vgic_v5_host_caps()->max_vms =3D BIT(FIELD_GET(GICV5_IRS_IDR3_VM_ID_BITS,=
 idr));
+	vgic_v5_host_caps()->two_level_vmt_support =3D !!FIELD_GET(GICV5_IRS_IDR3=
_VMT_LEVELS, idr);
+
+	if (FIELD_GET(GICV5_IRS_IDR3_VMD, idr))
+		vgic_v5_host_caps()->vmd_size =3D BIT(FIELD_GET(GICV5_IRS_IDR3_VMD_SZ, i=
dr));
+	else
+		vgic_v5_host_caps()->vmd_size =3D 0;
+
+	idr =3D irs_readl_relaxed(GICV5_IRS_IDR4);
+
+	vgic_v5_host_caps()->vped_size =3D BIT(FIELD_GET(GICV5_IRS_IDR4_VPED_SZ, =
idr));
+	/* Field stores VPE_ID_BITS - 1 */
+	vgic_v5_host_caps()->max_vpes =3D BIT(FIELD_GET(GICV5_IRS_IDR4_VPE_ID_BIT=
S, idr) + 1);
+
+	return 0;
+}
+
 /*
  * Probe for a vGICv5 compatible interrupt controller, returning 0 on succ=
ess.
  */
@@ -61,6 +110,9 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
 		goto skip_v5;
 	}
=20
+	if (gicv5_irs_extract_vm_caps(info))
+		goto skip_v5;
+
 	kvm_vgic_global_state.max_gic_vcpus =3D VGIC_V5_MAX_CPUS;
=20
 	vgic_v5_get_implemented_ppis();
diff --git a/include/linux/irqchip/arm-gic-v5.h b/include/linux/irqchip/arm=
-gic-v5.h
index dfa4d29dc0012..76dcf414ffb20 100644
--- a/include/linux/irqchip/arm-gic-v5.h
+++ b/include/linux/irqchip/arm-gic-v5.h
@@ -68,6 +68,8 @@
 #define GICV5_IRS_IDR0			0x0000
 #define GICV5_IRS_IDR1			0x0004
 #define GICV5_IRS_IDR2			0x0008
+#define GICV5_IRS_IDR3			0x000c
+#define GICV5_IRS_IDR4			0x0010
 #define GICV5_IRS_IDR5			0x0014
 #define GICV5_IRS_IDR6			0x0018
 #define GICV5_IRS_IDR7			0x001c
@@ -105,6 +107,14 @@
 #define GICV5_IRS_IDR2_LPI		BIT(5)
 #define GICV5_IRS_IDR2_ID_BITS		GENMASK(4, 0)
=20
+#define GICV5_IRS_IDR3_VMT_LEVELS	BIT(10)
+#define GICV5_IRS_IDR3_VM_ID_BITS	GENMASK(9, 5)
+#define GICV5_IRS_IDR3_VMD_SZ		GENMASK(4, 1)
+#define GICV5_IRS_IDR3_VMD		BIT(0)
+
+#define GICV5_IRS_IDR4_VPE_ID_BITS	GENMASK(9, 6)
+#define GICV5_IRS_IDR4_VPED_SZ		GENMASK(5, 0)
+
 #define GICV5_IRS_IDR5_SPI_RANGE	GENMASK(24, 0)
 #define GICV5_IRS_IDR6_SPI_IRS_RANGE	GENMASK(24, 0)
 #define GICV5_IRS_IDR7_SPI_BASE		GENMASK(23, 0)
--=20
2.34.1
