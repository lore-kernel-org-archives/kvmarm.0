Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011041.outbound.protection.outlook.com [40.107.130.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0D2847F2ED
	for <kvmarm@lists.linux.dev>; Fri,  4 Sep 2026 11:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.41
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788521729; cv=fail; b=cwOL/DVIlSg7QmtFKZok0wt96vGqmDuCbkr1X/MRgllVVCDC5JuktDzpT9JdMwdAw073vKKv8iDww9/fhIfPL0Op/8IjtWsgQfBYnwUgN3+NDQFFaF+q63bYAZwAfQrD2fEhrc06O3HqvMpHDzf6XOLpqy7ovUDFzTSGXjCyWIs=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788521729; c=relaxed/simple;
	bh=NgzWVSf8sMkdr0zY08W8uHE9wO1FRNwY4rtLsS2OCj4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Ko5lyTqHoV05FHbHjzg2z1uLlN7VgIt5zyK1r/muDjt5H1efw5MHXL3uraKTA2uy0yjKE7fvGuX37Awg7MAxiKEnrCrJUCB7v+NJMPIPIIGEdG9/lDGb22nx3QK22F/OB2E+Q8C0qOrHzV7u6XEukjOKknZhaPeLadeIDHuzahc=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Am+7S31N; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Am+7S31N; arc=fail smtp.client-ip=40.107.130.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Am+7S31N";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Am+7S31N"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=uh2c6vjpGY9Y4k3izq9Y9pBryyqXrqAbwh9NQ1C9wgncy8WwnEmteWkjuAKRnnk1mRli1gNywq7pAHzBwqmSP359mWpqfBz50hoIFOUrdhWICPnQTmabgnrGs6kNz7/oiNwK7kBq3QNddVQzM7wYs7W4ONqPCsx538CLaGs4wr8Pm/eR2Y1Dquq1tQlpFhgjxLwX68GXC9tiVc5QwCGrlCbjVYvAC/8903tQsQtnv+nHcjrXFzVlCrsXH3TTTyDLYa/GiQ15qNXxJWdxLaf/oQlrPKNvMrg564ASYuT+KhCgIygHGDKPLQ9WagJEZPI5fTSStb6eOemm/efQZJNjkg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qxfZQdJrCVH2tBg9fow0pW5u9fefy2AgrS55OK8IQG0=;
 b=eqinZSjk9+WQPjqIpx03J6+TtY/MznrHiaTgTCwo5lutUmIR5soBQ8h+nJbvxgD3JFur8KUXzcIjfrjWrfJpFSwv9kds1fjYZwOa9VY6C8glzaZumdE9O6TZGvbRg7n6AT/VkFBiK5xnZIjN1B7JAsm9U+gVmj/8meN0v+JapYrh9NyLI+8o86KFqHmfQ7+Y4qLLGwOv5bSOXE8gdQS9KXBaLb11ERqn8ym+K9Ne6tezGQUGR01S7KEIlbE+ZSt87oMPfRUogAzmSWZ5EbECi6LkdNEiP4SA26+UvsvUJzixA1uU7rMv2q/ZKuWG6wZI+SEtDy9ZFHlVZKBToL999Q==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qxfZQdJrCVH2tBg9fow0pW5u9fefy2AgrS55OK8IQG0=;
 b=Am+7S31NGAjQa5gmctwuMnHrW3SFSb9NMg16jzoQTMRsJxQtM/ok7rqR6rmWzfIn6l9m1+r+OyNMkNjR4XKoMhO5Mbv12zb5fyCPTsS0qi53dnY9tfMlF2VlaCaCiFDdFnh1MTu2jW23yNt+EDPrcfZlFKH1dwpwY7TRUbZJ33s=
Received: from PAYP264CA0017.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:11e::22)
 by AS4PR08MB7759.eurprd08.prod.outlook.com (2603:10a6:20b:516::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 11:35:21 +0000
Received: from MI3PEPF0000855B.eurprd05.prod.outlook.com
 (2603:10a6:102:11e:cafe::5f) by PAYP264CA0017.outlook.office365.com
 (2603:10a6:102:11e::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.13 via Frontend Transport; Fri, 4
 Sep 2026 11:35:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 MI3PEPF0000855B.mail.protection.outlook.com (10.167.240.23) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.8
 via Frontend Transport; Fri, 4 Sep 2026 11:35:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IBhuKKfW9EFhmo2FltUsUWmv6TdmyWdPx6AwerIDWlpvWbYHwpeMOTt17mWyEw6pohZ5fPNAJMlpJYDEuKVmsUbGUmt3ApCo1Rj+qf1Mnn10DuEUQmEfAsgJGw1L1S8FbDNO82rLvYQopD2qh6m30NQ2kLhVmDNQkDWkLmp1W0EHorQXf2FaznC9SQwAyYR7Cr7QgjmU7N2DvE4eVOqcjwPmediAK3sv2vfH8cH3bQvevGq9nHbnOQyTA4Cz33malpdttDlaDBbqDTL8h5LQ0eGhM8tB7A1iASJpQF5ubJ9OsJY7RlPj0tSedqmVBCiyJMy0ZmIgAxISbX2OdgZBoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qxfZQdJrCVH2tBg9fow0pW5u9fefy2AgrS55OK8IQG0=;
 b=IEB8WaKK5PgSbz8qRoc0RpokSCOuSf2LtcotArHzIdyrIBL8Dt+m4ArwxOi6XRoSbza724bXc7k4gPSKW/KGpCjVGi8CnqGshKVqEM15OiSz2VFWZLAhIxKO/J2Cf8KOPw2MNmML+4cjnA7B3THXRGalcq21tFiKfYcs/avi25N2f39kf8LPGiSDMUnWnQsCtuZFdxivGersChtEg0UGJrIW2GqiENrEjV1gfvukImvzQqw8XlCXhe8jo9+kZpDiA5U3BqFL/vvhh0aLCg3HH68nlNzM8NtZ2SmD8hDWTNEfxedjIZ6mHRBvyt5OSj9b6DSFzGRPWR5j6I6/Akn/rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qxfZQdJrCVH2tBg9fow0pW5u9fefy2AgrS55OK8IQG0=;
 b=Am+7S31NGAjQa5gmctwuMnHrW3SFSb9NMg16jzoQTMRsJxQtM/ok7rqR6rmWzfIn6l9m1+r+OyNMkNjR4XKoMhO5Mbv12zb5fyCPTsS0qi53dnY9tfMlF2VlaCaCiFDdFnh1MTu2jW23yNt+EDPrcfZlFKH1dwpwY7TRUbZJ33s=
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com (2603:10a6:101:1d::23)
 by VI1PR08MB5504.eurprd08.prod.outlook.com (2603:10a6:803:13b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 11:34:46 +0000
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e]) by PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e%4]) with mapi id 15.21.0382.007; Fri, 4 Sep 2026
 11:34:46 +0000
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
Subject: [PATCH v6 01/49] irqchip/gic-v5: Allow KVM setup without a
 maintenance IRQ
