Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 131832E2850
	for <kvmarm@lists.linux.dev>; Mon, 15 Jun 2026 05:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781502242; cv=fail; b=XVcC6xu0Fg5XjIihCpLBlKD6r3w6oWF8/Tj+JqwG8nc0DmCs4IxgY4Km+Bk+n++SA+sers36qbNTxct+PJ8AkBmVQlkHD/FoOyk8znO/r68DPoaY45Z8wP3Wiu+mpmieaorBfq8xgcK4uG0fnL0wj+3g+8kBg5hB8fJdzckL4z8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781502242; c=relaxed/simple;
	bh=W9PDaiNhPxVRHBaFpa2wvmPF+MkOEvY8vwDhoyaJmQk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Euz9cH2p9/qsem6+vg8oD5jvgpS9jqCaq0FLZLzbpUCjb8q0HxpxrEg5bVUgr5tyEqAy1maZEzwgK68BKZW/7q61i0JuJr8aCod2BWz+irgSRQOyu0KRbTf2DCbNwUJ1bng8JAxIQInDd1vBSSBO97EvRRAQDP4iRm9iA9XYrhY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=tBEzQe4S; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=dOPR6y7p; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="tBEzQe4S";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="dOPR6y7p"
Received: from pps.filterd (m0127840.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65F1jSgm2150978;
	Sun, 14 Jun 2026 22:43:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=W9PDaiNhPxVRHBaFpa2wvmPF+MkOEvY8vwDhoyaJm
	Qk=; b=tBEzQe4SPbebOnV/pytfKtztagUfqGBLv6g3d4aAcnsFJ1eRl91m8NbIx
	kl+ZtEo806ms/NnbCrVTBPImBqK8axFb5CzjAbB2dKX3CYC6UuxXZkqWOEdm0jRL
	jlnN8zy/ko61h5Bcxb0kiPiuuJJC5aGcYRTG9G7xD/4fYOebW/Ro35iPZ5RVFmLU
	1rdwpurwpB+fHAPcUPRzmdlaLMlE3xbCYNdMSjtJx6Ph15tLdshrxXOQs3UGdkqE
	HcvTqDpQw6yAv76oMM4qaJzUlr2xa4MEnsHzl4AIsyt2ASDcE5VAupHLVEa96zW4
	alIqtiwuZzbHLWEDUBKf09H0jXClg==
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11022106.outbound.protection.outlook.com [52.101.48.106])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 4es3hpauee-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sun, 14 Jun 2026 22:43:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=R/70sNVyjG+jdyIAbeVDi8XcQXij86HOC7V0il1I7U16Qd31w2OXDp2T6zyBq6jsXk5x8nPozVvCmX/Lj6ZAjyLLcjOk/TFKMQMB1yTFWf43GroRvfakzsPQPmDb4bE6l1Po8HO0WhoDoNX1ZrwGt/8nfAl4VoQhbOD5LiajKYL9Vbr4vxQEAllQExobbhQckVnGHKwdl+fJ9dwfObtDiCWlHJ35i4/LFil5pzuA6mT+BuaEl2UfHsowKAeoI7oSvb6vjJ/ge+/UROz0P+txp2smWDbI2oeg8au7R0Gs3GAhCrdpsxW7H2OBFsR3nln04/vU9YSAH8eFTxZhYgqt5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W9PDaiNhPxVRHBaFpa2wvmPF+MkOEvY8vwDhoyaJmQk=;
 b=wqOrmICGdCrvZ24LQUcuXWKt+xo7DnUCLXg9QjwyWinPN0ig6bcu49teSQ6jsWHvc6TwHn7911657ERZFh59L0nMSpF/pdwz8Rc036LGfIFWmqGTi1x9LAK/Ddyqk5BlfJlvs28qSF60vf5zCmFJz9qlAK++vqkRxiCA5Im06sfKb4n0vqXDOvwCgJV6Hya6rX9Eitl0OVXNRRg2hsjEAMxr2AdhBdU2IFOWeNsGAkwmxXXtpEwBRd1yzGIH4GBztLRjypXYBtzh3wU+0Ya4ctCOlL3ktiaOblXP+4JXBGF8x+5fui3a2+QuYkDpsyYGLVs5Xn0XpcxypSUTGhk+ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W9PDaiNhPxVRHBaFpa2wvmPF+MkOEvY8vwDhoyaJmQk=;
 b=dOPR6y7pDpQa+DwuUvEcpv3FCiLO/VaWyouSZ5M0OED9RH/R8t/rT/Lb5jMzgZkQ4wb+vtFQ7/a1oHTL2e7o4AZ0G1moiAtnCaZWsgHAtxsX1r/PfzCOzVAa90X9LHCotqZUU14I6zfu+SDfQ9D65aohhmZHv0sVtV2zCk06ptF/uISZxQ+5sq03D9ZdW3xJ0ybFggJvx4dFj5b7Bl42jqTSNeF2MaDK6cTk49bF+RFdcUXZIxheHW4x7+btNKrnhZYbn1p4BuMC9SOcvGNmmd6G57ZEYyGpGkQ+XNhuNaGo5aev23SLhU0dtHsI79IdQn5hr6GuGLrkDcdrAiGEbw==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by SA1PR02MB8477.namprd02.prod.outlook.com (2603:10b6:806:1f8::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.18; Mon, 15 Jun
 2026 05:43:35 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%5]) with mapi id 15.21.0113.015; Mon, 15 Jun 2026
 05:43:35 +0000
