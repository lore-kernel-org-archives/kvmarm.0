Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 320973B8920
	for <kvmarm@lists.linux.dev>; Fri, 16 Oct 2026 06:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792133879; cv=fail; b=FB9JREOvXE234lJzxlnlL4DbG8r0q8IjGqEG6Ur7h7Pg/Al32tKh+t6QLCggq2JAJH1T40kQdmh+sFQ7wH242RX09DY3+zNBr68U3srJ2kvUGPIVfl/OtDJOxTDC+xWt/8RsxVUARg4G4vyPZBANmypdYwvFpyJMpc3/MFabUYA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792133879; c=relaxed/simple;
	bh=yAYLNODARPf3IW1HVPMZ7qvgU7vMNkpm8nI6hTWfMZQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=TVQo10mX+lAdsqCuuMwitKwN0XtqnEKeOdHmYUMm1IZmldf5a9+6BDKoEsgr368nqb1l7t4F7y96C28/5EvPtSItjr5sykaptkp6I6tqBPYoLyXmFDzBVH9UxY5sO0KJDh2sIdSm6shrnt+PNefeN2LpJ+UcratW7DzWWQUTQvc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=ETt18foS; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=W1hS7i1s; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="ETt18foS";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="W1hS7i1s"
Received: from pps.filterd (m0127843.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69FIFZWq3861826;
	Thu, 15 Oct 2026 23:57:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=yAYLNODARPf3IW1HVPMZ7qvgU7vMNkpm8nI6hTWfM
	ZQ=; b=ETt18foSj8MDe/juQN+Xn09DHjAcApfwb8B+kjYIDegF5EkzU/uVvjfJP
	gbNf4220fnLp6ejSv6MisZOXwYA6fgjPNwjApW8bNUfuKa9ApCZnp553PUALbllI
	nFFdFIPjZlCrA60Ce90OpdeKQ+/V1VEwNq9BC5gENK1FVYpqgJlzjRqKwsmTbMHN
	3Ze/W9ciTcCgpW9aTtNgvLuoNts+DAza+K09FfEUZRmwLLFu46md7iSMnLU75/zs
	wQRZUtT0yFfKliQH5ekBIogN7AXHTBEDHMxZ88Ojxuz4v9tJ3/5eUdN9HVH/ZCp4
	9s/aFzAFBeiAZjqxpsA80bPKh2SuA==
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11023084.outbound.protection.outlook.com [40.93.201.84])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4haukujr5n-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 15 Oct 2026 23:57:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XENeIpfY3RWK2tqhin1QNpaTok8bTtZgrICwzzUOhyhZO7QxOmuhiw8wTFi0GjP9HiyTzUX+v50QzO907ilTVwtePkbk7kGjhL1Mr4TUOozGrL/P8S0uBNL0D0Fr15iYWmpnN4rEzBxt5gTfoyrLgvKkP36N+gQpLeT3K1PO6MZLmb5Z3wH0gSQe9b/XByEBqd7F44duMeFIHjOLatlsvLu7hSEgxmlsiSjxxRDpaJ6f5sf3vnUEa1000RzRWNUqMx1W3qZLLJ0EYahe24tSY2pHTI4fQNjaRYkwwtlOJ4oGVXzXSlXdl4iPJzyFSXdsr2VldQ33ZyjgEAGwUsZEJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yAYLNODARPf3IW1HVPMZ7qvgU7vMNkpm8nI6hTWfMZQ=;
 b=RyXs/N8ih0Vt0DpN5FDKhp0wu4ZCqkdO19bcuEfp4bvlN4bGzr928NFk0qj1mcXyasrH5p4LQ01kHqaRNpRLFxffqfuHQ7mitNFPRbQQs8YRwQwetEEOhMfFIKCxtTxzs3XH0z2ZpUBJAvzXfYw83a6kfzZXSQBb4UobZWzmGNNos0jZjpLCjYSuGfgVN9yxj2jcy15L4K/OZD3pLgQQXuV913LLdZhDNYhoT3Ta3JG5thCxfFqJV+dQVJH6AVioYxPuiDk0Cbxa/4ssp+PeXjrgjWnczu+fWxbhsUKGr+7o6rzcafeFyj7tiqcP4Kbfo5p3mwJHwBT5bmx73yhrLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yAYLNODARPf3IW1HVPMZ7qvgU7vMNkpm8nI6hTWfMZQ=;
 b=W1hS7i1sOfB7F6CYXZZfK5zgAKSlJ0sSF33EZo6UxFLhPwppF8CfeISxW3SMQzL+E5lXEEqKUT+BVOQBnXHC8gCovDba1yO5k+RIjuN3fY8xwxFmKLSrIpOQzbeheNODu2caUA0fzpQw1PtXzmSk5UI+NoPzHadATbRPNdtxsM0NvqFUiBjb77fceFeucqArF0wgPpzft3WY4M6W88oqbFu0qE1/UVknVZ2FKZY2Kg5Fg43PnD/nesMu/yIyuRwTG6le1oSTj9HuV7PqLg7x7oLQ8fCWz43R5bJD6zcHAJpOIbEwjeBcgrxmDQB+jtTy3ht4VUyNJHRuVMAfhZlWWw==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by DS0PR02MB8997.namprd02.prod.outlook.com (2603:10b6:8:c9::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.15; Fri, 16 Oct
 2026 06:57:22 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%5]) with mapi id 15.21.0522.013; Fri, 16 Oct 2026
 06:57:22 +0000
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
Subject: Re: [RFC PATCH v4 23/25] qmp: add query-cpu-props-info command
Thread-Topic: [RFC PATCH v4 23/25] qmp: add query-cpu-props-info command
Thread-Index: AQHdScVuCsCn7BcrT0iSyROZkWWAg7b+zTCAgAEWaAA=
Date: Fri, 16 Oct 2026 06:57:22 +0000
Message-ID: <95CBB54C-21CB-4594-8EA4-9C596ADB65EE@nutanix.com>
References: <20260921123249.1708067-1-khushit.shah@nutanix.com>
 <20260921123249.1708067-24-khushit.shah@nutanix.com>
 <543a8f0a-bd66-4c13-8117-07f069a754d8@redhat.com>
