Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011059.outbound.protection.outlook.com [52.101.70.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D778B18DF9D
	for <kvmarm@lists.linux.dev>; Tue, 16 Sep 2025 09:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.59
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758014733; cv=fail; b=ECKHw9crO85I4HR1VFdCS3wZ2ypKUpbPqNh4UArI4EXUp90OfN7Ny2TQoTn9cHlXmbLZ8eijj8Gzu9DXaJFqc0sI/ug5olyZKyXMiEmCPUon1VKJHRXDOXCfG/XF7HFw02RPdFAeSwfCKx1ZD5uaZyUcvJyBw+T2pOrQjXPqI2A=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758014733; c=relaxed/simple;
	bh=V4f2nn4kbA90/WnTJa1ziUq6BVGr2pHu7p72RndhtQ0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=tRRLesXQ5aIs35ndiZS/hZoar/sKRa/ilp9Z/KCSj6eH/RNQwWCMyo+tqqsPlDCIR1o0hCXnxHtgHKZHdFPvh0BVxtyvcVv3tpFHunioZwoAZGsm2k4WL5352IkyS3gCjuyLIbftL2I1SXZDu66o8SKGQZ1GuyPwqSP3IZHEnX0=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=AK4onXjH; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=AK4onXjH; arc=fail smtp.client-ip=52.101.70.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="AK4onXjH";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="AK4onXjH"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=E45mpPB3DOzx6s1Kq0ZmQfCSZRndRFWFXo+3fEai2yKqhkpsehKNj3N5GlEkIFJjea491/PCEOifhpTlyqlXlVMraUIaCBND9L6EC3CjkkSpUFknOsVRf2CrflUH0b43Xlk/C02SoIC1faRrzWDsiwQNTbvNO0MNewcIGMfqDBRZGtitsa84fgJs7nnBv974xWwTr0e3y2521oXp+jRtjCYqP/XDMqo6w5Vs57ALVaBAWrjIBhn3T7/zOzNsCl+R7HTZfPwTjW+kfGfphVNWFmbqSdcnjNqb6hLo74DaPMpnL69n1qvU9Dri/Cu2xLQPZvEe5j5ztKcuLKlK7AVy3w==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B6oK6gNfXzAck584z8eSvHZigp3WwAUwfaQZ8XGUPTc=;
 b=YInS4n9JKSaSWUtQ9/R9EOYrQnb6KkM3WvfBix342gUlQxoOTESeUNvJ6NO+PLjSyt/0ZZ+fMUDBjmAU9+Ua4Rau/Z+y1StuU778VjIG+s2Bog4stCeAP1IY3bfV0B/NMNydwr97GfK4b89QVYtUW48CKtTZJE2dTkyiV89wkxVnuBR8dWnh3tHImUPmP9ncflPzmHTFY2+RlA68Z9eizoE5qZnHi2wZLpGGWiOpHkrS4pKPZBOEVd80pDWXqflgUGt+t5Ff7gLovE6XZCMJ6RTp/nJttpKVYYzUdOSvDzqx/B546qyn04YyE/tk3T5KDyjaVV8t3pw4QsEd1fzqrg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B6oK6gNfXzAck584z8eSvHZigp3WwAUwfaQZ8XGUPTc=;
 b=AK4onXjHkFy83efCOIvYhS1EJyub8RUa34iv18Klhn1YFSAp8kEHaLGT/Sn8goA/rAUU34nH3IMX6ZqTI2SMJmMOV32+Qp3hHwIIk+KVCpWRjm9EXIq1+zJIQUmTobalgNJhqgucv0nCvCjrURtWl5bl/cpKIcLt+Y2rXxWs0Ww=
Received: from PR1P264CA0174.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:344::18)
 by DU0PR08MB9299.eurprd08.prod.outlook.com (2603:10a6:10:41e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.19; Tue, 16 Sep
 2025 09:25:25 +0000
Received: from AM4PEPF00025F9A.EURPRD83.prod.outlook.com
 (2603:10a6:102:344:cafe::15) by PR1P264CA0174.outlook.office365.com
 (2603:10a6:102:344::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9137.13 via Frontend Transport; Tue,
 16 Sep 2025 09:25:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM4PEPF00025F9A.mail.protection.outlook.com (10.167.16.9) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9160.0 via
 Frontend Transport; Tue, 16 Sep 2025 09:25:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SNbFXTqaXx9BDA9sNJrXIFE1BMwW81SpNA54VzCUCifUO+87OBbyE36CAB8YveEMtJUySG3F++PPkN6lue4GfWB94y3SfdyITs8FSmrZMFOuIUc5S/uFPoftzZE8pc6LujflE7Mbp3HttAB6feMlJQ7n9z6lnmshUH5j16AXVYPPpFKPmta5dgIX4+uLtpVeEg9IbCG16ltJp4YaVdWpnQfofJuyzN8oHpUHTBB+yzYcjRCmZhPA236ncn0b6Mwz4Oalf0KQLcK2/UncqejERVAFC2IW1LeRezTScoVBPsCNyPIdCiqpFeABnnR7e94+2gCUfw77gsjgvtM4XL8q0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B6oK6gNfXzAck584z8eSvHZigp3WwAUwfaQZ8XGUPTc=;
 b=wWil6WPElDTAUKt+Gnwxft7GHdMBbb10LjYcsejrNMX34yCCgDRnFYP1GSwU5EMiZqFn/kRwYbC4ayd8lXlPzZF4bJJdsr5/JTTwh9lv4b6kYllNvPkilxFbuz/QF3dAunbbkkmgfNlddjlkrtvNOQ4NEXjsxWlUjfzV/knm/mWUCDRDermIXR8t+sHxLE+tf+9JlHiCBvG5xpeTD9N/OSM0S0viHwjwQje05MbVr16aU6wCFY7ibdAKTDYTrGX88r5arOpl4sja6IGhlYqZXj6HPZkGapY/6wsMOt2/p1RbW6Z3viziJJza7USQ1xSFDuhmbRiE4GMo2uVKFiD0pQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B6oK6gNfXzAck584z8eSvHZigp3WwAUwfaQZ8XGUPTc=;
 b=AK4onXjHkFy83efCOIvYhS1EJyub8RUa34iv18Klhn1YFSAp8kEHaLGT/Sn8goA/rAUU34nH3IMX6ZqTI2SMJmMOV32+Qp3hHwIIk+KVCpWRjm9EXIq1+zJIQUmTobalgNJhqgucv0nCvCjrURtWl5bl/cpKIcLt+Y2rXxWs0Ww=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20) by AS8PR08MB7743.eurprd08.prod.outlook.com
 (2603:10a6:20b:524::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Tue, 16 Sep
 2025 09:24:45 +0000
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739]) by GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739%3]) with mapi id 15.20.9115.020; Tue, 16 Sep 2025
 09:24:45 +0000
