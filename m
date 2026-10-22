Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.155.12
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792668184;
	b=YmuBchDMyrKI3jeSO0bWMcxtEwNhOA34YcmCzEVo1FC6UxysaIHSbPl7qIRI8JeNU0Ur
	 T+GuL/93enjrXHHcDdGWzKxIemQRVTtJBNIg06RlRC0spbKZLdtsv2XgPdOEoQzZn6S5/
	 T1KodiV7wtKVcHk9zG0YcDHn6/wWjuTLXrTNOngRk5jzBr7PIagt8rscurxl/9cTDvpXx
	 Ym/eaYw3Yiyzf7HKqLsReEObOY5XFGdGUfdNQi2v/51uGh0nYH3/E/MkO6A3Tc22UEYvD
	 yzi4OnLpL++6lQHJ1nzx6TugyFcQ81j9rrKGwE2csxC5i6mzIiuMvjm9xsFb8gZ1QYA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792668184;
	h=DMARC-Filter:Received:DKIM-Signature:Received:DKIM-Signature:
	 Received:Received:From:To:CC:Subject:Thread-Topic:Thread-Index:Date:
	 Message-ID:References:In-Reply-To:Accept-Language:Content-Language:
	 X-MS-Has-Attach:X-MS-TNEF-Correlator:x-ms-publictraffictype:
	 x-ms-traffictypediagnostic:x-ms-office365-filtering-correlation-id:
	 x-proofpoint-crosstenant:x-ms-exchange-senderadcheck:
	 x-ms-exchange-antispam-relay:x-microsoft-antispam:
	 x-microsoft-antispam-message-info:x-forefront-antispam-report:
	 x-ms-exchange-antispam-messagedata-chunkcount:
	 x-ms-exchange-antispam-messagedata-0:Content-Type:Content-ID:
	 Content-Transfer-Encoding:MIME-Version:
	 X-Exchange-RoutingPolicyChecked:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-AuthAs:X-MS-Exchange-CrossTenant-AuthSource:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-originalarrivaltime:
	 X-MS-Exchange-CrossTenant-fromentityheader:
	 X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
	 X-MS-Exchange-CrossTenant-userprincipalname:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:
	 X-Authority-Analysis:X-Proofpoint-Spam-Details-Enc:X-Proofpoint-GUID:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Reason;
	bh=y3SqqLxpovmji7QZAZ8tSZBsBGylCUDRDChaUhvMeX8=;
	b=12l1MFF03CPOvbqIvuLFD8ihAx+7V5NeFh6Fv8PROqViUuxlVXX7Ywt1jbcClVjiq0Y8
	 Jh1fNpGGY0NZMCFsRWWgrl2v8JClF5HNdbQ0kq9Z3/UkvD7m4bVrvBYJt8lAoVKhIb93E
	 qRhIy9wPDOXbbXRJCtXwuXJFsKAfpSjy539tTsN6c2Ix13+unssH8pDEDz8aNc4Hcbpr4
	 alVw76b+KNsthXyFZgSVyV/gtnTYDvcCQWqugouFx9zYbgmVWVHUwiTnmaO75Sz6DXWt3
	 Mjq6HIYuHkVHsbX6hZEPranXE+zlRO+IbophexWa4JDcQyOpLZTYnr1GW/YiDCd2f8w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nutanix.com;
	spf=pass smtp.mailfrom=nutanix.com;
	dkim=pass header.d=nutanix.com header.i=@nutanix.com header.a=rsa-sha256 header.s=proofpoint20171006 header.b=YLPb36jz;
	dkim=pass header.d=nutanix.com header.i=@nutanix.com header.a=rsa-sha256 header.s=selector1 header.b=n4RIuSVy;
	arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.155.12
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CFDA606A319
	for <kvmarm@lists.linux.dev>; Thu, 22 Oct 2026 11:23:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5CFDA606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=nutanix.com header.i=@nutanix.com header.a=rsa-sha256 header.s=proofpoint20171006 header.b=YLPb36jz;
	dkim=pass (2048-bit key, unprotected) header.d=nutanix.com header.i=@nutanix.com header.a=rsa-sha256 header.s=selector1 header.b=n4RIuSVy
