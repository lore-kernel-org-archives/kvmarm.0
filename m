Received: from mx0a-0014ca01.pphosted.com (mx0a-0014ca01.pphosted.com [208.84.65.235])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF5BF82866
	for <kvmarm@lists.linux.dev>; Wed,  8 Oct 2025 13:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=208.84.65.235
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759931031; cv=fail; b=FXRWOGQRdQT5roQm3i+6x3JWo/M6ohij0GtuxpLT+D3PFjLyeyM9HNWOPOWXStMJeBA5qIMKAysMYCvlELY1AVwinVI2Gtepn6cH/2H3iRK29Ao01mbJLyKbTjoLrc2ZVI1MhKfHMzRVwmIXGW6N6YCHv+ZBU7PPFZSKeNPLtaA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759931031; c=relaxed/simple;
	bh=ZEF1IlyGPx+PCTNDxWARLybsx7aBn+51NGgY1KfSAvo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Ht5y8wa6W29LiLiajUwBlFIBoFCUSHeGuwS4SnHLSnEnxCuIPmYnRzbkRlsiUNSmvDw8KRz3v+UgGJkfby9ZeVK6tIltjtE1UMAQNzfOVNX2VZF70yOV+xowA4cqbMLZlmXtjtWOyhLp5UlyaWXMlLNtNLj9InBO4+XaJZf7Ekg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cadence.com; spf=pass smtp.mailfrom=cadence.com; dkim=pass (2048-bit key) header.d=cadence.com header.i=@cadence.com header.b=dgwpYDnk; dkim=pass (1024-bit key) header.d=cadence.com header.i=@cadence.com header.b=c++OhEVI; arc=fail smtp.client-ip=208.84.65.235
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cadence.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cadence.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cadence.com header.i=@cadence.com header.b="dgwpYDnk";
	dkim=pass (1024-bit key) header.d=cadence.com header.i=@cadence.com header.b="c++OhEVI"
Received: from pps.filterd (m0042385.ppops.net [127.0.0.1])
	by mx0a-0014ca01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5988tZJH003172;
	Wed, 8 Oct 2025 06:43:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint; bh=ZEF1IlyGPx+PCTNDxWARLybsx7aBn+51NGgY1KfSAvo=; b=d
	gwpYDnkM6Zbg49GLj9XOeSkOwyVp17iC/+uM/zipdvawjwrSvsJhRxmc/+nlWS+y
	XN5uhlc7zy8KsNq9ADkUdAMIXnxfCjfGcFLXUlDZD3j8mjTKILBZysTyrSPHUr8Z
	nZrI6iKS0EZT29fgZWvy3NOdvTSsEqomgW8Kl1mPBATBs1xB4E+zOhrK3ZLQSbRC
	dAC9eacTRtsiYGDX2EXM9wpNrNMtgv4pFc+BcP/WgW3kKWAX3kpMSu9QXi58mGq5
	KUaAvM8bKvJJmDaWvCXr2xthzBLeoCJCMj/udfgESGBbdUi+xzbF9W7RkmzQRxww
	mejK/XYoRgqYmCciIvJVw==
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11020119.outbound.protection.outlook.com [52.101.193.119])
	by mx0a-0014ca01.pphosted.com (PPS) with ESMTPS id 49m920wv5r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Oct 2025 06:43:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JYdOpKkja6e6KGq4iTtH+nJwMCXxIaKxZk63HwZN/z8eL5NdsA73KYjqafYWrxiqMTBYNMxtU9cJ1POSu+Px8Gw1h/vRD0o0WPYdUPwsClWfgfQUTiFvkgkon0tqQhNxFY46LOfoJP6zauakXyaR0PGCvpGTXW1+Tl1vYIvVZwVkVqrOFb6H6LI4DW88RrWuCH1vdKLVUMMrDYB6Hds4dcLbCv4AQeODtaoESyKYxM4GkEfPSMrmD4cxqvJnaGosJURLngFP2txfskNO5dQLPKNBAdEd+4qULRve9KKaCHlmUTHiNnTacWjkB83cI9OWshsR8yTQfXkh/Rq6EgHkcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZEF1IlyGPx+PCTNDxWARLybsx7aBn+51NGgY1KfSAvo=;
 b=fEMrPy07iobiUgC/IhlPTuafqLcXoHKyBSoHSb1SrvPEhdPOv0OqXZ+K57FrytFhq8be8nd2VEwVCsmN2rXJYS+ejNhSgjWom6DaAGd1DAcq1DC1CieRuBsPDZH4EDu7zcMwjudTvFQtQjH8vJlk7brvvbaGgpcf1YHwegpXIFHbKLf+OT8hdAB4MIeX/+wQjC8i2ywgKUciWQIeD/wQm7tRFxhEqDEqR44uFpGCivOGFAqMZ0xP/XW3YSF5KKJhI2DnKshZp4MbgyUCJor7oFwHkZTtSn1VAx4HmQuRdcLfwP0UBC+K5C1qC+pTqyqVf5Bfy0mohxnuBEQ5aQymlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cadence.com; dmarc=pass action=none header.from=cadence.com;
 dkim=pass header.d=cadence.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZEF1IlyGPx+PCTNDxWARLybsx7aBn+51NGgY1KfSAvo=;
 b=c++OhEVIOng8zfKaddGMhCUbSaT5Hg7a5Zmmtr187xUi6TGAfyqOhgDB3B2t2lelzgEvsEUcH4MbWbq4GU97rcaKSjQLT/WFYLxZRkMgZMjm9u6L0UMV4rJffXMyE+yAyXmJPexJvLGLpe+9Rig+APK61rzW4VNDuRc0LXFT1Gw=
