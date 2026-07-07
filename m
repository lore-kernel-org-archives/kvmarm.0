Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013007.outbound.protection.outlook.com [52.101.83.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35409332623;
	Tue,  7 Jul 2026 14:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.83.7
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783434602; cv=fail; b=b9D/VUB/i4eJYMvJPYIWnsTTLRNv/+9Hvajf4U/Zkz/a0UeBTU9TwKLSt98QvwRp7A0UlV/oFpKq0aNWp2htxNVaSuHwH+PBZiGes7rmtvBTc3aeIxn+iA6ug+PQziVzwRyMPp+tGWV4l4GnFFvz5cwH1dRmwfgN1HjSKLoIYGQ=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783434602; c=relaxed/simple;
	bh=b94FafxnCu8Q7ZHnWXLrbcrso+80KnalW/U/Fs+3X1I=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=k3QyPMy/uXDkUIBXeJJx0tEZb+jSO4fjJl+4sxIsmnTLSpGwGroYrT+mKqVbgfWPqVjTmctQ6+6GlQa0bCFtcOQSHJ/p9mAhV7jAvh+QmNiv4uMs1BEVFxP2KlvpI4DdjqlkdBa8bNcEsGztG1T0DB9i1fZSQNFd6+yGBkzYe7M=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=V++YaRz+; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=V++YaRz+; arc=fail smtp.client-ip=52.101.83.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="V++YaRz+";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="V++YaRz+"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=hatiGIyz3/5HHwktEusO7mHx3q9FZOPNLkXbJPXH/GhI2n9lMqyenocbBnSs3nF57+26y5h1SzbUj5Wsj1H4nsOkaaicK4c7sYMOAeFiay4gKNUWcv8xbihH2PQQ/ziyDp/XeTF7VVEXwE0Ya7fjeMWqCO3fPVfRuJdykacStt7LKOKsGdgKS+b7Rv2M5SBnzVRMa8f89x+cKRDuItO5/48Pmy4IYkGmxkhh+nVHVLyRrGxNEY61+8QLNLOr/pbt8sGWLL5taeOLWjpt4P49/vfNJU0TAU3dnTkIrddZgPPZZ8+9Y++VzRJesXLl+Vp/sDJ8BEPPqmdLT/bZUSzccg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b94FafxnCu8Q7ZHnWXLrbcrso+80KnalW/U/Fs+3X1I=;
 b=wUH42hrOjsa4VDk6ex+5mPcJR9N5zucrp+radsii1Duz8r/PoL3nJsBfShqu8Ov/1XPS3GuQpUBJJhFDb9KYST+UfeRNWdZEgb6wOLD888HfuqNeohz1kkjTSkrHHhgEDshZaU5cdOoDzEUT0d9wvWKRor7PySOSa3RoPVcahJveHZfknvdE7j1QgrD7I6N790S5dPcZaHNfsr+A+FvEKdZQ5+ETSt+1b+prAKF3+rC8OYRKMbMmkJyF/fxJ+Y5geIaNknB/ZlzkcJcEq4maX1C6DDtZxa8CCfrsmPX/EKZXP5XtuGbDldNI7XYPoDtkqT1JPbNkfJ1brsJriyWg0Q==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b94FafxnCu8Q7ZHnWXLrbcrso+80KnalW/U/Fs+3X1I=;
 b=V++YaRz+QiB+q0KwCe3V/q7f1A1SwTXILRb9yA4hT1VbjvQJFfVH+CWwLtX9BtrjdmhSMfQ3KPzVP/IIZvx8qHUbyrw4v7JrN3yyMz3WdUkxgB46vqquWjpgPJc+HeB0+jgA03Lkd2sU71AYHcyfR6rYWBZ6CXTCeeT3AMX6jv4=
Received: from DUZPR01CA0223.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4b4::10) by GVXPR08MB11496.eurprd08.prod.outlook.com
 (2603:10a6:150:2e4::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.9; Tue, 7 Jul 2026
 14:29:55 +0000
Received: from DB5PEPF00014B89.eurprd02.prod.outlook.com
 (2603:10a6:10:4b4:cafe::ab) by DUZPR01CA0223.outlook.office365.com
 (2603:10a6:10:4b4::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.13 via Frontend Transport; Tue, 7
 Jul 2026 14:29:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB5PEPF00014B89.mail.protection.outlook.com (10.167.8.197) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.6
 via Frontend Transport; Tue, 7 Jul 2026 14:29:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KBTzxFJ5rbPt1hBm/iSXtM6GHOoo/MqOSrNHCQx4yU0QjqS/J9h1gWmuBF2p4/m5zWm9P3zN6nZBpLFbm2s1CsaxqByHQf7vPbtNVCeZQ7/GQPLeDR+KUYHfk+visiOz62rbOKdV60X67Z4AfW/iTTkfO7YS5x4CztZD+xRw7v+uZLkGsnQJVZriY2JfND7UojjuVg+7Z+683a4MaT8qvhoDz3iZHEM01k86JTyKNQfJEeGQ8b4S5XPAEn1vkKaVMhcKxqmmsaLxHgBd3umd7Av9V2sacENDgsa4mFJN3HEy9CligGLMGBDUpfB/WHHM0qQrR9/AE6SRd6WT+w4U5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b94FafxnCu8Q7ZHnWXLrbcrso+80KnalW/U/Fs+3X1I=;
 b=bFcn4U5Ypm6RyodD3EQFvFf9M1+NobNv2Doitk/BsnAPDQjQqAZ0c/WqiRZlC8LcE/AvX4sO0F0iT7tAqDcjn5uiTLB0+w/5KgMPFK3kokCqgitgDI2Awc7zFaFNHlWgjEHgKY9AxV4SQAKjh/GXd9WyLED2+jMzjZ96zwpjkN4ooWIMHzeDUS/dJPHUSLei5ZAbbgKWTWhwASSYkA3E10FAjQtHJ1Ucs3SYdLfXfsPo4RYzg5woRmbQC3sjQYnbDoTZq51aXNBhF+b87EH0P0SZvSoG74LSFO30v/R01wIxCIp2IoIGxEidsKwmQwD2RlYYOV5m/WIzhtDr+rGhAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b94FafxnCu8Q7ZHnWXLrbcrso+80KnalW/U/Fs+3X1I=;
 b=V++YaRz+QiB+q0KwCe3V/q7f1A1SwTXILRb9yA4hT1VbjvQJFfVH+CWwLtX9BtrjdmhSMfQ3KPzVP/IIZvx8qHUbyrw4v7JrN3yyMz3WdUkxgB46vqquWjpgPJc+HeB0+jgA03Lkd2sU71AYHcyfR6rYWBZ6CXTCeeT3AMX6jv4=
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com (2603:10a6:10:407::19)
 by VI1PR08MB10031.eurprd08.prod.outlook.com (2603:10a6:800:1cd::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.8; Tue, 7 Jul 2026
 14:28:46 +0000
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e]) by DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e%5]) with mapi id 15.21.0181.009; Tue, 7 Jul 2026
 14:28:46 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "sashiko-reviews@lists.linux.dev" <sashiko-reviews@lists.linux.dev>
