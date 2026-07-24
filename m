Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013065.outbound.protection.outlook.com [52.101.83.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F373942BC3A
	for <kvmarm@lists.linux.dev>; Fri, 24 Jul 2026 11:01:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.83.65
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784890878; cv=fail; b=Rk6ifqdoXNNx3IUjL8KQ/3936Sxg+QVpdJI7S9HQEdlxGe37J91gFFe9aa24uM2HatT0K7C6/vHCSnuS3YcLEpVsfQo4auqmHZA0yEaeq8nMTBoC0bkmPmq+X5pcj/M/Q3yYsDHzliIrB9sUGtAv386+SlFQQdtr/zuTbdNC4Pw=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784890878; c=relaxed/simple;
	bh=w8WwAbbWeDdTtKgcGTxIRI1c1JP3dZvBlArQnoNbMFs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=B4Br4GYLNQHzto4dIhQMWohEDbeZemnMXqohHqrtKutCLtvi1A7Bos3tQj/3c2pkmsqNs4JAh1p8y1ZBJUCM8+yBYMtRfGTit3qttWEWCpzsfFWmla2yR5f3K21OwTBi2DeSMoCCChZVTgLd2JK2Ir40DAJoO2AnoVJGvNsMXes=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=eWyhDhBJ; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=eWyhDhBJ; arc=fail smtp.client-ip=52.101.83.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="eWyhDhBJ";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="eWyhDhBJ"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=YVo1ViYrLlIo9Db9W1mSIUyu+RmvfPdr11FaO3l4AVy6aRTzCo1XwACbmgXn0cdfZrFK8z672XOLdoEY03fEgOgtwTgbrebwY3rtTD8h6P25vLBXgaIghiln05maboxsCiOnasQ6wD6Gq3UwntKY92uRumnpYUtHz0aLPSDCwSlYbDIhtuXwnzpb1nqeBEC15XRl1iAVEBTN1/QXK97pY02TdFwLTmbCQYq+vfAC0s0US4nQ+5N5RseD4WJC/KcG6PW2Dll2bt5jJo6CEWVR3PwzQYy5gdcncDMId6DcqGOJj3YJlS53qVi9G5O/Wangz8hDPxZeCtRIYXksvnS0GQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3vZZVlawr1O05ZRm8soOTkSFBtM6G3j8XOdwvP2cGLA=;
 b=eW52Vusl1m6uV18ERj6XN8WW6QZtfd729iUJqz2hvxQL4pfGLrdv2iZtoFtifzAnyNMJOyRh99ulQ3JuUUs7ZhT4dBBUOYGOq+hxF1pt7k+ffrdS1uw73w3VhICj3wiT4k466cxQi4dnHdbrL8IXA3VTdzGhR0rOw3Ml7zUbT1Erw/rI6FaMZGWn27saPDinWM89xnPlFnfJnorKc3UEiMD8oDZcXB/mYP6DIlElAFNpUCnYFDK7rnxwMc/iqv8h3PKRTsvtKLH/Vp/+IxISaArC8ZcD8kPi97twfRFjAVXZUtK+dkuYHc05HB+HYIL7ToIfJx92ma89k63rRv7RfQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3vZZVlawr1O05ZRm8soOTkSFBtM6G3j8XOdwvP2cGLA=;
 b=eWyhDhBJsYcxw0q/7gyBSkFIgcdKTUmUcdHysBEeV9/0pLjoc1HQhz8Gk2jJgtuoxiulaw4s5Qu6PZkNrAWloYcKPHCcY04CMYTW2qC6/UWaHbLTACFNwM0o2YLXdygt6/GNyv60LuQhK7EscYjAPDtFK90l2sQW07/fF/1NXGE=
Received: from AS9PR04CA0151.eurprd04.prod.outlook.com (2603:10a6:20b:48a::21)
 by PAVPR08MB9090.eurprd08.prod.outlook.com (2603:10a6:102:327::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Fri, 24 Jul
 2026 11:01:04 +0000
Received: from AM1PEPF000252DE.eurprd07.prod.outlook.com
 (2603:10a6:20b:48a:cafe::96) by AS9PR04CA0151.outlook.office365.com
 (2603:10a6:20b:48a::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.11 via Frontend Transport; Fri,
 24 Jul 2026 11:01:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM1PEPF000252DE.mail.protection.outlook.com (10.167.16.56) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.5
 via Frontend Transport; Fri, 24 Jul 2026 11:01:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=y+SflM98ek/RhXLVQYNJZofvirUl+bxMWyR8nk/eI3hDHiP4o+COjn982JIIOPAU5gKOtacHYmigagdyJCxh0at8t6oHiKHNn8wQMcdsUsciPulPmTSwMwT2eI6yOxfbCKCHDvmzQ204aPBMncEUUI14On4l+y2MMBo20zzPt8evOrWFnlquoSg+2lDOSS5Hs+KdeWpVNs2oK53jgPbyRCWqIlZbQ2zwhE2T88Q9Y36rcWigU/sikapT70eoP8nG28UOvH44O2o8pXgSzPkwv2DbNYi2YrdU1jmEEdDfkFiWSfZY2NqTrETuFZDifPdHxud1fRM4rlrVdDMeNw3/Cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3vZZVlawr1O05ZRm8soOTkSFBtM6G3j8XOdwvP2cGLA=;
 b=cr8ERuAGEHCiCZbtuzz9rbocSFLVVGvghm4X1/Nfn4LolPvf5GRDzjdKf3o5GhFdHIlwcydLzrKl4Wp41vdTTL/Sabpg6ZKRfIaH/Z1nVTq1EIT21F1sK0Js7k0GKy7R55PsdQgGw8nSdJf1RfV8en40inxncgTyYAqc4pFd6ffwoWlA5Lru9yujMLDQrhb0mdBTlfWk5uBIFE7uh6dTavy/8c/QWhdTmdfT3dPvfEBqEBjexYRj/ABDPzVqRvuhp3fHEtoCieZLpfc98I6ufJo0YcYicJCSooM05KCm167ZBcPCitfx8+pBX1drTPL4ivu6EHbW71SAkRhYTlUY0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3vZZVlawr1O05ZRm8soOTkSFBtM6G3j8XOdwvP2cGLA=;
 b=eWyhDhBJsYcxw0q/7gyBSkFIgcdKTUmUcdHysBEeV9/0pLjoc1HQhz8Gk2jJgtuoxiulaw4s5Qu6PZkNrAWloYcKPHCcY04CMYTW2qC6/UWaHbLTACFNwM0o2YLXdygt6/GNyv60LuQhK7EscYjAPDtFK90l2sQW07/fF/1NXGE=
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com (2603:10a6:10:407::19)
 by GV2PR08MB11279.eurprd08.prod.outlook.com (2603:10a6:150:2f0::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Fri, 24 Jul
 2026 11:00:01 +0000
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e]) by DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e%5]) with mapi id 15.21.0245.009; Fri, 24 Jul 2026
 11:00:01 +0000
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
Subject: [PATCH v4 45/48] KVM: selftests: Add VGICv5 CPU sysreg attribute
 tests
