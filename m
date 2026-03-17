Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011050.outbound.protection.outlook.com [52.101.70.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D62F43AE1B7
	for <kvmarm@lists.linux.dev>; Tue, 17 Mar 2026 11:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.50
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773747863; cv=fail; b=BVEbR9A5rPalB297yQR3aSHm2P0aIKYYjMAgDUPUHNBkfxelteZSTnuEPjEN5kMsPQhX25B3kDoiODKBDDEvB5rCHTfmBqygvHh8uzW0Kgmq54Gqfdr04q6pBvFWcKyKIR99You7Ttc9FfH6yK0SPpu0JJ6MO2gJNC81+gVRXa4=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773747863; c=relaxed/simple;
	bh=4cgS0ffFanqEd6w27GaAMGHScnOQZAthhw/5GdOl860=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=qLrJsbumwSCaB6grev5uigPKvoFopCOgW2Rl5P+Ewn7WaSauKiGeWDX3mH+yzI4iMnRihEn/1amFGUrZJWOvDEFKAwMbuAiWeRHvqJCL4kA7QjzxxU8KVsTWVVRfXz9CegmgFGPeTdqBNnA4bvxvtP3jc3ncL/cqTM1gSLnZSBk=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=SZO6PwbI; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=SZO6PwbI; arc=fail smtp.client-ip=52.101.70.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="SZO6PwbI";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="SZO6PwbI"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=ZMYHUo2OQ2QQYKbzAI1KqOnGYVHPsA1uCWM3rGAN/Y9uticSNqfH5eqrfmmHI+15Ix63NDdq4YHP3XoxY8+4eFioCycse49NMWQ5AlsNItDnoMpPHn40uIdbHWzl1HiMysQPvD6dyLnxhIWOUkDPTwMItk1zXhtTw3TeI8oQMMz2gw67XK5BUwZMrM7MX6u0WFwlIB7FuN5IKF26FGUshs3/X4b04FN2BUICqeET/fC2Z7FTNtUPNfa/W8GOFr+gu92D2Pl9Adrwxzl/ApfeEVhp7Wq19d8KTHFXDbcpSvvn1FvJWvAaIBQVtJFo20fiKZ9JkJVKyaqAe52sQ52/+A==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xDSw10+oPkVH9UPzFYS9WQKkn1CX1SN8QHuzRrPRa/A=;
 b=GuY+dIo0S5qn0AtUy/54s1OuEhRh6WnsTrLLr9F2zMhnH7IkuF7gdn9iZPKhNJ2jme+2dQ13U2VTKs3/EgPkq592gFVmEpoZCBQ/5C0veY3HxaQaJWbGW2ji+wDvjSLEbR+gU7MfnMu06Adgh1MZ6MxiM6FhbRsjWPh1I9D1kr1hJ3i4mjDCwJxyIHehA55Cx3WS5gOffnopnudOxfVcSAGrR1OnUy2XLH6EhQjJwsLncc8YH6+JhxJM+4Qra75e7G0eN9i69er8cbPJi6mg658Aq7uEbtgR6jFSirbYiqeVNI5RyGmJmagK3T+fvzSqYNIABHX037Izwp5nIlIaFQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xDSw10+oPkVH9UPzFYS9WQKkn1CX1SN8QHuzRrPRa/A=;
 b=SZO6PwbIpl7oyRnZxSGbQ/fNi+A/9/X1ipY0+WHCWsfa5IfrbwUHqJIAffYEpalHpRSXCEdRQtYmSr6idLGjO3GB5IepcALZ7xmKguvYTpdT486YCrvLuACscqEIAYeG+KKMo1rb2nA3U3rC2HjIe2x41jv1u+yU2TK87O52x+Y=
Received: from AS4P191CA0035.EURP191.PROD.OUTLOOK.COM (2603:10a6:20b:657::11)
 by DU4PR08MB11746.eurprd08.prod.outlook.com (2603:10a6:10:63e::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.24; Tue, 17 Mar
 2026 11:44:09 +0000
Received: from AMS1EPF00000044.eurprd04.prod.outlook.com
 (2603:10a6:20b:657:cafe::ac) by AS4P191CA0035.outlook.office365.com
 (2603:10a6:20b:657::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9700.25 via Frontend Transport; Tue,
 17 Mar 2026 11:44:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS1EPF00000044.mail.protection.outlook.com (10.167.16.41) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9700.17
 via Frontend Transport; Tue, 17 Mar 2026 11:44:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kZH/vb+dBYyrz2WJqvg6Zj2B/1uh3HOYPbzy8uu70XsFJB4VMSSHgZk71ZTZC1jBLDTQujwuQpK2HGWxbwoFuDYCnSKNFO4EqsMw8Cn9UfeXgkvfc08yZF3TMHecbvwSukd6LyMHSk7ya7xfWNdV5+JexFloSCAWbNs3Gan6x+UR3gRTGW5lWJc22wUkdeuUdHFTH9+G6qJVpXOJ5t56BpSyzhOjk6HXQlWJ2vr6/K2yQ43ZLgw+hloA+gOio0npfjJ4SkPNkiUlOFnnwxwktO/Yv5h2UC90ew7zp8WYn9Ceee8ZYberoLnNehWe06Ki4vYqmSLqF0ywz6g+UVUoKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xDSw10+oPkVH9UPzFYS9WQKkn1CX1SN8QHuzRrPRa/A=;
 b=OtIWq8qo91Vv765glSH144j/mwQDVgigc5XswKYGw8EaD7qYAiCfm6YJq19wixa4iQCNUuWC+nCwnQ3m57KRc0VxBZKIayiRMc1Lo4MB7PzI7htXSdAIyUEkjyjRSL9ZUJ95z+m/mibTTh0nqt52wb2b7lnHvEm2knuRO7/kYcMAAm+3lY8537Q7bt33XiG0F19H6SMjORzO/pw8BAd7luJDMtvx0WfkNePHeL47z/54x6BvMftNMTKqjzmCFhbtHnq1U/GF9ckImuTRMn6CQdko6xwjHqhSI1jmzHbxrP9xKNgfySHltCgMfap4lI3C8XzQGPxmThSkAq1QuJMKSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xDSw10+oPkVH9UPzFYS9WQKkn1CX1SN8QHuzRrPRa/A=;
 b=SZO6PwbIpl7oyRnZxSGbQ/fNi+A/9/X1ipY0+WHCWsfa5IfrbwUHqJIAffYEpalHpRSXCEdRQtYmSr6idLGjO3GB5IepcALZ7xmKguvYTpdT486YCrvLuACscqEIAYeG+KKMo1rb2nA3U3rC2HjIe2x41jv1u+yU2TK87O52x+Y=
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com (2603:10a6:20b:504::10)
 by VI1PR08MB10122.eurprd08.prod.outlook.com (2603:10a6:800:1c8::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.21; Tue, 17 Mar
 2026 11:43:03 +0000
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27]) by AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27%6]) with mapi id 15.20.9700.022; Tue, 17 Mar 2026
 11:43:03 +0000
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
Subject: [PATCH v6 12/39] KVM: arm64: gic-v5: Support GICv5 FGTs & FGUs
Thread-Topic: [PATCH v6 12/39] KVM: arm64: gic-v5: Support GICv5 FGTs & FGUs
Thread-Index: AQHctgM2m7fibeJVdEu6b80SJreClQ==
Date: Tue, 17 Mar 2026 11:43:03 +0000
Message-ID: <20260317113949.2548118-13-sascha.bischoff@arm.com>
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
	AS4PR08MB8241:EE_|VI1PR08MB10122:EE_|AMS1EPF00000044:EE_|DU4PR08MB11746:EE_
