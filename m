Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FFE1378D8C
	for <kvmarm@lists.linux.dev>; Mon, 28 Sep 2026 10:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790592260; cv=fail; b=QCVDu82g1x5KpdfkL4g5mGjmN69tHQfAmJ29dUgzEebucXyVEdVCXABl7+LjnOpZ/o/6TrDfJpzjeb0Y6Ul5CisficZ49W70CSCJ8Ob4wwgI8S0ijUxz9nQDS1rwwa0TrXq7Rq9xLJ7RJbomXe1iHOCU9JCboHnwF7vPkjm8LvA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790592260; c=relaxed/simple;
	bh=rWhUuy0+9YRR3nqcZN1EEiYr06xAb+KHkhrVbPrtiKU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=WBcKdqcjmcCDH3gAFcJL5VenrUJRMg9oIxY9rMc5OGQPF2wO0JdkjkBC9xnOS46TlZ3R1ncQMSZDR1d+iuFNdrpcy9whLFyT3ma981uGjtI1dZ7S8qTYfGtCB6Jm/W2z1mOH8Bg9coepQaSNXbMg5qLvFJAM3U6JnJnYWC2jraU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=c8ltu8Aw; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=FqAuEi1h; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="c8ltu8Aw";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="FqAuEi1h"
Received: from pps.filterd (m0127839.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68S9Kg8Z1142565;
	Mon, 28 Sep 2026 03:44:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=rWhUuy0+9YRR3nqcZN1EEiYr06xAb+KHkhrVbPrti
	KU=; b=c8ltu8AwAXdvthnlF9viTFE93x35ZFzGJK0P221A1mti/Bo0VShDSZgca
	MfW+Eh0Qb6fc1rNu63FbeMX+s3I0hw7+6cdkisZ7RyaQOyOkFSC+K4OE9ixJVpQx
	14bfAdCXOryqkSyk5j/zYkC6HlSIbdlyj4opZfj9NTm9Y073Q1FFlNYKDS69eIyt
	yKL7gc+Tzl3NhqYNP0W11Y4h//hFIVu2R0SS/5pD8UBrBt5xN1185UhR3z4yvtKg
	yVZfirgG7TCyGtekOkGBLRc4sM4rU9UXcRvLuUuufh7jfIl/BXImemLvNPclQJhv
	xPODoEH0Ge9KozrBwkOz+mBqYeoBg==
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11022086.outbound.protection.outlook.com [40.107.200.86])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 4gxd4ekfg9-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 28 Sep 2026 03:44:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=g1gHRNJFmM842ZCl+AThNhr5lrIL7eYxWEFv1bQ6Fdc26GFPq4aOwY/r2g1XTsE8NUotVlDgL1Dt3gwxiOaLei+D/ggulQ/j4m3DFV7tItptpxVewVbwAjqm0SquyU69xOa7o5iKahEAYKdAa0ebnYg/5tG0PNFr2uXZnjH8AbtdISWCDmo37h6x1XRiieNxRH/lLshrOZHfLMdbBod8auc1qAD7SGzZdlSjx/jSu+2Zb0IvLFL/QsubhK6vyp94FaVXMUC8KJcanklRgpv2Gh0YslK5lT1tT0alecwa8kuYc+N+vE+oKPD3FMhzdIgi4lUGgFD23Buqd8DfaWRnEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rWhUuy0+9YRR3nqcZN1EEiYr06xAb+KHkhrVbPrtiKU=;
 b=eYxpsyVNuUkCU/4cWcyKdMgwAMsrQfvLw8ognBA5niIMYfpWxYskFjaHz3RkrEGwyxUbiI8FOWyg4e9xezUfjUaBzeq9uQJQMYGdilWuVwGJkLwzI39CX8K7Fvjfw8YP8s740CO1lR75oZ6j1sTHcpddNk0s2oD4OpOt/ixtTVEHgf8eWkVt2KxUgoxmR6j617IunV/BiK+v4A5qn0E8+XEidqB8VG4gGzoBLLLEFKXRYheKGydu47DirkDAzrqgfHBkkDLqxXdYkar1IDH3B0gMeGaYWWBtG+JgHqISnPCMoMR6CtuwNXYcIt1UuOjagaQ7NCmX0Wr0+F/bHJgTBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rWhUuy0+9YRR3nqcZN1EEiYr06xAb+KHkhrVbPrtiKU=;
 b=FqAuEi1hAWt5fqFhEEymoaDJgM/0lT3A53h/+x2xaRAzCfnSoiJMj4Sqw5Ts7PRikpBfgwr370Awu7NQdvJbxZmlPoBgNIBA3grt4ha+CH5bdZM2cGiGjI/uTeGA6kfV819z8LDZmHM1KdjSql32Uh9qntzd1jk2uJpGVgsPmjgRbNh6YQlMawgTpdoykjH77099G2csm3tqR+2pEKjslLhyUYBU4hbYX1n4lNks3DH2N5ZGXpRke+QsPn6PpoRpYJR/FohiASwxSgeEO0AqT9kTqu01dLHFXZ6AM6Z19brRcgLgeYaFYpk42fA1GT9I7FnpMhGs1hWURvr5tcik6w==
