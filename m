Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011014.outbound.protection.outlook.com [52.101.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 523B72EB5D5
	for <kvmarm@lists.linux.dev>; Mon, 15 Sep 2025 08:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.14
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757924711; cv=fail; b=nNUWCKBCOotBRNHfhNDw+kmzhvcQ/AUFSxjutsFAIDOH0+vY9ahd/RbGp4+4v76PybijdCKkSlAXWiRjmDPEQHW8y26Puy86S7nBp5UyLCFPv60RRvu/Q6OdexT4HsbDsjbZyaNHOuBoQDc1A4NZ+38qIC7B29KH4pab0z/SJms=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757924711; c=relaxed/simple;
	bh=9rXdnMaos4XjIr0+RVQJexsW9rY+UJIwWZiMfDK1Pf4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=r1ePfEw6TvQBqCBNa77XMedr76NuUPtOChoAK10dI4/mXbZS//KNmKtH6NRfpLYF/wV8jEIOszNojip3Z4eowJKXi0RIvpXEI9OvQDVIUJjmmuFC8HT8lcKQ03VAROw5tmUUD6rrsE9fIK1uZoVTG6/iZyItqDILVySm+cZe8Sg=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=oYY796HQ; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=oYY796HQ; arc=fail smtp.client-ip=52.101.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="oYY796HQ";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="oYY796HQ"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=sQkl1Z5HYOqLP7YsJR2HvaeAHDjzZaAQkRvBvbAqIJHNFzAluq+r7HlTMN76d3DNlaeZklin3kqv5ZsTDXVwhAlqkRSwuBzQmjIhotP9nCeLAeEhQi1NGlp+bO7E3/qhh6lc4XERQgzS607MeIoIiqWITKP5vA1wFX7o2DNgNvBsFk2aecTt1vg5tCMmsCYG2CtaXT8EZfGuhOQEFuK0NSb0vhT45r00Qg7xz8AEDB+Cl01RwMNa0aWlkMwekeK3OWauoB0h7slqmoZ+R4EbVvlu+xADrvUV3mJvAKt79Ier1oNWoQvl7Uq04feaHbsXFoZkMamFw5e5PtFxLKwgsA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NFIDA+c6c7huWfax6nZ+UZl2C9rqZS4gaOBf4AGys6o=;
 b=kYdrAkptVOi/H7u27/smGFssxz60vZqAWnMcps5Q2rqyOnv7n8EQppeYQQ1gjAwumf8N/raNKe3cvCapwA3RyLClCGSmTcd4tQQIEjIS2KIZiDt60Uy9+6qCrIE/cnPUG+AgUOIEvxCRv1M+4AMUlX5XjvG4Rn+O+PpifCO9C4k2oVrIKxpZOaltPKc+K/TdwTQs3gvVGuSUC0KN3yKuItNVm4/R3w12ttTdD3wUuNjoRhNmqW32qxR52iTR9XoxIzd5597kuHoO7qiszZJjVam3F+kK9TMLQ+20CtRFX4P3EGELL2sXLogv1aMSPwRB8dQ3laLH6JvbXH7Wt0MPxA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NFIDA+c6c7huWfax6nZ+UZl2C9rqZS4gaOBf4AGys6o=;
 b=oYY796HQ7hnLBdY3MoNZc9/xMuJyrPHN1syHYoA6yf920HSsGCyi3l5Ah4Er4ERWGLoTPcA4jGHyzjyVcLTmjPKvgEH8BJAICMJ+hww70K53HgLk2u4HoDukkzp/QBGgrrRnuRLhmIa5UCDGZCD4MSKkdR9/1n6LFQgitiyy8VA=
Received: from AS4P190CA0057.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:656::6)
 by AS2PR08MB9893.eurprd08.prod.outlook.com (2603:10a6:20b:5f3::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.19; Mon, 15 Sep
 2025 08:25:05 +0000
Received: from AM3PEPF0000A78D.eurprd04.prod.outlook.com
 (2603:10a6:20b:656:cafe::14) by AS4P190CA0057.outlook.office365.com
 (2603:10a6:20b:656::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9115.22 via Frontend Transport; Mon,
 15 Sep 2025 08:25:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM3PEPF0000A78D.mail.protection.outlook.com (10.167.16.116) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9137.12
 via Frontend Transport; Mon, 15 Sep 2025 08:25:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T5Su9qe5mW2BQbhRr6rK9Adg5oDYlo2RnaDTUIL5XmFDtRyVpxKoKM3JILcpj22TG1ptF84bVbow5Uq+x1HqaC27Ak1F6qxg9yWjmYxYkeYy8eqCCHr+fPw4DMkDb8Y34qMimZee5QfoCICPzAO969ckgun3SoSS8hzLJK+Td57WC8GVwELSWVNeoBETHvancQM0NJmHzd2k4NuB+0+gLA7FQ2B9Mryn4XFvGYy9Kl3w/fJfWaYasHavSrfpkeYdUXdNa+ETOyljRf2xJGzR4dnqppsa+rssN1ROkAIQu55ojUeQp6K9Kv7exntRuQApDEwMx+6qRQYTYmrecH5c6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NFIDA+c6c7huWfax6nZ+UZl2C9rqZS4gaOBf4AGys6o=;
 b=MXx+QhzdwxypNAJz9+b7R8vlGmFn5hQAG1ZMsmJDSwmVCbalnw2cBSnpojUgI6PS9zb2m4e3qIocuCjFat5YiBZ+6fScdKFEsCuckOtGL9ej2kyBnh9KvCquWutCG8dZDsxbk1HTDUUfBcD3Hi1Glf5sJFh5VDo6JqQHI5r9OFQEoZwIDldkjQa43qvyMVeyiFbfI41PS4zQ7i+Lp0buzy3mN++st00+F9rvLMblm958r0wx4rN5zZYIkPf97fr9sgw8oVf/HMjAjxOjyTtP7/F5uyEIQj4BuHPpJ+yXdNatEqFk+ux7J0wAcfNhdCW1TIzNfqoI4uNogusqJ9rIng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NFIDA+c6c7huWfax6nZ+UZl2C9rqZS4gaOBf4AGys6o=;
 b=oYY796HQ7hnLBdY3MoNZc9/xMuJyrPHN1syHYoA6yf920HSsGCyi3l5Ah4Er4ERWGLoTPcA4jGHyzjyVcLTmjPKvgEH8BJAICMJ+hww70K53HgLk2u4HoDukkzp/QBGgrrRnuRLhmIa5UCDGZCD4MSKkdR9/1n6LFQgitiyy8VA=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20) by AMDPR08MB11459.eurprd08.prod.outlook.com
 (2603:10a6:20b:71a::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.21; Mon, 15 Sep
 2025 08:24:33 +0000
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739]) by GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739%3]) with mapi id 15.20.9115.020; Mon, 15 Sep 2025
 08:24:33 +0000
