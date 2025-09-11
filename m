Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010032.outbound.protection.outlook.com [52.101.69.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F0021DD525
	for <kvmarm@lists.linux.dev>; Thu, 11 Sep 2025 16:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.32
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757609183; cv=fail; b=meeJFe5UX9KGk0CFPMlCn2Wu1lXX1YNd6GrHR/Gx0+2dm8v0eSe2OH5UXAtt0koWk/piKwBCinakcDcjZcPmzISwYuXih7E7C2Tg2ePFEWdIbUMj0z0Uy13yUjJJu4zgOdEgxInLc4NqdvxdwBiAlkrITaKRcqh74GMvUhqbbQ8=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757609183; c=relaxed/simple;
	bh=F/jRt7pnphls8tkAq8hsxv+IeLQYQvriVhmVRwnq0OA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=TpHPru1ATyLqe+TEZ29ZRXoGaDbbCHrp2R6BB4u2Pbb6mO7CRwujG/4wPcb6yayRqPI7lytSOjSFbpCgMlaZlSXI+OWKhZjwgKiTSvj7OAYqhSbMHcgrp8a8l+h30p9F1IgE4oxVQ9fxgxweQOVeZqOeYUtxcqoPeIzCdHL7iXo=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=rJBEisiV; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=rJBEisiV; arc=fail smtp.client-ip=52.101.69.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="rJBEisiV";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="rJBEisiV"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=tY6VJuTihdkuqQQF7pK8eYuIO+exIJj8aRG9PZg55v2Vkys4An7vV+tiqpJ96IjnRDy/cxxpvMoq24GWng3b43ne3KWf58I4L5J1glU+H7j/UrXzKQueP4LD7NzKL/xSbDh/3djpFKc/kdbllju/MZlnJRuyWXUZNVkLm7CkB37uV20h8gYgZP7yGaBwVrCUTqokyumyf1lWS8xWK//Zg7k9Va7qbu7dBfmGV8vXWPJvMHrorp9eW0HEiEGrbQzeaGCXwnC2HRqgGb6AMIRfNA39E5u0fV9rkyZT0mUDq8GcM+IFFpw7j0FZ44LqDRtRu9uyu+Xzyv08psaik8Unlw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uvFcmtfhQjpOvzwcjJBcsU34LWwsOVniGEMwt7+/yw8=;
 b=UbhgRA7ZJ+luU3NAbx+JNvok0sIhSD+GYg9CRRdGmVvVZrqOvRyoprsz1A9DiG4h41t/j7Ecq7Av8HgXfRS3aQnsuws4m8cnWpO0tgCZSUcDetGmuOQ8P6GfeBobpIY9irvDpPMJlcSduoE4NBqVyd4eS9wBXY0QT3zJWh8+94Ah16Bs+parMnLVbGL0Wt89jQdTxVhdC61Q16xxAETPCsJ0w7H84ewaMLNnNYxZ58IMMDpe1EipoDUaQHq9NwxjInLuNuxkGNrMej8GjeTEgfwCVsX9UeMfIvybXtgAZ/JnLjTNhIQYCDdkXSSnLQq6UED/d7RiEGDpdfA5zdYU4w==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uvFcmtfhQjpOvzwcjJBcsU34LWwsOVniGEMwt7+/yw8=;
 b=rJBEisiV/k8z+Gm88v37voF7YojJEn5Ci9gB5Pw6iVCYBOJleZUrPOWbzVE54K9MOcvTXbTI8iWqwuhUxw5LWT/h9I4dJk7uLWjSOGACt04PELy4Ex6gZj+eTXm1NU7X4v5IRg/NabkZGCuc6oVg+wN2ukntEDyQsgsGpSUHD7w=
Received: from DB9PR06CA0017.eurprd06.prod.outlook.com (2603:10a6:10:1db::22)
 by VE1PR08MB5869.eurprd08.prod.outlook.com (2603:10a6:800:1b2::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Thu, 11 Sep
 2025 16:46:14 +0000
Received: from DB5PEPF00014B98.eurprd02.prod.outlook.com
 (2603:10a6:10:1db:cafe::88) by DB9PR06CA0017.outlook.office365.com
 (2603:10a6:10:1db::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9115.16 via Frontend Transport; Thu,
 11 Sep 2025 16:46:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB5PEPF00014B98.mail.protection.outlook.com (10.167.8.165) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9115.13
 via Frontend Transport; Thu, 11 Sep 2025 16:46:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ARjSyF4O3daSHDvxZ7QLwRa8/PFWoGkOCJEEgGIstVi3hQ6T6aT+MKoUd9lA8+LOQWvOnGJlkuPnD0nihMWP+6DGS9ubx7er4muePg2UeSP7c6PUYyD52sKjTUwzbPSPNSD5i422tAnvSJ/oLpUcW1oQmedkF3dOosFFA8OadYzv7X8itecly+8N6ZJWt+nphBjH3ZY6SIMbITZhBOu7gHMm0rq6/AaC+nV0ZjJH1QL7yxCEamffD2/B/bycK0DK11MaQt8T56YWF2JlwkXrdb7bFeRwQDb1HjiZ/9X5DE8ZR73M3k55UlDKGvM4zE80pVCzfbXFizrbw91CJNbTYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uvFcmtfhQjpOvzwcjJBcsU34LWwsOVniGEMwt7+/yw8=;
 b=jrLQ+7RiETa53o6ol13PkjF9KTyRKIha8z72DlFj56ADjP1ayhnLeHwI6xktdYG3I12Pvb9PGTJPR+CW0jPsxded6tZO/0D2ATEOk+KYQL+4vhFIpY0N9XYU3C3m+7a/XStdcgCmB7S3FnKaG/OO3B5jJdKwNZUw4BCu3Xq7D/m1V/ecCydpqs0HM3YySLJVkrZCgDYJGKmdXK4VSsQ8vDwmSkMjlqcKqD/0Kqaz8yD5tHSf4CnFDm1iuXQ3IM90KE9XmlyAGR3ob9Cq/SjabzYCaEMZ+khyZDbqjVdLAyw+4olwoYmWw9ONiSi68ECbHS/6aeu1asqauCEdzykLMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uvFcmtfhQjpOvzwcjJBcsU34LWwsOVniGEMwt7+/yw8=;
 b=rJBEisiV/k8z+Gm88v37voF7YojJEn5Ci9gB5Pw6iVCYBOJleZUrPOWbzVE54K9MOcvTXbTI8iWqwuhUxw5LWT/h9I4dJk7uLWjSOGACt04PELy4Ex6gZj+eTXm1NU7X4v5IRg/NabkZGCuc6oVg+wN2ukntEDyQsgsGpSUHD7w=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20) by PA6PR08MB11586.eurprd08.prod.outlook.com
 (2603:10a6:102:525::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Thu, 11 Sep
 2025 16:45:37 +0000
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739]) by GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739%7]) with mapi id 15.20.9094.021; Thu, 11 Sep 2025
 16:45:37 +0000
