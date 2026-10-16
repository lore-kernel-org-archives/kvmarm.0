Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93D023DDDC1
	for <kvmarm@lists.linux.dev>; Fri, 16 Oct 2026 07:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792136076; cv=fail; b=cNgOiW7mRJMRfh8umiUgG8SddgwLQ5uZ1zSb3N6GlycHXRyKXiZw9U/TYoAVqQIt/AjY4RcLE/rnLcDo60ceqi+TWzRY6I6AwLF0x7H5M3SCkfHVN5UH0oMyLCnfQ19GiFLH293mPL3M3WKqAPQOSoCi/fFNDoekn3BVVUpKDjQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792136076; c=relaxed/simple;
	bh=6StMRMH7UgpNOW+QzQPw1i0+L9OtP7jG9/cxi/7ilIY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=QsYdmgHjwx614ruk7ZhTm8bE3NCtoOTgg2hXocfkSkCsjY/dJu+SRK8vy8pgYgISkScoJhX6pB8lHjt6JJHNm+AfK0NMzW1c+1DOYAzr9fYpYWPDB+a7JI6dMk1CRSjRwiycwblomOehRs31UyEHdmGssHw3ZxoLdRRt5G1QFt4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=2VeEAoOO; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=aLEIpznF; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="2VeEAoOO";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="aLEIpznF"
Received: from pps.filterd (m0127837.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69G6e8dP4079268;
	Fri, 16 Oct 2026 00:34:20 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=6StMRMH7UgpNOW+QzQPw1i0+L9OtP7jG9/cxi/7il
	IY=; b=2VeEAoOOG37XRUFiYbiHxLGD/+lasyp1ymHhyv+SLDnNQEuGEbqvXOvX3
	kjzTuZv3TLx91k8Y9QzS/zuysZcn30arYYb9dAVOR53pHhxZ4Pdnlx4AAEoajHaa
	fD5y1Y+E03/5YbxI2/M5+ltSn5wQOU0lZ+x53e7HdImOLDepeOzkpmyKrQ39zhqw
	6yVMhIqT0QSI9TDf2OtgsOQ+0V4Gu/W5GTcmytbqVJRk5woLetBq76z2JTJ/TsS7
	vTlBvShb5/RJ6L+R7ptVAtem1KJYe9k4aQz+1FkfE/VRLWXp42Dghy89ziUkJtsQ
	OdPmJhZL0KMqX2rCQ2GoId3TmPBsQ==
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11023139.outbound.protection.outlook.com [40.93.201.139])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 4habw5d213-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 16 Oct 2026 00:34:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QSjk9ho73xhKtNLSKYtzMdNkjfGSOKPAGSkMAghCnp7MOeIFeCR2rvTQnamgwbd0C1h++bzgEteapGqyg4fpuRwJdoiAwhgfg3ndikPTUcOVRACrdDNl2A42CErhwMI/jh+Vjmcljr1/l1cKNXCkm2fQiacyVdeYEo+rP24OyVkgsfoPVLV+1pqmTtNvEvVjFT6CU+oLbibV6hHPsQrd9hph6UCTCb10S4+hsq9PeLVQLT2W2n+1N+Qn0NJYqDdwiZ9+HFk51YM8S62s3F1qmUsWeHtda5qujTErMX3O+yChDUenbjLMjFq8sBky3zZjSYT4uBozALqzeVP4yidq0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6StMRMH7UgpNOW+QzQPw1i0+L9OtP7jG9/cxi/7ilIY=;
 b=QHEkzT6sVl6M4Us2mY8OzYmMRlJAym0wfKBci/KTjBTFnZMfMYPD2EnWpgyp6oWPEKBEmQOpKxOoWNkDvOILwb1J0l14xlEb2+xYTbtcDJMW+c1E5B8CNNBYLcfw3hcw4R+vmEbU2B0ikxgMCEyDPzyBcBoGZ2xh5Ig+q77M/ZqbEfL92fTq7UC2kVMHbdLlLasP4uA8Mq0TqEYK3K7WTjr6w3sXxYhGy1bSh4dK+5nuHbjXKrXmWrubz9IelJk4vU4UVoqSmL6SCA4fxMQVeytG+f5L94TbjhyOPmfKhrzCU8uocydv6O7A8IGuCf/NqFxEUu1yvojubof88L0A0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6StMRMH7UgpNOW+QzQPw1i0+L9OtP7jG9/cxi/7ilIY=;
 b=aLEIpznFT/aIJjzdpn0VdypgFz1IMyS1Uf5kVbAv8Vo7lSOVBR/IrNN21huoGyS41QwSPwS5rVpQiuRkaYJDC1hRwtekZk8T52TD+gVPGlcIMntiSLYprQsUIcPVq6SShV1mP6sOor69/ssi7xZT+JFb5Dcon/lahgv6dtwVxPZOonfYwRnt2xkbf6IAqOKI/Zzmn+GHMf1cDtWQp+ALNtO3G182/4aT3HxnnwP/hadxYG7zTu3hoPHVbIZLqLEEPtGXS8VIyuzS7SjSUazmO7DhfU/9HqEfmVSxcX5t4nm0/FCXuL8cPA23JEcWnJPQ3p70dt3sAiCq8WYw4E35bw==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by SN7PR02MB9302.namprd02.prod.outlook.com (2603:10b6:806:34d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.13; Fri, 16 Oct
 2026 07:34:18 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%5]) with mapi id 15.21.0522.013; Fri, 16 Oct 2026
 07:34:17 +0000
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
Subject: Re: [RFC PATCH v4 10/25] target/arm: fix SVE and PAuth finalize for
 named CPU models
