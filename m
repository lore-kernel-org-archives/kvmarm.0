Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011055.outbound.protection.outlook.com [52.101.65.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EB584A92E1;
	Fri,  4 Sep 2026 10:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.55
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788519518; cv=fail; b=DpXQwOMXBiX+4pvDocO++RiJKcW3CTFAzuWzVgvq5sUYRLK4KzE4FNivGE8deTzE94V8EU3pNDNj70lZ2M8zePEh3Wa7hLCYHDeZ4SQLzYaIKvrWPVck9b6vOLInt9L12CINFEJUrHXXgZflGHEYDZpwrkDg3Kfme/6reXbFtqY=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788519518; c=relaxed/simple;
	bh=ANZUIS8pFtQhFvhVYhJ5zLqKyXkKKaLXGhZ0UWL7yLE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=SUEoi+PflTJDSA66Ja1kvoipN3q1j7gUZqjJimYJrGcYDrH0jv/QF5DBwIjD8QvyhZsj6wRmhIF2TCZ4UKHUHKvApsPXzc34awoYgaMwFvYMpo/cBwFVP10RVS7aG/KPJ6GODqpEqO3LvLyHG38KR6neev0jM0J74XzTRLPSq40=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=dd3h73u3; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=dd3h73u3; arc=fail smtp.client-ip=52.101.65.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="dd3h73u3";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="dd3h73u3"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=hJxjelq4qrxzX+LDFKxIfWO1SZLXAq13VIhMOACnGqnTqg3+RdYMXWYtOEh7lpslyhfcNjiLlVS4L8P5FoYAV1OQW/cLAEmcYQMlatlaONNJgYP7dzYCMY1S4Ujm9KWkdQsvvfzDCT1/6be4RYCX/TL6vD+DcHEgE95+mqy1yaRFDRwN9OSgHzn+/n1H3kncTPQckAT2rhsq/xG4ypsrp/RobrhBRnkLAiXlbsAb/cz5buSdj2HSgoKERAydm5AkFR2IEPZQChjQ6BSvP8tJHqDVid/YsiHuKSj6t5oC5Ms1rcTPOnAPY/jczu1yMjJ5r9WHk///SU/OOyfjIGMkug==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ANZUIS8pFtQhFvhVYhJ5zLqKyXkKKaLXGhZ0UWL7yLE=;
 b=SrSbLWh9X/CkAS6eekp8arZlUFmODxdepBmKIqJpsX4WMX8R+N/XRNbQnbHpve2ejj6IbSPdiexaOU+frskkGSedS0q45E3ZgStqj4y7tT+rDxn1+uMqSxBe9w7enmMWlLfbUybh2nMAKYmt/JYXrx/teX33e65iW1jeCPemd7R3jX6uzltDPH/dwtUNQfOSRoulpYx2Q7tg4/xaaCdCVgMuQzyPX6XozZ2hIaVzdraJbyXbRWyaC5rIWehhl9MPpBToYsbB8eBUY1oq2cawJznJLDonNPh+PARUnBun/1qFO2CypzHKPJotONIUjYSEwNEHEJM5rbnsMXc5YUITDA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ANZUIS8pFtQhFvhVYhJ5zLqKyXkKKaLXGhZ0UWL7yLE=;
 b=dd3h73u3lhcUQvOSA68Gat5UuEjebmSWX1/s7Dm57jWAMDcJiQkT/kWsX1cRqgiT1XfnIPtZ2ss8K1HUIV9VdjCyQIgkjQbtmDvI0RUS+opk/zChvevGGMLqpPJkhsMkmpTit2oY15oIoJvtvLBJ6RP3VEzWe7i6iGsb+ZniqA4=
Received: from VI6PEPF00000205.AUTP296.PROD.OUTLOOK.COM (2603:10a6:808:1::915)
 by AM8PR08MB5811.eurprd08.prod.outlook.com (2603:10a6:20b:1de::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 10:58:30 +0000
Received: from WA1PEPF00009B38.eurprd05.prod.outlook.com (2603:10a6:1d8::115)
 by VI6PEPF00000205.outlook.office365.com (2603:10a6:808:1::915) with
 Microsoft SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id
 15.21.382.13 via Frontend Transport; Fri, 4 Sep 2026 10:58:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 WA1PEPF00009B38.mail.protection.outlook.com (10.167.242.37) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.8
 via Frontend Transport; Fri, 4 Sep 2026 10:58:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=K7lCT139kJDmt28J1FiuRywDnUbrLBkpR15Qn4jyCIIWk08jiz3xPGxZ/ezBTWV90w/a4SFBBeZIkkitbeVHfLUtHPiL+2glmSAQI6leQJRPYqPNqKeyioUlOL76CjRjaV3Tfbhkf3BGLvriK1WFp6NQ4sZ9cj0Wsu3BTdyu+hP6x6JCWyKVeWxHDFOy5kpzliLfjH2I13XmMQudAyvQ2XG/4y58inW7iTOOyChoah6BxmHPNKfTSYREhBP7b3n0N01+8tN5P3xEvnx9rrC6hRylX4RgIb+LdKuvUinmhkZVIeFsR//LNfInRiDGbnPM8O0IT53Uyun/VEJH6Pxz1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ANZUIS8pFtQhFvhVYhJ5zLqKyXkKKaLXGhZ0UWL7yLE=;
 b=oMgDp5vvy0EfktFhG7H6fyfqIduwkqyn10/raEu0v+DFZ5VU59j3j2Ga7Rlgks6dviN1qAVxvpEPQs0gi/sgTwVfI/8MZliCbppCqiqANCOfsIFpKeZxEf8rRNzQMYSgpK+kJ7DN6tY0ZZze6+f+EFknZAUnaB6EYo6vCe67Z3jDpQ3vVcKmelFXDlJZV1eYR7FUoLJViUO/VNigZ9rLmXAT8End38uYw9k145oq1dMnLV+f6MW2neA/qxRmgUV7h+TsmRys75qjTXcKAduRUzyNALsOKzC/WwcNVaFlaY/qvSYRJvHRKCuUByDDP5ukyGvh+ZB5t18QvqNwOS/w7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ANZUIS8pFtQhFvhVYhJ5zLqKyXkKKaLXGhZ0UWL7yLE=;
 b=dd3h73u3lhcUQvOSA68Gat5UuEjebmSWX1/s7Dm57jWAMDcJiQkT/kWsX1cRqgiT1XfnIPtZ2ss8K1HUIV9VdjCyQIgkjQbtmDvI0RUS+opk/zChvevGGMLqpPJkhsMkmpTit2oY15oIoJvtvLBJ6RP3VEzWe7i6iGsb+ZniqA4=
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com (2603:10a6:101:1d::23)
 by GV2PR08MB8437.eurprd08.prod.outlook.com (2603:10a6:150:c3::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.7; Fri, 4 Sep 2026
 10:57:56 +0000
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e]) by PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e%4]) with mapi id 15.21.0382.007; Fri, 4 Sep 2026
 10:57:56 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "sashiko-reviews@lists.linux.dev" <sashiko-reviews@lists.linux.dev>
