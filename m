Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013042.outbound.protection.outlook.com [52.101.72.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 477D4372B2E
	for <kvmarm@lists.linux.dev>; Tue, 17 Mar 2026 11:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.72.42
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773748031; cv=fail; b=WbLX+w0ZRQUSRQeEIdeo7pwqctogy4lEgdcyePrB6yJ504nzsSaM8ACzfzUlAa9/lOwxgh1Hb6733Rupm5nbX6QeydYTjf/aSfx99P985RvcrJcAD2PKJ47TGGqf157sS/HFTENBAVbl7vPhonbWR+UCE3kpJzBJS75fhG7Z+xs=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773748031; c=relaxed/simple;
	bh=UH1mKBgaZzvGLKvmrJX8zieDh/pKblUgymKRomaUHn0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=gpBu9lMwUILkBPcsf/HCBxyjACPr66gjwUM9X/zjMQKZjDMzz4K07MIPC+ZOuUiEYdAEjvnxwgrs1tgUJXY/EgOrCvS8SOqsxPY+kBy8KxpCNe7fnltDE/EoTzBe5TYuIOovvjwcqEmeCKlKqlHixM4Yu+g2k4SaYHeHvq7KriI=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=oHJICoNx; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=oHJICoNx; arc=fail smtp.client-ip=52.101.72.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="oHJICoNx";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="oHJICoNx"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=g8mkAPByUN6Fp43LYDzIwhdCbTAQ5kQBZW+s+TBm9myj49XTBS087Sr2lEiDwwfwOMkrUHUCVD5LF/My1D2HDA6XJqsmV2zZOxJSF20ecWsWBqT884n7Sf8XWcmxmCujrQuP/NErsob0KAfDFW38F6ZkGGn1eJRrPc88daAIJ9txjTRpK28Rp9melPFLQXCKMTj2sh99lE6pjeGZYhQwo3VZgGHlZj86/F22mzoA/NrwlaSP+lDCxcCvsr4WljJDiBTMTb+773Z5KzU+nQ2zazjQdKGJ4FWp3PQMQFA6ryvK8tX+8s1gcmCevOYkbefSJ/f1Gm8DpCduscRpAqK1zg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rIbarGI8p1R4wAq8t/JMvUqaNSZaXegKFhqeK2qISSA=;
 b=xQk4xSVJWRYEjcMrYK/L60BwIOf2gFt4UCK8sV7UapHE1ej0/cC3nCvDuxrHCsM4aGXbYuLFnYSyT6PpCdAqZ6P2CvEptKSv+8/1S2P9Cp3HBMspauaqDg1qMX2NvPzgtvxS/7DF2TvfnlAdTq9mRdVaVkrTP5z+UYYQLUfSqLLewI+4jyLkDI/8IrughpEl2pafFLJRTjcnNyZrxq1ZRmtUnvnTrnNXiE0tKOp6rvgU0aGfkY+qLAeG2yBx6mMPWnl7fiJhj4r2EBiALVcrPJfIoZCgW8KcubvMJZMElOvn/8g3Ppd1pvzGXOHmKM7F/3iiDcLkyKSGHHDgmYe0uA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rIbarGI8p1R4wAq8t/JMvUqaNSZaXegKFhqeK2qISSA=;
 b=oHJICoNxTDzB+hnqtjkqLhH508pxzGY2zzKKcyM8jnHZgGr8h+YldL5ClJj+ZbtcZWetqBK+Hu6Zo9lTVKeQZrFhnoqH2RbWagSBrBpEtGy1Llg2l4uNzFpXoWuv17iGQHE/TqgQ5aV0iIAytSna2eiMjVsgmCaC9FafDKe3xaM=
Received: from DUZP191CA0004.EURP191.PROD.OUTLOOK.COM (2603:10a6:10:4f9::23)
 by DBBPR08MB6044.eurprd08.prod.outlook.com (2603:10a6:10:207::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.27; Tue, 17 Mar
 2026 11:47:01 +0000
Received: from DB5PEPF00014B8B.eurprd02.prod.outlook.com
 (2603:10a6:10:4f9:cafe::1c) by DUZP191CA0004.outlook.office365.com
 (2603:10a6:10:4f9::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9700.27 via Frontend Transport; Tue,
 17 Mar 2026 11:46:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB5PEPF00014B8B.mail.protection.outlook.com (10.167.8.199) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9700.17
 via Frontend Transport; Tue, 17 Mar 2026 11:47:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Deu9Qmss8vyR7WQXLDrEcIYWQnJM4Xc+J+hA+FcfGGxWwMvbLBaHRm6ZLraswdz1mcK69Yg4heqTmJQVnQxz+xqRD2anocM+tAtvwdgMOAk6qU5ds4xuoemCrOIXtNS0GFPUlv2UIQJpK2ZoQWDva4oa7DRt2hn+44pQILTZ4ErCH84jMQXqPEmMak2mOeWCMV88BGh68vuio7yvh16l9wN2IVdAE3cLw7LF0daL37eys8xJI2cetScIOLwiZOfhBdDj/KgPxpEvyhVxqS2wZghUzYYESWkBNgXYRKb1kySkFlXMBZ1aw6q/OJ2vLvS38czBNZSiHnN2e53+NWftUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rIbarGI8p1R4wAq8t/JMvUqaNSZaXegKFhqeK2qISSA=;
 b=dFgAF92jl4VxMm4kZCOMZ/vNXrP9yMlj5ezxnhoUn0pLvXVMWxbZZsZt0oFgc5eAmSC0lqJIhwt2TiJkBpLfGqSuS01EyyjBfddzrcqIhBPYDChRJFKF2o0qCYW9SGdN7grquGmOhgWO9KbmPI2Ts1Jw7mIzgzCHD8KCKGS40GbP5iSiQoroyHATyl/HjhTqAwxlNu4jrvn5nOiN9aEJNspO1m4IMxPbs/u4xNU3WNcnDECuMKrXsrXUPG5BZHSumKrcfdl3qBqFQqMV22yYq8/0AZJPWKsAi/c5E6jDERq10R+01c+95Ojui9pefaHhIiveMAqle4caqd7lnbsJpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rIbarGI8p1R4wAq8t/JMvUqaNSZaXegKFhqeK2qISSA=;
 b=oHJICoNxTDzB+hnqtjkqLhH508pxzGY2zzKKcyM8jnHZgGr8h+YldL5ClJj+ZbtcZWetqBK+Hu6Zo9lTVKeQZrFhnoqH2RbWagSBrBpEtGy1Llg2l4uNzFpXoWuv17iGQHE/TqgQ5aV0iIAytSna2eiMjVsgmCaC9FafDKe3xaM=
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com (2603:10a6:20b:504::10)
 by DB9PR08MB8483.eurprd08.prod.outlook.com (2603:10a6:10:3d5::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.24; Tue, 17 Mar
 2026 11:45:57 +0000
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27]) by AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27%6]) with mapi id 15.20.9700.022; Tue, 17 Mar 2026
 11:45:57 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, Joey Gouly
	<Joey.Gouly@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>, "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	Timothy Hayes <Timothy.Hayes@arm.com>, "jonathan.cameron@huawei.com"
	<jonathan.cameron@huawei.com>
