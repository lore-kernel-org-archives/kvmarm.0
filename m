Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013067.outbound.protection.outlook.com [52.101.83.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28CD628314C
	for <kvmarm@lists.linux.dev>; Tue, 19 Aug 2025 15:16:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.83.67
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755616566; cv=fail; b=GGLejbbpDAQvdprV8tv+DAaKn6zNpKsW276GGwNmE8G2jLfsB/0004GNvp7JwTSXQyxValfXMHLTml4bFSIMTWEy7dXilW2hFgGLhSwIElvucfpXl2stWrjfUOpP2FA0e6tTmZUqzrij+nB6vTyawsk5UO2A1rPQnolJZ9WmGGM=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755616566; c=relaxed/simple;
	bh=lQSFQ43eHNL0TApjqFFtN6hmvXkuZfaUokpeRjeGeYA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=VUEcCbCYVMJhwaugKHBjPbR/63zuaFbM0N1Kfk7r2QVIxV4vACqlL0vffgnlT6LumySgDaVYY3alD0GlSE2GmlM7K8Efmxi2kP6kQ9XJAyOdaQodvnyS9NIXXcPcTZHiPF4OmhWh5qgfUcm7pbnEtFpKezcZCPXjs6pTML8Uy6k=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=f1mIAWpm; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=f1mIAWpm; arc=fail smtp.client-ip=52.101.83.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="f1mIAWpm";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="f1mIAWpm"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=D8c4UWFX6KBS3314DPn68xNoYTk3k8ceCS8ZL1/Ud0RQzugiDS9DztyvPf39Wdy8bdgW4stwcHlHnT3Gx1Cde/KLqozaC/uppZTwPHPyuQV0cyu8fOczyKVaFkIALACtqjKVhLF5wvBZD8vbZr3gXnAzYDLeEzDZN6gj5/nrRCKKd4OoiWjgNpzUvAycnKMm503MpYUIk5AURHNf1a2XNHVsfJtKWygCM2nRoCfDR1X9w7TLmAXa8ybOWjfy6QA+eGQ9eLD/Ftaz4jvTbGuXNmhpIevPyW0M+m1/rcpijdHyrJoen4PquEFnlPo2JbPy3vO5167/VTX6WMdDCS697g==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lQSFQ43eHNL0TApjqFFtN6hmvXkuZfaUokpeRjeGeYA=;
 b=kNLexVNY3IjKepmllyOzAj8sfgTsnn/FUyeoBU7ZpRkEbbTQyV2wC0mnJ9LfZN76pXbwugVkDOZZ6IkgAUFQmEFVdatEi7MTwhx5iUOWw1aS6ALs8ZqwNOxI2sOdb1kNHuNCsCmZ1utGSgS+sIeYalr/a3H62Lews04qEf0vAe+3f45kbvhC73R8dIaAp8+DqWXWqIAbS58l1WI4HK0M8BjknWUll1RKjqyQXTH7oJMDhrr1vwhu1/8GSX/rZocc8TB/dBTyfS7kJoJLTJGaBY3maiF294V4QISRnDFHXPDTpZ+nGUDZul5I9klLsZjNbs/S7iAJOXCRKfkLiguwZg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lQSFQ43eHNL0TApjqFFtN6hmvXkuZfaUokpeRjeGeYA=;
 b=f1mIAWpmKfWoCCRuhyW1CHAaG6MhYZ9Em/cca7zoa5WQYDJ5RRIH5RZxXz512yyax5sYy95QvHOIay9/18Ut2+mCmrnDD3tQk6OoyW9Py1zIqNGvFTIxnaoEj73yfwxgSVPhu7AqiUeo0t/Dl97Ew7eYex05TQ/GwY6CYhzFxwc=
Received: from DUZPR01CA0184.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4b3::7) by PAVPR08MB9506.eurprd08.prod.outlook.com
 (2603:10a6:102:314::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Tue, 19 Aug
 2025 15:15:59 +0000
Received: from DB5PEPF00014B8C.eurprd02.prod.outlook.com
 (2603:10a6:10:4b3:cafe::b8) by DUZPR01CA0184.outlook.office365.com
 (2603:10a6:10:4b3::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9031.23 via Frontend Transport; Tue,
 19 Aug 2025 15:16:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB5PEPF00014B8C.mail.protection.outlook.com (10.167.8.200) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9052.8
 via Frontend Transport; Tue, 19 Aug 2025 15:15:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pJb9RDfmOoYZ0A85K4YNbCfuYACyH3e0hputG/6xSR32MNlOm0i/WcxML/qhgCpve6ZGez0Syu17giC7+lauqCxmiKJAAhkS9/2uOU6scRVQbPxC4jiyRw1z+gOajY8PbwweHcUL/RLr1PZ9B2AeceK3yW7cG38bUetkYkRbh9husuyvz6b7IpvSYIcWMQEwDh70kiZaqfIV0Nli4xhOimfSMnnP8zMaG8f/8pOkA5FWx4MxpgnT1YDhX6hOs0494XqAuTxEWIepXYPrd7H+A+XAizlwqZSPa5AepaU30katLR1tw0YDuDYugkBdSH7MWH+qrWg7Mk/2vRRo+grVuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lQSFQ43eHNL0TApjqFFtN6hmvXkuZfaUokpeRjeGeYA=;
 b=JPFuLkJBKAWXXvVEeBmxHhEUIlRiAwBMgNXWOA1kfVtS3P01y8AZt3jb+M8hVQRwMMiiGX3E0iUXmp9mHZQ8NgmcqhVgjFxxGZMUDvzozXkHQcF5rLcQJR8cUL6JAoYjUQVpn1yRAggxyZjMv6T2ZQiOfTLkgNlZgc9evmD2q4iRQnTCj5rc5j/PqeozHPm78T6Z+N1p5sYgQA3v11Xng6GIxoTtlzcTdFofLG6CA5bVw1hf5KFleVk8tWN4Y4kniZHFF+xPhBg+U1k/iH+I5kkdgI3uOGEFFbr/9zBWjft90QhQmQ7ELZYSas5+7wJ8/8j9Inv5PtYSURE9j+358w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lQSFQ43eHNL0TApjqFFtN6hmvXkuZfaUokpeRjeGeYA=;
 b=f1mIAWpmKfWoCCRuhyW1CHAaG6MhYZ9Em/cca7zoa5WQYDJ5RRIH5RZxXz512yyax5sYy95QvHOIay9/18Ut2+mCmrnDD3tQk6OoyW9Py1zIqNGvFTIxnaoEj73yfwxgSVPhu7AqiUeo0t/Dl97Ew7eYex05TQ/GwY6CYhzFxwc=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20) by VE1PR08MB5854.eurprd08.prod.outlook.com
 (2603:10a6:800:1b0::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Tue, 19 Aug
 2025 15:15:23 +0000
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739]) by GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739%7]) with mapi id 15.20.9031.023; Tue, 19 Aug 2025
 15:15:23 +0000
