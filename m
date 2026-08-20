Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DD60389452
	for <kvmarm@lists.linux.dev>; Thu, 20 Aug 2026 06:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787207775; cv=fail; b=ur+vLO8Tn/PuMcVPzgRVviLHCZkdVZNy85bBP5VAXyCHKv+o4F5ckcr8epRn26tiDazjooYx8BaLi5ki+eu054Crqh6x1UImu9z3v7Afg9/Z7zpTUARlRkw4Fz5VZhf8Rd68SPeYWXtgFU+gzZ8Ol+XN6Ghsn9bSDVXrgFtETEg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787207775; c=relaxed/simple;
	bh=DmpIZ3slnLuHJdHl2eRoLxjS541MhLgEvtcwnUzvGjI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=tjwRmDMFfJrD0ASEhZSVU7wPPW/tULBeqJtuM3+YO5MZbvg7JH3OEIk5dRpXxGxB1EAoKdMlmtfcVR0dDg/hjYqEknsIECfoMDCIvYC76myDMZhk9+H1dQJSFFUD6VqSUw3SI5ZGAaQB7s0D0YD+UX0LkxnSuQm6LtdqQhIW6KI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=qiNbI4C2; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=QsolDJ6u; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="qiNbI4C2";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="QsolDJ6u"
Received: from pps.filterd (m0127844.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67JLB4rF1442591;
	Wed, 19 Aug 2026 23:36:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=DmpIZ3slnLuHJdHl2eRoLxjS541MhLgEvtcwnUzvG
	jI=; b=qiNbI4C2Rdz3Dnwfe6otzITxSmIf9puts/WSTawD8RTEjdGCUxqp1OqWJ
	s1+m4yDe/3RDVeha1Dr2n8wsbr0EDENTBnbuzA5lY6bjOahrK3pYQofVd+WMyl8U
	gey6M03SwDLpcBQzRe2zMWVy8oclD8gXyuxUIHKflw0dIyKxndfcxmgr7SBH2g1w
	1BpuIwdjMt8GenLyibdCiyBVG9o5Ai86Kvwihz+Jq0y1OIo4/rvqZJeotEIwKeH3
	pBeoIcrWJV9FEoqLKlcPkKbQkOA9eqtN/jYccjXllJ+i70MR5pLoEGAz8rRnRMU0
	ODP2YwI21ZwBhkhCfvcNjKX3/A2Mg==
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11023140.outbound.protection.outlook.com [40.93.196.140])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4g4up4vwv2-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 19 Aug 2026 23:36:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mQcUPacvBZ+y/vOdVGS1KlFuOo8ci6vI4jZjNBqmI+cucL+950T1RR6Ijt3Cj9velYKI+OT/xyIeA8Ch164BMt6YmWGV9Ug1SV8mBEorj82Ni5Ihb1lO8Bbxv6BhHS1zkjnYxbFLooNsd02SEf4NBEXojgWsJXwdTqsYXwEOm6nwNLuDQ37CP61SHVItCWmpu2gkuM6LvRM+A9trZn/sQjCnzid4WCtj2xLeu3do2u6B42Q7koh+KZpWqUovfOtlcMX3lg2sjlwVLwK9lE6k1FyGdiW8Laz90Uuqmwef2OtSR+1GMC7hF757tzBA/EAJDM3RZDHUsoNVF9LEnSFcLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DmpIZ3slnLuHJdHl2eRoLxjS541MhLgEvtcwnUzvGjI=;
 b=FXBs1bohKP2uosZ4nvkjbqDvcWKt990ONpKOsC5iRgZX2dkWRcjjbPN67GbueVrCysAr99TRDkb9GBDxbMokE0LRWD4nBrmC0+seumu4ddFS6znl/nOKxyw3aNuluXbMMvUjHOORwlIPyxQeE8ENtgfLRNbtiZaARWAUrgbhrH5M+Jot5Cym9glXFZkMSsPEqkV2U/Aj5uM9tkqS02n2glF/6H+cvTLL9Gx1OJSYAFOmMFBTdmp8tmT+y89ZjxJu3DM9yj1zH5jk7mH2p9kF+e13eCRqt2XPL2NtNR16zt383xCyQIPSvIwUYHHwdDsueQRDLpsOKkO6zRS+MQ/9JQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DmpIZ3slnLuHJdHl2eRoLxjS541MhLgEvtcwnUzvGjI=;
 b=QsolDJ6uAA0D3yyAXVUDluLS36GUU2KNIRkWNVk1yXHMAhjxXGJBLUCoWJ3A2HbY3v4LsjR5xoug/wpi5/E2hvhvkIjsxmbZscOqJI4YLnP2OCA1pv8rcjREXs3hyLI2Vy7Uk5ua6jbVASt/v0xY41numhUzZIrf4uXhV9d8+v5SUyqpBytF4z21xLKQSAKHL2qK370sFs1sdeClSmYn3xXQ6geotRC1vMBVd9zAS4yv9Qz72vCgZ7AwwxtbNp9tsnVh4vR3fqYmrfXwT+1vBHi5nwylRnEfUe7IVlE9zk+gbqNiMJw7ZPHvH3MhAN+9ATVpnQ+cZp/1YosB4TGa2g==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by SA2PR02MB7724.namprd02.prod.outlook.com (2603:10b6:806:136::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.8; Thu, 20 Aug
 2026 06:35:58 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%5]) with mapi id 15.21.0339.008; Thu, 20 Aug 2026
 06:35:58 +0000
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
Subject: Re: [RFC PATCH v7 04/18] arm/cpu: Add infra to handle generated ID
 register definitions
