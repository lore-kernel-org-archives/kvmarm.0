Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27F103F928D
	for <kvmarm@lists.linux.dev>; Fri, 15 May 2026 16:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861909; cv=fail; b=W/TasxthBuMjwvW/kGg0yIk6rM3u8kR9c2M+zweK6O69IDhxUyrDs+WKuxRatUf4ldKght277N0sSB2rD9MmTHDt6CSuKsQtZ7gR+PXBPx6PcdbZ+FCmG1lfl4crRBtX05xjwspPLJ3D+Ls8BHnVgFZ++Pnlw2ijG/q6WUK02jk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861909; c=relaxed/simple;
	bh=RQiRO1nl4g6dBlch/oHUhsPPxIatIEeZGyuyBF6tDJY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=s0RzBwe4n7jmr19BxwU5RWZzSNRT3SAVOyl450Vv4d++Yxir8uAmDj/zi+DWdZzgVc7K/W1wd7HZCtkQ8YgPT+K1oishykubdjGzv7YGaH60GzK1C+WKdlqcnhlC6AQXUUZye8gdjpuPwsWYLljeylpgKhIceqRXwuyHWxdybBU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=azBAuU4S; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=kqjMrN8f; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="azBAuU4S";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="kqjMrN8f"
Received: from pps.filterd (m0127842.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64F9aSsT1809953;
	Fri, 15 May 2026 09:16:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=RQiRO1nl4g6dBlch/oHUhsPPxIatIEeZGyuyBF6tD
	JY=; b=azBAuU4Svhj8EaRtDfX73sKvGQ9bLeW8fZfK297q0G5RzyWVwWQkyENF/
	g2J0EIm4fThjxdSlNxrnB1dJ31kajCgMK+4Ti5REc3OH+KjXZ/T0Xk/mgcgrHDqv
	MsYXCTUz1Dar3xJFnrBZ0mCXk9IsRZPpXLcpxPByTFL9KqRJJSFFtXCEwpUH5eeK
	Zo4jRDi5dqa65E0kKmDnllWFPmuCA8B986O8KqpPK0qk0jA3X86+EJsQfLQ6C0le
	PH5mvrDFReL2BJvEnZ7sidlAWXBdQjATq2/LRHOrZ6W8ew/JNs+N4N4ZFhJZJIHj
	tD/W+DZZJZADjw69oSpmgZRnmSmNw==
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11021092.outbound.protection.outlook.com [40.107.208.92])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4e5m20agm0-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 15 May 2026 09:16:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oGQ78jvM5BKiqXwAjI5eXmTO/ZtJtUJbGPJnNMTE9w6nee3XEoqTnxXdyqcU3Sl883lLZVAmseBCL8JcucsptKJCdrtVuDIPOwOpRF1NIo7VXDVrdAXRwwjx+V7cno3hIn0CbeXSTl7Gq/CHl+RzXIG8b2JTEKD8It03TBMEi7GqsPa0mAPbOvBilYQWYwH4+l1IgmPubrzHKldJUyYBuvCUzlpyTgWkTZTQvjIEEYHwsUsGhXKtpYzW6UgatodqQvScF3T1vb4Rpdlkd52McVHbGh0d6apoln2LOQeaiCw+/cQngOX3YSnPIcGH+3PE1EjveCkWJGuoJ9We102SYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RQiRO1nl4g6dBlch/oHUhsPPxIatIEeZGyuyBF6tDJY=;
 b=Ym0gXFRyAIiGnz8zfgxSzG0KXpeRdw289/pI+ZW+W11StnIfdRTDjAqgmLQVz6iIEVAOU56MwVRZMZJJCW2X5o5Z3DwxhCoahcOJDMT/RbYjrQVdlhb8bQnSFNr2zZPiphuyxeqHybV5wtZSKY9FBpffPubmz3ZSexSTiDcZeSmt8pfzkV1cNCAvhIudQM57DN7dYouCeJmd3YHmmptbmKexD0TUEIX24sMuQUsQ9JT03Dgjg4RBylGIrFpGi1vlGEa07cLASE6dX6moVAmKP0ZogNNwrAX/8KQG47AO2IJbH9Fh3NHP10J26NYwALs9hq9KYb+8ObQ7EAnIXd9FGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RQiRO1nl4g6dBlch/oHUhsPPxIatIEeZGyuyBF6tDJY=;
 b=kqjMrN8fuTSeuUrR7VftAHQkv+/j3UxauIZEMxsVyWuhgk2sdxR++QxzT0YhL1XxfyVe7Zm18AbCkz1XqXWJDemByo764ukYUzLyAYuNHULOblyrInQTBAUz11AHIaMmQgdiS/HaNgTIkZygXSskH3W+rTHu12hdwdtVei7kWBRKPTLRMJiN59yj4N7lNXYN8QghIqW8vIHDBQxQJb0gStD8FJczHwp2qBPw8xqTLwv7C57kRHAPePeLOshVRGoVPOpcpDZpx0cZT3JacEXcduGEGxIetKbVJWuCPW9N60HH9owb0AgBhMfRDnig4lJ0refLuOz2CB/8vyO67CD1AA==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by CH3PR02MB9115.namprd02.prod.outlook.com (2603:10b6:610:147::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.25.19; Fri, 15 May
 2026 16:13:42 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%6]) with mapi id 15.21.0025.019; Fri, 15 May 2026
 16:13:40 +0000
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
Subject: Re: [RFC PATCH v1 06/13] target/arm: named_cpu_model: data-structures
 required for the ARM property layer.
