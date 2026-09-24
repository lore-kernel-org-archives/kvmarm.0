Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4605839CCF6
	for <kvmarm@lists.linux.dev>; Thu, 24 Sep 2026 06:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790231218; cv=fail; b=gL8JqAiePXinnWMx1CGdiZAa0awGBG6UfofjG70FN9JqSFgtuSpnAvoUwz9vggvVdQeaPpwT+cIP3R0uBt+2WhM3Yq/IMLSU8p9DCjCffpWf6mTEoprDMv2fDrWQwhblq/82C/CEXsIv2vaRO2LTBZ4MC6i1jJ1AseKXkqWqoS4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790231218; c=relaxed/simple;
	bh=5A7xlpGPtsTFsHua4771nq/PDEVR9uPNE6Y4oZberXg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=roBEYPkgEG/Z5Z34fYfhNu+TJwhurfnrPk5411To4xDl9Fcksxj1DuNGh2xNmSKfGUVx1cEFmuTFwOomTexRbk3QB61vHK9U84PHdLHZR5myBHGMqMdMJuzcLvhEs5N6ANgrC4RFvYuw5pAHTk6OgS6lY+ZLJHfmJqEuxRi6X9w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=0xUJqFS8; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=a+uzdpbp; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="0xUJqFS8";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="a+uzdpbp"
Received: from pps.filterd (m0127843.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68O5bSAW1147433;
	Wed, 23 Sep 2026 23:26:39 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=5A7xlpGPtsTFsHua4771nq/PDEVR9uPNE6Y4oZber
	Xg=; b=0xUJqFS8oGrTXkasuiHdl5rI9XZpSLspVXIm/48VaQ45Fflr6q5eOfZZ0
	gt3tbDDQPDmC/x7aw+1GdL74ocu4ZQRCi0E9xg83AMuTWhoouchvkRDqaWQbi1lq
	/ASmmJ5Ki8th22bDtuZXhy0YnkB3vJ1EMbRcTfZQciU7EhIBOKdNrcmyNsNLbc+z
	LhTmjEPf5ELiXgmfA6nToOaLyOu26NFaEMZKhebTfIVfrODGmxc/5bJjOgablCvV
	e80Lko6DX04u3KPv2COWRA0O/0pc355zGiM/aaBJPwiESKWjjJLgiyMDXbz4wFvx
	a/0T93Hcs6HTgaD2Q0vDSxmjhseHQ==
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11021111.outbound.protection.outlook.com [52.101.62.111])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4gv326bu60-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 23 Sep 2026 23:26:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=L0nBNlAaOj5YCgIqqdRmk8qvh83yG879WaJwy/4X8hL60mX4kQ6Ab5zflaa0YWAWypEbHJekAdhoDWIU2imh6tkvO9gUAxMRE/kGjzpksxdxelbZoAh//D6+bjDYmy+dKvZkz56MZHCkP94aJU1hIYvHnqIMQtP9cthXMwrsKymQUJM/1w4E3tyO8DVFcyRoYuHrYR3g0Nngz28gLxyGGPF1ThA3MsE9NJ6lcPLOFfqoxz2dsnCHNsXVQiqHPfliTp4P8yUpLwCVx9n1qTACTWnTLOEERkdwdPsffsTKEC1TSgvwUIPVB4icR7diaA3o+iLO8flDtmKyEJpoYArjoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5A7xlpGPtsTFsHua4771nq/PDEVR9uPNE6Y4oZberXg=;
 b=r1pWPLsktv6tnA0aPrvo7dMTOvb1dK5YWScZemgUbCRrlEA0zlzyFE378Q1qMj/UVpZnIcYxux3Np+8QOgW9UkwqeK/v0etvUAzXWdDmkJovULJM8ESl92XWg87X+eWkYdeaqTA8FJE4907I1gj8UgbMyGqBB+4UCyDVVtF+wJVmzOlFimdRf8Ou0UBXURmrQqk8sYq6JxwE+MS6I3UFVndpO9B2Qp3BfHYkAtoyCCX831naLqErqUdM1fydDa2lQ4EIvmaG/c0Ki2X+yaergRQhD9aX9Mg2jRNFQntWdtIzZNj2h0WrqWNYE18/Vh4WboGsDIarBR0ZPq9wOzJjMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5A7xlpGPtsTFsHua4771nq/PDEVR9uPNE6Y4oZberXg=;
 b=a+uzdpbp9oQAMQtkF3BRQBvCRNxRP40PaCWrmt8GZGqqmPwfFnYdEajZ8ItO1Hob1QuoFAisBhmLJDeb93umH+dF64mr+DDrfLR8+/g8FOvYTCUb92XflBsK0QWmtiJt8dAcpDBERxwNPcM9aI4r3843OR5xA4vl71VHXagy8Dhvjn9cmJdRhC1k25+3XAZR/iX3VpUhL30OKBfmbtwNrWvYh+i7TzPb+GGqaHpz5hA5BY68OKUsrkRNAnKON7mkhZkRz9e6UGlVAdeUqUAFEunz+I/QsHsTtbXrHUjmTfJc37nXSre24DdLFjxGYK5J2UKzjxM9Ip4YAjRDL4Bqtg==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by MN6PR02MB10607.namprd02.prod.outlook.com (2603:10b6:208:4ee::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.16; Thu, 24 Sep
 2026 06:26:25 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%5]) with mapi id 15.21.0451.014; Thu, 24 Sep 2026
 06:26:24 +0000
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
Subject: Re: [PATCH v9 13/26] target/arm/kvm: Introduce
 kvm_arm_expose_idreg_properties