Date: Thu, 11 Sep 2025 17:45:34 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Will Deacon <will@kernel.org>
Cc: catalin.marinas@arm.com, broonie@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, james.morse@arm.com,
	ardb@kernel.org, scott@os.amperecomputing.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com, mark.rutland@arm.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND v7 6/6] arm64: futex: support futex with FEAT_LSUI
Message-ID: <aML8rpygzJhs/JQr@e129823.arm.com>
References: <20250816151929.197589-1-yeoreum.yun@arm.com>
 <20250816151929.197589-7-yeoreum.yun@arm.com>
 <aMLpMBWtHDI9sPHK@willie-the-truck>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aMLpMBWtHDI9sPHK@willie-the-truck>
X-ClientProxiedBy: LO2P265CA0080.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:8::20) To GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	GV1PR08MB10521:EE_|PA6PR08MB11586:EE_|DB5PEPF00014B98:EE_|VE1PR08MB5869:EE_
X-MS-Office365-Filtering-Correlation-Id: a813161e-3306-4477-d25a-08ddf152b84b
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|7416014|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info-Original:
 =?us-ascii?Q?RPTBWzVaew5Y2FFMl4SxuOINtNnWdpmXx8Qs9QyBvFlV9173hPRYSqEaBRFC?=
 =?us-ascii?Q?VQpNcvkbb3OwZugVHQXUMJoRasVGiM+egCpN5SCF7iZLGT05l98RvzwIa8uA?=
 =?us-ascii?Q?nZanN/5Y4M1R4P9dxBZcquJelN6C1yUWow8YpgLuGS2F99nMDhZZi01zwcyM?=
 =?us-ascii?Q?1O/vJ39W+AGVemmWNrfxq2zkytCJxcLqMY3NX/OFNgwceXlh8OMLPias8EdI?=
 =?us-ascii?Q?pn9ZFFeY8RaLtfFbWxxQrP1rzsT455tr62aEoYX/YuHy5p1Ltd/RHbjvNPj/?=
 =?us-ascii?Q?uN4xhKFYxhx+fFRlav0z3tqfOwXkChvnSPcZK4te256LQg6sqKPjr4P4Ow1B?=
 =?us-ascii?Q?vyOjvf1dZ6oMLKH4Me5xB81ABkjD8nF8h9PFhame24ks7gS4ad0ZZHtqQTVf?=
 =?us-ascii?Q?pijELTERJABWk1AVlR9s1oC+BP63wIrwNnVnWeq6UCu1Sn7M5ihk69HPHb3t?=
 =?us-ascii?Q?5nHh3q6cf3gtdQeXuFtiGbYGxoH83Dg1WBwbxZWliGMNSykiTuMCibjSuECM?=
 =?us-ascii?Q?oAfbWYX4CVIvOkDi844yXrdtxqf/4BUmxEgkaGElaYd0hAvXE9fxd2waI0LJ?=
 =?us-ascii?Q?aY31syPiB47lgRmARLJ+/AMO47AOMmhaIUoNpO3aEnZsClnRH1fuBOraBLQz?=
 =?us-ascii?Q?0bIpJ0TVQTPzFgqbGQNjGCRPUnShQtd49MPc96KLi5U0gdmDLw6z9cY5ONEW?=
 =?us-ascii?Q?Z2qdp/PehUzN/nUFMSabnUIjeGL4RHBS5Vxts+C7tb5/YyHWO3jMfGkbgvOr?=
 =?us-ascii?Q?yBS/Txvr7AZYUCBB6m3s910ygUF+SJyFuxYRszrBBdv2S9QXcq88fIRImHNd?=
 =?us-ascii?Q?m1n5V3iGt6fTP5wzW0nKVCdUChDHEnySH3utQJcQYfbwrsU2YmZcMPNVJ2c3?=
 =?us-ascii?Q?A5rNslDpJgxzwe076BTmQ8fqlqrIqfer1an8NzqImu/A1h5KFpC/Fh+aVtdR?=
 =?us-ascii?Q?uadf1C+YgDKpgq+4GkOq74HeMa03Wm76MQZsslHBlK0fostJHfEPxMMiw48N?=
 =?us-ascii?Q?e+/HGtZHykooRdfyiZaOruJX3IAaLpIROkWD8TGELZ1LnF+vMjZKZDi15cn6?=
 =?us-ascii?Q?rOMQKQVPkRQ6ATTIqsvBstCN7yEkfCL18uBcBdawFp4UrZPXEWv9kaImditW?=
 =?us-ascii?Q?W1so/pthu4vGzjh/wuZVHc5WK/VDuAjb1WxEdkijfX/J6NE7EvTfaeQraVzZ?=
 =?us-ascii?Q?psAveTUoa5CdCl9ujT9xz0bPUZ8Z9cqoCir4d5Ffd03/n4StxW74kP/0c10u?=
 =?us-ascii?Q?b7F3ReQxtkXhjECoPxFpv1iRBq6bCvVB8Tnsyynz3riWy4/kDn4gDhIanYwq?=
 =?us-ascii?Q?bThKQPQLlxTyCU+vebivpf1YfaSozpRZhoa1qvscJa7ShAahHWhoITxFNAeL?=
 =?us-ascii?Q?mkW5YQlDKMg8HrdiQR7iekaxgj/EOuZpAhptPm/5MkU7HgRbhOfa8clI6nf8?=
 =?us-ascii?Q?JYL2RlH4sBc=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB10521.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA6PR08MB11586
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB5PEPF00014B98.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	89b5bd1b-511c-4ab9-a6b4-08ddf152a256
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|35042699022|82310400026|14060799003|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Gjtnhj2EO7zdP7lj+vxZDCjEJAYg3R2p2XuGOxgD9p8+vmadx+X6pXI00xX0?=
 =?us-ascii?Q?fTGuhRtPIm+Z2EX5RGy8iogHeyOlAak049ywiBcK4+zICbibmAfkI8QBmm5q?=
 =?us-ascii?Q?RPFzcu2/7r+lgqX4PkDNFSztcxUdZrNWYKKNOKxZ0qRMuDYcdpSNeGp52Cuv?=
 =?us-ascii?Q?jTaVDuCr+GQB0qzDLehNX9ikho3gSLM7IAJgPx+uxfrY1AfCEtkS0awmil1C?=
 =?us-ascii?Q?n6hsOQHAb2RX/tBcoXmoFHjdRMop/UfU+azfHsof+XzKmSsUXgMZkPkSWKzK?=
 =?us-ascii?Q?GSuohY/5pV4ox+NHBJE1JdD/+/Op1TAfK27LEpKON/uBkiVTnFBKC0m0uCAH?=
 =?us-ascii?Q?PM9uc/i+K1dhi33XKyBplb32Q696l3QMJlcg4Wb8BP9jS8at3p9lC7ZIbqMO?=
 =?us-ascii?Q?U7iOfmYBTt16Y9mP1JRdWG4rZZXCRwrI2wxv6WLdlzIs1+IfwGUvFSCt+amF?=
 =?us-ascii?Q?EOF1dEsWIVgjKK6CPTKJPkXADnnvcTqPiPlicJhggWoY25rKzOyS8To2FAsj?=
 =?us-ascii?Q?Sgojjn2fTNY+kAJFBkSUdB83in9XAaxp4JGyQFWA3KkptZ8ctR40N9MQV2q5?=
 =?us-ascii?Q?3McI+wxE1/HzZ+A0kzoiCzmLBwiWWSFZ/HoRZgymGjQ8OBh8qayq9MKdYosi?=
 =?us-ascii?Q?wT1r4Srr23/opix1TkRzoOnflY5VUDxK2c7iNJD3rNlwGStYRi7BjPHDv1x2?=
 =?us-ascii?Q?3XgeaGM31uEFrlUpygOo1lX1FLmEnxXmG2+eIya/r5O9bohse5S9si5rxkEM?=
 =?us-ascii?Q?TgNSEBSvxhvyLeqtuwxxl9X58M+4NiYywLrHMngKXJwt+l48fyC110sQ9cK2?=
 =?us-ascii?Q?Ry8SdLIbIRR2DKNjCAk6IHBTNeBNN+vTAU3MlwbIakGlLGEcfoSJtn2yevJg?=
 =?us-ascii?Q?dd2iNeRoI0s0igT0d+sSybKZh39GriA5bqNj/Cv5DsG222YQZQm+oEy8Nb2O?=
 =?us-ascii?Q?MRXZ59Rdcxwy3ux61T7Bp+fMPoVj8KxWq7rS6PjqBmaXAM3e1a2QLJzFQsrV?=
 =?us-ascii?Q?oopJYIcX0JTRqTBhBt61SOZepalykegUPflBx0C9c2Lv0PCVQBHx7NLoGCDE?=
 =?us-ascii?Q?4tM4hnK+JoFDvT2i+/frJutWPR0tLmBIlD0VStpdFuBAh4A4AXzdbpDCMP40?=
 =?us-ascii?Q?a1wnUysEzEx9LuqLIdgOItIjuYRdfVdOGTqHQLB/nyMYhspOAoLsKGBSNkYZ?=
 =?us-ascii?Q?FZhSEa6PNoDCqHaBNnBFecP1e47/W40b0Bs9U0Jqn2RG/wpOSJ9bW3+MEzG4?=
 =?us-ascii?Q?nU1xOcKVDBeCRz0GcX2mmHmelvC/DmzVa0woOuWp/DQE6B04nwU8RJ5oueLE?=
 =?us-ascii?Q?Os0yaoo1NwVZGKzrTJ8bU+NphvYZPDwrD6Ymk76AxHSAGpNOr17uXd3wWUC2?=
 =?us-ascii?Q?uHAzJ+FE38kuxrGovoJX9aoIjKBrqOLUJaLnE1/8r4FKsgoCtZ68eWLs4wPC?=
 =?us-ascii?Q?/QGU+2Kbwr2840ja2dL8VPWy+iOlCMU1ynheIblV4q/dHTxKi3WRwqgbsq1P?=
 =?us-ascii?Q?gpz0jeW1sUiLjfSxlKz0RCbq0Ih4nAWcDM/g?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(35042699022)(82310400026)(14060799003)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2025 16:46:13.7075
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a813161e-3306-4477-d25a-08ddf152b84b
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB5PEPF00014B98.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR08MB5869

