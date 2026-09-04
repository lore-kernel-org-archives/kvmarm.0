Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012024.outbound.protection.outlook.com [52.101.66.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF8A7479877
	for <kvmarm@lists.linux.dev>; Fri,  4 Sep 2026 11:35:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.24
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788521759; cv=fail; b=YtCYYg4c3ap4J2QS4EWbIAhstX3oVl2JbiN9ZU8i2KI0DFvUenFkSwVFweZR/HdVVPQwisXdJhTshc3ifbhm4DwtOixzU+r2nEEKPh9yXTJo5cZYdQMfsb9qeO1AOIsjosoN/BR/UAVchlVTkw+qEot8o5K16WIo7VrPJKm2tbU=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788521759; c=relaxed/simple;
	bh=9rTuL+ZDIvTS6oKI8mvSLu99GFtdnxtoe/FNPaluRfg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=JlMIZnuaMZe4VcS8Xbll/DWAHqFsoi8fmPmx567woD09wcnvttFuPk0+9qK2ErtIqMsCBwWnN9miAVRx537H2d5GEGsGanrlTOl33eZKOvhByDbtsigsdR1ySuDFQnoQ1PDQ12lzNDaIR+b/j/Ze/ONTCKFQHpgKWaTi4W1u6Tg=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=CxdseWgP; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=CxdseWgP; arc=fail smtp.client-ip=52.101.66.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="CxdseWgP";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="CxdseWgP"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=npRhsIRu8P7o5NNdb6chExbxRgrdMhAtlpJ6FG4+hTZELIOhp0JO2sLqVj6ur5xiUG0+OB4Sn3VlyEa98zWToLZR5q3Mz4XivbOHEQkLfjdx8ZExju4sQgRI8/wDoowBjk7B3KMkPA2bdf5ufhi7wcZc7QTEnxGkU0BM4KHbrxA+yx8NWLvwENuMO5EI0xEOdmhMtJGqcLnosfDgIWGIt37qC48IPKabzv4ssSREmD2PavBlAvwqzoEPiA4YawXTouTh9Exx4h2WeaFfJG/s+FYChUboUjtNDko9zy4dob0yG35gB1niu+IK2hURPQXILDlJkNUmieawlhe4k7ogAg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5dGqaHk/8j6DdRnM7juiuZhAX05DewNFnr2vNuJJXAY=;
 b=Zda5BSyOWhi0AzzkaYt08OrbfO+/SVGoz48bODbb51gTVMcQyhh8RdV+YcZbOoFqCkk4AvlmOVzIOgkl3sRrVX0hnPt9DsKnO1BO70ekveckqP4TAzXx4KnOHkoc4Vu+kN9QYDx6MEIUYeJfvc9bmy+M3zI1joiPBDapuBcF2PWyQv1jzbTZe/csWuDL410JGVql1LwusqyGIAVY8CfchSzkBtfWQilLQ1j9Iupr0Khe4aNVyeAyLBEBjrGmiMSPtqCbj3ByJ8/Kl7zeGTlU7AoISnQ/uGBP1Xz3SumywT/d3wnU+/rqpRxSXZdKhzA6L6HNWsnpurs3ViljY0TEDw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5dGqaHk/8j6DdRnM7juiuZhAX05DewNFnr2vNuJJXAY=;
 b=CxdseWgPjS43BeRmM7kVxnWfpKz0QSHvZTk9ttDrIPK1//16XQQtlKL2Y7/XyAFfiKNlUIetvb17nEO2BDORkBQd4nigdpAk78stfR7AjDoFXkrnoJejGX7yWKDxmpYMF1Bk8TDgkQlkNMXtVZCpydHX3LRinMks0yxTXnVqPi8=
Received: from AS4P192CA0003.EURP192.PROD.OUTLOOK.COM (2603:10a6:20b:5da::13)
 by AM0PR08MB11736.eurprd08.prod.outlook.com (2603:10a6:20b:73e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 11:35:52 +0000
Received: from DB1PEPF000509F4.eurprd02.prod.outlook.com
 (2603:10a6:20b:5da:cafe::10) by AS4P192CA0003.outlook.office365.com
 (2603:10a6:20b:5da::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.13 via Frontend Transport; Fri, 4
 Sep 2026 11:35:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509F4.mail.protection.outlook.com (10.167.242.150) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.8
 via Frontend Transport; Fri, 4 Sep 2026 11:35:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=r2+9UXQwzmeYImlTAzwBlucDvR9Ko9naIpaAn71O77nDOStCj4yDjqRZ1ALMoiUY/H3GPCKP7TXQFbPyAmfo/rxOM4tUXwv0IsuBJBSe2L59KtPtUfGfjh0RUkiaJxPi+p14v9l2WEy6BbTfD+WpUsdIsmn7NhsaIS5bJf5Q3M5QFY4y3n8mSozvd48uh2N4wC/vIKufHhg4TxET2ocBYJ7/GdDDSB0DGwjha1yAQE7zRnNh/dUdkCcm5mr78yodnttMHLCPrtF9zHxguiZk6sW88zUWU84zaxjz80sxrEsGeF/Rt6cin9rZfQ7nKkv0opkpWkpu1getb/d+UFggcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5dGqaHk/8j6DdRnM7juiuZhAX05DewNFnr2vNuJJXAY=;
 b=iCpn6allDJY3+fi/3IJ7inu0UCrHLSaHS3Y6ARykqjz2BErDjztGLh2umEEMTy92Rz4CjKkkjvnULxz4utUc5FxJ3Wn+ZMmq8jUp42LxhTzSe2oLmcUOu7psIs5IZ9YyBaZQcYdEYhOKsz+xV/Op2DrYuzk25ViLKUDpFXW5LNVassCE1U4pxLRZICACLZOfE2HdzErn+WSuqo3D3CHyTyKNSQVBpcTaJLoqYGqH/XMYgUlgnNVlVFTL1/zIrJJmxWIDKNA9kQTCSlkGiyTWOzUyPU+bJWQqxSd+ZmgLT11DC6TvxhflcOe97taaO6+4Mz1NccVqw27n7I0ZB6iBxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5dGqaHk/8j6DdRnM7juiuZhAX05DewNFnr2vNuJJXAY=;
 b=CxdseWgPjS43BeRmM7kVxnWfpKz0QSHvZTk9ttDrIPK1//16XQQtlKL2Y7/XyAFfiKNlUIetvb17nEO2BDORkBQd4nigdpAk78stfR7AjDoFXkrnoJejGX7yWKDxmpYMF1Bk8TDgkQlkNMXtVZCpydHX3LRinMks0yxTXnVqPi8=
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com (2603:10a6:101:1d::23)
 by VI1PR08MB5504.eurprd08.prod.outlook.com (2603:10a6:803:13b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 11:35:17 +0000
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e]) by PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e%4]) with mapi id 15.21.0382.007; Fri, 4 Sep 2026
 11:35:17 +0000
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
Subject: [PATCH v6 02/49] irqchip/gic-v5: Provide OF IRS config frame attrs to
 KVM
