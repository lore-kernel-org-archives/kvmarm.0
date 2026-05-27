Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33ECF42B72C
	for <kvmarm@lists.linux.dev>; Wed, 27 May 2026 14:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779893872; cv=fail; b=QhR/dBM1OPgZAZQWJh0kk1dgmRGUFybsDEi27bg8+R/xgZuxLpAgoi09Rum8eBfaShWbq7Tnsrtyl/Nkz6gpY44xGeklwi/nOLPCDmwIe6H9d2lc/akevKPW8D6MrL8TeNTjUCCEmLM4QIFIp30i5bAWl+VZnX1CnW+3Mm6pY+Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779893872; c=relaxed/simple;
	bh=uGQuoVcdwV+rFyBxD5FSdOwlXV/TEam7KQqPs4DpgSs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=pJkCOwhP9DfFtMYpxFqjv3zKg7GBIXceSAZXV1q3QiYj4HWGBgpcwDEG1t42QwScD/JGl+LJGmc9M7OBc7seIXMHlbZC+1cIuyhMxL3nPCgB7K+nvLzpXQJIh2u1IDNTJDp+URk9ncV5lPVAFwlrod2/gdBoVhzymiYpFZ9Mngk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=b3o4IVnm; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=t5Hpkkky; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="b3o4IVnm";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="t5Hpkkky"
Received: from pps.filterd (m0127841.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64RCs5D32641608;
	Wed, 27 May 2026 07:52:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=uGQuoVcdwV+rFyBxD5FSdOwlXV/TEam7KQqPs4Dpg
	Ss=; b=b3o4IVnm5kBM2j6Zu3lsv+2CKQ7FSzdyyJsUBjwzUaFJV++ueYb5+2UlI
	wrZSJSGnhyyn8RO2fxmJrf4Dzwl7ABXoAKmLJsxE8vn0vaVGHxE9xCyo8pHeUqaF
	cy5W+00XPS0JN8YyQEpktE/SfW+Jwx40UiN1PIJA3ha2D2pdAMzdfweMLloOSdQQ
	sTKoHvUiln2XuUibsG3qu8ueyOgxl4FbrR5atR2nFSphJLRYEu9Mty+76CkwxT3a
	nduyYLHPRSN5Uhow1EZYymgyomCwX7dKvr4F3OgpvNKk3lrfJVbP9wPamLhfaO6J
	I39gxClkXu8zK3fLTBLYL8aGU/s8w==
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11020115.outbound.protection.outlook.com [52.101.201.115])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4edkqt20k8-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 27 May 2026 07:52:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=o5ZxDmhppUES35A3k1qmlIsXFT2C3MyOnNVjbr+1uNmPH/uZJlBvQjndEmeUv9X3M1T48NMgm5k55mMusmrx1GYxtt8SZ2cnAF8ZxlE4TvsrEGByC7CUAP54dUyY4YFdvJaZDwALsjUNM+q/TZlo5FugzMHHK3VE1NR9VR0TPtMRTYOCRHkw3SpCiFJK1B9LgkiRWo9+OFnBZ8SYBgnuPC1Yholn1THuTu1SfLbcuixNPm8+IJODJtxU6XuX+8E3Tn7+iXBBqL0ybwvhs8Cm3Cx3nNOJZ6ayNlooPPmSYPZl26Lq+SnYgbaivGXiiJ4tM6snIAlgUpVvvB7oUTjhHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uGQuoVcdwV+rFyBxD5FSdOwlXV/TEam7KQqPs4DpgSs=;
 b=AshJyTBgHAMACkCpUo86WvJrnWO708wZXJBKjEr1LhJU07Ty1r6gHSdnRL+Xg3r3caNtDbkzJ41qx7yEXxr6nqn2qraG/yhCRYeTCKGRnYHzuo8ilXBHxrT4ARL11AD0Wsk8xv3038i2CUSOrbE3laOvGw0YNlKEUt0bjFNlxqZlHcAOccArDtjvXA0eIoSTFcrJiyzlWaRwWyctukwYTEsHVHPU18IZNPhA4eBfqUnMjQVSh3EDKsCiscRRHqdNgUE3MoL1x9WPS99fCzbdArPQbyGESu+OYDu+kmurDi/0r+5cg7/6hhVPZEO2RMsUqMGsV/GGkM/m70ZF3+hUqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uGQuoVcdwV+rFyBxD5FSdOwlXV/TEam7KQqPs4DpgSs=;
 b=t5Hpkkky4vVwziAl2eLk/k5ubZnTbiJjt5VwYz+7tOYRy0zPgUBWxpDSFKqtI6cGFOtt5trqdAmzJAQtf72Y/3ARgAyTSqhyktq1xU8avCJsWICRqH+GiyWaIOJzz3ZVTwZgWg7vtKOLGTWZxh9gkTV5R+tQfgD8LdmmkUtkdeWiLeCRYxeFSbFVPH7tAVeXkfD/bkqI51Er6ZD/WAhbKqlVNFEGFYfsMxaulSL273pIBS5zCdd00BunwxqzXQ3dDbZv20GDaGF7mj6lUu+jue47UJLiDoEzigJ/qSQAIY4fpowoBXi6et6ApEg7UsigeF91aUYmwz0GhFn1N7n/dw==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by IA1PR02MB10983.namprd02.prod.outlook.com (2603:10b6:208:5b2::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.13; Wed, 27 May
 2026 14:52:03 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%6]) with mapi id 15.21.0071.011; Wed, 27 May 2026
 14:52:03 +0000
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
        "philmd@linaro.org" <philmd@linaro.org>,
        "maz@kernel.org" <maz@kernel.org>,
        "oliver.upton@linux.dev"
	<oliver.upton@linux.dev>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "armbru@redhat.com" <armbru@redhat.com>,
        "berrange@redhat.com"
	<berrange@redhat.com>,
        "abologna@redhat.com" <abologna@redhat.com>,
        "jdenemar@redhat.com" <jdenemar@redhat.com>
