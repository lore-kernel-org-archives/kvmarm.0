Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FC0928E0F
	for <kvmarm@lists.linux.dev>; Mon,  3 Aug 2026 16:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785773156; cv=fail; b=QvrHB/3TFcp2G6mpo4HRDJ4G8mvUpWfdx0tncw7LHa7ksLiexl0AJ4ejo983YM8rode5KcCSCiyaBcQGBZRoUzTYn7Sh5AkqQFwQ5UjIz5LQ1oAKC6ZBJgHxUmNszs2ZBwEoBQejTnBFhpe/zcINsFrZcfGmPVlX5hFnr08bEtY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785773156; c=relaxed/simple;
	bh=iUErXZXSU39mF8lneNJZNoNtAi6SGLA7nPoFBWCtu8Q=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=EcIwhnIr9miw32LmIoiSjd59UnGMB/zarOo7cUCI0BPYyXkJlagHVw+Tp7hlGqPnLhmn6QTTOt0op0tzY+2rsP4zDHH+5Tb7hs4qaw20ucJ9BxolN3+sazJKakAimktSHozo6g8+W4VTF2rBSe6E/1TPgh44UtoqsaZ8QNpGE9c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=1z+bB0qw; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=HGkFRkgp; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="1z+bB0qw";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="HGkFRkgp"
Received: from pps.filterd (m0127837.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 673EHI3F1811443;
	Mon, 3 Aug 2026 09:05:45 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=iUErXZXSU39mF8lneNJZNoNtAi6SGLA7nPoFBWCtu
	8Q=; b=1z+bB0qwSrFE4JNdeK2De6unXJQwRxUTCh42VEOb1ssUXpXOJ3rqE6QXb
	+1z6prPEsANiu7SVelv8fn37Gr6GM8SjsNnXSlDSm8si27FrZk4txMxlyFY2N5ni
	VvkEtY0DIrFV8QbPwMOkqpzO5HFG6nR5b4xpu1o3dbLRzGRiQKE1mNTfdFty1dcU
	N8XMR1cjupx/OPsCxnZOTUHZ+jSxSakyIsyfTSwxw0mDkPnE0xq9xn7SDA+0apQq
	WM64OJqbS2lF4/Seokoucfq+gbwUY9qBfAND/UeOagh2wbbqjDCZwFOpH0gZ5NxM
	azvbOsw6x8EmpNwP7+Fb5l1GNAWww==
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11022108.outbound.protection.outlook.com [40.107.200.108])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 4fscq6c450-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 03 Aug 2026 09:05:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vmA6G1R7fhOz3xu/4kBInBYf1/wB/XTzlvsHpG0eNpS+gu+y0LSwJBBcP47fBwY6Yb8PbraUnYw3EsRV9CjbIPWMEGdG1gxM0yMkIJd7sDMew59QZoibiazCjW7ekhnShV6SK38Snj0Yx5UvtC927/3t37APABvJ8enr6UzPzVymQDnnyWbfP9kLg2UXNIC8fNMGcnrb9gQFf0GPYWGSWprNvOsOOFqFIfw1YQTzwup0P81q3FajCCqG7mOp0AuA9CDOrGJHQZZboYe7R8tnIkSqVKFPnRp5iqx6dA2TAzdENuOWU0Y8iFupvXxRQRKGozGEmJJ1yf5BmGKp7DBrIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iUErXZXSU39mF8lneNJZNoNtAi6SGLA7nPoFBWCtu8Q=;
 b=Qu8/4Q2ri8KY525/RFgX3BuCZl5kJCVFh3C11cRhTC+pEcJyRaJEOOZFwtFbpzi3Vy8uyqQFbQPLrZT/Ka7OdyA6HN79ZJ0MSKA79zYNAy0JyOdaGb0cZ7eUkwdumHxiBwr0AuTqLG/m1S8firBafBZH7p6u9qHb0UHNHmEhmVkpgapryi6MnCXYo5kliVkxNbUdXPr/YXfpPY8io+VH8I2uWlsTdekR5oucCbG1tiHuUV6PmGHkBn0ISk3J4Shh1XOi8Chlx6SVFWvaUmv0fl3K6pxtIlLKayd5wu5R9UoltZOLuZm00ovlWsaFGfFGQjvb9mwFU3xlt5Ymgq75mA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iUErXZXSU39mF8lneNJZNoNtAi6SGLA7nPoFBWCtu8Q=;
 b=HGkFRkgpyyHYMzpj30SNy8QY2kw5KjmmOZdgyU0P8hXOqggNwzOOwXFEnR44rBScRylLC9kmcm82XCIpz7ufeMmWi8wLJwWG3zOaQYDzvoMXBMm//ndSSL/yace7rAMuyGAlde51lNgJ+ByZRgp43C0pr2jpVNVX9UUe2oqIXzQ7KWMlZLkrS+t+uyy5oufCwDhm1EjhYApXHsw01u1a8TF3H2N/oZ6DFtH1nkywuk3Ngyh/e4zJpDhDKmVhd97dcKWYe5D6g+njs8ErkikaDSteyVA+q4xlAkJN3o5LhQFB7WN+FoeMJQTrxar7XaOFG8uv80rVMpQX64hfmFuwdg==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by CH3PR02MB9235.namprd02.prod.outlook.com (2603:10b6:610:152::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.18; Mon, 3 Aug
 2026 16:05:42 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%5]) with mapi id 15.21.0270.016; Mon, 3 Aug 2026
 16:05:42 +0000