Received: from PH0PR02MB7557.namprd02.prod.outlook.com (2603:10b6:510:54::17)
 by BL0PR02MB6515.namprd02.prod.outlook.com (2603:10b6:208:17e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.24; Mon, 28 Sep
 2026 10:44:00 +0000
Received: from PH0PR02MB7557.namprd02.prod.outlook.com
 ([fe80::4917:bc05:4373:6bef]) by PH0PR02MB7557.namprd02.prod.outlook.com
 ([fe80::4917:bc05:4373:6bef%4]) with mapi id 15.21.0451.022; Mon, 28 Sep 2026
 10:44:00 +0000
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
Subject: Re: [PATCH v9 16/26] target/arm/kvm: Apply SYSREG props to the final
 vcpu
Thread-Topic: [PATCH v9 16/26] target/arm/kvm: Apply SYSREG props to the final
 vcpu
Thread-Index: AQHdTzZFoY+MOIL5Y026FZAo6poQew==
Date: Mon, 28 Sep 2026 10:44:00 +0000
Message-ID: <8F110441-6D38-4134-9196-76AFA021250F@nutanix.com>
References: <20260916144721.751810-1-eric.auger@redhat.com>
 <20260916144721.751810-17-eric.auger@redhat.com>
In-Reply-To: <20260916144721.751810-17-eric.auger@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nutanix.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR02MB7557:EE_|BL0PR02MB6515:EE_
x-ms-office365-filtering-correlation-id: d91142a4-9f6f-4f30-3456-08df1d4d6809
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|23010399003|1800799024|376014|7416014|366016|10067099003|3023799007|56012099006|18002099003|22082099003|4143699003|38070700021;
x-microsoft-antispam-message-info:
 tAXGqDL52m3UoLMp+AoXYcwrsAd2G0asBxgmhQKWrEoo+14U7gjfXzRQMRkxGeh/oEytcneo8fiT7DAMViMnZzAiGLCMZXvpxRh9nYHRqGut8mzjt+MrF6TH5XEfbClscW3OT6aYTNbYB7oWUn320L42nSzD7u9PHKtUwFjhFNoq5hMgG0yRBYVjW4q/TSpMf7EIAh4x6CFkQ4puJ09DuYZVf0b9hHVakC+/CouVwQrsiOnZYtSUv2Q9nS25QWmkMx0xRln7NhuG6F6rORYKG6L50INb4DWC7Xnv3fmTAhT8DAxg1int9II4zT/6I64MCW0D8x16VjyxxhhXSVuHx8HvJQedjeloMEO1+Se7EadMjHzy+nUEHt60olK4+5scFpxhc6m8udK4GEdzHcl1jlb8EEP1QdNMbb9QKFocVcLHBSJx7MNgl8saBni4ja+WW8T0gid2//eLIGEmYPPr1PyBuyftSBnmyiXnJZH9Xv1aX3UWFYv1rVqgzEVrZl/KJuiJBW0o8/0TcUj03Q5/szC/xOoSpYSVyMB2JBvQYOR6v10jA1hLL5Lc5N/XhMfTNy9zqdhAedNoknH06pD6EeTTaAxmSBfo9HAg5kO2W8erHtDQ5yke6acZ3G56EEguSe1HkfmCSWCXBB2x04VvZgrZSBSSBPEeyq1f1VcDY6IVi6n8O9PYBhliO0Hxno5zwq+qTdSj1QehaOpg7wxfEhTx19Jog9RhZuSnu6BD1pw=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR02MB7557.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(7416014)(366016)(10067099003)(3023799007)(56012099006)(18002099003)(22082099003)(4143699003)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?K09CVktOTXVzYnZ1VHJvOHBqOXRVWXdXNDI3bHVaTTdFZk1LUGxXSkx0WVlL?=
 =?utf-8?B?eGplYzdDd3hYdHpsUkZIS1RIQUQ1NDlvRUY3NzkwTkwvYkFEb2c0Z0RvN0hm?=
 =?utf-8?B?OUVGOE9Gbktvd0Q3SHdrVzlvdnEzQ1A3MlN0NHAyY0hOQlRpMkdPR2NaTUdQ?=
 =?utf-8?B?RFM2dHZ5YVdvdEhOODBnR21XL0o1dGJnR29FODROb1RjK2o2ZCs1KzlHV1Ay?=
 =?utf-8?B?eDdKSFpqdk4rKzFOM3g5eHhFSFJHTm8vbjZzUTQ5RlZONTNqb3RHT3Z0WE9s?=
 =?utf-8?B?aDJHdzUxVUszbVZiTm9IVVdGRUdqMk5WY1JsNkJGZ1NPa1g3VFZXZUR2RVVl?=
 =?utf-8?B?TFk5UGdiR1Nhd3dmdXE0ODVGODdlTzBVRzYvSzU3UEp0WXB1cU9kOTYvbFps?=
 =?utf-8?B?RVRST1dqWFBTOGl0K0NhY2J5QS9DRDRJSmZQQ0hld0J2UDE5bnIzeGE5L2N4?=
 =?utf-8?B?dGZad1dUcy80OGZMUkdYUWRhTndKWElZNnRwUVhlOUtySUs2VURlRjBqbGZY?=
 =?utf-8?B?UFB6ai9wYkF4dDJmaDdCakdDcVFGckRDNllINEhySWh3MTExWjdqSWRIRHp6?=
 =?utf-8?B?NjN2SlNGZGNQcDBvclVQSnREanJHd2kvQ2FVbTBERlBmVVpiOTlPYVliRStI?=
 =?utf-8?B?djV3ZG1JU1MyRitYemxwR1FjM1A5ZHJ3dnFBTlpPd3p5bWZ0d0hqc3dyMHlW?=
 =?utf-8?B?RURHZWJlMkF5aGRzOTVSa0VJTFAzRmcvUlZPZzZoQmh4SHZRMnFEais5RnBQ?=
 =?utf-8?B?bDZreVRQRFBuVEtZSU9jNk9aQ1pLQ01lekxJazBReVl3MEpOWEl4a0N0UktL?=
 =?utf-8?B?UlBzTkxsYkdyTE9ZNTZnbFREMFR6UnFsc1BPVytzV01ieDRoc1B6K2pSM2tU?=
 =?utf-8?B?bDJwUmg5Q1JMKzBMYXNsRGRQbVNtYWNxYmVXNlRyb0xtQllGQlFwNEYxTXJO?=
 =?utf-8?B?QjVLVG1xMTh6bGtIMktYSllCYjh1K25jSXR5U1BDTzlMbGVRbW9CU1MrMmNB?=
 =?utf-8?B?QTJvOEZVK3RhWklQdi96cUtxMDI4SXZvWm13UDRiaGdHVFlWWnhUOHd4ditG?=
 =?utf-8?B?WlptRmZjRTBXWkp3YmRDeWpjTERPYVQ2a3RhVzRtSlBUVUpaZ1RGT1lwSXhH?=
 =?utf-8?B?UDhydEYrNTEyT2NyWTlWTHIvclRacmUxUlNQUlRLM3JvWkFxTTVtTlk1Wm5E?=
 =?utf-8?B?UVZ5VHBzRjEzOEZKeVRZaTRjeGw0a0NmMzhhSTB3RTdrMVdLczNLd0QzVFJD?=
 =?utf-8?B?eWcxcGFCclZzOUtFeWRpQmhaUVJxRmxSSGdPc3I2SkM0N0dIRmhWYmRUUmpZ?=
 =?utf-8?B?NzRaVlRRZHBUWlk2KzcwT3RFdjlHZWgvclRzZkMvMmRzT1pwTmcrWU1wVXNS?=
 =?utf-8?B?akRqM0FYMSt6SkEwQ0R5NjlyWDdmeGV0ZTN3alFNY04xV1lTM2cyREdoc1p3?=
 =?utf-8?B?L0JLZFFhOHV6enk5dVZQM0dqMFFFRFh5MW84aW5PRGlJRjNEM0tJVFYrUnBE?=
 =?utf-8?B?RHg2NUlGcThlKzNpQStDRGxHYVZydGtXSzJRMWdxWk5wWmp6L1V0bW8yK1Ri?=
 =?utf-8?B?ZGxyS3c4eUhjZEgreHRKUXo1OXNSZEdKeWxFRFJwUzdFN0NZNEJXdlcyblJi?=
 =?utf-8?B?UHk2aDRGM285cVVxQlA3Q1cyK0c5WC9HUVJvLzI4WDZUMUhVMmtld2RrN1pU?=
 =?utf-8?B?SFlobGt6TUEwSmV0UUFaQnJkeDR2RCtTakpMMFVCS0M3MEFTcTFpYnVzZzYw?=
 =?utf-8?B?OUh0UzNCaFRHVGdOVC9vaHlqZFpGYTB3UUZ0aUhFQU9jR1lPUDVJQys5bVkr?=
 =?utf-8?B?UDhxNmJYQkFEUGNNamZmY0c5WmxEMkxDbEVBT1pyL210c2dvdy9DK2pCak9C?=
 =?utf-8?B?SVNGQlRzUGg2VnZUb0xqc3lvcVZsWFRlYjFnemQ2dGRpQXJaU3pCeWp2MldG?=
 =?utf-8?B?UDEwUFpnd1hHRkhibk1qQ2k2bzBieDJFTWh3bU14U2xBYnluNzJYZmE5c21K?=
 =?utf-8?B?VHkyWHlPQStZc2g5a2dKa1VpWDBseS9jV1FwOUZOaXFHbGo1S0FKQmN5VzBS?=
 =?utf-8?B?dXlDZ0hXenBuaDd2L09ybDlvU0Rkcmh5RGE3cUlqRksrcmFIbGVjU040TUkz?=
 =?utf-8?B?b3NRZldtaVY4Rks2cTNKZnhWaG1iZlUwRFhYdUR6ZUFxallrSTI4T1EzSnhj?=
 =?utf-8?B?V29KeFpaZUR1YTVsU0lFVU4xWG9MdjVVUUk3SWxqb2Rsc0hzemd5WVhXZFZK?=
 =?utf-8?B?OVMwb0xLOE5hVjNteTNrS1NRUjRRcmI3Wmk5NTJUeEF0ZVZta3ovQlpkNHVG?=
 =?utf-8?B?d011SHJaSlFUOFFieGdvRjhjYys2SjJwWjQ1emNLOWNmOUFPcUUwN2dMckJB?=
 =?utf-8?Q?6R6A5nJ5zpZBOftg=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C41B98DC81CC83498D20F2AABF5AA7BF@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	27HIlf2mocwPH+RtXKfwcJBzIEq8V6izigUp6FH1YgZ+WZV78YoSm1bI9lYxQIS/gmoT3wctMCZn1L1UPb7AzIslBzQEweMAHe3xymtjnT3e0LTA9X7ROa5XwtBDLHYZawSa8deJALU+q7jLwteIvVQ/PSHE/YNXiUtb2DhOAiIqTZpNjATaqjEVedCRfxwNBB/KJGhmjcZS5oOd3U9c1VtQOPLfWlPa5B9MSmcJa48kZsxuVxWcRKAj+AQXZf5MKtY90zlM+EgmFVlW0lHflRPITqtnfAstDMiGWtz8SsRgEMe2jb7eSwlH9i5IfndoKF0RCc8vhuM43pRRZ7MfLQ==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR02MB7557.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d91142a4-9f6f-4f30-3456-08df1d4d6809
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Sep 2026 10:44:00.4706
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qvr3Ryv50N8i7sCRW/LNv9EPaVO4HlH0I7i++t7QHwoDiNEt4FA6i7OWfznPdhX7EdsSYd0Ro8vL6JaLo8ZAAfJrSKVQO1PpN+bMXcWhtoE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR02MB6515
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI4MDA0MiBTYWx0ZWRfX6bkMMZn6YEtq
 SXDky9LKaAzP/5Z+w/8RQUzFH5Axdim7vgPhXJwpzdcAzN7WNR5XHzj5KZs2nA9Xv3DS2ItYSHY
 nCeP1NeIW9Fs6Q3kPnWSDI9ACAotPFg=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI4MDA0MiBTYWx0ZWRfX4i4ZHOedA+0z
 QynMWPLYI9mTAGBZU5fyTemAI6ij5tsIG7T+M3zaGqjGE4QNUn8mlUIgAxI5fJr3YFfSX/5zkv4
 ol4XjzgW6bnf/DYJXhj2n16FxGsR+XzsSDY2Bt+625xU8R68geqvI6H86q157JmUpuhOQws3tD1
 D1D3N38nqYasbPPSDlrDq728K/ElS3GmH1SE3XTrMJ1xCi1DD+PZyyVjzaGHYRoDSekuewe+QTU
 kvghnsClsW/QXeh3I2POqlUxCo+SiGiooxCpGw/YnOu4O1+cKKgZvt+LRrZIu5mo34+PgVl/Jq+
 5bab7Q1f2n64ceapp99u8GaUkSKRE6LFWXbN2XWblVsiJuFPBDHPuyyKIjd0Le/Yg+OHH8WTIwO
 IQeetXyKKWDVXWg9P/NQWm8s+ZAGFpq19fdA5wJdS6LJVRok/rZHzm6CFRGV0cbxvMet9uEKJp2
 gfmKEFq/d9gQ+VNqq4A==
X-Authority-Analysis: v=2.4 cv=SqMFe/O0 c=1 sm=1 tr=0 ts=6aba44f2 cx=c_pps
 a=9PhP5jdPzEAvW1dfnTQ6sQ==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VofLwUrZ8Iiv6rRUPXIb:22 a=y4UcunY2MAxhM4LwGdWI:22 a=20KFwNOVAAAA:8
 a=2xvLi6Oc0WyZS3UoGWkA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: -RjU84ZmSBVcnZDNUqZOgkWPfmPYrfIR
X-Proofpoint-GUID: -RjU84ZmSBVcnZDNUqZOgkWPfmPYrfIR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-28_02,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gMTYgU2VwIDIwMjYsIGF0IDg6MTXigK9QTSwgRXJpYyBBdWdlciA8ZXJpYy5hdWdl
ckByZWRoYXQuY29tPiB3cm90ZToNCj4gDQo+ICEtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tfA0KPiAgQ0FVVElPTjogRXh0
ZXJuYWwgRW1haWwNCj4gDQo+IHwtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tIQ0KPiANCj4gU1lTUkVHIHByb3Agc2V0dGlu
Z3Mgd2VyZSByZWNvcmRlZCBpbiBhIGhhc2h0YWJsZSBidXQgdGhleQ0KPiBhcmUgbm90IHlldCBp
bmplY3RlZCBvbiBndWVzdC4gSXRlcmF0ZSBvdmVyIGFsbCBzZXQgZmllbGRzIGFuZA0KPiBhcHBs
eSB0aGUgbmV3IHZhbHVlIHRocm91Z2ggS1ZNX1NFVF9PTkVfUkVHLiBUaGUgbmV3IGZpZWxkDQo+
IHZhbHVlIG92ZXJyaWRlcyB0aGUgY3VycmVudCBvYnNlcnZhYmxlIHZjcHUgcmVnaXN0ZXIgdmFs
dWUuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBFcmljIEF1Z2VyIDxlcmljLmF1Z2VyQHJlZGhhdC5j
b20+DQoNCldpdGggdGhpcywgSSBzdXBwb3NlLCB3aGF0IG5hbWVkIG1vZGVscyB3aWxsIGRvIGlz
IGRpcmVjdGx5IHdyaXRlIHRvDQpJRCByZWdpc3RlciBzdGF0ZSwgQXMgaXQgYWxzbyBkZWZpbmVz
IHN0YXRlIHdoaWNoIGFmZmVjdHMgdkNQVSBpbml0IGZsYWdzIGFsc28uDQoNCj4gLS0tDQo+IHRh
cmdldC9hcm0va3ZtLmMgICAgICAgIHwgNjUgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysNCj4gdGFyZ2V0L2FybS90cmFjZS1ldmVudHMgfCAgMSArDQo+IDIgZmlsZXMg
Y2hhbmdlZCwgNjYgaW5zZXJ0aW9ucygrKQ0KPiANCj4gZGlmZiAtLWdpdCBhL3RhcmdldC9hcm0v
a3ZtLmMgYi90YXJnZXQvYXJtL2t2bS5jDQo+IGluZGV4IDNlYzI2MThjYzEuLmRkZjMyMGQwZTYg
MTAwNjQ0DQo+IC0tLSBhL3RhcmdldC9hcm0va3ZtLmMNCj4gKysrIGIvdGFyZ2V0L2FybS9rdm0u
Yw0KPiBAQCAtMzQzLDYgKzM0Myw5IEBAIHN0YXRpYyBBUk02NFN5c1JlZ0ZpZWxkICpnZXRfZmll
bGQoaW50IGksIEFSTTY0U3lzUmVnICpyZWcpDQo+ICNkZWZpbmUgTUFLRV9JRFJFR19LRVkocmVn
X2lkeCwgZmllbGRfc2hpZnQpIFwNCj4gICAgICgoKHVpbnQ2NF90KShyZWdfaWR4KSA8PCA4KSB8
ICgodWludDY0X3QpKGZpZWxkX3NoaWZ0KSAmIDB4RkYpKQ0KPiANCj4gKyNkZWZpbmUgS0VZX1RP
X1JFR19JRFgoa2V5KSAgICAgKCh1aW50MzJfdCkoKCh1aW50NjRfdCkoa2V5KSkgPj4gOCkpDQo+
ICsjZGVmaW5lIEtFWV9UT19TSElGVChrZXkpICAgICAgICgodWludDhfdCkoKCh1aW50NjRfdCko
a2V5KSkgJiAweEZGKSkNCj4gKw0KPiBzdGF0aWMgdm9pZCBzZXRfc3lzcmVnX3Byb3AoT2JqZWN0
ICpvYmosIFZpc2l0b3IgKnYsDQo+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICBjb25zdCBj
aGFyICpuYW1lLCB2b2lkICpvcGFxdWUsDQo+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICBF
cnJvciAqKmVycnApDQo+IEBAIC0yMjE1LDYgKzIyMTgsNjMgQEAgaW50IGt2bV9hcmNoX3ByZV9j
cmVhdGVfdmNwdShDUFVTdGF0ZSAqY3B1LCBFcnJvciAqKmVycnApDQo+ICAgICByZXR1cm4gMDsN
Cj4gfQ0KPiANCj4gK3N0YXRpYyBpbnQga3ZtX2FybV9hcHBseV9zeXNyZWdfcHJvcHMoQVJNQ1BV
ICpjcHUsIEVycm9yICoqZXJycCkNCj4gK3sNCj4gKyAgICB1aW50NjRfdCAqaWRyZWdzID0gY3B1
LT5pc2FyLmlkcmVnczsNCj4gKyAgICBncG9pbnRlciBrZXlfcHRyLCB2YWx1ZV9wdHI7DQo+ICsg
ICAgQ1BVU3RhdGUgKmNzID0gQ1BVKGNwdSk7DQo+ICsgICAgR0hhc2hUYWJsZUl0ZXIgaXRlcjsN
Cj4gKw0KPiArICAgIGdfaGFzaF90YWJsZV9pdGVyX2luaXQoJml0ZXIsIGNwdS0+c3lzcmVnX3By
b3BzKTsNCj4gKw0KPiArICAgIHdoaWxlIChnX2hhc2hfdGFibGVfaXRlcl9uZXh0KCZpdGVyLCAm
a2V5X3B0ciwgJnZhbHVlX3B0cikpIHsNCj4gKyAgICAgICAgdWludDY0X3Qga2V5ID0gKHVpbnQ2
NF90KWtleV9wdHI7DQo+ICsgICAgICAgIHVpbnQ2NF90IHZhbHVlID0gKHVpbnQ2NF90KXZhbHVl
X3B0cjsNCj4gKyAgICAgICAgdWludDMyX3QgcmVnX2lkeCA9IEtFWV9UT19SRUdfSURYKGtleSk7
DQo+ICsgICAgICAgIHVpbnQ4X3QgbG93ZXIgICAgPSBLRVlfVE9fU0hJRlQoa2V5KTsNCj4gKyAg
ICAgICAgQVJNNjRTeXNSZWcgKnJlZyA9ICZhcm02NF9pZF9yZWdzW3JlZ19pZHhdOw0KPiArICAg
ICAgICBzdHJ1Y3Qga3ZtX29uZV9yZWcga3ZtX3JlZzsNCj4gKyAgICAgICAgdWludDY0X3QgY3Vy
cmVudCwgb2xkLCBtYXNrOw0KPiArICAgICAgICB1aW50NjRfdCBrdm1faWR4Ow0KPiArICAgICAg
ICBBUk02NFN5c1JlZ0ZpZWxkICpmaWVsZCA9IGdldF9maWVsZChsb3dlciwgcmVnKTsNCj4gKyAg
ICAgICAgaW50IGxlbmd0aCA9IGZpZWxkLT5sZW5ndGg7DQo+ICsgICAgICAgIHVpbnQ2NF90IG9s
ZGZ2Ow0KPiArICAgICAgICBpbnQgcmV0Ow0KPiArDQo+ICsgICAgICAgIG1hc2sgPSBNQUtFXzY0
QklUX01BU0sobG93ZXIsIGxlbmd0aCk7DQo+ICsgICAgICAgIHZhbHVlID0gdmFsdWUgPDwgbG93
ZXI7DQo+ICsNCj4gKyAgICAgICAgb2xkID0gaWRyZWdzW3JlZ19pZHhdOw0KPiArDQo+ICsgICAg
ICAgIGt2bV9pZHggPSBpZHJlZ3Nfc3lzcmVnX3RvX2t2bV9yZWcoaWRfcmVnaXN0ZXJfc3lzcmVn
W3JlZ19pZHhdKTsNCj4gKyAgICAgICAgcmV0ID0gcmVhZF9zeXNfcmVnNjQoY3MtPmt2bV9mZCwg
JmN1cnJlbnQsIGt2bV9pZHgpOw0KPiArICAgICAgICBpZiAocmV0KSB7DQo+ICsgICAgICAgICAg
ICBlcnJvcl9zZXRnKGVycnAsICJmYWlsZWQgdG8gcmVhZCB0aGUgY3VycmVudCB2YWx1ZSBvZiAl
cyIsDQo+ICsgICAgICAgICAgICAgICAgICAgICAgIHJlZy0+bmFtZSk7DQo+ICsgICAgICAgICAg
ICByZXR1cm4gcmV0Ow0KPiArICAgICAgICB9DQo+ICsgICAgICAgIG9sZGZ2ID0gKGN1cnJlbnQg
JiBtYXNrKSA+PiBsb3dlcjsNCj4gKw0KPiArICAgICAgICBpZHJlZ3NbcmVnX2lkeF0gPSBjdXJy
ZW50ICYgfm1hc2s7DQo+ICsgICAgICAgIGlkcmVnc1tyZWdfaWR4XSB8PSB2YWx1ZTsNCj4gKyAg
ICAgICAga3ZtX3JlZy5pZCA9IGt2bV9pZHg7DQo+ICsgICAgICAgIGt2bV9yZWcuYWRkciA9ICh1
aW50cHRyX3QpJmlkcmVnc1tyZWdfaWR4XTsNCj4gKw0KV2UgY2FuIGlnbm9yZSB0aGlzIGlmIHZh
bHVlID09IG9sZCB2YWx1ZQ0KDQo+ICsgICAgICAgIHJldCA9IGlvY3RsKGNzLT5rdm1fZmQsIEtW
TV9TRVRfT05FX1JFRywgJmt2bV9yZWcpOw0KPiArICAgICAgICBpZiAocmV0KSB7DQo+ICsgICAg
ICAgICAgICBlcnJvcl9zZXRnKGVycnAsICJmYWlsZWQgdG8gYXBwbHkgbmV3IHZhbHVlIDB4JSJQ
Ukl4NjQiIGZvciBmaWVsZCAlcy4lcyAiDQo+ICsgICAgICAgICAgICAgICAgICAgICAgICIocHJl
dmlvdXMgaXMgMHglIlBSSXg2NCIpOiAlbSIsIGlkcmVnc1tyZWdfaWR4XSwNCj4gKyAgICAgICAg
ICAgICAgICAgICAgICAgcmVnLT5uYW1lLCBmaWVsZC0+bmFtZSwgb2xkZnYpOw0KPiArICAgICAg
ICAgICAgcmV0dXJuIHJldDsNCj4gKyAgICAgICAgfQ0KPiArDQo+ICsgICAgICAgIHRyYWNlX2Fw
cGx5X3N5c3JlZ19wcm9wKHJlZy0+bmFtZSwgZmllbGQtPm5hbWUsIG9sZCwgY3VycmVudCwNCj4g
KyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgbWFzaywgdmFsdWUsIGlkcmVnc1tyZWdf
aWR4XSk7DQo+ICsgICAgfQ0KPiArICAgIHJldHVybiAwOw0KPiArfQ0KPiArDQo+IGludCBrdm1f
YXJjaF9pbml0X3ZjcHUoQ1BVU3RhdGUgKmNzLCBFcnJvciAqKmVycnApDQo+IHsNCj4gICAgIGlu
dCByZXQ7DQo+IEBAIC0yMzE1LDYgKzIzNzUsMTEgQEAgaW50IGt2bV9hcmNoX2luaXRfdmNwdShD
UFVTdGF0ZSAqY3MsIEVycm9yICoqZXJycCkNCj4gICAgIH0NCj4gICAgIGNwdS0+bXBfYWZmaW5p
dHkgPSBtcGlkciAmIEFSTTY0X0FGRklOSVRZX01BU0s7DQo+IA0KPiArICAgIHJldCA9IGt2bV9h
cm1fYXBwbHlfc3lzcmVnX3Byb3BzKGNwdSwgZXJycCk7DQo+ICsgICAgaWYgKHJldCkgew0KPiAr
ICAgICAgICByZXR1cm4gcmV0Ow0KPiArICAgIH0NCj4gKw0KVGhpcyBzaG91bGQgYWxzbyBoYXBw
ZW4gb24gdkNQVSByZXNldC4NCg0KT3ZlcmFsbCwgSSBsaWtlIHRoaXMgYXBwcm9hY2ggYXMgaWYg
dGhlIHVzZXIgZG9lcyBub3QgcHJvdmlkZSBhbnkgcHJvcGVydHkgb3ZlcnJpZGVzLCBpdCBzaG91
bGQgYmVoYXZlIHRoZSBzYW1lIGFzIG9sZGVyIGJ1aWxkcy4NCg0KV2FybSBSZWdhcmRzLA0KS2h1
c2hpdA0KPiAgICAgcmV0dXJuIGt2bV9hcm1faW5pdF9jcHJlZ19saXN0KGNwdSk7DQo+IH0NCj4g
DQo+IGRpZmYgLS1naXQgYS90YXJnZXQvYXJtL3RyYWNlLWV2ZW50cyBiL3RhcmdldC9hcm0vdHJh
Y2UtZXZlbnRzDQo+IGluZGV4IGQ3MmFkNmI2NzEuLmI0ZDJiNDVhN2QgMTAwNjQ0DQo+IC0tLSBh
L3RhcmdldC9hcm0vdHJhY2UtZXZlbnRzDQo+ICsrKyBiL3RhcmdldC9hcm0vdHJhY2UtZXZlbnRz
DQo+IEBAIC0xOCw2ICsxOCw3IEBAIGt2bV9hcm1fd3JpdGFibGVfaWRyZWdzX3RvX2NwcmVnX2xp
c3QoY29uc3QgY2hhciAqbmFtZSwgdWludDY0X3QgcHJldmlvdXMsIHVpbnQ2DQo+IGRlY29kZV9p
ZHJlZ193cml0ZW1hcChjb25zdCBjaGFyKiBuYW1lLCBpbnQgbG93ZXIsIGludCB1cHBlciwgY2hh
ciAqcHJvcF9uYW1lKSAiJXMgWyVkOiVkXSBpcyB3cml0YWJsZSAocHJvcCAlcykiDQo+IGdldF9z
eXNyZWdfcHJvcChjb25zdCBjaGFyICpuYW1lLCB1aW50NjRfdCB2YWx1ZSkgIiVzIDB4JSJQUkl4
NjQNCj4gc2V0X3N5c3JlZ19wcm9wKGNvbnN0IGNoYXIgKm5hbWUsIHVpbnQ2NF90IG9sZCwgdWlu
dDY0X3QgbWFzaywgdWludDY0X3QgZmllbGRfdmFsdWUsIHVpbnQ2NF90IG5ldykgIiVzIG9sZCBy
ZWcgdmFsdWU9MHglIlBSSXg2NCIgbWFzaz0weCUiUFJJeDY0IiBuZXcgZmllbGQgdmFsdWU9MHgl
IlBSSXg2NCIgbmV3IHJlZyB2YWx1ZT0weCUiUFJJeDY0DQo+ICthcHBseV9zeXNyZWdfcHJvcChj
b25zdCBjaGFyICpyZWdfbmFtZSwgY29uc3QgY2hhciAqZmllbGRfbmFtZSwgdWludDY0X3Qgb2xk
LCB1aW50NjRfdCBjdXJyZW50LCB1aW50NjRfdCBtYXNrLCB1aW50NjRfdCBmaWVsZF92YWx1ZSwg
dWludDY0X3QgbmV3KSAiJXMuJXMgb2xkPTB4JSJQUkl4NjQiIGN1cnJlbnQ9MHglIlBSSXg2NCIg
bWFzaz0weCUiUFJJeDY0IiBuZXcgZmllbGQgdmFsdWU9MHglIlBSSXg2NCIgbmV3PTB4JSJQUkl4
NjQNCj4gbmJfc3lzcmVnX3Byb3BzKGNvbnN0IGNoYXIgKm5hbWUsIGludCBjb3VudCkgIiVzOiAl
ZCBTWVNSRUcgcHJvcGVydGllcyINCj4gDQo+ICMgY3B1LmMNCj4gLS0gDQo+IDIuNTMuMA0KPiAN
Cg0K
