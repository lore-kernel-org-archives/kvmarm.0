Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011003.outbound.protection.outlook.com [40.107.130.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD8E32C08AD;
	Fri, 20 Mar 2026 10:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.3
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774003122; cv=fail; b=hvWfuXc2/v0CB5KDBDpvDhOdUnDlLoQmQplxHhmwMhGajiSwg7XxrwisPegjlfC/qOj3cw353itv9k5CQHfHM6de/091ubQZl1cXQbv71gNu8z6c7il50ZJ7VQFQTEYtPDGIUDq7WeE6nVvFrP3BJgGmwRMaFhyYJZmAchLiE7w=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774003122; c=relaxed/simple;
	bh=kpp24ZGHQ8hL8CXqJPDh6tJ6Gad2/ysSKkzp+2Rsp48=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ZjIWE2EUKCju1i52xVp2hoWykrIQazxDlpAU6j6mmVHhRg/vlqOy8iHE1S90GBjbhpmG6qEAIsXTpl1LMx2jKHYzS9Km2BZKISyTsq8nq+z24axiSOeL63XaGcF8JTQyznyWAV2N9uAoDQHA7rGxkv4GVWLHIPId6lV0KLAeeTI=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=JqQsjaxw; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=JqQsjaxw; arc=fail smtp.client-ip=40.107.130.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="JqQsjaxw";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="JqQsjaxw"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=G3jSveoQBSEktiKj1r579lsAvDw7v6/x9OjZ7Lj2VI0d7cJ8wpMjESSSReIF88R0gtBX8nOhpQztzTKWgEykP1EpSFW0/lytODBh2VKqW0bWNXz58dhqlxWv60Z3p8WOmYFEIMNTxXCQhkIrO+xkRkQbWZlBZooMKlFeHmSelmphMPHNYpjGyx1GW/AQf4+ViRc6204JqGYBy2kmXzlIA/1vnZOS0My9SiVCAVhFJrq34Odp/VaYbv0PI3mGqHHEmtXIPD000ip2hDuJz/n5Q1YuZvcB/dnvLF9S0jUu7FS+XXHGABYoBDSbd19CXEIcLtktIdhNy9z3mnJiKiEJzA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=42S9Zc8zQdE2oZlKF6aOyPN6ur8T2ksopV/AJdiTx0A=;
 b=ovHLM/PZS0RPwtCeUr11lyWlqyNQmMzg3A6LDplWhuP2G3UVBARlNIZS3ztQsdnisxe9FWCp9tiM2W1DUMQSa2HVpMjhVpfcmt8bXNwaxW+jpuVpOzv9CnKrzYbKIcBwVc1qIPu90hulyspBEPBqVYV/xgyvcWmD+7TVu9YdAmhnHTtR6Kuw/j1Y3+B4eoWm7hdMBsrhuaNnKPFEYq96apnGE0IJDthliypwtug2VMka9gNUfHvCf38xb8xjvuZCPhY144Ysd6h/osTQOwFW8GIaMxwR+32Stib5MFfMikjuBXIOMnPmlJ6dhNC8gxS3AGBHBGBjucHoBdA3QjA2wg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=42S9Zc8zQdE2oZlKF6aOyPN6ur8T2ksopV/AJdiTx0A=;
 b=JqQsjaxwxquKer+Boeu5RXIgdhcpmPBrbiyt5GoEYiEhBc9A5mO984y77IclKo3c6131NMgQe5pWS9pdRWOWldmj41b27JqWEZKD45YVd+BaRYNTp94hRM0O6CeOD1lXsVQYJt9ZDIlALNp5hP6hmA/vE/uIDmoxoX3S97laQPE=
Received: from DU2PR04CA0356.eurprd04.prod.outlook.com (2603:10a6:10:2b4::14)
 by AM0PR08MB11703.eurprd08.prod.outlook.com (2603:10a6:20b:743::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.23; Fri, 20 Mar
 2026 10:38:33 +0000
Received: from DU6PEPF0000B61E.eurprd02.prod.outlook.com
 (2603:10a6:10:2b4:cafe::f8) by DU2PR04CA0356.outlook.office365.com
 (2603:10a6:10:2b4::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.19 via Frontend Transport; Fri,
 20 Mar 2026 10:38:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU6PEPF0000B61E.mail.protection.outlook.com (10.167.8.133) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.19
 via Frontend Transport; Fri, 20 Mar 2026 10:38:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=n+xSQX4sTCm/QPrO7Iu5ExX4oJGqQ0p88wxyRKuc63cU658obb8wskG1YDqqxmYJ9JhbGLEaxvruBZPmD27ixfgZHJVM1tc95cKxKexc7L1lNJeOernrEV0T69eI5Gb8tTh5VoQ0XHv7V9zmqJmzmj00xryD82xq9F9ZLnhatqhFiR8w9zXhBTLmYn5EDelv5Uaq+F8Wqv0lU/HxASIbFFwjLrwb92mWiVy64eyC70D4JwDEdC4QK/yE93sBn8U2ygLeTLqpA3mG2vs1+f1MZF2q4oZ9VOb0aH+dFqz7PKe+4KYaBGJgLk/HS6IZzPGo0Qr2RVKk2FFf03MTHkX/aA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=42S9Zc8zQdE2oZlKF6aOyPN6ur8T2ksopV/AJdiTx0A=;
 b=Sy/qVzopJn7yR51NKoS2/daG9NhjUCnfK+SCoEhFF8WWeUzBxyZgSaN8eiRehFZwxlIajmzRMtqZP+nXNkIFpgqqSS/tZBRCjEW1B9oaqyurqlRndO2YZw7aeF6KoKe1Yj373HEQfBQzhjJAGkLALdw4p8boDAJ9OmOpWEtwyVdk4O50ZaVkTmjictyVxuvOHSQLJSXTndrg/OecPwuRLCJdOWnFnQDGBSv8YLODI2ZqadQrHh7nODgFqMFSvnDls7hftXfSM5KgmPAoh9u4dvSUu3I55VQGyKztky9tIWDY95wzelMp3BT2pOpq44VsV/0xd1MSoBOXx5TkpQUk/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=42S9Zc8zQdE2oZlKF6aOyPN6ur8T2ksopV/AJdiTx0A=;
 b=JqQsjaxwxquKer+Boeu5RXIgdhcpmPBrbiyt5GoEYiEhBc9A5mO984y77IclKo3c6131NMgQe5pWS9pdRWOWldmj41b27JqWEZKD45YVd+BaRYNTp94hRM0O6CeOD1lXsVQYJt9ZDIlALNp5hP6hmA/vE/uIDmoxoX3S97laQPE=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from DU4PR08MB11769.eurprd08.prod.outlook.com (2603:10a6:10:644::21)
 by GVXPR08MB7872.eurprd08.prod.outlook.com (2603:10a6:150:16::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.23; Fri, 20 Mar
 2026 10:37:24 +0000
Received: from DU4PR08MB11769.eurprd08.prod.outlook.com
 ([fe80::d424:cd62:81a8:490f]) by DU4PR08MB11769.eurprd08.prod.outlook.com
 ([fe80::d424:cd62:81a8:490f%5]) with mapi id 15.20.9723.018; Fri, 20 Mar 2026
 10:37:24 +0000
Message-ID: <db905c7e-0a47-4f12-b1ff-dce55e0584ed@arm.com>
Date: Fri, 20 Mar 2026 10:37:23 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 15/48] arm64: RMI: RTT tear down
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
 <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>,
 Vishal Annapurve <vannapurve@google.com>
References: <20260318155413.793430-1-steven.price@arm.com>
 <20260318155413.793430-16-steven.price@arm.com>
Content-Language: en-US
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20260318155413.793430-16-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0340.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:d::16) To DU4PR08MB11769.eurprd08.prod.outlook.com
 (2603:10a6:10:644::21)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	DU4PR08MB11769:EE_|GVXPR08MB7872:EE_|DU6PEPF0000B61E:EE_|AM0PR08MB11703:EE_
X-MS-Office365-Filtering-Correlation-Id: 2c3740f5-e617-4806-2d84-08de866cd5e1
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|7416014|366016|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info-Original:
 eV/9NjeuKswdoP7V1QDRyMyP8CtVQxSAnayUokPPX6PIiWjaa4szUb+aduzsR9Bt0Y/F4aGFeLg9T0BxxspsxyLBigmP73oWgTuOjxG+xB96dEFFcuW8t79RZZUtpuD7/dnu7WmkfLpOnOU3EkTJP3HxRaHRATc3XbvOSI+WLeUoHqD6qvl6x4EUlsnIMtAHt7DE9LZ95B9FNDja16wTDhOAhKhfx7H6ZlySuv+zZ9ydsZaNmNCEP6OAX1zOfmIj3Kj7UBRhJE8Emd4HWr/A2/rQizGJ2Q7tzYMWJYi3w/J6jiK1ah+yJT2tyDQMLYSDpVZ9vmopY/MDwEjlorNbGcZhcp+oveXUD3nNc+2Mh9bZrygu8eZlmwiqVlr0saKNKzmPjHXMcPPbRpCo+m0eSjZH50TOm5I/CkfriMn9EIfm7RM3qoOlDQ4j4t81Qy/kB72mirO+Z9qqES82euxIq6FpybIcp6pnCotUSKBxrMz+li+XmrdKN2nDUtnsJ3oi3ZKlDgDHMHUfJW1/7tzZHeLBl7apjl6VkgA12YiXqhW0xg/IFDZ4UFPQ8bZcRR+yyrmoSqiJK0nC7pNlnkmDLMXjWqDyzWD4jRJElCHkE+QA+atnySmQJMjIZqRpjfZIuHSdjjgpn8p7kGp2a+/xaTbMKnj8nOTFlLJlIWnsXFDKssiAR4ZgccPIx12GymGrApGjl06v6YWvIjY0jqYOahe4b3RyDC6wEbO2T3wvEdk=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU4PR08MB11769.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 UHrSt43Y0rn4Sm4eQondqNIvhwy4Pr7yTM3NhJfCtEbh5AHX6u2NFcQN7ablnr4nlom5bnoBuc8/CibTDdtqixplcKWRoM7ni5gEP16Gi803ZBf9FyQV0RsUPfbDDYVweDmk3uzW3F03pn6+otH0VZTNViEQ6OJ6B6VvBeBxZPKuLjkTwIEiYCdVITjczKkLz+BCzsC+aUApATcXQhkFleOmdu7mYPKhWSGerulwb6Esc5uKPp4FdV5VFFt/Ljaqm5ghrUfWNlEc4GyTihc0/L1ACOqiFqMHXSkqrAHsioFUkfbSSUlNEZOpnyw73kU1SdJvDIHQ47p4rTjnmrf+0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVXPR08MB7872
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU6PEPF0000B61E.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	f561228d-92f2-4fa7-7429-08de866cacc2
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|36860700016|7416014|82310400026|14060799003|35042699022|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	bD1pbR1/XLfV29Tdt+93qcC7oFWFTx99UX5yWnrk9ELAmKSCqesXSv9WFGmjpYaB+d2hZXGKnfRhFzZYv7oc3ndD/2Gfyela6XK6/uIl+nl2Vecf5H9aOjPTzUrQQ7azOYunL9+BNd0ygROv64ScWMPhAVclsg/QwS04IqRgmT1WiLwMdDeyFGYHq0DdvP5vtilhtBp/WnmatynhYGKb8yvtf1hk44lH6P0v9Ud+6vi8YkyH3lnVwzHyUimSg8uJmdLfAxtduN5odV8b3gUWZ743svwmGNUCdcDCXewhLw3hTCDcRd8PQNQ0G2t9xW/ZMkymbKO9jG8SVG8q+iM22M9jHIKZKD/nMuDagUI7IBYGbyyGauAPuuQCeIGKipgbVf/fYiRpa5bhljnd+qVdOEUKdvfSSyel2HC/pOGLPW9OR/luXAlc7JN6hjah2sp8fHSL3r8pl5+eEMvUWwHeHXBtrWI51q5i1opO1rA26L/fM1Hu0MUbpAIFqEtjv+XEjgEckmbgBJWS4pJfT49QQNycoSQ5Rc8hPitZ3SJ9zuDQyDjbx6J+qwkVuLh4/4eEPQKXsdUeqT3/RzyRgfSdJWywbOlkNAi8dG6Swm/tHrGvS7EIb901spS1zXj/jB2y2O2xef+KFsMcRSwk0Sqw44a4taV3gFF8BV6EeY03rxVnZLa8DDM6p99eOVZ1Px42Os0Ji71CcVVXBRrlDMxum4+WY5COnZG4kGZkr2/xmIJ9UwupbCy0BU6W+nNK7ArpHbc0/+Zt7p8Kh0iGyt++uA==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(36860700016)(7416014)(82310400026)(14060799003)(35042699022)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	0cxKtVQj+OuvuLUTVI/5L3A5Ssbu0ts6qcIyYOOwoS+0t5+Jo9NCf2HJ+5OfNFLVURn+rwLh0d3QyqhGzfPDUMs7cHIcBTjJjhnrRj8zaTiE+NsyReUrjvj7mDwCd1VeN/40VVB+vjTZ1vDwM7izB3yk2WBBSZNDcLHtMFOGFsH00WkLR5VGTZWl30d/HCsuKauLEft/A8gYhbpOnvX0MuundZsOfQqdN78xw+EzG4uuRNs9UorjvOwLTSIINXKKX9iCA/9PVhQtGfrjaevCDZ1u6AbPPicTUNOfVLaTblezkSrSRvoQ7SPsUoECxxUkK5mREpqeP29JJkVw9soFLYfUzAoq1x1lWn07/5yFH/eXVPoPT0NS88Yn35Akg//x/V7Ci1zgkBuGfFreaZ/VLMkqM+IG7A8vbA6NHEvZ8TEN9TMvTEW2n9JFNk21k53W
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2026 10:38:33.4913
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c3740f5-e617-4806-2d84-08de866cd5e1
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU6PEPF0000B61E.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR08MB11703

On 18/03/2026 15:53, Steven Price wrote:
> The RMM owns the stage 2 page tables for a realm, and KVM must request
> that the RMM creates/destroys entries as necessary. The physical pages
> to store the page tables are delegated to the realm as required, and can
> be undelegated when no longer used.
> 
> Creating new RTTs is the easy part, tearing down is a little more
> tricky. The result of realm_rtt_destroy() can be used to effectively
> walk the tree and destroy the entries (undelegating pages that were
> given to the realm).
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes since v12:
>   * Simplify some functions now we know RMM page size is the same as the
>     host's.
> Changes since v11:
>   * Moved some code from earlier in the series to this one so that it's
>     added when it's first used.
> Changes since v10:
>   * RME->RMI rename.
>   * Some code to handle freeing stage 2 PGD moved into this patch where
>     it belongs.
> Changes since v9:
>   * Add a comment clarifying that root level RTTs are not destroyed until
>     after the RD is destroyed.
> Changes since v8:
>   * Introduce free_rtt() wrapper which calls free_delegated_granule()
>     followed by kvm_account_pgtable_pages(). This makes it clear where an
>     RTT is being freed rather than just a delegated granule.
> Changes since v6:
>   * Move rme_rtt_level_mapsize() and supporting defines from kvm_rme.h
>     into rme.c as they are only used in that file.
> Changes since v5:
>   * Rename some RME_xxx defines to do with page sizes as RMM_xxx - they are
>     a property of the RMM specification not the RME architecture.
> Changes since v2:
>   * Moved {alloc,free}_delegated_page() and ensure_spare_page() to a
>     later patch when they are actually used.
>   * Some simplifications now rmi_xxx() functions allow NULL as an output
>     parameter.
>   * Improved comments and code layout.
> ---
>   arch/arm64/include/asm/kvm_rmi.h |   7 ++
>   arch/arm64/kvm/mmu.c             |  15 +++-
>   arch/arm64/kvm/rmi.c             | 145 +++++++++++++++++++++++++++++++
>   3 files changed, 166 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_rmi.h b/arch/arm64/include/asm/kvm_rmi.h
> index 0ada525af18f..16a297f3091a 100644
> --- a/arch/arm64/include/asm/kvm_rmi.h
> +++ b/arch/arm64/include/asm/kvm_rmi.h
> @@ -68,5 +68,12 @@ u32 kvm_realm_ipa_limit(void);
>   
>   int kvm_init_realm_vm(struct kvm *kvm);
>   void kvm_destroy_realm(struct kvm *kvm);
> +void kvm_realm_destroy_rtts(struct kvm *kvm);
> +
> +static inline bool kvm_realm_is_private_address(struct realm *realm,
> +						unsigned long addr)
> +{
> +	return !(addr & BIT(realm->ia_bits - 1));
> +}
>   
>   #endif /* __ASM_KVM_RMI_H */
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 9dc242c3b9c8..41152abf55b2 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1098,10 +1098,23 @@ void stage2_unmap_vm(struct kvm *kvm)
>   void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
>   {
>   	struct kvm *kvm = kvm_s2_mmu_to_kvm(mmu);
> -	struct kvm_pgtable *pgt = NULL;
> +	struct kvm_pgtable *pgt;
>   
>   	write_lock(&kvm->mmu_lock);
>   	pgt = mmu->pgt;
> +	if (kvm_is_realm(kvm) &&
> +	    (kvm_realm_state(kvm) != REALM_STATE_DEAD &&
> +	     kvm_realm_state(kvm) != REALM_STATE_NONE)) {
> +		write_unlock(&kvm->mmu_lock);
> +		kvm_realm_destroy_rtts(kvm);
> +
> +		/*
> +		 * The PGD pages can be reclaimed only after the realm (RD) is
> +		 * destroyed. We call this again from kvm_destroy_realm() after
> +		 * the RD is destroyed.
> +		 */
> +		return;
> +	}
>   	if (pgt) {
>   		mmu->pgd_phys = 0;
>   		mmu->pgt = NULL;
> diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
> index 700b8c935d29..1fd2c18f7381 100644
> --- a/arch/arm64/kvm/rmi.c
> +++ b/arch/arm64/kvm/rmi.c
> @@ -15,6 +15,19 @@
>   static unsigned long rmm_feat_reg0;
>   static unsigned long rmm_feat_reg1;
>  

-->

> +#define RMM_RTT_BLOCK_LEVEL	2
...
> +
> +#define RMM_L2_BLOCK_SIZE	PMD_SIZE

<--

Unused ? Even better we could use PMD_SIZE directly if at all we need
it, as we are using PAGE_SIZE


minor nit: Also, may be we can have a generic name for the 
RMM_RTT_MAX_LEVEL ? This applies to all page tables ?

I see we have KVM_PGTALBE_LAST_LEVEL, may be we could use that ?


> +
> +static inline unsigned long rmi_rtt_level_mapsize(int level)
> +{
> +	if (WARN_ON(level > RMM_RTT_MAX_LEVEL))
> +		return PAGE_SIZE;
> +
> +	return (1UL << ARM64_HW_PGTABLE_LEVEL_SHIFT(level));
> +}
> +
>   static bool rmi_has_feature(unsigned long feature)
>   {
>   	return !!u64_get_bits(rmm_feat_reg0, feature);
> @@ -189,6 +202,11 @@ u32 kvm_realm_ipa_limit(void)
>   	return u64_get_bits(rmm_feat_reg0, RMI_FEATURE_REGISTER_0_S2SZ);
>   }
>   
> +static int get_start_level(struct realm *realm)
> +{
> +	return 4 - stage2_pgtable_levels(realm->ia_bits);
> +}
> +
>   static int undelegate_range(phys_addr_t phys, unsigned long size)
>   {
>   	unsigned long ret;
> @@ -223,6 +241,131 @@ static int free_delegated_page(phys_addr_t phys)
>   	return 0;
>   }
>   
> +static void free_rtt(phys_addr_t phys)
> +{
> +	if (free_delegated_page(phys))
> +		return;
> +
> +	kvm_account_pgtable_pages(phys_to_virt(phys), -1);
> +}


How about a comment here for the function below ?

Something like :

/*
  * realm_rtt_destroy: Destroy an RTT at @level for @addr.
  *
  * Returns - Result of the RMI_RTT_DESTROY call, additionally :
  *  @out_rtt  : RTT granule, if the RTT was destroyed.
  *  @next_addr: IPA corresponding to the next possible valid Table entry
  *		we can target.
  */
> +
> +static int realm_rtt_destroy(struct realm *realm, unsigned long addr,
> +			     int level, phys_addr_t *rtt_granule,
> +			     unsigned long *next_addr)
> +{
> +	unsigned long out_rtt;
> +	int ret;
> +
> +	ret = rmi_rtt_destroy(virt_to_phys(realm->rd), addr, level,
> +			      &out_rtt, next_addr);
> +
> +	*rtt_granule = out_rtt;
> +
> +	return ret;
> +}
> +
> +static int realm_tear_down_rtt_level(struct realm *realm, int level,
> +				     unsigned long start, unsigned long end)
> +{
> +	ssize_t map_size;
> +	unsigned long addr, next_addr;
> +
> +	if (WARN_ON(level > RMM_RTT_MAX_LEVEL))
> +		return -EINVAL;
> +
> +	map_size = rmi_rtt_level_mapsize(level - 1);
> +
> +	for (addr = start; addr < end; addr = next_addr) {
> +		phys_addr_t rtt_granule;
> +		int ret;
> +		unsigned long align_addr = ALIGN(addr, map_size);
> +
> +		next_addr = ALIGN(addr + 1, map_size);
> +
> +		if (next_addr > end || align_addr != addr) {
> +			/*
> +			 * The target range is smaller than what this level
> +			 * covers, recurse deeper.
> +			 */
> +			ret = realm_tear_down_rtt_level(realm,
> +							level + 1,
> +							addr,
> +							min(next_addr, end));
> +			if (ret)
> +				return ret;
> +			continue;
> +		}
> +
> +		ret = realm_rtt_destroy(realm, addr, level,
> +					&rtt_granule, &next_addr);
> +
> +		switch (RMI_RETURN_STATUS(ret)) {
> +		case RMI_SUCCESS:
> +			free_rtt(rtt_granule);
> +			break;
> +		case RMI_ERROR_RTT:
> +			if (next_addr > addr) {
> +				/* Missing RTT, skip */
> +				break;
> +			}
> +			/*
> +			 * We tear down the RTT range for the full IPA
> +			 * space, after everything is unmapped. Also we
> +			 * descend down only if we cannot tear down a
> +			 * top level RTT. Thus RMM must be able to walk
> +			 * to the requested level. e.g., a block mapping
> +			 * exists at L1 or L2.
> +			 */
> +			if (WARN_ON(RMI_RETURN_INDEX(ret) != level))
> +				return -EBUSY;
> +			if (WARN_ON(level == RMM_RTT_MAX_LEVEL))
> +				return -EBUSY;
> +
> +			/*
> +			 * The table has active entries in it, recurse deeper
> +			 * and tear down the RTTs.
> +			 */
> +			next_addr = ALIGN(addr + 1, map_size);
> +			ret = realm_tear_down_rtt_level(realm,
> +							level + 1,
> +							addr,
> +							next_addr);
> +			if (ret)
> +				return ret;
> +			/*
> +			 * Now that the child RTTs are destroyed,
> +			 * retry at this level.
> +			 */
> +			next_addr = addr;
> +			break;
> +		default:
> +			WARN_ON(1);
> +			return -ENXIO;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +static int realm_tear_down_rtt_range(struct realm *realm,
> +				     unsigned long start, unsigned long end)
> +{
> +	/*
> +	 * Root level RTTs can only be destroyed after the RD is destroyed. So
> +	 * tear down everything below the root level
> +	 */
> +	return realm_tear_down_rtt_level(realm, get_start_level(realm) + 1,
> +					 start, end);
> +}
> +
> +void kvm_realm_destroy_rtts(struct kvm *kvm)
> +{
> +	struct realm *realm = &kvm->arch.realm;
> +	unsigned int ia_bits = realm->ia_bits;
> +
> +	WARN_ON(realm_tear_down_rtt_range(realm, 0, (1UL << ia_bits)));

AFAICS, we already WARN_ON() in all the cases where the
realm_tear_down_rtt_range() fails, so may be we can skip this
WARN_ON here ?

Suzuki

> +}
> +
>   void kvm_destroy_realm(struct kvm *kvm)
>   {
>   	struct realm *realm = &kvm->arch.realm;
> @@ -246,6 +389,8 @@ void kvm_destroy_realm(struct kvm *kvm)
>   	if (realm->rd) {
>   		phys_addr_t rd_phys = virt_to_phys(realm->rd);
>   
> +		kvm_realm_destroy_rtts(kvm);
> +
>   		if (WARN_ON(rmi_realm_destroy(rd_phys)))
>   			return;
>   		free_delegated_page(rd_phys);

