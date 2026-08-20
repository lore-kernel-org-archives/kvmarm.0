Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1A3C3AFD12
	for <kvmarm@lists.linux.dev>; Thu, 20 Aug 2026 06:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787207960; cv=fail; b=tddWrzw5oCDcoCcJLqlSRBMncMkpXiRzpgu6OsXeY9VegCzz2TuhYPlVrk2vbrzdtVm/lYfvcvnR1FLQ0zATVCFOKxI9NSRaBYR4lyZ9SapK6XFnMrFbASLhDXCVtPdBKOQ6p9tZiT9hJNNkAObC01WdUHVdLOI464HDfr9oYtA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787207960; c=relaxed/simple;
	bh=f/AfAnSHkA+L5ZgZEzgyF4sok5GsqaaxEovxg4kr6xU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=OgxPM2dUsi+9Fn5Iaz4j0AufVhJX8cXXBV/s2omVK9WNNMXG2a4auZB//8jXEH2Ozniwz7FVL9PI8pf5H1Zm8UB/bd+pbTHEUmc34dYvtUvdsy48n/512NgUKWzzgO42gAlX52RJcGAUI8R+HJwLqwrQg3GgFGyBJ32y39AShP8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=hRYkDreJ; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=JJ0YMEP7; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="hRYkDreJ";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="JJ0YMEP7"
Received: from pps.filterd (m0127843.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67JLB3b71594010;
	Wed, 19 Aug 2026 23:39:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=f/AfAnSHkA+L5ZgZEzgyF4sok5GsqaaxEovxg4kr6
	xU=; b=hRYkDreJleu0VxRMC4gxm/Q42IOJMJOOfylFwf14ztV2u7JOfcdT/qCKH
	goFpJbz4LA/FM08L0gpm2DzjIEcWOxeo0DxQuwT62r6Cgh26kyP9cwBdc8j8WMYN
	Kb8ru4NP8RKeiFMcnk0S77bmtF9PT/+vdf0IF1pVaGOf1MwGXCCoD1iXLAxXA0k+
	RcyxP4gj+YK8QPU1qOyW4qhHijZRUzxOu3GKhGz9vTDFFckvzumAK9vg0DBvWq0J
	TjjDVwDz/eYgsA3NLqeX04XFiLA/WRZFkS82NFQg653IM113gNHR7aD7K4qCi8KK
	3feIrnHGhYnozluUIoKgCMWO9mI5A==
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11020126.outbound.protection.outlook.com [52.101.56.126])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4g4wgrvh11-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 19 Aug 2026 23:39:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=s2zNHCOEKvZ8AjZlSguufTFDlNURUzbVmbQHK6BGPkeSME09y26F9B75FhOy/ESqlKmsvO4/CB9BUL0e/t1Kotd44sf6/f0nRN07g3GmoVZ96BUfjBE+AS7udVpadlztCPmq7EzykBONFQ6+1GX1CjjQnHyzNRAj93C7+HyLM46l6uGm+2Q1cU66C94vVpoQ3s3Ag5o1wpCztnHmXqwHnTmRY1mHh8Pj6WGc+0Nq4esJ6DnC3CiRWk1PG91cZVkJDvVBlvf5acbI5gNQwjS154WQY/ss9sMGt8KK5BgUlV1yIg86qz/Lfq1dZobyMmF6PknvY7Kgdc+mfei6WKkIgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f/AfAnSHkA+L5ZgZEzgyF4sok5GsqaaxEovxg4kr6xU=;
 b=ca1eC56zlGIqL+q/9QGkq3nS6M7NrXF0JFkk5Trf1LJgtxSlrtyclu6e66YYyzhxvl05E/b7U+JEF2UCscPTxhjuV4j+4wIyzV3kJNZ9xWKKfuYxB5Wu6UIOrQqrAeo3NzZbz82CF1y7XxOK6aTWYPeuG4e1lqvcYZasKIDSse2exxHVEEmDfSO9NVHc0g4AtaIKoqkDpE7i712iFG9EwcvBvrofOCe61y8CWeC8NQcx+wwK8EoHOVifpJaKa1uq7muEnyJkC4rNCMu1bs7rgwkT9y1dEF9LyVcWkiZ1Zwmrcf+9IjUjHKFABiOVVnlta06DkIbeV5Es1AYhTpczjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f/AfAnSHkA+L5ZgZEzgyF4sok5GsqaaxEovxg4kr6xU=;
 b=JJ0YMEP7ZQoEPOUC60+jKbb0PuwEgHlZYmX1QcOE5/lkUmc7lnb2NZ+RS6OjAHD5XkHXdAHWYZ1xYByRTERAoTo0J+06SFhbCln+VfkCQ9xGM0nHZXx7toJQHweIJQoN7F7KMokAwXD8ClyLucpqjKEk4IZb0147bsK1fFPpOxXxkCOyCt/Zh6N84xHdC2eqiDm/AH3GD8dczJEZxoxZalcTlqRpR6mPQJG0vfeBy2UtFByVGz2N4h4t4+MV2UQRUZArVeaty61RE0A39FaRpZbuyKbl9iNkArAqUr4j+bAJA9GxvBauCKGc7fvuYmxiE3jt1CfCFETI3sT2aJyASA==
