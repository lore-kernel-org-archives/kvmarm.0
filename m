Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013026.outbound.protection.outlook.com [40.107.162.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39E3733BBBA
	for <kvmarm@lists.linux.dev>; Thu, 21 May 2026 14:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.26
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779375185; cv=fail; b=T/ZIgC4HLJITffpnpnrfvj6dAVuQgtWYzAEB0aWKBu3su5sk1apmwz5J4uwyhJ0PX/2dNNtVPNHa0U0VrMmiekmita2ckPM/8uzq18FgWaAZ1p6jSF9Oq/iwiyzxGLnv4m9K1ZLVvH7kq/3ve3hhhyJhVOcaBuxvpJlRNaUwzAs=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779375185; c=relaxed/simple;
	bh=3voZdAzQjE8levwf+1RgDd3RH4G8Y6K9jpjetsE2sD4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=dEpQ0CIhysmDOvQvLPc0JaKO+xCringFqpsjvdphk8VL9nzYHNiHrzWfyVA1fEdGG/tsZJs/ntqAVIAKt0jhmJK1Y8nXwRWy/gw5bkhRCPXmfJkJNGRRKlxp9DXGm4Fs41wo+Lj93ND3UUZ7XPj0ltnZ9sEHQ0xJdUCD8PXxYFk=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=W10zsSLU; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=W10zsSLU; arc=fail smtp.client-ip=40.107.162.26
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="W10zsSLU";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="W10zsSLU"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=fail;
 b=CIMgAHcptyJ/zK5HKvlJcfWmJW83x6ETH8he05ekRk1BNGkS4WRbCl+xBwAl9ocF7auqecRCZQjhjynxan1VpHTTXAsrVpNEoIrYbd/tm9aEYeLaclschRbPFis8goFe1B/DK0tN3TU8DqvaObO6RmNvh8LfGl0tGtDdonYliVumW4UE6oU24VtiuMbiv0Uxtvj/7XHl5PBibtKZYah02w5YOHKkUjziDOeasbbZvwJtOeNgbPGhxwNHIRhKNxFVT8+p4KehDVlipCDhrxfFHM/50zKuAV/J1Qu8tKxQ89FqvYW9uS2aLxK53MaillTdMKYJreL5rzeQGL2BP0HDeA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G735tGlS/pjFy0kb1NHLtBv6/JPijeFfEFPdUZAyBzk=;
 b=ijkUzTTAwFw69NB5sDFqouadHM5fd36u/RHb5GDs2lEKEaQxoXFj7wk+H8TyHigRfbf4j7Nrq4Ic/tV9eWGOhoPJ+ZHju6yDHy49qItN9zaaoPDSs+Yvo359HGL/aVQpIMGm+TsN8qD/A+bdzzP7Sce5z08qx3VLuRvoL2Rsf5dap+q4fg33fbjSTco/S6XLJCTd3iiNDgXfCPAb0tk5Apy3KkAt536RBK1ePQlISYhNZ4U9GVPB+jxFoSDWBPoeR2cDtqrupYPs8aggVfqKbwbzapqfCN0zJzD2o4uISEtK7AkYYPpytKKdfS7qT8SJYR4EBouRaNUT4FPXWRQZrA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=fail (48)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G735tGlS/pjFy0kb1NHLtBv6/JPijeFfEFPdUZAyBzk=;
 b=W10zsSLUGwUB7G8Q/TaDvCExIq2axxIvrwlyeROKrip0fzaVa79mRgmJ+ZLaOKk5qCOhJ3nxbGzVSPjvW8KS4C2UX240I+y/btsCUSkfJD4GaAwlmkFtEmfnCntCEvCcYEgESlpVk2dEaGibry5slNtAF/SWSP82IJBYkF52tiU=
Received: from DU2PR04CA0202.eurprd04.prod.outlook.com (2603:10a6:10:28d::27)
 by DBBPR08MB10553.eurprd08.prod.outlook.com (2603:10a6:10:52e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.14; Thu, 21 May
 2026 14:52:56 +0000
Received: from DB5PEPF00014B9D.eurprd02.prod.outlook.com
 (2603:10a6:10:28d:cafe::91) by DU2PR04CA0202.outlook.office365.com
 (2603:10a6:10:28d::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.48.17 via Frontend Transport; Thu, 21
 May 2026 14:52:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB5PEPF00014B9D.mail.protection.outlook.com (10.167.8.164) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.71.7 via
 Frontend Transport; Thu, 21 May 2026 14:52:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JHpW4QJxVc+d5tcgy+jYk2/pvoEBpcyV6m6OeafEiDgul0KQVbflDD/WohzHIRRPfw+x0foOiVNVynugMASsJDM/bohMtiEfNDLofxFprDGtGRxXcAhhFlqK+7IE3Tnmpj7T+CW5pjUqJEkKqAIvpBCNIW4ju68muZ0Ye/nHJFmkviV49T7YPRW6RrwISVoyad3CQ1SJj2Acg1V0qzuXN0jQrZ9PyvQmNtNbGk8dbBzryYfTnS+bZLaq6vqHQmChO2sHvqfHozEwSC+Y5o9WFjRldFBl6dBeyi5/OtcFNLvne4Y3cd27xuqhOtUXOUz421Ffit5gd1PfsoKs0+UCDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G735tGlS/pjFy0kb1NHLtBv6/JPijeFfEFPdUZAyBzk=;
 b=TYAtkdz/CVtjz8tsjRgz4i832n+Fi+DdzUTpMsXCHUzwawl2M1mGMtKuqXULlYHjbanxY4hNm/cplaT5vgBDvFhr4zDaK1kH5O96zWiPDpSBgMecfzZX86sTyxXWDfhFnd8TFfWtnpU/wQj/6X3vHFH8rcWOiA0O+4p9pOxffHxzJABxnc00TEw9v5XKI7Tg7ObPFzFnJnD1psXQLK5h19SkTAZtHKjdfLtf5W5Zv2ieAiHAih2eRB1R0eeWVaBo/5rf4IVSjqNaiXQ3Me94XIbTHkjx8Kltj/rwPXGs1/3DqiWguaSQGR0lgqh2Z38Au1zBHgrMfsWeHzHtKJdNgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G735tGlS/pjFy0kb1NHLtBv6/JPijeFfEFPdUZAyBzk=;
 b=W10zsSLUGwUB7G8Q/TaDvCExIq2axxIvrwlyeROKrip0fzaVa79mRgmJ+ZLaOKk5qCOhJ3nxbGzVSPjvW8KS4C2UX240I+y/btsCUSkfJD4GaAwlmkFtEmfnCntCEvCcYEgESlpVk2dEaGibry5slNtAF/SWSP82IJBYkF52tiU=
Received: from GV1PR08MB7315.eurprd08.prod.outlook.com (2603:10a6:150:1e::15)
 by VE1PR08MB5856.eurprd08.prod.outlook.com (2603:10a6:800:1ab::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.17; Thu, 21 May
 2026 14:51:52 +0000
Received: from GV1PR08MB7315.eurprd08.prod.outlook.com
 ([fe80::c249:1aed:a4c2:4193]) by GV1PR08MB7315.eurprd08.prod.outlook.com
 ([fe80::c249:1aed:a4c2:4193%3]) with mapi id 15.21.0048.013; Thu, 21 May 2026
 14:51:52 +0000
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
Subject: [PATCH v2 08/39] KVM: arm64: gic-v5: Add VPE doorbell domain
Thread-Topic: [PATCH v2 08/39] KVM: arm64: gic-v5: Add VPE doorbell domain
Thread-Index: AQHc6TFcdXyX6oMacE+MkK+Olvm5vg==
Date: Thu, 21 May 2026 14:51:52 +0000
Message-ID: <20260521144846.1899475-9-sascha.bischoff@arm.com>
References: <20260521144846.1899475-1-sascha.bischoff@arm.com>
In-Reply-To: <20260521144846.1899475-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	GV1PR08MB7315:EE_|VE1PR08MB5856:EE_|DB5PEPF00014B9D:EE_|DBBPR08MB10553:EE_
X-MS-Office365-Filtering-Correlation-Id: 4c699b02-6958-4866-93a2-08deb748a482
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|38070700021|56012099003|18002099003|22082099003|11063799006|6133799003|3023799007;
X-Microsoft-Antispam-Message-Info-Original:
 a2hy7A7Ol9kyBzibxYEJ7kC8J+96vdXKEmrN86EAUz6smHvokYunOeBVxRXmcOQxxaeyxiVYWyAfDK3K9DV+zj924OE5G+Vo3Ez6ETScOLS0h82NOslds3UZ8aAscXpBkKVKOuc1Jq4bpZPWPT2IyFgXKzHN8I3yI2f/GFwrIGzt9kqXwdtXiOdJQjypfXxg18PXgLN5pHRtMSuQMLGRMZFUYPoa+M6MMvDWGC5KpX8/F5cYfo+4B/ctJxhieMnCkdD3BVTu/CnxweNRY9q2xekPFlnWS5FABZmMqKDUI/HJA95+V76M8irD4rO5Kuu/68HCAixOaZJB9uEUog74XfLedo0V5TGanBFXPlHEFtDHcLWSsfGzser/+qhqS2WXPp7KBKR1bRAeMqmwQ6fF1nNdkuh/Kz9+TmrUhnMBv9q6zZUKDvsN1m6R8SgumWLRwIW20H5o0MXVg5K2Al2YMZUhpQejtkgRgdlM3Yz3bKczbSz6om4k0B6o20etqDuIzhs8aaXzdldV3zzuGrQIdJzTHnkIVXuWriDCtZ0qfSXzeallolUwPBpGwvqphTe3qIITHwoyoBcgw3WvHQDST4Ro5IZxr6jWukmfQ3Dj2D7W/GZpiqhXAPag+3bSjz9+/NS/U9yeu5+um7YI1xf4Kc0wsZ2ac2XX4S9CV8zigtMyhH+9CcnrTFD+KdDlDsZptnXmHgcGHxsAq+7WYakUbY3O7880Bi6Alp2tUYxm/IsC/+rjOCS2Pf5pl0cTSQuW
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB7315.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700021)(56012099003)(18002099003)(22082099003)(11063799006)(6133799003)(3023799007);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 OcOxYMKPqlDQdU9eGJNsLIEcuV1uLLH43fS6G7xkoNNaU4k7LJVDnrosDzuxBy/38OSQg9skjqrpMvdqMD2/EA5Dn+OSn300TERaRHPSRR2J4kRxhYBw8+wkYKhcO9KKG+3c3NlqLhHDrRw+FfmCLnSHQxU03AiSHMwqS2/bbgPj+/Txswf4LoglYtdmPq6hWe7PGM55vARLq1W+jUG4fAP1/ZdYycInueeU9TiEqMw/KsUmdqj1a0//NMcgzhE/MlJEE4clm2GsNzz/eE3IdGOO5yov5S7ExJOXeUepCW1UUzEuklZ/N3FciAFAbFnuvZFROc/VLWeCDMZBqimkIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR08MB5856
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB5PEPF00014B9D.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	1e0f3bbc-c7ed-4aa5-7a53-08deb7487ebf
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|376014|1800799024|82310400026|14060799003|35042699022|18002099003|56012099003|22082099003|11063799006|3023799007|6133799003;
X-Microsoft-Antispam-Message-Info:
	S5AelrjZv3iC9zGyzB4CSrAY95mQTt8xMBo/kI3VbCk04DkGgqiFuz/8fdQ9Z7GmBi1qdv/afQVVivWa8gRfRTeK0WAd84+ftWwYHWYzL/KGAxmzX3qOU2SByBhlqT1isz+b3ADAMfKL6lWOl2fqjAGzAn7b983x8oU4EnYpNslezc4HVQliAlPsgYJ2yVqs9uPlxnhm7BvIDAvMMsUdKOODw6jIsfS/tCWpIoRYMtX41HARQCZDiFpfiee9k8ACtDtb/4VOZ+l7cfzTL70y5lp59d4matwgbafKpXJ7RDqfeSoJVMq+9/HTEb+Ms+nPcXdwGDQTHv0SCJ3TCvU7JXEqeBYQT+ttjdEaV/jajz0gAQSFBpE8ASB3S27Nl8vETm+OQVPnoegfbqdA+bfZHBa2EKW5t/u1A53J3Daa6bXg8NbFH1k+rL0Rg5cFp/oQDuNOkm4Pu5RkpnT8p6DZa66SiwCixRMfm0NgKVXg8By55w1KuIjBwSihoS6tnji1Z7D9mJcjw6oIQBWRUIwtyUHGYhQxiSzWkWqUr02MJnAhjUXa0s2/rpnsPgrR++I/NocMQAQimxQtboA3Hd8q6jsnymcPZNaD+cczx5eb+cC2N6gd98x0ivkSU3vKOxSkCCO3Ioh7qx2DY0nR0ehdHfNWEP7igcSSjh8D6vFTYxskkZzMkJqg6MUHKlLqYyUfYYNqcxxWwzb61vTWuIN+Z/Ty2+cEGhMB2iOJoLf9ITk=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(376014)(1800799024)(82310400026)(14060799003)(35042699022)(18002099003)(56012099003)(22082099003)(11063799006)(3023799007)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	LQxpdLHcJRADsxt8ub2OxgMOJZxM+23X3JWmgURoyJmS88agLKrr3SrroPDMBi2/hUfhPhU0Hu6+atxu6lKCXASu/KXn7aD7RSawx1CHApq3nxAHAmuSBHWfiJ02tMskmqmn0d5Jo3sz10RmBSsQp5UFdk3bvv9dhj7SUCu3033a1/XLJL3UsTLFqj+VK2VZQ/EZk38jtHL1iXLyy8x321ofbWTBePwo0QYiekyKEjNKkZl+eemVSkttKAO9AkYPEVSX2jQOt6farRp0Vv3iEW73BXkGrq+bmpYTXNZvoFtRdKwSaaIVuGW5oWpLAjkLyPlFGn6qMQ+L/7CinAsDj2/sQBlhvPIBe64qfyHgBsMBPnbV8Wf2Mf34klWte7ZgdzHtbHyvc+acEB+/ZjvmbJCoivwNvOMUA0N5KtTE2b3JyhCUkA0wLrhV1aRcHkHN
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2026 14:52:55.7623
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c699b02-6958-4866-93a2-08deb748a482
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB5PEPF00014B9D.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR08MB10553

VPE doorbells allow the GICv5 hardware to notify KVM when an SPI or LPI
can be signalled to a non-resident VPE. This provides the mechanism used
to wake blocked vcpus once the hardware determines that the interrupt is
eligible to be delivered.

Add support for a per-VM VPE doorbell irq domain. The domain is created
under the GICv5 LPI domain, with one doorbell allocated per VPE. Store
the allocated doorbell base in the VM's GICv5 state so that later
patches can request per-vcpu doorbell IRQs and use them for IRS
commands and wakeups.

Add the per-VPE doorbell state to the GICv5 CPU interface state. The
doorbell IRQ number is populated when the IRQs are requested, and the
db_fired state is used by later patches once doorbell delivery is wired
up.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-init.c    |  18 ++--
 arch/arm64/kvm/vgic/vgic-v5.c      | 137 +++++++++++++++++++++++++++++
 arch/arm64/kvm/vgic/vgic.h         |   1 +
 include/kvm/arm_vgic.h             |   4 +
 include/linux/irqchip/arm-gic-v5.h |   2 +
 5 files changed, 156 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-ini=
t.c
index 907057881b26a..625d352756fcf 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -492,16 +492,22 @@ static void kvm_vgic_dist_destroy(struct kvm *kvm)
 	dist->nr_spis =3D 0;
 	dist->vgic_dist_base =3D VGIC_ADDR_UNDEF;
=20
-	if (dist->vgic_model =3D=3D KVM_DEV_TYPE_ARM_VGIC_V3) {
+	switch (dist->vgic_model) {
+	case KVM_DEV_TYPE_ARM_VGIC_V2:
+		dist->vgic_cpu_base =3D VGIC_ADDR_UNDEF;
+		break;
+	case KVM_DEV_TYPE_ARM_VGIC_V3:
 		list_for_each_entry_safe(rdreg, next, &dist->rd_regions, list)
 			vgic_v3_free_redist_region(kvm, rdreg);
 		INIT_LIST_HEAD(&dist->rd_regions);
-	} else {
-		dist->vgic_cpu_base =3D VGIC_ADDR_UNDEF;
-	}
=20
-	if (vgic_supports_direct_irqs(kvm))
-		vgic_v4_teardown(kvm);
+		if (vgic_supports_direct_irqs(kvm))
+			vgic_v4_teardown(kvm);
+		break;
+	case KVM_DEV_TYPE_ARM_VGIC_V5:
+		vgic_v5_teardown(kvm);
+		break;
+	}
=20
 	xa_destroy(&dist->lpi_xa);
 }
diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index 3f7b132110114..52924408ca990 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -7,6 +7,7 @@
=20
 #include <linux/bitops.h>
 #include <linux/irqchip/arm-vgic-info.h>
+#include <linux/irqdomain.h>
=20
 #include "vgic.h"
=20
@@ -152,6 +153,132 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
 	return 0;
 }
=20
+/*
+ * This set of irq_chip functions is specific for doorbells.
+ */
+static const struct irq_chip vgic_v5_db_irq_chip =3D {
+	.name =3D "GICv5-DB",
+	.irq_mask =3D irq_chip_mask_parent,
+	.irq_unmask =3D irq_chip_unmask_parent,
+	.irq_eoi =3D irq_chip_eoi_parent,
+	.irq_set_affinity =3D irq_chip_set_affinity_parent,
+	.irq_get_irqchip_state =3D irq_chip_get_parent_state,
+	.irq_set_irqchip_state =3D irq_chip_set_parent_state,
+	.flags =3D IRQCHIP_SET_TYPE_MASKED | IRQCHIP_SKIP_SET_WAKE |
+		 IRQCHIP_MASK_ON_SUSPEND,
+};
+
+static void vgic_v5_irq_db_domain_free(struct irq_domain *domain,
+				       unsigned int virq, unsigned int nr_irqs)
+{
+	int i;
+
+	for (i =3D 0; i < nr_irqs; i++) {
+		struct irq_data *d =3D irq_domain_get_irq_data(domain, virq + i);
+
+		irq_set_handler(virq + i, NULL);
+		irq_domain_reset_irq_data(d);
+	}
+
+	irq_domain_free_irqs_parent(domain, virq, nr_irqs);
+}
+
+static int vgic_v5_irq_db_domain_alloc(struct irq_domain *domain,
+				       unsigned int virq, unsigned int nr_irqs,
+				       void *arg)
+{
+	const struct irq_chip *chip =3D &vgic_v5_db_irq_chip;
+	struct vgic_v5_vm *vm =3D arg;
+	struct irq_data *irqd;
+	int ret;
+
+	if (!vm) {
+		kvm_err("invalid parameter for doorbell irq allocation\n");
+		return -EINVAL;
+	}
+
+	ret =3D irq_domain_alloc_irqs_parent(domain, virq, nr_irqs, NULL);
+	if (ret)
+		return ret;
+
+	for (int i =3D 0; i < nr_irqs; i++) {
+		irq_domain_set_hwirq_and_chip(domain, virq + i, i, chip,
+					      domain->host_data);
+		irqd =3D irq_desc_get_irq_data(irq_to_desc(virq + i));
+		irqd_set_single_target(irqd);
+	}
+
+	return 0;
+}
+
+static const struct irq_domain_ops vgic_v5_irq_db_domain_ops =3D {
+	.alloc =3D vgic_v5_irq_db_domain_alloc,
+	.free =3D vgic_v5_irq_db_domain_free,
+};
+
+static int vgic_v5_create_per_vm_domain(struct kvm *kvm)
+{
+	struct vgic_v5_vm *vm =3D &kvm->arch.vgic.gicv5_vm;
+	int nr_vcpus =3D atomic_read(&kvm->online_vcpus);
+	int id =3D task_pid_nr(current);
+	int ret, db_virq =3D 0;
+
+	if (!gicv5_global_data.lpi_domain) {
+		kvm_err("LPI domain uninitialized, can't set up KVM Doorbells\n");
+		return -ENODEV;
+	}
+
+	vm->fwnode =3D irq_domain_alloc_named_id_fwnode("GICv5-vpe-db", id);
+
+	/*
+	 * KVM per-VM VPE DB domain; child of LPI domain; only ever handles
+	 * doorbells. We know how many doorbells we have, and therefore we
+	 * create a linear domain.
+	 */
+	vm->domain =3D irq_domain_create_hierarchy(gicv5_global_data.lpi_domain,
+						 0, nr_vcpus, vm->fwnode,
+						 &vgic_v5_irq_db_domain_ops, vm);
+	if (WARN_ON(!vm->domain)) {
+		ret =3D -ENOMEM;
+		goto err;
+	}
+
+	db_virq =3D irq_domain_alloc_irqs(vm->domain, nr_vcpus, NUMA_NO_NODE, vm)=
;
+	if (db_virq <=3D 0) {
+		ret =3D db_virq;
+		goto err;
+	}
+
+	kvm->arch.vgic.gicv5_vm.vpe_db_base =3D db_virq;
+
+	return 0;
+
+err:
+	if (db_virq > 0)
+		irq_domain_free_irqs(db_virq, nr_vcpus);
+	if (vm->domain)
+		irq_domain_remove(vm->domain);
+	if (vm->fwnode)
+		irq_domain_free_fwnode(vm->fwnode);
+
+	kvm->arch.vgic.gicv5_vm.vpe_db_base =3D 0;
+	vm->domain =3D NULL;
+	vm->fwnode =3D NULL;
+
+	return ret;
+}
+
+static void vgic_v5_teardown_per_vm_domain(struct vgic_v5_vm *vm)
+{
+	if (!vm->domain)
+		return;
+
+	irq_domain_remove(vm->domain);
+	irq_domain_free_fwnode(vm->fwnode);
+	vm->domain =3D NULL;
+	vm->fwnode =3D NULL;
+}
+
 void vgic_v5_reset(struct kvm_vcpu *vcpu)
 {
 	/*
@@ -167,10 +294,16 @@ void vgic_v5_reset(struct kvm_vcpu *vcpu)
 	vcpu->arch.vgic_cpu.num_pri_bits =3D 5;
 }
=20
+void vgic_v5_teardown(struct kvm *kvm)
+{
+	vgic_v5_teardown_per_vm_domain(&kvm->arch.vgic.gicv5_vm);
+}
+
 int vgic_v5_init(struct kvm *kvm)
 {
 	struct kvm_vcpu *vcpu;
 	unsigned long idx;
+	int ret;
=20
 	if (vgic_initialized(kvm))
 		return 0;
@@ -182,6 +315,10 @@ int vgic_v5_init(struct kvm *kvm)
 		}
 	}
=20
+	ret =3D vgic_v5_create_per_vm_domain(kvm);
+	if (ret)
+		return ret;
+
 	/* We only allow userspace to drive the SW_PPI, if it is implemented. */
 	bitmap_zero(kvm->arch.vgic.gicv5_vm.userspace_ppis,
 		    VGIC_V5_NR_PRIVATE_IRQS);
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index f45f7e3ec4d6e..f2f5fdc3211d7 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -366,6 +366,7 @@ void vgic_debug_destroy(struct kvm *kvm);
 int vgic_v5_probe(const struct gic_kvm_info *info);
 void vgic_v5_reset(struct kvm_vcpu *vcpu);
 int vgic_v5_init(struct kvm *kvm);
+void vgic_v5_teardown(struct kvm *kvm);
 int vgic_v5_map_resources(struct kvm *kvm);
 void vgic_v5_set_ppi_ops(struct kvm_vcpu *vcpu, u32 vintid);
 bool vgic_v5_has_pending_ppi(struct kvm_vcpu *vcpu);
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 8d65a18fefb80..bff2b7c896d55 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -392,6 +392,10 @@ struct vgic_v5_vm {
 	 * convenient way to do that).
 	 */
 	DECLARE_BITMAP(vgic_ppi_hmr, VGIC_V5_NR_PRIVATE_IRQS);
+
+	struct fwnode_handle	*fwnode;
+	struct irq_domain	*domain;
+	int			vpe_db_base;
 };
=20
 struct vgic_dist {
diff --git a/include/linux/irqchip/arm-gic-v5.h b/include/linux/irqchip/arm=
-gic-v5.h
index dd7da568ee8b8..1702b57527dee 100644
--- a/include/linux/irqchip/arm-gic-v5.h
+++ b/include/linux/irqchip/arm-gic-v5.h
@@ -577,6 +577,8 @@ void gicv5_irs_syncr(void);
=20
 /* Embedded in kvm.arch */
 struct gicv5_vpe {
+	int			db;
+	bool			db_fired;
 	bool			resident;
 };
=20
--=20
2.34.1
