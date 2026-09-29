Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECDC552E064
	for <kvmarm@lists.linux.dev>; Tue, 29 Sep 2026 16:38:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790699940; cv=fail; b=BndqQyJB4nrhkCWwRls/6kuaEkxr9WwA+SJY3wAdYXgIV2Z54iWhTPJnFcVooHszz/z8ukL+ZHJjBm2YI2Y+IG33fXFe9rwjJiYmhGAMR1xKFPueUQNKOsR0xkwnylWVaOBLroRIJNv98j0MguQTNigias5gYkpGZSKYTHz+kd8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790699940; c=relaxed/simple;
	bh=g3Hv6Ret52feTI/PdvCrORsBZwSDIA+XtNxI+QrEvTs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=BnCO/gcz9p3FpycxkfqArVFlhYtOQ2g6eMohtdoYJostmuOyp7ekNVN72yhaoox5rXYgEzNxGEIY7x4ErMbiEg20iZKk3IQbeb3b8zbsZIszYSJr6TeTN60z9VcM5Youe7kaUCkc9ig7fcFgiM3c4GVw2hYXKhjvklNvfWAdnDI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=eJjXSX+x; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=BQywB5K9; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="eJjXSX+x";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="BQywB5K9"
Received: from pps.filterd (m0127841.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68TAkVgM361478;
	Tue, 29 Sep 2026 09:38:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=g3Hv6Ret52feTI/PdvCrORsBZwSDIA+XtNxI+QrEv
	Ts=; b=eJjXSX+x48XHRyllArJ6EkIq+rWd4Cgt5y4YcKAKMn4sjwN6ufekih/MA
	o9K9Wb+iuFRQFvd8+e1YmKipTdmOEApOAMWBZldKWZjhIeXs2pgGHHMeZ+xj3KPM
	bGUAkZwWrxVeB/kuy6ZsEex8k1Ro/223fRNekgXVaSDASASeQV7kGdLU93ECkfen
	lqAhvxmWR2LfyQXrbcl0Smq3BrQJ+zpz/+qoQxz3/rgeVOMxuvcJ5g12KXcsRHDh
	sfNv1R/aenOufTsu5wnBPP96nJbvEjkFhHza2yoA7pnzIzCKlz6lKAo1UFnGvpGJ
	cWauMFSODDHtRRRGbRlMIhaJUvvFA==
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11022129.outbound.protection.outlook.com [40.93.195.129])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4h098sh9yj-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 29 Sep 2026 09:38:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=khcG+e721kRcOB9k+u2z5LI3eoUukr0rOpUMUgiD9jpJe13NDfdDMhn2aH+zaePBeIfMdB7shfWSSq/c/C3AYAWsDhr01hwOpfO3KaEFtK4DVKGtL20JO6LzTMvHwM80/zHvTc+GsrXUPzuzx3e0FZSWXHbkNcm3wr5vOmi4c4cLJP+sUJZxIynvs9H1ralnTIqzPtT7ZSuMa02UT3/5ftUX7LTwkCx6bTA4FP2I3dfmuaBXhYCJJ8wit6rOda/NY2+JnjLd18jYhegxSrKChHdyS7K5hL7Ot1VCBCcwhQoxeTyML1AfT0ZIbyQS7EjKV1gtFKkXpF2XxDJJeh+qLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g3Hv6Ret52feTI/PdvCrORsBZwSDIA+XtNxI+QrEvTs=;
 b=pAeNWQlgiN9R602K8i2O6tL8SB70RoWETG3CT32PedJlqORAtxvFqB4XS/D1qKeTGyBwyHQI90b7nNm3S0SDg+lVcTAnVzQLgkxvhHGKQ1I/NawGvx7aCDy/UVsIBrujf7V3LVtA8xFU0QijVsgPQM4XDqlxqFWzA/W8eJZsIkWUAKvQo8Knl0TT4RpeKmwwStCjrCOwP6zToKwL1ZQDdHzszMjMn7RZ+bx5hdOvmbu+5Wkbb9akDDhFrGd6lgSfUbO3fvEWK2DC0K6AB2O1qE6J8VZOs5K3yDCLIl908WVct2RhnSQbocAF1QFPXEVerbHWxSfgHAMpvkpwOJGh8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g3Hv6Ret52feTI/PdvCrORsBZwSDIA+XtNxI+QrEvTs=;
 b=BQywB5K9AUoaaOpIq6Y39uDfYW7krIY1F7RKGgHHZQ+cZplI3mbLpQmXjUveZhF6rV7pHo7sWkOV/GugHTj7B319LIiPWBrW2kpvv46fAXZ8L4vup/JJyUI/Mnhm1cxw1jVyaAA/GqJ4ivFKT9n1MMEv2S0BxuUUPz70F0Mo/dwm5j9zvJll62sDT4UD2vF85xBWrM3xNOXafD3gQTIRQ0gfhfr/HJdliUcZu45gsV2cciiO03OZPR7QrGg31TcN+BQokKvJi0npx87/Yh31v3F1bnA23ME/mK/xvlaUF9QQD6UWafe8Oy36KRjO3zeC6jh0H1vhovEGgV5i4QjLnA==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by CH0PR02MB8043.namprd02.prod.outlook.com (2603:10b6:610:108::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.26; Tue, 29 Sep
 2026 16:38:42 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%5]) with mapi id 15.21.0451.026; Tue, 29 Sep 2026
 16:38:42 +0000
