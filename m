Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.155.12
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792669501;
	b=bt/5aqvNthu9AaAwG3ZYtJsT7zv5jvWz4SkuiWoIgBmzNPFwijAPAJAOeQkJ68ufQ8V5
	 OtmTH2Dfhz+lrdnFWeR/ay0dnX36jWjesRrQoBAU1LB5bHYlsnJ64TVEMSbjodbK6a4hr
	 gWkkGwQpTuFbMPGBEJudjua8JjNm2RqGtlD2eCTqvC65d0W7wBaaGZubOBbKQn5mWgxST
	 RElixFizEochwk72Qv64/gQE1w1gTsPGBzvs5qNkkgw1iMrLEALP9WI/LF8/sCL+m569u
	 4C09JsVdsQIWrTwNnjnPmde72XVDDex3vgCE6NL0e41MUCs89tKDzGj1irNbpjlPUMQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792669501;
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
	bh=kqQwIKP/rg3U6EnIw0UA9I5OywpAcB+hklj0LuQNb5o=;
	b=aQOGMH1REVu5J3ct1BQBqfiEAk/aJhMtfi18q746+lXJCxS8gbVIy0uobx3ni9Nony9m
	 LH04++J1jOUQfn/rmhNd5IApC5dPjEOHwRdFNq7lCtNsQ4cJj12SXZJqghVZoe5rLMPN+
	 AWhqT9XuB/BPx8OBXswaLRRzphvR5IlsIdxvpla7r5O6eeNW9C2tf2XhVkFNq/GFt+hgG
	 2jw2jU1JmduyCa5YtGgVZVqCTIMLFUPmwuj0wLpNhXolCofzbQNYTs7OItZgJqPPuJtP5
	 XdtMVmOpM+AULICe4kXWnOc5puNWjJTw/HAJqYm5/2Ru1o/Z/or1vNFqpvcZusCShbA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nutanix.com;
	spf=pass smtp.mailfrom=nutanix.com;
	dkim=pass header.d=nutanix.com header.i=@nutanix.com header.a=rsa-sha256 header.s=proofpoint20171006 header.b=0GaE3Tqy;
	dkim=pass header.d=nutanix.com header.i=@nutanix.com header.a=rsa-sha256 header.s=selector1 header.b=QnDnfjkR;
	arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.155.12
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A40A4606A31E
	for <kvmarm@lists.linux.dev>; Thu, 22 Oct 2026 11:45:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A40A4606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=nutanix.com header.i=@nutanix.com header.a=rsa-sha256 header.s=proofpoint20171006 header.b=0GaE3Tqy;
	dkim=pass (2048-bit key, unprotected) header.d=nutanix.com header.i=@nutanix.com header.a=rsa-sha256 header.s=selector1 header.b=QnDnfjkR
Received: from pps.filterd (m0127843.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69M9xuJJ307176;
	Thu, 22 Oct 2026 04:44:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=kqQwIKP/rg3U6EnIw0UA9I5OywpAcB+hklj0LuQNb
	5o=; b=0GaE3TqyYztIJrib776UDJdzpgCqVRFjksbWtKMPPeih47HWk7WLfjUP8
	rvxVKrq2F7lphlQp902gZUgROTz+/H2aOZWPcC9htTEUsg0UgbHpmT6e0Hc8dppI
	FRydXCDvuLbPr9bfbNCkhyWkP2zEZZnqxhUZeDIqZ6SYCX+udUcKX+JdTUhT1GDo
	2/SxI0U53jjKIcyuxYc9OPZlsGkLCIMlO6gt1djMV0LkCsus+w/CH8ojvtEqalFD
	eTbXQgCNEPINwPp22VwW4cgCE6ZTJ9mf+ZTcKJOiQBn3Jyqp0B9qD0UPp9Q1Jk2v
	Xjtz7xRQQKqSoLq/F94wOC2yHvFnA==
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11020139.outbound.protection.outlook.com [52.101.201.139])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4hf973hb6b-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 22 Oct 2026 04:44:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=b8gq8YwudtcBizffacolPB3Vu2/PXXDWE2aGxD18vXpIDDe/pb3X8XxcU6aM8mYIgh34aGTD2BAFTE6aWzl8A08D6UoQqmYLfmCK094bcNWyGztlF7xQE0RaaC2yr7eEmi5+7yTMNDxrJCnHwoniamYccFr9Ce83lE04o/qUsXhba/+FdpQVhkdVv3UuhVR/UD2ZIWg7NX455zCqU1n7gOM2kwgdH64grxiEZzcwry1Kj3ln8bfDX+SAZDkf9AJfhyxzTkH6UQTGuvQZAQa0b9DaWq64MKzpCBwv3z7d5QzvyRIMdE7eQyZAc9KFt1AKGfMa8SqPdTwiTLr43QqcAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kqQwIKP/rg3U6EnIw0UA9I5OywpAcB+hklj0LuQNb5o=;
 b=vdbawAsWKX5tl8mgR0dmmFZTa4gsCXdZNn0Wu/0OwzrBpv9PJZ6j4dnFnAPsjrFXXkUAlMMslIMobbLlebJx5cF6R5gcFL8IV/1nGXsqW2mC7Gqok9vcvO6VK1Xrnq61nSDI5DsYSUzvd8mv9Kk5/Usk2TQwqhtWP1zIRQNZqpER1sL3+DXF9DYDY2slyCJKUJlWw5PVEsV6IOFuqQQ9QgtL/wQxwXvRsvgqa97OxE9zT3ObXAYrEg70y24dG6VYRlqv0z0SzMIV3wpCRlnpl2rT/e5H6p7serxiSo5AEW13CbY7fET8qSueTHou5yZhfJ17TfF6qLNH6eHZkydgxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kqQwIKP/rg3U6EnIw0UA9I5OywpAcB+hklj0LuQNb5o=;
 b=QnDnfjkReH8ZyRMJszTMvUPsVLJBWqM+RCrqeybbv9Crn+dYj9A19zy1orLjY2y5goa2Nm3Q6l/CCd0DsxWw5TUlLyLi2OPaJPPkiwuBSXXU8nT6Dp/L0+GzK/lmnaEu22XnPW/m4wCkABWVPYt76381+x0WCaflODFkNgg5hnDdpINti0GgD+QBOnmN92SE0aEle5KgV2kF7gMThsxd3Ror2AfWs8eyvPnQTK0qBn+i2sj8XXDA6qE9EKOlDuY/Bng4aPA4MWXbteo+e+ZjcRX2y3fSz+2FpT0cnXEnUJQtM3iH4YlJrYZfPWcWoom6Bj8BWDnWZLcATskPbPUDqA==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by IA4PR02MB382684.namprd02.prod.outlook.com (2603:10b6:207:104::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.15; Thu, 22 Oct
 2026 11:44:45 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%5]) with mapi id 15.21.0546.012; Thu, 22 Oct 2026
 11:44:45 +0000
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
Subject: Re: [RFC PATCH v4 25/25] target/arm/qmp: hook blockers in
 query-cpu-definitions
