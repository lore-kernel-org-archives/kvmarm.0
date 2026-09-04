Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013043.outbound.protection.outlook.com [40.107.159.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BD3A4772B6;
	Fri,  4 Sep 2026 10:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.43
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788519290; cv=fail; b=YYvox8xb3Z7a07ns0rJG0hARpTTgvlvBkwwwGQoWNqUhy9dAH2qXhpq3/c3x3OqCkceALNfjd6kkaVp649krX4eTK/IN+ARFs3DXXuFAzjHzNVi5nStK/RLpGgtEj4pbzoY28P+UzW6ueRydIJWrPT/7xmJD99DimOIoO99+XC4=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788519290; c=relaxed/simple;
	bh=hR4S+nStbm97HiQ2rSB43ksSNjxGcqBQgoA7CutQg4s=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=qmXN5vwAJ+yTJaQ+93j3gwIpvfTkb0TtDkFJRh4kaB+SXS912l1xM3xNiJJTHVNCgt5qnGtVN6xqpizGscZArCcM1vyqAMtq3v309whjWGTV/6605z8qL+oSiqol1tw6yBZULcFT6I3y9GyKZ1sk8vcjsGQgLXiFfv2OagdwRNM=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=E+1hmzt5; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=E+1hmzt5; arc=fail smtp.client-ip=40.107.159.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="E+1hmzt5";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="E+1hmzt5"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=IM+W2q2lV3N6ylLLV6yBawNf19tichFvf4c24yS3tLHQxxnbC9bUHLZTe0kFeXe2N/itMZlIMkklV4zN4ZcEZQafsEh5cgn61/cMQ8emhE4VT8d/1H8RutyLPRiv+ujQfzqK5885FwP6tfpogeV8tP2aPju/Ji92DChBlUVgBNB0g5mDyXOeI1ciZpsz/WKUzadTzsentWgWvZDEyeiaZkOJPEDBE9SY4if4RIMefBYRBhTyJGp7xvwTUYic6Y9Mn4QdBPD/PIY9lqCrhcpOY45k32jE7/CBBk7BkMIRUbd+yziw70SAP2rmF3w3cupzyG9fhVJK7bGMhfy6T1T1QA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hR4S+nStbm97HiQ2rSB43ksSNjxGcqBQgoA7CutQg4s=;
 b=dbH5Ibd6i3mxo6LFpk07ZXhGCgae1ALty6Hyl3tRslFQGatFtZjXA82pCIo77L4evcSrNDR90ygRwi9hDq8LcVWGkkoAeqRObt0odZZz9tyOga9GAOTH++ppm/6tkfOZlVLJWioFq9QTVe6yVpn/nCpNDzzE1uQ8yzQzJnyu7Kj/k3GG9RIidHAm54dUAJJOL4Ng8RrdKh5C/kZsyateSA2VR4bPHsvmDnqF6ANttlpFBF/bgBesKRuvGOuDlLBeF1ZsQOG/MLhZVHbUEBYykpctZ+FmnC6IvNs3riZwWbl46TXDgDmslB7WeBFntq2l0o3TgLdH6v8Hn2AnC2kMbQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hR4S+nStbm97HiQ2rSB43ksSNjxGcqBQgoA7CutQg4s=;
 b=E+1hmzt5xTjZe5lc4myYlRHqG1SdonJaP2LWv0vOwNg6N+loEZkSJ2IHMDa+PMoa3H16O05zmhiTRVHOodZ2UHmnqBMWFRhpa3tNakcP9msJkbLLkNqscoXT7gCcaEYF+XiINRGtCUBn0p34okKdfa9WXTZRP/MgQEVOCKV3I70=
Received: from AS9PR04CA0177.eurprd04.prod.outlook.com (2603:10a6:20b:530::10)
 by MI9PR08MB198788.eurprd08.prod.outlook.com (2603:10a6:290:85::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 10:54:43 +0000
Received: from AM3PEPF00009BA0.eurprd04.prod.outlook.com
 (2603:10a6:20b:530:cafe::12) by AS9PR04CA0177.outlook.office365.com
 (2603:10a6:20b:530::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.13 via Frontend Transport; Fri, 4
 Sep 2026 10:54:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM3PEPF00009BA0.mail.protection.outlook.com (10.167.16.25) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.8
 via Frontend Transport; Fri, 4 Sep 2026 10:54:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tauZvPJPRrIRTJjDnqpWy/yJA84fTDYOesmKinmylhp07g++h+EvWa+h2Pdab8hCv/1wNnXp5/VUKezp5qXYEfifIQHA1MyB04g2fRRzjEeCMO4HLWNaVdoBJ9YXrwniZQpuCOwqmKw4QW9mhoR+p1sseClF6bar24efK1vQ/o168SoZ/v24qZefOawiao2us/hDahbkrglstXbrVK8LLUI2jC9q21SrsbumTfQ3Wd7Vyo997Or/i/EsGkW8INCUkUdM2TYQ7wHe1kdkJXulXCEPCdKS2lGo/yrMkXDozb6qDcWLPELPVKLBGZWLnj4/mHEZ7hS1sajVfMjVsttMcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hR4S+nStbm97HiQ2rSB43ksSNjxGcqBQgoA7CutQg4s=;
 b=ZTovXVwma8Mw9quUoVWt2lj5BLcrKF4M0w2x14GRUKyyM75ey0tKQhmRfybWK+P/fjltBp6cIy3hRDgFfo+hJ8S8xWlTkdw1bhBiADAzPc0a1SWaaWIiHrtqjgK0z5+VX3KSma45fFFVvoDZyNBz1mguzhgxofCWgn4i04OlWTwYPx02bErqWRjSL5Y6oaMdmNaCHW4FAdzsVEpzBf6ouOfoNrJfwYj2yrFfaNKOUNrINniAMJIAGs2+dmYdEJt/wUblLjBphnB5cp+XCOVqfTCTL4vQVEfSM2ioet6s/rG9cc98AY1wOsQ1ZgCbrhZiI0Mr8nIGAkzndjg5KDFVCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hR4S+nStbm97HiQ2rSB43ksSNjxGcqBQgoA7CutQg4s=;
 b=E+1hmzt5xTjZe5lc4myYlRHqG1SdonJaP2LWv0vOwNg6N+loEZkSJ2IHMDa+PMoa3H16O05zmhiTRVHOodZ2UHmnqBMWFRhpa3tNakcP9msJkbLLkNqscoXT7gCcaEYF+XiINRGtCUBn0p34okKdfa9WXTZRP/MgQEVOCKV3I70=
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com (2603:10a6:101:1d::23)
 by GV2PR08MB8437.eurprd08.prod.outlook.com (2603:10a6:150:c3::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.7; Fri, 4 Sep 2026
 10:54:06 +0000
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e]) by PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e%4]) with mapi id 15.21.0382.007; Fri, 4 Sep 2026
 10:54:06 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "sashiko-reviews@lists.linux.dev" <sashiko-reviews@lists.linux.dev>