From: Khushit Shah <khushit.shah@nutanix.com>
To: Markus Armbruster <armbru@redhat.com>
CC: "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "qemu-arm@nongnu.org"
	<qemu-arm@nongnu.org>,
        "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "cohuck@redhat.com"
	<cohuck@redhat.com>,
        "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
        "richard.henderson@linaro.org" <richard.henderson@linaro.org>,
        "maz@kernel.org" <maz@kernel.org>,
        "oliver.upton@linux.dev"
	<oliver.upton@linux.dev>,
        "berrange@redhat.com" <berrange@redhat.com>,
        "abologna@redhat.com" <abologna@redhat.com>,
        "jdenemar@redhat.com"
	<jdenemar@redhat.com>,
        "gshan@redhat.com" <gshan@redhat.com>,
        "skolothumtho@nvidia.com" <skolothumtho@nvidia.com>,
        "sebott@redhat.com"
	<sebott@redhat.com>,
        "philmd@linaro.org" <philmd@linaro.org>,
        "yangjinqian1@huawei.com" <yangjinqian1@huawei.com>,
        Shaju Abraham
	<shaju.abraham@nutanix.com>,
        Mark Cave-Ayland <mark.caveayland@nutanix.com>,
        Prerna Saxena <prerna.saxena@nutanix.com>
Subject: Re: [RFC PATCH v3 16/19] qmp: add query-cpu-props-info command
Thread-Topic: [RFC PATCH v3 16/19] qmp: add query-cpu-props-info command
Thread-Index: AQHdFWubvCZ5bHZqSUmcDdL6/mUClLZ2aouzgBYuboA=
Date: Mon, 3 Aug 2026 16:05:42 +0000
Message-ID: <6AA3BD42-9596-476B-9F64-AB09372821B9@nutanix.com>
References: <20260716213858.609699-1-khushit.shah@nutanix.com>
 <20260716213858.609699-17-khushit.shah@nutanix.com>
 <87y0f5u78t.fsf@pond.sub.org>