Received: from SN7PR07MB9604.namprd07.prod.outlook.com (2603:10b6:806:2af::13)
 by SJ0PR07MB7630.namprd07.prod.outlook.com (2603:10b6:a03:283::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.9; Wed, 8 Oct
 2025 13:43:29 +0000
Received: from SN7PR07MB9604.namprd07.prod.outlook.com
 ([fe80::3db6:f5eb:b1c3:999a]) by SN7PR07MB9604.namprd07.prod.outlook.com
 ([fe80::3db6:f5eb:b1c3:999a%5]) with mapi id 15.20.9182.017; Wed, 8 Oct 2025
 13:43:29 +0000
From: Jan Kotas <jank@cadence.com>
To: Marc Zyngier <maz@kernel.org>
CC: Jan Kotas <jank@cadence.com>, Oliver Upton <oliver.upton@linux.dev>,
        "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>
Subject: Re: KVM NV + SVE host OS warning
Thread-Topic: KVM NV + SVE host OS warning
Thread-Index:
 AQHcLiUKR+wB9cgAPkys8N+jKyIMXLSj98IAgAAI7YCAAAb+gIAAeJmAgBIZ7gCAAM0NAIAAdwsAgAAP94CAACEnAIAABOgAgAAlOYCAAB0sAA==
Date: Wed, 8 Oct 2025 13:43:29 +0000
Message-ID: <15A85F2B-1A0C-4FA7-9FE4-EEC2203CC09E@global.cadence.com>
References: <799DD5E5-8BC2-47B3-A919-33429D3FB2F1@global.cadence.com>
 <865xd61tt5.wl-maz@kernel.org>
 <F9556C9F-2671-4EF6-A725-D080C3793A34@global.cadence.com>
 <864isq1r66.wl-maz@kernel.org> <aNXGW8C_S1TbFR9-@linux.dev>
 <25C5E00D-62BC-4188-8642-21913446B32C@global.cadence.com>
 <aOWhlvC1kROWfMSv@linux.dev>
 <1271032F-41BB-4896-AAED-8660D5459E7D@global.cadence.com>
 <E2FD1CD0-AE1F-4F9C-86FF-D576C212832B@global.cadence.com>
 <864is9zqs9.wl-maz@kernel.org>
 <677A529C-B3D7-4BD1-BEED-D8414D961BBD@global.cadence.com>
 <86zfa1y58i.wl-maz@kernel.org>
In-Reply-To: <86zfa1y58i.wl-maz@kernel.org>
Accept-Language: en-US, pl-PL
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3826.700.81)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN7PR07MB9604:EE_|SJ0PR07MB7630:EE_
x-ms-office365-filtering-correlation-id: eaf6ee28-8dac-4654-5e7e-08de0670aa4b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?Vy8xT3hxeDVqcEZPRUhiUFk4dWpxZlAwUHF3VTFMNVc1RGs0aWI4Z0F1b1Ja?=
 =?utf-8?B?NXJJV3d5UHprUnplSTB0U3NES3VzdlBHZGo5ZzBQdjRVdU82cS8vekpCV3FK?=
 =?utf-8?B?dUh0dlhaWm1mVWpPVHQrNFlBQVRoaXVZZmgxNzBHaUhEcVMyR1ZGTXVSeDVn?=
 =?utf-8?B?RVFhVk1oUGZVQkdjQ2NHbUFZVWFsakplcTg4OW9ZcUhydzM2cGNkbDQzbytE?=
 =?utf-8?B?SUVtdEpPYngxN0FJTE00WDQ5anBId1pyOTl3R29jV2pRYXdOS1g2SHBxbXlJ?=
 =?utf-8?B?eHdlRjhjUi9tVXBXWjRSNWdObmp6M2RwSzZ4cFdibkk5NWdzaDlhbkI0ZUlP?=
 =?utf-8?B?UlZMMFpMWHpPMHoya1pSbVNZMFRhVUVUTHZOSnI4L1FtQU16dGNISDZBNm8x?=
 =?utf-8?B?VElLS2dBdURCYlczajBzZDVsZ0Y4bmZyWjZWZFlnTVlET2IwTUlBdGRFWGhI?=
 =?utf-8?B?Qks2UzlUN3VxVnNnT3dUN3NRbS96eFBXQmVaRERUeXIvZkFHcVBvMEhEZnM4?=
 =?utf-8?B?V1RTRk5MMUR2aFMvMWRtYkVpaFdSN0NzbjhBZnVQK0dRdUxFWmJLcnhGRzhF?=
 =?utf-8?B?UWJvQlpGT05aWUlzbDA1OG5UYkFodjdFbnFLMTJRYTZIcGp1Smg2L2JORE5k?=
 =?utf-8?B?cW4vVDRublNiQmlPRlVXaUwyRk1DYkNFSzBYOUpXUkpQK0pLN0FEcWRoYW4w?=
 =?utf-8?B?SkZETGo1QU9wQ1N0eWUyTHp2U2VUYzJHTVE1eG9pUVZWNVdLK1VUVEMvbk9Y?=
 =?utf-8?B?SmNDNHpnL1lRbHNZb0VGVVpjbTNKdjEvdVpxUUdyVmJ3TVJPQ1QxWEU1Zllu?=
 =?utf-8?B?RzE3RHh6MDZUM1RhSitwa21HZjRFU09kTEw2dVVTWG54VXJMUkhhL3ZpdnUx?=
 =?utf-8?B?NmhXZVoxWGF6Z056SUcrREYrTTVMQm1SaHpBSEl5a2FiRTVWMzlUZCtxa1BO?=
 =?utf-8?B?Y25oeVRuMXFnczlsNnNDc1pvb3JJaFIxNEhTdG1BbTBpM0s5aHNEZWhYUDNS?=
 =?utf-8?B?SktUT2tjYzJQMDgyZTFmemoxc0Z6akpCUC90eEpiR3NudmpzSXpQY0RVdVJM?=
 =?utf-8?B?My83OCt1RDlrTGovTEREeFFyV3g4L0NsTXJqOEtDZkFSdjIyWVVZUC9ManZk?=
 =?utf-8?B?bDg2eE01ZGhWZHZsQU1OdFh2dEp5T2xXNHJLbEd0MmRhU1Bxd2RtSkt6dWI0?=
 =?utf-8?B?Q3hkUGdDTEJsbHNLSG9rT0dwTUF4YkRYM2luOE9EQkNXQklENDdzckFCeisx?=
 =?utf-8?B?dGluM05YQ2ZsWjFwekEvRXUzcFE1SXBXSWN1TkkwNzBCT1JKTmRoSXRjbTVj?=
 =?utf-8?B?VitNS2lqNktjWnVkVVo0cGZUb2ZPYktES1FkZXZnL0I1VDhmQ2FlUmdqd0Zk?=
 =?utf-8?B?anlqdEVWT3JCY2VsV3Z0anNWNGEvVjRsbTE1dDVnWHlSTmUxTWNiNmQ3am5F?=
 =?utf-8?B?Tm10bHl0R0k2ZCs3OHRqSllZRmU4UkgrUForNW5ramVoSmNIS21maG1NVjdr?=
 =?utf-8?B?RnhUMzN2RGpNdVlpRVFVSFFUY3hkN2RQZzc5Q0l6WE1UUlE1M25oM24xTHVS?=
 =?utf-8?B?MGQ3NjlmYm90dVpMdHFOaGhUWFFwaXlzcXpqQjZod2RxVnl4dVdXd2lMN0ls?=
 =?utf-8?B?aENpNEVSNTYwMzdIZjdmdDlNMVd6dm92NE13THVkVDEzenVyNjMrNTFOS2R6?=
 =?utf-8?B?ZDZxV3lDQVJVdUhEbGhVVGxOMlNPWUhqOVBEdlUxRXU2UFdBK0FOc2RCeEFk?=
 =?utf-8?B?T2U1Z3FjekRmNlJTZEZQYkZ5Z3pSOElJVDJkUjR4Mzdtb3M2cHpKMWtaRXZJ?=
 =?utf-8?B?aTltTVYybi9YRmhEcVpDS2pWcVNJazV2T1dxc0R4N0d1TmhTUHA0MXFZS0kw?=
 =?utf-8?B?NE94WE9kZG1FVlpPSlh0YzNJMWFCYU5qUlhja1lYY1E2RkxNNFNpYTBQbStY?=
 =?utf-8?B?UXMvM294L1o4ODhIVU5BM0xzZFE2SmJ5eXBndjRGaDZCZi9vTjY2Qk5MNWVr?=
 =?utf-8?B?V0NvUHcweEx2cjVyeFNyVzZZTUEvOXp0aEwrcmJGZzVjQXJlNVQ4R1hBcVhQ?=
 =?utf-8?Q?pZpUhH?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR07MB9604.namprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?SVBtQUVPWlN5QnFvMWMrbm1OZzVsdkd3TkZqUERtbjU2ZExQQ2VPMCs5ZCtQ?=
 =?utf-8?B?YVY0emtZMUJXSXZCR2E4ZG4rM1RscHpsVEdWMkRMVUtsaDRKWFJsSXNoLzdw?=
 =?utf-8?B?TW1XQUsvTUZXY1hSVlM0b2JNN2IxTkVrMzV3ek91YWtxRi9wV0Jjd1F5b0hk?=
 =?utf-8?B?Z2NyRzRnQkNGTE8xY2tvcHZpMXRCeUF3TGd6bUVta1ltd0hqUHk2T0dLS2ZC?=
 =?utf-8?B?N0taMFV0ZXl4SS9ZNUFhVUxmalp1V2RpdlA1SW8waitLdFQzQmFEWStLRTlV?=
 =?utf-8?B?ZzZVT3RmdzFhbk1EZk9Ld0NrNWlGMEt5bnBNWldRK1JLemtlTjhpbFppbWxh?=
 =?utf-8?B?dHNxOGRPN2VKNGFxTWFXTExneVhMQUU2RG13SlpQejQrcHA3UHI2aVJDMkg0?=
 =?utf-8?B?WHp5VGFMM3RBRmdjR2c1RmY1aEpKZ1dqRGpMTVRmckxFbE9MNk44K1U2dy9Q?=
 =?utf-8?B?NFA5MWpkTUpLdmlVMDlhRUw2OUdnMThuSmpxZ1A4VzRNalVNYXZIZWIrVllZ?=
 =?utf-8?B?T3dVMXp0ZEhFTnpmSUNmTU9iQU5rakl5QmJrV2NQT0lrKzQ4M1Njd0h2U2Rt?=
 =?utf-8?B?TkJaQXhSM1JYWEFMOHVvbWpidElYSWFyWm93WVRPT0phUGRCWk1EZzdmT1A1?=
 =?utf-8?B?YnhhZFlmSjBua1FqMzRlU1FCcE9kRm41emhrendqRGRTRitkSkd6bkpSUkFp?=
 =?utf-8?B?SjB0ejEvRzFCK21VMG9DNWVwS3M2ZS83cHoxQXNtSUV2ZWR4bFgwdEdvd2Vx?=
 =?utf-8?B?dUZEY0RpMVFudzJrWXNTV3ZPT1FxSm5ub1NJRVJNNUVaRVBwNk1UZ1FBMVJN?=
 =?utf-8?B?TUxhMHBhdDRBdEVWcEFvTnBBbkFqeUtFNG8rcHc2M0o0V1IxUGdIVGs5enZY?=
 =?utf-8?B?elcvRnRFb25RWm4vcVFsRWhROG5COG5UWTZZaCtkR1kxcHlvWXJ2V0NFbmFM?=
 =?utf-8?B?anVBYWhrRmp6dmhxTytncy9LRFJwYm00bGlOWisvcEU2ZHhZVzBsdWZ5M3RY?=
 =?utf-8?B?Sm5xdkNjT2NaR0d0MXkyVWc5MXdVeURUUGxJRm5NODhlaDJVQks3MjZuS2VW?=
 =?utf-8?B?eGlMbW4zU1JwUnVnNFdwZ2lpYzZTZ3ZMWXArYXNMVkRTVm0zemxLWkZrS1E4?=
 =?utf-8?B?Z3d0S3lLRExIWmk0b2xzcUx0Y0NxcXlDSzVPMG0rTkg2ME5jemMyTDBzdW9O?=
 =?utf-8?B?cVZleWNlUzRiOU9vNWpRZVh5eUF4ZWNvOUZsV09GNkNmOWZ0TVM3QjB1Y0th?=
 =?utf-8?B?RktkSUJ1QlY2Rzd2NmZhYmdTdlA2cmhPRjRqN2hmSm5RTUt3eDVXbHFWc2hC?=
 =?utf-8?B?bHNDbk9VMjg1N2ZENGhZVncxdDhGOE1LRklRLytQTzJzT2JVYkRCTW81SEpi?=
 =?utf-8?B?dDhRSVBONTlBUUdNbHJJS0FBb1lyQVBrTEtGTmVpK2NwMkcveTF1OXpPN3Ju?=
 =?utf-8?B?Tk5pb3Z0bitnSFpxSUkrQkY1WnIwODRSaVhIakk4VEMzK0tWazZkNUVhUCtZ?=
 =?utf-8?B?WUVBOHFZSUc4cnJ0Yk1hK3JnR2swOVRleGU5YzFob0lJV3NUY2lYalFRaWU1?=
 =?utf-8?B?ZHpBSm9oMWpkMEJia0JJNSt2WkpJb3Rzb2o4bGlYWEl0amhyeVh5a2Ewa1Js?=
 =?utf-8?B?TXVnMS9VNTJMcU5ZODRCamc1a2thaTJYZVFieFpreHB2Sis2RVdUTkUvektz?=
 =?utf-8?B?bFhMSm9KbWFDaFJoa2ZocGJEbTlVYUQrcElNWi9uRDMrNGFTZ01yQmhGMXk4?=
 =?utf-8?B?YjA4SlNYVlNZblVrQkw3VWVpOEt4T2pyaVQwRkF6QTRmUDFPbG10QSs4ZXZY?=
 =?utf-8?B?OEZsY1EwZ2g3UlRmd1hKZEg2WEw0UHlRMDdNQUEycExwdEtrUGpyT0RrcDd6?=
 =?utf-8?B?dHlhRGh6eUNydnZhUHZscHRBa0RRN01wTmdvQlJ4UkZFck52SENDYzJrTTFZ?=
 =?utf-8?B?aVZtMDMvbmpvMm9qemR4OGJHZjc1VlB6ZVBSeDgxS1k4aktiVmF3Z2lGVHNj?=
 =?utf-8?B?bFFYQ0cvbkdXODh4OUkvelFJN1BGb2lyWlQ1akJOQk13RWw3bFE1d2pKcHFG?=
 =?utf-8?B?YnRML2pJRzMxK3FGUTRXQ1RBK09sUStmTVRKWENsZldtVmNGazRsTTJMY21D?=
 =?utf-8?B?YkpUbXZnTEE1VXBiQlRoTWJpRnZWQkxpZlBkWkFjYXlsTkdpUlJrdTBqNzN1?=
 =?utf-8?B?UlE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3624D1F52AC20748813BE9CFF1C21796@namprd07.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN7PR07MB9604.namprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eaf6ee28-8dac-4654-5e7e-08de0670aa4b
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Oct 2025 13:43:29.6295
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hMZYjL9/t9AzH7UoG4bbqyDATHP9/hqpWBrZ1ju61mjeHLe9jY6i/AMMATOPQeOwcO+xVOoMu+s6EaTPWUJ0Bw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR07MB7630
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDA2MDA1NCBTYWx0ZWRfX7oEWl5vTRqo2
 Vfiqbf+F7+XuJJ6+Vv2Ndm+w6fcjT2wayPsb1BSP2yBQTRuZrU3Q8P6Fe3CN/R4ylODSCLg0Qpl
 sL/Yj/3w/pCuCI9MeSSdB5OvxQNhWa8D9OGramxHqJ2I3Ub4VMDFPBJD8pPypeGPZBUr8wPU2+e
 7559BXmvioLAa6kFCidRXKdGyRN0nqfFBbimzXaNFSKn0hxXzNeZbrj8F0veAJ5/SHKuVSpeFmE
 qQ/3Sw/Gg4BSsD61tzKoIWxr94oJM2TOeJvMWLclnQueLmCV8i69CUI2+Au8CKo+mj25Sz8DDrw
 V8clakBH/j3I+e9mK/ZJPphaX7glb7RhkIiZfgifDiZs7FNAUUATWpf+YgV2josuPJ0aEemK6U2
 Bouv7cTv/QucUQl/Cx/cLuIbGWzKBA==
