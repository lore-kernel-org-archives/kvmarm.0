Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010068.outbound.protection.outlook.com [52.101.69.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0DC638AC66;
	Fri, 20 Mar 2026 11:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.68
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774005389; cv=fail; b=T3AP0ZoLGQpRK7KrAO3ReKDPeaC9x8DFg5cKVTxJ35fkYD8DsoSNaCzSyEQuqA1qydMiCUIfVBN2JUCTTdzgQhUDQFbf9rmqjcaLR74HO5iOCMf9t5BITJ2oo7oGz5YodqCt8aW4DsWpb+zITe2YQ/LA3a8660GOnU2jDSiABHc=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774005389; c=relaxed/simple;
	bh=hmgtidQqKJxihtO8jDeOtwooKhI3LOqjgrKGy4Ecq8I=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=dv/TSP//S/OLlCwBl3vlbF657oQsEknx/i3/ncRv2lkwhY742fHw03YHV72Mf0NXALCVPXf92QPGHSn/hlgb7a3JYHv5IA8i0NEss9QHFQydtRSICmH8+effZyc78pOhPfwXRG2zjIZBtpQy1LYuyAjcm8zM9dhwHIbkRezdiK4=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=GkqA0WA4; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=GkqA0WA4; arc=fail smtp.client-ip=52.101.69.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="GkqA0WA4";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="GkqA0WA4"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=KiRhby8nnCTrRDp7L5AlLk219Hr8V+RX6+oYzeFBq9YFBO4fyl0uTgqF8Qim0fgZogaDRFqiLYqT63l7vk4zi2meSa6C+o+Xmd8bO2CDcpkHfoh7z7nlJ1nIwnjsK5piv4obJmGKbRO6QfB04QP85PoOc6XeCZJ/d0ZWmBx/ftcHFd6oPFbHMFugF8w2yOP+EyCgmdCPixeoR4JGqusfgAp23apEo5hPc5PHIxeKxUu+uRs2Exks63Jx7x2pihvVcqVRRV+3GSzpn8cLDLl+0ArOW57v2CuJwZTLTZpZS5DS/YSLxHWas9jKm4oeMJr6Vv9gx3cqck9x272H8rNYUA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0/IvFl7L2cyrBEcbko48zVMh95PyDPSARuGU1uluoVU=;
 b=aiFGpJskxunp8fkPLZUcHiDsvj7uUamiJ3RV9HcpvE622CLT7GTRRa8g8G4fIE32r644xq+04Mw3T+PMx3ydQEKRFrR9S5ujQCA4xAoLbjIXdwpru7DWU0osdi8MK5lHGGHc6RFoPwIYQB8iDmkyJBwY2b97kYQWpQ/kVrrnsOsBAGBq/U4HPATIK3CxxS9osSeR8AN9OV9KJxgoxeYn4itclmln4zWP3kIp2xZ989m/9+8Xu6jjSdPLdlACKa1c3pLbmv3AkJYqp5memoL2Sia6K4jcotQkLbMoZdl+rOGjRBfEoYDNiWBf8qIwQvoLHKn1MqOXSluJUNYHhCOQwA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0/IvFl7L2cyrBEcbko48zVMh95PyDPSARuGU1uluoVU=;
 b=GkqA0WA4p1ZAM4eqw/ix6dV01iZ7m12Fek2vlaVD+NuLsnQud1IywXbbWDrAV6aJ389DhHf3vDlTf+7UyLJe+NDShlQYaihStD1rdxf9FwD/Jibrn6KeJ8+06tlSTFeINJ8DqHput/Ed7h6v6E05c4HatNAO8ERbp/yLtcSWuL8=
Received: from DU7P251CA0009.EURP251.PROD.OUTLOOK.COM (2603:10a6:10:551::29)
 by GVXPR08MB11153.eurprd08.prod.outlook.com (2603:10a6:150:1f8::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Fri, 20 Mar
 2026 11:16:16 +0000
Received: from DU2PEPF00028D0E.eurprd03.prod.outlook.com
 (2603:10a6:10:551:cafe::89) by DU7P251CA0009.outlook.office365.com
 (2603:10a6:10:551::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.23 via Frontend Transport; Fri,
 20 Mar 2026 11:16:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU2PEPF00028D0E.mail.protection.outlook.com (10.167.242.22) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.19
 via Frontend Transport; Fri, 20 Mar 2026 11:16:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=szUQimuH1ZCs4UFTHvaMyi418UB2sq9jL5ty6RMVJetADsHZBgACUW9GcjN/I2aGXZE3G4JQmhu0CxhZrK+pefr5uedXOUnj2inawWyi0ynEXLl6qlA/sYr7/KwdXBC9Lp04qRMYG35g5s0s8oY5bOKzUC9eOjBoRuct4k6Sxa5zbJCPTMkWBg+3wNUlWtLLgky6Yzms+sM6N75eo1yspTGLSIQEONumvGBal51hi4RY8X0LRvZOja7lReSis629cbwNrV8s2cPhvb7lPHqAqCigE0DZ+8Swt5fQpjkAFVwrQSEmPFSjzKHmOwAWEc7OTXY/q8B8+PvD39KeZ4Ijjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0/IvFl7L2cyrBEcbko48zVMh95PyDPSARuGU1uluoVU=;
 b=uPesGw7Klsi2QxxxG9X7OlaSP5YJ4lXz8w8nvkv8g/9l1th9Kmx4DN3Ftj6Q+WB1GIOzXfee9D/b9qyXmToHTPP3Cr+R7u8rKLUrYBJzx/0ZuSusIKYReupCSE8Ge4vgHLgJ/9DXSwZQalfeCtzNeyynKbYvvv7izMGY8icmm3Md25GgTT7BK87jUIN47FXsEPSq34jSvFUoVD/f7OO2nYZZ+ToHkMjLRrqibxyY3B7XW3cvdkVQ4b8F9oOyEsZ36NfBmwQKzQjO10xiKG42NMvfmCOfHrPjCPZNF6tWphUAneqGKudrf6UnkFF7oIKoV5q5HWlQLe5XSmTTV6XiqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0/IvFl7L2cyrBEcbko48zVMh95PyDPSARuGU1uluoVU=;
 b=GkqA0WA4p1ZAM4eqw/ix6dV01iZ7m12Fek2vlaVD+NuLsnQud1IywXbbWDrAV6aJ389DhHf3vDlTf+7UyLJe+NDShlQYaihStD1rdxf9FwD/Jibrn6KeJ8+06tlSTFeINJ8DqHput/Ed7h6v6E05c4HatNAO8ERbp/yLtcSWuL8=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from DU4PR08MB11769.eurprd08.prod.outlook.com (2603:10a6:10:644::21)
 by GV1PR08MB10607.eurprd08.prod.outlook.com (2603:10a6:150:16c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.20; Fri, 20 Mar
 2026 11:15:11 +0000
Received: from DU4PR08MB11769.eurprd08.prod.outlook.com
 ([fe80::d424:cd62:81a8:490f]) by DU4PR08MB11769.eurprd08.prod.outlook.com
 ([fe80::d424:cd62:81a8:490f%5]) with mapi id 15.20.9723.018; Fri, 20 Mar 2026
 11:15:11 +0000
Message-ID: <59c83ace-c8be-4c71-99b6-cd5f085a3063@arm.com>
Date: Fri, 20 Mar 2026 11:15:10 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 21/48] arm64: RMI: Handle RMI_EXIT_RIPAS_CHANGE
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
 <20260318155413.793430-22-steven.price@arm.com>
Content-Language: en-US
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20260318155413.793430-22-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PR3P250CA0013.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:102:57::18) To DU4PR08MB11769.eurprd08.prod.outlook.com
 (2603:10a6:10:644::21)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	DU4PR08MB11769:EE_|GV1PR08MB10607:EE_|DU2PEPF00028D0E:EE_|GVXPR08MB11153:EE_
X-MS-Office365-Filtering-Correlation-Id: 2333b233-9482-4cc7-3240-08de86721a87
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|7416014|366016|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info-Original:
 vCKLIgGg4pb5eL2bDJYfA3ghR9p8WyFHofnRexmnWd1F5vEcaTj9NESf7e4eyXiV6fgG3ZgOa47gyj66R5av2tdSasl0CTXNaf2WHbsXJj9sxlP6VanUiSSu3HrgDmbceIqfQiC9TauVzoQG8LEiPpERS0YQHHFlz1CYSTsE8TLs8AVKpzPRZe1uKyWtUraXQafG41SQvw89NzlrwYmYnDvbrd7U8mhjAPjXvhuWXAQNSYwxbZ/8L6pPqwTwKsOfh5/0q8UwZLex9r/mWDQOfGd2o9miF+b6xuzE2IRue+H584Bz5YVJLTITfkmmS466muY4eEa5TwjB7/jhAqf7ZqspB/KQDvjEpM9C3WiA4LFLorV4uTIT314AP5WqrFIg0QtLvcrjHcbAbw8HeJr9NmBerVnFPIzcit61HssfZOORM2PbZDQNiVD7bk1BM0t5eNs2x2Rda5zOeE3nAbpls3NKmkUla7FGmUCNI+03N+mKmbQNgRVHoe2SUl5FOciiJY7itIIvZTbwjjhmsMeW4lvUiAmdglub4auC2tqLsmCrVucyVgGUmPEZwN4GM2yDAKvm3TcgGa74QjVp12PVt6xz7JZgTatHx31Ob648A+5Fobdor+QxiE13eMEfYl7Risq7YyUXRsoP3LBWurt3Zqfi/Qe2YNvTzZAPz5I7VMCsCwv8vQPRa3pxXCpGBejNvKKghBv9dZh+T0bb4tkO8M1vf0QLom+xJUziSwcAmtk=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU4PR08MB11769.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 KbOwrBctcMUSJkl8dpJeerFF7qWChIF9ErairotD7X3L4rnhc08cg/gWwMCHUXPg7rCZaJaYN+cadGrY2vFuH2WgbD0CN25hcMU4u3wSa4Gn/W/Qj0YzayMSNqgZRyCFJ3myJMc9ERuoRbSQAMoPAAWWUpGLccgkekorot4PgDJKvOTVVIqi77O3h67o+RLUCDhvRcR7gG90HoQwnjSuLwz0gchzBLCwO3NSoDA0xmWLooPJfwktKGhDo4GMbJglMRoUqxhY1hniPY1mHJ2URwSstrH20wtWUdOq1vlZDUfAy8Dv79y8x/PUhkONzmkg9doUjwZM/MFv22O/slMflA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR08MB10607
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU2PEPF00028D0E.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	fef5a7b6-6131-4fcc-92e0-08de8671f3e0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|14060799003|82310400026|376014|36860700016|1800799024|35042699022|30052699003|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	Us6DvItUy/YZwmNKbpjSziadngGvTd5i7/+VFJHJSwoG9pg8NHj6KrVbWlLmWYiYUG33Kp/0TqypGqpP0cprbzbie2aTFjwspMRzutDDpIwGzKvoP6zbXn8VTibSrghCscNOi23qmDJ8v41bzhbEFnSbIuSenGjwqYU/4F8Uv6iJf7BvT+F1bJIMBP9uIbsZBjKxKnxlHBzEzHDFaepqtUJINnOpRk0CAa60+6HeuvLS5LQ/G4+cI4mVP/ClfcQ3TqLc0XBK5DP/FDpigq23emMWrwKrSteZ2hEodq9NTYBDgcNduNTJjix4NgqCa4NwxPyLhVOkPhUtPrFyI8QhRZj0PL7bEet6TAorXujW+m6ZuI+J2lW++SXmA5F/ecr3qYG6Idxm+d8/DfM7+8cGcVLJaFqHIFHW1Ytt5WzdhgwK/BbDRb3/eWSt2xeTvAwmdyeZQY/5ANondMH9jWnYdkshZNt2YgmRiTKz1vCpCDTtmx5RsjKjSIAYAwTxvqcWLrxKfrCIEU/1xCA0i/WIB3j6weF04/hQbHRixF8MusnT+/c7YLIsRMCIb9ha190jBvAsGw/jnt6O3Pf0R4Gu4ALVdcIsvS7LhaNCUBZNWguZ5b6bpHnlHOo9ZsO1ULcrLMehBBT4kRXyYqiOdhMtJJmWI1YO8hOYvP2QcUOk+DRMRD8pviceYrytxoKGIAmgOrpYIbczwoxn9C9uVszSYpHtijyViu0two4Fl3tyFvLAQMFuOO4LqjhWOTXGOZjj4du+9YaJA56X4ihyROmefg==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(14060799003)(82310400026)(376014)(36860700016)(1800799024)(35042699022)(30052699003)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	bjYEtyYI9KGycn9VxgRlCluTPWQ1CVIhDRdwqsDAlbWd2cU1ugWyF4Y3vys8f4OW9/K1g68YEQRsDLGSrovOfy9OH+rReASlCi6PhsbVmfjReE/Zizk6HoO/S9PMTDt/QgaUbGcdRpnCTowOuCUi3gwUA2H+our9BKtOuMp3Drp04JYol4ZVoZUoOR19T+YLzW1iRcU+EuK5Ae8nXKt079OkDCuY2yupKFcxWz9xATTC9YLYmPZj249lmVrl1INwDb1KbRKx/9FwqdxDxlIM790kkvMn2bfeURwl8oNP0L7pmqz1B1fXiS+/pke0tuQCRbbTLfIYHnd+7LPM9V5snfIl2ISNq+Pbw6SnnDdlY0kEu3ehB2eC0rcIOkT4/4boGQ+bzhqCFqgRA79wKiEASngDBdHada58nf0HtX73YE+xbF19iA+EEsyKo02r6ID+
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2026 11:16:16.1517
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2333b233-9482-4cc7-3240-08de86721a87
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF00028D0E.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVXPR08MB11153

Hi Steven

On 18/03/2026 15:53, Steven Price wrote:
> The guest can request that a region of it's protected address space is
> switched between RIPAS_RAM and RIPAS_EMPTY (and back) using
> RSI_IPA_STATE_SET. This causes a guest exit with the
> RMI_EXIT_RIPAS_CHANGE code. We treat this as a request to convert a
> protected region to unprotected (or back), exiting to the VMM to make
> the necessary changes to the guest_memfd and memslot mappings. On the
> next entry the RIPAS changes are committed by making RMI_RTT_SET_RIPAS
> calls.
> 
> The VMM may wish to reject the RIPAS change requested by the guest. For
> now it can only do this by no longer scheduling the VCPU as we don't
> currently have a usecase for returning that rejection to the guest, but
> by postponing the RMI_RTT_SET_RIPAS changes to entry we leave the door
> open for adding a new ioctl in the future for this purpose.

I have been thinking about this. Today we do a KVM_MEMORY_FAULT_EXIT
to the VMM to handle the request. The other option is to make this
a KVM_EXIT_HYPERCALL with SMC_RSI_SET_RIPAS. But this would leak RSI
implementation to the VMM. The advantage is that the VMM can provide
a clear response RSI_ACCEPT vs RSI_REJECT (including accepting a partial
range) and KVM can satisfy the RMI_RTT_SET_RIPAS.

We may end up doing something similar for Device assignment too, where
the VMM gets a chance to reject any inconsistent device mappings.

Like you mentioned, the VMM can stop the Realm today as an alternate
approach.

Suzuki

> 
> There's a FIXME for the case where the RMM rejects a RIPAS change when
> (a portion of) the region. The current RMM implementation isn't spec
> compliant in this case, this should be fixed in a later release.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes since v12:
>   * Switch to the new RMM v2.0 RMI_RTT_DATA_UNMAP which can unmap an
>     address range.
> Changes since v11:
>   * Combine the "Allow VMM to set RIPAS" patch into this one to avoid
>     adding functions before they are used.
>   * Drop the CAP for setting RIPAS and adapt to changes from previous
>     patches.
> Changes since v10:
>   * Add comment explaining the assignment of rec->run->exit.ripas_base in
>     kvm_complete_ripas_change().
> Changes since v8:
>   * Make use of ripas_change() from a previous patch to implement
>     realm_set_ipa_state().
>   * Update exit.ripas_base after a RIPAS change so that, if instead of
>     entering the guest we exit to user space, we don't attempt to repeat
>     the RIPAS change (triggering an error from the RMM).
> Changes since v7:
>   * Rework the loop in realm_set_ipa_state() to make it clear when the
>     'next' output value of rmi_rtt_set_ripas() is used.
> New patch for v7: The code was previously split awkwardly between two
> other patches.
> ---
>   arch/arm64/include/asm/kvm_rmi.h |   6 +
>   arch/arm64/kvm/mmu.c             |   8 +-
>   arch/arm64/kvm/rmi.c             | 459 +++++++++++++++++++++++++++++++
>   3 files changed, 470 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_rmi.h b/arch/arm64/include/asm/kvm_rmi.h
> index 7bec3a3976e7..46b0cbe6c202 100644
> --- a/arch/arm64/include/asm/kvm_rmi.h
> +++ b/arch/arm64/include/asm/kvm_rmi.h
> @@ -96,6 +96,12 @@ int kvm_rec_enter(struct kvm_vcpu *vcpu);
>   int kvm_rec_pre_enter(struct kvm_vcpu *vcpu);
>   int handle_rec_exit(struct kvm_vcpu *vcpu, int rec_run_status);
>   
> +void kvm_realm_unmap_range(struct kvm *kvm,
> +			   unsigned long ipa,
> +			   unsigned long size,
> +			   bool unmap_private,
> +			   bool may_block);
> +
>   static inline bool kvm_realm_is_private_address(struct realm *realm,
>   						unsigned long addr)
>   {
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 41152abf55b2..b705ad6c6c8b 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -319,6 +319,7 @@ static void invalidate_icache_guest_page(void *va, size_t size)
>    * @start: The intermediate physical base address of the range to unmap
>    * @size:  The size of the area to unmap
>    * @may_block: Whether or not we are permitted to block
> + * @only_shared: If true then protected mappings should not be unmapped
>    *
>    * Clear a range of stage-2 mappings, lowering the various ref-counts.  Must
>    * be called while holding mmu_lock (unless for freeing the stage2 pgd before
> @@ -326,7 +327,7 @@ static void invalidate_icache_guest_page(void *va, size_t size)
>    * with things behind our backs.
>    */
>   static void __unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64 size,
> -				 bool may_block)
> +				 bool may_block, bool only_shared)
>   {
>   	struct kvm *kvm = kvm_s2_mmu_to_kvm(mmu);
>   	phys_addr_t end = start + size;
> @@ -340,7 +341,7 @@ static void __unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64
>   void kvm_stage2_unmap_range(struct kvm_s2_mmu *mmu, phys_addr_t start,
>   			    u64 size, bool may_block)
>   {
> -	__unmap_stage2_range(mmu, start, size, may_block);
> +	__unmap_stage2_range(mmu, start, size, may_block, false);
>   }
>   
>   void kvm_stage2_flush_range(struct kvm_s2_mmu *mmu, phys_addr_t addr, phys_addr_t end)
> @@ -2241,7 +2242,8 @@ bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
>   
>   	__unmap_stage2_range(&kvm->arch.mmu, range->start << PAGE_SHIFT,
>   			     (range->end - range->start) << PAGE_SHIFT,
> -			     range->may_block);
> +			     range->may_block,
> +			     !(range->attr_filter & KVM_FILTER_PRIVATE));
>   
>   	kvm_nested_s2_unmap(kvm, range->may_block);
>   	return false;
> diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
> index ee8aab098117..13eed6f0b9eb 100644
> --- a/arch/arm64/kvm/rmi.c
> +++ b/arch/arm64/kvm/rmi.c
> @@ -251,6 +251,88 @@ static int undelegate_page(phys_addr_t phys)
>   	return undelegate_range(phys, PAGE_SIZE);
>   }
>   
> +static int find_map_level(struct realm *realm,
> +			  unsigned long start,
> +			  unsigned long end)
> +{
> +	int level = RMM_RTT_MAX_LEVEL;
> +
> +	while (level > get_start_level(realm)) {
> +		unsigned long map_size = rmi_rtt_level_mapsize(level - 1);
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
> +static unsigned long level_to_size(int level)
> +{
> +	switch (level) {
> +	case 0:
> +		return PAGE_SIZE;
> +	case 1:
> +		return PMD_SIZE;
> +	case 2:
> +		return PUD_SIZE;
> +	case 3:
> +		return P4D_SIZE;
> +	}
> +	WARN_ON(1);
> +	return 0;
> +}
> +
> +static int undelegate_range_desc(unsigned long desc)
> +{
> +	unsigned long size = level_to_size(RMI_ADDR_RANGE_SIZE(desc));
> +	unsigned long count = RMI_ADDR_RANGE_COUNT(desc);
> +	unsigned long addr = RMI_ADDR_RANGE_ADDR(desc);
> +	unsigned long state = RMI_ADDR_RANGE_STATE(desc);
> +
> +	if (state == RMI_OP_MEM_UNDELEGATED)
> +		return 0;
> +
> +	return undelegate_range(addr, size * count);
> +}
> +
> +static phys_addr_t alloc_delegated_granule(struct kvm_mmu_memory_cache *mc)
> +{
> +	phys_addr_t phys;
> +	void *virt;
> +
> +	if (mc) {
> +		virt = kvm_mmu_memory_cache_alloc(mc);
> +	} else {
> +		virt = (void *)__get_free_page(GFP_ATOMIC | __GFP_ZERO |
> +					       __GFP_ACCOUNT);
> +	}
> +
> +	if (!virt)
> +		return PHYS_ADDR_MAX;
> +
> +	phys = virt_to_phys(virt);
> +	if (delegate_page(phys)) {
> +		free_page((unsigned long)virt);
> +		return PHYS_ADDR_MAX;
> +	}
> +
> +	return phys;
> +}
> +
> +static phys_addr_t alloc_rtt(struct kvm_mmu_memory_cache *mc)
> +{
> +	phys_addr_t phys = alloc_delegated_granule(mc);
> +
> +	if (phys != PHYS_ADDR_MAX)
> +		kvm_account_pgtable_pages(phys_to_virt(phys), 1);
> +
> +	return phys;
> +}
> +
>   static int free_delegated_page(phys_addr_t phys)
>   {
>   	if (WARN_ON(undelegate_page(phys))) {
> @@ -271,6 +353,32 @@ static void free_rtt(phys_addr_t phys)
>   	kvm_account_pgtable_pages(phys_to_virt(phys), -1);
>   }
>   
> +static int realm_rtt_create(struct realm *realm,
> +			    unsigned long addr,
> +			    int level,
> +			    phys_addr_t phys)
> +{
> +	addr = ALIGN_DOWN(addr, rmi_rtt_level_mapsize(level - 1));
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
> +	addr = ALIGN_DOWN(addr, rmi_rtt_level_mapsize(level - 1));
> +	ret = rmi_rtt_fold(virt_to_phys(realm->rd), addr, level, &out_rtt);
> +
> +	if (rtt_granule)
> +		*rtt_granule = out_rtt;
> +
> +	return ret;
> +}
> +
>   static int realm_rtt_destroy(struct realm *realm, unsigned long addr,
>   			     int level, phys_addr_t *rtt_granule,
>   			     unsigned long *next_addr)
> @@ -286,6 +394,38 @@ static int realm_rtt_destroy(struct realm *realm, unsigned long addr,
>   	return ret;
>   }
>   
> +static int realm_create_rtt_levels(struct realm *realm,
> +				   unsigned long ipa,
> +				   int level,
> +				   int max_level,
> +				   struct kvm_mmu_memory_cache *mc)
> +{
> +	while (level++ < max_level) {
> +		phys_addr_t rtt = alloc_rtt(mc);
> +		int ret;
> +
> +		if (rtt == PHYS_ADDR_MAX)
> +			return -ENOMEM;
> +
> +		ret = realm_rtt_create(realm, ipa, level, rtt);
> +		if (RMI_RETURN_STATUS(ret) == RMI_ERROR_RTT &&
> +		    RMI_RETURN_INDEX(ret) == level - 1) {
> +			/* The RTT already exists, continue */
> +			free_rtt(rtt);
> +			continue;
> +		}
> +
> +		if (ret) {
> +			WARN(1, "Failed to create RTT at level %d: %d\n",
> +			     level, ret);
> +			free_rtt(rtt);
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
> @@ -380,6 +520,62 @@ static int realm_tear_down_rtt_range(struct realm *realm,
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
> +		ret = realm_rtt_fold(realm, align_addr, level, &rtt_granule);
> +
> +		switch (RMI_RETURN_STATUS(ret)) {
> +		case RMI_SUCCESS:
> +			free_rtt(rtt_granule);
> +			break;
> +		case RMI_ERROR_RTT:
> +			if (level == RMM_RTT_MAX_LEVEL ||
> +			    RMI_RETURN_INDEX(ret) < level) {
> +				not_folded++;
> +				break;
> +			}
> +			/* Recurse a level deeper */
> +			ret = realm_fold_rtt_level(realm,
> +						   level + 1,
> +						   addr,
> +						   next_addr);
> +			if (ret < 0) {
> +				return ret;
> +			} else if (ret == 0) {
> +				/* Try again at this level */
> +				next_addr = addr;
> +			}
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
>   void kvm_realm_destroy_rtts(struct kvm *kvm)
>   {
>   	struct realm *realm = &kvm->arch.realm;
> @@ -388,12 +584,272 @@ void kvm_realm_destroy_rtts(struct kvm *kvm)
>   	WARN_ON(realm_tear_down_rtt_range(realm, 0, (1UL << ia_bits)));
>   }
>   
> +static void realm_unmap_shared_range(struct kvm *kvm,
> +				     int level,
> +				     unsigned long start,
> +				     unsigned long end,
> +				     bool may_block)
> +{
> +	struct realm *realm = &kvm->arch.realm;
> +	unsigned long rd = virt_to_phys(realm->rd);
> +	ssize_t map_size = rmi_rtt_level_mapsize(level);
> +	unsigned long next_addr, addr;
> +	unsigned long shared_bit = BIT(realm->ia_bits - 1);
> +
> +	if (WARN_ON(level > RMM_RTT_MAX_LEVEL))
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
> +			realm_unmap_shared_range(kvm, level + 1, addr,
> +						 min(next_addr, end),
> +						 may_block);
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
> +				realm_unmap_shared_range(kvm, level + 1, addr,
> +							 next_addr,
> +							 may_block);
> +			}
> +			break;
> +		default:
> +			WARN_ON(1);
> +			return;
> +		}
> +
> +		if (may_block)
> +			cond_resched_rwlock_write(&kvm->mmu_lock);
> +	}
> +
> +	realm_fold_rtt_level(realm, get_start_level(realm) + 1,
> +			     start, end);
> +}
> +
> +static void realm_unmap_private_range(struct kvm *kvm,
> +				      unsigned long start,
> +				      unsigned long end,
> +				      bool may_block)
> +{
> +	struct realm *realm = &kvm->arch.realm;
> +	unsigned long rd = virt_to_phys(realm->rd);
> +	unsigned long next_addr, addr;
> +	int ret;
> +
> +	for (addr = start; addr < end; addr = next_addr) {
> +		unsigned long out_range;
> +		unsigned long flags = RMI_ADDR_TYPE_SINGLE;
> +		/* TODO: Optimise using RMI_ADDR_TYPE_LIST */
> +
> +retry:
> +		ret = rmi_rtt_data_unmap(rd, addr, end, flags, 0,
> +					 &next_addr, &out_range, NULL);
> +
> +		if (RMI_RETURN_STATUS(ret) == RMI_ERROR_RTT) {
> +			phys_addr_t rtt;
> +
> +			if (next_addr > addr)
> +				continue; /* UNASSIGNED */
> +
> +			rtt = alloc_rtt(NULL);
> +			if (WARN_ON(rtt == PHYS_ADDR_MAX))
> +				return;
> +			ret = realm_rtt_create(realm, addr,
> +					       RMI_RETURN_INDEX(ret) + 1, rtt);
> +			if (WARN_ON(ret)) {
> +				free_rtt(rtt);
> +				return;
> +			}
> +			goto retry;
> +		} else if (WARN_ON(ret)) {
> +			continue;
> +		}
> +
> +		ret = undelegate_range_desc(out_range);
> +		if (WARN_ON(ret))
> +			break;
> +
> +		if (may_block)
> +			cond_resched_rwlock_write(&kvm->mmu_lock);
> +	}
> +
> +	realm_fold_rtt_level(realm, get_start_level(realm) + 1,
> +			     start, end);
> +}
> +
> +void kvm_realm_unmap_range(struct kvm *kvm, unsigned long start,
> +			   unsigned long size, bool unmap_private,
> +			   bool may_block)
> +{
> +	unsigned long end = start + size;
> +	struct realm *realm = &kvm->arch.realm;
> +
> +	if (!kvm_realm_is_created(kvm))
> +		return;
> +
> +	end = min(BIT(realm->ia_bits - 1), end);
> +
> +	realm_unmap_shared_range(kvm, find_map_level(realm, start, end),
> +				 start, end, may_block);
> +	if (unmap_private)
> +		realm_unmap_private_range(kvm, start, end, may_block);
> +}
> +
> +enum ripas_action {
> +	RIPAS_INIT,
> +	RIPAS_SET,
> +};
> +
> +static int ripas_change(struct kvm *kvm,
> +			struct kvm_vcpu *vcpu,
> +			unsigned long ipa,
> +			unsigned long end,
> +			enum ripas_action action,
> +			unsigned long *top_ipa)
> +{
> +	struct realm *realm = &kvm->arch.realm;
> +	phys_addr_t rd_phys = virt_to_phys(realm->rd);
> +	phys_addr_t rec_phys;
> +	struct kvm_mmu_memory_cache *memcache = NULL;
> +	int ret = 0;
> +
> +	if (vcpu) {
> +		rec_phys = virt_to_phys(vcpu->arch.rec.rec_page);
> +		memcache = &vcpu->arch.mmu_page_cache;
> +
> +		WARN_ON(action != RIPAS_SET);
> +	} else {
> +		WARN_ON(action != RIPAS_INIT);
> +	}
> +
> +	while (ipa < end) {
> +		unsigned long next = ~0;
> +
> +		switch (action) {
> +		case RIPAS_INIT:
> +			ret = rmi_rtt_init_ripas(rd_phys, ipa, end, &next);
> +			break;
> +		case RIPAS_SET:
> +			ret = rmi_rtt_set_ripas(rd_phys, rec_phys, ipa, end,
> +						&next);
> +			break;
> +		}
> +
> +		switch (RMI_RETURN_STATUS(ret)) {
> +		case RMI_SUCCESS:
> +			ipa = next;
> +			break;
> +		case RMI_ERROR_RTT: {
> +			int err_level = RMI_RETURN_INDEX(ret);
> +			int level = find_map_level(realm, ipa, end);
> +
> +			if (err_level >= level) {
> +				/* FIXME: Ugly hack to skip regions which are
> +				 * already RIPAS_RAM
> +				 */
> +				ipa += PAGE_SIZE;
> +				break;
> +				return -EINVAL;
> +			}
> +
> +			ret = realm_create_rtt_levels(realm, ipa, err_level,
> +						      level, memcache);
> +			if (ret)
> +				return ret;
> +			/* Retry with the RTT levels in place */
> +			break;
> +		}
> +		default:
> +			WARN_ON(1);
> +			return -ENXIO;
> +		}
> +	}
> +
> +	if (top_ipa)
> +		*top_ipa = ipa;
> +
> +	return 0;
> +}
> +
> +static int realm_set_ipa_state(struct kvm_vcpu *vcpu,
> +			       unsigned long start,
> +			       unsigned long end,
> +			       unsigned long ripas,
> +			       unsigned long *top_ipa)
> +{
> +	struct kvm *kvm = vcpu->kvm;
> +	int ret = ripas_change(kvm, vcpu, start, end, RIPAS_SET, top_ipa);
> +
> +	if (ripas == RMI_EMPTY && *top_ipa != start)
> +		realm_unmap_private_range(kvm, start, *top_ipa, false);
> +
> +	return ret;
> +}
> +
>   static int realm_ensure_created(struct kvm *kvm)
>   {
>   	/* Provided in later patch */
>   	return -ENXIO;
>   }
>   
> +static void kvm_complete_ripas_change(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm *kvm = vcpu->kvm;
> +	struct realm_rec *rec = &vcpu->arch.rec;
> +	unsigned long base = rec->run->exit.ripas_base;
> +	unsigned long top = rec->run->exit.ripas_top;
> +	unsigned long ripas = rec->run->exit.ripas_value;
> +	unsigned long top_ipa;
> +	int ret;
> +
> +	do {
> +		kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_page_cache,
> +					   kvm_mmu_cache_min_pages(vcpu->arch.hw_mmu));
> +		write_lock(&kvm->mmu_lock);
> +		ret = realm_set_ipa_state(vcpu, base, top, ripas, &top_ipa);
> +		write_unlock(&kvm->mmu_lock);
> +
> +		if (WARN_RATELIMIT(ret && ret != -ENOMEM,
> +				   "Unable to satisfy RIPAS_CHANGE for %#lx - %#lx, ripas: %#lx\n",
> +				   base, top, ripas))
> +			break;
> +
> +		base = top_ipa;
> +	} while (base < top);
> +
> +	/*
> +	 * If this function is called again before the REC_ENTER call then
> +	 * avoid calling realm_set_ipa_state() again by changing to the value
> +	 * of ripas_base for the part that has already been covered. The RMM
> +	 * ignores the contains of the rec_exit structure so this doesn't
> +	 * affect the RMM.
> +	 */
> +	rec->run->exit.ripas_base = base;
> +}
> +
>   /*
>    * kvm_rec_pre_enter - Complete operations before entering a REC
>    *
> @@ -419,6 +875,9 @@ int kvm_rec_pre_enter(struct kvm_vcpu *vcpu)
>   		for (int i = 0; i < REC_RUN_GPRS; i++)
>   			rec->run->enter.gprs[i] = vcpu_get_reg(vcpu, i);
>   		break;
> +	case RMI_EXIT_RIPAS_CHANGE:
> +		kvm_complete_ripas_change(vcpu);
> +		break;
>   	}
>   
>   	return 1;

