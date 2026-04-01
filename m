Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011019.outbound.protection.outlook.com [52.101.70.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C210C316192
	for <kvmarm@lists.linux.dev>; Wed,  1 Apr 2026 08:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.19
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775031758; cv=fail; b=twdc6KgXMkIJz8LWkg8/sAr3QdaCuORXJbyVQb3FmpzdzV3AOVIjRzx/57aBbnVsBvqXX3HTyERhNzVDgfO9ZHkiNPKmfjbHRPKtUoXLW64YlXvGSBD91VishhaqE+oGQddr0rZGQUTTLj+BPfkhx+OExi0jHezdyF3DaZ9b9HE=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775031758; c=relaxed/simple;
	bh=yIWOI6eE4782PYowHDAJgNygpa+npFIcPyhMwWz0BFQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=OUGKuMjnbMejmgEpjyN1HCROf7ER9erRPOH4Xe1Akb82WnHpuOu9bbI03GXCDUFl2pSpYts5pEvwy77gRfLNt64TOQWmCVGkxNOUgVUMPxol4BGOMNnVRxSf69RpLtiNZDBEyxwZAV8mNjTQStAL1sR8Lif9Z4/zTLzbEHjpWvM=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Kdr0svUg; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Kdr0svUg; arc=fail smtp.client-ip=52.101.70.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Kdr0svUg";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Kdr0svUg"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=H1oME8aoVA4j2TvW2wgE9CODVRG3xaLrUcYcR3sYPBfMtQv7McyYX8a0F8W5aNqBOGDbskP8QIBpKnmLWucEPZr+8IE7M+xupG+s8B2ZInNaS7Ppjz/RkcSnSTZS/YeKqnA4iDNuG6n2ky7+jnFo7i9Y1St7HDsm9R/NNeWWSBMHVdFdjl2IesvPeEWBaEFbi/euGVwesGk/oeQx+xS/kt4SSTPx1ooI7laYgTOrm7WmAmo2EPLzQL3QyTllz1lob5vhFZXIm7uRBMbWyNcyFfO1Z7F432MvcaYa6yRNq5EObg6GuVNtBOsBt4TdGr8UbjA+tteT4vI7Vr8XeaRnOA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yIWOI6eE4782PYowHDAJgNygpa+npFIcPyhMwWz0BFQ=;
 b=t7FBPiMBN5LPvTvVMg7lErP6QO+CHsCmLLVyTy6wuXN+AA5R5oQ+94I/sTjOUT3vHxuOjKxH6FX0Ywd/U3xG4Ji7QTa3eEu06E05nZZ+zA0ZH6HM8fFdW/suPUc0+nJvhkUyUo0xcu0hvSEhA7t/aHSQP7P/1nA73JohT1Uex1qY2Ti66UeUs6eL6L3CwRtdQ0ljgWBcYMNLhw+J65fkFoiZMi7s6RIXsuviGCo9Wax0CVUPjvl5BsBhtCop106y888Rbp6XNvo1jK5S+73qi36AmrNWF+Rs/oCFBBIxjcPM59zdoEx2p7wJqU6SELbi31s0gc9izenF4dIXWeFHdQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yIWOI6eE4782PYowHDAJgNygpa+npFIcPyhMwWz0BFQ=;
 b=Kdr0svUg1nmZPi2inCDg5DXKz+CJtXDFg11xB8VWOp0xI/A9w8tbgqkzFKRDve5f8FWOBIJlk6hco3LsDKRoWrG8MkEpQRBQnfctMVb3ogE7tFhmsKuJhFck8qP9jBBXdJY/Mte1d3Kw3OJckOx4rOcpCn+uYiK5pRodyUQbStc=
Received: from CWLP265CA0536.GBRP265.PROD.OUTLOOK.COM (2603:10a6:400:18d::18)
 by DU0PR08MB7518.eurprd08.prod.outlook.com (2603:10a6:10:312::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.17; Wed, 1 Apr
 2026 08:22:28 +0000
Received: from AM4PEPF00025F98.EURPRD83.prod.outlook.com
 (2603:10a6:400:18d:cafe::51) by CWLP265CA0536.outlook.office365.com
 (2603:10a6:400:18d::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9745.30 via Frontend Transport; Wed,
 1 Apr 2026 08:22:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM4PEPF00025F98.mail.protection.outlook.com (10.167.16.7) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9791.0 via
 Frontend Transport; Wed, 1 Apr 2026 08:22:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gz8LxhgbuI/89zgFpIsE+XkYUyWUqI3gV7euKfWCpyx0V07rfDTkl06lxwujfHTh1zk3AG5/zKbk9DXJajNHKU21q8rk0FhqM5UCMSa0n61YCTmY+U8LgkIqhDO42zbIEAogE8BDJd+U4Wc9AxIpn2Dy3YTYyUHbTOqJzfliYmeZkz0aXNs8e30YLJZdz5jSh16jxrqL+JbK/9A4JOnX3j0vX3xohW2KQH/rG4QMZoD1O781w7e4rYmpjlTW7qBulb66TUi7jMlR04qnoBOrEMIX6HTlgkk9rC1VY/ewAM9LFMlsJtCAjbgTe3IGCMKdana0S8B6wKFoOJDz50kn8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yIWOI6eE4782PYowHDAJgNygpa+npFIcPyhMwWz0BFQ=;
 b=Txj08RWGg04kfgr5N6Mv+LiIiikInJ3CxbYUQPwnwLo5IsyRZ8vxB89OBUNg5K0WlFb+w7syQZyRSkHIpvQ+0aGG0dER+psnVJ7XUBaaZJGCVMdgA6Hmi9SkdEc+MEFJitTWqQqO+0XxRDp5fvgWltS+S9GxDJGPXrmTi+QVfsBgj3BRVTx/NYqa6/BrXz80jcGJesxXqMfKRomn36ObWYjweHMSh51/uI4n+IJ5OZQvncwgkxYMpJXYgXLvH/Oymrolj7raQUCsaoBU3/iOLNr8zbXa0FbQjqXivsGaPMUHNLomfTnVqKYfwKP/beHzLoZv+AQLMStx6zVazioM8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yIWOI6eE4782PYowHDAJgNygpa+npFIcPyhMwWz0BFQ=;
 b=Kdr0svUg1nmZPi2inCDg5DXKz+CJtXDFg11xB8VWOp0xI/A9w8tbgqkzFKRDve5f8FWOBIJlk6hco3LsDKRoWrG8MkEpQRBQnfctMVb3ogE7tFhmsKuJhFck8qP9jBBXdJY/Mte1d3Kw3OJckOx4rOcpCn+uYiK5pRodyUQbStc=
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com (2603:10a6:20b:504::10)
 by AS8PR08MB8442.eurprd08.prod.outlook.com (2603:10a6:20b:568::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.15; Wed, 1 Apr
 2026 08:21:22 +0000
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27]) by AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27%6]) with mapi id 15.20.9769.014; Wed, 1 Apr 2026
 08:21:22 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "maz@kernel.org" <maz@kernel.org>
