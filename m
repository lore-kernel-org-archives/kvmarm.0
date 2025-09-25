Received: from mx0a-0014ca01.pphosted.com (mx0a-0014ca01.pphosted.com [208.84.65.235])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11D98304BC3
	for <kvmarm@lists.linux.dev>; Thu, 25 Sep 2025 15:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=208.84.65.235
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758813053; cv=fail; b=lA7sAUpvdiQYmc7G6RAaRUUVka8kSjHqc9wm5OPBrtl2D5C3rJqXkiwDBce0hGRDrvyMkmi8zT25dTIEk3W64kEEuPJwalaKYsc9UwHStAH8RMgrXDm88mQTU4VqIUG85L6iXtOXaAeKcJdfcH7I3s56m2UzqdCkKtRsk0EzdnA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758813053; c=relaxed/simple;
	bh=Jj7T9QuU0QUEi+TIUBRJ7eEML7sxdXkTqUezMkDO77M=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=L47Si1Mf8Z7ereCTCfSJxhJR/WFSGFxhnKEZ+I5RE7OR2LW5juqB7eCoN7ZsAU806RJYLjOxmMsBI9c0rOk5pNRpSk5psnEWEHxY9NP/dbNXSQT+qrkMCtSgegh1aYR6Us8Lh/W7gNBC777Zg/7zIA6134xwj/R8r/KKU2xVovo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cadence.com; spf=pass smtp.mailfrom=cadence.com; dkim=pass (2048-bit key) header.d=cadence.com header.i=@cadence.com header.b=Adcy1H6u; dkim=pass (1024-bit key) header.d=cadence.com header.i=@cadence.com header.b=cNeyEQsn; arc=fail smtp.client-ip=208.84.65.235
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cadence.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cadence.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cadence.com header.i=@cadence.com header.b="Adcy1H6u";
	dkim=pass (1024-bit key) header.d=cadence.com header.i=@cadence.com header.b="cNeyEQsn"
Received: from pps.filterd (m0042385.ppops.net [127.0.0.1])
	by mx0a-0014ca01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58PAEH4o004872;
	Thu, 25 Sep 2025 08:10:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint; bh=Jj7T9QuU0QUEi+TIUBRJ7eEML7sxdXkTqUezMkDO77M=; b=A
	dcy1H6uwtIytyU4VfCxlo6RGf9gQMzm+E2l31wkYDKawDsdgDM3ahTM4jU3Q/Qde
	nD+Dikfx1BpLfNjttt//rdlooMdA+ahIDFMWgEvRiq6K/cXhwFunT2hDVJctATGj
	qJ9fbq20E/5Iw1KIsMfhFMEwn52AqcFouKK2I5VQGyEIbQ47gPOKt1lKzHzeKVSt
	k1F50qlTMeqH9Vp4su+oghpAfKlpNBFQXwmmt5j1m+SUCLyN8mYJQoIvAoZhDPK4
	gYA4YW6aa/fiv2vw2wsnW8qoRK7YpDir7eRhHoyVpbpzgqNwAl1WCEUBGKmP0iCD
	0zabpv/e+Z6dE164U6F+Q==
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011061.outbound.protection.outlook.com [52.101.62.61])
	by mx0a-0014ca01.pphosted.com (PPS) with ESMTPS id 49brapevdv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 25 Sep 2025 08:10:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Gr9+6ZaF8yb3i9aDDfl2WJe/dQphpc0ctfi2com7PHrp+SB33D8dvJeDJAIa7qLf7+3+elQ6rQfgFGUWxT1lLghWTUc5+Y/Y7tq7fN+9wTNild/KXjnbwFiej7//FE1za4bXX5TKNzsMOl6/uLMPZVJPcj+Vj6wOgBvdjKNBcE+ROCtNIt4AJf9O5XyWhgY31jAbNxcUTL+Eeqo2JQ8OkUj0zb1OndgUFRKIoRI+BuEK7c3GvrKsyS1dDd3BcKtQFmiBdsHdi70nGSLbhCTdy7E6gyPgGY5PZIZ7f3KDU/em/T+O++5l2CZGLu0jFb3yPlvDPfulJorpJMTOHNMAvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Jj7T9QuU0QUEi+TIUBRJ7eEML7sxdXkTqUezMkDO77M=;
 b=jn+X9/DT+y7srhi1ytUV2peO8FdvbqAa5h5/FLepLZw2q/sMed+p31ImG0xlazkg2E48xZjNDOr9TOLDk9jh/rLuLl0JfQb9nYSCqFYRmx7ymgmQH9XAb1EpYzZWTih2XeKLuJY8gGQiijWQ/5ktnCxSr/Xr+Vl+OWNeNo8ogzcCWL9QKc/AZb+BIB3dBaZK189/xK7mIdbkSOH2eG/7MxhZ2nlFrHHtZBeUjpvFvFmbE/j7nX91GEs+TAGhHbw9UkV0T7ApEP7BHEUyrp9vTMUwmJC25X5Q2/0qze8s2bGtpjUE5Jg+egkrNc2169YZPy3YR81BELUtu6lN8S7u9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cadence.com; dmarc=pass action=none header.from=cadence.com;
 dkim=pass header.d=cadence.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jj7T9QuU0QUEi+TIUBRJ7eEML7sxdXkTqUezMkDO77M=;
 b=cNeyEQsnDaMtoaYgT2fykeF9Rtl0ekxwIiR5C9yG9tvNyS4T4BcXg9QmgSxaYvScN/Lcfhli9w+NEL760z2nGyUsi+oaaL5mH7mKjUYdySQvNw2xEGbdub0OzJtE5dJpzGsI+tBwTC6Dq+OtobUMMUGmyJRjR7JM8voGSRNYXfU=
