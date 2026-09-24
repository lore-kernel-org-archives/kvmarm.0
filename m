Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52A8E41E6C5
	for <kvmarm@lists.linux.dev>; Thu, 24 Sep 2026 10:21:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790245304; cv=fail; b=Vkrd3q4xukgE4AuqGKaF4pkCrpyIVbEVl4p2WI2/07WqkNs078imx7d52BvR3iAHLt7rPazXUYdzb6cBRK4ZLbZHIQQTeBtcBVtbT9Br/RBoFem4AGCCPgztHbZXj74Yt9yZCeLKzzw4ej729eY/haD2/eNZyTIRYeAZsG8V3CQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790245304; c=relaxed/simple;
	bh=+PaW4lmJA/1xX2G0IBkC2d/e//lC0QKTGtLNz6ZFVXU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=eRkB+Mn5GPZEgUSU9CgjvChGbb1D5xVnMDdyin5qSmbkkL6HSE2bO7ADGKRn9zm1z/TZF/5ibpDPyGzudb23YcYCHIgPG+GEP51a4jFYlY+O6lZ7CQBX4Tx0+U7XFc+xH0ELZFLRTJvwaRQOuET2tMae73dQJjYQDEK/rwT4/m4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=mKI7E3wA; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=Ih/DzDQU; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="mKI7E3wA";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="Ih/DzDQU"
Received: from pps.filterd (m0127838.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68O9Guc21712516;
	Thu, 24 Sep 2026 03:21:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=+PaW4lmJA/1xX2G0IBkC2d/e//lC0QKTGtLNz6ZFV
	XU=; b=mKI7E3wAzQ7Q/Dz5isa8nfcMBZ+Xz13rhFf89pY453uH2WWTli43226LV
	QOPvYVIucBNMP8OJJpUw1Sx6l4tdjPtC22EK4o3tJ+t2l6tEla2gKwsNfRVr7yXu
	vvBwtJ4qHpK5nwj1jA3okCvRCvbiZAa5Tq+qbIznWor1haHWY9cWoQRJHI4GUSbz
	3AJuH5aouqfkG/olD84wAaHPYPYQBHU96MWvsezDTmtD0tgJg2VMreuCvIycb8oE
	38n7oxbA3+DabfLaOLc7daIpvpWA/YGth09zkR77tH5Tb1BFWNK7/p9VX62BaV8Y
	AGV3NTtQMhfSJjhT5C6NEwPC66f1A==
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11020099.outbound.protection.outlook.com [52.101.193.99])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 4gw13br4pm-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 24 Sep 2026 03:21:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AQYicDZ4UdTQBwSsfSXkBmb5tbLzzyWSIA29lYw8SSBiO+M22D9lx6ZRbdLB7GXWGesq5nSCyeSu6OJ8xkzAiggmEMySWWU/pAofC+/TgxPFi408MjlEp3IZFe53CQgiC2HDRQ+euSHx7ppUjCZML1x083aD+PSt02CE9+Ul+a+QNlYukP9NxYemNddhOmbPebaMAU9zh3pQN0MaTN7oXDlhS+l7I+TT1SVwNQJHcmbSjJqc9zkPus+JIuXifTQRVDMJt/KIuGNgFm5aDc8M6djY/4ZcY3Fyu6G239OzVoswgTFFcn+xVB4EYJF35M5W8ZzASBlifgmcf6lAYdznbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+PaW4lmJA/1xX2G0IBkC2d/e//lC0QKTGtLNz6ZFVXU=;
 b=Tm0J71sra8+mcInPclj4Xyj3vFUrxYHCJUZ+lyUoSKlqVy0R+8OQi3kY5p6+r121DeWMw6zylEDGUcEX4091dQIFlHWWlwqthcbBwjofH/gI9du7LJpZmKHbXv+EvCVVvRm0qZRDgSDLmNqVZhKDJR44ynWmk58TQH3AbtJrR13BZq3y7r+DovL+FkfoFnM2uNQkGhezWVK13EW1zau/nMGEi90LwozxLkHVBFyFYjtOe4t6S/l5bbJgQGHt4UiyyOJmcCaFi7r5VAMPbVq5Ii8jFHhl4N9VGnGb9sY8FQ9XtIaJ5ljpVf/+gVmHuyz/sBoGr9E3sy4IzxLBeFDn/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+PaW4lmJA/1xX2G0IBkC2d/e//lC0QKTGtLNz6ZFVXU=;
 b=Ih/DzDQUI4b9K22CL+y8FMl8dDwx1FaXqXGBBWjVobauGmR/E4gsdzBX14bqqjbjnRpWy+Z6LAzQO//ihObUxeP4ZEAKUgVX8SYMxN7anYbJLB9IaaV/tvjATT50NsC9mYjXWvFmui6rxIBDG1u7rV8JY9gzg41L+8D7ZIxN24i0Y0yodBb8/RjZwCZo4NrhMgQmGjS49njGC5cXmnypfV0r/Fc4fXdp/of4tR1IHHLkWd2t8btc8Tw5fdez1+TOptALiTSkhTPqGRxzzK3+rEcUTH65Gb2IffACC0cHQCerRaBV96k2XB2j/S7zREpxJwjsNu8t/aJklmC2fQOXog==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by SA5PR02MB11265.namprd02.prod.outlook.com (2603:10b6:806:476::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.18; Thu, 24 Sep
 2026 10:21:32 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%5]) with mapi id 15.21.0451.014; Thu, 24 Sep 2026
 10:21:31 +0000
