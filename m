Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012044.outbound.protection.outlook.com [52.101.66.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1A9744E67F
	for <kvmarm@lists.linux.dev>; Fri,  7 Aug 2026 11:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.44
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786102542; cv=fail; b=P2TphEUTGv/f8swRqYYKPstRVFzjfxvMyhWThf0xCpAtw7CdZUW/2uNeaVmgbLjJM8QmA0SxeXCsX7jKV60S3bMj37r/WY/vasDhI6nflkhHehbc1cEiMSJ7o5K1CHSUjs12BEhFkoSrBVxK50399G1plXzIDr6tzIs3mW1mKZo=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786102542; c=relaxed/simple;
	bh=c1y29wnNOr06Dm43PaJOdfC8njXlkuqwus0BCqokyGo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Bpd3jgI/sv5TBTi1escUqkhB1A32lMtLQcAJmYqzywx18yvcePDUVm4AcOKFoRA+GpeAB/eTc9Fmfe3r9dOlfwvhtzRFJcr1ZfkW9lppcj5QCe1YGN2tZoXnbG9X6Pp/VIsZSH2ihrZj5jGm9Qtk3Pu3dajW2LPB1WQuABMYUsg=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=GjRSj7hs; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=GjRSj7hs; arc=fail smtp.client-ip=52.101.66.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="GjRSj7hs";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="GjRSj7hs"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=KqA7mNpwX9o7hoPzUlmsWd9hNpQ9mSIrfAwqcZt7kj+8HfS7prXiCi5jtcjw2uKPmo+7xS9pQLBjUSAcfkFwihOZJfCn1YTj7ouu2lNzRoXoOABoYgymSTKNrXYjUIL52SvGF+gJuRiJw03Y6PgrZnHjAiOrO7wy9KUfPSWG95+yuipVq4qJBuwgYMMzLLdxCS4SiGqA50YTsg9DceMALbh7m2SbBlTmrK+ChrpJUv434wlxPCMQnBl1obAmZU+9wPKJPgtQglORivdq9WHu+a3ZSrf+detx3/YchuyW9aoW+tj0Jf9g6v8P5hykPJKQbyWUWS+3Jx3+E9NNYZUSZQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F+wOweEq80PYavMJr+ZXq38YtXsVkxtzfFndQ/UC65A=;
 b=lyhB/SGLCJHZr1fA0sgxFlRpF2dTGrKSj6IfTbaS2BT1pLmt7lTr8DYKCCpqCXdp2EYsYkYW0Xcf//3etE7wZ00GnNXUr0roCeEayG12RVXpr0YO9Mxllh0MBhXjmYp5G5Sgiqa3aYh/tQB1yCsJmVvzZc2qAuDBkJvrPO1sls9vwX7gEXHLKxQgP+Z0ncJTYNwlSs2HIbrQSvtHRngVYHcL0BePDXDdL7I07/hPwDWFmlVLG2bLsLvwO6IA7isRmiQVP2fG3M5YHAWg7RNIT0Qahy0lbgEs/ffJ2eQM3WGfZHis793Cc8UOc9RoHWg3Tk5eu8NFukAMtFofIKB3Sw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F+wOweEq80PYavMJr+ZXq38YtXsVkxtzfFndQ/UC65A=;
 b=GjRSj7hsUs+G2cA80s+wojEBRXZcRS/9BtQxnSnrONEwKwyBEivaPloWF2TT6FxZftvV3zm/x2pa8Lv1URMmnTl9tj7RM31bzBzel19YdWcKe4vb0ESRdcZESWMqxAXLK9l+RgUHSGJlgc0SyAOJ+hz92YFGU++jq/11WDslgWI=
Received: from AS9PR05CA0172.eurprd05.prod.outlook.com (2603:10a6:20b:496::33)
 by VI1PR08MB10273.eurprd08.prod.outlook.com (2603:10a6:800:1be::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.15; Fri, 7 Aug
 2026 11:35:34 +0000
Received: from AM2PEPF0001C716.eurprd05.prod.outlook.com
 (2603:10a6:20b:496:cafe::9a) by AS9PR05CA0172.outlook.office365.com
 (2603:10a6:20b:496::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.21 via Frontend Transport; Fri, 7
 Aug 2026 11:35:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM2PEPF0001C716.mail.protection.outlook.com (10.167.16.186) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.315.6
 via Frontend Transport; Fri, 7 Aug 2026 11:35:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=um4oUSuRu8OPDwP5ycQqetX84JAv70ghR7souUnSzd3qZDZeQ90tzV9W97k+4V4DdPxPY5PiwX/jCKeDFKVL2Y0ndLj++YZ+RQMRbQwdAAfLYbAk/u+7KcZI1e3Th3LvBZ3eXy5KJUzfWLHQOO+/I1zgsKxM4wZOX4zjdeMsVghS3mZlUL8EDPWquJ7uTzKIgvmVSAUAAPAy6UgB0mGELGaTrr+ixf+E3YKPZ5bYsLgfrbPkHuZrC8NfPaR9YbJcsT36WXLTrUn02Iz/QCyWyGzghReJi/2XNHZ1ALmMxTKyNP8HQJtaB7UhMKQgtFiBRNx6d9nqm1DMxKyfjlQz5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F+wOweEq80PYavMJr+ZXq38YtXsVkxtzfFndQ/UC65A=;
 b=jSRL0C0z5a+jur1PGUcwl8XhxWwsIE+S1i9jx7SnSqAxMYxDzM1uQMZQubDyBuoy3L0qek0MAmGCbRqINxeJNqutunrafPs4dJ6UZeDVQhO842HTpDlfgIGkZaeUB1XjAaMEBZoZU2/6EZmPmRX7JFeIjvzJAorjWypTyUA1Z6yXfS9cqBk3umPdUR+vMXanNRWXx74SlxW3eMDt18yzyn2ySh7vYS0jbFfss40iejtZgCRPU4bOMHB+YW5iR+TsJEZBH6D936ZE7DLK0xwzVWydIcTtwiTraQWyEm+o37WZqiejMJsKdRBc0yMQt+Lk9I4OqG41vB48/CFxuK0AMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F+wOweEq80PYavMJr+ZXq38YtXsVkxtzfFndQ/UC65A=;
 b=GjRSj7hsUs+G2cA80s+wojEBRXZcRS/9BtQxnSnrONEwKwyBEivaPloWF2TT6FxZftvV3zm/x2pa8Lv1URMmnTl9tj7RM31bzBzel19YdWcKe4vb0ESRdcZESWMqxAXLK9l+RgUHSGJlgc0SyAOJ+hz92YFGU++jq/11WDslgWI=
Received: from GV1PR08MB8428.eurprd08.prod.outlook.com (2603:10a6:150:81::5)
 by DBBPR08MB10793.eurprd08.prod.outlook.com (2603:10a6:10:53d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.23; Fri, 7 Aug
 2026 11:35:01 +0000
Received: from GV1PR08MB8428.eurprd08.prod.outlook.com
 ([fe80::9b97:c973:3308:5ba7]) by GV1PR08MB8428.eurprd08.prod.outlook.com
 ([fe80::9b97:c973:3308:5ba7%5]) with mapi id 15.21.0292.018; Fri, 7 Aug 2026
 11:35:01 +0000
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
Subject: [PATCH v5 44/49] KVM: selftests: Add VGICv5 USERSPACE_PPIS tests
Thread-Topic: [PATCH v5 44/49] KVM: selftests: Add VGICv5 USERSPACE_PPIS tests
Thread-Index: AQHdJmDIEfkV4shtSU2eIkh/IgTR5w==
Date: Fri, 7 Aug 2026 11:35:01 +0000
Message-ID: <20260807111159.429128-45-sascha.bischoff@arm.com>
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
	GV1PR08MB8428:EE_|DBBPR08MB10793:EE_|AM2PEPF0001C716:EE_|VI1PR08MB10273:EE_
X-MS-Office365-Filtering-Correlation-Id: e2082e8d-97e8-4c29-6818-08def477fe62
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|23010399003|22082099003|18002099003|38070700021|6133799003|11063799006|10067099003|56012099006;
X-Microsoft-Antispam-Message-Info-Original:
 UbF19KmPenX/+8H4ENQs0Sv7qvr0VrK1F6XCtmoCnBN+RVMoiLN6Sv/GDcBD9q488sl7lYl9MvwK6lX4PU3bGq5ECU6x5cjn2GRGo3e+Ys0PafponiJx5BiuoOtsNIFLoeigAHNcOgcXShimSD/4tn3Vpvrh3dPj6Rz9XAUwj7AOpafkKyxP5Wc9uaXikTppWQVpyJLp8LIokm0fByJdTEJFQ2e/fCdmyUspFVWVLI/LDhx6xvYFY/lcBrjzVc/17Efpy7FLYFAtdnJkrHCX0DbdpKWnW0xqiq3oerktlGVh9Mf+9PvyGRyM5YrXESJmKkrq5vLLBY7ITiSlOC1ah0BEMU2W7Cl97i3vlQRnS8X1DRArKqVuv9kbU0/SKftEf36uuxQakhF7vwEbMq/2KiL9BLMCycRZd/q56jw5aTPPas7uV1shG+E2udbpYR5slsLXRPVBDeW4+YDi7x81n1CsokHtMMtbxevnsT1gqksattyoC02DNmT1lTN7cK8TnAuw8ok9rmTWv0cZnEyfSa0bMeolNDg901rg53yHKx6NITXDN2YzkBp/8RzOeM/pRXrMHoaOfuILp3LQrOzWegwsxKlq1WvUNR5FBWuJe/bse6cVWcuwUD8W3k2MWR8yR6I8+ti8p2l6jA+yJ8FgTeNpk6ZuP/MxFAGQjKMiXEdrz6nsDp3hHTZJPRUdWp0A47s+ArevfDO3dCj67jNHbCjfmyowW7qyaQv8TJsxwS8=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB8428.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(23010399003)(22082099003)(18002099003)(38070700021)(6133799003)(11063799006)(10067099003)(56012099006);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 DDy0v+3uRLMFPZf9gFv0gWq8OukhMu1dNyHVSMWdP7ZrgEXW+Zwr36z5yvfbLaYVwRNm2aUxwjDw3gqnmnwiptvjtPo4SB3JsyuUz/jrBzoj49TgO4YsYOJVieYHqAaUurbCpx8er8Tg/AISREaKXDXAHwysaOwKHMK/MVTGX5iNY9+oEOtQxnNhMzO6dKLGTQseB5GesSgwggZ+842vONwdx9npR/xVo/Wson0ZRL9uLNTlNlSJd1ixAOsnP9KlW+rQ+6axsrjH/nuONgNozZ1BO03p/7R3OsxfcWI9djeUkSTuTpn9LvU9NRYfF3zmLyo+extFXFNe+M8I7OWfJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR08MB10793
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM2PEPF0001C716.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	80aea22b-1e44-4f0c-ea55-08def477ead9
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|23010399003|376014|35042699022|14060799003|1800799024|22082099003|56012099006|11063799006|10067099003|6133799003|18002099003;
X-Microsoft-Antispam-Message-Info:
	YHiM7XdwqSF/ZcFZ2POgarT86bhLIAsYHZvJOHgUnefRiP8MbGZxRa1Gg4dfrhNbc4twopxluvfaIUDKkQJKaAn5YBRwZmb3iAJBbnc4HMX6kX7+5HSsUkiZ63zl4L+DkzGSj7Mhs5OtTW+Ix7HprvVjyxbFaQHKOtbO9/2IKTnuGHfBmaZdqmoQTwO8JHjY+0IkH454Z2XeyXdqd81XjzrAbUMabyNcqUUOM/AJoeo5RgnvZK7d9SRS1YtZVO5pRmwnQOlZvRw6bBzJXo3iUvw3aGKeOqs21r1EUziBNO8jyb9OJ5AAn7lsb9wq1RKtjXRF9FVanUEzAY8A95Vqp0TuVaU378/Cy8BnJVWxUEjqhkul8hhMKOAdS5Z79h7Rq38jbEn1rQ71MAhvQ0OnrHZ9SyS2b0izSrazG7oS8prZoiew+CRcN928jxYi8ozun7iNbw2KVoU4f7EEK8HyJf/70E2DADEx9RFAe5KmexY5Sz0JY540ZOD2DFgkUZAdlWwg+jSlXJLAwhgET7/hWJ0ZlkTZ0Bk9l4LBndVRg6tn/DGfl2wF16rZdabH2M8eyLkgfcEYuxxOggSS88Il6S8qIYO/D6bC+zAIB2/TqXzvCtQQI2EUbelixIs2tjXb4/Pj35cnb881vtvpDPTVdSpjcpNLiX23oPK56waa7HUScBz0l+o3dNbQdu0Bi8Z9Ry4/HGOd0qBhWiMVGoYClQ==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(23010399003)(376014)(35042699022)(14060799003)(1800799024)(22082099003)(56012099006)(11063799006)(10067099003)(6133799003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	iCKo6PMzYbAKXEQJ7lRyRELirymHAAqlFYfFx2jI6+NFHbGSVeRELoVE3GDf5Y3RElBjFdrPCv9jNnbKXmKrrke//5y+6Xqwkixt55tV+lTuElj434aYojgOBObHk0Slg4O3jBCUbndgU/iO+KilA/E4vC7VRIMrYykxG0ZA/rIYIuB2T8jGQ/8MIDjj+/ygPJY5dmGqICqzh1C1kvL9VhQHgQcLvHO7wD0a7prgF2FkFzdCniwf6TA6camjGfDdMNIDO/YOzymC6luwse5OBxtYJZs7F1TchhB1LzbVcnNGZ0QygjxLv/XUdCmLtNLdeQY5i1Bm9+iJGImbASWsj+GE3KCNx4Eq7118rx6IXdEdy9j5dX01OqKmkNp66dsJy08HuufHlVMSZFDQNFNaflkGlDhv0UK9L2TXFn9jfKBWxvRF2H/hTsJtOJdQEINm
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2026 11:35:33.8439
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e2082e8d-97e8-4c29-6818-08def477fe62
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM2PEPF0001C716.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB10273

Add coverage for the VGICv5 USERSPACE_PPIS control attribute. VGICv5
only allows userspace to drive PPIs that KVM explicitly advertises, so
the selftest should verify the discovery path and the corresponding
KVM_IRQ_LINE rejection cases.

Verify that KVM reports the control attribute and that the returned
bitmap contains SW_PPI. Also check that the upper 64 bits are zero, as
KVM only exposes architected PPIs (the lower 64 entries). Finally,
verify that writes, bad userspace pointers, PPIs outside the
advertised bitmap, and the first out-of-range PPI number are rejected.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 tools/testing/selftests/kvm/arm64/vgic_v5.c | 70 +++++++++++++++++++++
 1 file changed, 70 insertions(+)

diff --git a/tools/testing/selftests/kvm/arm64/vgic_v5.c b/tools/testing/se=
lftests/kvm/arm64/vgic_v5.c
index e053b01bb5be3..53aad3d32f08e 100644
--- a/tools/testing/selftests/kvm/arm64/vgic_v5.c
+++ b/tools/testing/selftests/kvm/arm64/vgic_v5.c
@@ -13,6 +13,7 @@
 #include "vgic.h"
=20
 #define NR_VCPUS		1
+#define VGIC_V5_NR_PRIVATE_IRQS	64
 #define VGIC_V5_DEFAULT_NR_SPIS	32
 #define VGIC_V5_MAX_NR_SPIS	BIT(16)
=20
@@ -111,6 +112,17 @@ static void vm_gic_destroy(struct vm_gic *v)
 	kvm_vm_free(v->vm);
 }
=20
+static u32 vgic_v5_irq_line_payload(u32 type, u32 num)
+{
+	return (type << KVM_ARM_IRQ_TYPE_SHIFT) |
+	       FIELD_PREP(KVM_ARM_IRQ_NUM_MASK, num);
+}
+
+static int __vgic_v5_irq_line(struct kvm_vm *vm, u32 type, u32 num, int le=
vel)
+{
+	return _kvm_irq_line(vm, vgic_v5_irq_line_payload(type, num), level);
+}
+
 struct vgic_region_attr {
 	u64 attr;
 	u64 size;
@@ -642,6 +654,47 @@ static void test_vgic_v5_ist_attrs(void)
 	vm_gic_destroy(&v);
 }
=20
+static void test_vgic_v5_userspace_ppis_attrs(void)
+{
+	struct kvm_vcpu *vcpu;
+	struct vm_gic v;
+	u64 user_ppis[2];
+	int ret;
+
+	v.gic_dev_type =3D KVM_DEV_TYPE_ARM_VGIC_V5;
+	v.vm =3D __vm_create(VM_SHAPE_DEFAULT, NR_VCPUS, 0);
+	v.gic_fd =3D kvm_create_device(v.vm, v.gic_dev_type);
+	vcpu =3D vm_vcpu_add(v.vm, 0, NULL);
+	TEST_ASSERT(vcpu, "Failed to create vCPU");
+
+	kvm_has_device_attr(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
+			    KVM_DEV_ARM_VGIC_CTRL_INIT);
+	kvm_has_device_attr(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
+			    KVM_DEV_ARM_VGIC_USERSPACE_PPIS);
+
+	kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
+			    KVM_DEV_ARM_VGIC_CTRL_INIT, NULL);
+
+	user_ppis[0] =3D 0;
+	user_ppis[1] =3D 0xbad;
+	ret =3D __kvm_device_attr_get(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
+				    KVM_DEV_ARM_VGIC_USERSPACE_PPIS, user_ppis);
+	TEST_ASSERT(!ret, "GICv5 USERSPACE_PPIS get failed");
+	TEST_ASSERT(user_ppis[0] & BIT(GICV5_ARCH_PPI_SW_PPI),
+		    "GICv5 USERSPACE_PPIS does not expose SW_PPI");
+	TEST_ASSERT(!user_ppis[1], "GICv5 USERSPACE_PPIS upper word is not zero")=
;
+
+	ret =3D __kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
+				    KVM_DEV_ARM_VGIC_USERSPACE_PPIS, user_ppis);
+	TEST_ASSERT(ret && errno =3D=3D ENXIO, "GICv5 USERSPACE_PPIS set accepted=
");
+
+	ret =3D __kvm_device_attr_get(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
+				    KVM_DEV_ARM_VGIC_USERSPACE_PPIS, NULL);
+	TEST_ASSERT(ret && errno =3D=3D EFAULT, "GICv5 USERSPACE_PPIS get with ba=
d pointer");
+
+	vm_gic_destroy(&v);
+}
+
 static void test_vgic_v5_ppis(u32 gic_dev_type)
 {
 	struct kvm_vcpu *vcpus[NR_VCPUS];
@@ -681,6 +734,20 @@ static void test_vgic_v5_ppis(u32 gic_dev_type)
 	TEST_ASSERT(user_ppis[0] & BIT(GICV5_ARCH_PPI_SW_PPI),
 		"SW_PPI is not drivable by userspace");
=20
+	/* PPIs not explicitly exposed to userspace must be rejected. */
+	for (i =3D 0; i < VGIC_V5_NR_PRIVATE_IRQS; i++) {
+		if (user_ppis[i / 64] & BIT_ULL(i % 64))
+			continue;
+
+		ret =3D __vgic_v5_irq_line(v.vm, KVM_ARM_IRQ_TYPE_PPI, i, 1);
+		TEST_ASSERT(ret && errno =3D=3D EINVAL,
+			    "GICv5 accepted non-userspace PPI %d", i);
+	}
+
+	ret =3D __vgic_v5_irq_line(v.vm, KVM_ARM_IRQ_TYPE_PPI,
+				 VGIC_V5_NR_PRIVATE_IRQS, 1);
+	TEST_ASSERT(ret && errno =3D=3D EINVAL, "GICv5 accepted out-of-range PPI"=
);
+
 	while (1) {
 		ret =3D run_vcpu(vcpus[0]);
 		if (ret)
@@ -767,6 +834,9 @@ void run_tests(u32 gic_dev_type)
 	pr_info("Test VGICv5 IST attrs\n");
 	test_vgic_v5_ist_attrs();
=20
+	pr_info("Test VGICv5 userspace PPI attrs\n");
+	test_vgic_v5_userspace_ppis_attrs();
+
=20
 	pr_info("Test VGICv5 PPIs\n");
 	test_vgic_v5_ppis(gic_dev_type);
--=20
2.34.1