Thread-Topic: [RFC PATCH v4 10/25] target/arm: fix SVE and PAuth finalize for
 named CPU models
Thread-Index: AQHdScVovpeadzXPnk+2jIyJQ9uKuLb+twiAgAE23wA=
Date: Fri, 16 Oct 2026 07:34:17 +0000
Message-ID: <A64FF020-7E69-4523-9EB3-4240E6F3EF3D@nutanix.com>
References: <20260921123249.1708067-1-khushit.shah@nutanix.com>
 <20260921123249.1708067-11-khushit.shah@nutanix.com>
 <4ea14973-ac46-497c-80f6-499487f733cc@redhat.com>
In-Reply-To: <4ea14973-ac46-497c-80f6-499487f733cc@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nutanix.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA2PR02MB7564:EE_|SN7PR02MB9302:EE_
x-ms-office365-filtering-correlation-id: ab499e59-9cc2-4aab-2fe4-08df2b57e2ea
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|366016|1800799024|7416014|23010399003|38070700021|56012099006|261009223027099003|4143699003|10067099003|18002099003|3023799007|22082099003;
x-microsoft-antispam-message-info:
 Kh/Ko2HHFEo77QQP6HmHAipG3F7X4o1jdXp5EpKOrhe/HEko0uZCUDch3xYOZ7Bg2aZ7pFCzLftYMPonA6JX43WrWzoMlyXOW1gVMXO12njoUxBYi9U8jp4dzwh/3SPaRVCy9cC5U3cAK/ESa8e+bG3x7J4pBWEpkZigTxUb5A84DzTOjUspTTEh0QlfMfmbM1PNhIGU2IKwnyjKvmp2Kk/tJX672fxiYiG+LMm/vD4xOcfLWhyHxfOhw4dwNkyDf92ap4RRrHRvFwUlgjL8S29bB/j++B92bZrbGgUdMAN4qvjalLx1QFI0XkncSM5eiokV00uNqAKqEQMZNqYe74lJjNG3gjAPMHU19ZA7HGCDSlZ16V9lp/v22NqyxEywsy4trGEjfawJmSfIVzl/RPG8KTs+uzLH4YzzkPE7ZozjVoHfS7HeQ7ODYYvD/xpRZawC1LTynd4W9vwjmvu5TgW+knVqBcFsHKEStR6JwnVXnApxIPja+cHGPI6VpOF837IPn6KH4COTCxGpB+2oHcrjIT6RBvTH6tnGThnjzQs3ha2sxFTgZUL42KtIn2piH1EzBjfzsSGurt2KRMPBuEHnzb+5l3e2jKkt3TIsM+BNhKulOYRXTns+gqk7ZH6AR0szgUzhIaN4ovXyGdW3TZkEXRUtbUC68ZjbnuoFgoaw7Oe/ATazlSNrVog/0wmZ4DCTdpWG+CGIgVZZz+6Ey6PEiXRJBnAeBrnY1tUNYZ0=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014)(23010399003)(38070700021)(56012099006)(261009223027099003)(4143699003)(10067099003)(18002099003)(3023799007)(22082099003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?amRJd01iWFRrQjVwQnVpRlRHMURNNmxUaXBNSk1JREU2SU03MWtSM3AwRXkr?=
 =?utf-8?B?RzdLdUpFNktPNmI5QkFVVUVXdStMUE5sRVhHRzhzSjZaSEVzVS9WdUZ0amdG?=
 =?utf-8?B?K0FjVzhPNjJrZ2NENVRLUWpPWVNLYlpsTFpXWW1YRVpSQjJZTjFPYUJ6Sk9h?=
 =?utf-8?B?WkgrT1dOUm1reEJUcTVHamQ4aWdpdSs5ZXpuV1JqVURjYStoWHdHTW5obGp2?=
 =?utf-8?B?UGF4c0gvdEtWbDNLOEhVMkpDK1ExQ21jdXZHc2Y1K1JTV0tKbjllUXdOSE9r?=
 =?utf-8?B?ekUydTdYY1NNNVZvVXgxNWwvR0pEbFlqdE13RTlwMGN1cXBzTE1MVHh1clBU?=
 =?utf-8?B?NHVYVTA1dG5XNVZGUE05T1JKMXR3cGQvV0RPQ3Z2RTNvNTg4c050TTZUYWNH?=
 =?utf-8?B?VHpkWnNPakx0SkFBRVFlUlR1Z05RK1VKZXg4RmU2d0xYT00xM2ZwMWxKRXUr?=
 =?utf-8?B?MG1XN3YwQUFRbUMvZ3JZdEJEeTV2d04yK2lQdTNud3BZSWI4cmc2b3RPMUdl?=
 =?utf-8?B?VFpobzVIeE9RYmJDVnpNOEZSdndBQ0piSnRqcUV2WHJoTnE0V01zemxJTkJD?=
 =?utf-8?B?eTJ4MDZlUmlvWEo1emN6R2RuVkhZNTZxbmRSZCtubzFQOFd5UlpkZE8xcEhN?=
 =?utf-8?B?VWZMSDFUbEFMOUgwNDFOSndzaEVWN1BBUEQ5QWtVNWFCK3BBVm96TGFPcktj?=
 =?utf-8?B?alhSVzM4SlBiYVlPRlBITjZVRU5NalFvZ3pHUDJSczk4OSs1SlBPdnZXa1dx?=
 =?utf-8?B?K2pBV25RdVFsdUJTRS80bFJBQklyYUlNMHN3WnppVHpNWm9zaEI2K2lCV3Ev?=
 =?utf-8?B?WWZ4bUpsT1VlQ3c3cndhc1hXQmd6cTJGMTBJL3FSeHFQdURmbHE0ck5WMDJN?=
 =?utf-8?B?Wm5JdDZTR0RPRVE0SHdwR2dFdXNiSmlZWWswUjZnTGhLcHlEZVhoWVBVRTQz?=
 =?utf-8?B?L3czSkJYM0RiZzg2UU5VMjJaTWkxWXhrck4rbk1Oa2VqZlRIbEtJUUU2TnVV?=
 =?utf-8?B?YzBzTVMxRkM5WUdOMnRkUlg4czBQSlJQRld2dnJhaUltaGV3clJ5Z1F4RnBL?=
 =?utf-8?B?YzlGMVZFSG9KTENlcGU4UHN2U0t0dk9iR0x6SGVFZ0VYbTVIajZzWndNZHlo?=
 =?utf-8?B?dHVwMkFhbXppL2EvQWtuZWNhcWoybWp4VFR5eEJwSWxwZUJQdXhKR0I1Sm9Q?=
 =?utf-8?B?L014ZjhoOXdvZzlCK2NKTkVQNlhZcXNMWTZOUGI3WnFMTExNY3htRU1wWWo0?=
 =?utf-8?B?bnBvTTdVWk5uOGdSN3pDemZUNmFQOG5NL2pVNkF1UFJiWnBpN28xRDFVV3c2?=
 =?utf-8?B?TWlWL0JmU0pXNjUyRExadnJ1UXRucDg3U252UEZTK1VVN2srY3lHdGYxVkht?=
 =?utf-8?B?Z2NyUFJrR25UcE5SQUtrRWJxQ2xsZWlTbmh3c1BGV1JYTzNUdFFnRE10b2RI?=
 =?utf-8?B?Q2dMekhlM2FQdkMyQVNZM2VTMTIwSkhNM01oL2dobUh0bmVYZ0J3Njc4M3Rr?=
 =?utf-8?B?Rk1sSy9tUWxZSFR6ajFVV2FPMGVabDRCcFZtazJ6a25kZkF4M1RjVEpmWHJn?=
 =?utf-8?B?ZmhnV3pLNjJqNW1mOE11a2ZXNWs2K2kxL3JwRUprZGl0Yk9JSTl3RjZ4ckdT?=
 =?utf-8?B?QXRXdkFqWHJiRHZ1bXV1SXNzMDQ3Q3FFRk81eldtTkFnbVJ5eTRFd3Z0dmpE?=
 =?utf-8?B?Nk41anFFeGk2dXRKbVhKVGhCS1IyVlhVYVpvZGxYVWFVTjZLSlZnVThobUl6?=
 =?utf-8?B?dmFtZGZ2dHNrY3I4VklnTjlnZmtNV2xGL0s3NzI5dHRmS3hBbndoM1UyQ0pa?=
 =?utf-8?B?MERJRXczcit4UTVuKzJUOWV0NDVNc1RuZGc1VFV6cmVUSVZKWkJFRWFyODBk?=
 =?utf-8?B?QUxTdlIwdnJVbFpiZHkxQXA4bHpMc3QyUWIweFFnMTJQREdMRWpJUUdRdFYr?=
 =?utf-8?B?cG9tSWdzbE0veUhiSXBpWFo3V3QzaHh3eGpSaHJQYzRnMVVVVUVJZVdRRURq?=
 =?utf-8?B?eHNmdUVabWRrSlgyR0tUNFd2UXQ0TkZQUXpnamhNSm9LMEg1TlVJRXpibGg4?=
 =?utf-8?B?S0pwWmNQdUdweURnZDFwTXpsT1Y1S0JaR3VQSDNUK0JoMXJwVG1NZW4vaDZa?=
 =?utf-8?B?T0dkV1BDeExDY25SSTZhdDcwNnRPZmlvZXdpQ0ZjVTJhUTE1YWptNlRZdFVC?=
 =?utf-8?B?Z1l3SUs1cVMzcGRlY2VQeDRkaXR5U2RZRUxzNXplb2Rkd2hDSTh3U2MyYkxT?=
 =?utf-8?B?VGpraVNYdFp3dmI5OThibzcvdWcxWU16T2lhR1JLU1NvZTlXMlVNdUsySWFW?=
 =?utf-8?B?TlN0aC9rSjNCVGNXanVsWGw4WnJQZDQ5QTR0bTFVNStwZnRUREtTeTRXTTJL?=
 =?utf-8?Q?SeyIiCWs64RQF0UE=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3CE5A8000C29B740A8DE5C4E1273AA7A@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	uqcION3oRVPtjKgVEufWjn17BH/rzE+e2BuBixxGc3MX6LqP+zt1hBiu/lXLc/BgWrRGun2N11cOG9KzDtOz86n8FQcgXd0zqBFLKVmfVutCkGWjFIug4/v/prQGWmwss6+J2J4whk7GqL+EDZM3eKPK9wOLe/ImWhOxWcmgxlgHuHdmqzl8vA+KA8M4VXMXAl1s/vTnNRSYvKPBmC8VbaR3WVjMxEBAgxqFchJ/4fO73xd/YVd2jSgnItN5B2v9u+8RK2iJ1vRLEICHV5X/E7LsYzV5yAxSyAX9XKFFAsRFsatMkYrs6F6PLIkLka8FSv8nsw0lCkSzKGY2jhlA8A==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab499e59-9cc2-4aab-2fe4-08df2b57e2ea
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Oct 2026 07:34:17.8789
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2OzXH7UZJW10YLKY76CnAPGeR0m8fUAd5b1DbaF8DmpQkjbpJYQMTByqJEmGxEWgfxjH+DGyA6ZU69LCTfWxOj4nVZ+h7DJ4vDfzff/Plf4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR02MB9302
X-Authority-Analysis: v=2.4 cv=fuVJ914f c=1 sm=1 tr=0 ts=6ad1d37c cx=c_pps
 a=nTChkIIWaLHlKa6Ix9xfsg==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=660iZSQnnn4A:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VofLwUrZ8Iiv6rRUPXIb:22 a=Ap8k9tRZuQ82DLYWQqG7:22 a=20KFwNOVAAAA:8
 a=64Cc0HZtAAAA:8 a=HLskfZ5dVneFFkl1X8sA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: r0nDQ-TSI3sLbuU5boz-zbaxEaKaCeqt
X-Proofpoint-ORIG-GUID: r0nDQ-TSI3sLbuU5boz-zbaxEaKaCeqt
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE2MDAyOSBTYWx0ZWRfX++f+NUSNZZNh
 65V76IYvxxs1Gg88qeCIy0ZTCvxBbMwZR1LcypoOIsE1VsKP505MQtkOVztE2q8zYALw/S9jv1b
 /IOlOMnEdv0nYrI00PEa30LREk+OPuc=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE2MDAyOSBTYWx0ZWRfX8c8+VNpGHycZ
 fLl0qvUOkuqhVOCX7cHlEPnipbwe40q4kzlbvxgg1z/vmpD4qbNWeoicGMrTsQeJP3R/WtKERm3
 DFcVSuTPMnKJP7c/YONuuQMw/aB9n0VhmhmbOTL9Sk7RvzHCCPapNFaDc11O78qOHbuBY+ykBx/
 N1gwAYRlXjL6hqsBkqYREHpb6kUzN0OPSDSzM6MoikmReJsBLJcs6FhugyZ/LOIz/4JNoMw3Ixl
 orgWfSqfUI5HFJjW/G+4jTffL9RXy/OvHDybU9j9NCK6W2Slw1MOSHV45y1W9D95GCyz+8JryVs
 QBIqCah9NNHau/ZzjQ58HN+QgD/p39Bunb5onT6WdfydESylmwXQHMM8VYZSxRbcIOZmQfWdEAY
 tP/xCv70RhSrvYtt06ayXT0rb9UR2D7tnP+6mmIkzMrnDJd15Q0eEeFZ7Tle/8KqMj01SruzdDD
 6hygGQXqsaw0aPUPlbQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-14_01,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gMTUgT2N0IDIwMjYsIGF0IDY6MzHigK9QTSwgRXJpYyBBdWdlciA8ZXJpYy5hdWdl
ckByZWRoYXQuY29tPiB3cm90ZToNCj4gDQo+ICEtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tfA0KPiAgQ0FVVElPTjogRXh0
ZXJuYWwgRW1haWwNCj4gDQo+IHwtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tIQ0KPiANCj4gSGkgS2h1c2hpdCwNCj4gDQo+
IE9uIDkvMjEvMjYgMjozMiBQTSwgS2h1c2hpdCBTaGFoIHdyb3RlOg0KPj4gQXMgbmFtZWQgQ1BV
IG1vZGVscyBkZWZpbmUgdGhlaXIgZmVhdHVyZSBzZXQgZXhwbGljaXRseSwgdGhlaXIgU1ZFDQo+
PiB2ZWN0b3IgbGVuZ3RocyBhbmQgUEF1dGggZmllbGRzIG11c3Qgbm90IGJlIGRlcml2ZWQgZnJv
bSB0aGUgaG9zdC4NCj4+IA0KPj4gV2hlbiBTVkUgaXMgZW5hYmxlZCB3aXRob3V0IGFuIHN2ZTxO
PiBzZXR0aW5nLCByZXF1aXJlIHRoZSBuYW1lZCBtb2RlbA0KPj4gdG8gc3BlY2lmeSBpdHMgc3Vw
cG9ydGVkIHZlY3RvciBsZW5ndGhzIHJhdGhlciB0aGFuIGluaGVyaXRpbmcgdGhlbSBmcm9tDQo+
PiB0aGUgaG9zdC4NCj4+IA0KPj4gTmFtZWQgbW9kZWxzIHNldCBQQXV0aCBJRCByZWdpc3RlciBm
aWVsZHMgZGlyZWN0bHkgdGhyb3VnaCBTWVNSRUdfDQo+PiBwcm9wZXJ0aWVzLiBQcmVzZXJ2ZSB0
aGVzZSB2YWx1ZXMgaW4gUEF1dGggZmluYWxpemF0aW9uLg0KPj4gDQo+PiBTaWduZWQtb2ZmLWJ5
OiBLaHVzaGl0IFNoYWggPGtodXNoaXQuc2hhaEBudXRhbml4LmNvbT4NCj4+IC0tLQ0KPj4gdGFy
Z2V0L2FybS9jcHU2NC5jIHwgMzMgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrDQo+
PiAxIGZpbGUgY2hhbmdlZCwgMzMgaW5zZXJ0aW9ucygrKQ0KPj4gDQo+PiBkaWZmIC0tZ2l0IGEv
dGFyZ2V0L2FybS9jcHU2NC5jIGIvdGFyZ2V0L2FybS9jcHU2NC5jDQo+PiBpbmRleCA3NDg3YjQ4
Y2M5Li5hMDExNGIwZmEyIDEwMDY0NA0KPj4gLS0tIGEvdGFyZ2V0L2FybS9jcHU2NC5jDQo+PiAr
KysgYi90YXJnZXQvYXJtL2NwdTY0LmMNCj4+IEBAIC0zOCw2ICszOCw3IEBADQo+PiAjaW5jbHVk
ZSAiaW50ZXJuYWxzLmgiDQo+PiAjaW5jbHVkZSAiY3B1LWZlYXR1cmVzLmgiDQo+PiAjaW5jbHVk
ZSAiY3B1LWlkcmVncy5oIg0KPj4gKyNpbmNsdWRlICJjcHUtbW9kZWxzLmgiDQo+PiAjaW5jbHVk
ZSAidHJhY2UuaCINCj4+IA0KPj4gLyogY29udmVydCBiZXR3ZWVuIDxyZWdpc3Rlcj5fSURYIGFu
ZCBTWVNfPHJlZ2lzdGVyPiAqLw0KPj4gQEAgLTEzNCw2ICsxMzUsMjEgQEAgdm9pZCBhYXJjaDY0
X2NwdV9zdmVfZmluYWxpemUoQVJNQ1BVICpjcHUsIEVycm9yICoqZXJycCkNCj4+ICAgICAgICAg
ICAgIHJldHVybjsNCj4+ICAgICAgICAgfQ0KPj4gDQo+PiArI2lmbmRlZiBDT05GSUdfVVNFUl9P
TkxZDQo+IEkgZG9uJ3QgZ2V0IHdoeSBkbyB5b3UgbmVlZCB0aGF0ICNpZm5kZWY/IA0KSGkgRXJp
YywNCg0KWWVhaCwgdGhhbmtzLCByZW1vdmVkLg0KPj4gKyAgICAgICAgLyoNCj4+ICsgICAgICAg
ICAqIElmIFNWRSBpcyBlbmFibGVkIGJ1dCBubyB2ZWN0b3IgbGVuZ3RocyBhcmUgc3BlY2lmaWVk
LCB3ZSBtdXN0IG5vdA0KPj4gKyAgICAgICAgICogZGVmYXVsdCB0byB0aGUgaG9zdCdzIHN1cHBv
cnRlZCBsZW5ndGhzIGZvciBuYW1lZCBDUFUgbW9kZWxzLg0KPj4gKyAgICAgICAgICovDQo+PiAr
ICAgICAgICB7DQo+PiArICAgICAgICAgICAgQVJNQ1BVQ2xhc3MgKmFjYyA9IEFSTV9DUFVfR0VU
X0NMQVNTKGNwdSk7DQo+PiArICAgICAgICAgICAgaWYgKGFjYy0+aW5mbyAmJiBhcm1fZmluZF9t
b2RlbChhY2MtPmluZm8tPm5hbWUpKSB7DQo+PiArICAgICAgICAgICAgICAgIGVycm9yX3NldGco
ZXJycCwNCj4+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAiTmFtZWQgQ1BVIG1vZGVscyB3
aXRoIFNWRSBtdXN0IHNldCB2ZWN0b3IgbGVuZ3RocyIpOw0KPj4gKyAgICAgICAgICAgICAgICBy
ZXR1cm47DQo+PiArICAgICAgICAgICAgfQ0KPj4gKyAgICAgICAgfQ0KPj4gKyNlbmRpZg0KPj4g
Kw0KPj4gICAgICAgICBpZiAoa3ZtX2VuYWJsZWQoKSkgew0KPj4gICAgICAgICAgICAgLyogRGlz
YWJsaW5nIGEgc3VwcG9ydGVkIGxlbmd0aCBkaXNhYmxlcyBhbGwgbGFyZ2VyIGxlbmd0aHMuICov
DQo+PiAgICAgICAgICAgICB0bXAgPSB2cV9pbml0ICYgdnFfc3VwcG9ydGVkOw0KPj4gQEAgLTU1
Niw2ICs1NzIsMjMgQEAgdm9pZCBhYXJjaDY0X2NwdV9wYXV0aF9maW5hbGl6ZShBUk1DUFUgKmNw
dSwgRXJyb3IgKiplcnJwKQ0KPj4gICAgIEFSTUlTQVJlZ2lzdGVycyAqaXNhciA9ICZjcHUtPmlz
YXI7DQo+PiAgICAgdWludDY0X3QgaXNhcjEsIGlzYXIyOw0KPj4gDQo+PiArI2lmbmRlZiBDT05G
SUdfVVNFUl9PTkxZDQo+PiArICAgIC8qDQo+PiArICAgICAqIEZvciBuYW1lZCBDUFUgbW9kZWxz
IHRoZSBtb2RlbCBwcm9wcyB3cml0ZSB0aGUgYXV0aG9yaXRhdGl2ZQ0KPj4gKyAgICAgKiBBUEEv
QVBJL0FQQTMvR1BBL0dQSS9HUEEzIHZhbHVlcyBkaXJlY3RseSBpbnRvIGNwdS0+aXNhciB0aHJv
dWdoDQo+IGFsbCB0aG9zZSBmaWVsZHMgYXIgbm90IEtWTSB3cml0YWJsZSBjdXJyZW50bHkuDQpD
b3JyZWN0LCBidXQgaGVyZSB3ZSBhcmUgbGV0dGluZyB0aGUgbmFtZWQgbW9kZWwgYnVpbGQgaXTi
gJlzIElEIHJlZ2lzdGVyIHZpZXcuDQoNCkxhdGVyIGluIHdyaXRlYmFjayAoYmFzZWQgb24gdjkp
LCB3ZSBlcnJvciBvdXQgaWYgdGhlIEtWTeKAmXMgYW5kIG1vZGVs4oCZcyBJRCANCnJlZ2lzdGVy
IHZpZXcgZGlzYWdyZWUuDQoNCj4+ICsgICAgICogU1lTUkVHXyBwcm9wZXJ0aWVzLCBzbyBkbyBu
b3Qgb3ZlcnJpZGUgdGhlbSBoZXJlLiBTaW5jZSBvdGhlciBjb2RlDQo+PiArICAgICAqIHJlbGll
cyBvbiBjcHUtPnByb3BfcGF1dGgsIG1pcnJvciB0aGUgcmVzdWx0aW5nIHBhdXRoIHN0YXRlIGlu
dG8NCj4+ICsgICAgICogY3B1LT5wcm9wX3BhdXRoLg0KPj4gKyAgICAgKi8NCj4+ICsgICAgew0K
Pj4gKyAgICAgICAgQVJNQ1BVQ2xhc3MgKmFjYyA9IEFSTV9DUFVfR0VUX0NMQVNTKGNwdSk7DQo+
PiArICAgICAgICBpZiAoYWNjLT5pbmZvICYmIGFybV9maW5kX21vZGVsKGFjYy0+aW5mby0+bmFt
ZSkpIHsNCj4+ICsgICAgICAgICAgICBjcHUtPnByb3BfcGF1dGggPSBjcHVfaXNhcl9mZWF0dXJl
KGFhNjRfcGF1dGgsIGNwdSk7DQo+PiArICAgICAgICAgICAgcmV0dXJuOw0KPj4gKyAgICAgICAg
fQ0KPj4gKyAgICB9DQo+PiArI2VuZGlmDQo+IElmIEkgdW5kZXJzdGFuZCBjb3JyZWN0bHkgYWxs
IHRoZSBpc2FyMS9pc2FyMiBtYW5pcHVsYXRpb25zIGFmdGVyd2FyZHMNCj4gb25seSBhZmZlY3Qg
VENHLiANCj4gSW4gS1ZNIG1vZGUsIGFsdGhvdWdoIGlzYXIxL2lzYXIyIGZpZWxkcyBhcmUgcmVz
ZXQgYWZ0ZXJ3YXJkcyB0aGlzIGRvZXMNCj4gbm90IGltcGFjdCB0aGUgZ3Vlc3QgdmlldyBzbyBt
b3N0IHByb2JhYmx5IHRoZSBpc2ExLzIgcmVzZXQgKyBmaW5hbGUNCj4gdXBkYXRlIGNvdWxkIGJl
IG1vdmVkIHRvIHRoZSAhaHdfYWNjZWwgYmxvY2sgYW5kIHlvdSBwdXQgdGhhdCBhZGRpdGlvbg0K
PiBpbiB0aGUgaHdhY2NlbF9lbmFibGVkKCkgYmxvY2ssIG9yIGFtIGkgd3Jvbmc/DQoNCkZvciB0
aGUgY3VycmVudCBwYXRjaCBzZXJpZXMsIHRoZSBRRU1VIGlkcmVnc1tdIGRpcmVjdGx5IGFmZmVj
dHMgS1ZN4oCZcw0KaWRyZWdzLiBTbywgaWYgcGF1dGggaXMgZGlzYWJsZWQsIEtWTSB3aWxsIGVy
YXNlIF9BUEEvX0dQQSwgZHVyaW5nDQp3cml0ZWJhY2sgY2hlY2sgdGhhdCBLVk3igJlzIF9BUEEv
X0dQQSBtYXRjaGVzIFFFTVXigJlzIHZhbHVlcy4gU28sIGlmIHdlDQpkbyBub3QgcmVzZXQgdGhl
c2UgaGVyZSwgdGhlbiB0aGUgY29uZGl0aW9uIHdpbGwgZmFpbC4NCg0KSSBuZWVkIHRvIGxvb2sg
YXQgdjEwIGluIGRldGFpbCB0byB1bmRlcnN0YW5kIHdoYXQgd2lsbCBoYXBwZW4gdGhlcmUuDQoN
ClRoYW5rcywNCktodXNoaXQNCg0KPiBUaGFua3MNCj4gDQo+IEVyaWMNCj4+ICsNCj4+ICAgICAv
Kg0KPj4gICAgICAqIFRoZXNlIHByb3BlcnRpZXMgZW5hYmxlIG9yIGRpc2FibGUgUGF1dGggYXMg
YSB3aG9sZSwgb3IgY2hhbmdlDQo+PiAgICAgICogdGhlIHBhdXRoIGFsZ29yaXRobSwgYnV0IGRv
IG5vdCBjaGFuZ2UgdGhlIHNldCBvZiBmZWF0dXJlcyB0aGF0DQo+IA0KDQo=