Subject: [PATCH v6 23/39] KVM: arm64: gic-v5: Trap and mask guest
 ICC_PPI_ENABLERx_EL1 writes
Thread-Topic: [PATCH v6 23/39] KVM: arm64: gic-v5: Trap and mask guest
 ICC_PPI_ENABLERx_EL1 writes
Thread-Index: AQHctgOe8MFpfc6EJ0iC4jVSz2wwlQ==
Date: Tue, 17 Mar 2026 11:45:57 +0000
Message-ID: <20260317113949.2548118-24-sascha.bischoff@arm.com>
References: <20260317113949.2548118-1-sascha.bischoff@arm.com>
In-Reply-To: <20260317113949.2548118-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AS4PR08MB8241:EE_|DB9PR08MB8483:EE_|DB5PEPF00014B8B:EE_|DBBPR08MB6044:EE_
X-MS-Office365-Filtering-Correlation-Id: 5e8157c8-5d21-4396-334b-08de841ae700
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|38070700021|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info-Original:
 MUMHgVdwjHMucATDB7cAuuG8wyzmJkupY6hCAJCBebJhvCLyQY802XWEwFbTjPrGlojRP5nIraT50z6c2FFo1fj0298VV6gJ9Ql1QzZpenCz4nk2J/z+bNBZtDaEfe5GZwduv78ZhigG62jtfoyXl9/FXvaWvkcR7n6AlVPVJKSxF4dunfVlov00pbNZqr7vc6cX7HFkspmWFmxPojDxT6rkASnwXZKLi+FLq+Avifct8vWam3/OvjYAgy6PPaSa99i/SSBvi5SyO1sP/cReOa8S26GkPrxmkgiLfQzn9CRtxajGxzQJIlAvqVkfAFLJDSKCY5p6zN+KYlzPSBGoCl3nzy3IbYABJFMpLnqsWOISSVezxBkoh0M99CKqyzG16lnXx7LcpwcG4Fs+nl4R14uT/8/sT9nlBjx3Anj19XSY3dtLPriqoHiORXi8LNy63iI46Q8dg0ZbVBmJq8IRaw/lfJ8edM5LQ9O9lX7bdtzog1zSeCjEb773eIOvi31GFmdhqN77XXTfYzjtRBYlukddoWMbBtmU3K0sHIcRotKiZf2hwMrHIZtpI4E3xXPwSeoE9mjavSZSyOqKz0o1jYZJpKIsq0SJTzFyPrHKBw7vEjVQJrTNDRRpmK1IrDUZdHpaokBJ69VESpMBuyB0FN9Zsl09A0dpTsXE7bj8KawFdbIqWLs8uzgkZzIefyRSqSn1rKEXfp8mivL6zlqJjSsyNMtdj8IvaNI1p56HHZDnZfC5YaqQVQc98/ro+P3mSrY90bSqwtbfZPcgrCUm4e0yP7zdFcVJsSI7dRIT9UA=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS4PR08MB8241.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700021)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 WMCDmhsiwAOTxAByIeTavd8lX3yQXJzvpjNyuxSStmMYdAPgp4xw5/+0Be9IRDx53F2Sah8NSu8rgoxaChYATsNZjaTjIcOyURRWnkai6sqhH9V7GJFwd8/YdhwHjc+nNAAYOA65hJRuKaD88Teg/DY6hcXXn6bFV7D1n0DCRfmTflkIjPDEU60eiqdJkN27tWu0gE4bvUFH4yv5rPb2QIcffsO3147SDi2uR0y3/32T7xztjJAmYpHLLevFNxzC5vW2WFeQOFaSc2JkQKT+7lDafKIYx/+G7D6QTF3LxgNjRueY3qEWits3sCUyTSWgE/gDN4aQYcLaxi/U2MUUOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB8483
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB5PEPF00014B8B.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	9f289e1f-565c-4d6d-ec9e-08de841ac0ce
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|1800799024|36860700016|376014|82310400026|35042699022|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	VGM/OxpxwQ7ZolTpsniEBwJlMN/OC/tQCZ1VAS+6qV42DQqAGKmqyltA4M74OjLmjJQHd1rblRMugpSfC5gWwXVFETDG33T0gRFJKiUg+AD5j6ob+DS9MdzSbtlI6ZrqNJrhhdV7t6Nn4shyREj6tjEz9OpHmcC34uK+RTERipe7kcSN7KUtjbr3TWIjhWBUSJdGr+uIScNOknmTl86DFcrPSETKo0C3Xr0SzzCdPD81cx5frCZM8liSt8wUDTQgVMsMHetTF8YbvXIozRacm29rRAz77TJPxwyBRjsGhEBoo9qXCPAab5f5j6KItMKRTvmeV85hDR0qYL/bPvDF3zVM9cI774UW68X2oAeOxrvy9+h+7HBTvr3QtGPfXTV0F1GRb+iOb47M3IKtkKkD6A1YYAjla+0i++SE5uJgBuNkbfx/hwD/q1zztqpoXK46lpfJmsx2rcKRqAcP90ymHq1qEPBVbINfu0g73KYcyBS+C2Yq9n+jy95Xquz120Z8BfW1NT5I09tBK49CDBAxI8knT/vwF2wOqnz856ra3w2PPVKsaUFBVZXGyPH7gHdy5NOG5JZJZbdWLf5yA3If1wTGwtcKQNGMrIO2yYkPQdoZ35rau0KxWP/avfpcbISC63eyVJAvj1Db/t+zduFnrFbfJTaa9Z2k1jkeMvn3WyGI4Ro1OqzsfszHv7gAYO4revSBzbuNB0QEjwYUpwDh41DBRdYPulqLfQgcEGTwAxnMhyIUsCk48lYkICxi5tTIJfH1Mj2LEDLgVixmgf5mIQ==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(1800799024)(36860700016)(376014)(82310400026)(35042699022)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	OxLcufqX0xVo56KobiwPvRShmpSHaqaT9foGc7IsKR4c5Cn9YIf8w0tCJlMiKpQCnfAzSItSB09mqqtFyKVKW7TSMGcV1BaC790XgrxgvYP88N/yGtodggV8fXE0yfJUTlkEvIpoUotcSKlnwKTsq95Z2jC9VDLU9mn49nomZ7Si8udqJI26Tmni4syD66ovzBJpbOAJL4j/drcg5wtvQgyB9H4IQiKYcpfGhmsM3T9LwC2wJ+J0DZHsCpSHZxGpM3uRpAd8uOPt7EXnjBlSZIVk4MVuQDgsBwxxBO1WqtHHFNbNJPqISjZ9FU9hTn8IAEJtRlKGeHV5TUpvfN2GLymD4bwso4wOHmSJzJtaU17Bm595hKJnFiqny/RFzQsZpKg3vHgeYFBzATFdKVbkT2apGOEVLNBzKPU1cB69Yd30DB/40SYaHCgZ57EGM7gI
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2026 11:47:01.1659
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e8157c8-5d21-4396-334b-08de841ae700
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB5PEPF00014B8B.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR08MB6044

