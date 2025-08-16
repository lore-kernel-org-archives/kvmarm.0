Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010039.outbound.protection.outlook.com [52.101.69.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E3D023D7EB
	for <kvmarm@lists.linux.dev>; Sat, 16 Aug 2025 12:31:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.39
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755347474; cv=fail; b=GKzByjivZXynSySpQ5j2NsTtda/YkWEKgYPq57WV37GZbXUfDd7IGufeRCiP+pHW3ZAbN52U/+65S/a+dRd7Lj8J5AC5MckHOtYXHPjFscKWRLkRk6iEGR+EqzVoiIYH54l3QeOerYz/npB0XHYICcYJPd74ywyv35aQnSTSG+M=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755347474; c=relaxed/simple;
	bh=Wn5YkMe4WDMokZFJTbw1FskqpFmk2BbZL5g9JnTM9Ts=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=pryH1IrGFdqkzXDxLP/T71uWKJtG35d2Vmgm6L+h0AtPgBbg6XqfqwviTXXvFUUaeXJoX12zFWb+AqRaAJw7iaKPtR7ho4CUCHH6QXDVzf35A4QpDfl5blL41U5SwXRoclhL2vObnuTF8gE+gBxug0lSI29R9ulS8adueZNhFFA=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=nVXyEt0I; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=nVXyEt0I; arc=fail smtp.client-ip=52.101.69.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="nVXyEt0I";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="nVXyEt0I"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=eXbAMRgBc997xc3tLckMyye/lqlRd2nF7ULpmYCd1U3Mx/rP2UJ9t7Z7lPXBr2q3xK7KI40JP7AK4S/K5LNfnXP/6zzRuysH+PaBMJk9tUIvg2W9bULF8pWryf+XsVNyx8Mla0jx7T/RZhHn0sOB1siGjCdoMPHKINtycohdRsPk9Jq3Z6tc7CCV+e3FVilxXAMSNjF4VgU4/toQMZb7+9ptfxGmU425921UqAEWG3bH3li6EOEOhah4/jCHwVlcvuQd121HyV9Ua8XkAl0YmZwQCab/Kscw77SHHImENASpBsnl9QTSW5yKTOomdQ1qOORz55qbHW4HQ82wJ5EyeA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n8Y6F3gnyTylyuTVDBPOC9W0vbJ8nn2SxmwsRo6I1LY=;
 b=oiqe/VQK0qN2AfsJLaTRPGqWLZzhqkniKk6H7iBHzen/uXc9nCUjQ32t6H/CX8AvpeSZ55+PCV44pHAsr5Dc/hNieMnSbw18fyFI5y3MNExjRZNd5ZUUPlXXLNGrpYQUowMb6nVyHbNw0iWrM78DBLZzk+27mL7rBmlxjgWonpGVX1CVCic36bZ/Jo5jveHe/H/0D4t6ANUWGGRIef2D2fG2Odj26mEZK5r45UXTR5MsCGIofvbcsbt/uJyZ/TJOc9EXwyTApaxcZuOnQ07HajtLO7b+jb4b14oT9Y6qifylQgG/tNRF9IqGFjN2H43ESNT2OYSEBif42qPQ3VDG0w==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n8Y6F3gnyTylyuTVDBPOC9W0vbJ8nn2SxmwsRo6I1LY=;
 b=nVXyEt0IJBEfikNwye/j0yhB7TxWWY5tl5sK/CAohBJkUWWFnuqaR0I/TzCG4lNqzSbSFfRJ4m0MUBaV+dtSdRaA1vLCfyiWJU6/jY6mdoYTL4+0KT+uNzMpwoKWq53xkyCi+yg2dssN6n2fQx6uYFDEbfO5IdBmFMDKj2xezMk=
Received: from DU7P190CA0001.EURP190.PROD.OUTLOOK.COM (2603:10a6:10:550::27)
 by AS4PR08MB7631.eurprd08.prod.outlook.com (2603:10a6:20b:4ce::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.17; Sat, 16 Aug
 2025 12:31:08 +0000
Received: from DB1PEPF000509FE.eurprd03.prod.outlook.com
 (2603:10a6:10:550:cafe::40) by DU7P190CA0001.outlook.office365.com
 (2603:10a6:10:550::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9031.20 via Frontend Transport; Sat,
 16 Aug 2025 12:31:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509FE.mail.protection.outlook.com (10.167.242.40) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9052.8
 via Frontend Transport; Sat, 16 Aug 2025 12:31:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kr+ryUjmOw/FMWCMNDQQ7JlHQhG2bT5xkih7MTo3gn3NfCdiSQbVyD6PZmWY52HeqNLo0Vwyc1IgLLqvFfHUx5soua+X9fyk6WIOtvISkeYv4qtLI/yHEoCpYAj9kWXE33ZRTlGev3fT0rysTSxwo9YbFn91aVOkysTZH6bpxtWyVVfxotruU55f6S7T8P7tdAGE8y+0O+G2QdyNj+iQoi45wuT1cnIj1r2QR8vJZNzGPXbuDnvVHFFOaqiefUGdg93wRYwYJ/wXO6ehNVygOQSSRg1EWYA80cjyCFy70r2WrJflj0svSjLmrtZOIepIC4pFc9CvjAfXd74tA82Luw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n8Y6F3gnyTylyuTVDBPOC9W0vbJ8nn2SxmwsRo6I1LY=;
 b=k2PIcoCFwk/pNuQhep/uEJ2icOqh0XiyBT1F9b0dK3P+nn3NJ+UdyqFRz+KPzj6meajXXalcbhoIveopyt5cuBy0EdFDmQdPeN4/qL4a4LYAsjPBg75Ht/czS5rQFSA/8v1Bvjbudkt/o6ArbRDPYUFzXEq4JLOWVl35Ar7azw+IZz2UCDID7U1I3kqskLtHtgJh2Vs2Caq5gJHHxiWpcGJFEdwJxHqE1VEbCD0nanK2GGl6QsPQ+JPAjwBBuoYzJCP1sZLe41Z1pYyk7MNlucx1JfkzBN1B/deFOIhNANymwW0CJ54MH+fzK/6uR1oLzw04g1ym9opdTMHH4WcaLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n8Y6F3gnyTylyuTVDBPOC9W0vbJ8nn2SxmwsRo6I1LY=;
 b=nVXyEt0IJBEfikNwye/j0yhB7TxWWY5tl5sK/CAohBJkUWWFnuqaR0I/TzCG4lNqzSbSFfRJ4m0MUBaV+dtSdRaA1vLCfyiWJU6/jY6mdoYTL4+0KT+uNzMpwoKWq53xkyCi+yg2dssN6n2fQx6uYFDEbfO5IdBmFMDKj2xezMk=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20) by AM7PR08MB5432.eurprd08.prod.outlook.com
 (2603:10a6:20b:10b::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.18; Sat, 16 Aug
 2025 12:30:33 +0000
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739]) by GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739%7]) with mapi id 15.20.9031.019; Sat, 16 Aug 2025
 12:30:33 +0000
