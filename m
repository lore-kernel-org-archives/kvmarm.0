Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00E783E00B3
	for <kvmarm@lists.linux.dev>; Wed,  5 Aug 2026 06:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785912501; cv=fail; b=J7mnXTaj27nKYz9q/wMviLDBhua+an3LnbSJFxUJWECkOW2uUaDhGk62RjqH1MhxIi8sYRYDna/LYmxozBsqYLEp8cueuXs6+yVADU5NsVGi3hlAt0WirjgTG441/efXOiNufSpjjnfYlEiXChWyKQcberuTJch497Mi1xRw38w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785912501; c=relaxed/simple;
	bh=vJod2Z352oETuH+SskhYPbyy6JjxKDDw4wcoDz0/zOo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=NM0VroDIuGVYVI2bq5AD96b/c19IJkbz7z3KZjMvCmM6pIjuPaU2IW60kbRkt36t0Pn08s3QmImIsQw4BwSxqgS0aI001e3QyJR2c+C6BrKahMpQGVRMmJHnzNVUqaMQwRdWeEXHOYrOCHNQCmLpMtN43EmY075kt0K5gdYTARs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=Q+EnpbBv; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=UFtvV+7g; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="Q+EnpbBv";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="UFtvV+7g"
Received: from pps.filterd (m0127841.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6755locN2660006;
	Tue, 4 Aug 2026 23:47:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=vJod2Z352oETuH+SskhYPbyy6JjxKDDw4wcoDz0/z
	Oo=; b=Q+EnpbBvZXhi7nN8rB5QS7yVdwibji+SlZ2duGE8RMxKU9nYDDwIo8Pfv
	z07Yp32vB8cl+tak6rZWmfszzgkyHpjx7AcSPai+Gs7ooKOm4APC6d4QCWomhiBq
	Arn2MPYPYyKrjeEmTEHQem26GX7aGJCU8Yxzig6u8Yg1T9WjOoGquVdO+MVMU3WQ
	dAfAcyeaAHic4BFxCm8p0msykJUpYyB/NRu1h/B436FF9mlb6AVHWziG7NtXs0F8
	APLfAWDA4PU4XwFIE36P8cRoiFDBakHjPHKAK6MMEJ82Q+GzlAVqug0l/gc6O/lm
	3vP0IxXvWs/HdaGwkxv4P+3GEpbxA==
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11023137.outbound.protection.outlook.com [40.93.201.137])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4fuh9022b0-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 04 Aug 2026 23:47:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TL+VwuXPkk9lx9WpXG3lXMVBCPRYCr2lqCaZ2DDjIFcBizaPPQ/HpkVRPos3m7L0daoO9PM1/yWOyaXceSyym84SSBFq4wQ0zMxTHHnBJzb42eF54yuqDGzwUjiSYxMuWec24/lny8Kx/cGqj93SLKDkEayWydS0kt6V1UV6VRQS8L6h5jA8MO3D9xtO5OhR61na2AOxSVL0CFLvJJtwwUXXG/9/zf9+hy/aW13m2/lbZC3wW13l68FsyGmWTUYbLcFt0C+ryPTkGzJmFgFnpgWdEVvgvF67YcEfch+bBwkVdm+04++TJAIZAN3xU9UoVb4a+c0CvXGgyl0Xam7sdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vJod2Z352oETuH+SskhYPbyy6JjxKDDw4wcoDz0/zOo=;
 b=BnpKa1LKSW0nZg2Zj9tRkVzP6Gu9N6dAjg6UuChepgyLLsiAX8V7R+Tb9bnExYsvamXG5AFv/rIixbtTkTVsYy0/hkdOv/lPC9/ICx+0aLKzAHL02wMHHuiTJ0F7kEgiBi121jT6PEaHSrPrdiXz0YRb1oYrIFKfra/AjmyImTGlPbGCh5p8IVppRMQyWkjrpZD+V03L5r9ouJYka7w5yd2bS0X91MhGpoFIi0NhzJIaZKDcQFwfMvWO64f32DzM5oef/+iJaoAbWNvCAB4xWIkKE8YCxePL1/noPGIIoTvaWX0K9LjZtuXxZMPdI7FWZqkyAoPFlh9DG6bbBdx3FQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vJod2Z352oETuH+SskhYPbyy6JjxKDDw4wcoDz0/zOo=;
 b=UFtvV+7g+X152vT2JwN1ESfWvw2B0el4kmyGemOFvpgbHAGksZ1kN7C7zP5Pf/fNyO4ARHdS3zCqqnyF3HFg41Hx1J+gMxgKMACEYfuDxPUpl/Qtd1j7LhtcXz9sacyIZ5Zk08CvabVtzOaBDdYquL9MGS0lwBAji37WRgFXCwgSxYYian4ETr3uBMPb5dZrbigE7zWklCO71JvUz8uthRr6iUkMv6berDc9Kex9RCeD48CNwKaG6QFmkNgnLMlXwJ/WnMhoX1vF3x/eENHc9KkSi6iZjReRkzw11SAwLYe6xoCgDpORjVBBj2P3jqD+9cY1UZMgCPqqjdtKw3iqzw==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by BY1PR02MB10380.namprd02.prod.outlook.com (2603:10b6:a03:5aa::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.20; Wed, 5 Aug
 2026 06:47:52 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%5]) with mapi id 15.21.0292.013; Wed, 5 Aug 2026
 06:47:52 +0000