Received: from PH0PR02MB7557.namprd02.prod.outlook.com (2603:10b6:510:54::17)
 by SA1PR02MB11147.namprd02.prod.outlook.com (2603:10b6:806:4aa::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.8; Thu, 20 Aug
 2026 06:39:00 +0000
Received: from PH0PR02MB7557.namprd02.prod.outlook.com
 ([fe80::4917:bc05:4373:6bef]) by PH0PR02MB7557.namprd02.prod.outlook.com
 ([fe80::4917:bc05:4373:6bef%4]) with mapi id 15.21.0339.007; Thu, 20 Aug 2026
 06:39:00 +0000
From: Khushit Shah <khushit.shah@nutanix.com>
To: Eric Auger <eric.auger@redhat.com>
CC: "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "qemu-arm@nongnu.org"
	<qemu-arm@nongnu.org>,
        "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
        "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
        Shaju Abraham
	<shaju.abraham@nutanix.com>,
        "yangjinqian1@huawei.com"
	<yangjinqian1@huawei.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "richard.henderson@linaro.org" <richard.henderson@linaro.org>,
        "sebott@redhat.com" <sebott@redhat.com>,
        "skolothumtho@nvidia.com"
	<skolothumtho@nvidia.com>,
        "philmd@oss.qualcomm.com"
	<philmd@oss.qualcomm.com>,
        "maz@kernel.org" <maz@kernel.org>,
        "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
        "pbonzini@redhat.com"
	<pbonzini@redhat.com>,
        "armbru@redhat.com" <armbru@redhat.com>,
        "berrange@redhat.com" <berrange@redhat.com>,
        "abologna@redhat.com"
	<abologna@redhat.com>,
        "jdenemar@redhat.com" <jdenemar@redhat.com>
Subject: Re: [RFC PATCH v7 04/18] arm/cpu: Add infra to handle generated ID
 register definitions
Thread-Topic: [RFC PATCH v7 04/18] arm/cpu: Add infra to handle generated ID
 register definitions
Thread-Index: AQHdMG6OIO+eacH7wEekjZUskfN9AQ==
Date: Thu, 20 Aug 2026 06:39:00 +0000
Message-ID: <393F8EF8-6483-46E6-9E0F-64215D96C312@nutanix.com>
References: <20260726153221.24773-1-eric.auger@redhat.com>
 <20260726153221.24773-5-eric.auger@redhat.com>
In-Reply-To: <20260726153221.24773-5-eric.auger@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR02MB7557:EE_|SA1PR02MB11147:EE_
x-ms-office365-filtering-correlation-id: 1afcafce-b3b2-4bbc-bd65-08defe85b7ef
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|23010399003|7416014|376014|366016|1800799024|38070700021|6133799003|56012099006|10067099003|4143699003|18002099003|22082099003;
x-microsoft-antispam-message-info:
 3vAZ+QeIaOKAxrYGlp12SZbqpw0/B/NIQkeB5CuNRKdggJ/6180Uqx8HYMXLJCPSIV1G+sj7KzNhLE6tE4uR3/o5dUw4m4j975L9b68YI2SKgv0M8BxbWhrPLKAiInlwl57r2DZKbMHHS5wnWs6QQY9+AHOKalHYQFmDNDRmrc2SMJsxKZL8EXxYQSetCWFzyjZi5kZIhUTdCfLLBrhS7o4kdfrsy5gonaw5gfkOB44/LOLX10ou2amq8FEa7SqOjh+Nxi04wFh5P7cHWs1qi9uA9mfsF0RMDTw7ZaARyOwQbLwtjcziqdNRKtKq72EAfRliWUf4JfR9P5EbrZY+ABN72y4jbgoeU/rdfK+asgxthk9ZTqk3kPXtAzz4f04VB3NPN2Mmff4Nwb4BnlPU2YyjPtBkGjLw2r4/oaeUpPd/1QbCGM5zLMSzK949g+hlU3krJJJ9PWGw+g1rGyULBKruXdgxccyz6P8ukRGdP2zUA1JM39YjzsoDUS+Pc52wkCOK1LBambRt0tQRTB6pzOWvoM17GoJTiDSykV9B+ydBm8Wtvv2MD8kGpZL3mk0esbtT9JSIEHo5Gx1btBsu7NwQ1WoD2CZvaHGUUsaCKVxHWVrAPNLDGV0aN6tCyphW8ZHKulj/Z+CELIY5KhT6+jVoF2piJz9elvrYUJxUzDbjILbdJeQJO6mRztvQbYrxqxCnrU4vnfSvUVQpsJaLhYVCW7LE3PNGaJAmyK0g3W4=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR02MB7557.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(366016)(1800799024)(38070700021)(6133799003)(56012099006)(10067099003)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?eDRkbnZoYk5iM0xzdytPOTJGWUM0VHdncXNtaUJUbVdRZHhRNmtUN0dLNENW?=
 =?utf-8?B?SGp1bXBrLzJTYmN5T01JL3YrbUtPUGY1dlNxOHIwb0grRDVYbFlzWFc1QVNp?=
 =?utf-8?B?SlFyTlhPVWkzemloZGxYVXAxcWhWSVkvTXY0NExJVndzcUdJQTgvOXpHajFI?=
 =?utf-8?B?RjdpeEExc1UxdUJzdDhmSGlINyt2L2dBWmNabHlmS3NxTm1HU0krWGFNS1V6?=
 =?utf-8?B?dzZIMnFQeEZUQXhYcTdXVmNHWEdjV3grdG9YWUVTUkJIRzJRZkxjRzlNcDBJ?=
 =?utf-8?B?eFNYdm1mZldIdU5kdEVyajR6cy9yb21zb3ZVZ2tERE5Xbk8yV3c0b1BZUW9J?=
 =?utf-8?B?aWEzbjROeWxWZzdLeGhMcTlEZXZjaGdRay9Hd2JSbjJvTHpMZWJ1d0QrV1JU?=
 =?utf-8?B?MXNNYituYTh0Yi84czFDL2NvMjEyRlRzYXFKYW5pQkZzcllLUlExS09zV043?=
 =?utf-8?B?Ym9xTFFLQnpjd0JENGtRcFdVd3d2YkNmRGFZN2kxTnR5dDNPRURkdVJ3QXZC?=
 =?utf-8?B?NWZUcENsM2xrT2xBSVJXZDJ5UHJqQjNNMk5TK00ydFRIdzJWcmFMWUdhV0xE?=
 =?utf-8?B?WjB3c1NqSGtiMENCQWxKbWpCSGxnNit2UURMWWYzSjNOQ3FKdnk5MmhvdEg4?=
 =?utf-8?B?Q3ZJYitmbFM3S2Zvb1NTRW94eG9ZTHpRQ1QxTnNuRG13cmwvcTNZMG5WOGxv?=
 =?utf-8?B?aW0wd3YzQnpWWmNicmRzSjJQbFMzK2dGcHdueGNQWjhFZklOeGxTOVlOenBB?=
 =?utf-8?B?U3VjMkM5dEhGZ1IydTRIS3hWRVdGUkNzOGJxNjlRMzYyNXZNSlJPbURjdmZr?=
 =?utf-8?B?VEgxcVlESVo3emJiZ3hkOUYwSDdyVjl2SVZPVFBDNXZiMC9xcXlYV1cxZEwx?=
 =?utf-8?B?VVE2R0FkU0xpakh0SEJuTDg5UnV1ZCs3VnNzNEpQU3I0UWpvekhJRTdiQ3Jp?=
 =?utf-8?B?YkQ1VWE5ZDFySitpYTVDdU5UTzEyRW5hd2hDMVQ3eGhwd0dGY1FENWlWZE9t?=
 =?utf-8?B?b0U1T281NEl0NTV0eTZNWCtQQVJHREhmR0Y2QVB1aDZXSVQ1VE0vWnhNbVlt?=
 =?utf-8?B?UDQxZlYvbVhwRWdzdVc4djNUU0x2NHArZ2Z6ZGxLTVZTTzFoSVEvaUVweXRs?=
 =?utf-8?B?UHNFK09BTlRxZkJyck9LaUNWRjJmd0NSMDhxYkRuVC9qY2x5N25USFpwekph?=
 =?utf-8?B?Y2cxVkNiUWxEMkxTZ1h6TW5JMVEzY2dUck5wMXAvSU13MUhtWHpVQjFyd1Zq?=
 =?utf-8?B?RFhpRkxSd2RKcWFnQk5yMXZ5ZytkODV1YnFBcUx4NE9nazBsVXdqejdTanFD?=
 =?utf-8?B?Ym9aQm9EeDFlSVdoSHRmcmtLakdxYzRHa2Z1K2tVMG94Z1lwM3gxL3RFQ1Y4?=
 =?utf-8?B?TjN2Rk1BZWZNSExqdmVBekQ5OVJnNWUzZkl6RnVSNTVpT2IxL2RkTllTSGhV?=
 =?utf-8?B?YkhITitNZk9pU2E4VUNadUdJNGNiQzV6QXptVjBicGVlZlhTaWRxVHhCdDZh?=
 =?utf-8?B?cnltQXd0eHJtQkxBMmZSbUlROGhpeGNCQk85WHh6a2FaTkQ2SHVNcmlhUDJl?=
 =?utf-8?B?QUV5cUsyZHhWRFBCL05aYytYVys4L01oTVRTeERwbjllUnpVREhRQ1hzaW9X?=
 =?utf-8?B?ODNrZmErL0NTZG5vN2YyR2kreld0b1FzcFpZanJVTWM1QmNuVnloU0l2V1pz?=
 =?utf-8?B?dm5nbWZtVGZkS0pVek95N1NwQWdHb3RwR3Z4aVBSemxOWW04a1FiNWNRa2pi?=
 =?utf-8?B?anZFRExFUjdKdUk1ZS9GWnRWc1lrS01sb2dxcHJWT1k3SE5sQ0ZvallSby9X?=
 =?utf-8?B?Q2s4NmJMYW1reXAyc09lNUVZRlFLMkJabU1zUzVSR0R3RFRHNjA4eHpWZEFN?=
 =?utf-8?B?di9BaEs5T3ovK1pUODVWckxCeUsvbDhDTnZhMEQvcFNDV1NhK0w1VDlXV2Vi?=
 =?utf-8?B?bE1tTklKQnNEZ1dSaWRidmFLREMzSmpLb2hOeExtMU5sU2w2TGErMXJtUm5y?=
 =?utf-8?B?c01INHFnbFl6dm5xVmQ5Sjdtei9YYmJDanZuejVFZk5vcFVHRDk1b1hjeXlK?=
 =?utf-8?B?SVcyZDM0K2pCTXkwemRndmc4VFlHTzdFM0JKSVVkd3JkajVKSlBHaFdZYnlw?=
 =?utf-8?B?MHErbmVOYS9nZ2FFbXVKMXoweGtIVUpTejVoZU5qcWw2NFBjVDVta1VXMS9y?=
 =?utf-8?B?K0wvdGlNczg1cjRiQnNjZHdKRFpqVEVqdEM0RFViYXFpMERzcFBSUC9XZUl1?=
 =?utf-8?B?TzJIWG5sRS9tQWJYTXdUVkNBamp1d3Nkc2FUVVRyV3N0ZngzZHBYdGUyM1Rr?=
 =?utf-8?B?TU9YOGdJN0pQSkNNczl2b25LNE93KzhyaGQ5M2VvYndmQm9ncUxlWnZnZDRN?=
 =?utf-8?Q?L/o14sFEZfLNgDMI=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9C01AC60305E8F4C840FD6B3BFA9F3C0@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	pliDIfWzbQfAOckJzap5H72iSQ9LnG8jdRO2+7ipljR4XEL8TL88gvtEErNv4DnZKgrmbQHdnDRNG3j7vkyxOwM6rb48HVvAfnO0VySpwITx1BjaaHFUCR+qz5D7sCz0TOEwcaP6bxo+fm8QheBZW2sjcYEGf7Fo7eJvR3c4+GppgYsYp31m4oXc+7hsH/qUn7o5ph87uyntnjy8ylFvx49oxRifpq3wK8hAYi63nNfybgQv5C8uqjfOnvoomRSdJkqrNQ+c+VZ+N53QIVR7/sXL9nhMX5jcqTkFchYAUlIKLRkw6rTMasESvN7Z1E7t/fVI3EbqMNCZdtxfQBnOFg==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR02MB7557.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1afcafce-b3b2-4bbc-bd65-08defe85b7ef
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Aug 2026 06:39:00.3018
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TkrCmJ1IPcT//srKE/MzMQzlotEeCrEATEqYZQAsADwUfdlarJZ9p3dqWH0ZtJM+XdnZ3B6mhJ9vRNfl+YNRT3ifKEUJCRD1cDwukHNdBv0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR02MB11147
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODIwMDA0NiBTYWx0ZWRfX9/Dsw2/rxcfX
 B94uzsm4C8MLC5QCI9X25ggd6RNPW3ubMf+tCpXOmYJsIF7Zs2cvB21TdPwRBjEVedETnhuaaks
 72Gxgoe9Abgy6NCwYd6tQHeDMweAeNZwm3spNhT9KcxKlkcm/L9SjNqb5M4URoT6iLDhx7EwkI5
 f02EdLnc2PvAH2P7NBVLWA5HZ0dWRY82MwAeDtldi/Cg1j4s01DzDCyehSJD5u4wqP/eejmH+PP
 1CQqFda/tQ4jd+SmVko3Phn8A4Uaqzw4g4aURoRYjQZS3myLeaDY6vqI36AWt5lHXgC52xCt+Tc
 1c3eFiKr1nPWxTtPp/Uw4IHxrHjfVRHKoQJcMBYAN49ViFlQqlxH/ZwyAu400fbZBkCxfQI0W3N
 kcx6w0YnuetS3DwmI78WsUrbcgGFKMmrKwTNkJVrdj+mFv49o9L8G04ZOGRIo75kfYO6N/55Fxh
 XNvkQfhqdrX3Y1r1Idw==
X-Proofpoint-GUID: TyMgXt469JtVzsJmlsDoulTOrqjwPaZF
X-Proofpoint-Spam-Info: AW1haW4tMjYwODIwMDA0NiBTYWx0ZWRfXxFBKkSmIRibl
 TfkFuA79/6Eah7yzQLh5htQKOFFm7zUEeLeVqwcEbvnK8YFc+2CjvmTAeMeC/HeXvkwQeqe36iX
 pX66JG/VOAWaL8+pfRlumb3rM2SP/QQ=
X-Proofpoint-ORIG-GUID: TyMgXt469JtVzsJmlsDoulTOrqjwPaZF
X-Authority-Analysis: v=2.4 cv=CcY4Irrl c=1 sm=1 tr=0 ts=6a86a106 cx=c_pps
 a=y6InnzShCRkIpTYudTQ+bA==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Sv0fKeRqtYgA:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VofLwUrZ8Iiv6rRUPXIb:22 a=dEe9Ve2bX-KnNSUMM2s9:22 a=20KFwNOVAAAA:8
 a=64Cc0HZtAAAA:8 a=Nxd502bWVzb8p8cIEP4A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-19_06,2026-08-19_02,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gMjYgSnVsIDIwMjYsIGF0IDg6NTnigK9QTSwgRXJpYyBBdWdlciA8ZXJpYy5hdWdl
ckByZWRoYXQuY29tPiB3cm90ZToNCj4gDQo+ICEtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tfA0KPiAgQ0FVVElPTjogRXh0
ZXJuYWwgRW1haWwNCj4gDQo+IHwtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tIQ0KPiANCj4gSW50cm9kdWNlIGFuIGluZnJh
c3RydWN0dXJlIHRvIHN0b3JlIHRoZSBkZWZpbml0aW9uIG9mIGFsbCBJRCByZWdzOg0KPiBUaGlz
IGluY2x1ZGUgdGhlaXIgbmFtZSwgaW5kZXggYW5kIGFycmF5IG9mIG5hbWVkIGZpZWxkcy4NCj4g
DQo+IFNpZ25lZC1vZmYtYnk6IEVyaWMgQXVnZXIgPGVyaWMuYXVnZXJAcmVkaGF0LmNvbT4NCj4g
U2lnbmVkLW9mZi1ieTogQ29ybmVsaWEgSHVjayA8Y29odWNrQHJlZGhhdC5jb20+DQo+IENvLWF1
dGhvcmVkLWJ5OiBLaHVzaGl0IFNoYWggPGtodXNoaXQuc2hhaEBudXRhbml4LmNvbT4NClNpZ25l
ZC1vZmYtYnk6IEtodXNoaXQgU2hhaCA8a2h1c2hpdC5zaGFoQG51dGFuaXguY29tPg0KDQo+IA0K
PiAtLS0NCj4gDQo+IHY1IC0+IHY2Og0KPiAtIGFkZCBBcm1JZFJlZ0FyY2hWYWwNCj4gLS0tDQo+
IHRhcmdldC9hcm0vY3B1LWlkcmVncy5oIHwgNDEgKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysNCj4gMSBmaWxlIGNoYW5nZWQsIDQxIGluc2VydGlvbnMoKykNCj4gY3Jl
YXRlIG1vZGUgMTAwNjQ0IHRhcmdldC9hcm0vY3B1LWlkcmVncy5oDQo+IA0KPiBkaWZmIC0tZ2l0
IGEvdGFyZ2V0L2FybS9jcHUtaWRyZWdzLmggYi90YXJnZXQvYXJtL2NwdS1pZHJlZ3MuaA0KPiBu
ZXcgZmlsZSBtb2RlIDEwMDY0NA0KPiBpbmRleCAwMDAwMDAwMDAwLi4yNDVmMWM4MTAzDQo+IC0t
LSAvZGV2L251bGwNCj4gKysrIGIvdGFyZ2V0L2FybS9jcHUtaWRyZWdzLmgNCj4gQEAgLTAsMCAr
MSw0MSBAQA0KPiArLyoNCj4gKyAqIGhhbmRsZSBJRCByZWdpc3RlcnMgYW5kIHRoZWlyIGZpZWxk
cw0KPiArICoNCj4gKyAqIFNQRFgtTGljZW5zZS1JZGVudGlmaWVyOiBHUEwtMi4wLW9yLWxhdGVy
DQo+ICsgKi8NCj4gKyNpZm5kZWYgVEFSR0VUX0FSTV9DUFVfSURSRUdTX0gNCj4gKyNkZWZpbmUg
VEFSR0VUX0FSTV9DUFVfSURSRUdTX0gNCj4gKw0KPiArI2luY2x1ZGUgInFlbXUvb3NkZXAuaCIN
Cj4gKyNpbmNsdWRlICJxZW11L2Vycm9yLXJlcG9ydC5oIg0KPiArI2luY2x1ZGUgImNwdS5oIg0K
PiArI2luY2x1ZGUgImNwdS1zeXNyZWdzLmgiDQo+ICsNCj4gK3R5cGVkZWYgc3RydWN0IEFybUlk
UmVnQXJjaFZhbCB7DQo+ICsgICAgdWludDY0X3QgdmFsdWU7DQo+ICsgICAgY29uc3QgY2hhciAq
bmFtZTsNCj4gK30gQXJtSWRSZWdBcmNoVmFsOw0KPiArDQo+ICt0eXBlZGVmIHN0cnVjdCBBUk02
NFN5c1JlZ0ZpZWxkIHsNCj4gKyAgICBjb25zdCBjaGFyICpuYW1lOyAvKiBuYW1lIG9mIHRoZSBm
aWVsZCwgZm9yIGluc3RhbmNlIENUUl9FTDBfSURDICovDQo+ICsgICAgQVJNSURSZWdpc3Rlcklk
eCBpbmRleDsgLyogcGFyZW50IHJlZ2lzdGVyLCBlLmcuIENUUl9FTDBfSURYICovDQo+ICsgICAg
aW50IHNoaWZ0OyAvKiBsc2Igb2YgdGhlIGZpZWxkIGluIHRoZSByZWdpc3RlciAqLw0KPiArICAg
IGludCBsZW5ndGg7IC8qIGhpZ2hlc3QgYml0IG51bWJlciAqLw0KPiArICAgIEFybUlkUmVnQXJj
aFZhbCAqYXJjaF92YWxzOw0KPiArICAgIHVpbnQzMl90IGFyY2hfdmFsc19jb3VudDsNCj4gK30g
QVJNNjRTeXNSZWdGaWVsZDsNCj4gKw0KPiArdHlwZWRlZiBzdHJ1Y3QgQVJNNjRTeXNSZWcgew0K
PiArICAgIGNvbnN0IGNoYXIgKm5hbWU7ICAgLyogbmFtZSBvZiB0aGUgc3lzcmVnLCBmb3IgaW5z
dGFuY2UgQ1RSX0VMMCAqLw0KPiArICAgIEFSTUlEUmVnaXN0ZXJJZHggaW5kZXg7IC8qIHJlZ2lz
dGVyIGluZGV4LCBlLmcuIENUUl9FTDBfSURYICovDQo+ICsgICAgc3RydWN0IEFSTTY0U3lzUmVn
RmllbGQgKmZpZWxkczsNCj4gKyAgICB1aW50MzJfdCBmaWVsZHNfY291bnQ7DQo+ICsgICAgdWlu
dDY0X3Qgd3JpdGFibGVfbWFzazsNCj4gK30gQVJNNjRTeXNSZWc7DQo+ICsNCj4gKy8qDQo+ICsg
KiBMaXN0IG9mIGV4cG9zZWQgSUQgcmVncyAoYXV0b21hdGljYWxseSBwb3B1bGF0ZWQgZnJvbSBB
QVJDSE1SUyBSZWdpc3RlcnMuanNvbikNCj4gKyAqLw0KPiArZXh0ZXJuIEFSTTY0U3lzUmVnIGFy
bTY0X2lkX3JlZ3NbTlVNX0lEX0lEWF07DQo+ICsNCj4gKyNlbmRpZg0KPiAtLSANCj4gMi41My4w
DQo+IA0KDQo=
