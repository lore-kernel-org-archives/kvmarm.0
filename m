Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013034.outbound.protection.outlook.com [40.107.159.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96E6429ACF9
	for <kvmarm@lists.linux.dev>; Sat, 16 Aug 2025 11:05:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.34
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755342344; cv=fail; b=Q6BJdj+e2UAcoohznKp9Gn7P1DDuyL77l1cCpj9LQU2KMCbSbFWGoYeL0fZBGgEMnNBQwppc++MHdnosvBmSNofgEIPivzZmm/XH1bvwrVLHFPg8aaWSIOs75DYQFDC00HO4PcpCntt9TBOOA6LHa18js5D5XIMt9YhwDtzU76I=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755342344; c=relaxed/simple;
	bh=8M4PRNjhMj9Gw0i59UO/c+BeGsanLaP1t5qZtL0g0gc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=tDDitnwGAV8JNFBrJj1qTXpVcmZMaisWhSsYMs4ZO4dB37dD9gQ4lYmJhGi/GhhkbXRsFpSXvouML2UxugjEQ6rLW81PysP14fWG7/t5UlCg5qUHvPk+DYwnrlHJwwVDJc7x6l7KOhcVwLoSHc/hf1BLRToW4aesPWIzryCb2qg=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=WBdj+vYh; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=WBdj+vYh; arc=fail smtp.client-ip=40.107.159.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="WBdj+vYh";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="WBdj+vYh"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=sQ6eZvG+SZKRBAzVq1wLm7tDJnpuqXpOj4GXj+SrfjkwFYD9yG2PnSFekly/Z4/iCh8X4NdN45uAThl995/oSt0FWmJqm8MlmHOYTEsY4mL9OoaNdt+NQsL0k3CKW1+OYyoUTbMYK/2kTAqWpMcxRYCGE4dIvthwMJy2A1Lmfwzh8agRWtX5NZpkV4tLLaz6ld7uRmR5q69w9ESvHOwK9fBiQ7nb96Fi0FNa0BYuk7Rvd76guD11mzA9Iy8ePX+Be0oOXV2gBYkefkgp7Ly/G+TCMBFllul0JK6BoScKsYF4GpNfv/Bs6hqj3XyHfq8/6Y/7turLX5PxPCjTVEh2zw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wLbgGIafHukkXaqTRDSNX5g96eR2W4Qm01JMYas7QcY=;
 b=FS9b3TZehVSZwtd2Qx+/Ukr7sa+4EKAZ+nYw7V8b648sWxWwkLlQuezUF6Jku8e0HocQ/Lphl+4LcRjAeTeKGd+YsOd4hIAFjPlyomFJ8JvpdJ/Q/Olo5GWMW/MEv2qejRgvc5sddhrlG3J84AMcmjO8VA5oW+GqxNCp4604v8GXUms2cvdVmu2DpB7p433KBQUv8TaylS3ExNLWfy/kwGSOsvbjVFm9EuVCjTkye7RztCtvKxzsjwDP6oQdCI+L8QMKESUad0W7WRS3rD5Ik+LHNjuqEG17+wsPbm3QzDY/w7c1tU/w7TO9nqcw1FAdmTaxDMe/QOZ9EmX1pzzfbg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wLbgGIafHukkXaqTRDSNX5g96eR2W4Qm01JMYas7QcY=;
 b=WBdj+vYhj8jhXWoaQxXO6uwPSKi8y5leb7roFfw82gLBX8q2gmxXp1MFJYx6CRxtjRVn3QovIeyNH9F2xNOCKMKeHXLAkxb2J0A31+fvp3DFgek1DS/rRhP/eceP9YUeLD+etRWOlVLl6QEcX2GohHj3MjyHYP8bLOuE9LEJGJA=
Received: from PR0P264CA0161.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:1b::29)
 by AM8PR08MB5617.eurprd08.prod.outlook.com (2603:10a6:20b:1dc::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.20; Sat, 16 Aug
 2025 11:05:37 +0000
Received: from AM4PEPF00025F9C.EURPRD83.prod.outlook.com
 (2603:10a6:100:1b:cafe::6f) by PR0P264CA0161.outlook.office365.com
 (2603:10a6:100:1b::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9031.20 via Frontend Transport; Sat,
 16 Aug 2025 11:05:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM4PEPF00025F9C.mail.protection.outlook.com (10.167.16.11) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9073.0
 via Frontend Transport; Sat, 16 Aug 2025 11:05:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RHSVxhqWhtOYw0Pz8AuWUaCSnHpgU/2uRBuVbcnZ1bItHbvz3dWxa0Yl6pNrkO7cf5DHVCdFT4F/WZau/6hel81XflmbHSxOnfWzbE4enfW+bsyuUw9C+jNZIEkgaFLvgH5pa3pDjoIuaCXs4wALZA2iLitl0N8++zBvjieuA4mJkBr3KQXwipwzG6JIGGTC0wNgVNxxUWV2SeZgJnAW7+Vl8iDidvP31B3JTQeCiyhTDPpE1ZwrrxQs5ECDPYZBcoR5llkyeDZnw8fIq0zW8ZdBqQ4hmvyHiRpyoZC+IQeBGWuNA6uKtywaC69q4s3eJGNj0MQaOsf1cySz7Wf98A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wLbgGIafHukkXaqTRDSNX5g96eR2W4Qm01JMYas7QcY=;
 b=H6exK646/cfKxumb1WCcU9dkBaeOkU8FIR/opU2vhAGXquh08Fso5e5B2+sh9mZN4b8bXo75z5T1lYe3mB1FVprawZwfyS+wdneUgMvjiL6ZSXsHziitpG7pXXr0RZs9UckSyAVKs0F6gzMBxVa4La54aRyMFp4EcmNoSaNym6l5EBEd3y9IYsG8LCOI2Yh3jcaU9iNjlkyVsQ6dqrkRM4SpmevIVfTJC0bFZvv5D82fGg/PwtZT0qzOecl5TCITkeL7IgU7y/y/HFNRwfLIGYy6r6b908J61zRtsUxDf06r54nWSc/EhLrb78eZELaTzP/DTp5PTWJa1oXu5aQxpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wLbgGIafHukkXaqTRDSNX5g96eR2W4Qm01JMYas7QcY=;
 b=WBdj+vYhj8jhXWoaQxXO6uwPSKi8y5leb7roFfw82gLBX8q2gmxXp1MFJYx6CRxtjRVn3QovIeyNH9F2xNOCKMKeHXLAkxb2J0A31+fvp3DFgek1DS/rRhP/eceP9YUeLD+etRWOlVLl6QEcX2GohHj3MjyHYP8bLOuE9LEJGJA=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20) by GV1PR08MB7874.eurprd08.prod.outlook.com
 (2603:10a6:150:5d::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.20; Sat, 16 Aug
 2025 11:05:01 +0000
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739]) by GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739%7]) with mapi id 15.20.9031.019; Sat, 16 Aug 2025
 11:05:01 +0000
