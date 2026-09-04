Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013010.outbound.protection.outlook.com [40.107.162.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DEFF44AB94
	for <kvmarm@lists.linux.dev>; Fri,  4 Sep 2026 11:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.10
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788522918; cv=fail; b=Kb8zsDOM25/153GyT3v/jkHUnzIUkdnUOkp1FgttM/miT5darIBSb41x+qK9vO/VOI/F/cTdCuv8Xqx+2Mpzmd21BawCFNm5/0oNWqLV51BWdXKFx5kwmgp4WtyyUuUW8PGPrxetfLjIbfUdRVt+azilt9Ol6hGjx9QBrbp1syI=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788522918; c=relaxed/simple;
	bh=/+e/AkaWRpTPwjW23BgYy4Cq7NK+gW6+V/aNpVnxgVQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Fg+2gRi4QXkrlc9JTIeTd21+u92fIyTGG50GYAClkBk1kf0R+MRhZVJ5MLcEBMmd3VFaQ5nYruZOUEJs44kV7UY0wA34Ue6yJUeysIx64Jop8l3/MDvwPdMyGzlF9Z6T3AhadbpgBUTYrnNPpGLqz2mwE2KWYURZoHyybDCCNZM=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=XBv3TAa0; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=XBv3TAa0; arc=fail smtp.client-ip=40.107.162.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="XBv3TAa0";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="XBv3TAa0"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=HQ86OX8ZMD2UlmBPCNQm7GkJLq4HZ80DIibxlZXow9INHw1JUONRmxiFmj++Wq7Mhu0wNwnO6/91qJ3mBIathBmUkRlKFE/7uM0sxh1WHfQdeTF2yUne6WkJbSojtPK1DgQUJibPK3zsFs6o5Vjhp5/jZONHmVNDWvppKpA99jM8O7w/jU7FYfWq1HoEV+eldpVDkIfJlD35Dg5LU6hnfIYjHEBfpNLz+fSB/Bbd5KQ8UR1te2pFdPjlJaYTAWL9ngrbHzWmiF4XnSQQqWi6BJmNy8IWep/LzNo3e9gc8I7YM6tBM2sCOwAvfBDw7SoNIzqW3+kliUSGKm/MG4v+zw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A0V2cFbey9tp/MZ4Fys1o9v8hc6ZxpVgavABz32KqqQ=;
 b=LEv8BKd8g6lMhfs2R67T7i/nuxJ+BrGgpViGXACxER4bMZm698BqoYe/vOnI2p4Cp2SXr4Hz+UqYqu9YAyPGxEULtBflx+uzgp1pbSlWdImxEt9bh2n4TaPvG9fXWiWKji07mLtrOTbtC1Mv6e2E0mLVbKQ1UwOtcfS5HES/uANyVEC1+wB6zxR/TX5M0pkYPgDSs8iPYpjuxXQzC5sd0Ljp12d6foMeHyhCE9Q+yhQvR1D829NnsrBcS2ecS13lqWMbbU7RD2p89ktjj0WPJ/RZAq0U4CfV2AGhjgaqgErtyy5rUjzGvWP99Cv81QkSXQTb44aozZAFbvjttpxfaw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A0V2cFbey9tp/MZ4Fys1o9v8hc6ZxpVgavABz32KqqQ=;
 b=XBv3TAa0VDgSY1mw9apNsiP5eIDy2PlbNPHKCvAAOPZbwfBzcv0f3epY3FXVkKazS8Ng5GLsXfBfS26LY9VqtH9jAH1sxfCfDEzLRSNvQDdBY7GyafHCCSi3fDx0Pd7H5t1bFsf0hFMRgZUSFQiZ77539IFmmfFmf8NTfSs1rA8=
Received: from DU2PR04CA0078.eurprd04.prod.outlook.com (2603:10a6:10:232::23)
 by GV1PR08MB8012.eurprd08.prod.outlook.com (2603:10a6:150:98::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 11:55:10 +0000
Received: from DU6PEPF00009528.eurprd02.prod.outlook.com
 (2603:10a6:10:232:cafe::1c) by DU2PR04CA0078.outlook.office365.com
 (2603:10a6:10:232::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.12 via Frontend Transport; Fri, 4
 Sep 2026 11:55:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU6PEPF00009528.mail.protection.outlook.com (10.167.8.9) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.8 via
 Frontend Transport; Fri, 4 Sep 2026 11:55:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=N7EG4np0/pMoIAhCdu4oMPFbn3rhZmOw5K0XFJC1K4BBBlkaFKZrYN/IGEuix8ztcd4+3ZQFbvD8k3pYnc5yOk2ehLOmsUcdFNFZG0dNbrOFv8gzNrEEvxVeBOEInXPTXs6cBYldH62fMWfq9FV7s4ifLHm58+zpovo94KEa5VWm8EAQ0Zh01Did9QDeKKgXlHhNhmPRUuEdeVtEtidS3zyowCBABIZix4gDN2aM1D5ZYkk+GiaY3eyqfffTgtHIXiSIyWkzYU+61n/PE+4uZqZvnsZflVPn9VPqr8Of5bEjx0d7ydAsFOeUORKYn5m+TwA6V90/aWho1CnvkpPkzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A0V2cFbey9tp/MZ4Fys1o9v8hc6ZxpVgavABz32KqqQ=;
 b=wrXQv16fzVUC9cYpdX50hF9J7Pl+vLNYEq00kd/mx2q2bgSpmIACA8m2ozSkv1QZOajEVFPaONbeAU/+ZlAv1dk7i3NWT8RdLgBNL84pulDu94n2iW2SpKbktEddBwWGV+8oNYOxgEL3clEikpoGF2lYtH8WXHNc/eW233bt3VSfLyScqVRI2hfeiFJRtmzrOPBQnka9z/3XzbYw6m4T3Mdd+OSM0qe48/IfYIQI6Xoh8GLmwM/iS4ypoEHgZqbZy5fQVxgxxK6nXp4JiEQwVQX2ix5I+6gnDkHbGuRkz2bTbfzvRM0wv2F9Mu6Pt5JTEakaeFfdxuLSMOsAUOh3oA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A0V2cFbey9tp/MZ4Fys1o9v8hc6ZxpVgavABz32KqqQ=;
 b=XBv3TAa0VDgSY1mw9apNsiP5eIDy2PlbNPHKCvAAOPZbwfBzcv0f3epY3FXVkKazS8Ng5GLsXfBfS26LY9VqtH9jAH1sxfCfDEzLRSNvQDdBY7GyafHCCSi3fDx0Pd7H5t1bFsf0hFMRgZUSFQiZ77539IFmmfFmf8NTfSs1rA8=
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com (2603:10a6:101:1d::23)
 by AS2PR08MB10207.eurprd08.prod.outlook.com (2603:10a6:20b:647::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 11:54:35 +0000
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e]) by PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e%4]) with mapi id 15.21.0382.007; Fri, 4 Sep 2026
 11:54:35 +0000
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
Subject: [PATCH v6 40/49] KVM: selftests: Add VGICv5 IRS address attribute
 tests