CC: "yuzenghui@huawei.com" <yuzenghui@huawei.com>, "broonie@kernel.org"
	<broonie@kernel.org>, Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, "oupton@kernel.org"
	<oupton@kernel.org>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, Joey Gouly <Joey.Gouly@arm.com>, nd <nd@arm.com>
Subject: Re: [PATCH 12/15] KVM: arm64: Remove evaluation of timer state in
 kvm_cpu_has_pending_timer()
Thread-Topic: [PATCH 12/15] KVM: arm64: Remove evaluation of timer state in
 kvm_cpu_has_pending_timer()
Thread-Index: AQHcvTY2WDg7wXCK502ordwnLxCEDrXIz/mAgAAWDICAAQCZgA==
Date: Wed, 1 Apr 2026 08:21:22 +0000
Message-ID: <5c516315ae72949b2dcfa00d9249d635a7d400dc.camel@arm.com>
References: <20260326153530.3981879-1-maz@kernel.org>
	 <20260326153530.3981879-13-maz@kernel.org>
	 <2779510cb9795d1c934d2122478485847930358a.camel@arm.com>
	 <868qb83pa6.wl-maz@kernel.org>
In-Reply-To: <868qb83pa6.wl-maz@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AS4PR08MB8241:EE_|AS8PR08MB8442:EE_|AM4PEPF00025F98:EE_|DU0PR08MB7518:EE_
X-MS-Office365-Filtering-Correlation-Id: 8ddc5e28-7ba1-4dcb-2a16-08de8fc7cee4
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|38070700021|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info-Original:
 9rdP+JbWPxP4bgdVrJH+sm5ApZZ5I4k/QKeisH8nfjhkSLVDA0kGiYkpPQ5sVmR6h10HDOWuMGSc8aXUte76qb7MydO3SHgCSvvRLO7aKoTErDW87wx+VPMMv5KLkVVkSSwJWsAVaeKefvVe52ii3I5tZv40Kem4KgnQ8l/pyXk3MHrPXqvSpHWGspymMD6NMb89QMPCANrJVUKbDL6Zy049R3oRSYAk02f/vsqk5SK4wHQrnB4oezQLB5aFCCl7bpS2H2sn8r8jHcx8qB31oyBwNH1tESVVhFXrKw8Jw7eG49Pab527NeUpIFzFJpNF5UrSspAH85E4MOR1xpm4kYYexleiQL/3GE+gRJP5IVvKG4EDofPaJCgqua1rwKJuCD4HBTAFQT0+oN/SGzorrOJE7yvEJOaTCyMp7cb+xQsNvoUXAdelcvOfyiXEYsYZrJ60ME+PKm0oqGk9dSaVTT8tR9JjT4G54lTMxzE6MMz6ObdZlY7rJXmDdmMaa2oazx+t6ListNsuheFCqYSVWN3e1cazpYQm5I8SPTcRiVaVVSjTj3il5+jgcWW/I/hB3zOnN/DLxFifL8/sHYP/+MVJVmnKpAV18yh8XlmcOKM9zOOKxNBgcpEwjfzYyKvoIMLvip8CcjPyIBal0vd/cEtLvytTDAaSHDqL5ppvOZ800zpdbQFBVdfHxIyCo36lYNxF9Dves2TN6yMddA7x52gRg+aBzQ4+K2VZqjvKnw8=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS4PR08MB8241.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700021)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <C355D36707DD0C4488532AAB84E1941E@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 jEuA/mdP3QERsVRY3FSkAVrH9/ot3ug3yAZAtczf4O/Hb/yBjJn4xoPDmcQF29N6TfFVrW+liBHMlXrxyEeoxezbvKoPNJxVq4oi/fbsubHxY5DMUlkVX0UVy/RLb/kHU6ceYbY4kPYvyWy0QXuIN3zfttLYQSH5mRkzg+lM1JczA0wh/T1yeK0dnhhlcDMzufNbmjkdPiU93VynajBqRUP0AbAaXzUBV8MSfAlzfH/0kDY/gX5V6CrIZOXPI7xDMZnbb/HzUlgpa+9mkWNhaQ5aNtf1X+pqBrPjz3hZ6E9imzEXm9n29bRI7tPZ6Qn4sVayGpLkQi4uirfAOq/TLg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB8442
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM4PEPF00025F98.EURPRD83.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	2c526c6e-f71b-4f79-ef29-08de8fc7a8c5
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|36860700016|376014|1800799024|35042699022|82310400026|13003099007|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	chwqBH47LTYhMd00sKzApuQDuC2KZch7YQXbY3exgkpEPArcUrTSgUHCf+7nSIGBj61LdN1fLuqYkAR1x1CZcLHHH4OcOKGoozWOH33KliULzcegGOMLsMUmUFVdN6pJJRGseyr7Eh6OY7b/cQNscnWaTgS2Kj0+33l+CXGxG+ELsDbPs9oQLA7SxPbt2uXnieFst69LujNfqkzwt2ATYXhL9lvyyhu5NV1BxJIoq+VIWBGNGJhxSKXicYBuwRKnlpIBeW759w0esOEdBO/6frJIArCs/BRmCwyBJcC3cNsc+N2LBltqontIwAu5C8avP9CX+3Ba61sPhJaaBgDGrU4Jq5/sKuH7R9l9UWYZuKebeC/ay1OGiCchYNWmsEge6/6OAV/rvBNHar4cZKmWSX1xfX4iVuYn+mXwhAjMepjrVuJfz9rVC1eqgZEAW0IKftEeibOAujqBGmKTIFjqY824okmxeP4032meNlVu75eAEWEXR+UqPp0SW3ay+MRy96HuZqH7pcivO+e5llVaGmk8X0Y3oG8YYjb1VII1j5Tnv2EmBaEl0Y2pc+IIcCBp8mNqNWMAA/M3yD4X2Vda3qasUExlmrOL2gjMO2FXzkkvLxSCuvmh84Al5XaJgh6XczFWjlSbPIB6d9jTqMcY9hXD1pRNZcIUtT/0fDruZjKaWkRpFaATbbTu4w0RzQlB+lxKSB6BdBFrISp2rYhxiPVOIsRi77ulUIiLJfE+VFI=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(36860700016)(376014)(1800799024)(35042699022)(82310400026)(13003099007)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Mqt7UDPRBv+o2thc3edpCITtPvmdaf7SZPm2PdQi5QRi97xPnfdRapOHGSvD3C9etXo6XsPEhJWoCsGlGKIkMHutlsM67oODPdNN7js/gFLBgFcSDECi4BPMi5T1DLVQ3Z0asoIrLlqKghRsyMCaoZ4XV3FkEPYjz9kyW1HfbEBgX97q5zD/n2bGAYjwIZISixW6rzJuVGivgJ3I523iFqITUCecvPEZSydRgOWGydQe53+SdyvlNzbVtsXqWFGyZ3xL6uALbEISy2/D6Y6jicsD5gjRp9syc63N/aPXNJVhkq2a0HgZxhiu/7ZlTIa4YrKISVvAB5u7QKehUdnRfSTJFWEIEvfAtKmGCzXl4d0GlJ4YFp8k2n9a5zg0TGBms7IG3yJA4LW4+ydJd10jPecYg17zk+IYMHm/7ckAO3i6QWS/UeWykWT10NNY57nS
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2026 08:22:26.4367
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ddc5e28-7ba1-4dcb-2a16-08de8fc7cee4
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM4PEPF00025F98.EURPRD83.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB7518

