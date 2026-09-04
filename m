Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010052.outbound.protection.outlook.com [52.101.69.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D915481252
	for <kvmarm@lists.linux.dev>; Fri,  4 Sep 2026 11:53:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.52
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788522830; cv=fail; b=jpc5etBv3uPMTjO/LQDpVaF4H7Y9YvhZY3pPFzxZvUj/gyzEchM1pN1HgkgFaPD2tup9pQ/mHK8FulVEZQcZpLj2mRHJtEQ5ztgWq6JS0cehGhSh6LF9ZQrZ+vahLRXBb3lh/8k0IqjJgzSf8HqtNy7NSDOtogJG7mTP2eNgJ9o=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788522830; c=relaxed/simple;
	bh=XQOlmdI2vxjSvPBwc2KK9cOFzAn6qbtmcxDBgBfbZ6k=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=bw7qsFKo276/IMwTUIN7HlDFr0RIGA4nSzqGuKXBoukwfy3AvE0OUe943VJvOXb/ni9IZbuBx2OdPD9xL9ylvUPyMdBmwH+l+F67basSbex50W329v+Kz6jh9oBEVSrQwCD082ApVf+xkvJrY/AVlC1fIzwkOr5A1atx2Ij1Wb0=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=R5sNOj3s; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=R5sNOj3s; arc=fail smtp.client-ip=52.101.69.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="R5sNOj3s";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="R5sNOj3s"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=Z2EvwHt8uR0agYMDIEkvAmU/MfszQqa0zJNEwR5ZaanbZb85AQJ+I55Eou7lLtTosXHOjjdCdQpuYBFvaGIhaRMtFcrYRDcsSFQ1aQslprk8DubPrlMmKhKvkWFJk1kYweflhovzfxLiMwSM0oTREX7HB8PPCV04/xSASuk5WYm95cO1tyTmv56jPXTgXA1RkT7/bs7osld8TaIXXZZxa6FCYofFBCKb6q6VU347mUl+lRAmGuc0lLaxLyX2X+pX1W6jofNIIHc83uiZCW8xzSQWt7GxADQ0Swi21Rs8BBKUi87J1bJMdGkELndbUmIzIVqYYkWRFzvJ+w1NCAUUwg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I7J0vHrpciypc967BFPQadieQt2lAPdHq7s5o+jvarA=;
 b=Sh6hnh1/UYaNAH4FAweSOZHbh58qw0H8twjuMFy8EWjZ2CrgDzf0l6HbZr5bAzpqHZ6IrP89zr9aAUrsqmgmKzJeljkU/esBHCRWGVUGYqc+aSn0kkY1GGLOQ69aT+KXMl1ypS4PSjkYEwXvywYNFSBZAiP0V9zQgIP3BLjsPwJnuQTzRrxvr/fSzSkBhzSXlC/tV4BhgROENlnm5wSEfZZHrkKv+vVaN31HOtf87pIxhFY/8LBVQlZKBdEj24o0R0DIn+SpfEdnRZfMTJ9XgYAI7I4nBDC3IOAMpQotnq73r9vqb7oWw9PrgaCNmXFG6RWVYpVJUBHpN+7PhlcNxQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I7J0vHrpciypc967BFPQadieQt2lAPdHq7s5o+jvarA=;
 b=R5sNOj3ssr2GQDyVN4I7zv2n+VWe1epsxhTnWajonPMio8PEOOo3V8Y7rBt3W2hVLI4hCpZ5A880dF5Drt2TZQwf5BBpJsesiqt9lvQkPNytjcEdq92rfIiGxO9mwqLRMr31JLx3UmwhS6+T4jqLQR8PDEvWXiy+w2drPv45HKs=
Received: from PAZP264CA0232.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:238::8)
 by AS8PR08MB10271.eurprd08.prod.outlook.com (2603:10a6:20b:629::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.4; Fri, 4 Sep 2026
 11:53:38 +0000
Received: from MI3PEPF00008492.eurprd03.prod.outlook.com
 (2603:10a6:102:238:cafe::5d) by PAZP264CA0232.outlook.office365.com
 (2603:10a6:102:238::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.13 via Frontend Transport; Fri, 4
 Sep 2026 11:53:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 MI3PEPF00008492.mail.protection.outlook.com (10.167.240.153) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.8
 via Frontend Transport; Fri, 4 Sep 2026 11:53:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uTrsG/p5Sm0EJMqzgEvk78Tqa5At+0m9qPVCpuCLN/jS0GIcQUCghz3IlVi8FZDn9qIALZxuVxLaFldG76VTrVtj52bH3iTNJ6/KKb/TslJmzokmm6rRrF7CcaLIq8wc9lA+5IQ3u1rdb/UphLWF2ST1xWUC2V8dl8lD8JEBos3uzXCDQeokPkwUTmjo229GPzo9Iyyz2QfyGNXyjq6QORhf9l+wd1Uz1ZBVSwJKR2FsSWcfXZhQf4+MCDpjwHD6fyeOug9/q9+rl7py1Um8dZ6POr42v+gPUPw1S4t1nB/X6iR60jQbmBUHO32X0y05LKRfN6GXOr5GmK24NoJrwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I7J0vHrpciypc967BFPQadieQt2lAPdHq7s5o+jvarA=;
 b=aPTckBdLqE3MCAlv305Kf369tHXG48B5WcDJkn9A4OBGVioilGBXNpJKZxbtFjo6iZz9u+MyBxvcxsJwHGx0bzigqk+rrgwyFdJcYiG5BoYWDCH7cccaRV3bGx7hRoFP8XjbaHsJWIh15XplHTHoJw7qrzdUJyn/cdEBvr9K+PvIKOTdREG6NlR07KJIw4evNVq5R55o6cQ07Yc/iO1UDpUAGlc5xVo5hljIXoL/RC9QqOIim6kdk04EaAcyl++CT+G/aRjCzUCYBUH9+vYkORjp8kjVkVw9G9kE2zMrBE24MCmoVkMhX6Y/3Nk0UNDZZFNrefJbBUs0Vih7dCXhyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I7J0vHrpciypc967BFPQadieQt2lAPdHq7s5o+jvarA=;
 b=R5sNOj3ssr2GQDyVN4I7zv2n+VWe1epsxhTnWajonPMio8PEOOo3V8Y7rBt3W2hVLI4hCpZ5A880dF5Drt2TZQwf5BBpJsesiqt9lvQkPNytjcEdq92rfIiGxO9mwqLRMr31JLx3UmwhS6+T4jqLQR8PDEvWXiy+w2drPv45HKs=
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com (2603:10a6:101:1d::23)
 by AS2PR08MB10207.eurprd08.prod.outlook.com (2603:10a6:20b:647::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 11:53:04 +0000
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e]) by PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e%4]) with mapi id 15.21.0382.007; Fri, 4 Sep 2026
 11:53:04 +0000
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
Subject: [PATCH v6 37/49] Documentation: KVM: Add
 KVM_DEV_ARM_VGIC_GRP_IRS_REGS to VGICv5 docs
