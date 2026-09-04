Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013039.outbound.protection.outlook.com [52.101.83.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E1EC3CAE66;
	Fri,  4 Sep 2026 09:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.83.39
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788515997; cv=fail; b=RX39OrAPI+yjlgDGhVb+8JoTFcwcgfgUMZhXAwKqPvW2Mvh7PId9JyetHsLLQ7HUoq2mmtpr0cTsQtomFT7kkwAOVkldmhuMDxNDEdX19gFdbEkb94FdW2W6Bdt1BcnSu0fEYuihCxuxNbAFwuflulbKLo78gAoeihK9eiMtgMQ=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788515997; c=relaxed/simple;
	bh=Ddd+625qPFwHS6tLt9Og0UwKoTA35j/aYMTy50hBbbo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=o/CIpsHIgacOmn8IT9Sds9ri45Puna9BXph9jcqlqkPu7rBV8ezUxhxl2TnMWfA4RNx2UHAwcXQBwZ0jbfiRPZDO3G9v8cLocErQSLpnIJy/MCaH07KfmaaKvoeZgWL0FVKYz9Vln0IgSKuUq6LqX8FnMuIlSpBEB9LgEb1wkfY=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=M8LbVOgU; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=M8LbVOgU; arc=fail smtp.client-ip=52.101.83.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="M8LbVOgU";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="M8LbVOgU"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=TnMlfgZYxCvYKa7iI8IOZXw/RIuvMtAgGLlzLf/zH6XPTZlKntmtaGWUOECktof5PS6/8S8dC3p1IVh8j1LsqwwZ8tVSff3P88HlIuq69hSCIbbn92HJHe5Hpca7U3Sj/t+UwCcUX7yh6kkTJtj/sn1yUbfnRjm7Q0UTwpwEsbSBQuElyOKON7rS7yf2VmAK7E2djwR5cX1RJPJ4bE2EyZkHhkfvykjXfrmwJreu3PRNEEvs1f9og+BPQLfip3Y8KuGDZhDbNFoI2iYHrYyEWpnios7tgr+gRBFa89XzoRfy4LSXFRy/Jk/5zYJ6mis69hktUiVAJ2Vv77Xvi8j0qA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ddd+625qPFwHS6tLt9Og0UwKoTA35j/aYMTy50hBbbo=;
 b=yviakZ5SekK+ExOvq6xcaS8UvMxihN7nKf9M9EVK08lyWS9kHS/8FRxti9rY91KhupWWlR6DxBqcTCUKrXVGD7seIfPdYF+b1s7iyzaz464jTYx2gcrW1Bx8aOMLHOuCRIhO0BidQQ5IGnZoiZWVt8HoJr75ZtfxwIGjDZYSlahCAgHb9PGvwS6dBxW8s9geIBzgg8kcAy5m6++wGqYOTzhpFT9E/pQ5CJEk/yQ2ffw+V1ng86wsY+p2RYlwUzW8aAngtZGdJktFgjQZRBYJm33REHj2zGNP9atbn02bNAoLCN+425CGxeFqCmkvUqQN8aOEpVjxD3AADnMoxn7L6g==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ddd+625qPFwHS6tLt9Og0UwKoTA35j/aYMTy50hBbbo=;
 b=M8LbVOgUiFcVaZJf5aH6PNUFyK6c+oi9knDDPDCx1PH4v7FNNh3fv+xjh0GPKnXBgqrxRjpPYKwashyX9Kq38oUnrS+tIidSufcmSaL2crhZr/0nMhc6LrUWCKTCUI1z3j0eRPrsV5qwQ9eqZJri4frswTtEbqDnPQ1zXCz6s4c=
Received: from DU6P191CA0038.EURP191.PROD.OUTLOOK.COM (2603:10a6:10:53f::22)
 by GV1PR08MB10732.eurprd08.prod.outlook.com (2603:10a6:150:160::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 09:59:46 +0000
Received: from DB1PEPF000509E4.eurprd03.prod.outlook.com
 (2603:10a6:10:53f:cafe::6e) by DU6P191CA0038.outlook.office365.com
 (2603:10a6:10:53f::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.12 via Frontend Transport; Fri, 4
 Sep 2026 09:59:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509E4.mail.protection.outlook.com (10.167.242.54) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.8
 via Frontend Transport; Fri, 4 Sep 2026 09:59:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lOSbxW+gegOWO8lvXaZJs6qxjPUneeiLyzoquTrnxT+DYK/7cT0vcNgc6AKkLjoigQRtBDIX6A6TEF33GSmKJecYXCtKT/YokcHs+WvpbXH1i7GvDGYrkQrXsYx0lFmGcVmHgbS44eF2Cez3zGasVOOKBiA9Lyc6XK/zjDzr2x9xzIXCYqUNlt+gqs010po411ZkC7mMfmYQsC63GTatxw+/fDn6jGumnpZCSe7SKDzsL2uFVl6FuORLwTymhUAeK5LhHTxGiVbn4UKVdMvOs0M/vrMKPc9CB13dbb1J5aaZInZzICHa0tNVQe6eHk+ltxzhKraI2J+JX9tb+gHTpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ddd+625qPFwHS6tLt9Og0UwKoTA35j/aYMTy50hBbbo=;
 b=kwVvXyEhh79i5QTlBkiY5g7RHBv5MaOk1wAHASTwqYehUtohTbSevTseRPftUnDnEKqq+g1kuf7r0XemCa0Z/oViaXl3ykFs6t1YSoK8LilHMhjGZNXbR4aqZgwPs/kFQF4XcZ8zJIBf2pL1oNtpt2RNiDBU8rdionYVYX43JNV3ch+RGiyZCJtDz8m87Ebak2HgSAufYKMVy2qNohsbzh0bKoyCkE+CV5NHFaMNbSO7CAVkTY/W2nBOGJiJFvbU2aerZNaPI+5mBIqIpY7XVSD1dU2RQqO4y3Rs6PfSM0bgRyuMr4cqVdo8WQdTd0blu77xyKKApIG0WFs92pUulg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ddd+625qPFwHS6tLt9Og0UwKoTA35j/aYMTy50hBbbo=;
 b=M8LbVOgUiFcVaZJf5aH6PNUFyK6c+oi9knDDPDCx1PH4v7FNNh3fv+xjh0GPKnXBgqrxRjpPYKwashyX9Kq38oUnrS+tIidSufcmSaL2crhZr/0nMhc6LrUWCKTCUI1z3j0eRPrsV5qwQ9eqZJri4frswTtEbqDnPQ1zXCz6s4c=
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com (2603:10a6:101:1d::23)
 by AM9PR08MB6129.eurprd08.prod.outlook.com (2603:10a6:20b:284::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 09:59:10 +0000
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e]) by PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e%4]) with mapi id 15.21.0382.007; Fri, 4 Sep 2026
 09:59:09 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "sashiko-reviews@lists.linux.dev" <sashiko-reviews@lists.linux.dev>
