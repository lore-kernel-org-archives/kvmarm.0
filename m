Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013015.outbound.protection.outlook.com [40.107.162.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21C9B42CAE9
	for <kvmarm@lists.linux.dev>; Mon,  6 Jul 2026 12:36:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.15
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783341365; cv=fail; b=Bgc5GJxRqwE9w3wOtkkjVbOXzhcB81QR9uDyKNACVik+vSOXsHhMfVxlP5f5umUIo94z2EEvILqOTUjoBP07sCsFnEGxl9dkd66P5QGm7veymhZQJGnNomFSSadriwF+wKYBv4kzIDwmcDPUEUQ5QRx958NGoOOIi+BITueFZYc=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783341365; c=relaxed/simple;
	bh=idPX1Xr8TCu7Jp7nLT+qLzF1xYM9rpBPQ7rFOVemC6w=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=r9XV3+N0wfDFedsjzfpTfFDIuyQ4x7kYaSThaF3cr7Rb5AC0dz847seNfdVQWrwMQObUTVG0arFiSTHzBnfFx2CyLYuH/3FjByn1OtnA73+9/OIBSGbOG2UBh7fH7meJyREoYL6lRoeI42mqZ/uRxpvRzp5/+Vo2ba7WZqe2C6I=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=EScEk+zA; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=EScEk+zA; arc=fail smtp.client-ip=40.107.162.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="EScEk+zA";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="EScEk+zA"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=ywmbEi5KyYdZoklgPCn/EMoyQejSBkKr6FKPui8XWarX3G9tf0N5hXPdQOCiNiWBDqnQo6Xc6oCNlKqmAzx4ar0fTm8fIaDp8VgYl59NjsW5ecFkaZjBZMOvX4bNTcMzt9eVl8U3Q5tNoaE7ZTYEnygcwqWJ+qbPBnPF7GjGJxivXixPEHqC6SpSbM+1bmxjoOotV1+mcRtNRyqVHDM2djqWpKw/NEADTaG3VLUI+KVvgtfe7KjT8Rk+FGK/5vau4pvVNznsSznF4qOg2Cz2m0ZLWpWBqWtH3T5Ebz7Lv8Br0kdZwsq+LQH0FMI4D715WEAn3AOS/P5CTM0CcMPgXg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iFTcwv23aercn4Rt3AJiwkkXmJUeLE3KAEWKV9k4IJE=;
 b=hGMAAv+N66j2ufW/4s0jxSpHqh0iJOcK2C2pBWJP4+nibmuPI5mJwiGVyVRerm2lvv8J688blu9QToL6VjAgaoT8PvuuUa9BX6mhSh1ANeYTzpcYypU4WW6abz2dMgS3UoYllq1Smk0ySzNmIGHdl6Yb+2TGJaVkaT+4slDFYNvyrdow2NVZJzqIHXr0uAm7nQbNPwO3UWMm6jDzzETfzBHWmquCFtNvFJjp3Nsvd5aJ5KLPzQRNhIOXgnvE+GI9pN1MT9tK1Ou3AAX+604uXr9jMZRqHA2Vata+Ke30qYRVMbepNbUaHSj8o6zHSko6LjuuHwAV1DBSWuWzfwvqsA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=linux.dev smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iFTcwv23aercn4Rt3AJiwkkXmJUeLE3KAEWKV9k4IJE=;
 b=EScEk+zA5HtUU3fdmf+RMNH92mX3sXpbyJHQHhtaOR7jbOct35907d8OyStrpUxW7wBNfxD0Ys2MFzMShYKg3dAtFmuq2p6K5mARcHmdGYBEc+Vz+rC9w56mR4QrgsfGeKVymBbAcnWzuoeL++a9Otqh4bZlPt3glwXThonQ8ZE=
Received: from DU2PR04CA0356.eurprd04.prod.outlook.com (2603:10a6:10:2b4::14)
 by PA6PR08MB10816.eurprd08.prod.outlook.com (2603:10a6:102:3d9::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.9; Mon, 6 Jul 2026
 12:35:51 +0000
Received: from DB3PEPF0000885B.eurprd02.prod.outlook.com
 (2603:10a6:10:2b4:cafe::4e) by DU2PR04CA0356.outlook.office365.com
 (2603:10a6:10:2b4::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.13 via Frontend Transport; Mon, 6
 Jul 2026 12:35:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB3PEPF0000885B.mail.protection.outlook.com (10.167.242.6) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.6
 via Frontend Transport; Mon, 6 Jul 2026 12:35:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qGGePKH10nWYXtm2lwPiTX+JQo8geYZKs7ZEClmPgSzv6qwJtVIzqiW0+G6sKqxVPQBJ0NYOlfk0FFu3FjjotMdnzJkeNf+dD7lM7Le8/i958vhFcarL+b6sDe9uwnySlgP0ye5GJwZcaXjkcAsF6VtsRHI4WHGin5OpwPfqL7U5I6CNboHnu+ZASdKdn3GmaYv88AOSD1GBKJaH8eGlynxEiy6lWycvIyN7Z+XDMQJkqGFUmalAL5A/WWjk+7a2NR3tFFENPBZRHteeeCwpOqiw6I+tPnf06LY6r1XCaB38U8BgvV9k/OObpzMoQfluFQI95C7+OXrq/LAkE65mgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iFTcwv23aercn4Rt3AJiwkkXmJUeLE3KAEWKV9k4IJE=;
 b=Uc5Z6b5VRvQPMvpg06bAJ1AQnNn2vCkP/QmSBLpvg40cTY2JX/ymsbjVykGGfYSSHb4TbC2on3lJzH52WALfhcZVZ5X3tBgZlwLyJE1AUN+vzOSY6UbqiYKfF/SFDt7aX293yHH29emUT6OUqTGxJtXMwcUSU7p5HLpPgwkFiU8FO/o1YtLOfB6hjMXKEsK6Wr0QWnX01IJTuolpuWvYYP0TIpsKI5YrCGg5wHtN/SbJAq00USK77bFuF67DhthRjIUa+ETAhA7fFf3P9+nf3IdKirodSWvVJ8PcMZ70QVd+OvrtBqSs1sJSSfXAGrSRPdMDEKceSB5m4g2JSzBAlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iFTcwv23aercn4Rt3AJiwkkXmJUeLE3KAEWKV9k4IJE=;
 b=EScEk+zA5HtUU3fdmf+RMNH92mX3sXpbyJHQHhtaOR7jbOct35907d8OyStrpUxW7wBNfxD0Ys2MFzMShYKg3dAtFmuq2p6K5mARcHmdGYBEc+Vz+rC9w56mR4QrgsfGeKVymBbAcnWzuoeL++a9Otqh4bZlPt3glwXThonQ8ZE=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from PAWPR08MB10975.eurprd08.prod.outlook.com (2603:10a6:102:46e::7)
 by DU0PR08MB9933.eurprd08.prod.outlook.com (2603:10a6:10:413::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.9; Mon, 6 Jul 2026
 12:34:40 +0000
Received: from PAWPR08MB10975.eurprd08.prod.outlook.com
 ([fe80::3c7a:9a64:14bc:ce15]) by PAWPR08MB10975.eurprd08.prod.outlook.com
 ([fe80::3c7a:9a64:14bc:ce15%7]) with mapi id 15.21.0181.009; Mon, 6 Jul 2026
 12:34:40 +0000
Message-ID: <5992165b-e4d8-4600-9aad-93bfff401e5a@arm.com>
Date: Mon, 6 Jul 2026 13:34:39 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH kvmtool v1 4/5] Add guest_memfd support to
 kvm__register_mem()
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, Will Deacon
 <will@kernel.org>, Alexandru Elisei <alexandru.elisei@arm.com>,
 Andre Przywara <andre.przywara@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>
References: <20260706083555.302972-1-fuad.tabba@linux.dev>
 <20260706083555.302972-5-fuad.tabba@linux.dev>
 <5a699a28-07ce-4a6c-bc41-8b9bc7ca0d4a@arm.com>
 <ab60e6a1-e59a-4089-a6d4-386b83627b87@arm.com>
 <CA+EHjTxh0rbuOA+Ar4kzYUNOETf9kJ0p2c-Kz9xQOJTkCYNz+Q@mail.gmail.com>
Content-Language: en-US
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <CA+EHjTxh0rbuOA+Ar4kzYUNOETf9kJ0p2c-Kz9xQOJTkCYNz+Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: LO4P123CA0408.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:189::17) To PAWPR08MB10975.eurprd08.prod.outlook.com
 (2603:10a6:102:46e::7)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	PAWPR08MB10975:EE_|DU0PR08MB9933:EE_|DB3PEPF0000885B:EE_|PA6PR08MB10816:EE_
X-MS-Office365-Filtering-Correlation-Id: 1b30126a-d497-4a63-6b20-08dedb5b1d44
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|23010399003|366016|376014|1800799024|4143699003|11063799006|56012099006|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info-Original:
 b32rUQsz4o5gVrUmE/eq4VCwaEZbqJ4L+6dhYRUGK6dKeV5bQ6YVOcHj0tBgQKPgY0d+J5ESkA8fTFHNSxpecSTlXTg3yP9etjugnk0NjxUnDRt9Zoxu6+oDT9rQCq2WEIKEMBGsx0IWGuGSQmR5Wu6iYDWxPTOunUh8A/Kh4NM4I+bv5JMMb5E+VmHSC1WU90wNSWbu55+DAkq3rD0yup+CIA1aSPEX3TzB+ePUl8f37PY/52z/v2NNdP/C9GhagTYGzoQmy5lD2d6VMsizA1rL2BhS9dQjzauLI9OOL2HCY9Is01deX0QCm/VJc6Mz+ESEcGyRZj35sKIGUKvdeZlLYWrcrmArSjxcrMgddnPEWE88aSekuU8bQvP1zb+KXrShn/9nwq4eVfn2RFgbqJzc5WdKgoakATCv76ssng49wIRwRsbkCcKCQ2muqiFVmMcphEYoHWzyCN0tWOLVOZprAqhWvXri0tlaCmkD9i28ryD/ScYltDJ1YI2VmKrextfhJkedharUuTDrEAeoMc23Klh0is3XmsMjOES28u3pxTk1GtO99fai+VeAYLN8JxbV6ILMmGnrFc9UqP+w8jdalj52gN/6gbDQ5AeGaLDrLZO8XDAcOVjl7IWEAhol7M0NzksR6yqIQo2FOXmyZItnPEFaqJTZn/0YjIfJLrQ=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAWPR08MB10975.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(376014)(1800799024)(4143699003)(11063799006)(56012099006)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 LL4O606RwhUf95kGqWaI1B10GwIAdSKYeUaZG7CRD9v5zIpqBGgdcAPpBabCRPvg+V2P3M6+lExo2Mf/ktFx6e6swDmzvBxZ5kx45Bt0xOeTGF3/9wY3vusMYA1J77eN19+koq2iXaOIpbI7FtG2AIL+A6esBkl6neuCMXt3jL/g057yF9lb3V8ZizYVhLV6kI5XGA9xLT/2Y8CwxfFV5lb45bfxtXIBdaAWxC/xWgb/hV8CqLGdF0V8u4jMMGDHTA7V9gy3cc9GBzGuASJjYrK0Fzp6GRMtSf04O8ivDwa0uqZ1YPd/iFA3v0uj/og2i4QKvD3frHcz+U7cUN4Jyg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB9933
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB3PEPF0000885B.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	ecba3ab1-64d0-4194-9bbc-08dedb5af314
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|23010399003|14060799003|35042699022|1800799024|36860700016|6133799003|4143699003|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	3jSEfaztJKSpEMD6gNSx64DIJuMBuEsVVG3UrRWUoPWg4zIkh0DQDveVb76NmzymjkTyIyrA8NiHyhG2nkjPU/uMiEaH+KRyUrPAFhHRP1uLIl8P44j86ERJT5tfrhnkVSZq1nXG2IbVsL3PCHhG4KZiqTsxwm+6IbeIibdE45/eerbljWOsIgY1H0lB8kCgS7S12AXfgE0HnUNazrql2cawxpfRnxVwjYDwtv9OnOMm/DCpZMkYVkx+ZocyrGNw5TrpOMgK17Rj/TLqvI4ym/IKCjBCaXYMv+bbUgpn9sIGdohHNpjrFNSJbtScMZWF/YaFOpfg5946H+5vxnluyRmTBOi86LFFrkTxxfbWwWexfaDCTBmUmFOl81FyMHcafyEBWXiLpFYoZ3zCtBK6j7RDFLsK9GRdkZrE2tJDObAh9nfMD1tLE0Tv5A4KzelgtY/I8U0RufZZ7SI4SGQGBemKq9cArTTNy16Rjh6nyAJ96/eVHMe5/pkhv+oyhkb00Xk6TbtczSWHu3+JDD60z7woKE/of1SAZsvpjjW7Gg21YMJ0DoBs2n6eaFqUpUqdxqYVIDdx1+8blkkaac5ZdSYRkvH+y1Uh2zI+9yddy+SpRwYoZ2yQXs8A07Fl+QJAbwgrjJMe+VWug5QIKbqvVn1MGN3d5LWyW6i7qHrEnpg7+NjNWKPtD/4L2jCj3OStUKo6Uha2YeVcLwCFxn7aHQ==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(23010399003)(14060799003)(35042699022)(1800799024)(36860700016)(6133799003)(4143699003)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	8HTWxBqQlCTbOAVLBmwcOERYIkI46swzgrhkRlXJg/guOIjjFj9VbIMi3XgM+Sxy2VNVulUWpoi2S7aZVR7QhAX5D9jkdG1+MPGs1WVSDqeXvgQnEowVmA7p6DhNZ1ZHhQWAca3Kj7yPUw+nwcyZ3d++DVl0/n4w1u0uQIq7RyFyhg2z1RRTKdufOYvb+TZg21O2hC2RVMMV0TqE/SGEAyKfHXlAmljujOpgqjtneVdzP2f9Y5fkfXUOEGuMFkJbHcatJlJVFFT2BBh0n/XuvPIBYzPZDXzu73lVpa5WAxZchZYMDm5jnIKIL39xqWaiRvU0/BhRC1iE+L6RJ9tE8Oqvlv4FyVKbc/JIETc/YImBV9hGCSZ/uE1U6o8ck4k26XYVpLwDGVcJ6LXpkoHLEP7s1NCaYn8Pah4bZT7Jjn6lelPm4tLp8I0+b6NBaKHr
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jul 2026 12:35:51.1740
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b30126a-d497-4a63-6b20-08dedb5b1d44
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB3PEPF0000885B.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA6PR08MB10816

On 06/07/2026 12:25, Fuad Tabba wrote:
> On Mon, 6 Jul 2026 at 12:14, Suzuki K Poulose <suzuki.poulose@arm.com> wr=
ote:
>>

>>>> +
>>>>            ret =3D ioctl(kvm->vm_fd, KVM_SET_USER_MEMORY_REGION2, &mem=
);
>>>>            if (ret < 0) {
>>>>                ret =3D -errno;
>>>
>>
>> IMPORTANT NOTICE: The contents of this email and any attachments are con=
fidential and may also be privileged. If you are not the intended recipient=
, please notify the sender immediately and do not disclose the contents to =
any other person, use it for any purpose, or store or copy the information =
in any medium. Thank you.

Sorry about this^, hopefully I have fixed this now :-(

Suzuki
IMPORTANT NOTICE: The contents of this email and any attachments are confid=
ential and may also be privileged. If you are not the intended recipient, p=
lease notify the sender immediately and do not disclose the contents to any=
 other person, use it for any purpose, or store or copy the information in =
any medium. Thank you.