Thread-Topic: [PATCH v6 37/49] Documentation: KVM: Add
 KVM_DEV_ARM_VGIC_GRP_IRS_REGS to VGICv5 docs
Thread-Index: AQHdPGPxnv8ZEcTx6UyiQNd9Mvj+bQ==
Date: Fri, 4 Sep 2026 11:53:04 +0000
Message-ID: <20260904113404.4051341-38-sascha.bischoff@arm.com>
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
	PR2PR08MB4889:EE_|AS2PR08MB10207:EE_|MI3PEPF00008492:EE_|AS8PR08MB10271:EE_
X-MS-Office365-Filtering-Correlation-Id: d309eeed-c86f-4fca-2499-08df0a7b2863
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|10067099003|6133799003|22082099003|11063799006|56012099006|18002099003|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 gAqiOn4uW4/f/B1PXFtPH2Wc4KtpcPdYEBZ3gX3FDkUU+Y4lSpBDOGJ7xCu8Deg2n4nTEzw5e+REirEqhxlCpgptofcgci61KHr7mhwJvCjuJqQ+ICu+o4asf+mCKwSPC8+8hnmsBUkDCeWZgYD7XzydkbTQpo9BbWoHUjcDXfjv7MoBAGPNDtB6sVUEtcl2wfpL8shGCOiyDG5Q2e32dYixnSn6bcibuSrint0KSjFeUP079RW6uUrN6BNiCjmtzjSFHJiOl+bkGEdJj9XDiMDHsWpSdNufG24N9xyjTizVA/SlL6ZxEqOKnqhyi9yrDa3R8ruANr4MIWDeccQOx5hHZWbHSh7RB3OFjd61R9AcBTnjeP8ZmW9gU1NFP3QWQ+UGbWC0PtrbsgKS2Mh5uarHaftr+Ooy9rjkHup6e/f3xY56QrpfpfUT7ehP/zfphKYJGOrazLepvsRLfTFoi4S05Zo1t6Pa5pRyFlQdAXEdbNjGji0Te8tP/L16Qxz4A8WpQ+El/7dcocuQiq0qVAgfVBZ/0lKMA4TMR23l853yNTq6JFwlyUZw8PI5MFzpNQUAFLgjthTtiwPV+uwz+tZyahIqSnzAom7Em1gVvi6+2r7iYN+aOLBDZe98Z2tnAfQNOYnqpUkU+Kznvu/1LpKqWzp2+umu9eJavzYAb6KXT3uZ+4Xd53a06xQJ8ux2VOVhej9g/S2X6j/d4D2VoSNmhi0LaKhbxx/DSm7U1dg=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR2PR08MB4889.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(10067099003)(6133799003)(22082099003)(11063799006)(56012099006)(18002099003)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 0pp7FyMnzvzYf2yevpuNVpjDpd0JVkG0yFpXajF8ff51+pdywFha0ztwKNKxsluJNPYeWNyO2+wz8ab4ivIyFd/myFKLsVpjOFCrDpYX6L3Nhuyu/sy4e1iXgorMTmB1yW2JdvaTrXvtpkhleeFW3yv9ZPc6fJLhTasWsEI3jUH8hmmtzet9q3rvcyoF2WQaWtMF+PozY+jOmVVs4dyx5bmZn5ctUnemN52xLn2mdW4mtGOTUXBpSB8hxko3EwELn2IcGDiil0eMu4YdX/ymY2poSE5I1/pRNYy6GjG3YjuZIoXG6TtPlk/1WsYJ//ksnZ1txN/GnriB/i2mpBCG5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB10207
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 MI3PEPF00008492.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	27146cbc-b448-4b2b-9773-08df0a7b143e
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|23010399003|376014|14060799003|36860700016|35042699022|6133799003|10067099003|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	YAzkB++LwYKS3SCuBdGMaNHVkN1U9RhnzLiN5i7YjAsYWeWlnqoTnq3c+mbi55YR84v01yuj//eVyxJPkGuua9mPp6lY64UsHkGRz8H2cubwfi83UZw7VvgO8CZU27Aupq+8DwtedLGuufTiHVIHybStexm932QJn6STOaM76qSZ0yxwu512idmkPZJk+4sil89ZXZgXD1v40O5Z6qbBDcE50Mv4Ts/BKlv4kLIsYWqEUdDh/vcBuOjAv/X/K2Fof0Bfz2k3+TZ8QvBCxA2Vg7ptKQsitllRVCzKo/gWFysgy+BVklRBdk/TBZ1iJ4AUyE/CWJVnHAUMq7L5Oybolv4x7yjxiNCzKrTXFsxF2IUO5kDFM9koasZlYKH91Yq3DddPvoUQhaWQhAOomHLnrLn177roqxNWAdPLfpCEsLlhOHZ4DIfmkTul/v6akKN+OCUk/tjU3gcbu+xzkNL7E9ccCHxw9N0MsaVGNnxymq86wUBzhSFjPdSnoMp6BLoJ3tcBl+z8f49bMXw5oweAmpNbfPsRUOGgzx/vXKrDbsNEY0ZCTr+xNTuMC1jd9SmWtRbJFrPcd8nrZFffTOG6lfIcREYSoWkizql8TGHh41F6sS6knmj1MBQbnoguo+uL9ieWtn3G5R+YQwd9hnMaWjAitKhqd3SD4sPINJGk01o=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(23010399003)(376014)(14060799003)(36860700016)(35042699022)(6133799003)(10067099003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	1wFHTL6nqpNa6dg3V0H1d3riVGBNowHwdCPdXmt+l1y1dUGlX7BnHa2feROnQwbI+7fxnI8s/saB+5VwPXBP6B/NNERU0julUnkYm6+zP6lCFOrjs63m2idUwxpeeLiTymEySWo8bQGFIYuJyWaO2EKBVw/LktTEVscvx1r0It4fUO/j2VSQK9HN9Y9wvlBVZLNQ7a0/jcBg0Io75K3B6L4Ru0ztO8r+El39Y0qqT97Ii9iIqB9eTVdB6duamxp63L9cqTRGqNUzgClvVQitokVS1ojZpbFhRB5jO4VrmjM5ib7D/a+fagU5P6sZoj+eSQMOpb9tF4YMgCpgJuGPpoJ9RAA7wxyXQN2QgMoCcVQFvXvv6dLT6F1n6RIXkjs+uEtZuxLdkz7QPzs9NDgf17QxXRWcD1nO2+EuJktctepQEgRrKGln+2hmlRB5yvMQ
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2026 11:53:38.2916
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d309eeed-c86f-4fca-2499-08df0a7b2863
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MI3PEPF00008492.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB10271

