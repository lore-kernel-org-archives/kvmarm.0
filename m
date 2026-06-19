Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CEAB2ECD3A
	for <kvmarm@lists.linux.dev>; Fri, 19 Jun 2026 11:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781870077; cv=fail; b=SfMSUiphy1p6jaiBajh9tToeJ+6NvAiTAnW8kBZ+j9gRQsx9rNw6pGb08mQPCqTHKnkKJ8jF/JJGtvlvgA1U2q8StoL90YggqVi5fWATiYkE/sCLB9zOysTCW/LyBMak/l+GJswnyjrXWuvvtESVUP3rwUWCuADBCZTPG7VAgTM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781870077; c=relaxed/simple;
	bh=SMwh5HowOtiDsegNcY7gDGtGsxCpvGHPb9vOgN+BJXk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Jt19ziaPqJgUKEJFgvdnhzJg6Q4hnKltcjbSHUEGHqpqA3dUUl0xzjMozFNtW4jykhndKQVBuZNoEeMy2qlxbdbeDSCI7b5+G+VM2qnDgj3acCN3DDKxGBTpz44Da+bMd4de7eQywGmsgMwuJHVezRwCq1pUaEZ8Lg2duVr0CS4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=hK86+Jeh; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=yjZ15RPr; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="hK86+Jeh";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="yjZ15RPr"
Received: from pps.filterd (m0127842.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65J7QpX03840544;
	Fri, 19 Jun 2026 04:54:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=SMwh5HowOtiDsegNcY7gDGtGsxCpvGHPb9vOgN+BJ
	Xk=; b=hK86+JehjSYT7WPqJTTOghvnV7qi4BlrO9FHSoY1lXB9E0UHThxV9p1OR
	YZ69MPHt3QEbUgpapPYNlAuDDHFoJwYuiog480zpJ4K2xHf9zk4Veo1YNyoZqdPz
	LdWHpgYnhCxxxsNOn/OyYYehQuk7YBSPO6qZoIzj+z6KJRna+TJ/KDCWgpZA7ycM
	T6bY4wL/czqO/Uc9y8MfC00zql19VogkhYTzX68SdYeoEoD+PfrBviODKTCv2RNo
	GigM0eNa9MIyjO7NdbP6JnEjMMxpsdDoG1tRkR95XxjH4ViYObNBebYFHD8uDSQh
	E9Y7CgUQvqLBeWSm4njDU/STSFy1A==
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11022125.outbound.protection.outlook.com [52.101.48.125])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4eueg20113-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 19 Jun 2026 04:54:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RUL8GnxkdVPg1/4my7Fly0SADfDKOvjLEbXILCB4KSX4yLmI2QuIPbQZ1+fM08JgFYMibWGGtw+Wu3aZLtREPyHG6ZeJDZqOulGWO5L3n/Lzi1E1CanqCIrPfRrJnOmwHAmalFnC+JERYRpwI4J0QTrAEVLM0wPQPETDIjjrrsaT/Y0PMrj6eX+jPOg7244YgxSDmHCBmRZ0WURKckUidE59bZoHH5oKnGGcEC2pL3VB+SIrfOkKIW70XqrzfZjWQV7tX73GFG5NyoE9PKcad6OJ15avxw6vZlrsTHRzz5vDZspgJUeDnJlKM6E0ZjGZ20h8XsKs/SOpEKVxCQsuCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SMwh5HowOtiDsegNcY7gDGtGsxCpvGHPb9vOgN+BJXk=;
 b=IO/QjpT/maLPH7A5QJ22HT6aJ/PeJV9oHTdSUFe3yfu7tD6UrkXs/E3z2nUKCkFDNBuLVacHlFFIL/TAOnQyAQcMTWunJL6cl1q2XvKLVzRzsMyjXh+ejV9GAkIIf5UFoU46wdBtlL6jbR5jOTqOk/Dlk/QxWtSoQAwhKDrPcndxEvW8JIvp8k6xYysPanHi4SA1CMudVpb77N4eAakfLUVxlgFfomgnqQsWvWX4/lhViBm8SZO/PvxbgqVz3jdKxd+b3ryO3GefYh4haUwyCZvY5i1VBci6c0BFnmq2vVTWsim4NAQsFP8UFJIQUVDvpvZ2KUZ3V1dgBoF9vtpPug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SMwh5HowOtiDsegNcY7gDGtGsxCpvGHPb9vOgN+BJXk=;
 b=yjZ15RPr7oHeDDmjD32K2Ew6PWlqoZ1/4gejI7VzQWNUGg1dQkwBhr2gQChItvZf2Q7Dc1gf0R46VSh+097LrFaZX91PHQuKJSM2IOGXQyeBkbA4yn6i8fYKyeSa7w2YK68oVXb9dS2pB35nPPumPIgrOUfXzMLa0hvsCFj74LFuQtPGrtP5W6KDhRLsosG12FKjzaeNn/E8emp5nxQhRA30Yhx9wNp1yCGkv7NOcVhxwOzjLPCoDCx/m3uoPQroa0H0imOS8I+/HxkRWulYE+2GAWZgsfb6t7Vxe6AX2wsubynVYWoorPK3WMN5lU3oOSkmeeW/UOAUMVb4BG8+vw==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by BY5PR02MB6533.namprd02.prod.outlook.com (2603:10b6:a03:1d5::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.139.11; Fri, 19 Jun
 2026 11:54:19 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%5]) with mapi id 15.21.0139.009; Fri, 19 Jun 2026
 11:54:19 +0000
