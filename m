Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44A3E3CAE66
	for <kvmarm@lists.linux.dev>; Mon, 28 Sep 2026 12:53:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790600021; cv=fail; b=dQfNQb1UisSYmMVcrAJOISWyOrIvUuT3WTRTzXim4/ZDweMyQJHnzsIIKrP6RVu0yj5O95QRuDbNDri9UizwhaKhT7JFRmQAPd1iMDq5fT7RAbXc55eZk7WeC303ffvsx4LF876ZAzUTiUoONo9DbVKU0BI/QJHFN4Fu77lh56c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790600021; c=relaxed/simple;
	bh=qdRcv89kslSMjJP1SIP6mqhmhM6thcUqJ3+RDARfUHo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=FNo2p+6xTPgY86iqER2UXYhOGbhAS5VOfVLgxx1I/msCTlpc44lhdN/pce61z7jwihzrRhypMXGho/q+eDw6iWEwyE/pmd96HL4Gu1VLEHNc1nceefugNLTky2bbMpI0xRp4iu2sMf+2II9CG9gE/kNd4VopBbac6qY7Miehifo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=q3u8Up8m; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=SVUX5d3H; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="q3u8Up8m";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="SVUX5d3H"
Received: from pps.filterd (m0127837.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68SBCxsQ1535018;
	Mon, 28 Sep 2026 05:53:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=qdRcv89kslSMjJP1SIP6mqhmhM6thcUqJ3+RDARfU
	Ho=; b=q3u8Up8mTOHv0MFu1nxhLVGZZAnUAhyk/R3wNV6iA0Yk12mwm0QLS1tvG
	eZDs+iuNrhw8v2yG8jzXKKlsJKftbewXX7ij26O0EPxRw17F9dN+Lw68zJRfMn0J
	wNk6stIxuO3aayVMAtTeHHlsru47VxDEQ/OIyuTBddPf5B+taaTgDvevcKWVH5pn
	OKIJr1pZknw6pF8JknvHNSe5dzNqg+N0OHBgP0UlLfSCX4VZm7Mo7fHLeN1DfwNv
	ut6S90KG6uImSvY/AD9PBzCv6iu2no6rAEyyZ2ppV6hGZP9dpZMh1L/iBfCarY1O
	FCgZEU4fLM/XF4+wiWuk+8YZL6RgQ==
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11020084.outbound.protection.outlook.com [52.101.201.84])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 4gx9y740hp-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 28 Sep 2026 05:53:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tvKtoUihz9IfBndAA/oOoNIZyrnqRq4Yg63vbli/yFMYcwTLTsAGSkd1V0uTPU2MGpy79QGdfKGf6exzTKFPu/+1Unn4SQ4F/rLw/g4XoVBKVyk16++tNCQcBl8iqWDs16q4k+ENTHuRNOWzBD7grzlbrn89xG5vyhti+xY8bBQ0XN1dxtYdGbri+wmjX6UaUqnuNX8IEiP9Aw4Zdnpw1n+TLDN9K3GkrnTrqb0TjDMH6zN4YyO8U14vJHYLO57v1sBRoCSoqAGKlliPjwcq3wGtpgsRVA/tAxpJTdfAi9Z8/XB8FgTyAPl1NbdFvx5O6l0G4qOjiDqQlyBj633wlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qdRcv89kslSMjJP1SIP6mqhmhM6thcUqJ3+RDARfUHo=;
 b=arW44k8/MTiNwX3jGlUq2cGeTOIf2ANGlVajFtVY9jhQNbLEdumP/5kAQci1wuHCsXT8KydA/Q3GONsCKb5+qatA8AvGp3jyAsWDky1FCYaBtVUZGUhyYIWyXAsJ4JaD3/FfdjKAdb0HJ5Qz6pj9a+CkFFkn5udo9Vz15l5Biaftwlq0xjeCh435wEpA/wUgocnm01RU+a2Y+yctcYuPzE7bIXC+WvnTzqhXi/JZPa6Uic6AsqxGFG268a+kvPqjSRdKS7HicsvjCNcDv0n/TitzInTG3gjJWcWyWLrSEuX7XIQsCoS75DDtPnJuQczxXdqLO0UzHehg35iHeOW5xQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qdRcv89kslSMjJP1SIP6mqhmhM6thcUqJ3+RDARfUHo=;
 b=SVUX5d3HnEDbAxxlBifQu/JYfPjmmZR2rcfikvWazcyjDnORboOZfWUd1715k1SBnZiG8JEixKMC4hsEKRiHljs77b0CPvOLh5Gd0u+9A1zXrV6WcZIzace/0jZek6PUHsRMnr+N6iZCdIpfL8HwzCXZHbY4D4+Cg/sgTCqd+0pF+GxswyeUcR48JT2EcchLvgztIEryrMsXgliTrfj0IBm54wThLjNp98SZligesWLgS0YaT9w+znd9m7gSAEpIBu93JGMNX5gZBTwtv2GfVYLwHGfvrAwzQa+mJUJ/dgTSYpygPAGoubw9en0uQfEKjawb/dqE4S1jY59L62v2SQ==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by PH0PR02MB7493.namprd02.prod.outlook.com (2603:10b6:510:1a::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.24; Mon, 28 Sep
 2026 12:53:23 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%5]) with mapi id 15.21.0451.022; Mon, 28 Sep 2026
 12:53:23 +0000
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
Subject: Re: [PATCH v9 17/26] target/arm/kvm: Add consistency checking for
 SYSREG props