In-Reply-To: <543a8f0a-bd66-4c13-8117-07f069a754d8@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nutanix.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA2PR02MB7564:EE_|DS0PR02MB8997:EE_
x-ms-office365-filtering-correlation-id: 853330de-4f51-4650-fe34-08df2b52ba86
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|7416014|376014|1800799024|23010399003|6133799003|10067099003|22082099003|18002099003|260925022911599003|3023799007|4143699003|260925021911599003|260925021311599003|261009223027099003|56012099006|38070700021;
x-microsoft-antispam-message-info:
 1xsfGEF/uxSyEbvt1X98pVzUbeR5dVaIe+xvZXCZ0TLNjf6jd3NDVNBGX3ftOIDCcp6BFyqRI4tRUHWQt3vqv2zGTdp9LcnBBv/JxRtWl9p0oir427e5cOkHFMhbQXsXSYc5Z4dzcBLWZes/C6xTdln7LmIKmgKVDwq6Fw/m2h0tqOQAIRsBlUzuqBqdJXjUFLea+rCxXGc6xkSUNY7ydq87r1CqepzdlzyMetTnXkZoh21ATw1S+0i2cPLiM1kmn9nFRmGAPe3krPnaHHnulY14y8dVX6f7vhFoxJtMErO7WIlRYHELJJnZAc5ruv4Z2St48HugVk6BcxN87nAxo3RpDL1BDCl57MX/7rgJxvIXngYomcXQLvz3zCeKDMeluaXRcDEP9PJERi5CZQb0BqoN3q8RFv15Fy8jYbJ5al2g3bT7xxrBj1Yi1uBQXgo0I+etOtay2f9duddSZcz21lGDejYefSIwAL3T5bEUXBIvFr9WiJDqFVSOWKi2LHt5RA0CifNiU2Su8z2Tmcp4M6b9miboMSiHHB/VjTeRmqsubMmN3rUfSrL22WV9Joxyg9dNcfj5mJReJMkAeEj/LECdG0hMUx+qi3kh5OprQVE3vCifNj36FNugT+AZld3nADhlFutzCz8dNBYyZe8lnnqpfV+KaQSA7zhW3IkjEKNLgh7fa1fxx7zrVe93XzD0Ip2ZeTuo9UNGigU2WpUhqO/LAoS135NsgHGIt7vWBGE=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(23010399003)(6133799003)(10067099003)(22082099003)(18002099003)(260925022911599003)(3023799007)(4143699003)(260925021911599003)(260925021311599003)(261009223027099003)(56012099006)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?Ni9GUW5FSGY0R2tWSlBYWTdVWUdrczJTanNUeFluWUdwSkFaZ2VDQ3dTYlc0?=
 =?utf-8?B?SExJeTlXRkk0OUpsbnhrU0JKdW51dXlZc2MxcEZISlR3OTVnaDNiNldKM1lV?=
 =?utf-8?B?LzlpZlRjNVhYc0d3bHJBd2RFekMyTDIwMmZKYjZjck1aMVRrY1RwVkhwYTNK?=
 =?utf-8?B?UGhtYy90OS9xaVJLQWdvQ0pMK3M4b29GZ2d3MUZscWRBT0I4MmVPMS9SVy9X?=
 =?utf-8?B?WGZYSXVkdEUvYzRSUlNpZmFneDlGRDhGem12R1lKaXdudTMzTzd1ZFpOYkpS?=
 =?utf-8?B?SkRZRlRGRVNQa05MN1FCdGdHanFmdmdaZFhlVWhrY0t3Vy96d3orYXFPQ1p5?=
 =?utf-8?B?YnNwVEx4VkJITFBUOW1Gekk2UWxOMkxIaXhLZ2hTSFY3bmpaSVlkZE1MazZq?=
 =?utf-8?B?ODZxazlZb3dEdTFTY3RiVkVDN1dRTEpsemVsaU5iRVgyYnR4RzVzbngxVk9y?=
 =?utf-8?B?WS9ZNG9wVmJGcVNmR1Y4UXNuaXc2am1wT2I1OHlrMlVXNjNzVGFBbEhLOHcx?=
 =?utf-8?B?cXc1R2ZIV2ZMSCtqM1hWMnVEU2U5eHA5NjZaeW1icWFwRERSbWdXZzV4VXhU?=
 =?utf-8?B?aXkrbEJCVHJPRVRSMytzRmV0MjZ2VE9oSHErQjFSZXF0WnJCMEpoZE1PS3hB?=
 =?utf-8?B?akZpVnZWU0tkVlVWNG5NNzZrUFF5aGZocEtPTDUvenZ0WldjK0JEM2RKc0dw?=
 =?utf-8?B?ZHVaNXFwdjA3akdYeTE2UzFZa0REVmwzVHlDb1FKWG9CSlFKOG9kZTY2WDhv?=
 =?utf-8?B?Y3VsMVBINGlLY2wrNy9UQ0NPd1JpRHJVcWE1NDdyQmpvbVhZY2M3RzFXdCti?=
 =?utf-8?B?T0Q0YXdhRUdyU0F5MzA2L2xZZmpKN1FaNU8xZFJtckpCcVA2Yi9CTFpmTnRW?=
 =?utf-8?B?V3NhaXc2b0RLUjlUNmlHNVQyNkRkOXF5NFJESVZBQjBXUlZQMkV4NWd3cm9r?=
 =?utf-8?B?YjBLNGJFaW9LVmZvRUFnREFVQldROXd0KzErV1JEdVQwbzZIa1hrMTJ0bG1M?=
 =?utf-8?B?M0l1TlRwWUZNTXJiYVVONEQ5K29ESTAvZWZNNkh6S0x2V3gxUU4xRXBESTFQ?=
 =?utf-8?B?SDAxL0dVN2Jwbkpka2hPSG9nSDVTcVBOZDhJV3BnNjhSc3lJaXZNZ0Q0OXZP?=
 =?utf-8?B?RCswL0FLTGJCZUZrUWZvZ3N2SVpCMDA2VlRtNXJjQ1ZDb29abWhNQ1pObUFP?=
 =?utf-8?B?RG0yTzFVNUIzcWhKcE92RmQvUjFaeW5jeVpLRlVRT3RSZTR3Ynp6dFViTTBv?=
 =?utf-8?B?MTNpMUZMdDdKdzlGdVBmMzZMTHQ2T1lPcHBFU2VYY01BSGtQS01iMGU1UDJI?=
 =?utf-8?B?Q1dPcGlUSzhwcE52eVMyZytZc013YmdudTNsQmFhQ1pMMit5UUhpdzFhdWF1?=
 =?utf-8?B?ZWsyaDNyL3NENVRsaUM3VEhaQ29QTStTdW1UWHBNcXczL3JXRXVTcFkvTjFC?=
 =?utf-8?B?SzM5VzArTFROdzZ2ZmFKRDBxQW42UkN2VzI5NWhpWU04dldiRUVidVhocWZR?=
 =?utf-8?B?dWhpeUIrR0NzamxiMVprOVQ0YjJEaFRidHZXWGxuVkZ2UjJxL3NqM3NkV0dp?=
 =?utf-8?B?eThKMHo5S3BFalZQKzM5d3grOS9yRTZ4aWRzQmJabE40WEV1YmhGMSt0MEdH?=
 =?utf-8?B?ZzJQbFNXSG5HUjUwWU1SSjhoK3VnbHhwc29MMVpBUy9xRUpRSUtSOHlCOXJs?=
 =?utf-8?B?RktsK0gvTXd3M3lQOXU2b2ZZYTVjckxBdnd2TS9LeDBoYXNxdC9SM0VBMUNn?=
 =?utf-8?B?NGJ2UCtyek5XRklIRk1WckE5M0p6ZXkyeitmTmFrVU41TUNoMmVaNG1lYVdQ?=
 =?utf-8?B?c1dZZ0ZTRTQ0Q25EdGhmdzFlUldQbjBUSnZpYjIwN29acWluTDF5UG5LelZk?=
 =?utf-8?B?ejBmSzdoWEpvMzhaTkpyQ2l5L0hVcStzRG9YSEdLVzRtOU9vNE1RSnozcDM2?=
 =?utf-8?B?Q0Z6RnFiU1FNSFBSNzF3aDVSVzlRcUZ6SFUxdjFkc2FNcW1nc3dvQTRLRmdv?=
 =?utf-8?B?NkhGU201SUkwM3hRd0JVbzh0SFNvdzRkOWRIcGVpc1dPbE5MWTlyUXNvMUdV?=
 =?utf-8?B?R0lnRjRlM2ozUTNXNURLL29adGZrVmc5WitVWlZaM3BjcFk1bHZFYk84alVh?=
 =?utf-8?B?NEx3K29JbUVoMUZFREpFRTh0RHA0MDRqY3h1emwzbmNLVkozaGIrYWIxbE1M?=
 =?utf-8?B?RlFqRE5qRXFsUDdaWHBHRStBeSt3SlJaSlFpQ0g1azlzY2VDOExvbDdKQzF0?=
 =?utf-8?B?QlM3TmZvNDlDVDRKUU04OTBOWWF4dDBXWkFRQ0FYTGRVbEkwUCtMSjdoSHFj?=
 =?utf-8?B?RjRqY3pyaXQwL0NVMzY3MTE2NnBwbTVjNS9KL2htQ0hQbU9MSzZ1NnhJKy9s?=
 =?utf-8?Q?d6K5XXO5rsx2t8Fk=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <76023FA26346884EA864BEDD58AD3DC1@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	41B+zCsSanQqRMZjm4ZhKxZMeVmXfDkyo++U0a8f1MGjViObaeW7paO3b7cNhTwqFh+tMKED5ouqMH5gncvd36zGGcT4rHkhvsDal7V2hMxLwP/psKIBnSEb8GT3igCD6SGLuBZ+eSLExHpJ+w36mr/YHz+8EAdXVTrJiRZc4nEogmfoq3ZgOf+s1NQ1nFvzM6TdWXAUy2rScS0BDblcpXcYlTRu5ddg6pwDt8l1vTc1KblwLABb1v6t8p6pd4G8Fy9p96EnyeqcV0pa11lrTe+wg5cHaWe0KChj4Wt0NVaKq3n0sH9k7HgC9Tye6OvKMms/Ve4bQkFw7sRtbmBNvw==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 853330de-4f51-4650-fe34-08df2b52ba86
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Oct 2026 06:57:22.6016
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nKokIqMLmFhyZc1n+YW+5ZyMahOlLIg+FSQuZ1KfiahByGtK1RIKMKNs85kTvgpg2pJh4T6trnNMPFPQVi3We15f8UALy0Dz67hBDmnIUbw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR02MB8997
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE2MDAyNyBTYWx0ZWRfX+JG0OKbwDeU3
 FoMSwo2h7zdcZHH8UtDAUcXgY/c7n5vAFghiyTSgtU2uxlOilMjCZV/OpfAdkTnDoB7TvoQVfVW
 xBG9PbleuBgJdlA+kJPvCBqdcsestio=
