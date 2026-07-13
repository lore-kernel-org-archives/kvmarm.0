Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013045.outbound.protection.outlook.com [40.107.162.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38A0B40BCB4
	for <kvmarm@lists.linux.dev>; Mon, 13 Jul 2026 14:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.45
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783951994; cv=fail; b=ItMEzyFPTppMt6KEuUxsLgYD5MGhvk5h128fe4UnzZJsHoYp/3P7UytwKDsMb2zhqpuSclmJgLtyYRRwXvCVk31ciehBNnT93Qsq8FDlJeB0Vwt0AcoZhb96/TveSJC8Ywe+SpTYDy3JiWwEl3SxccFxPo/Nq59FYO2uSFEw7Kk=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783951994; c=relaxed/simple;
	bh=PVY6idulC9ySkzgqO2vh1LzkMPdjsUPW2C7yIbX6t9U=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=XwUU7+oBcfe3zvGXOs/26sndTxyzgTYQCpGeyPUnLnhEQ3OzdwriVLW1Bu8ViO0xS6TaukkrsBVJcBvekLWVpiViaLQE4YHQLNckQgjfBmMZ/CBKe7klqEQPd2VVyiIbTfed6arH3eYhhrjrsZqFx/RLrY6c1FX1AA0CO9/0t30=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=NEF3w2tW; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=NEF3w2tW; arc=fail smtp.client-ip=40.107.162.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="NEF3w2tW";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="NEF3w2tW"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=YgUnwYgbr0Qgr/riqqPVuvIXywY9VyxWuAuOx+jAKB2Rvzp95NNmmluNQL/6LLf445N+arzESuCezImChlRuddmlrilQtZagI6CwhdVPR60a8WQKasaI517jck5z9Cucg1tDxeSXEh0y8jYh2i0Qe862l892Hkv1ljAS94IpkqsO6xylOc4Ii9ujcivWERrHzhFyjvlgwrE3TOS0qbCDUZGG28uvc67UmfOBWNPyZtQ8wGpBwajgwR3wKmtngHji0eZdOb+2k5GwcEfOuwv3b4cusmE5s8Pt4u+NvMuQufap7oWxUw6duId4b1XFnUgQGr43ASwR0AFGMpGgnNHNiQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UQiYx55vC9XfJxGoP3Udp0jr9uYMdNbN7ClF6rp4mGY=;
 b=wmhLpimJ7ScyRxNsSOEoOjwhc04m9aT0qfTAg0H3AFXHYAIEbjk6mxun/Vs/Ut7sfTMVk6q6RimhNUS+/1iaU70JUucWGKRs/1Y5iSoTCZ6GzQh23/M7Kejk+bhjXdfErOgNFplvJUYekphPrd57xbyBP0jusT/KhMuHZI8hWbxOczR+LY+PkYUciERN2UAh/IV0GRE3LvAyTN5l6h2IgAuiublGGhI7DWwbkp75oTI73IEQchI2GYX0g3ENd2PLaNNUQL4N7XCpXVXMFwVp9uSqfclBeGYjfJIGarCSvz4Ky3MNiO6nmW8xLBCVSxQnW9qkzVOfrQCZOs+g1oveFg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=google.com smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UQiYx55vC9XfJxGoP3Udp0jr9uYMdNbN7ClF6rp4mGY=;
 b=NEF3w2tWb3TIw2rhRu8focHTrMfQ2l7DztV/XY6nBps8g3iBN9SVCUrCtIUOTnN6ZYawepp7NQHSz0OsxgtsNdlOrZg2GjRZbOrga9bBKEt9F2SXK7NK7Ek5c3prGrVq4SOdIvGmj0U3MeOCzSDsJc4J7ldq2CTvVzF0it5E87c=
Received: from DB8PR04CA0009.eurprd04.prod.outlook.com (2603:10a6:10:110::19)
 by PA1PR08MB11238.eurprd08.prod.outlook.com (2603:10a6:102:4df::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.202.18; Mon, 13 Jul
 2026 14:13:04 +0000
Received: from DU6PEPF0000A7E4.eurprd02.prod.outlook.com
 (2603:10a6:10:110:cafe::88) by DB8PR04CA0009.outlook.office365.com
 (2603:10a6:10:110::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.202.19 via Frontend Transport; Mon,
 13 Jul 2026 14:13:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU6PEPF0000A7E4.mail.protection.outlook.com (10.167.8.43) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.223.9 via
 Frontend Transport; Mon, 13 Jul 2026 14:13:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QUYHqOlg6i+EEeWCF2UW/KyUA/5zUPV/muAloPoCwLn/GgidcF8pakdzSEhDlslxTQ6ngnFAwYBhBCpD9QiGiRc71pII+3Ruu66uN1Hoj+pU4pLg4JoESn3HeyUKy5C4+9yVn5MqKRHKdR21EQQgDW5MjtfNuEQQ7CKR8QBe6MaCJNwzAJjydzWGBQCnYxmT6xFtNq5YMgs4w1C8a5xi1/QWUgLW2xobddgJ6TbvqEA7/gO1UYxpR9Pnaex1G9s7KeYDW7rYQ8TFsVC/NfiQyx4w2X2s2OQ4b3bw2rGxm90001Kz7IUGEZziHP3F802GSvXFE7HOiVi6OcZVgwznOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UQiYx55vC9XfJxGoP3Udp0jr9uYMdNbN7ClF6rp4mGY=;
 b=kptmTZp9g6s6wsbeK5UCUaOY41X+B7CpKwxvyAzF9AlmUjNmtQanD0Lej1h+lZ6PblOhfOWV3gYiGOzJEjCCXasa9uSiNp0oSQiJvK/TL4r4mq6y1I1exZTV1XdBjhX1NBfLnwzp0OhNFxfCuIf5EwDbsfSBUsYpY8XdNU5/M4D5IJprb3PwPYIgWTQ5bayoeVU1SND4pZ6Pp680PSo3Fn6bsT/bRmomd6D6TuKsEpz3JMdbJzgvcSMZ0vw7vn5b8GjB1aTdC10bDRceSBZFgWhRUzKMKp/q+PyZwD5pwC68R79BiyMNwhCobOODFc1sPQI69Oxm00C7HnpSMeFh5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UQiYx55vC9XfJxGoP3Udp0jr9uYMdNbN7ClF6rp4mGY=;
 b=NEF3w2tWb3TIw2rhRu8focHTrMfQ2l7DztV/XY6nBps8g3iBN9SVCUrCtIUOTnN6ZYawepp7NQHSz0OsxgtsNdlOrZg2GjRZbOrga9bBKEt9F2SXK7NK7Ek5c3prGrVq4SOdIvGmj0U3MeOCzSDsJc4J7ldq2CTvVzF0it5E87c=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from AS8PR08MB9597.eurprd08.prod.outlook.com (2603:10a6:20b:61b::18)
 by VI1PR08MB10145.eurprd08.prod.outlook.com (2603:10a6:800:1ca::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.202.18; Mon, 13 Jul
 2026 14:11:58 +0000
Received: from AS8PR08MB9597.eurprd08.prod.outlook.com
 ([fe80::e11:42b9:2ed1:ef5f]) by AS8PR08MB9597.eurprd08.prod.outlook.com
 ([fe80::e11:42b9:2ed1:ef5f%4]) with mapi id 15.21.0202.018; Mon, 13 Jul 2026
 14:11:58 +0000
Message-ID: <a127176a-1722-460c-aa84-754e1d343f53@arm.com>
Date: Mon, 13 Jul 2026 16:11:57 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/3] KVM: Dirty page logging for guest_memfd-only
 memslots
To: Mark Rutland <mark.rutland@arm.com>,
 Sean Christopherson <seanjc@google.com>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>, pbonzini@redhat.com,
 kvm@vger.kernel.org, maz@kernel.org, oupton@kernel.org, joey.gouly@arm.com,
 seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 fuad.tabba@linux.dev
References: <20260702142912.6395-1-alexandru.elisei@arm.com>
 <akxOrMnlNga-vtQv@google.com> <ak0wSQ1133O7B96D@raptor>
 <ak0ziUcCXUlDdcla@google.com> <ak-EKSslAz1uqEtv@J2N7QTR9R3>
 <ak_wC4Q-mQe14DI8@google.com> <alDI1b8fC99SG4_a@J2N7QTR9R3>
From: David Hildenbrand <david.hildenbrand@arm.com>
Content-Language: en-US
Autocrypt: addr=david.hildenbrand@arm.com; keydata=
 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 fa0=
In-Reply-To: <alDI1b8fC99SG4_a@J2N7QTR9R3>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0542.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:319::7) To AS8PR08MB9597.eurprd08.prod.outlook.com
 (2603:10a6:20b:61b::18)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	AS8PR08MB9597:EE_|VI1PR08MB10145:EE_|DU6PEPF0000A7E4:EE_|PA1PR08MB11238:EE_
X-MS-Office365-Filtering-Correlation-Id: 3a998c0d-11b3-4307-3331-08dee0e8dabc
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|1800799024|376014|7416014|23010399003|22082099003|18002099003|56012099006|4143699003|5023799004|11063799006;
X-Microsoft-Antispam-Message-Info-Original:
 td2elnz5xVN0XzPrpkSccUDwBENl8x8pNope14Zd3WL5ny5T9uJz3TVXpmZT9tHAnUugpP8GnBbKUZ0LdvEBZSO0tD90zLOXHFrgozjfEEBoKHCI5v0fq8o6gHmbH5yQWuowY0sWjVrfF6y+PChDLuCIeT1iQ2rDpIMsqbDtD253othzAIqRuR/dPlio8BBNXaAI39CpwoB7z07oKwX2LOa0gFEAtl3jHTofgF5+I88SOTg68ORZC/VwDOBA93P9MTY78OKEVc/G2i5/lDijNQHUTZlvx2hUIky2KKZek1fNVVJDIno+cFGTVQavGeD/bRep5insJUqXoIsTRds0oXk7QNvliXVu7KJjjqKhqDlOu0fbt/2FwOmS7U/9oD+9ag5vVEyNHwb1PemuzElNxNUBnA1PpaJsmp5kpJxIF0vVC67oNuHIoeWJ69ny7ArSyAuHpYo76DuKGY/aQ+3Atb5IEc4rwWW0tDe5nYGgDhZ9+qVnslQ+rIi8PU3hedpGnklbYo4ksq0mKWyi7YM1XL7e0SDuDbcPspstcZ0BjJfMlb2ml5TebCzao6hKD4M8N56Vwu14slDDnTCh7VNeUPASt1r1o7FVQ0WUjY1P6P0XjyofHmtAbN86j8Upo2bkHI3FClnZHAys9ib/rulL+5dVS4Y3/RF1DJT050YJ/yc=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR08MB9597.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(23010399003)(22082099003)(18002099003)(56012099006)(4143699003)(5023799004)(11063799006);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 mNW5yZh9Ll6AJI/TSnVBVa1mN2ysNnl0sxtJDsXWOBQv6r6xn8lAnBPxoLJIhZnvnB4NjkFeeqoFiAgOw4wKbb7ybOMjpv7MnEDzasRoZLBfJgBksqvlt1cMAGwE87aBn5B772Kxw81TlVfdUAWcrZX4EgQ1b2JkWRT8GdBlsEJeg3f1PzocvGVrq19OTMXtVZgJJyO1FExKN+dHXqTJfEZ4KRBJNFy1L5RRDNNdjYWNe+Dl3xJmLq6YBgoPbyy3X96H/K5G6QmKRytfOpwWrW/P6fndsO+R/oWBamjv2mPwRSnXQrwU6IjBy4cWs6Q5+zgJPEiLiOUw2+T6//lzQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB10145
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU6PEPF0000A7E4.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	fcd911d8-1246-44d0-261e-08dee0e8b38b
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|1800799024|7416014|36860700016|82310400026|35042699022|14060799003|11063799006|5023799004|4143699003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	l6iMEp7YgOQiLazC1biDFAtJJX2T1S3A/VpZsIJtpyyKZodha8zp1cC6P13nM46FhahiWkUss9zjdHn0xefMqJt8GxyafvctROa/ITViOqPr3zIWVvsv6cP0tNNWGh2fyWImC0XRdMmoqcC6Q830qNFaKQUkSYibhIjNBQTIL3CLS1BzQdQNnUUpUAM1m2LvnjwTROMU/iVO15rEzdbPZOXIw71GmJOrfdFgDmW98lDl/c0JWxcVOq2ODj31pQsg6zRg9HG+LvGr9XLuxh54nbqWusqfjeP0GCMk40Dm/7B2INOeS8QM7ytollz+LsQvMlun2lQ7FydvQczc8LsfiA9Kz+aTDwM4by8XoK5vvt8xgyXjwH9n2hM7wVMRpprT4CfCuwMQwh72PAO7Uwez3mpXR6Uf2E1h/sMBQYHaL8JTMtvytJ2GYbWmWTngwfYIEAarIUZ2kkUR/E9icdPJ7xOkPuSKSeKhpy941fTxspQCrmhoxlysYaRh7bhkQm/8efXHUi5qLXRMw3O4ADQMICkWMes7qt+fm+L1oIIo4JEgkK6HKhYwAhFL42H32rv05e2FUAB4Ocoh2xqcHm9nBJvVbOCNBCOO5rp5mpxVP9oVR45Z8F+oCX2U8raOqdt8roLF6gBT+OY6n24ZcO7SWCYK8KdC3jmvl8+7cKmKQYtZckfaB4fUvROx6JcMIzLAuPxH+aQjffq5HhAbsP/wfw==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(23010399003)(1800799024)(7416014)(36860700016)(82310400026)(35042699022)(14060799003)(11063799006)(5023799004)(4143699003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	eW8qPM0L5rhQJnJz49F1mCpZ7v6/yH1PQmu7IiZfxy2aD/u/kjC369JaCitCsqSesujqwggSVp0K9OGRxtFgdYhFtNkIo1CQJ2Wj1kDJZn4IQnp+qZuE6u8Oe1InxXVTbjflHROCg0rkal2gBUzGsfQpD3W97GENpomDktHFI4bVQ47+cEZWuZJKTWroyvvx4owvV7M3pLvl4HLT/lafslLBIPL/WaSrFNvpui8hhF5/0+B1FlZ3bE/yWCLe9RCFu+rG+hba+mp+N6qrQP9kS0y/ABDYPnDdWAUe+3AAkbYjwYhJtmHsUlj2X1nxlNEuYVfjlZ3+3pZlFwwwsJq1kJ3HGL4s5AI3q09G3c4ARSCpwnAS8VjzPcITDaZTZ1Y6JSCakUjwJGrx+vq1QxNP5LYSTP9gWJ9lWlOsUog2iaEXa4FCOn9LFFGPIEdjJp1N
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2026 14:13:03.9014
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a998c0d-11b3-4307-3331-08dee0e8dabc
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU6PEPF0000A7E4.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA1PR08MB11238


>> That said, odds are good that we'll end up with per-gmem flags to communicate to
>> guest_memfd whether or not the gmem instance supports page migration (x86's TDX
>> and SNP in particular require extra consideration).  So if the anticipated use
>> cases are fine with all-or-nothing "pinning", or with juggling guest_memfd files
>> in userspace if a more dynamic setup is desired, then you should be ok?
>>
>> E.g. if the anticipated use cases are all slice-of-hardware style setups where
>> the VM will be statically assigned a chunk of memory, then for the most part this
>> will all Just Work.
> 
> Yeah. I agree (with the caveats you mention). Arm folk need to go figure
> out if it's worthwhile to support with all those caveats.

Right, disabling migration (once gmem supports it) was also what I discussed
with Alexandru when that topic comes up.

How to communicate to gmem that it wants these fixed mappings is a good question.

-- 
Cheers,

David