Received: from SN7PR07MB9604.namprd07.prod.outlook.com (2603:10b6:806:2af::13)
 by LV5PR07MB11452.namprd07.prod.outlook.com (2603:10b6:408:2fb::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.11; Thu, 25 Sep
 2025 15:10:22 +0000
Received: from SN7PR07MB9604.namprd07.prod.outlook.com
 ([fe80::3db6:f5eb:b1c3:999a]) by SN7PR07MB9604.namprd07.prod.outlook.com
 ([fe80::3db6:f5eb:b1c3:999a%5]) with mapi id 15.20.9160.008; Thu, 25 Sep 2025
 15:10:22 +0000
From: Jan Kotas <jank@cadence.com>
To: Marc Zyngier <maz@kernel.org>
CC: Jan Kotas <jank@cadence.com>, Oliver Upton <oliver.upton@linux.dev>,
        "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>
Subject: Re: KVM NV + SVE host OS warning
Thread-Topic: KVM NV + SVE host OS warning
Thread-Index: AQHcLiUKR+wB9cgAPkys8N+jKyIMXLSj98IAgAAI7YA=
Date: Thu, 25 Sep 2025 15:10:22 +0000
Message-ID: <F9556C9F-2671-4EF6-A725-D080C3793A34@global.cadence.com>
References: <799DD5E5-8BC2-47B3-A919-33429D3FB2F1@global.cadence.com>
 <865xd61tt5.wl-maz@kernel.org>
In-Reply-To: <865xd61tt5.wl-maz@kernel.org>
Accept-Language: en-US, pl-PL
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3826.700.81)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN7PR07MB9604:EE_|LV5PR07MB11452:EE_
x-ms-office365-filtering-correlation-id: 292d722f-45df-43cd-e512-08ddfc45a5ed
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?c0hGbzh0MXoySGxYOXF2Njkya3l4aHF0Mk5MNVZGdnI1L1lWUWZzcnowNmhq?=
 =?utf-8?B?b2ZROGExOFY4N3Rydk9XbzVYMzZvT1ZxTlhRV1VsOUxkaW9PTVg4VFJUcUpM?=
 =?utf-8?B?S29sSGpxVkJ0bHhsdEw5ZGxpek1yOWRJc1M2cmNkZ0lIWEFKQXp3NUhFRytX?=
 =?utf-8?B?YnkyaDVydUt0U2pZWGxmTFRNd2tPcE5UU2NEc3pkajRjdmpUY01CU2lwNnEy?=
 =?utf-8?B?QUhJWUpXRVFvYmUyYy9RcVhPSnMvdnd3QS84NGlzL1IzSXNGcEVDdVVGU1Vv?=
 =?utf-8?B?VjRNSnk4NHF3a0tieEdRNmtJOG00OUVHd09ab05tckdzVkJBNUhLVTRBQndN?=
 =?utf-8?B?ekU5U1N6SVNZaXFGS1dZejdaWXNIeWhGREZxcG5Ea3A0bE5JRkFSOHF1Q0FD?=
 =?utf-8?B?b1l2bkVwell3Q1lNK2ZMa2RocUtiNDJzYVYwa2FvRDRCOUlnZzUwai9Zd05a?=
 =?utf-8?B?UlplYkdMQ0Z1b2ZFYlU5bVNxSExtRFl4SEZxTGhVdVA2aURES1hGNWR0ZFRu?=
 =?utf-8?B?TlpuczZRbWlYRjNrVEdUNTJ1VE90cGowYkpkbGtldlhRanNzUmdPU2lnQ3l4?=
 =?utf-8?B?VlVWS0o4WjZVS1U1NDF3dlY3YkV6T2dkNEVab21IWWRlS1hIb1BOOXkyc0E5?=
 =?utf-8?B?T3N3OFhERmE3N0lFcDRlVnVZeXM3S0xoTnZDcG9MZDZ4N1VXM2VFMFFpNVFQ?=
 =?utf-8?B?a2FjZ2ErcGVZK1NNdmZXMzdEUTdKRkQyMWplRWVsUGEwTENnR1dDT0tNaDBJ?=
 =?utf-8?B?Qm9Zb0hwSDNwcFV1THEwQ0pXV0Q5bzdLSWJBdHVLZDFySWoxbUNOdFJMSGJn?=
 =?utf-8?B?WnFhRUs4RmhXbG1tcmdWMG1VcEhIblgzM0k0d2Zrditjc2Zvbk5jQTJIUWNF?=
 =?utf-8?B?Q016c21RK0EvSnZMZnUzc0Q4czhleW1JT2JGT2tlVFBzbGhtRUttTzM2anZo?=
 =?utf-8?B?TlB5ekdEMHlXZW12NFdEOUFqU0NWbzJnQ1grY3YxMi9uL2ZBZVdpdXRhOElz?=
 =?utf-8?B?bE5VN1NqUjB1MUxtZ3JvRnFnU0F2OEo3YjFvK1lIejhnek9aUnJxUDBCcTVu?=
 =?utf-8?B?bUxrbFBTb1Z4MWNHMmdpc0pSbVhiVGpqVGNaWVNORit3YldIUlo1bTN0aERl?=
 =?utf-8?B?Tlk4WkpjUGFiYTEwY1B1dVBEUlBVdlFxL1NiczB3bFAvVEVxOVJKcHFtS1E4?=
 =?utf-8?B?aEtWUEVuUEZLb3N0L2lGR3daVUVuZEM0UDcxQ3l5ZmJEeTQ1RVQrN203NCtk?=
 =?utf-8?B?ZlZBU2ZQVmpYTjh4cWwwTC9SWnMrYXhUdjFmeEJiQnY4Smx4Yk14Z3AvNU14?=
 =?utf-8?B?VDhBTzNJdlU0NU1DYm1pcmFwNnZya3BPQ2RaN2NUTEx2Mm9IcTVqODZUL0tT?=
 =?utf-8?B?RVZqRmtKWndCVEhqcWkycVFPMHlTTVp4SjB5MkdBYTJQay9FOU5LaVRuNUJE?=
 =?utf-8?B?Nk1DNUFSczl2Y2psZTRSK3luQXNVM29PWEZDZ1RSTVUrQVhsVzRmbU1Da092?=
 =?utf-8?B?SU5RbzI5b1ZiWkFIU2xUdkdWL2lvaVNxU3ZkMHphUTA4WUd4bEFMRS8rTDMr?=
 =?utf-8?B?SWNtTVp3c0N3VkJEKzg5RU41ajRNUUJUdi9KU3cwSjdpa2JQckp6ZUg5amtO?=
 =?utf-8?B?c09NL3V3LytkVzcrUVllQ1ZwQjdPcFo4M1d1Q0x1ejVoY1FJZUQ1S2FNSGVG?=
 =?utf-8?B?R01Tbmw3U2c2RURnQ0FRLzFOblc5VllTdWNkcjNmZzA3cGdzYlUwVGdqOHlB?=
 =?utf-8?B?T3kxRDA5QVIxNTV2a2lkWmFKWktwa3NvT2xRUUtOL0VNYXFuQjc0KzBOUVFY?=
 =?utf-8?B?YnI2OUlZWllIMlVGWUltQUhZMTZuQWpwM1ZZSFVkWEtLQUNuUU5yTUF6Rys5?=
 =?utf-8?B?WGNwdm9KbGVXQVEza09kV1ZMdkFvQWxlcTFRcGQ3cXJQZXhxTitsZEd3cnVm?=
 =?utf-8?B?czRrdEsvMzBNbVdvNmE2WjZ0bk5VTTdFWXltK0NESmpGVStwRGtnTlJoTzBJ?=
 =?utf-8?Q?lCtJhU6WSUX8Kb3LjF4SufM/DCtNNc=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR07MB9604.namprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?aXFuYldXU2M2U093NEFobzhXUmdVdEs3d25abHZEY2V4NjVRMnM2WmpOeVYw?=
 =?utf-8?B?WVJURkc4TjdaOGZQU3VSNWgxa2t3MXEzWCtDV3lacnRTaXNoOWUrTXczU3Ux?=
 =?utf-8?B?TjNxVHYrZDRDYXBjWjhrQ3A0Qlg2ZkxYb3p3am9OeWoyaDlYWG10ZndPVkJS?=
 =?utf-8?B?MDdBekxDV2d6UEhsczhDYkpjd21kTVNMTUE3ZzVZTGkyZ1Y2U2RhSXVZazJs?=
 =?utf-8?B?N2ZOUkhSU3FrSFMyRlNtMjNNQVVoV3ZCSGdzSTRhZm1SMlpVWHhXOUg4Q0tT?=
 =?utf-8?B?bWNxVWVUMGx1L0xNbU05TkFlbHdPZ3BkOXFXWGNFRUxFZ0FBRUtQcUtIUitL?=
 =?utf-8?B?S2U5dWIwdktSZ0ozb1JZZTBOTkkvWU94QjVsYStPa3dIVzI5c3k3ZGY3eU9H?=
 =?utf-8?B?NGxOeFZmNFBxdk1PMnk4S1VDSjNvUE5wdWNZczdReDVKL0tDOU5icDBKanpI?=
 =?utf-8?B?YTZlOC9yaGNmOC9RQkM2K1lEZDhpRUdRQ1dTTEc4UkkxUCtkTWNFSDI4ZkpY?=
 =?utf-8?B?WHcwRU53RG1GZkwvZGtlTVBXQjdILzlyTVptN0lFUTFnQ1VtcEo4RC8vTmNS?=
 =?utf-8?B?NStxeGs2VmxRWjhSY0tmMTdKdFNQV0szd09kMWYrUldwejZYNjAvOVgzQXhE?=
 =?utf-8?B?YXpoSEJBWHdYbjZlR3E0SVcrdzRnRkcyRXJKdnVJbjlwUEpjbGZRazFQNkRs?=
 =?utf-8?B?L0dPekE2RUsxbmNzeVVPQ0kvdUd1dE04YkFyZVdJRTBCQUZjTGJNcU5NRlU2?=
 =?utf-8?B?UGdSTzhQNzRVWTl5bkJ2OTU5dkpJcG5LbnQ3a3k4Mm1BS0hyckpnaUR1ZC9B?=
 =?utf-8?B?UnBuTXE3cU9mcTRPVHhTb01hdFFIMjlaZkNNYjRWYmdNY0oxSHlqZTkxZTJO?=
 =?utf-8?B?YWFyN1JjTlloZWJFVEdHd0szWldYNEoyRVlEem95M0ltT2NUbG5TVy85ci9q?=
 =?utf-8?B?dVhuTGFuQTBkcVR0K29Kd2g3dGYrRG82eG81OTJiZFQ4WFI5aFUxdUlveDU5?=
 =?utf-8?B?ZitrbUhDczBnck5hM09hL3gySVRwb2Rnb2ZEUnFjK0hYdURaWGg1ZjVkY3Zz?=
 =?utf-8?B?ekVpckNzVkhlYmxQMzYxVkIzTTFIMzBIMXZqeTM1VEJTRFZjREdCaTU5elNS?=
 =?utf-8?B?RCszWUdRbERUTVpMR3ZPN0dlNThlQ2EreWdidk9reldlcHRxTnBCNEdvQ3F1?=
 =?utf-8?B?UUpaWEtmRzFsejdsdEZVRUdSN3lKb0ZlcENLWHg2Ukp4TXhjeDAzTjJkT3g4?=
 =?utf-8?B?UmNIbll5VCtBTFZlQlNXTElkMEhpZE02Q3lSejJNb0JQaC9iOFYxWWI4bkRS?=
 =?utf-8?B?MGRncHVqRDI0TmE4b3k3NEEvbTFseDR1d3pqNFZnMndHalA3aFIxY3VzK1Rn?=
 =?utf-8?B?eE1OOHBndWI4UWpXa3BWaGovRFBOMVd5M1dNYUZreHpMWWFFQi9yeUtLSTVi?=
 =?utf-8?B?a3dJUGlBaUF4OFhhdzdhTXhYN3BTZnkybU03NUZNUFYrK1l1d3hDWGZxblll?=
 =?utf-8?B?RW9qRnVZK1o3b0RyZldiRkIvbEFVL3JCME1lbDUyL0IzMVdkeCtCRVJLZ3k1?=
 =?utf-8?B?L3FKQjQvcENqc24zc1BXZFJpVVR4RklJNDZyVU53eGlubjlnTDFXbDBzVDY1?=
 =?utf-8?B?SEtmcC9lbDNFS3Z1VFBIczJVRkJBdGRjRXdMb1NSemQyYUdySksvMkk1M3ZT?=
 =?utf-8?B?WjdIekJBc2ZQVVByOVhUSFhVbDVVSnpFWnN6VE5LQThNQTBIVXZlaGNYcHhl?=
 =?utf-8?B?K2RBblV1dHlXT3hVVXZtQzMyczA4ME5WKzkrTWFIYjdTc2VDR09jbkJWRnFv?=
 =?utf-8?B?NUtzRjEyeXFPaWM1RnNtUWVZdnJZeHlveDBUQ3BlOGZMSXNFa2pWRUdIaUVZ?=
 =?utf-8?B?OUtZWG0yemxWZVJBZWdSbUVtNkVjczVTaUtuSmVyT0tiUDJLdkVacy9vNWoz?=
 =?utf-8?B?cU5JSlZKSm0yM2VUSDdRTXkwZDV3WFhhMnNZQk80V3RNUUh1c2lzSVdVbEpl?=
 =?utf-8?B?SlI0NE5XeFRVeVNvNDFDMklQMnJocis4NW9SSGlQYXpPcGlhOXFmVVBSRHFR?=
 =?utf-8?B?SStIVUR1TFc0dlhQSjNaSkhzUkgvdkVzclkxNHZob2E3RXFpK0RINkZOSXl4?=
 =?utf-8?B?ckhITEZtTEhva28xSWw1T3NoQ3JRUjVLT0VQZnBPRkU3d1lIcGZMNmZ6cW03?=
 =?utf-8?B?anc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5847B30017C6AE4E9E48EBBBC9F23388@namprd07.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 292d722f-45df-43cd-e512-08ddfc45a5ed
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Sep 2025 15:10:22.2701
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QOAJsMOBUR1mcuj/vZKWULun/xYbMjpxdn0jSR22D66vqIg7H+2EgMnT24oTupUfCy3Ge1cyLRanriWlHxHmwQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV5PR07MB11452
X-Authority-Analysis: v=2.4 cv=W784VQWk c=1 sm=1 tr=0 ts=68d55b60 cx=c_pps a=WxwGY4H08PlrDVivH1wjUg==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=Zpq2whiEiuAA:10 a=VwQbUJbxAAAA:8 a=Br2UW1UjAAAA:8 a=-rN6-wwmgasTOrJkjgMA:9 a=QEXdDO2ut3YA:10 a=WmXOPjafLNExVIMTj843:22
X-Proofpoint-ORIG-GUID: fVp93J4SfDoUbI6b3NeIoCa5TrmMky4h
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTIzMDA4MCBTYWx0ZWRfX5EVt1HzqTLlU C+ACcw5XtyE5k8rlAE1pHKetBu6zwRs8JfNJjx33w4kjbWO2m+oMhSg9enDfHfxNOIZhjIwwpjP VSeNe6BEcw3SISN9L4+V0OTN002OhkJJEuxcM0x+ipuVKlp9n9VvuQEwlK9OPmoNvmXwzbP8poq
 EGup94AXe9elwUqQO+RoeeZTe9GVrkzdDQUlitN3ypsVvsn9CJIiBK/VAdofDWdUX4l4XwKG4G5 dQpdyy82NqurgaJr1+9BakVA6mFx4pSvUbUoMTAaCwpjlSySGhZmgTEmSjugLZMC1QWsWuOkwry qH0/IFdjChAiNgOGOb0LK5TGklaHyxEezFADy4Z+SDb92cAX2jSoYR4S0FyuLBxm7gK+dAETZ2G vtLYO3l5
