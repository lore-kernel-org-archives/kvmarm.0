Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE3CF40B0FB
	for <kvmarm@lists.linux.dev>; Mon,  3 Aug 2026 14:32:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785767559; cv=fail; b=DFaf8x0/NZC5u+BNysN31wGy9aX/IjobdGg6bimlqg7IvoF3g5G+C8GX+My8mcSxS9cTQL3j3MAtRQMpJug57HkddXEGcYSYYs3rjCLgihpRI3SshyR8KLbVBYPNYCdNMnnKaxDKUKTG2gBzu4JBLxm/0XSIM/8n21kb0pcMt4Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785767559; c=relaxed/simple;
	bh=hEI/i8KNR63lj69FTEtyiTaBM+OlnfxCp+13c2tkjHM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=plPpK6dPECwAb0t1w4qEmy+tE7K3nEKxhvuZS+1IZymLVrQbxbOGytZKRsAneT8Ola5391ZpwWa7eiXRYpD4FBRAuebVOnirMV8MdKXsvncSX7boWbdORXqMbL2MttitDf8s4SIAaNjiPw4jBEP5pakoxh11uuIZWhvnFOoEF0M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=jsZybx0v; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=HbuYEKDC; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="jsZybx0v";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="HbuYEKDC"
Received: from pps.filterd (m0127843.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 673EE6hR1845586;
	Mon, 3 Aug 2026 07:32:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=hEI/i8KNR63lj69FTEtyiTaBM+OlnfxCp+13c2tkj
	HM=; b=jsZybx0vjaaFyN36apT5xDIFU/YUhgN7+U3+8dWL08fEao0/qa8SWGljH
	NgjEJ/QeKrbj2OrLUOwxkiac7UJFURNPN41Id6FP36L3+evCyH2A4HPxSGpykzLS
	BhvBvLzPyF1OUcPBxYZtPfr5HNvMcluHqa967h1td3Vv03NLn/KgHaA1zP+sL843
	zJkvH89CDU1Dv1rlBA7tEhwA3XtLb8WWc43Yq3fJ6SdcFbh8IyUAp7UaLDK97C3K
	wsEdYWKPSq52R2s3NOO+sbf/wZBWE/mvAkZNRjRy9ra2NESZ0WIE0d04YedUt45s
	Xb+Nz9jjuzBaV/8q08adJhJnZQnPw==
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11020099.outbound.protection.outlook.com [52.101.201.99])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4fsewf3qyb-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 03 Aug 2026 07:32:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=o/bspmfLBTUYMRdKSxPGsT2lLj8ehgMiQ23ueCt8zNAUsQfmDXgmiH+ub9O9ycWtUGxaqR5TeK8NZjJrxEpK2Trd/+NJst1NW//q6eCxNaDTWlAuUPw+2SJ7465USaGVrEOXTPDCkA9NmolpnvlJid/SlfL8hilBZOk/sz9J2IMX2C6BYYTndsJqcZCetSdco7XhV2Lid0TExzKL+LsmH5po96Cci+IkbquZxnrsH4dwL9L6G9xLWPJjx3pj9Y2LHlw2oihtsK5arnmdll8Aeew5c7IAEhw635/JdnJ8nXK8TbMKJ6XkPgHyRCrMg56iIgE1xOuJl91NcxYDqHL64g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hEI/i8KNR63lj69FTEtyiTaBM+OlnfxCp+13c2tkjHM=;
 b=FZKM1I1rw33WnCPfZjhHfkovGQ424y6Sg66RK0BdYj1ojWSWA2rrUdX//JbSZJsQTCnX/TIRAUidoWfSeTS5IzaACErceWJQpqCpKQgReTCZMeDkSR/jnYK6h2OZuT6WRjSXRo1Wd5M/FDd7XlwXYOOa6rOKGYkC2nB6tPyTOieAOAUOjS0Kxu0h94XwrKRYSh4PSyRZHaiSphKUL+RzBO5M4ah5Oq5PBVK/Qp21ZhgXl5I3ysk0QCxcljsDt/WDKnzZi6+2oxk+e7MLcmFx+N3HLmiBCC+8kYt66/5HOUPC5cbzjAafrY97ZJnq455Kii+7CU8+TGNS+GPOjtBmGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hEI/i8KNR63lj69FTEtyiTaBM+OlnfxCp+13c2tkjHM=;
 b=HbuYEKDCz0kTZ3p2SpNO2nDeDuqJJcDkaK9LWL9DEP9Vm0LfE1JiDvKR91hhQpXTqDOeAKwirIIEmHLbRBgBW7TZmUex2o42FamfU2DSps9nE3xEdRixFqXatkADSGwhMV0ew+YTFg3WQclzUcGOC2hmVhPK0w6YxI5I4N2T91exKgl/HZr9pDqpZr60mxwvPOInYcVdceq8ScXpE0jlzYA3yjCslK1rTvqreglrOdOtzoE8QyaPWfyvmY+d9SJudeoUbi1Wsg9h0nkVA+BXyeDO1UanvUSap7QDTR4aoLcXl7haZ8yf3/+M02BzKZ6dWLPKXunhMLizv4GBBMjYSw==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by DS0PR02MB10201.namprd02.prod.outlook.com (2603:10b6:8:1a8::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.17; Mon, 3 Aug
 2026 14:32:13 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%5]) with mapi id 15.21.0270.016; Mon, 3 Aug 2026
 14:32:13 +0000
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
        Prerna Saxena <prerna.saxena@nutanix.com>
