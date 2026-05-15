Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43FDB49550E
	for <kvmarm@lists.linux.dev>; Fri, 15 May 2026 15:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778858863; cv=fail; b=rczDyq1nsUUTkv1PV08GKBnumUotr4tx/wJzknP8m1bvndQEaPyS0YyV/hqT/D/k8I13ftJ+AUpVwpxEvajs934hTbQTkhTxXoS6ui8+XYUs9C63yWDOJAHUyEqF8xHnhgzhAAxncZkDuIkykcN+KA5eC1igqxkGDNtdJNkH0Xc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778858863; c=relaxed/simple;
	bh=0thLVSrTLaA02sJWAOfFRjmiYRLb7qMKa7oX+WpiKmM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=PmG7r6/Z8y7PjZsp6MOU0vmxD/nZJn/wBEH3Xq/aLZRkWfF7PeLblMv44fJ2bIZQcNzSql7MEdFQxafe2e4KvPoypfB46597J563VMlkYtqXrksvMzEAm870OSpP9XiK2/ANy/7HWCpIzknXem7R5yzqTLrOglplAtQeGn9vXLc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=tAiq9679; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=nBFaCryD; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="tAiq9679";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="nBFaCryD"
Received: from pps.filterd (m0127839.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64F9mkXY3855732;
	Fri, 15 May 2026 08:27:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=0thLVSrTLaA02sJWAOfFRjmiYRLb7qMKa7oX+WpiK
	mM=; b=tAiq9679WOLoliTFMJ2ZUJKfW9PUwHpCaTS/nlVRyqBGJ4/6SOIGlvdIj
	mYT0KxvRWUp8TUl4TvG0iozeI3i2HVvKVQEX+DRkOWqe09E7Yse2u5Sj1f0krmeV
	IPPBJMuQRn+qeefjyJnNiIaDwssU3p3bXsWuaM0ywRCTL1d5VKntgxRsMkYbOE0b
	f05W6ly+i5U39uuoxK/u6AMjMKSzQuFtAax40h4XrpI9VruNxb+naD2ZFCofQ0BR
	AbBE58uKx/CMe9a/9rTmhw/u0h9cOW4Gah/tITa8By698FF/zz7BWU8CoBLFzyPg
	i36sQzExgSmutzmqwCk7/S1r4ZRcw==
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11023131.outbound.protection.outlook.com [40.107.201.131])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 4e5m282bkd-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 15 May 2026 08:27:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KllfkoRlf7gls3Am1QQp3TrGwE5anq3sskEtaa8MGiuZ2DCpyoi+wfMbCt+Qd6mnARi2tZZinZEzItILip65piw4Wk5h5PtobsRdNx5igkb5rbCgFrdcz9SdjdecK3iVdtYQ3lVxlooXhwY8V3P9lZOV8aVa2ONE5MCQiXofkHsv5sgirrQu+r1xRgoSHBSJ/CCQsj6DiCicnveRZL7gKcU9+g10SVTwJhFDXJofr19j5vQ0XpAFrhoW3zR2dzTnmLsnDkR2O6iRz5YjYIHujRztyV6BeK5tfwPcEryMaGu6YCrkiDHmg2Djo6My7hP1Vagi9PHh1Zel1RK3pIpW+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0thLVSrTLaA02sJWAOfFRjmiYRLb7qMKa7oX+WpiKmM=;
 b=iVerWIeHnnCYzt48qlCKKQIhpxF0ksLVDwido6IYCPXMOD/PbzxeJTBrqgAwBSfieUpK+XOQDZmA+hTEt/UUVdpzRH4uauos4m1XQwLpCzKG9AzJAzI+/WHk/M67JDW3lB8ZHLyDcCetNPgLxzPPso0K3c9//qG3sIjPPBRf/XGdmCWqCjrzYkT1e1ESctn6VoW17jXKyYzVbLKidVP9D9UlBmdwehcV59U7M4FIAzbSJHMzlUqZDWLQhq48OfdU87SdYLiy2j6HAqMmMEee+wmEo1sfD83YzXHk2wLdl9RHQjNz1rN+PsCZiCkZSxZaHb/7WQ70oGNbj2ObMS+QNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0thLVSrTLaA02sJWAOfFRjmiYRLb7qMKa7oX+WpiKmM=;
 b=nBFaCryDs0/Xu5kvZWshw+0fPC1TcbZ5z4frKtqErnetZ4X/KS2LHoMMyqOCTSvI3h1guL9VcGEucXI9OCFlueTkPTqFkAQVU7/w+frKWlVlk6VkHZusXdgqzG4r4ebZAizec7js3BzLQanyX3N0Weee9a7u6ujj/aOlFdjMRJhYYMXDEQI0dr09uXngfFBT3m3cYYbozL/hLtVwvWYTsdPWQJS+9m3hbhdyjWt+410mHwob8Jl3QEa/++rhR41lTes/YLxGDHgJxNdutQ4NJS6Vyh+LOU7ecz/4MRtf/3dKh7G634LVPMFiW+4jDYUEh12mpnUReq9VU18s409JXQ==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by DM6PR02MB6940.namprd02.prod.outlook.com (2603:10b6:5:25a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.25.20; Fri, 15 May
 2026 15:27:23 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%6]) with mapi id 15.21.0025.019; Fri, 15 May 2026
 15:27:23 +0000
