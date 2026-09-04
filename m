Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013062.outbound.protection.outlook.com [40.107.162.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78E90199EAD
	for <kvmarm@lists.linux.dev>; Fri,  4 Sep 2026 11:48:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.62
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788522488; cv=fail; b=buoHq85ZYxVetqQZEc0iApiKV6VhHYLPbazSobdihoPaUKFydG2x7OlmXDmLd/JqtA+Yqpy1ptW4aCj+oVxGjHoQOAd7noFexmG0Hg2cKVcKQ/W/tJzLYDCQSqpO97CnjoBgj5VautI2qpLO5wnCvKxu3TQ8sXbbrrEQ9d9Q88s=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788522488; c=relaxed/simple;
	bh=EXnIGNKgYHtc4b4meEb13YGyWIMq2Rrn/Dv6uBtSdco=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=UgabYeZI/9LKOE0ad0rNqH0e2aAQ3RrZliFv/zpSq0pUoxrtWQpj252DFXPxtMBQCZlWwTXSLeAo36TQ8G0n5GPT06yd/9d1yn7I9g4Gf8tkWljzgTkQYLWp/QdeTQh000IF/5ycg0dJ2KI4xKzilKFL39+BUsvZKzDjGUvupd4=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=G5LUh1Yb; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=G5LUh1Yb; arc=fail smtp.client-ip=40.107.162.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="G5LUh1Yb";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="G5LUh1Yb"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=dJzhfg9N1dcU7P0xhmF1NH5nu7fRtt+zxKEOdg0P7ebWZm36tClYAApYGyKglkiCMDjxW/u90IEcYvMARbUuJSsFjKoOstBM2WkgVLhto5VpHGw9noZcX5M1ysIA+NTHrFl0mZvozK1BuKvoLOdd+WqdvmFjr5nbl+u32daSnBQZzabZJs3APpI6XAr05YF/GLKvD0nMbdzy+cNSlJeSfnGl9997t4jRSrcZpE3U1Pg60VYGvd3UASXTa+zOqmGfFzp+4VQtPoJjuwjtTHaxdkyFNKfuJvTkufZn8t1givJfDwXNgMcXkLriYx0nWpNfLvw6JBiTXL7UyUGSxUTdBg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p0GpBwC99UpWc6w4sR7bsZWjK54fUz2VdMf777u7+ZE=;
 b=mTUgcFGOvByybr3qDXKfjetzexSoof51eSukLD4nX+EkURG5l52xEdmyn+D/ncLKWNlA8+eADE2VLNXe5124eNn0vddSZTqRDMEQpIDkVcIxc0HWYESrJiZo1+TgxTtNJbxpivy6HSysu0uuscdKWLgzl2Odm2fECIqd1v5Qpe0RT14t0SaNQDvQ0G5FyyfdllDNKhmKGX+Jbpek+mT0sYOKhERmKKQIW3Fa0So5nnrNfigkE0ek7OeI3LYdYqbJrpl9vYaj/fJkpU6RPiptlm1b7B+XiCS4AxdgZTOMLob52/j10A2HH3mhgkTD+qbk9PBM9ghnC0mWPFYdCIDP7A==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p0GpBwC99UpWc6w4sR7bsZWjK54fUz2VdMf777u7+ZE=;
 b=G5LUh1Yb8+wYxPpBwY2WeaR8qDxwybn7Tjf//uyhQknvfFxKd3L/A59p7ebt8tgsBlYiou8FOwz2pT2VILkflfVLETtxtQdh3ZBRJw+a5j1ySd2fjkP+8C3VF8UkYPeSqbRKjHXr5PbV/dkzG8/6BXAbDi978GJjyLgLPEWpjUw=
Received: from DUZPR01CA0195.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4b6::26) by PAWPR08MB9733.eurprd08.prod.outlook.com
 (2603:10a6:102:2e6::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 11:48:01 +0000
Received: from MAD0EPF000008BB.eurprd04.prod.outlook.com
 (2603:10a6:10:4b6:cafe::2a) by DUZPR01CA0195.outlook.office365.com
 (2603:10a6:10:4b6::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.13 via Frontend Transport; Fri, 4
 Sep 2026 11:48:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 MAD0EPF000008BB.mail.protection.outlook.com (10.167.241.170) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.8
 via Frontend Transport; Fri, 4 Sep 2026 11:48:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qJmTXLYzBdLM0kh3fJvcVshwE09Ayf/2paiEpkP9UNvoy0fGNM75aRMZZNNyNwnFryDU6OhZzvMB8ut2ejYmgL+CkEIliYpxtpEAlccYxZ08wsh6uRDVwYbeut2OrfhNETmEg1NVlpbnYYzKxgavdwEXjpUSxjiIsBhtl0WjQO8/WX39d1MwkKhrNdAN0ksqKUMV+7ibzj0GN+3/sZBA7TN+SBRsSnJXJIybHv+KJ4w3Iy1h+vMuwI0R76D679Rfrbzmb1bTXtnlkG7z5oV3XTtlwlxI61tH9Fcq3RtJ13/C/vUO5HcM+HLFXb/msSeepnkQDIfiYWaKYlShl7WBcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p0GpBwC99UpWc6w4sR7bsZWjK54fUz2VdMf777u7+ZE=;
 b=py0GkgVviNWZ359e+it31/nuR3vXRji9iqN+n47hwrr9SuOXsLfhziCTAv5xCvM/qDWHswTaGh6z2uQUA7Yo/21N/LM2j/q6VSXBmJSLWkY8b22Uz3SvKWjT5zNImPYqookhq1If5mo7zkIz5AxwDmszhQEZMjcVV44AyrR3bOycI+4oOVjFAbIajuKqRSAQSG5S+GXtcyqk4zmClKpCHjvrVadZWav2hmtO3L1fc01VHiZSXiMqIxh57dFNLdqMjbpdNf3Jw96sol3GHW4piNAEw0kjz6uCDU1r3GB1mF2v9xFYPeSup6zBu3S6IDJ9jcQouOveEw/NLBTqfzW6Vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p0GpBwC99UpWc6w4sR7bsZWjK54fUz2VdMf777u7+ZE=;
 b=G5LUh1Yb8+wYxPpBwY2WeaR8qDxwybn7Tjf//uyhQknvfFxKd3L/A59p7ebt8tgsBlYiou8FOwz2pT2VILkflfVLETtxtQdh3ZBRJw+a5j1ySd2fjkP+8C3VF8UkYPeSqbRKjHXr5PbV/dkzG8/6BXAbDi978GJjyLgLPEWpjUw=
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com (2603:10a6:101:1d::23)
 by AMCPR08MB999887.eurprd08.prod.outlook.com (2603:10a6:20b:784::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.4; Fri, 4 Sep 2026
 11:47:28 +0000
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e]) by PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e%4]) with mapi id 15.21.0382.007; Fri, 4 Sep 2026
 11:47:28 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, Joey Gouly
	<Joey.Gouly@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>, "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	Timothy Hayes <Timothy.Hayes@arm.com>, "fuad.tabba@linux.dev"
	<fuad.tabba@linux.dev>
