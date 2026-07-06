Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010065.outbound.protection.outlook.com [52.101.84.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B24223812D2
	for <kvmarm@lists.linux.dev>; Mon,  6 Jul 2026 10:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.65
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783335275; cv=fail; b=PFe+2wFMByD+iEQgxbc0PzzckBW2su61xPXr7ikuMGjmC3DHXh9wQTl+vEY7+5xQz1gKzTqM8ANGTJbCnQVi7I0ZEap7TMpHnLS3CZC4dZpLVDu2z3XclBHzI21Ucbr/pUBfEumYReiWkCfdHDcdpV2dtGoHYoVvc4+opineXZI=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783335275; c=relaxed/simple;
	bh=2qD0jDHEoVYlZDINPZKcvSDyQnHtabtS+GPp/U8VY+Y=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=VOWHQU6oyZYDhkLltSrSqC4Ysp+NoXhMJeD7itJpminI17gNVKtbTPZDgzNGV2T/Kb3u/qRaMwxr81myhr7/br5pqFnYmMkAH7xpKlM19A5f9zx9EvQBHMaDHLZoC6A0Hb8nX0L/GZnqeNEYoUiAKktPb58shQBrhfX0suyuOh0=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ph9HUKut; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ph9HUKut; arc=fail smtp.client-ip=52.101.84.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ph9HUKut";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ph9HUKut"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=bmfNCmGijFRuK0zIXeYu9oP21ITzfwsIDaeMQjbwH0l3Dk7dL1exkTDxSUAIWoHY5e58fPkLVgIwFsO4wvyVZJ019boO1qF9nOCVtok2GpOnwHTLF9VlsLWtTFRkL2AtPzy/ifA6hTyFWIcjqfo1z+RscuPJPbp5iV6280QJZrka1bgZyrLicrOzms8IUZaa7E8Y/OBJgxudHaRoxKVnkBBJyKCmjcOcSdX8Z/blnbRuyGbgJZaZtHncgTXYPOX7VrTGhkpOfpMVEdyKb2W5uqbr7sQ7FTfp350fuLIWJZJAGucrG3csEoNCQqLihS3NIoXVv29xth9h1rLUYp6zzw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QdSQ+lFNcl0eNPKO3z4UU9Lsr+lORqCrWyx00cv0yQU=;
 b=vqU+XJux9psNBX7kkWzhwBL8i4RYO+rls7iJXcAKq9Z4Wxa29a4qJpabi/89CcYn2vH7B1Toc+xwCD3Y5k31btfL5nbH6jjxI/IG8+8ZZqVlaSe0g4H1dSwQGbeqktBFDFM9CRTUqGasPGVCfoNM4t22tSwRX2uKUXoZBe8RT0Gcu+SZ6/88gNw99JuCRtfGpMwUe1HMhkQd7TMNlIMF8hjc4wgZrRGLsqG2ChmPPWRWBgYlpslGuoem8L13GCrLI7+Q9szMtVT4xKeJQfuKEocRo24O1+5TLrT2MciX6AUrpZsx3tUNgNw8ErOQC587sah8h2ECo6unaMSqlAZ8nw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=linux.dev smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QdSQ+lFNcl0eNPKO3z4UU9Lsr+lORqCrWyx00cv0yQU=;
 b=ph9HUKutWfVREddMoAJeVAJ0KZ7aHIBUdgjq2ZYgog4n+HtTCAlOlLNR/c6YJZsTZ2Z9ukTHnD7rwG33y/ZfQT5UNK8onEfPaTIyz759GYPSoxYKpLg+MmIuJaYnfvbegyyXJOF+Age8dTAt7KjHy6Zd2eaUhQDvGvV1u8fDrdE=
Received: from AS9PR05CA0226.eurprd05.prod.outlook.com (2603:10a6:20b:494::28)
 by PA6PR08MB10647.eurprd08.prod.outlook.com (2603:10a6:102:3c9::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.10; Mon, 6 Jul
 2026 10:54:30 +0000
Received: from AM2PEPF0001C714.eurprd05.prod.outlook.com
 (2603:10a6:20b:494:cafe::a1) by AS9PR05CA0226.outlook.office365.com
 (2603:10a6:20b:494::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.13 via Frontend Transport; Mon, 6
 Jul 2026 10:54:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM2PEPF0001C714.mail.protection.outlook.com (10.167.16.184) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.6
 via Frontend Transport; Mon, 6 Jul 2026 10:54:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fO1/+BpWg1uvSMoo9j+JXAEMFsiFfCtr1YfaybgT7I/LbalTLMgWALLb+ayTKRab4rC5sexfUdCiWUnSFfV64eWC6GkEVgfpDa8ZaMqi9ujySAml1w/8cSPlluPZ0fxFCKOvJ9KRCybZiISmKQ+VYTsjV2mslle5br8t6ltur0Q4AQ8URVFfeXCucKjpBbXVlbZTtg1xn77UVhEDntBcDud3xiaLp+BxznYLzHIbKtVyUmr4WOuOW8wzgQDiXgORw0oQ7iDPm2mrPpeHtvU1rjPI8gHsEj2rte9YGP7OUg4wOUGpzZehSw0u+wtwC2XN0hykj1eqMxa0X9Cba1SfMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QdSQ+lFNcl0eNPKO3z4UU9Lsr+lORqCrWyx00cv0yQU=;
 b=YH+F1/9sX8hYXG54DD6zb5L1yygH8W/jjOXo0BZOdyQwr8r39jOm0JUvIWX0mgLUZBrV+a4T12+bP4mj1iDcvS/q7gBOu1y5hYYHxjvE9xHT11nQRR6hD83aerZTZk827DwR7OyK5yyAQ2x/pH4VUXkCxPRtkJMievn55B7oItVjLhKCUNNaVdn3iVg6wNDXT2w81+bAhQIjdcyHXH60t2T2LzHt8a2S5pO9c7JEqNZ+dIwvVEPf35kzzQmKNw68xjVwGe0vp15ZBHMOtQuYH94+QWjZj4FVYpwc8guzH8CRV2f0+LE3eyO40idcLD84BtE77oh6C7+ehcGZxOrunQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QdSQ+lFNcl0eNPKO3z4UU9Lsr+lORqCrWyx00cv0yQU=;
 b=ph9HUKutWfVREddMoAJeVAJ0KZ7aHIBUdgjq2ZYgog4n+HtTCAlOlLNR/c6YJZsTZ2Z9ukTHnD7rwG33y/ZfQT5UNK8onEfPaTIyz759GYPSoxYKpLg+MmIuJaYnfvbegyyXJOF+Age8dTAt7KjHy6Zd2eaUhQDvGvV1u8fDrdE=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from PAWPR08MB10975.eurprd08.prod.outlook.com (2603:10a6:102:46e::7)
 by GV2PR08MB8341.eurprd08.prod.outlook.com (2603:10a6:150:bb::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.9; Mon, 6 Jul 2026
 10:53:26 +0000
Received: from PAWPR08MB10975.eurprd08.prod.outlook.com
 ([fe80::3c7a:9a64:14bc:ce15]) by PAWPR08MB10975.eurprd08.prod.outlook.com
 ([fe80::3c7a:9a64:14bc:ce15%7]) with mapi id 15.21.0181.009; Mon, 6 Jul 2026
 10:53:26 +0000
Message-ID: <9cb2a188-0bee-4433-b850-6a9fc1da6463@arm.com>
Date: Mon, 6 Jul 2026 11:53:25 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH kvmtool v1 2/5] Remove newline from end of die() aborts
To: Fuad Tabba <fuad.tabba@linux.dev>, kvm@vger.kernel.org
Cc: kvmarm@lists.linux.dev, Will Deacon <will@kernel.org>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Andre Przywara <andre.przywara@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>,
 Fuad Tabba <tabba@google.com>
References: <20260706083555.302972-1-fuad.tabba@linux.dev>
 <20260706083555.302972-3-fuad.tabba@linux.dev>
Content-Language: en-US
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20260706083555.302972-3-fuad.tabba@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: LO4P123CA0611.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:314::10) To PAWPR08MB10975.eurprd08.prod.outlook.com
 (2603:10a6:102:46e::7)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	PAWPR08MB10975:EE_|GV2PR08MB8341:EE_|AM2PEPF0001C714:EE_|PA6PR08MB10647:EE_
X-MS-Office365-Filtering-Correlation-Id: 1903453d-3a5d-4866-1003-08dedb4cf48a
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|23010399003|1800799024|366016|11063799006|4143699003|56012099006|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 x5mk81mdZSFPI+srqos1GsYlpd2tpogVBVC03oMUBm+3ZODuG42g/ZFM9hTqrunyE+gF4rODYGBiVJfPiJc3+JmRprH3byMyMRGtz/PdI+IDL412wr0YhXUVpNa6jd2gzg7gFvXlLVOZVUuc2OIq5HJDJ/lBDGdjKpVDPY1+g9EX13HMPhR9IVxITXG6KyRZT70yn5K2LKXEPj2M7JgviZ/PcSD4LF1rxOD/OjMWLp9yOm8L5J3zG++Rx/m9Ysiil4gDFspWiHM96h94V16upnikbA/sHhmxQ4qBLX/cgPB/kP7cDwtZXYUTdinie+4NoLsKEcW7m+ZYr7G+UU77xdAcpbpGVsIzl9uq69vKaS+VvH4OA9Hx2GiddOWiJPcsZhK/fgUXIDyL6qkhrrRVCZNsz1uuyuSbXwl/S11VNThLeTI9tZ34eyQbGTxKPhg7HzBG+b3HQflLVqTuIpzbGF+UVs3trtOutaA41sRFgT2FVlU9MaOeUI/XuiZ9CaWinN9RaA0uoP1lX0FiEoG6qA4lSuePJKgC3ypMaoaSN0deApYRa+aPaLd9UdmweTcso3fmaxOurneX1o99zLd7AEk+uUhpkEelAr877SosVmVrEdayTxrX84hCAIrN+KkkZkjJczUTxf6O05UUlcYbtIloP0mT7svn0qvdN3FQMgE=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAWPR08MB10975.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(1800799024)(366016)(11063799006)(4143699003)(56012099006)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 dODO6pRta4ymF9420Nwl/K6wbjwsuYEvNBUvBF/WchvS8Ge4IwwJfr1Le8+g/awtWjhQ33/yJrLCdG2Q0Slzl2NSlf1dB4FS8N3vuFgdowgaLjldeHjW4zt+QCMR7p5ox4l95H2IhO+n0uEj4dTbgnc1PgSt5GUN3t2klh2YVDpKkEuzWFX5X3zcnC5Wikt+s+IB3/RU9STLN1XEMua1YdUbfdnLShwo3x33hnT4jkFtlpjELgM5u0l/no5uj6FGd0q54AX0Vflc3a7m2YYES7Wu9zp2MtCpbwalPmLctBbdGiuy9eLWV4KDjyks2tZpVhtNz1sU2OSX29BsdrA2yA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR08MB8341
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM2PEPF0001C714.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	f27ec3e5-a12f-41c5-59c3-08dedb4cce9a
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|23010399003|35042699022|1800799024|82310400026|376014|14060799003|6133799003|18002099003|22082099003|11063799006|4143699003|56012099006;
X-Microsoft-Antispam-Message-Info:
	A5/CW60y3SRRYxXIBzaK8Wno5EI5N5aQDIVuVPLR1QJVua84EjPcYgD810DAa+4/FZyGLrM1tfboRhcP/naqsqM9WoNyGUnY1fS5Q2Tn+IcBu85HWe7J015ID3NUewvov/ywwYdhIQ/c0xM7ibxeNbEtyJggai6a2LG4Hj0CT6wrm1VM/3ciNd1xi7/VDF5bMVoqQ2a05Di8Y1smlqouLHs6uS5pcLzWI538IkC7wF6zTfNMesR3qgQC8z8qp5E2/3avifTRzAmwmgvAar5XPWUpHGmmAheUzKo2RlCoJ9YOAFverGJDfeHmjQ+wQhflavnV+WN/RJ0ztvybrpTXYosF5V7jFNUQplS6xVOzG+Nfy10sTck9rus4Urnm9pwe7XaOKNjb4aMF7IoW2sPvk4LZod3Gm+tdd7O9vDgXyrTxFp+mwvfq1qqIFVQlkjXmhfLg1jAYdD0WKjY+HBqYk4ul8XixrZYoC2zm5XJDcNBbheSf+M5OW8Ptx1OR2+6d3k0Z6jlRK5BLByMMGFDtjI8oOmOvuxfFOgmVwAv2d0pC02BY7JKYMvdYxt+tsiN6L+C3Lrzgz4CWpv5EZMD1VD9s4qcUMNXPll+dRIUAwPIPDSZw+D0RR6c8RD/3vRDZGF6qG4WBarK+HOMK45WKOlK7qKBEPustzsgzSPVvTO+HkYu14L6dVOEuma55wiMn+2tQpn+wGrJCt5xp1wtfCw==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(23010399003)(35042699022)(1800799024)(82310400026)(376014)(14060799003)(6133799003)(18002099003)(22082099003)(11063799006)(4143699003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	0rDCTLzyzgCecpzMl8k5y8kqu+sm26NWbURHCDtFzOvxvMLc0UeD6jEw1RG5oTrePGNZrqMKyygrci/rfgzyrVvOkkvgAVyoJmaNmDEhu4wJ6f1QQbkkZGnvqIO+3SNHWEnRdwdCdlxCu0DAkE/CwSUsR/v5eZsONfH3yySffCRb/kAqmPeh+2WOoQ+8kzRJfzNOM0k8h6p+x84ppqlF3aanGm3ZUckrOYT70/7+rFhSI9bSKZQZThVEE3+soaInlzcIfosBxQyQstPgP8kx1mtaZg/nnf0ZZUcgg/a8MZyrnhc4aa1p9EnR6y8YqG7fahIOxpkP21WT4qtP8J2TDG+i2VS0XL450BOo2ZCUCxiFZpIPqCPSkvrSh5/jKFZEjBFzM2T6bLzPVZaa1yydOPfA/LnEPU4ATndqCxIxsu+PnXsQPYyPAM/UXGCjX1ZB
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jul 2026 10:54:29.8932
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1903453d-3a5d-4866-1003-08dedb4cf48a
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM2PEPF0001C714.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA6PR08MB10647

On 06/07/2026 09:35, Fuad Tabba wrote:
> die() already adds the newline at the end of the string.
>
> Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>

While you are at it, there are plenty more die() with \n, worth fixing
them too ?

$ git grep "die(" | grep "\\\n" | grep -v util
arm64/kvm-cpu.c:                        die("32bit guests are not
supported\n");
arm64/kvm-cpu.c:                die("What's that mode???\n");
builtin-run.c:                  die("Unable to resolve program %s:
%s\n", src, strerror(errno));
builtin-run.c:                  die("Pathname too long: %s -> %s\n",
src, resolved_path);
include/kvm/fdt.h:                      die("Error creating device tree:
%s: %s\n",     \
kvm-cpu.c:                      die("Pause signaled for already paused
CPU\n");
kvm.c:                  die("kvm__arch_setup_firmware() failed with
error %d\n", ret);
powerpc/kvm.c:          die("Couldn't map %lld bytes for RAM (%d)\n",
powerpc/kvm.c:          die("Can't allocate %d bytes for HPT\n",
(1<<HPT_ORDER));
powerpc/kvm.c:                          die("initrd too big to contain
in guest RAM.\n");
powerpc/kvm.c:          die("Couldn't create RTAS FDT properties\n");
powerpc/spapr_hvcons.c:                 die("term_putc_iov error %d!\n",
errno);
powerpc/spapr_pci.c:            die("error making bus subnode, %s\n",
fdt_strerror(bus_off));
powerpc/spapr_pci.c:                    die("error making node subnode,
%s\n", fdt_strerror(bus_off));
powerpc/xics.c:                 die("Invalid server number for cpuid
%ld\n", vcpu->cpu_id);
riscv/fdt.c:            die("Invalid CPU type %s\n", arg);
riscv/fdt.c:            die("No way to generate IRQCHIP FDT node\n");
riscv/irq.c:    die("No IRQCHIP found\n");
term.c: die("term_poll_thread_loop: error polling device fds %d\n", errno);
term.c:         die("Unable to create console input poll thread\n");
virtio/mmio.c:  die("Unable to generate device tree nodes without
libfdt\n");
virtio/vhost.c:         die("Unable to start vhost polling thread\n");
x86/boot.c:             die("firmware image %s is too big to fit in
memory (%Lu KB).\n", firmware_filename, (u64)(st.st_size / 1024));


> ---
>   util/util.c | 10 +++++-----
>   1 file changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/util/util.c b/util/util.c
> index 6f41e2c..05d49c4 100644
> --- a/util/util.c
> +++ b/util/util.c
> @@ -128,14 +128,14 @@ void *mmap_hugetlbfs(struct kvm *kvm, const char *h=
tlbfs_path, u64 size)
>       unsigned long blk_size;
>
>       if (statfs(htlbfs_path, &sfs) < 0)
> -             die("Can't stat %s\n", htlbfs_path);
> +             die("Can't stat %s", htlbfs_path);
>
>       if ((unsigned int)sfs.f_type !=3D HUGETLBFS_MAGIC)
> -             die("%s is not hugetlbfs!\n", htlbfs_path);
> +             die("%s is not hugetlbfs!", htlbfs_path);
>
>       blk_size =3D (unsigned long)sfs.f_bsize;
>       if (sfs.f_bsize =3D=3D 0 || blk_size > size) {
> -             die("Can't use hugetlbfs pagesize %ld for mem size %lld\n",
> +             die("Can't use hugetlbfs pagesize %ld for mem size %lld",
>                       blk_size, (unsigned long long)size);
>       }
>
> @@ -144,10 +144,10 @@ void *mmap_hugetlbfs(struct kvm *kvm, const char *h=
tlbfs_path, u64 size)
>       snprintf(mpath, PATH_MAX, "%s/kvmtoolXXXXXX", htlbfs_path);
>       fd =3D mkstemp(mpath);
>       if (fd < 0)
> -             die("Can't open %s for hugetlbfs map\n", mpath);
> +             die("Can't open %s for hugetlbfs map", mpath);
>       unlink(mpath);
>       if (ftruncate(fd, size) < 0)
> -             die("Can't ftruncate for mem mapping size %lld\n",
> +             die("Can't ftruncate for mem mapping size %lld",
>                       (unsigned long long)size);
>       addr =3D mmap(NULL, size, PROT_RW, MAP_PRIVATE, fd, 0);
>       close(fd);

For this one :

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
IMPORTANT NOTICE: The contents of this email and any attachments are confid=
ential and may also be privileged. If you are not the intended recipient, p=
lease notify the sender immediately and do not disclose the contents to any=
 other person, use it for any purpose, or store or copy the information in =
any medium. Thank you.
