Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7A5C41CB31
	for <kvmarm@lists.linux.dev>; Fri, 25 Sep 2026 12:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790339885; cv=fail; b=itghAWVA1oXJF+CF9khipciI2QuRh6mi4SbAku9yWFit3EW7DJC6tEhjGuSY1bPI0hHLCUwX4bC1JBFXECFpUhPW4i8uIJx6fdszmKCzC6UQVk9QdqhVyyhmDm1aXCs4KzR/eMs43LOwxm+na2lkx96uSpHC7SptdhjbbRfTaOA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790339885; c=relaxed/simple;
	bh=ku0kf4zLmM31g/Fp7F0Iq6DJJwpXVbHAbLi/O6Qh9iQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Z96aGEXAWv9oigXWG1rxDOcy1b2y580qNUEw1Lq3F8jegSxz8vcjrEE93ZmR0eUcKnzHBW5Xcm0w6gSEsh7LBZRJwHNugA9JnXs92QugVxSI15eGURwewe3v/o4ihezBLZPKNVky2w4i68u6HtC7HQJLUsEV3rcV5DT2zM1c4T8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=oK0WF4ii; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=pH3J8nhj; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="oK0WF4ii";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="pH3J8nhj"
Received: from pps.filterd (m0127841.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68P4b64k4013078;
	Fri, 25 Sep 2026 05:37:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=ku0kf4zLmM31g/Fp7F0Iq6DJJwpXVbHAbLi/O6Qh9
	iQ=; b=oK0WF4ii9kOtoUUtEskuF/NDAQyo1dauI9SZsvHanKBUEwTqUcQjX/v/Z
	/hng+VKdmomMZU0Ez4sDJD8Y/2Et0qhjSy0wdkguzwtVnRRUgNMdXHJInbv2917z
	FpzhTvImaz2dOpkyQC81Dc2pDhj+2kpWJ4tTy9gUWmsCcB7fmp5OuHwBozlyjpBg
	OqVJ1FEt3bBpWQIYmh8fsh08LVGHmFc+1S0NgHvsEfuWUSOLH2SO+RgvO4QTeuJ0
	cLEK1B1ObxO4SZrhGqw7nCD3dK//+k0x++Mji04HSSkZfq7q79ZTLvO3O4NshA5y
	GmmttUSdn0Rwu4geYFnX03w+KC/cQ==
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11021143.outbound.protection.outlook.com [52.101.52.143])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4gw81ej1ww-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 25 Sep 2026 05:37:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FqoSZyDe5DZxzSKVwbG/juM7bHIMOkhaLzAKM97/rzaMlI+0gdg4N6fpVET1riM6EpOauM0L0Bbbgt95TfW3uxqq3cDUrx+igFlFTKkRVh6d9q68XmxlyzSXHx9q9tXgAq9d8fg6Gxvdtfk7GEyv0GmkvhF7r/JanK9LK3YO5dTmsIl9hQE3xrIjXCZwpkkR1Lim6+oY2Kcy+q/j6v+8joDjnDQAucKmnL9GjT6Eu1/f6JFSdQl+sulsxJ9JBOd9nxx86N56HQy1MXu0TAlgCs5+ENDn/RHRvIm4p30yUabVxtLlZT5y0m5hxrzVA2MrwucClaQWyhDZARnSaVKSWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ku0kf4zLmM31g/Fp7F0Iq6DJJwpXVbHAbLi/O6Qh9iQ=;
 b=wHSFNx3NLiomP1SSWhhG+XXbQg8seP//Sc77HfVVqbNvzUkzpra+YWKw5kFAelgM0FbGEuipLrVfbWxrCITBXv938H/FYzRUF6y3SI9zMovuiVQe+9Q2TDB3gWTu6dssq7AgKHaN2ueTl6kX88pW7PEOlVO4MUQKxm52KV7gigbIUF/rkvnJ2QMjrKQb3JftCmCwiQS9kuxsA85r1cm2oPZk4W5cqGna8h9or8Pn4VANGF3rx76z0sELevQkVC8YHwyT3kgiwBoKfucsHziiUZt0xpc2U0k5YvCAkAjMPhpt5QvLYU/xxEskIz8hm14YflmL9oov3H9NAhH/hRZebg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ku0kf4zLmM31g/Fp7F0Iq6DJJwpXVbHAbLi/O6Qh9iQ=;
 b=pH3J8nhjMPkMoOFZW8lSRWpDUTQeGlslNgUUMw2z1JGu1R3g1Zt5St/BSD0BL1vZ1Z+JXMAd9zbjF3AZpmZODD2mdHc0eOVgZfeWczMpm79M+AOmDN2pqPSRv06CfO7SBGLYp+BL5o8XAEAn0Ii2RPW+MdYQC7MEOCCWjBLU4mQGx/tk6xgSM1EkpBHHrVN22STKM3ZYGM07vUCPwh2UMzf3LOnfR+HlUaWk5lhbKaRaJeFKVWNyQc0xhcZDZveBUA2rhc2ybpd2QP7OI5pLKu5boAbCKdmApDYaofkRjKUgko8gmM6Zsj2/1jQc2n9pkZ5raDjxwsZ1A98leqCD1Q==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by DS6PR02MB343405.namprd02.prod.outlook.com (2603:10b6:8:4b5::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.18; Fri, 25 Sep
 2026 12:37:50 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%5]) with mapi id 15.21.0451.014; Fri, 25 Sep 2026
 12:37:50 +0000
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
Subject: Re: [PATCH v9 10/26] target/arm/kvm: Retrieve writable ID reg map
Thread-Topic: [PATCH v9 10/26] target/arm/kvm: Retrieve writable ID reg map
Thread-Index: AQHdTOqtIaWCor0bzU2FBojyWY8VkQ==
Date: Fri, 25 Sep 2026 12:37:50 +0000
Message-ID: <FC2C35F5-6C1D-4C8C-B4E2-9D2EB1924445@nutanix.com>
References: <20260916144721.751810-1-eric.auger@redhat.com>
 <20260916144721.751810-11-eric.auger@redhat.com>