From: Khushit Shah <khushit.shah@nutanix.com>
To: "eric.auger@redhat.com" <eric.auger@redhat.com>
CC: "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "qemu-arm@nongnu.org"
	<qemu-arm@nongnu.org>,
        "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>,
        "richard.henderson@linaro.org"
	<richard.henderson@linaro.org>,
        "maz@kernel.org" <maz@kernel.org>,
        "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
        "berrange@redhat.com"
	<berrange@redhat.com>,
        "abologna@redhat.com" <abologna@redhat.com>,
        "jdenemar@redhat.com" <jdenemar@redhat.com>,
        "gshan@redhat.com"
	<gshan@redhat.com>,
        "skolothumtho@nvidia.com" <skolothumtho@nvidia.com>,
        "sebott@redhat.com" <sebott@redhat.com>,
        "armbru@redhat.com"
	<armbru@redhat.com>,
        "philmd@linaro.org" <philmd@linaro.org>,
        "yangjinqian1@huawei.com" <yangjinqian1@huawei.com>,
        Shaju Abraham
	<shaju.abraham@nutanix.com>,
        Mark Cave-Ayland <mark.caveayland@nutanix.com>,
        "ping@khushitshah.com" <ping@khushitshah.com>,
        Sandesh Patel
	<sandesh.patel@nutanix.com>
Subject: Re: [RFC PATCH v4 08/25] target/arm/kvm: handle writeback for special
 ID register fields
Thread-Topic: [RFC PATCH v4 08/25] target/arm/kvm: handle writeback for
 special ID register fields
Thread-Index: AQHdScVnVa3Hz5ai9EyoEFthTgDDig==
Date: Thu, 24 Sep 2026 10:21:31 +0000
Message-ID: <C220B122-8B4A-43DF-A665-AF1B9DCE3734@nutanix.com>
References: <20260921123249.1708067-1-khushit.shah@nutanix.com>
 <20260921123249.1708067-9-khushit.shah@nutanix.com>
 <aabcb61b-8341-423f-b113-e7ab2b34c2ac@redhat.com>