From: Khushit Shah <khushit.shah@nutanix.com>
To: Markus Armbruster <armbru@redhat.com>
CC: "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "qemu-arm@nongnu.org"
	<qemu-arm@nongnu.org>,
        "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
        Eric Auger <eric.auger@redhat.com>, Cornelia Huck <cohuck@redhat.com>,
        Peter
 Maydell <peter.maydell@linaro.org>,
        Richard Henderson
	<richard.henderson@linaro.org>,
        Marc Zyngier <maz@kernel.org>, Oliver Upton
	<oliver.upton@linux.dev>,
        =?utf-8?B?RGFuaWVsIFAgLiBCZXJyYW5nw6k=?=
	<berrange@redhat.com>,
        Andrea Bolognani <abologna@redhat.com>,
        Jiri Denemark
	<jdenemar@redhat.com>, Gavin Shan <gshan@redhat.com>,
        Shameer Kolothum
	<skolothumtho@nvidia.com>,
        Sebastian Ott <sebott@redhat.com>,
        =?utf-8?B?UGhpbGlwcGUgTWF0aGlldS1EYXVkw6k=?= <philmd@linaro.org>,
        Jinqian
 Yang <yangjinqian1@huawei.com>,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Mark Cave-Ayland <mark.caveayland@nutanix.com>,
        Sandesh Patel
	<sandesh.patel@nutanix.com>
Subject: Re: [RFC PATCH v2 23/29] target/arm/qmp: add query-arm-cpu-props-info
Thread-Topic: [RFC PATCH v2 23/29] target/arm/qmp: add
 query-arm-cpu-props-info
Thread-Index: AQHc9Mdan99yrqTo5UaDF54gmxsAAbZFsa0TgAApboA=
Date: Fri, 19 Jun 2026 11:54:19 +0000
Message-ID: <17B524D0-6D08-4ECF-93FC-E38EB0F8F6D7@nutanix.com>
References: <20260605083358.1320563-1-khushit.shah@nutanix.com>
 <20260605083358.1320563-24-khushit.shah@nutanix.com>
 <87o6h6hofm.fsf@pond.sub.org>