From: Khushit Shah <khushit.shah@nutanix.com>
To: =?utf-8?B?UGhpbGlwcGUgTWF0aGlldS1EYXVkw6k=?= <philmd@oss.qualcomm.com>
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
        "armbru@redhat.com" <armbru@redhat.com>,
        "philmd@linaro.org" <philmd@linaro.org>,
        "yangjinqian1@huawei.com"
	<yangjinqian1@huawei.com>,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Mark
 Cave-Ayland <mark.caveayland@nutanix.com>,
        "ping@khushitshah.com"
	<ping@khushitshah.com>,
        Sandesh Patel <sandesh.patel@nutanix.com>,
        Mohamed
 Mediouni <mohamed@unpredictable.fr>
Subject: Re: [RFC PATCH v4 00/25] named CPU models for Arm64 on KVM
Thread-Topic: [RFC PATCH v4 00/25] named CPU models for Arm64 on KVM
Thread-Index: AQHdScVcmVH3lL3Gaki+e01U/Yh81bbltYuAgAAY1oA=
Date: Tue, 29 Sep 2026 16:38:41 +0000
Message-ID: <6361B7E6-E3C1-41FF-9F40-3051669529ED@nutanix.com>
References: <20260921123249.1708067-1-khushit.shah@nutanix.com>
 <365d64a9-416c-46fd-b9af-4023b112a164@oss.qualcomm.com>
