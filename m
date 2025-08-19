Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013039.outbound.protection.outlook.com [40.107.162.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A00273115AE
	for <kvmarm@lists.linux.dev>; Tue, 19 Aug 2025 09:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.39
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755594704; cv=fail; b=nOWmSfd0/TGtZBy1Chfe6mKse8wq+E64qc7uQ/pfXdoq0LBSfgXv6OLTyfF2Xp6uqNmlPwyRPapJH4GINn/4/nAsyf5f3ZMbiYEGr4pHEnRi+hAEcgyyAuyLRADF3B2MkCujtp2Ns+lbEw+ATyT/lTaMZwumZ5t8Ey9wlXxiMTI=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755594704; c=relaxed/simple;
	bh=uDU9qgoeeTDASvsEqSENX0M4DkVpV5LBOY03KVlT7ZU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=iUszXVAN94CM670EJaUEQbt9/8mfr0UgotVIKWzHcom4HpyRYmQbRsdyGlAh6M9wqYeN+Weo6ccpmmng/VMMYTFcx+AdGY2e+LLDLRd+2AVyavo/NcF8eKJemzzFTDDsbubg+SsH73rDiKtxiDwKshR7tEo4J7DqVrO36J8YbkM=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Oyp9RW7s; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Oyp9RW7s; arc=fail smtp.client-ip=40.107.162.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Oyp9RW7s";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Oyp9RW7s"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=XXJNzYVSP8VBPva8TI/GnLTwS8Fu4wkOH0N8Va/B4zGlDBw0MFxBfYfYfkMNBTYb7V6yfwCfc6EXFdM3x391F/MHBo5TnGgeEZwK7KLErC3VJh2ak5ELIOt/6EWjKDAFANA5LXXebQF+55wvax2aETj6Grol0b9C+As2jw8WCol2pWaQgYzYeZyZkP6cSY3bh6jQL6ilbfdUtKkurriU1Gk/qKSm9KcnGt4iwI5682FsA3etnVjPUjwKn+AaD45DpUOoez8Lzipl7IlyWaSWJlXkbORIjcFkkOxo6ZYp5GhAddxKy+DHOt92/wQrnGaD4v3mWjQ/EY6h3SBVcXUTWw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uDU9qgoeeTDASvsEqSENX0M4DkVpV5LBOY03KVlT7ZU=;
 b=s8BPxud+uoNi6rEof5p8dMIpf0fkzmZjZqQUjSM9rLX9rOUINysYCBUMTTpjLR0SAK9yXOG3X0FUD6o6o2IJJHxTFWb54jpr8zBYo2MI1RG2+gvlE0a2nkFhp9QdJREY7TIhmgRCFOHatfReIhsrx1R+VFH5lxjg6xOrmU7zzgWq+UP71tBFvUNy1izkcIEgwhA+3ftRzz8NuDr0ZnliTfrlTSYDHiK0YaKfCdSZFP5NrDQgTi+FzI/eehlT8McWkrhxA2yMM0o5bBX6qkfAYyVkkgONw7l9XFiesJmC0J+5bVMfxh/WF3w4QYY5jx2H3y1EZr5ygXY362jJpaGILg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uDU9qgoeeTDASvsEqSENX0M4DkVpV5LBOY03KVlT7ZU=;
 b=Oyp9RW7s8n527hJGk3aEm0n+oLwsF1gIQIunO+DzHdRMJK+XGtJYhkTcnOrK9v36RAVK2AlVHDMm5D+fWMdKHrNs+m7bYLKprjPWUEwXyIBnpyCw/M0oc91v/xmW3Z8kvakVcPJTJw9tFF50kP23pROypfNuTWcALGwxIlr3GZM=
Received: from DUZP191CA0064.EURP191.PROD.OUTLOOK.COM (2603:10a6:10:4fa::17)
 by DU4PR08MB10984.eurprd08.prod.outlook.com (2603:10a6:10:573::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Tue, 19 Aug
 2025 09:11:39 +0000
Received: from DB3PEPF0000885D.eurprd02.prod.outlook.com
 (2603:10a6:10:4fa:cafe::63) by DUZP191CA0064.outlook.office365.com
 (2603:10a6:10:4fa::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9031.24 via Frontend Transport; Tue,
 19 Aug 2025 09:11:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB3PEPF0000885D.mail.protection.outlook.com (10.167.242.8) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9052.8
 via Frontend Transport; Tue, 19 Aug 2025 09:11:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OVdYq9wsaLd4/ZWn3ATb+yCGQiZ35/Z59Oci8g9I2z0wjNmHsHdXvAZPc5lUi0o7LZwNJYBRqBaAT+mqcSFGvvug1yjUhA1ayBxTg82EVWXy0zlf17zUpiz+ie7ZfW2UWdqg5IbSddgjfUBvGZPJ9/pRwqQ50ZFOvq5y8ZEMRB3uFCxMG6ZRsVJsQ/QavAvNvScHYFqlQZ81oUe3b/G5sRGF979QLGaeeEyMV9uW7tZCnxOBf6gQXNSfFNFPRtQbCeQbmbttt4fja7npfafAxNwgkq4zn+3hlYmDaoGUCxiphqLHETjdBxUAqMJMRSRlVGnnz9hJFrYfxDsr4tLScg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uDU9qgoeeTDASvsEqSENX0M4DkVpV5LBOY03KVlT7ZU=;
 b=VvkR8SVBFPzu7Dq5N6Om4saYgslIxY1gxkJB3JfdrbpF1unWkwyxqwOdJg+jn1PBOzUzggi1bnJc50ut61Ll12Pt4UXmFFs9reJZXUBkoWwlBgzNTEnc8IJA7nUjGsET2Tn+jj3GZ9rOaTsBFWh2NC5+wbCFvSk6qJq/lhV1PdnocmtGLkj03lE2su0v/f0tC3cnnjugTd+HahKcvO7XdQ+brzV6DgtPoQehkwGizXAPP88vIrHLSi8GkWFYYKAmzi6Fmxol6NNFChtquhtznewkxqk6prhx6/0ZGKuwXPkt0ckhMRdwpKqqw4AVyeVFnxvg89s4Qkv2JTcTYGzVzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uDU9qgoeeTDASvsEqSENX0M4DkVpV5LBOY03KVlT7ZU=;
 b=Oyp9RW7s8n527hJGk3aEm0n+oLwsF1gIQIunO+DzHdRMJK+XGtJYhkTcnOrK9v36RAVK2AlVHDMm5D+fWMdKHrNs+m7bYLKprjPWUEwXyIBnpyCw/M0oc91v/xmW3Z8kvakVcPJTJw9tFF50kP23pROypfNuTWcALGwxIlr3GZM=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20) by DU0PR08MB8883.eurprd08.prod.outlook.com
 (2603:10a6:10:47e::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.20; Tue, 19 Aug
 2025 09:11:05 +0000
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739]) by GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739%7]) with mapi id 15.20.9031.023; Tue, 19 Aug 2025
 09:11:05 +0000
