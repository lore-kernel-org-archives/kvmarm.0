Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14B2438A726
	for <kvmarm@lists.linux.dev>; Fri, 15 May 2026 15:32:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778859135; cv=fail; b=R84fcSvgN50m4TAWMH2smzSbJqQK7SOjeEXT7/P60jn+j0BW3RIIKaIDBn/6ljn+wr6KGmSR7rI+qaUM71eV6Sl8PmRX168tl8UZY9IP/4p0U0MMoyGzMq2Z815BMjnILSTSa0V5aRjRH5jTabdBeYKg8yXsPFkNd4d7a1Hn8UQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778859135; c=relaxed/simple;
	bh=58HaMDrnECgGUKA0w8Ow7djMvZQLPnev+qGenNubqIk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=aK9Qx/AfHCsDM9ayOSOTCm9n3HLX06jdXqxGSWUpYdXWki9+i9W01IKzQfs0DS5VvZ83ajpc5NuqcFeNsYkrfK6UPZZmFMio6Ui/hKlvID4yAT9MH78pO5Uv5wx4fd8sKpUSPQeCOy/Dobuw83V3xz7ObF0as3Nd0GyMpK4iNrU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=L/6c1m0b; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=Sqh+0jo0; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="L/6c1m0b";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="Sqh+0jo0"
Received: from pps.filterd (m0127840.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64FDqMMn763417;
	Fri, 15 May 2026 08:31:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=58HaMDrnECgGUKA0w8Ow7djMvZQLPnev+qGenNubq
	Ik=; b=L/6c1m0beDo+mvNFKyWebAGp9BYasgP2njKSlnn+82BfRS2aCRMdGLlPO
	IScBLy09Yl8tKBS13wV0DGpFwNmYnVKKcIz5mXksgbeIawRc8l2fo65O7B68swxu
	oaUBERETmZNJpThnwBVPigHdjpXHg1IGpuarJJ15fVzZzTSn7qyWGRMPp8xnq/hA
	fvZe3qA9D6hlbYSB/00uyz9eeyAn+cIVVr9hBFxR5vJDSsVIaMGJXjDDyJoU4QLK
	4JB5XsdZLgbQk/DYG5syqES6DXN1POzQd7xaxUI1FXCcMV9/BG8V99D8/a0tVtjh
	NWP7bl+qNN290IS/d1rnzQ5GSTQ2Q==
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11021136.outbound.protection.outlook.com [40.93.194.136])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 4e5m22abyf-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 15 May 2026 08:31:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ldpuUN+X6oSwpsq1Pq92mBL+y5ecWa6J2+rfPi3JygaUfS7NQLXAI4zO8jj/jrxciDm2/8A8A8SrFis0MbeAbDN2KKskTFdmBEBHePMOSDIqhA+ieEv/qtONnIXJJXR6LzZ1zNyOQg09T/6Wku7jrfsRI+yzR9Etf+WTceHW9Yq+wRAnSgOGT0PJ8hfoiZgtpyCa2OQfk0vaR4jlImjdufQZBaWXLlctY43pWPZCAGDeQjsg+a50vg+sDBY3GcQXw05eoWha7yB0sNb8BY91XGDV2pr+ZC5IbjnDnZY6eBl0aM6L5t3i6josyLdh2OmHLYvhC5nxDpYg0NTZEH23rA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=58HaMDrnECgGUKA0w8Ow7djMvZQLPnev+qGenNubqIk=;
 b=uNpO2l69BbY3nHeLlqbwE/63Y7WtKnGnI7J5x4DKpJjWMueCXrgqiP8YX2RD8LImZzVQUM8DUDzJVwKA1tKwDKYLzayFJPxS4hoi26cJEX37c+hgM2f3Tri95lR+ORlYs4RL40Ju7aPCkpr2rj/Q5NhuFiLWH/67PlbRVg2oA3oOpTtYrYPUTJoge65nJwhOQoR74vUZhnFXWRA6SWKcIXAhXstjyGYaPQk+w9Rlq1zELZDba320+eUjK14iA13FdFhsG/f3IJKMkg4HIXV0THwJbS5/I3JYEnvagg8qmBAyecxeCm0c7IxVBQCBQzlVUwMYkVQ3iFSNIV46HjymUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=58HaMDrnECgGUKA0w8Ow7djMvZQLPnev+qGenNubqIk=;
 b=Sqh+0jo0MeS07ZMwJJp9DxiZrVijbxZRq4uQucdlmCZE7LEzugqrXr5KF/iyoXgGtpMruhNTDXc4mAJxKzngZyvmAnyefRAaQ3aTCBlQVn39qovFzz6x6GGAOV/718Cp6R0YKysWuYMfATWBt/qI1v1sdxx3fsplbzCRtmmk93a/sf9+/PSpo0lg5J3J48Z5Y7GYMN5+j2J63JSmrD6ZaruZpXimEPOaq3dqqZuMYZbwCAtnqObvr6R5AWdE5vc9xwSV/RViS8ET82AnQJp1H07nsSHYmd5CkyFsP9+kLW8rwmjsRZrEJsbVpVT/v0nZPNz+10ZlIVXgS3OFAsjPnw==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by CH3PR02MB9492.namprd02.prod.outlook.com (2603:10b6:610:123::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9913.11; Fri, 15 May
 2026 15:31:56 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%6]) with mapi id 15.21.0025.019; Fri, 15 May 2026
 15:31:56 +0000
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
Thread-Index: AQHc4vZXBdvgQOyd40yTWebWLHE5Y7YPOSWAgAAAzYA=
Date: Fri, 15 May 2026 15:31:56 +0000
Message-ID: <A5B7711D-32EE-4444-8966-D42346A5C410@nutanix.com>
References: <20260513163356.3033159-1-shaju.abraham@nutanix.com>
 <20260513163356.3033159-6-shaju.abraham@nutanix.com>
 <2a1eb06f-1293-4d6a-8354-445891ba36ec@redhat.com>
