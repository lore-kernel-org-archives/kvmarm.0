Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2040.outbound.protection.outlook.com [40.107.21.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9306C1865E2;
	Wed, 16 Oct 2024 08:46:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.21.40
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729068420; cv=fail; b=uMseZSGLOJ7/vUS+/ksIyQMy+wys+YkTn3rBIBDuF8dnyo/6M5GPAzqDuxFUdYg7VMxIN56CEDN+vBAr8M7c9JxlgdOyvi4sbnuMiy9tiSqTzBFP9B+pG5XNtCPnR/UxGgxrO5Fpy8cdtm/nPp1/ZEUa+hX24hRwl2yYboMcOX0=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729068420; c=relaxed/simple;
	bh=xup3SC5Qbde7XcqEofviPWu37H8Se15SQtl4KRg/990=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=AmYcYPzfWLHK2PKPkMsWutCG/rFutfmXuSCsttaBdaP2OL4LazSObrGuMdbN4LioWtqCf6nOzFb3AwjLjMhx/TvCQpZx9CRg8GT6Koj3HV0Qj7GYVvcVE+O5CKi/JRiBVDSsKZto/UDaNtUWZYDabk9lSUgyeDHD1ckxJHEtrVM=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=g7JWyAmC; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=g7JWyAmC; arc=fail smtp.client-ip=40.107.21.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="g7JWyAmC";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="g7JWyAmC"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=Nk5zNAF5fFDVoFfMaEyG4hahNmnrmy3HVff9zv8jR3xDSaxYkpD/aRervh+pTJi/6/TK74kQSUaP0aNgqmoacf0ABkF19//GANXITmPiFix6K84TjJGlpt6SRGuIKr2rIqj00yhayJUXWyZmJZ2Yah8DxHxjvuwacLRuMtE4ePvbxhjilQQ9VM8Iog9Zvd1enQwcae03fElDi36duzu0SxQM5LxbUfgkYld+eGYGxD1By11MIKl1fEAZg42X33kjHWmVa1v55OLW/If36+m3ZK8RAx3oErnK4RiuB1Jno9TZXHzBOlVqnTFfzaUol2Z9iP0qZvG4/lqisfFNbDVpPQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wBIxsAXUsSF1YJWUycITxohmGUkVjO/an3OtuW6tq74=;
 b=dSYx7ZJfKYwlgawUxcB52Iqj2XixS0LejrFDUcQRrTunAHk2EH5BpkxMFud1MzzwnO98CsMqfTKUSxGiXGIHW7G8hVlI4f/rDTVS9xzqF73Z43BuWPqcZfTbjIXo1aKvoYod3xvo7rR6x0k2AMZGVx4Sn6Ckab6/fmHGpPc4fA9u+qXC4Uqyl9Sw61U2KnmqHK45S8y/IINyRMwyDLM/6LmmeVPM5VDrqI8eNKBgo+NqwtX/79GwTglAOkad6TTVt2cfyrGrAk06mumCcO/EVxTvFdQv1KUbkaVMldSE2Fmz3FU9AGx4ZxrASUt4dEbkHyffyhil0XhqctPFmtTm3Q==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 63.35.35.123) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wBIxsAXUsSF1YJWUycITxohmGUkVjO/an3OtuW6tq74=;
 b=g7JWyAmCvNJplRWQ9Fd8fcmbTAzbaB13EPiAOG5x+ezd7rBcjsPCiG2rh1+rCDo58lDWPbl9dge8B4i+OlLQx9KagFuzj2cjpLD5fJFRSY+TE6suzqkDt0I+/LK5geR3275EESgAyEzAZh8NNbCw7I1pZnS2Bp3zn71AsFYbIlg=
