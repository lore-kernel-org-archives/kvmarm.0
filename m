Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011022.outbound.protection.outlook.com [52.101.70.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C1FB279323
	for <kvmarm@lists.linux.dev>; Tue, 22 Jul 2025 16:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.22
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753201201; cv=fail; b=H7YfK3FtcZ7GuIKEw1e4Lt8j2avWrHmZfwz0mCkgVZtpFG8Up2kPsBTTUTjFMdPBvROzLpN5CD48D+N4DJvZhqhBNA0C7Kq4v2nVC8xLYLnG2x5J86ijFsi17VXcZS9WnBk0UrZI5bXKr4uj2tQmJGa8zM89vPe4o2yl5wykypw=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753201201; c=relaxed/simple;
	bh=0bEBjF9tHyjLrxtbYKH/gj5/rUobN3hy1mAWLm5M7Jw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=AOLrqD8q/Kd0djz5WeORH8Kh0X8kRuh9+K9AfURl2QLYZSqyyIBoaG2y6HycL5y3Dm84+UouFLfX7NP4IWy3ZZxHLM8T2Fns1D5wIX+8FTs8ohWVqBavLcRKi2iyh2eMQZ1BSLLcJVmDPkgstnrTySvjbjCqN1olMnfPXXfPFF4=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=iVgMQuKK; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=iVgMQuKK; arc=fail smtp.client-ip=52.101.70.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="iVgMQuKK";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="iVgMQuKK"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=NR4ZgD0O+NOnU4N3AzKDO4j74VKpNv3mJ0/LnZ4HpYVNfQg5/XYFFZZJ77cqPQp7K2F/09/LOfA+CdDsT6op9BDny3s1VjqwfPuBTQLybknrGyX0Zp9dLf58gR/z8Jv/j7fOm4/vfl/Ple1Cq0vOz90tKmLjXFi5nUjUL0fzYTSTzPUSN3B0WYjaHZ3ncetxknpsPH9u2oEk2YfGQ0F2AsPoLgJhdsM1eqLm66IlPlvn8VA+d3yLwRYDZmdiJ33GkDbSrC+QbOOVV6CVUk3lh05pqQoo1E1h/tvqYisKhCxpVthwaOh651QbW+BqYhlMwEFFGsSQtAUpqM49OH3OAA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HuIUosiFEo111NEj6W/T4EyfgPKN1hp8SKhlUh7Ql9g=;
 b=VZM6m8nFighGvIRzaJfUvPTxUuONrevsMbubalF+Te1UUdWAWZ9FukRtIOiL0Eb99/TJfNY5Dk1vjd9LvU6nOqf7wXJFtHQhrVfdoAGzJv/g1/pdxodTf7vx6tRFcjfdwKWi4NI7oDcnk3GAkBmU7Wjl6sCujxalD9sQC4qTFNS/2KYuFAhVLvonVISxA2isnHLAOvD+ddXdhDdQW5ilOCDPc1zjCej42khck50UIpMt7AkrzCMbJz96iWFF+7jJhnx6JSpaoBMBLdcr3iA6O4FGptiWYe67iqI9QZyHAkoGkxdumFhna2eGZ2up1kmDxsaB8xDeGiKMamD14qLf3Q==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HuIUosiFEo111NEj6W/T4EyfgPKN1hp8SKhlUh7Ql9g=;
 b=iVgMQuKKnLl8zTIYxKoS3Hcl/rauGh0a/L3Bo/1tz7WFCruUI8QU9XMBcx2Jd5veIXO2feu1+ADlEjVYuKlXV3LSsr9FsaTGOrZPQJGlwCXFYMX5C/GTPkJ3gAzsALT0Z72H/N/LBubaq1x5rloXnimzV/wxZLSzF2Gcoe66fyM=
Received: from AM5PR0601CA0063.eurprd06.prod.outlook.com (2603:10a6:206::28)
 by VI1PR08MB5518.eurprd08.prod.outlook.com (2603:10a6:803:13a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.35; Tue, 22 Jul
 2025 16:19:50 +0000
Received: from AM3PEPF00009B9E.eurprd04.prod.outlook.com
 (2603:10a6:206:0:cafe::d2) by AM5PR0601CA0063.outlook.office365.com
 (2603:10a6:206::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8964.21 via Frontend Transport; Tue,
 22 Jul 2025 16:19:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM3PEPF00009B9E.mail.protection.outlook.com (10.167.16.23) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8964.20
 via Frontend Transport; Tue, 22 Jul 2025 16:19:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z9G7uH0MLWN1yvnMTgcKUqrHbmlQqiqhqgq/sxCSNKgJVRxHFBEsItvhmWH7t7x8CfYrLW851wB+8TV2PCruJH+uLtdpI9gMk224W04ZSMIjkh8rXBtgZh1sShD0J1faHhntbCUaTugJeKnj10ghsRQInEXBKGPbQ9knws3NGkfZi7TVcjd5T9oswB6VI6KalMbWwGHtIdbGRl87V6WkJ1wi9hYGWuxHDE/TpGTSASobBpLZZ935gtMX7RJSeh+Tb0Cgl/C9e1OKoNL1WEjBTeC9+ofxftB66fH4cuHddkuAEh6Qz6o+p0DBEVvUZU5hZ3phfasvWH/HRA/3C6bOPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HuIUosiFEo111NEj6W/T4EyfgPKN1hp8SKhlUh7Ql9g=;
 b=kgoEXkBteahFgIaRpuIQXRb7kp1fsO4YluG4y1joCzLtdXs1YBynhDvgX13BmAov1f3Yoy0kpAVqrJxmLsXjo0I2GsX0Lyfr+yuGpJchzAOvxkD5+FgbgiIoyx+f4VeeplFkmXjDVXCxZ2UgcC1iIz2D4tM1h24ZDgYgnA+nDDGbQexMl9mB+wJ8NVwDq5spZLGcKRioVLIaLT9a+Pt6130ElLt+nVubr98Z4Ef+zDCGDswignl9f5b1dGcZDSlUhKoqkAv/yGem947hePd5CDC5MY4kyNrhmyu+P0VL7xhIkMh8/rtzYtmGb8kuGvW3KSUpsKtM4mkJqJGZM87f2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HuIUosiFEo111NEj6W/T4EyfgPKN1hp8SKhlUh7Ql9g=;
 b=iVgMQuKKnLl8zTIYxKoS3Hcl/rauGh0a/L3Bo/1tz7WFCruUI8QU9XMBcx2Jd5veIXO2feu1+ADlEjVYuKlXV3LSsr9FsaTGOrZPQJGlwCXFYMX5C/GTPkJ3gAzsALT0Z72H/N/LBubaq1x5rloXnimzV/wxZLSzF2Gcoe66fyM=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20) by DB9PR08MB7445.eurprd08.prod.outlook.com
 (2603:10a6:10:36f::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.30; Tue, 22 Jul
 2025 16:19:18 +0000
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739]) by GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739%7]) with mapi id 15.20.8943.029; Tue, 22 Jul 2025
 16:19:18 +0000
