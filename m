Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011048.outbound.protection.outlook.com [52.101.70.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AD183AFCE6;
	Fri,  4 Sep 2026 10:49:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.48
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788518954; cv=fail; b=SnwlVvABVfCqg9rsVh/LgHt1muLAWAnWIu2P+AZtfAG5+jXTyUU/dfpEUtY10B9+Tp0InE7gkTCiIgZrv+nGTuaVsGbYARE+v7SDtpKyJ/e2/rPGpieoLS0VDBjeTEn2fpBDqvnwXu2ZgJ2INnQUe9hzdRoUOMYc6GqOhZU2jNw=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788518954; c=relaxed/simple;
	bh=JY6qFbqCUNaYN8yPfUtQQN3RrGNDtQkswjOllz+Pj2A=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=H3LXA7f4bzmCrAWHp52c3h9n1bz24dQvCfMIeVk1xz2xWmMsLJeOWXiVZjky9ke3NvjOuWSiLDdhDco2OtSewcNfodE1UXQAVpktQ49BucnSrx2Tbkq5CFMvCjoS51+BH6IWfXVOpT3NpPz3RD5fbKeFygM8NKn5WyxMOrRSut4=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Zl25MxLp; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Zl25MxLp; arc=fail smtp.client-ip=52.101.70.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Zl25MxLp";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Zl25MxLp"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=R9YWg229RE+oDpq8yNM6n41wEilgsB79sQOZyyUcF7L+/7XTbxP8JXMwq1qE2y/cQHIVUkB4ZvTWYj6ODsr8Zraa9xROwGaMy/zPzvXu+8rPI3cQ2oPBUIVUpNl5sMvblM6CO/3e0QACSJDBYxx4TE4XhUcQW+BnTsSqnwHMNOXh9pL2F0f6XIPqXDmjngWjc3HGzgp/Jibz5I7aIsvostHxQC2WKDZhnLNz+YoQDm58ngiPlhTn3RA8fnoEKv6+LJuUR/0J2KmYbLvnv6ysLD2OXeMNmZYEShtK7wP6K4rMR+mnXtVtAxka+rdpPkqgWMI0GkrSzqbngGP8iNqB6g==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JY6qFbqCUNaYN8yPfUtQQN3RrGNDtQkswjOllz+Pj2A=;
 b=orht2k33ar9RBmgyONnoG9iRwdhkTu7HMQx0LQNedgYjwiqGKhzjAK56AEAaP4rotw4OQUGsNA2ftUyBHN3w7TPmfmHisngHr+s91nU6/hZqLW6CyWij5tC79Y7x6K2CVCmFIwbY4tKsHgPqzvsqBjL614Da73qUfSR4/+c5YkfbzhwL0kYQX3akN/1upTBkfMwY3IJlCxL2dxeJ7k7V0Uw3b9I1P4yGUF4Z3naht0AnYHvbJPNAsCofdFIBoR41cuO4zGykAy85sw8dVDk6Z6WNX9lUYTwrW8+X+iZo4TX7scrcllXcBAhnzs+qRdyjGWa//ovY0sGG2/JbyFMcbQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JY6qFbqCUNaYN8yPfUtQQN3RrGNDtQkswjOllz+Pj2A=;
 b=Zl25MxLpn1pLaTdFnJPZw/yghrosD0HviMiPa6yesD/Fn4WLeadQQ/wozPzgMkjS1l6nxTRnHSTxznR74KNv6Hw/bsD0fvbWhJhBMlr4y/cr0dYw4gGjXk3nZMkQYWSTv+gv702bqjtJKc/QpOSl0v3wR53hwh1drMpsctmVrZI=
Received: from PA7P264CA0119.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:34c::12)
 by ZR6PR08MB524761.eurprd08.prod.outlook.com (2603:10a6:910:dd::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 10:49:08 +0000
Received: from ZR1PEPF0000E463.eurprd04.prod.outlook.com
 (2603:10a6:102:34c:cafe::54) by PA7P264CA0119.outlook.office365.com
 (2603:10a6:102:34c::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.12 via Frontend Transport; Fri, 4
 Sep 2026 10:49:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 ZR1PEPF0000E463.mail.protection.outlook.com (10.167.241.56) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.8
 via Frontend Transport; Fri, 4 Sep 2026 10:49:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Io0Wf2a018kuaebinky4ueyJOPN/y13XQcd7E5CVWqiUN+InNpZ/Aw74nKxpXhMK0e9ccxEv35/dZHN84kcuWk0BxGCyC6Nx0xqA6jdCvgtOfs+fYNbXaqFxBKeagJofjPWurGp8H0Qmls6TMJfdNP1tHA6KGfLPSoNwutezUrY7cCe5zQ6tlw6CZUFN+/E96aBNgpKIbfLZHI64+616o8swDCHudW7/5N+Z+7PV+1I7v4VLKRaMInsa8c/AqmCAbAiPCplhJR/k8J48sI+yhVAiTS2lxJDaFp+sufp1XU2+Qa6yzIBiM0GIF14m9SjVVFy1S4l0fDOU84jpM4rp6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JY6qFbqCUNaYN8yPfUtQQN3RrGNDtQkswjOllz+Pj2A=;
 b=Gm4ptLG4l7qS1m+TKKGlPabNrLQv6TZSwz7ztVUhNGL0+2Y9jJ0UYDO4ore0vSbioz+wWyNL4UFgwsqF9hvryMYLYDX7hkifR+Kq8KzmFYZI7bl8isMUIlbDp6j+xXge00aMGZ4EEtJKAicZsZHMgrbdw+x2lW6iZhs5Vhd/8+qh27XoQTYVrcBLyBMN6Wnzg8qsHHof31vHWf4/d7M6LWWz9YKYB2IaV5l+eRo8hb+aLHXK8pP8z86yqShrl3mwz34SI09gLEmS/SkTVmYGQmjEYpzbfO7lovPPi+0BPsP7wxmfE7uM2hbi9tY/P01i3q5bNG1JRSTbEoJGJSZZ4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JY6qFbqCUNaYN8yPfUtQQN3RrGNDtQkswjOllz+Pj2A=;
 b=Zl25MxLpn1pLaTdFnJPZw/yghrosD0HviMiPa6yesD/Fn4WLeadQQ/wozPzgMkjS1l6nxTRnHSTxznR74KNv6Hw/bsD0fvbWhJhBMlr4y/cr0dYw4gGjXk3nZMkQYWSTv+gv702bqjtJKc/QpOSl0v3wR53hwh1drMpsctmVrZI=
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com (2603:10a6:101:1d::23)
 by DU0PR08MB8471.eurprd08.prod.outlook.com (2603:10a6:10:405::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 10:48:33 +0000
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e]) by PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e%4]) with mapi id 15.21.0382.007; Fri, 4 Sep 2026
 10:48:33 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "sashiko-reviews@lists.linux.dev" <sashiko-reviews@lists.linux.dev>