T24gVHVlLCAyMDI2LTAzLTMxIGF0IDE4OjAyICswMTAwLCBNYXJjIFp5bmdpZXIgd3JvdGU6DQo+
IE9uIFR1ZSwgMzEgTWFyIDIwMjYgMTY6NDQ6MDQgKzAxMDAsDQo+IFNhc2NoYSBCaXNjaG9mZiA8
U2FzY2hhLkJpc2Nob2ZmQGFybS5jb20+IHdyb3RlOg0KPiA+IA0KPiA+IE9uIFRodSwgMjAyNi0w
My0yNiBhdCAxNTozNSArMDAwMCwgTWFyYyBaeW5naWVyIHdyb3RlOg0KPiA+ID4gVGhlIHZnaWMt
djUgY29kZSBhZGRlZCBzb21lIGV2YWx1YXRpb25zIG9mIHRoZSB0aW1lcnMgaW4gYSBoZWxwZXIN
Cj4gPiA+IGZ1bnRpb24NCj4gPiA+IChrdm1fY3B1X2hhc19wZW5kaW5nX3RpbWVyKCkpIHRoYXQg
aXMgY2FsbGVkIHRvIGRldGVybWluZSB3aGV0aGVyDQo+ID4gPiB0aGUgdmNwdSBjYW4gd2FrZS11
cC4NCj4gPiA+IA0KPiA+ID4gQnV0IGxvb2tpbmcgYXQgdGhlIHRpbWVyIHRoZXJlIGlzIHdyb25n
Og0KPiA+ID4gDQo+ID4gPiAtIHdlIHdhbnQgdG8gc2VlIHRpbWVycyB0aGF0IGFyZSBzaWduYWxs
aW5nIGFuIGludGVycnVwdCB0byB0aGUNCj4gPiA+IMKgIHZjcHUsIGFuZCBub3QganVzdCB0aGF0
IGhhdmUgYSBwZW5kaW5nIGludGVycnVwdA0KPiA+ID4gDQo+ID4gPiAtIHdlIGFscmVhZHkgaGF2
ZSBrdm1fYXJjaF92Y3B1X3J1bm5hYmxlKCkgdGhhdCBldmFsdWF0ZXMgdGhlDQo+ID4gPiDCoCBz
dGF0ZSBvZiBpbnRlcnJ1cHRzDQo+ID4gPiANCj4gPiA+IC0ga3ZtX2NwdV9oYXNfcGVuZGluZ190
aW1lcigpIHJlYWxseSBpcyBhYm91dCBXRklULCBhcyB0aGUNCj4gPiA+IHRpbWVvdXQNCj4gPiA+
IMKgIGRvZXMgbm90IGdlbmVyYXRlIGFuIGludGVycnVwdCwgYW5kIGlzIHRoZXJlZm9yZSBkaXN0
aW5jdCBmcm9tDQo+ID4gPiDCoCB0aGUgcG9pbnQgYWJvdmUNCj4gPiA+IA0KPiA+ID4gQXMgYSBj
b25zZXF1ZW5jZSwgcmV2ZXJ0IHRoZXNlIGNoYW5nZXMuDQo+ID4gPiANCj4gPiA+IEZpeGVzOiA5
NDkxYzYzYjZjZDdiICgiS1ZNOiBhcm02NDogZ2ljLXY1OiBFbmxpZ2h0ZW4gYXJjaCB0aW1lcg0K
PiA+ID4gZm9yDQo+ID4gPiBHSUN2NSIpDQo+ID4gPiBMaW5rOg0KPiA+ID4gaHR0cHM6Ly9zYXNo
aWtvLmRldi8jL3BhdGNoc2V0LzIwMjYwMzE5MTU0OTM3LjM2MTk1MjAtMS1zYXNjaGEuYmlzY2hv
ZmYlNDBhcm0uY29tDQo+ID4gPiBTaWduZWQtb2ZmLWJ5OiBNYXJjIFp5bmdpZXIgPG1hekBrZXJu
ZWwub3JnPg0KPiA+ID4gLS0tDQo+ID4gPiDCoGFyY2gvYXJtNjQva3ZtL2FyY2hfdGltZXIuYyB8
IDYgKy0tLS0tDQo+ID4gPiDCoDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgNSBkZWxl
dGlvbnMoLSkNCj4gPiA+IA0KPiA+ID4gZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQva3ZtL2FyY2hf
dGltZXIuYw0KPiA+ID4gYi9hcmNoL2FybTY0L2t2bS9hcmNoX3RpbWVyLmMNCj4gPiA+IGluZGV4
IDM3Mjc5Zjg3NDg2OTUuLjY2MDhjNDdkMWY2MjggMTAwNjQ0DQo+ID4gPiAtLS0gYS9hcmNoL2Fy
bTY0L2t2bS9hcmNoX3RpbWVyLmMNCj4gPiA+ICsrKyBiL2FyY2gvYXJtNjQva3ZtL2FyY2hfdGlt
ZXIuYw0KPiA+ID4gQEAgLTQwMiwxMSArNDAyLDcgQEAgc3RhdGljIGJvb2wga3ZtX3RpbWVyX3No
b3VsZF9maXJlKHN0cnVjdA0KPiA+ID4gYXJjaF90aW1lcl9jb250ZXh0ICp0aW1lcl9jdHgpDQo+
ID4gPiDCoA0KPiA+ID4gwqBpbnQga3ZtX2NwdV9oYXNfcGVuZGluZ190aW1lcihzdHJ1Y3Qga3Zt
X3ZjcHUgKnZjcHUpDQo+ID4gPiDCoHsNCj4gPiA+IC0Jc3RydWN0IGFyY2hfdGltZXJfY29udGV4
dCAqdnRpbWVyID0gdmNwdV92dGltZXIodmNwdSk7DQo+ID4gPiAtCXN0cnVjdCBhcmNoX3RpbWVy
X2NvbnRleHQgKnB0aW1lciA9IHZjcHVfcHRpbWVyKHZjcHUpOw0KPiA+ID4gLQ0KPiA+ID4gLQly
ZXR1cm4ga3ZtX3RpbWVyX3Nob3VsZF9maXJlKHZ0aW1lcikgfHwNCj4gPiA+IGt2bV90aW1lcl9z
aG91bGRfZmlyZShwdGltZXIpIHx8DQo+ID4gPiAtCcKgwqDCoMKgwqDCoCAodmNwdV9oYXNfd2Zp
dF9hY3RpdmUodmNwdSkgJiYNCj4gPiA+IHdmaXRfZGVsYXlfbnModmNwdSkgPT0NCj4gPiA+IDAp
Ow0KPiA+ID4gKwlyZXR1cm4gdmNwdV9oYXNfd2ZpdF9hY3RpdmUodmNwdSkgJiYgd2ZpdF9kZWxh
eV9ucyh2Y3B1KQ0KPiA+ID4gPT0NCj4gPiA+IDA7DQo+ID4gPiDCoH0NCj4gPiA+IMKgDQo+ID4g
PiDCoC8qDQo+ID4gDQo+ID4gSGkgTWFyYywNCj4gPiANCj4gPiBJdCBhcHBlYXJzIHRoYXQgSSdk
IG1pc3VuZGVyc3Rvb2QgdGhlIGludGVudCBvZiB0aGlzIGZ1bmN0aW9uIHdoZW4NCj4gPiBJDQo+
ID4gb3JpZ2luYWxseSB3cm90ZSB0aGlzIGJpdCBjb2RlLiBUaGF0IGlzOiBJIGFncmVlIHRoYXQg
dGhlc2UgY2hlY2tzDQo+ID4gc2hvdWxkbid0IGJlIGhlcmUuDQo+ID4gDQo+ID4gSG93ZXZlciwg
c2FpZCBjaGVja3MgYXJlIG5lZWRlZCBzb21ld2hlcmUuIFdpdGggR0lDdjUsIHdlIGRpcmVjdGx5
DQo+ID4gaW5qZWN0IHRoZSB0aW1lciBzdGF0ZSAod2hlbiBwb3NzaWJsZSwgYXQgbGVhc3QpIHdo
aWNoIG1lYW5zIHRoYXQNCj4gPiB3ZQ0KPiA+IG5ldmVyIHNlZSB0aGUgdGltZXIgaW50ZXJydXB0
IGZpcmluZyBvbiB0aGUgaG9zdCwgYW5kIGRvbid0IHRyYWNrDQo+ID4gaWYgaXQNCj4gPiBpcyBw
ZW5kaW5nIG9yIG5vdCBpbiBzdHJ1Y3QgdmdpY19pcnEgYXMgdGhlIHBlbmRpbmcgc3RhdGUgaXMg
ZHJpdmVuDQo+ID4gYnkNCj4gPiB0aGUgaGFyZHdhcmUgaXRzZWxmLiBUaGUgcmVzdWx0IG9mIHRo
aXMgaXMgdGhhdCB3ZSBleHBsaWNpdGx5IG5lZWQNCj4gPiB0bw0KPiA+IGNoZWNrIGlmIHRoZSB0
aW1lciBpbnRlcnJ1cHQgd291bGQgYmUgcGVuZGluZyBpZiB0aGUgZ3Vlc3Qgd2VyZQ0KPiA+IHJ1
bm5pbmcNCj4gPiBzb21ld2hlcmUuDQo+ID4gDQo+ID4gSSd2ZSBydW4gd2l0aCB0aGlzIGNvbXBs
ZXRlIHNlcmllcyBhbmQgaGF2ZSB0ZXN0ZWQgdGhlIGZvbGxvd2luZw0KPiA+IGNoYW5nZS4gSXQg
aXMgc3VmZmljaWVudCB0byBjYXRjaCB0aGlzIGNhc2UsIGFuZCBkb2VzIGl0IGFzIHBhcnQgb2YN
Cj4gPiBjaGVja2luZyBpZiB0aGVyZSBhcmUgcGVuZGluZyBpbnRlcnJ1cHRzLCBpLmUuLCBhIG1v
cmUgYXBwcm9wcmlhdGUNCj4gPiBwbGFjZSBjYWxsZWQgdmlhIGt2bV9hcmNoX3ZjcHVfcnVubmFi
bGUoKS4gSXQgaXMgeWV0LWFub3RoZXIgR0lDdjUNCj4gPiBzcGVjaWFsIGNhc2UsIGhvd2V2ZXIu
IEknZCBsb3ZlIHRvIGhlYXIgeW91ciB0aG91Z2h0cy4NCj4gPiANCj4gPiBkaWZmIC0tZ2l0IGEv
YXJjaC9hcm02NC9rdm0vYXJjaF90aW1lci5jDQo+ID4gYi9hcmNoL2FybTY0L2t2bS9hcmNoX3Rp
bWVyLmMNCj4gPiBpbmRleCBjYmVhNGQ5ZWU5NTUyLi5mOGI5NTcyMTg1N2MzIDEwMDY0NA0KPiA+
IC0tLSBhL2FyY2gvYXJtNjQva3ZtL2FyY2hfdGltZXIuYw0KPiA+ICsrKyBiL2FyY2gvYXJtNjQv
a3ZtL2FyY2hfdGltZXIuYw0KPiA+IEBAIC00MDAsNiArNDAwLDE0IEBAIHN0YXRpYyBib29sIGt2
bV90aW1lcl9zaG91bGRfZmlyZShzdHJ1Y3QNCj4gPiBhcmNoX3RpbWVyX2NvbnRleHQgKnRpbWVy
X2N0eCkNCj4gPiDCoMKgwqDCoMKgwqDCoCByZXR1cm4gY3ZhbCA8PSBub3c7DQo+ID4gwqB9DQo+
ID4gwqANCj4gPiAraW50IGt2bV9jcHVfdGltZXJfc2hvdWxkX2ZpcmUoc3RydWN0IGt2bV92Y3B1
ICp2Y3B1KQ0KPiA+ICt7DQo+ID4gK8KgwqDCoMKgwqDCoCBzdHJ1Y3QgYXJjaF90aW1lcl9jb250
ZXh0ICp2dGltZXIgPSB2Y3B1X3Z0aW1lcih2Y3B1KTsNCj4gPiArwqDCoMKgwqDCoMKgIHN0cnVj
dCBhcmNoX3RpbWVyX2NvbnRleHQgKnB0aW1lciA9IHZjcHVfcHRpbWVyKHZjcHUpOw0KPiA+ICsN
Cj4gPiArwqDCoMKgwqDCoMKgIHJldHVybiBrdm1fdGltZXJfc2hvdWxkX2ZpcmUodnRpbWVyKSB8
fA0KPiA+IGt2bV90aW1lcl9zaG91bGRfZmlyZShwdGltZXIpOw0KPiA+ICt9DQo+ID4gKw0KPiA+
IMKgaW50IGt2bV9jcHVfaGFzX3BlbmRpbmdfdGltZXIoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KQ0K
PiA+IMKgew0KPiA+IMKgwqDCoMKgwqDCoMKgIHJldHVybiB2Y3B1X2hhc193Zml0X2FjdGl2ZSh2
Y3B1KSAmJiB3Zml0X2RlbGF5X25zKHZjcHUpID09DQo+ID4gMDsNCj4gPiBkaWZmIC0tZ2l0IGEv
YXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLmMNCj4gPiBiL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdp
Yy5jDQo+ID4gaW5kZXggNzY4MGNlZDkyZjcxNS4uZmZiOTFmNTM1ZWZlOCAxMDA2NDQNCj4gPiAt
LS0gYS9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMuYw0KPiA+ICsrKyBiL2FyY2gvYXJtNjQva3Zt
L3ZnaWMvdmdpYy5jDQo+ID4gQEAgLTEyMzgsNiArMTIzOCw5IEBAIGludCBrdm1fdmdpY192Y3B1
X3BlbmRpbmdfaXJxKHN0cnVjdCBrdm1fdmNwdQ0KPiA+ICp2Y3B1KQ0KPiA+IMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoCBpZiAoUkVBRF9PTkNFKHZjcHUtDQo+ID4gPmFyY2gudmdpY19j
cHUudmdpY192NS5naWN2NV92cGUuZGJfZmlyZWQpKQ0KPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcmV0dXJuIHRydWU7DQo+ID4gwqANCj4gPiArwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBpZiAoa3ZtX2NwdV90aW1lcl9zaG91bGRfZmlyZSh2
Y3B1KSkNCj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAg
cmV0dXJuIHRydWU7DQo+ID4gKw0KPiANCj4gVGhpcyB1bmZvcnR1bmF0ZWx5IHNlZW1zIHRvIHN1
ZmZlciBmcm9tIHRoZSBleGFjdCBzYW1lIHByb2JsZW06IHlvdQ0KPiBhcmUgZXZhbHVhdGluZyB0
aGUgb3V0cHV0IG9mIHRoZSB0aW1lciBpbmRlcGVuZGVudGx5IG9mIHRoZSBlbmFibGUNCj4gYml0
cyBnYXRpbmcgdGhlIHRpbWVyIGludGVycnVwdCBhdCB0aGUgR0lDIGxldmVsLg0KPiANCj4gV2l0
aCB0aGlzLCB5b3UgY2FuIGRpc2FibGUgdGhlIHRpbWVycyBhdCB0aGUgR0lDIGxldmVsLCBhcm0g
dGhlDQo+IHRpbWVycw0KPiBzbyB0aGF0IHRoZXkgYXJlIGluIGEgZmlyaW5nIHBvc2l0aW9uLCBh
bmQgZW50ZXIgV0ZJOiB0aGUgdmNwdSB3aWxsDQo+IGV4aXQgV0ZJIGltbWVkaWF0ZWx5LCB3aGlj
aCBpcyBub3QgdGhlIGV4cGVjdGVkIHJlc3VsdC4NCj4gDQo+IEknZCBzdWdnZXN0IHNvbWV0aGlu
ZyBsaWtlIHRoaXMgaW5zdGVhZCAoY29tcGlsZSB0ZXN0ZWQgb25seSk6DQo+IA0KPiBkaWZmIC0t
Z2l0IGEvYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLXY1LmMNCj4gYi9hcmNoL2FybTY0L2t2bS92
Z2ljL3ZnaWMtdjUuYw0KPiBpbmRleCA3NTM3MmJiZmI2YTZhLi5lN2QyM2QwNTE5ZThiIDEwMDY0
NA0KPiAtLS0gYS9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMtdjUuYw0KPiArKysgYi9hcmNoL2Fy
bTY0L2t2bS92Z2ljL3ZnaWMtdjUuYw0KPiBAQCAtMzY1LDkgKzM2NSwxMyBAQCBib29sIHZnaWNf
djVfaGFzX3BlbmRpbmdfcHBpKHN0cnVjdCBrdm1fdmNwdQ0KPiAqdmNwdSkNCj4gwqANCj4gwqAJ
CWlycSA9IHZnaWNfZ2V0X3ZjcHVfaXJxKHZjcHUsIGludGlkKTsNCj4gwqANCj4gLQkJc2NvcGVk
X2d1YXJkKHJhd19zcGlubG9ja19pcnFzYXZlLCAmaXJxLT5pcnFfbG9jaykNCj4gLQkJCWhhc19w
ZW5kaW5nID0gKGlycS0+ZW5hYmxlZCAmJg0KPiBpcnFfaXNfcGVuZGluZyhpcnEpICYmDQo+ICsJ
CXNjb3BlZF9ndWFyZChyYXdfc3BpbmxvY2tfaXJxc2F2ZSwgJmlycS0+aXJxX2xvY2spIHsNCj4g
KwkJCWJvb2wgcGVuZGluZzsNCj4gKw0KPiArCQkJcGVuZGluZyA9IGlycS0+aHcgPw0KPiB2Z2lj
X2dldF9waHlzX2xpbmVfbGV2ZWwoaXJxKSA6IGlycV9pc19wZW5kaW5nKGlycSk7DQo+ICsJCQlo
YXNfcGVuZGluZyA9IChpcnEtPmVuYWJsZWQgJiYgcGVuZGluZyAmJg0KPiDCoAkJCQnCoMKgwqDC
oMKgwqAgaXJxLT5wcmlvcml0eSA8DQo+IHByaW9yaXR5X21hc2spOw0KPiArCQl9DQo+IMKgDQo+
IMKgCQl2Z2ljX3B1dF9pcnEodmNwdS0+a3ZtLCBpcnEpOw0KPiDCoA0KDQpJJ3ZlIGp1c3QgdGVz
dGVkIHRoZSBhYm92ZSBhbmQgY2FuIGNvbmZpcm0gdGhhdCBpdCBkb2VzIHdvcmsgYXMNCmV4cGVj
dGVkLiBJdCBpbmRlZWQgbWFrZXMgYSBsb3QgbW9yZSBzZW5zZSB0aGFuIHdoYXQgSSdkIHN1Z2dl
c3RlZC4NCg0KVGhhbmtzLA0KU2FzY2hhDQoNCj4gDQo+IFRoYW5rcywNCj4gDQo+IAlNLg0KPiAN
Cg0K