Thread-Topic: [PATCH v6 40/49] KVM: selftests: Add VGICv5 IRS address
 attribute tests
Thread-Index: AQHdPGQoJSeH93neKk6bJHpUBFDqfg==
Date: Fri, 4 Sep 2026 11:54:35 +0000
Message-ID: <20260904113404.4051341-41-sascha.bischoff@arm.com>
References: <20260904113404.4051341-1-sascha.bischoff@arm.com>
In-Reply-To: <20260904113404.4051341-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	PR2PR08MB4889:EE_|AS2PR08MB10207:EE_|DU6PEPF00009528:EE_|GV1PR08MB8012:EE_
X-MS-Office365-Filtering-Correlation-Id: 9a0fc818-4d99-42ec-182b-08df0a7b5f40
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|10067099003|6133799003|3023799007|22082099003|11063799006|56012099006|18002099003|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 RL7KC9T0PGMQIXWsKIbOQTR66xxgrm1hWIpwafLiFJNOl7No8zUo7cdShGIr5mHhEy1VPXfgF5tgYk1v25EWdjIbls1oTfRz+mj2JfBZepfv9O3lWnPrlLoN0MOD/ExZn0tPUuZg6uoRI5EERQgkhra2hiCP7M6zWUeE/1fun+BCfC/6BZNJDj/bDwM3G/l2u5Pvi2bLQ/BFNaJkVaUA0eWZByQEzpZxRotrGCawIWn1S1B9pqzw1dKuRWQtUJaWYksjcWZO4Ap3xv2QOicFVMiIVPbZlvYG88pgiXFiartHj4r5QcXE4oD8Cc5L9QWWLRtzGrlqbsk1Q/qN36rhFonOsVPHCIPS6S+zTZh2sFNIuFqnyaBSX8XYwbAUYHLNGyNwKAVmHAnSnM4ZNWUGSeW+cAKxh5K98ngtCsxPjN3jLaV9XG6mBYs8T9YIqyIeARgWC3IgWFTMBGkp8AyypHS/Yt3OWvjzaSMZ0Hc7TY5p77VIr4H27rY9q7vPx2uPuTe0LCD9mo+oJd/BNlbXzV6mmRQFyXq3oGhgxpJwJ5UIZSNuqeOAthSpjvcfKi0ZdSZXF1qPjIN8tK6yScQ2UI3WYAT/K6tkbh7TkNzXL5a0yh18QDQNTfDm1IIGJrYA72u5gwYQDVvrWZdlhEspELZZWsLfBfuQ4HKQQy6LJjC9KBwgQgHUdC4oR4bcoW7zFnPOlTn+ucKYbKPYfzGvPw==
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR2PR08MB4889.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(10067099003)(6133799003)(3023799007)(22082099003)(11063799006)(56012099006)(18002099003)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 xBkdp6b81BqxTdRj6rc05QdnwojyPRTGWaofPDNr7W7lMXyqD8xRJi2W2LBjqETUN1EuqhTO1ckBd8hmYHhdHAK8TX308Ka7bY33YIiDVh+ldWoqnCDGo3taXekWKyoh4ubrlRYBbHmM8fJpGJJGg3uu1wlSykLd/xJDrrt/cu9otCVwDlPU7qpUCcV7VbVe/srTkXC/zCYQ1Ro86wN7xJu7SKco1ZDllbzqoGcIOkjViM4z78Tgr9RG5dZDBhW7tJfo5XhGscdfa1gdH/HB3+sqYZj9UhJLD85gF2rn1Jqw+0FguLAPmzIz5X4XH9OEzdQdvP4WErzWmSjKX3EX0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB10207
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU6PEPF00009528.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	3be753ed-3d84-4346-bc1f-08df0a7b4a83
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|1800799024|376014|35042699022|23010399003|82310400026|36860700016|22082099003|10067099003|56012099006|11063799006|3023799007|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	nb9xswjsN2DZLFGigWgBjLVNNdikMuzU/BpbSQfkcpxZadptmD0XYU9ItNUCaK+fu+GLtI7ZUOv9wKNSwHAXi6dkyJLguf1wU71pj7FUmczXOlDWT5wGvjjOyAg7Atv1r2vxTwk7mYrms2T1Gar+8APM3LF6xRzbfq3O+rtJM63Bjfik1V84dMO6IJEzWhH3uLvJvgnlw6ndRMNH6/NoiCDf//a+Sytk9QFRik4bJ4FIqD3XJrp1mvPAMVhAMva8ejlS/Y4Eli3YbnikBbdTpqamLKYLWf9Q+MvrSr34jVXhI9r/QIz46zkqbN07TaFFnZA8U9z8yOiRB+71UtKkqmsoZHhpMZXNwToIR4q98T4oeSioNR65uWO9xgqoKTcaVBTgAFGASz1l0PlY8Wj6UX2o+J41Qd+ZqhtHicDPG3UtqnhoN3Vk/DWa67vDdjuk4pMgpMPiWaRge5jkwUcQwW3nZ7IQkfs8rqcPbD4v8o2vj7LCmd8CL3g1fFOgKH3zg/FWzqh6elSlBgsCfQ0EqmqaZH0j3L03XWpVJmh079TKbr8DKCUsgBHx5PF430+d87DGHCm7ELbwMqQ8qnIBZRCmhsjTUZp4B546twBBWzxlCjalKmbcgDA3dXfyOBwiMmjYzQooo+xP1Rrus2ENbUgnjvrT1lQRysEJyTdRkRk=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(1800799024)(376014)(35042699022)(23010399003)(82310400026)(36860700016)(22082099003)(10067099003)(56012099006)(11063799006)(3023799007)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	2u+2aSLlzvCEoFdMa81Ds4tkrpOk9fGOtb6M1fqwUTPNk7ob6Sp4eVF7JB9hheI8aEklAybZfugPB9Okb78NQi0MqJ+wDVD8inQae3llZm2W0EPgkHp2Kznp1upgAU4jpNrTe1x0iDagkXXbBGWd7IEbdCGDq6uggYiDn1JwGnqILV7gbs9bVvVXAjG54uHn+hZJskaQ+chnW6+oCsgq9BJ/WdnPGxlvds8mqR0CAfd5u44DeTtBY3VGdjNXuXc2ySS4iBhf1w4fwXshR4IfAJXNhDNB/0QDsD7m/RGeayeVURgENeIrn3/xdQQhjLeymg3Bh+Lx3v6tO9kESsvctD260/uSn5nStrVGf+Yn9LYx7QR6VVjGtXnSjLbQuFOQ/Tvl1FcqS5PDPzm2cD1K7g0lgCdNVVg0JS+nIF+XO4xf1RloycSwcxkC1eefGmuM
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2026 11:55:10.4076
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a0fc818-4d99-42ec-182b-08df0a7b5f40
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU6PEPF00009528.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR08MB8012