A guest should not be able to detect if a PPI that is not exposed to
the guest is implemented or not. Avoid the guest enabling any PPIs
that are not implemented as far as the guest is concerned by trapping
and masking writes to the two ICC_PPI_ENABLERx_EL1 registers.

When a guest writes these registers, the write is masked with the set
of PPIs actually exposed to the guest, and the state is written back
to KVM's shadow state. As there is now no way for the guest to change
the PPI enable state without it being trapped, saving of the PPI
Enable state is dropped from guest exit.

Reads for the above registers are not masked. When the guest is
running and reads from the above registers, it is presented with what
KVM provides in the ICH_PPI_ENABLERx_EL2 registers, which is the
masked version of what the guest last wrote.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
---
 arch/arm64/include/asm/kvm_host.h |  1 -
 arch/arm64/kvm/config.c           | 13 +++++++-
 arch/arm64/kvm/hyp/vgic-v5-sr.c   |  4 ---
 arch/arm64/kvm/sys_regs.c         | 50 +++++++++++++++++++++++++++++++
 4 files changed, 62 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm=
_host.h
index c4a172b702063..a7dc0aac3b934 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -814,7 +814,6 @@ struct kvm_host_data {
=20
 		/* The saved state of the regs when leaving the guest */
 		DECLARE_BITMAP(activer_exit, VGIC_V5_NR_PRIVATE_IRQS);
-		DECLARE_BITMAP(enabler_exit, VGIC_V5_NR_PRIVATE_IRQS);
 	} vgic_v5_ppi_state;
 };