Thread-Topic: [RFC PATCH v1 06/13] target/arm: named_cpu_model:
 data-structures required for the ARM property layer.
Thread-Index: AQHc4vZYY1My4TwnXUKCyTDRium+UrYPQbYAgAAD5YA=
Date: Fri, 15 May 2026 16:13:40 +0000
Message-ID: <F62101C1-38FC-4D9E-954E-A6F169189F2C@nutanix.com>
References: <20260513163356.3033159-1-shaju.abraham@nutanix.com>
 <20260513163356.3033159-7-shaju.abraham@nutanix.com>
 <a73c5f14-ed64-4322-8315-482e5b621add@redhat.com>
In-Reply-To: <a73c5f14-ed64-4322-8315-482e5b621add@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA2PR02MB7564:EE_|CH3PR02MB9115:EE_
x-ms-office365-filtering-correlation-id: 6f1a3b8f-ce79-4a51-cc54-08deb29ced73
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|376014|1800799024|7416014|10070799003|3023799003|4143699003|56012099003|22082099003|18002099003|38070700021;
x-microsoft-antispam-message-info:
 3YVojiLt9vemjMSmnINOuQSQuirYSoVw1orHZh6IJRMBX5cs9l1xdzTuED2Z9MxyefQMiT/87nAzZvaQAJ3vSvgJOV4bbzZzaq7jMPqdvlCP4PTRRfqX70meAFHB9cQeYPU1gOwhsTaXel5VhV1FCQ8c2tlDja/Ef0INA3dfm9JaHixdj2RU2xLbXdH65EkL0eZB7syNcVyInffklXwEMc/sslvRCHvcj2qsL1krcb21EtPcvbMHIyBDHYvv/RYDFhgE5MU6+7PdD7Y9nQnL9v4NhiT/OGg9k01BWvgRTGB5CETxNP7A0ZhNGZFQlbWlw9JzmY4VP8WeBBJb+5Ch325cqxSGNLSTNidmppWOJasRU3noCXwUbE7IbGf4pZL7NXwlRWWZQzh71NMwinrGSxQC2Hxm/8YpiPlL3ONaKlDj8l8qL2iuT3ytKCgJFDc1apU0LGKuTa/gR2thPd8Iqslqo9NFlRUOBzHYRKND+I18QhFWbmu6SEXVEC087zIV6nu7ZLgVuqNviOotZZS06zcqGKMF/g7IoanI478KbnzW464WEMPcZZgO9KzA9B0nu+DfJX0EqJtreZVXHpJph1Rgc7uPaIxAA7VIyqdkDGPLVi/XoM8KmezN5NtLTaqNRM8FMPZgx/9a3Hk6XyeY95nG6oLbIPMqbQJuFsgqOE3vSY15nZGLtoP1/bd/LVRn+NYOI0+d4Ln9m2iXS9WXz6xvmikvjK6d+oy+oDU19XwKsYUDiRG8TuDgOPm+jOno
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014)(10070799003)(3023799003)(4143699003)(56012099003)(22082099003)(18002099003)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?RTZtakpsUkwxMkIrQWhabE5OOTBTV01CNFpSRnNJT1dycHFHYmJ0U3VubC8y?=
 =?utf-8?B?ZFB3WG5QbU4zSllEMDhod1kwQXBsY0gwaTJUQzg1WFhmUERBdFcyMDdqU1JY?=
 =?utf-8?B?Mlk3eU1SdGVVRmdQRmNIc1VGN2xOdi9Nek40UXA5VXg4d2VOWmc0TEQ0V0lV?=
 =?utf-8?B?OUdtVG5EZkplWlFDZmhBNEV5WlhMeXpndTJMZzdDUk5JTmJteFFLSUUyczlm?=
 =?utf-8?B?a3hwbWE4cFJGbVhaZ2YwQ0lWeEhjS1BBbVpLeVYyRWpJQklvWVBkZjJvd0FG?=
 =?utf-8?B?aHpkTDljL2tLcGdxOE8rWCsyQlFBUmNBT2VhSHFDM1IvSGJLbko3M0pvaU1h?=
 =?utf-8?B?ak9mZzFlN3B3QTI2Y3ZMbDFqNHd0VjZTeU9RN29BY2pzRjkybm5XK1hxTU9N?=
 =?utf-8?B?YlN6Z0tTY0hQWHdaVitXcExTTlRIdnYrRDZxVnU2SStyVHlUOStBcG05Ymda?=
 =?utf-8?B?QjBiVXA1NFJsay9LTE0xa3ZreHFEeFd1TTQ0alMrNXVPRmV4WlhjY00ycFkr?=
 =?utf-8?B?cnIzMDhobitPRVpqVUJYYndSYTErUXA4ZUdZQk1MSXR3R3BGeEFaL0xIeHJW?=
 =?utf-8?B?RE9CMEFzeUluS1VMczd0WFVJZVhGN1FRNUgvdGdPREJXcGJtV1orTUtBSW1O?=
 =?utf-8?B?cVNzaVp2TXZkdE42RzBETnFPWkllc1lqQnVvMHNvdFhwL2E0eThxS0hVeTRn?=
 =?utf-8?B?VXhRT3VEb3RBb1BJa3ExNnJGbkFlNk1SMkF0eU0xZyttOG9ITERTSENOTjda?=
 =?utf-8?B?Uml4TjlLSTRsTGVHY3FQaHIzNEhrdGxuL0VtMFlmaHRPbmludE02ejRwNkJh?=
 =?utf-8?B?UC9WRkpvMmh1YjZ3clVBaWNMd25KQkd6NGVFK252M0k2ZXdzc1N2OGNxNFNN?=
 =?utf-8?B?QnBKOTEyOFBKMVN5SWdOT0NqcFgyaUl2aWNXa0s0ZVRmZGZ2VUJ3a3E2dm1y?=
 =?utf-8?B?eTdmSXpiZWkrNFppb2k5WFlUQTVuQ2JUanFjRHNPZ2M3TktpU2NGRkh4aEor?=
 =?utf-8?B?bGFyc1RET2NwNTlmdlNzdDR3WUhBN0NPOThQaVovcCtTZTg4K0k2U0F1R3d6?=
 =?utf-8?B?bk5QSjNQb1djQUtYRjlrY2tKRzN6TFpTcEMxS3Zyc0YvTDhsMU1GRGdLMWM0?=
 =?utf-8?B?VFJYR2tPb0F4eEhYc2F3TmxXVURCbllzVllMdktFRUFTaitlQ0dFNEFGYUl0?=
 =?utf-8?B?NjNNNVdWcXZvcHpqWEh0RktIQ2ZxS0VrU0F4elBRbVdJc1N2QWtEYVAxbnpa?=
 =?utf-8?B?QmJsc1FmWlB3WWREWmNwaHlPaytIUHRZQVFXOFV4VWk0ZzJWTjNleVVBNlVs?=
 =?utf-8?B?T1RuSGNpeVF3SjRGa3Z3Um5oRHhabkxvQ01jcVA0Y2Z2NS8yT0RzaHJBdlR6?=
 =?utf-8?B?YVhvVkdtZjh3MVc5SkR0Q2VHMnliQzNwdHQyT1d5ZHlwcXR5WCtCeldhN2hC?=
 =?utf-8?B?WlhqblRVTm5jTHlGSVRJb2pNTkhEWWtYcTlUVHpRMUE2WVZiQmtnc0lsdnY0?=
 =?utf-8?B?V3ZiUS9rWWo0ck1iSVVHS0FuWkwwcGM0eHhQTy9QdjlmOFRJRWFkMzdUYzFx?=
 =?utf-8?B?V0xGMXV1SyswZzRRcVhhMG1VU0JMVTJheUxEY3ozSlYyNmZML01pdGJWTkZN?=
 =?utf-8?B?SjZabjVhSzJ0RDlnVzhIb2VBcXBpdWJ0MGd6T0ZFVGUrL3J0Wlk4UkF0ZlhM?=
 =?utf-8?B?dkExMy9DWEVHK2o4S3hsMGNScE1VVEdOYWN1UzhlUXdJK2JabXFod0ZNa3N5?=
 =?utf-8?B?bkphbE1hOElTYUhBOEZWd3BqdE1QOEdxMElxcVNWSGlNSy9vUFhoS3gxTzF2?=
 =?utf-8?B?UnNRektJR00zS3EvRTltWVQ2RzFiUGJxOXNrbjhxWHJBdzliR0JzZjFxNEZN?=
 =?utf-8?B?WVh2MjNGUFcvdW5kREpVd05UWmFVZVgrM1ZGTWFuM3VHempXWFJYUEp5QW5S?=
 =?utf-8?B?TXdmc2NFUG80d3RyTDN1cUhVNUphVnU3RnkvWE9BNjZQVGxQNjZRMkduWjJO?=
 =?utf-8?B?MnNkclQwMnBTbWRPekpGRTI1WXNhK0RzcE9wL0h2WG11SS9ZOFFoaDFUYXd2?=
 =?utf-8?B?ZTYrMm1wOVAvbnNmMmllVFZlYlpCZlZtM1hhbzQ4OEZoaE9uTHRDYWZaMzlh?=
 =?utf-8?B?cGZOM0ozMURBSHNTVDBRaURydnliRGVwQ01yU0k5WUNrRzhhQ2VLVlFVb3U4?=
 =?utf-8?B?QjZlRndjV0k4dnA0YlZnT2FJcEl5MW5LazBPaEYyQlN1Q2ZkbUFNdXZPV01V?=
 =?utf-8?B?Rm1LclFYajcvdFI2WHBQMzdKaDh2NWUyTUY5S3NNbFEzMyt6Yjd4eEQ3RFBU?=
 =?utf-8?B?TnZhWDVkdEtFc0l5Y2VXQXVRaTZYQW5RdFg2cHd4VTRwK3crTERvUXBtQ3NK?=
 =?utf-8?Q?qYKO+fU/Vk0OJHVqn2b4KzjJkWbImR+o+c/yf2WT/Mypt?=
