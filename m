Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011024.outbound.protection.outlook.com [52.101.70.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE0532FE04E
	for <kvmarm@lists.linux.dev>; Mon, 15 Sep 2025 10:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.24
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757932810; cv=fail; b=R4WKWW7BoZhA0qDsamUgGG7r5WCMIWYSpVdEwINAPXOwf1CX6Wc8zFQ6Lp8dtcPM7dq4iy7sElwWLmWI3sfVuPQ3pZRF0l/AV0zUXvMhBI9/YLYNeL/3rcdpSNDPqtLmttheJJjMecqHBNyRrcd6IrO8/VJI/q2VV2fiQumKS4Y=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757932810; c=relaxed/simple;
	bh=EhKRTZx6YBoBi4/L6UvbMSbxSOvp1mSMQgNk8dI1w6E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=vGYnpMP6650xTTnPuCH42efk0ZvAw8DHE6jb/XvANLeUqtRlM2ovzU7T0g6zYd8hVKAFb/YNB32QYMo+f5eSsOc/oLTFIgLSxD1qZKBMW+mGEzDHMphpLT90bXGm4w4CcirtS/ZbuuW+XG3fwPk5X3kVSA0A6zD1OrDrZlUMpi4=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Fa9Cnd8t; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Fa9Cnd8t; arc=fail smtp.client-ip=52.101.70.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Fa9Cnd8t";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Fa9Cnd8t"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=RWs9wWGO3uNao400JQ2wqvLquLGlnySYg12DnfyhjX0pXaz4Q7nVsDuok2WxpGWLQq0636UAfR82GW3Bkgf3mEBpnAZWr1o5Dt6EFEBWtC4R6//j4wBWuntQOJh4tfq4GKIC6Tu5kjED9eGyLjHwV8P0CaytksihiLbRlnlRgRB2iid9BCxQXGzvaDqu3WeiU/Y7UnXXLmy5GCS3K1e/dpkFj8ac2PgX80sZ632VuZP+3ZU8I3jLxnHSk4UJvzZrXT276x5a3p5ZZ04q0SMRI1AaBUVDWaqUQwg61G8WV3WfbSzqvskPKcEQS3kjxAMXT3zWkPp48Zp+87R8Ft5BwA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aWaqBNNHSeUnygn0zRC3EYC3HCEkn6Lavg9rsQGO6E8=;
 b=h2+VokwpUkf/PG8xATZVWkl1qpZILlYYF0gwXEvqeb5J4Bifiew6ABjLMZvav+PF+siWgv52p2feQ1J6ftSUC484E3tnV5iq5e7QmHXJl5eGAVZ6YXcTRg73VN9iknWrVD5LzXp+w5VXNPvVZTUnrOB+ExZiMTyn8QyhLasssUeKU+hhtbd4ZJ6CmzlB/fDFelE4JvDfNRcIpvnXVJ3UA96sVBZpGddLnXArZco21ceSCNFeMyaFhOHHY0WbvFcE6Cfz9Bsl9/EvKNeMWO2HfGgAlnc9DnUNnjcWWZG7W6s+vkLIwxy4mG7KDjk0Uacg1H/s93Fe2LMU7/5+Jwz04A==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aWaqBNNHSeUnygn0zRC3EYC3HCEkn6Lavg9rsQGO6E8=;
 b=Fa9Cnd8t5AmBYdTpjJvTggJ37JR+ryvREg61Ri9zkZTKFbzHtx13kUOO+o6DS4DTGfm4fH7T+2rZ3wPwnLdEunse21upr1Fj5Ng5+yDpi44kWTS1blWqB/LdynllMvOV425HvevCeggjJOi7sAGlMTdtKwbMl8HDIArdJXEosJU=
Received: from AS9PR05CA0248.eurprd05.prod.outlook.com (2603:10a6:20b:493::27)
 by DU5PR08MB10849.eurprd08.prod.outlook.com (2603:10a6:10:522::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.21; Mon, 15 Sep
 2025 10:40:01 +0000
Received: from AM3PEPF00009BA2.eurprd04.prod.outlook.com
 (2603:10a6:20b:493:cafe::4b) by AS9PR05CA0248.outlook.office365.com
 (2603:10a6:20b:493::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9115.21 via Frontend Transport; Mon,
 15 Sep 2025 10:39:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM3PEPF00009BA2.mail.protection.outlook.com (10.167.16.27) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9115.13
 via Frontend Transport; Mon, 15 Sep 2025 10:40:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=inqjdmQiiK1kEK16wxNP3Oaq0Rppn+g0NctYBpnRxS7YSLXlb3phTFd3Mu2TloC/IR0F0wst+0I+i7mPv2/MDzDByDWEMdswBCU6T7mBeRwhSFnbfV5L1J1U8j6XjWpVYav1n/p2o1eNWjFCIu8JMo+g4O9ZxwLbTAqh+uvdhzl+lw2sM4NXvEkqpi5jnftsGEdmDtmEnxp4TQRsmVluW89T9UtlkgK51MI1fUKz5ZBHed759ZIBruiA5oTQAyvyOrWYhAuTIEdgLLvz3lgp47u9gZgw/ANIyOWHhPL+0GlQ72KRnIHXAe8bRJSQJf9T2sNqWsLnRrLuA/cF9FXZSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aWaqBNNHSeUnygn0zRC3EYC3HCEkn6Lavg9rsQGO6E8=;
 b=a+2Z4Tm+FROw6Z3yFkkTGr8QNP1vcWQ2KKg0yKVkOKBX79sWHuwNRVxAoIl/ZQSO3oTYqmZM0VdzYcC8+a8ErQdE8Z+chiOuNwmXeb8UxhuKfYeRY1SSUuzMqlC0fDCYzwYsv5jedTdP+6SY8RzcTcuZfPMTZ3Bkc1NwXl1z+p1y5wVMeh2gIPbiYByGTajx0AFZa5Gb4elhNQ82PD4nSZsqfOFWYfc9kOLyw5iEandgR0fcOkFDs9rANjTmufbnOceLIc1d03nxx1fSUKwcU8evjNtuSvtjivH/DRZjFbnmLEd4AI01wK1k3hHtPd40HsNgJQRXC6CFUtJPzSrSIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aWaqBNNHSeUnygn0zRC3EYC3HCEkn6Lavg9rsQGO6E8=;
 b=Fa9Cnd8t5AmBYdTpjJvTggJ37JR+ryvREg61Ri9zkZTKFbzHtx13kUOO+o6DS4DTGfm4fH7T+2rZ3wPwnLdEunse21upr1Fj5Ng5+yDpi44kWTS1blWqB/LdynllMvOV425HvevCeggjJOi7sAGlMTdtKwbMl8HDIArdJXEosJU=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20) by GV2PR08MB11468.eurprd08.prod.outlook.com
 (2603:10a6:150:2b1::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.21; Mon, 15 Sep
 2025 10:39:25 +0000
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739]) by GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739%3]) with mapi id 15.20.9115.020; Mon, 15 Sep 2025
 10:39:25 +0000
