Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010042.outbound.protection.outlook.com [52.101.84.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F0EF471D00
	for <kvmarm@lists.linux.dev>; Fri,  7 Aug 2026 11:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.42
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786102338; cv=fail; b=lM8YcWnnLog2HP8aQrg8XDhx06I7ayUuRYGyCL6KPZHMX7c5MgOqID10oDTtuzwBRo0YLKS2mPUYo6XYKloW4VrOBpASXtcWPxaIQIeC3yAr/j4c4n7IEi/Y0Ilt3FD+WxEidNA8cFLxfmW6A8k1VYAFJv5oogrVWl5ASQI5x84=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786102338; c=relaxed/simple;
	bh=58DPkrX/aBeJQo0Z0vIkTpDpfDRxnrOftJcCa3v0TR8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Q1eE8pvNiNVB0BscAd6AC+5lJX5PEaTse3SGvpeaLf28Oa2Jc18WSNxXg1rAZQzhO1EM057AmHqVdSdwthV/XNLk09p6ZV+G26JVmQdusyw+40SeKjLBKSqDZDzyqJLgTnjI4alx2IynuylaIBC4txXMfG0fBvhF0A6XG4hmD60=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=DPHK34Ye; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=DPHK34Ye; arc=fail smtp.client-ip=52.101.84.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="DPHK34Ye";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="DPHK34Ye"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=XFJ9nE+mKPwD8gKF1sgXYeo9pmPYGbr3GvN/8/7sRj2V+yi3XqTRi0lCeOzGYSHXRmceGWyEoyMtznJdL075wRpIMJTEfdsAW/B02A3wPjKTsCTYyJ29MWxPZdgCOl3BS2nd9QH8m/XNc6nMM9B7klOBbFkOTx62pJDppJs3Mpf9DcP5U7M+l9Dr9K/kIVGxd4lsu3bVcoCs3y0YUE4Ap675ZuaNUsMqCsfyiDXpXg/SS+xHzbNUrLt7Fzd5RfTTQ7iwRAsHksMIlLiR2HooI1JJkEbq2XoEYsGJZumGzxAa2ZADXp1eD8WThiRJw7vLOmwIXL621Y13csv3/mhFcg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+KtPeFO4rcJNO6C0OZ01bp7rgtk/iEqfYOK101KrqnI=;
 b=QlwmXTIQWwqjs6BdYYQJUrP8jOhAt+GpOSB9QXfr337sikiUSQujr1ykeJNZdVJtnQHdSpGw/0csRa8A3uVFNhe3fLtRY+kI/05qK7K/kvytq83GrWkZt+8Ud9MFe6Xnriomwu4LLZwj7ptSy9b/xE6l5qqoy3L/U2D8RFOTICTgs4h1nvWVGq8WWk7jHUcjdTu7BAowArMuXJuHaEjnk3sfwvSBC2AwG3XoaeAzsAlAkvMnfJI/vK94HK0hY/gAfEEJT1CA1l8pQFtHaIh01EZAgxuXnNOcy83DPYlFLh1yW0dMDLgVh92itJ1BGHJQ8JBUzd5h1/flAeCx/WgYTQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+KtPeFO4rcJNO6C0OZ01bp7rgtk/iEqfYOK101KrqnI=;
 b=DPHK34Ye3CsZA3ENBhnIUm/roQ5NVGgi5SeTHAV3nSKno/n2O+FWZnUUmG+JWwbdQ8Nuh86hYCeFddzVMbwvsaPB4CHpcl/Z/KUBKCH7foCkMMLzt21zAWzNoFhoNillXFOf1/MZ7FHBBqh0yV8chYLb3+Z4+I1SI8oF5Ddi3rI=
Received: from AS8PR07CA0059.eurprd07.prod.outlook.com (2603:10a6:20b:459::28)
 by DBAPR08MB5829.eurprd08.prod.outlook.com (2603:10a6:10:1a9::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.23; Fri, 7 Aug
 2026 11:32:10 +0000
Received: from AMS1EPF00000093.eurprd05.prod.outlook.com
 (2603:10a6:20b:459:cafe::a2) by AS8PR07CA0059.outlook.office365.com
 (2603:10a6:20b:459::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.315.9 via Frontend Transport; Fri, 7
 Aug 2026 11:32:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS1EPF00000093.mail.protection.outlook.com (10.167.242.90) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.315.6
 via Frontend Transport; Fri, 7 Aug 2026 11:32:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=k0NhvYDK0F0uB+rasdjjvUzljcOrMEkTAQ4KAncYguG/4S/2tZ9g2N1oxkvIZV+VjQ1diOrKUgRJi18pf75UDAUKUmj6g2aQkGGlhcaHcb4ZrKpmwzwlqn1Dz62eCx1LfHz8kojUSqCPylaCI48kcfmEGfXVMAy6sWrp6MY6UT6wVVCpkxxkFwgbkuN/Z7ODFzP52z7osJtAV546uRFp4L+TNfYOL3ywCAITewqBk8N9WaggnqmPubU2tO5n2l/L1YDbnyqu0MqrVbsLR9S5MkSA7z4ay0zWr/tPg4d6qAVk2euUig5NyrGGKJohLUYIqzLyY/HCWDmDcvlfg5mtTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+KtPeFO4rcJNO6C0OZ01bp7rgtk/iEqfYOK101KrqnI=;
 b=HTIyx44gfrS5apc7jTdSnw4UZ7fR+RAPCd2k8Qvjh9xhfKcZmhXPmRwwDoYubbERwzTqD8MgI2vaZi190gfA9WWnr7AJMI4rtLbG2M9ADbshXvKA8yyYJJIX9RQBHnHT/HQagTlce7Q3v4mX3Bb1ulGBkdx2GaDTff65JoAN9hDBD2j1V/K/7lQJw0/l5HJkmyUpq1fTvsoY62Y4ALiFvP1hDEWwe+QkYgWO23mhsqZLnheSilrA5wbHTHci5XP0BExk+rg3PPmesXnVLEIB9I6JVA+7rH0DuggcAcyIALwuv51JLjZPdeQmDmh2xU3MxmlLoOMzC1jViw8sc3+CaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+KtPeFO4rcJNO6C0OZ01bp7rgtk/iEqfYOK101KrqnI=;
 b=DPHK34Ye3CsZA3ENBhnIUm/roQ5NVGgi5SeTHAV3nSKno/n2O+FWZnUUmG+JWwbdQ8Nuh86hYCeFddzVMbwvsaPB4CHpcl/Z/KUBKCH7foCkMMLzt21zAWzNoFhoNillXFOf1/MZ7FHBBqh0yV8chYLb3+Z4+I1SI8oF5Ddi3rI=
Received: from GV1PR08MB8428.eurprd08.prod.outlook.com (2603:10a6:150:81::5)
 by AS8PR08MB7308.eurprd08.prod.outlook.com (2603:10a6:20b:443::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.21; Fri, 7 Aug
 2026 11:31:33 +0000
Received: from GV1PR08MB8428.eurprd08.prod.outlook.com
 ([fe80::9b97:c973:3308:5ba7]) by GV1PR08MB8428.eurprd08.prod.outlook.com
 ([fe80::9b97:c973:3308:5ba7%5]) with mapi id 15.21.0292.018; Fri, 7 Aug 2026
 11:31:27 +0000
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
Subject: [PATCH v5 37/49] Documentation: KVM: Add
 KVM_DEV_ARM_VGIC_GRP_IRS_REGS to VGICv5 docs
Thread-Topic: [PATCH v5 37/49] Documentation: KVM: Add
 KVM_DEV_ARM_VGIC_GRP_IRS_REGS to VGICv5 docs
Thread-Index: AQHdJmBI31WfVMcIMUGOQ4jbbcYugw==
Date: Fri, 7 Aug 2026 11:31:26 +0000
Message-ID: <20260807111159.429128-38-sascha.bischoff@arm.com>
References: <20260807111159.429128-1-sascha.bischoff@arm.com>
In-Reply-To: <20260807111159.429128-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	GV1PR08MB8428:EE_|AS8PR08MB7308:EE_|AMS1EPF00000093:EE_|DBAPR08MB5829:EE_
X-MS-Office365-Filtering-Correlation-Id: 5bdcfcb4-0457-4dd4-c000-08def47784b4
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|23010399003|376014|366016|1800799024|38070700021|6133799003|10067099003|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 H12Jv6x/fDk7hIsAfWzn2dnyqb49HyG7atRst/Mp6n5X0qpwhGvqe3BUqXvuNEXOdpfbFI0ApnHO/sk3aSV/w9eff7VlqHH8na2in1VYmbMxwBEEKAwMe/J/eby3f0W+83AVeOXCXyAeQdE3P4h4NRMlct0ocvhp778ovRu3xzBuFU7wC04yQzVNVp8H7ecVNy0Bgbd8L9qgNYMPMh9NeWzoG+omBgLtc1IlW7AFmFpvscCkqCoNGAAx+WjLb6B1JgNMGFzTGaIocITbfleqkhm3szlfMdoxLZDJKDHsSb6d1UFwvIVzw6tpxylhnO8m9dc1v3vJwBjrxNK2FybySVVM1DDsTWvxcIdM6GQRccl0YcyhckSxrIwlJW7x+B67fxf8jEo0rd8ec9Fpmm+VZoBtbR6JNvWr8JkuxUVd+72767mgU59/qO3EWDk0MajTfkN0hDkR2ofy8wARamztRCYNgBgrPiefiS6MbTJZAkVBQYkIJRULkcZpw68UnvYA9JDb0EL5kY4ggRpOKJPePRcPHuLC1Hx4bjiJqu1Nc3DIoYDKe06TGIPoMj1TRAdL2WoFaLiiD1TW/4xReHG+TnAVS+CDRqkQaIw1fNjMyavIJx2H7Xh4suLgWVYOcX3HSHMTyRdDvkSHo5isZ8z43dg+TMM/ptAtaCluHyWS0z3FYu6dSa8XM+WSviD/hDPYspqgvM4QRS1XXG3RcEVZ0fZddw7vH4rO/vgOPdH64jQ=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB8428.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(1800799024)(38070700021)(6133799003)(10067099003)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 QyebrCAGpEmKPW+dvFQsuRA2YV9DugkqiKz7Uc05NTDFgUx5LDxuIrsfcx/PEgSAB77IaKFP/w1Yj+vuMam9C+AImkqkhY3nOZW7DEgUV/K4ah03+OA53O8+BLf0BSVYt6bCwQcQRDz/o7EZrs5PPPe5AbAvxijdYGT5Ed38IoxHsrV+Iyjf2Rcx3RkB33C4C74bX8oRg9SnhlDNu+XxnMekxxl8vgP5OnUB6A5CGwoTar+Zvq1FG8zebDVDzMhChQzY4o0xtbBBzJvfw8WgE5xFGyHAaPNNqRgNcpsaZ4BumZ9J9Tsu224z7AiJMvSlAJpZP4P40WgTBv39MnTbgA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB7308
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS1EPF00000093.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	7fec2a9b-0920-43c3-5fe7-08def4776b38
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|14060799003|82310400026|35042699022|1800799024|36860700016|376014|18002099003|22082099003|10067099003|6133799003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	anK4/iWUNjuFyLGc/x3Yc81g3cJ7jjaqWCwlElXDv8nFu7fQQBamNJeUZXuTKS3ktA0n19s2tvUYuB7Oy18XFMHetgv7Ak0vQjpyPDYH5mPSLXNw/lUPUZIsdu0NWe95Y7K2sEYECXKuQooLPL+pl1CXat7kpvclgUSmP86sZ3Q0MNQdM1YmGxHbmt90zL5LII8kifHpwbvthTQfgOLEEqn0fbbYbP9XPwcCrknJuix8axVcJj5Cl9iRa7rDiEk5xT7mT9PoVwPOob+1lDUSk7o4iceNQY6B8RJbg+D/6KETOE2Wvm6unVVTwk1BcF0uPvBCx3yB/qhSVXAuPG7F/c6iaw1XLZpX7UZbF0T7LmHDGjYLyFR+57/KO/OhIMgBPt0kIRt4xv18fu6/bZ0Je9jZLz+TlK5o/Q49+k4KJzxsPAWEXMfa64ppIbw/3tdAL6sFVhO6QZWU5Bp3gehsEoMXD3txjtsQHDSNFWJtgkmgLVdf2u3AMIzBZE6woNDR0tND1V/YLdDyWVDpXtyX61uGAc2O1E02xTO2HmtNdirf+LjCoVYAN9ulfuM8Q7BijWOOG6j5IwlpkB7cV+B1Sg4ypTQUzHI3V834PXWUiGGAzznHZ9vwrBiuBZ4NW0ZcDGQIu+V09HdXPW8pgGUDEONOkWr02TWSGhI+d5z6VNt5XRylZPJVC0ockHabzyrOOY2HJbZK6AP+lXpe5oeruA==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(14060799003)(82310400026)(35042699022)(1800799024)(36860700016)(376014)(18002099003)(22082099003)(10067099003)(6133799003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	cPuImO6bh/S10Lt9NmNfc09Uq1WlqxJCT9wkEf9haGSOIVo/bFthsVxW/QAIh6UN36lq8SXTgh/KfcGc1Dlbg6DdooAXmqMG+QWY3Ia3QT18VvSjRR3PM9piulIvy6JsKblHfWz3evnZzx0cQQifStoOgSy42OCUfDXgBwrSOH+BZjy23A/KW27FOdfRkMTXzF3NLdxtWVZg+Dizgpx6NEmImk0Ricty2T73oXJL09bx/hd8siGGVAlsrkwk2UpkXYOaMjHld1heHCBETmdBWCirzYuV8sYewHbWsCyqIpPzM7ZsvuuGzkAzXCXOtaviF6FPVLSvuzOKnB+uC5M95mvQlNt2jdwiw9tObEK2zX6JxqPJfPSfuCg2/NNeQaf2HYO/YGeTk5MlEY8HtGK4XPMBAR7AHmaB3cLjl9vYndnUmBvg3T1MJqAMspLndxP+
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2026 11:32:09.6983
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5bdcfcb4-0457-4dd4-c000-08def47784b4
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS1EPF00000093.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR08MB5829

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
index 7e41d6699538f..6dd3ff555ba02 100644
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
+KVM_DEV_ARM_VGIC_GRP_IRS_REGS
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
