Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011007.outbound.protection.outlook.com [52.101.65.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F10612B2D7;
	Fri,  4 Sep 2026 08:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.7
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788512305; cv=fail; b=SxXIk7Ol/3UjhP3QUzK80BIoQi0oXCb9pLJ1bvdTnlzrbATVfbhTN7SLQ0vAOr4onnFtAlkVezblhVgcASJ6MJJmXq4IhCqoIWPWExd1Qa6rKgJy+hOlUCSr7qB0Pb8fOImgli+qeTF11wjXSraknK8XslSg3Xtc7ooozIahBdk=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788512305; c=relaxed/simple;
	bh=SMhuNsj5HCJ0wcGM36rgmIEEhk8vfpfDPeTwwrmQEbg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=hb9WmFqeRQHO0SC7qzJs/pUDu/+hamn465hZUJmmuNCqGba3F5ms/zCUpqWviK7bVxUOJMJW7tRu7HmvgN77Ovx1sTrH3tU0KidaA1QV7xbagPfbfCn/3hocdX/hHK6k8Oj6siIvu+JQGNx0yvpYXi2zNe8jVibusaxFOKlleb8=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=CQHbeOYq; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=CQHbeOYq; arc=fail smtp.client-ip=52.101.65.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="CQHbeOYq";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="CQHbeOYq"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=nrPNXATOSXmS1GIuEnvxo9swf7av4rUJqARooQbUFduE4zvFb/PWUjhlwc2ul0o6iBtczz/iDGlR7NFhys72I9Q8V+Jj8noFFoDv7po+sjT+SyS7K+owZdIpdrO3ghUf3jq26aIgsT4UJUAtEDvkPGs91GQ0ryeL1cPiXLk218thOk5G2MtDSk0Jj+Qc6ouBa77RUliuXmsX8l9cNpTHD6NX6sFtmNj5nvyoxd2QNtURAN7MCC5k9usaW5HFukg7P1BWBm3TmjisRr11DrhE2VKcQXHO1tvIc439ebP0VeDvOF7qU78LI8jbq8x/G5zGFVC5ANaKvUjg8Bwcv5AQ7g==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SMhuNsj5HCJ0wcGM36rgmIEEhk8vfpfDPeTwwrmQEbg=;
 b=WuVkciWQE+vraGFpDdgS3WLrAI8pYv3khzsrGUTkt4CIzaQ6SaYetdedhMrR5JM8zPvtAlR99A+Wen/npobLOeiHFVHtYCTp6CRVcwYKOpftfOVLuzpfdubb2R3Qtf5TBgWe6siTcDUoRORwUNVye/nCgs6WY5XzU0dwkWThnrhyooWWBR+uHtWJRaIZSMLwdxYCZGKFSQsvJFsV/h3i9qviH27cQgdxkcPMn+UK5wj+c8AFE3IWQxUjz38Gdcp9NMFMN0zfg2ORAKZ6J1ckrpegv8uZSS3vCZjy/m2gG7f5zOfvm11Z+RBLBV1OLZn93ZsIOG0SDd/4Q7seDR5nOA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SMhuNsj5HCJ0wcGM36rgmIEEhk8vfpfDPeTwwrmQEbg=;
 b=CQHbeOYqQJ4Z+ugWx43XCWuBHfku+GSuNcrqq6IhPFXUbQymEHvk8umAXq3C4D+D3WJVtyAgK198XAsttKVdAaYaF95xbH/oErbJrChq6uFO5814rPXmeDIvUe9Tat67aUVrDqs5k0c/l3q8JkPgSB2StI0EcTmJImcv8sd/S3k=
Received: from AS4P195CA0010.EURP195.PROD.OUTLOOK.COM (2603:10a6:20b:5e2::20)
 by AM9PR08MB6145.eurprd08.prod.outlook.com (2603:10a6:20b:2dd::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 08:58:16 +0000
Received: from AMS1EPF00000044.eurprd04.prod.outlook.com
 (2603:10a6:20b:5e2:cafe::9d) by AS4P195CA0010.outlook.office365.com
 (2603:10a6:20b:5e2::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.12 via Frontend Transport; Fri, 4
 Sep 2026 08:58:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS1EPF00000044.mail.protection.outlook.com (10.167.16.41) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.8
 via Frontend Transport; Fri, 4 Sep 2026 08:58:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DyPKRcAdCDZEkIeP+AZYoJmI0LJyJISZf+b3j0WH9zuFFS+34rtvPcAz3qZmd9ClrJ6D4Cv4qlHGbf4y6Jm4XfUJyZMQ1s+vQM6YgT6igZ3iYvBaSZ8FA/IlBVMqy5LLZW9E6cPHyUpMLcJttcbKWPB0YvzUB8YWvZL7H4eCqsjWjZPeQX9T8dJ/hRgSaR/9HKY4wkzoB5SLTdvavv2EOB45NJYhT0yc7W063em5PxSWgz5FBP73JIC3VryasrNcTbEFaslYy/vt3k0B9Ymfu9zrTqGoYiC8zblAfyS+gf46rPYi1AWUQmPJR7VzJLtHr8IGbee3zB9OU5q/Umz9yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SMhuNsj5HCJ0wcGM36rgmIEEhk8vfpfDPeTwwrmQEbg=;
 b=CRWXlEhyO6ZROKtOZ0rNHCVeFXFTUGBxmIFO0evaJ6Y7moRxupLeKD+djyjdEAYK1IoXaO7TFAViB2WQIFZUihON9U9Hafmw7cTe5oMo8rhVNDtwtljsxmHd4D4c/+W2vw8XLTGy9hZ1KD6yanDNPEqEzV75xiRWAXyl3e7/2B1oHpbU90gSQ4wD3fhh4/CixGNR5vaPYBRoqAjRyTXJkmvHd20XmOrUof1M43sCelEdttZAIL7Rp63niExvI1UH/Pvgcbpgsv56hZQp4GI4+qol78A2QxK3G4gYKROdd3udyM67NMidsut98kV8pxKL97ZnCFNKzgSsb2rIIXF3hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SMhuNsj5HCJ0wcGM36rgmIEEhk8vfpfDPeTwwrmQEbg=;
 b=CQHbeOYqQJ4Z+ugWx43XCWuBHfku+GSuNcrqq6IhPFXUbQymEHvk8umAXq3C4D+D3WJVtyAgK198XAsttKVdAaYaF95xbH/oErbJrChq6uFO5814rPXmeDIvUe9Tat67aUVrDqs5k0c/l3q8JkPgSB2StI0EcTmJImcv8sd/S3k=
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com (2603:10a6:101:1d::23)
 by AS8PR08MB6246.eurprd08.prod.outlook.com (2603:10a6:20b:296::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 08:57:40 +0000
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e]) by PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e%4]) with mapi id 15.21.0382.007; Fri, 4 Sep 2026
 08:57:40 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "sashiko-reviews@lists.linux.dev" <sashiko-reviews@lists.linux.dev>