From: Khushit Shah <khushit.shah@nutanix.com>
To: "eric.auger@redhat.com" <eric.auger@redhat.com>
CC: Shaju Abraham <shaju.abraham@nutanix.com>,
        "qemu-devel@nongnu.org"
	<qemu-devel@nongnu.org>,
        "qemu-arm@nongnu.org" <qemu-arm@nongnu.org>,
        "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
        "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>,
        "richard.henderson@linaro.org"
	<richard.henderson@linaro.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "sebott@redhat.com" <sebott@redhat.com>,
        "skolothumtho@nvidia.com"
	<skolothumtho@nvidia.com>,
        "philmd@linaro.org" <philmd@linaro.org>,
        "maz@kernel.org" <maz@kernel.org>,
        "oliver.upton@linux.dev"
	<oliver.upton@linux.dev>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        Prerna
 Saxena <prerna.saxena@nutanix.com>,
        Jon Kohler <jon@nutanix.com>, Jonathan
 Davies <jond@nutanix.com>
Subject: Re: [RFC PATCH v1 02/13] target/arm: named_cpu_model: Add ID Register
 Fields
Thread-Topic: [RFC PATCH v1 02/13] target/arm: named_cpu_model: Add ID
 Register Fields
Thread-Index: AQHc4vZUSy91MSEtGEqhLU61tmz+/LYPJfuAgAASsgA=
Date: Fri, 15 May 2026 15:27:22 +0000
Message-ID: <189B12F2-68DF-4442-8657-D5F295F710DC@nutanix.com>
References: <20260513163356.3033159-1-shaju.abraham@nutanix.com>
 <20260513163356.3033159-3-shaju.abraham@nutanix.com>
 <0b9d0320-96ab-4ccd-9440-0c0494af5aaa@redhat.com>
