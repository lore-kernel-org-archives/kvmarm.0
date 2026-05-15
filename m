Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D44773FD946
	for <kvmarm@lists.linux.dev>; Fri, 15 May 2026 15:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778859399; cv=fail; b=eDamxoXNedH3UikKfr80amh2H6qAzza5km1PvC0bkm4B8Skv86sY8eIufjjHCynEpkErleIjf7n0PBEWXKWqOW+iyAvcZfJ3LIdpfdMhPdjE/oh2CjRnJcINT4rs4+giq5QXy5Kr5hxhlGS3E343g/4sTUPFPb0jw3GJUvoA7xk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778859399; c=relaxed/simple;
	bh=9IroNRzxPWFXkF2Nxx9qh3lkAUnHu9Zu1Vd1WYPy8DY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=etHYFKUqGSJLHVCIiwbNdWCffKj1xZhUgQm7VgRLnTMwpnSe4I7MiePjqZek3FMqgBpg006gXJbrSRWFU4LjWzkQ8LEco01qjWvrNe+53iYT5/8s+0BgU9vOblfHBGEewVHAuXu87GQlN3p0vSoGBDGrGt+Q1pJ5NxkVa0SV8PA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=bclVBR8G; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=wWUEwilr; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="bclVBR8G";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="wWUEwilr"
Received: from pps.filterd (m0127843.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64F9rdcv108475;
	Fri, 15 May 2026 08:36:20 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=9IroNRzxPWFXkF2Nxx9qh3lkAUnHu9Zu1Vd1WYPy8
	DY=; b=bclVBR8GsMWQ3NppcFzxklraOQmWq2p1hjsNjcc1vYCzfmNrJUlK+E1bP
	5kWIV4NiygFYkBKVRiMosXdadTGnufKuhkh4C8eNwwDzpqK15JXHaYMPU+twTF+u
	E7H8Z380OgDom1up0RZKVb4E6wsmSQjLv2G8RVD+czOD8dvZj7nGUbJ3ipRqaQTh
	zijjYjO/5x8qliWDqUYEGOhTSUMCxnSJSgbaqne0okiJPnbkY5piecpk5cExzKG7
	Unck34xpR2bemQpG+STubCkna2tLqDrSjFaO0rQlcRNRTF9mHLPDDVgxY40v1XaZ
	FcwWPmXi7jhXXJNrZkF4Y9JBEAunQ==
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11022113.outbound.protection.outlook.com [52.101.53.113])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4e5m222d8f-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 15 May 2026 08:36:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XJbEAmHSI/CYNYVLxm+u1dJxBjAdLVtF9skGFRvnQu49wH56K7ozqeysQCEngitzQ7jUbuabrIxgMrYRK5i2fA4XauR9CZP9wdrEh22xSdqhtD9TIWMcD5jN7oGlETUVBd3WGFv0tLgwTIrntsDZR9FAxyNX4wtqsYMJ6CzrLNmgfG1I/bFka8xg3KmUknzV2EICGUFA6QeZz7sWUZK7B7f6b7+YLfA7gUuYh/EKw70juFhLB5/wblqibZyjUtujLiZb8hB49gxrFtDr8pOYuGa1Nkqg1nlLQde4vTV+3jx+mpG/Gr+pVF9DiHPWcMID2m75zoSeAFqhTX+58Omy7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9IroNRzxPWFXkF2Nxx9qh3lkAUnHu9Zu1Vd1WYPy8DY=;
 b=HAvJ2oS2usAaIf1kG0W8oN0xVmRM8omJ2SHc4IShlIR89P1S41Pr9PQUhFcBjp4afWqfIB9keQX4cjLhdtmuCxQpHfGLpEQTCNpOsDLebajCgprCvqA/EoFw3SXOJSzBzHrOCNwlKexAFUbKQtgNmy7rtq6Xtsgelt5xDYL0Fz/LuxtgkDcPuBHIM39l5USXSP7HjBKO4g2iXOI3H9eO6Yk3XtxKY/BxhYee0gbgg6cX3RyWMIYdzvtjjVn7UKBmwIBI7bq0bbddG2ietM7WXzPerNOCCkvrlQsaRY5LnkFE0hjwSa2Q0gsYJqBSyK7WuKccBYUrAZNKBKbyclOcpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9IroNRzxPWFXkF2Nxx9qh3lkAUnHu9Zu1Vd1WYPy8DY=;
 b=wWUEwilrscGY5pKN2LvbCQtc0N1V4u76xwj2sVd9UBJ20UAYNeMfQwJHjBEB6UdSYAeAdoSm77Kmm54uuliux8/F1NDX4/TCH5CNFoBvtblGoXlpSJJpcxx1QOB2QXmBDKeDPPX4j9Iq5ZJrIaHvUbs1CLe75n2H6r0CGIi6qecfDvj/Cl9IzC+aYOngJkh74/ucAHjM3CRBwdzLAdRKtTC7nsUblgratll36Lb+7pR2uOH29KNGvcAsu+SaVckrHaRHrh7k6rcq6Kj0BT6TH363GhLST88pbkGtGSLPjsyTEjCTVXp1M0xXPOq3u8Kh9so/n2pGQN4hY5wZKeQtsw==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by LV3PR02MB10740.namprd02.prod.outlook.com (2603:10b6:408:285::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.25.19; Fri, 15 May
 2026 15:36:17 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%6]) with mapi id 15.21.0025.019; Fri, 15 May 2026
 15:36:17 +0000