Received: from AM0PR03CA0063.eurprd03.prod.outlook.com (2603:10a6:208::40) by
 AS8PR08MB9242.eurprd08.prod.outlook.com (2603:10a6:20b:5a1::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.26; Wed, 16 Oct
 2024 08:46:47 +0000
Received: from AM2PEPF0001C716.eurprd05.prod.outlook.com
 (2603:10a6:208:0:cafe::52) by AM0PR03CA0063.outlook.office365.com
 (2603:10a6:208::40) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.18 via Frontend
 Transport; Wed, 16 Oct 2024 08:46:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
 pr=C
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AM2PEPF0001C716.mail.protection.outlook.com (10.167.16.186) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.7918.13
 via Frontend Transport; Wed, 16 Oct 2024 08:46:46 +0000
Received: ("Tessian outbound 60a4253641a2:v473"); Wed, 16 Oct 2024 08:46:46 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 66f6257717cdf9db
X-TessianGatewayMetadata: CQXqpwwAyr1ToS4FNfYIn0hiVbj/Mozu+YX3mIjVy4/aKKCNK7mK8wTTxW0XTLR8YxnlhsFCOfgpysBL0WGtjp7zeoSw1wMYV4R1SWOD1E6LnKqC1IWX/Q1BIvPm2coK2kJkedgFA13TQ9N6DZ4nZaiXZrWybsNDANhjv7ECul0=
X-CR-MTA-TID: 64aa7808
Received: from L9b504f3a828b.2
	by 64aa7808-outbound-1.mta.getcheckrecipient.com id 04520D65-006C-4F82-87DE-9F9969E13D33.1;
	Wed, 16 Oct 2024 08:46:34 +0000
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id L9b504f3a828b.2
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Wed, 16 Oct 2024 08:46:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mll+WdrFWgn6JtwHMzLxWX8J78mmoM3rVbDfLy48lXc5sf7C7FPzWQxbBVmcnz5HiKh3L9njE5WhM0IpbN7r/Q9ilU7TZTucLZy6r4IiSB2BkU/l+WevG2vfz2eNBymbJ2XEokDV/vqgzHL7XewrvWvlQsY5BOJVey8FHvQLwuhPbyUWJVDCxsqPtba/+PZVF2IGbwPSCP8KFUdDTxGcnTgndQ7loHHGQCkOv/IaYHvRxfcrCMKdj1qJsEmALfgPOCgKO6zRC0dtKNpGF0+HDOTXR3ls9RjSfGlp3A/NnJp6BrGt95Cro4mWptMtYD5wLSrIieD1O/Ts96Yr5TEyig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wBIxsAXUsSF1YJWUycITxohmGUkVjO/an3OtuW6tq74=;
 b=L1V3znmW66eeZzc0eNO4e8ppiyY+lQejnsaKCkRxrN4O+ulfFMhet+ekVwW33UqHMyMFDU3oaTCrpwLGymZpO1A3N1Vg2Wd+h9pnHoID9Nk5D2JW2GIYfx8RccgCqrxChVXPay7zsB9dMNWO5YtekJfCjD3ffTprbCL9xU3vdCr5B1Oy1vszu9FoCi9QzB15CiAzgqm8W3H4ztyUBKDBeevCUo50VxHwS8AEW+q66RjXjsccA9n+jl8GRRh/Evg/ojd37ep7PyMNdL/GzsrNDsvvR5nE8+9VnVv6k57l3tVpc4yb0ODQl5FAb1luTQXSXyw9Jq65vjCwbWGzjnr/rA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wBIxsAXUsSF1YJWUycITxohmGUkVjO/an3OtuW6tq74=;
 b=g7JWyAmCvNJplRWQ9Fd8fcmbTAzbaB13EPiAOG5x+ezd7rBcjsPCiG2rh1+rCDo58lDWPbl9dge8B4i+OlLQx9KagFuzj2cjpLD5fJFRSY+TE6suzqkDt0I+/LK5geR3275EESgAyEzAZh8NNbCw7I1pZnS2Bp3zn71AsFYbIlg=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from GVXPR08MB7727.eurprd08.prod.outlook.com (2603:10a6:150:6b::6)
 by AS8PR08MB8466.eurprd08.prod.outlook.com (2603:10a6:20b:568::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.18; Wed, 16 Oct
 2024 08:46:29 +0000
Received: from GVXPR08MB7727.eurprd08.prod.outlook.com
 ([fe80::9672:63f7:61b8:5469]) by GVXPR08MB7727.eurprd08.prod.outlook.com
 ([fe80::9672:63f7:61b8:5469%7]) with mapi id 15.20.8048.020; Wed, 16 Oct 2024
 08:46:29 +0000
Message-ID: <4075a8bc-2f1e-441d-815e-aaf83e88d3d0@arm.com>
Date: Wed, 16 Oct 2024 09:46:26 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 17/43] arm64: RME: Allow VMM to set RIPAS
Content-Language: en-GB
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>, "Aneesh Kumar K . V"
 <aneesh.kumar@kernel.org>
References: <20241004152804.72508-1-steven.price@arm.com>
 <20241004152804.72508-18-steven.price@arm.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20241004152804.72508-18-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0362.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a3::14) To GVXPR08MB7727.eurprd08.prod.outlook.com
 (2603:10a6:150:6b::6)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	GVXPR08MB7727:EE_|AS8PR08MB8466:EE_|AM2PEPF0001C716:EE_|AS8PR08MB9242:EE_