Subject: [PATCH v6 26/49] KVM: arm64: gic: Introduce set_pending_state() to
 irq_ops
Thread-Topic: [PATCH v6 26/49] KVM: arm64: gic: Introduce set_pending_state()
 to irq_ops
Thread-Index: AQHdPGMp28RmrVbwVUeTouQ5GIVS7Q==
Date: Fri, 4 Sep 2026 11:47:28 +0000
Message-ID: <20260904113404.4051341-27-sascha.bischoff@arm.com>
References: <20260904113404.4051341-1-sascha.bischoff@arm.com>
In-Reply-To: <20260904113404.4051341-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	PR2PR08MB4889:EE_|AMCPR08MB999887:EE_|MAD0EPF000008BB:EE_|PAWPR08MB9733:EE_
X-MS-Office365-Filtering-Correlation-Id: bfad9b23-e58b-4fe3-18a4-08df0a7a5f7f
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|23010399003|376014|366016|1800799024|10067099003|38070700021|3023799007|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info-Original:
 l1w+ptI6zJ1OBICIEeAoEcBGRApVmdzCX/A+Nc9lVTT+gHfbPiv1XXJy/KpcWg7E0qOPWrqC0XPxUUTSGnXBGf/DHnqJlY+rYMtTjgTwzS3CHvoFgS0N65OY4YyROY5LTWTlVU27ch2nDTZ+RIcFgPJbpDhoJXbx6cGX5OhB9yHlt6U0NrCxMofhvXifUGieLKGXzuKc/rwffY2taHf0ixlArsd2U7VEYbTTk4gDlH6RG5NKXqDPdpoENOV5MCYoyTZxFPRGM8OevFsyzrBmCC6X7TORoy0ZuTsTgw+Wir0AKOHES6VmnwTyUG1dHwHmVNPJ5sHq2wM9KMFhfFTLQoMPo/5nmrHmiMC/60SZwjtvS8F5Fv8G08L01B0ZL35x0BA4EAvN40i5caY+PzRy9rvsD0gleB/Y9ZcK/n+5gO+eurHcsgftX0Gi8qXgiduHs9WGZ1CjhRD1v+mOMexE/x4XNpBZhfTezah43lWbqeippP21ar01SypYkGQi4eUXl6ck4Lrymey0DpGj/xWvGGI86ikcIzWXNrLayEOT6WRlyoGmkW9rM+SkhY3KJnQ3gdEZZ8PSF8R7h/eJtgkMK6GYE9epl1DpYmv91rDShP49u0TYmBw3Bs7cutdL/My8nX0BGYluaDsFboKtR8iTA7POSLKHYtXZOt8txDxgvbK+/pCWAD/XJFJC1Cf1yg/FzMKO+NP7wGRsp6qhzhL3nbgqqLlpekKjs6+zI378dEE=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR2PR08MB4889.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(1800799024)(10067099003)(38070700021)(3023799007)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 BJ0CHlhQ6vJWnegTl5MrrOyekvrv8UlUG7IvLytW4F6ez3mLOHy3TOgoZP/EzBQGcpwDSWO+iVHp1+2NJrTyMvdgiwxdiejUKzIaAwKAiURUBIj5AwaWvgfJtd9X5ihVdiZOJcaN68BPLzxlSoUOe2NdGKhcB+XM8lO1qtz1RGc/L2GNf118RUoFMtR+6FlwPZOxaWp4ozyw/TTGUVbQQ3hyi4db+mvwpnxWEP2MHUrSv1eFhXM1xNYwCOaOTVCPiguMggsMGQ3OkO4d6w/yV/KR9phO+/+YZcNFm8uY1OqPMkAvfZlM5kxJOY8b5OIN1l/eC6zujL12IH+Af1p8Qw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AMCPR08MB999887
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 MAD0EPF000008BB.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	5a447595-2c0e-40b9-bdd1-08df0a7a4bcd
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|23010399003|1800799024|36860700016|35042699022|82310400026|376014|22082099003|18002099003|10067099003|3023799007|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	vrjV3zn6QqSSY69DVdJwZSKxvsfZ+MAClWQI7OI+SmFDiNIayNJqDv19KliPdKjVCh+r+jsPMHCmb7v25SkDFSdZTO1dtyCYs1rEjnC1Di7xksNT7cKq5jWEjmfZdyNzEhwB4QlDtchLsf0xGRXzOBC9gBJe2pT1EyiwNiPUB5F0fl9aabGvvuvMtGIXxeHbQu8N0tnOKvIN44ORfuw+DVqn+Q5xCPmffVXpjVsjoclptpYNHZCpds5ZUc1AXeCXBmg6ffOz3wLkJ2WP+tgaD9iDz7LJulsjiAbAt2OJxApjsO0ZlKkhdE1+xe4Q1LylItxdDr5/YEF9W/KFdmDy6o8r7Qian5+NHIQ97I6hfOTUDvw7ZmnTCNrSsO7p6XnatK5at0tTO+n72qtNLyWxh3JrGBnSG8OuxWeTjyauMuJrCsuaXYmf79zNQtIUrrFBgOX6MSJ9tSiOLlumnuSHYA0DCJjqTEbE5O/bnQ9S3kJOE1zNvmb63iM05tUjpVKfeTeijgSXq05btP9ynpkhZVL3uH+4KYI1qzYyGiAV4D9rtMbrCEKRovwuw+/phuiRCSjkjRxl6hCHQvGQu1GNsxe4uabxg2DwwVky8E6WzRCsJGRNIdgaLAriyw2s8iL1Ph/TsUUCulGx3k1XAuumkCPZW5D36tmmx6dgAenSwMs=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(23010399003)(1800799024)(36860700016)(35042699022)(82310400026)(376014)(22082099003)(18002099003)(10067099003)(3023799007)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	CqTHfZt+WVTDBNbXA9zDw9BnQSgMWXB0E9iZ+8pp5rxICNa/IRfcmtSmg+4703BRmrzcjDrU2kzcuQno5Gytug0ZRfbKFI6kh+bfqvXurbJz71t/bM3NIwgVlbokyaaitYY2n4nkIH7lHBj2G6ABox0MdugzBni0b4wgf2iwI+Ki7RBPeYslCL+yoDKIhP4FyCUrPcFOF5LfBd/KKeDo/5H9XeKR7Hd/3enGW7y0sOvyZxTMG6szvsNSEYD6VeUJk2HAuSGZdLrVw9/1uCg/F7Nbpfj7DSBaZQ5yBGdN5PKov26zi/viKszgSVHghwV3/pk9KJc20T071OOvjhc7sHDj4FsPz+YqPbq/zT1pCikqJQFDw4g1krAfLBsn9+WB8DwFwpwctURnSX4jxPd0wzvJkT6Is2KQK+gmehhrFRnmk5f3CpIT6x3m5lNHVlKl
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2026 11:48:01.2742
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bfad9b23-e58b-4fe3-18a4-08df0a7a5f7f
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MAD0EPF000008BB.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR08MB9733