Thread-Topic: [PATCH v6 01/49] irqchip/gic-v5: Allow KVM setup without a
 maintenance IRQ
Thread-Index: AQHdPGFjRL5+1GTwi0WvTFoXAHzV6A==
Date: Fri, 4 Sep 2026 11:34:46 +0000
Message-ID: <20260904113404.4051341-2-sascha.bischoff@arm.com>
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
	PR2PR08MB4889:EE_|VI1PR08MB5504:EE_|MI3PEPF0000855B:EE_|AS4PR08MB7759:EE_
X-MS-Office365-Filtering-Correlation-Id: 98cfb38a-5be7-4643-b4b5-08df0a7899cc
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|23010399003|1800799024|376014|38070700021|5023799004|56012099006|10067099003|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 t6EM2B2+7oBYTsRiqetepxDcIdkkb3KXZDbL7F9E/RpzMStbMlsMM98EST5Bd3iHqSKPOLEbvOVnbA3Y/LRsQezJKUYlUaECApGBfyFV8vAhVjOKmafK3maIcGtTWtPKuPBm4Q2cIEWe6oLjr25UdLhN0qVf1DVpcMoPIMnCnUAhtmfhzEJQCCShK9IEz7gfUj9NwsjaFv8MuUmrEvOpGdNOYlE16/l0kg/IUnctIkdHvhA6x8CnPk9h6pDLQgsGewoz+fYJlug1uEQDYynu2MG17H7W17IwMvkodPnO4wt4a/xYH3K/ij091zUd3sfcHls2vfBAG/B9U7QXRFgjHeqM0zzEFLkXL8q9WAgByRG5pSsK2HR1fhLJfdgD4dQuo8orEri57hsuG976c6SwxQNVLdWET4+qH8oYCsbdlszGjoBzDT1U00duDEsQJ+kQwYHuPuoB0uhIDQp1EFIQaAy7mEQkkHFyQxS8pNsRV9wPw5GWLrX53f3rjD11ShaB/12ShTV/sV8xmNtQBUQbpbKdTh7UJtPI9Cl/IGao3bWWIy2vcRDllzgfHBk8sXr249vMeUUJKYkr3+CRFldmU7I3gjUsYfp4XD+Kc0L0Y59wa5PULoXdb5oIROdzLytQwYASURT/ut+7HdUpZmxpXaBwNoGJs/EwdEgBp7oXZyKFQ0V7rjLinmrC8Z7G7jTCnpcv7DsRB8rTJoI9rEihxB0NwFbM2DbXcWOmVXDE7pE=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR2PR08MB4889.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(376014)(38070700021)(5023799004)(56012099006)(10067099003)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 F3JbqPphsIB38L4lEnbuOX2POWQzbHm4oLeDc0ii44JQGwZCXPsqt7/ZF8/V7oAJBOSfc6aqZXq78VPFgogopA5qZjUmPGECQ6tU8VUX+UlvhYdiCElHwib/+aTY+lgEsyPLZLW758c/yC8mE1V4qqNppzgNs4ZolXX9K7518EGUWHeraxGuiQg+BXBXT2EeKzfr6IsHISQU9c8UmB3fkr2d3TRnWgGjNtW9FPtB1JchzcXw/pySHxzBOrPt8e/UW3wYh7MJVj8LAU1W3zxctHhVqPC+iQ4wDn6EmNeUt0NK5qD4b4W6XWAZ8Nz3kZ0rIzLurXdI4Y3STVk9R+F2DA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB5504
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 MI3PEPF0000855B.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	93e45b6d-2723-43e5-f62c-08df0a7885c8
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|82310400026|1800799024|376014|14060799003|23010399003|36860700016|22082099003|18002099003|10067099003|5023799004|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	mIm4kz9LGBRQRe7yfih9ZvhuU56kRhMumGbENlxz9GmO+z0OC2ubXvtO4mjHlUaVxU9kVPveT2l0dnC4+ilJOzrMO20CYMzTxy+7yBaTMNI9mCO3GCLUme9dMpbs3BwhMMG3uipHcwtskF75eC0bvu9DzdYx49mu2xWAq1TyJmbPjVMonhGF61r3J8R1ZmzkTHp5OsKDaw8OhXY9LhEdX9LweBj7UlpP4dpQPjvSFgoxCeqWnqjmuNe28112njZvYhoVqerX5/Pl2565kcEm2mhzeQG3y4dVicue0N/9hEhFrtXWh3sNSOmOfPSkE8VxHeL23tRaAnNrWDb/CHQmSSC8a0+IaCw8r2+aRE1y/f61JA8pIcMo8dj8pU3G23KyN98ihhy6rqi7Am+DRtpIU2Wg8jM3NWTH4vomYrY49plpXIwHEUtA7AJpChDZEFdablA4LyPcFf+Y0CP9pxqGZqqJBQFeRaupZXev8XCvdIS6/XvP6xk0yNenp0vzxfqvbW5ErqVFcCJ0O/zsxappL/goYhsweBft3zjpIYxrg3RoMqQ85773nKo2jky8nvnFkENP4OPGeG29EzFsMVgGJTGCpJf9wBoAMPPK/rbO4TD7WpNNNA+6dN/uImphPum7yBY9LieD3U9bQx4FjevJNlfaiQ5bCJZNjFlfw+ByJGo=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(82310400026)(1800799024)(376014)(14060799003)(23010399003)(36860700016)(22082099003)(18002099003)(10067099003)(5023799004)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	K2sZsTgFaNEkdmqMhC9/WyOVJtaKa7/K+v9dsf4jv9zkJ6CHdW1vjVq312/LgYRiPkd2YEJBss7PQrpyxoBvumZLmd3VpGaW6+4yIVc9lweDpmBtonWgr77Ek2+GCEyB5h3lvXt79Vnv4DYeyY0DxZtGx+e0ZXv5pkX6s5CUrNUl6BoJgGGuB8IYrZvbuYE8f+z49Jybd0OMR4Qujv+mNEqYeS3pTTNBcxLTm/YAa11Wo4/hQ8DCaX04UK/R5Oe2wotiorC0SbIseknkZOQPnQMyrAk7QnPiHZUvb8jbd1AHPIabOcc3jJ7++onr4TtCyP94wvF7vzdNLs629ackdzOp2QtGd1hYu3yEzCpaOLqztZyoNuzv3ajp2cQv9nRVkt9k5ksaL4m4a08S6Sq+OWl6upxMJF0+xhMXnEfaIgZ1IBbwbnbSPycfJnSKeRX3
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2026 11:35:20.0910
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 98cfb38a-5be7-4643-b4b5-08df0a7899cc
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MI3PEPF0000855B.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR08MB7759