Thread-Topic: [PATCH v9 17/26] target/arm/kvm: Add consistency checking for
 SYSREG props
Thread-Index: AQHdT0hYvXLQXk4wdk6P56p75GiQRw==
Date: Mon, 28 Sep 2026 12:53:23 +0000
Message-ID: <7C929003-175E-450D-885B-CAB243B89645@nutanix.com>
References: <20260916144721.751810-1-eric.auger@redhat.com>
 <20260916144721.751810-18-eric.auger@redhat.com>
In-Reply-To: <20260916144721.751810-18-eric.auger@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nutanix.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA2PR02MB7564:EE_|PH0PR02MB7493:EE_
x-ms-office365-filtering-correlation-id: 86113781-04aa-493d-ea36-08df1d5f7b25
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|23010399003|7416014|376014|1800799024|366016|10067099003|6133799003|56012099006|18002099003|22082099003|4143699003|38070700021;
x-microsoft-antispam-message-info:
 hwKgmjVlc4Idgug8cF6tGmCDW9beOu/tE+7Gv+YpWeHCTkZl3lQutl4Ap8Mg/flaUN4iLar/LANnG329usCn5txjqUOiEOmAlzmSCSHhfAlTHl8Vf/ZlvH9BpNP+wCk6q72uQyPf8HQB0dAp3BHExvyz70HF+iGjK2nZkjUp82uuFVhELR5KEks58gNX0oh7Fi38E6mymKUn+7v2EEt8BJpCWvtamMnraUC/Igr3cqLgUReb9SWUIOZlAc5aWO0ArRsOYi9A953m1vhoYnwYqMoEbtWSPXlwKZWthw4IqBr/mygnLBGtJStG1wJV2x1xoGuNfISmiLkyn1H0kApHgj9kNw3kEjcSRKiE5sWe/Cw1HOAKhV9xSSLn9ldj4w9eouYaVe455YPsXHbpln3zuIuxZHJ2wNFmXFe24JcFLj6mCm1opAUvZIHkciJK3EgzYWlMlAO7MrN9DCMOsnf3D1WjuwC5kdKemedubTsaEEiBa6MWL9rHnrwjdQhFWO3PHLC40lS8LsnBb4kqhiBVMFosWzgK6SADaCPILwrjLAbsIp85u7HQfTJ1bffkbYGlnWi37Vw+/VPMmZzp//j5tOoR8z5pQTGy+SX/WfBi/q3Rcp8r8KTuPF5gfhYx8SzjcQd7VeYO0H4ASqKm4cvaRknHjD1Cqc3Iod5hOX5I3u32k8tgnBq0EDSQabrB/G/XV26c1yH6Yao44CMT22TQ+NY/cqKeZio6VsyejYjbh9o=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(1800799024)(366016)(10067099003)(6133799003)(56012099006)(18002099003)(22082099003)(4143699003)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?T1IwOFA0d3lYODlzRkRJT21pRG13djBXcGw3enh6cW1BYXEyNkNZdDg4YUFh?=
 =?utf-8?B?aEgwSm80dStQb0hqZkIzdGNIRkNmaUhFNGZ3eGt5cjFsTFVmZDR6bUJLOXpQ?=
 =?utf-8?B?b1RpREp2NjArYkVGdTIwNjdYM2kxSzVMdUNaMGFWbUUwTC9PaWdJZS9IT1Ar?=
 =?utf-8?B?WTI4ZVZSd3ZkRllOYURaQnZyNnlzblViaHI3NW1kRFNoWHRMNklPOTFjMlZT?=
 =?utf-8?B?U09sTTFnN3hqZzg0bXd1M2F2SHQ0SHFZb1RDTXZGbmZrYnV1Wk5ISmNkSkVk?=
 =?utf-8?B?NXFuYjZCbGMraU5PaTZVNmVrZytiK3poc3k5bGxrenhJcnNrUHBoelBtOEJQ?=
 =?utf-8?B?b3ZTWG1DQ29hbkdET2lYODgwUjhJTDhRMWJxeHc2VDFOOEUvSHlXR012cmpJ?=
 =?utf-8?B?U2ZaYzgyZ3U4RTV2VHFOWTIrSEkwUS9YT1RjRWl5eENKWWhrM0VRb2VYV20w?=
 =?utf-8?B?aGQwd29sVnFkVW5kc0YxUWJYckx3TjlaeGNCKzVIbUhXK3pzS21JM0w0SkF3?=
 =?utf-8?B?QUZEYm45ZUJrYjZ1N25rUEtZcy9CUDNMRFB1dlE3WHZnQU9mSEZKRHBoTEs3?=
 =?utf-8?B?VW92by9Kb0xwTXFSK1FsR29IbnM4bzdVMk9GTU02U0ZabFg3ZzhjQWFKRkJM?=
 =?utf-8?B?ZlowaDVwOHpzNkMrZXF1SnQwREtzem1CV3hzb2padTNMZjErVUNSQlBmSmsv?=
 =?utf-8?B?cTZ4Y1R1ZHNEZFNGa3FjNXZsRG1DdllxY2UvWGFWS2xUaXgzUVhGcTcwUTY1?=
 =?utf-8?B?WEJEdlYwNm1lZzlZSVkxeTV6TS8vUHJLVVlhdWxOUFV1c3VtWVBvbENCcTRU?=
 =?utf-8?B?TWZXR3VJM1NBVUE0ZHVoL0lSbll3VTZtMDJ0NzNpUElrN3BIczZjSjhGTTVw?=
 =?utf-8?B?TnVvUDlYd28yRlR3MFVqNlpabE5HaCsvemxvS21laGlkdEpoS21lQXlsZkRP?=
 =?utf-8?B?NGNqeTF1V0EvTmN5OWdKM1lIUXFFVUxqTFY2MHhjL1dhV3J4cCtCaVZkYjA2?=
 =?utf-8?B?U1lZT2Fnb0JSZGV6djhsSDNPS0t4TEJpVTJuZzhKNFZzeGd3RUF2cFhMYUNo?=
 =?utf-8?B?eDdTMi9RY3lKeUxMc0U5SXRsakNIKzBIRDh1RDYvcXg3djZqSzlFcjNvTnpF?=
 =?utf-8?B?SC94TU80RjlqRjhSWGtDd2M1cVIrNElJbnM3eFgzc2diTWh0T1BzTGtUSklL?=
 =?utf-8?B?ZTZoOFc3TiszT0xiQ3oyMWE2MllEd0Q5TDhUT0dZb21BV0JGWlVBWWxQZ1Ni?=
 =?utf-8?B?czF2cEN3M21Tam1jQ01DaXUwOWdtZzhQa0xMcWVLOGRpc290Q3RpVVVPQjdk?=
 =?utf-8?B?RWY1RlU2b1V1WnVDV296UVVUcHM2eStVVGJtbmk0UVo5QVF1eHNwd0t4Slh3?=
 =?utf-8?B?dFpWYi9aYUI3UnFUUW9KMkM1dU1IRTBldHM5U2ZTc3lFMDU2N3JyOTE1NDN5?=
 =?utf-8?B?L0NkdzVOeTBPdDVGbmM5MnhBNytYWVRGMUtJTFFyclJRcnRDZW1qQjZSMm1T?=
 =?utf-8?B?QTEzMlBTOG5MQ1pwWEZQZGxaa3ZKV0hLVU14aG1NSDlyQlBBbGl0TnNnT0pH?=
 =?utf-8?B?ZnVOQjlTbTBGdjRSRHh0SVJSUFZyemREbzQ5SXA0RW52RWlMaXpNU2dLYnk0?=
 =?utf-8?B?aHgxSVE4VlY2ZnVsZmtWcjljR3R4RXlETlltU1ppK2M2RGVQY3orMExTUldE?=
 =?utf-8?B?WmJJcXNpNEJiMGphOUhqdmxuamhDVTFYcHpzWTIrcHBITHpKMXRqR1E1UmhH?=
 =?utf-8?B?OHVxTEFkVUxMdkpqdzNyeHpBSThWOElySDk5Q1ZZVFBySzhxTHozZjJzVS81?=
 =?utf-8?B?dVNqaHpRb0tlSkhIUlRYRkNSbUxTN3VRUjNuTSt5Z0RHSE9QT2FTL0pGZkRl?=
 =?utf-8?B?M3pIamQxbTJydVh6NFB1RFNkYWJEdHYrSmQvVldDMHJjc09FRnU2Uk95WTBw?=
 =?utf-8?B?T1JSS0RSeFpRSXBtOHN1K2tkMjZrRGcrK09pLzNVeTBjQWc1dnRtMWQ2NnE2?=
 =?utf-8?B?TmVBL0dMQ0ZHbEpSUVd0V3AxdFkvdkJrTFhEUWoxbkJNMkhJZzZkdWU3aCtF?=
 =?utf-8?B?V2Evck9mMWYzWFN0MzhkN1NCdmxJb2RuRmRmNXFSNUI4UG90SDg5bFAyb1BV?=
 =?utf-8?B?K28yTWs2WnZ6dnpKQUMrTUFSUzRlcmV1bDZiSEg1aloyZGRDMGZjNkhRWmo2?=
 =?utf-8?B?ei94OVBWc1NzRlZ6U2lZRVdEMzRJZFRvTTJqRStRbFI2REFYVXpxTWRTRVlu?=
 =?utf-8?B?Q3BnVllEWnl2SGw2ZFJhcEZXVjlXZ3RyaFlQbVVaVWJua0xpc3BQZ1ZCYkxN?=
 =?utf-8?B?dzBsUU1VcklPRzJGR1V4Ui9wYVpsTjhsbTlxRVhBSDh3S1gxMEdNc0YwS1V4?=
 =?utf-8?Q?ElgczCV1F7j8jQN4=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <93AD67A6518C6F4F8BAB024D8F513F33@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	Q34fXrEssFkp6GKbsUI63EUjxkzTxCIvp3AtMOAetrmfjFVNUfvEuyCc64IAHEtPld3q+ujJwQP5eGt2QNA8A99JdR1+cjoGGiBTlu3MRNau/y0IPls+TZ36CCeAZxtQHkAD9+Zwm0ThDyqJciv0KD+qL7oXi+e9wgwWJ5F9tRoHfesSot9CDSyirUBbd1cYAhSiOJY+zcTHQEwwa5D3WGuTnw3SisiCE3+jtzyv8aufc0fY7sE8yOVgUxkrZPSeC3x7MOzUnaIZXPHzh1T4yuMaAsDZ1BhRh6YHSJOGOYqGpOIJo64iZz/6re9MjF4iDHzoEiV/byRhxSftjO+D0A==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86113781-04aa-493d-ea36-08df1d5f7b25
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Sep 2026 12:53:23.4849
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 91g8NfELHcl+NqYCMepX0J+/sh29uuUzRrZvm3c9c4vM694PpOriGT+9wMbG8XWrECNfM8hs4Crvn6NAXVklZ3s5ae/ea6ig/Y8mXML38Ww=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR02MB7493
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI4MDA1MSBTYWx0ZWRfX0ENcRp+rg9x7
 U8uNbdSO8wJkU8D/p3VlxK2BEDYBb6+uZPgJ1DFtDzRmoSu0e7lT50D1sMb90EWHnCYtHjGEaDy
 FwKQ5l7BaWC0NSm9FSJzrS/NjIn73yjXx4BHUvoqzJ38xeN9vdtulXzET9FpF/WXxxS7Qsrg72y
 pWWh0ADjiNZWy1lcirNlxqogTOupVQHoBK5dtsTIgeaVroCUC6/CrnkVjQWHuvsj70v6+ctugV4
 85M2jmK4L0S3f3aWSIqblnOluUewGFRTPChgm8+pdqTkSu/N4C1tHS6+v9/acvV/WcY46lDIJy5
 oDauSts3r6UUpHaiKbFHx11Uzu6y1AGSEnutZ5fiEDmtapkMtafF++Bs9R7fo28YjHiLmIJvwPN
 naEWduqIZ/1wEBJo/r2d9/xDv0dl9KOfHqCAa9XqvInmlBmasEyIa5Wasxn9NhVLiuBMyiqCHbF
 oiM/TNujET/igr59haA==
