Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013007.outbound.protection.outlook.com [52.101.83.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69AFD286881
	for <kvmarm@lists.linux.dev>; Thu, 21 May 2026 14:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.83.7
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779375125; cv=fail; b=jz+emIVRNQ890CD0CLqEuNMr1x+Nlu6PxWZOUtWYuIzOFaqfcdlDKE/kTplNjhiGbGd6AgtSheK056vxV/FHHsuZCJPoWTc2SYf04zmy5jgUql3dPy1Y8vd/dYrssKNwEEejWSXkQOVXVJE6hP4T1RuUkysiFp0Z/u25MhCP+m8=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779375125; c=relaxed/simple;
	bh=jiVRWQtYDuKNoNPPK1Q3vduv08rlg+8XYhv/gWMxTF4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=nOSh6mAmjg9Z+ktn7HJ1e2Vf1ejdbIFMsICozgMI1Eqx5nxmei/mMs0gWFqLj5btT08fKRF0feuXPMCsM5Psobao8IsnrYPGY8acLHmsrctNGbIkUC3I7Azi5432vT7s6jv5OfYqo8yZ08Ufs/CxtZwmum8XKMImFCVa5QAqPfo=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=GlyHlGkM; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=GlyHlGkM; arc=fail smtp.client-ip=52.101.83.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="GlyHlGkM";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="GlyHlGkM"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=fail;
 b=VJk9Lb3RMFYpvb6rcYkhHe5TCKNOslcBp4msGqrwUnFawD51f2P2aj8vGPWSih3QXm++dDVMMh+Ed3lwRqfkzalUuyFEiMq12QNoLBVJiHbTYp430vluw/RS2MPgwlNhpxBaBkdA5VKuevr73AUj/B19paRN7e1YmWU08N88XvYs6yGSXizCstUlI7KwB4fZsKlbVu8YOnukjZthg/gg1pNgHbtwzvoTM82kWDOsZ18MFM0GEzWpxyPg5plzQZN83G7CDOwS6rRw3WUbcngrFpDpIWS3XQRx4PuXXrs6mQ2xu6wMetpZJzjzo4GBEKfLB0U8ox9uZRkOcoFGBge0ag==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uDoVGaRL3vBISbPI/XBhD+TTeHP0413aN2VV9e64IgQ=;
 b=YFaPvTvDFMc3iLYVh142vUsdw/ie4bAY3H9eQNHzymCMAM67TG2TQlErT4zlIPEAOR6Wnd6WQ6Vr/fJ1EmtQzkKt6kUJ+hLvqRJbLVLSuOjNRJHE0xusrg0Cp/UPFVK4MzBkocvlpxXrdnJSOj9aK22mOq0YZjggm91JRem9NL0o+GaBCBChQ9Qco+dqkjnCGJXRdIs4M+yavEbonsjbCpRG5AZcIXEk5joQVSemH6vJR268v1olKPW8J6E1eIUXYQhxTp0SEkfrYyG8D8ebYTQQesIyZi/C6AIu8yt2ef+LjePFmolVcHQ5+5MbQNt9YvprILSuvswhfWgdCYwVTQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=fail (48)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uDoVGaRL3vBISbPI/XBhD+TTeHP0413aN2VV9e64IgQ=;
 b=GlyHlGkMxHPuisusPfDG4v9wRef4tGNBkI62ImaevddzqXXk7loaqslYsArNKGnAZIvhJayvZi9YXxCPKRTVtHKjSbcOiDTjcupxB297ETbMgguIGaRpK0BwTnTnrRcIOZIbDosxsOC2iZ6frH2/z6/ua59crB5cAu3PY2R2/vY=
Received: from AS4P192CA0043.EURP192.PROD.OUTLOOK.COM (2603:10a6:20b:658::9)
 by GVXPR08MB10891.eurprd08.prod.outlook.com (2603:10a6:150:1ff::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.14; Thu, 21 May
 2026 14:51:54 +0000
Received: from AMS0EPF000001A2.eurprd05.prod.outlook.com
 (2603:10a6:20b:658:cafe::3) by AS4P192CA0043.outlook.office365.com
 (2603:10a6:20b:658::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.48.17 via Frontend Transport; Thu, 21
 May 2026 14:51:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF000001A2.mail.protection.outlook.com (10.167.16.235) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.71.7 via
 Frontend Transport; Thu, 21 May 2026 14:51:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VjOTqPAl5SDxlsN+fyasI4F+3YI5hck2ULvufNW+a08XeOCpGdMtdv6SXPUOhvq9JkrE/IMRme+o3kJKdZXkc5kV/Cvg3+4bAoAJsAjTqYIim/3cd+vO2kRgfDHL2sFvDuCY2izIfuFXNLLxz85ufQ1B1VQf3mpoN4lcUVqjBOhobFf8u7mTbNmxK7apilcY2SnTy/KrEsGu3/kK5jTFEOXyYb+MgVzMLmCLwVU9c87j5i3uX5+8/2nEj0alkGL4H7DrAsB3oDsDsSzxnt208xyO8kbfeeNHp7NF6/fEPHfSpzA4qEP8ah8WcRE8OLZvkdAguYo8SOwddJoDmdmviQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uDoVGaRL3vBISbPI/XBhD+TTeHP0413aN2VV9e64IgQ=;
 b=YELRVKOoMszcMq9fi/PhRqEnEV8j8PceH5vcT1VY5ICUvPWTESJikzrjSIBwv8q4M92YJvjLbubOVB/K6h6oKP8a1ScPraWWzLmQOodA1OS0nVhefHNEBuK61o2Z2XNSMbBDfzaGGZVqAP4U1rr5U4txEaUelsI2kWmVLcwR9i1rK97r7TCwrpBX5QDaVEkTI//O8K8fdgJkQgt8/x4ELBNdpL/cr1tU+epDOJadPwHcHwrUvGaU8wetE5q0qkh4Q08yFUiM4pK8ZIC4GmmHWYUxutj3wuGI5+G7PwBOpTI5OKweFpqO0z1+xzzGpffc8U9bdpsoHZNPe6XdMRJ1sQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uDoVGaRL3vBISbPI/XBhD+TTeHP0413aN2VV9e64IgQ=;
 b=GlyHlGkMxHPuisusPfDG4v9wRef4tGNBkI62ImaevddzqXXk7loaqslYsArNKGnAZIvhJayvZi9YXxCPKRTVtHKjSbcOiDTjcupxB297ETbMgguIGaRpK0BwTnTnrRcIOZIbDosxsOC2iZ6frH2/z6/ua59crB5cAu3PY2R2/vY=
Received: from GV1PR08MB7315.eurprd08.prod.outlook.com (2603:10a6:150:1e::15)
 by VE1PR08MB5856.eurprd08.prod.outlook.com (2603:10a6:800:1ab::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.17; Thu, 21 May
 2026 14:50:50 +0000
Received: from GV1PR08MB7315.eurprd08.prod.outlook.com
 ([fe80::c249:1aed:a4c2:4193]) by GV1PR08MB7315.eurprd08.prod.outlook.com
 ([fe80::c249:1aed:a4c2:4193%3]) with mapi id 15.21.0048.013; Thu, 21 May 2026
 14:50:50 +0000
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
Subject: [PATCH v2 05/39] arm64/sysreg: Add GICv5 GIC VDPEND and VDRCFG
 encodings
Thread-Topic: [PATCH v2 05/39] arm64/sysreg: Add GICv5 GIC VDPEND and VDRCFG
 encodings
Thread-Index: AQHc6TE3g7jZMTkpm0SRDPI6PXDP1g==
Date: Thu, 21 May 2026 14:50:50 +0000
Message-ID: <20260521144846.1899475-6-sascha.bischoff@arm.com>
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
	GV1PR08MB7315:EE_|VE1PR08MB5856:EE_|AMS0EPF000001A2:EE_|GVXPR08MB10891:EE_
X-MS-Office365-Filtering-Correlation-Id: 09d44e51-aae4-49b8-f5ff-08deb7487ffe
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|38070700021|56012099003|18002099003|22082099003|11063799006|6133799003|3023799007;
X-Microsoft-Antispam-Message-Info-Original:
 yG8JdrJCS/A8nMbkWG0UyBWP1pL+BjPXcqNZBk3I0RbvbHeMkxJ51OiwvfPq5WtY9or9NC3Jl3suc98BrYp7Fgno0liU7jzMQxFxmG0iv5QrhBLDLa77OVcYKPPGsL0qZfg3s08GH97UAkfd4ptDNRCtjhu2+mt6W2hYmM0/UYqYgwP1oREXCTQUzgpgu1KYmg+uSmVuyMpeA18ZUsAgw80Fu6TG10Sgu2rWep7qnZOkoEmyAt7DoTC8puqxNkKn0tbR37DrR4ZALBxhWsYNFkuJFR/FF3CvOy14TiH44m357pT0dEnU+VLGi6XE/vqxVqOyy+ztqRbdSH5k5k8ort8A5pLJuo+0W6pNyNahZpPeq+LfRGBYz5lLrCUeJu4XkfQFzw1hl7AXjKQ+TK6HPVspd5iO+y1ViwF2hGzAoGAuoovmnZgQbvoXuokhJVnJGMDcOrXVqTBIMlD30W25sMpZoYWeU0c8ULPYxw6xUXkNipH2hEZfQDabnvn99xqplsHNPuQjx0Sdtz8bTBf651mwd24ATnZKKIaPxkceyYGSPmvY48cZaM0aMg2NwwBJzcrNB7xqadWV8D2ATSV6+cXZ3aXYyWBRLCvXjxU+h0NZNmhFfHjRBkqSQxMbH1qsdmuPHBY5gZqoyythBQwjOgClhP5IMScRzVXazsUeJ7bMa3m0tNKQ1pYg9mKEPmutbEZ5DrHC9FawiVc5TGu2u4kY35zNWrfHzg5OI3aLcPrxVw8Ww2dC2bF4wWFXdm42
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
 LuMizswpFVqFm8GPNC+qRggyRYcFePROw7V6+E+Hg/dMaVtUDHFILpv3Od8ZizBWS5R+Ws1HmKwo/v3UTJrJvDWkKC4ahpkpL4kUV1Qzq8NfnaqX1bi24KNW4Zxh5RiwzqxsjNc+mRCSFfWcrBPEskebZEHJnxaUq5gfa5+lrTisuSnrRVHwP/9IimE3eEBwr1qkB8ZnZEOlHeNzlSNxJd5ivz3PrGqf1AWFGjVSyQYI8A8W4/6aFVOmpNhYoJuO9j9yXwZoWrQ48YlIJqj6Gqvv1p56BXRTFoHkBizgenUAK9/9jCvU6I6+t4Dr/IfgWR454xuvCfKC/hazLy9nEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR08MB5856
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF000001A2.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	c110afa3-434a-4f48-c69a-08deb74859e5
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|14060799003|1800799024|82310400026|35042699022|376014|18002099003|56012099003|3023799007|11063799006|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	A7XDChXAqfStQczFsq+K1sPr3MHdfEy/VwQJh0p5q85/yxy/T4Tqh09q5z7QHj17hzfit7ODL59P+xbEEt/BvFeYoIBJx/PZHf8eCfysEWquGmt5r0Ub2L1WDBIoy0OhWWZNgJtkdNYb+8dCwv2e74TcY4v2r6iGKKlJ0CaonMx74ib31KvIyufyrj41Z7huhMswgTF9YaQkQTvgOaX1/H5rzzld70+Qb/qeuoaZehTPuVDfX2Cq96RVnYdhL+sCnk5WYLy0nDifpBQw7pUM/kWhNcEZ3OvODA27RhqSj2k1NvIi3kKQL0jR4Jn+J37R6jj0ZsnVG9sjzHjR2/v3IZ3d/QpoogNgcO6AZWbk730lJM0qbQ51mMhcrlJt453J5u1eqsgmKGFLhydU6LsJlIg4kjnQYklD/T2P4xKiCWc5gWSxPB4GT9zEQhnc9FGQuktqVd9VppMbB21t3At08N3QNlzlq2wnB8YeaNYQz6z+IVl6WGpK0JaqoynXJkzG9zTWgF61631/COBjsaOREcjNNS3kvO8l8m6D5YM7GW9ZPpwjgf4CLX08uKgyT4XTrn0kKa7O/RKZKMNTBr5olO62SDVnBo0fJO6Udq647X53zaHWAViOr5cA3rZp+kScki3Axn8pyreHA0pUWcsrp3FAdortGR3rXaTYUMh/anU+dekd8RxI7X8f7mBpq8UgOKPfEbrNo5kwzsIXc3RAI5JDL4zqwhu1agkB/UseVYI=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(14060799003)(1800799024)(82310400026)(35042699022)(376014)(18002099003)(56012099003)(3023799007)(11063799006)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	aSEi4zZWIF66lY+1ZlE3o5zi2CHQ0WQoFuIGqgYgdwJ9Bn1HdPJm9XvHvIJT4P/UqiW+QhlBaKod1+HZ1OmYk273DjCbmfD6bUhqmdRWWdk9YkaDP/xs6iU2mWezf245FLxig673alIw4cjZASaK/IP+VgXi8bDg41RY3oEAV1sH7By9+LsQRx/jjvAnlzU6NTMBswkuWp0gHcpbX97Ujljq0J+SGjd2TSke8vlNDvPpW4J6TDMgcYBkdMDMOnuIzR9u8+mSWEpGUNlcmQJOkAMwv81x3vdSXteepVxKKUPcpTHR3+Nh+8jbZZYZgzOh3I75kkZ2VLy5oMKCy/S1QMlt7P8mKGqpFAAjOfULNOYBYORHbwbplITFznd0tLITTGXcxGNRsY3HVhXl2H/TXohSCLOhEZ0AzpkRhmOgbOS8VqK8TYXXet7R5IefkFSR
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2026 14:51:54.5240
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 09d44e51-aae4-49b8-f5ff-08deb7487ffe
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF000001A2.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVXPR08MB10891

Add the encodings for the GIC VDPEND and GIC VDRCFG system
instructions. These operate on the virtual interrupt domain, and are
used to make interrupts pending for a VM and to read back the
configuration of a VM's interrupts.

This is part of enabling GICv5 KVM support, and is required for
injection of SPIs and LPIs, and querying the state of in-flight SPIs
to detect their deactivation.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/include/asm/sysreg.h | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysre=
g.h
index 7aa08d59d4944..40ff7d25d37b0 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -1040,7 +1040,7 @@
 #define GCS_CAP(x)	((((unsigned long)x) & GCS_CAP_ADDR_MASK) | \
 					       GCS_CAP_VALID_TOKEN)
 /*
- * Definitions for GICv5 instructions
+ * Definitions for GICv5 instructions for the Current Domain
  */
 #define GICV5_OP_GIC_CDAFF		sys_insn(1, 0, 12, 1, 3)
 #define GICV5_OP_GIC_CDDI		sys_insn(1, 0, 12, 2, 0)
@@ -1105,6 +1105,22 @@
 #define GICV5_GICR_CDNMIA_TYPE_MASK	GENMASK_ULL(31, 29)
 #define GICV5_GICR_CDNMIA_ID_MASK	GENMASK_ULL(23, 0)
=20
+/*
+ * Definitions for GICv5 instructions for the Virtual Domain
+ */
+#define GICV5_OP_GIC_VDPEND		sys_insn(1, 4, 12, 1, 4)
+#define GICV5_OP_GIC_VDRCFG		sys_insn(1, 4, 12, 1, 5)
+
+/* Shift and mask definitions for GIC VDPEND */
+#define GICV5_GIC_VDPEND_PENDING_MASK	BIT_ULL(63)
+#define GICV5_GIC_VDPEND_VM_MASK	GENMASK_ULL(47, 32)
+#define GICV5_GIC_VDPEND_TYPE_MASK	GENMASK_ULL(31, 29)
+#define GICV5_GIC_VDPEND_ID_MASK	GENMASK_ULL(23, 0)
+
+/* Shift and mask definitions for GIC VDRCFG */
+#define GICV5_GIC_VDRCFG_TYPE_MASK	GENMASK_ULL(31, 29)
+#define GICV5_GIC_VDRCFG_ID_MASK	GENMASK_ULL(23, 0)
+
 #define gicr_insn(insn)			read_sysreg_s(GICV5_OP_GICR_##insn)
 #define gic_insn(v, insn)		write_sysreg_s(v, GICV5_OP_GIC_##insn)
=20
--=20
2.34.1
