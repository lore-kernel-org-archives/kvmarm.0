Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEF6133A9E8
	for <kvmarm@lists.linux.dev>; Mon,  3 Aug 2026 15:52:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785772340; cv=fail; b=TlLcFpaquoa2VW/sihQHT6NSPC0lM5yGsZpFSJt8zRgLPN09xQaIOGagDBVlpyJl3BjiqX4LwboAHX5ogg7QuXh6+VjB1wYl/PrjLdcY3d7yuDuuy/Gtc3Ru8lG8EhzPBkUSDQ8nV3aPYDuTKpNVjhVCxKFnsCNvHpO9MZ933wk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785772340; c=relaxed/simple;
	bh=vgv/F7EOz2EK7qWJhy50EaWF0JZOFo2j5pymagMpHcI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Ak/Y2BapTRbyHoGv4KUm3Mn1L2HlwK3SUEy4xfRLMdlqpXeUUDZ5N2GJpVW5ZWoPnx6RxCOyK/F5IQkxNyWlxPBCn65chQwbogmpuiVPpmRbZJa9XpCX9d9L6bFKDfEqsoayMnkgaLoA9i9z2VEv582KNESJPWMT79GPaa9QKso=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=MrTpPX6D; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=Fj8WpH4K; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="MrTpPX6D";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="Fj8WpH4K"
Received: from pps.filterd (m0127839.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 673EHbf61677864;
	Mon, 3 Aug 2026 08:52:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=vgv/F7EOz2EK7qWJhy50EaWF0JZOFo2j5pymagMpH
	cI=; b=MrTpPX6DpKr6YJvr16Eej7SpwAutl1uN+cl52WGO3GWbk8KjAJCrnAIMN
	RL77tSV4QICBKMjO8vxmp1piZQE4Ake6SFR2/ekSEQMjTlWDBaiauQ7/zZXRY1h6
	Qd4e2j/GW7RhX9VUIDypT5IgTjz7f/Q/7pM2bqSYFeMk8MouBgN8BsSMgKp1/SAO
	hP6qYKXgOQRAwAhLxgO7ebRtAmF3eDeEYP3BXEoGpzx50uvr9Nrw5g8pCCyzYWea
	v/Vj4+Kjy77G5oF18aPFtPtRIQQPdpgNosNuG0Saw7jBIS/gpcWqtRhF8dZHnbJi
	bjaaxgU/tbvk9uuyHx+lwQG8UvbYw==
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11020100.outbound.protection.outlook.com [40.93.198.100])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 4fsfvd3vk6-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 03 Aug 2026 08:52:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iCwGPXCs2ve12k2WsVXJrUtVSkdybk90K6PLhlrx/byM6FuUs6XQRmbuaxwS11XIW1pk07qHc35yp52SM5Zz8NJnbxdFV7ExbVhmY4ILFJcSURsESiU/8/ULHvz7Nl//cXEYGBbD6L2lhhsvCiRSI9GNKbvibqtG4GWgURPYdUnoONGHCUum6uGJNbzQgTqap3/0cov7Iph+Fp6BYR8PYx9d/WsZThtv+/6vzBWpI7YMhGqMDNN3HHwb2iX5yyHOtvwacP23gidkAiq/SHRSOqzUQbLiX/x8tiPy8CI4zFaw7aCp44HyTqeBSYATkiradYezJE3p/KMdl2xpHhe+PA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vgv/F7EOz2EK7qWJhy50EaWF0JZOFo2j5pymagMpHcI=;
 b=hRk5lNzoCeC5ZXyVGX4VKev02bObJ0ZauqVParKY7qFkYdUPfqZahHaiN6SaY+YtPLO70MdX3u1KGdpDUI+OnxY4sXjotBWW52OXQPqj9fpqHH/T7XSMkPnnQNgB8y8mXTNbLbR/Fc7mt+lKSA4ZUP+lDA5r7hueqoFtk/Yq8k7E4E6ZG9cq35iWKkHCCk3Mwa0PSPzOazipbvmGLHZLe6P0G7sNbwHWg+FAeAT03vKUPJNHo1uig6sqZpybH8qz8JZHd/HumB7l2K2KuNa9OlHc7M1BI1m/X6kNfGqsidGuEf98NPjaABZd04SP9DFLoH5sn/LKrsXgrQ0nZh7Ucg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vgv/F7EOz2EK7qWJhy50EaWF0JZOFo2j5pymagMpHcI=;
 b=Fj8WpH4KuXy2J6uF9pSOX4AivCbhplpFl5pGVbZMjG8aK1Y7fy4mroYDTpHjZHwdMEeP4PvEUXzMzZ7pZNJQOKX19NXkwdcmt1m7wfD+sW9oketayrATV8UU2MdeyIXMkZ8TPQrsAeNDWrPDsz4awjJSFufpDwHX9+USO2KGISvmod2XU3TqBl2L7rLVYj9GPzjL8s+c3xwH43ieIFzWbNWzMLKqJOWUyTjKgHxDjYgsFw/9WbGavYLRIRSu8WsppS78rnQOF91BPItTr4QzOqYhG0FWiRH4ktr/NJy+dPW7JGD8cRi9fx+erIbRXhpUmc2ZLqRZxxU3ieuzJNiEZQ==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by LV3PR02MB10692.namprd02.prod.outlook.com (2603:10b6:408:28c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.17; Mon, 3 Aug
 2026 15:52:02 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%5]) with mapi id 15.21.0270.016; Mon, 3 Aug 2026
 15:52:02 +0000
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
Subject: Re: [RFC PATCH v3 07/19] target/arm/kvm: handle special ID registers
 cases when reading from KVM
