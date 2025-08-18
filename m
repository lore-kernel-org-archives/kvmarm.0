Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011053.outbound.protection.outlook.com [40.107.130.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAC20275847
	for <kvmarm@lists.linux.dev>; Mon, 18 Aug 2025 19:54:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.53
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755546884; cv=fail; b=YBKleV1K/rUBh/OBfIanNl0wQus66GmW3l8v6VjPso0le5Z5Wg+KW8rqOV3cWaTRkCTcEKpcFCKn6+Js2Qn24wztpAYZC46of4RfZDQ2HO1jBeAcGIhqr0kfh/+PP31Ky1e0LavH8O1QQxriQXz+/xHPrzNK7wM4owsXNItfe3A=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755546884; c=relaxed/simple;
	bh=hp+ScKa5ifi5MkCN4LifVZe7vTSazw3ZddnrAy7TU34=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=bMED6kL+j6HxJilIw8jRIGHP1fDpg2YCCeVxW3AZQ3N6PH7u107zcIo+Qocgk0txsgD6e3v4isQDUWfaVnd53ueEmHe9FQhdLB3MALawgxm/UaJxMqt8vjhcGcRqXSZeQPOz6rxJeTpne6I6z/tEWdz70d9MgqrvsDwf/lNeCjk=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=OFZCfu0d; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=OFZCfu0d; arc=fail smtp.client-ip=40.107.130.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="OFZCfu0d";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="OFZCfu0d"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=vEWAf2N55WOvqQu+1OlNUUm1dQ5Q33Zp9xwOdssTc6nZBu1crfsCITWD4W8dZshxX544mcPyE0kblEFW1FUCUSR39d7s8Hqp8dBwMyP0yW1hpva6pXeStPDENACsvojCkim3xa9/KDEeLZuEAMeBkj+k/YldL1/4UA20W0GOCdTI6Ncxnun++iiL8ZEk7MBKd5P7WFxTXvbkQPUdYTrrMZZZ4tZ1IHu+cvXmKSUQV/Ch0IGbaYqHxisuIc1Gmxpilu7NYihOQYylhJGyFClyV2ZTvNAklOcrfE9DtGb8dKYhvjQf+E9th6V45zVXk/kJQmyXxM47Z+9MtR6W3DOftA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f0pghDXBh5Suszdbm7w3mc3ptfC3KRsCXG3YT+vhcQE=;
 b=H+pBfufkaUdYyw4OXrSDuKhZ+2nKNdTHXFOjK9aP33mW5PtIbZfFUjgH3WOIQQfflp1foIjcy6WwOaNQBNdEFD4Yn9SICCD38aQcpszpNg6iAoWte8qlmkvf9sXMcdvEMd20YP2ybbQduD4VoGNhZhqYGkaMdJlO0w+LnUh3mDWbZhs0OnXzQlSRDci79DPQpBllAA7X1TbKUJ//E/8y+1r9EnzNOEdZxWQ8Z7602Z44o7Y8aLgGP9LMWK+Abw/XF6DfmxsKPygM51NHK5un9svDMW4IGiSOhV1Fbn1TAxtv4JB2bVOJ2LsM/HuaPRpuUXHDuIstBQPaVVzI1HA++w==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f0pghDXBh5Suszdbm7w3mc3ptfC3KRsCXG3YT+vhcQE=;
 b=OFZCfu0dfhPbzho4rfyI2QlQf+zZ8SKfQ4zxGrKVyEh0PnpcoZVi9TAdt4Y2fBGpUu0HgXr+UQhMhaYsoPu8JkvIDsUPVnfapTVvJvvWHNGTGHwtTyky6zJg6V7RRlFzUogrje4kCSG67XKcmGDrZy3mgpxTV7gRD8GPtL8UgYM=
Received: from PAZP264CA0247.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:239::7)
 by VI1PR08MB5327.eurprd08.prod.outlook.com (2603:10a6:803:13b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Mon, 18 Aug
 2025 19:54:35 +0000
Received: from AMS0EPF000001A8.eurprd05.prod.outlook.com
 (2603:10a6:102:239:cafe::48) by PAZP264CA0247.outlook.office365.com
 (2603:10a6:102:239::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9031.21 via Frontend Transport; Mon,
 18 Aug 2025 19:54:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF000001A8.mail.protection.outlook.com (10.167.16.148) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9052.8
 via Frontend Transport; Mon, 18 Aug 2025 19:54:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=t0Dn/hFLTNL3jUMDp5xAAmoV1DPYbFUm1AHGoA4BTcASYnkQ1OAEL1JWeQUL0ykWmIeRrkeV1s7fWpurgDY/xGNxspQKgW7dBRqc82+hM1z3haAENcXnAvQDTUkwkz8/JaaPIgllCMhCBintdE2wAOsUmutU3DuvqEgpllxWVFeYuy78/ql+dP+LYMyv+x7o3QTXXtIYHBnvdJiy4xdL5qoSNGH+38XdCuGadZu7Y30Mdc+A9xC0hj7YhaLc5469CXULHS6j3i4m1BNyYECXU51foIIDiCzMEK2OEAx3AzWcTDNoOZASB9zbTk1t+JYOuyI4drsFEbSwazb0iYFKCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f0pghDXBh5Suszdbm7w3mc3ptfC3KRsCXG3YT+vhcQE=;
 b=OwLNy4iVNyFqcJwtNiq6TC4Lg2f4AGWx+Ct/GrVG/RbQ+3g1ZqPLwMRchyjnbsmq8UiYXPiCfHtWqA0xjWsMA6+Yt7/rTuWLBnIvdijVbCveLDp0A03XbfvXxbwE9gQgsDvK3zrm0/JWmaKYtWFk3dOdZW1KotL7cc2F26MQ/99l99Zs6z8I77m+H8/IawQmu9dKCUyC14lMAlP1J2hk3jFB5+rimIP0NfU9oeJFhceC5CsiE4vIQVRUSYo4p6yhSDJT9D+IJ/r/FR54nQ5YUmGMbNkmuX+pieWDvkRhhc2Gb8phof+l9wwUp8c9bpOGjjSn8QoIl+aWO97KMW8nPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f0pghDXBh5Suszdbm7w3mc3ptfC3KRsCXG3YT+vhcQE=;
 b=OFZCfu0dfhPbzho4rfyI2QlQf+zZ8SKfQ4zxGrKVyEh0PnpcoZVi9TAdt4Y2fBGpUu0HgXr+UQhMhaYsoPu8JkvIDsUPVnfapTVvJvvWHNGTGHwtTyky6zJg6V7RRlFzUogrje4kCSG67XKcmGDrZy3mgpxTV7gRD8GPtL8UgYM=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20) by AS8PR08MB9624.eurprd08.prod.outlook.com
 (2603:10a6:20b:617::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Mon, 18 Aug
 2025 19:54:00 +0000
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739]) by GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739%7]) with mapi id 15.20.9031.023; Mon, 18 Aug 2025
 19:54:00 +0000
