Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.151.68
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792656257;
	b=UfGOdtoa9gRx1iItgUYVsgNKJ02q0/Ryur5ylVWwCWkoDAnDSnwegxdMRP9g9N3M5CLb
	 cRgCokC62H8PdfPUKh0dFx9rg4oRhLw7gKjKvrYpXOfWfKQxI58btJwMThiHUVM+DRRS0
	 EQA1HQIw+C/F2mIZXmXbdnjaDJBm5+OLXdy1us84w15gN2atKZ9CcLB0qdSHAugAV/QYT
	 W4bHAVo+jmS6i1B+Y2mzyQgPCno1ellFkxnp+vgsyZFkBRPRmU3J35fFPoJVqeN5y8Loq
	 0/4xmmpl1lpUCcdCTzQ+X2B3jKD63qRkbGiqRXpEAg062av22wCbTVOB1Yu58EQfOXw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792656257;
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
	 X-Proofpoint-Spam-Info:X-Authority-Analysis:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Reason;
	bh=ydlz9au1Zc0pmXg7goamrf4Q15HGEDk2gJKJjpCjiJA=;
	b=fTduCOlg6aKPLcQzptOovXmUpybfoI2tj56KL7p4G9sgX9WBO3lj6Tkv/5TucbaoPU7E
	 C9wUaf1x7qWtpAY12KRriT7ex5rA3UTJDXMfl+YgdnPJ9R4BwhhMl6j6GSgiQ6dcVQgjl
	 WnLAEJ3k1/A/LKuRZLNwPgCurkNAk5sfoOGsD7g8W7pD8E5QJKMNG/KalVrg7XIgLiTZT
	 db2iGmDsLfsZpq9fo1k6hkmJTZGVtGwwej2wBLWOqLrny8WKpSOxgWClpM+mlspQdAegI
	 NeNqbAuWzsnAyrF9jpyfqAapUF3FRTO0UZze2GKvDOoo52PvYVQckK8IcvTotz+C6SQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nutanix.com;
	spf=pass smtp.mailfrom=nutanix.com;
	dkim=pass header.d=nutanix.com header.i=@nutanix.com header.a=rsa-sha256 header.s=proofpoint20171006 header.b=iSDCgr7I;
	dkim=pass header.d=nutanix.com header.i=@nutanix.com header.a=rsa-sha256 header.s=selector1 header.b=pnEJjGdg;
	arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.151.68
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EB5C606A31B
	for <kvmarm@lists.linux.dev>; Thu, 22 Oct 2026 08:04:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9EB5C606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=nutanix.com header.i=@nutanix.com header.a=rsa-sha256 header.s=proofpoint20171006 header.b=iSDCgr7I;
	dkim=pass (2048-bit key, unprotected) header.d=nutanix.com header.i=@nutanix.com header.a=rsa-sha256 header.s=selector1 header.b=pnEJjGdg
