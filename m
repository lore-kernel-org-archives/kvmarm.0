Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010017.outbound.protection.outlook.com [52.101.69.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF1DB29E0FD
	for <kvmarm@lists.linux.dev>; Thu, 30 Oct 2025 20:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.17
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761856153; cv=fail; b=PKx9dDKHIuFM5rrMRT0rWNHL90gGSjuG7z1Mj88RRoDqXabVTy9lJNGOptnzXvFIyC9LluercXxguDqYO/s7HmBtYei3prrA6/6W/l4sl2sYm2wLLgPBlg/XOwXJ1te9/rCANH5rbqF67Wcp8Y8V7rTnhzIcbcECHfvtUkzNFEc=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761856153; c=relaxed/simple;
	bh=6u1JyRsqeFPmVofNnljtBJeEvgU6B1a6hIy715J2XYM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=fuHOuSFho9XO7d/9j/MyEaLz9brKFAWrClhKU+q7hPH7vhnpe9dj1gIvhVsXaje+yHbM3BLOXC+CFBpYwOetYTQhgkSA6VHglBQSAg4kuzUhjnBQ3oQL/oSCksQaPrnAa1sV1ARZ6Mh3vfZEv9LDVVPa1g4rc6geoUhlRluzN5o=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Xr523/HD; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Xr523/HD; arc=fail smtp.client-ip=52.101.69.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Xr523/HD";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Xr523/HD"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=HymMxEKJypkNzo/jg4AovnAMvzih/ABfvecoVKNZwfoniEH3ij6jgFYGVun8mA8XYnWU14gxrmDj7VY+ImyjCUDlrQdrNgoe6JUkCRGUrkuCoxEabxhasINGpI8gccS4gngRcV/zmt2In9OT8kcyQNjdM4wqAZKXZXKnpbJ6rSYhyBEYuJPf4C7Gmd/fr7hfRSC+3be0Qyo8FL9E3iRPINke+zE48KVYY08171rDcNiUtMteZQQvi2OB/TdGsxnmArXE5hpsLUjynvW6xl0NrC4HFL3e1h79YD7uhgK1gNWlnROw/UmbptDtD7WVOdGhFm+CioAWKRxUDMd6bCGIfQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qyTS16hJCWPyn5a9wQ4Xlp5t1CbWOf/928oeiitgUfc=;
 b=mEFHRZJjoOMOf45gaY8VQAAhDzF/XHb4o8KixVl+AUOB2aj39rJ2Rdk0n4gepugFgGCcinSu5R0c2gGW+Bj7J/UuEJZq2GckamMRUK4L3Xw0yIzVxokUocCzR2an0NDUrmzywM3Gok2SZgf43eHuua4uZsLJKZjX2sJlPjS+N9JwCgW8b/AUbIQOF/jHsiMEZpWLNMsre6lsm8fSOOJpdh43zEF/Gi5VZLDL+B4UVUJ8bAfHbaN6/YL0T8zcBfcmh+pMXG4KSjM7GeBHl2usiwCnLCpF72hmGo6g3hKj1kIOI5C/XH1exrZOlwtQDjKI3cqJREZ9mz64VowRzVNjhg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=google.com smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qyTS16hJCWPyn5a9wQ4Xlp5t1CbWOf/928oeiitgUfc=;
 b=Xr523/HDT0O3+aq5sttiJzwz+0blNHnrIfZIY2EWTfnekT0YuZzg3Hav8EyZw3uEOZ8mTTTluSBU2mE9dIKzRLinJZEPArV0F027QYrhSdUeTPiuXeOM4yW4nlszAohiE0/6WplafKC2yBPIw/Pt/S1YUSPCYDK30c5TbVETFQI=
Received: from AM9P195CA0018.EURP195.PROD.OUTLOOK.COM (2603:10a6:20b:21f::23)
 by AS2PR08MB8997.eurprd08.prod.outlook.com (2603:10a6:20b:5f9::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.14; Thu, 30 Oct
 2025 20:29:03 +0000
Received: from AM2PEPF0001C713.eurprd05.prod.outlook.com
 (2603:10a6:20b:21f:cafe::9c) by AM9P195CA0018.outlook.office365.com
 (2603:10a6:20b:21f::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9253.18 via Frontend Transport; Thu,
 30 Oct 2025 20:29:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM2PEPF0001C713.mail.protection.outlook.com (10.167.16.183) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9275.10
 via Frontend Transport; Thu, 30 Oct 2025 20:29:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jqu/5uC8ICfxRA4BHvCCKDw4OZsXTYFiSAvRt710+lfu9e0hZodcZCgoTTskTqQS68YTFh5pY7oOgpe+74x/sC9nIWrQXggoWxOGMH/XisrlyOMGs4kB9ecjUaf9umtiiDuUQjtSphPQRu0RDZ5SZRkbe0R011td/K+9nq7CTm7+xROwtv76FmD2IWbfQV09vXvhbkJOAR/fMMEKRhtGQOlgEE8EDf5IAANb/tBaFg0lAcMqofdl8quU94qh6ZJsLl+MC/I5pVIZuBIpPjk/gMG4zKLgX/YAJVf86huxnPOJO3+Vv1PGU1KcXqTOpnE4wTKb5L82ROep4tLcvw9M8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qyTS16hJCWPyn5a9wQ4Xlp5t1CbWOf/928oeiitgUfc=;
 b=aQUdJ7KCl9XgqiUUA1rV7p9/bKHQh/2keVsZ8SiD7OKLqNN+bRfWJVtj03FfasLQ8BUNoWR+cjXjkWKiMXvrrIXI1SF+VnmqKcmZyZjJLNBLE2Pw6TUhQKnTTJLq+FsxwR59ZNWNOX/WMwhnMODOzDaT1scMJeMnVGcfNqwq61WbFGMKZjJjIPY1j2yiXm2zK8NcYgatSZIcyDjH19NaP4S/zZ6mAeAc4UFXyjMirbvTSDmjgU9WC5RMRbTDJ4H1SXqjWnrQsY4rEMXC472NiszClyf48H1jk8vCJNV/P1fy8ee7JQWevvIAPNCN9kPFavLQBwan2ymCkpiQtuIT/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qyTS16hJCWPyn5a9wQ4Xlp5t1CbWOf/928oeiitgUfc=;
 b=Xr523/HDT0O3+aq5sttiJzwz+0blNHnrIfZIY2EWTfnekT0YuZzg3Hav8EyZw3uEOZ8mTTTluSBU2mE9dIKzRLinJZEPArV0F027QYrhSdUeTPiuXeOM4yW4nlszAohiE0/6WplafKC2yBPIw/Pt/S1YUSPCYDK30c5TbVETFQI=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20) by VI0PR08MB10427.eurprd08.prod.outlook.com
 (2603:10a6:800:1b8::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.13; Thu, 30 Oct
 2025 20:28:27 +0000
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739]) by GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739%3]) with mapi id 15.20.9275.011; Thu, 30 Oct 2025
 20:28:27 +0000
