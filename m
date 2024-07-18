Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2052.outbound.protection.outlook.com [40.107.20.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 332CA7828B
	for <kvmarm@lists.linux.dev>; Thu, 18 Jul 2024 14:45:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.20.52
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721313945; cv=fail; b=D3S7FcnOkle1tKraARnAJIm8MEy36lfJ0+pNdjTJOUIqFO4Mkv5xKp12U/5zf571Jl44UNynFiwRwE2E68nie+pAsX5r909GB37qImLkV7cizArLfpKIDsHAfjg6031PnZ+7DxA3eon2TeX4/YVX+Nyml7FLm10BPAzX2zXoa8w=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721313945; c=relaxed/simple;
	bh=fUZkKLPHa+8tZxu9mC0LqCxXAF5IRF5v3XwYO3pkK4E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=mLXD4ObIBtruxw9fP0dg0XFzmd2KR7I0gR5zbtwhvUHIhxJlDV2UJ2PBGbHchOScfhMQPxrysH4ZZ+Wp/MOXi3jkU23n8UBVCiN+vnssIQE+xAIWS3JM9V1agCPVxrytA8YNKg85WHUoNnPXzGCa3vI1hMPESCHlKqxQVksLeg8=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=sApcrNAB; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=sApcrNAB; arc=fail smtp.client-ip=40.107.20.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="sApcrNAB";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="sApcrNAB"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=bZ0pO7IVtvSMK2U3Zl5O+nZ8d4VS3uDzORRv37q4zHuKlFjy6C8MQVL2LPbA4N6LilhO2vyKO5Xdeouuih42qJLGokfkz1aSOULXVaxgxZvsFqSbmyyxrMythBEMfp2IzOFEOMQIHkZuMcJ60mtCvoMwKdQcwQesTQwNu/4aRT7bkT27k0J2h3XR1TEQaZvBBB96RBFIjXy/sZoI8ULhDi1R3KdK6F6NB+iONSyZNb7tHHvXQrjKaoCt4w16D6TfRPfUPsZw5uW05XCKQXw7hWtXXLLG8+Di2pRglMuPcFWH0sRq6n+puMf4tRyHUkNX1JYvNKF5obP6soZKXmdTUA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L4EicoIga3irNfep9vd/yS9f61b9izPttbB5R3om0HY=;
 b=IXjtGAaCSV2WKb6YyyKk4RTxoqQnHZp8q65x8wHTmHQ06hGrKQjRd7JkBVJOkQZ2hFUvX2WZWoEbirgx29rS/+jx6QKRC1JE5Q0KI72ISaoo+dbC2hrAn+QEgTowln/83TEqleVI0yqhXM9NmefNAHCWlkwUbSor3DPgdSvPYqJghIvX7543qwdjVZYOdZxpWMj/aLcpfPITvDcDiJ3k31RvpsHvdfBpXjc1Ny+j3O3tApHek/scbDsbx/vn7VX7sc16Qwn8YohqJWZL857LeH+iG+fnzz412m/xTOd95C4VRtyV4h+XwArQ36Vyt0+jGK1c98QN93HJnaxvXwtlsQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 63.35.35.123) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L4EicoIga3irNfep9vd/yS9f61b9izPttbB5R3om0HY=;
 b=sApcrNAB9BE/WAfUq8zR6qnODd3pmMY6n+eJCS5B00scn2hKlHhyZl0IK5YEGndEt4vgfGxCjy+nDg3lHj3Pi3dinXSw8f+pMV5FELgrt+DRIuqzlZBk+fCHD4xbu7WDbjeQRO0HeFyxM2mGxVX5KZS5/gKu/wqZ04XQx2tZ0xI=