X-Proofpoint-ORIG-GUID: l0X_BFwkcol73UHK6aH_lzPQQ4UTORu_
X-Proofpoint-GUID: l0X_BFwkcol73UHK6aH_lzPQQ4UTORu_
X-Authority-Analysis: v=2.4 cv=TIZIilla c=1 sm=1 tr=0 ts=68e66a84 cx=c_pps
 a=tDId93ursMd3H6XzuY9MuQ==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=x6icFKpwvdMA:10 a=Zpq2whiEiuAA:10 a=VwQbUJbxAAAA:8 a=Br2UW1UjAAAA:8
 a=u-CY6o_Bni62FsIisWQA:9 a=QEXdDO2ut3YA:10 a=WmXOPjafLNExVIMTj843:22
 a=HhbK4dLum7pmb74im6QT:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-08_04,2025-10-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check
 score=0 lowpriorityscore=0 clxscore=1015 phishscore=0 bulkscore=0
 suspectscore=0 spamscore=0 priorityscore=1501 malwarescore=0 adultscore=0
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2509150000
 definitions=main-2510060054

DQoNCj4gT24gOCBPY3QgMjAyNSwgYXQgMTM6NTgsIE1hcmMgWnluZ2llciA8bWF6QGtlcm5lbC5v
cmc+IHdyb3RlOg0KPiANCj4gRVhURVJOQUwgTUFJTA0KPiANCj4gDQo+IE9uIFdlZCwgMDggT2N0
IDIwMjUgMTA6NDU6NTEgKzAxMDAsDQo+IEphbiBLb3RhcyA8amFua0BjYWRlbmNlLmNvbT4gd3Jv
dGU6DQo+PiANCj4+IEhpIE1hcmMsDQo+PiANCj4+IFRoYW5rcyBmb3IgbG9va2luZyBpbnRvIHRo
aXMuDQo+PiANCj4+IA0KPj4+IE9uIDggT2N0IDIwMjUsIGF0IDExOjI4LCBNYXJjIFp5bmdpZXIg
PG1hekBrZXJuZWwub3JnPiB3cm90ZToNCj4+PiANCj4+PiBFWFRFUk5BTCBNQUlMDQo+Pj4gDQo+
Pj4gDQo+Pj4gT24gV2VkLCAwOCBPY3QgMjAyNSAwODoyOTozOCArMDEwMCwNCj4+PiBKYW4gS290
YXMgPGphbmtAY2FkZW5jZS5jb20+IHdyb3RlOg0KPj4+PiANCj4+Pj4gDQo+Pj4+IA0KPj4+Pj4g
DQo+Pj4+PiBPbiA4IE9jdCAyMDI1LCBhdCAwODozMiwgSmFuIEtvdGFzIDxqYW5rQGNhZGVuY2Uu
Y29tPiB3cm90ZToNCj4+Pj4+IA0KPj4+Pj4gSGkgT2xpdmVyLA0KPj4+Pj4gDQo+Pj4+Pj4gT24g
OCBPY3QgMjAyNSwgYXQgMDE6MjYsIE9saXZlciBVcHRvbiA8b2xpdmVyLnVwdG9uQGxpbnV4LmRl
dj4gd3JvdGU6DQo+Pj4+Pj4gDQo+Pj4+Pj4gRVhURVJOQUwgTUFJTA0KPj4+Pj4+IA0KPj4+Pj4+
IA0KPj4+Pj4+IE9uIFR1ZSwgT2N0IDA3LCAyMDI1IGF0IDExOjEyOjMxQU0gKzAwMDAsIEphbiBL
b3RhcyB3cm90ZToNCj4+Pj4+Pj4gSGVsbG8sDQo+Pj4+Pj4+IA0KPj4+Pj4+PiBJIHdhcyBmaW5h
bGx5IGFibGUgdG8gZG8gc29tZSB2YWxpZGF0aW9uLCBzb3JyeSBmb3IgYSBsb25nIGRlbGF5Lg0K
Pj4+Pj4+IA0KPj4+Pj4+IE5vIHdvcnJpZXMsIHRoYW5rcyBmb3IgdGVzdGluZy4NCj4+Pj4+PiAN
Cj4+Pj4+Pj4gRmlyc3QgSSBhcHBsaWVkIHRoZSAiRG9uJ3QgYWR2YW5jZSBQQyIgcGF0Y2ggb24g
dG9wIG9mIDYuMTYuOS4NCj4+Pj4+Pj4gSXQgZml4ZWQgdGhlIGVycm9yIG1lc3NhZ2UsIGJ1dCB0
aGUgR3Vlc3QgZGlkbuKAmXQgYm9vdC4NCj4+Pj4+Pj4gSSBkaWRu4oCZdCBkZWJ1ZyBpdCBmdXJ0
aGVyLg0KPj4+Pj4+PiANCj4+Pj4+Pj4gVGhlbiBJIGFwcGxpZWQgaXQgb24gdG9wIG9mIDYuMTcg
YWxvbmcgd2l0aCBPbGl2ZXLigJlzIHNlY29uZCBwYXRjaC4NCj4+Pj4+Pj4gR3Vlc3QgT1Mgc3Rv
cHMgYm9vdGluZyBiZWNhdXNlIG9mIGFuIGV4Y2VwdGlvbiwgd2hlbiBhY2Nlc3NpbmcgWkNSX0VM
Mi4NCj4+Pj4+Pj4gDQo+Pj4+Pj4+IEkgY2hlY2tlZCB0aGUgRVNSX0VMMiByZWdpc3RlciBhbmQg
aXQgaGFzIDB4NjYwMDAwMDA6DQo+Pj4+Pj4+IA0KPj4+Pj4+PiBBY2Nlc3MgdG8gU1ZFIGZ1bmN0
aW9uYWxpdHkgdHJhcHBlZCBhcyBhIHJlc3VsdCBvZiBDUEFDUl9FTDEuWkVOLA0KPj4+Pj4+PiBD
UFRSX0VMMi5aRU4sIENQVFJfRUwyLlRaLCBvciBDUFRSX0VMMy5FWg0KPj4+Pj4+PiANCj4+Pj4+
Pj4gSeKAmWxsIGNvbnRpbnVlIHRoZSBkZWJ1ZyB0byBtYWtlIHN1cmUgdGhlIGlzc3VlIGlzIG5v
dCBvbiBvdXIgZW5kLg0KPj4+Pj4+IA0KPj4+Pj4+IENvdWxkIHlvdSBwbGVhc2Ugc2hhcmUgdGhl
IHJlcHJvIHN0ZXBzPyBBbHNvLCBpcyB0aGUgZ3Vlc3Qga2VybmVsDQo+Pj4+Pj4gdW5tb2RpZmll
ZD8gRldJVywgSSB0ZXN0ZWQga3ZtYXJtL25leHQgYXMgdGhlIGtlcm5lbCBhdCBhbGwgbGV2ZWxz
LA0KPj4+Pj4+IGt2bXRvb2wgYXMgdGhlIFZNTSBhbmQgRTJIPVJFUzEuDQo+Pj4+PiANCj4+Pj4+
IEnigJltIHJ1bm5pbmcgYSBtaW5pbWFsLCB1bm1vZGlmaWVkIExpbnV4IDYuMTYuMCwgZm9yIG15
IGludGVncmF0aW9uIHRlc3RzLg0KPj4+Pj4gSXQgb25seSBoYXMgYSBDUFUsIGEgR0lDLCBhIGZl
dyBVQVJUcywgYW5kIHVzZXMgaW5pdHJhbWZzLg0KPj4+Pj4gDQo+Pj4+PiBJbiBteSBWTU0gSSBv
bmx5IHNldCBLVk1fQVJNX1ZDUFVfSEFTX0VMMiwgd2l0aG91dCBIQVNfRUwyX0UySDAuDQo+Pj4+
PiBUbyBzdGFydCB0aGUga2VybmVsIEkgc2V0IHRoZSBYMC1YMyByZWdpc3RlcnMuDQo+Pj4+PiBJ
dCB3b3JrZWQgZmluZSwgc28gZmFyLCBmb3IgYWxsIG90aGVyIGNhc2VzIHRoYW4gU1ZFICYmIE5W
Lg0KPj4+Pj4gDQo+Pj4+Pj4gV2hpbGUgdGhlIHRyYXAgdG8gTDAgaXMgdW5hdm9pZGFibGUsIHJl
aW5qZWN0aW5nIHRoZSBTVkUgdHJhcCBkZXBlbmRzIG9uDQo+Pj4+Pj4gdGhlIEwwIHZpZXcgb2Yg
Q1BUUl9FTDIgd2hpY2ggb3JpZ2luYXRlcyBmcm9tIHRoZSBpbi1tZW1vcnkgdmFsdWUuDQo+Pj4+
Pj4gVW5sZXNzIHRoZXJlJ3MgYSBidWcgbHVya2luZyB0aGlzIHNob3VsZCBhbHdheXMgYmUgaW4g
YWdyZWVtZW50IHdpdGggdGhlDQo+Pj4+Pj4gZWZmZWN0aXZlIHZhbHVlIHByb2dyYW1tZWQgaW4g
Q1BBQ1JfRUwxLg0KPj4+Pj4gDQo+Pj4+PiBJIGNoZWNrZWQgdGhlIHBsYWNlLCB3aGVyZSBpdOKA
mXMgZmFpbGluZy4NCj4+Pj4+IEl0IGxvb2tzIGxpa2UgR3Vlc3QgY2xlYXJzIENQVFJfRUwyIGZy
b20gMHgzM2ZmIHRvIDAuDQo+Pj4+PiBDUEFDUl9FTDEgaXMgMCBhdCB0aGlzIHBvaW50LiBUaGlz
IGRvZXNu4oCZdCBzZWVtIHRvIGJlIGNvcnJlY3QuDQo+Pj4+PiANCj4+Pj4+IDgwNjIxOTJjOiAg
IG1ycyAgICAgeDAsIGNwdHJfZWwyDQo+Pj4+PiA4MDYyMTkzMDogICBhbmQgICAgIHgwLCB4MCwg
IzB4ZmZmZmZmZmZmZmZmZmVmZg0KPj4+Pj4gODA2MjE5MzQ6ICAgbXNyICAgICBjcHRyX2VsMiwg
eDANCj4+Pj4+IDgwNjIxOTM4OiAgIGlzYg0KPj4+Pj4gDQo+Pj4+PiBBbmQgYWNjZXNzaW5nIFpD
Ul9FTDIgaXMgdHJhcHBlZCwgYW5kIGNhdXNlcyBhbiBleGNlcHRpb24uDQo+Pj4+PiA4MDYyMTkz
YzogICBtb3YgICAgIHgxLCAjMHhmDQo+Pj4+PiA4MDYyMTk0MDogICBtc3IgICAgIHpjcl9lbDIs
IHgxDQo+Pj4+PiANCj4+Pj4+IExvb2tzIGxpa2UgdGhlIEd1ZXN0IE9TIGV4ZWN1dGVzDQo+Pj4+
PiAuTGNwdHJfbnZoZV9cQDogLy8gblZIRSBjYXNlDQo+Pj4+PiBmcm9tIGVsMl9zZXR1cC5oLg0K
Pj4+PiANCj4+Pj4gSSBkaWQgc29tZSBtb3JlIGRlYnVnZ2luZy4NCj4+Pj4gSSBjaGVja2VkIF9f
Y2hlY2tfaHZoZSBhbmQgaXQgbG9va3MgbGlrZSBpdCBqdW1wcyB0byBmYWlsLg0KPj4+PiBIQ1Jf
RUwyIGhhcyAweDEwMDAzMDA4MDAwMDAwMC4NCj4+Pj4gRTJIIGlzIHNldCB0byAwLCBldmVuIHRo
b3VnaCBpdCBzaG91bGQgYmUgUkVTMT8NCj4+PiANCj4+PiBUaGUgdmFsdWUgaXRzZWxmIGRvZXNu
J3QgbWF0dGVyIGZvciBLVk0uIEhvd2V2ZXIsIHRoZSBndWVzdCBjYW4gd3JpdGUNCj4+PiBhbnl0
aGluZyBpdCB3YW50cywgYW5kIHRoYXQgdmFsdWUgd2lsbCBob2xkICppbiB0aGUgcmVnaXN0ZXIq
Lg0KPj4+IA0KPj4+PiBJIGNoYW5nZWQgdGhlIHZhbHVlIHVzaW5nIGEgZGVidWdnZXIsIHNvIHRo
ZSBjaGVjayBwYXNzZWQuDQo+Pj4+IFRoZSBjb2RlIHRvb2sgYSBkaWZmZXJlbnQgYnJhbmNoIGFu
ZCBpdCBzZWVtcyB0aGUgU1ZFIGluaXQgcGFzc2VkLg0KPj4+IA0KPj4+IE9oIGNyYXAuIFlvdSBh
cmUgb24gVjIsIHdoaWNoIGRvZXNuJ3QgaGF2ZSBGR1QsIHNvIElEX0FBNjRNTUZSNF9FTDENCj4+
PiBkb2Vzbid0IHRyYXAsIGFuZCB0aGUga2VybmVsIGVuZC11cCBhc3N1bWluZyB0aGF0IHRoZSBD
UFUgaXMgblZIRQ0KPj4+IGNhcGFibGUuIE5vdGhpbmcgd29ya3MgYWZ0ZXIgdGhhdC4NCj4+PiAN
Cj4+PiBJJ20gYWZyYWlkIHRoZXJlIGlzIG5vIHJlYWwgZml4IGZvciB0aGlzLCBvbmx5IGhhY2tz
Li4uDQo+PiANCj4+IElzIGl0IHBvc3NpYmxlIHRvIHRyYXAvZW11bGF0ZSBIQ1JfRUwyLCBhbmQg
bWFrZSBzdXJlIEUySCBpcyBhbHdheXMgMSwNCj4+IGluIGNhc2VzIHdoZW4gb25seSBLVk1fQVJN
X1ZDUFVfSEFTX0VMMiBpcyBzZXQ/DQo+PiBXb3VsZCB0aGF0IGhlbHA/DQo+IA0KPiBUaGVyZSBh
cmUgbm8gdHJhcHMgZm9yIEhDUl9FTDIuDQo+IA0KPj4gQXMgYSB0ZXN0LCBJIHRyaWVkIGZvcmNp
bmcgdGhpcyBiaXQgYmVmb3JlIHJ1bm5pbmcgVkNQVXMsIGJ1dA0KPj4gcmVhZGluZyBpdCB2aWEg
TVJTIGdvdCBhIHZhbHVlIHdpdGhvdXQgaXQgYmVpbmcgc2V0Lg0KPiANCj4gV2hlcmUgZGlkIHlv
dSByZWFkIHRoYXQgZnJvbT8NCg0KSSBjaGVja2VkIHRoZSBYMSByZWdpc3RlciwgYWZ0ZXI6IG1y
cyB4MSwgaGNyX2VsMiBpbiBfX2NoZWNrX2h2aGUuDQoNCg0KPiBJZiB5b3UgYXBwbHkgdGhlIGZv
bGxvd2luZyBjaGFuZ2UgdG8geW91ciBndWVzdCwgZG9lcyBpdCBzdGFydA0KPiBiZWhhdmluZz8N
Cj4gDQo+IE0uDQo+IA0KPiBkaWZmIC0tZ2l0IGEvYXJjaC9hcm02NC9pbmNsdWRlL2FzbS9lbDJf
c2V0dXAuaCBiL2FyY2gvYXJtNjQvaW5jbHVkZS9hc20vZWwyX3NldHVwLmgNCj4gaW5kZXggNDYw
MzMwMjc1MTBjYy4uMzkyYzlmNDAxNmYyZSAxMDA2NDQNCj4gLS0tIGEvYXJjaC9hcm02NC9pbmNs
dWRlL2FzbS9lbDJfc2V0dXAuaA0KPiArKysgYi9hcmNoL2FybTY0L2luY2x1ZGUvYXNtL2VsMl9z
ZXR1cC5oDQo+IEBAIC0zNCw3ICszNCw3IEBADQo+IG1yc19zIHgxLCBTWVNfSURfQUE2NE1NRlI0
X0VMMQ0KPiBzYmZ4IHgxLCB4MSwgI0lEX0FBNjRNTUZSNF9FTDFfRTJIMF9TSElGVCwgI0lEX0FB
NjRNTUZSNF9FTDFfRTJIMF9XSURUSA0KPiBjbXAgeDEsICMwDQo+IC0gYi5nZSAuTG5WSEVfXEAN
Cj4gKy8vIGIuZ2UgLkxuVkhFX1xADQo+IA0KPiBvcnIgeDAsIHgwLCAjSENSX0UySA0KPiAuTG5W
SEVfXEA6DQo+IA0KDQpXaXRoIHRoaXMgY2hhbmdlIEd1ZXN0IE9TIHN0YXJ0cyB0aGUgYm9vdCBw
cm9jZXNzLg0KDQpbIDAuMDAwMDAwXSBDUFUgZmVhdHVyZXM6IGRldGVjdGVkOiBWaXJ0dWFsaXph
dGlvbiBIb3N0IEV4dGVuc2lvbnMNClsgNi45OTg2OTZdIFNNUDogVG90YWwgb2YgNCBwcm9jZXNz
b3JzIGFjdGl2YXRlZC4NClsgNy4yNTcwNDVdIENQVTogQWxsIENQVShzKSBzdGFydGVkIGF0IEVM
Mg0KWyAxODUuNzgxMDYyXSBTVkU6IG1heGltdW0gYXZhaWxhYmxlIHZlY3RvciBsZW5ndGggMTYg
Ynl0ZXMgcGVyIHZlY3Rvcg0KWyAxODYuMTA0MTU5XSBTVkU6IGRlZmF1bHQgdmVjdG9yIGxlbmd0
aCAxNiBieXRlcyBwZXIgdmVjdG9yDQoNCkkgYWxzbyBvYnNlcnZlZCBzb21ldGhpbmcgaW50ZXJl
c3RpbmcuDQpXaGVuIFBTQ0kgbWV0aG9kIGlzIHNldCB0byBIVkMsIEkgZ2V0IGEga2VybmVsIHBh
bmljLg0KVGhpcyB3YXNu4oCZdCBhIHByb2JsZW0gaW4gYWxsIG90aGVyIHRlc3QgY2FzZXMuDQoN
ClsgMy4zOTE3NzNdIHNtcDogQnJpbmdpbmcgdXAgc2Vjb25kYXJ5IENQVXMgLi4uDQpbIDMuNjgw
OTgxXSBVbmhhbmRsZWQgNjQtYml0IGVsMWggc3luYyBleGNlcHRpb24gb24gQ1BVMCwgRVNSIDB4
MDAwMDAwMDA1YTAwMDAwMCAtLSBIVkMgKEFBcmNoNjQpDQpbIDMuNjgxNjgwXSBDUFU6IDAgVUlE
OiAwIFBJRDogMSBDb21tOiBzd2FwcGVyLzAgTm90IHRhaW50ZWQgNi4xNi4wICM2IFZPTFVOVEFS
WSANClsgMy42ODIzMDVdIEhhcmR3YXJlIG5hbWU6IFRFU1RfR1VFU1QgKERUKQ0KWyAzLjY4Mjc0
N10gcHN0YXRlOiBhMDAwMDAwOSAoTnpDdiBkYWlmIC1QQU4gLVVBTyAtVENPIC1ESVQgLVNTQlMg
QlRZUEU9LS0pDQpbIDMuNjgzMDU3XSBwYyA6IF9fYXJtX3NtY2NjX2h2YysweDgvMHgzMA0KWyAz
LjY4NDIxNl0gbHIgOiBfX2ludm9rZV9wc2NpX2ZuX2h2YysweDNjLzB4NjgNClsgMy42ODU2NDld
IHNwIDogZmZmZjgwMDA4MGNhYmIwMA0KWyAzLjY4NTczOV0geDI5OiBmZmZmODAwMDgwY2FiYjEw
IHgyODogMDAwMDAwMDAwMDAwMDAyOCB4Mjc6IDAwMDAwMDAwMDAwMDAwMDANClsgMy42ODYwNjZd
IHgyNjogMDAwMDAwMDAwMDAwMDAwMCB4MjU6IGZmZmY4MDAwODAwM2NhYzggeDI0OiBmZmZmN2Zm
ZmJmMjk0MDAwDQpbIDMuNjg2Mjc1XSB4MjM6IDAwMDAwMDAwMDAwMDAwMDEgeDIyOiBmZmZmODAw
MDgwYzQxNGY4IHgyMTogZmZmZjgwMDA4MDNhYjg4OA0KWyAzLjY4NjQ0NV0geDIwOiAwMDAwMDAw
MDAwMDAwMDAxIHgxOTogZmZmZjAwMDAwMTBkODAwMCB4MTg6IDAwMDAwMDAwMzYzZTNmNzUNClsg
My42ODY2MTZdIHgxNzogMDAwMDAwMDAzYTUwMTdjNyB4MTY6IDAwMDAwMDAwYzI1YTI2MmMgeDE1
OiAwMDAwYjYxODNjYzAwZmUyDQpbIDMuNjg2ODA2XSB4MTQ6IDAwMDAwMDAwMDAwMDAwMDAgeDEz
OiAwMDAwMDAwMDAwMDAwMDNlIHgxMjogZmZmZjAwMDAwMTBkODAwMA0KWyAzLjY4Njk4MV0geDEx
OiBmZmZmMDAwMDNmZDk3ZDU0IHgxMDogMDAwMDAwMDAwMDAwMDAwMSB4OSA6IDAwMDAwMDAwMDAw
MDAwMDANClsgMy42ODcxNzVdIHg4IDogMDAwMDAwMDAwMDAwMDAwMSB4NyA6IDAwMDAwMDAwMDAw
MDAwMDAgeDYgOiAwMDAwMDAwMDAwMDAwMDAwDQpbIDMuNjg3MzQ2XSB4NSA6IDAwMDAwMDAwMDAw
MDAwMDAgeDQgOiAwMDAwMDAwMDAwMDAwMDAwIHgzIDogMDAwMDAwMDAwMDAwMDAwMA0KWyAzLjY4
NzUwNV0geDIgOiAwMDAwMDAwMDgwNzNlNDU0IHgxIDogMDAwMDAwMDAwMDAwMDEwMCB4MCA6IDAw
MDAwMDAwYzQwMDAwMDMNClsgMy42ODc3MjNdIEtlcm5lbCBwYW5pYyAtIG5vdCBzeW5jaW5nOiBV
bmhhbmRsZWQgZXhjZXB0aW9uDQpbIDMuNjg3ODM1XSBDUFU6IDAgVUlEOiAwIFBJRDogMSBDb21t
OiBzd2FwcGVyLzAgTm90IHRhaW50ZWQgNi4xNi4wICM2IFZPTFVOVEFSWSANClsgMy42ODgwMjhd
IEhhcmR3YXJlIG5hbWU6IFRFU1RfR1VFU1QgKERUKQ0KWyAzLjY4ODEwNV0gQ2FsbCB0cmFjZToN
ClsgMy42ODgxNjRdIHNob3dfc3RhY2srMHgxOC8weDI0IChDKQ0KWyAzLjY4ODM3N10gZHVtcF9z
dGFja19sdmwrMHgzOC8weDkwDQpbIDMuNjg5MDkzXSBkdW1wX3N0YWNrKzB4MTgvMHgyNA0KWyAz
LjY4OTMzOV0gcGFuaWMrMHgzNzgvMHgzOGMNClsgMy42ODk3MjRdIGFybTY0X2V4aXRfbm1pLmlz
cmEuMCsweDAvMHg5NA0KWyAzLjY5MDIxNl0gZWwxaF82NF9zeW5jX2hhbmRsZXIrMHg4Yy8weDEx
OA0KWyAzLjY5MDUwNl0gZWwxaF82NF9zeW5jKzB4NmMvMHg3MA0KWyAzLjY5MDY0N10gX19hcm1f
c21jY2NfaHZjKzB4OC8weDMwIChQKQ0KWyAzLjY5MTE4N10gcHNjaV8wXzFfY3B1X29uKzB4MmMv
MHg2MA0KWyAzLjY5MTUwMF0gY3B1X3BzY2lfY3B1X2Jvb3QrMHg0MC8weDdjDQpbIDMuNjkyNDAw
XSBfX2NwdV91cCsweDQ0LzB4MWQ0DQpbIDMuNjkyNzAzXSBicmluZ3VwX2NwdSsweDQ4LzB4MTkw
DQpbIDMuNjkyOTI0XSBjcHVocF9pbnZva2VfY2FsbGJhY2srMHgxMjAvMHgyMzANClsgMy42OTMx
MjddIF9fY3B1aHBfaW52b2tlX2NhbGxiYWNrX3JhbmdlKzB4YTgvMHgxM2MNClsgMy42OTMzMzdd
IF9jcHVfdXArMHgxNmMvMHgzOTgNClsgMy42OTM1NTBdIGNwdV91cCsweGE4LzB4MTFjDQpbIDMu
NjkzNzYyXSBicmluZ3VwX25vbmJvb3RfY3B1cysweDY4LzB4ZDQNClsgMy42OTQ0NTFdIHNtcF9p
bml0KzB4MzAvMHg4OA0KWyAzLjY5NDYyOV0ga2VybmVsX2luaXRfZnJlZWFibGUrMHgxNTAvMHgz
NDgNClsgMy42OTQ5NDVdIGtlcm5lbF9pbml0KzB4MjAvMHgxMjgNClsgMy42OTUyNjVdIHJldF9m
cm9tX2ZvcmsrMHgxMC8weDIwDQpbIDE1LjQ2MTU4OF0gLS0tWyBlbmQgS2VybmVsIHBhbmljIC0g
bm90IHN5bmNpbmc6IFVuaGFuZGxlZCBleGNlcHRpb24gXS0tLQ0KDQoNCk9uIGEgc2lkZSBub3Rl
LCB0aGFuayB5b3UgZm9yIGdpdmluZyBtZSBzb21lIHBvaW50ZXJzLg0KV2l0aCBIQVNfRUwyX0Uy
SCB0aGUgb3JpZ2luYWwgR3Vlc3QgT1MgYm9vdHMgZmluZSBpbiBuVkhFLg0KDQpbICAgIDAuMjA0
NzQ0XSBDUFU6IEFsbCBDUFUocykgc3RhcnRlZCBhdCBFTDINClsgICAxOC40ODM3MzddIFNWRTog
bWF4aW11bSBhdmFpbGFibGUgdmVjdG9yIGxlbmd0aCAxNiBieXRlcyBwZXIgdmVjdG9yDQpbICAg
MTguNTAwOTU5XSBTVkU6IGRlZmF1bHQgdmVjdG9yIGxlbmd0aCAxNiBieXRlcyBwZXIgdmVjdG9y
DQpbICAgMjUuOTk5NDc1XSBrdm0gWzFdOiBIeXAgblZIRSBtb2RlIGluaXRpYWxpemVkIHN1Y2Nl
c3NmdWxseQ0KDQo+IC0tIA0KPiBXaXRob3V0IGRldmlhdGlvbiBmcm9tIHRoZSBub3JtLCBwcm9n
cmVzcyBpcyBub3QgcG9zc2libGUuDQoNClJlZ2FyZHMsDQpKYW4NCg0K