Add coverage for the VGICv5 IRS address attribute. The address is the
base of the guest-visible MMIO region used to configure the virtual
IRS, so userspace must provide a valid base address before the VM can
run.

Verify that KVM reports the attribute, returns VGIC_ADDR_UNDEF before
it is configured, rejects misaligned and out-of-IPA-range addresses,
accepts a valid base, rejects a second base, and fails vCPU entry if
the VGIC is initialized without an IRS address.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 tools/testing/selftests/kvm/arm64/vgic_v5.c   | 121 ++++++++++++++++--
 .../selftests/kvm/include/arm64/gic_v5.h      |   3 +
 2 files changed, 110 insertions(+), 14 deletions(-)

diff --git a/tools/testing/selftests/kvm/arm64/vgic_v5.c b/tools/testing/se=
lftests/kvm/arm64/vgic_v5.c
index 19039a8940568..51ea2fe7141ad 100644
--- a/tools/testing/selftests/kvm/arm64/vgic_v5.c
+++ b/tools/testing/selftests/kvm/arm64/vgic_v5.c
@@ -14,6 +14,8 @@
=20
 #define NR_VCPUS		1
=20
+static u64 max_phys_size;
+
 struct vm_gic {
 	struct kvm_vm *vm;
 	int gic_fd;
@@ -25,6 +27,104 @@ struct vm_gic {
 #define GUEST_CMD_IS_AWAKE	12
 #define GUEST_CMD_IS_READY	13
=20
+/* we don't want to assert on run execution, hence that helper */
+static int run_vcpu(struct kvm_vcpu *vcpu)
+{
+	return __vcpu_run(vcpu) ? -errno : 0;
+}
+
+static void vm_gic_destroy(struct vm_gic *v)
+{
+	close(v->gic_fd);
+	kvm_vm_free(v->vm);
+}
+
+struct vgic_region_attr {
+	u64 attr;
+	u64 size;
+	u64 alignment;
+};
+
+static const struct vgic_region_attr gic_v5_irs_region =3D {
+	.attr =3D KVM_VGIC_V5_ADDR_TYPE_IRS,
+	.size =3D GICV5_IRS_SIZE,
+	.alignment =3D GICV5_IRS_ALIGN,
+};
+
+static void test_vgic_v5_create(void)
+{
+	struct kvm_vcpu *vcpu;
+	struct vm_gic v;
+	u64 addr;
+	int ret;
+
+	v.gic_dev_type =3D KVM_DEV_TYPE_ARM_VGIC_V5;
+	v.vm =3D __vm_create(VM_SHAPE_DEFAULT, NR_VCPUS, 0);
+	v.gic_fd =3D kvm_create_device(v.vm, v.gic_dev_type);
+
+	/* Check existing group/attributes */
+	kvm_has_device_attr(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR, gic_v5_irs_regio=
n.attr);
+
+	/* check non existing attribute */
+	ret =3D __kvm_has_device_attr(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR, -1);
+	TEST_ASSERT(ret && errno =3D=3D ENXIO, "attribute not supported");
+
+	/* get IRS base address before setting*/
+	ret =3D __kvm_device_attr_get(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				    KVM_VGIC_V5_ADDR_TYPE_IRS, &addr);
+	TEST_ASSERT(!ret && addr =3D=3D (-1ULL), "GICv5 IRS returns VGIC_ADDR_UND=
EF");
+
+	/* misaligned IRS address settings */
+	addr =3D gic_v5_irs_region.alignment / 0x10;
+	ret =3D __kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				    KVM_VGIC_V5_ADDR_TYPE_IRS, &addr);
+	TEST_ASSERT(ret && errno =3D=3D EINVAL, "GIC IRS base not aligned");
+
+	/* out of range address */
+	addr =3D max_phys_size;
+	ret =3D __kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				    KVM_VGIC_V5_ADDR_TYPE_IRS, &addr);
+	TEST_ASSERT(ret && errno =3D=3D E2BIG, "IRS address beyond IPA limit");
+
+	/* Space for half an IRS (an IRS is: 2 * irs.alignment). */
+	addr =3D max_phys_size - gic_v5_irs_region.alignment;
+	ret =3D __kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				    KVM_VGIC_V5_ADDR_TYPE_IRS, &addr);
+	TEST_ASSERT(ret && errno =3D=3D E2BIG,
+			"half of the IRS is beyond IPA limit");
+
+	/* set IRS base address @0x0*/
+	addr =3D 0x00000;
+	ret =3D __kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				    KVM_VGIC_V5_ADDR_TYPE_IRS, &addr);
+	TEST_ASSERT(!ret, "GICv5 IRS base correctly set");
+
+	/* get IRS base address */
+	addr =3D 0xbad;
+	ret =3D __kvm_device_attr_get(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				    KVM_VGIC_V5_ADDR_TYPE_IRS, &addr);
+	TEST_ASSERT(!ret && addr =3D=3D 0, "GICv5 IRS base correctly set");
+
+	/* Attempt to create a second IRS region */
+	addr =3D 0xE0000;
+	ret =3D __kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				    KVM_VGIC_V5_ADDR_TYPE_IRS, &addr);
+	TEST_ASSERT(ret && errno =3D=3D EEXIST, "GICv5 IRS base set again");
+
+	vm_gic_destroy(&v);
+
+	/* Try running a VM without ever setting the IRS base addr */
+	v.vm =3D __vm_create(VM_SHAPE_DEFAULT, NR_VCPUS, 0);
+	v.gic_fd =3D kvm_create_device(v.vm, v.gic_dev_type);
+	vcpu =3D vm_vcpu_add(v.vm, 0, NULL);
+	kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
+			    KVM_DEV_ARM_VGIC_CTRL_INIT, NULL);
+	ret =3D run_vcpu(vcpu);
+	TEST_ASSERT(ret && errno =3D=3D ENXIO, "GICv5 IRS base not set");
+
+	vm_gic_destroy(&v);
+}
+
 static void guest_irq_handler(struct ex_regs *regs)
 {
 	bool valid;
@@ -81,19 +181,6 @@ static void guest_code(void)
 	while (1);
 }