Hi Will,

> > Current futex atomic operations are implemented with ll/sc instructions
> > and clearing PSTATE.PAN.
> >
> > Since Armv9.6, FEAT_LSUI supplies not only load/store instructions but
> > also atomic operation for user memory access in kernel it doesn't need
> > to clear PSTATE.PAN bit anymore.
> >
> > With theses instructions some of futex atomic operations don't need to
> > be implmented with ldxr/stlxr pair instead can be implmented with
> > one atomic operation supplied by FEAT_LSUI.
> >
> > However, some of futex atomic operations still need to use ll/sc way
> > via ldtxr/stltxr supplied by FEAT_LSUI since there is no correspondant
> > atomic instruction or doesn't support word size operation.
> > (i.e) eor, cas{mb}t
> >
> > But It's good to work without clearing PSTATE.PAN bit.
> >
> > Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> > ---
> >  arch/arm64/include/asm/futex.h | 130 ++++++++++++++++++++++++++++++++-
> >  1 file changed, 129 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/arm64/include/asm/futex.h b/arch/arm64/include/asm/futex.h
> > index 22a6301a9f3d..ece35ca9b5d9 100644
> > --- a/arch/arm64/include/asm/futex.h
> > +++ b/arch/arm64/include/asm/futex.h
> > @@ -9,6 +9,8 @@
> >  #include <linux/uaccess.h>
> >  #include <linux/stringify.h>
> >
> > +#include <asm/alternative.h>
> > +#include <asm/alternative-macros.h>
> >  #include <asm/errno.h>
> >
> >  #define LLSC_MAX_LOOPS	128 /* What's the largest number you can think of? */
> > @@ -115,11 +117,137 @@ __llsc_futex_cmpxchg(u32 __user *uaddr, u32 oldval, u32 newval, u32 *oval)
> >  	return ret;
> >  }
> >
> > +#ifdef CONFIG_AS_HAS_LSUI
> > +
> > +#define __LSUI_PREAMBLE	".arch_extension lsui\n"
> > +
> > +#define LSUI_FUTEX_ATOMIC_OP(op, asm_op, mb)				\
> > +static __always_inline int						\
> > +__lsui_futex_atomic_##op(int oparg, u32 __user *uaddr, int *oval)	\
> > +{									\
> > +	int ret = 0;							\
> > +	int oldval;							\
> > +									\
> > +	uaccess_ttbr0_enable();						\
> > +	asm volatile("// __lsui_futex_atomic_" #op "\n"			\
> > +	__LSUI_PREAMBLE							\
> > +"1:	" #asm_op #mb "	%w3, %w2, %1\n"					\
> > +"2:\n"									\
> > +	_ASM_EXTABLE_UACCESS_ERR(1b, 2b, %w0)				\
> > +	: "+r" (ret), "+Q" (*uaddr), "=r" (oldval)			\
> > +	: "r" (oparg)							\
> > +	: "memory");							\
> > +	uaccess_ttbr0_disable();					\
> > +									\
> > +	if (!ret)							\
> > +		*oval = oldval;						\
> > +									\
> > +	return ret;							\
> > +}
> > +
> > +LSUI_FUTEX_ATOMIC_OP(add, ldtadd, al)
> > +LSUI_FUTEX_ATOMIC_OP(or, ldtset, al)
> > +LSUI_FUTEX_ATOMIC_OP(andnot, ldtclr, al)
> > +LSUI_FUTEX_ATOMIC_OP(set, swpt, al)
> > +
> > +static __always_inline int
> > +__lsui_futex_atomic_and(int oparg, u32 __user *uaddr, int *oval)
> > +{
> > +	return __lsui_futex_atomic_andnot(~oparg, uaddr, oval);
> > +}
> > +
> > +static __always_inline int
> > +__lsui_futex_atomic_eor(int oparg, u32 __user *uaddr, int *oval)
> > +{
> > +	unsigned int loops = LLSC_MAX_LOOPS;
> > +	int ret, oldval, tmp;
> > +
> > +	uaccess_ttbr0_enable();
> > +	/*
> > +	 * there are no ldteor/stteor instructions...
> > +	 */
>
> *sigh*
>
> Were these new instructions not added with futex in mind?

rather than the futex, this seems to be designed for atomic_op()...
(like user version of LSE)...

That's why it seems no "eor" for this...

> I wonder whether CAS would be better than exclusives for xor...
>
> > +static __always_inline int
> > +__lsui_futex_cmpxchg(u32 __user *uaddr, u32 oldval, u32 newval, u32 *oval)
> > +{
> > +	int ret = 0;
> > +	unsigned int loops = LLSC_MAX_LOOPS;
> > +	u32 val, tmp;
> > +
> > +	uaccess_ttbr0_enable();
> > +	/*
> > +	 * cas{al}t doesn't support word size...
> > +	 */
>
> What about just aligning down and doing a 64-bit cas in that case?

Though it applies with cas{al}t applying to
futex_eor() and futex_cmpxchg(), I think it still need to compare with
old value is the same at the time of load. that means the routine will
be the same for LLSC way like:

again:
   oldval = uaddr;
   oldval2 = oldval
   cas uaddr, oldval2, newval
   if (oldval != oldval2)
     goto again;

with the CAS feature, try cmpxchg if old was different,
returns -EAGAIN immediately seems not the same beheavior with
former __llsc_futext_atomic_op().

This patch's intension is "not to change former beheavior"
but removing change of PSTATE only.

If this beheavior change is allowed,
I'll replace them with CAS one with delight :

Thanks!

--
Sincerely,
Yeoreum Yun