Thread-Topic: [RFC PATCH v3 07/19] target/arm/kvm: handle special ID registers
 cases when reading from KVM
Thread-Index: AQHdFWuW2xvLGKDi10yjEZ90KQ37mLZ5gYAAgBMTqQA=
Date: Mon, 3 Aug 2026 15:52:02 +0000
Message-ID: <34D1F8A9-C40F-4BA4-80F8-FC611EBCC732@nutanix.com>
References: <20260716213858.609699-1-khushit.shah@nutanix.com>
 <20260716213858.609699-8-khushit.shah@nutanix.com>
 <134decf2-a084-4cba-8536-a59ecbd6b420@redhat.com>
In-Reply-To: <134decf2-a084-4cba-8536-a59ecbd6b420@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA2PR02MB7564:EE_|LV3PR02MB10692:EE_
x-ms-office365-filtering-correlation-id: dc519af0-4d49-47fb-2dfd-08def1772933
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|7416014|366016|23010399003|1800799024|6133799003|22082099003|18002099003|38070700021|56012099006|10067099003|4143699003;
x-microsoft-antispam-message-info:
 JjZUvD55EY8HyNRHA9f7GOYZj5fKB56miku8ouia6umQ8xLWH95ztxpVvRTdhlYLMvXhTysyA2mv1LrX4M2rCqBPk5U6eH9SxHxKH1zg0Tn83JiIhv/4PCs2TBTWq5RcAbQYWR+mJIM4OYHpUyVIoP8+45dzMNnnc+ymlXOjFoMTVoXjreponEnin7JjhwlCo4joy8gJvmDfmRNnuLDfd90u99HaJqIYwpNDv0BWY70SIWG7Z8AFQ4zbqxDmg60OLQKq2M2w4i9d9d3WJieXCx1kxljHy8kCY9NHFGeKI+rKmEZ6U/y7BNh3kZ1Go7r0p1HMoPFFnkVUsgWxBS1Hs6r22xCLAy2VMMSl25Wpbs77Ksr7eKrStkemXHsvFcbxZ5S8Xsb1/G1NcRL9JjOByzTMqMLhsbaIQCO5xGvDdwSY4ewo0SqpuCG1ukyzUokxI4Q6zAntMJTTD/kFVFFXNWtNPd0iJ6E1c3N1xbT6DSvEqex8w4gxy02Q2ewN9/upCG3T9awOX5XZG10SOuTp5vPybzz6MEqWHBM45dMpE8DDaypXY4lFnD9jl0xfxI64sBHAxyP0HPKz59V9LvCoTU3HIgPpV2sFm/Ba5kRcEc+26/3XEsEQhPKNUyFyqS/P+oM9iXw5KDvZNIJGZXNqww0M8Tbg6XgNosT9zyHYFD5yr5ddiL9KG4fpfdc5BcgbG1iZo1VpNC4ogx/0liMB57pmuGwTLhXE5A3UwJCScV0=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(23010399003)(1800799024)(6133799003)(22082099003)(18002099003)(38070700021)(56012099006)(10067099003)(4143699003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?VVZjV1Z6UFlyMStPYUF5Wk90UmlWQ0ZnSTRvcTFmZ2UzWVlhS3Jpd0R3NG8z?=
 =?utf-8?B?S2RSemxOejlXMEJhNWt1MVA0cVVPamZqdyt6OE0vQ2xYRTdKdHBFUFJxNUJ2?=
 =?utf-8?B?Z0t4UUdaS0R4emxqd1dDZTFxUlRtYzZvU1F2cUYwUkdYeXBOcFZZanpyd0k5?=
 =?utf-8?B?Y1huSVNCUDN2NWI5YTVwUm1sV1RJNUJpQW1WZk5UOFV1cVFFM3BQcUdXai9L?=
 =?utf-8?B?SjljWTRHRGg2M1NyTXA1MmhWZXFMY0pWT0s3TmJlVC8rSnpIVkkyUzhsMzcw?=
 =?utf-8?B?UWhpdm9JeEVBaGl1akU0bXR4ZGdKL3k3cVdRaW9VMGZtWjVGZmJYSk9kKzE4?=
 =?utf-8?B?REpiS29nL2p0N0VybDFtU29rUDk3YS90WEY3V1hWMzRSRHVvbnlRTDRWRjRJ?=
 =?utf-8?B?S2w0aU9Yd0J0ekRkbGJsNDlsRDh2bm16SllldVpIN1dRc0dOQlM3eFgyTG5i?=
 =?utf-8?B?M25mUHVSaHI3Z2FhekJtdlhya1VacitvMkJLQzBsSzlrVXhnbFdZbW5wdVhJ?=
 =?utf-8?B?dUJydVBJZUNWdGNDU2c3RGhabGszS2tUSHRsaFo5dldIaUtLRFp1T3hsMEJx?=
 =?utf-8?B?NmdDNE5ibkR3UGlZd3cvN2xCTFhNanJEUzQyaWpTbFM0anFlSlp5K0FQSWlR?=
 =?utf-8?B?QkpNMVZGTWlOU2RubUFrYjNSTjFKUFF5bE1jSmhSMDd3c2w4aVM1V2R4cmJH?=
 =?utf-8?B?eTAyMXJlUE5GMTI0c2dxLzNYL3EyL0pYcEJUWXA2NzcwMjB6Rks4YjdYMEd0?=
 =?utf-8?B?Wi9pMGpGdVNoK3djTWUxQUVDTWhSWWQya3ozSjlUVDZoN1V6WnNsTEhocWJX?=
 =?utf-8?B?OVZ2M05CYXh2YWVEWUxyRGs3eHBpRGwzSnNqdmVoWkpHLzNLRWF2NU82aUR6?=
 =?utf-8?B?RHZNajhZYVlBQ0lsQlY3ZGR4anhkMDQ4RTg2NFg3azdrVVhXMTRjdSs3WXp0?=
 =?utf-8?B?MjZ6RW01SE0vSFprL3BXd2NaN0N6ZmdNKy9NMFVQZ3BCVWNuY1FiV2xCWDhQ?=
 =?utf-8?B?WkNzOTh4dS8wV3BYMUw5d2NncThTT1hKWWVnVW1Zanc0bS9VaVM4Ti9naTJU?=
 =?utf-8?B?NkdIbFBKaVVkRDNuVGRCdXFKNWZUTDEvMDdtY25ZOTdwS3E2SXVNR1IzUU1I?=
 =?utf-8?B?VzRNMXVORUJVL2YrYWFlb1drMUE2dXpuUEdOT1htaXBqVXNKd2c0SzN2MTdi?=
 =?utf-8?B?aXNyUUlMNkVPL0hjc3pBK21JWDQwZDMxcGJaK3lEejV0OWk0Yk5zejVWdkdw?=
 =?utf-8?B?WlJ4WlhFeEhpNXM0bEJ4R0JnUE8yaDZvZDhuL0dYRWcrREsvNnZ2Um00Mlcr?=
 =?utf-8?B?QmJjNy9NcG9Jb2NpUWtTNUowTWdoRzBRQy9FUm1xNU44ZDdocHFIZTJVZ3hi?=
 =?utf-8?B?MWlxZEMrUExPRjdZQnJVbUJ4bWt0L09IdXc5aXhCS2RBMDA2U3lOb2xPUXpM?=
 =?utf-8?B?Y0hZOXA2d0RLRjJDWWpuTVdKT3lycXFXR1FJWGhlSnUxQzA3ZXVnQlRnV1Yw?=
 =?utf-8?B?T2lLQ1lPK3pHQVM5YTdjWEtJREVlYXlYdEZ3ZG0rZWV2Y0s5dEFkb2FYNVls?=
 =?utf-8?B?UURkRFdhd1JnVVdzZFpHM1VqUFFjZ2pyUnNRbHk2Ylp0WmxHalhtY1B0cWM0?=
 =?utf-8?B?T2tBSUpVMXZ0MzM3RXBENjhob1ZHZDlKcENkOW5mVkNLd2FBeVZUU2JqY3Rh?=
 =?utf-8?B?aWlMQUpSL2cxQTN3a2Y4Y25vVzZBVGdBYUhmaUwrLzRZUnVRMHR3OUdqUTNQ?=
 =?utf-8?B?cmVORWU4bjlTQVplNk1BbFM2K2tyREpteWlVODMwRkJlbWFPV2FTc0gzVm5I?=
 =?utf-8?B?QjVUNzk2NjZjTEVFVVY4OXRLU0d5bU80eDJOdXVIU1lhNmRQblNBeEVtY3Jr?=
 =?utf-8?B?WktwcEhlTWJ3aHp1OHlwV1pEak9HWmVxNzRrcCtsZFZkMjBOSjFWTHloU25a?=
 =?utf-8?B?YmFvRCtzSFJyaXhTcUpvZDlyWkdlUW1kSHFJazlydmoweXc5VkdZNmFkWlRC?=
 =?utf-8?B?VUhqM2I0QmxuNmlEU2FkMElNeU92alBWWFV0ckFXOHluNzRYQm43YUxmM0VD?=
 =?utf-8?B?L0JEYUNGTlFWVExFa2phQ3Q0QmFtcE04T0txQmN2N1RLV1RHVDliWVJBc2lR?=
 =?utf-8?B?QXhKejJ5K0dTeEZMd2lOTE5aSUI1VXZnK014Y1Jib1IrcnVhcXQyYlBUSFV3?=
 =?utf-8?B?SDh0WXIzV1VpTE1Sd0RTQzlPK3VNajNJK2p0VDdSY1lOWjNRSnpmUjV0ZGNk?=
 =?utf-8?B?anpmZmF4UXcxQmgvRXVSYStQb2FkbG9Uc0J3S2lPNlpLWkp3dDMxcnZPM0RK?=
 =?utf-8?B?MmRJTXdUVWJkODJUMXhzQ2pwT2NoY3VZU3hsWDlzTVVGWUZIYXNaWXdkRlo2?=
 =?utf-8?Q?DBAUhuwxtc524FWk=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <44AC1FB7AFEFD04FB5CE402AAB1C3673@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	F1clHvB9osweHh1yCWXB64UHLXPSJROri8gmHOPR8DJxgt5Uy1wEpljTqW358+yJfN68F2mpDs8cG+ClEJGOdOf7Vxx8P1HeOypcTK4LCh+2ouKl7AmHYd1sxWnM9E9RErVXygrLoLR1kMI69XxXcnHg88DxKEosqQxytlTxjdb9TGRUV16OszMkJ28IpKt+fx3dQzWdgsIcdAgC8WIxfYQ8o4roJlyPfpxHFQWt8weZ8h5iOwMu9LpbzrUC2R+L20wrrR9Uhx0DtH36lofy+BzOOBu9AkF/YGNIZyDiRpUSc3VelPnyuPiKUERgBDfcWrSsrHG0phJavrvF3IovKQ==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc519af0-4d49-47fb-2dfd-08def1772933
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Aug 2026 15:52:02.7250
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ANs1TYB/W9ONM7rch6uh681wiLnzbvBj2xp7QJ9x8vG5emIrkDaIhNoLDSj9jfFiDlULxy4NCv2+CB8D1ka1KB735oZ6vJPYMBoRrIyX3ms=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR02MB10692
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODAzMDE0MSBTYWx0ZWRfX0UxBdttcSJGG
 eUjtmaiomP8eaQVZzZdHCw3NVe0r5xSAReHtZFJ52xV4rPUy4mkYyW41Bhl68SdafrZQFeXbaTa
 R2NYvcD2Q5UttmnE2Yjv83jmhulOjnT7pLeZ1xr/nAyzJQV57xCNgeJuzVCNpCR6IX05LyHd9jf
 9mqqXO3SQGoe3qHMhkwAeWdxH0/+z+ccO5sM6QfReUgPRQJFi42zSZb+5yejYnEs76ty2ZCQ03Z
 ljK/Vwo78s9ZXXJbTQduLSssQfoiTyvQ6gsBaAw5htjrjmlaBTO+qfR6e5/9gpehrg6b2O4sGb5
 P8Vl4ydxGldEctTiyRCL7u9LDAEpWZEdgjkL0fZ7K+SLAD90qYbWgBJNSfPrj7DQfTDC/9eYK4o
 Wu9HbxIpzdEAKmxz44L0tL8YKBZMHg29LAko+gCH7+uTW85R/jasQhNegaYE1ql9nS510l6RHwe
 we3MUbGLrckIoVZ0hng==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODAzMDE0MSBTYWx0ZWRfX1h3aC5YC/lNP
 5Cuc+8iWEyL0b85NCyu1P0W9Uzy3tf5gMrQ8tm1I7f1+5CbqJrAwf5zbyDaDfRethiOYMTymoSv
 GuqWa3BpudFZk8APeQdtmbotWC48XBc=
X-Authority-Analysis: v=2.4 cv=X8Bi7mTe c=1 sm=1 tr=0 ts=6a70b925 cx=c_pps
 a=rsLXg5VPEOJQy+C7BNxFIQ==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Sv0fKeRqtYgA:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VofLwUrZ8Iiv6rRUPXIb:22 a=y4UcunY2MAxhM4LwGdWI:22 a=20KFwNOVAAAA:8
 a=64Cc0HZtAAAA:8 a=g_IME0bt5OBPbi51zUYA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: J_s0Io4RPwxOS1yLBWTKycD6atLjCYKg
X-Proofpoint-ORIG-GUID: J_s0Io4RPwxOS1yLBWTKycD6atLjCYKg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-03_03,2026-08-03_02,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gMjIgSnVsIDIwMjYsIGF0IDY6MDLigK9QTSwgRXJpYyBBdWdlciA8ZXJpYy5hdWdl
ckByZWRoYXQuY29tPiB3cm90ZToNCj4gDQo+ICEtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tfA0KPiAgQ0FVVElPTjogRXh0
ZXJuYWwgRW1haWwNCj4gDQo+IHwtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tIQ0KPiANCj4gSGkgS2h1c2hpdCwNCj4gDQo+
IE9uIDcvMTYvMjYgMTE6MzggUE0sIEtodXNoaXQgU2hhaCB3cm90ZToNCj4+IFRoZSBnZW5lcmlj
IEtWTV9HRVRfT05FX1JFRyBsb29wIGNhbm5vdCBjb3JyZWN0bHkgcmVhZCBhIGhhbmRmdWwgb2YN
Cj4+IElEIHJlZ2lzdGVycywgc28gc3BlY2lhbGx5IGhhbmRsZSB0aG9zZToNCj4+IA0KPj4gLSBE
Q1pJRF9FTDA6IE5vIGZpbmUgZ3JhaW4gdHJhcCBleGlzdHMsIGhlbmNlIG5vdCB0cmFja2VkIGJ5
IEtWTS4NCj4+ICBJdCBpcyBFTDAtcmVhZGFibGUgYW5kIHVudHJhcHBlZCwgc28gcmVhZCBpdCBk
aXJlY3RseSB3aXRoIE1SUy4NCj4+IA0KPj4gLSBDQ1NJRFJfRUwxL0NDU0lEUjJfRUwxOiBub3Qg
cGxhaW4gSUQgcmVnaXN0ZXJzLCB0aGVpciB2YWx1ZSBpcw0KPj4gIHNlbGVjdGVkIGJ5IENTU0VM
Ul9FTDEuIEtWTSBvbmx5IGV4cG9zZXMgdGhlbSB2aWEgdGhlIERFTVVYIEFQSQ0KPj4gIChLVk1f
UkVHX0FSTV9ERU1VWF9JRF9DQ1NJRFIpLCBzbyB0aGVyZSBpcyBubyBzaW5nbGUgdmFsdWUgdG8g
cmVhZA0KPj4gIGhlcmUuIFNraXAgdGhlbS4NCj4+IA0KPj4gLSBTTUlEUl9FTDE6IEtWTSBkb2Vz
IG5vdCBzdXBwb3J0IFNNRSwgc28gdGhlcmUgaXMgbm8gbWVhbmluZ2Z1bCBob3N0DQo+PiAgdmFs
dWUuIFNraXAgaXQuDQo+PiANCj4+IC0gR01JRF9FTDE6IG5vdCBpbiBLVk0ncyBzeXNfcmVnX2Rl
c2NzW10gYW5kLCBiZWluZyBhbiBFTDEgcmVnaXN0ZXIsDQo+PiAgY2Fubm90IGJlIHJlYWQgZnJv
bSB1c2Vyc3BhY2UgdmlhIE1SUyBlaXRoZXIuIFRoZSBndWVzdCByZWFkcyB0aGUNCj4+ICByYXcg
aG9zdCB2YWx1ZTsgdGhpcyBpcyBhIGdlbnVpbmUgbWlzcyB3aGVuIE1URSBpcyBlbmFibGVkLg0K
Pj4gDQo+PiBTaWduZWQtb2ZmLWJ5OiBLaHVzaGl0IFNoYWggPGtodXNoaXQuc2hhaEBudXRhbml4
LmNvbT4NCj4+IC0tLQ0KPj4gdGFyZ2V0L2FybS9rdm0uYyB8IDUzICsrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKystLS0tLS0tLQ0KPj4gMSBmaWxlIGNoYW5nZWQsIDQ0IGlu
c2VydGlvbnMoKyksIDkgZGVsZXRpb25zKC0pDQo+PiANCj4+IGRpZmYgLS1naXQgYS90YXJnZXQv
YXJtL2t2bS5jIGIvdGFyZ2V0L2FybS9rdm0uYw0KPj4gaW5kZXggNDJmZjczMWY2ZS4uNjk3NGU1
YzU1MSAxMDA2NDQNCj4+IC0tLSBhL3RhcmdldC9hcm0va3ZtLmMNCj4+ICsrKyBiL3RhcmdldC9h
cm0va3ZtLmMNCj4+IEBAIC0zMTEsMTUgKzMxMSw1MCBAQCBzdGF0aWMgaW50IGdldF9ob3N0X2Nw
dV9pZHJlZ3MoaW50IGZkLCBBUk1Ib3N0Q1BVRmVhdHVyZXMgKmFoY2YpDQo+PiAgICAgICAgIGlu
dCByZXQ7DQo+PiANCj4+ICAgICAgICAgcmVnID0gJmFoY2YtPmlzYXIuaWRyZWdzW2ldOw0KPj4g
LSAgICAgICAgcmV0ID0gcmVhZF9zeXNfcmVnNjQoZmQsIHJlZywgaWRyZWdzX3N5c3JlZ190b19r
dm1fcmVnKHN5c3JlZykpOw0KPj4gLSAgICAgICAgaWYgKHJldCkgew0KPj4gLSAgICAgICAgICAg
IGlmIChlcnJubyA9PSBFTk9FTlQpIHsNCj4+IC0gICAgICAgICAgICAgICAgd2Fybl9yZXBvcnQo
IiVzIGVycm9yIHJlYWRpbmcgdmFsdWUgb2YgaG9zdCAlcyByZWdpc3RlciAiDQo+PiAtICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAiKEVOT0VOVCkiLCBfX2Z1bmNfXywgc3lzcmVnZGVz
Yy0+bmFtZSk7DQo+PiAtICAgICAgICAgICAgfSBlbHNlIHsNCj4+IC0gICAgICAgICAgICAgICAg
ZXJyb3JfcmVwb3J0KCIlcyBlcnJvciByZWFkaW5nIHZhbHVlIG9mIGhvc3QgJXMgcmVnaXN0ZXIi
DQo+PiAtICAgICAgICAgICAgICAgICAgICAgICAgICAgICIgKCVtKSIsIF9fZnVuY19fLCBzeXNy
ZWdkZXNjLT5uYW1lKTsNCj4+IC0gICAgICAgICAgICAgICAgZXJyID0gcmV0Ow0KPj4gKyAgICAg
ICAgc3dpdGNoIChpKSB7DQo+PiArICAgICAgICBjYXNlIERDWklEX0VMMF9JRFg6DQo+PiArICAg
ICAgICAgICAgLyoNCj4+ICsgICAgICAgICAgICAgKiBEQ1pJRF9FTDAgaXMgbm90IGluIEtWTSdz
IHN5c19yZWdfZGVzY3NbXSwgc28NCj4+ICsgICAgICAgICAgICAgKiBLVk1fR0VUX09ORV9SRUcg
d2lsbCBmYWlsLiBSZWFkIGl0IGRpcmVjdGx5IGZyb20NCj4+ICsgICAgICAgICAgICAgKiBoYXJk
d2FyZSBzaW5jZSBLVk0gZG9lc24ndCB0cmFwIGd1ZXN0IHJlYWRzIG9mIGl0Lg0KPj4gKyAgICAg
ICAgICAgICAqLw0KPj4gKyAgICAgICAgICAgIGFzbSB2b2xhdGlsZSgibXJzICUwLCBEQ1pJRF9F
TDAiIDogIj1yIiAoKnJlZykpOw0KPj4gKyAgICAgICAgICAgIGJyZWFrOw0KPj4gKyAgICAgICAg
Y2FzZSBDQ1NJRFJfRUwxX0lEWDoNCj4+ICsgICAgICAgIGNhc2UgQ0NTSURSMl9FTDFfSURYOg0K
Pj4gKyAgICAgICAgICAgIC8qDQo+PiArICAgICAgICAgICAgICogQ0NTSURSX0VMMSBpcyBub3Qg
YSBwbGFpbiBJRCByZWdpc3RlcjogdGhlIHZhbHVlIGl0DQo+PiArICAgICAgICAgICAgICogcmV0
dXJucyBpcyBzZWxlY3RlZCBieSBDU1NFTFJfRUwxLCBzbyB0aGVyZSBpcyBubyBzaW5nbGUNCj4+
ICsgICAgICAgICAgICAgKiB2YWx1ZSB0byBjYXB0dXJlIGhlcmUuIEl0IGlzIGV4cG9zZWQgdG8g
dXNlcnNwYWNlIG9ubHkgdmlhDQo+PiArICAgICAgICAgICAgICogdGhlIERFTVVYIEFQSSAoS1ZN
X1JFR19BUk1fREVNVVhfSURfQ0NTSURSKSwgaW5kZXhlZCBieQ0KPj4gKyAgICAgICAgICAgICAq
IENTU0VMUi4gU2tpcCByZWFkaW5nIGl0IGhlcmUgYXMgdGhlcmUgaXMgbm8gbWVhbmluZ2Z1bCBo
b3N0DQo+PiArICAgICAgICAgICAgICogdmFsdWUgdG8gcmVhZC4NCj4+ICsgICAgICAgICAgICAg
Ki8NCj4gSSB0aGluayB5b3Ugc2hvdWxkIHJlbHkgb24gcHJlcmVxdWlzaXRlDQo+IFtQQVRDSCB2
NCAzLzNdIGFybS9rdm06IGdldCBkZW11eGVkIElEIHJlZ2lzdGVycyBmcm9tIGt2bQ0KQ3VycmVu
dGx5IEkgYW0ganVzdCBza2lwcGluZyB0aG9zZSBhcyBhbnl3YXkgS1ZNIGV4cG9zZXMgYSB2ZXJ5
DQpiYXJlYm9uZSBDYWNoZSB0b3BvbG9neS4NCg0KQWdyZWVkIG9uIHVzaW5nIERFTVVYIHJlZ3Ms
IGluIGNhc2Ugd2Ugd2FudCB0byBzdXBwb3J0IGV4b3BzaW5nIHNvbWUgb3RoZXINCuKAnGNvbmZp
Z+KAnS4NCg0KQWxzbyBvbiB0aGlzIHBvaW50LCBJIGRvbuKAmXQga25vdyBpZiBDQ1NJRFJfRUwx
L0NDU0lEUjJfRUwxIHNob3VsZA0KYmUgcGFydCBvZiBpZHJlZ3NbXSwgd2UgYWxyZWFkeSBoYXZl
IGEgY2NzaWRyW10sIG1heWJlIHRoaXMgY2FuIGJlIGZpeGVkDQppbiB5b3VyIHNlcmllcy4NCg0K
Pj4gKyAgICAgICAgICAgIGJyZWFrOw0KPj4gKyAgICAgICAgY2FzZSBTTUlEUl9FTDFfSURYOg0K
Pj4gKyAgICAgICAgICAgIC8qDQo+PiArICAgICAgICAgICAgICogQXMgU01FIGlzIG5vdCB5ZXQg
c3VwcG9ydGVkIGJ5IEtWTSwgaWdub3JlIHJlYWRpbmcgU01JRFJfRUwxDQo+PiArICAgICAgICAg
ICAgICovDQo+PiArICAgICAgICAgICAgIGJyZWFrOw0KPj4gKyAgICAgICAgY2FzZSBHTUlEX0VM
MV9JRFg6DQo+PiArICAgICAgICAgICAgLyoNCj4+ICsgICAgICAgICAgICAgKiBHTUlEX0VMMSBp
cyBub3QgaW4gS1ZNJ3Mgc3lzX3JlZ19kZXNjc1tdIGFuZCBndWVzdCByZWFkcw0KPj4gKyAgICAg
ICAgICAgICAqIHRoZSByYXcgaG9zdCB2YWx1ZS4gQnV0IGFzIGl0IGlzIGFuIEVMMSByZWdpc3Rl
ciwgd2UgY2Fubm90DQo+PiArICAgICAgICAgICAgICogcmVhZCBpdCBkaXJlY3RseS4gVGhpcyBp
cyBhIGdlbnVpbmUgbWlzcyB3aGVuIE1URSBpcw0KPj4gKyAgICAgICAgICAgICAqIGVuYWJsZWQg
Zm9yIHRoZSBndWVzdC4NCj4+ICsgICAgICAgICAgICAgKi8NCj4+ICsgICAgICAgICAgICBicmVh
azsNCj4+ICsgICAgICAgIGRlZmF1bHQ6DQo+PiArICAgICAgICAgICAgcmV0ID0gcmVhZF9zeXNf
cmVnNjQoZmQsIHJlZywgaWRyZWdzX3N5c3JlZ190b19rdm1fcmVnKHN5c3JlZykpOw0KPj4gKyAg
ICAgICAgICAgIGlmIChyZXQpIHsNCj4+ICsgICAgICAgICAgICAgICAgaWYgKGVycm5vID09IEVO
T0VOVCkgew0KPj4gKyAgICAgICAgICAgICAgICAgICAgd2Fybl9yZXBvcnQoIiVzIGVycm9yIHJl
YWRpbmcgdmFsdWUgb2YgaG9zdCAlcyByZWdpc3RlciAiDQo+PiArICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgIihFTk9FTlQpIiwgX19mdW5jX18sIHN5c3JlZ2Rlc2MtPm5hbWUp
Ow0KPiB0cmFjZSBwb2ludA0KTm90ZWQuDQoNCldhcm0gUmVnYXJkcywNCktodXNoaXQNCj4+ICsg
ICAgICAgICAgICAgICAgfSBlbHNlIHsNCj4+ICsgICAgICAgICAgICAgICAgICAgIGVycm9yX3Jl
cG9ydCgiJXMgZXJyb3IgcmVhZGluZyB2YWx1ZSBvZiBob3N0ICVzIHJlZ2lzdGVyIg0KPj4gKyAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIiAoJW0pIiwgX19mdW5jX18sIHN5c3JlZ2Rl
c2MtPm5hbWUpOw0KPj4gKyAgICAgICAgICAgICAgICAgICAgZXJyID0gcmV0Ow0KPj4gKyAgICAg
ICAgICAgICAgICB9DQo+PiAgICAgICAgICAgICB9DQo+PiAgICAgICAgIH0NCj4+ICAgICAgICAg
dHJhY2VfZ2V0X2hvc3RfY3B1X2lkcmVncyhzeXNyZWdkZXNjLT5uYW1lLCAqcmVnKTsNCj4gVGhh
bmtzDQo+IA0KPiBFcmljDQoNCg0K