x-ms-exchange-antispam-messagedata-1: TOB5b0B1KIEIRsyjwAzZeP0JtQ4I4EznAp0=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1EE78740ACA657408C45FF4B11FBC2C7@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	bdBw2URez3Loj5ypXqL4X2NPEtGrUB0HApj/r7YhclxYJG7H9PE90j5PpsclEuCAUkDT5ahqS4se3CYzV4OsJ75a2KcZzL3B7XMIz9iNVkSi4xR5j7+EoM0Uj0eVW2SPuB68n0V4EvGOp261s4iVY56LiglQbCob73msp+KDfz2hTtP0kDwonaLW+YOgPrKYuAO7H47li6gfysJ4EBry3kqvKd9OZ3gvweoLMRMAskISVnq6+j9LQv3wkpNeL8oBa2RX/6do8WEeOI1ZeU1qxNKdySSCJ29JkVFw2C03I+zZILg19nY8gGuWk7WpNTrNYr0vTBhri72wS/LDoTcaSg==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f1a3b8f-ce79-4a51-cc54-08deb29ced73
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 May 2026 16:13:40.1066
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BOiLTdZnB/WndUQcQBXUp+C5AsrgTstbuZNCBb8nY06+SnKKWVfHIpcWPaxj6tCmYhtfpgMG5DM65lnx7WJajVdHH42sOJhiHwsyR5D66ns=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR02MB9115
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTE1MDE2NiBTYWx0ZWRfX0aG+tKZKPDsb
 JiXMH7A2wrwhmMA4SH7+0dn+CYTflm8zs485qcq1ddnmyHrJyfOy2iI2hTn258eVM+bpXywdgyZ
 nzg64zTrhqaUzB8JUCtD3HZymVKpVWG+n1MQUMxI1sWlSFRjjVIboM4g1Hy4BTqK1w6kBqkPHvv
 bPKR5d79FVUvHcrUeDePQTh8CabHVsUkdjwKmEDsdzdZfT69voc0QBptzK79Dlc3OhSbioTc/X3
 Nlzf45+lTa0KHIzP2LMq0h5b0VL4BYFgdeHaGvORU+tkZdAicChHk7sR0cu6oCvOijrekiq4/yV
 7sEnzM4Rp7KQNAVR3/N9AJApu1njJGBMqZkTzVByxbu3H+orrRmG2L6kE5/+a8aqzo6Td+VdLbZ
 AVyFnBiTuxsog184WPZPrXaOg1m0n6RvikfTtCwggZiYjBP0UdQ87lDO9q1UUoapR91aRBBOjvi
 zR+lPSALZFQVN42aAVQ==