CC: "maz@kernel.org" <maz@kernel.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"oupton@kernel.org" <oupton@kernel.org>, nd <nd@arm.com>
Subject: Re: [PATCH v5 49/49] KVM: selftests: Add VGICv5 sparse vCPU IDs test
Thread-Topic: [PATCH v5 49/49] KVM: selftests: Add VGICv5 sparse vCPU IDs test
Thread-Index: AQHdJmEjhOX8KfScjk6WDNanV30n57aS33QAgCuMQ4A=
Date: Fri, 4 Sep 2026 10:57:56 +0000
Message-ID: <89f6657a33eb18b9641dbee38ed4b71320e72a16.camel@arm.com>
References: <20260807111159.429128-1-sascha.bischoff@arm.com>
	 <20260807111159.429128-50-sascha.bischoff@arm.com>
	 <20260807175645.0FF0F1F000E9@smtp.kernel.org>
In-Reply-To: <20260807175645.0FF0F1F000E9@smtp.kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	PR2PR08MB4889:EE_|GV2PR08MB8437:EE_|WA1PEPF00009B38:EE_|AM8PR08MB5811:EE_
X-MS-Office365-Filtering-Correlation-Id: 26e51356-327c-4b5a-c988-08df0a73744f
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|23010399003|366016|376014|38070700021|6133799003|56012099006|11063799006|4143699003|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info-Original:
 DC/G2NDJCmo++nf435TKwaSNDTLI5DC8fj+YaALlNYGTsA6WOdrGFsTuNq4Ue4PRDFpJkeaBD35PlaSDTHNJOaE8LVJWMPo12Pjd8scUgwktU62VPKzA02sMMgWPMdcSJvbBzJ4FlZVybwWVzhlh+v9qZwZ0gKuhl2jsjA+hyCXxif6eNrZtnerwaA9HH1uty6/8/65xrIx50e5gOWxDhoWu5UhZp4pcemXurEahGwkPgs/0qDeQgK5kWHvRK1i2nQ4w/Bmw/796a79I0q+KykOp5+RMTyalL0V7aS+d53cmqjfKigwPcvyDYoHU4HaovydzagQukolZ14vN0qaAVAO4bXuuMS1bA8ObENYYEex33PxQ1rd7WrX2jkxheYSup7yiDbPS12sjgzhoEjpN/TmcXkZA3PkMpKTgkXcYGhLKq5AB25xQT8a+y3PJQwisT9KrKhA8aj3EvdMRCny0nE9Uq6leQBZV6BLk/h/pi+6rvDH27RiRC/A6jZA4Wuo+bJOOe15KsCN0LZA8//Uyq7fmjqO0X5U2fDae+iwgiU3fE+RegLpRKx+xoLBIn1NGOAHvxNQANwN/B90NE/4gl2IgDyWonMne8rRBhlCiX09dAw9aXOFl3UdvgH3NANhHP8KHKhiXxQ/qii1OORXAh95jqp7QU1Km5DDbBsL6IsFwjxwgdrvG4sfR2iZbOplLTAFPMvM/JTvQ6SzpUIE8zw==
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR2PR08MB4889.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(366016)(376014)(38070700021)(6133799003)(56012099006)(11063799006)(4143699003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <8CB70F7D0FB22F4EAD2588167402D9C6@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 KYNLVN2jeVwzE/z9FmBPOzysL/eEUg3VvHpUpMWvRhigWKV9eUXAewoa21Qf7ZmpjZDXtOM1nql4F5RViklWqBTg1dIFHoMuY4ZJS2kKquTz8LGr/VjEOaTQkYVTucs+BU6pL2FsaqZynLwvPMw4bPe4/dH8Y4rP+tmDJVvdEOub3wU1ll+/crDhxXHe8Bzm6Gdd8Big5b0mJJmwG0LKQLS8SHlJo9cb5pR6GLu3A0VTANiHWEDNApndqWlYoXqbjXeJbZFMEKEsnPUV/VGLoIDWI8g3xgvh615G/P50D83lIhoOYm0AaEZ8qoU3VZ1eTy0bpesfc41PjC4mT9mX7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR08MB8437
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 WA1PEPF00009B38.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	4d759f43-862d-45df-37a4-08df0a736077
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|23010399003|36860700016|376014|14060799003|1800799024|35042699022|10067099003|22082099003|11063799006|4143699003|56012099006|6133799003|18002099003;
X-Microsoft-Antispam-Message-Info:
	OmOiXdMNWMkyGcHS/OPF4gQfEHwJJIt8k2aoQ8MFU009rpGY+wZc4RpePU9eHehGo8QqvaIBGlH0v9U4u6r1DIFtsorZXzAkR82bGZTJB7gP7H7ANLinVpgKg5ul7trX7B3pYAWAFIDuQvZjoGi3CUM39GIuLUqzJr6O7wOQOdY5x8YeAwYqQyGVzyTwokcPXD0ab4ghpsgzaib3FOidxNbRpW0SmbxKe3WDt6hKaa3a5whVwHNXYdpzDpQy/7bT/esSQYMhuXZSpgV+oX+Q+Kga88oWJKcXhhCYDO3HXHLptvfocXYI/Eu+ayIduVyJmHXKwQV4ikQE/KcGUazzEifDrNE2X4bZiiSRn35SAhqss9a2/FfaQZO7rK62xgqK4C3Bo+tC4RyjMYX2AkeMJ4ZteSo4RpoDTvmcU0IuF16U2dnEkhAXOxPltezwfpVvr1LKPE9tRRTcCqSsfOF/c4cYWoSmL88hH0obxqScccP3QeIrGxxg4xYBuSnBxkjnAf812tbpcfQgsN6f6tcAaq3w5bWWiJ682VHfMmDDv8/VxfSquCnbGfMGnnqZEIGflOHhdqqj5rO2nT4IetE/KGw+LKS8dCZscMuPL+E0NY++57uaeWcoX8tSF3yVtVh5WW37y0kW8Yr2cTtmRIXefdcXcKcizPUn1+VEDaSKj8k=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(23010399003)(36860700016)(376014)(14060799003)(1800799024)(35042699022)(10067099003)(22082099003)(11063799006)(4143699003)(56012099006)(6133799003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	OBtJRc6e6/VbxrW3/lMSV16Nx3dUT8ANVixJnR/MMpE1peWVzuyRLVVnp4ok48rrC5LJwi7lt5AEDkXM3X7DBdZBNlWWCNlOaKNr6PPYjDbpqrv4Z9qkdyi2B9Vu2bas5QMyVB3ergDmko2Zu4QVTnfp7YL5XvrGktvPHlsA2JL2xPzkTg24Hqh7AgVjbBQLNZsT1bzq7l2CEUFcHkQqxsWYbPVx6ztK/n8J0+EArSEDe9xLWVGp2fAaSfzmeD3vob8j4luqr2o9gbrW0BEU4tDLj6afhcOJTmKLcKQtWlLObsG+MYBBNYankyOOogd5bwCt/FumDyYsmS8QYMPgyah/Qjn4H8d4WJHKqtlCJnojm7DHK8RzOhbaIKLCRUQtcGhOfra43h/lkO08paE+cXv6n4uHo4Kb0QW55Yw9SQtSGJs8vs1BzFtGAEQYLPsE
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2026 10:58:29.6718
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 26e51356-327c-4b5a-c988-08df0a73744f
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	WA1PEPF00009B38.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR08MB5811

T24gRnJpLCAyMDI2LTA4LTA3IGF0IDE3OjU2ICswMDAwLCBzYXNoaWtvLWJvdEBrZXJuZWwub3Jn
IHdyb3RlOg0KPiBUaGFuayB5b3UgZm9yIHlvdXIgY29udHJpYnV0aW9uISBTYXNoaWtvIEFJIHJl
dmlldyBmb3VuZCAyIHBvdGVudGlhbA0KPiBpc3N1ZShzKSB0byBjb25zaWRlcjoNCj4gLSBbTWVk
aXVtXSBUaGUgVkdJQ3Y1IHNwYXJzZSB2Q1BVIElEcyB0ZXN0IHVzZXMgYW4gb3V0LW9mLWJvdW5k
cyB2Q1BVDQo+IElEIG9mIDUxMiB0byB2ZXJpZnkgR0lDdjUgVlBFIElEIHZhbGlkYXRpb24sIGJ1
dCBLVk0gY29yZSBnbG9iYWxseQ0KPiByZWplY3RzIElEcyA+PSA1MTIsIG1ha2luZyB0aGUgdGVz
dCBhIGZhbHNlIHBvc2l0aXZlLg0KPiAtIFtNZWRpdW1dIFRoZSBWR0lDdjUgc3BhcnNlIHZDUFUg
SURzIHRlc3QgaGFyZGNvZGVzIGEgdkNQVSBJRCBvZiAxNywNCj4gd2hpY2ggd2lsbCBjYXVzZSBz
cHVyaW91cyB0ZXN0IGZhaWx1cmVzIG9uIGhhcmR3YXJlIHRoYXQgc3VwcG9ydHMgMTYNCj4gb3Ig
ZmV3ZXIgVlBFcyBwZXIgVk0uDQo+IC0tDQo+IA0KPiAtLS0gUGF0Y2ggWzQ5XTogW1BBVENIIHY1
IDQ5LzQ5XSBLVk06IHNlbGZ0ZXN0czogQWRkIFZHSUN2NSBzcGFyc2UNCj4gdkNQVSBJRHMgdGVz
dCAtLS0NCj4gY29tbWl0IDI1M2RiNWZjYmQxNTQ4ZTNlYjBlODRlNjVlY2U0Y2E1NzQ3ZTUwYzIN
Cj4gQXV0aG9yOiBTYXNjaGEgQmlzY2hvZmYgPFNhc2NoYS5CaXNjaG9mZkBhcm0uY29tPg0KPiAN
Cj4gS1ZNOiBzZWxmdGVzdHM6IEFkZCBWR0lDdjUgc3BhcnNlIHZDUFUgSURzIHRlc3QNCj4gDQo+
IEdJQ3Y1IHVzZXMgdGhlIHVzZXJzcGFjZS1wcm92aWRlZCB2Q1BVIElEIGFzIHRoZSBWUEUgSUQu
IFRoaXMgbXVzdA0KPiB3b3JrIHdoZW4gdkNQVSBJRHMgYXJlIHNwYXJzZSBhbmQgZGlmZmVyIGZy
b20gdGhlIGRlbnNlIGludGVybmFsIHZDUFUNCj4gaW5kZXguDQo+IA0KPiBBZGQgYSB0ZXN0IHRo
YXQgY3JlYXRlcyB2Q1BVcyB3aXRoIElEcyAxNyBhbmQgMywgdmVyaWZpZXMgdGhhdCBhIHZDUFUN
Cj4gd2l0aCBJRCA1MTIgaXMgcmVqZWN0ZWQgYWZ0ZXIgYSBHSUN2NSBoYXMgYmVlbiBjcmVhdGVk
LCBhbmQgcnVucyBib3RoDQo+IHZDUFVzIHRvIGNoZWNrIHRoYXQgSUNDX0lBRkZJRFJfRUwxIHJl
cG9ydHMgdGhlIGNvcnJlY3QgVlBFIElEcyBvbg0KPiBlYWNoLg0KPiANCj4gPiBkaWZmIC0tZ2l0
IGEvdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMva3ZtL2FybTY0L3ZnaWNfdjUuYw0KPiA+IGIvdG9v
bHMvdGVzdGluZy9zZWxmdGVzdHMva3ZtL2FybTY0L3ZnaWNfdjUuYw0KPiA+IGluZGV4IDQ3ZTE0
N2JjMTRiODcuLjNlZWYyZDJkYTU5NWYgMTAwNjQ0DQo+ID4gLS0tIGEvdG9vbHMvdGVzdGluZy9z
ZWxmdGVzdHMva3ZtL2FybTY0L3ZnaWNfdjUuYw0KPiA+ICsrKyBiL3Rvb2xzL3Rlc3Rpbmcvc2Vs
ZnRlc3RzL2t2bS9hcm02NC92Z2ljX3Y1LmMNCj4gPiBAQCAtMTQsNiArMTQsMTAgQEANCj4gDQo+
IFsgLi4uIF0NCj4gDQo+ID4gK3N0YXRpYyB2b2lkIHRlc3RfdmdpY192NV9zcGFyc2VfdmNwdV9p
ZHModm9pZCkNCj4gPiArew0KPiA+ICsJc3RydWN0IGt2bV92Y3B1ICp2Y3B1c1tWR0lDX1Y1X1NQ
QVJTRV9OUl9WQ1BVU107DQo+ID4gKwljb25zdCB1MzIgdmNwdV9pZHNbVkdJQ19WNV9TUEFSU0Vf
TlJfVkNQVVNdID0gew0KPiA+ICsJCVZHSUNfVjVfU1BBUlNFX1ZDUFUwX0lELA0KPiA+ICsJCVZH
SUNfVjVfU1BBUlNFX1ZDUFUxX0lELA0KPiA+ICsJfTsNCj4gPiArCWludCByZXQsIGk7DQo+ID4g
KwlzdHJ1Y3QgdWNhbGwgdWM7DQo+ID4gKwlzdHJ1Y3Qgdm1fZ2ljIHY7DQo+ID4gKwl1NjQgYXR0
cjsNCj4gPiArDQo+ID4gKwl2LmdpY19kZXZfdHlwZSA9IEtWTV9ERVZfVFlQRV9BUk1fVkdJQ19W
NTsNCj4gPiArCXYudm0gPSBfX3ZtX2NyZWF0ZShWTV9TSEFQRV9ERUZBVUxULA0KPiA+IFZHSUNf
VjVfU1BBUlNFX05SX1ZDUFVTLCAwKTsNCj4gPiArCXYuZ2ljX2ZkID0ga3ZtX2NyZWF0ZV9kZXZp
Y2Uodi52bSwgdi5naWNfZGV2X3R5cGUpOw0KPiA+ICsNCj4gPiArCS8qDQo+ID4gKwkgKiBBIEdJ
Q3Y1IFZNIGNhbm5vdCBjcmVhdGUgYSB2Q1BVIG91dHNpZGUgdGhlIFZQRSBJRA0KPiA+IHJhbmdl
LiBXZSd2ZQ0KPiA+ICsJICogYWxyZWFkeSBjcmVhdGVkIGEgR0lDdjUsIHNvIGl0IHNob3VsZCBy
ZWplY3QgVkNQVQ0KPiA+IGNyZWF0aW9uLg0KPiA+ICsJICovDQo+ID4gKwlyZXQgPSBfX3ZtX2lv
Y3RsKHYudm0sIEtWTV9DUkVBVEVfVkNQVSwNCj4gPiArCQkJICh2b2lkICopKHVuc2lnbmVkDQo+
ID4gbG9uZylWR0lDX1Y1X1NQQVJTRV9UT09fQklHX0lEKTsNCj4gPiArCVRFU1RfQVNTRVJUKHJl
dCA8IDAgJiYgZXJybm8gPT0gRUlOVkFMLA0KPiA+ICsJCcKgwqDCoCAiR0lDdjUgYWNjZXB0ZWQg
dkNQVSBJRCAldSIsDQo+ID4gVkdJQ19WNV9TUEFSU0VfVE9PX0JJR19JRCk7DQo+IA0KPiBbU2V2
ZXJpdHk6IE1lZGl1bV0NCj4gV2lsbCB0aGlzIHRlc3QgYWN0dWFsbHkgdmVyaWZ5IHRoZSBHSUN2
NSB2YWxpZGF0aW9uIGxvZ2ljIGFzDQo+IGludGVuZGVkPw0KPiANCj4gVGhlIHRlc3QgdW5jb25k
aXRpb25hbGx5IGNhbGxzIEtWTV9DUkVBVEVfVkNQVSB3aXRoDQo+IFZHSUNfVjVfU1BBUlNFX1RP
T19CSUdfSUQNCj4gKHdoaWNoIGlzIDUxMikuIFRoZSBLVk0gY29yZSdzIGt2bV92bV9pb2N0bF9j
cmVhdGVfdmNwdSgpIHdpbGwNCj4gaW1tZWRpYXRlbHkNCj4gcmV0dXJuIC1FSU5WQUwgYmVjYXVz
ZSB0aGUgSUQgaXMgPj0gS1ZNX01BWF9WQ1BVX0lEUyAod2hpY2ggZGVmYXVsdHMNCj4gdG8gNTEy
DQo+IG9uIEFSTTY0KS4NCj4gDQo+IFRoaXMgaGFwcGVucyBiZWZvcmUgYW55IGFyY2hpdGVjdHVy
ZS1zcGVjaWZpYyBvciBHSUN2NSB2YWxpZGF0aW9uIGlzDQo+IHJlYWNoZWQsDQo+IHBvdGVudGlh
bGx5IG1ha2luZyB0aGlzIHRlc3QgYSBmYWxzZSBwb3NpdGl2ZS4NCg0KQWgsIHllcy4gVGhpcyB0
ZXN0IGlzIHVzZWxlc3MuIEkndmUgZHJvcHBlZCBpdC4NCg0KPiANCj4gPiArDQo+ID4gKwkvKiBO
b3csIGNyZWF0ZSB0d28gdkNQVXMgd2l0aCBsZWdhbCwgYWxiZWl0IHNwYXJzZSwgSURzICovDQo+
ID4gKwlmb3IgKGkgPSAwOyBpIDwgQVJSQVlfU0laRSh2Y3B1cyk7IGkrKykgew0KPiA+ICsJCXZj
cHVzW2ldID0gdm1fdmNwdV9hZGQodi52bSwgdmNwdV9pZHNbaV0sDQo+ID4gZ3Vlc3RfaWFmZmlk
X2NvZGUpOw0KPiA+ICsJCVRFU1RfQVNTRVJUKHZjcHVzW2ldLCAiRmFpbGVkIHRvIGNyZWF0ZSB2
Q1BVICV1IiwNCj4gPiB2Y3B1X2lkc1tpXSk7DQo+IA0KPiBbU2V2ZXJpdHk6IE1lZGl1bV0NCj4g
Q291bGQgaGFyZGNvZGluZyB0aGUgdkNQVSBJRCB0byAxNyBjYXVzZSBzcHVyaW91cyB0ZXN0IGZh
aWx1cmVzIG9uDQo+IHNvbWUNCj4gaGFyZHdhcmU/DQo+IA0KPiBUaGUgdGVzdCB1bmNvbmRpdGlv
bmFsbHkgYWRkcyBhIHZDUFUgd2l0aCBJRCAxNw0KPiAoVkdJQ19WNV9TUEFSU0VfVkNQVTBfSUQp
Lg0KPiBJbiBLVk0gQVJNNjQsIGEgVk0ncyBtYXhfdmNwdXMgaXMgYm91bmRlZCBieSBoYXJkd2Fy
ZSBjYXBhYmlsaXRpZXMNCj4gKGZvcg0KPiBleGFtcGxlLCBHSUNWNV9JUlNfSURSNF9WUEVfSURf
QklUUykuDQo+IA0KPiBJZiB0aGUgaGFyZHdhcmUgc3VwcG9ydHMgMTYgb3IgZmV3ZXIgVlBFcyBw
ZXIgVk0sIHRoZSBLVk1fQ1JFQVRFX1ZDUFUNCj4gaW9jdGwNCj4gZm9yIElEIDE3IHdpbGwgYmUg
bGVnaXRpbWF0ZWx5IHJlamVjdGVkIGJ5IEtWTSB3aXRoIC1FSU5WQUwsIHdoaWNoDQo+IHRyaWdn
ZXJzDQo+IHRoaXMgVEVTVF9BU1NFUlQgYW5kIGZhaWxzIHRoZSB0ZXN0Lg0KDQpUaGUgaGFyZHdh
cmUgc3VwcG9ydHMgYXQgbGVhc3QgMjU2IFZQRXMgcGVyIFZNLiBBbnl0aGluZyBsZXNzIGlzIG5v
dA0KYWxsb3dlZCBhcyBwZXIgdGhlIHNwZWNpZmljYXRpb24uIEhlbmNlLCB0aGlzIG9uZSBpcyBu
b3QgYW4gaXNzdWUuDQoNCj4gDQo+ID4gKwl9DQo+IA0KDQpUaGFua3MsDQpTYXNjaGENCg==
