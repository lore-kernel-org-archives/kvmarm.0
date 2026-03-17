Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013023.outbound.protection.outlook.com [40.107.162.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0548034EF07
	for <kvmarm@lists.linux.dev>; Tue, 17 Mar 2026 11:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.23
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773747892; cv=fail; b=PSkSTY336mpK3NROy+wmTKKzSKXunnYPTf8mM1uyKq1YXXEw4UK9wy5xtKXMAx+h+DTNg7UnADZFnOzbddfHvPTzUnczp7PELRI9dEZ5B6PRSzWH1G1HWic2yUzpCX44GT2gkgt7Zn1yrheSlVGm6pqh+e36sXsHJuDqJrVzbCs=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773747892; c=relaxed/simple;
	bh=HCUYsYQaM1E8fQRnqu2etWHW6wuPp6SBjBS8CReKSX0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=cjG9JrcBlZZkPbJ9V9L1a1CE5nZiGj/np+Xf7CRXol7QeEoCpBGKSCG9JDrOpJH+0EJh3kBgRce08rdUQhEVWSDJnj90mnzN0f/LIoC3datRnjXPeUqAOjnl9YA8TI2XYUMVwgTW5qMdeLk8dasiMrFsuRwO+RTRPT1QQcGZbjk=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=nKwmwrXn; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=nKwmwrXn; arc=fail smtp.client-ip=40.107.162.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="nKwmwrXn";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="nKwmwrXn"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=Pd6zBoNQ8TYQ2XKdI/EB0ZDJ/vJnZNo9+/uaJkfuY43UuQA0Wu60rYl4/KKcsQDtCR0PFgfY5onRtDJkfA/tYRR65t6XSkzrbYANRZweWipjjfz67UNT4mBwMum/X/xgESthiQCdBUgiyWE6WgKaPvZS4hmoPsTDEDKX/7SEBIGpuWoseB4ZRM513hs4fJpOZJsEEiQe1Dcc1ITZX5/+/b+WuYhe9m+/S9XOr3Fi39kpQSdbz5+LiKy9/8wGOrMamZKJDqTHlvHlSbPAxZxwXt7RlawG3+n2gDCp+CIxdFj7zpjrpcPtPG31+4BceYtMQAZEM18OP505vV3NKhOebg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4UoB/m3GFxjJD2BS7Vme/sECieeDem4AyzE8E7KnnIk=;
 b=vq4bTtseR76/qv3ghEcOALYOeRigEktmVZEuS4rrDrzTvKggwCDQ+LXle8nseWYCN0cSxDtvM4cnsctjrfwznPu8Ixeo3DTKrWFDaqBmCeXmxaaH/OjIExjBnoajkZ0sxIVbn8IhZkWdrxmu+s0BUXb4/k/4AWHydGjvTe6JR8YRSbx+rc3sC27inCEEDlVm/MRAaQImUhwDGO5+gT/HJooPIHM9bG25r2rm+teKggOIe6SLsPdTS9IDuU+gnGAD4iFssuroCXRmXQDmLy/jeoJG93UB4h3LhkOWm1UhoOMf4NwqKWN6y/3ssP6JHW8682Dw9v5H26rLNUNm2BKKJA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4UoB/m3GFxjJD2BS7Vme/sECieeDem4AyzE8E7KnnIk=;
 b=nKwmwrXnafmiHhQXmVJ2y06RKOJ82LwHkwmq0IniP5zbKWHpxBQbEqTZA0MgU04zsvITOmn6Jki/5JuI3yZsSq79hZeS32ysD3yS1wTFFck7qnqvfz64Vn+Qa4/CLLiuT6jOeqOPDK3U3P8TAhAsUEqF6+Wpjz9u4VXKE2J31xQ=
Received: from DUZPR01CA0283.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4b7::17) by AS8PR08MB8898.eurprd08.prod.outlook.com
 (2603:10a6:20b:5b7::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.21; Tue, 17 Mar
 2026 11:44:37 +0000
Received: from DU2PEPF0001E9C4.eurprd03.prod.outlook.com
 (2603:10a6:10:4b7:cafe::bf) by DUZPR01CA0283.outlook.office365.com
 (2603:10a6:10:4b7::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9700.27 via Frontend Transport; Tue,
 17 Mar 2026 11:44:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU2PEPF0001E9C4.mail.protection.outlook.com (10.167.8.73) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9700.17 via
 Frontend Transport; Tue, 17 Mar 2026 11:44:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=egG/hwHpmBDvjrGwCz9rM7Kpfe8Rbw1naQHWufLUPd4WBeKFSqpHMLszkjeoxNlZuvw0LEwOS+XHmDt6vvhFJW4cx3n5hFw3t2XpfTuhvLXODcaEcZ0Y/2l5IKkP3KcV58VKWtZkzoB9zlBDUcl1foZZjE+YhWaGNQd5KmGkMEYxAzDhbTYMEIRZZDczUeKhV0oqOBsh+Plbc9VK79aARAtLGgGjLGVjwpvvvn/5ka41LwwvIpxZaBe3pFP/qj/kcMJCK+z0CeJv2yFhUO4WwsOYmuYRIV95f7gbvxpJeMsm9V3D+W/QpVixSbp6V6EAlWFAFSqOLBFPbEwPpaHp2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4UoB/m3GFxjJD2BS7Vme/sECieeDem4AyzE8E7KnnIk=;
 b=OQN3P7yywkDPOKJjpMNJOvaA6w9UOr89SmtWOWclHQERdZRBU36Y9stfX/swQn7QU9FGMxB2iaxpI6VCJuI5LCe18zsEezKwMUY5fXFM2G4OydOShIX0qchOF8ma/XCR8gdufIxf1lriFbwcUG+K8laPBB+u49klf2jr+bSbxhZnpW7qJcEs7ZX2DYKtXoE9kvdm59ynokgDc2LfFAkt+QygBYAV8DzKNhvuhFDCQKO8NufQVsT5y0Vg3JSZEo5g5mw+Efh3SqUHeU4YITJYnNZLkT/9MGF+3fC1n6oELGu5bpq+B07jIucjb1GJEmlymWZESzqRNe4DcSTp7MYQuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4UoB/m3GFxjJD2BS7Vme/sECieeDem4AyzE8E7KnnIk=;
 b=nKwmwrXnafmiHhQXmVJ2y06RKOJ82LwHkwmq0IniP5zbKWHpxBQbEqTZA0MgU04zsvITOmn6Jki/5JuI3yZsSq79hZeS32ysD3yS1wTFFck7qnqvfz64Vn+Qa4/CLLiuT6jOeqOPDK3U3P8TAhAsUEqF6+Wpjz9u4VXKE2J31xQ=
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com (2603:10a6:20b:504::10)
 by PA6PR08MB10417.eurprd08.prod.outlook.com (2603:10a6:102:3cd::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.24; Tue, 17 Mar
 2026 11:43:34 +0000
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27]) by AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27%6]) with mapi id 15.20.9700.022; Tue, 17 Mar 2026
 11:43:34 +0000
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
Subject: [PATCH v6 14/39] KVM: arm64: gic-v5: Trap and emulate ICC_IDR0_EL1
 accesses