Subject: Re: [RFC PATCH v3 02/19] scripts: bug fixes in
 update-aarch64-cpu-sysreg-properties
Thread-Topic: [RFC PATCH v3 02/19] scripts: bug fixes in
 update-aarch64-cpu-sysreg-properties
Thread-Index: AQHdFWuUW7xD36Uxa0axgITHGLlSqbZ2fDsAgBYCnQA=
Date: Mon, 3 Aug 2026 14:32:13 +0000
Message-ID: <7B85F7CA-C4CB-4EAD-BCB1-6D2135934F5B@nutanix.com>
References: <20260716213858.609699-1-khushit.shah@nutanix.com>
 <20260716213858.609699-3-khushit.shah@nutanix.com>
 <b839f20a-da50-493c-9b71-78069b62b867@redhat.com>
In-Reply-To: <b839f20a-da50-493c-9b71-78069b62b867@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA2PR02MB7564:EE_|DS0PR02MB10201:EE_
x-ms-office365-filtering-correlation-id: ef402f45-1ce4-43f6-4f06-08def16c024d
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|7416014|1800799024|23010399003|366016|18002099003|22082099003|38070700021|6133799003|3023799007|56012099006|4143699003|10067099003;
x-microsoft-antispam-message-info:
 3RpIfP0O+qwtaAcpDHBJxCcLW4QgdufwFLIMWT52ts7zQNmp9nq7678BCFaKFhNX/9oWksyYtcqaoJdRSMq5FV2JKCxaQCT+jw1n/5ISo5gngUYkWNUzsA1kBn35u8+/BnHqBNvtbsMUJny9j84ua0l4emYtcRFhnjS7rw4UuYO7oTjebY+X+TYV3o5ADALJIjwVvStE7rAGCwOYKPqL9buFtSCvEwoSnOLHw7+R5V7vV9llSHZKSl2gkGr3bWvcWy7NdMwgAl09Nvx4IpMBMF6WEAbXOxXerXCqmZpr8J54YX+lbt9+LYYOlIBc+WEoX45XHvxamAcjOOyTEKIt07HygFU/Urc0qmY1BNMSkRFOdExVhMPC9xmhEzf6cnatZLA+nvUAKALwxLcByIPhagyHGNYE8GlfUw0pOt/r9OuvQiMnQAqfbWjZV5nuqJJU9aGuejHNOnPzJpsYMbNTlc0N+Svb2+cGaxNJ5bDU0DSTCMiPBRS7FOvTdFy7R73/1UACJtDtjABMZBqPNjfDxyr1hX24TWPzU+6PE93rEVYlkACg+vOGTyOAkXfFqE2wc4mz/Gho2cdrQCCRg+y+mTrS+e8jsbf+8R1CZoEXkOBN6VBO2uh3mlFCiEO0FTcaxa5GFHMrAxBcKCBlLJjN4Yz4pF9IdXbsPdw2oBNAfV/L0lfsz2BlR1/mTGa+Wuw2KnuUXGmdeSRyWUEO4YoW/w==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(23010399003)(366016)(18002099003)(22082099003)(38070700021)(6133799003)(3023799007)(56012099006)(4143699003)(10067099003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?RjRkVHFxeWZxYmxDbHdSdHpDL2pEcjAydzRRdmpuUmtGTTRxUVcvWHpGY0tB?=
 =?utf-8?B?QTY3eWJiNFVjMHI1QXpjOS9udTR0bVZGMXJZME1iUUFsWmc1enJlcDhJcDZQ?=
 =?utf-8?B?YTBUUHdIdzNEbFMvcW9XS0d6ZzNkMHZ2T052WWV0TmpOSm9PdHVlWEt4K0xC?=
 =?utf-8?B?YW9neit2QzJkZXpydjNKLzBNM3hhOUhoSHdhL0ZNYXpLd2J1bkdUVFdvQVVT?=
 =?utf-8?B?TXRqMk1QbkV3TnZWZmFVM3JlcUdDQWJvZEdOZ242bE4xR05ib0k3bUxNMUhk?=
 =?utf-8?B?MFlKNkc4Y1VPOVVsbmpSTHJRaTJNQ3M5dlBuWlhvZUIxekxpMzEwcjJoUTMv?=
 =?utf-8?B?TGMzSFVxRGdDY2l2d1RNRWRJWGdiMjFRdXVVODZIbEZIL1JRUkw3QklzaTFs?=
 =?utf-8?B?MFFXb1d3eW5FNWxodnBrVmw5V1gyZEJHaStIbWg5ZWFVNGlCT21zZUQ0UUVh?=
 =?utf-8?B?Z1p4cmFRYXFTUEg1REFXUHA3bFpwUjR5Y2tMSkFNV2NEWWVxZEhLYzR6Y1Vo?=
 =?utf-8?B?MzhYTW1zSDJZaTdsdlhjRFdyRFpKaWNFMlZZUTFPNHdRSG5QQmxBQ1hZdnhT?=
 =?utf-8?B?bGIrUmQ0U0hsLzRHc3R4bnFxdlBXMHU4cmlBSWEzUElBb0FVMEp5b0twUldK?=
 =?utf-8?B?bk4wMEs0RksreVVDYjdMOHBETlVVN1NkYjdmQ3IzalpVc2U0ZVYzczZ0WHRr?=
 =?utf-8?B?S2lTSjhiUDNxOUMzTVFJcE0yVk5JRVdyVjBrV1pzQjBnN1RDb1JCY3JiMjk4?=
 =?utf-8?B?ZXFzd3ByWWNONndXVmU4Sk5LSXREUGhqQ1A4eWJsSUtuS24vbGhaZkt6Q3Z5?=
 =?utf-8?B?dEtGaDJ3UW9ScE52U0o5b0UrT3RiS1doYXNsMDRnNTNxdk9IUUg5cTk5VEor?=
 =?utf-8?B?dDRLTHRHdGZ2NGdJVHdwWktqWmNISUdhVXFaT0lvTlFudkxFOXU1SlhJdHVJ?=
 =?utf-8?B?SnpnaFdidHdQYlhlV0o3OWEyQktCQU9iUmlpQzB3MDFYdzFLNjRaWU9lL1ZB?=
 =?utf-8?B?NTBYVTdNcW9QSkl5SjFNTkllZmJGNDRaMWZ2VHl2bUFWVmt1UG1JVzJuWjA4?=
 =?utf-8?B?QkhOK0lOS2lDaWFFLzFCS09jcCt0YUh1ZmcrSDFweXYyWDhxbmlKWTJCalZt?=
 =?utf-8?B?ODRZekJPV0lwVmNIbFlzSjg3bndXVUIrdXcxeDY2QUVPcGVseC9LaTZyUTNC?=
 =?utf-8?B?Z0lXcFJiSEhEUmoxdnpJYnpQUWZucHQxTjd0Q2llL0E1UmJpcHJyVk40VlhE?=
 =?utf-8?B?NnplaXZGdnhUSHVSbnZrM1ZiL1JlNFBSMDV2a0xIZzRjNnZielBla3NBK1Vz?=
 =?utf-8?B?OFMrZ1NCMll4WEZoYXRhRTBGdGdyaU5GVVE0SFMrSkdwckZEV1NKemFMV3A1?=
 =?utf-8?B?V1BVMGJ0YitxNi9VQ1hZZUdrRmdsakd5aVpkdjRmWXVFa0d1djFXU05xZ1ph?=
 =?utf-8?B?eHhSeVlRRFp6ZFNRWFQ2NTlSd3ZkUnpVM0tDN3BGT2UzTkcxcm1sRm1uNTZF?=
 =?utf-8?B?YlFaSk9lRlM2dWhxRjlCY2ZaaGpTVnM5d2ZaVGFpYmhUb0svbFdTQS9jQjh0?=
 =?utf-8?B?NW5md0JPMENORFJ0ejlpcDVuWFhKV0R2S04wTC84YUk3TDNmTXdUQ3NhcU9m?=
 =?utf-8?B?Vlh0SVQzbkhUVDVZYUZCSnI4cmFlR0FweGprakFYc0x0K09GQVloTDhzRVhL?=
 =?utf-8?B?S2M2OW00UW5vRWdyT2d1aE1PT0FmQVhpTjNWL3BIV2hENTJZTVNuM0xaM1FH?=
 =?utf-8?B?THY5QXA5OVZwTUFoNkxTbmtCQ3hQN0xnT1NQSjY1TEtjcnJ1dGliZ2YrODBs?=
 =?utf-8?B?eEgvOEgrd28wa2lPYVF3S0QrSEdKQmk2RGdwdE5OSmRTSUlXWXo1R1RKemVn?=
 =?utf-8?B?ZkNRWk1CU05uUnZzZ0hnMVdOdytEUW4vVWxId3l1c2oyV0VmUSsvNjFsTk9V?=
 =?utf-8?B?blpLWWp1SjZwMUE4K1QxVjlHc3lra1RDTjRWbTUwUmRvYmtVZTRZbEpadjcy?=
 =?utf-8?B?RWVxaU1xcFVrVVllT25rWjVXSjdqOXdaOTFGZzAxR0pDNkJkZE1DMStxWUFy?=
 =?utf-8?B?NHIvQ1F4NWJuYXZuSWFGc2Q3SWhpeWd6T3p0TXJpY25YQ1k1bnkyenJUbnVv?=
 =?utf-8?B?N2w3c29YT0lwa3NvKzRjUC9kWlZhb3FhZWRnTDgyZE5IaXBjZ3ZraDVFL1ll?=
 =?utf-8?B?aGRuZWRZbTdOUHBsZHQzNnF6M2hEV3djRDhDZ3lLZ25GRHlEaFlGM0NDNkh6?=
 =?utf-8?B?SUlqWXJUb3ZsREZlcjFXTUhJc3hSWENGaDN1dVJwYTYrOUo1RnF4c3N0ODFI?=
 =?utf-8?B?dzFUZTl6dHpNZmpmdHdJZ3J6OTNFM0hpZGdMcEN2R0hBMHpaSkcvMXdrdFl0?=
 =?utf-8?Q?OiNBHcuoHSKnGsJ8=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FB391CBC360FB146A6FAC19B97B62E1E@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	mt2liWPjBjtMA18P3tJK0VkAOjO8pNnbKQmtm3pMbKbfVUh/7gHLJvfyvf9uGnWoVonT+gjClLjCwMvOWO/Fj4OR6H6rU/t3JWM+aFB5SNIPgUm5P9HUCPnIyHt6YFM4i8CNZ01VXi1+FQ4oPo7SVUIb2TGRDHfinxiRLc05TAcneKb4TCAJs5u/nqQin8R+lNQkvfqaXURVceOqFbv6jFB5erXAqnFyPY3Ad3hXVUwbNDgUDSHAIkiTucN735Bo0uK/K8fhsTm5THK6uk8rIW9tshh/Bvh0hBy7UaBRpkeo+nydQ4iVblW4lng826pZgE3apPAK2wD/h+gqRXMzqQ==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef402f45-1ce4-43f6-4f06-08def16c024d
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Aug 2026 14:32:13.0263
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +/x2dqk9gl8NQQ0+wrZdBJtNG1GToLPaHClxrPa+yUMcMio5uVsGF6LWNGOmCQXpAUdrbFp+Mk4N5D1iPT8a3mdwopmayjjHu/T9qSrZMaQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR02MB10201
X-Proofpoint-Spam-Info: AW1haW4tMjYwODAzMDEzMSBTYWx0ZWRfX4Nf2peH947MZ
 GjOVp6gU+IO26RRJcvJH3Gr0z0fFDGiUuN/+bQu4zuTPifD6YCFv/scR2NNxj+MTz8FEWZf3I5h
 MI1PTLzu8ISMQY9+tne9bGurJJWnxgY=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODAzMDEzMSBTYWx0ZWRfX1QtqPO8yW2pm
 /J08kiuj6fwLfxiYYnP+ygp5ggXDLd26piFyOKoogMJ+4QFysOCZ4yHooQNagm9+LMakTnNAh53
 wzTRvkFE3t6R0CC6PKiv7pE1hGA3HPUJugECIa92VqDb8kgfsXcuZr6I82Y8ndacJH3EUrIBqDP
 NT7cIrmd4W6mmqjV2DFz3vuftVq41n/dz/GE3emztjvERrPq8bpBqOGc4y8AveTvsQQszgumxW6
 xJQpBj1e/kPT4Z1WDSPMDo4D7Lh+Jvr4ZOMsuiVPi3KSBgU0n5Dcoe26hxhpTfL8tBPBrKo1aO2
 Z9DFjKPjl9E4fUUxAumPVS/mdxQgmjO1XNYCOX4xhRbkQrn+z0zBsqVCrzfBzB5+pXxJrG1IRbb
 ojtLXf/xuH9UDW1ESWzCCFY9UCVr3/F70OI5XDZKV4CQcq2x2bOz0RMzVlNDAifES5vQHut8Whb
 ra7YZR81Pos4oiJvd3w==
X-Proofpoint-GUID: H6ntX1tIalfcwoHDqCtB2Hq9bnNR51H0
X-Authority-Analysis: v=2.4 cv=FfgHAp+6 c=1 sm=1 tr=0 ts=6a70a670 cx=c_pps
 a=kJh41/vVy0mmRivLipeQDA==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Sv0fKeRqtYgA:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VofLwUrZ8Iiv6rRUPXIb:22 a=dEe9Ve2bX-KnNSUMM2s9:22 a=20KFwNOVAAAA:8
 a=64Cc0HZtAAAA:8 a=2YeejPGHgxji9U3td4oA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: H6ntX1tIalfcwoHDqCtB2Hq9bnNR51H0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-03_03,2026-08-03_02,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gMjAgSnVsIDIwMjYsIGF0IDc6NTTigK9QTSwgRXJpYyBBdWdlciA8ZXJpYy5hdWdl
ckByZWRoYXQuY29tPiB3cm90ZToNCj4gDQo+ICEtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tfA0KPiAgQ0FVVElPTjogRXh0
ZXJuYWwgRW1haWwNCj4gDQo+IHwtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tIQ0KPiANCj4gDQo+IA0KPiBPbiA3LzE2LzI2
IDExOjM4IFBNLCBLaHVzaGl0IFNoYWggd3JvdGU6DQo+PiAtIGhhbmRsZSBxdW90ZWQgYml0c3Ry
aW5ncyAgYW5kIGRlY2ltYWwNCj4+IC0gc2tpcCBWYWx1ZXMuVmFsdWVSYW5nZSBlbnRyaWVzLg0K
PiBUaGUgYWJvdmUgaXMgdGhlIGlzc3VlIHlvdSByZXBvcnRlZCBvbiBteSB2Ni4gU2VlIG15IGNv
bW1lbnQgb24gdGhlDQo+IG90aGVyIHRocmVhZC4NCkFja2VkLg0KPj4gLSBFbWl0IHVuaXF1ZSBS
RVN4X3tsc2J9IG5hbWVzIGZvciByZXNlcnZlZCBmaWVsZHMgc28gbm8gdHdvIGZpZWxkcyBpbg0K
Pj4gIGEgcmVnaXN0ZXIgc2hhcmUgYSBuYW1lLg0KPiBUaGUgcmVxdWlyZW1lbnQgZm9yIG5hbWlu
ZyBSRVMgZmllbGQgbmVlZHMgdG8gYmUgZXhwbGFpbmVkLiBJIHVuZGVyc3RhbmQNCj4gdGhhdCBu
b3cgeW91IGV4cG9zZSBhbGwgZmllbGRzIGluY2x1ZGluZyB0aG9zZSB3aGljaCBhcmUgbm90IHdy
aXRhYmxlIGl0DQo+IG1heSBiZSByZXF1aXJlZCBidXQgYXQgdGhpcyBzdGFnZSBJIHN0aWxsIGZh
aWwgd2h5IHRoaXMgaXMgcmVxdWVzdGVkLg0KSSB0aGluayB3ZSBkb27igJl0IG5lZWQgdG8gZXhw
b3NlIFJFUyBmaWVsZHMgdG8gdXNlcnMuIA0KSSB3YXMgdGhpbmtpbmcgb2YgY2FzZSB3aGVyZSBh
IFJFUzAgZmllbGQgaXMgcmVwdXJwb3NlZCBmb3INCnNvbWV0aGluZyBlbHNlLCBidXQgdGhhdCBz
aG91bGQgYmUgdGFrZW4gY2FyZSBieSB6ZXJvaW5nIHRoZQ0KSUQgcmVncyBhcnJheSBiZWZvcmUg
aW5pdGlhdGluZyB0aGUgbmFtZWQgbW9kZWwgaGllcmFyY2h5Lg0KKFJFUzEgZmllbGQgaW4gQ1RS
X0VMMCBuZWVkcyBzb21lIGhhbmRsaW5nKS4NCg0KT24gd2h5IHdlIGV2ZW4gbmVlZCB0byBleHBv
c2Ugbm9uLXdyaXRhYmxlIGZpZWxkczoNCi0gQXNzdW1lIHNvbWUgbm9uLXdyaXRhYmxlIGZpZWxk
IG1pc21hdGNoZXMgZm9yIHRoZSBtb2RlbCBhbmQNCiAgaG9zdCwgd2h5IGRvIHdlIHdhbnQgdG8g
c3RvcCB1c2VycyBmcm9tIGV4cGxpY2l0bHkgb3ZlcnJpZGluZw0KICB0aGUgbW9kZWwncyBmaWVs
ZCB2YWx1ZSB0byBob3N0IHZhbHVlPw0KDQo+PiAtIEVtaXQgYSBkdW1teSA2NC1iaXQgVkFMIGZp
ZWxkIGZvciByZWdpc3RlcnMgd2l0aCBubyBkZWZpbmVkIGZpZWxkcywNCj4+ICBzdWNoIGFzIEFJ
RFJfRUwxIGFuZCBSRVZJRFJfRUwxLg0KPiBUaGlzIGlzIHlldCBhbm90aGVyIGZ1bmN0aW9uYWwg
Y2hhbmdlIHRoYXQgY291bGQgYmUgc2VwYXJhdGUuDQpBY2tlZCwgd2lsbCBkbyBpbiB2NC4NCg0K
PiBUaGFua3MNCj4gDQo+IEVyaWMNCj4+IA0KPj4gU2lnbmVkLW9mZi1ieTogS2h1c2hpdCBTaGFo
IDxraHVzaGl0LnNoYWhAbnV0YW5peC5jb20+DQo+PiAtLS0NCj4+IC4uLi91cGRhdGUtYWFyY2g2
NC1jcHUtc3lzcmVnLXByb3BlcnRpZXMucHkgICB8IDY3ICsrKysrKysrKysrKystLS0tLS0NCj4+
IDEgZmlsZSBjaGFuZ2VkLCA0NSBpbnNlcnRpb25zKCspLCAyMiBkZWxldGlvbnMoLSkNCj4+IG1v
ZGUgY2hhbmdlIDEwMDY0NCA9PiAxMDA3NTUgc2NyaXB0cy91cGRhdGUtYWFyY2g2NC1jcHUtc3lz
cmVnLXByb3BlcnRpZXMucHkNCj4+IA0KPj4gZGlmZiAtLWdpdCBhL3NjcmlwdHMvdXBkYXRlLWFh
cmNoNjQtY3B1LXN5c3JlZy1wcm9wZXJ0aWVzLnB5IGIvc2NyaXB0cy91cGRhdGUtYWFyY2g2NC1j
cHUtc3lzcmVnLXByb3BlcnRpZXMucHkNCj4+IG9sZCBtb2RlIDEwMDY0NA0KPj4gbmV3IG1vZGUg
MTAwNzU1DQo+PiBpbmRleCA5ZTgyOWZkYTJlLi5lY2MzNWRiNTI4DQo+PiAtLS0gYS9zY3JpcHRz
L3VwZGF0ZS1hYXJjaDY0LWNwdS1zeXNyZWctcHJvcGVydGllcy5weQ0KPj4gKysrIGIvc2NyaXB0
cy91cGRhdGUtYWFyY2g2NC1jcHUtc3lzcmVnLXByb3BlcnRpZXMucHkNCj4+IEBAIC0xMDYsNiAr
MTA2LDI5IEBAIGRlZiBjb2xsZWN0X2ZpZWxkcyhpdGVtLCBiaXRfb2Zmc2V0PTApOg0KPj4gDQo+
PiAgICAgcmV0dXJuIGZpZWxkcw0KPj4gDQo+PiArZGVmIHBhcnNlX3ZhbHVlX2ludChyYXdfdmFs
KToNCj4+ICsgICAgaWYgcmF3X3ZhbCBpcyBOb25lIG9yIGlzaW5zdGFuY2UocmF3X3ZhbCwgYm9v
bCk6DQo+PiArICAgICAgICByZXR1cm4gTm9uZQ0KPj4gKw0KPj4gKyAgICAjIG1heSBhbHJlYWR5
IGJlIHJlYWwgbnVtYmVyDQo+PiArICAgIGlmIGlzaW5zdGFuY2UocmF3X3ZhbCwgaW50KToNCj4+
ICsgICAgICAgIHJldHVybiByYXdfdmFsDQo+PiArDQo+PiArICAgIHJhd19zdHIgPSBzdHIocmF3
X3ZhbCkuc3RyaXAoKQ0KPj4gKw0KPj4gKyAgICBpZiAiJyIgaW4gcmF3X3N0cjoNCj4+ICsgICAg
ICAgICMgcXVvdGVkIGJpdHN0cmluZyBsaWtlICInMDEwMCciDQo+PiArICAgICAgICBiaXRzID0g
cmF3X3N0ci5yZXBsYWNlKCInIiwgIiIpDQo+PiArICAgICAgICB0cnk6DQo+PiArICAgICAgICAg
ICAgcmV0dXJuIGludChiaXRzLCAyKQ0KPj4gKyAgICAgICAgZXhjZXB0IFZhbHVlRXJyb3I6DQo+
PiArICAgICAgICAgICAgcmV0dXJuIE5vbmUNCj4+ICsNCj4+ICsgICAgIyB1bnF1b3RlZCwgdHJ5
IGRlY2ltYWwNCj4+ICsgICAgdHJ5Og0KPj4gKyAgICAgICAgcmV0dXJuIGludChyYXdfc3RyLCAw
KQ0KPj4gKyAgICBleGNlcHQgVmFsdWVFcnJvcjoNCj4+ICsgICAgICAgIHJldHVybiBOb25lDQo+
PiANCj4+IGRlZiBleHRyYWN0X2ZpZWxkX2VudW1zKGZpZWxkKToNCj4+ICAgICBlbnVtcyA9IFtd
DQo+PiBAQCAtMTI0LDMyICsxNDcsMjMgQEAgZGVmIGV4dHJhY3RfZmllbGRfZW51bXMoZmllbGQp
Og0KPj4gICAgIGlmIG5vdCBpc2luc3RhbmNlKHZhbF9lbnRyaWVzLCBsaXN0KToNCj4+ICAgICAg
ICAgcmV0dXJuIGVudW1zDQo+PiANCj4+ICsgICAgIyBBIFZhbHVlcy5WYWx1ZVJhbmdlIGZpZWxk
IHNwZWNpZmllcyBzdGFydCBhbmQgZW5kIHZhbHVlIGZvciBhIHJhbmdlLg0KPj4gKyAgICAjIERv
bid0IGVudW1lcmF0ZSBhbnl0aGluZyBmb3IgdGhlbS4NCj4+ICsgICAgZm9yIHZhbF9lbnRyeSBp
biB2YWxfZW50cmllczoNCj4+ICsgICAgICAgIGlmIGlzaW5zdGFuY2UodmFsX2VudHJ5LCBkaWN0
KSBhbmQgXA0KPj4gKyAgICAgICAgICAgdmFsX2VudHJ5LmdldCgiX3R5cGUiKSA9PSAiVmFsdWVz
LlZhbHVlUmFuZ2UiOg0KPj4gKyAgICAgICAgICAgICAgIHJldHVybiBbXQ0KPj4gKw0KPj4gICAg
IGZvciB2YWxfZW50cnkgaW4gdmFsX2VudHJpZXM6DQo+PiAgICAgICAgIGlmIG5vdCBpc2luc3Rh
bmNlKHZhbF9lbnRyeSwgZGljdCk6DQo+PiAgICAgICAgICAgICBjb250aW51ZQ0KPj4gLSAgICAg
ICAgICAgIA0KPj4gKw0KPj4gICAgICAgICBpZiB2YWxfZW50cnkuZ2V0KCJfdHlwZSIpID09ICJW
YWx1ZXMuVmFsdWUiOg0KPj4gLSAgICAgICAgICAgIHJhd192YWwgPSB2YWxfZW50cnkuZ2V0KCJ2
YWx1ZSIpDQo+PiAtICAgICAgICAgICAgaWYgcmF3X3ZhbCBpcyBOb25lOg0KPj4gKyAgICAgICAg
ICAgIGludF92YWwgPSBwYXJzZV92YWx1ZV9pbnQodmFsX2VudHJ5LmdldCgidmFsdWUiKSkNCj4+
ICsgICAgICAgICAgICBpZiBpbnRfdmFsIGlzIE5vbmU6DQo+PiAgICAgICAgICAgICAgICAgY29u
dGludWUNCj4+IC0gICAgICAgICAgICAgICAgDQo+PiAtICAgICAgICAgICAgIyBzb21lIG9mIHRo
ZSB2YWx1ZXMgaGF2ZSAnIGxpa2UgIicwMTAwJyINCj4+IC0gICAgICAgICAgICByYXdfdmFsX3N0
ciA9IHN0cihyYXdfdmFsKS5zdHJpcCgpLnJlcGxhY2UoIiciLCAiIikNCj4+IC0gICAgICAgICAg
ICANCj4+IC0gICAgICAgICAgICB0cnk6DQo+PiAtICAgICAgICAgICAgICAgICMgY29udmVydCBp
bnRvIGJpbiANCj4+IC0gICAgICAgICAgICAgICAgaW50X3ZhbCA9IGludChyYXdfdmFsX3N0ciwg
MikNCj4+IC0gICAgICAgICAgICBleGNlcHQgVmFsdWVFcnJvcjoNCj4+IC0gICAgICAgICAgICAg
ICAgdHJ5Og0KPj4gLSAgICAgICAgICAgICAgICAgICAgIyBGYWxsYmFjayB0byBkZWMgaWYgbm90
IGJpbg0KPj4gLSAgICAgICAgICAgICAgICAgICAgaW50X3ZhbCA9IGludChyYXdfdmFsX3N0ciwg
MCkNCj4+IC0gICAgICAgICAgICAgICAgZXhjZXB0IFZhbHVlRXJyb3I6DQo+PiAtICAgICAgICAg
ICAgICAgICAgICBjb250aW51ZQ0KPj4gLSAgICAgICAgICAgIA0KPj4gLSAgICAgICAgICAgIGVu
dW1zLmFwcGVuZCh7DQo+PiAtICAgICAgICAgICAgICAgICd2YWx1ZSc6IGludF92YWwNCj4+IC0g
ICAgICAgICAgICB9KQ0KPj4gLSAgICAgICAgICAgIA0KPj4gKyAgICAgICAgICAgIGVudW1zLmFw
cGVuZCh7J3ZhbHVlJzogaW50X3ZhbH0pDQo+PiArDQo+PiAgICAgcmV0dXJuIGVudW1zDQo+PiAN
Cj4+IGRlZiBnZW5lcmF0ZV9zeXNyZWdfcHJvcGVydGllc19mcm9tX3JlZ2lzdGVyc19qc29uKGlk
X3JlZ19uYW1lcywgcmF3X2pzb25fcGF0aCk6DQo+PiBAQCAtMjEwLDcgKzIyNCw3IEBAIGRlZiBn
ZW5lcmF0ZV9zeXNyZWdfcHJvcGVydGllc19mcm9tX3JlZ2lzdGVyc19qc29uKGlkX3JlZ19uYW1l
cywgcmF3X2pzb25fcGF0aCk6DQo+PiAgICAgICAgICAgICAgICAgICAgICAgIG1zYiA+IGN1cnJl
bnRfZmllbGRzZXRfZmllbGRzW3VuaXF1ZV9rZXldWydtc2InXToNCj4+ICAgICAgICAgICAgICAg
ICAgICAgICAgIGVudW1zID0gZXh0cmFjdF9maWVsZF9lbnVtcyh2YWwpDQo+PiAgICAgICAgICAg
ICAgICAgICAgICAgICBjdXJyZW50X2ZpZWxkc2V0X2ZpZWxkc1t1bmlxdWVfa2V5XSA9IHsNCj4+
IC0gICAgICAgICAgICAgICAgICAgICAgICAgICAgJ3Jhd19uYW1lJzogbmFtZSwNCj4+ICsgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgJ3Jhd19uYW1lJzogdW5pcXVlX2tleSwNCj4+ICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAnbHNiJzogbHNiLA0KPj4gICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICdtc2InOiBtc2IsDQo+PiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgJ3dp
ZHRoJzogd2lkdGgsDQo+PiBAQCAtMjM4LDYgKzI1MiwxNSBAQCBkZWYgZ2VuZXJhdGVfc3lzcmVn
X3Byb3BlcnRpZXNfZnJvbV9yZWdpc3RlcnNfanNvbihpZF9yZWdfbmFtZXMsIHJhd19qc29uX3Bh
dGgpOg0KPj4gICAgICAgICAjIFNvcnQgZGVjcmVhc2luZyBsc2JzDQo+PiAgICAgICAgIHNvcnRl
ZF9maWVsZHMgPSBzb3J0ZWQodW5pcXVlX2ZpZWxkcy5pdGVtcygpLA0KPj4gICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgIGtleT1sYW1iZGEgeDogeFsxXVsnbHNiJ10sIHJldmVyc2U9VHJ1
ZSkNCj4+ICsgICAgICAgIGlmIGxlbihzb3J0ZWRfZmllbGRzKSA9PSAwOg0KPj4gKyAgICAgICAg
ICAgICMgY2FzZXMgbGlrZSBSRVZJRFJfRUwxIGFuZCBBSURSX0VMMS4NCj4+ICsgICAgICAgICAg
ICAjIGF1Z21lbnQgYSBkdW1teSBmaWVsZHMgVkFMLg0KPj4gKyAgICAgICAgICAgIHNvcnRlZF9m
aWVsZHMuYXBwZW5kKCgnVkFMJywgew0KPj4gKyAgICAgICAgICAgICAgICAnbHNiJzogMCwNCj4+
ICsgICAgICAgICAgICAgICAgJ21zYic6IDYzLA0KPj4gKyAgICAgICAgICAgICAgICAnd2lkdGgn
OiA2NCwNCj4+ICsgICAgICAgICAgICAgICAgJ2VudW1zJzogW10NCj4+ICsgICAgICAgICAgICB9
KSkNCj4+IA0KPj4gICAgICAgICBmb3IgdW5pcXVlX2tleSwgYml0cyBpbiBzb3J0ZWRfZmllbGRz
Og0KPj4gICAgICAgICAgICAgZW51bXNfbGlzdCA9IGJpdHMuZ2V0KCdlbnVtcycsIFtdKQ0KPiAN
Cg0K