Thread-Topic: [PATCH v9 13/26] target/arm/kvm: Introduce
 kvm_arm_expose_idreg_properties
Thread-Index: AQHdS+2fsygTgJNcvEORBBbmSAH7rw==
Date: Thu, 24 Sep 2026 06:26:24 +0000
Message-ID: <67EB28E9-F8CE-4BE1-8712-88583DEFF24E@nutanix.com>
References: <20260916144721.751810-1-eric.auger@redhat.com>
 <20260916144721.751810-14-eric.auger@redhat.com>
In-Reply-To: <20260916144721.751810-14-eric.auger@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA2PR02MB7564:EE_|MN6PR02MB10607:EE_
x-ms-office365-filtering-correlation-id: 034a8455-a728-446b-8bbb-08df1a04c1fa
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|7416014|376014|23010399003|56012099006|4143699003|10067099003|38070700021|18002099003|22082099003;
x-microsoft-antispam-message-info:
 vKVFcO50jLAyXaHDted2eLvKFpWuB9y0B0oJ7phTUnrNyqeX2qfzvR3RYbYznpIux1GeqGJKkifgVl3hEQRzNv296rYoe8PkLawFKM1cAAPz6j8LCdUMBOgWMatsdEaTgcmZ/SpMYkEkxXDi7KJ3SXdCvOCdvwn0YBQir/kuBrHpbBVcdMqEiQWPvZSaVneLjd2rbjfMsJvURtx1UOBcNakDVzBg4PcZkh3NEgAvOfCUT+MLHnfRr8Gc8IE2h8+8Mna7oP17BPlma9M32Pz6lZGItBDIX1Ap6ILxbdnb58Car4ScSAM1/byg1NDQ9/akW3F37pTjQblri9THHUh3eu+3d27r/H8FluOnGOKWoGdxvFpNiURrsy8LGQUM45XXTuaamZL24lPhO6frG7z/2wys1cNl44H2PAJ38G4OgGQwydvAe/+SERU9r7dfukZVw0RaMWhxqmZe30lWEeNLCnOHlBvU+ur4TC4E8pJ8Lopj4JUzB/UjOtiipr/ug5h0vN5Jwb4kNaYZV15CSpqOlQW/Bb3U9N/TT4HogfSvP6pDsTzP7aOOnQM+ih35etfLh2AGym5RELHVEmofbirhVpVBo9DId+7tAiEwVymU+/P9pThdhgvmkcR1Sv9k2+rqYhErVC7YWLjyHKtrX3rztjnLWyIsGO2gWPpEIwTBZNZC2gxx0HDKmy2Z2XInigM2p8+Z2CF+15IRmOaET4hygvaY9Xye2HQEVczCQejTj5g=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(23010399003)(56012099006)(4143699003)(10067099003)(38070700021)(18002099003)(22082099003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?Q0VKMUt2WWcwajZ0cVRzVk9aVzk1OURuUDVBR0o1OVVHWkJOSThCNThKRXBQ?=
 =?utf-8?B?eEgzbTZUclFXdUtUdGh2QUxQWW42WkpoeWhaM1RndnFkTUhlSTFSVGorTGJT?=
 =?utf-8?B?R2hSTWRHblQ5TnNhbkl2ekxKbDZFV0tmQTZpWWhEeHFUbFJMRGkrcWk5QzNW?=
 =?utf-8?B?K0dBcFdKOWc3b1lOUkdnUlhEdGoyQVB0ZjlHM3hxbTNlNHpGVm5rbmtvUEt5?=
 =?utf-8?B?R3BVWWU3UW5IamlvblQzQjlIVzJGUTdsT2l1bmVqVU0zR3ZmQS9DVnZRU2E0?=
 =?utf-8?B?LzN5QmFpekpoUjhzZnFXSkFnVTh1WS9nZGVUdllkQjdHYkM1Tzd2UUpRY0Zm?=
 =?utf-8?B?Z0JmdDlwc0xXTmZhNE5vQ0JDaTY0bEl1eWR3cldtUWRSYzl5b3BCMHlOaStO?=
 =?utf-8?B?eGhLVmdFMUVidFVZVWhYU0l2VkVKOGZUZHhzWEtmcVlrNGZXa1N6VWZWTW5C?=
 =?utf-8?B?M3o3MGVXNURNN1Y3Vmt6dW9RazNUbk83VHZzb3RHYlhXdTJ1OURtd3RhODI0?=
 =?utf-8?B?d3lmYkhwTnFKN2FIcGwrK1MydTd1RUVKMTEvRGdqQTRSRFBnYVprdG80a0h6?=
 =?utf-8?B?TjVsYkFwQWRhbWNvc1F5ckZwekh4Q1dhSEE3dHpYMVRXRi9WWWZzek9mUkdT?=
 =?utf-8?B?WkZGaFkzWmR4Qi9YWEI2UERaaWxmS25idHY1aFo3Q0I3MnlvSzk3bkVadnRn?=
 =?utf-8?B?NDUrZGtlaVpTWDl2eU1qUGVIY1h1aW9OUkRlT1hIa2pRZmpQcEMrWnk0RFZw?=
 =?utf-8?B?bDFIYnptc0Y0OEZpbEF5R3V1ZzAzeG95bEZncE0rcktWU2hTQ0U2MGRCdjl2?=
 =?utf-8?B?UnlIeWVwbVU4OFRKejY2WUVBOWNBTFp3TExWV0V5dm95QjBNdVAwdVlGSUVY?=
 =?utf-8?B?eDFkdDlWRzRrdWxwcnc0OVk3STdMY1cwZzNnZmRsTStzR3hIR0pkS2Q0UXV3?=
 =?utf-8?B?S0VlaW12UEx5aDNsSC9aOWRSRzVUNzNFV3EzazVVQVlDa1ozSGlZVlpBbmFS?=
 =?utf-8?B?Q2NLOUIwb0J0S0dEMzZnci9sc2NBUnVKTEEyd2pUdDdHd3cwVnRPTWc5QzZK?=
 =?utf-8?B?OHVMckYvM2hDUDlJSXVwRzhoOXN5eHlWa2tZdVdVaDFHclBTd1ByR3NwNXFZ?=
 =?utf-8?B?T25QczVPdUhxdGhFdU42dGRLU3lrM2VtS0xpcW5NV3RueWlYMzZJOUVSbjFH?=
 =?utf-8?B?UXZsb2NsUlVmdldXT2VqMjBkSld3bE9mQXlxTC9Ec3VpUG5rS0hXWnd6eHB6?=
 =?utf-8?B?UWd0ZEdlajlqeDM5ZWswaW01dkpyQXo5SS9aSS93Y0orZzF2UCtjR2dtQUNF?=
 =?utf-8?B?eG5kS3U3eUV5VHBWSDJPQjZEOC9JTitYOWo3SjZPN05zVHJ0V1BLRHRVUEZI?=
 =?utf-8?B?NXRVWkF2REdUVU5FdmZwVVkwamJGejd6eHFwbmo5ZCtyMlVTZVZPMmh3RVhS?=
 =?utf-8?B?WnRLWkxrcTdNOU9UV0wrcm5TT0VZTTBSOG9SVHYvREFkRTZjMWRsTzlpeWlv?=
 =?utf-8?B?bkNoSVFzbUh6WUdlRlk0S2lKLy9kbGtwSkxaYUw1bXhyUUVXZkpkem9GQ1du?=
 =?utf-8?B?RElIV2swK3dnVGhSTzUxU1ZOTHlUc2I5cXZ4UkhsU1lES01zVFhQakhGNnVI?=
 =?utf-8?B?M09YVDhNNXYrVk9aRUxhNEtpVGhTL2tCSmdBajYySmJGaDZoVjBTcDZQcExP?=
 =?utf-8?B?NE94WkRZWmRUd2ZUa0lueFVhMXJQa1lZTmhZa2VZbVV0alJHdWZucVJQelU2?=
 =?utf-8?B?MHBjVmhlSDk3elFjQjZoM25ndDFla2FUVlgvZVk2QWVOYUtGZ1oxNUYxb0d6?=
 =?utf-8?B?Y2NpRy9rVVg1UEV4QWJTMGJoZlB2SXBOTmpXazVqRk1jZFoxSDZPQlg3OGF1?=
 =?utf-8?B?Rm1BRmpPekp6WDFrbjRESHNGK0t6REMzNVJSTzJSUU1JZGVJODVDMG9tSStF?=
 =?utf-8?B?OVdsYTRjRVVyOEdXZkh0UTRKRnZJRGR3SXJUa0htMkd1aVcvUFpDR2Y5NE9U?=
 =?utf-8?B?VmdoREF2Nmhzb3NZUHpCdmpOL25KMzhSZFUyVVpYakJ5a29Dck5WVWtsOEtt?=
 =?utf-8?B?RkM0ZTVPMTRPQktuR1FRL2IybC9wWTdlRHlDNXM2ZW5rZTNNa2hBZVJ6Qmp2?=
 =?utf-8?B?V0NTVkRnVkdQa1pPZk1SR3VObW1DbzhxTklBMGg5TzZRTUtiaWF4Vk56Wksw?=
 =?utf-8?B?ZEFESGs4djJzRHlLVUhNZkx0ZDVtc0xxNFY2S2NzUVlEM240MUp4THB3UXJu?=
 =?utf-8?B?SWVYOVlnbExWVndaT3pqM1k5VDhVWXdDdGNJc1dnZy9TZG9WVXVNR0RoYzJL?=
 =?utf-8?B?TUcvTlIyWndOQnNjaDlsV0F5aDVrSTZTOGhxdURHbG5LdEhyUXB6bXNocHEw?=
 =?utf-8?Q?QjMkv47OFEp5a24U=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FFEDDC1B59FC614C955D79963000A58C@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	x3uSmb9jB5mYFREwveeljkfOiUoIa7HpoflKN7Y3W9pRuJQbN8MHd+u9ak8YJS11LkgxutY364p7D6VStaH7hN+Iv+qIeSfwvWDQ1XkoBHLo8CVU/KgouVC43x1eqYJ2nP58nDb2eugzwH78VUEGlKLv+3rdT7f+U408M63my3cRiyRCaY7d84q8C5HKQ6E9JYRduNniVfD4fGQhAOR8f54lOZ/x+Nv8XB4PPSQPbxkTobrUlflRVNIQxrynMu1vtc46IwJcUozoAJ6l3xWfyocBdO3jgGz740po7oV0l8cBvXiVwE7E2deRZF+QFfN3zscrv5jSGOee+zgAhminQg==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 034a8455-a728-446b-8bbb-08df1a04c1fa
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Sep 2026 06:26:24.5804
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +jMZrkcuTBXCfzJv10+V51vg5+psEuxM2oEzfd8codik6pUnMK9mG6ruJ14fTDE1P2GkkDsnj7dUgURK6Ci297fh6Zs+jZDerip+Kq6jTt4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR02MB10607
X-Authority-Analysis: v=2.4 cv=XNKl2ghE c=1 sm=1 tr=0 ts=6ab4c29f cx=c_pps
 a=pLVGl/zQNnluPJXkQhez9g==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VofLwUrZ8Iiv6rRUPXIb:22 a=dEe9Ve2bX-KnNSUMM2s9:22 a=20KFwNOVAAAA:8
 a=kcWajEm6ENIvncBVwyMA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: iBg681ItMcU1JoQTXNL-dhtdpiEnEgjZ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI0MDAyNyBTYWx0ZWRfX55svIW/3p4y5
 g5oWTi5EWv4o6NaTtHOpDUG4DxxlEi2zd4bG55E/EnsNd8KBHNYn6Wiqgqq7UjKOnbJgMzLIGyJ
 ux+jyZx186uSOg0bIQOu+NDvKu4LTRiRGrTfdSfLbRnQpjzBmu1DEtswNragYH03HmR/lzQUYv+
 QQGOxl5H3cA1rgemBdIiybH6qReGbr1qFDbC78MNfvKiA2HssnJevRfZbfVWXo4OoMmJGV5GRft
 cisnXj3nWqJFPym7iT04ahcG7rg+7AbAQGEYtIxxtb9gTEJdI1ntCEuskPdmiG2bvq5pBtrT6ap
 LdxKDLN0s9ecpR9hTZ5x4AvsggEXC1SGyz8Avwl0iLI1P1UqD1xJUCpJivJUHy774mQGSbWnX4R
 ANAXaIIMGpizs6xeEhz2LUMBKrTBvpMSWf5ABZQuFvk4dc372f5hfJPOoVRuAJFz39niK49Uc4d
 5YwNOhOoWT1FpLzmMGg==
X-Proofpoint-ORIG-GUID: iBg681ItMcU1JoQTXNL-dhtdpiEnEgjZ
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI0MDAyNyBTYWx0ZWRfX3tIpGDW1sbMC
 fD8lfPaCgYk6pI/9V0y4Qy/txxSJndY8LZaCmfgBsbE23+u/JiOXuroFzOFpy2FBq85cUCWYx7T
 9w7UHiIOu7PXxTDQxbQpO79fBRwGjHc=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-24_02,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gMTYgU2VwIDIwMjYsIGF0IDg6MTXigK9QTSwgRXJpYyBBdWdlciA8ZXJpYy5hdWdl
ckByZWRoYXQuY29tPiB3cm90ZToNCj4gDQo+ICsNCj4gKy8qDQo+ICsgKiBkZWNvZGVfaWRyZWdf
d3JpdGVtYXA6IEdlbmVyYXRlIHByb3BzIGZvciB3cml0YWJsZSBmaWVsZHMNCj4gKyAqDQo+ICsg
KiBAb2JqOiBDUFUgb2JqZWN0DQo+ICsgKiBAcmVnOiBkZXNjcmlwdGlvbiBvZiB0aGUgc3lzcmVn
DQo+ICsgKi8NCj4gK3N0YXRpYyBpbnQNCj4gK2RlY29kZV9pZHJlZ193cml0ZW1hcChPYmplY3Qg
Km9iaiwgQVJNNjRTeXNSZWcgKnJlZykNCj4gK3sNCj4gKyAgICB1aW50NjRfdCBtYXAgPSByZWct
PndyaXRhYmxlX21hc2s7DQo+ICsgICAgaW50IGkgPSBjdHo2NChtYXApOw0KPiArICAgIGludCBu
Yl9zeXNyZWdfcHJvcHMgPSAwOw0KPiArDQo+ICsgICAgd2hpbGUgKG1hcCkgew0KPiArICAgICAg
ICBBUk02NFN5c1JlZ0ZpZWxkICpmaWVsZCA9IGdldF9maWVsZChpLCByZWcpOw0KPiArICAgICAg
ICBpbnQgbG93ZXIsIHVwcGVyOw0KPiArICAgICAgICBjaGFyICpwcm9wX25hbWU7DQo+ICsgICAg
ICAgIHVpbnQ2NF90IGZpZWxkX21hc2s7DQo+ICsNCj4gKyAgICAgICAgaWYgKCFmaWVsZCkgew0K
PiArICAgICAgICAgICAgd2Fybl9yZXBvcnQoIiVzIGJpdCAlZCBvZiAlcyBpcyB3cml0YWJsZSBi
dXQgbm8gbmFtZWQgZmllbGQgIg0KPiArICAgICAgICAgICAgICAgICAgICAgICAgImluIHRhcmdl
dC9hcm0vY3B1LWlkcmVncy5oLmluYyIsDQo+ICsgICAgICAgICAgICAgICAgICAgICAgICBfX2Z1
bmNfXywgaSwgcmVnLT5uYW1lKTsNCj4gKyAgICAgICAgICAgIG1hcCA9ICBtYXAgJiB+QklUX1VM
TChpKTsNCj4gKyAgICAgICAgICAgIGkgPSBjdHo2NChtYXApOw0KPiArICAgICAgICAgICAgY29u
dGludWU7DQo+ICsgICAgICAgIH0NCj4gKyAgICAgICAgbG93ZXIgPSBmaWVsZC0+c2hpZnQ7DQo+
ICsgICAgICAgIHVwcGVyID0gZmllbGQtPnNoaWZ0ICsgZmllbGQtPmxlbmd0aCAtIDE7DQo+ICsg
ICAgICAgIHByb3BfbmFtZSA9IGdfc3RyZHVwX3ByaW50ZigiU1lTUkVHXyVzXyVzIiwgcmVnLT5u
YW1lLCBmaWVsZC0+bmFtZSk7DQo+ICsgICAgICAgIHRyYWNlX2RlY29kZV9pZHJlZ193cml0ZW1h
cChmaWVsZC0+bmFtZSwgbG93ZXIsIHVwcGVyLCBwcm9wX25hbWUpOw0KPiArICAgICAgICBvYmpl
Y3RfcHJvcGVydHlfYWRkKG9iaiwgcHJvcF9uYW1lLCAidWludDY0IiwNCj4gKyAgICAgICAgICAg
ICAgICAgICAgICAgICAgICBnZXRfc3lzcmVnX3Byb3AsIHNldF9zeXNyZWdfcHJvcCwgTlVMTCwg
ZmllbGQpOw0KPiArICAgICAgICBnX2ZyZWUocHJvcF9uYW1lKTsNCj4gKyAgICAgICAgbmJfc3lz
cmVnX3Byb3BzKys7DQo+ICsNCj4gKyAgICAgICAgZmllbGRfbWFzayA9IE1BS0VfNjRCSVRfTUFT
Syhsb3dlciwgZmllbGQtPmxlbmd0aCk7DQo+ICsgICAgICAgIG1hcCA9IG1hcCAmIH5maWVsZF9t
YXNrOw0KPiArICAgICAgICBpID0gY3R6NjQobWFwKTsNCj4gKyAgICB9DQo+ICsgICAgdHJhY2Vf
bmJfc3lzcmVnX3Byb3BzKHJlZy0+bmFtZSwgbmJfc3lzcmVnX3Byb3BzKTsNCj4gKyAgICByZXR1
cm4gMDsNCj4gK30NCj4gKw0KDQpXZSBjYW4gdHJ5IGZpZWxkIGJhc2VkIGhhbmRsaW5nLCBpdCBp
cyBtb3JlIGVsZWdhbnQuDQotIGZvciBlYWNoIGZpZWxkLCBjaGVjayBpZiBub3QgUkVTIGFuZCB3
cml0YWJsZS4NCg0KPFRob3VnaCBJIHdpbGwgYXJndWUgdGhhdCBhbGwgZmllbGRzIHNob3VsZCBi
ZSBwcmVzZW50IG5vdCBqdXN0IHdyaXRhYmxlIDopPg0KDQoNCg0K
