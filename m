Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2041.outbound.protection.outlook.com [40.107.21.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C0651C07E0;
	Tue, 15 Oct 2024 12:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.21.41
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728996532; cv=fail; b=JGflAgSM8O7r1GJyoH4AyfwFZXJm7gzeUrDdhYoTkZGPAX+2Rb2ZRv2cAMKufPXo81gcn02+FkX+zWl5gCr+0MMgYeHs+JTalzwrWZ8X+NYuwR6Ja9SUc//nrs3G1fkL0D75ErzdZF5j805eM6Fv5+K8SS2v7UEVKSBdScw2E+4=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728996532; c=relaxed/simple;
	bh=YedFrnokZGHr9b8fM1HXcTUAphz9+uzXnLoe7CervNU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=LDkvMk/UKNzQXGCiBl3AOf3dWmgiIxq05hJlrse5d7790M3AYO9NGQXAdCQffL47/PJoDFbV39qpEBQJQ7qS1Rw2XfgIrdZriCkCgkzwEKWYAXoHfMSLntDmAW3vxOYNcMWbnynqiKjZVKcOqYht3jOondUnF8/4bw0w02nJSIQ=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=mgJvhdys; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=mgJvhdys; arc=fail smtp.client-ip=40.107.21.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="mgJvhdys";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="mgJvhdys"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=Vh78l6u7o/YwIDpBdZi2hrD5k4PbA+46CIUHc5RSXq6hZPnLfSvACCuCsx4Ta0vR846ZYBypip4BQMHAFAy/SehCVw3EUuUQRPOZfDOpaj8wsYsRsYekHCYZK5u1UCLHIQUcSd8wvE1mxCmHKgIWKn9x0Nib7N0kmVA0jKDJ6drwdCCz65QBNH2g+Npvtt7aq1+OihyiCZJ0en6zeeeSOfrFd8dh5TaVM9+6CAK4d1P7TU8/PWQQ50vkHeZvV/983QVCis8m56gzoVodFnKWF0BhcK0k9P6hXQoKsa0JTrsgEyIe8t7tBTXi4M5SZzArQJarJdju1Y4uoY3PRaktdw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eB9609zvMbchdkyfXpNxyPlh67FSvA4uhUlZQUoyCyA=;
 b=Lo0FuQG0ofPgs0oJvng8bWczYaatC7zn43T1kH/A4UGrU6BKoDoL9RNqc42Ud/NtP3KsCFGiUf0Ijqm7W5a04IgHaVO+g6QKp9vOgb1crsTuB3ykwPZMQi3ZBpvE8g/JSCmAt0i83qNumIZg/qlhoO/booGrhuXAdRMGItz/bY0EsfmDBd5if8jjT/FYbmCTYtn6RV91LnHUsps/Qx9+wkz1lv2dLC8VaX5uRyiu8SCH4fb9vbQ8iflrste8JSi8PswWuVLbA+cLP5yC1s84HzyXiYdI24RtSj/kmj31F78PhLgp5ATJfNfZXyhXpnHGWtaZpyTQVWw9l6Q0ZR5xhw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 63.35.35.123) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eB9609zvMbchdkyfXpNxyPlh67FSvA4uhUlZQUoyCyA=;
 b=mgJvhdys1B4JxRPmNgP4OEmdcwxLs7kXCS9a/ZBQzFdpdwvSCnpA+ZdZKp+uxnzh3YDRZcjF9/1bIYMaTjB7676vzmhLY0lIKSd6ziMlAvGPQTuc/xsm+ewSigaXQFmHAtuhg4QTOZqKHW/sm24I+ynMn3yfCK9DZ6HXQg2ONlg=