Received: from pps.filterd (m0127837.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69M71ZFN140173;
	Thu, 22 Oct 2026 01:03:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=ydlz9au1Zc0pmXg7goamrf4Q15HGEDk2gJKJjpCji
	JA=; b=iSDCgr7IypGh7tzh9QTz+g+xvHFc5zOr0rK5EejmBnAL3wnbh/PBnBfhd
	wpziwklO6UtfNlg8minuqdfSzwH8NLSLzE8BDF8nCswl8rb1T5EcnuStDyR3yC8c
	JZ5KpZZ7U2mcH2S5DjkEDN1rm8yDasJd5YSGvsFjHES2eOLejYpbImYPcKggbh3G
	fxdUz5zF819dN6qpfvIszCqAySvN6I8ZRw+B8VgIqFp5ZBAQ9/6s8/c0waW9jC9H
	vNREuWh6vzW4Qi4RSOVr9gQ4HEEPNn0PVhasx+lWD+zPHtEpWRDhB/h781KtrzCL
	4KRm+Y+3qzC4Ao+WUCpT+uFRf7rGQ==
Received: from bn8pr05cu002.outbound.protection.outlook.com (mail-eastus2azon11021143.outbound.protection.outlook.com [52.101.57.143])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 4hf9720syw-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 22 Oct 2026 01:03:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=q1qFBeXi3lsjXqCnYVJkAKzQ8V9Iw07NQ/Cce5gXLjavj/FRBlMeNFwkP06S458EteWyV87KG6evhi0pX0ppJaJqnfrYYFcpQKpBOc7r7SEaAwdAab+8yMDQS5qyVYEVxFIiJ/SNCHVFZFtEq0Vo3lj76DXIACF/sM/wRbASLvuzE+yLQAA+niXhX9JFnRX8AtxdTx/t7GmOsngCJYfw1KsDDrgcf5tXA+zkzHk4q3n1l3cwRBWJqDCzjpBJKStETmEdUVNie55ks8QBPYd61jwl1eCGjc1dIldPpBhOS0HinHszNlH1qld5irweVqmaY1y8r2+Qbrb5oCF/fZxQaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ydlz9au1Zc0pmXg7goamrf4Q15HGEDk2gJKJjpCjiJA=;
 b=VD75XEyxAMOXA6WjIPajLoGFDxeP+1mcfltIuVqCwSmkjA0R0MYzGkENAiVjCkXD0UdR3e9Vqiz8HHQfpxWTpGL6fPv+1zJP+DISQh6ZrXTwoswdNcJWyz1F8p1aKSVMKdTZgPEk+NOEWTuLav8nBjanwXnIZ+7CbtFm9qnFskzZokHlHWVBnizConELMNnJ8KexCfaWz3ibCpF1444ScAyhVSj+Nk8+xBxYkb93143M/vlw3WS1D82CUIIwt//KIDi9Bn+1KoCzJR8zPr6/nz4e1Bl6BCScXvl0mZ7egjCm4EmwzR8fIB0IyoBOO+Qy+Cvsrgg464MFJRNYXl3R8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ydlz9au1Zc0pmXg7goamrf4Q15HGEDk2gJKJjpCjiJA=;
 b=pnEJjGdggstdFwfX/E1C/VW3yVK6/zwiOFpavG1iIoBelEbDYrTLR8gNfsVet24orTKTp1jkF+g8/Nq6E4XeEdYI7p/THnzB8FWLv18p5XOcBZE6Elj6/q/YmskUpPHsetZJSRmMfNgRIvQ8n6HWoQmjGxl6zWXSMbXw/kmXhOtcqGHxXGjUl0AL8SJA0MVv0Ty3wJL+zRd6QttAZ0hEfw0KLTf7sCcqlz1n5UFswva2vci7jQcPttFga89DACrX8eoN/RKcUJgbicUXz71nNElXKnAdPLGi6Un6hSkTiglRxerkik2TLN6KZV58cnyjtpH7mXRVue3Yjc2Tw5bHIw==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by SA0PR02MB464239.namprd02.prod.outlook.com (2603:10b6:806:d7::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.15; Thu, 22 Oct
 2026 08:03:50 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%5]) with mapi id 15.21.0546.012; Thu, 22 Oct 2026
 08:03:50 +0000
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
Subject: Re: [RFC PATCH v4 11/25] target/arm: disable PMU support for named
 CPU models
Thread-Topic: [RFC PATCH v4 11/25] target/arm: disable PMU support for named
 CPU models
Thread-Index: AQHdScVo9PsGfPM9b0eUm1GlO2bOarb+ui0AgAqp+YA=
Date: Thu, 22 Oct 2026 08:03:49 +0000
Message-ID: <6210B10F-496F-4D2A-86B1-6A7E28DB42C9@nutanix.com>
References: <20260921123249.1708067-1-khushit.shah@nutanix.com>
 <20260921123249.1708067-12-khushit.shah@nutanix.com>
 <6e0b9a10-84c3-4948-8eef-3d2ea5c44a56@redhat.com>