CC: "maz@kernel.org" <maz@kernel.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"oupton@kernel.org" <oupton@kernel.org>, nd <nd@arm.com>
Subject: Re: [PATCH v5 32/49] KVM: arm64: gic-v5: Handle userspace accesses to
 IRS MMIO region
Thread-Topic: [PATCH v5 32/49] KVM: arm64: gic-v5: Handle userspace accesses
 to IRS MMIO region
Thread-Index: AQHdJl/tk5nB4HQSnU+G1FOibCjzE7aSxK4AgCuWnwA=
Date: Fri, 4 Sep 2026 09:59:09 +0000
Message-ID: <15f92744b6da7cd67196895789088e8b04986502.camel@arm.com>
References: <20260807111159.429128-1-sascha.bischoff@arm.com>
	 <20260807111159.429128-33-sascha.bischoff@arm.com>
	 <20260807162053.3AEC71F000E9@smtp.kernel.org>
In-Reply-To: <20260807162053.3AEC71F000E9@smtp.kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	PR2PR08MB4889:EE_|AM9PR08MB6129:EE_|DB1PEPF000509E4:EE_|GV1PR08MB10732:EE_
X-MS-Office365-Filtering-Correlation-Id: f06f2b22-7128-4943-2724-08df0a6b400e
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|23010399003|1800799024|366016|38070700021|6133799003|4143699003|11063799006|10067099003|22082099003|18002099003|56012099006|3023799007;
X-Microsoft-Antispam-Message-Info-Original:
 A+vFvEidLSt1bez/yBgpiWFHDg8HjzGlxr60zg2Z3+oaqTKDpD6rShwbrlZ+3+1IQJbMFOdRuFrCmLSyd2QZIlwfCVnu/Oqu+Ahs4l6pdhUXXOve0Q3/wRdikCYcqvi/NQ4VBYP+wspNLRxLAYkqU2a0Hwf8lU8KP2F26P90HJiAG1oINPwzZoAOGksapShuAmKeIphTJw1CeKpt24Uk07sMttztjaoWzVmGkJrZ7N6ltEW6rrHfG4yLudXlSFZyhB+o+cUeYwJ2n40eUscOqegsJGXicoIIyhvF+Kt8YuPMN9t4gDNSITaS8JPnXXzR1SONJYzB37znboUlM36zc0/IwQCpkp3FAvFXPRfCVf3a/ENYYO4YIvmXK0Mzg+WqT4OEvFTSnRnsDeupNV/06xsC13xGvs5plB9KRLJ4puSrY3FOkp5z05lMbpFd4eevPTsD5XMXV61VVvL+qAIbxXROYqLx4Yz5dinf+EfMf2ec44+qQHY1hvFMrVLDKENkCIQqtiyTvBFhuGIu+uEjRLn49EZC41IxB8v0mlnLmyyLlI3car0GmiYQBfrTLvVn1ZWDjqgxlQaef6YQUoCuvrg4lI4MadGuqCrq6ZinycPsDhf9Z30bGfVDqn+UZ6P+MGTK/8u7hBYmTIeytcMo+Y+1bF92m1eXJ0pqpU0qAgMwfwFXnLQh81Ur17H2i28mTkRpHyjXoziaR8Nbazo/1M/Jn1ZC2gosV+sg2YmHB98=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR2PR08MB4889.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(1800799024)(366016)(38070700021)(6133799003)(4143699003)(11063799006)(10067099003)(22082099003)(18002099003)(56012099006)(3023799007);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <D388142D4EC4DB4B8D3C64C891A31735@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 VVBZLbU9BpzOwTB59IzgvliJp3eodI/pEgIurFE4WZiUXtBm3QXFPIlLxRq8n3HhsQiogK1qJHGwaoDxGcWPgWQV9QwbJgPcsjViIssSxYuXkBi4nGw5uY1f6k01NvqOR/nmc41cufL5dZztOcALl3I33hV81JSByheRd82rbE+D+1UjCRkczVx1SHHHnHsh4uLTgDRCmkktUe4WMlX6X/+HftLZ5somrYMwPD96OuCDmcWfq1mHo8/3Yb+NGc5IJD3NE5f0pmgo5vFNrbbVSyLIN+GHIdmrDAvKuF6ys+F6mmy24bRPe8eyfiTaiYcF2+sRFs12uVBqddvnLy1zbA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR08MB6129
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509E4.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	0974f746-6d65-4bb2-8039-08df0a6b2a6f
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|30052699003|14060799003|23010399003|36860700016|82310400026|35042699022|3023799007|10067099003|4143699003|56012099006|11063799006|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	flmFGn5tDiexnpjc0Tl+oN0mow4meeTsySOP5DDBDYR46b9pS8BUeR7wj7EtxoPqX6Xt9QoYC4DOjkzV5J6COGLuZG9sq2g48PMoE1QHNt2xWiKhQ1M514Pf6tkmIZOBWOQhd51KI+w7MdzmiOiFItE0K1kdEF+6Fb8BfVK8qLfR5gX4ekl2MV7fJ7iewTQEPPOIfBdanBNn/rHdUlXnz3HGTsl7p+VeWdr/wPYOb+4PDaHOc9zGxn7MgiSwAGXTr/IQ4PJRHdNiVH7lh/PofTGlQnRxqVb+lBupCPlf9lzvhr8V8i9hbPZ8aq6ZNFYSjxgLi1j9ClrqFwKunrTtig+JvCbnVO4pzSTEySTi26Cbjinie0JAuODQyIZQfSDCtdDgUtZOHtYGDkmwnkLpOI+JSK2MoGJiRrim4fxmjoluTkRZqElunTPSxBH7A+kzJKfYd6HyDwURJqJ04Zgsrn2hgV2zi1AAncEYiuUlLNEoUll22V+rbqDczcHzOz5+oYiCnWaq8iX0yXRbPqeW0Ua7WzCLf/TMGplDE0yb0qDoddVxYJ1s+LR2ta8CrIv4vjca3DL+aIaNvssJs+7kfZeO29p7gmYssvmcole+r1yJoKPO9lGABNbzTexyu8r5AlymdYGtIHoWel+9jJNde2UgABVX9gP67999TeDNJFk=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(30052699003)(14060799003)(23010399003)(36860700016)(82310400026)(35042699022)(3023799007)(10067099003)(4143699003)(56012099006)(11063799006)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	if8usGMYeR8p7pQ2t3Htk6IBRH1vMbFtVF66MI4gMNx2UjQkrT3NxdzetObMLRdwPGn9wN3gEtDM8S25jdLIdF637qE28FKtRCaaM4LVGnGHtS6AlnYJ3dmxscNE6e2UcCBcavL4ERjkCY9Jv+VDNLVGOv6WlRXXRlFcJWbPSl2DK+dybtP8QxRk+Ytg0qNvrynupxfPKqEZ5LNSyKpvrjKt1zzrlMSRye4U2eetTTQJd2NNtTMLsXCzl150CF2kOezNhp8pvYfSVjD4P8INcEINsTr1ZTComa0E3crzpm6FiDIAisPFJSNay6McZb8SuNgn9PrrC8c4fumB+IPq8ExBzHbUekqXEGehiVOxy3nlv5FT0+LXDh2Q4YtcI8vCBmEBUa5fuN4wqF1X1M/ZLqQ+jmfmSIvXqhBUJJ8bxPgNx6i7nSQ2dQ+LSyECxAjc
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2026 09:59:46.1191
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f06f2b22-7128-4943-2724-08df0a6b400e
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509E4.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR08MB10732