Date: Mon, 15 Sep 2025 09:24:30 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: will@kernel.org, broonie@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, james.morse@arm.com,
	ardb@kernel.org, scott@os.amperecomputing.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com, mark.rutland@arm.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND v7 6/6] arm64: futex: support futex with FEAT_LSUI
Message-ID: <aMfNPokmfo6AfMfq@e129823.arm.com>
References: <20250816151929.197589-1-yeoreum.yun@arm.com>
 <20250816151929.197589-7-yeoreum.yun@arm.com>
 <aMRTu3lcwqhu-dYY@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aMRTu3lcwqhu-dYY@arm.com>
X-ClientProxiedBy: LO4P123CA0064.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:153::15) To GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	GV1PR08MB10521:EE_|AMDPR08MB11459:EE_|AM3PEPF0000A78D:EE_|AS2PR08MB9893:EE_
X-MS-Office365-Filtering-Correlation-Id: a23e24e4-3556-4ef5-7cb0-08ddf4315fcc
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info-Original:
 =?us-ascii?Q?uBFaEsh6OvAjco+bkSx59SUkiyXzqBp5BWJ6GR2K3q0hpdeuvZxfhbMvzU5F?=
 =?us-ascii?Q?p3PMH2SknduoqKjTXv5/9oyn626ksUiyUkr606iXr/jpIbMSWEK/PcNB+09+?=
 =?us-ascii?Q?fxtKSdcHHggHQcjSNO9cIW+beue3rEr8fE9lOSWeSzWkZwkQTCCgNFyApqAL?=
 =?us-ascii?Q?4PHGqx+2ELA6ugbPMgQydR+ABF5pKGXB/f9eWxM2jwf9HIBpAdJ9++2k2mu4?=
 =?us-ascii?Q?scA7hf5YJw+3wdG35bY5HISIMVBA0Dh6okJHQUE/yKCL/t4O3w48uoO0pWMy?=
 =?us-ascii?Q?S56xXmQRsfW+sKN/wldEL7lITfV15LGzumSEmBy9n/HNi940MaEwv6GW49ic?=
 =?us-ascii?Q?2UCWRXEHLMf3Nw7+tNsQcFCgc33l19Uel3mGIAEVyWM+qWmR75V5vq7r12qW?=
 =?us-ascii?Q?nODStZUm0ilsGENDzYjms7i9FDSDDr/f+MY0+uJVvoKO8DVO/FrAEaKs3/eG?=
 =?us-ascii?Q?if/Yl05k6Q7N9c6X9iyIYs4+nbk1Q5SO7Lu00X6Q1QfdjVjQRV1YYHcsNWAA?=
 =?us-ascii?Q?3DvW0Ym90Cvr/hpQ/uVowumf/3SkWfTEtJ3Hy3Afuozg0YVWRn02dPL0UDaf?=
 =?us-ascii?Q?WXNVC/xdGbTUmagmhWC8N6YXF9MqkN6QwKTZ2glDVUclIh54pGNG3tsVQdbi?=
 =?us-ascii?Q?WmS3bbCArAGbUDOQDKVMR/KI9cj0qvNcMBvsEakf1VB8GPmys4SzucNQrmy/?=
 =?us-ascii?Q?gjjBtOO+FJx71Vc/c8HyLHyeLPaIY/btRORR3/jznTNHU08lPI1UGSbx8M4S?=
 =?us-ascii?Q?A0tWUxZSh5uqJAQdErrQIVvHnsxYd/RtQxDKanbCpBPP5Nc9BfKvpTOcNT9o?=
 =?us-ascii?Q?XFVy+Gw7vqSTP2uOwPTXbKETOWUoPENipT5OFPepZ49ZEQB0NLf0yEcgYLxZ?=
 =?us-ascii?Q?q6T1hi/lkhO6CGLWL5ivKSXBrOTa/5JzMLQVz9pdEgvnr1eJERV+jAIlPzOE?=
 =?us-ascii?Q?nvh5qBH7m/LEY6Zw5qOVbbBwC8Jg193jVqxfA9Yt3fdaCK4+3t7KCbx6pAL8?=
 =?us-ascii?Q?t9bsu5Ja3GEYx+3q3uT34ZzvNJxkf+k4uxcGXf2xnTniT4NsqDe7F+8ei7v2?=
 =?us-ascii?Q?bbC4a0RJlqbCVNu9ORszX9EAhIAdGw2bXNgh4mzsNlUJKN6onDRmzSOBwO3C?=
 =?us-ascii?Q?0enl+u7TpDXN2nY6kn6nlD86RaPdOI4ZXZshsvsSq82HJ0E+0GN5CEukXP6T?=
 =?us-ascii?Q?iXpEG/bF529vzP3XJxxc2gpJa9MmWgR1stlDVK/+XdJ1hgA3ars0TApsuBS+?=
 =?us-ascii?Q?aPfkMQkspTg4h9UhF42hF0ehSOGcfqsoAmMaa0szQxC9ZwdLshyOYrTDzTqt?=
 =?us-ascii?Q?VwtXTe14QE0AJeKkse+Go6Vs7MJV54k3ZUZNN1IiUksRNO+bCpvDOlyjmXBm?=
 =?us-ascii?Q?M7GkSGKiMatVMtwXePcHGZ9Xyu9fmxlXQx4yyAJSEvLZ5f69xIDs07jllBSN?=
 =?us-ascii?Q?03Tj/TEMIyo=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB10521.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AMDPR08MB11459
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM3PEPF0000A78D.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	7fb6fa84-383a-4091-c6df-08ddf4314c51
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|14060799003|36860700013|1800799024|376014|7416014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?A7qbMKVTs3skpxXK+vfPXqeIBr9qAymI0i1g7j5ghgxNNZPP2oMItij7rYZn?=
 =?us-ascii?Q?53I2Z9W/EDIBWw5F2dl8rwjneqBV55Wqvn9li0stMtVAhsKs6bpYllhT7YJ2?=
 =?us-ascii?Q?lweXt40JgDsMJgQDfED2tveyQmPykSN/VuRupSGar4sZDkieY/GrKLuBNI3l?=
 =?us-ascii?Q?lkW02Z932skZgOz8gcyc0s3s/0yBqS3+COqYrffYsunPVEJoTZayIum+f32Z?=
 =?us-ascii?Q?3V6B4wuTZVE0ybk8an9P0vvntOhdfuFoutLEJQKJc0+UcIDQ6CxXXdCe7GY2?=
 =?us-ascii?Q?DCBhxPbw3XYPHPPpvdztGZXxuFcQT83t7i7YtNVIrQFgtJP6tQDR7g3vcJV+?=
 =?us-ascii?Q?TPbkyLOJqWkPWqpMX63bHelXHGyWktKUPM5+AsaKC8uO9BpgYPRzA6/p9aUZ?=
 =?us-ascii?Q?Hbn6oU1xFK7VPsi6ez/BBDA6doVE96AI/ZBF4F4kNuDlieZ0V9jU+boHX91x?=
 =?us-ascii?Q?fEQMuIE5nyic6Lfk1fD7S25HjSE4VkNkyEXuOMSZ70/MPX8JYF1KD/sj1RNG?=
 =?us-ascii?Q?Nh3ZOil+U4iYA1f8YKoi6SOI5IHKhGQ+AKZdfEhTEYpxSlm0NKrkuzSCcZmo?=
 =?us-ascii?Q?I18ssN+9cnxq83PEy1YAmChyIzMCA3XU0+Ifp6AG/iETEGrruYACHhkh64d5?=
 =?us-ascii?Q?/r+UHDD1LBosJNCd5nyW4Iw/WQD6CiFVjAA045ZBnN+WnWE/A7/zHW/DY7oA?=
 =?us-ascii?Q?yL6VAql7FffegHxGdnvGsHwGvsNmjZEulNvLSkKk/MzyDQ33ZlWfeA0HD8zH?=
 =?us-ascii?Q?jkbeY7UYBJYZRTnggBVMhnvZv/FqHT0YRg8JWv3XMzZ7VK+hWkjLMTSZjYii?=
 =?us-ascii?Q?BA2VvI6/B8okeliUF5PYuSKPGbVhwS3oIUTkFE77cx/yYca+aSWf78QaON7W?=
 =?us-ascii?Q?MsGpT+ZzNj0Xl8VbjBVLOhvD9bHkcWEMYhwdC62JQUGEnEpGtaLG2ueLuIS1?=
 =?us-ascii?Q?s+t2M87V3j1TSeuOUSdmGGZCZ/ADs7NxRNjOQV9+r+v/qrIXR1n4WMi19mzs?=
 =?us-ascii?Q?9hI9IkvX5tj/H1cFFDYuEyjvU8OEEy6DgitO15vLxeiblb4wskQXpw85ioB7?=
 =?us-ascii?Q?NmzUgJgbP2sbB/SJdqESpfME8FF6rLLSUU2oOUvjHyjflhQCsAl3H+P0DvXZ?=
 =?us-ascii?Q?sKsm78Qb5+lYj7x2dX0z45LorK7YYeUicP1MmgY6NZ5tCXUZ1E7Fc1CCsF3F?=
 =?us-ascii?Q?HOSyhRva8XKBFABTag7GnV7ccjZNCV4i4MZRE9Nnzh8On23fnleabj6b24KC?=
 =?us-ascii?Q?joA1B4+Bv8oYo3+yWQiCBtbMk7gPVo1nPH2DcwB5X0a+VbNurv86seX3h0pa?=
 =?us-ascii?Q?f/5BCL7Zf2H49JwRSNryV3dsi9UJ0JXsmJ0UsFIkEHj8zu1yWuAOaTUq8n8r?=
 =?us-ascii?Q?NrZvlvLfn3Ab8ZsA4D0CSPVCvfUqrJlX7oqblqmLTaZJt6PbAGZN6jhrPQaZ?=
 =?us-ascii?Q?EGb/EF5YgVB/kI98zXJ+v0kAp4dW9RZ1HMj779bNrZaFd8ZZYyWS/yuQ9SPY?=
 =?us-ascii?Q?9HfuaWdpt+tOEvO/amouv4a6RUrGBPeAz6zl?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(14060799003)(36860700013)(1800799024)(376014)(7416014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2025 08:25:05.3372
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a23e24e4-3556-4ef5-7cb0-08ddf4315fcc
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM3PEPF0000A78D.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB9893

Hi Catalin,

> On Sat, Aug 16, 2025 at 04:19:29PM +0100, Yeoreum Yun wrote:
> > @@ -115,11 +117,137 @@ __llsc_futex_cmpxchg(u32 __user *uaddr, u32 oldval, u32 newval, u32 *oval)
> >  	return ret;
> >  }
> >
> > +#ifdef CONFIG_AS_HAS_LSUI
> > +
> > +#define __LSUI_PREAMBLE	".arch_extension lsui\n"
> > +
> > +#define LSUI_FUTEX_ATOMIC_OP(op, asm_op, mb)				\
> > +static __always_inline int						\
> > +__lsui_futex_atomic_##op(int oparg, u32 __user *uaddr, int *oval)	\
> > +{									\
> > +	int ret = 0;							\
> > +	int oldval;							\
> > +									\
> > +	uaccess_ttbr0_enable();						\
>
> I think we can drop uaccess_ttbr0_*() from these functions. At the
> kconfig level, TTBR0_PAN selects PAN. Hardware with LSUI will also
> have PAN (since 8.1), so the above is an unnecessary branch or nop,
> depending on how the alternatives play out. But add a comment instead.

Thanks to point out this.
I'll change it.

>
> > +static __always_inline int
> > +__lsui_futex_atomic_eor(int oparg, u32 __user *uaddr, int *oval)
> > +{
> > +	unsigned int loops = LLSC_MAX_LOOPS;
> > +	int ret, oldval, tmp;
> > +
> > +	uaccess_ttbr0_enable();
> > +	/*
> > +	 * there are no ldteor/stteor instructions...
> > +	 */
> > +	asm volatile("// __lsui_futex_atomic_eor\n"
> > +	__LSUI_PREAMBLE
> > +"	prfm	pstl1strm, %2\n"
> > +"1:	ldtxr	%w1, %2\n"
> > +"	eor	%w3, %w1, %w5\n"
> > +"2:	stltxr	%w0, %w3, %2\n"
> > +"	cbz	%w0, 3f\n"
> > +"	sub	%w4, %w4, %w0\n"
> > +"	cbnz	%w4, 1b\n"
> > +"	mov	%w0, %w6\n"
> > +"3:\n"
> > +"	dmb	ish\n"
> > +	_ASM_EXTABLE_UACCESS_ERR(1b, 3b, %w0)
> > +	_ASM_EXTABLE_UACCESS_ERR(2b, 3b, %w0)
> > +	: "=&r" (ret), "=&r" (oldval), "+Q" (*uaddr), "=&r" (tmp),
> > +	  "+r" (loops)
> > +	: "r" (oparg), "Ir" (-EAGAIN)
> > +	: "memory");
> > +	uaccess_ttbr0_disable();
> > +
> > +	if (!ret)
> > +		*oval = oldval;
> > +
> > +	return ret;
> > +}
>
> That's an unfortunate omission from the architecture.
>
> > +#define __lsui_llsc_body(op, ...)					\
> > +({									\
> > +	alternative_has_cap_likely(ARM64_HAS_LSUI) ?			\
> > +		__lsui_##op(__VA_ARGS__) : __llsc_##op(__VA_ARGS__);	\
> > +})
> > +
> > +#else	/* CONFIG_AS_HAS_LSUI */
> > +
> > +#define __lsui_llsc_body(op, ...)	__llsc_##op(__VA_ARGS__)
> > +
> > +#endif	/* CONFIG_AS_HAS_LSUI */
> > +
> > +
> >  #define FUTEX_ATOMIC_OP(op)						\
> >  static __always_inline int						\
> >  __futex_atomic_##op(int oparg, u32 __user *uaddr, int *oval)		\
> >  {									\
> > -	return __llsc_futex_atomic_##op(oparg, uaddr, oval);		\
> > +	return __lsui_llsc_body(futex_atomic_##op, oparg, uaddr, oval);	\
> >  }
>
> That's what I got confused about. It looks fine:
>
> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>

Thanks!
--
Sincerely,
Yeoreum Yun