X-Proofpoint-ORIG-GUID: B8NR9d-1v8o-EbzatdvR_6sp_YOJFjTt
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI4MDA1MSBTYWx0ZWRfX6zVUBha/BZNc
 OAdA6F/xm3HS8DtPvGWfOnOq+4jeDhQGNDLMwAq6VYV9v/Qwq502JpgLf2DqLOiEJ0osDwLwNYz
 K76tzPNnId6vXxKpUO1hCr1uwyPsmI8=
X-Authority-Analysis: v=2.4 cv=c/A+0h9l c=1 sm=1 tr=0 ts=6aba6345 cx=c_pps
 a=MpfTxiBaMh6MIwR6HTKnTw==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VofLwUrZ8Iiv6rRUPXIb:22 a=Ap8k9tRZuQ82DLYWQqG7:22 a=20KFwNOVAAAA:8
 a=LgP7S-U-kMzdRV7_vn8A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: B8NR9d-1v8o-EbzatdvR_6sp_YOJFjTt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-28_03,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQpIaSBFcmljLA0KDQo+IE9uIDE2IFNlcCAyMDI2LCBhdCA4OjE14oCvUE0sIEVyaWMgQXVnZXIg
PGVyaWMuYXVnZXJAcmVkaGF0LmNvbT4gd3JvdGU6DQo+IA0KPiAhLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLXwNCj4gIENB
VVRJT046IEV4dGVybmFsIEVtYWlsDQo+IA0KPiB8LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLSENCj4gDQo+IFNpbmNlIGxl
Z2FjeSBjb21wb3NpdGUgb3B0aW9ucyAoc3VjaCBhcyBTVkUsIHZpcnR1YWxpemF0aW9uLCAuLi4p
DQo+IGFuZCBuZXcgU1lTUkVHIHByb3BzIGNvZXhpc3QsIGFkZCBzb21lIGJhc2ljIGNvbnNpc3Rl
bmN5IGNoZWNrcy4NCj4gDQo+IFRob3NlIGNoZWNrcyBhcmUgcGVyZm9ybWVkIGJvdGggaW4ga3Zt
X2FyY2hfaW5pdF92Y3B1KCkgYmVmb3JlDQo+IGFwcGx5aW5nIHRoZSBTWVNSRUcgcHJvcHMgYXQg
dGhlIGVuZCBvZiB0aGUgaW5pdGlhbGl6YXRpb24gY2hhaW4uDQpXaGVyZSBlbHNlPw0KDQo+IFNv
bWUgSUQgcmVnIGZpZWxkcyBjb3JyZXNwb25kaW5nIHRvIGxlZ2FjeSBjb21wb3NpdGUgb3B0aW9u
IHNjb3BlDQo+IGFyZSBub3Qgd3JpdGFibGUuIEluIHRoYXQgY2FzZSB3ZSBqdXN0IGNoZWNrIHRo
YXQgdGhlIGZpZWxkIGhhcw0KPiBub3QgYmVjb21lIHdyaXRhYmxlLg0KSSBkb27igJl0IHVuZGVy
c3RhbmQgd2hlcmUgdGhlIGFib3ZlIGhhcHBlbnMgaW4gY29kZS4NCg0KPiANCj4gU2lnbmVkLW9m
Zi1ieTogRXJpYyBBdWdlciA8ZXJpYy5hdWdlckByZWRoYXQuY29tPg0KPiAtLS0NCj4gdGFyZ2V0
L2FybS9rdm0uYyB8IDEwNSArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKw0KPiAxIGZpbGUgY2hhbmdlZCwgMTA1IGluc2VydGlvbnMoKykNCj4gDQo+IGRpZmYg
LS1naXQgYS90YXJnZXQvYXJtL2t2bS5jIGIvdGFyZ2V0L2FybS9rdm0uYw0KPiBpbmRleCBkZGYz
MjBkMGU2Li5mNTJjMDM3NDVlIDEwMDY0NA0KPiAtLS0gYS90YXJnZXQvYXJtL2t2bS5jDQo+ICsr
KyBiL3RhcmdldC9hcm0va3ZtLmMNCj4gQEAgLTM0MCw2ICszNDAsMTA3IEBAIHN0YXRpYyBBUk02
NFN5c1JlZ0ZpZWxkICpnZXRfZmllbGQoaW50IGksIEFSTTY0U3lzUmVnICpyZWcpDQo+ICAgICBy
ZXR1cm4gTlVMTDsNCj4gfQ0KPiANCj4gKw0KPiArLyoqDQo+ICsgKiBrdm1fYXJtX3ZjcHVfdmFs
aWRhdGVfc3lzcmVnOg0KPiArICoNCj4gKyAqIFZhbGlkYXRlIGEgU1lTUkVHIGZpZWxkIHZhbHVl
IGlzIGNvbnNpc3RlbnQgd2l0aCBsZWdhY3kgY29tcG9zaXRlIG9wdGlvbnMNCj4gKyAqIFNvbWUg
Y2hlY2tzIGFyZSBub3QgaW1wbGVtZW50ZWQgYmVjYXVzZSB0aGUgY29ycmVzcG9uZGluZyBzeXNy
ZWcgZmllbGQNCj4gKyAqIGlzIG5vdCBjdXJyZW50bHkgd3JpdGFibGUuIEluIHRoYXQgY2FzZSB3
ZSBtYWtlIHN1cmUgdGhlIGZpZWxkIGhhcyBub3QNCj4gKyAqIGJlY29tZSB3cml0YWJsZSwgd2hp
Y2ggd291bGQgbWVhbiB0aGUgdXNlciBoYWQgdGhlIGNhcGFiaWxpdHkgdG8gc2V0IHRoZQ0KPiAr
ICogY29ycmVzcG9uZGluZyBwcm9wZXJ0eS4NCj4gKyAqDQo+ICsgKiByZXR1cm4gdHJ1ZSBpZiBj
b25zaXN0ZW50LiBmYWxzZSBpZiBpdCBpcyBub3QsIGFsb25nIHdpdGggYW4gZXJyb3IgaGFuZGxl
DQo+ICsgKi8NCj4gK3N0YXRpYyBib29sIGt2bV9hcm1fdmNwdV92YWxpZGF0ZV9zeXNyZWcoQVJN
Q1BVICpjcHUsIEFSTTY0U3lzUmVnRmllbGQgKmZpZWxkLA0KPiArICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICB1aW50NjRfdCB2YWx1ZSwgRXJyb3IgKiplcnJwKQ0KPiAr
ew0KPiArICAgIGNvbnN0IGNoYXIgKmZpZWxkbmFtZSA9IGZpZWxkLT5uYW1lOw0KPiArICAgIEFS
TTY0U3lzUmVnICpzeXNyZWdkZXNjID0gJmFybTY0X2lkX3JlZ3NbZmllbGQtPmluZGV4XTsNCj4g
KyAgICBjb25zdCBjaGFyICpyZWduYW1lID0gc3lzcmVnZGVzYy0+bmFtZTsNCj4gKyAgICBnX2F1
dG9mcmVlIGNoYXIgKnByb3BuYW1lID0gZ19zdHJkdXBfcHJpbnRmKCJTWVNSRUdfJXNfJXMiLCBy
ZWduYW1lLCBmaWVsZG5hbWUpOw0KSSBkb27igJl0IHNlZSBhIHJlYXNvbiB0byBidWlsZCBwcm9w
ZXJ0eSBuYW1lIGhlcmUuDQo+ICsNCj4gKyAgICAvKiB2aXJ0dWFsaXphdGlvbiAqLw0KPiArICAg
IGlmICghc3RyY21wKHByb3BuYW1lLCAiU1lTUkVHX0lEX0FBNjRQRlIwX0VMMV9FTDIiKSkgew0K
PiArICAgICAgICAvKiBjb25zaXN0ZW5jeSB3aXRoIG1hY2hpbmUgdmlydHVhbGl6YXRpb24gcHJv
cGVydHkgKi8NCj4gKyAgICAgICAgaWYgKGNwdS0+aGFzX2VsMiAmJiB2YWx1ZSA9PSAwKSB7DQo+
ICsgICAgICAgICAgICBlcnJvcl9zZXRnKGVycnAsDQo+ICsgICAgICAgICAgICAgICAgIkluY29u
c2lzdGVudCAtbWFjaGluZSB2aXJ0dWFsaXphdGlvbj1vbiBhbmQgIg0KPiArICAgICAgICAgICAg
ICAgICIlcz0wIiwgcHJvcG5hbWUpOw0KPiArICAgICAgICAgICAgcmV0dXJuIGZhbHNlOw0KPiAr
ICAgICAgICB9IGVsc2UgaWYgKCFjcHUtPmhhc19lbDIgJiYgdmFsdWUgPiAwKSB7DQo+ICsgICAg
ICAgICAgICBlcnJvcl9zZXRnKGVycnAsDQo+ICsgICAgICAgICAgICAgICAgIkluY29uc2lzdGVu
dCAtbWFjaGluZSB2aXJ0dWFsaXphdGlvbj1vZmYgYW5kICINCj4gKyAgICAgICAgICAgICAgICAi
JXMgPiAwIiwgcHJvcG5hbWUpOw0KPiArICAgICAgICAgICAgcmV0dXJuIGZhbHNlOw0KPiArICAg
ICAgICB9DQo+ICsgICAgLyogc2VjdXJlICovDQo+ICsgICAgfSBlbHNlIGlmICghc3RyY21wKHBy
b3BuYW1lLCAiU1lTUkVHX0lEX0FBNjRQRlIwX0VMMV9FTDMiKSAmJiB2YWx1ZSA+IDApIHsNCj4g
KyAgICAgICAgLyogY29uc2lzdGVuY3kgd2l0aCBtYWNoaW5lIHNlY3VyZSBwcm9wZXJ0eSAqLw0K
PiArICAgICAgICBlcnJvcl9zZXRnKGVycnAsICIlcyBpcyBzZXQgYnV0IHFlbXUgaXMgbm90IHJl
YWR5IHRvIHN1cHBvcnQgaXQiLA0KPiArICAgICAgICAgICAgICAgICAgIHByb3BuYW1lKTsNCj4g
KyAgICAgICAgcmV0dXJuIGZhbHNlOw0KPiArICAgIC8qIE1URSAqLw0KPiArICAgIH0gZWxzZSBp
ZiAoIXN0cmNtcChwcm9wbmFtZSwgIlNZU1JFR19JRF9BQTY0UEZSMV9FTDFfTVRFIikpIHsNCj4g
KyAgICAgICAgZXJyb3Jfc2V0ZyhlcnJwLCAiJXMgaXMgbm93IGV4cG9zZWQgYnV0IHFlbXUgaXMg
bm90IHJlYWR5IHRvIHN1cHBvcnQgaXQiLA0KPiArICAgICAgICAgICAgICAgICAgIHByb3BuYW1l
KTsNCj4gKyAgICAgICAgcmV0dXJuIGZhbHNlOw0KPiArICAgIC8qIFNWRSAqLw0KPiArICAgIH0g
ZWxzZSBpZiAoIXN0cmNtcChwcm9wbmFtZSwgIlNZU1JFR19JRF9BQTY0UEZSMF9FTDFfU1ZFIikp
IHsNCj4gKyAgICAgICAgZXJyb3Jfc2V0ZyhlcnJwLCAiJXMgaXMgbm93IGV4cG9zZWQgYnV0IHFl
bXUgaXMgbm90IHJlYWR5IHRvIHN1cHBvcnQgaXQiLA0KPiArICAgICAgICAgICAgICAgICAgIHBy
b3BuYW1lKTsNCj4gKyAgICAgICAgcmV0dXJuIGZhbHNlOw0KPiArICAgIH0gZWxzZSBpZiAoIXN0
cmNtcChwcm9wbmFtZSwgIlNZU1JFR19JRF9BQTY0WkZSMF9FTDFfU1ZFdmVyIikpIHsNCj4gKyAg
ICAgICAgaWYgKGNwdV9pc2FyX2ZlYXR1cmUoYWE2NF9zdmUsIGNwdSkgJiYgdmFsdWUgPT0gMCkg
ew0KPiArICAgICAgICAgICAgZXJyb3Jfc2V0ZyhlcnJwLCAic3ZlIGlzIHNldCBidXQgJXMgaXMg
c2V0IHRvIDAiLCBwcm9wbmFtZSk7DQo+ICsgICAgICAgICAgICByZXR1cm4gZmFsc2U7DQpUaGlz
IGlzIGFjdHVhbGx5IGFuIHZhbGlkIGNvbmZpZ3VyYXRpb24uDQoNCj4gKyAgICAgICAgfSBlbHNl
IGlmICghY3B1X2lzYXJfZmVhdHVyZShhYTY0X3N2ZSwgY3B1KSAmJiB2YWx1ZSA+IDApIHsNCj4g
KyAgICAgICAgICAgIGVycm9yX3NldGcoZXJycCwgInN2ZSBpcyBub3Qgc2V0IGJ1dCAlcyBpcyBn
cmVhdGVyIHRoYW4gMCIsDQo+ICsgICAgICAgICAgICAgICAgICAgICAgIHByb3BuYW1lKTsNCj4g
KyAgICAgICAgICAgIHJldHVybiBmYWxzZTsNCj4gKyAgICAgICAgfQ0KPiArICAgIC8qIFBBVVRI
ICovDQo+ICsgICAgfSBlbHNlIGlmICghc3RyY21wKHByb3BuYW1lLCAiU1lTUkVHX0lEX0FBNjRJ
U0FSMV9FTDFfQVBBIikpIHsNCj4gKyAgICAgICAgLyogUEFVVEggUUFSTUE1IGFkZHJlc3MgYXV0
aGVudGlmaWNhdGlvbiAqLw0KPiArICAgICAgICBlcnJvcl9zZXRnKGVycnAsICIlcyBpcyBub3cg
ZXhwb3NlZCBidXQgcWVtdSBpcyBub3QgcmVhZHkgdG8gc3VwcG9ydCBpdCIsDQo+ICsgICAgICAg
ICAgICAgICAgICAgcHJvcG5hbWUpOw0KPiArICAgICAgICByZXR1cm4gZmFsc2U7DQo+ICsgICAg
fSBlbHNlIGlmICghc3RyY21wKHByb3BuYW1lLCAiU1lTUkVHX0lEX0FBNjRJU0FSMV9FTDFfQVBJ
IikpIHsNCj4gKyAgICAgICAgLyogUEFVVEggSW1wbCBEZWZpbmVkIGFkZHJlc3MgYXV0aGVudGlm
aWNhdGlvbiAqLw0KPiArICAgICAgICBlcnJvcl9zZXRnKGVycnAsICIlcyBpcyBub3cgZXhwb3Nl
ZCBidXQgcWVtdSBpcyBub3QgcmVhZHkgdG8gc3VwcG9ydCBpdCIsDQo+ICsgICAgICAgICAgICAg
ICAgICAgcHJvcG5hbWUpOw0KPiArICAgICAgICByZXR1cm4gZmFsc2U7DQo+ICsgICAgfSBlbHNl
IGlmICghc3RyY21wKHByb3BuYW1lLCAiU1lTUkVHX0lEX0FBNjRJU0FSMV9FTDFfR1BBIikpIHsN
Cj4gKyAgICAgICAgLyogUUFSTUE1IGdlbmVyaWMgY29kZSBhdXRoZW50aWZpY2F0aW9uICovDQo+
ICsgICAgICAgIGVycm9yX3NldGcoZXJycCwgIiVzIGlzIG5vdyBleHBvc2VkIGJ1dCBxZW11IGlz
IG5vdCByZWFkeSB0byBzdXBwb3J0IGl0IiwNCj4gKyAgICAgICAgICAgICAgICAgICBwcm9wbmFt
ZSk7DQo+ICsgICAgICAgIHJldHVybiBmYWxzZTsNCj4gKyAgICB9IGVsc2UgaWYgKCFzdHJjbXAo
cHJvcG5hbWUsICJTWVNSRUdfSURfQUE2NElTQVIxX0VMMV9HUEkiKSkgew0KPiArICAgICAgICAv
KiBRQVJNQTUgZ2VuZXJpYyBjb2RlIGF1dGhlbnRpZmljYXRpb24gKi8NCj4gKyAgICAgICAgZXJy
b3Jfc2V0ZyhlcnJwLCAiJXMgaXMgbm93IGV4cG9zZWQgYnV0IHFlbXUgaXMgbm90IHJlYWR5IHRv
IHN1cHBvcnQgaXQiLA0KPiArICAgICAgICAgICAgICAgICAgIHByb3BuYW1lKTsNCj4gKyAgICAg
ICAgcmV0dXJuIGZhbHNlOw0KPiArICAgIC8qIFBNVSAqLw0KPiArICAgIH0gZWxzZSBpZiAoIXN0
cmNtcChwcm9wbmFtZSwgIlNZU1JFR19JRF9BQTY0REZSMF9FTDFfUE1VVmVyIikpIHsNCj4gKyAg
ICAgICAgaWYgKGNwdS0+aGFzX3BtdSAmJiB2YWx1ZSA9PSAwKSB7DQo+ICsgICAgICAgICAgICBl
cnJvcl9zZXRnKGVycnAsICIlcyBpcyAwIHdoZXJlYXMgcG11IGlzIHNldCIsIHByb3BuYW1lKTsN
Cj4gKyAgICAgICAgICAgIHJldHVybiBmYWxzZTsNCj4gKyAgICAgICAgfSBlbHNlIGlmICghY3B1
LT5oYXNfcG11ICYmIHZhbHVlKSB7DQo+ICsgICAgICAgICAgICBlcnJvcl9zZXRnKGVycnAsICIl
cyBpcyBub24gbnVsbCB3aGVyZWFzIHBtdSBpcyB1bnNldCIsIHByb3BuYW1lKTsNCj4gKyAgICAg
ICAgICAgIHJldHVybiBmYWxzZTsNCj4gKyAgICAgICAgfQ0KPiArICAgIC8qIGFhcmNoNjQgZmFs
c2UgKi8NCj4gKyAgICB9IGVsc2UgaWYgKCFhcm1fZmVhdHVyZSgmY3B1LT5lbnYsIEFSTV9GRUFU
VVJFX0FBUkNINjQpKSB7DQo+ICsgICAgICAgIGlmICgoIXN0cmNtcChwcm9wbmFtZSwgIlNZU1JF
R19JRF9BQTY0UEZSMF9FTDFfRUwwIikgfHwNCj4gKyAgICAgICAgICAgICAhc3RyY21wKHByb3Bu
YW1lLCAiU1lTUkVHX0lEX0FBNjRQRlIwX0VMMV9FTDEiKSB8fA0KPiArICAgICAgICAgICAgICFz
dHJjbXAocHJvcG5hbWUsICJTWVNSRUdfSURfQUE2NFBGUjBfRUwxX0VMMiIpKSAmJiB2YWx1ZSA8
IDIpDQo+ICsgICAgICAgICAgICBlcnJvcl9zZXRnKGVycnAsICIlcyBpcyA8IDIgd2hpbGUgYWFy
Y2g2NCBpcyBzZXQgdG8gb2ZmIiwNCj4gKyAgICAgICAgICAgICAgICAgICAgICAgcHJvcG5hbWUp
Ow0KPiArICAgICAgICAgICAgcmV0dXJuIGZhbHNlOw0KcmV0dXJuIHNob3VsZCBiZSBjb3ZlcmVk
IGluIGJyYWNlcy4NCg0KV2FybSBSZWdhcmRzLA0KS2h1c2hpdA0KPiArICAgIH0NCj4gKyAgICBy
ZXR1cm4gdHJ1ZTsNCj4gK30NCj4gKw0KPiAjZGVmaW5lIE1BS0VfSURSRUdfS0VZKHJlZ19pZHgs
IGZpZWxkX3NoaWZ0KSBcDQo+ICAgICAoKCh1aW50NjRfdCkocmVnX2lkeCkgPDwgOCkgfCAoKHVp
bnQ2NF90KShmaWVsZF9zaGlmdCkgJiAweEZGKSkNCj4gDQo+IEBAIC0yMjQxLDYgKzIzNDIsMTAg
QEAgc3RhdGljIGludCBrdm1fYXJtX2FwcGx5X3N5c3JlZ19wcm9wcyhBUk1DUFUgKmNwdSwgRXJy
b3IgKiplcnJwKQ0KPiAgICAgICAgIHVpbnQ2NF90IG9sZGZ2Ow0KPiAgICAgICAgIGludCByZXQ7
DQo+IA0KPiArICAgICAgICBpZiAoIWt2bV9hcm1fdmNwdV92YWxpZGF0ZV9zeXNyZWcoY3B1LCBm
aWVsZCwgdmFsdWUsIGVycnApKSB7DQo+ICsgICAgICAgICAgICByZXR1cm4gLTE7DQo+ICsgICAg
ICAgIH0NCj4gKw0KPiAgICAgICAgIG1hc2sgPSBNQUtFXzY0QklUX01BU0sobG93ZXIsIGxlbmd0
aCk7DQo+ICAgICAgICAgdmFsdWUgPSB2YWx1ZSA8PCBsb3dlcjsNCj4gDQo+IC0tIA0KPiAyLjUz
LjANCj4gDQoNCg==
