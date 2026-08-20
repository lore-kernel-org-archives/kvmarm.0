Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BC9C2E8B67
	for <kvmarm@lists.linux.dev>; Thu, 20 Aug 2026 06:32:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787207567; cv=fail; b=NcOK0whF2C5Y0oCl47cltn6kvHfpAPMnXxDWckxEcnjzxXKmEXpU0+Ml5xGfmXMlJ5SEwTZdirIeUJk3952/KQY+tPnWMuc28hF1zvaHs1tMqFxVF3GffNL+YOtwxECM0va0GDmVnw++vdiStQACcjeosBO4rinQiyfRtB5+Kco=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787207567; c=relaxed/simple;
	bh=gnVO+R8JFyRVvYrxI87wrVVaKvnCHmHicNMyRmAB5CU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=oN1T11QUMFHqOSEZ8nJvLXQ98hxT7BBRSrsFqbk5E9/pISZbxmJqxpk9rXke6sqmO3fBw/dqrSDI//NzPBzk6q2UBEYwbw16R4AIeILjInPy7AWCsjOlpYOQLcoTZ046AmSiYxwiso+6EJJ3e6/SbdxY7krDYpcklYVT0oGftJ8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=SrB+y97e; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=IDx7dZC8; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="SrB+y97e";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="IDx7dZC8"
Received: from pps.filterd (m0127842.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67JLAqah3970727;
	Wed, 19 Aug 2026 23:32:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=gnVO+R8JFyRVvYrxI87wrVVaKvnCHmHicNMyRmAB5
	CU=; b=SrB+y97e6auAKZScDIqtvMjjfQiI1qn5iqNo4cCORtpsUm2gKT3KqCrxm
	8RZFbh7n6B+KX3AR4gvzPZMkHQ75GxHkvYRz10nj6C8sbQcmx/ewAfFKwZ+o05Tw
	6ilGtKQhDRjMpXA37W6MZH7pRVD5zy52B4KWRm8zQOUZLmicJy1YXViq43+pNgvV
	bL1or2h9XJIcfmX1fCTajser1++nVw02RALxBkusqBLta+cdZ4t43x+du67ID6r5
	ZlkjdzY9mJFlNmtpIPiZkpfDcqKGTW5U36j66KYy9YVomgNJIWe1p3DKto9pVSL7
	RbArAYmOcE+Atg/Y1+8ZkoBwfWZFQ==
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11022109.outbound.protection.outlook.com [40.93.195.109])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4g4wg3vhw3-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 19 Aug 2026 23:32:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kPwYRdZWQ6c4VTgerjiXryiiCNK+Blnf6AkEz+xd3241X7sfQft4r/COfDn/xcJivk8vhU2v5typ/9MO5KvVcSmwB8YiDupGM7OLS+4+wAoSKWsLl5DOVwzOsAo9z86w1curCxV2lBB/WqKM+AbAXIjk6YFJJk46H8bn6Z0cpw/9VWYB9+fmqL54iXDNNMXa/vsAA0eB9I1GxMweVbMRiORr5Zv5JyXlusgfZoPu++HiIrwUMRKYac2V/X7yit7mrBuhYRu6ur77oSCGhImKONnbng1+v5Jp7XpMAKCPcNc6IEDGMdNQL1UWMJaAQXksmZu2xfaK21EnD6KtQHGTDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gnVO+R8JFyRVvYrxI87wrVVaKvnCHmHicNMyRmAB5CU=;
 b=wz3keS50gC3nrSlSSbwJCqm4yRvg09ZzCWeip7NtHL5zZd8LwE0C25Pl0reBHUcOA8UEreCBVMSMiS7eqHCnSYrh2Hnghl5EtTDIUWni0YF0T/FQCgCkAE8avoilXHZzHCQXyaDEgR/Ey5Ca9rKGwxx6QWTTg+qYfbqrm3qUoHz9ImWONJfZnxkeYCltiVkBjQUZa1WPhFbLfMtTXFOdCgJMclsCnEvdiw9OHdgx0JZyWy9fvp7s5j4sNZ5nlyqDSIuGAgPXu5+lud3n9sfzz66BJf2g0M1pnvSb6oUdjbKOvbWKx5ceLOeTDA7k/XF4RsBZHRlo0suW3JXiX6axow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gnVO+R8JFyRVvYrxI87wrVVaKvnCHmHicNMyRmAB5CU=;
 b=IDx7dZC8SxExSexaBS/AUIeCp8701chpE2tmOz1mWzEXS5Jk2/HDdNdhq7B3ivL/+FYaKUAcYI+ndHGiqf/afvPKmANcAoVRip7OXxrGXY1qVC3BZ49o1lPZlGbSJGnCIQfWI3m56zqe/oZupz44z92hx+BgYzH59Ti/Y8sS8NM/n2xTXcZH31cOnqiuqUT6CoULerb8IndUcTae0vF/3qKsXLbD0PWr1GQ3ALEps3etFsCW/ZIV6tg8kXOzi4idVxATyir9tn4MH0/9urFK/i9CA6MjGcTlZJV0QvjXQoYgUl0IWWop/nVrkG5uRzWN3l3eVChKOejLHnZ8/9hVZA==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by SA2PR02MB7724.namprd02.prod.outlook.com (2603:10b6:806:136::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.8; Thu, 20 Aug
 2026 06:32:23 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%5]) with mapi id 15.21.0339.008; Thu, 20 Aug 2026
 06:32:23 +0000