Received: from AM0PR10CA0101.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:e6::18)
 by DBAPR08MB5861.eurprd08.prod.outlook.com (2603:10a6:10:1a3::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.18; Thu, 18 Jul
 2024 14:45:34 +0000
Received: from AM4PEPF00025F97.EURPRD83.prod.outlook.com
 (2603:10a6:208:e6:cafe::3a) by AM0PR10CA0101.outlook.office365.com
 (2603:10a6:208:e6::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.16 via Frontend
 Transport; Thu, 18 Jul 2024 14:45:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
 pr=C
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AM4PEPF00025F97.mail.protection.outlook.com (10.167.16.6) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.7784.5 via
 Frontend Transport; Thu, 18 Jul 2024 14:45:32 +0000
Received: ("Tessian outbound 0808e8e76ea3:v365"); Thu, 18 Jul 2024 14:45:32 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 353639cb5c53a94f
X-CR-MTA-TID: 64aa7808
Received: from Le5933fce3642.2
	by 64aa7808-outbound-1.mta.getcheckrecipient.com id AF32D5CA-27E6-415C-AAE1-B7587D42A90A.1;
	Thu, 18 Jul 2024 14:45:22 +0000
Received: from EUR05-DB8-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id Le5933fce3642.2
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Thu, 18 Jul 2024 14:45:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pPBVG+5adpoDeOHQonqzv6CMdIcdxgNOyKV5p5nFy/TMTIF066/wY/XtLV7u6blIQ3X2x8q6+MFM/ctetJSxZ5niaKcSOmCkP1egIjcNuoWnhD5cvciL5/Tzr16COvS04ybs8MhnYWWNwZesh+ZbSrqgMBXab7y0WyrN/hDvy3Zfmup23py4TobJRuxd/QwaYj2EHkN1XKwJ7PAo/xqOZ1bUSS2RBga/M1cOCzMxz37/Wr2JY6j1wz52deo9z3g7lnn3Phtg632Vh4pnPeV1jGjL3hg+HEDI9ON3pt9uF1MVGFJJ5D3zjUbyB9DhiOmw5vSbXNrwKgeBtAi915d9QQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L4EicoIga3irNfep9vd/yS9f61b9izPttbB5R3om0HY=;
 b=usjoHcF7H5QRL9+59sMp6xHdkJoRfcg3y/eWQOujhRSntQdH8Z2YOSGkAXvdNaKSXdr9oeiHH3x9TQIio3fCYAcil8uJBAUjeMNBfjAwvAFh8yMqFjfFv1pII1tncBy1JmXOuPw6gvM/DZz/BuKjpAe2Jeuexj3lX6bbQTGiGH8rcsbfjdZccAGKdKsSEfvP36q0GRxtq6r3leqjPKv4xdo16UMlIrUGpEhLHbRA3xtUmUT+0DE87Znz+s2/soDVlUnI33pg1DgPe6YR1OjiBawybU1pfhyU8+kDYDD22vSjC5ApnPd+fpA9M5mgJnzPQL+G3cgLcGs95qpgPpkxhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L4EicoIga3irNfep9vd/yS9f61b9izPttbB5R3om0HY=;
 b=sApcrNAB9BE/WAfUq8zR6qnODd3pmMY6n+eJCS5B00scn2hKlHhyZl0IK5YEGndEt4vgfGxCjy+nDg3lHj3Pi3dinXSw8f+pMV5FELgrt+DRIuqzlZBk+fCHD4xbu7WDbjeQRO0HeFyxM2mGxVX5KZS5/gKu/wqZ04XQx2tZ0xI=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from DB9PR08MB7179.eurprd08.prod.outlook.com (2603:10a6:10:2cc::19)
 by GVXPR08MB7822.eurprd08.prod.outlook.com (2603:10a6:150:3::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.29; Thu, 18 Jul
 2024 14:45:18 +0000
Received: from DB9PR08MB7179.eurprd08.prod.outlook.com
 ([fe80::7d7e:3788:b094:b809]) by DB9PR08MB7179.eurprd08.prod.outlook.com
 ([fe80::7d7e:3788:b094:b809%6]) with mapi id 15.20.7762.020; Thu, 18 Jul 2024
 14:45:18 +0000
Date: Thu, 18 Jul 2024 15:45:04 +0100
From: Szabolcs Nagy <szabolcs.nagy@arm.com>
To: Joey Gouly <joey.gouly@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>
Cc: Florian Weimer <fweimer@redhat.com>, dave.hansen@linux.intel.com,
	linux-arm-kernel@lists.infradead.org, akpm@linux-foundation.org,
	aneesh.kumar@kernel.org, aneesh.kumar@linux.ibm.com, bp@alien8.de,
	broonie@kernel.org, christophe.leroy@csgroup.eu, hpa@zytor.com,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org, maz@kernel.org, mingo@redhat.com,
	mpe@ellerman.id.au, naveen.n.rao@linux.ibm.com, npiggin@gmail.com,
	oliver.upton@linux.dev, shuah@kernel.org, tglx@linutronix.de,
	will@kernel.org, x86@kernel.org, kvmarm@lists.linux.dev,
	yury.khrustalev@arm.com
Subject: Re: [PATCH v4 17/29] arm64: implement PKEYS support
Message-ID: <ZpkqcGwdkK78KBZY@arm.com>
References: <20240503130147.1154804-1-joey.gouly@arm.com>
 <20240503130147.1154804-18-joey.gouly@arm.com>
 <ZlnlQ/avUAuSum5R@arm.com>
 <20240531152138.GA1805682@e124191.cambridge.arm.com>
 <Zln6ckvyktar8r0n@arm.com>
 <87a5jj4rhw.fsf@oldenburg.str.redhat.com>
 <ZnBNd51hVlaPTvn8@arm.com>
 <ZownjvHbPI1anfpM@arm.com>
 <20240711095000.GA488602@e124191.cambridge.arm.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240711095000.GA488602@e124191.cambridge.arm.com>
X-ClientProxiedBy: LO4P123CA0317.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:197::16) To DB9PR08MB7179.eurprd08.prod.outlook.com
 (2603:10a6:10:2cc::19)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	DB9PR08MB7179:EE_|GVXPR08MB7822:EE_|AM4PEPF00025F97:EE_|DBAPR08MB5861:EE_
X-MS-Office365-Filtering-Correlation-Id: d82a942f-0996-45a0-10eb-08dca73846f0
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?bHduTFVjNlR0MHlWeTYxbjN5OWhuSjczLzQ1MHJzMVZQOFg0QXlJVG4vY0h4?=
 =?utf-8?B?OFZ4dXJ1RFluVGdMVCsyanU2L0gyY3l2bGhNK29ma1lyMXE4ckpVNHl4L1BF?=
 =?utf-8?B?Z2QwdFRnNmo4aVRsZzZsVVJ2NHBIRHpPTzNvd0RycUtRSG13aUNqVnVBM1M1?=
 =?utf-8?B?aDAvZTN3ajNSck9JSVRlenVnUVlPOWZFZkorenRHMXlvbmUvK2pEcllIRmFX?=
 =?utf-8?B?WHdrbjhySGs3WDhVeEprZTJFdXVKTm9oc01yeWUxVnR6VDhiZ3FTckhUekxU?=
 =?utf-8?B?ZUJ5K0pIYis1UkxZdlc5UmtoWHp0Q2FTeC91N0kvbVVXVTNFVWNOM3piY3dG?=
 =?utf-8?B?QytRdXYyRmFrOW5HcUlldWRMQ3M4L3h0M1dSK2Y0NE0rMHBZQThyakEyQS96?=
 =?utf-8?B?RHRuSDRQMUVIOWZrUDdqdFZDN1NmbFNuZ0RzNmcvWWdKZGJFUEpESDZMdHYr?=
 =?utf-8?B?WXdSNUJPQmxEZDJsQ2VYSVFiSGpPa2NHOHYyNkROc1FxMDhrTGh1K0FTSWs4?=
 =?utf-8?B?bnJISGtIRlJzVFQ4bFVIM1pZUlJPKzdQcnJIWVBNNENiclJpaE8wNXJlbVJ2?=
 =?utf-8?B?aVJDeUNwVVNTMEVFbEFtSUZIK3FJdmpUUHhGc2ZpZVhnWkh1cmROcnRXWjRI?=
 =?utf-8?B?ZEdDbkQxWVlJSFlJZklhSWdtYk9kQWV2RUxPTjhXZ3RYQXBmeWpqR0VySTY3?=
 =?utf-8?B?UXJLNmdNT21YcmtXbTJmK2ErbklMeFFmTEdpaTlEZzB5U1FnTzg0V3FwcGdI?=
 =?utf-8?B?aTRXamxNQXYrTlhrT0FGYis5TDBXQ1hHZUtIZmtSdWh1WU1ibVFnN08zZEVP?=
 =?utf-8?B?YWlVaTBZL2tCZE1ZaWY0SjBQQ2tJejkxNWQ5dndtQ0N5TGppQWNXYmltOTdt?=
 =?utf-8?B?N2kxemhyMmJUMUhDRURWN0tXS2lWTWxKZVN4ZlNEejFuWVhaSVBVU2hrQTFQ?=
 =?utf-8?B?YmJyRTJHelY4bEw5RU41STdUT2xXK0VIQ1pLZmNyS1c1TGx6SVpBOEt2MDgw?=
 =?utf-8?B?Y2c5WTk0dE1zNkNIVGV6ZEdBdUMxWjNiSmpLYjFUb2FOZHdvVThsS1JnbEpo?=
 =?utf-8?B?YldWYk1nQ0NvcDRvVEJuQnVwUTJnSGlndzNGLzJNdGRSOVlINWhMS2I0UXd2?=
 =?utf-8?B?bXZNTkthTTQ0V1E1UzRNdytxM3pmTlh3WlJTQ2xHdkRweEhmRVZ5bGxNRFJS?=
 =?utf-8?B?RnhYZEtnWmRaK1VTNmRaR1l2d1JmUVpVVStkN2hEUTB3Mm1qUVlQNTVBOXps?=
 =?utf-8?B?OXA0bi9DaUp1RlhJd3NiVnVRWUJGVWZEK090d0o3WkNwTzVkV1ZxUW1VRCsr?=
 =?utf-8?B?M3gwU1BDbGlCTnZmd0lGUkJ1eUd4bmJOckhGaGQyamZrSHNzLy9nTDdDRU5N?=
 =?utf-8?B?NlJBN1pSTFlaMWxXMGUySVR2U0I1MDBGR25PT05zMHdiRVpzS0o0YTFsWEE2?=
 =?utf-8?B?bGVMdGQ0RHpWdmFOeko4SnVtV01lNjlpV2xYY3dZaDYvWFVGVm5qcUl0Z21H?=
 =?utf-8?B?SG16ZjVZQ2VXaE9ZN0VJQ2xkMXZ1Rnd0cm5GMkNncEF3R1FhbXp2SGZDMkdr?=
 =?utf-8?B?dFR0UWZra0pndmI3UldsejdQYmVOVzJVNm9ueUhSR0Z0WERaZXJXYy91N0Yz?=
 =?utf-8?B?RzNPekxFR1Q2Z1BQK0FNaGZ4VGFYNkllRlNCVThwdG5rT3ZMTmtmTjBrUEt6?=
 =?utf-8?B?bFhTZnVERGFwTWhUR1lMV01Fdi85Wk1DRElHd2U0YTVwTEhwNUdqZ1BmMW8x?=
 =?utf-8?B?MVZYNndvcUlEVlBuQ1dEcWJWbFM4amM1V3BVUjhMNGNTRjg4SXNXbnlDR2Jl?=
 =?utf-8?B?YXZiTFhGM3VGOG5OQTA3Zz09?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR08MB7179.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVXPR08MB7822
Original-Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-SkipListedInternetSender:
 ip=[2603:10a6:10:2cc::19];domain=DB9PR08MB7179.eurprd08.prod.outlook.com
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM4PEPF00025F97.EURPRD83.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	7fffc864-169c-438b-8f34-08dca7383e3d
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|34070700014|35042699022|36860700013|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dnJKY3RaSmZKMVQ5a2dCT05zTzlnQVNRWVg5SklLYzNKSXZlb1I3OCs0eHNX?=
 =?utf-8?B?T0JJcmtwL1o1L2Mya3Fwa3pPNjdQdXU3czk5ZWVHc0QyYk5RRmNSeGthL3Vl?=
 =?utf-8?B?bWsvZEJHczlCYmgrV3d1azhIU2ZzUzJmL1dnbnh1TXBkTVBjUXhiVklOVjVi?=
 =?utf-8?B?OU9LL3NDbUh6RWNPZXN6aTlhandKQ1c3bm1aNTgvWm9NTm1KSHJLYUVqSVVm?=
 =?utf-8?B?aHRSbUhJdmc2WHZXcnNUMURpcC9BVVlhbzdjUUc3b2g3aVVjRFcwamNLK1Vp?=
 =?utf-8?B?eUxjWHJyckRtdDVaRmVEKy80dTRBeG1nS0FQYnIvRDRBd2c1R2p5Y0FPbXp6?=
 =?utf-8?B?MGZtSFhsTDE2TjZmazhYeXZocnpyY2lVZmVNcGFxMnh1NGY5WDZqOW5CWHNq?=
 =?utf-8?B?cmpSSzlGOXgvOWkySGdiYVFaMGQ5YU5CR0pNYmw3aE1xdllHVmJoSnI5dTlp?=
 =?utf-8?B?M3hCZkRLQ0dNbHdENlNnQURwZ2ZEcU4rd24xUTJYQUwyamVSZzdoQTFxNThp?=
 =?utf-8?B?RHB3TDVCZzNBakorT1A3NytEOFcxcHNSZ3NlSFppeDlmc3hhMnBFT2swS1hF?=
 =?utf-8?B?cXF2b1VJaVF0TnNXVVBpOG82VHBMYVcxQjF2NFFMdk4rd3pTZ3d1QVM5SzJa?=
 =?utf-8?B?NE1DZVpKbGJDNVFqdkJDOExqQXVqekNqYkFTTW0rd1VZbkcvcjVjNUJPQi9k?=
 =?utf-8?B?VzI2NjFvdmNyMmpvOVJITVBWQW5WSjJoeTk4R1puaHFGRUxjb3p0Wkg3c0do?=
 =?utf-8?B?WGowdXp6TytXQVlTTzRlK09JZk9mSG5pR1JjTGk1YU1CQzBNYlF0Qkk0YXZ2?=
 =?utf-8?B?M3ErMmtLZFNxSUo1SmZyWkk1QXhJVXBmQXdPMjF1L2RoU2hKOHRBZDNmQk1O?=
 =?utf-8?B?ZmpXMGU5SFcvRWJSNkZCekZ5QlNTS1ROd1Jyek9jM3g3YmVNS0FvSndWNWxO?=
 =?utf-8?B?K1B5Sm1tZTBhbncyVFY5dnF0TTY1YlBPNlhsbXlmNmdLSmVBbVdzcWZBemcz?=
 =?utf-8?B?eDA3UGlmYUpHUzN1L1BMVFUreFhLZStadjFLRnlIRFhNR2t5M2tYbzh1cWhl?=
 =?utf-8?B?UWdmaENtZGhmbUNRMGlNZ3QzdllZTlp4ZkkyVS9XdThkY3FFS0xvMXYzSUZa?=
 =?utf-8?B?d0pYdWlNQklaeWtDUjYyb0o0Tk5GajVyMXg5SXZoWnd5NmRVNkY0dkovZ0pT?=
 =?utf-8?B?VjlvV1FLVUlrZ3B0RHZVK1FQOTU3TEVCQ1dTRVd6d0V1K0pQYmFQTHF1MEN5?=
 =?utf-8?B?SjV4QUVQV2tSZUJUcy9ua0VKSWNudlk2c3lEeGZVWjNUVWVSVkVBeGFFbUFX?=
 =?utf-8?B?TnkrZjl5NDV2Y1RsWS9nVi8raDdPcmppK3FTOUVMelVFVUJ1dHJPQTg2NlVO?=
 =?utf-8?B?MkRlQWtVV21MLzY0R2ZwdklHQzk0UGZTTXJBNjJSK0k3Ym5kdnNiVlhpTmlp?=
 =?utf-8?B?bFZLZ01jYjdqTGxKcm96VUgzb2h2cEZ6K3l0MVVBVmZSZHM0ekNaRDQ0SXU2?=
 =?utf-8?B?b1lKOGVrMUY2aGNRQUdSbWF0d0Q0T3B6L2hxdDd3SGlRbnRYVHF4eU44b2ln?=
 =?utf-8?B?bzJUT2NITXF1bG9iSWVmMk1QUFZsaGp2UnNkb0ZleDVMZEg1R1JMakdqMVVX?=
 =?utf-8?B?bEpIVFlLUUtESFY5UUFnOEIxbSt6bzEyck1wbERHTGU2N0ZwbmlqU1Y5NFpq?=
 =?utf-8?B?cmhtQTUxeUdwMUprN0s1M0F0eVEzWlBocU5ZdjNnM1NDeWN0ZjBBdmhDdGRE?=
 =?utf-8?B?MnZPZzlPTm8zc1I2aWNueWhsTXlKYXF2WGY4bFFiVFY3NnUvbGswcThhdmkv?=
 =?utf-8?B?Q2Rqdm1tQUphNWdLTDVDYk1DS0RFOFUwb29pTzdjSm5ZZVErRmo4MUNveTVX?=
 =?utf-8?B?Q0F5NDRoZFFPTjU4c0puV04wVWdTbGhOZjhuamRVQ2dlQW1BVE5kckpKWEVU?=
 =?utf-8?Q?hM6UpyVHpKFGOvmrH+TyPGB7Q3OPJObC?=
X-Forefront-Antispam-Report:
	CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(13230040)(1800799024)(34070700014)(35042699022)(36860700013)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2024 14:45:32.9288
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d82a942f-0996-45a0-10eb-08dca73846f0
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM4PEPF00025F97.EURPRD83.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR08MB5861

The 07/11/2024 10:50, Joey Gouly wrote:
> On Mon, Jul 08, 2024 at 06:53:18PM +0100, Catalin Marinas wrote:
> > On Mon, Jun 17, 2024 at 03:51:35PM +0100, Szabolcs Nagy wrote:
> > > to me it makes sense to have abstract
> > > 
> > > PKEY_DISABLE_READ
> > > PKEY_DISABLE_WRITE
> > > PKEY_DISABLE_EXECUTE
> > > PKEY_DISABLE_ACCESS
> > > 
> > > where access is handled like
> > > 
> > > if (flags&PKEY_DISABLE_ACCESS)
> > > 	flags |= PKEY_DISABLE_READ|PKEY_DISABLE_WRITE;
> > > disable_read = flags&PKEY_DISABLE_READ;
> > > disable_write = flags&PKEY_DISABLE_WRITE;
> > > disable_exec = flags&PKEY_DISABLE_EXECUTE;
...
> > On powerpc, PKEY_DISABLE_ACCESS also disables execution. AFAICT, the
...
> Seems to me that PKEY_DISABLE_ACCESS leaves exec permissions as-is.

assuming this is right the patch below looks
reasonable to me. thanks.

> Here is the patch I am planning to include in the next version of the series.
> This should support all PKEY_DISABLE_* combinations. Any comments? 
> 
> commit ba51371a544f6b0a4a0f03df62ad894d53f5039b
> Author: Joey Gouly <joey.gouly@arm.com>
> Date:   Thu Jul 4 11:29:20 2024 +0100
> 
>     arm64: add PKEY_DISABLE_READ and PKEY_DISABLE_EXEC

it's PKEY_DISABLE_EXECUTE (fwiw i like the shorter
exec better but ppc seems to use execute)

>     
>     TODO
>     
>     Signed-off-by: Joey Gouly <joey.gouly@arm.com>
> 
> diff --git arch/arm64/include/uapi/asm/mman.h arch/arm64/include/uapi/asm/mman.h
> index 1e6482a838e1..e7e0c8216243 100644
> --- arch/arm64/include/uapi/asm/mman.h
> +++ arch/arm64/include/uapi/asm/mman.h
> @@ -7,4 +7,13 @@
>  #define PROT_BTI       0x10            /* BTI guarded page */
>  #define PROT_MTE       0x20            /* Normal Tagged mapping */
>  
> +/* Override any generic PKEY permission defines */
> +#define PKEY_DISABLE_EXECUTE   0x4
> +#define PKEY_DISABLE_READ      0x8
> +#undef PKEY_ACCESS_MASK
> +#define PKEY_ACCESS_MASK       (PKEY_DISABLE_ACCESS |\
> +                               PKEY_DISABLE_WRITE  |\
> +                               PKEY_DISABLE_READ   |\
> +                               PKEY_DISABLE_EXECUTE)
> +
>  #endif /* ! _UAPI__ASM_MMAN_H */
> diff --git arch/arm64/mm/mmu.c arch/arm64/mm/mmu.c
> index 68afe5fc3071..ce4cc6bdee4e 100644
> --- arch/arm64/mm/mmu.c
> +++ arch/arm64/mm/mmu.c
> @@ -1570,10 +1570,15 @@ int arch_set_user_pkey_access(struct task_struct *tsk, int pkey, unsigned long i
>                 return -EINVAL;
>  
>         /* Set the bits we need in POR:  */
> +       new_por = POE_RXW;
> +       if (init_val & PKEY_DISABLE_WRITE)
> +               new_por &= ~POE_W;
>         if (init_val & PKEY_DISABLE_ACCESS)
> -               new_por = POE_X;
> -       else if (init_val & PKEY_DISABLE_WRITE)
> -               new_por = POE_RX;
> +               new_por &= ~POE_RW;
> +       if (init_val & PKEY_DISABLE_READ)
> +               new_por &= ~POE_R;
> +       if (init_val & PKEY_DISABLE_EXECUTE)
> +               new_por &= ~POE_X;
>  
>         /* Shift the bits in to the correct place in POR for pkey: */
>         pkey_shift = pkey * POR_BITS_PER_PKEY;
> 
> 
> 
> Thanks,
> Joey
