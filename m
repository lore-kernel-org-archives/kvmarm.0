Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011053.outbound.protection.outlook.com [52.101.70.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 221A32FF64A
	for <kvmarm@lists.linux.dev>; Mon,  1 Sep 2025 10:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.53
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756721271; cv=fail; b=JaiSW8JqCJy3fJm9v5K+e9oDdwN3/JiDG+vHegrI/7GEOiWsd4+MENhBMI+SmVEfnu+COOvUhRb+f1do6/qJYcoQFpHBypkQPyBWEe3uV8nHPy73PJCzunyYdBBjLDDuMarnohG2DPQZoyPKfbM18Bamb/+PKaG+/qUTPnLRhqE=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756721271; c=relaxed/simple;
	bh=O3oQtfWZdjeIu3fMBRg+J5BxJADOHBVxKLjKuBicFYI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=jn6Wz8KLL9ylq8sazCKCkB/otNVVmc5zTjlkxTP8ApiGCkBJPoRr9GW2//Xk+GA58Gs2efCjtvWSmWam8av+9qbrOEKr/uT3lX29KODhCcSsVHfi2DfGzWFIPh/u5PAbX2JKquf8srYyPlbpw3yOz9Ijylelmh3GSYjN0T7Q6/s=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=iNdrzngZ; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=iNdrzngZ; arc=fail smtp.client-ip=52.101.70.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="iNdrzngZ";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="iNdrzngZ"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=ua9Z8/9pUBjp37MmDqjcgw2OKkb7AaN/mnltX/9Y6cszGYnbppVlkw+Vj32rATTt6PQBcXTGOxLZIGj2u37kK7OIGZ5i2a9FJqIQVL3mSAAEoBcWwyZ2uqXKm7fdVhqIFkoWY7V1wHQneewGB0VCZSt5XnaPqMuG8jjBszxhkKvgS6v9tF8fOspn/dFXF1wphUsK9Jo5oPj6FB11SDGSjbc8qokSIPMhF/i8ic2xYzki+TVCXdV7RMz4CmeonTTrss2rV5dztqPdrgwTdbnH1Tqa6pcmiLcZYZc4HnxHTBlW+aScKHeJfhOGebN2ICxquEte0nGLWYjsqcrlZs2S3Q==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SeoyidgjOj0AUWgw8DQhAwDJvtN78pPgrRbPkK0tsac=;
 b=LbDwp04HPCFPNXqX7I+0V/yP2b0Ijyt5mJwxvoxtcxR5TPU2aZmZrcUqWha+ZO6vqwtypeV+3jEqVSD6nvU1OJUbzu8QkhCfNKflsh1jA3uurML7uRwrZ+OXB3es6Pvza8mpLniudGFkBENxPUTzUndFJvtgXsFdwyTQ213XeWMjDAgmtvjSGtbAv3Lm5LUmy8MxvzNN55sadDo4BhY1ulLgvkJ/A8egjnNGWFuHICjtum+3QJRcwSCGShK0k+EBunjZPjrxaDXzKSXDqn5QisoUWCqEK9VrnewRVMVSYvW4GYL7k8xN0AMg74ij2wnTzhOkwn95kBYjczXahkkktA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SeoyidgjOj0AUWgw8DQhAwDJvtN78pPgrRbPkK0tsac=;
 b=iNdrzngZkSqMWqfVcu1vj9EfIOmLjtOOjjPiXEDHL0SznaiCriFjVTbvzZO/F1aVXq1kqHsE6gymnHZOu4bZn/kGfI1gSIlkB8cz+618O3l+Lyir9Tsu40fXUclDdbZ5mYfWz7enVaXO0lG3l2begCWOwOD3it27qmFSMO+qp5s=
Received: from AM0PR10CA0067.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:15::20)
 by DU2PR08MB10185.eurprd08.prod.outlook.com (2603:10a6:10:49e::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.14; Mon, 1 Sep
 2025 10:07:42 +0000
Received: from AM4PEPF00027A6B.eurprd04.prod.outlook.com
 (2603:10a6:208:15:cafe::ad) by AM0PR10CA0067.outlook.office365.com
 (2603:10a6:208:15::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9073.26 via Frontend Transport; Mon,
 1 Sep 2025 10:07:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM4PEPF00027A6B.mail.protection.outlook.com (10.167.16.89) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9094.14
 via Frontend Transport; Mon, 1 Sep 2025 10:07:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KC1vRZI/CwJj6sisPfOtst7yi07oV5Y+FUD3j7jLelI05wTQ6/zn4i1wpQxCZcmgfiMGptJnOaPsmYV/RRDIMx+26n8edopMdAiPFwu6ATmAwoW9cuHgCPaf60qNaBrUtrgiegeOo0/c2DV8Y+L/ntaW0hIBqlTH0PtRfozoipgjNOTmSgYLwFXd8XFeQw1/ZiONEBN10VgTyVOi88rKvqQWk/EUHxmhtn6J6HooRfMFoTekX7bHpKnONggBufQ5zZGBhXVnpUjjKXy+6ZcLsPB6GoSUGsYdx5X+RSwrOWdi85g4Z+Nm8mL0m0hXDKJbeWa1jJ/bjzA8Ljdc9a6YSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SeoyidgjOj0AUWgw8DQhAwDJvtN78pPgrRbPkK0tsac=;
 b=o4nIpoxEEfKQ0BXijzUT+3hxfAfKBna5iKJAWLZle57ooHxTCsPtxI5WjaGah5afoySIyTxdRGZvnai1ihNprn0aUJnPtCLkfuUJkKvWFy+gxwvnZvxsjk7mQT0MPTVDauKVCzLaEDIvVs2gVB16VzDQxZvWS/njIf+6AahRNKubfL6ngEdxdkK1EE9GOzSn6LUbRelkveikLjwumpoUF0atuJ/urqbOhmj98Itul4kQNQX+yTtY/dmeu/VyY9VzALUIfuzaZCX/Enx1AImz+x76pSBAyzXx/hUbxLIf6oBJNBGA8LatdQ73zkhHSxOW2EkCKNxGvFczBzbP5gDpdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SeoyidgjOj0AUWgw8DQhAwDJvtN78pPgrRbPkK0tsac=;
 b=iNdrzngZkSqMWqfVcu1vj9EfIOmLjtOOjjPiXEDHL0SznaiCriFjVTbvzZO/F1aVXq1kqHsE6gymnHZOu4bZn/kGfI1gSIlkB8cz+618O3l+Lyir9Tsu40fXUclDdbZ5mYfWz7enVaXO0lG3l2begCWOwOD3it27qmFSMO+qp5s=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20) by PAWPR08MB10947.eurprd08.prod.outlook.com
 (2603:10a6:102:468::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.27; Mon, 1 Sep
 2025 10:07:10 +0000
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739]) by GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739%7]) with mapi id 15.20.9073.021; Mon, 1 Sep 2025
 10:07:08 +0000
