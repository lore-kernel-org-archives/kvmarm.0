Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011013.outbound.protection.outlook.com [52.101.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2111525DB0D
	for <kvmarm@lists.linux.dev>; Fri,  3 Jul 2026 15:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.13
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783094055; cv=fail; b=HJn1DAMO+3h2LG2CHRCCayosngXiQ8/1MN7Jfks4h3z+9XghAHcJcWN71aISnqEWtQVJEWGzqy7/iBNuVtqplDVuQcGmm3cpvJQzW9giFrujC2mT/qLfjRC/CIa6nlfEHqWlYWlvw505qElpKgj9osFLv/sGOtO+U9lXCHbnFYM=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783094055; c=relaxed/simple;
	bh=jiVRWQtYDuKNoNPPK1Q3vduv08rlg+8XYhv/gWMxTF4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=m8lyVrIOh9IVss5ejE4wzBti3fsjSQbQkmjSDEVntMkkzAhlnJU7liaw12LWs0oQ8A/1QmbZLeaQ3QUPehlWyCllvhzMQxGURYfUIuYt7B8VGVHlBmi7sk3ryX+UTRg8M+39jTAAJqBcnIZwzFETJG+cfdvApzKKZOmtaIigCNI=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=VaB9DJbo; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=VaB9DJbo; arc=fail smtp.client-ip=52.101.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="VaB9DJbo";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="VaB9DJbo"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=Js+9jkYx1GtsdjO/QCTdI5C2/lU/TvKRP0NGQVhE5XFNB2kbiuwir0QjS0RO7plOcM/+i8RX5SOtA+/FBu/UtBZXJEj5fXjWFJIoW3yqL78DPj8BdTnZGRzhQDNB/RUkmjBLFpkvdY+XkI+iVIMCn1V3svWKC3V/qVnzgyYBtkO1ZWfM21FTK/Y5PosnEkiOULEbh9LpOtVpt1QBt+LcY81apSjDY2gJTXetnDX5ojvU7/Y3U5Qln6AesjRKgMYHZjwQCncdYmgN97eR+Oay4HW8v3+dDloa73k3OLUyOrn5vgn2qhUuP/62chIo4eX3ctARx7tKfVbG168TK4127w==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uDoVGaRL3vBISbPI/XBhD+TTeHP0413aN2VV9e64IgQ=;
 b=Tg6M9Y98t9mtqwS0KU6zN5YL4Wqo6rvKSdLDWtAB7QSwjnL0WW0At0HcIQbVhP55muimydmue8Q25GgUxiyHNekxIEaCGIDLeVsgNagwX9rOxxHBJqUhj3QF9gV0N/cufh2gKUCvgRQ1Mge3O82utdk1wyZC0My8zj7rq7a/VUQS3O6URonQD15pq8AOvH86zuMtB6DmM00UkXcvGDydmZj5Cvy2yWeXnL3aZxT6lL5kdkX/UrSpmHpifIEVqXFitUBR8DMOfV/pCPRdtvlSUAcPwVJ89YeS+wHEirhQNcauxXODEpvTvpVCgtKGxa4oOH4sIF/ORj5YJM8bs0sp+w==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uDoVGaRL3vBISbPI/XBhD+TTeHP0413aN2VV9e64IgQ=;
 b=VaB9DJboGNT62sJNgjFcy7briQcvnBUhzfH85M+t0FqYju2efKxYKkaR7eaXHqC7he4EmVXr5PuhYEqH9mesC618Vze7kEcb6wdLk/rfTC2/AsxpNPxUPQyP0KJ5JP/oHDfVw5QmOH/aOGboJZg8XcKAT/vSvl1mv04WaozWayI=
Received: from AS4PR09CA0011.eurprd09.prod.outlook.com (2603:10a6:20b:5e0::13)
 by PAWPR08MB11067.eurprd08.prod.outlook.com (2603:10a6:102:469::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.11; Fri, 3 Jul
 2026 15:54:10 +0000
Received: from AM3PEPF0000A791.eurprd04.prod.outlook.com
 (2603:10a6:20b:5e0:cafe::a5) by AS4PR09CA0011.outlook.office365.com
 (2603:10a6:20b:5e0::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.11 via Frontend Transport; Fri, 3
 Jul 2026 15:54:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM3PEPF0000A791.mail.protection.outlook.com (10.167.16.120) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.6
 via Frontend Transport; Fri, 3 Jul 2026 15:54:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=d9ZbvgcpAAftm0tiVlwZ9dlFPxAuZqpRPJREUroKOgcszypx0qyN2n5GJk1D/y/fPpb4Tpndi8059DzE5eV7qmntzu3LKSUHif2HunfW/6RlAkZP9XcjotbF5qzRpvacz/OAURmvihM8YRyPziWMEUeIUpIlmnV8bZdcK7yu0zVQdcJMCNx3ewTt66nzUBR5QqrnGHEFENC12Fr5NvIb3E6ZAKBmqpAQ9FbK0bAMjAl/AFBc6mvJ9N5iBIpPl+tWklN7vs6nC6O1dph472ifn2qx7xO8HNNnTQ/p5l19UfA4or+wrFwmiEFgxrCex0OJD2T34A8Bh05IlHIPQm9gsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uDoVGaRL3vBISbPI/XBhD+TTeHP0413aN2VV9e64IgQ=;
 b=l9aPvq8upWOybuzekbmjNUK5VYWim4mCyjb3RLwuenIL96dYsgQAYMevlom165Tfe9uEVptTy+IzKihXcwGNfQxtgVVZnPkUacDkrgZCfz51/aEKRcj/59zsvJluLvcThsQo6Ns8Q64fK0Kftv2fSRBQoUZB6HY+/a3TOnKyW6iui+F+rsdkhqjhnnVAcRyHNJmBw1u5ryuPFcDtfxa47qUqmBMcM7Og1V5XiTibnwMohTqU0oLcNEPbPTFNf0JTEtQos5Jn2pG7RkVPXf8LigCscqazp7F+BxaYZtu9o3V2lZ2qzx/Ch7WdIDRVEtmyXSeMNmogI6/82JPg7m5Wqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uDoVGaRL3vBISbPI/XBhD+TTeHP0413aN2VV9e64IgQ=;
 b=VaB9DJboGNT62sJNgjFcy7briQcvnBUhzfH85M+t0FqYju2efKxYKkaR7eaXHqC7he4EmVXr5PuhYEqH9mesC618Vze7kEcb6wdLk/rfTC2/AsxpNPxUPQyP0KJ5JP/oHDfVw5QmOH/aOGboJZg8XcKAT/vSvl1mv04WaozWayI=
Received: from DU2PR08MB7310.eurprd08.prod.outlook.com (2603:10a6:10:2e5::5)
 by PAWPR08MB11014.eurprd08.prod.outlook.com (2603:10a6:102:46c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.11; Fri, 3 Jul
 2026 15:53:06 +0000
Received: from DU2PR08MB7310.eurprd08.prod.outlook.com
 ([fe80::e007:b494:8a24:1fc0]) by DU2PR08MB7310.eurprd08.prod.outlook.com
 ([fe80::e007:b494:8a24:1fc0%4]) with mapi id 15.21.0181.009; Fri, 3 Jul 2026
 15:53:06 +0000
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
Subject: [PATCH v3 05/40] arm64/sysreg: Add GICv5 GIC VDPEND and VDRCFG
 encodings
Thread-Topic: [PATCH v3 05/40] arm64/sysreg: Add GICv5 GIC VDPEND and VDRCFG
 encodings
Thread-Index: AQHdCwQKexffveXYYke+t11TljXgeg==
Date: Fri, 3 Jul 2026 15:53:06 +0000
Message-ID: <20260703154811.3355680-6-sascha.bischoff@arm.com>
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
	DU2PR08MB7310:EE_|PAWPR08MB11014:EE_|AM3PEPF0000A791:EE_|PAWPR08MB11067:EE_
X-MS-Office365-Filtering-Correlation-Id: f16dcf5a-6f1f-4d3c-58b0-08ded91b5265
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|23010399003|38070700021|3023799007|56012099006|11063799006|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info-Original:
 5qjk3v0JuLvs+cKmYLyDS1VW7+Jz1EJ3NkP9bucMgT6gYXMxM76F7Y27gRfBNXRhcHalW5qEqkj4ONXr2NqCRuX8hrQvh1IuracQF3dEpiTOcVb9KhftHkIf+xhEounuSqHcZnELqffyD2Yv3xbGqKm/ezf1D8CiRMQqFVDE09oppVtSjviNp1EnMRqQh+2hd97M1B5B3rzdTTgfRxpWY0Vw9d0wnOJaTimphwXAsm4FpOQkgf7hw/wJJ9Tcqt098Ag2CyJoqbreOLPlJ3fAvboHALs+BDO+7LSTjWIt10IKCuAGRvjfBpdWljvvm3JszcHZNJbSOR1oQFEPsLVfNYFQL1wxifT3zv+xBfSn/q4p+yN0DUx2qTUwEDo+eGpSH5ZRl0l4+UWKv256qMdlRaRWslcaFLpKnNqLVRqOh77xex73KTi1+YunnmQIWxdClY5pN+D6Nje79WK54MLv7BvmA6n0HM/2JoQ6R6GoCOmB3DVLbYX/cHNT/GB+/1Xgsojp65ruV6W0HEzDT3+A9UUu2WPRwIJ6hBRIYE4U+x+iY7yJiY/zgfMPFYpmmq0xPeb/CKYSBziDlvBSm/U7CR0WUMe289rmYrY+pHlGBlEHB8OocWYxPyh6jpBoHeFrhc2hjBRh4WEULA7kLMftaqfbL5djP++Tm0guIz+MEDLS6tXqk8NhpFDxpY9UVxoEMnEA18ER3/10gWHl9UsiPxK/KCS7z/r7BOSuen2Mtk4=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU2PR08MB7310.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(23010399003)(38070700021)(3023799007)(56012099006)(11063799006)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 Kwi/ao5YFdDgCnkgvleH2K0O9ht2q6R5fdAOV5OA0v5z9m/EqESd63AB5I0VxAqCany7q60HPwNZfAyEjtUVrd03QtnVm8GmtdVyfImsBj+Mh/N9BuKearLT17Df1KaMBia0E/vRIsB00so93mmyPKmIaBx1qtvDFk88U7LNcuwSJbVKic/dpj0oY+LpNx11ifBb0gf6WsT6c/mjYTg8VhvqR+v8+YsXxdzOtHSdfQaR8AYuOVgxobQ1CArlyOV8wNOXAZNaZxfkm9+LFWVsoHFRGYE7/5tX6u1xk51F4vhe8u2LmNc9F+Lnind7Y0sj/JcigEmyhavbxdc215WV4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR08MB11014
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM3PEPF0000A791.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	6a5d745e-ec6a-421e-2850-08ded91b2c85
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|23010399003|82310400026|14060799003|376014|1800799024|35042699022|56012099006|11063799006|6133799003|3023799007|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	AXm6Ijr0gl1o1J2ERyzle1+rhLvQ/kIf89MyLaiVFo8Eg7vdtaG6mOHXNYM34k8NHKLEOPioxqGG3nDLaCK0QAvdni1vrszzrEZ1E23nYnka0uZOGUoec+0TzLir5ys+9elHb43mt4gSYgMGfqHcm5dQz+0o5yu+36wOJqQLaIkRM530ZXo8/dWlJyT80wLlK8gRRByn9D4Z/fA/hT6RlrYQsb0+9aFemxnxn/CdVgNSbQL7Wfy+td18/Nbz+Bi1UHXIdmXyc9BgUXJSEGODa6CHxQnjPU67Y2diGhwQtbD3as4gHGJbrTZ65XTfrt9r3j5m+sTs/IfTxvxU0JMwdzD7eG47/JAJhmcF2sBNjbAP1r2rLz5l4luc7Gp8OPxkDGro5KvMwfJgl6H+iD9NcieTKFYToZwHzmt7zaX5BeY9FnyOTY81QYzdRtyh7wnxapSGGKZ+eesy8QVZWRWB0T7EH/KgnCG5Z3pRWX3jxU0MoFEZUlj017IabK9PuYOYNbM9iDmUbkaw05/NFuz+GzQ41sT9+Yq6jf7rrXfcAoBGee53YqyZTQUuTDEVb47GBBgnQIiQ7XaMlI5aJoPm4CwmvuO4mDCyin2O1Y8Fq23TWXqS77rQc08xKGTrx26JNFfQb8a/U5V8wem3+i/GMw2/WHakArdna3Fgq6N2MMFqCU8MhoTYzrVthhbOJaB+UoDsiqW/DhugzrNDt/2G9A==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(23010399003)(82310400026)(14060799003)(376014)(1800799024)(35042699022)(56012099006)(11063799006)(6133799003)(3023799007)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	7wPUVLrblfa46Cvi1//LvwCwjd358NtpBim8TfdevPgxZXkVVkaHSGbMosyRMXUgi0URn72euv5uW4lwgYs+VAhiwLcvTz61WfWN8wzMl6uueHFxqNAgC/xpfYw7MmE5MXi4xrUTG5ADb8+a/n/WYOImMDVfcaRrxPVOjLvxPM/SjdPdflzNcwDKThgLZfvncqcqWzS6X27W7gI44FJZ3AFjer9HrSO/HqHseZD9QhGI5Msl7JshG1ufjIv97XNSw2zWUcLim8hubnAckZpmJRysCEueQRFt7cbvDT+tRtquFYVibGDbxPDMleByS7VxKo8wmlxBYWKeJhb86hDbHEYNskYmxQHzEL2dyQ/OoU+LvlNgSs1twVwdu0841lR4y3YTGv3iB7orAHFkG7LIEA2YHgRNt3j1WwP73ugoR1fBznwnV8d7LAUwj1nK14DB
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2026 15:54:10.2053
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f16dcf5a-6f1f-4d3c-58b0-08ded91b5265
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM3PEPF0000A791.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR08MB11067

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
