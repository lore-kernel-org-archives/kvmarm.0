Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013012.outbound.protection.outlook.com [52.101.83.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43F454734CC
	for <kvmarm@lists.linux.dev>; Fri,  4 Sep 2026 11:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.83.12
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788522442; cv=fail; b=SIYngqus4bs8czBRpevqWehGStFj0aGP0efr2eSKGGfRXWQPQsSshyXtn1E3FN6+g3ycLV0+3N7CiSC/UuaXVMi5xLT8nDx5F3WbWmdarP3rOv9UrmRYTVrNLeVfQdn+D00Er3AFhx1VmSG77UxZn7kPMdzu/twhJ6/h9tZRqyY=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788522442; c=relaxed/simple;
	bh=tpVEUFWFo0N5gUA+T39KZP+mLbZEDCDrInv8mZxqHa8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=q4QIXpNGt17CIwxZVmaOq9KLPiUm09RCjavwRhYE8D4TbTL5UZ5FDGt3Arf5jwTGnzYw6Kypuk9qUCyc9qdi8dBwWu5m2ckj/RlzYaqHX4Gj5PC0N+9r89/VKOdPfeQjWhMezIZGGhrSw6lhESed6vdPRIWFavcfwgW/4dc9U3U=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Xl1lBsqp; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Xl1lBsqp; arc=fail smtp.client-ip=52.101.83.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Xl1lBsqp";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Xl1lBsqp"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=ELmkzQv41/j9kAJMpS6c+3hnJFZZew/LDtvyo9qdqFQaggd2EUo5vMNcgjXKe6xeHtUjK7Z0g7iO5DMUXS4LjdWxomJWBHO0GiQhI6/tw9IF8O1kCyxlDqq1v/kf9TWrazmp1M27b80olr2KfsX5B8tT/DZCH0YnSd9KmeTzeNeQepH3SRbg3P2lXSvRnz3SpnlraOdCYcP4Y8ylzicKs6upKdim6CZHAk8V7XoERl5P+qubAhgZiocslNi5Oue40SPdmLIPlGCtzWXoo6PDoSsJQE6HwjUOJX85Sx6w18WgJFc/VzDk2z71zOgbXCG3M3riWsFTQWmVNV84gClArg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aBBD/Qx2168rADX0pEGbPpmi2yUYpZf1u3sdvoFcLEQ=;
 b=IV3dXxsXyWJOxIC2qGSv/ywcCTCfyu99F5Z+TJYjDCR85E7riGNZcPK3ybvZa7gmk2ArqflumYzf/XroqYGjvqb2+KxTfYB68zu76WMTGti+pFlFeH/8Ct5I/hYzuLq4RlC7mI9tA1Tw8ulo7NQGkCKqzDhUOtPSG3C8M8DWqfCvJwKxPII/MuUYimkAyT9jfgQpQtZkEGKp75pEt0Cq2/JuJRE9TKOWSrcd50EouWbCa+yyDA8G8DHOPM3WA5bUWyMSArTQqELqxSJiOwpMsEdXJig4UPJzz6uGjCl3ATOAmHBnYy8AK1OZQ7HcjIgNOp7xG4TWTL6cQ38r4M1rvg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aBBD/Qx2168rADX0pEGbPpmi2yUYpZf1u3sdvoFcLEQ=;
 b=Xl1lBsqpEDpN1/yGzI9WC3sfbnZ4dEz0rG6/V2Jg6swQOAtNbura/hBmdJrhqoouuADjTmxjV8dxNF4X0uM/OVgVmB+MGdbeD71qda3SPKQfMZ7N3rU/JaT3DGycKmuvNy36RKF3d4ZVAEvUcevejwI3cJ8AUHGMAim7cdI2pw4=
Received: from PR1P264CA0092.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:345::18)
 by GV2PR08MB9350.eurprd08.prod.outlook.com (2603:10a6:150:d0::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 11:47:05 +0000
Received: from MI3PEPF00008494.eurprd03.prod.outlook.com
 (2603:10a6:102:345:cafe::43) by PR1P264CA0092.outlook.office365.com
 (2603:10a6:102:345::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.12 via Frontend Transport; Fri, 4
 Sep 2026 11:47:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 MI3PEPF00008494.mail.protection.outlook.com (10.167.240.155) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.8
 via Frontend Transport; Fri, 4 Sep 2026 11:47:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rIpWW90Gl9HXrp+FI/5DzmqjcLMRRNkfdiI3+PQZuI9WjnMXT7glfncMwxfUItdMZOgkqJhXSKBpzHedg9trD97WNCkwWS6I5j2dq2/uAij8r6q0nnqc5xh2Ju1yYkcNNw9RNHqsg7II3hpQIyjHq7OQcVhvhvBSWVL6SFGV72aX/Fn9pIJ138iQoWG1qItSs5sm9AreuV8JZE7kfGCKurwfA6oj+d9wt6OLJK2o7Huc10KQJiGvf6GavGQnE6XBO1bhJfTtnYzicNWWcxhmgEPlsci3IFw/eL5Pd3pRoIRx8tOskWqCZNds4WbSAFR3sssVKOUChk7TF1D59WwVOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aBBD/Qx2168rADX0pEGbPpmi2yUYpZf1u3sdvoFcLEQ=;
 b=O9DKIF4jYVqJNHLEgum63jRUHKxhGL1Te4f3cQlpmJPMSWO9gT+JQNrh4xn9EduT2geyBaZnvzvmabDDFVrjAm70odQA/4PheihsF5JJUf4s9qUnZ7Ut6Obw0V6Ekav4IVpr/UlW9ZoDZCXFnzZoLj6X/1WfmTdC7FD2kYEFW4ejLJSRBGZ4hIfO/GRe3Po+wSfYCMr4QSY9WF+KXxYyXOk3GVMw27nUChq1SpG9nF9zMTi9dc5bDoJD5WO44b+XMM1M7FDuxP9lVY+fVW18xtBeCLE8WNbIUsuNXwclmB3d0lkjhD2ZM4XkC4H0M74p9P2izgnsume+pWtZhFqkig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aBBD/Qx2168rADX0pEGbPpmi2yUYpZf1u3sdvoFcLEQ=;
 b=Xl1lBsqpEDpN1/yGzI9WC3sfbnZ4dEz0rG6/V2Jg6swQOAtNbura/hBmdJrhqoouuADjTmxjV8dxNF4X0uM/OVgVmB+MGdbeD71qda3SPKQfMZ7N3rU/JaT3DGycKmuvNy36RKF3d4ZVAEvUcevejwI3cJ8AUHGMAim7cdI2pw4=
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com (2603:10a6:101:1d::23)
 by PAWPR08MB10898.eurprd08.prod.outlook.com (2603:10a6:102:46f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 11:46:27 +0000
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e]) by PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e%4]) with mapi id 15.21.0382.007; Fri, 4 Sep 2026
 11:46:27 +0000
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
Subject: [PATCH v6 24/49] KVM: arm64: selftests: Update vGICv5 selftest to set
 IRS address