In-Reply-To: <87o6h6hofm.fsf@pond.sub.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA2PR02MB7564:EE_|BY5PR02MB6533:EE_
x-ms-office365-filtering-correlation-id: c1474c32-cd52-4532-dcf4-08decdf97edb
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|23010399003|7416014|376014|38070700021|3023799007|4143699003|18002099003|22082099003|56012099006|6133799003;
x-microsoft-antispam-message-info:
 hme8nIdcty2nKmQInx4fJWhTAfpF8Ev6aBfgpKAQe3nCXKOBQZGNSCv8vNUwgKAaaVS4DztuKPNxhEWKRwgTz3dDQ3Qh1FY9wntpRNKHw/3CBHZ85Ltc1jXnXHzc3whV3VpDOvpJreVVpwpcT110N+wMoFk+HxHjyS2iCe8/PlthNrF9CoCtE34T6K8gR/z0Ha9FfkBcTjBU6IUf9IZ/l7PXynwUg0tLSXghHKQFeWx90MwdxjF01geZHoPrkgh3MVjpPJ61XVM3JWtL6n1pkfFp7ePotdL+bZQByzF5U5X+lJOoxGSoDt+hsF/b0L399dyHF8wybNho2dC6Vs2S+mSWofg5Z6YAH2h5t01PzCuTb6al4iRivrgRbCcAZRxqgHUrqpm1WoVN56xheaiCeLXUcaPtZ/vDcyFOZbceE8W1AWJ26HR/MjDVyUnHeqd1ZiHNKqQxz8caxZKlt9XrJ5ZmRnqZ7oi//xfxrr2L/nD0kGI8kJmWZw+SWJNevbAT2/WpBNEnaviZ1RPuwbY5t+bF2LLUHaej/ttLI+CDhNn0/WsjAaxPg7BReVh76oFtT5HJYbw4jgydSD6yu8l9bZPwK8ZXvMFMvHfaEfcr6gFQdtrkdLpYVEmzpA6vzLAf5HxhawtTLx/BWtfXKEd2bNHV01H7NVlURdG55N191muovzbTUYCYS14zC/yR3ni9d0kNIttjJtjY99uQHqGNpGZPhCOdcvF3CyAl41NXujI=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(7416014)(376014)(38070700021)(3023799007)(4143699003)(18002099003)(22082099003)(56012099006)(6133799003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?TERJQlJOWElaeHNCMkRhWmJ1d2JqeGsvWGxEVU00NlhZSkk5N0twdGNSaU9U?=
 =?utf-8?B?MldlNE9aYzB6WVd3TVRrNHgySUtGbSt3cGFzNnhPTE01YlNYS250ZHZTYnh4?=
 =?utf-8?B?REh1YlVtY0g0RWpHVmt4V09GV1JXb0lEUEJDMVh0eFh4ZlZDWHd2c2dENHk1?=
 =?utf-8?B?QUZTMktsS3JpYzhDVnpGcXEyVUs0Tk5vQ2FBN1BVOFpnUkFiYzZMY21YSzMr?=
 =?utf-8?B?TW51NXpFc2djYzhNd0JuSUlOUUNwVktyMFQvamlVVjYwSjhBRTZMYS9tRFI5?=
 =?utf-8?B?SDlYeGJQMENLWHIrelc0ZHdDajVWSDViVTZiSUxTeWRPMFpUVFlmT1pTYVhz?=
 =?utf-8?B?anZaMFplTU1Fb1Y2dnVTQW4yK1dmZlZLQ3NjN0xmUE1mMTdMOFN1RTg1b3pZ?=
 =?utf-8?B?THB6VEExczk3MlNVeTl2c3FPRlBlTkJlSmxHS3FvMTYvQW9NUU1ndnZYd3di?=
 =?utf-8?B?S3M2VzdpM2ZOeWtqT1ZEU25jUG9FNGNFWEJKZ3VCeTZwZWx5T1c2Z1Ywa1Ux?=
 =?utf-8?B?ZjJyMnA1Vm9TNDlleXZhOXhyVTcvbXNJbENiTEZsMHZwS2RuNnNPK1lkVUdx?=
 =?utf-8?B?QUFucDJ2MEdpV3dSUERXVXFrT05nWDgya3I5eGlIczgzdmg0MWhYbU5MS3Jq?=
 =?utf-8?B?cEgrVTJ5UXluanRQdXArb1MvS1RmWldiNWhGclhXeHkreEgzelVvQTIrck5z?=
 =?utf-8?B?eGNkUHJIWDlrU3IvOHNaRHpzOFhqY1pxR1g2V25qczgrcFZPUC9BdExwNGwz?=
 =?utf-8?B?RXZSQ3A0ZVlVdk94V3BpOEtsekpkdWFvNTVaQUFaNjFEMGtjQnhjUU1HR1RQ?=
 =?utf-8?B?MDFGc1FaMTdJd2VPWFV3aXRabXlPS1ZOOUYyR3NkTmtxMFZWNFhGbUFBNk5O?=
 =?utf-8?B?RFAvVFZHREdUNjRyYzE3MzVEWWVRRlpweFV4RGF1WUg5N3QrTVFRekNUVjlS?=
 =?utf-8?B?SkVHdnlJT1N3RXptNTVRKzdjNnBvdDZSLzVxUDI0VkUvNW1lNTlyaGFHbExB?=
 =?utf-8?B?a0liWnpUMXJMVHJwRjJwUWZOQkM2S1NNNTNWUzB0REF0R2tjWXdQYThDWGhl?=
 =?utf-8?B?cXd4aFVrUmkySzlQVUFyTmVPTVZZS0J1QVNnTVZJaVRmUnJSYkYybVB5RHdJ?=
 =?utf-8?B?R3huN21CM0hPR3FPUGVUcXIwSkltLzJrVi9MeWNObk43aXdBU1IvT2U3VDN1?=
 =?utf-8?B?NHVKcmx6ZEh2SmdtSFI0M0FrOGMxc1ArVXJCKy9WK0lpZWExYUdCOExCL205?=
 =?utf-8?B?OGpnSDFHd2p2U1pyVVI0OGUyQUpyaUNwL0VDSXFHRDQ0SVZHdUkySjRLclVr?=
 =?utf-8?B?QlJPZU5vVFBNeTRhcWc4aUgyNEZWQXEwbjc5Y0xHZFpqM3Mrc09PYUZPVkta?=
 =?utf-8?B?azZxRnl0WDFwZW11NWRDUkdOMFhWTUVIbDFVZVRUY1cwV0tQdUIyZWc5bHhs?=
 =?utf-8?B?RGJlcWRLQm9vRkRiWXZ2Rkg3VTRjekx0d3BHREgzM1NHQ2hmVTlyeUZMOUNC?=
 =?utf-8?B?Z0FkYnU3dWs4R3lvSmxlQkdHdWpIdTZWVW14eC95MWNxdHB1RlJ3eGx5Skc1?=
 =?utf-8?B?U2l2a21PZDY2Q0IrVStPdGpGWWE0emVpOEE1ajU4QXc4MXhTU3YwZi8rRzRE?=
 =?utf-8?B?ZE9YaE5aQTJGKzVXN2xBY2JGNXhjSXd4ZHlsYXlBR0s3b1RFQWZqSXVoYU1R?=
 =?utf-8?B?VUJUZVRkaEozMlFXK3MzQTdERVE0TmRSUDZqaW04eXB1OU1GcmFTbkZjMWdx?=
 =?utf-8?B?WVZWcFBZNnRSampUbDBydDlOUHNmNWEyNlRaZnd3OHVzMENUV2hjY3pza2JG?=
 =?utf-8?B?THBzcERieW5URk9kaDVlL0cra0hUNTlPc3dRUDduNExyTzQrWXZMeUcvUURo?=
 =?utf-8?B?U01UQnJuR3VXc0tWTzRZZkhldFNQZnRldFd1b0ZHWGN6enF6L084Uk5oUHR0?=
 =?utf-8?B?NG5uaURxRXlheWV1REVzWHpURHh2bjFjRVY3R2tRckdlYStVY2ZkK3BWVWp6?=
 =?utf-8?B?blFaTU9JUTVIS1U2ckhQelh5UHR5OTRscSsyZlU0cmNabVNCZHNKM0lzc1VL?=
 =?utf-8?B?MWYzWjR6bll1UTNRcWVkRmovNWlsZ0ZIZ0NxbStBaTBZbnlhTnNBOHgzYVFn?=
 =?utf-8?B?YUl6b2hzbW0va0tqVXJ3bXVNWGVDOXpyV016dUZGeUhhQmg0NTJaU1dKbENJ?=
 =?utf-8?B?S0hIdW9obEJrc2JxMFdsNERvYTB4NlcyWnpKTTFPbjI0ZjRSb2l6aFhiZ2di?=
 =?utf-8?B?UlczQTRTRkZtcjNqQ3owcmpzSDBSNENEQ2Y1UmM2Z2Zqb0UycmpwY3c3eXJn?=
 =?utf-8?B?eFNuR0o1cWxCYStCK1JidjlEcnBrZW91S1B3MWFORE50SmxYdnY0bCtiMGVr?=
 =?utf-8?Q?QqFkCcEPQLjngI0c=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D84AFC8669C0EF48AA8B8B9F31CE8C93@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	SehwBrFXZuoBEzWHVAs9GLqw/e9GTeINwgpbIrLIj61Qwzq47a48ONXfkMJ6zdQ+n+SV2NWtofg6MNYg7Y1hcLRUv8Q91u5sHEqeUXGHnEymIyT93tG2mUtGOXJXSh4Gp4XIcYjQbnAFoztNvTaNtFRpycBaW5NO6oaiKa3n8iXsBjYrOjlpPkTqu+cZEQd4n1E8bZmlu1wFu6qTpKx77W24e+LvKOluodwgZjfz4cgrTPcJpyJd1MA1unJGRQp94KvMAzTxKCbupGdeC5be5sLwNPb7va65Xh/AVKgMFl5ZcJiYPSptX+vw9nU1dK+jdISpRz7I5N3KPmwZVhi9Gg==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1474c32-cd52-4532-dcf4-08decdf97edb
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jun 2026 11:54:19.1673
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: O6SxHnAhdleAQOTV/DQVFLcAYrV1dIw2BKrYM/xB+XnEcSE1x+5alqfXBYn3W8VioBxguodQnKlB9vVVCB/5VBY9ixMVkRolAmngUoXHbFY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR02MB6533
X-Proofpoint-GUID: MjVeonf4stR8xNlgQOZSp9L9FFTKfLhC
X-Proofpoint-ORIG-GUID: MjVeonf4stR8xNlgQOZSp9L9FFTKfLhC
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE5MDExMSBTYWx0ZWRfXxl0x0uoShAUr
 AtVWU6TC9eEdI1dImaBpNfepCMZYje3jEgcF5/IipmLA/kJpMNUKIk+TWEeIE3cCOv87aqqLcll
 0QQaM0bc+J9W/HCar2LmdmRPZApWZTxALhizQkEGeDxr4iB15aETgJzHL2LZRIN/C201K28lvjZ
 dKPkhqJpN1cW21Sz03lSXtoKsknmKCVInf/cfgkPIObfMX/juHEnRPGOWF5b6whNteai2YFnY6L
 HaXolCVfW7shG4K1E2UeB4u+TNUU/PY2gmZcIuUnzOv4nN1QY2J+Iloy8lEQYT5KiOt+2S8lD0E
 FRmRVDXQdzJgc0TlpPrXvIew9/F42VmmBo7k1JBU+csQQfwqcgVwfAJY/drZAgDY+spaX/4OsUE
 FXWKGORhjqkniqOr1sRToZWUQdxxCwoznRV1kEjRGf2y2qLKGD8CdUhreZzZbzCKZHYiF7se/Ye
 JD+rxzQpVBYlQoHoMiw==