Date: Tue, 19 Aug 2025 10:11:02 +0100
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
Message-ID: <aKQ/pglPWZMprL5e@e129823.arm.com>
References: <20250811163635.1562145-1-yeoreum.yun@arm.com>
 <20250811163635.1562145-6-yeoreum.yun@arm.com>
 <aJ9oIes7LLF3Nsp1@arm.com>
 <aKB55rPj1Qe8G+zF@e129823.arm.com>
 <aKCcbQWioNfG1MMQ@e129823.arm.com>
 <aKNyj_6dZVp9O4BA@arm.com>
 <aKOE1aqe6EljRkuB@e129823.arm.com>
 <aKQ4HvqZa_7Q7oDu@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aKQ4HvqZa_7Q7oDu@arm.com>
X-ClientProxiedBy: LO6P123CA0051.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:310::7) To GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	GV1PR08MB10521:EE_|DU0PR08MB8883:EE_|DB3PEPF0000885D:EE_|DU4PR08MB10984:EE_
X-MS-Office365-Filtering-Correlation-Id: c656aba7-9b69-46f2-2446-08dddf006831
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info-Original:
 =?us-ascii?Q?BcianBy1cIci49wH7A7yDB8VeIRCroZxpcZrewFMEt35Q8IaZyU0SOP2FpAF?=
 =?us-ascii?Q?ojDqIQJiXtfRXZvSpk1MXSC70s/vP8RvqNS7wlaUbuQiuT2PapiMq0On0BEO?=
 =?us-ascii?Q?Ae9GqCadMYRZ/bz5jiwDDLpJ3ePl6OtQaLoEfmdK/r0KWyybMiaH1bKbBhbW?=
 =?us-ascii?Q?ixkIoVEAD+vEQ74hDxpU10QuYI7LA3D7wv8nXEsEyrwwRtsZcjBa6fVwThVL?=
 =?us-ascii?Q?9OObTSZcWG0ZUXKBNj/MwOghbqrj92cquWHthwijBIZKrHwJAdOoTCEoHBSE?=
 =?us-ascii?Q?ECwLeQ+o8K9h0rfnW0qqYqN1RTS14UImlEGal0hj/L3iR2UNUwMmZW6egCMn?=
 =?us-ascii?Q?kdo1lM8Iq3LYUapseqhjvncxCTTmuo18xRkm5DTbmhQuzgUqOhnEUsbHxFJg?=
 =?us-ascii?Q?uUtAXSmH7oNLbVPlqPnLwnHAgwKGonYz2u7VwH+r54K16+iZ51d/w92hqN2D?=
 =?us-ascii?Q?I4u4Mzvn5qN4WR0uxbexvqBDHuvZQjWxnA4xpunIfohygRew59fC6CznebCT?=
 =?us-ascii?Q?Q88qFsrODy7L4QScofndEarEQHpZ75wsXxXVOu53s/PIdFr/NJUgmEuG4GQa?=
 =?us-ascii?Q?3Dc9udeUUaEh1ENjynKs0ItyGDNxVLrzfndQvZkpeBXo4Vt68AkGzexp4LIu?=
 =?us-ascii?Q?Soz1CGiHGgwkzIX3yv+Dj/D5OXBILZh9T3m2xoowhSwpRU3eJ8wubvR78UlY?=
 =?us-ascii?Q?vmGVOE8HOuhfDh0CrdJnpLw2lD0oiQFOeDmRNlzUSvpulvdacejUcXX+khjn?=
 =?us-ascii?Q?lZnQVWhpWFPjaXjlYRp6qsV5vcoHVeRYTm9b/cW5hSpD6ZHJ3vEtcL3qd3Cs?=
 =?us-ascii?Q?DKr3/cs2GRB1Cwiknw4TqleX8kPpPa0N0ijiqD5Tv3d0P91I2kaFTwk9HH+F?=
 =?us-ascii?Q?Y7zbIvBBv9/SkrIH96n+3JctAcU0G/MStbxlHtiXuqQVgVAcfI3w0ILNLhsu?=
 =?us-ascii?Q?IMSZKhD5elcQDAmSzzLVG9pf/6g+sRKsYVjhHoTtkkL88RFmtIqNyJ2q5sPy?=
 =?us-ascii?Q?fDEKd79xNvz6FcEOOFownfx3thhnNNVmUw4FIUOzgR3irIRtHOr035iqFZJ7?=
 =?us-ascii?Q?O1oBw9JnwUB12oTF9GPSXcEG5+ViaV0uWdhAgeT5scQoyQW1Z0QXKO8d0Rdw?=
 =?us-ascii?Q?vLqvUeMGJvLxzGGOMtXOJzyShtSnqGgIdx2xbvCSJ4oKNxpLiO5huFvi/5fz?=
 =?us-ascii?Q?q3/dP0oydG1YdBJzbN69o2B53lMnl02P78n5FfyHSJovVwo6fft3PdQM3Ga+?=
 =?us-ascii?Q?QxjqurJbC62OjCkjMSXlOoNlTPbQcFlIjd1rXWhDrVkH62gp1TFMynWHwYub?=
 =?us-ascii?Q?fqo/SizsArejgxYZUbMdRXMLHquesTblEX6eQiXU2s0xmqXcpHRvWqUoVpwB?=
 =?us-ascii?Q?DqCyOrGShOXKfkR0mvI27YRignI6qiuhU3OrtkRIXmCfPiRgqyzhJ07Qp0+J?=
 =?us-ascii?Q?u1RDfNM8/KM=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB10521.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB8883
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB3PEPF0000885D.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	c0750e3f-2837-4113-619b-08dddf005397
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|7416014|1800799024|82310400026|35042699022|14060799003;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?WLrBWE80dmGB2ES4S+Esn2Fviv39rfrBOwyuZtJ19T22IpoUBpSOQcGZdGX5?=
 =?us-ascii?Q?1lnpkiaN/nw//S1TI16MYL9I6t2lUO/ZwDHWlqdPwlFt4cYJQ8BVgMlvaILo?=
 =?us-ascii?Q?y71LrqHVpPpa6YSOqlYXSYJVbhE0n6BmuA95yP0SQaiP1Hd2efOAmjf4+9Wy?=
 =?us-ascii?Q?6QUrWIxB0EHWlA7LBD+6N1LIgmAorb/IVw7gieMZGwhsRFRzD1c58ari3x1m?=
 =?us-ascii?Q?gJE/LlM0Kla+vB04CdTm01u5R1NMLsmQU2vVvkEfn/S3AXE1Xt1ZROgCr47C?=
 =?us-ascii?Q?cOk0AHSBQH4319Y05C10rBWlrd8mOgQHRfZmE5dWXZVO9b2B45p7zYmL99Qa?=
 =?us-ascii?Q?f06j9oXhv/v3EQkPy/biqKw5FONoE35ZJ78bSokWedhNEW1CHbIHfKzFWlEY?=
 =?us-ascii?Q?/EmC9TOqgS/PAcusHRRk+EGIyPYRkMOScI2obqCt2XBKY5TRsdYMnCED3XmW?=
 =?us-ascii?Q?X8Vxr7XRurRpt/zGr7CUHnct+Tnmb398FeaRGa6ZJBqLC5xPZ36alcdNtH05?=
 =?us-ascii?Q?OXaWuKlBxFYtz/HPTi3CaGkUHP0WrcO9xqUmo9pU8bOSRJDCk4B4gJYCuamX?=
 =?us-ascii?Q?0Kmu18SxsFITN4rPTYV4EWaH0dDB4eH+OhcCe13myKj1A2qxMJqGPStpShCs?=
 =?us-ascii?Q?Q75EvUVg8RBtoKq6r2Bi6JS+v6Sy8XaV+72drBW2UIx1bfVSQIAEF5cIB7t6?=
 =?us-ascii?Q?HVJIUm25TOrXuN/8FhKI9IKp4Bu1KPIiXQBcBwq0PBi3gyGR78WsvYFnr3x/?=
 =?us-ascii?Q?dnTWu2XzcT/iCmjdQyTXL+kKfsWrNxJK5az4tQnva+cw+d3xZV0+DQ+t2nd8?=
 =?us-ascii?Q?qNoZtkIqKZHnfP94iwFDxQX6RPzPFP95qPZEEAegVe5iGLftZmVR+jUXNT0b?=
 =?us-ascii?Q?RRE3TN1yC0i2dYDglnz6GfYq7VBJHzvx7dPjKsiWFedHwcJYaYeW/QdVfrZd?=
 =?us-ascii?Q?7HSdWhsA9QAId5k172TXFoncIhiPFPmPrBfIemLgNfFL30sC36b6wS+EB/7q?=
 =?us-ascii?Q?+kPA3QVvYdf/e0nKxvKi97X8xrlyaV0f89izSJA97xcpQG1/TrqTPwhAplC/?=
 =?us-ascii?Q?qxfUBF+0KyJusHwj7UkXL/vNNqlDvq9hCd2VwDhx7du2affHaUwa7VX3bEG6?=
 =?us-ascii?Q?nZEeCNNEHnp2I+uHZM2l3RdMGFxxsr6KJ9SZCn4VuRsx/VNpubtWyDmv1Lc/?=
 =?us-ascii?Q?7GXegJttDJMGQdk8fcuPSoz5DcedjJoCQlyAV+beUkRm2N4qDgrNWIqwTzPb?=
 =?us-ascii?Q?XPO6ltA9X4e792TYwFVMzqaNfk85hxeFyeOnu03W9mBaYXHHE5mujjk/xdoW?=
 =?us-ascii?Q?hsxTKzWXnIjwCrruKl05PaqXuPlEgFD2jEoceYDrSCGztdz0E8cPHjHlzdwb?=
 =?us-ascii?Q?+AYbQvg1Fapp2zo4zsT8hA5YfhBclvgPpM6Is1bIfHuLs342qjEJABHiR+95?=
 =?us-ascii?Q?+ggAWqBCw4QiA5uXctU2KapPc6Zig7+Z1b27+j43hh7smCaxyAdQ2VVUY9i6?=
 =?us-ascii?Q?BYgQ7v7CWIgQXcnWhl75cPnDCmbeX/maQNrm?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(376014)(7416014)(1800799024)(82310400026)(35042699022)(14060799003);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2025 09:11:39.6542
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c656aba7-9b69-46f2-2446-08dddf006831
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB3PEPF0000885D.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU4PR08MB10984