Received: from pps.filterd (m0127844.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69MA07lf095751;
	Thu, 22 Oct 2026 04:22:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=y3SqqLxpovmji7QZAZ8tSZBsBGylCUDRDChaUhvMe
	X8=; b=YLPb36jzwF/SFLz/EerYEbSe/uLAvkQg2vX5DvibEnTeKFhyCd3Zh5vwf
	pxXeoWQcEiN7NnYB+nxxi9DkzXEAh5nikMkvFTbpZfQHsZ+5xkS+KnX9NFJxhtVZ
	bSglOqhv97sRdcsjl9oSMpvFqb83xRhSFAyDDyOGk/y5z+2/EKBMozKEP8QSsJuC
	93P6292/NXhF03bZZEXJHCyi/+VtC53JotMUdmE0VeRGd9zMY/phk0AkQG11D+1/
	xgA6O7J8sKP0Yfca5uxBQlkNCUEsa46tFHqaY61t4YqiwWD6cPVGp4qT/W699xqU
	SgmfptSlLrZnyLbETzfi5U6ItVotg==
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11020077.outbound.protection.outlook.com [52.101.193.77])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4hf9759a09-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 22 Oct 2026 04:22:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Q6YkCgZUx5FK6JG3cWydP9LjTYXlgaIl7PXMPjZOIqfhNW1ReDfy0BJxly1BsTmMRQhx5dNpR2zsqp+Q+8hfbNyks2Gf65GmdHceEyXROGOFvhclkclQs1YAV7or6wcxL9KdUL2V8P8Yrc8DyZjP5dGHdN/fb20lia9gbakAXu0FkX4My0GPQUs6XBFh4hjr40bPmgSlCdgqDTI9nb9DJ0X6NaW56q/gxV/TW/6CGq5+fMPQRiCTpV9lUFJUFhK2ZHGkMn6doJHfDlsxI4MHjrcRsbxrSPzvY7T1chCzew+ot+gtUcncFOfX1W6MkMz5J8UYpnalOzZm2FbxWAy/Hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y3SqqLxpovmji7QZAZ8tSZBsBGylCUDRDChaUhvMeX8=;
 b=UTxJVNS54qjg4lZjUa2rXCW+hnmfDr0XvToZNYTNbGqsDj2bHi3n/t0Np84vCwyAQfIKaXIzTZzYhh8L5QY0Mqj1RfyF35MZ1FbPU4Me5VJVSjaEDrXxX0q0g/3IH0AteZ+x9DTxpwt5dcyAsKmbXDclYTE1iLQ+zmZGSiZ6AZBieYotH4CUJqnRl6UXfuARDFfsoScEdnUzMcCOEJ/BwlE2VMNYGs5d2ecnr+ocGU4i1pp5yfMhvGj3ISUFrz12Vhtsn/Z4uWwTdd+EvfragE0BX9ItQz/Jr6fHMusSmf9+iEqJmZXQbk/I4721xG3RVQ0zRzvQExtEuTv/fJYH9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y3SqqLxpovmji7QZAZ8tSZBsBGylCUDRDChaUhvMeX8=;
 b=n4RIuSVy/uoL0YtCO4YYfJ6l2JU6TQwRTcd8bGlnHLYSGt38qAkqRVmrO08JQ0Tat0nGIKWABx3CFUwemawJNd3LAZpo4Sbs8T/S6W2+niX8gQIfe/le8U3NyN/BlL8Y3L24tDRIRpwSnMpap//Etfufb5u+h734L+b0mnGGd2aYYfncGnaLg6/NK8TpS/qCHkqFtdtScKwRKsBzat8AIwWlgOZAEqg+m8Vp/ya8Y9xXvzq65GKqtTG/B8pRtLfcLsfaMjokZjKH58AcsFQyiECM02ljY4yPcnwGZGymm8HJfR2i/3pbePRlsYTUAIJPV+C6ze3r+R46XCGU7nEFwg==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by SA3PR02MB11046.namprd02.prod.outlook.com (2603:10b6:806:460::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.15; Thu, 22 Oct
 2026 11:22:49 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%5]) with mapi id 15.21.0546.012; Thu, 22 Oct 2026
 11:22:49 +0000
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
Subject: Re: [RFC PATCH v4 21/25] target/arm: report 0 as supported for ID
 fields gated by vCPU init flags
