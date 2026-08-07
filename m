Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011004.outbound.protection.outlook.com [52.101.65.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C93AB3F6613
	for <kvmarm@lists.linux.dev>; Fri,  7 Aug 2026 11:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.4
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786102084; cv=fail; b=rwkgmAlQIlQ2j1IYV/9aBoyD0CD1b+5azwmg1Aa9JQTQqXUyk9cgmHgSDsCS8CHXV2yKk6z6EMm5HVEpZ0rcEkpLOFJAfasWNiVkD5t+qrDBkj1S4mLnhXVEwZobE1PFgPrIrZ82g5pyCn/VsIdl/KNYndamFXLjx1t5jY1oDCE=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786102084; c=relaxed/simple;
	bh=M7cuoF6Fcy/YWmAY/AQia2G8vxfCrErFB9aBwunzclI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=GL3I2HiFhfCbyja7mhs89TSDvI4J4VOz6Y4lTbloy+c+S9vdPKJMRzXBwaEe47zpZqgjbkE3eqniZ/naaBGBVFUjhlbWSWZ8zjLv2KIxsmbz5Zonk+AV77GeM9DicylQQvBxo9G47ES32kv2SylL3CrRoi9U0jaFaih7wEh6ih0=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=mwBOsu5V; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=mwBOsu5V; arc=fail smtp.client-ip=52.101.65.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="mwBOsu5V";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="mwBOsu5V"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=zNdNP1Xxql704sbn0D48ZWzW/zKY+htk4sgAlhJJtiOAlloCjIPVaHqTplaoFjUt5CW2MqQl4/kubtVNwfmo5FYJimJmrBX7ewsspqhd1eT5RKTdDjEq9+274m5kP9YKx1hPS7WCV1tN09CCf4Pg/bJvupWuW4UuAEDTui6CRxHXU41ImRvQhVDHgqINzfLKnV7Wjmd6o/jpvK0hfI9dt6xk1gRcOvBmXFVHbr8HIifsYrT0YQzri8wJaneaoXnj49m78UOj4jM4xFo6CDj1QqcXPFt8U9KBR+vbf5Qu1eCtX+daxFgi1pyZZ9lAO1N8YP5WoQnvxR2YXoJa4hqlpw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mV/fYt8z9inTjQLtumcwP+TrD7h7rhP6cqR8OiFEl9k=;
 b=d9gK6sQ51bNCvuv+/qcVhc8V2Zh4Ogzk8cebcIpFJ81srDcbQaJWwgV9Ba39nRd+hLJCaKFSFo2uKmdpA7uNfT4Y9dspYpq/hP78zoFsRmCK9f0k/k77syKF8u2dZfdNhn/fuviae4B8GdRhEmmK7dP0Ddv3R/CqitWyZJU2Y2JglazDNP95YFDTbwjQPzainRIfEDqyR0eInGN0k5sJoe6hYIr1zKNhv1OfHaZzzTtQfHz1vgHUHYEtgmqkhTQtgXHcwzYRtO8753dOwqnFHb2OIxExAebzkIfoc/puV4tRFoY63VPRpGG/xcLZxc6HiZpat/ygX2ra8XkFzM1/EA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mV/fYt8z9inTjQLtumcwP+TrD7h7rhP6cqR8OiFEl9k=;
 b=mwBOsu5VPeb/KWhN9r9vpgm7FLmh5NmPmWkAoVRqalY3DStAUujw4zJlo6nFBL+bWY+1WTKWRoUa8t0Vv1F9yOdhKk5ajPNNORfT2DGGJz0GJGvlWv/Dp5mBltDZyDiZBTuk1hEk4I8yaQFVDmswzRhriLt5crp9CA0hVYUfJX8=
Received: from AM0PR02CA0192.eurprd02.prod.outlook.com (2603:10a6:20b:28e::29)
 by DBBPR08MB10747.eurprd08.prod.outlook.com (2603:10a6:10:536::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.23; Fri, 7 Aug
 2026 11:27:55 +0000
Received: from AMS0EPF000001A9.eurprd05.prod.outlook.com
 (2603:10a6:20b:28e:cafe::4e) by AM0PR02CA0192.outlook.office365.com
 (2603:10a6:20b:28e::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.21 via Frontend Transport; Fri, 7
 Aug 2026 11:27:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF000001A9.mail.protection.outlook.com (10.167.16.149) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.315.6
 via Frontend Transport; Fri, 7 Aug 2026 11:27:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NAlhiiDwfksaZg0n57T8bHF2Ilj1JkI6jlXh3j8+IvBMSe9Bi+aI4l6gmZ2MsjDAtS6Hid71ZhHMdki9MHVETIcB2+tw2SeT4/XRb7TGBDCCQ9j8apHipVo+HI1CwYJl8lAO5ZKpqulC6dIUDDgR/fOEfFpHPwMOBWZtcQMoFYDrj692q1JnqRfGXb2qMXHblu0ayyFEQWpkc7YLX2OTyhcFAURnDHDM4RIcBm46PRFkJRj66A930lQoNxrWG7EghpFO1shSjtZLVfGh4iaWSKjbtTuMYuu6p8aC6EJampx/QabQZPyxnQn+8A/rjaLfMqygdLuYh8E0DZB6wqMVOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mV/fYt8z9inTjQLtumcwP+TrD7h7rhP6cqR8OiFEl9k=;
 b=gDt+9qmfCwuLLpgOWiB/XggqVXoV8T09/6Xlr97h5cmdJoujN2+CL1MrWXb97zu0C4/eQe0BQ7naeCxJIuubZwK7eD2uZTtC3HjEzUBU+cIwEr25w8o4s1I5WCehjUOOO5Gps830j6lym66wbbgX+inlBoCOQyOEMGvocJN+MudnvC1+tK/ddoAFVMEijzklr0nfEXlXbMHJUKP66Po22LODuHe3RgTxitr1HEbv9uiEfBjSAk15X5801vZbXgvlROVAQngh7JsYd2WDiocIkWQ476gGSatgRxSMDU0aFaVtYMoCouqFsSoXKJ0KjitXIP6CbGCPe1wfJhtbXfkkWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mV/fYt8z9inTjQLtumcwP+TrD7h7rhP6cqR8OiFEl9k=;
 b=mwBOsu5VPeb/KWhN9r9vpgm7FLmh5NmPmWkAoVRqalY3DStAUujw4zJlo6nFBL+bWY+1WTKWRoUa8t0Vv1F9yOdhKk5ajPNNORfT2DGGJz0GJGvlWv/Dp5mBltDZyDiZBTuk1hEk4I8yaQFVDmswzRhriLt5crp9CA0hVYUfJX8=
Received: from GV1PR08MB8428.eurprd08.prod.outlook.com (2603:10a6:150:81::5)
 by PAVPR08MB9724.eurprd08.prod.outlook.com (2603:10a6:102:31f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.20; Fri, 7 Aug
 2026 11:27:22 +0000
Received: from GV1PR08MB8428.eurprd08.prod.outlook.com
 ([fe80::9b97:c973:3308:5ba7]) by GV1PR08MB8428.eurprd08.prod.outlook.com
 ([fe80::9b97:c973:3308:5ba7%5]) with mapi id 15.21.0292.018; Fri, 7 Aug 2026
 11:27:22 +0000
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
Subject: [PATCH v5 29/49] KVM: arm64: gic-v5: Add GICv5 SPI injection to irqfd
Thread-Topic: [PATCH v5 29/49] KVM: arm64: gic-v5: Add GICv5 SPI injection to
 irqfd
Thread-Index: AQHdJl+2LIxUaUm3KUeEZ5M8zHiUPQ==
Date: Fri, 7 Aug 2026 11:27:22 +0000
Message-ID: <20260807111159.429128-30-sascha.bischoff@arm.com>
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
	GV1PR08MB8428:EE_|PAVPR08MB9724:EE_|AMS0EPF000001A9:EE_|DBBPR08MB10747:EE_
X-MS-Office365-Filtering-Correlation-Id: ca6f5af0-1715-443f-28f1-08def476ecea
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|23010399003|11063799006|56012099006|10067099003|18002099003|22082099003|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 fvn0vJnak/46pI+wGB+IfaWF7gvqGJ8vX8wz1s/4T78P1C8WEuiz1agk4WSfW2ExeZavSEsmnL/aTpSngogbHXDDbHTbBIsxcP3KkOvGKWNLcxsSP6kiFRRO2NHzfnHVZTMxGNA7neJcxle68yu3lRcTVrOmhGcvcZyj5/xLpQ+wZx/8ROHReYsA0c4TZD77lBsM7AKI0sfMxN8HNaTZYEje10/k2dBlfUq/HvoCt39KMVnIf4aW52lerN9OYu3J8pr+SO1NDc1WXgPRh1g9B5c7nzHCgX6cGqOsKdLrRrwW7ZxSzs3Cu6mDuR4ji3OW/jV2inabbZNZ86E4x3OB9nTEv4q3nENxnOx6zsPtJVc/lQRoa6k08nK1dY/2Rc0Y7QsO+3n9GPlzOLWvGeA/pHqffxy7SuJeWRapo0ey3aqmFbZ6DpYZKMLAStWPFbwhlllLEP2qWDjeTP1xg7opcB3twR4EnZ9URrJexdmQg2zpepBUbnG3YOtH1RZc72ELyZVIcfstTGUOXwEYtXRLyyclioNmSQ1RpGFumJcC4gkeKw2k5w0JFdX1WjfJJn6qePPt9bdwv4zNxbzdprUXbDaK38UaD2XdLk0J4EmL9CtVJ6o6lphIUDVDJ1u4FA4Neqgpn0NokssFzPRMH9upjFgVSP3QW++OWHtrx5YQFvwfYybllfMMQN6HwTyM0tZmZPbVoHGeV1Hf82r5E6+EqaPwdSyet98VtDuLJpSkEfA=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB8428.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(23010399003)(11063799006)(56012099006)(10067099003)(18002099003)(22082099003)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 jiOW3JOYPkR3J3okHY1y9Vuxn2gjARS4Sp4rrl+tgPK8fjClRy9pkPQxmmb7jgyDB4dlluqTC7ZOKsQO2sQ16kcPhnz75KUsJl9FGgHFYrQoKJ1KrStoE87cyQldy6oTQUePwIao3p3Ut1D87YGQZw7YuI4KPceKHAS0YM7rm+a2bEbn2zY/nCbDLkWNuLCh2kmUJEYDSIsUbCyeyLL2JGnOScr1tFUy/UCQM0CmmUoxLVgOT+2QaF2BdswSY9sMEAP8PBad493MxI8dVj9MiFYhO+pOdgM36Li96nP9BJq/DAMRJG6vohanBYC84cokLMXgZprJPcFu2Q1A3xB38w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAVPR08MB9724
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF000001A9.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	0aa545e3-cf10-4bda-18fd-08def476d93b
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|82310400026|23010399003|35042699022|1800799024|376014|14060799003|56012099006|11063799006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	F18SXefDQ1NbND3HCJ6vQS9sjOxS/oLQmelHQ0bNaIPHU+trxHJc6UbCoDyE0jIYnlmDxLt/Q41uxJnIn5QFkjW3w/E9KVpHps4Aml278oYhDsWIzrFrVxWwGZfzYe0Ibwbe/gVx2Mf5yvZXIQ0TF5vhWOycR8k7i4BgN8JFAGd+MGIbWFKX7hrsfC/c/L+Q17wn4+fBEJVPXbJPaoYuB3ZSOmuJcn7jTY8HdJd3j+//ELiw8spPV45Ngninn0j5t3D5sV4HIAGvZr65aFYqCVdbSe8s5tWEDQeP+Uq1Bib3HCG0EfcUYgQ44jzETQQxIr5G4awY8Jf/c4ZkzNZMZFxIWFaSBuSX9HhGAsw/DIyJc/+xMioYpFc2KFaYFHANxdjjY6+4L85l2eF2XEX5KIS/pmatA34RFjIihtaD1F3ugt4gQTBaskxzaaIze6AnM3TX/EKphgeFEMuIwPYw8AtCgcDI3z9dpPEpbK3CXCkg3yx2gJAOJnRy7Q7OC+voRj3eDiO30s9Nvjo5B49eDWz2NMvSNWY01tgecq7oFmKhhBy0kJEcKu+xFzLfUOvjXNuFVHrYc0ydErFHAREjAR0brWRSWYjsqbk8eNT9tuR7xGc9STI8P2qT2Cp17BK4zp824+bydxfj0zha0IOJGqPUlihqtb5Q+6FJXoI7IuuKLm/Hm93LAA2ebcZ+24kMRv7P3mHZlijfinWgSqq5eA==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(82310400026)(23010399003)(35042699022)(1800799024)(376014)(14060799003)(56012099006)(11063799006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	bTmd9nvEQ2G2mWr++WFgFm9y17DP+clKgt100nkZYPHJhk2wPP8wZTrZ7JUWs77oIFqhF7p4Lxsan0X2/C72AXtQJHPweaZUUp6vUJsFFzF3suh8GY/M8XKHIaM1b5Dsr/31SNICYwBQQL5FwlVTvXT9JMINkCbUN+xR5vLzXU6dhjiAokPy1jvKUc5PyWvgTMb9JvPZr/8pNqkWnuWTFMcIpUMczaCc2IHitplFmkvkKR/Oqh6LMzR8kqUp5yXyPumZorG9/czRRPZDwyeIXhDEroO19xK8b7og2DX2/WUVbDESn2W0cOUvJdH+9dUJDaWjKTI3ryVVFYJpLfNTVZ5lgqXnBujLaJ4UbnoCteLGfn+4kg6jUyjAKgmLggGiNg+i2wq1/P/7s7dR2/Elbkgw1ZNq10ZMWAfAJuMb2MpoaZWf4tcgdcg7wGUsUu9r
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2026 11:27:55.0211
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ca6f5af0-1715-443f-28f1-08def476ecea
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF000001A9.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR08MB10747

Now that there is support for GICv5 SPIs in KVM, update
vgic_irqfd_set_irq() to translate irqchip pins into GICv5 SPI IntIDs
before injecting them.

Validate IRQCHIP route pins against the GIC model. GICv2 and GICv3
only support 988 pins for SPIs 32 through 1019, while KVM supports up
to 1024 GICv5 SPI pins. The common routing table is sized for the
largest supported range.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-irqfd.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-irqfd.c b/arch/arm64/kvm/vgic/vgic-ir=
qfd.c
index 19a1094536e6a..ee1a1b214f03c 100644
--- a/arch/arm64/kvm/vgic/vgic-irqfd.c
+++ b/arch/arm64/kvm/vgic/vgic-irqfd.c
@@ -19,9 +19,14 @@ static int vgic_irqfd_set_irq(struct kvm_kernel_irq_rout=
ing_entry *e,
 			struct kvm *kvm, int irq_source_id,
 			int level, bool line_status)
 {
-	unsigned int spi_id =3D e->irqchip.pin + VGIC_NR_PRIVATE_IRQS;
+	unsigned int spi_id;
 	int ret;
=20
+	if (kvm->arch.vgic.vgic_model =3D=3D KVM_DEV_TYPE_ARM_VGIC_V5)
+		spi_id =3D vgic_v5_make_spi(e->irqchip.pin);
+	else
+		spi_id =3D e->irqchip.pin + VGIC_NR_PRIVATE_IRQS;
+
 	if (!vgic_valid_spi(kvm, spi_id))
 		return -EINVAL;
=20
@@ -45,6 +50,13 @@ int kvm_set_routing_entry(struct kvm *kvm,
 			  struct kvm_kernel_irq_routing_entry *e,
 			  const struct kvm_irq_routing_entry *ue)
 {
+	/*
+	 * The common routing table reserves enough entries for all GICv5 SPI
+	 * pins. KVM limits GICv5 to 1024 SPI pins, while GICv2 and GICv3
+	 * only support SPIs 32..1019, leaving 988 pins.
+	 */
+	unsigned int max_irqchip_pins =3D vgic_is_v5(kvm) ?
+		VGIC_V5_MAX_NR_SPIS : VGIC_MAX_SPI - VGIC_NR_PRIVATE_IRQS + 1;
 	int r =3D -EINVAL;
=20
 	switch (ue->type) {
@@ -52,8 +64,8 @@ int kvm_set_routing_entry(struct kvm *kvm,
 		e->set =3D vgic_irqfd_set_irq;
 		e->irqchip.irqchip =3D ue->u.irqchip.irqchip;
 		e->irqchip.pin =3D ue->u.irqchip.pin;
-		if ((e->irqchip.pin >=3D KVM_IRQCHIP_NUM_PINS) ||
-		    (e->irqchip.irqchip >=3D KVM_NR_IRQCHIPS))
+		if (e->irqchip.pin >=3D max_irqchip_pins ||
+		    e->irqchip.irqchip >=3D KVM_NR_IRQCHIPS)
 			goto out;
 		break;
 	case KVM_IRQ_ROUTING_MSI:
--=20
2.34.1