From: Khushit Shah <khushit.shah@nutanix.com>
To: Markus Armbruster <armbru@redhat.com>
CC: "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "qemu-arm@nongnu.org"
	<qemu-arm@nongnu.org>,
        "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "cohuck@redhat.com"
	<cohuck@redhat.com>,
        "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
        "richard.henderson@linaro.org" <richard.henderson@linaro.org>,
        "maz@kernel.org" <maz@kernel.org>,
        "oliver.upton@linux.dev"
	<oliver.upton@linux.dev>,
        "berrange@redhat.com" <berrange@redhat.com>,
        "abologna@redhat.com" <abologna@redhat.com>,
        "jdenemar@redhat.com"
	<jdenemar@redhat.com>,
        "gshan@redhat.com" <gshan@redhat.com>,
        "skolothumtho@nvidia.com" <skolothumtho@nvidia.com>,
        "sebott@redhat.com"
	<sebott@redhat.com>,
        "philmd@linaro.org" <philmd@linaro.org>,
        "yangjinqian1@huawei.com" <yangjinqian1@huawei.com>,
        Shaju Abraham
	<shaju.abraham@nutanix.com>,
        Mark Cave-Ayland <mark.caveayland@nutanix.com>,
        Prerna Saxena <prerna.saxena@nutanix.com>
Subject: Re: [RFC PATCH v3 16/19] qmp: add query-cpu-props-info command
Thread-Topic: [RFC PATCH v3 16/19] qmp: add query-cpu-props-info command
Thread-Index: AQHdFWubvCZ5bHZqSUmcDdL6/mUClLaNjwqTgAGSvoA=
Date: Wed, 5 Aug 2026 06:47:52 +0000
Message-ID: <3099C064-6051-4B93-BE0F-C54B7FD91D82@nutanix.com>
References: <20260716213858.609699-1-khushit.shah@nutanix.com>
 <20260716213858.609699-17-khushit.shah@nutanix.com>
 <878q6m5qox.fsf@pond.sub.org>
