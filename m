Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010032.outbound.protection.outlook.com [52.101.84.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92C182EF665
	for <kvmarm@lists.linux.dev>; Mon, 15 Sep 2025 10:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.32
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757932976; cv=fail; b=Vp4zUAUkxi7PchkaZe8Yf0m0hN3s/tVWCtL672srM8GtXZej//KqGCC/m6dnFD/pLsJZTQjo+U79Ty783RseWhVBb1TBOUhk/JqqCJiQY2XTA5iyZRopVVXrNY+jITnTMkxe+YCn1c3tD/8iw+GKTPrHBfW7HVvnbHdstNS/wz4=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757932976; c=relaxed/simple;
	bh=eDzJVHG3nVPsx07m/hT4IiS8ANaMjhBvDmTtCEUzZeI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=BM7v7pQMB7/Znkn9lRUE1jpdo9Ut+u38ppliTzGEWQOMGNsl14jcJRToiP1a8Hpe9PjjrUGqVqpDInpDQgd2jb6G7z01jXbK5Bs3+ue/cOhXfJkzrQH/9bsDexCTed2Z+hDHDJk9dYf2lXF6cJrYw228SznlVGWNpVz0iIPPOsg=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=lx8NiwFh; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=lx8NiwFh; arc=fail smtp.client-ip=52.101.84.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="lx8NiwFh";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="lx8NiwFh"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=h+uATaJGtr8Y/51AY/dCFneu1B8Yo+61xcPGKNLdxY/u05SR5+IzINBN3iQ1+9KZp6itwwi6xzhYP5+wi1LjMDPA5N5A2WCee0SV0f/lj/44x5WCh4kGdFzEG6OrAw8BZ6KWj3Ob6LLOHhUAH7MdIrd+mlR7F9uWF5AJXgD1VHXv+8pzNNal59bFC0UTaOwJ69D43RulkdSX1VW7Fo28mZ87SNkc4WkuX5dFfYY7qhxkDRGgu+SckdEcOJ1S1ZlbkXqiM5eB63XMzCn5VPWcVpzMdJ3QnITxDVlZRj/7z8RDm9gMhyVIkVvb+t1lYPrCJ1c2s2POfV+i1SPoSxBWTA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=unW3Yy3gJIx8aqo4TGFcz4R2G13Zugcq/7hAb06wINA=;
 b=g0c2rfOfk4iGlpS/WXUG2YmmtzTW+etL1KsXXbVGyE6rGf2xDOy7iWD0TcmZ1bplewD1Qgc7eMMmiPvrKi0t7+QnV0+UU3SARnaWe7R0UFcWNr2SS6WRD0gqQqZ2Tksgl2pmkc6+/XL5JoWPpa9VE2Ko6/G8KF24f1EKjDc+J/SC0pEPg20HpiWj9wXWXIGy3aB609UNltERS8Gg4ntlGg1DufyBC6KwhUjVlTf0chxyRHyOVpB4U6uLIdFmH9GtDdANAi9SNphk6P/+OIgtvPn+cqmuwRff8YaGapMY066q+r6R3gbLyMEJ+I6BPbad6Z8JkPf75QuEQ0Mw33q3Yw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=unW3Yy3gJIx8aqo4TGFcz4R2G13Zugcq/7hAb06wINA=;
 b=lx8NiwFhylm8p4thhXTLuPmEiUZLethIpRLMPU/cymieSoFGsMVnYUFsylyCiZtd9tS9ChbfqXgC4bN4yK60zHvNEZ/j1jZMrEtM8fJAya8Lg78E4z/V66mm52WodjTxIHWlMgT/HmvMwo8TEthyy99vI50zzKFoEpeg0waMb0g=
Received: from DUZPR01CA0327.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4ba::17) by AS2PR08MB8453.eurprd08.prod.outlook.com
 (2603:10a6:20b:559::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.18; Mon, 15 Sep
 2025 10:42:50 +0000
Received: from DU6PEPF0000B621.eurprd02.prod.outlook.com
 (2603:10a6:10:4ba:cafe::d8) by DUZPR01CA0327.outlook.office365.com
 (2603:10a6:10:4ba::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9115.21 via Frontend Transport; Mon,
 15 Sep 2025 10:42:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU6PEPF0000B621.mail.protection.outlook.com (10.167.8.138) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9115.13
 via Frontend Transport; Mon, 15 Sep 2025 10:42:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=blCr0rYsIQIkgp2uwVZ9/JSdkoEEyVPoA4jFv5zBK6+yQ9GRc61UCCTx+ErvuQDBS6ETNuRi1gDIZT/2nhxoS6GAAlJeLwMxabHX/OehzK0EoGNuqYav9fh7mR0mL4N/BN5KTeMybNwVQP3SBjM3FQ7N6z92Xfn8XW4i8O4Ch6YYS7DXVxFLsazPWUAI236Q7uGYJltg6kkUoSgvgnqMMMwh4JSvPez0z3ubXdPLMDJrlC/SdbM8BD0FkXKl4YxPIg85mmNDfoGMi1esioKJZhnd/AuLC/Icuh37ioJG7WwbLrfJ1EVIC6XJ9ka0tG6aomwvZ+nry3dp5xGv3pWJ9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=unW3Yy3gJIx8aqo4TGFcz4R2G13Zugcq/7hAb06wINA=;
 b=ef33Vfr3fH+DTFMAK/1h2L9hcYgY6WXBI8wOSOqI1s5Hps2dG5JUUljU03RU/5VC/3uIAz80MSY856NUv0RE9bEFy6+b4DIdrSpfcn5OKzgguuVObtUzQw7N9eor3gxYZAF3xO+EYRxzxybeUIUQuTrFohxQND/lOeX+N1EXrscyDNkAQprCep5At8WCa+f5ViTp4Vnm14izcJ8KU00ZGmum19yGdSIRZGXouo+7YP8ggc6/hO/Lz1qVoxX8VgTPXvV8okib0wvcf8100wMUh7Fdcl3+5kh6/GEI3Rwd4MJg8fj8QSiKdYu8eVZ1GInpjfirTixvNiI/eaD5eJFXdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=unW3Yy3gJIx8aqo4TGFcz4R2G13Zugcq/7hAb06wINA=;
 b=lx8NiwFhylm8p4thhXTLuPmEiUZLethIpRLMPU/cymieSoFGsMVnYUFsylyCiZtd9tS9ChbfqXgC4bN4yK60zHvNEZ/j1jZMrEtM8fJAya8Lg78E4z/V66mm52WodjTxIHWlMgT/HmvMwo8TEthyy99vI50zzKFoEpeg0waMb0g=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20) by GVXPR08MB7725.eurprd08.prod.outlook.com
 (2603:10a6:150:6d::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Mon, 15 Sep
 2025 10:42:14 +0000
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739]) by GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739%3]) with mapi id 15.20.9115.020; Mon, 15 Sep 2025
 10:42:14 +0000