From: Khushit Shah <khushit.shah@nutanix.com>
To: "eric.auger@redhat.com" <eric.auger@redhat.com>
CC: Shaju Abraham <shaju.abraham@nutanix.com>,
        "qemu-devel@nongnu.org"
	<qemu-devel@nongnu.org>,
        "qemu-arm@nongnu.org" <qemu-arm@nongnu.org>,
        "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
        "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>,
        "richard.henderson@linaro.org"
	<richard.henderson@linaro.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "sebott@redhat.com" <sebott@redhat.com>,
        "skolothumtho@nvidia.com"
	<skolothumtho@nvidia.com>,
        "philmd@linaro.org" <philmd@linaro.org>,
        "maz@kernel.org" <maz@kernel.org>,
        "oliver.upton@linux.dev"
	<oliver.upton@linux.dev>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        Prerna
 Saxena <prerna.saxena@nutanix.com>,
        Jon Kohler <jon@nutanix.com>, Jonathan
 Davies <jond@nutanix.com>
Subject: Re: [RFC PATCH v1 05/13] target/arm: named_cpu_model: replace FIELD
 macro with IDREG_FIELD
Thread-Topic: [RFC PATCH v1 05/13] target/arm: named_cpu_model: replace FIELD
 macro with IDREG_FIELD
Thread-Index: AQHc4vZXBdvgQOyd40yTWebWLHE5Y7YPOSWAgAACA4A=
Date: Fri, 15 May 2026 15:36:17 +0000
Message-ID: <A84C8759-6EF8-4DFA-B5C5-A4381022F81C@nutanix.com>
References: <20260513163356.3033159-1-shaju.abraham@nutanix.com>
 <20260513163356.3033159-6-shaju.abraham@nutanix.com>
 <2a1eb06f-1293-4d6a-8354-445891ba36ec@redhat.com>