Subject: Re: [PATCH v5 08/18] target/arm/cpu_idregs: generate tables for Arm64
 ID registers and fields
Thread-Topic: [PATCH v5 08/18] target/arm/cpu_idregs: generate tables for
 Arm64 ID registers and fields
Thread-Index: AQHc55OjqLXzPfvzck68ml4xn83SfbYiAY6A
Date: Wed, 27 May 2026 14:52:03 +0000
Message-ID: <E6706A9A-B0E0-4A1B-B7E9-8A0BF73A1170@nutanix.com>
References: <20260519132905.145643-1-eric.auger@redhat.com>
 <20260519132905.145643-9-eric.auger@redhat.com>
In-Reply-To: <20260519132905.145643-9-eric.auger@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA2PR02MB7564:EE_|IA1PR02MB10983:EE_
x-ms-office365-filtering-correlation-id: 244ee008-0dd9-410e-c48c-08debbff83ec
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|376014|1800799024|366016|38070700021|6133799003|56012099006|4143699003|18002099003|22082099003;
x-microsoft-antispam-message-info:
 6PxSh91JMbwCBtJKdU6ihrwyr0JfnZDb4F6GKcUajrJ5oWWtUQXE690nFya2JLa7RiCVS9kvAdCyCgZmXfxDX7l8B6UPsBThl8RI8oDssWjQrc/akHm5IyeuWuh/WhIRFeRInZasiRMkiU7Szs3ycV4wcPyiYO828WKBIoILXFGrNvdwtGqMOS/AwFnmCVW9uRY8F4sLgzY6pvADm0Kn5GzsH043jThektydoOfjnN/g5bX2amQ+2SPvFy8yG5PkfVhkCNFi2O5OIiokPJW63YLLbDwhBmyFMlQxl9+gHkqJQdS+iQRza+tKHNyfCu/tqeHidOuLjVtfwHWp/D0QgoL3FFz72TORkX+zsXXUU1Pr1PUCGXTcO6gLFeMFWwjE+wcsp/VzjaSpbwxNeng72Lnbm+pdVABPF9CFMpbyNi84iWc+ki3or4GKUCc6F6wvqlgxphX54UFQjN062liuQgWMCmNKeEsgVwQkztrVSldAiHf1i5tAhZomxs8f7Pl5XeuqK9cxuSCpOnkQtVc6oGH6OkqWO6GTW92lqEARkk6wo9zBwMp2ymNj6lIapcOlQJbbjCoVCCFy7qoGQ9jS36VOGnNO9/CruMiiE1rDNiufvE6F5+UlQafamqdrxa3Ud8DdMqn+xlG6CjXsmsNaKFaW2IFM/WdgWNadkKkS79PzcWIxMscjjgdu9BeFmm0kL/QBr8yeRNibqmoJmGPgtR3P7kJR83nUUHCf4k6jmrDf1+rkk2tNLh4nzwzHFkaO
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(38070700021)(6133799003)(56012099006)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?T0ZoQWxRSlNLQjBYZzN5SHlsNzJ3U1JsblNPTTZTR0t2OUozUkVRVFRDT09a?=
 =?utf-8?B?NVFjYlU0YjFoZHdtRFgrTWhiU2krSTRmN2dOSG1NaFBCZkR0T3o5bEZjRGc1?=
 =?utf-8?B?WldOZzZBb3JoQ2NNYitrbkVWTzhmY0FiQ0N6dE95dUE4blBzcW1ZblBrRGJM?=
 =?utf-8?B?L3RaL2N4NXlMZ050THI0TG1PL2VINTNFZjRSZk1QMHZ5SkVka3NPQU9HbG1M?=
 =?utf-8?B?VHJZcTJYWmRCZWdOaU50NW1wSnFRemkxaS9Vcm85eTF1aXVHSGNyV0hOTzVR?=
 =?utf-8?B?UTU3RzZnbGlud01TbTUxeHBwQ2xsZTZTd20yTHV5dU1TclhQSFVVS3E5c24y?=
 =?utf-8?B?NkdJcEJiS2YzRUhMeXY4THc4TkRKMFJSVmhkeENEaXhtcVE2V0Q2M21uV3Jv?=
 =?utf-8?B?RVl0SHZ1U3JmdEQ2a3RLNjlKY1VDN3dla2VTRjV2czZ5UE5jdlhJa2FOL3M1?=
 =?utf-8?B?RE9FS1Rqa3IwMnl0QVIvS0xkanR0aUVQR2tZWlZUVXRLd0t1dDhHcjJjbkJi?=
 =?utf-8?B?OVIweW93SUZzNkpRRy9Nd1daMUQ3V2xhamkvNkoyNnBUeXBUdkkxMExyejBk?=
 =?utf-8?B?TThNdTJ5elFCTWRzb003SlI1czlQM203SEVYMVB6SDVmL2FGd0hWZWdBNHZn?=
 =?utf-8?B?L2M5eDhkZkEyeENIWE1UWnU3aVhWR0x4SXRvZ1cvRGhSRS9WaXlza0J3SGFi?=
 =?utf-8?B?UjRxZWoxVDM5RjFOMTJxZkd1cm43ZFgybXhaSVZyellRcmZxUUhCeG9DSmRT?=
 =?utf-8?B?ZTVxUTRnL1RlaFpIT0dnbFRubmdXNmtFWnFVYTRvbFNWeTlpRnY5dlJHMFUy?=
 =?utf-8?B?TXcxbGVWdXBYb0pRU2FPaU9UNzVBK2hmZ0FlU0JHYWxiUXlTMkdsdEhxVUhI?=
 =?utf-8?B?cTRZcWxuekxVbmpzOEt5NjZEYnNlV2FSZDRpQVNlZzZFbkttbmt3MlVwNDN3?=
 =?utf-8?B?K1ZLNnl1aGZzMWw0YjhoOER6VVZZbWFvMXZSc1RnZHlzNUUwT0dCekVVMjJI?=
 =?utf-8?B?M2tVODlOWHNDNXdSZlJlRjRkYXZwQVYzdGtPSm9lb3REQ05GQVJudy80L215?=
 =?utf-8?B?a3hsbTBUZDZHdDk2c3hMS29oNTFXdXZKa0c5MzRmWUpQdEYyKzRkWHB1cWN6?=
 =?utf-8?B?TElrM29pdlVpdjlDNnMvdldIUHBIVnp3eThSNjZJalFXaEdRdkpLZWQ3SHhB?=
 =?utf-8?B?Q1J2ZzAxcnB3T0wxcjN6UVpJRUdNc3dzT0IxM1A2M0c1eVZNd3RPcFFBSGlz?=
 =?utf-8?B?VThwU2p2dUZkR2lhbXZ0blU4WjdMZjUvVW0ydzNtek1SWE9uTE8xQjlJakIx?=
 =?utf-8?B?ZnBiWlVnZ0ZGUFpEUy9UVngyRzd1cElHZHN5RTBGMXFjb1cyZ0NLL09ya3ov?=
 =?utf-8?B?cnZsY0VXQnByaHErN0x4Tm9ZZkZMUUFubFFNSVZjeHZWbDg0TFF1OExJdG5L?=
 =?utf-8?B?eDR5YkFFZWFEZWtaSEUvRmllNytDMEhEN2lwSjNKS3RMSGdNbGpxQ1o2endm?=
 =?utf-8?B?dmNENUxvT2lBN3lKSmtEaWYyNVFMYUt3V3ZNY0J3aFBnaWk5WnBZcFpVV1Bs?=
 =?utf-8?B?V3lZY3diY2VSdUdoclpqakwySjJCRkdWNHllZEt4cytPU3lDL2kzNEkwWGp1?=
 =?utf-8?B?L2wrM3AwejNDbmI3WmJibmlFZmZkMWNzcW9Cb1E5YWRYSDRZL2NCWHZTZmtn?=
 =?utf-8?B?T2Q5ZmE3Y3EzNytXTjA3MklMTnhjR0hBcUFObld5bEd3Y2N2UDZPOTRVM0lQ?=
 =?utf-8?B?QTRvdnJKYVpLK2RqT05jVWRWWkFjUUYweTlWUHdrRDcxMi83ejg5Q1dHaGNt?=
 =?utf-8?B?YnRoVlNONTZ4R1BmMmlQNlVlVjYyYU1qcGt4b05Ca0V5ODhHT0dOUzRiOEgw?=
 =?utf-8?B?cS9lSG5VUXp2N1U3VjE0R0FPWXFDNldTRTVHemZEU2RBMHBIUlVwVXhjU2Rm?=
 =?utf-8?B?UnBBMEJpQUc5V0hDdW5wbUtFbEZKOWtIaHJqNkM2aElyMVI4TzdVa1U5YjNu?=
 =?utf-8?B?aXRDakpvc21LREQ3REllU0F5eDVoWWJ3L2UrSHFkd0JiZHJDVkZSTnkrSnd3?=
 =?utf-8?B?ZFN5U1ZWcXNYaC9qa0czWlJKVllUVDVnQlcxTGFIY2VSVzVUbUc0ZXF4UHda?=
 =?utf-8?B?NEdyWmFGVklTU0UxaktCdlIyRGdzSVNZZHVKRUZrMGRoR1R2b1MxOE44elFN?=
 =?utf-8?B?bkdET1dnU0lzVDBEK2VMSlZzNWhXYWlCR1N3OHhESGE1YW1jUEVIME9zb1Fz?=
 =?utf-8?B?cmN5R0gxTE5JZkRJYkdaTllWQmhCZ3lrZVhmcnRqQlR3SHRXTEliMGNpYlJs?=
 =?utf-8?B?a1pZNW5IK2VpZEVoS3lmKzByNjl4VGZlQ1RTZlAzZ2Q3RnE5VEZISlE5M01O?=
 =?utf-8?Q?9+xhtkw8TsrgwNxw=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7D5F70AE55C4E34F8FBA855E232025C7@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	SHM8BUvxHiQU6LVAVA0fo69+MAbfl7Ktctv7FWBQK3TmHbrTCnD5DyyPDhAtpJOflKfKwS2mU+4of8PNHy7bf+qbjn+O7M/RPi0wd1kWrRdEqPiYLJF3IObcCaLB3fsMy7Yi8pRFM4hq4kT+OYjxNJTBRJNJrjF6H/O/p6XzBieUEwULMUHIjlkBSo0Axp4lxFUSzPE8YoRdJX8DbHl+FNBcnMmtGMcC0K0Tfl+MlOe0oNHFjjZzwD+zoZJ5Bi/rG59M9ifi4aVsJSDXf8umvIl3y2OsnqtfzQJ/eVIFlHfXWZ3qvhzDcP0I7KJdqqTRGUphlzejllyz9U2SaAZQDg==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 244ee008-0dd9-410e-c48c-08debbff83ec
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 May 2026 14:52:03.7154
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qYvGc9m8GsSNVHkAYadM+ZtUAGpesGmpWiDrTagBO1ji/aqbe9AMcK0684VDMXcYzc5p6cfDXp5gqxZxMHYEdrTWAgGRALXHlP7MU3czUcg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR02MB10983
X-Authority-Analysis: v=2.4 cv=Z8Tc2nRA c=1 sm=1 tr=0 ts=6a170516 cx=c_pps
 a=i9AYdY+muJfbJY5DtBkDBA==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=NGcC8JguVDcA:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VofLwUrZ8Iiv6rRUPXIb:22 a=jxMXjlTPpCISP5mWtjnE:22 a=20KFwNOVAAAA:8
 a=64Cc0HZtAAAA:8 a=gwD-gB1NCmvgJ67ZuKwA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: YqKvfac2ozMUq_eUZY9fR22KCjixn7A0