In-Reply-To: <2a1eb06f-1293-4d6a-8354-445891ba36ec@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA2PR02MB7564:EE_|CH3PR02MB9492:EE_
x-ms-office365-filtering-correlation-id: 390d4fba-4c90-40f6-09d1-08deb2971931
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|1800799024|376014|366016|4143699003|38070700021|18002099003|22082099003|56012099003;
x-microsoft-antispam-message-info:
 YsFRKrXmFyP4vbbCl8bZaL2IAC/ZkBvxeBnnTh1GedU9ChHfnUx6aXAoWhpuzc0GkswYL/v/baeAMnXTBJexhx7OjMQmmG6QwJYT0hv0DzzxvT9WXA7rUqWnaz1rNOrVw2doESft8bADSeQ45uCEfTaPCF1MOZOw0GNsFJLmIdvP5Zg2BXml5cuSea+w4+2Q2V5TDJ50JSNWuK3oEk6BN6W7+GgpMEQ2R5HBRByYGmKNuBZqHTlJb4cI3tBx1LgnDOGRQ/H49c2CM4L8oo+halu1thUWNJMJ1KitCo8AuAOOi+6RRfLoG/gkHg2Ith0ujxGr4ZbMYdX/Qf/fmnmRMTqU//1EFzDLRUdFU+0eXnUjljt9Y7MEDdcyJ+LIyBJxXIOH3h3Oiz4Rg4GnAQbJq2AT0EaqV80wjmCizI9IRHk+J79LKKVfuW+vkzOknzZ7l6ujVQFlaxzZ0fjWrbia185E3yLGh4ODO3NDUfRsopUVnE7lIZqKb9toicywkzFrQVAdFdZewWb34R7lZ8VgjN7HAmnxEi4hU35ZUzcXy04mQxeE9SSun9fepzZOqA2avdLhSzXVtAuxiACA2ojIjKEue1BXr6yIowjhf/CJvP+E8fNPHcNRw8kaacK9jDjvmJ9iJD+0D2YqabC6UGD8GP5xcFD/2Rl2wTzS3UlEaP0OfcybvxDJ3HPPO8IsTcJq7u3L0xPXpqdIrPQhj1odxD9fBa4Z03LjtDgFG+Md+/GBRHE8YRT5j0SVAb0+kzJC
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016)(4143699003)(38070700021)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?M1MyKzdqYVczK3NGT0p4UTgraW9lVEZSMWJoVFl0cjQweEpaeGtQNEYwNzB1?=
 =?utf-8?B?R0JGWC9YdEF1R1RYQjQyRG1zcTI4VFJydVZuZ1dnOTNvK3NUQVN3TVN1ZlhE?=
 =?utf-8?B?eSs4L2U0YjRHNUxrZVp2Y3lOdFU0WWNvTVlpOVB0Ti9OL3ZqZlQwRnB2WUw1?=
 =?utf-8?B?akErT1k2VmN2djl3ZVZMOERGcHhQU0VESkF0TGRUQ1JScmlHT1FsZ1h4RDNs?=
 =?utf-8?B?ZjA1bmJCRnNvTmRUUmpSVlpleU9YMXVkN25PckxVSXlJb3RPanh3ZXFmbXRi?=
 =?utf-8?B?K0VQeWJtclE5OG1ka2NqcDdObWpsbHpzQUdjbHZmejZpcXZkMFJUTXhkdjIr?=
 =?utf-8?B?UHF0cFh1UUFka3dpbzYwejhJdWRtdHFVbXYwb0FnTjB5Z3c3NHA0YzZHV2Jz?=
 =?utf-8?B?L0JBc21ZUE1mK0RNTXU0eGFqMkpJcDFTZXpWbTY0aXgzNGp5M0RZZFRZUWZw?=
 =?utf-8?B?ejRQc1FaQWM0RXdyWVVqR2puYkpoMWdSS3VTYnNzcTIreU5Ddis5d1ZwZDdP?=
 =?utf-8?B?VXV1emJpR3RKOUtrSjRxWDB2NEw5dktQUXAxbXRIcFU1NWM3ZUpubCtuTDZ1?=
 =?utf-8?B?bU1UYU1ScnpETlVkblNaNDdxcCtNUlp3ZWRRRjdmLzMydzdjNkFiK3FxMGtJ?=
 =?utf-8?B?cUpEVGhNZExGMENwY2l6WmM5NlNXQ2s3WUxWSWp2UWV1T21ZVWxMNHpsL3RG?=
 =?utf-8?B?TEFqRFZDOVZEYVBJTXJ2YVJMcEkyVG9mOVNkTEJ0dWxSdlBlVG5CK1g1c0VV?=
 =?utf-8?B?dWhYSEZxS0FKMUVnUXB4Y2V3NUNqN3pTVks2aFNYdGN5WTltaDZFTVkySDR5?=
 =?utf-8?B?M2RHajN5c3Y5bnlDL2xyQ29vQmM1aW9RcXlkd0VxMjVmY0xIanpIbHhjM0xz?=
 =?utf-8?B?Z2t6ZVVSakdRQ1lremtGT01JUHZ4dUo5cDdZdFdRdTlHdHBTMHhNVEpVQ2V0?=
 =?utf-8?B?cG5DZWMvUFRWUGhWYzZDZ3p4UWVmNXAwMURsbDlPMFpyNVpFL2tZQXdHdEZH?=
 =?utf-8?B?UkF2T2FwT3doakVRREs0bXFySlN4T3c2TWQrQWZySkNFa2VTbWJ5VFh1NWRi?=
 =?utf-8?B?NjRqU25hUHVzVUJ2eXVCZXFKQnA5V245RGhWT040Q0ppV1l2cWpYaUpzNFlX?=
 =?utf-8?B?eXowdWpiT1lCNjFqZ3R1Q2l3SzJ3dlovZ3FVMWxweWwwekdFZTdqOVNmYWxk?=
 =?utf-8?B?VTFReFU5QjRDcEh4Yllsdkx4cUpITjJUQXBsSlFHT29mOGo4V2ZEbngyNUlr?=
 =?utf-8?B?UkZoU3NMYlk5MlVCdWU0Y3k0aFNybm8vZEJ4K2N2L3ErQmpkeVR1Rzk0SVE5?=
 =?utf-8?B?eXZNV2ErN3NYZ1hERXlGSytkTWV6Q2R5ZkVLT2dVRUdNQWVUWjRLbFpXTGVj?=
 =?utf-8?B?bTVpSXJxYlB5VW9na3VXTmR6WHhYcUdkZ0ZCTHpuS0VGa0ZibTEwWFpUZm5G?=
 =?utf-8?B?aFBLZTMxcHpFUTBZNjFhclAvaDV2b0l0a0J4QXNXQWY3QkUwd2lGeGV6WEU1?=
 =?utf-8?B?Rk9JMkx2YW1LY2lkL1BOYXpvZ1BITy9EOXZxWkd1OVJSYS93SUg2emlNcWds?=
 =?utf-8?B?UkxoaU9sbHBnZkFHNzZ0RXBzWTdzVmVLcXF4TklIUDltZ0N0QVRSWjJqelFz?=
 =?utf-8?B?MnR4WThoK3BNYlVWK3ZWRDRCUFRMYmpqYkVoUENFQ2tBZ0RDeEFIcmF3eFVU?=
 =?utf-8?B?MXJoWHkxYW1Sb2lEc3hhTWRSdDN5NHZQa3BmNndBVjNiTVlGQjBtZ0pzRTYw?=
 =?utf-8?B?YWZHUi9STEYrRWpzdEFqWldVNDNpTnlXUkJxWG0yN0E1YUJYSW5YMVUyWGRW?=
 =?utf-8?B?OG44Z1F0OFJFaHpuVDhrc2ZIUFRobXd5dVdkakhvUHI4OHdraHZQdEEvSUJC?=
 =?utf-8?B?U2JNWUNhVDFHMFdHM25xT3NQTytOaDdnekRuZUNTM0xab3dVSHMvN09VaVla?=
 =?utf-8?B?VkRwSGV2WlVJaTVSTlR6Q0dTZExGTTNPc0g2dVZ4bkZ5akhqbUM0N2xSTjh0?=
 =?utf-8?B?VmdlTllCL2FQcnFqa29QNEtySGFTeVRudVY2N25iVmo0Y1c3akZXNDJ6TmIx?=
 =?utf-8?B?bmpXR0hLN2pXZWF1b0U5dmdid0xia054RzdlWUJJTWx3YndjZnZZN2twbGN2?=
 =?utf-8?B?WGE0cVJnV1hRekxZUWVLUFRYdTlCT3BuZzl2cFZIYSs1TmhhV2NGNWVpQUJp?=
 =?utf-8?B?WnV5WHV3R0RNYmdGWmdPenhVNTJnTnNsM3hEdW1YYmQ2bXlaZjZIZ0VoMHZZ?=
 =?utf-8?B?TUNBaW1XcVUvaTR4NlJBMXgxZnpZMTg3YnZWSkxLTFMwVHMwaDltanBYb1Jt?=
 =?utf-8?B?aWpYcllZUkF1eFBHMmM4TjJ3Sjd3WnVwa1JvdGljMjBRbjVUOTZ0MlI3OW1P?=
 =?utf-8?Q?00djUkD1dB8WGuM4=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3841F9B2797FAF4A9E6E4AEB0BF29D8C@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	Y2LSGCFM4c8nUlvbnUz1KaZXnfeJoBbPLUt6bRB74QW2mrBTPoj8QwjKCETm39wyTD5AkttZl8UIQwPgHy9iEZL2qYWD/M3+sRHT7j6jyd42rOGh0kpaJup9p67SFF74TFY8HXWlLvheyKUnxLp4czY94G2pPK40ubavoYwSMkGJEQcnv5AdG5Au5l2ADab0mspgykXTvUam0LbjXxm2nTP2eC8l5AE/4yK6z6fYtLrnrNm8HlMXc3yQSD5FXqXj5abjl7N8ILwHo4l+6UCtjDzG+Nva32y+gxg6ZwreN3i52Mt8gGMqbdyMGrEfz8czL8TjWmEDTWl0LO9zWazYWA==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 390d4fba-4c90-40f6-09d1-08deb2971931
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 May 2026 15:31:56.5401
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UZDjP5qhCxCg8RgH5amSMo3MA6veRVgSzq9tfsF094n93i7lgPtjP+T/vCtJCWJFoRmFlh5NUlJQKmSyDfWlWjohEakCq3SheGvIOJz/A1M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR02MB9492
X-Authority-Analysis: v=2.4 cv=Eff4hvmC c=1 sm=1 tr=0 ts=6a073c6e cx=c_pps
 a=iP8LO1GmXzZBnhZ97s6OmA==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=NGcC8JguVDcA:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VofLwUrZ8Iiv6rRUPXIb:22 a=_-M8LpHI31CeLmyZm6wg:22 a=20KFwNOVAAAA:8
 a=1DJUW0HPbwB5hM-gDkIA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: L4CNdtrN4J1-K5k9SXwhMZsrbJuKump5