Date: Tue, 16 Sep 2025 10:24:42 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>, broonie@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, james.morse@arm.com,
	ardb@kernel.org, scott@os.amperecomputing.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com, mark.rutland@arm.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND v7 4/6] arm64: futex: refactor futex atomic
 operation
Message-ID: <aMks2haYCZia8LR/@e129823.arm.com>
References: <20250816151929.197589-1-yeoreum.yun@arm.com>
 <20250816151929.197589-5-yeoreum.yun@arm.com>
 <aMRQIeIdyiWVR8a0@arm.com>
 <aMfrR0vserl/hfZ3@e129823.arm.com>
 <aMhrscd1gz_syMtL@arm.com>
 <aMh4q4-xAPHnaOul@willie-the-truck>
 <aMkLb6jPiSbzeRWL@arm.com>
 <aMkqt1LMUd5QPc3S@e129823.arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aMkqt1LMUd5QPc3S@e129823.arm.com>
X-ClientProxiedBy: LO4P123CA0443.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a9::16) To GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	GV1PR08MB10521:EE_|AS8PR08MB7743:EE_|AM4PEPF00025F9A:EE_|DU0PR08MB9299:EE_
X-MS-Office365-Filtering-Correlation-Id: 359f9fe9-0cfc-4d8b-d7da-08ddf502f79d
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info-Original:
 =?us-ascii?Q?XhiWGXT/LUoMg2wKqQ1wPqSl3fQqC8+H/a8oPB0/PWF4JOpgf6UbfmQQR9pH?=
 =?us-ascii?Q?MBq+9ozl5J7TwapKtDV+vWLQK8jEEEYOaDPUvKo2WSzcAIDU2rOgGMEpqnLt?=
 =?us-ascii?Q?IXRDkWAD52Ih8+GX6h2PEwvrIEkf/DFHjWzGQM/FIGMztEcw2xGNf1zoY9MG?=
 =?us-ascii?Q?9sVe8fWWuTiwSOUR2OS7zbIG9ScDpxftS/aF/wYzplbBWvl7hVVbekkSQXtE?=
 =?us-ascii?Q?bZ9Z8VLm+cBTr5lOjc6+4YuU14nemqN9n4ehB4/wOj+qT7ydav989BWZ5wQg?=
 =?us-ascii?Q?dNZX/3Ywh4suKH+DDgMsRziqUKFzQG9CWaqcnkAluaV5jGXD84ifuxA35BRn?=
 =?us-ascii?Q?WFijj0gF6DNAm4Ai6qJBXEhqAauAHEN1FA2Pk5GCR9Rjs4IrFIppV98A15gs?=
 =?us-ascii?Q?k1pyLKHXGmCLU4lNA45JJfuGtyTxx2KG6+PU24wiwHl24EOGVJcJTSeF7A6y?=
 =?us-ascii?Q?0ZwVbBo+Poit64jt2X14R+/0//qK9uj5tY5FakFH+x0Y9zmpL41BdwIIL9wC?=
 =?us-ascii?Q?ZW+qd9KsACXEuC0Mo6qmH4VTj0hUVnffPot5qGyA1/IjQVaOsf4sRzsb7+PV?=
 =?us-ascii?Q?sCTxp8XmCEiynyKKSkBK2geiko6lpr4x+Rpiy9p/vy514vomodcnixeS3goz?=
 =?us-ascii?Q?Z9If5Kc4pC+HmwgioEPFRWMlpcdVb+1HwUiOr2hdA6NrzGfpJigJFQ8uYfl9?=
 =?us-ascii?Q?LDAJNqVmRuwAFMZor1UFiwLTLwsUuE6KOHrl3x26LYaT5q7e1qUfIuGle2fJ?=
 =?us-ascii?Q?GdiWiqxPKCi/H5C6rUzb6rSfugJIqUGL/0bXORFnz0z0HQY1WqOAEMJxJY9O?=
 =?us-ascii?Q?rAh3gZcowgz8r6IMf+Nr64HPAylT6/7GbxOXbHx31N+xOtmeAIZctxGZgKnc?=
 =?us-ascii?Q?ZyjcOcVGgCCTqzueVqOGiHNDGiiCE+48Nai/xiFAyNB4lVxLyq62kI1BIIys?=
 =?us-ascii?Q?5eoZnCWlRX8/Fu3fUB+yKcye/4Lfjwjc9bVt/3JEfB7ZQr60SMi7mlXewXuE?=
 =?us-ascii?Q?lstvEstuDWBtnD8Ixj/xupJ2r1VciYyet3bu3+TOm8Fc5QE9qYrAhQ+RQGeu?=
 =?us-ascii?Q?C6lHI67iuigpDHqVWf+gasY1S9aEsIhtoCzj8mIhKpVGt7zdYVFCpBlDSICY?=
 =?us-ascii?Q?8KRGHRUTD2ke/JpbIbQ1AA11CdptxJUhQbYtXLH70w2Rew/zwotpymd0x+3a?=
 =?us-ascii?Q?3Q6xdJ/sO7SxgrHmgZAixBA2HTbopuLFIu0ibjVoU9FYjVyl+5KkHE3GzzTc?=
 =?us-ascii?Q?aksz0t6KDjhoK2Zi/7mwmbM5k+NN0WniMSI+j48mtC0yHcCEwgP7N2f9Utq4?=
 =?us-ascii?Q?NbxtWAol4gsO2xUeW1uxmV+s9KOI0Su82e/wgtNy6rxapoCVQ8fd95yUElcZ?=
 =?us-ascii?Q?P85/41fJgNV0Jj99VdMjieaSh+XA+DRkF2hNG3Ia30L82uaSB8HNaZmvYhVF?=
 =?us-ascii?Q?8ArCuVfWkoE=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB10521.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB7743
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM4PEPF00025F9A.EURPRD83.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	02bce671-90b3-4da5-08d6-08ddf502dfc8
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|14060799003|82310400026|35042699022|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?b97DbTSvQ3gXeqgljKmigfiGKb6meSyAeMxKl1VlD/TIqYcKP6evZPZ1dNW2?=
 =?us-ascii?Q?V8YFECx16Oc4X2987CxbKFpufdZkyi22wjte4pL0EUDREsAtR5kT8kra5Mk4?=
 =?us-ascii?Q?q1+qIh4Ipy6dRlBiShFZR7L/J9pIP68eA8nyLo0zrT5YltE+tlpmvo8mnk8m?=
 =?us-ascii?Q?iIvGMUI1w++xc1zp3+xcnno0cY2iPb60K+W5FGal+DxFQBnYIYHKSZz2Dnfy?=
 =?us-ascii?Q?uZrYILqt7gkR7HkcKf8HNs31PSWrMXcMEHD34AhuqRID37eOhNj6VFeknkAU?=
 =?us-ascii?Q?Au1WYRaubpvgRnKGnoCkVgd0tZEVr1xlVIl9vOd1MEmiGqko3FDlgxrKl4PQ?=
 =?us-ascii?Q?AUeJ0khhXrbkAGDFy3MXetSEcQnSJNuQDDZ08uyDhgqLGbGCcyaclKtiw82t?=
 =?us-ascii?Q?7oGXmd8jnjkn9KIdIFU2Q6Qiml48chxlvx0WkOxXom8MdO5BGinIy4xQZEuN?=
 =?us-ascii?Q?scZQNv0SdfIoGt4xx3wWO4GFxntXzqMzYeHFAezWRWv0B1eor0hBlIq93QDd?=
 =?us-ascii?Q?5uymzHyzqXZAg8ocrAI7Ag671x/NNW/gwHKtL0gA8ZtIwp6vNEoiqke8KZ/H?=
 =?us-ascii?Q?Slb3aAq9r81zftWYQVcg0M6famFBETwf+4zC4NQ9k+7bvm+5ogjYnTcwkiZe?=
 =?us-ascii?Q?wsUcWcQRWfqCDW3AqiHnatEUSUtKdC3bdXXQGSnhOW1OTNeXaQ3K/JNrd1Yv?=
 =?us-ascii?Q?oPQsLccP3fRu+OWiQvSl92Aiwdy++O4M8uUjU2noKyDRF3uIT1xr79+Kl4F0?=
 =?us-ascii?Q?2AvmkOjgxdqGVqOpbPNCtGy2oj4003dkXUOY/djFTriWqQwqNJTm77fwcJOP?=
 =?us-ascii?Q?t1Ms/1kP4iqQdcekF9jr5wkkfer8CvJRfL3cjKDqeKssLXyQUiYLZjFXppIA?=
 =?us-ascii?Q?WdHWX1nv0TCvF0ic4nU1wtL/jepLDHtgnMhY1/YfJ8ewDJol+xNSIt+zAvWk?=
 =?us-ascii?Q?ZXL+0NCyboOS1pHywGTuz4QnnmcSvgUf0LRV0wAY7pm2EySn8Hk9AOYfG6tB?=
 =?us-ascii?Q?AlLNSyo6J8q3PFDBaZyWj0LlqAj8qjbwoMdAgLi+gHlKPP4SzOacNA2myRJd?=
 =?us-ascii?Q?3TMJXpvWKuNRQUT2B9jIOp+Acie+8MeLtgpYdfxAQmw9ozHD8Lu6GBIJ2y/Z?=
 =?us-ascii?Q?DeIBTeSiqzveQ/nIuTnaCC4LoZIZ98/iLAJIkBRxzlRKmxh0Hb6c1AxSeBC9?=
 =?us-ascii?Q?hOUtYVbumwEUR7JsOwzVcL2p+TiuzkEj1lAS/vpUIo3FIV2xi/vsudTbak9O?=
 =?us-ascii?Q?/jaO1yARCMueHGuUv72pL7zJR8qEmZAeSAR3pdAV/DLZqm6A0Ruu3N+qSrgh?=
 =?us-ascii?Q?VAAokG8wTwkVYu3vnE5ZACI5gDAsZ68zYOgn0/K/KAaRiOh/4SU22K+//7v0?=
 =?us-ascii?Q?isvYTXPe6ht0ca5oXvlVnk069YxjVBLAifUcAl7gSgnD53dWE2mKqh5kD3CC?=
 =?us-ascii?Q?zNITUFQFIpBo6yVX+HD/oZIA2XfG7SliXnjMZgoD2Jrpp4vsO71FlxjVer79?=
 =?us-ascii?Q?hkvsqD++WNm6C2XIcnP0GJoQmgz87fMfr+PG?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(14060799003)(82310400026)(35042699022)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2025 09:25:24.8554
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 359f9fe9-0cfc-4d8b-d7da-08ddf502f79d
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM4PEPF00025F9A.EURPRD83.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB9299