From: Khushit Shah <khushit.shah@nutanix.com>
To: Cornelia Huck <cohuck@redhat.com>
CC: "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "qemu-arm@nongnu.org"
	<qemu-arm@nongnu.org>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
        Shaju Abraham
	<shaju.abraham@nutanix.com>,
        Mark Cave-Ayland <mark.caveayland@nutanix.com>,
        =?utf-8?B?RGFuaWVsIFAgLiBCZXJyYW5nw6k=?= <berrange@redhat.com>,
        Shameer
 Kolothum <skolothumtho@nvidia.com>,
        Jinqian Yang <yangjinqian1@huawei.com>, Marc Zyngier <maz@kernel.org>,
        Sebastian Ott <sebott@redhat.com>,
        "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>
Subject: Re: [RFC] arm: property and value naming summary between named CPU
 models vs customizable host model
Thread-Topic: [RFC] arm: property and value naming summary between named CPU
 models vs customizable host model
Thread-Index: AQHc+NUU6u7lDOWdBEetHLRTTdZXRbY6yoiAgARXkQA=
Date: Mon, 15 Jun 2026 05:43:35 +0000
Message-ID: <66FC2356-D89D-4200-8A7D-012F3FB15EC0@nutanix.com>
References: <B820643E-3F14-4CDA-BA6B-09C632F17B9E@nutanix.com>
 <87bjdgm25y.fsf@redhat.com>