Date: Thu, 30 Oct 2025 20:28:24 +0000
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: perlarsen@google.com
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Ben Horgan <ben.horgan@arm.com>,
	Armelle Laine <armellel@google.com>,
	Sebastien Ene <sebastianene@google.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/2] KVM: arm64: Support FF-A direct messaging
 interfaces
Message-ID: <aQPKaDQkjkiKKP5G@e129823.arm.com>
References: <20251030-host-direct-messages-v2-0-9f27cef36730@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251030-host-direct-messages-v2-0-9f27cef36730@google.com>
X-ClientProxiedBy: LO4P123CA0334.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18c::15) To GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	GV1PR08MB10521:EE_|VI0PR08MB10427:EE_|AM2PEPF0001C713:EE_|AS2PR08MB8997:EE_
X-MS-Office365-Filtering-Correlation-Id: dc557192-d638-4905-800c-08de17f2f6b9
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|7416014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info-Original:
 =?us-ascii?Q?A2jjIi0wOwus2Gq1kFPkipOvNhi7gKG9IV2WOK+8Ol/5keWFLPpLnkXIhTkT?=
 =?us-ascii?Q?QYLTCvyNhRAqY1X05Q2HNya334wvBwaHMScDgTu36xTqTKx1gNooj0qm18mI?=
 =?us-ascii?Q?NpTdGtN8yAIuC/79hq4fSoATAn1jVLM30nsPPk/V3Lg6l+vaFpT8keC2OvvQ?=
 =?us-ascii?Q?UHJ0Lzl0X53ddSUgUiDa0Yq4Vyn4X2c6PjIuQbjZjIMMZ8sU00IAWJRCSfA5?=
 =?us-ascii?Q?dqGg8LAJljPOZLYqAtCNUlMHen9toa5n1kysxR46PYp+zKltHSEhxh6DJ+rs?=
 =?us-ascii?Q?Ai+wzajSjwcdqtd0puKWc31yEqpNEvLqEBZJIKi+9X03X1L5WH1nNHiqhhxL?=
 =?us-ascii?Q?y/p2+JBggEJKZ4FBDmNubfF+9ZpEsPcw34HnbaTNghc4UQHJcPxYb9OxM/n8?=
 =?us-ascii?Q?Myk4bGOvWQokorjuj6rdTU1euXtOdMo5ft9+Q1HRG9tf8C1K9AvwPkHB+hUA?=
 =?us-ascii?Q?gUrCWegvjZeeQuanMQ5Yq6xtkC62wYEcaHqrPN7B8/3pjVmr3BHrIG3tguqo?=
 =?us-ascii?Q?07Fq7kEalAdvRxEZzH6EkL1lbT0HLOaI8PdfWdaq6ugKCqCpq6XhPuMkIAsJ?=
 =?us-ascii?Q?cdYCRMxJYUnM595uIaJKX+7G4aF+7xWEj2+InII0u1Zuo4EgJb6jyS5fHJ9H?=
 =?us-ascii?Q?Zopfxush+1hCkZchq4lO1fWFuEKT8Zsp8e8PA0miCstP3PikuHDUoiFqkYZK?=
 =?us-ascii?Q?fM4UYgvOBU1KCYGy9oJ1ycOySALZKaC19WVOD3IhbLFyh+HnxUHhAHZWQG1L?=
 =?us-ascii?Q?YXEacRbrdyw4nnwF9PMb3fjKRI3islLiImGKyl1ZebTlmH+PwsHtMHv9RlsD?=
 =?us-ascii?Q?BQvXqa60w4NqIN0nhleqMJnPBKx5TIuH/nnDDAQe7J4asDR1nIUykkFL9W5B?=
 =?us-ascii?Q?YnE3x+zBIw2StgzU9aBNzFoKVPwGh97FGmcgpDlQwuhaIXC8cXmDXzVmq5gk?=
 =?us-ascii?Q?6s11CfHh++idOArBD/sEhMOCbayJCeUn7XZ2xY+Y+6RLM4F8NkgYscmIZJI3?=
 =?us-ascii?Q?l4NU8YrWAK5fudTc89Ylz2D26bUdMIhM8u2QgLHOnXdn5so7f9Zx95X5sumO?=
 =?us-ascii?Q?nNb99/Ujh+OBcnKpDABX6uZdX1Cz5SLquLFTeNlCatEiv9UVMY8YtdG6y7PW?=
 =?us-ascii?Q?evvbBI7T6U7IMY5VjS4rS0USK52iYccljiY/QIA0K3gCwh7Y4O5MQekOwoCx?=
 =?us-ascii?Q?PDyuik+3nvP0BtwfGYeskIRrNG5zEOJEPRJs2kR2IZ/HIiITFy/sK40ok43a?=
 =?us-ascii?Q?nANwI7MnDvt44uh/QTOIb77b4tHdWWPIq7JABPUujkA1tFqfEH/LgntN5zt7?=
 =?us-ascii?Q?zWR9wMRjxPXaV1KKr0QYyiwHZFr/+HFOqSgganyxG5Rk9i31aX5m42elyOub?=
 =?us-ascii?Q?G2rly3GaWVCyFBUw2C2e3HYkgv2SRC1jTslckAQta9XyzfPRXWUzrlm86913?=
 =?us-ascii?Q?hVhFWzOo6x9eu6F5wfHVqcYeWckWre9pzgRDnNNo5oTWa2SDrPNowA=3D=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB10521.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI0PR08MB10427
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM2PEPF0001C713.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	fa6985f0-160d-454f-896a-08de17f2e187
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|82310400026|35042699022|36860700013|1800799024|14060799003|7053199007|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?lhaYipMNnzwptkc3NfjFrFLvms37cONEeNRbhKf9fqt7erlimkRZ8AUdNylA?=
 =?us-ascii?Q?cbWWFtKEWMl0cGFIwc7dmOmhG3J/hh6021YQbiqeyfRnzlsIir1xMs6IrtxG?=
 =?us-ascii?Q?ruQ8LXKBwTanFAwtMcU2/z8PKjJQcv41Bq3PsbeVAdGa8l5ruApbQrcZTKvn?=
 =?us-ascii?Q?3t9VlVnhlN77i79SazuIP6HcAo4sJC+PatL4aPDAq3kJcoPeyB0c91vxJviT?=
 =?us-ascii?Q?s90LjDQk91DwEu1ufE4d3HT/Szp/fjQRVrPlxcO4esZOp5svXziIYIdJCYgL?=
 =?us-ascii?Q?2eAm/prJaH354GNRJEusVKDdQrhlCtc0qD+kSnxA0A/vDYaHsWm6+mUMEhFF?=
 =?us-ascii?Q?RnL8wAJ3Ue4u2zqm2z678bupgyWhxmtMapv7BMq7XrXYq3byOXNeHlxDd3mU?=
 =?us-ascii?Q?7ijNzgoZbL7s0cs2Qr93oarHH1rJxVmV368cLX+Bbm2bHxOcnKbKN3tVLfew?=
 =?us-ascii?Q?147BhbciE0YTpyXywkUZFYoKk0MQsEt4p/wnwlK/d2hvphdP1MHYb7fB971c?=
 =?us-ascii?Q?PQVhXiVXfYEL622zZGDAMYQzEUFztdJemT1wlXehGu72pmzySLfBXRQW32b9?=
 =?us-ascii?Q?bbXlrjzMv/HzEajBXt+gLbm3XY3JDb6CpLafx+uikWgcLZHI0o0EL6FSvvQk?=
 =?us-ascii?Q?6Bb97ht0TD6d76Y7+ENI58ehOiLV99Cb+rDgppWlSODZFm2pYZmSgQdODcPk?=
 =?us-ascii?Q?1i2/v39GnQCB6XG4qurtu5uAjyP4kxX2F0ODU9JBSxY32sNEW1YdCS8XDxjd?=
 =?us-ascii?Q?MqfY7JG6lvNKlmaBUAuvfmDuBvCf0WGoTzFGHaNDKzpHfqZgKqguvuGJ47Js?=
 =?us-ascii?Q?YVH7uGUM+QbTD/gEIyEQkbewT+rWn81tsjdIlykhsWvPJxq0BNKdWY+ivlav?=
 =?us-ascii?Q?0gbMyQ3NPqrRmtI+ynJrl8LWs4/9xvduDwhpWbK5xurq8Eytm8204wznQDRJ?=
 =?us-ascii?Q?4Ae6IPVQESCENso52PULZz7W4/d/kA4i7AvZFYzw0VYwoEBojJbRBZbahrF0?=
 =?us-ascii?Q?KKBrtX1gawBe4FoMrcOeaDZcx1xlcTjG7/fwmFm+TiFmFe6+iuQG1ahdaj+d?=
 =?us-ascii?Q?M6j8uFP3CIpiA1Hs/ZwRj80g+9K5ryCcskQmFND4o7M1JVU3d5eEd40NphPB?=
 =?us-ascii?Q?ccpviR/ifwFyb/u/zBQo4T5+4rMcC3vXreYAlQWbwjS1TWepFf7RAyBM2hvm?=
 =?us-ascii?Q?DNa/2cfc5xtMqSmbvuN83g+BEmkVWO/unPDwRx8lnlS1JPC82coP4hXSNBOQ?=
 =?us-ascii?Q?9fA7EKEhPS9S+XE3L1PYsu42O4hXMMgmxy0NWFpv0ha1MmiZUt8umuIZ4zpO?=
 =?us-ascii?Q?niq9kqeNYvV9xS8gxKpkapOFP9TUgbFqumqquTirrDaeZMMmEtp5Mq3WZg6o?=
 =?us-ascii?Q?DSD8Kzgqc92sg1sU7rLdiQ6i/46xJ++R3I/omaQdsrVHOW2R67v1BT8o0GNb?=
 =?us-ascii?Q?cjiF5gPQ8017J6eg2Tst1wa+lEnDfUx7y9d2V3t5cmixtVo4XreO3DgKl1WL?=
 =?us-ascii?Q?MG4ykgcUBBxwNpbbSdW38qL1ztbQj7PPeMwJs15p5+anJChWeXNerOSw9xh+?=
 =?us-ascii?Q?TNIHQ3oaSno1KNToTzkTQFH2UguYUukgu4AqGr0X?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(82310400026)(35042699022)(36860700013)(1800799024)(14060799003)(7053199007)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2025 20:29:02.1139
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dc557192-d638-4905-800c-08de17f2f6b9
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM2PEPF0001C713.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB8997


