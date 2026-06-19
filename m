Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5AF73233F4
	for <kvmarm@lists.linux.dev>; Fri, 19 Jun 2026 06:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781849178; cv=fail; b=MAiR6txdSVFyul1+hMWM8ZldpKEScrojfQ9qRnKr5jFpUySW3NeJEPcP8UomeeMMXUflTX6rlEWVdONIMxl0ZijOKQaPr/dayZF6Z8LtBnzMXENWo1tPec+DSsKLYEFpyzQh+Spt4r8/U93bvSHO5Ze93jaRg0Rl/YDpcVnc1Yg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781849178; c=relaxed/simple;
	bh=fgDjMhNZFJP0v6No3+u5XZ4wF2nwLjUJXnYOyo54dE0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=RHFhOsbChwzCzbFiA3sjETWHp0rla89dZ6zCsZe/zq0TB8OXp8udLMeHO7p2zqQP0Hs7GfkFUHkkcDMDw+pUzDTTBu1DsmCsY5hsbYplRNy+F3sVqhcor2Izt27SpRw4L1xcJguhdn/fIiLQ2Tm/7QOen9BrZQWOs9eOn3yiPP0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=PRrHC/Uo; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=G7v76Ufp; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="PRrHC/Uo";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="G7v76Ufp"
Received: from pps.filterd (m0127840.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65J2voke2379934;
	Thu, 18 Jun 2026 23:05:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=fgDjMhNZFJP0v6No3+u5XZ4wF2nwLjUJXnYOyo54d
	E0=; b=PRrHC/Uo8Gv3ZySNAD6vDAezog/AvuMNQigWqG6Oq3w7IOwiBu9XtGu74
	s1GhKufVlgJY4AY5y37fEIyIroFY1DpgzngMMgRBSTVeOpl8gGqSoPyJa9Iin9av
	PGuvhFiNjWi6c6ShR0fjiNis1CvzF9q3SW4YAi6EzmKTWmJGlcJsj/boeZ+sbexS
	1As64ZHxnpkEyKc+av2AZVA5DmKlzZwLSToed4/N8/D+s7C+EcYIbi6Offxi8mhU
	q4uycEASIjp0KvizKmxwYIt9bBWJW7yb7CE6KaqrwbqEJJ53kJbHgkBvLDgp6vTk
	0S/q+nUkJYPAjUOy7x3CYI/BI8F5Q==
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11021113.outbound.protection.outlook.com [40.107.208.113])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 4evpfs1e92-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 18 Jun 2026 23:05:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BgOrR0LtlP/gEU13yk3D/SgHNoXEW7D5KA/+5xgPVDpfHYr80/6/tIGRo2POnzYSF2+eGXvNtBN6D8phJZ68/5xKS3H7mncr+RoH+wWAaFfJ3JRbdMBsX1zvGZki16UjrHsF52H/ipOwrMP452eKJsE4QuqdAtdlxkRhTRRSWW3sBuJIHZRER02gV85fiz0nmO8EAREruHV+iie3YeBLyWLiasvZEOAs09+FtCb8uJFQJyiAmzriQsFdPZI+4IGDkijwy2ixjYonkbM3PhwIF+SP6FRn/651g6+tjlhh0IlhhQSoq8fX1Oos0AHG20DX4b7yIE1a5j3Hia5N8cj7Zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fgDjMhNZFJP0v6No3+u5XZ4wF2nwLjUJXnYOyo54dE0=;
 b=eWyyLznVVY/fnyyEai7JI8qzfGEQwc7+gnf3IhVBanmuCjXzIduyLFprkYiBtn60M5VMroppj/SrlsMn05WV64tXoH1Kx/aRs+EuZVrwYahu0sf4M4MzfBcHE2Wcf4GiZbRTCxLGkbZHWAFPHmtE6kdEYlyhOYmHzDP6l0S+l31XnzXjpJKQ4stMlH9DYaKTVZYS2ZzLsdYhTmAZAoh3+f3t3GmOTLlaqCkWqn4uEwqn2SN3FmKxnx0tpzrNkq3NQvBWfpkGn/0gpRIkWnmZjaniV0cLW80ngs3CliGC1egRFd2IIvlrnbEPBoUChtRHQw2u937zVrK65c/xhrzheA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fgDjMhNZFJP0v6No3+u5XZ4wF2nwLjUJXnYOyo54dE0=;
 b=G7v76UfpWlINyfYBA0cmmV0iTs+EC+o0c9UDIh+hrO1y+35tS/b2INixtmmPP87Bp/T61W5zdSDNFYbdqj7o0ltloCVwl3rqwzhgwC3N8GK+soX6UvpWQV6VXV3dvdVN6OllfFbjuPjkGK/a7wsX17PnHOxS3dftHS0gchN0o7H2VlvV68bHgVdTGceEIoQh0S3Ahto7kULmXEJ4BE9SyJVHs5ip3ANoOym0VabCUp8apUwNQKqaHCdaaNraFxrf2iDA4FIogui+otqaqHM/C7ocfpbegTAS0GPbYFvzyY86MyaKCVF9/IS6RUDm/roPQjH0izxgFiFtWfpwK3Voug==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by DM6PR02MB6697.namprd02.prod.outlook.com (2603:10b6:5:214::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.139.11; Fri, 19 Jun
 2026 06:05:56 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%5]) with mapi id 15.21.0139.009; Fri, 19 Jun 2026
 06:05:55 +0000