In-Reply-To: <aabcb61b-8341-423f-b113-e7ab2b34c2ac@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA2PR02MB7564:EE_|SA5PR02MB11265:EE_
x-ms-office365-filtering-correlation-id: 7b969c4b-9202-412a-4a45-08df1a259a8f
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|7416014|23010399003|366016|1800799024|38070700021|4143699003|10067099003|56012099006|18002099003|22082099003;
x-microsoft-antispam-message-info:
 rXMPz33Vkeq0q6+cms785WbyEutIJu2KC/vw86aZPseqV/muzvqnK6JmpPr8Byja5JV8dZBezO5T0IM57WdSnWn8CGv8c1Abd+9Z5JQFhUfW7H8ICqj0uLB3RGZgm6MStag5l1JtJzdNBA2UgKL5/dY4GKFBhcAOd1mYW5Xi97DlvdEJ2lMWsY7TTO+mmXtiWPu9dRtjmu1VHumpelvl82om4VKqbb9HFC1nyyiasccJf6cY6nU0BL+iInmnPMmWlQLAwzbwcocqAmCy/jY73xabMnUBSjGetiWklA1qPBPYqm99sMiFGQnuix9kFHVVYMvDHR1qAzvDI33pnZspK5rYVaDFzsoujZxVPoJbtf683SBOrD3kwInX069ZRjAbZ1gmg3bTu37LDNlIvXfTucXlVlcCQWhSTwkWliQs/tTIB8DdYP99PsDD0R+uMYdzBjvOrSAZ9Psv8hAZaClTuefnKdpdSc1fiYOVlW+8+LyGMB3a7dLTZ6IuqS24M0d8TNI1skdAeoycuqZV7ClzCxkvJggktfWtHqDCLBcnDP8h4Sxhoqc4axAof5HjVMHMvEI9g0YC4CXVCY6CQu7LUkBPoevHhFYQlRFJxgMPykb4SbtllsTY0iW2U0Feee4sShlHtmV9wXAIu1OjTHsTO1/ukIHqO2xkIU5AqTcocTVdNkwSiyqz2U9H9DO7and4rRaSry8/vnxyLn4WLBPS6A==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(366016)(1800799024)(38070700021)(4143699003)(10067099003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?bEpkMytKQnlGSVpLdis2dmsxaTNaRG1FV0s3dUVyRnd3dC82QmZLZzdiS0xZ?=
 =?utf-8?B?OWpaNGNkaEhpc0JnZW90cWVOdldIKzh2UHl1TzZ3TEc2WDFZQzY1Rm1Ob2pN?=
 =?utf-8?B?R2h0bm5WSlpFZW8vdW1IczR3MlhINWdNS2R6ZkU2YlFGaE1KamJYYmwwV2VH?=
 =?utf-8?B?am9sT0QvakJqbnNQbDBuMnJjWUNyNm9tRS8wMTQ0TGQ4TlhuajNxbmcvN1oy?=
 =?utf-8?B?c1k1ZTFkeXlhTEYrNHlyNTJPbDF4ckhJVVEvYjZVamgyMk9uWTd4MzRIRkdN?=
 =?utf-8?B?MVl5OVlSTy96K2lOQzZJRjBrUGZPZVBBbDVzY0RmeVlGdDNuT3lJTXRPTXZr?=
 =?utf-8?B?bHZRTnNBcXI5eXcvYkF4SER0aE1neW9kTVY0dWlDZ3poMkFmY1dCSVZIYVox?=
 =?utf-8?B?MDJzWjFFQUxjSlc2bE0rMmRtd2wvVCt4RnRHVjRmbUdsTXBheVB3UkNPRXFt?=
 =?utf-8?B?Y1NhWHFJKzhWS1JsbVlDUXYwOG0vaklIc0NCc0s3WW0xRGw0d2hKUTB0T00x?=
 =?utf-8?B?WFpSVVdjOGlTQU5XYk9LcGpXbWJCMzEyRE5scFNNWmhjUS9vRU92bXhySGJ6?=
 =?utf-8?B?R2FOMjhTYjdmMHhRWmIrL2s3MTc3a3pwbHZiWnI0UHdkQjJzWmVEVCticnFJ?=
 =?utf-8?B?TEg3NmJiQk9zWERJVzlxL2dXZUhIU2RyUktWMGhTYUxDRE0rMFpjZmpkUUJV?=
 =?utf-8?B?aWRCSzZlTk5sVmYvQ3lhVjJod3JRMW5VVEtjV0YxcUIyZVM1RGV1OStCZDFO?=
 =?utf-8?B?ZjBqdmRlZW1uZFJDZW5vR2tEUDJBU0N6SE45cE1saHNaLzJkZWVzUDhGZmJ6?=
 =?utf-8?B?YWRPZmNvYmtJRkVQUEsrQkNyMGRZa2RZU0VCdXFTakFDSEJjMXB5RVpmbW1z?=
 =?utf-8?B?UGRvOU4wWW0xR1NWR0txTllEamFpRE5nbWpsVTZDNnZzQitKTzhFcFU3MzlQ?=
 =?utf-8?B?MC9GakQ3MjRhRWVYMlIvWUZuRnBhd0lTM0tnYXJsaVdMS1BpUHFnTDBoYUhB?=
 =?utf-8?B?dmIvVTMvUFJKZ0pFejZjM2ExVzYydDZDZnRYckdLd00rZUdtT1FtZFBZYU1C?=
 =?utf-8?B?a0l2VFd0TFFXWU93dkk5K3V6OE1MV2tDaEI4Vkp2UVlNc1A2K2ZnOTJkOUlV?=
 =?utf-8?B?ZXdUKzcyWHI0UnpMb0NWajRCeTRmL2pKOXpQWjVITzRiWjcvSS9JVDVOd2p2?=
 =?utf-8?B?OVVlbEJGd09oS0VnQUxIeVVOaEhmbUNZbCtxOVE3WldkcS9sUTVXQzQ0aXgz?=
 =?utf-8?B?K2J3UzZoQjZiTlh6SFZydzFIWndXdmplMWxkektBRjVRSzVjRjBOaW4rT1Vo?=
 =?utf-8?B?Unp3Tnl5RDhmbCtSRHJIVHJ6d3dlNHJld2NiMXlTQ3E4b1dRNDVvT09zR1Fv?=
 =?utf-8?B?NGxWK3FlUTlGaURzcXViZjlrRjQ3aTNWckhrdERKeFRtdWwvUkRrdGZYNTNy?=
 =?utf-8?B?Y0FUbkJoaW82ZHFhV1NxN3RNTmdyeUxieHA5TG1lbXZ6VFVHZHlKdHJoeU0z?=
 =?utf-8?B?QmpjN2hiOUZUeVlWQUlTbTN6WDUrdUZ1ZWl5L09IdmJ0MnprSEcrRGRiUjhR?=
 =?utf-8?B?RHZKdG9kZzdQNlNHQnVnd3BFOG1CVWJRUFowT3VhQVIrd1o4OU9hRk1uRFJh?=
 =?utf-8?B?SzN4WWsrRmREc0dDdncwNldseW5mMkZVbmpzSGp5Y0hldDhBNVBOY3RqelRy?=
 =?utf-8?B?a3lCVFhiTHBYUnBDc3lSTUN2Um9zL014VEVxdmUxbUh1WElOeVR3UExRb3Fh?=
 =?utf-8?B?WFB5bXEvTmRlTkt6cGI5OTlWNFp1RUhFQkluemVJa1NPcERoek1hVzUyalp0?=
 =?utf-8?B?R3pqRTcvNXBrckYzNkNNbC9sQjRmUXpQNk42aEJaZ0p2TTdBeVdHRVNzd0s5?=
 =?utf-8?B?amhDRDF1SUZlYldSb2Y1RmZycm85enF4M0llOUNpbmgveGNwRUQ2VTNJeGxF?=
 =?utf-8?B?cE15dzVrQjgxTWtRRnRWKzl1Qk40VUwzVkd6NVN4dEs2ZVM1eForSW0zcWR6?=
 =?utf-8?B?TFRDV2NNY0ZkUTRaK0JtQlo5TU1qbG9VcElERGdXNGI0Mk1ZTkJSbXlvSlAv?=
 =?utf-8?B?cTZZaCtZKzdoZFNKZGJLQ0E3NGZvVk4vRFNmNFRwb3ZVWTFienhBcTBSdHpr?=
 =?utf-8?B?bS81TkpXdU42cUNUWnBkWlJaQ0VQcGZRWmY2ZVlWcnNFSU1MclRoMnkxT09i?=
 =?utf-8?B?TXhLVGwyUENTenBMY2RQL3BPUmptaVVZT2xKUEpCTDVObXFlMHYrSFd4cEY0?=
 =?utf-8?B?MHJjVFVlMzRVdzFwQVc5N0tncnFCSlVKYjFwSDBMV1VYOSt6bGZGZE9DTktz?=
 =?utf-8?B?bUtmNWhEdmZsT3NWOXRjT0hUd1c0MjkvdGFZZG1PQlhnSnJwdHlhdTZXK0x0?=
 =?utf-8?Q?G+wzspd1lSIwY5TE=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <34124574CB87EB438A6F3373C11541C7@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	vkMGryKQ7GdaZQKSuIgzjC4o26GzLBwLlcIvM/oHfCQ6TUqxzSTc6b1LE+o6EvO3AtGq4F6nm0hKxwVxfUUwCro/hS9VUKqax/d/Q51KzlYyWW67Hri0cxk1S4Zfv/V2diiEyhGtNuN6NINvlySQ45Za2e61EUZBMLa4XFEPN/RjgSZKL2RIN7GGsSt0jONmPTA9QrBWB27AcAVM5f4advm+Hn6u9i80M0/28I9VknOL1TE4c/zECr/RovVeCzc5I8VK5JGVO/VPgfpsJcoZ+er9GF2XEaK0/kew64nS36c4iLx0z5A+0mZ8uBjA2kT8Aw+BNLnf/9g8D+MtacKDnQ==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b969c4b-9202-412a-4a45-08df1a259a8f
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Sep 2026 10:21:31.8542
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jezJRVPH8WRkWa4Am7NMSG/dND9aKRGK7oxQ4Pop/cP2AQchqAPHF8MaMQfFR34J+RhR3HkQi0zB/GLTCkPH0FrCRHdyETy2aqrtrLdn9Ig=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA5PR02MB11265
X-Authority-Analysis: v=2.4 cv=IKaXmQvG c=1 sm=1 tr=0 ts=6ab4f9ae cx=c_pps
 a=Yoik/vw0OvDn0K+F3zf8Kg==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VofLwUrZ8Iiv6rRUPXIb:22 a=1L6crL_YRTbalZ11mEUO:22 a=20KFwNOVAAAA:8
 a=BKwghRRMkP9E_hczCwwA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI0MDA0MyBTYWx0ZWRfX3WkbTVRViGOU
 SlxAuKJEQbwTFrTdQTAx5nHTq9bHnaka6hGhtdKFT+rNyfMMk7WYHC3A8kLXu2OSovPjfZnL4pp
 IzSXswoUrnedwN/XYr819Iq9H7Erkr8=
X-Proofpoint-GUID: h_YF60QxZHGch42XcBt2_gWXY33n_I_a
X-Proofpoint-ORIG-GUID: h_YF60QxZHGch42XcBt2_gWXY33n_I_a
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI0MDA0MyBTYWx0ZWRfXyjGL04nJCWNw
 nOekIrUXB08cImuZvs7KklYnFB8/8Uu2O6IBy4QnpuB5HZZToCtq1MtG9BCUk+JIzS5JYf9g+Xd
 b4he4zu00dFof+Shrjm7iqV1QC6BcfjuCwcgKMN9U0yPlMzAQaaiOzzCtaaliCG0UDuc2DEtRgV
 R4pMZOy6zc0utZ15nyWQ86T7QSmTItIc+VFPKU4UjJqEf57RIk+VzmaKwnA6qTHg3P7rvayv8uT
 oKdpyDX6c38bqxcVka0S6BUfW8dcUgJhdclvp+TCxT95kq3Axcu30wNQ4MzMTdbo2IufGc88RaR
 ah+7aA6VwbFz5+jsACZF0+opZROPultExh1puErsCxYjbhaGTbmrJbcAZcV5uXLcpXHFyqn/WHy
 KyyYyPlnlkdcYZRRvvfA/xgqN5PLLI3GMcruz4S86Z4BiMDyZpNX3/dPWoGnHgZnNp/v2NunfkK
 xBBylEcLDUB6iy+Mt7g==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-24_02,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gMjQgU2VwIDIwMjYsIGF0IDM6MjfigK9QTSwgRXJpYyBBdWdlciA8ZXJpYy5hdWdl
ckByZWRoYXQuY29tPiB3cm90ZToNCj4gDQo+IHY5IGhhcyBjaGFuZ2VkIHRoZSB3YXkgbmV3IGZp
ZWxkIHZhbHVlcyBhcmUgc3RvcmVkLiB3cml0YWJsZSBmaWVsZCBwcm9wcw0KPiBhbmQgbm9uIHdy
aXRhYmxlIGZpZWxkIHByb3BzIGNvdWxkIGhhdmUgZGlmZmVyZW50IHNldHRlcnMuIEEgbm9uDQo+
IHdyaXRhYmxlIGZpZWxkIHNldHRlciBqdXN0IG5lZWRzIHRvIGNoZWNrIHRoZSBuZXcgdmFsdWUg
aXMgdGhlIHNhbWUgYXMNCj4gdGhlIGN1cnJlbnQgaG9zdCB2YWx1ZS4gTm8gbmVlZCB0byByZWNv
cmQgdGhlIG5ldyB2YWx1ZSBpbiB0aGUgaGFzaHRhYmxlDQo+IGZvciBmdXJ0aGVyIGNvbW1pdG1l
bnQuDQoNCkhvdyB3aWxsIHRoYXQgd29yaz8gYXMgYmFzZWQgb24gY2VydGFpbiB2Q1BVIGluaXQg
b3B0aW9ucywgbm9uLXdyaXRhYmxlIGZpZWxkcyB3aWxsIGNoYW5nZeKApiByaWdodD8NCg0KV2Fy
bSBSZWdhcmRzLA0KS2h1c2hpdA==
