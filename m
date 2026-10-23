Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.155.12
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792736762;
	b=RWXRfO1dg8kGOGCuwxKSuooNccsprWbMUV30AO4Z2rRTsTD5BnDs9wTS5nFgMaBJX8+O
	 AY5dBLTQniiuyNqMsFYBa/ynQgNFUrvFJOj+SBxEocsP6ykeVRNgDxJvickMd2l3+OMUN
	 YyP8RhsLhx+Qvc5lXophuk1T7qacyfeYlhYc+RkolMsMFtq2otjtfm1Evx2TRZGLwWh6s
	 +fGxoan8TX7qeLSBPgl2X6NIzLMEC89dw83Bmrnsr+5UY4Z80579IgcVnyuxJoXOqHx5A
	 RC36WCs8kSGICZ5ADDUnhk8w6rVMxKXKqNdrvswSIb0P2RSH6BbGwKYSu5bv6sZpstg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792736762;
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
	bh=JIti3vUnhSTeqRKAYGAnLQu+jzSydFYH8KVNvzl42wc=;
	b=pWNZ43Pm/f00cpLLuFmqrKZSIBZIAODrQpN2FzUQJvfSaodbg5DRfxL//b36YDhzLEtH
	 dZ5y71Z0lFJ1631jHRvpQMy8shPHmTz1qgBLUw0eOKpuOPZtiZkqpnBn9cVbXC9oqVzt1
	 3jFA5ok9OJ9hBZbL25nzoyZGWqatrshksB8cWTytQCMuVxMcIwr9NufDpgzXrBuWmcjxo
	 HezF9D1H1441xh5BqSc22io1rPyF/rsu/vbyMpsNffW6M3NIqgvSSHMOxk5j9+7sC6I9X
	 rO1yYjDMNV2mvZkvIy/03c7uO64M5FOJUfeN102GtpZdho9o7CFvmWMMWprxn8lX4oA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nutanix.com;
	spf=pass smtp.mailfrom=nutanix.com;
	dkim=pass header.d=nutanix.com header.i=@nutanix.com header.a=rsa-sha256 header.s=proofpoint20171006 header.b=EpBNt7lh;
	dkim=pass header.d=nutanix.com header.i=@nutanix.com header.a=rsa-sha256 header.s=selector1 header.b="TEk/j2di";
	arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.155.12
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 964ED606A31A
	for <kvmarm@lists.linux.dev>; Fri, 23 Oct 2026 06:26:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 964ED606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=nutanix.com header.i=@nutanix.com header.a=rsa-sha256 header.s=proofpoint20171006 header.b=EpBNt7lh;
	dkim=pass (2048-bit key, unprotected) header.d=nutanix.com header.i=@nutanix.com header.a=rsa-sha256 header.s=selector1 header.b=TEk/j2di
Received: from pps.filterd (m0127843.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69N1FRTu2303352;
	Thu, 22 Oct 2026 23:25:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=JIti3vUnhSTeqRKAYGAnLQu+jzSydFYH8KVNvzl42
	wc=; b=EpBNt7lhMKG47oVI+H1ZguSf9L30xW4LAh0YW4XACvZxT0bmn4Dk8n51e
	CWmJFUqy9GEMgjsRbP+psfoGwXEzQkY5EaBiq7afwEKrzJ19tMFTbtzTtzg7pzPg
	VunHSVfWs510nUKgAeoH9EX7fC5Hx4rYNxsQEqqDpRlsDYtPk9vR0d7rLDVCkWNy
	9Ypq+NVsUYyOc/yxac05ilesbl3J8zpfax+bKvqRd0VCcHvUR1TP81sNUAMejina
	MJoXj98ucm8Nrbyrn6LxAEjGxu6GJeQVjwSuvBMChKHrKPge38BOyEIYY5unRkx3
	gep0ooQc0PywjTFJFPwoaM8JTHr/Q==
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11023100.outbound.protection.outlook.com [40.93.201.100])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4hf973ktt1-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 22 Oct 2026 23:25:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ugd5n65f0wBRU9ZUBHQ8fvtKS1XDE+dwM6SOlfqvs1ae/6Qqv/cipAvHeK9s/C8ZRec6+y+27e+Yl7/pQbi3l5hRxnUzEp6MrqklnCi5cbpQaXqoGeiqjoyTxEXEd/ij+3CcffiF0uNt78x8YaHdTL+/bebrSQsqVbFEs2fpIze+Y0mCPlzBXFQDQMmogpDj7hoyF+g2gYnzhrymxJYhV0kNgkPHTz8xJXXAvoYonHuV+CvVu1NmD6UIiOZjrUN0V7+1X4GJVWz1XlVVMSYRVh1GfnUF7wV0du3GJMidNvxy1eGllvjsj1rEVXLDEnRWGOjrBc5MtwL/DY6g5kpgsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JIti3vUnhSTeqRKAYGAnLQu+jzSydFYH8KVNvzl42wc=;
 b=FmwpDyeoaXmHSnLV5BucdBmtFCXM9EEJ+7H3vswU4RmL8JRG3Dk5IA6BV/v2CBTXHWZfeRxjoPUEj4ELGZb+Vu6cDiityM1f9aQ6VfPDmQH3Gjyb0doDaDVrtowttMaovEvPHvZl7vc7faNfPBAHECuPtRUD3WUogicrErmLjvXq3fSVuF0QLmgTH/TZQdxvklZcD0UAzOnaaaMh4j2Kef6QiRiWKIhcWx7Lc2hg6RrrRv6IkSYHs2lM6jS+MV4bPIgn3s96LBs3Y5bPVOskAIKIfIGGFnVNYSdmMFrIRI5oOwGoyxgLwdtlNHF+o4O7whjlxiAxfPPw0f5cVE+TQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JIti3vUnhSTeqRKAYGAnLQu+jzSydFYH8KVNvzl42wc=;
 b=TEk/j2diZmIU7cZWd4CvHu4n3F28K5rkKtuUpycgVtyu6x4LDEyKzIEJXV1eG2IgiHOcN8DwaZPysgJ40jd5UKf8SGZNIcwJ0VFy4v9fH6Roa08l5sywkVLQLieHv7wGdvL+MaW8m8c6nk5hu8SbM0OPrONDZORpjV4p0IlJn5HerOuDhlJlLTF6Za/l78oq179eD9B/8jYtwmeMlNHBDUwBJGDPJMFn7kPNRXYbxcuhK/73EjCR6SHkNJYAWV1snGqd8LBvGvtv5Q0uilBHNdQ21yfVO2GADC4WQdrIXQ2MzQwk9N9e5W05tZnQOnIazjCdZFRgmrVSijEeQp1E/g==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by DM8PR02MB8170.namprd02.prod.outlook.com (2603:10b6:8:1b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.16; Fri, 23 Oct
 2026 06:25:41 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%5]) with mapi id 15.21.0546.017; Fri, 23 Oct 2026
 06:25:40 +0000
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
Subject: Re: [RFC PATCH v4 20/25] target/arm/kvm: compute host-supported
 values for ID register fields
