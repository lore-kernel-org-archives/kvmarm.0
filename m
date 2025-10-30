Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013028.outbound.protection.outlook.com [40.107.159.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 635EE25784E
	for <kvmarm@lists.linux.dev>; Thu, 30 Oct 2025 13:49:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.28
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761832154; cv=fail; b=OHMj0XOGsLgT0gKQ3Eb1kQ/u4OX9tuQWIrYFrl0sy6cx7hj/BuOLP+AloEiQugi2N03R+FTkxnTzUeRX9CHTV2KOwSAZcDaNhZwIzVmDWCwvosLIgXAZsOmo3Xu8DBKtC50CYFfDFL25dumVODy9HJ+ynnzTlpTPDy7Y4pHQVqE=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761832154; c=relaxed/simple;
	bh=4+XoSwm+LRDXQ52mdNPZVCGKviW4NpLrxpJXlfGGc8Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=HZh+qN2R3rVZCcYrzGcrLLRlom9ChXvWMDgonE+UKFhOjgV7ySJgY7o9yaVouBsfoUkCg4G1oMZhgZXO93/Eu/8PTvLc3OTopcbyNgekyARqn5KVPFncX6L3+gAiHziyUDp3PSCuX8v8x4Ppsn1Z/iva3WM2iLbIxQEuRra/ijU=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=YtpZN3eu; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=YtpZN3eu; arc=fail smtp.client-ip=40.107.159.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="YtpZN3eu";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="YtpZN3eu"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=TMyCMZbihvpHqyBM6Z59Xk1zP0qvx4O1uZRa3ajQdK4693Bb5wyRBp8QYAhZazSODuzqSSCL0E+GM9XBahaA/C3Th6HiIyQ2Lo66GxBGwM4N2lvaH9nR+5GkZCmNQMD5GauPF0I6yC90tloAV1g2+TMhZakfSQUEXflwbFjtE59n899VFIQjgXv0BkDCSyX4cVZTOXxeJpycNT2yC2yTVjlRnSos0mwrppI3n1YbePuKFGGflmSZliVgU3UGTyNPCpfWuyiF5zoIHht0R/w+ttS/Mk33iBHcGNzgrgfMRJge18ZCzXSFOOyebLdy4h/vAuYdBTbeH3f5m68mvNVuNg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KZX9JIFHOEw/quVdGDM7dM0r4NGguMcHFu1OwVxQXvY=;
 b=mwxvcCdVaOsS9xrOULVJKlx9jhTxnxY78dWICwNVHTKpvlkyYqkN+tLtIIHqJmxZ7zGuBiqnzF+7nEXqf981lahSNsODR/adCuV0RgFeeyk40h9IJqRLl+71e2yr5p1a0kM+H3JGnXZ7D8gNJpb+HuXBExlhtY/i2fmxLpUzMRCQzEmrot80kanCMLggPHIztSXPVF506w/iu+EtixX2zX6iDCxe7fRjL8iNrRHZngbPg6jWSKSPKHUhcB4RZygWkFZnoByYeVGqa9VxQKLICqgwWXd1sGsu1Z5aXoxtVHdAaWntmBTkUFw4Q0fjiYPc+M7Jd1EAB6Sib7M69+NXhw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=google.com smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KZX9JIFHOEw/quVdGDM7dM0r4NGguMcHFu1OwVxQXvY=;
 b=YtpZN3eub4nwf+T+tXuC0R0Lzz8+TY8Ujo0tcJwW4J9MPhh2PH/TQ/DPIW05sWZn+D2OMfvVq7H9vXj1ZUdu7xQACEBHXUtBKXwM9DG2X1t/nsqMWCs912dvQI67Whcqa60H/MPWPqlIqwKcQxJ6o18NeTRJD1w7J0TGIPEd3OU=
Received: from AM0PR02CA0129.eurprd02.prod.outlook.com (2603:10a6:20b:28c::26)
 by AS8PR08MB7306.eurprd08.prod.outlook.com (2603:10a6:20b:441::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.12; Thu, 30 Oct
 2025 13:49:07 +0000
Received: from AMS1EPF00000049.eurprd04.prod.outlook.com
 (2603:10a6:20b:28c:cafe::1a) by AM0PR02CA0129.outlook.office365.com
 (2603:10a6:20b:28c::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9275.13 via Frontend Transport; Thu,
 30 Oct 2025 13:48:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS1EPF00000049.mail.protection.outlook.com (10.167.16.133) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9275.10
 via Frontend Transport; Thu, 30 Oct 2025 13:49:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uJI4TEaNQtHt9HhGL9bPAR/2eCxQRmx1i/bvVaF7lxt57tVVCTnN7bwbJcBDnIc4hERVSMZq6ndxCGZ02gjEk+NRFDXQcZtXas0a8bqKh093kNWa/x1U+ntD7Hc7Jjtcx0NzXnf9IAUSrkCVwmhRSJl3c2i42DJ4B3r34XbTuPKZMhEd5WXE3R5c6MXGxHdd1HQnixwAJ3SboSX0h5QdauOBTSuSM6XEx7S1t+0CIQ4cCaQRGjrtUl0DqCUFtEEt182V65SlxJeX+V/CQohXfOB3nxR48sFChlG/p5l9d09lrwv1WSkCXtEMMchgHIKgc71SvX87hl9/Jq19Wvmw4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KZX9JIFHOEw/quVdGDM7dM0r4NGguMcHFu1OwVxQXvY=;
 b=dn9xCAdq5ESofXWphEQGH/BE79iib3uSAPVS1XpIAE5eq3Kc5eCaAj59+OlXO6Up24WIK1CDbO9ylGgKHnNTVw1M4bd7c9dOqgJucwUh9iebgyLRyJKqnrZb6Mj9V3Dqk8tjM0NjbWfdq2YvR/No/QB5yoC1E77+rFxuxEVQ7NZ1EH72BalCp5sOalN+K36Z4FxUVqdvnMfqJQOaSuyY8hyNXNv0GQ5YTrXEJ7TOk7zjz2+1KZPSgzXeiIMnyxrf/w+o7aU1bHk/HeXBG52ilAubMq96RkgF8seQBkL+PyMqNTS9+66NJFWMSAtGjvcPp28KyQeEko1b7+aXlULcsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KZX9JIFHOEw/quVdGDM7dM0r4NGguMcHFu1OwVxQXvY=;
 b=YtpZN3eub4nwf+T+tXuC0R0Lzz8+TY8Ujo0tcJwW4J9MPhh2PH/TQ/DPIW05sWZn+D2OMfvVq7H9vXj1ZUdu7xQACEBHXUtBKXwM9DG2X1t/nsqMWCs912dvQI67Whcqa60H/MPWPqlIqwKcQxJ6o18NeTRJD1w7J0TGIPEd3OU=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20) by DB9PR08MB7651.eurprd08.prod.outlook.com
 (2603:10a6:10:30e::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.18; Thu, 30 Oct
 2025 13:48:33 +0000
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739]) by GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739%3]) with mapi id 15.20.9275.011; Thu, 30 Oct 2025
 13:48:32 +0000