Date: Mon, 1 Sep 2025 11:06:57 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: catalin.marinas@arm.com, will@kernel.org, broonie@kernel.org,
	maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
	james.morse@arm.com, ardb@kernel.org, scott@os.amperecomputing.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com, mark.rutland@arm.com
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND v7 0/6] support FEAT_LSUI and apply it on futex
 atomic ops
Message-ID: <aLVwQXOHrfaDNFlV@e129823.arm.com>
References: <20250816151929.197589-1-yeoreum.yun@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250816151929.197589-1-yeoreum.yun@arm.com>
X-ClientProxiedBy: LO4P265CA0154.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2c7::11) To GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	GV1PR08MB10521:EE_|PAWPR08MB10947:EE_|AM4PEPF00027A6B:EE_|DU2PR08MB10185:EE_
X-MS-Office365-Filtering-Correlation-Id: f1c79614-8b25-4b84-8342-08dde93f6421
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|7416014|921020;
X-Microsoft-Antispam-Message-Info-Original:
 =?us-ascii?Q?YQYgSQlFDi9VokbQ+TuChpxKZ7DV6dd0YGpsWODjHo+rKik3j3fI8Qqy+KGf?=
 =?us-ascii?Q?Zio4z0wUZgZI9mv1w8gBWughQKBNVgBUlSaBmUEZTPxUjdXzsA1Tfw5TgGMe?=
 =?us-ascii?Q?6vwt8z2DNVshG+bBHvv2kNcJ+mn/rimF8EoMmi983ysxpCrGlnUQlQf34vqB?=
 =?us-ascii?Q?9SP6d1lx6WTI0Gm/4Y6i2fq0MRf+uCHYcX4nDGbgONJhhV9nKFta7cgoASuh?=
 =?us-ascii?Q?dxTNQSNcQAQze2S6nA8Vq3+UgXaWqeRI1dGWzx9QsZPjY4+3QTypH4TGZkyx?=
 =?us-ascii?Q?v2f2u17Hd+t4CmQhyLnrGewub75lP8fMHXvBtDNm8MSZnrgxine4aBgEJJ41?=
 =?us-ascii?Q?fnHEHZsfg1+O5cU6Cx0U91DACwgCdHhVaD/xjIYhXZ9UoyU1NbczGMzwDUuN?=
 =?us-ascii?Q?QdlODxGAI3qzXkHb6hL0mgIEVXoixBLtBeNrOUr8SAl+0Gm4qCjjSeNk4V3e?=
 =?us-ascii?Q?LaDp4/tXyGmHMLCtWoiQktr7FMgmFhhwufKP67qfSz6wUye0IqWPoHaXRcsO?=
 =?us-ascii?Q?f41AIwbIW9Xj2Q1c8n3x+68Dt2dbIjm0gqY/BHHxg4K7GQPvb0YVwWc5x8EB?=
 =?us-ascii?Q?U44z1zwYxBoWV+CqgF9lf7ixL0kWqNAch6Yv33oBWZ6G2WLkFfz5/02ZLp1e?=
 =?us-ascii?Q?gt7ixh0seWB8SbpLbZf/VXYeKtGJJ/S0BZwlXBUH2THib0p+4aSeMy63GW/i?=
 =?us-ascii?Q?Ya4S64Iwb5L9X9vo3l63AUubVI4XuIxITpAzsWzhA4Rc74EslZ1U4qprtFzp?=
 =?us-ascii?Q?SjW3F0qoeOdhCNly4/sAlbJ10leOv46+LtYifpd+zXoNGZFz7Bcp+dALrRP0?=
 =?us-ascii?Q?e5zScIdDH6UIc7tJt0i0esUdST3lop+6FTSgMXVSL6tQzuIHhppLqu7WHt3a?=
 =?us-ascii?Q?0TfOJrGSe9GZOLgLk/3vgtUZhmbmU5YQ+iAQ0x/UQ+f01/4h/UhZU2kWrl6j?=
 =?us-ascii?Q?B5ZbeBXimXK/uAAxCDbOUwnEUhvELXQOag4X30UmswmMTYkaw5rD4Lw5uIF3?=
 =?us-ascii?Q?L0u97ZNxH5jm5qvyHf98eslkynZFUqWoLgi6KiAQ8E3NE43JrN1QVlkV6onw?=
 =?us-ascii?Q?yucniDrJfQa7r5x8MOXDwWQTZHJBuVdKKs73aG53Is0b3z316sQylfv5/gIU?=
 =?us-ascii?Q?Bn2uneEH7k5hbThbJTRl+1g3ZEskqhhPl5ce8biwmNHIxlko022RhRsZiBFI?=
 =?us-ascii?Q?KhdSnDfkhb+mmckDocv/l+q2Gaux8P/YNLfXCwOJ/AB2V9a1rjbJw77n9FE5?=
 =?us-ascii?Q?HDhzRE6zM3KmY31xp3dd0UNPmMj28s/0K7NzlQEuKucIsxqsFl0mfB+9zA9R?=
 =?us-ascii?Q?/4TTirgfzcFzF7sQORHxiEToBW7RuR6HSE3Kl1g8bCyq84wsxoX6wxSxFwhO?=
 =?us-ascii?Q?RnJrQSxjNkQKVEZyWOPgVmrL05GVwim9QjC8wIrDBNodFCxUxnEHQlhwAZYs?=
 =?us-ascii?Q?kNPf277z9ooCmETyaYpskgaPpFkCyqdnFPAdeQfBNxgupT+8JxlUWWfuEEKY?=
 =?us-ascii?Q?PjMrtNjpWhRZCoc=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB10521.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR08MB10947
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM4PEPF00027A6B.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	79b11b19-9f82-4709-d6d0-08dde93f4f29
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|376014|7416014|35042699022|1800799024|82310400026|36860700013|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?b3+nF+wrciKd/JhUjZ8t30sEMPoksJdVynL8F2GxN5qCrwKdnXf7Y6HcTaTB?=
 =?us-ascii?Q?sxxi5fJZ3ovGfB5UCCf1mlOZxtp2np1kqRcL5yiuRu7zNfRfUniaSJU4QnGv?=
 =?us-ascii?Q?Lu9Om4Qj5OyE/z4t/9+K4LYVvPRVqYzPDziltGPR45OKkhbHRtX6b4b+Dg/x?=
 =?us-ascii?Q?uaszhgGHVTrJfBkCzFqFUXfbrMgO80+C5AKICcQZ8hEE/rr4UtttlkyCDxhx?=
 =?us-ascii?Q?QnGeWap/XTJe7e7dBTQBNBMhaWEfDdo5huBXKscMgJ1hw0NLDW7tZUM/5iK2?=
 =?us-ascii?Q?Un+bUY5BnFFQwlqC33ptwKTSl1P8VYbwIJKL5Z0nEGhIzjcMJfrnJyymEBaw?=
 =?us-ascii?Q?vTO+l/V262WHKS1LPJIykVi5x07WsD/4tn5+eBW+ZkE5G+rpoD30VX2G+keO?=
 =?us-ascii?Q?E7B7YpVQduUz2QNc6OIM7ciV7OBntvgLFasuHl/QvQGKYPz0DFDLuGRIcaqp?=
 =?us-ascii?Q?5A1WE8fuCxzEFegi1evzcv4jDwtiWwiL8pHbM6CmbkJ7JU6VtLTVN5ia0HTi?=
 =?us-ascii?Q?2DNV3nYu+9a0SaFa1ccNBoaCGHC4YJ6yVaPHCgLhuXMyOnKRICGduaZWXJVS?=
 =?us-ascii?Q?B9Zzgy/dWpih1VXrnGy2PNR+DzWSYHdSSO3/xRiYyiVb2l+LlsiUylI11d6N?=
 =?us-ascii?Q?jtqMb692vzWPK6s+UztZon1h/re/Oiro/5EeEM84jmyDU6Ovx0ur/NrIYU6d?=
 =?us-ascii?Q?HYRrCsihVpoQhN9nH9VoNGyTS19Ez5GMg6TiAwpNY/1w7zMkr5lcte/3aPwl?=
 =?us-ascii?Q?V8yu/BNJYVozb8JTqssa7Mm/EpfIO4dNJ4lW4lwRPo7XgqhrCl5KqgQRUsGa?=
 =?us-ascii?Q?WF3btwo+5hibG0+053lpb42+OcMnMWT5h28VnoldzdBwbC0dIu/9fAvGt0xa?=
 =?us-ascii?Q?NykSBBxBFvKFAZPyK4nVV/sL60r6ac5vKvhBKjLIanEEznw4V4Vvx5umLGsn?=
 =?us-ascii?Q?EUv0tf5k2UMl2pcp5v4RApT0oZMPm6FgYInWgXcJuk7vLGFqXmtJ7+e04EFL?=
 =?us-ascii?Q?Bsr/mG6b/ts35reGwX9Z1SY1ZugLpayXkF00OCj+NliKYvNZKqBZ81zDg9GQ?=
 =?us-ascii?Q?uH+HppCokiW9gZX9Nskk/xUMHoFIWixmHh2L/biEze+7o+iLG1PNePaYrLtf?=
 =?us-ascii?Q?ZKIWlEZ+VpfZZvjBQmqXsd4H/xV3V5Qt+LG9wrPswC5SE2lol6USVSBaKTaB?=
 =?us-ascii?Q?+G/lYD5TgLGoiWgXsq7NZkFZV/BSk6uWb8FIAiqS9ariXFkeYHk9Eze71uUZ?=
 =?us-ascii?Q?wEfZopkW/lECjpX3LvWHiaIoK6Tki/oJ2kfoZDXgbYGIXI5AzIS/qkj8mjfN?=
 =?us-ascii?Q?tdUK7wOx82LWbvIOfHxL7Q8w6wUKLK8Mmrp+JN+g/NQEO4xYI2ocRxyuCYpe?=
 =?us-ascii?Q?3ZxGJIgWXtqlS3Tv/QJ2ZiZa+4NqDqW1lHmvrs1/cPaxRoBDpnUwvQkgiv4s?=
 =?us-ascii?Q?9bMZcf8WEWp+utK8ugcneiE0kSmxyfq6ipawJk1gs4gPq52IZwSQ77uQVrxJ?=
 =?us-ascii?Q?Im3RixBQcIHEjcpo5Sk9VjIs148LM59a2tX58U/7k4X+tresWDhOGR3Fi79S?=
 =?us-ascii?Q?2vjdGOf4Z5oIFUt4LJM=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(376014)(7416014)(35042699022)(1800799024)(82310400026)(36860700013)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2025 10:07:42.7719
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f1c79614-8b25-4b84-8342-08dde93f6421
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM4PEPF00027A6B.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR08MB10185