In-Reply-To: <365d64a9-416c-46fd-b9af-4023b112a164@oss.qualcomm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nutanix.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA2PR02MB7564:EE_|CH0PR02MB8043:EE_
x-ms-office365-filtering-correlation-id: dd09ced6-7738-49e7-59b4-08df1e481f37
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|7416014|10067099003|56012099006|5023799004|4143699003|3023799007|6133799003|22082099003|18002099003|38070700021;
x-microsoft-antispam-message-info:
 RdzmO5dYjTYl6IjlLgDNVxiFPQXcqaq7I+ol4n1x7VEnaMpJV3yswFrtCTbBwnyZflRlPNmqjSKk8rvB9cEkYUwkytHRILdkkW7I4+ZtAfhImjZVhwMXvo4LmK1M57JKxmlQNbXiEO98FgNz898EpV2F5GlXL+F90nwo9NKFb78We8TQW4zzkDFUdWt1oRgP3REjv3Mg2NSLhrkS/w2x/NXPazk9OTttqWXl39GCaMO6hlazKPw0csXqyG2teFUNBiTBLv14LsnTpHuaxDZh6h16YViUF7ihYSHifWB8qU07+Fizvi8VkC6WQBI2jGIm5+xy1S02H2Fwc5h8ldRU1ETYDsxXEscJSzx3HEU4uRETL0mAKS5ExsU8KKVWP0ibLUCG+kO92tk3hpVh7HrhoP0AsS2TB7PoasLHW5u2tNxOzzD47m365tAkPZ5PNDmVGNlxJiPS3LSOowHM42KKkcK9BihfaR62SMJr4SMHeUnQXMHhRbm1T17WSbux/kZfI5BTADZUaeqkmtsh8814/9WfSZZaTnkAskigFXpx1a/9D1VABEmDbur29xPYuYrutPIaD8cVfsCqLZRkUDKk6Tq20d8dYOkqCViMODFbz8ebDQlkAXCodP26H+DcKy5VymVzwafJgTGYSg6qkwdvIosWRsST12ydFs165rczq8OaH1DBQINpMIgv7YBV4kMLcMTLLbp2JW04Ht+7n67Zy90A2PVDAFa4/HAhyQ/AHZo=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(7416014)(10067099003)(56012099006)(5023799004)(4143699003)(3023799007)(6133799003)(22082099003)(18002099003)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?aW1pcmZnUUt0aGZBOWVUeUN3SE5Nck9TK0JMV1p4clJFN29WRTlJRWpsNlZI?=
 =?utf-8?B?SWRqYUdsNmczYm4xVXZTZ1hFREhIditKa096NFVsY2YxSGxUN1p6WVkwcGtu?=
 =?utf-8?B?cndsZGNZSDQvd29XT2c5eHRHamdySFEvTkh6enNuaVN1WHQ0U1FDVnN3SGsy?=
 =?utf-8?B?M2QzbDVWS2NBMk15SXYrc1dPNjdHK3VHbEh4aEZTa0Q1Zk5OcEZwQVVaNDhx?=
 =?utf-8?B?azZFQmlwbzl5QkVFdHdCNGx1OFczcFVKWGIvdjhsVXVNU1VMaVBSNmRhblF5?=
 =?utf-8?B?SDFWbUNBUStraHRnY1lxZWNucERxdFlITFZQbGRPMTVJbkxjRkhXbDk5OEUz?=
 =?utf-8?B?aW5ZbytWbHQ3TE1KM05HVmJwenJqV2hGbEtoMEthWko5TmxKMlhWWEZTcEtE?=
 =?utf-8?B?K090b0tCZlVOdEJjME1DZnQvSmZWZUlOTUU2SHB1QlJsSG1jaEVJS3N1bDl4?=
 =?utf-8?B?bXdtSGRQVDlZTyticlZSb1NsYnVCRW1yR2xwZ1cxS0szNDk3QXlON0l5eUNt?=
 =?utf-8?B?ajZhZUNtY2NwWUZTZy9pL3ZXNXovUnJQSjVsMnF3M29KNWlHOXhXVkRNYlZE?=
 =?utf-8?B?ejNneHJzNjQxNGVvM3V1cEQ4K2JKT0NlZ0VvSkdaMVVDdHVhcG5MV0JIUEZ0?=
 =?utf-8?B?a2hBb21uUyt1Mi9uZXpZSmY1OXRZaUtoMVZzWDRQSDVXN2JUbU8vQVNDNGw0?=
 =?utf-8?B?TFFJaFZPWklSOFlDUWRaaWJPVDY0d2hRMVV3QmYwZjVKUVpZSVpvUFFFZ3ZX?=
 =?utf-8?B?engzLzBuZCtEME5uUnZyWUp0bnB1c3FYQTVQTFVjS1dFVkhrclRLZHdhNDdL?=
 =?utf-8?B?MTVNYkVMN2dQWGVJMmRUNHg3anJsejZTazhDUWEyanZCeVFNdlJnL0QxdmM3?=
 =?utf-8?B?TWlDdEtSUnlkYjBhSVJUK2wvd1NKdUxyS1ZVZG5lVE5EMEVpQ3RZejYveitv?=
 =?utf-8?B?UWxuNFhsVkZnOVRwVXdqNUJzQWxEbTJKMU1OaUxLVEZhSDZBVEFsekg2cVV2?=
 =?utf-8?B?RjNhNGdRY2QrTUhXNFBnZDNWeU9hWWp1aTBzbEtLUFYrTDl2ZVhzKzFoZDJ3?=
 =?utf-8?B?empPQjBiK0FEQjVpTzdjWkk1NXhTWTBvMnRGdStNeUVMRXdsbmZ0QVZkSWxq?=
 =?utf-8?B?dmZLOWFmZTVtQzNETndlSnZTNXlSSFBFNlVhcHlkUU1MWE1aT25MOWptajlo?=
 =?utf-8?B?cXZ3eTZLVk82SEdTUWc5QlhXU0FiaU0rU0RoUGF6NnJOYnhpRm85ZXVSQWxj?=
 =?utf-8?B?dW1xT0xpVnluVUg5dlUyRjNCR3ByN0lJWDI0YmpaVzJEU2hTeC9Vakd3Znpn?=
 =?utf-8?B?NDFpZFk3c2ZnakVBSldFVDhWV3gycGhyUFZBbk04QXkrd0JpTWZUbFhCdlNS?=
 =?utf-8?B?alhKRENtOXNUUENvOW1wUXF6WFluYWRWTFEwbVh2UWVSM1VES3dua2ZJc1lF?=
 =?utf-8?B?Zm9NK090UVFNbHJsZDhvQjdJL3NLWlRFbC9veHJQck5CQ2xaOWU2dGwxUlk4?=
 =?utf-8?B?T1E5UFdseHA0MnR4YVRwM09vc0l1QWVCWVJlT3JtT0NnWXU3S1NPQmdiTDA0?=
 =?utf-8?B?UWdjNjlDQmc5TGRxZ2U5QkM0dDY2RUVTbW0zcFErRnEwSFJ0bW9KM2lHOWkv?=
 =?utf-8?B?R3ZoVElBVzAxV3BTa1BhVkIxLzBZS0t5bUtUTkdkZXR5bjU2Z0FJRjdHMlJy?=
 =?utf-8?B?WXNEb24za3NNRllqZW5jU1NPZjBOdUVvL3dMSmZ5U0NKd094RUh0MjdTOU13?=
 =?utf-8?B?eUh6WFEweGdGbnQ4WEhJN0hScFZXTk1aWU9SL3RkNkhlZ2lPUUJOR3RSUUU1?=
 =?utf-8?B?c3FsdDlFZHc2UFhrZ2FCaWpXcnpCYjJ1SHhYazdUcGlWbU9wQWN2Z3JSNktM?=
 =?utf-8?B?eXk2dnVKU1NnZEhEVnZqV3l5QlNCZ2lTSk5CRzdhTmN6dGdLSWV6K2xMQnRK?=
 =?utf-8?B?UldtZ0NZd05UN3FyQlhQYmVsY0JkdGNRMCtsYjZrcUtYSnRaRzlBdnpycjJG?=
 =?utf-8?B?WDRtbVJQb1FOaDlrM3JtWi90QmsxbmVLMU51OUttcld5M2g3eWNIeW0xaHE3?=
 =?utf-8?B?eTVQVk5IUlFkVUFNK2hGVUpTVk1nMnV6UGV2NzQzSEx6bmFScmloY1BFM1B1?=
 =?utf-8?B?RmJPU0gwamRDVFFVNjlJVTRtaFFTTUlLUFAwemF3RnhiQjNqMHlieEFEMVMx?=
 =?utf-8?B?NU9XRG1GK01xV1dSZmovZUJiU2l5SEVGZTNZM0dXbExNckkxUDVPOXk4Uy94?=
 =?utf-8?B?OHJwdkcwL25RQXh0RmZUaE10Tnl5VHdteHROUVlBdkwwMXBaUUEwa01VNENL?=
 =?utf-8?B?N21LN3NkbmxQODJnY3FZa3JrUStFNi8vQUJvQ1hlZWQrdXJPNXB2YjdicEp5?=
 =?utf-8?Q?j4GaDftZh+hENgP0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4B2BE7D479A1DD4E98433A2421965CB4@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	D9tPT9VxEmrOgLT4HdSgQKy6WQRKKQB9KbSsQ5/R51XkcI6/+ljdvnAOF1fzcOa2PNaZ3+0C76Y5+o+ojGDxdBQU7Xn2F6oG5tGMkS75BwpHvzATlWqcS2FeBH8W04XGri9eo5DNR4ZF3mkxCxuWGmR00XQ7ZsLAfMPVHNaF7z0mpNLY1DeaMhlsRw5/qL4L6+B9PlnfqC9JJN0SbZiYxsr2D9BW7nhZLjmAkw3uhnMsShQzepmwK+nHDWsikUgeGUswDKTrmRyr4/8XK69m1gvJL1B9y51iM7FAHnk/lJoazIEp3y5VFtpGK3ik6oVfkmr7TrYKDEvB60sBL6UDGg==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd09ced6-7738-49e7-59b4-08df1e481f37
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Sep 2026 16:38:41.9597
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eKeG8XYQvwIB/NwW+Glw3+Uwduo/4DhB4P9A/TsW0BAtoOSSQ29hSs/dahr2OuMsJGueVOs8AMBmV6fejJ9oBFrWbg1rvpv+rndOanIo+7Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR02MB8043
X-Authority-Analysis: v=2.4 cv=O6CsLx9W c=1 sm=1 tr=0 ts=6abbe993 cx=c_pps
 a=+AD+TCgY8d24af2vGjQMRw==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VofLwUrZ8Iiv6rRUPXIb:22 a=jxMXjlTPpCISP5mWtjnE:22 a=EUspDBNiAAAA:8
 a=KXmzLhxscmQzJtRbCecA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: 1l8sait_OfHr8DM_hYve4BQc8j1TjuqB
