Received: from mx0a-0014ca01.pphosted.com (mx0b-0014ca01.pphosted.com [208.86.201.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9C5B29D29B
	for <kvmarm@lists.linux.dev>; Wed,  8 Oct 2025 07:13:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=208.86.201.193
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759907589; cv=fail; b=umHKaGQ1xzRRYmP5Q6wQT9NJwNoB7zNfBucU3zjn8MiedaxTYyPjEJZdlhnmdX4FnI7GswRQDx4Re2YNvUmIpU00bYo6jt/SgLaFRKDP+siQu80EM/Bi0QzScj/d1GxWEkrDEydQK97e35NZFUEpI9bU6Q3Dot7eITwU2KAWSvA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759907589; c=relaxed/simple;
	bh=fWLwhmNke1qc8k+a2chGxaasu7T3Ggs6QUGpJv2tLTg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=teuuKB78092KXm5eP3lZ0IZXSoSt6miIHzvAdGZSKFXgGjdfOEqz0U2FOy4gfwinW9xfcSZcCCTiHVJhScU6b/pOvKGXRv2a6Kg82b8q7cK3v3l7qbHLxckQwZTrD7dinHK10WDLZp9Ka9suMWi3x5kTLcs9tZZEUZ2gBedobXI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cadence.com; spf=pass smtp.mailfrom=cadence.com; dkim=pass (2048-bit key) header.d=cadence.com header.i=@cadence.com header.b=LQcVu+gR; dkim=pass (1024-bit key) header.d=cadence.com header.i=@cadence.com header.b=40UW3x4e; arc=fail smtp.client-ip=208.86.201.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cadence.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cadence.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cadence.com header.i=@cadence.com header.b="LQcVu+gR";
	dkim=pass (1024-bit key) header.d=cadence.com header.i=@cadence.com header.b="40UW3x4e"
Received: from pps.filterd (m0042333.ppops.net [127.0.0.1])
	by mx0b-0014ca01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5982eGiY005056;
	Tue, 7 Oct 2025 23:32:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint; bh=fWLwhmNke1qc8k+a2chGxaasu7T3Ggs6QUGpJv2tLTg=; b=L
	QcVu+gRnWJT0hJwDsghlP6HzsurjPvUY87n3NQX7L67GPdHM6wneL8Jk2q+MCPMt
	hCZKDimdMS1Z+82NDwHen43mWT4GQJl5DPjaKXJRAvZi8Ly/ah8FDZZRTbrnlhs1
	Pox37v161ixuJ1JHWVCZbTDYGFef8zVPaTNKphNoxT0WrqZZSXYQeGp91muokqdW
	VkWDKZJEMM2/Ubn1rNzCwTRu600V7I4gAk9jsTmFL5hJNf9Y+FVGpuZoQNlQNTCb
	kwYsLEFaMtT75ziW+T+0aWkDIxlDZxSbXwdvOpf1rZs1hNjXmKt95qQKeQ0vHteC
	H7W4oq/w2nVZrnzWg0rHQ==
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11020095.outbound.protection.outlook.com [40.93.198.95])
	by mx0b-0014ca01.pphosted.com (PPS) with ESMTPS id 49m986uwt8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 07 Oct 2025 23:32:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jx7ScBSE1Wl3RGIbqxycsUG9HX1mtBo8rYMqsUIm+hx5Af1isP3W8cc2DMxQ/BNl2ttEV08Q8cAs+aE2pGk279UJymWGL6FIvQMPd/GR3x+m1OkS5Y7/xHYeg3/WyodtpxVBH53cWvVP0uPoGX7abzgMfTCCbGpoLa1XTbeEPHwnU2RH2/N9Xeq5Vf5uw4Ojt5VS9xjJpG0gOEkl0y17MaUlxfogue0yG8snokH3GFQKQ58V8eRaluAq7cKdtUpXZOaW1PjhMjuEeRynMz+s3qBkzdpWB/Ga2kyqXPSGEJyQ6D1qmTQEME+bcKX0QH4J275K19cvgXdPATLsBk5zXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fWLwhmNke1qc8k+a2chGxaasu7T3Ggs6QUGpJv2tLTg=;
 b=ZwYqxykIW0tfuW0sHwWkdYLqSxlRrlGSDy9vWTJGzHl3MFBNLSQDOLc8g+TJfkwHAQU0lU9UeaL0AmWTSXiWAK+gv+gO9iIIDmdERaaWDF00TezN1QbvPuFOA+YjTxpcPtcLmOnTNgT+u4Vo+rI8ck+Hafht0b+hLWmyPfNrTSOuQlUAXmqhj+e3eUXQk8O5sjUJc4BdHxKjdN25suRcCzKo6pReoL5iwPqS7ARJkeoTmXBHg/7mYneFRLDDx0fY2uj4kIJODHymzc+I4esFIma9wlx1D6WAR6lW1IUmDjxw+EUv7vgquSoyfTXm8afQZ+UJdnafyHwBhuskYEJm4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cadence.com; dmarc=pass action=none header.from=cadence.com;
 dkim=pass header.d=cadence.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fWLwhmNke1qc8k+a2chGxaasu7T3Ggs6QUGpJv2tLTg=;
 b=40UW3x4ebQvkpCFgab7zJh7aF1GUsrH4m4ebj4aVQLQJli08lkvoD/Pfo+uADmG8rJzEBLGxLYxk5iiaJ12xnM9LFxK9OCLfByoCrIKKhJain5CUOvipUhz4atT5n29jpQwMvlb2X8jkdDGCn4mnI4PIQXVb7EfWBg3Ef4vnr0E=
Received: from SN7PR07MB9604.namprd07.prod.outlook.com (2603:10b6:806:2af::13)
 by SJ0PR07MB8407.namprd07.prod.outlook.com (2603:10b6:a03:358::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9182.20; Wed, 8 Oct
 2025 06:32:28 +0000
Received: from SN7PR07MB9604.namprd07.prod.outlook.com
 ([fe80::3db6:f5eb:b1c3:999a]) by SN7PR07MB9604.namprd07.prod.outlook.com
 ([fe80::3db6:f5eb:b1c3:999a%5]) with mapi id 15.20.9182.017; Wed, 8 Oct 2025
 06:32:28 +0000
From: Jan Kotas <jank@cadence.com>
To: Oliver Upton <oliver.upton@linux.dev>
CC: Jan Kotas <jank@cadence.com>, Marc Zyngier <maz@kernel.org>,
        "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>
Subject: Re: KVM NV + SVE host OS warning
Thread-Topic: KVM NV + SVE host OS warning
Thread-Index:
 AQHcLiUKR+wB9cgAPkys8N+jKyIMXLSj98IAgAAI7YCAAAb+gIAAeJmAgBIZ7gCAAM0NAIAAdwsA
Date: Wed, 8 Oct 2025 06:32:28 +0000
Message-ID: <1271032F-41BB-4896-AAED-8660D5459E7D@global.cadence.com>
References: <799DD5E5-8BC2-47B3-A919-33429D3FB2F1@global.cadence.com>
 <865xd61tt5.wl-maz@kernel.org>
 <F9556C9F-2671-4EF6-A725-D080C3793A34@global.cadence.com>
 <864isq1r66.wl-maz@kernel.org> <aNXGW8C_S1TbFR9-@linux.dev>
 <25C5E00D-62BC-4188-8642-21913446B32C@global.cadence.com>
 <aOWhlvC1kROWfMSv@linux.dev>
In-Reply-To: <aOWhlvC1kROWfMSv@linux.dev>
Accept-Language: en-US, pl-PL
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3826.700.81)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN7PR07MB9604:EE_|SJ0PR07MB8407:EE_
x-ms-office365-filtering-correlation-id: 2cebc459-fe17-4895-c4af-08de0634740c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?TlpmZGVYdks3UlhSaTFnWitwL3BFVStueGVFcWFWaXdsNUQ1K1RSSTNFM3Rp?=
 =?utf-8?B?cEtYUHppUGRlNGgzK1M4YXpZc2R4d1NnSHBvSEhQSmd4SDFZQUdtS3pUQ0Ni?=
 =?utf-8?B?azNaaXZrckpWMURFdzdsZkN6QmdhcmNNb3pyUzd6NTJjUzdwWmtBTmZTVzRa?=
 =?utf-8?B?OHU5MFZQMWY3d25CNjhBek0vTzRMdWJJaGZXOFA4cmRvZnV4WkVLS2gzam9t?=
 =?utf-8?B?bXV6OWZ5WXJlRTlRcE5od1lNYTQva1d4QzNrcGNvVW1vYmIveDNiT1kvNmpP?=
 =?utf-8?B?bmZTUzNNOTBoOS9GSXRDU2trdkpWMlVib3JlQVE1OE9vUmxBcjlsL001Nk9G?=
 =?utf-8?B?cTZJdFY5b0o2OUhHRGUvNlJPbGhNd0ZCa3BlS0EzTWhGUVE0NnB3Y1RXVVBr?=
 =?utf-8?B?WU1Ca1BzdmgwM1VlWXBHOWQ3UUhCRkpTY3BJYkVYa0VpQ2x2alVORVh1c2pK?=
 =?utf-8?B?SVJrM05sdG9BL1pYd3BtMEFCOE1MbForczNSVm1FUitFOUszZkw2N0QzT2o2?=
 =?utf-8?B?TGEzNFFxR2paTUhwRnhHUTllbEMxRDZxOFFwamtSREk5eDZTb1FDbDMwdVBm?=
 =?utf-8?B?K3h3L1YwZ204Q2k5WS9QZitrLzVMd01vcnhTWVVySEJYRkwwMStUNG93T2JI?=
 =?utf-8?B?ZFRYSmdISEJvNFY5cnB2REtVNllGTDlob09qaUpHelI3eEZNVldjZXJLSlpZ?=
 =?utf-8?B?Q3luUkFPaTA3Uyt2VWU2OCs1SWlhNEp1V3UwbTdCdjJKYlRzVFB5MXRya2lv?=
 =?utf-8?B?aVdDZUpWWHFyTUJOdDFkNWlVUzlWT2JKQzB1TUQ5dVMyRGJLQzh1Sm53aDVo?=
 =?utf-8?B?RWdCWWlLb3RJbW1qN2ZKaVlVaDhwdTR3YkZ6VUhkSEZyQ3NzMkQzczhSYjc2?=
 =?utf-8?B?WkoyYkJiMHhocTh4b0NLQ2dwN3RIdzgyS1RIRXZTWkg0d3pSOFdDZnlRQWZP?=
 =?utf-8?B?Mm9PUGkvVU5JOVFMVC96ckNlSHFCSWZnMjR1eXBsN3lhd3cwOVcxeklRMTIw?=
 =?utf-8?B?OTBzQk1ITlNzaWVvY2xlekpIN25jM0RnMTh1cDVyOG5PL2dLY3RmOGkyMUw2?=
 =?utf-8?B?dHBPN0VVSDdVT2VscThkdENiZWw2dU5lUGorb25qaDJ0dGpPd0JTa0dvanFM?=
 =?utf-8?B?azcxYzA4dVV5N2pHQWhoTGs1Q0RwRWwvZEcrWmlVYVpXOG5WR2VQSEFFamRV?=
 =?utf-8?B?UzRjVENUVDgvVFhpa1VsVGUyVll1UHh1N3Rkb01Lems3UnFVSG9XM09BKzA1?=
 =?utf-8?B?bUg1Mm8wWkZRanpjbTViTjM2NWtjWFh0a0FNM3JJbkZ1Rk9SK3pubUJVZ1lN?=
 =?utf-8?B?d1Qvc0hsbXZUTHFiVTA2ek1mQ28yVkRVbDZpcFQ4NkxqSG5qOXE2VzlrcWk2?=
 =?utf-8?B?MHJ0VDZZTVZUY2hsNnFQSjNjcmJEOVBObENxOEFuZWttV2ovZWtORmtsL1FE?=
 =?utf-8?B?TDRUb2FjTXFjWHJpTEJVVDN3NE9QZVMrNHdzVVV1Q0kwR3pVS0NLMDJuVmkz?=
 =?utf-8?B?dWlra1dnWEp6ZWVtSG5nMnBicEJuaHMzM29tWmlRV1orTk5hRXlKS0MxUUlQ?=
 =?utf-8?B?ZC9McnZaV2s0YXV2em5IWVNIZ0hzYnJiclBuTEtndlpDYUxnRTlUTW1GUW9K?=
 =?utf-8?B?ZC9OZnBKU2Q4NzF2cmY4dHdDWWRxQUMyem9ROVVlU2JXZnJrVUtHVkRZN21Q?=
 =?utf-8?B?R0VEa29kVitRMVJBNGtsMHB6bUEyRG9BTXE1ZFJ4U1pVWEdYMmJmcDI2V3lQ?=
 =?utf-8?B?cDdwL2xYS0E2aVc5elpHckVYc3lydUZDbkJBZ3B0SFdjWGdoQ0EweW1OY2tG?=
 =?utf-8?B?RFRqdEZpZkRRaUlEYldxS2tOaGRYYnFzbnZXbDV5cStTZWZSbjdUSlhJNEVG?=
 =?utf-8?B?UDZhbEtUODhNbEUwbC9YZ1orS0FXYTVyUktXNUk5akdyeDVUendQR0pUeXJK?=
 =?utf-8?B?b0txSk5laWIxOXZreEpwRXI1T1FzWUs5d1haYm9DemdwcGdOTXZlK3YrZFlN?=
 =?utf-8?B?YlJPRW01STJ4VlZzMnJ2OUFhemVxdndTV1ordjlIdlVqVWQwUElnVG43cjJB?=
 =?utf-8?Q?Ajul3v?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR07MB9604.namprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?V0ljVDFxSm1tQkpVS1ZpNDM5SzB5WmlNU0R1M0dwWVhSTlNzS2hJQ2VFcUl0?=
 =?utf-8?B?SUc3ZXN1TEJSbk42YTVvYXVVYjc1UTM4dVVLM1E0R0ZxcmR5SDZMb3hUbUJT?=
 =?utf-8?B?cGVUMzA0bnpTVkluYjREMmZJNDc1YVlCY0tDbnQwdU5pcXNBWU1nc2ZzZDk0?=
 =?utf-8?B?NmNCaDgyeFlSVjRYYWdreHNRckp1UWtmcW1MaE1GeWc0eDZrV05wM0ZIUVdq?=
 =?utf-8?B?dURuSXNvTjRuZTBHZ2tWWW5NYkJDMmhoZnJlajE2dm5iaEx2SlMxcFU3eVN5?=
 =?utf-8?B?bGJlYVljc0ZuN2FMUzJ3djdjckYyTms4VS9TdTJxMEpycEJFV254ZG1NcHNt?=
 =?utf-8?B?SGhMTHlqc04vZmpOUXZwK3BIckpZMG1zTVpQQzdXc200WE1rcnhhODhDc3Bm?=
 =?utf-8?B?UnYrOGVnRnhKTFVTWk9UTjlDdElnUGVDeWNpdnhqKzdFS2xrWmM1TDRQZ0Np?=
 =?utf-8?B?Z244MExQZ2I2MlZ6czFnUkpGMHc0WnZsOGlCa05rNHRYWmYwaDJiTUo1N3Y2?=
 =?utf-8?B?ZDhHbCs1YzdNSVRwdXM3S2cyU3V5cGpwS2R6N3Y1OHdTTzZHY0d1QmQ2bStY?=
 =?utf-8?B?U0pINUQ4bDAvek1DU2NWSVM5Q084N200STZCKzliZUUvUzNRTThLNFdHQ2NB?=
 =?utf-8?B?UDlEeGp3VUt0MmxXWFBhWGJFK3Myb2V1Z2xWaTBORUFhQldXQmZWcGJZdFFk?=
 =?utf-8?B?TWQzMld2L3g2VURHVGcydkRJMFVwaWRVaDBaUmxaNWd2Tkc3bDd5VTZJbE5t?=
 =?utf-8?B?VGVzckkwS2R4M2EzOUZOK1krTVdldFZvTzJDU3lIMGNaZ0s4UmxPNEE1empM?=
 =?utf-8?B?TmI3U3ViYVlsRGUvb2lQeU5mQ3NiUFVUaVdPcjlUVzNUKzlrNWVSQXVac2JW?=
 =?utf-8?B?d0IwUXQ1N3lSZWVOL01jRjQxMWRURFplS0psNGZGYkhqcHMzdlUzMWpTckNC?=
 =?utf-8?B?THNuQVpnWVVERUZtL1NsNWc1WDdBczEzcUEzc0RHU3MvR2cvQ0dYUEZXS2dG?=
 =?utf-8?B?VVBmeTlSV0tOK3RKOE00WEs3akFNc29jaG84UHRYZDMrK29qQnFTMmtmR3NH?=
 =?utf-8?B?RStHSVh3L2YyM1hoWWRyZ1UxVmRrSEZyVHA0cVJjSGVuWnRmMGJMYk5zQUVV?=
 =?utf-8?B?OFhxQXQwWC9zTGZZL2JLZjFGdHBKUFdMR2YwWVIwMEJtVitEbzR3VkQ0K0J5?=
 =?utf-8?B?c2RsdDNlSlpHU1ZoN0ptcm5MNENmWnBtazZGQWwyc3U1ZFgzTUpxN0JmSEZG?=
 =?utf-8?B?RG9KTVBLN01oOGdQNjc3ZUN2eVlGUklIN3MwWVJKaFRvOG81OExqdmxzcDRE?=
 =?utf-8?B?WWMvWWNTUnZwQlNadnJhUUdEVDdrcWV1TE5qSlVYTmxyMjJLejZqNFBLZEIr?=
 =?utf-8?B?WE8zZ2ljYitFNWhTRWhUQkd5V3liR2VndVhsbTJ4MTlWMDNDRWVPb0xQdU02?=
 =?utf-8?B?Rm13UHFnVmUxZXRENFRacnBCUEM5YVd1cXVKL1RiQ2NKWHpsSkxvTHFOZjVJ?=
 =?utf-8?B?K0owQWZ0a1BSTjgzb3lTVktJVGVSeXVpWkxmdzJMbEdnTFJxNGJqTXpGZnJB?=
 =?utf-8?B?V1FRdXlxWmRxMlhjNHFHMC9CbzQ0dGtwS3lKU2N3czJwY1pHd1JkS2lybmxr?=
 =?utf-8?B?bmhNUFpDMFBkb2NFWTVGbmNSdTlEdEtrOEtsSHRCTHpDTStGcTFjQ0RoaGxh?=
 =?utf-8?B?N2E2YWtsblhVNHNXc1RNeC9BcHBkcjk3WlpxQ2xZL3pVTTZHcnVxSFVYQWdt?=
 =?utf-8?B?dGJ4aTVzLytpVVB5OVNQYW5GMG9uZktISkd4YzROR0RKczRNZnJyOE1DbDZ4?=
 =?utf-8?B?R1lvNzl6RFMrVVpQM1ArWTAwbS9nL3JGYUJINTk3Y1A0U3UvZ2JMQVhrNUZn?=
 =?utf-8?B?WGYyYUlPd3RyNDNqNDc3N2JkWndDTkxpK3VLa3pDUG43ZmxmSTZjU0pFVjlF?=
 =?utf-8?B?REJQUUNjNmxFaUtLZE9xK1h0dXZXdmlGdlJDRTBjdnNGYU1kZVRLMHZ1T2kz?=
 =?utf-8?B?WUhSWWZjRmpJM2pwdjlMa2lHRDlYMmJIb0lqQ2wxd3JPREpTQnAyRHJHbzV5?=
 =?utf-8?B?dmFxaVJrVFRqMFNOaDJBaUt2NDB4aThGTDJRM1p6TzdwSDNTZG5hOWVsR1pX?=
 =?utf-8?B?cDdlS3UrZ3hneTYrajUweFdEQi9zN0p3MllPb0EvZkdZdUxobHVvVlA3RGtV?=
 =?utf-8?B?a0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <14E408C1DB07C6498873CC63FB1FB3D0@namprd07.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 2cebc459-fe17-4895-c4af-08de0634740c
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Oct 2025 06:32:28.8125
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ihMWHj8bfmBySG1PWlCYUP8sFvqJzGtkqc/7EgNEEZQhAP2oqaGBgInvL6PCZEO9cbr1jkOEsVJA7Q6oaZBrgA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR07MB8407
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDA2MDA1NiBTYWx0ZWRfX7/6ablD/gFHa
 KB33uGGOsdhGMjwBl6aelynM9+Uyki6DvEhTTPa5JxnPThMB/ieJ2khb+6JcIxC+4rVbVaARo6M
 +kpQ2rY1XccfUzITHvUuMBXTwCcK6XhneCpDlzSjrOjeu/Kibzq3mChNn1VYPWOsUEYKSpmq0gR
 xEOtK2yC1pIXEBcKaQ+6+BfY/pfRBbxIXRVAiagVmZF/QJgKr8BSQOxlE9AGJ5ITMIs3M1Ii2UZ
 EQH0cxVVMWrHjWHvNjlT3sSNmYFxxydMSetLH71jF0WMIFLxNZPa7oT3ozSjAVd5KAOyx1IFmGq
 wo35QuV+qY8nZ/5rnSIhZIYLTOEf0wNAlkc6E7HBWrsnBnc/ND9zdBMCNE1fF8CigXHv69t1Tch
 3Vw4plBBPI6oLTLB9kp21Fbry1tRZA==
X-Authority-Analysis: v=2.4 cv=P9A3RyAu c=1 sm=1 tr=0 ts=68e60583 cx=c_pps
 a=gm/QZ0ERG918agb7PW944w==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=x6icFKpwvdMA:10 a=Zpq2whiEiuAA:10 a=R0tnyDT27yLCS029gEsA:9
 a=QEXdDO2ut3YA:10 a=HhbK4dLum7pmb74im6QT:22
X-Proofpoint-GUID: ZduNdDtZa3EGfYsGPDbHk6QDHXIAURgU
X-Proofpoint-ORIG-GUID: ZduNdDtZa3EGfYsGPDbHk6QDHXIAURgU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-08_01,2025-10-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check
 score=0 malwarescore=0 bulkscore=0 impostorscore=0 adultscore=0 clxscore=1015
 lowpriorityscore=0 suspectscore=0 priorityscore=1501 spamscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2509150000 definitions=main-2510060056

SGkgT2xpdmVyLA0KDQo+IE9uIDggT2N0IDIwMjUsIGF0IDAxOjI2LCBPbGl2ZXIgVXB0b24gPG9s
aXZlci51cHRvbkBsaW51eC5kZXY+IHdyb3RlOg0KPiANCj4gRVhURVJOQUwgTUFJTA0KPiANCj4g
DQo+IE9uIFR1ZSwgT2N0IDA3LCAyMDI1IGF0IDExOjEyOjMxQU0gKzAwMDAsIEphbiBLb3RhcyB3
cm90ZToNCj4+IEhlbGxvLA0KPj4gDQo+PiBJIHdhcyBmaW5hbGx5IGFibGUgdG8gZG8gc29tZSB2
YWxpZGF0aW9uLCBzb3JyeSBmb3IgYSBsb25nIGRlbGF5Lg0KPiANCj4gTm8gd29ycmllcywgdGhh
bmtzIGZvciB0ZXN0aW5nLg0KPiANCj4+IEZpcnN0IEkgYXBwbGllZCB0aGUgIkRvbid0IGFkdmFu
Y2UgUEMiIHBhdGNoIG9uIHRvcCBvZiA2LjE2LjkuDQo+PiBJdCBmaXhlZCB0aGUgZXJyb3IgbWVz
c2FnZSwgYnV0IHRoZSBHdWVzdCBkaWRu4oCZdCBib290Lg0KPj4gSSBkaWRu4oCZdCBkZWJ1ZyBp
dCBmdXJ0aGVyLg0KPj4gDQo+PiBUaGVuIEkgYXBwbGllZCBpdCBvbiB0b3Agb2YgNi4xNyBhbG9u
ZyB3aXRoIE9saXZlcuKAmXMgc2Vjb25kIHBhdGNoLg0KPj4gR3Vlc3QgT1Mgc3RvcHMgYm9vdGlu
ZyBiZWNhdXNlIG9mIGFuIGV4Y2VwdGlvbiwgd2hlbiBhY2Nlc3NpbmcgWkNSX0VMMi4NCj4+IA0K
Pj4gSSBjaGVja2VkIHRoZSBFU1JfRUwyIHJlZ2lzdGVyIGFuZCBpdCBoYXMgMHg2NjAwMDAwMDoN
Cj4+IA0KPj4gQWNjZXNzIHRvIFNWRSBmdW5jdGlvbmFsaXR5IHRyYXBwZWQgYXMgYSByZXN1bHQg
b2YgQ1BBQ1JfRUwxLlpFTiwNCj4+IENQVFJfRUwyLlpFTiwgQ1BUUl9FTDIuVFosIG9yIENQVFJf
RUwzLkVaDQo+PiANCj4+IEnigJlsbCBjb250aW51ZSB0aGUgZGVidWcgdG8gbWFrZSBzdXJlIHRo
ZSBpc3N1ZSBpcyBub3Qgb24gb3VyIGVuZC4NCj4gDQo+IENvdWxkIHlvdSBwbGVhc2Ugc2hhcmUg
dGhlIHJlcHJvIHN0ZXBzPyBBbHNvLCBpcyB0aGUgZ3Vlc3Qga2VybmVsDQo+IHVubW9kaWZpZWQ/
IEZXSVcsIEkgdGVzdGVkIGt2bWFybS9uZXh0IGFzIHRoZSBrZXJuZWwgYXQgYWxsIGxldmVscywN
Cj4ga3ZtdG9vbCBhcyB0aGUgVk1NIGFuZCBFMkg9UkVTMS4NCg0KSeKAmW0gcnVubmluZyBhIG1p
bmltYWwsIHVubW9kaWZpZWQgTGludXggNi4xNi4wLCBmb3IgbXkgaW50ZWdyYXRpb24gdGVzdHMu
DQpJdCBvbmx5IGhhcyBhIENQVSwgYSBHSUMsIGEgZmV3IFVBUlRzLCBhbmQgdXNlcyBpbml0cmFt
ZnMuDQoNCkluIG15IFZNTSBJIG9ubHkgc2V0IEtWTV9BUk1fVkNQVV9IQVNfRUwyLCB3aXRob3V0
IEhBU19FTDJfRTJIMC4NClRvIHN0YXJ0IHRoZSBrZXJuZWwgSSBzZXQgdGhlIFgwLVgzIHJlZ2lz
dGVycy4NCkl0IHdvcmtlZCBmaW5lLCBzbyBmYXIsIGZvciBhbGwgb3RoZXIgY2FzZXMgdGhhbiBT
VkUgJiYgTlYuDQoNCj4gV2hpbGUgdGhlIHRyYXAgdG8gTDAgaXMgdW5hdm9pZGFibGUsIHJlaW5q
ZWN0aW5nIHRoZSBTVkUgdHJhcCBkZXBlbmRzIG9uDQo+IHRoZSBMMCB2aWV3IG9mIENQVFJfRUwy
IHdoaWNoIG9yaWdpbmF0ZXMgZnJvbSB0aGUgaW4tbWVtb3J5IHZhbHVlLg0KPiBVbmxlc3MgdGhl
cmUncyBhIGJ1ZyBsdXJraW5nIHRoaXMgc2hvdWxkIGFsd2F5cyBiZSBpbiBhZ3JlZW1lbnQgd2l0
aCB0aGUNCj4gZWZmZWN0aXZlIHZhbHVlIHByb2dyYW1tZWQgaW4gQ1BBQ1JfRUwxLg0KDQpJIGNo
ZWNrZWQgdGhlIHBsYWNlLCB3aGVyZSBpdOKAmXMgZmFpbGluZy4NCkl0IGxvb2tzIGxpa2UgR3Vl
c3QgY2xlYXJzIENQVFJfRUwyIGZyb20gMHgzM2ZmIHRvIDAuDQpDUEFDUl9FTDEgaXMgMCBhdCB0
aGlzIHBvaW50LiBUaGlzIGRvZXNu4oCZdCBzZWVtIHRvIGJlIGNvcnJlY3QuDQoNCjgwNjIxOTJj
OiAgIG1ycyAgICAgeDAsIGNwdHJfZWwyDQo4MDYyMTkzMDogICBhbmQgICAgIHgwLCB4MCwgIzB4
ZmZmZmZmZmZmZmZmZmVmZg0KODA2MjE5MzQ6ICAgbXNyICAgICBjcHRyX2VsMiwgeDANCjgwNjIx
OTM4OiAgIGlzYg0KDQpBbmQgYWNjZXNzaW5nIFpDUl9FTDIgaXMgdHJhcHBlZCwgYW5kIGNhdXNl
cyBhbiBleGNlcHRpb24uDQo4MDYyMTkzYzogICBtb3YgICAgIHgxLCAjMHhmDQo4MDYyMTk0MDog
ICBtc3IgICAgIHpjcl9lbDIsIHgxDQoNCkxvb2tzIGxpa2UgdGhlIEd1ZXN0IE9TIGV4ZWN1dGVz
DQouTGNwdHJfbnZoZV9cQDogLy8gblZIRSBjYXNlDQpmcm9tIGVsMl9zZXR1cC5oLg0KDQo+IFRo
YW5rcywNCj4gT2xpdmVyDQoNClJlZ2FyZHMsDQpKYW4NCg0K