Thread-Topic: [PATCH v6 24/49] KVM: arm64: selftests: Update vGICv5 selftest
 to set IRS address
Thread-Index: AQHdPGMF6ByU8I2eNEuuSUeIaOH3Rg==
Date: Fri, 4 Sep 2026 11:46:27 +0000
Message-ID: <20260904113404.4051341-25-sascha.bischoff@arm.com>
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
	PR2PR08MB4889:EE_|PAWPR08MB10898:EE_|MI3PEPF00008494:EE_|GV2PR08MB9350:EE_
X-MS-Office365-Filtering-Correlation-Id: 0702d528-23cf-444c-9a15-08df0a7a3ca1
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|23010399003|10067099003|38070700021|11063799006|56012099006|3023799007|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 coC3P+0AbAhafXQ1asYCia9YL3aYM/GF2W/3yeDUchdbFZy3TVJ/S/2fMO/1iTYNMAwtBznL5ESpu6oQw77HdUwYmagxfOAcLAr8jIBEO3peJF/22YxKeyS1WlZ3tLjMTBJ7UsexRbILDTseEcOz7VPwE2tFyAmmw6zzk3nDJPKd84CjnCpv8vc1pSrf/UoXnylxTB9hP3WLUCmsnHtpPr5za6xtDj4ZR1PFj0zizWms35Nz5NvCL/643Vgg4ey6YZZRskTapVaNUAXPrvjBjl/vGRDn0rigHtzwD9po04Qrlfk8zr4YZjGLCj8j7yFp9EKs3JoJr2FhlyjJmas2Okr9odjoBNmS587isTXDiOULA9opbkJJvcV9v0dOntWY3kBp40v1oX1h0DqmH6BZIq3OTwjkSKrjDIo9WlV4Ojzx6FEfsafb2WOs8Y0BgVS7hEDo6vQgTqBvhAuzA+jw0ykr2/izTVklgnGlEQPxLhRQLaki13iL/I1mfm2JUmGn1HE5WQ7m6JVKShR8qiOyvt1CCbo/0V6qE4Oklqx23+3UlagWtAxfclqm6AsdBipLgiYDOzD9nYYbjZLwdFh/ZiuSCpRMPPhJnWxGSp5sHdR5NMpdnzidQTa1Tw+Z1LzMeafMLjSKOiJ4pi4AGSriy4q1pKEWkqNVluEiyI0+3RBOXXwOA/3b2YEUx0fBDOFTZMGJD5rdtS34b1Yab2nj8Ct3favFuc903+SM+SMsN6g=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR2PR08MB4889.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(23010399003)(10067099003)(38070700021)(11063799006)(56012099006)(3023799007)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 A2DRs1pnW/TY80xox+hhQ+Tcj7+hurotOlqTl0oP6D5bFd2YmNlpzxGkpE3jg0ayuR/E/DVFGcPMnLnL2zY1IxRr4MgFuquy1/EwL+nxpWHZOdRac4E0+ZyBrhtPyZ8wx5ZHDgc/9D/7LrL1fBgbaavD1po723Iin7VImbnTexxJ9JaeyPC0SAApRWevFXYaK7/cLC6hTCFggfxYtsgKYh+ukuAxIfWTLcMnCPC5po7wIpsM04H9nwwaUe1Qdq+ZekjAKjUGmgzlRUCQonHDncLVxTTrrmBitxnj/r2YF/7jPymUQlpX9Tq4ZcZ8/17gZSftv4iBYDf9Z87T2itssg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR08MB10898
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 MI3PEPF00008494.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	3b667a68-da17-48b0-588e-08df0a7a279c
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|14060799003|36860700016|1800799024|23010399003|35042699022|376014|18002099003|22082099003|3023799007|56012099006|6133799003|10067099003|11063799006;
X-Microsoft-Antispam-Message-Info:
	oRbMzOZGQGfzewFQx1TtsxwcZ4O04v6QvSuQ/p5YEuAghWp/0X7Y9eaf5O+7TIs4KRld+JyZDFJUW3BZtFibHFvxOhibddZJAQ4VUFTBBNhtkyNhH0EzNMIa/72cESYLqYnPbOAOXL1iP55kJhv8Tfd+kLKwOoTUthVSITePGov3KJEULfkGl8+mFrApzG/nBs0h68Duo6XcRdFSX5Vfs6d6BWe+4PxWVA8Dnv5WdPup1wO2rpxdFwiAue1BFlgn36GGTrA8mlCNVJQ3AafI27SdHhMnoVz6n2BQLrE3d//fSNfbKVzq5FS/dOjizghUd61Hf6CpTGCWmwplK2KuoNRWCfinxLGbBpBFKlY3+YyK/wR2wWEBdXMKW4SNVt7cmFkvr81HIrNl6Sj+MAkt8mZP0JHe4sRwzc4Gezs/uOC68//lyr0mw/aeO/w7lz3982H5NdclJp9AzsglTs887slbnrtkd1DJe8KTYvYrCup46ExUMemefgXNCVVqV3zyVf0drpAohjwWVif3Qtof6CwfWmrww16xcd2jYjiBwhYqqSfZNTTFa5cWcEtXf99XzFmayAniJDylLk8ctxHPWdrpi6FN0zS4DOaicGInsOgXfuWXmTO26TYkl1kn/QwPUrIkoPSlDFVu321UeaTksPeaisT9ZRBD72DFjPMHpO0=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(14060799003)(36860700016)(1800799024)(23010399003)(35042699022)(376014)(18002099003)(22082099003)(3023799007)(56012099006)(6133799003)(10067099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	g+1LtlmkT/fDljWf96ePv56hQHcLHAFr3PhrHfvw5ywYcaqQteS6DkQn4JdAe6foroY/HHRphhnTKVoMNRirOqc5g38LDOAq5fjqnf1Ypwgwa9euCrtlLv1oRYcrUg5t6PPQayT9eMWWxgybXxCXUhkaSyHcUY9eWVkSpY7fxY/RTlG9pLrF5z2JS71sypEjBkZWfRQr1WpIUr+kRB9cLLdiNIB9WdgBwKcj5AAhgr/AZabKXm7qyx03Pq3ON1oJDWH9XwC1YRKVn5oagacZuwg+wMtV+0Adgu60PXRE1WKEDoaFfKaIWRh84T3tAXSsGFA8VGNDMnwfm07mxyftXCzTvEu+kr7+WKIg/4S0wFnbpZoUCpcD1bHBGa7gSroH5GDcmbtTtbBaPWH2/MHvOQYs634ilRxXWN0YMFbdKR24z0kwSwz7Vk8ck9CL2yMv
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2026 11:47:02.7746
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0702d528-23cf-444c-9a15-08df0a7a3ca1
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MI3PEPF00008494.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR08MB9350

