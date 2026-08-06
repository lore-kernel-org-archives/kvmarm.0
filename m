Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE3D1377A80
	for <kvmarm@lists.linux.dev>; Thu,  6 Aug 2026 04:52:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785991941; cv=fail; b=omY2C6ni34D4TX/TrVdHIaAh6uaqt7dE4mWHOLdwSPVBzY4rUCG1UcJlMVXtjtWOE1PNhiyCrgq8cjGil50guSRSZ9lc56nyk29vkCod66XhpYpndTuu2JKDGqsk3E//jdGh3kFbqvUx9RIn9ViP8HL6ckoABr1I4QRHVwtQtTk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785991941; c=relaxed/simple;
	bh=SuCQ6amrIAApUWAVtJME6ktKzkF2MANPyliLsjHCShg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=efRs248jFXWWMkqulbPYj5nO+TCCWyYGDrSLrm2IvJhbExyuHn1LPx1M+T7yVU+x29cDS2NHcxwIYBfh/FgpeUQ3Opl6uo3CBMtAJZl54E6f0urMTmG6w65owXKHKV8PtxbfRm3/a39tU+BDlmW3BnmVM0X5Sb8OOMt717SLPqA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=IX3kJWpZ; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=bAaOLxM6; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="IX3kJWpZ";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="bAaOLxM6"
Received: from pps.filterd (m0127839.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 675NXwPY700896;
	Wed, 5 Aug 2026 21:52:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=SuCQ6amrIAApUWAVtJME6ktKzkF2MANPyliLsjHCS
	hg=; b=IX3kJWpZFxgW9BRISNcEGLhsCs8BLgzg0E0+PLQ1oZNDrrItlHdw5n/JS
	6QKJYOMfjWQhN38zOAPPbKb76T/BgJfETxloKB0LuJVDcFJb3071ZAdfdRfwlXR2
	HJJrCZphPFhnX+0HURqH37KlWkob4DWNBKOEFj7DDFCoftgjAmBNy6MzhINhQgBS
	dHlC6wgViP0JLOLuBTmBi3QqpXsnuJJiAz5ISzvC+niS+OlWFFzOKpYp37AiArSe
	NX+7cwoXcw4fqi8rHmyHjUgHPcNVFRzp2AbwwGA+QpxhoeTe2WVDXwSRJRJ0Xgsm
	WT+X3prWlY9Eu0mFx/e4r9QTjCwYg==
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11022093.outbound.protection.outlook.com [52.101.43.93])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 4fujeqcxc4-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 05 Aug 2026 21:52:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VAipT2sCPleR4fYIqh10cDlo7K2u69vScWhackPHjhTvtB3oJRPpIIH0QDB1bit/auG8AUPpPJrjxPsWvEQ0gTVtA63/ib0O3xr0M8HfPNP/3G7YIrarONBL0QmiY1CHQEliGIAa07Ef6qjXOnfXsF0aQS40Uw841R4Y9DKBwzPYzz7C/YQvy3nkZmje/1YuN8vJ1qXwQPmHqBBYI/p9FD91i+UmpDGS608YO2zv3qgCwpMQKU6LvVuSnnX0F5WXPkpIJbU/HKn7FcTJIN2wCkXi8e95JUcj+3NrMRwrQKrYXgGMMl3aekeSDybHM4pD9DhE77cGic0o7giXNLIZhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SuCQ6amrIAApUWAVtJME6ktKzkF2MANPyliLsjHCShg=;
 b=TLagr4O/s42x1U+pPQ2kW0CL5FgiOSf3gl/RnjIqUtzhWbLAZ1GWFVnjswZlCbG3MAwLRBB0w6QMiKgtHuUR4aprmeqcffcXMV4ze5FOAdBkg+nCNqV6nk1OGYqybbe2hd983nfecgcP7r8ZhNYSh67F7lIv7IQMiNELAzppeHVFv8QAuKjuEKf0JTIYjcyjKAckTJqIt3jWDNdMbWst/GTskzxLUm2LSy2WuuTd58rSb419BC3HYEmVPPC7bGgNTZeFWY/kaMDHAE/fKoY9iuj+vQNyU85qgnlC3i9zVCNQzkcdztbhAIKpgM2AYsYODXaCaaoVgaVXMN9JqNxPdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SuCQ6amrIAApUWAVtJME6ktKzkF2MANPyliLsjHCShg=;
 b=bAaOLxM6dC69DO4Ic4Vc7u2C/XI5OySZzy5mtHkAQ3LJRPCvCWRxylmCVlqUugwxn1ppRZOiJrIkIKjbl/NUmKCvcMZrDXbAlgV4m4+ZhDw9t0L3UK2wOyRxEVkpPbYZVzEfxQcrsZQFVD/L4P/j2rAB+zhe0TyO9F+flsgGtS4VK4Xhlvtu/x+EpX/wTXyQSS0Aw73pHGGRDjrFzFMbiDnUqcFHP0+2a20Dz9DDlcMBAMYBTluF+S7N1gQe5Atzxy0hQL0g4GjTHlVAcS8vIMTBLc6PWpJwvh5BpCezyFbwYh2ZE9gcJ1cdbrSNuVAYVKfTtoEddUuMEr7obMjlHw==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by SJ2PR02MB9341.namprd02.prod.outlook.com (2603:10b6:a03:4cb::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.16; Thu, 6 Aug
 2026 04:52:02 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%5]) with mapi id 15.21.0292.019; Thu, 6 Aug 2026
 04:52:00 +0000
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
Subject: Re: [RFC PATCH v7 10/18] target/arm/kvm: Retrieve writable ID reg map
Thread-Topic: [RFC PATCH v7 10/18] target/arm/kvm: Retrieve writable ID reg
 map