In-Reply-To: <6e0b9a10-84c3-4948-8eef-3d2ea5c44a56@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nutanix.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA2PR02MB7564:EE_|SA0PR02MB464239:EE_
x-ms-office365-filtering-correlation-id: bb91370d-b341-4c5d-0899-08df3013019f
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|23010399003|376014|1800799024|7416014|22082099003|10067099003|18002099003|261021121427099003|261021123027099003|4143699003|261009223027099003|56012099006|38070700021;
x-microsoft-antispam-message-info:
 mnNxenZOZ2YCboJz2DYClYbAuGu50x25r3or+HgTP96D8m7Jj27/aQLzLgPn+LVQn2oOJ/UHcCy2N2X5jzyUPIHqTPu/BLFmllOcSUP1ZkryY0iCn0cjZa9DLuby1ijV/FhgVW02mX9QA05EciBg7TaUVB9c5RK2lOBWM2H4t0aCK/RoquQ6hy9t1TVITU6ENK+SRrcbtFyNRIghpdLQtWLCzKhidQBuWZG28Lei0hDa0wuLk935nPKW7Ewl9bJ+jZi0iuxQIJbVVFhs/cspYoPLkN/Gpzj2mxhgCrkpShZNz1PSfxKwa5Hs8zA+Rpb2rBXDn5REUgTN/ZAM0MuEwQFSwgVMOH9XM4kADWXSmAiTvGVJbzZnUgug2h+R1rBAa+eVWTH76T/3DD0HtfZymHE8muaShrvVQSAwoxgRTkKZoZf3wFeuQsCsBBWglZh1bIIYCzLsVjfxLYfMIv3pSAUgxkZzTddu+JNROZ0LwDuA/RCJze2+cH62xJpBnWWm3RCCwJ03GDbRW9mTGojDD7I5HB9zkHf9QpgnsSc1C4w/P6mJgRA/ycZbACg0CswJD1MT8Z3QS/qp++/aAnkCJx3JdFeqpUO6kxOMQMdW+3s4PjSfXOG5Hlp7lBPOnEOEk5VnlEzPGTgE+Cd49q6mHt2qudesc5R8Do+895glEMu6ySbzXkXYgUPhnDu5UpO7gLoCEqO9cdXSO0o3LHgt7JX1FkWLcLCwPO/iqTExNhQ=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(1800799024)(7416014)(22082099003)(10067099003)(18002099003)(261021121427099003)(261021123027099003)(4143699003)(261009223027099003)(56012099006)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?aURKTlJsZDhXVTJ2a2x6b2l5N29nVTRlTXVaUXhoTzhDak9LdzZ1MXpWOWpy?=
 =?utf-8?B?L0RZVXQzdC9QY2o4eDdaU3UvQXRkR2c1MWlabmxqMytpTUd2UytNd1pLSG5R?=
 =?utf-8?B?anZRb3pVOW0yMHNQNXJCVDQyUlFrYzZtVS9VMnRnTlBJK1NNelp1ODVXYmdT?=
 =?utf-8?B?S1hXeFhURnNUKzdqdWpIcFloVXo0MllnS0hOQWZvUTFYNlA5SElzSEhHNnVQ?=
 =?utf-8?B?UkNWai9MSldMVk16eHJ0aTk1b0NjQTN1RlNIMk1Ba0NSYWlQOHdoS2d4dVpG?=
 =?utf-8?B?WUJQNTJES09CKzJhcmR6RWRvSzhRNzBMdGNiRGl4Q3dmaENSTzZsVmpTcFF0?=
 =?utf-8?B?RGVBeVZqWmt0VnRlaGp0S0xlRjB2RmVsKzIyZGV3NElaMGVzRVBlMmNWSFFK?=
 =?utf-8?B?cWlvOTUrdkN2VVJaVW1ESisvMW9PdEpIM2cxWlBDUFF5MGlUcHF0TU9ROE1H?=
 =?utf-8?B?T2NER0FnWVVvWHFUakFXY2x6MFBHS0JxZVE0cU8vNFJhMkhpa2EzalVMcnlj?=
 =?utf-8?B?OU5pbFkwWGJ2cnZyR2hSZFRTQ1c2TGJ2VnUrUFFEZWdRQm9zZzFwVzBOZy9N?=
 =?utf-8?B?T0pSUFNaa3lyTE9GNFVseHpiemZORnhkWHBaYVJPNGNod2t0WldlS1F3V3F6?=
 =?utf-8?B?M3ZqME1JSlJ0S0tFZEpGVy9TUlVDZ0c0QnBGOGN4cWpZcG5ybGpQVHZ0aGk2?=
 =?utf-8?B?c1RjRDNvZmpkZXI4T3d2cXIva2pOMUJ1RWdSMzdPV0gvOTRwb05vdW9Ib2ds?=
 =?utf-8?B?a1FWV2s3bzZla0Z2Tm5PMkdpNWRZL3MyMHhLSlB1Qk5jc0JNdiswNDYxODlW?=
 =?utf-8?B?L1JScWpLZEh0cXh3bkQ1M1pweCtKaFJNVDZsQ0wwQ2hNY0Zrang1MEJPN2E0?=
 =?utf-8?B?a1RwdlRBcFJURmVrclV4dWFadGpGWXplVGllZmZoMzY3NWllcUhBZXdiaTZF?=
 =?utf-8?B?R1JEenZTZThETnJ4bHVXcWhaWGUweTl6SGVzeVlIQ3B0b0w4ZXlGZHhSblNi?=
 =?utf-8?B?ZnFDVDRhTUdFR1MwQnRLUTBVRlNMcVB0YURKempzeTQzdGZ4ODgxeENXb2hT?=
 =?utf-8?B?RFpHdjhuYUNCM21XVjdBZ1pNekJkaHVpVmliTHFxOUZ5UnQ1Z3FtQmdCbkVw?=
 =?utf-8?B?T3VlRjNMZStkbVdBTzdjd3BHWnhtWFM5NHZOZzhKZld5ZWkrbzNEejNTOWZr?=
 =?utf-8?B?ck54WXZ2S2djMXF0dDVKWXdkMHRXb1pqNmRoQ2VOYW1XNEhKbi9XZnpodDF6?=
 =?utf-8?B?UEtIZkJtNHY1dXFhRlVnUWJUODN0VkhUWjRQclZHUE1zazB5UGlFOW5QOXR6?=
 =?utf-8?B?a05OZVpPeDdvakhwTUFLbGJ6QmxqTHlZTUY2TDIvUUZUV3FCNmFGRVBsZTd5?=
 =?utf-8?B?eTh2dURPWjh0TmJEQUF4RXQzMEhQWXhsTmpLSThOT1NIdjlWMDNzN0oyaWVJ?=
 =?utf-8?B?bkdDVFRRbmJDOWsycE5vK1IzTkh4N1pVNVFySW5hWGJZbFU2M01ML0l1RDEx?=
 =?utf-8?B?QUlSTVVCcUhScXc4cWVOMGM4RDROTXkxbmMxZmIxeW9EOWNFeFFwblpxeUUv?=
 =?utf-8?B?Z1JUUEJDVGluN3NNSE5hYzJtMWFOMTlBbXFyQzJMQSthS3Vpb3NRQjFmL3lp?=
 =?utf-8?B?SVF3Y3pUNXovUG9hblJvdHNiZXBTQy9iSTJWU0RqU000N2c4S3NBZHU2YUti?=
 =?utf-8?B?U3cwRjliVHljQktYMmZEazUzZWNoZ1YyRGhHWm1COU8zdHh0L3JRNTh5U0xR?=
 =?utf-8?B?NXQvQ2Fhb0VKZFByK3M5UVMwZXNCTnlrVUFBby93OUhib2I3Ylk5enpBaE1P?=
 =?utf-8?B?Mmg5SVRiNmV1bnBnTkJNcStldVdpRlJhNlA3enRpT1lQMzFiM3dEVUVhMCs2?=
 =?utf-8?B?Z2RKL3JIYldSOVQrNmRKNGFrUklNTzJ2WUtkMm80RWdHVzlhbjNBTGVJOHg0?=
 =?utf-8?B?SVRmci93K2NOajBJalN5M0hFdU92NU83MFVTSFVOMnNjeXlNWEpqUnZVYlVi?=
 =?utf-8?B?akdDZ2VFQnN1RGFjbFhkSVFRakRKUVExdXVCN0h3cDk4aDE3T2tnalc3UE4y?=
 =?utf-8?B?K2wvdjRJaXdVZ3hPRGNTL1QzT2FXdDNKUFF0UW1WN01tdGt2R2dDS1BBV0w4?=
 =?utf-8?B?SzByUkpqWk8ybXgxaEoxQmpCeWFWUFJyS2JVN1RwbCtXVmFEVVI2L2pNSGdX?=
 =?utf-8?B?RHZ0VXVYOG9QNzNvNS9Gc1U0Y1Jwd0xjL1VDUGNscDZVcllOdkUvNVNWYXZ4?=
 =?utf-8?B?M0c2SFRUVThMN0w4S1d6ZktuYWp2dDlqZDAzL2hrdDRocytraTYrQjNWZW5h?=
 =?utf-8?B?V0djYU9WOTBkUzAwdGdiYkoycFJmR0dZNmFwRTdwdEg2N3JwNnJSR0VpaEpV?=
 =?utf-8?Q?Yq0E7e8UbuarGbS8=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <47278825EB20CE489214915BDAC8133B@namprd02.prod.outlook.com>
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
	SvAVMbOBazy/EiXrxR7ROWC5PBoEu3KPOfuGVF8QOzJ720JmJw2Q4havurHEvdP3ZtIQHcsgYAqshk7YexhwN4V5XLEhr9qCm5S+uBBH2amcWPJaKV0DG5EGHpa+t4OIksmaIlRRpOwE4g36aFQBT5fMlwfkP1StLZAncSMGMqTxqOorJHf6M7u9sEyRKZuhtHUdud5ZP/O5qIdZcbU0kSxCsrgW2ca+O7ixbSQj0nFu0ebg3a347Vs8FYnDz7KdiVsBvq6l1ZtzI8CKYmMccWH3edUbZLY727TXU+iNdfwcUSpUA5l5BcJyPzGhmk6GVZ7DSI34Wm91enOwXiY2RQ==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb91370d-b341-4c5d-0899-08df3013019f
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Oct 2026 08:03:49.9442
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9F3AKSuTeMhtDFADuvbrRnJpNZv8YY7CDzUocUwHCiU/LjUXD0qf2nbGWyihjmFjJu/M7Iqw0zmw1NAyKrpHib7T1iwwH8kv0FlVGJKHYhA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR02MB464239
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIyMDAzMSBTYWx0ZWRfXzv/eCCkEZqI1
 QdbZIrF8f1NhcUZrF91eK4hRHc8Rij1oqKAa7rjkOXPQNP9izfi06+i56EJW1f8IiN3GcE4dYYD
 ub77b2V3/ZfTNVlSfg7IeErWk1pDETY=