In-Reply-To: <2a1eb06f-1293-4d6a-8354-445891ba36ec@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA2PR02MB7564:EE_|LV3PR02MB10740:EE_
x-ms-office365-filtering-correlation-id: 0659d51d-7ceb-40bc-373e-08deb297b4de
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|376014|366016|10070799003|1800799024|4143699003|56012099003|22082099003|18002099003|38070700021;
x-microsoft-antispam-message-info:
 EIvKK+5kadANl4AOMSlL3cXrvYvKP/MNgvl7HeyyYJdTBLl4Bpj0gVj6hhhq52401w5d8tjS6jhN4x7wXu0NCpTMdG0Dj0rSzN4WdkU1C9M0Q/7ZlITfd4ywk8qJvbQnKGxnZbWt/8ech6OzkWmD5XQfHLzzKHEHhLL5fBiqWXOr4qjMEz9u4p7bV5cMizUiCJOXddAw7gpU1XaTWz/hkJebNib86HT4XCG4rlav7iGmmelFFmF9ZhH8amuvh0oTT7tjv8NX0LfRI34guBQb9h+jpOf5VijRyLALUi3IcJzZMwjqKC7ZyUsSJATbeXv1x2fj5SVdkHJBY4VY2TDrmMxjoncVGKYrHRJrgdB6JXNJrgOd4XyJbDfxC5W5OTEtC04TNeEgwyZjNCRk0mgi6dwpcjzOQzZkYgvqF4bx0Aq6QZzidD8JQjXbT6hg0he+jbpeWBrDp3y1ljEcp8LE2fQzpNIpEAPz4VZKFoLt/lzdoZs5tV0oN7wc1kHK7PLOshT5LavH3IBm1ZyCDZR9mBU7xih20kTc/e7NbLaS1/uhEERqZxXjs6QjryAnoChXvPYIEwExyznZXkGe+o8HlIek9XKOP45PgTaqrBmmaeqUihJ3LeJNiGO+DsY3ngYAKHj7PKI5Munx/CVeWdRAoaot4cZA48+QsY3S1tzDl3HAEsmJoqD5htvnds/bR6iXBbuxlgSSQExuCIr7KYJrgB3fyKrd+Sad/JeQ3cV1IIDfj8ng2U3Zk7JBL4agfWuN
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(10070799003)(1800799024)(4143699003)(56012099003)(22082099003)(18002099003)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?cnI1ako3U05vaUxpYUFUVndrc3c1T1dnY2dHTDN1MVFyYlUvaHF4clJodTBH?=
 =?utf-8?B?ay85QW90aTFRNEpoSE02dFFjOUhPRXYxZE8vUzV0dWQwS0lXUUVKbFU1ZHVo?=
 =?utf-8?B?bWtkc1E5V0tXZG9YZlVZcVdjVnI2UnFOZ0hkWWg1S3ZtSlAySFJsbHB2N2xV?=
 =?utf-8?B?WmpMUGlGQlRIUzJXejZROXh5K1VoWVRIS2NJVjB6MlJrMGlHK1VIc29Qc0lv?=
 =?utf-8?B?RXNkM1JyUVpnQnZ2M2pDc0hkVEN1NHFTbUl4TU9sZ2FnSWpqK0IyT0lHOVV5?=
 =?utf-8?B?bzh4eU9ReDRha2xPRStYYzJFTmFHWmR6dEl6Q21jWkxsU2FDWWJ5eDlMM1ZQ?=
 =?utf-8?B?OHNsMnpPbTNaL0wrczFPaWY2Y1NIWHBsMzJ1ZG5lMjFuY0lUdmhtbmphZVZu?=
 =?utf-8?B?akkxSXE5d2VQTXNCeGcxd1NHL3IxWFZ1UENsWXlBVi9pWlkxdkRSUUFXZzR5?=
 =?utf-8?B?Zm5YZlc5ZE0zTUVhOTI1U0g3NHhXUFZpa2dEM0lpTWZ6S3Jnb3RBYjcvdy9F?=
 =?utf-8?B?UHJMV01mdWRJR1ovc0FOUCt5OGErdG95M0IxcnQ3WEsvczVxNkpNZFZtK3hk?=
 =?utf-8?B?L0lOTTlHV1pnbWNiVWw1Q3pnRVhGY3NUQWc1ZGNPcUQ5c1dsSG5BcytralVQ?=
 =?utf-8?B?Q2lQZU9ad3YxdXFKM0RZVjBYZ1ZjNmV5ZUNkbitIM21qZWE3ZTFUendqVTZL?=
 =?utf-8?B?RWN4dzJaNUV4V0VXdTZVbXI5OW4rbmFEemUzbGhFRkFhZDl3Y2xQL3NHZjV6?=
 =?utf-8?B?eXN4R3hnVlp1dWg1T2d5YkZUVytnUVdxNjJQbE5nVExqUGozMkU4R3NnKzFJ?=
 =?utf-8?B?RE5jdFZ3VWowck5CUVJUdjRmeDA5UDZNZm1lTUhwVHBjU3hUb3ZpcDZQKzZy?=
 =?utf-8?B?VTI5a01HNnhIWmZzUWpHUktzM3VxM2dHaThNK3RsdXI2WE4wMWZuSTBBcThZ?=
 =?utf-8?B?RGFCS1dWd2ZCYkhONUhoS0JGNzVnMFJ2dXNwVU05QVBDdlBJRnRoUEh0NGZ0?=
 =?utf-8?B?YW0vMVpDTzhXczBXeG5VbmNML1RiK05XNkFSSmI0VnNpbm9vSnBQd0dLWXJM?=
 =?utf-8?B?ZGV6RGU2VE13d0pLeHJVQTBRSEpWUE9LSE1GTGhIdjZiQzRKd1k3Rll3SGJj?=
 =?utf-8?B?QkkxVDJyZzlzOEFkQ3BXQmNuS0EySUxvQnhJdU5mdzJGU1c4d01jc0VSMVg1?=
 =?utf-8?B?U1B6Kzh6ZmYwajhUVGtZN2FrNCt4UTBRbHloRTBBM0pOZzFLWWJnSzM0QjhP?=
 =?utf-8?B?NTFFWjdWRkY0SE93WFgyZExlSE03M1RtcGlmYVRUTDcwVHVwcVpiQU9qTllZ?=
 =?utf-8?B?UjRlY3dzREoyZUhkRHF3emZVbUZwVnliQWNiMTIyam5zOXQwZDB4WCsyQlJJ?=
 =?utf-8?B?VTMzQzY3VGZkUnZFT2EwYkk5cGtoOC9kemlMRzUxRkZvK2t0T2x0cThvMnV2?=
 =?utf-8?B?U1FPZU14UVM2ZkZUZXhhZ3BCcmhsemd6aUZSNHR4NDhxWUhJWS92aDNsVDV2?=
 =?utf-8?B?Mkg2OVgwZHZmeEsreHF3eFN0b1FNdXY2MDBqbEcrUU95OVJQVXlNbktoamN2?=
 =?utf-8?B?bUhNTEQ5SWZWcndyUTIxVHZMZkRRNFMvN1JvZkd0UEgyYUVrVkFzVC8rb2k3?=
 =?utf-8?B?M1ZHbHpROFFHRk9YUnVkOW1iRElkK1RkVlNPS1UwQUJ6dUlUbUFFaUJ6T1JS?=
 =?utf-8?B?VVd4MHdLa1d6Z0RXUGdqNUNCajVQcGtldTJEdU1LeDh3UjFJajZrWmVhRmtJ?=
 =?utf-8?B?Yk9EZWtoUFpMS3I1eXZqOUxmT2FVRzVtRVFYcVB5TDNVZkFMaUpqdGhWL3li?=
 =?utf-8?B?bEY3Qkc1TUFYT291YjZFK09Kd3JSbm9HTmF0dnFTbWozc3UxNGU4ZFNZTE14?=
 =?utf-8?B?L1ljZTk4VCswbkwzVmdzZnMzYnhiUDdLejFuMUpwY21DOGZCM0NYcGMva1lF?=
 =?utf-8?B?YjNXUnJBRlM3cFU1VElTTUdTSk9VSDM4RU5VTnJuV1FmSVpFaDRDYUJXa0FU?=
 =?utf-8?B?cTNRR21BbUhTeGVkaG5wM2tRdVhXUjFvMU1uRk9JY1hJd3A3UFBMSWZncTBa?=
 =?utf-8?B?OEJFRG1xcTVEdTFTTVFRZEtsODhkTHg4Y1FQRENscDlBMzFLMmpScUpxeldq?=
 =?utf-8?B?R1lGQmc5Y1ZTczJleGwxSVkxRDU1U2hEdkVjcjVHRldGMzQycFdxcngyM2xD?=
 =?utf-8?B?bHc5S3QvcGtsMDBUZzBITFQvbjFvdDY0WHlJOEFUOXQ2ZTVRekVnVDFNRzBV?=
 =?utf-8?B?SGNPQTMrcjF4RUpISnd0bVpTTDBWWUZWVEYwcllIT0J4TUIvbllNWWtyeFdN?=
 =?utf-8?B?N2NSM0owSmR6eWU0U3NOZ2x2ejc2aXVyUjJGUExBYno1WDVxWmhIUGFQMGpM?=
 =?utf-8?Q?vSeclez8361A1geXKxpFhBCgsF5hiv2Doz+Iy1Xsy2AhN?=