Thread-Index: AQHdHRREbtlaDk/39UmM5UTUuf5X8LaQhG0A
Date: Thu, 6 Aug 2026 04:52:00 +0000
Message-ID: <650A3325-5A8A-477A-9E60-D1D02363FA19@nutanix.com>
References: <20260726153221.24773-1-eric.auger@redhat.com>
 <20260726153221.24773-11-eric.auger@redhat.com>
In-Reply-To: <20260726153221.24773-11-eric.auger@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA2PR02MB7564:EE_|SJ2PR02MB9341:EE_
x-ms-office365-filtering-correlation-id: b9dde7ab-0f5e-454d-dc75-08def37673cb
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|23010399003|7416014|376014|56012099006|10067099003|4143699003|6133799003|22082099003|18002099003|38070700021;
x-microsoft-antispam-message-info:
 EciykAEWmg9nAqYqkMgU7ZXZKTDjmCeP28l9KRdvDOitmqk2gmE/QIBYFoMa0/+lQk9EOQnQxahGi3RKlxxDKmGSgp6ghnW95qmgptw3VJtz7FExgk79TcP3yU9V0rI4qx5dMrEH0WWVj0ZWmw0fl1tncGonzlgvNCbgFchm/DoNRKWMwOqnYLUMFFMXQxpQ6xN/lHbE08SvB3WD8vSI6mU53pDvwEx03rwmK0jv+JNgXnHsGxtFr24HSqiFYl1JQFdHqWAYkpcr4NdcqJJVfcP4omnjYaBuyVWg24MLm78Ydyxljoq27glLCP97PrB9fNsoah+54yL+xtojSOMDZtlzOQHrnIhOTS/amfWsq0FZgerD4vvUnfJ7G68YGE48RD+XwammsWb/onkSH23GYZzx+Ta9UWWc43sF8NZX41PBBlMSJpVUGW2HBU91KGYbQHZtmWh7uJWzXB7J+iPGOzsg4ctGfT6XDo/HWNBHnbkAMgccViTmvebvOsB8gJ30CAmLZcrU+EZ8HHgHVp+hAmAkWW7shtQq56yP3P5SOkb8jMiJcdtJwkfofckZHuReaiOa1Vby42JJVDNLsogMPnJUJ3w66ff26R5YcsK0zofPQyZxia/Dk9RO6wY+fhDTY/yAXZGW4/3nm0lD3Y2FLiaUdUpvmpEGfBg8IYFJiQrfkukKyjAT5nqeLJ6YHrKm3NBzQJuk1hHZX5MO2q8fbMTiC/3lNvrodpZ4LXslfX4=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(7416014)(376014)(56012099006)(10067099003)(4143699003)(6133799003)(22082099003)(18002099003)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?SmpJWTN6OGkyZThjTEpVOGlvaDJXUFpObFQwSFFyTURGRVR3SGt2MnBQSjJO?=
 =?utf-8?B?N2pDSWlMVXI0QTBhZWZ3Qi9EdTBMbFlERDBaQ0NDNWJVQlh6M0l3Ni93UzFm?=
 =?utf-8?B?VEVPcGFGYUhjemZOYVJKME1rVEM1c1E1ckdIeDE1Um5IWmZtbzFDeTVsK0Nq?=
 =?utf-8?B?VjI0S2FOT3FzZGtYa3FOTGUxMkN4aHVyYStWcVhjL1AvMjIxRGJ2S2RwS0lL?=
 =?utf-8?B?TlZURm5sTWs0cExjdmJWNWdGOHZaUzJmcGpkNXpLNXNRN1drNGRnNTd4N3hM?=
 =?utf-8?B?NldHWEJ4WFpvWFNuallRcy9Na3RVZVhLWU10bTlSR3Mva01abmVoK3NOSTk0?=
 =?utf-8?B?dzRzMmZMbkh2U1Q1MHYycUNWMk1TNWc4VExYOHVpS1BpcGNkbUh4ZlVUVjIx?=
 =?utf-8?B?MzNUODZmZ2pheHNnODJ0WUZYZUYxRHcvNEpZa0tSMjRlZ1pYRFdhOHIzVmUx?=
 =?utf-8?B?czYwZGNFQ0pmNmRvVVI0VVdhSkVhc3gxajN5RmIxd0tCQTlaQmFlZEs5WGFl?=
 =?utf-8?B?SXlOeEliUWFsY2k1RlpCaExrMXEzRFBCdjNXSnlyL05hdHNVVjZuWEF0QW1F?=
 =?utf-8?B?M0FlY3RYODFCdnBjNFZjeE5rbWRaZ3RnVlBYSVB0ZTJPaW9RVWgvSXBHWUhh?=
 =?utf-8?B?cjZTaWJ5MEhrNHdYZTAvOGhYaVNRQzRwT0ZGZDkwbHhqZ2I0N2NqQk93Sks3?=
 =?utf-8?B?eXdDUTBLNGFyS0FHS0c4SWo3b0k5U0xVcFZoNDk1UDlWUkcxNGhPRE4vOEVu?=
 =?utf-8?B?cXBoZjJNUHppeFlTVHVqRTdzTFBDMnV4ZVIza2tsVldZTjlEcEZEd3JMU3pq?=
 =?utf-8?B?ck5hUU9DVVVDVUdENmRZWEpmdzFvUHpaL2dlRVhObWV0S1U3NVFGWEIvY3Mz?=
 =?utf-8?B?Q0NXMjJ5OVJCcDhHZkdkMmVCNWxHZm5ETjMzWWhYcWxxMmlySWhpOFBzS256?=
 =?utf-8?B?MzVLdUNaeTZhTDJvbVFubG5IWkt6am94eStxUjYzSkZ4a1pUQmF0VjRHTlYr?=
 =?utf-8?B?S2lnR3RqbW5lN0JTWjlTN2VaUmdhNzBRK3E2SlFOcnYrNWR4WTJYVnJjZHlp?=
 =?utf-8?B?eWdHR0s1aEtzclVuUTFWS21qZEIwWlRoQnNPWWROa3pzRjZjbjRGcTU1amdD?=
 =?utf-8?B?UFMvazNXdmF3amFFaUUvVHRrQ3FkRGFnb2VVekFnSEVQSWdQMlNQMVVHdFZK?=
 =?utf-8?B?REZtdHRFNm83bFBJWERqY0t5Q1NyZTJEb01kcDNmY2YwYUdzd0thYTc1RnE5?=
 =?utf-8?B?bG5xZkdGN05UZDI0WnJ6Rk80TGpuZ0JpdXZUNlp4dVQ0dXVBbnpNYnVxQmZs?=
 =?utf-8?B?MEFtamQvd3ZaeGNZYmZkVXVRSkc1dldvYk1uNjAzT0VIRjNIYUlCYUdCRmFi?=
 =?utf-8?B?R1VHRS9TMThJS0pFY0JKSnBPaHlDU3VvdUpCdkdkMGVuaUV0YUt1K3cwZlo3?=
 =?utf-8?B?MHFzZ2NwUmFWRlFHWVVwTjFYc3pwV0k0VWNJbUFqZ2V0emlqQjNpdjhZK3Zl?=
 =?utf-8?B?OXJHNlIvTSttTzBqeUpiVHppdzU4MmRkUlk1ZmxqcXg3VjFRUkJjU3BLK3Ir?=
 =?utf-8?B?UVRuNWZYa01OT24rdGwvTHZvTFlpR2VaakIrcG1yaGZUV1V0dGR0STVwRVJN?=
 =?utf-8?B?R081d01EdUpocHIyZVY4d2JFQVJrYUx0bkY4eDdXOCtXaDRaWFREYWhINWw0?=
 =?utf-8?B?aGFLcDMvcmxSSFh5SjRaM0doQ2YrQXZ1NUVBSmVxRlNPUHUwM25XUzJRTXow?=
 =?utf-8?B?TnNoL2UzWE9XQ3k3bU85VXZHc280QVNIaDA3emhZL3RWUVA3TGV6TzRqQjNC?=
 =?utf-8?B?cmVPOWR1eVQ2dFJCUGw5bFlsWXdkOGRlTUhTQXBnNnlUU2x4LzFReGwwRWhm?=
 =?utf-8?B?QmVnb1gwUXpoaDA0K1VrTDczOUVndlczQ1ZjNGYwZDBwS0EyZVNkbERGS1pZ?=
 =?utf-8?B?dXJwYlRJNE0yNDNoMmxkYW1MVWFNcUxlWHNobjV2RjlVbSsyODhxcktScU8r?=
 =?utf-8?B?ZHMvdUFqTWR0Tkd6MTlrM1N3cHVnWUFndk5RSldjbHdJb3Jta2JuSnZaOWZo?=
 =?utf-8?B?cldpQUFwanE2c1BIdENsSTZzWlRsUGhXN1pJb2tmcGVTKzBicXp6WFFmRDk2?=
 =?utf-8?B?bUc3RU0rZkxtNDFlSzM0V0s4aHhTQ1FqbjhIN0xxWnAxQzhWbURRUFhES2d3?=
 =?utf-8?B?Vk0vTTQ5TVNtejU2ODdPQUFSMGJnRVBPUFNKdUpyUWNrMHdqWmpzYnhSNWE2?=
 =?utf-8?B?c3hXUk4ySHFRZnZTRC9pWkJDaENLd0FaYjlrS1pRRHVkNFNnaEhCNWdrVU8r?=
 =?utf-8?B?RzdkT2JITkdaRmRLTE1qQ1dINVEzZXJRL0s0bnZGUXRMRWZLZVRjdzAvWVFl?=
 =?utf-8?Q?vZB5tCksPucqC2MI=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3B36EC6A4FFA8A46BB44005AE6ED1196@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	V1r4no0BiJ1orvw71zKefaBLQ6Fc4P8ECDXxJGEdeVxCD9CtAt2fAcc6iAKm3R/mOWOkWUYaURGrUNieIgfWkQS0WPLtZK15vTornvgvkJB/RnJk5eh4ZTl/WalO3PP/CLXdX15u58hS+Tq+LgKyTY2U1pwpr39tjnvdyziXOwTcim45P2qybger0JiNCgk9Xav96zT4t8kxC6K3FrhXtJYeVn2DfW1wTxSK6lgiaAzKN4Zh2cfPQ9+UqM6GByeDG4h4fQgCRxTmXtC+sZm0Ob710WJCDNwoKO+kp2DSKUH0yRT6k6CIMozXhdRT0scv6cMF/LI+RhBMNdNd3omP2g==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b9dde7ab-0f5e-454d-dc75-08def37673cb
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Aug 2026 04:52:00.7160
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2jqB4/1NBZDUTnMr9stIjWB/t6qier/GacmPzEsl7jdncDqCsnrjDDcVZGsV27Op1F/rpiVWFUtOKtXJ0LUJsvOUbLtUZzO9/oYZ9IdGaZg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR02MB9341
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA2MDAzMyBTYWx0ZWRfX7wMuB9xxpYw3
 3dKRI2q0+o3WAIr+qaxOK6BDhFZEJfVYt72KobXsP0ecLkDP7ltN9boUQsEPuPF16hvcEvrp44v
 kD+xHrX1+bkvlyoujUZeUqpXlhSiQ1Y=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA2MDAzMyBTYWx0ZWRfXyWsE0TN+6NVb
 GTQGeB+b14hEloV5Xk/nALHGvcHhTpCBhHw1yAPjXXxWkrP+pQ/KdRkRjMcF5/HXN0UIhthmpcm
 v9xh3dmoncfhfg/sPq5Eoizc7ciy6xoDmQ8tTT5SXzUnvBntgACA8hmSs+4frgjWSU2FkmyoDs/
 z7NRXjOIvkd8QMk3nEW8exEFDXalSP4TKuyAF9Z9JADlrnJaYaNpS4FaIBh9vsproevDahkHszs
 OGqT46pxh1tUPDud7aq4bFAl2hK6RVIKf6OZWNMOS9rZ3XiegdSOu5lGPzVrq+gHPd+ZfciYSsu
 jKFvXdgl3XtoaJCouWuKREOrWyvkCPw4gi+oMw2d93whWnyuINV7SLKTWL07UdCASsKpfXsJRSn
 4H1aIVLWtgVIqa2dMC+o0FBduYv8TZmrN7zA2S/dI21dP6mAHgbg22OFnX8cx1i3UicnOfYxdPa
 mCsRKHMaqEmIF34dRLQ==