X-Authority-Analysis: v=2.4 cv=cLl1IVeN c=1 sm=1 tr=0 ts=6ad9c368 cx=c_pps
 a=pCScd9Md5F2Oib7HHR5gBQ==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=660iZSQnnn4A:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VofLwUrZ8Iiv6rRUPXIb:22 a=Ap8k9tRZuQ82DLYWQqG7:22 a=20KFwNOVAAAA:8
 a=64Cc0HZtAAAA:8 a=pQWVBxlGKqhegC0iRGIA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: 6R8HgdZcctynOvqcEiMES1VZ63vwn_Cd
X-Proofpoint-GUID: 6R8HgdZcctynOvqcEiMES1VZ63vwn_Cd
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIyMDAzMSBTYWx0ZWRfX3/8V3s9uu+9b
 DbICGPDFjyXshCBH56eYY88AqtoMZT/U9i0LnueCbWh1+18vNGLuAYiDag6KJ6EBzcf17rshhdi
 HiKhB+w43r96wPYZ0Aq9AeP6V2Yo7MJvnm3vhBNf7JUkaoJ0DfuUaDoV95KJKTGg2E+XyUZeL+S
 X4pjOtwEgtnYl3EgvCzwhVyfwSd/kt2WD3QY496Wg0o3ZdYuZXWR4Q98gKxzODuttccHTl5Sk80
 dPBFCJ9wcNM9+nEEOVuqAXVC/KLrWc1E8Mssqftoc8ib1p9ctYowKDdTL6vP+vsys83WXolfLem
 jZkbZhlRbiAAgpmsBO4TCxLDHhqr3NbHq0/ZKRLMfyFer8gNPit04xoTQX/KCPjV8ASHT8D/C9V
 uvGMtpJL8ELURiVso1wlHW1TliX9OaCKcdIantv2pisYqd9eIUBkg5u6ltVs79fNrG0OJYFVOPu
 pwEGafiEmrJBmlE/weQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-22_03,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gMTUgT2N0IDIwMjYsIGF0IDY6NDLigK9QTSwgRXJpYyBBdWdlciA8ZXJpYy5hdWdl