X-MS-Office365-Filtering-Correlation-Id: b3b7f304-7da2-40de-54f1-08dcedbf11cd
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?V0h2R3hrTHVpR0o5ekoxY2s1Um5xcSsvRXZ6SmJEamg2VVBkT2F6bmhsZk4y?=
 =?utf-8?B?MU5BeEc2cjJBR21LQUFxcVdrc0djbmRjajB2QnBjZUwxQTVKUTRYUkg0MU5o?=
 =?utf-8?B?L0FKZmx6MUpSMDh0NFlaeTYrMkRuN2ROTWpRODluODZhSEdpOXEzcVc1S3Jj?=
 =?utf-8?B?RXFmbUtJVE92bElTYlFHejBhM29QMUZFM0IxRVVoY2FnWldlS3Evb0pqY2hB?=
 =?utf-8?B?Nm95TU1xZk43SHIrYzF6cTlzYUZJbWlPVmdBWTZTYm83dkw0dEo1OC96UUln?=
 =?utf-8?B?VnVWUkhHaGNrd3E4SHA5RDFFbmZBcXY5WFBYMmVHaUdoVVpQd1lGMWt0Z2ZM?=
 =?utf-8?B?S0VKaUNyR0pkQkcreE9EUjBDMXpySXlGLzZXcG95cUV0Syt2elFxU01uNFFq?=
 =?utf-8?B?M3hHNUxZM1RGbkYrZ3dOcldpYWY4TnorYkdoOW5aOGxhak8rL2taY0MvT0Jp?=
 =?utf-8?B?MTMzdlpHajBoWnlFN1ltNVNXRjBQUkZzZElMaVQ5VGw3SEY0U2VjQVRyZDQy?=
 =?utf-8?B?QlZwUU9UVlpQT0xqTk1QR0lVWGlKMWNEdkdNV01ZajRpK3RaM0U1UUlFbHZ3?=
 =?utf-8?B?M29Kcjl6NDBVRCtyVlRoNlB1UCthMHFqU2ZsSDFYakJ4Q2FlQ1NpcUF1aEhi?=
 =?utf-8?B?dmI3dTNrVnc1SEdhaVcvSnRPbXlmWjRMZnM0aXRIa2pRdlllWmk5VFFQZ2Nm?=
 =?utf-8?B?VDF0K1duNWN6V1kwYW9NRE9qZDYzcm13V1R5OGxiK0V4Nk84MHBnMG1OeVBv?=
 =?utf-8?B?eEtrRUNPRXM2ZUJuNmdYTWRRbjlyZkdHZ05CUWpLZ2U2ZmpBdy9YQnJWeGxP?=
 =?utf-8?B?N0JycGhHWG8zaWxSY2lUaUV2R0hJc080Zmk1OEtUSHBwQ2dWeWNGY3p6WUd1?=
 =?utf-8?B?R1pNc3RtY2h4OE9MSHdwaVJLbVh2aDN3bGRXU2Fwd3JoaTJ1cktMMGNtYmM3?=
 =?utf-8?B?djBXV3RkM0FDdzByK0J3N3B5RE9MZ2c3YVlKMzRPMjUzaDd2WHFTMXVOVFM2?=
 =?utf-8?B?c0tQazVkOWt1cElheU1lcUtmcUZJb1drVllTd0tWeHZSNVVqWnFtVXhjT3hm?=
 =?utf-8?B?aEFHWHBnbWc4c2ZSQnErMVNlSFgyZm0rZkhqMmY5SzVOZUh3WEYzcEFEa1FN?=
 =?utf-8?B?QzBOSGZQL0ttNFJmZUZ1ZEJUazVBWkpvaC9EMmh6RHpPTVRqc3V2ZDVoVXh2?=
 =?utf-8?B?MWk3alpGVHZ1NGxkNDVVNzhrWllVOFJmeDhTYTdZV0RXQ2N2RzlkcmozTkVr?=
 =?utf-8?B?K0hyaWw3N3JSN2VudXc5SGFFcDJISVdmR3BBdENpNGQ3a2p3c3hKK1Q2MU5l?=
 =?utf-8?B?bTI1dlUwaXo5WHlhcUhkcnh0WlQxMzN1SGo0RDRTQnpMSE5LTWZHMThqd3pn?=
 =?utf-8?B?SEZXcjVCWFMrdXFQSjZVcGlYWXNGTEJmTWtBcm53b0F6Mk9TNEpLZTRqeVJy?=
 =?utf-8?B?VDRNVjVrdG1RbGRIeGdTODd3Rmx4MVoyMUdjUUhmajBVZGRTWkpUMUZTeG1R?=
 =?utf-8?B?dTQ3ckxhUnJUdEo3ZVVGZENJVXYxUTBIVHBkZUtaOXFFbGVMcFRyNnpSNzFU?=
 =?utf-8?B?cktScmQrWXB1MW1MTkFKeFFpR0EyaExsRDVpNFRFSEhkOXNIN1pPSk0yMmh5?=
 =?utf-8?B?c01Tc05iMXkvQ1Z1QkIrNUltV3p2VEJLUWxoenoyVWpmR053SnFyc1RVZGFQ?=
 =?utf-8?B?RytrSzRZV2lVOVc2akRyMnhZYzFEcVcvdGRNOTlhNDFPc2FtMHFqVFVBPT0=?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GVXPR08MB7727.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB8466