Document the KVM_DEV_ARM_VGIC_GRP_IRS_REGS attribute group used to
read and write the virtual IRS's MMIO register state. This provides a
GICv5-specific interface for state that is conceptually similar to the
VGICv3 ITS register interface, but uses IRS terminology instead of
ITS.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 .../virt/kvm/devices/arm-vgic-v5.rst          | 47 +++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/Documentation/virt/kvm/devices/arm-vgic-v5.rst b/Documentation=
/virt/kvm/devices/arm-vgic-v5.rst
index 7e41d6699538f..4f475d14f83dc 100644
--- a/Documentation/virt/kvm/devices/arm-vgic-v5.rst
+++ b/Documentation/virt/kvm/devices/arm-vgic-v5.rst
@@ -149,3 +149,50 @@ Groups:
     -EBUSY   VCPU is running, or write attempted after a VCPU has run
     -EINVAL  Invalid mpidr or register value supplied
     =3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+
+  KVM_DEV_ARM_VGIC_GRP_IRS_REGS
+    Attributes:
+      The attr field of kvm_device_attr encodes the offset of the IRS regi=
ster,
+      relative to the IRS CONFIG_FRAME base address. This is the address t=
hat
+      was provided via KVM_VGIC_V5_ADDR_TYPE_IRS when creating VGICv5 in t=
he
+      first place.
+
+      kvm_device_attr.addr points to a __u64 value whatever the width
+      of the addressed register (32/64 bits). 64 bit registers can only
+      be accessed with full length.
+
+      Writes to read-only registers are ignored by the kernel except for
+      IRS_IDR0 - IRS_IDR2 and IRS_IDR5 - IRS_IDR7, which are sanity checke=
d to
+      ensure that they match a sane config.
+
+      IRS_IDR3 and IRS_IDR4 are RAZ/WI, as nested virtualization is not
+      supported.
+
+      For registers without dedicated userspace accessors, getting or sett=
ing a
+      register uses the same emulated MMIO handlers as guest reads/writes.
+      Dedicated userspace accessors may instead save or restore migration =
state
+      without triggering guest-visible side effects. For example, restorin=
g
+      IRS_IST_BASER only restores the emulated register state; any host LP=
I IST
+      allocation based on the restored IRS_IST_CFGR and IRS_IST_BASER stat=
e
+      happens when KVM_DEV_ARM_VGIC_GRP_IST is restored.
+
+      Once an LPI IST has been allocated, IRS_IST_CFGR is immutable. Users=
pace
+      may write back its current value, but setting a different value is
+      rejected with -EINVAL.
+
+      Once an LPI IST has been allocated, IRS_IST_BASER is immutable.
+      Userspace may write back its current value, but setting a different =
value
+      is rejected with -EINVAL.
+
+  Errors:
+
+    =3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+    -ENXIO   Offset does not correspond to any supported register
+    -EFAULT  Invalid user pointer for attr->addr
+    -EINVAL  Offset is not 32-bit aligned for 32-bit MMIO registers, not
+             64-bit aligned for 64-bit registers, or the supplied register
+             value is not compatible with the configured VGICv5 IRS state
+    -EBUSY   VGIC is not initialized, one or more VCPUs are running, or a
+             write is attempted after a VCPU has run
+    =3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--=20
2.34.1