There are times, such as with GICv5 SPIs and LPIs, where the hardware
itself manages parts of the interrupt lifecycle. This means that
pending state can be directly communicated to the hardware instead of
being represented only in the VGIC shadow state.

In order to accommodate cases where the hardware handles pending state
directly, add a new set_pending_state() function pointer to
irq_ops. The intent is for this to be used after the VGIC shadow
pending state has changed, allowing the backend to mirror the updated
state into hardware.

This new function is plumbed into kvm_vgic_inject_irq(), and is only
called if irq_ops are provided and this function pointer is explicitly
set. In the general case, this has no effect.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic.c | 3 +++
 include/kvm/arm_vgic.h     | 6 ++++++
 2 files changed, 9 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index ca4fb45f7d501..fc88024ca3a5c 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -565,6 +565,9 @@ int kvm_vgic_inject_irq(struct kvm *kvm, struct kvm_vcp=
u *vcpu,
 	else
 		irq->pending_latch =3D true;
=20
+	if (irq->ops && irq->ops->set_pending_state)
+		WARN_ON_ONCE(!irq->ops->set_pending_state(vcpu, irq));
+
 	vgic_queue_irq_unlock(kvm, irq, flags);
 	vgic_put_irq(kvm, irq);
=20
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 1edc7b378f5ab..684e8324a6178 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -246,6 +246,12 @@ struct irq_ops {
 	 */
 	bool (*get_input_level)(int vintid);
=20
+	/*
+	 * Function pointer to directly update hardware pending state after the
+	 * VGIC shadow pending state has changed.
+	 */
+	bool (*set_pending_state)(struct kvm_vcpu *vcpu, struct vgic_irq *irq);
+
 	/*
 	 * Function pointer to override the queuing of an IRQ.
 	 */
--=20
2.34.1