Date: Mon, 15 Sep 2025 11:42:12 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: will@kernel.org, broonie@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, james.morse@arm.com,
	ardb@kernel.org, scott@os.amperecomputing.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com, mark.rutland@arm.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND v7 3/6] arm64: Kconfig: add LSUI Kconfig
Message-ID: <aMfthATCr5VZcVAH@e129823.arm.com>
References: <20250816151929.197589-1-yeoreum.yun@arm.com>
 <20250816151929.197589-4-yeoreum.yun@arm.com>
 <aMRJK3x-K0HktAPA@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aMRJK3x-K0HktAPA@arm.com>
X-ClientProxiedBy: LO4P123CA0202.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a5::9) To GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	GV1PR08MB10521:EE_|GVXPR08MB7725:EE_|DU6PEPF0000B621:EE_|AS2PR08MB8453:EE_
X-MS-Office365-Filtering-Correlation-Id: 91c55d38-61f5-4858-0be8-08ddf4449d35
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info-Original:
 =?us-ascii?Q?YvNqBP6IzXko1Mk+ba22VMswO1NkUEk4HtAjkY1LXfqi8FV4AjQCrp9uekHI?=
 =?us-ascii?Q?I2S/q0EPZVPPmb/4cu0zTK4MpXUe0usgFR8AFlO5kllQkxv6JjJNmAqTNODx?=
 =?us-ascii?Q?c+zOjgLkvqdTFdDaoTc8zNXvyyG4LxKiH5TbH6Gk5XJjJk7ciN1cRs4AxULf?=
 =?us-ascii?Q?F2oYHrqon6RUOiGdL0mzScYfyl/lfnKlqHiqORx8cbALcin6B9muC3vlVrd4?=
 =?us-ascii?Q?CZjTj7xmyavnFB9n2Ax7N3LbemcDyRJygyt1ymy3kUt6SwCGK9iTaEq4Cr9B?=
 =?us-ascii?Q?HXVZQgqr51ToKDL4P0Lvv1o7Az6gEwwqNUyCtf2hESYiMHQzY4IGI0uo5rZu?=
 =?us-ascii?Q?8nLKvlm3L2mSJ+91TFR3cFOJVNGL1uLJ8vDpfmGQ+R+40A2SIwFIdWdxXpEC?=
 =?us-ascii?Q?xxa+WmSrx5iCqTBULKDR/8URbZ4MHH6AHtcDWd/qe7Z+Tpe510MYQTBynjbn?=
 =?us-ascii?Q?ULL8FuPQalWUf/pHkW2mF/+v+udydYN813wEuP6OS4oNgreXKzXG4PUQjnKS?=
 =?us-ascii?Q?XSU09yUdEBTE06kr0/4+RamHqVifRbKke42IR9OY1IiBBx6SQGDpsxICi3Ev?=
 =?us-ascii?Q?6xc7EfguzK0widysUN17YhVbghsEqwp0DZkRRnLkBGxlUBa9tL5htcOXs5H6?=
 =?us-ascii?Q?VUijte3bIbVPOGWKsjgSzbAje1MT8XoJRASv3nv2A3Wf7SpxmJAYHSUyYOhD?=
 =?us-ascii?Q?+/TX/z+lrYxpjzKKeGWxk2QKh74ZzE1L/l02bN3RsQgfqlu5m3tDY5st3plP?=
 =?us-ascii?Q?/rd6NfvpJyOHmUG1EfvTI7rktpZfWJbp3n7YJubsJjs0+cy1yK+bU6dgYPIP?=
 =?us-ascii?Q?UHd/nS5sW0YtsHInSIHysfX286/3DTL6IuhLhsXLzECjmKTL7/VOkOjZLFcd?=
 =?us-ascii?Q?QN+Zj7C5bR+BAcer65Zmqq9FBxVOmDH3NMzziuuqezRcj5TW/5p3YGHR2B8L?=
 =?us-ascii?Q?lGE5ikwqse3YFJaaHRQKBAFb5wjc0jMLb49XeNBs0blJXuBAQbk4d8FfpKwp?=
 =?us-ascii?Q?V1DYxEftA5NkPrN3whajuH2YDUj2g16u4zWPDoQIi3xEwdYZerDdsT3yWaZ8?=
 =?us-ascii?Q?bVqlh9MYFfhz8A9sfD0lFuXiRKJNAcN4snrPjXfn8CG0/z/JXJDiRi71XPUz?=
 =?us-ascii?Q?8WGDbIvZBA0wmYe+p5cFu2pcb5cC3+Pg+vosMxRVChnwuTuqUsp/psfzrINv?=
 =?us-ascii?Q?o6YlgVU+2UAEdoyIYfNi+ptEDuagxs6E4OGcJkOtoHYBw33teYNWFusvAqms?=
 =?us-ascii?Q?aih9T7amhU3Ut9AglCma6oA3awOCtVfpzSyUAuMF78Yuyl7cC7zmx/cAPE/b?=
 =?us-ascii?Q?cfy12+J8wO2gwn01Rwt4QX1BHByBVvCFH7CFbfFweL2/DyEzaHVqFwMJvTV/?=
 =?us-ascii?Q?SLR4ywZGJCFZeiN/EeNVv5WfQUfCebl9kB45P/yYB2y/pUceTEJsSLHDwKqQ?=
 =?us-ascii?Q?CcBrMhi9Ieo=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB10521.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVXPR08MB7725
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU6PEPF0000B621.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	daa4897e-01fd-42a0-b549-08ddf44488c7
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|7416014|376014|35042699022|82310400026|14060799003;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?OA89mMpdCvWMj4pZHN6funhb1sr7RNNKwn3IVuxD7GwDxr28Zk5cL1qgpiur?=
 =?us-ascii?Q?sZyYjQQPtgDRx6RmuD26Pl+t3nEo6uL3DVFZ7VYGB5TEzW9a2MEGRwpSyufU?=
 =?us-ascii?Q?b4zMczr6k5+I1RUKvZwlABebl5r2v/ciMq6JdqhIM393Yx1wv6ABtKOoOYwP?=
 =?us-ascii?Q?xMr9oZKWpemdQnBTNdH6/kpb0NiiMec+sARsqOLICtcIv4AUyJGy+2zNHTPW?=
 =?us-ascii?Q?e/2BlDMJz/YmOCTO/fECFfdIvUfEWF0CeBoq6d6dVDPGm6sXMd+W0xHiZmxj?=
 =?us-ascii?Q?/E9UmMvxJDqrjseNVUYy4ObAE93fiayWyCD1NsdFwEtlrrxbfjBlDFN5alwB?=
 =?us-ascii?Q?eEKYNkDA6Ba2bz274COdEwIXzWrAoIhxs863jqtAsT1Oprc0LjNLPJuXWUjI?=
 =?us-ascii?Q?5ibzfhEUrlMkMG6KklTcL4OKfHErvfdnCA5fJOkINf/9TxfsFy60AqVIU8Tf?=
 =?us-ascii?Q?8S0ZpMJ3rR1gNtyLQiX6rne+X8gBxsuMLTDO12Rmw2vOSkVyXoh23BKozXHg?=
 =?us-ascii?Q?yFhf8iot4DlZ2yVToWW4UFBvJQEEodRurNoEWTChlmldMO/y6vV9yyAhPMC5?=
 =?us-ascii?Q?mX3iYu1lI4+8nlfji/MM4yojvqqQBLLnA+eIEGNRuVVZ4g1o0J0EHhTZG10/?=
 =?us-ascii?Q?b+erV5LZPgYOUdcxWicWr8vd3gkwNrxq8P2UIzvvyDkuDBdAZ1skITVZ7rOl?=
 =?us-ascii?Q?qOutrAjV/daFTIEwi9anvcIfJko+ghUjDvsIvHkCULp3wtVUPQEb7TuCafkD?=
 =?us-ascii?Q?hEIDKsxN4VH/jtGWu0scQyZG562Grs9VQco4cGMWPkaQv+x2evE8l9NB1jWn?=
 =?us-ascii?Q?Pf2JVPmJyzQk7zecADgf7yX44B+qwVEXa4Y8Bll443W9hDrYxQ/qQcauh8Fw?=
 =?us-ascii?Q?v65wJrQ/N1QpGXPiNHciw1nXKw7Zby58uHtc+8S8QRwuYirZ6BmzSJJdpqWA?=
 =?us-ascii?Q?mZ9bxe73JaQkkMmzOszcp2XBHrax2B4ao/KINS0vo5qTPoxPGJKguPLMEmbX?=
 =?us-ascii?Q?qmHvNLH7mNdQ613TIciqYCsPrFSXn4zLIOS2zT+lRLCwYtpB61edJbmLj0nn?=
 =?us-ascii?Q?63z/DKeSdjPEdbflSNPFAdHsBlVHlbLP7j3pvipAvIcOmTEn0tfvXFhIYQyL?=
 =?us-ascii?Q?xn567jefa0Md2HCoWYugQvQmcxgCvlBGd6UZ8GeUgi0TsjzlrEkInMnIjIwm?=
 =?us-ascii?Q?/qSblOUMpXPsTuGM7cJwzMoww2tu/8QBpbyDsNhrG9N/vUPG369Nx+GY2hfL?=
 =?us-ascii?Q?NMdAffzZRxLbRGmWb2HLlZLQB8x6RqSfKbXGyXrPVJaT5hWwZFq3aEqIjl+8?=
 =?us-ascii?Q?6Ds/J81YyiJbDkUQud29b1EHedMdTHDf612C1QcxNxhMcId/K+eQoEYCBKle?=
 =?us-ascii?Q?Df8i7/M6JeceLi70JakHyLqpR5UEBDObXaxb30Q14vrg+D9eisw+W1UIQ2ty?=
 =?us-ascii?Q?ciYBkdZmK3P38mDxujcnS0ZfjbL2zABnOnWDadEo5uqzk8I+GDmpxM4UUNAc?=
 =?us-ascii?Q?0giGqTCH9PKdw7VNUIQ+6OlbajBEqCYY56BM?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(7416014)(376014)(35042699022)(82310400026)(14060799003);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2025 10:42:48.7931
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 91c55d38-61f5-4858-0be8-08ddf4449d35
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU6PEPF0000B621.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB8453