Received: from PR1P264CA0196.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:34d::7)
 by AS8PR08MB10172.eurprd08.prod.outlook.com (2603:10a6:20b:628::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.22; Tue, 15 Oct
 2024 12:48:42 +0000
Received: from AM4PEPF00025F96.EURPRD83.prod.outlook.com
 (2603:10a6:102:34d:cafe::5d) by PR1P264CA0196.outlook.office365.com
 (2603:10a6:102:34d::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.26 via Frontend
 Transport; Tue, 15 Oct 2024 12:48:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
 pr=C
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AM4PEPF00025F96.mail.protection.outlook.com (10.167.16.5) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8093.1 via
 Frontend Transport; Tue, 15 Oct 2024 12:48:41 +0000
Received: ("Tessian outbound cd6aa7fa963a:v473"); Tue, 15 Oct 2024 12:48:41 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 6a48062eedcba61c
X-TessianGatewayMetadata: Icjp+1A2slBswNVIPftU0NbZtdh5cTiAeKo+ZIqcxcUTjNxh649ZGqxRekc6u2HaZpKWp0x0m5AccMCh0OvPhYTsPnQZZ+Q7lcQ9yyjZcS3nKjIH7NAHXtnOdSrfmqcxeJjAZle/mc86eWftTlpo0q+1cGZQkg0OSnB4wOvqMFY=
X-CR-MTA-TID: 64aa7808
Received: from Lcab9e31480f5.2
	by 64aa7808-outbound-1.mta.getcheckrecipient.com id B5177B8E-12AC-4ECF-9565-3B8854197832.1;
	Tue, 15 Oct 2024 12:48:30 +0000
Received: from EUR05-DB8-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id Lcab9e31480f5.2
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Tue, 15 Oct 2024 12:48:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DIH6Hc06chxTsu0y6Vle3RuhkJtVTT/03GxALnZ0gUCr6KW8Zrtf1pLaP85zxvM4jX8r5xGSewDTS8nC/Nw2DtKYlhN43ocVp2hwYyZw+3Tx4dW88gGJwLGQJSnKlCs7x8prCjEgczv0tCLB6Uyg3XqqRGA85nWbwWWXOb1t5lI0vVYxsi+/wzrE3U5TEfjRPD8QmQFXPpn7kv/vkhe1c3++eTQdy8RnTRAWv3tlhqg0aBvWX8u5jHeGkuucTRpCcDlw82JCNepTVzGr26AEc2WtPlPuoTfF76rx3pS7R9SVCv4ts7d4tiwbc+elhqNg/24J+XUkxcrh4YbGafG+gQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eB9609zvMbchdkyfXpNxyPlh67FSvA4uhUlZQUoyCyA=;
 b=LHhzBqWWXXoZl2nF1GaNzLINj53wtj1imWoyXJ8VD39n3DrWxXoY3QlH/vjRUXt5YJA6mMR9aisfKN6tA1aRt3tD5DPbub/oFosATr8A6z6JfoGN3aKqNgZtJQTet7JX19/AR/AKWVlNAaSLl0JI9Ls9M5wdRQl8Zf9XFkp0zx27iQq4s0ufnXDYqFnEhkPzvGqHDwbp/Q8k3rQU5m+gkduHIWQXJ2U+f+DgCGbm59cZnrSpiESq5uocYeLfQCDCvRYH1V9OiQRRP/r4j2tWNpMc7cKNl044EiZ8ygbLXcIxvhyg2Bq8KqjXlfe/cg9ZT5xSMRq7pOHvXOhEB77mpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eB9609zvMbchdkyfXpNxyPlh67FSvA4uhUlZQUoyCyA=;
 b=mgJvhdys1B4JxRPmNgP4OEmdcwxLs7kXCS9a/ZBQzFdpdwvSCnpA+ZdZKp+uxnzh3YDRZcjF9/1bIYMaTjB7676vzmhLY0lIKSd6ziMlAvGPQTuc/xsm+ewSigaXQFmHAtuhg4QTOZqKHW/sm24I+ynMn3yfCK9DZ6HXQg2ONlg=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from GVXPR08MB7727.eurprd08.prod.outlook.com (2603:10a6:150:6b::6)
 by GV1PR08MB8081.eurprd08.prod.outlook.com (2603:10a6:150:97::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.26; Tue, 15 Oct
 2024 12:48:20 +0000
Received: from GVXPR08MB7727.eurprd08.prod.outlook.com
 ([fe80::9672:63f7:61b8:5469]) by GVXPR08MB7727.eurprd08.prod.outlook.com
 ([fe80::9672:63f7:61b8:5469%7]) with mapi id 15.20.8048.020; Tue, 15 Oct 2024
 12:48:20 +0000
Message-ID: <6d4bf0cc-7060-4843-9e15-e4ed23c74839@arm.com>
Date: Tue, 15 Oct 2024 13:48:17 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 14/43] arm64: RME: Allocate/free RECs to match vCPUs
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
 <20241004152804.72508-15-steven.price@arm.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20241004152804.72508-15-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0169.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18a::12) To GVXPR08MB7727.eurprd08.prod.outlook.com
 (2603:10a6:150:6b::6)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	GVXPR08MB7727:EE_|GV1PR08MB8081:EE_|AM4PEPF00025F96:EE_|AS8PR08MB10172:EE_
X-MS-Office365-Filtering-Correlation-Id: 2793768c-fd60-4205-3f8e-08dced17b2cb
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|366016|7416014|1800799024;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?SXNuNnVza0JKSkZnWEFKa0YyWGx1OUd0K252RVRCM2I2bUNNYzExVFJxTTlN?=
 =?utf-8?B?cG1JdjM5SGs0SHc5US8yaXhvSkJCSFo3d1BtdUdDWjg3R3RBVTBiSkVXU3ZX?=
 =?utf-8?B?R21rNGJVSFVHYStXeDN1SGpXZnovUkJsV2NUeFdPemVVbWxNQUthQ0YzYmRm?=
 =?utf-8?B?SGRTbUpMNkVGcUVMaFVSNmVicmxFcStUMXlxemNHK3lwUlJaVEdacjhPMnpS?=
 =?utf-8?B?OWRTTmp0ZW1nUW9LQU9ZS3g1c0o2anpGd1FqOUVYb29DdG5WeThHclMvbE9J?=
 =?utf-8?B?ZTVHZmZaY3owMHFUVVkwQTB4RURpUWJaaXoyS0FLU3l4ZXZQbFVpU25WdGpi?=
 =?utf-8?B?dy8zQ2xBSHdWYmhrVTM3VDRBUWlVbGlma081Ukk2U3FpaW1wWmNzd0ZHVFdC?=
 =?utf-8?B?dkwzK2VFS1JsM0JFWi9YazIvclRJN25TcXJ3cy9uTm9kV2ltSmhRbXczMnY1?=
 =?utf-8?B?TE11YURGWmZ2T1d5OXdwbjQrM3FBaVZ4SnloNW00Y2QraDZydmUvY3ZhNmJx?=
 =?utf-8?B?bGxWUTF4UVRkaDFBYjNPVHhDNjJnYVk2VGFtVjAxOG1zN002S0RMYTZaTjVm?=
 =?utf-8?B?VGRxNHVPMWdhVmlPb1FVY053b3VNR1E4TDVKN3ovZlkxVkdJV0dpNllwWTg0?=
 =?utf-8?B?SlVZVi9kVWRJZWNmeGZrMys1dEJVL2k2RGZNazF4aWNycDc4eG5vRGE1RlIw?=
 =?utf-8?B?NmwzQUY1VU9WWUZlNzQ2ZWdPQk9QeXh0aFo5VkJmbVFpMStsU25qOXBDUCt4?=
 =?utf-8?B?VW9zSnVBaXpDVWE0OTQzaXhlbFNFVENuS1NEY3pFTUJEdC9xcE9YK3g3S1Bk?=
 =?utf-8?B?c2UxWEhxZXdVY2dWUXZINWJjWnJGd0dCU2ZPUS9LTUJBODBGRFZ6WURtWnc1?=
 =?utf-8?B?N1RJelVmd0VqRGtQRXVzR1N1RzhpdzcvdzkrYUVobC9XTFF4RnRCNDFPVTh0?=
 =?utf-8?B?SGtYMlRvOG01ZWtkdVBlNnhTODZHbVFvVnpGUDdhM0JGUmdxdjBFd204S2dp?=
 =?utf-8?B?MSs3QmZaRGZhU1JabHhISUMvcmw4WkR6UFdBYjdLYWViN29zeTl1KzY3YjlE?=
 =?utf-8?B?eVE2Y3NDWktMak9aYmdYOVdzYWZOdXMzWmNNOGNUK1E5cGhzaGY5OWNNOS9K?=
 =?utf-8?B?T3M2VFNKL2JuU3FKdU1KZTJDczIxSDJValZ1SzRiQVJkcHRSb1hYbHJXQmhw?=
 =?utf-8?B?MXNBeDRUb08rWlcyTzFKL05TMEVPU2pXWEpUcFBQQTNJdnpERk5ocmVnVER0?=
 =?utf-8?B?WTRzZnZKS0Vmc3NMNWwvem1hSXIyVmkrR3FLSDRBRHVTY3Bud3NiOGxlVXlo?=
 =?utf-8?B?QjNlOWVMWjQwU1lITXlhYTNpOFVwdjh1Tk41RWFGQWJSVGZjMzhHcUd3TGpF?=
 =?utf-8?B?RmhNVXM5akN5a2FCeHBVdTFTOUNWNjlUd0VrakVLWklmblFoc2Jlcnh5NXVQ?=
 =?utf-8?B?WUIyTlNvT1hoSTdzZDAxd2VQelREK2s3bnk3ZzUxbjRscWpldmNJMVBtam5t?=
 =?utf-8?B?Y0Z5dnRjeVlNWHBHY3ljNS94bW5ma1Zicy9FNDhYSllZT0RzSG53QmVlYXBG?=
 =?utf-8?B?Mk0yVVhZZmF1ZWNpMDE1TVFaRWJvcnBVT0Irb3JYVWQrQU1NLzB2M056NmpJ?=
 =?utf-8?B?ampveHF6RnRiY0x0bmxleUx2OW0wVkFCelBzNzBKdUk5VWJHNzdzbUZkSXRV?=
 =?utf-8?B?YnVHQWtTSE8zN2dkeVZJK2FodVplSC9CbUpYMGNlVjVkajczcmFIWnlRPT0=?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GVXPR08MB7727.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR08MB8081
Original-Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-SkipListedInternetSender:
 ip=[2603:10a6:150:6b::6];domain=GVXPR08MB7727.eurprd08.prod.outlook.com
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM4PEPF00025F96.EURPRD83.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	931615dc-6203-4304-d1f9-08dced17a5c4
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700013|1800799024|82310400026|35042699022;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NkxDWTRtMUZtZ280ci85VTZFVkJ1SGhNVDFJQmxMVVBNY252SlVmU2hISGR6?=
 =?utf-8?B?bVliaEl2dXNNNFJXR2NmRGVtU3FmbS9mb3J5KzZXdWxxZ2JMTm9UN3VZbkdH?=
 =?utf-8?B?Wjd3OXd5ajlZK1JCKzROWjBFMGJJd2dZdE5ET2pDN3pDenU4QjlkZk9qY056?=
 =?utf-8?B?YjZRelJsODdzWUgrTVJPb21vYXdxS1BuTm5CZGU2TkJ4T1pBdHRXVmVGT21y?=
 =?utf-8?B?REFuR3FVYlJKV0xqSFNLUjc5VnZ1bXJWS216Y0ZyYkUxdFFZODFEOThHZlZx?=
 =?utf-8?B?NVZpOEc3SWduNExwWG5mWktEV0ZQQW5ydkJkVmxVQ3ZETFJyK25JaGVZalZZ?=
 =?utf-8?B?cUF4M29tUlloVjkwTHRKaVF5ZzhoblErcHZ0azBWUTFQWXJMdWtGT0hSc0lF?=
 =?utf-8?B?SGRoSjBUOHMwVzMxUm5OQkZGUHNDNlM3UGFhY0RzRjFwOHA0SGpObmhHZHkv?=
 =?utf-8?B?TVpEeHN6akpQdUVqVlE0bTZFeXcwQW81YzZyUHdZcVc4MUVZcWw4WTVZcTBi?=
 =?utf-8?B?c0FDK3p3ejc1TjJMQ1ZKaXd1ZkEzTG1Kd2V1ckhadlYxQTh4QkVPZE1LQmJj?=
 =?utf-8?B?aG9ZTDlvdXlodzVwYk1ENEFtUTVzK2l4KzQ1L095YlFKd3ZrY01xZnNlUjZk?=
 =?utf-8?B?UHhLcVRNT0ZTRS8wZXN0d2tsU0JFdXB5a0l1cWVLOGYxT3lYQXB0djc2RXQ5?=
 =?utf-8?B?aXZyaTFHV1JmaG9SQmx0RXpMM2pVNlExOEFOcXFFUXF6dElTQkNVTHNKTlJS?=
 =?utf-8?B?K1k3N0hMaEVDMEhKRUFXbWk4Nyt5RmRqY0Z1UW5BN201VnRTU3paamt5NUpR?=
 =?utf-8?B?MDJmQk0xLytoQ1JLdk5TZzNmbmVHQUYwbks5M05FUzJXQUpqVzBoREp4TTlS?=
 =?utf-8?B?YmxwWUl2a0VsMnJoWkpRbEFSVGlWN0IrTFJPcFhpWVFjL2hhaXJJNzkzeTJC?=
 =?utf-8?B?VThkQ3dBQXVyTTVGL0VmTFhZU1RuSFBjS25tdDdNNXU5UXU5cmZ5ZGZTY1po?=
 =?utf-8?B?LzJSYUZVd1BFd3VselZVQkdXSVFUV1dWekZuWGdHYncwOHBuYWlwRjBwSkRy?=
 =?utf-8?B?ZFNYK3JOYnYwTzlOdk5nUVJIZHdaYTc5VG9iUDl0NzZWclg5VWMwMlBVUUJU?=
 =?utf-8?B?TDZ0MlRleXVoZU5jS3l2cWRieTdUQytDZEVZeDFvUXh4YmFjbGN6MFp4RWV4?=
 =?utf-8?B?dmFmWFpwTDYxeHJ3TUtweGFKMmtDMGlvbmJ2MkFzdm9QbFFWV091dHpMNmMv?=
 =?utf-8?B?cVpxakNPbjh3cHFiNEMydE9tMmxrbklLQ0tSQkJ2dExtRURWQVh1cm1jOXl2?=
 =?utf-8?B?NnY3ek1XVjVsT0FSNXYxb2dTSmpON3hZcFM0Z3BMMkgrMDBZQjRQRGY2TEND?=
 =?utf-8?B?UW0rU0FWNVozOUI2N3J4SVZwOUJYL1NDVlZPeHl2R2pPY3BQUnlySG1VSFJh?=
 =?utf-8?B?eFE0SkE4MjE1L0NxbFlQVDRxaFV2N0NXenN4ZWZWSjdIUERncDJJRlJYTDlu?=
 =?utf-8?B?eVYvNTFMN0VrTGFFUVFZNmtZOVFBekZ2RFBmUWRBMS82NXdxTTdTeWNXcEps?=
 =?utf-8?B?Rk9waUlJaXFrTEkwMExJbCtGK0NDQldTdHp5ZmVKdTRnb0ZJOS9NeW1UUndW?=
 =?utf-8?B?V3l5STl3YmkrUVdTUEpzeGtiYWJRRFFMN2k2Qy9vUHliM2xWQUk4L2laRENU?=
 =?utf-8?B?RktxZ3BZOG5NOEU1eU5wMEgzME5qTy9Tamo3Q0ZiTWV1TDd2SDBsUnVIUWI0?=
 =?utf-8?B?c1lkZktweSsxV3ZBS0RBc2N6R005emNxSGxoK0o1dFVPUlVnL0xGRlREd1Qv?=
 =?utf-8?B?Y0hOckYzamVjZjlGMjBjYlBiTmYvM1JzVFg0RGt4a0JsMnR6QUJjUXFnTFEy?=
 =?utf-8?Q?p4IYHc582Eqpf?=
X-Forefront-Antispam-Report:
	CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(13230040)(376014)(36860700013)(1800799024)(82310400026)(35042699022);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2024 12:48:41.8681
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2793768c-fd60-4205-3f8e-08dced17b2cb
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM4PEPF00025F96.EURPRD83.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB10172

Hi Steven

On 04/10/2024 16:27, Steven Price wrote:
> The RMM maintains a data structure known as the Realm Execution Context
> (or REC). It is similar to struct kvm_vcpu and tracks the state of the
> virtual CPUs. KVM must delegate memory and request the structures are
> created when vCPUs are created, and suitably tear down on destruction.
> 
> RECs must also be supplied with addition pages - auxiliary (or AUX)
> granules - for storing the larger registers state (e.g. for SVE). The
> number of AUX granules for a REC depends on the parameters with which
> the Realm was created - the RMM makes this information available via the
> RMI_REC_AUX_COUNT call performed after creating the Realm Descriptor (RD).
> 
> Note that only some of register state for the REC can be set by KVM, the
> rest is defined by the RMM (zeroed). The register state then cannot be
> changed by KVM after the REC is created (except when the guest
> explicitly requests this e.g. by performing a PSCI call).

The patch looks good to me. It may be a good idea to mention the strict
ordering of REC creation (i.e., in the ascending order of the mpidr)
mandated by the RMM and how we leave it to the VMM to do it in order.


Suzuki



> 
> See Realm Management Monitor specification (DEN0137) for more information:
> https://developer.arm.com/documentation/den0137/
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes since v2:
>   * Free rec->run earlier in kvm_destroy_realm() and adapt to previous patches.
> ---
>   arch/arm64/include/asm/kvm_emulate.h |   2 +
>   arch/arm64/include/asm/kvm_host.h    |   3 +
>   arch/arm64/include/asm/kvm_rme.h     |  18 ++++
>   arch/arm64/kvm/arm.c                 |   2 +
>   arch/arm64/kvm/reset.c               |  11 ++
>   arch/arm64/kvm/rme.c                 | 155 +++++++++++++++++++++++++++
>   6 files changed, 191 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> index 5edcfb1b6c68..7430c77574e3 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -712,6 +712,8 @@ static inline bool kvm_realm_is_created(struct kvm *kvm)
>   
>   static inline bool vcpu_is_rec(struct kvm_vcpu *vcpu)
>   {
> +	if (static_branch_unlikely(&kvm_rme_is_available))
> +		return vcpu->arch.rec.mpidr != INVALID_HWID;
>   	return false;
>   }
>   
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 7a77eed52c7d..122954187424 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -773,6 +773,9 @@ struct kvm_vcpu_arch {
>   
>   	/* Per-vcpu CCSIDR override or NULL */
>   	u32 *ccsidr;
> +
> +	/* Realm meta data */
> +	struct realm_rec rec;
>   };
>   
>   /*
> diff --git a/arch/arm64/include/asm/kvm_rme.h b/arch/arm64/include/asm/kvm_rme.h
> index e5704859a6e5..3a3aaf5d591c 100644
> --- a/arch/arm64/include/asm/kvm_rme.h
> +++ b/arch/arm64/include/asm/kvm_rme.h
> @@ -6,6 +6,7 @@
>   #ifndef __ASM_KVM_RME_H
>   #define __ASM_KVM_RME_H
>   
> +#include <asm/rmi_smc.h>
>   #include <uapi/linux/kvm.h>
>   
>   /**
> @@ -70,6 +71,21 @@ struct realm {
>   	unsigned int ia_bits;
>   };
>   
> +/**
> + * struct realm_rec - Additional per VCPU data for a Realm
> + *
> + * @mpidr: MPIDR (Multiprocessor Affinity Register) value to identify this VCPU
> + * @rec_page: Kernel VA of the RMM's private page for this REC
> + * @aux_pages: Additional pages private to the RMM for this REC
> + * @run: Kernel VA of the RmiRecRun structure shared with the RMM
> + */
> +struct realm_rec {
> +	unsigned long mpidr;
> +	void *rec_page;
> +	struct page *aux_pages[REC_PARAMS_AUX_GRANULES];
> +	struct rec_run *run;
> +};
> +
>   void kvm_init_rme(void);
>   u32 kvm_realm_ipa_limit(void);
>   
> @@ -77,6 +93,8 @@ int kvm_realm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap);
>   int kvm_init_realm_vm(struct kvm *kvm);
>   void kvm_destroy_realm(struct kvm *kvm);
>   void kvm_realm_destroy_rtts(struct kvm *kvm, u32 ia_bits);
> +int kvm_create_rec(struct kvm_vcpu *vcpu);
> +void kvm_destroy_rec(struct kvm_vcpu *vcpu);
>   
>   #define RME_RTT_BLOCK_LEVEL	2
>   #define RME_RTT_MAX_LEVEL	3
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index d16ba8d8bc44..87aa3f07fae2 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -526,6 +526,8 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>   	/* Force users to call KVM_ARM_VCPU_INIT */
>   	vcpu_clear_flag(vcpu, VCPU_INITIALIZED);
>   
> +	vcpu->arch.rec.mpidr = INVALID_HWID;
> +
>   	vcpu->arch.mmu_page_cache.gfp_zero = __GFP_ZERO;
>   
>   	/* Set up the timer */
> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> index 0b0ae5ae7bc2..845b1ece47d4 100644
> --- a/arch/arm64/kvm/reset.c
> +++ b/arch/arm64/kvm/reset.c
> @@ -137,6 +137,11 @@ int kvm_arm_vcpu_finalize(struct kvm_vcpu *vcpu, int feature)
>   			return -EPERM;
>   
>   		return kvm_vcpu_finalize_sve(vcpu);
> +	case KVM_ARM_VCPU_REC:
> +		if (!kvm_is_realm(vcpu->kvm))
> +			return -EINVAL;
> +
> +		return kvm_create_rec(vcpu);
>   	}
>   
>   	return -EINVAL;
> @@ -147,6 +152,11 @@ bool kvm_arm_vcpu_is_finalized(struct kvm_vcpu *vcpu)
>   	if (vcpu_has_sve(vcpu) && !kvm_arm_vcpu_sve_finalized(vcpu))
>   		return false;
>   
> +	if (kvm_is_realm(vcpu->kvm) &&
> +	    !(vcpu_is_rec(vcpu) &&
> +	      READ_ONCE(vcpu->kvm->arch.realm.state) == REALM_STATE_ACTIVE))
> +		return false;
> +
>   	return true;
>   }
>   
> @@ -159,6 +169,7 @@ void kvm_arm_vcpu_destroy(struct kvm_vcpu *vcpu)
>   		kvm_unshare_hyp(sve_state, sve_state + vcpu_sve_state_size(vcpu));
>   	kfree(sve_state);
>   	kfree(vcpu->arch.ccsidr);
> +	kvm_destroy_rec(vcpu);
>   }
>   
>   static void kvm_vcpu_reset_sve(struct kvm_vcpu *vcpu)
> diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
> index 7db405d2b2b2..6f0ced6e0cc1 100644
> --- a/arch/arm64/kvm/rme.c
> +++ b/arch/arm64/kvm/rme.c
> @@ -422,6 +422,161 @@ void kvm_destroy_realm(struct kvm *kvm)
>   	kvm_free_stage2_pgd(&kvm->arch.mmu);
>   }
>   
> +static void free_rec_aux(struct page **aux_pages,
> +			 unsigned int num_aux)
> +{
> +	unsigned int i;
> +
> +	for (i = 0; i < num_aux; i++) {
> +		phys_addr_t aux_page_phys = page_to_phys(aux_pages[i]);
> +
> +		/* If the undelegate fails then leak the page */
> +		if (WARN_ON(rmi_granule_undelegate(aux_page_phys)))
> +			continue;
> +
> +		__free_page(aux_pages[i]);
> +	}
> +}
> +
> +static int alloc_rec_aux(struct page **aux_pages,
> +			 u64 *aux_phys_pages,
> +			 unsigned int num_aux)
> +{
> +	int ret;
> +	unsigned int i;
> +
> +	for (i = 0; i < num_aux; i++) {
> +		struct page *aux_page;
> +		phys_addr_t aux_page_phys;
> +
> +		aux_page = alloc_page(GFP_KERNEL);
> +		if (!aux_page) {
> +			ret = -ENOMEM;
> +			goto out_err;
> +		}
> +		aux_page_phys = page_to_phys(aux_page);
> +		if (rmi_granule_delegate(aux_page_phys)) {
> +			__free_page(aux_page);
> +			ret = -ENXIO;
> +			goto out_err;
> +		}
> +		aux_pages[i] = aux_page;
> +		aux_phys_pages[i] = aux_page_phys;
> +	}
> +
> +	return 0;
> +out_err:
> +	free_rec_aux(aux_pages, i);
> +	return ret;
> +}
> +
> +int kvm_create_rec(struct kvm_vcpu *vcpu)
> +{
> +	struct user_pt_regs *vcpu_regs = vcpu_gp_regs(vcpu);
> +	unsigned long mpidr = kvm_vcpu_get_mpidr_aff(vcpu);
> +	struct realm *realm = &vcpu->kvm->arch.realm;
> +	struct realm_rec *rec = &vcpu->arch.rec;
> +	unsigned long rec_page_phys;
> +	struct rec_params *params;
> +	int r, i;
> +
> +	if (kvm_realm_state(vcpu->kvm) != REALM_STATE_NEW)
> +		return -ENOENT;
> +
> +	/*
> +	 * The RMM will report PSCI v1.0 to Realms and the KVM_ARM_VCPU_PSCI_0_2
> +	 * flag covers v0.2 and onwards.
> +	 */
> +	if (!vcpu_has_feature(vcpu, KVM_ARM_VCPU_PSCI_0_2))
> +		return -EINVAL;
> +
> +	BUILD_BUG_ON(sizeof(*params) > PAGE_SIZE);
> +	BUILD_BUG_ON(sizeof(*rec->run) > PAGE_SIZE);
> +
> +	params = (struct rec_params *)get_zeroed_page(GFP_KERNEL);
> +	rec->rec_page = (void *)__get_free_page(GFP_KERNEL);
> +	rec->run = (void *)get_zeroed_page(GFP_KERNEL);
> +	if (!params || !rec->rec_page || !rec->run) {
> +		r = -ENOMEM;
> +		goto out_free_pages;
> +	}
> +
> +	for (i = 0; i < ARRAY_SIZE(params->gprs); i++)
> +		params->gprs[i] = vcpu_regs->regs[i];
> +
> +	params->pc = vcpu_regs->pc;
> +
> +	if (vcpu->vcpu_id == 0)
> +		params->flags |= REC_PARAMS_FLAG_RUNNABLE;
> +
> +	rec_page_phys = virt_to_phys(rec->rec_page);
> +
> +	if (rmi_granule_delegate(rec_page_phys)) {
> +		r = -ENXIO;
> +		goto out_free_pages;
> +	}
> +
> +	r = alloc_rec_aux(rec->aux_pages, params->aux, realm->num_aux);
> +	if (r)
> +		goto out_undelegate_rmm_rec;
> +
> +	params->num_rec_aux = realm->num_aux;
> +	params->mpidr = mpidr;
> +
> +	if (rmi_rec_create(virt_to_phys(realm->rd),
> +			   rec_page_phys,
> +			   virt_to_phys(params))) {
> +		r = -ENXIO;
> +		goto out_free_rec_aux;
> +	}
> +
> +	rec->mpidr = mpidr;
> +
> +	free_page((unsigned long)params);
> +	return 0;
> +
> +out_free_rec_aux:
> +	free_rec_aux(rec->aux_pages, realm->num_aux);
> +out_undelegate_rmm_rec:
> +	if (WARN_ON(rmi_granule_undelegate(rec_page_phys)))
> +		rec->rec_page = NULL;
> +out_free_pages:
> +	free_page((unsigned long)rec->run);
> +	free_page((unsigned long)rec->rec_page);
> +	free_page((unsigned long)params);
> +	return r;
> +}
> +
> +void kvm_destroy_rec(struct kvm_vcpu *vcpu)
> +{
> +	struct realm *realm = &vcpu->kvm->arch.realm;
> +	struct realm_rec *rec = &vcpu->arch.rec;
> +	unsigned long rec_page_phys;
> +
> +	if (!vcpu_is_rec(vcpu))
> +		return;
> +
> +	free_page((unsigned long)rec->run);
> +
> +	rec_page_phys = virt_to_phys(rec->rec_page);
> +
> +	/*
> +	 * The REC and any AUX pages cannot be reclaimed until the REC is
> +	 * destroyed. So if the REC destroy fails then the REC page and any AUX
> +	 * pages will be leaked.
> +	 */
> +	if (WARN_ON(rmi_rec_destroy(rec_page_phys)))
> +		return;
> +
> +	free_rec_aux(rec->aux_pages, realm->num_aux);
> +
> +	/* If the undelegate fails then leak the REC page */
> +	if (WARN_ON(rmi_granule_undelegate(rec_page_phys)))
> +		return;
> +
> +	free_page((unsigned long)rec->rec_page);
> +}
> +
>   int kvm_init_realm_vm(struct kvm *kvm)
>   {
>   	struct realm_params *params;