X-Authority-Analysis: v=2.4 cv=c+Wbhx9l c=1 sm=1 tr=0 ts=6a352dee cx=c_pps
 a=qTO11YbfUBYfkhAk4rXMnw==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=FelO9ux0wxsA:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VofLwUrZ8Iiv6rRUPXIb:22 a=VUi8bpU7OL1Oj2-RSIOF:22 a=20KFwNOVAAAA:8
 a=64Cc0HZtAAAA:8 a=FvGWtwKvNQWAn3xbJl0A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE5MDExMSBTYWx0ZWRfXyHdxh9H3aG9t
 hurliPfRxgnn2rERnmlK/pN/+mJNUXg0W4TGEt/poZJCoglPe/KJ7aLpYuL/Mss/TfkKnENRVQD
 uSmNKnnyYI78l4XUAI1P3Qweo/1l/1c=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-19_02,2026-06-18_03,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gMTkgSnVuIDIwMjYsIGF0IDI6NTXigK9QTSwgTWFya3VzIEFybWJydXN0ZXIgPGFy
bWJydUByZWRoYXQuY29tPiB3cm90ZToNCj4gDQo+ICEtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tfA0KPiAgQ0FVVElPTjog
RXh0ZXJuYWwgRW1haWwNCj4gDQo+IHwtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tIQ0KPiANCj4gS2h1c2hpdCBTaGFoIDxr
aHVzaGl0LnNoYWhAbnV0YW5peC5jb20+IHdyaXRlczoNCj4gDQo+PiBJbnRyb2R1Y2UgJ3F1ZXJ5
LWFybS1jcHUtcHJvcHMtaW5mbycgUU1QIGNvbW1hbmQuIFRoaXMgY29tbWFuZCByZXR1cm5zDQo+
PiBpbmZvcm1hdGlvbiBhYm91dCBBUk0gQ1BVIG1vZGVsIHByb3BlcnRpZXMsIGluY2x1ZGluZyB0
aGVpciBuYW1lLCB0eXBlLA0KPj4gc3VwcG9ydGVkIHZhbHVlcyBvbiB0aGUgZ2l2ZW4gaG9zdCwg
YW5kIGNvbXBvc2l0ZSBwYXJlbnQgaWYgYW55Lg0KPj4gDQo+PiBUaGlzIHByb3ZpZGVzIG1hbmFn
ZW1lbnQgbGF5ZXIgbmVjZXNzYXJ5IGluZm9ybWF0aW9uIHRvIGRldGVybWluZQ0KPj4gbWlncmF0
aW9uIGNvbXBhdGliaWxpdHkgb2ZmIGEgVk0gb24gZGlmZmVyZW50IGhvc3QuDQoNCk5vdGU6IHMv
b2ZmL29mLg0KDQo+PiANCj4+IFNpZ25lZC1vZmYtYnk6IEtodXNoaXQgU2hhaCA8a2h1c2hpdC5z
aGFoQG51dGFuaXguY29tPg0KPj4gLS0tDQo+PiBxYXBpL21pc2MtYXJtLmpzb24gICAgICAgICAg
ICAgIHwgNDEgKysrKysrKysrKysrKysrKw0KPj4gc3R1YnMvcW1wLWFybS1naWMuYyAgICAgICAg
ICAgICB8ICA2ICsrKw0KPj4gdGFyZ2V0L2FybS9hcm0tY3B1LXByb3BzLXN0dWIuYyB8IDEzICsr
KysrDQo+PiB0YXJnZXQvYXJtL2FybS1jcHUtcHJvcHMuYyAgICAgIHwgODUgKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrDQo+PiB0YXJnZXQvYXJtL2FybS1jcHUtcHJvcHMuaCAgICAg
IHwgIDUgKysNCj4+IHRhcmdldC9hcm0vYXJtLXFtcC1jbWRzLmMgICAgICAgfCA0NCArKysrKysr
KysrKysrKysrKw0KPj4gdGFyZ2V0L2FybS9jcHUtaWRyZWdzLmMgICAgICAgICB8IDcxICsrKysr
KysrKysrKysrKysrKysrKysrKysrKw0KPj4gdGFyZ2V0L2FybS9jcHUtaWRyZWdzLmggICAgICAg
ICB8ICA4ICsrKysNCj4+IDggZmlsZXMgY2hhbmdlZCwgMjczIGluc2VydGlvbnMoKykNCj4+IA0K
Pj4gZGlmZiAtLWdpdCBhL3FhcGkvbWlzYy1hcm0uanNvbiBiL3FhcGkvbWlzYy1hcm0uanNvbg0K
Pj4gaW5kZXggNGRjNjZkMDBlNS4uMWEzZmIxNDBjNCAxMDA2NDQNCj4+IC0tLSBhL3FhcGkvbWlz
Yy1hcm0uanNvbg0KPj4gKysrIGIvcWFwaS9taXNjLWFybS5qc29uDQo+PiBAQCAtNDYsNiArNDYs
NDcgQEANCj4+ICMjDQo+PiB7ICdjb21tYW5kJzogJ3F1ZXJ5LWdpYy1jYXBhYmlsaXRpZXMnLCAn
cmV0dXJucyc6IFsnR0lDQ2FwYWJpbGl0eSddIH0NCj4+IA0KPj4gKyMjDQo+PiArIyBAQ3B1UHJv
cEluZm86DQo+IA0KPiBDcHVQcm9wZXJ0eUluZm8gZm9yIGNvbnNpc3RlbmN5IHdpdGggdHlwZSBu
YW1lcyBzdWNoIGFzIE9iamVjdFByb3BlcnR5SW5mby4NCg0KQWNrZWQuIA0KDQo+PiArIw0KPj4g
KyMgSW5mb3JtYXRpb24gYWJvdXQgYSBzcGVjaWZpYyBBUk0gQ1BVIG1vZGVsIHByb3BlcnR5Lg0K
Pj4gKyMNCj4+ICsjIEBuYW1lOiB0aGUgbmFtZSBvZiB0aGUgcHJvcGVydHkNCj4+ICsjDQo+PiAr
IyBAdHlwZTogdGhlIHR5cGUgb2YgdGhlIHByb3BlcnR5LCBhbnkgb2YgKCdzdHJpbmcnLCAnYm9v
bGVhbicsDQo+PiArIyAgICAgJ251bWJlcicpLg0KPj4gKyMNCj4+ICsjIEBzdXBwb3J0ZWQtdmFs
dWVzOiB0aGUgc2V0IG9mIHZhbHVlcyB0aGUgaG9zdCBoYXJkd2FyZSBzdXBwb3J0cw0KPj4gKyMg
ICAgIGZvciB0aGUgcHJvcGVydHksIGEgbGlzdCBvZiBzdHJpbmdzLg0KPiANCj4gSSBmaWd1cmUg
dGhlIHNldCBvZiB2YWx1ZXMgZGVwZW5kcyBvbiB0aGUgaG9zdCwgaS5lLiBpdCBpc24ndCBrbm93
biBhdA0KPiBjb21waWxlIHRpbWUuICBDb3JyZWN0Pw0KPiANCg0KWWVzLCBjb3JyZWN0Lg0KDQo+
IEFyZSB0aGUgcG9zc2libGUgcHJvcGVydHkgbmFtZXMga25vd24gYXQgY29tcGlsZSB0aW1lPw0K
DQpZZXMsIHByb3BlcnR5IG5hbWVzIGFyZSBrbm93biBhdCBjb21waWxlIHRpbWUuDQoNCj4gTGlz
dCBvZiBzdHJpbmdzIGlzIGZpbmUgd2hlbiB0aGUgdmFsdWVzIGFyZSBzdHJpbmdzLiAgV2hlbiB0
aGV5J3JlIG5vdCwNCj4gdGhlIGludGVyZmFjZSByZXF1aXJlcyBpdHMgdXNlcnMgdG8gcGFyc2Ug
c3RyaW5ncywgd2hpY2ggaXMgc29tZXRoaW5nIHdlDQo+IHRyeSBoYXJkIHRvIGF2b2lkIGluIFFB
UEkvUU1QLg0KDQpPa2F5LCB0aGVuIEkgdGhpbmsgd2UgY2FuIGRvIHRoaXMgd2l0aCBmbGF0IHVu
aW9uIGRpc2NyaW1pbmF0ZWQgd2l0aCANCuKAnHR5cGXigJ0gKGNoYW5naW5nIGl0IHRvIGVudW0p
IDoNCiAgIGJvb2xlYW46IFvigJhib29s4oCZXQ0KICAgc3RyaW5nOiBb4oCZc3Ry4oCZXQ0KICAg
bnVtYmVyOiBbJ051bVJhbmdl4oCZXSB3aGVyZSBOdW1SYW5nZToge+KAmG1pbuKAmTogdWludDY0
LCDigJhtYXjigJk6IHVpbnQ2NH0NCg0KUmFuZ2UgZm9ybSB0byBoYW5kbGUgbnVtZXJpYyBwcm9w
ZXJ0aWVzIHdpdGggbm8gcmVzdHJpY3Rpb25zLg0KDQpEb2VzIHRoaXMgbG9vayByZWFzb25hYmxl
IHRvIHlvdT8NCg0KPj4gKyMNCj4+ICsjIEBjb21wb3NpdGU6IG5hbWUgb2YgdGhlIGVuY2Fwc3Vs
YXRpbmcgY29tcG9zaXRlIHByb3BlcnR5IGlmIGFueS4NCj4+ICsjDQo+PiArIyBTaW5jZTogMTEu
MQ0KPj4gKyMjDQo+PiAreyAnc3RydWN0JzogJ0NwdVByb3BJbmZvJywNCj4+ICsgICdkYXRhJzog
eyAnbmFtZSc6ICdzdHInLA0KPj4gKyAgICAgICAgICAgICd0eXBlJzogJ3N0cicsDQo+PiArICAg
ICAgICAgICAgJ3N1cHBvcnRlZC12YWx1ZXMnOiAnYW55JywNCj4gDQo+IERlc2NyaXB0aW9uIGFi
b3ZlIGNsYWltcyAibGlzdCBvZiBzdHJpbmdzIi4gIElmIHRoYXQncyBhY2N1cmF0ZSwgaXQNCj4g
c2hvdWxkIGJlIFsnc3RyJ10gaGVyZS4gIEVsc2UsIHRoZSBkZXNjcmlwdGlvbiBuZWVkcyBmaXhp
bmcuDQo+IA0KDQpBY2tlZCwgd2lsbCBmaXggYXMgbWVudGlvbmVkIGFib3ZlLg0KDQo+PiArICAg
ICAgICAgICAgJypjb21wb3NpdGUnOiAnc3RyJyB9IH0NCj4+ICsNCj4+ICsjIw0KPj4gKyMgQHF1
ZXJ5LWFybS1jcHUtcHJvcHMtaW5mbzoNCj4+ICsjDQo+PiArIyBSZXR1cm5zIGluZm9ybWF0aW9u
IGFib3V0IG1vc3Qgb2YgQVJNIENQVSBuYW1lZCBtb2RlbCBwcm9wZXJ0aWVzLg0KPiANCj4gSW1w
ZXJhdGl2ZSBtb29kLCBwbGVhc2U6IFJldHVybiBpbmZvcm1hdGlvbiAuLi4NCg0KQWNrZWQsIHdp
bGwgZml4IHRoaXMuDQoNCj4gDQo+PiArIyBUaGlzIGRvZXMgbm90IGluY2x1ZGUgY29tcG9zaXRl
IHByb3BlcnRpZXMgb3IgcHJvcGVydGllcyBhbHJlYWR5DQo+PiArIyBkZWZpbmVkIGJ5IFFFTVUg
bGlrZSAoc3ZlTk5OTiwgcG11LCBldGMpLCBUaGlzIG9ubHkgcmV0dXJucyBhbGwNCj4+ICsjIHRo
ZSBuZXdseSBkZWZpbmVkIHByb3BlcnRpZXMgbGlrZSAoJ2ZlYXRfKicsICdod19wcm9wXyonLCBl
dGMpLg0KPiANCj4gIm5ld2x5IGRlZmluZWQiIGNvbXBhcmVkIHRvIHdoYXQ/DQoNCk9rYXksIEkg
c2VlIHRoZSBpc3N1ZS4gV2lsbCByZXdvcmQgdGhpcy4NCg0KPiANCj4+ICsjDQo+PiArIyBXaXRo
IHRoaXMgdXBwZXIgbWFuYWdlbWVudCBsYXllcnMgY2FuIGZpbmQgb3V0IHdoYXQgcHJvcGVydHkg
dmFsdWVzDQo+IA0KPiBDb21tYSBhZnRlciB0aGlzLCBJIHRoaW5rLg0KDQpBY2tlZC4NCg0KPiAN
Cj4+ICsjIGFyZSBzdXBwb3J0ZWQgb24gdGhlIGdpdmVuIGhvc3QuDQo+PiArIw0KPj4gKyMgUmVx
dWlyZXMgS1ZNIHRvIGJlIGVuYWJsZWQuDQo+IA0KPiBXaGF0IGhhcHBlbnMgd2hlbiBpdCBpc24n
dD8NCg0KUmlnaHQgbm93IGl0IHRocm93cyBhbiBlcnJvci4gV2UgY2Fubm90IGNhbGN1bGF0ZSBz
dXBwb3J0ZWQtdmFsdWVzDQp1bnRpbCB3ZSByZWFkIGhvc3QgdmFsdWVzIHVzaW5nIEtWTS4gV2ls
bCBleHBsaWNpdGx5IG1lbnRpb24gdGhpcw0KaW4gdGhlIGRvYy4NCg0KV2FybSBSZWdhcmRzLA0K
S2h1c2hpdA0KDQo+IA0KPj4gKyMNCj4+ICsjIFNpbmNlOiAxMS4xDQo+PiArIyMNCj4+ICt7ICdj
b21tYW5kJzogJ3F1ZXJ5LWFybS1jcHUtcHJvcHMtaW5mbycsDQo+PiArICAncmV0dXJucyc6IFsn
Q3B1UHJvcEluZm8nXSB9DQo+PiArDQo+PiAjIw0KPj4gIyBAU3NpZFNpemVNb2RlOg0KPj4gIw0K
PiANCj4gWy4uLl0NCg0KDQo=
