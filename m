Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013047.outbound.protection.outlook.com [52.101.83.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DC223081C2
	for <kvmarm@lists.linux.dev>; Tue, 16 Sep 2025 13:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.83.47
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758031140; cv=fail; b=tIZFoKrSpJg3qy4Lk3IAsxjG1094TTyaID1avyK2ftnz6amg6ojs8p3CmRN415w/hFq9l8rm4PZ706QiIWkX+Eu6HQJNuqcLoAhwG0bZi/i9MNsYEU+VZoqLTvwXxQQv0ACHkW/a1fvQLIoeFSCgNKVZL9NFPLrVwYybEi48edo=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758031140; c=relaxed/simple;
	bh=iN/ygPI+gPPsdNi3qQNYwvKPuczqxXGABMOM9Wi5q+0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=LpzzzFEvIMSNbPaLqKooQyjNkDgdCnX574a0hECOqMqrqqBXESGQbXvy16bJ9J/dYVfk+SSeS+52Howl3BfLmRbIyOILCyn4xNHiKtTjE/GtwX6w4NEDIaRyLqTgw5KTM0Kx14SyjzTzlyjpcheq3aspp2jN/KHCxlzFtQNVGLU=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=a9yTMEkL; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=a9yTMEkL; arc=fail smtp.client-ip=52.101.83.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="a9yTMEkL";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="a9yTMEkL"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=RefWmFZ0ssNpGSVg0KO2agmT2g+I5GIf10ZjyE2oKwaQxfkZxnUJzbDuvRBfT2sbnDjbUaityICeObbadQvUPET9c+9+CzCiHGKFzt3FUO3vlNXbLQpCWfteAdZRGw9heDCKDTT1RPwHwUOkO4BOk/SZdNdSt7AD4NKzKN0EQWSNX1MA5Qkg8VAmIQTF7JOm/TFxwLN7QzfLG2T4i2Gj7PsiiC/tV2vq6pYfdnMn4HyG2nKIUiLSkwlrv4oKOzB3GrcxFkcg4OKnhRgrejPuiLSkUiOl8Qxn5gXjC8DFxAYqch6fqkryF+dENHyhV+fS9tO9Z++O8hQQUYCBJ2W1jg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3o2nUNXj90ovoahy1KPSmuJCJUznpTbGjWHcnaBgpn0=;
 b=BAh9cEnyDvxkHo6EIIxrrv9vG9hKNaQG0JDNcskO03hIE+JcBJmPGboiIhB15QlhwMXgdirr95jI+tneHKixsSaA+R12KuoEwPEJLtOJb3mKJSTs9b2H7lXSPSZJCL9NkD6NKDtMBVVrE2heu13jJ7ZPIG1OjX7npyVwznkU3gh/WBZzwlfvJGmd7uPlMFHEbaWQJtjb06qejZ3WYaO1GB7a+/OUbadHUUV3Yx9wxndchPcnBaKbS3LSwNS2o6pUKMRRhy6jKVvg4IijYja+j2IBrISofj8GYLVUiv5PvZO6CHcPCj+JxLnAeZxeslcorz1XnvevpAaLkn3l4Ms6wQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3o2nUNXj90ovoahy1KPSmuJCJUznpTbGjWHcnaBgpn0=;
 b=a9yTMEkL7ks3k22SugYsDNJmxjpLAtZgJarU7iyN7+VF5ncj/weh7OZxhkP8V8e8IOm1qnU2I0JfI+lcl18TQg/26Ozj+hWqQgBXYXaL83yknOytrjCaZRTn5leUn6E7ul6Xy3KOiTQEI9zrix+WyJB05NZuV0Zm98jrd8jNX/M=
Received: from AM0PR07CA0020.eurprd07.prod.outlook.com (2603:10a6:208:ac::33)
 by DU0PR08MB9509.eurprd08.prod.outlook.com (2603:10a6:10:44f::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.21; Tue, 16 Sep
 2025 13:58:54 +0000
Received: from AMS1EPF00000042.eurprd04.prod.outlook.com
 (2603:10a6:208:ac:cafe::a6) by AM0PR07CA0020.outlook.office365.com
 (2603:10a6:208:ac::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9137.12 via Frontend Transport; Tue,
 16 Sep 2025 13:58:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS1EPF00000042.mail.protection.outlook.com (10.167.16.39) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9137.12
 via Frontend Transport; Tue, 16 Sep 2025 13:58:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VLVseIHpiNTS+8zWvT6lZd2kiybj3mdPDQrck0BjkT7NKy5oAhX540ZV4fcdrO+JziVw99ucEYOszI+U34x6UnR1b1pistOYIxMwuOV+XCP0cj28DB374CqDQ7ElHk/VmaWvvKaMjH+UoyenC6cygctoN+iEOKRD+kGuJE5n37nxrqEf9TIuwjVjwLVqCpg3Z/yS4xIlKegy/Nfz7sCQrLpcaP2A6MIYM2ZNYWD45tOYrQ1QuRSLvdHGWcj7Da4wW/CqTncXl3/mzI8FRjJOMpUPiZvRduQKWbsLB/Hm9NBri4dcDYeB1hGaa5zJTaJo9kko27lXAgVHz27GvSw3iQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3o2nUNXj90ovoahy1KPSmuJCJUznpTbGjWHcnaBgpn0=;
 b=ZJjsXQ5W4S3R23Hh8wEZ9aaNoK3+MI3OjbOQa5mzIIQK1dhzIqBFEDTtejbx0bvpqUoFmfq55LZQXwgW7ceFRNGnLrJjebM+UWECSVmreuG80yAqm+9cFzAuaoAUn8FdqSTrSk889W5tECjetwIj+MUiIhomD2NpFrv0CHPYXwjdJs6Z37si3JXm6dGHDIthg1kxBZX4dPIkrUTxi/fdLzuuxeQZS5XF0kSaUTs2zSyHAxhRZaQefe+n6rmu9svx6zjGt2rbFtFmPmIRLd/mofpozy7E/fbz3qkjWnN9gf1H10ePVRhqCPAio/wdEW/YUjdEVQ+1TAcoprADj8+Ojg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3o2nUNXj90ovoahy1KPSmuJCJUznpTbGjWHcnaBgpn0=;
 b=a9yTMEkL7ks3k22SugYsDNJmxjpLAtZgJarU7iyN7+VF5ncj/weh7OZxhkP8V8e8IOm1qnU2I0JfI+lcl18TQg/26Ozj+hWqQgBXYXaL83yknOytrjCaZRTn5leUn6E7ul6Xy3KOiTQEI9zrix+WyJB05NZuV0Zm98jrd8jNX/M=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20) by AS2PR08MB8975.eurprd08.prod.outlook.com
 (2603:10a6:20b:5fb::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.19; Tue, 16 Sep
 2025 13:58:19 +0000
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739]) by GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739%3]) with mapi id 15.20.9115.020; Tue, 16 Sep 2025
 13:58:19 +0000