ckByZWRoYXQuY29tPiB3cm90ZToNCj4gDQo+ICEtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tfA0KPiAgQ0FVVElPTjogRXh0
ZXJuYWwgRW1haWwNCj4gDQo+IHwtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tIQ0KPiANCj4gSGkgS2h1c2hpdCwNCj4gDQo+
IE9uIDkvMjEvMjYgMjozMiBQTSwgS2h1c2hpdCBTaGFoIHdyb3RlOg0KPj4gVW5kZXIgS1ZNLCB0
aGUgZ3Vlc3QgUE1VIGlzIGJhY2tlZCBieSB0aGUgaG9zdCBQTVUgKGV2ZW50IHNldCwgUE1DUi5O
LA0KPj4gYW5kIFBNQ0VJRCksIHdoaWNoIG1heSBub3QgYmUgcG9ydGFibGUgYWNyb3NzIGhldGVy
b2dlbmVvdXMgaG9zdHMuDQo+PiANCj4+IERpc2FibGUgUE1VIHN1cHBvcnQgZm9yIG5hbWVkIENQ
VSBtb2RlbHMgYnkgY2xlYXJpbmcgQVJNX0ZFQVRVUkVfUE1VIGluDQo+PiB0aGUgbmFtZWQtbW9k
ZWwgaW5pdCBwYXRoIHNvIGFybV9jcHVfcG9zdF9pbml0KCkgZG9lcyBub3QgY3JlYXRlIHRoZQ0K
Pj4gInBtdSIgcHJvcGVydHkuDQo+IA0KPiBUbyBtZSBpdCBzaGFsbCBiZSBwb3NzaWJsZSB0byB0
dXJuIFBNVSBvbiBldmVuIG9uIG5hbWVkIG1vZGVsLiBJDQo+IHVuZGVyc3RhbmQgaXQgbWF5IGNy
ZWF0ZSBtaWdyYXRpb24gaXNzdWVzIGR1ZSB0byB0aGUgSFcgYWRoZXJlbmNlIGJ1dCB5ZXQuDQo+
IEkgdGhpbmsgb24geDg2IHlvdSBjYW4gdXNlIC1jcHUgSGFzd2VsbC1JQlJTLHBtdT1vbi4NCj4g
DQpPa2F5LCBmaXhlZCBpbiB2NS4NCg0KVGhhbmtzLA0KS2h1c2hpdA0KDQo+IEVyaWMNCj4gDQo+
IA0KPj4gDQo+PiBTaWduZWQtb2ZmLWJ5OiBLaHVzaGl0IFNoYWggPGtodXNoaXQuc2hhaEBudXRh
bml4LmNvbT4NCj4+IC0tLQ0KPj4gdGFyZ2V0L2FybS9jcHUtbW9kZWxzLmMgfCA0ICsrKysNCj4+
IDEgZmlsZSBjaGFuZ2VkLCA0IGluc2VydGlvbnMoKykNCj4+IA0KPj4gZGlmZiAtLWdpdCBhL3Rh
cmdldC9hcm0vY3B1LW1vZGVscy5jIGIvdGFyZ2V0L2FybS9jcHUtbW9kZWxzLmMNCj4+IGluZGV4
IGZlZDMxOTcxODYuLjE1M2VlMTBhZTYgMTAwNjQ0DQo+PiAtLS0gYS90YXJnZXQvYXJtL2NwdS1t
b2RlbHMuYw0KPj4gKysrIGIvdGFyZ2V0L2FybS9jcHUtbW9kZWxzLmMNCj4+IEBAIC0xNTksNiAr
MTU5LDEwIEBAIHN0YXRpYyB2b2lkIGFybV9uYW1lZF9jcHVfaW5pdGZuKE9iamVjdCAqb2JqKQ0K
Pj4gICAgIC8qIDEuYiBQcm9wZXJseSBzZXQgUkVTMSBmaWVsZHMuICovDQo+PiAgICAgcmVzZXRf
cmVzMV9maWVsZHMoY3B1KTsNCj4+IA0KPj4gKyAgICAvKiBEaXNhYmxlIFBNVSBmb3IgbmFtZWQg
Q1BVIG1vZGVscy4gKi8NCj4+ICsgICAgdW5zZXRfZmVhdHVyZSgmY3B1LT5lbnYsIEFSTV9GRUFU
VVJFX1BNVSk7DQo+PiArICAgIGNwdS0+aGFzX3BtdSA9IGZhbHNlOw0KPj4gKw0KPj4gICAgIC8q
IDIuIEFkZCBzdmVOTk5OIGFuZCBTWVNSRUdfIHByb3BlcnRpZXMgKi8NCj4+ICAgICBhYXJjaDY0
X2FkZF9zdmVfcHJvcGVydGllcyhvYmopOw0KPj4gICAgIGFhcmNoNjRfYWRkX2lkcmVnc19wcm9w
ZXJ0aWVzKG9iaik7DQo+IA0KDQo=
