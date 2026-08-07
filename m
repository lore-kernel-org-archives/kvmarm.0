Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013059.outbound.protection.outlook.com [52.101.83.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51EFB34B669
	for <kvmarm@lists.linux.dev>; Fri,  7 Aug 2026 11:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.83.59
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786101778; cv=fail; b=RtJyFF9AZ6Za5NZYQTiKLSVp/ERNrj5CMjUvXTvmZObw//IMswBtA0ZHBxdRHA/QR7W8IjaBm01pMeWCCZx6z2gLWpDvoF+2nsvnIybyDnAGTQMxZgpwcF5uE7wpVx5gMF8RmWuSkUip3C4oxvRYmfBXR+pmcnn/wuBL94tP070=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786101778; c=relaxed/simple;
	bh=cgLTExn/0dTE2MV3XP573SDzRp1xA9leFLgiPJ05S6Q=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=JjqyfgbGdf49exms3RSp7sfWq1cTYPYptR/esY1PzSKslCI5Pf2Y/ol0emogQ2hwiFkFGji2od9W2FblVc1Ge4cDOSYx89CSfRJeAfmkrO94Hgec0OVNsWmz2GRSiEhmIJhqbvHpE1YmsaArBLspmkBQKg7bVKjvBEH5l8FMGs0=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=jtHQ2wp1; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=jtHQ2wp1; arc=fail smtp.client-ip=52.101.83.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="jtHQ2wp1";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="jtHQ2wp1"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=I9ie9wyHbDDPKmxfT2BWvM+F0jZ5LE9PkSGVaI62QEM95EI2Y+w/FNvqhI2oXKw7xWzWqt46mJ1n04TxPPizPS2DT4Rld5kG+zr6NzBbEcLDEBXmdbOX9PSaAd7Awov+Nn8dSppii7G6P8SxUcnsXPZXb3AJXdo7p6MqYhEB3/YltmFIHhwnDxHCcRZarxsR1vNoFZZtTdTJN5XCTB0dQ3AYCZxJ3S6Xdww0SSgckZcXLAkBtIVvIDb0wBOlNM23HQ9h1+uqozHEGzOn/Sr30m4XxBrBuKSPjkF4w1xW+gSOQ8aTzqhL4p5YPlMODOOOC9hpBXmzfzFChzxC9n3RNQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NmWbwSu1taDmixq/EgXIRwL12LNFUjMssL/NHJHTkvY=;
 b=bxhcNDCp5w0zBxV6d6VTcTRqZy8+Ma1jTxCD1dj2iyxnXbOEk6Ab3iiJ5MLNgsKVKlvN7ATdtxxNi6vXM//0BhMgn/qTEn22uCxRXfaTiW5yjwxvasotS8GgvPOsBj1iCxSkH1koas9zdSW6rWlPG7mMH8driLx3c7OSoejJd6F/e9wcOWMnh9HZVYEDh7k/qt+R3Akzu7omuaIwz1RDVUmZqPyhy2E7lo+lfNI2QZKUOFF+8BHiE01a5l4VYyJlnsQi0cbfWNccJ24mtrsgNH7Q27Bdv0HaUoJ2atA81EQZfTy2ndpWBe+ITNwaL2s/5/kvpJ6zPP+xD4A1Z2FLDg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NmWbwSu1taDmixq/EgXIRwL12LNFUjMssL/NHJHTkvY=;
 b=jtHQ2wp1JxuFwhzAKtn+KIDODid8So2jE9Uw+yyFT/KpIDruh3nfUJ1Hkkzd1xwEjAlCsZg/Ozni0nk3TqGbqhw8XWFah1qoS+GK8RPM09e9vdzfdCaf0IiBjgYtKqbCi2UcT49rKTj9+EDdEVSeggOCK6BKk3fH4Ni3UDC1res=
Received: from AM9P192CA0016.EURP192.PROD.OUTLOOK.COM (2603:10a6:20b:21d::21)
 by AM8PR08MB5812.eurprd08.prod.outlook.com (2603:10a6:20b:1d5::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.23; Fri, 7 Aug
 2026 11:22:48 +0000
Received: from AMS1EPF00000044.eurprd04.prod.outlook.com
 (2603:10a6:20b:21d:cafe::98) by AM9P192CA0016.outlook.office365.com
 (2603:10a6:20b:21d::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.23 via Frontend Transport; Fri, 7
 Aug 2026 11:22:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS1EPF00000044.mail.protection.outlook.com (10.167.16.41) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.315.6
 via Frontend Transport; Fri, 7 Aug 2026 11:22:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bVIKsY+le68onAOjRb8AT6KFZUPAaSNwelmm9vyTizFqmqZVYJT8L/w4t2P0QBOozxTyDMTNdv6UHpd1U+rPAyQLwGjVZ4IvsF12yxKhLx4SfHMA0SUkbqMKUL5EB93V3Bv0Rywe8D1sxoSh45uSikhQrkqiapn2ipyAPfDvoWn6v2SY2wkhRAkuwSJr1SeEFzQ39/6+vc92NKN+rVfAUzK5UhE0GIwfE8c124ghpE1QBMX5jbry/+oPVFXX4MWZFVahOEGmU/jZQE+z2CHEPsVbDZriFY/kniOGIzF9x28jRVnGZz0lah6URKZhs5yHsFB5azlZfth8QhDSvOE4iA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NmWbwSu1taDmixq/EgXIRwL12LNFUjMssL/NHJHTkvY=;
 b=XJl91Zcc7gw8uSxQzg7V8CnNYOXbQMo63qxv3FsynNPzgpC/utq/VRoRPeIxvcY6iPc8zQMudRbnlnsPM7QCKdo21HOg8c4xfkdbSe41nGOWmK8H0ZiHn+6uMiARYq6bODpF6QqKkBEURov3jbvNx+vw6T4UY0mq+Pv2zc8EV1021ub4dUY80lKDup8p1mOlFOVD1G+Qj6pg3Bk909LuS2iBFHWZnzKtqGwjkmIsnvzKf9r2UEBmjzBTsZietIpT1qhLnMeHEFdIAroPmz3h0eZdlvuAxuyFA3gYOKhiIrVJus3pY30XkO9XsjqHjPpWRhvuQa2x3ZQ5o9RSmQKMOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NmWbwSu1taDmixq/EgXIRwL12LNFUjMssL/NHJHTkvY=;
 b=jtHQ2wp1JxuFwhzAKtn+KIDODid8So2jE9Uw+yyFT/KpIDruh3nfUJ1Hkkzd1xwEjAlCsZg/Ozni0nk3TqGbqhw8XWFah1qoS+GK8RPM09e9vdzfdCaf0IiBjgYtKqbCi2UcT49rKTj9+EDdEVSeggOCK6BKk3fH4Ni3UDC1res=
Received: from GV1PR08MB8428.eurprd08.prod.outlook.com (2603:10a6:150:81::5)
 by DB9PR08MB6729.eurprd08.prod.outlook.com (2603:10a6:10:2ac::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.23; Fri, 7 Aug
 2026 11:22:16 +0000
Received: from GV1PR08MB8428.eurprd08.prod.outlook.com
 ([fe80::9b97:c973:3308:5ba7]) by GV1PR08MB8428.eurprd08.prod.outlook.com
 ([fe80::9b97:c973:3308:5ba7%5]) with mapi id 15.21.0292.018; Fri, 7 Aug 2026
 11:22:16 +0000
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
Subject: [PATCH v5 19/49] KVM: arm64: gic-v5: Add KVM_VGIC_V5_ADDR_TYPE_IRS to
 UAPI
Thread-Topic: [PATCH v5 19/49] KVM: arm64: gic-v5: Add
 KVM_VGIC_V5_ADDR_TYPE_IRS to UAPI
Thread-Index: AQHdJl8AtYz06E10UEOs8KK76lVwSw==
Date: Fri, 7 Aug 2026 11:22:16 +0000
Message-ID: <20260807111159.429128-20-sascha.bischoff@arm.com>
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
	GV1PR08MB8428:EE_|DB9PR08MB6729:EE_|AMS1EPF00000044:EE_|AM8PR08MB5812:EE_
X-MS-Office365-Filtering-Correlation-Id: 5ca5fcfc-a20e-4787-e185-08def4763669
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|23010399003|56012099006|18002099003|22082099003|38070700021|6133799003|10067099003|11063799006;
X-Microsoft-Antispam-Message-Info-Original:
 7t4REwng9rmR9skTFmhfexEYNRbM60IU14wPUmCp16PO9wD9Wtaf3xbi4leT7FbGv7p3rcVSZUG3kbZPRsLHudNU75ITDVj0m8EnjsNEiXsH2tHhbgytwfsTCOyVNnlaoSCQWf3Y1/bWEjhqH8Rde8KSw4qswqDDP8u9EaxF9IOZ2jDXmVJi9GcvDcs8K+Tr79vct/ltz9ms+hQHS5e0eaMMQG//1eWR8HiHne0KoFwUtWNJYnKevzFcTZbF789BA/a8p6ZZSxYUV+laJ5xm0Eg3hF8hB8CUSfcpQjX2L426lPca7bZGmiLXEGU8iXzNmHX5Czm4lSUS+7he2+WrV+Zb8cMcjW7hlNtA1PD8BgwbIYT36+dLcl6luvdfUC/UV13DNGtRmKlCfmAgn96THVrCvZYsFdMQdHKT58G+2iDtyfeoSC74HR8teQvw7G7OjndrCRrQpcz/yTEriYsDd2vZCUXbeXivlpL9tbi4lDIx48dKQZLwQAdPCcStvQKg+JTtLfNE0RcurFDTy+YdUZ4CSpz2HYtB3aV8Vo2hPSPDZMRBMGrr8321/Y6sJPOJnqxa1D8qOcgCjrLzLMCa6cpGT9pfqagHg+8iTOLz6is7RA0w5VNHE/h8tQM71I0jsgStKs5TJwIa+98mdNo08WBfP9YP7RzPy+pyDf5hDeoKgz5Uhucom0vA3dc+ZCLnYlbuK+rd6veOHBAC+a2tf5itE5ro/k12yaZ3IFmqmp4=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB8428.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(23010399003)(56012099006)(18002099003)(22082099003)(38070700021)(6133799003)(10067099003)(11063799006);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 XaO9YIlD1DOMxP4TeDwgL4sBi4nfp2ZwywTOkJLzlVGWe29eehFPgCWGD3T2BafVZEioDCBSJI2rGvzpoxLV6a4wtAv5XfrgmcSPR7eT2Jw80n/BMZ/T7GpCE4uEBugmapTlnrlREPEw+PF2Fp+HesO8ERqhkRW6lUkKHO4WyfsXpP7zhiJvVZrU2Day6zdcdLJARBvIoirYf3NuraOtYst5oO0hE5BNMFUcoG3GX73jwF7BNWgvfHjvfXiL+xsYgucDaXHIMppGbzpSJeBhPVB0gK/WYvXj0W5TrlOviebIDMbPKj3KKQ6nQqdBBQlL+S70MNe0lHOtgKrukXEdEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB6729
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS1EPF00000044.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	0ee3f50a-95be-41d2-366c-08def4762314
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|23010399003|82310400026|35042699022|1800799024|36860700016|376014|22082099003|18002099003|56012099006|11063799006|10067099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	+3pLT7SYHstcVENsF1jy8gB+rPW5CZE9GrdGnExKZq5Xn4AxuFEItjTJDufYKkOUYW2kgLtu5LPJ0DRiOnrX/JeofZMXwyNwe5dP6hJmgjB/ishZ01qMhe6SdORp9XKBubSPPyVOmVw7koa5P1ygwTFKH97HHS5YxExZr/Bn+A8mIN93JUpe0F40oVW/e69BuENVFDR8tMOEOxB7TpG78vyNz04eNzNqPcTfpWFC6I9ceQu8/XpymgJltY1KFGWvpM1tvNYhTzIhVa/JNwwro4148GgaOkreHzyW2D9i6baVQLPSEqtT2QmUkPxQLVzF8fdTO3CzJRF4tk+0X15Nf6tQtT2IZK2WwuC7aRa2jXVov3ghon/ZBBCS3j9yilNSzV8RggYkkppGsoRPX3CyhVA8I4Jg8RaGIwTvIF2iY7DesqX8dIVHJvdENVeSdHrO2wqOdx+djXr+6y9GNNWZ27siUmHY4feZwF9vGB6T8755N2NgoRnDpSx+c4fIdV0szqXmCgndVdN15q2/p9sEN9cSbyKsfucezjf29S4GQU05hsD7FIm5V8YgF34EV1IxFfo+2qTUgEOFb5oZxgT2iytn7lBHnJvz8NPKUVkzJA1O6mWEoO62rV0CmJZRtjMNKK1/lnRetkkNjQDddVo7N8vEa/vRLBPjv69gh/eNU69tFVX+8XkgLc1gay3FPw2Ano8/+wzNL7rZ2c17gf8piA==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(23010399003)(82310400026)(35042699022)(1800799024)(36860700016)(376014)(22082099003)(18002099003)(56012099006)(11063799006)(10067099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	cNSrNwC46w8WTTFZVLjMGaI/9Chs+ztxpuhl3A2rDUsV1tWbDmC2AmrMlbOAO1KSJnx/c7ATj+QqTYSPERtw7Eafg/R0F8duTu0X4MQ7J6Mp9skl5eZ3cjOvCdkk76WHfxO5lcNeix4o5pSNJSJd0fXVpzB+YcGr0d15/0PBt8PfXKtiDHPShlxVMxIrBj13zjnaRnIbChUv8s9DuT4jCLe9yJvgH2YW15y1hTzwNSIKJskRYCkRoVcGVAEuZobEJcku/O9YMR3LIbrFDcD0e6KV/6iYEkYsZORt7tXu5H76ybTVhP2dmdbpOKe+cD9iyFNLq2vTI9QA7XpLH66w9Zey1YL4thzixK1wjdbmSnC5Wu4RichoFqKigr9V1zPA4+OTf/deRNTe38CQly6jXnobtSC38EW41te/Uvahl/jS4YAe7Zf1lFGyohcxGxQ2
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2026 11:22:48.8510
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ca5fcfc-a20e-4787-e185-08def4763669
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS1EPF00000044.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR08MB5812

Define the UAPI address type used by userspace to describe the
location of the emulated IRS in guest physical address space, together
with the size reserved for that region.

As per the GICv5 specification, the IRS has one CONFIG_FRAME and
optionally one SETLPI_FRAME per interrupt domain. Within a KVM VM we
are only concerned with one interrupt domain. Each of these frames is
64kB in size, so reserve 2x64kB of contiguous memory in the GPA space
for a GICv5 IRS.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/include/uapi/asm/kvm.h       | 5 +++++
 tools/arch/arm64/include/uapi/asm/kvm.h | 5 +++++
 2 files changed, 10 insertions(+)

diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/as=
m/kvm.h
index 1c13bfa2d38aa..d1b2ca317f586 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -97,6 +97,11 @@ struct kvm_regs {
 #define KVM_VGIC_V3_REDIST_SIZE		(2 * SZ_64K)
 #define KVM_VGIC_V3_ITS_SIZE		(2 * SZ_64K)
=20
+/* Supported VGICv5 address types  */
+#define KVM_VGIC_V5_ADDR_TYPE_IRS	6
+
+#define KVM_VGIC_V5_IRS_SIZE		(2 * SZ_64K)
+
 #define KVM_ARM_VCPU_POWER_OFF		0 /* CPU is started in OFF state */
 #define KVM_ARM_VCPU_EL1_32BIT		1 /* CPU running a 32bit VM */
 #define KVM_ARM_VCPU_PSCI_0_2		2 /* CPU uses PSCI v0.2 */
diff --git a/tools/arch/arm64/include/uapi/asm/kvm.h b/tools/arch/arm64/inc=
lude/uapi/asm/kvm.h
index 1c13bfa2d38aa..d1b2ca317f586 100644
--- a/tools/arch/arm64/include/uapi/asm/kvm.h
+++ b/tools/arch/arm64/include/uapi/asm/kvm.h
@@ -97,6 +97,11 @@ struct kvm_regs {
 #define KVM_VGIC_V3_REDIST_SIZE		(2 * SZ_64K)
 #define KVM_VGIC_V3_ITS_SIZE		(2 * SZ_64K)
=20
+/* Supported VGICv5 address types  */
+#define KVM_VGIC_V5_ADDR_TYPE_IRS	6
+
+#define KVM_VGIC_V5_IRS_SIZE		(2 * SZ_64K)
+
 #define KVM_ARM_VCPU_POWER_OFF		0 /* CPU is started in OFF state */
 #define KVM_ARM_VCPU_EL1_32BIT		1 /* CPU running a 32bit VM */
 #define KVM_ARM_VCPU_PSCI_0_2		2 /* CPU uses PSCI v0.2 */
--=20
2.34.1
