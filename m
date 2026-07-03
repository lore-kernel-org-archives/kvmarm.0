Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011047.outbound.protection.outlook.com [52.101.65.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C799220F2A
	for <kvmarm@lists.linux.dev>; Fri,  3 Jul 2026 16:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.47
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783095124; cv=fail; b=MzLJXKIbxM73dCL5dVIzHvdO6VfwqQiocNh3BklWrQtI5mOQN+qYikSXWOFNQiOGpDjOAOrnSO683UwE0jV+s4j+zm3IHipseb957KbbmOYOwUf9Gf0t90OSLHGN5nQFiLCw5xuAl+kHaYg0Dd3H2Oj+NS7aLHgjyrG9sPqJWfk=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783095124; c=relaxed/simple;
	bh=u2bmOAYVgCJ4AVkoewK8uosaWTCrSeiFU7NIiopnmbc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=HuEkF3Br+D0RnGFJ7fc2SIKI5nnZ6hjL4gzRgGEC80l9jYDybydnFTs9lHGCTErbs33XcUj2w5rbtSU1TBIzVUpUDrnLj1Gefv/+/IFwdE8cN6jO58Tim70x/D198lAkaRe/1Oypzk/B7QF2o+yWm2G3jhgI7GZxVaHwo8muGpE=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=LhGpG2lI; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=LhGpG2lI; arc=fail smtp.client-ip=52.101.65.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="LhGpG2lI";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="LhGpG2lI"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=OCh4FrAFdJhHC36VNWaJ63emBD94FT2fiTD0jouU8p+GlRfPEa/GMv3vU76Ge73611V6y+hHnIP5pY+WsvjgfzH0bpnTg5Ikr2AZCICIvXvR8uXYFGZqdN3bGqFPmZVPdHWQhmpBgqeDr3DdGVyFYxa9hnosAZHjQAdsBOZPoZ8GS8jGAPVU9wHKlgSNW5X3sFxYRUP1/SDW0ppirPndhk7YDe/Bf0xPG8Q98X1Cuswsvo2ePuQ/e7NuQqscboxT+NSHgdxKYONZ1Fjftjm7rUMBvAGwCrU3o4IVfuc3Hbw0Jscs9NxUsM+Sa/tvuBH76x04rnn3t2nBOd1DWYFIlw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vAZBvedpnT1n1TJaLvuO0NRyKDu5mX2BQAxWXLbvPms=;
 b=afklbHOgTkufdKBKdCYOWhcRGjZ4x9CcTLy40Tzw5PyeJwQb277HQXZezzN4qEn9/FyUi2JENdOVZsExMTDrE+20qx3iMJdM3Q1LaJPdcyzDj64eQ2C6HmI/PoqaGs9CqBH0xlFk3swqKRQcSNHPNMDY40kGt+irRBbsOiXNvZsTVJ+/O1rmAYlT4/P96oYPT+4+gsG3aZDf8USbkzK8sIyD/eMt//lFZnNhxsko6hVM6p2AwG0pwalQVqgaQtrxy3JNIF3yKzobVjp26hI3lwKWrrKCzrb+5LiCgtNPJNqYLT3cEKhuwjHk+3M6u4C+Bmz5j7KmyyqBa/mWbZ6azA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vAZBvedpnT1n1TJaLvuO0NRyKDu5mX2BQAxWXLbvPms=;
 b=LhGpG2lIb2bYoVaR/d9Frbsh6DbNSgqcgAD/4A6+rcuIeknWwXcx1W1TG0/FczZ5lUWQsipW4Rjpq82TmsIfIaoGXF3gZIqk0lNNJmoZLrHjFGVlo6XROcAWngRQxq2H/qSYT4+paP4eqkoBc0qmX+jMBgNYHcpCgwFJg4pMjZg=
Received: from DUZPR01CA0023.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:46b::17) by AS2PR08MB10350.eurprd08.prod.outlook.com
 (2603:10a6:20b:57a::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.8; Fri, 3 Jul 2026
 16:11:57 +0000
Received: from DB1PEPF00050A01.eurprd03.prod.outlook.com
 (2603:10a6:10:46b:cafe::a7) by DUZPR01CA0023.outlook.office365.com
 (2603:10a6:10:46b::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.11 via Frontend Transport; Fri, 3
 Jul 2026 16:11:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF00050A01.mail.protection.outlook.com (10.167.242.43) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.6
 via Frontend Transport; Fri, 3 Jul 2026 16:11:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XsGi8gTAe3e28nbr7pNzS60TDN811+VAbpmxsI3utAOX4Xxul8HD+8MnQtKgibVx8cpP+XnTSYYxKbhcafxDYsl+tbFM2oASGyGsJ1LJIL5YuEcXJlMhUxCfj221vcKpNU+0FCL7jrQpcX4i0lgdZ3Rf6F2kZ3cfLc978Y+yhS5B+YrIwvTbTpG5toiYilW8Q3cmd6QQ3Pf4GvbdnPp8wk4lbNv+08yz/uIZ+B+HMv2A2KJShiuImsXq4zc86RyOq2x8tSnq/QyAjG3lCs1DMKH825FDU1pPJBucqXINXjF/S6JN7LCsL5mwtEBViFyTvsu0NHrTZU4fPLSIORTIdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vAZBvedpnT1n1TJaLvuO0NRyKDu5mX2BQAxWXLbvPms=;
 b=n2PEY1RhxsgARTjL7U/am9muRSOHS4gI/sXUS9lqrjuf+tZesGFDiSs2pdWI3T3RAkjWIR/dIOwEvdWWwbw5JVlvurXrhkZFTsP8VR+k5xr/tebQ7rWTf2An1rwXxwq6tUUPq4ttEormp007yxWdBFPHYokj7fatgxLhAxzoQYSK8V2qxmGXOQeIYsL3GXCAA8WdlZmmctP3FVJKciHhpD3IVO6PTRbSp1d33LtxDdQRdmQ3XNLbdIdPyFjx9yf+hbSKRMEJTBiWLO1qZ0bCauXmfNUa5qgG4nnQEz6E3SerYjvZFVZuf2r3IGIb5qkXCD6wM95qtqCC45QzvE/rog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vAZBvedpnT1n1TJaLvuO0NRyKDu5mX2BQAxWXLbvPms=;
 b=LhGpG2lIb2bYoVaR/d9Frbsh6DbNSgqcgAD/4A6+rcuIeknWwXcx1W1TG0/FczZ5lUWQsipW4Rjpq82TmsIfIaoGXF3gZIqk0lNNJmoZLrHjFGVlo6XROcAWngRQxq2H/qSYT4+paP4eqkoBc0qmX+jMBgNYHcpCgwFJg4pMjZg=
Received: from DU2PR08MB7310.eurprd08.prod.outlook.com (2603:10a6:10:2e5::5)
 by PAWPR08MB8840.eurprd08.prod.outlook.com (2603:10a6:102:339::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.10; Fri, 3 Jul
 2026 16:10:54 +0000
Received: from DU2PR08MB7310.eurprd08.prod.outlook.com
 ([fe80::e007:b494:8a24:1fc0]) by DU2PR08MB7310.eurprd08.prod.outlook.com
 ([fe80::e007:b494:8a24:1fc0%4]) with mapi id 15.21.0181.009; Fri, 3 Jul 2026
 16:10:54 +0000
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
Subject: [PATCH v3 40/40] Documentation: KVM: Add the VGICv5 IRS save/restore
 sequences
Thread-Topic: [PATCH v3 40/40] Documentation: KVM: Add the VGICv5 IRS
 save/restore sequences
Thread-Index: AQHdCwaGWZyp/UYhi06QbTc/qwOUHA==
Date: Fri, 3 Jul 2026 16:10:54 +0000
Message-ID: <20260703154811.3355680-41-sascha.bischoff@arm.com>
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
	DU2PR08MB7310:EE_|PAWPR08MB8840:EE_|DB1PEPF00050A01:EE_|AS2PR08MB10350:EE_
X-MS-Office365-Filtering-Correlation-Id: 91b88698-9b9e-420c-0803-08ded91dce6c
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|23010399003|376014|366016|1800799024|38070700021|18002099003|22082099003|5023799004|11063799006|56012099006|6133799003;
X-Microsoft-Antispam-Message-Info-Original:
 P5lW1L3Qfqa3Hrvbj30nHkhRMX6YX3Ad6t+N8L3kSqTEucQs9pQzRVgeOV8865BEBCH4rYhztnX0wA/vpLqjJxhUsQm53Hg5OgGOeI3HRtGvMkOR3/qUHrsyLUgnnS5RzBQb/7cEtcZ0srUikHcDo0aCflK+C766phLxSzY2M59Kz/ReP1tiFh5+Vt/TNnkxkFc189AP/mNdA9eRbcL4XeVBf4jOFztR7KEscuGGDzcnGw4fHvYuAyPaAPFTeQfX/JHIsGq9UX5/IzodOYsbjyrMFkDe2RVYS46LIkspdw4D4gjFnKHIUCSlEiNH46m/KTJqbYeZTH6unwyWa4vACdSd8bRY/juyUcbUDl/APGA1s4VzyxyrIy1CatK3ZpW86h9TfUWbaOgTdZT8s/unB3G70FWrksQ7kMaMF9Oj2GFM2yY+JrAFQlgXMMJrQ970v4CTb03H6gUASDzn7tx3v3wlg0BRukZR09jlWuTg+llSw/hOq/HW6wXvLjqjbPHIqPwFUhTEgyntWtFvIvGR8Okfwi9tcrJU+OvP5hi/TZWyoVc64emmSoAGOp+IJIsF8YqwKCfCvFZCAXkYjUdLc+gTyakUjF9e/82Oj/O0ZD6dqaXb58mndlfZTBu6r7zz4O7zEiBhag0QI43eTKSxr7oSoPwfXB7ytDCWek/wFVApxQmXl3Dhej8gJwfQKdcvoUWr40r4pIBQ2jojrJyfrraEZRZsNrOtuY+v7ifXu84=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU2PR08MB7310.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(1800799024)(38070700021)(18002099003)(22082099003)(5023799004)(11063799006)(56012099006)(6133799003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 okk5CyUxjgw8pB90vEGqg8DoYaUWE5bD2myW1+a2Vpk596zZfutWgeM0nX56vdA+VzT2xwOFTwUfyRad9CB6uPnmcTE9StqM5YQLf8wK5ovOxyEY04C4W+urzKGb+BtS+fKNIK+ePIG3tku0DgM6RpktI4CwxyvKiuSzkv7ssO8GlYLMvTvtYPJC4sA9xYZF5vYZZtAg7sOTqCAZ819/EPiekOQSh23Voz7CtT58j8U8/sEF13M+BBochtbD+ajc6neD3/B1P7gsnIxXNHiwZgdRhSwrmqzjesE8UXAr28kewrjA+MBX7x2sgrr+7SSZ5V575hQNcDIbcJHYvC7Jsg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR08MB8840
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF00050A01.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	f1465790-55ef-4f31-8fda-08ded91da8fb
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|14060799003|1800799024|82310400026|23010399003|35042699022|376014|18002099003|22082099003|11063799006|5023799004|56012099006|6133799003;
X-Microsoft-Antispam-Message-Info:
	Fq7ym0MGSK1nltXwdZ6bT+5AjJx7vuIc/iRP67/wRDlApIL9TLp87wFEWmqJ/MY+HG9QRsb0RdjEQFCjrU8kjL4esLSnagXpr6yUVLRhBMzldNVtuVqUfXucaUj1Xo43bZ40ms0dKShU0ZuwnfHEm4Au2z0RPIL0ZmAZ00PhdMAbOLWcmhGh1c0H0Uppg3aimFAf7JR7Hx3ba5IjbFNKAnmgdS4ldkInFs/v7PzJSLXo1vM8W2xVS6No25sWw3hh4VyIfB/8ZzSPUeY/x43lXBB59fT0LtNcm45EgIsRfqUzyVDaBNFzxsNXxV5QibmBruuC1zGMVMF57GT7a6kVweE8gLfH7VvWWxJc0NKLmnIBAUdVKmqFVWsC2B2rcwF0H06Op/ybADX2MQOTBF1fMm5ehXuQUGObn6zTGGQb01J8EpOrPSmz74KP52sxHkeHV1h6PFu2IYi508Q0A/4pik8x3z1RV6cavCHhQ8S1O6jAKs5XWx2MW+mo+6XNXOHnQTR4OpxP9DN5LqkeGt9/n1/iuP1agqwDGG+/C4qe405POrAHq/enh3HLj2Vl81HeEnGGjjZbiirzVgUmH5Ot0UNV2gv9nqJF+BIlBpSHqZqrOl7IxSnjRDJu1DV8ygMRpmhg0ECqSBZZcI4dMcOy2AtNzkI60F8WmhCzLbBtj3dZbAcowtRa5MH4ef5T2oY/lKBXKVvxSmqjlWJMDSS1Yw==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(14060799003)(1800799024)(82310400026)(23010399003)(35042699022)(376014)(18002099003)(22082099003)(11063799006)(5023799004)(56012099006)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	sxESNPJ1Hhmzp6igg2vimblSQFDnwiL5oC5whUSOTWPDIRKvv8l2AesAEEmewYfzEYPGXaW6+p4ZSvI/gtwkAXLPy2UBAw0QetGWvv0fh7EwQUiE6ebajQLEN3EqBfIU095sOzazkaL29dtc0BOjl58l0s3zPAZ9vOiF3JeTyWbQ2FGJMt2epPSrvkyGTnqBt/4qPbTY7xjHDRNwN4OCINW0N8VLiyHonmbUYQdUHUqLc4Ch8AnzbyHnlch4eJp7XlgURxPDidALdaZ3TgLirkzNy2vRLrW8EP1Go+oPngda/VA3b3Hnb2rHKJvYrIdtOaNVGzHSJ4CMpg6PEPTnAFGHYC0ynEcmaAcOrwzQ4JOUcE0gvPpBiuAfeBE33yCcTU5oJDK9FKxM6TwQDFoV7yhX7NQUp4SU752wU3BB8feUToD6Qe8bUKSD94ikWlyc
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2026 16:11:57.2627
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 91b88698-9b9e-420c-0803-08ded91dce6c
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF00050A01.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB10350

When saving/restoring the state of the GICv5 IRS, it is important that
it happens in the correct order. Failure to do so will almost
certainly result in failing to restore a guest that is capable of
handling interrupts correctly.

On a save, the ISTs must be saved prior to saving the guest's memory
as the guest's LPI IST is written to guest memory. Conversely, on
restore the guest's memory must be restored prior to restoring the
ISTs.

It is important to restore the IRS MMIO registers by first restoring
the IRS_IDx registers as they define the capabilities of the IRS, and
are used as part of creating and managing ISTs and SPIs.

In order to restore the ISTs themselves, the IRS_IST_CFGR must be
restored prior to the IRS_IST_BASER. KVM uses these restored registers
when KVM_DEV_ARM_VGIC_GRP_IST is restored to determine whether a guest
LPI IST exists, how large it must be, and where the guest-provided
migration storage lives. The host LPI IST is allocated and populated
as part of restoring KVM_DEV_ARM_VGIC_GRP_IST.

At this stage the remaining MMIO registers can be restored. The SPI
IST gets extracted from a userspace provided buffer, and is
transferred to the host-allocated SPI IST. The LPI IST is extracted
from guest memory, and is written to the host-allocated LPI IST.

As a general rule, the IRS_*_STATUSR registers can be ignored on
restore. They are not userspace writable.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 .../virt/kvm/devices/arm-vgic-v5.rst          | 45 +++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/Documentation/virt/kvm/devices/arm-vgic-v5.rst b/Documentation=
/virt/kvm/devices/arm-vgic-v5.rst
index 0ee0fe9308fc9..188851f22f9eb 100644
--- a/Documentation/virt/kvm/devices/arm-vgic-v5.rst
+++ b/Documentation/virt/kvm/devices/arm-vgic-v5.rst
@@ -232,3 +232,48 @@ Groups:
                    or tracking pending interrupts
       -ETIMEDOUT   An IRS save/VM operation timed out
       =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+IRS Save Sequence:
+------------------
+
+The following operations are required when saving the virtual GICv5 IRS:
+
+a) Save the ISTs by issuing KVM_GET_DEVICE_ATTR on KVM_DEV_ARM_VGIC_GRP_IS=
T.
+b) Save the IRS MMIO register state by issuing KVM_GET_DEVICE_ATTR on
+   KVM_DEV_ARM_VGIC_GRP_IRS_REGS.
+
+These two steps may be performed in either order. However, the guest memor=
y
+must be serialised after the ISTs have been saved, as saving the LPI IST w=
rites
+the IST state back into guest memory.
+
+IRS Restore Sequence:
+---------------------
+
+The following ordering must be followed when restoring the virtual GICv5 a=
nd
+IRS:
+
+a) Create vCPUs.
+b) Provide the IRS base address by issuing KVM_SET_DEVICE_ATTR on
+   KVM_DEV_ARM_VGIC_GRP_ADDR
+c) Restore the number of SPIs by issuing KVM_SET_DEVICE_ATTR on
+   KVM_DEV_ARM_VGIC_GRP_NR_IRQS.
+d) Initialise the GIC - this sets up the default state and creates the SPI
+   IST - by issuing KVM_SET_DEVICE_ATTR on KVM_DEV_ARM_VGIC_GRP_CTRL with
+   KVM_DEV_ARM_VGIC_CTRL_INIT
+e) Restore guest memory.
+f) Restore the IRS MMIO register state by issuing KVM_SET_DEVICE_ATTR on
+   KVM_DEV_ARM_VGIC_GRP_IRS_REGS. KVM uses the restored IRS_IST_CFGR and
+   IRS_IST_BASER state to allocate the LPI IST during the following step.
+g) Restore the ISTs by issuing KVM_SET_DEVICE_ATTR on
+   KVM_DEV_ARM_VGIC_GRP_IST.
+
+The number of SPIs must be restored before VGIC initialization because
+initialization allocates the SPI state and fixes the SPI range exposed by =
the
+IRS ID registers.
+
+The various ``*_STATUSR`` registers are observational state in the current=
 KVM
+implementation. Userspace may save them for validation or debugging purpos=
es,
+but they are not required as restore input and do not need to be replayed =
during
+restore.
+
+Then vCPUs can be started.
--=20
2.34.1