In-Reply-To: <20260916144721.751810-11-eric.auger@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nutanix.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA2PR02MB7564:EE_|DS6PR02MB343405:EE_
x-ms-office365-filtering-correlation-id: 798b6d47-9e76-4005-c401-08df1b01cf8d
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|376014|7416014|23010399003|10067099003|4143699003|56012099006|6133799003|18002099003|22082099003|38070700021;
x-microsoft-antispam-message-info:
 HXWSyIz6TRkV8vQ+JAAx9eg7jIPStTDGoeadj5F0Udct5tG+iu5hthvxJjSnfCqGvyOyxMKezEt8aGyr0ReivYHEMPVoeWicYnMAtBgvo2hqEBSikOjbCrpfiDlw4JbJXM8jvpwG0WxRcY6SJjKR+jcxlyhCMlvkDqZXsZblLdL7WzvyybBcwiZYIr4lXU6OM+9xrQBoI4+92jtS+1g+/SNeuAJT6mdYHx5WSRSi+XkJp0e0s7PRUHWtV9U902A1vArE7SCdRdGTJW1w6VWp/mMcbc2gXZ/f8/uUQLQX2RWyD3C/q9V5HAtX8RGKb+DcjEn6x3G5YNLar6k9PnqSohZlCcmZ+w9pNMAZbNIHTF3nORsYjwOtpeiKkDHSP1ZY8uFoGTh38COtjqkUiAZ4f+wxzeFXojZ8iUF+/SoYk0YI5mFEAF2bfyJB6sf/qoT4MdUPT8wY959ZIb6hZlwHrEajYGd5yVK2lCt2EvauiYM9Im7ZVQLgLbM5y4tYvWl+nqjQydMCqT84iCi+9A964aezunA2n5C0HwJK+qyk1iDZuNzu+8zzyL6LuQu/gdO3iHHIcVSZNBYR+uqoo0T3noiI1qGIH2a/ZxFmr91ljeQ3EzmOWJxWpXiHnWmU047nvklXl9qaDTQA4DuUmFO7S1z9h0Cu8scrlpBXq7Vu7igXn0Ds583ZL3UGlFTXEBQF72w+xO9Dv0VddEywrEAdH117z5u6h4BtZoovtF10ozw=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(23010399003)(10067099003)(4143699003)(56012099006)(6133799003)(18002099003)(22082099003)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?aVp1MFN6QmJESll3dHg5UkVRVVlCV2NFNDl1TUpsODRFVkk4Q3ZwdVJpWUdx?=
 =?utf-8?B?Q05KV1lLd0dvN1UxM0w2YjZ2aUJ6MVB5eUY0ZCtscEZCNTZYS0U0MGd5S2k0?=
 =?utf-8?B?VnBYdW85UGhCTk5nYlJqdnpGNzRXMnV4VkhudVlwalhUbnExVmdNZno1dWFH?=
 =?utf-8?B?eDNOMFFLUG1QY25McWNsZGVmQXdtVHhsaEN6WGRyNTFDWXBreGllUzM2OXVO?=
 =?utf-8?B?T3FqWGR4SUFIWnhXcGYwalFCTDcyRHNOc2ZzenBOUVpaVG1yTlI0TmU1bTFG?=
 =?utf-8?B?UVYvcU9SbWNTTklGaEI3Nk1ETVVybGlnQjVaV0FtUnlJYzNhWmZDZ3ZhTEtG?=
 =?utf-8?B?Q01CSTVCZWhpQnhNL1h6eWpBQ1htbkd3ZGNPakZOT293RytDK0JSdFI3R0xq?=
 =?utf-8?B?VEVyZXhrUVpYQkgvVWtBM1JEb3EvOGIxL2ZtNW1kN2E4NUR5RTZIa0dpbEN5?=
 =?utf-8?B?RkIzOTBETkp2aVdaNVdyQ0pERmRiaG9pbDcwQzFZeWREQ3ZBV3RLWEcveWYw?=
 =?utf-8?B?ZmxQNjNCY2hNSVgrL2RVdE11clo1cWorNHdSSmh4UWp1NU9SR0kzNW1TQU03?=
 =?utf-8?B?UW1tQXp2Qzd0Q3FPbHJSbFp5cUlnbmV1elZwZ3hUZGhaa24rR1NZUm9ycXY2?=
 =?utf-8?B?OXNsRlh2QkJoUU9Mbm5NbG5rWkJjcGVhUWNjdDRKTVZIM2tReVBDa3Excmgr?=
 =?utf-8?B?RUsxaWlVb0dDWkw0bzQzNVRYTk12VmVHVjZjcjh2bmVJOE9Wa3ArVlNZOVlN?=
 =?utf-8?B?RDVHWFlTNzhRV3hNSHA0bURtWFg2US8vSHQyaVR2cGNXVzg5MVhXdTN0UlEx?=
 =?utf-8?B?QkxPK0RLNnNueTVZM2V3Tkg3WUlTOEJrZ2JwL0xwZ1NXSWw1R1VuYTdyb2tv?=
 =?utf-8?B?YzNFUXVoeGhuUjN4amZONXpsQWdjTmZHL1hiaEtudDNPZFdyNWgvZ3duWDRO?=
 =?utf-8?B?Z0R0RGd6N2M1R1BNN29OQVlCWmxOajcvV3NBNXpKVFVBZDJyQnUvd1NhQ1Yz?=
 =?utf-8?B?bGRKY0NMRGljQnhQUk1jRnJJRTFiUTJyTlFhU1N5NlF6aStiNjFmRDRSM2hQ?=
 =?utf-8?B?NncvbTF6bnB1Z0UxSjRKNFRkNEh1SlpOUHZnaUNPWGh0U2lvS1dWUXBxR0lW?=
 =?utf-8?B?REJWRTNWNWhMZkYzcXBOT05USDV2dml4Q0NRNk5abitaM1ZXQnU1WjNvdGdO?=
 =?utf-8?B?cCtLU2NJU3NVMUVHU09kN3RSTXcyZGVZVVFuaEd6Rm1vTDZudWVrck1PNWRh?=
 =?utf-8?B?OTloZUs1RDhJMFVnNVhqR1B4ckZ3disxc0IvSkVNSFFYYk10Q1dISlZ2NHF5?=
 =?utf-8?B?OWVlTmNsLzJXN1hLcHRPdjdzY21DdnpiZllIME02MUo5eW8vVWZuR2dZN2Zs?=
 =?utf-8?B?aktHQlBHeWhSMDAwTUpqdnpRb29KTnFvei9pcDkrTVZnRFpRdGtJblJCUyt2?=
 =?utf-8?B?SytRSDhYRzhxa2ZFTGtEV29LUDBEWENNSDZwb2x5VEtBNXhVbWIwS2hqcG1F?=
 =?utf-8?B?WklBUW9Ja0ZzZVkzT1lwdGkyUFVKY21hdSthRnZ0Q09ZdHBTS25BaFJMRXht?=
 =?utf-8?B?RjdVWGkwbktCWW1HdkJoYVpqS2kwK1FFMXZEY3B1T1E1UkVJeFo4ZmZXREJW?=
 =?utf-8?B?UHFzQ1RTMEN2L3lJd2tvVkdXcmpKNTZrTjI3aVpPUDd2Q2VFTTZWQ3A1VHg5?=
 =?utf-8?B?ZzBJWmtNanpocnBVZVd0OGJzTXJGTkxDWHZuVytpNjk0L3Bxc25nK1dTMDZG?=
 =?utf-8?B?NUI2Q3NLb0VQVmk0RHFRWURpYWhycXEyS0RzWGhGTGZBNDJ6Uy9pNTBRamZF?=
 =?utf-8?B?NkpuQWszc2RidDl0d3YvY09UclRyaWxDWm5TSUt0eHRoUC9MNkxCR1VDZFgw?=
 =?utf-8?B?dXJRcnNVZ3NTQ2JPdTJ2bEJOMlhYVm9oREVMWEIyTUNNL2NaK1hXRTAyZXJn?=
 =?utf-8?B?OFJuRDd6WXJkNGNIdmozYlNXSm9CcjF5djVYMnFScUUzTEwyRjVlRThhWksr?=
 =?utf-8?B?SXZ6ckVxV3luMG5OME9HdkpIK2ptcVdVVXRuVjBQcE9zK2pDR05LcmxvOXRJ?=
 =?utf-8?B?aUJsZWdsN3JYWVJBR28zVXhHNUVRNThPaERRTVpxRXRwOUVHKytWeGU4K2FW?=
 =?utf-8?B?QXBUNFpRT3ZZVitkMng4MWlwVzBYZStRWlFhWVh1S3ViN1ZhK3AzODMrRm5J?=
 =?utf-8?B?TngzSkxGbldVbUw0Y0FrWGNqNEU0VnJYbHdzOU1BSW8rZmhFS2tiNTdYWDlr?=
 =?utf-8?B?emU3Y2RiUkVLLzhWV1ZIVE0wWWRtWHZ5VU9pYVU0VGZZK1JGdEhzTWowRy9J?=
 =?utf-8?B?TG4wakkyUkxZNTFNN2FHRzlDQVpvOUpNNWNleWc3azNmM0R2VlhVVml0WUw0?=
 =?utf-8?Q?wGjMP46jDnQ50avc=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <59891152A9362E46AB31ACE56BC9D443@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	zH6qHvEvrenPMISgfESdA2U84mLNiRAsgW6krqHDYXlu4YA5hJl8rNqeUSAfIMhY/7WbFI7NCqSG4MZF8tkPbkVedul0gt/ZbZjQT/H8sfzedA5oRw+bJj0ISyQf6CftK2GtA98b+Y1vJpWjx0z0dkr2hnRv4FeXWH3aqTIi4TwKXrthKWgfG0DgpjPMW1yg7cb/NXZ4udgzDa/38kOuCHoBS6xQfk5+CODD1k2Jm6fAjo2WKo//ItYmcgLOZRpvRsJ7g5MHmD3cg29sc7B1nNQCSij304YecQEGjfiq3hjWs3p49M51GX2cjWSajEdOfgmhYqSe+O5wSoe6ZQ8PAQ==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 798b6d47-9e76-4005-c401-08df1b01cf8d
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Sep 2026 12:37:50.0604
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rmwoHVIal5lObiuWIgHqkn2YJX2rrSI2BAENG11HcqKakrNgF2LCQe/dsPBMAaqxVA0v9+6A7fZSTaDDrk/hWaR/ckvFClwHT3p67cHeajk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS6PR02MB343405
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI1MDA1MCBTYWx0ZWRfXyFmlnnDn25ji
 jR28SkwAj143s72KX2vWX1xl0XpRUqDVzQGlav4gk3ln7HK7Z0arZ5ObBTSgw2nV/4BBnfRYuef
 R5f9gpMhq3x/aPySGrkZpAk8DDy9Uj96MEVdRZz1bawDiMhVIj6z8TbsZcuC7My6NigW0kOBEQC
 BU6Ed5QRhZeewxyZkqMSfTO8/Y/AlcHKlcf35FKUk0O+b68+CGqmEKMVEUPe3yj2hQV5iJYaBKL
 sBavJWNN1BafzF4GdKh++9SzgzKF/BuiJm4MEP1yGNec4lmqmag2fbDnF8tZw13wAvpHb4J3FsF
 FpIKMKqTcKRFaWGIxE1o2AduGCkHeL1cjrmu5EJggIeMAlvfHYInIRBND/TtTDKUX4Xt778N8nR
 Mz8lSzF52zsGEnJQrCQV5FkdY1HNeWnqhpK9wEadBicy5tp39Da5trqQzPL6utD2thiD9f659W1
 demjLEjoDBu3lG5QS/Q==