This selftest was added before the GICv5 IRS was supported in
KVM. Therefore, there was no address to set, and the specific UAPI
didn't even exist.

Now that the IRS is supported, and setting its address is mandatory
before VGIC resources are mapped, set the emulated IRS GPA before
initialising the VGIC. Running a GICv5 VM will fail if userspace has
not provided the IRS address before the first vCPU run.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 tools/testing/selftests/kvm/arm64/vgic_v5.c        | 6 ++++++
 tools/testing/selftests/kvm/include/arm64/gic_v5.h | 3 +++
 2 files changed, 9 insertions(+)

diff --git a/tools/testing/selftests/kvm/arm64/vgic_v5.c b/tools/testing/se=
lftests/kvm/arm64/vgic_v5.c
index 96cfd6bb32f6f..19039a8940568 100644
--- a/tools/testing/selftests/kvm/arm64/vgic_v5.c
+++ b/tools/testing/selftests/kvm/arm64/vgic_v5.c
@@ -100,6 +100,7 @@ static void test_vgic_v5_ppis(u32 gic_dev_type)
 	struct ucall uc;
 	u64 user_ppis[2];
 	struct vm_gic v;
+	uint64_t attr;
 	int ret, i;
=20
 	v.gic_dev_type =3D gic_dev_type;