In-Reply-To: <878q6m5qox.fsf@pond.sub.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA2PR02MB7564:EE_|BY1PR02MB10380:EE_
x-ms-office365-filtering-correlation-id: 692c4798-9bcf-4d35-b168-08def2bd791b
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|23010399003|376014|7416014|1800799024|38070700021|4143699003|56012099006|10067099003|3023799007|22082099003|18002099003;
x-microsoft-antispam-message-info:
 r+ZAV3RVpVNwgtGEswGKmXiJnZhGTrkKpPNpKv9sKF4HO2jx0encbZNyTMr4l0Wvabab+DMzijgwJ34VM6N+Jn/Q9tDIEMGbnqGT5RMuDZ+cOLji7Ca8Bk2iGMekDR4dLfUHRw6EF9vvTVHkUcv9EnvCTC2XJnsvpbzkgneBDDYgyCRaz8AYrHE8ixwngDoaYi+5F7I5tBnxr61iUCRa7of1WNLJfFozzFZzRhJIfTby8GFfQ8jSKC3CRrdg87TVPh2+GZ8qJhT5fj3CRIizcChDbImozGZvlTiDUAmxTkH8/DCk6xtfZsxPRcQ7tJF/w8z9anOCaBRY06WZmxUcXVCIUw4JDsSNULOPUSJArqtXhDEBRGxahWdKruHAomuOC23Q0unEJxfVLFtr50HvnXAqN62g3HgVi0J84dFK0SNPLffy56RqrpqL3tJZozJZoPUgC1zNat5Kj5/2SXjB6/xG/iVcAn1GJ2M1nblF6H+lydv4bPh9iMqYYBzTMDRtLy7OvrlVhzRBf5fQF163gpvcz1lrGqvteyLnFrQMLZWrWrQUsLcIrwm0Pc7XlpPSvbXdVGPzQHMzm5MOUQMtLfQUCT4xQbUyhBl42+BS8ko5elZJaOvZwmmRE0rzF6R5w3ZZyziOluHujPCtl/6nJPmCRqSZObgmUeKP/64msBIrfIOlhpvGefWr2+DJxkkAMhNMHIgnTffrfHXcpXeVzQ==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(7416014)(1800799024)(38070700021)(4143699003)(56012099006)(10067099003)(3023799007)(22082099003)(18002099003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?bkJRSGJldHVWT0JHaWJ5YTdEUmhQY1p6ZnNYa3FUTTRnbHFPbUd2OWZwYVhS?=
 =?utf-8?B?emFjbzRsazFVWkhaanNxYkZJVmV1RHA3NE9hb3VlNy9ITjFTK21XbnRnZUp4?=
 =?utf-8?B?QkJjWlJNMy8raE9zUkcrSGxSOXRLWnRBZFJ1RjhUUXFiZ3BPbkYxeHlyMDFk?=
 =?utf-8?B?NnMwU0ZieVhVdWdjVTZNT1A0TjJBalFTR21LL1ovWlVhWG5WcHErRkNqVXNw?=
 =?utf-8?B?S0tTUXVITXJVMjhta1RBdi83OG9qazBuYVRhQmVxMjZ5cTRjRUxwZ0o4cyto?=
 =?utf-8?B?dEhKQUVJSDQwNVVZalJxVm01YVY0QklmUUVjai9pMVk0T04yTFdCTXlleER1?=
 =?utf-8?B?UXBjQlZxbWlTVklFcmhGK0lLOFd3Yk9xTzFNNmFiaEdib3JjUjVWdGxJdGs3?=
 =?utf-8?B?cW81M2tMTGJVUVRDZFg5c3lORm5DRGJQdlpaNUZGZElkTFkvQWpWeWZjMWtF?=
 =?utf-8?B?OWxpYzRsM2NtSDJPQjZyOWhxMFhBRVB2SzlEY0lQSlc2YU5vZi9CNkphUG1I?=
 =?utf-8?B?TElFeDUwTEcxNW1rQ0Yzek9TRFhtUzdHd2dNWjFoMlZJU0Voazl6a29BZnl5?=
 =?utf-8?B?YnNxUkdpYmYydk5rLysyNTFFc2VsYVRlZ3BkU01CV2FZVzhCNW50NmF6Q2V1?=
 =?utf-8?B?di83YXVabGNQbTZnWXQyem1LZ1VkbkNkSmdBZ200SXc4VHdxbGcyaXQyclFt?=
 =?utf-8?B?NUhRZysyemlubHRPUTl3OFNIN1B0UDNKN2FFdVowajhkV2dWSk1mQUo5V1po?=
 =?utf-8?B?Qm1JU1ovQXdqRDVxMnU0NG1NLytJOXJsTUFPQWxRZVhZMENuVDdFY210NmZB?=
 =?utf-8?B?elVheUxvaUJKdFh1Y0ZIaGo3TFNQOGc4MWNXaE9URGZodE5ncFdMWEloMEZI?=
 =?utf-8?B?VC92bHl6eFg3L0I2eUhUaFNvWU5YRUFFQldBQmw3ZFZJSTM4cSs1T2N4SVAz?=
 =?utf-8?B?UmhTaDZRQlJkaXY1L3V3RklIWkc0K2V2dUhJbUVXRDYxalZWTGF5ZHlHb1N3?=
 =?utf-8?B?bUx6K1Q2bUEvTTZSWS9uT0ZLK2lyRTAwNmtrNFQwUGJxSHJUUlkyRGJZUC9i?=
 =?utf-8?B?MU5YVVV5Zm5RREx2UEFKS1NVWVhQWTBvMVhicEdVVXhyV3VZS3J1bVUzVzNt?=
 =?utf-8?B?aVB1aTRlcnF3MHUxbTY4TXpPWGtvQ21LeGpQbTF1bUxIM0duQkhJVml6OXk2?=
 =?utf-8?B?dHk2UE5FOXJPaTd1S0k1dlFPbE45YWtSVWNkZzVVdk5adW9VT3YvdkJhMHJK?=
 =?utf-8?B?L053RHo5VFhSSDI0Q2d5UExXTTFKNEhwQ0o1UlE0RWRIb3p4VGQrdXNMVjM3?=
 =?utf-8?B?TlQwMDcyUDM0UlQybUdHV3h1ZFhIeGQ2VWZzVUxrTHBLZHI3TytxdGVlYnBw?=
 =?utf-8?B?MkloSlBjNUg0OHlxR1ZYakx0UFdDUWFQK3JvTlpxVDIwbm1nSmpZdFlDa2Ra?=
 =?utf-8?B?QXQvem4zYkRSckRKRjFadDQwU0xGNFVLd1FNTDh3ditnSit6bHNzRnZhN3ho?=
 =?utf-8?B?VW1WN3YrRWE1RjhLZjVXaG5KdHZIb1lrcHBMVENlaG5xaTJTZ0VoTGk5Ymds?=
 =?utf-8?B?cWptYS95QXhxclhmNXJyRExjRjAzdm9uai9pY2dvcGV2SXNWU0xFWjluVmg3?=
 =?utf-8?B?YkNoQ1o1VTJ1YkdOY3FpeWxEaGhCbUI4UTVXMCtEUTRSWmlOR082eHJoamxC?=
 =?utf-8?B?cHJqS1RlZHQ2L21TSUlsdjU0aWxSMjhOZlpMdkFMb2l1eVdkbFlmcVU2bEp2?=
 =?utf-8?B?TVdDK0VjT3I5czl4OGpSeUVyTDZmTkg1NUdHbHdzbXVDcGlIVUFySTB0Z25R?=
 =?utf-8?B?T2tnYmVtMC9HSU9wOHVnS2FoN3h2NGJEZDh1Rlh0cGszZjYvOXpobWlldVp6?=
 =?utf-8?B?a3IxVHphT3BlQlY5UkpveVhQWFo5ems5b09tcVo2bG8zUjFYME15MmY4RFdZ?=
 =?utf-8?B?bmxCYWQxdXNrWnRZZVVUa0hFejVIbUZ5T1NCcWk2N1BMaWYwaUZubDg1MGlE?=
 =?utf-8?B?eTgvd2c0QmNsNE9aMUJKcGpwQWFqSmE2MVZjZWVKOUpKR0xLRlp1QXE2Z1lC?=
 =?utf-8?B?QW9ocjJGSzdRdnA3dHVaNmozQ1ZoV3MrdHV1aTJaMnVrbXZNZFd6UE1WUFF6?=
 =?utf-8?B?bXZGZVFlTUNWRGF6RE1VSVp2NVR2bFFTVUw0cVFVOVRuTXdpRk1PYkFlRHJK?=
 =?utf-8?B?YUg0MjBLUURsekhXaXJaQUd3Mm5zd1FDbVZ1dHRHMEZyTDNWaVpSSEZFY3kx?=
 =?utf-8?B?VVBPeVdNeGtJajNDc2I2WjdheEZwU2RRUWFYTEZKREZzdWNBRmc1dXVGZ1NT?=
 =?utf-8?B?N0JRNXB2SWR6cmlGK3Z6R21KV0djVGhaV3FPOUhoamkydjFoUlBIRDN5UVR4?=
 =?utf-8?Q?FK+XKn5J6n3vzOE0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <27D4F4C6C04C464AB4B877A9BAC15061@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	WcdPSAD0S3QITS6e+kaBW2+pi9FQNHxewm7LJyLU5sus/vnX2exFqP5UYb7NBQ7OHIb2GVZ414b9vtdQP4XRcNq4baI8TAl8yXXibnRz2/xQ021t0dzo7NYEWCZQKUXdoCOeXkcU2CF3lLopgtAwNNoOUOkfLKhAfjqOrpSZWlYlXandohy+fqvm7RC+xIX0w2MGF7XEAjFqaWs2xFOIMsqX3bITKYEFjGr4xtzknhlLhvXKMJSPb5tuFYpNW7oWl5zz6tPJN3tI0OKaEUGwXVxivxxB55F0G0TP8cA0WXwUL5BMLRF4eAxjPu6k1qPsRm/wFbb+fz10PlWFfNHBAg==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 692c4798-9bcf-4d35-b168-08def2bd791b
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Aug 2026 06:47:52.7620
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dZGmlvCTPP6U6ToXYXgeWsnbp6NpP4petPFa0GvrQg+LdErD4B0nFJ0ROveDwi92rVVjGiaC6k8LAQlheSvtY2/IZeIcEvrO0vqgBxeL4f4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR02MB10380
X-Authority-Analysis: v=2.4 cv=SePHsPRu c=1 sm=1 tr=0 ts=6a72dc9b cx=c_pps
 a=lhMG70nIYFfcSaqvxYvWRA==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Sv0fKeRqtYgA:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VofLwUrZ8Iiv6rRUPXIb:22 a=jxMXjlTPpCISP5mWtjnE:22 a=20KFwNOVAAAA:8
 a=64Cc0HZtAAAA:8 a=raqXEruqm-Ipo9WNifEA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: i5Abee71VZlzMrafUX_lSz_MRfi_61ae
X-Proofpoint-ORIG-GUID: i5Abee71VZlzMrafUX_lSz_MRfi_61ae
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA1MDA1MSBTYWx0ZWRfX/8Ah+lWCMpaJ
 XtRTuUHkX5FXobA4MmzxbG4z6A/1+SqDXk1ZktNjShHrabJ8BKigBbFKtpJXP34MkYziLuxPjI+
 byfN+vBTZGNrSX4DYK6DpoHsvm5S6RIB9hDLiUAwbQRzjJuMO/ArTqPTVqIYapHDkIWvlGPA0l4
 iY0U7v5fRgvDhiOLCVpuGEF6z+r9Pt1HWGReSeuhhxinRDld3At+6WLcRzM2tbVJpqqmarjsfhq
 3pTOW2DJSO5ZMjJ2iB7UJsdTwT7WnMnnGjPrtdjCFzsywgOrND3TrnVOc7oIYd+dQpY9ZL2lT9k
 hOoytxGvASHMiDtTrpNHBMurviuxC0tk29G6/nzWHYJvZpeaajCq83rqSnAHgkBVQw0tts6SuOL
 DtwvVJTaevy6d+AEr0JcaYYhsQnZE7WkSUgc3A0yohYJ7gyRihEfCS/CPTiKN0QtizzMmKY0357
 hPuiPem2bIU/98v3G5A==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA1MDA1MSBTYWx0ZWRfX4q7Ffdi9HWmy
 3fqorP+p3+wz7STp+YaQewGIZqeU4es08Ia5DU4cCtcvOSnkmJ+dcDyMf4YDd+0gMYevpg7jwc4
 DBi36cP8VhDGAsQB9aiGdk1lQis0XS8=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-05_02,2026-08-04_02,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gNCBBdWcgMjAyNiwgYXQgMTI6MTXigK9QTSwgTWFya3VzIEFybWJydXN0ZXIgPGFy
bWJydUByZWRoYXQuY29tPiB3cm90ZToNCj4gDQo+ICEtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tfA0KPiAgQ0FVVElPTjog
RXh0ZXJuYWwgRW1haWwNCj4gDQo+IHwtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tIQ0KPiANCj4gS2h1c2hpdCBTaGFoIDxr
aHVzaGl0LnNoYWhAbnV0YW5peC5jb20+IHdyaXRlczoNCj4gDQo+PiBJbnRyb2R1Y2UgdGhlICdx
dWVyeS1jcHUtcHJvcHMtaW5mbycgUU1QIGNvbW1hbmQuIEZvciBDUFUgbW9kZWwNCj4+IHByb3Bl
cnRpZXMgaXQgcmVwb3J0cyB0aGUgdHlwZSAoYm9vbGVhbiBvciBudW1iZXIpIGFuZCB0aGUgc2V0
IG9mIHZhbHVlcw0KPj4gc3VwcG9ydGVkIHVuZGVyIHRoZSBhY3RpdmUgYWNjZWxlcmF0b3IgYW5k
IGhvc3QuDQo+PiANCj4+IEZvciBudW1iZXJzIHRoZSBzdXBwb3J0ZWQgdmFsdWVzIGFyZSBleHBy
ZXNzZWQgYXMgYSBsaXN0IG9mIGluY2x1c2l2ZQ0KPj4ge21pbiwgbWF4fSByYW5nZXM7IGZvciBi
b29sZWFucyBhcyB0aGUgbGlzdCBvZiBhbGxvd2VkIHRydWUvZmFsc2UNCj4+IHZhbHVlcy4NCj4+
IA0KPj4gVGhlIGNvbW1hbmQgYW5kIGl0cyByZXR1cm4gdHlwZXMgKENwdVByb3BlcnR5VHlwZSwg
Q3B1UHJvcGVydHlJbmZvIGFuZA0KPj4gZnJpZW5kcykgYXJlIGRlZmluZWQgaW4gcWFwaS9tYWNo
aW5lLmpzb24gcmF0aGVyIHRoYW4gYW4gQXJtLXNwZWNpZmljDQo+PiBzY2hlbWEsIHNpbmNlIHRo
ZSBjb25jZXB0IGFwcGxpZXMgdG8gb3RoZXIgdGFyZ2V0cyAoZS5nLiB4ODYsIHJpc2N2KQ0KPj4g
dG9vLiBUYXJnZXQgdGhhdCBkbyBub3QgaW1wbGVtZW50IGl0IHJldHVybiBhbiBlcnJvci4NCj4+
IA0KPj4gVGhlIEFybS9LVk0gaW1wbGVtZW50YXRpb24gc3BpbnMgdXAgYSBzY3JhdGNoICJob3N0
IiB2Q1BVIG9iamVjdCwNCj4+IHdhbGtzIGl0cyBRT00gcHJvcGVydGllczogU1lTUkVHXyBJRC1y
ZWdpc3RlciBmaWVsZHMgYmVjb21lICdudW1iZXInDQo+PiBwcm9wZXJ0aWVzIHdob3NlIHJhbmdl
cyBjb21lIGZyb20gYXJtX2ZpZWxkX2dldF9zdXBwb3J0ZWRfdmFsdWVzKCksDQo+PiBhbmQgdGhl
IGFkdmVydGlzZWQgZmVhdHVyZSB0b2dnbGVzIGJlY29tZSAnYm9vbGVhbicgcHJvcGVydGllcy4N
Cj4+IA0KPj4gU2lnbmVkLW9mZi1ieTogS2h1c2hpdCBTaGFoIDxraHVzaGl0LnNoYWhAbnV0YW5p
eC5jb20+DQo+IA0KPiBUaGlzIGV4cGxhaW5zIHdoYXQgdGhlIGNvbW1hbmQgZG9lcyBhbmQgaG93
IGl0J3MgaW1wbGVtZW50ZWQuICBJdCdzDQo+IHNpbGVudCBvbiB0aGUgbW9zdCBpbXBvcnRhbnQg
YXNwZWN0OiB3aHkgZG8gd2Ugd2FudCB0aGUgY29tbWFuZD8gIFdoYXQNCj4gaXMgaXRzIGludGVu
ZGVkIHB1cnBvc2U/DQoNCldpbGwgYWRkIHNvbWV0aGluZyBsaWtlOg0KDQpUaGlzIGhlbHBzIHRo
ZSBtYW5hZ2VtZW50IHN0YWNrIHRvIGRpc2NvdmVyIHdoaWNoIHZhbHVlcyBhcmUgc3VwcG9ydGVk
DQpmb3IgYSBnaXZlbiBDUFUgcHJvcGVydHkuIFRoaXMgaXMgZXNwZWNpYWxseSBpbXBvcnRhbnQg
Zm9yIG5vbi1ib29sZWFuDQpwcm9wZXJ0aWVzLCB3aGVyZSBrbm93aW5nIHRoYXQgdGhlIGhvc3Qg
aGFzIHZhbHVlICd4JyBkb2VzIG5vdCBpbmhlcmVudGx5DQpyZXZlYWwgdGhlIGZ1bGwgcmFuZ2Ug
b2YgdmFsaWQgdmFsdWVzIHN1cHBvcnRlZCBvbiB0aGUgaG9zdC4NCg0KDQoNCg==