Thread-Topic: [PATCH v6 14/39] KVM: arm64: gic-v5: Trap and emulate
 ICC_IDR0_EL1 accesses
Thread-Index: AQHctgNJXQmEcRj2h0uZxU3oPTPHnw==
Date: Tue, 17 Mar 2026 11:43:34 +0000
Message-ID: <20260317113949.2548118-15-sascha.bischoff@arm.com>
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
	AS4PR08MB8241:EE_|PA6PR08MB10417:EE_|DU2PEPF0001E9C4:EE_|AS8PR08MB8898:EE_
X-MS-Office365-Filtering-Correlation-Id: 776e586d-86d9-46d1-cbb2-08de841a90ed
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|22082099003|18002099003|56012099003|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 fNc3P22T7kW2i8+bInOCpSPA7DaKIo+Tjg+VX29Hq81V2k4JUz/Rt2BcpNAWKWrSG6vCfE8TCVVAjGFarJk73mefIxplkBM02SjMAlKkcpLc7ELm2RMaFb28XS3qnUCctCqeE1eXz2XEGSvl4KZgX8x5so4Q5hsc5HRwWzIcwOSaGgPUlt0Xbd8LFV03t/ugRiLlLYgvanA079ECbQgZ7ndK2X0UwjFoQaeW59lxMFirng9ssIp6NXHqtGM8KnqB3ng4NxaQo6fItMY/9zRto5mcLsr308Pgj76PepQN997G2dZ3U9lmqD5IQfMw6cZ8gdsLs22B0ib387Yz7RX02K/Wy9GVfBnVCHKr5ikPmo+7SvRpiQv+ZHbzxLaUMwDpErWTCXQkcGIeUIY9nxRhwCPAJfSbRRah5aXiCO+5C9czqUfIIEY70azVCOeU+HnG5zXxVNdva3feRAcwvtsCZ0I5umuy1JQxDA9/kGjgSmAUi3aqY/Cmrh3fxkN9o7/974knrKw9XiOOy85RcxbBIv3RXv4AVGUOU7V3YG6mQ1iMrKpcEsv+RoBy+ljvvO9lTS+vNjj8RRPxLRJBf67oZC5Kyqjst4G+OKamLvhUhi4TpZvLSA13TwE8VipoHKFoE+NpMj/bKBsYi0ACAeS3js3BV4I2T6Wi+amhEuiuRZFVqT4AkQsH5w5bgk/lQRuf77B2Zd2blbsHfXTdVwW6L2VDVtWChJCVivdQ7sF4Fa05NWVo0ugflmWs6hLzDA+l88mxXoxPcfzwCAN2Z6C9Ps9BpgyHWqJBnr97lvbnMbk=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS4PR08MB8241.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(22082099003)(18002099003)(56012099003)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 mho2CDl8gepI1rMKlYA803d3n83jdRm4AooXiDWi0uIE+iPOHMSY4bpHMrAiNI0gHyHmhsCFU36mgsFJYqjVhq3YbT2iYTeMCPR9BhFlPQYrP317d44AfOYc0jT483/mgbv3UFDIY999RHphaaisrBNVIUQY7fbf34MbLPz9m16HDxK5mmJrOBZaCzlD73w7D2B50MT4h1ZGDHV4wfySRLFvgaSgCI9e13lh0hVi4LrtBZkL3eptgLtvE7VPS6KoVqcsuMqGJ5L/ZGWD5flClxmCt8w5tcPvKPnuXP7CVrfPWDd6c8m19au/dRkJx1SYFXeFE8wp/K8Mov0h6nKryw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA6PR08MB10417
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU2PEPF0001E9C4.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	8775b823-e4b9-41df-d95d-08de841a6b9c
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|35042699022|36860700016|14060799003|1800799024|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	K4Mh65gZwpX1GVo++WIxcCs6v3v99eszI1Lytc4G89fKTrJpOyL7TUxJvVntEplWxo5HuJLpB4JdofpvRuySCmcEZMAhUbqXX2TS/JcfpQB5xncR/QqdQK0LCWPRYB03sClaqQKJHyTTQcHGuLJrl0rmaKlRvN3JmXMrMm84Pk40RYBXjr0kBoiebi8VOld7v+fZgbg2a3GpAc0AG+P/Oq8cLX3bqgKeP49/Wfq0BkiKxjwdWTEvoyxj7z4Wxx8JyPzo8IZPfExF4qSJeaU2knHrYnEtx6z3Lmk9HteoK/xUeIMLsAx2DzepMVadwJuLZRC6xAFmUx3r7ZyFgmbGvgaRNkMQQi4tc+NV70JmSJ2wg6Tvn/UGE/XAYjORRmM0jBZrTDapTqt7hRx9r53QX3VboFpEbO7rBfqOQv2mfZpwMaQBykPeUlTnt8K9DZ8qsloGKCLbApw6f5a7LalVHc87yg4D3pIGRm9OtnEbtMEw1uWmQs1Qe/0wPkzLSQAGw0rziXZP4GVVPkcuYsNRDvYLQl/R7xFNeL9tt694x+jXvg9yhw3mcTGsO+sJPA5BcuiudZtJA5zwdPYye6zdFZIMYYLiuoWjYv7KwaPgskzY3fxiDCAmnUUd2LJMWdUNtRH6RiPWxNSUUaiqxVHrTuGKRQIsqPDfNuIlZl6czvLE9C9Al6SkYMucKp8eitKgzzEAcLPE/9mgLV5AbIBv3GmhQtLwC+ziMvM6sb3gHjWOKSSuQzNV+24uL/hY4uzKw5YcR/+3AXK2cGZlmwNUsw==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(35042699022)(36860700016)(14060799003)(1800799024)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	3ijD7ZWD4auAdBgqKCLa7noYmezpows/ZCFC0wLBkt2mbAI6XGldzXZoY6p6EnAJivD7Jg5yeuJocamXVqaba+/+LD6DZy9MepjszqCuWxTp+4ZWotUYhixT0IbXgxEzIRoOWq1dxVeZje6gJ8OWW/gyhz7Ycoz8ttt4w0IP8iQD6Q7CAd+n9VrOxtKAlE21C5X0obbXy3JpEfMi1IR4V4bdb5iRYu7I22T8dgHmzEnXLhzpHjKoGfigppOwP82UpK31q5EBs1gRrI1JezC6IVkkobaTMe8c7i2MsoN88QtfLmmZh6Suu74IcOsx74CsfOqUsazG1wZcVsWyr969c9jASDhjX5kTf/13fl3OuQBL7EMDBgn/+jLWqjg4DMSFDtwgp02h423EMUFNtRu8KfU9Ry7LcCY15b9/HVfHJlV47jpfu04CoTSVszZfOs3w
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2026 11:44:36.7729
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 776e586d-86d9-46d1-cbb2-08de841a90ed
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF0001E9C4.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB8898