Date: Mon, 18 Aug 2025 20:53:57 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: will@kernel.org, broonie@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, shameerali.kolothum.thodi@huawei.com,
	joey.gouly@arm.com, james.morse@arm.com, ardb@kernel.org,
	scott@os.amperecomputing.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, mark.rutland@arm.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 5/5] arm64: futex: support futex with FEAT_LSUI
Message-ID: <aKOE1aqe6EljRkuB@e129823.arm.com>
References: <20250811163635.1562145-1-yeoreum.yun@arm.com>
 <20250811163635.1562145-6-yeoreum.yun@arm.com>
 <aJ9oIes7LLF3Nsp1@arm.com>
 <aKB55rPj1Qe8G+zF@e129823.arm.com>
 <aKCcbQWioNfG1MMQ@e129823.arm.com>
 <aKNyj_6dZVp9O4BA@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aKNyj_6dZVp9O4BA@arm.com>
X-ClientProxiedBy: LO2P265CA0125.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9f::17) To GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	GV1PR08MB10521:EE_|AS8PR08MB9624:EE_|AMS0EPF000001A8:EE_|VI1PR08MB5327:EE_
X-MS-Office365-Filtering-Correlation-Id: d4cd4d1c-401f-4578-a0b1-08ddde910e09
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info-Original:
 =?us-ascii?Q?Uc13LnKMFkilf7MngGd5jVERDFLMeyjVdw2EV0lcqq50JkSbQjN3rnFNBSgi?=
 =?us-ascii?Q?+RpYbdRYssVDJy2p3u/WWYPSKT5OLt/k7VUkCN6LzN9729gZYV696FhhCnOL?=
 =?us-ascii?Q?pVYZPuHLz7Agqgd8bDv1o2j3jV/il2Fc5NRAobZtQIYC7uZ/VK8JNlzg0jbc?=
 =?us-ascii?Q?jaNyIUvNSjK+ZIn0fJowZBwMtRIbAZlaAx1ZumOYGBK3waIYL0rVwh1btGOO?=
 =?us-ascii?Q?GzidK1U+mDzqg38+t6f8R0g7ndnd9Va7fbJnL1kafk20Ax12b9IpJh+kM62/?=
 =?us-ascii?Q?bNQbQM5E+kKPfAlisRWxFpsskddRgscrDlnJeU6YKcxE3SH+SqLVnP5fcNe9?=
 =?us-ascii?Q?zJgLlDWTzjA/O+Jy0i31eeG1b0n6aEl49WBukP1U8Vp9gIL+sxd3WFluLqVI?=
 =?us-ascii?Q?a9pZtRr3RzDuDwfKcV95mt+xwHagDmujje/ws+aEVmiwdO2gvrpHK2M7BlSq?=
 =?us-ascii?Q?l/GNBjv7x26UsJTowUH6cuHFcCNqZBksF6WF5f8VXRz+hwtGinHltlQu6nkG?=
 =?us-ascii?Q?e6IXHahjv1J7ZMIpqi7CjUJEZPMgbokAfscj06u/pptoETWsYBTXToG9Usdi?=
 =?us-ascii?Q?Tg4jqWxKFsra8ByUeuUCnf+Sn6FyasIzAU7hQtd6WDgP1WNCFbcaPVp11MBg?=
 =?us-ascii?Q?ev35qKO9GxHbkp2aJK+HgRcxAvCZSdUUwTP+HoLWaW7umqshSMagNQIqs5Wi?=
 =?us-ascii?Q?vqOLgqmx/lq7dpsSyZkC5AlIn6L5lpDW702o88RY5JUlRD3lgEXrsfW5a3fR?=
 =?us-ascii?Q?ujoxwdgiKbkbIdXxZaxzOZjx5HMO2CDECcQAqZFrvN7/PE9cMUTNtgLHsHw3?=
 =?us-ascii?Q?VQ0qkR83Nduedjtmm+FoJi4NN5pOrqbutyzys/BC12fkivAvu4LLCNyxOjKE?=
 =?us-ascii?Q?4kBR1IFWFeIlNuXYHtaLBsmgbKA7jVqBDMaRFn32YwmeDryHXO3Wkphxc1ul?=
 =?us-ascii?Q?UCQKTzYDoUYTWa6n36+Qx/tRDvS+NmvlATMby6WbhmYRLjN+d/tdRnLfQo52?=
 =?us-ascii?Q?2/od0UGYblTnB/NgHjaSkplsyAtPpviUk4YCc+ouGr80URub20lGKStV6wyu?=
 =?us-ascii?Q?xEWZfFIUqe++DWCAWVbVnf8chJMJ1RANZRQxSDQCUVwbfSZjRytXDYZGHY6H?=
 =?us-ascii?Q?f1xFBq6E7Aao/7zL8eTlI6vvuRjqRtP8ctcTepM/6S3lUpiFPQ5+c/sUd+gG?=
 =?us-ascii?Q?JNbptZ3B1/Sk+ZaGi9akKZ6juWi1KMhzxYFfdYX3TA15LQLD45jqaSgyWGpH?=
 =?us-ascii?Q?oFft9l64NAe7uI9bv/nwXfLx1Wzp0KdqupL08UVEdyc4pHYx/rMapiwKjLLN?=
 =?us-ascii?Q?yDKvxrxoZ9XyzeK4niB0hol39ZacOq2nx2d6L7tNKcO+kGPRRvcKJSd9QhqE?=
 =?us-ascii?Q?MMZq0nCZnRuEjiOaLRugTD9gTFvUcFpehRggB/FTh8BvqYYFzw=3D=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB10521.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB9624
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF000001A8.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	bcfefff5-8002-4705-aeca-08ddde90f9ac
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|35042699022|7416014|14060799003|82310400026|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?y3QS/cfOXA7GPDc80pAvTH4v44MauNs2i7zYbVbSn1GW6B7iIgyJTEe5BTJT?=
 =?us-ascii?Q?9lPCKzBIJI4vo9Yh19p0vhuZBwFKnCsAFyl+dI/dw5+cLueq9ietNYYigQCN?=
 =?us-ascii?Q?8VxieesEEllqK+VnyPNMMmAPXkM3T9ihvBFYUhDpUu2m81gbQlvczNwFAbM0?=
 =?us-ascii?Q?2vqFVILyouKGuDxzXIqKS/1DpYbPnakXplzfL6A1CN9bQikUoyDZJCmkCZfF?=
 =?us-ascii?Q?DdKkpLfHZYEi9Ove7LT92r3szw/4ChzkPsPkJEF7hUmxj4T8oj+2Za/qa/3R?=
 =?us-ascii?Q?GydJxOUJOjba6SHlN4KFCpyFqP8O3EAwd58Y1beLHJrXoew8mUo8OoAsV0fx?=
 =?us-ascii?Q?iuKjQLE7xSsg+N2WdrZ59B/wcJs9ncPWPd4W6wHEiIBnhUhnvF293dLV4Okm?=
 =?us-ascii?Q?JwIkJi0FD5peHES3mTtHUYFD9NuJsNFOCuQUkaBB+9kiiMjPIXV+yB9zkCW6?=
 =?us-ascii?Q?+EWCY057e+e3APWUG5LpSkDqpS1GljLfYELBQMUG2xnPW5QyCToBV+ubGe0z?=
 =?us-ascii?Q?u0kItosNpR+eeg58WVJxm2Od5TGVMScnDyY4/dSCMKD9N8GNeByLHDuWO5v8?=
 =?us-ascii?Q?mcae2OAN4KrLy2vx4w3TfPlHTZHbfuAldprHGGzt7rdEgVvmwEVeJzmr9lb/?=
 =?us-ascii?Q?EQeQg0JQRpOBOQpMsf5qUM18J9MM8CdgmYGBj/HoW9N3+0wzWQqmHmkjdHX4?=
 =?us-ascii?Q?DgSs3fZ5LLDTAZBka2PuEWhV3UgaG/mcHzSOJZr2VBJ1McghA/GoldV/XY3P?=
 =?us-ascii?Q?Evbco/3oBI5wnz1q3t7QOB/U7vxlftLIP9TL9ML0kPWXx0CsLGcpDY5kGpgf?=
 =?us-ascii?Q?ZY2GEueSRnrEsrUfSUWiK3xb2tXMbGJRkFmi+3OsmHP7DpRueotseLRmHKg7?=
 =?us-ascii?Q?YHMy2WhhjSIdK8vNSWBVInJuj8d4q5JL8RUNAGjKXUzEIgfCP18D3KF6YaWY?=
 =?us-ascii?Q?Mhtq37XAw3rkLIMoLqv7RSZOrZE3Fnt5s1BLIhJ4mDkCDbksgPwZd1EINwLH?=
 =?us-ascii?Q?VyK8POT6Ei7Ee/N79VtYwq5KIOUHbdRe4JthDqGf62+Xj1qJp7a1sLA7UrXC?=
 =?us-ascii?Q?YnqZjwEeCqKjg10SjQwj09OcN+Rr0ENLOc1y5IVlR2IsrSZ4Ytam6AoqvxM3?=
 =?us-ascii?Q?7llmubHr26bv8MmxClFcaa5l8xi/cakJcdnNAZbSJ7ZawB5xZh1kOu/iSzfy?=
 =?us-ascii?Q?L6grZzMEa6b6Mth+QjlfP27QGPK+1D7JGJzBYkoK3KP4it8ui1xI32Gfik2+?=
 =?us-ascii?Q?R/3pyf/k+hppYCAHPJKLHe3lHcwlxeSQJ+5hjGR6vGnV0j0VQJfH91KIaPyW?=
 =?us-ascii?Q?Y9YMIcaWFj1jjrbJkFi6ydkbM4gfRUO8OOD3nFsuMVF9rfu5CHZ8oopyPSB/?=
 =?us-ascii?Q?/ZWVQweWFNhxd8ZiG/EZO5lVePfcNQS/lMNWW1fWKTLSKq91PQkHmjHrmB6y?=
 =?us-ascii?Q?SyR3lGJt6+25EXU9eeOrITva5v41w5vgrhDXFY/6Ynpv51/ed5vKCktvfjud?=
 =?us-ascii?Q?ne4oVaZnkMoWwJG6ZPiUqT+dUGxlz+JPVM0M?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(35042699022)(7416014)(14060799003)(82310400026)(376014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2025 19:54:34.2749
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d4cd4d1c-401f-4578-a0b1-08ddde910e09
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF000001A8.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB5327

Hi Catalin,

> On Sat, Aug 16, 2025 at 03:57:49PM +0100, Yeoreum Yun wrote:
> > > > > +#ifdef CONFIG_AS_HAS_LSUI
> > > > > +
> > > > > +#define __LSUI_PREAMBLE	".arch_extension lsui\n"
> > > > > +
> > > > > +#define LSUI_FUTEX_ATOMIC_OP(op, asm_op, mb)				\
> > > > > +static __always_inline int						\
> > > > > +__lsui_futex_atomic_##op(int oparg, u32 __user *uaddr, int *oval)	\
> > > > > +{									\
> > > > > +	int ret = 0;							\
> > > > > +	int val;							\
> > > > > +									\
> > > > > +	mte_enable_tco();						\
> > > >
> > >
> > > > The reason uaccess_disable_privileged() sets the MTE TCO (tag check
> > > > override) is because the user and the kernel may have different settings
> > > > for tag checking. If we use the user instructions provided by FEAT_LSUI,
> > > > we leave the MTE checking as is.
> > > >
> > > > The same comment for all the other functions here.
> > >
> > > You're right. Thanks for catching this :)
> >
> > But one bikeshedding question.
> > why we need to care about the different settings for tag checking when
> > we use uaccess_disable_privileged()?
>
> Because, for example, the user may not be interested in any tag check
> faults (has checking disabled) but the kernel uses KASAN with
> synchronous tag check faults. If it uses the privileged instructions as
> in the futex API, it either won't make progress or report errors to the
> user which it does not expect.
>
> > IIUC, the reason we uses to uaccess_disaable_privileged() to access
> > user memory with copy_from/to_user() and etc.
>
> We don't use uaccess_disable_privileged() with copy_from_user() since
> those use the unprivileged instructions already.

Thanks for your explaination :)

>
> > But, although tag check fault happens in kernel side,
> > It seems to be handled by fixup code if user address is wrong.
>
> The user may know it is wrong and not care (e.g. one wants to keep using
> a buggy application).

Then Does this example -- ignoring wrong and keep using a buggy
application shows us that we need to enable TCO when
we runs the LSUI instruction?

AFAIK, LSUI instruction also check memory tag -- i.e) ldtadd.
if passed user address which has unmatched tag and if user isn't
interested in tah check, It can meet the unexpected report from KASAN.

Am I missing something?

--
Sincerely,
Yeoreum Yun