Date: Tue, 16 Sep 2025 14:58:16 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, broonie@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, james.morse@arm.com,
	ardb@kernel.org, scott@os.amperecomputing.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND v7 4/6] arm64: futex: refactor futex atomic
 operation
Message-ID: <aMls+MSR33BRrCMA@e129823.arm.com>
References: <20250816151929.197589-5-yeoreum.yun@arm.com>
 <aMRQIeIdyiWVR8a0@arm.com>
 <aMfrR0vserl/hfZ3@e129823.arm.com>
 <aMhrscd1gz_syMtL@arm.com>
 <aMh4q4-xAPHnaOul@willie-the-truck>
 <aMkLb6jPiSbzeRWL@arm.com>
 <aMk1qxS3htyaTgEQ@e129823.arm.com>
 <aMlcf5oUNZU65u_I@J2N7QTR9R3.cambridge.arm.com>
 <aMllyaObyciHEEFX@e129823.arm.com>
 <aMlp_Covl57nnVoe@J2N7QTR9R3.cambridge.arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aMlp_Covl57nnVoe@J2N7QTR9R3.cambridge.arm.com>
X-ClientProxiedBy: LO0P265CA0005.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:355::10) To GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	GV1PR08MB10521:EE_|AS2PR08MB8975:EE_|AMS1EPF00000042:EE_|DU0PR08MB9509:EE_
X-MS-Office365-Filtering-Correlation-Id: 0fb129cd-4c18-4c44-a652-08ddf5292ba5
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info-Original:
 =?us-ascii?Q?sAIfl2Fqyjc3y0y6CB7NsyQ0ERYl0Kk80wQGOXq+YoX/yQnKOAKTd7bq4xLf?=
 =?us-ascii?Q?Sxq3R4jqbzpjJTHhZsWlFhz22NXIIkQtFzMyiYSoqt4SNPxprkyATH5h17ni?=
 =?us-ascii?Q?FRIuXecTPc6mMIwr28wekaJhIBusMVwv3KpqCeZORFuKXa89lfvpfP7LEbsY?=
 =?us-ascii?Q?1379Kre+9uiKEhO9cjVGtDJxqZRkt2xYP6JNUt534gYMtefGrKl4U8m1ZfKQ?=
 =?us-ascii?Q?ixAzOiCVNwRCm5tN44VF4pzomDPNYVadaFmsHCz+oS+6lqrtkFSUMC1JlvEk?=
 =?us-ascii?Q?/Ohksfi0YceFGd8eTHfGI9YM7vDxIqDk/TWw1QmZ3Cl2HRdPDuZc0KydcaRs?=
 =?us-ascii?Q?I27Po43hgqrKDFcnP7s5C4fGldbPwcnifPx1CoqlPl+G3ekuV+AhEQc09rnv?=
 =?us-ascii?Q?EIWMMvovL94wUCjkPT3jKRVCVaEv3EkhHEFy88Ix3/DfQbEZDXcJSxIF5AsC?=
 =?us-ascii?Q?cbsQFhsfFtqE0RU+RZl48mj0xn642SlIAz2i1rjCly2J50085TdtUXDrf+lO?=
 =?us-ascii?Q?pUhMrKHcfJvR5W5xVbvTX8ovvw4Kifwh1dFm4A9IOuhDx3RS4DddvU8UBQzD?=
 =?us-ascii?Q?hsVQaHiuJn9FvUha65UKssByG3bES6Y8/x4dvTOCvVH1sqGEZ/eOGxAhz6cW?=
 =?us-ascii?Q?IhW6WCtamirKqEAsNGCZf6Z18BSHse7MMzCZbAG+eOP2eIAb2+PiyBSWPqMB?=
 =?us-ascii?Q?fGgmK1GQ6BlSJE3tM8Da3AjK+xlVVV5+rMKNDI2Lpf79rT5q3y/c+DiC+Xvn?=
 =?us-ascii?Q?A9PwKMwiciOCk03v32TCnpwZzbxZeEtjdHa9bG8LvjnYQBEbt6fuh8YlPIDq?=
 =?us-ascii?Q?zMLoMhNaYvC4bTmCeMhvxzFQuRBDq1S3kM+73UCb3xx3zIa20qblbaHQ8cp6?=
 =?us-ascii?Q?6mSqqpODUKd0anbUOwBwfkHINOOZpUdObLVunG7XjXg2mK75Dl6sxPw0QDb3?=
 =?us-ascii?Q?2yfBWWokuUwNqTGf19pZqhiFJHJnMdlbkEQoJXPp7WZf46YctLhZaX7bFhai?=
 =?us-ascii?Q?OsKbGp00ZfDx8UFW3tQHRqkkE8HfFhYz+K8GaEYeS1K1OCwfZqV+evPrJkFC?=
 =?us-ascii?Q?yYHkHBsyy2lwWBFOGfNZzg/z8/W046Bmm41eQ6W1Njdh8tIc6tRRgqZIgWa8?=
 =?us-ascii?Q?+PJV/OQFBUVeZzU2+ZR57igihWPG37S2x2i19FEcr4Xl1Uc/VaAgBdhgtuUg?=
 =?us-ascii?Q?DeGXrhwre0hJreSYmwVhUs7Hn/KbNxih0QHc/5oR5HHJqbE+sHdZiqIl9rP5?=
 =?us-ascii?Q?toiAYRNjlpCjDvtZvztvUYZnfrrdJleTFhIZpkJJrEdk4LHGH7E++SWzXWch?=
 =?us-ascii?Q?t1gyzeZaFO7e8yS2qwxBr5t/oaDxQ6qlAg6Crj6u1WisWJnGYYp+aZqrKpF0?=
 =?us-ascii?Q?fsN4S63IvBoTTE9kSvZAZW/Hz9Q2JBBpn+/t9MnmwYmsVKRubWMAiUPWIX+X?=
 =?us-ascii?Q?WTHvXCn03Qo=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB10521.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB8975
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS1EPF00000042.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	a9aa6544-7261-47a3-bdf0-08ddf5291778
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|82310400026|14060799003|1800799024|36860700013|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?NEJ8lL1HjsaX6QhBv3mSr1sqsf85N0zjIOEdd0SIw7JXJQ/iP3Sf1nYwj6tK?=
 =?us-ascii?Q?Mkpz6pddjfieTaqp31PnTHUHbIdp5mRXe8/hwHXuWhEGbdoulT8qMfOofhro?=
 =?us-ascii?Q?bZzEHMtsFZIxO/hEpvL7b1xcZImG5aweXGjdL7SW/lAbsmuWc+Ol/7Wr/1m+?=
 =?us-ascii?Q?b0m40UUPKHaBSYBVszjWbdImGnCRAVUVqfvrcLLSKDkJOzLMX3WTr4V94ddq?=
 =?us-ascii?Q?kilLW+9Vk3VmzxNBta4QRvDiF3wXbyD4BEPAy1lv2hH1lUNr4T86g94L+szL?=
 =?us-ascii?Q?9hr+I2x9ib/1zvpGZR4JPpoy2hYSoNMju5g+Jq1gRDkkDHM03G7XfYPcqKbg?=
 =?us-ascii?Q?kXYcduqxrxuIGCJO3VTENUgEhpjtIw9fJkzhCbbLxU2YyDz1Vd09mLbtPvou?=
 =?us-ascii?Q?7bwAV9mGcVTB8l3isJWsiUrWObBlgxHRCpLfywBmTXzg3utysbf2IvTn7/XT?=
 =?us-ascii?Q?NvJyEOwvb1nWTvmUqHmfd+Crp60Gk7DAEhfjYt9n5Mb3/Vkw/QDg46qql33g?=
 =?us-ascii?Q?Lb52aChe+szMDxlOMd373xGCXDjMTfQkQTG1Xi7cVJtIyPBAI85mG8kKQvvA?=
 =?us-ascii?Q?S6/bT5s2oGanaIAX3uKYuJyh0zZJh7yUzQPhxyTUVMztUnJfSjaHbVXWzrC0?=
 =?us-ascii?Q?hFvNFBM12EX0jAr3C7s7n81XXV05QdsDa9E2SeZhbFEOdIiuDKmOjvNMLBnV?=
 =?us-ascii?Q?8XyUq6wvIv6buCLBRmGuf53Pb6AakogpV0WdF6My/l29QW1JJlxeG41u1u4P?=
 =?us-ascii?Q?xzNcWX8crtLgiYY1uuzsUmzFP7HM+yjSZyYiYS0kOfDVDC+LmIHz0EJ71z/k?=
 =?us-ascii?Q?QjdVyQQtlEHM/ASKCB6+6xHuISpu9foeuvNfRg9CJUdo5mPlwH0PHdekXYlr?=
 =?us-ascii?Q?PMs4tW7Av7V+8SKY3rgtPZpzcb0HDUAZeuEhUntdKQ2ucozEy6h3i5OgOdpj?=
 =?us-ascii?Q?GiBjbCgxuBoZ1y8sqLR1LUyQsy3RP2sZ1C1adVeNBdNHuqSnWz0G6mNebV7c?=
 =?us-ascii?Q?oF2Ktp8hCOU/JZFuhN90cz38ur/Ui69kIByjHRFX2Os0aMf/j3fGm7/BsXc0?=
 =?us-ascii?Q?1Ql2HmQwpuknjbXydABNtRSZktp1KFRbDRcvsusvdUQOmXWdqOJ/yzLyq2Qy?=
 =?us-ascii?Q?GMQuJqHMEUOGrRjNCO86Pc+85IMvsRCP3ORsCbb6nwGt9SoFMcX+EAhGzPN1?=
 =?us-ascii?Q?wjsE6U0w9K5wlJB7kZzS1cCXIi3UOYY7ZChMn0iO9hFdl+u4vHzVCfKticaw?=
 =?us-ascii?Q?S0TKmF7GSLeJC81aiQbeTfzRVKalpK9KXMX8o2aa7kfyhxRm6FO2xtCyjSSH?=
 =?us-ascii?Q?HxgVQov1dEhOzISIiCB9g/3iv9sPnSlsyNYvTG4AAWkf3xTRWLfMUmXiLlSp?=
 =?us-ascii?Q?LQOe9D59Ln+7voPw++8DFtgq820pTVDi7HKzGccm/aUTv4EAqCrfV/YGq6Mg?=
 =?us-ascii?Q?F84CSWMk/MjDHi/nf5pmOY9KIogO3CSpvNQ5uoy/VpcIOBgpkt46I6954A9P?=
 =?us-ascii?Q?StyhFsScIf/Z2Low6XrK+mpRxb0f7sTbUemf?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(82310400026)(14060799003)(1800799024)(36860700013)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2025 13:58:53.0209
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0fb129cd-4c18-4c44-a652-08ddf5292ba5
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS1EPF00000042.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB9509