X-Proofpoint-GUID: RtFJJj1sfNsxTt7FhrS0K32PXWr9nptN
X-Proofpoint-ORIG-GUID: RtFJJj1sfNsxTt7FhrS0K32PXWr9nptN
X-Authority-Analysis: v=2.4 cv=Ed34hvmC c=1 sm=1 tr=0 ts=6a0746f0 cx=c_pps
 a=N7hQvVYZfm862vJ1WlRLdg==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=NGcC8JguVDcA:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VofLwUrZ8Iiv6rRUPXIb:22 a=VUi8bpU7OL1Oj2-RSIOF:22 a=20KFwNOVAAAA:8
 a=6kAs-aptPJy9S__z2TwA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-15_04,2026-05-15_01,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gMTUgTWF5IDIwMjYsIGF0IDk6MjnigK9QTSwgRXJpYyBBdWdlciA8ZXJpYy5hdWdl
ckByZWRoYXQuY29tPiB3cm90ZToNCj4gDQo+IHdoZW4geW91IHNheSAiYXJjaCBkZWZpbmVkIG5h
bWVkIHZhbHVlcyIsIGlmIHdlIHRha2UgZm9yIGluc3RhbmNlIFNIQTINCj4gZmllbGQgb2YgSURf
QUE2NElTQVIwDQo+IA0KPiArSURSRUdfRklFTERfU1RBUlQoSURfQUE2NElTQVIwLCBTSEEyLCAg
ICAxMiwgIDQsIExPV0VSLCAgMCkNCj4gK0lEUkVHX0ZJRUxEX0FSQ0hfVkFMKDBiMDAwMCwgIm9m
ZiIpDQo+ICtJRFJFR19GSUVMRF9BUkNIX1ZBTCgwYjAwMDEsICJzaGEyNTYiKQ0KPiArSURSRUdf
RklFTERfQVJDSF9WQUwoMGIwMDEwLCAic2hhNTEyIikNCj4gK0lEUkVHX0ZJRUxEX0VORChJRF9B
QTY0SVNBUjAsIFNIQTIpDQo+IA0KPiANCj4gSSBkb24ndCBzZWUgc3VjaCBzdHJpbmcgdmFsdWUg
aW4gdGhlIEFSTSBBUk06DQo+IA0KPiAwYjAwMDAgTm8gU0hBMiBpbnN0cnVjdGlvbnMgaW1wbGVt
ZW50ZWQuDQo+IDBiMDAwMSBJbXBsZW1lbnRzIGluc3RydWN0aW9uczogU0hBMjU2SCwgU0hBMjU2
SDIsIFNIQTI1NlNVMCwgYW5kIFNIQTI1NlNVMS4NCj4gMGIwMDEwIEltcGxlbWVudHMgaW5zdHJ1
Y3Rpb25zOiDigKIgU0hBMjU2SCwgU0hBMjU2SDIsIFNIQTI1NlNVMCwgYW5kDQo+IFNIQTI1NlNV
MS4g4oCiIFNIQTUxMkgsIFNIQTUxMkgyLCBTSEE1MTJTVTAsIGFuZCBTSEE1MTJTVTEuDQo+IA0K
PiBXaGVyZSBkaWQgeW91IGdldCB0aG9zZSBhcmNoIGRlZmluZWQgc3RyaW5ncz8gVGhlIG9ubHkg
c291cmNlIEkgY2FuIHNlZQ0KPiBpcyBsaW51eCBzeXNyZWcgYW5kIEkgYW0gbm90IHN1cmUgdGhp
cyBjYW4gYmUgdXNlZCBhcyBhIHJlZmVyZW5jZS4NCj4gDQo+IExvb2tpbmcgYXQgIHRhcmdldC9h
cm0vY3B1LWlkcmVncy5oLmluYw0KPiANCj4gK0lEUkVHX0ZJRUxEX1NUQVJUKElEX0FBNjRJU0FS
MCwgVExCLCAgICAgNTYsICA0LCBMT1dFUiwgIDApDQo+ICtJRFJFR19GSUVMRF9BUkNIX1ZBTCgw
YjAwMDAsICJvZmYiKQ0KPiArSURSRUdfRklFTERfQVJDSF9WQUwoMGIwMDAxLCAib3MiKQ0KPiAr
SURSRUdfRklFTERfQVJDSF9WQUwoMGIwMDEwLCAicmFuZ2UiKQ0KPiArSURSRUdfRklFTERfRU5E
KElEX0FBNjRJU0FSMCwgVExCKQ0KPiANCj4gaXQgbG9va3Mgbm90IHN0cmFpZ2h0Zm9yd2FyZCB0
byBsaW5rIHdpdGggQVJNIEFSTSANCj4gDQo+IFRMQiwgYml0cyBbNTk6NTZdIEluZGljYXRlcyBz
dXBwb3J0IGZvciBPdXRlciBTaGFyZWFibGUgYW5kIFRMQiByYW5nZQ0KPiBtYWludGVuYW5jZSBp
bnN0cnVjdGlvbnMuIFRoZSB2YWx1ZSBvZiB0aGlzIGZpZWxkIGlzIGFuIElNUExFTUVOVEFUSU9O
DQo+IERFRklORUQgY2hvaWNlIG9mOiAwYjAwMDAgT3V0ZXIgU2hhcmVhYmxlIGFuZCBUTEIgcmFu
Z2UgbWFpbnRlbmFuY2UNCj4gaW5zdHJ1Y3Rpb25zIGFyZSBub3QgaW1wbGVtZW50ZWQuIDBiMDAw
MSBPdXRlciBTaGFyZWFibGUgVExCIG1haW50ZW5hbmNlDQo+IGluc3RydWN0aW9ucyBhcmUgaW1w
bGVtZW50ZWQuIDBiMDAxMCBPdXRlciBTaGFyZWFibGUgYW5kIFRMQiByYW5nZQ0KPiBtYWludGVu
YW5jZSBpbnN0cnVjdGlvbnMgYXJlIGltcGxlbWVudGVkLiBBbGwgb3RoZXIgdmFsdWVzIGFyZSBy
ZXNlcnZlZC4NCj4gRkVBVF9UTEJJT1MgaW1wbGVtZW50cyB0aGUgZnVuY3Rpb25hbGl0eSBpZGVu
dGlmaWVkIGJ5IHRoZSB2YWx1ZXMgMGIwMDAxDQo+IGFuZCAwYjAwMTAuIEZFQVRfVExCSVJBTkdF
IGltcGxlbWVudHMgdGhlIGZ1bmN0aW9uYWxpdHkgaWRlbnRpZmllZCBieQ0KPiB0aGUgdmFsdWUg
MGIwMDEwLiBGcm9tIEFybXY4LjQsIHRoZSBvbmx5IHBlcm1pdHRlZCB2YWx1ZSBpcyAwYjAwMTAu
DQo+IEFjY2VzcyB0byB0aGlzIGZpZWxkIGlzIFJPDQo+IA0KPiANCj4gVGhhbmtzDQo+IA0KPiBF
cmljDQoNCg0KWW91IGFyZSBjb3JyZWN0LCBJIHNob3VsZCBzYXk6IGFyY2hlZCBkZWZpbmVkIHZh
bHVlcyB3aXRoIG5hbWVzLg0KRm9yIG1hbnkgZmllbGQsIHRoZXJlIGFyZSBubyBuYW1lcyBmb3Ig
dGhlIHZhbHVlcy4gQnV0LCB3ZSBjYW4NCml0ZXJhdGUgb3ZlciB0aGUgbmFtZXMgdGlsbCB0aGV5
IG1ha2Ugc2Vuc2UuIExpa2UgbWF5YmU6DQoNCitJRFJFR19GSUVMRF9TVEFSVChJRF9BQTY0SVNB
UjAsIFRMQiwgICAgIDU2LCAgNCwgTE9XRVIsICAwKQ0KK0lEUkVHX0ZJRUxEX0FSQ0hfVkFMKDBi
MDAwMCwgIm9mZiIpDQorSURSRUdfRklFTERfQVJDSF9WQUwoMGIwMDAxLCAib3MiKQ0KK0lEUkVH
X0ZJRUxEX0FSQ0hfVkFMKDBiMDAxMCwg4oCcb3NfcmFuZ2UiKQ0KK0lEUkVHX0ZJRUxEX0VORChJ
RF9BQTY0SVNBUjAsIFRMQikNCg0KV2FybSBSZWdhcmRzLA0KS2h1c2hpdA0KDQoNCg==