Date: Sat, 16 Aug 2025 12:04:57 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: will@kernel.org, broonie@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, shameerali.kolothum.thodi@huawei.com,
	joey.gouly@arm.com, james.morse@arm.com, ardb@kernel.org,
	scott@os.amperecomputing.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, mark.rutland@arm.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 1/5] arm64: cpufeature: add FEAT_LSUI
Message-ID: <aKBl2UjCM7NRKM+G@e129823.arm.com>
References: <20250811163635.1562145-1-yeoreum.yun@arm.com>
 <20250811163635.1562145-2-yeoreum.yun@arm.com>
 <aJ9vW8SgklYByjpB@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aJ9vW8SgklYByjpB@arm.com>
X-ClientProxiedBy: LO2P123CA0075.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:138::8) To GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	GV1PR08MB10521:EE_|GV1PR08MB7874:EE_|AM4PEPF00025F9C:EE_|AM8PR08MB5617:EE_
X-MS-Office365-Filtering-Correlation-Id: 9f81092d-79e0-4337-a6a0-08dddcb4d3e6
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|7416014|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info-Original:
 =?us-ascii?Q?DRdqG6YniGfGNj8BUAOJyxZWx/hL6j+Sk3bnlAqk57yb3RpjYUckKWwkdxTz?=
 =?us-ascii?Q?ic+xsFCS9GBAPSEmeqR8YxXPsi9OIiY5ikm4IrsCoNNTU8uMIONFwRaZ1M+h?=
 =?us-ascii?Q?TA/wwJucqlwAZbNZXIvgauo81YTw9GPAZMlqUsszUwfHhKHyBVyIKFyMrP4B?=
 =?us-ascii?Q?skjnKfCElvALGAGpC0h25KuFUJyFfUilSvUXTVLYcUvJ2DpgYsmGIWXjojw8?=
 =?us-ascii?Q?fwhLNGRv/2+xl3rPoSgQUfD5fa+GpdCzFSRAHavuSZXGIC+umLfaF7bqeDQA?=
 =?us-ascii?Q?n0Bj9KojQKrgs8ySNvARfCA3MGyAIyxBsQGLlw+RzH7vhqb2+zwmc6o6D1ow?=
 =?us-ascii?Q?Bpze+bE53LhGeqckNxPLEZCncX+RCv/rrvIzbgNf8y3pED2Ci3C018aXP5wC?=
 =?us-ascii?Q?jqcgGTWvxdhOTafQg4lUoVov0GBclyhX1Ulxj9joXhnAAZZCx5l180w4zpMq?=
 =?us-ascii?Q?StZOLNc5SSlGM5SnXhlPdu/SIN8ohujwTXB1nlqJQvyKL4T6sORbYDOuvUlM?=
 =?us-ascii?Q?CsvTdJnQDxvAALy5mjw7Ume4MRue+XZLNcjoLWeQa+jy0RkrWGh9Uf4f6ffd?=
 =?us-ascii?Q?6IUUoaOiral4oRnbIgOjCjNXubGiNa0uQPC/GrGzcRzOLwSEryshmlaNMwFl?=
 =?us-ascii?Q?Fc480jpQoEc3OBzaVReAZYyt1tCZNw6vNxgewIQs53qRNyIR52ofY1t8QYav?=
 =?us-ascii?Q?P0xJenWMlK0810mH+H+Gv/yEig/8eLdQqjfpfJnMKg9PYc9FxlGTmSU9p5en?=
 =?us-ascii?Q?NMKOMa3Ih6v1ibR4nidNezARCtGQrbi35okHKtE7FOZ3EmmVE123uXeSic9H?=
 =?us-ascii?Q?C0kk92gMV3/hPCVGaPfCthbgJoJHYB81clLswHMDcAMfRr1Z8SifaEJgNcOY?=
 =?us-ascii?Q?0CeJEvjDRmtIByCPfyBCcnExo5uKB7XbeOONSKWRY62xW+zyONEGnsKe+BiP?=
 =?us-ascii?Q?RzRajLFaxQqLo1i6BIL9Biq2Pt8O2LF3NSEd4UndQR7NT/MgQNMqdgF56b3J?=
 =?us-ascii?Q?ZSQIl9c6qvRZ1Dtwfo4zlOgSUAsYFyARI1TJxesR5VjPcJWdUrCYRc9I7UMt?=
 =?us-ascii?Q?47d/AHKJSBdNxTTtNPMs68z5/V5P7Pus5eZxu0G2So33NSLetnjkPsQqm7mK?=
 =?us-ascii?Q?5YSNl83SqK94PNPjOw7MIiesa6zR8I/5cHpIQlFUeZI0OEVlYkklJcxzfB37?=
 =?us-ascii?Q?tpmzgmJExhIyAhU4G+i/omqBhCSrpqTPb8dMh2GdMCi5b+VoFPcdckLqEYcS?=
 =?us-ascii?Q?KWWZcOiNzSv+bwaXrHnwhngl+xGUV0q+05V951TNEznbiLvrUnhN3dI1ETE4?=
 =?us-ascii?Q?+r8zlqr/dI/oWIKjitG22QV6zKBWk781lDQKS8iNWljL8S+xT8/HM2tZdyyA?=
 =?us-ascii?Q?OqQ4GovzbBii+8b26sWvUuwrS7SUhGIWP+ucdZjyjhdfx0FAMnP0vdeyQPzi?=
 =?us-ascii?Q?0BiHilWfqBM=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB10521.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR08MB7874
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM4PEPF00025F9C.EURPRD83.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	ecab2ad2-4125-4197-69a0-08dddcb4bead
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|7416014|376014|1800799024|82310400026|35042699022|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?zOPGPvOQZkMK1aLcMstj+/Fl/alhdis7gejgxh1bBpfvrDyNykiNNAhiY6/j?=
 =?us-ascii?Q?fotXixcdbO09C1EQSkrrE/xwdirRPfOozD+tSWhLGngTnn2UKf4G7rft1Git?=
 =?us-ascii?Q?MOnt9+ktgg1fU5KF8SN6MLqGdeHt8ed9pAiTAfEUhB2NaTL8j2Eo3tJFUm7p?=
 =?us-ascii?Q?Xe3GVjC2T8AR0ZvQm4xH/62E95ysLzR3PprT94zYx6SxO6IBFC8LQO8LOhSO?=
 =?us-ascii?Q?jyUhugVb5Jkz7RetiCp47NgEi4blV7tpMLGssJ7dX8Cf3AoW08VK62O0wMXM?=
 =?us-ascii?Q?1yNUDf7EM1Kd6mzpAxnXUudMfjU0GX2pCPRhkm54nut9cL4/TBJu41ZYdHIn?=
 =?us-ascii?Q?4xaG70Zejox5qo4eGg2eD9yPLU76xgfuDiLrPisdMhHUxB5OZK/M+0+FQ//1?=
 =?us-ascii?Q?CndMSpLHxwkrBu/Eogxg8fs3MsDNOUFbMZah4yv/v6zR+eJVCX5Hi9zlx+HY?=
 =?us-ascii?Q?jbPFlO38gnvnitHrrfGpYNUoo2q787cZlGac7d16UQSaSLX84+jDPM45iVLs?=
 =?us-ascii?Q?EuBoEaO4EIRyjwWAcxIbnQ+Io9nlKaeTvejad86Yqz3OtkjMLT7IaPQ4rbtr?=
 =?us-ascii?Q?IWJTS82yDIR7qeK78JjF/Ak/1K8oLSx1+2cDA4fNUpFe42KgTlQSjsxyGw9L?=
 =?us-ascii?Q?SgSMrxT9fI34qtEOCu+uuUdvg4qjLgC/z+znuw01UWqE2KgzVCluAgC6NJXT?=
 =?us-ascii?Q?vcV4lYLhW4GorN+ZARxmaJdyjK8JRjAYgH1MimW9xUMZJ/1NkMxon0DkKqCV?=
 =?us-ascii?Q?yVqneW+lp2KNSDfkUrl2GVID+QTFTwsQ9Htq0iavhNIaeFXpkfUyKLT0eLOL?=
 =?us-ascii?Q?6hU0UEnE4+3wrV86bnEXa68BfUhE46c8KFbOQ90OCFJK+dIAwaF7syTgkIwx?=
 =?us-ascii?Q?/SxDbukEZ7ND639PAaCB4FbfVL3qd613yFccTRmXOAqDu/6mSUU7XcxmMSLt?=
 =?us-ascii?Q?mU4YAnwTWEhTMXCW5Qf9+56uWhp4JFHacJ2r2ua3qm1qxyj43i6LvUZhGRfu?=
 =?us-ascii?Q?GcD0R7BmQ3YUPfQCBG+O9aEQOwcJKqpiW/7Bt5Hm/5ZkV3ZnciNJVoLx5k3F?=
 =?us-ascii?Q?JAbnhuyb49pygQm/vMxReLB1l1sw0JWm8KhVrLIO6yPHrGFW4obc181Ko9J+?=
 =?us-ascii?Q?F6/KNAk30WyCrK2ckHwa+2E1nXMtMF0dQOol0IRpN/h4d6DmPDLGWwMYh/oj?=
 =?us-ascii?Q?8qM8ZC7nHNfttN8vCyMvG/ZYqNVKXXnecKXurH/sPEbbz7q4eGInJNaA0x/I?=
 =?us-ascii?Q?xiu/CvF9f/d6pWK4Iw0ogfj3V/JxHxsMEFra4xad1ICOMiFEQsBaOTq+ghU0?=
 =?us-ascii?Q?oOS/QCna0iZpXss0PmY7/EstfKOm/3HQQw7PesB/yowevZlCu5ysALJNwM6D?=
 =?us-ascii?Q?yKURWzisEPoXcysxwDiZ4HMbwZvErbSgtvrbSQYgOanmLXp9+mNW4lprnOhC?=
 =?us-ascii?Q?VWzj9R+jt6HoUmZ/qeKMgPANxti8pvJbgVoVOva7xRDA6PP6NOpc+lDCYEyM?=
 =?us-ascii?Q?aqMdOs1D5cnbsfGNk7SaBTVkMp4LBdiEDZg5?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(7416014)(376014)(1800799024)(82310400026)(35042699022)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2025 11:05:36.2880
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f81092d-79e0-4337-a6a0-08dddcb4d3e6
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM4PEPF00025F9C.EURPRD83.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR08MB5617

Hi Catalin,

> On Mon, Aug 11, 2025 at 05:36:31PM +0100, Yeoreum Yun wrote:
> > @@ -3131,6 +3132,13 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
> >  		.matches = has_cpuid_feature,
> >  		ARM64_CPUID_FIELDS(ID_AA64PFR2_EL1, GCIE, IMP)
> >  	},
> > +	{
> > +		.desc = "Unprivileged Load Store Instructions (LSUI)",
> > +		.capability = ARM64_HAS_LSUI,
> > +		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
> > +		.matches = has_cpuid_feature,
> > +		ARM64_CPUID_FIELDS(ID_AA64ISAR3_EL1, LSUI, IMP)
> > +	},
> >  	{},
> >  };
>
> Since this is only used in the kernel, I wonder whether we should hide
> it behind #ifdef CONFIG_AS_HAS_LSUI. Otherwise we report it as present
> and one may infer that the kernel is going to use it. Not a strong view
> and I don't think we have a precedent for this.

Agree, anyway if CONFIG_AS_HAS_LSUI, it'll be not used anywhere
right now though kernel report it has this feature.

I'll wrap it as your suggestion.

Thanks.

--
Sincerely,
Yeoreum Yun