CC: "maz@kernel.org" <maz@kernel.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"oupton@kernel.org" <oupton@kernel.org>, nd <nd@arm.com>
Subject: Re: [PATCH v5 22/49] KVM: arm64: gic-v5: Register the IRS IODEV
Thread-Topic: [PATCH v5 22/49] KVM: arm64: gic-v5: Register the IRS IODEV
Thread-Index: AQHdJl83UrdzY5MOAku2Jdqg9JixpraSrCAAgCueAAA=
Date: Fri, 4 Sep 2026 08:57:39 +0000
Message-ID: <bbb84dd10d0706ac7733a0cb297f16df6ea88d9f.camel@arm.com>
References: <20260807111159.429128-1-sascha.bischoff@arm.com>
	 <20260807111159.429128-23-sascha.bischoff@arm.com>
	 <20260807145258.AC71A1F000E9@smtp.kernel.org>
In-Reply-To: <20260807145258.AC71A1F000E9@smtp.kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	PR2PR08MB4889:EE_|AS8PR08MB6246:EE_|AMS1EPF00000044:EE_|AM9PR08MB6145:EE_
X-MS-Office365-Filtering-Correlation-Id: 27914167-444e-47f1-d456-08df0a62a886
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|18002099003|22082099003|56012099006|38070700021|11063799006|4143699003|10067099003|5023799004|6133799003;
X-Microsoft-Antispam-Message-Info-Original:
 bTq2IW8tqCB6ln+6nfrisXk2sxJDAZWZrKHnTjtRIJrwoVz7N/6YNMqPK++0xQzuTBJ2IJk+EwlU/WH3b1R8/HiIqlYu6bhowP2B1qMlR9efGLioJU+HcQQwnjJKKvpFXGjjFoJWSJp6V3OI9Umn3+CmkIJRT9rVG0ULn5TZL5s2wq4tKPUDZAXhNLc4ZBjZtbzHZABb37ZqbEAUuubYlpObekzWLkmhCox0wB34NzxuZdogicZGv411mEmq7vt5BnvmU6o7NOlU5TUm2HdealBJig1ebWUX/RFb8dsf/eE8fYUZEilKL5qwLh6nqca8jXvUjX0eOMpCA9TfUCuLdqdXMCzn3biJDJ3KmqtrGtM9N5voTRNJ166Kd1EOlNxXYQcXMSn8D2Bjn/aIZOXXaePdBH5SbrU/QVHNX+DTXQDYymcCH9+ZN/EqB+XLlQPN8gJikmJ05wxGCjFY8LOgYF8kfKj3fOb2ssdZSbrS+006pquIrfmmqubW0Y2IaKhBn+6maabqrLvu48zH8rJ8jcqyXkKCMXY+Lie6uK7sVXFzOQfyaeSIieT0n+xkPtCa/a/saRoyLU0Sa0Unzl4WvgwpMnsxJnrWsb0JcuKhOBDnrGreYd7Ld/hzANPslfG3XGpY6zJv84sk121aFvxpmDvRmEfw9tLCeZuv2eyxStbChavjhYWTTQxzH09sAsk0qGA7ePdEyMqdWifhsJeV51LSonn7OWW6edzUjtSS6fs=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR2PR08MB4889.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(18002099003)(22082099003)(56012099006)(38070700021)(11063799006)(4143699003)(10067099003)(5023799004)(6133799003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <4DA394FD5B8F354DA233C310DAEC9207@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 pwwebc13/s4Y79t8EGKTWhdFfZkh6thLBe3i3Yv1UIrnNHYVDvXidPJI2jwPOm+S3s1q1ecREnsu1FfSu13GbDN/a2n4E2wmgEEuvGmUiNszeOy3Clf2t13F4D6+wQMmgZgqJ+9fnOVNQf1GhfAUioW8ZLvKzn5q9HzVTjMXbDHZcQ5kggyMKuxhNHfqpKNyKaOFYLqkWGhEfxj+W5HXEfaUUpkU5KyUMvTMxLqW4CUJyy4riSwhIc9z0dZZ3x4b2u82BJJoLfxYVQdqFaalCUQfVwFB3+uZHsjMbYHtvXpTEq/tjbB0CIzQXqIZMloyjRiTnnhayh41dvoqWzl3nA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB6246
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS1EPF00000044.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	4a750566-766d-4222-8e43-08df0a629308
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|35042699022|14060799003|82310400026|36860700016|1800799024|376014|10067099003|11063799006|5023799004|56012099006|4143699003|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	3IoL7b8OLI4U/deD/33dANk8ta6+KmVFQlwCrF4o5SycInx7Pix5x9Ry37iT4XJdhQWhv6QGrS56WS2qs0Vzdq63AJNkqj69bLD7n1qLsRLJUi1EeQn7CjZ0VNUrGYYF6DG/T4OOEpdvhoEoAIKIauUMMUOeE5ViL7Bt5x6sJCiZAGnQ3uyjho3unVeNlaICa4TUf3FkRMEX2her0qA+s5bB6MmHch/MvooDjyVKCh/06N5RjRWZCmHPSa04R04qd7hzV4fF3M7kkRTETD3P3uqFki8ZFpc8AzCuPsUJAOvd+dIAcPBLa9+rgHcwnbMBbXSabFR+HmvgP7FhiiL9b9QwwRhO8buApGW7/cnhrBGbajFIu9Z3iP5Bc+USu47ZpAqbf3vHVIECiDWbg7PJ2QGq4fN87MMHrveQ1ccIZ3IEw46rGvVGHgqXfUFdMvF+ei/LCOgbXwu6kz4qFSgPhh1t/jhmrYo03IgWzMvbMQohURr45W0NakvPvJaZUpE9zNMCB2lJmArqJFcs6+8V1hFRCt5OfmLEBhiTcinD4/VTGpNum8lxXHocwf211vnAM+lBYXglbXPbocT0TGwwMerxR62aeKN/dyX1h6rzIuumCzYYgTw94IGuKItXM5I8KJjPKZpDG35b/MaQSTFuCr/EN6Ta0BmlH4waKZ5gAhI=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(35042699022)(14060799003)(82310400026)(36860700016)(1800799024)(376014)(10067099003)(11063799006)(5023799004)(56012099006)(4143699003)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	pAE4FcLncOQOkOKg65zvUJNgpP5bc/oowp/Ftuek0IPgU/YApNAUQhsYjGCLb8PbAQ6N3DZCRVmKBKZ2zxL66sRGYWO9pXveIhTshyppz0tf/RGE+p+5LrIHVS77seGMkOfJlEoViSGv/xo937CY/huqPus8Fmx/Eij3V12SIZQsK0VxK0BCXMjnD8hs95j3HZl8hQ3bcX+nUF4Ibl5RO3wRv0FW8cBNBDhet2PzV8j3ra0I4VveIu/OEP++vvCxY6dDSyRhcW+XBuiJ/glPCKHljtDdWb1jaXgS3Kv18zJr0+0ko9lwjYs8yJj7ZA8xlKdVPmxXytv0AR04xMxSXNtZ+tzO9ecj8CGFNTdADx6Cz+gxWlICEnp3rCap8Yg4Q2rCXzPUP5E2fQ0l+QgBLGUlOqAoBxy2jL6ffEnyUhvyJJtmtRDBn40tHjpOAapu
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2026 08:58:15.9317
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 27914167-444e-47f1-d456-08df0a62a886
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS1EPF00000044.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR08MB6145

T24gRnJpLCAyMDI2LTA4LTA3IGF0IDE0OjUyICswMDAwLCBzYXNoaWtvLWJvdEBrZXJuZWwub3Jn
IHdyb3RlOg0KPiBUaGFuayB5b3UgZm9yIHlvdXIgY29udHJpYnV0aW9uISBTYXNoaWtvIEFJIHJl
dmlldyBmb3VuZCAyIHBvdGVudGlhbA0KPiBpc3N1ZShzKSB0byBjb25zaWRlcjoNCj4gLSBbSGln
aF0gR0lDdjUgU1BJIGluamVjdGlvbiB2aWEgSVJRRkQgYW5kIEtWTV9JUlFfUk9VVElOR19JUlFD
SElQIGlzDQo+IGJyb2tlbiBkdWUgdG8gbWlzc2luZyBVQVBJIElOVElEIHRyYW5zbGF0aW9uIGFu
ZCBpbmNvbXBsZXRlDQo+IHZnaWNfZ2V0X2lycSgpIHN1cHBvcnQuDQo+IC0gW0hpZ2hdIFBNVSBJ
UlEgY29uZmlndXJhdGlvbiBpcyBicm9rZW4gZm9yIEdJQ3Y1IFZNcyBkdWUgdG8gbWlzc2luZw0K
PiBVQVBJIElOVElEIHRyYW5zbGF0aW9uLg0KPiAtLQ0KPiANCj4gLS0tIFBhdGNoIFsyMl06IFtQ
QVRDSCB2NSAyMi80OV0gS1ZNOiBhcm02NDogZ2ljLXY1OiBSZWdpc3RlciB0aGUgSVJTDQo+IElP
REVWIC0tLQ0KPiBjb21taXQgMWY3YzQyMWRlZjI2NTZhNzVkOWY0YzZjM2M5YmM4YjkwMzA5ZGJi
OA0KPiBBdXRob3I6IFNhc2NoYSBCaXNjaG9mZiA8U2FzY2hhLkJpc2Nob2ZmQGFybS5jb20+DQo+
IFN1YmplY3Q6IEtWTTogYXJtNjQ6IGdpYy12NTogUmVnaXN0ZXIgdGhlIElSUyBJT0RFVg0KPiAN
Cj4gVGhpcyBjb21taXQgcmVnaXN0ZXJzIHRoZSBHSUN2NSBJUlMgSU9ERVYgZHVyaW5nIHZnaWNf
bWFwX3Jlc291cmNlcy4NCj4gSXQNCj4gYWxzbyBleHBvc2VzIHRoZSBJUlMgYWRkcmVzcyBjb25m
aWd1cmF0aW9uIHRvIHVzZXJzcGFjZSBhbmQgYWxsb3dzDQo+IHNldHRpbmcNCj4gdGhlIG51bWJl
ciBvZiBTUElzIGhhbmRsZWQgYnkgdGhlIEdJQ3Y1IGltcGxlbWVudGF0aW9uLg0KPiANCj4gPiBk
aWZmIC0tZ2l0IGEvYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLWt2bS1kZXZpY2UuYw0KPiA+IGIv
YXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLWt2bS1kZXZpY2UuYw0KPiA+IGluZGV4IDkwYmU5OTQ0
M2RmM2IuLjhjMmM2ODg2YWY0ZTMgMTAwNjQ0DQo+ID4gLS0tIGEvYXJjaC9hcm02NC9rdm0vdmdp
Yy92Z2ljLWt2bS1kZXZpY2UuYw0KPiA+ICsrKyBiL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy1r
dm0tZGV2aWNlLmMNCj4gDQo+IFsgLi4uIF0NCj4gDQo+ID4gQEAgLTIyNCwzMSArMjMyLDQ4IEBA
IHN0YXRpYyBpbnQgdmdpY19zZXRfY29tbW9uX2F0dHIoc3RydWN0DQo+ID4ga3ZtX2RldmljZSAq
ZGV2LA0KPiANCj4gWyAuLi4gXQ0KPiANCj4gPiArCQl9IGVsc2Ugew0KPiA+ICsJCQkvKg0KPiA+
ICsJCQkgKiBHSUN2NSByZXBvcnRzIGEgbnVtYmVyIG9mIFNQSXMsIG5vdCBhDQo+ID4gdG90YWwg
bnVtYmVyIG9mDQo+ID4gKwkJCSAqIGludGVycnVwdHMuIFJlcXVpcmUgYSBtdWx0aXBsZSBvZiAz
Mg0KPiA+IFNQSXMuDQo+ID4gKwkJCSAqLw0KPiA+ICsJCQlpZiAodmFsIDwgVkdJQ19WNV9ERUZB
VUxUX05SX1NQSVMgfHwNCj4gPiArCQkJwqDCoMKgIHZhbCA+IFZHSUNfVjVfTUFYX05SX1NQSVMg
fHwNCj4gPiArCQkJwqDCoMKgICh2YWwgJiAzMSkpDQo+ID4gKwkJCQlyZXR1cm4gLUVJTlZBTDsN
Cj4gPiArDQo+ID4gKwkJCW11dGV4X2xvY2soJmRldi0+a3ZtLT5hcmNoLmNvbmZpZ19sb2NrKTsN
Cj4gPiArCQkJaWYgKHZnaWNfaW5pdGlhbGl6ZWQoZGV2LT5rdm0pIHx8IGRldi0NCj4gPiA+a3Zt
LT5hcmNoLnZnaWMubnJfc3BpcykNCj4gPiArCQkJCXJldCA9IC1FQlVTWTsNCj4gPiArCQkJZWxz
ZQ0KPiA+ICsJCQkJZGV2LT5rdm0tPmFyY2gudmdpYy5ucl9zcGlzID0gdmFsOw0KPiA+ICsJCQlt
dXRleF91bmxvY2soJmRldi0+a3ZtLT5hcmNoLmNvbmZpZ19sb2NrKTsNCj4gPiArCQl9DQo+ID4g
wqANCj4gPiDCoAkJcmV0dXJuIHJldDsNCj4gPiDCoAl9DQo+IA0KPiBbU2V2ZXJpdHk6IEhpZ2hd
DQo+IERvZXMgdGhpcyBsZWF2ZSBQTVUgSVJRIGNvbmZpZ3VyYXRpb24gYnJva2VuIGZvciBHSUN2
NSBWTXM/DQo+IA0KPiBTaW5jZSB0aGUgVUFQSSBJTlRJRCBsYWNrcyB0aGUgR0lDdjUgaW50ZXJu
YWwgaGFyZHdhcmUgdHlwZSBiaXRzLCB0aGUNCj4gUE1VIGNvbmZpZ3VyYXRpb24gZmFpbHMgdW5j
b25kaXRpb25hbGx5IGR1cmluZyB2YWxpZGF0aW9uLiBXaGVuDQo+IHVzZXJzcGFjZQ0KPiBjb25m
aWd1cmVzIHRoZSBQTVUgSVJRIHVzaW5nIHRoZSBLVk1fQVJNX1ZDUFVfUE1VX1YzX0lSUSBhdHRy
aWJ1dGUNCj4gKHBhc3NpbmcNCj4gYSBzdGFuZGFyZCBQUEkpLCB0aGUgY2hlY2sgZmFpbHM6DQo+
IA0KPiBhcmNoL2FybTY0L2t2bS9wbXUtZW11bC5jOmt2bV9hcm1fcG11X3YzX3NldF9hdHRyKCkg
ew0KPiDCoMKgwqAgLi4uDQo+IMKgwqDCoCBpZiAoIShpcnFfaXNfcHBpKHZjcHUtPmt2bSwgaXJx
KSB8fCBpcnFfaXNfc3BpKHZjcHUtPmt2bSwgaXJxKSkpDQo+IMKgwqDCoMKgwqDCoMKgIHJldHVy
biAtRUlOVkFMOw0KPiDCoMKgwqAgLi4uDQo+IH0NCj4gDQo+IEJlY2F1c2UgaXJxX2lzX3BwaSgp
IGFuZCBpcnFfaXNfc3BpKCkgcmVxdWlyZSB0aGUgR0lDVjVfSFdJUlFfVFlQRQ0KPiBiaXRzDQo+
IHRoYXQgYXJlIG1pc3NpbmcgZnJvbSB0aGUgcmF3IGludGVnZXIsIHdpbGwgdGhpcyBjYXVzZSBQ
TVUgc2V0dXAgdG8NCj4gZmFpbA0KPiB3aXRoIC1FSU5WQUwgZm9yIEdJQ3Y1IFZNcz8NCg0KTm8s
IGJlY2F1c2Ugd2UgcmVxdWlyZSBhIEdJQ3Y1IFZNTSB0byBwcm92aWRlIGEgdmFsaWQgR0lDdjUt
c3R5bGUNCmludGVycnVwdCBJRC4gSWYgdGhlIFZNTSBqdXN0IHByb3ZpZGVkIHVzIHdpdGggYW4g
SUQgd2l0aG91dCBhIHR5cGUNCndpdGggYSB2R0lDdjUsIHdlIGhhdmUgbm8gd2F5IHdoYXRzb2V2
ZXIgb2Yga25vd2luZyBpZiBpdCBpcyBhIFBQSSBvcg0KU1BJLiBGb3IgR0lDdjUsIHdlIG1hbmRh
dGUgdGhhdCBpdCBpcyB0aGUgYXJjaGl0ZWN0ZWQgUFBJLCBhbmQgdGhhdCdzDQppdC4gTm90aGlu
ZyBlbHNlIGlzIGFsbG93ZWQuDQoNCj4gDQo+ID4gZGlmZiAtLWdpdCBhL2luY2x1ZGUva3ZtL2Fy
bV92Z2ljLmggYi9pbmNsdWRlL2t2bS9hcm1fdmdpYy5oDQo+ID4gaW5kZXggNTljNmU2ZTc2NjE2
Ni4uZTAzZTgyMGU0M2ZmMCAxMDA2NDQNCj4gPiAtLS0gYS9pbmNsdWRlL2t2bS9hcm1fdmdpYy5o
DQo+ID4gKysrIGIvaW5jbHVkZS9rdm0vYXJtX3ZnaWMuaA0KPiA+IEBAIC0zMSw3ICszMSwxMiBA
QA0KPiA+IMKgI2RlZmluZSBWR0lDX01BWF9TUEkJCTEwMTkNCj4gPiDCoCNkZWZpbmUgVkdJQ19N
QVhfUkVTRVJWRUQJMTAyMw0KPiA+IMKgI2RlZmluZSBWR0lDX01JTl9MUEkJCTgxOTINCj4gPiAt
I2RlZmluZSBLVk1fSVJRQ0hJUF9OVU1fUElOUwkoMTAyMCAtIDMyKQ0KPiA+ICsNCj4gPiArLyoN
Cj4gPiArICogVGhlIGNvbW1vbiBJUlEgcm91dGluZyB0YWJsZSBtdXN0IGFjY29tbW9kYXRlIGFs
bCBHSUMgdHlwZXMuDQo+ID4gR0lDdjIgYW5kDQo+ID4gKyAqIEdJQ3YzIG5lZWQgOTg4IHBpbnMs
IHdoaWxlIEdJQ3Y1IG5lZWRzIDEwMjQgcGlucy4NCj4gPiArICovDQo+ID4gKyNkZWZpbmUgS1ZN
X0lSUUNISVBfTlVNX1BJTlMJMTAyNA0KPiANCj4gW1NldmVyaXR5OiBIaWdoXQ0KPiBEb2VzIGV4
cGFuZGluZyB0aGUgSVJRIHJvdXRpbmcgdGFibGUgdG8gMTAyNCBwaW5zIGV4cG9zZSBhIGdhcCBp
bg0KPiBHSUN2NQ0KPiBTUEkgaW5qZWN0aW9uIHN1cHBvcnQ/DQoNCldpdGggdGhpcyBjb21taXQs
IHdlIGRvbid0IHlldCBzdXBwb3J0IFNQSSBpbmplY3Rpb24sIHNvIHRoaXMgaXMgbm90IGFuDQpp
c3N1ZS4gVGhlIHN1cHBvcnQgZm9yIFNQSSBpbmplY3Rpb24gaXMgYWRkZWQgaW4gYSBzdWJzZXF1
ZW50IGNvbW1pdC4NCkZ1cnRoZXJtb3JlLCB0aGUgaXJxZmQgc3VwcG9ydCBpcyBhbHNvIGFkZGVk
IGluIGEgbGF0ZXIgY29tbWl0IGluIHRoaXMNCnNlcmllcy4NCg0KPiANCj4gV2hpbGUgdGhpcyBl
eHBhbmRzIHRoZSBwaW5zIGZvciBHSUN2NSwgdGhlIHVuZGVybHlpbmcgaW5qZWN0aW9uDQo+IG1l
Y2hhbmlzbXMNCj4gZG8gbm90IHRyYW5zbGF0ZSB0aGUgVUFQSSBJTlRJRC4gRm9yIGV4YW1wbGUs
IGluDQo+IHZnaWNfaXJxZmRfc2V0X2lycSgpOg0KPiANCj4gYXJjaC9hcm02NC9rdm0vdmdpYy92
Z2ljLWlycWZkLmM6dmdpY19pcnFmZF9zZXRfaXJxKCkgew0KPiDCoMKgwqAgLi4uDQo+IMKgwqDC
oCB1bnNpZ25lZCBpbnQgc3BpX2lkID0gZS0+aXJxY2hpcC5waW4gKyBWR0lDX05SX1BSSVZBVEVf
SVJRUzsNCj4gwqDCoMKgIC4uLg0KPiDCoMKgwqAgaWYgKCF2Z2ljX3ZhbGlkX3NwaShrdm0sIHNw
aV9pZCkpDQo+IMKgwqDCoMKgwqDCoMKgIHJldHVybiAtRUlOVkFMOw0KPiDCoMKgwqAgLi4uDQo+
IH0NCj4gDQo+IFRoaXMgY2FsY3VsYXRlcyBzcGlfaWQgd2l0aG91dCB0aGUgcmVxdWlyZWQgR0lD
VjVfSFdJUlFfVFlQRV9TUEkNCj4gYml0cywNCj4gY2F1c2luZyB2Z2ljX3ZhbGlkX3NwaSgpIHRv
IGZhaWwgZm9yIEdJQ3Y1Lg0KPiANCj4gQWRkaXRpb25hbGx5LCB2Z2ljX2dldF9pcnEoKSBoYXJk
Y29kZXMgYSBOVUxMIHJldHVybiBmb3IgR0lDdjUgU1BJcywNCj4gd2hpY2ggYmxvY2tzIGluamVj
dGlvbiBlbnRpcmVseToNCj4gDQo+IGFyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy5jOnZnaWNfZ2V0
X2lycSgpIHsNCj4gwqDCoMKgIC4uLg0KPiDCoMKgwqAgaWYgKHZnaWNfaXNfdjUoa3ZtKSkNCj4g
wqDCoMKgwqDCoMKgwqAgcmV0dXJuIE5VTEw7DQo+IMKgwqDCoCAuLi4NCj4gfQ0KPiANCj4gV2ls
bCB0aGlzIHByZXZlbnQgZ3Vlc3RzIHVzaW5nIGRldmljZSBwYXNzLXRocm91Z2ggb3IgdmlydGlv
IGRldmljZXMNCj4gdGhhdCByZWx5IG9uIFNQSXMgZnJvbSByZWNlaXZpbmcgaW50ZXJydXB0cyB2
aWEgaXJxZmQvZXZlbnRmZD8NCj4gDQpBcyBvZiB0aGlzIGNvbW1pdCwgdGhhdCBpcyBpbmRlZWQg
dGhlIGNhc2UgYXMgd2UndmUgbm90IGFkZGVkIHRoZQ0Kc3VwcG9ydCBpbiB5ZXQuIEhlbmNlLCB0
aGlzIGlzIGV4cGVjdGVkIGF0IHRoaXMgc3RhZ2UgaW4gdGhlIHNlcmllcy4NCg0KVGhhbmtzLA0K
U2FzY2hhDQo=