In-Reply-To: <0b9d0320-96ab-4ccd-9440-0c0494af5aaa@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA2PR02MB7564:EE_|DM6PR02MB6940:EE_
x-ms-office365-filtering-correlation-id: d4325e00-1506-481b-4acf-08deb296761c
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|376014|7416014|10070799003|56012099003|22082099003|38070700021|18002099003|4143699003;
x-microsoft-antispam-message-info:
 8jQHVlpQKiMCqI+9XJ7UlYFwA/3n0nXn7Ax4jqGNM/RUgxo0SzeU1BV+bByNfzX/1k+tNCEkl6BSV9hhm7/2rhudSvqCBG9VcYiVXlVkXx39UelinRpz1OD9e+yxBAHQjlO+2SxH9yL7qnNfVmHbr+jXBcdPnAFhr0ERAe+s+qw5oye5KYHpvRc/l85dz/Q+1XDAuOom/9bw7RfmECtMH7hED1jCj+nNWcfdYxLhYcE5QDH6LIJ9LvLoamSV43NhMm1jGzoXG1uVkn7osaOPq2Fb9ALa6vPVQWrnqWH4o52vcAMuGCq174TAVPsM1TwT4vmgy1ZcP7TF6W934BAv38mpHuYMO5wVyhemd28W0fdw/YeZEYutW4U/rQZrkI3F+psRAzD4K8U3mgG/IaFaQJ8jeSXGzUhZTGIKl0JztZr3q9epDYRGRo58YKsbOptUMSHGe22+g/s5cG/W6XeueGvFYs9YCSEO3SoVSc0O9fTZ17/v7frZTif6PJjCFnfWcKzwqRdGHQmK5sQyuCHTC02CfR8yn6+fO3zuct8GI01YDz644Yhfl7bz3TWOArVCL4rTHLmQFFkZn0xDBwKFXgg8QL7VkW8PqSZmfD/IR1Ale5pPBNFhG4vQa3phxJOeVNNdYLVLKn3D0AFgmTfZeFA7QtU9apl5a9qlpctn1mw8uqOPI5aAt8fUuhOhkrywKFNtUuPQmFqG4RlCVWTEdvXXO1fwIiMp3xEhbE7EPmYNaNzADkUlpHP9RpuZup2g
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(10070799003)(56012099003)(22082099003)(38070700021)(18002099003)(4143699003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?NWp0eStaNytrT3pyZXkyZ29RVmI5eEtNSzNtb2JHQ05OUGtIRzVybjVueGJj?=
 =?utf-8?B?S20wdVhybmdaWGFKVnQ0ZllVL3dObEE4TnpLc0hFaXhXSlZsOVFBKzU0TE5z?=
 =?utf-8?B?YU5sZDNZUmZYdldXY2ZXSGhMYTZMeEFQY3BJbHpFUG00aTZCS01kbVEvRXBq?=
 =?utf-8?B?RVBMMWIramVNdFF3Q2hMWkhaL1hiRTFocUdvWTk2aVpsT3NIWFAyNVFkVVhr?=
 =?utf-8?B?Y2lyMSswcWc0TWJYcGN4N1BWcllhc0xMNk5sa1VSQy8wQ0FHZWV5YW5yR3ZN?=
 =?utf-8?B?cHBYV3B4ZGlpcDBxeDVaMFRtc0FTYU5EVm93a3FhSlA0M2RjVUxlOHMxK1l2?=
 =?utf-8?B?YXRodEFPS0tFdmFBL0g4Q2MwcGdRQmVwc3FFTmtEUk1pbWYwRVdkb1dDbnAx?=
 =?utf-8?B?aWhlT2hpd1o2S3NOQkI0VUlZRmk1dm5HNVhFM2lYakFPOXltelNJOTJacmtx?=
 =?utf-8?B?ZzYyUURCbVFrZXdobkNiVUQxb2tkU3BDQXo4cUtJQmFOT08wREJDN3Vwa0Mw?=
 =?utf-8?B?b3p3YWRwaFozS091OU1LakxtUk0ySWc5MWwxRmQrSTMvQ1NMUXpwOWRRMnRi?=
 =?utf-8?B?U2ZHUWdmVGRNdUxWU2ZWdFZSQ2tXUlRDTE4yODZzM3RRTkdyU2hVcFE0eEZZ?=
 =?utf-8?B?UWlwWFkzelBhSzlzR2lCbVlRN2dnbWF4aWxtdzluTkZjOE13NVJBbUVOOEk0?=
 =?utf-8?B?ZUx4ZUZocXZIWXJyTERhb2VRcXpPaVYwWEdmc1FVRTNVR0ZHdzc1QnAvNmt2?=
 =?utf-8?B?MzgzMnZWV1RMbldNenNNMS9EN0JLNTVtV0RSMEcyWlY1Y1A0dkluSXg5RmQ1?=
 =?utf-8?B?MWxwSnU0a0RKSVV0N0huQ1JwZFJyMmZSeVFGSnVRV0R2eU03dzIwTG1VUUNw?=
 =?utf-8?B?QnFVWDlDZjdNMlREOTJ5eWxyY0JTQ1dNc0syMWwxOVVkMlcwM0s3ZkxoSDJR?=
 =?utf-8?B?eGRpbVZRZjZzVG03M2FTbjY0bmg0Tzk4RDhlSlFvS21QbWQ0MllTREc5ZGs5?=
 =?utf-8?B?UGJPcWFSdVZwN29adENzLzhZQlZaY2VncUhyM2I0eGVnU0V3YjVZZmdhSGR1?=
 =?utf-8?B?MzFSa0Y4U0dUbmNhZzRqeTZmMzdEZDZhZUxNWHVMYU81aTZxcy9maFA5c3VG?=
 =?utf-8?B?dnpNdGhvejQxK1h0MC92TGJmRlM3cE1nbTVDTHVHUkw0V0xMWDVRRVplRUkv?=
 =?utf-8?B?aUFOYjVKL2tRczhXeXpUQ2NCS0xsNFdyZ2gydkVwUEl6SExzeU1Eb1JUTEpS?=
 =?utf-8?B?UVJHTW5EUFNqWjVwTmxWTzRYNjdJOVg4dWxYZWdCZVZObFZzZy9CcjRuajc5?=
 =?utf-8?B?N3VkZ3VrcExETzNvQ0U4OC94aUM2UCtGeWlzY3I5Y2F6TVdOTWhZczdjdVMz?=
 =?utf-8?B?Wmw5OWtqbGU0QUh5b0RMWStLNW14L1pqRVZWMnBveDFwQkZuMW1aNVpwU1lw?=
 =?utf-8?B?RTNQQnVtWDRUQmRnSXYvWnJ2OHZpUUwxQnZ1eThUK1dpVHBlZzR6cFdoaW15?=
 =?utf-8?B?TjkydFlSRTM3Q1BFcEo4aHl3ZW50VVU5Vjg0YURRNGI5czRFTkl1a0F3Z3dl?=
 =?utf-8?B?YTZGQ0FrUFVzUEltT0loSFR4ZDZrU3lqQklVVEthNkFPRjdXYzgxYzE5emtt?=
 =?utf-8?B?Mnpocng1Y2hnUGZ0SGlPQVlta0VxYlBHZHBSRzJTRjdiTitwYWZGZnlTb2Yx?=
 =?utf-8?B?dmpUNG5HaUZ2K1NZWjFyRzBVa2pVVVNFaEJCeG5iZkFZdXhDdEIyNVJvekpP?=
 =?utf-8?B?ME9WblBPa0tSSXZNUE9UaFFwTjdhSTBtUU5GenAvVDNOWG9kUzhiVFpVUWNB?=
 =?utf-8?B?enhJYXdCQXVmd0dIa0xyYUZkekRMTlExRHhMRUxEZE9RaFUvU3JMejhXTTZu?=
 =?utf-8?B?a01ZdmwzRlVJckNPMzY0S2szTXc3RXgrRElINU8vL2JtZWh1eERvN1JiVHJT?=
 =?utf-8?B?MEcyaGxDM2IwTEdjSEVES0Q3ZlNwanByajhYRVdFR09DNnBhaC9YTW0zUEFJ?=
 =?utf-8?B?NEM2d1pLQ1VhUjFTL1JyL1RVQlk3YURsUjU3Nm5WWWJhK2VwOHpMMmtDdTlE?=
 =?utf-8?B?YzN4azZPUjU2ajNhMDM3TmZJeU9WUkMzRGxldEhuUXpjOVhBUXJsWG1rVlRm?=
 =?utf-8?B?K0Ira2c2T3k0dWJTT1kwd2EzWEpIME5VYm5mbEllZlorVmZEb3NLalBvUW95?=
 =?utf-8?B?STNyYmp1Qmk2VW9DNXlncVpYRm5UOHdXck95QzNrK2FxYnRjbEFESVBIcTJD?=
 =?utf-8?B?NW5TeEFHUCtoYWp5dUVNcFZKZXRQUkFzSVFSQ0JTYkdtSHhQaFNiL29jdWdQ?=
 =?utf-8?B?Tk9BZUQyRlduL2orUDhaQVE2dmcySXlYNFpzR01UWTczZzR1amhEUTZlTXJJ?=
 =?utf-8?Q?BETCicRH9eikjfUcdG4+MbmkRmr4Z2TX23CfJ2ibDSF8G?=
x-ms-exchange-antispam-messagedata-1: 13rIVQox/2iXDs1lHZgfGXJt7Qg9cJEp/dU=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7AE6CC63B3950B4EB423508F90638994@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	R6rRJzMckgzyKMAOaDCtUeHvMBxK/hmX6Y6iLx5Cr8juyTP++1jgbPTq8OakXHz0PMi2efNrHv2jnIBQ0wevZn7PKQaBHVYqV9svMSmvVke+yYhuBpDKVt9I9jRjoyFz+Gipm5Q8MoeA7zDLdCovPOmGGrFMKKYmq8OGxy8SDNbID/dVuiFkkrgeiLXDBWWyH4QfLd+PFF3x8d5j2B6oKE8u3Pzfvq+l5KfzBbMLBIWV2uuMlfotovxmbEhvuRcHvHQmLzvw4gGcD4uqP061VQwubGmYJQg2o0NP+ECb1QGZIUonUleFD3AC1JRUMl6BboD5F+r5Pjq18CnvxGB78A==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4325e00-1506-481b-4acf-08deb296761c
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 May 2026 15:27:22.8913
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1RNUYZtCSnkM7CTxBlWM3OeDbxa1A5/o2AP/DSn9qZs1Q+fDK6sTjKcO2E40aDX4ZFqoRk3B7cWzzm/gBHxXES38/o2FUsD9P/B4+l5ZSS8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR02MB6940
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTE1MDE1NyBTYWx0ZWRfX6sLL2CmAUnFM
 mLS80qCnizpUUO8aBeOco7lr93GX8utW/W4zgtu9R4Fgpy0WPr7LzxDX6smWy+OXzf26EusTzvb
 8aofBM87N0N59MPRKY8BzcQa5vfdfU8XSQ+VsaEgNXFudVgAAyljZWG47292m4Vvt9wpeZaVHjh
 f7WjhDquCkcIHep6fhsX+V8I4Zcd5drRz6GQT5jKW0QCJp26lECkpbApusgqdwOQlFu+d0cuKjw
 qRDDLq5+/Sl6ryZfg4rWBTOzkQd9GHTKfwOKYs18lex/GE2LICMBzffrV0o5SkKfeMBpqDLsbib
 fyN+1WQYU7519sJE//syQqcM4fwn1/A3eYCKR4EviR9dKRX0hIJBLUI2ok1PThC6FDnbMWhVOz1
 UexrZVRNmt1bpI0KsiV3MX2Q2QANpTfy1YjbbrbfZd+POsbVaZW92wgjiD6VKku3X4+wUjELKR0
 Ht4Q1ths/xkeb1+6d2Q==
X-Proofpoint-GUID: h-ZkxYMM8SMze1ASueoX5tVgM4cpz3GH
X-Authority-Analysis: v=2.4 cv=eYsNubEH c=1 sm=1 tr=0 ts=6a073b5d cx=c_pps
 a=YiOwH4ClqGLeqjbxKXDYtA==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=NGcC8JguVDcA:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VofLwUrZ8Iiv6rRUPXIb:22 a=y4UcunY2MAxhM4LwGdWI:22 a=IHM9SOEswRhOewKk2uIA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: h-ZkxYMM8SMze1ASueoX5tVgM4cpz3GH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-15_03,2026-05-15_01,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQo+IE9uIDUvMTMvMjYgNjozMyBQTSwgU2hhanUgQWJyYWhhbSB3cm90ZToNCj4+IEFkZCBhIGRl
Y2xhcmF0aXZlIGRlc2NyaXB0aW9uIG9mIGV2ZXJ5IGFyY2hpdGVjdHVyYWxseSBkZWZpbmVkIGZp
ZWxkIGluIHRoZQ0KPj4gQXJtNjQgSUQgcmVnaXN0ZXJzIGluIGNwdS1pZHJlZ3MuaC5pbmMgZmls
ZS4gVGhpcyBmaWxlIHdpbGwgYmUgaW5jbHVkZWQNCj4+IG11bHRpcGxlIHRpbWVzIHdpdGggZGlm
ZmVyZW50IGRlZmluaXRpb25zIHRvIGJ1aWxkIHRoZSBwZXItZmllbGQgYXJjaCB2YWx1ZXMsDQo+
PiBwZXItcmVnaXN0ZXIgZmllbGQgZGVzY3JpcHRvciBhcnJheXMsIGFybS1pZHJlZ3MgdGFibGUg
ZXRjLiBUaGUgYXJjaGl0ZWN0dXJlbHkNCj4+IGRlZmluZWQgdmFsdWVzIGZvciBlYWNoIElEIHJl
Z2lzdGVyIGZpZWxkIGlzIGV4dHJhY3RlZCBmcm9tIGtlcm5lbCdzDQo+PiBhcmNoL2FybTY0L3Rv
b2xzL3N5c3JlZyBmaWxlLiBUaGUgc2FmZS12YWx1ZSB0YWdzIGFuZCBkZWZhdWx0IHZhbHVlcyBh
cmUNCj4gSW4gdGhlIHBhc3Qgd2Ugd2VyZSByYXRoZXIgYWR2aXNlZCB0byB1c2UgQUFSQ0hNUlMg
aW5zdGVhZCBvZiBzeXNyZWcuDQo+IFRoaXMgaXMgd2hhdCBpcyBjdXJyZW50bHkgZG9uZSBpbiBb
UEFUQ0ggdjQgMDAvMTddIGt2bS9hcm06IEludHJvZHVjZSBhDQo+IGN1c3RvbWl6YWJsZSBhYXJj
aDY0IEtWTSBob3N0IG1vZGVsLg0KDQpJIGFtIG5vdCBzdXJlIGlmIHdlIGNhbiBnZXQgc2FmZSBy
dWxlcyBmcm9tIEFBUkNITVJTLiBPdGhlcndpc2UgaXTigJlzIGZpbmUuDQoNCj4+IGRlcml2ZWQg
ZnJvbSB0aGUga2VybmVsJ3MgZnRyX2JpdHMgYXJyYXkuIEFhcmNoMzIgSUQgcmVnaXN0ZXJzIGFy
ZSBhZGRlZA0KPj4gd2l0aCBkdW1teSBmaWVsZCBzbyB0aGV5IGNhbiBiZSBkZWZhdWx0ZWQgdG8g
MCBieSBsYXRlciBjb21taXRzLg0KPj4gDQo+PiBYLW1hY3JvIHN0cnVjdHVyZToNCj4+IElEUkVH
X1NUQVJUKFJFRykNCj4+IElEUkVHX0ZJRUxEX1NUQVJUKFJFRywgRklFTEQsIFNISUZULCBMRU5H
VEgsIFNBRkVfUlVMRSwgREVGQVVMVF9WQUwpDQo+IFdoeSBkbyB5b3UgbmVlZCBTQUZFX1JVTEUv
REVGQVVMVF9WQUw/IEFzIGZhciBhcyBJIHVuZGVyc3RhbmQgdGhpcyBpcw0KPiB1c2VkIHdoZW4g
d2UgaGF2ZSBkaWZmZXJlbnQgZmxhdm91cnMgb2YgQ1BVUyBpbiBTTVAgYW5kIHdlIGZhY2UNCj4g
bWlzbWF0Y2hlcyBiZXR3ZWVuIENQVSBmZWF0dXJlcy4gV2h5IGRvIHdlIGNhcmUgaGVyZT8NCj4g
DQo+IEkgZG9uJ3Qgc2VlIHNhZmVfcnVsZSB1c2VkIGFueXdoZXJlLg0KPiBJIHNlZSBhcm1faWRy
ZWdzX3Jlc2V0X3RvX2RlZmF1bHRzKCkgdXNlcyB0aGUgZGVmYXVsdCB2YWx1ZSB0aG91Z2guDQo+
IFNob3VsZCB3ZSB1c2UgdGhlIFJlZ2lzdGVycy5qc29uIHJlc2V0IHZhbHVlIGluc3RlYWQ/DQoN
Cktlcm5lbCB1c2VzIHNhZmVfcnVsZXMgdG8gc2hvdyBhIGNvbW1vbiBkZW5vbWluYXRvciBvZiBj
cHUgZmVhdHVyZXMgaW4gU01QIGFuZCBzYW1lIHJ1bGVzIGFyZQ0KdXNlZCBieSBLVk0gdG8gdmVy
aWZ5IGlmIGNlcnRhaW4gZmllbGQgdmFsdWUgaXMgdmFsaWQgdG8gc2hvdyB0byBndWVzdCBvbiB0
aGUgZ2l2ZW4gaG9zdC4NCktWTV9TRVRfT05FX1JFRyB2YWxpZGF0ZXMgdGhlIHdyaXRhYmxlIGZp
ZWxkcyB3aXRoIHRoZSBTQUZFX1JVTEUgZGVmaW5lZCBpbiBmdHJfYml0cyB0YWJsZS4NCg0KU28s
IFNBRkVfUlVMRSB3aWxsIGJlIHVzZWQgaW4gdjIgdG8gdmFsaWRhdGUgaWRyZWdzIGV2ZW4gYmVm
b3JlIHdlIHdyaXRlYmFjayB0byB0aGUgS1ZNLCBhbmQgdG8NCnBhc3Mgc3VwcG9ydGVkIGZpZWxk
IHZhbHVlcyBmb3IgYSBwcm9wZXJ0eSBvbiBhIGdpdmVuIGhvc3QgdG8gbWFuYWdlbWVudCBzdGFj
ayAobGlidmlydCkuIFNvbWV0aGluZyBsaWtlDQpmZWF0X0FFUyBzdXBwb3J0cyAob2ZmLCBhZXMs
IHBtdWxsKSBvbiB0aGlzIGhvc3QuDQoNClJlZ2lzdGVycy5qc29uIGNhbiBwcm9iYWJseSBiZSB1
c2VkIGZvciBkZWZhdWx0X3ZhbHMsIGJ1dCBJIHdpbGwgbmVlZCB0byBjaGVjayBmdXJ0aGVyIG9u
IHRoaXMuDQoNCkluIHNob3J0OiBkZWZhdWx0X3ZhbHMgLT4gc2hvdyBubyBmZWF0dXJlLg0KICAg
ICAgICAgICAgICAgc2FmZV9ydWxlIC0+IHZhbGlkIHZhbHVlcyBmb3IgZ3Vlc3QgZ2l2ZW4gaG9z
dCB2YWx1ZXMuDQoNCj4gdGFraW5nIEZITSBmaWVsZCBpZiBJIGNvbXBhcmUgd2l0aCBzeXNyZWcg
SSBoYXZlOg0KPiBVbnNpZ25lZEVudW0gICAgNTE6NDggICBGSE0NCj4gICAgICAgICAwYjAwMDAg
IE5JDQo+ICAgICAgICAgMGIwMDAxICBJTVANCj4gICAgICAgICAwYjAwMTAgIEYxNkYzMkRPVA0K
PiAgICAgICAgIDBiMDAxMSAgRjE2RjMyTU0NCj4gU28gd2h5IGRvIHdlIG1pc3Mgc29tZSB2YWx1
ZXM/DQoNClRoZSB0YWJsZSB3YXMgY3JlYXRlZCBiYXNlZCBvbiBzeXNyZWcgZmlsZSBpbiA2LjE4
Lg0KQSBzY3JpcHQgYWRkZWQgdGhlIGFyY2ggdmFsdWVzLiBSZWdpc3RlciwgRmllbGRzLCBzYWZl
IHZhbHVlcyBhbmQgZGVmYXVsdCB2YWx1ZXMgYXJlDQptYWludGFpbmVkIG1hbnVhbGx5Lg0KDQpX
YXJtIFJlZ2FyZHMsDQpLaHVzaGl0DQoNCg0K
