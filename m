Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012001.outbound.protection.outlook.com [52.101.66.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CC154A23
	for <kvmarm@lists.linux.dev>; Mon, 15 Sep 2025 11:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.1
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757936552; cv=fail; b=em3OHwZAf8f+XTgfgOx6DOXpT5s3a31PDb48mALoiBHGdFcn4kXmiaNz4OwHgv/Yltdmo3qNTZB5+0xfZdNCC7zUDUW5KHIRdsXD+2zoukOHmLf5giIc4dBEN4WFR1wGfl/wOdbUZ0jrulZHfRrhewtR8X3cZPsDeuZzDvBfCBA=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757936552; c=relaxed/simple;
	bh=iFdlfloJbK5U2gchL47+kG+UkHageu3/itlFe5q6VoI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=jUBFBb45KsK930iqIDLNsKS0LlWAYKMiqaFnCC2wKlNZpYvqOWt3nsLhzxOhVT0VaihAaXJONPFhUViK55hMLVWkgSMneicsN+U9gZWlK1EIJNnKOW+5rc1qnpLeJgBkyckxF5VZg3Hl6kDT1GYFWKGOGgesbN4go5aKzp3Rhw8=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=h0Fwk+qZ; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=h0Fwk+qZ; arc=fail smtp.client-ip=52.101.66.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="h0Fwk+qZ";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="h0Fwk+qZ"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=S/p0iSssBj6E95JOm0xjFSincuIwUAWJwtmiQxrt89xnFyVjfsa0eU/MJ9Y3/IL2CbRKkPGRvoP70OQ/rJRQ+4iQrVQVLhyz0T1DAmDtjdIu48zRHyk52MneeXtRaF89/mMzvGq28RXRM2hIPyk2gkY9qg6DLwJXjayAs7Li2C5pEZlxDMPcNPPmVvr1exXjosz+2HbJWyUVnU59mN6RF1yXpvo8AdEe2byhnGDC3FFGjXwdoWZwGBDemP2ZePpZNQpInwsC4BJOMNj7vhiJHARyrmgTatDD3I3InaiPglmYaLarHL8hyDRQcxC76VN6O46ReEkeD05r9rYPpx8XwQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4ejusfX8SPNOSZZa4IuWUm11X2QR+ZnIge2qV735oBE=;
 b=amjF71d7eOiM6wKjNZn06fE6Z9mXr3TgsGluxFtlQqriEwQ8HofF/n0ghwwVJ9EynkR/AxOhhS4xsnA0iW36XGaYIdanFbO/vQC2uxG8ujIyrG4HHFCKrqxZtbHRdxYuD2OSq9Jh20BFCgIpUUnbrHr4z2coc0lwjqykOY7w8b1p3e2RmwoEVQJuxd2pzlH8VehP9s6YEgTEHgwAh8ai9DN0dZz7Bzg8u8FhXQq5Eo8MKZkUEpiP7ux5PrkredAJdkCJPmh7eQJ88+mj5FKrcWidpssaJFBCtavMNkU2zENRr9CIdvUUuOZ38uGYBzIQexiYifFv/8g3P5jbi+QMcw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4ejusfX8SPNOSZZa4IuWUm11X2QR+ZnIge2qV735oBE=;
 b=h0Fwk+qZ8GfUK7nJGMP9XWQBe6iESQxoKP0fTRagq9bF09XQicNqMQI71R2ziT8+tngDS6C5SnCCfU4bF9+32eFGlUp2DkByQJmm2z+uTdSotwKJTrKSiitWHDXL9/+95fVI6Xr0+C7YF6e+QkrFIASMf+E0iPvMuzWVWSGNyAI=
Received: from DU2PR04CA0157.eurprd04.prod.outlook.com (2603:10a6:10:2b0::12)
 by DBBPR08MB10819.eurprd08.prod.outlook.com (2603:10a6:10:53a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.22; Mon, 15 Sep
 2025 11:42:25 +0000
Received: from DU2PEPF00028D13.eurprd03.prod.outlook.com
 (2603:10a6:10:2b0:cafe::27) by DU2PR04CA0157.outlook.office365.com
 (2603:10a6:10:2b0::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9115.20 via Frontend Transport; Mon,
 15 Sep 2025 11:42:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU2PEPF00028D13.mail.protection.outlook.com (10.167.242.27) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9115.13
 via Frontend Transport; Mon, 15 Sep 2025 11:42:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SZhhERPUH1TQ0+Hr9ylpbR204J4isHCs66gjz2mNUe0imzA5AHUJD89ULTHz1uYLO1+yO/nbEYgz+LEaKNW5d5Azrr7aQwCN7TF1EiDoe0kXIQYL5ccP67Y3P7oZ2Bj9hgSTyb/pcmo5c5LkH5HzYp3m7Doil09pVUMR4sMHN45Rp060L8DibMEjmz++4kMu9Hls5ROUE3PJUt0m7e9iWio0GXB3Fx80pJnLMqfna4Oz61jzmFfhG3tIEJ/pfXa6cY7jV1Ym5vkNhU3gsrXF8mWThVo1A+BwNZsbJo/X8dDYR2AeVoxOx3sEvxgnXMFbg4pw0OMg1oH7NlpCeXnEog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4ejusfX8SPNOSZZa4IuWUm11X2QR+ZnIge2qV735oBE=;
 b=tN9wLT4iqeDmycG5Wz/dlL2cWstj+jsdgzSaVqf+J+vslY0HgzoTUacujVdeuvUpzO7DdZ+MGGL9iRRPSGhFURx0ruwkFgkIFgA2CvVeMOprARjCNRBlXxrxDDGhggTT06Hxy1QDpc3v1vJ2sXU0P/h7tBQpGorL4ncUwMq8SqmvKpermmqQcoy1xHLH0aUvTOsPxiUWvBCp4S2WNmWdN8CGTlw0ovt5zYRKl83LNnNYjCA8g9mWDU8Y8M1Y43unz4iql2F+FEviva92yZcgXFwXC0difpdJhRkSc4qQjaavT7yzlzVF1W4CHjmenrCN1hxFOEfi+vp8MTrCc50MDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4ejusfX8SPNOSZZa4IuWUm11X2QR+ZnIge2qV735oBE=;
 b=h0Fwk+qZ8GfUK7nJGMP9XWQBe6iESQxoKP0fTRagq9bF09XQicNqMQI71R2ziT8+tngDS6C5SnCCfU4bF9+32eFGlUp2DkByQJmm2z+uTdSotwKJTrKSiitWHDXL9/+95fVI6Xr0+C7YF6e+QkrFIASMf+E0iPvMuzWVWSGNyAI=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20) by DB9PR08MB7819.eurprd08.prod.outlook.com
 (2603:10a6:10:39b::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.21; Mon, 15 Sep
 2025 11:41:49 +0000
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739]) by GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739%3]) with mapi id 15.20.9115.020; Mon, 15 Sep 2025
 11:41:49 +0000