From: Khushit Shah <khushit.shah@nutanix.com>
To: Eric Auger <eric.auger@redhat.com>
CC: "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "qemu-arm@nongnu.org"
	<qemu-arm@nongnu.org>,
        "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
        "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
        Shaju Abraham
	<shaju.abraham@nutanix.com>,
        "yangjinqian1@huawei.com"
	<yangjinqian1@huawei.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "richard.henderson@linaro.org" <richard.henderson@linaro.org>,
        "sebott@redhat.com" <sebott@redhat.com>,
        "skolothumtho@nvidia.com"
	<skolothumtho@nvidia.com>,
        "philmd@oss.qualcomm.com"
	<philmd@oss.qualcomm.com>,
        "maz@kernel.org" <maz@kernel.org>,
        "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
        "pbonzini@redhat.com"
	<pbonzini@redhat.com>,
        "armbru@redhat.com" <armbru@redhat.com>,
        "berrange@redhat.com" <berrange@redhat.com>,
        "abologna@redhat.com"
	<abologna@redhat.com>,
        "jdenemar@redhat.com" <jdenemar@redhat.com>
Subject: Re: [RFC PATCH v7 02/18] target/arm/cpu-sysregs.h.inc: Sort by name
 alphabetical order
Thread-Topic: [RFC PATCH v7 02/18] target/arm/cpu-sysregs.h.inc: Sort by name
 alphabetical order
Thread-Index: AQHdMG2oGd+IodEGCEW6UnjCai8fKA==
Date: Thu, 20 Aug 2026 06:32:23 +0000
Message-ID: <56FB4FAB-B9F6-428F-B5E2-B1D13576C39A@nutanix.com>
References: <20260726153221.24773-1-eric.auger@redhat.com>
 <20260726153221.24773-3-eric.auger@redhat.com>