X-Proofpoint-GUID: 0u-PuTP9vT27TM2BBewSvA1bMkaTHfnF
X-Proofpoint-ORIG-GUID: 0u-PuTP9vT27TM2BBewSvA1bMkaTHfnF
X-Authority-Analysis: v=2.4 cv=dfOwG3Xe c=1 sm=1 tr=0 ts=6a7412f6 cx=c_pps
 a=+CKpLqsC5QamL8vULJ+FWg==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Sv0fKeRqtYgA:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VofLwUrZ8Iiv6rRUPXIb:22 a=y4UcunY2MAxhM4LwGdWI:22 a=20KFwNOVAAAA:8
 a=4N3F1D_Vr_cz3fw7_rMA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-05_06,2026-08-05_01,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gMjYgSnVsIDIwMjYsIGF0IDg6NTnigK9QTSwgRXJpYyBBdWdlciA8ZXJpYy5hdWdl
ckByZWRoYXQuY29tPiB3cm90ZToNCj4gDQo+ICEtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tfA0KPiAgQ0FVVElPTjogRXh0
ZXJuYWwgRW1haWwNCj4gDQo+IHwtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tIQ0KPiANCj4gRnJvbTogQ29ybmVsaWEgSHVj
ayA8Y29odWNrQHJlZGhhdC5jb20+DQo+IA0KPiBBZGQgYW4gaGVscGVyIHRvIHJldHJpZXZlIHRo
ZSB3cml0YWJsZSBpZCByZWcgYml0bWFzay4NCj4gDQo+IHRoZW4gcmV0cmlldmUgdGhlIHdyaXRh
YmxlX21hcCBhcnJheSBhbmQgZGlzcGF0Y2ggaXQgaW4gdGhlIHdyaXRhYmxlX21hcA0KPiBmaWVs
ZHMgb2YgYXJtNjRfaWRfcmVnc1tdIGVsZW1lbnRzLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogRXJp
YyBBdWdlciA8ZXJpYy5hdWdlckByZWRoYXQuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBDb3JuZWxp
YSBIdWNrIDxjb2h1Y2tAcmVkaGF0LmNvbT4NCj4gDQo+IC0tLQ0KPiANCj4gdjUgLT4gdjYNCj4g
LSB1c2UgYXJtNjRfaWRfcmVnc1tdLndyaXRhYmxlX21hcA0KPiAtIHNxdWFzaGVkIDIgY29tbWl0
cyAoaGVscGVyICsgdXNlcikNCj4gLSByZW1vdmVkIHN0dWINCj4gLS0tDQo+IHRhcmdldC9hcm0v
a3ZtLmMgfCA2MSArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysNCj4gMSBmaWxlIGNoYW5nZWQsIDYxIGluc2VydGlvbnMoKykNCj4gDQo+IGRpZmYgLS1naXQg
YS90YXJnZXQvYXJtL2t2bS5jIGIvdGFyZ2V0L2FybS9rdm0uYw0KPiBpbmRleCBkNDBhNmE5ODU5
Li5kMjcwZjk4NzBlIDEwMDY0NA0KPiAtLS0gYS90YXJnZXQvYXJtL2t2bS5jDQo+ICsrKyBiL3Rh
cmdldC9hcm0va3ZtLmMNCj4gQEAgLTI4LDYgKzI4LDcgQEANCj4gI2luY2x1ZGUgImt2bV9hcm0u
aCINCj4gI2luY2x1ZGUgImNwdS5oIg0KPiAjaW5jbHVkZSAiY3B1LXN5c3JlZ3MuaCINCj4gKyNp
bmNsdWRlICJjcHUtaWRyZWdzLmgiDQo+ICNpbmNsdWRlICJ0cmFjZS5oIg0KPiAjaW5jbHVkZSAi
aW50ZXJuYWxzLmgiDQo+ICNpbmNsdWRlICJody9wY2kvcGNpLmgiDQo+IEBAIC01MSw2ICs1Miw3
IEBAIGNvbnN0IEtWTUNhcGFiaWxpdHlJbmZvIGt2bV9hcmNoX3JlcXVpcmVkX2NhcGFiaWxpdGll
c1tdID0gew0KPiBzdGF0aWMgYm9vbCBjYXBfaGFzX21wX3N0YXRlOw0KPiBzdGF0aWMgYm9vbCBj
YXBfaGFzX2luamVjdF9zZXJyb3JfZXNyOw0KPiBzdGF0aWMgYm9vbCBjYXBfaGFzX2luamVjdF9l
eHRfZGFidDsNCj4gK3N0YXRpYyBib29sIHdyaXRhYmxlX21hcF9kaXNwYXRjaGVkOw0KPiANCj4g
LyoqDQo+ICAqIEFSTUhvc3RDUFVGZWF0dXJlczogaW5mb3JtYXRpb24gYWJvdXQgdGhlIGhvc3Qg
Q1BVIChpZGVudGlmaWVkDQo+IEBAIC0yNzMsNiArMjc1LDIxIEBAIHN0YXRpYyB1aW50MzJfdCBr
dm1fYXJtX3N2ZV9nZXRfdmxzKGludCBmZCkNCj4gICAgIHJldHVybiB2bHNbMF0gJiBNQUtFXzY0
QklUX01BU0soMCwgQVJNX01BWF9WUSk7DQo+IH0NCj4gDQo+ICtzdGF0aWMgaW50IGt2bV9mZWF0
dXJlX2lkeF90b19pZHJlZ3NfaWR4KGludCBraWR4KQ0KPiArew0KPiArICAgIGludCBvcDEsIGNy
bSwgb3AyOw0KPiArICAgIEFSTVN5c1JlZ3Mgc3lzcmVnOw0KPiArDQo+ICsgICAgb3AxID0ga2lk
eCAvIDY0Ow0KPiArICAgIGlmIChvcDEgPT0gMikgew0KPiArICAgICAgICBvcDEgPSAzOw0KPiAr
ICAgIH0NCj4gKyAgICBjcm0gPSAoa2lkeCAlIDY0KSAvIDg7DQo+ICsgICAgb3AyID0ga2lkeCAl
IDg7DQo+ICsgICAgc3lzcmVnID0gRU5DT0RFX0lEX1JFRygzLCBvcDEsIDAsIGNybSwgb3AyKTsN
Cj4gKyAgICByZXR1cm4gZ2V0X3N5c3JlZ19pZHgoc3lzcmVnKTsNCj4gK30NCj4gKw0KPiBzdGF0
aWMgdm9pZCBrdm1fYXJtX2dldF9ob3N0X2NwdV9mZWF0dXJlcyhBUk1Ib3N0Q1BVRmVhdHVyZXMg
KmFoY2YpDQo+IHsNCj4gICAgIC8qIElkZW50aWZ5IHRoZSBmZWF0dXJlIGJpdHMgY29ycmVzcG9u
ZGluZyB0byB0aGUgaG9zdCBDUFUsIGFuZA0KPiBAQCAtNDgwLDkgKzQ5Nyw1MyBAQCBzdGF0aWMg
dm9pZCBrdm1fYXJtX2dldF9ob3N0X2NwdV9mZWF0dXJlcyhBUk1Ib3N0Q1BVRmVhdHVyZXMgKmFo
Y2YpDQo+ICAgICBhaGNmLT5mZWF0dXJlcyA9IGZlYXR1cmVzOw0KPiB9DQo+IA0KPiArc3RhdGlj
IGludCBrdm1fYXJtX2dldF93cml0YWJsZV9pZF9yZWdzKHVpbnQ2NF90ICppZHJlZ21hcCkNCj4g
K3sNClRoaXMgc2hvdWxkIHByb2JhYmx5IGJlIGdhdGVkIHdpdGgga3ZtX2VuYWJsZWQoKT8NCg0K
cXRlc3QtYWFyY2g2NC9kZXZpY2UtaW50cm9zcGVjdC10ZXN0IGZhaWxzIG9uIG15IGFhcmNoNjQg
ZGV2dm0sIHdoaWNoIGRvZXMgbm90DQpoYXZlIEtWTS4NCg0KPiArICAgIGludCBjYXBfd3JpdGFi
bGVfaWRfcmVnczsNCj4gKyAgICBzdHJ1Y3QgcmVnX21hc2tfcmFuZ2UgcmFuZ2UgPSB7DQo+ICsg
ICAgICAgIC5yYW5nZSA9IEtWTV9BUk1fRkVBVFVSRV9JRF9SQU5HRSwNCj4gKyAgICAgICAgLnJl
c2VydmVkID0gezB9LA0KPiArICAgICAgICAuYWRkciA9ICh1aW50NjRfdClpZHJlZ21hcCwNCj4g
KyAgICB9Ow0KPiArDQo+ICsgICAgY2FwX3dyaXRhYmxlX2lkX3JlZ3MgPQ0KPiArICAgICAgICBr
dm1fY2hlY2tfZXh0ZW5zaW9uKGt2bV9zdGF0ZSwgS1ZNX0NBUF9BUk1fU1VQUE9SVEVEX1JFR19N
QVNLX1JBTkdFUyk7DQo+ICsNCj4gKyAgICBpZiAoIWNhcF93cml0YWJsZV9pZF9yZWdzIHx8DQo+
ICsgICAgICAgICEoY2FwX3dyaXRhYmxlX2lkX3JlZ3MgJiAoMSA8PCBLVk1fQVJNX0ZFQVRVUkVf
SURfUkFOR0UpKSkgew0KPiArICAgICAgICByZXR1cm4gLUVOT1NZUzsNCj4gKyAgICB9DQo+ICsN
Cj4gKyAgICBpZiAoa3ZtX3ZtX2lvY3RsKGt2bV9zdGF0ZSwgS1ZNX0FSTV9HRVRfUkVHX1dSSVRB
QkxFX01BU0tTLCAmcmFuZ2UpKSB7DQo+ICsgICAgICAgIHJldHVybiAtZXJybm87DQo+ICsgICAg
fQ0KPiArICAgIHJldHVybiAwOw0KPiArfQ0KPiArDQo+IHZvaWQga3ZtX2FybV9zZXRfY3B1X2Zl
YXR1cmVzX2Zyb21faG9zdChBUk1DUFUgKmNwdSkNCj4gew0KPiAgICAgQ1BVQVJNU3RhdGUgKmVu
diA9ICZjcHUtPmVudjsNCj4gKyAgICB1aW50NjRfdCAqd3JpdGFibGVfbWFwOw0KPiArDQo+ICsg
ICAgd3JpdGFibGVfbWFwID0gZ19uZXcodWludDY0X3QsIEtWTV9BUk1fRkVBVFVSRV9JRF9SQU5H
RV9TSVpFKTsNCj4gKw0KPiArICAgIGlmICghd3JpdGFibGVfbWFwX2Rpc3BhdGNoZWQgJiYNCj4g
KyAgICAgICAgIWt2bV9hcm1fZ2V0X3dyaXRhYmxlX2lkX3JlZ3Mod3JpdGFibGVfbWFwKSkgew0K
PiArICAgICAgICBmb3IgKGludCBpID0gMDsgaSA8IEtWTV9BUk1fRkVBVFVSRV9JRF9SQU5HRV9T
SVpFOyBpKyspIHsNCj4gKyAgICAgICAgICAgIHVpbnQ2NF90IG1hc2sgPSB3cml0YWJsZV9tYXBb
aV07DQo+ICsNCj4gKyAgICAgICAgICAgIGlmIChtYXNrKSB7DQo+ICsgICAgICAgICAgICAgICAg
aW50IGlkeCA9IGt2bV9mZWF0dXJlX2lkeF90b19pZHJlZ3NfaWR4KGkpOw0KPiArDQo+ICsgICAg
ICAgICAgICAgICAgaWYgKGlkeCA8IDAgfHwgaWR4ID4gQVJSQVlfU0laRShhcm02NF9pZF9yZWdz
KSkgew0KPiArICAgICAgICAgICAgICAgICAgICBjb250aW51ZTsNCj4gKyAgICAgICAgICAgICAg
ICB9DQo+ICsgICAgICAgICAgICAgICAgYXJtNjRfaWRfcmVnc1tpZHhdLndyaXRhYmxlX21hc2sg
PSBtYXNrOw0KPiArICAgICAgICAgICAgfQ0KPiArICAgICAgICB9DQo+ICsgICAgICAgIHdyaXRh
YmxlX21hcF9kaXNwYXRjaGVkID0gdHJ1ZTsNCj4gKyAgICB9DQo+ICsgICAgZ19mcmVlKHdyaXRh
YmxlX21hcCk7DQo+IA0KPiAgICAgaWYgKCFhcm1faG9zdF9jcHVfZmVhdHVyZXMuZHRiX2NvbXBh
dGlibGUpIHsNCj4gICAgICAgICBrdm1fYXJtX2dldF9ob3N0X2NwdV9mZWF0dXJlcygmYXJtX2hv
c3RfY3B1X2ZlYXR1cmVzKTsNCj4gLS0gDQo+IDIuNTMuMA0KPiANCg0K