Thread-Topic: [RFC PATCH v4 21/25] target/arm: report 0 as supported for ID
 fields gated by vCPU init flags
Thread-Index: AQHdScVt+SKDXcA1ckeqIAlxfJXYvLcATFIAgAlPbYA=
Date: Thu, 22 Oct 2026 11:22:49 +0000
Message-ID: <9BB79180-67B1-490E-B1B7-D7515B964F73@nutanix.com>
References: <20260921123249.1708067-1-khushit.shah@nutanix.com>
 <20260921123249.1708067-22-khushit.shah@nutanix.com>
 <0a1a763d-c95d-413c-ac11-384d5db599c2@redhat.com>
In-Reply-To: <0a1a763d-c95d-413c-ac11-384d5db599c2@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nutanix.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA2PR02MB7564:EE_|SA3PR02MB11046:EE_
x-ms-office365-filtering-correlation-id: 3a282209-1ff9-4caa-ff07-08df302ece33
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|23010399003|376014|1800799024|7416014|366016|261021121427099003|56012099006|38070700021|4143699003|261009223027099003|18002099003|10067099003|261021123027099003|6133799003|22082099003;
x-microsoft-antispam-message-info:
 RZabpKoCV1m1wHKeemkX4CZXO9UEuBi58cGnQB6NQFeC2m0BVMuJ1Wz6/mvkVRMRXZaMZLXW9ZmGzm640Vqehkgmi1L05O91YtNPFj/8poPqj/7mflhr7++RWu49tI98J+9vLNABgqirRFMbssB5KMxD5/2fKrJeWcp4EUKCfegI6dkcfs1AToMQQOeMGK9sA6DzvIWU+VZREFF8VXToTW7u7hKKUrWemjI5O1C1eSzWh92SJ3gdxgx0wZBWHuii6NbxtX8xi5hs8A/ydd/sN4avEUEpu9/gsrA+sVmi/FENUI2sEjQKdI4fyNGEGl/QrymiamYCO7lPdw0eBMbLVQcoTJ+hskBy+mIK/G3qraFrvKtoAssNOGJZNcAn3UnC1zm1gjQh7Zn/YZGyD4RxtoXyryavHb7PqKqoNagZU1z8xkJsjXU4mn8Hnre23FrXOzUuUVRE/NW/zM/NXxk4j2K+eeLljkMIDklDo37eDcNLfssH2BB6WBGbdex0sEPs//i4FCjKseBwGgyMFOOgp8fJhWc0d5+AwIikueKjYNRAK2U9rLkMqB87ekjJnC7uSKvYY7vacRo7cCVlBGjgLvBQcALrDUeXjO2x9D2i4JNouWKvszdRRwrlfJ4ZBOfNvKmlfGFzurQDgyLEO/sCSOcDAohH2eltHCWpWgidXBcPWQ//YIEOd0pR+XI0DQFC3Sze2d2lgKFb9umCkdl8js9kbn7RJ3x1ydIv2bZzZ+U=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(7416014)(366016)(261021121427099003)(56012099006)(38070700021)(4143699003)(261009223027099003)(18002099003)(10067099003)(261021123027099003)(6133799003)(22082099003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?ZUxyNnZoYjdKNzNrRzZNNW9vbldjRFhPeGNVZDFTNDJUUUxIb2VsNGg3azNO?=
 =?utf-8?B?U0t5a0hOMVUvRTd1NnA3VWpJeXM2WlJoMmtXV3h2U2NzaFJsUjlXYmZwdVV0?=
 =?utf-8?B?Skg2dWh1bmtiU2xobGZMWHg1Q1ZlaWI5V3ZKVTkxSEVPWUh2RExOSDdXVVpi?=
 =?utf-8?B?OVpPMitLck9teno5NHhlbU5vc3h2Q0VpcEFHaVJJOExuS29oWGdNRkU2U29D?=
 =?utf-8?B?K0ZwWkdEK2taWnBmNXd1SjhUMi82Q2s4Q2JLRmliVlN0MSt6dzhJcjNENDFo?=
 =?utf-8?B?dk9HOUpvVlNoNUdQVU9RbUR4Sms5MUtlYUZDdkFqdFhBZEJMQ1dPcDBYM3pv?=
 =?utf-8?B?OXoxU3hSd282d2JFOS9ONHR5RTFlNmJLWW9NZTBJWWYzeGtIckpVdFl2SWJV?=
 =?utf-8?B?OEoyc2hDOXF5cEtXZGx5U3B2akdWNnN2aktteHJUSVROMStMK2V3RnZRSVFs?=
 =?utf-8?B?TUc2YUxKbXZKeG52Zk1xT2o0Nm9YZm9DNzcvY0VlT2JRT2RaMWRZcjBwNGIz?=
 =?utf-8?B?Ynlqb2NFR01yZlJJYkJHMTBkZUxOdjNBT2t1QTZNQmw5azhmN2F2TmJISlZz?=
 =?utf-8?B?TXY4a0tKS0ovbUVqa0d4R3UrV0hLQTc2MEZ1SmRKRnBPUFNJelJ5N0tUUUhu?=
 =?utf-8?B?YSsyUi9Zci9YdVVTN1JHTStLemtaMXNFOXFHZGZod2hBNmlNd2RucEViMnd3?=
 =?utf-8?B?WWRvdU01V3kraWtXRHNkNG1iSFN4bHdycHpUVmFSVUtOalhFT2tNTkZyYXE3?=
 =?utf-8?B?aWIwZkxmbXlOZlVpVzlaWHVaRWpXSUdrd3RkOVcyRVVFSGZkbkpxWTlyRHFn?=
 =?utf-8?B?Y1d1V0ZnVzJwMkFCVExxVE5BNWVyZHNqOWJQY1ZNUEt2Um5FRFJQWW1SclhJ?=
 =?utf-8?B?MEdYcmp2RERQZ05RMGVKcUwzM0tkME5oVUxIWW5EdjBKMi9qRkFaQ0haZW1q?=
 =?utf-8?B?djVMOXpBRWxVMGc4MU5tbmJJMjBYdzdxTmhyZ044RmVWcURJRUtLeUE0UGdn?=
 =?utf-8?B?aDcrZGhVZjdkQ1ZhNWJOT1ZGYjJqeHJBdHBiNlFZQ1VteFlkMGJjQ2Zwd3B0?=
 =?utf-8?B?OStuZ2FtSmlDblBqNEx6V0tPcnM2aW5zbkJ3TU0vUDduY2RyZjREMHY3aVZJ?=
 =?utf-8?B?L0k4VnVxYTlNZFh6V3dycVcvZEczK0xVeXVSVDhDT0dEeTA4MWc1NHZYd3Jn?=
 =?utf-8?B?Z0hTV0tFa3o3Nk41YTVPLzE0Rlh4M1VkSlpSUHQ5TjFXZlYxVGQ0S1dSTmN4?=
 =?utf-8?B?OFZKbEl2dlY4WHlQY0FrU1V2Nnh4b2kxMTVuNXQ3ZVVSZTdGRTZra2I1OGFK?=
 =?utf-8?B?TFRISHVnT3d2MU9TYk9yODNVNnhoc3l4MSt5YWdqZ3NsYWxJT0o0M1lTTkl6?=
 =?utf-8?B?VlZrUG9FU0pyeGRxV0VodFJPZC9FTUlTZ0JvNm1CczB3bVArVitwcStZeTFN?=
 =?utf-8?B?clRkRExYUHgram5laGNOMUlSMllmRGoyc1lGS2R3eStrc1lVS3pQWDg2SXJ3?=
 =?utf-8?B?aEcxL1U1Z1JlNzhkZzhGd3hKeUV0c2h0ZVNhNHpYZzIxdU5uM3hOMzdZeTg3?=
 =?utf-8?B?bVB1YUhFTjZ5Vi9YbTZxQUhEZHlUV3BKQ3NjU1FGU1FoeHVWVjAxT2dzVTFL?=
 =?utf-8?B?dmYwSUo1Z2pEeDFTTVp5K2FLSE1NN1BtWTFxd2VOaElPdGYwSVp6TkdWSG5R?=
 =?utf-8?B?SXhKcWZMZ3NuRVo3ZlFhNDBEYmFtTGJkcTBJbnBiQUg4NFhvczQrYWxxTFFj?=
 =?utf-8?B?M2dIYk9WdmkrRFpyNndHYW1lN1ViZ2d4VW5JRnlBRTZsUjNXSWlXeTVDdmsx?=
 =?utf-8?B?clFRcjJWS3o4bnNYczRIVTQ2OEgzdWR5NnczOWZVOWl3cmpiZkZpbzFab3Rq?=
 =?utf-8?B?RE5ISWNqQ1N0ZC9tWE1YZFhiQUtvSVVSd3NSNlBFSDdKbFJzQ0MvRlE0L09E?=
 =?utf-8?B?Y3BIMUJnRDdsR1RibStPQU02cTZXUHNLb3dlano1UzZPOFhmRlFGK05WSzJ4?=
 =?utf-8?B?SFN5ckx3Ry9XRDNYQWRiWUNpcDdUM053K09DazIzWEFGZEhDM3IxOU1QN0pu?=
 =?utf-8?B?V1lVc2I3ZVJteDJ5Um9xc2dRV3IvS1hmanJtYnVxMHpNL0ZvTlhIK2Jya05U?=
 =?utf-8?B?cVptc3NvMTFEd3FpSzhZVjFzRXhWWGs5b3o1WlNvUzNwWlRTOEhENmthV1Vh?=
 =?utf-8?B?dlpoNm1zRmZFNE13MzlSU2ZxSFI0S2dPVnROeEhvem84d2dtbitIZHdmeUE0?=
 =?utf-8?B?MS9qOW90bnFHZVNHK2FkK3hOWEcycDMxbjF1Vm9kVE5vQ1hjL2RrUjdEd0Yv?=
 =?utf-8?B?Z0xoa2JxVkZaSjgwMEEybHA2eVVHWFA4and5SVV4QVA0WWd6cDIvQ2ZYQXRj?=
 =?utf-8?Q?uWcvatYMNH5tkTUY=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <02B95EA59714314EB197D4206D9EAA07@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	LEIZLInJb+15xXw9Lzdnzt4nPgciOIKPj1Z2QdmLJZ4cGP/YFARWgZ92hFjLB00/q2hJO3BsWXZTMRk89xhsWOUFOzmdA8b34C6njnqLa7CaxSR8uQTM8i0OdaD+NjvGrTDfTv49ni+7CuHfwgcUHJG3pqKkmrd2mABAeolh8OtFqF6mFySZ9D4byRq5FfMo9lQ/mhMtUIZinWPFXm762sVVmx4wNxZsUgVSRbun2Rey7/3xU/A5iE2NQFJmrBgw4gSbc/muWfR/pQFbLwcIHxzWrNuYMf9uFDgsMHA4ZoFHF6RHMporjHEPnbegitw6y8CyNNguBzDSnPL33yC6qQ==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a282209-1ff9-4caa-ff07-08df302ece33
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Oct 2026 11:22:49.5572
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Z9TDMkWeeLvcCoZulNq+77v9SMf7bnv4maPnyIs1dz3LENzqu9lbIKJCXlz9LLxIPS2FvqofHDFOT+Fdl+7A9pPT/1Uk7Bws1JrOzIqzCeg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR02MB11046
X-Authority-Analysis: v=2.4 cv=TKLQ2Fla c=1 sm=1 tr=0 ts=6ad9f20b cx=c_pps
 a=0f5ZEuiVSdGWuY0eyBan/w==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=660iZSQnnn4A:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VofLwUrZ8Iiv6rRUPXIb:22 a=0LlEyIVc8U2lsR7dKhuH:22 a=20KFwNOVAAAA:8
 a=64Cc0HZtAAAA:8 a=ybwk6nc7vaCMY1-kEIsA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIyMDA0NSBTYWx0ZWRfX5ba6VYTUkDte
 uYFHYrVoYcto7Vf+jNH/hGrqrPJj8dcY3jChXRBFtw6jS4Iotd8iMWWv0uwYNYvA6UM7CFB3CMr
 nn9nZO271JavrZp2NPUMCsJzrHu+/ORpims9w5Qx0kATRvgy/Iv0O2lgWT4g+MHxk1v4rj/CuBm
 9zlV/MGyDTsf1ffIoBACrc0ir/5xU7x6oaBHfCtgnE9gogt5hM6KSrYRj/bsaX1G2+d9MkVa01S
 90Sew61Uuwai503sCjAFlpwm29EZzL12GiNRZe9vneeyi+EDQBr/5gq3WOKc8LOCoiGT0LKe+sh
 1/Ij0zqD6roU65iqEy6Ukc2Uab0TBKGs/MbqGK4GfRlEXLGozpJpIIQokkuLMu3sijNNBXtkiP7
 jgohvvac4VpeASU7HpBnMeHgVZdM6zvUcJdGEbGHTxQP81uZpX+V3eEIE9d6zs6tWrO4/KKkK6e
 XURRji3f5wyUP8OLb8w==