Date: Mon, 15 Sep 2025 12:41:46 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Will Deacon <will@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, broonie@kernel.org,
	maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
	james.morse@arm.com, ardb@kernel.org, scott@os.amperecomputing.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com, mark.rutland@arm.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND v7 3/6] arm64: Kconfig: add LSUI Kconfig
Message-ID: <aMf7ekA3J6Uhh4h6@e129823.arm.com>
References: <20250816151929.197589-1-yeoreum.yun@arm.com>
 <20250816151929.197589-4-yeoreum.yun@arm.com>
 <aMRJK3x-K0HktAPA@arm.com>
 <aMfthATCr5VZcVAH@e129823.arm.com>
 <aMf5SlYGhOFLSU1N@willie-the-truck>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aMf5SlYGhOFLSU1N@willie-the-truck>
X-ClientProxiedBy: LO4P123CA0435.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a9::8) To GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	GV1PR08MB10521:EE_|DB9PR08MB7819:EE_|DU2PEPF00028D13:EE_|DBBPR08MB10819:EE_
X-MS-Office365-Filtering-Correlation-Id: b6cfbac9-580e-4bb3-e03f-08ddf44cf0f7
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info-Original:
 =?us-ascii?Q?RJdhLnNKCZQe78sFMb9uGf/c/rQoiBmpXS9j4bN40TNBzrrfXaHIbzzK5bRs?=
 =?us-ascii?Q?qELxoaIzTn8qPE4cmu+dYZx5Gydeu07OMX8SDssmdjZVNqLSkyafi+A7a7jk?=
 =?us-ascii?Q?aYGCjFlhO4KQ4l2ywjUeB24wTxgZGvKO1/CSqW0WzPMPXhBVfdxVjex3ujRI?=
 =?us-ascii?Q?27YK4oMCrB4a97+3VU++rDyNSAF28C0LmiRyJ3mxPntvyjGqU8NbSnyeV+2+?=
 =?us-ascii?Q?QZj9EEdDW9NNm/UVZhcm8BWlxaETOiGGKN+ScGOakW/t4J3gWtGW7Yui4yqC?=
 =?us-ascii?Q?P/x6grerRzHMuCFhrk8QoFWSkUmO5B90a7uA256YXfx7PVuZ8tHpEAQ8iN7E?=
 =?us-ascii?Q?T0H7JAXHpw1TCwZXeSWGaXcTjKxAMqBmMv9ZYJx0hoTBOtaWsqLF0tqiNQZN?=
 =?us-ascii?Q?1o1Op0T4/51e1koC4RBxxjchH2SAR/++uNjeWmZjwFQnctf6GdfWEtz1rVJD?=
 =?us-ascii?Q?QeHATUq02kbsqaUMD79/2ToV5vqs1SCU+5qrZCOWri0BPU2pt/6vDOqrzAip?=
 =?us-ascii?Q?uIgASYGi/jIucuiZm4mrOptmn9GjyDQ55QFk6ZNamHlio/MLR6Bw5vy/fKb0?=
 =?us-ascii?Q?Upi7SP4cGUXHiq+DdJ+ZxII8E60R07Z3ysuZ+OlXtY9ed6SfhSLWGUmB0NdB?=
 =?us-ascii?Q?wtheVzfiYvmJsaZ3OzXN1agmUtWtmc7+zSMaLwK84BDhMDei0UExprIg8yzj?=
 =?us-ascii?Q?LzcScR/c826Tt8bwoRAfHlUhXtLU+BxHgoV4aj1PsdPaTpVwz24em6xbMhcu?=
 =?us-ascii?Q?lx70fge90wEp5MqoKsGXCqpn4EVP7ZXwD0oLO5pUh4EuREn8hqnf6CCrBDGc?=
 =?us-ascii?Q?GBzonSfHsfhzAAza4BXu18JQM6RrZ2Ne2iJW6w+r3JfuH7VAkxMWkdMtTfYk?=
 =?us-ascii?Q?xeiIEtfhv7Dqe/mSjbU+SUWwrcBWKr59lOObEoEFB+H0Bg2ZcW8QKTd4dJcd?=
 =?us-ascii?Q?OJAsessN1wkNeuL8Sf/ahUCD0xwuhbX3v7FbxaCEYQ9G0LvmRuzZ/SBLPmks?=
 =?us-ascii?Q?49ftGqffM65jHS0F1dL81diVhMxa74kq0BJ/yENzpkzumMaAMd7KHjtcuaVe?=
 =?us-ascii?Q?WVKujidKqzJCn01DuyfMH4OYtw2EvTUzlWxjn2a1MF+cy3h4T875dVuNpYsV?=
 =?us-ascii?Q?+iumC/Ur/I+Q/8bcoIWGknCK9d8m+rgW6j1uXJxa57vLVluaG5O5pCBKtg53?=
 =?us-ascii?Q?7Y4Y2iFHU0u8QSlal7VCr0CCyHnamTE5tdK2bZYGEcyBtGgmmZ3f5D+aje00?=
 =?us-ascii?Q?LB0Jrxt+Ipun+Y+ZAiPTz9lPWM9zKoUpfrkLt3HFwn8aoo1ODU2h46ShhNyE?=
 =?us-ascii?Q?atXA6dkbQfGs5hP5uykj8BOy+vR78ry16OiKx1gcafgSCBh6WpTrA5niYU2J?=
 =?us-ascii?Q?NoMZptGlovU3e3UwLuXD5/AyKDhc?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB10521.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB7819
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU2PEPF00028D13.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	7db51c3c-8cb6-4453-704d-08ddf44cdb7c
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|35042699022|14060799003|1800799024|36860700013|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?5amKXZk0uBdvoqk4oqN+BKtdDUpUF3z9hOSYyANg11TFCyWi0qyFHObq1gTy?=
 =?us-ascii?Q?E0VrG+Qs/JUbEr0Xaunu+vOOMb4phZvzLGvVMe9ypSl680YpSR4c8dU2Cpba?=
 =?us-ascii?Q?38tVq5wqfrD45RJfSu1qLNn06rMxiPi4Ldpvq4AFeDfSZBvn31yf6bKSh+vp?=
 =?us-ascii?Q?8n/kD+MDoZCxN1BrTQbuk3P1057G5pZ4hChjXenBU8DDtDtbzxcKspgNCM5l?=
 =?us-ascii?Q?s6/JgGmIUCxWcgvYe8Mk/p/UlHnWyul4gdfZtZS4Ekqfd8IDbsmVoQiCo8ST?=
 =?us-ascii?Q?jm5HiFwpwHclJfaiYA4x2n/HPsSdGufdK0tJEvRg9icLdVey9tNpyu8Sdw0S?=
 =?us-ascii?Q?RwyuyjnUCSWNm21046TfhHwx9Nb1Og6GRkWo9dJgWG2v0Z9OJq+VgG73e057?=
 =?us-ascii?Q?yF/fko/gjseXPe9AjqCWnVNTRq9nZh+qYAlahDkmMAJpHMDICWh28Wv9raBd?=
 =?us-ascii?Q?uw8Rznt/CHxLnnsXwbbkkCrq5RQo5xoqHWsSiMPQTrDSleRJyj25SVUHAfxJ?=
 =?us-ascii?Q?GW1/MhfmLY11yE5X+YQRQ82ndqhrJRj3gRuzRPxklVrvjjcEm4WXlPyRJW3f?=
 =?us-ascii?Q?BzbEaX923v7tJTtnu5YTbmdXXpN9EQocDd1kXkmcMjCoOLaSLY1BOpFdX9NI?=
 =?us-ascii?Q?n7z1Si5UbEMAJM7NfAdbzj3DkxmuVnlQ2Hqi+ud/rTjq90pe9o6qi2di7lQN?=
 =?us-ascii?Q?+nqQ0cAKhLmxHLe+NV6Jk2f7UA/eF7scBBXj8Fcw03TonRY1PizgmAW14rYz?=
 =?us-ascii?Q?kO4lXCJWVlBH+s4W+a7WMrsQxIqNgztXPqE0PzJ+3xr2E49YPActR9kHRyg6?=
 =?us-ascii?Q?dSekgGyxAA4OTWBUmNkjFrUS9C4YY2xMGdGNRW5fwVfARq3BLiaWit/YccW6?=
 =?us-ascii?Q?l1dr97hqhyljxVLnlGlKNq/g7u/+rQ+ia36Uk+q4z3Ym83obxcpq96k6t8Db?=
 =?us-ascii?Q?/pTxTGyxk2ujS6A3+ucqEVsNosxaCXyEctzzGqj+YYVu6463I75OozixsxyM?=
 =?us-ascii?Q?a1ouBi/yyDjTFaS4cI2/3dDlEgNDVYq/E4IiscWPGpK00yO7XhtcwZNJfRoO?=
 =?us-ascii?Q?GVY0AKKQr3UivfUok8q41+DpLHczthJfeRigVj9tl9DcYyISElfhXD2EOTMv?=
 =?us-ascii?Q?UYq/ZDNVlq1lJ+H3DvcRAGb+GY7c9dB2vEJJuwcSKhC0V9Dmg7bfeX2ZpAOd?=
 =?us-ascii?Q?yRRn39I08Hvq2MWTlc4i6KlsJtR4lXsUu5N7MJu7u58TTEUiK1sMB22WVXFX?=
 =?us-ascii?Q?eircf9Y3g8NKy8Zk0Dc+ixmkhGv+/rbqytFw8LZI810gbJZh1ZUKEvBfq+mT?=
 =?us-ascii?Q?tsOwBLAqgcpNNPk8CkDaoPfjjNHZtzdCqL8tjwzWeuZ6gF8hJY5hrPjAMD1F?=
 =?us-ascii?Q?Q8t5PWdRMKZWkpPa1uKdELCrNS1bvQ0nTbiIDOxWD+6EWbzpQtt3DiT7Vyml?=
 =?us-ascii?Q?GBIzANDJ2IkTk9/UJHxVEFvv1n68lzpMYKMdtA0CB9sqmzC7HiUih9T+Um87?=
 =?us-ascii?Q?aw2yw2wFNfHBZcA=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(35042699022)(14060799003)(1800799024)(36860700013)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2025 11:42:25.2854
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b6cfbac9-580e-4bb3-e03f-08ddf44cf0f7
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF00028D13.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR08MB10819