Thread-Topic: [RFC PATCH v7 04/18] arm/cpu: Add infra to handle generated ID
 register definitions
Thread-Index: AQHdMG4oIO+eacH7wEekjZUskfN9AQ==
Date: Thu, 20 Aug 2026 06:35:58 +0000
Message-ID: <557850AC-880C-4A6D-AA7A-7A0F38B3C9CD@nutanix.com>
References: <20260726153221.24773-1-eric.auger@redhat.com>
 <20260726153221.24773-5-eric.auger@redhat.com>
In-Reply-To: <20260726153221.24773-5-eric.auger@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA2PR02MB7564:EE_|SA2PR02MB7724:EE_
x-ms-office365-filtering-correlation-id: 82533a8e-060c-4395-e5f8-08defe854b82
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|7416014|366016|376014|23010399003|22082099003|18002099003|56012099006|38070700021|6133799003|4143699003|10067099003;
x-microsoft-antispam-message-info:
 C4XcVHhezb2s2fjFs5O7+cf1zcFDKQ3KLMOU2sk7TVHHJ9nzTJjnVWKq0USK026rxvkIxcWn6XIkRM1S6vFYzEJr9zzbZGYtqG/2JXX3RVAdCM2ZhGyQ/cVFSmMjn8sTNGiInj6LXqkTfLSLdeY+l5FUS7biOqUIJLbXTYYfzin+/TVmgy6LmbEaG460imQ2IA8ikP53g3zYFHaGl8AxvO5N21H6/5TXAXXFKv+VtxpdSG6c2IlIn8ImYIc33h9NlIuzvKv89BjD6neOmlyw8JPgyA79IC17tSpl4UNODRzzDlIZwiTsrDPYDxYLV/Q59hEmck3FQdKZOaGkPIMgTB/I5DT98akNLJBJfs5rBeTcO3zlUVwsowV0yOMhBFdtgRuF6Hou6oxINhGYfK8BubT3z7H3aZcNcbZwmGWI0loBRdVUdLZWTL6D8xAnPCoRHjXQ1OtqZHUE642F88Wk7QKQ4m7sPPNWbOLsP/XN5HWEZHHPbin1FPDQaKojq777eNe9fVmwYYkUuB71ldBYQh3V8NCiGCbmyGgAOcuSBDbY63czIFKcAJTBqkZVxWKBWXbXD2lptCrW3tEgaCk/dwSPhkzVf+w5Q827/TCEnAUSwoooUnYQaNrpjiqVbQvRBGcTVcV43wBBgSw3Y2DjtuIIbB4Exj9zGZXuH6eKQzNShIc9/BwdsytQJCXbdBQv/shfnwldDfEjuDAXwsviMV9fkvoNgdU4xdJ1d4qeb1I=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014)(23010399003)(22082099003)(18002099003)(56012099006)(38070700021)(6133799003)(4143699003)(10067099003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?ZUY2Y1RGTG1wVU5WdXZjYlV2d1NoNmZZVXNidnlFVjNGN28yeURPWjRabGNM?=
 =?utf-8?B?K2NZK0hiRHBBN21PV1RmTE4wMXVOYkROYitubWRiZFJoSnJobVdrcU9lU2lP?=
 =?utf-8?B?SWRKUE0vYkRuaWFSTjJLaUY3WE1rbEVoblV3QXl6T2RBUmtsMHF2enF5NENK?=
 =?utf-8?B?REg1cWNheFllSE53ei9VYUxIYUJWNVU3cEc4aStvazhrSnNzNFo3MkQwdkhE?=
 =?utf-8?B?MndhNjQ4RlhnelJQalNCeG9mVDRXcUhhZVBHNmdOZmZwSzd5azQ1ZWlDek5w?=
 =?utf-8?B?K2ZVQ2toRlNsdWNkelJERTRrOTFqYXQ0S3R0TlQzMUNsREoxb0ZtVjVpbWdo?=
 =?utf-8?B?aEZLd3F1ci81cVFxRXBDaUpkVjM0RDRsaDJFR2tVOEl3RlNQSnJ6cjl4Y3JG?=
 =?utf-8?B?SytMcGZTWGswUzBDVWQyNm9wVnl1VFFHMnlLb2Vtb2N0OEVtRUlHV1JPWTFK?=
 =?utf-8?B?NUhPcHd4bXRQWXBMMnNpZW0vTkdNOUx3R3hqZ0NEZmVmMGw2Y1NMejRuQUJt?=
 =?utf-8?B?ejZ3dG1odDNZM3RPVjF6Ym83U3VnVU81WmpWR2k4MjZWci91Q2E4UC9hRWRO?=
 =?utf-8?B?SE55K25tWVZOZXdUalF6MmxZNGhuQVl3OEtwMDdBczFZZWM5eG1sSmFwMi8z?=
 =?utf-8?B?ZHdWQkdFVXdIZStndDI0RXI3ZjhpbDNvclBSRElWVXZCTHNQMTdkL3grNWh0?=
 =?utf-8?B?ZGM5OGZkeHJjQmlnSmtCSVlMUnp5WENyVWt4ajFKVUR0MUFpQ0Y1VmNGK29s?=
 =?utf-8?B?bjRqcEtiODk4Ky9YOHBsdW8yU0lUZ3dCOWpSejlKVnZHNjZEY0VlcWRvTklx?=
 =?utf-8?B?Y1ZFNi90YnRHOEFXVGN5NFI1QW9CeCtQdmp4UnlmOFc4cWcxVEQxVWZha2dL?=
 =?utf-8?B?ZTM1ZldIT3Q5bVZHMUVaUVJiR0tUQ3lGT0haSW1zMDA1eUJtM0ltaDhGcnJs?=
 =?utf-8?B?RnFtTkxRTm9mbnUwUGdYZzhsZldjR3NUTG94UUdDa1hOZ3l1VHNvU0pQUTl6?=
 =?utf-8?B?T1FkRjBhdlZjQUtaeHNVMHZpM3hmNVFLZFJuakpCN1JrQmE4S2gxV3lHNnVq?=
 =?utf-8?B?bkYzMmR1ViswYXhpYmpha3RDaWx0NlgzZDFvZG5IbmQ0WVdNa3gyUCtzNEVF?=
 =?utf-8?B?Ukkwb1VETi9KdktPMFA2V2VIL0REN1F3aTYyNXNySXFIK2JGUmFLQ3FJS3B2?=
 =?utf-8?B?WExwSG0xZkp2RVpWMFlNUm9KR1lUNHF2OElHNnZkL1hQTnA1VTRvOGltVmhx?=
 =?utf-8?B?a0orTWpLNTJSNEpJUUpyMXNZNHRyK0ZUa3E5TnhEZ1FHeGx0R295K1IyaXlB?=
 =?utf-8?B?VFVaWlI1aG1sbmg4QmZuWG1nTXBSaUphVDJXZDN6NjBEeVZBaWdDYnEzSGxz?=
 =?utf-8?B?cUc2U1NmeWpiKy92KzQ0T2FMQ2RNa2VheFByNHR5TUtWYlhBMkRqWFpIVE9t?=
 =?utf-8?B?ZXNsRnAyUU5Mb3d6d3pjMk95UkxJbysxTHNDRXk2cGZEY2NaYUNqa0lZWEtM?=
 =?utf-8?B?aml6SDdjRjZES2xTbmRmbEFmQ0ZsSWwrSCtOUlJSbHpFMTgrNUZ2MkJDMkFu?=
 =?utf-8?B?cU5UUCtrVDJhMmNqb2I1dDJ4Q0pHdG96cjRqZXljejZuTWE3eFQrQW9uSjZm?=
 =?utf-8?B?WWprU3Uwd0tpemVoZ2RweDBKRURMK09jNGJoNlQ4bDNETFBlOUdkKzJoUjMw?=
 =?utf-8?B?L1orOEZUNG05bk1vUDNSTlN4a0gvVmZsVTVlQWY2d2dYeDZXRlhrVm5QaTdM?=
 =?utf-8?B?MnJ6dU5EQ29hVkg2OGNpYmV1MDZJT1dibytNWXVCdjkrUFR2MzZwd1RVS0VE?=
 =?utf-8?B?NmlKcUZSMEJaUjdzd2lUYWJHSG1NQnhpTE9MbUpGNEd6TEVEakJVNXc4WlNF?=
 =?utf-8?B?VHpkbEtHMUhMaXpzUlJLSmFVcW9aS0lSU1NEY0ZBcWExUXhTTUY1cVYveHRG?=
 =?utf-8?B?ZTU3R2lHSkdrRG1sSkVKSGNTUys1c0kyOTg5bEI5aitna0I3WjFzS0RqdXB1?=
 =?utf-8?B?Y3FsVi8zUUJrTFBDU1EraUx1YUI4dWtZTytXaU12VU4yRlNGQXBLWHNYTWNY?=
 =?utf-8?B?ZWszWWNnak9CTGs5UzJJdkRjUUhnQkxqVmU5cEtSaU1XV25NRDMyTDZnVW9I?=
 =?utf-8?B?K1YrbDhiTThtSVZPRXNKVDloOGt2Q1F3cnBGb1AvTFkyaTdJUFo2SGlvUGVJ?=
 =?utf-8?B?Z01rMmRPYklNVnNsYXBrL242UE5IZEt4T3U3UjNndGIvOHBYb0NOVlFBcDd2?=
 =?utf-8?B?YXRCaDRFRk5ZQTJUeEsveS9MVXNEOXR1b01RZ0grSmNoOHM0VGw3OWJCdTVP?=
 =?utf-8?B?Nkk2UmYzMi9lZThMcThrSFVMRGtTME5tZzR0aEdBUmVqbUNYdk1SWmsyV3pJ?=
 =?utf-8?Q?BrDh23d6xSHwRD8Q=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F2D16358C36DAE49A845DF79AFF24A4A@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	F2zqANmgb6CVwt4KgB9Qpv0WrmFe/oqoxKy5Jk7AQt6YbFdAW5/Ce7BPY0dhrj9TKe+jJtZ/4wNvRlhUwPI8Jm2VsACD6byZoJwo6tIVPgb/l7My+gLUbfinB+rLCy4Mt8OQq9SmdzYb7OF/gYcX6/8kS25yWlYTZY9VR+E63X9clMF0TGLhQ1c+pBZOFzjCbdPKY9dGwuLfztea21LwVIyDIM7FTM2tx1u8ZMvIuvmaeJzbaUnZGUXuosKKCu01E2LLGfab/uk8kARsNWX7Njy6gyEtd3l4hgTzJMv0/LbwssfVyU73aTxd3HXmYhVGdTEos3ABS2r1gm71ZQZ2Hg==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82533a8e-060c-4395-e5f8-08defe854b82
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Aug 2026 06:35:58.3557
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AD/BMMNwiIE2k8XF28LXRDXC7+pTadXdL7KWRFB4vJRjFzyRmFoeHr/Z3V2gu3oEWuzBiShLsOxDJb9gYzyr4pDR7LPDdSnqTzxbTmlq5Mk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR02MB7724
X-Proofpoint-ORIG-GUID: VOcjLR_cTbo7L_Lca_LAPUUi6c4isp3m
X-Proofpoint-Spam-Info: AW1haW4tMjYwODIwMDA0NiBTYWx0ZWRfX3I7zyM9YKvko
 2DkrSaZsiuEUIF4I3iWfPPGpFBOpt+UPiGanNi0ke0gpJCOla92QtPpj0o2Lyxm7YecPsL1KJQQ
 SJLke88I6hWdIWvoW74uaMUvqtBN1Bc=
X-Proofpoint-GUID: VOcjLR_cTbo7L_Lca_LAPUUi6c4isp3m
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODIwMDA0NiBTYWx0ZWRfX8gVmZJHKa2VE
 wRIE/OtwE6Ei7fCvFP/Na2QRCQBdFVvvm1H4EDkhRLQAqqGlhDGzQWsRoJkWZI/yYSpK/Ifdu6T
 8A/P/sCnu+tIjmG9CAgMp4isNznTDRMG59QIDndO4BuODaUdtZlSeG8UlY1+GJPKElMP4EhC3mV
 lHyJ23584+LMnP2JsiN/CnJn+QQiKl4E23cO++cpN5uz8oPWN1KVG9KozpQgIMilW+Owfy2XFVY
 v8NIXHo1HNEoqY+zyzfEn+iioBuFWOye+5N24pNZQU223jxqVY8w6JhHEBRQO0vRH6txMyp6o7e
 TU7TdTwHO7OC7W6Unfo+j/bzUiHhRbQe2rz3NUPHnmnANsJHw8O3uYbGdkrG1gV6c/vH2rYVcfi
 p3421M0ul6nhFWlVJB8Hksvxb8clkrcOieBrjoZlWlm5dO93L8EoZVE519sqMgseldk8jqNatKb
 +eq3KvaetCRzuAAw2+A==
X-Authority-Analysis: v=2.4 cv=JpDBas4C c=1 sm=1 tr=0 ts=6a86a050 cx=c_pps
 a=qcfn1AlnsIIAWGxC+ugzFg==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Sv0fKeRqtYgA:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VofLwUrZ8Iiv6rRUPXIb:22 a=0LlEyIVc8U2lsR7dKhuH:22 a=20KFwNOVAAAA:8
 a=64Cc0HZtAAAA:8 a=MlsSqEnWTJP3iF34jW0A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-19_06,2026-08-19_02,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gMjYgSnVsIDIwMjYsIGF0IDg6NTnigK9QTSwgRXJpYyBBdWdlciA8ZXJpYy5hdWdl
ckByZWRoYXQuY29tPiB3cm90ZToNCj4gDQo+ICEtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tfA0KPiAgQ0FVVElPTjogRXh0
ZXJuYWwgRW1haWwNCj4gDQo+IHwtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tIQ0KPiANCj4gSW50cm9kdWNlIGFuIGluZnJh
c3RydWN0dXJlIHRvIHN0b3JlIHRoZSBkZWZpbml0aW9uIG9mIGFsbCBJRCByZWdzOg0KPiBUaGlz
IGluY2x1ZGUgdGhlaXIgbmFtZSwgaW5kZXggYW5kIGFycmF5IG9mIG5hbWVkIGZpZWxkcy4NCj4g
DQo+IFNpZ25lZC1vZmYtYnk6IEVyaWMgQXVnZXIgPGVyaWMuYXVnZXJAcmVkaGF0LmNvbT4NCj4g
U2lnbmVkLW9mZi1ieTogQ29ybmVsaWEgSHVjayA8Y29odWNrQHJlZGhhdC5jb20+DQo+IENvLWF1
dGhvcmVkLWJ5OiBLaHVzaGl0IFNoYWggPGtodXNoaXQuc2hhaEBudXRhbml4LmNvbT4NCj4gDQo+
IC0tLQ0KPiANCj4gdjUgLT4gdjY6DQo+IC0gYWRkIEFybUlkUmVnQXJjaFZhbA0KPiAtLS0NCj4g
dGFyZ2V0L2FybS9jcHUtaWRyZWdzLmggfCA0MSArKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKw0KPiAxIGZpbGUgY2hhbmdlZCwgNDEgaW5zZXJ0aW9ucygrKQ0KPiBjcmVh
dGUgbW9kZSAxMDA2NDQgdGFyZ2V0L2FybS9jcHUtaWRyZWdzLmgNCj4gDQo+IGRpZmYgLS1naXQg
YS90YXJnZXQvYXJtL2NwdS1pZHJlZ3MuaCBiL3RhcmdldC9hcm0vY3B1LWlkcmVncy5oDQo+IG5l
dyBmaWxlIG1vZGUgMTAwNjQ0DQo+IGluZGV4IDAwMDAwMDAwMDAuLjI0NWYxYzgxMDMNCj4gLS0t
IC9kZXYvbnVsbA0KPiArKysgYi90YXJnZXQvYXJtL2NwdS1pZHJlZ3MuaA0KPiBAQCAtMCwwICsx
LDQxIEBADQo+ICsvKg0KPiArICogaGFuZGxlIElEIHJlZ2lzdGVycyBhbmQgdGhlaXIgZmllbGRz
DQo+ICsgKg0KPiArICogU1BEWC1MaWNlbnNlLUlkZW50aWZpZXI6IEdQTC0yLjAtb3ItbGF0ZXIN
Cj4gKyAqLw0KPiArI2lmbmRlZiBUQVJHRVRfQVJNX0NQVV9JRFJFR1NfSA0KPiArI2RlZmluZSBU
QVJHRVRfQVJNX0NQVV9JRFJFR1NfSA0KPiArDQo+ICsjaW5jbHVkZSAicWVtdS9vc2RlcC5oIg0K
PiArI2luY2x1ZGUgInFlbXUvZXJyb3ItcmVwb3J0LmgiDQo+ICsjaW5jbHVkZSAiY3B1LmgiDQo+
ICsjaW5jbHVkZSAiY3B1LXN5c3JlZ3MuaCINCj4gKw0KPiArdHlwZWRlZiBzdHJ1Y3QgQXJtSWRS
ZWdBcmNoVmFsIHsNCj4gKyAgICB1aW50NjRfdCB2YWx1ZTsNCj4gKyAgICBjb25zdCBjaGFyICpu
YW1lOw0KSSBndWVzcyB0aGUgbmFtZSBpcyBub3QgcmVxdWlyZWQsIHJpZ2h0Pw0KDQo+ICt9IEFy
bUlkUmVnQXJjaFZhbDsNCj4gKw0KPiArdHlwZWRlZiBzdHJ1Y3QgQVJNNjRTeXNSZWdGaWVsZCB7
DQo+ICsgICAgY29uc3QgY2hhciAqbmFtZTsgLyogbmFtZSBvZiB0aGUgZmllbGQsIGZvciBpbnN0
YW5jZSBDVFJfRUwwX0lEQyAqLw0KPiArICAgIEFSTUlEUmVnaXN0ZXJJZHggaW5kZXg7IC8qIHBh
cmVudCByZWdpc3RlciwgZS5nLiBDVFJfRUwwX0lEWCAqLw0KPiArICAgIGludCBzaGlmdDsgLyog
bHNiIG9mIHRoZSBmaWVsZCBpbiB0aGUgcmVnaXN0ZXIgKi8NCj4gKyAgICBpbnQgbGVuZ3RoOyAv
KiBoaWdoZXN0IGJpdCBudW1iZXIgKi8NCj4gKyAgICBBcm1JZFJlZ0FyY2hWYWwgKmFyY2hfdmFs
czsNCj4gKyAgICB1aW50MzJfdCBhcmNoX3ZhbHNfY291bnQ7DQo+ICt9IEFSTTY0U3lzUmVnRmll
bGQ7DQo+ICsNCj4gK3R5cGVkZWYgc3RydWN0IEFSTTY0U3lzUmVnIHsNCj4gKyAgICBjb25zdCBj
aGFyICpuYW1lOyAgIC8qIG5hbWUgb2YgdGhlIHN5c3JlZywgZm9yIGluc3RhbmNlIENUUl9FTDAg
Ki8NCj4gKyAgICBBUk1JRFJlZ2lzdGVySWR4IGluZGV4OyAvKiByZWdpc3RlciBpbmRleCwgZS5n
LiBDVFJfRUwwX0lEWCAqLw0KPiArICAgIHN0cnVjdCBBUk02NFN5c1JlZ0ZpZWxkICpmaWVsZHM7
DQo+ICsgICAgdWludDMyX3QgZmllbGRzX2NvdW50Ow0KPiArICAgIHVpbnQ2NF90IHdyaXRhYmxl
X21hc2s7DQo+ICt9IEFSTTY0U3lzUmVnOw0KPiArDQo+ICsvKg0KPiArICogTGlzdCBvZiBleHBv
c2VkIElEIHJlZ3MgKGF1dG9tYXRpY2FsbHkgcG9wdWxhdGVkIGZyb20gQUFSQ0hNUlMgUmVnaXN0
ZXJzLmpzb24pDQo+ICsgKi8NCj4gK2V4dGVybiBBUk02NFN5c1JlZyBhcm02NF9pZF9yZWdzW05V
TV9JRF9JRFhdOw0KPiArDQo+ICsjZW5kaWYNCj4gLS0gDQo+IDIuNTMuMA0KPiANCg0K