X-Proofpoint-GUID: 1l8sait_OfHr8DM_hYve4BQc8j1TjuqB
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI5MDA2NiBTYWx0ZWRfX7SkJdyXBz8u9
 w2+l9vwrfPn2JqAiNzee1UBPdOjw+QZj6vQh9tbs9ApU+5GZdQwBSESppMVApXeYwdn13NPaCWA
 aLxC9CYvf3phVg7MjYAtMxlQ0SGquFwziEuPuN8H4EW3plj+hj5onOZJ/uW5Rum5zv+Rg5WkF/s
 mIs6GB5flQsmDODl6O5Uyx2YGgEPiJWw8g3FD5fPCEc0O+q89gO+wd5OlQMm0IZZDKba7QJGqj5
 B8HEbg1HhCY499uPgCIr5X2IbY83Xv1ZsXgDbvfulSv8e0sGhcZnnlcV4BVcXpRJ1GIN5BuKbi/
 yyUdYNWT3EHwQ3YIywPmumsGKDUw+5xxnXgPqCXO0P+phoF0y0i7otKM2J9b6Mp+nePmIEgXBQo
 iQQ/szpp7YOxB6DBuC/MFX6+NIVU1YqcDqUJi2RFmLj+56RlmhIwCvDmF8eJDtsbytnY9MMD+1P
 KhDRWoloOiNbumBDG/A==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI5MDA2NiBTYWx0ZWRfX8tXRQ1LmM1uQ
 A8WdUvnn0hP3I1dggDxyql2nSEgVFgkUEjoYDeqEXviHhN4N9DgsNQWceZFj1TxvoFruGtdVjV2
 XE8C5YUauAJ+Pu4PPILPl0xvofocH+s=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-29_04,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gMjkgU2VwIDIwMjYsIGF0IDg6MznigK9QTSwgUGhpbGlwcGUgTWF0aGlldS1EYXVk