X-Proofpoint-GUID: fVp93J4SfDoUbI6b3NeIoCa5TrmMky4h
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-25_01,2025-09-25_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0 clxscore=1011
 bulkscore=0 suspectscore=0 adultscore=0 spamscore=0 malwarescore=0
 impostorscore=0 phishscore=0 priorityscore=1501 classifier=typeunknown
 authscore=0 authtc= authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2507300000 definitions=main-2509230080

SGkgTWFyYywNCg0KVGhhbmsgeW91IGZvciBhIHF1aWNrIHJlc3BvbnNlLg0KDQo+IE9uIDI1IFNl
cCAyMDI1LCBhdCAxNjozOCwgTWFyYyBaeW5naWVyIDxtYXpAa2VybmVsLm9yZz4gd3JvdGU6DQo+
IA0KPiBFWFRFUk5BTCBNQUlMDQo+IA0KPiANCj4gWytPbGl2ZXIgZm9yIHRoZSBTVkUgc3R1ZmZd
DQo+IA0KPiBIaSBKYW4sDQo+IA0KPiBPbiBUaHUsIDI1IFNlcCAyMDI1IDE1OjAyOjIwICswMTAw
LA0KPiBKYW4gS290YXMgPGphbmtAY2FkZW5jZS5jb20+IHdyb3RlOg0KPj4gSGVsbG8sDQo+PiAN
Cj4+IEnigJltIGV4cGVyaW1lbnRpbmcgd2l0aCBOZXN0ZWQgVmlydHVhbGl6YXRpb24uDQo+PiBJ
IHVzZSBMaW51eCBrZXJuZWwgNi4xNi4zIGZyb20gRGViaWFuIGJhY2twb3J0cyBydW5uaW5nIG9u
IE5lb3ZlcnNlLVYyLg0KPj4gDQo+PiBXaGVuIEkgdHJ5IHRvIGJvb3QgYSBHdWVzdE9TLCBpdCBo
YW5ncywNCj4+IGFuZCBJIGNhbiBzZWUgYSB3YXJuaW5nIGluIEhvc3QncyBkbWVzZzoNCj4+IA0K
Pj4gWzUyNDE3LjkzNDk1MV0gLS0tLS0tLS0tLS0tWyBjdXQgaGVyZSBdLS0tLS0tLS0tLS0tDQo+
PiBbNTI0MTcuOTM0OTkwXSBXQVJOSU5HOiBDUFU6IDEyMCBQSUQ6IDQ0MTE1IGF0IGFyY2gvYXJt
NjQvaW5jbHVkZS9hc20va3ZtX2VtdWxhdGUuaDo1NTMgcGVyZm9ybV9hY2Nlc3MrMHgxNGMvMHgx
NjANCj4+IFs1MjQxNy45MzUwODddIE1vZHVsZXMgbGlua2VkIGluOiBuZnN2MyBuZnMgbmV0ZnMg
c25kX3NlcV9kdW1teSBzbmRfaHJ0aW1lciBzbmRfc2VxIHNuZF9zZXFfZGV2aWNlIHNuZF90aW1l
ciBzbmQgc291bmRjb3JlIHJma2lsbCBxcnRyIGJpbmZtdF9taXNjIG5sc19hc2NpaSBubHNfY3A0
MzcgdmZhdCBmYXQgYWVzX2NlX2JsayBhZXNfY2VfY2lwaGVyIHBvbHl2YWxfY2UgZ2hhc2hfY2Ug
Z2YxMjhtdWwgc2hhM19jZSBzaGE1MTJfY2Ugc2hhMV9jZSBhY3BpX2lwbWkgZGF4X2htZW0gYXJt
X3NtY2NjX3RybmcgY3hsX2FjcGkgaXBtaV9zc2lmIGkyY19zbWJ1cyBhcm1fc3BlX3BtdSBhcm1f
c21tdXYzX3BtdSBjb3Jlc2lnaHRfdHJiZSBzcGlfbm9yIG10ZCBpcG1pX2RldmludGYgaXBtaV9t
c2doYW5kbGVyIGNvcmVzaWdodF9zdG0gY29yZXNpZ2h0X3RtYyBjb3Jlc2lnaHRfZnVubmVsIHN0
bV9jb3JlIGNvcmVzaWdodF9ldG00eCBjb3Jlc2lnaHQgam95ZGV2IGV2ZGV2IGNwcGNfY3B1ZnJl
cSBuZnNkIGF1dGhfcnBjZ3NzIG5mc19hY2wgbG9ja2QgZ3JhY2Ugc3VucnBjIGVmaV9wc3RvcmUg
Y29uZmlnZnMgbmZuZXRsaW5rIGVmaXZhcmZzIGlwX3RhYmxlcyB4X3RhYmxlcyBhdXRvZnM0IGV4
dDQgY3JjMTYgbWJjYWNoZSBqYmQyIGNyYzMyY19jcnlwdG9hcGkgaGlkX2dlbmVyaWMgdXNiaGlk
IGhpZCBybmRpc19ob3N0IGNkY19ldGhlciB1c2JuZXQgbWlpIGRtX21vZCBhc3QgaXhnYmUgZHJt
X3NobWVtX2hlbHBlciB4aGNpX3BjaV9yZW5lc2FzIGkyY19hbGdvX2JpdCB4ZnJtX2FsZ28geGhj
aV9wY2kgZHJtX2NsaWVudF9saWIgbWRpb19kZXZyZXMgZHJtX2ttc19oZWxwZXIgeGhjaV9oY2Qg
b2ZfbWRpbyBudm1lIGZpeGVkX3BoeSBkcm0gZndub2RlX21kaW8gdXNiY29yZSBudm1lX2NvcmUg
bGlicGh5IHNic2FfZ3dkdCBtZGlvX2J1cyBudm1lX2tleXJpbmcgdXNiX2NvbW1vbiBudm1lX2F1
dGggbWRpbyBpMmNfdGVncmENCj4+IFs1MjQxNy45MzU4MThdIENQVTogMTIwIFVJRDogMjU0MzUz
IFBJRDogNDQxMTUgQ29tbToga3ZtX3ZjcHUwIFRhaW50ZWQ6IEcgICAgICAgIFcgICAgICAgICAg
IDYuMTYuMytkZWIxMy1hcm02NCAjMSBQUkVFTVBUTEFaWSAgRGViaWFuIDYuMTYuMy0xfmJwbzEz
KzENCj4+IFs1MjQxNy45MzU4NTVdIFRhaW50ZWQ6IFtXXT1XQVJODQo+PiBbNTI0MTcuOTM1ODY2
XSBIYXJkd2FyZSBuYW1lOiBTdXBlcm1pY3JvIEFSUy0xMjFMLUROUi9HMVNNSCwgQklPUyAyLjEg
MDQvMTcvMjAyNQ0KPiANCj4gRmFuY3kgSFcgKC9tZSBnb2VzIHNlbGxpbmcgYSBraWRuZXkuLi4p
DQo+IA0KPj4gWzUyNDE3LjkzNTg3OV0gcHN0YXRlOiA2MjQwMDAwOSAoblpDdiBkYWlmICtQQU4g
LVVBTyArVENPIC1ESVQgLVNTQlMgQlRZUEU9LS0pDQo+PiBbNTI0MTcuOTM1OTA2XSBwYyA6IHBl
cmZvcm1fYWNjZXNzKzB4MTRjLzB4MTYwDQo+PiBbNTI0MTcuOTM1OTMzXSBsciA6IHBlcmZvcm1f
YWNjZXNzKzB4NGMvMHgxNjANCj4+IFs1MjQxNy45MzU5NTZdIHNwIDogZmZmZjgwMDBmMzBkYjg1
MA0KPj4gWzUyNDE3LjkzNTk2N10geDI5OiBmZmZmODAwMGYzMGRiODUwIHgyODogZmZmZjAwMDA5
NzI0NTAwMCB4Mjc6IDAwMDAwMDAwMDAwMDAwMDANCj4+IFs1MjQxNy45MzYwMDRdIHgyNjogMDAw
MDAwMDAwMDAwMDAwMCB4MjU6IDAwMDAwMDAwMDAwMDAwMDAgeDI0OiBmZmZmMTAwMDJjNzAxYzI4
DQo+PiBbNTI0MTcuOTM2MDM2XSB4MjM6IDAwMDAwMDAwMDAwMDAwMDAgeDIyOiBmZmZmMDAwMDk3
MjQ1MDAwIHgyMTogZmZmZjgwMDBmMzBkYjhhMA0KPj4gWzUyNDE3LjkzNjA2NV0geDIwOiBmZmZm
ZGJmMTRhMTllYWMwIHgxOTogZmZmZjEwMDAyYzcwMWJlMCB4MTg6IDAwMDAwMDAwMDAwMDAwMTQN
Cj4+IFs1MjQxNy45MzYwOTVdIHgxNzogMDAwMDAwMDQwMDQ0ZmZmZiB4MTY6IDAwMTAwMDc1YjU1
MDM1MTAgeDE1OiAwMDAwMDAwMDAwMDAwMDAwDQo+PiBbNTI0MTcuOTM2MTI3XSB4MTQ6IDAwMDAw
MDAwMDAwMDAwMDAgeDEzOiAwMDAwMDAwMDAwMDAwMDAwIHgxMjogMDAwMDAwMDAwMDAwMDAwMA0K
Pj4gWzUyNDE3LjkzNjE1N10geDExOiAwMDAwMDAwMDAwMDAxMzQ4IHgxMDogMDAwMDAwMDAwMDAw
MTNiMCB4OSA6IGZmZmZkYmYxNDkxNjA4YjQNCj4+IFs1MjQxNy45MzYxODhdIHg4IDogMDAwMDAw
MDAwMDAwMDAwMSB4NyA6IDAwMDAwMDAwMDAwMDAwMDAgeDYgOiAwMDAwMDAwMDAwMGZmZmZmDQo+
PiBbNTI0MTcuOTM2MjE4XSB4NSA6IDAwMDAwMDAwMDAzNmNiNzYgeDQgOiBmZmZmMTAwMjcxNDhm
N2MwIHgzIDogZmZmZmRiZjE0OTE1ZjA0Yw0KPj4gWzUyNDE3LjkzNjI0OV0geDIgOiAwMDAwMDAw
MDAwMDAwMDAwIHgxIDogMDAwMDAwMDAwMDAwMDAwMCB4MCA6IDAwMDAwMDAwMDAwMDAwMDkNCj4+
IFs1MjQxNy45MzYyODBdIENhbGwgdHJhY2U6DQo+PiBbNTI0MTcuOTM2MjkxXSAgcGVyZm9ybV9h
Y2Nlc3MrMHgxNGMvMHgxNjAgKFApDQo+PiBbNTI0MTcuOTM2MzI1XSAga3ZtX2hhbmRsZV9zeXNf
cmVnKzB4MTJjLzB4MmEwDQo+PiBbNTI0MTcuOTM2MzY2XSAgaGFuZGxlX2V4aXQrMHg2OC8weDE5
MA0KPj4gWzUyNDE3LjkzNjQwOF0gIGt2bV9hcmNoX3ZjcHVfaW9jdGxfcnVuKzB4MmQ4LzB4YTEw
DQo+PiBbNTI0MTcuOTM2NDM2XSAga3ZtX3ZjcHVfaW9jdGwrMHgxYTgvMHhiMTgNCj4+IFs1MjQx
Ny45MzY0NTldICBfX2FybTY0X3N5c19pb2N0bCsweGI0LzB4MTIwDQo+PiBbNTI0MTcuOTM2NTEw
XSAgaW52b2tlX3N5c2NhbGwrMHg2Yy8weDEwMA0KPj4gWzUyNDE3LjkzNjU0N10gIGVsMF9zdmNf
Y29tbW9uLmNvbnN0cHJvcC4wKzB4NDgvMHhmMA0KPj4gWzUyNDE3LjkzNjU4MV0gIGRvX2VsMF9z
dmMrMHgyNC8weDM4DQo+PiBbNTI0MTcuOTM2NjEzXSAgZWwwX3N2YysweGQ0LzB4MTkwDQo+PiBb
NTI0MTcuOTM2NjQzXSAgZWwwdF82NF9zeW5jX2hhbmRsZXIrMHgxMGMvMHgxMzgNCj4+IFs1MjQx
Ny45MzY2NjddICBlbDB0XzY0X3N5bmMrMHgxOTgvMHgxYTANCj4+IFs1MjQxNy45MzY2OTBdIC0t
LVsgZW5kIHRyYWNlIDAwMDAwMDAwMDAwMDAwMDAgXS0tLQ0KPj4gDQo+PiANCj4+IFRoZSB0cmFj
aW5nIHJldmVhbGVkLCBpdCBtYXkgYmUgY2F1c2VkIGJ5IGEgWkNSX0VMMiB3cml0ZToNCj4+IFsx
MDldIC4uLi4uIDUyMDY4LjM3NTkyNzoga3ZtX3N5c19hY2Nlc3M6IFBDOiA4MDY2MDhiOCBTWVNf
WkNSX0VMMiAoMyw0LDEsMiwwKSB3cml0ZQ0KPj4gDQo+PiBUaGUgaW5zdHJ1Y3Rpb24gZnJvbSBF
TFIgYWxzbyBtYXRjaGVzOiBtc3IgemNyX2VsMiwgeDENCj4+IA0KPj4gVGhlIHJlYXNvbiBtaWdo
dCBiZSBDUFRSX0VMMiwgaXRzIHZhbHVlIGp1c3QgYmVmb3JlIHRoaXMgaW5zdHJ1Y3Rpb24gaXMg
ZXhlY3V0ZWQsIGlzIDAuDQo+PiBIb3dldmVyIGJlZm9yZSB0aGUgc3RhcnQgb2YgdGhlIFZNIGV4
ZWN1dGlvbiwgaXQgaGFzIDB4MjJmZi4NCj4+IA0KPj4gSSBjYW4gc2VlIGFjY2Vzc2VzIHRvIHRo
aXMgcmVnaXN0ZXIgaW4gdGhlIHRyYWNlIGxvZyBhcyB3ZWxsLCBqdXN0IGJlZm9yZSBaQ1JfRUwy
IGlzIGFjY2Vzc2VkLg0KPj4gWzEwOV0gLi4uLi4gNTIwNjguMzc1OTIyOiBrdm1fc3lzX2FjY2Vz
czogUEM6IDgwNjYwOGE0IFNZU19DUFRSX0VMMiAoMyw0LDEsMSwyKSByZWFkDQo+PiBbMTA5XSAu
Li4uLiA1MjA2OC4zNzU5MjU6IGt2bV9zeXNfYWNjZXNzOiBQQzogODA2NjA4YWMgU1lTX0NQVFJf
RUwyICgzLDQsMSwxLDIpIHdyaXRlDQo+PiANCj4+IEnigJltIHJ1bm5pbmcgTGludXggNi4xNi4w
IGFzIG15IEd1ZXN0Lg0KPj4gTmVzdGVkIFZpcnR1YWxpemF0aW9uIHdvcmtzIGZpbmUgd2l0aCBT
VkUgZGlzYWJsZWQsIHNvIGRvZXMgU1ZFIHdpdGhvdXQgTlYuDQo+PiBDb3VsZCBpdCBiZSBjYXVz
ZWQgYnkgYSBidWcgaW4gdXNlcnNwYWNlIGh5cGVydmlzb3IgY29kZT8NCj4gDQo+IFVubGlrZWx5
LiBUaGUgd2FybmluZyBpbmRpY2F0ZXMgdGhhdCB3ZSBhcmUgaW5jcmVtZW50aW5nIFBDIHdoaWxl
DQo+IHRoZXJlIGlzIGEgcGVuZGluZyBleGNlcHRpb24uIEhhdmluZyBib3RoIGF0IHRoZSBzYW1l
IHRpbWUgaXMgYSB2ZXJ5DQo+IGJhZCBidWcgLS0gaGVuY2UgdGhlIHdhcm5pbmcuDQo+IA0KPiBM
b29raW5nIGF0IHRoZSBjb2RlIHdpdGggdGhlIGFib3ZlIGluIG1pbmQsIHNvbWV0aGluZyBpbW1l
ZGlhdGVseQ0KPiBqdW1wcyBhdCBtZS4gQ2FuIHlvdSB0cnkgdGhlIGZvbGxvd2luZyAoYWdhaW5z
dCA2LjE3LCBidXQgeW91J2xsDQo+IHN1cmVseSBiZSBhYmxlIHRvIGFwcGx5IGl0IGFnYWluc3Qg
Ni4xNik6DQo+IA0KPiBkaWZmIC0tZ2l0IGEvYXJjaC9hcm02NC9rdm0vc3lzX3JlZ3MuYyBiL2Fy
Y2gvYXJtNjQva3ZtL3N5c19yZWdzLmMNCj4gaW5kZXggOTEwNTNhYTgzMmQwOC4uYTA3YWQ1Yzky
NTgzZCAxMDA2NDQNCj4gLS0tIGEvYXJjaC9hcm02NC9rdm0vc3lzX3JlZ3MuYw0KPiArKysgYi9h
cmNoL2FybTY0L2t2bS9zeXNfcmVncy5jDQo+IEBAIC0yNzA1LDcgKzI3MDUsNyBAQCBzdGF0aWMg
Ym9vbCBhY2Nlc3NfemNyX2VsMihzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsDQo+IA0KPiBpZiAoZ3Vl
c3RfaHlwX3N2ZV90cmFwc19lbmFibGVkKHZjcHUpKSB7DQo+IGt2bV9pbmplY3RfbmVzdGVkX3N2
ZV90cmFwKHZjcHUpOw0KPiAtIHJldHVybiB0cnVlOw0KPiArIHJldHVybiBmYWxzZTsNCj4gfQ0K
PiANCj4gaWYgKCFwLT5pc193cml0ZSkgew0KPiANCj4gVGhpcyBzaG91bGQgbWFrZSB0aGUgd2Fy
bmluZyBnbyBhd2F5IC0tIG5vdCBzdXJlIGFib3V0IGFueXRoaW5nIGVsc2UuDQo+IE5vdGUgdGhh
dCBJIGRvIG5vdCBoYXZlIGFjY2VzcyB0byBhbiBOVitTVkUgY2FwYWJsZSBtYWNoaW5lLCBzbyB5
b3UncmUNCj4gYXJlIGJhc2ljYWxseSBvbiB5b3VyIG93biwgdW5sZXNzIE9saXZlciBoYXMgYSBi
b3ggaGUgY2FuIHJlcHJvZHVjZQ0KPiB0aGlzIG9uLg0KPiANCj4gSSB3b3VsZCBhbHNvIHJlY29t
bWVuZCB0byB1cGRhdGUgdG8gNi4xNyAtLSA2LjE2IHdhcyB0aGUgZmlyc3QgcmVsZWFzZQ0KPiB3
aXRoIE5WLCBhbmQgd2hpbGUgaXQgbWF5IHdvcmssIGl0IHdpbGwgYWxzbyBoYXZlIGEgbG90IG9m
IHVnbHkgYnVncy4NCg0KSSB3aWxsIHRyeSwgYnV0IGFzIEkgZG9u4oCZdCBvd24gdGhpcyBtYWNo
aW5lLA0KY2hhbmdpbmcga2VybmVscyBtaWdodCBiZeKApiBjaGFsbGVuZ2luZy4NCklmIHRoZXJl
4oCZcyBhbnl0aGluZyBlbHNlIEkgY2FuIHByb3ZpZGUgdG8gaGVscCB0cmFjayBpdCBkb3duLA0K
cGxlYXNlIGxldCBtZSBrbm93Lg0KDQo+IA0KPiBUaGFua3MsDQo+IA0KPiBNLg0KPiANCj4gLS0g
DQo+IFdpdGhvdXQgZGV2aWF0aW9uIGZyb20gdGhlIG5vcm0sIHByb2dyZXNzIGlzIG5vdCBwb3Nz
aWJsZS4NCg0KUmVnYXJkcywNCkphbg0KDQo=