Hi Catalin,

> On Sat, Aug 16, 2025 at 04:19:26PM +0100, Yeoreum Yun wrote:
> > Since Armv9.6, FEAT_LSUI supplies the load/store instructions for
> > previleged level to access to access user memory without clearing
> > PSTATE.PAN bit.
> > It's enough to add CONFIG_AS_HAS_LSUI only because the code for LSUI uses
> > individual `.arch_extension` entries.
>
> The subject could be improved slightly: Detect toolchain support for
> LSUI.
>
> >
> > Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> > ---
> >  arch/arm64/Kconfig | 5 +++++
> >  1 file changed, 5 insertions(+)
> >
> > diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> > index e9bbfacc35a6..c474de3dce02 100644
> > --- a/arch/arm64/Kconfig
> > +++ b/arch/arm64/Kconfig
> > @@ -2239,6 +2239,11 @@ config ARM64_GCS
> >
> >  endmenu # "v9.4 architectural features"
> >
> > +config AS_HAS_LSUI
> > +	def_bool $(as-instr,.arch_extension lsui)
> > +	help
> > +	 Supported by LLVM 20 and later, not yet supported by GNU AS.
>
> binutils 2.45 added support for LSUI.
>
> Nitpick: we tend to add a two-space indentation from "help".
>
> Otherwise it looks fine:
>
> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>

Thanks! I'll change the Nitpick and send again.

--
Sincerely,
Yeoreum Yun
