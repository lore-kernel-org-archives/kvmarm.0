Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013045.outbound.protection.outlook.com [40.107.162.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DA9D4502F
	for <kvmarm@lists.linux.dev>; Tue, 11 Aug 2026 15:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.45
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786461026; cv=fail; b=StXEnDdHeDn0kgLvGGEw2JZW/u9xExr96DE7qmM+hAeV/qYdTFdg0MOF+pDiresXrMjZHcfrU2EI3xRYzujk+s24amJl+9Pazj28FSUu9Rc+00iJNpAW4U/T6s0KEh+CFsZpHYX6WMEGWyU2xYUvSrrzfMijVZBTGYz/kf8DxGU=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786461026; c=relaxed/simple;
	bh=NcCT9QJiPIODy98jhrQTAynyV52M+VnK33SJQt0EVsY=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=EpTzebBlAEkh0Fw8RZuHeQJzRh7a09ubgiFvacGat88hyXl2Ia9RVVyIQc/Y75HseALkLuT7oyvJxWTk4cTpTpQ8bgnS0zrz+stZG4kjsWlJl/zUOEHEzgGfom8ybGz/vmvEQfEr2KqkIIEMjfcFiiaU62pufjqQbHtDSg4/7lg=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ZqFxfxJq; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ZqFxfxJq; arc=fail smtp.client-ip=40.107.162.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ZqFxfxJq";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ZqFxfxJq"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=o+TW/Wvuu7zKJO2KyaNr3kbBAVfdsZmG4uZFa7ycFDrE3uDwMQreMOobTuxAp09c2LfEf8XsfdIl2c5WKZDr+OFMu048NMOvq8C1Y4ZkXU9PJf0eoAoOM6q9t0bSJrQ2IP7LkFUH4QfOv60Cl5jz94C7B65E8A+XkGnH+YrZMStVPt+ya3bx1d1SJG5Y0MLmgOI7qLGAYzN6BElHCElInxzNTH25DMJVa40+bO6gTEBV+VAyAXd8SNlDfrZOQNJglJhiTM15xwHHlf7gPVYfkRqV7nnPd9T+x0pFehyVsEqxmQZVqPe7Yn6lKYnxkHSkn1Y1YHiocuhDgRxHKyhASw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NcCT9QJiPIODy98jhrQTAynyV52M+VnK33SJQt0EVsY=;
 b=T4I2oVJ4t5ga9q2lF+M3XZ8jZfk7jyjj9oRAM5lHRxBkReE5/4nDm8hF9diI5Ad32ZVJ5s0dChLPLc4Ogmaecrz+3ZUJv35goxZV6ClQYpBxWV7DpMG9zu8eud/rQnx5W9ZCvkqBL3ClwtgbbjEBUMunIxEMxER/ekr9k5o+/c/7y90O7DtoYIz84xxlrr4vX9Ry6WLKNZXTy9nAwbNykVGA+ILUgFSy0kmY8MjYUgAnQW8g6N7kNKG2A+5/fK6KJdf91/Gh0Ouw81Wk1qtwXQWwtj3g07XRaafVkA4Dsk/lnK+Qcz5JRV3U5LCmkB2+dQbcqPFo3aEbqXpWNyt48Q==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NcCT9QJiPIODy98jhrQTAynyV52M+VnK33SJQt0EVsY=;
 b=ZqFxfxJq5WWHLvw3+UtGpavmmpE5EN6IKhglH+bBiWex/lK6eD2y168HcR1vM2twyrL257t9pbO6pwY2GNUptf1BVUhBVvKnmvAYh0rHSFxF7xUO+WSRw0vAnO1tlFlu50aDA0Or8sUvuNmyX3Uqx9PsFoDYUTIgX3Ja4gvbRDc=
Received: from DU2PR04CA0226.eurprd04.prod.outlook.com (2603:10a6:10:2b1::21)
 by PAVPR08MB9091.eurprd08.prod.outlook.com (2603:10a6:102:32d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.11; Tue, 11 Aug
 2026 15:10:19 +0000
Received: from DU6PEPF0000B621.eurprd02.prod.outlook.com
 (2603:10a6:10:2b1:cafe::84) by DU2PR04CA0226.outlook.office365.com
 (2603:10a6:10:2b1::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.25 via Frontend Transport; Tue,
 11 Aug 2026 15:10:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU6PEPF0000B621.mail.protection.outlook.com (10.167.8.138) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.315.6
 via Frontend Transport; Tue, 11 Aug 2026 15:10:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ybw2tjJQjv+nDVyfPbErh5qLzkcp1wIeQNt+5VUb1+RUZ84yCCAhtphlxHymdyNjq/+qVnaqvq7fOT4190CYcXmdk8Cmx6ue77bhvFNRHyesRVAskBQxzk70hoKrYt72cHhcKJnOzhDBcrcSWCsD4R/lDMlAa6p80tCiEOY6OaqrTvjElRMU6dANov6QhmyVVDwGyebwUY4dvg/LyHDyMIw/4YbD2NxcYZwouyC2QWCyrMhEmcsir1gHzkuz3ngembCTqUV6A5onQpJyzuf4ihd9XvxToVHipeW+y63zTAd27PKzUDyV6UFV0bCtC/t6BvvFZmk6tfrgeJlwQ5d4Cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NcCT9QJiPIODy98jhrQTAynyV52M+VnK33SJQt0EVsY=;
 b=Zmb6inwlXJfHcN+E2Xmkuhr/gBGEkaTLW08nhpodpB4HSK1GzOSZBn0RNy5H5BujVF4/gljXCu1FQhokr5ZGzwt/Ud+h3Wc95SplqW3AeVf6QJ1yKvNXchC2XC/RzHHJ/4HMpZr3xa3k3TbmSDykehyMDOkkMOHbTqMFDztMuSZmhUEsBlD/l74QOSlg1wbFkWOunzyOewsFabUgi2/QMOXrYVjUJTtTg7F/axqQmPCv//ETlpntL9cJpDHjZg5Ii1gheHzhBrjUQZLYY6YO2EZGtcJLPS47wFHQ2pHEcj0lwMj8eLvRs0eETqL4YLwCILTG3GGJDrcpN4WM9CoHtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NcCT9QJiPIODy98jhrQTAynyV52M+VnK33SJQt0EVsY=;
 b=ZqFxfxJq5WWHLvw3+UtGpavmmpE5EN6IKhglH+bBiWex/lK6eD2y168HcR1vM2twyrL257t9pbO6pwY2GNUptf1BVUhBVvKnmvAYh0rHSFxF7xUO+WSRw0vAnO1tlFlu50aDA0Or8sUvuNmyX3Uqx9PsFoDYUTIgX3Ja4gvbRDc=
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com (2603:10a6:10:407::19)
 by AM7PR08MB5413.eurprd08.prod.outlook.com (2603:10a6:20b:10a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.11; Tue, 11 Aug
 2026 15:09:47 +0000
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e]) by DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e%6]) with mapi id 15.21.0315.008; Tue, 11 Aug 2026
 15:09:46 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>, "oupton@kernel.org"
	<oupton@kernel.org>, Joey Gouly <Joey.Gouly@arm.com>, Suzuki Poulose
	<Suzuki.Poulose@arm.com>, "yuzenghui@huawei.com" <yuzenghui@huawei.com>,
	"lpieralisi@kernel.org" <lpieralisi@kernel.org>