CC: "maz@kernel.org" <maz@kernel.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"oupton@kernel.org" <oupton@kernel.org>, nd <nd@arm.com>
Subject: Re: [PATCH v5 47/49] KVM: selftests: Add VGICv5 LPI delivery tests
Thread-Topic: [PATCH v5 47/49] KVM: selftests: Add VGICv5 LPI delivery tests
Thread-Index: AQHdJmD+kEyRawFw+kS79lYoQsgFe7aS2qCAgCuOeAA=
Date: Fri, 4 Sep 2026 10:48:33 +0000
Message-ID: <681f9634be11e9b7b636b0730d80a71b8aa38776.camel@arm.com>
References: <20260807111159.429128-1-sascha.bischoff@arm.com>
	 <20260807111159.429128-48-sascha.bischoff@arm.com>
	 <20260807173928.3F6731F000E9@smtp.kernel.org>
In-Reply-To: <20260807173928.3F6731F000E9@smtp.kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	PR2PR08MB4889:EE_|DU0PR08MB8471:EE_|ZR1PEPF0000E463:EE_|ZR6PR08MB524761:EE_
X-MS-Office365-Filtering-Correlation-Id: 5a732f33-1c8a-45bd-29df-08df0a722580
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|23010399003|10067099003|38070700021|11063799006|56012099006|3023799007|4143699003|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 mNQjgXrfGuls8hiFK8n+7ZjbB3ykPs2bOoQgDHzfJ+CF8p0FiTgpaJltwXseTEmQ7OR9WPcBo0gnUro2ysVhsIqmMJr4W2zdwibwXscs5rLWqyvz9EUmGU7f3NEtfqMSEYFi/f6V3/W9tpf9OX/8VgbQYQoRSbQeaFkI4s3rqgyTb3m0topvRnfIDRQAK2TGvt2s9t6pjBEveaGA6jInVlmIdBowJN7yIPJRQxhzKbyFdU3BBhjt8nwAkWviVpzSVSYqd0fADfLh10PHrIOtXOwX7t3MuO0PIzFtxWCXq81bcSWN7Go9ToW4YlNwXuVMNprtLXGVwaa7atjHCz/XlkoWyczUhznaD/ncFTZOFDZGlO4hEjgYtcjREgp34uX9jdA4mknVAiK0boJ+QgZQJ6rUvLRtYUORJup10N+ed2jGmDBkgPDG/wjCaugrScni9xaJy1kb3/2CQHvu3w/KPS+G0G/xPZl6vhge8J3aNojyTaA+edQ4z7IzSonTgP+ICokuTHWPS1FtioS4bB/94/5j3ws+4qz/BM6yrbGbhM2lWVsU1rEJTk6XyaUyaQCuJeUOEIoGZHEZwaL/wnfNRnJeP1jY5V/4LFGOmGm6tN1loiOVp+yydJTaZtVNTQ+wcy0F/NEMU+KZaJzP8DVUUuO7sBRkJRqsI3JTRjvRIC8miKPwGG5Y5DvmLatDBKf3ArYEh4oIluZZo2MozmJWsOGSQrLZvctUUDuT0mIVE+Y=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR2PR08MB4889.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(23010399003)(10067099003)(38070700021)(11063799006)(56012099006)(3023799007)(4143699003)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <3C0294FBC3E2474FA9A703772611A94E@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 28zGgD1zVGYLXZpTGXNpzDmFq+Xngiyft5rrdB5zmHDPYT7hjinvMT0Kr7xEzO70CqY6qBLNXVrTcdGhy25AvX3PltzkSQryHZ+NLjD10NBXMnyPnXeIb5EyQHPMQCSEsbMsBtmVjcSWwnr94BvzGUX4L+9GI0IDMefeIMqUBY0Ik6c0+c3qWaQAa+XCIV8g1U5RUUfXmH6WBjFIbqGJUshttnQzNGA0qF1jT2X2kVBEU1+kZr4HdwVzmhVmgGWiXCNdWmf4NHuPad58swBdEz/mx7s3s2nrstAPGSjSvbg/mzzxMdzyMau78Ce+IdftV7cyS4pxnE4JuaZKu4zDPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB8471
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 ZR1PEPF0000E463.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	cc871901-2182-4ccd-1349-08df0a7210fb
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|35042699022|14060799003|36860700016|82310400026|1800799024|6133799003|10067099003|4143699003|11063799006|18002099003|22082099003|56012099006|3023799007;
X-Microsoft-Antispam-Message-Info:
	agROY6HHX/ArIfjBt+DM1CcgZnePS5TTt4bXmw5C1+XYxoKKR/nbGwcYlaXU8H6/sCM//lP4Y1sUmSNY/A5RP8bw2/CFxe2sAyIa11iFXRXHUC1ycKgJPS2GDSKtnyNiVEhUG1btUXP8K9Wi+5U0g5Od1KXA5VYOUW/G0Lg8nIGT13FIkvf/vW+ZGQccO8BCEGexFq9SBYLYieT1Gl9oSa06PVN3N/GFEycsRHqSuoMxpjnoVHYJlaHXm6FXvA0DfgUv0tR26EOgcEMkRJtyxyf7REiT/45TfzyG23azqeC30U998LIbKjbksHD4h7KZcHFXJJOhwfp/AUEhFcVLrhrxPVHfco2FYZ+CyAdu3fK8e5qS9VhF97Uex5iTpZxTtUiBwTlm1GiQhU21sZy2yhgQYZkeCOeiLashD/KFBIsbVq9CNPAG1emhRNgMZEIpEuSizHEbi/yq5zIBYSRlU+I8Xm+w2q+a1JAyuuOWT6GMb2bHAE4dBhW92n/x9QdjUadwx5l+BhY7oGZxP1tlDBGSSEu05zqk0wJ5GdKZRrU9KD76Ub+5VsrQtFYDTrzVjqrNJISXyuzA60qkOZxVUswmoMdoRgKMb6ZDYDaoNGb2686HDg+IPqXHOlJ9JQA415cyGecLnuNGXLW2O3j8ATiF0cWrGKd0MMInzFgv05M=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(23010399003)(35042699022)(14060799003)(36860700016)(82310400026)(1800799024)(6133799003)(10067099003)(4143699003)(11063799006)(18002099003)(22082099003)(56012099006)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	2HkZcnaNFXeiCz3+AqCyJDG+R+MnmvsZCccoZFgtR0UFpgfPR3tzYtmDwcKOIird7i4C0xxZULk72Yl+FhG86tRlgl20sYQmkKI7XpdpG9g727PHc44Z2x9/lrkxtFfAweVNjXkAYhjuzCLCtqaUjtwAEw8GXqgscRIJXP1+8OI4WMIcVYXG/KlekXanxsFt/w3LB/Ril5JCLNadak/5UcDe0EVFsYWzs9HjX0WGOikXgq3mh21clRSEOzGRafeKLjMIkbTix/Px7LEjC3d+RtycfavkeJb78OFMVtLm5SVEHymU12aRCuRZpGv5SB0+lUGJLOnQqElWj3alcALdwRss8jD3lVQyKaeokaVCkeR4umsnqDPgCg3FQddaJKPfFifMuZXgMl3GPN66lND9BG34TvRzSIBxVjOXMCw/WJTg3sC0Oi7KB0MRtJcVjnHG
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2026 10:49:08.0050
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a732f33-1c8a-45bd-29df-08df0a722580
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	ZR1PEPF0000E463.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZR6PR08MB524761