Thread-Topic: [PATCH v4 45/48] KVM: selftests: Add VGICv5 CPU sysreg attribute
 tests
Thread-Index: AQHdG1uSStFSlQfSkEyz8LAOwdBg8w==
Date: Fri, 24 Jul 2026 11:00:00 +0000
Message-ID: <20260724104819.1296803-46-sascha.bischoff@arm.com>
References: <20260724104819.1296803-1-sascha.bischoff@arm.com>
In-Reply-To: <20260724104819.1296803-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU0PR08MB8421:EE_|GV2PR08MB11279:EE_|AM1PEPF000252DE:EE_|PAVPR08MB9090:EE_
X-MS-Office365-Filtering-Correlation-Id: 76f5c49d-8eb7-4d43-ae4d-08dee972dadb
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|23010399003|22082099003|18002099003|56012099006|11063799006|38070700021|6133799003|10067099003;
X-Microsoft-Antispam-Message-Info-Original:
 8UTxEv5gom+ZCNNTOwRwZCKZ7yCzZfzp0rk0bBbAs63IjyODtBdTrKu33ZFVPI0qAfBxDq5X72kBcg1npCorNkoIpd3FqmmvSax8xxSFoiaeZkdhiBa0XijWTriSnIiUSaimGmXrxaF/KDZgmwdxjieqDe9xeZLyR7yEr2+2EGrJOV/n9m5CwsxtUSeNPdJJr0Su2RxmkxgNoRM9If7KmYd4uSPll/mwPpQGQueP4NQ7YdyTSWcYFZ+5/D5vS5in4Q8qxU7LSbxPAKbqjVT5BgzRAh4jTjXP694vZhm5Y88BgilLanG8oKzxBJV8hh0pTmNDTvmLzE/Oq4kroo6XzGbENQQHP7/D7PXmNcpXGWz1WnNyB+xY+a42rcdZylSeOlx8CbLN4+74jxzbbGP/cY0fIHCXjfTCMzCRiPFQQRR5lKSR6gi1P3oqbAhek6uI28ChLruVZzyqM0/H83EX3XBjbS5eHeOVkix8rRSR7AesQXhdkgB6ETU7RiTY5v1AkVn8hLNV5ieT6E9vbGTeQepkIGp+deP1Y90xLPxyO7C+18ohn9KkQegmlTv5FXehLdWgZgWT/ET6jVwzCK9RDkst7AR/K0/oTdoEN5HzaOiwiLlzemuv/NctZ/3+GMJOZ+iCivMgsaAneCGxYyqpBfn2Bv3fSlzTU7InJzLY8YK5FnMEIov5EHB3g01tv3Wn2gs/gyk+zKpSpokpJuGRkQ91Ly9HWmX0TwQsE2p7ELY=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB8421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(23010399003)(22082099003)(18002099003)(56012099006)(11063799006)(38070700021)(6133799003)(10067099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 KvWS3+vKnf5dcL5r38ddilr+FYIjx06UgyGcK+qW4yvdTG8Pa+zmPwMYjP84HjNXBOGMV/XNybJV8c3risA60T+AKtxm46J6kp2CP3OhriYz1uwcstuAyRAsvnQGEEMQ8ONn71RQYLhsrIG4jEwhumdAXBuv/EzwNXpX1hohWUI9CYmTBVVnFQHwmZI3LK8MFjup6s76Ph9+7JjeeVrpbh39YDX6GBER6dI+AjhmBsgHBESqeR9C3n4YzkPgZJssKV6bKkMf4E8XlW//dNkwTg5hR5CZWSEmvGtyoLhnVRZp4HB+527rkeqgRpcFCjSrpCuJEP6bkd46WiX0whogjA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR08MB11279
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM1PEPF000252DE.eurprd07.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	747e4eaf-a3da-4ab6-18f3-08dee972b552
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|23010399003|14060799003|36860700016|1800799024|376014|35042699022|6133799003|10067099003|11063799006|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	ti+uJER3osxPQT2TqhoVQ4GDBEsRUWJCI5WxcrqAKtC2dX8iqRnvwcmQ3DRd1BbRL/ZLv7EKg3pDOwDnrJTQQVob56XrrLaj0NVLfUaE48yGCvwxrPoD9ebhDGDmvT63lSWgbwYzHTm8quzl3x+LmCzOnZYmyxOMtplP/9q55wF0QM5jNMMHbZ48SEzdrdOZOVSGyG6Kw8EFkBJBIPzHS23mJD94RalR8IabzRVb3+RnbvTA2r1M1Djori+fmO4fLmI+URrZTf0C4JCvE6w0s3qy9i5gvjdSXGtKZd9ONqdVUubxLjwALG+SpOd6SP9JzKyRA3p/mR0cito2FSdrrSwKmbe/6Z0ealsddlvq/ts9a51NidlqwNC7aLp9K5+isR9ZnAQg9tX6bKq8BlfxCOJVCdhG2iwjPAESKX8/a4Plcqx+fVNUBXjf4ze6rVEDkoNt59Aq6Bqwq7gJ2qG86stl7LETbA95yrxgFANNcOH1vTf/3DtBTWwSo3Ej0wsIk6uKLQ1GzciCT8afcLN815MRgA60om+Yii1Hh/grdeeU1ffRUw8wsnA83Nf25sYL71gqs3tCWOhBkzEfxgUoFEBlPRoKqXsbVmkDPd66fdHYV0EtborJmkkkD15qmbBuqn2stupYnEdZP7zEZmpEUBucJh5LYYThd4hCe4ff+LvY0SAO8xJtJp8n/Ui+AaHYlVw/zixyhZgM7drePPtz3w==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(23010399003)(14060799003)(36860700016)(1800799024)(376014)(35042699022)(6133799003)(10067099003)(11063799006)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	ChKTI3kb/2rWrBr/MWWj8Jq0OKbNjC06oJYdxjzwzHuV1+5w8dLZ9FggnxwrQ3n5s89yu7+bG8irv8bvsxnfFoEMf1uZv35+MPdYOofp87Qsu4lISk4WbyHOWKItnymEfM/Z3gWzdTvifDELA563kHPh33e98YEj9+gPHkUCLn7ag5jW8PIVD45BY5WDzV0lIPsHTMhs0O1CNTex2tK+1NLnQdQu0+Vz8HbBo2Rj0w7n22YkGAJ1UccmLe3DPpjWul2VCvzOMb8mRhceF92pNyH1E0Mp/rtP3Imk4xo1mhrwJK7G8zdmhS4RpWhVuLmYOYiYVesuYx5cBNLBsdt3JwKNYFgXQsV4BwtLlVa3wyUWy9rdWDZTFoPdaEwV1HZZ45YsgFHh2FwUoUTtvLx1QkQSBL+wEU2jvxZPsEjXV+1q3oQQjeEH8CO60X17BD1q
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2026 11:01:03.9529
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 76f5c49d-8eb7-4d43-ae4d-08dee972dadb
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM1PEPF000252DE.eurprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAVPR08MB9090

Add coverage for the VGICv5 CPU_SYSREGS attribute group. The vCPU-local
CPU interface registers are part of the VGICv5 userspace ABI, so KVM must
expose the supported registers and reject invalid register or vCPU
selectors.

Verify that CPU_SYSREGS access is rejected before VGIC initialization,
that all exposed VGICv5 CPU interface registers can be read and written
back, and that unsupported sysregs, invalid MPIDRs and bad userspace
pointers are rejected.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 tools/testing/selftests/kvm/arm64/vgic_v5.c | 137 ++++++++++++++++++++
 1 file changed, 137 insertions(+)

diff --git a/tools/testing/selftests/kvm/arm64/vgic_v5.c b/tools/testing/se=
lftests/kvm/arm64/vgic_v5.c
index fe56484583d4b..22ae726b17be8 100644
--- a/tools/testing/selftests/kvm/arm64/vgic_v5.c
+++ b/tools/testing/selftests/kvm/arm64/vgic_v5.c
@@ -132,11 +132,29 @@ static const struct vgic_region_attr gic_v5_irs_regio=
n =3D {
 	.alignment =3D GICV5_IRS_ALIGN,
 };
=20
+struct vgic_sysreg_attr {
+	const char	*name;
+	u32		encoding;
+};
+
 struct vgic_irs_reg_attr {
 	const char	*name;
 	u64		attr;
 };
=20
+#define PACK_SR(r)						\
+	((sys_reg_Op0(r) << 14) |				\
+	 (sys_reg_Op1(r) << 11) |				\
+	 (sys_reg_CRn(r) << 7) |				\
+	 (sys_reg_CRm(r) << 3) |				\
+	 (sys_reg_Op2(r)))
+
+#define SR(r)							\
+	{							\
+		.name		=3D #r,				\
+		.encoding	=3D r,				\
+	}
+
 #define IRS_REG(r)						\
 	{							\
 		.name		=3D #r,				\
@@ -198,6 +216,35 @@ static const struct vgic_irs_reg_attr gic_v5_irs_regs[=
] =3D {
 	IRS_REG(GICV5_IRS_SWERR_SYNDROMER1),
 };
=20
+static const struct vgic_sysreg_attr gic_v5_cpu_sysregs[] =3D {
+	SR(SYS_ICC_ICSR_EL1),
+	SR(SYS_ICC_PPI_ENABLER0_EL1),
+	SR(SYS_ICC_PPI_ENABLER1_EL1),
+	SR(SYS_ICC_PPI_SACTIVER0_EL1),
+	SR(SYS_ICC_PPI_SACTIVER1_EL1),
+	SR(SYS_ICC_PPI_SPENDR0_EL1),
+	SR(SYS_ICC_PPI_SPENDR1_EL1),
+	SR(SYS_ICC_PPI_PRIORITYR0_EL1),
+	SR(SYS_ICC_PPI_PRIORITYR1_EL1),
+	SR(SYS_ICC_PPI_PRIORITYR2_EL1),
+	SR(SYS_ICC_PPI_PRIORITYR3_EL1),
+	SR(SYS_ICC_PPI_PRIORITYR4_EL1),
+	SR(SYS_ICC_PPI_PRIORITYR5_EL1),
+	SR(SYS_ICC_PPI_PRIORITYR6_EL1),
+	SR(SYS_ICC_PPI_PRIORITYR7_EL1),
+	SR(SYS_ICC_PPI_PRIORITYR8_EL1),
+	SR(SYS_ICC_PPI_PRIORITYR9_EL1),
+	SR(SYS_ICC_PPI_PRIORITYR10_EL1),
+	SR(SYS_ICC_PPI_PRIORITYR11_EL1),
+	SR(SYS_ICC_PPI_PRIORITYR12_EL1),
+	SR(SYS_ICC_PPI_PRIORITYR13_EL1),
+	SR(SYS_ICC_PPI_PRIORITYR14_EL1),
+	SR(SYS_ICC_PPI_PRIORITYR15_EL1),
+	SR(SYS_ICC_APR_EL1),
+	SR(SYS_ICC_CR0_EL1),
+	SR(SYS_ICC_PCR_EL1),
+};
+
 static void test_vgic_v5_addr_attrs(void)
 {
 	struct kvm_vcpu *vcpu;
@@ -702,6 +749,93 @@ static void test_vgic_v5_userspace_ppis_attrs(void)
 	vm_gic_destroy(&v);
 }
=20
+static void test_vgic_v5_cpu_sysreg_attrs(void)
+{
+	struct kvm_vcpu *vcpu;
+	struct vm_gic v;
+	u64 attr, val;
+	int ret, i;
+
+	v.gic_dev_type =3D KVM_DEV_TYPE_ARM_VGIC_V5;
+	v.vm =3D __vm_create(VM_SHAPE_DEFAULT, NR_VCPUS, 0);
+	v.gic_fd =3D kvm_create_device(v.vm, v.gic_dev_type);
+	vcpu =3D vm_vcpu_add(v.vm, 0, NULL);
+	TEST_ASSERT(vcpu, "Failed to create vCPU");
+
+	/* Check existing group/attribute */
+	attr =3D PACK_SR(SYS_ICC_CR0_EL1);
+	kvm_has_device_attr(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS, attr);
+
+	/* CPU sysregs are not accessible before the VGIC is initialized. */
+	ret =3D __kvm_device_attr_get(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS,
+				    attr, &val);
+	TEST_ASSERT(ret && errno =3D=3D EBUSY, "GICv5 CPU_SYSREGS get before init=
");
+
+	val =3D 0;
+	ret =3D __kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS,
+				    attr, &val);
+	TEST_ASSERT(ret && errno =3D=3D EBUSY, "GICv5 CPU_SYSREGS set before init=
");
+
+	kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
+			    KVM_DEV_ARM_VGIC_CTRL_INIT, NULL);
+
+	/* Read all exposed CPU sysregs and write the value back. */
+	for (i =3D 0; i < ARRAY_SIZE(gic_v5_cpu_sysregs); i++) {
+		attr =3D PACK_SR(gic_v5_cpu_sysregs[i].encoding);
+		ret =3D __kvm_has_device_attr(v.gic_fd,
+					    KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS,
+					    attr);
+		TEST_ASSERT(!ret, "GICv5 CPU_SYSREGS missing %s",
+			    gic_v5_cpu_sysregs[i].name);
+
+		val =3D 0xbad;
+		ret =3D __kvm_device_attr_get(v.gic_fd,
+					    KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS,
+					    attr, &val);
+		TEST_ASSERT(!ret, "GICv5 CPU_SYSREGS get failed for %s",
+			    gic_v5_cpu_sysregs[i].name);
+
+		ret =3D __kvm_device_attr_set(v.gic_fd,
+					    KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS,
+					    attr, &val);
+		TEST_ASSERT(!ret, "GICv5 CPU_SYSREGS set failed for %s",
+			    gic_v5_cpu_sysregs[i].name);
+	}
+
+	/* Check non existent GICv3 sysreg */
+	attr =3D PACK_SR(SYS_ICC_CTLR_EL1);
+	ret =3D __kvm_has_device_attr(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS,
+				    attr);
+	TEST_ASSERT(ret && errno =3D=3D ENXIO, "GICv5 CPU_SYSREGS accepted bad sy=
sreg");
+
+	ret =3D __kvm_device_attr_get(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS,
+				    attr, &val);
+	TEST_ASSERT(ret && errno =3D=3D ENOENT, "GICv5 CPU_SYSREGS get bad sysreg=
");
+
+	/* Check non existing vCPU */
+	attr =3D PACK_SR(SYS_ICC_CR0_EL1) |
+	       (1ULL << KVM_DEV_ARM_VGIC_V3_MPIDR_SHIFT);
+	ret =3D __kvm_has_device_attr(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS,
+				    attr);
+	TEST_ASSERT(ret && errno =3D=3D EINVAL, "GICv5 CPU_SYSREGS accepted bad M=
PIDR");
+
+	ret =3D __kvm_device_attr_get(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS,
+				    attr, &val);
+	TEST_ASSERT(ret && errno =3D=3D EINVAL, "GICv5 CPU_SYSREGS get bad MPIDR"=
);
+
+	/* Check bad user pointers */
+	attr =3D PACK_SR(SYS_ICC_CR0_EL1);
+	ret =3D __kvm_device_attr_get(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS,
+				    attr, NULL);
+	TEST_ASSERT(ret && errno =3D=3D EFAULT, "GICv5 CPU_SYSREGS get with bad p=
ointer");
+
+	ret =3D __kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS,
+				    attr, NULL);
+	TEST_ASSERT(ret && errno =3D=3D EFAULT, "GICv5 CPU_SYSREGS set with bad p=
ointer");
+
+	vm_gic_destroy(&v);
+}
+
 static void test_vgic_v5_ppis(u32 gic_dev_type)
 {
 	struct kvm_vcpu *vcpus[NR_VCPUS];
@@ -844,6 +978,9 @@ void run_tests(u32 gic_dev_type)
 	pr_info("Test VGICv5 userspace PPI attrs\n");
 	test_vgic_v5_userspace_ppis_attrs();
=20
+	pr_info("Test VGICv5 CPU sysreg attrs\n");
+	test_vgic_v5_cpu_sysreg_attrs();
+
=20
 	pr_info("Test VGICv5 PPIs\n");
 	test_vgic_v5_ppis(gic_dev_type);
--=20
2.34.1