X-Proofpoint-GUID: Fr7xu-IRTpd2zvMRe9PV9SiuzX9EPNwn
X-Proofpoint-ORIG-GUID: Fr7xu-IRTpd2zvMRe9PV9SiuzX9EPNwn
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIyMDA0NSBTYWx0ZWRfX/xR7euYPhmq3
 1fB9rgly1wICbkxVF1yT0l8hFrZHM7Q4vnI9MkQdJ7AhT/ZLnWeFJ9cU+pZX/pLra233NaKtOrH
 0u0a4dTIEuQB216yVA1OdKa64gj9M+Q=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-22_04,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gMTYgT2N0IDIwMjYsIGF0IDY6NDLigK9QTSwgRXJpYyBBdWdlciA8ZXJpYy5hdWdl
ckByZWRoYXQuY29tPiB3cm90ZToNCj4gDQo+ICEtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tfA0KPiAgQ0FVVElPTjogRXh0
ZXJuYWwgRW1haWwNCj4gDQo+IHwtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tIQ0KPiANCj4gDQo+IA0KPiBPbiA5LzIxLzI2
IDI6MzIgUE0sIEtodXNoaXQgU2hhaCB3cm90ZToNCj4+IFdoZW4gUUVNVSBxdWVyaWVzIHRoZSBo
b3N0IElTQVIgdmlhIEtWTSwgaXQgdXNlcyBhIHNjcmF0Y2ggdkNQVQ0KPj4gaW5pdGlhbGl6ZWQg
d2l0aCBhbGwgaG9zdC1zdXBwb3J0ZWQgZmVhdHVyZXMgKGxpa2UgU1ZFIGFuZCBQQXV0aCkuDQo+
IA0KPiBTbyBJIGV4cGVjdCB0aGlzIHBhdGNoIGlzIG5vdCBuZWVkZWQgYW55bW9yZSBhZnRlciBy
ZWJhc2Ugb24gdjkvdjEwDQpUaGlzIHBhdGNoIGl0c2VsZiBpcyBzdGlsbCBuZWVkZWQgYWZ0ZXIg
cmViYXNlLiBCdXQgcmVwb3J0aW5nIGJsb2NrZXJzDQppbiBxbXAgY3B1LWRlZmluaXRpb25zIHdp
bGwgbmVlZCBleHRyYSBsb2dpYyBhcyBiZWxvdyBmaWVsZCBwcm9wcw0KYXJlIG5vIGxvbmdlciBw
cmVzZW50Lg0KDQpUaGFua3MsDQpLaHVzaGl0DQoNCj4gRXJpYw0KPj4gDQo+PiBLVk0gZXhwb3Nl
cyB0aGUgY29ycmVzcG9uZGluZyBJRCByZWdpc3RlciBmaWVsZHMgKGUuZy4sDQo+PiBJRF9BQTY0
SVNBUjFfRUwxLkFQQSkgYXMgcmVhZC1vbmx5LiBUaGUgc3VwcG9ydGVkLXZhbHVlcyBsaXN0IG9u
bHkNCj4+IHNob3dzIHRoZSBlbmFibGVkIGhvc3QgdmFsdWUgKGUuZy4sIDUpLiBUaGlzIGZhbHNl
bHkgZmxhZ3MgYSBtb2RlbCBhcw0KPj4gYmxvY2tlZCwgZXZlbiB0aG91Z2ggdGhlIGZlYXR1cmVz
IGNhbiBiZSBtYXNrZWQgYnkgb21pdHRpbmcgdGhvc2UgZmxhZ3MNCj4+IGR1cmluZyB2Q1BVIGlu
aXRpYWxpemF0aW9uLiBGb3IgdGhlc2UgZmllbGRzLCBldmVuIGlmIEtWTSByZXBvcnRzIHRoZW0g
YXMNCj4+IG5vbi13cml0YWJsZSwgd2UgZXhwbGljaXRseSBhcHBlbmQgIjAiIHRvIHRoZSBsaXN0
IG9mIHN1cHBvcnRlZCB2YWx1ZXMNCj4+IGlmIHRoZSBob3N0IHZhbHVlIGlzIG5vbi16ZXJvLg0K
Pj4gDQo+PiBTaWduZWQtb2ZmLWJ5OiBLaHVzaGl0IFNoYWggPGtodXNoaXQuc2hhaEBudXRhbml4
LmNvbT4NCj4+IC0tLQ0KPj4gdGFyZ2V0L2FybS9rdm0uYyB8IDI1ICsrKysrKysrKysrKysrKysr
KysrKysrKysNCj4+IDEgZmlsZSBjaGFuZ2VkLCAyNSBpbnNlcnRpb25zKCspDQo+PiANCj4+IGRp
ZmYgLS1naXQgYS90YXJnZXQvYXJtL2t2bS5jIGIvdGFyZ2V0L2FybS9rdm0uYw0KPj4gaW5kZXgg
NzdiMWJjZGY1NS4uMGI1ZmI0OWRmZiAxMDA2NDQNCj4+IC0tLSBhL3RhcmdldC9hcm0va3ZtLmMN
Cj4+ICsrKyBiL3RhcmdldC9hcm0va3ZtLmMNCj4+IEBAIC0xMzQ2LDYgKzEzNDYsMjQgQEAgc3Rh
dGljIHZvaWQgcmFuZ2VzX2FkZChHQXJyYXkgKnJhbmdlcywgdWludDY0X3QgbWluLCB1aW50NjRf
dCBtYXgpDQo+PiAgICAgZ19hcnJheV9hcHBlbmRfdmFsKHJhbmdlcywgcik7DQo+PiB9DQo+PiAN
Cj4+ICsvKg0KPj4gKyAqIFNvbWUgZmllbGRzIGFyZSByZXBvcnRlZCBhcyBub24td3JpdGFibGUg
YnkgS1ZNIGJ1dCBjYW4gc3RpbGwgYmUNCj4+ICsgKiBkaXNhYmxlZCBieSBub3QgcmVxdWVzdGlu
ZyB0aGUgY29ycmVzcG9uZGluZyB2Q1BVIGluaXQgZmVhdHVyZSBmbGFnDQo+PiArICogKFNWRSwg
cGF1dGgpLiBUaGUgc3VwcG9ydGVkIHZhbHVlcyBhcmUgZGVyaXZlZCBmcm9tIGEgc2NyYXRjaCB2
Q1BVDQo+PiArICogd2hvc2UgaW5pdCBmbGFncyBtYXkgZGlmZmVyIGZyb20gdGhlIHJlYWwgdkNQ
VSwgc28gZm9yIHRoZXNlIGZpZWxkcw0KPj4gKyAqICJvZmYiICgwKSBpcyBhIHN1cHBvcnRlZCB2
YWx1ZSBpbiBhZGRpdGlvbiB0byB0aGUgaG9zdCB2YWx1ZS4NCj4+ICsgKi8NCj4+ICtzdGF0aWMg
Ym9vbCBrdm1fYXJtX2ZpZWxkX29mZl92aWFfdmNwdV9mbGFncyhjb25zdCBBUk02NFN5c1JlZ0Zp
ZWxkICpmaWVsZCkNCj4+ICt7DQo+PiArICAgIHJldHVybiBmaWVsZF9tYXRjaGVzKGZpZWxkLCBJ
RF9BQTY0UEZSMF9FTDFfSURYLCAiU1ZFIikgICB8fA0KPj4gKyAgICAgICAgICAgZmllbGRfbWF0
Y2hlcyhmaWVsZCwgSURfQUE2NElTQVIxX0VMMV9JRFgsICJBUEEiKSAgfHwNCj4+ICsgICAgICAg
ICAgIGZpZWxkX21hdGNoZXMoZmllbGQsIElEX0FBNjRJU0FSMV9FTDFfSURYLCAiQVBJIikgIHx8
DQo+PiArICAgICAgICAgICBmaWVsZF9tYXRjaGVzKGZpZWxkLCBJRF9BQTY0SVNBUjFfRUwxX0lE
WCwgIkdQQSIpICB8fA0KPj4gKyAgICAgICAgICAgZmllbGRfbWF0Y2hlcyhmaWVsZCwgSURfQUE2
NElTQVIxX0VMMV9JRFgsICJHUEkiKSAgfHwNCj4+ICsgICAgICAgICAgIGZpZWxkX21hdGNoZXMo
ZmllbGQsIElEX0FBNjRJU0FSMl9FTDFfSURYLCAiQVBBMyIpIHx8DQo+PiArICAgICAgICAgICBm
aWVsZF9tYXRjaGVzKGZpZWxkLCBJRF9BQTY0SVNBUjJfRUwxX0lEWCwgIkdQQTMiKTsNCj4+ICt9
DQo+PiArDQo+PiB2b2lkIGt2bV9hcm1fZmllbGRfZ2V0X3N1cHBvcnRlZF92YWx1ZXMoY29uc3Qg
QVJNNjRTeXNSZWdGaWVsZCAqZmllbGQsDQo+PiAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgY29uc3QgQVJNSVNBUmVnaXN0ZXJzICpob3N0X2lzYXIsDQo+PiAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgQXJtRmllbGRWYWx1ZVNldCAqKnZhbHVl
X3NldCkNCj4+IEBAIC0xMzU4LDYgKzEzNzYsMTMgQEAgdm9pZCBrdm1fYXJtX2ZpZWxkX2dldF9z
dXBwb3J0ZWRfdmFsdWVzKGNvbnN0IEFSTTY0U3lzUmVnRmllbGQgKmZpZWxkLA0KPj4gICAgIC8q
IEEgbm9uLXdyaXRhYmxlIGZpZWxkIGNhbiBvbmx5IGV2ZXIgaG9sZCB0aGUgaG9zdCB2YWx1ZS4g
Ki8NCj4+ICAgICBpZiAoIWFybV9maWVsZF9pc193cml0YWJsZShmaWVsZCkpIHsNCj4+ICAgICAg
ICAgcmFuZ2VzX2FkZChyYW5nZXMsIGhvc3QsIGhvc3QpOw0KPj4gKyAgICAgICAgLyoNCj4+ICsg
ICAgICAgICAqIC4uLnVubGVzcyBpdCBpcyBvbmUgb2YgdGhlIGZpZWxkcyB0aGF0IGNhbiBzdGls
bCBiZSB0dXJuZWQgb2ZmDQo+PiArICAgICAgICAgKiB2aWEgdkNQVSBpbml0IGZsYWdzLCBpbiB3
aGljaCBjYXNlICJvZmYiICgwKSBpcyBhbHNvIHN1cHBvcnRlZC4NCj4+ICsgICAgICAgICAqLw0K
Pj4gKyAgICAgICAgaWYgKGhvc3QgIT0gMCAmJiBrdm1fYXJtX2ZpZWxkX29mZl92aWFfdmNwdV9m
bGFncyhmaWVsZCkpIHsNCj4+ICsgICAgICAgICAgICByYW5nZXNfYWRkKHJhbmdlcywgMCwgMCk7
DQo+PiArICAgICAgICB9DQo+PiAgICAgICAgIGdvdG8gZG9uZTsNCj4+ICAgICB9DQo+PiANCj4g
DQoNCg==