T24gRnJpLCAyMDI2LTA4LTA3IGF0IDE3OjM5ICswMDAwLCBzYXNoaWtvLWJvdEBrZXJuZWwub3Jn
IHdyb3RlOg0KPiBUaGFuayB5b3UgZm9yIHlvdXIgY29udHJpYnV0aW9uISBTYXNoaWtvIEFJIHJl
dmlldyBmb3VuZCAxIHBvdGVudGlhbA0KPiBpc3N1ZShzKSB0byBjb25zaWRlcjoNCj4gLSBbTWVk
aXVtXSBUaGUgc3lzdGVtIGluc3RydWN0aW9uIEdJQyBDREVPSSByZXF1aXJlcyB0aGUgZml4ZWQN
Cj4gcmVnaXN0ZXIgWFpSLCBidXQgaXMgZW1pdHRlZCB1c2luZyBhIGNvbXBpbGVyIGNvbnN0cmFp
bnQgd2hpY2ggbWF5DQo+IHNlbGVjdCBhIGdlbmVyYWwtcHVycG9zZSByZWdpc3Rlci4NCj4gLS0N
Cj4gDQo+IC0tLSBQYXRjaCBbNDddOiBbUEFUQ0ggdjUgNDcvNDldIEtWTTogc2VsZnRlc3RzOiBB
ZGQgVkdJQ3Y1IExQSQ0KPiBkZWxpdmVyeSB0ZXN0cyAtLS0NCj4gY29tbWl0IDFkY2EzMTMwODYz
YzA4YjBjM2ExOWUwOTI5NGRmNmVkZDE1MzRhMjANCj4gQXV0aG9yOiBTYXNjaGEgQmlzY2hvZmYg
PFNhc2NoYS5CaXNjaG9mZkBhcm0uY29tPg0KPiANCj4gS1ZNOiBzZWxmdGVzdHM6IEFkZCBWR0lD
djUgTFBJIGRlbGl2ZXJ5IHRlc3RzDQo+IA0KPiBBZGQgYSB0d28tVlBFIFZHSUN2NSBMUEkgZGVs
aXZlcnkgdGVzdC4gRXhlcmNpc2UgdGhlIHZpcnR1YWwgSVJTIElEDQo+IHJlZ2lzdGVycyBhbmQg
SVNUIGJhc2UgY29uZmlndXJhdGlvbiBwYXRoIGJlZm9yZSBjaGVja2luZyBpbnRlcnJ1cHQNCj4g
ZGVsaXZlcnkuDQo+IA0KPiA+IGRpZmYgLS1naXQgYS90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9r
dm0vYXJtNjQvdmdpY192NS5jDQo+ID4gYi90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9rdm0vYXJt
NjQvdmdpY192NS5jDQo+ID4gaW5kZXggMjNmYmQyZGI1MGM0My4uNzFiZGE1NjYxYzc0ZSAxMDA2
NDQNCj4gPiAtLS0gYS90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9rdm0vYXJtNjQvdmdpY192NS5j
DQo+ID4gKysrIGIvdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMva3ZtL2FybTY0L3ZnaWNfdjUuYw0K
PiANCj4gWyAuLi4gXQ0KPiANCj4gPiBAQCAtMjA5LDYgKzI5OCw2NyBAQCBzdGF0aWMgdm9pZCBn
dWVzdF9zcGlfbGluZV9jb2RlKHZvaWQpDQo+ID4gwqAJCXdmaSgpOw0KPiA+IMKgfQ0KPiA+IMKg
DQo+ID4gK3N0YXRpYyB2b2lkIGd1ZXN0X2xwaV9pcnFfaGFuZGxlcihzdHJ1Y3QgZXhfcmVncyAq
cmVncykNCj4gPiArew0KPiA+ICsJdTMyIHZjcHVfaWQgPSBndWVzdF9nZXRfdmNwdWlkKCk7DQo+
ID4gKwl1MzIgZXhwZWN0ZWRfbHBpID0gdmNwdV9pZCA/IExQSV9URVNUX1RPX1ZQRTEgOg0KPiA+
IExQSV9URVNUX1RPX1ZQRTA7DQo+ID4gKwl1NjQgZXhwZWN0ZWRfaHdpcnEgPSBnaWN2NV9scGlf
aHdpcnEoZXhwZWN0ZWRfbHBpKTsNCj4gPiArCXUzMiBod2lycTsNCj4gPiArCXU2NCBpYTsNCj4g
PiArDQo+ID4gKwlpYSA9IGdpY3JfaW5zbihDRElBKTsNCj4gPiArCWlmICghR0lDVjVfR0lDUl9D
RElBX1ZBTElEKGlhKSkNCj4gPiArCQlyZXR1cm47DQo+ID4gKw0KPiA+ICsJZ3NiX2FjaygpOw0K
PiA+ICsJaXNiKCk7DQo+ID4gKw0KPiA+ICsJaHdpcnEgPSBGSUVMRF9HRVQoR0lDVjVfR0lDUl9D
RElBX0lOVElELCBpYSk7DQo+ID4gKwlHVUVTVF9BU1NFUlRfRVEoaHdpcnEsIGV4cGVjdGVkX2h3
aXJxKTsNCj4gPiArDQo+ID4gKwlnaWNfaW5zbihod2lycSwgQ0RESSk7DQo+ID4gKwlnaWNfaW5z
bigwLCBDREVPSSk7DQo+IA0KPiBbU2V2ZXJpdHk6IE1lZGl1bV0NCj4gV2lsbCB0aGlzIGxlYWQg
dG8gbWlzZW5jb2RlZCBpbnN0cnVjdGlvbnM/DQo+IA0KPiBUaGUgc3lzdGVtIGluc3RydWN0aW9u
IEdJQyBDREVPSSByZXF1aXJlcyB0aGUgZml4ZWQgcmVnaXN0ZXIgWFpSLCBidXQNCj4gaXMNCj4g
ZW1pdHRlZCB1c2luZyB0aGUgZ2ljX2luc24oKSBtYWNybyB3aGljaCBleHBhbmRzIHRvIHdyaXRl
X3N5c3JlZ19zKCkNCj4gdXNpbmcgYQ0KPiBjb21waWxlciBjb25zdHJhaW50IGluc3RlYWQgb2Yg
YSBoYXJkY29kZWQgcmVnaXN0ZXIuDQo+IA0KPiBJZiB0aGUgY29tcGlsZXIgc2VsZWN0cyBhIGdl
bmVyYWwtcHVycG9zZSByZWdpc3RlciBvdGhlciB0aGFuIFhaUiwNCj4gdGhpcyBjb3VsZA0KPiBy
ZXN1bHQgaW4gQ09OU1RSQUlORUQgVU5QUkVESUNUQUJMRSBiZWhhdmlvci4gU2hvdWxkIHRoaXMg
aW5zdHJ1Y3Rpb24NCj4gdXNlIGFuDQo+IGlubGluZSBhc3NlbWJseSBibG9jayB0aGF0IGV4cGxp
Y2l0bHkgaGFyZGNvZGVzIHRoZSBleGFjdCByZWdpc3RlciBpbg0KPiB0aGUNCj4gaW5zdHJ1Y3Rp
b24gc3RyaW5nPw0KDQpJIGZpcnN0IHRob3VnaHQgdGhhdCB0aGlzIHdhcyBub3QgYW4gaXNzdWUs
IGJ1dCBJIHRoaW5rIGl0IG1pZ2h0IGJlIGFuDQp1bmRlcmx5aW5nIGlzc3VlLiBGb3IgY29udGV4
dCwgdGhlIG5vcm1hbCBrZXJuZWwgc3lzcmVnLmggaGVhZGVyIGZpbGUNCmhhcyBhIHNwZWNpYWwg
Y2FzZSB0aGF0IGZvcmNlcyB0aGUgdXNlIG9mIFhaUiBpbiB0aGlzIGNhc2UuIEhvd2V2ZXIsDQp0
aGF0IHNhbWUgaGFuZGxpbmcgaXMgbm90IHByZXNlbnQgaW4gdGhlIHRvb2xzIHZlcnNpb24gb2Yg
dGhlIGhlYWRlcg0KZmlsZS4gVGhlcmVmb3JlIC0gYnkgbXkgdW5kZXJzdGFuZGluZyBhdCBsZWFz
dCAtIHRoaXMgaXMgc29tZXRoaW5nIHRoYXQNCmNvdWxkIHJlYWxpc3RpY2FsbHkgaGFwcGVuIHdp
dGggTExWTS4NCg0KR2l2ZW4gdGhhdCB0aGlzIGlzIG5vdCBhbiBpc3N1ZSB3aXRoIHRoZSBHSUN2
NSBJUlMgc2VyaWVzLCBJJ2xsIHBvc3QgYQ0KZml4IGZvciB0aGlzIG9uZSBzZXBhcmF0ZWx5Lg0K
DQo+IA0KPiA+ICsNCj4gPiArCWlmICh2Y3B1X2lkKSB7DQo+ID4gKwkJZ2ljdjVfc2VuZF9scGko
TFBJX1RFU1RfVE9fVlBFMCk7DQo+ID4gKwkJR1VFU1RfU1lOQyhHVUVTVF9DTURfTFBJX1JFUExJ
RUQpOw0KPiA+ICsJCXdoaWxlICgxKQ0KPiA+ICsJCQl3ZmkoKTsNCj4gPiArCX0NCj4gPiArDQo+
ID4gKwlHVUVTVF9ET05FKCk7DQo+ID4gK30NCj4gDQoNClRoYW5rcywNClNhc2NoYQ0K