=20
-
-/* we don't want to assert on run execution, hence that helper */
-static int run_vcpu(struct kvm_vcpu *vcpu)
-{
-	return __vcpu_run(vcpu) ? -errno : 0;
-}
-
-static void vm_gic_destroy(struct vm_gic *v)
-{
-	close(v->gic_fd);
-	kvm_vm_free(v->vm);
-}
-
 static void test_vgic_v5_ppis(u32 gic_dev_type)
 {
 	struct kvm_vcpu *vcpus[NR_VCPUS];
@@ -207,13 +294,19 @@ int test_kvm_device(u32 gic_dev_type)
=20
 void run_tests(u32 gic_dev_type)
 {
+	pr_info("Test VGICv5 Creation & Setup\n");
+	test_vgic_v5_create();
+
 	pr_info("Test VGICv5 PPIs\n");
 	test_vgic_v5_ppis(gic_dev_type);
 }
=20
 int main(int ac, char **av)
 {
-	int ret;
+	int pa_bits, ret;
+
+	pa_bits =3D vm_guest_mode_params[VM_MODE_DEFAULT].pa_bits;
+	max_phys_size =3D 1ULL << pa_bits;
=20
 	test_disable_default_vgic();
=20
diff --git a/tools/testing/selftests/kvm/include/arm64/gic_v5.h b/tools/tes=
ting/selftests/kvm/include/arm64/gic_v5.h
index c388df8f2a2b4..41b698b3952f3 100644
--- a/tools/testing/selftests/kvm/include/arm64/gic_v5.h
+++ b/tools/testing/selftests/kvm/include/arm64/gic_v5.h
@@ -13,6 +13,9 @@
 /* GIC component base address is guest PA space */
 #define GICV5_IRS_CONFIG_BASE_GPA	0x8000000ULL
=20
+#define GICV5_IRS_SIZE			0x20000
+#define GICV5_IRS_ALIGN			0x10000
+
 /*
  * Definitions for GICv5 instructions for the Current Domain
  */
--=20
2.34.1