X-Proofpoint-GUID: L4CNdtrN4J1-K5k9SXwhMZsrbJuKump5
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTE1MDE1OCBTYWx0ZWRfX6vJ5tsMUUYyd
 qyh0P9ZOFDhrrph8vLyakISNscvwcJ1MLM6wgU35rWE3vXoMKWKuoy4G+lIvubghT7ADgoLYb5k
 19zqvXiSU9Lcscv3cFno0Jt8FxzbfxGmuVd8+Xqkvz9PHhoZFcgIdTT7xtvPSGZK+Fmv18c07w6
 NH2+vzgtgOHyVnsKOLDqTZhWc8b3TK0PayMxDkAb+/eoa7GzxGzaxdWKlfijk0sW/AdFqu1BGsu
 lVt8QcMq2BZZ4+90Rgt0bQ5yzXvTeINK+n+6ALbbli0yZTX+hYhSD0PppNTdskomyYWOePdY3Xn
 PgcmRv1Vq1sFh+1hlRRrChgWdaZQ4PDzRL/LwHnS3S2e3F5ljPozoO5lgYoslCOBtspOUucncgQ
 l+pGIDypjiuCnDzYOYopyF2bTeFUVxL+rZTa+42C2P99GrM1j09IER5vJpKkmSOyGWbXIER/pBP
 kHWKzwuWTSJXOSbY+zg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-15_03,2026-05-15_01,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gMTUgTWF5IDIwMjYsIGF0IDg6NTjigK9QTSwgRXJpYyBBdWdlciA8ZXJpYy5hdWdl
ckByZWRoYXQuY29tPiB3cm90ZToNCj4gDQo+IGluIDAyLzEzIHlvdSBzZWVtIHRvIGhhdmUgYSBw
YXJ0aWFsIGRlc2NyaXB0aW9uIG9mIElEX1BGUjEgYW5kIHlvdSBtaXNzDQo+IG1hbnkgb3RoZXIg
ZmllbGRzLiBBbnkgcmVhc29uPw0KPiANCj4gRXJpYw0KDQoNCldlIGFyZSBub3QgcGxhbm5pbmcg
dG8gc3VwcG9ydCBBYXJjaDMyIGd1ZXN0IGZvciBuYW1lZCBjcHUgbW9kZWxzLg0KRHVtbXkgRmll
bGQgZm9yIEFBcmNoMzIgcmVnaXN0ZXJzIGFyZSBhZGRlZCBzbyB0aGV5IGNhbiBiZSBkZWZhdWx0
ZWQgdG8gemVyby4NCg0KV2FybSBSZWdhcmRzLA0KS2h1c2hpdA==