X-Proofpoint-ORIG-GUID: YqKvfac2ozMUq_eUZY9fR22KCjixn7A0
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTI3MDE0NyBTYWx0ZWRfX8PShNRreKEuN
 7gp2CSSt9psjZRIWKImtkrmqMincKW7+m7/IVqzsJfwIsWORtylu6QCeau1JIJiBmNo5xAT+Bod
 ISTiNX3PUqaCg9bTJpyu6G14629IyL29OhDzVmMQUQd8vXxhGAxlU4c/NpaeZrgTSHLX2SH9egu
 CfkpOEkLjMbb4KdC0yY6kuERfKe0cGgZYnwpcCKbcuPYFZ5r25HOO28mkgXg/24QsP718JVNr0u
 ubgrjaZfs7Eylgv3D6dzss2X/1iLqqx5nJao2IvNh8abDH/vQX63ME/fZi5FU2JqijPa2ZHIOQk
 tIAn6Zc4I+92oh7+pbuNIoxX4eNpiJUNECCJAylXsF/XHl/UnQGYIV4nhGc+yQcotcBRRPpwrLD
 ZD+kuyWK23REorOOJaRXMU3xqSCPAJpAtYIUan2+TQ5k4PkzAFuonvBq3ItyeOa45CjG1OHerKr
 K2fyK+FGTl+qy2tJh+A==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-05-27_02,2026-05-26_03,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gMTkgTWF5IDIwMjYsIGF0IDY6NTfigK9QTSwgRXJpYyBBdWdlciA8ZXJpYy5hdWdl