w6kgPHBoaWxtZEBvc3MucXVhbGNvbW0uY29tPiB3cm90ZToNCj4gDQo+ICEtLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tfA0K
PiBDQVVUSU9OOiBFeHRlcm5hbCBFbWFpbA0KPiANCj4gfC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0hDQo+IA0KPiBIaSwN
Cj4gDQo+IE9uIDIxLzkvMjYgMTQ6MzIsIEtodXNoaXQgU2hhaCB3cm90ZToNCj4+IEhpIEFsbCwN
Cj4+IEhlcmUgaXMgdjQgb2YgdGhlIFJGQyBmb3IgbmFtZWQgQ1BVIG1vZGVscyBvbiBBcm02NC9L
Vk0uDQo+PiBCYWNrZ3JvdW5kOg0KPj4gPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PQ0KPj4gQ3VycmVudGx5IFFFTVUgb25seSBzdXBw
b3J0cyAtY3B1IGhvc3QvbWF4IGZvciBLVk0gb24gQXJtNjQuIFRoaXMgYmxvY2tzDQo+PiBsaXZl
IG1pZ3JhdGlvbiBvZiBWTXMgYmV0d2VlbiBob3N0cyB0aGF0IGRpZmZlciBpbiBDUFUgZmVhdHVy
ZXMuDQo+PiBUaGlzIFJGQyBwcm9wb3NlcyBoaWVyYXJjaGljYWwgbmFtZWQgbW9kZWxzIGZvciBB
cm02NCB1bmRlciBLVk0uIEEgbmFtZWQNCj4+IG1vZGVsIGlzIGEgc3RyaWN0IGNvbnRyYWN0IG9m
IHRoZSBDUFUgZmVhdHVyZXMgZXhwb3NlZCB0byB0aGUgZ3Vlc3QsIHNvDQo+PiB0aGUgc2FtZSBt
b2RlbCByZXNvbHZlcyB0byB0aGUgc2FtZSBndWVzdC12aXNpYmxlIElEIHJlZ2lzdGVycyBvbiBh
bnkNCj4+IGNhcGFibGUgaG9zdC4gTW9kZWxzIGNhbiBiZSBjdXN0b21pemVkIGZ1cnRoZXIgYnkg
b3ZlcnJpZGluZyBpbmRpdmlkdWFsDQo+PiBJRC1yZWdpc3RlciBmaWVsZHMgKGUuZy4gU1lTUkVH
X0lEX0FBNjRJU0FSMF9FTDFfU0hBMT0wKS4NCj4+IE9uIHRvcCBvZiB0aGUgbW9kZWxzLCB0aGlz
IHNlcmllcyBhZGRzIHRoZSBRTVAgaW50cm9zcGVjdGlvbiBzdXBwb3J0IG9uDQo+PiBBcm0gdGhh
dCB0aGUgbWFuYWdlbWVudCBsYXllciBhbHJlYWR5IGRlcGVuZHMgb24gZm9yIHg4NjoNCj4+IGBx
dWVyeS1jcHUtZGVmaW5pdGlvbnNgIGxpc3RzIHRoZSBtb2RlbHMgYSBob3N0IGNhbiBydW4gYW5k
IHJlcG9ydHMNCj4+IGJsb2NrZXJzIGZvciB0aGUgb25lcyBpdCBjYW5ub3QsIGBxdWVyeS1jcHUt
bW9kZWwtZXhwYW5zaW9uYCByZXNvbHZlcyBhDQo+PiBtb2RlbCB0byBpdHMgZnVsbCBzZXQgb2Yg
cHJvcGVydGllcywgYW5kIHRoZSBuZXcgYHF1ZXJ5LWNwdS1wcm9wcy1pbmZvYA0KPj4gcmVwb3J0
cyB0aGUgdmFsdWVzIHRoZSBob3N0IHN1cHBvcnRzIGZvciBlYWNoIHByb3BlcnR5LiBUaGUgYWlt
IGlzIGZlYXR1cmUNCj4+IHBhcml0eSB3aXRoIHg4NiBzbyBleGlzdGluZyB0b29saW5nIGNhbiBj
b25zdW1lIEFybSBuYW1lZCBtb2RlbHMgd2l0aA0KPj4gbGl0dGxlIGNoYW5nZS4NCj4+IFRMO0RS
IGV4YW1wbGVzOg0KPj4gPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PQ0KPj4gICAjIEJvb3QgYSBuYW1lZCBtb2RlbA0KPj4gICBxZW11
LXN5c3RlbS1hYXJjaDY0IC1jcHUgZ3JhY2UtdjEgLW1hY2hpbmUgdmlydCxhY2NlbD1rdm0gLi4u
DQo+PiAgICMgTmFtZWQgbW9kZWwgd2l0aCBJRC1yZWdpc3RlciBmaWVsZCBvdmVycmlkZQ0KPj4g
ICBxZW11LXN5c3RlbS1hYXJjaDY0IC1jcHUgZ3JhY2UtdjEsU1lTUkVHX0lEX0FBNjRJU0FSMF9F
TDFfU0hBMT0wIC4uLg0KPj4gICAjIC1jcHUgaG9zdCB3aXRoIElELXJlZ2lzdGVyIGZpZWxkIG92
ZXJyaWRlDQo+PiAgIHFlbXUtc3lzdGVtLWFhcmNoNjQgLWNwdSBob3N0LFNZU1JFR19JRF9BQTY0
SVNBUjBfRUwxX0FFUz0xIC4uLg0KPj4gICAjIHF1ZXJ5LWNwdS1tb2RlbC1leHBhbnNpb24NCj4+
ICAgICAgICAgIm1vZGVsIjogew0KPj4gICAgICAgICAgICAgIm5hbWUiOiAiZ3Jhdml0b240LXYx
IiwNCj4+ICAgICAgICAgICAgICJwcm9wcyI6IHsNCj4+ICAgICAgICAgICAgICAgICAiU1lTUkVH
X0lEX0FBNjRJU0FSMF9FTDFfQUVTIjogMiwNCj4+ICAgICAgICAgICAgICAgICAiU1lTUkVHX0lE
X0FBNjRJU0FSMF9FTDFfU0hBMSI6IDEsDQo+PiAgICAgICAgICAgICAgICAgIlNZU1JFR19JRF9B
QTY0SVNBUjBfRUwxX1NIQTIiOiAyLA0KPj4gICAgICAgICAgICAgICAgICJTWVNSRUdfSURfQUE2
NElTQVIxX0VMMV9BUEEiOiAzLA0KPj4gICAgICAgICAgICAgICAgICJTWVNSRUdfSURfQUE2NFBG
UjBfRUwxX1NWRSI6IDEsDQo+PiAgICAgICAgICAgICAgICAgInN2ZSI6IHRydWUsDQo+PiAgICAg
ICAgICAgICAgICAgInN2ZTEyOCI6IHRydWUsDQo+PiAgICAgICAgICAgICAgICAgLi4uDQo+PiAg
ICAgICAgICAgICB9DQo+PiAgICAgICAgIH0NCj4gDQo+PiBLaHVzaGl0IFNoYWggKDI1KToNCj4+
ICAgdGFyZ2V0L2FybTogZXhwb3NlIFNZU1JFR18gcHJvcHMgZm9yIFJFVklEUl9FTDEgYW5kIEFJ
RFJfRUwxDQo+PiAgIHRhcmdldC9hcm06IGV4cG9zZSBhbGwgbm9uLXJlcyBJRCByZWcgZmllbGRz
IGFzIHByb3BlcnRpZXMNCj4+ICAgdGFyZ2V0L2FybTogbW92ZSBTWVNSRUdfIHByb3AgaW5mcmEg
dG8gY3B1NjQuYw0KPj4gICB0YXJnZXQvYXJtL2t2bTogZW5hYmxlIHdyaXRhYmxlIGltcGxlbWVu
dGF0aW9uIElEIHJlZ2lzdGVycw0KPj4gICB0YXJnZXQvYXJtL2t2bTogcmVhZCBhbGwgSUQgcmVn
aXN0ZXJzIGZyb20gS1ZNDQo+PiAgIHRhcmdldC9hcm0va3ZtOiBoYW5kbGUgc3BlY2lhbCBJRCBy
ZWdpc3RlcnMgd2hlbiByZWFkaW5nIGZyb20gS1ZNDQo+PiAgIHRhcmdldC9hcm0va3ZtOiBwcm9j
ZXNzIElEIHJlZ2lzdGVyIHdyaXRlYmFjayBwZXIgZmllbGQNCj4+ICAgdGFyZ2V0L2FybS9rdm06
IGhhbmRsZSB3cml0ZWJhY2sgZm9yIHNwZWNpYWwgSUQgcmVnaXN0ZXIgZmllbGRzDQo+IA0KPiBX
aGlsZSB0aGUgZmlyc3QgcGFydCBvZiB0aGlzIHNlcmllcyBkbyBLVk0gc3BlY2lmaWMgY2FsbHMg
dG8gZ2V0DQo+IHVzYWJsZSBJRCByZWdpc3RlcnMsIHRoZSByZXN0IGRvZXNuJ3Qgc2VlbSBLVk0g
c3BlY2lmaWMuIElPVywgd2hhdA0KPiB3b3VsZCByZXN0cmljdCBuYW1lZCBDUFUgbW9kZWxzIHRv
IGJlIHVzZWQgd2l0aCBIVkYgb3IgV0hQWD8gSUlVQw0KPiBhcyBsb25nIGFzIHdlIGNhbiB2YWxp
ZGF0ZSB0aGUgQ1BVIGZlYXR1cmVzIHdpdGggdGhlIGhvc3Qgd2UgYXJlDQo+IGdvb2QuIElmIHNv
LCBzb21lIGhhbmRsZXJzIHNob3VsZCBiZSBtb3ZlZCB0byB0aGUgYWNjZWxlcmF0b3IgbGF5ZXI7
DQo+IGJ1dCBvZiBjb3VzZSB0aGlzIGNhbiBiZSBkb25lIGxhdGVyLg0KPiANCg0KSSBkb24ndCBz
ZWUgYSByZWFzb24gd2h5IG5hbWVkIG1vZGVscyBzaG91bGRuJ3Qgd29yayB3aXRoIG90aGVyIGFj
Y2VsZXJhdG9ycywNCmFzIGxvbmcgYXMgdGhlIGFjY2VsZXJhdG9yIHByb3ZpZGVzIGEgd2F5IHRv
IHNldCB0aGUgZ3Vlc3QncyBJRCByZWdpc3RlciB2YWx1ZXMNCmFuZCB0byByZXBvcnQgd2hpY2gg
dmFsdWVzIGl0IHN1cHBvcnRzIG9uIHRoZSBob3N0Lg0KDQpJJ20gbm90IHN1cmUgYWJvdXQgSFZG
L1dIUFggY2FwYWJpbGl0aWVzLiBJIGRpZCB0cnkgYSBxdWljayBoYWNrICh+MjAgbGluZXMpDQpm
b3IgVENHIGFuZCB0aGUgbmFtZWQgbW9kZWxzIGFuZCB0aGUgdW5kZXJseWluZyBTWVNSRUdfIHBy
b3BlcnRpZXMgd29yayBhbG1vc3QNCm91dCBvZiB0aGUgYm94ISA6KQ0KDQpNYXliZSBpbiB0aGUg
ZnV0dXJlIHRoZSBob3N0LWRlcGVuZGVudCBwYXJ0cyBpbiBuYW1lZCBtb2RlbHMvcW1wIChnZXR0
aW5nIHRoZQ0Kc3VwcG9ydGVkIHZhbHVlcyBhbmQgY29tcHV0aW5nIGJsb2NrZXJzKSBjb3VsZCBi
ZSBtYWRlIG1vcmUgYWNjZWxlcmF0b3ItYWdub3N0aWMuDQooSWYgSSB1bmRlcnN0b29kIHlvdSBj
b3JyZWN0bHkpDQoNClRoYW5rcywNCktodXNoaXQNCj4+ICAgdGFyZ2V0L2FybTogaW50cm9kdWNl
IG5hbWVkIENQVSBtb2RlbCBpbmZyYXN0cnVjdHVyZQ0KPj4gICB0YXJnZXQvYXJtOiBmaXggU1ZF
IGFuZCBQQXV0aCBmaW5hbGl6ZSBmb3IgbmFtZWQgQ1BVIG1vZGVscw0KPj4gICB0YXJnZXQvYXJt
OiBkaXNhYmxlIFBNVSBzdXBwb3J0IGZvciBuYW1lZCBDUFUgbW9kZWxzDQo+PiAgIHRhcmdldC9h
cm06IGFkZCBhcm0tdjkuMC1hLXYxIG5hbWVkIENQVSBtb2RlbA0KPj4gICB0YXJnZXQvYXJtOiBh
ZGQgbmVvdmVyc2UtdjItdjEgbmFtZWQgQ1BVIG1vZGVsDQo+PiAgIHRhcmdldC9hcm06IGFkZCBu
ZW92ZXJzZS12Mi12MiBuYW1lZCBDUFUgbW9kZWwNCj4+ICAgdGFyZ2V0L2FybTogYWRkIGdyYXZp
dG9uNC12MSBuYW1lZCBDUFUgbW9kZWwNCj4+ICAgdGFyZ2V0L2FybTogYWRkIGdyYWNlLXYxIG5h
bWVkIENQVSBtb2RlbA0KPj4gICB0YXJnZXQvYXJtOiBmYWlsIG5hbWVkIENQVSBtb2RlbHMgb24g
dW5rbm93biBub24temVybyBmZWF0dXJlIElEIHJlZ3MNCj4+ICAgdGFyZ2V0L2FybTogYWRkIGNw
dS1tb2RlbHMtc3R1Yi5jDQo+PiAgIHRhcmdldC9hcm0vcW1wOiBhbGxvdyBuYW1lZCBDUFUgbW9k
ZWxzIG9uIGNwdS1tb2RlbC1leHBhbnNpb24NCj4+ICAgdGFyZ2V0L2FybS9rdm06IGNvbXB1dGUg
aG9zdC1zdXBwb3J0ZWQgdmFsdWVzIGZvciBJRCByZWdpc3RlciBmaWVsZHMNCj4+ICAgdGFyZ2V0
L2FybTogcmVwb3J0IDAgYXMgc3VwcG9ydGVkIGZvciBJRCBmaWVsZHMgZ2F0ZWQgYnkgdkNQVSBp
bml0DQo+PiAgICAgZmxhZ3MNCj4+ICAgdGFyZ2V0L2FybS9rdm06IGFkZCBrdm1fYXJtX2dldF9o
b3N0X2lzYXIgaGVscGVyDQo+PiAgIHFtcDogYWRkIHF1ZXJ5LWNwdS1wcm9wcy1pbmZvIGNvbW1h
bmQNCj4+ICAgdGFyZ2V0L2FybS9xbXA6IGltcGxlbWVudCBxdWVyeS1jcHUtcHJvcHMtaW5mbyBm
b3IgS1ZNDQo+PiAgIHRhcmdldC9hcm0vcW1wOiBob29rIGJsb2NrZXJzIGluIHF1ZXJ5LWNwdS1k
ZWZpbml0aW9ucw0KPiANCg0K