X-Proofpoint-ORIG-GUID: 79LEtxIxUR6Ggc8HkIVog9vRx3WutVxh
X-Authority-Analysis: v=2.4 cv=bvbZl0ai c=1 sm=1 tr=0 ts=6ab66b1f cx=c_pps
 a=/cdxYPoEIjFnUsMTEY5PDA==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VofLwUrZ8Iiv6rRUPXIb:22 a=jxMXjlTPpCISP5mWtjnE:22 a=20KFwNOVAAAA:8
 a=JeFDVx8HkGecG-Bg6g8A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI1MDA1MCBTYWx0ZWRfX3IbacfK77YVR
 E/rz89SMDFxisWqm8JyttGe9+FBuuIMhtPXov6XBLPWcd4PxF7+WvBIZm8qmc8X9g67+cRrXa/G
 9JNmmpSy9afU048zbnF7qBCl1uynF2M=
X-Proofpoint-GUID: 79LEtxIxUR6Ggc8HkIVog9vRx3WutVxh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-25_02,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gMTYgU2VwIDIwMjYsIGF0IDg6MTXigK9QTSwgRXJpYyBBdWdlciA8ZXJpYy5hdWdl
ckByZWRoYXQuY29tPiB3cm90ZToNCj4gDQo+ICEtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tfA0KPiAgQ0FVVElPTjogRXh0
ZXJuYWwgRW1haWwNCj4gDQo+IHwtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tIQ0KPiANCj4gRnJvbTogQ29ybmVsaWEgSHVj
ayA8Y29odWNrQHJlZGhhdC5jb20+DQo+IA0KPiBBZGQgYW4gaGVscGVyIHRvIHJldHJpZXZlIHRo
ZSB3cml0YWJsZSBpZCByZWcgYml0bWFzay4NCnMvYW4vYQ0KPiB0aGVuIHJldHJpZXZlIHRoZSB3
cml0YWJsZV9tYXAgYXJyYXkgYW5kIGRpc3BhdGNoIGl0IGluIHRoZSB3cml0YWJsZV9tYXANCnMv
d3JpdGFibGVfbWFwL3dyaXRhYmxlX21hc2sNCj4gZmllbGRzIG9mIGFybTY0X2lkX3JlZ3NbXSBl
bGVtZW50cy4NCnMvZmllbGRzL2ZpZWxkDQo+IFNpZ25lZC1vZmYtYnk6IEVyaWMgQXVnZXIgPGVy
aWMuYXVnZXJAcmVkaGF0LmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogQ29ybmVsaWEgSHVjayA8Y29o
dWNrQHJlZGhhdC5jb20+DQo+IA0KPiAtLS0NCj4gDQo+IHY3IC0+IHY4DQo+IC0gYWRkZWQga3Zt
X2VuYWJsZWQoKQ0KPiANCj4gdjUgLT4gdjYNCj4gLSB1c2UgYXJtNjRfaWRfcmVnc1tdLndyaXRh
YmxlX21hcA0KPiAtIHNxdWFzaGVkIDIgY29tbWl0cyAoaGVscGVyICsgdXNlcikNCj4gLSByZW1v
dmVkIHN0dWINCj4gLS0tDQo+IHRhcmdldC9hcm0va3ZtLmMgfCA2MSArKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysNCj4gMSBmaWxlIGNoYW5nZWQsIDYxIGlu
c2VydGlvbnMoKykNCj4gDQo+IGRpZmYgLS1naXQgYS90YXJnZXQvYXJtL2t2bS5jIGIvdGFyZ2V0
L2FybS9rdm0uYw0KPiBpbmRleCBlZDk5YmU3ZmQ4Li5jNmVhYzQxOTkxIDEwMDY0NA0KPiAtLS0g
YS90YXJnZXQvYXJtL2t2bS5jDQo+ICsrKyBiL3RhcmdldC9hcm0va3ZtLmMNCj4gQEAgLTI4LDYg
KzI4LDcgQEANCj4gI2luY2x1ZGUgImt2bV9hcm0uaCINCj4gI2luY2x1ZGUgImNwdS5oIg0KPiAj
aW5jbHVkZSAiY3B1LXN5c3JlZ3MuaCINCj4gKyNpbmNsdWRlICJjcHUtaWRyZWdzLmgiDQo+ICNp
bmNsdWRlICJ0cmFjZS5oIg0KPiAjaW5jbHVkZSAiaW50ZXJuYWxzLmgiDQo+ICNpbmNsdWRlICJo
dy9wY2kvcGNpLmgiDQo+IEBAIC01MSw2ICs1Miw3IEBAIGNvbnN0IEtWTUNhcGFiaWxpdHlJbmZv
IGt2bV9hcmNoX3JlcXVpcmVkX2NhcGFiaWxpdGllc1tdID0gew0KPiBzdGF0aWMgYm9vbCBjYXBf
aGFzX21wX3N0YXRlOw0KPiBzdGF0aWMgYm9vbCBjYXBfaGFzX2luamVjdF9zZXJyb3JfZXNyOw0K
PiBzdGF0aWMgYm9vbCBjYXBfaGFzX2luamVjdF9leHRfZGFidDsNCj4gK3N0YXRpYyBib29sIHdy
aXRhYmxlX21hcF9kaXNwYXRjaGVkOw0KPiANCj4gLyoqDQo+ICAqIEFSTUhvc3RDUFVGZWF0dXJl
czogaW5mb3JtYXRpb24gYWJvdXQgdGhlIGhvc3QgQ1BVIChpZGVudGlmaWVkDQo+IEBAIC0yNzMs
NiArMjc1LDIxIEBAIHN0YXRpYyB1aW50MzJfdCBrdm1fYXJtX3N2ZV9nZXRfdmxzKGludCBmZCkN
Cj4gICAgIHJldHVybiB2bHNbMF0gJiBNQUtFXzY0QklUX01BU0soMCwgQVJNX01BWF9WUSk7DQo+
IH0NCj4gDQo+ICtzdGF0aWMgaW50IGt2bV9mZWF0dXJlX2lkeF90b19pZHJlZ3NfaWR4KGludCBr
aWR4KQ0KPiArew0KPiArICAgIGludCBvcDEsIGNybSwgb3AyOw0KPiArICAgIEFSTVN5c1JlZ3Mg
c3lzcmVnOw0KPiArDQo+ICsgICAgb3AxID0ga2lkeCAvIDY0Ow0KPiArICAgIGlmIChvcDEgPT0g
Mikgew0KPiArICAgICAgICBvcDEgPSAzOw0KPiArICAgIH0NCj4gKyAgICBjcm0gPSAoa2lkeCAl
IDY0KSAvIDg7DQo+ICsgICAgb3AyID0ga2lkeCAlIDg7DQo+ICsgICAgc3lzcmVnID0gRU5DT0RF
X0lEX1JFRygzLCBvcDEsIDAsIGNybSwgb3AyKTsNCj4gKyAgICByZXR1cm4gZ2V0X3N5c3JlZ19p
ZHgoc3lzcmVnKTsNCj4gK30NCj4gKw0KPiBzdGF0aWMgdm9pZCBrdm1fYXJtX2dldF9ob3N0X2Nw
dV9mZWF0dXJlcyhBUk1Ib3N0Q1BVRmVhdHVyZXMgKmFoY2YpDQo+IHsNCj4gICAgIC8qIElkZW50
aWZ5IHRoZSBmZWF0dXJlIGJpdHMgY29ycmVzcG9uZGluZyB0byB0aGUgaG9zdCBDUFUsIGFuZA0K
PiBAQCAtNDgwLDkgKzQ5Nyw1MyBAQCBzdGF0aWMgdm9pZCBrdm1fYXJtX2dldF9ob3N0X2NwdV9m
ZWF0dXJlcyhBUk1Ib3N0Q1BVRmVhdHVyZXMgKmFoY2YpDQo+ICAgICBhaGNmLT5mZWF0dXJlcyA9
IGZlYXR1cmVzOw0KPiB9DQo+IA0KPiArc3RhdGljIGludCBrdm1fYXJtX2dldF93cml0YWJsZV9p
ZF9yZWdzKHVpbnQ2NF90ICppZHJlZ21hcCkNCj4gK3sNCj4gKyAgICBpbnQgY2FwX3dyaXRhYmxl
X2lkX3JlZ3M7DQo+ICsgICAgc3RydWN0IHJlZ19tYXNrX3JhbmdlIHJhbmdlID0gew0KPiArICAg
ICAgICAucmFuZ2UgPSBLVk1fQVJNX0ZFQVRVUkVfSURfUkFOR0UsDQo+ICsgICAgICAgIC5yZXNl
cnZlZCA9IHswfSwNCj4gKyAgICAgICAgLmFkZHIgPSAodWludDY0X3QpaWRyZWdtYXAsDQo+ICsg
ICAgfTsNCj4gKw0KPiArICAgIGNhcF93cml0YWJsZV9pZF9yZWdzID0NCj4gKyAgICAgICAga3Zt
X2NoZWNrX2V4dGVuc2lvbihrdm1fc3RhdGUsIEtWTV9DQVBfQVJNX1NVUFBPUlRFRF9SRUdfTUFT
S19SQU5HRVMpOw0KPiArDQo+ICsgICAgaWYgKCFjYXBfd3JpdGFibGVfaWRfcmVncyB8fA0KPiAr
ICAgICAgICAhKGNhcF93cml0YWJsZV9pZF9yZWdzICYgKDEgPDwgS1ZNX0FSTV9GRUFUVVJFX0lE
X1JBTkdFKSkpIHsNCj4gKyAgICAgICAgcmV0dXJuIC1FTk9TWVM7DQo+ICsgICAgfQ0KPiArDQo+
ICsgICAgaWYgKGt2bV92bV9pb2N0bChrdm1fc3RhdGUsIEtWTV9BUk1fR0VUX1JFR19XUklUQUJM
RV9NQVNLUywgJnJhbmdlKSkgew0KPiArICAgICAgICByZXR1cm4gLWVycm5vOw0KPiArICAgIH0N
CkkgdGhpbmsganVzdCBkb2luZyByZXR1cm4ga3ZtX3ZtX2lvY3RsKGt2bV9zdGF0ZSwgS1ZNX0FS
TV9HRVRfUkVHX1dSSVRBQkxFX01BU0tTLCAmcmFuZ2UpIGlzIGVub3VnaC4NCj4gKyAgICByZXR1
cm4gMDsNCj4gK30NCj4gKw0KPiB2b2lkIGt2bV9hcm1fc2V0X2NwdV9mZWF0dXJlc19mcm9tX2hv
c3QoQVJNQ1BVICpjcHUpDQo+IHsNCj4gICAgIENQVUFSTVN0YXRlICplbnYgPSAmY3B1LT5lbnY7
DQo+ICsgICAgdWludDY0X3QgKndyaXRhYmxlX21hcDsNCj4gKw0KPiArICAgIHdyaXRhYmxlX21h
cCA9IGdfbmV3KHVpbnQ2NF90LCBLVk1fQVJNX0ZFQVRVUkVfSURfUkFOR0VfU0laRSk7DQo+ICsN
Cj4gKyAgICBpZiAoa3ZtX2VuYWJsZWQoKSAmJiAhd3JpdGFibGVfbWFwX2Rpc3BhdGNoZWQgJiYN
Cj4gKyAgICAgICAgIWt2bV9hcm1fZ2V0X3dyaXRhYmxlX2lkX3JlZ3Mod3JpdGFibGVfbWFwKSkg
ew0KPiArICAgICAgICBmb3IgKGludCBpID0gMDsgaSA8IEtWTV9BUk1fRkVBVFVSRV9JRF9SQU5H
RV9TSVpFOyBpKyspIHsNCj4gKyAgICAgICAgICAgIHVpbnQ2NF90IG1hc2sgPSB3cml0YWJsZV9t
YXBbaV07DQo+ICsNCj4gKyAgICAgICAgICAgIGlmIChtYXNrKSB7DQo+ICsgICAgICAgICAgICAg
ICAgaW50IGlkeCA9IGt2bV9mZWF0dXJlX2lkeF90b19pZHJlZ3NfaWR4KGkpOw0KPiArDQo+ICsg
ICAgICAgICAgICAgICAgaWYgKGlkeCA8IDAgfHwgaWR4ID4gQVJSQVlfU0laRShhcm02NF9pZF9y
ZWdzKSkgew0KQnVnOiA+PQ0KQWxzbywgdGhpcyBjb25kaXRpb24gd2lsbCBuZXZlciBiZSB0cnVl
LCBhcyBnZXRfc3lzcmVnX2lkeCgpIGFzc2VydHMgb3V0IG9uIGFuIHVua25vd24gSUQgcmVnaXN0
ZXIuIFdoaWNoIHByb2JhYmx5DQpzaG91bGQgbm90IGhhcHBlbi4NCg0KPiArICAgICAgICAgICAg
ICAgICAgICBjb250aW51ZTsNCj4gKyAgICAgICAgICAgICAgICB9DQo+ICsgICAgICAgICAgICAg
ICAgYXJtNjRfaWRfcmVnc1tpZHhdLndyaXRhYmxlX21hc2sgPSBtYXNrOw0KPiArICAgICAgICAg
ICAgfQ0KPiArICAgICAgICB9DQo+ICsgICAgICAgIHdyaXRhYmxlX21hcF9kaXNwYXRjaGVkID0g
dHJ1ZTsNCldoYXQgaXMgdGhlIG5lZWQgb2Ygd3JpdGFibGVfbWFwX2Rpc3BhdGNoZWQsIHdoeSBj
YW7igJl0IHdlIHVzZSBhcm1faG9zdF9jcHVfZmVhdHVyZXMuZHRiX2NvbXBhdGlibGUgYXMgYmVs
b3c/DQoNCldhcm0gUmVnYXJkcywNCktodXNoaXQNCj4gKyAgICB9DQo+ICsgICAgZ19mcmVlKHdy
aXRhYmxlX21hcCk7DQo+IA0KPiAgICAgaWYgKCFhcm1faG9zdF9jcHVfZmVhdHVyZXMuZHRiX2Nv
bXBhdGlibGUpIHsNCj4gICAgICAgICBrdm1fYXJtX2dldF9ob3N0X2NwdV9mZWF0dXJlcygmYXJt
X2hvc3RfY3B1X2ZlYXR1cmVzKTsNCj4gLS0gDQo+IDIuNTMuMA0KPiANCg0K