In-Reply-To: <87bjdgm25y.fsf@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA2PR02MB7564:EE_|SA1PR02MB8477:EE_
x-ms-office365-filtering-correlation-id: 7ef00536-78ae-4da0-da49-08decaa10acc
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|7416014|23010399003|376014|38070700021|18002099003|22082099003|56012099006|4143699003|6133799003;
x-microsoft-antispam-message-info:
 LJW5Qc4Y3aqzDxP3yjgCeXy6qjTuA14peDPDYgdNr9vUmbEjVAdNeK0edB41iJwL25+IuuicucKlwFMVEybFmEyJy1hu9T9/jtNWkmloX56v58mug1syv+iZMLKzSrDloDryswEURlo57aOe6Ho+GvoRGTcHfEBo3sm2Lx9phUlzB9Y5Ds76KlydHPUZBuLF+Oi17xC2vIO1/ajatxmvn0IQsCR9RjEHuUeo1vhA5zX9fZNNdhZLdTNzTkhmlzmKyKRzSD715A8AdLx8GnJxa1/Y5nZB6YYFiDeKUYDolIJqvWY4tr82Q3JAtRsdZbN2Y1EWL19c7er+p1anzipquDCErVjvbibTwWHlBiFVNnHs/TKS3EjB9sUYfxlJxVVm295fiw8pzF04qHnr0w33O57ifZAManx2NHvfqav4J5BY3GDW4SxGy3S9SjsIdZfnNqpkoNiPEqoHxoPiFN9GP73wOjOj1HlzPiZ4zSkCI2agZIzFV5Ub/e//FNYuiOlZgG8joGR+yKE9fWSmm0h964ogarOCxqegqKhNQg1D/h1N+XF8Mh9qQQxMqs88VxjLfTEpqGbjBom8fCaUlqWSQtVfRJl6x5w9TQ0Tba5R0omOA/kedlIftJFNPg9uzcPyTLr7hpmRZTp8Qv+Dszny8keRn8RLFjavR+fD2jcBWt8wgfJTBvR2u6fGoSoVcUzW4/9TycEZj5RjUII45gIVvseB4d56gmoxu8JyCD72ZkLJmONxzKZGmS4xraelT/R6
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(23010399003)(376014)(38070700021)(18002099003)(22082099003)(56012099006)(4143699003)(6133799003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?SWZNeHBxbTZnS2VZcVZDdlpSTlN2T1VtSnNxUTJXYlFyaG11bWx0dzh1YlNi?=
 =?utf-8?B?TkNrTFdUS2xxMW9vUDdmYWVPL1lwUm84OVJWS0phekZjd1l6eE9kNWFLWEY2?=
 =?utf-8?B?YU93NkFka2JSQXJyYzN0cUcwMFBTdzNyRGg3UWVLR2hZeVFSbDdBMzRaQ1BR?=
 =?utf-8?B?TXNFQkN6bXFSRjIzc2VzM0hqK0pFRWcxSjVnbWZXZG9MdG53TGhVYnY2UC9X?=
 =?utf-8?B?NlRTZFlNYkZuU0dqOWdVZVoxbVZwbElxcmRZQnlETXVCYjhZZXR1VzNzSERv?=
 =?utf-8?B?c1BqVWY0dFkrK0tTbCtLWmdaQ3Zwc3p4Z1dwQ3F4bVN1OTYvSVhQeUphd3Q5?=
 =?utf-8?B?UVFWMU1QcGR3ZHliNkNJWkNsclc1eFprRzB6b3BKUW1lZEowY3FXQk9kSHNv?=
 =?utf-8?B?YVU0N2JoMHlqNmQrVTZObHd2bFBESnk0NStGVmR5cjh4dDZmNTJZdXhpYWxJ?=
 =?utf-8?B?MUZ6YTJUemVJaW41ak9XczdIWW1BVzU1RFg3ajV3T3NXRGZ2WXNnbEtweDJQ?=
 =?utf-8?B?bGVneWxJV3RBWU1xUXBTZzlTU0tYamFoTTMzTkFSYnFueVpsMG1FUEp3VHZS?=
 =?utf-8?B?Yi9rM0EzZllYQ253Nko1NUh6L0VFenpmTFFDQ0JKNnM1Z3VmVXU4Zmg1RTNN?=
 =?utf-8?B?a1RQSmdTV0Z6VG1rNEh3a0NzczRoSWIwaWpBazI0cmc3c21MOTR3V09lam4r?=
 =?utf-8?B?S09RK0FSVmVVYWo4aVQ4YXd6Vm13TkI1YzhncUhyVUxndzJBZ3Z5TjhFNVdw?=
 =?utf-8?B?UVp2UThuWmM3U2Nmb3J4YWdPdVZVTWwxS0J0cmdHdS9wcWczQ2J2RlFXZ2h3?=
 =?utf-8?B?cUpJNjAxZzFxMTl2VzBDUjFFZ0FZV1ZqbWsyaHBUeGVNdExsSld6aGxYd0Ny?=
 =?utf-8?B?T3gvbkpKZ3g2bTNPLzMvMEZpazZMa0VEL1kxM25qNkxkTTdocnJPQ3VvQmhB?=
 =?utf-8?B?M2k4UE9VMVZ5R1B2RCtMZ2J6ZXlnZ1BCQ2ZWRVRNVStKeVpCR0V1R0dtenNP?=
 =?utf-8?B?VlVEUG1QNFN3dFZnRGU5em5DVnpPK0NQZXVYeGYzdENTNlQ0dm5NQnRtcDcx?=
 =?utf-8?B?Y2FpNXNLQUdwWFlQZHZJRUlKTmJRcVpjaVNxVXRrZ3lDTStvVTVOb1hpSWll?=
 =?utf-8?B?VWM4TnRQMzZ3TGd3WUI2UEV0OXBoWmtJTW1KTmhjSnpXczRFRGZCeWNXenB5?=
 =?utf-8?B?cGxmRU5PdzM0SHZ5NjFrOGYyYnNwbURyWEZEMlRxM2xYYTRhSlBVOUV4NVNu?=
 =?utf-8?B?MSs2ZktZRFVLZGt6MVVON1JXYXRNVlBvYUtlaWdlQ2FJSVFVQkpNNk9SSSto?=
 =?utf-8?B?SUNQLzJJcURxYitWRXYySy9aVUxoelVYWExTbXI0eUp5elVVTFdoY2RjTXVa?=
 =?utf-8?B?V2ZNVGlEVUVBOU91YTJaTTErc0dPTVliRzhzeXFZL3VzekRqaFBXSkVpY3Bt?=
 =?utf-8?B?azhsUk4vQjlaZUxUYmdzMEVxZzU4VkVhL2NzMEY5U1BocnMwZlVYVWhVenlW?=
 =?utf-8?B?dUl5UGJHa0twdTJtVlFpZVlzczhaaTZ1dTZEYzlXV3FsSHdqbExlSWszNGgw?=
 =?utf-8?B?N3h6TTBvbkhHM0l3OVBrbkVVQXJ3VEI3c3crVi9aVmlzWk1TN1NPNFpQV00z?=
 =?utf-8?B?Z2dPWnh6RzdVa1RtYTI2N0E0QnVzb3FUZXlIRlJuQ01QVXU0U01hZVlTeVY3?=
 =?utf-8?B?ZXBDS29uSXpVWWFWRGllRkh4LzRGaVdQYzFFb3VkVXk3Qm16ZFc4akpoUUNJ?=
 =?utf-8?B?dE9rcGdzUldGd2d1L3F1US9vanQyVXYwYjRhTlpoRDNvNUliQUZOWGRUaWpD?=
 =?utf-8?B?WjZmdEFGbW81TjFBWDhoTGsxK3licmsxbDhZcC9zMFIrQ0FqTjVGc2phdWpX?=
 =?utf-8?B?eE8yZ2V0SHJqUWx0RFprVXNuTEJweG5QcDI5eExXa1g4OFJ6RjZYeHEvWkJ3?=
 =?utf-8?B?VmRMbWJ4LzJtaU0zcUtSZVpOUHR4Q2V5QVcrdnQvRkxIT1k3MlJWTTFnT0J2?=
 =?utf-8?B?UHhRb3hMSHk0QmNjMlRwRkFpdXFBeW16S29GSHNFRTJkUEdsM1BaZ3dUdktY?=
 =?utf-8?B?MC9ZbGxLVWkvaTNNNm4rc3pwL2RRc2plVkdMeEM4SktIR21teUY1NHJtTy9E?=
 =?utf-8?B?WlhzYzVoem5jcEp0UEdYUHdESXgwaEZHYmszZkR4ZzFLT1h5STZlek5tVGhK?=
 =?utf-8?B?TUJNRkprZGN1ZW5mcWRhQiszNEtyeHZkOFVJQ1Q3RnNySHZidXg4M2NaYlhR?=
 =?utf-8?B?UHQ4K0VLOW8ycnRXTElocHpKSEVGRUNlc1E4cGdFWjhKV21INUVJbTMxTmRH?=
 =?utf-8?B?VVZER215L210eTNsUEZHRllCYis4c0V5QmxJbC8vbnVpZWcwNDMwZlcwdC92?=
 =?utf-8?Q?DL51ji/LmYwQ0SFk=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F8B7CE7D337A224AA50BD9F049D6FD63@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	oTmrfWrHAOvjkYT80TB991Z0PFdgXCSGw6MdVb/OyTgiTeNKSWutXkMl/4IXtr314i2YHzyPseBOfkxwcAmJkpjET2n6xWpF3/zkZrB/DZwMmvhFVbMnfn3fGfzPMR1gqTe6Gsdhjsh0jwX9hgQKcfN/RKFATQMSeskaO0dR3+dRq03xqiXHYtRwlP6Ak1j97xCgIoB3R1OlVxm4RUks03T13uKzoyke98/acgQpRBcm36/HZqR/CRW0Ch35HugIZYmjCaoCDqFlDkMOwtkfOBeZqxDgCxOPNBSLXiK6obMCdyAEJL3G/0nLq9P6wu1qZHZ9p7zNKHfeaIY5kU3mQw==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ef00536-78ae-4da0-da49-08decaa10acc
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jun 2026 05:43:35.2817
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cJSswaIsPfpPshrjs0Xv37oc3PTwez8gPUyNTe94QMZR3NxmEGIa7KL1sF4qO9wd7SdSqiXVXobo+VYwUs2fsAQIYQAFPw+4G37Vnoa4bnQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR02MB8477
X-Proofpoint-ORIG-GUID: Zm5h6DEcRK4iuB8oI9XBER02QTTWMKNL
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE1MDA1NyBTYWx0ZWRfX/1QPfd6kx/MC
 7tRcv2C+ve+HqcF0WnVhnvXKgzBliLiZtb5Cno6dcBMeWhlcTCsJDe44ReNyre3om3/7Y//hyuk
 90gLk7juCyjYIwaECngh/xQ7ii6X55zBNMJdmOntr0Ngmn1VUGj1P8ZtPILOILZnE84il51ab4r
 Doy2FWr6HvWqe1XlZYxdoNr8WKGbFLI04x3UFDFzS36aGNRtX4sOjwFNYKNASGKDq+XhS63xUt6
 wLhC5eAnHXZpqUqwgUa58W2CX4Kw1Nm59P8LBWcL1VsURiFb36TXRu99jr4Q8f8aBp8zH5UPM0q
 e5vVP9VX5y1HsoyQMPIxYbaaEJjbQruRw5A9TsUoZxG5YJvczNl4wlR/nEcdNxeOQPy9NfK4Ebu
 zapn+ppxXwDVdBLqlcw4wyOzldFE0dbwqXGZZBpP9i7g9HykGhZ1kQI2tiuOx8lVXaWB8m/rLPB
 Et3aV13MBBxHeeEMlhw==
X-Authority-Analysis: v=2.4 cv=Zpjd7d7G c=1 sm=1 tr=0 ts=6a2f9109 cx=c_pps
 a=8ZeDDwZrcBwoztOOIup3VA==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=FelO9ux0wxsA:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VofLwUrZ8Iiv6rRUPXIb:22 a=_-M8LpHI31CeLmyZm6wg:22 a=20KFwNOVAAAA:8
 a=LPAjB-mvOJWVMoo5ePQA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE1MDA1NyBTYWx0ZWRfXwMerBkBK0vf6
 kNQr9ePcZxM6GIkKtx7G76+UwrW67+z722dclbiulB7wBStcdMVurq+bus+3A+stzuWizfUTuOr
 h+qyxKoZWRXLLQQqpcrgnVzlnyXye+U=
X-Proofpoint-GUID: Zm5h6DEcRK4iuB8oI9XBER02QTTWMKNL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-15_01,2026-06-12_03,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gMTIgSnVuIDIwMjYsIGF0IDQ6NTTigK9QTSwgQ29ybmVsaWEgSHVjayA8Y29odWNr
QHJlZGhhdC5jb20+IHdyb3RlOg0KPiANCj4gVGhhbmsgeW91IGZvciB0aGUgd3JpdGV1cCENCj4g
DQo+ICguLi4pDQo+IA0KPj4gSSBoYXZlIHRyaWVkIHRvIGtlZXAgdGhlIGNvbXBhcmlzb24gYWJv
dmUgbmV1dHJhbCwgYnV0IEVyaWMvQ29ybmVsaWEgY2FuDQo+PiBhZGQgbW9yZS4gSSBzZWUgcmVh
bCBtZXJpdCBpbiBbMl0ncyBzaW1wbGljaXR5IGFuZCBnZW5lcmFsaXphdGlvbi4gQnV0DQo+PiBm
b3IgWzFdLCBJIGxvdmUgYSBjb21tYW5kIGxpbmUgdGhhdCBsb29rcyBsaWtlOg0KPj4gLWNwdSBo
b3N0LGZlYXRfRFA9b2ZmLGZlYXRfQUVTPW9mZixmZWF0X1JBUz0wLjAsLi4uDQo+PiANCj4+IGlu
c3RlYWQgb2Y6DQo+PiAtY3B1IGhvc3QgXA0KPj4gICAgIFNZU1JFR19JRF9BQTY0SVNBUjBfRFA9
MCxcDQo+PiAgICAgU1lTUkVHX0lEX0FBNjRJU0FSMF9BRVM9MCxcDQo+PiAgICAgU1lTUkVHX0lE
X0FBNjRQRlIwX1JBUz0wLFwNCj4+ICAgICBTWVNSRUdfSURfQUE2NFBGUjFfUkFTX0ZSQUM9MCAN
Cj4+IA0KPj4gSSBoYXZlIG5vIHN0cm9uZyBwcmVmZXJlbmNlIG9uIHRoaXMgdG9waWMuIFRoZSBu
YW1lZCBDUFUgbW9kZWwgbGF5ZXIgaXMNCj4+IGluZGVwZW5kZW50IG9mIHdoaWNoZXZlciBjb252
ZW50aW9uIHdlIGNob29zZSBoZXJlLCBzbyBJJ2QgbGlrZSB0aGUNCj4+IGNvbW11bml0eSB0byBk
ZWNpZGUgd2hpY2ggZGlyZWN0aW9uIG1ha2VzIHRoZSBtb3N0IHNlbnNlIDopDQo+IA0KPiBJIHNl
ZSB0aGUgaHVtYW4tZnJpZW5kbGluZXNzIG9mIHByb3ZpZGluZyBwcm9wIG5hbWVzIGFzIGluIFsx
XSwgYnV0IEkNCj4gYWxzbyBzZWUgdGhlIGFkdmFudGFnZXMgb2YgZ2VuZXJhdGluZyBwcm9wZXJ0
aWVzIGF1dG9tYXRpY2FsbHkgZnJvbSB0aGUNCj4gQVJNIHNwZWNpZmljYXRpb24gaW4gWzJdLiBN
YXliZSB0aGVyZSdzIGEgd2F5IHRvIGdldCB0aGUgYmVzdCBvZiBib3RoDQo+IHdvcmxkcz8gQ2Fu
IHdlIGV4cG9zZSB0aGUgZmVhdF9YWFggcHJvcGVydGllcyB0byB1c2VycyBieSBtYXBwaW5nIHRo
ZW0NCj4gdG8gdGhlIHJlbGV2YW50IHJlZ2lzdGVycyByZXNwZWN0aXZlbHkgdGhlIGNvbWJpbmF0
aW9ucyBvZiB0aGVtIGFuZA0KPiBzdGlsbCBrZWVwIHRoZSByYXcgc3lzcmVncyBmb3IgdGhvc2Ug
Y2FzZXMgd2hlcmUgc29tZXRoaW5nIGRvZXMgbm90DQo+IG1hdGNoIHRvIGZlYXRfWFhYIChlLmcu
IHNvbWUgY2FjaGUgdmFsdWVzKSwgb3IganVzdCBhcyBhbiBhbHRlcm5hdGl2ZQ0KPiB3YXkgb2Yg
Y29uZmlndXJpbmcgdGhpbmdzPw0KDQpZZXMsIG1ha2VzIHNlbnNlLiBIb3cgYWJvdXQgU1lTUkVH
XyogZm9yIGV2ZXJ5IGZpZWxkIG5vbmV0aGVsZXNzDQp3cml0YWJsZSBvciBub3QuIFRoZW4gd2Ug
aW50cm9kdWNlIGZlYXRfWFhYIGluIGFuIGFub3RoZXIgZWZmb3J0IG9uIHRvcC4NCg0KPiBBbHNv
LCB3ZSd2ZSBtb3N0bHkgdGFsa2VkIGFib3V0IEtWTSBzbyBmYXIuIElmIHdlIGFsc28gY29uc2lk
ZXIgVENHLCBvcg0KPiBvdGhlciBoeXBlcnZpc29ycyBzdWNoIGFzIEhWRiwgSSdkIGJlIGluIGZh
dm91ciBvZiBncmFiYmluZyBkZWZpbml0aW9ucw0KPiBmcm9tIHRoZSBzcGVjLCBpbnN0ZWFkIG9m
IGZyb20gYSBzcGVjaWZpYyBrZXJuZWwuIChXZSBjYW4gc3RpbGwgY2hvb3NlDQo+IHRvIG1hdGNo
IHRoZSBMaW51eCBuYW1lcywgYnV0IHdlIHNob3VsZCBub3QgaGF2ZSB0by4pDQo+IA0KPiBUaGVy
ZSBhcmUgYWxzbyBzb21lIHByZS1leGlzdGluZyBwcm9wZXJ0aWVzIGZvciBjcHVzOyBjYW4gd2Ug
ZXhwcmVzcw0KPiB0aGVtIHZpYSB0aGUgbmV3IGludGVyZmFjZXMsIG9yIGRvIHdlIHdhbnQgdG8g
ZGVwcmVjYXRlIHRoZW0sIG9ubHkNCj4ga2VlcGluZyB0aG9zZSB0aGF0IGRvIG5vdCBtYXRjaCB0
byBoYXJkd2FyZSwgYnV0IHRvIGFjY2VsZXJhdG9yDQo+IGltcGxlbWVudGF0aW9uIGRldGFpbHM/
DQoNCg0KUHJlLWV4aXN0aW5nIHByb3BlcnRpZXMgYmFja2VkIGJ5IGNwdS0+cHJvcF88cHJvcD4g
bXVzdCBiZSBrZXB0Lg0KDQpQcm9wZXJ0eSBsaWtlIOKAmXN2ZeKAmSwgd2hpY2ggaXMgbm90IGJh
Y2tlZCBieSBhbnkgcHJvcF9zdmUgaXMganVzdCBhbm90aGVyDQpuYW1lIGZvciBTWVNSRUdfLi4u
X1NWRSAgb3IgZmVhdF9TVkUuIFdoaWxlIOKAmHBhdXRo4oCZIHdoaWNoIGlzIGJhY2tlZA0KYnkg
Y3B1LT5wcm9wX3BhdXRoLCBhbmQgaGFzIG5vIGVxdWl2YWxlbnQgU1lTUkVHXy4uLl8gb3IgZmVh
dF/igKYuDQoNCldhcm0gUmVnYXJkcywNCktodXNoaXQNCg0K
