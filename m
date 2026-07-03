Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010062.outbound.protection.outlook.com [52.101.84.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F8B62C15BB
	for <kvmarm@lists.linux.dev>; Fri,  3 Jul 2026 15:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.62
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783094270; cv=fail; b=nt5UyoO/dp4f++qc04Knk+O1kz4nDsq9tEoyUQ2a7HizDSC6cnU7aS2FFGUskC5k2fUJ5TaHDbmaD+ScOYxuVZC8DBS9etvIdlzROTwNLo91CwOLrgpmE0an/WAiGrUmIU+G1MEdgBsDT0sFKs9moXmFRT1akHctw85GL21OTf8=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783094270; c=relaxed/simple;
	bh=3v8vJbFf3qpxXZm2+zMFjTE8VUUjGuKul3cdW/qCs8k=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=sJ51eAQDIq1feG8XzFFiI6OnlP9XB2unT6Fo0fzVoiDNcAbeLjol2WVolIJiIr8ju4ybtolfZrxWRRkoBtIDnTweNx6uX5YkcimldgbpCwrBkEp7RbLrG2l7lCXj2tivIFrLUrGlTh61nOyJXenR3bfIkdNCp5dZsoH1SsdyS1I=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=KQgyr6jM; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=KQgyr6jM; arc=fail smtp.client-ip=52.101.84.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="KQgyr6jM";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="KQgyr6jM"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=K/tUr3visJIEO4R3HKQMhUWPfPPHAf90NutxuzD1eJ3uaMBlAA8vgASrPMgTk6djnQwbZKqrZIsB997+eVNUEKZZ+21FgfLrvW83yWQ1xmXVNyGKtTOjQSnYlE9wYRgMMyE9zKT1q54YrdL3DHtM14gOGyax0vN+nu+XkBz2EwjkViS00kEthETXdhbPgCOSUeqyPkpbyRVAxLkJqijmpFAp65BbkK9V6tO6dzxroiSGxrv3ZdFtoM58758oXTJJw/K7lSkstgj7iihz1HjbLnjxe/tcsENk+OWigHLAj7CUFfCYugt6xNqSnjYKVoioPgSEZpkvfnuVv4iHjQIORg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aX5JUddT0ABcdm4KoFK42TuiiLlgXHFKY7oDCLleeGg=;
 b=BzbIhzzSq3kVlsGxNbzZRHd247mHOgTcT0qD/nZF6eay1U/NcUd6R3G7pwLSE3FTL8HvNqWl29Ksp5g8+kKfICiUWXsf+hBDKmdkAlOZ764VN/75LUxHu85TU2Wnu3U/6ray1rCa0qJ9PmVZdTHPoOc2qd4z57wX1TkP1l8AfMph1BWABaJQgTsWlkqHAJwKzEyL9x9uGfEKi3nCsC+OadHQJNlA7IEzlxjGghFI+fXOK067Zz6jCPQ2xKumyu/LjVq2nDpclCKjWZXIu6Gz+EiBoGIbh8E//VoKuV7ivjnZB1FFw4EDJMbnavIPzV1TpLBPjGTto2zWWC7KzGKZEw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aX5JUddT0ABcdm4KoFK42TuiiLlgXHFKY7oDCLleeGg=;
 b=KQgyr6jMGUF8D77D3Fw8fo+p2lj+aiG5TknAESPPRePEof/tNuJ573wVIkA2FPofCcvslSFzsrYl6XtYZgJBsw4OWJGnyOK7VTEWTxukazH9kKAvxVa19wqkEa/EYfFWQiiBKH8IDtwFTaIUE84JAdBt8Q762qxVd50pJP60aR8=
Received: from DU7PR01CA0045.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:50e::18) by AM8PR08MB5729.eurprd08.prod.outlook.com
 (2603:10a6:20b:1de::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.11; Fri, 3 Jul
 2026 15:57:42 +0000
Received: from DB5PEPF00014B8A.eurprd02.prod.outlook.com
 (2603:10a6:10:50e:cafe::8f) by DU7PR01CA0045.outlook.office365.com
 (2603:10a6:10:50e::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.11 via Frontend Transport; Fri, 3
 Jul 2026 15:57:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB5PEPF00014B8A.mail.protection.outlook.com (10.167.8.198) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.6
 via Frontend Transport; Fri, 3 Jul 2026 15:57:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yxS81dYq3DfwL+Isjw1fmNfxpdFkkW1Fdu74rQi4pRHIi62+3HHhCn44y70/WzFFCDUBI73rkpgnUwJi6AMMLAcI5k52E2i1HoaIR/2VvkWy3y5rXWn3Yp28RJRT6XBRViElDg8aKPcGB6RozEqoBMkjXJbig3HY17dI3GowQ6wZo6Pz/Q4maAm9a4I+6HDOFSNYA1LSC1NuljjZyF7vbYXQf7+TzsXqY1WdJYDrAsmtJF1ivrN2K/Y/Kx9sAGoYd3bC72VpzAYKozfQ4sJJOx3ZWj/xQ9/KPUw8pe07Gr8O4zOq+rp5cy4P0talJ/iNUb35uSbMJ04NO/m4QMc02g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aX5JUddT0ABcdm4KoFK42TuiiLlgXHFKY7oDCLleeGg=;
 b=iRXNl2reqly79wsiHGtzamqvIIqA+tdB4aRM4VX8tfFQNJQk68ZMB4VWnPZ7osh7pJQ8kEvoi09+WbH3do1tQZxq+Ec2qwt74su24PVkxxnf8QyJKnZmWPcE3udVx+rE/YvZj8aFgIHXyFDUDNueuhDotaTgt3YhxQnAZi51t1EBU++KbUX4Zq3u5jzQoa7vzWw0dL7CxWeG3I404/m30DkyWTzdugk2mOPBjXYn5lNMM9cD2I/VGJu+lsv1QY3VzxV3g7l0bs31dfXCbk6jwubkhb5Cfb6rHTQAjEG9uTOV+OVY5Suwxs6jsyO08/Vwwtz8dxjc349XvGq7PgNaLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aX5JUddT0ABcdm4KoFK42TuiiLlgXHFKY7oDCLleeGg=;
 b=KQgyr6jMGUF8D77D3Fw8fo+p2lj+aiG5TknAESPPRePEof/tNuJ573wVIkA2FPofCcvslSFzsrYl6XtYZgJBsw4OWJGnyOK7VTEWTxukazH9kKAvxVa19wqkEa/EYfFWQiiBKH8IDtwFTaIUE84JAdBt8Q762qxVd50pJP60aR8=
Received: from DU2PR08MB7310.eurprd08.prod.outlook.com (2603:10a6:10:2e5::5)
 by PAWPR08MB11014.eurprd08.prod.outlook.com (2603:10a6:102:46c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.11; Fri, 3 Jul
 2026 15:56:39 +0000
Received: from DU2PR08MB7310.eurprd08.prod.outlook.com
 ([fe80::e007:b494:8a24:1fc0]) by DU2PR08MB7310.eurprd08.prod.outlook.com
 ([fe80::e007:b494:8a24:1fc0%4]) with mapi id 15.21.0181.009; Fri, 3 Jul 2026
 15:56:39 +0000
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
Subject: [PATCH v3 12/40] KVM: arm64: gic-v5: Keep GICv5 vCPU limit
 model-specific
Thread-Topic: [PATCH v3 12/40] KVM: arm64: gic-v5: Keep GICv5 vCPU limit
 model-specific
Thread-Index: AQHdCwSJ/BYbY93Q6EKISnhafqaAjA==
Date: Fri, 3 Jul 2026 15:56:39 +0000
Message-ID: <20260703154811.3355680-13-sascha.bischoff@arm.com>
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
	DU2PR08MB7310:EE_|PAWPR08MB11014:EE_|DB5PEPF00014B8A:EE_|AM8PR08MB5729:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f1f175a-9ff9-4497-bf47-08ded91bd0a1
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|23010399003|38070700021|56012099006|11063799006|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info-Original:
 kN6UNv947uTMDhvyACyQNzbaBYUJ8bd7eBr0cS/iT5CBy4+zaruD5dfeXxYPn+GI051kR2azqYf2nQeZp2uBZJmC0vXsoUs5mqsuyGrAFYof0RUZSJQvl3xbEzGrgSMxtxsCuRLoBWn4MZdNRo1P16UNAEllrsS6nTisw71wV4DkD/iI6oyGw9tdweVvFp2d0jQGHS6mnlrYV1AikGw342Jsz3xz8j/Zx9V2PXXszrD5aEQXaXSb/jAx8HW+KCYFO3SW1kqk7C421o4G0s1msA7iqoykzjrByfhX+uUgB+9ugDJ7MSF97lxXjo1rdrOXje9IwOtRguyKCwBE6nd2m56K4mmYHNENNzV4c3758SUr22h1K2Dr7V40bO5pfnhxmFTVpKcw1EiW4i+Kk/O3MJGSfOBpCcs3RtgqlmklCQamgfWLKFreockTrf+8C5vm/hhrlJIbT13sZuT/4Um4zG15NFS3CwVvr1giS2aVs0KRUEw2+ss9dDztxRBQkyVfIYLF1O0tYHgi2RrQxgM4a7Gxneyx4ZzDKnY1BWfIpVRgau/qGpkxw2jEIC7E9cHGJYDz3BCbe21IHWVb+QHjjIVU6Is/UyrNWbBQk3/+tdSftd8PuopTqWerdrqa2Fwb3UNMGx7P35Gm5h8QA2ryCyCiZU8cvkcEl0d46EiKbZ/R7/4f2sL1Vgt6lUd5/29/bv43f594ghB0sE1OY1mRaydFawdZB/VdlYgfdraBHeE=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU2PR08MB7310.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(23010399003)(38070700021)(56012099006)(11063799006)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 emsInYwZlKZ2c/1gcl8qK0Sdy+uPwVqZ6yygYc7cPJF427tdGtAH3+e+TPri3p92YPBSuiUlkK2IT74AokwcAH4G0Mi8qSvhNkljrNYtgHEZGWs4eqcHQaYyY2GGRk78eSC0gJOn9WK1pt50sV5CJ/Ti0NMKAAR8M7E3N8k1E0UfDoR5VTGVn3FzlCk4jjy6Qq2NkIth8ZexW77p9cZeNoUaF3bRRzAZyekqhF+CU8Va6HypHo4kTs5iHKJP/n+xJiiIdL+splBC3UFlheB7jjhO5+HlMbYwoB8hojaAOCGxaytWkUmXNwIgtSHWItp4UFHHsBJ7f9wjiZ2t+nhrRw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR08MB11014
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB5PEPF00014B8A.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	5983c25d-df45-44e5-57d7-08ded91bab85
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700016|35042699022|1800799024|82310400026|14060799003|23010399003|11063799006|56012099006|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	H0Zvpx12b9wAz9q3VyDA7PNg2j/WKBfVmMwNQAxe4NEteZqbeY6hrKyjBOGKUnl3ToyE21LO9umEO6DkF8IhdWbvKfaDVG982JHvQp1GHc8L00OR2R2clODBl06O8ZdFayUT9DIHTo798EFs4saeLS65tSZ9lpk/DML/yOpsUmTH7sm9XCGHA3M7Iciujt7P8V9uNfmxEE39XGRzWYfg5AS/1TeNr993HS77PZ6PLegjR3u4tWcx01fz90Y0P65n1wpgbHMxtfB49uFRj5C9LxrlHyZ5pZnWhi44g/HTFP4A/goCFU9DCYY+IzrBogEdEkvv9jV5C+7q9krJKz1gSndDlaMRCP4nIrFJyicR89wzzYegC9upe39T7kMbNZmbsxxD69X3HzupD8O5IiWSFLGPlE98IE0+wvZO0ye/wOA7VCsfuGShquDF1SfvarSNoYL7y7wIDSxEahFaW0GD/NB4LwwXqEEY3+OOS4JayoHw0wOaJ7hksFLVWHNyrTBjZUf20zbCX0jI8UNxKC5r6GeRXr+39AIfL7108q6wRDgiFEUpty+L115x6PZzPx5mK0xR0IBsifgqlAd8xnltFBlDY4pYkVYiYJ7V4EBU9EHEaz0VLUdElK3DvejaC1kvvxoFPssyzmrONcokN3rHq6Bnz33ntng33cuVf0uZHoidsqOWK/loYmL7T1HWCgiKt4MCv7ex71aB8Fqq/nn2OQ==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(36860700016)(35042699022)(1800799024)(82310400026)(14060799003)(23010399003)(11063799006)(56012099006)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	CmcGD1/L5yWK8OKWDUhcRiOdjcwaLygnrEQwYU0iKDnd96q1k/Don8MUyzD0S7MrGWQ5ANhj8gaTQvJitt9rOfRAoiDONn2ST472G19TebBABbMBwdXzQ3zXwk6f1IQ93F4PbA+OUyITqU0H5aW7KUFA4EEj5DWFWzokHDHrW0TUbw1GDrkfPzaszUtBMJi0+REo/4Ytdpa+VkuuB5bLHiMqHLlsxXrMxS+2+zM60JFmd1ALwluvHwSJFJj/Cn1ZTYiTaujFTFHXS1XS13P2gSuv67HJ9zJ05Lgld2V3pAaYk+k58pjJ0wX29OW4NkkNTqV+242rlIB7K1DqU/5xQ9c/QFZ5ugzCrBzGyqmbfcnMvG25eiKRyVdWSEr+o1/KYxpeHIdUr1e5WtQ2+9bUDS8d/IFqOVPuV5r1a/d7pX1aD48YVlh+I7790YCOP5MR
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2026 15:57:41.9719
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f1f175a-9ff9-4497-bf47-08ded91bd0a1
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB5PEPF00014B8A.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR08MB5729

A GICv5 host with FEAT_GCIE_LEGACY can expose both a native vGICv5 or
a vGICv3 device. These models do not necessarily have the same vCPU
limit: the native GICv5 limit is probed from the IRS VPE capacity,
while the GICv3 limit remains the fixed KVM vGICv3 limit.

Keep the IRS-derived limit separately for vGICv5 creation. The
pre-VGIC KVM_CAP_MAX_VCPUS value continues to expose the largest limit
among the still-selectable models, and kvm_vgic_create() clamps the VM
to the limit of the VGIC model userspace actually selected.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-init.c | 14 +++++++++-----
 arch/arm64/kvm/vgic/vgic-v5.c   | 19 +++++++++----------
 include/kvm/arm_vgic.h          | 16 ++++++++++++----
 3 files changed, 30 insertions(+), 19 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-ini=
t.c
index 079a57c2b18f6..94632fd90b728 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -129,13 +129,17 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
 	}
 	ret =3D 0;
=20
-	if (type =3D=3D KVM_DEV_TYPE_ARM_VGIC_V2)
+	switch (type) {
+	case KVM_DEV_TYPE_ARM_VGIC_V2:
 		kvm->max_vcpus =3D VGIC_V2_MAX_CPUS;
-	else if (type =3D=3D KVM_DEV_TYPE_ARM_VGIC_V3)
+		break;
+	case KVM_DEV_TYPE_ARM_VGIC_V3:
 		kvm->max_vcpus =3D VGIC_V3_MAX_CPUS;
-	else if (type =3D=3D KVM_DEV_TYPE_ARM_VGIC_V5)
-		kvm->max_vcpus =3D min(VGIC_V5_MAX_CPUS,
-				     kvm_vgic_global_state.max_gic_vcpus);
+		break;
+	case KVM_DEV_TYPE_ARM_VGIC_V5:
+		kvm->max_vcpus =3D kvm_vgic_global_state.max_gicv5_vcpus;
+		break;
+	}
=20
 	if (atomic_read(&kvm->online_vcpus) > kvm->max_vcpus) {
 		ret =3D -E2BIG;
diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index 14adc82b65828..fd64ea0173b2f 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -110,7 +110,8 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
 	int ret;
=20
 	kvm_vgic_global_state.type =3D VGIC_V5;
-	kvm_vgic_global_state.max_gic_vcpus =3D VGIC_V5_MAX_CPUS;
+	kvm_vgic_global_state.max_gic_vcpus =3D 0;
+	kvm_vgic_global_state.max_gicv5_vcpus =3D 0;
=20
 	kvm_vgic_global_state.vcpu_base =3D 0;
 	kvm_vgic_global_state.vctrl_base =3D NULL;
@@ -135,8 +136,8 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
 	 * Even if the HW supports more per-VM vCPUs, artificially cap as we
 	 * can't use them all.
 	 */
-	kvm_vgic_global_state.max_gic_vcpus =3D min(irs_caps.max_vpes,
-						  VGIC_V5_MAX_CPUS);
+	kvm_vgic_global_state.max_gicv5_vcpus =3D min(irs_caps.max_vpes,
+						    VGIC_V5_MAX_CPUS);
=20
 	/*
 	 * GICv5 requires a set of tables to be allocated in order to manage
@@ -145,7 +146,7 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
 	 * we want to run. For now, we match the maximum number offered by the
 	 * hardware, but this might not be a wise choice in the long term.
 	 */
-	ret =3D vgic_v5_vmt_allocate(kvm_vgic_global_state.max_gic_vcpus);
+	ret =3D vgic_v5_vmt_allocate(kvm_vgic_global_state.max_gicv5_vcpus);
 	if (ret) {
 		kvm_err("Failed to allocate the GICv5 VM tables; no GICv5 support\n");
 		return -ENODEV;
@@ -166,9 +167,6 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
 		return -ENODEV;
 	}
=20
-	kvm_vgic_global_state.max_gic_vcpus =3D min(irs_caps.max_vpes,
-						  VGIC_V5_MAX_CPUS);
-
 	ret =3D kvm_register_vgic_device(KVM_DEV_TYPE_ARM_VGIC_V5);
 	if (ret) {
 		kvm_err("Cannot register GICv5 KVM device.\n");
@@ -182,6 +180,8 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
 	}
=20
 	v5_registered =3D true;
+	kvm_vgic_global_state.max_gic_vcpus =3D
+		kvm_vgic_global_state.max_gicv5_vcpus;
 	kvm_info("GCIE system register CPU interface\n");
=20
 skip_v5:
@@ -209,9 +209,8 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
 		return v5_registered ? 0 : ret;
 	}
=20
-	/* We potentially limit the max VCPUs further than we need to here */
-	kvm_vgic_global_state.max_gic_vcpus =3D min(VGIC_V3_MAX_CPUS,
-						  kvm_vgic_global_state.max_gic_vcpus);
+	kvm_vgic_global_state.max_gic_vcpus =3D max(kvm_vgic_global_state.max_gic=
_vcpus,
+						  VGIC_V3_MAX_CPUS);
=20
 	static_branch_enable(&kvm_vgic_global_state.gicv3_cpuif);
 	kvm_info("GCIE legacy system register CPU interface\n");
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index ba32cd71fe0a7..6f736094a0e7e 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -157,9 +157,16 @@ struct vgic_global {
 	/* Maintenance IRQ number */
 	unsigned int		maint_irq;
=20
-	/* maximum number of VCPUs allowed (GICv2 limits us to 8) */
+	/*
+	 * Maximum number of VCPUs exposed before userspace has selected a
+	 * VGIC model. Individual VGIC models can impose a lower limit
+	 * (GICv2 limits us to 8).
+	 */
 	int			max_gic_vcpus;
=20
+	/* Maximum number of VCPUs allowed for a GICv5 VM. */
+	int			max_gicv5_vcpus;
+
 	/* Only needed for the legacy KVM_CREATE_IRQCHIP */
 	bool			can_emulate_gicv2;
=20
@@ -635,10 +642,11 @@ void kvm_vgic_process_async_update(struct kvm_vcpu *v=
cpu);
 void vgic_v3_dispatch_sgi(struct kvm_vcpu *vcpu, u64 reg, bool allow_group=
1);
=20
 /**
- * kvm_vgic_get_max_vcpus - Get the maximum number of VCPUs allowed by HW
+ * kvm_vgic_get_max_vcpus - Get the pre-VGIC-selection VCPU limit
  *
- * The host's GIC naturally limits the maximum amount of VCPUs a guest
- * can use.
+ * Userspace can query KVM_CAP_MAX_VCPUS before selecting a VGIC model, so
+ * expose the highest model-specific limit and let kvm_vgic_create() enfor=
ce
+ * the selected model's actual limit.
  */
 static inline int kvm_vgic_get_max_vcpus(void)
 {
--=20
2.34.1