Gentle ping in case of forgotten.

On Sat, Aug 16, 2025 at 04:19:23PM +0100, Yeoreum Yun wrote:
> Since Armv9.6, FEAT_LSUI supplies the load/store instructions for
> previleged level to access to access user memory without clearing
> PSTATE.PAN bit.
>
> This patchset support FEAT_LSUI and applies in futex atomic operation
> where can replace from ldxr/stlxr pair implmentation with clearing
> PSTATE.PAN bit to correspondant load/store unprevileged atomic operation
> without clearing PSTATE.PAN bit.
>
> (Sorry, I've sent wrongly for patch version 7 and resend it.
>  Again, sorry for mail-boom).
>
> Patch Sequences
> ================
>
> Patch #1 adds cpufeature for FEAT_LSUI
>
> Patch #2 expose FEAT_LSUI to guest
>
> Patch #3 adds Kconfig for FEAT_LSUI
>
> Patch #4 refactor former futex atomic-op implmentation with ll/sc &
>          clearing PSTATE.PAN
>
> Patch #5 applies small optimisation for __llc_futex_atomic_set().
>
> Patch #6 support futext atomic-op with FEAT_LSUI
>
> Patch History
> ==============
> from v6 to v7:
>   - wrap FEAT_LSUI with CONFIG_AS_HAS_LSUI in cpufeature
>   - remove unnecessary addition of indentation.
>   - remove unnecessary mte_tco_enable()/disable() on LSUI operation.
>   - https://lore.kernel.org/all/20250811163635.1562145-1-yeoreum.yun@arm.com/
>
> from v5 to v6:
>   - rebase to v6.17-rc1
>   - https://lore.kernel.org/all/20250722121956.1509403-1-yeoreum.yun@arm.com/
>
> from v4 to v5:
>   - remove futex_ll_sc.h futext_lsui and lsui.h and move them to futex.h
>   - reorganize the patches.
>   - https://lore.kernel.org/all/20250721083618.2743569-1-yeoreum.yun@arm.com/
>
> from v3 to v4:
>   - rebase to v6.16-rc7
>   - modify some patch's title.
>   - https://lore.kernel.org/all/20250617183635.1266015-1-yeoreum.yun@arm.com/
>
> from v2 to v3:
>   - expose FEAT_LUSI to guest
>   - add help section for LUSI Kconfig
>   - https://lore.kernel.org/all/20250611151154.46362-1-yeoreum.yun@arm.com/
>
> from v1 to v2:
>   - remove empty v9.6 menu entry
>   - locate HAS_LUSI in cpucaps in order
>   - https://lore.kernel.org/all/20250611104916.10636-1-yeoreum.yun@arm.com/
>
> Yeoreum Yun (6):
>   arm64: cpufeature: add FEAT_LSUI
>   KVM: arm64: expose FEAT_LSUI to guest
>   arm64: Kconfig: add LSUI Kconfig
>   arm64: futex: refactor futex atomic operation
>   arm64: futex: small optimisation for __llsc_futex_atomic_set()
>   arm64: futex: support futex with FEAT_LSUI
>
>  arch/arm64/Kconfig             |   5 +
>  arch/arm64/include/asm/futex.h | 291 +++++++++++++++++++++++++++------
>  arch/arm64/kernel/cpufeature.c |  10 ++
>  arch/arm64/kvm/sys_regs.c      |   5 +-
>  arch/arm64/tools/cpucaps       |   1 +
>  5 files changed, 261 insertions(+), 51 deletions(-)
>
>
> base-commit: 8f5ae30d69d7543eee0d70083daf4de8fe15d585
> --
> LEVI:{C3F47F37-75D8-414A-A8BA-3980EC8A46D7}
>

--
Sincerely,
Yeoreum Yun