Thread-Topic: [RFC PATCH v4 20/25] target/arm/kvm: compute host-supported
 values for ID register fields
Thread-Index: AQHdScVtG+tDlIZGkE2qutFe3cZ23rcAS8yAgAqPQgA=
Date: Fri, 23 Oct 2026 06:25:40 +0000
Message-ID: <44FAD132-5FCA-4194-BB10-AA2B86EB6027@nutanix.com>
References: <20260921123249.1708067-1-khushit.shah@nutanix.com>
 <20260921123249.1708067-21-khushit.shah@nutanix.com>
 <3e20590e-4276-4166-91d4-47db4875543b@redhat.com>
In-Reply-To: <3e20590e-4276-4166-91d4-47db4875543b@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nutanix.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA2PR02MB7564:EE_|DM8PR02MB8170:EE_
x-ms-office365-filtering-correlation-id: ccac6ed9-0d5a-4ff0-d91b-08df30ce75dd
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|7416014|23010399003|1800799024|366016|261021130227099003|261022105027099003|56012099006|38070700021|261022075727099003|4143699003|261021123027099003|261021121427099003|261021133027099003|261021135927099003|261009223027099003|10067099003|18002099003|22082099003|3023799007|261022115727099003|261022113327099003;
x-microsoft-antispam-message-info:
 CNTOnmzv5lt2qoxXiakQQKFOvkDfXNZA6Pa1k4F+48fTRx0Ao9w8RdttQzXYSqBYMeWqMdePgbw3BIpg7PXvLfNRiZXgtExeTQAUjH4nbnDccHvUJVfMhPiLRnXPDlCl4YeDDJEX0+5RVZme+2rMtG64j+GlsWnAblbBHU4LTZsmspvJNgLlw8HPdreAqcUuG0RlxfPr5M1e2HpXbQWxwkTQk/vV5PequzwzoliTebEXE3inedXVkbcuyYxq4cEa8/eN0xAoY44c7UttkX+6A7FRQO8268zg4y5GZ1WPVpVWA7kUvE5r1vHxPz0mdDFIRW2EKQHRmU2fGppu1zb2rNVADzo17t1jWp5nSq9TRI1hPPrlDpJ12f1OlVZb+PBdv0Jr+4bsLd+cyHoE5CnfqSRfbOExhaMnC/Baf5xTnXuEVNFH11IpQ19qJI+C0I52QcbHYQUeBUVj+edCmWwDg4k2oTmNYjM7Xdvbua0WcuoIgGhIbP+VL9RS7BPOwzdX6sr27OBsKCkuqvllEn9YrywL5RCcJviCcBBGeTkGY61oS/5XxwORHM7ocuxGsjkeAQCfkyzBRVKTvf6ozQAGChwzTiUnnrhjRsMS1CEnykeODN9ErkS03fDHaEeXmbmnMF+2ru1VeR5DmCOtbLDIVb9hRbHK/YXo6Xdpck3giVHyDOX3xzg+iHxrXr95rqoP0JVcmhXQu8al77TVnQQtk9yIJFEPuNtbyeMLIdhSgJU=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(1800799024)(366016)(261021130227099003)(261022105027099003)(56012099006)(38070700021)(261022075727099003)(4143699003)(261021123027099003)(261021121427099003)(261021133027099003)(261021135927099003)(261009223027099003)(10067099003)(18002099003)(22082099003)(3023799007)(261022115727099003)(261022113327099003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?dWJDVVFEOERXM0p2TWxSRUJDbXU4bVR4S0EzaWN0VkZKUXQwOENmYUxnVFRl?=
 =?utf-8?B?UFlBRGFBM3hjMmJhdzAyN3ZKNFNmYzRsa3dyWmRYOUFqVWJDWUxXS1JEQmY2?=
 =?utf-8?B?UnlDQm9RcW01QTc0ZmlzY2ROZnAzRm05ZGVZSXkreWV0dldwT0VTS2Y5OG5K?=
 =?utf-8?B?MXBLNVZ1a1RXeGJZc0hubHpBVXdIeHZ0WGFZM1ZPYTFoN3JSWHlzL2pZREMx?=
 =?utf-8?B?NHBrQzZKNFVnQWRDdUlOV0h3QkY0cFlJRGRjTE9VVnVmNzRXM1ZMbEdySFZW?=
 =?utf-8?B?d3RYOWkwenBEeDdFeDJpU1o0Zm1IM2YyQVJCdWo5bkpJdWJhR0RmZmt2MTVk?=
 =?utf-8?B?TkZQSnRJZG1qQkFROEpDN2YvVGwyZzZXWnZFb2YwajEwdER2SEY1RkxaL3Jt?=
 =?utf-8?B?TllKQzBWT0NVd3Y5aGtJTWR3VUdRTFZnbW1ESENObGZWbGRLT3BzVTg4N0Nz?=
 =?utf-8?B?RmJWbFhMclVVVDZZTmpkY3gycjBqSWZZS1p5anBlWDlvR1BsOHJveHJsbVlE?=
 =?utf-8?B?ZUUrb2l1clNTRGFML3BSdWFZYVprVzRXN0tMRVM5NFV0MHRFZndLczdleEs2?=
 =?utf-8?B?L3hUNXBma1hIQnFXQm53UFRUK3lPM05SaEtqWmFVZUpTSDF0OThjd1ZkLzgx?=
 =?utf-8?B?ZXhGbmZiMkY1NmQ4Qzk5ZEFsNVIxRGxwWUJ0eHlRREllTlVwazhLTk1KRUpZ?=
 =?utf-8?B?cDhhZk13M0dERFl5S2sxZzFQZjYrbXB6VDh0UDhLdUhjREZXejlhTjZpOFRM?=
 =?utf-8?B?TFNPUmQyWWVGZFBueG5iUlBSb1hYTjN1T21IY1FMLzU2YkFURE9mU0pPSFRH?=
 =?utf-8?B?Mlg4RGMrTlJiM3FUQlkydDJtTWN0T0Y2VVhiU0Z5SlFvbjh0M1piZnJ0cndx?=
 =?utf-8?B?eGtMbkVOSXMwWTE2Y2tXTEk1Nm5EN2lQSGxHVFJ5dG5EUHV4dWI0ZG9CN2NB?=
 =?utf-8?B?dVY4ZU9aREV6VWI2WEV2aitTUjdaU0l6cU5GRUhLQ09WQnhZNExaQmNad1h0?=
 =?utf-8?B?ZXNnM1YrM3NZRXBGZ3Vsc3hnbVNPdWpXbUJKSDdGa3kyMC9vVU9LSmJxMWtv?=
 =?utf-8?B?cG5XZmk3KzV5ZENGaCt0WFNiQU41cndYK0prK3pjZ0NUc2llRW04MkJtYUlR?=
 =?utf-8?B?VE9EZmRqVlBoL3hKM1plZTNkWGh4czRuSzZzT2lDeTZkRWE2NVNxWjVzUnBY?=
 =?utf-8?B?VmM0T09lRWtVdzNjMEo1MzlSOXdwcjhSYkk4WEpyRzE4Q1Vsd1VUZStUclZl?=
 =?utf-8?B?Y2pHZzhoV3EvKzNzRmJQR2luUWtPS3EyUGRpM2lJanVYeVN6ZHZOR1N3YU84?=
 =?utf-8?B?Qm1NemQvVnI4NGVDWmIxbER5N2lQb2tHVFFzd1VVL2E3cVRSQUs2N1B3OFhI?=
 =?utf-8?B?aGlJRkVHTGI4Y2FWVURCSEZ0MVVHNVNrQnpDTXhZQ1VhRDhDQjAvWlJnMVFB?=
 =?utf-8?B?Y2hObElUaUJSVHJSTmRHZElTbUdxaklBMU81Umw5N3dNdS9ITElpZDR1RWRW?=
 =?utf-8?B?Y2lGaDR0V1Z3TXhtZWZZU1hRaDBEaGlGeVRCNThZclVwNTVJWnFZT1JybTcv?=
 =?utf-8?B?eXpsbFRDSjNDOTZXU3lQRTVIM1Z2dVhveTVMdzdQcHZTckFmNzV1ZzdiTnYz?=
 =?utf-8?B?Q2t6UW00ZGtZOCtmZkNrcXIxYi81K0xPQ1JTV3hwMW9UQ2I2Qmh3NlZZVU9O?=
 =?utf-8?B?dFgwY0hFMFFnY3A5Z25PRjBiL0ppQUxvOXRoaEErUHFVNHF4clVOaXJyK2k3?=
 =?utf-8?B?ZUhWTGF0QlBOWEtzWmhWZmtJcTFVVFVJUHVSUGowaWFkOHZzeDF2WDJCZHpl?=
 =?utf-8?B?bUpRRCs2WjJQcHh2QjlGdC9mMGVFNFZYcnZ6cTY3TGlQUlVOdnlPcjcwRXcz?=
 =?utf-8?B?L3duV2hYSC9GZDJMT1NpZkhoSUZGZU11T1FucTR0SW5xMFQ5RGIvZGtiUzV4?=
 =?utf-8?B?VXk0U2RONFR2ck1IRWtoaXgvNzlQZHpsRktTRE14UThBNVpCcENTK2lLRXdM?=
 =?utf-8?B?ZkFLY1VhcFZrVGlPZlh6ZlcySWpMSm1lL3pranF1bktVK1pHa2d0VWllK0p1?=
 =?utf-8?B?d3BMV0hERFRueEFUaUpqSm0ya1g5ZE5QNEpUVE5WUmI0RUFWK0lIYVM0Yk8v?=
 =?utf-8?B?S2Jaa3NTYkRST0VYS1pDWnEzbFZxZVZYWW5xbHFrY3oxYncyNEwzUWx6K0E4?=
 =?utf-8?B?MzlYeTJjR2J5SGdrUGFnUmdFNFNmNWJabldjbG05S1k5NzFydnFieXBUZ3g3?=
 =?utf-8?B?MUEzWTRpYmsxcXprekNWTGYrMVEweHhUM1RBeStxa2tIWC8vZktwUXEvajEw?=
 =?utf-8?B?T3EvOXZ1MElOZm9TanVPd2lHUmN6NDM2NjQyZXlTdDZ2MnFzMGE2SzRpSk9x?=
 =?utf-8?Q?p4rpMvwHvlxQuPU0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9D20F01FC2D0F740AE8CAA8C5336AE9E@namprd02.prod.outlook.com>
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
	W2za9sO4cmZGvQBJ3sfROhiJQVVFnO5Rj4G5Y267pnmlKqBVdWBDLjIFQKbS95NQQ1F4pbHab9O0p/TtlseSwZ4FKTYIF/MtprXkJ6vJt+gZcWGjhBSUunDpGcNuU1kxAIwj26uptHYDwidBubz+PD9ohAUFjZXIBMu36isD56fqtitaJxyrJ79u9dr+V+HA1loF8+zZLsdxn92xE0BkRSc+j9GQXPd9Z6c74qPRPUW99uRaa3N+Y2fBaF8QtkgCRq6ZZFCvJI4dnju5VP8wq1UTN/1IXW08O2ZWNV0eOlyKcOGZvtSprD5tc41+J+f3eDjdMyw02DeOMy5Tw5HmFA==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ccac6ed9-0d5a-4ff0-d91b-08df30ce75dd
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Oct 2026 06:25:40.8488
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PxlYRAjlCX1zo48SpuWgmhH3j8UnqagzT6VGtaAGgM6YtPWENok5pKZvvRJYwHCqtGzDkSYyTgRWw39bg2s8Ut4y8SosNLORw2osFvXbNn8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR02MB8170
X-Authority-Analysis: v=2.4 cv=E8NYNqdl c=1 sm=1 tr=0 ts=6adafde6 cx=c_pps
 a=RZStT+UEo2YVQxgsfJfMbA==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=660iZSQnnn4A:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VofLwUrZ8Iiv6rRUPXIb:22 a=dEe9Ve2bX-KnNSUMM2s9:22 a=20KFwNOVAAAA:8
 a=64Cc0HZtAAAA:8 a=pBU68f9MOgnd-DjW0cUA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIzMDAyNSBTYWx0ZWRfX0nrkAlyCI9+Y
 uc2O3LMmYtnXVIrUy1Lw9V5dq1vr/3O4pt38eCbEUblLwNV4BjV/wTPrQVhcMZfGxP8QSo1m9v3
 3w6HpCSunOTRwnAoHihA8qJzcw7FUloEK8jumBaqh2ogrYhLm9s9xPQHZ37Us9ym9gTJpZQJLse
 2E6lz0o6tCNYpagKi5erpuWI7mX9AWvbHLjhHRU1y9oOmj01YbivYLSB+gtloulDZ9illsmqR8S
 2b7X2TVSWxfrY9SeYPftWhZUjUOEGMt16R4C12MijkY62F/bX060W8bPHzGZXh9xlO9GlPTBOz+
 gUQFPvbYJgpy1l/A8uSvnkWG8a+NzTP/j1a3Ux7zW82m2g5OkkzJrzpCwhUVUrETULB16fHLBPH
 DDUNCecYHBtDVAL7+MjRVs9+3qC6FNfd16imWdz4vHnt3N3jfHkrE8oNOkwJn7r/xeNNswRzpAG
 xTX1hfzZMe+HyRSRZAQ==
X-Proofpoint-GUID: OT-PBUCUqai7axZKLJ3md2194hMu9TnM
X-Proofpoint-ORIG-GUID: OT-PBUCUqai7axZKLJ3md2194hMu9TnM
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIzMDAyNSBTYWx0ZWRfX9vrArb8QtP9U
 pTtt+MItTY+G4nvVCJndtM9EyDc5tL2qTXGCBhqTJb2t2awDzWUcr/w3Gbd7+zNVCK4mkw3DW41
 S2yzY+HqXCoqVKCI+FfNXxMPCqAOi4E=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-23_01,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gMTYgT2N0IDIwMjYsIGF0IDY6NDDigK9QTSwgRXJpYyBBdWdlciA8ZXJpYy5hdWdl
ckByZWRoYXQuY29tPiB3cm90ZToNCj4gDQo+ICEtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tfA0KPiAgQ0FVVElPTjogRXh0
ZXJuYWwgRW1haWwNCj4gDQo+IHwtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tIQ0KPiANCj4gSGkgS2h1c2hpdCwNCj4gDQo+
IE9uIDkvMjEvMjYgMjozMiBQTSwgS2h1c2hpdCBTaGFoIHdyb3RlOg0KPj4gQWRkIGt2bV9hcm1f
ZmllbGRfZ2V0X3N1cHBvcnRlZF92YWx1ZXMoKSB3aGljaCwgZm9yIGEgZ2l2ZW4gSUQgcmVnaXN0
ZXINCj4+IGZpZWxkLCBidWlsZHMgdGhlIHNldCBvZiB2YWx1ZXMgS1ZNIGFsbG93cyBpdCB0byB0
YWtlIG9uIHRoZSBnaXZlbiBob3N0Lg0KPj4gDQo+PiBOb24td3JpdGFibGUgZmllbGRzIGFyZSBw
aW5uZWQgdG8gdGhlIGhvc3QgdmFsdWUuIFdyaXRhYmxlIGZpZWxkcyBmb2xsb3cNCj4+IHRoZWly
IHBlci1maWVsZCBjb25zdHJhaW50cy4gVGhpcyBmdW5jdGlvbiBtdXN0IGJlIHVwZGF0ZWQgd2hl
biBLVk0NCj4+IHN0YXJ0cyBleHBvc2luZyBhIG5ldyB3cml0YWJsZSBmaWVsZCB0aGF0IGlzIG5v
dCBsb3dlci1zYWZlOyBoZW5jZSB0aGUNCj4+IHNwZWNpYWwgaGFuZGxpbmcgb2YgVEdyYW5YXzIv
U3BlY1NFSS9MMUlwL01JRFIvUkVWSURSL0FJRFIuDQo+IA0KPiBUaGlzIGVmZmVjdGl2ZWx5IGFk
dm9jYXRlcyBmb3IgaGF2aW5nIGEgc25hcHNob3Qgb2YgYWxsIHRoZSBJRFJFR1MgdGhhdA0KPiBh
cmUga25vd24gdG8gYmUgd3JpdGFibGUgYW5kIGhhbmRsZWQgYnkgdGhlIHFlbXUgY29kZS4gQmVj
YXVzZSBvdGhlcndpc2UNCj4gd2UgbWF5IHJldHVybiB3cm9uZyBzYWZlIHZhbHVlcyBmb3IgYSBn
aXZlbiBwcm9wLg0KDQpPa2F5IEkgd2lsbCBhZGQgYSBzbmFwc2hvdCBvZiB3cml0YWJsZSBmaWVs
ZHMgaW4gUUVNVSBhbmQgd2Ugd2lsbCB0cmVhdA0KYSBmaWVsZCBhcyB3cml0YWJsZSBvbmx5IGlm
IGl0IGlzIHdyaXRhYmxlIGluIEtWTSBhbmQgaW4gUUVNVeKAmXMgbGlzdC4NCg0KPiANCj4+IHNp
Z25lZC1vZmYtYnk6IEtodXNoaXQgU2hhaCA8a2h1c2hpdC5zaGFoQG51dGFuaXguY29tPg0KPj4g
DQo+PiAtLS0tLS0tLQ0KPj4gTm90ZToNCj4+IC0gV2Ugc2hvdWxkIGhhdmUgYW4gYXV0aG9yaXRh
dGl2ZSBzdGF0aWMgbGlzdCBvZiAid3JpdGFibGUiIGZpZWxkcyBpbg0KPj4gIFFFTVUuDQo+PiAt
LS0NCj4+IHRhcmdldC9hcm0va3ZtLXN0dWIuYyB8ICA3ICsrKw0KPj4gdGFyZ2V0L2FybS9rdm0u
YyAgICAgIHwgOTkgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKw0K
Pj4gdGFyZ2V0L2FybS9rdm1fYXJtLmggIHwgMjggKysrKysrKysrKysrDQo+PiAzIGZpbGVzIGNo
YW5nZWQsIDEzNCBpbnNlcnRpb25zKCspDQo+PiANCj4+IGRpZmYgLS1naXQgYS90YXJnZXQvYXJt
L2t2bS1zdHViLmMgYi90YXJnZXQvYXJtL2t2bS1zdHViLmMNCj4+IGluZGV4IGQyNjNhZGM5MjEu
LmM5Y2Q0N2JmNDcgMTAwNjQ0DQo+PiAtLS0gYS90YXJnZXQvYXJtL2t2bS1zdHViLmMNCj4+ICsr
KyBiL3RhcmdldC9hcm0va3ZtLXN0dWIuYw0KPj4gQEAgLTE0NCwzICsxNDQsMTAgQEAgdm9pZCBr
dm1fYXJtX2Rlc3Ryb3lfc2NyYXRjaF9ob3N0X3ZjcHUoaW50ICpmZGFycmF5KQ0KPj4gew0KPj4g
ICAgIGdfYXNzZXJ0X25vdF9yZWFjaGVkKCk7DQo+PiB9DQo+PiArDQo+PiArdm9pZCBrdm1fYXJt
X2ZpZWxkX2dldF9zdXBwb3J0ZWRfdmFsdWVzKGNvbnN0IEFSTTY0U3lzUmVnRmllbGQgKmZpZWxk
LA0KPj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBjb25zdCBBUk1J
U0FSZWdpc3RlcnMgKmhvc3RfaXNhciwNCj4+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgQXJtRmllbGRWYWx1ZVNldCAqKnZhbHVlX3NldCkNCj4+ICt7DQo+PiArICAg
IGdfYXNzZXJ0X25vdF9yZWFjaGVkKCk7DQo+PiArfQ0KPj4gZGlmZiAtLWdpdCBhL3RhcmdldC9h
cm0va3ZtLmMgYi90YXJnZXQvYXJtL2t2bS5jDQo+PiBpbmRleCA2ZjcwNGMwNTA5Li43N2IxYmNk
ZjU1IDEwMDY0NA0KPj4gLS0tIGEvdGFyZ2V0L2FybS9rdm0uYw0KPj4gKysrIGIvdGFyZ2V0L2Fy
bS9rdm0uYw0KPj4gQEAgLTEzMjQsNiArMTMyNCwxMDUgQEAgYm9vbCBrdm1fYXJtX2NwdV9wb3N0
X2xvYWQoQVJNQ1BVICpjcHUpDQo+PiAgICAgcmV0dXJuIHRydWU7DQo+PiB9DQo+PiANCj4+ICtz
dGF0aWMgYm9vbCBhcm1fZmllbGRfaXNfc2lnbmVkKGNvbnN0IEFSTTY0U3lzUmVnRmllbGQgKmZp
ZWxkKQ0KPj4gK3sNCj4+ICsgICAgcmV0dXJuIGZpZWxkX21hdGNoZXMoZmllbGQsIElEX0FBNjRN
TUZSMF9FTDFfSURYLCAiVEdyYW40IikgICAgfHwNCj4+ICsgICAgICAgICAgIGZpZWxkX21hdGNo
ZXMoZmllbGQsIElEX0FBNjRNTUZSMF9FTDFfSURYLCAiVEdyYW42NCIpICAgfHwNCj4+ICsgICAg
ICAgICAgIGZpZWxkX21hdGNoZXMoZmllbGQsIElEX01NRlIwX0VMMV9JRFgsICJJbm5lclNociIp
ICAgICAgfHwNCj4+ICsgICAgICAgICAgIGZpZWxkX21hdGNoZXMoZmllbGQsIElEX01NRlIwX0VM
MV9JRFgsICJPdXRlclNociIpICAgICAgfHwNCj4+ICsgICAgICAgICAgIGZpZWxkX21hdGNoZXMo
ZmllbGQsIElEX0FBNjRERlIwX0VMMV9JRFgsICJEb3VibGVMb2NrIikgfHwNCj4+ICsgICAgICAg
ICAgIGZpZWxkX21hdGNoZXMoZmllbGQsIElEX0FBNjRERlIwX0VMMV9JRFgsICJQTVVWZXIiKSAg
ICAgfHwNCj4+ICsgICAgICAgICAgIGZpZWxkX21hdGNoZXMoZmllbGQsIElEX0RGUjBfRUwxX0lE
WCwgIlBlcmZNb24iKSAgICAgICAgfHwNCj4+ICsgICAgICAgICAgIGZpZWxkX21hdGNoZXMoZmll
bGQsIElEX0FBNjRQRlIxX0VMMV9JRFgsICJNVEVfZnJhYyIpICAgfHwNCj4+ICsgICAgICAgICAg
IGZpZWxkX21hdGNoZXMoZmllbGQsIElEX0FBNjRNTUZSNF9FTDFfSURYLCAiRTJIMCIpICAgICAg
fHwNCj4+ICsgICAgICAgICAgIGZpZWxkX21hdGNoZXMoZmllbGQsIElEX0RGUjFfRUwxX0lEWCwg
Ik1UUE1VIikgICAgICAgICAgfHwNCj4+ICsgICAgICAgICAgIGZpZWxkX21hdGNoZXMoZmllbGQs
IElEX0FBNjRQRlIwX0VMMV9JRFgsICJGUCIpICAgICAgICAgfHwNCj4+ICsgICAgICAgICAgIGZp
ZWxkX21hdGNoZXMoZmllbGQsIElEX0FBNjRQRlIwX0VMMV9JRFgsICJBZHZTSU1EIik7DQo+PiAr
fQ0KPj4gKw0KPj4gK3N0YXRpYyB2b2lkIHJhbmdlc19hZGQoR0FycmF5ICpyYW5nZXMsIHVpbnQ2
NF90IG1pbiwgdWludDY0X3QgbWF4KQ0KPj4gK3sNCj4+ICsgICAgQXJtRmllbGRSYW5nZSByID0g
eyAubWluID0gbWluLCAubWF4ID0gbWF4IH07DQo+PiArICAgIGdfYXJyYXlfYXBwZW5kX3ZhbChy
YW5nZXMsIHIpOw0KPj4gK30NCj4+ICsNCj4+ICt2b2lkIGt2bV9hcm1fZmllbGRfZ2V0X3N1cHBv
cnRlZF92YWx1ZXMoY29uc3QgQVJNNjRTeXNSZWdGaWVsZCAqZmllbGQsDQo+PiArICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGNvbnN0IEFSTUlTQVJlZ2lzdGVycyAqaG9z
dF9pc2FyLA0KPj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBBcm1G
aWVsZFZhbHVlU2V0ICoqdmFsdWVfc2V0KQ0KPj4gK3sNCj4+ICsgICAgYm9vbCBpc19zaWduZWQg
PSBhcm1fZmllbGRfaXNfc2lnbmVkKGZpZWxkKTsNCj4+ICsgICAgdWludDY0X3QgaG9zdCA9IGV4
dHJhY3Q2NChob3N0X2lzYXItPmlkcmVnc1tmaWVsZC0+aW5kZXhdLA0KPj4gKyAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgIGZpZWxkLT5zaGlmdCwgZmllbGQtPmxlbmd0aCk7DQo+PiArICAg
IEdBcnJheSAqcmFuZ2VzID0gZ19hcnJheV9uZXcoZmFsc2UsIGZhbHNlLCBzaXplb2YoQXJtRmll
bGRSYW5nZSkpOw0KPj4gKw0KPj4gKyAgICAvKiBBIG5vbi13cml0YWJsZSBmaWVsZCBjYW4gb25s
eSBldmVyIGhvbGQgdGhlIGhvc3QgdmFsdWUuICovDQo+PiArICAgIGlmICghYXJtX2ZpZWxkX2lz
X3dyaXRhYmxlKGZpZWxkKSkgew0KPj4gKyAgICAgICAgcmFuZ2VzX2FkZChyYW5nZXMsIGhvc3Qs
IGhvc3QpOw0KPj4gKyAgICAgICAgZ290byBkb25lOw0KPj4gKyAgICB9DQo+PiArDQo+PiArICAg
IGlmIChmaWVsZF9tYXRjaGVzKGZpZWxkLCBJRF9BQTY0TU1GUjBfRUwxX0lEWCwgIlRHcmFuNF8y
IikgIHx8DQo+PiArICAgICAgICBmaWVsZF9tYXRjaGVzKGZpZWxkLCBJRF9BQTY0TU1GUjBfRUwx
X0lEWCwgIlRHcmFuMTZfMiIpIHx8DQo+PiArICAgICAgICBmaWVsZF9tYXRjaGVzKGZpZWxkLCBJ
RF9BQTY0TU1GUjBfRUwxX0lEWCwgIlRHcmFuNjRfMiIpKSB7DQo+PiArICAgICAgICAvKiBFaXRo
ZXIgc3VwcG9ydCB0aGUgaG9zdCB2YWx1ZSBvciB0aGUgIm9mZiIgdmFsdWUgKi8NCj4+ICsgICAg
ICAgIHJhbmdlc19hZGQocmFuZ2VzLCBob3N0LCBob3N0KTsNCj4+ICsgICAgICAgIGlmIChob3N0
ICE9IDEpIHsgLyogMSA9ICJvZmYiICovDQo+PiArICAgICAgICAgICAgcmFuZ2VzX2FkZChyYW5n
ZXMsIDEsIDEpOw0KPiB0aG9zZSBhcmUgdGFnZ2VkIHdpdGggU0FGRV9FWEFDVCBwb2xpY3kgaW4g
dGhlIGtlcm5lbC4gQ291bGQgeW91IGVsYWJvcmF0ZT8NCg0KU29tZSBmaWVsZHMgYXJlIFNBRkVf
RVhBQ1QgaW4ga2VybmVsLCBiZWNhdXNlIG9ubHkg4oCcbm90LWltcGxlbWVudGVk4oCdIG9yIA0K
SG9zdCB2ZXJzaW9uIGNhbiBiZSBzYWZlbHkgZW11bGF0ZWQuIEZvciBleGFtcGxlLCBQQXV0aCwg
ZWl0aGVyIFBBdXRoID0gMCwNCmlzIHNhZmUgb3IgUEF1dGggPSBob3N0IGltcGxlbWVudGF0aW9u
IGlzIHNhZmUuDQoNCkFub3RoZXIgZXhhbXBsZSBvZiB0aGlzIGlzIGdyYW51bGFyIHNpemUsIFlv
dSBjYW5ub3Qgc2hvdyBhIDY0S0Igc3VwcG9ydCBpZg0KdGhlIGhvc3QgZG9lcyBub3Qgc3VwcG9y
dCBpdC4NCg0KPj4gKyAgICAgICAgfQ0KPj4gKyAgICB9IGVsc2UgaWYgKGZpZWxkX21hdGNoZXMo
ZmllbGQsIENUUl9FTDBfSURYLCAiTDFJcCIpKSB7DQo+PiArICAgICAgICAvKiBPbmx5IHNhZmUg
dG8gZG93bmdyYWRlIHRvIFZJUFQsIG90aGVyIHZhbHVlcyBhcmUgcmVzZXJ2ZWQuICovDQo+PiAr
ICAgICAgICByYW5nZXNfYWRkKHJhbmdlcywgaG9zdCwgaG9zdCk7DQo+PiArICAgICAgICBpZiAo
aG9zdCAhPSAyKSB7IC8qIDIgPSAiVklQVCIgKi8NCj4+ICsgICAgICAgICAgICByYW5nZXNfYWRk
KHJhbmdlcywgMiwgMik7DQo+ICpJRF9BQTY0RlBGUjBfRUwxX0Y4KiBoYWxzIGhhdmUqIEVYQUNU
IHBvbGljeSBhbmQgSSBkb24ndCBzZWUgdGhlbQ0KPiBzcGVjaWFsIGNhc2VkIGhlcmUuDQpBbGwg
ZmllbGRzIGFyZSBzaW5nbGUgYml0cy4gU28gTE9XRVJfU0FGRSBpcyBzYW1lIGFzIEVYQUNULg0K
DQpUaGFua3MsDQpLaHVzaGl0DQo+PiArICAgICAgICB9DQo+PiArICAgIH0gZWxzZSBpZiAoZmll
bGRfbWF0Y2hlcyhmaWVsZCwgSURfQUE2NE1NRlIxX0VMMV9JRFgsICJTcGVjU0VJIikgfHwNCj4+
ICsgICAgICAgICAgICAgICBmaWVsZF9tYXRjaGVzKGZpZWxkLCBJRF9NTUZSNF9FTDFfSURYLCAi
U3BlY1NFSSIpKSB7DQo+PiArICAgICAgICAvKiBJdCBpcyBzYWZlIHRvIHVwZ3JhZGUgU3BlY1NF
SSB0byAxLCBvdGhlciB2YWx1ZXMgYXJlIHJlc2VydmVkLiAqLw0KPj4gKyAgICAgICAgcmFuZ2Vz
X2FkZChyYW5nZXMsIGhvc3QsIGhvc3QpOw0KPj4gKyAgICAgICAgaWYgKGhvc3QgIT0gMSkgew0K
Pj4gKyAgICAgICAgICAgIHJhbmdlc19hZGQocmFuZ2VzLCAxLCAxKTsNCj4+ICsgICAgICAgIH0N
Cj4+ICsgICAgfSBlbHNlIGlmIChmaWVsZC0+aW5kZXggPT0gTUlEUl9FTDFfSURYIHx8DQo+PiAr
ICAgICAgICAgICAgICAgZmllbGQtPmluZGV4ID09IFJFVklEUl9FTDFfSURYIHx8DQo+PiArICAg
ICAgICAgICAgICAgZmllbGQtPmluZGV4ID09IEFJRFJfRUwxX0lEWCkgew0KPj4gKyAgICAgICAg
LyoNCj4+ICsgICAgICAgICAqIE5vIHJlc3RyaWN0aW9uIG9uIHZhbHVlIHRoYXQgY2FuIGJlIHNl
dCBmb3IgaW1wbGVtZW50YXRpb24gSUQNCj4+ICsgICAgICAgICAqIHJlZ2lzdGVycyBmaWVsZHMu
DQo+PiArICAgICAgICAgKi8NCj4+ICsgICAgICAgIHVpbnQ2NF90IG1heCA9IDA7DQo+PiArICAg
ICAgICBpZiAoZmllbGQtPmxlbmd0aCA9PSA2NCkgew0KPj4gKyAgICAgICAgICAgIG1heCA9IH4w
VUxMOw0KPj4gKyAgICAgICAgfSBlbHNlIHsNCj4+ICsgICAgICAgICAgICBtYXggPSAoMVVMTCA8
PCBmaWVsZC0+bGVuZ3RoKSAtIDE7DQo+PiArICAgICAgICB9DQo+PiArICAgICAgICByYW5nZXNf
YWRkKHJhbmdlcywgMCwgbWF4KTsNCj4+ICsgICAgfSBlbHNlIHsNCj4+ICsgICAgICAgIC8qDQo+
PiArICAgICAgICAgKiBBZnRlciBoYW5kbGluZyB0aGUgc3BlY2lhbCBjYXNlcywgb3RoZXIgd3Jp
dGFibGUgZmllbGRzIGFyZQ0KPj4gKyAgICAgICAgICogZWl0aGVyIGxvd2VyLXNhZmUgb3Igc2ln
bmVkIGxvd2VyLXNhZmUuDQo+PiArICAgICAgICAgKi8NCj4+ICsgICAgICAgIGlmIChmaWVsZC0+
YXJjaF92YWxzX2NvdW50KSB7DQo+PiArICAgICAgICAgICAgZm9yICh1aW50MzJfdCBpID0gMDsg
aSA8IGZpZWxkLT5hcmNoX3ZhbHNfY291bnQ7IGkrKykgew0KPj4gKyAgICAgICAgICAgICAgICB1
aW50NjRfdCBhdiA9IGZpZWxkLT5hcmNoX3ZhbHNbaV07DQo+PiArICAgICAgICAgICAgICAgIGlu
dDY0X3QgdiA9IGlzX3NpZ25lZCA/DQo+PiArICAgICAgICAgICAgICAgICAgICBzZXh0cmFjdDY0
KGF2LCAwLCBmaWVsZC0+bGVuZ3RoKSA6IChpbnQ2NF90KWF2Ow0KPj4gKyAgICAgICAgICAgICAg
ICBpbnQ2NF90IGh2ID0gaXNfc2lnbmVkID8NCj4+ICsgICAgICAgICAgICAgICAgICAgIHNleHRy
YWN0NjQoaG9zdCwgMCwgZmllbGQtPmxlbmd0aCkgOiAoaW50NjRfdClob3N0Ow0KPj4gKyAgICAg
ICAgICAgICAgICBpZiAodiA8PSBodikgew0KPj4gKyAgICAgICAgICAgICAgICAgICAgcmFuZ2Vz
X2FkZChyYW5nZXMsIGF2LCBhdik7DQo+PiArICAgICAgICAgICAgICAgIH0NCj4+ICsgICAgICAg
ICAgICB9DQo+PiArICAgICAgICB9IGVsc2Ugew0KPj4gKyAgICAgICAgICAgIGdfYXNzZXJ0KCFp
c19zaWduZWQpOyAvKiBObyBzaWduZWQgZmllbGQgd2l0aCBubyBhcmNoIHZhbHMgKi8NCj4+ICsg
ICAgICAgICAgICByYW5nZXNfYWRkKHJhbmdlcywgMCwgaG9zdCk7DQo+PiArICAgICAgICB9DQo+
PiArICAgIH0NCj4+ICtkb25lOg0KPj4gKyAgICAqdmFsdWVfc2V0ID0gZ19uZXcwKEFybUZpZWxk
VmFsdWVTZXQsIDEpOw0KPj4gKyAgICAoKnZhbHVlX3NldCktPm5fcmFuZ2VzID0gcmFuZ2VzLT5s
ZW47DQo+PiArICAgICgqdmFsdWVfc2V0KS0+cmFuZ2VzID0gKEFybUZpZWxkUmFuZ2UgKilnX2Fy
cmF5X2ZyZWUocmFuZ2VzLCBmYWxzZSk7DQo+PiArfQ0KPj4gKw0KPj4gc3RhdGljIGJvb2wgYXJt
X2ZpZWxkX3NraXBfd3JpdGViYWNrX2Fsd2F5cyhjb25zdCBBUk02NFN5c1JlZ0ZpZWxkICpmaWVs
ZCkNCj4+IHsNCj4+ICAgICAvKg0KPj4gZGlmZiAtLWdpdCBhL3RhcmdldC9hcm0va3ZtX2FybS5o
IGIvdGFyZ2V0L2FybS9rdm1fYXJtLmgNCj4+IGluZGV4IDRlNTYzZmFiOTYuLjk0ODFlNTY0MTIg
MTAwNjQ0DQo+PiAtLS0gYS90YXJnZXQvYXJtL2t2bV9hcm0uaA0KPj4gKysrIGIvdGFyZ2V0L2Fy
bS9rdm1fYXJtLmgNCj4+IEBAIC0xNzUsNiArMTc1LDM0IEBAIGludCBrdm1fYXJtX3JlYWRfc3lz
X3JlZzY0KGludCBmZCwgdWludDY0X3QgKnZhbCwNCj4+ICAqLw0KPj4gdm9pZCBrdm1fYXJtX2Fk
ZF92Y3B1X3Byb3BlcnRpZXMoQVJNQ1BVICpjcHUpOw0KPj4gDQo+PiArdHlwZWRlZiBzdHJ1Y3Qg
QVJNNjRTeXNSZWcgQVJNNjRTeXNSZWc7DQo+PiArdHlwZWRlZiBzdHJ1Y3QgQVJNNjRTeXNSZWdG
aWVsZCBBUk02NFN5c1JlZ0ZpZWxkOw0KPj4gK3R5cGVkZWYgc3RydWN0IEFSTUlTQVJlZ2lzdGVy
cyBBUk1JU0FSZWdpc3RlcnM7DQo+PiArDQo+PiArdHlwZWRlZiBzdHJ1Y3QgQXJtRmllbGRSYW5n
ZSB7DQo+PiArICAgIHVpbnQ2NF90IG1pbjsNCj4+ICsgICAgdWludDY0X3QgbWF4Ow0KPj4gK30g
QXJtRmllbGRSYW5nZTsNCj4+ICsNCj4+ICt0eXBlZGVmIHN0cnVjdCBBcm1GaWVsZFZhbHVlU2V0
IHsNCj4+ICsgICAgQXJtRmllbGRSYW5nZSAqcmFuZ2VzOw0KPj4gKyAgICBzaXplX3Qgbl9yYW5n
ZXM7DQo+PiArfSBBcm1GaWVsZFZhbHVlU2V0Ow0KPj4gKw0KPj4gKy8qKg0KPj4gKyAqIGt2bV9h
cm1fZmllbGRfZ2V0X3N1cHBvcnRlZF92YWx1ZXM6DQo+PiArICogQGZpZWxkOiBUaGUgZmllbGQg
dG8gZ2V0IHRoZSBzdXBwb3J0ZWQgdmFsdWVzIGZvcg0KPj4gKyAqIEBob3N0X2lzYXI6IFRoZSBo
b3N0IElTQVIgcmVnaXN0ZXJzDQo+PiArICogQHZhbHVlX3NldDogVGhlIHNldCBvZiBzdXBwb3J0
ZWQgdmFsdWVzIGZvciB0aGUgQGZpZWxkDQo+PiArICoNCj4+ICsgKiBXaWxsIGJlIGFsbG9jYXRl
ZCBhbmQgZmlsbGVkIGluIHdpdGggdGhlIHN1cHBvcnRlZCB2YWx1ZXMgZm9yIHRoZSBAZmllbGQN
Cj4+ICsgKiBiYXNlZCBvbiB0aGUgaG9zdF9pc2FyIGFuZCB3aGV0aGVyIHRoZSBmaWVsZCBpcyB3
cml0YWJsZSBvciBub3QuDQo+PiArICogVGhlIGNhbGxlciBtdXN0IGZyZWUgdGhlIHZhbHVlX3Nl
dC4NCj4+ICsgKi8NCj4+ICt2b2lkIGt2bV9hcm1fZmllbGRfZ2V0X3N1cHBvcnRlZF92YWx1ZXMo
Y29uc3QgQVJNNjRTeXNSZWdGaWVsZCAqZmllbGQsDQo+PiArICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgIGNvbnN0IEFSTUlTQVJlZ2lzdGVycyAqaG9zdF9pc2FyLA0KPj4g
KyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBBcm1GaWVsZFZhbHVlU2V0
ICoqdmFsdWVfc2V0KTsNCj4+ICsNCj4+IC8qKg0KPj4gICoga3ZtX2FybV9zdGVhbF90aW1lX2Zp
bmFsaXplOg0KPj4gICogQGNwdTogQVJNQ1BVIGZvciB3aGljaCB0byBmaW5hbGl6ZSBrdm0tc3Rl
YWwtdGltZQ0KPiBFcmljDQo+IA0KDQo=