=20
diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
index 5663f25905e83..e14685343191b 100644
--- a/arch/arm64/kvm/config.c
+++ b/arch/arm64/kvm/config.c
@@ -1699,6 +1699,17 @@ static void __compute_ich_hfgrtr(struct kvm_vcpu *vc=
pu)
 					     ICH_HFGRTR_EL2_ICC_IDRn_EL1);
 }
=20
+static void __compute_ich_hfgwtr(struct kvm_vcpu *vcpu)
+{
+	__compute_fgt(vcpu, ICH_HFGWTR_EL2);
+
+	/*
+	 * We present a different subset of PPIs the guest from what
+	 * exist in real hardware. We only trap writes, not reads.
+	 */
+	*vcpu_fgt(vcpu, ICH_HFGWTR_EL2) &=3D ~(ICH_HFGWTR_EL2_ICC_PPI_ENABLERn_EL=
1);
+}
+
 void kvm_vcpu_load_fgt(struct kvm_vcpu *vcpu)
 {
 	if (!cpus_have_final_cap(ARM64_HAS_FGT))
@@ -1721,7 +1732,7 @@ void kvm_vcpu_load_fgt(struct kvm_vcpu *vcpu)
=20
 	if (cpus_have_final_cap(ARM64_HAS_GICV5_CPUIF)) {
 		__compute_ich_hfgrtr(vcpu);
-		__compute_fgt(vcpu, ICH_HFGWTR_EL2);
+		__compute_ich_hfgwtr(vcpu);
 		__compute_fgt(vcpu, ICH_HFGITR_EL2);
 	}
 }
diff --git a/arch/arm64/kvm/hyp/vgic-v5-sr.c b/arch/arm64/kvm/hyp/vgic-v5-s=
r.c
index f34ea219cc4e9..2c4304ffa9f33 100644
--- a/arch/arm64/kvm/hyp/vgic-v5-sr.c
+++ b/arch/arm64/kvm/hyp/vgic-v5-sr.c
@@ -37,8 +37,6 @@ void __vgic_v5_save_ppi_state(struct vgic_v5_cpu_if *cpu_=
if)
=20
 	bitmap_write(host_data_ptr(vgic_v5_ppi_state)->activer_exit,
 		     read_sysreg_s(SYS_ICH_PPI_ACTIVER0_EL2), 0, 64);