ckByZWRoYXQuY29tPiB3cm90ZToNCj4gDQo+ICEtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tfA0KPiAgQ0FVVElPTjogRXh0
ZXJuYWwgRW1haWwNCj4gDQo+IHwtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tIQ0KPiANCj4gRnJvbTogU2hhanUgQWJyYWhh
bSA8c2hhanUuYWJyYWhhbUBudXRhbml4LmNvbT4NCj4gDQo+IEluY2x1ZGUgY3B1LWlkcmVncy5o
LmluYyBtdWx0aXBsZSB0aW1lcyB3aXRoIGRpZmZlcmVudCBkZWZpbml0aW9ucyBmb3IgdGhlDQo+
IFgtbWFjcm9zLiBUaGlzIHdpbGwgZ2VuZXJhdGUgdGFibGVzIGZvciBhbGwgQXJtNjQgSUQgcmVn
aXN0ZXJzIGFuZCB0aGVpcg0KPiBmaWVsZHMuIEFkZGl0aW9uYWxseSwgaW5pdGlhbGl6ZSB0aGUg
dGFibGVzIHdpdGggYWxsIGFyY2hpdGVjdHVyYWxseSBkZWZpbmVkDQo+IHZhbHVlcy4gVGhlc2Ug
dGFibGVzIHdpbGwgYmUgY29uc3VtZWQgYnkgdGhlIHByb3BlcnR5IGxheWVyIGluIGZ1dHVyZQ0K
PiBwYXRjaGVzLg0KPiANCj4gQ28tYXV0aG9yZWQtYnk6IEtodXNoaXQgU2hhaCA8a2h1c2hpdC5z
aGFoQG51dGFuaXguY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBTaGFqdSBBYnJhaGFtIDxzaGFqdS5h
YnJhaGFtQG51dGFuaXguY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBFcmljIEF1Z2VyIDxlcmljLmF1
Z2VyQHJlZGhhdC5jb20+DQo+IC0tLQ0KPiB0YXJnZXQvYXJtL2NwdS1pZHJlZ3MuYyB8IDUwICsr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrDQo+IHRhcmdldC9hcm0vbWVz
b24uYnVpbGQgIHwgIDEgKw0KPiAyIGZpbGVzIGNoYW5nZWQsIDUxIGluc2VydGlvbnMoKykNCj4g
Y3JlYXRlIG1vZGUgMTAwNjQ0IHRhcmdldC9hcm0vY3B1LWlkcmVncy5jDQo+IA0KPiBkaWZmIC0t
Z2l0IGEvdGFyZ2V0L2FybS9jcHUtaWRyZWdzLmMgYi90YXJnZXQvYXJtL2NwdS1pZHJlZ3MuYw0K
PiBuZXcgZmlsZSBtb2RlIDEwMDY0NA0KPiBpbmRleCAwMDAwMDAwMDAwLi5mNzliMjI2ODBjDQo+
IC0tLSAvZGV2L251bGwNCj4gKysrIGIvdGFyZ2V0L2FybS9jcHUtaWRyZWdzLmMNCj4gQEAgLTAs
MCArMSw1MCBAQA0KPiArLyoNCj4gKyAqICAgQVJNIElEIHJlZ2lzdGVyIGZpZWxkIHRhYmxlLg0K
PiArICoNCj4gKyAqICAgQnVpbGRzIHRoZSBwZXItaWQtcmVnaXN0ZXIgZmllbGQgZGVzY3JpcHRv
ciBhcnJheXMgYW5kIHRoZSBnbG9iYWwNCj4gKyAqICAgYXJtX2lkcmVnc1tdIHRhYmxlLg0KPiAr
ICoNCj4gKyAqICBTUERYLUxpY2Vuc2UtSWRlbnRpZmllcjogR1BMLTIuMC1vci1sYXRlcg0KPiAr
ICovDQo+ICsjaW5jbHVkZSAicWVtdS9vc2RlcC5oIg0KPiArI2luY2x1ZGUgInFlbXUvZXJyb3It
cmVwb3J0LmgiDQo+ICsjaW5jbHVkZSAicWFwaS9lcnJvci5oIg0KPiArI2luY2x1ZGUgImNwdS5o
Ig0KPiArI2luY2x1ZGUgImNwdS1pZHJlZ3MuaCINCj4gKw0KPiArI2RlZmluZSBJRFJFR19TVEFS
VChyZWcpIFwNCj4gKyAgICBzdGF0aWMgQVJNNjRTeXNSZWdGaWVsZCByZWcjI19maWVsZHNbXSA9
IHsNCj4gKw0KPiArI2RlZmluZSBJRFJFR19FTkQocmVnKSBcDQo+ICsgICAgfTsNCj4gKw0KPiAr
I2RlZmluZSBJRFJFR19GSUVMRChyZWcsIGZpZWxkLCBfc2hpZnQsIF9sZW5ndGgpIFwNCj4gKyAg
ICB7IFwNCj4gKyAgICAgICAgLm5hbWUgPSAjZmllbGQsIFwNCj4gKyAgICAgICAgLmluZGV4ID0g
cmVnIyNfSURYLCBcDQo+ICsgICAgICAgIC5zaGlmdCA9IChfc2hpZnQpLCBcDQo+ICsgICAgICAg
IC5sZW5ndGggPSAoX2xlbmd0aCksIFwNCj4gKyAgICB9LA0KPiArI2luY2x1ZGUgImNwdS1pZHJl
Z3MuaC5pbmMiDQo+ICsjdW5kZWYgSURSRUdfU1RBUlQNCj4gKyN1bmRlZiBJRFJFR19FTkQNCj4g
KyN1bmRlZiBJRFJFR19GSUVMRA0KPiArDQo+ICsvKiBnZW5lcmF0ZSBhbiBhcnJheSBvZiB0b3Ag
bGV2ZWwgSUQgcmVnaXN0ZXJzICovDQo+ICsjZGVmaW5lIElEUkVHX0VORChyZWcpDQo+ICsjZGVm
aW5lIElEUkVHX0ZJRUxEKHJlZywgZmllbGQsIHNoaWZ0LCBsZW5ndGgpDQo+ICsNCj4gKyNkZWZp
bmUgSURSRUdfU1RBUlQocmVnKSBcDQo+ICsgICAgW3JlZyMjX0lEWF0gPSB7IFwNCj4gKyAgICAg
ICAgLm5hbWUgPSAjcmVnLCBcDQo+ICsgICAgICAgIC5pbmRleCA9IHJlZyMjX0lEWCwgXA0KPiAr
ICAgICAgICAuZmllbGRzID0gcmVnIyNfZmllbGRzLCBcDQo+ICsgICAgICAgIC5maWVsZHNfY291
bnQgPSBBUlJBWV9TSVpFKHJlZyMjX2ZpZWxkcyksIFwNCj4gKyAgICB9LA0KPiArDQo+ICtBUk02
NFN5c1JlZyBhcm02NF9pZF9yZWdzW05VTV9JRF9JRFhdID0gew0KPiArI2luY2x1ZGUgImNwdS1p
ZHJlZ3MuaC5pbmMiDQo+ICt9Ow0KPiArI3VuZGVmIElEUkVHX1NUQVJUDQo+ICsjdW5kZWYgSURS
RUdfRU5EDQo+ICsjdW5kZWYgSURSRUdfRklFTEQNCj4gZGlmZiAtLWdpdCBhL3RhcmdldC9hcm0v
bWVzb24uYnVpbGQgYi90YXJnZXQvYXJtL21lc29uLmJ1aWxkDQo+IGluZGV4IDQ3MjNmOWYxNzAu
LjY0ZDFlYzYzYWIgMTAwNjQ0DQo+IC0tLSBhL3RhcmdldC9hcm0vbWVzb24uYnVpbGQNCj4gKysr
IGIvdGFyZ2V0L2FybS9tZXNvbi5idWlsZA0KPiBAQCAtMTksNiArMTksNyBAQCBhcm1fY29tbW9u
X3NzLmFkZChmaWxlcygNCj4gDQo+IGFybV9jb21tb25fc3lzdGVtX3NzLmFkZChmaWxlcygNCj4g
ICAnYXJtLXFtcC1jbWRzLmMnLA0KPiArICAnY3B1LWlkcmVncy5jJywNCj4gKSkNCj4gYXJtX3N5
c3RlbV9zcy5hZGQod2hlbjogJ0NPTkZJR19LVk0nLCBpZl90cnVlOiBmaWxlcygnaHlwX2dkYnN0
dWIuYycsICdrdm0uYycpKQ0KPiBhcm1fc3lzdGVtX3NzLmFkZCh3aGVuOiAnQ09ORklHX0hWRics
IGlmX3RydWU6IGZpbGVzKCdoeXBfZ2Ric3R1Yi5jJykpDQo+IC0tIA0KPiAyLjUzLjANCj4gDQoN
CldlIGNhbiBhbHNvIHN0b3JlIHdyaXRhYmxlX21hc2tzIGhlcmUuIHdyaXRhYmxlX21hc2sgZXhw
b3NlZCBieSBLVk0gaXMNCnN0YXRpYy4gSXQgZG9lcyBub3QgY2hhbmdlIGluIGFueSBjb25maWd1
cmF0aW9uIGhlbmNlIGNhbiBiZSBmZXRjaGVkIG9uY2UgDQpkdXJpbmcgc2NyYXRjaCB2Q1BVIGNy
ZWF0aW9uDQoNCldhcm0gUmVnYXJkcywNCktodXNoaXQ=
