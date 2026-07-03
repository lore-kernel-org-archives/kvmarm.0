Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013010.outbound.protection.outlook.com [40.107.159.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36B5D2566F7
	for <kvmarm@lists.linux.dev>; Fri,  3 Jul 2026 15:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.10
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783094361; cv=fail; b=cvDF8wEg/nMlwGI1wHNgnZLYdbBRS7s4a9Ayal2b4JQ8UoKtecrLXEKyItFXzktMy7zohBV14jNfUcVruRbRy7+oaN7xqnzpQ6NueEUy86N6pwgmeBfl3g6ya7iMkFJw/FVHVNKVhbltCLzuPWx78KzagXgdrXVLk/7DhkrR3bY=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783094361; c=relaxed/simple;
	bh=BKBHXSFyVFHa+VBeOZLBglZD9wtmZIbZkUMjrEv73XY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=mqgn9FE/xa6wSow9W/+foiNg7yW+yG2u47o/A6ZzthmeBOZq75Cu4DPo9+0W9OfR/lCWUmv4olULoTx9RBDsKuOcp9+uyHOpppCPkuccVlutyxVt+VsL9HJlGCr1qy0Xs+dhP6ZQw+oX3fGvA7/3nx7E/OmYK0ctIw+iOLFH4OA=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Wex7d9dX; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Wex7d9dX; arc=fail smtp.client-ip=40.107.159.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Wex7d9dX";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Wex7d9dX"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=HgvJxf5sT28a7rdkpEvsBzvh+IO/j9aAz8561K0TOtei5nMBbDfnGK/AUPSqWk0rRxWk0O4+A5z0AwkTjIkLaWE/h/PsMJEqjEBuVeorYl1RF2nIIcWTgL+uw/DyV7s0TH146l15u+d4EqMK85Uq2/N+VlVAsm1QldJuom0vbEHuWJ+yJ3bE4dzVTOtsliV3E+16JAIhXp+kpQK/Bih0NiMVCAOgMLhlnpokh5UQNLb/E7MyVGLiXWSd1Eh2L+mgfNWqN1mk6Z+GcT5ZCefLvsAcKKoO55fp6L2UBCwvzCKBp1NoCEY9rxcPWpAIDfz9HByWYFUvk4pAmGD/YTj0RQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VL+np5loKXyF2tcF+SeMPrMKEXCrQtnj9MdnDY1G8x4=;
 b=un0kwE+TFj1Brsx9THlgIP82/QuLhtEk1rt/OmMt8gpW6YELNCbx8S+Kk7zYjXtsAlbu9UEnu7ZLaXxdorAKSmpuVK8yN4z1KgTuhNA4cQiBHlsvL0sfCyGBEkkLzqK+tCGD21wiW44w7h0cXr3ZvqXC/edwJ2It1XXnNHFrHlDJvS0KjzQRTnpS0oxnH1dZmf46kHgZiIWivsFTbjfC4+ptLJRGhQskfhJluTKy+UnT4fwgBdrQgPhm3aGqO2aX6a30an4beW4LGZXnzMp7bpzf9kPlv4A3TPJ3YbVlStkKJMq/3rZBklYaq9TxRAikYSJnjAqLlZqqqBRkRXcO2Q==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VL+np5loKXyF2tcF+SeMPrMKEXCrQtnj9MdnDY1G8x4=;
 b=Wex7d9dXXM8okAXqJdwLngJdoHo2gMR5pLyQY1025BWP3h7D3G1QqGcoRD+Px6lOFMQs5ls/JMhj9jQX2OHOdmm5nplLRec8CYVmiI5Bb+/8YwVT+CPQ9EE2rIPtk2h7Qw4lE10Y+aUrhoN8KJBCv3BgjJI5bmO90l+y2dQ1AFk=
Received: from DUZPR01CA0123.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4bc::8) by AMBPR08MB11592.eurprd08.prod.outlook.com
 (2603:10a6:20b:6f7::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.11; Fri, 3 Jul
 2026 15:59:14 +0000
Received: from DB1PEPF000509E3.eurprd03.prod.outlook.com
 (2603:10a6:10:4bc:cafe::97) by DUZPR01CA0123.outlook.office365.com
 (2603:10a6:10:4bc::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.11 via Frontend Transport; Fri, 3
 Jul 2026 15:59:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509E3.mail.protection.outlook.com (10.167.242.53) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.6
 via Frontend Transport; Fri, 3 Jul 2026 15:59:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kTrVjER7g6j26o3RSknwB0F+Z1uHgW8AGPNdL1yB1YrakaEwvdGR7baK1vdTc60Q/7LfA1Hh3Q820qCI/pS70K5YRskZg8K7m6O5q20J32neGVUgKG93tqrJKBSj5DbACvKDZFy/+3XDATNWVna9Ag31myecSD/VNyDVVYwDce9UjeTfZmPr2I4gaQ53tB5RdM3em6ods8CN5QghvorkzpRV7JvpBLc2hM5y0fsMA4v1e0z8HsOHP+1q9RgkKkB5e5hBb4HHyBEFvrVP4tA4ReneQPXhZxY6nmEkWxjQGa9UOuHNpwHDb/ZKVyooE0YjarJDTbUEhiYl40XCxsOA0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VL+np5loKXyF2tcF+SeMPrMKEXCrQtnj9MdnDY1G8x4=;
 b=vOcpjt209jsLYTTV1KqqyhA68q2hLMraaPCrs6JFnlx/wfHMsQcQZc1Rxck6ff+oPLDhh1nesxNQpW5TYWtdLjhblEDmkmOLfva4tudzHQuVmGEilLpv2VaXrRJWNGf31Q6uT+OoNWzCHg0DnvaCu++CHUxRxhN41cgIX++8Hg2LoimAEsOIzken1E4wEqNV1gTD2xqRd5ofaHE8qk95ejYzAmBDSQmPk/YPAWQwFLhm6OMa02I1zq3hdHd8xak8/rB+diJ2jhB7Yy7eWD8ei5yHIi5bjRip+nySCJGI/M67zYtqdiTiie+8oZ19Au+u/GPleHgPVosb0nrE+io4Hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VL+np5loKXyF2tcF+SeMPrMKEXCrQtnj9MdnDY1G8x4=;
 b=Wex7d9dXXM8okAXqJdwLngJdoHo2gMR5pLyQY1025BWP3h7D3G1QqGcoRD+Px6lOFMQs5ls/JMhj9jQX2OHOdmm5nplLRec8CYVmiI5Bb+/8YwVT+CPQ9EE2rIPtk2h7Qw4lE10Y+aUrhoN8KJBCv3BgjJI5bmO90l+y2dQ1AFk=
Received: from DU2PR08MB7310.eurprd08.prod.outlook.com (2603:10a6:10:2e5::5)
 by GV4PR08MB11250.eurprd08.prod.outlook.com (2603:10a6:150:2e9::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.11; Fri, 3 Jul
 2026 15:58:11 +0000
Received: from DU2PR08MB7310.eurprd08.prod.outlook.com
 ([fe80::e007:b494:8a24:1fc0]) by DU2PR08MB7310.eurprd08.prod.outlook.com
 ([fe80::e007:b494:8a24:1fc0%4]) with mapi id 15.21.0181.009; Fri, 3 Jul 2026
 15:58:11 +0000
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
Subject: [PATCH v3 15/40] KVM: arm64: gic-v5: Add resident/non-resident hyp
 calls
Thread-Topic: [PATCH v3 15/40] KVM: arm64: gic-v5: Add resident/non-resident
 hyp calls
Thread-Index: AQHdCwS/aZ9ROluC50yBBGsizpyEhA==
Date: Fri, 3 Jul 2026 15:58:11 +0000
Message-ID: <20260703154811.3355680-16-sascha.bischoff@arm.com>
References: <20260703154811.3355680-1-sascha.bischoff@arm.com>
In-Reply-To: <20260703154811.3355680-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU2PR08MB7310:EE_|GV4PR08MB11250:EE_|DB1PEPF000509E3:EE_|AMBPR08MB11592:EE_
X-MS-Office365-Filtering-Correlation-Id: 16869b90-c802-4414-800b-08ded91c0769
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|23010399003|376014|366016|1800799024|38070700021|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 SkFXUMs7iA+Ao4Poy+0GNQO7739PBzEErDThN1mKIFNuuPuU4DLbPwuISx2fwc2rlOZZlVCV2gfweZY9zihwthrcZy6sVH9rQoS52OkhTq87vpNeb+rppPsqXqAbeXNPL1Xx5tSCVNjKI3kUyChRwY4bOcdKDHNfowBXsagEIEehsIPaRtQGYGfvHOtwZePWY0//8TQU076zmuKwS2QXYSP4mkji6SHWtFoD1vw2G4TSgCj0HD4yoMYeeWVfD90gzTnTs95zBCiIh8G+bgqEykufwoe9Q1NiCx945ZeM9XHNXx9sbUR9FP4bhBuJn6Tz1aX1YdbXlCHKb2QdJEtIk9A7k/Z37CGoNVJFOmOuwpPgBEVyMNMoYgrPeAIwIfMzwsoQV4jI+smeIxh8Ss8pac3Bt9qJ5P014YZTR6dt60zSTZTKU3mQOtpd/Qmx7SRiiKvN73gavJY4GktleaGZ2L7nWgqySD/vm8g8j1z9TTc0GOOKnnlKqAarRdIWtleLs2CdV05Ozxwg/X9Xd95S4aU5BygAIl36WQHzv5wI2cxD6wNs8wRWEKB29yB9rLhmDxDmpIWYAsrEfr64G220wz1tafFoF7hsoCk8cehri+5wO41ll0PzwZUvYtbq5tvdPGUxo0qcVVEZrnLDCpcCO9cAxHq0IpAPywUZirIc3bnS2UJNCiQqshU4n4gX/HMI+L7a9imHW7+RuD1nvD2EFRrMXYkPTDTfeBgeKu8g8Z4=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU2PR08MB7310.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(1800799024)(38070700021)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 fuS6EQf3TQskD+/A9ssnLZ8GuhN14C1n491+9UDxEkQLAR/tOMH6BG2k2MMFhL2TWW0nSjybdEpgBnT6oUJwi7NAHjnQNzTwEvX10q5+/abHf/fhvEb/Gtjqf/nBgsDOENAPisaUuICDYpHLg02BkqoV5/VSgmVX6nUHFK+VxOWc5XfA8Elfa0b8ggYqulnMR0VK0AwF3jbzbAQ2OZWuULlcTioS7cJVVl91pGfDFLS+QqI9O6cC1MSOHHVfwjIrBUKXjF7diJ1N+L9Qdgozsfi0GGrFJVngA6bHaxF1Th7bb97sxyQWIUoKojTG5mAalgnNDod9lSldcDshBiEvdg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV4PR08MB11250
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509E3.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	21d8e1bc-1674-4929-1980-08ded91be1ea
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|14060799003|82310400026|35042699022|1800799024|36860700016|376014|18002099003|22082099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	Z0GMfrk8erQ+PURvGcf+mSbqVKPqVZePaaclQ3ICFfkCeq3GOCWPFzw1NhKiJBnGuohOay7AmLg9nNyBSfmVYZQ2CihKW8oWDEkWEevUWhXEvqCIcAkbU9DlD+xebpaa0Zvyw+Ya8kB3sUBedI7muTZ9AZjwIXgKco21lQ5UbbS9YfWTnXK9LcSt7MLpWPUgSlabnEUUWKWUDSrgiUpblYb+qlnLRsANweNiTSRwDP8fV2rlOUCgynQrrk7aQCO6RPRGRDxdXosDxWw9uZIQ0lgFJ+YkC3XWSqx8kL+iDnZYeiaiUMHozs6JTR8kncD/F4yIlT4WGgUZm+IbEMBJx0xd8JsM9knSwJPVUdfzNX8BD3HPa0wx+emQOUE+/hhTwiU6SeQSUSLgtJP6RMfNitEFKw21qMqei8+efDof+h2P9AIm+f1c9QV4drPHsLE93/LwC7k/rtPPGE8FYrnBmJB7uxryTgFhZ9xW39rMPSpClN9yNTA1benjlBEFMOt4tSYx6I+6ivE0vwuxB7xKr/daO3nGa6OibRV3VjcWCyMn7qAfbeuaBeXMTmjLkJF3sVFfKT58I2XfSsnAS9GMVyCVf0vjRnPCGFTeD79/hteUsfxeDgB7ej5uiUhAxdWM8ilafhUylF3UMHv8RqA0gTqFBkQobJx5QdA9MhJqN5+vZXyVJ402qj22D9V2bC36rE5ToP9hjlFr9tpYXHRxSg==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(14060799003)(82310400026)(35042699022)(1800799024)(36860700016)(376014)(18002099003)(22082099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	t26lk68KUIcMM9ac6/86CpJ0/8hN5tvQCb1ntFy2sccwRXouOdBi4Sk4xP+ZTJT48hx/SpU6SH7n8R9Lt88KuBUK5XZOV1JGCPnXV1esClYYqB1NfGswHZDlAztVevrNJaMdVz3gl3opfhjBPtSYuLwtyH2IgOiB8zu5Zl32E//GeQZGUkfiBcBrxHT48rnjALa3J+PdCeINmqABY/I54uu5UObcQ6lKKnsJ72weg67zRMgY/lQdi/VW/xw5jXFgdh5a/OzcjDvUmDZCb/eN/8jEHgD6h5YzXGGeXXaV/4N6IVOYbonPKskZ8BMWMaciACsAT9hRpEvJhPZ2pBlI/sg6uwOfbyocYJ/x3gS0uZTkkwbcdFceK2GB0/Rswn4OIsIqqJFZiibpeRUQKTT0fX5pPlqtF0X9vELFX6d5tQyp/HiTs/RWhn6rkuFm2mpJ
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2026 15:59:13.8804
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 16869b90-c802-4414-800b-08ded91c0769
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509E3.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AMBPR08MB11592

GICv5 introduces the concept of VPE residency - a VPE can be either
resident or non-resident. When the VPE is resident, the IRS is allowed
to select interrupts that target that VPE (or the VM) as the HPPI
(Highest Priority Pending Interrupt). As the IRS handles both SPIs and
LPIs, these will only be picked as the IRS's HPPI when a VPE is
resident.

A GICv5 VPE is made resident by writing ICH_CONTEXTR_EL2 with
ICH_CONTEXTR_EL2.V set, together with valid VM and VPE IDs. This
informs the IRS that a specific VPE is running, and that it can begin
HPPI selection for that VPE. Making a VPE non-resident (by making the
ICH_CONTEXTR_EL2 invalid) informs the IRS that the VPE is no longer
running, and it stops HPPI selection for it.

This change introduces two new hyp calls - one to make a VPE resident
and its counterpart to make a VPE non-resident. As part of making a
VPE resident, the resulting ICH_CONTEXTR_EL2.F bit is checked to catch
residency faults. Such a fault indicates a broken VM/VPE setup, so
warn and mark the VM dead.

Furthermore, this change extends vgic_v5_load() and vgic_v5_put() to
make the VPEs resident and non-resident, respectively. Hence, the VPE
is considered resident for the entire load-to-put interval.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/include/asm/kvm_asm.h   |  2 ++
 arch/arm64/include/asm/kvm_hyp.h   |  2 ++
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 16 ++++++++++++++++
 arch/arm64/kvm/hyp/vgic-v5-sr.c    | 26 ++++++++++++++++++++++++++
 arch/arm64/kvm/vgic/vgic-v5.c      | 16 ++++++++++++++--
 include/kvm/arm_vgic.h             |  3 +++
 6 files changed, 63 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_=
asm.h
index 043495f7fc78b..d9ff9c2999aa7 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -87,6 +87,8 @@ enum __kvm_host_smccc_func {
 	__KVM_HOST_SMCCC_FUNC___tracing_write_event,
 	__KVM_HOST_SMCCC_FUNC___vgic_v3_save_aprs,
 	__KVM_HOST_SMCCC_FUNC___vgic_v3_restore_vmcr_aprs,
+	__KVM_HOST_SMCCC_FUNC___vgic_v5_make_resident,
+	__KVM_HOST_SMCCC_FUNC___vgic_v5_make_non_resident,
 	__KVM_HOST_SMCCC_FUNC___vgic_v5_save_apr,
 	__KVM_HOST_SMCCC_FUNC___vgic_v5_restore_vmcr_apr,
=20
diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_=
hyp.h
index 4974492744cc8..8fcbbff719cce 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -88,6 +88,8 @@ void __vgic_v3_restore_vmcr_aprs(struct vgic_v3_cpu_if *c=
pu_if);
 int __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu);
=20
 /* GICv5 */
+void __vgic_v5_make_resident(struct vgic_v5_cpu_if *cpu_if);
+void __vgic_v5_make_non_resident(struct vgic_v5_cpu_if *cpu_if);
 void __vgic_v5_save_apr(struct vgic_v5_cpu_if *cpu_if);
 void __vgic_v5_restore_vmcr_apr(struct vgic_v5_cpu_if *cpu_if);
 /* No hypercalls for the following */
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/h=
yp-main.c
index d3c69de698f48..09756f71df08e 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -691,6 +691,20 @@ static void handle___tracing_write_event(struct kvm_cp=
u_context *host_ctxt)
 	trace_selftest(id);
 }
=20
+static void handle___vgic_v5_make_resident(struct kvm_cpu_context *host_ct=
xt)
+{
+	DECLARE_REG(struct vgic_v5_cpu_if *, cpu_if, host_ctxt, 1);
+
+	__vgic_v5_make_resident(kern_hyp_va(cpu_if));
+}
+
+static void handle___vgic_v5_make_non_resident(struct kvm_cpu_context *hos=
t_ctxt)
+{
+	DECLARE_REG(struct vgic_v5_cpu_if *, cpu_if, host_ctxt, 1);
+
+	__vgic_v5_make_non_resident(kern_hyp_va(cpu_if));
+}
+
 static void handle___vgic_v5_save_apr(struct kvm_cpu_context *host_ctxt)
 {
 	DECLARE_REG(struct vgic_v5_cpu_if *, cpu_if, host_ctxt, 1);
@@ -738,6 +752,8 @@ static const hcall_t host_hcall[] =3D {
 	HANDLE_FUNC(__tracing_write_event),
 	HANDLE_FUNC(__vgic_v3_save_aprs),
 	HANDLE_FUNC(__vgic_v3_restore_vmcr_aprs),
+	HANDLE_FUNC(__vgic_v5_make_resident),
+	HANDLE_FUNC(__vgic_v5_make_non_resident),
 	HANDLE_FUNC(__vgic_v5_save_apr),
 	HANDLE_FUNC(__vgic_v5_restore_vmcr_apr),
=20
diff --git a/arch/arm64/kvm/hyp/vgic-v5-sr.c b/arch/arm64/kvm/hyp/vgic-v5-s=
r.c
index 6d69dfe89a96c..f064045a31aee 100644
--- a/arch/arm64/kvm/hyp/vgic-v5-sr.c
+++ b/arch/arm64/kvm/hyp/vgic-v5-sr.c
@@ -7,6 +7,32 @@
=20
 #include <asm/kvm_hyp.h>
=20
+void __vgic_v5_make_resident(struct vgic_v5_cpu_if *cpu_if)
+{
+	write_sysreg_s(cpu_if->vgic_contextr, SYS_ICH_CONTEXTR_EL2);
+	isb();
+
+	/* Catch any faults */
+	cpu_if->vgic_contextr =3D read_sysreg_s(SYS_ICH_CONTEXTR_EL2);
+	if (!!FIELD_GET(ICH_CONTEXTR_EL2_F, cpu_if->vgic_contextr))
+		return;
+
+	cpu_if->gicv5_vpe.resident =3D true;
+}
+
+void __vgic_v5_make_non_resident(struct vgic_v5_cpu_if *cpu_if)
+{
+	/*
+	 * Make as non-resident before actually making non-resident. Avoids race
+	 * with doorbell arriving.
+	 */
+	cpu_if->gicv5_vpe.resident =3D false;
+	dsb(st);
+
+	write_sysreg_s(cpu_if->vgic_contextr, SYS_ICH_CONTEXTR_EL2);
+	isb();
+}
+
 void __vgic_v5_save_apr(struct vgic_v5_cpu_if *cpu_if)
 {
 	cpu_if->vgic_apr =3D read_sysreg_s(SYS_ICH_APR_EL2);
diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index f1cc36696669d..9c383b6864270 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -1053,6 +1053,8 @@ void vgic_v5_flush_ppi_state(struct kvm_vcpu *vcpu)
 void vgic_v5_load(struct kvm_vcpu *vcpu)
 {
 	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+	u16 vm =3D vgic_v5_vm_id(vcpu->kvm);
+	u16 vpe =3D vgic_v5_vpe_id(vcpu);
=20
 	/*
 	 * On the WFI path, vgic_load is called a second time. The first is when
@@ -1065,7 +1067,15 @@ void vgic_v5_load(struct kvm_vcpu *vcpu)
=20
 	kvm_call_hyp(__vgic_v5_restore_vmcr_apr, cpu_if);
=20
-	cpu_if->gicv5_vpe.resident =3D true;
+	cpu_if->vgic_contextr =3D FIELD_PREP(ICH_CONTEXTR_EL2_V, true) |
+				FIELD_PREP(ICH_CONTEXTR_EL2_VPE, vpe) |
+				FIELD_PREP(ICH_CONTEXTR_EL2_VM, vm);
+
+	kvm_call_hyp(__vgic_v5_make_resident, cpu_if);
+
+	/* Failed to make the VPE resident? Bang! */
+	if (WARN_ON(!!FIELD_GET(ICH_CONTEXTR_EL2_F, cpu_if->vgic_contextr)))
+		kvm_vm_dead(vcpu->kvm);
 }
=20
 void vgic_v5_put(struct kvm_vcpu *vcpu)
@@ -1083,7 +1093,9 @@ void vgic_v5_put(struct kvm_vcpu *vcpu)
=20
 	kvm_call_hyp(__vgic_v5_save_apr, cpu_if);
=20
-	cpu_if->gicv5_vpe.resident =3D false;
+	cpu_if->vgic_contextr =3D 0;
+
+	kvm_call_hyp(__vgic_v5_make_non_resident, cpu_if);
=20
 	/* The shadow priority is only updated on entering WFI */
 	if (vcpu_get_flag(vcpu, IN_WFI))
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 6f736094a0e7e..faecde764fea3 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -536,6 +536,9 @@ struct vgic_v5_cpu_if {
 	 */
 	u64	vgic_icsr;
=20
+	/* The contextr used to make VPEs resident and non-resident */
+	u64	vgic_contextr;
+
 	struct gicv5_vpe gicv5_vpe;
 };
=20
--=20
2.34.1
