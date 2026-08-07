Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011005.outbound.protection.outlook.com [52.101.65.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 048B4376BD1
	for <kvmarm@lists.linux.dev>; Fri,  7 Aug 2026 11:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.5
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786102637; cv=fail; b=oGR2+vtR3JZnAsoDNHTULhiMSnUQuF+5MqE2PTiuXXxc80iShl6ZvLFqb/d89EapK/ZspeAzwQcUTQWPLo+QjRS9LDCCEMeswgZwBjry3tytb2q/O2fn4f1N4Zz8MIrc8q2KTkdduMks25gv3HNjfYQ2/6gPm6MXixuFrzbzdEw=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786102637; c=relaxed/simple;
	bh=TM6529ZjZ5sl6GAtD887BE+txnEdVuRQVa5xf8G8UuA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=UIuzM9hu7m6mhCmlrrElWppCzcMayklrEA9H1qSj/fE8pWeYGWjBTzzcrhWmGP5I4PV1Lk5dev3oCEO+GcDGKcFYw7C8JKTPLNynvhE8bsLY0RvTvOtCb7UujVi9J9YJf/6Q3YtTMTHWJAjIU4lVi3gMtB0hh7+v67iC7MgBEJ0=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Aolk2VTJ; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Aolk2VTJ; arc=fail smtp.client-ip=52.101.65.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Aolk2VTJ";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Aolk2VTJ"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=CqMVW6DqRYfA3kJqpzwqGorQ/dJqqX/rgLc1Nle6m4KFgytz/6paV+VT/sr/IUiU74U4RDZocvp4pOrM/X1+r/6EtQJ/ogVJJ5/BuUO1DbD1LkA6tFYFJEgNW9BXbmrdtCvUT25CWbBf6PD29rD7yxQgfF1uK1ijNsV5gNk0iQauu/itC6Ks3iG50p/6Unn3KSRLQlj6lCHKvDgiV0ErlGEHK5PEL5d+92ujh9EIbm61bsQR8OvXyJ/ciAUpXD59uAg2VbYcg52BZWBKcAUuo5AZ7aD5sEVxwFx/btkRAPP2HUv0//yhDcCazPLob1bGeP/6amS9/67mQAzrY1kQEA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vg7HhJIbk54hCegxWgGnm0nVctSEha0sQ1M7GkpScyw=;
 b=n5Mc4R3GVMH9I7mAUhheijuRP5YVdjpbxypCBNQagW5kWx/k4kqddNKFwYh4hh2K7saIEV+KM8xoIh5XOJminFgNniqT9dSUeQ0OjrKXorZ7BB+LiiE+emGaLiezpYeUZx5GCAzH5cszwj2N3Oh72in/jVvsfkJ/RvzPadfh3kTZZejhOcNhNUa0TcJiA5wS+21AASmANMyCV5Zd7jZxktBW0hivceqJ9Pf0nHkmUE5b37qfE+YdBUAfa7xLGWl2Ej4baFiuzQOgXp51O+mLMcXrXr+XasqpMJng7B6g50TFk2yE+/YikZRSCfMmw1ic0ZUOlee4BXejxTFBGH0SQQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vg7HhJIbk54hCegxWgGnm0nVctSEha0sQ1M7GkpScyw=;
 b=Aolk2VTJNRz6xxZ3cP19yTuawb6Ftqf4u5DdqsF7OMA0J5A/0ppo6K803OxQm8qkN4G5ZpjKMy3xrhU16IKS1kZ93V4iBCr63BDGqTqrir6DiiYxTsD7ecZgxj/bTPMl/GYSP3PUQ4o9N+8vHbKTbbJ6hZGUzI1QoGtToEre6Y4=
Received: from DU7P189CA0027.EURP189.PROD.OUTLOOK.COM (2603:10a6:10:552::22)
 by AM7PR08MB5384.eurprd08.prod.outlook.com (2603:10a6:20b:10c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.23; Fri, 7 Aug
 2026 11:37:06 +0000
Received: from DB1PEPF000509E5.eurprd03.prod.outlook.com
 (2603:10a6:10:552:cafe::65) by DU7P189CA0027.outlook.office365.com
 (2603:10a6:10:552::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.23 via Frontend Transport; Fri, 7
 Aug 2026 11:37:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509E5.mail.protection.outlook.com (10.167.242.55) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.8
 via Frontend Transport; Fri, 7 Aug 2026 11:37:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mOspk9WdAO8rzD+mS1B+djmbjTqz89drQmVTRz65gs6achW1pzW+6EO2+VxZ3ABpmhJpk6nqwXHTeabjnsv+nJvwXNUKCYAWlM5yhpnGII8aFxD9agRfB7XhKpDHOiyU2M1TUM5Y2F3Sfa5r8LoWDwdy7jv0pC2kOKI5BafhMB99o1xJm9srm1YN5StmnYZu7g67RoETdp20JKFodxlL30IMfdIzkhd0n8cekWBeNcGSeVaj31u2G9H1eMsPhv7lYIIgR+Bq7aDDkkNidf5ioAVBRBOhSJEWq7OeRujzfNj/SJ/LgznAUpIA0JjBjBxQ+DZy+yvrAoLlKHRZV375Vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vg7HhJIbk54hCegxWgGnm0nVctSEha0sQ1M7GkpScyw=;
 b=MjIiTeZwu2rd7PJKWRmAf0Twry43ysmt4fhmeilgh2OxuJBpTpAurXfUfP1mayk9FYPu0JLS6UJGW6NcH2+hXR/+BY/acVAR39AoBLKIJwP8Whml9VsWpxjPBgcBTuK7vjwx134FzfeChORREmz0RqOf69rAiBWxlwOWClbbtxBeJIKziRijGhgvA8OOcKCB4Jn6YN3hQFzyw2Nr33CtLWeechh0b29pkftmp6r7bUCpz6c5MzK9CaKmaqQDo7rqoL2pF50ChMjN5qdHGblwt65xXIJImMl4JAg4uZWjH7edtwttb6hqhepdC56GeKrs5j8rjHuJlX7asasEYBxkjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vg7HhJIbk54hCegxWgGnm0nVctSEha0sQ1M7GkpScyw=;
 b=Aolk2VTJNRz6xxZ3cP19yTuawb6Ftqf4u5DdqsF7OMA0J5A/0ppo6K803OxQm8qkN4G5ZpjKMy3xrhU16IKS1kZ93V4iBCr63BDGqTqrir6DiiYxTsD7ecZgxj/bTPMl/GYSP3PUQ4o9N+8vHbKTbbJ6hZGUzI1QoGtToEre6Y4=
Received: from GV1PR08MB8428.eurprd08.prod.outlook.com (2603:10a6:150:81::5)
 by DBBPR08MB10793.eurprd08.prod.outlook.com (2603:10a6:10:53d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.23; Fri, 7 Aug
 2026 11:36:32 +0000
Received: from GV1PR08MB8428.eurprd08.prod.outlook.com
 ([fe80::9b97:c973:3308:5ba7]) by GV1PR08MB8428.eurprd08.prod.outlook.com
 ([fe80::9b97:c973:3308:5ba7%5]) with mapi id 15.21.0292.018; Fri, 7 Aug 2026
 11:36:32 +0000
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
Subject: [PATCH v5 47/49] KVM: selftests: Add VGICv5 LPI delivery tests
Thread-Topic: [PATCH v5 47/49] KVM: selftests: Add VGICv5 LPI delivery tests
Thread-Index: AQHdJmD+kEyRawFw+kS79lYoQsgFew==
Date: Fri, 7 Aug 2026 11:36:32 +0000
Message-ID: <20260807111159.429128-48-sascha.bischoff@arm.com>
References: <20260807111159.429128-1-sascha.bischoff@arm.com>
In-Reply-To: <20260807111159.429128-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	GV1PR08MB8428:EE_|DBBPR08MB10793:EE_|DB1PEPF000509E5:EE_|AM7PR08MB5384:EE_
X-MS-Office365-Filtering-Correlation-Id: 99952e7a-d310-4a08-5c17-08def4783507
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|23010399003|22082099003|18002099003|38070700021|6133799003|11063799006|10067099003|56012099006|3023799007;
X-Microsoft-Antispam-Message-Info-Original:
 KSdsBCnPrNJPRvTsTDz94RV02Ly04qcRgFQV/35dhAtxWs5aLW7ziIP7XjJAyNPPK8/MQONZWxsU0khTu4vaBtxmv/wz60L0Mlpgm0zuUNrbHuapKArw/orgh7LnSt6h6qoQb2DukDn5YJTQBnerYDyKA88nSmu80hU5QcT/T0vnhZ6xus/Y2LGmsZF0Zxav6rhA5Rfs6FXwH1FgrbdkT+gFxf+eUYcQoM/6ZrM2kOqcaQntwuiWtRleQMzzN5q+j77yDU59ztvG2kBGmVaJR9QVEMFvC3SQpWV8Jj4WlJI3cpeDQtc+QK1YL2KFb2WB+t/cCcHRJ0/Xf9EIYkzThmUZuB8+fGC0XKjnJRGMP4BgRfg84ySw8yuMy/hQLWvwWxyThIRSs3v/Da4lfGX1+Lh4KcLBSZcPwKi8xRx1irc9fBUge0oPJSFlO4KL8Y29QsArvATNmohjl0ySB6LZhd+/lrnAALP7Vlm4o6ziHXRScrnju+kRmmJ11s+OFAQadn7wvdSroOTh/NCs3laTnDhzF6K6TCp4XDJruwztuAeLMkL6NwevEN6dPWyotgH0PMIN9MT0kMiLK6+ty/eCg5eh/FhWj++xCoGpiKebG6+v6FcnqCEJBUMk7SuNd0TY1w6IQD2cjk4dZUjYy44IEHTQMU/I71uSSLjzWlemoBrzr34N0jZQUSvWA69Wh+H9c70OP+e2rTc9xI16Fx2+6l9hV19lfQVuGG42vDrwN8w=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB8428.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(23010399003)(22082099003)(18002099003)(38070700021)(6133799003)(11063799006)(10067099003)(56012099006)(3023799007);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 AjI34NSIQmaiw1XYNPBncyBu4yCt0t+A9XSQF8BN2QZZh7D/WZSq/TdaQ66hDJcMWt9QAkGDSai5uhUvRasNNOmk++RyQ+k020aIR27K6VsdCQTYQ2H/9y80Atw2NcWjr1NvAU8R+WnR//noL0LBgYWG7jKyrJgbUeNCrlVtXPsqZ72FsIqbLnF7I/INlvjaIgS4Fe18ipQ0jK8TU1HmpRNjdvxYWFyqSbM7TfjHexP78PMuR3tWxDDfVeD/vwDZ9cdG26mwf9pzT8lf/D9ZNzRm1f/txPolrVqokjvF6GaSCPPbGgRRjPzqFTH3zJu1dxbCgs9V8FLqfBYguGRS5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR08MB10793
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509E5.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	79b427cf-1fc0-4f13-2f41-08def4782176
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|14060799003|82310400026|35042699022|1800799024|36860700016|376014|18002099003|22082099003|10067099003|6133799003|11063799006|56012099006|3023799007;
X-Microsoft-Antispam-Message-Info:
	0ydSnDw7d3JJStGDLvr+Ib0yuiz6lt1rbnxGPkgY3auxuvzumiVc9Qj4zjPknEfrn69RzcMFr5kH/B2wRvYCOX9fVVv1b/LH1AXY7YZ3bhKq3EjMuxDvQ3tcj4q66iVMprGuh4g8tFQvandyGBz0OIkZjSp/7mzpuJQfmk+cx9NFK8E8cDIjbuTNmogHiJUAz/Yj+LvmR3BJLgo8Mv76Qq45DW0H06AbdTe2mglhv4vFlP/CGgMmiTltoq6G3wW0DFstfz1qErAOe9vpIOM8DNW6BxBIxZr0FnmS2HpkCN9wYajLIqfgy4O8X39ltYBy5ufoqzm9Rsh9aaNejXwD0opZbh16anH0oyz6ngZ+U2aWLtW1BLsqi/HzjyulJ3FfZVFd4iiur20/LEovu4AyRflmBGcENC2LytsNVDyW2c7wflq5RV/t6tryOMw8GW5xrU/MJxb3Unf55ETahqwWxbd+xKTH6EJzkxwE+3Ezh/YBo4psTi/KXN+Ym5pFSGm4QwsIsy1uEk3w0Xmi+zPPh2h4PZMO3521xCcDCv9o67xV730MQQlpUn39RE0gc8Ey4NXr06M6hHKYR92RURsOMNO8O5XN+apnstzIIbaD0x9M0ilABo/Ue7aT6bb4E0CqWGe7USGCaaraNUmQPfdwQkNcDTZ5V8auveDS+9Qwz6oqpC0sPRz9AFdeYI5PmyRoAAbuGyUfUnOJPrHFGlJqig==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(14060799003)(82310400026)(35042699022)(1800799024)(36860700016)(376014)(18002099003)(22082099003)(10067099003)(6133799003)(11063799006)(56012099006)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	ZmAZ/20oVsYHT/YMl8/5UgT+f6w/W0q6NQgXKTnFbbOrEEhgAsrE3eBgupyduPuyJmhsiMseWz8vsLOZcXmPzPQZTjM4dOENuYDeSENUYGDbRez485zMWqClkpYBVHQIpe9xeNMDT6P070Y8+GRjnPpIkuOKKbvwwG++QxISLOfV5+/Y8dJ9/ys1QU5aTBtC+paRoJSbBMODSck/v8nQJmAka6jk1l9y3ODDSHAUpcyjtcAFeRQNLnT15lXXrz1G4BsdMBKJZROwW1KibZ2qjstn+xsF0Jkt9qVq2/v+jc34BYx7xWEqZWiFTzKIKzZ5SySc9uVAC7aUIBsqH1WLouyFdJPtF7LOHBEH4x/Nobdzcovts0eTV6v68NAx9gwdftkmBq3gaxk22lNQWlK6z6cT60Q5/57kKily1X4FksC7+iLAFENnAm50kLBPMYtz
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2026 11:37:05.4985
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 99952e7a-d310-4a08-5c17-08def4783507
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509E5.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR08MB5384

Add a two-VPE VGICv5 LPI delivery test. LPIs depend on an IST whose
base is provided by the guest through IRS_IST_BASER, which causes KVM
to allocate and provide an LPI IST to the hardware. Exercise the
virtual IRS ID registers and IST base configuration path before
checking interrupt delivery.

Back the guest's LPI IST with a dedicated userspace memslot and
identity-map it into the guest at the same IPA and VA. This lets the
guest provide that address to the emulated IRS through IRS_IST_BASER
while the host test still allocates and owns the backing memory.

Have VPE0 enable the IRS, derive a valid linear LPI IST configuration
from the virtual IRS ID registers, provide the IST base through
IRS_IST_BASER, configure one LPI for each VPE, and send an LPI to
VPE1. While the BASER is valid, attempt to change its address and
verify that the write is ignored. VPE1 consumes the first LPI and
replies with a second, which VPE0 consumes before completing the test.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 tools/testing/selftests/kvm/arm64/vgic_v5.c   | 247 +++++++++++++++++-
 .../selftests/kvm/include/arm64/gic_v5.h      |  16 ++
 2 files changed, 261 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/arm64/vgic_v5.c b/tools/testing/se=
lftests/kvm/arm64/vgic_v5.c
index 23fbd2db50c43..71bda5661c74e 100644
--- a/tools/testing/selftests/kvm/arm64/vgic_v5.c
+++ b/tools/testing/selftests/kvm/arm64/vgic_v5.c
@@ -13,11 +13,17 @@
 #include "vgic.h"
=20
 #define NR_VCPUS		1
+#define VGIC_V5_LPI_NR_VCPUS	2
+#define VGIC_V5_LPI_MEMSLOT	1
 #define VGIC_V5_NR_PRIVATE_IRQS	64
 #define VGIC_V5_DEFAULT_NR_SPIS	32
 #define VGIC_V5_MAX_NR_SPIS	BIT(10)
 #define VGIC_V5_IRS_SIZE		0x20000
 #define VGIC_V5_IRS_WAIT_RETRIES	1000000
+#define VGIC_V5_LPI_IST_BASE_GPA	(GICV5_IRS_CONFIG_BASE_GPA + VGIC_V5_IRS_=
SIZE)
+#define VGIC_V5_LPI_IST_SIZE		0x10000
+#define LPI_TEST_TO_VPE1		0
+#define LPI_TEST_TO_VPE0		1
=20
 static u64 max_phys_size;
=20
@@ -33,6 +39,8 @@ struct vm_gic {
 #define GUEST_CMD_IRQ_DIEOI	11
 #define GUEST_CMD_IS_AWAKE	12
 #define GUEST_CMD_IS_READY	13
+#define GUEST_CMD_LPI_SENT	14
+#define GUEST_CMD_LPI_REPLIED	15
=20
 static struct kvm_vgic_v5_ist vgic_v5_ist_attr(void *spi_ist, size_t spi_s=
ize,
 					       void *lpi_ist, size_t lpi_size)
@@ -47,11 +55,22 @@ static struct kvm_vgic_v5_ist vgic_v5_ist_attr(void *sp=
i_ist, size_t spi_size,
=20
 static u32 spi_line_expected;
 static bool spi_line_level_sensitive;
+static bool lpi_ist_ready;
+
+static u64 gicv5_hwirq(u32 type, u32 intid)
+{
+	return FIELD_PREP(GICV5_HWIRQ_TYPE, type) |
+	       FIELD_PREP(GICV5_HWIRQ_ID, intid);
+}
+
+static u64 gicv5_lpi_hwirq(u32 lpi)
+{
+	return gicv5_hwirq(GICV5_HWIRQ_TYPE_LPI, lpi);
+}
=20
 static u64 gicv5_spi_hwirq(u32 spi)
 {
-	return FIELD_PREP(GICV5_HWIRQ_TYPE, GICV5_HWIRQ_TYPE_SPI) |
-	       FIELD_PREP(GICV5_HWIRQ_ID, spi);
+	return gicv5_hwirq(GICV5_HWIRQ_TYPE_SPI, spi);
 }
=20
 static void gicv5_setup_and_enable_hwirq(u64 hwirq, u32 target_vpe)
@@ -73,6 +92,18 @@ static void gicv5_enable_spi(u32 spi, u32 target_vpe)
 	gicv5_setup_and_enable_hwirq(gicv5_spi_hwirq(spi), target_vpe);
 }
=20
+static void gicv5_enable_lpi(u32 lpi, u32 target_vpe)
+{
+	gicv5_setup_and_enable_hwirq(gicv5_lpi_hwirq(lpi), target_vpe);
+}
+
+static void gicv5_send_lpi(u32 lpi)
+{
+	u64 hwirq =3D gicv5_lpi_hwirq(lpi);
+
+	gic_insn(hwirq | GICV5_GIC_CDPEND_PENDING_MASK, CDPEND);
+}
+
 static void gicv5_wait_for_irs_idle(u32 reg, u32 idle)
 {
 	int i;
@@ -102,6 +133,58 @@ static void gicv5_configure_spi(u32 spi, bool level)
 				GICV5_IRS_SPI_STATUSR_IDLE);
 }
=20
+static u32 gicv5_lpi_istsz(u32 idr2, u32 lpi_id_bits)
+{
+	if (!(idr2 & GICV5_IRS_IDR2_ISTMD))
+		return GICV5_IRS_IST_CFGR_ISTSZ_4;
+
+	if (lpi_id_bits >=3D FIELD_GET(GICV5_IRS_IDR2_ISTMD_SZ, idr2))
+		return GICV5_IRS_IST_CFGR_ISTSZ_16;
+
+	return GICV5_IRS_IST_CFGR_ISTSZ_8;
+}
+
+static void gicv5_configure_lpi_ist(void)
+{
+	u32 idr2, min_lpi_id_bits, lpi_id_bits, id_bits, istsz;
+	u64 val;
+
+	idr2 =3D readl(GICV5_IRS_CONFIG_BASE_GVA + GICV5_IRS_IDR2);
+	GUEST_ASSERT(idr2 & GICV5_IRS_IDR2_LPI);
+
+	min_lpi_id_bits =3D FIELD_GET(GICV5_IRS_IDR2_MIN_LPI_ID_BITS, idr2);
+	id_bits =3D FIELD_GET(GICV5_IRS_IDR2_ID_BITS, idr2);
+	/* Default to 32 LPIs, unless the min requirement is higher */
+	lpi_id_bits =3D max(5U, min_lpi_id_bits);
+	GUEST_ASSERT(lpi_id_bits <=3D id_bits);
+
+	istsz =3D gicv5_lpi_istsz(idr2, lpi_id_bits);
+	/*
+	 * We allocate a fixed-size IST buffer on the host to avoid dynamic
+	 * allocation from the guest. Make sure it fits the linear IST described
+	 * by IDR2 before programming IRS_IST_BASER.
+	 */
+	GUEST_ASSERT((BIT_ULL(lpi_id_bits) << (istsz + 2)) <=3D VGIC_V5_LPI_IST_S=
IZE);
+
+	val =3D FIELD_PREP(GICV5_IRS_IST_CFGR_LPI_ID_BITS, lpi_id_bits) |
+	      FIELD_PREP(GICV5_IRS_IST_CFGR_ISTSZ, istsz);
+	writel(val, GICV5_IRS_CONFIG_BASE_GVA + GICV5_IRS_IST_CFGR);
+
+	val =3D FIELD_PREP(GICV5_IRS_IST_BASER_ADDR_MASK,
+			 VGIC_V5_LPI_IST_BASE_GPA >> GICV5_IRS_IST_BASER_ADDR_SHIFT);
+	val |=3D GICV5_IRS_IST_BASER_VALID;
+	writeq(val, GICV5_IRS_CONFIG_BASE_GVA + GICV5_IRS_IST_BASER);
+
+	GUEST_ASSERT_EQ(readl(GICV5_IRS_CONFIG_BASE_GVA + GICV5_IRS_IST_STATUSR),
+			GICV5_IRS_IST_STATUSR_IDLE);
+
+	/* The address is immutable while the BASER is valid. */
+	writeq(val ^ FIELD_PREP(GICV5_IRS_IST_BASER_ADDR_MASK, 1),
+	       GICV5_IRS_CONFIG_BASE_GVA + GICV5_IRS_IST_BASER);
+	GUEST_ASSERT_EQ(readq(GICV5_IRS_CONFIG_BASE_GVA +
+			      GICV5_IRS_IST_BASER), val);
+}
+
 static void gicv5_enable_irs(void)
 {
 	writel(GICV5_IRS_CR0_IRSEN,
@@ -109,6 +192,12 @@ static void gicv5_enable_irs(void)
 	gicv5_wait_for_irs_idle(GICV5_IRS_CR0, GICV5_IRS_CR0_IDLE);
 }
=20
+static void gicv5_configure_test_lpis(void)
+{
+	gicv5_enable_lpi(LPI_TEST_TO_VPE1, 1);
+	gicv5_enable_lpi(LPI_TEST_TO_VPE0, 0);
+}
+
 static void guest_ppi_irq_handler(struct ex_regs *regs)
 {
 	bool valid;
@@ -209,6 +298,67 @@ static void guest_spi_line_code(void)
 		wfi();
 }
=20
+static void guest_lpi_irq_handler(struct ex_regs *regs)
+{
+	u32 vcpu_id =3D guest_get_vcpuid();
+	u32 expected_lpi =3D vcpu_id ? LPI_TEST_TO_VPE1 : LPI_TEST_TO_VPE0;
+	u64 expected_hwirq =3D gicv5_lpi_hwirq(expected_lpi);
+	u32 hwirq;
+	u64 ia;
+
+	ia =3D gicr_insn(CDIA);
+	if (!GICV5_GICR_CDIA_VALID(ia))
+		return;
+
+	gsb_ack();
+	isb();
+
+	hwirq =3D FIELD_GET(GICV5_GICR_CDIA_INTID, ia);
+	GUEST_ASSERT_EQ(hwirq, expected_hwirq);
+
+	gic_insn(hwirq, CDDI);
+	gic_insn(0, CDEOI);
+
+	if (vcpu_id) {
+		gicv5_send_lpi(LPI_TEST_TO_VPE0);
+		GUEST_SYNC(GUEST_CMD_LPI_REPLIED);
+		while (1)
+			wfi();
+	}
+
+	GUEST_DONE();
+}
+
+static void guest_lpi_code(void)
+{
+	u32 vcpu_id =3D guest_get_vcpuid();
+
+	local_irq_disable();
+
+	if (!vcpu_id) {
+		gicv5_enable_irs();
+		gicv5_configure_lpi_ist();
+		gicv5_configure_test_lpis();
+		WRITE_ONCE(lpi_ist_ready, true);
+	}
+
+	/* Go bang if we run VCPU1 before VCPU0 */
+	GUEST_ASSERT(READ_ONCE(lpi_ist_ready));
+
+	gicv5_cpu_enable_interrupts();
+	local_irq_enable();
+
+	GUEST_SYNC(GUEST_CMD_IS_READY);
+
+	if (!vcpu_id) {
+		gicv5_send_lpi(LPI_TEST_TO_VPE1);
+		GUEST_SYNC(GUEST_CMD_LPI_SENT);
+	}
+
+	while (1)
+		wfi();
+}
+
 /* we don't want to assert on run execution, hence that helper */
 static int run_vcpu(struct kvm_vcpu *vcpu)
 {
@@ -279,6 +429,48 @@ static void vgic_v5_spi_line_vm_create(struct vm_gic *=
v,
 			    KVM_DEV_ARM_VGIC_CTRL_INIT, NULL);
 }
=20
+static void vgic_v5_lpi_vm_create(struct vm_gic *v,
+				  struct kvm_vcpu *vcpus[VGIC_V5_LPI_NR_VCPUS])
+{
+	unsigned int nr_lpi_ist_pages;
+	u64 attr;
+	int i;
+
+	v->gic_dev_type =3D KVM_DEV_TYPE_ARM_VGIC_V5;
+	v->vm =3D __vm_create(VM_SHAPE_DEFAULT, VGIC_V5_LPI_NR_VCPUS, 0);
+	v->gic_fd =3D kvm_create_device(v->vm, v->gic_dev_type);
+
+	for (i =3D 0; i < VGIC_V5_LPI_NR_VCPUS; i++) {
+		vcpus[i] =3D vm_vcpu_add(v->vm, i, guest_lpi_code);
+		TEST_ASSERT(vcpus[i], "Failed to create vCPU");
+	}
+
+	vm_init_descriptor_tables(v->vm);
+	vm_install_exception_handler(v->vm, VECTOR_IRQ_CURRENT,
+				     guest_lpi_irq_handler);
+
+	for (i =3D 0; i < VGIC_V5_LPI_NR_VCPUS; i++)
+		vcpu_init_descriptor_tables(vcpus[i]);
+
+	attr =3D GICV5_IRS_CONFIG_BASE_GPA;
+	kvm_device_attr_set(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+			    KVM_VGIC_V5_ADDR_TYPE_IRS, &attr);
+	vgic_v5_map_irs(v->vm);
+
+	nr_lpi_ist_pages =3D vm_calc_num_guest_pages(v->vm->mode,
+						   VGIC_V5_LPI_IST_SIZE);
+	vm_userspace_mem_region_add(v->vm, VM_MEM_SRC_ANONYMOUS,
+				    VGIC_V5_LPI_IST_BASE_GPA,
+				    VGIC_V5_LPI_MEMSLOT,
+				    nr_lpi_ist_pages, 0);
+	/* Map the IST at VA =3D=3D IPA so the guest can program the same BASER. =
*/
+	virt_map(v->vm, VGIC_V5_LPI_IST_BASE_GPA,
+		 VGIC_V5_LPI_IST_BASE_GPA, nr_lpi_ist_pages);
+
+	kvm_device_attr_set(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
+			    KVM_DEV_ARM_VGIC_CTRL_INIT, NULL);
+}
+
 static void vgic_v5_run_spi_line_test(u32 nr_spis, u32 expected_spi,
 				      bool level_sensitive,
 				      bool lower_before_run)
@@ -1170,6 +1362,54 @@ static void test_vgic_v5_spis(void)
 	vgic_v5_run_spi_line_test(VGIC_V5_DEFAULT_NR_SPIS, 2, true, false);
 }
=20
+static void test_vgic_v5_lpis(void)
+{
+	struct kvm_vcpu *vcpus[VGIC_V5_LPI_NR_VCPUS];
+	struct ucall uc;
+	struct vm_gic v;
+	int ret;
+
+	lpi_ist_ready =3D false;
+	vgic_v5_lpi_vm_create(&v, vcpus);
+	sync_global_to_guest(v.vm, lpi_ist_ready);
+
+	/* VPE0 programs a linear LPI IST from the virtual IRS ID registers. */
+	ret =3D run_vcpu(vcpus[0]);
+	TEST_ASSERT(!ret, "Failed to run GICv5 LPI vCPU0");
+	TEST_ASSERT(get_ucall(vcpus[0], &uc) =3D=3D UCALL_SYNC &&
+		    uc.args[1] =3D=3D GUEST_CMD_IS_READY,
+		    "GICv5 LPI vCPU0 did not become ready");
+
+	/* VPE1 waits for the shared LPI setup and enables its CPU interface. */
+	ret =3D run_vcpu(vcpus[1]);
+	TEST_ASSERT(!ret, "Failed to run GICv5 LPI vCPU1");
+	TEST_ASSERT(get_ucall(vcpus[1], &uc) =3D=3D UCALL_SYNC &&
+		    uc.args[1] =3D=3D GUEST_CMD_IS_READY,
+		    "GICv5 LPI vCPU1 did not become ready");
+
+	/* VPE0 sends an LPI to VPE1. */
+	ret =3D run_vcpu(vcpus[0]);
+	TEST_ASSERT(!ret, "Failed to run GICv5 LPI vCPU0 sender");
+	TEST_ASSERT(get_ucall(vcpus[0], &uc) =3D=3D UCALL_SYNC &&
+		    uc.args[1] =3D=3D GUEST_CMD_LPI_SENT,
+		    "GICv5 LPI vCPU0 did not send LPI");
+
+	/* VPE1 consumes the LPI and replies with another LPI. */
+	ret =3D run_vcpu(vcpus[1]);
+	TEST_ASSERT(!ret, "Failed to run GICv5 LPI vCPU1 receiver");
+	TEST_ASSERT(get_ucall(vcpus[1], &uc) =3D=3D UCALL_SYNC &&
+		    uc.args[1] =3D=3D GUEST_CMD_LPI_REPLIED,
+		    "GICv5 LPI vCPU1 did not reply");
+
+	/* VPE0 consumes the reply LPI and ends the test. */
+	ret =3D run_vcpu(vcpus[0]);
+	TEST_ASSERT(!ret, "Failed to run GICv5 LPI vCPU0 receiver");
+	TEST_ASSERT(get_ucall(vcpus[0], &uc) =3D=3D UCALL_DONE,
+		    "GICv5 LPI vCPU0 did not complete");
+
+	vm_gic_destroy(&v);
+}
+
 /*
  * Returns 0 if it's possible to create GIC device of a given type (V5).
  */
@@ -1224,6 +1464,9 @@ void run_tests(u32 gic_dev_type)
=20
 	pr_info("Test VGICv5 SPIs\n");
 	test_vgic_v5_spis();
+
+	pr_info("Test VGICv5 LPIs\n");
+	test_vgic_v5_lpis();
 }
=20
 int main(int ac, char **av)
diff --git a/tools/testing/selftests/kvm/include/arm64/gic_v5.h b/tools/tes=
ting/selftests/kvm/include/arm64/gic_v5.h
index 091d9dbd3c01d..2d455515563e0 100644
--- a/tools/testing/selftests/kvm/include/arm64/gic_v5.h
+++ b/tools/testing/selftests/kvm/include/arm64/gic_v5.h
@@ -80,6 +80,14 @@
=20
 #define GICV5_IRS_IDR1_PRIORITY_BITS	GENMASK(22, 20)
=20
+#define GICV5_IRS_IDR2_ISTMD_SZ	GENMASK(19, 15)
+#define GICV5_IRS_IDR2_ISTMD		BIT(14)
+#define GICV5_IRS_IDR2_IST_L2SZ	GENMASK(13, 11)
+#define GICV5_IRS_IDR2_IST_LEVELS	BIT(10)
+#define GICV5_IRS_IDR2_MIN_LPI_ID_BITS	GENMASK(9, 6)
+#define GICV5_IRS_IDR2_LPI		BIT(5)
+#define GICV5_IRS_IDR2_ID_BITS		GENMASK(4, 0)
+
 #define GICV5_IRS_CR0_IDLE		BIT(1)
 #define GICV5_IRS_CR0_IRSEN		BIT(0)
=20
@@ -94,6 +102,13 @@
 #define GICV5_IRS_IST_BASER_ADDR_MASK	GENMASK_ULL(55, 6)
 #define GICV5_IRS_IST_BASER_VALID	BIT_ULL(0)
 #define GICV5_IRS_IST_BASER_ADDR_SHIFT	6ULL
+#define GICV5_IRS_IST_CFGR_STRUCTURE	BIT(16)
+#define GICV5_IRS_IST_CFGR_ISTSZ	GENMASK(8, 7)
+#define GICV5_IRS_IST_CFGR_L2SZ	GENMASK(6, 5)
+#define GICV5_IRS_IST_CFGR_LPI_ID_BITS	GENMASK(4, 0)
+#define GICV5_IRS_IST_CFGR_ISTSZ_4	0b00
+#define GICV5_IRS_IST_CFGR_ISTSZ_8	0b01
+#define GICV5_IRS_IST_CFGR_ISTSZ_16	0b10
=20
 /*
  * Definitions for GICv5 instructions for the Current Domain
@@ -164,6 +179,7 @@
=20
 #define GICV5_HWIRQ_TYPE		GENMASK_ULL(31, 29)
 #define GICV5_HWIRQ_ID			GENMASK_ULL(23, 0)
+#define GICV5_HWIRQ_TYPE_LPI		0x2
 #define GICV5_HWIRQ_TYPE_SPI		0x3
=20
 #define gicr_insn(insn)			read_sysreg_s(GICV5_OP_GICR_##insn)
--=20
2.34.1