Original-Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-SkipListedInternetSender:
 ip=[2603:10a6:150:6b::6];domain=GVXPR08MB7727.eurprd08.prod.outlook.com
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM2PEPF0001C716.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	ea17bb1e-e521-4b40-05f5-08dcedbf06c9
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|1800799024|376014|35042699022;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VHdHNHVQbHdEdWI4MTM1WXRycS95d3lmaWVpeGxRT2N5cTd2ZVYrMk9NNHBx?=
 =?utf-8?B?dHNsRnhDT2pTRllneStaR3V5Skt2YjRPa0x6YzhQZGMyZHp5bm5XVE9vdWZl?=
 =?utf-8?B?aUw4MXhrNVdpTnptbmlBdGhUOXZaekZBN3ZqSFh3UmlVU1hZQkN5cTJJbzNt?=
 =?utf-8?B?RFlYSzAxZTR4bEd4QkRvVXZGTkdPUldXOVArS2Q3dFZNMGMrbzBEUEV5eEJK?=
 =?utf-8?B?V0Myc2hRbGl3eFl4UXBLeDRXcEJhK0dxRk0wRitTMTNJM1FqOE5YZEdHd1E2?=
 =?utf-8?B?SDd1dDNtVXFkM2w3MEZ0SFI1U1lHbWo5NzNBK3Npc2tXdGxRdjh6OW1lemlU?=
 =?utf-8?B?WmViY1BQd0pObFNrYkY0cUdVZnRkd2lTTHBib2Yvb2pHQUxadk1PNDBKaXJk?=
 =?utf-8?B?T3pZc2tpYmJaSjI2LzdvZm1yV3BpL2dMMTVnaEtTcDVxaGI0RkY3SlhnRCsw?=
 =?utf-8?B?WjJLelFGZDVzRTVqT21lUjRyN2UvdndLa0pCVDFtVlVKSFUrbnhjS2pKNm1y?=
 =?utf-8?B?ZVpHRTI5TnJ5MVFGL051UElqU214TkVHUExoZHlzWWVuWWJFYWFBMnJTbWJP?=
 =?utf-8?B?d3VPdTRTYkpTMjQxT0pQMUpETGwrQ2Uwb0FYTFlNN2VUYkdTUlBvbXVOOG9h?=
 =?utf-8?B?SGNpVFRSK2k2emdzcWhJaVgvM3VUR3l6ODRmaUx4d2RsVXcrKzdXQzUwU0N1?=
 =?utf-8?B?ODUwam16ZHF2dHE1bGxOQ2Z4eTJ6MVNFRzlIVnVONG40TzFBN3NUYjEvY0FU?=
 =?utf-8?B?Z090SGtqb2RwL2R4WWpBUTVjTE4vUTg2eVk0Y00zZmpXU3dYRjgya3Y0SGtK?=
 =?utf-8?B?MWdpRTJweWladjFUd1UrVk5lMEY5NXZ5S2cwaEpjNENXQ1I5N2ZmcUJ0cEJI?=
 =?utf-8?B?OEtYekpFTFZVUE0xeFBHdXdRazJxRi9lM2h2dzNrMUJqcTF4N2ovZ3AyVGFT?=
 =?utf-8?B?MU56WUFaVTRjMXRHWFVNZ1U3eGdNVzVkVTdjS2sybVdSczA3WUVQcFg2Y2o4?=
 =?utf-8?B?RmxTV05mMGcyTEduaVBMMUFyRXF6dmZYNmRYMWl3c3o0NnVBOWJjOFA1czZz?=
 =?utf-8?B?MmhXU3ErWjExK2krdTZVMlFzQjdHcERSQ29jRlJyd2REWjU4TXdaa0RiWU1G?=
 =?utf-8?B?SWlaK1kyLzdDTHNKeGc4WnN6bitWY1FZM1Rnd2dKV28yUUJMU25iVG42NnVV?=
 =?utf-8?B?bmZtRnl0RWpkblZqSm1UUmFTVGtZRkNNdEFsbS9HeWVKNWlraW81M1hmUk5v?=
 =?utf-8?B?K1ZYNTZERDVDZXpjeUQ4YkVQZHlTSkdLNzJCSEZsZFdVdWFMTnlCWEl4aDlV?=
 =?utf-8?B?by9FZityc3YzNWlSNDVjcHBTOUJ4Qy9zNVlmaFVrNmE1Vmg0WmptSVFiK1dE?=
 =?utf-8?B?WEQ5UVZERWZCdFdzSm8xelV0L1llWUp2eTduU0UxVGwzODZQR2Q0aFBnaDNa?=
 =?utf-8?B?MzBPZmRrL2lkOWt1c2hhNHF3RXhjcDBRblR1SXc0OHlrRTFvWFdqSWtubncw?=
 =?utf-8?B?Z29reUhnenc3NDZVZ2VNaVZtd0UraUc2UU5qRSttRVZLSWUxTUdkRk1jSlM5?=
 =?utf-8?B?V25VV2c4ZGpBMlVRRk1vZXlMcUJsZXY0ZlBJQVNWNy9YOXRUU0NQei9CeGRa?=
 =?utf-8?B?b21DUGdpRTJzSWtRcDJ6cnIxZjd2NGxOTFFmUC9CcGgxVmNlSitvRGpDTFJD?=
 =?utf-8?B?RlQreVUwaTFuN2JBaXlialcvdDB6TkxtNEpIUmpYWklmVXpRYkhIaVBFVUxq?=
 =?utf-8?B?eldTdDl4TzJtbDVqY3lLT0hqclUwMXRWc01ZR1VFM1Bnay9vSXpJVnJDTkxk?=
 =?utf-8?B?RVJyREw5SmdNQmdlb0h1VEQyWjY0Q0pKb2QveGplc1JxRnJ5MU5hUXBBRWpl?=
 =?utf-8?Q?aYL1bgezc3fKW?=
X-Forefront-Antispam-Report:
	CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(1800799024)(376014)(35042699022);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2024 08:46:46.9692
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b3b7f304-7da2-40de-54f1-08dcedbf11cd
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM2PEPF0001C716.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB9242

Hi Steven