Date: Mon, 15 Sep 2025 11:39:22 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: will@kernel.org, broonie@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, james.morse@arm.com,
	ardb@kernel.org, scott@os.amperecomputing.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com, mark.rutland@arm.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND v7 4/6] arm64: futex: refactor futex atomic
 operation
Message-ID: <aMfs2mRf4aDABFtl@e129823.arm.com>
References: <20250816151929.197589-1-yeoreum.yun@arm.com>
 <20250816151929.197589-5-yeoreum.yun@arm.com>
 <aMRN3z3WNRGuwBgQ@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aMRN3z3WNRGuwBgQ@arm.com>
X-ClientProxiedBy: LO4P265CA0030.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2ae::15) To GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	GV1PR08MB10521:EE_|GV2PR08MB11468:EE_|AM3PEPF00009BA2:EE_|DU5PR08MB10849:EE_
X-MS-Office365-Filtering-Correlation-Id: 5f1d2e4a-3f04-44ff-40de-08ddf44438e9
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|7416014|366016|376014;
X-Microsoft-Antispam-Message-Info-Original:
 =?us-ascii?Q?PVwsWkFUFxzfUYpZRQqP7u3P/YEXP5U82bCNqeamMXWO/HuzvNmuQ4QBcv5i?=
 =?us-ascii?Q?+eISNWnIzwY5ksSuoODixEVV62IBn4ADCKYG8abnnMJ/MYu192rLeFM8VUjz?=
 =?us-ascii?Q?X/Isfo8TQ+hCKbmBYqrmkEnSCf8krZsUiA2ha63QnjOT+iqt5o0AVC4ax0TV?=
 =?us-ascii?Q?ML5T5qxHOueTUQmgZshQbrkxd2Kt7t2fXPMAegvZvbKnw0pemCaSf7U/2QeT?=
 =?us-ascii?Q?A6lltJETH1L13o2VFZLe72E4pveSC3xcRIWYOSZ+T7dl5xzxCqvqz67ofG0+?=
 =?us-ascii?Q?LnA6iVNvaDkGWceRSxUDMZh6xgQ2QKMQB1BVpL9rewrqpEItHjPKLA/JhFRt?=
 =?us-ascii?Q?DATU45zffiQkhNle8EaxquVci+AByHWzsHuvWD2THarBavjYw5xEJnLo1UJn?=
 =?us-ascii?Q?W/GDMjt0T8y3YRv5ewfaynAoQw8sxdYF/yCiTBf/atiu1W6/SgWfAeZQ0RsI?=
 =?us-ascii?Q?vj6wL/VnvANetTwvBg5RDYw/oXtG6sfWyorA34/Us0kI46JD9ArY0kinLSHy?=
 =?us-ascii?Q?kcFGkIO7CM6CTXNKqdWgc9A99tzgeLioGOySvwNG62oT6Er2Jj1JuKvJdTFC?=
 =?us-ascii?Q?Ta/vfOqmhFHoeJr4Qfl4/PALzU5BG0lOciALBZlXvePy2Ezxrs2Ze7rVUzk6?=
 =?us-ascii?Q?KNqp/vp3G85P8ZgXNfxSlYiAsMuS2Rue5FWP46rky8FWBDKXRKqR8WP0ItOH?=
 =?us-ascii?Q?jzorXBrCEh1apUvJeyMmTBf5eeqd3K7DzisBxqRmyKNKLnhYvN0c9WEwtAZr?=
 =?us-ascii?Q?wom+FdOV2qu6PA59YDKXYiGwuGfOCYeVdLDulosPm3lvhIUwa6ojZHUoR3DQ?=
 =?us-ascii?Q?9FFAdshOl2vPmezCjWNESLStidAVf1e/es7x3cs+bdLFCMqwUTh2LNDX0cAt?=
 =?us-ascii?Q?pI5rApjXfVuofdJXWoCPk3vL387YTfultYR0gz0oJcTINqSxVqaOOtS7wBgM?=
 =?us-ascii?Q?JgjdhIiNLctaE8mV5w+jdEjji7Dm9oRztrKJa32lQ3W6EraAYKZv7Lf6k8AW?=
 =?us-ascii?Q?Iu/oL3Wep06VW56btYE+aZmN+VH8Zo54FZdoCgiQaHSA1a/yemJlRbLoWOfm?=
 =?us-ascii?Q?5JprGmmqeN5xGT/H4dneBV5zgZ/RrVHbt4FrCCWeuwdCU2L7i6YNKdh+qPIN?=
 =?us-ascii?Q?G2SdQEz6qCD6rJWcxQ5wxoVTCKdB1SYEbFXT+ZSyjAn6pdS0HuToM127OcQ7?=
 =?us-ascii?Q?nUzNB25akISoIUecDzB2NfEW7IgjGQfL8zURBxBpe555D/Vx7yMMURj3v317?=
 =?us-ascii?Q?FoKkFnWirIr+o3MRYJihzhQAxTmRIdgKClmyj8XiIb5zWORxOwZAqMox0GoS?=
 =?us-ascii?Q?SqxoSEHhv2+laIZtSu0JXtRQd+nyt5e9IY2CRBcmb8E6ABwmOA+hH1EghuyL?=
 =?us-ascii?Q?uVMGnCLNQdq3J5yXkYXgdzfert/3+/5Srb72N+IQ+lvIJtFBlglF+Qi3Dbu9?=
 =?us-ascii?Q?P9Pz2EXnUog=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB10521.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR08MB11468
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM3PEPF00009BA2.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	aa7de889-d146-42b3-1bcd-08ddf44423b6
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|376014|7416014|35042699022|82310400026|14060799003;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?LhR6A1PoMisIVrBxm3Dakyvdc+ivXuF6kdQWLpE7EI/Ide7cHp4EjZ/QVizg?=
 =?us-ascii?Q?G2hs9wqqGb80x53XhQuS/H5xyngZPkbQNFmOg6NOqwOafMuxAlyiwny+170U?=
 =?us-ascii?Q?Uj3YFX6G8u9EmmCzqgYoxSGIEZxHohPObz44EtGojb/0mlBbSXmvNVjGJfHa?=
 =?us-ascii?Q?Wnu9LvRSXDuFKv7rN9xM+AaFoptOESfNh2DARfHS6afOqDDmfLgAT9AnzNny?=
 =?us-ascii?Q?TB/b4qDMuG1YJI+baaNkBEfZ+7IoiTysZ97E3DYDM3m9Dy9zw5Ys6UQOj02B?=
 =?us-ascii?Q?5CNBCzmlYK3I7gk3qdv2USAIxNC7Ypf8i4BT+En6hJkIe2Dlnj4EGQnaEQ4Y?=
 =?us-ascii?Q?H2SlGGQb+DR1HUl0YS8ZasAsWJ6sTCcWZlaBj2Df0Ui9ADX6dejSYXJBrTeE?=
 =?us-ascii?Q?jzW+e0Cdat4+67JLcA5CZzfJKizyxlNrXlqGbCM3GXrhgYAcySQEmRdbUEUS?=
 =?us-ascii?Q?KZMEDEe6rpfTkqUTv1X+QXIh1j+UQALFbNE+ZH79pzUNw2htHSNp56YNOW+h?=
 =?us-ascii?Q?MhSBoZ678L92IWgSMq+fBG76afZC1MxngZ6ho0AKXuiLNnDTwxgwoPExmYmm?=
 =?us-ascii?Q?YGmXBGD+B04c1UAp687XUnMi1Slz7i8XvfYHtJTJ6Mff9L1AIVX0sAzRxgX3?=
 =?us-ascii?Q?yFrMVK0TVCz8aAq6NiJY8pHrpUHpKFzs8VFZFUp3mFeeFzXe1roMJTsxWfRq?=
 =?us-ascii?Q?Lc1xUdVIy1KRlh6xmXRaXhn3GG+Sa0JAJs4gQpi91AKtGJb2WOpXvENqyLkQ?=
 =?us-ascii?Q?gSgyz9qoMmT0UhAuf8l7ic5WDPxSVSRNJUaqTetZnXSZZVorH3IXafKRGSF+?=
 =?us-ascii?Q?zdbKBd2iOBTDtgRw+XkQgbJR82xcKUcYbmz4C6cjAUHcV5Xvr5zcHUo9x34L?=
 =?us-ascii?Q?AuhrF1vC0QEq0L7ZIhJHBhCnBaDHBAtAwLj2h38JnSYMYtRDu/eaEwlqHFTD?=
 =?us-ascii?Q?PnxYgpo13m+nv4+mKu6bohLG2B3L19WcZ9sGhJRL0ic/QqQQmKD9vSl9Vhjc?=
 =?us-ascii?Q?xQFqhkJK41VKMvH7VdwkHRn+JHIK089z4pTmmpUuNJB/Z0kXBKofJbQK9jkj?=
 =?us-ascii?Q?E2klMREDHQMmSMcehzajH4PZRhMSTBg8wrS61sxsh1xMQyng4ETzZP1ZiZiG?=
 =?us-ascii?Q?QPmhFsH+tdPw8OxVs8QZ5UeXDku/yPio+D3fbqfO6UHAGMnnFXuzwZN3ZojB?=
 =?us-ascii?Q?VgCBRU2J6yDVZN0abYeMsC+X7uA1flki2aN+yPtb7JuCxJwC/cOcFLsMnsmh?=
 =?us-ascii?Q?HtneMOpnxk8YvDToLdiZJSV0Re54+CGmOR+6LJcRZ4YV6tq4shvwqgMewpze?=
 =?us-ascii?Q?h0HEzHHfDpi7JT0KjopHBNv/6qaCOTzyQIfmwbfc2gC8AH5m8Mdk9tmsDKJP?=
 =?us-ascii?Q?LTwxGGVEfSYFTV0Xo9ruIoRPk6AEWLjS/XkymWcA6mC7pGu9GJPzhP7zgsmW?=
 =?us-ascii?Q?uxnOKHDA6OMVUqqDYt0V6PF0ajWo9YzeXhrtUOSDjIgINUlFrGlqNXA/zNSy?=
 =?us-ascii?Q?HXvP4c4FenyWEMLBBFVR4+h+Twaxd0wtWn0h?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(376014)(7416014)(35042699022)(82310400026)(14060799003);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2025 10:40:00.5244
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f1d2e4a-3f04-44ff-40de-08ddf44438e9
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM3PEPF00009BA2.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU5PR08MB10849

> On Sat, Aug 16, 2025 at 04:19:27PM +0100, Yeoreum Yun wrote:
> > +#define FUTEX_ATOMIC_OP(op)						\
> > +static __always_inline int						\
> > +__futex_atomic_##op(int oparg, u32 __user *uaddr, int *oval)		\
> > +{									\
> > +	return __llsc_futex_atomic_##op(oparg, uaddr, oval);		\
> > +}
> > +
> > +FUTEX_ATOMIC_OP(add)
> > +FUTEX_ATOMIC_OP(or)
> > +FUTEX_ATOMIC_OP(and)
> > +FUTEX_ATOMIC_OP(eor)
> > +FUTEX_ATOMIC_OP(set)
> > +
> > +static __always_inline int
> > +__futex_cmpxchg(u32 __user *uaddr, u32 oldval, u32 newval, u32 *oval)
> > +{
> > +	return __llsc_futex_cmpxchg(uaddr, oldval, newval, oval);
> > +}
>
> The patch looks fine and my impression that the __futex_* functions will
> be used in patch 6 to dispatch between lsui and llsc. But you got them
> the other way around. I'll comment there. For this patch:
>
> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>

Thanks!

--
Sincerely,
Yeoreum Yun