X-Authority-Analysis: v=2.4 cv=G+OJgNk5 c=1 sm=1 tr=0 ts=6ad1cad6 cx=c_pps
 a=vrZu8FCDnvlauzLDEj0iEg==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=660iZSQnnn4A:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VofLwUrZ8Iiv6rRUPXIb:22 a=dEe9Ve2bX-KnNSUMM2s9:22 a=20KFwNOVAAAA:8
 a=64Cc0HZtAAAA:8 a=9xiG3EmSjtJhQA_feq4A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: 0pYmXlPI3sDwUjL-7uJA4ZlVvprw1VCI
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE2MDAyNyBTYWx0ZWRfX4Ss64jgikDb9
 bhVp7Fl0/vRrxelkWaMiQhfmLCjoA9amIlVw9oGZvTTrEwWGzod3UN9+Pd8+Ua1VJXPZG6VLn1S
 OnacjEwLLSqbxYd/M912yROAKz6NaLd8NtqJrIDUmy4Bo7QzlAUJ/6R4pTv0G1atUv//PrB46G6
 IFl87/ZCf/lUHdgcH9psici32zyv44tiZg3lzGDCgvwkuSLDgMghFSV4bbyBGk8G3tYSCfgBymj
 g2gzR0sb3h3pLmPgnrCJoNIIAzevfqMNi7tY31YyeHrtFlp6wVJkQnDVG4uhwewG0fYE90RFLNy
 wL/yRz9EBtav7uqCvyfegg8+gl0ZEmpHhPc6YrZXwv4wTcCcFSCAznWLnMuSMjZmVA9OU3ldjdm
 dsGmJ5+keM5naeQorXDVqTsV3MJCeuYi1//pTrTY2RNzsURywKR3jhBQw2vChBfjBTI7IuSJ0XZ
 L6U48DmRnD59HfCdTEA==
