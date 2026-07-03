Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011007.outbound.protection.outlook.com [52.101.70.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFDD8265CD9
	for <kvmarm@lists.linux.dev>; Fri,  3 Jul 2026 16:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.7
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783094885; cv=fail; b=NtdJmnZrRX4JBycKhSz+4lkfQq0hRuewPaMXFv+b6XIYEIPsnbGvXbCNFqv7TTkZRSqEEt5JPHLpBYpkTuQHB9LJaFvOVZ0YUpCu8cZJFNTg03S25jZBScFnxj1plj1eRmMYqJy94l+a0dPvxHQTkHrhY6QvIzdl+aqrWhCcCtI=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783094885; c=relaxed/simple;
	bh=EyM6eYHUc2xUbn2t6sUDT+2kxrVimdoHQpAW0Lv61z8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=WQbpfUM2xADb7XPi+Ac1ZZq6aA7tMwY+gwdvIjZfbRbc7aJYNqgT9nxgtjnawQR7OTm0Ku1J7WIt0J97cqbebEOMB7gN4G8FDHT/7A8OrKIQO6DpdQ5CanaTF/HP6Xe1Tl0F9N7Hq56YrTuD1GE8DyIU70u6xOkR/47+TyfPlY4=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=bGY6962X; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=bGY6962X; arc=fail smtp.client-ip=52.101.70.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="bGY6962X";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="bGY6962X"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=dYhGTQm1gxfaP5tVhWlCwA1L8KFjb574mtUkmBChRjWiVPh3WAprWBnCsz+AqUgvrCjTBI6WiZsyqIOvNT0QXN1d+sniveg2AiwPmBEh+Zf4FlpNMLydUSmLkv5DlOzWpTuy7MH44JqnRjHEs0dK32jovrAnuSg/7k63y8yLpW4T5wBe7HByLtmuKpBfgUPmzg38MVhyKxuEeZsbunbzbzijZj7Tq8D1GyqNTO7NjOenjkJgCDOsdGTBftOdKhPDVqty4rI2Tii+X646KbeP2ApHnuxTfG2Tbby/Kws/ZpFZhtIxY46LgGRimp58X7KUl+TD3VHtLnDijIldVZstTQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GsNILN1h+M04pTwHtKVotOSR162o3jDLiePSx9oJdpk=;
 b=aL+H8YVT2CioimWWzWju41ykA99OZb9Wc8QOZclUM5VN3sFO1Fjwjo/DO6opDiXkJLQ20GtGSwCleVbyR6qruXgY0fUoD0KWJWJT06FfUTR73zCg4YAtLdhxQyTHp8HC58NBgjYftqJ06c80cWNsPHxQWdWaggu874H6av/sASWAhnJSPTcjrG6AeiS9KMWjvTprNFCfd5uTR1dmRRoOzqMOtIAaFL86QS0xB/9Nd/Cb7tWQJo9CVbKFun6/wTLPhlmBAUQgzceLYJPnbMo7baGA+a8DEtI+cPHudUzIoMCd2aZDxGopddpD/m4WbLzGB2fuLpu/T4TDBI8RkhtvGQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GsNILN1h+M04pTwHtKVotOSR162o3jDLiePSx9oJdpk=;
 b=bGY6962Xso2BLtsvErQREcEddngeVttOOgaUK0lB3UgLtDJT3bgEiTw5EwR7ilipGJkzgrUcdhzwnLfkugOSje2WB2NKH6Njej6skOzplxzShwuJIgfbXIfit3JNCBicMu14/K+UFdYttJf6PgILftba3d1yMRmAfGkttsgCpys=
Received: from DUZPR01CA0200.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4b6::10) by AS8PR08MB7355.eurprd08.prod.outlook.com
 (2603:10a6:20b:446::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.10; Fri, 3 Jul
 2026 16:07:52 +0000
Received: from DB1PEPF00039230.eurprd03.prod.outlook.com
 (2603:10a6:10:4b6:cafe::21) by DUZPR01CA0200.outlook.office365.com
 (2603:10a6:10:4b6::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.11 via Frontend Transport; Fri, 3
 Jul 2026 16:07:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF00039230.mail.protection.outlook.com (10.167.8.103) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.6
 via Frontend Transport; Fri, 3 Jul 2026 16:07:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ts0RsOu57evd4BEPE6sv3CAB4I9av8DTI1so6lVnJbee408VJ+w7RC6vtZaJnBraZJ2pvpJ4lhfYHKhmOMsaxdmm9GyOTxEUWg29AF3AUjoejUDH55s6E0WM4GuchDHb45cLYOrY00Whjeahdf+wgzOASMRZX1z6QCWZoReTG5eKgfDF9ygd8x7fieL6S2QHWD4f9v6LH5pHXSDVfZCV65jE+HZRcRRGf2QG6bmK1moQ9DLqWGwmhssxNEwXlFKhtx5NYkHWiz/v76FZfziaVaR4DWZm6w+Jco6MUVg1TPaIdbyO0BEC2jh5/LtXWweyDQ+JFJpeLzT+AaFepT+vMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GsNILN1h+M04pTwHtKVotOSR162o3jDLiePSx9oJdpk=;
 b=kfVGd69EdOsPGzvoMXv+XPHYfDCL/hnA/oOPfRNNzQpv+jw4OC/GBBUcQMRipo6soEf5qgedG9w4fJKIoJ38sL+Wg9iguvr9GgUWmldmfSwZqwKzSsfX+RnLw1tLa63CyigMImnC1+EJKLn6EGdGHifpJMD0UefpZbVmltObGc/4ByaHvuzjppQycvemMyZZy/KQQmArqxQtr8Uc6g00BrHlCwQjvaBuksECJSN1Ualq+ZR65uHhc13obZbOgIZTp7OhsFlht5CZJk7q2XkjMchYuJxuMWGeH9ZCWMD4Fjj0UNC/n7YUHlLT7ywQVAxTpU5Y2G2p3ncpO1B+S8eayg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GsNILN1h+M04pTwHtKVotOSR162o3jDLiePSx9oJdpk=;
 b=bGY6962Xso2BLtsvErQREcEddngeVttOOgaUK0lB3UgLtDJT3bgEiTw5EwR7ilipGJkzgrUcdhzwnLfkugOSje2WB2NKH6Njej6skOzplxzShwuJIgfbXIfit3JNCBicMu14/K+UFdYttJf6PgILftba3d1yMRmAfGkttsgCpys=
Received: from DU2PR08MB7310.eurprd08.prod.outlook.com (2603:10a6:10:2e5::5)
 by AM0PR08MB5459.eurprd08.prod.outlook.com (2603:10a6:208:186::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.11; Fri, 3 Jul
 2026 16:06:50 +0000
Received: from DU2PR08MB7310.eurprd08.prod.outlook.com
 ([fe80::e007:b494:8a24:1fc0]) by DU2PR08MB7310.eurprd08.prod.outlook.com
 ([fe80::e007:b494:8a24:1fc0%4]) with mapi id 15.21.0181.009; Fri, 3 Jul 2026
 16:06:50 +0000
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
Subject: [PATCH v3 32/40] KVM: arm64: gic-v5: Mask per-vcpu PPI state in
 vgic_v5_finalize_ppi_state()
Thread-Topic: [PATCH v3 32/40] KVM: arm64: gic-v5: Mask per-vcpu PPI state in
 vgic_v5_finalize_ppi_state()
Thread-Index: AQHdCwX0iGCqiH5ns0eL91oJJdvMFw==
Date: Fri, 3 Jul 2026 16:06:49 +0000
Message-ID: <20260703154811.3355680-33-sascha.bischoff@arm.com>
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
	DU2PR08MB7310:EE_|AM0PR08MB5459:EE_|DB1PEPF00039230:EE_|AS8PR08MB7355:EE_
X-MS-Office365-Filtering-Correlation-Id: 00bd4ac0-f6c1-4f7f-20d5-08ded91d3c86
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|18002099003|22082099003|6133799003|56012099006|11063799006|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 gUL6Tfev+YRJ0qy6Y/fK276cx8DstLno6YyXKwHLoc82+QxiJQig6g21YyVvUu1gOJ5q2/RmmRb8vMtqyEGK32nfYBErKwPxsVUuZadC72CAjaQ3Vk9AaFT4rdzhbWk5y8hurwHBL0hqzi6wAwTRtR5eBX9T3OGT3yoiNFszb+M9u+WF9IXz7Uofgy6af6W4feBy3hpVhByEbU8OM1e/kVyAmAfDpsg/PPhk3Ku3eAOWUur4YZsa2mA1tOSDCDc4+7HElIVjaFg11wEie95PpS4Hycf++7j2qUX4IUdMH7Qeo94e5PgFJQuPB9wAzJnudV8PTEk7XK9mDmHZvE3rcB5o5eS/T2HaRF4rramuyVV/r2w1go+bjHlpGK4Qd+CuXc5gvxPVJbND8R+++khWO82zbiqN8xWh/8IK2mvGNvtdoya5t+HXu9zNbGbXd7Uwh/idgoqVXWsm3GK5JB2VZB/AvFDcDnzSssEDY3ghp7AUCCBo6dqZAr5tPih8fUEOF6UKK/RQrtHGxqRcVpK6FpLPPKTX8f7yiAGi3pz5IHVOvTnApCXRcGT2dN653wePyK7pc93hVt2gaEd0j+5zH0gGSnN9GmOD7iGixp6V08Sw6Th9FoIsCwbwvCfAkhMb4bqgfwfJzo3Wcn5iXDU9crSvpwRVIhHDpTJzLQZkuZ/QI/6cCZzjuxJsR5gwjOq1XCi4MHDM+09rdEt4soyzBDYNpJlVx7XV5PUDqRNg2GA=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU2PR08MB7310.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(18002099003)(22082099003)(6133799003)(56012099006)(11063799006)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 TsHOKiqaiXbZErs1EnRsawy3EbwsEa+155S93ozWxIjZyKeat5fbn5FM87qmQZhHxEg1ksmJonfZZ5DNC8r+mHzCCn00iFsPTwPpI77UT8a5pRrZU9F2mna/kTCXIHby3yJew1+zQTn3C5PrfykQDeafliJ4ccuZsnX30mWCkwat+0jT7TGuFF8UZPxWTtpRgGsYZiTYuN7OkVAb3d1h5HyPX74pSmXpjC4mG4O9mXDKA7tdYIJTIJ8J9vLwrAEoxsXS97NAzvKA8hY3VbgmszfkG7sWCj1j5SxCUYj3A0A/5+l60NXPYEsMSd4+hD6M3dqO7s1toRsmmj3Fxhk7zA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR08MB5459
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF00039230.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	66b29f49-2067-40e3-2dbe-08ded91d172e
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|82310400026|36860700016|1800799024|14060799003|35042699022|18002099003|56012099006|11063799006|6133799003|22082099003;
X-Microsoft-Antispam-Message-Info:
	stcoueU3TSPF2iz+vtEO5/qliwClgsEF3T0SG4fL6uUG6iMQjgI+0FaePSx5UAVLunnOmVEYcRIZ1zYNUjtM7rmQ5sO8Vt2932gmEY68ZWq+bPoUdb6ndcYMZm/O9ZeDkkRRSCLCxsmwCRVoL1MEqEcBOfO4bzv0Ui+LWkmFIs0A+xLb6KO384usfL3tiTj07/gckXlUNHC5je+vMUlKod78Rpl7omH12F7eg6R2GgOZqXh5XXrGkPjkC5IlhaH6rAKFHvI50h/6zICr2SEZ5DguWHCZz1DF4Fo4fbeGUT9d94cSFyHux0+RNWnP7jYL/4DPr37yvwDPG2W+QUIBNDDZv0pk/QUgyYa416AWGq6wEzFRs5V/nKzzMNDllxu2jJ+foNQmuFhCyOqJWhqOrnT8Tj36Nx7kQWM2xgJhnlg65laLe6MOwCJfRnIU7R1gDL6ezE7v0cOAgBBRTVeh0DI0hggNLt1462vfMFc6Gbxzl5/LUSRokVwEX+++SClzwuHl7aeBTcjA77fsN8YNDgeoHJdN08J0baEDFTKJOhzcbgPpevmqGm8nOSIIFRa+IQL6Ls/6a9lBG7pMMIm5xyf/dKNX+vf9sFuRUKXz6NJDxry1DYR+5VkhiwIJ67B5Gi5s1fAjRfzr+ECetaHKuRdFb4KbxLjmmfwyUQ1gXUcI0ER/nLotnB8lp9iOhvYk8U/stCBokbLT6oRX7/uJzA==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(376014)(82310400026)(36860700016)(1800799024)(14060799003)(35042699022)(18002099003)(56012099006)(11063799006)(6133799003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	gzRtFOpeC3NElUrlXAuZYrLdnxzioyo5MeX06x6ofKf6GIssSeMQzR7K28etw5dX7Xftuo5Og66jEpEZbAtHkN8dK8zIlUXMAzM4x1Yh9IYKvVNoZg5KHqwQA+P75W+OXGVG8HWD1ADSOmFzReGlXldRpOkF2n3eb/3aXWYi4uRKOddOEvUp0LNuw5Dt0058ZEjU3uFwpctdhzkpAgmefZ84JOpvaL0FzN31rEHY4P3egzGbw9dj4Wivbd0NyJS6kzLwPbS4CTp03fNdsEkb6aAb8kVcRkR/AHHoZ2sEw2P/Hrjs79UctrLf/JsJ5gxeuaqv+DMtPq5cBSgez9pp2GUF5dDrADNLk9uOHfxpXAZNK9t5gta5cOKLhPSzuK0G0d4ZD+UHvaywXPHNAGnjoxB5Mu6IMC0d3S1nbOfL7EjLgzAv69scJ7dMghl9fNpl
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2026 16:07:52.4787
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 00bd4ac0-f6c1-4f7f-20d5-08ded91d3c86
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF00039230.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB7355

Only a subset of the possible PPIs are exposed to a guest when running
with a vGICv5. First of all, only the architected PPIs are considered
by KVM. Secondly, only a set of those is exposed to a guest - those
corresponding to devices that KVM emulates (timers, PMU) and the GICv5
SW_PPI.

The finalisation of exposed PPIs happens on first vCPU run as this is
the first time when the full set of exposed devices is known. At this
stage a mask is calculated, and this mask is applied to both hide
non-exposed PPI state from the guest and to reduce overhead when
iterating over the PPIs.

As part of introducing support for userspace accesses to the GICv5
system registers it has become apparent that userspace sets of the
GICv5 PPI registers can result in a mismatch between the state exposed
to the guest and what KVM expects to be exposed. Effectively,
userspace can set the Enable, Active, Pending state of PPIs that KVM
has chosen to hide from a guest.

Under the assumption that on a VM restore userspace will set the PPI
state prior to running the vCPU(s) for the first time, rework
vgic_v5_finalize_ppi_state() to not only calculate the mask of exposed
PPIs, but also to clear any state for the non-exposed PPIs. This
ensures that only the state that KVM intends to expose to the guest is
exposed.

Note: If userspace chooses to set the state of PPI registers after
running a vCPU for the first time, then no masking takes place and
that state is directly exposed to a guest.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/arm.c          |  2 +-
 arch/arm64/kvm/vgic/vgic-v5.c | 71 +++++++++++++++++++++++++----------
 include/kvm/arm_vgic.h        |  2 +-
 3 files changed, 53 insertions(+), 22 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 50adfff75be82..6ebe4fd74c878 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -961,7 +961,7 @@ int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
 			return ret;
 	}
=20
-	ret =3D vgic_v5_finalize_ppi_state(kvm);
+	ret =3D vgic_v5_finalize_ppi_state(vcpu);
 	if (ret)
 		return ret;
=20
diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index ceab71c2412bd..058cedfc2bf4c 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -776,9 +776,10 @@ int vgic_v5_map_resources(struct kvm *kvm)
 	return 0;
 }
=20
-int vgic_v5_finalize_ppi_state(struct kvm *kvm)
+int vgic_v5_finalize_ppi_state(struct kvm_vcpu *vcpu)
 {
-	struct kvm_vcpu *vcpu0;
+	struct kvm *kvm	=3D vcpu->kvm;
+	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
 	int i;
=20
 	if (!vgic_is_v5(kvm))
@@ -787,35 +788,65 @@ int vgic_v5_finalize_ppi_state(struct kvm *kvm)
 	guard(mutex)(&kvm->arch.config_lock);
=20
 	/*
-	 * If SW_PPI has been advertised, then we know we already
-	 * initialised the whole thing, and we can return early. Yes,
-	 * this is pretty hackish as far as state tracking goes...
+	 * Discover the set of PPIs that are exposed to the guest once per VM.
+	 * Once known, apply that mask to each VCPU's restored PPI state as the
+	 * VCPUs are first run.
 	 */
-	if (test_bit(GICV5_ARCH_PPI_SW_PPI, kvm->arch.vgic.gicv5_vm.vgic_ppi_mask=
))
-		return 0;
-
-	/* The PPI state for all VCPUs should be the same. Pick the first. */
-	vcpu0 =3D kvm_get_vcpu(kvm, 0);
+	if (!test_bit(GICV5_ARCH_PPI_SW_PPI, kvm->arch.vgic.gicv5_vm.vgic_ppi_mas=
k)) {
+		bitmap_zero(kvm->arch.vgic.gicv5_vm.vgic_ppi_mask,
+			    VGIC_V5_NR_PRIVATE_IRQS);
+		bitmap_zero(kvm->arch.vgic.gicv5_vm.vgic_ppi_hmr,
+			    VGIC_V5_NR_PRIVATE_IRQS);
+
+		for_each_set_bit(i, ppi_caps.impl_ppi_mask, VGIC_V5_NR_PRIVATE_IRQS) {
+			const u32 intid =3D vgic_v5_make_ppi(i);
+			struct vgic_irq *irq;
+
+			irq =3D vgic_get_vcpu_irq(vcpu, intid);
+
+			/* Expose PPIs with an owner or the SW_PPI, only */
+			scoped_guard(raw_spinlock_irqsave, &irq->irq_lock) {
+				if (irq->owner || i =3D=3D GICV5_ARCH_PPI_SW_PPI) {
+					__set_bit(i, kvm->arch.vgic.gicv5_vm.vgic_ppi_mask);
+					__assign_bit(i, kvm->arch.vgic.gicv5_vm.vgic_ppi_hmr,
+						     irq->config =3D=3D VGIC_CONFIG_LEVEL);
+				}
+			}
=20
-	bitmap_zero(kvm->arch.vgic.gicv5_vm.vgic_ppi_mask, VGIC_V5_NR_PRIVATE_IRQ=
S);
-	bitmap_zero(kvm->arch.vgic.gicv5_vm.vgic_ppi_hmr, VGIC_V5_NR_PRIVATE_IRQS=
);
+			vgic_put_irq(kvm, irq);
+		}
+	}
=20
-	for_each_set_bit(i, ppi_caps.impl_ppi_mask, VGIC_V5_NR_PRIVATE_IRQS) {
+	/*
+	 * Apply the mask to Enable, Active. Skip pending as that's calculated
+	 * on guest entry.
+	 */
+	bitmap_and(cpu_if->vgic_ppi_enabler, cpu_if->vgic_ppi_enabler,
+		   kvm->arch.vgic.gicv5_vm.vgic_ppi_mask, VGIC_V5_NR_PRIVATE_IRQS);
+	bitmap_and(cpu_if->vgic_ppi_activer, cpu_if->vgic_ppi_activer,
+		   kvm->arch.vgic.gicv5_vm.vgic_ppi_mask, VGIC_V5_NR_PRIVATE_IRQS);
+
+	/* Also update the vgic_irqs */
+	for (i =3D 0; i < VGIC_V5_NR_PRIVATE_IRQS; i++) {
+		bool visible =3D test_bit(i, kvm->arch.vgic.gicv5_vm.vgic_ppi_mask);
 		const u32 intid =3D vgic_v5_make_ppi(i);
 		struct vgic_irq *irq;
=20
-		irq =3D vgic_get_vcpu_irq(vcpu0, intid);
+		irq =3D vgic_get_vcpu_irq(vcpu, intid);
=20
-		/* Expose PPIs with an owner or the SW_PPI, only */
 		scoped_guard(raw_spinlock_irqsave, &irq->irq_lock) {
-			if (irq->owner || i =3D=3D GICV5_ARCH_PPI_SW_PPI) {
-				__set_bit(i, kvm->arch.vgic.gicv5_vm.vgic_ppi_mask);
-				__assign_bit(i, kvm->arch.vgic.gicv5_vm.vgic_ppi_hmr,
-					     irq->config =3D=3D VGIC_CONFIG_LEVEL);
+			if (!visible) {
+				irq->enabled =3D false;
+				irq->active =3D false;
+				irq->pending_latch =3D false;
+				irq->line_level =3D false;
+			} else {
+				irq->enabled =3D test_bit(i, cpu_if->vgic_ppi_enabler);
+				irq->active =3D test_bit(i, cpu_if->vgic_ppi_activer);
 			}
 		}
=20
-		vgic_put_irq(vcpu0->kvm, irq);
+		vgic_put_irq(kvm, irq);
 	}
=20
 	return 0;
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index f9f58ca793707..eb68c96a46ed2 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -783,7 +783,7 @@ int vgic_v4_load(struct kvm_vcpu *vcpu);
 void vgic_v4_commit(struct kvm_vcpu *vcpu);
 int vgic_v4_put(struct kvm_vcpu *vcpu);
=20
-int vgic_v5_finalize_ppi_state(struct kvm *kvm);
+int vgic_v5_finalize_ppi_state(struct kvm_vcpu *vcpu);
 bool vgic_v5_ppi_queue_irq_unlock(struct kvm *kvm, struct vgic_irq *irq,
 				  unsigned long flags);
 void vgic_v5_set_ppi_dvi(struct kvm_vcpu *vcpu, struct vgic_irq *irq, bool=
 dvi);
--=20
2.34.1