Unless accesses to the ICC_IDR0_EL1 are trapped by KVM, the guest
reads the same state as the host. This isn't desirable as it limits
the migratability of VMs and means that KVM can't hide hardware
features such as FEAT_GCIE_LEGACY.

Trap and emulate accesses to the register, and present KVM's chosen ID
bits and Priority bits (which is 5, as GICv5 only supports 5 bits of
priority in the CPU interface). FEAT_GCIE_LEGACY is never presented to
the guest as it is only relevant for nested guests doing mixed GICv5
and GICv3 support.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/config.c   | 11 +++++++++--
 arch/arm64/kvm/sys_regs.c | 23 +++++++++++++++++++++++
 2 files changed, 32 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
index bac5f49fdbdef..5663f25905e83 100644
--- a/arch/arm64/kvm/config.c
+++ b/arch/arm64/kvm/config.c
@@ -1688,8 +1688,15 @@ static void __compute_ich_hfgrtr(struct kvm_vcpu *vc=
pu)
 {
 	__compute_fgt(vcpu, ICH_HFGRTR_EL2);
=20
-	/* ICC_IAFFIDR_EL1 *always* needs to be trapped when running a guest */
-	*vcpu_fgt(vcpu, ICH_HFGRTR_EL2) &=3D ~ICH_HFGRTR_EL2_ICC_IAFFIDR_EL1;
+	/*
+	 * ICC_IAFFIDR_EL1 *always* needs to be trapped when running a guest.
+	 *
+	 * We also trap accesses to ICC_IDR0_EL1 to allow us to completely hide
+	 * FEAT_GCIE_LEGACY from the guest, and to (potentially) present fewer
+	 * ID bits than the host supports.
+	 */
+	*vcpu_fgt(vcpu, ICH_HFGRTR_EL2) &=3D ~(ICH_HFGRTR_EL2_ICC_IAFFIDR_EL1 |
+					     ICH_HFGRTR_EL2_ICC_IDRn_EL1);
 }