From: Khushit Shah <khushit.shah@nutanix.com>
To: "eric.auger@redhat.com" <eric.auger@redhat.com>
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
        "jdenemar@redhat.com" <jdenemar@redhat.com>,
        Sandesh Patel
	<sandesh.patel@nutanix.com>
Subject: Re: [RFC PATCH v6 14/17] arm-qmp-cmds: introspection for ID register
 props
Thread-Topic: [RFC PATCH v6 14/17] arm-qmp-cmds: introspection for ID register
 props
Thread-Index: AQHc/ZQAy2L7Uw2Pb0WxEuN53nkKZ7ZEDhAAgAFaGQA=
Date: Fri, 19 Jun 2026 06:05:55 +0000
Message-ID: <A6010F6F-FF60-4227-ACFE-B141EEBE88AC@nutanix.com>
References: <20260616132625.1732031-1-eric.auger@redhat.com>
 <20260616132625.1732031-15-eric.auger@redhat.com>
 <c6f663fc-93ad-4a22-b9dc-d7a4653bf348@redhat.com>
In-Reply-To: <c6f663fc-93ad-4a22-b9dc-d7a4653bf348@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA2PR02MB7564:EE_|DM6PR02MB6697:EE_
x-ms-office365-filtering-correlation-id: 6bd50ed0-f964-4df2-7753-08decdc8d352
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|366016|376014|1800799024|23010399003|38070700021|18002099003|22082099003|5023799004|4143699003|56012099006|6133799003;
x-microsoft-antispam-message-info:
 r4ytjrx+DYhHaxBb/fEMKJs2XYOal0J03m185WjpNst+D0jy6TlxvMQJsA+t65UhGvJ+t8Hg67tmCc2uZ9nJPfpT4zFIGYD+NF2lGVuQiwTe3P8H5PKp2oPOZL0DJ9/0tDpXacoz5tUe59YoW/cSRILjXE6c5aawY/Bt+KykMU66lkDJmB4bXxC9X3Q0Q/LpoQiuRpSEikSjM/5ripu6MjEt/x9cmW0vtPvVVMDvpMlZkALtGHy6IcESO2P2gV+euvcrrEnhfi07p9vV15hijbVpBDXbxGhSsIb0+rkvNyZMB7C6DlDR1WXYVm6BX+gB/t4ztuAifaPdYm4J+YnhxdDvbXoMkgPMlQTq9bJP+Wurs0wDhOl9tH9zcDQm7lM6Nuzb/2qK2e8w66y1OOCByQ+QfWgns0WP+ij/1tsTa3mWM49bYVANVO27A9AZJmdk5YuO54WTMlz3bxcbWKVkwO5JQMU0bP9w/iRqiSeAYFnCL5jSooCsbSli9TKCyehI19xyJ5elRRYDSeQFlouihutZoG+EkNVQ6Um5/R4FXBzofHyspLvDoXpOE3ytlKQbGz6SH/FtIupJcOV4JTlqfvfGT9Z37HpQEKWaUcqv2uBOxMEGAB2NKeDGk3XUvp90II+ksYxYzonTQ8rzQZOepGmuOUNrmbtXReEu0WhDwtnq8txPooMJoerzZnzNivhPjVkCTVv4kNhmLOHHl1MFlbcFEpzxEbGjvaPeAVGQC1I=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024)(23010399003)(38070700021)(18002099003)(22082099003)(5023799004)(4143699003)(56012099006)(6133799003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?MmdGa0dXbmk4Q2ZuazR3RUFwTm11YjByQ2dBVVJZK1VUemV3UGQvWjFUKzQv?=
 =?utf-8?B?MlRIN2RFUllSRHlDRUkrNEJUbjZCWFdFUDNtbC9sVE1OME9kQVBxM1MzZkZi?=
 =?utf-8?B?WmhBaVAyNklJM2FmVEhyZEY4aisyMWpNdmd2L1Y1SjJ4RUFTVGtFVytoMHZv?=
 =?utf-8?B?RkZxK0lYQ2Irc3EvdnpHT3FxWmdMNDR5cU9UMlVMTTY5OEpIUGxiOU5JdDRM?=
 =?utf-8?B?bXA1QmNSY2RvMjdNMVFSSzlaWGpwQUoxb3VkV2NVRFRXOEtHL01oazA2My9o?=
 =?utf-8?B?a3YvZCtMQ2FIN01vdjFTZ0NQS2dQRmxFSUQyRVNyOW9MZVdoVzN1TmVyaHlO?=
 =?utf-8?B?WEgwVjNXTTk4SU55NDZZZE5wVDIyczZUbmtFelFFRG9FK0R5dnJIQzRoWDlw?=
 =?utf-8?B?K1Y0TTJ5QzFTZVRHbXF0TkFMYUh1UGVOcUErQ3V0V3R0eHM1S2NBbXlzNFp3?=
 =?utf-8?B?eCtnTTJmaE1FMlBYVWExUlhuWERTWllXMjdFdU1DUkw3TUozR1k0TzhXMkQ1?=
 =?utf-8?B?RlIxVm1rdzRKNGN1cVBCQjhrVUs0OVVPVGMyN0NEbUxPZU53YnJaeXRsNE9r?=
 =?utf-8?B?dGE2TytMbFlyMWdkWmRyTDRkQkVKejA4UTlMcFEwRTVPZmJGeHoycDEwdzcz?=
 =?utf-8?B?Qk1TSWk0bllsdVBxMERhd1VsOUVYZjlscjRjT0NGaGwzaXlDS1IwMDR6K1pR?=
 =?utf-8?B?VmoxZXJpV1BuaE1EQ28vUDM5S2RVeldkK3hjcXpsRjdhMjJlK0tnYnZiUHhY?=
 =?utf-8?B?THdXSGtWb2JJN3U5VURNdXlrTG4wYmxLN3djODhWTEhzNy8wOVRPbHRFa1F5?=
 =?utf-8?B?bUJIcUxOWTdBNjJFTlFnaE0vQ2lTRjFOVnNYRlFkM1UzcXdvZUVrZlQ2NjJu?=
 =?utf-8?B?azJ4Z1VNOElnU25Jc1o3VVNaMTNOMWdyeWx6RTNTVzY4VG83SGUwYUpqTENC?=
 =?utf-8?B?Z3ZSb3JWcXFXa0JjeDJXcE5EbmhLaXhtM1c3aDBlRnI0blR6dHBHVkpoNDg0?=
 =?utf-8?B?c3lJaG56NEg3eDh1UC8zRGFXNVR3NHdkSTJGVzVlMFNPZUZPdW1JV2tuR1lQ?=
 =?utf-8?B?WW9lU1ZUbDFXY3dQOUJJVk1XdU1wOU84RUorZ3FOUW1QM0RrNmpNWTVxaWZ1?=
 =?utf-8?B?UFA5OWpVaE54MzU3eEF5b2cvbVJQckY2WHpSdmhJS1ZIR2JodThmOGRTQm9o?=
 =?utf-8?B?YitYMGYyMThhdFdxTFIvY3lxZm5zMXAzU3VXMUxoRGo3TDh0VGNaTTRJbzVq?=
 =?utf-8?B?Q2FxVUVQM3JyRUovOGRqb3FLZ3ExQVMwNWtVUVdKTHo4SzZzQnQxYzNOUjNJ?=
 =?utf-8?B?c01HaTF4TGpaSm5McmU3ME92MUJjTGdieUlGSytGUHdKcGdwQWt6L20wT2dD?=
 =?utf-8?B?eXBXdU0yREoyMDN3VWQ5MUZ0MmViTTN2ZUVrQVo1RUN3RGx6bTBUd3lHWWcv?=
 =?utf-8?B?dDcyckJ2eDc5TmxueDVRU3hLYnk2S2dGZmNLeUVCb241VEtiSUZIdEdmQmNB?=
 =?utf-8?B?Um10TXczMHpLaWxGNjc5Tmo5NW81eTBCZFhmVlFZRnhMOTBZYm1xeHBocnlo?=
 =?utf-8?B?Wjc0YTJldEo4dWhDZXIwVWlFN3BCdU92OVowQzNhUSt6UVNvblpFUVVPQWlO?=
 =?utf-8?B?bDh6SDk1Qnl4V01kWVVvcXh4N2dpOUtGNjdzM1VlVzZiUUhxV3lRMnJBTTFM?=
 =?utf-8?B?VU1RdDVzdGhnR3lZNWRaeDlwWFBxWnVBM21SdG16YU1JQmRBK21DUHNKcnhI?=
 =?utf-8?B?eWhPSE9rT05CeWdNN1h1NmUvL2NpT0VJMThUNURiNStpSkxoU01jOHhJeEh3?=
 =?utf-8?B?WTM1enJQZTBXdW9WL0RjUFpEamZSWDg3Y2h0bjVyRng0cG5rUXlTeStpOFVu?=
 =?utf-8?B?dFp5bjgzU0pCYlVsVnJncE5Ca01FTnNmY3piNjMxQ2ZOKzd2ZHd6T3NqSmgz?=
 =?utf-8?B?S1FvbVJWK1N2a09KN0xEUWphbnN0YVorV1ljY2ZRT1FMeC8rRS9KQy8vNXEz?=
 =?utf-8?B?WUxNNWY0eTJUUGN2cVlZZkhMTHJSYnhnL2JIMmZ6RU83VVdiOXR6c2dZb0JH?=
 =?utf-8?B?T1NkR2w4VkYyQkRqNkZTa2JuWmhpeTBFeDNkcVRrVUhlWmxVaUdmVUg0R3hD?=
 =?utf-8?B?Um5nTFJpYU1TRXNkbFRSTE5wQWpuYW41MXRTRndsYy9OZVp0YVZIWCtVd1Nx?=
 =?utf-8?B?RGZjNlZ3aCtWRDIvTW91Z25leVZQRDNmcVlyaCt4UGZBTUVzbTBlU3pWVWRm?=
 =?utf-8?B?QW5CeDZBYm1uNlYxS2VLTnYzdFhyZ3p2MnB3KzMzV1UzS1VvKzgvOFZCQWpL?=
 =?utf-8?B?R0lqVUdGeVlaREVZWGhCb2dSTHZzY1VyYjlRS21sU3Y5MndTbW1QWGl1VU03?=
 =?utf-8?Q?kHlq1BH5wCw/MLQw=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <180AC7950C961D448C2A90F9D0FBA4A3@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	QLqpv67RmPI/n9nzvWyRR6llW8T7/h8ixSOhi7wX9Jn+VOlkI3HNTkSGq24K/j27lQoEDeZJJjDo5VX3rMgVFjE/eckjmNlPoBL3GhV+Y4aASCehua6JmYgFahnMZC+KZ0zSJAdBhbC3C+4OqcDnlrdMnYZ2+3MsX2CNoCtYYeWajanXsNUlk40s+lJ3BJ9UF92FqEA/1JBFOzmYaNdj3mG6/sZcXf3DxXAT20B0j2Hoy75kjpYXFBaqJ8zTR8x2SN6C5KDZyGXDqEOccPupA0kYOE5KjDrHFOAc9ySxbFbs2T6fZlnUq/BxOYCaVmxI7Q9wZzWDCtThRB05f98dMQ==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6bd50ed0-f964-4df2-7753-08decdc8d352
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jun 2026 06:05:55.4589
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8UNKSS6Qhz/7R41bDV/lE2h7G7F5CPcuH0ucaWwjugYvjC/v6AdogKgOvWZQ07k/lzpb0E217aF1N8jJ9cLNuEC2dGpg+7ghFxAipd+/OZI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR02MB6697
X-Proofpoint-GUID: gp7ewTtoxDcwoPkOyPIvMSXwFbh-C8Sd
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE5MDA1NCBTYWx0ZWRfX+pYiE3p1ri8o
 rF69P0UBeaiQo95CRvqBHdqWk+q8kIxaU/UpI/CzFkjTtcD5OuzP33lGZ13tqfWgkMFVKVKEjrI
 IxPJ5jUJWVVQAne4QuRw4cyTl4myKm8=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE5MDA1NCBTYWx0ZWRfX4mJ0o6rrRcf2
 qmoCw1T6jiokshoFXxk5RZOgs3eWuC57LhY2QskeWd5OMXqwHmS5moVpCGTqc9jcKYF2oMZmJ+S
 790RN7kr3Mm64Bh5ldP1GJUHq38FzWTATUdlYyiNaE4JaoAMl9vXJMmdLhReJEsWYpAi+JDBYAc
 fAz5c/hPkmjVsE59cQ2x3LpteJq/xOwxk+tZEr38C0Me/qwrRxCA3UwncofcH5tVPtvIHPRVRq2
 Squz8wbgDEdVyWS794BOQ7yVnfCt2p+kR8BqcEX4zY4Mh34U/uY0PqkfaGtdmijmQ1qnhWxz+8N
 XV/dCHPwgthI9ihmMlRd3F/jDbciUxfU5voEwiaaSZ16B3B3CYyfaxZ3ZOAUWsCPMcn7F40+y05
 Bu+AeG1zjwXsTSczQ4NSkodTHFUiGGKMsiQlP7AiZMH+CbXWFIYqmh8M8/iYFTVfagy8EmiGVzB
 dr0BYg0HM3iAXrYS4OA==
X-Authority-Analysis: v=2.4 cv=XuzK/1F9 c=1 sm=1 tr=0 ts=6a34dc47 cx=c_pps
 a=f+3zdzEv7nFEBFh6qWwLEA==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=FelO9ux0wxsA:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VofLwUrZ8Iiv6rRUPXIb:22 a=_-M8LpHI31CeLmyZm6wg:22 a=20KFwNOVAAAA:8
 a=1nHZzikcq_zE_l74pm8A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: gp7ewTtoxDcwoPkOyPIvMSXwFbh-C8Sd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-19_01,2026-06-18_03,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gMTggSnVuIDIwMjYsIGF0IDI6NTbigK9QTSwgRXJpYyBBdWdlciA8ZXJpYy5hdWdl
ckByZWRoYXQuY29tPiB3cm90ZToNCj4gDQo+ICEtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tfA0KPiAgQ0FVVElPTjogRXh0
ZXJuYWwgRW1haWwNCj4gDQo+IHwtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tIQ0KPiANCj4gSGkgS2h1c2hpdCwNCj4gDQo+
IE9uIDYvMTYvMjYgMzoxNyBQTSwgRXJpYyBBdWdlciB3cm90ZToNCj4+IEZyb206IENvcm5lbGlh
IEh1Y2sgPGNvaHVja0ByZWRoYXQuY29tPg0KPj4gDQo+PiBJbXBsZW1lbnQgdGhlIGNhcGFiaWxp
dHkgdG8gcXVlcnkgYXZhaWxhYmxlIElEIHJlZ2lzdGVyIHZhbHVlcyBieQ0KPj4gYWRkaW5nIFNZ
U1JFR18qIG9wdGlvbnMgYW5kIHZhbHVlcyB0byB0aGUgY3B1IG1vZGVsIGV4cGFuc2lvbiBmb3Ig
dGhlDQo+PiBob3N0IG1vZGVsLCBpZiBhdmFpbGFibGUuDQo+PiANCj4+IEV4Y2VycHQ6DQo+PiAo
UUVNVSkgcXVlcnktY3B1LW1vZGVsLWV4cGFuc2lvbiB0eXBlPWZ1bGwgbW9kZWw9eyJuYW1lIjoi
aG9zdCJ9DQo+PiB7InJldHVybiI6IHsibW9kZWwiOiB7Im5hbWUiOiAiaG9zdCIsICJwcm9wcyI6
IHsiU1lTUkVHX0lEX0FBNjRQRlIwX0VMMV9FTDMiOiAxLA0KPj4gIlNZU1JFR19JRF9BQTY0SVNB
UjJfRUwxX0NMUkJIQiI6IDAsICJTWVNSRUdfQ1RSX0VMMF9MMUlwIjogMywNCj4+ICJTWVNSRUdf
TUlEUl9FTDFfUGFydE51bSI6IDM0MDcsICJTWVNSRUdfQ1RSX0VMMF9EbWluTGluZSI6IDQsDQo+
PiAiU1lTUkVHX0lEX0FBNjRNTUZSMF9FTDFfUEFSYW5nZSI6IDUsICJTWVNSRUdfSURfQUE2NE1N
RlIxX0VMMV9FQ0JIQiI6IDANCj4+IC4uLy4uDQo+PiANCj4+IFNvIHRoaXMgYWxsb3dzIHRoZSB1
cHBlciBzdGFjayB0byBkZXRlY3QgYXZhaWxhYmxlIHdyaXRhYmxlIElEDQo+PiByZWdzIGFuZCB0
aGUgImhvc3QgcGFzc3Rocm91Z2ggbW9kZWwiIHZhbHVlcy4NCj4+IA0KPj4gSXQgYWxzbyBhbGxv
d3MgdG8gdGVzdCBzb21lIElEIHJlZyBmaWVsZCB2YWx1ZXM6DQo+PiAoUUVNVSkgcXVlcnktY3B1
LW1vZGVsLWV4cGFuc2lvbiB0eXBlPWZ1bGwgbW9kZWw9eyJuYW1lIjoiaG9zdCIsInByb3BzIjp7
IlNZU1JFR19JRF9BQTY0SVNBUjBfRUwxX0RQIjoweDEzfX0NCj4+IHsiZXJyb3IiOiB7ImNsYXNz
IjogIkdlbmVyaWNFcnJvciIsICJkZXNjIjogImlkcmVnIFNZU1JFR19JRF9BQTY0SVNBUjBfRUwx
X0RQIHNldCB2YWx1ZSAoMHgxMykgZXhjZWVkcyBsZW5ndGggb2YgZmllbGQgKDQpISJ9fQ0KPj4g
DQo+PiAoUUVNVSkgcXVlcnktY3B1LW1vZGVsLWV4cGFuc2lvbiB0eXBlPWZ1bGwgbW9kZWw9eyJu
YW1lIjoiaG9zdCIsInByb3BzIjp7IlNZU1JFR19JRF9BQTY0SVNBUjBfRUwxX0RQIjoweDJ9fQ0K
Pj4geyJlcnJvciI6IHsiY2xhc3MiOiAiR2VuZXJpY0Vycm9yIiwgImRlc2MiOiAiaWRyZWcgU1lT
UkVHX0lEX0FBNjRJU0FSMF9FTDFfRFAgc2V0IHZhbHVlICgweDIpIGRvZXMgbm90IG1hdGNoIGFu
eSBhcmNoIHZhbGlkIGVudW0gdmFsdWUhIn19DQo+IA0KPiBmb3IgeW91ciBpbmZvIEkgYW0gY3Vy
cmVudGx5IGV4cGxvcmluZyB3YXlzIHRvIHRlc3Qgc2V0IGZpZWxkIHZhbHVlcw0KPiBhZ2FpbnN0
IEtWTS4gQ3VycmVudCBjaGVjayBvbmx5IHRlc3QgYWdhaW5zdCBmaWVsZCBzaXplIGFuZCBlbnVt
IHZhbHVlcw0KPiBpZiBhbnkuDQo+IA0KPiBJIGhhdmUgYSBQT0MgaW5zdGFudGlhdGluZyBhIHNj
cmF0Y2ggdmNwdSBhbmQgaXQgaXMgdG90YWxseSBmZWFzaWJsZSB0bw0KPiBzZXQgdGhlIGlkIHJl
ZyB3aXRoIHRoZSBtb2RpZmllZCB2YWx1ZS4gV2hhdCBpcyBtb3JlIHRyaWNreSBpcyB0byBidWls
ZA0KPiBhbiBpbmNyZW1lbnRhbCBzY3JhdGNoIHZjcHUgd2l0aCBhbGwgdGhlIHNldCB2YWx1ZXMg
YWNjdW11bGF0aW5nIEJ1dCBJDQo+IGd1ZXNzIGl0IHNob3VsZCBiZSBmZWFzaWJsZSB0b28uDQo+
IA0KPiBJZiB3ZSBtYW5hZ2UgdG8gZG8gdGhhdCwgSSBkb24ndCB0aGluayB5b3UgbmVlZCBzYWZl
IHJ1bGVzL3ZhbHVlcw0KPiBhbnltb3JlIGJlY2F1c2UgdXNpbmcgcXVlcnktY3B1LW1vZGVsLWV4
cGFuc2lvbiB5b3UgY291bGQgZGlyZWN0bHkgY2hlY2sNCj4gdGhlIGVuaGFuY2VkIGNwdSBtb2Rl
bCBjYW4gc2FmZWx5IGFwcGx5IG9uIGhvc3QuIEkgd2lsbCBzaGFyZSBhcyBzb29uIGFzDQo+IEkg
Z2V0IHNvbWV0aGluZyBjbGVhbiBlbm91Z2guIFRoYW5rcyBFcmljDQoNClRoaXMgc2VlbXMgbGlr
ZSBpdCBpcyBkZWZpbml0ZWx5IGRvYWJsZS4gQnV0LCBJIHRoaW5rIGl0IGlzIGluZWZmaWNpZW50
IGFuZCBkb2VzIG5vdA0Kc2NhbGUgd2l0aCB0aGUgbnVtYmVyIG9mIGNwdSBtb2RlbHMuDQoNCkl0
IHdpbGwgZXNzZW50aWFsbHkgcmVxdWlyZSAxICh2Y3B1IGNyZWF0ZSkgKyB4IChudW1iZXIgb2Yg
aWQgcmVnaXN0ZXIpIGlvY3RsIGNhbGxzDQpwZXIgTmFtZWQgQ1BVIG1vZGVsIG9yIGEgY29uZmln
dXJhdGlvbiB0aGF0IG1hbmFnZW1lbnQgc29mdHdhcmUgd2FudHMNCnRvIHRlc3QuDQoNCkluIHYz
LCBJIHdpbGwgIGNoYW5nZSBob3cgd2UgaGFuZGxlIHNhZmVfcnVsZXMuIEFzIHRoZSBhbmFseXNp
cyBpbiBtYWlsIHRvIE1hcmMNCmFsbW9zdCBhbGwgb2YgdGhlIHdyaXRlYWJsZSBJRCByZWdpc3Rl
ciBmaWVsZHMgc3VwcG9ydHMgd3JpdGluZyBhIGxvd2VyIHZhbHVlLg0KDQpUaGVyZSBhcmUgb25s
eSBmZXcgZXhjZXB0aW9ucy4NCg0KQW5vdGhlciBwb2ludCBJIHdhbnQgdG8gcmFpc2UgaXMgd2l0
aG91dCBzYWZlX3J1bGVzLCB3ZSB3aWxsIG5vdCBoYXZlDQpRTVAgZmVhdHVyZSBwYXJpdHkgd2l0
aCB4ODYgd2hlcmUgY3B1LWRlZmluaXRpb25zIHJlcG9ydHMgbW9kZWwNCmJsb2NrZXIgcHJvcGVy
dGllcy4gVGhpcyBpbi1wYXJpdHkgbWVhbnMgc29tZSBtYW5hZ2VtZW50DQpzb2Z0d2FyZSBjYW4g
bm90IGJlIGVhc2lseSBwb3J0ZWQgdG8gd29yayB3aXRoIGFybTY0IG5hbWVkDQpjcHUgbW9kZWxz
LiANCg0KV2FybSBSZWdhcmRzLA0KS2h1c2hpdA0KPiANCj4+IA0KPj4gU2lnbmVkLW9mZi1ieTog
RXJpYyBBdWdlciA8ZXJpYy5hdWdlckByZWRoYXQuY29tPg0KPj4gU2lnbmVkLW9mZi1ieTogQ29y
bmVsaWEgSHVjayA8Y29odWNrQHJlZGhhdC5jb20+DQo+PiANCj4+IC0tLQ0KPj4gDQo+PiB2NSAt
PiB2NjoNCj4+IC0gYWRkIHRoZSB3cml0ZSBjYXBhYmlsaXR5DQo+PiAtLS0NCj4+IHRhcmdldC9h
cm0vYXJtLXFtcC1jbWRzLmMgfCAyOSArKysrKysrKysrKysrKysrKysrKysrKysrKysrKw0KPj4g
MSBmaWxlIGNoYW5nZWQsIDI5IGluc2VydGlvbnMoKykNCj4+IA0KPj4gZGlmZiAtLWdpdCBhL3Rh
cmdldC9hcm0vYXJtLXFtcC1jbWRzLmMgYi90YXJnZXQvYXJtL2FybS1xbXAtY21kcy5jDQo+PiBp
bmRleCA4M2VjOTVjMjkwLi5lZGNmYzgyYTI1IDEwMDY0NA0KPj4gLS0tIGEvdGFyZ2V0L2FybS9h
cm0tcW1wLWNtZHMuYw0KPj4gKysrIGIvdGFyZ2V0L2FybS9hcm0tcW1wLWNtZHMuYw0KPj4gQEAg
LTIxLDYgKzIxLDcgQEANCj4+ICAqLw0KPj4gDQo+PiAjaW5jbHVkZSAicWVtdS9vc2RlcC5oIg0K
Pj4gKyNpbmNsdWRlICJxZW11L2Vycm9yLXJlcG9ydC5oIg0KPj4gI2luY2x1ZGUgInFlbXUvdGFy
Z2V0LWluZm8uaCINCj4+ICNpbmNsdWRlICJody9jb3JlL2JvYXJkcy5oIg0KPj4gI2luY2x1ZGUg
Imt2bV9hcm0uaCINCj4+IEBAIC04NCw2ICs4NSw4IEBAIENwdU1vZGVsRXhwYW5zaW9uSW5mbyAq
cW1wX3F1ZXJ5X2NwdV9tb2RlbF9leHBhbnNpb24oQ3B1TW9kZWxFeHBhbnNpb25UeXBlIHR5cGUs
DQo+PiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
IEVycm9yICoqZXJycCkNCj4+IHsNCj4+ICAgICBDcHVNb2RlbEV4cGFuc2lvbkluZm8gKmV4cGFu
c2lvbl9pbmZvOw0KPj4gKyAgICBPYmplY3RQcm9wZXJ0eUl0ZXJhdG9yIGl0ZXI7DQo+PiArICAg
IE9iamVjdFByb3BlcnR5ICppZHJlZ3Byb3A7DQo+PiAgICAgY29uc3QgUURpY3QgKnFkaWN0X2lu
Ow0KPj4gICAgIFFEaWN0ICpxZGljdF9vdXQ7DQo+PiAgICAgT2JqZWN0Q2xhc3MgKm9jOw0KPj4g
QEAgLTE0NSw2ICsxNDgsMjAgQEAgQ3B1TW9kZWxFeHBhbnNpb25JbmZvICpxbXBfcXVlcnlfY3B1
X21vZGVsX2V4cGFuc2lvbihDcHVNb2RlbEV4cGFuc2lvblR5cGUgdHlwZSwNCj4+ICAgICAgICAg
fQ0KPj4gDQo+PiAgICAgICAgIHFkaWN0X2luID0gcW9iamVjdF90byhRRGljdCwgbW9kZWwtPnBy
b3BzKTsNCj4+ICsNCj4+ICsgICAgICAgIG9iamVjdF9wcm9wZXJ0eV9pdGVyX2luaXQoJml0ZXIs
IG9iaik7DQo+PiArDQo+PiArICAgICAgICB3aGlsZSAoKGlkcmVncHJvcCA9IG9iamVjdF9wcm9w
ZXJ0eV9pdGVyX25leHQoJml0ZXIpKSkgew0KPj4gKyAgICAgICAgICAgIGlmICghZ19zdHJfaGFz
X3ByZWZpeChpZHJlZ3Byb3AtPm5hbWUsICJTWVNSRUdfIikpIHsNCj4+ICsgICAgICAgICAgICAg
ICAgY29udGludWU7DQo+PiArICAgICAgICAgICAgfQ0KPj4gKyAgICAgICAgICAgIGlmIChxZGlj
dF9nZXQocWRpY3RfaW4sIGlkcmVncHJvcC0+bmFtZSkpIHsNCj4+ICsgICAgICAgICAgICAgICAg
aWYgKCFvYmplY3RfcHJvcGVydHlfc2V0KG9iaiwgaWRyZWdwcm9wLT5uYW1lLCB2aXNpdG9yLCAm
ZXJyKSkgew0KPj4gKyAgICAgICAgICAgICAgICAgICAgYnJlYWs7DQo+PiArICAgICAgICAgICAg
ICAgIH0NCj4+ICsgICAgICAgICAgICB9DQo+PiArICAgICAgICB9DQo+PiArDQo+PiAgICAgICAg
IGkgPSAwOw0KPj4gICAgICAgICB3aGlsZSAoKG5hbWUgPSBjcHVfbW9kZWxfYWR2ZXJ0aXNlZF9m
ZWF0dXJlc1tpKytdKSAhPSBOVUxMKSB7DQo+PiAgICAgICAgICAgICBpZiAocWRpY3RfZ2V0KHFk
aWN0X2luLCBuYW1lKSkgew0KPj4gQEAgLTE5MCw2ICsyMDcsMTggQEAgQ3B1TW9kZWxFeHBhbnNp
b25JbmZvICpxbXBfcXVlcnlfY3B1X21vZGVsX2V4cGFuc2lvbihDcHVNb2RlbEV4cGFuc2lvblR5
cGUgdHlwZSwNCj4+ICAgICAgICAgfQ0KPj4gICAgIH0NCj4+IA0KPj4gKyAgICBvYmplY3RfcHJv
cGVydHlfaXRlcl9pbml0KCZpdGVyLCBvYmopOw0KPj4gKw0KPj4gKyAgICB3aGlsZSAoKGlkcmVn
cHJvcCA9IG9iamVjdF9wcm9wZXJ0eV9pdGVyX25leHQoJml0ZXIpKSkgew0KPj4gKyAgICAgICAg
UU9iamVjdCAqdmFsdWU7DQo+PiArDQo+PiArICAgICAgICBpZiAoIWdfc3RyX2hhc19wcmVmaXgo
aWRyZWdwcm9wLT5uYW1lLCAiU1lTUkVHXyIpKSB7DQo+PiArICAgICAgICAgICAgY29udGludWU7
DQo+PiArICAgICAgICB9DQo+PiArICAgICAgICB2YWx1ZSA9IG9iamVjdF9wcm9wZXJ0eV9nZXRf
cW9iamVjdChvYmosIGlkcmVncHJvcC0+bmFtZSwgJmVycm9yX2Fib3J0KTsNCj4+ICsgICAgICAg
IHFkaWN0X3B1dF9vYmoocWRpY3Rfb3V0LCBpZHJlZ3Byb3AtPm5hbWUsIHZhbHVlKTsNCj4+ICsg
ICAgfQ0KPj4gKw0KPj4gICAgIGlmICghcWRpY3Rfc2l6ZShxZGljdF9vdXQpKSB7DQo+PiAgICAg
ICAgIHFvYmplY3RfdW5yZWYocWRpY3Rfb3V0KTsNCj4+ICAgICB9IGVsc2Ugew0KDQoNCg==