Date: Sat, 16 Aug 2025 13:30:30 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: will@kernel.org, broonie@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, shameerali.kolothum.thodi@huawei.com,
	joey.gouly@arm.com, james.morse@arm.com, ardb@kernel.org,
	scott@os.amperecomputing.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, mark.rutland@arm.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 5/5] arm64: futex: support futex with FEAT_LSUI
Message-ID: <aKB55rPj1Qe8G+zF@e129823.arm.com>
References: <20250811163635.1562145-1-yeoreum.yun@arm.com>
 <20250811163635.1562145-6-yeoreum.yun@arm.com>
 <aJ9oIes7LLF3Nsp1@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aJ9oIes7LLF3Nsp1@arm.com>
X-ClientProxiedBy: LO4P123CA0643.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:296::10) To GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	GV1PR08MB10521:EE_|AM7PR08MB5432:EE_|DB1PEPF000509FE:EE_|AS4PR08MB7631:EE_
X-MS-Office365-Filtering-Correlation-Id: da845a60-d597-4add-5bbb-08dddcc0c5fa
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info-Original:
 =?us-ascii?Q?XzXShWc7oYpq7nbiH/W9XkAIiI8h7YExImLU8baBAollFxnUB/QnsQqkzBsR?=
 =?us-ascii?Q?UcUGd/lf8Py6K0rL/VDElPRu1rg44ryOU94u8MNcQjggH1kalFmQFsWgi8Yi?=
 =?us-ascii?Q?v0E6v5heIrjaAEUdRX6xUExEYS5AJUvxcPH3+siY/RopO/EJJj+soEzRAxpE?=
 =?us-ascii?Q?b2/o9EylE66kHeZnbM5JscResBmoBcma3p1MEj5Q5c4L3VLVMzynU8WIhLCX?=
 =?us-ascii?Q?JF3berlBXwmb9iYvZQVP1ds+ydp4J8xJ0+sNnNrru9njYcMkZikthSPKyT4k?=
 =?us-ascii?Q?6fY5k+jBoNrYk7gaULsQSFJCn2lv/yf2rPOMdaUPd93sySZ/9aBInLlizrrt?=
 =?us-ascii?Q?LDQ4mk0qoFK8jjJ7DPH3mZnsR6Aw8iLPFd5CPCtqbDo98XVaXT7SDr1InkR9?=
 =?us-ascii?Q?WulKbfRLRn/GTnxTdnylXW1F5q4vPhQkPaJggFjwnnovmTy+zSNOJnCqEGdq?=
 =?us-ascii?Q?scw1btqrQk2dpdhL3+POF0mvfmpB20Dik0yHlBG2NmqdnD4sc1s+wIKd6zV4?=
 =?us-ascii?Q?u/leloLsukBRqstYsetSCxpTJObf5stTrWeHCGqUR7t/uNKaBZ5yZPydhKnY?=
 =?us-ascii?Q?7kASN2YOXO4e5GTmqW5/Y0Wh1m+WY4aBhzKhz1SIoYDaWcKU9HmfXm9GdHue?=
 =?us-ascii?Q?dJ0klXuphpCRzjF75NIyYcUsF/JlBtiYGrAlJak1iZaM2lOWTzF9WtbncngD?=
 =?us-ascii?Q?gXW8bfyu9LUe5b18MxOS1yR0VVtoM8L9IpjYVhjriGmu5+HgWf0VC0ad65D1?=
 =?us-ascii?Q?wLDoOP617mpvhrqunhpPBackHmOv70Hp8YbfuXd9YR3hmvYm7BIndXGWMLge?=
 =?us-ascii?Q?6S1TNAXJYYtXdo0VoDKQ/NY6+YcoSRhywFms2waFBox3szs8gIG2zKaekqro?=
 =?us-ascii?Q?TuZ6BzD6YCcojhnwS6Xo+snv71uG0iFarwE53H33OCLFp8dsUDJK0xEXUCeO?=
 =?us-ascii?Q?s0R/MfRJ45vX45FyfoMbkK6cpPpZVdOI43ySLfLzpH0YsLU8M9Kv6kDVWFc9?=
 =?us-ascii?Q?DxH5/jlsUnCiwY1dSlbIIavr9CBV67dTFM20pNVY9xIuMGRrhB8mp9ry/TJ+?=
 =?us-ascii?Q?OK5R6qBYCegZTzDUgJQHPa30KM2NXaPl7/VD4NCHvHSa9heHf6WMo5oMv3AN?=
 =?us-ascii?Q?quySBWuBJp5mvaoAEtTKylF/+7Mh2kXZYJj4JmWu7OcVhT2RCxOpNKGGotZu?=
 =?us-ascii?Q?2eX0Lr5gmdlou11iaWeLZfuu8+wPpv7aeqXg6sOK+vhPtONbIr7gE5iJN9fF?=
 =?us-ascii?Q?oJWz1OiHCR3bm3bvtMqRqZgP89aGz7io87nb48MiS6Bho1CBO9uX+tGxSstj?=
 =?us-ascii?Q?FAqn0rSTMzNpNr7bWvoHNfvjcsjg8rpxHbi1/PGmaiOSuK7K9ge7likBtkP5?=
 =?us-ascii?Q?MwtUaP5dBoWxlZrzdV6jJ4wS1yzqYBRs39wN1q51LTcjFVdhklc3K403nPyR?=
 =?us-ascii?Q?VwJQzR1S0Ts=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB10521.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR08MB5432
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509FE.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	4fd8fd31-847b-45b3-a3b3-08dddcc0b1cf
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|36860700013|1800799024|7416014|82310400026|376014|14060799003;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?/2/+2nR3+0cZRUnjxuDHVNYky23HuTONQhPV8MAX5I9t+fFLj/3/yF1OMbxH?=
 =?us-ascii?Q?r3J5hlzRkZibkGm7ooZ/+eVA5SSMYmuWJzSWIg8L/Noa2ORZys+IU3nASiFu?=
 =?us-ascii?Q?tNcMxfwvXKbY13cGuy8d+KwoZeCQdAqUoEC0w9ZEpigELK0XR255fgnnK3YT?=
 =?us-ascii?Q?A8FOin+f/315c/cHZMxUuxoOT++MdUwj47wkzrGVTiUiesDPNVZfQfDE98CY?=
 =?us-ascii?Q?TbqKjqcQk+AArIxd+iz3+cKuInGT6YVpy7SF+iRhw8+zX/khiv8oqeLoYvy2?=
 =?us-ascii?Q?G0M/DutHdGG8UUEtuYFM2vgUdRecswgC0Ke4JDtTmZg/1tZbq0J1/gYyea3O?=
 =?us-ascii?Q?uY3xokRZzpCFNRVv3c2f6Gony6rNvYAhViZm5dh4hJWHaehfBt9GsQsxnmPH?=
 =?us-ascii?Q?b+UrSH9v8jbgPnMCPsR/IafB5fS8kffIvkyrlIDq1zCwqTl9e9SOHPSQeeqp?=
 =?us-ascii?Q?tWtFlfSX7JXgJl+WCo/r5tt8cl/LnqgkMJ3W0MBm2OvuGnOIZFXNG+PLktLv?=
 =?us-ascii?Q?k/RdJJYFXwsMHWslqMIK9/VtI+fI+OOcGxVg7kh4PSP4nPREYTDtY4ZU6smI?=
 =?us-ascii?Q?zlppdFM+gqbllJSbqQVGseUEZBW9B1slnNjP3orKPHbSqrKAJbp/EX431tNN?=
 =?us-ascii?Q?qq0+YptbYfJh2otvkOcV0c/cuIZoGfydNIgUFMy1y4t5Q1N46DAAjTdXkIKb?=
 =?us-ascii?Q?+vxvwHex8b7TENscQ3qOuZY1o7JK0J1fiVR1gsTdUT5aFutnzLYV98l9ef62?=
 =?us-ascii?Q?Enua0nqUhxHynKNLXttzU/H6MJyB1lIYHNhQdMCLDhRi2cbpwzWMsDn/ln2b?=
 =?us-ascii?Q?MENP8UyLKAj3wN9slpLJsO1o00vMWjnMGIUB+VaABPQauteqmtZ5gyrPXRRE?=
 =?us-ascii?Q?3kjTcn6iHs+aHlzcwAGPYhVm4EnaffDsn84lNpN3+0tOSL6TLLERZR+q4fpF?=
 =?us-ascii?Q?V5RbYxHqCTV4hFBOK4LTvDmgMhoNV4VCBoNbGMjQBfNIxl/4PoEbAn8jbr4d?=
 =?us-ascii?Q?m274E2dFrCeA7bDPAG4DnKpklq2P197ViUIxm1aY94g8n7XKufFyJ7Uo9Eqy?=
 =?us-ascii?Q?kmd8XdILXs/5xn6tIoulTcXNGXgEijgPLrWDqUl/QsQtY6s8nhx4L+GTwz9Y?=
 =?us-ascii?Q?Wij7GKAUpS+BOF8XFe6lN62YfrAMsYV0k8+IqvozvBKzleYYiPZ/wjgv2Wc7?=
 =?us-ascii?Q?+qyfKUXkr0q5Uzqj/ZJNL5FAhQMEYznxH4KH5RpNCN9vv5j8gyE2o7fNuf2O?=
 =?us-ascii?Q?zIdJDrUBzFl8ea+ODVjB1TCGuv+pkJVrN5BP961l+p8HbaJctdyJkEeJvaIh?=
 =?us-ascii?Q?QVO2FCb8qn3vxNQAyqJKZ+XWLAXDZSmMs8aDrsU6i2p9+zHPOCR0Gfj1quzO?=
 =?us-ascii?Q?usoze1dAvjCqOu/IOuD/3Y8f4bpEwuIS4ahRwXp5rEoNrqYjTkLvHdN/s3G5?=
 =?us-ascii?Q?9P03ve1Z6U6t3HxVxNvbmGYG1m0LhiQMpXqHzAyNXsFMUQhSZ9noQ7bcWiVQ?=
 =?us-ascii?Q?r8a8VhLbjHpRl3xUFEp8QBakww+NljWAasBU?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(36860700013)(1800799024)(7416014)(82310400026)(376014)(14060799003);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2025 12:31:06.8849
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: da845a60-d597-4add-5bbb-08dddcc0c5fa
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509FE.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR08MB7631

Hi Catalin,
> On Mon, Aug 11, 2025 at 05:36:35PM +0100, Yeoreum Yun wrote:
> > +#ifdef CONFIG_AS_HAS_LSUI
> > +
> > +#define __LSUI_PREAMBLE	".arch_extension lsui\n"
> > +
> > +#define LSUI_FUTEX_ATOMIC_OP(op, asm_op, mb)				\
> > +static __always_inline int						\
> > +__lsui_futex_atomic_##op(int oparg, u32 __user *uaddr, int *oval)	\
> > +{									\
> > +	int ret = 0;							\
> > +	int val;							\
> > +									\
> > +	mte_enable_tco();						\
>

> The reason uaccess_disable_privileged() sets the MTE TCO (tag check
> override) is because the user and the kernel may have different settings
> for tag checking. If we use the user instructions provided by FEAT_LSUI,
> we leave the MTE checking as is.
>
> The same comment for all the other functions here.

You're right. Thanks for catching this :)

--
Sincerely,
Yeoreum Yun