X-MS-Office365-Filtering-Correlation-Id: 272c5ff9-089f-442f-3ea9-08de841a8012
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|38070700021|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 +P+JVR1SChmPKN2b/95JDXjzMqNdWzndzCMvq5/d2qtYpkMva5MiSgaAgVvjjUkgws+dR/wQXRdE2XU2Li/SQ1lDpy5d9DE9MgfLUztdDKY97BtVWjxJ7/eAmTkjqRQvmzeRLZeB0gqjbKZAKXEulSQVx9Pr0aZi82XwMfu5hlmmw0dv3hADikKbTrv4jdQjYq58XmrSgp91GFpDdyY30uWXaD+/pqqrdh+XRdkHygXvyFJ8PklbgpxqDFhzX851amRrgLmgBwC12FoWedAA32yesigNN5a22SulpatUL4iB8toTG1xu+oMl+oO0kJ0Q+HoYnBunNW/ajpNoGZzjOVKBm7+II2M0aLKXoNsRwSzH56Sb2VOCbihdrpTemQJq8PTYfoCK/ZbPTstEQ0YBoc9qFzS04YVzEpXCNqMTfH4cEWLLiOvJNyiU4iurqmHj2qTUND0vDtTlIn/bP6+LnTfMSGESm02zm5D/DUjwRSY7rGofHcFRMCnqpDT0f8TPUWvFRmjNcuyoObJL1xLNXTuc3oA1BdOhpbPba4wwTVhRzB1GMWMCtF5YeHzNumWiQ2VT+aZTHJQcj5PB1NB4XamGb2Ae1ndYgopfD5JdTpFw3Fnpd/gIrMyNSlMN6y9PqPyQLibtLCHkb+XxcFEATU0nQMOcSNkxzN10KhE8jsdSfwIh3eRsGb9oDi8MK0wsKJO8ERnifq8DGjYki7OyAj2RxPJHXw7+wKBWdK/zWuGIEJGW84tpUKqFI8gi/p+zDteN4rqUyfDtahNXfnOOG62Ep0f/koMRbmlDeTxyEYk=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS4PR08MB8241.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700021)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 CHTYkReaRL0CmNN9qcDnyMk0icSeldbrJPNhUtKBiWLoXIE4MJ7YHfodRfu+DpwXjs1fy2tCC2WHxnfpd9m1kuxplF0csnI8j5DsxwhV8XERC/8I7MhLEem7CdKynO8irxvtMk291ufySeTRYh+Gvgof5HFVpKC5KuLiaepbp3Rz7EguyLGrtuUDFqZYjjx6uV+OKYFTVEmyDZE7m2t0OiNLagwXt98csxttx5xXkbnMf3b203qRmLEFcaO0ITEL8vKoDLwUKBVi27ELI5n8hvPz1VoijJ0AiR9KklVQUwukuZk9wxjFozjFat3kZFVzFYSweqYkh3krf/1OimVzVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB10122
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS1EPF00000044.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	f0bfd0ec-db50-4687-035f-08de841a593f
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|36860700016|14060799003|82310400026|376014|1800799024|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	fQl6dvGiJwrVSQiweKbvMOuQS14OkbcgSb9eDXkPi95YeeuXjyBCH4bEQywMGS1SKO27KsMm0HHzq3su4CCgNrb0K4pBhDirc/89aTg61fgw6Gpsp5qxw5raz1iRVzetjSAtmaVUH7gr8kBBWkTJgPkVFsWk9b8j/SWmo039WS7JOVzrxxtP3fiQrquW48OVLIGxq1x0djnuZGiRWNgm6ohpK6OFsJAD3X2Q2gUnGXsiRLesbbh3e6olxIytYu0TFwSSnURojzu1bKo1Xfc8LVb46EUac1KpetgfR5cnaB9PxdQasXNAZDZC6WsmlJkHRqaZRwgTuxeUGSl0/wSPsde7MEyNJ5TgwOsWmqH2RfdAmFg4LY4j0t0mCBHe54VyMxG5yvZ6QQgJklGfkjihbjlBNGR2onA8ag/+HlCXvtCBjNCChqfUOjxNzJsrZYJXQdLg6Tggih2JziFmIU0BRUY7NpIDuaBuUd79qyYkDc6J7VqhAAYjrY7uwa71GDEtvqrxG1c3fzMBBdmrlteIT7JCqdsbtLNTlNnvBdv6apRYDjKeBOf00PiZwpZ1MNVLacz85pdhXsjpXXsqrU1FeOvpAy/uSxx9CIDhyg/P10vC5D/whDUdj5qlxiN/swfpFCUJy+QhECX4C4J6TPd55br14YwTTgrNRegRXK7XzprJyaJiSPQeLdEcN8IInnHqAfZxlgob+ukuIzaqbpqzvHjNxNPH9hu0z4x9V1kArtuIn/VIoWAx+bC3hpPQ+PFHY485T7iyETEyto39g4Peug==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(36860700016)(14060799003)(82310400026)(376014)(1800799024)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	vfV+WeDwYU2tz7MvhpWrqxiEXp6MewBb+CyN7yG4+40bMG66fTU4d8xVBYV09uj4H0EH1CSykMBInuumDNHkGc9O12G//Q8aZQgHN4QtHuVEuYNSIGbwmwqapalaXJc4Ai34vek5vIIKcrhWPXyLDWwVV6SeOIPG05gpLE85MWI2yU13uyxB+CgqesY85hax9PYjhjOT+ONqOvBG7RjdGMDGFUwprBE2kM/YnCs63TlNGaoln2gX+RsoDCKB4oZ/K9kBj66o/B8aJoB7zK4/2lGN3Yzg6Tn0gOn2kHMTfjaK5tU7X1KuRQmOaF12XUF5YaMlXqGpa9WX2BYlgVM/IImctHIXACTwlNIAEh0p+dHdvpVMsX0QrJVHsgDSNnCDGefsvJmneGvqWSj3WXBIh0VOVR/g7F/hWfo8WHHcWT5Vv4qwjrX3KIS5QWcm+cNx
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2026 11:44:08.4830
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 272c5ff9-089f-442f-3ea9-08de841a8012
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS1EPF00000044.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU4PR08MB11746

