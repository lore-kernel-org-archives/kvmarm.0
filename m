Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011045.outbound.protection.outlook.com [40.107.130.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CA3B38D68E;
	Fri, 20 Mar 2026 14:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.45
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774015800; cv=fail; b=UsGHwXBAQ6m9RQCbpxytgvi6tgogw72HwGS0A4CS+3JjSkye838SSNMev8d0J3igKfzv+AAZ6L1IK8azQdgpxPNy2mUbdCzRGTCFUX6Ms/lF1Kt4gSV3eatL5Egcmk2wQxbRnPYFwqlqjDlcbQLUOJ9dWUVKF4WjQS6ud+xDVds=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774015800; c=relaxed/simple;
	bh=r08YfAZklEru+t6nvtc1oPoTo1zgZvk7tFdkVh/FaU8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=EW5vgGHrOSKWpU6xnhcKDXEmtFTf6PeA7cHG/RxGWYnAzWAaSCK1kJAXUbVUd5To3z23crPOE4M9tYOgiEyKSnraZfxqdwDvIooN420xXidWpl+a6H9l99cO8wnO5ylxngZmevXL4tHjULjIC1g4hj4b3Y3nu9CehJwhJLEKVp0=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=oQMMOE4J; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=oQMMOE4J; arc=fail smtp.client-ip=40.107.130.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="oQMMOE4J";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="oQMMOE4J"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=Am3/WimByQ62dn/nzvh0qhiTEnXU3SD1qmZBIIr7OsAn3egxf6bba28bu4bUgJFfnJrgoMwRl5XDhONNFenRd96gY/GzldfnaH0nbMEwB1jOZKl+Wln5ZOunOCYUb9M2Q4LDiumIiHUksD/KYbso7fjd7t1ca+cPxGAP57MuOYVySPtXdd4PqcIQdXOtRKiq1IBnisLgfW1L4gDj80O6tyH/cK+YR0QiGk4j0PV30Jbz2XdTrs+deQbsU7JWY3QMpxVWb6bTHp+g6R5I0KpTtZJcmaj0MK7y9rprHuqX4UBTTR43oUBmXXxC+NdyK2uTexzsfsZnJJVcVIOeLgP+1g==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=grrNrlauWqqo2k87L/PWn+f80TOA00jsjWZtSsudBWY=;
 b=dSXViHX8yOY5JyRW+5TBkrymYgmpb536wPQBtZ1YJAe+v4uRCxhZw0CFrqVmCIv71Rzs4Py6giujwQm9i+T+TsEA4i+VtzkYS+J2zCEj1jxICSH6zCwZr+XT5rO938fBMJpR2i43BFeZNpc3q4KEgTlusHlmwI+mtThB0EW0YpGopZlo3d6Yk/Ialk/Am9ZMA9iglNwgDejqIRX8cWeUsV5elTijUuaOV7SGXOkm/ypjd+NG3FY6Rc3Wp+d3kd33Jl4QSqoja78WA21QHpKUSS35JbKPnXhqKyoHmWX5OTcnKVYJ6OblsTmp0VuJjkcqmdwMfsjXfxdpY23Yi6tYLA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=grrNrlauWqqo2k87L/PWn+f80TOA00jsjWZtSsudBWY=;
 b=oQMMOE4Ji9RxvBYQdz3hB6poHXii9dQzvGOAPqUxDhdAc3G4+D94IYeAZfEKwHdpJi75cF8zuc2yzMDvlwIO9Ji9v/4bSL//Uds6YJB9BWj0S8jhj2cjGcM6YPPZV0nwAiOkELq3EhhUB1mkA/DvctDTyIDiFOQeAImRzR2K9LY=
Received: from DU2PR04CA0059.eurprd04.prod.outlook.com (2603:10a6:10:234::34)
 by GVXPR08MB11544.eurprd08.prod.outlook.com (2603:10a6:150:2e3::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Fri, 20 Mar
 2026 14:09:46 +0000
Received: from DU6PEPF0000A7DF.eurprd02.prod.outlook.com
 (2603:10a6:10:234:cafe::a0) by DU2PR04CA0059.outlook.office365.com
 (2603:10a6:10:234::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9700.27 via Frontend Transport; Fri,
 20 Mar 2026 14:09:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU6PEPF0000A7DF.mail.protection.outlook.com (10.167.8.36) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.19 via
 Frontend Transport; Fri, 20 Mar 2026 14:09:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RCPhovLw1QnUTGUzsTBElQ2Zu4wSNyursmOp0n78suidBtMNNdVlW6J7b1s5gGjdYHo80tmeAhhSntlUyvpyQHpTCLvU26g0dgAeYq9Vk6CfEM13Ucfl73UgMfNXH/0y78If2luMGQa3tKsKMpPbZVWu2KZihjdkslKypwy/lF9Uf3yQ8o4zF3bHNKBraRxJZ61Oy5Z1OmpD87E1z12AXb6WvL3WaW0S4H3YkBufQFH3Eg3RjLHAYSoiyExKU7d3Qe6/y7lBE5nOnYOxZ6pdgTgCyA+RKlmop4OmXEKIFk7TqCsVb6O1yq9yCzc5uYFm1ghyhUz7tvm6xcEkBt/bXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=grrNrlauWqqo2k87L/PWn+f80TOA00jsjWZtSsudBWY=;
 b=IPDyeNM6vNk+pJM/8Zo9QgBk6QdAyWPgIiD1V4975kziTZTSP3aXMzjCsLgJHJQTittT29rFOb/ZDH8eSPMotQma3gK+Brnp3l8jNJTPSD5BmNwuhz7KLJ/hOAJBPqZggHSZt47xqPSFHLKg3OpS/2ZYaBX7n9Zh/2d2WHlyT+2UTjlfTnEx7D07ORY6iUsDSor5qvaW3/d616O3UegD+ai0aHW4hsqi5vKDn4HRW77ZtuJeOLUeJ3JcDMSb1OIGH1/XycnZDfZPnrWyXuizN6m4sy3zAOi2y8bnzUmtdfJ416xNjJ92GRaxDMN09qp0ukAbnW7HtzRXU5/7T08KEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=grrNrlauWqqo2k87L/PWn+f80TOA00jsjWZtSsudBWY=;
 b=oQMMOE4Ji9RxvBYQdz3hB6poHXii9dQzvGOAPqUxDhdAc3G4+D94IYeAZfEKwHdpJi75cF8zuc2yzMDvlwIO9Ji9v/4bSL//Uds6YJB9BWj0S8jhj2cjGcM6YPPZV0nwAiOkELq3EhhUB1mkA/DvctDTyIDiFOQeAImRzR2K9LY=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from DU4PR08MB11769.eurprd08.prod.outlook.com (2603:10a6:10:644::21)
 by PA6PR08MB11586.eurprd08.prod.outlook.com (2603:10a6:102:525::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.23; Fri, 20 Mar
 2026 14:08:41 +0000
Received: from DU4PR08MB11769.eurprd08.prod.outlook.com
 ([fe80::d424:cd62:81a8:490f]) by DU4PR08MB11769.eurprd08.prod.outlook.com
 ([fe80::d424:cd62:81a8:490f%5]) with mapi id 15.20.9723.018; Fri, 20 Mar 2026
 14:08:41 +0000
Message-ID: <8929a008-0991-4e3c-98a1-f00af47dd0ff@arm.com>
Date: Fri, 20 Mar 2026 14:08:39 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 20/48] arm64: RMI: Handle realm enter/exit
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
 <20260318155413.793430-21-steven.price@arm.com>
Content-Language: en-US
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20260318155413.793430-21-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PA7P264CA0246.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:371::13) To DU4PR08MB11769.eurprd08.prod.outlook.com
 (2603:10a6:10:644::21)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	DU4PR08MB11769:EE_|PA6PR08MB11586:EE_|DU6PEPF0000A7DF:EE_|GVXPR08MB11544:EE_
X-MS-Office365-Filtering-Correlation-Id: 44f708a3-96d4-434e-9094-08de868a571f
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|7416014|376014|366016|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 ePl+gn/C1WcvmnfOJEvDDsPwz30iMh2xICM9C3wfjR1Zj7fQhPOxmfS7XthC9Rc4vISETctg/tnTqXKruBV4BpXf92BquxIDbhG/4Pxk9T6MNKwNQcKH7xhcMBNHaD1qxRUbAhB47lCDkdPY5rPfvhIpBlagxIBYO8bug2qcLGt3NXFHeXcrpRgHTFz5KEA2tvJRjnj0y0E66b4rg524pL7cIL8vRLkrHAZEjBsJuSpbRAFJ/OE4KkXmplBj+9lSePhjusIvgrX5hqrWHnxjYNh4qwyAfU1F3I6psYIHmmdxatn9npj3r+s3p3Z/Y3LlkJvLFPyiPs+fzOFpVkEae5qnU5RVtvnvktBA9pq57ihLDYv96BumvI8wu+W8BLqJxX/CfCvWZaGzfiDuBpjb+ASnOpnSvqplaFPHqqh1cAAUL3RMeJwAZ6DDqfcGkZIjOCWcjXA1EQEsbQHhngi19Y6bp0ORCd4L11d3Hvd/vYJLg6/XxED/rUUo6hzvG3ZCcnk1oGqv4cbR/SS5Jzsh7hlPge1nOkTq3mTxKYqHAH3bJTeC4CY2h7SH/JYf/y7mmmMmpaEPSRf5+nFnhXOeuEvf/R7fgm4ASTd02l2kCYmSWNep0zehZRCIjyEhgEpPfncKhof/C8qUO3vpIm15N7nNmLYWGd7D/wSX8SgvBLaBofFKxd2O0yxpakUfV+Pt7fji4lqbhdwjIZqdDLxrZ2Bg2uimdgdkdAircaFx0Qs=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU4PR08MB11769.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 b+SG6ZYQ68PvZCmrQ6Q5sYzfgmZjtINOu/lV6jdC235ah2rzruM/Kvi1zw21/bf+1brgJXIeItpUrwrSCyZ4moKf90qode++mKYK/0Leffia5pNZrXnQoAz5LU1sDp9xzMir4EY05f4PHonMuvO7lY2c7ZUla382RxkuJkLWzflxS7aVxI053fWywC45o1m8p+8UWi47kvcajvFJWIYLLxToZKMH5ciPMXdPxI54yJ8kDHkJ7DKR7sdqc7xqRr6+1XQfXTY9EmEb5xrtSHjOlZ81sKfFTQxysP/ySht1PqaxPcMt+pSHCHJg1d1yWr72tszuTTPCC2a9+niVxON1uQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA6PR08MB11586
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU6PEPF0000A7DF.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	5e85d8e0-d337-45ec-9e36-08de868a3067
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|82310400026|35042699022|14060799003|36860700016|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	KESgNGsLIzCIsw3xTtcx1icQ+59bCkoG7jk/7UC+CLj99r7yNl7cq1vCTV5i9Vajd/VRSHQQ+ypYsfDs/dB73kzfRdT1otEW8d1H9Z7AoupZ/lBVXgidf8ZU3A2wUKeKtzCD3FU5PksYqvUBdbv105wU+Jh7+EaDfycG/COi/lwFhwnDc3vlOHzo5T7dnLgzvpHCHHIS4epp69/4m7cAIiDH41Im+32dGjyH8c8IoVSI4vwIMLb0cqApls6kgJYT0Fd5li7Z28g8ozCaVgGHYy1FFF9i+iamxEdwNkIcvTfbBGOpjioWEfiT0thVgy2rtmqLjdt+imiXAdIfYzbfgYKdIuM+LPesulQhsOW1B4rcqMZV5atwd9CIjXur6Kv1P2EOk1NO+CRPQVRx0mwe6QZfxkHTpikC/nth9b0X5nAaUBX1ZeI+ic/L+ddtK6oOxTGgOz5tW4/26mzdRySUS5lWymHkAbZASgAtsjtk1sbC8VR6zHxJg+uT3Yh3c1WsNt002wGI2M/VDJ7Tqi/XT+d140j3IonEeggXu8HVx7tvvM4TEHZGtl/GZo9BoLIBtUK1z1hvsAIL4F9UMigirDs3JNRECs8FUAoMFIFL9QUtHT5cq+k8E+TBD+bRG714tIXg/arMaaMnoGwqV68KgRRYsaxSPydAgJb92qJTMCZtLzBFeyzkjV7eteRJqtuRPxDk3zrvN6taZ59TlcioIq7rtauHRsX6YVisMV9goO4mc5UnTiZOyS/jk5shmgMhafq4dvxTaz1BfLSrklQ8UQ==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(82310400026)(35042699022)(14060799003)(36860700016)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	zHUCymPge8+o7qMzVXSAQbFBdjC7+3JNIjtBix/evdjZxOLFMLx4KYupuvTuDBOg3l/edKLDczUO6qWK391cSE/MyWZ4OV9+ODhbH2Om0QZ6tsSWq/hwWQRyBa7/q1Ga2kgeg+pe1CyRQDAyh8bjQoNNlLdmROJJpfs+FU8ReeKBCnuKC8qLco09O/UoEApqERPjMkxnCG2N0kIxVQjvMsS+3owNFLraJZjrJ1XlnvXXatoiKU6OhuDdzoArIOk7v0YaNCEDCdtPJ31hnUBwyjLPUpGJ6yR2SvaHzORBvdtkzZSsVJaQsTXyaKsdq2jKCM/pujYHVFKyI7mzFRvN9rAVo8g5SrTtu8DGVoKPwOKicj5jS6zA+9ggyOWFgGY1AGesMWq1Nqh8PpgcH4qbq5bH53aAhHlI8n9jnLeJXq+dHvGA3Kf2Tm5Em5j6W1lM
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2026 14:09:45.7384
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 44f708a3-96d4-434e-9094-08de868a571f
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU6PEPF0000A7DF.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVXPR08MB11544

On 18/03/2026 15:53, Steven Price wrote:
> Entering a realm is done using a SMC call to the RMM. On exit the
> exit-codes need to be handled slightly differently to the normal KVM
> path so define our own functions for realm enter/exit and hook them
> in if the guest is a realm guest.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> ---
> Changes since v12:
>   * Call guest_state_{enter,exit}_irqoff() around rmi_rec_enter().
>   * Add handling of the IRQ exception case where IRQs need to be briefly
>     enabled before exiting guest timing.
> Changes since v8:
>   * Introduce kvm_rec_pre_enter() called before entering an atomic
>     section to handle operations that might require memory allocation
>     (specifically completing a RIPAS change introduced in a later patch).
>   * Updates to align with upstream changes to hpfar_el2 which now (ab)uses
>     HPFAR_EL2_NS as a valid flag.
>   * Fix exit reason when racing with PSCI shutdown to return
>     KVM_EXIT_SHUTDOWN rather than KVM_EXIT_UNKNOWN.
> Changes since v7:
>   * A return of 0 from kvm_handle_sys_reg() doesn't mean the register has
>     been read (although that can never happen in the current code). Tidy
>     up the condition to handle any future refactoring.
> Changes since v6:
>   * Use vcpu_err() rather than pr_err/kvm_err when there is an associated
>     vcpu to the error.
>   * Return -EFAULT for KVM_EXIT_MEMORY_FAULT as per the documentation for
>     this exit type.
>   * Split code handling a RIPAS change triggered by the guest to the
>     following patch.
> Changes since v5:
>   * For a RIPAS_CHANGE request from the guest perform the actual RIPAS
>     change on next entry rather than immediately on the exit. This allows
>     the VMM to 'reject' a RIPAS change by refusing to continue
>     scheduling.
> Changes since v4:
>   * Rename handle_rme_exit() to handle_rec_exit()
>   * Move the loop to copy registers into the REC enter structure from the
>     to rec_exit_handlers callbacks to kvm_rec_enter(). This fixes a bug
>     where the handler exits to user space and user space wants to modify
>     the GPRS.
>   * Some code rearrangement in rec_exit_ripas_change().
> Changes since v2:
>   * realm_set_ipa_state() now provides an output parameter for the
>     top_iap that was changed. Use this to signal the VMM with the correct
>     range that has been transitioned.
>   * Adapt to previous patch changes.
> ---
>   arch/arm64/include/asm/kvm_rmi.h |   4 +
>   arch/arm64/kvm/Makefile          |   2 +-
>   arch/arm64/kvm/arm.c             |  26 ++++-
>   arch/arm64/kvm/rmi-exit.c        | 178 +++++++++++++++++++++++++++++++
>   arch/arm64/kvm/rmi.c             |  43 ++++++++
>   5 files changed, 247 insertions(+), 6 deletions(-)
>   create mode 100644 arch/arm64/kvm/rmi-exit.c
> 
> diff --git a/arch/arm64/include/asm/kvm_rmi.h b/arch/arm64/include/asm/kvm_rmi.h
> index 4e2c61e71a38..7bec3a3976e7 100644
> --- a/arch/arm64/include/asm/kvm_rmi.h
> +++ b/arch/arm64/include/asm/kvm_rmi.h
> @@ -92,6 +92,10 @@ void kvm_destroy_realm(struct kvm *kvm);
>   void kvm_realm_destroy_rtts(struct kvm *kvm);
>   void kvm_destroy_rec(struct kvm_vcpu *vcpu);
>   
> +int kvm_rec_enter(struct kvm_vcpu *vcpu);
> +int kvm_rec_pre_enter(struct kvm_vcpu *vcpu);
> +int handle_rec_exit(struct kvm_vcpu *vcpu, int rec_run_status);
> +
>   static inline bool kvm_realm_is_private_address(struct realm *realm,
>   						unsigned long addr)
>   {
> diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
> index e17c4077d8e7..4b103bcbe760 100644
> --- a/arch/arm64/kvm/Makefile
> +++ b/arch/arm64/kvm/Makefile
> @@ -16,7 +16,7 @@ CFLAGS_handle_exit.o += -Wno-override-init
>   kvm-y += arm.o mmu.o mmio.o psci.o hypercalls.o pvtime.o \
>   	 inject_fault.o va_layout.o handle_exit.o config.o \
>   	 guest.o debug.o reset.o sys_regs.o stacktrace.o \
> -	 vgic-sys-reg-v3.o fpsimd.o pkvm.o rmi.o \
> +	 vgic-sys-reg-v3.o fpsimd.o pkvm.o rmi.o rmi-exit.o \
>   	 arch_timer.o trng.o vmid.o emulate-nested.o nested.o at.o \
>   	 vgic/vgic.o vgic/vgic-init.o \
>   	 vgic/vgic-irqfd.o vgic/vgic-v2.o \
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 45eff4c41cde..badb94b398bc 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -1311,6 +1311,9 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>   		if (ret > 0)
>   			ret = check_vcpu_requests(vcpu);
>   
> +		if (ret > 0 && vcpu_is_rec(vcpu))
> +			ret = kvm_rec_pre_enter(vcpu);
> +
>   		/*
>   		 * Preparing the interrupts to be injected also
>   		 * involves poking the GIC, which must be done in a
> @@ -1358,7 +1361,10 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>   		trace_kvm_entry(*vcpu_pc(vcpu));
>   		guest_timing_enter_irqoff();
>   
> -		ret = kvm_arm_vcpu_enter_exit(vcpu);
> +		if (vcpu_is_rec(vcpu))
> +			ret = kvm_rec_enter(vcpu);
> +		else
> +			ret = kvm_arm_vcpu_enter_exit(vcpu);
>   
>   		vcpu->mode = OUTSIDE_GUEST_MODE;
>   		vcpu->stat.exits++;
> @@ -1404,7 +1410,9 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>   		 * context synchronization event) is necessary to ensure that
>   		 * pending interrupts are taken.
>   		 */
> -		if (ARM_EXCEPTION_CODE(ret) == ARM_EXCEPTION_IRQ) {
> +		if (ARM_EXCEPTION_CODE(ret) == ARM_EXCEPTION_IRQ ||
> +		    (vcpu_is_rec(vcpu) &&
> +		     vcpu->arch.rec.run->exit.exit_reason == RMI_EXIT_IRQ)) {
>   			local_irq_enable();
>   			isb();
>   			local_irq_disable();
> @@ -1416,8 +1424,13 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>   
>   		trace_kvm_exit(ret, kvm_vcpu_trap_get_class(vcpu), *vcpu_pc(vcpu));
>   
> -		/* Exit types that need handling before we can be preempted */
> -		handle_exit_early(vcpu, ret);
> +		if (!vcpu_is_rec(vcpu)) {
> +			/*
> +			 * Exit types that need handling before we can be
> +			 * preempted
> +			 */
> +			handle_exit_early(vcpu, ret);
> +		}
>   
>   		kvm_nested_sync_hwstate(vcpu);
>   
> @@ -1442,7 +1455,10 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>   			ret = ARM_EXCEPTION_IL;
>   		}
>   
> -		ret = handle_exit(vcpu, ret);
> +		if (vcpu_is_rec(vcpu))
> +			ret = handle_rec_exit(vcpu, ret);
> +		else
> +			ret = handle_exit(vcpu, ret);
>   	}
>   
>   	/* Tell userspace about in-kernel device output levels */
> diff --git a/arch/arm64/kvm/rmi-exit.c b/arch/arm64/kvm/rmi-exit.c
> new file mode 100644
> index 000000000000..f5701153dec0
> --- /dev/null
> +++ b/arch/arm64/kvm/rmi-exit.c
> @@ -0,0 +1,178 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (C) 2023 ARM Ltd.
> + */
> +
> +#include <linux/kvm_host.h>
> +#include <kvm/arm_hypercalls.h>
> +#include <kvm/arm_psci.h>
> +
> +#include <asm/rmi_smc.h>
> +#include <asm/kvm_emulate.h>
> +#include <asm/kvm_rmi.h>
> +#include <asm/kvm_mmu.h>
> +
> +typedef int (*exit_handler_fn)(struct kvm_vcpu *vcpu);
> +
> +static int rec_exit_reason_notimpl(struct kvm_vcpu *vcpu)
> +{
> +	struct realm_rec *rec = &vcpu->arch.rec;
> +
> +	vcpu_err(vcpu, "Unhandled exit reason from realm (ESR: %#llx)\n",
> +		 rec->run->exit.esr);
> +	return -ENXIO;
> +}
> +
> +static int rec_exit_sync_dabt(struct kvm_vcpu *vcpu)
> +{
> +	return kvm_handle_guest_abort(vcpu);
> +}
> +
> +static int rec_exit_sync_iabt(struct kvm_vcpu *vcpu)
> +{
> +	struct realm_rec *rec = &vcpu->arch.rec;
> +
> +	vcpu_err(vcpu, "Unhandled instruction abort (ESR: %#llx).\n",
> +		 rec->run->exit.esr);
> +	return -ENXIO;
> +}
> +
> +static int rec_exit_sys_reg(struct kvm_vcpu *vcpu)
> +{
> +	struct realm_rec *rec = &vcpu->arch.rec;
> +	unsigned long esr = kvm_vcpu_get_esr(vcpu);
> +	int rt = kvm_vcpu_sys_get_rt(vcpu);
> +	bool is_write = !(esr & 1);
> +	int ret;
> +
> +	if (is_write)
> +		vcpu_set_reg(vcpu, rt, rec->run->exit.gprs[0]);

The RMM has been fixed to indicate the correct value in ESR_ELx_SRT. So
this could be :
		vcpu_set_reg(vcpu, rt, rec->run->ext.gprs[rt]); ?

> +
> +	ret = kvm_handle_sys_reg(vcpu);
> +	if (!is_write)
> +		rec->run->enter.gprs[0] = vcpu_get_reg(vcpu, rt);

Same here ^

> +
> +	return ret;
> +}
> +
> +static exit_handler_fn rec_exit_handlers[] = {
> +	[0 ... ESR_ELx_EC_MAX]	= rec_exit_reason_notimpl,
> +	[ESR_ELx_EC_SYS64]	= rec_exit_sys_reg,
> +	[ESR_ELx_EC_DABT_LOW]	= rec_exit_sync_dabt,
> +	[ESR_ELx_EC_IABT_LOW]	= rec_exit_sync_iabt
> +};
> +
> +static int rec_exit_psci(struct kvm_vcpu *vcpu)
> +{
> +	struct realm_rec *rec = &vcpu->arch.rec;
> +	int i;
> +
> +	for (i = 0; i < REC_RUN_GPRS; i++)
> +		vcpu_set_reg(vcpu, i, rec->run->exit.gprs[i]);
> +
> +	return kvm_smccc_call_handler(vcpu);
> +}
> +
> +static int rec_exit_ripas_change(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm *kvm = vcpu->kvm;
> +	struct realm *realm = &kvm->arch.realm;
> +	struct realm_rec *rec = &vcpu->arch.rec;
> +	unsigned long base = rec->run->exit.ripas_base;
> +	unsigned long top = rec->run->exit.ripas_top;
> +	unsigned long ripas = rec->run->exit.ripas_value;
> +
> +	if (!kvm_realm_is_private_address(realm, base) ||
> +	    !kvm_realm_is_private_address(realm, top - 1)) {
> +		vcpu_err(vcpu, "Invalid RIPAS_CHANGE for %#lx - %#lx, ripas: %#lx\n",
> +			 base, top, ripas);
> +		/* Set RMI_REJECT bit */
> +		rec->run->enter.flags = REC_ENTER_FLAG_RIPAS_RESPONSE;
> +		return -EINVAL;
> +	}
> +
> +	/* Exit to VMM, the actual RIPAS change is done on next entry */
> +	kvm_prepare_memory_fault_exit(vcpu, base, top - base, false, false,
> +				      ripas == RMI_RAM);
> +
> +	/*
> +	 * KVM_EXIT_MEMORY_FAULT requires an return code of -EFAULT, see the
> +	 * API documentation
> +	 */
> +	return -EFAULT;
> +}
> +
> +static void update_arch_timer_irq_lines(struct kvm_vcpu *vcpu)
> +{
> +	struct realm_rec *rec = &vcpu->arch.rec;
> +
> +	__vcpu_assign_sys_reg(vcpu, CNTV_CTL_EL0, rec->run->exit.cntv_ctl);
> +	__vcpu_assign_sys_reg(vcpu, CNTV_CVAL_EL0, rec->run->exit.cntv_cval);
> +	__vcpu_assign_sys_reg(vcpu, CNTP_CTL_EL0, rec->run->exit.cntp_ctl);
> +	__vcpu_assign_sys_reg(vcpu, CNTP_CVAL_EL0, rec->run->exit.cntp_cval);
> +
> +	kvm_realm_timers_update(vcpu);
> +}
> +
> +/*
> + * Return > 0 to return to guest, < 0 on error, 0 (and set exit_reason) on
> + * proper exit to userspace.
> + */
> +int handle_rec_exit(struct kvm_vcpu *vcpu, int rec_run_ret)
> +{
> +	struct realm_rec *rec = &vcpu->arch.rec;
> +	u8 esr_ec = ESR_ELx_EC(rec->run->exit.esr);
> +	unsigned long status, index;
> +
> +	status = RMI_RETURN_STATUS(rec_run_ret);
> +	index = RMI_RETURN_INDEX(rec_run_ret);
> +
> +	/*
> +	 * If a PSCI_SYSTEM_OFF request raced with a vcpu executing, we might
> +	 * see the following status code and index indicating an attempt to run
> +	 * a REC when the RD state is SYSTEM_OFF.  In this case, we just need to
> +	 * return to user space which can deal with the system event or will try
> +	 * to run the KVM VCPU again, at which point we will no longer attempt
> +	 * to enter the Realm because we will have a sleep request pending on
> +	 * the VCPU as a result of KVM's PSCI handling.
> +	 */
> +	if (status == RMI_ERROR_REALM && index == 1) {
> +		vcpu->run->exit_reason = KVM_EXIT_SHUTDOWN;
> +		return 0;
> +	}
> +
> +	if (rec_run_ret)
> +		return -ENXIO;
> +
> +	vcpu->arch.fault.esr_el2 = rec->run->exit.esr;

Even ESR_EL2 is only valid when the exit reason is RMI_EXIT_SYNC or 
RMI_EXIT_SERROR.
Doing this unconditional copying is fine, as long as we don't consume
the esr_el2 in exit handling without consulting the exit reason, which
may not be available to the rest of the KVM. It may be safer to set it
to 0 ?


> +	vcpu->arch.fault.far_el2 = rec->run->exit.far;
> +	/* HPFAR_EL2 is only valid for RMI_EXIT_SYNC */
> +	vcpu->arch.fault.hpfar_el2 = 0;
> +
> +	update_arch_timer_irq_lines(vcpu);
> +
> +	/* Reset the emulation flags for the next run of the REC */
> +	rec->run->enter.flags = 0;
> +
> +	switch (rec->run->exit.exit_reason) {
> +	case RMI_EXIT_SYNC:
> +		/*
> +		 * HPFAR_EL2_NS is hijacked to indicate a valid HPFAR value,
> +		 * see __get_fault_info()
> +		 */
> +		vcpu->arch.fault.hpfar_el2 = rec->run->exit.hpfar | HPFAR_EL2_NS;
> +		return rec_exit_handlers[esr_ec](vcpu);
> +	case RMI_EXIT_IRQ:
> +	case RMI_EXIT_FIQ:
> +		return 1;
> +	case RMI_EXIT_PSCI:
> +		return rec_exit_psci(vcpu);
> +	case RMI_EXIT_RIPAS_CHANGE:
> +		return rec_exit_ripas_change(vcpu);

RMI_EXIT_SERROR is missing in the list above.

> +	}
> +
> +	kvm_pr_unimpl("Unsupported exit reason: %u\n",
> +		      rec->run->exit.exit_reason);



> +	vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
> +	return 0;
> +}
> diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
> index 6daf14c4b413..ee8aab098117 100644
> --- a/arch/arm64/kvm/rmi.c
> +++ b/arch/arm64/kvm/rmi.c
> @@ -394,6 +394,49 @@ static int realm_ensure_created(struct kvm *kvm)
>   	return -ENXIO;
>   }
>   
> +/*
> + * kvm_rec_pre_enter - Complete operations before entering a REC
> + *
> + * Some operations require work to be completed before entering a realm. That
> + * work may require memory allocation so cannot be done in the kvm_rec_enter()
> + * call.
> + *
> + * Return: 1 if we should enter the guest
> + *	   0 if we should exit to userspace
> + *	   < 0 if we should exit to userspace, where the return value indicates
> + *	   an error
> + */
> +int kvm_rec_pre_enter(struct kvm_vcpu *vcpu)
> +{
> +	struct realm_rec *rec = &vcpu->arch.rec;
> +
> +	if (kvm_realm_state(vcpu->kvm) != REALM_STATE_ACTIVE)
> +		return -EINVAL;
> +
> +	switch (rec->run->exit.exit_reason) {
> +	case RMI_EXIT_HOST_CALL:
> +	case RMI_EXIT_PSCI:
> +		for (int i = 0; i < REC_RUN_GPRS; i++)
> +			rec->run->enter.gprs[i] = vcpu_get_reg(vcpu, i);
> +		break;
> +	}
> +
> +	return 1;
> +}
> +
> +int noinstr kvm_rec_enter(struct kvm_vcpu *vcpu)
> +{
> +	struct realm_rec *rec = &vcpu->arch.rec;
> +	int ret;
> +
> +	guest_state_enter_irqoff();
> +	ret = rmi_rec_enter(virt_to_phys(rec->rec_page),
> +			    virt_to_phys(rec->run));

In the normal VM case, we try to fixup some of the exits (e.g., GIC 
CPUIF register accesses) which may be applicable to Realms. Do we
need such fixups here ? Given the cost of world switch, it is
debatable whether it matters or not.

Suzuki
> +	guest_state_exit_irqoff();
> +
> +	return ret;
> +}
> +
>   static void free_rec_aux(struct page **aux_pages,
>   			 unsigned int num_aux)
>   {