On Tue, Aug 19, 2025 at 09:38:54AM +0100, Catalin Marinas wrote:
> On Mon, Aug 18, 2025 at 08:53:57PM +0100, Yeoreum Yun wrote:
> > > On Sat, Aug 16, 2025 at 03:57:49PM +0100, Yeoreum Yun wrote:
> > > > why we need to care about the different settings for tag checking when
> > > > we use uaccess_disable_privileged()?
> [...]
> > > > But, although tag check fault happens in kernel side,
> > > > It seems to be handled by fixup code if user address is wrong.
> > >
> > > The user may know it is wrong and not care (e.g. one wants to keep using
> > > a buggy application).
> >
> > Then Does this example -- ignoring wrong and keep using a buggy
> > application shows us that we need to enable TCO when
> > we runs the LSUI instruction?
> >
> > AFAIK, LSUI instruction also check memory tag -- i.e) ldtadd.
> > if passed user address which has unmatched tag and if user isn't
> > interested in tah check, It can meet the unexpected report from KASAN.
>
> That's a valid point w.r.t. PSTATE.TCO that applies to copy_to/from_user
> as well. I don't think we documented it but we don't expect the user
> PSTATE.TCO state to be taken into account while doing uaccess from the
> kernel. We do, however, expect SCTLR_EL1.TCF0 to be honoured and that's
> what the user normally tweaks via a prctl(). The TCO is meant to
> disable tag checking briefly when TCF enabled the tag check faults.

So, IMHO, as copy_to/from_user (ldt/sttr) enable tco before it operates,
I think futex using LSUI should enable TCO bit
before it calls LSUI instruction.
Otherwise, this sounds have a inconsistency of allowing TCF according to
SCTLR_EL1.TCF (not 0)'s configuration while kernel accescss user memory.

Am I on right way?

Thanks.

> --
> Catalin

--
Sincerely,
Yeoreum Yun