Extend the existing FGT/FGU infrastructure to include the GICv5 trap
registers (ICH_HFGRTR_EL2, ICH_HFGWTR_EL2, ICH_HFGITR_EL2). This
involves mapping the trap registers and their bits to the
corresponding feature that introduces them (FEAT_GCIE for all, in this
case), and mapping each trap bit to the system register/instruction
controlled by it.

As of this change, none of the GICv5 instructions or register accesses
are being trapped.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
---
 arch/arm64/include/asm/kvm_host.h       | 19 +++++
 arch/arm64/include/asm/vncr_mapping.h   |  3 +
 arch/arm64/kvm/arm.c                    |  3 +
 arch/arm64/kvm/config.c                 | 97 +++++++++++++++++++++++--
 arch/arm64/kvm/emulate-nested.c         | 68 +++++++++++++++++
 arch/arm64/kvm/hyp/include/hyp/switch.h | 27 +++++++
 arch/arm64/kvm/hyp/nvhe/switch.c        |  3 +
 arch/arm64/kvm/sys_regs.c               |  2 +
 8 files changed, 215 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm=
_host.h
index 70cb9cfd760a3..64a1ee6c442f0 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -287,6 +287,9 @@ enum fgt_group_id {
 	HDFGRTR2_GROUP,
 	HDFGWTR2_GROUP =3D HDFGRTR2_GROUP,
 	HFGITR2_GROUP,
+	ICH_HFGRTR_GROUP,
+	ICH_HFGWTR_GROUP =3D ICH_HFGRTR_GROUP,
+	ICH_HFGITR_GROUP,
=20
 	/* Must be last */
 	__NR_FGT_GROUP_IDS__
@@ -620,6 +623,10 @@ enum vcpu_sysreg {
 	VNCR(ICH_HCR_EL2),
 	VNCR(ICH_VMCR_EL2),
=20
+	VNCR(ICH_HFGRTR_EL2),
+	VNCR(ICH_HFGWTR_EL2),
+	VNCR(ICH_HFGITR_EL2),
+
 	NR_SYS_REGS	/* Nothing after this line! */
 };
=20
@@ -675,6 +682,9 @@ extern struct fgt_masks hfgwtr2_masks;
 extern struct fgt_masks hfgitr2_masks;
 extern struct fgt_masks hdfgrtr2_masks;
 extern struct fgt_masks hdfgwtr2_masks;
+extern struct fgt_masks ich_hfgrtr_masks;
+extern struct fgt_masks ich_hfgwtr_masks;
+extern struct fgt_masks ich_hfgitr_masks;
=20
 extern struct fgt_masks kvm_nvhe_sym(hfgrtr_masks);
 extern struct fgt_masks kvm_nvhe_sym(hfgwtr_masks);
@@ -687,6 +697,9 @@ extern struct fgt_masks kvm_nvhe_sym(hfgwtr2_masks);
 extern struct fgt_masks kvm_nvhe_sym(hfgitr2_masks);
 extern struct fgt_masks kvm_nvhe_sym(hdfgrtr2_masks);
 extern struct fgt_masks kvm_nvhe_sym(hdfgwtr2_masks);
+extern struct fgt_masks kvm_nvhe_sym(ich_hfgrtr_masks);
+extern struct fgt_masks kvm_nvhe_sym(ich_hfgwtr_masks);
+extern struct fgt_masks kvm_nvhe_sym(ich_hfgitr_masks);
=20
 struct kvm_cpu_context {
 	struct user_pt_regs regs;	/* sp =3D sp_el0 */
@@ -1659,6 +1672,11 @@ static __always_inline enum fgt_group_id __fgt_reg_t=
o_group_id(enum vcpu_sysreg
 	case HDFGRTR2_EL2:
 	case HDFGWTR2_EL2:
 		return HDFGRTR2_GROUP;
+	case ICH_HFGRTR_EL2:
+	case ICH_HFGWTR_EL2:
+		return ICH_HFGRTR_GROUP;
+	case ICH_HFGITR_EL2:
+		return ICH_HFGITR_GROUP;
 	default:
 		BUILD_BUG_ON(1);
 	}
@@ -1673,6 +1691,7 @@ static __always_inline enum fgt_group_id __fgt_reg_to=
_group_id(enum vcpu_sysreg
 		case HDFGWTR_EL2:					\
 		case HFGWTR2_EL2:					\
 		case HDFGWTR2_EL2:					\
+		case ICH_HFGWTR_EL2:					\
 			p =3D &(vcpu)->arch.fgt[id].w;			\
 			break;						\
 		default:						\
diff --git a/arch/arm64/include/asm/vncr_mapping.h b/arch/arm64/include/asm=
/vncr_mapping.h
index c2485a862e690..14366d35ce82f 100644
--- a/arch/arm64/include/asm/vncr_mapping.h
+++ b/arch/arm64/include/asm/vncr_mapping.h
@@ -108,5 +108,8 @@
 #define VNCR_MPAMVPM5_EL2       0x968
 #define VNCR_MPAMVPM6_EL2       0x970
 #define VNCR_MPAMVPM7_EL2       0x978
+#define VNCR_ICH_HFGITR_EL2	0xB10
+#define VNCR_ICH_HFGRTR_EL2	0xB18
+#define VNCR_ICH_HFGWTR_EL2	0xB20
=20
 #endif /* __ARM64_VNCR_MAPPING_H__ */
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 410ffd41fd73a..aa69fd5b372fd 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2529,6 +2529,9 @@ static void kvm_hyp_init_symbols(void)
 	kvm_nvhe_sym(hfgitr2_masks) =3D hfgitr2_masks;
 	kvm_nvhe_sym(hdfgrtr2_masks)=3D hdfgrtr2_masks;
 	kvm_nvhe_sym(hdfgwtr2_masks)=3D hdfgwtr2_masks;
+	kvm_nvhe_sym(ich_hfgrtr_masks) =3D ich_hfgrtr_masks;
+	kvm_nvhe_sym(ich_hfgwtr_masks) =3D ich_hfgwtr_masks;
+	kvm_nvhe_sym(ich_hfgitr_masks) =3D ich_hfgitr_masks;
=20
 	/*
 	 * Flush entire BSS since part of its data containing init symbols is rea=
d
diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
index d9f553cbf9dfd..e4ec1bda8dfcb 100644
--- a/arch/arm64/kvm/config.c
+++ b/arch/arm64/kvm/config.c
@@ -225,6 +225,7 @@ struct reg_feat_map_desc {
 #define FEAT_MTPMU		ID_AA64DFR0_EL1, MTPMU, IMP
 #define FEAT_HCX		ID_AA64MMFR1_EL1, HCX, IMP
 #define FEAT_S2PIE		ID_AA64MMFR3_EL1, S2PIE, IMP
+#define FEAT_GCIE		ID_AA64PFR2_EL1, GCIE, IMP
=20
 static bool not_feat_aa64el3(struct kvm *kvm)
 {
@@ -1277,6 +1278,58 @@ static const struct reg_bits_to_feat_map vtcr_el2_fe=
at_map[] =3D {
 static const DECLARE_FEAT_MAP(vtcr_el2_desc, VTCR_EL2,
 			      vtcr_el2_feat_map, FEAT_AA64EL2);
=20
+static const struct reg_bits_to_feat_map ich_hfgrtr_feat_map[] =3D {
+	NEEDS_FEAT(ICH_HFGRTR_EL2_ICC_APR_EL1 |
+		   ICH_HFGRTR_EL2_ICC_IDRn_EL1 |
+		   ICH_HFGRTR_EL2_ICC_CR0_EL1 |
+		   ICH_HFGRTR_EL2_ICC_HPPIR_EL1 |
+		   ICH_HFGRTR_EL2_ICC_PCR_EL1 |
+		   ICH_HFGRTR_EL2_ICC_ICSR_EL1 |
+		   ICH_HFGRTR_EL2_ICC_IAFFIDR_EL1 |
+		   ICH_HFGRTR_EL2_ICC_PPI_HMRn_EL1 |
+		   ICH_HFGRTR_EL2_ICC_PPI_ENABLERn_EL1 |
+		   ICH_HFGRTR_EL2_ICC_PPI_PENDRn_EL1 |
+		   ICH_HFGRTR_EL2_ICC_PPI_PRIORITYRn_EL1 |
+		   ICH_HFGRTR_EL2_ICC_PPI_ACTIVERn_EL1,
+		   FEAT_GCIE),
+};
+
+static const DECLARE_FEAT_MAP_FGT(ich_hfgrtr_desc, ich_hfgrtr_masks,
+				  ich_hfgrtr_feat_map, FEAT_GCIE);
+
+static const struct reg_bits_to_feat_map ich_hfgwtr_feat_map[] =3D {
+	NEEDS_FEAT(ICH_HFGWTR_EL2_ICC_APR_EL1 |
+		   ICH_HFGWTR_EL2_ICC_CR0_EL1 |
+		   ICH_HFGWTR_EL2_ICC_PCR_EL1 |
+		   ICH_HFGWTR_EL2_ICC_ICSR_EL1 |
+		   ICH_HFGWTR_EL2_ICC_PPI_ENABLERn_EL1 |
+		   ICH_HFGWTR_EL2_ICC_PPI_PENDRn_EL1 |
+		   ICH_HFGWTR_EL2_ICC_PPI_PRIORITYRn_EL1 |
+		   ICH_HFGWTR_EL2_ICC_PPI_ACTIVERn_EL1,
+		   FEAT_GCIE),
+};
+
+static const DECLARE_FEAT_MAP_FGT(ich_hfgwtr_desc, ich_hfgwtr_masks,
+				  ich_hfgwtr_feat_map, FEAT_GCIE);
+
+static const struct reg_bits_to_feat_map ich_hfgitr_feat_map[] =3D {
+	NEEDS_FEAT(ICH_HFGITR_EL2_GICCDEN |
+		   ICH_HFGITR_EL2_GICCDDIS |
+		   ICH_HFGITR_EL2_GICCDPRI |
+		   ICH_HFGITR_EL2_GICCDAFF |
+		   ICH_HFGITR_EL2_GICCDPEND |
+		   ICH_HFGITR_EL2_GICCDRCFG |
+		   ICH_HFGITR_EL2_GICCDHM |
+		   ICH_HFGITR_EL2_GICCDEOI |
+		   ICH_HFGITR_EL2_GICCDDI |
+		   ICH_HFGITR_EL2_GICRCDIA |
+		   ICH_HFGITR_EL2_GICRCDNMIA,
+		   FEAT_GCIE),
+};
+
+static const DECLARE_FEAT_MAP_FGT(ich_hfgitr_desc, ich_hfgitr_masks,
+				  ich_hfgitr_feat_map, FEAT_GCIE);
+
 static void __init check_feat_map(const struct reg_bits_to_feat_map *map,
 				  int map_size, u64 resx, const char *str)
 {
@@ -1328,6 +1381,9 @@ void __init check_feature_map(void)
 	check_reg_desc(&sctlr_el2_desc);
 	check_reg_desc(&mdcr_el2_desc);
 	check_reg_desc(&vtcr_el2_desc);
+	check_reg_desc(&ich_hfgrtr_desc);
+	check_reg_desc(&ich_hfgwtr_desc);
+	check_reg_desc(&ich_hfgitr_desc);
 }
=20
 static bool idreg_feat_match(struct kvm *kvm, const struct reg_bits_to_fea=
t_map *map)
@@ -1460,6 +1516,13 @@ void compute_fgu(struct kvm *kvm, enum fgt_group_id =
fgt)
 		val |=3D compute_fgu_bits(kvm, &hdfgrtr2_desc);
 		val |=3D compute_fgu_bits(kvm, &hdfgwtr2_desc);
 		break;
+	case ICH_HFGRTR_GROUP:
+		val |=3D compute_fgu_bits(kvm, &ich_hfgrtr_desc);
+		val |=3D compute_fgu_bits(kvm, &ich_hfgwtr_desc);
+		break;
+	case ICH_HFGITR_GROUP:
+		val |=3D compute_fgu_bits(kvm, &ich_hfgitr_desc);
+		break;
 	default:
 		BUG();
 	}
@@ -1531,6 +1594,15 @@ struct resx get_reg_fixed_bits(struct kvm *kvm, enum=
 vcpu_sysreg reg)
 	case VTCR_EL2:
 		resx =3D compute_reg_resx_bits(kvm, &vtcr_el2_desc, 0, 0);
 		break;
+	case ICH_HFGRTR_EL2:
+		resx =3D compute_reg_resx_bits(kvm, &ich_hfgrtr_desc, 0, 0);
+		break;
+	case ICH_HFGWTR_EL2:
+		resx =3D compute_reg_resx_bits(kvm, &ich_hfgwtr_desc, 0, 0);
+		break;
+	case ICH_HFGITR_EL2:
+		resx =3D compute_reg_resx_bits(kvm, &ich_hfgitr_desc, 0, 0);
+		break;
 	default:
 		WARN_ON_ONCE(1);
 		resx =3D (typeof(resx)){};
@@ -1565,6 +1637,12 @@ static __always_inline struct fgt_masks *__fgt_reg_t=
o_masks(enum vcpu_sysreg reg
 		return &hdfgrtr2_masks;
 	case HDFGWTR2_EL2:
 		return &hdfgwtr2_masks;
+	case ICH_HFGRTR_EL2:
+		return &ich_hfgrtr_masks;
+	case ICH_HFGWTR_EL2:
+		return &ich_hfgwtr_masks;
+	case ICH_HFGITR_EL2:
+		return &ich_hfgitr_masks;
 	default:
 		BUILD_BUG_ON(1);
 	}
@@ -1618,12 +1696,17 @@ void kvm_vcpu_load_fgt(struct kvm_vcpu *vcpu)
 	__compute_hdfgwtr(vcpu);
 	__compute_fgt(vcpu, HAFGRTR_EL2);
=20
-	if (!cpus_have_final_cap(ARM64_HAS_FGT2))
-		return;
+	if (cpus_have_final_cap(ARM64_HAS_FGT2)) {
+		__compute_fgt(vcpu, HFGRTR2_EL2);
+		__compute_fgt(vcpu, HFGWTR2_EL2);
+		__compute_fgt(vcpu, HFGITR2_EL2);
+		__compute_fgt(vcpu, HDFGRTR2_EL2);
+		__compute_fgt(vcpu, HDFGWTR2_EL2);
+	}
=20
-	__compute_fgt(vcpu, HFGRTR2_EL2);
-	__compute_fgt(vcpu, HFGWTR2_EL2);
-	__compute_fgt(vcpu, HFGITR2_EL2);
-	__compute_fgt(vcpu, HDFGRTR2_EL2);
-	__compute_fgt(vcpu, HDFGWTR2_EL2);
+	if (cpus_have_final_cap(ARM64_HAS_GICV5_CPUIF)) {
+		__compute_fgt(vcpu, ICH_HFGRTR_EL2);
+		__compute_fgt(vcpu, ICH_HFGWTR_EL2);
+		__compute_fgt(vcpu, ICH_HFGITR_EL2);
+	}
 }
diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-neste=
d.c
index 22d497554c949..dba7ced74ca5e 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -2053,6 +2053,60 @@ static const struct encoding_to_trap_config encoding=
_to_fgt[] __initconst =3D {
 	SR_FGT(SYS_AMEVCNTR0_EL0(2),	HAFGRTR, AMEVCNTR02_EL0, 1),
 	SR_FGT(SYS_AMEVCNTR0_EL0(1),	HAFGRTR, AMEVCNTR01_EL0, 1),
 	SR_FGT(SYS_AMEVCNTR0_EL0(0),	HAFGRTR, AMEVCNTR00_EL0, 1),
+
+	/*
+	 * ICH_HFGRTR_EL2 & ICH_HFGWTR_EL2
+	 */
+	SR_FGT(SYS_ICC_APR_EL1,			ICH_HFGRTR, ICC_APR_EL1, 0),
+	SR_FGT(SYS_ICC_IDR0_EL1,		ICH_HFGRTR, ICC_IDRn_EL1, 0),
+	SR_FGT(SYS_ICC_CR0_EL1,			ICH_HFGRTR, ICC_CR0_EL1, 0),
+	SR_FGT(SYS_ICC_HPPIR_EL1,		ICH_HFGRTR, ICC_HPPIR_EL1, 0),
+	SR_FGT(SYS_ICC_PCR_EL1,			ICH_HFGRTR, ICC_PCR_EL1, 0),
+	SR_FGT(SYS_ICC_ICSR_EL1,		ICH_HFGRTR, ICC_ICSR_EL1, 0),
+	SR_FGT(SYS_ICC_IAFFIDR_EL1,		ICH_HFGRTR, ICC_IAFFIDR_EL1, 0),
+	SR_FGT(SYS_ICC_PPI_HMR0_EL1,		ICH_HFGRTR, ICC_PPI_HMRn_EL1, 0),
+	SR_FGT(SYS_ICC_PPI_HMR1_EL1,		ICH_HFGRTR, ICC_PPI_HMRn_EL1, 0),
+	SR_FGT(SYS_ICC_PPI_ENABLER0_EL1,	ICH_HFGRTR, ICC_PPI_ENABLERn_EL1, 0),
+	SR_FGT(SYS_ICC_PPI_ENABLER1_EL1,	ICH_HFGRTR, ICC_PPI_ENABLERn_EL1, 0),
+	SR_FGT(SYS_ICC_PPI_CPENDR0_EL1,		ICH_HFGRTR, ICC_PPI_PENDRn_EL1, 0),
+	SR_FGT(SYS_ICC_PPI_CPENDR1_EL1,		ICH_HFGRTR, ICC_PPI_PENDRn_EL1, 0),
+	SR_FGT(SYS_ICC_PPI_SPENDR0_EL1,		ICH_HFGRTR, ICC_PPI_PENDRn_EL1, 0),
+	SR_FGT(SYS_ICC_PPI_SPENDR1_EL1,		ICH_HFGRTR, ICC_PPI_PENDRn_EL1, 0),
+	SR_FGT(SYS_ICC_PPI_PRIORITYR0_EL1,	ICH_HFGRTR, ICC_PPI_PRIORITYRn_EL1, 0)=
,
+	SR_FGT(SYS_ICC_PPI_PRIORITYR1_EL1,	ICH_HFGRTR, ICC_PPI_PRIORITYRn_EL1, 0)=
,
+	SR_FGT(SYS_ICC_PPI_PRIORITYR2_EL1,	ICH_HFGRTR, ICC_PPI_PRIORITYRn_EL1, 0)=
,
+	SR_FGT(SYS_ICC_PPI_PRIORITYR3_EL1,	ICH_HFGRTR, ICC_PPI_PRIORITYRn_EL1, 0)=
,
+	SR_FGT(SYS_ICC_PPI_PRIORITYR4_EL1,	ICH_HFGRTR, ICC_PPI_PRIORITYRn_EL1, 0)=
,
+	SR_FGT(SYS_ICC_PPI_PRIORITYR5_EL1,	ICH_HFGRTR, ICC_PPI_PRIORITYRn_EL1, 0)=
,
+	SR_FGT(SYS_ICC_PPI_PRIORITYR6_EL1,	ICH_HFGRTR, ICC_PPI_PRIORITYRn_EL1, 0)=
,
+	SR_FGT(SYS_ICC_PPI_PRIORITYR7_EL1,	ICH_HFGRTR, ICC_PPI_PRIORITYRn_EL1, 0)=
,
+	SR_FGT(SYS_ICC_PPI_PRIORITYR8_EL1,	ICH_HFGRTR, ICC_PPI_PRIORITYRn_EL1, 0)=
,
+	SR_FGT(SYS_ICC_PPI_PRIORITYR9_EL1,	ICH_HFGRTR, ICC_PPI_PRIORITYRn_EL1, 0)=
,
+	SR_FGT(SYS_ICC_PPI_PRIORITYR10_EL1,	ICH_HFGRTR, ICC_PPI_PRIORITYRn_EL1, 0=
),
+	SR_FGT(SYS_ICC_PPI_PRIORITYR11_EL1,	ICH_HFGRTR, ICC_PPI_PRIORITYRn_EL1, 0=
),
+	SR_FGT(SYS_ICC_PPI_PRIORITYR12_EL1,	ICH_HFGRTR, ICC_PPI_PRIORITYRn_EL1, 0=
),
+	SR_FGT(SYS_ICC_PPI_PRIORITYR13_EL1,	ICH_HFGRTR, ICC_PPI_PRIORITYRn_EL1, 0=
),
+	SR_FGT(SYS_ICC_PPI_PRIORITYR14_EL1,	ICH_HFGRTR, ICC_PPI_PRIORITYRn_EL1, 0=
),
+	SR_FGT(SYS_ICC_PPI_PRIORITYR15_EL1,	ICH_HFGRTR, ICC_PPI_PRIORITYRn_EL1, 0=
),
+	SR_FGT(SYS_ICC_PPI_CACTIVER0_EL1,	ICH_HFGRTR, ICC_PPI_ACTIVERn_EL1, 0),
+	SR_FGT(SYS_ICC_PPI_CACTIVER1_EL1,	ICH_HFGRTR, ICC_PPI_ACTIVERn_EL1, 0),
+	SR_FGT(SYS_ICC_PPI_SACTIVER0_EL1,	ICH_HFGRTR, ICC_PPI_ACTIVERn_EL1, 0),
+	SR_FGT(SYS_ICC_PPI_SACTIVER1_EL1,	ICH_HFGRTR, ICC_PPI_ACTIVERn_EL1, 0),
+
+	/*
+	 * ICH_HFGITR_EL2
+	 */
+	SR_FGT(GICV5_OP_GIC_CDEN,	ICH_HFGITR, GICCDEN, 0),
+	SR_FGT(GICV5_OP_GIC_CDDIS,	ICH_HFGITR, GICCDDIS, 0),
+	SR_FGT(GICV5_OP_GIC_CDPRI,	ICH_HFGITR, GICCDPRI, 0),
+	SR_FGT(GICV5_OP_GIC_CDAFF,	ICH_HFGITR, GICCDAFF, 0),
+	SR_FGT(GICV5_OP_GIC_CDPEND,	ICH_HFGITR, GICCDPEND, 0),
+	SR_FGT(GICV5_OP_GIC_CDRCFG,	ICH_HFGITR, GICCDRCFG, 0),
+	SR_FGT(GICV5_OP_GIC_CDHM,	ICH_HFGITR, GICCDHM, 0),
+	SR_FGT(GICV5_OP_GIC_CDEOI,	ICH_HFGITR, GICCDEOI, 0),
+	SR_FGT(GICV5_OP_GIC_CDDI,	ICH_HFGITR, GICCDDI, 0),
+	SR_FGT(GICV5_OP_GICR_CDIA,	ICH_HFGITR, GICRCDIA, 0),
+	SR_FGT(GICV5_OP_GICR_CDNMIA,	ICH_HFGITR, GICRCDNMIA, 0),
 };
=20
 /*
@@ -2127,6 +2181,9 @@ FGT_MASKS(hfgwtr2_masks, HFGWTR2_EL2);
 FGT_MASKS(hfgitr2_masks, HFGITR2_EL2);
 FGT_MASKS(hdfgrtr2_masks, HDFGRTR2_EL2);
 FGT_MASKS(hdfgwtr2_masks, HDFGWTR2_EL2);
+FGT_MASKS(ich_hfgrtr_masks, ICH_HFGRTR_EL2);
+FGT_MASKS(ich_hfgwtr_masks, ICH_HFGWTR_EL2);
+FGT_MASKS(ich_hfgitr_masks, ICH_HFGITR_EL2);
=20
 static __init bool aggregate_fgt(union trap_config tc)
 {
@@ -2162,6 +2219,14 @@ static __init bool aggregate_fgt(union trap_config t=
c)
 		rmasks =3D &hfgitr2_masks;
 		wmasks =3D NULL;
 		break;
+	case ICH_HFGRTR_GROUP:
+		rmasks =3D &ich_hfgrtr_masks;
+		wmasks =3D &ich_hfgwtr_masks;
+		break;
+	case ICH_HFGITR_GROUP:
+		rmasks =3D &ich_hfgitr_masks;
+		wmasks =3D NULL;
+		break;
 	}
=20
 	rresx =3D rmasks->res0 | rmasks->res1;
@@ -2232,6 +2297,9 @@ static __init int check_all_fgt_masks(int ret)
 		&hfgitr2_masks,
 		&hdfgrtr2_masks,
 		&hdfgwtr2_masks,
+		&ich_hfgrtr_masks,
+		&ich_hfgwtr_masks,
+		&ich_hfgitr_masks,
 	};
 	int err =3D 0;
=20
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/i=
nclude/hyp/switch.h
index 2597e8bda8672..ae04fd680d1e2 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -233,6 +233,18 @@ static inline void __activate_traps_hfgxtr(struct kvm_=
vcpu *vcpu)
 	__activate_fgt(hctxt, vcpu, HDFGWTR2_EL2);
 }
=20
+static inline void __activate_traps_ich_hfgxtr(struct kvm_vcpu *vcpu)
+{
+	struct kvm_cpu_context *hctxt =3D host_data_ptr(host_ctxt);
+
+	if (!cpus_have_final_cap(ARM64_HAS_GICV5_CPUIF))
+		return;
+
+	__activate_fgt(hctxt, vcpu, ICH_HFGRTR_EL2);
+	__activate_fgt(hctxt, vcpu, ICH_HFGWTR_EL2);
+	__activate_fgt(hctxt, vcpu, ICH_HFGITR_EL2);
+}
+
 #define __deactivate_fgt(htcxt, vcpu, reg)				\
 	do {								\
 		write_sysreg_s(ctxt_sys_reg(hctxt, reg),		\
@@ -265,6 +277,19 @@ static inline void __deactivate_traps_hfgxtr(struct kv=
m_vcpu *vcpu)
 	__deactivate_fgt(hctxt, vcpu, HDFGWTR2_EL2);
 }
=20
+static inline void __deactivate_traps_ich_hfgxtr(struct kvm_vcpu *vcpu)
+{
+	struct kvm_cpu_context *hctxt =3D host_data_ptr(host_ctxt);
+
+	if (!cpus_have_final_cap(ARM64_HAS_GICV5_CPUIF))
+		return;
+
+	__deactivate_fgt(hctxt, vcpu, ICH_HFGRTR_EL2);
+	__deactivate_fgt(hctxt, vcpu, ICH_HFGWTR_EL2);
+	__deactivate_fgt(hctxt, vcpu, ICH_HFGITR_EL2);
+
+}
+
 static inline void  __activate_traps_mpam(struct kvm_vcpu *vcpu)
 {
 	u64 r =3D MPAM2_EL2_TRAPMPAM0EL1 | MPAM2_EL2_TRAPMPAM1EL1;
@@ -328,6 +353,7 @@ static inline void __activate_traps_common(struct kvm_v=
cpu *vcpu)
 	}
=20
 	__activate_traps_hfgxtr(vcpu);
+	__activate_traps_ich_hfgxtr(vcpu);
 	__activate_traps_mpam(vcpu);
 }
=20
@@ -345,6 +371,7 @@ static inline void __deactivate_traps_common(struct kvm=
_vcpu *vcpu)
 		write_sysreg_s(ctxt_sys_reg(hctxt, HCRX_EL2), SYS_HCRX_EL2);
=20
 	__deactivate_traps_hfgxtr(vcpu);
+	__deactivate_traps_ich_hfgxtr(vcpu);
 	__deactivate_traps_mpam();
 }
=20
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/swi=
tch.c
index 779089e42681e..b41485ce295ab 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -44,6 +44,9 @@ struct fgt_masks hfgwtr2_masks;
 struct fgt_masks hfgitr2_masks;
 struct fgt_masks hdfgrtr2_masks;
 struct fgt_masks hdfgwtr2_masks;
+struct fgt_masks ich_hfgrtr_masks;
+struct fgt_masks ich_hfgwtr_masks;
+struct fgt_masks ich_hfgitr_masks;
=20
 extern void kvm_nvhe_prepare_backtrace(unsigned long fp, unsigned long pc)=
;
=20
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 140cf35f4eeb4..cd6deaf473159 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -5661,6 +5661,8 @@ void kvm_calculate_traps(struct kvm_vcpu *vcpu)
 	compute_fgu(kvm, HFGRTR2_GROUP);
 	compute_fgu(kvm, HFGITR2_GROUP);
 	compute_fgu(kvm, HDFGRTR2_GROUP);
+	compute_fgu(kvm, ICH_HFGRTR_GROUP);
+	compute_fgu(kvm, ICH_HFGITR_GROUP);
=20
 	set_bit(KVM_ARCH_FLAG_FGU_INITIALIZED, &kvm->arch.flags);
 out:
--=20
2.34.1