Date: Tue, 22 Jul 2025 17:19:15 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: catalin.marinas@arm.com, will@kernel.org, broonie@kernel.org,
	oliver.upton@linux.dev, shameerali.kolothum.thodi@huawei.com,
	joey.gouly@arm.com, james.morse@arm.com, ardb@kernel.org,
	scott@os.amperecomputing.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, mark.rutland@arm.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 0/5] support FEAT_LSUI and apply it on futex atomic ops
Message-ID: <aH+6AzWkVbbfg9ZY@e129823.arm.com>
References: <20250722121956.1509403-1-yeoreum.yun@arm.com>
 <86ikjk8efp.wl-maz@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86ikjk8efp.wl-maz@kernel.org>
X-ClientProxiedBy: LO2P265CA0506.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:13b::13) To GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	GV1PR08MB10521:EE_|DB9PR08MB7445:EE_|AM3PEPF00009B9E:EE_|VI1PR08MB5518:EE_
X-MS-Office365-Filtering-Correlation-Id: a2439a7c-c775-4959-4f2d-08ddc93b9595
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info-Original:
 =?us-ascii?Q?PK0E1CYpx/ORTIbWvVdDcHu+U6UTuyKENpD9JwBUwycOdbjl84evN1WXYWzP?=
 =?us-ascii?Q?UwgPoFWcl4vRM1RNSA5Z2IVMvqd5d09ac46ypEj+RcIaubccbpBlYphEGqzt?=
 =?us-ascii?Q?PBoaZjX6FWvt6sQpCLyU/yMR1hEWFeNoY5Wxe5sQNuH8cGDwl5/GNndlxvkW?=
 =?us-ascii?Q?RmfnxG/SPCTAkxIYyY0f81GoMb4Y3DeEaBTtEQLr008q7LnjisZG2Ny89Gjj?=
 =?us-ascii?Q?w2/ZYpMWVFieSkb15xPdczRafJ3OaurM15tEtXSaeUp2+KUr/ek+0jRSj6XI?=
 =?us-ascii?Q?W11HjBLP0C4Jze52V2r3uCJEga5sRge0OIYHzYjdgVcD+PvrHY85wNWqSOV7?=
 =?us-ascii?Q?tnUX22kylryhIC7A4WhhDpAiVuJMI2XLRc0f0KH3sw3bPcR2K9KKGiKl//DG?=
 =?us-ascii?Q?/03Vw6PVdhKPDqAFwbVKI7IClKnxQb2sESe/ox0vEGkLQDf4FALZ4sUmg0El?=
 =?us-ascii?Q?rx2AiqVq0DBqWkD9YpiValuFuVUenCVW/WdLc3bnfFAUqqxj8XmD76e/F6Oq?=
 =?us-ascii?Q?BKWyWcdg7Uqru4eupgtscid/Wm0+EeaU4QUcV43K2IUIelrf0cnqt4WMfpu7?=
 =?us-ascii?Q?ygnNTq9uRRfG0NNZQAgjx1ffaRn8cO9fw8Bq769JBOawF9Adej+7/L297mN9?=
 =?us-ascii?Q?2MDINOXwyy8vjOYr7bV4SpZBjst8Q1GNGPCYbOoAWYiW9sMnZXXOiLnInJCW?=
 =?us-ascii?Q?N8nvihdUq1b9tYA2cYkBuR7vuyGk/1MaB6TW+PmWUj1WqYjKfcqGP647xHCq?=
 =?us-ascii?Q?asNtU5Jq5rlxfuLlKbzwl2/7+vcqUyvboNxsrZcJz+rriTI67V8RZakrndJx?=
 =?us-ascii?Q?fvJUSyB009zzDA4f7s+6SaCLJNxWQvV1dxrRxuSkq8AgFsBZIt60lD+Ill7e?=
 =?us-ascii?Q?tJw2qjxqPzBm73wUOL5a4/iyudvi95k+rVG/V77Ii56n30ufWVBFBmS/BHUo?=
 =?us-ascii?Q?M7f+3D3K+OCpPEGx3TfCdvCu744+J+afFgIpC2e2/jHw33oAf+kl4syd5aul?=
 =?us-ascii?Q?2OEKqm+9NVIqaQOUVDi1cVgjAgzLjKT5Wl9Q3SJyVyGh+2BLjnQw7qmaE/bI?=
 =?us-ascii?Q?DyRkOGQquDk+LMmxO5DnewWyt+SH1KAVYgt+2FEI1AgJ/xRK9sO0Er+q6YMK?=
 =?us-ascii?Q?4iMqGnreUs/JbY4avAiFg8URvVOIMnCPndgtzLt4XGLMWg/Y+HPNJ53lDCTJ?=
 =?us-ascii?Q?4teI8VY7ySrUo1T1yMoGAGw1ettZcJSFwcGGZrhSiptWfsV+k1tggu4FVpt3?=
 =?us-ascii?Q?rK9DFPl7rpr9x3OR6bSj21mnm8R7MnkSy6FepTV3om1lA5K7y2sc80FuL/mw?=
 =?us-ascii?Q?+niWD+KIhzIS1YLoz8EYIsAmRGlOs/+rMlPEvn2dWU5ZmwS4rALAkVvPB1rS?=
 =?us-ascii?Q?2KDasxfrznOEWJkjPQLON2YLKppqdMn0wHro56WZaBej7P3kxyLxVwb3tvO6?=
 =?us-ascii?Q?YgeTzrhzljw=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB10521.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB7445
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM3PEPF00009B9E.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	bfd0b67b-f77f-46e7-c6af-08ddc93b8205
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|30052699003|35042699022|14060799003|7416014|82310400026|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?4H9IjK7hB7OHmQXPe/dKXJkLMeGnfLopZup4yw9LGjF34Q7GpoGBgKJJeFyd?=
 =?us-ascii?Q?emnzGLTH1Ly2UbFwKZT661WMDMclmtu61abw4TARzAQntMffvl1ErkK4trzq?=
 =?us-ascii?Q?04jUVMFYcPLvq3gCNUFj3hPj/PIAZYOo17JbZXykSx6QcTYCFJdv8ZkKPpXB?=
 =?us-ascii?Q?wjdUC7C8nDSX2BkbgSGvpjOPIHqQ0kGYlIZvdgPPO+EmsUl7y0Zn2AIjfIcX?=
 =?us-ascii?Q?CpMbQuvY41b2J8hO8m0BjjKMTVOoPTbhAAMyk28wD3jP4DVSDWttk+E1f6bJ?=
 =?us-ascii?Q?PICYIP4mNkasv6tcfgvncGRv/pSAF2fbRPw9++qkK4RaJ34oEHRWcqHfv6GL?=
 =?us-ascii?Q?oN6vLuKWdyB1DwhzZwBT2F51opS3hjqyF/mOwUf2geO9yQLXBrKO1XIQ5aYz?=
 =?us-ascii?Q?wu0Z/DLzpa9LgZ2YwXcrc5s8w/nRxJLXlfNdHeTOehppzE39sO7ltNEi4JIZ?=
 =?us-ascii?Q?cHsmpjBM+jmkC/apkBubP5JaoLAh1Av5N2SwjeDA+c5jr34BQ4V1OotbdNTo?=
 =?us-ascii?Q?Qw400CCx3SYxLXDXZBGBtKjF8BslzCrI5sVZ8GOreTksgrdEWZVcO/UFxNk8?=
 =?us-ascii?Q?2gyOuSVswUXSBCZKVweGqFGqDvnTDmnpXtaPq1FTFY+flWGjKYc374AO9bSM?=
 =?us-ascii?Q?GVxiXLIA5Oqtnbmfj4uwZgvJj6o64ugCXt9Wpb6qtLAOayh4DH9CnUTFdgnF?=
 =?us-ascii?Q?JAqls+shfR8WLzLufcH7aMhjEW2OnBZi11lqPWhFXi0svCiDjT6ko2t0I5ZU?=
 =?us-ascii?Q?l98Gw/0VUcgGNX09OeGZRbS3UfUqetUvThPUVjl/xABw3iw2rpx0YTYIWsdw?=
 =?us-ascii?Q?ThAQUpuozjLvRTo+jc3llHwIu9yQpZG6WQvwiHkMKhJkqO7hx5AzXbq27/ND?=
 =?us-ascii?Q?72KAsW3mYsBjVEhtaHVwE9LlY1OtNVwUvqg8u3KiL67c8vodu+/z8MqmzXch?=
 =?us-ascii?Q?Zl4FmKHEZ+RvZ0zJwgGyvLfxAlSQCY0Cef3HtzRU5nS0PusubzHJNcSUMfu5?=
 =?us-ascii?Q?CTuCdpIpuvg8Vm8UmpRRoN4MKMRPtsh4u4i8Hr3i1vBCvFJJZH6C7os2iKaj?=
 =?us-ascii?Q?wJA3UUrDr1U+lmgEhkke8M28UOMVlgTzQyNlcgt0YFNIPukrIb2K40QT5KWE?=
 =?us-ascii?Q?J1Q+YCmGkzcqFKn7Qm9y0W0bMHm2h3j/jcNdMMWkawLnEuUwkvCti+NvV9VK?=
 =?us-ascii?Q?g28rwqJAyRv7k0I28vSdZs+ydsAK98Wd79L5fIvxi46C2v8NxVA5JWNVb9NG?=
 =?us-ascii?Q?G/mQZgQkqgkxZo5oZsNHwwgv/le/2/2kMH6TZU5FCXMGBD3iII1nFEnMXUsi?=
 =?us-ascii?Q?Ibn46aK7Hh7WzRMwDGM0Qhs1YKcXYEMKwgX1NS3zJTvgenO1MbxUGXL7F0+/?=
 =?us-ascii?Q?ntwSoI0HjGlrUWJVa/05K9moCBd18N8yPeXcbJfYktOV2TqjXbdehtp3p3DJ?=
 =?us-ascii?Q?ilnyK6u7zsN9DAC8/2zSwIclwalGGNkJykNByUkCkCYswmUnX3AKXD532wEd?=
 =?us-ascii?Q?GW0KEd79STqZRd76E77MaM6A/4vlpvJs0289?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(30052699003)(35042699022)(14060799003)(7416014)(82310400026)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2025 16:19:50.5373
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a2439a7c-c775-4959-4f2d-08ddc93b9595
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM3PEPF00009B9E.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB5518

Hi Marc,

[...]
>
> Please give people a chance to review your series without having to
> jump to the new one within 48 hours. If anything, it actively prevents
> people from reviewing it (why would I review it, since the author is
> going to post a new version in a couple of days...).
>
> Also, given that we're >this< close to the next merge window, I don't
> think this series is likely to be a candidate for 6.17. Give yourself
> the space to polish the series and look at it with a critical eye,
> there is plenty of time for 6.18.
>
> Thanks,
>
> 	M.

Thanks to let me know and sorry for being impatient ...

--
Sincerely,
Yeoreum Yun