X-Proofpoint-ORIG-GUID: 0pYmXlPI3sDwUjL-7uJA4ZlVvprw1VCI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-14_01,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gMTUgT2N0IDIwMjYsIGF0IDc6NTDigK9QTSwgRXJpYyBBdWdlciA8ZXJpYy5hdWdl
ckByZWRoYXQuY29tPiB3cm90ZToNCj4gDQo+ICEtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tfA0KPiAgQ0FVVElPTjogRXh0
ZXJuYWwgRW1haWwNCj4gDQo+IHwtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tIQ0KPiANCj4gDQo+IA0KPiBPbiA5LzIxLzI2
IDI6MzIgUE0sIEtodXNoaXQgU2hhaCB3cm90ZToNCj4+IEludHJvZHVjZSB0aGUgJ3F1ZXJ5LWNw
dS1wcm9wcy1pbmZvJyBRTVAgY29tbWFuZC4gRm9yIGVhY2ggQ1BVIG1vZGVsDQo+PiBwcm9wZXJ0
eSwgaXQgcmVwb3J0cyB0aGUgdHlwZSAoYm9vbGVhbiBvciBudW1iZXIpIGFuZCB0aGUgc2V0IG9m
IHZhbHVlcw0KPj4gc3VwcG9ydGVkIHVuZGVyIHRoZSBhY3RpdmUgYWNjZWxlcmF0b3IgYW5kIGhv
c3QuDQo+PiANCj4+IFRoaXMgaGVscHMgdGhlIG1hbmFnZW1lbnQgc3RhY2sgdG8gZGlzY292ZXIg
d2hpY2ggdmFsdWVzIGFyZSBzdXBwb3J0ZWQNCj4+IGZvciBhIGdpdmVuIENQVSBwcm9wZXJ0eS4g
VGhpcyBpcyBlc3BlY2lhbGx5IGltcG9ydGFudCBmb3Igbm9uLWJvb2xlYW4NCj4+IHByb3BlcnRp
ZXMsIHdoZXJlIGtub3dpbmcgdGhhdCB0aGUgaG9zdCBoYXMgdmFsdWUgJ3gnIGRvZXMgbm90DQo+
PiBpbmhlcmVudGx5IHJldmVhbCB0aGUgZnVsbCByYW5nZSBvZiB2YWxpZCB2YWx1ZXMgc3VwcG9y
dGVkIG9uIHRoZSBob3N0Lg0KPj4gRm9yIGV4YW1wbGUsIGFuIEFybSBob3N0IHdpdGggQ1RSX0VM
MC5MMUlwPTMgKFBJUFQpIGFsc28gYWxsb3dzIDINCj4+IChWSVBUKSBidXQgYSBob3N0IHdpdGgg
Q1RSX0VMMC5MMUlwPTIgZG9lcyBub3QgYWxsb3cgQ1RSX0VMMC5MMUlwPTMNCj4+IGZvciBhIGd1
ZXN0Lg0KPj4gDQo+PiBGb3IgbnVtZXJpY2FsIHByb3BlcnRpZXMsIHRoZSBzdXBwb3J0ZWQgdmFs
dWVzIGFyZSBleHByZXNzZWQgYXMgYSBsaXN0DQo+PiBvZiBpbmNsdXNpdmUge21pbiwgbWF4fSBy
YW5nZXMuIEZvciBib29sZWFuIHByb3BlcnRpZXMsIHRoZXkgYXJlDQo+PiByZXByZXNlbnRlZCBh
cyBhIGxpc3Qgb2YgdHJ1ZS9mYWxzZSB2YWx1ZXMuDQo+PiANCj4+IFRoZSBjb21tYW5kIGFuZCBp
dHMgcmV0dXJuIHR5cGVzIChDcHVQcm9wZXJ0eVR5cGUsIENwdVByb3BlcnR5SW5mbyBhbmQNCj4+
IGZyaWVuZHMpIGFyZSBkZWZpbmVkIGluIHFhcGkvbWFjaGluZS5qc29uIHJhdGhlciB0aGFuIGFu
IEFybS1zcGVjaWZpYw0KPj4gc2NoZW1hLCBzaW5jZSB0aGUgY29uY2VwdCBhcHBsaWVzIHRvIG90
aGVyIHRhcmdldHMgKGUuZy4geDg2LCBSSVNDLVYpDQo+PiB0b28uIFRhcmdldHMgdGhhdCBkbyBu
b3QgaW1wbGVtZW50IGl0IHJldHVybiBhbiBlcnJvci4NCj4+IChUaGUgZm9sbG93aW5nIGNvbW1p
dCBpbXBsZW1lbnRzIHRoZSBjb21tYW5kIGZvciBBcm0gS1ZNLikNCj4+IA0KPj4gU2lnbmVkLW9m
Zi1ieTogS2h1c2hpdCBTaGFoIDxraHVzaGl0LnNoYWhAbnV0YW5peC5jb20+DQo+PiAtLS0NCj4+
IHFhcGkvbWFjaGluZS5qc29uICAgICAgICAgIHwgODIgKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysNCj4+IHN0dWJzL21lc29uLmJ1aWxkICAgICAgICAgIHwgIDEgKw0KPj4g
c3R1YnMvcW1wLWNwdS1wcm9wcy1pbmZvLmMgfCAxMiArKysrKysNCj4+IHRlc3RzL3F0ZXN0L3Ft
cC1jbWQtdGVzdC5jIHwgIDEgKw0KPj4gNCBmaWxlcyBjaGFuZ2VkLCA5NiBpbnNlcnRpb25zKCsp
DQo+PiBjcmVhdGUgbW9kZSAxMDA2NDQgc3R1YnMvcW1wLWNwdS1wcm9wcy1pbmZvLmMNCj4+IA0K
Pj4gZGlmZiAtLWdpdCBhL3FhcGkvbWFjaGluZS5qc29uIGIvcWFwaS9tYWNoaW5lLmpzb24NCj4+
IGluZGV4IDJkNjNjMWJhYzMuLjZlNjViZGFkODYgMTAwNjQ0DQo+PiAtLS0gYS9xYXBpL21hY2hp
bmUuanNvbg0KPj4gKysrIGIvcWFwaS9tYWNoaW5lLmpzb24NCj4+IEBAIC0yMjkxLDMgKzIyOTEs
ODUgQEANCj4+ICMgU2luY2U6IDEuMg0KPj4gIyMNCj4+IHsgJ2NvbW1hbmQnOiAncXVlcnktY3B1
LWRlZmluaXRpb25zJywgJ3JldHVybnMnOiBbJ0NwdURlZmluaXRpb25JbmZvJ10gfQ0KPj4gKw0K
Pj4gKyMjDQo+PiArIyBAQ3B1UHJvcGVydHlUeXBlOg0KPj4gKyMNCj4+ICsjIFRoZSB0eXBlIG9m
IGEgQ1BVIG1vZGVsIHByb3BlcnR5Lg0KPj4gKyMNCj4+ICsjIEBib29sZWFuOiB0aGUgcHJvcGVy
dHkgaXMgb2YgdHlwZSBib29sZWFuLg0KPj4gKyMNCj4+ICsjIEBudW1iZXI6IHRoZSBwcm9wZXJ0
eSBpcyBvZiB0eXBlIHVuc2lnbmVkIGludGVnZXIuDQo+PiArIw0KPj4gKyMgU2luY2U6IDExLjIN
Cj4+ICsjIw0KPj4gK3sgJ2VudW0nOiAnQ3B1UHJvcGVydHlUeXBlJywNCj4+ICsgICdkYXRhJzog
WyAnYm9vbGVhbicsICdudW1iZXInIF0gfQ0KPiB3aHkgZG8gd2Ugc3RpbGwgbmVlZCB0aGUgYm9v
bGVhbiB0eXBlPyBDYW4ndCB3ZSBzaW1wbGlmeSBhbmQgc3RpY2sgdG8NCj4gdWludDY0X3QgZm9y
IGFsbCBTWVNSRUcgcHJvcHM/DQpIaSBFcmljLA0KDQpCb29scyB0byBzdXBwb3J0IGV4aXN0aW5n
IHByb3BlcnRpZXMgKHN2ZSwgcGF1dGgsIGV0Y+KApikgYXJlIGJvb2xlYW5zLg0KPj4gKw0KPj4g
KyMjDQo+PiArIyBAQ3B1UHJvcGVydHlWYWx1ZVJhbmdlOg0KPj4gKyMNCj4+ICsjIEFuIGluY2x1
c2l2ZSByYW5nZSBvZiBudW1lcmljIHZhbHVlcyBzdXBwb3J0ZWQgZm9yIHRoZSBwcm9wZXJ0eS4N
Cj4+ICsjDQo+PiArIyBAbWluOiB0aGUgbG93ZXN0IHN1cHBvcnRlZCB2YWx1ZS4NCj4+ICsjDQo+
PiArIyBAbWF4OiB0aGUgaGlnaGVzdCBzdXBwb3J0ZWQgdmFsdWUuDQo+PiArIw0KPj4gKyMgU2lu
Y2U6IDExLjINCj4+ICsjIw0KPj4gK3sgJ3N0cnVjdCc6ICdDcHVQcm9wZXJ0eVZhbHVlUmFuZ2Un
LA0KPj4gKyAgJ2RhdGEnOiB7ICdtaW4nOiAndWludDY0JywgJ21heCc6ICd1aW50NjQnIH0gfQ0K
Pj4gKw0KPj4gKyMjDQo+PiArIyBAQ3B1UHJvcGVydHlJbmZvQm9vbGVhbjoNCj4+ICsjDQo+PiAr
IyBAc3VwcG9ydGVkLXZhbHVlczogbGlzdCBvZiBib29sZWFuIHZhbHVlcyBzdXBwb3J0ZWQgZm9y
IHRoZQ0KPj4gKyMgICAgIHByb3BlcnR5Lg0KPj4gKyMNCj4+ICsjIFNpbmNlOiAxMS4yDQo+PiAr
IyMNCj4+ICt7ICdzdHJ1Y3QnOiAnQ3B1UHJvcGVydHlJbmZvQm9vbGVhbicsDQo+PiArICAnZGF0
YSc6IHsgJ3N1cHBvcnRlZC12YWx1ZXMnOiBbJ2Jvb2wnXSB9IH0NCj4gd2h5IGNhbid0IHlvdSBt
b2RlbCB0aGF0IHdpdGggYSByYW5nZSB0b28/DQpJ4oCZbSBzb3JyeSBJIGRpZG7igJl0IGdldCB5
b3UuDQoNClRoYW5rcywNCktodXNoaXQNCj4+ICsNCj4+ICsjIw0KPj4gKyMgQENwdVByb3BlcnR5
SW5mb051bWJlcjoNCj4+ICsjDQo+PiArIyBAc3VwcG9ydGVkLXZhbHVlczogbGlzdCBvZiBudW1l
cmljIHZhbHVlIHJhbmdlcyBzdXBwb3J0ZWQNCj4+ICsjICAgICBmb3IgdGhlIHByb3BlcnR5Lg0K
Pj4gKyMNCj4+ICsjIFNpbmNlOiAxMS4yDQo+PiArIyMNCj4+ICt7ICdzdHJ1Y3QnOiAnQ3B1UHJv
cGVydHlJbmZvTnVtYmVyJywNCj4+ICsgICdkYXRhJzogeyAnc3VwcG9ydGVkLXZhbHVlcyc6IFsn
Q3B1UHJvcGVydHlWYWx1ZVJhbmdlJ10gfSB9DQo+PiArDQo+PiArIyMNCj4+ICsjIEBDcHVQcm9w
ZXJ0eUluZm86DQo+PiArIw0KPj4gKyMgSW5mb3JtYXRpb24gYWJvdXQgYSBzaW5nbGUgQ1BVIG1v
ZGVsIHByb3BlcnR5LCBpbmNsdWRpbmcgdGhlIHZhbHVlcw0KPj4gKyMgdGhlIGhvc3QvYWNjZWxl
cmF0b3Igc3VwcG9ydHMgZm9yIGl0Lg0KPj4gKyMNCj4+ICsjIEBuYW1lOiB0aGUgbmFtZSBvZiB0
aGUgcHJvcGVydHkuDQo+PiArIw0KPj4gKyMgQHR5cGU6IHRoZSB0eXBlIG9mIHRoZSBwcm9wZXJ0
eSwgd2hpY2ggc2VsZWN0cyB0aGUgbGF5b3V0IG9mDQo+PiArIyAgICAgQHN1cHBvcnRlZC12YWx1
ZXMuDQo+PiArIw0KPj4gKyMgU2luY2U6IDExLjINCj4+ICsjIw0KPj4gK3sgJ3VuaW9uJzogJ0Nw
dVByb3BlcnR5SW5mbycsDQo+PiArICAnYmFzZSc6IHsgJ25hbWUnOiAnc3RyJywNCj4+ICsgICAg
ICAgICAgICAndHlwZSc6ICdDcHVQcm9wZXJ0eVR5cGUnIH0sDQo+PiArICAnZGlzY3JpbWluYXRv
cic6ICd0eXBlJywNCj4+ICsgICdkYXRhJzogeyAnYm9vbGVhbic6ICdDcHVQcm9wZXJ0eUluZm9C
b29sZWFuJywNCj4+ICsgICAgICAgICAgICAnbnVtYmVyJzogJ0NwdVByb3BlcnR5SW5mb051bWJl
cicgfSB9DQo+PiArDQo+PiArIyMNCj4+ICsjIEBxdWVyeS1jcHUtcHJvcHMtaW5mbzoNCj4+ICsj
DQo+PiArIyBSZXR1cm4gaW5mb3JtYXRpb24gYWJvdXQgdGhlIENQVSBtb2RlbCBwcm9wZXJ0aWVz
LiAgRm9yIGVhY2gNCj4+ICsjIHByb3BlcnR5IGl0IHJlcG9ydHMgdGhlIHZhbHVlcyBzdXBwb3J0
ZWQgdW5kZXIgdGhlIGFjdGl2ZQ0KPj4gKyMgYWNjZWxlcmF0b3IgYW5kIGhvc3QuDQo+PiArIw0K
Pj4gKyMgU2luY2U6IDExLjINCj4+ICsjIw0KPj4gK3sgJ2NvbW1hbmQnOiAncXVlcnktY3B1LXBy
b3BzLWluZm8nLA0KPj4gKyAgJ3JldHVybnMnOiBbJ0NwdVByb3BlcnR5SW5mbyddIH0NCj4+IGRp
ZmYgLS1naXQgYS9zdHVicy9tZXNvbi5idWlsZCBiL3N0dWJzL21lc29uLmJ1aWxkDQo+PiBpbmRl
eCAzYjJmMjY4MGIxLi4zYmI0MDI4YmFiIDEwMDY0NA0KPj4gLS0tIGEvc3R1YnMvbWVzb24uYnVp
bGQNCj4+ICsrKyBiL3N0dWJzL21lc29uLmJ1aWxkDQo+PiBAQCAtODMsNiArODMsNyBAQCBpZiBo
YXZlX3N5c3RlbQ0KPj4gICBzdHViX3NzLmFkZChmaWxlcygncW1wLWkzODYtc2d4LmMnKSkNCj4+
ICAgc3R1Yl9zcy5hZGQoZmlsZXMoJ3FtcC1pMzg2LXhlbi5jJykpDQo+PiAgIHN0dWJfc3MuYWRk
KGZpbGVzKCdxbXAtY3B1LmMnKSkNCj4+ICsgIHN0dWJfc3MuYWRkKGZpbGVzKCdxbXAtY3B1LXBy
b3BzLWluZm8uYycpKQ0KPj4gICBzdHViX3NzLmFkZChmaWxlcygncW1wLWNwdS1zMzkweC5jJykp
DQo+PiAgIHN0dWJfc3MuYWRkKGZpbGVzKCdxbXAtY3B1LXMzOTB4LWt2bS5jJykpDQo+PiAgIHN0
dWJfc3MuYWRkKGZpbGVzKCdobXAtY21kLWluZm9fbWVtLmMnKSkNCj4+IGRpZmYgLS1naXQgYS9z
dHVicy9xbXAtY3B1LXByb3BzLWluZm8uYyBiL3N0dWJzL3FtcC1jcHUtcHJvcHMtaW5mby5jDQo+
PiBuZXcgZmlsZSBtb2RlIDEwMDY0NA0KPj4gaW5kZXggMDAwMDAwMDAwMC4uMzZiMDUzMGI5OA0K
Pj4gLS0tIC9kZXYvbnVsbA0KPj4gKysrIGIvc3R1YnMvcW1wLWNwdS1wcm9wcy1pbmZvLmMNCj4+
IEBAIC0wLDAgKzEsMTIgQEANCj4+ICsvKiBTUERYLUxpY2Vuc2UtSWRlbnRpZmllcjogR1BMLTIu
MC1vci1sYXRlciAqLw0KPj4gKw0KPj4gKyNpbmNsdWRlICJxZW11L29zZGVwLmgiDQo+PiArI2lu
Y2x1ZGUgInFhcGkvZXJyb3IuaCINCj4+ICsjaW5jbHVkZSAicWFwaS9xYXBpLWNvbW1hbmRzLW1h
Y2hpbmUuaCINCj4+ICsNCj4+ICtDcHVQcm9wZXJ0eUluZm9MaXN0ICoNCj4+ICtxbXBfcXVlcnlf
Y3B1X3Byb3BzX2luZm8oRXJyb3IgKiplcnJwKQ0KPj4gK3sNCj4+ICsgICAgZXJyb3Jfc2V0Zyhl
cnJwLCAicXVlcnktY3B1LXByb3BzLWluZm8gbm90IHN1cHBvcnRlZCBvbiB0aGlzIHRhcmdldCIp
Ow0KPj4gKyAgICByZXR1cm4gTlVMTDsNCj4+ICt9DQo+PiBkaWZmIC0tZ2l0IGEvdGVzdHMvcXRl
c3QvcW1wLWNtZC10ZXN0LmMgYi90ZXN0cy9xdGVzdC9xbXAtY21kLXRlc3QuYw0KPj4gaW5kZXgg
Mjc5YThmNTYxNC4uMmMyNWRiZDhjYiAxMDA2NDQNCj4+IC0tLSBhL3Rlc3RzL3F0ZXN0L3FtcC1j
bWQtdGVzdC5jDQo+PiArKysgYi90ZXN0cy9xdGVzdC9xbXAtY21kLXRlc3QuYw0KPj4gQEAgLTEw
MCw2ICsxMDAsNyBAQCBzdGF0aWMgYm9vbCBxdWVyeV9pc19pZ25vcmVkKGNvbnN0IGNoYXIgKmNt
ZCkNCj4+ICAgICAgICAgImFkZC1mZCIsDQo+PiAgICAgICAgIC8qIFN1Y2Nlc3MgZGVwZW5kcyBv
biB0YXJnZXQgYXJjaDogKi8NCj4+ICAgICAgICAgInF1ZXJ5LWNwdS1kZWZpbml0aW9ucyIsICAv
KiBhcm0sIGkzODYsIHBwYywgczM5MHggKi8NCj4+ICsgICAgICAgICJxdWVyeS1jcHUtcHJvcHMt
aW5mbyIsIC8qIGFybSArIGt2bSAqLw0KPj4gICAgICAgICAicXVlcnktZ2ljLWNhcGFiaWxpdGll
cyIsIC8qIGFybSAqLw0KPj4gICAgICAgICAicXVlcnktczM5MHgtY3B1LXBvbGFyaXphdGlvbiIs
IC8qIHMzOTB4ICovDQo+PiAgICAgICAgIC8qIFN1Y2Nlc3MgZGVwZW5kcyBvbiB0YXJnZXQtc3Bl
Y2lmaWMgYnVpbGQgY29uZmlndXJhdGlvbjogKi8NCj4gVGhhbmtzDQo+IA0KPiBFcmljDQoNCg0K