Date: Thu, 30 Oct 2025 13:48:30 +0000
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: perlarsen@google.com
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Ben Horgan <ben.horgan@arm.com>,
	Armelle Laine <armellel@google.com>,
	Sebastien Ene <sebastianene@google.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] KVM: arm64: Support FFA_MSG_SEND_DIRECT_REQ in host
 handler
Message-ID: <aQNsrjceYM3RvY0e@e129823.arm.com>
References: <20251030-host-direct-messages-v1-0-463e57871c8f@google.com>
 <20251030-host-direct-messages-v1-1-463e57871c8f@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251030-host-direct-messages-v1-1-463e57871c8f@google.com>
X-ClientProxiedBy: LO4P123CA0607.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:314::9) To GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	GV1PR08MB10521:EE_|DB9PR08MB7651:EE_|AMS1EPF00000049:EE_|AS8PR08MB7306:EE_
X-MS-Office365-Filtering-Correlation-Id: 4c27a49e-b18c-407c-4016-08de17bb1826
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|7416014|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info-Original:
 =?us-ascii?Q?7oKWTuLl0cfUj8gNzjHyTXV41KoAFM/l6f3WaY+qnyApYj+BQ+DX284wah6O?=
 =?us-ascii?Q?gejhCjprrxIJBLzjyuJJYFCm3//9Hw4/JOJ7ohv7lqQxJePZdMzVmONS5tOb?=
 =?us-ascii?Q?JBhp7Toeg+UoxdzP+RkcjPRfwgSeih7UmJuvK2oDcp/QDLn4x50/uWH+KlWT?=
 =?us-ascii?Q?vcBSlU9l+e1H/VonyeWpu3muxOFc3S05RUzrbNWIbpehHD9KHkv6QhCMigNp?=
 =?us-ascii?Q?v31RB2JozV7YIq5sOy1mAVnu/yHQr4zTNuFY56ziDMHas/QpAMfE/JUF99tr?=
 =?us-ascii?Q?QmwrLlk2tfYCW5Gefb5tWXUlyKKYOhvFmsttGhDYuHHoDhOcqx2K1vODjTaF?=
 =?us-ascii?Q?3i30PejxKSIR1ICH2qTo3vFOVLXJmcACvie8CgyaYqzUh69/DpP7NLPjElke?=
 =?us-ascii?Q?G0xNGmjzNyYhBYg8piQFgjEXTtCmleFnDer2LF2wuiHrPumWTm7dh1s5VA1E?=
 =?us-ascii?Q?f0HpntVuhYbFs2FpGJ1Qyqbv4N0vepYKqbYFUO2KLm5G3zBN9vQ/eVkzE3Zq?=
 =?us-ascii?Q?AH+EyWGCHGz7BxoCpABzGmmNqjb8LUEezh2K/iTcjOKDpaCxKwQ/WlXxBxAj?=
 =?us-ascii?Q?wEq7hN0kaPxXkv+fl3ASsfOq6C0xIdVl47GL1A4trynzzkdcitUq7SeyGrLH?=
 =?us-ascii?Q?+dYa3Ej5Zd/ekFwJOo1uK23GXoZEnLwK9hpdDsPwdiEGFykcn8AXHiTrNAyX?=
 =?us-ascii?Q?eqtg9oU7DQ5zJI7psUXQ7/93MVSviguAIgCwZqtZ65DWPWSYjOgytktwz+pM?=
 =?us-ascii?Q?DKoxauHnhnHuM5QsKuvkEjzkCGmphnRgjpmaZZK4+JCTc/+phXCrYv5EyhRa?=
 =?us-ascii?Q?N5fofiWpwrHWBEkDn/WEnSHMhq4hximpZ80EnEBcRnwymH3CXptwnDbkOnIe?=
 =?us-ascii?Q?aCHWH2PLDxWFyC1MERKPUCq9HP0Y6yR1cBh2kLD7la6ZC9BiCa4TDoBvX4Ca?=
 =?us-ascii?Q?1feqYrd4NJxhiAol0ysjThiO0OQRj62Byy7+585UJB2yYbEhZv9pAZnU3yJW?=
 =?us-ascii?Q?/rFPUDLUoR9B5RIXJZ0eCKNVZShS5xDXhAPGUDHCm+jK/1digtHDghDlg1ch?=
 =?us-ascii?Q?oENz7LCzU2wkrTa6kOH4lpcTzgpae0eA7btvUZzTR0rZWkgRs3shijRtTiL8?=
 =?us-ascii?Q?maxcAs3M+5XGbKtBi1Ysls0caSKBXQnK/fT3AOL3C6ZGz5acKhTHQw5ioMtT?=
 =?us-ascii?Q?1BBw/nBbL3Z4A4k/mbim9gehmD3h7Q9rsK7P+RjkokuRpotVGkkgnVSdA8KW?=
 =?us-ascii?Q?7+xzjYYeJMXZi/Lq70Y0YZxyiFSkrzgNo4cx2QIqtnHus1KG9MLHWT4ZRpIK?=
 =?us-ascii?Q?DE2Ortz8lJyFBuLgELZIs7XFFwwGrsmInolfgDaTGCXQXfwFxXXakuuGB+GH?=
 =?us-ascii?Q?KdIcSZZ6y0RGvt/VeAxuDofRxM3esIjIir0EFB6zRU3arIX1NKwV5f3Dp0hb?=
 =?us-ascii?Q?geTh37+iD9g0o05IZ8lkHUiv1xeOUTEQ?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB10521.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB7651
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS1EPF00000049.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	fd1c9077-0109-4dcb-304e-08de17bb0402
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|82310400026|35042699022|36860700013|1800799024|14060799003|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?+G1l5yLnRS24O8CyX30jGvYwhYGwSsD2/wVWIR3XTsqd7lBMk8dtB4gM4STa?=
 =?us-ascii?Q?0yiLFl7xzkgaNWV3NKZyRXVWSETzKyKxbBZgS1P4HTSQt8gVFEibSxBa4xD3?=
 =?us-ascii?Q?Magx17f8AmSplBWHuPDoGhWb4ZMhQgYiafvECZV7omkL0XWVGzxJbB6SBHaG?=
 =?us-ascii?Q?gTkK+oQiSFHT0YkUf8c6wH9VKLTwgbD9kYSM6fm0LWlQHHJuzfqsNZOGn+pR?=
 =?us-ascii?Q?ueuI40N3352D1w+ogYtAWEQGKBMEOLnBgv8Wb8xT/dhSbn0WbxZwi/ZFgj0N?=
 =?us-ascii?Q?2tkf/3C1A10qt33M8uDdBijzjm3gHsyCANu0cTD2cU+46mFvX0DEDF+hwcAN?=
 =?us-ascii?Q?rTPKo7BmU9pFaBg+FflE6Vy6B+Y810h9m8GOazWVLq4rJNPwYcyATA2DYzFy?=
 =?us-ascii?Q?SnNACCX/dMnKm15IncqKoJTSKIpu4zB9iEUG++Cxn4DOc3efwilLMXFOLJOl?=
 =?us-ascii?Q?NhS7JfwDwhKpDBE8Oi36ywLtlAJlH9IyADRjWjaLsLf7+b5hdF5W3/Yy9eCJ?=
 =?us-ascii?Q?X6NdSPTzB0iseViynr5wr+41AGxKCjFf1tSzV5LlfP6abVkauQoxmudx4n2a?=
 =?us-ascii?Q?Si/W3zZDaX/cbLMgBOPgNNXjyr2ruXr21c5pvUNpgUDm0PmXxUzWSnEN8Sb4?=
 =?us-ascii?Q?HqgXMdz7hAUViLufMBqX0VYVyGJQCj9v2R5wgtsjrTty2b2spmvgG3jeywvJ?=
 =?us-ascii?Q?jmP4j9Jji15xB7ulwTy++LTIFibGnfzMQp5t6giB2TANRDMVUeqaSV7KsTYp?=
 =?us-ascii?Q?uDFjHj+yznIoKnu7gqJbWTXSrd9PSNmYFWtPxCLdIWqk+wgY2Hoxmc1jw+cB?=
 =?us-ascii?Q?6DJ2zFEYwQo8GCPyd8c4bSZDej+p+Sp2AONnhgLmDD9cBHygF5PlgOjSGX2s?=
 =?us-ascii?Q?SwpOR/2j5QBSXNE729zEo+NkhDH/36oJql65KjIhnqAr7ccYq/BpO9qvhdDE?=
 =?us-ascii?Q?7Czb+FxQcuCT50YIFRJHr2pg/ydFMui7qVixr2KHkTs4WM5CzswClFoapfUH?=
 =?us-ascii?Q?0/+lnhC+wP3UqgwUGoUumZWbPd8nBg8lOgl+le2AA1SQMMAmFwAl6JXaslFm?=
 =?us-ascii?Q?74a2ZQ3Q1gi1i5L79hKepFX9OKHBJkFJX4ca0boXul3sbG89oLFRzqPEpq4h?=
 =?us-ascii?Q?szM++LK4ZMp8W8M6CVQiRzT4TbIgqJX6m72jMCCJTaIeFNdKBF5cHNdO04Qc?=
 =?us-ascii?Q?aSOMOeJOYIRRNerxgf/XFV9BTe4siOZlVYMmHQlVx+tRJ6h1Nw6Z4AxDKe9c?=
 =?us-ascii?Q?Wm1yZukExzf6GUHyo9Nxf5Sex75LO+X78Vvevoi5dw71xHZoifeF5M+c2opU?=
 =?us-ascii?Q?czSv5MCf7CO1dCqwMe5S315cKg1hNXtRg8tYMTKvJtSJ6XQ+P7p4i8y+7LtT?=
 =?us-ascii?Q?8SibcrK2VRU8FRzD0H6FxSod1i2hlKT318X9gyLrrC9H6J+jMpZfGgPxT7zH?=
 =?us-ascii?Q?/iwjSBtYk6pfav38ms0NIYSE6S1gdZnDKQv25fB2tc2v08DiPzrqMGR0oTj8?=
 =?us-ascii?Q?F3ACcmJqCROXCaqxeGxYNrbQ2clSPE/YAtoY17expeG2Aqyge4whhgvj6zF8?=
 =?us-ascii?Q?laccha4HSoUoUTm4yN8=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(82310400026)(35042699022)(36860700013)(1800799024)(14060799003)(7053199007);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2025 13:49:06.3729
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c27a49e-b18c-407c-4016-08de17bb1826
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS1EPF00000049.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB7306