-	bitmap_write(host_data_ptr(vgic_v5_ppi_state)->enabler_exit,
-		     read_sysreg_s(SYS_ICH_PPI_ENABLER0_EL2), 0, 64);
 	bitmap_write(host_data_ptr(vgic_v5_ppi_state)->pendr_exit,
 		     read_sysreg_s(SYS_ICH_PPI_PENDR0_EL2), 0, 64);
=20
@@ -54,8 +52,6 @@ void __vgic_v5_save_ppi_state(struct vgic_v5_cpu_if *cpu_=
if)
 	if (VGIC_V5_NR_PRIVATE_IRQS =3D=3D 128) {
 		bitmap_write(host_data_ptr(vgic_v5_ppi_state)->activer_exit,
 			     read_sysreg_s(SYS_ICH_PPI_ACTIVER1_EL2), 64, 64);
-		bitmap_write(host_data_ptr(vgic_v5_ppi_state)->enabler_exit,
-			     read_sysreg_s(SYS_ICH_PPI_ENABLER1_EL2), 64, 64);
 		bitmap_write(host_data_ptr(vgic_v5_ppi_state)->pendr_exit,
 			     read_sysreg_s(SYS_ICH_PPI_PENDR1_EL2), 64, 64);
=20
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 85300e76bbe46..e1001544d4f40 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -718,6 +718,54 @@ static bool access_gicv5_iaffid(struct kvm_vcpu *vcpu,=
 struct sys_reg_params *p,
 	return true;
 }
=20
+static bool access_gicv5_ppi_enabler(struct kvm_vcpu *vcpu,
+				     struct sys_reg_params *p,
+				     const struct sys_reg_desc *r)
+{
+	unsigned long *mask =3D vcpu->kvm->arch.vgic.gicv5_vm.vgic_ppi_mask;
+	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+	int i;
+
+	/* We never expect to get here with a read! */
+	if (WARN_ON_ONCE(!p->is_write))
+		return undef_access(vcpu, p, r);
+
+	/*
+	 * If we're only handling architected PPIs and the guest writes to the
+	 * enable for the non-architected PPIs, we just return as there's
+	 * nothing to do at all. We don't even allocate the storage for them in
+	 * this case.
+	 */
+	if (VGIC_V5_NR_PRIVATE_IRQS =3D=3D 64 && p->Op2 % 2)
+		return true;
+
+	/*
+	 * Merge the raw guest write into out bitmap at an offset of either 0 or
+	 * 64, then and it with our PPI mask.
+	 */
+	bitmap_write(cpu_if->vgic_ppi_enabler, p->regval, 64 * (p->Op2 % 2), 64);
+	bitmap_and(cpu_if->vgic_ppi_enabler, cpu_if->vgic_ppi_enabler, mask,
+		   VGIC_V5_NR_PRIVATE_IRQS);
+
+	/*
+	 * Sync the change in enable states to the vgic_irqs. We consider all
+	 * PPIs as we don't expose many to the guest.
+	 */
+	for_each_set_bit(i, mask, VGIC_V5_NR_PRIVATE_IRQS) {
+		u32 intid =3D vgic_v5_make_ppi(i);
+		struct vgic_irq *irq;
+
+		irq =3D vgic_get_vcpu_irq(vcpu, intid);
+
+		scoped_guard(raw_spinlock_irqsave, &irq->irq_lock)
+			irq->enabled =3D test_bit(i, cpu_if->vgic_ppi_enabler);
+
+		vgic_put_irq(vcpu->kvm, irq);
+	}
+
+	return true;
+}
+
 static bool trap_raz_wi(struct kvm_vcpu *vcpu,
 			struct sys_reg_params *p,
 			const struct sys_reg_desc *r)
@@ -3444,6 +3492,8 @@ static const struct sys_reg_desc sys_reg_descs[] =3D =
{
 	{ SYS_DESC(SYS_ICC_AP1R3_EL1), undef_access },
 	{ SYS_DESC(SYS_ICC_IDR0_EL1), access_gicv5_idr0 },
 	{ SYS_DESC(SYS_ICC_IAFFIDR_EL1), access_gicv5_iaffid },
+	{ SYS_DESC(SYS_ICC_PPI_ENABLER0_EL1), access_gicv5_ppi_enabler },
+	{ SYS_DESC(SYS_ICC_PPI_ENABLER1_EL1), access_gicv5_ppi_enabler },
 	{ SYS_DESC(SYS_ICC_DIR_EL1), access_gic_dir },
 	{ SYS_DESC(SYS_ICC_RPR_EL1), undef_access },
 	{ SYS_DESC(SYS_ICC_SGI1R_EL1), access_gic_sgi },
--=20
2.34.1
