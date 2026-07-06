Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010057.outbound.protection.outlook.com [52.101.69.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6514834B1A3
	for <kvmarm@lists.linux.dev>; Mon,  6 Jul 2026 11:19:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.57
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783336768; cv=fail; b=COw55G9irTRUu5ZzsFLt453Y+3iDIwcoUOXIwLlMQDuS3yO0sXefv4IT2ufmJ66pubsjmoRo1v5KHQXuyzvrau5/ZD9cwfn9J+oAmylz7QwVxKU+KZO8mSwREYRdOT8kUSXrx+oyyU2lXbWPRG+qEE68A33McLZsmC9jCznRPLY=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783336768; c=relaxed/simple;
	bh=TTH7DJS9ImNY8TRXietj9IGC7B48wZeqnvdlz2QUKD4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=HuyQ0xqHVCPqS+bK+/2AlrsVz3VNtQxNolRbK3TyaG7kTPgm1GEGI8omDDSSAs3V4a5HMR+JBhlnyfAbTNkE7ORTwbl584IuAu0cznLu1afegFA9X9BwMPhRTfJ06mjLzCg7f1CMxvAqZDRiBF4nl2dLKqPtZmGLFUxJfrKf1QI=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=KDPx5vNc; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=KDPx5vNc; arc=fail smtp.client-ip=52.101.69.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="KDPx5vNc";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="KDPx5vNc"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=A+mDUzQrWUUyGVgGNfn0fXsdEVsXviwJHCWZPvA/ZUm3ZCN6CiL0zpVh2cQcISX6BR8p5QE7jYBS8SYJE3tTZoiLL+7oXjF0Zx0y66zah6DIcQiRXqpt1OU1ERPKN5hrmVwoYDuhgyjdQHQkYutacORugKzbCc3Y7Tjwhsr8ReJKAIOyHpZClNxPMpPBVG8vQMg4k/YEJtM4J2rFcDpUJNhsLahUdx3Ky+ixnZ6VImOd5S+O/S3gYeZ5s9tBW4TdDBWrRXJ1Sqrb9ZVzIftNlRGioLVaeKN9so1BdBiRbh7cMj7oHoRbw2gtMvLjtcDEO5SQPAjhsxj0D6Wxpvevkw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xAX7L6jJl+zHjzDfPn3Bn2+sRcn4Z23hqrSf6RlgOkw=;
 b=Y1b2SlzP3N9uwgRyYp/fHZYQL3AfluZhYJJ++pOOd7j4aaGHrkVDkdt7WumE6RpEsjZf4DyWHzDgTSLaDy2YJjMekS3PsxK5IvMI5s98lDU++mUhnxLYZO7Kdyhkn/+uEB21nGwBlQZXvmzxFZ3iy5dbCC3Y+fZfKTUEP7uH2PvbD0XFMBfD8bPTWYJrCMfWqTdkN2SMh20pUPzSZAilpTYbp+aicZFePo4Kk5uTHvGd27XPWwCNVqUcMMa9eJv32i8MDwrbhqid4hCk//qhYVVt7RX+R31gzlomwMusVdHL3ai3rZrX1UItIH/DadFAX/K/cMYYRaJvbK1LEtmD2A==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=linux.dev smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xAX7L6jJl+zHjzDfPn3Bn2+sRcn4Z23hqrSf6RlgOkw=;
 b=KDPx5vNcTjPraa1q2ASLQYqEkd/gd42DPa4OAEYhPHgGOQ6ZnC+vKUi9+woEA7I7qMr/3jNkVK7/5yNncLV/kUGiINFie+mEKkozZ2nkbYquuqtAg0TE9X2sWwhNm3VHu9dQWaUTIgHbGo8tPWhUCh49BxHiPC0ZSwGxJtSSlrw=
Received: from AS4P191CA0024.EURP191.PROD.OUTLOOK.COM (2603:10a6:20b:5d9::18)
 by PAXPR08MB6671.eurprd08.prod.outlook.com (2603:10a6:102:13b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.13; Mon, 6 Jul
 2026 11:19:21 +0000
Received: from AMS0EPF000001A5.eurprd05.prod.outlook.com
 (2603:10a6:20b:5d9:cafe::95) by AS4P191CA0024.outlook.office365.com
 (2603:10a6:20b:5d9::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.13 via Frontend Transport; Mon, 6
 Jul 2026 11:19:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF000001A5.mail.protection.outlook.com (10.167.16.232) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.6
 via Frontend Transport; Mon, 6 Jul 2026 11:19:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=k5Wx/LJ4dQSa/2QJfAcaVAQU0bOe48Wn7Mrr0fKI4Z9vXu4iuDbpTDeNaQyBF170nc2H46BmJgk95yJ28059VfcWImxwC3q6R9ZJaXmJ+SnZFdgsO3420yphHwKcXyO9tbcrAVHl8BcrtWi+Ydu3l61Quw8zfEmkZRlPaW97FlgQdQARO6X31RlII7PaP76ieRG4gboS3H7DF5+cy02x5FQ6oY8iXbh/epfGMPB2WCRyeFuFT6QFJ1Hg55NZonTmi01spqrTCYFF8bIfaLgMY1ddu09O9SQjqmeu2FpQz9nRfcEDRE7FLOqsyIpZrrm7uCl37NSGw4m2LZT7Qfy+Vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xAX7L6jJl+zHjzDfPn3Bn2+sRcn4Z23hqrSf6RlgOkw=;
 b=yQfS8KirNdY+bI74l+vE6qePhp7oJkAS8FnwEYnZ6wXFafxh6ya0/hNNEJBvOJTwTImn8f4xVr+tV8QraONMvHxkOQkDzAH7ffVRY12+UbmAgukjg2qkSQgVHZGUGR3pl2wpLo9xTPvflYe3IFC5qgtE6CzzuSS18f/M36uEi4Af+WIdAogTgnGw6UOcIuJVSt9PbOlGwKqdI3p24iz3dUHqBWa4pHfPtVOTtj0uUcYOsdMae114l+FFLZ3zmmBWFv2CsbT1SNq9taPZlU8//LY62xp9jUZHuylY4+bUdhvaUA89TT+gCz+idnP74cS+uunusx6hzK3N2FMFRNKVQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xAX7L6jJl+zHjzDfPn3Bn2+sRcn4Z23hqrSf6RlgOkw=;
 b=KDPx5vNcTjPraa1q2ASLQYqEkd/gd42DPa4OAEYhPHgGOQ6ZnC+vKUi9+woEA7I7qMr/3jNkVK7/5yNncLV/kUGiINFie+mEKkozZ2nkbYquuqtAg0TE9X2sWwhNm3VHu9dQWaUTIgHbGo8tPWhUCh49BxHiPC0ZSwGxJtSSlrw=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from PAWPR08MB10975.eurprd08.prod.outlook.com (2603:10a6:102:46e::7)
 by VI0PR08MB11773.eurprd08.prod.outlook.com (2603:10a6:800:313::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.8; Mon, 6 Jul 2026
 11:18:14 +0000
Received: from PAWPR08MB10975.eurprd08.prod.outlook.com
 ([fe80::3c7a:9a64:14bc:ce15]) by PAWPR08MB10975.eurprd08.prod.outlook.com
 ([fe80::3c7a:9a64:14bc:ce15%7]) with mapi id 15.21.0181.009; Mon, 6 Jul 2026
 11:18:14 +0000
Message-ID: <90145d58-7ab3-4e88-98cc-21f574cbd673@arm.com>
Date: Mon, 6 Jul 2026 12:18:13 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH kvmtool v1 5/5] arm64: Add --guest-memfd option to back
 guest RAM with guest_memfd
To: Fuad Tabba <fuad.tabba@linux.dev>, kvm@vger.kernel.org
Cc: kvmarm@lists.linux.dev, Will Deacon <will@kernel.org>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Andre Przywara <andre.przywara@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>,
 Fuad Tabba <tabba@google.com>
References: <20260706083555.302972-1-fuad.tabba@linux.dev>
 <20260706083555.302972-6-fuad.tabba@linux.dev>
Content-Language: en-US
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20260706083555.302972-6-fuad.tabba@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: LO4P123CA0547.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:319::16) To PAWPR08MB10975.eurprd08.prod.outlook.com
 (2603:10a6:102:46e::7)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	PAWPR08MB10975:EE_|VI0PR08MB11773:EE_|AMS0EPF000001A5:EE_|PAXPR08MB6671:EE_
X-MS-Office365-Filtering-Correlation-Id: e89b03d0-3ccc-4918-680f-08dedb506c6a
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|23010399003|376014|1800799024|366016|18002099003|56012099006|4143699003|11063799006|6133799003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 d13rQTzaVfjrN1jRO93sGBKD/Udc78+LMUtNb3wzV2Ide7vWzyIBTueVw203OAUMe2q7Zn2ry80yYtmJyhCMjJmiq3Nwogkt02bkLheqaB5cjjY4njJKs/nrwAMWW2eYoeM3joOj8+oez8YxMwTl9TzDMP7y2G/nYAo4JOCV0aCalGXowxCdx+HouZIMeHmz57WUX0uQywLgykEg/R7u74x963vaVnIrc91mdDGR37RYIsW1rgXiDRPoDvMjpS6ojfS6OZOi/0VL03LiQbZpb8Cl/Ggkw7V9e1i0kS/IpLAWH2mY9RW5bLP0T4K6orsl7Nay51/G1slTQ0I2JdF0zAiXSKOHnnf0x++itKOq4jXK0rJz3lw7YuA+nUg/acKihIZMJJl5ALJMwZrIfxhUIVOeSgHxoPPU9aIuE7983GtSlcCqKYWEgR3ulsbiKF0n/OgEdFLmBaIsfT62QIswfaceDs3F5WZNuuYdy14g4d4OQSKxbnkJwbMOXcdOEqS1HszTLJU24L12nllmbA/HEYTAAu0N6Q/+Cj+ie9xN51QYtXKkq1eFqIxMq+r6iAVz+mDNQ0pKqTDgAaX/IkpnqI+MuTwuEWIQNeJ0+s1nlmxthHBPd3EYmCKXXLYsXfbCWmYf5pOzDkSaCN6cuNi2FzZBJOrPaZciC5hytZbY+Us=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAWPR08MB10975.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(366016)(18002099003)(56012099006)(4143699003)(11063799006)(6133799003)(22082099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 F0HGkMC/XS+8k93gQqPE+0yFlK8aeCG641ytlK/2SsSji6lv1fJpZwjA12WOt0WTMPKvac3RuL6AaAUq3lIXz5TU9/G9ipPTMc6IuwNf6KPTwGN4pIBTEmVFwRWWNCGbsLBUvCi6Y+AINdeE0dSh3sYbN+kn0KRKc8lHOo1C3Fh6IxpOpvDttwV+fvc9PdxUC62hJPJqBAcvpvepTbpW/YBlzWuH9LaTuVZ6zytkv9IO6Byqjd5Rrjhzq0TxW3/+mpUkLlcAzN3KVrxE2FQKOm1+/7opHzUao1BECUAaB4mJDqD1lk1eGQWuMG8JaO9C2sR/WmKIzHuetnSSRaIVzw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI0PR08MB11773
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF000001A5.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	ca654a96-caf4-4ae9-8b4f-08dedb504595
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|35042699022|376014|1800799024|36860700016|23010399003|82310400026|11063799006|4143699003|56012099006|18002099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	43Howlu9P+rXtIgC5To8EEpqtZq5h82C0k/Ke3RNgiduwz9Xm+vAvaipvXOXZNF0wvEUWfUXh6tMT6L1VSzxE9oDMuqb3ll8iM5MEHxWz02jBL+2mWxyvEOwfvfHFVAYeSvjfmwb1JyGTyymaQ3wm8B6/dBTmK41/zKt1gRrbFhff1/LtUrdcMnhCXT3HkGellk5ft2z3eoG+z2wfYq8gEMqdulrc2hSwFa5RMyVXy6CRGxW2omGkRbCJ07VV+NtaAn06VfmSW5RCkDCgV88WyqXyyEhNs5paKfKvpBN1V5mbHGwBkBMW3r1N/AB9ugeD3Ol9aWq2i+UNE6JLrZR5CH40NdyQ8g21GweHdGAD/Hj0b86OdJozKdeuAGaHr9b9g2t3w5wZEjsMJXdW9TvGN9nAKrxKfO/QdBZ9i/n9l7ZRD0FammzY9H50eUWhxcUBfZiiIzNtGnYAH6KFb5dzFX14m6z2ln/LapeKEcU80uGyEdnK7/j2zz6y3O12Ok0PvFvgrF4i/8nT9dY0vOwufehCHvHGKX61+qYky+46uLne8pKwQ4V30J9TwkHo6aPG3TxjJXypj0kBwUoALb3Waqx4pPyhAyRtD6wO4Vop+mHHwlE3iehJc9G+xcHhbpYBJtPWLe5Ttu/BOZWewiS2N1wEM5q0RfkaHRVPlIGiS1ykqec8WpIIA65pPfSnfbKM8v6lz/Ya/QtxhX+3gCWsQ==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(35042699022)(376014)(1800799024)(36860700016)(23010399003)(82310400026)(11063799006)(4143699003)(56012099006)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	PZY7WCSeaMKS2h+nPVE8MGM1tXpRxAZTtejY/O4BH/gYiDF5DT18/1vi9HtkojY+77AaQEqnSNPAMjc6IBcueDQswmQuPhG7IR2Z8KeYNZVqpdYE4LXeYeV/onI3Qd1QsTuc/r9kbGSB2dmD7Wdp/AN3K0rM6h3VmzRggXY87wd4gMH1oqoCxXYCI8Cfhzz+C9lIr/HjJN+4Zm/wa9UEMmQRxp3+Gv/RPHoA3f+D/8voEXONnEACOuWmSgOVFPn3Z1b4FSQ8LNIGUbg1SAfPxKSyYJM/mfJVJ558MwOOcrD+25WNkPbkZfaRIrpGnNxe6dHKsirfeqZNsPeSPhCaMQn3o3YKd6RiUdJeLaocv1E6JbgDYLWrP5SfwfM0ffBhLKbcSqt5veQr2C+5iLO9/KLswB6fElhox/SQZcoxcP/V5GL8LGy4O6BPuwgbeKYu
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jul 2026 11:19:19.4882
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e89b03d0-3ccc-4918-680f-08dedb506c6a
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF000001A5.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR08MB6671

On 06/07/2026 09:35, Fuad Tabba wrote:
> Back guest RAM with a guest_memfd created with GUEST_MEMFD_FLAG_MMAP
> and GUEST_MEMFD_FLAG_INIT_SHARED, mmapped MAP_SHARED to provide the
> userspace mapping.
>
> Protected VMs need in-place shared/private conversion of guest_memfd,
> which the kernel does not support yet, so reject the combination of
> --protected and --guest-memfd.
>
> Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
> ---
>   arm64/include/kvm/kvm-config-arch.h |  5 +++-
>   arm64/kvm.c                         | 38 +++++++++++++++++++++++------
>   include/kvm/kvm.h                   |  1 +
>   include/kvm/util.h                  |  1 +
>   kvm.c                               |  1 +
>   util/util.c                         | 34 ++++++++++++++++++++++++++
>   6 files changed, 71 insertions(+), 9 deletions(-)
>
> diff --git a/arm64/include/kvm/kvm-config-arch.h b/arm64/include/kvm/kvm-=
config-arch.h
> index c2702d5..d8a8ef7 100644
> --- a/arm64/include/kvm/kvm-config-arch.h
> +++ b/arm64/include/kvm/kvm-config-arch.h
> @@ -20,6 +20,7 @@ struct kvm_config_arch {
>       bool            no_pvtime;
>       bool            psci;
>       bool            protected;
> +     bool            guest_memfd;
>   };
>
>   int irqchip_parser(const struct option *opt, const char *arg, int unset=
);
> @@ -73,6 +74,8 @@ int sve_vl_parser(const struct option *opt, const char =
*arg, int unset);
>       OPT_BOOLEAN('\0', "e2h0", &(cfg)->e2h0,                            =
     \
>                   "Create guest without VHE support"),                   =
     \
>       OPT_BOOLEAN('\0', "protected", &(cfg)->protected,                  =
     \
> -                     "Create a protected VM when pKVM is enabled"),
> +                     "Create a protected VM when pKVM is enabled"),     =
     \
> +     OPT_BOOLEAN('\0', "guest-memfd", &(cfg)->guest_memfd,              =
     \
> +                     "Use guest_memfd to back guest RAM"),
>
>   #endif /* ARM_COMMON__KVM_CONFIG_ARCH_H */
> diff --git a/arm64/kvm.c b/arm64/kvm.c
> index fb0b98d..b594578 100644
> --- a/arm64/kvm.c
> +++ b/arm64/kvm.c
> @@ -49,9 +49,14 @@ void kvm__init_ram(struct kvm *kvm)
>       kvm->arch.ram_alloc_size =3D kvm->ram_size;
>       if (!kvm->cfg.hugetlbfs_path)
>               kvm->arch.ram_alloc_size +=3D SZ_2M;
> -     kvm->arch.ram_alloc_start =3D mmap_anon_or_hugetlbfs(kvm,
> -                                             kvm->cfg.hugetlbfs_path,
> -                                             kvm->arch.ram_alloc_size);
> +
> +     if (kvm->cfg.arch.guest_memfd)
> +             kvm->arch.ram_alloc_start =3D
> +                     mmap_guest_memfd(kvm, kvm->arch.ram_alloc_size);
> +     else
> +             kvm->arch.ram_alloc_start =3D
> +                     mmap_anon_or_hugetlbfs(kvm, kvm->cfg.hugetlbfs_path=
,
> +                                            kvm->arch.ram_alloc_size);
>
>       if (kvm->arch.ram_alloc_start =3D=3D MAP_FAILED)
>               die("Failed to map %lld bytes for guest memory (%d)",
> @@ -60,17 +65,25 @@ void kvm__init_ram(struct kvm *kvm)
>       kvm->ram_start =3D (void *)ALIGN((unsigned long)kvm->arch.ram_alloc=
_start,
>                                       SZ_2M);
>
> -     madvise(kvm->arch.ram_alloc_start, kvm->arch.ram_alloc_size,
> -             MADV_MERGEABLE);
> +     if (!kvm->cfg.arch.guest_memfd) {
> +             madvise(kvm->arch.ram_alloc_start, kvm->arch.ram_alloc_size=
,
> +                     MADV_MERGEABLE);
>
> -     madvise(kvm->arch.ram_alloc_start, kvm->arch.ram_alloc_size,
> -             MADV_HUGEPAGE);
> +             madvise(kvm->arch.ram_alloc_start, kvm->arch.ram_alloc_size=
,
> +                     MADV_HUGEPAGE);
> +     }
>
>       phys_start      =3D kvm->cfg.ram_addr;
>       phys_size       =3D kvm->ram_size;
>       host_mem        =3D kvm->ram_start;
>
> -     err =3D kvm__register_ram(kvm, phys_start, phys_size, host_mem);
> +     if (kvm->cfg.arch.guest_memfd)
> +             err =3D kvm__register_ram_guest_memfd(kvm, phys_start,
> +                                                 phys_size, host_mem,
> +                                                 kvm->ram_guest_memfd,
> +                                                 host_mem - kvm->arch.ra=
m_alloc_start);
> +     else
> +             err =3D kvm__register_ram(kvm, phys_start, phys_size, host_=
mem);
>       if (err)
>               die("Failed to register %lld bytes of memory at physical "
>                   "address 0x%llx [err %d]", phys_size, phys_start, err);
> @@ -468,6 +481,15 @@ void kvm__arch_validate_cfg(struct kvm *kvm)
>       if (kvm->cfg.arch.e2h0 && !kvm->cfg.arch.nested_virt)
>               pr_warning("--e2h0 requires --nested, ignoring");
>
> +     if (kvm->cfg.arch.guest_memfd) {
> +             /* Requires in-place shared/private conversion of guest_mem=
fd. */
> +             if (kvm->cfg.arch.protected)
> +                     die("Protected VMs do not yet support guest_memfd")=
;
> +
> +             if (kvm->cfg.hugetlbfs_path)
> +                     die("guest_memfd cannot be backed by hugetlbfs");
> +     }
> +
>       if (kvm->cfg.arch.protected) {
>               if (kvm->cfg.ram_size &&
>                   kvm->cfg.ram_size < DMA_MEM_REGION_SIZE) {
> diff --git a/include/kvm/kvm.h b/include/kvm/kvm.h
> index 5e7b5eb..95dc52f 100644
> --- a/include/kvm/kvm.h
> +++ b/include/kvm/kvm.h
> @@ -90,6 +90,7 @@ struct kvm {
>       u64                     ram_size;       /* Guest memory size, in by=
tes */
>       void                    *ram_start;
>       u64                     ram_pagesize;
> +     int                     ram_guest_memfd; /* guest_memfd backing RAM=
, -1 if none */
>       struct mutex            mem_banks_lock;
>       struct list_head        mem_banks;
>
> diff --git a/include/kvm/util.h b/include/kvm/util.h
> index a6dba11..9e23431 100644
> --- a/include/kvm/util.h
> +++ b/include/kvm/util.h
> @@ -148,5 +148,6 @@ static inline int pow2_size(unsigned long x)
>   struct kvm;
>   void *mmap_hugetlbfs(struct kvm *kvm, const char *htlbfs_path, u64 size=
);
>   void *mmap_anon_or_hugetlbfs(struct kvm *kvm, const char *hugetlbfs_pat=
h, u64 size);
> +void *mmap_guest_memfd(struct kvm *kvm, u64 size);
>
>   #endif /* KVM__UTIL_H */
> diff --git a/kvm.c b/kvm.c
> index 3d05756..a400dd2 100644
> --- a/kvm.c
> +++ b/kvm.c
> @@ -162,6 +162,7 @@ struct kvm *kvm__new(void)
>       mutex_init(&kvm->mem_banks_lock);
>       kvm->sys_fd =3D -1;
>       kvm->vm_fd =3D -1;
> +     kvm->ram_guest_memfd =3D -1;
>
>   #ifdef KVM_BRLOCK_DEBUG
>       kvm->brlock_sem =3D (pthread_rwlock_t) PTHREAD_RWLOCK_INITIALIZER;
> diff --git a/util/util.c b/util/util.c
> index 05d49c4..c60fe02 100644
> --- a/util/util.c
> +++ b/util/util.c
> @@ -6,7 +6,9 @@
>   #include "kvm/util.h"
>
>   #include <kvm/kvm.h>
> +#include <linux/kvm.h>
>   #include <linux/magic.h>    /* For HUGETLBFS_MAGIC */
> +#include <sys/ioctl.h>
>   #include <sys/mman.h>
>   #include <sys/stat.h>
>   #include <sys/statfs.h>
> @@ -169,3 +171,35 @@ void *mmap_anon_or_hugetlbfs(struct kvm *kvm, const =
char *hugetlbfs_path, u64 si
>               return mmap(NULL, size, PROT_RW, MAP_ANON_NORESERVE, -1, 0)=
;
>       }
>   }
> +
> +/*
> + * Map guest RAM backed by a guest_memfd. The file descriptor must stay =
open
> + * for the lifetime of the VM: closing it invalidates the memslot bindin=
gs.
> + */
> +void *mmap_guest_memfd(struct kvm *kvm, u64 size)
> +{
> +     u64 flags =3D GUEST_MEMFD_FLAG_MMAP | GUEST_MEMFD_FLAG_INIT_SHARED;
> +     struct kvm_create_guest_memfd gmem =3D {
> +             .size   =3D size,
> +             .flags  =3D flags,
> +     };
> +     void *addr;
> +     int ret;
> +
> +     ret =3D ioctl(kvm->vm_fd, KVM_CHECK_EXTENSION, KVM_CAP_GUEST_MEMFD_=
FLAGS);
> +     if (ret < 0 || ((u64)ret & flags) !=3D flags)
> +             die("kernel does not support guest_memfd with mmap");

Minor nit: "VM type doesn't support..", to be precise ?

Suzuki
IMPORTANT NOTICE: The contents of this email and any attachments are confid=
ential and may also be privileged. If you are not the intended recipient, p=
lease notify the sender immediately and do not disclose the contents to any=
 other person, use it for any purpose, or store or copy the information in =
any medium. Thank you.
