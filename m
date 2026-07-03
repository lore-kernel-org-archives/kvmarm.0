Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010002.outbound.protection.outlook.com [52.101.69.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0720E25DB0D
	for <kvmarm@lists.linux.dev>; Fri,  3 Jul 2026 16:07:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.2
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783094848; cv=fail; b=CUFTKHreEvHbTb8LTlWBCHW5o45BYpidzrNAHKCqjjSgyxiiKCIC59q+L+RqAB1dBQtb/JxaBsZ+kNReq2+79lNibC1XBteZGm77fQDB+N6W1mSMER3l0iRYU765PrfD01uHZL3k4OI85D9j0sBH1CrVWqVGpLjvPnsnNPRpxHo=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783094848; c=relaxed/simple;
	bh=6/5nUXP9uLmO2YtDlIgM0HIzeI7lXfVcfB1UW5vwEwY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=VDSsHA8EyugB4JHdu6tIz8NcKPhx9bwbWTBcw97qdyGknwNI8WXWYj23p6lMCQ/8HjY5IR4TugUSMf+a/LpUDkToEEW3pX8+3JBLx6fUlQMJ6p5upYZEJTYwyTq6q6t1j19CcuazmZRCyBysiRuj542LDO8AM02F3qCxlLSPSTc=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=QJ8Lqx+5; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=QJ8Lqx+5; arc=fail smtp.client-ip=52.101.69.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="QJ8Lqx+5";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="QJ8Lqx+5"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=JxyHHh94edWI4uYXnaLw7b2EO8m52AljmkZKraAJRZkIU63MHPVamunKSDje7BKPY8sD4q+o9ihF93J0M2GagHgAB7kugcr4y631nOZcZ1ZW21Ep44rrsevzdcQatPyl3a6kxa2lDwrn0i5+waOn5J+D6817jSkONpVNq6r94OiZOaOpLVXcldBYU3lI+bW2klWEoYpNIFGI34utH9e4KcLQdPXkL6QnX2RkPU+/H9OxI6ML9p30nbkjGEvnKIntRuiiVHO1FX4sV71aTVK0GvNniUMFKMbzR9knssf9FIme2G1qbhPIBx5YK6dzwZzUgsayCVSLqjFqqLiNFccULA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MGbmyqWEiFsj3WkvYqPzLlZ3+nVuRYR5n4mkvS+GTbE=;
 b=tq5T4AZouRlEjAK658YMna9ixfUT3hPXK88e+ikaM1THYdQXsBFUaDgcxnA9qR9lPf/2kZUPAIhI6o8cqRQ8I/e5UzsdLhk90NBUs1Xm+/fS2qHnCjAKLjYCfsE5oHJ1syE60AW2ZXfHdsd9J/wsGoCIAJD09vza56X7X/SDSK+fY4XGD+cjnVjKFNRZYV9mdCtRK8f93D5E//7TmjsGRNFStWfKKjRao6ofJfcL/RDX6qxn7AD1z3eIp7WZBYOAegc4Bwx+0a+KaVozvDICkXlwp90mDc6wBdex4nQLtjFsgAVqCqiBFZFDbwGHgoegcxxpVTMf+BCYX7zWqoiBjg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MGbmyqWEiFsj3WkvYqPzLlZ3+nVuRYR5n4mkvS+GTbE=;
 b=QJ8Lqx+5RhAM+LjJ2OJzwjzUywZf8IRQqOPzmlzehUywsQkaISpoHly4qQXIryHL3h+jzQMquKYI8olhO+qotfNdl0oHowKINuc10nn50eXoE7nsjzLk9OL9+OZzJwDVSpeYw8Y+ZvGIq2byS3QDH3lLai6LCrd8TH9IDCz5UB4=
Received: from AS8PR05CA0019.eurprd05.prod.outlook.com (2603:10a6:20b:311::24)
 by AM8PR08MB5617.eurprd08.prod.outlook.com (2603:10a6:20b:1dc::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.11; Fri, 3 Jul
 2026 16:07:23 +0000
Received: from AMS0EPF00000191.eurprd05.prod.outlook.com
 (2603:10a6:20b:311:cafe::80) by AS8PR05CA0019.outlook.office365.com
 (2603:10a6:20b:311::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.11 via Frontend Transport; Fri, 3
 Jul 2026 16:07:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF00000191.mail.protection.outlook.com (10.167.16.216) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.6
 via Frontend Transport; Fri, 3 Jul 2026 16:07:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=v/naaLKiI4Z/kJR8vJZsDGTv1r2hX9M0KIXI2pfOC3yA5Nfg9ct0qJunO4dHFrJhC27Kar6xgqqRefVjT8ciqOZkHRYPb0E46EkPBHW96rdGluElaCRDR4VnLKnDPx1TcVxUm1hYBfgXwXMfdLxukjmwsjuQZXQITAVupMKrJuUH6lpsMCoEqZFHnZGIiT8tDluxY10+3qQdBawB1nMKdBRFmxXBLlMZC3nGofKrVB29mFbWBA+uGqB+djijf842KiEh/DV9SHQES7HCVBRgvERjnsUa5GMWgCKHJgTt/NGjFKKrUdqpm24zV58iSy5Vm5bZsXvfOvPQUVLs+Xmd1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MGbmyqWEiFsj3WkvYqPzLlZ3+nVuRYR5n4mkvS+GTbE=;
 b=qUqOBDdLmMA/1ffIQFjRlS7PNUe98RUgTaB14/6nmykCEHtC5wlaQFOukb8Gl2VGWmaFVGY0+YvoXWwCtwsy9PbueCJGUI72XQrFq5sGN1v263wSyfrOpqUV5VEO/r4og7T3+CclUMdZfD9BqjIxpkO/49laWZglLopa7Onli0HjpX2NGlXwrMV7ipq+KXSGLZzUqrIvvOWTmw/+oJHBmuDXEYEBKRmqCgBLDiXwRlBGjL7q9qUaoneJiXnmjUWDORShhU6nij8BhS2Sw8Pk1BxAcC0swMaiLungjxUwlrNgE53FGjMtpLeRyahYFBVQnJUaUeMWGleRuQDMbzua3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MGbmyqWEiFsj3WkvYqPzLlZ3+nVuRYR5n4mkvS+GTbE=;
 b=QJ8Lqx+5RhAM+LjJ2OJzwjzUywZf8IRQqOPzmlzehUywsQkaISpoHly4qQXIryHL3h+jzQMquKYI8olhO+qotfNdl0oHowKINuc10nn50eXoE7nsjzLk9OL9+OZzJwDVSpeYw8Y+ZvGIq2byS3QDH3lLai6LCrd8TH9IDCz5UB4=
Received: from DU2PR08MB7310.eurprd08.prod.outlook.com (2603:10a6:10:2e5::5)
 by AM0PR08MB5459.eurprd08.prod.outlook.com (2603:10a6:208:186::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.11; Fri, 3 Jul
 2026 16:06:19 +0000
Received: from DU2PR08MB7310.eurprd08.prod.outlook.com
 ([fe80::e007:b494:8a24:1fc0]) by DU2PR08MB7310.eurprd08.prod.outlook.com
 ([fe80::e007:b494:8a24:1fc0%4]) with mapi id 15.21.0181.009; Fri, 3 Jul 2026
 16:06:19 +0000
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
Subject: [PATCH v3 31/40] KVM: arm64: gic-v5: Add GICv5 SPI injection to irqfd
Thread-Topic: [PATCH v3 31/40] KVM: arm64: gic-v5: Add GICv5 SPI injection to
 irqfd
Thread-Index: AQHdCwXilgWQ+uY8G0KjXbBPtg8WHg==
Date: Fri, 3 Jul 2026 16:06:19 +0000
Message-ID: <20260703154811.3355680-32-sascha.bischoff@arm.com>
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
	DU2PR08MB7310:EE_|AM0PR08MB5459:EE_|AMS0EPF00000191:EE_|AM8PR08MB5617:EE_
X-MS-Office365-Filtering-Correlation-Id: f51cdbd2-2e48-45e2-f481-08ded91d2a36
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|18002099003|22082099003|56012099006|11063799006|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 INLv6ylqLnbvEYneJUFqz1T4gICWUUC8gCN8y5qxDXuN2E4/IdYRMqfLAj9I2VyhzvYM8Eb3MrLmEwQlcIVf7ArW3SNPYmeQ96iDzfTrtVu7VZcub9cxjMiiSIY1AQUYNn42vMNVvpl7q1YJtvD+epyUxHpo/7xrPKHsHbBtAmX1Lm156qpbyE1hFEDdfqzaVqElMdcQN/58X6T/oyuGjAG8T6hu7igkFoZPMb00ofVidDu37Jf5Wj32GQaBy613JKRhkC0txdBW8sZzv39J8WJtknOrxCkWSxID+FtAxTf9OMZQPtXyjysUrU73p/iOsx3ltwyO33J669T9trmoYcm359NgRwrCv090bEBuJcYr0oomaQYkPL+f0Grm73Hb+DoVd32q2bR/EFzDa3onvryCaPTVQqIkW2yAsyv+Cm5TH+3xXsSyq+rlqbnwD2niine4G//VgmjH4p2aMJKI132XgB4I7xi3OBCe1WVbSMxLouJ6XqrLrLeg5SesksCMJCmzjBPzQDi+wSaP/J2PFSBDikKHg64tlHsqPFU6EqnB8J96bLFBN8YF+Lry6uDSPnHAVtijrfjiBiZY2/+JoUnJp0RfxEVw/wGXhe8EBtI//Wsntf3wblSGQLALKSyDxTl8YxLg8SWBNpw/ARucI62x/+kD5kpNAbrjPyues48j6l5dRLpiu6EomXyYQDYUiPWgHhoop3j4/XhyCkFa2opykTpclRcK5ePJRolM9bA=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU2PR08MB7310.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(18002099003)(22082099003)(56012099006)(11063799006)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 BXv3qd4mDeP+lncc4W3dwX6v2CXV0bIhqwIOIOV/3i2/a0BTTf7ivMLIMKRB8Zm6dDIBlU0SmtX1/2n2WX9DhQnwmjMEMZ5p7kTJ/AW51Fov0Z/nk9x0xv4+uq3nXhnE3GAjwIyvQn/jMHMhoWevfcPqW39Y3YucStcpQrFp+tbhRYN+zE7nJrpmMJ1HilhlAi5R1GXY6C+C+gGZrs86CbV3xwIi66hDqHl+pMMwp9XH+WwQxa9F3PvdHsR2qTvsj6/4ETFTmFznDorMYgCNpBx3xkheGZNobaxm+7gMXJqX5hkg062Qj/woOXU2OV8gzcaxjhnNmm4DEW2kbVWg6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR08MB5459
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF00000191.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	0af5a9ce-4698-4f0e-52a1-08ded91d04df
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|376014|35042699022|36860700016|23010399003|1800799024|82310400026|11063799006|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	b6Wvg81CcI2F6alIx4cqjVw9y4lAco8vd9OJ3/b0TWnaE6bDhWB/UlA+ilIohxekgsbUg8AyqzONe8DZaE1v+xv0AbDW87uU/1Gh3Nmztw+Uzz7447ggQFdf/lanYLKYyE51UMgLaXJ+c690nS0iV7/K0R8xis7Mqj44/h51ENdoZra+shcUjrcEselcuSqNVSCa9BBWUSv3wbHVE4545PJNH5yE6MgHqTlf0tI6rawcpqsaYB0YnYnlOIvK4BtrxdIr7UQlDWOwBFqPuothJ9hk8aVhAeAanuto4K3zEo88TQh6ubxdCTlo5UoRNfi3lfi3FLPoArHuUoKuZt1dPQB4LOWCqRB0tWgsXYu5ikryM9E0q5ctiy7H6WyoycjCF3+Sk1/fPvX0UK1Sa6EZXr/eFtU5NHIIJfSaJNFbTvNkcI+HCWZ5kMLpNoWCSHFIaR4XUFXHb0F3yJrMupiDat52auaHTmjRIOEYBYWug0Ta66FGgms/b1iV6p1kIt3Vzaa4Jd0h9r2TZJ6k5cPexi0Yj+QjnH7GxjIqJW7YMwg8P5FjZsK563Kf7WsOzU6pGn8JlTyoRJv2x/vfv7+OH/aw7S/Sq7qUdtK1dD4LLCgGFCxnBLC5ndSq9OY03/qRYCtrwA7Ezi3etE5GfFSa2XirVskNWPgLBM6Q/D4Ucnr0zlJXPjCYgnmCTbMGU0jHFZ/DkSP6poAVeo+6t+CB4Q==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(376014)(35042699022)(36860700016)(23010399003)(1800799024)(82310400026)(11063799006)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	69PzevIVhr46qusxeAwfqg8fBnondajrOXLsPY8izyQWVgjabdTr+YvzOfS6CqrXqtmNbLe15A/qfl8QOIpepUg+8kO7+g5zvl0SNe0IYXmBfVAhc5w7p8Z3VuVIFVFvd9YsZYJmxivPBJXvaxEz2uHqlnhu1TgkghBCGwaGYBD4ChD+TvT93Eydk8cQmPMjEUn0NoOBpfoVviS7L36we+jQ6OXuItwy31urnDtMoK/ImKi0KYifJY9WCgppsGKHWmDouWYiO9i9Exm48WXE8pKzhEx25/nD4kqpluGOw35qapM6U8qUdftwG1WLHmZTm/+QQh64nQEryAfzOyzs8HdgdoUou8m2laURfwjykLR2o912nRFNcqCAbedFNhNMjJEc6pDT62O9LJgOZuOWveh+PqiqPIJVHOx6TF//qcupHTQ4cwtMW6edQ4IpFku5
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2026 16:07:21.7751
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f51cdbd2-2e48-45e2-f481-08ded91d2a36
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF00000191.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR08MB5617

Now that there is support for GICv5 SPIs in KVM, update
vgic_irqfd_set_irq() to translate irqchip pins into GICv5 SPI IntIDs
before injecting them.

Also adjust IRQCHIP route validation for GICv5: use the configured SPI
count, fall back to the default SPI count before VGIC init, and cap
the accepted pin range to the generic irq routing table size.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-irqfd.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-irqfd.c b/arch/arm64/kvm/vgic/vgic-ir=
qfd.c
index 19a1094536e6a..61fdc70fd1657 100644
--- a/arch/arm64/kvm/vgic/vgic-irqfd.c
+++ b/arch/arm64/kvm/vgic/vgic-irqfd.c
@@ -19,9 +19,14 @@ static int vgic_irqfd_set_irq(struct kvm_kernel_irq_rout=
ing_entry *e,
 			struct kvm *kvm, int irq_source_id,
 			int level, bool line_status)
 {
-	unsigned int spi_id =3D e->irqchip.pin + VGIC_NR_PRIVATE_IRQS;
+	unsigned int spi_id;
 	int ret;
=20
+	if (kvm->arch.vgic.vgic_model =3D=3D KVM_DEV_TYPE_ARM_VGIC_V5)
+		spi_id =3D vgic_v5_make_spi(e->irqchip.pin);
+	else
+		spi_id =3D e->irqchip.pin + VGIC_NR_PRIVATE_IRQS;
+
 	if (!vgic_valid_spi(kvm, spi_id))
 		return -EINVAL;
=20
@@ -45,15 +50,21 @@ int kvm_set_routing_entry(struct kvm *kvm,
 			  struct kvm_kernel_irq_routing_entry *e,
 			  const struct kvm_irq_routing_entry *ue)
 {
+	unsigned int nr_pins;
 	int r =3D -EINVAL;
=20
+	if (vgic_is_v5(kvm))
+		nr_pins =3D kvm->arch.vgic.nr_spis;
+	else
+		nr_pins =3D KVM_IRQCHIP_NUM_PINS;
+
 	switch (ue->type) {
 	case KVM_IRQ_ROUTING_IRQCHIP:
 		e->set =3D vgic_irqfd_set_irq;
 		e->irqchip.irqchip =3D ue->u.irqchip.irqchip;
 		e->irqchip.pin =3D ue->u.irqchip.pin;
-		if ((e->irqchip.pin >=3D KVM_IRQCHIP_NUM_PINS) ||
-		    (e->irqchip.irqchip >=3D KVM_NR_IRQCHIPS))
+		if (e->irqchip.pin >=3D nr_pins ||
+		    e->irqchip.irqchip >=3D KVM_NR_IRQCHIPS)
 			goto out;
 		break;
 	case KVM_IRQ_ROUTING_MSI:
--=20
2.34.1