This series looks good to me

Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>

> Support FFA_MSG_SEND_DIRECT_REQ unconditionally.
> Support FFA_MSG_SEND_DIRECT_REQ2 if hypervisor negotiated version 1.2+.
>
> The second patch was part of a previous patch set [0] but was dropped
> since the use case was unclear. A clear use case has now appeared [1].
>
> Tested by booting Android under QEMU.
>
> Best Regards,
> Per
>
> [0]: https://lore.kernel.org/all/20250730-virtio-msg-ffa-v9-0-7f1b55c8d149@google.com/
> [1]: https://lore.kernel.org/all/20251027191729.1704744-1-yeoreum.yun@arm.com/
>
>
> Signed-off-by: Per Larsen <perlarsen@google.com>
> ---
> Changes in v2:
> - 1/2: Drop support for FFA_ID_GET interface in host handler.
> - Link to v1: https://lore.kernel.org/r/20251030-host-direct-messages-v1-0-463e57871c8f@google.com
>
> ---
> Per Larsen (1):
>       KVM: arm64: Support FFA_MSG_SEND_DIRECT_REQ2 in host handler
>
> Sebastian Ene (1):
>       KVM: arm64: Support FFA_MSG_SEND_DIRECT_REQ in host handler
>
>  arch/arm64/kvm/hyp/nvhe/ffa.c | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
> ---
> base-commit: e53642b87a4f4b03a8d7e5f8507fc3cd0c595ea6
> change-id: 20251029-host-direct-messages-5201d7f55abd
>
> Best regards,
> --
> Per Larsen <perlarsen@google.com>
>
>

--
Sincerely,
Yeoreum Yun