In-Reply-To: <87y0f5u78t.fsf@pond.sub.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA2PR02MB7564:EE_|CH3PR02MB9235:EE_
x-ms-office365-filtering-correlation-id: eb4bfbce-dc85-47e3-85d8-08def1791195
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|23010399003|376014|7416014|366016|38070700021|4143699003|56012099006|10067099003|18002099003|22082099003;
x-microsoft-antispam-message-info:
 tzp+FjtKZDlY6fAIf7qzAfL4I2392m/u7FNeyG1gX4oe0cUwHyLIT3G8MqUnX2DcZc6D+tMm7WM0e2PVq4NJfdUHv8tBis6b2I0yygMAFtEqCJ6MLlqsAghyVxSs9fLbEn2/Gimdy4bFhA/BAt1bEf6eMrM8wvlJpvGiJcqfg4/5QBCWifAxY8VA9Dj6n36AU9/jI8tKVTbG0Q/Jrs6DXNAgJ0vw6iMe2xHy45FL3aTCdKT0KeY9cjxRcXFG571vueCWTbfIqbKiz4kGgJeVSayv/4Rv7s64uhbQYsmuT7hyV6T02SvyNIS37dI6d5VhG0d5ZBEv1UQ9rhksWfB8PwDn99dsikV7cwFjT4CHijwmS9HmOosFzwkcLGxPM5bJ/GiPNBRBUQJnjUQgu3G4i4DUSvVmGdXEVKWvzERG52V0FJ6LaRaTYy0HLGxySuAIQ4AqiNypXEJDQqt/F73UPGW4mg0RhxNu1qTIepDPgip8gS8/2gvksQ5yfaxod5M+Jo/WMPbbYy4QdYHWa7v1NUdnj8Pq9jbLDtZs2K0y1NHTjrh1hg+p7vLBX7a/xi0gF2GW7vI/72WH7R7TT7zTzftMA8edv9ljVgDm3vIqzbmV420Ae3MWhHLBr4Yx33r1DS/G7OPWZhYk3o6aMYG214naNuAvba87a7Detn0wW3YzgpEUIArCvmTKMhYNaLi+Qh4FQ80f3FpN5rSzK6CbOnXUCeMFSEeosZkirsq7oAI=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(376014)(7416014)(366016)(38070700021)(4143699003)(56012099006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?b3dIL1Q0YzcrN2ZSY0N4Z0pMcHJTMkpFcWlPRVFGR1JzSlFMV0JNMnM2djVZ?=
 =?utf-8?B?VVdka1ZaUXNDbEo3RjM5SWJieXJPQ1htUjgwcjJGb0ZFWnZqRGJyQnp0QnNN?=
 =?utf-8?B?Ukh1MU5BTVo1ZjNLRlg0STl4OWZyV2hXRmJQLzJHTWx1WUNLalZGTDQwNDhz?=
 =?utf-8?B?bnVQTndrK0tONnEvRGh0TFdSK2hiUEc3dDZ1bHkxb1dLTnRPZ2xwUVVlQ3hS?=
 =?utf-8?B?eE9RcXFrdHcvbzF3NHQxbXFCYy91ZWdZNzFwV3l6V0xkV2VLSVRNL0s5WjNl?=
 =?utf-8?B?TWMzWUFLVWI5MzhYNGU5bExwVkJ5VFpDVVBqMCtubFdoSUtzQWlaMkdsWlhI?=
 =?utf-8?B?K3Z4R0JSZ3UzUGlkYmVCVEtmeDJxdjBFU2R1T1NkTndjcDBhWS9WdTNlSG1k?=
 =?utf-8?B?ZmhVRlBPZzlMMnloRW1yd21USndKSW53VFBwcHVlb0o1UitmZUhabVY3VTB3?=
 =?utf-8?B?c3JMb0tVczVOTUczd1gzZmh5MW1lTm03OXNzekJVSzE5bXB3ZzM2WG5BMDNC?=
 =?utf-8?B?akk0ZGVLWHE1bll6SU5QOTBXUEtNS1huc2Vva1N3QlRxSHNuSURMaDJoY1k2?=
 =?utf-8?B?UkNRZjJHcENzbWRCRURkbVhFdjczUVF2c0hmR1hBVm53WHU3OW5yMC9XbmIy?=
 =?utf-8?B?enFMZ3RqVkpnT3BDVUMreUczcGY4T1FySWlmTEVCTkFjdGxsMnlVMUFPTCt1?=
 =?utf-8?B?UE13QUlodUpKNE1RUzltNDJOd01mb3YzZ2JwemU1TjNIbmF0OVdyQTB6cThY?=
 =?utf-8?B?eTFpUFRiMmlOK20zL3ZCVzY2TzdsOEVjS1VVbmduazVnKzByYjNkWFlFNGFR?=
 =?utf-8?B?M202S0wvUFRJNkpWNjlPVm84T0ZxNnRqQ1c1dTI3RDQwNTlidHRQN2hNMU5a?=
 =?utf-8?B?QjVLYmRRNS8wV3h4S01EODgrbFFSdHdtZG9EVTNmUkxrVXI1KzBtTmdFcGM3?=
 =?utf-8?B?UzRkMDVpVmwxQ2haaUlaUkNpNVNOeTVjOTdVSFFMVHkyRzhZeVBTLzZCcytJ?=
 =?utf-8?B?YUNUNTFqeU1SU0NVb3BqMkVUdm9ob3hOTDB4SmlsTEVZVmRQd1FnLy9YcXo1?=
 =?utf-8?B?VTEwYzdjMmFENUVLRy9BcXc2MVRUemVpTElteDFCV0x2dWU2S0JibFIrdTdn?=
 =?utf-8?B?WjBGTXZvTFQ4WXppd1JQUTNqLzViNEUrVDJ6S09valFkcFk5aG5hTGx5RWhV?=
 =?utf-8?B?c0NweE93Y0NDaGo0TTZXdi8va241MXIxRkRMamV1WXBCaFFJbzg5M29JWVht?=
 =?utf-8?B?SmdSY3EvU3lZSnZVYTVoZ01vRmlRSXVzZ0pxY25NemJPWEhiYmRqWG5rR25h?=
 =?utf-8?B?RUp0ZTgwRVlMaTlENEZJcmZ1VWNUcld2M2dibGs5K0d2V1NIY2FrMy9ESlBt?=
 =?utf-8?B?MjdJWlc1cEs3Yi9udnZzOXNQYnhHNElobDRpa0ZzeXc1MlBFcVF0Uzd2NlVQ?=
 =?utf-8?B?c2lPSHVUMjN6a0w0STAzbkVkY0k0ZlQ3M09jcFQ1WGZKWVIwYnBGOUdISWlF?=
 =?utf-8?B?QkRlRjIzQlFHY3FjMGdKbThJbE1Kbi9NQUVacGpsWkpyc0Y4NTk0UnR4OUJO?=
 =?utf-8?B?SnhnNGtwZ0JOZmt5bUlZMkhMeEdoWjVoVzJMR1dTOG9maUdYZWNpTC9iek1E?=
 =?utf-8?B?aGxuUFI3Y1Y3QlVkcDRZd1Avc0t0U3VJVXZpeHF3M2hFa0lMbmIweldJUEJR?=
 =?utf-8?B?V2ZzUEFZNDE4aUlkSEorSW5mNzdBaEpnL29OK0tyRGRYdkIyZkZ5eWVMY3Bk?=
 =?utf-8?B?ZzAveThIaTNvdjRRNFNBVzdnTm5wMG9IMjQ1blhac2QzRWhLbVNaM0x1MXZ1?=
 =?utf-8?B?V3k2cVU0N3c2M1NrU05ITDJHUmJhQ3ZVcnR1SjJUWXdUOVlWZGcrc1hzY3dl?=
 =?utf-8?B?cnRzNjlqSXVrOGp4dW9mY0NoUWlDYjYrT01ZeUlSRnJLVmVUc0xwUTN4eDd3?=
 =?utf-8?B?aEdOZEwvams1c0lWbjVjQWNKUTZRcldHam9QWkZGSFk5MGpnbHZGODRJTXFj?=
 =?utf-8?B?YkFCaEpMeWZ5dDl1QTVXdzNiTFcwazB6Sm1hc2FkNmdXMHg0Rkk3UGtoL0xr?=
 =?utf-8?B?SXRRUTR4bEFyQWNVOWpNNXZRd1ZXS2UvUzdpZXVkSDNjL3FZNXNPVmhaU292?=
 =?utf-8?B?cjJDL2IvRUg5TDZzeE43OW5wQWZTNVBRS0x3NWtNWEJoQThIbjM4MW01WnEv?=
 =?utf-8?B?WjdvZlRkUU5BekJXSW42YTl6cnZjdG90M3J3MEdBTlllWVF5UHV1S0l6eW5r?=
 =?utf-8?B?Z2pkWEpNdWF3NkY3L1RSeEF3b0F1V280ZUcxT3h6Y1BTVTh4VHlmSGNUZVl5?=
 =?utf-8?B?RXZGOGd0a1V0NzRPUGswS3RoT3hJaHBaZ09NZVUvU0t0Kys1Q0xUbkQxeGVC?=
 =?utf-8?Q?wpVNXFeBth7w6ynU=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <911DAF30B47FAC40874DD4369AC5A495@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	fCeMV3yJC1Cl4Hy8AAEco+Z8YZ4+1PRK43O7wBboWeYVjL747ntWLySvN5EowalTWq0jVyuaJU7IJP9h0TxPjQ8lbFqx/o6ntKhxIRYqhUeZOKdGJVvIrBJBCzeronh00kgCkTqAIlwH4vrugYwuCrf49KHvW5lYsJoHJBfPoLvHUHUKTRjyVJj2BC1KfUamPJZ2JBIsUSFqiBBGEn34iN0MCWgt5y6KZNIvZOoaNQlG7vbTQx4/Halj6mEzXcSD0gAzREqEhiW17BRKDgIsLx9Ck5WQS3CMK9DlatLw8hGucgCt10zaoSQVdzVQDoUCVDHMyEPx9HU+9Lm3uYI4vw==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb4bfbce-dc85-47e3-85d8-08def1791195
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Aug 2026 16:05:42.0986
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4pKP/GnnDFUm20FoqkcKIV/lW1Jw4auj/iXW1XvLYxo5gHabQZZcxJ5uL5cmDEbLEXSFKIjh1MaamRHnZjVCsSrK3AodIkgbxEL8fjU1roo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR02MB9235
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODAzMDE0MyBTYWx0ZWRfX1wvbtmPzTzpD
 n+hdOpTz1O0UjcNrhpXURTZ64bDozZPV7wkwnpsPFVCY2SA3/2xSL3nbqEaNFn5QQHa0u1EP/WB
 K92yLES8eXxx3iVqQRmVdRawDb3xuOGBzgnxo4Onee0jZ6Wo5ww0SqOlXh1+glAjr/d2xHZxdN3
 2+UfJSTOuYAx5GnIURRbiSTtG3HO+hHlDBMVP4/OY2/iPTs7Ssb5mw17tKqIBt43J4QGEtAP5tp
 CRHgi9IFnCg2QEpnL/plBjz1OnLBeEVw4uUHD4qCRVMuIzDCWoBYkE4v4fpsNvYJwSDP5Hf/3Pw
 bcmLt8zFUhqng5Zg1v/ghoY0j0X+txF44uEhhK1dbn5MPBBfLtGgjbKQdjEgWN/T+XSGySAcJbf
 Ow+R/f2uJXLO6rlLzN0rJ+O09qoKdoV8b+NFl1JVWGCXBTxaO3UJN0MmbYlfkjdjye153oz6+Oh
 3YSfz2fIxyuYUGBWx9Q==
X-Authority-Analysis: v=2.4 cv=MexcfZ/f c=1 sm=1 tr=0 ts=6a70bc59 cx=c_pps
 a=s/l6Ps6BKnbfTvrvnp3tLg==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Sv0fKeRqtYgA:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VofLwUrZ8Iiv6rRUPXIb:22 a=Ap8k9tRZuQ82DLYWQqG7:22 a=NEAV23lmAAAA:8
 a=20KFwNOVAAAA:8 a=LNzhdRYH6PzGu4gxBnIA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYwODAzMDE0MyBTYWx0ZWRfXwhObABbUwYyl
 5Hah6UsbwvzKd9nViVwI0KfazLuSx6tIHdAYa91WnKZFZRmQIw8mDm+LOy+8TuWpTY9yN+HOaYx
 mWdCCBdKAgkDtauqx+T9CN0h3FInNMQ=
X-Proofpoint-ORIG-GUID: e1-VoVTF4leJx_qCH-La2KOgKHAGV-b8
X-Proofpoint-GUID: e1-VoVTF4leJx_qCH-La2KOgKHAGV-b8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-03_03,2026-08-03_02,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gMjAgSnVsIDIwMjYsIGF0IDY6NTHigK9QTSwgTWFya3VzIEFybWJydXN0ZXIgPGFy
bWJydUByZWRoYXQuY29tPiB3cm90ZToNCj4gDQo+ICEtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tfA0KPiAgQ0FVVElPTjog
RXh0ZXJuYWwgRW1haWwNCj4gDQo+IHwtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tIQ0KPiANCj4gU2VyaWVzIGRvZXNuJ3Qg
YXBwbHkgZm9yIG1lLiAgSSBuZWVkIHRvIGFwcGx5IGl0IHRvIGJlIGFibGUgdG8gY2hlY2sNCj4g
cmVuZGVyZWQgZG9jdW1lbnRhdGlvbi4gIENvdWxkIHlvdSBwdXNoIGl0IHNvbWV3aGVyZSBJIGNh
biBwdWxsPw0KPiANCg0KU29ycnkgZm9yIHRoZSBsYXRlIHJlcGx5LCANClBsZWFzZSB1c2UgdGhl
IGZvbGxvd2luZyBicmFuY2g6IGh0dHBzOi8vZ2l0aHViLmNvbS9raHVzaGl0LXNoYWgtbngvcWVt
dS90cmVlL3Vwc3RyZWFtLXJmYy12My1maXh1cHMNCg0K