CC: "maz@kernel.org" <maz@kernel.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"oupton@kernel.org" <oupton@kernel.org>, nd <nd@arm.com>
Subject: Re: [PATCH v5 48/49] KVM: selftests: Add VGICv5 IST save/restore
 coverage
Thread-Topic: [PATCH v5 48/49] KVM: selftests: Add VGICv5 IST save/restore
 coverage
Thread-Index: AQHdJmERc5NqRjyaxUKWWSuim2UyyLaS3aKAgCuNA4A=
Date: Fri, 4 Sep 2026 10:54:06 +0000
Message-ID: <a2e15cb724b7778a1a663b3d4913ca1d5f075733.camel@arm.com>
References: <20260807111159.429128-1-sascha.bischoff@arm.com>
	 <20260807111159.429128-49-sascha.bischoff@arm.com>
	 <20260807175013.D7FC71F000E9@smtp.kernel.org>
In-Reply-To: <20260807175013.D7FC71F000E9@smtp.kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	PR2PR08MB4889:EE_|GV2PR08MB8437:EE_|AM3PEPF00009BA0:EE_|MI9PR08MB198788:EE_
X-MS-Office365-Filtering-Correlation-Id: 050f11e0-47d8-48b0-8921-08df0a72ed0e
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|23010399003|366016|376014|38070700021|6133799003|56012099006|11063799006|4143699003|10067099003|22082099003|3023799007|18002099003;
X-Microsoft-Antispam-Message-Info-Original:
 8kPIz+rZwYoc1Fgkuxnl0geOOu3UIulz2V+xVhpZqVuK0Ar8bILCHEZMsZwNNFLTpx0AAIph15mFcy/ymCUpL0RGBCemuHxUUUM48LrjePgMiGZdxv3P92iTIWy4Am1vMTcZzdKvQCP9hiQyipLmpHZCe9YTjBbZJNfnrYKOY2C0ai8FeR94DnuEJSnFU9S09nHEzjsionugQZxA6jfZz7eM83KVD6GkgloQmfev1d3Pa13LOZxD8Ahu+DSHCGK5IgkL2Bx1u51PczgetCSKaPRv8UzxSaKR+z5JgVwQPyPWxU2pAp7GPjNsvimZ6EuYCZTnqoqbTCglKk7+2yhz8UUYsNr4/Qp0kEynvEKKaODIHpxxMjV7gs3p6utQixtAi88iO9J09hYueC4aslH/O7u5pajYGcJk4+dzFxBtC1Mxa0beGIgbD3caEAhWTlLk6cQPUQFX9RjfyFJk+S4Vcu9XrUAemrkBejbjt/RoAhtB4jn7O9MkAQRF/4VutNFeCsTH4ADAoXCQLDzyq6V5vqsIVe+T6ZwJG2Mfwq1BDnrxXUlRrVWjMwrOB/iKfB0OZspxQjmB2yZhEezNeif+39JimMuqv/KkEpDGhu5cfJfLU0BNr8nztRRb/OgNHwJhZGsL7qRyId5MvRyZ/WGav+PlG4Jo68fePQNhU7YsES4q1BYSliSbF3p9QTcXxaDmdKtDm/LCKzHk+ZkLQhS214S/ei2InQsXNtj4nSAk0cU=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR2PR08MB4889.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(366016)(376014)(38070700021)(6133799003)(56012099006)(11063799006)(4143699003)(10067099003)(22082099003)(3023799007)(18002099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <CFE37E593212694E8D1FEB0C717A9391@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 fMI6X8GPI/O6OlCRVl5rT3En2tS39r+NphelEyailf3/AEIPlh5YtQOs3i3KKODh04taslRTc6RqUFrvQuqJO6wRsZC/voJ4k8yfb1PmsNvIvAJrqh0nI24p0F5U4np+v5ZKMzexqbU/EXoVmfFczWWz3j/f+RyfCQ8OFGsrqF1w9XEBe0CXj9GNdn1ZEFC9v4yz4IDSyrV7ZfVYvhJT73UGAHQKyzjtq4cCoqMy8rF06rKJDEwdy7ZS6ARnGx9kYs74OdiGhwzuZdvsNjth15MGe4XMMOD61gAKSBUHTIpi0u1em/qmbQm5wEEs5Yh960QHfqa8or8d/LXaimYA+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR08MB8437
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM3PEPF00009BA0.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	8888ced6-f52d-470a-dc3e-08df0a72d783
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|1800799024|376014|35042699022|23010399003|82310400026|36860700016|22082099003|10067099003|56012099006|11063799006|4143699003|3023799007|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	K7muYQFsMYHU8LB0SpkApBaaobjk9FXTtefBLZ8VgENtpTLVNEZ+3d5LnXMsXp1k5U0Gn1qTeU3+gwkxkVnS1s8y+u89+lPqy9CPFRNkxhcde4IYV9obwiurnxJM5VBmlq4hnIkN+mrX1IDtMCHG2bYpYB3YoDQH20v8zS9FALaZU4qTZ5aWsJ7ucR3nBA2lF2hoqKNCsVllA8fsFcYDsD47hE3tlZfJi9KdF0oOGq/5Wm7RiXIN6bSw2DawcKk/3uDt3h0u7VKmj1GjwhgzMHTJ5ioXpMvF8gIXRpRztNwE++EOg/pZxC8cKz58i8dpRmdsBbGNJrBYnYovYD11DKePQzkRW18e10HCiLA42yHcdWT0kqZ/LYJdnkAvQ9sn9whlbSbxS4D0R88ar9DI6CEBkgqiFcSkQuyJTd4istBdkYlkptZWoimxu27feT0UBSeZG3GArxKzRg/oaHTMw+39cayn8cFIWKcZXeIahuNfpA5ycfhpLzyERpLNUT0tQaXOwH5kVrQt4Imf0TBKRd1W81heIVlL/5fW05locdUizz2ZC10zo6ZKPmyGyYs/fdUpTsQ1YrNFLvl3OREuywCcUDQPk99tcewEob712Bx/f7875tYB25MV2w3jTabdNwF3oCMlfF/1D+1hdgiRJujZ6Y7ekrNjBmko50n1Gx4=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(1800799024)(376014)(35042699022)(23010399003)(82310400026)(36860700016)(22082099003)(10067099003)(56012099006)(11063799006)(4143699003)(3023799007)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	K5BAO9ZQ0nKDJRSOhBXOJ6r/QqE8UXIeo4Vvai9lN40LrG6ImdECUcvb6aIiybsMO2680PHpU650V562lJQ4/Fxr1vDjLw9wQDOrTnT+B0rbVf0mCEjHysXYWcrD2SQO11KWTqn1fp6dZkdxIVO5e1eXLfN+WMBaz+ZMKNlAKVhox2wSURi50k16VMu0jy/PgwCBMuN88cSoSPHKPZrO8UxnjWdHmPyxoOisVMWH8CKGDs0NGQ+SB40RMpUoT94MhViHy5xXMb+bEejt2I9XppQshbfPib+vdfdbsiJZkdfsOD8KFTiOpJBbjfx2zLk8GHnF2Ao1yt20iLFoRAwUoaTqxGIy532vuT0D6EyNGoL5MRMthYQ4lViWlNXLQpf1U9wIJD4Aiz1wrJUgL118YWXgKXuVB9GKEGZaSAVJogA8y00rYOnLdEzdp203SLyh
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2026 10:54:42.8596
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 050f11e0-47d8-48b0-8921-08df0a72ed0e
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM3PEPF00009BA0.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MI9PR08MB198788

T24gRnJpLCAyMDI2LTA4LTA3IGF0IDE3OjUwICswMDAwLCBzYXNoaWtvLWJvdEBrZXJuZWwub3Jn
IHdyb3RlOg0KPiBUaGFuayB5b3UgZm9yIHlvdXIgY29udHJpYnV0aW9uISBTYXNoaWtvIEFJIHJl
dmlldyBmb3VuZCAxIHBvdGVudGlhbA0KPiBpc3N1ZShzKSB0byBjb25zaWRlcjoNCj4gDQo+IFBy
ZS1leGlzdGluZyBpc3N1ZXM6DQo+IC0gW0hpZ2hdIE1pc3NpbmcgQ29udGV4dCBTeW5jaHJvbml6
YXRpb24gRXZlbnQgKElTQikgYWZ0ZXIgY29udHJvbC0NCj4gcGxhbmUgc3lzdGVtIHJlZ2lzdGVy
IHdyaXRlcy4NCj4gLS0NCj4gDQo+IC0tLSBQYXRjaCBbNDhdOiBbUEFUQ0ggdjUgNDgvNDldIEtW
TTogc2VsZnRlc3RzOiBBZGQgVkdJQ3Y1IElTVA0KPiBzYXZlL3Jlc3RvcmUgY292ZXJhZ2UgLS0t
DQo+IGNvbW1pdCAzZjJjOTc5ZTc4MzY1ZTcwNDIxYmNhYWYzOWYzNTBkOGI0YTgzMDg2DQo+IEF1
dGhvcjogU2FzY2hhIEJpc2Nob2ZmIDxTYXNjaGEuQmlzY2hvZmZAYXJtLmNvbT4NCj4gDQo+IEtW
TTogc2VsZnRlc3RzOiBBZGQgVkdJQ3Y1IElTVCBzYXZlL3Jlc3RvcmUgY292ZXJhZ2UNCj4gDQo+
IEFkZCBlbmQtdG8tZW5kIFZHSUN2NSBJU1Qgc2F2ZS9yZXN0b3JlIGNvdmVyYWdlLiBUaGUgdGVz
dCB2ZXJpZmllcw0KPiB0aGF0DQo+IGludGVycnVwdCBzdGF0ZSBzYXZlZCBmcm9tIHRoZSBJU1Rz
IGNhbiBiZSByZXN0b3JlZCBpbnRvIGEgZnJlc2ggVk0NCj4gYmVmb3JlDQo+IGZpcnN0IHJ1biBh
bmQgdGhlbiBjb25zdW1lZCBieSB0aGUgZ3Vlc3QuDQo+IA0KPiA+IGRpZmYgLS1naXQgYS90b29s
cy90ZXN0aW5nL3NlbGZ0ZXN0cy9rdm0vYXJtNjQvdmdpY192NS5jDQo+ID4gYi90b29scy90ZXN0
aW5nL3NlbGZ0ZXN0cy9rdm0vYXJtNjQvdmdpY192NS5jDQo+ID4gaW5kZXggNzFiZGE1NjYxYzc0
ZS4uNDdlMTQ3YmMxNGI4NyAxMDA2NDQNCj4gPiAtLS0gYS90b29scy90ZXN0aW5nL3NlbGZ0ZXN0
cy9rdm0vYXJtNjQvdmdpY192NS5jDQo+ID4gKysrIGIvdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMv
a3ZtL2FybTY0L3ZnaWNfdjUuYw0KPiBbIC4uLiBdDQo+ID4gQEAgLTM1OSw2ICs0MDYsMTY1IEBA
IHN0YXRpYyB2b2lkIGd1ZXN0X2xwaV9jb2RlKHZvaWQpDQo+IFsgLi4uIF0NCj4gPiArc3RhdGlj
IHZvaWQgZ3Vlc3RfaXN0X3Jlc3RvcmVfY29kZSh2b2lkKQ0KPiA+ICt7DQo+ID4gKwlsb2NhbF9p
cnFfZGlzYWJsZSgpOw0KPiA+ICsNCj4gPiArCWdpY3Y1X2NwdV9lbmFibGVfaW50ZXJydXB0cygp
Ow0KPiA+ICsNCj4gPiArCWlmICghZ3Vlc3RfZ2V0X3ZjcHVpZCgpKQ0KPiANCj4gW1NldmVyaXR5
OiBIaWdoXQ0KPiBUaGlzIGlzIGEgcHJlLWV4aXN0aW5nIGlzc3VlLCBidXQgc2hvdWxkDQo+IGdp
Y3Y1X2NwdV9lbmFibGVfaW50ZXJydXB0cygpDQo+IGlzc3VlIGFuIGlzYigpIGJlZm9yZSBpdCBy
ZXR1cm5zPw0KPiANCj4gTG9va2luZyBhdCB0aGUgaW1wbGVtZW50YXRpb24gb2YgZ2ljdjVfY3B1
X2VuYWJsZV9pbnRlcnJ1cHRzKCkgaW4NCj4gYm90aCB0aGUNCj4gaG9zdCBrZXJuZWwgZHJpdmVy
IChkcml2ZXJzL2lycWNoaXAvaXJxLWdpYy12NS5jKSBhbmQgdGhlIHNlbGZ0ZXN0DQo+IGhlbHBl
cg0KPiAodG9vbHMvdGVzdGluZy9zZWxmdGVzdHMva3ZtL2luY2x1ZGUvYXJtNjQvZ2ljX3Y1Lmgp
LCBpdCB3cml0ZXMgdG8NCj4gY29udHJvbA0KPiBwbGFuZSBzeXN0ZW0gcmVnaXN0ZXJzIGxpa2Ug
U1lTX0lDQ19DUjBfRUwxIHdpdGhvdXQgYW4gZXhwbGljaXQNCj4gY29udGV4dA0KPiBzeW5jaHJv
bml6YXRpb24gZXZlbnQuDQo+IA0KPiBJbiB0aGlzIG5ldyB0ZXN0IGNvZGUsIHdlIHBlcmZvcm0g
YSBjb25kaXRpb25hbCBicmFuY2ggYmFzZWQgb24NCj4gZ3Vlc3RfZ2V0X3ZjcHVpZCgpIGltbWVk
aWF0ZWx5IGFmdGVyIHJldHVybmluZyBmcm9tIHRoZSBmdW5jdGlvbi4NCj4gV2l0aG91dCBhbg0K
PiBpc2IoKSwgY291bGQgdGhpcyBjb25kaXRpb25hbCBpbnN0cnVjdGlvbiBiZSBleGVjdXRlZCBh
Z2FpbnN0IGFuDQo+IGFyY2hpdGVjdHVyYWxseSB1bmRlZmluZWQgcGlwZWxpbmUgc3RhdGU/DQoN
CkFzIHdlJ3ZlIGRpc2N1c3NlZCByZWxhdGl2ZWx5IG9mdGVuIGF0IHRoaXMgcG9pbnQsIHRoaXMg
aXMgbm90IGFuDQppc3N1ZS4gQWxzbywgd2UncmUgbm90IGluIGFuIHVuZGVmaW5lZCBwaXBlbGlu
ZSBzdGF0ZS4NCg0KPiANCj4gPiArCQlnaWN2NV9zZXRfcGNyKFZHSUNfVjVfSVNUX1BSSU9fSElH
SCk7DQo+ID4gKw0KPiA+ICsJR1VFU1RfU1lOQyhHVUVTVF9DTURfSVNfUkVBRFkpOw0KPiA+ICsN
Cj4gPiArCWxvY2FsX2lycV9lbmFibGUoKTsNCj4gPiArDQo+ID4gKwl3aGlsZSAoMSkNCj4gPiAr
CQl3ZmkoKTsNCj4gPiArfQ0KPiANCg0KVGhhbmtzLA0KU2FzY2hhDQo=