Hi Will,

> On Mon, Sep 15, 2025 at 11:42:12AM +0100, Yeoreum Yun wrote:
> > > On Sat, Aug 16, 2025 at 04:19:26PM +0100, Yeoreum Yun wrote:
> > > > Since Armv9.6, FEAT_LSUI supplies the load/store instructions for
> > > > previleged level to access to access user memory without clearing
> > > > PSTATE.PAN bit.
> > > > It's enough to add CONFIG_AS_HAS_LSUI only because the code for LSUI uses
> > > > individual `.arch_extension` entries.
> > >
> > > The subject could be improved slightly: Detect toolchain support for
> > > LSUI.
> > >
> > > >
> > > > Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> > > > ---
> > > >  arch/arm64/Kconfig | 5 +++++
> > > >  1 file changed, 5 insertions(+)
> > > >
> > > > diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> > > > index e9bbfacc35a6..c474de3dce02 100644
> > > > --- a/arch/arm64/Kconfig
> > > > +++ b/arch/arm64/Kconfig
> > > > @@ -2239,6 +2239,11 @@ config ARM64_GCS
> > > >
> > > >  endmenu # "v9.4 architectural features"
> > > >
> > > > +config AS_HAS_LSUI
> > > > +	def_bool $(as-instr,.arch_extension lsui)
> > > > +	help
> > > > +	 Supported by LLVM 20 and later, not yet supported by GNU AS.
> > >
> > > binutils 2.45 added support for LSUI.
> > >
> > > Nitpick: we tend to add a two-space indentation from "help".
> > >
> > > Otherwise it looks fine:
> > >
> > > Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
> >
> > Thanks! I'll change the Nitpick and send again.
>
> Please don't resend until we've concluded on the CAS discussion.

Yes. so I'm waiting for your comment for:
  - https://lore.kernel.org/all/aMfZI2VVV5zEsTna@e129823.arm.com/
  - https://lore.kernel.org/all/aMfrR0vserl%2FhfZ3@e129823.arm.com/

Thanks.

--
Sincerely,
Yeoreum Yun