In-Reply-To: <20260726153221.24773-3-eric.auger@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA2PR02MB7564:EE_|SA2PR02MB7724:EE_
x-ms-office365-filtering-correlation-id: f4a16141-844c-4794-17da-08defe84cb3b
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|7416014|366016|376014|23010399003|22082099003|18002099003|56012099006|38070700021|4143699003|10067099003;
x-microsoft-antispam-message-info:
 olmQIgE3xUWS/nzhrplFRAEyYBZw5kEMeh8UQX0Tjr8KCqpexD8+VYAoocdQDbf2LVIatzF3e/+uL76z6sAIxXeyFuTONn6Q/Rxwzl6pGgL1XyC6P0Cf9onLw4VzM+PeqEvu7bW983+I7EaXmBx5+pm2j7evi/UK28nSyC5SyrNNDU8296ea0sPHoWNjjqVuv444McAXXyIay9OyeSOV6qp22YlcsL/uyGejKYr+UkAUbvbSiOx47ElB2YHMcHZgHoH2JxZb3Yd1SW4TR2eCXPiBxXIWO/BO5EgnGHJZ5F1zUCdQkWfgRN/1+XgrJlwBp+cw2+srPwYsSUoO2skWwmORDyOixznRZxx1+/VSTtyQQN4AK4lNhHDNsg1ncyTyzgxi1+IGTkpg5xnhgvUiVg543CZOQH612uMAWJ4Q4b3mI6yYBO533GjDRdPws3+1HcHOVEIUO/cx4vZ5TgzXNySXcFLP0Iz5p+mgGWNZPrqmqZ5CAe10miPDdQoHIDKxLTEjca8im+FeJdN2JyDTzZXhWyWKFIyX0h1dXY+pesFSm66GOK01FJx/QpLpMO6JLdOFn5SDAoOCDdRDsJMQNEEmLYZ7B5UYk+xGq05HJgNeAA4IxTrIf+yRMdCpubkf9YfvBH0GBaGlsrCEE5E614nMBWt7Vgulkkb1P72Xby7kaLzyQREMJrLmZrCgwVRpvMnEqGqfFH84FOz5qYSJmivU3uCy5+5EwODX196iWt0=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014)(23010399003)(22082099003)(18002099003)(56012099006)(38070700021)(4143699003)(10067099003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?NG9RNTdCNnhuQ2hDOHJSdFpMWE13NnNuTVNlbW9RcFc3dm9mRndhQ3dGSGlH?=
 =?utf-8?B?OWhiMGpBSHRqbmU1bXpYdk5vVkVodkJucGk3SkowZUpBa25wK2ZSb3QvMHov?=
 =?utf-8?B?VUtWaDhkT2pYSUo2aVBVQTNBZ05vbTlCa2YrMFN3MThGaGxZa2RVcGFMbTd1?=
 =?utf-8?B?UGxLRjc1cmNFdVNDRW93aWlaQVJaL3A2TFpSMTZDTHVOcHUxY1U3eHJaMm9T?=
 =?utf-8?B?ZGlVWEJLdUdmeE9SRzhvMkV3M3NubVpjVStYRDU3c3VxYlcvSVAxeHpLaDh4?=
 =?utf-8?B?Q1FFb1J3WGVuYlRFdVp3Y3hZQytOQWlmVEZFa2RGSkVrenNsOU9RUE5VY2RD?=
 =?utf-8?B?RHplaGhpSkhJeGVhNDRxQld1c3hLbzhudWpkb2ZYNkgvM0lnUFhaanZpL0xn?=
 =?utf-8?B?V3V3dERkTWhFb2RlRVpYbHMvakRQc0kyVUZTY3lHaVY3SFA0M01rb3ZGcHVv?=
 =?utf-8?B?QVhJWXlNK3pyVVp0VFJldi9xSSt0d0VYbEVYNHY2SEFuT01KMGFkTm1kN1Nz?=
 =?utf-8?B?ZG1ycS8vK25FSWtyY1FtQVBBUWk1QnVLL0x6aGZUbng5ZHp5ZnFEZGt5YWdJ?=
 =?utf-8?B?REZibGo2cURQREZMTzh1TWVSUTY5Mkk5bDB4NjkvNC9GNzRGb2JlWks1ZVRs?=
 =?utf-8?B?TXZZcVBZWm9FczVIM3BPSVFVODV3K0txSlhpSG9FZ2FkWHhOWjFIMmFlUFdu?=
 =?utf-8?B?dm5VdXA1UlVVV3F2TTdhUllMSE83YmJIQXVReWRlUE9KaVVWV3h1WFBmVFVS?=
 =?utf-8?B?QXMzZEI5bDhOVFNUaWREa1hKOXl1SDZFMEpnZlVLUDZ3Q3ZZWXlzbmhSdHMy?=
 =?utf-8?B?bTFiMjhhVlpYOWVSa1lHVmZHdWFzNEdwOXZTZ1FxTGFwYlNUa3JFdHRhTm13?=
 =?utf-8?B?ZmxvUzdGVWt2SmhaMkp3SmZJNmxUOVg3SVFqaGxsU0RxbEczajQvU3ljSXNE?=
 =?utf-8?B?U3BlUTZzSXk2RjdTWFovZHlZeS9JamY4Ly9OZDBlYjBBczN1bkhhTVFrRWlZ?=
 =?utf-8?B?TVVnS2Q5ZUZLVmhuSXdzbnZPbHlkdFd2dFdQV3o4aWVJa2owUXgzMVl6TzJj?=
 =?utf-8?B?cGNQODE5bjdycEJ4U3VvYkZiVjUzQTMrRG1jTlFYQkg2NFJ4eitUcWE5OHYx?=
 =?utf-8?B?MmdKSXRsZTdSRVRvSU1FN2FZVitiTldDWDAzWjVVVXZ1by9uQkVTWGNZbTEw?=
 =?utf-8?B?d3hBSEM3OEdpdWZtVmtXSTh4cGV2cVFLTXFTdjlNREF1ZFFQWGc5RkVqZWV6?=
 =?utf-8?B?UHRtcXpTckk0YUpJTW9NQmJzZ1ljQjZBU3V2a0VBbWYxU1BERzhHa050OFFE?=
 =?utf-8?B?dWVYOHRJbDV6UnJBT05DRmVKakx2dHNSUWs2ZElLS2t0Y3NqakdFRlVIYkpk?=
 =?utf-8?B?QlpRcDJPcEFDalk1VEhhQ1pjTVRIRkkvdGtLUEZSc3hBWGh4dmRJSzFud0Mr?=
 =?utf-8?B?TVlya1NtaHVVYk1vcVEzak1OWTE0OUFPc2MwNWFtWWpEZ2dnaFg2WjA4bXdE?=
 =?utf-8?B?QnQzcGVCTVR4NXovbk1qc3RzZ3d0cm5HYXdQQ3hYcCtkZ1RsSG9yZUVMZXVZ?=
 =?utf-8?B?QUxSaUp5RXNzbUFndVRhL1RpaGpVU0VETE1wSGw4dEFEK2x1SHdNSTdNWHVy?=
 =?utf-8?B?VTZ4OTc2UkIrZlJsWmlXU3NkMUVpZE9NL050OWpraU9vcUpqczd1MXY4RDJK?=
 =?utf-8?B?VTRFYTFlY3JaWVJObDRLSE12OWNEVVlUZERnQmtVdjlQMjNWTGNiQ0c3OGhi?=
 =?utf-8?B?OUtNYzNKRHJTb3JVRU1Eb1NrZ01UczErVWlHV0d6S3hlc0l0RFJzVGxCU293?=
 =?utf-8?B?N1ozaW13L3U4V2JiN3RMTlZ1Vlk3UlU3aHRHRlZBVko2THViTmJ1dzV4bjZV?=
 =?utf-8?B?ZVpBbGlMTmdWMXE4M2IzeWdvMlJNNm5VcmhaQXlzaWRRcDZERDJQTTc5dHhv?=
 =?utf-8?B?QVN5endTTDhTUHpHSEVFM3NlY2VhMWhXZWhsZktScFF0V0NvYTRBL1FpcW5t?=
 =?utf-8?B?dTJEdVY3b3NqNUVOT1NZTW9oRVVrSmdQNi95dlAzR3BMOXlJaUxETHdSZU1Z?=
 =?utf-8?B?ZnNlcS9Pb3VzaTZwK0dzQzQ5NjNqRkQyb0xjWXJqV1lGbVNMdHNzdEs4S2pl?=
 =?utf-8?B?OXR6b3NuSHhRYXZ4b01kTC9FL2FadXhMY1RPbFFvM0FidTN0UTVjaG9LRStF?=
 =?utf-8?B?TUdYWTZQY1FLYktZbnpKTjY2VDVoa0VVQmdQcDAxaUpQK0dwKzhRZGNrYVVM?=
 =?utf-8?B?UWVXMTFqWi9XWlV3R2JnYU5CVkhHTmJQc1ZBL1B1Y2l3MG9SMmZLcjVDeHlL?=
 =?utf-8?B?NFMwRXFOZWEvRXZOTjdraTRrWUkwZEZmWUw1VmtoN0tDeVEyMFpVZ1l4VTZt?=
 =?utf-8?Q?0fOvF7U16bBDz734=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <88FBE1836F21BD44B1CCECD2E1EFD3E0@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	L+QkWWerujX/G2kyw2mr5q4fZpXmoJynMgv95H1UmiZxx2m50pwAXc7LGImfoDrkBsKmtz1SsW9tTzkJvBcGD3r3VwouzVzhEf9xXsMKVpvObapSmCneBus5zXa5u0tq8sgpprtqLg/+o4mUMFX7nTFrXXROETiNJlyB8k+vGQvtbuq5QVKeePh664wMOJoybH0crxBTVWt7+zd7XaWJJx54vj/vNSuTtEMsl5CbDfPo1BNPEeHhUEYa0/JFR5dgUL2IXpc4zh5ZzrxC0I9XMmCovKgv7uo3TwkWjKlu59OBR7wqKnf2qNu5jog/2QrYIeDMw8+s/1INNjHX4jR8TQ==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4a16141-844c-4794-17da-08defe84cb3b
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Aug 2026 06:32:23.1509
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: APWNcETCe5Qh4Xf4TfQBMlBpry6qZyfQbukX5FXQEML7qI/jA8YBH0aq0Qhdp7syvobcAtQTXP3yD/vUJ5S9onhss9tXCK/d58RHeT1cFBM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR02MB7724
X-Proofpoint-Spam-Info: AW1haW4tMjYwODIwMDA0NSBTYWx0ZWRfX/Z3UDk/3vxj6
 JovgiIq2oP4/Upr8Y+wvJAJqU/0j5i39Gir0D4JvplhflT1+s2WrpvF2rAuN/E4Jv1sHtoldXpV
 5T8270SoF0KEVbh0ticbDzHYG5nD/3E=
X-Authority-Analysis: v=2.4 cv=c+qbhx9l c=1 sm=1 tr=0 ts=6a869f79 cx=c_pps
 a=o74NBiIPioXkFKZqBywf3Q==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Sv0fKeRqtYgA:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VofLwUrZ8Iiv6rRUPXIb:22 a=VUi8bpU7OL1Oj2-RSIOF:22 a=20KFwNOVAAAA:8
 a=Ikd4Dj_1AAAA:8 a=64Cc0HZtAAAA:8 a=7p2mnGJBOtd2yDpg9ZMA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODIwMDA0NSBTYWx0ZWRfX1Hhf2/krgfax
 EG9Op4jINBRd2z+23cIo+emD4/R1eJ1+oX/5S88Fo/skvb2PkOj99DqnX7n0K3/n1JuidoDqKfP
 tMpQFbolFHUuVi/5qjRX5pd0zsCvtZnsotc8PON2Zb6ouuP36tabPicqfrBDqsxlpj4bZn6Negf
 MxFfb/yVCqv19WK9KINso0Odi6EgFqosLqQPmSg4XHBITRi1to0p+1EwFUqwKeAxZVXk/FKkBvp
 SX/CoF1WMUMifveqAN9EAfDUORLBccEYvKAuLEdK4aUK266xcvm8vnpek8+/U2PHGNa7/Sta05m
 GyRzffFxnFR6riogjAlD9lXc3X98PpGj9AnItEhEX6ZRUm/kebRgEccS/j/+4SsgEcTrmeqYVIQ
 kwOSHccGK0DtNQiIf7iochfnJWaaLHhzfBYTALMNuwV0or8sjmM2m4/F+VIQEcAcvl1Ghyom5o+
 kK59XPEh/fJ1A2xlCpg==
X-Proofpoint-GUID: dQkOKeCTf-6CHjgpjvFY3UO3mbVyZKvl
X-Proofpoint-ORIG-GUID: dQkOKeCTf-6CHjgpjvFY3UO3mbVyZKvl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-19_06,2026-08-19_02,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gMjYgSnVsIDIwMjYsIGF0IDg6NTnigK9QTSwgRXJpYyBBdWdlciA8ZXJpYy5hdWdl
ckByZWRoYXQuY29tPiB3cm90ZToNCj4gDQo+ICEtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tfA0KPiAgQ0FVVElPTjogRXh0
ZXJuYWwgRW1haWwNCj4gDQo+IHwtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tIQ0KPiANCj4gU29ydCBieSByZWdpc3RlciBu
YW1lIGFscGhhYmV0aWNhbCBvcmRlci4gVGhpcyB3aWxsIGFsbG93IHRvDQo+IGVhc2lseSBkaWZm
IHdpdGggdGhlIGZ1dHVyZSBjb250ZW50LCBhdXRvbWF0aWNhbGx5IGdlbmVyYXRlZC4NCj4gDQo+
IE5vIGZ1bmN0aW9uYWwgY2hhbmdlIGludGVuZGVkLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogRXJp
YyBBdWdlciA8ZXJpYy5hdWdlckByZWRoYXQuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBDb3JuZWxp
YSBIdWNrIDxjb2h1Y2tAcmVkaGF0LmNvbT4NCj4gUmV2aWV3ZWQtYnk6IFNoYW1lZXIgS29sb3Ro
dW0gPHNrb2xvdGh1bXRob0BudmlkaWEuY29tPg0KPiANCj4gLS0tDQo+IHY1IC0+IHY2Og0KPiAt
IHY1IHZlcnNpb24gY29uZmxpY3RlZCBiZWNhdXNlIElEX0FBNjRGUEZSMF9FTDEgaGFzIGJlZW4N
Cj4gIGFkZGVkDQo+IA0KPiB2NCAtPiB2NToNCj4gLSByZW1vdmUgc3B1cmlvdXMgQ0NTSURSIGRl
ZmluaXRpb24NCj4gLS0tDQo+IHRhcmdldC9hcm0vY3B1LXN5c3JlZ3MuaC5pbmMgfCA0NCArKysr
KysrKysrKysrKysrKystLS0tLS0tLS0tLS0tLS0tLS0NCj4gMSBmaWxlIGNoYW5nZWQsIDIyIGlu
c2VydGlvbnMoKyksIDIyIGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL3RhcmdldC9h
cm0vY3B1LXN5c3JlZ3MuaC5pbmMgYi90YXJnZXQvYXJtL2NwdS1zeXNyZWdzLmguaW5jDQo+IGlu
ZGV4IDZlOGIzMzViOGYuLmVjNWExMmIwZjQgMTAwNjQ0DQo+IC0tLSBhL3RhcmdldC9hcm0vY3B1
LXN5c3JlZ3MuaC5pbmMNCj4gKysrIGIvdGFyZ2V0L2FybS9jcHUtc3lzcmVncy5oLmluYw0KPiBA
QCAtMSwxMyArMSwxMiBAQA0KPiAvKiBTUERYLUxpY2Vuc2UtSWRlbnRpZmllcjogR1BMLTIuMC1v
ci1sYXRlciAqLw0KPiAtREVGKElEX0FBNjRQRlIwX0VMMSwgMywgMCwgMCwgNCwgMCkNCj4gLURF
RihJRF9BQTY0UEZSMV9FTDEsIDMsIDAsIDAsIDQsIDEpDQo+IC1ERUYoSURfQUE2NFBGUjJfRUwx
LCAzLCAwLCAwLCA0LCAyKQ0KPiAtREVGKElEX0FBNjRTTUZSMF9FTDEsIDMsIDAsIDAsIDQsIDUp
DQo+IC1ERUYoSURfQUE2NEZQRlIwX0VMMSwgMywgMCwgMCwgNCwgNykNCj4gLURFRihJRF9BQTY0
REZSMF9FTDEsIDMsIDAsIDAsIDUsIDApDQo+IC1ERUYoSURfQUE2NERGUjFfRUwxLCAzLCAwLCAw
LCA1LCAxKQ0KPiArREVGKENMSURSX0VMMSwgMywgMSwgMCwgMCwgMSkNCj4gK0RFRihDVFJfRUww
LCAzLCAzLCAwLCAwLCAxKQ0KPiArREVGKERDWklEX0VMMCwgMywgMywgMCwgMCwgNykNCj4gREVG
KElEX0FBNjRBRlIwX0VMMSwgMywgMCwgMCwgNSwgNCkNCj4gREVGKElEX0FBNjRBRlIxX0VMMSwg
MywgMCwgMCwgNSwgNSkNCj4gK0RFRihJRF9BQTY0REZSMF9FTDEsIDMsIDAsIDAsIDUsIDApDQo+
ICtERUYoSURfQUE2NERGUjFfRUwxLCAzLCAwLCAwLCA1LCAxKQ0KPiArREVGKElEX0FBNjRGUEZS
MF9FTDEsIDMsIDAsIDAsIDQsIDcpDQo+IERFRihJRF9BQTY0SVNBUjBfRUwxLCAzLCAwLCAwLCA2
LCAwKQ0KPiBERUYoSURfQUE2NElTQVIxX0VMMSwgMywgMCwgMCwgNiwgMSkNCj4gREVGKElEX0FB
NjRJU0FSMl9FTDEsIDMsIDAsIDAsIDYsIDIpDQo+IEBAIC0xNywyOSArMTYsMzAgQEAgREVGKElE
X0FBNjRNTUZSMV9FTDEsIDMsIDAsIDAsIDcsIDEpDQo+IERFRihJRF9BQTY0TU1GUjJfRUwxLCAz
LCAwLCAwLCA3LCAyKQ0KPiBERUYoSURfQUE2NE1NRlIzX0VMMSwgMywgMCwgMCwgNywgMykNCj4g
REVGKElEX0FBNjRNTUZSNF9FTDEsIDMsIDAsIDAsIDcsIDQpDQo+IC1ERUYoSURfUEZSMF9FTDEs
IDMsIDAsIDAsIDEsIDApDQo+IC1ERUYoSURfUEZSMV9FTDEsIDMsIDAsIDAsIDEsIDEpDQo+IC1E
RUYoSURfREZSMF9FTDEsIDMsIDAsIDAsIDEsIDIpDQo+ICtERUYoSURfQUE2NFBGUjBfRUwxLCAz
LCAwLCAwLCA0LCAwKQ0KPiArREVGKElEX0FBNjRQRlIxX0VMMSwgMywgMCwgMCwgNCwgMSkNCj4g
K0RFRihJRF9BQTY0UEZSMl9FTDEsIDMsIDAsIDAsIDQsIDIpDQo+ICtERUYoSURfQUE2NFNNRlIw
X0VMMSwgMywgMCwgMCwgNCwgNSkNCj4gK0RFRihJRF9BQTY0WkZSMF9FTDEsIDMsIDAsIDAsIDQs
IDQpDQo+IERFRihJRF9BRlIwX0VMMSwgMywgMCwgMCwgMSwgMykNCj4gLURFRihJRF9NTUZSMF9F
TDEsIDMsIDAsIDAsIDEsIDQpDQo+IC1ERUYoSURfTU1GUjFfRUwxLCAzLCAwLCAwLCAxLCA1KQ0K
PiAtREVGKElEX01NRlIyX0VMMSwgMywgMCwgMCwgMSwgNikNCj4gLURFRihJRF9NTUZSM19FTDEs
IDMsIDAsIDAsIDEsIDcpDQo+ICtERUYoSURfREZSMF9FTDEsIDMsIDAsIDAsIDEsIDIpDQo+ICtE
RUYoSURfREZSMV9FTDEsIDMsIDAsIDAsIDMsIDUpDQo+IERFRihJRF9JU0FSMF9FTDEsIDMsIDAs
IDAsIDIsIDApDQo+IERFRihJRF9JU0FSMV9FTDEsIDMsIDAsIDAsIDIsIDEpDQo+IERFRihJRF9J
U0FSMl9FTDEsIDMsIDAsIDAsIDIsIDIpDQo+IERFRihJRF9JU0FSM19FTDEsIDMsIDAsIDAsIDIs
IDMpDQo+IERFRihJRF9JU0FSNF9FTDEsIDMsIDAsIDAsIDIsIDQpDQo+IERFRihJRF9JU0FSNV9F
TDEsIDMsIDAsIDAsIDIsIDUpDQo+IC1ERUYoSURfTU1GUjRfRUwxLCAzLCAwLCAwLCAyLCA2KQ0K
PiBERUYoSURfSVNBUjZfRUwxLCAzLCAwLCAwLCAyLCA3KQ0KPiArREVGKElEX01NRlIwX0VMMSwg
MywgMCwgMCwgMSwgNCkNCj4gK0RFRihJRF9NTUZSMV9FTDEsIDMsIDAsIDAsIDEsIDUpDQo+ICtE
RUYoSURfTU1GUjJfRUwxLCAzLCAwLCAwLCAxLCA2KQ0KPiArREVGKElEX01NRlIzX0VMMSwgMywg
MCwgMCwgMSwgNykNCj4gK0RFRihJRF9NTUZSNF9FTDEsIDMsIDAsIDAsIDIsIDYpDQo+ICtERUYo
SURfTU1GUjVfRUwxLCAzLCAwLCAwLCAzLCA2KQ0KPiArREVGKElEX1BGUjBfRUwxLCAzLCAwLCAw
LCAxLCAwKQ0KPiArREVGKElEX1BGUjFfRUwxLCAzLCAwLCAwLCAxLCAxKQ0KPiArREVGKElEX1BG
UjJfRUwxLCAzLCAwLCAwLCAzLCA0KQ0KPiBERUYoTVZGUjBfRUwxLCAzLCAwLCAwLCAzLCAwKQ0K
PiBERUYoTVZGUjFfRUwxLCAzLCAwLCAwLCAzLCAxKQ0KPiBERUYoTVZGUjJfRUwxLCAzLCAwLCAw
LCAzLCAyKQ0KPiAtREVGKElEX1BGUjJfRUwxLCAzLCAwLCAwLCAzLCA0KQ0KPiAtREVGKElEX0RG
UjFfRUwxLCAzLCAwLCAwLCAzLCA1KQ0KPiAtREVGKElEX01NRlI1X0VMMSwgMywgMCwgMCwgMywg
NikNCj4gLURFRihDTElEUl9FTDEsIDMsIDEsIDAsIDAsIDEpDQo+IC1ERUYoSURfQUE2NFpGUjBf
RUwxLCAzLCAwLCAwLCA0LCA0KQ0KPiAtREVGKENUUl9FTDAsIDMsIDMsIDAsIDAsIDEpDQo+IC1E
RUYoRENaSURfRUwwLCAzLCAzLCAwLCAwLCA3KQ0KPiAtLSANCj4gMi41My4wDQo+IA0KDQpSZXZp
ZXdlZC1ieTogS2h1c2hpdCBTaGFoIDxraHVzaGl0LnNoYWhAbnV0YW5peC5jb20+