Date: Tue, 19 Aug 2025 16:15:20 +0100
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
Message-ID: <aKSVCB2e8g8P703C@e129823.arm.com>
References: <20250811163635.1562145-1-yeoreum.yun@arm.com>
 <20250811163635.1562145-6-yeoreum.yun@arm.com>
 <aJ9oIes7LLF3Nsp1@arm.com>
 <aKB55rPj1Qe8G+zF@e129823.arm.com>
 <aKCcbQWioNfG1MMQ@e129823.arm.com>
 <aKNyj_6dZVp9O4BA@arm.com>
 <aKOE1aqe6EljRkuB@e129823.arm.com>
 <aKQ4HvqZa_7Q7oDu@arm.com>
 <aKQ/pglPWZMprL5e@e129823.arm.com>
 <aKSKS2__HEZDfyoi@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aKSKS2__HEZDfyoi@arm.com>
X-ClientProxiedBy: LO4P123CA0059.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:153::10) To GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	GV1PR08MB10521:EE_|VE1PR08MB5854:EE_|DB5PEPF00014B8C:EE_|PAVPR08MB9506:EE_
X-MS-Office365-Filtering-Correlation-Id: 6a3a1757-0bcf-4349-ce77-08dddf334d6b
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info-Original:
 =?us-ascii?Q?RAPbkpZeUIBbt/x44Q92iEgrc30qtquB+fbJbHcWfG65SkdgvdhsnoDMM2Mw?=
 =?us-ascii?Q?Y4Amn47uWsAB8S9s3s+t+RF/P5MmTU/yIqJNC+BewWHpL5+xKcfc5OTlcDnU?=
 =?us-ascii?Q?564c6HlhaWUuHs8Tf4TiSSCHoT2jz1rh96tYU9CUK+/u3/2PE5ngWAe4TECN?=
 =?us-ascii?Q?uNBbo7vmDdo32be7MJaHvrt7c0d9Wt7fZ4NtCUqznbVARDSgzZzyn9O4rKAh?=
 =?us-ascii?Q?04mVBw5SR9HlUWHuVRTO4wME6UmSoDvrNXeNpFvSn17dX3P55aXLagu5hR/f?=
 =?us-ascii?Q?kxBCux/I3CfyhUktIQlyxK1SR04Ik7ApJNXj326swS8M3/AKxdB9SlmsXwoO?=
 =?us-ascii?Q?OioTE+BSDehRMXBIFI8u/BxXoiDqxNODdMlyFwIWy+l+e1jMDUoacvY5C8Mf?=
 =?us-ascii?Q?uMT/LcaDele7PlibahkjGHoN1QRmJqc/qDCMV7X9T4IeTdT6PTh7Rc36Ua9i?=
 =?us-ascii?Q?Zn/YdI4ClnqU43WTIxGvXDr5pzbch0mS8JiEA9sKQdUzbe9CWZEWfSoF53gP?=
 =?us-ascii?Q?YGtedneI6qA+YN7URK/IlULTFMbor56pCFslaP/dkPh634yqBlfi+mpxtjlH?=
 =?us-ascii?Q?rVYNDeHjF26Dv0rj6QkrTiE8/Dr8eYwmL0eb9fHSdTT63f+0gPpRpxNcXT/R?=
 =?us-ascii?Q?kujO5lf2KN9g61etTcysi6WD+a8b9hkldSBvxvtftJKb+3IDvpByVIdP36jT?=
 =?us-ascii?Q?i8IehMzbxle8M1qP6cov9Oi+Wltsrtbp/zTM4A9z0vTQt8xYJpnKjzBe/UYX?=
 =?us-ascii?Q?RF3Y2QmWPeRDoVp+OQm1cjq/U8VyTM+cELM+xSzdeRbAtTEWnPoCqlqHVDYP?=
 =?us-ascii?Q?h6MBKZXOFOMc28aeferI0pOeMeUhbpVok86A8Wt4wUnD8kBFcwqe60gnNQy8?=
 =?us-ascii?Q?Pz2oy2r9CkWeZAfmoNVAQlmFj/X3fiPUMpIybjVJxqVIDvS/LNob9FCbDRNc?=
 =?us-ascii?Q?KcWoGiXrSmLD0X3nApJYX+0yK32uUGVGvmEJegT4BDT2tclpe5GK2CDtcVbG?=
 =?us-ascii?Q?C6HYx4bUucUBaw+speKHbjvKdgbIlucO0oePq2KB9opjyTkZCXhwbs8pT44+?=
 =?us-ascii?Q?aE629CYukhAeZARq8sjz5j2Pi+YOyYpe5M/VLdzHGv/nIUoEiT6d96OyDl8Q?=
 =?us-ascii?Q?ZXbUVbtIFOikfRtewqbHtunESbkni8uL9OYQfmtYbOow0+9SfPvsKsryiYS6?=
 =?us-ascii?Q?lKfM6G7tCR6K5iAofGtvUlvmHPuYB7MKjEMzeq4XTKfNnJHGbLmIyp1tYgXS?=
 =?us-ascii?Q?ZSUPlq9GbMeQZeCO/otmZ2YSA+y2pM06GW98MyJ25Cjd0yyAdZl8y+5YIdU0?=
 =?us-ascii?Q?rEjM1aCWAv+sTD2xv4Kd9DoTLUGe1blwcaYSZzUO7qdV+NygXDBMo9uRPTqx?=
 =?us-ascii?Q?xUcrG3PHvdTCNWRpEvOp9BeBfEy6CfH7DBZyDf7D+80FWKgTv5Mmv4CcI+UB?=
 =?us-ascii?Q?Yrno8ft1PKs=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB10521.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR08MB5854
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB5PEPF00014B8C.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	addbcc40-d440-4b27-c3c9-08dddf333816
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|1800799024|7416014|376014|35042699022|14060799003;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?wp/seBgatNQ0hNcZHuHCmi0s/gVsXPo4/30RfkRr9mQEK+Gshntd6aYAsmNl?=
 =?us-ascii?Q?74X6neoJNcShkLGLZE3+BfQzhWGnXWxgjpw9MnzDbLYT6rw9H19aGRubt6KU?=
 =?us-ascii?Q?DxI+7VTm6j98/L/oKpLvBNVGCQ6V70mLbvs7MGzVnaamHhn66f76sUgO1kvl?=
 =?us-ascii?Q?s6V+gB3SYOCqF6O8bn6Nxn+v8SXFpefcOwUb1MHo03nwSHZhkBWVFgLQ20os?=
 =?us-ascii?Q?P8P41aCTQtAHPx/AaTZtXR9BBGaamaILf06EGsolpyNQ3aVcCc/2YQ8DAcb2?=
 =?us-ascii?Q?rAW+SvxBc9m3Vg9lzrBbxEsD/qQddNiNDL1uR1/itizik1mV8jfXfqcYoKbi?=
 =?us-ascii?Q?vaHV8gcnxnmU7nvTzKsEytJyAOqrAqX/+B53zr5tITUktkhQ3fQUSdEhpc/K?=
 =?us-ascii?Q?kBeqmjOOccwAA2cobmM/kFS1+1ms4yHTEB5UdHDnYyQZixjJsnSTxU4K7BUA?=
 =?us-ascii?Q?smB7nmvQDbZ4Ee96Fj5ioL/Y0lXpZhNqTlc0KHkJNeScxFGFIshMFi6Zc9Y6?=
 =?us-ascii?Q?c54fsv8WzIKDawCFlZJJZ2wYmXfzyfNe5vYNOsU8o2vbwwZTH+nVtQL7LEcO?=
 =?us-ascii?Q?njWCrV30nk+Q+QjejiLlXrHxW6vIQHXY4XwJY5b2ZAeNn6z/ghdc5Yw5gNno?=
 =?us-ascii?Q?M0A4nHweW5lcX1N5RJqdIPw+e2b/86+bJPRH9Qzzdo1zPs4gx/pTrtl655x+?=
 =?us-ascii?Q?dKhdEUfwuI6+zbGJmJlPIniGvAEM5NmcW1pBbsvPw7qA7vfa8IF61u6WoTwy?=
 =?us-ascii?Q?KNw+sP5l073ffZBTvbvzoAK1aRx6HnuIydsfQdQ+8LaiXvPGzCMZmka/jx5i?=
 =?us-ascii?Q?RkFMSW4RWoGb92bMQzQ/9q2uqms82CE+7GU903sTzy/VufQJ+08AvZ7HG2sS?=
 =?us-ascii?Q?kttg9TC49iLW77xRPbGPs25WTIHPK6yyM9ofddEYo1Z90TRWAubQo+ljIi6f?=
 =?us-ascii?Q?ERc1bhQIuxYkRBtFNgvtQLEN1SZUK4SfVsc1zkPmED29VNWkSxt5E28XVzC+?=
 =?us-ascii?Q?pP7k07uMbeyE2r8Bydi7BSxyxfFFZufWYmX8h7d1t9JH5Z2a0yL2awg5ftB9?=
 =?us-ascii?Q?8z/5LWdPcXNzqYf2L8VHimo0rYZWhhMp7l5LQuM2pimyQJDVc1zIOmk9/84T?=
 =?us-ascii?Q?lWAp/3vmlIWm+8POyxgoEsUIqIHpKZnpyyY1clhmTy8nYiyI9CdIPcafwZkL?=
 =?us-ascii?Q?NAY/EaEgSHFDbAdSQf84yMYuzbsQEA1uqS7x/NBrmL3bsW+oDcWmfR85lNR1?=
 =?us-ascii?Q?XwfATV9/BH3yFS/dAP1o3a3nnyUjhf8iw2wgDpA384eLO4YGaZ9H+0wyQGjx?=
 =?us-ascii?Q?vuWPkJCFqUtXnUeKjxM56d8n0oVm9jfkHQWzw2JLJe0/GAStACIhTiiikp1b?=
 =?us-ascii?Q?lKLNyvVM9V+JqDsatx1KEzmShRo9GfeaaQPcTRM87aLnmhuzO6CNdWpZlylX?=
 =?us-ascii?Q?0HqO9A1ulKxhgCLwh+8GpOd+nMKUioPgKs4fOEAk59j2BON3qMCcq1yfYlQa?=
 =?us-ascii?Q?08utCOV4QgmtoeVPgBdVTOloI3oUhUu6+yPy?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(1800799024)(7416014)(376014)(35042699022)(14060799003);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2025 15:15:59.0649
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a3a1757-0bcf-4349-ce77-08dddf334d6b
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB5PEPF00014B8C.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAVPR08MB9506