Thread-Topic: [RFC PATCH v4 25/25] target/arm/qmp: hook blockers in
 query-cpu-definitions
Thread-Index: AQHdScVvsm74oQku9UaW0lMsdBSaurcAWEuAgAlJlAA=
Date: Thu, 22 Oct 2026 11:44:45 +0000
Message-ID: <4E792D20-AFAC-4BB2-A88A-6412E8D58465@nutanix.com>
References: <20260921123249.1708067-1-khushit.shah@nutanix.com>
 <20260921123249.1708067-26-khushit.shah@nutanix.com>
 <89403aff-9082-40fb-bd62-a13638bde9f7@redhat.com>
In-Reply-To: <89403aff-9082-40fb-bd62-a13638bde9f7@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nutanix.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA2PR02MB7564:EE_|IA4PR02MB382684:EE_
x-ms-office365-filtering-correlation-id: 4b80f00e-e421-4959-a176-08df3031de6e
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|23010399003|1800799024|366016|376014|7416014|18002099003|22082099003|10067099003|261021130227099003|261021121427099003|3023799007|261021135927099003|261021123027099003|38070700021|4143699003|261009223027099003|261009220027099003|261009221727099003|261009223327099003|261009221227099003|261021133027099003|5023799004|56012099006;
x-microsoft-antispam-message-info:
 flsf3UZQ9GcK0nw7qe+6uA+Ypk9RRaUMqbuTAZea6I6cMJN8AZ7+GZHUVzPOhV3lP0CuuKQrhl5lSn2HvBJkOpYWhCavUkFIXSkLJ+gu5d7eQcvwmCeQmHRjpBReDgTk+UPywWXLqILy3cfUZaMYv7zireuUKMxJ1NaqxuCfpNJo0+0UqyZ1bT+F84CW0GKH8bkFXdwf5grm8iB+wqZSJJNeYBSlnGcMtKMHKIOXv59NisSiGPKoWgwG2BBfPPFki5CPyQKDoETktJuM8YWeGgI2yvyXcLFdlRlUaudksVcovf0nr0iRL/Pd2ZRG9lBrWxCpLYoVWiHMN1aLqfbdhMWbHDCyG1VziiNM/HDO4bX1CZbTTSopdO0oJYREb8zpl0y8DmAPRTOmGoie9xO+cP+9GvRrIVHHGqxdE7hgco3Oi29OZOUoSrx0K24hbfjqH/hp/sMsDo+y2BOtxHXNxzjB0crraiLlQ2aglXIkGzGS56ji91WMDTfDYQX0Qn8Ixgyjaiao1OM5Fd7uiK2ykm6jeCjZp4WokBLMfdksj4Yuy9Vv+6K5LzEgjwOKYAzjnpeBVPYr7gQhXUPD22DUs7yMHRCvifWUBJ6Qkcfw8VmIZ0dQ3YUQb6x9SWt4GGE6oVr7ABoN3uve3KylYhK9A+jB8bjy6o0ZHJyz6pKCQ8kxVKNilAA4C06FZSHz8nx7AGU+vG10zT0DIl/YNfrY+HEMxLAqeHbmtMOEpVmtS38=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(376014)(7416014)(18002099003)(22082099003)(10067099003)(261021130227099003)(261021121427099003)(3023799007)(261021135927099003)(261021123027099003)(38070700021)(4143699003)(261009223027099003)(261009220027099003)(261009221727099003)(261009223327099003)(261009221227099003)(261021133027099003)(5023799004)(56012099006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?ZDZ3VG1iQjJpeENhNUpPZnlZTHdSdno0U2UvTzNZaittWVhUMFA4SzVPNUt4?=
 =?utf-8?B?N3ZYTU5sUkdtM0M5NlNNdGZldUk1ejgxRzRHRDRnVHczUmZEZzZOUjdhY0x0?=
 =?utf-8?B?cFM3c3EyLy9STEJWUVZJVHlpbzdPZE9wUTY1VWF4aGg2UDJsS00vMnh0WlBP?=
 =?utf-8?B?WXFYQmpJYzJ4TjBVblkwMXNLdm9DZlZWSnBvR0NvL1RxR3d3Sjh2NXJRNk5z?=
 =?utf-8?B?Wlo4dlB0dXdpWEpvaTY3MnQxUTQ3YzkyZDZ5U1I4NlpjQ0hEU2RlRVJKQVll?=
 =?utf-8?B?TUdycHd5V2x6SlRTN25QdVNWdjdvWlY4WFJoZHZyVUp5cDdKVTRHM1FHQzlW?=
 =?utf-8?B?b2pPR3E1aFBnK3phbFFjTmpjc2E5VFVXaDNJeUxOZlF3VFJReUhyNkhad3dN?=
 =?utf-8?B?L1YyWFZrdTkyQTlTK0hxakJ5cnNHR1p5WGR4eTdMS0xabmdFeS9USWJjV1ha?=
 =?utf-8?B?Q2pxTWd4aFprRVFrNFhScDBiWE15S0prcXNOWVdibHpHL3hIYUZlRXhVVUYw?=
 =?utf-8?B?TGxlZzNhYTRVT0p0Y1kzSG4vYTU3QkR4bUU4ODZUMmtWRGE2cFFHckp1b2Nq?=
 =?utf-8?B?RHZSVktyY0NQWjc5MVJ2c3dOSWRxaElnOVFQUWlDUUdORDJBUHc1cllJTnZr?=
 =?utf-8?B?OEcxRWlXZlY5TEovSkpLR0F6bk1BR2Q4SEZuSDVPRjR1SVBhQmk0blBTQkJW?=
 =?utf-8?B?aDFpRG5FRkdPcnVmTXpPVC80TW5MWUtWaFRhcUtXb1YzZWR5dHFKL1ZwNmZH?=
 =?utf-8?B?cXJkSTBSZXRWc05LcXdXT2tteU9pZXNUdmJoY0lIMERuZGtzd3FRUS8wTTZF?=
 =?utf-8?B?S0l5VGVWU0FiWWEySytJbEpKaFNQMEpHQmtsZXA1clRlTm5BbEVIU2praFI2?=
 =?utf-8?B?cTNCYUhrNCt4c2xuUlQ1bXdiM2srb2RlaU4zYUlHRGRtY3I0U29jWjdxN1Zx?=
 =?utf-8?B?dnlOYWp6aVJDR2dtNGJUU1o4eHRERmdZMUdQVkMzRlpFZzdxaXFvNmVRbndL?=
 =?utf-8?B?L1hEcVF5aXNpSmpjZXZOOGdSYnhjQTFGeVZCcWllWmZBL2FJemI3T2hKZEQy?=
 =?utf-8?B?Zk1vdms2WVVsWFNkN3FGNWR5RTl5c3dzeUtaMUNnR2p6ZUtFSDhnTmFGb1Uz?=
 =?utf-8?B?MTF0dVJtZEFyNFdYSWtqdDhDNWhWZDdabDZsTDJ4Rk52am9Jc3AxNnZFbGVO?=
 =?utf-8?B?WlJzN2JDczYvN1J5dW02ZW5SWEgza1FqVUZWYlYyWTNJL2dGRkpSSWJiUnVu?=
 =?utf-8?B?VjRDVXpjMWZUTnhWQkx6NzIyaWZ6UWdqQktnRHBjaW55RWxFdGxSbGx1YVQ1?=
 =?utf-8?B?Z1hlcVdORzJOaVUreVRuV0dOQWYzMllMWHR4OHVUSkQydyt1enZHeDJoNEN6?=
 =?utf-8?B?MHV4STVqMEpxTktydS91elppRGx1eEVCZGVXbzk5eEYzdkEwYkltYjVwZUky?=
 =?utf-8?B?WHcxZkRlTjBUczlFSDB5MTBJUHFjc1F1TlBJRWhhVk44Y20xN1NKKzBnN216?=
 =?utf-8?B?V0hMM3hQUjd1VTJsL1IrQk1SbFB6VUlxVkFNd2tCdTVZSC9Edk96MWs5L3pJ?=
 =?utf-8?B?QnlUV0NSbWY4ajB6VFpTTmU5cTYwSU9KdkZNRlk1RXhXMW1qQTJzYXBLeDVD?=
 =?utf-8?B?NlIxNjJiN3Vva1NwZTFiOVdoMEhKdCtjelVaWkkxYUI2VTNENms3dGFXekly?=
 =?utf-8?B?TFVHNlFDK2lnN0tZOE5rT01VWkhBMXNtKzF6RmUvM0JpSGRTYUJqVFZtZUtZ?=
 =?utf-8?B?Q3c2UnB1SkR4ZU11L2FyODBDZlY4dE9HbzJNSm03ZkNQaTd5UDZhdDBXUk1X?=
 =?utf-8?B?ZkVZN1BhQnUwQm14WmZTWXcwL0xLejhZRHI4YkNOY09JTVV4RWR6czAyMjlR?=
 =?utf-8?B?T0xlMmJ4VzBZazdCZm56WVprTjJQQ1NpejA1WG5YUGw1OE5ZQ0ExSGVGOGxp?=
 =?utf-8?B?L2l2UWFyRmFUUmNaamtYZjY2L0d3VUJjWEd5TXpiRmVxUDB0MkZRVTJTdVRs?=
 =?utf-8?B?Zm5CeFJDYm5nWmlRRU5Xb011dUJzaTI4azRhVVJMdzg4ZlFxWDQ5OHlCUTB1?=
 =?utf-8?B?b3ZWSmtRZ3pYSEZRdzhZV045cmMzVldPQ1dVUFRuOCtXWVVuWUZ1dWdDaG5B?=
 =?utf-8?B?YnVOT3dnbDNwaHJSdTVWWVFTZzUwL3lqc1U1NTdJUWdxNjJUUVNia0dCRzVW?=
 =?utf-8?B?UG5CRExpYlNTcjlOamNla1RKRzdwTnhENWJ0QzRrSzRCaUtnT3k2VEI2aFpj?=
 =?utf-8?B?Uko4QjVISUQ3eHFVQkRKK1cxK0ZUeUl1QmRld25VbFRKVjhxcVF0UjdxTkU3?=
 =?utf-8?B?d2Z4VnptT0o2T1A3eDlXNUFveWFkZmJTTUNqNmI5TEFnYVRMZGVnTlFpSmF3?=
 =?utf-8?Q?vys1ybIao54vMQfI=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F45A3C3DF83B0B449088F465EF3EA516@namprd02.prod.outlook.com>
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
	n8MknfAi9RPMOSd2/8WbabFO0KQOTEqMznsqxW/3CBourJb3XqfXQttNhwExIl8MTRGSSmYTqq1BHkMBWKEe9Zenq8RO+ZUaCgAL/ru1Ya53zcmmJBLQ5J7ynTjhDR5iSQp1n7hDMo8Jh1StYdBy+KQlqj/OcGsndNNqrQJPN8zx2daBccwu6nRp205pwycUSM/sbmmXpfVc8xpqkiKzvl2czUL8qlP/oxxcnzQQmxf7D4H6i9XkCiBbMOxj8pl4Vr2tDbcrGKE+iHZRbiHQWolvgBnns7yomMl8jHz8dHeEWT99YMeQu43f92molw1s/OFc5r6ZHAPLT4UeJ4U9rg==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b80f00e-e421-4959-a176-08df3031de6e
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Oct 2026 11:44:45.3174
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UzD7WZfA6fDyHqH8CSkm+4b9XS/q0DxgyUYhmY5SiEQVkzQkXCUAYZ4RnhR1tyVBd4BIkr/Jr4jHfhvTq3m/TyYdEYK1QJhDRCy2EcAH2fk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR02MB382684
X-Authority-Analysis: v=2.4 cv=E8NYNqdl c=1 sm=1 tr=0 ts=6ad9f72f cx=c_pps
 a=m5u7UkoT2y3MSdrnBkr6Vg==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=660iZSQnnn4A:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VofLwUrZ8Iiv6rRUPXIb:22 a=dEe9Ve2bX-KnNSUMM2s9:22 a=20KFwNOVAAAA:8
 a=64Cc0HZtAAAA:8 a=lrzzh_0aCO1B9hj6pHwA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIyMDA0NiBTYWx0ZWRfX4YkRc+jVQ/3E
 iBzYySMo3Pb60FtnLb7dr3GHPKsvnk/oMD4/wfejwCvNYKkDlRYcHkjyXvkubNtTdQRb2DPqlbT
 Qbre81BkKfHlw1kP6m/ak6SyBjRqjolyO772bGUN0So2vFP140WUojGUWPxS9NzkP7kb8X59kx7
 Yv4XOcAmJGlOCqPENZfEb+Iff9Hd9Pjhe5sZ0Aq8SrNlFuu4IjnrLVEu2Cui2N1wJM05UBVbtNB
 +jx//kt5rss2HTfM/In8GBPEo1PVYhsmbAtGeyXN5pzmX4+QIcyrFfXEOyBegrSuehP0nUb0rNy
 Bz0uoMlMqSnT3Je611A2hM+SMKEwWohzb5GQzshCMloCuM5mHuzJ/6ZOg2gnzYPEFZgoOQ/p+Ih
 7ybZxhcHYVjvidENsqsUeKkuIRcjHJJN2Se8EZOkuibzaxrRinIinEyxv4TsknRtxZus6sv+0EK
 ya2YMDAuza4x4pdsXOA==
X-Proofpoint-GUID: iOJF3TDV03LvMh_l7RxZIeJuOQMBtPDx
X-Proofpoint-ORIG-GUID: iOJF3TDV03LvMh_l7RxZIeJuOQMBtPDx
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIyMDA0NiBTYWx0ZWRfX4p+FNA9XbD+B
 JmV4ScVg/66Rih5BIxWIgNMWOWW7g7mRUQ5JCe4bsD0LmSlr13cnBvhrmKcsgw0gZnPzDCB8BXy
 venXhVXSEXiyno6cdw9tTuYa6DwEusY=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-22_04,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gMTYgT2N0IDIwMjYsIGF0IDc6MjTigK9QTSwgRXJpYyBBdWdlciA8ZXJpYy5hdWdl
ckByZWRoYXQuY29tPiB3cm90ZToNCj4gDQo+ICEtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tfA0KPiAgQ0FVVElPTjogRXh0
ZXJuYWwgRW1haWwNCj4gDQo+IHwtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tIQ0KPiANCj4gSGksDQo+IA0KPiBPbiA5LzIx
LzI2IDI6MzIgUE0sIEtodXNoaXQgU2hhaCB3cm90ZToNCj4+IFJlcG9ydCBibG9ja2VycyBmb3Ig
bmFtZWQgQ1BVIG1vZGVscyBpbiBxdWVyeS1jcHUtZGVmaW5pdGlvbnMuDQo+PiANCj4+IEVmZmlj
aWVudGx5IGRvIHRoaXMgYnkgdmFsaWRhdGluZyB0aGUgcmVhbGl6ZWQgSUQgcmVnaXN0ZXIgdmFs
dWVzDQo+PiBhZ2FpbnN0IHRoZSBob3N0IHZhbHVlcy4gc3ZlTk5OTiBwcm9wZXJ0aWVzIG5lZWQg
c3BlY2lhbCBoYW5kbGluZw0KPj4gYmVjYXVzZSB0aGV5IGFyZSBub3Qgc3RvcmVkIGluIElEIHJl
Z2lzdGVycy4NCj4+IA0KPj4gVGhpcyB3YXksIHdlIG5lZWQgbm90IGluc3RhbnRpYXRlIGVhY2gg
bW9kZWwgdG8gY2hlY2sgaWYgaXQgY2FuIGJlDQo+PiByZWFsaXplZCBvbiB0aGUgaG9zdCwgYW5k
IHdlIGFsc28gZ2V0IGdyYW51bGFyIGluZm9ybWF0aW9uIGFib3V0IHRoZSBJRA0KPj4gcmVnaXN0
ZXIgZmllbGRzIGJsb2NraW5nIHJlYWxpemF0aW9uLg0KPj4gDQo+PiBJbnRyb2R1Y2UgYXJtX2Nw
dV9jbGFzc19jaGVja19taXNzaW5nX2ZlYXR1cmVzKCkgYW5kDQo+PiBrdm1fYXJtX2lkcmVnc19n
ZXRfYmxvY2tlcnMoKSB0byBhY2hpZXZlIHRoaXMuDQo+IA0KPiBJIHdvdWxkIHJlY29tbWVuZCB0
byBzaG93IGFuIGV4Y2VycHQgb2YgdGhlIG91dHB1dA0KQ292ZXIgbGV0dGVyIGFscmVhZHkgaGFz
IG9uZeKApiBXaWxsIGFkZCB0byBjb21taXQgbWVzc2FnZS4NCg0KVGhhbmtzLA0KS2h1c2hpdA0K
Pj4gDQo+PiBTaWduZWQtb2ZmLWJ5OiBLaHVzaGl0IFNoYWggPGtodXNoaXQuc2hhaEBudXRhbml4
LmNvbT4NCj4+IC0tLQ0KPj4gdGFyZ2V0L2FybS9hcm0tcW1wLWNtZHMuYyAgICB8IDEyICsrKysr
KysrKw0KPj4gdGFyZ2V0L2FybS9jcHUtbW9kZWxzLXN0dWIuYyB8ICA1ICsrKysNCj4+IHRhcmdl
dC9hcm0vY3B1LW1vZGVscy5jICAgICAgfCAzNSArKysrKysrKysrKysrKysrKysrKysrKysrDQo+
PiB0YXJnZXQvYXJtL2NwdS1tb2RlbHMuaCAgICAgIHwgIDIgKysNCj4+IHRhcmdldC9hcm0va3Zt
LmMgICAgICAgICAgICAgfCA1MCArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysN
Cj4+IHRhcmdldC9hcm0va3ZtX2FybS5oICAgICAgICAgfCAxMyArKysrKysrKysrDQo+PiA2IGZp
bGVzIGNoYW5nZWQsIDExNyBpbnNlcnRpb25zKCspDQo+PiANCj4+IGRpZmYgLS1naXQgYS90YXJn
ZXQvYXJtL2FybS1xbXAtY21kcy5jIGIvdGFyZ2V0L2FybS9hcm0tcW1wLWNtZHMuYw0KPj4gaW5k
ZXggYmE0ODhkNWMwMS4uZDgzN2VjNjY1MyAxMDA2NDQNCj4+IC0tLSBhL3RhcmdldC9hcm0vYXJt
LXFtcC1jbWRzLmMNCj4+ICsrKyBiL3RhcmdldC9hcm0vYXJtLXFtcC1jbWRzLmMNCj4+IEBAIC0z
NzksNiArMzc5LDE4IEBAIHN0YXRpYyB2b2lkIGFybV9jcHVfYWRkX2RlZmluaXRpb24oZ3BvaW50
ZXIgZGF0YSwgZ3BvaW50ZXIgdXNlcl9kYXRhKQ0KPj4gICAgIGluZm8tPm5hbWUgPSBjcHVfbW9k
ZWxfZnJvbV90eXBlKHR5cGVuYW1lKTsNCj4+ICAgICBpbmZvLT5xX3R5cGVuYW1lID0gZ19zdHJk
dXAodHlwZW5hbWUpOw0KPj4gDQo+PiArICAgIC8qIGNhbGN1bGF0ZSBibG9ja2VycyAqLw0KPj4g
KyAgICBpZiAoa3ZtX2VuYWJsZWQoKQ0KPj4gKyAgICAgICAgICAgICYmICFnX3N0cl9lcXVhbChp
bmZvLT5uYW1lLCAiaG9zdCIpDQo+PiArICAgICAgICAgICAgJiYgIWdfc3RyX2VxdWFsKGluZm8t
Pm5hbWUsICJtYXgiKQ0KPj4gKyAgICAgICAgICAgICYmIGFybV9maW5kX21vZGVsKGluZm8tPm5h
bWUpICE9IE5VTEwpIHsNCj4+ICsgICAgICAgIGFybV9jcHVfY2xhc3NfY2hlY2tfbWlzc2luZ19m
ZWF0dXJlcyhBUk1fQ1BVX0NMQVNTKG9jKSwNCj4+ICsgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAmaW5mby0+dW5hdmFpbGFibGVfZmVhdHVyZXMpOw0KPj4gKyAgICAgICAgaWYg
KGluZm8tPnVuYXZhaWxhYmxlX2ZlYXR1cmVzKSB7DQo+PiArICAgICAgICAgICAgaW5mby0+aGFz
X3VuYXZhaWxhYmxlX2ZlYXR1cmVzID0gdHJ1ZTsNCj4+ICsgICAgICAgIH0NCj4+ICsgICAgfQ0K
Pj4gKw0KPj4gICAgIFFBUElfTElTVF9QUkVQRU5EKCpjcHVfbGlzdCwgaW5mbyk7DQo+PiB9DQo+
PiANCj4+IGRpZmYgLS1naXQgYS90YXJnZXQvYXJtL2NwdS1tb2RlbHMtc3R1Yi5jIGIvdGFyZ2V0
L2FybS9jcHUtbW9kZWxzLXN0dWIuYw0KPj4gaW5kZXggNDhmNzEyZDY0OC4uMmQxYmU0OWUwYSAx
MDA2NDQNCj4+IC0tLSBhL3RhcmdldC9hcm0vY3B1LW1vZGVscy1zdHViLmMNCj4+ICsrKyBiL3Rh
cmdldC9hcm0vY3B1LW1vZGVscy1zdHViLmMNCj4+IEBAIC0xMSwzICsxMSw4IEBAIGNvbnN0IEFy
bU5hbWVkQ3B1TW9kZWwgKmFybV9maW5kX21vZGVsKGNvbnN0IGNoYXIgKm5hbWUpDQo+PiB7DQo+
PiAgICAgcmV0dXJuIE5VTEw7DQo+PiB9DQo+PiArDQo+PiArdm9pZCBhcm1fY3B1X2NsYXNzX2No
ZWNrX21pc3NpbmdfZmVhdHVyZXMoQVJNQ1BVQ2xhc3MgKmFjYywgc3RyTGlzdCAqKmJsb2NrZXJz
KQ0KPj4gK3sNCj4+ICsgICAgcmV0dXJuOw0KPj4gK30NCj4+IGRpZmYgLS1naXQgYS90YXJnZXQv
YXJtL2NwdS1tb2RlbHMuYyBiL3RhcmdldC9hcm0vY3B1LW1vZGVscy5jDQo+PiBpbmRleCA4NTVl
YjVlZTZiLi45NTkxYjZkYmZjIDEwMDY0NA0KPj4gLS0tIGEvdGFyZ2V0L2FybS9jcHUtbW9kZWxz
LmMNCj4+ICsrKyBiL3RhcmdldC9hcm0vY3B1LW1vZGVscy5jDQo+PiBAQCAtNDc3LDYgKzQ3Nyw0
MSBAQCBzdGF0aWMgdm9pZCBhcm1fbmFtZWRfY3B1X2luaXRmbihPYmplY3QgKm9iaikNCj4+ICAg
ICBhcm1fbmFtZWRfY3B1X3plcm9fdW5rbm93bl9mZWF0dXJlX2lkcyhjcHUsICZlcnJvcl9hYm9y
dCk7DQo+PiB9DQo+PiANCj4+ICt2b2lkIGFybV9jcHVfY2xhc3NfY2hlY2tfbWlzc2luZ19mZWF0
dXJlcyhBUk1DUFVDbGFzcyAqYWNjLCBzdHJMaXN0ICoqYmxvY2tlcnMpDQo+PiArew0KPj4gKyAg
ICBFcnJvciAqZXJyID0gTlVMTDsNCj4+ICsgICAgT2JqZWN0ICpvYmogPSBvYmplY3RfbmV3X3dp
dGhfY2xhc3MoT0JKRUNUX0NMQVNTKGFjYykpOw0KPj4gKyAgICBBUk1DUFUgKmNwdSA9IEFSTV9D
UFUob2JqKTsNCj4+ICsNCj4+ICsgICAgaWYgKCFrdm1fZW5hYmxlZCgpIHx8ICFhcm1fZmluZF9t
b2RlbChhY2MtPmluZm8tPm5hbWUpKSB7DQo+PiArICAgICAgICBnb3RvIG91dDsNCj4+ICsgICAg
fQ0KPj4gKw0KPj4gKyAgICBpZiAoY3B1X2lzYXJfZmVhdHVyZShhYTY0X3N2ZSwgY3B1KSkgew0K
Pj4gKyAgICAgICAgYWFyY2g2NF9jcHVfc3ZlX2ZpbmFsaXplKGNwdSwgJmVycik7DQo+PiArICAg
ICAgICBpZiAoZXJyKSB7DQo+PiArICAgICAgICAgICAgZXJyb3JfZnJlZShlcnIpOw0KPj4gKyAg
ICAgICAgICAgIGVyciA9IE5VTEw7DQo+PiArICAgICAgICAgICAgdWludDMyX3QgaG9zdF92cV9t
YXAgPSBjcHUtPnN2ZV92cS5zdXBwb3J0ZWQ7DQo+PiArICAgICAgICAgICAgdWludDMyX3QgbW9k
ZWxfdnFfbWFwID0gY3B1LT5zdmVfdnEubWFwOw0KPj4gKw0KPj4gKyAgICAgICAgICAgIGlmICgo
bW9kZWxfdnFfbWFwICYgaG9zdF92cV9tYXApICE9IG1vZGVsX3ZxX21hcCkgew0KPj4gKyAgICAg
ICAgICAgICAgICBmb3IgKGludCB2cSA9IDE7IHZxIDw9IEFSTV9NQVhfVlE7IHZxKyspIHsNCj4+
ICsgICAgICAgICAgICAgICAgICAgIHVpbnQzMl90IHZxX2JpdCA9ICgxIDw8ICh2cSAtIDEpKTsN
Cj4+ICsgICAgICAgICAgICAgICAgICAgIGlmICgobW9kZWxfdnFfbWFwICYgdnFfYml0KSAmJiAh
KGhvc3RfdnFfbWFwICYgdnFfYml0KSkgew0KPj4gKyAgICAgICAgICAgICAgICAgICAgICAgIFFB
UElfTElTVF9QUkVQRU5EKCpibG9ja2VycywNCj4+ICsgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgZ19zdHJkdXBfcHJpbnRmKCJzdmUlZCIsIHZxICogMTI4KSk7DQo+PiArICAgICAgICAgICAg
ICAgICAgICB9DQo+PiArICAgICAgICAgICAgICAgIH0NCj4+ICsgICAgICAgICAgICB9DQo+PiAr
ICAgICAgICB9DQo+PiArICAgIH0NCj4+ICsNCj4+ICsgICAga3ZtX2FybV9pZHJlZ3NfZ2V0X2Js
b2NrZXJzKGNwdSwga3ZtX2FybV9nZXRfaG9zdF9pc2FyKCksIGJsb2NrZXJzKTsNCj4+ICtvdXQ6
DQo+PiArICAgIG9iamVjdF91bnJlZihvYmopOw0KPj4gK30NCj4+ICsNCj4+IHZvaWQgYXJtX3Jl
Z2lzdGVyX25hbWVkX2NwdV9tb2RlbHModm9pZCkNCj4+IHsNCj4+ICAgICBzdGF0aWMgQVJNQ1BV
SW5mbyAqYXJtX25hbWVkX2NwdV9pbmZvczsNCj4+IGRpZmYgLS1naXQgYS90YXJnZXQvYXJtL2Nw
dS1tb2RlbHMuaCBiL3RhcmdldC9hcm0vY3B1LW1vZGVscy5oDQo+PiBpbmRleCAxNDQ3Nzg3NDRl
Li40MWJiMTVkOTI4IDEwMDY0NA0KPj4gLS0tIGEvdGFyZ2V0L2FybS9jcHUtbW9kZWxzLmgNCj4+
ICsrKyBiL3RhcmdldC9hcm0vY3B1LW1vZGVscy5oDQo+PiBAQCAtNCw2ICs0LDcgQEANCj4+IA0K
Pj4gI2luY2x1ZGUgInFhcGkvZXJyb3IuaCINCj4+ICNpbmNsdWRlICJxb20vb2JqZWN0LmgiDQo+
PiArI2luY2x1ZGUgImNwdS5oIg0KPj4gDQo+PiB0eXBlZGVmIGVudW0gQXJtTW9kZWxQcm9wVHlw
ZSB7DQo+PiAgICAgQVJNX01PREVMX1BST1BfQk9PTCwNCj4+IEBAIC0zMiw1ICszMyw2IEBAIHZv
aWQgYXJtX2FwcGx5X21vZGVsX3Byb3BzKE9iamVjdCAqb2JqLCBjb25zdCBBcm1Nb2RlbFByb3BW
YWx1ZSAqcHJvcHMsDQo+PiAgICAgICAgICAgICAgICAgICAgICAgICAgICBFcnJvciAqKmVycnAp
Ow0KPj4gdm9pZCBhcm1fcmVhbGl6ZV9tb2RlbF9jaGFpbihPYmplY3QgKm9iaiwgY29uc3QgQXJt
TmFtZWRDcHVNb2RlbCAqbW9kZWwsDQo+PiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIEVy
cm9yICoqZXJycCk7DQo+PiArdm9pZCBhcm1fY3B1X2NsYXNzX2NoZWNrX21pc3NpbmdfZmVhdHVy
ZXMoQVJNQ1BVQ2xhc3MgKmFjYywgc3RyTGlzdCAqKmJsb2NrZXJzKTsNCj4+IA0KPj4gI2VuZGlm
IC8qIEFSTV9DUFVfTU9ERUxTX0ggKi8NCj4+IGRpZmYgLS1naXQgYS90YXJnZXQvYXJtL2t2bS5j
IGIvdGFyZ2V0L2FybS9rdm0uYw0KPj4gaW5kZXggYmI3NGY4YzI3NC4uY2EzZGE4MDI2MiAxMDA2
NDQNCj4+IC0tLSBhL3RhcmdldC9hcm0va3ZtLmMNCj4+ICsrKyBiL3RhcmdldC9hcm0va3ZtLmMN
Cj4+IEBAIC0xNDg1LDYgKzE0ODUsNTYgQEAgYXJtX2ZpZWxkX3NraXBfd3JpdGViYWNrX2lmX25v
dF93cml0YWJsZShjb25zdCBBUk02NFN5c1JlZ0ZpZWxkICpmaWVsZCkNCj4+ICAgICByZXR1cm4g
ZmllbGRfbWF0Y2hlcyhmaWVsZCwgSURfREZSMF9FTDFfSURYLCAiUGVyZk1vbiIpOw0KPj4gfQ0K
Pj4gDQo+PiArdm9pZCBrdm1fYXJtX2lkcmVnc19nZXRfYmxvY2tlcnMoQVJNQ1BVICpjcHUsDQo+
PiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgY29uc3QgQVJNSVNBUmVnaXN0ZXJz
ICpob3N0X2lzYXIsDQo+PiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgc3RyTGlz
dCAqKmJsb2NrZXJzKQ0KPj4gK3sNCj4+ICsgICAgZm9yIChpbnQgaSA9IDA7IGkgPCBOVU1fSURf
SURYOyBpKyspIHsNCj4+ICsgICAgICAgIEFSTTY0U3lzUmVnICpyZWcgPSAmYXJtNjRfaWRfcmVn
c1tpXTsNCj4+ICsNCj4+ICsgICAgICAgIGlmICghcmVnLT5uYW1lKSB7DQo+PiArICAgICAgICAg
ICAgY29udGludWU7DQo+PiArICAgICAgICB9DQo+PiArDQo+PiArICAgICAgICBmb3IgKHVpbnQz
Ml90IGogPSAwOyBqIDwgcmVnLT5maWVsZHNfY291bnQ7IGorKykgew0KPj4gKyAgICAgICAgICAg
IGNvbnN0IEFSTTY0U3lzUmVnRmllbGQgKmZpZWxkID0gJnJlZy0+ZmllbGRzW2pdOw0KPj4gKyAg
ICAgICAgICAgIEFybUZpZWxkVmFsdWVTZXQgKnZzID0gTlVMTDsNCj4+ICsgICAgICAgICAgICBi
b29sIHN1cHBvcnRlZCA9IGZhbHNlOw0KPj4gKyAgICAgICAgICAgIHVpbnQ2NF90IG1vZGVsX3Zh
bDsNCj4+ICsNCj4+ICsgICAgICAgICAgICAvKiBOb3QgYSBibG9ja2VyIGlmIHRoZSBmaWVsZCBp
cyBuZXZlciB3cml0dGVuIGJhY2sgdG8gS1ZNLiAqLw0KPj4gKyAgICAgICAgICAgIGlmIChhcm1f
ZmllbGRfc2tpcF93cml0ZWJhY2tfYWx3YXlzKGZpZWxkKSB8fA0KPj4gKyAgICAgICAgICAgICAg
ICAoIWFybV9maWVsZF9pc193cml0YWJsZShmaWVsZCkgJiYNCj4+ICsgICAgICAgICAgICAgICAg
IGFybV9maWVsZF9za2lwX3dyaXRlYmFja19pZl9ub3Rfd3JpdGFibGUoZmllbGQpKSkgew0KPj4g
KyAgICAgICAgICAgICAgICBjb250aW51ZTsNCj4+ICsgICAgICAgICAgICB9DQo+PiArDQo+PiAr
ICAgICAgICAgICAgbW9kZWxfdmFsID0gZXh0cmFjdDY0KGNwdS0+aXNhci5pZHJlZ3NbZmllbGQt
PmluZGV4XSwNCj4+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgZmllbGQtPnNo
aWZ0LCBmaWVsZC0+bGVuZ3RoKTsNCj4gbml0IEkgc2VlIHlvdSB1c2UgdGhhdCBzZXZlcmFsIHRp
bWVzLCB5b3UgY291bGQgaW50cm9kdWNlIGEgaGVscGVyDQo+PiArDQo+PiArICAgICAgICAgICAg
LyoNCj4+ICsgICAgICAgICAgICAgKiBJZiB0aGUgZmllbGQgaXMgd3JpdHRlbiBiYWNrLCBtYWtl
IHN1cmUgYSAic3VwcG9ydGVkIiB2YWx1ZQ0KPj4gKyAgICAgICAgICAgICAqIGlzIHJlcXVlc3Rl
ZC4NCj4+ICsgICAgICAgICAgICAgKi8NCj4+ICsgICAgICAgICAgICBrdm1fYXJtX2ZpZWxkX2dl
dF9zdXBwb3J0ZWRfdmFsdWVzKGZpZWxkLCBob3N0X2lzYXIsICZ2cyk7DQo+PiArICAgICAgICAg
ICAgZm9yIChzaXplX3QgayA9IDA7IGsgPCB2cy0+bl9yYW5nZXM7IGsrKykgew0KPj4gKyAgICAg
ICAgICAgICAgICBpZiAobW9kZWxfdmFsID49IHZzLT5yYW5nZXNba10ubWluICYmDQo+PiArICAg
ICAgICAgICAgICAgICAgICBtb2RlbF92YWwgPD0gdnMtPnJhbmdlc1trXS5tYXgpIHsNCj4+ICsg
ICAgICAgICAgICAgICAgICAgIHN1cHBvcnRlZCA9IHRydWU7DQo+PiArICAgICAgICAgICAgICAg
ICAgICBicmVhazsNCj4+ICsgICAgICAgICAgICAgICAgfQ0KPj4gKyAgICAgICAgICAgIH0NCj4+
ICsgICAgICAgICAgICBnX2ZyZWUodnMtPnJhbmdlcyk7DQo+PiArICAgICAgICAgICAgZ19mcmVl
KHZzKTsNCj4+ICsNCj4+ICsgICAgICAgICAgICBpZiAoIXN1cHBvcnRlZCkgew0KPj4gKyAgICAg
ICAgICAgICAgICBRQVBJX0xJU1RfUFJFUEVORCgqYmxvY2tlcnMsDQo+PiArICAgICAgICAgICAg
ICAgICAgICBnX3N0cmR1cF9wcmludGYoIlNZU1JFR18lc18lcyIsIHJlZy0+bmFtZSwgZmllbGQt
Pm5hbWUpKTsNCj4+ICsgICAgICAgICAgICB9DQo+PiArICAgICAgICB9DQo+PiArICAgIH0NCj4+
ICt9DQo+PiArDQo+PiAvKg0KPj4gICogQ29weSB3cml0YWJsZSBJRCByZWcgZmllbGRzIGZyb20g
aXNhci5pZHJlZ3NbXSBpbnRvIHRoZSBLVk0gY3ByZWcgbGlzdCwNCj4+ICAqIHNvIHRoZSBzdWJz
ZXF1ZW50IHdyaXRlX2xpc3RfdG9fa3Ztc3RhdGUoKSBwdXNoZXMgdGhlbSB0byBLVk0uDQo+PiBk
aWZmIC0tZ2l0IGEvdGFyZ2V0L2FybS9rdm1fYXJtLmggYi90YXJnZXQvYXJtL2t2bV9hcm0uaA0K
Pj4gaW5kZXggYWIwMWNlODY2NS4uNTk4MzJkODA2MyAxMDA2NDQNCj4+IC0tLSBhL3RhcmdldC9h
cm0va3ZtX2FybS5oDQo+PiArKysgYi90YXJnZXQvYXJtL2t2bV9hcm0uaA0KPj4gQEAgLTIwNSw2
ICsyMDUsMTkgQEAgdm9pZCBrdm1fYXJtX2ZpZWxkX2dldF9zdXBwb3J0ZWRfdmFsdWVzKGNvbnN0
IEFSTTY0U3lzUmVnRmllbGQgKmZpZWxkLA0KPj4gICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgIGNvbnN0IEFSTUlTQVJlZ2lzdGVycyAqaG9zdF9pc2FyLA0KPj4gICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIEFybUZpZWxkVmFsdWVTZXQgKip2YWx1
ZV9zZXQpOw0KPj4gDQo+PiArLyoqDQo+PiArICoga3ZtX2FybV9pZHJlZ3NfZ2V0X2Jsb2NrZXJz
Og0KPj4gKyAqIEBjcHU6IEFSTUNQVQ0KPj4gKyAqIEBob3N0X2lzYXI6IFRoZSBob3N0IElTQVIg
cmVnaXN0ZXJzDQo+PiArICogQGJsb2NrZXJzOiBUaGUgbGlzdCBvZiBibG9ja2Vycw0KPj4gKyAq
DQo+PiArICogR2V0IHRoZSBsaXN0IG9mICJibG9ja2VycyIgaW4gQGNwdSdzIGlkcmVncyBzdGF0
ZSBmb3IgdGhlIGdpdmVuDQo+PiArICogQGhvc3RfaXNhci4NCj4+ICsgKi8NCj4+ICt2b2lkIGt2
bV9hcm1faWRyZWdzX2dldF9ibG9ja2VycyhBUk1DUFUgKmNwdSwNCj4+ICsgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICBjb25zdCBBUk1JU0FSZWdpc3RlcnMgKmhvc3RfaXNhciwNCj4+
ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBzdHJMaXN0ICoqYmxvY2tlcnMpOw0K
Pj4gKw0KPj4gLyoqDQo+PiAgKiBrdm1fYXJtX3N0ZWFsX3RpbWVfZmluYWxpemU6DQo+PiAgKiBA
Y3B1OiBBUk1DUFUgZm9yIHdoaWNoIHRvIGZpbmFsaXplIGt2bS1zdGVhbC10aW1lDQo+IFRoYW5r
cw0KPiANCj4gRXJpYw0KDQoNCg==