Thread-Topic: [PATCH v6 02/49] irqchip/gic-v5: Provide OF IRS config frame
 attrs to KVM
Thread-Index: AQHdPGF1ieQ/AlZ8O0Gb8ZAdm7qh3g==
Date: Fri, 4 Sep 2026 11:35:17 +0000
Message-ID: <20260904113404.4051341-3-sascha.bischoff@arm.com>
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
	PR2PR08MB4889:EE_|VI1PR08MB5504:EE_|DB1PEPF000509F4:EE_|AM0PR08MB11736:EE_
X-MS-Office365-Filtering-Correlation-Id: 8fd32776-075a-4903-ba46-08df0a78ace0
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|23010399003|1800799024|376014|38070700021|56012099006|10067099003|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 zJrClgYZxutad0M8P4FgW/XMW5qfm2hnakHmh+thGoUmRTox1elMEJOolsJregz87s+fMEYr96MrMpBVM1BsUP7OR+0ukFtwSvvlVH8VGCuDHk9m7GJv3VN5LhcnRWDM0VnZQRWH1BvnWYnCkGGf/liRXcDQcm5NwpXanJNqZGCrKzGTaWxbsN5BW3NR23gmL30h6oXQ/ntK6XA3EYwwwznRonsM9Z1/bz1yjzqUXHH+P9+/mFd/zZtpOX3OutIS1tRBa4GQSeWCyZbzZ2PNWscN/qw32fw7ypCqivUGRCJZQiSDVZRfyDDQaAqPvIDc2O9B+c2xIdEFZfrydODR0QW762SAqxc4k9X2Ydt+2HP/fRHJA01CpiQXFfpvtzkDcrWwQZiEcHJD5foAF9LGuJBCQxCt3oHkbEMMoLJGz0Ri1QOY+82nvlXWf8+4KFJ5HhkWpL1kR/sP7DywImuoevHWPp6GJrpYXp2wda1zrECjP21H8ZzgNwU7d3TCs0/TA23B3kRtocaU4ybVqhCYaaAAM7vvynxK+uNy9Qn+AzGLrGV/irITY3px9z4pFtQu5w2+8wJXHiSGzNg+4oUZG/lbfjpC8fH4YCapIw9uzJdltZDz3xNsQe2yZFH0ByVVltv3xA6ifkUQO9lpHPjBPLRDUSn85RvqfIlBFE306L/zrBgZ/cF82Z8yvLvRFxNgLHrfz2feuxxtnsorFWukYX7yCl67OyOECMrJu9tYbRk=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR2PR08MB4889.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(376014)(38070700021)(56012099006)(10067099003)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 gypcxKyCs2xmyDiIgWPr1ckugMcEEaNI/eF7jKDiSh5tNlNjq+bd+a7OG5MQh7JmKI3XK4rw79j5MCCzxnC9LfqKa4yy41QVzqU1VC4xeLkA51OCyxwfjpNRFn52ZIsUWSMT9vCvCd50UZPpFTIU1HBcIZyEf3GDUV61ewAirem+0yJ8n4nuv1KpQ6RwmsRXAmi1eRyH6u/olDvVYx8c14gndcqkncj6z8/K6mA6MYRBw+tzFGKptEuf0nSIBZmUTEbOjafILT3okY5bQu+DiRse6dfThTUb/q4YHMcvw16Kvmrld0TSf4BHmg0UEVhXOHepOOWHb3Tlq8jV6I0dxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB5504
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509F4.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	5e5e497e-23ac-409e-cc29-08df0a7897e1
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|35042699022|1800799024|376014|23010399003|36860700016|14060799003|18002099003|22082099003|56012099006|11063799006|10067099003;
X-Microsoft-Antispam-Message-Info:
	X3+aLgBKEaqbfUMlR5bTwaoY9caFxiiHCgSk9fYDLyktOW6xuTD09V1FHQ1Pv5YbxsgXFM0mbEkS0/gP3sQC0o5GR1WnyuOWeAVTZneBGDJWHjhmKC4sqehd1HTXV/kDeX9YvWy/bIvRUcqoUR7NBD1WvVzsE/Ah/Fm8uEIl1pfRxtv0FXQWrux0D/pYPyX2hbb4Bqo6LvOk7to0kznq3ZKg+XraVaGILLWvOZXRWlDXJMBc8K03f2mW6pfmMUlcW+yARnBqkVQ9c7uuF6/VYfB3e+XcBqOHeNfEoxwbMVaULNkFcjbJPl/AKgFcW39TVVrl/cxvTGeBZWvYsEXEMvtd5PsRwScPm28WVcYRvrs9WPqIE4oXMhNWnRgDBuEDkI8z1SSV6VDFiwy8aZ0t/hvyjC7sSu7q1msaIS1UEZs5yEkWJMDpxEBicpbG6kIzAXwnmiEBh7AEsV5DaUIj1lo6vUXkWEKQZx6C4H1K+kPGVSttdGzhSpNtMPXCLm6rl1agATCD29pSSHMl8E0JDF1nJA6xuIQD/fBm5JTdoUrDmbBwmi2PyhF9YZ65zd5sMbCgsbGOf0HUMVaG1qyMqGwbp9DgWdgY/uIYC5W+TruoG+oRNafUnBzTV0HIoGP/2GbGeEN5Kt1ZYnJDMODmD2tTr9TDxzhmR7pE5+/cx8o=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(35042699022)(1800799024)(376014)(23010399003)(36860700016)(14060799003)(18002099003)(22082099003)(56012099006)(11063799006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	uzpiSi0daZEVTSlZcyGuRmdKC0og0DWM5nJzxt+4laySPfKo66ssFzzaFTRU/J7l2ABBq8/B0F3RX2jqj9no0zblboI1friGucypZWl+dqFswp0sayJW34mWrpGOePc/QDRoQYCS5ClOVItpFLGiN5k5WrvPVncZ+CQcrVub36w9EKn0LDFuLprf0PFBHvV8uHST2lvOfGAjcVIMOziFc7oOMDxws49r9i7SpBI6snTvkJAONIqo/uUn5lv0SCDXoA3erIq/3tSOkNZzw5WqoMg0oDRj8rcOgfCkat8+z6xIzbut33ZaInKzsB+J+J86/PAccoyHmQIkhCkxvWaCDWvdurhpz2bsVDhVb+eOJlfngAqMcR3eOlrQlwgY99Q9z43LZwwQegOXcAITN2USssHtGMkSHqp36iuFCabVhKz6XT435/sZruAHjWKJzPaC
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2026 11:35:51.9910
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8fd32776-075a-4903-ba46-08df0a78ace0
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509F4.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR08MB11736

KVM needs to interact with the host IRS in order to, for example, make
VMs or VPEs valid. There are two potential approaches here. Either the
host irqchip driver can provide an interface, or KVM can interact
directly with the host IRS. The latter of these two is chosen as the
set of MMIO registers that KVM needs to interact with is orthogonal to
the set used by the host irqchip driver (with the exception of some of
the read-only IRS_IDRx registers).

Pass KVM a pointer to an IRS config frame - the config frame belonging
to ANY IRS is fine as long as one IRS's config frame is used
consistently - in struct gic_kvm_info. Additionally, include a flag
telling KVM whether the IRS is coherent or non-coherent in order to
make sure that KVM can do the correct cache state management, if
required.

Only OF (Device Tree) is supported with this change. ACPI is not.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 drivers/irqchip/irq-gic-v5-irs.c      | 7 +++++--
 drivers/irqchip/irq-gic-v5.c          | 5 +++++
 include/linux/irqchip/arm-gic-v5.h    | 3 +++
 include/linux/irqchip/arm-vgic-info.h | 5 +++++
 4 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v5-irs.c b/drivers/irqchip/irq-gic-v5-=
irs.c
index b3feb6340b59e..1014cbd80e873 100644
--- a/drivers/irqchip/irq-gic-v5-irs.c
+++ b/drivers/irqchip/irq-gic-v5-irs.c
@@ -21,8 +21,6 @@
  */
 #define LPI_ID_BITS_LINEAR		12
=20
-#define IRS_FLAGS_NON_COHERENT		BIT(0)
-
 static DEFINE_PER_CPU_READ_MOSTLY(struct gicv5_irs_chip_data *, per_cpu_ir=
s_data);
 static LIST_HEAD(irs_nodes);
=20
@@ -50,6 +48,11 @@ static void irs_writeq_relaxed(struct gicv5_irs_chip_dat=
a *irs_data,
 	writeq_relaxed(val, irs_data->irs_base + reg_offset);
 }
=20
+struct gicv5_irs_chip_data *gicv5_irs_get_chip_data(void)
+{
+	return per_cpu(per_cpu_irs_data, 0);
+}
+
 /*
  * The polling wait (in gicv5_wait_for_op_s_atomic()) on a GIC register
  * provides the memory barriers (through MMIO accessors)
diff --git a/drivers/irqchip/irq-gic-v5.c b/drivers/irqchip/irq-gic-v5.c
index 0950bb9bb2814..29e9c59a3fb09 100644
--- a/drivers/irqchip/irq-gic-v5.c
+++ b/drivers/irqchip/irq-gic-v5.c
@@ -1122,6 +1122,8 @@ static struct gic_kvm_info gic_v5_kvm_info __initdata=
;
=20
 static void __init gic_of_setup_kvm_info(struct device_node *node)
 {
+	struct gicv5_irs_chip_data *irs_data =3D gicv5_irs_get_chip_data();
+
 	/*
 	 * If we don't have native GICv5 virtualisation support, then
 	 * we also don't have FEAT_GCIE_LEGACY - the architecture
@@ -1134,6 +1136,9 @@ static void __init gic_of_setup_kvm_info(struct devic=
e_node *node)
=20
 	gic_v5_kvm_info.type =3D GIC_V5;
=20
+	gic_v5_kvm_info.gicv5_irs.base =3D irs_data->irs_base;
+	gic_v5_kvm_info.gicv5_irs.non_coherent =3D !!(irs_data->flags & IRS_FLAGS=
_NON_COHERENT);
+
 	/* GIC Virtual CPU interface maintenance interrupt */
 	gic_v5_kvm_info.no_maint_irq_mask =3D false;
 	gic_v5_kvm_info.maint_irq =3D irq_of_parse_and_map(node, 0);
diff --git a/include/linux/irqchip/arm-gic-v5.h b/include/linux/irqchip/arm=
-gic-v5.h
index 2c2fb39f049c3..59a5875854319 100644
--- a/include/linux/irqchip/arm-gic-v5.h
+++ b/include/linux/irqchip/arm-gic-v5.h
@@ -332,6 +332,8 @@ struct gicv5_irs_chip_data {
 	raw_spinlock_t		spi_config_lock;
 };
=20
+#define IRS_FLAGS_NON_COHERENT		BIT(0)
+
 static inline int gicv5_wait_for_op_s_atomic(void __iomem *addr, u32 offse=
t,
 					     const char *reg_s, u32 mask,
 					     u32 *val)
@@ -379,6 +381,7 @@ void __init gicv5_free_lpi_domain(void);
=20
 int gicv5_irs_of_probe(struct device_node *parent);
 int gicv5_irs_acpi_probe(void);
+struct gicv5_irs_chip_data *gicv5_irs_get_chip_data(void);
 void gicv5_irs_remove(void);
 int gicv5_irs_enable(void);
 void gicv5_irs_its_probe(void);
diff --git a/include/linux/irqchip/arm-vgic-info.h b/include/linux/irqchip/=
arm-vgic-info.h
index 67d9d960273b9..f05370e2debf4 100644
--- a/include/linux/irqchip/arm-vgic-info.h
+++ b/include/linux/irqchip/arm-vgic-info.h
@@ -38,6 +38,11 @@ struct gic_kvm_info {
 	bool		has_v4_1;
 	/* Deactivation impared, subpar stuff */
 	bool		no_hw_deactivation;
+	/* GICv5 IRS base */
+	struct {
+		void __iomem	*base;
+		bool		non_coherent;
+	}		gicv5_irs;
 };
=20
 #ifdef CONFIG_KVM
--=20
2.34.1