@@ -116,6 +117,11 @@ static void test_vgic_v5_ppis(u32 gic_dev_type)
 	for (i =3D 0; i < NR_VCPUS; i++)
 		vcpu_init_descriptor_tables(vcpus[i]);
=20
+	/* Set the address of the IRS before initialising the GIC */
+	attr =3D GICV5_IRS_CONFIG_BASE_GPA;
+	kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+			    KVM_VGIC_V5_ADDR_TYPE_IRS, &attr);
+
 	kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
 			    KVM_DEV_ARM_VGIC_CTRL_INIT, NULL);
=20
diff --git a/tools/testing/selftests/kvm/include/arm64/gic_v5.h b/tools/tes=
ting/selftests/kvm/include/arm64/gic_v5.h
index eb523d9277cf1..c388df8f2a2b4 100644
--- a/tools/testing/selftests/kvm/include/arm64/gic_v5.h
+++ b/tools/testing/selftests/kvm/include/arm64/gic_v5.h
@@ -10,6 +10,9 @@
=20
 #include "processor.h"
=20
+/* GIC component base address is guest PA space */
+#define GICV5_IRS_CONFIG_BASE_GPA	0x8000000ULL
+
 /*
  * Definitions for GICv5 instructions for the Current Domain
  */
--=20
2.34.1