On 04/10/2024 16:27, Steven Price wrote:
> Each page within the protected region of the realm guest can be marked
> as either RAM or EMPTY. Allow the VMM to control this before the guest
> has started and provide the equivalent functions to change this (with
> the guest's approval) at runtime.
> 
> When transitioning from RIPAS RAM (1) to RIPAS EMPTY (0) the memory is
> unmapped from the guest and undelegated allowing the memory to be reused
> by the host. When transitioning to RIPAS RAM the actual population of
> the leaf RTTs is done later on stage 2 fault, however it may be
> necessary to allocate additional RTTs to allow the RMM track the RIPAS
> for the requested range.
> 
> When freeing a block mapping it is necessary to temporarily unfold the
> RTT which requires delegating an extra page to the RMM, this page can
> then be recovered once the contents of the block mapping have been
> freed. A spare, delegated page (spare_page) is used for this purpose.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes from v2:
>   * {alloc,free}_delegated_page() moved from previous patch to this one.
>   * alloc_delegated_page() now takes a gfp_t flags parameter.
>   * Fix the reference counting of guestmem pages to avoid leaking memory.
>   * Several misc code improvements and extra comments.
> ---
>   arch/arm64/include/asm/kvm_rme.h |  17 ++
>   arch/arm64/kvm/mmu.c             |   8 +-
>   arch/arm64/kvm/rme.c             | 481 ++++++++++++++++++++++++++++++-
>   3 files changed, 501 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_rme.h b/arch/arm64/include/asm/kvm_rme.h
> index 3a3aaf5d591c..c064bfb080ad 100644
> --- a/arch/arm64/include/asm/kvm_rme.h
> +++ b/arch/arm64/include/asm/kvm_rme.h
> @@ -96,6 +96,15 @@ void kvm_realm_destroy_rtts(struct kvm *kvm, u32 ia_bits);
>   int kvm_create_rec(struct kvm_vcpu *vcpu);
>   void kvm_destroy_rec(struct kvm_vcpu *vcpu);
>   
> +void kvm_realm_unmap_range(struct kvm *kvm,
> +			   unsigned long ipa,
> +			   u64 size,
> +			   bool unmap_private);
> +int realm_set_ipa_state(struct kvm_vcpu *vcpu,
> +			unsigned long addr, unsigned long end,
> +			unsigned long ripas,
> +			unsigned long *top_ipa);
> +
>   #define RME_RTT_BLOCK_LEVEL	2
>   #define RME_RTT_MAX_LEVEL	3
>   
> @@ -114,4 +123,12 @@ static inline unsigned long rme_rtt_level_mapsize(int level)
>   	return (1UL << RME_RTT_LEVEL_SHIFT(level));
>   }
>   
> +static inline bool realm_is_addr_protected(struct realm *realm,
> +					   unsigned long addr)
> +{
> +	unsigned int ia_bits = realm->ia_bits;
> +
> +	return !(addr & ~(BIT(ia_bits - 1) - 1));
> +}
> +
>   #endif
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index a26cdac59eb3..23346b1d29cb 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -310,6 +310,7 @@ static void invalidate_icache_guest_page(void *va, size_t size)
>    * @start: The intermediate physical base address of the range to unmap
>    * @size:  The size of the area to unmap
>    * @may_block: Whether or not we are permitted to block
> + * @only_shared: If true then protected mappings should not be unmapped
>    *
>    * Clear a range of stage-2 mappings, lowering the various ref-counts.  Must
>    * be called while holding mmu_lock (unless for freeing the stage2 pgd before
> @@ -317,7 +318,7 @@ static void invalidate_icache_guest_page(void *va, size_t size)
>    * with things behind our backs.
>    */
>   static void __unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64 size,
> -				 bool may_block)
> +				 bool may_block, bool only_shared)
>   {
>   	struct kvm *kvm = kvm_s2_mmu_to_kvm(mmu);
>   	phys_addr_t end = start + size;
> @@ -330,7 +331,7 @@ static void __unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64
>   
>   void kvm_stage2_unmap_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64 size)
>   {
> -	__unmap_stage2_range(mmu, start, size, true);
> +	__unmap_stage2_range(mmu, start, size, true, false);
>   }
>   
>   void kvm_stage2_flush_range(struct kvm_s2_mmu *mmu, phys_addr_t addr, phys_addr_t end)
> @@ -1919,7 +1920,8 @@ bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
>   
>   	__unmap_stage2_range(&kvm->arch.mmu, range->start << PAGE_SHIFT,
>   			     (range->end - range->start) << PAGE_SHIFT,
> -			     range->may_block);
> +			     range->may_block,
> +			     range->only_shared);
>   
>   	kvm_nested_s2_unmap(kvm);
>   	return false;
> diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
> index 6f0ced6e0cc1..1fa9991d708b 100644
> --- a/arch/arm64/kvm/rme.c
> +++ b/arch/arm64/kvm/rme.c
> @@ -47,9 +47,197 @@ static int rmi_check_version(void)
>   	return 0;
>   }
>   
> -u32 kvm_realm_ipa_limit(void)
> +static phys_addr_t alloc_delegated_page(struct realm *realm,
> +					struct kvm_mmu_memory_cache *mc,
> +					gfp_t flags)
>   {
> -	return u64_get_bits(rmm_feat_reg0, RMI_FEATURE_REGISTER_0_S2SZ);
> +	phys_addr_t phys = PHYS_ADDR_MAX;
> +	void *virt;
> +
> +	if (realm->spare_page != PHYS_ADDR_MAX) {
> +		swap(realm->spare_page, phys);
> +		goto out;
> +	}
> +
> +	if (mc)
> +		virt = kvm_mmu_memory_cache_alloc(mc);
> +	else
> +		virt = (void *)__get_free_page(flags);
> +
> +	if (!virt)
> +		goto out;
> +
> +	phys = virt_to_phys(virt);
> +
> +	if (rmi_granule_delegate(phys)) {
> +		free_page((unsigned long)virt);
> +
> +		phys = PHYS_ADDR_MAX;
> +	}
> +
> +out:
> +	return phys;
> +}
> +
> +static void free_delegated_page(struct realm *realm, phys_addr_t phys)
> +{
> +	if (realm->spare_page == PHYS_ADDR_MAX) {
> +		realm->spare_page = phys;
> +		return;
> +	}
> +

---  Cut here --

> +	if (WARN_ON(rmi_granule_undelegate(phys))) {
> +		/* Undelegate failed: leak the page */
> +		return;
> +	}
> +
> +	free_page((unsigned long)phys_to_virt(phys));

The above pattern of undelegate and reclaim a granule or leak appears 
elsewhere in the KVM support code. Is it worth having a common helper to
do the same ?

something like: reclaim_delegated_granule()


> +}
> +
> +static int realm_rtt_create(struct realm *realm,
> +			    unsigned long addr,
> +			    int level,
> +			    phys_addr_t phys)
> +{
> +	addr = ALIGN_DOWN(addr, rme_rtt_level_mapsize(level - 1));
> +	return rmi_rtt_create(virt_to_phys(realm->rd), phys, addr, level);
> +}
> +
> +static int realm_rtt_fold(struct realm *realm,
> +			  unsigned long addr,
> +			  int level,
> +			  phys_addr_t *rtt_granule)
> +{
> +	unsigned long out_rtt;
> +	int ret;
> +
> +	ret = rmi_rtt_fold(virt_to_phys(realm->rd), addr, level, &out_rtt);
> +
> +	if (RMI_RETURN_STATUS(ret) == RMI_SUCCESS && rtt_granule)
> +		*rtt_granule = out_rtt;
> +
> +	return ret;
> +}
> +
> +static int realm_destroy_protected(struct realm *realm,
> +				   unsigned long ipa,
> +				   unsigned long *next_addr)
> +{
> +	unsigned long rd = virt_to_phys(realm->rd);
> +	unsigned long addr;
> +	phys_addr_t rtt;
> +	int ret;
> +
> +loop:
> +	ret = rmi_data_destroy(rd, ipa, &addr, next_addr);
> +	if (RMI_RETURN_STATUS(ret) == RMI_ERROR_RTT) {
> +		if (*next_addr > ipa)
> +			return 0; /* UNASSIGNED */
> +		rtt = alloc_delegated_page(realm, NULL, GFP_KERNEL);
> +		if (WARN_ON(rtt == PHYS_ADDR_MAX))
> +			return -1;
> +		/*
> +		 * ASSIGNED - ipa is mapped as a block, so split. The index
> +		 * from the return code should be 2 otherwise it appears
> +		 * there's a huge page bigger than allowed

The comment could be misleading. RMM allows folding upto Level 1, but
KVM RMM driver doesn't do that yet.

> +		 */
> +		WARN_ON(RMI_RETURN_INDEX(ret) != 2);

I am not sure if we should relax it to something like :

		WARN_ON(RMI_RETURN_INDE(ret) < 1); ?

and

> +		ret = realm_rtt_create(realm, ipa, 3, rtt);

Use realm_rtt_create_levels(realm, ipa,..); ?

Agree that it complicates the whole code as we need at least two rtts 
and it becomes horribly complex for something we don't support yet.

So, the best approach would be, in the short term, to fix the comment
to make it explicit that it is something the KVM doesn't do yet.

> +		if (WARN_ON(ret)) {
> +			free_delegated_page(realm, rtt);
> +			return -1;
> +		}
> +		/* retry */
> +		goto loop;
> +	} else if (WARN_ON(ret)) {
> +		return -1;
> +	}


> +	ret = rmi_granule_undelegate(addr);
> +
> +	/*
> +	 * If the undelegate fails then something has gone seriously
> +	 * wrong: take an extra reference to just leak the page
> +	 */
> +	if (!WARN_ON(ret))
> +		put_page(phys_to_page(addr));

The same pattern of "reclaim_delegated_page()" repeats.

> +
> +	return 0;
> +}
> +
> +static void realm_unmap_range_shared(struct kvm *kvm,
> +				     int level,
> +				     unsigned long start,
> +				     unsigned long end)
> +{
> +	struct realm *realm = &kvm->arch.realm;
> +	unsigned long rd = virt_to_phys(realm->rd);
> +	ssize_t map_size = rme_rtt_level_mapsize(level);
> +	unsigned long next_addr, addr;
> +	unsigned long shared_bit = BIT(realm->ia_bits - 1);
> +
> +	if (WARN_ON(level > RME_RTT_MAX_LEVEL))
> +		return;
> +
> +	start |= shared_bit;
> +	end |= shared_bit;
> +
> +	for (addr = start; addr < end; addr = next_addr) {
> +		unsigned long align_addr = ALIGN(addr, map_size);
> +		int ret;
> +
> +		next_addr = ALIGN(addr + 1, map_size);
> +
> +		if (align_addr != addr || next_addr > end) {
> +			/* Need to recurse deeper */
> +			if (addr < align_addr)
> +				next_addr = align_addr;
> +			realm_unmap_range_shared(kvm, level + 1, addr,
> +						 min(next_addr, end));
> +			continue;
> +		}
> +
> +		ret = rmi_rtt_unmap_unprotected(rd, addr, level, &next_addr);
> +		switch (RMI_RETURN_STATUS(ret)) {
> +		case RMI_SUCCESS:
> +			break;
> +		case RMI_ERROR_RTT:
> +			if (next_addr == addr) {
> +				/*
> +				 * There's a mapping here, but it's not a block
> +				 * mapping, so reset next_addr to the next block
> +				 * boundary and recurse to clear out the pages
> +				 * one level deeper.
> +				 */
> +				next_addr = ALIGN(addr + 1, map_size);

> +				realm_unmap_range_shared(kvm, level + 1, addr,
> +							 next_addr);

In this particular case, we could simply destroy the RTT at level + 1, 
instead of unmapping individual entries at a lower level. Given we have
verified that the entry at "level" covers the range that we want to tear
down and there is an RTT down there. For unprotected IPA range this is
safe and efficient.

> +			}
> +			break;
> +		default:
> +			WARN_ON(1);
> +			return;
> +		}
> +	}
> +}
> +
> +static void realm_unmap_range_private(struct kvm *kvm,
> +				      unsigned long start,
> +				      unsigned long end)
> +{
> +	struct realm *realm = &kvm->arch.realm;
> +	ssize_t map_size = RME_PAGE_SIZE;
> +	unsigned long next_addr, addr;
> +
> +	for (addr = start; addr < end; addr = next_addr) {
> +		int ret;
> +
> +		next_addr = ALIGN(addr + 1, map_size);
> +
> +		ret = realm_destroy_protected(realm, addr, &next_addr);
> +
> +		if (WARN_ON(ret))
> +			break;

minor nit: We seem to be leaving the "spare" page dangling there, to be
collected later. May be we could try to reclaim the RTT pages once
"addr" crosses a "table worth" entry from "start". Or, given we deal
with entries at the L3, we could at the least reclaim L3 tables by
checking :

		if (IS_ALIGNED(next_addr, RME_L2_BLOCK_SIZE) &&
		    ALIGN(start, RME_L2_BLOCK_SIZE) != next_addr)
			/* Fold rtt for (addr, level=3) */

> +	}
>   }
>   
>   static int get_start_level(struct realm *realm)
> @@ -57,6 +245,26 @@ static int get_start_level(struct realm *realm)
>   	return 4 - stage2_pgtable_levels(realm->ia_bits);
>   }
>   
> +static void realm_unmap_range(struct kvm *kvm,
> +			      unsigned long start,
> +			      unsigned long end,
> +			      bool unmap_private)
> +{
> +	struct realm *realm = &kvm->arch.realm;
> +
> +	if (realm->state == REALM_STATE_NONE)
> +		return;
> +
> +	realm_unmap_range_shared(kvm, get_start_level(realm), start, end);

Could we use the "find_map_level(start, end)" instead of starting at the
top level ?

> +	if (unmap_private)
> +		realm_unmap_range_private(kvm, start, end);
> +}
> +
> +u32 kvm_realm_ipa_limit(void)
> +{
> +	return u64_get_bits(rmm_feat_reg0, RMI_FEATURE_REGISTER_0_S2SZ);
> +}
> +
>   static int realm_create_rd(struct kvm *kvm)
>   {
>   	struct realm *realm = &kvm->arch.realm;
> @@ -140,6 +348,30 @@ static int realm_rtt_destroy(struct realm *realm, unsigned long addr,
>   	return ret;
>   }
>   
> +static int realm_create_rtt_levels(struct realm *realm,
> +				   unsigned long ipa,
> +				   int level,
> +				   int max_level,
> +				   struct kvm_mmu_memory_cache *mc)
> +{
> +	if (WARN_ON(level == max_level))
> +		return 0;
> +
> +	while (level++ < max_level) {
> +		phys_addr_t rtt = alloc_delegated_page(realm, mc, GFP_KERNEL);
> +
> +		if (rtt == PHYS_ADDR_MAX)
> +			return -ENOMEM;
> +
> +		if (realm_rtt_create(realm, ipa, level, rtt)) {
> +			free_delegated_page(realm, rtt);
> +			return -ENXIO;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
>   static int realm_tear_down_rtt_level(struct realm *realm, int level,
>   				     unsigned long start, unsigned long end)
>   {
> @@ -231,6 +463,90 @@ static int realm_tear_down_rtt_range(struct realm *realm,
>   					 start, end);
>   }
>   
> +/*
> + * Returns 0 on successful fold, a negative value on error, a positive value if
> + * we were not able to fold all tables at this level.
> + */
> +static int realm_fold_rtt_level(struct realm *realm, int level,
> +				unsigned long start, unsigned long end)
> +{
> +	int not_folded = 0;
> +	ssize_t map_size;
> +	unsigned long addr, next_addr;
> +
> +	if (WARN_ON(level > RME_RTT_MAX_LEVEL))
> +		return -EINVAL;
> +
> +	map_size = rme_rtt_level_mapsize(level - 1);
> +
> +	for (addr = start; addr < end; addr = next_addr) {
> +		phys_addr_t rtt_granule;
> +		int ret;
> +		unsigned long align_addr = ALIGN(addr, map_size);
> +
> +		next_addr = ALIGN(addr + 1, map_size);
> +
> +		ret = realm_rtt_fold(realm, align_addr, level, &rtt_granule);
> +
> +		switch (RMI_RETURN_STATUS(ret)) {
> +		case RMI_SUCCESS:
> +			if (!WARN_ON(rmi_granule_undelegate(rtt_granule)))
> +				free_page((unsigned long)phys_to_virt(rtt_granule));

Same pattern for reclaim_delegated_page()

> +			break;
> +		case RMI_ERROR_RTT:
> +			if (level == RME_RTT_MAX_LEVEL ||
> +			    RMI_RETURN_INDEX(ret) < level) {
> +				not_folded++;
> +				break;
> +			}
> +			/* Recurse a level deeper */
> +			ret = realm_fold_rtt_level(realm,
> +						   level + 1,
> +						   addr,
> +						   next_addr);
> +			if (ret < 0)
> +				return ret;
> +			else if (ret == 0)
> +				/* Try again at this level */
> +				next_addr = addr;
> +			break;
> +		default:
> +			WARN_ON(1);
> +			return -ENXIO;
> +		}
> +	}
> +
> +	return not_folded;
> +}
> +
> +static int realm_fold_rtt_range(struct realm *realm,
> +				unsigned long start, unsigned long end)
> +{
> +	return realm_fold_rtt_level(realm, get_start_level(realm) + 1,

Could we use find_map_level() for this too ?

> +				    start, end);
> +}
> +
> +static void ensure_spare_page(struct realm *realm)
> +{
> +	phys_addr_t tmp_rtt;
> +
> +	/*
> +	 * Make sure we have a spare delegated page for tearing down the
> +	 * block mappings. We do this by allocating then freeing a page.
> +	 * We must use Atomic allocations as we are called with kvm->mmu_lock
> +	 * held.
> +	 */
> +	tmp_rtt = alloc_delegated_page(realm, NULL, GFP_ATOMIC);
> +
> +	/*
> +	 * If the allocation failed, continue as we may not have a block level
> +	 * mapping so it may not be fatal, otherwise free it to assign it
> +	 * to the spare page.
> +	 */
> +	if (tmp_rtt != PHYS_ADDR_MAX)

Ah, it took a while to understand this logic :-(. "free it to assign it"
sounds unconventional, but it works.

> +		free_delegated_page(realm, tmp_rtt);
> +}
> +
>   void kvm_realm_destroy_rtts(struct kvm *kvm, u32 ia_bits)
>   {
>   	struct realm *realm = &kvm->arch.realm;
> @@ -238,6 +554,155 @@ void kvm_realm_destroy_rtts(struct kvm *kvm, u32 ia_bits)
>   	WARN_ON(realm_tear_down_rtt_range(realm, 0, (1UL << ia_bits)));
>   }
>   
> +void kvm_realm_unmap_range(struct kvm *kvm, unsigned long ipa, u64 size,
> +			   bool unmap_private)
> +{
> +	unsigned long end = ipa + size;
> +	struct realm *realm = &kvm->arch.realm;
> +
> +	end = min(BIT(realm->ia_bits - 1), end);
> +
> +	ensure_spare_page(realm);
> +
> +	realm_unmap_range(kvm, ipa, end, unmap_private);
> +
> +	if (unmap_private)
> +		realm_fold_rtt_range(realm, ipa, end);

I see this (and ate up my agressive RTT reclaim thoughts at
realm_unmap_range_private()) , but we may need more than one spare
rtt if the range is sufficiently bigger, given the "spare" rtt is not
reclaimed until we finish the range ? May be we could reclaim the
"spare" rtt alone as make progress, as commented above ?

> +}
> +
> +static int find_map_level(struct realm *realm,
> +			  unsigned long start,
> +			  unsigned long end)
> +{

As mentioned above, this is useful for unmap_shared() to
start at a level that is suitable.

> +	int level = RME_RTT_MAX_LEVEL;
> +
> +	while (level > get_start_level(realm)) {
> +		unsigned long map_size = rme_rtt_level_mapsize(level - 1);
> +
> +		if (!IS_ALIGNED(start, map_size) ||
> +		    (start + map_size) > end)
> +			break;
> +
> +		level--;
> +	}
> +
> +	return level;
> +}
> +
> +int realm_set_ipa_state(struct kvm_vcpu *vcpu,
> +			unsigned long start,
> +			unsigned long end,
> +			unsigned long ripas,
> +			unsigned long *top_ipa)
> +{
> +	struct kvm *kvm = vcpu->kvm;
> +	struct realm *realm = &kvm->arch.realm;
> +	struct realm_rec *rec = &vcpu->arch.rec;
> +	phys_addr_t rd_phys = virt_to_phys(realm->rd);
> +	phys_addr_t rec_phys = virt_to_phys(rec->rec_page);
> +	struct kvm_mmu_memory_cache *memcache = &vcpu->arch.mmu_page_cache;
> +	unsigned long ipa = start;
> +	int ret = 0;
> +
> +	while (ipa < end) {
> +		unsigned long next;
> +
> +		ret = rmi_rtt_set_ripas(rd_phys, rec_phys, ipa, end, &next);
> +
> +		if (RMI_RETURN_STATUS(ret) == RMI_ERROR_RTT) {
> +			int walk_level = RMI_RETURN_INDEX(ret);
> +			int level = find_map_level(realm, ipa, end);
> +
> +			/*
> +			 * If the RMM walk ended early then more tables are
> +			 * needed to reach the required depth to set the RIPAS.
> +			 */
> +			if (walk_level < level) {
> +				ret = realm_create_rtt_levels(realm, ipa,
> +							      walk_level,
> +							      level,
> +							      memcache);
> +				/* Retry with RTTs created */
> +				if (!ret)
> +					continue;
> +			} else {
> +				ret = -EINVAL;
> +			}
> +
> +			break;
> +		} else if (RMI_RETURN_STATUS(ret) != RMI_SUCCESS) {
> +			WARN(1, "Unexpected error in %s: %#x\n", __func__,
> +			     ret);
> +			ret = -EINVAL;
> +			break;
> +		}
> +		ipa = next;
> +	}
> +
> +	*top_ipa = ipa;
> +
> +	if (ripas == RMI_EMPTY && ipa != start) {
> +		realm_unmap_range_private(kvm, start, ipa);
> +		realm_fold_rtt_range(realm, start, ipa);

minor nit: Could we not move the realm_fold_rtt_range() into the 
unmap_range_private() ? Both cases (from here as well as unmap_range())
we seem to be doing it.

Suzuki



> +	}
> +
> +	return ret;
> +}
> +
> +static int realm_init_ipa_state(struct realm *realm,
> +				unsigned long ipa,
> +				unsigned long end)
> +{
> +	phys_addr_t rd_phys = virt_to_phys(realm->rd);
> +	int ret;
> +
> +	while (ipa < end) {
> +		unsigned long next;
> +
> +		ret = rmi_rtt_init_ripas(rd_phys, ipa, end, &next);
> +
> +		if (RMI_RETURN_STATUS(ret) == RMI_ERROR_RTT) {
> +			int err_level = RMI_RETURN_INDEX(ret);
> +			int level = find_map_level(realm, ipa, end);
> +
> +			if (WARN_ON(err_level >= level))
> +				return -ENXIO;
> +
> +			ret = realm_create_rtt_levels(realm, ipa,
> +						      err_level,
> +						      level, NULL);
> +			if (ret)
> +				return ret;
> +			/* Retry with the RTT levels in place */
> +			continue;
> +		} else if (WARN_ON(ret)) {
> +			return -ENXIO;
> +		}
> +
> +		ipa = next;
> +	}
> +
> +	return 0;
> +}
> +
> +static int kvm_init_ipa_range_realm(struct kvm *kvm,
> +				    struct kvm_cap_arm_rme_init_ipa_args *args)
> +{
> +	gpa_t addr, end;
> +	struct realm *realm = &kvm->arch.realm;
> +
> +	addr = args->init_ipa_base;
> +	end = addr + args->init_ipa_size;
> +
> +	if (end < addr)
> +		return -EINVAL;
> +
> +	if (kvm_realm_state(kvm) != REALM_STATE_NEW)
> +		return -EINVAL;
> +
> +	return realm_init_ipa_state(realm, addr, end);
> +}
> +
>   /* Protects access to rme_vmid_bitmap */
>   static DEFINE_SPINLOCK(rme_vmid_lock);
>   static unsigned long *rme_vmid_bitmap;
> @@ -363,6 +828,18 @@ int kvm_realm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
>   	case KVM_CAP_ARM_RME_CREATE_RD:
>   		r = kvm_create_realm(kvm);
>   		break;
> +	case KVM_CAP_ARM_RME_INIT_IPA_REALM: {
> +		struct kvm_cap_arm_rme_init_ipa_args args;
> +		void __user *argp = u64_to_user_ptr(cap->args[1]);
> +
> +		if (copy_from_user(&args, argp, sizeof(args))) {
> +			r = -EFAULT;
> +			break;
> +		}
> +
> +		r = kvm_init_ipa_range_realm(kvm, &args);
> +		break;
> +	}
>   	default:
>   		r = -EINVAL;
>   		break;