x-ms-exchange-antispam-messagedata-1: eSFMEEW4KNvhhViGZvG95mFyWOiHXFiZhIA=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B6E5728FD90D4046AB19FB20E24FE118@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	Xhjm2Fu4n0TWYSuGTXAxuAGvIR9+n9OuZDCmNY/Ptul/Vp4Krk6VLIC6c2A7cU9yi0TN2GSsJNBB/XRj7G7zMS4rcXeZMV261oria+lZIBMlPvcamJ8+7aDL04be7U2Jh3TM0x8jWxLjJ3qfr9onEeq0KK0e/sdbpBM5+0Vtq6uunRCyQ7/VjbKbKZS07OZRRofE4yryr6R2IyZ0rAwJsDsofIV89Q+MfzeMGTd1tuacfT/oCKKV+HA07fJ+itgq/QdkMAuePU9g/BYTyZvlwDRmcam8ql6UQcM6xBd1V99mEv93ndIYzUo+HJ5jkW76SPPCBMO2SVFOCb2o4sGt0g==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0659d51d-7ceb-40bc-373e-08deb297b4de
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 May 2026 15:36:17.7034
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: U+0YvA0o8bTrBiHcmsGFwMu/f+SEj/GYA1baS6Iyb8b6lfa/uLUz+w9lKmXSsiJKqIjPRYDs5dZFVRzOGBMyaYzTjmOUDrS9lr+02PPQneE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR02MB10740
X-Proofpoint-GUID: 7j9ttwW89twN9AOYeWQHNId-Y59nIZ2j
X-Proofpoint-ORIG-GUID: 7j9ttwW89twN9AOYeWQHNId-Y59nIZ2j
X-Authority-Analysis: v=2.4 cv=LpCiDHdc c=1 sm=1 tr=0 ts=6a073d74 cx=c_pps
 a=opNks6lJvPUjoR/Ci7CsCA==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=NGcC8JguVDcA:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VofLwUrZ8Iiv6rRUPXIb:22 a=dEe9Ve2bX-KnNSUMM2s9:22 a=20KFwNOVAAAA:8
 a=XUMKaskqzVv-C7TANUwA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTE1MDE1OSBTYWx0ZWRfXwBV3SAbiwMSE
 hvqmEbG7qFkIdrhepWhzGsK0w+JoIjiFYIrKLysG+FamBuYdp414Xmh5/9bQq89fGbZJySqYV47
 OW/HAIRIjfQatzEBF0qK1HsuLUMDK2NvPmu/pMzOjfc03kdWHJ55h1TW2ITbXWR0Ptc2Mj9j/+6
 RH9fJKi1gv7+r6Mdy7KNTjSTHGeaqUsOhTm1y5jh9fMSFB8rZ4mXupRXamRCqqRF8JMXBjUI88T
 NzPDSBCk/Qr7T1OVNdcusDhEODlgoh7vf41UMb/oku4qAnMiW/bBeLnZlRZx5aEmsss0u/YuxB5
 NbiChPm36kM8Sblnk8wWlsP+q7WgWD+k3MIxwyYegHeQlw6k/LHV+b++hyJ7/uHlmP7rWSD9snk
 YAiRAfqNJxBHGn4dHZw6R+jinTma+0TtW3Ja4YBoRP6udo5xm0L9D9wyAWhvDmhVYI76dWL5hrL
 lqXxVxYN3mnRDCGvLdg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-15_03,2026-05-15_01,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gMTUgTWF5IDIwMjYsIGF0IDg6NTjigK9QTSwgRXJpYyBBdWdlciA8ZXJpYy5hdWdl
ckByZWRoYXQuY29tPiB3cm90ZToNCj4gDQo+IE1JRFJfRUwxIGlzIGFsc28gZGVzY3JpYmVkIGlu
IA0KPiANCj4gdGFyZ2V0L2FybS9jcHUtaWRyZWdzLmguaW5jIA0KPiBzbyBpdCBjb3VsZCBiZSBy
ZW1vdmVkIEkgZ3Vlc3MuIFBsZWFzZSBjaGVjayBvdGhlcnMNCg0KSSBkbyBub3Qgc2VlIE1JRFJf
RUwxIGluIGNwdS5oLCBib3RoIE1JRFIgYW5kIFJFVklEUiBhcmUNCm1haW50YWluZWQgc2VwYXJh
dGVseSBpbiBBcmNoQ1BVIHN0cnVjdCBhbmQgYXJlIG5vdCBpbiBjcHUuaXNhci0+aWRyZWdzW10g
KG9yIGlzIGR1cGxpY2F0ZWQpLg0KDQpXYXJtIFJlZ2FyZHMsIA0KS2h1c2hpdA==