> > > > > > why we need to care about the different settings for tag checking when
> > > > > > we use uaccess_disable_privileged()?
> > > [...]
> > > > > > But, although tag check fault happens in kernel side,
> > > > > > It seems to be handled by fixup code if user address is wrong.
> > > > >
> > > > > The user may know it is wrong and not care (e.g. one wants to keep using
> > > > > a buggy application).
> > > >
> > > > Then Does this example -- ignoring wrong and keep using a buggy
> > > > application shows us that we need to enable TCO when
> > > > we runs the LSUI instruction?
> > > >
> > > > AFAIK, LSUI instruction also check memory tag -- i.e) ldtadd.
> > > > if passed user address which has unmatched tag and if user isn't
> > > > interested in tah check, It can meet the unexpected report from KASAN.
> > >
> > > That's a valid point w.r.t. PSTATE.TCO that applies to copy_to/from_user
> > > as well. I don't think we documented it but we don't expect the user
> > > PSTATE.TCO state to be taken into account while doing uaccess from the
> > > kernel. We do, however, expect SCTLR_EL1.TCF0 to be honoured and that's
> > > what the user normally tweaks via a prctl(). The TCO is meant to
> > > disable tag checking briefly when TCF enabled the tag check faults.
> >
> > So, IMHO, as copy_to/from_user (ldt/sttr) enable tco before it operates,
>
> They don't enable TCO.

Ah right. I've confused. Thanks for answer!

>
> --
> Catalin

--
Sincerely,
Yeoreum Yun
