Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012044.outbound.protection.outlook.com [52.101.66.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32007946A
	for <kvmarm@lists.linux.dev>; Thu, 21 May 2026 15:00:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.44
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779375639; cv=fail; b=l+7JebdHaMm2jSWIinvIExMWT9CFsOufWUeER+4e6F/AH/QIhMwdPgjuk1wOAhIK7loc/jA5xBKNM4ENga/fpZa0mVN8EpFsjHZ5ynBZlbWCBnxjjWQ9Wn3ScAXMJhjON75jM4qf1pILCVbwEBS5TCjWahRfNDgt2Pb3XQwcgxA=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779375639; c=relaxed/simple;
	bh=8+A+TC7MrwXMpddgNQQthV0UrBPjsqGpxnwsfxivzjg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=kgVgcTfkOgCs0nEYbJNFnVfT0zWTgs+qO5ShMMiTegg8CBqJtC/7sXlB/9n4za6C2W8jDT52w7mfWQ9PQdVDgWxS5PufY0zHILOVFDZlEsI/SdAIP4TEIQLbI4NMbdVkzTJ5FyqjS+wDyKT7C75aKfOeWJo+pP2K3PEXJKIjxh0=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=VijqU5l5; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=VijqU5l5; arc=fail smtp.client-ip=52.101.66.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="VijqU5l5";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="VijqU5l5"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=fail;
 b=ck1DjNABdbukzIJmuPqz5cFOeYKF6Y0PlZPkO0HjXTdgVfhXPaR/sSYYquNXRfO314pbjB5hTDDcckhjvqnOox+QA6BEDNMM/nulQFrqqhTXxvReMM4BUgkANpUUxnWw9xn+oMYLRtFnQ7CbhKtiLu1eKntvy19yNCD/+MByqW+ZqOXaGTmdzJgJy7RaJ8m6CEyG5BprqeixaGfiwj9L8pXo/svnMQU0n1O8ZghaLiE4BpatS1Qc6WjnKrslWAZ3HFVOkKTTMFaFSogwEoKIBJ9wbfFbMWj42+qK6aJ1OEpNUJ+OXxZQL9SXjsKCE/HTRBkGfQJuR6Ffk+cAXb8rJw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kf1Yme0z97IL/I9juDufayoR8hsiCslk0j3/BdCBogw=;
 b=TOndZJYtNAzcBpH69XRHqC74YzNAkKaoKDz6ff6NGs8/WjLRE0JZ4+XwM61dbLs2MSPLOhNRLCY4iFvnrUe1SCJHzP38lB88WgJn4zGboRrRtxTP7aPl6mVdF6gURtD9HIOtn12MoBxkDvgBbgbZmsaOgIuIVplKdjCKb7mNmpmClfVB4+cRTjQe8reERztDF3IqYhTmpg2TrxFNEbbGl4GBA7YjbdE6n7FcuiT96ZYNp/JRFbg+tmjzGIwURom5PBZubCgU76hg0cICjwCdaqCICc+n6QWaBYzrbv73dN7JqVQOK3hIjkmWNyzuO7W7x1YjSsPdpjz4RNKqYesL4w==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=fail (48)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kf1Yme0z97IL/I9juDufayoR8hsiCslk0j3/BdCBogw=;
 b=VijqU5l5jQxcHyw6Fh/9cd9St6jz/WgFlquJbCtr6NiKiuMltAdV2c+odWNmcOuHGeDA1S1GaIjS4L1+Q6Tjl39YxTO5hPuT7LmUo39DCXS4OvN2KnSMEUioelk30Ci4vgLKYDanPYrCFYD/tUKY/4txyvVw4UYoHhY4NuMoFOM=
Received: from CWLP123CA0223.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:19f::6)
 by AS8PR08MB8898.eurprd08.prod.outlook.com (2603:10a6:20b:5b7::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.17; Thu, 21 May
 2026 15:00:32 +0000
Received: from AMS0EPF000001A9.eurprd05.prod.outlook.com
 (2603:10a6:400:19f:cafe::a8) by CWLP123CA0223.outlook.office365.com
 (2603:10a6:400:19f::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.48.17 via Frontend Transport; Thu, 21
 May 2026 15:00:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF000001A9.mail.protection.outlook.com (10.167.16.149) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.71.7 via
 Frontend Transport; Thu, 21 May 2026 15:00:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=l6GNNG/cHU341Qz2Sg4Uvs9YXdokHI+cqh/IEravQykJemQsqFOah25d8uhuZb/axwhBQRmFZ4m2sHFaGN4HzbRpscAU/igPvOhWYSFq5hZtRHaO9b1rKCNFd1e02uRGqObgD6bocK0GGfPxlJ98mgS/LZiPn8EkGebpLg5jNRjdtnFNgJA+w1v03Bq4NdZfOHjpQ74wQw2ZdbEOrn9eOgu3NQp+9zd5/Thdx4og7Vt29zMFgolUK24C/tqmKPfuhyzRbu/tFmmhp2D9iyU1TrJXc8gSbsPSwhx6thv89cq6qwfs5u/XCZsQ/4SGxJ6EOAIEy8tVneG1SHgzu0G3aA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kf1Yme0z97IL/I9juDufayoR8hsiCslk0j3/BdCBogw=;
 b=Dfajtbp/Qu8Ar3Lnvod/uaIIzf46GfvZOUbi38YrwphcCwhIlkBfwwkajqYrY707IENfmCAubXdGqQkInkzivd1CtbhVb/H08d4J9GjKq8PoL0jlPqH13Bg4gprNTxwtM5YzsnrZkBK+99c/G5U+ff0poj4Ff4eD0tTHA2XQvNRHwsmlQ4RetWpHDwcWqwcCF5ns6YmLU25SropLS8eFw/6ZufJpQ1YRTe8dxENxU23mW3fbiqziZrZS8C2IdtZ1QNc0SvIypd3HX0T2IU4RGTMQOnus7z21PQV0ifhIPBuC3pbgEBdoeVqoODNSF1rHBRLwnN7GI2VJfU+wPvGf8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kf1Yme0z97IL/I9juDufayoR8hsiCslk0j3/BdCBogw=;
 b=VijqU5l5jQxcHyw6Fh/9cd9St6jz/WgFlquJbCtr6NiKiuMltAdV2c+odWNmcOuHGeDA1S1GaIjS4L1+Q6Tjl39YxTO5hPuT7LmUo39DCXS4OvN2KnSMEUioelk30Ci4vgLKYDanPYrCFYD/tUKY/4txyvVw4UYoHhY4NuMoFOM=
Received: from GV1PR08MB7315.eurprd08.prod.outlook.com (2603:10a6:150:1e::15)
 by DBBPR08MB6204.eurprd08.prod.outlook.com (2603:10a6:10:1f5::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.17; Thu, 21 May
 2026 14:59:28 +0000
Received: from GV1PR08MB7315.eurprd08.prod.outlook.com
 ([fe80::c249:1aed:a4c2:4193]) by GV1PR08MB7315.eurprd08.prod.outlook.com
 ([fe80::c249:1aed:a4c2:4193%3]) with mapi id 15.21.0048.013; Thu, 21 May 2026
 14:59:28 +0000
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
Subject: [PATCH v2 30/39] Documentation: KVM: Extend VGICv5 docs for
 KVM_VGIC_V5_ADDR_TYPE_IRS
Thread-Topic: [PATCH v2 30/39] Documentation: KVM: Extend VGICv5 docs for
 KVM_VGIC_V5_ADDR_TYPE_IRS
Thread-Index: AQHc6TJrOQi/gCmeJkifFrt3LzCUpw==
Date: Thu, 21 May 2026 14:59:28 +0000
Message-ID: <20260521144846.1899475-31-sascha.bischoff@arm.com>
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
	GV1PR08MB7315:EE_|DBBPR08MB6204:EE_|AMS0EPF000001A9:EE_|AS8PR08MB8898:EE_
X-MS-Office365-Filtering-Correlation-Id: 0fc944cb-c81a-4ca4-b0fa-08deb749b452
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|22082099003|56012099003|18002099003|38070700021|11063799006;
X-Microsoft-Antispam-Message-Info-Original:
 rLUyFQJ4og4BZ0EPq+0fR0zlVEfmZTt2KqyKW5uiBWl46Mwbg3votIZRhWZBOO0fxAWYuASBNGgtgoDZz12df2J1SYSghqH1tKFIQuYY936cepTiYigca8CsnRk4kdU8ARCRjJbMdXfo+aFDsJCKZe0Mt4XSgkbSQu5UaTl+ODEDjRiCx9tbB+P4MNRKe/5bH4QwBrQwdqAGeCtpbsNlur3LznGViKzUmRUSdhw9X5b9IYwUX2iqVmMh6mmoMBmPdxVeVXkHJyk+arhpEdiHBk4m3jkgyhaQH5SphJJSErhXLhJ/v/TLC1FQ8Ru9+KxRWT4sPUeDt6IPe9zNdIERnmxgjdgoU1lUngD6Rm3ofcAEG2zwUV+toY+N17a3CT5sK3sR0Q9HgZp2lqBAKK1h2f6FAeFtjeWSopbtPq9UZIWBe1NQY/N61x7FLQrhRy/76dk8yQDRtrDjsc5M6s02dwHkcNa0fdSKwDfW2VqOaG0oApLPcf4kogSFk8WGCzBzTbwnqYW9JHdby1akdZuaKtwQBQGKrInvJk09m+7vTUeYF1LFA+j4OoEP2NWWvI9Y5UlnTQH5BTyNsyfAXfGMiyBmnEG7Cu3V7/H8VCYfH3O2hRvk8bshqEX23Lr1uhhPuOlEjiH/txKofxxIK6ElGILoUoK/GA1Q+AJNBlovpV4eu4l4q0s8hRAPHQ9inz3H2xP+DnlcMcsO4lydEGL5CaP+hxBK/Z4kmMBguaKixCgyND0uA68TMz0DoIx0pp5F
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB7315.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(22082099003)(56012099003)(18002099003)(38070700021)(11063799006);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 smMXB+AcrEGIy65PGqwSxlBn6IJFOIRHTuVmg/BpQbfLiEetZ9BYcbBoLs50AocWkwJ/Po4No7czeCaOJ+GjPv8kcGn6C9cFD7jvMERhVJm+qPdO90vn52TUVZxsZv6KsDsXmhsaFWGnPNtjnk0u4XT38TGAEBYuVNW6jYzG3bIBct9A07ngPA/Lgk2OE5NTJZ74XlX4COb5S3FtOshhQfIdwvXNeAgxmHykA0pjVylupYYq2KJL0IDjNb6v3269EstOUbq/a8qFoR1SRw1UNrnrqpi9Y+VjJvc49QX4hJO+37XmQmHuxSfygY/uqjzHZ9Nicm9iM6q7IfH3qqfpKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR08MB6204
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF000001A9.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	a808007e-7649-4bbd-b1bf-08deb7498e6e
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|1800799024|14060799003|36860700016|376014|82310400026|22082099003|56012099003|18002099003|11063799006;
X-Microsoft-Antispam-Message-Info:
	bzFDAJJieB9PsrvJax/aGIpfyvuzy1M161wdwjFTW291jYUvrYFi46J2GQg2l7HzVpd2U2qvbdw3KtDava9Jv76dMbztVu/4Yh52cL5anxn7IcAvCprENA64hTnYvd72sOjOmAhyE1rQEQ8ASRaUZSj8C51Gx7NdamSE5kq5Pyl8of4OTjGL8blPGA8LPlXzhN4iu0UQT1gLyeeehiKg5Na08rpAYt3c9p0M8x3NlDVMu/MGUbQNCjcNQVze3xWiaeGqzCgYh/yXSqtFcRYgKIF6JqBVPjM2MW9wNdQLEy0BTq55FdQ1G7jTDnWUSeGvEFYNmuKIbK1Jh3vZdIzg5BDY2opChnhgE88gcolVeAA534BqvMVRQqFl/GBBTl2NaIr2OmdElZTfilA7znVaXqUviAdS1it0BcXqNKcQePW5jPNi8MTGdZNqzx3txvDc3AI8Q99BoP9V8QzCXw2rvx0E4gtVnSQfMujfjDUAL3N1D8Ggw8k/l3HU2gU+qDRJBJEvgigoBE/Ut3Rv9fX0G/zSFqPU61/0G56pX1n2ERimoCMfb04Z/RhyH1itSCGxRboklUavQj0a9rhFnKSnf9pFKexHxQPc2RHapMmOSIBQhduU+HuVvsZM0HHSXwg9Qm5t9Aq5AtQIGYNlM4zMOUGHvA4HeBZtOK4RQFCo2k7mIsyT3bmegX8JNddfCbpPWFoEuavZ11meEAlAzs+CkAupx4t7yU4GPg7AuTVm130=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(1800799024)(14060799003)(36860700016)(376014)(82310400026)(22082099003)(56012099003)(18002099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	9pL8f3ebfci0Y3YNewXZIDdAWo5PzoXdRPj/jO6b2byCNqfzXS9IZy5T+1f92AS36/DBCBftG3mCMoyZOPFs7Ddg6f0yDSupcxha6GdEjaT/UbNIhOBRWQ7f2OR4hhkDeAAiHdEWTHIBSveXs/gXoudw9znolZeVJHhBJBKo/UzgXB/BdV/+QBDIt4ZJPOKU60MfYTjKU1kvqFQhbIHe7ysrqqSn4LCLqC62UXdgPJZeyngUFrB4Xs9mTsW37oHy+AdJxd/Sw4z7bmUYcYun5qDeUv74QIqZ7VSSZspKnmCQDkEeYp5CexJiQolAEU7QG9HTL/TCm1843hWDEUCbSsqaj+9+sfvurMRt9BjbmxORVi+85TTmL26gDvYZlb5NsiU6TRILoa/WfNvjyYPRibU8HpCs/ExnWdnvrIjl8bahtlgKpaYyZ5uVs32mLP8l
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2026 15:00:31.8080
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0fc944cb-c81a-4ca4-b0fa-08deb749b452
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF000001A9.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB8898

Now that it is possible and required to set the address of the GICv5
IRS in GPA space, update the documentation accordingly. This region
must be 64KByte-aligned, and covers a total range of 128KBytes.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 .../virt/kvm/devices/arm-vgic-v5.rst          | 35 ++++++++++++++++---
 1 file changed, 31 insertions(+), 4 deletions(-)

diff --git a/Documentation/virt/kvm/devices/arm-vgic-v5.rst b/Documentation=
/virt/kvm/devices/arm-vgic-v5.rst
index 70b9162755c7e..5c6323d82f784 100644
--- a/Documentation/virt/kvm/devices/arm-vgic-v5.rst
+++ b/Documentation/virt/kvm/devices/arm-vgic-v5.rst
@@ -12,12 +12,39 @@ Only one VGIC instance may be instantiated through this=
 API.  The created VGIC
 will act as the VM interrupt controller, requiring emulated user-space dev=
ices
 to inject interrupts to the VGIC instead of directly to CPUs.
=20
-Creating a guest GICv5 device requires a GICv5 host.  The current VGICv5 d=
evice
-only supports PPI interrupts.  These can either be injected from emulated
-in-kernel devices (such as the Arch Timer, or PMU), or via the KVM_IRQ_LIN=
E
-ioctl.
+Creating a guest GICv5 device requires a GICv5 host.  The VGICv5 device su=
pports
+PPI, SPI, and LPI interrupts.  The PPI and SPI interrupts can either be in=
jected
+from emulated in-kernel devices (such as the Arch Timer, or PMU), or via t=
he
+KVM_IRQ_LINE ioctl.  LPIs are not externally injected, but are handled in
+hardware via the LPI IST.  Their pending state is driven directly by the g=
uest.
=20
 Groups:
+  KVM_DEV_ARM_VGIC_GRP_ADDR
+   Attributes:
+
+    KVM_VGIC_V5_ADDR_TYPE_IRS (rw, 64-bit)
+      Base address in the guest physical address space of the GICv5 IRS
+      (Interrupt Routing Service) register mappings. Only valid for
+      KVM_DEV_TYPE_ARM_VGIC_V5.  This address needs to be 64K aligned and =
the
+      region covers 128 KByte - the IRS has a CONFIG_FRAME and a SETLPI_FR=
AME,
+      each of which is 64 KBytes in size.
+
+      Setting the address of the IRS in GPA space is mandatory before VGIC
+      resources are mapped, as the IRS is responsible for handling SPIs an=
d
+      LPIs. Failure to set the IRS address before the first vCPU run resul=
ts in
+      an error.
+
+  KVM_DEV_ARM_VGIC_GRP_NR_IRQS
+   Attributes:
+
+    A value describing the number of SPIs for this GIC instance. This is
+    GICv5-specific: unlike GICv2/v3, the value does not include SGIs or PP=
Is.
+    The value ranges from 32 to the maximum value reported by
+    GICV5_IRS_IDR5.SPI_RANGE, in increments of 32. If userspace does not s=
et
+    this attribute, KVM uses 32 SPIs by default.
+
+    kvm_device_attr.addr points to a __u32 value.
+
   KVM_DEV_ARM_VGIC_GRP_CTRL
    Attributes:
=20
--=20
2.34.1