CC: "maz@kernel.org" <maz@kernel.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"oupton@kernel.org" <oupton@kernel.org>, nd <nd@arm.com>
Subject: Re: [PATCH v3 05/40] arm64/sysreg: Add GICv5 GIC VDPEND and VDRCFG
 encodings
Thread-Topic: [PATCH v3 05/40] arm64/sysreg: Add GICv5 GIC VDPEND and VDRCFG
 encodings
Thread-Index: AQHdCwQKexffveXYYke+t11TljXgerZb/AiAgAYnxYA=
Date: Tue, 7 Jul 2026 14:28:46 +0000
Message-ID: <1929b285ee0e0786baf880570b5e1a31b2648c2a.camel@arm.com>
References: <20260703154811.3355680-1-sascha.bischoff@arm.com>
	 <20260703154811.3355680-6-sascha.bischoff@arm.com>
	 <20260703162851.E357C1F000E9@smtp.kernel.org>
In-Reply-To: <20260703162851.E357C1F000E9@smtp.kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU0PR08MB8421:EE_|VI1PR08MB10031:EE_|DB5PEPF00014B89:EE_|GVXPR08MB11496:EE_
X-MS-Office365-Filtering-Correlation-Id: 0c637273-c65a-4802-504f-08dedc3436be
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|23010399003|3023799007|4143699003|6133799003|11063799006|56012099006|18002099003|22082099003|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 8B6tJuwSbjBbBHvG65NNQ0UMErllxx3dxC+n0F3Js+iJf7neujNj6zX7q7rV8nrC2OqMLeg6CJJ/TiM0I01ieBHYTxPMnjhWdxh8ADBymUofM+rvLJW2uYEUZ4Kd3+ldiVpJvl9kPXXeTrEGzKwKcan6+CeDrWfU1Mtk8ZBPUi2LTNAcWfnItCwUS0aFrk4VcqtsFNqmZ6AP+75P3Hf8FLM6G2HcCdCMe95NzN+PmFBf2MkGPqnlkCNbh2NfFeASdLSs/v2mBQylQ4uPEZ5xFmxhtM5nGojq4CdHfwq47x0oRNJGD1TDU1E2UzLxXUerTCLhjhVcrd54AiZmnxzu1CnN0xu5xbFBHZBwn5Gq8c0iecsV9YriEA+wLfYCWGl26X0LeJoXiAqBLReLuJLTbAd45R1TZxmC7mZbQOfOKzCW0MmjPIq5y8/uVHsjB25HkWxPMtLJSeXm3/bx6uXp0rZOzLklAUschXYsLY1ADIGWZvkrQgsBrvDArQH8c1/XE8sjJ7YVbLQLUBXb/IIOVQFm8SxBDYcD3q6MIYXxAoPhygzwivFuV7zzSAnHfKnN0YOjVEYAD54bRQXZTqcPpz6/NBnIPiX4zQ7cfagWLpNkhdPc7RrpNEqNA69F5x4ZJXKsPjaX1KC71vNirHMeYC+bkr0l4zAbtE3REhQV1pShYe61vaNYNXVZ4kyf6/BB72hu4LaIxO+b6uoVfNMRtDT4QdaZRPRWTjgSQLVv0dI=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB8421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(23010399003)(3023799007)(4143699003)(6133799003)(11063799006)(56012099006)(18002099003)(22082099003)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <E8F8EC0C1AAA7A46A3123BD464667461@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 XPR5zSYTRXMiShV5O/glS7J4eCXZXdmbC6wYoolo/JkTRBGnE5WGdvkC6QwG+b93ngPOZRSb7qBUsbOTxtCAMgK94OwJxG3KZgux40sjlQCigxZXB2lOIru/bLhi6paud2kSgtd3RhgrKsPAV1pYdIIoL5dusSuItwzxei/I4dUPjF8gCqeKRyGsHDzVIZcXpGraYNqUib+zwPX67iGfrAM5PQCC1/8Bw8gYhOY1dJ8Yq8XAQTq8vLf4wQg59FHFzBn4bl+VihjiYTDPh6ZmCguYu8o7Mc3i3EVt/dOgSsp8P+JD0KZAWlv2/sZzuugqVprnn4Fb6N0ws8I8YGmSeg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB10031
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB5PEPF00014B89.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	5d271597-8f73-4a26-345d-08dedc340df0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|1800799024|82310400026|376014|36860700016|14060799003|23010399003|11063799006|4143699003|3023799007|18002099003|22082099003|6133799003|56012099006;
X-Microsoft-Antispam-Message-Info:
	1wdiAUGozN4g1yAOhyZcR/Pa6Py+z3HOFqODSUPhpVd6m46PFm3EcpsgUqVoiwaso+x8fc0mOlOrdVq3+fmWa1UXD7zKpI70g3LqOsNeYjKaDYl6DJ84l9r5n9e1jWhwELptnjzeO2+b2U1kTV8Wne3DHNSVIC6UKrxS21XbINFYb77ZT0xx2/EKP2l2eXoPtNHTl85e+oA8dw2yUVNBBf9HpuvwuVXcqDqew2PJp9s8It4zw9NSpWzYe9mIKtLekGahVBfvuIg3ADvxHkGa71DG2NG3Xn5D5sFXxgRT17vz6MTenuslnCQK7hxg9ICBUY9nZOp2C0O7cOueQXoRwJLKde7gHR3Ix0N5XA3zY+7tWLx7+8nZKqKDU9TIFh+hkIgpcfEFL/AS1k0k3SVlwWNVUFjs9HeJLhk/PJ3KjDOMiEKy1ocMUKHn3kHG7hp4E1YUWinB6rq3kiuBw1jUsF91N30hNYxbz++imsAooDmiokOv/ETpvn0yX1esm67RKv0aCD805SutWMAb2W7MIqDeLjffFxh12sPCRAv5SEfPY6ZRYgFP025RGFl9iRJOz17SLmQSklEeEQVBxZcHmd+ZEh0DE6n4j5yMg7RZy0c2boOeUiV9AJkW7RwNcSgmknqjO5FdAFg/fnOp496f8juM3t2oxO7jo6UAJORitG5xDpccyJCuWtroFVrhtqd9K2LJbrhHDYjVpJjx5/M8Ww==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(1800799024)(82310400026)(376014)(36860700016)(14060799003)(23010399003)(11063799006)(4143699003)(3023799007)(18002099003)(22082099003)(6133799003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	GNeRGruj7SUJv+4kdUrdbpjxn+DbjEKaADSlkCLDsoAORX/JaTkMQCdakUGbrTAPJuvbMXVfMTBTfmfLSnkpD1m1ealin9+4NZUnJbyNX29Ki588TGbhgYUKSDeaiOP3TXFL6Ui8QMjJy1a7URuJhjlzvVxwgg+z/nY1cnYMAv7bbIAsWkKCpwblUl52K1LGHCEKnrypVRMJv0x6HHCuNFOKTUlvppLjPIaPqNHnWOkojQBLUXBULSrylcaT2hPo09M2dHmbundXqNY0/gbqZcIaUW1kQYlDrDOYJ9yTuJFj+iCCCIcj+huOw4jsaJjgAGPcumu3EQ9aLxHj0B5ICtwqVgXc/k06erHatw7tjJlsgpUK60mVhidHd7t1hMfOitp4l5//4pzB5lNPeVmsFaUr+rHBtOY4EpFVuT2YgYT443j2phaJsY8QYbD9+qDo
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2026 14:29:54.6961
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c637273-c65a-4802-504f-08dedc3436be
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB5PEPF00014B89.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVXPR08MB11496

T24gRnJpLCAyMDI2LTA3LTAzIGF0IDE2OjI4ICswMDAwLCBzYXNoaWtvLWJvdEBrZXJuZWwub3Jn
IHdyb3RlOg0KPiBUaGFuayB5b3UgZm9yIHlvdXIgY29udHJpYnV0aW9uISBTYXNoaWtvIEFJIHJl
dmlldyBmb3VuZCAxIHBvdGVudGlhbA0KPiBpc3N1ZShzKSB0byBjb25zaWRlcjoNCj4gLSBbSGln
aF0gTWlzc2luZyBWTSBJRCBpbiBHSUMgVkRSQ0ZHIHBheWxvYWQgY2F1c2VzIFNQSSBzdGF0ZQ0K
PiBjb3JydXB0aW9uIGZvciBWTXMgPiAwIG9yIGR1cmluZyByZXN0b3JlLg0KPiAtLQ0KPiANCj4g
Y29tbWl0IGFmMjEwMGNjN2VkOGJlYTVkOGRiN2M3ZTA5YTY0OWMxMmUwMzNkODANCj4gQXV0aG9y
OiBTYXNjaGEgQmlzY2hvZmYgPFNhc2NoYS5CaXNjaG9mZkBhcm0uY29tPg0KPiANCj4gYXJtNjQv
c3lzcmVnOiBBZGQgR0lDdjUgR0lDIFZEUEVORCBhbmQgVkRSQ0ZHIGVuY29kaW5ncw0KPiDCoMKg
wqAgDQo+IEFkZCB0aGUgZW5jb2RpbmdzIGZvciB0aGUgR0lDIFZEUEVORCBhbmQgR0lDIFZEUkNG
RyBzeXN0ZW0NCj4gaW5zdHJ1Y3Rpb25zLiBUaGVzZSBvcGVyYXRlIG9uIHRoZSB2aXJ0dWFsIGlu
dGVycnVwdCBkb21haW4sIGFuZCBhcmUNCj4gdXNlZCB0byBtYWtlIGludGVycnVwdHMgcGVuZGlu
ZyBmb3IgYSBWTSBhbmQgdG8gcmVhZCBiYWNrIHRoZQ0KPiBjb25maWd1cmF0aW9uIG9mIGEgVk0n
cyBpbnRlcnJ1cHRzLg0KPiANCj4gPiBkaWZmIC0tZ2l0IGEvYXJjaC9hcm02NC9pbmNsdWRlL2Fz
bS9zeXNyZWcuaA0KPiA+IGIvYXJjaC9hcm02NC9pbmNsdWRlL2FzbS9zeXNyZWcuaA0KPiA+IGlu
ZGV4IDdhYTA4ZDU5ZDQ5NDQuLjQwZmY3ZDI1ZDM3YjAgMTAwNjQ0DQo+ID4gLS0tIGEvYXJjaC9h
cm02NC9pbmNsdWRlL2FzbS9zeXNyZWcuaA0KPiA+ICsrKyBiL2FyY2gvYXJtNjQvaW5jbHVkZS9h
c20vc3lzcmVnLmgNCj4gWyAuLi4gXQ0KPiA+IEBAIC0xMTA1LDYgKzExMDUsMjIgQEANCj4gPiDC
oCNkZWZpbmUgR0lDVjVfR0lDUl9DRE5NSUFfVFlQRV9NQVNLCUdFTk1BU0tfVUxMKDMxLCAyOSkN
Cj4gPiDCoCNkZWZpbmUgR0lDVjVfR0lDUl9DRE5NSUFfSURfTUFTSwlHRU5NQVNLX1VMTCgyMywg
MCkNCj4gPiDCoA0KPiA+ICsvKg0KPiA+ICsgKiBEZWZpbml0aW9ucyBmb3IgR0lDdjUgaW5zdHJ1
Y3Rpb25zIGZvciB0aGUgVmlydHVhbCBEb21haW4NCj4gPiArICovDQo+ID4gKyNkZWZpbmUgR0lD
VjVfT1BfR0lDX1ZEUEVORAkJc3lzX2luc24oMSwgNCwgMTIsIDEsIDQpDQo+ID4gKyNkZWZpbmUg
R0lDVjVfT1BfR0lDX1ZEUkNGRwkJc3lzX2luc24oMSwgNCwgMTIsIDEsIDUpDQo+ID4gKw0KPiA+
ICsvKiBTaGlmdCBhbmQgbWFzayBkZWZpbml0aW9ucyBmb3IgR0lDIFZEUEVORCAqLw0KPiA+ICsj
ZGVmaW5lIEdJQ1Y1X0dJQ19WRFBFTkRfUEVORElOR19NQVNLCUJJVF9VTEwoNjMpDQo+ID4gKyNk
ZWZpbmUgR0lDVjVfR0lDX1ZEUEVORF9WTV9NQVNLCUdFTk1BU0tfVUxMKDQ3LCAzMikNCj4gPiAr
I2RlZmluZSBHSUNWNV9HSUNfVkRQRU5EX1RZUEVfTUFTSwlHRU5NQVNLX1VMTCgzMSwgMjkpDQo+
ID4gKyNkZWZpbmUgR0lDVjVfR0lDX1ZEUEVORF9JRF9NQVNLCUdFTk1BU0tfVUxMKDIzLCAwKQ0K
PiA+ICsNCj4gPiArLyogU2hpZnQgYW5kIG1hc2sgZGVmaW5pdGlvbnMgZm9yIEdJQyBWRFJDRkcg
Ki8NCj4gPiArI2RlZmluZSBHSUNWNV9HSUNfVkRSQ0ZHX1RZUEVfTUFTSwlHRU5NQVNLX1VMTCgz
MSwgMjkpDQo+ID4gKyNkZWZpbmUgR0lDVjVfR0lDX1ZEUkNGR19JRF9NQVNLCUdFTk1BU0tfVUxM
KDIzLCAwKQ0KPiANCj4gW1NldmVyaXR5OiBIaWdoXQ0KPiBEb2VzIEdJQyBWRFJDRkcgYWxzbyBu
ZWVkIGEgVk1fTUFTSyBkZWZpbml0aW9uPw0KDQpOby4NCg0KPiANCj4gVGhlIG1hc2sgZGVmaW5p
dGlvbnMgZm9yIHRoZSBHSUMgVkRSQ0ZHIHBheWxvYWQgb21pdCBhIFZNX01BU0sgKGUuZy4sDQo+
IEdFTk1BU0tfVUxMKDQ3LCAzMikpLCB3aGljaCBpcyBwcmVzZW50IGZvciBWRFBFTkQgYWJvdmUu
IA0KPiANCj4gQ291bGQgbWlzc2luZyB0aGUgVk0gSUQgaW4gdGhlIHBheWxvYWQgY2F1c2UgdGhl
IEdJQyB0byBxdWVyeSB0aGUgU1BJDQo+IHN0YXRlDQo+IGZvciBWTSAwIGluc3RlYWQgb2YgdGhl
IHRhcmdldCBWTT8NCg0KTm8uIEdJQyBWRFJGQ0cgYXBwbGllcyB0byB0aGUgcmVzaWRlbnQgVk0u
IEl0IGlzIGEgcHJvZ3JhbW1pbmcgZXJyb3IgdG8NCnVzZSB0aGlzIHN5c3RlbSBpbnN0cnVjdGlv
biB3aGVuIHRoZXJlIGlzIG5vdCBhIHJlc2lkZW50IFZQRSBmcm9tIHRoZQ0KVk0gb25lIGNhc2Ug
YWJvdXQuDQoNCj4gDQo+IFRoaXMgcmVncmVzc2lvbiBtaWdodCBsZWFkIHRvIGluY29ycmVjdCBm
dW5jdGlvbmFsIGJlaGF2aW9yIGZvciBWTXMgPg0KPiAwLg0KPiBGb3IgZXhhbXBsZSwgd2hlbiBr
dm1fdmdpY19zeW5jX2h3c3RhdGUoKSBjYWxscyBfX3ZnaWNfdjVfdmRyY2ZnKCksDQo+IGFuIGVt
cHR5DQo+IFZNIElEIGZpZWxkIGNvdWxkIGNhdXNlIHRoZSBoeXBlcnZpc29yIHRvIGZvbGQgdGhl
IFNQSSBzdGF0ZSBvZiBWTSAwDQo+IGludG8gdGhlDQo+IHNoYWRvdyBzdGF0ZSBvZiBWTSA+IDAu
DQo+IA0KPiBBbHRlcm5hdGl2ZWx5LCBpZiB0aGUgaW5zdHJ1Y3Rpb24gYXJjaGl0ZWN0dXJhbGx5
IHJlbGllcyBvbiB0aGUNCj4gcmVzaWRlbnQgVk0gaW4NCj4gSUNIX0NPTlRFWFRSX0VMMiByYXRo
ZXIgdGhhbiBhIHBheWxvYWQgZmllbGQsIHdvdWxkIGV4ZWN1dGluZyBpdA0KPiBkdXJpbmcgVk0N
Cj4gcmVzdG9yZSB3aGVuIG5vIHZDUFUgaXMgcmVzaWRlbnQgKHN1Y2ggYXMgaW4NCj4gdmdpY192
NV9yZXN0b3JlX3NwaV9hcF9saXN0KCkpDQo+IGZhaWwgdG8gd29yayBjb3JyZWN0bHk/DQo+IA0K
WWVzLCBleGVjdXRpbmcgaXQgYXQgdGhlIHdyb25nIHRpbWUgKGkuZS4sIHdpdGggbm8gdmFsaWQg
VlBFIHJlc2lkZW50KQ0Kd291bGQgY2F1c2UgaXNzdWVzLg0KDQpBcyBpdCB0dXJucyBvdXQsIHRo
aXMgaXMgYSBiYWQgd2F5IG9mIHJlcG9ydGluZyBhbiBhY3R1YWwgYnVnLCBiZWNhdXNlDQp0aGF0
J3MgZXhhY3RseSB3aGF0IEkndmUgZG9uZS4gVGhpcyB3YXMgaW5kZWVkIGFuIGlzc3VlIGluIHBh
dGNoICMzNiwNCmJ1dCBJIG5lYXJseSBza2lwcGVkIGl0IGR1ZSB0byB0aGUgd2F5IGl0IGhhcyBi
ZWVuIHJlcG9ydGVkLg0KDQpJbiB0aGlzIHYzIHBvc3RpbmcsIHBhdGNoICMzNiAoS1ZNOiBhcm02
NDogZ2ljLXY1OiBJbXBsZW1lbnQNCnNhdmUvcmVzdG9yZSBtZWNoYW5pc21zIGZvciBJU1RzKSBp
cyBpdGVyYXRpbmcgb3ZlciBhbGwgcG9zc2libGUgU1BJcw0KZm9yIGEgVk0gdG8gZmlndXJlIG91
dCB3aGljaCBuZWVkIHRvIGJlIHRyYWNrZWQgYnkgS1ZNIGluIG9yZGVyIHRvDQpub3RpZnkgdXNl
cnNwYWNlIG9uY2UgYW4gU1BJIGhhcyBiZWVuIGNvbnN1bWVkIGJ5IHRoZSBndWVzdC4gSW4gdGhl
DQpjdXJyZW50IGluY2FybmF0aW9uLCBpdCBpcyB1c2luZyBHSUMgVkRSQ0ZHIGJ1dCB3b3VsZCBk
byBzbyB3aXRob3V0IGENCnJlc2lkZW50IFZQRSAob29wcyB0byBzYXkgdGhlIGxlYXN0ISkuDQoN
CkkndmUgbG9jYWxseSByZXdvcmtlZCB0aGlzIHRvIHVwZGF0ZSB0aGUgcGVuZGluZyBzdGF0ZSBv
ZiBhbiBTUEkgYXMNCnBhcnQgb2YgcmVzdG9yaW5nIHRoZSBoYW5kbGluZyBtb2RlICh3aGljaCB3
ZSB3ZXJlIGFscmVhZHkgZG9pbmcpLiBUaGlzDQpoYXBwZW5zIGJhc2VkIG9uIHRoZSByYXcgSVNU
RSBiZWluZyByZXN0b3JlZCwgcmF0aGVyIHRoYW4gcXVlcnlpbmcgdGhlDQpzdGF0ZSBmcm9tIHRo
ZSBoYXJkd2FyZS4gV2UgdGhlbiBxdWV1ZSBhbnkgYWN0aXZlL3BlbmRpbmcgU1BJcyBpbiB0aGUN
CkFQIGxpc3QgdG8gbWFrZSBzdXJlIHRoYXQgd2UgdHJhY2sgdGhlaXIgZGVhY3RpdmF0aW9uIG9u
IGFsbCB2Y3B1DQpleGl0cy4gVGhpcyBzaG91bGQgZml4IHRoZSB1bmRlcmx5aW5nIGlzc3VlIHJl
cG9ydGVkIGhlcmUsIGFuZCB3aWxsIGJlDQppbmNsdWRlZCBpbiB2NCBvZiB0aGlzIHNlcmllcy4N
Cg0KVGhhbmtzLA0KU2FzY2hhDQo=