Subject: [PATCH v2 0/4] KVM: arm64: GICv5 KVM IRS review fixes
Thread-Topic: [PATCH v2 0/4] KVM: arm64: GICv5 KVM IRS review fixes
Thread-Index: AQHdKaNy0zmjtqfjuUSFxdsGAja3VA==
Date: Tue, 11 Aug 2026 15:09:46 +0000
Message-ID: <20260811150941.941295-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU0PR08MB8421:EE_|AM7PR08MB5413:EE_|DU6PEPF0000B621:EE_|PAVPR08MB9091:EE_
X-MS-Office365-Filtering-Correlation-Id: abb95cb9-d21e-40bf-4790-08def7baa83d
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|23010399003|366016|1800799024|6133799003|10067099003|56012099006|11063799006|18002099003|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 hKv8ZPIpBpoox3oWY6NuhIFugm4eCBcjDAy9/xzzFBffSZaLTUm1zFnauyE7wNyaIHdng62PwE5FT4yEAQyrKjyGLWgF8NLj+R7+doYo+D23NZ8N6mwTK20+y3CPIOhbce4O9LCaBM318+23JjruEn7oRMdJ0VDU77l4zJiIB5Sv3cDTAqGae1TfMi46Q229KcvS8jCCBnT1johUC4afkbdV0vP3pVOm+Nw9GLeNMOr6Tton4o+FqEjiShehVMYQwbVxQB23xOy23sNZt0zLQIY0mNKwADHs9CFM7O1rw64EaypAlVn84FjmoEaVAvtOJgurUtn94le2LeQjGOBviZE6qIDMeYE7gNIETwK4ukr1Otj3AoLxq0iYJFRcH/JFc9VNPz8UiZGFY4vtDgTz1a+QtQ8D+uHkn4IlqR4qlM6L37s9GahJ7HB91MXaQvlVaLXB9CH3adAHD2ucbXoNsCxWz6PCe68qO9hHszmhWavxkSG6YOdUkyBZTyANEPln66GuP8bPpDKoC2sQlZscXMAppDn3fljQnbC60iu4TGWSFrzpmr8ydlvcqSRC2o83GrdYNtvfqTDROaAQef1IJVDg2R4aujdbMY4esFM24NC2/jrsh3gGro49YzrCRu7apfYzNaWctBae3Xe0RcDJRY13i2U126HYea1IN4u3r3I=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB8421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(366016)(1800799024)(6133799003)(10067099003)(56012099006)(11063799006)(18002099003)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 bYzgl1zKeuHTplOU1Ujo8mqnAoJlJxXxpbs8E+yqrHfBMbJ+rAaHc6tAbbquQhkPMu7eK87D2lzqZLvJ/4Zi4W2EuYCmghkHVl9x+L9cuT895HJ9ypCiRyPGiIdpcbkCTPMCQyw1P1+TRyqjqd4Ck72F3EFOLeUiSvNIYN23e4kWpBtBbYbVOYkMiCmygQ31Vw7QyK2DRoc3HsWJIdXhP5uH2QnDkt15+ZdwFL5nUT8JlzvY2c4BRYp2z7k+M57ZrYe3QUZaVvZRjygo2VibLIWU03XmhBBAxzj66peoY5bIBlgZp5QWRlMOh4kIRfJb5j5gZ5qnCXl0pOAx43cdUw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR08MB5413
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU6PEPF0000B621.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	328e8078-5f3f-4bd2-64c9-08def7ba94fc
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|1800799024|36860700016|14060799003|82310400026|35042699022|13003099007|6133799003|56012099006|11063799006|10067099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	vrkylGnGni3cDb3QaaJFOGzbMZjD1/ZIf68RGr8UxrSm4+4xQbCuEepc1GtBuCzZXkuhmaTDdDdhvd5tN+hcakZGN1wEwGQKGlzMe7Vz1YcGvnKkzko0nfUBFSkCjWSDAHwJ5Py80nw+ooJB9PAPsnsoA/vjBbWa1m4RBrxn1Bs01dkmUupoJL93N54cw0jO/5wluhoj2DcwZoCxx2NVSG4fdJrBIj8nN59DCOuVrctsc70wJZvCJKbfNsUWBFpmhmUH67eWF6c45keL4APMAk1pvqQmQY9E9uCdxEnGuH5AsWZHmNW3rDcfr0cyb0C0f0afP3/Rot2FBedNhbuDikZIFAKPapLWL7rhw8U755DBcX+yjcA4vSkWnS0sJtKvEzqNB7o0HBr4TcpkN4BWype405pmnDvAFdD+/5RHKJ2D4XlPxHfEH/jjvbjodsily0YCkzzVZeX2OapmPOBS/TKb/qJeo1PVvft/GfmwOy6rjbuRGZpJ3xc1kmZEnre/lpR7OSBJR47E4Qme6a2ydF/a75Om2NnK5Us+1YKMME8aJSYirynXNiM0HR+K0R+sA00vPH17v7VhSnXwSxI5l/U1KFybl/CBkgrzcWHkUVulIpe46RKSWIcJQhybtoYpW+E12/KT7KYDuaQUfxgUZQ==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(36860700016)(14060799003)(82310400026)(35042699022)(13003099007)(6133799003)(56012099006)(11063799006)(10067099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	GxlyuR20XFqvAVT5Zkf4dNfFrKpcLwFUZyy9TFDIYPcuPGclkscqSDdhRcZljJkZ96zzQjVJzyEWldfQHtVLl+UdI8xjLTTClq7HDDnYCMwhiRJ2zzpqczZYjtAyU2dYXhPh1iatkqr41kFfdJdkr6wnpRnKjmd3OXChD4f+CG61ofRRxB8bEnABX8H8sy+mSr2lCJdkoy2o8tj8fbbV4Qg1c2VmQ0NQ43UpwqoI1MkwVu0/0WsGrGPwH1aq7W4gOj+tWGBkUq5cgpf0xxSWpo1mJkMx8an5/eZyjPJA+MNjlTasAhb5heWAII6wxCYvB+7iEIvp5IGaUyjF4BeX5YdYYnAfAVROzewuTFQ5uimw/illNp4p7uRxWFCENead6UfKiBDXTUFG61SNPXzLeXWYP2sURFNgc5jOrV2w4lASyLyidxUNOAw6PE0/wPi3
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2026 15:10:19.0732
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: abb95cb9-d21e-40bf-4790-08def7baa83d
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU6PEPF0000B621.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAVPR08MB9091

SGkgYWxsLA0KDQp2MSBbMV0gY29tYmluZWQgaXJxY2hpcCBhbmQgS1ZNIGZpeGVzIGlkZW50aWZp
ZWQgYnkgU2FzaGlrbyBbMl0gd2hpbGUNCnJldmlld2luZyB0aGUgR0lDdjUgS1ZNIElSUyBzZXJp
ZXMgWzNdLiBGb2xsb3dpbmcgZmVlZGJhY2ssIHYyIHNwbGl0cw0KdGhlIGZpeGVzIGludG8gc2Vw
YXJhdGUgaXJxY2hpcCBhbmQgS1ZNIHBvc3RpbmdzLiBUaGlzIHBvc3RpbmcNCmNvbnRhaW5zIHRo
ZSBLVk0gZml4ZXM7IHRoZSBpcnFjaGlwIGZpeGVzIGFyZSBwb3N0ZWQgc2VwYXJhdGVseS4NCg0K
Q2hhbmdlcyBzaW5jZSB2MToNCg0KKiBTcGxpdCB0aGUgY29tYmluZWQgc2VyaWVzIGludG8gaXJx
Y2hpcCBhbmQgS1ZNIHBvc3RpbmdzLg0KDQoqIEV4dGVuZCB0aGUgb3V0LW9mLXJhbmdlIEdJQ3Y1
IFBQSSBmaXggdG8gcmVqZWN0IHVuc3VwcG9ydGVkIFBQSXMgYXQNCiAgdGhlIHR5cGUtdmFsaWRh
dGlvbiBib3VuZGFyeSBhcyB3ZWxsIGFzIGluIHRoZSBsb29rdXAgcGF0aC4NCg0KKiBBZGQgYSBm
aXggdG8gdmFsaWRhdGUgYSBHSUN2NSB0aW1lciBQUEkgYmVmb3JlIGNsYWltaW5nIGl0cyBJUlEu
DQoNClRoZSBmaXhlcyBhcmU6DQoNCiogRnJlZSBnaWNfa3ZtX2luZm8gd2hlbiB2R0lDIGluaXRp
YWxpc2F0aW9uIGZhaWxzIGJlY2F1c2UgdGhlDQogIG1haW50ZW5hbmNlIGludGVycnVwdCBpcyBu
b3QgcHJvdmlkZWQgYnV0IGlzIHJlcXVpcmVkLg0KDQoqIEZpeCBzcGVjdWxhdGl2ZSBhY2Nlc3Nl
cyBpbiB0aGUgY29tbW9uIHZHSUMgU1BJIGxvb2t1cCB3aGljaCBjb3VsZA0KICBwcmV2aW91c2x5
IHVuZGVyZmxvdy4gVGhlIFNQSSBpbmRleCBpcyBub3cgbWFkZSByZWxhdGl2ZSB0byB0aGUgU1BJ
DQogIGFycmF5IGJlZm9yZSBhcnJheV9pbmRleF9ub3NwZWMoKSBjb25zdHJhaW5zIGl0IHJhdGhl
ciB0aGFuDQogIGFmdGVyd2FyZHMuDQoNCiogUmVqZWN0IEdJQ3Y1IFBQSXMgb3V0c2lkZSBLVk0n
cyBzdXBwb3J0ZWQgcHJpdmF0ZSBJUlEgcmFuZ2UuIFRoZXNlDQogIHdlcmUgcHJldmlvdXNseSBj
bGFzc2lmaWVkIGFzIFBQSXMgYW5kIGNsYW1wZWQgdG8gemVybywgYWxpYXNpbmcNCiAgcHJpdmF0
ZSBJUlEgMC4NCg0KKiBWYWxpZGF0ZSB0aGUgYXJjaGl0ZWN0dXJhbGx5IGZpeGVkIEdJQ3Y1IHRp
bWVyIFBQSSBiZWZvcmUgY2xhaW1pbmcgaXQNCiAgd2l0aCB0aGUgdkdJQy4NCg0KVGhlc2UgY2hh
bmdlcyBhcmUgYmFzZWQgb24gdjcuMi1yYzcuDQoNClRoYW5rcywNClNhc2NoYQ0KDQpbMV0gaHR0
cHM6Ly9sb3JlLmtlcm5lbC5vcmcvYWxsLzIwMjYwODEwMTAyNjUyLjc1ODcxOS0xLXNhc2NoYS5i
aXNjaG9mZkBhcm0uY29tLw0KWzJdIGh0dHBzOi8vc2FzaGlrby5kZXYvIy9wYXRjaHNldC8yMDI2
MDcyNDEwNDgxOS4xMjk2ODAzLTEtc2FzY2hhLmJpc2Nob2ZmJTQwYXJtLmNvbQ0KWzNdIGh0dHBz
Oi8vbG9yZS5rZXJuZWwub3JnL2FsbC8yMDI2MDcyNDEwNDgxOS4xMjk2ODAzLTEtc2FzY2hhLmJp
c2Nob2ZmQGFybS5jb20vDQoNClNhc2NoYSBCaXNjaG9mZiAoNCk6DQogIEtWTTogYXJtNjQ6IHZn
aWM6IEZyZWUgZ2ljX2t2bV9pbmZvIG9uIGluaXRpYWxpemF0aW9uIGZhaWx1cmUNCiAgS1ZNOiBh
cm02NDogdmdpYzogUHJldmVudCBzcGVjdWxhdGl2ZSBTUEkgYXJyYXkgdW5kZXJmbG93DQogIEtW
TTogYXJtNjQ6IHZnaWM6IFJlamVjdCBvdXQtb2YtcmFuZ2UgR0lDdjUgUFBJIElEcw0KICBLVk06
IGFybTY0OiBWYWxpZGF0ZSBHSUN2NSB0aW1lciBQUElzIGJlZm9yZSBjbGFpbWluZyBvd25lcnNo
aXANCg0KIGFyY2gvYXJtNjQva3ZtL2FyY2hfdGltZXIuYyAgICAgfCA1ICsrKy0tDQogYXJjaC9h
cm02NC9rdm0vdmdpYy92Z2ljLWluaXQuYyB8IDQgKysrLQ0KIGFyY2gvYXJtNjQva3ZtL3ZnaWMv
dmdpYy5jICAgICAgfCA3ICsrKysrLS0NCiBpbmNsdWRlL2t2bS9hcm1fdmdpYy5oICAgICAgICAg
IHwgMiArKw0KIDQgZmlsZXMgY2hhbmdlZCwgMTMgaW5zZXJ0aW9ucygrKSwgNSBkZWxldGlvbnMo
LSkNCg0KLS0gDQoyLjM0LjE=