Hi Per and Sebasian,

>
> Allow direct messages to be forwarded from the host.
>
> Signed-off-by: Sebastian Ene <sebastianene@google.com>
> Signed-off-by: Per Larsen <perlarsen@google.com>
> ---
>  arch/arm64/kvm/hyp/nvhe/ffa.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
>
> diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> index 4e16f9b96f637599873b16148c6e40cf1210aa3e..191dcb301cca3986758fb6a49f15f1799de9f1d1 100644
> --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
> @@ -857,6 +857,15 @@ static void do_ffa_part_get(struct arm_smccc_1_2_regs *res,
>  	hyp_spin_unlock(&host_buffers.lock);
>  }
>
> +static void do_ffa_direct_msg(struct arm_smccc_1_2_regs *res,
> +			      struct kvm_cpu_context *ctxt,
> +			      u64 vm_handle)
> +{
> +	struct arm_smccc_1_2_regs *args = (void *)&ctxt->regs.regs[0];
> +
> +	arm_smccc_1_2_smc(args, res);
> +}
> +

TBH, I don't have a strong comment for this but, I'm not sure why
it is necessary.
Since it calls just "smc" with the passed argments,
I think it can be handled by default_smc_handler() without adding this
function but return the ture for DIRECT MSG2 in ffa_call_support().

Am I missing something?

>  bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
>  {
>  	struct arm_smccc_1_2_regs res;
> @@ -915,6 +924,13 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
>  	case FFA_PARTITION_INFO_GET:
>  		do_ffa_part_get(&res, host_ctxt);
>  		goto out_handled;
> +	case FFA_ID_GET:
> +		ffa_to_smccc_res_prop(&res, FFA_RET_SUCCESS, HOST_FFA_ID);
> +		goto out_handled;

I think FFA_ID_GET should be a seperated patch?

> +	case FFA_MSG_SEND_DIRECT_REQ:
> +	case FFA_FN64_MSG_SEND_DIRECT_REQ:
> +		do_ffa_direct_msg(&res, host_ctxt, HOST_FFA_ID);
> +		goto out_handled;
>  	}
>
>  	if (ffa_call_supported(func_id))

Thanks.

--
Sincerely,
Yeoreum Yun