Sorry, Ignore this. I've sent wrong this :(
I'll send it again.

> Hi,
>
> > On Mon, Sep 15, 2025 at 09:35:55PM +0100, Will Deacon wrote:
> > > On Mon, Sep 15, 2025 at 08:40:33PM +0100, Catalin Marinas wrote:
> > > > On Mon, Sep 15, 2025 at 11:32:39AM +0100, Yeoreum Yun wrote:
> > > > > So I think it would be better to keep the current LLSC implementation
> > > > > in LSUI.
> > > >
> > > > I think the code would look simpler with LL/SC but you can give it a try
> > > > and post the code sample here (not in a new series).
> > >
> > > If you stick the cas*t instruction in its own helper say, cmpxchg_user(),
> > > then you can do all the shifting/masking in C and I don't reckon it's
> > > that bad. It means we (a) get rid of exclusives, which is the whole
> > > point of this and (b) don't have to mess around with PAN.
> >
> > We get rid of PAN toggling already since FEAT_LSUI introduces
> > LDTXR/STTXR. But, I'm all for CAS if it doesn't look too bad. Easier
> > I think if we do a get_user() of a u64 and combine it with the futex u32
> > while taking care of CPU endianness. All in a loop. Hopefully the
> > compiler is smart enough to reduce masking/or'ing to fewer instructions.
> >
>
> Hmm, I think sure shifting/masking can be replace by single bfi
> instruction like:
>
> diff --git a/arch/arm64/include/asm/futex.h b/arch/arm64/include/asm/futex.h
> index 1d6d9f856ac5..30da0006c0c8 100644
> --- a/arch/arm64/include/asm/futex.h
> +++ b/arch/arm64/include/asm/futex.h
> @@ -126,6 +126,59 @@ LSUI_FUTEX_ATOMIC_OP(or, ldtset, al)
>  LSUI_FUTEX_ATOMIC_OP(andnot, ldtclr, al)
>  LSUI_FUTEX_ATOMIC_OP(set, swpt, al)
>
> +
> +#define LSUI_CMPXCHG_HELPER(suffix, start_bit)                                 \
> +static __always_inline int                                                     \
> +__lsui_cmpxchg_helper_##suffix(u64 __user *uaddr, u32 oldval, u32 newval)      \
> +{                                                                              \
> +       int ret = 0;                                                            \
> +       u64 oval, nval, tmp;                                                    \
> +                                                                               \
> +       asm volatile("//__lsui_cmpxchg_helper_" #suffix "\n"                    \
> +       __LSUI_PREAMBLE                                                         \
> +"      prfm    pstl1strm, %2\n"                                                \
> +"1:    ldtr    %x1, %2\n"                                                      \
> +"      bfi     %x1, %x5, #" #start_bit ", #32\n"                               \
> +"      bfi     %x1, %x6, #" #start_bit ", #32\n"                               \
> +"      mov     %x4, %x5\n"                                                     \
> +"2:    caslt   %x5, %x6, %2\n"                                                 \
> +"      sub     %x4, %x4, %x5\n"                                                \
> +"      cbz     %x4, 3f\n"                                                      \
> +"      mov     %w0, %w7\n"                                                     \
> +"3:\n"                                                                         \
> +"      dmb     ish\n"                                                          \
> +"4:\n"                                                                         \
> +       _ASM_EXTABLE_UACCESS_ERR(1b, 4b, %w0)                                   \
> +       _ASM_EXTABLE_UACCESS_ERR(2b, 4b, %w0)                                   \
> +       : "+r" (ret), "=&r" (oval), "+Q" (*uaddr), "=&r" (nval), "=&r" (tmp)    \
> +       : "r" (oldval), "r" (newval), "Ir" (-EAGAIN)                            \
> +       : "memory");                                                            \
> +                                                                               \
> +       return ret;                                                             \
> +}
> +
> +LSUI_CMPXCHG_HELPER(lo, 0)
> +LSUI_CMPXCHG_HELPER(hi, 32)
> +
> +static __always_inline int
> +__lsui_cmpxchg_helper(u32 __user *uaddr, u32 oldval, u32 newval, u32 *oval)
> +{
> +       int ret;
> +       unsigned long uaddr_al;
> +
> +       uaddr_al = ALIGN_DOWN((unsigned long)uaddr, sizeof(u64));
> +
> +       if (uaddr_al != (unsigned long)uaddr)
> +               ret = __lsui_cmpxchg_helper_hi((u64 __user *)uaddr_al, oldval, newval);
> +       else
> +               ret = __lsui_cmpxchg_helper_lo((u64 __user *)uaddr_al, oldval, newval);
> +
> +       if (!ret)
> +               *oval = oldval;
> +
> +       return ret;
> +}
> +
>  static __always_inline int
>  __lsui_futex_atomic_and(int oparg, u32 __user *uaddr, int *oval)
>  {
> @@ -135,71 +188,25 @@ __lsui_futex_atomic_and(int oparg, u32 __user *uaddr, int *oval)
>  static __always_inline int
>  __lsui_futex_atomic_eor(int oparg, u32 __user *uaddr, int *oval)
>  {
> -       unsigned int loops = FUTEX_MAX_LOOPS;
> -       int ret, oldval, tmp;
> +       int ret = -EAGAIN;
> +       u32 oldval, newval;
>
>         /*
>          * there are no ldteor/stteor instructions...
>          */
> -       asm volatile("// __lsui_futex_atomic_eor\n"
> -       __LSUI_PREAMBLE
> -"      prfm    pstl1strm, %2\n"
> -"1:    ldtxr   %w1, %2\n"
> -"      eor     %w3, %w1, %w5\n"
> -"2:    stltxr  %w0, %w3, %2\n"
> -"      cbz     %w0, 3f\n"
> -"      sub     %w4, %w4, %w0\n"
> -"      cbnz    %w4, 1b\n"
> -"      mov     %w0, %w6\n"
> -"3:\n"
> -"      dmb     ish\n"
> -       _ASM_EXTABLE_UACCESS_ERR(1b, 3b, %w0)
> -       _ASM_EXTABLE_UACCESS_ERR(2b, 3b, %w0)
> -       : "=&r" (ret), "=&r" (oldval), "+Q" (*uaddr), "=&r" (tmp),
> -         "+r" (loops)
> -       : "r" (oparg), "Ir" (-EAGAIN)
> -       : "memory");
> +       unsafe_get_user(oldval, uaddr, err_fault);
> +       newval = oldval ^ oparg;
>
> -       if (!ret)
> -               *oval = oldval;
> +       ret = __lsui_cmpxchg_helper(uaddr, oldval, newval, oval);
>
> +err_fault:
>         return ret;
>  }
>
>  static __always_inline int
>  __lsui_futex_cmpxchg(u32 __user *uaddr, u32 oldval, u32 newval, u32 *oval)
>  {
> -       int ret = 0;
> -       unsigned int loops = FUTEX_MAX_LOOPS;
> -       u32 val, tmp;
> -
> -       /*
> -        * cas{al}t doesn't support word size...
> -        */
> -       asm volatile("//__lsui_futex_cmpxchg\n"
> -       __LSUI_PREAMBLE
> -"      prfm    pstl1strm, %2\n"
> -"1:    ldtxr   %w1, %2\n"
> -"      eor     %w3, %w1, %w5\n"
> -"      cbnz    %w3, 4f\n"
> -"2:    stltxr  %w3, %w6, %2\n"
> -"      cbz     %w3, 3f\n"
> -"      sub     %w4, %w4, %w3\n"
> -"      cbnz    %w4, 1b\n"
> -"      mov     %w0, %w7\n"
> -"3:\n"
> -"      dmb     ish\n"
> -"4:\n"
> -       _ASM_EXTABLE_UACCESS_ERR(1b, 4b, %w0)
> -       _ASM_EXTABLE_UACCESS_ERR(2b, 4b, %w0)
> -       : "+r" (ret), "=&r" (val), "+Q" (*uaddr), "=&r" (tmp), "+r" (loops)
> -       : "r" (oldval), "r" (newval), "Ir" (-EAGAIN)
> -       : "memory");
> -
> -       if (!ret)
> -               *oval = oldval;
> -
> -       return ret;
> +       return __lsui_cmpxchg_helper(uaddr, oldval, newval, oval);
>  }
>
>  #define __lsui_llsc_body(op, ...)                                      \
>
>
> This is based on the patch #6.
>
> Am I missing something?
>
> --
> Sincerely,
> Yeoreum Yun
>

--
Sincerely,
Yeoreum Yun