=20
 void kvm_vcpu_load_fgt(struct kvm_vcpu *vcpu)
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index d4531457ea026..85300e76bbe46 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -681,6 +681,28 @@ static bool access_gic_dir(struct kvm_vcpu *vcpu,
 	return true;
 }
=20
+static bool access_gicv5_idr0(struct kvm_vcpu *vcpu, struct sys_reg_params=
 *p,
+			      const struct sys_reg_desc *r)
+{
+	if (p->is_write)
+		return undef_access(vcpu, p, r);
+
+	/*
+	 * Expose KVM's priority- and ID-bits to the guest, but not GCIE_LEGACY.
+	 *
+	 * Note: for GICv5 the mimic the way that the num_pri_bits and
+	 * num_id_bits fields are used with GICv3:
+	 * - num_pri_bits stores the actual number of priority bits, whereas the
+	 *   register field stores num_pri_bits - 1.
+	 * - num_id_bits stores the raw field value, which is 0b0000 for 16 bits
+	 *   and 0b0001 for 24 bits.
+	 */
+	p->regval =3D FIELD_PREP(ICC_IDR0_EL1_PRI_BITS, vcpu->arch.vgic_cpu.num_p=
ri_bits - 1) |
+		    FIELD_PREP(ICC_IDR0_EL1_ID_BITS, vcpu->arch.vgic_cpu.num_id_bits);
+
+	return true;
+}
+
 static bool access_gicv5_iaffid(struct kvm_vcpu *vcpu, struct sys_reg_para=
ms *p,
 				const struct sys_reg_desc *r)
 {
@@ -3420,6 +3442,7 @@ static const struct sys_reg_desc sys_reg_descs[] =3D =
{
 	{ SYS_DESC(SYS_ICC_AP1R1_EL1), undef_access },
 	{ SYS_DESC(SYS_ICC_AP1R2_EL1), undef_access },
 	{ SYS_DESC(SYS_ICC_AP1R3_EL1), undef_access },
+	{ SYS_DESC(SYS_ICC_IDR0_EL1), access_gicv5_idr0 },
 	{ SYS_DESC(SYS_ICC_IAFFIDR_EL1), access_gicv5_iaffid },
 	{ SYS_DESC(SYS_ICC_DIR_EL1), access_gic_dir },
 	{ SYS_DESC(SYS_ICC_RPR_EL1), undef_access },
--=20
2.34.1