GICv5 does not require a virtual CPU interface maintenance interrupt
for native GCIE operation. The interrupt is only needed when
FEAT_GCIE_LEGACY is present, as the legacy GICv3 interface still
relies on maintenance IRQ delivery.

Stop rejecting KVM setup solely because the maintenance interrupt is
absent. Parse the interrupt if present, but if none is described and
the system does not advertise FEAT_GCIE_LEGACY, tell KVM that no
maintenance interrupt is required.

This lets native GICv5 KVM support be registered on systems that do
not provide a maintenance interrupt, while requiring a maintenance
interrupt for GICv3-capable systems.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 drivers/irqchip/irq-gic-v5.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v5.c b/drivers/irqchip/irq-gic-v5.c
index ac2d423b17239..0950bb9bb2814 100644
--- a/drivers/irqchip/irq-gic-v5.c
+++ b/drivers/irqchip/irq-gic-v5.c
@@ -1137,10 +1137,18 @@ static void __init gic_of_setup_kvm_info(struct dev=
ice_node *node)
 	/* GIC Virtual CPU interface maintenance interrupt */
 	gic_v5_kvm_info.no_maint_irq_mask =3D false;
 	gic_v5_kvm_info.maint_irq =3D irq_of_parse_and_map(node, 0);
-	if (!gic_v5_kvm_info.maint_irq) {
-		pr_warn("cannot find GICv5 virtual CPU interface maintenance interrupt\n=
");
-		return;
-	}
+
+	/*
+	 * We require an MI if we have legacy support, but don't, otherwise.
+	 * Given that there's an existing flag to convey that an MI isn't
+	 * needed, we (ab)use it to tell KVM that the MI isn't needed if we
+	 * don't support legacy.
+	 *
+	 * The check for ARM64_HAS_GICV5_LEGACY explicitly doesn't use
+	 * cpus_have_final_cap() here as we run too early.
+	 */
+	if (!cpus_have_cap(ARM64_HAS_GICV5_LEGACY) && !gic_v5_kvm_info.maint_irq)
+		gic_v5_kvm_info.no_maint_irq_mask =3D true;
=20
 	vgic_set_kvm_info(&gic_v5_kvm_info);
 }
--=20
2.34.1