T24gRnJpLCAyMDI2LTA4LTA3IGF0IDE2OjIwICswMDAwLCBzYXNoaWtvLWJvdEBrZXJuZWwub3Jn
IHdyb3RlOg0KPiBUaGFuayB5b3UgZm9yIHlvdXIgY29udHJpYnV0aW9uISBTYXNoaWtvIEFJIHJl
dmlldyBmb3VuZCAxIHBvdGVudGlhbA0KPiBpc3N1ZShzKSB0byBjb25zaWRlcjoNCj4gLSBbSGln
aF0gVXNlcnNwYWNlIGNhbiBpbmplY3QgYW4gaW5jb25zaXN0ZW50IHN0YXRlIGJ5IHNldHRpbmcN
Cj4gSVJTX0lTVF9CQVNFUi52YWxpZD0xIHdpdGhvdXQgYWxsb2NhdGluZyBhIGhvc3QgSVNULCBs
ZWFkaW5nIHRvIGENCj4gQ09OU1RSQUlORUQgVU5QUkVESUNUQUJMRSBoYXJkd2FyZSBzdGF0ZSBp
ZiB0aGUgZ3Vlc3Qgc3Vic2VxdWVudGx5DQo+IGNsZWFycyB0aGUgdmFsaWQgYml0Lg0KPiAtLQ0K
PiANCj4gLS0tIFBhdGNoIFszMl06IFtQQVRDSCB2NSAzMi80OV0gS1ZNOiBhcm02NDogZ2ljLXY1
OiBIYW5kbGUgdXNlcnNwYWNlDQo+IGFjY2Vzc2VzIHRvIElSUyBNTUlPIHJlZ2lvbiAtLS0NCj4g
Y29tbWl0IDI0ZWU4ODAyMjJlYjNlNGZmMDZjOWIyN2IxZDY1NWRhMTM0ZWZkN2ENCj4gQXV0aG9y
OiBTYXNjaGEgQmlzY2hvZmYgPFNhc2NoYS5CaXNjaG9mZkBhcm0uY29tPg0KPiBEYXRlOsKgwqAg
RnJpIEF1ZyA3IDExOjI4OjU0IDIwMjYgKzAwMDANCj4gDQo+IEtWTTogYXJtNjQ6IGdpYy12NTog
SGFuZGxlIHVzZXJzcGFjZSBhY2Nlc3NlcyB0byBJUlMgTU1JTyByZWdpb24NCj4gwqDCoMKgIA0K
PiBBcyBwYXJ0IG9mIHNhdmluZyBhbmQgcmVzdG9yaW5nIHRoZSBzdGF0ZSBvZiBhIEdJQ3Y1LWJh
c2VkIHN5c3RlbSwNCj4gdXNlcnNwYWNlIG11c3Qgc2F2ZSBhbmQgcmVzdG9yZSB0aGUgSVJTIE1N
SU8gcmVnaXN0ZXJzLiBUaGVzZSBpbmNsdWRlDQo+IGltcG9ydGFudCBpbmZvcm1hdGlvbiBzdWNo
IGFzIHRoZSBndWVzdCBJU1QgY29uZmlndXJhdGlvbiwgYW5kIEtWTQ0KPiBtdXN0IHByZXNlbnQg
Y29uc2lzdGVudCBzdGF0ZSB0byB0aGUgZ3Vlc3QgYWZ0ZXIgbWlncmF0aW9uLg0KPiANCj4gPiBk
aWZmIC0tZ2l0IGEvYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLWlycy12NS5jDQo+ID4gYi9hcmNo
L2FybTY0L2t2bS92Z2ljL3ZnaWMtaXJzLXY1LmMNCj4gPiBpbmRleCAwOTUwNDZjNzk1OWZhLi4y
MTIwNjZiOGQ3ZWQ1IDEwMDY0NA0KPiA+IC0tLSBhL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy1p
cnMtdjUuYw0KPiA+ICsrKyBiL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy1pcnMtdjUuYw0KPiBb
IC4uLiBdDQo+ID4gK3N0YXRpYyBpbnQgdmdpY192NV9tbWlvX3VhY2Nlc3Nfd3JpdGVfaXJzKHN0
cnVjdCBrdm1fdmNwdSAqdmNwdSwNCj4gPiBncGFfdCBhZGRyLA0KPiA+ICsJCQkJCcKgIHVuc2ln
bmVkIGludCBsZW4sDQo+ID4gdW5zaWduZWQgbG9uZyB2YWwpDQo+ID4gK3sNCj4gPiArCXN0cnVj
dCB2Z2ljX2Rpc3QgKnZnaWMgPSAmdmNwdS0+a3ZtLT5hcmNoLnZnaWM7DQo+ID4gKwlzdHJ1Y3Qg
dmdpY192NV9pcnMgKmlyc19kYXRhID0gdmdpYy0+dmdpY192NV9pcnNfZGF0YTsNCj4gPiArCXNp
emVfdCBvZmZzZXQgPSBhZGRyICYgKFNaXzY0SyAtIDEpOw0KPiA+IMKgDQo+ID4gLQkJLyogVGhl
IGFkZHJlc3MgY2Fubm90IGJlIGNoYW5nZWQgd2hpbGUgdGhlIElTVCBpcw0KPiA+IHZhbGlkLiAq
Lw0KPiA+IC0JCWlmIChpcnMtPmlzdF9iYXNlci52YWxpZCAmJiB2YWxpZCkNCj4gPiAtCQkJcmV0
dXJuOw0KPiA+ICsJLyoNCj4gPiArCSAqIFRoZSBmb2xsb3dpbmcgcmVnaXN0ZXJzIGFyZSBPTkxZ
IHNldHRhYmxlIHZpYQ0KPiA+IHVhY2Nlc3Nlcy4gVGhlIGd1ZXN0DQo+ID4gKwkgKiBjYW5ub3Qg
d3JpdGUgdGhlbSENCj4gPiArCSAqLw0KPiA+IMKgDQo+ID4gLQkJLyogVmFsaWQgLT4gSW52YWxp
ZCAqLw0KPiA+IC0JCWlmIChpcnMtPmlzdF9iYXNlci52YWxpZCAmJiAhdmFsaWQpIHsNCj4gPiAt
CQkJLyogTWFrZSB0aGUgTFBJIElTVCBpbnZhbGlkIGFuZCB0aGVuIC4uLg0KPiA+ICovDQo+ID4g
LQkJCWlmDQo+ID4gKGlycV9zZXRfdmNwdV9hZmZpbml0eSh2Z2ljX3Y1X3ZwZV9kYih2Y3B1KSwg
JmNtZCkpDQo+ID4gLQkJCQlicmVhazsNCj4gPiArCXN3aXRjaCAob2Zmc2V0KSB7DQo+IFsgLi4u
IF0NCj4gPiArCWNhc2UgR0lDVjVfSVJTX0lTVF9CQVNFUjoNCj4gPiArCQlpZiAoaXJzX2RhdGEt
PmlzdF9iYXNlci52YWxpZCAmJg0KPiA+ICsJCcKgwqDCoCAhdmdpY192NV9pc3RfYmFzZXJfbWF0
Y2hlcyhpcnNfZGF0YSwgdmFsKSkNCj4gPiArCQkJcmV0dXJuIC1FSU5WQUw7DQo+ID4gKw0KPiA+
ICsJCXZnaWNfdjVfdXBkYXRlX2lyc19pc3RfYmFzZXIoaXJzX2RhdGEsIHZhbCk7DQo+ID4gKwkJ
YnJlYWs7DQo+IA0KPiBbU2V2ZXJpdHk6IEhpZ2hdDQo+IERvZXMgdGhpcyBhbGxvdyB1c2Vyc3Bh
Y2UgdG8gaW5qZWN0IGFuIGluY29uc2lzdGVudCBzdGF0ZT8NCj4gDQo+IElmIHVzZXJzcGFjZSBz
ZXRzIHRoZSB2YWxpZCBiaXQgb2YgR0lDVjVfSVJTX0lTVF9CQVNFUiB0byAxIHZpYQ0KPiB2Z2lj
X3Y1X21taW9fdWFjY2Vzc193cml0ZV9pcnMoKSBidXQgZG9lcyBub3QgYWN0dWFsbHkgYWxsb2Nh
dGUgYQ0KPiBob3N0IExQSSBJU1QNCj4gKGJ5IG9taXR0aW5nIHRoZSBLVk1fREVWX0FSTV9WR0lD
X0dSUF9JU1QgaW9jdGwpLCB0aGUgVk0gY2FuIHN0aWxsIGJlDQo+IHN0YXJ0ZWQuDQo+IA0KPiBX
aGVuIHRoZSBndWVzdCBzdWJzZXF1ZW50bHkgY2xlYXJzIHRoZSB2YWxpZCBiaXQsIEtWTSdzIE1N
SU8gaGFuZGxlcjoNCj4gDQo+IHZnaWNfdjVfd3JpdGVfaXJzX2lzdF9iYXNlcigpIHsNCj4gwqDC
oMKgIC4uLg0KPiDCoMKgwqAgaWYgKGlycy0+aXN0X2Jhc2VyLnZhbGlkICYmICF2YWxpZCkgew0K
PiDCoMKgwqDCoMKgwqDCoCAvKiBNYWtlIHRoZSBMUEkgSVNUIGludmFsaWQgYW5kIHRoZW4gLi4u
ICovDQo+IMKgwqDCoMKgwqDCoMKgIHJjID0gaXJxX3NldF92Y3B1X2FmZmluaXR5KHZnaWNfdjVf
dnBlX2RiKHZjcHUpLCAmY21kKTsNCj4gDQo+IGRldGVjdHMgYSBWYWxpZCAtPiBJbnZhbGlkIHRy
YW5zaXRpb24gYW5kIGlzc3VlcyB0aGUNCj4gTFBJX1ZJU1RfTUFLRV9JTlZBTElEDQo+IGNvbW1h
bmQuIFRoaXMgc2VuZHMgYW4gdW5tYXAgY29tbWFuZCB0byB0aGUgaGFyZHdhcmUgZm9yIGEgVklT
VCB0aGF0DQo+IHdhcyBuZXZlcg0KPiBtYXBwZWQuDQo+IA0KPiBTaW5jZSB0aGlzIHJlc3VsdHMg
aW4gQ09OU1RSQUlORUQgVU5QUkVESUNUQUJMRSBoYXJkd2FyZSBiZWhhdmlvciwNCj4gc2hvdWxk
IEtWTQ0KPiByZWplY3QgdWFjY2VzcyB3cml0ZXMgdGhhdCBzZXQgdGhlIHZhbGlkIGJpdCB3aXRo
b3V0IGEgYmFja2luZyBJU1QsDQo+IG9yIHBlcmhhcHMNCj4gdmVyaWZ5IElTVCBwcmVzZW5jZSBi
ZWZvcmUgaXNzdWluZyB0aGUgdW5tYXAgY29tbWFuZD8NCj4gDQoNClJpZ2h0LCB0aGlzIGlzIGFu
IGlzc3VlLiBJJ3ZlIGFkZGVkIHNvbWUgdHJhY2tpbmcgaW4gc3VjaCB0aGF0IHdoZW4NCnVzZXJz
cGFjZSBzZXRzIHRoZSBJUlNfSVNUX0JBU0VSLlZhbGlkIGJpdCBpdCBtdXN0IGFsc28gcmVzdG9y
ZSBhbiBMUEkNCklTVC4gV2l0aG91dCB0aGF0LCB3ZSBub3cgZmFpbCBLVk1fUlVOLiBUaGlzIG1l
YW5zIHRoYXQgdGhlIHVzZXJzcGFjZS0NCnNldCBzdGF0ZSBtdXN0IGJlIGNvbnNpc3RlbnQgd2l0
aCB0aGUgc3RhdGUgYmVpbmcgcHJvdmlkZWQgdG8gdGhlDQpoYXJkd2FyZSAodmlhIHRoZSBWTVRF
KSBmb3IgdGhlIGd1ZXN0IHRvIGJlIHJ1bm5hYmxlLg0KDQpUaGlzIGNoYW5nZSBzcGFucyB0aGlz
IGNvbW1pdCBhbmQgIktWTTogYXJtNjQ6IGdpYy12NTogSW1wbGVtZW50DQpzYXZlL3Jlc3RvcmUg
bWVjaGFuaXNtcyBmb3IgSVNUcyIuDQoNClRoYW5rcywNClNhc2NoYQ0K