Hi Mark,

[...]
> > > > diff --git a/arch/arm64/include/asm/futex.h b/arch/arm64/include/asm/futex.h
> > > > index 1d6d9f856ac5..0aeda7ced2c0 100644
> > > > --- a/arch/arm64/include/asm/futex.h
> > > > +++ b/arch/arm64/include/asm/futex.h
> > > > @@ -126,6 +126,60 @@ LSUI_FUTEX_ATOMIC_OP(or, ldtset, al)
> > > >  LSUI_FUTEX_ATOMIC_OP(andnot, ldtclr, al)
> > > >  LSUI_FUTEX_ATOMIC_OP(set, swpt, al)
> > > >
> > > > +
> > > > +#define LSUI_CMPXCHG_HELPER(suffix, start_bit)                                 \
> > > > +static __always_inline int                                                     \
> > > > +__lsui_cmpxchg_helper_##suffix(u64 __user *uaddr, u32 oldval, u32 newval)      \
> > > > +{                                                                              \
> > > > +       int ret = 0;                                                            \
> > > > +       u64 oval, nval, tmp;                                                    \
> > > > +                                                                               \
> > > > +       asm volatile("//__lsui_cmpxchg_helper_" #suffix "\n"                    \
> > > > +       __LSUI_PREAMBLE                                                         \
> > > > +"      prfm    pstl1strm, %2\n"                                                \
> > > > +"1:    ldtr    %x1, %2\n"                                                      \
> > > > +"      mov     %x3, %x1\n"                                                     \
> > > > +"      bfi     %x1, %x5, #" #start_bit ", #32\n"                               \
> > > > +"      bfi     %x3, %x6, #" #start_bit ", #32\n"                               \
> > > > +"      mov     %x4, %x1\n"                                                     \
> > > > +"2:    caslt   %x1, %x3, %2\n"                                                 \
> > > > +"      sub     %x1, %x1, %x4\n"                                                \
> > > > +"      cbz     %x1, 3f\n"                                                      \
> > > > +"      mov     %w0, %w7\n"                                                     \
> > > > +"3:\n"                                                                         \
> > > > +"      dmb     ish\n"                                                          \
> > > > +"4:\n"                                                                         \
> > > > +       _ASM_EXTABLE_UACCESS_ERR(1b, 4b, %w0)                                   \
> > > > +       _ASM_EXTABLE_UACCESS_ERR(2b, 4b, %w0)                                   \
> > > > +       : "+r" (ret), "=&r" (oval), "+Q" (*uaddr), "=&r" (nval), "=&r" (tmp)    \
> > > > +       : "r" (oldval), "r" (newval), "Ir" (-EAGAIN)                            \
> > > > +       : "memory");                                                            \
> > > > +                                                                               \
> > > > +       return ret;                                                             \
> > > > +}
> > > > +
> > > > +LSUI_CMPXCHG_HELPER(lo, 0)
> > > > +LSUI_CMPXCHG_HELPER(hi, 32)
> > > > +
> > > > +static __always_inline int
> > > > +__lsui_cmpxchg_helper(u32 __user *uaddr, u32 oldval, u32 newval, u32 *oval)
> > > > +{
> > > > +       int ret;
> > > > +       unsigned long uaddr_al;
> > > > +
> > > > +       uaddr_al = ALIGN_DOWN((unsigned long)uaddr, sizeof(u64));
> > > > +
> > > > +       if (uaddr_al != (unsigned long)uaddr)
> > > > +               ret = __lsui_cmpxchg_helper_hi((u64 __user *)uaddr_al, oldval, newval);
> > > > +       else
> > > > +               ret = __lsui_cmpxchg_helper_lo((u64 __user *)uaddr_al, oldval, newval);
> > > > +
> > > > +       if (!ret)
> > > > +               *oval = oldval;
> > > > +
> > > > +       return ret;
> > > > +}
> > >
> > > I think Will expects that you do more of this in C, e.g. have a basic
> > > user cmpxchg on a 64-bit type, e.g.
> > >
> > > /*
> > >  * NOTE: *oldp is NOT updated if a fault is taken.
> > >  */
> > > static __always_inline int
> > > user_cmpxchg64_release(u64 __usr *addr, u64 *oldp, u64 new)
> > > {
> > > 	int err = 0;
> > >
> > > 	asm volatile(
> > > 	__LSUI_PREAMBLE
> > > 	"1:	caslt	%x[old], %x[new], %[addr]\n"
> > > 	"2:\n"
> > > 	_ASM_EXTABLE_UACCESS_ERR(1b, 4b, %w0)
> > > 	: [addr] "+Q" (addr),
> > > 	  [old] "+r" (*oldp)
> > > 	: [new] "r" (new)
> > > 	: "memory"
> > > 	);
> > >
> > > 	return err;
> > > }
> > >
> > > That should be the *only* assembly you need to implement.
> > >
> > > Atop that, have a wrapper that uses get_user() and that helper above to
> > > implement the 32-bit user cmpxchg, with all the bit manipulation in C:
> >
> > Thanks for your suggestion. But small question.
> > I think it's enough to use usafe_get_user() instead of get_user() in here
> > since when FEAT_LSUI enabled, it doeesn't need to call
> > uaccess_ttbr0_enable()/disable().
>
> Regardless of uaccess_ttbr0_enable() and uaccess_ttbr0_disable()
> specifically, API-wise unsafe_get_user() is only supposed to be called
> between user_access_begin() and user_access_end(), and there's some
> stuff we probably want to add there (e.g. might_fault(), which
> unsafe_get_user() lacks today).
>
> Do we call those?

Yes when you're available.
As you mention, the difference seems might_fault(),
But I'm not sure whether that would be a reason to validate to use
get_user() instead of unsafe_get_user() taking a increase of instruction
of "nop" -- uaccess_ttbr0_enable()/disable() in LSUI
except the reason for DEUBG purpose.

--
Sincerely,
Yeoreum Yun
